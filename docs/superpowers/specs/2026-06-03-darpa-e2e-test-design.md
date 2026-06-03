# DARPA智能问答服务工具 — 端到端自动化测试设计

**日期**: 2026-06-03
**状态**: 待实现
**系统版本**: ragflow 0.18.0 + gaisoft-mes (Spring Boot) + gaisoft-ui (Vue 3)

---

## 1. 概述

为DARPA智能问答服务工具设计端到端自动化测试体系。系统采用"外挂知识库—RAG检索增强—交互式提示"三级架构，测试覆盖从UI到后端的全链路。

### 1.1 核心测试模块

| 模块 | 功能 | 测试类型 |
|------|------|----------|
| 外挂知识库 | 非结构化文档深度加工与语义化重构 | API |
| RAG检索增强 | 多文本特征融合的混合检索体系 | API |
| 交互式提示词工程 | 动态模板引擎与结构化约束机制 | API |
| gaisoft集成层 | StreamProxy代理、会话持久化、认证缓存 | API |
| 全链路集成 | 知识库→检索→回答完整链路 | API |
| 前端交互 | 知识库管理、对话、文档上传界面 | Playwright |

### 1.2 技术决策

| 决策项 | 选择 | 理由 |
|--------|------|------|
| API测试框架 | Python pytest | ragflow已有pytest体系，可复用SDK |
| UI测试框架 | Playwright (Chromium) | 支持headless，容器友好 |
| 运行方式 | Docker容器化 | 与部署架构一致，环境隔离 |
| 报告格式 | HTML + Allure | HTML快速查看，Allure支持趋势分析 |
| 测试数据 | 模拟DARPA风格文档 | 可自由构造，无敏感数据风险 |

---

## 2. 目录结构

```
docker/test-runner/
├── Dockerfile                    # Python 3.11 + pytest + playwright + allure
├── requirements.txt
├── pytest.ini                    # pytest配置
├── conftest.py                   # 全局fixture
│
├── fixtures/
│   ├── api_client.py             # ragflow API client封装
│   ├── gaisoft_client.py         # gaisoft-mes API client封装
│   ├── browser_factory.py        # Playwright浏览器工厂
│   ├── test_data_factory.py      # 测试文档生成器
│   └── assertions.py             # 自定义断言
│
├── test_data/
│   ├── darpa_report.pdf          # 模拟DARPA技术报告
│   ├── equipment_manual.docx     # 模拟装备手册
│   ├── spec_table.xlsx           # 模拟规范参数表
│   ├── field_guide.txt           # 模拟野战指南
│   ├── policy_laws.md            # 模拟政策法规
│   └── mixed_corpus/             # 混合语料
│       ├── cn_military_doc.txt   # 中文军事文档
│       ├── en_tech_report.txt    # 英文技术报告
│       └── structured_qa.json   # 结构化QA对
│
├── tests/
│   ├── module1_knowledge_base/
│   │   ├── conftest.py
│   │   ├── test_dataset_crud.py           # 知识库CRUD
│   │   ├── test_document_upload.py        # 多格式文档上传
│   │   ├── test_document_parsing.py       # 12种chunk_method解析
│   │   ├── test_chunk_management.py       # 分块管理CRUD
│   │   ├── test_metadata_filter.py        # 元数据过滤
│   │   └── test_multi_source_ingestion.py # 多源异构数据接入
│   │
│   ├── module2_rag_retrieval/
│   │   ├── conftest.py
│   │   ├── test_vector_search.py          # 向量语义检索
│   │   ├── test_hybrid_search.py          # 混合检索
│   │   ├── test_reranking.py              # 重排序
│   │   ├── test_similarity_threshold.py   # 相似度阈值调优
│   │   ├── test_cross_language.py         # 跨语言检索
│   │   ├── test_knowledge_graph.py        # GraphRAG知识图谱
│   │   └── test_retrieval_accuracy.py     # 检索精度评估
│   │
│   ├── module3_prompt_engineering/
│   │   ├── conftest.py
│   │   ├── test_chat_assistant.py         # 对话助手创建与配置
│   │   ├── test_system_prompt.py          # 系统提示词模板
│   │   ├── test_multi_turn_dialog.py      # 多轮对话上下文
│   │   ├── test_streaming_response.py     # 流式响应
│   │   ├── test_reference_citation.py     # 引用溯源
│   │   └── test_prompt_template_engine.py # 动态模板引擎
│   │
│   ├── module4_gaisoft_integration/
│   │   ├── conftest.py
│   │   ├── test_stream_proxy.py           # StreamProxy代理
│   │   ├── test_kb_session.py             # 知识库会话管理
│   │   ├── test_kb_chat.py                # 聊天记录CRUD
│   │   └── test_auth_integration.py       # 认证集成
│   │
│   ├── e2e_full_pipeline/
│   │   ├── conftest.py
│   │   ├── test_e2e_knowledge_to_answer.py    # 全链路
│   │   ├── test_e2e_multi_doc_reasoning.py     # 多文档推理
│   │   ├── test_e2e_offline_deployment.py      # 离线部署验证
│   │   └── test_e2e_data_security.py           # 数据安全验证
│   │
│   └── ui_playwright/
│       ├── conftest.py
│       ├── test_ui_knowledge_management.py     # KB管理界面
│       ├── test_ui_chat_interaction.py         # 对话交互界面
│       ├── test_ui_rag_testing.py              # RAG测试界面
│       └── test_ui_document_upload.py          # 文档上传界面
│
└── reports/                      # Allure报告输出目录
```

