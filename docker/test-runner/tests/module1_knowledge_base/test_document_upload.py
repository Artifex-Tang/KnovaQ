"""KB-002: Multi-format upload. KB-010: Large file. KB-011: Batch upload."""

import pytest
from pathlib import Path

pytestmark = pytest.mark.api


def test_kb002_upload_pdf(ragflow_api, module_dataset):
    """KB-002: Upload PDF document."""
    from fixtures.test_data_factory import generate_pdf, RADAR_REPORT_CN
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        path = generate_pdf(Path(tmp) / "radar.pdf", RADAR_REPORT_CN)
        docs = ragflow_api.upload_document(module_dataset["id"], str(path))
    assert docs["id"], "Document ID should be returned"


def test_kb002_upload_docx(ragflow_api, module_dataset):
    """KB-002: Upload DOCX document."""
    from fixtures.test_data_factory import generate_docx, EQUIPMENT_MANUAL_CN
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        path = generate_docx(Path(tmp) / "manual.docx", EQUIPMENT_MANUAL_CN)
        docs = ragflow_api.upload_document(module_dataset["id"], str(path))
    assert docs["id"]


def test_kb002_upload_xlsx(ragflow_api, module_dataset):
    """KB-002: Upload XLSX document."""
    from fixtures.test_data_factory import generate_xlsx
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        path = generate_xlsx(Path(tmp) / "spec.xlsx")
        docs = ragflow_api.upload_document(module_dataset["id"], str(path))
    assert docs["id"]


def test_kb002_upload_txt(ragflow_api, module_dataset):
    """KB-002: Upload TXT document."""
    from fixtures.test_data_factory import generate_txt, FIELD_GUIDE_CN
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        path = generate_txt(Path(tmp) / "guide.txt", FIELD_GUIDE_CN)
        docs = ragflow_api.upload_document(module_dataset["id"], str(path))
    assert docs["id"]


def test_kb002_upload_md(ragflow_api, module_dataset):
    """KB-002: Upload MD document."""
    from fixtures.test_data_factory import generate_txt, POLICY_LAWS_CN
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        path = generate_txt(Path(tmp) / "policy.md", POLICY_LAWS_CN)
        docs = ragflow_api.upload_document(module_dataset["id"], str(path))
    assert docs["id"]


def test_kb010_large_file_upload(ragflow_api, module_dataset):
    """KB-010: Upload large file (>50MB simulated by large text)."""
    import tempfile

    with tempfile.TemporaryDirectory() as tmp:
        # Generate a large text file (~5MB with repeated content)
        large_content = ("军事装备测试数据 " * 100 + "\n") * 5000
        path = Path(tmp) / "large_doc.txt"
        path.write_text(large_content, encoding="utf-8")
        docs = ragflow_api.upload_document(module_dataset["id"], str(path))
    assert docs["id"], "Large file should upload successfully"


def test_kb011_batch_document_upload(ragflow_api, module_dataset):
    """KB-011: Upload 20 documents in batch."""
    import tempfile
    from fixtures.test_data_factory import generate_txt

    with tempfile.TemporaryDirectory() as tmp:
        paths = []
        for i in range(20):
            path = generate_txt(
                Path(tmp) / f"batch_{i}.txt",
                f"批量测试文档 #{i}：装备编号EQ-{i:04d}，状态正常。"
            )
            paths.append(str(path))
        docs = ragflow_api.upload_documents(module_dataset["id"], paths)
    assert len(docs) == 20, f"Expected 20 docs, got {len(docs)}"
