"""E2E-004: Data isolation — datasets are scoped to their creator."""

import uuid
import pytest

pytestmark = [pytest.mark.api, pytest.mark.e2e]


def test_e2e004_data_isolation(ragflow_api):
    """E2E-004: Dataset A's documents are not visible through unscoped listing of B."""
    # Create two datasets
    ds_a = ragflow_api.create_dataset(name=f"secure_a_{uuid.uuid4().hex[:6]}")
    ds_b = ragflow_api.create_dataset(name=f"secure_b_{uuid.uuid4().hex[:6]}")

    # Upload to A only
    from fixtures.test_data_factory import generate_txt, RADAR_REPORT_CN
    import tempfile
    from pathlib import Path

    with tempfile.TemporaryDirectory() as tmp:
        path = generate_txt(Path(tmp) / "radar.txt", RADAR_REPORT_CN)
        docs_a = ragflow_api.upload_document(ds_a["id"], str(path))

    # List docs in B — should be empty
    docs_b_list = ragflow_api.list_documents(ds_b["id"])
    b_docs = docs_b_list.get("docs", docs_b_list) if isinstance(docs_b_list, dict) else docs_b_list
    b_count = len(b_docs) if isinstance(b_docs, list) else 0
    assert b_count == 0, "Dataset B should have no documents from A"

    # List docs in A — should have the doc
    docs_a_list = ragflow_api.list_documents(ds_a["id"])
    a_docs = docs_a_list.get("docs", docs_a_list) if isinstance(docs_a_list, dict) else docs_a_list
    a_count = len(a_docs) if isinstance(a_docs, list) else 0
    assert a_count > 0, "Dataset A should have uploaded document"

    ragflow_api.delete_dataset(ds_a["id"])
    ragflow_api.delete_dataset(ds_b["id"])
