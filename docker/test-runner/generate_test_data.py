#!/usr/bin/env python3
"""Generate test documents and query data for KnovaQ test suites."""
import os
import json
from pathlib import Path

BASE = Path(__file__).parent / "test_data"
DOCS = BASE / "test_documents"
ISSUE = BASE / "issue_test_data"

def generate_chinese_txt():
    (DOCS / "chinese_military.txt").write_text(
        "装备维修技术手册\n\n"
        "第一章 TN800通信设备概述\n\n"
        "TN800型战术通信设备是我国自主研发的新一代军用通信装备，"
        "采用软件无线电架构，支持VHF/UHF双频段通信。"
        "该设备具备抗干扰能力强、通信距离远、保密性好等特点。\n\n"
        "主要技术参数：\n"
        "- 工作频率：30MHz-512MHz\n"
        "- 发射功率：5W/25W可调\n"
        "- 通信距离：视距内不少于30km\n"
        "- 工作温度：-40℃~+55℃\n"
        "- 重量：不大于2.5kg（含电池）\n\n"
        "第二章 操作维护规程\n\n"
        "2.1 日常维护\n"
        "每日使用前应检查天线连接是否牢固，电池电量是否充足。"
        "使用完毕后应清洁设备表面，检查各接口是否有腐蚀现象。\n\n"
        "2.2 故障排除\n"
        "常见故障代码：\n"
        "- E01：天线开路，检查天线连接\n"
        "- E02：频率锁定失败，重启设备\n"
        "- E03：电池电压过低，更换电池\n"
        "- E04：温度过高，降低发射功率\n"
    , encoding="utf-8")

def generate_english_txt():
    (DOCS / "english_technical.txt").write_text(
        "Technical Specification: Radar System RS-200\n\n"
        "The RS-200 radar system is a phased array radar designed for air defense "
        "surveillance and target tracking. It operates in the X-band frequency range "
        "and provides 360-degree coverage with a detection range of up to 400km.\n\n"
        "Key specifications:\n"
        "- Operating frequency: 8-12 GHz (X-band)\n"
        "- Detection range: 400km (fighter-size target)\n"
        "- Tracking capacity: up to 100 simultaneous targets\n"
        "- Scan rate: 6 RPM\n"
        "- Resolution: 30m range, 0.5 degree azimuth\n\n"
        "Maintenance Schedule:\n"
        "Monthly checks include antenna alignment verification, transmitter power "
        "output measurement, and receiver sensitivity testing. Annual overhaul "
        "requires complete system calibration and component replacement as needed.\n"
    , encoding="utf-8")

def generate_md():
    (DOCS / "faq_knowledge.md").write_text(
        "# 常见问题知识库\n\n"
        "## 通信设备\n\n"
        "### Q: TN800如何进行频率设置？\n"
        "A: 进入菜单→频率设置→选择预设频道或手动输入频率。"
        "手动输入时，确保频率在30MHz-512MHz范围内。按确认键保存。\n\n"
        "### Q: TN800出现E01错误代码怎么办？\n"
        "A: E01表示天线开路。请检查：1）天线是否正确安装；"
        "2）天线接口是否有损坏；3）天线电缆是否断裂。"
        "排除故障后重启设备即可。\n\n"
        "## 雷达系统\n\n"
        "### Q: RS-200雷达的最大探测距离是多少？\n"
        "A: 对战斗机类目标的最大探测距离为400km。"
        "实际探测距离受目标RCS、天气条件和电磁环境影响。\n\n"
        "### Q: 雷达日常维护包括哪些内容？\n"
        "A: 包括天线对准检查、发射功率测量、接收灵敏度测试。"
        "每月执行一次常规检查，每年进行一次全面校准。\n"
    , encoding="utf-8")

def generate_test_queries():
    queries = {
        "basic_queries": [
            {"id": "Q001", "query": "TN800通信设备的主要技术参数有哪些？", "expected_keywords": ["30MHz", "512MHz", "2.5kg"]},
            {"id": "Q002", "query": "E01错误代码怎么处理？", "expected_keywords": ["天线", "开路", "检查"]},
            {"id": "Q003", "query": "RS-200雷达的探测距离是多少？", "expected_keywords": ["400km"]},
            {"id": "Q004", "query": "雷达日常维护包括哪些？", "expected_keywords": ["天线", "功率", "灵敏度"]},
        ],
        "cross_language_queries": [
            {"id": "CL001", "query": "雷达系统的探测范围", "expected_keywords": ["400km", "detection range"], "doc_language": "en"},
            {"id": "CL002", "query": "What is the operating frequency of TN800?", "expected_keywords": ["30MHz", "512MHz"], "doc_language": "zh"},
        ],
        "domain_constraint_queries": [
            {"id": "DC001", "query": "如何制作红烧肉？", "expected": "should_reject_or_decline"},
            {"id": "DC002", "query": "推荐一部好看的电影", "expected": "should_reject_or_decline"},
            {"id": "DC003", "query": "TN800的操作维护步骤", "expected": "should_answer"},
        ],
        "multi_turn_queries": [
            {"turn": 1, "id": "MT001-1", "query": "TN800设备的工作频率范围是多少？", "context_key": "TN800频率"},
            {"turn": 2, "id": "MT001-2", "query": "它的最大通信距离是多少？", "context_key": "TN800距离"},
            {"turn": 3, "id": "MT001-3", "query": "工作温度范围呢？", "context_key": "TN800温度"},
            {"turn": 4, "id": "MT001-4", "query": "结合前面提到的频率和通信距离，总结一下这个设备的优缺点", "context_key": "综合"},
        ],
        "sse_queries": [
            {"id": "SSE001", "query": "请详细介绍TN800的故障排除方法"},
            {"id": "SSE002", "query": "RS-200雷达系统的维护计划是什么？"},
        ]
    }
    (BASE / "test_queries.json").write_text(json.dumps(queries, ensure_ascii=False, indent=2), encoding="utf-8")

