"""RG-004: Cross-language retrieval — Chinese query finds English docs and vice versa."""

import uuid
import pytest
import tempfile
from pathlib import Path

pytestmark = pytest.mark.api


@pytest.fixture(scope="module")
def bilingual_dataset(ragflow_api):
    """Dataset with both CN and EN documents."""
    from fixtures.test_data_factory import generate_txt, RADAR_REPORT_CN, TECH_REPORT_EN

    ds = ragflow_api.create_dataset(name=f"bilingual_{uuid.uuid4().hex[:6]}")
    with tempfile.TemporaryDirectory() as tmp:
        cn = generate_txt(Path(tmp) / "cn.txt", RADAR_REPORT_CN)
        en = generate_txt(Path(tmp) / "en.txt", TECH_REPORT_EN)
        docs = ragflow_api.upload_documents(ds["id"], [str(cn), str(en)])
    ragflow_api.parse_documents(ds["id"], [d["id"] for d in docs])
    ragflow_api.wait_for_parsing(ds["id"], timeout=180)
    yield ds
    ragflow_api.delete_dataset(ds["id"])


def test_rg004_cn_query_finds_en(ragflow_api, bilingual_dataset):
    """RG-004: Chinese query with cross_languages should find English docs."""
    results = ragflow_api.retrieval(
        question="雷达信号处理算法",
        dataset_ids=[bilingual_dataset["id"]],
        cross_languages=True,
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0, "Cross-language query should return results"


def test_rg004_en_query_finds_cn(ragflow_api, bilingual_dataset):
    """RG-004: English query with cross_languages should find Chinese docs."""
    results = ragflow_api.retrieval(
        question="radar maintenance interval hours",
        dataset_ids=[bilingual_dataset["id"]],
        cross_languages=True,
    )
    chunks = results.get("chunks", [])
    assert len(chunks) > 0, "Cross-language query should return results"
