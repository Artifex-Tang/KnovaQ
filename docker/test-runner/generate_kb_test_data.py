#!/usr/bin/env python3
"""Generate topic-organized knowledge base test data for RAG testing.

Creates 960 files across 6 military equipment domain topics:
  雷达系统, 通信装备, 导弹武器, 装甲车辆, 后勤保障, 电子对抗

Each topic gets: 30 PDF, 30 DOCX, 30 XLSX, 30 TXT, 30 MD, 10 JSON (QA pairs)
Total: 6 × (30×5 + 10) = 960 files

Usage:
    python generate_kb_test_data.py
    python generate_kb_test_data.py --topics 雷达系统 通信装备
    python generate_kb_test_data.py --count 10 --formats pdf,docx,json
"""

import argparse
import json
import os
import sys
import time
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from fixtures.test_data_factory import generate_docx, generate_pdf, generate_txt, generate_xlsx

# ═══════════════════════════════════════════════════════════════
# Output base directory
# ═══════════════════════════════════════════════════════════════

OUTPUT_BASE = Path(__file__).parent / "test_data" / "kb_topics"

# ═══════════════════════════════════════════════════════════════
# Topic definitions — 6 military equipment domains
# ═══════════════════════════════════════════════════════════════

TOPICS = {
    "雷达系统": {
        "english": "Radar Systems",
        "subtopics": [
            "相控阵天线", "脉冲压缩", "频率合成器", "信号处理算法", "杂波抑制",
            "目标跟踪", "电子扫描", "多普勒处理", "波形设计", "天线校准",
            "发射机维护", "接收机测试", "波导系统", "低噪声放大器", "数据链路",
            "BIT自检", "冷却系统", "频谱管理", "目标识别", "干扰抑制",
            "雷达组网", "反隐身技术", "气象雷达", "合成孔径", "机动目标检测",
            "雷达截面积", "旁瓣抑制", "距离分辨率", "角分辨率", "系统标校",
        ],
        "xlsx_headers": ["装备型号", "参数名称", "参数值", "单位", "检验标准", "备注"],
        "xlsx_data": [
            ["AN/TPQ-53", "工作频段", "8-12", "GHz", "GJB 7869-2012", "X波段"],
            ["AN/TPQ-53", "峰值功率", "45", "kW", "GJB 7869-2012", "行波管输出"],
            ["AN/TPQ-53", "探测距离", "60", "km", "GJB 7869-2012", "火炮定位"],
            ["AN/TPQ-53", "方位覆盖", "360", "度", "设计指标", "全向扫描"],
            ["AN/TPQ-53", "仰角覆盖", "-5~+85", "度", "设计指标", "俯仰扫描"],
            ["AN/TPQ-53", "MTBF", "500", "小时", "GJB 899A-2009", "可靠性试验"],
            ["YLC-8B", "工作频段", "1-2", "GHz", "GJB 7869-2012", "L波段"],
            ["YLC-8B", "探测距离", "320", "km", "出厂检验", "对空警戒"],
            ["YLC-8B", "峰值功率", "250", "kW", "GJB 7869-2012", "固态发射"],
            ["JY-27A", "工作频段", "0.5-1", "GHz", "GJB 7869-2012", "VHF/UHF"],
            ["JY-27A", "探测距离", "500", "km", "出厂检验", "远程预警"],
            ["JY-27A", "反隐身能力", "有", "", "专项测试", "米波反隐身"],
            ["H-200", "工作频段", "2-4", "GHz", "GJB 7869-2012", "S波段"],
            ["H-200", "探测距离", "150", "km", "出厂检验", "目标指示"],
            ["H-200", "跟踪精度", "30", "m", "GJB 7869-2012", "距离精度"],
        ],
        "qa_pairs": [
            {"question": "AN/TPQ-53雷达的工作频段是什么？", "answer": "X波段（8-12 GHz）", "keywords": ["频段", "X波段", "8", "12"]},
            {"question": "AN/TPQ-53雷达的探测距离是多少？", "answer": "60公里（火炮定位模式）", "keywords": ["探测距离", "60", "公里"]},
            {"question": "YLC-8B雷达的峰值功率是多少？", "answer": "250 kW（固态发射）", "keywords": ["功率", "250", "固态"]},
            {"question": "JY-27A雷达的主要特点是什么？", "answer": "米波反隐身远程预警，探测距离500公里", "keywords": ["反隐身", "500", "米波"]},
            {"question": "雷达ERR-001故障代码表示什么？", "answer": "发射机功率不足，需检查行波管和高压电源", "keywords": ["ERR-001", "发射机", "功率"]},
            {"question": "雷达周维护中波导连接处的扭矩值范围？", "answer": "25-30 N·m", "keywords": ["扭矩", "25", "30"]},
            {"question": "雷达接收机灵敏度指标是多少？", "answer": "最小可检测信号优于-110 dBm", "keywords": ["灵敏度", "-110", "dBm"]},
            {"question": "相控阵雷达的主要优势是什么？", "answer": "电子扫描无机械转动，波束切换速度快，可同时多目标跟踪", "keywords": ["相控阵", "电子扫描", "多目标"]},
            {"question": "脉冲压缩技术的作用是什么？", "answer": "在不增加峰值功率的情况下提高距离分辨率，实现大时宽带宽积", "keywords": ["脉冲压缩", "分辨率", "时宽带宽"]},
            {"question": "雷达冷却系统液位正常范围？", "answer": "4.5-5.5升", "keywords": ["冷却", "液位", "4.5", "5.5"]},
        ],
    },

    "通信装备": {
        "english": "Communications Equipment",
        "subtopics": [
            "超短波电台", "短波通信", "卫星通信", "跳频通信", "数据链路",
            "加密模块", "天线系统", "功率放大器", "中继设备", "野战交换机",
            "光纤通信", "战术互联网", "通信保密", "频谱监测", "电磁兼容",
            "通信侦察", "软件无线电", "自组网", "抗干扰技术", "通信协议",
            "语音终端", "数据终端", "图像传输", "通信车改装", "通信线缆",
            "接地防雷", "电源管理", "远程遥控", "通信网管", "应急通信",
        ],
        "xlsx_headers": ["装备型号", "参数名称", "参数值", "单位", "检验标准", "备注"],
        "xlsx_data": [
            ["ZBD-2000", "频率范围", "30-512", "MHz", "GJB 2924-1997", "全频段覆盖"],
            ["ZBD-2000", "输出功率", "5/20/50", "W", "GJB 2924-1997", "三档可调"],
            ["ZBD-2000", "工作温度", "-40~+55", "°C", "GJB 150A-2009", "全温度范围"],
            ["ZBD-2000", "防护等级", "IP67", "", "GJB 4206-2000", "防尘防水"],
            ["ZBD-2000", "重量", "3.5", "kg", "称重", "含电池"],
            ["HCN-518", "频率范围", "1.5-30", "MHz", "GJB 2924-1997", "短波频段"],
            ["HCN-518", "输出功率", "100/400", "W", "出厂检验", "车载/固定"],
            ["HCN-518", "调制方式", "AM/CW/USB/LSB", "", "GJB 2924-1997", "多模式"],
            ["BD-1", "工作频段", "1553/1610", "MHz", "GJB 7266-2011", "北斗一号"],
            ["BD-1", "定位精度", "20", "m", "GJB 7266-2011", "单点定位"],
            ["BD-1", "通信容量", "5600", "bit/s", "设计指标", "短报文"],
            ["TJJ-501", "跳频速率", "500", "跳/秒", "GJB 2924-1997", "高速跳频"],
            ["TJJ-501", "跳频带宽", "60", "MHz", "出厂检验", "宽频跳变"],
            ["TJJ-501", "同步时间", "<2", "秒", "设计指标", "快速同步"],
            ["TJJ-501", "抗干扰容限", ">20", "dB", "GJB 2924-1997", "抗干扰能力"],
        ],
        "qa_pairs": [
            {"question": "ZBD-2000通信系统的频率范围？", "answer": "30-512 MHz", "keywords": ["频率", "30", "512"]},
            {"question": "ZBD-2000防护等级是多少？", "answer": "IP67", "keywords": ["防护", "IP67"]},
            {"question": "ZBD-2000通信装备重量限制？", "answer": "小于3.5kg（含电池）", "keywords": ["重量", "3.5"]},
            {"question": "加密通信需要插入什么？", "answer": "加密模块", "keywords": ["加密", "模块"]},
            {"question": "通信装备开机后自检大约需要多少秒？", "answer": "约15秒", "keywords": ["自检", "15秒"]},
            {"question": "HCN-518短波电台的输出功率是多少？", "answer": "100W（车载）/400W（固定）", "keywords": ["功率", "100", "400"]},
            {"question": "TJJ-501跳频速率是多少？", "answer": "500跳/秒", "keywords": ["跳频", "500"]},
            {"question": "北斗一号的定位精度？", "answer": "20米（单点定位）", "keywords": ["定位", "20", "精度"]},
            {"question": "通信装备的频率设置步骤有哪些？", "answer": "进入信道管理、选择信道号、输入频率值、设置调制方式、保存确认", "keywords": ["频率", "信道", "设置"]},
            {"question": "野战交换机的主要功能？", "answer": "提供有线/无线语音和数据交换，支持组网和路由功能", "keywords": ["交换机", "语音", "数据"]},
        ],
    },

    "导弹武器": {
        "english": "Missile Weapons",
        "subtopics": [
            "制导系统", "推进系统", "战斗部", "引信系统", "发射装置",
            "惯性导航", "红外导引", "雷达导引", "卫星制导", "激光制导",
            "固体火箭", "液体火箭", "冲压发动机", "导弹贮存", "运输转载",
            "发射控制", "火力规划", "目标分配", "毁伤评估", "抗干扰措施",
            "隐身技术", "末端机动", "多模制导", "导弹测试", "延寿维护",
            "导弹总装", "质量检验", "弹体结构", "舵面控制", "安全保险",
        ],
        "xlsx_headers": ["装备型号", "参数名称", "参数值", "单位", "检验标准", "备注"],
        "xlsx_data": [
            ["HQ-9B", "射程", "200", "km", "GJB 5309-2004", "防空导弹"],
            ["HQ-9B", "射高", "0.5-30", "km", "GJB 5309-2004", "有效射高"],
            ["HQ-9B", "最大速度", "4.2", "Ma", "出厂检验", "超音速"],
            ["HQ-9B", "制导方式", "惯导+中继+末制导", "", "GJB 5309-2004", "复合制导"],
            ["HQ-9B", "战斗部", "180", "kg", "设计指标", "高爆破片"],
            ["YJ-18", "射程", "400", "km", "GJB 5309-2004", "反舰导弹"],
            ["YJ-18", "巡航速度", "0.8", "Ma", "出厂检验", "亚音速巡航"],
            ["YJ-18", "末段速度", "3.0", "Ma", "设计指标", "超音速突防"],
            ["YJ-18", "发射方式", "垂发/倾斜", "", "GJB 5309-2004", "多平台"],
            ["DF-26", "射程", "4000", "km", "GJB 5309-2004", "中远程弹道"],
            ["DF-26", "CEP", "30", "m", "出厂检验", "圆概率误差"],
            ["DF-26", "弹头类型", "常规/核", "", "设计指标", "双用途"],
            ["PL-15", "射程", "200", "km", "GJB 5309-2004", "空空导弹"],
            ["PL-15", "制导方式", "主动雷达", "", "出厂检验", "末段主动"],
            ["PL-15", "最大过载", "40", "g", "设计指标", "高机动"],
        ],
        "qa_pairs": [
            {"question": "HQ-9B防空导弹的最大射程是多少？", "answer": "200公里", "keywords": ["射程", "200", "HQ-9B"]},
            {"question": "YJ-18反舰导弹的末段突防速度？", "answer": "3.0马赫", "keywords": ["末段", "3.0", "马赫"]},
            {"question": "DF-26中远程导弹的圆概率误差是多少？", "answer": "30米", "keywords": ["CEP", "30", "误差"]},
            {"question": "导弹固体火箭发动机的主要优点？", "answer": "反应速度快、维护简单、可长期战备值班", "keywords": ["固体", "反应", "维护"]},
            {"question": "PL-15空空导弹的最大过载是多少？", "answer": "40g", "keywords": ["过载", "40", "PL-15"]},
            {"question": "导弹贮存的环境温度要求？", "answer": "-30°C至+40°C，相对湿度不大于75%", "keywords": ["贮存", "温度", "湿度"]},
            {"question": "导弹发射前的安全检查项目有哪些？", "answer": "检查发射筒密封、电气连接、保险装置、弹体外观", "keywords": ["发射", "安全", "检查"]},
            {"question": "红外导引头的主要优势是什么？", "answer": "被动探测不发射电磁波、精度高、抗电子干扰", "keywords": ["红外", "被动", "精度"]},
            {"question": "导弹延寿维护的周期是多长？", "answer": "通常每5年进行一次延寿检测和维护", "keywords": ["延寿", "5年", "维护"]},
            {"question": "多模制导技术的优势？", "answer": "提高抗干扰能力和命中精度，适应复杂战场环境", "keywords": ["多模", "抗干扰", "精度"]},
        ],
    },

    "装甲车辆": {
        "english": "Armor Vehicles",
        "subtopics": [
            "主战坦克", "步兵战车", "装甲输送车", "发动机系统", "传动系统",
            "行走机构", "火控系统", "炮塔机构", "弹药装填", "观瞄设备",
            "通信系统", "三防系统", "灭火抑爆", "空调系统", "电气系统",
            "液压系统", "悬挂系统", "扫雷装置", "抢修车辆", "架桥坦克",
            "装甲防护", "反应装甲", "主动防护", "烟幕系统", "激光告警",
            "驾驶训练", "射击训练", "战场抢修", "保养规程", "故障诊断",
        ],
        "xlsx_headers": ["装备型号", "参数名称", "参数值", "单位", "检验标准", "备注"],
        "xlsx_data": [
            ["ZTZ-99A", "战斗全重", "55", "t", "GJB 792-1990", "第三代主战坦克"],
            ["ZTZ-99A", "发动机功率", "1500", "hp", "GJB 792-1990", "柴油发动机"],
            ["ZTZ-99A", "最大速度", "70", "km/h", "出厂检验", "公路行驶"],
            ["ZTZ-99A", "主炮口径", "125", "mm", "GJB 792-1990", "滑膛炮"],
            ["ZTZ-99A", "弹药基数", "41", "发", "设计指标", "含炮射导弹"],
            ["ZBD-04A", "战斗全重", "24.5", "t", "GJB 792-1990", "步兵战车"],
            ["ZBD-04A", "发动机功率", "600", "hp", "GJB 792-1990", "柴油发动机"],
            ["ZBD-04A", "最大速度", "65", "km/h", "出厂检验", "公路行驶"],
            ["ZBD-04A", "水上速度", "6", "km/h", "设计指标", "浮渡能力"],
            ["ZBD-04A", "乘员/载员", "3+7", "人", "设计指标", "标准配置"],
            ["PLZ-05", "战斗全重", "35", "t", "GJB 792-1990", "自行榴弹炮"],
            ["PLZ-05", "口径", "155", "mm", "GJB 792-1990", "榴弹炮"],
            ["PLZ-05", "最大射程", "39", "km", "出厂检验", "底排弹"],
            ["PLZ-05", "射速", "8", "发/分", "设计指标", "最大射速"],
            ["PLZ-05", "弹药基数", "30", "发", "设计指标", "携弹量"],
        ],
        "qa_pairs": [
            {"question": "ZTZ-99A主战坦克的战斗全重是多少？", "answer": "55吨", "keywords": ["重量", "55", "99A"]},
            {"question": "ZTZ-99A的发动机功率？", "answer": "1500马力", "keywords": ["功率", "1500", "马力"]},
            {"question": "ZBD-04A步兵战车的水上速度？", "answer": "6公里/小时", "keywords": ["水上", "速度", "6"]},
            {"question": "PLZ-05自行榴弹炮的最大射程？", "answer": "39公里（使用底排弹）", "keywords": ["射程", "39", "底排弹"]},
            {"question": "坦克发动机机油检查的周期是？", "answer": "每500公里或每周检查", "keywords": ["机油", "500", "每周"]},
            {"question": "反应装甲的工作原理是什么？", "answer": "被命中时引爆内部炸药，形成反向射流抵消破甲弹的金属射流", "keywords": ["反应装甲", "射流", "抵消"]},
            {"question": "坦克三防系统的功能？", "answer": "核生化防护，包括超压通风、滤毒、辐射报警", "keywords": ["三防", "核生化", "超压"]},
            {"question": "装甲车辆灭火抑爆系统的响应时间？", "answer": "小于5毫秒检测、小于150毫秒灭火", "keywords": ["灭火", "抑爆", "毫秒"]},
            {"question": "坦克火控系统的组成包括哪些部分？", "answer": "激光测距仪、弹道计算机、热成像瞄准镜、稳定器", "keywords": ["火控", "激光", "弹道"]},
            {"question": "装甲车辆战场抢修的基本原则？", "answer": "先保战斗力后保完整、先修关键部件后修一般部件", "keywords": ["抢修", "战斗力", "关键部件"]},
        ],
    },

    "后勤保障": {
        "english": "Logistics Support",
        "subtopics": [
            "补给管理", "运输调度", "仓储管理", "油料保障", "弹药管理",
            "给养供应", "被装管理", "营房建设", "医疗保障", "卫生防疫",
            "装备抢修", "备件管理", "供水保障", "供电保障", "道路抢修",
            "野战仓库", "集装箱运输", "铁路军事运输", "空运投送", "海上补给",
            "物资编码", "条码管理", "库存盘点", "供应链优化", "应急物资",
            "战场救护", "伤员后送", "血液保障", "药品管理", "卫生装备",
        ],
        "xlsx_headers": ["物资类别", "物资名称", "规格型号", "单位", "储备定额", "备注"],
        "xlsx_data": [
            ["油料类", "柴油", "-10号/0号", "升", "50000", "冬/夏季用"],
            ["油料类", "汽油", "95号", "升", "20000", "车辆用油"],
            ["油料类", "航空煤油", "RP-3", "升", "100000", "直升机用"],
            ["弹药类", "125mm榴弹", "杀爆弹", "发", "200", "坦克炮弹"],
            ["弹药类", "155mm榴弹", "底排弹", "发", "500", "火炮弹药"],
            ["弹药类", "5.8mm步枪弹", "普通弹", "发", "100000", "轻武器弹药"],
            ["给养类", "单兵口粮", "09式", "份", "5000", "三日份"],
            ["给养类", "饮用水", "瓶装5L", "瓶", "10000", "日常供应"],
            ["给养类", "压缩干粮", "军用型", "箱", "2000", "应急储备"],
            ["被装类", "作战靴", "07式", "双", "3000", "按码配发"],
            ["被装类", "迷彩服", "07丛林", "套", "5000", "季节更换"],
            ["药品类", "止血带", "CAT型", "条", "2000", "战伤急救"],
            ["药品类", "吗啡注射器", "自动型", "支", "500", "镇痛用"],
            ["药品类", "碘伏消毒液", "500ml", "瓶", "1000", "创面消毒"],
            ["备件类", "发动机总成", "1500hp型", "台", "5", "主战坦克"],
        ],
        "qa_pairs": [
            {"question": "军用柴油的牌号有哪些？", "answer": "-10号（冬季用）和0号（夏季用）", "keywords": ["柴油", "-10", "0号"]},
            {"question": "09式单兵口粮包含几日份？", "answer": "三日份", "keywords": ["口粮", "三日"]},
            {"question": "弹药储存的温度要求？", "answer": "-20°C至+40°C", "keywords": ["弹药", "温度", "-20", "40"]},
            {"question": "弹药储存的湿度要求？", "answer": "相对湿度45%-75%", "keywords": ["弹药", "湿度", "45", "75"]},
            {"question": "战场救护的基本原则是什么？", "answer": "先重后轻、先止血后包扎、先固定后搬运", "keywords": ["救护", "止血", "包扎"]},
            {"question": "航空煤油的牌号是什么？", "answer": "RP-3", "keywords": ["航空煤油", "RP-3"]},
            {"question": "集装箱运输的标准箱型有哪些？", "answer": "20尺标准箱和40尺标准箱", "keywords": ["集装箱", "20尺", "40尺"]},
            {"question": "野战仓库的选址要求？", "answer": "交通便利、隐蔽伪装、地势较高、排水良好", "keywords": ["仓库", "选址", "隐蔽"]},
            {"question": "备件管理的ABC分类法是什么？", "answer": "A类高价值少数量重点管理、B类中等、C类低价值大量简化管理", "keywords": ["ABC", "分类", "管理"]},
            {"question": "铁路军事运输的装载限界标准？", "answer": "货物高度不超过5300mm，宽度不超过3400mm", "keywords": ["铁路", "限界", "5300"]},
        ],
    },

    "电子对抗": {
        "english": "Electronic Warfare",
        "subtopics": [
            "电子侦察", "电子干扰", "电子防护", "频谱管理", "信号情报",
            "通信对抗", "雷达对抗", "光电对抗", "导航对抗", "网络对抗",
            "电子支援", "电磁环境", "干扰样式", "欺骗干扰", "压制干扰",
            "侦察接收机", "测向定位", "信号分析", "脉冲分选", "威胁识别",
            "电磁静默", "频率跳变", "功率管理", "电子告警", "抗干扰措施",
            "电子战飞机", "电子战无人机", "舰载电子战", "地面电子战", "综合电子战",
        ],
        "xlsx_headers": ["装备型号", "参数名称", "参数值", "单位", "检验标准", "备注"],
        "xlsx_data": [
            ["ECM-2000", "频段覆盖", "0.5-18", "GHz", "GJB 7866-2012", "全频段侦察"],
            ["ECM-2000", "灵敏度", "-90", "dBm", "GJB 7866-2012", "接收灵敏度"],
            ["ECM-2000", "动态范围", "70", "dB", "出厂检验", "瞬时动态"],
            ["ECM-2000", "测向精度", "2", "度(RMS)", "GJB 7866-2012", "干涉仪测向"],
            ["ECM-2000", "干扰功率", "500", "W", "设计指标", "有效辐射"],
            ["ESM-300", "频段覆盖", "2-40", "GHz", "GJB 7866-2012", "毫米波覆盖"],
            ["ESM-300", "信号环境", "100万", "脉冲/秒", "出厂检验", "高密度环境"],
            ["ESM-300", "分选能力", "同时1000", "个辐射源", "设计指标", "脉冲去交错"],
            ["SECM-100", "通信侦察频段", "20-3000", "MHz", "GJB 7866-2012", "通信频段"],
            ["SECM-100", "解调方式", "AM/FM/PM/FSK/PSK", "", "出厂检验", "多制式解调"],
            ["SECM-100", "测向精度", "3", "度(RMS)", "GJB 7866-2012", "多基站定位"],
            ["SECM-100", "干扰带宽", "60", "MHz", "设计指标", "宽带阻塞"],
            ["NCW-500", "网络侦察协议", "TCP/IP全协议", "", "GJB 7866-2012", "协议分析"],
            ["NCW-500", "漏洞扫描速度", "1000", "IP/分钟", "出厂检验", "高速扫描"],
            ["NCW-500", "渗透测试模块", "200+", "个", "设计指标", "攻击载荷"],
        ],
        "qa_pairs": [
            {"question": "ECM-2000电子对抗系统的频段覆盖范围？", "answer": "0.5-18 GHz", "keywords": ["频段", "0.5", "18"]},
            {"question": "电子侦察接收机的灵敏度指标是多少？", "answer": "-90 dBm", "keywords": ["灵敏度", "-90", "dBm"]},
            {"question": "欺骗干扰和压制干扰的区别是什么？", "answer": "欺骗干扰发射虚假信号误导敌方，压制干扰用大功率噪声淹没信号", "keywords": ["欺骗", "压制", "干扰"]},
            {"question": "ESM-300系统的脉冲分选能力？", "answer": "可同时处理1000个辐射源", "keywords": ["分选", "1000", "辐射源"]},
            {"question": "跳频通信的抗干扰原理？", "answer": "频率按伪随机码快速跳变，使干扰方无法跟踪", "keywords": ["跳频", "伪随机", "抗干扰"]},
            {"question": "电子战飞机的主要任务是什么？", "answer": "防空压制、电子侦察、对敌防空火力打击引导", "keywords": ["电子战", "防空压制", "侦察"]},
            {"question": "光电对抗的主要手段有哪些？", "answer": "红外诱饵、激光告警、烟幕遮蔽、激光致盲", "keywords": ["光电", "红外", "激光"]},
            {"question": "电磁静默的战术目的是什么？", "answer": "避免己方电磁辐射被敌方侦察发现，隐蔽作战意图", "keywords": ["静默", "隐蔽", "侦察"]},
            {"question": "网络对抗的主要技术手段？", "answer": "网络侦察、漏洞利用、渗透攻击、网络防御", "keywords": ["网络", "渗透", "漏洞"]},
            {"question": "综合电子战系统的特点？", "answer": "集侦察、干扰、防护于一体，实现多平台多手段协同", "keywords": ["综合", "协同", "一体化"]},
        ],
    },
}


