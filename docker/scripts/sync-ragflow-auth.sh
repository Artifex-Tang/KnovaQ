#!/usr/bin/env bash
# ============================================================
# sync-ragflow-auth.sh
# 从 ragflow 容器读取 RSA 公钥，加密密码后更新 gaisoft DB。
# 纯 shell + docker，零宿主机依赖。集成在 start.sh 中自动执行。
#
# 用法: bash docker/scripts/sync-ragflow-auth.sh
# ============================================================
set -euo pipefail

# 配置（可通过环境变量覆盖）
RAGFLOW_CONTAINER="${RAGFLOW_CONTAINER:-ragflow-server}"
MYSQL_CONTAINER="${MYSQL_CONTAINER:-ragflow-mysql}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-infini_rag_flow}"
RAGFLOW_EMAIL="${RAGFLOW_EMAIL:-wanglun000330@163.com}"
RAGFLOW_PASSWORD="${RAGFLOW_PASSWORD:-wl20000330}"

echo "  ragflow: $RAGFLOW_CONTAINER  mysql: $MYSQL_CONTAINER  email: $RAGFLOW_EMAIL"

# 等待 ragflow 容器就绪
echo "[1/4] 等待 ragflow 容器就绪..."
for i in $(seq 1 20); do
    if docker exec "$RAGFLOW_CONTAINER" echo ok >/dev/null 2>&1; then
        break
    fi
    sleep 3
done
if ! docker exec "$RAGFLOW_CONTAINER" echo ok >/dev/null 2>&1; then
    echo "  ⚠ ragflow 容器未就绪，跳过认证同步"
    exit 0  # non-fatal
fi
echo "  容器已就绪"

# 在 ragflow 容器内加密密码
echo "[2/4] 加密密码（ragflow 容器内）..."
# base64 编码明文密码避免 shell 转义问题
B64_PASS=$(echo -n "$RAGFLOW_PASSWORD" | base64)

ENCRYPTED=$(docker exec "$RAGFLOW_CONTAINER" python3 -c "
import base64
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5

with open('/ragflow/conf/public.pem') as f:
    pub_key = RSA.importKey(f.read())

cipher = PKCS1_v1_5.new(pub_key)
plaintext = base64.b64decode('${B64_PASS}').decode()
encrypted = cipher.encrypt(plaintext.encode())
print(base64.b64encode(encrypted).decode())
")

if [ -z "$ENCRYPTED" ]; then
    echo "  ⚠ 加密失败，跳过"
    exit 0
fi
echo "  加密完成 (${#ENCRYPTED} chars)"

# 更新 gaisoft DB
echo "[3/4] 更新 gaisoft DB..."
docker exec "$MYSQL_CONTAINER" mysql -uroot -p"$MYSQL_PASSWORD" --default-character-set=utf8mb4 \
    equipment_iqas -e "UPDATE sys_config SET config_value='$ENCRYPTED' WHERE config_key='password'" 2>/dev/null

# 清除 Redis 缓存
docker exec ragflow-redis redis-cli -a "$MYSQL_PASSWORD" -n 8 DEL "sys_config:password" >/dev/null 2>&1 || true
echo "  DB 已更新，Redis 缓存已清除"

# 验证
echo "[4/4] 验证 ragflow 登录..."
LOGIN_RESULT=$(docker exec "$RAGFLOW_CONTAINER" curl -s -X POST "http://ragflow-server/v1/user/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$RAGFLOW_EMAIL\",\"password\":\"$ENCRYPTED\"}")

if echo "$LOGIN_RESULT" | grep -q '"code":0'; then
    echo "  ✅ 登录验证通过"
else
    echo "  ⚠ 登录验证失败: $(echo "$LOGIN_RESULT" | head -c 200)"
    exit 1
fi
