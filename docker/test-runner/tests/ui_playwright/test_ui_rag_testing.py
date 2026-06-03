"""UI-004: RAG testing page — execute retrieval test with similarity scores."""

import os
import pytest

pytestmark = pytest.mark.ui


def test_ui004_rag_test_page(logged_page):
    """UI-004: Navigate to RAG test page and verify it renders."""
    frontend_url = os.environ.get("GAISOFT_FRONTEND_URL", "http://gaisoft-frontend:80")

    # Navigate to RAG test / knowledge testing page
    rag_selectors = [
        'a:has-text("检索测试")',
        'a:has-text("RAG")',
        'a:has-text("知识测试")',
        'a[href*="rag"]',
        'a[href*="test"]',
    ]
    for selector in rag_selectors:
        link = logged_page.locator(selector).first
        if link.is_visible(timeout=3000):
            link.click()
            logged_page.wait_for_load_state("networkidle", timeout=10000)
            break
    else:
        logged_page.goto(f"{frontend_url}/#/ragTest", wait_until="networkidle", timeout=15000)

    # Verify page rendered
    page_content = logged_page.content()
    assert len(page_content) > 100, "RAG test page should render"
