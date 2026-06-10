# DARPA-IQAS V2 - Design Spec

> Human-readable design narrative. Machine-readable contract: `spec_lock.md`.

## I. Project Information

| Item | Value |
| ---- | ----- |
| **Project Name** | DARPA智能问答服务工具 项目汇报 V2 |
| **Canvas Format** | PPT 16:9 (1280×720) |
| **Page Count** | 14 |
| **Design Style** | General Versatile + 深色科技政务 |
| **Target Audience** | 评审专家、项目验收方 |
| **Use Case** | 项目汇报验收 |
| **Created Date** | 2026-06-09 |

---

## II. Canvas Specification

| Property | Value |
| -------- | ----- |
| **Format** | PPT 16:9 |
| **Dimensions** | 1280×720 px |
| **viewBox** | `0 0 1280 720` |
| **Margins** | left/right 60px, top/bottom 50px |
| **Content Area** | 1160×620 px |

---

## III. Visual Theme

### Theme Style

- **Style**: 深色科技 + 政务权威
- **Theme**: Light theme with dark accent headers
- **Tone**: 专业、权威、现代、科技感

### Color Scheme

| Role | HEX | Purpose |
| ---- | --- | ------- |
| **Background** | `#F8FAFC` | 页面背景 |
| **Secondary bg** | `#FFFFFF` | 卡片背景 |
| **Primary** | `#1E2761` | 标题装饰、关键区域 |
| **Accent** | `#2DD4A8` | 数据高亮、关键指标 |
| **Secondary accent** | `#4A7BF7` | 辅助强调 |
| **Body text** | `#1E293B` | 正文 |
| **Secondary text** | `#64748B` | 注释说明 |
| **Tertiary text** | `#94A3B8` | 页脚补充 |
| **Border/divider** | `#E2E8F0` | 卡片边框、分隔线 |
| **Success** | `#2DD4A8` | 正面指标 |
| **Warning** | `#EF4444` | 告警标记 |

### Gradient Scheme

```xml
<linearGradient id="headerGradient" x1="0%" y1="0%" x2="100%" y2="0%">
  <stop offset="0%" stop-color="#1E2761"/>
  <stop offset="100%" stop-color="#2A3A7E"/>
</linearGradient>

<radialGradient id="bgDecor" cx="80%" cy="20%" r="50%">
  <stop offset="0%" stop-color="#4A7BF7" stop-opacity="0.08"/>
  <stop offset="100%" stop-color="#4A7BF7" stop-opacity="0"/>
</radialGradient>
```

---

## IV. Typography System

### Font Plan

**Typography direction**: 深色科技政务 — 黑体标题 + 微软雅黑正文

**Per-role font stacks**:

| Role | Font stack |
| ---- | ---------- |
| Title / heading | `SimHei, "Microsoft YaHei", sans-serif` |
| Body | `"Microsoft YaHei", Arial, sans-serif` |
| Emphasis | `SimHei, "Microsoft YaHei", sans-serif` |
| Code | `Consolas, "Courier New", monospace` |

### Font Size Ramp

| Level | Size | Use |
| ----- | ---- | --- |
| Cover title | 56px | 封面主标题 |
| Page title | 36px | 页面标题 |
| Subtitle | 24px | 副标题/模块名 |
| **Body** | **22px** | 正文基线 |
| Body small | 18px | 辅助正文 |
| Annotation | 15px | 注释/标签 |
| Page number | 12px | 页码 |

---

## V. Layout Strategy

- **Header bar**: 每页顶部深蓝色矩形条(60px高) + 白色标题
- **Content grid**: 左文右图 / 左图右文 / 全图 / 三栏卡片的混合布局
- **Card style**: 白色圆角矩形(6px radius) + 轻阴影 + 左侧彩色竖条装饰
- **Footer**: 右下角页码 `N/14`

### Page Rhythm Plan

| Page | Layout | Rhythm |
| ---- | ------ | ------ |
| 1 Cover | 全幅深色背景 + 右侧三级架构示意 | breathing |
| 2 Overview | 左侧说明卡片 + 右侧特性列表 + 底部统计 | dense |
| 3 Three-tier Arch | 全图 — SVG原生绘制三级架构 | breathing |
| 4 Tech Arch | 全图 — SVG原生绘制四层架构 | breathing |
| 5 Deployment | 全图 — SVG原生绘制部署关系 | breathing |
| 6 Functions | 全图 — SVG原生绘制功能组成 | breathing |
| 7 Data Flow | 全图 — SVG原生绘制数据流 | breathing |
| 8 M1 Module | 左侧能力列表 + 右侧截图 | dense |
| 9 M2 Module | 左侧能力列表 + 右侧截图 | dense |
| 10 M3 Module | 左侧能力列表 + 右侧截图 | dense |
| 11 Interfaces | 全图 — SVG原生绘制接口关系 | breathing |
| 12 UI Showcase | 2×3截图网格 | dense |
| 13 Test Results | 左侧大数字统计 + 右侧模块卡片 + 底部工具标签 | dense |
| 14 Summary | 深色背景 + 左侧成果 + 右侧交付清单 | breathing |

