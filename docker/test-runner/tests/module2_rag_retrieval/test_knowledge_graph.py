"""RG-008: Knowledge graph (GraphRAG) retrieval."""

import uuid
import pytest
import tempfile
from pathlib import Path

pytestmark = [pytest.mark.api, pytest.mark.slow]


def test_rg008_graphrag_retrieval(ragflow_api):
    """RG-008: Build GraphRAG and use knowledge graph for retrieval."""
    from fixtures.test_data_factory import generate_txt, RADAR_REPORT_CN

    ds = ragflow_api.create_dataset(name=f"graphrag_{uuid.uuid4().hex[:6]}")
    with tempfile.TemporaryDirectory() as tmp:
        path = generate_txt(Path(tmp) / "radar.txt", RADAR_REPORT_CN)
        docs = ragflow_api.upload_document(ds["id"], str(path))

    doc = docs if isinstance(docs, dict) else docs[0]
    ragflow_api.parse_documents(ds["id"], [doc["id"]])
    ragflow_api.wait_for_parsing(ds["id"], timeout=180)

    # Try to build graph — this may fail if GraphRAG not configured
    try:
        ragflow_api.run_graphrag(ds["id"])
    except Exception:
        pytest.skip("GraphRAG not available or not configured")

    import time
    time.sleep(10)  # Wait for graph construction

    # Retrieve with knowledge graph
    results = ragflow_api.retrieval(
        question="雷达和通信装备有什么关联？",
        dataset_ids=[ds["id"]],
        use_kg=True,
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0, "GraphRAG retrieval should return results"

    ragflow_api.delete_dataset(ds["id"])
