"""Batch generate remaining common diagrams for DARPA IQAS documents."""
import sys, os
sys.stdout.reconfigure(encoding='utf-8')
os.environ['PATH'] = r'C:\Program Files\GTK3-Runtime Win64\bin;' + os.environ['PATH']

import cairosvg

OUT = 'docs/output/images'

def write_svg(name, content):
    svg_path = os.path.join(OUT, f'{name}.svg')
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(content)
    return svg_path

def to_png(svg_path):
    png_path = svg_path.replace('.svg', '.png')
    cairosvg.svg2png(url=svg_path, write_to=png_path, scale=2)
    print(f'  OK: {os.path.basename(png_path)}')

FONT = '"Microsoft YaHei", "SimHei", Arial, sans-serif'

# ── 1. 功能组成图 ──────────────────────────────────────
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 520" width="960" height="520">
<style>text {{ font-family: {FONT}; }}</style>
<defs>
  <marker id="a1" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0,10 3.5,0 7" fill="#2563eb"/></marker>
  <filter id="s1" x="-4%" y="-4%" width="108%" height="108%"><feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.08"/></filter>
</defs>
<rect width="960" height="520" fill="#ffffff"/>
<text x="480" y="30" text-anchor="middle" fill="#111827" font-size="18" font-weight="600">DARPA智能问答服务工具 — 功能组成</text>

