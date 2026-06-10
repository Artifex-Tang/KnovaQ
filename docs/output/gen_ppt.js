const pptxgen = require("pptxgenjs");
const path = require("path");

const pres = new pptxgen();
pres.layout = "LAYOUT_16x9"; // 10" x 5.625"
pres.author = "DARPA-IQAS Project Team";
pres.title = "DARPA智能问答服务工具 项目汇报";

// ─── Color Palette: Midnight Executive ───
const C = {
  navy:    "1E2761",
  ice:     "CADCFC",
  white:   "FFFFFF",
  dark:    "0F1A3E",
  accent:  "4A7BF7",
  accent2: "2DD4A8",
  gray:    "94A3B8",
  lightBg: "F1F5F9",
  text:    "1E293B",
  subtext: "475569",
  card:    "FFFFFF",
  tag:     "E0E7FF",
};

const imgDir = path.join(__dirname, "images");
const ssDir  = path.join(imgDir, "screenshots");

// Helper: fresh shadow object
const cardShadow = () => ({ type: "outer", blur: 4, offset: 2, angle: 135, color: "000000", opacity: 0.10 });
const makeShadow = cardShadow;

// Helper: add navy header bar + white title
function addHeader(slide, title, subtitle) {
  slide.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 1.0, fill: { color: C.navy } });
  slide.addText(title, { x: 0.6, y: 0.15, w: 8, h: 0.7, fontSize: 24, fontFace: "Arial Black", color: C.white, bold: true, margin: 0 });
  if (subtitle) {
    slide.addText(subtitle, { x: 0.6, y: 0.7, w: 8, h: 0.3, fontSize: 11, fontFace: "Arial", color: C.ice, margin: 0 });
  }
}

// Helper: page number
function addFooter(slide, num, total) {
  slide.addText(`${num} / ${total}`, { x: 8.8, y: 5.25, w: 1, h: 0.3, fontSize: 9, fontFace: "Arial", color: C.gray, align: "right", margin: 0 });
}

const TOTAL_SLIDES = 14;

