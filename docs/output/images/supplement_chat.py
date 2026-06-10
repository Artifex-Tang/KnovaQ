# -*- coding: utf-8 -*-
"""Capture Q&A dialog and search results by navigating to direct routes."""
import os, sys, time, json, urllib.request
sys.stdout.reconfigure(encoding='utf-8')

FRONTEND_URL = 'http://localhost:8899'
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'screenshots')

from playwright.sync_api import sync_playwright

def shot(page, name, desc=''):
    page.screenshot(path=os.path.join(OUTPUT_DIR, f'{name}.png'), full_page=False)
    sz = os.path.getsize(os.path.join(OUTPUT_DIR, f'{name}.png')) // 1024
    print(f'  {name}.png ({sz}KB) - {desc}')

def js_click_button(page, text):
    return page.evaluate(f'() => {{'
        f'const btns = document.querySelectorAll("button, .el-button, [role=\\"button\\"]");'
        f'for (const b of btns) {{'
        f'  if (b.textContent.trim().includes("{text}")) {{ b.click(); return true; }}'
        f'}}'
        f'return false;'
        f'}}')

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    ctx = browser.new_context(viewport={'width':1440,'height':900}, device_scale_factor=2)
    page = ctx.new_page()

    # Login
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
    ctx.add_cookies([{
        'name': 'Admin-Token',
        'value': token,
        'domain': 'localhost',
        'path': '/'
    }])

    # === Navigate directly to chat route ===
    print('--- Q&A via direct route ---')
    page.goto(f'{FRONTEND_URL}/assistant/ops_solutions_chat', timeout=30000)
    time.sleep(5)
    print(f'  URL: {page.url}')
    shot(page, '33-智能问答-对话界面', 'Chat interface via direct route')

    # Find and fill chat input
    try:
        # Try various selectors for the chat input
        selectors = [
            'textarea',
            '.el-textarea__inner',
            'input[type="text"]',
            '.chat-input textarea',
            '.chat-input input',
            '#chat-input',
        ]
        chat_filled = False
        for sel in selectors:
            try:
                el = page.locator(sel).last
                if el.is_visible(timeout=2000):
                    el.fill('DARPA项目的核心技术方向是什么？')
                    chat_filled = True
                    print(f'  Filled via selector: {sel}')
                    break
            except Exception:
                continue

        if not chat_filled:
            # Try JS approach
            result = page.evaluate('''() => {
                const inputs = document.querySelectorAll('textarea, input[type="text"], [contenteditable="true"]');
                for (const inp of inputs) {
                    if (inp.offsetParent !== null) {
                        if (inp.tagName === 'TEXTAREA' || inp.tagName === 'INPUT') {
                            inp.value = 'DARPA项目的核心技术方向是什么？';
                            inp.dispatchEvent(new Event('input', {bubbles:true}));
                            inp.dispatchEvent(new Event('change', {bubbles:true}));
                            return 'filled:' + inp.tagName;
                        }
                    }
                }
                return 'not_found';
            }''')
            print(f'  JS fill result: {result}')

        time.sleep(1)
        shot(page, '34-智能问答-输入问题', 'Question typed in chat')

        # Send via JS
        page.evaluate('''() => {
            const btns = document.querySelectorAll('button, .el-button');
            for (const b of btns) {
                const t = b.textContent.trim();
                if (t === '发送' || t === '发 送' || t.includes('发送') || t === 'Submit') {
                    b.click(); return;
                }
            }
            // Try Enter key on textarea
            const ta = document.querySelector('textarea');
            if (ta) {
                ta.dispatchEvent(new KeyboardEvent('keydown', {key: 'Enter', code: 'Enter', keyCode: 13, bubbles: true}));
            }
        }''')
        time.sleep(12)
        shot(page, '35-智能问答-对话结果', 'Q&A answer result')

    except Exception as e:
        print(f'  Chat interaction failed: {type(e).__name__}: {e}')

    # === Navigate to fault tracing / knowledge search ===
    print('\n--- Knowledge search via direct route ---')
    page.goto(f'{FRONTEND_URL}/customApp/faultTracing', timeout=30000)
    time.sleep(5)
    print(f'  URL: {page.url}')
    shot(page, '36-知识检索-检索界面', 'Knowledge search interface')

    # Try to fill search input
    try:
        search_input = page.locator('input[type="text"], .el-input__inner').first
        if search_input.is_visible(timeout=3000):
            search_input.fill('DARPA')
            time.sleep(1)
            shot(page, '37-知识检索-输入关键词', 'Search keyword')
            # Click send/search
            page.evaluate('''() => {
                const btns = document.querySelectorAll('button, .el-button');
                for (const b of btns) {
                    const t = b.textContent.trim();
                    if (t.includes('搜索') || t.includes('检索') || t.includes('查询') || t.includes('发送')) {
                        b.click(); return;
                    }
                }
            }''')
            time.sleep(5)
            shot(page, '38-知识检索-检索结果', 'Search results')
    except Exception as e:
        print(f'  Search failed: {type(e).__name__}: {e}')

    # === Session history ===
    print('\n--- Session history ---')
    page.goto(f'{FRONTEND_URL}/assistant/assitantSession', timeout=30000)
    time.sleep(3)
    shot(page, '44-会话记录页', 'Chat session history')

    page.close()
    browser.close()

print('\nDone!')