---

## 3. 测试用例清单

### 3.1 模块1：外挂知识库（12个用例）

| ID | 用例名 | 步骤 | 预期结果 |
|----|--------|------|----------|
| KB-001 | 创建知识库 | POST `/api/v1/datasets` name="DARPA装备手册", chunk_method="naive" | 201, 返回dataset_id |
| KB-002 | 多格式文档上传 | 分别上传 PDF/DOCX/XLSX/TXT/MD 到同一dataset | 各文档状态UNSTART, document_count递增 |
| KB-003 | 文档解析-naive | 解析通用文本，chunk_token_num=512 | UNSTART→RUNNING→DONE, chunk_count>0 |
| KB-004 | 文档解析-book | 上传长篇手册，chunk_method="book" | 按章节分块，保留目录结构 |
| KB-005 | 文档解析-table | 上传XLSX装备参数表，chunk_method="table" | 表格结构保持完整 |
| KB-006 | 文档解析-paper | 上传技术论文，chunk_method="paper" | 摘要/正文/参考文献正确分离 |
| KB-007 | 分块管理CRUD | 手动添加/修改/删除/切换chunk | 操作成功，内容更新 |
| KB-008 | 多源异构接入 | 同一dataset同时包含中英文文档+表格+图片 | 全部解析成功，无冲突 |
| KB-009 | 元数据过滤 | 为文档设置metadata，检索时condition过滤 | 仅返回匹配文档的chunk |
| KB-010 | 大文件处理 | 上传50MB+ PDF | 解析不超时，不OOM |
| KB-011 | 批量文档操作 | 一次上传20个文档并批量解析 | 全部完成，进度可追踪 |
| KB-012 | 知识库删除级联 | 删除dataset，检查文档/chunk级联清除 | 无残留数据 |

### 3.2 模块2：RAG检索增强（12个用例）

| ID | 用例名 | 步骤 | 预期结果 |
|----|--------|------|----------|
| RG-001 | 基础语义检索 | 上传装备手册后，query="雷达维护周期" | 返回相关chunk, similarity>0.2 |
| RG-002 | 混合检索 | vector_similarity_weight=0.5, keyword=true | 向量+关键词双路召回融合 |
| RG-003 | 相似度阈值调优 | 分别设threshold=0.1/0.3/0.5/0.7检索 | 阈值越高结果越少越精准 |
| RG-004 | 跨语言检索 | 中文文档+英文文档, cross_languages=true | 中英文文档都被召回 |
| RG-005 | 重排序验证 | 启用rerank模型检索 | 重排后top结果相关性提升 |
| RG-006 | top_k参数影响 | top_k=10/50/1024分别检索 | top_k越大召回越多，延迟越高 |
| RG-007 | 多dataset联合检索 | 跨3个dataset检索同一query | 结果包含各dataset匹配chunk |
| RG-008 | 知识图谱检索 | 构建GraphRAG后use_kg=true检索 | 多跳推理返回关联实体 |
| RG-009 | 精确率/召回率评估 | 预设20个query+标准答案，计算P/R/F1 | P>0.8, R>0.7, F1>0.75 |
| RG-010 | 无关query处理 | query="今天天气怎么样"（无关知识库） | similarity低于阈值，返回空 |
| RG-011 | 长query检索 | 200字长问题描述 | 正确提取关键语义检索 |
| RG-012 | 检索性能基准 | 100次并发检索，记录延迟 | P95<2s |

### 3.3 模块3：交互式提示词工程（12个用例）

