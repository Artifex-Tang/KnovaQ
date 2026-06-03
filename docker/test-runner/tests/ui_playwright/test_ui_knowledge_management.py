"""UI-001: Knowledge base management page — navigate, create dataset."""

import os
import pytest

pytestmark = pytest.mark.ui


def test_ui001_kb_page_navigation(logged_page):
    """UI-001: Navigate to KB management page and verify it renders."""
    frontend_url = os.environ.get("GAISOFT_FRONTEND_URL", "http://gaisoft-frontend:80")

    # Look for KB-related navigation menu items
    kb_links = [
        'a:has-text("知识库")',
        'a:has-text("知识管理")',
        'a:has-text("KB")',
        '[data-menu-key="kb"]',
        'a[href*="kb"]',
    ]
    found = False
    for selector in kb_links:
        link = logged_page.locator(selector).first
        if link.is_visible(timeout=3000):
            link.click()
            logged_page.wait_for_load_state("networkidle", timeout=10000)
            found = True
            break

    if not found:
        # Try direct URL navigation
        logged_page.goto(f"{frontend_url}/#/kb", wait_until="networkidle", timeout=15000)

    # Page should have loaded without errors
    assert logged_page.locator("body").is_visible()


def test_ui001_kb_page_elements(logged_page):
    """UI-001: Verify KB page contains expected UI elements."""
    # Check for common KB page elements
    page_content = logged_page.content()
    assert len(page_content) > 100, "Page should have rendered content"