// ════════════════════════════════════════════
// SLIDE 1 — Title
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.dark };
  // Decorative accent bar
  slide.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.12, h: 5.625, fill: { color: C.accent } });
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.12, y: 2.4, w: 4.5, h: 0.06, fill: { color: C.accent2 } });
  slide.addText("DARPA智能问答服务工具", { x: 0.5, y: 1.2, w: 9, h: 1.2, fontSize: 40, fontFace: "Arial Black", color: C.white, bold: true, margin: 0 });
  slide.addText("DARPA-IQAS V1.0", { x: 0.5, y: 2.0, w: 5, h: 0.5, fontSize: 22, fontFace: "Arial", color: C.accent2, bold: true, margin: 0 });
  slide.addText("项目汇报", { x: 0.5, y: 2.65, w: 5, h: 0.5, fontSize: 20, fontFace: "Arial", color: C.ice, margin: 0 });
  slide.addText("研究内容四 —— DARPA智能问答服务工具开发", { x: 0.5, y: 3.4, w: 8, h: 0.4, fontSize: 14, fontFace: "Arial", color: C.gray, margin: 0 });
  slide.addText("军事科学院军事科学信息研究中心", { x: 0.5, y: 3.85, w: 6, h: 0.35, fontSize: 13, fontFace: "Arial", color: C.gray, margin: 0 });
  slide.addText("2026年6月", { x: 0.5, y: 4.3, w: 3, h: 0.3, fontSize: 12, fontFace: "Arial", color: C.gray, margin: 0 });

  // Right side: mini architecture illustration
  slide.addShape(pres.shapes.RECTANGLE, { x: 6.5, y: 1.0, w: 3.0, h: 1.0, fill: { color: C.accent }, transparency: 80, rectRadius: 0.08 });
  slide.addText("M3 交互式提示词工程", { x: 6.5, y: 1.1, w: 3.0, h: 0.8, fontSize: 12, fontFace: "Arial", color: C.white, align: "center", valign: "middle", margin: 0 });

  slide.addShape(pres.shapes.RECTANGLE, { x: 6.5, y: 2.2, w: 3.0, h: 1.0, fill: { color: C.accent2 }, transparency: 70, rectRadius: 0.08 });
  slide.addText("M2 RAG检索增强", { x: 6.5, y: 2.3, w: 3.0, h: 0.8, fontSize: 12, fontFace: "Arial", color: C.white, align: "center", valign: "middle", margin: 0 });

  slide.addShape(pres.shapes.RECTANGLE, { x: 6.5, y: 3.4, w: 3.0, h: 1.0, fill: { color: C.navy }, transparency: 50, rectRadius: 0.08 });
  slide.addText("M1 外挂知识库", { x: 6.5, y: 3.5, w: 3.0, h: 0.8, fontSize: 12, fontFace: "Arial", color: C.white, align: "center", valign: "middle", margin: 0 });

  addFooter(slide, 1, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 2 — 项目概述
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "项目概述", "DARPA-IQAS V1.0");

  // Left column: description
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.3, w: 4.5, h: 3.8, fill: { color: C.card }, shadow: makeShadow() });
  slide.addText("系统定位", { x: 0.7, y: 1.4, w: 4.1, h: 0.35, fontSize: 15, fontFace: "Arial", color: C.navy, bold: true, margin: 0 });
  slide.addText([
    { text: "DARPA智能问答服务工具（DARPA-IQAS）是研究内容四的核心成果，面向DARPA国防高级研究计划局相关领域的军事文档智能问答场景。", options: { fontSize: 11, fontFace: "Arial", color: C.text, breakLine: true } },
    { text: "", options: { fontSize: 6, breakLine: true } },
    { text: "突破多源异构数据整合瓶颈，通过融合结构化知识管理与检索增强生成技术（RAG），打造具备高精度领域适应能力的离线智能问答系统。", options: { fontSize: 11, fontFace: "Arial", color: C.text, breakLine: true } },
  ], { x: 0.7, y: 1.8, w: 4.1, h: 1.5, valign: "top", margin: 0 });

  // Key stats
  const stats = [
    { label: "核心模块", value: "3" },
    { label: "测试用例", value: "64" },
    { label: "通过率", value: "92%" },
  ];
  stats.forEach((s, i) => {
    const bx = 0.7 + i * 1.45;
    slide.addShape(pres.shapes.RECTANGLE, { x: bx, y: 3.5, w: 1.3, h: 1.2, fill: { color: C.tag }, rectRadius: 0.06 });
    slide.addText(s.value, { x: bx, y: 3.55, w: 1.3, h: 0.6, fontSize: 28, fontFace: "Arial Black", color: C.navy, align: "center", valign: "middle", margin: 0 });
    slide.addText(s.label, { x: bx, y: 4.15, w: 1.3, h: 0.4, fontSize: 10, fontFace: "Arial", color: C.subtext, align: "center", valign: "middle", margin: 0 });
  });

  // Right column: key features
  slide.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.3, w: 4.3, h: 3.8, fill: { color: C.card }, shadow: makeShadow() });
  slide.addText("核心特性", { x: 5.4, y: 1.4, w: 4.0, h: 0.35, fontSize: 15, fontFace: "Arial", color: C.navy, bold: true, margin: 0 });

  const features = [
    { t: "完全离线运行", d: "Docker Compose容器化部署，无外网依赖" },
    { t: "本地大模型", d: "智谱GLM-9B本地部署，保障数据安全" },
    { t: "三级架构解耦", d: "知识库、检索增强、提示工程独立可扩展" },
    { t: "军事文档适配", d: "多格式文档深度解析与语义化处理" },
    { t: "混合检索", d: "向量语义检索+关键词检索多特征融合" },
  ];
  features.forEach((f, i) => {
    const fy = 1.85 + i * 0.62;
    slide.addShape(pres.shapes.RECTANGLE, { x: 5.4, y: fy, w: 0.06, h: 0.45, fill: { color: C.accent2 } });
    slide.addText(f.t, { x: 5.6, y: fy, w: 3.7, h: 0.25, fontSize: 12, fontFace: "Arial", color: C.text, bold: true, margin: 0 });
    slide.addText(f.d, { x: 5.6, y: fy + 0.22, w: 3.7, h: 0.22, fontSize: 9.5, fontFace: "Arial", color: C.subtext, margin: 0 });
  });

  addFooter(slide, 2, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 3 — 三级架构图
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "三级架构设计", '"外挂知识库—RAG检索增强—交互式提示" 三级架构');

  slide.addImage({
    path: path.join(imgDir, "三级架构图.png"),
    x: 0.5, y: 1.2, w: 9.0, h: 4.0,
    sizing: { type: "contain", w: 9.0, h: 4.0 },
  });

  addFooter(slide, 3, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 4 — 四层技术架构图
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "技术体系架构", "四层技术架构：用户交互层 / 应用服务层 / 数据存储层 / 基础设施层");

  slide.addImage({
    path: path.join(imgDir, "四层技术架构图.png"),
    x: 0.3, y: 1.15, w: 9.4, h: 4.1,
    sizing: { type: "contain", w: 9.4, h: 4.1 },
  });

  addFooter(slide, 4, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 5 — 系统部署关系图
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "部署架构", "Docker Compose容器化编排 · 离线部署 · 7个服务容器");

  slide.addImage({
    path: path.join(imgDir, "系统部署关系图.png"),
    x: 0.3, y: 1.15, w: 9.4, h: 4.1,
    sizing: { type: "contain", w: 9.4, h: 4.1 },
  });

  addFooter(slide, 5, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 6 — 功能组成图
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "功能组成", "三大核心模块 + 集成部署基础设施");

  slide.addImage({
    path: path.join(imgDir, "功能组成图.png"),
    x: 0.3, y: 1.15, w: 9.4, h: 4.1,
    sizing: { type: "contain", w: 9.4, h: 4.1 },
  });

  addFooter(slide, 6, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 7 — 数据流图
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "信息流程 / 数据流", "从文档上传到智能问答的完整数据链路");

  slide.addImage({
    path: path.join(imgDir, "数据流图.png"),
    x: 0.3, y: 1.15, w: 9.4, h: 4.1,
    sizing: { type: "contain", w: 9.4, h: 4.1 },
  });

  addFooter(slide, 7, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 8 — M1 外挂知识库模块
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "M1 外挂知识库模块", "第一级：军事文档深度加工与语义化重构");

  // Left: description
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.3, w: 4.5, h: 3.0, fill: { color: C.card }, shadow: makeShadow() });
  const m1Items = [
    "知识库CRUD — 创建、查看、编辑、删除知识库",
    "文档上传 — 支持PDF/Word/Excel/TXT/Markdown/图片",
    "文档解析 — 版面分析、表格提取、图文识别",
    "智能分块 — 多策略分块（通用/手册/Q&A/论文/法律/表格）",
    "元数据标注 — 自动/手动标注文档元数据",
    "多源异构数据整合 — 统一格式入库",
  ];
  slide.addText("核心能力", { x: 0.7, y: 1.4, w: 4.1, h: 0.3, fontSize: 14, fontFace: "Arial", color: C.navy, bold: true, margin: 0 });
  slide.addText(
    m1Items.map((item, i) => ({
      text: item,
      options: { bullet: true, breakLine: i < m1Items.length - 1, fontSize: 10.5, fontFace: "Arial", color: C.text },
    })),
    { x: 0.7, y: 1.75, w: 4.1, h: 2.4, valign: "top", paraSpaceAfter: 6, margin: 0 }
  );

  // Right: screenshot
  slide.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.3, w: 4.3, h: 3.0, fill: { color: C.card }, shadow: makeShadow() });
  slide.addText("知识库管理界面", { x: 5.4, y: 1.35, w: 3.9, h: 0.3, fontSize: 11, fontFace: "Arial", color: C.subtext, align: "center", margin: 0 });
  slide.addImage({
    path: path.join(ssDir, "10-知识库管理页.png"),
    x: 5.4, y: 1.7, w: 3.9, h: 2.4,
    sizing: { type: "contain", w: 3.9, h: 2.4 },
  });

  // Bottom: tech tags
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 4.5, w: 9.0, h: 0.8, fill: { color: C.card }, shadow: makeShadow() });
  const techTags = ["ragflow v0.18.0", "MinIO对象存储", "Elasticsearch向量索引", "多格式解析引擎"];
  techTags.forEach((tag, i) => {
    const tx = 0.7 + i * 2.2;
    slide.addShape(pres.shapes.RECTANGLE, { x: tx, y: 4.6, w: 2.0, h: 0.55, fill: { color: C.tag }, rectRadius: 0.06 });
    slide.addText(tag, { x: tx, y: 4.6, w: 2.0, h: 0.55, fontSize: 10, fontFace: "Arial", color: C.navy, align: "center", valign: "middle", margin: 0 });
  });

  addFooter(slide, 8, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 9 — M2 RAG检索增强模块
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "M2 RAG检索增强模块", "第二级：多维度混合检索与语义重排序");

  // Left: description
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.3, w: 4.5, h: 3.0, fill: { color: C.card }, shadow: makeShadow() });
  const m2Items = [
    "向量语义检索 — 基于Embedding的高维向量相似度匹配",
    "混合检索 — 向量检索+关键词检索双路召回",
    "相似度阈值调节 — 动态调节检索精度/召回率",
    "检索结果重排序 — 语义相关性二次排序",
    "知识图谱辅助 — GraphRAG图结构检索",
    "跨语言检索 — 支持中英文混合检索",
  ];
  slide.addText("核心能力", { x: 0.7, y: 1.4, w: 4.1, h: 0.3, fontSize: 14, fontFace: "Arial", color: C.navy, bold: true, margin: 0 });
  slide.addText(
    m2Items.map((item, i) => ({
      text: item,
      options: { bullet: true, breakLine: i < m2Items.length - 1, fontSize: 10.5, fontFace: "Arial", color: C.text },
    })),
    { x: 0.7, y: 1.75, w: 4.1, h: 2.4, valign: "top", paraSpaceAfter: 6, margin: 0 }
  );

  // Right: screenshot
  slide.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.3, w: 4.3, h: 3.0, fill: { color: C.card }, shadow: makeShadow() });
  slide.addText("知识检索界面", { x: 5.4, y: 1.35, w: 3.9, h: 0.3, fontSize: 11, fontFace: "Arial", color: C.subtext, align: "center", margin: 0 });
  slide.addImage({
    path: path.join(ssDir, "04-知识检索页.png"),
    x: 5.4, y: 1.7, w: 3.9, h: 2.4,
    sizing: { type: "contain", w: 3.9, h: 2.4 },
  });

  // Bottom tags
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 4.5, w: 9.0, h: 0.8, fill: { color: C.card }, shadow: makeShadow() });
  const m2Tags = ["Elasticsearch 8.11", "向量+全文混合", "语义重排序", "GraphRAG"];
  m2Tags.forEach((tag, i) => {
    const tx = 0.7 + i * 2.2;
    slide.addShape(pres.shapes.RECTANGLE, { x: tx, y: 4.6, w: 2.0, h: 0.55, fill: { color: C.tag }, rectRadius: 0.06 });
    slide.addText(tag, { x: tx, y: 4.6, w: 2.0, h: 0.55, fontSize: 10, fontFace: "Arial", color: C.navy, align: "center", valign: "middle", margin: 0 });
  });

  addFooter(slide, 9, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 10 — M3 交互式提示词工程模块
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "M3 交互式提示词工程模块", "第三级：用户意图对齐与结构化回答生成");

  // Left: description
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.3, w: 4.5, h: 3.0, fill: { color: C.card }, shadow: makeShadow() });
  const m3Items = [
    "聊天助手管理 — 创建、配置和管理专属AI助手",
    "系统提示词配置 — 定制助手角色、行为和回答规范",
    "多轮上下文对话 — 保持对话历史和上下文连贯",
    "流式响应输出 — 实时逐字输出，提升交互体验",
    "引用溯源 — 回答附带来源文档引用，可追溯验证",
    "提示模板定制 — 动态模板引擎支持结构化约束",
  ];
  slide.addText("核心能力", { x: 0.7, y: 1.4, w: 4.1, h: 0.3, fontSize: 14, fontFace: "Arial", color: C.navy, bold: true, margin: 0 });
  slide.addText(
    m3Items.map((item, i) => ({
      text: item,
      options: { bullet: true, breakLine: i < m3Items.length - 1, fontSize: 10.5, fontFace: "Arial", color: C.text },
    })),
    { x: 0.7, y: 1.75, w: 4.1, h: 2.4, valign: "top", paraSpaceAfter: 6, margin: 0 }
  );

  // Right: screenshot
  slide.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.3, w: 4.3, h: 3.0, fill: { color: C.card }, shadow: makeShadow() });
  slide.addText("智能问答界面", { x: 5.4, y: 1.35, w: 3.9, h: 0.3, fontSize: 11, fontFace: "Arial", color: C.subtext, align: "center", margin: 0 });
  slide.addImage({
    path: path.join(ssDir, "03-智能问答页.png"),
    x: 5.4, y: 1.7, w: 3.9, h: 2.4,
    sizing: { type: "contain", w: 3.9, h: 2.4 },
  });

  // Bottom tags
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 4.5, w: 9.0, h: 0.8, fill: { color: C.card }, shadow: makeShadow() });
  const m3Tags = ["GLM-9B本地LLM", "流式SSE响应", "引用溯源", "动态提示模板"];
  m3Tags.forEach((tag, i) => {
    const tx = 0.7 + i * 2.2;
    slide.addShape(pres.shapes.RECTANGLE, { x: tx, y: 4.6, w: 2.0, h: 0.55, fill: { color: C.tag }, rectRadius: 0.06 });
    slide.addText(tag, { x: tx, y: 4.6, w: 2.0, h: 0.55, fontSize: 10, fontFace: "Arial", color: C.navy, align: "center", valign: "middle", margin: 0 });
  });

  addFooter(slide, 10, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 11 — 接口设计
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "接口设计", "外部接口关系与内部接口设计");

  slide.addImage({
    path: path.join(imgDir, "外部接口关系图.png"),
    x: 0.3, y: 1.15, w: 9.4, h: 4.1,
    sizing: { type: "contain", w: 9.4, h: 4.1 },
  });

  addFooter(slide, 11, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 12 — 系统界面展示
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "系统界面展示", "主要功能页面截图");

  // 2x3 grid of screenshots
  const screenshots = [
    { file: "01-登录页.png", label: "用户登录" },
    { file: "02-首页主界面.png", label: "系统首页" },
    { file: "03-智能问答页.png", label: "智能问答" },
    { file: "05-配置助理页.png", label: "配置助理" },
    { file: "09-模型管理页.png", label: "模型管理" },
    { file: "12-参数设置页.png", label: "参数设置" },
  ];

  screenshots.forEach((ss, i) => {
    const col = i % 3;
    const row = Math.floor(i / 3);
    const bx = 0.4 + col * 3.15;
    const by = 1.2 + row * 2.05;
    // Card
    slide.addShape(pres.shapes.RECTANGLE, { x: bx, y: by, w: 2.95, h: 1.9, fill: { color: C.card }, shadow: makeShadow() });
    slide.addImage({
      path: path.join(ssDir, ss.file),
      x: bx + 0.05, y: by + 0.05, w: 2.85, h: 1.5,
      sizing: { type: "contain", w: 2.85, h: 1.5 },
    });
    slide.addText(ss.label, { x: bx, y: by + 1.55, w: 2.95, h: 0.3, fontSize: 10, fontFace: "Arial", color: C.subtext, align: "center", valign: "middle", margin: 0 });
  });

  addFooter(slide, 12, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 13 — 测试验证
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.lightBg };
  addHeader(slide, "测试验证", "64条自动化测试用例 · 92%通过率 · 6大测试模块");

  // Test module results - cards
  const modules = [
    { name: "M1 知识库", cases: 10, pass: 9,  rate: "90%" },
    { name: "M2 RAG检索", cases: 10, pass: 9,  rate: "90%" },
    { name: "M3 交互式", cases: 12, pass: 11, rate: "92%" },
    { name: "身份认证", cases: 10, pass: 10, rate: "100%" },
    { name: "UI端到端", cases: 14, pass: 13, rate: "93%" },
    { name: "菜单验证", cases: 8,  pass: 7,  rate: "88%" },
  ];

  // Big stat
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.3, w: 3.5, h: 1.8, fill: { color: C.navy }, shadow: makeShadow() });
  slide.addText("92%", { x: 0.5, y: 1.3, w: 3.5, h: 1.1, fontSize: 56, fontFace: "Arial Black", color: C.accent2, align: "center", valign: "middle", margin: 0 });
  slide.addText("综合通过率", { x: 0.5, y: 2.3, w: 3.5, h: 0.4, fontSize: 16, fontFace: "Arial", color: C.ice, align: "center", valign: "middle", margin: 0 });
  slide.addText("64条用例 · 59条通过 · 5条待优化", { x: 0.5, y: 2.65, w: 3.5, h: 0.3, fontSize: 10, fontFace: "Arial", color: C.gray, align: "center", valign: "middle", margin: 0 });

  // Module breakdown
  modules.forEach((m, i) => {
    const col = i % 3;
    const row = Math.floor(i / 3);
    const bx = 4.3 + col * 1.9;
    const by = 1.3 + row * 1.05;

    slide.addShape(pres.shapes.RECTANGLE, { x: bx, y: by, w: 1.75, h: 0.9, fill: { color: C.card }, shadow: makeShadow() });
    slide.addText(m.name, { x: bx + 0.05, y: by + 0.05, w: 1.65, h: 0.25, fontSize: 10, fontFace: "Arial", color: C.navy, bold: true, margin: 0 });
    slide.addText(m.rate, { x: bx + 0.05, y: by + 0.3, w: 1.65, h: 0.3, fontSize: 20, fontFace: "Arial Black", color: m.rate === "100%" ? C.accent2 : C.accent, margin: 0 });
    slide.addText(`${m.pass}/${m.cases} 通过`, { x: bx + 0.05, y: by + 0.6, w: 1.65, h: 0.25, fontSize: 9, fontFace: "Arial", color: C.subtext, margin: 0 });
  });

  // Test tools bar
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 3.6, w: 9.0, h: 1.6, fill: { color: C.card }, shadow: makeShadow() });
  slide.addText("测试技术栈", { x: 0.7, y: 3.65, w: 4.0, h: 0.3, fontSize: 13, fontFace: "Arial", color: C.navy, bold: true, margin: 0 });

  const tools = [
    { name: "pytest", desc: "自动化测试框架" },
    { name: "Playwright", desc: "UI端到端测试" },
    { name: "Allure", desc: "测试报告生成" },
    { name: "Docker", desc: "容器化测试环境" },
  ];
  tools.forEach((t, i) => {
    const tx = 0.7 + i * 2.2;
    slide.addShape(pres.shapes.RECTANGLE, { x: tx, y: 4.05, w: 2.0, h: 0.95, fill: { color: C.tag }, rectRadius: 0.06 });
    slide.addText(t.name, { x: tx, y: 4.1, w: 2.0, h: 0.45, fontSize: 13, fontFace: "Arial", color: C.navy, bold: true, align: "center", valign: "middle", margin: 0 });
    slide.addText(t.desc, { x: tx, y: 4.5, w: 2.0, h: 0.35, fontSize: 9, fontFace: "Arial", color: C.subtext, align: "center", valign: "middle", margin: 0 });
  });

  addFooter(slide, 13, TOTAL_SLIDES);
}

