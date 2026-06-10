"""
Regenerate 功能组成图.png and ER图.png without 设备管理域 content.
Generates SVG then converts to PNG via cairosvg.
"""
import os
os.environ['PATH'] = r'C:\Program Files\GTK3-Runtime Win64\bin;' + os.environ['PATH']
import cairosvg
from pathlib import Path

IMG_DIR = Path(r'E:\ccode\KnovaQ\docs\output\images')

# ═══════════════════════════════════════════════════════════════
# 功能组成图 — Two domains: 智能问答域 + 系统管理域
# ═══════════════════════════════════════════════════════════════
svg_function = r'''<?xml version="1.0" encoding="UTF-8"?>
<svg width="1200" height="660" xmlns="http://www.w3.org/2000/svg" font-family="Microsoft YaHei, SimHei, Arial, sans-serif">
  <defs>
    <filter id="shadow" x="-2%" y="-2%" width="104%" height="104%">
      <feDropShadow dx="2" dy="2" stdDeviation="3" flood-color="#00000022"/>
    </filter>
    <linearGradient id="headerGrad" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0%" stop-color="#1565C0"/>
      <stop offset="100%" stop-color="#1976D2"/>
    </linearGradient>
    <linearGradient id="domainGrad1" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#E3F2FD"/>
      <stop offset="100%" stop-color="#BBDEFB"/>
    </linearGradient>
    <linearGradient id="domainGrad2" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#F3E5F5"/>
      <stop offset="100%" stop-color="#E1BEE7"/>
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="1200" height="660" fill="#FAFAFA" rx="8"/>

  <!-- Title -->
  <text x="600" y="38" text-anchor="middle" font-size="22" font-weight="bold" fill="#1A237E">DARPA智能问答服务工具 — 功能组成</text>

  <!-- Main container box -->
  <rect x="40" y="55" width="1120" height="580" rx="12" fill="none" stroke="#1565C0" stroke-width="2.5" stroke-dasharray="8,4"/>
  <rect x="48" y="48" width="200" height="24" fill="#FAFAFA"/>
  <text x="58" y="66" font-size="14" font-weight="bold" fill="#1565C0">DARPA智能问答服务工具</text>

  <!-- ═══ Domain 1: 智能问答域 ═══ -->
  <rect x="60" y="85" width="640" height="530" rx="10" fill="url(#domainGrad1)" stroke="#1976D2" stroke-width="2" filter="url(#shadow)"/>
  <!-- Domain 1 header -->
  <rect x="60" y="85" width="640" height="44" rx="10" fill="#1976D2"/>
  <rect x="60" y="105" width="640" height="24" fill="#1976D2"/>
  <text x="380" y="114" text-anchor="middle" font-size="17" font-weight="bold" fill="white">智能问答域</text>

  <!-- Sub-module: 知识库管理 -->
  <rect x="80" y="145" width="180" height="38" rx="6" fill="#FFFFFF" stroke="#42A5F5" stroke-width="1.5"/>
  <text x="170" y="170" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">知识库管理</text>
  <!-- Children -->
  <rect x="85" y="192" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="170" y="212" text-anchor="middle" font-size="12" fill="#2E7D32">创建/编辑/删除知识库</text>
  <rect x="85" y="228" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="170" y="248" text-anchor="middle" font-size="12" fill="#2E7D32">知识库分类管理</text>
  <rect x="85" y="264" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="170" y="284" text-anchor="middle" font-size="12" fill="#2E7D32">知识库配置</text>

  <!-- Sub-module: 文档上传与管理 -->
  <rect x="290" y="145" width="180" height="38" rx="6" fill="#FFFFFF" stroke="#42A5F5" stroke-width="1.5"/>
  <text x="380" y="170" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">文档上传与管理</text>
  <rect x="295" y="192" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="380" y="212" text-anchor="middle" font-size="12" fill="#2E7D32">文档上传/批量导入</text>
  <rect x="295" y="228" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="380" y="248" text-anchor="middle" font-size="12" fill="#2E7D32">文档解析/分块预览</text>
  <rect x="295" y="264" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="380" y="284" text-anchor="middle" font-size="12" fill="#2E7D32">文件格式支持</text>

  <!-- Sub-module: 检索配置 -->
  <rect x="500" y="145" width="180" height="38" rx="6" fill="#FFFFFF" stroke="#42A5F5" stroke-width="1.5"/>
  <text x="590" y="170" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">检索配置</text>
  <rect x="505" y="192" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="590" y="212" text-anchor="middle" font-size="12" fill="#2E7D32">向量检索/混合检索</text>
  <rect x="505" y="228" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="590" y="248" text-anchor="middle" font-size="12" fill="#2E7D32">重排序/相似度阈值</text>
  <rect x="505" y="264" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="590" y="284" text-anchor="middle" font-size="12" fill="#2E7D32">Top-K结果配置</text>

  <!-- Sub-module: 对话问答 -->
  <rect x="80" y="310" width="180" height="38" rx="6" fill="#FFFFFF" stroke="#42A5F5" stroke-width="1.5"/>
  <text x="170" y="335" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">对话问答</text>
  <rect x="85" y="357" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="170" y="377" text-anchor="middle" font-size="12" fill="#2E7D32">多轮对话/SSE流式</text>
  <rect x="85" y="393" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="170" y="413" text-anchor="middle" font-size="12" fill="#2E7D32">会话历史管理</text>
  <rect x="85" y="429" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="170" y="449" text-anchor="middle" font-size="12" fill="#2E7D32">引用溯源/来源标注</text>

  <!-- Sub-module: 提示词配置 -->
  <rect x="290" y="310" width="180" height="38" rx="6" fill="#FFFFFF" stroke="#42A5F5" stroke-width="1.5"/>
  <text x="380" y="335" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">提示词配置</text>
  <rect x="295" y="357" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="380" y="377" text-anchor="middle" font-size="12" fill="#2E7D32">系统提示词模板</text>
  <rect x="295" y="393" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="380" y="413" text-anchor="middle" font-size="12" fill="#2E7D32">动态变量替换</text>
  <rect x="295" y="429" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="380" y="449" text-anchor="middle" font-size="12" fill="#2E7D32">结构化输出约束</text>

  <!-- Sub-module: LLM推理引擎 -->
  <rect x="500" y="310" width="180" height="38" rx="6" fill="#FFFFFF" stroke="#42A5F5" stroke-width="1.5"/>
  <text x="590" y="335" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">LLM推理引擎</text>
  <rect x="505" y="357" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="590" y="377" text-anchor="middle" font-size="12" fill="#2E7D32">GLM-9B本地推理</text>
  <rect x="505" y="393" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="590" y="413" text-anchor="middle" font-size="12" fill="#2E7D32">模型参数配置</text>
  <rect x="505" y="429" width="170" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="590" y="449" text-anchor="middle" font-size="12" fill="#2E7D32">离线推理/无外网依赖</text>

  <!-- Domain 1 bottom: core tech label -->
  <rect x="80" y="490" width="600" height="36" rx="6" fill="#FFF8E1" stroke="#FFB300" stroke-width="1.5"/>
  <text x="380" y="514" text-anchor="middle" font-size="13" fill="#E65100">核心技术：RAG检索增强生成 · 向量语义检索 · SSE流式输出 · ragflow v0.18.0</text>

  <!-- Sub-module: 知识库检索 -->
  <rect x="290" y="540" width="390" height="38" rx="6" fill="#FFFFFF" stroke="#42A5F5" stroke-width="1.5"/>
  <text x="485" y="565" text-anchor="middle" font-size="14" font-weight="bold" fill="#1565C0">知识库检索服务</text>

  <rect x="295" y="586" width="126" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="358" y="606" text-anchor="middle" font-size="12" fill="#2E7D32">向量索引构建</text>

  <rect x="427" y="586" width="126" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="490" y="606" text-anchor="middle" font-size="12" fill="#2E7D32">文档解析分块</text>

  <rect x="559" y="586" width="126" height="30" rx="4" fill="#E8F5E9" stroke="#81C784" stroke-width="1"/>
  <text x="622" y="606" text-anchor="middle" font-size="12" fill="#2E7D32">ES/MinIO存储</text>

  <!-- ═══ Domain 2: 系统管理域 ═══ -->
  <rect x="720" y="85" width="420" height="530" rx="10" fill="url(#domainGrad2)" stroke="#7B1FA2" stroke-width="2" filter="url(#shadow)"/>
  <!-- Domain 2 header -->
  <rect x="720" y="85" width="420" height="44" rx="10" fill="#7B1FA2"/>
  <rect x="720" y="105" width="420" height="24" fill="#7B1FA2"/>
  <text x="930" y="114" text-anchor="middle" font-size="17" font-weight="bold" fill="white">系统管理域</text>

  <!-- Sub-module: 用户权限管理 -->
  <rect x="740" y="145" width="380" height="38" rx="6" fill="#FFFFFF" stroke="#AB47BC" stroke-width="1.5"/>
  <text x="930" y="170" text-anchor="middle" font-size="14" font-weight="bold" fill="#6A1B9A">用户权限管理</text>
  <rect x="745" y="192" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="836" y="212" text-anchor="middle" font-size="12" fill="#6A1B9A">用户注册/登录</text>
  <rect x="933" y="192" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="1024" y="212" text-anchor="middle" font-size="12" fill="#6A1B9A">JWT令牌认证</text>

  <rect x="745" y="228" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="836" y="248" text-anchor="middle" font-size="12" fill="#6A1B9A">RBAC角色权限</text>
  <rect x="933" y="228" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="1024" y="248" text-anchor="middle" font-size="12" fill="#6A1B9A">菜单权限配置</text>

  <!-- Sub-module: 角色菜单管理 -->
  <rect x="740" y="275" width="380" height="38" rx="6" fill="#FFFFFF" stroke="#AB47BC" stroke-width="1.5"/>
  <text x="930" y="300" text-anchor="middle" font-size="14" font-weight="bold" fill="#6A1B9A">角色菜单管理</text>
  <rect x="745" y="322" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="836" y="342" text-anchor="middle" font-size="12" fill="#6A1B9A">角色CRUD</text>
  <rect x="933" y="322" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="1024" y="342" text-anchor="middle" font-size="12" fill="#6A1B9A">菜单树配置</text>

  <rect x="745" y="358" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="836" y="378" text-anchor="middle" font-size="12" fill="#6A1B9A">权限分配</text>
  <rect x="933" y="358" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="1024" y="378" text-anchor="middle" font-size="12" fill="#6A1B9A">数据权限隔离</text>

  <!-- Sub-module: 部门管理 -->
  <rect x="740" y="405" width="380" height="38" rx="6" fill="#FFFFFF" stroke="#AB47BC" stroke-width="1.5"/>
  <text x="930" y="430" text-anchor="middle" font-size="14" font-weight="bold" fill="#6A1B9A">部门管理</text>
  <rect x="745" y="452" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="836" y="472" text-anchor="middle" font-size="12" fill="#6A1B9A">部门树结构</text>
  <rect x="933" y="452" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="1024" y="472" text-anchor="middle" font-size="12" fill="#6A1B9A">部门人员分配</text>

  <!-- Sub-module: 系统配置 -->
  <rect x="740" y="500" width="380" height="38" rx="6" fill="#FFFFFF" stroke="#AB47BC" stroke-width="1.5"/>
  <text x="930" y="525" text-anchor="middle" font-size="14" font-weight="bold" fill="#6A1B9A">系统配置</text>
  <rect x="745" y="547" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="836" y="567" text-anchor="middle" font-size="12" fill="#6A1B9A">系统参数配置</text>
  <rect x="933" y="547" width="183" height="30" rx="4" fill="#F3E5F5" stroke="#CE93D8" stroke-width="1"/>
  <text x="1024" y="567" text-anchor="middle" font-size="12" fill="#6A1B9A">操作日志审计</text>

</svg>
'''

