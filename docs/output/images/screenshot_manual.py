"""
DARPA智能问答服务工具 — 用户手册截图脚本（完整流程版）

用法：
    # 关验证码
    docker exec ragflow-mysql mysql -uroot -pinfini_rag_flow \
      -e "UPDATE equipment_iqas.sys_config SET config_value='false' WHERE config_key='sys.account.captchaEnabled';"
    # 跑截图
    python docs/output/images/screenshot_manual.py
    # 恢复验证码
    docker exec ragflow-mysql mysql -uroot -pinfini_rag_flow \
      -e "UPDATE equipment_iqas.sys_config SET config_value='true' WHERE config_key='sys.account.captchaEnabled';"

截图输出到 docs/output/images/screenshots/ 目录，约25张完整流程截图。
"""

import os
import sys
import time
import json
import urllib.request

sys.stdout.reconfigure(encoding='utf-8')

FRONTEND_URL = os.environ.get('FRONTEND_URL', 'http://localhost:8899')
LOGIN_USER = os.environ.get('GAISOFT_LOGIN_USER', 'admin')
LOGIN_PASS = os.environ.get('GAISOFT_LOGIN_PASS', 'admin123')
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'screenshots')

os.makedirs(OUTPUT_DIR, exist_ok=True)

SHOT_INDEX = 0


def shot(page, name, description=""):
    """截图并打印日志"""
    global SHOT_INDEX
    SHOT_INDEX += 1
    path = os.path.join(OUTPUT_DIR, f'{name}.png')
    page.screenshot(path=path, full_page=False)
    size_kb = os.path.getsize(path) // 1024
    print(f'  [{SHOT_INDEX:02d}] {name}.png ({size_kb}KB) — {description}')
    return path


def js_click_menu(page, menu_text):
    """用JS查找并点击菜单项"""
    return page.evaluate(f'''() => {{
        const items = document.querySelectorAll('.el-menu-item');
        for (const item of items) {{
            const text = item.textContent.trim();
            if (text === "{menu_text}" || text.includes("{menu_text}")) {{
                item.click();
                return true;
            }}
        }}
        return false;
    }}''')


def js_expand_submenu(page, title_text):
    """用JS点击submenu标题展开"""
    return page.evaluate(f'''() => {{
        const titles = document.querySelectorAll('.el-submenu__title');
        for (const t of titles) {{
            if (t.textContent.includes("{title_text}")) {{
                t.click();
                return true;
            }}
        }}
        return false;
    }}''')


def js_click_button(page, button_text):
    """用JS点击按钮（支持 el-button 等）"""
    return page.evaluate(f'''() => {{
        // 优先找 el-button
        const btns = document.querySelectorAll('button, .el-button, [role="button"]');
        for (const b of btns) {{
            const text = b.textContent.trim();
            if (text === "{button_text}" || text.includes("{button_text}")) {{
                b.click();
                return true;
            }}
        }}
        // 其次找 a 标签
        const links = document.querySelectorAll('a.el-button');
        for (const a of links) {{
            if (a.textContent.trim().includes("{button_text}")) {{
                a.click();
                return true;
            }}
        }}
        return false;
    }}''')


def js_click_table_row(page, row_index=0):
    """用JS点击表格第N行"""
    return page.evaluate(f'''() => {{
        const rows = document.querySelectorAll('.el-table__body-wrapper tbody tr');
        if (rows.length > {row_index}) {{
            rows[{row_index}].click();
            return true;
        }}
        return false;
    }}''')


def js_fill_input(page, selector, value):
    """用JS填写输入框"""
    page.evaluate(f'''() => {{
        const el = document.querySelector('{selector}');
        if (el) {{
            el.value = '{value}';
            el.dispatchEvent(new Event('input', {{ bubbles: true }}));
            el.dispatchEvent(new Event('change', {{ bubbles: true }}));
        }}
    }}''')


def wait_and_shot(page, menu_or_step, shot_name, description, wait=2):
    """等待networkidle后截图"""
    try:
        page.wait_for_load_state('networkidle', timeout=10000)
    except Exception:
        pass
    time.sleep(wait)
    shot(page, shot_name, description)


def try_js_click_button(page, button_text, shot_name, description, wait=2):
    """尝试点击按钮并截图，失败跳过"""
    print(f'    点击按钮: {button_text}')
    try:
        found = js_click_button(page, button_text)
        if not found:
            print(f'      ✗ 未找到按钮: {button_text}')
            return False
        time.sleep(wait)
        shot(page, shot_name, description)
        return True
    except Exception as e:
        print(f'      ✗ 跳过 {shot_name}: {type(e).__name__}')
        return False


def try_js_click_menu(page, menu_text, shot_name, description, wait=2):
    """JS点击菜单项+截图"""
    print(f'  导航: {menu_text}')
    try:
        found = js_click_menu(page, menu_text)
        if not found:
            print(f'    ✗ 未找到菜单项: {menu_text}')
            return False
        wait_and_shot(page, menu_text, shot_name, description, wait)
        return True
    except Exception as e:
        print(f'    ✗ 跳过 {shot_name}: {type(e).__name__}')
        return False


