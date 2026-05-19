# KnovaQ Docker 部署工程设计

**日期：** 2026-05-19  
**项目：** 知枢 · KnovaQ  
**状态：** 已批准

---

## 背景

KnovaQ 基于 ragflow 0.18.0 full 版本全量镜像，叠加 gaisoft-mes（Spring Boot）和 gaisoft-ui（Vue 3）两个自研服务。需要构建统一的 docker 工程目录，支持：

- 多客户部署（同代码，不同品牌/配置）
- 在线部署（pull 镜像）和离线部署（docker save/load tar 包）
- 数据库自动初始化（ragflow + gaisoft-mes）
- 外部构建产物（jar / html）注入运行时目录

---

## 目录结构

```
KnovaQ/docker/
├── docker-compose.yml          # 统一 compose：ragflow full 全服务 + gaisoft-server + gaisoft-frontend
├── .env                        # 全局默认值（镜像版本、端口、基础密码等）
│
├── projects/                   # 每客户一个子目录
│   ├── _template/              # 新客户复制用模板
│   │   ├── .env                # 客户变量说明（含所有可覆盖项及注释）
│   │   └── nginx/
│   │       └── default.conf    # nginx 配置模板
│   └── demo/                   # 示例客户
│       ├── .env                # 覆盖：域名、密码、品牌名等
│       └── nginx/
│           └── default.conf    # 客户专属 nginx 配置
│
├── gaisoft/                    # 运行时挂载目录（.gitignore 中排除大文件）
│   ├── jar/
│   │   └── gaisoftmes.jar      # gaisoft-mes 构建产出，由 build-mes.sh 更新
│   ├── uploadfile/             # 上传附件持久化存储
│   └── nginx/
│       ├── conf.d/
│       │   └── default.conf    # 运行时由 start.sh 从 projects/<客户>/nginx/ 复制
│       ├── html/               # gaisoft-ui 构建产出，由 build-ui.sh 整目录替换
│       └── logs/               # nginx 访问日志和错误日志
│
├── init/
│   └── equipment_iqas.sql      # gaisoft-mes 数据库初始化（equipment_iqas 库）
│
├── scripts/
│   ├── start.sh                # 启动指定客户：./start.sh <project>
│   ├── stop.sh                 # 停止所有服务
│   ├── build-mes.sh            # 从 gaisoft-mes/target/ 复制 jar：./build-mes.sh <project>
│   ├── build-ui.sh             # 从 gaisoft-ui/dist/ 复制 html：./build-ui.sh <project>
│   ├── offline-save.sh         # 将全部镜像 docker save → images/*.tar
│   └── offline-load.sh         # 从 images/*.tar 批量 docker load
│
└── images/                     # 离线 tar 包存放（.gitignore 排除）
```

---

## 服务设计

### docker-compose.yml 服务

| 服务名 | 镜像来源 | 说明 |
|--------|----------|------|
| ragflow 原有服务 | ragflow 0.18.0 full | 原样保留（ragflow core、mysql、redis、elasticsearch、minio 等） |
| `gaisoft-server` | `gaisoftmes`（已有自建镜像） | Spring Boot 服务，运行 gaisoftmes.jar |
| `gaisoft-frontend` | `nginx` | 静态前端 + 反向代理入口 |

### gaisoft-server 挂载

```yaml
gaisoft-server:
  image: gaisoftmes
  container_name: equipment-server
  networks: [ragflow]
  ports:
    - "8080:8080"
  volumes:
    - ./gaisoft/jar:/usr/soft
    - ./gaisoft/uploadfile:/ragflow/uploadPath
  restart: always
```

### gaisoft-frontend 挂载

```yaml
gaisoft-frontend:
  image: nginx
  container_name: equipment-front
  networks: [ragflow]
  ports:
    - "8899:80"
  volumes:
    - ./gaisoft/nginx/html:/usr/share/nginx/html
    - ./gaisoft/nginx/logs:/var/log/nginx
    - ./gaisoft/nginx/conf.d:/etc/nginx/conf.d
  restart: always
```

### 网络

全服务共用一个 compose 内部网络，compose 自动命名为 `docker_ragflow`（因工程目录名为 `docker`），与现有脚本习惯一致。

### nginx 代理规则（default.conf）

```
/              → gaisoft/nginx/html（静态前端）
/prod-api/     → http://gaisoft-server:8080（gaisoft-mes API）
/v1/           → http://ragflow:9380（ragflow API，如需直接访问）
```

具体路由按客户需求在各自 `projects/<客户>/nginx/default.conf` 中定制。

---

## 数据库初始化

`init/equipment_iqas.sql` 挂载到 mysql 容器的 `/docker-entrypoint-initdb.d/`。MySQL 官方镜像在数据目录为空时（首次启动）自动执行，之后跳过。ragflow 自身数据库由 ragflow 容器启动时自行初始化，无需额外 SQL。

---

## 构建流程

### gaisoft-mes 更新

```bash
# 在 gaisoft-mes 目录执行
mvn clean package -pl gaisoft-admin -am -DskipTests

# 回到 KnovaQ 执行
./docker/scripts/build-mes.sh demo
# → 复制 gaisoft-mes/gaisoft-admin/target/gaisoft-admin.jar
#   到 docker/gaisoft/jar/gaisoftmes.jar
# → docker compose restart gaisoft-server
```

### gaisoft-ui 更新

```bash
# 在 gaisoft-ui 目录执行
npm run build:prod

# 回到 KnovaQ 执行
./docker/scripts/build-ui.sh demo
# → 清空 docker/gaisoft/nginx/html/
# → 复制 gaisoft-ui/dist/ 到 docker/gaisoft/nginx/html/
# → docker compose restart gaisoft-frontend
```

---

## 多客户操作

### 启动指定客户环境

```bash
./docker/scripts/start.sh demo
# 1. cp projects/demo/nginx/default.conf → gaisoft/nginx/conf.d/default.conf
# 2. docker compose --env-file projects/demo/.env up -d
```

### 新增客户

```bash
cp -r docker/projects/_template docker/projects/customer-b
# 编辑 customer-b/.env 和 customer-b/nginx/default.conf
```

---

## 离线部署流程

### 开发/构建机

```bash
./docker/scripts/offline-save.sh
# → docker save 所有镜像 → docker/images/<image-name>.tar
# → 打包 docker/ 目录（含 images/）发给客户
```

### 客户机

```bash
./docker/scripts/offline-load.sh
# → 批量 docker load 所有 images/*.tar
./docker/scripts/start.sh <project>
```

---

## .gitignore 策略

```
docker/gaisoft/jar/
docker/gaisoft/uploadfile/
docker/gaisoft/nginx/html/
docker/gaisoft/nginx/logs/
docker/gaisoft/nginx/conf.d/
docker/images/
```

`projects/` 目录全量入 git（含各客户 `.env` 和 nginx 配置）。注意：`.env` 中不存放生产密码明文，敏感值由部署时手动填入或 CI 注入。
