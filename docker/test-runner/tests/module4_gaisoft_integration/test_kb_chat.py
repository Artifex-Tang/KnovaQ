"""GI-003 subset: KB chat record CRUD via gaisoft API."""

import pytest

pytestmark = pytest.mark.api


def test_gi003_kb_chat_list(gaisoft_api):
    """GI-003: List KB chat records through gaisoft API."""
    result = gaisoft_api.list_kb_chats()
    assert result is not None, "Should return chat records"
    assert result.get("code") == 200 or "rows" in result or "data" in result


def test_gi003_kb_session_list(gaisoft_api):
    """GI-003: List KB sessions through gaisoft API."""
    result = gaisoft_api.list_kb_sessions()
    assert result is not None, "Should return session records"