# ═══════════════════════════════════════════════════════════════
# Content generation helpers
# ═══════════════════════════════════════════════════════════════

# Size tiers: vary content length
SIZE_MULTIPLIERS = {
    "small": 1,    # 1-3 KB
    "medium": 3,   # 5-15 KB
    "large": 8,    # 20-50 KB
}


def _size_tier(seq: int) -> str:
    """Assign size tier based on sequence number."""
    if seq % 3 == 0:
        return "large"
    elif seq % 3 == 1:
        return "small"
    else:
        return "medium"


def _generate_rich_content(topic_name: str, subtopic: str, seq: int, ext: str) -> str:
    """Generate unique, domain-specific content for a given topic + subtopic."""
    topic_info = TOPICS[topic_name]
    english = topic_info["english"]
    tier = _size_tier(seq)

    # Build document with realistic military content
    parts = []

    # ── Header section ──
    parts.append(f"# {topic_name}·{subtopic} 技术文档")
    parts.append(f"")
    parts.append(f"**文件编号：** GJB-{topic_name[:2].encode('utf-8').hex().upper()[:4]}-{seq:03d}-2024")
    parts.append(f"**主题分类：** {topic_name} / {english}")
    parts.append(f"**子主题：** {subtopic}")
    parts.append(f"**密级：** 内部")
    parts.append(f"**编制日期：** 2024年{(seq % 12) + 1:02d}月{(seq % 28) + 1:02d}日")
    parts.append(f"")

    # ── Chapter 1: 概述 ──
    parts.append(f"## 第一章 概述")
    parts.append(f"")
    parts.append(f"本文档针对{topic_name}领域中的{subtopic}进行系统性阐述。"
                 f"{subtopic}是{topic_name}技术体系的重要组成部分，"
                 f"对于提升装备作战效能具有关键作用。")
    parts.append(f"")
    parts.append(f"### 1.1 背景与意义")
    parts.append(f"")
    parts.append(f"随着现代战争形态的演变，{topic_name}技术已成为信息化条件下作战能力的重要支撑。"
                 f"{subtopic}作为{topic_name}的核心环节，直接影响装备的实战性能和可靠性。"
                 f"根据GJB 9001C-2017质量管理体系要求，必须对{subtopic}进行规范化管理。")
    parts.append(f"")
    parts.append(f"### 1.2 适用范围")
    parts.append(f"")
    parts.append(f"本技术文档适用于以下单位和场景：")
    parts.append(f"- 装备研制生产单位的质量控制")
    parts.append(f"- 部队使用单位的操作维护指导")
    parts.append(f"- 院校教学训练的参考教材")
    parts.append(f"- 维修保障机构的技术依据")
    parts.append(f"")

    # ── Chapter 2: 技术参数 ──
    parts.append(f"## 第二章 技术参数与指标")
    parts.append(f"")
    parts.append(f"### 2.1 主要技术参数")
    parts.append(f"")
    xlsx_data = topic_info["xlsx_data"]
    for i, row in enumerate(xlsx_data[:5]):
        parts.append(f"- {row[1]}（{row[0]}）：{row[2]} {row[3]}，依据{row[4]}")
    parts.append(f"")

    # ── Chapter 3: Detailed subtopic content ──
    parts.append(f"## 第三章 {subtopic}技术详述")
    parts.append(f"")

    # Generate subtopic-specific paragraphs
    subtopic_paragraphs = _generate_subtopic_detail(topic_name, subtopic, seq)
    parts.extend(subtopic_paragraphs)
    parts.append(f"")

    # ── Chapter 4: 维护规程 ──
    parts.append(f"## 第四章 维护与检查规程")
    parts.append(f"")
    parts.append(f"### 4.1 日常维护")
    parts.append(f"")
    parts.append(f"每日检查项目：")
    parts.append(f"1. 外观检查：确认无破损、无锈蚀、无渗漏")
    parts.append(f"2. 电源检查：供电电压应在规定范围内（DC 24V ± 10%）")
    parts.append(f"3. 功能检查：运行自检程序，确认所有BIT项目通过")
    parts.append(f"4. 环境检查：工作温度在{-40 + seq}°C至{50 + seq}°C范围内")
    parts.append(f"5. 记录检查：填写当日维护记录表")
    parts.append(f"")
    parts.append(f"### 4.2 周维护")
    parts.append(f"")
    parts.append(f"每周维护项目：")
    parts.append(f"- 清洁设备表面及接口，使用无尘布和去离子水")
    parts.append(f"- 检查连接器紧固状态，扭矩值应在规定范围内")
    parts.append(f"- 校准测量基准，偏差不超过±{(seq % 5) + 1}%")
    parts.append(f"- 检查密封件完整性，必要时更换")
    parts.append(f"- 更新系统软件至最新版本")
    parts.append(f"")
    parts.append(f"### 4.3 月度维护")
    parts.append(f"")
    parts.append(f"每月维护项目：")
    parts.append(f"- 全面性能测试，对比出厂指标")
    parts.append(f"- 校准频率源，频率偏差不超过±{(seq % 100) + 50} Hz")
    parts.append(f"- 检查备用电源，容量不低于额定值的80%")
    parts.append(f"- 检查散热系统，清理散热片灰尘")
    parts.append(f"- 整理维护记录，归档技术文档")
    parts.append(f"")

    # ── Chapter 5: 故障诊断 ──
    parts.append(f"## 第五章 故障诊断与排除")
    parts.append(f"")
    parts.append(f"### 5.1 常见故障代码")
    parts.append(f"")
    fault_codes = [
        ("ERR-001", "功率不足", "检查发射模块和供电系统"),
        ("ERR-002", "信号异常", "检查信号链路和接口连接"),
        ("ERR-003", "通信中断", "检查数据链路和协议配置"),
        ("ERR-004", "温度过高", "检查散热系统和环境温度"),
        ("ERR-005", "校准失败", "检查基准源和校准程序"),
        ("ERR-006", "内存错误", "重启系统，检查存储模块"),
        ("ERR-007", "电源故障", "检查供电线路和保险丝"),
        ("ERR-008", "同步丢失", "检查时钟源和同步信号"),
    ]
    parts.append(f"| 故障代码 | 故障描述 | 处理措施 |")
    parts.append(f"|---------|---------|---------|")
    for code, desc, fix in fault_codes:
        parts.append(f"| {code} | {desc} | {fix} |")
    parts.append(f"")

    # ── Chapter 6: 训练大纲 (only for medium/large) ──
    if tier in ("medium", "large"):
        parts.append(f"## 第六章 训练与考核")
        parts.append(f"")
        parts.append(f"### 6.1 基础训练")
        parts.append(f"")
        parts.append(f"训练课时：{(seq % 4 + 2) * 8}学时")
        parts.append(f"训练对象：{topic_name}相关专业士兵和士官")
        parts.append(f"训练内容：")
        parts.append(f"- 理论学习：{subtopic}基本原理，{seq * 2}学时")
        parts.append(f"- 实操训练：设备操作规程，{seq * 3}学时")
        parts.append(f"- 故障排除：常见故障判断与处理，{seq}学时")
        parts.append(f"- 综合演练：实战条件下操作考核，{seq * 2}学时")
        parts.append(f"")
        parts.append(f"### 6.2 考核标准")
        parts.append(f"")
        parts.append(f"- 理论考核：闭卷考试，80分合格")
        parts.append(f"- 实操考核：标准化操作流程，独立完成时间不超过30分钟")
        parts.append(f"- 故障排除：在规定时间内完成指定故障的定位和排除")
        parts.append(f"")

    # ── Chapter 7: Safety (only for large) ──
    if tier == "large":
        parts.append(f"## 第七章 安全注意事项")
        parts.append(f"")
        parts.append(f"### 7.1 人员安全")
        parts.append(f"")
        parts.append(f"操作{topic_name}装备时必须遵守以下安全规定：")
        parts.append(f"1. 操作人员须经过专业培训并取得上岗资质")
        parts.append(f"2. 高压设备操作需两人协同，穿戴防护用具")
        parts.append(f"3. 发射状态下人员须退至安全距离以外")
        parts.append(f"4. 严禁在设备运行时进行未经授权的拆卸")
        parts.append(f"5. 发现异常立即按下紧急停止按钮并上报")
        parts.append(f"")
        parts.append(f"### 7.2 设备安全")
        parts.append(f"")
        parts.append(f"- 运输过程中必须使用专用减震包装")
        parts.append(f"- 存储环境温度：-30°C至+50°C")
        parts.append(f"- 相对湿度：不大于80%（无凝露）")
        parts.append(f"- 远离强电磁辐射源和腐蚀性气体")
        parts.append(f"- 定期通电检查，每季度不少于一次")
        parts.append(f"")
        parts.append(f"### 7.3 电磁安全")
        parts.append(f"")
        parts.append(f"- 严格按照频谱管理规定使用指定频段")
        parts.append(f"- 发射功率不得超过核定功率上限")
        parts.append(f"- 注意与其他电子设备的电磁兼容性")
        parts.append(f"- 电磁辐射防护按GJB 5313-2004执行")
        parts.append(f"")
        parts.append(f"### 7.4 应急处理")
        parts.append(f"")
        parts.append(f"遇到以下紧急情况时的处理程序：")
        parts.append(f"- 火情：立即断电，使用CO₂灭火器，报告上级")
        parts.append(f"- 漏电：切断总电源，隔离危险区域，通知维修人员")
        parts.append(f"- 辐射超标：立即撤离，设置警戒区，通知防化部门")
        parts.append(f"- 数据异常：暂停操作，记录现象，技术分析原因")
        parts.append(f"")

    # ── Appendix ──
    parts.append(f"## 附录A 相关标准引用")
    parts.append(f"")
    standards = [
        "GJB 9001C-2017 质量管理体系要求",
        "GJB 150A-2009 军用装备实验室环境试验方法",
        "GJB 899A-2009 可靠性鉴定和验收试验",
        "GJB 450B-2008 装备可靠性工作通用要求",
        "GJB 451A-2005 可靠性维修性保障性术语",
        f"GJB 7869-2012 军用雷达通用规范",
        "GJB 2924-1997 军用超短波通信设备通用规范",
        "GJB 5309-2004 导弹武器系统通用规范",
        "GJB 792-1990 装甲车辆通用规范",
        "GJB 7866-2012 电子对抗装备通用规范",
    ]
    for s in standards:
        parts.append(f"- {s}")
    parts.append(f"")

    content = "\n".join(parts)

    # Pad content based on size tier
    if tier == "medium":
        # Add extra detail sections to reach 5-15 KB
        extra = _generate_extra_section(topic_name, subtopic, seq, paragraphs=8)
        content = content + "\n\n" + extra
    elif tier == "large":
        # Add multiple extra sections to reach 20-50 KB
        for i in range(3):
            extra = _generate_extra_section(topic_name, subtopic, seq + i * 10, paragraphs=12)
            content = content + "\n\n" + extra

    return content


