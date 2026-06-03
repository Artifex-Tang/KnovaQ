"""RG-003: Similarity threshold tuning — higher threshold = fewer, more precise results."""

import pytest

pytestmark = pytest.mark.api


def test_rg003_threshold_tuning(ragflow_api, prepared_dataset):
    """RG-003: Vary similarity_threshold and verify result count inversely correlates."""
    thresholds = [0.1, 0.3, 0.5, 0.7]
    counts = []
    for t in thresholds:
        results = ragflow_api.retrieval(
            question="雷达维护",
            dataset_ids=[prepared_dataset["id"]],
            similarity_threshold=t,
        )
        chunks = results.get("chunks", [])
        counts.append(len(chunks))

    # Generally, higher threshold should yield fewer or equal results
    # Allow for some tolerance as similarity scores may not be strictly ordered
    assert counts[0] >= counts[-1], (
        f"Expected count(0.1)={counts[0]} >= count(0.7)={counts[-1]}"
    )


def test_rg003_threshold_extreme(ragflow_api, prepared_dataset):
    """RG-003: Very high threshold (0.9) should return few or no results."""
    results = ragflow_api.retrieval(
        question="装备检查",
        dataset_ids=[prepared_dataset["id"]],
        similarity_threshold=0.9,
    )
    chunks = results.get("chunks", [])
    # At 0.9 threshold, results should be very few
    assert len(chunks) <= 3, f"Threshold 0.9 should yield <= 3 chunks, got {len(chunks)}"
