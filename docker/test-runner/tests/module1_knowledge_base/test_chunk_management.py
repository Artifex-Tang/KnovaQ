"""KB-007: Chunk CRUD operations."""

import uuid
import pytest

pytestmark = pytest.mark.api


@pytest.fixture(scope="module")
def chunk_dataset(ragflow_api):
    """Create dataset, upload doc, parse, ready for chunk tests."""
    from fixtures.test_data_factory import generate_txt, FIELD_GUIDE_CN
    import tempfile
    from pathlib import Path

    ds = ragflow_api.create_dataset(
        name=f"chunk_test_{uuid.uuid4().hex[:6]}", chunk_method="naive"
    )
    with tempfile.TemporaryDirectory() as tmp:
        path = generate_txt(Path(tmp) / "guide.txt", FIELD_GUIDE_CN)
        docs = ragflow_api.upload_document(ds["id"], str(path))
    doc = docs if isinstance(docs, dict) else docs[0]
    ragflow_api.parse_documents(ds["id"], [doc["id"]])
    ragflow_api.wait_for_parsing(ds["id"], timeout=120)
    yield ds, doc
    ragflow_api.delete_dataset(ds["id"])


def test_kb007_add_chunk(ragflow_api, chunk_dataset):
    """KB-007: Add a new chunk manually."""
    ds, doc = chunk_dataset
    chunk = ragflow_api.add_chunk(
        ds["id"], doc["id"],
        content="手动添加的测试分块：装备编号EQ-9999",
        important_keywords=["装备", "测试"],
    )
    assert "chunk" in chunk or "id" in chunk, f"Chunk creation failed: {chunk}"


def test_kb007_list_chunks(ragflow_api, chunk_dataset):
    """KB-007: List chunks in a document."""
    ds, doc = chunk_dataset
    data = ragflow_api.list_chunks(ds["id"], doc["id"])
    chunks = data.get("chunks", data.get("data", {}).get("chunks", []))
    assert len(chunks) > 0, "Parsed document should have chunks"


def test_kb007_update_chunk(ragflow_api, chunk_dataset):
    """KB-007: Update chunk content."""
    ds, doc = chunk_dataset
    # Add a chunk first
    chunk_data = ragflow_api.add_chunk(
        ds["id"], doc["id"], content="原始内容待更新"
    )
    chunk = chunk_data.get("chunk", chunk_data)
    chunk_id = chunk["id"]

    updated = ragflow_api.update_chunk(
        ds["id"], doc["id"], chunk_id,
        content="更新后的内容：装备维护规程v2.0",
    )
    assert updated is not None


def test_kb007_delete_chunk(ragflow_api, chunk_dataset):
    """KB-007: Delete a chunk."""
    ds, doc = chunk_dataset
    chunk_data = ragflow_api.add_chunk(
        ds["id"], doc["id"], content="待删除的测试分块"
    )
    chunk = chunk_data.get("chunk", chunk_data)
    chunk_id = chunk["id"]

    result = ragflow_api.delete_chunks(ds["id"], doc["id"], [chunk_id])
    assert result is not None
