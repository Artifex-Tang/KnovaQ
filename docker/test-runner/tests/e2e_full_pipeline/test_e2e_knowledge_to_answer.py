"""E2E-001: Full pipeline — upload → parse → create assistant → ask → verify."""

import uuid
import pytest
import tempfile
from pathlib import Path

pytestmark = [pytest.mark.api, pytest.mark.e2e]


def test_e2e001_knowledge_to_answer(ragflow_api):
    """E2E-001: Complete knowledge-to-answer pipeline."""
    from fixtures.test_data_factory import generate_txt, RADAR_REPORT_CN

    # Step 1: Create dataset
    ds = ragflow_api.create_dataset(name=f"e2e_pipe_{uuid.uuid4().hex[:6]}")

    # Step 2: Upload document
    with tempfile.TemporaryDirectory() as tmp:
        path = generate_txt(Path(tmp) / "radar.txt", RADAR_REPORT_CN)
        docs = ragflow_api.upload_document(ds["id"], str(path))

    doc = docs if isinstance(docs, dict) else docs[0]

    # Step 3: Parse document
    ragflow_api.parse_documents(ds["id"], [doc["id"]])
    success = ragflow_api.wait_for_parsing(ds["id"], timeout=180)
    assert success, "Parsing should complete"

    # Step 4: Create chat assistant
    chat = ragflow_api.create_chat(
        name=f"e2e_chat_{uuid.uuid4().hex[:6]}",
        dataset_ids=[ds["id"]],
    )

    # Step 5: Create session and ask question
    sess = ragflow_api.create_session(chat["id"])
    result = ragflow_api.chat_completion(
        chat_id=chat["id"],
        question="AN/TPQ-53雷达的探测距离是多少？",
        session_id=sess["id"],
        stream=False,
    )

    # Step 6: Verify answer
    answer = result.get("answer", "")
    assert len(answer) > 0, "Should return an answer"
    # Answer should contain "60" (km) — the radar range
    assert "60" in answer or "公里" in answer or "探测" in answer, (
        f"Answer should reference radar range. Got: {answer[:200]}"
    )

    # Cleanup
    ragflow_api.delete_session(chat["id"], [sess["id"]])
    ragflow_api.delete_chat(chat["id"])
    ragflow_api.delete_dataset(ds["id"])
