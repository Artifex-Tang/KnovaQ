# 会话总结 2026-06-29：QA链路修复 + 数据灌库 + UI/基建修复

## 起因
用户报"问答出错"。排查定位到前后端↔ragflow认证链路在 ragflow 0.18.0 下断裂, 继而完成知识库灌库(原KB空)及一系列UI/基建问题。

---

## 一、根因：ragflow 双认证被部分回归

ragflow 0.18.0 两族认证:
- `/api/v1/*`(SDK HTTP API) → **API Key**(`Bearer <RagFlowKey>`)
- `/v1/*`(web内网API) → **session token**(=`/v1/user/login` **响应的 Authorization 头**, 非body的access_token)

`892f9db`("unify to pure API key, remove session")重构把后端改成纯API Key, 假设所有端点吃Key — **错**, `/v1/*`拒Key返401。`cc18295`只回滚UtilsController, 漏改KbSession + StreamProxy + ThirdPartyFileUpload。

### 修复(均部署, jar sha `70f65d8`)
| 文件 | 原 | 改 |
|------|----|----|
| `KbSessionServiceImpl` | `/v1/conversation/set`+API Key(401) | 迁 `/api/v1/chats/{id}/sessions`+Key |
| `StreamProxyController` | 纯API Key | dual(`/api/`→Key, `/v1/→getAuthorization session`) |
| `ThirdPartyFileUploadServiceImpl` | 纯API Key | dual(按url分) |
| `ops_solutions.vue`(completion) | `/v1/conversation/completion` | `/api/v1/chats/{id}/completions` |

`UtilsController`(/ragflow/common)本就dual正确; `GetAuthorization`虽@Deprecated但session认证实测有效, 保留。

> 结论: 当前dual = 既工作又保留0.18.0兼容; 无需全退原始纯session(会撤掉0.18.0兼容commit)。

---

## 二、知识库灌库(原KB空 → QA无内容)

### 灌库v3(已部署, 助理`692d3e0e`已挂12 KB)
- **12 KB = 主题×切片方式**(6主题循环配12切片)。脚本 `docker/test-runner/ingest_matrix.py`。
- 每切片方式灌**全格式**(ragflow规格): 单格式方法25篇/格式, 多格式12篇/格式。~400篇, **1391 chunks**, 12min。
- embedding切 **glm embedding-3@ZHIPU-AI**(原BAAI本地慢, 大文件50M+切块爆炸)。
- 复用 `test_suite_h_parser_coverage.py` GENERATORS + 自补 csv/json/html/xlsx/jpg 生成器。

### ragflow v0.18.0 切片格式规格(权威, 源 `/ragflow/web/src/locales/zh.ts`)
| 切片 | 格式 | 切片 | 格式 |
|------|------|------|------|
| naive | DOCX/XLSX/XLS/PPT/PDF/TXT/JPEG-JPG/PNG/TIF/GIF/CSV/JSON/EML/HTML | qa | XLSX |
| book | DOCX/PDF/TXT | table | XLSX/CSV/TXT |
| laws | DOCX/PDF/TXT | tag | XLSX |
| manual | PDF | picture | JPG/PNG/TIF/GIF |
| paper | PDF | email | EML |
| presentation | PDF/PPTX | one | TXT |

resume/knowledge_graph: dataset API不暴露, 不纳入。**已写入 SRS M1-REQ-004(.md + .docx附录)**。

### 僵尸任务drain(SOP)
删KB后task_executor的`recover_pending_tasks`不自动清 → 堵队列。drain: `redis-cli -n 1 FLUSHDB` + `restart ragflow-server`。**db1=ragflow队列, db8=gaisoft(勿碰), db0空**。

### 大文件测试结论
上传1M-100M全成功(nginx 1024M够); 解析50M+崩(naive切块爆炸→embedding过载)。**单文件实用上限~10M**。

---

## 三、UI修复(全部署)

| 问题 | 文件 | 修法 |
|------|------|------|
| "搜索中"卡死 | ops_solutions.vue | completion迁/api/v1/ |
| 聊天输入框出视口 | ops_solutions.vue | chatBox flex column + chatRecordBox flex:1(原固定500px顶出footer) |
| 分块弹窗"暂无分块" | dataSet.vue | 去掉错误GET /documents/{id}, 直接用docId调 /documents/{id}/chunks |
| 知识库卡片不平均 | manual.vue | flex+margin hack → grid auto-fill 350px居中+gap |
| 助理头像不能删/不显示 | assistantConfig.vue | 画廊(6预设)+上传+删除+显示 |
| 用户头像 | userAvatar.vue | 画廊(6预设)+usePreset(fetch→uploadAvatar) |

### 头像(CogView生成)
- **ZHIPU CogView**(`open.bigmodel.cn/api/paas/v4/images/generations`, cogview-4, 1024x1024)。deepseek纯文本不能出图, GLM有CogView。
- 12张在 `gaisoft-ui/public/imgs/`: avatar_assistant_1..6 + avatar_user_1..6。脚本 `docker/test-runner/avatar_gen.py`。

---

## 四、基建修复

### Druid 404回归
- `docker/gaisoft/nginx/conf.d/default.conf` 被未提交编辑简化, 删了druid代理+SSE流式配置。
- `git checkout` 恢复HEAD(commit a1dfb6b) + demo/_template/nginx/default.conf 同步加druid块。
- **Druid账号: `ruoyi` / `123456`**(application-druid.yml)。

### 109 "API key invalid"
- ragflow日志30m内0次, 系drain重启时的瞬时, 非持续。无需处理。

---

## 五、未提交代码改动(待commit)

| 仓库 | 文件 |
|------|------|
| gaisoft-mes | KbSessionServiceImpl.java, StreamProxyController.java, ThirdPartyFileUploadServiceImpl.java |
| gaisoft-ui | ops_solutions.vue, dataSet.vue, manual.vue, assistantConfig.vue, userAvatar.vue |
| KnovaQ | docker/gaisoft/nginx/conf.d/default.conf(恢复), docker/projects/{demo,_template}/nginx/default.conf(加druid), docker/test-runner/{ingest_matrix,bigfile_test,avatar_gen}.py, docs/(SRS + 本总结) |

---

## 六、关键命令速查
- session token: `curl -s -D - -o /dev/null -X POST .../v1/user/login -d '{email,password}' | grep -i '^authorization:'`(取响应头)
- jar部署: `bash docker/scripts/build-mes.sh`(先 `mvn package -pl gaisoft-admin -am -DskipTests`)
- UI部署: `bash docker/scripts/build-ui.sh`(先 `npm run build:prod`)
- 僵尸drain: `redis-cli -a <pw> -n 1 FLUSHDB` + `docker restart ragflow-server`
- test-runner跑脚本: `MSYS_NO_PATHCONV=1 docker run --rm --network knovaq_ragflow --entrypoint python3 -v <test-runner>:/tests knovaq-test-runner:latest /tests/<script>.py`

详见 memory: `ragflow-auth-audit-2026-06-29.md`, `ingest-format-avatars-2026-06-29.md`。