// ════════════════════════════════════════════
// SLIDE 14 — 总结
// ════════════════════════════════════════════
{
  const slide = pres.addSlide();
  slide.background = { color: C.dark };
  slide.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.12, h: 5.625, fill: { color: C.accent } });

  slide.addText("总结与展望", { x: 0.5, y: 0.5, w: 9, h: 0.7, fontSize: 32, fontFace: "Arial Black", color: C.white, bold: true, margin: 0 });

  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.3, w: 4.2, h: 0.06, fill: { color: C.accent2 } });

  // Left: achievements
  slide.addText("已交付成果", { x: 0.5, y: 1.6, w: 4.5, h: 0.35, fontSize: 16, fontFace: "Arial", color: C.accent2, bold: true, margin: 0 });
  const achievements = [
    "完成三级架构智能问答系统开发",
    "实现完全离线Docker容器化部署",
    "集成智谱GLM-9B本地大模型",
    "支持多格式军事文档智能处理",
    "64条自动化测试用例，92%通过率",
    "完整项目文档体系（需求/设计/测试/手册）",
  ];
  slide.addText(
    achievements.map((a, i) => ({
      text: a,
      options: { bullet: true, breakLine: i < achievements.length - 1, fontSize: 12, fontFace: "Arial", color: C.ice },
    })),
    { x: 0.5, y: 2.0, w: 4.5, h: 2.5, valign: "top", paraSpaceAfter: 5, margin: 0 }
  );

  // Right: deliverables
  slide.addShape(pres.shapes.RECTANGLE, { x: 5.3, y: 1.5, w: 4.2, h: 3.5, fill: { color: C.navy }, transparency: 40, rectRadius: 0.1 });
  slide.addText("交付物清单", { x: 5.5, y: 1.6, w: 3.8, h: 0.35, fontSize: 16, fontFace: "Arial", color: C.accent2, bold: true, margin: 0 });

  const deliverables = [
    { doc: "软件需求规格说明书", ver: "V1.0" },
    { doc: "软件设计说明书", ver: "V1.0" },
    { doc: "系统测试大纲", ver: "V1.0" },
    { doc: "系统测试报告", ver: "V1.0" },
    { doc: "软件用户手册", ver: "V1.0" },
    { doc: "离线Docker镜像包", ver: "—" },
    { doc: "自动化测试套件", ver: "48+16" },
  ];
  deliverables.forEach((d, i) => {
    const dy = 2.05 + i * 0.38;
    slide.addText(d.doc, { x: 5.7, y: dy, w: 2.8, h: 0.3, fontSize: 11, fontFace: "Arial", color: C.ice, margin: 0 });
    slide.addText(d.ver, { x: 8.5, y: dy, w: 0.8, h: 0.3, fontSize: 10, fontFace: "Arial", color: C.gray, align: "right", margin: 0 });
  });

  // Bottom line
  slide.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 4.9, w: 9.0, h: 0.04, fill: { color: C.accent }, transparency: 60 });
  slide.addText("DARPA智能问答服务工具 DARPA-IQAS V1.0  ·  军事科学院军事科学信息研究中心  ·  2026年6月", {
    x: 0.5, y: 5.05, w: 9.0, h: 0.35, fontSize: 10, fontFace: "Arial", color: C.gray, align: "center", valign: "middle", margin: 0,
  });

  addFooter(slide, 14, TOTAL_SLIDES);
}

// ─── Write file ───
const outPath = path.join(__dirname, "DARPA智能问答服务工具-项目汇报.pptx");
pres.writeFile({ fileName: outPath }).then(() => {
  console.log("PPT generated:", outPath);
}).catch(err => {
  console.error("Error:", err);
  process.exit(1);
});