def _generate_subtopic_detail(topic_name: str, subtopic: str, seq: int) -> list:
    """Generate subtopic-specific technical detail paragraphs."""
    parts = []
    parts.append(f"### 3.1 {subtopic}的基本原理")
    parts.append(f"")
    parts.append(f"{subtopic}是{topic_name}技术中的关键环节。在现代信息化战场条件下，"
                 f"其技术水平和运用能力直接决定了装备体系的整体作战效能。"
                 f"本节从原理层面进行系统阐述。")
    parts.append(f"")

    # Technical specifics based on topic
    topic_technical = {
        "雷达系统": [
            f"雷达{subtopic}的核心指标包括探测距离、分辨率和抗干扰能力。"
            f"在工作频段选择上，需综合考虑目标特性、传播损耗和电磁环境等因素。"
            f"现代雷达系统普遍采用数字波束形成(DBF)技术，实现了灵活的波束调度。",
            f"雷达信号处理流程包括：脉冲压缩、动目标检测(MTD)、恒虚警率(CFAR)检测、"
            f"目标关联与航迹管理。每个环节的参数设置都会影响系统的整体性能。"
            f"脉冲压缩比通常选择在{100 + seq * 10}:{1}以上，以兼顾探测距离和距离分辨率。",
            f"杂波抑制是雷达信号处理的核心难题。地面杂波、海面杂波和气象杂波"
            f"具有不同的统计特性，需要采用自适应处理方法。STAP技术可以有效抑制"
            f"机载雷达中的杂波，改善因子可达{40 + seq}dB以上。",
        ],
        "通信装备": [
            f"通信{subtopic}在现代战场通信体系中占据重要地位。"
            f"数字化通信技术使信息传输速率大幅提升，抗干扰能力显著增强。"
            f"软件无线电(SDR)技术的应用使通信装备具备多频段、多模式工作能力。",
            f"跳频通信是重要的抗干扰手段，跳速达到{300 + seq * 10}跳/秒以上时，"
            f"可有效对抗跟踪式干扰。跳频带宽越宽，抗干扰能力越强。"
            f"自适应跳频还可以感知并避开被干扰的频点。",
            f"军事通信加密采用流密码体制，密钥长度不低于128位。"
            f"密钥分发采用二级密钥管理体制，每日更换工作密钥。"
            f"通信保密设备应通过国家密码管理局的型号认证。",
        ],
        "导弹武器": [
            f"导弹{subtopic}的技术水平决定了导弹的精确打击能力。"
            f"复合制导体制的采用有效提高了抗干扰能力和命中精度。"
            f"制导精度CEP（圆概率误差）是衡量制导系统性能的核心指标。",
            f"固体火箭发动机具有结构简单、反应快速的优点，推力可达{100 + seq * 5}kN。"
            f"推进剂选型需综合考虑比冲、密度比冲和贮存性能。"
            f"HTPB复合推进剂是目前主流选择，理论比冲约250秒。",
            f"导弹战斗部设计需考虑目标特性和毁伤要求。"
            f"破片式战斗部有效杀伤半径与装药量和破片初速有关，"
            f"通常以破片动能{80 + seq * 2}J作为有效杀伤判据。",
        ],
        "装甲车辆": [
            f"装甲车辆的{subtopic}是影响其战场生存力和机动性的关键技术。"
            f"现代装甲车辆在火力、机动、防护三个维度持续改进，"
            f"同时注重信息化程度的提升。",
            f"发动机功率密度是衡量动力系统先进性的重要指标。"
            f"目前主流坦克发动机功率达到1500马力，单位功率{20 + seq}kW/t以上。"
            f"传动系统采用液力机械综合传动，实现无级变速和中心转向。",
            f"复合装甲和反应装甲的组合使用可有效提高防护能力。"
            f"正面防护可抵御{600 + seq * 10}mm穿甲弹的攻击。"
            f"主动防护系统能够在毫秒级时间内探测并拦截来袭弹丸。",
        ],
        "后勤保障": [
            f"后勤{subtopic}是保障部队持续作战能力的基础。"
            f"现代战争对后勤保障提出了精确化、快速化和信息化的要求。"
            f"建立科学高效的{subtopic}体系是后勤建设的重要内容。",
            f"物资储备遵循'前方少储、后方多储、梯次配置'的原则。"
            f"战备物资储备量按照{seq + 1}个基数计算，确保满足{seq * 3 + 7}日作战需要。"
            f"库存周转率不低于{85 + seq}%，避免物资积压和过期浪费。",
            f"运输保障采用公路、铁路、航空和海运相结合的方式。"
            f"优先级分为紧急（{seq * 2}小时内送达）、优先（12小时内）和常规（24小时内）。"
            f"运用物流优化算法规划运输路线，降低运输成本{15 + seq}%。",
        ],
        "电子对抗": [
            f"电子对抗{subtopic}是信息化条件下夺取电磁频谱控制权的关键手段。"
            f"随着电子技术的发展，电子对抗与反对抗的博弈日趋激烈。"
            f"认知电子战概念的提出标志着电子对抗进入智能化时代。",
            f"电子侦察系统的关键指标包括频率覆盖范围、灵敏度和动态范围。"
            f"现代侦察接收机可覆盖0.5-40 GHz频段，灵敏度达到-90 dBm以上。"
            f"高速数字信号处理使脉冲分选速度达到{500 + seq * 10}万脉冲/秒。",
            f"干扰效果评估(EA)采用干信比(JSR)作为主要衡量标准。"
            f"对雷达的有效干扰一般要求JSR > {10 + seq}dB，"
            f"对通信的压制干扰需要JSR > 0dB，欺骗干扰则更注重信号的一致性。",
        ],
    }

    technical = topic_technical.get(topic_name, [])
    for para in technical[:3]:
        parts.append(para)
        parts.append("")

    parts.append(f"### 3.2 {subtopic}的技术参数要求")
    parts.append("")
    parts.append(f"根据相关国军标要求，{subtopic}须满足以下技术参数：")
    parts.append(f"- 工作温度范围：-40°C至+55°C（按GJB 150A-2009执行环境试验）")
    parts.append(f"- 振动：5-500 Hz，加速度谱密度0.04 g²/Hz（按GJB 150.16执行）")
    parts.append(f"- 冲击：半正弦波，30g，11ms（按GJB 150.18执行）")
    parts.append(f"- 湿度：95% RH，+35°C（按GJB 150.9执行）")
    parts.append(f"- 盐雾：5% NaCl溶液，连续喷雾48h（按GJB 150.11执行）")
    parts.append(f"- EMC：满足GJB 151B-2013要求，CE102、RE102等限值")
    parts.append(f"- MTBF：不低于{(seq % 5 + 3) * 100}小时（按GJB 899A-2009验证）")
    parts.append(f"- MTTR：不超过{seq % 3 + 1}小时")
    parts.append("")

    parts.append(f"### 3.3 操作流程")
    parts.append("")
    parts.append(f"1. 开机前检查：确认所有连接正确、供电正常、环境条件满足要求")
    parts.append(f"2. 上电自检：系统自动执行BIT检测，约{15 + seq % 10}秒完成")
    parts.append(f"3. 参数设置：根据任务要求配置工作参数和模式选择")
    parts.append(f"4. 功能验证：执行功能测试，确认各项指标满足要求")
    parts.append(f"5. 正式运行：进入正常工作模式，开始执行任务")
    parts.append(f"6. 数据记录：全程记录关键参数和事件日志")
    parts.append(f"7. 关机流程：完成数据备份，按规程安全关机")
    parts.append("")

    return parts


