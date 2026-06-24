#!/usr/bin/env python3
"""Aggregate per-suite JUnit XML into a single test report (Markdown + HTML).

Each suite run should emit reports/<suite>.xml via pytest --junitxml. This
script scans reports/*.xml, summarises every test case (pass/fail/skip + time +
failure message), and writes:
    reports/TEST_REPORT.md
    reports/TEST_REPORT.html

Usage:
    python gen_report.py [reports_dir]
"""
import sys
import glob
import html
import os
import xml.etree.ElementTree as ET
from datetime import datetime

REPORTS_DIR = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), "reports")

SUITE_TITLES = {
    "suite_a": "A 功能 (Functional)",
    "suite_b": "B 问题域 (Issues)",
    "suite_c": "C 全覆盖 (Full Coverage)",
    "suite_d": "D 交互 UI (Interactive)",
    "suite_e": "E 业务逻辑 (Business Logic)",
    "suite_f": "F Bug 验证 (Bug Verify)",
    "suite_g": "G KB 管线 (KB Pipeline)",
    "suite_h": "H 切片方式覆盖 (Parser Coverage + E2E QA)",
}


def parse_suite(path):
    """Return (suite_key, [cases], totals) from one junit xml."""
    key = os.path.splitext(os.path.basename(path))[0]
    tree = ET.parse(path)
    root = tree.getroot()
    suites = root.findall(".//testsuite") or ([root] if root.tag == "testsuite" else [])
    cases, npass, nfail, nskip, terr = [], 0, 0, 0, 0
    total_time = 0.0
    for ts in suites:
        for tc in ts.findall("testcase"):
            name = tc.get("name", "")
            t = float(tc.get("time", "0") or 0)
            total_time += t
            failure = tc.find("failure")
            error = tc.find("error")
            skip = tc.find("skipped")
            if failure is not None or error is not None:
                node = failure if failure is not None else error
                status, msg = "FAIL", (node.get("message", "") or "")[:200]
                nfail += 1 if failure is not None else 0
                terr += 1 if error is not None else 0
            elif skip is not None:
                status, msg = "SKIP", (skip.get("message", "") or "")[:120]
                nskip += 1
            else:
                status, msg = "PASS", ""
                npass += 1
            cases.append((name, status, t, msg))
    totals = {"pass": npass, "fail": nfail + terr, "skip": nskip,
              "total": len(cases), "time": total_time}
    return key, cases, totals