---

## VI. Icon Strategy

- **Library**: chunk-filled
- **Inventory**: target, bolt, shield, users, chart-bar, lightbulb, database, server, search, book, file, layers, lock-closed, code, checkmark, globe, grid, box

---

## VII. Visualization

No data charts. All diagram pages are hand-drawn SVG with native shapes.

---

## VIII. Image Resource List

| ID | Filename | Source | Acquire Via | Status | Placement |
| -- | -------- | ------ | ----------- | ------ | --------- |
| img-01 | 10-知识库管理页.png | user | user | Ready | Page 8 M1 |
| img-02 | 04-知识检索页.png | user | user | Ready | Page 9 M2 |
| img-03 | 03-智能问答页.png | user | user | Ready | Page 10 M3 |
| img-04 | 01-登录页.png | user | user | Ready | Page 12 |
| img-05 | 02-首页主界面.png | user | user | Ready | Page 12 |
| img-06 | 05-配置助理页.png | user | user | Ready | Page 12 |
| img-07 | 09-模型管理页.png | user | user | Ready | Page 12 |
| img-08 | 12-参数设置页.png | user | user | Ready | Page 12 |
| img-09 | 11-用户管理页.png | user | user | Ready | Page 12 |

---

## IX. Content Outline

### Page 1: 封面
- Title: DARPA智能问答服务工具
- Subtitle: DARPA-IQAS V1.0 项目汇报
- Info: 研究内容四 | 军事科学院 | 2026年6月
- 右侧: 三级架构示意色块 (M1/M2/M3)

### Page 2: 项目概述
- 系统定位描述
- 核心特性列表 (离线运行/本地LLM/三级架构/军事文档适配/混合检索)
- 关键指标: 3模块 / 64用例 / 92%通过率

### Page 3: 三级架构设计
- SVG原生绘制三级架构图
- M1外挂知识库 → M2 RAG检索增强 → M3交互式提示词工程
- 层级间数据流箭头

### Page 4: 四层技术架构
- SVG原生绘制: 用户交互层 / 应用服务层 / 数据存储层 / 基础设施层
- 各层技术栈标注

### Page 5: 系统部署架构
- SVG原生绘制Docker Compose容器编排
- 7个服务容器 + 网络拓扑 + 数据卷

### Page 6: 功能组成
- SVG原生绘制三大模块功能组成
- M1/M2/M3各子功能

### Page 7: 数据流
- SVG原生绘制完整数据链路
- 文档上传 → 解析分块 → 向量索引 → 检索 → LLM生成 → 用户

### Page 8: M1 外挂知识库模块
- 左: 6项核心能力 (知识库CRUD/文档上传/解析/分块/标注/整合)
- 右: 知识库管理界面截图
- 底: 技术标签 (ragflow/MinIO/ES)

### Page 9: M2 RAG检索增强模块
- 左: 6项核心能力 (向量检索/混合检索/阈值/重排序/图谱/跨语言)
- 右: 知识检索界面截图
- 底: 技术标签

### Page 10: M3 交互式提示词工程模块
- 左: 6项核心能力 (助手管理/提示词/多轮对话/流式/溯源/模板)
- 右: 智能问答界面截图
- 底: 技术标签

### Page 11: 接口设计
- SVG原生绘制外部接口关系图

### Page 12: 系统界面展示
- 2×3截图网格 (登录/首页/问答/助理/模型/参数)

### Page 13: 测试验证
- 92%大数字 + 6模块测试结果卡片
- 测试技术栈标签

### Page 14: 总结与展望
- 深色背景
- 左: 已交付成果清单
- 右: 交付物清单
- 底: 项目信息一行

---

## X. Speaker Notes

Speaker notes generated in Executor phase.

---

## XI. Technical Constraints

- SVG viewBox: `0 0 1280 720`
- All colors from spec_lock.md
- All fonts from spec_lock.md
- Images: crop+embed via finalize_svg.py
- Architecture diagrams: SVG native shapes (rect, text, line, path) — no embedded images
- Screenshots: user-provided PNG, embedded as images
- No formulas needed (text-only policy)