def _generate_extra_section(topic_name: str, subtopic: str, seed: int, paragraphs: int = 8) -> str:
    """Generate extra paragraphs to reach target size."""
    lines = []
    lines.append(f"## 补充技术资料（{subtopic}专题 #{seed}）")
    lines.append("")

    # Generate varied extra content
    templates = [
        f"在实际作战运用中，{topic_name}领域的{subtopic}需要特别关注以下技术要点。"
        f"首先，装备的可靠性直接影响任务完成率。统计数据显示，经过规范维护的装备，"
        f"任务成功率可达{(85 + seed % 10)}%以上，而缺乏维护的装备成功率仅为{(60 + seed % 15)}%。"
        f"因此，严格执行维护规程是保障装备战备完好率的关键措施。",

        f"根据部队训练和演习的反馈数据，{subtopic}相关装备在高温环境下（环境温度+50°C）"
        f"连续工作{8 + seed % 8}小时后，性能下降不超过5%。在低温环境下（-30°C），"
        f"启动时间延长至正常值的{(seed % 3) + 2}倍，需提前预热{(seed % 5) + 3}分钟。"
        f"这些数据为装备使用提供了重要的参考依据。",

        f"装备技术状态监测是{subtopic}管理的重要手段。通过在线监测系统，"
        f"可实时采集温度、振动、电流等{(seed % 10) + 10}项参数。当参数偏离基准值超过"
        f"{(seed % 5) + 10}%时，系统自动发出预警信号。趋势分析可提前{(seed % 14) + 7}天"
        f"预测潜在故障，为预防性维修提供决策支持。",

        f"备件储备是确保{subtopic}装备持续运行的重要保障。根据故障率统计分析，"
        f"易损件更换周期为：密封件{(seed % 6 + 3)}个月、滤芯{(seed % 3 + 1)}个月、"
        f"继电器{(seed % 12 + 6)}个月。关键备件的储备量应不低于{(seed % 3 + 2)}个月的"
        f"消耗量，紧急采购渠道响应时间不超过{(seed % 48 + 24)}小时。",

        f"从装备全寿命管理角度看，{subtopic}相关的技术资料管理同样重要。"
        f"技术说明书、维修手册和零部件目录须保持最新版本。每次技术改进后，"
        f"应在{(seed % 7 + 3)}个工作日内完成技术资料的更新和分发。"
        f"电子化资料管理系统的推广应用，使资料检索效率提升了{(seed % 30 + 40)}%。",

        f"质量控制方面，{subtopic}的检验分为进货检验、过程检验和最终检验三个环节。"
        f"进货检验按GJB 908A-2012执行，抽样方案采用GB/T 2828.1正常检验一次抽样。"
        f"过程检验实行首件检验制度，关键工序实行100%检验。"
        f"最终检验需完成全部性能测试项目，合格判定数AQL值为{(seed % 3 + 1)}%。",

        f"装备退役处置也需要遵守{subtopic}相关规程。涉密装备的退役须经保密审查，"
        f"关键部件拆卸后须在指定场所销毁。存储介质须经过物理粉碎处理，"
        f"确保无法恢复。退役装备的处置记录须保存不少于{(seed % 5 + 10)}年。"
        f"这些措施确保敏感技术信息不会泄露。",

        f"在联合训练中，{topic_name}领域{subtopic}的协同运用展现了良好的效果。"
        f"多平台信息共享使态势感知时间缩短了{(seed % 30 + 20)}%，"
        f"决策响应速度提高了{(seed % 20 + 15)}%。下一步将重点优化数据融合算法，"
        f"进一步提升系统的智能化水平和自主决策能力。",

        f"装备技术档案管理遵循'一装一档'原则。每台装备建立独立的技术档案，"
        f"记录装备出厂参数、历次检测数据、维修记录和使用情况。"
        f"档案数据为装备状态评估和延寿决策提供了科学依据。"
        f"通过大数据分析技术，可挖掘出装备故障规律{seed}类关键特征。",

        f"国际军事技术交流中，{topic_name}领域{subtopic}的发展趋势备受关注。"
        f"主要军事强国均加大了在该领域的研发投入，年均增长率超过{(seed % 8 + 5)}%。"
        f"智能化、网络化和模块化是未来的主要发展方向。"
        f"我方需持续跟踪前沿技术发展，加快自主创新步伐。",

        f"装备论证阶段的效费比分析是{subtopic}装备采办决策的重要依据。"
        f"全寿命费用(LCC)包括研制费、采购费、使用保障费和退役处置费。"
        f"其中使用保障费约占总费用的{(55 + seed % 15)}%，是费用控制的重点。"
        f"可靠性提升投资回报率通常在{seed}:{(seed + 3)}以上。",

        f"装备试验与评价是验证{subtopic}技术指标的重要手段。"
        f"定型试验包括环境适应性试验、电磁兼容性试验、可靠性试验等{8 + seed % 5}大类。"
        f"部队试用期间需收集不少于{(seed % 6 + 6)}个月的使用数据。"
        f"试验结果的评价采用定量与定性相结合的方法，确保评价的全面性和客观性。",

        f"装备保障信息化建设是提升{subtopic}保障效率的重要途径。"
        f"通过物联网技术实现装备状态的实时感知，采集频率不低于{seed}次/分钟。"
        f"保障信息系统与指挥信息系统的互联互通，使保障决策时间缩短了{(seed % 40 + 30)}%。"
        f"下一步将推广智能仓储和自动分拣技术，进一步提升保障效能。",
    ]

    # Select paragraphs based on seed
    for i in range(paragraphs):
        idx = (seed + i * 7) % len(templates)
        lines.append(templates[idx])
        lines.append("")

    return "\n".join(lines)


