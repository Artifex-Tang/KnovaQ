"""Module 1 fixtures — isolated dataset per test file."""

import uuid
import pytest


@pytest.fixture(scope="module")
def module_dataset(ragflow_api):
    """Create a fresh dataset for this module's tests."""
    ds = ragflow_api.create_dataset(
        name=f"m1_kb_{uuid.uuid4().hex[:8]}", chunk_method="naive"
    )
    yield ds
    try:
        ragflow_api.delete_dataset(ds["id"])
    except Exception:
        pass
