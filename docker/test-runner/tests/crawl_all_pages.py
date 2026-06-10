"""BFS crawl all pages of gaisoft-ui, screenshot every page.

Strategy:
1. Login to gaisoft
2. Call /getRouters to get dynamic menu tree
3. BFS traverse all menus, click each, screenshot
4. Also visit known static routes not in menu tree
5. Save results as JSON + PNG screenshots

Output:
  reports/crawl/screenshots/  — PNG per page
  reports/crawl/crawl_report.json  — summary
"""

import base64
import json
import os
import sys
import time
import traceback
from collections import deque
from pathlib import Path

# Constants
API_URL = os.environ.get("GAISOFT_API_URL", "http://gaisoft-server:8080").rstrip("/")
FRONTEND_URL = os.environ.get("GAISOFT_FRONTEND_URL", "http://gaisoft-frontend:80").rstrip("/")
LOGIN_USER = os.environ.get("GAISOFT_LOGIN_USER", "admin")
LOGIN_PASS = os.environ.get("GAISOFT_LOGIN_PASS", "admin123")

REPORT_DIR = os.path.join(os.path.dirname(__file__), "..", "reports", "crawl")
SCREENSHOT_DIR = os.path.join(REPORT_DIR, "screenshots")

# Known routes that may not appear in dynamic menu
EXTRA_ROUTES = [
    "/user/profile",
    "/401",
    "/404",
    "/tool/build",
    "/tool/swagger",
    "/monitor/druid",
    "/monitor/cache/list",
]


def ensure_dirs():
    os.makedirs(SCREENSHOT_DIR, exist_ok=True)


def login_and_get_token():
    """Login to gaisoft, return Bearer token."""
    import requests
    resp = requests.post(
        f"{API_URL}/login",
        json={"username": LOGIN_USER, "password": LOGIN_PASS},
        timeout=30,
    )
    assert resp.status_code == 200, f"Login failed: {resp.status_code}"
    data = resp.json()
    token = data.get("token", "")
    assert token, f"No token: {data}"
    return token


def get_menu_tree(token):
    """Call /getRouters to get dynamic menu tree."""
    import requests
    headers = {"Authorization": f"Bearer {token}"}
    resp = requests.get(f"{API_URL}/getRouters", headers=headers, timeout=30)
    assert resp.status_code == 200, f"getRouters failed: {resp.status_code}"
    data = resp.json()
    # Response: {code:200, data: [...menu tree...]}
    routes = data.get("data", data) if isinstance(data, dict) else data
    return routes


def flatten_menu_tree(menu_tree):
    """Flatten menu tree into list of (path, name, parent_path) tuples.
    BFS traversal preserving order.
    """
    pages = []
    queue = deque()

    # Seed with top-level items
    for item in menu_tree:
        queue.append((item, "ROOT"))

    while queue:
        node, parent = queue.popleft()
        name = node.get("name", node.get("meta", {}).get("title", "unknown"))
        path = node.get("path", "")
        component = node.get("component", "")
        children = node.get("children", [])
        meta = node.get("meta", {})
        title = meta.get("title", name)

        # Only record leaf nodes (ones with components) or directory nodes with paths
        if component or not children:
            pages.append({
                "path": path,
                "name": name,
                "title": title,
                "component": component,
                "parent": parent,
                "is_menu": bool(children),
            })
        elif path:
            # Directory node, record it too for completeness
            pages.append({
                "path": path,
                "name": name,
                "title": title,
                "component": component,
                "parent": parent,
                "is_menu": True,
            })

        # Process children
        for child in children:
            queue.append((child, path))

    return pages