# ═══════════════════════════════════════════════════════════════
# File generators per format
# ═══════════════════════════════════════════════════════════════

def _make_file_path(topic_dir: Path, topic_name: str, subtopic: str, seq: int, ext: str) -> Path:
    """Build output path: {topic_dir}/{ext}/{topic}_{subtopic}_{seq:03d}.{ext}"""
    fmt_dir = topic_dir / ext
    fmt_dir.mkdir(parents=True, exist_ok=True)
    return fmt_dir / f"{topic_name}_{subtopic}_{seq:03d}.{ext}"


def gen_pdf(topic_dir: Path, topic_name: str, subtopic: str, seq: int) -> Path:
    content = _generate_rich_content(topic_name, subtopic, seq, "pdf")
    path = _make_file_path(topic_dir, topic_name, subtopic, seq, "pdf")
    return generate_pdf(path, content)


def gen_docx(topic_dir: Path, topic_name: str, subtopic: str, seq: int) -> Path:
    content = _generate_rich_content(topic_name, subtopic, seq, "docx")
    path = _make_file_path(topic_dir, topic_name, subtopic, seq, "docx")
    return generate_docx(path, content)


def gen_xlsx(topic_dir: Path, topic_name: str, subtopic: str, seq: int) -> Path:
    topic_info = TOPICS[topic_name]
    path = _make_file_path(topic_dir, topic_name, subtopic, seq, "xlsx")
    path.parent.mkdir(parents=True, exist_ok=True)

    from openpyxl import Workbook
    wb = Workbook()
    ws = wb.active
    ws.title = f"{subtopic}参数"

    headers = topic_info["xlsx_headers"]
    ws.append(headers)

    # Add base data
    for row in topic_info["xlsx_data"]:
        ws.append(row)

    # Add subtopic-specific data rows
    extra_data = _generate_xlsx_extra_rows(topic_name, subtopic, seq)
    for row in extra_data:
        ws.append(row)

    wb.save(str(path))
    return path


