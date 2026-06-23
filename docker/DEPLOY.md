# KnovaQ 部署手册 (DEPLOY.md)

离线部署到 Linux 服务器（验证环境：Ubuntu 22.04 / 24.04, x86_64, Docker + Compose v2）。

栈：ragflow 0.18.0 full + Elasticsearch + MySQL + MinIO + Valkey(Redis) + gaisoft-server + gaisoft-frontend。

---

## 0. 资源要求

| 项 | 最低 | 说明 |
|----|------|------|
| 内存 | 16 GB 建议（实测 30 GB 宽裕） | ragflow full + ES 较吃内存；< 8 GB 易 OOM |
| 磁盘 | 30 GB 空闲 | ragflow 镜像 ~7 GB + 数据卷 |
| Docker | 任意较新版 + `docker compose` v2 | `docker compose version` 能跑 |
| 内核 | `vm.max_map_count=262144` | ES 必需，见下 |

---

## 1. 交付物（拷贝什么）

整个 `docker/` 目录就是自包含部署包。两类场景：

- **全新机器（无镜像）**：拷**完整** `docker/`，含 `docker/images/`（7 个 `*.tar`，约 8.7 GB）。
- **现场已部署过（镜像已加载、且未变）**：只拷 `docker/` **除 `images/` 外**的部分（约 200 MB），关键是 `init/`、`scripts/`、`gaisoft/jar/gaisoftmes.jar`、`docker-compose.yml`、`.env`、`nginx/`、`projects/`。

> 注意：`gaisoftmes` 后端更新走 `gaisoft/jar/gaisoftmes.jar`（挂载的 jar），**不在** `images/` 里。`gaisoftmes` 镜像只是跑 jar 的 JRE 壳，一般不变。

---

## 2. 全新部署（首次）

```bash
cd docker
chmod +x scripts/*.sh

# 内核参数（ES 必需，持久化）
sudo sysctl -w vm.max_map_count=262144
grep -q vm.max_map_count /etc/sysctl.conf || echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf

# 加载镜像（带 *.tar 时）
bash scripts/offline-load.sh        # 自动校验 7 个镜像是否齐全

# 起栈（不带项目名 = 用 docker/nginx/default.conf 兜底）
bash scripts/start.sh
```

`start.sh` 会：起容器 → 等 ragflow-server healthy → 自动 seed ragflow 认证 → **自动跑 `verify.sh`**。
日志写到 `docker/logs/deploy-*.log` 与 `docker/logs/verify-*.log`。

---

## 3. 现场更新 / 重部署（镜像不变）

**⚠️ `down -v` 会销毁所有数据（知识库、上传文件、数据库），不可逆。确认旧数据不要了再执行。**

正确顺序：**备份 → (在原目录) down -v → 换成新目录 → start**。

```bash
# 1. 备份原 docker 目录
cp -r /path/to/docker /path/to/docker.bak-$(date +%F)

# 2. 清理旧部署（在「原」docker 目录里跑，需要原 compose+.env 定位 knovaq_* 卷）
cd /path/to/docker
docker compose down -v

#    验证清干净 + 镜像还在
docker ps -a    | grep -E "ragflow|equipment"   # 空 = 容器清了
docker volume ls | grep knovaq                   # 空 = 卷清了
docker images   | grep -E "ragflow|gaisoftmes|mysql|elasticsearch|minio|valkey|nginx"  # 7 个仍在

#    （万一 down -v 报错，手动兜底）
# docker rm -f ragflow-server ragflow-mysql ragflow-redis ragflow-es-01 ragflow-minio equipment-server equipment-front
# docker volume rm knovaq_mysql_data knovaq_esdata01 knovaq_minio_data knovaq_redis_data knovaq_ragflow_logs knovaq_ragflow_upload

# 3. 用新 docker/（除 images）覆盖原目录；images 已加载，无需重传/重 load

# 4. 起栈（内核参数若没持久化先补 sysctl，见 §2）
cd /path/to/docker
chmod +x scripts/*.sh
bash scripts/start.sh
```

镜像没变 → **不跑 `offline-load.sh`**，省 8.7 GB。

---

## 4. 验证

`start.sh` 末尾自动跑；也可随时独立运行：

```bash
bash scripts/verify.sh ; echo "exit=$?"
```

