"""RG-002: Hybrid retrieval. RG-006: top_k parameter. RG-007: Multi-dataset."""

import uuid
import pytest
import tempfile
from pathlib import Path

pytestmark = pytest.mark.api


def test_rg002_hybrid_search(ragflow_api, prepared_dataset):
    """RG-002: Hybrid search with vector + keyword."""
    results = ragflow_api.retrieval(
        question="雷达ERR-001故障",
        dataset_ids=[prepared_dataset["id"]],
        vector_similarity_weight=0.5,
        keyword=True,
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0, "Hybrid search should return results"


def test_rg006_top_k_parameter(ragflow_api, prepared_dataset):
    """RG-006: Different top_k values affect result count."""
    r10 = ragflow_api.retrieval(
        question="装备维护", dataset_ids=[prepared_dataset["id"]], top_k=10,
    )
    r50 = ragflow_api.retrieval(
        question="装备维护", dataset_ids=[prepared_dataset["id"]], top_k=50,
    )
    c10 = r10.get("chunks", [])
    c50 = r50.get("chunks", [])
    assert len(c50) >= len(c10), "top_k=50 should return >= top_k=10 chunks"


def test_rg007_multi_dataset_retrieval(ragflow_api):
    """RG-007: Retrieve across multiple datasets."""
    from fixtures.test_data_factory import generate_txt, RADAR_REPORT_CN, FIELD_GUIDE_CN

    ds1 = ragflow_api.create_dataset(name=f"multi1_{uuid.uuid4().hex[:6]}")
    ds2 = ragflow_api.create_dataset(name=f"multi2_{uuid.uuid4().hex[:6]}")

    with tempfile.TemporaryDirectory() as tmp:
        p1 = generate_txt(Path(tmp) / "radar.txt", RADAR_REPORT_CN)
        p2 = generate_txt(Path(tmp) / "guide.txt", FIELD_GUIDE_CN)
        d1 = ragflow_api.upload_document(ds1["id"], str(p1))
        d2 = ragflow_api.upload_document(ds2["id"], str(p2))

    ragflow_api.parse_documents(ds1["id"], [d1["id"]])
    ragflow_api.parse_documents(ds2["id"], [d2["id"]])
    ragflow_api.wait_for_parsing(ds1["id"], timeout=120)
    ragflow_api.wait_for_parsing(ds2["id"], timeout=120)

    results = ragflow_api.retrieval(
        question="装备维护周期",
        dataset_ids=[ds1["id"], ds2["id"]],
    )
    chunks = results.get("chunks", [])
    ds_ids = set(c.get("dataset_id", "") for c in chunks)
    assert len(chunks) > 0, "Should find results across datasets"

    ragflow_api.delete_dataset(ds1["id"])
    ragflow_api.delete_dataset(ds2["id"])
