# -*- coding: utf-8 -*-
"""Supplement missing screenshots: Q&A dialog, search results, system submenus."""
import os, sys, time, json, urllib.request
sys.stdout.reconfigure(encoding='utf-8')

FRONTEND_URL = 'http://localhost:8899'
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'screenshots')
os.makedirs(OUTPUT_DIR, exist_ok=True)

from playwright.sync_api import sync_playwright

def shot(page, name, desc=''):
    page.screenshot(path=os.path.join(OUTPUT_DIR, f'{name}.png'), full_page=False)
    sz = os.path.getsize(os.path.join(OUTPUT_DIR, f'{name}.png')) // 1024
    print(f'  {name}.png ({sz}KB) - {desc}')

def js_click_menu(page, text):
    return page.evaluate(f'() => {{'
        f'const items = document.querySelectorAll(".el-menu-item");'
        f'for (const item of items) {{'
        f'  if (item.textContent.trim().includes("{text}")) {{ item.click(); return true; }}'
        f'}}'
        f'return false;'
        f'}}')

def js_expand_submenu(page, text):
    return page.evaluate(f'() => {{'
        f'const titles = document.querySelectorAll(".el-submenu__title");'
        f'for (const t of titles) {{'
        f'  if (t.textContent.includes("{text}")) {{ t.click(); return true; }}'
        f'}}'
        f'return false;'
        f'}}')

def js_click_button(page, text):
    return page.evaluate(f'() => {{'
        f'const btns = document.querySelectorAll("button, .el-button, [role=\\"button\\"], a");'
        f'for (const b of btns) {{'
        f'  const t = b.textContent.trim();'
        f'  if (t === "{text}" || t.includes("{text}")) {{ b.click(); return true; }}'
        f'}}'
        f'return false;'
        f'}}')

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    ctx = browser.new_context(viewport={'width':1440,'height':900}, device_scale_factor=2)
    page = ctx.new_page()

    # Login
    print('Login...')
    page.goto(FRONTEND_URL, wait_until='networkidle', timeout=30000)
    login_data = json.dumps({'username':'admin','password':'admin123'}).encode()
    req = urllib.request.Request(
        f'{FRONTEND_URL}/prod-api/login',
        data=login_data,
        headers={'Content-Type':'application/json'}
    )
    resp = urllib.request.urlopen(req, timeout=10)
    token = json.loads(resp.read()).get('token', '')

    page.evaluate(f'() => {{'
        f'localStorage.setItem("Admin-Token", "{token}");'
        f'localStorage.setItem("token", "{token}");'
        f'}}')
    page.evaluate(f'() => {{ window.location.href = "{FRONTEND_URL}/index"; }}')
    try:
        page.wait_for_load_state('networkidle', timeout=15000)
    except Exception:
        pass
    time.sleep(2)
    if '/login' in page.url:
        ctx.add_cookies([{
            'name': 'Admin-Token',
            'value': token,
            'domain': 'localhost',
            'path': '/'
        }])
        page.goto(f'{FRONTEND_URL}/index', wait_until='networkidle', timeout=15000)
        time.sleep(2)
    print(f'URL: {page.url}')

    # === Q&A Dialog Result ===
    print('\n--- Q&A Dialog ---')
    page.locator('.el-menu-item:has-text("智能问答")').first.click()
    try:
        page.wait_for_load_state('networkidle', timeout=10000)
    except Exception:
        pass
    time.sleep(2)

    # Find chat input and send question
    try:
        chat_input = page.locator('textarea, .el-textarea__inner').last
        if chat_input.is_visible(timeout=5000):
            chat_input.fill('DARPA项目的核心技术方向是什么？')
            time.sleep(1)
            shot(page, '33-智能问答-输入问题', 'Input question in chat')
            # Click send button via JS
            page.evaluate('() => {'
                'const btns = document.querySelectorAll("button");'
                'for (const b of btns) {'
                '  const t = b.textContent.trim();'
                '  if (t === "发送" || t === "发 送") { b.click(); return; }'
                '}'
                '}')
            time.sleep(10)
            shot(page, '34-智能问答-对话结果', 'Q&A dialog result with answer')
        else:
            print('  Chat input not visible')
    except Exception as e:
        print(f'  Q&A failed: {type(e).__name__}: {e}')

    # === Search Results ===
    print('\n--- Search Results ---')
    page.locator('.el-menu-item:has-text("知识检索")').first.click()
    try:
        page.wait_for_load_state('networkidle', timeout=10000)
    except Exception:
        pass
    time.sleep(2)

    try:
        search_input = page.locator('input.el-input__inner, input[type="text"]').first
        if search_input.is_visible(timeout=3000):
            search_input.fill('知识库')
            time.sleep(1)
            shot(page, '35-知识检索-输入关键词', 'Search keyword input')
            # Click search via JS
            page.evaluate('() => {'
                'const btns = document.querySelectorAll("button, .el-button");'
                'for (const b of btns) {'
                '  const t = b.textContent.trim();'
                '  if (t === "搜索" || t === "检 索" || t === "查询") { b.click(); return; }'
                '}'
                '}')
            time.sleep(5)
            shot(page, '36-知识检索-检索结果', 'Search results')
    except Exception as e:
        print(f'  Search failed: {type(e).__name__}: {e}')

    # === System Management Submenus ===
    print('\n--- System Submenus ---')
    js_expand_submenu(page, '系统管理')
    time.sleep(2)

    for name, label in [
        ('部门管理', '37-部门管理页'),
        ('字典管理', '38-字典管理页'),
        ('通知公告', '39-通知公告页'),
        ('岗位管理', '40-岗位管理页'),
    ]:
        try:
            js_click_menu(page, name)
            try:
                page.wait_for_load_state('networkidle', timeout=10000)
            except Exception:
                pass
            time.sleep(2)
            shot(page, label, f'{name} page')
        except Exception:
            print(f'  {name} not found')

    # System Monitor submenus
    js_expand_submenu(page, '系统监控')
    time.sleep(2)

    for name, label in [
        ('登录日志', '41-登录日志页'),
        ('定时任务', '42-定时任务页'),
        ('缓存监控', '43-缓存监控页'),
    ]:
        try:
            js_click_menu(page, name)
            try:
                page.wait_for_load_state('networkidle', timeout=10000)
            except Exception:
                pass
            time.sleep(2)
            shot(page, label, f'{name} page')
        except Exception:
            print(f'  {name} not found')

    page.close()
    browser.close()

print('\nSupplement screenshots done!')
