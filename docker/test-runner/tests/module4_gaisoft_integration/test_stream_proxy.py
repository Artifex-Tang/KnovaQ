"""GI-001: StreamProxy forwards SSE from ragflow correctly."""

import pytest

pytestmark = pytest.mark.api


def test_gi001_stream_proxy_sse(gaisoft_api, ragflow_api, test_chat_assistant, test_session):
    """GI-001: Stream proxy forwards ragflow SSE through gaisoft-mes."""
    # Call through gaisoft StreamProxyController
    chunks = gaisoft_api.stream_proxy(
        url=f"/api/v1/chats/{test_chat_assistant['id']}/completions",
        params={
            "question": "请简述雷达维护规程",
            "session_id": test_session["id"],
            "stream": True,
        },
    )
    assert len(chunks) > 0, "Stream proxy should forward SSE chunks"
    combined = "\n".join(chunks)
    assert "data" in combined.lower() or len(chunks) > 1, (
        "SSE stream should contain data events"
    )
