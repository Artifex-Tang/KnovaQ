# 服务器部署步骤（2026-06-10）

## 今天改了什么

1. **ragflow session 认证自动同步** — 启动时自动用 ragflow 当前 RSA 公钥加密密码更新 DB
2. **druid 监控页面** — nginx 代理 + 静态资源修复 + iframe URL 修复
3. **模拟测试数据** — 文件、分类、会话、对话记录

涉及的代码改动：
- KnovaQ: `start.sh`, `start.ps1`, `default.conf`, `sync-ragflow-auth.sh/py`, `mock_test_data.sql`
- gaisoft-ui: `src/views/monitor/druid/index.vue`（前端需要重新 build）

---

## 部署步骤

### 第一步：服务器上拉取最新代码

```bash
cd /path/to/KnovaQ
git pull origin master

cd /path/to/gaisoft-ui
git pull origin cxy
```

### 第二步：本地构建前端，拷贝到服务器

如果服务器上没有 Node.js，在本地构建后拷贝：

```bash
# 本地执行
cd E:\ccode\gaisoft-ui
npm run build:prod
# 将 dist/ 目录内容拷贝到服务器 KnovaQ/docker/gaisoft/nginx/html/
```

或者直接用打包好的 html 覆盖（如果已经在本地 build 过）：

```bash
# 本地执行
bash docker/scripts/build-ui.sh   # 构建
# 然后把 docker/gaisoft/nginx/html/ 拷到服务器
```

### 第三步：重启服务

```bash
# 服务器上执行
cd /path/to/KnovaQ/docker

# 如果修改了 compose 配置或 nginx 配置：
bash scripts/stop.sh
bash scripts/start.sh

# start.sh 会自动执行 sync-ragflow-auth.sh（同步 ragflow 密码）

# 如果只改了前端代码（compose 没变）：
docker exec equipment-front sh -c 'nginx -s reload'
```

### 第四步：验证

1. 浏览器访问 `http://<服务器IP>/` → 登录 admin/admin123
2. 点击各菜单确认 ragflow 交互正常（知识库管理、模型管理等）
3. 访问 `http://<服务器IP>/monitor/druid` → ruoyi / 123456

### 如果 ragflow 认证还有问题

手动运行同步脚本：
```bash
bash docker/scripts/sync-ragflow-auth.sh
docker restart equipment-server
```

---

## 注意事项

- **每次 ragflow 容器重建后**，start.sh 会自动同步认证，无需手动操作
- **gaisoft-ui 改了代码必须重新 build**，否则前端没变化
- **docker/gaisoft/nginx/conf.d/default.conf** 现在 track 在 git 里了
- **captcha 已关闭**（`sys.account.captchaEnabled=false`），如需恢复：
  ```sql
  UPDATE sys_config SET config_value='true' WHERE config_key='sys.account.captchaEnabled';
  ```