def _generate_xlsx_extra_rows(topic_name: str, subtopic: str, seq: int) -> list:
    """Generate additional XLSX data rows specific to the subtopic."""
    rows = []
    equipment_prefixes = ["XX-1", "XY-2", "XZ-3"]
    param_names_by_topic = {
        "雷达系统": ["工作频段", "探测距离", "分辨率", "扫描速率", "数据率"],
        "通信装备": ["工作频率", "输出功率", "调制方式", "数据速率", "覆盖范围"],
        "导弹武器": ["射程", "战斗部重量", "命中精度", "反应时间", "储存寿命"],
        "装甲车辆": ["战斗全重", "发动机功率", "最大速度", "装甲厚度", "行程"],
        "后勤保障": ["储备数量", "运输距离", "供应周期", "最小库存", "保质期"],
        "电子对抗": ["频段覆盖", "干扰功率", "测向精度", "反应时间", "同时目标数"],
    }
    params = param_names_by_topic.get(topic_name, ["参数1", "参数2", "参数3"])
    for i, param in enumerate(params):
        model = f"{subtopic}-{equipment_prefixes[i % len(equipment_prefixes)]}"
        value = f"{(seq * 10 + i * 7) % 500 + 1}"
        unit = ["MHz", "km", "W", "dB", "m", "kg"][i % 6]
        standard = f"GJB {(7000 + seq * 10 + i)}-2012"
        note = f"{subtopic}测试参数#{i + 1}"
        rows.append([model, param, value, unit, standard, note])
    return rows


