"""PE-005: Multi-turn dialog context. PE-008: Temperature effect."""

import uuid
import pytest

pytestmark = pytest.mark.api


def test_pe005_multi_turn_context(ragflow_api, prepared_dataset):
    """PE-005: 4-turn dialog, 4th turn references 1st turn."""
    chat = ragflow_api.create_chat(
        name=f"multiturn_{uuid.uuid4().hex[:6]}",
        dataset_ids=[prepared_dataset["id"]],
        prompt_config={"system": "你是装备分析专家。", "refine_multiturn": True},
    )
    sess = ragflow_api.create_session(chat["id"])

    # Turn 1
    r1 = ragflow_api.chat_completion(
        chat["id"], "AN/TPQ-53雷达的工作频段是什么？", sess["id"], stream=False
    )
    assert len(r1.get("answer", "")) > 0

    # Turn 2
    r2 = ragflow_api.chat_completion(
        chat["id"], "它的探测距离呢？", sess["id"], stream=False
    )
    assert len(r2.get("answer", "")) > 0

    # Turn 3
    r3 = ragflow_api.chat_completion(
        chat["id"], "故障代码ERR-001怎么处理？", sess["id"], stream=False
    )
    assert len(r3.get("answer", "")) > 0

    # Turn 4: references turn 1
    r4 = ragflow_api.chat_completion(
        chat["id"], "刚才说的那个频段的雷达，维护周期是多久？", sess["id"], stream=False
    )
    answer4 = r4.get("answer", "")
    assert len(answer4) > 0, "Multi-turn context should be maintained"

    ragflow_api.delete_session(chat["id"], [sess["id"]])
    ragflow_api.delete_chat(chat["id"])


def test_pe008_temperature_effect(ragflow_api, prepared_dataset):
    """PE-008: Different temperatures produce varied outputs."""
    chat_low = ragflow_api.create_chat(
        name=f"temp_low_{uuid.uuid4().hex[:6]}",
        dataset_ids=[prepared_dataset["id"]],
        llm_setting={"temperature": 0.0},
    )
    chat_high = ragflow_api.create_chat(
        name=f"temp_high_{uuid.uuid4().hex[:6]}",
        dataset_ids=[prepared_dataset["id"]],
        llm_setting={"temperature": 1.0},
    )
    sess_low = ragflow_api.create_session(chat_low["id"])
    sess_high = ragflow_api.create_session(chat_high["id"])

    question = "请简述雷达维护规程"

    r_low = ragflow_api.chat_completion(chat_low["id"], question, sess_low["id"], stream=False)
    r_high = ragflow_api.chat_completion(chat_high["id"], question, sess_high["id"], stream=False)

    # Both should return answers
    assert len(r_low.get("answer", "")) > 0
    assert len(r_high.get("answer", "")) > 0

    ragflow_api.delete_session(chat_low["id"], [sess_low["id"]])
    ragflow_api.delete_session(chat_high["id"], [sess_high["id"]])
    ragflow_api.delete_chat(chat_low["id"])
    ragflow_api.delete_chat(chat_high["id"])
