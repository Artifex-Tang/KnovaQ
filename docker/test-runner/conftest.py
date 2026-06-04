"""Global pytest fixtures for DARPA E2E test suite."""

import os
import sys
import uuid

import pytest

# Add fixtures to path
sys.path.insert(0, os.path.dirname(__file__))

from fixtures.api_client import RagflowClient
from fixtures.gaisoft_client import GaisoftClient
from fixtures.browser_factory import BrowserFactory


@pytest.fixture(scope="session")
def ragflow_api():
    """Ragflow HTTP API client — session-scoped, reused across all tests."""
    base_url = os.environ["RAGFLOW_BASE_URL"]
    api_key = os.environ.get("RAGFLOW_API_KEY", "")
    client = RagflowClient(base_url=base_url, api_key=api_key)

    # Wait for ragflow to be healthy
    healthy = client.wait_healthy(timeout=120, interval=5)
    if not healthy:
        pytest.skip("Ragflow service not healthy after 120s")

    yield client


@pytest.fixture(scope="session")
def gaisoft_api():
    """Gaisoft-mes API client — session-scoped. Skips if login fails (e.g. captcha required)."""
    base_url = os.environ["GAISOFT_API_URL"]
    username = os.environ.get("GAISOFT_LOGIN_USER", "admin")
    password = os.environ.get("GAISOFT_LOGIN_PASS", "admin123")
    try:
        client = GaisoftClient(base_url=base_url, username=username, password=password)
    except Exception as e:
        pytest.skip(f"Gaisoft login failed: {e}")
        return
    yield client


@pytest.fixture(scope="session")
def browser_context():
    """Playwright Chromium headless browser context."""
    frontend_url = os.environ.get("GAISOFT_FRONTEND_URL", "http://gaisoft-frontend:80")
    factory = BrowserFactory()
    context = factory.create_context(base_url=frontend_url, headless=True)
    yield context
    factory.close()


@pytest.fixture(scope="session")
def test_dataset(ragflow_api):
    """Create a temporary dataset for testing. Auto-deleted after session."""
    ds_name = f"test_darpa_{uuid.uuid4().hex[:8]}"
    ds = ragflow_api.create_dataset(name=ds_name, chunk_method="naive")
    yield ds
    try:
        ragflow_api.delete_dataset(ds["id"])
    except Exception:
        pass


@pytest.fixture(scope="session")
def prepared_dataset(ragflow_api, test_dataset):
    """Dataset with all test documents uploaded and parsed."""
    from fixtures.test_data_factory import upload_test_documents, wait_for_parsing

    docs = upload_test_documents(ragflow_api, test_dataset["id"])
    doc_ids = [d["id"] for d in docs]
    ragflow_api.parse_documents(test_dataset["id"], doc_ids)
    success = wait_for_parsing(ragflow_api, test_dataset["id"], timeout=300)
    if not success:
        pytest.skip("Document parsing did not complete within 300s")
    return test_dataset


@pytest.fixture(scope="session")
def test_chat_assistant(ragflow_api, prepared_dataset):
    """Create a test chat assistant bound to prepared dataset. Auto-deleted."""
    chat = ragflow_api.create_chat(
        name=f"test_chat_{uuid.uuid4().hex[:8]}",
        dataset_ids=[prepared_dataset["id"]],
    )
    # Try to set prompt config — may fail on 0.18.0
    try:
        updated = ragflow_api.update_chat(
            chat["id"],
            prompt_config={
                "system": "你是DARPA装备分析专家，基于提供的知识库内容回答问题。请用中文回答。",
                "empty_response": "抱歉，知识库中没有找到相关信息。",
            },
        )
        # Only replace if update returned a valid chat with id
        if isinstance(updated, dict) and "id" in updated:
            chat = updated
    except Exception:
        pass  # prompt_config not supported, use default
    yield chat
    try:
        ragflow_api.delete_chat(chat["id"])
    except Exception:
        pass


@pytest.fixture(scope="session")
def test_session(ragflow_api, test_chat_assistant):
    """Create a test conversation session."""
    chat_id = test_chat_assistant.get("id", test_chat_assistant.get("data", {}).get("id", ""))
    if not chat_id:
        pytest.skip("Could not get chat assistant ID")
    sess = ragflow_api.create_session(chat_id)
    yield sess
    try:
        ragflow_api.delete_session(chat_id, [sess.get("id", sess)])
    except Exception:
        pass