| ID | 用例名 | 步骤 | 预期结果 |
|----|--------|------|----------|
| PE-001 | 创建对话助手 | POST `/api/v1/chats` 绑定dataset，设system prompt | 创建成功，配置正确 |
| PE-002 | 系统提示词-领域约束 | prompt="你是DARPA装备分析专家，仅回答军事技术问题" | 拒绝无关问题 |
| PE-003 | 单轮问答 | session中发送query，非流式 | 返回answer + references |
| PE-004 | 流式问答 | stream=true发送query | SSE逐token返回，最终[DONE] |
| PE-005 | 多轮对话上下文 | 连续3轮相关对话，第4轮引用第1轮内容 | 正确理解上下文引用 |
| PE-006 | 引用溯源 | 检查response中reference字段 | 包含chunk_id/similarity/doc_name |
| PE-007 | 空知识库回复 | query关于空知识库的问题 | 返回预设empty_response |
| PE-008 | temperature影响 | 分别设temperature=0/0.5/1.0回答同一问题 | 温度越高答案越多样 |
| PE-009 | 动态模板变量 | prompt中使用 `{knowledge}` 变量 | 正确注入检索结果 |
| PE-010 | 会话管理 | 创建/列表/删除session | CRUD完整，消息不串 |
| PE-011 | OpenAI兼容接口 | 通过 `/api/v1/chats_openai` 调用 | 兼容OpenAI格式响应 |
| PE-012 | 结构化输出约束 | prompt要求JSON格式输出 | 返回合法JSON |

### 3.4 模块4：gaisoft集成层（4个用例）

| ID | 用例名 | 步骤 | 预期结果 |
|----|--------|------|----------|
| GI-001 | StreamProxy代理转发 | 前端发对话→gaisoft代理→ragflow | SSE流正确透传 |
| GI-002 | KB会话持久化 | 创建session→聊天→重启服务→恢复 | 数据不丢失 |
| GI-003 | 认证token缓存 | 连续请求验证token复用 | 60分钟内不重新登录 |
| GI-004 | 多用户会话隔离 | 两用户同时对话，session不混淆 | 各自独立 |

### 3.5 E2E全链路（4个用例）

| ID | 用例名 | 步骤 | 预期结果 |
|----|--------|------|----------|
| E2E-001 | 知识库→检索→回答 | 上传文档→解析→创建助手→提问 | 完整链路成功，答案可引用 |
| E2E-002 | 多文档交叉推理 | 3份装备手册入库，提问需跨文档推理 | 正确综合多源信息 |
| E2E-003 | 离线部署验证 | offline-load→start→跑全部测试 | 无外网依赖 |
| E2E-004 | 数据安全-无泄露 | A用户知识库对B用户不可见 | 数据隔离 |

### 3.6 UI Playwright（4个用例）

| ID | 用例名 | 步骤 | 预期结果 |
|----|--------|------|----------|
| UI-001 | 知识库管理页面 | 登录→导航到KB管理→创建dataset | 页面渲染正确，操作可完成 |
| UI-002 | 文档上传交互 | 拖拽/点击上传多个文件 | 进度条显示，状态更新 |
| UI-003 | 对话界面 | 输入问题→观察流式回答→检查引用 | 流式渲染流畅 |
| UI-004 | RAG测试界面 | ragTest页面执行检索测试 | 结果展示含相似度分数 |

**总计: 48个测试用例**

---

## 4. 基础设施设计

### 4.1 Dockerfile

```dockerfile
FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl unzip fonts-wqy-zenhei \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tests
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && playwright install chromium \
    && playwright install-deps chromium

COPY . .

ENTRYPOINT ["pytest", "--alluredir=/tests/reports/allure-results"]
```

### 4.2 docker-compose 集成

```yaml
test-runner:
  build:
    context: ../test-runner
    dockerfile: Dockerfile
  depends_on:
    ragflow:
      condition: service_healthy
    gaisoft-server:
      condition: service_started
    gaisoft-frontend:
      condition: service_started
  environment:
    - RAGFLOW_BASE_URL=http://ragflow:9380
    - RAGFLOW_API_KEY=${RAGFLOW_API_KEY}
    - GAISOFT_API_URL=http://gaisoft-server:8080
    - GAISOFT_FRONTEND_URL=http://gaisoft-frontend:8899
    - RAGFLOW_EMAIL=${RAGFLOW_EMAIL:-admin@ragflow.com}
    - RAGFLOW_PASSWORD=${RAGFLOW_PASSWORD:-admin}
  volumes:
    - ./test-runner/reports:/tests/reports
  networks:
    - ragflow
  profiles:
    - test
```

`profiles: [test]` 确保默认 `docker compose up` 不启动测试，需显式 `--profile test`。

### 4.3 核心fixture

