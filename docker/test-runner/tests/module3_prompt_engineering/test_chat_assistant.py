"""PE-001: Create chat assistant. PE-003: Single turn Q&A. PE-010: Session management."""

import uuid
import pytest

pytestmark = pytest.mark.api


def test_pe001_create_chat_assistant(ragflow_api, prepared_dataset):
    """PE-001: Create chat assistant with dataset binding and system prompt."""
    chat = ragflow_api.create_chat(
        name=f"test_chat_{uuid.uuid4().hex[:6]}",
        dataset_ids=[prepared_dataset["id"]],
        prompt_config={
            "system": "你是DARPA装备分析专家，仅基于知识库内容回答。",
            "empty_response": "知识库中无相关信息。",
        },
    )
    assert chat["id"], "Chat assistant should have an ID"
    assert chat["name"].startswith("test_chat_")
    ragflow_api.delete_chat(chat["id"])


def test_pe003_single_turn_qa(ragflow_api, test_chat_assistant, test_session):
    """PE-003: Single turn question returns answer with references."""
    result = ragflow_api.chat_completion(
        chat_id=test_chat_assistant["id"],
        question="AN/TPQ-53雷达的探测距离是多少？",
        session_id=test_session["id"],
        stream=False,
    )
    answer = result.get("answer", "")
    assert len(answer) > 0, "Should return a non-empty answer"
    reference = result.get("reference", {})
    assert reference, "Should include reference information"


def test_pe010_session_management(ragflow_api, test_chat_assistant):
    """PE-010: Create, list, delete sessions — CRUD complete."""
    # Create
    sess = ragflow_api.create_session(test_chat_assistant["id"])
    assert sess["id"], "Session should have an ID"

    # List
    sessions = ragflow_api.list_sessions(test_chat_assistant["id"])
    assert isinstance(sessions, list)

    # Delete
    ragflow_api.delete_session(test_chat_assistant["id"], [sess["id"]])