def gen_txt(topic_dir: Path, topic_name: str, subtopic: str, seq: int) -> Path:
    content = _generate_rich_content(topic_name, subtopic, seq, "txt")
    path = _make_file_path(topic_dir, topic_name, subtopic, seq, "txt")
    return generate_txt(path, content)


def gen_md(topic_dir: Path, topic_name: str, subtopic: str, seq: int) -> Path:
    content = _generate_rich_content(topic_name, subtopic, seq, "md")
    path = _make_file_path(topic_dir, topic_name, subtopic, seq, "md")
    return generate_txt(path, content)  # MD is plain text with markdown syntax


def gen_json(topic_dir: Path, topic_name: str, subtopic: str, seq: int) -> Path:
    """Generate QA pair JSON file for the topic."""
    topic_info = TOPICS[topic_name]
    path = _make_file_path(topic_dir, topic_name, subtopic, seq, "json")
    path.parent.mkdir(parents=True, exist_ok=True)

    # Use topic QA pairs as base, add subtopic-specific ones
    qa_pairs = list(topic_info["qa_pairs"])

    # Add subtopic-specific QA pairs
    extra_qa = [
        {
            "question": f"{topic_name}领域中{subtopic}的核心技术难点是什么？",
            "answer": f"主要难点包括：精度指标要求高、环境适应性强、抗干扰能力要求严、"
                      f"全寿命周期可靠性保证。需采用先进的材料工艺和设计方法解决。",
            "keywords": [subtopic, "精度", "可靠性", "抗干扰"],
            "subtopic": subtopic,
        },
        {
            "question": f"{subtopic}的日常维护中需要注意哪些事项？",
            "answer": f"日常维护需注意：检查接口密封性、校准测量基准、记录运行参数、"
                      f"清洁关键部件、检查电源系统。维护记录应保存不少于3年。",
            "keywords": ["维护", subtopic, "校准", "密封"],
            "subtopic": subtopic,
        },
    ]
    qa_pairs.extend(extra_qa)

    # Tag all pairs with topic and subtopic
    for pair in qa_pairs:
        pair["topic"] = topic_name
        pair["source_file"] = f"{topic_name}_{subtopic}_{seq:03d}"

    path.write_text(json.dumps(qa_pairs, ensure_ascii=False, indent=2), encoding="utf-8")
    return path