def main():
    xmls = sorted(glob.glob(os.path.join(REPORTS_DIR, "*.xml")))
    if not xmls:
        print(f"No junit xml found in {REPORTS_DIR}")
        return 1

    suites = [parse_suite(p) for p in xmls]
    suites.sort(key=lambda s: s[0])

    g = {"pass": 0, "fail": 0, "skip": 0, "total": 0, "time": 0.0}
    for _, _, t in suites:
        for k in g:
            g[k] += t[k]

    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # ---- Markdown ----
    md = [f"# 知枢 · KnovaQ 测试报告\n", f"生成时间：{ts}\n",
          f"\n## 总览\n",
          f"| 指标 | 数值 |", "|---|---|",
          f"| 套件数 | {len(suites)} |",
          f"| 用例总数 | {g['total']} |",
          f"| ✅ 通过 | {g['pass']} |",
          f"| ❌ 失败 | {g['fail']} |",
          f"| ⏭️ 跳过 | {g['skip']} |",
          f"| 总耗时 | {g['time']:.1f}s |",
          f"| 通过率 | {100*g['pass']/max(1,g['total']-g['skip']):.1f}% (不含跳过) |\n"]

    md.append("\n## 各套件汇总\n")
    md.append("| 套件 | 通过 | 失败 | 跳过 | 耗时 |")
    md.append("|---|---|---|---|---|")
    for key, _, t in suites:
        title = SUITE_TITLES.get(key, key)
        md.append(f"| {title} | {t['pass']} | {t['fail']} | {t['skip']} | {t['time']:.1f}s |")

    for key, cases, t in suites:
        title = SUITE_TITLES.get(key, key)
        md.append(f"\n## {title}\n")
        md.append("| 用例 | 结果 | 耗时 | 备注 |")
        md.append("|---|---|---|---|")
        for name, status, ct, msg in cases:
            icon = {"PASS": "✅", "FAIL": "❌", "SKIP": "⏭️"}.get(status, status)
            md.append(f"| {name} | {icon} | {ct:.1f}s | {msg.replace('|', '/')} |")

    md_path = os.path.join(REPORTS_DIR, "TEST_REPORT.md")
    with open(md_path, "w", encoding="utf-8") as f:
        f.write("\n".join(md))

    # ---- HTML ----
    rows = []
    for key, cases, t in suites:
        title = SUITE_TITLES.get(key, key)
        rows.append(f"<h2>{html.escape(title)} "
                    f"<small>✅{t['pass']} ❌{t['fail']} ⏭️{t['skip']} · {t['time']:.1f}s</small></h2>")
        rows.append("<table><tr><th>用例</th><th>结果</th><th>耗时</th><th>备注</th></tr>")
        for name, status, ct, msg in cases:
            cls = {"PASS": "p", "FAIL": "f", "SKIP": "s"}.get(status, "")
            rows.append(f"<tr class='{cls}'><td>{html.escape(name)}</td>"
                        f"<td class='st'>{status}</td><td>{ct:.1f}s</td>"
                        f"<td>{html.escape(msg)}</td></tr>")
        rows.append("</table>")
    passrate = 100 * g['pass'] / max(1, g['total'] - g['skip'])
    html_doc = f"""<!doctype html><html lang=zh><head><meta charset=utf-8>
<title>KnovaQ 测试报告</title><style>
body{{font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;margin:24px;color:#1a1a2e}}
h1{{border-bottom:3px solid #4a4ae0}}h2{{margin-top:28px}}small{{font-weight:400;color:#666;font-size:14px}}
table{{border-collapse:collapse;width:100%;margin:8px 0;font-size:13px}}
th,td{{border:1px solid #ddd;padding:6px 10px;text-align:left}}th{{background:#f0f0f8}}
.summary{{display:flex;gap:16px;flex-wrap:wrap;margin:16px 0}}
.card{{background:#f7f7fc;border-radius:10px;padding:14px 20px;min-width:120px}}
.card .n{{font-size:28px;font-weight:700}}.card.ok .n{{color:#16a34a}}.card.bad .n{{color:#dc2626}}.card.sk .n{{color:#d97706}}
tr.p .st{{color:#16a34a;font-weight:600}}tr.f{{background:#fef2f2}}tr.f .st{{color:#dc2626;font-weight:700}}
tr.s .st{{color:#d97706}}
</style></head><body>
<h1>知枢 · KnovaQ 测试报告</h1><p>生成时间：{ts}</p>
<div class=summary>
<div class='card'><div class=n>{g['total']}</div>用例总数</div>
<div class='card ok'><div class=n>{g['pass']}</div>通过</div>
<div class='card bad'><div class=n>{g['fail']}</div>失败</div>
<div class='card sk'><div class=n>{g['skip']}</div>跳过</div>
<div class='card'><div class=n>{passrate:.0f}%</div>通过率(不含跳过)</div>
<div class='card'><div class=n>{g['time']:.0f}s</div>总耗时</div>
</div>
{''.join(rows)}
</body></html>"""
    html_path = os.path.join(REPORTS_DIR, "TEST_REPORT.html")
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html_doc)

    print(f"Report written:\n  {md_path}\n  {html_path}")
    print(f"TOTAL: {g['pass']} passed, {g['fail']} failed, {g['skip']} skipped "
          f"({passrate:.1f}% pass excl skip)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