<!-- Center box -->
<rect x="340" y="50" width="280" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5" filter="url(#s1)"/>
<text x="480" y="80" text-anchor="middle" fill="#111827" font-size="14" font-weight="600">DARPA智能问答服务工具</text>

<!-- M1 -->
<rect x="30" y="150" width="280" height="44" rx="8" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.5" filter="url(#s1)"/>
<text x="170" y="177" text-anchor="middle" fill="#16a34a" font-size="13" font-weight="600">M1 外挂知识库模块</text>
<rect x="30" y="204" width="130" height="36" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1"/>
<text x="95" y="226" text-anchor="middle" fill="#111827" font-size="11">知识库CRUD</text>
<rect x="170" y="204" width="130" height="36" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1"/>
<text x="235" y="226" text-anchor="middle" fill="#111827" font-size="11">文档解析与分块</text>
<rect x="30" y="248" width="130" height="36" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1"/>
<text x="95" y="270" text-anchor="middle" fill="#111827" font-size="11">元数据标注过滤</text>
<rect x="170" y="248" width="130" height="36" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1"/>
<text x="235" y="270" text-anchor="middle" fill="#111827" font-size="11">多源数据整合</text>
<line x1="170" y1="150" x2="400" y2="100" stroke="#16a34a" stroke-width="1.2" marker-end="url(#a1)"/>

<!-- M2 -->
<rect x="340" y="150" width="280" height="44" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5" filter="url(#s1)"/>
<text x="480" y="177" text-anchor="middle" fill="#2563eb" font-size="13" font-weight="600">M2 RAG检索增强模块</text>
<rect x="340" y="204" width="130" height="36" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1"/>
<text x="405" y="226" text-anchor="middle" fill="#111827" font-size="11">向量语义检索</text>
<rect x="480" y="204" width="130" height="36" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1"/>
<text x="545" y="226" text-anchor="middle" fill="#111827" font-size="11">混合特征检索</text>
<rect x="340" y="248" width="130" height="36" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1"/>
<text x="405" y="270" text-anchor="middle" fill="#111827" font-size="11">重排序/跨语言</text>
<rect x="480" y="248" width="130" height="36" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1"/>
<text x="545" y="270" text-anchor="middle" fill="#111827" font-size="11">知识图谱检索</text>
<line x1="480" y1="150" x2="480" y2="100" stroke="#2563eb" stroke-width="1.2" marker-end="url(#a1)"/>

<!-- M3 -->
<rect x="650" y="150" width="280" height="44" rx="8" fill="#faf5ff" stroke="#9333ea" stroke-width="1.5" filter="url(#s1)"/>
<text x="790" y="177" text-anchor="middle" fill="#9333ea" font-size="13" font-weight="600">M3 交互式提示词工程</text>
<rect x="650" y="204" width="130" height="36" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1"/>
<text x="715" y="226" text-anchor="middle" fill="#111827" font-size="11">动态模板引擎</text>
<rect x="790" y="204" width="130" height="36" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1"/>
<text x="855" y="226" text-anchor="middle" fill="#111827" font-size="11">结构化约束</text>
<rect x="650" y="248" width="130" height="36" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1"/>
<text x="715" y="270" text-anchor="middle" fill="#111827" font-size="11">多轮对话/引用</text>
<rect x="790" y="248" width="130" height="36" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1"/>
<text x="855" y="270" text-anchor="middle" fill="#111827" font-size="11">系统提示词</text>
<line x1="790" y1="150" x2="560" y2="100" stroke="#9333ea" stroke-width="1.2" marker-end="url(#a1)"/>

<!-- Cross-module flows -->
<rect x="80" y="330" width="800" height="44" rx="8" fill="#f9fafb" stroke="#d1d5db" stroke-width="1.2"/>
<text x="480" y="356" text-anchor="middle" fill="#6b7280" font-size="12">集成支撑：用户认证(JWT) · 知识库-会话绑定 · 流式代理 · 离线容器化部署</text>

<!-- Bottom: deployment -->
<rect x="180" y="410" width="600" height="44" rx="8" fill="#fff7ed" stroke="#fed7aa" stroke-width="1.2"/>
<text x="480" y="436" text-anchor="middle" fill="#9a3412" font-size="12">离线部署：Docker Compose · ragflow v0.18.0 · GLM-9B本地推理 · 无外网依赖</text>

<rect x="180" y="470" width="600" height="36" rx="6" fill="#f9fafb" stroke="#d1d5db" stroke-width="1"/>
<text x="480" y="492" text-anchor="middle" fill="#6b7280" font-size="11">测试覆盖：48条自动化用例(pytest + Playwright) · 6大模块 · 端到端验证</text>
</svg>'''
to_png(write_svg('功能组成图', svg))

# ── 2. 系统部署关系图 ──────────────────────────────────
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 620" width="960" height="620">
<style>text {{ font-family: {FONT}; }}</style>
<defs>
  <marker id="ab" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0,10 3.5,0 7" fill="#2563eb"/></marker>
  <marker id="ag" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0,10 3.5,0 7" fill="#16a34a"/></marker>
  <filter id="s1" x="-4%" y="-4%" width="108%" height="108%"><feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.08"/></filter>
</defs>
<rect width="960" height="620" fill="#ffffff"/>
<text x="480" y="28" text-anchor="middle" fill="#111827" font-size="18" font-weight="600">DARPA智能问答服务工具 — 系统部署关系</text>

<!-- User -->
<rect x="390" y="48" width="180" height="40" rx="8" fill="#f9fafb" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="480" y="72" text-anchor="middle" fill="#111827" font-size="13">用户浏览器</text>
<line x1="480" y1="88" x2="480" y2="118" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<text x="500" y="108" fill="#6b7280" font-size="10">:8899</text>

<!-- gaisoft-frontend -->
<rect x="330" y="120" width="300" height="44" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.2" filter="url(#s1)"/>
<text x="480" y="138" text-anchor="middle" fill="#2563eb" font-size="12" font-weight="600">前端界面</text>
<text x="480" y="155" text-anchor="middle" fill="#6b7280" font-size="10">Vue 3 + nginx :8899</text>
<line x1="480" y1="164" x2="480" y2="194" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<text x="500" y="184" fill="#6b7280" font-size="10">HTTP</text>

<!-- gaisoft-server -->
<rect x="310" y="196" width="340" height="50" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5" filter="url(#s1)"/>
<text x="480" y="218" text-anchor="middle" fill="#2563eb" font-size="13" font-weight="600">应用服务层 (Spring Boot)</text>
<text x="480" y="236" text-anchor="middle" fill="#6b7280" font-size="10">知识库管理 · 检索服务 · 对话服务 · 认证鉴权 :8088</text>
<line x1="480" y1="246" x2="480" y2="278" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<text x="500" y="268" fill="#6b7280" font-size="10">REST API</text>

<!-- ragflow-server -->
<rect x="310" y="280" width="340" height="50" rx="8" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.5" filter="url(#s1)"/>
<text x="480" y="302" text-anchor="middle" fill="#16a34a" font-size="13" font-weight="600">RAG引擎 (ragflow v0.18.0)</text>
<text x="480" y="320" text-anchor="middle" fill="#6b7280" font-size="10">文档解析 · 向量检索 · LLM对话(GPT-4B) · MCP :8070/:9380</text>

<!-- Arrows from ragflow to storage layer -->
<line x1="380" y1="330" x2="160" y2="380" stroke="#16a34a" stroke-width="1.2" marker-end="url(#ag)"/>
<line x1="480" y1="330" x2="480" y2="380" stroke="#16a34a" stroke-width="1.2" marker-end="url(#ag)"/>
<line x1="580" y1="330" x2="790" y2="380" stroke="#16a34a" stroke-width="1.2" marker-end="url(#ag)"/>

<!-- MySQL -->
<rect x="60" y="384" width="200" height="44" rx="8" fill="#fff" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="160" y="404" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">MySQL 8.0</text>
<text x="160" y="420" text-anchor="middle" fill="#6b7280" font-size="10">rag_flow + darpa_iqas :5455</text>

<!-- ES -->
<rect x="370" y="384" width="220" height="44" rx="8" fill="#fff" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="480" y="404" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">Elasticsearch 8.11</text>
<text x="480" y="420" text-anchor="middle" fill="#6b7280" font-size="10">向量索引 + 全文检索 :1200</text>

<!-- Redis + MinIO -->
<rect x="660" y="384" width="240" height="44" rx="8" fill="#fff" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="780" y="404" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">Redis(Valkey) + MinIO</text>
<text x="780" y="420" text-anchor="middle" fill="#6b7280" font-size="10">缓存:6580 · 对象存储:9100</text>

<!-- gaisoft-server to MySQL direct -->
<line x1="340" y1="240" x2="200" y2="384" stroke="#2563eb" stroke-width="1" stroke-dasharray="5,3" marker-end="url(#ab)"/>
<text x="250" y="310" fill="#6b7280" font-size="10">JDBC</text>

<!-- Docker network label -->
<rect x="40" y="460" width="880" height="40" rx="8" fill="#f9fafb" stroke="#d1d5db" stroke-width="1" stroke-dasharray="6,3"/>
<text x="480" y="484" text-anchor="middle" fill="#6b7280" font-size="12">Docker Bridge Network (docker_ragflow) · 所有容器共享网络 · 服务名互访</text>

<!-- Offline deployment -->
<rect x="240" y="530" width="480" height="40" rx="8" fill="#fff7ed" stroke="#fed7aa" stroke-width="1.2"/>
<text x="480" y="554" text-anchor="middle" fill="#9a3412" font-size="12">离线部署：offline-load.sh 加载镜像 → start.sh demo 启动 → 无外网依赖运行</text>

<!-- Legend -->
<g transform="translate(40,590)">
  <line x1="0" y1="8" x2="30" y2="8" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
  <text x="36" y="12" fill="#6b7280" font-size="10">请求/数据流</text>
  <line x1="140" y1="8" x2="170" y2="8" stroke="#16a34a" stroke-width="1.5" marker-end="url(#ag)"/>
  <text x="176" y="12" fill="#6b7280" font-size="10">存储访问</text>
</g>
</svg>'''
to_png(write_svg('系统部署关系图', svg))

# ── 3. 四层技术架构图 ──────────────────────────────────
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 500" width="960" height="500">
<style>text {{ font-family: {FONT}; }}</style>
<defs><filter id="s1" x="-4%" y="-4%" width="108%" height="108%"><feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.08"/></filter></defs>
<rect width="960" height="500" fill="#ffffff"/>
<text x="480" y="28" text-anchor="middle" fill="#111827" font-size="18" font-weight="600">DARPA智能问答服务工具 — 四层技术体系结构</text>

<!-- Layer 1: Presentation -->
<rect x="40" y="50" width="880" height="80" rx="10" fill="#faf5ff" stroke="#c4b5fd" stroke-width="1.5"/>
<text x="60" y="72" fill="#7c3aed" font-size="13" font-weight="600">展示层</text>
<rect x="200" y="60" width="160" height="50" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1" filter="url(#s1)"/>
<text x="280" y="82" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">Vue 3 前端</text>
<text x="280" y="100" text-anchor="middle" fill="#6b7280" font-size="10">知识库/对话/管理界面</text>
<rect x="400" y="60" width="160" height="50" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1" filter="url(#s1)"/>
<text x="480" y="82" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">nginx 反向代理</text>
<text x="480" y="100" text-anchor="middle" fill="#6b7280" font-size="10">路由/负载/SSL</text>
<rect x="600" y="60" width="160" height="50" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1" filter="url(#s1)"/>
<text x="680" y="82" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">SSE 流式推送</text>
<text x="680" y="100" text-anchor="middle" fill="#6b7280" font-size="10">实时对话输出</text>

<!-- Layer 2: Business -->
<rect x="40" y="150" width="880" height="80" rx="10" fill="#eff6ff" stroke="#93c5fd" stroke-width="1.5"/>
<text x="60" y="172" fill="#2563eb" font-size="13" font-weight="600">业务层</text>
<rect x="140" y="160" width="180" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="230" y="182" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">M1 知识库管理</text>
<text x="230" y="200" text-anchor="middle" fill="#6b7280" font-size="10">CRUD/文档/分块</text>
<rect x="390" y="160" width="180" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="480" y="182" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">M2 检索增强服务</text>
<text x="480" y="200" text-anchor="middle" fill="#6b7280" font-size="10">向量/混合/重排序</text>
<rect x="640" y="160" width="180" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="730" y="182" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">M3 提示词工程</text>
<text x="730" y="200" text-anchor="middle" fill="#6b7280" font-size="10">模板/对话/引用</text>

<!-- Layer 3: Engine -->
<rect x="40" y="250" width="880" height="80" rx="10" fill="#f0fdf4" stroke="#86efac" stroke-width="1.5"/>
<text x="60" y="272" fill="#16a34a" font-size="13" font-weight="600">引擎层</text>
<rect x="140" y="260" width="180" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="230" y="282" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">ragflow v0.18.0</text>
<text x="230" y="300" text-anchor="middle" fill="#6b7280" font-size="10">RAG核心引擎</text>
<rect x="390" y="260" width="180" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="480" y="282" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">GLM-9B 本地推理</text>
<text x="480" y="300" text-anchor="middle" fill="#6b7280" font-size="10">离线LLM对话生成</text>
<rect x="640" y="260" width="180" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="730" y="282" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">文档解析引擎</text>
<text x="730" y="300" text-anchor="middle" fill="#6b7280" font-size="10">多格式深度解析</text>

<!-- Layer 4: Data -->
<rect x="40" y="350" width="880" height="80" rx="10" fill="#fff7ed" stroke="#fed7aa" stroke-width="1.5"/>
<text x="60" y="372" fill="#9a3412" font-size="13" font-weight="600">数据层</text>
<rect x="80" y="360" width="180" height="50" rx="6" fill="#fff" stroke="#fdba74" stroke-width="1" filter="url(#s1)"/>
<text x="170" y="382" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">MySQL 8.0</text>
<text x="170" y="400" text-anchor="middle" fill="#6b7280" font-size="10">结构化数据存储</text>
<rect x="300" y="360" width="180" height="50" rx="6" fill="#fff" stroke="#fdba74" stroke-width="1" filter="url(#s1)"/>
<text x="390" y="382" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">Elasticsearch</text>
<text x="390" y="400" text-anchor="middle" fill="#6b7280" font-size="10">向量+全文索引</text>
<rect x="520" y="360" width="180" height="50" rx="6" fill="#fff" stroke="#fdba74" stroke-width="1" filter="url(#s1)"/>
<text x="610" y="382" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">MinIO</text>
<text x="610" y="400" text-anchor="middle" fill="#6b7280" font-size="10">文档对象存储</text>
<rect x="740" y="360" width="150" height="50" rx="6" fill="#fff" stroke="#fdba74" stroke-width="1" filter="url(#s1)"/>
<text x="815" y="382" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">Redis/Valkey</text>
<text x="815" y="400" text-anchor="middle" fill="#6b7280" font-size="10">缓存与会话</text>

<!-- Infra -->
<rect x="40" y="454" width="880" height="36" rx="6" fill="#f9fafb" stroke="#d1d5db" stroke-width="1" stroke-dasharray="6,3"/>
<text x="480" y="476" text-anchor="middle" fill="#6b7280" font-size="11">基础设施层：Docker Compose 容器编排 · 离线镜像交付 · Linux 服务器部署</text>
</svg>'''
to_png(write_svg('四层技术架构图', svg))

# ── 4. 数据流图 ────────────────────────────────────────
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 400" width="960" height="400">
<style>text {{ font-family: {FONT}; }}</style>
<defs>
  <marker id="ab" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0,10 3.5,0 7" fill="#2563eb"/></marker>
  <marker id="ap" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0,10 3.5,0 7" fill="#9333ea"/></marker>
  <marker id="ag" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0,10 3.5,0 7" fill="#16a34a"/></marker>
  <filter id="s1" x="-4%" y="-4%" width="108%" height="108%"><feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.08"/></filter>
</defs>
<rect width="960" height="400" fill="#ffffff"/>
<text x="480" y="28" text-anchor="middle" fill="#111827" font-size="18" font-weight="600">DARPA智能问答服务工具 — 数据流图</text>

<!-- Row 1: Knowledge ingestion flow -->
<rect x="40" y="50" width="880" height="100" rx="10" fill="#f0fdf4" stroke="#86efac" stroke-width="1.2" stroke-dasharray="6,3"/>
<text x="60" y="70" fill="#16a34a" font-size="11" font-weight="600">知识入库流</text>
<rect x="60" y="80" width="120" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="120" y="100" text-anchor="middle" fill="#111827" font-size="11">军事文档</text>
<text x="120" y="116" text-anchor="middle" fill="#6b7280" font-size="9">PDF/Word/...</text>
<rect x="240" y="80" width="120" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="300" y="100" text-anchor="middle" fill="#111827" font-size="11">深度解析</text>
<text x="300" y="116" text-anchor="middle" fill="#6b7280" font-size="9">表格/图文</text>
<rect x="420" y="80" width="120" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="480" y="100" text-anchor="middle" fill="#111827" font-size="11">语义化分块</text>
<text x="480" y="116" text-anchor="middle" fill="#6b7280" font-size="9">段落/章节</text>
<rect x="600" y="80" width="120" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="660" y="100" text-anchor="middle" fill="#111827" font-size="11">向量化索引</text>
<text x="660" y="116" text-anchor="middle" fill="#6b7280" font-size="9">Embedding</text>
<rect x="780" y="80" width="120" height="50" rx="6" fill="#fff" stroke="#6ee7b7" stroke-width="1" filter="url(#s1)"/>
<text x="840" y="100" text-anchor="middle" fill="#111827" font-size="11">ES+MinIO</text>
<text x="840" y="116" text-anchor="middle" fill="#6b7280" font-size="9">持久存储</text>

<line x1="180" y1="105" x2="240" y2="105" stroke="#16a34a" stroke-width="1.5" marker-end="url(#ag)"/>
<line x1="360" y1="105" x2="420" y2="105" stroke="#16a34a" stroke-width="1.5" marker-end="url(#ag)"/>
<line x1="540" y1="105" x2="600" y2="105" stroke="#16a34a" stroke-width="1.5" marker-end="url(#ag)"/>
<line x1="720" y1="105" x2="780" y2="105" stroke="#16a34a" stroke-width="1.5" marker-end="url(#ag)"/>

<!-- Row 2: Query flow -->
<rect x="40" y="170" width="880" height="100" rx="10" fill="#eff6ff" stroke="#93c5fd" stroke-width="1.2" stroke-dasharray="6,3"/>
<text x="60" y="190" fill="#2563eb" font-size="11" font-weight="600">问答检索流</text>
<rect x="60" y="200" width="120" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="120" y="220" text-anchor="middle" fill="#111827" font-size="11">用户提问</text>
<text x="120" y="236" text-anchor="middle" fill="#6b7280" font-size="9">自然语言</text>
<rect x="240" y="200" width="120" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="300" y="220" text-anchor="middle" fill="#111827" font-size="11">混合检索</text>
<text x="300" y="236" text-anchor="middle" fill="#6b7280" font-size="9">向量+关键词</text>
<rect x="420" y="200" width="120" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="480" y="220" text-anchor="middle" fill="#111827" font-size="11">重排序</text>
<text x="480" y="236" text-anchor="middle" fill="#6b7280" font-size="9">Reranking</text>
<rect x="600" y="200" width="120" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="660" y="220" text-anchor="middle" fill="#111827" font-size="11">提示构建</text>
<text x="660" y="236" text-anchor="middle" fill="#6b7280" font-size="9">模板+约束</text>
<rect x="780" y="200" width="120" height="50" rx="6" fill="#fff" stroke="#7dd3fc" stroke-width="1" filter="url(#s1)"/>
<text x="840" y="220" text-anchor="middle" fill="#111827" font-size="11">LLM生成</text>
<text x="840" y="236" text-anchor="middle" fill="#6b7280" font-size="9">GLM-9B</text>

<line x1="180" y1="225" x2="240" y2="225" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<line x1="360" y1="225" x2="420" y2="225" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<line x1="540" y1="225" x2="600" y2="225" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<line x1="720" y1="225" x2="780" y2="225" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>

<!-- Row 3: Response flow -->
<rect x="40" y="290" width="880" height="80" rx="10" fill="#faf5ff" stroke="#c4b5fd" stroke-width="1.2" stroke-dasharray="6,3"/>
<text x="60" y="310" fill="#9333ea" font-size="11" font-weight="600">响应输出流</text>
<rect x="140" y="316" width="140" height="40" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1" filter="url(#s1)"/>
<text x="210" y="340" text-anchor="middle" fill="#111827" font-size="11">引用溯源标注</text>
<rect x="340" y="316" width="140" height="40" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1" filter="url(#s1)"/>
<text x="410" y="340" text-anchor="middle" fill="#111827" font-size="11">SSE流式输出</text>
<rect x="540" y="316" width="140" height="40" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1" filter="url(#s1)"/>
<text x="610" y="340" text-anchor="middle" fill="#111827" font-size="11">多轮上下文</text>
<rect x="740" y="316" width="140" height="40" rx="6" fill="#fff" stroke="#c4b5fd" stroke-width="1" filter="url(#s1)"/>
<text x="810" y="340" text-anchor="middle" fill="#111827" font-size="11">用户浏览器</text>

<line x1="280" y1="336" x2="340" y2="336" stroke="#9333ea" stroke-width="1.5" marker-end="url(#ap)"/>
<line x1="480" y1="336" x2="540" y2="336" stroke="#9333ea" stroke-width="1.5" marker-end="url(#ap)"/>
<line x1="680" y1="336" x2="740" y2="336" stroke="#9333ea" stroke-width="1.5" marker-end="url(#ap)"/>

<!-- Connect row2 to row3 -->
<line x1="840" y1="250" x2="810" y2="316" stroke="#9333ea" stroke-width="1" stroke-dasharray="4,2"/>

<g transform="translate(40,384)">
  <line x1="0" y1="6" x2="25" y2="6" stroke="#16a34a" stroke-width="1.5" marker-end="url(#ag)"/>
  <text x="30" y="10" fill="#6b7280" font-size="10">知识入库</text>
  <line x1="110" y1="6" x2="135" y2="6" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
  <text x="140" y="10" fill="#6b7280" font-size="10">问答检索</text>
  <line x1="220" y1="6" x2="245" y2="6" stroke="#9333ea" stroke-width="1.5" marker-end="url(#ap)"/>
  <text x="250" y="10" fill="#6b7280" font-size="10">响应输出</text>
</g>
</svg>'''
to_png(write_svg('数据流图', svg))

# ── 5. 外部接口关系图 ──────────────────────────────────
svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 440" width="960" height="440">
<style>text {{ font-family: {FONT}; }}</style>
<defs>
  <marker id="ab" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0,10 3.5,0 7" fill="#2563eb"/></marker>
  <filter id="s1" x="-4%" y="-4%" width="108%" height="108%"><feDropShadow dx="0" dy="2" stdDeviation="3" flood-opacity="0.08"/></filter>
</defs>
<rect width="960" height="440" fill="#ffffff"/>
<text x="480" y="28" text-anchor="middle" fill="#111827" font-size="18" font-weight="600">DARPA智能问答服务工具 — 外部接口关系</text>

<!-- Browser -->
<rect x="60" y="70" width="140" height="60" rx="8" fill="#f9fafb" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="130" y="96" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">用户浏览器</text>
<text x="130" y="114" text-anchor="middle" fill="#6b7280" font-size="10">HTTP :8899</text>

<!-- nginx -->
<rect x="280" y="70" width="140" height="60" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.2" filter="url(#s1)"/>
<text x="350" y="96" text-anchor="middle" fill="#2563eb" font-size="12" font-weight="600">nginx</text>
<text x="350" y="114" text-anchor="middle" fill="#6b7280" font-size="10">反向代理/路由</text>

<!-- gaisoft-server -->
<rect x="500" y="50" width="180" height="90" rx="8" fill="#eff6ff" stroke="#2563eb" stroke-width="1.5" filter="url(#s1)"/>
<text x="590" y="72" text-anchor="middle" fill="#2563eb" font-size="12" font-weight="600">应用服务层</text>
<text x="590" y="90" text-anchor="middle" fill="#111827" font-size="10">Spring Boot :8088</text>
<text x="590" y="108" text-anchor="middle" fill="#6b7280" font-size="9">/api/knowledge/**</text>
<text x="590" y="122" text-anchor="middle" fill="#6b7280" font-size="9">/api/chat/** /api/auth/**</text>

<!-- ragflow -->
<rect x="500" y="190" width="180" height="90" rx="8" fill="#f0fdf4" stroke="#16a34a" stroke-width="1.5" filter="url(#s1)"/>
<text x="590" y="212" text-anchor="middle" fill="#16a34a" font-size="12" font-weight="600">RAG引擎</text>
<text x="590" y="230" text-anchor="middle" fill="#111827" font-size="10">ragflow v0.18.0</text>
<text x="590" y="248" text-anchor="middle" fill="#6b7280" font-size="9">/api/v1/datasets</text>
<text x="590" y="262" text-anchor="middle" fill="#6b7280" font-size="9">/api/v1/chats /api/v1/retrieval</text>

<!-- MySQL -->
<rect x="200" y="210" width="140" height="60" rx="8" fill="#fff" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="270" y="236" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">MySQL 8.0</text>
<text x="270" y="254" text-anchor="middle" fill="#6b7280" font-size="10">:5455</text>

<!-- ES -->
<rect x="760" y="190" width="140" height="60" rx="8" fill="#fff" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="830" y="216" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">Elasticsearch</text>
<text x="830" y="234" text-anchor="middle" fill="#6b7280" font-size="10">:1200</text>

<!-- GLM-9B -->
<rect x="760" y="280" width="140" height="60" rx="8" fill="#faf5ff" stroke="#c4b5fd" stroke-width="1.2" filter="url(#s1)"/>
<text x="830" y="306" text-anchor="middle" fill="#7c3aed" font-size="12" font-weight="600">GLM-9B</text>
<text x="830" y="324" text-anchor="middle" fill="#6b7280" font-size="10">本地推理</text>

<!-- MinIO -->
<rect x="200" y="310" width="140" height="60" rx="8" fill="#fff" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="270" y="336" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">MinIO</text>
<text x="270" y="354" text-anchor="middle" fill="#6b7280" font-size="10">:9100</text>

<!-- Redis -->
<rect x="420" y="340" width="140" height="60" rx="8" fill="#fff" stroke="#d1d5db" stroke-width="1.2" filter="url(#s1)"/>
<text x="490" y="366" text-anchor="middle" fill="#111827" font-size="12" font-weight="600">Redis/Valkey</text>
<text x="490" y="384" text-anchor="middle" fill="#6b7280" font-size="10">:6580</text>

<!-- Arrows -->
<line x1="200" y1="100" x2="280" y2="100" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<line x1="420" y1="95" x2="500" y2="90" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<line x1="590" y1="140" x2="590" y2="190" stroke="#2563eb" stroke-width="1.5" marker-end="url(#ab)"/>
<text x="604" y="168" fill="#6b7280" font-size="9">REST API</text>

<line x1="500" y1="115" x2="340" y2="210" stroke="#2563eb" stroke-width="1" stroke-dasharray="4,2" marker-end="url(#ab)"/>
<text x="390" y="160" fill="#6b7280" font-size="9">JDBC</text>

<line x1="680" y1="230" x2="760" y2="218" stroke="#16a34a" stroke-width="1.2" marker-end="url(#ab)"/>
<line x1="680" y1="245" x2="760" y2="300" stroke="#9333ea" stroke-width="1.2" marker-end="url(#ab)"/>
<text x="730" y="284" fill="#6b7280" font-size="9">LLM调用</text>

<line x1="500" y1="255" x2="340" y2="230" stroke="#16a34a" stroke-width="1" stroke-dasharray="4,2" marker-end="url(#ab)"/>
<line x1="520" y1="270" x2="340" y2="320" stroke="#16a34a" stroke-width="1" stroke-dasharray="4,2" marker-end="url(#ab)"/>
<line x1="560" y1="280" x2="500" y2="340" stroke="#16a34a" stroke-width="1" stroke-dasharray="4,2" marker-end="url(#ab)"/>
</svg>'''
to_png(write_svg('外部接口关系图', svg))

print('\\nAll diagrams generated!')