def close_dialog(page):
    """关闭弹窗"""
    try:
        page.evaluate('''() => {
            const closeBtn = document.querySelector('.el-dialog__headerbtn, .el-drawer__close-btn');
            if (closeBtn) closeBtn.click();
            // 也尝试按 Escape
        }''')
        page.keyboard.press('Escape')
        time.sleep(0.5)
    except Exception:
        pass


def login_via_api(page, context, frontend_url, user, passwd):
    """API登录 + cookie注入"""
    login_data = json.dumps({'username': user, 'password': passwd}).encode()
    req = urllib.request.Request(f'{frontend_url}/prod-api/login',
        data=login_data, headers={'Content-Type': 'application/json'})
    try:
        resp = urllib.request.urlopen(req, timeout=10)
        result = json.loads(resp.read())
        token = result.get('token', '')
        print(f'  API登录: code={result.get("code")}')
    except Exception as e:
        print(f'  API登录失败: {e}')
        token = ''

    if not token:
        return False

    # 注入localStorage
    page.evaluate(f'''() => {{
        localStorage.setItem("Admin-Token", "{token}");
        localStorage.setItem("token", "{token}");
    }}''')
    page.evaluate(f'''() => {{
        window.location.href = "{frontend_url}/index";
    }}''')
    try:
        page.wait_for_load_state('networkidle', timeout=15000)
    except Exception:
        pass
    time.sleep(3)
    print(f'  登录后URL: {page.url}')

    # 如果还在登录页，用cookie方式
    if '/login' in page.url:
        print('  Token注入未生效，尝试cookie方式...')
        context.add_cookies([{
            'name': 'Admin-Token',
            'value': token,
            'domain': 'localhost',
            'path': '/'
        }])
        page.goto(f'{frontend_url}/index', wait_until='networkidle', timeout=15000)
        time.sleep(3)
        print(f'  Cookie方式后URL: {page.url}')

    return '/login' not in page.url


