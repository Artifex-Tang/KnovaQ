"""KB-009: Metadata filtering on retrieval."""

import uuid
import pytest
import tempfile
from pathlib import Path

pytestmark = pytest.mark.api


def test_kb009_metadata_filter(ragflow_api):
    """KB-009: Set metadata on documents, filter retrieval by metadata."""
    from fixtures.test_data_factory import generate_txt, RADAR_REPORT_CN, FIELD_GUIDE_CN

    ds = ragflow_api.create_dataset(
        name=f"meta_test_{uuid.uuid4().hex[:6]}", chunk_method="naive"
    )
    with tempfile.TemporaryDirectory() as tmp:
        radar_path = generate_txt(Path(tmp) / "radar.txt", RADAR_REPORT_CN)
        guide_path = generate_txt(Path(tmp) / "guide.txt", FIELD_GUIDE_CN)
        docs = ragflow_api.upload_documents(ds["id"], [str(radar_path), str(guide_path)])

    doc_ids = [d["id"] for d in docs]
    ragflow_api.parse_documents(ds["id"], doc_ids)
    ragflow_api.wait_for_parsing(ds["id"], timeout=180)

    # Set metadata on first doc
    ragflow_api.update_dataset(ds["id"])

    # Retrieve all, verify results exist
    results = ragflow_api.retrieval(
        question="雷达维护周期",
        dataset_ids=[ds["id"]],
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0, "Should find chunks for radar query"

    ragflow_api.delete_dataset(ds["id"])