```python
# conftest.py

import os, pytest, uuid
from playwright.sync_api import sync_playwright

@pytest.fixture(scope="session")
def ragflow_api():
    """ragflow HTTP API client"""
    from fixtures.api_client import RagflowClient
    client = RagflowClient(
        base_url=os.environ["RAGFLOW_BASE_URL"],
        api_key=os.environ["RAGFLOW_API_KEY"]
    )
    yield client

@pytest.fixture(scope="session")
def gaisoft_api():
    """gaisoft-mes API client"""
    from fixtures.gaisoft_client import GaisoftClient
    client = GaisoftClient(
        base_url=os.environ["GAISOFT_API_URL"]
    )
    yield client

@pytest.fixture(scope="session")
def browser_context():
    """Playwright Chromium headless"""
    pw = sync_playwright().start()
    browser = pw.chromium.launch(headless=True)
    context = browser.new_context()
    yield context
    context.close()
    browser.close()
    pw.stop()

@pytest.fixture(scope="session")
def test_dataset(ragflow_api):
    """预创建测试知识库，session结束自动清理"""
    ds = ragflow_api.create_dataset(
        name=f"test_darpa_{uuid.uuid4().hex[:8]}"
    )
    yield ds
    ragflow_api.delete_dataset(ds["id"])

@pytest.fixture(scope="session")
def prepared_dataset(ragflow_api, test_dataset):
    """已上传并解析完成的测试数据集"""
    from fixtures.test_data_factory import upload_test_documents, wait_for_parsing
    docs = upload_test_documents(ragflow_api, test_dataset["id"])
    ragflow_api.parse_documents(
        test_dataset["id"],
        [d["id"] for d in docs]
    )
    wait_for_parsing(ragflow_api, test_dataset["id"], timeout=300)
    return test_dataset
```

### 4.4 pytest.ini

```ini
[pytest]
markers =
    api: API层测试
    ui: Playwright UI测试
    e2e: 全链路端到端测试
    slow: 慢速测试（大文件、批量操作）
testpaths = tests
timeout = 300
addopts = -v --tb=short
```

### 4.5 requirements.txt

```
pytest>=8.0
pytest-xdist>=3.5
pytest-timeout>=2.2
allure-pytest>=2.13
playwright>=1.40
requests>=2.31
python-docx>=1.1
openpyxl>=3.1
reportlab>=4.0
Pillow>=10.0
```

---

## 5. 执行方式

```bash
# 运行全部测试
docker compose --profile test up test-runner

# 只跑API层
docker compose --profile test run --rm test-runner \
    pytest tests/module1_knowledge_base tests/module2_rag_retrieval -m api

# 只跑UI测试
docker compose --profile test run --rm test-runner \
    pytest tests/ui_playwright -m ui

# 只跑E2E
docker compose --profile test run --rm test-runner \
    pytest tests/e2e_full_pipeline -m e2e

# 生成Allure报告
docker compose --profile test run --rm test-runner \
    allure generate /tests/reports/allure-results -o /tests/reports/allure-report
```

---

## 6. 测试执行流程

```
docker compose --profile test up test-runner
    │
    ├── ragflow (service_healthy 健康检查通过)
    ├── gaisoft-server (service_started)
    └── gaisoft-frontend (service_started)
          │
          ▼
    test-runner ENTRYPOINT [pytest ...]
          │
    ┌─────┼─────────────────────┐
    │     │                     │
    ▼     ▼                     ▼
  模块1  模块2               模块3
  知识库  RAG检索            提示词工程
  (API)  (API)              (API)
    │     │                     │
    └─────┼─────────────────────┘
          ▼
    模块4 gaisoft集成 (API)
          │
          ▼
    E2E 全链路 (API)
          │
          ▼
    UI Playwright (Chromium headless)
          │
          ▼
    Allure报告 → /tests/reports/
```

---

## 7. 测试数据设计

模拟DARPA风格文档通过 `test_data_factory.py` 自动生成：

| 文件 | 格式 | 内容 | 验证点 |
|------|------|------|--------|
| darpa_report.pdf | PDF | 雷达系统技术评估报告（含图表） | PDF解析、图文混合 |
| equipment_manual.docx | DOCX | 通信装备操作手册（多章节） | 书籍分块、目录结构 |
| spec_table.xlsx | XLSX | 装备参数规范表（结构化数据） | 表格解析、数据完整性 |
| field_guide.txt | TXT | 野战维护指南（纯文本） | 通用分块、关键词检索 |
| policy_laws.md | MD | 军事装备管理条例（法规格式） | 法规分块、条款引用 |
| cn_military_doc.txt | TXT | 中文军事技术文档 | 中文语义检索 |
| en_tech_report.txt | TXT | 英文DARPA技术报告 | 跨语言检索 |
| structured_qa.json | JSON | 结构化QA对（50组） | 精度评估基准 |