检查 8 项（全 PASS 才算成功，exit 0）：
1. 7 个容器 running / healthy
2. equipment_iqas 表数 ≥ 40
3. ragflow 用户已 seed（admin@163.com）
4. api_token 与 sys_config.RagFlowKey 匹配
5. ragflow API key 实时有效（`/api/v1/datasets` → code:0）
6. tenant 默认嵌入已设 + tenant_llm 有 embedding
7. HTTP 8070 / 8088 / 8899 → 200
8. 近 2 分钟无 gaisoft→ragflow 认证错误

失败项会把诊断（容器日志片段、异常响应）写进 `docker/logs/verify-*.log`。

---

## 5. 部署后唯一手动步骤：配置对话大模型

嵌入用镜像自带 `BAAI/bge-large-zh-v1.5`（本地、免 key、离线），**已自动配好**。
**对话（chat）需客户自己的 LLM API key**（如智谱 ZHIPU-AI），故意不写死在部署包里：

1. 浏览器开 `http://<服务器IP>:8899` 登录。
2. 模型管理 → 添加模型供应商 → 填客户的 chat LLM API key。
3. 设默认对话模型（如 `glm-4-flash@ZHIPU-AI`）。
4. 图文模型（img2txt）按需配置（视觉模型烧钱，默认留空）。

> 阿里云/云主机：安全组入方向放行 **8899 / 8070**（按需 5455 MySQL），来源建议收窄到办公 IP，勿留 `0.0.0.0/0`。

---

## 6. 端口

| 端口 | 服务 | 对外 |
|------|------|------|
| 8899 | gaisoft 前端（主系统入口） | 是 |
| 8070 | ragflow 知识库 Web | 是 |
| 8088 | gaisoft 后端 API（前端已反代 `/prod-api/`） | 一般否 |
| 5455 | MySQL（运维/Workbench） | 按需，限源 IP |
| 9100/9102 | MinIO | 否 |
| 6580 | Redis(Valkey) | 否 |

---

## 7. 初始化机制（排障背景）

三段 SQL，**执行时机/机制不同，不可合并**：

| 文件 | 时机 | 机制 | 作用 |
|------|------|------|------|
| `init/equipment_iqas.sql` | mysql 首次启动（卷空时） | initdb.d，一次性 | 建 equipment_iqas 库 + 表（开头已加 `CREATE DATABASE/USE`） |
| `init/ragflow-init.sql` | **每次**启动 | `--init-file`（幂等） | 确保 rag_flow 空库存在 |
| `init/post-seed/seed-ragflow-user.sql` | **ragflow healthy 之后** | `start.sh` 后置 exec | seed ragflow 用户/tenant/api_token/本地嵌入 |

关键：`rag_flow.*` 表由 ragflow-server 首次启动建（peewee），**不在** mysql initdb 阶段，所以 seed 必须后置，不能放 initdb.d。
`init/mock_test_data.sql.disabled` 是测试数据，**安装不加载**（改名 `.disabled` 让 initdb 跳过；测试时手动导入）。

---

## 8. 常见故障 → 定位

| 现象 | 原因 | 处理 |
|------|------|------|
| 页面弹「登录状态已过期」 | gaisoft 调 ragflow `/v1/*` 返回 401 | verify §3/§5；多半 ragflow 用户没 seed 或 jar 是旧版 |
| 「系统未知错误」/ API 调用失败 | ragflow API key 无效（code:109） | verify §4/§5；api_token 未注册，重跑 seed |
| equipment-server 起不来，`Unknown database` | equipment_iqas 没建 | verify §2；看 mysql initdb 日志 `docker logs ragflow-mysql` |
| ES 起不来 | `vm.max_map_count` 没设 | §2 的 sysctl |
| 外网访问不了（端口） | 云安全组没放行 / 本机代理(TUN)劫持 | 用无代理机器/手机 4G 测；查云安全组规则（注意别敲多逗号） |
| seed 失败 | ragflow 未在超时内 healthy | 看 `docker/logs/deploy-*.log`，ragflow 起来后重跑 `start.sh`（幂等） |

日志位置：`docker/logs/`（deploy-*.log 起栈过程，verify-*.log 验证明细）；容器日志 `docker logs <容器名>`。
