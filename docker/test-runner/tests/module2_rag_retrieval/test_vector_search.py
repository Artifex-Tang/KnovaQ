"""RG-001: Basic semantic retrieval. RG-010: Irrelevant query. RG-011: Long query."""

import pytest
from fixtures.assertions import assert_similarity_above

pytestmark = pytest.mark.api


def test_rg001_basic_semantic_search(ragflow_api, prepared_dataset):
    """RG-001: Query '雷达维护周期' should return radar maintenance chunks."""
    results = ragflow_api.retrieval(
        question="雷达维护周期",
        dataset_ids=[prepared_dataset["id"]],
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0, "Should return chunks for radar maintenance query"
    assert_similarity_above(chunks, threshold=0.1)


def test_rg001_equipment_query(ragflow_api, prepared_dataset):
    """RG-001: Query about equipment parameters."""
    results = ragflow_api.retrieval(
        question="ZBD-2000通信系统频率范围",
        dataset_ids=[prepared_dataset["id"]],
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0


def test_rg010_irrelevant_query(ragflow_api, prepared_dataset):
    """RG-010: Irrelevant query returns low similarity or empty results."""
    results = ragflow_api.retrieval(
        question="今天天气怎么样",
        dataset_ids=[prepared_dataset["id"]],
        similarity_threshold=0.5,
    )
    chunks = results.get("chunks", [])
    # Either empty or very low similarity
    if chunks:
        top_sim = chunks[0].get("similarity", 0)
        assert top_sim < 0.5, f"Irrelevant query should have low similarity, got {top_sim}"


def test_rg011_long_query(ragflow_api, prepared_dataset):
    """RG-011: 200+ character query should still retrieve relevant chunks."""
    long_query = (
        "请问在野战环境下，当AN/TPQ-53雷达系统出现发射机功率不足的故障时，"
        "操作人员应该按照什么步骤进行排查和处理？"
        "需要检查哪些关键部件？是否有备用方案可以临时恢复系统运行？"
        "同时在这种情况下如何确保战场态势感知能力不中断？"
    )
    results = ragflow_api.retrieval(
        question=long_query,
        dataset_ids=[prepared_dataset["id"]],
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0, "Long query should still return results"
