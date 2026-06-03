"""UI Playwright fixtures."""

import os
import pytest


@pytest.fixture(scope="module")
def logged_page(browser_context, gaisoft_api):
    """Navigate to frontend and log in."""
    frontend_url = os.environ.get("GAISOFT_FRONTEND_URL", "http://gaisoft-frontend:80")
    page = browser_context.new_page()

    # Navigate to login page
    page.goto(frontend_url, wait_until="networkidle", timeout=30000)

    # Try to find and fill login form
    username_input = page.locator('input[placeholder*="用户名"], input[type="text"]').first
    password_input = page.locator('input[placeholder*="密码"], input[type="password"]').first

    if username_input.is_visible() and password_input.is_visible():
        username = os.environ.get("GAISOFT_LOGIN_USER", "admin")
        password = os.environ.get("GAISOFT_LOGIN_PASS", "admin123")
        username_input.fill(username)
        password_input.fill(password)

        # Click login button
        login_btn = page.locator('button[type="submit"], button:has-text("登录")').first
        if login_btn.is_visible():
            login_btn.click()
            page.wait_for_load_state("networkidle", timeout=15000)

    yield page
    page.close()
