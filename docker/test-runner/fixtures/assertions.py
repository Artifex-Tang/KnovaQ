"""Shared assertion helpers for test suites."""


def assert_streaming_ended(chunks: list, message: str = ""):
    """Verify SSE stream ended properly (not truncated).

    Checks for common termination markers in the combined chunk output.
    """
    combined = "\n".join(chunks)
    termination_markers = [
        "[DONE]",
        "message_end",
        '"code":0',
        '"code": 0',
        '"answer":""',
        '"finish_reason"',
        '"data": true',
    ]
    found = any(marker in combined for marker in termination_markers)
    if not found:
        last_chunks = chunks[-5:] if len(chunks) >= 5 else chunks
        raise AssertionError(
            f"{message} — No termination marker found in stream. "
            f"Last chunks: {last_chunks}"
        )