def generate_issue_test_data():
    """Generate specific test data for issue verification."""
    # ISS-001: paper format test
    (ISSUE / "academic_paper.txt").write_text(
        "基于深度学习的目标检测算法研究\n\n"
        "摘要：本文提出了一种基于改进YOLOv8的目标检测算法，"
        "用于战场环境下的车辆识别。实验结果表明，"
        "该方法在自建军事车辆数据集上的mAP达到了94.3%。\n\n"
        "关键词：深度学习；目标检测；YOLOv8；战场识别\n\n"
        "1. 引言\n"
        "战场环境下的目标识别是军事智能化的重要研究方向。"
        "传统方法依赖人工特征提取，泛化能力差。"
        "近年来，深度学习方法在目标检测领域取得了显著进展。\n\n"
        "2. 相关工作\n"
        "YOLO系列算法因其优异的速度-精度平衡被广泛应用。"
        "YOLOv8引入了anchor-free检测头，进一步提升了检测精度。\n\n"
        "3. 方法\n"
        "3.1 网络结构\n"
        "本文在YOLOv8基础上引入了注意力机制模块CBAM，"
        "增强了模型对小目标和远距离目标的检测能力。\n\n"
        "3.2 数据增强\n"
        "采用Mosaic、MixUp和随机裁剪等数据增强策略，"
        "模拟不同天气和光照条件。\n\n"
        "4. 实验\n"
        "4.1 数据集\n"
        "自建军事车辆数据集，包含5000张训练图像和1000张测试图像，"
        "涵盖坦克、装甲车、军用卡车等6个类别。\n\n"
        "4.2 结果\n"
        "改进后的模型在测试集上达到94.3% mAP，"
        "相比基线YOLOv8提升了3.1个百分点。\n"
    , encoding="utf-8")

    # ISS-002: cross-language test
    (ISSUE / "bilingual_doc.txt").write_text(
        "Communication Equipment Specification / 通信设备规格说明书\n\n"
        "This document describes the specifications for the TN800 tactical radio.\n"
        "本文档描述TN800战术通信设备的技术规格。\n\n"
        "Frequency Range / 频率范围: 30-512 MHz\n"
        "Transmit Power / 发射功率: 5W/25W selectable / 可调\n"
        "Operating Temperature / 工作温度: -40°C to +55°C\n"
        "Weight / 重量: ≤2.5kg (including battery / 含电池)\n"
    , encoding="utf-8")

    # ISS-003: domain constraint system prompt
    (ISSUE / "domain_prompt.txt").write_text(
        "你是一个专业的军事装备技术问答助手。你只能回答与军事装备、军事技术、"
        "国防科技相关的问题。对于任何与军事无关的问题（如烹饪、娱乐、日常生活等），"
        "你必须明确拒绝回答，并告知用户你只能回答军事技术相关问题。"
    , encoding="utf-8")

    issue_queries = {
        "ISS-001_paper_parsing": {
            "doc_file": "academic_paper.txt",
            "query": "改进后的YOLOv8模型的mAP是多少？",
            "expected_keywords": ["94.3"]
        },
        "ISS-002_cross_language": {
            "doc_file": "bilingual_doc.txt",
            "chinese_query": "TN800设备的发射功率是多少？",
            "english_query": "What is the weight of TN800?",
            "expected_keywords_power": ["5W", "25W"],
            "expected_keywords_weight": ["2.5kg"]
        },
        "ISS-003_domain_constraint": {
            "system_prompt_file": "domain_prompt.txt",
            "in_domain_query": "TN800的工作频率范围是多少？",
            "out_of_domain_queries": ["如何制作红烧肉？", "推荐一部好电影", "今天天气怎么样？"],
            "expected": "in_domain answered, out_of_domain rejected"
        },
        "ISS-004_sse_streaming": {
            "queries": ["请详细介绍TN800通信设备的维护规程"],
            "expected": "SSE format with data: prefix, ending with data:[DONE]"
        },
        "ISS-005_multi_turn": {
            "turns": [
                "TN800的工作频率范围是多少？",
                "它的最大发射功率是多少？",
                "工作温度范围呢？",
                "请结合前面提到的频率、功率和温度，总结这个设备的适用场景"
            ],
            "expected": "4th turn references info from turn 1-3"
        }
    }
    (ISSUE / "issue_queries.json").write_text(json.dumps(issue_queries, ensure_ascii=False, indent=2), encoding="utf-8")

def main():
    DOCS.mkdir(parents=True, exist_ok=True)
    ISSUE.mkdir(parents=True, exist_ok=True)
    generate_chinese_txt()
    generate_english_txt()
    generate_md()
    generate_test_queries()
    generate_issue_test_data()
    print(f"Test data generated in {BASE}")
    for f in sorted(BASE.rglob("*")):
        if f.is_file():
            print(f"  {f.relative_to(BASE)} ({f.stat().st_size} bytes)")

if __name__ == "__main__":
    main()
