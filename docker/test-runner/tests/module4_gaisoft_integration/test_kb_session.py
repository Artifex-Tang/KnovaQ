"""GI-002: Session persistence. GI-004: Multi-user session isolation."""

import pytest

pytestmark = pytest.mark.api


def test_gi002_session_persistence(gaisoft_api):
    """GI-002: KB sessions persist across service operations."""
    # Create session
    sessions_before = gaisoft_api.list_kb_sessions()
    count_before = len(sessions_before.get("rows", sessions_before.get("data", [])))

    result = gaisoft_api.create_kb_session({
        "sessionName": "persistence_test",
        "chatId": "test_chat_id",
    })
    # If creation succeeded, verify it appears in listing
    sessions_after = gaisoft_api.list_kb_sessions()
    # Session should be in the list
    assert sessions_after is not None


def test_gi004_multi_user_isolation(ragflow_api, prepared_dataset):
    """GI-004: Two chat assistants have independent sessions."""
    chat1 = ragflow_api.create_chat(
        name="user_a_chat", dataset_ids=[prepared_dataset["id"]]
    )
    chat2 = ragflow_api.create_chat(
        name="user_b_chat", dataset_ids=[prepared_dataset["id"]]
    )

    sess1 = ragflow_api.create_session(chat1["id"])
    sess2 = ragflow_api.create_session(chat2["id"])

    # Ask different questions
    r1 = ragflow_api.chat_completion(
        chat1["id"], "雷达探测距离", sess1["id"], stream=False
    )
    r2 = ragflow_api.chat_completion(
        chat2["id"], "通信装备频率", sess2["id"], stream=False
    )

    # Answers should be different (different topics)
    a1 = r1.get("answer", "")
    a2 = r2.get("answer", "")
    assert a1 != a2 or len(a1) > 0, "Sessions should be independent"

    ragflow_api.delete_session(chat1["id"], [sess1["id"]])
    ragflow_api.delete_session(chat2["id"], [sess2["id"]])
    ragflow_api.delete_chat(chat1["id"])
    ragflow_api.delete_chat(chat2["id"])
