"""PE-004: Streaming response via SSE."""

import pytest
from fixtures.assertions import assert_streaming_ended

pytestmark = pytest.mark.api


def test_pe004_streaming_response(ragflow_api, test_chat_assistant, test_session):
    """PE-004: Stream=true returns SSE chunks ending with [DONE] or message_end."""
    result = ragflow_api.chat_completion(
        chat_id=test_chat_assistant["id"],
        question="请简述雷达系统的日常维护步骤",
        session_id=test_session["id"],
        stream=True,
    )
    chunks = result.get("chunks", [])
    assert len(chunks) > 0, "Streaming should produce chunks"
    assert_streaming_ended(chunks, "Stream should terminate properly")