def crawl_pages(token, pages):
    """Use Playwright to BFS-visit each page and take screenshots."""
    from playwright.sync_api import sync_playwright

    results = []
    visited = set()

    pw = sync_playwright().start()
    browser = pw.chromium.launch(headless=True)
    context = browser.new_context(
        base_url=FRONTEND_URL,
        viewport={"width": 1920, "height": 1080},
        locale="zh-CN",
    )
    page = context.new_page()

    # Collect JS console errors
    console_errors = []
    page.on("console", lambda msg: console_errors.append(msg.text) if msg.type == "error" else None)

    # Login via UI
    print("[1/3] Logging in via browser...")
    page.goto(f"{FRONTEND_URL}/#/login", wait_until="networkidle", timeout=30000)
    username_input = page.locator('input[placeholder*="用户名"], input[type="text"]').first
    password_input = page.locator('input[placeholder*="密码"], input[type="password"]').first

    if username_input.is_visible() and password_input.is_visible():
        username_input.fill(LOGIN_USER)
        password_input.fill(LOGIN_PASS)
        login_btn = page.locator('button[type="submit"], button:has-text("登录")').first
        if login_btn.is_visible():
            login_btn.click()
            page.wait_for_load_state("networkidle", timeout=15000)

    # Take login result screenshot
    page.screenshot(path=os.path.join(SCREENSHOT_DIR, "000_login_result.png"), full_page=True)

    # Phase 1: Visit each page by URL hash
    print(f"[2/3] Visiting {len(pages)} menu pages...")
    for i, p in enumerate(pages):
        path = p.get("path", "")
        title = p.get("title", p.get("name", ""))
        safe_name = f"{i+1:03d}_{title}".replace("/", "_").replace(" ", "_").replace("(", "").replace(")", "")

        if not path or path in visited:
            results.append({**p, "status": "skipped", "error": "no path or already visited"})
            continue

        visited.add(path)
        console_errors.clear()

        try:
            # Navigate via hash route
            full_url = f"{FRONTEND_URL}/#{path}"
            page.goto(full_url, wait_until="networkidle", timeout=20000)
            time.sleep(1)  # Let animations finish

            # Screenshot
            ss_path = os.path.join(SCREENSHOT_DIR, f"{safe_name}.png")
            page.screenshot(path=ss_path, full_page=True)

            # Check for error indicators on page
            body_text = page.locator("body").inner_text()
            has_error = any(kw in body_text for kw in ["系统未知错误", "404", "401", "页面不存在"])
            page_errors = list(console_errors)
            visible = page.locator("body").is_visible()

            results.append({
                **p,
                "status": "error" if has_error else "ok",
                "screenshot": ss_path,
                "visible": visible,
                "has_error_text": has_error,
                "console_errors": page_errors[:5],
                "page_title": page.title(),
            })
            status_icon = "❌" if has_error else "✅"
            print(f"  {status_icon} [{i+1}/{len(pages)}] {title} ({path}) — {'ERROR' if has_error else 'OK'}")

        except Exception as e:
            results.append({**p, "status": "exception", "error": str(e)})
            print(f"  ⚠️  [{i+1}/{len(pages)}] {title} ({path}) — EXCEPTION: {e}")

    # Phase 2: Visit extra routes not in menu
    print(f"[3/3] Visiting {len(EXTRA_ROUTES)} extra routes...")
    for i, path in enumerate(EXTRA_ROUTES):
        if path in visited:
            continue
        safe_name = f"extra_{i+1:03d}_{path}".replace("/", "_")
        console_errors.clear()

        try:
            page.goto(f"{FRONTEND_URL}/#{path}", wait_until="networkidle", timeout=20000)
            time.sleep(1)
            ss_path = os.path.join(SCREENSHOT_DIR, f"{safe_name}.png")
            page.screenshot(path=ss_path, full_page=True)

            body_text = page.locator("body").inner_text()
            has_error = any(kw in body_text for kw in ["系统未知错误", "404", "401", "页面不存在"])
            page_errors = list(console_errors)

            results.append({
                "path": path,
                "title": f"Extra: {path}",
                "status": "error" if has_error else "ok",
                "screenshot": ss_path,
                "has_error_text": has_error,
                "console_errors": page_errors[:5],
            })
            status_icon = "❌" if has_error else "✅"
            print(f"  {status_icon} Extra: {path} — {'ERROR' if has_error else 'OK'}")

        except Exception as e:
            results.append({"path": path, "title": f"Extra: {path}", "status": "exception", "error": str(e)})

    # Phase 3: Click sidebar menu items to discover dynamically-loaded sub-pages
    print("[Bonus] Clicking sidebar menus...")
    page.goto(f"{FRONTEND_URL}", wait_until="networkidle", timeout=20000)
    time.sleep(1)

    # Find all sidebar menu links
    sidebar_items = page.locator(".el-menu .el-sub-menu__title, .el-menu .el-menu-item").all()
    for i, item in enumerate(sidebar_items):
        try:
            if item.is_visible(timeout=2000):
                text = item.inner_text().strip()
                item.click()
                time.sleep(0.5)
                page.wait_for_load_state("networkidle", timeout=10000)
                time.sleep(0.5)

                safe_name = f"sidebar_{i+1:03d}_{text}".replace(" ", "_").replace("/", "_")
                ss_path = os.path.join(SCREENSHOT_DIR, f"{safe_name}.png")
                page.screenshot(path=ss_path, full_page=True)
                print(f"  📸 Sidebar click: {text}")
        except Exception:
            pass

    # Final: also expand all sub-menus
    page.goto(f"{FRONTEND_URL}", wait_until="networkidle", timeout=20000)
    time.sleep(1)
    sub_menus = page.locator(".el-sub-menu__title").all()
    for sm in sub_menus:
        try:
            if sm.is_visible(timeout=2000):
                sm.click()
                time.sleep(0.3)
        except Exception:
            pass
    time.sleep(1)
    page.screenshot(path=os.path.join(SCREENSHOT_DIR, "999_sidebar_expanded.png"), full_page=True)

    page.close()
    context.close()
    browser.close()
    pw.stop()

    return results


