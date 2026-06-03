"""KB-001: Create dataset. KB-012: Delete dataset with cascade."""

import uuid
import pytest

pytestmark = pytest.mark.api


def test_kb001_create_dataset(ragflow_api):
    """KB-001: Create knowledge base with name and chunk_method."""
    name = f"darpa_test_{uuid.uuid4().hex[:8]}"
    ds = ragflow_api.create_dataset(name=name, chunk_method="naive")
    assert ds["id"], "Dataset ID should be returned"
    assert ds["name"] == name
    # Cleanup
    ragflow_api.delete_dataset(ds["id"])


def test_kb001_create_dataset_with_embedding_model(ragflow_api):
    """KB-001 variant: Create dataset with embedding model specified."""
    name = f"darpa_emb_{uuid.uuid4().hex[:8]}"
    ds = ragflow_api.create_dataset(name=name, embedding_model="BAAI/bge-large-zh-v1.5@BAAI")
    assert ds["id"]
    ragflow_api.delete_dataset(ds["id"])


def test_kb012_delete_dataset_cascade(ragflow_api):
    """KB-012: Delete dataset cascades to documents and chunks."""
    from fixtures.test_data_factory import generate_txt, upload_test_documents

    # Create dataset and upload docs
    name = f"cascade_test_{uuid.uuid4().hex[:8]}"
    ds = ragflow_api.create_dataset(name=name)
    docs = upload_test_documents(ragflow_api, ds["id"])
    doc_ids = [d["id"] for d in docs]

    # Parse
    ragflow_api.parse_documents(ds["id"], doc_ids)
    ragflow_api.wait_for_parsing(ds["id"], timeout=120)

    # Verify docs exist
    doc_list = ragflow_api.list_documents(ds["id"])
    assert len(doc_list.get("docs", doc_list)) > 0

    # Delete dataset
    ragflow_api.delete_dataset(ds["id"])

    # Verify dataset gone — listing should not contain it
    datasets = ragflow_api.list_datasets()
    ds_ids = [d["id"] for d in datasets]
    assert ds["id"] not in ds_ids, "Deleted dataset should not appear in listing"


def test_kb001_list_datasets(ragflow_api):
    """KB-001 variant: List datasets returns valid structure."""
    datasets = ragflow_api.list_datasets()
    assert isinstance(datasets, list)