# ═══════════════════════════════════════════════════════════════
# Format dispatch
# ═══════════════════════════════════════════════════════════════

FORMAT_GENERATORS = {
    "pdf": gen_pdf,
    "docx": gen_docx,
    "xlsx": gen_xlsx,
    "txt": gen_txt,
    "md": gen_md,
    "json": gen_json,
}


# ═══════════════════════════════════════════════════════════════
# Main generation logic
# ═══════════════════════════════════════════════════════════════

def generate_all(topics: list = None, count: int = 30, formats: list = None) -> dict:
    """Generate all test files. Returns summary statistics."""
    if topics is None:
        topics = list(TOPICS.keys())
    if formats is None:
        formats = list(FORMAT_GENERATORS.keys())

    # Validate
    invalid_topics = [t for t in topics if t not in TOPICS]
    if invalid_topics:
        print(f"ERROR: Unknown topics: {invalid_topics}")
        print(f"Available topics: {list(TOPICS.keys())}")
        return {}

    invalid_fmts = [f for f in formats if f not in FORMAT_GENERATORS]
    if invalid_fmts:
        print(f"ERROR: Unknown formats: {invalid_fmts}")
        print(f"Available formats: {list(FORMAT_GENERATORS.keys())}")
        return {}

    start_time = time.time()
    stats = {}
    total_files = 0
    total_bytes = 0

    for topic_name in topics:
        topic_info = TOPICS[topic_name]
        topic_dir = OUTPUT_BASE / topic_name
        topic_dir.mkdir(parents=True, exist_ok=True)

        subtopics = topic_info["subtopics"]
        topic_files = 0
        topic_bytes = 0

        print(f"\n[{topic_name}] Generating files...")

        for fmt in formats:
            # Determine count for this format (json gets fewer)
            fmt_count = min(count, 10) if fmt == "json" else count
            generator = FORMAT_GENERATORS[fmt]

            for i in range(fmt_count):
                seq = i + 1
                # Cycle through subtopics
                subtopic = subtopics[i % len(subtopics)]

                try:
                    path = generator(topic_dir, topic_name, subtopic, seq)
                    file_size = path.stat().st_size
                    topic_files += 1
                    topic_bytes += file_size
                    total_files += 1
                    total_bytes += file_size

                    if seq % 10 == 0 or seq == fmt_count:
                        print(f"  {fmt}: {seq}/{fmt_count} done")
                except Exception as e:
                    print(f"  ERROR: {topic_name}/{fmt}/{seq:03d} - {e}")

        stats[topic_name] = {
            "files": topic_files,
            "bytes": topic_bytes,
        }
        print(f"  -> {topic_files} files, {topic_bytes / 1024:.1f} KB")

    elapsed = time.time() - start_time

    # Print summary table
    print("\n" + "=" * 72)
    print(f"{'KNOWLEDGE BASE TEST DATA GENERATION SUMMARY':^72}")
    print("=" * 72)
    print(f"{'Topic':<12} {'English':<24} {'Files':>8} {'Size (KB)':>12}")
    print("-" * 72)
    for topic_name, s in stats.items():
        en = TOPICS[topic_name]["english"]
        print(f"{topic_name:<12} {en:<24} {s['files']:>8} {s['bytes']/1024:>12.1f}")
    print("-" * 72)
    print(f"{'TOTAL':<36} {total_files:>8} {total_bytes/1024:>12.1f}")
    print(f"\nElapsed: {elapsed:.1f}s")
    print(f"Output: {OUTPUT_BASE}")
    print("=" * 72)

    return {
        "total_files": total_files,
        "total_bytes": total_bytes,
        "elapsed": elapsed,
        "topics": stats,
    }


# ═══════════════════════════════════════════════════════════════
# CLI
# ═══════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(
        description="Generate topic-organized knowledge base test data for RAG testing"
    )
    parser.add_argument(
        "--topics", nargs="+", default=list(TOPICS.keys()),
        help=f"Topics to generate (default: all 6). Choices: {list(TOPICS.keys())}"
    )
    parser.add_argument(
        "--count", type=int, default=30,
        help="Number of files per format per topic (default: 30, json always max 10)"
    )
    parser.add_argument(
        "--formats", default="pdf,docx,xlsx,txt,md,json",
        help="Comma-separated formats (default: pdf,docx,xlsx,txt,md,json)"
    )
    args = parser.parse_args()

    formats = [f.strip() for f in args.formats.split(",")]
    result = generate_all(topics=args.topics, count=args.count, formats=formats)

    if result.get("total_files", 0) == 0:
        sys.exit(1)


if __name__ == "__main__":
    main()