def main():
    ensure_dirs()
    print("=" * 60)
    print("BFS Crawl: All Pages of gaisoft-ui")
    print("=" * 60)

    # Step 1: Get auth token
    print("\n[Step 1] Getting auth token...")
    token = login_and_get_token()
    print(f"  Token: {token[:20]}...")

    # Step 2: Get menu tree
    print("\n[Step 2] Getting dynamic menu tree...")
    menu_tree = get_menu_tree(token)
    print(f"  Menu tree root items: {len(menu_tree)}")

    # Save raw menu tree
    with open(os.path.join(REPORT_DIR, "menu_tree.json"), "w", encoding="utf-8") as f:
        json.dump(menu_tree, f, ensure_ascii=False, indent=2)

    # Step 3: Flatten to page list
    pages = flatten_menu_tree(menu_tree)
    print(f"  Flattened pages: {len(pages)}")
    print("\n  Pages found:")
    for p in pages:
        print(f"    - [{p['title']}] {p['path']}")

    # Save page list
    with open(os.path.join(REPORT_DIR, "page_list.json"), "w", encoding="utf-8") as f:
        json.dump(pages, f, ensure_ascii=False, indent=2)

    # Step 4: Crawl each page
    print(f"\n[Step 3] Crawling {len(pages)} menu pages + {len(EXTRA_ROUTES)} extra routes...")
    results = crawl_pages(token, pages)

    # Step 5: Summary
    ok = sum(1 for r in results if r.get("status") == "ok")
    err = sum(1 for r in results if r.get("status") == "error")
    exc = sum(1 for r in results if r.get("status") == "exception")
    skip = sum(1 for r in results if r.get("status") == "skipped")

    print("\n" + "=" * 60)
    print(f"CRAWL RESULTS: {ok} ok, {err} error, {exc} exception, {skip} skipped")
    print(f"Screenshots saved to: {SCREENSHOT_DIR}")
    print("=" * 60)

    # Save results
    report = {
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S"),
        "total": len(results),
        "ok": ok,
        "error": err,
        "exception": exc,
        "skipped": skip,
        "results": results,
    }
    with open(os.path.join(REPORT_DIR, "crawl_report.json"), "w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print(f"Report saved to: {os.path.join(REPORT_DIR, 'crawl_report.json')}")
    return report


if __name__ == "__main__":
    main()
