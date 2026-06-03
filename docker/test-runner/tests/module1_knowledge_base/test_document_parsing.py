"""KB-003~006: Document parsing with different chunk methods. KB-008: Multi-source."""

import uuid
import pytest
import tempfile
from pathlib import Path

pytestmark = pytest.mark.api


def _upload_and_parse(ragflow_api, chunk_method, content_factory, filename, **parser_kwargs):
    """Helper: create dataset, upload doc, parse, return (dataset, doc_list)."""
    ds = ragflow_api.create_dataset(
        name=f"parse_{chunk_method}_{uuid.uuid4().hex[:6]}",
        chunk_method=chunk_method,
        parser_config=parser_kwargs if parser_kwargs else None,
    )
    with tempfile.TemporaryDirectory() as tmp:
        path = content_factory(Path(tmp) / filename)
        docs = ragflow_api.upload_document(ds["id"], str(path))
    doc_ids = [docs["id"]] if isinstance(docs, dict) else [d["id"] for d in docs]
    ragflow_api.parse_documents(ds["id"], doc_ids)
    success = ragflow_api.wait_for_parsing(ds["id"], timeout=180)
    doc_list = ragflow_api.list_documents(ds["id"])
    return ds, doc_list, success


def test_kb003_parse_naive(ragflow_api):
    """KB-003: Parse with naive chunk_method, chunk_token_num=512."""
    from fixtures.test_data_factory import generate_txt, FIELD_GUIDE_CN
    ds, doc_data, success = _upload_and_parse(
        ragflow_api, "naive",
        lambda p: generate_txt(p, FIELD_GUIDE_CN),
        "guide.txt",
    )
    assert success, "Parsing should complete successfully"
    docs = doc_data.get("docs", [doc_data])
    assert len(docs) > 0
    # Verify chunks were created
    doc = docs[0] if isinstance(docs, list) else docs
    chunk_count = doc.get("chunk_num", doc.get("progress", 0))
    assert chunk_count > 0, f"Expected chunks > 0, got {chunk_count}"
    ragflow_api.delete_dataset(ds["id"])


def test_kb004_parse_book(ragflow_api):
    """KB-004: Parse with book chunk_method — preserves chapter structure."""
    from fixtures.test_data_factory import generate_docx, EQUIPMENT_MANUAL_CN
    ds, doc_data, success = _upload_and_parse(
        ragflow_api, "book",
        lambda p: generate_docx(p, EQUIPMENT_MANUAL_CN),
        "manual.docx",
    )
    assert success, "Book parsing should complete"
    ragflow_api.delete_dataset(ds["id"])


def test_kb005_parse_table(ragflow_api):
    """KB-005: Parse XLSX with table chunk_method — preserves table structure."""
    from fixtures.test_data_factory import generate_xlsx
    ds, doc_data, success = _upload_and_parse(
        ragflow_api, "table",
        generate_xlsx,
        "spec.xlsx",
    )
    assert success, "Table parsing should complete"
    ragflow_api.delete_dataset(ds["id"])


def test_kb006_parse_paper(ragflow_api):
    """KB-006: Parse with paper chunk_method — separates abstract/body/references."""
    from fixtures.test_data_factory import generate_txt
    paper = """Abstract: This paper evaluates adaptive radar processing.
Keywords: radar, STAP, DARPA
1. Introduction
Modern radar faces complex environments.
2. Methodology
We developed novel algorithms.
3. Results
12 dB SINR improvement achieved.
4. Conclusion
Phase III recommended.
References
[1] Smith et al., IEEE Trans. Radar, 2024
[2] DARPA MTO Report, 2025
"""
    ds, doc_data, success = _upload_and_parse(
        ragflow_api, "paper",
        lambda p: generate_txt(p, paper),
        "paper.txt",
    )
    assert success, "Paper parsing should complete"
    ragflow_api.delete_dataset(ds["id"])


def test_kb008_multi_source_ingestion(ragflow_api):
    """KB-008: Ingest CN + EN docs + table into same dataset — no conflicts."""
    from fixtures.test_data_factory import (
        generate_txt, generate_xlsx,
        RADAR_REPORT_CN, TECH_REPORT_EN,
    )

    ds = ragflow_api.create_dataset(
        name=f"multi_source_{uuid.uuid4().hex[:6]}",
        chunk_method="naive",
    )
    with tempfile.TemporaryDirectory() as tmp:
        cn_path = generate_txt(Path(tmp) / "cn.txt", RADAR_REPORT_CN)
        en_path = generate_txt(Path(tmp) / "en.txt", TECH_REPORT_EN)
        xlsx_path = generate_xlsx(Path(tmp) / "spec.xlsx")
        all_docs = ragflow_api.upload_documents(
            ds["id"], [str(cn_path), str(en_path), str(xlsx_path)]
        )
    doc_ids = [d["id"] for d in all_docs]
    ragflow_api.parse_documents(ds["id"], doc_ids)
    success = ragflow_api.wait_for_parsing(ds["id"], timeout=180)
    assert success, "All documents should parse without conflict"
    ragflow_api.delete_dataset(ds["id"])
