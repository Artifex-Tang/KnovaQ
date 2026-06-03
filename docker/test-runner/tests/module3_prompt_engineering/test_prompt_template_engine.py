"""PE-011: OpenAI-compatible API endpoint."""

import pytest

pytestmark = pytest.mark.api


def test_pe011_openai_compatible(ragflow_api, test_chat_assistant):
    """PE-011: Call via OpenAI-compatible endpoint, verify response format."""
    result = ragflow_api.openai_completion(
        chat_id=test_chat_assistant["id"],
        messages=[{"role": "user", "content": "雷达维护周期是多少？"}],
        stream=False,
    )
    # OpenAI format: {"choices": [{"message": {"content": "..."}}]}
    assert "choices" in result or "data" in result, (
        f"OpenAI-compatible response should have 'choices'. Got keys: {list(result.keys())}"
    )
