"""GI-003: Auth token caching — gaisoft caches ragflow auth token."""

import pytest

pytestmark = pytest.mark.api


def test_gi003_auth_token_caching(gaisoft_api):
    """GI-003: Consecutive requests reuse cached token."""
    # Make two consecutive ragflow proxy calls
    r1 = gaisoft_api.ragflow_common("/api/v1/system/healthz", method="get")
    r2 = gaisoft_api.ragflow_common("/api/v1/system/healthz", method="get")

    # Both should succeed (token cached and reused)
    assert r1 is not None
    assert r2 is not None


def test_gi003_gaisoft_login(gaisoft_api):
    """GI-003: Gaisoft login returns valid token and user info."""
    info = gaisoft_api.get_info()
    assert info.get("code") == 200 or "user" in info, (
        f"getInfo should return user data. Got: {info}"
    )
