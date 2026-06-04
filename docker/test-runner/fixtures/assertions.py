"""Custom assertion helpers for E2E tests."""

import json


def assert_successful_response(data: dict, msg: str = ""):
    """Assert ragflow API returned success (code 0)."""
    code = data.get("code", -1)
    assert code == 0, f"Expected code 0, got {code}. {msg}. Data: {data}"


def assert_chunk_count(data: dict, min_count: int = 1, msg: str = ""):
    """Assert at least min_count chunks returned."""
    chunks = data.get("chunks", data.get("data", {}).get("chunks", []))
    assert len(chunks) >= min_count, (
        f"Expected >= {min_count} chunks, got {len(chunks)}. {msg}"
    )


def assert_similarity_above(chunks: list, threshold: float = 0.2, msg: str = ""):
    """Assert top chunk similarity exceeds threshold."""
    assert len(chunks) > 0, f"No chunks returned. {msg}"
    top_sim = chunks[0].get("similarity", 0)
    assert top_sim >= threshold, (
        f"Top similarity {top_sim} < threshold {threshold}. {msg}"
    )


def assert_valid_reference(reference: dict):
    """Assert reference contains required fields."""
    assert "chunk_id" in reference or "id" in reference, "Reference missing chunk_id"
    assert "similarity" in reference, "Reference missing similarity"


def assert_valid_json(text: str, msg: str = ""):
    """Assert string is valid JSON."""
    try:
        json.loads(text)
    except json.JSONDecodeError as e:
        raise AssertionError(f"Invalid JSON: {e}. {msg}")


def assert_streaming_ended(chunks: list, msg: str = ""):
    """Assert SSE stream contains terminal marker."""
    combined = "\n".join(chunks)
    assert "[DONE]" in combined or "message_end" in combined or '"code":0' in combined or '"answer":""' in combined, (
        f"Stream did not terminate properly. {msg}"
    )


def assert_doc_status(doc: dict, expected_status, msg: str = ""):
    """Assert document is in expected status (0=UNSTART, 1=RUNNING, 2=CANCEL, 3=DONE, 4=FAIL)."""
    status = doc.get("run", doc.get("progress", -1))
    assert status == expected_status, (
        f"Expected status {expected_status}, got {status}. {msg}"
    )
