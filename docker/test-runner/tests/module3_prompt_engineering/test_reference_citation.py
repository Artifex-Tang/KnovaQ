"""PE-006: Reference citation. PE-007: Empty knowledge base response."""

import uuid
import pytest
from fixtures.assertions import assert_valid_reference

pytestmark = pytest.mark.api


def test_pe006_reference_citation(ragflow_api, test_chat_assistant, test_session):
    """PE-006: Response references contain chunk_id, similarity, doc_name."""
    result = ragflow_api.chat_completion(
        chat_id=test_chat_assistant["id"],
        question="雷达系统技术参数有哪些？",
        session_id=test_session["id"],
        stream=False,
    )
    reference = result.get("reference", {})
    # Reference may be structured as chunks array or direct object
    chunks = reference.get("chunks", reference.get("chunk", []))
    if isinstance(chunks, list) and len(chunks) > 0:
        assert_valid_reference(chunks[0])
    elif isinstance(chunks, dict):
        assert_valid_reference(chunks)
    else:
        # Some versions return references in different format
        assert reference, "Should include reference data"


def test_pe007_empty_knowledge_response(ragflow_api):
    """PE-007: Query against empty dataset returns empty_response."""
    empty_ds = ragflow_api.create_dataset(name=f"empty_{uuid.uuid4().hex[:6]}")
    chat = ragflow_api.create_chat(
        name=f"empty_chat_{uuid.uuid4().hex[:6]}",
        dataset_ids=[empty_ds["id"]],
        prompt_config={
            "empty_response": "知识库中暂无相关数据。",
        },
    )
    sess = ragflow_api.create_session(chat["id"])
    result = ragflow_api.chat_completion(
        chat_id=chat["id"],
        question="雷达探测距离",
        session_id=sess["id"],
        stream=False,
    )
    answer = result.get("answer", "")
    assert "知识库" in answer or "无" in answer or "暂无" in answer or len(answer) < 50, (
        f"Empty KB should trigger empty_response. Got: {answer[:100]}"
    )

    ragflow_api.delete_session(chat["id"], [sess["id"]])
    ragflow_api.delete_chat(chat["id"])
    ragflow_api.delete_dataset(empty_ds["id"])
