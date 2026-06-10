"""
Generate 4 remaining images for the documentation set:
1. ER图.png - Database logical design ER diagram
2. 问答流程活动图.png - Q&A workflow activity diagram
3. 内部接口示意图.png - Internal interface diagram
4. 测试环境架构图.png - Test environment architecture diagram
"""
import os
import sys

os.environ['PATH'] = r'C:\Program Files\GTK3-Runtime Win64\bin;' + os.environ['PATH']

import cairosvg

OUTPUT_DIR = os.path.dirname(os.path.abspath(__file__))

def save_svg_and_png(name, svg_content, scale=2):
    svg_path = os.path.join(OUTPUT_DIR, f'{name}.svg')
    png_path = os.path.join(OUTPUT_DIR, f'{name}.png')
    with open(svg_path, 'w', encoding='utf-8') as f:
        f.write(svg_content)
    cairosvg.svg2png(url=svg_path, write_to=png_path, scale=scale)
    print(f'  -> {png_path}')
    return png_path

# ============================================================================
# 1. ER图 - Database Logical Design
# ============================================================================
er_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 900" font-family="Microsoft YaHei, SimHei, sans-serif">
  <defs>
    <style>
      .entity-box { fill: #E3F2FD; stroke: #1565C0; stroke-width: 2; rx: 8; }
      .entity-header { fill: #1565C0; }
      .entity-header-text { fill: white; font-size: 14px; font-weight: bold; }
      .field-text { fill: #333; font-size: 11px; }
      .pk-text { fill: #1565C0; font-size: 11px; font-weight: bold; }
      .fk-text { fill: #E65100; font-size: 11px; }
      .relation-line { stroke: #666; stroke-width: 1.5; fill: none; }
      .rel-label { fill: #666; font-size: 10px; }
      .title { font-size: 20px; font-weight: bold; fill: #1a237e; }
    </style>
  </defs>

  <text x="600" y="35" text-anchor="middle" class="title">知枢(KnovaQ) 数据库逻辑设计 ER图</text>

  <!-- Group 1: Knowledge Base (kb_) -->
  <g transform="translate(30, 60)">
    <rect class="entity-box" x="0" y="0" width="200" height="190"/>
    <rect class="entity-header" x="0" y="0" width="200" height="30" rx="8"/>
    <text x="100" y="20" text-anchor="middle" class="entity-header-text">kb_chat 聊天记录</text>
    <text x="10" y="50" class="pk-text">PK id</text>
    <text x="10" y="66" class="field-text">message_id 对话ID</text>
    <text x="10" y="82" class="field-text">chat_id 聊天窗ID</text>
    <text x="10" y="98" class="fk-text">FK session_id</text>
    <text x="10" y="114" class="field-text">content 原始对话JSON</text>
    <text x="10" y="130" class="field-text">reference 引用信息</text>
    <text x="10" y="146" class="field-text">role 角色</text>
    <text x="10" y="162" class="field-text">create_by / create_time</text>
    <text x="10" y="178" class="field-text">update_by / update_time</text>
  </g>

  <g transform="translate(270, 60)">
    <rect class="entity-box" x="0" y="0" width="200" height="170"/>
    <rect class="entity-header" x="0" y="0" width="200" height="30" rx="8"/>
    <text x="100" y="20" text-anchor="middle" class="entity-header-text">kb_session 会话管理</text>
    <text x="10" y="50" class="pk-text">PK id</text>
    <text x="10" y="66" class="field-text">session_id 会话ID</text>
    <text x="10" y="82" class="field-text">session_name 会话名称</text>
    <text x="10" y="98" class="field-text">chat_id 聊天窗ID</text>
    <text x="10" y="114" class="fk-text">FK user_id 用户ID</text>
    <text x="10" y="130" class="field-text">create_by / create_time</text>
    <text x="10" y="146" class="field-text">update_time</text>
  </g>

  <g transform="translate(510, 60)">
    <rect class="entity-box" x="0" y="0" width="200" height="170"/>
    <rect class="entity-header" x="0" y="0" width="200" height="30" rx="8"/>
    <text x="100" y="20" text-anchor="middle" class="entity-header-text">kb_source_file 知识文件</text>
    <text x="10" y="50" class="pk-text">PK id</text>
    <text x="10" y="66" class="field-text">name 文件名称</text>
    <text x="10" y="82" class="fk-text">FK type_id 文件类型ID</text>
    <text x="10" y="98" class="field-text">tenant_id 租户ID</text>
    <text x="10" y="114" class="field-text">size 文件大小</text>
    <text x="10" y="130" class="field-text">type 文件类型</text>
    <text x="10" y="146" class="field-text">create_by / create_time</text>
  </g>

  <g transform="translate(750, 60)">
    <rect class="entity-box" x="0" y="0" width="200" height="150"/>
    <rect class="entity-header" x="0" y="0" width="200" height="30" rx="8"/>
    <text x="100" y="20" text-anchor="middle" class="entity-header-text">kb_source_type 文件分类</text>
    <text x="10" y="50" class="pk-text">PK id</text>
    <text x="10" y="66" class="fk-text">FK parent_id 父类ID</text>
    <text x="10" y="82" class="field-text">source_type 类别名称</text>
    <text x="10" y="98" class="field-text">create_by / create_time</text>
    <text x="10" y="114" class="field-text">update_by / update_time</text>
  </g>

  <g transform="translate(990, 60)">
    <rect class="entity-box" x="0" y="0" width="180" height="120"/>
    <rect class="entity-header" x="0" y="0" width="180" height="30" rx="8"/>
    <text x="90" y="20" text-anchor="middle" class="entity-header-text">kb_source_dept</text>
    <text x="10" y="50" class="fk-text">FK source_id 来源ID</text>
    <text x="10" y="66" class="fk-text">FK dept_id 部门ID</text>
    <text x="10" y="82" class="field-text">ancestors 祖级列表</text>
  </g>

  <!-- Relations kb_ -->
  <line x1="230" y1="155" x2="270" y2="155" class="relation-line"/>
  <text x="250" y="148" class="rel-label">N:1</text>
  <line x1="710" y1="155" x2="750" y2="155" class="relation-line"/>
  <text x="730" y="148" class="rel-label">N:1</text>

  <!-- Group 2: Repair Service (rs_) -->
  <g transform="translate(30, 340)">
    <rect class="entity-box" x="0" y="0" width="220" height="210"/>
    <rect class="entity-header" x="0" y="0" width="220" height="30" rx="8"/>
    <text x="110" y="20" text-anchor="middle" class="entity-header-text">rs_repair_service_provider</text>
    <text x="10" y="50" class="pk-text">PK provider_id</text>
    <text x="10" y="66" class="field-text">provider_code 服务商编码</text>
    <text x="10" y="82" class="field-text">provider_name 服务商名称</text>
    <text x="10" y="98" class="field-text">provider_charge 负责人</text>
    <text x="10" y="114" class="field-text">provider_contact_person</text>
    <text x="10" y="130" class="field-text">province / city / district</text>
    <text x="10" y="146" class="field-text">service_region 归属区域</text>
    <text x="10" y="162" class="field-text">is_del 是否删除</text>
    <text x="10" y="178" class="field-text">remark 说明</text>
    <text x="10" y="194" class="field-text">create_by / create_time</text>
  </g>

  <g transform="translate(290, 340)">
    <rect class="entity-box" x="0" y="0" width="220" height="210"/>
    <rect class="entity-header" x="0" y="0" width="220" height="30" rx="8"/>
    <text x="110" y="20" text-anchor="middle" class="entity-header-text">rs_device_master 备件主表</text>
    <text x="10" y="50" class="pk-text">PK spare_part_masterid</text>
    <text x="10" y="66" class="fk-text">FK provider_id 服务商ID</text>
    <text x="10" y="82" class="field-text">warehouse_code 仓库编码</text>
    <text x="10" y="98" class="field-text">spare_part_name 备件名称</text>
    <text x="10" y="114" class="field-text">spare_part_unit 单位</text>
    <text x="10" y="130" class="field-text">spare_part_spec 型号</text>
    <text x="10" y="146" class="field-text">spare_part_code SN码</text>
    <text x="10" y="162" class="field-text">spare_part_status 状态</text>
    <text x="10" y="178" class="field-text">remark 说明</text>
    <text x="10" y="194" class="field-text">create_by / create_time</text>
  </g>

  <g transform="translate(550, 340)">
    <rect class="entity-box" x="0" y="0" width="220" height="190"/>
    <rect class="entity-header" x="0" y="0" width="220" height="30" rx="8"/>
    <text x="110" y="20" text-anchor="middle" class="entity-header-text">rs_device_inventory 备件库存</text>
    <text x="10" y="50" class="pk-text">PK inventory_id</text>
    <text x="10" y="66" class="fk-text">FK provider_id 服务商ID</text>
    <text x="10" y="82" class="field-text">spare_part_name 备件名称</text>
    <text x="10" y="98" class="field-text">spare_part_unit 单位</text>
    <text x="10" y="114" class="field-text">spare_part_num 本期数量</text>
    <text x="10" y="130" class="field-text">spare_part_pnum 上期数量</text>
    <text x="10" y="146" class="field-text">remark 说明</text>
    <text x="10" y="162" class="field-text">create_by / create_time</text>
  </g>

  <g transform="translate(810, 340)">
    <rect class="entity-box" x="0" y="0" width="220" height="230"/>
    <rect class="entity-header" x="0" y="0" width="220" height="30" rx="8"/>
    <text x="110" y="20" text-anchor="middle" class="entity-header-text">rs_device_detial 备件明细</text>
    <text x="10" y="50" class="pk-text">PK spare_part_detailid</text>
    <text x="10" y="66" class="fk-text">FK provider_id 服务商ID</text>
    <text x="10" y="82" class="field-text">warehouse_code 仓库编码</text>
    <text x="10" y="98" class="field-text">nspare_part_name 新备件</text>
    <text x="10" y="114" class="field-text">nspare_part_code 新备件SN</text>
    <text x="10" y="130" class="field-text">ospare_part_code 旧备件SN</text>
    <text x="10" y="146" class="field-text">abstract 操作摘要</text>
    <text x="10" y="162" class="field-text">transfer_by 调拨人</text>
    <text x="10" y="178" class="field-text">receive_by 接收人</text>
    <text x="10" y="194" class="field-text">remark 说明</text>
    <text x="10" y="210" class="field-text">create_by / create_time</text>
  </g>

  <!-- Relations rs_ -->
  <line x1="250" y1="445" x2="290" y2="445" class="relation-line"/>
  <text x="270" y="438" class="rel-label">1:N</text>
  <line x1="250" y1="460" x2="550" y2="460" class="relation-line" stroke-dasharray="4"/>
  <line x1="250" y1="475" x2="810" y2="475" class="relation-line" stroke-dasharray="4"/>

  <!-- Group 3: Issue Record (ir_) -->
  <g transform="translate(30, 620)">
    <rect class="entity-box" x="0" y="0" width="220" height="210"/>
    <rect class="entity-header" x="0" y="0" width="220" height="30" rx="8"/>
    <text x="110" y="20" text-anchor="middle" class="entity-header-text">ir_issue_recode 问题登记</text>
    <text x="10" y="50" class="pk-text">PK issue_id</text>
    <text x="10" y="66" class="field-text">issue_code 问题编码</text>
    <text x="10" y="82" class="field-text">issue_name 问题名称</text>
    <text x="10" y="98" class="field-text">customer_name 客户名称</text>
    <text x="10" y="114" class="field-text">product_id / product_sn</text>
    <text x="10" y="130" class="field-text">issue_type 问题类别</text>
    <text x="10" y="146" class="field-text">issue_level 问题等级</text>
    <text x="10" y="162" class="field-text">service_engineer 工程师</text>
    <text x="10" y="178" class="field-text">status 状态</text>
    <text x="10" y="194" class="field-text">create_by / create_time</text>
  </g>

  <g transform="translate(290, 620)">
    <rect class="entity-box" x="0" y="0" width="220" height="210"/>
    <rect class="entity-header" x="0" y="0" width="220" height="30" rx="8"/>
    <text x="110" y="20" text-anchor="middle" class="entity-header-text">ir_shelf_life 保质期维护</text>
    <text x="10" y="50" class="pk-text">PK shelf_life_id</text>
    <text x="10" y="66" class="fk-text">FK provider_id 服务商ID</text>
    <text x="10" y="82" class="field-text">product_id / product_sn</text>
    <text x="10" y="98" class="field-text">product_name 产品名称</text>
    <text x="10" y="114" class="field-text">spare_part_name 备件名称</text>
    <text x="10" y="130" class="field-text">product_sellby_date</text>
    <text x="10" y="146" class="field-text">spare_sellby_date</text>
    <text x="10" y="162" class="field-text">remark 说明</text>
    <text x="10" y="178" class="field-text">create_by / create_time</text>
  </g>

  <!-- Group 4: System (sys_) -->
  <g transform="translate(560, 620)">
    <rect class="entity-box" x="0" y="0" width="190" height="170"/>
    <rect class="entity-header" x="0" y="0" width="190" height="30" rx="8"/>
    <text x="95" y="20" text-anchor="middle" class="entity-header-text">sys_user 用户</text>
    <text x="10" y="50" class="pk-text">PK user_id</text>
    <text x="10" y="66" class="fk-text">FK dept_id 部门ID</text>
    <text x="10" y="82" class="field-text">user_name 用户名</text>
    <text x="10" y="98" class="field-text">nick_name 昵称</text>
    <text x="10" y="114" class="field-text">email / phonenumber</text>
    <text x="10" y="130" class="field-text">status 状态</text>
    <text x="10" y="146" class="field-text">create_time</text>
  </g>

  <g transform="translate(790, 620)">
    <rect class="entity-box" x="0" y="0" width="190" height="150"/>
    <rect class="entity-header" x="0" y="0" width="190" height="30" rx="8"/>
    <text x="95" y="20" text-anchor="middle" class="entity-header-text">sys_dept 部门</text>
    <text x="10" y="50" class="pk-text">PK dept_id</text>
    <text x="10" y="66" class="fk-text">FK parent_id 父部门</text>
    <text x="10" y="82" class="field-text">ancestors 祖级列表</text>
    <text x="10" y="98" class="field-text">dept_name 部门名称</text>
    <text x="10" y="114" class="field-text">order_num 显示顺序</text>
    <text x="10" y="130" class="field-text">status 状态</text>
  </g>

  <g transform="translate(1010, 620)">
    <rect class="entity-box" x="0" y="0" width="170" height="150"/>
    <rect class="entity-header" x="0" y="0" width="170" height="30" rx="8"/>
    <text x="85" y="20" text-anchor="middle" class="entity-header-text">sys_role 角色</text>
    <text x="10" y="50" class="pk-text">PK role_id</text>
    <text x="10" y="66" class="field-text">role_name 角色名</text>
    <text x="10" y="82" class="field-text">role_key 角色权限</text>
    <text x="10" y="98" class="field-text">role_sort 显示顺序</text>
    <text x="10" y="114" class="field-text">status 状态</text>
    <text x="10" y="130" class="field-text">create_time</text>
  </g>

  <!-- Relations sys_ -->
  <line x1="750" y1="705" x2="790" y2="705" class="relation-line"/>
  <text x="770" y="698" class="rel-label">N:1</text>

  <!-- Legend -->
  <g transform="translate(30, 865)">
    <rect x="0" y="0" width="15" height="10" fill="#1565C0" rx="2"/>
    <text x="20" y="10" class="field-text">PK 主键</text>
    <rect x="100" y="0" width="15" height="10" fill="#E65100" rx="2"/>
    <text x="120" y="10" class="field-text">FK 外键</text>
    <line x1="210" y1="5" x2="240" y2="5" class="relation-line"/>
    <text x="245" y="10" class="field-text">关联关系</text>
  </g>
</svg>'''

# ============================================================================
# 2. 问答流程活动图 - Q&A Workflow Activity Diagram
# ============================================================================
qa_flow_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 1050" font-family="Microsoft YaHei, SimHei, sans-serif">
  <defs>
    <style>
      .start-end { fill: #1B5E20; stroke: #1B5E20; }
      .start-end-text { fill: white; font-size: 13px; font-weight: bold; }
      .activity { fill: #E3F2FD; stroke: #1565C0; stroke-width: 2; rx: 6; }
      .activity-text { fill: #1565C0; font-size: 13px; font-weight: bold; }
      .decision { fill: #FFF3E0; stroke: #E65100; stroke-width: 2; }
      .decision-text { fill: #E65100; font-size: 12px; font-weight: bold; }
      .arrow { stroke: #455A64; stroke-width: 1.5; fill: none; marker-end: url(#arrowhead); }
      .label { fill: #455A64; font-size: 11px; }
      .lane-label { fill: #1565C0; font-size: 14px; font-weight: bold; }
      .lane-bg { fill: #F5F5F5; stroke: #E0E0E0; stroke-width: 1; }
      .title { font-size: 20px; font-weight: bold; fill: #1a237e; }
    </style>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#455A64"/>
    </marker>
  </defs>

  <text x="450" y="30" text-anchor="middle" class="title">知枢(KnovaQ) 智能问答流程活动图</text>

  <!-- Swim lanes -->
  <rect class="lane-bg" x="0" y="50" width="180" height="970" rx="4"/>
  <text x="90" y="75" text-anchor="middle" class="lane-label">用户</text>
  <rect class="lane-bg" x="180" y="50" width="270" height="970" rx="4"/>
  <text x="315" y="75" text-anchor="middle" class="lane-label">gaisoft-server</text>
  <rect class="lane-bg" x="450" y="50" width="220" height="970" rx="4"/>
  <text x="560" y="75" text-anchor="middle" class="lane-label">ragflow-server</text>
  <rect class="lane-bg" x="670" y="50" width="230" height="970" rx="4"/>
  <text x="785" y="75" text-anchor="middle" class="lane-label">LLM/向量库</text>

  <!-- Start -->
  <ellipse class="start-end" cx="90" cy="110" rx="45" ry="20"/>
  <text x="90" y="115" text-anchor="middle" class="start-end-text">开始</text>

  <!-- Step 1 -->
  <path d="M90,130 L90,150 L315,150 L315,170" class="arrow"/>
  <rect class="activity" x="230" y="170" width="170" height="40" rx="6"/>
  <text x="315" y="195" text-anchor="middle" class="activity-text">用户发起提问</text>

  <!-- Step 2 -->
  <path d="M315,210 L315,240" class="arrow"/>
  <rect class="activity" x="230" y="240" width="170" height="40" rx="6"/>
  <text x="315" y="265" text-anchor="middle" class="activity-text">创建会话/对话</text>

  <!-- Step 3 -->
  <path d="M315,280 L315,310 L560,310 L560,330" class="arrow"/>
  <rect class="activity" x="475" y="330" width="170" height="40" rx="6"/>
  <text x="560" y="355" text-anchor="middle" class="activity-text">检索知识库</text>

  <!-- Step 4 -->
  <path d="M560,370 L560,400 L785,400 L785,420" class="arrow"/>
  <rect class="activity" x="700" y="420" width="170" height="40" rx="6"/>
  <text x="785" y="445" text-anchor="middle" class="activity-text">向量相似度检索</text>

  <!-- Step 5 -->
  <path d="M785,460 L785,490" class="arrow"/>
  <rect class="activity" x="700" y="490" width="170" height="40" rx="6"/>
  <text x="785" y="515" text-anchor="middle" class="activity-text">返回TopK结果</text>

  <!-- Step 6 -->
  <path d="M785,530 L785,560 L560,560 L560,580" class="arrow"/>
  <rect class="activity" x="475" y="580" width="170" height="40" rx="6"/>
  <text x="560" y="605" text-anchor="middle" class="activity-text">组装Prompt</text>

  <!-- Step 7 - Decision -->
  <path d="M560,620 L560,660" class="arrow"/>
  <polygon class="decision" points="560,660 640,700 560,740 480,700"/>
  <text x="560" y="695" text-anchor="middle" class="decision-text">流式/</text>
  <text x="560" y="710" text-anchor="middle" class="decision-text">非流式</text>

  <!-- Stream path -->
  <path d="M560,740 L560,780 L785,780 L785,800" class="arrow"/>
  <text x="670" y="775" class="label">流式</text>
  <rect class="activity" x="700" y="800" width="170" height="40" rx="6"/>
  <text x="785" y="825" text-anchor="middle" class="activity-text">SSE流式返回</text>

  <!-- Non-stream path -->
  <path d="M480,700 L400,700 L400,800" class="arrow"/>
  <text x="420" y="695" class="label">非流式</text>
  <rect class="activity" x="315" y="800" width="170" height="40" rx="6"/>
  <text x="400" y="825" text-anchor="middle" class="activity-text">完整响应返回</text>

  <!-- Merge -->
  <path d="M785,840 L785,870 L400,870 L400,880" class="arrow"/>
  <path d="M400,840 L400,880" class="arrow"/>

  <!-- Step 8 -->
  <rect class="activity" x="315" y="880" width="170" height="40" rx="6"/>
  <text x="400" y="905" text-anchor="middle" class="activity-text">保存对话记录</text>

  <!-- Step 9 -->
  <path d="M400,920 L400,950 L90,950 L90,970" class="arrow"/>
  <rect class="activity" x="15" y="920" width="150" height="40" rx="6"/>
  <text x="90" y="945" text-anchor="middle" class="activity-text">展示回答结果</text>

  <!-- End -->
  <path d="M90,960 L90,980" class="arrow"/>
  <ellipse class="start-end" cx="90" cy="1000" rx="45" ry="20"/>
  <text x="90" y="1005" text-anchor="middle" class="start-end-text">结束</text>
</svg>'''

# ============================================================================
# 3. 内部接口示意图 - Internal Interface Diagram
# ============================================================================
internal_if_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1100 750" font-family="Microsoft YaHei, SimHei, sans-serif">
  <defs>
    <style>
      .module { fill: #E8F5E9; stroke: #2E7D32; stroke-width: 2; rx: 8; }
      .module-header { fill: #2E7D32; }
      .module-header-text { fill: white; font-size: 14px; font-weight: bold; }
      .api { fill: #FFF8E1; stroke: #F57F17; stroke-width: 1.5; rx: 4; }
      .api-text { fill: #333; font-size: 11px; }
      .arrow-http { stroke: #1565C0; stroke-width: 2; fill: none; marker-end: url(#blue-arrow); }
      .arrow-api { stroke: #2E7D32; stroke-width: 2; fill: none; marker-end: url(#green-arrow); stroke-dasharray: 6,3; }
      .arrow-data { stroke: #E65100; stroke-width: 2; fill: none; marker-end: url(#orange-arrow); }
      .label-http { fill: #1565C0; font-size: 10px; font-weight: bold; }
      .label-api { fill: #2E7D32; font-size: 10px; }
      .label-data { fill: #E65100; font-size: 10px; }
      .title { font-size: 20px; font-weight: bold; fill: #1a237e; }
      .proto-label { fill: #555; font-size: 10px; font-style: italic; }
    </style>
    <marker id="blue-arrow" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#1565C0"/>
    </marker>
    <marker id="green-arrow" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#2E7D32"/>
    </marker>
    <marker id="orange-arrow" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#E65100"/>
    </marker>
  </defs>

  <text x="550" y="30" text-anchor="middle" class="title">知枢(KnovaQ) 内部接口示意图</text>

  <!-- gaisoft-frontend -->
  <g transform="translate(30, 55)">
    <rect class="module" x="0" y="0" width="200" height="280"/>
    <rect class="module-header" x="0" y="0" width="200" height="35" rx="8"/>
    <text x="100" y="23" text-anchor="middle" class="module-header-text">gaisoft-frontend</text>
    <text x="100" y="55" text-anchor="middle" class="proto-label">(Vue 3 SPA)</text>
    <rect class="api" x="10" y="70" width="180" height="22"/>
    <text x="100" y="85" text-anchor="middle" class="api-text">POST /api/login</text>
    <rect class="api" x="10" y="96" width="180" height="22"/>
    <text x="100" y="111" text-anchor="middle" class="api-text">GET /api/kb/session/list</text>
    <rect class="api" x="10" y="122" width="180" height="22"/>
    <text x="100" y="137" text-anchor="middle" class="api-text">POST /api/kb/chat/send</text>
    <rect class="api" x="10" y="148" width="180" height="22"/>
    <text x="100" y="163" text-anchor="middle" class="api-text">POST /api/kb/source/upload</text>
    <rect class="api" x="10" y="174" width="180" height="22"/>
    <text x="100" y="189" text-anchor="middle" class="api-text">GET /api/issue/list</text>
    <rect class="api" x="10" y="200" width="180" height="22"/>
    <text x="100" y="215" text-anchor="middle" class="api-text">GET /api/device/inventory</text>
    <rect class="api" x="10" y="226" width="180" height="22"/>
    <text x="100" y="241" text-anchor="middle" class="api-text">GET /api/system/user/info</text>
  </g>

  <!-- gaisoft-server (MES Backend) -->
  <g transform="translate(340, 55)">
    <rect class="module" x="0" y="0" width="240" height="280"/>
    <rect class="module-header" x="0" y="0" width="240" height="35" rx="8"/>
    <text x="120" y="23" text-anchor="middle" class="module-header-text">gaisoft-server</text>
    <text x="120" y="55" text-anchor="middle" class="proto-label">(Spring Boot REST API)</text>
    <rect class="api" x="10" y="70" width="220" height="22"/>
    <text x="120" y="85" text-anchor="middle" class="api-text">AuthController /api/login</text>
    <rect class="api" x="10" y="96" width="220" height="22"/>
    <text x="120" y="111" text-anchor="middle" class="api-text">KbSessionController 会话管理</text>
    <rect class="api" x="10" y="122" width="220" height="22"/>
    <text x="120" y="137" text-anchor="middle" class="api-text">KbChatController 对话接口</text>
    <rect class="api" x="10" y="148" width="220" height="22"/>
    <text x="120" y="163" text-anchor="middle" class="api-text">KbSourceController 文件管理</text>
    <rect class="api" x="10" y="174" width="220" height="22"/>
    <text x="120" y="189" text-anchor="middle" class="api-text">IrIssueController 问题管理</text>
    <rect class="api" x="10" y="200" width="220" height="22"/>
    <text x="120" y="215" text-anchor="middle" class="api-text">RsDeviceController 备件管理</text>
    <rect class="api" x="10" y="226" width="220" height="22"/>
    <text x="120" y="241" text-anchor="middle" class="api-text">SysUserController 用户管理</text>
  </g>

  <!-- ragflow-server -->
  <g transform="translate(680, 55)">
    <rect class="module" x="0" y="0" width="220" height="280"/>
    <rect class="module-header" x="0" y="0" width="220" height="35" rx="8"/>
    <text x="110" y="23" text-anchor="middle" class="module-header-text">ragflow-server</text>
    <text x="110" y="55" text-anchor="middle" class="proto-label">(RAG Engine REST API)</text>
    <rect class="api" x="10" y="70" width="200" height="22"/>
    <text x="110" y="85" text-anchor="middle" class="api-text">POST /api/v1/datasets</text>
    <rect class="api" x="10" y="96" width="200" height="22"/>
    <text x="110" y="111" text-anchor="middle" class="api-text">POST /api/v1/datasets/{id}/documents</text>
    <rect class="api" x="10" y="122" width="200" height="22"/>
    <text x="110" y="137" text-anchor="middle" class="api-text">POST /api/v1/retrieval</text>
    <rect class="api" x="10" y="148" width="200" height="22"/>
    <text x="110" y="163" text-anchor="middle" class="api-text">POST /api/v1/chats/{id}/completions</text>
    <rect class="api" x="10" y="174" width="200" height="22"/>
    <text x="110" y="189" text-anchor="middle" class="api-text">GET /api/v1/chats</text>
    <rect class="api" x="10" y="200" width="200" height="22"/>
    <text x="110" y="215" text-anchor="middle" class="api-text">GET /api/v1/datasets/{id}/documents</text>
    <rect class="api" x="10" y="226" width="200" height="22"/>
    <text x="110" y="241" text-anchor="middle" class="api-text">POST /api/v1/datasets/{id}/chunks</text>
  </g>

  <!-- Data Layer -->
  <g transform="translate(200, 420)">
    <rect class="module" x="0" y="0" width="160" height="120" style="fill:#E3F2FD;stroke:#1565C0"/>
    <rect x="0" y="0" width="160" height="35" rx="8" style="fill:#1565C0"/>
    <text x="80" y="23" text-anchor="middle" class="module-header-text">MySQL</text>
    <text x="80" y="55" text-anchor="middle" class="api-text">equipment_iqas</text>
    <text x="80" y="72" text-anchor="middle" class="api-text">rag_flow</text>
    <text x="80" y="89" text-anchor="middle" class="api-text">kb_* / rs_* / sys_*</text>
    <text x="80" y="106" text-anchor="middle" class="api-text">QRTZ_* 调度表</text>
  </g>

  <g transform="translate(440, 420)">
    <rect class="module" x="0" y="0" width="160" height="120" style="fill:#FCE4EC;stroke:#C62828"/>
    <rect x="0" y="0" width="160" height="35" rx="8" style="fill:#C62828"/>
    <text x="80" y="23" text-anchor="middle" style="fill:white;font-size:14px;font-weight:bold">Redis</text>
    <text x="80" y="55" text-anchor="middle" class="api-text">缓存 (DB 8)</text>
    <text x="80" y="72" text-anchor="middle" class="api-text">会话存储</text>
    <text x="80" y="89" text-anchor="middle" class="api-text">认证Token</text>
    <text x="80" y="106" text-anchor="middle" class="api-text">RagFlow Token缓存</text>
  </g>

  <g transform="translate(680, 420)">
    <rect class="module" x="0" y="0" width="160" height="120" style="fill:#F3E5F5;stroke:#6A1B9A"/>
    <rect x="0" y="0" width="160" height="35" rx="8" style="fill:#6A1B9A"/>
    <text x="80" y="23" text-anchor="middle" style="fill:white;font-size:14px;font-weight:bold">向量数据库</text>
    <text x="80" y="55" text-anchor="middle" class="api-text">Elasticsearch</text>
    <text x="80" y="72" text-anchor="middle" class="api-text">文档分块索引</text>
    <text x="80" y="89" text-anchor="middle" class="api-text">向量嵌入存储</text>
    <text x="80" y="106" text-anchor="middle" class="api-text">相似度检索</text>
  </g>

  <!-- LLM Service -->
  <g transform="translate(910, 55)">
    <rect class="module" x="0" y="0" width="160" height="120" style="fill:#FFF3E0;stroke:#E65100"/>
    <rect x="0" y="0" width="160" height="35" rx="8" style="fill:#E65100"/>
    <text x="80" y="23" text-anchor="middle" style="fill:white;font-size:14px;font-weight:bold">LLM服务</text>
    <text x="80" y="55" text-anchor="middle" class="api-text">Chat Model</text>
    <text x="80" y="72" text-anchor="middle" class="api-text">Embedding Model</text>
    <text x="80" y="89" text-anchor="middle" class="api-text">Rerank Model</text>
    <text x="80" y="106" text-anchor="middle" class="api-text">OCR/解析引擎</text>
  </g>

  <!-- Arrows -->
  <!-- frontend -> server (HTTP) -->
  <path d="M230,195 L340,195" class="arrow-http"/>
  <text x="285" y="188" class="label-http">HTTP/REST</text>

  <!-- server -> ragflow (HTTP) -->
  <path d="M580,195 L680,195" class="arrow-http"/>
  <text x="630" y="188" class="label-http">HTTP/REST</text>

  <!-- ragflow -> LLM -->
  <path d="M900,150 L910,150" class="arrow-api"/>
  <text x="905" y="143" class="label-api">API</text>

  <!-- server -> MySQL -->
  <path d="M460,335 L310,420" class="arrow-data"/>
  <text x="360" y="370" class="label-data">JDBC</text>

  <!-- server -> Redis -->
  <path d="M460,335 L520,420" class="arrow-data"/>
  <text x="500" y="370" class="label-data">Redis</text>

  <!-- ragflow -> MySQL -->
  <path d="M790,335 L330,420" class="arrow-data" stroke-dasharray="6,3"/>

  <!-- ragflow -> ES -->
  <path d="M790,335 L760,420" class="arrow-data"/>
  <text x="790" y="370" class="label-data">ES API</text>

  <!-- Legend -->
  <g transform="translate(30, 600)">
    <text x="0" y="15" style="font-size:14px;font-weight:bold;fill:#333">图例</text>
    <line x1="0" y1="35" x2="40" y2="35" class="arrow-http"/>
    <text x="50" y="40" class="label-http">HTTP/REST 接口调用</text>
    <line x1="0" y1="55" x2="40" y2="55" class="arrow-data"/>
    <text x="50" y="60" class="label-data">数据访问层连接</text>
    <line x1="0" y1="75" x2="40" y2="75" class="arrow-api"/>
    <text x="50" y="80" class="label-api">内部API调用</text>
  </g>
</svg>'''

# ============================================================================
# 4. 测试环境架构图 - Test Environment Architecture
# ============================================================================
test_env_svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1100 700" font-family="Microsoft YaHei, SimHei, sans-serif">
  <defs>
    <style>
      .server-box { fill: #E3F2FD; stroke: #1565C0; stroke-width: 2; rx: 8; }
      .server-header { fill: #1565C0; }
      .server-header-text { fill: white; font-size: 13px; font-weight: bold; }
      .client-box { fill: #E8F5E9; stroke: #2E7D32; stroke-width: 2; rx: 8; }
      .client-header { fill: #2E7D32; }
      .client-header-text { fill: white; font-size: 13px; font-weight: bold; }
      .service-text { fill: #333; font-size: 11px; }
      .port-text { fill: #E65100; font-size: 10px; font-weight: bold; }
      .arrow { stroke: #455A64; stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
      .arrow-dashed { stroke: #455A64; stroke-width: 1.5; fill: none; marker-end: url(#arrowhead); stroke-dasharray: 6,3; }
      .label { fill: #455A64; font-size: 10px; }
      .title { font-size: 20px; font-weight: bold; fill: #1a237e; }
      .note { fill: #666; font-size: 10px; font-style: italic; }
    </style>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#455A64"/>
    </marker>
  </defs>

  <text x="550" y="30" text-anchor="middle" class="title">知枢(KnovaQ) 测试环境架构图</text>

  <!-- Test Client -->
  <g transform="translate(30, 60)">
    <rect class="client-box" x="0" y="0" width="200" height="180"/>
    <rect class="client-header" x="0" y="0" width="200" height="35" rx="8"/>
    <text x="100" y="23" text-anchor="middle" class="client-header-text">测试客户端</text>
    <text x="100" y="55" text-anchor="middle" class="service-text">浏览器 (Chrome)</text>
    <text x="100" y="72" text-anchor="middle" class="service-text">Playwright 自动化</text>
    <text x="100" y="92" text-anchor="middle" class="service-text">──────────────</text>
    <text x="100" y="110" text-anchor="middle" class="service-text">Pytest 测试框架</text>
    <text x="100" y="127" text-anchor="middle" class="service-text">requests HTTP客户端</text>
    <text x="100" y="147" text-anchor="middle" class="port-text">访问端口 :80</text>
    <text x="100" y="165" text-anchor="middle" class="note">Windows 测试机</text>
  </g>

  <!-- Docker Host -->
  <g transform="translate(290, 50)">
    <rect x="0" y="0" width="780" height="620" rx="12" fill="none" stroke="#9E9E9E" stroke-width="3" stroke-dasharray="10,5"/>
    <text x="390" y="25" text-anchor="middle" style="font-size:16px;font-weight:bold;fill:#616161">Docker Compose 容器集群 (Linux 服务器)</text>

    <!-- Nginx (ragflow built-in) -->
    <g transform="translate(30, 50)">
      <rect class="server-box" x="0" y="0" width="160" height="130"/>
      <rect class="server-header" x="0" y="0" width="160" height="30" rx="8"/>
      <text x="80" y="20" text-anchor="middle" class="server-header-text">Nginx</text>
      <text x="80" y="50" text-anchor="middle" class="service-text">反向代理</text>
      <text x="80" y="67" text-anchor="middle" class="service-text">静态资源服务</text>
      <text x="80" y="87" text-anchor="middle" class="port-text">:80 (对外)</text>
      <text x="80" y="107" text-anchor="middle" class="service-text">→ ragflow :9384</text>
      <text x="80" y="122" text-anchor="middle" class="service-text">→ gaisoft :8088</text>
    </g>

    <!-- ragflow-server -->
    <g transform="translate(30, 220)">
      <rect class="server-box" x="0" y="0" width="160" height="130"/>
      <rect class="server-header" x="0" y="0" width="160" height="30" rx="8"/>
      <text x="80" y="20" text-anchor="middle" class="server-header-text">ragflow-server</text>
      <text x="80" y="50" text-anchor="middle" class="service-text">RAG 引擎核心</text>
      <text x="80" y="67" text-anchor="middle" class="service-text">文档解析/分块</text>
      <text x="80" y="84" text-anchor="middle" class="service-text">向量检索</text>
      <text x="80" y="104" text-anchor="middle" class="port-text">:9384</text>
      <text x="80" y="122" text-anchor="middle" class="service-text">API v1 接口</text>
    </g>

    <!-- gaisoft-server -->
    <g transform="translate(230, 50)">
      <rect class="server-box" x="0" y="0" width="160" height="130"/>
      <rect class="server-header" x="0" y="0" width="160" height="30" rx="8"/>
      <text x="80" y="20" text-anchor="middle" class="server-header-text">gaisoft-server</text>
      <text x="80" y="50" text-anchor="middle" class="service-text">Spring Boot</text>
      <text x="80" y="67" text-anchor="middle" class="service-text">MES业务后端</text>
      <text x="80" y="84" text-anchor="middle" class="service-text">知识库管理API</text>
      <text x="80" y="104" text-anchor="middle" class="port-text">:8088</text>
      <text x="80" y="122" text-anchor="middle" class="service-text">问答代理/转发</text>
    </g>

    <!-- ragflow-mysql -->
    <g transform="translate(230, 220)">
      <rect class="server-box" x="0" y="0" width="160" height="130" style="fill:#E8EAF6;stroke:#283593"/>
      <rect x="0" y="0" width="160" height="30" rx="8" style="fill:#283593"/>
      <text x="80" y="20" text-anchor="middle" style="fill:white;font-size:13px;font-weight:bold">ragflow-mysql</text>
      <text x="80" y="50" text-anchor="middle" class="service-text">MySQL 8.0</text>
      <text x="80" y="67" text-anchor="middle" class="service-text">rag_flow 数据库</text>
      <text x="80" y="84" text-anchor="middle" class="service-text">equipment_iqas 数据库</text>
      <text x="80" y="104" text-anchor="middle" class="port-text">:3306</text>
    </g>

    <!-- ragflow-redis -->
    <g transform="translate(430, 50)">
      <rect class="server-box" x="0" y="0" width="160" height="130" style="fill:#FCE4EC;stroke:#C62828"/>
      <rect x="0" y="0" width="160" height="30" rx="8" style="fill:#C62828"/>
      <text x="80" y="20" text-anchor="middle" style="fill:white;font-size:13px;font-weight:bold">ragflow-redis</text>
      <text x="80" y="50" text-anchor="middle" class="service-text">Redis 缓存</text>
      <text x="80" y="67" text-anchor="middle" class="service-text">会话/Token缓存</text>
      <text x="80" y="84" text-anchor="middle" class="service-text">队列服务</text>
      <text x="80" y="104" text-anchor="middle" class="port-text">:6379</text>
    </g>

    <!-- Elasticsearch -->
    <g transform="translate(430, 220)">
      <rect class="server-box" x="0" y="0" width="160" height="130" style="fill:#F3E5F5;stroke:#6A1B9A"/>
      <rect x="0" y="0" width="160" height="30" rx="8" style="fill:#6A1B9A"/>
      <text x="80" y="20" text-anchor="middle" style="fill:white;font-size:13px;font-weight:bold">elasticsearch</text>
      <text x="80" y="50" text-anchor="middle" class="service-text">ES 8.x</text>
      <text x="80" y="67" text-anchor="middle" class="service-text">文档索引存储</text>
      <text x="80" y="84" text-anchor="middle" class="service-text">向量检索引擎</text>
      <text x="80" y="104" text-anchor="middle" class="port-text">:9200</text>
    </g>

    <!-- MinIO -->
    <g transform="translate(630, 50)">
      <rect class="server-box" x="0" y="0" width="130" height="130" style="fill:#FFF3E0;stroke:#E65100"/>
      <rect x="0" y="0" width="130" height="30" rx="8" style="fill:#E65100"/>
      <text x="65" y="20" text-anchor="middle" style="fill:white;font-size:13px;font-weight:bold">MinIO</text>
      <text x="65" y="50" text-anchor="middle" class="service-text">对象存储</text>
      <text x="65" y="67" text-anchor="middle" class="service-text">文件上传</text>
      <text x="65" y="84" text-anchor="middle" class="service-text">PDF/Word</text>
      <text x="65" y="104" text-anchor="middle" class="port-text">:9000</text>
    </g>

    <!-- Other ragflow services -->
    <g transform="translate(630, 220)">
      <rect class="server-box" x="0" y="0" width="130" height="130" style="fill:#ECEFF1;stroke:#546E7A"/>
      <rect x="0" y="0" width="130" height="30" rx="8" style="fill:#546E7A"/>
      <text x="65" y="20" text-anchor="middle" style="fill:white;font-size:12px;font-weight:bold">辅助服务</text>
      <text x="65" y="50" text-anchor="middle" class="service-text">ragflow-taskExecutor</text>
      <text x="65" y="67" text-anchor="middle" class="service-text">infinity (向量)</text>
      <text x="65" y="84" text-anchor="middle" class="service-text">selenium (解析)</text>
    </g>

    <!-- Data volume layer -->
    <g transform="translate(30, 400)">
      <rect x="0" y="0" width="730" height="80" rx="8" fill="#FFF8E1" stroke="#F9A825" stroke-width="1.5"/>
      <text x="365" y="20" text-anchor="middle" style="font-size:13px;font-weight:bold;fill:#F57F17">Docker 持久化卷</text>
      <text x="120" y="45" text-anchor="middle" class="service-text">mysql_data/</text>
      <text x="300" y="45" text-anchor="middle" class="service-text">redis_data/</text>
      <text x="480" y="45" text-anchor="middle" class="service-text">es_data/</text>
      <text x="640" y="45" text-anchor="middle" class="service-text">minio_data/</text>
      <text x="120" y="65" text-anchor="middle" class="service-text">ragflow/ (配置)</text>
      <text x="365" y="65" text-anchor="middle" class="service-text">gaisoft/uploadfile/ (上传文件)</text>
    </g>

    <!-- Internal connections -->
    <path d="M110,180 L110,220" class="arrow-dashed"/>
    <path d="M310,180 L310,220" class="arrow-dashed"/>
    <path d="M510,180 L510,220" class="arrow-dashed"/>
  </g>

  <!-- Client -> Nginx -->
  <path d="M230,150 L320,110" class="arrow"/>
  <text x="260" y="118" class="label">HTTP :80</text>

  <!-- Network label -->
  <g transform="translate(290, 510)">
    <rect x="0" y="0" width="780" height="50" rx="8" fill="#E8F5E9" stroke="#2E7D32" stroke-width="1.5"/>
    <text x="390" y="20" text-anchor="middle" style="font-size:13px;font-weight:bold;fill:#2E7D32">ragflow 桥接网络 (docker_ragflow)</text>
    <text x="390" y="40" text-anchor="middle" class="service-text">所有容器共享同一网络，通过容器名互相访问</text>
  </g>

  <!-- Test tools annotation -->
  <g transform="translate(30, 580)">
    <rect x="0" y="0" width="1040" height="90" rx="8" fill="#FFF3E0" stroke="#E65100" stroke-width="1.5"/>
    <text x="520" y="20" text-anchor="middle" style="font-size:13px;font-weight:bold;fill:#E65100">测试工具链</text>
    <text x="170" y="45" text-anchor="middle" class="service-text">Pytest 8.x (Python 测试框架)</text>
    <text x="440" y="45" text-anchor="middle" class="service-text">Playwright (浏览器自动化)</text>
    <text x="700" y="45" text-anchor="middle" class="service-text">requests (HTTP API 测试)</text>
    <text x="920" y="45" text-anchor="middle" class="service-text">Docker CLI (容器管理)</text>
    <text x="260" y="70" text-anchor="middle" class="service-text">48 E2E 测试用例 (6模块)</text>
    <text x="600" y="70" text-anchor="middle" class="service-text">覆盖: 认证 / 知识库 / 问答 / 文档 / 设备 / 系统</text>
  </g>
</svg>'''

# Generate all images
print('Generating images...')
save_svg_and_png('ER图', er_svg)
save_svg_and_png('问答流程活动图', qa_flow_svg)
save_svg_and_png('内部接口示意图', internal_if_svg)
save_svg_and_png('测试环境架构图', test_env_svg)
print('Done! All 4 images generated.')
