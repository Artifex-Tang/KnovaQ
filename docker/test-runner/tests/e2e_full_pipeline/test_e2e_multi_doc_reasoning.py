"""E2E-002: Cross-document reasoning — answer requires info from multiple docs."""

import uuid
import pytest
import tempfile
from pathlib import Path

pytestmark = [pytest.mark.api, pytest.mark.e2e]


def test_e2e002_multi_doc_reasoning(ragflow_api):
    """E2E-002: Ask question requiring info from radar + communication + policy docs."""
    from fixtures.test_data_factory import (
        generate_txt, generate_docx, generate_xlsx,
        RADAR_REPORT_CN, EQUIPMENT_MANUAL_CN,
    )

    ds = ragflow_api.create_dataset(name=f"e2e_multi_{uuid.uuid4().hex[:6]}")

    with tempfile.TemporaryDirectory() as tmp:
        radar = generate_txt(Path(tmp) / "radar.txt", RADAR_REPORT_CN)
        comms = generate_docx(Path(tmp) / "comms.docx", EQUIPMENT_MANUAL_CN)
        spec = generate_xlsx(Path(tmp) / "spec.xlsx")
        docs = ragflow_api.upload_documents(
            ds["id"], [str(radar), str(comms), str(spec)]
        )

    ragflow_api.parse_documents(ds["id"], [d["id"] for d in docs])
    success = ragflow_api.wait_for_parsing(ds["id"], timeout=180)
    assert success

    chat = ragflow_api.create_chat(
        name=f"e2e_multi_chat_{uuid.uuid4().hex[:6]}",
        dataset_ids=[ds["id"]],
    )
    sess = ragflow_api.create_session(chat["id"])

    result = ragflow_api.chat_completion(
        chat_id=chat["id"],
        question="请对比AN/TPQ-53雷达和ZBD-2000通信系统的维护要求",
        session_id=sess["id"],
        stream=False,
    )
    answer = result.get("answer", "")
    assert len(answer) > 30, "Cross-doc answer should be substantive"

    ragflow_api.delete_session(chat["id"], [sess["id"]])
    ragflow_api.delete_chat(chat["id"])
    ragflow_api.delete_dataset(ds["id"])
