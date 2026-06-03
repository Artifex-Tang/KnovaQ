"""Playwright browser factory for UI tests."""

import os
from playwright.sync_api import sync_playwright, Browser, BrowserContext


class BrowserFactory:
    """Manages Playwright browser lifecycle."""

    def __init__(self):
        self._playwright = None
        self._browser = None

    def create_context(self, base_url: str = "", headless: bool = True) -> BrowserContext:
        self._playwright = sync_playwright().start()
        self._browser = self._playwright.chromium.launch(headless=headless)
        context = self._browser.new_context(
            base_url=base_url,
            viewport={"width": 1920, "height": 1080},
            locale="zh-CN",
        )
        return context

    def close(self):
        if self._browser:
            self._browser.close()
        if self._playwright:
            self._playwright.stop()