def main():
    from playwright.sync_api import sync_playwright

    print(f'前端地址: {FRONTEND_URL}')
    print(f'截图输出: {OUTPUT_DIR}')
    print()

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            viewport={'width': 1440, 'height': 900},
            device_scale_factor=2,
        )

        # ================================================================
        # Part A: gaisoft-frontend 全流程截图
        # ================================================================
        print('=== A. 应用前端截图（完整流程） ===')
        page = context.new_page()

        # ── 01 登录页 ──
        print('\n── 登录流程 ──')
        page.goto(FRONTEND_URL, wait_until='networkidle', timeout=30000)
        time.sleep(1)
        shot(page, '01-登录页', '系统登录界面')

        # ── 登录 ──
        login_via_api(page, context, FRONTEND_URL, LOGIN_USER, LOGIN_PASS)

        # ── 02 首页 ──
        print('\n── 首页 ──')
        time.sleep(2)
        shot(page, '02-首页主界面', '登录后首页/主界面')

        # ── 03 智能问答 ──
        print('\n── 智能问答流程 ──')
        page.locator('.el-menu-item:has-text("智能问答")').first.click()
        wait_and_shot(page, '智能问答', '03-智能问答页', '智能问答主界面')

        # 在对话框输入问题
        print('    输入问题...')
        try:
            textarea = page.locator('textarea, .el-textarea__inner, input[type="text"]').last
            if textarea.is_visible(timeout=3000):
                textarea.fill('什么是知识库？')
                time.sleep(1)
                shot(page, '04-智能问答-输入问题', '输入问题后的界面')
                # 点击发送
                js_click_button(page, '发 送')
                js_click_button(page, '发送')
                time.sleep(5)  # 等待回答
                shot(page, '05-智能问答-对话结果', '智能问答对话结果')
        except Exception as e:
            print(f'    对话截图跳过: {type(e).__name__}')

        # ── 06 知识检索 ──
        print('\n── 知识检索流程 ──')
        page.locator('.el-menu-item:has-text("知识检索")').first.click()
        wait_and_shot(page, '知识检索', '06-知识检索页', '知识检索界面')

        # 输入检索词
        print('    输入检索关键词...')
        try:
            search_input = page.locator('input[type="text"], .el-input__inner').first
            if search_input.is_visible(timeout=3000):
                search_input.fill('知识库')
                time.sleep(1)
                shot(page, '07-知识检索-输入关键词', '输入检索关键词')
                # 点击搜索按钮
                js_click_button(page, '搜索')
                js_click_button(page, '检 索')
                js_click_button(page, '查询')
                time.sleep(3)
                shot(page, '08-知识检索-检索结果', '知识检索结果列表')
        except Exception as e:
            print(f'    检索结果截图跳过: {type(e).__name__}')

        # ── 展开智能问答助手子菜单 ──
        print('\n── 智能问答助手模块 ──')
        js_expand_submenu(page, '智能问答助手')
        time.sleep(2)

        # ── 09 配置助理 ──
        try_js_click_menu(page, '配置助理', '09-配置助理列表', '配置助理列表页')
        # 尝试点新增/编辑
        try_js_click_button(page, '新增', '10-配置助理-新增弹窗', '新增助理配置弹窗')
        close_dialog(page)

        # ── 11 文件查看 ──
        try_js_click_menu(page, '文件查看', '11-文件查看列表', '知识库文件列表')
        # 尝试点击第一行查看详情
        print('    尝试查看文件详情...')
        try:
            js_click_table_row(page, 0)
            time.sleep(2)
            shot(page, '12-文件查看-文件详情', '文件详情/预览')
        except Exception:
            print(f'      跳过文件详情')

        # ── 13 文件管理 ──
        try_js_click_menu(page, '文件管理', '13-文件管理列表', '文件管理列表页')
        # 上传按钮
        try_js_click_button(page, '上传', '14-文件管理-上传弹窗', '文件上传弹窗')
        try_js_click_button(page, '上传文件', '14-文件管理-上传弹窗', '文件上传弹窗')
        close_dialog(page)
        # 新建文件夹
        try_js_click_button(page, '新建文件夹', '15-文件管理-新建文件夹', '新建文件夹弹窗')
        close_dialog(page)

        # ── 16 文件分类 ──
        try_js_click_menu(page, '文件分类', '16-文件分类管理', '文件分类管理页')
        try_js_click_button(page, '新增', '17-文件分类-新增弹窗', '新增分类弹窗')
        close_dialog(page)

        # ── 18 模型管理 ──
        try_js_click_menu(page, '模型管理', '18-模型管理列表', '模型管理列表页')
        try_js_click_button(page, '设置默认模型', '19-模型管理-设置默认模型', '设置默认模型弹窗')
        close_dialog(page)
        # 试试其他按钮
        try_js_click_button(page, '新增', '20-模型管理-新增模型', '新增模型弹窗')
        close_dialog(page)

        # ── 21 知识库管理 ──
        try_js_click_menu(page, '知识库管理', '21-知识库管理列表', '知识库管理列表页')
        try_js_click_button(page, '新增', '22-知识库管理-新增弹窗', '新增知识库弹窗')
        close_dialog(page)
        # 尝试点击知识库卡片查看配置
        print('    尝试点击知识库配置...')
        try:
            page.evaluate('''() => {
                const configBtns = document.querySelectorAll('.el-button, button, [role="button"]');
                for (const b of configBtns) {
                    if (b.textContent.includes('配置')) {
                        b.click();
                        return true;
                    }
                }
                // 尝试点击第一个卡片
                const cards = document.querySelectorAll('.el-card, .kb-card, .card-item');
                if (cards.length > 0) {
                    cards[0].click();
                    return true;
                }
                return false;
            }''')
            time.sleep(2)
            shot(page, '23-知识库管理-配置页', '知识库配置详情页')
        except Exception:
            print(f'      跳过知识库配置页')

        # ── 展开系统管理子菜单 ──
        print('\n── 系统管理模块 ──')
        js_expand_submenu(page, '系统管理')
        time.sleep(2)

        # ── 24 用户管理 ──
        try_js_click_menu(page, '用户管理', '24-用户管理列表', '系统用户管理列表')
        # 新增用户弹窗
        try_js_click_button(page, '新增', '25-用户管理-新增弹窗', '新增用户弹窗')
        close_dialog(page)

        # ── 26 角色管理 ──
        try_js_click_menu(page, '角色管理', '26-角色管理列表', '角色管理列表页')
        try_js_click_button(page, '新增', '27-角色管理-新增弹窗', '新增角色弹窗')
        close_dialog(page)

        # ── 28 菜单管理 ──
        try_js_click_menu(page, '菜单管理', '28-菜单管理列表', '菜单管理列表页')

        # ── 29 参数设置 ──
        try_js_click_menu(page, '参数设置', '29-参数设置列表', '系统参数配置列表')

        # ── 展开系统监控子菜单（如有） ──
        print('\n── 系统监控模块 ──')
        js_expand_submenu(page, '系统监控')
        time.sleep(2)

        # ── 30 在线用户 ──
        try_js_click_menu(page, '在线用户', '30-在线用户列表', '在线用户监控')

        # ── 31 服务器监控 ──
        try_js_click_menu(page, '服务监控', '31-服务器监控', '服务器状态监控')
        try_js_click_menu(page, '服务器', '31-服务器监控', '服务器状态监控')

        # ── 32 操作日志 ──
        try_js_click_menu(page, '操作日志', '32-操作日志列表', '操作日志列表')

        page.close()
        browser.close()

    # ================================================================
    # 汇总
    # ================================================================
    print(f'\n{"=" * 60}')
    print(f'截图完成！共 {SHOT_INDEX} 张，保存在: {OUTPUT_DIR}')
    print(f'{"=" * 60}')


if __name__ == '__main__':
    main()