# ═══════════════════════════════════════════════════════════════
# ER图 — Only kb_* and sys_* tables (知识库域 + 系统管理域 + QRTZ调度域)
# ═══════════════════════════════════════════════════════════════
svg_er = r'''<?xml version="1.0" encoding="UTF-8"?>
<svg width="1500" height="1120" xmlns="http://www.w3.org/2000/svg" font-family="Microsoft YaHei, SimHei, Arial, sans-serif">
  <defs>
    <filter id="shadow" x="-2%" y="-2%" width="104%" height="104%">
      <feDropShadow dx="2" dy="2" stdDeviation="3" flood-color="#00000022"/>
    </filter>
  </defs>

  <!-- Background -->
  <rect width="1500" height="1120" fill="#FAFAFA" rx="8"/>

  <!-- Title -->
  <text x="750" y="38" text-anchor="middle" font-size="22" font-weight="bold" fill="#1A237E">DARPA智能问答服务工具 — ER图（equipment_iqas数据库）</text>

  <!-- ════════════════════════════════════════════════════════════ -->
  <!-- Domain 1: 知识库域 (kb_*) — Blue theme                       -->
  <!-- ════════════════════════════════════════════════════════════ -->
  <rect x="30" y="60" width="680" height="610" rx="10" fill="#E3F2FD" stroke="#1976D2" stroke-width="2" filter="url(#shadow)"/>
  <rect x="30" y="60" width="680" height="40" rx="10" fill="#1976D2"/>
  <rect x="30" y="80" width="680" height="20" fill="#1976D2"/>
  <text x="370" y="88" text-anchor="middle" font-size="16" font-weight="bold" fill="white">知识库域（kb_*）</text>

  <!-- Table: kb_source_type -->
  <rect x="50" y="115" width="300" height="170" rx="6" fill="white" stroke="#42A5F5" stroke-width="1.5"/>
  <rect x="50" y="115" width="300" height="32" rx="6" fill="#42A5F5"/>
  <rect x="50" y="135" width="300" height="12" fill="#42A5F5"/>
  <text x="200" y="137" text-anchor="middle" font-size="13" font-weight="bold" fill="white">kb_source_type（文件类型）</text>
  <text x="60" y="166" font-size="11" fill="#333"><tspan font-weight="bold" fill="#1565C0">PK</tspan>  id                    BIGINT</text>
  <text x="60" y="184" font-size="11" fill="#333">      source_type_name     VARCHAR(100)</text>
  <text x="60" y="202" font-size="11" fill="#333">      source_type_code     VARCHAR(50)</text>
  <text x="60" y="220" font-size="11" fill="#333">      description          VARCHAR(500)</text>
  <text x="60" y="238" font-size="11" fill="#333">      status               TINYINT</text>
  <text x="60" y="256" font-size="11" fill="#333">      create_time          DATETIME</text>
  <text x="60" y="274" font-size="11" fill="#333">      update_time          DATETIME</text>

  <!-- Table: kb_source_file -->
  <rect x="390" y="115" width="300" height="210" rx="6" fill="white" stroke="#42A5F5" stroke-width="1.5"/>
  <rect x="390" y="115" width="300" height="32" rx="6" fill="#42A5F5"/>
  <rect x="390" y="135" width="300" height="12" fill="#42A5F5"/>
  <text x="540" y="137" text-anchor="middle" font-size="13" font-weight="bold" fill="white">kb_source_file（文件信息）</text>
  <text x="400" y="166" font-size="11" fill="#333"><tspan font-weight="bold" fill="#1565C0">PK</tspan>  id                    BIGINT</text>
  <text x="400" y="184" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  source_type_id        BIGINT</text>
  <text x="400" y="202" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  session_id            BIGINT</text>
  <text x="400" y="220" font-size="11" fill="#333">      file_name             VARCHAR(255)</text>
  <text x="400" y="238" font-size="11" fill="#333">      file_path             VARCHAR(500)</text>
  <text x="400" y="256" font-size="11" fill="#333">      file_size             BIGINT</text>
  <text x="400" y="274" font-size="11" fill="#333">      ragflow_doc_id        VARCHAR(100)</text>
  <text x="400" y="292" font-size="11" fill="#333">      status                TINYINT</text>
  <text x="400" y="310" font-size="11" fill="#333">      upload_time           DATETIME</text>

  <!-- Table: kb_session -->
  <rect x="50" y="310" width="300" height="210" rx="6" fill="white" stroke="#42A5F5" stroke-width="1.5"/>
  <rect x="50" y="310" width="300" height="32" rx="6" fill="#42A5F5"/>
  <rect x="50" y="330" width="300" height="12" fill="#42A5F5"/>
  <text x="200" y="337" text-anchor="middle" font-size="13" font-weight="bold" fill="white">kb_session（会话）</text>
  <text x="60" y="366" font-size="11" fill="#333"><tspan font-weight="bold" fill="#1565C0">PK</tspan>  id                    BIGINT</text>
  <text x="60" y="384" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  user_id               BIGINT</text>
  <text x="60" y="402" font-size="11" fill="#333">      session_name          VARCHAR(200)</text>
  <text x="60" y="420" font-size="11" fill="#333">      knowledgebase_id      VARCHAR(100)</text>
  <text x="60" y="438" font-size="11" fill="#333">      description           VARCHAR(500)</text>
  <text x="60" y="456" font-size="11" fill="#333">      status                TINYINT</text>
  <text x="60" y="474" font-size="11" fill="#333">      create_time           DATETIME</text>
  <text x="60" y="492" font-size="11" fill="#333">      update_time           DATETIME</text>

  <!-- Table: kb_chat -->
  <rect x="390" y="355" width="300" height="230" rx="6" fill="white" stroke="#42A5F5" stroke-width="1.5"/>
  <rect x="390" y="355" width="300" height="32" rx="6" fill="#42A5F5"/>
  <rect x="390" y="375" width="300" height="12" fill="#42A5F5"/>
  <text x="540" y="382" text-anchor="middle" font-size="13" font-weight="bold" fill="white">kb_chat（对话记录）</text>
  <text x="400" y="408" font-size="11" fill="#333"><tspan font-weight="bold" fill="#1565C0">PK</tspan>  id                    BIGINT</text>
  <text x="400" y="426" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  session_id            BIGINT</text>
  <text x="400" y="444" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  user_id               BIGINT</text>
  <text x="400" y="462" font-size="11" fill="#333">      question              TEXT</text>
  <text x="400" y="480" font-size="11" fill="#333">      answer                TEXT</text>
  <text x="400" y="498" font-size="11" fill="#333">      ragflow_task_id       VARCHAR(100)</text>
  <text x="400" y="516" font-size="11" fill="#333">      source_list           TEXT</text>
  <text x="400" y="534" font-size="11" fill="#333">      tokens_used           INT</text>
  <text x="400" y="552" font-size="11" fill="#333">      duration_ms           INT</text>
  <text x="400" y="570" font-size="11" fill="#333">      create_time           DATETIME</text>

  <!-- Relations within 知识库域 -->
  <!-- kb_source_type 1:N kb_source_file (source_type_id) -->
  <line x1="350" y1="200" x2="390" y2="200" stroke="#1976D2" stroke-width="2"/>
  <text x="370" y="195" text-anchor="middle" font-size="10" fill="#1976D2" font-weight="bold">1:N</text>
  <circle cx="350" cy="200" r="4" fill="#1976D2"/>
  <circle cx="390" cy="200" r="4" fill="#1976D2"/>

  <!-- kb_session 1:N kb_source_file (session_id) -->
  <line x1="300" y1="310" x2="440" y2="325" stroke="#1976D2" stroke-width="2"/>
  <text x="370" y="310" text-anchor="middle" font-size="10" fill="#1976D2" font-weight="bold">1:N</text>
  <circle cx="300" cy="310" r="4" fill="#1976D2"/>
  <circle cx="440" cy="325" r="4" fill="#1976D2"/>

  <!-- kb_session 1:N kb_chat (session_id) -->
  <line x1="350" y1="420" x2="390" y2="420" stroke="#1976D2" stroke-width="2"/>
  <text x="370" y="415" text-anchor="middle" font-size="10" fill="#1976D2" font-weight="bold">1:N</text>
  <circle cx="350" cy="420" r="4" fill="#1976D2"/>
  <circle cx="390" cy="420" r="4" fill="#1976D2"/>

  <!-- ════════════════════════════════════════════════════════════ -->
  <!-- Domain 2: 系统管理域 (sys_*) — Purple theme                  -->
  <!-- ════════════════════════════════════════════════════════════ -->
  <rect x="740" y="60" width="730" height="610" rx="10" fill="#F3E5F5" stroke="#7B1FA2" stroke-width="2" filter="url(#shadow)"/>
  <rect x="740" y="60" width="730" height="40" rx="10" fill="#7B1FA2"/>
  <rect x="740" y="80" width="730" height="20" fill="#7B1FA2"/>
  <text x="1105" y="88" text-anchor="middle" font-size="16" font-weight="bold" fill="white">系统管理域（sys_*）</text>

  <!-- Table: sys_user -->
  <rect x="760" y="115" width="330" height="210" rx="6" fill="white" stroke="#AB47BC" stroke-width="1.5"/>
  <rect x="760" y="115" width="330" height="32" rx="6" fill="#AB47BC"/>
  <rect x="760" y="135" width="330" height="12" fill="#AB47BC"/>
  <text x="925" y="137" text-anchor="middle" font-size="13" font-weight="bold" fill="white">sys_user（用户表）</text>
  <text x="770" y="166" font-size="11" fill="#333"><tspan font-weight="bold" fill="#6A1B9A">PK</tspan>  id                    BIGINT</text>
  <text x="770" y="184" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  dept_id               BIGINT</text>
  <text x="770" y="202" font-size="11" fill="#333">      username              VARCHAR(50)</text>
  <text x="770" y="220" font-size="11" fill="#333">      password              VARCHAR(200)</text>
  <text x="770" y="238" font-size="11" fill="#333">      nickname              VARCHAR(50)</text>
  <text x="770" y="256" font-size="11" fill="#333">      email                 VARCHAR(100)</text>
  <text x="770" y="274" font-size="11" fill="#333">      phone                 VARCHAR(20)</text>
  <text x="770" y="292" font-size="11" fill="#333">      status                TINYINT</text>
  <text x="770" y="310" font-size="11" fill="#333">      create_time           DATETIME</text>

  <!-- Table: sys_dept -->
  <rect x="1120" y="115" width="330" height="190" rx="6" fill="white" stroke="#AB47BC" stroke-width="1.5"/>
  <rect x="1120" y="115" width="330" height="32" rx="6" fill="#AB47BC"/>
  <rect x="1120" y="135" width="330" height="12" fill="#AB47BC"/>
  <text x="1285" y="137" text-anchor="middle" font-size="13" font-weight="bold" fill="white">sys_dept（部门表）</text>
  <text x="1130" y="166" font-size="11" fill="#333"><tspan font-weight="bold" fill="#6A1B9A">PK</tspan>  id                    BIGINT</text>
  <text x="1130" y="184" font-size="11" fill="#333">      parent_id             BIGINT</text>
  <text x="1130" y="202" font-size="11" fill="#333">      dept_name             VARCHAR(100)</text>
  <text x="1130" y="220" font-size="11" fill="#333">      dept_code             VARCHAR(50)</text>
  <text x="1130" y="238" font-size="11" fill="#333">      sort_order            INT</text>
  <text x="1130" y="256" font-size="11" fill="#333">      leader                VARCHAR(50)</text>
  <text x="1130" y="274" font-size="11" fill="#333">      status                TINYINT</text>
  <text x="1130" y="292" font-size="11" fill="#333">      create_time           DATETIME</text>

  <!-- Table: sys_role -->
  <rect x="760" y="360" width="330" height="190" rx="6" fill="white" stroke="#AB47BC" stroke-width="1.5"/>
  <rect x="760" y="360" width="330" height="32" rx="6" fill="#AB47BC"/>
  <rect x="760" y="380" width="330" height="12" fill="#AB47BC"/>
  <text x="925" y="387" text-anchor="middle" font-size="13" font-weight="bold" fill="white">sys_role（角色表）</text>
  <text x="770" y="412" font-size="11" fill="#333"><tspan font-weight="bold" fill="#6A1B9A">PK</tspan>  id                    BIGINT</text>
  <text x="770" y="430" font-size="11" fill="#333">      role_name             VARCHAR(100)</text>
  <text x="770" y="448" font-size="11" fill="#333">      role_code             VARCHAR(50)</text>
  <text x="770" y="466" font-size="11" fill="#333">      description           VARCHAR(500)</text>
  <text x="770" y="484" font-size="11" fill="#333">      status                TINYINT</text>
  <text x="770" y="502" font-size="11" fill="#333">      create_time           DATETIME</text>

  <!-- Table: sys_user_role (junction) -->
  <rect x="1120" y="340" width="330" height="150" rx="6" fill="white" stroke="#AB47BC" stroke-width="1.5"/>
  <rect x="1120" y="340" width="330" height="32" rx="6" fill="#AB47BC"/>
  <rect x="1120" y="360" width="330" height="12" fill="#AB47BC"/>
  <text x="1285" y="367" text-anchor="middle" font-size="13" font-weight="bold" fill="white">sys_user_role（用户角色关联）</text>
  <text x="1130" y="392" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  user_id               BIGINT</text>
  <text x="1130" y="410" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  role_id               BIGINT</text>

  <!-- Table: sys_role_menu (junction) -->
  <rect x="1120" y="520" width="330" height="130" rx="6" fill="white" stroke="#AB47BC" stroke-width="1.5"/>
  <rect x="1120" y="520" width="330" height="32" rx="6" fill="#AB47BC"/>
  <rect x="1120" y="540" width="330" height="12" fill="#AB47BC"/>
  <text x="1285" y="547" text-anchor="middle" font-size="13" font-weight="bold" fill="white">sys_role_menu（角色菜单关联）</text>
  <text x="1130" y="572" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  role_id               BIGINT</text>
  <text x="1130" y="590" font-size="11" fill="#333"><tspan font-weight="bold" fill="#E65100">FK</tspan>  menu_id               BIGINT</text>

  <!-- Table: sys_menu -->
  <rect x="760" y="585" width="330" height="170" rx="6" fill="white" stroke="#AB47BC" stroke-width="1.5"/>
  <rect x="760" y="585" width="330" height="32" rx="6" fill="#AB47BC"/>
  <rect x="760" y="605" width="330" height="12" fill="#AB47BC"/>
  <text x="925" y="617" text-anchor="middle" font-size="13" font-weight="bold" fill="white">sys_menu（菜单表）</text>
  <text x="770" y="640" font-size="11" fill="#333"><tspan font-weight="bold" fill="#6A1B9A">PK</tspan>  id                    BIGINT</text>
  <text x="770" y="658" font-size="11" fill="#333">      parent_id             BIGINT</text>
  <text x="770" y="676" font-size="11" fill="#333">      menu_name             VARCHAR(100)</text>
  <text x="770" y="694" font-size="11" fill="#333">      menu_type             CHAR(1)</text>
  <text x="770" y="712" font-size="11" fill="#333">      path                  VARCHAR(200)</text>
  <text x="770" y="730" font-size="11" fill="#333">      permission            VARCHAR(100)</text>
  <text x="770" y="748" font-size="11" fill="#333">      status                TINYINT</text>

  <!-- Relations within 系统管理域 -->
  <!-- sys_user N:1 sys_dept -->
  <line x1="1090" y1="200" x2="1120" y2="200" stroke="#7B1FA2" stroke-width="2"/>
  <text x="1105" y="195" text-anchor="middle" font-size="10" fill="#7B1FA2" font-weight="bold">N:1</text>
  <circle cx="1090" cy="200" r="4" fill="#7B1FA2"/>
  <circle cx="1120" cy="200" r="4" fill="#7B1FA2"/>

  <!-- sys_user 1:N sys_user_role -->
  <line x1="925" y1="325" x2="925" y2="340" stroke="#7B1FA2" stroke-width="2"/>
  <line x1="925" y1="340" x2="1120" y2="392" stroke="#7B1FA2" stroke-width="2"/>
  <text x="1020" y="360" text-anchor="middle" font-size="10" fill="#7B1FA2" font-weight="bold">1:N</text>

  <!-- sys_role 1:N sys_user_role -->
  <line x1="1090" y1="455" x2="1120" y2="430" stroke="#7B1FA2" stroke-width="2"/>
  <text x="1105" y="450" text-anchor="middle" font-size="10" fill="#7B1FA2" font-weight="bold">1:N</text>

  <!-- sys_role 1:N sys_role_menu -->
  <line x1="1090" y1="475" x2="1120" y2="560" stroke="#7B1FA2" stroke-width="2"/>
  <text x="1095" y="520" text-anchor="middle" font-size="10" fill="#7B1FA2" font-weight="bold">1:N</text>

  <!-- sys_menu 1:N sys_role_menu -->
  <line x1="1090" y1="680" x2="1120" y2="610" stroke="#7B1FA2" stroke-width="2"/>
  <text x="1095" y="650" text-anchor="middle" font-size="10" fill="#7B1FA2" font-weight="bold">1:N</text>

  <!-- ════════════════════════════════════════════════════════════ -->
  <!-- Domain 3: 调度任务域 (QRTZ_*) — Green theme                  -->
  <!-- ════════════════════════════════════════════════════════════ -->
  <rect x="30" y="700" width="1440" height="400" rx="10" fill="#E8F5E9" stroke="#388E3C" stroke-width="2" filter="url(#shadow)"/>
  <rect x="30" y="700" width="1440" height="40" rx="10" fill="#388E3C"/>
  <rect x="30" y="720" width="1440" height="20" fill="#388E3C"/>
  <text x="750" y="728" text-anchor="middle" font-size="16" font-weight="bold" fill="white">调度任务域（QRTZ_*）— Quartz定时任务调度</text>

  <!-- QRTZ_LOCKS -->
  <rect x="50" y="760" width="300" height="120" rx="6" fill="white" stroke="#66BB6A" stroke-width="1.5"/>
  <rect x="50" y="760" width="300" height="28" rx="6" fill="#66BB6A"/>
  <rect x="50" y="778" width="300" height="10" fill="#66BB6A"/>
  <text x="200" y="779" text-anchor="middle" font-size="12" font-weight="bold" fill="white">QRTZ_LOCKS</text>
  <text x="60" y="806" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  LOCK_NAME     VARCHAR(40)</text>

  <!-- QRTZ_SCHEDULER_STATE -->
  <rect x="380" y="760" width="300" height="140" rx="6" fill="white" stroke="#66BB6A" stroke-width="1.5"/>
  <rect x="380" y="760" width="300" height="28" rx="6" fill="#66BB6A"/>
  <rect x="380" y="778" width="300" height="10" fill="#66BB6A"/>
  <text x="530" y="779" text-anchor="middle" font-size="12" font-weight="bold" fill="white">QRTZ_SCHEDULER_STATE</text>
  <text x="390" y="806" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  SCHED_NAME        VARCHAR(120)</text>
  <text x="390" y="824" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  INSTANCE_NAME     VARCHAR(200)</text>
  <text x="390" y="842" font-size="10" fill="#333">      LAST_CHECKIN_TIME   BIGINT</text>
  <text x="390" y="860" font-size="10" fill="#333">      CHECKIN_INTERVAL   BIGINT</text>

  <!-- QRTZ_FIRED_TRIGGERS -->
  <rect x="710" y="760" width="300" height="160" rx="6" fill="white" stroke="#66BB6A" stroke-width="1.5"/>
  <rect x="710" y="760" width="300" height="28" rx="6" fill="#66BB6A"/>
  <rect x="710" y="778" width="300" height="10" fill="#66BB6A"/>
  <text x="860" y="779" text-anchor="middle" font-size="12" font-weight="bold" fill="white">QRTZ_FIRED_TRIGGERS</text>
  <text x="720" y="806" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  SCHED_NAME    VARCHAR(120)</text>
  <text x="720" y="824" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  TRIGGER_NAME  VARCHAR(200)</text>
  <text x="720" y="842" font-size="10" fill="#333">      TRIGGER_GROUP    VARCHAR(200)</text>
  <text x="720" y="860" font-size="10" fill="#333">      STATE            VARCHAR(16)</text>
  <text x="720" y="878" font-size="10" fill="#333">      FIRED_TIME       BIGINT</text>

  <!-- QRTZ_JOB_DETAILS -->
  <rect x="1040" y="760" width="300" height="180" rx="6" fill="white" stroke="#66BB6A" stroke-width="1.5"/>
  <rect x="1040" y="760" width="300" height="28" rx="6" fill="#66BB6A"/>
  <rect x="1040" y="778" width="300" height="10" fill="#66BB6A"/>
  <text x="1190" y="779" text-anchor="middle" font-size="12" font-weight="bold" fill="white">QRTZ_JOB_DETAILS</text>
  <text x="1050" y="806" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  SCHED_NAME      VARCHAR(120)</text>
  <text x="1050" y="824" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  JOB_NAME        VARCHAR(200)</text>
  <text x="1050" y="842" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  JOB_GROUP       VARCHAR(200)</text>
  <text x="1050" y="860" font-size="10" fill="#333">      DESCRIPTION       VARCHAR(250)</text>
  <text x="1050" y="878" font-size="10" fill="#333">      JOB_CLASS_NAME    VARCHAR(250)</text>
  <text x="1050" y="896" font-size="10" fill="#333">      IS_DURABLE        VARCHAR(1)</text>

  <!-- QRTZ_TRIGGERS -->
  <rect x="200" y="960" width="300" height="130" rx="6" fill="white" stroke="#66BB6A" stroke-width="1.5"/>
  <rect x="200" y="960" width="300" height="28" rx="6" fill="#66BB6A"/>
  <rect x="200" y="978" width="300" height="10" fill="#66BB6A"/>
  <text x="350" y="979" text-anchor="middle" font-size="12" font-weight="bold" fill="white">QRTZ_TRIGGERS</text>
  <text x="210" y="1006" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  SCHED_NAME      VARCHAR(120)</text>
  <text x="210" y="1024" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  TRIGGER_NAME    VARCHAR(200)</text>
  <text x="210" y="1042" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  TRIGGER_GROUP   VARCHAR(200)</text>
  <text x="210" y="1060" font-size="10" fill="#333">      TRIGGER_STATE     VARCHAR(16)</text>
  <text x="210" y="1078" font-size="10" fill="#333">      NEXT_FIRE_TIME    BIGINT</text>

  <!-- QRTZ_CRON_TRIGGERS -->
  <rect x="550" y="960" width="300" height="110" rx="6" fill="white" stroke="#66BB6A" stroke-width="1.5"/>
  <rect x="550" y="960" width="300" height="28" rx="6" fill="#66BB6A"/>
  <rect x="550" y="978" width="300" height="10" fill="#66BB6A"/>
  <text x="700" y="979" text-anchor="middle" font-size="12" font-weight="bold" fill="white">QRTZ_CRON_TRIGGERS</text>
  <text x="560" y="1006" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  SCHED_NAME      VARCHAR(120)</text>
  <text x="560" y="1024" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  TRIGGER_NAME    VARCHAR(200)</text>
  <text x="560" y="1042" font-size="10" fill="#333">      CRON_EXPRESSION    VARCHAR(120)</text>
  <text x="560" y="1060" font-size="10" fill="#333">      TIME_ZONE_ID       VARCHAR(80)</text>

  <!-- QRTZ_BLOB_TRIGGERS -->
  <rect x="900" y="960" width="300" height="100" rx="6" fill="white" stroke="#66BB6A" stroke-width="1.5"/>
  <rect x="900" y="960" width="300" height="28" rx="6" fill="#66BB6A"/>
  <rect x="900" y="978" width="300" height="10" fill="#66BB6A"/>
  <text x="1050" y="979" text-anchor="middle" font-size="12" font-weight="bold" fill="white">QRTZ_BLOB_TRIGGERS</text>
  <text x="910" y="1006" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  SCHED_NAME      VARCHAR(120)</text>
  <text x="910" y="1024" font-size="10" fill="#333"><tspan font-weight="bold" fill="#2E7D32">PK</tspan>  TRIGGER_NAME    VARCHAR(200)</text>
  <text x="910" y="1042" font-size="10" fill="#333">      BLOB_DATA         BLOB</text>

  <!-- Relations: QRTZ_JOB_DETAILS 1:N QRTZ_TRIGGERS -->
  <line x1="1190" y1="940" x2="350" y2="960" stroke="#388E3C" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="770" y="942" text-anchor="middle" font-size="10" fill="#388E3C" font-weight="bold">1:N (JOB_NAME)</text>

  <!-- QRTZ_TRIGGERS 1:1 QRTZ_CRON_TRIGGERS -->
  <line x1="500" y1="1025" x2="550" y2="1025" stroke="#388E3C" stroke-width="1.5"/>
  <text x="525" y="1018" text-anchor="middle" font-size="10" fill="#388E3C" font-weight="bold">1:1</text>

  <!-- QRTZ_TRIGGERS 1:1 QRTZ_BLOB_TRIGGERS -->
  <line x1="500" y1="1040" x2="900" y2="1025" stroke="#388E3C" stroke-width="1.5" stroke-dasharray="6,3"/>
  <text x="700" y="1048" text-anchor="middle" font-size="10" fill="#388E3C" font-weight="bold">1:1</text>

  <!-- ═══ Cross-domain relations ═══ -->
  <!-- sys_user -> kb_session (user_id) -->
  <line x1="760" y1="350" x2="350" y2="380" stroke="#D32F2F" stroke-width="2" stroke-dasharray="8,4"/>
  <text x="555" y="358" text-anchor="middle" font-size="11" fill="#D32F2F" font-weight="bold">N:1 (user_id)</text>
  <circle cx="760" cy="350" r="5" fill="#D32F2F"/>
  <circle cx="350" cy="380" r="5" fill="#D32F2F"/>

  <!-- sys_user -> kb_chat (user_id) -->
  <line x1="760" y1="280" x2="690" y2="440" stroke="#D32F2F" stroke-width="2" stroke-dasharray="8,4"/>
  <text x="740" y="370" text-anchor="middle" font-size="11" fill="#D32F2F" font-weight="bold">N:1 (user_id)</text>

</svg>
'''


def main():
    # Generate 功能组成图
    svg_path = IMG_DIR / '功能组成图.svg'
    png_path = IMG_DIR / '功能组成图.png'
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(svg_function)
    cairosvg.svg2png(url=str(svg_path), write_to=str(png_path), scale=2)
    print(f'Generated: {png_path}')
    svg_path.unlink()

    # Generate ER图
    svg_path = IMG_DIR / 'ER图.svg'
    png_path = IMG_DIR / 'ER图.png'
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(svg_er)
    cairosvg.svg2png(url=str(svg_path), write_to=str(png_path), scale=2)
    print(f'Generated: {png_path}')
    svg_path.unlink()

    print('Done! Both images regenerated.')


if __name__ == '__main__':
    main()
