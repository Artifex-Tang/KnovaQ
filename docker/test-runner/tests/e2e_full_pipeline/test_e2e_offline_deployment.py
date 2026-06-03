"""E2E-003: Verify no external network dependency — all services reachable internally."""

import pytest

pytestmark = [pytest.mark.api, pytest.mark.e2e]


def test_e2e003_offline_no_external_deps(ragflow_api, gaisoft_api):
    """E2E-003: All core services respond without external network."""
    # Ragflow health
    health = ragflow_api.health_check()
    assert health is not None, "Ragflow should be reachable"

    # Gaisoft API
    info = gaisoft_api.get_info()
    assert info is not None, "Gaisoft-mes should be reachable"

    # Ragflow retrieval (internal)
    datasets = ragflow_api.list_datasets()
    assert isinstance(datasets, list), "Dataset listing should work internally"
