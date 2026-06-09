#!/usr/bin/env python3
"""
sync-ragflow-auth.py
从 ragflow 容器读取当前 RSA 公钥，加密密码后更新 gaisoft DB。
部署/重建 ragflow 容器后自动执行（集成在 start.sh / start.ps1 中）。

零依赖：加密操作在 ragflow 容器内完成，宿主机只需 docker + mysql 客户端。

用法:
  python3 docker/scripts/sync-ragflow-auth.py
"""

import subprocess
import sys
import os


def docker_exec(container, cmd):
    """在容器内执行命令，返回 stdout"""
    result = subprocess.run(
        ["docker", "exec", container, "bash", "-c", cmd],
        capture_output=True, text=True, timeout=30
    )
    if result.returncode != 0:
        print(f"ERROR: docker exec {container}: {result.stderr.strip()}")
        sys.exit(1)
    return result.stdout.strip()


def wait_for_container(container, max_wait=60):
    """等待容器就绪"""
    import time
    for i in range(max_wait // 3):
        result = subprocess.run(
            ["docker", "exec", container, "echo", "ok"],
            capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            return True
        time.sleep(3)
    return False


def encrypt_in_container(ragflow_container, plaintext_password):
    """在 ragflow 容器内用 Python 加密密码（容器内有 pycryptodome）"""
    # 把明文密码 base64 编码后传入容器，避免 shell 转义问题
    import base64
    b64_pass = base64.b64encode(plaintext_password.encode()).decode()

    cmd = f'''python3 -c "
import base64
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5

with open('/ragflow/conf/public.pem') as f:
    pub_key = RSA.importKey(f.read())

cipher = PKCS1_v1_5.new(pub_key)
plaintext = base64.b64decode('{b64_pass}').decode()
encrypted = cipher.encrypt(plaintext.encode())
print(base64.b64encode(encrypted).decode())
"'''
    return docker_exec(ragflow_container, cmd)


def update_db(mysql_container, mysql_password, encoded_password, email):
    """更新 gaisoft DB 中的密码配置"""
    # 转义 SQL 特殊字符
    safe_password = encoded_password.replace("\\", "\\\\").replace("'", "\\'")

    sql = (
        f"UPDATE sys_config SET config_value='{safe_password}' "
        f"WHERE config_key='password'"
    )
    docker_exec(
        mysql_container,
        f'mysql -uroot -p{mysql_password} --default-character-set=utf8mb4 equipment_iqas -e "{sql}"'
    )

    # 清除 Redis 缓存
    subprocess.run(
        ["docker", "exec", "ragflow-redis", "redis-cli",
         "-a", mysql_password, "-n", "8", "DEL", "sys_config:password"],
        capture_output=True, timeout=10
    )


def verify_login(ragflow_container, email, encoded_password):
    """验证登录是否成功"""
    safe_email = email.replace("'", "\\'")
    safe_pass = encoded_password.replace("'", "\\'").replace("=", "\\=")
    result = docker_exec(
        ragflow_container,
        f'''curl -s -X POST "http://ragflow-server/v1/user/login" '''
        f'''-H "Content-Type: application/json" '''
        f"""-d '{{"email":"{safe_email}","password":"{safe_pass}"}}' """
    )
    return '"code":0' in result


def main():
    # 配置
    ragflow_container = os.environ.get("RAGFLOW_CONTAINER", "ragflow-server")
    mysql_container = os.environ.get("MYSQL_CONTAINER", "ragflow-mysql")
    mysql_password = os.environ.get("MYSQL_PASSWORD", "infini_rag_flow")
    email = os.environ.get("RAGFLOW_EMAIL", "wanglun000330@163.com")
    plaintext_password = os.environ.get("RAGFLOW_PASSWORD", "wl20000330")

    print(f"  ragflow: {ragflow_container}  mysql: {mysql_container}  email: {email}")

    # 等待 ragflow 容器就绪
    print("[1/4] 等待 ragflow 容器就绪...")
    if not wait_for_container(ragflow_container):
        print("  ⚠ ragflow 容器未就绪，跳过认证同步")
        sys.exit(1)
    print("  容器已就绪")

    # 在 ragflow 容器内加密密码
    print("[2/4] 加密密码（ragflow 容器内）...")
    encoded = encrypt_in_container(ragflow_container, plaintext_password)
    print(f"  加密完成 ({len(encoded)} chars)")

    # 更新 DB
    print("[3/4] 更新 gaisoft DB...")
    update_db(mysql_container, mysql_password, encoded, email)
    print("  DB 已更新，Redis 缓存已清除")

    # 验证
    print("[4/4] 验证 ragflow 登录...")
    if verify_login(ragflow_container, email, encoded):
        print("  ✅ 登录验证通过")
    else:
        print("  ⚠ 登录验证失败，可能需要检查 ragflow 用户密码")
        sys.exit(1)


if __name__ == "__main__":
    main()
