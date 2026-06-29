#!/usr/bin/env python3
"""12-KB ingest v2: each KB = ONE chunk_method + ONE topic.
Formats per method = FULL ragflow spec (only pptx skipped — lib absent, use PDF).
12 methods, topics cycle over 6. ~25 docs/KB cycling method's formats. glm-em3.
"""
import os, sys, time, csv, json as _json, io
sys.path.insert(0, "/tests/tests")
sys.path.insert(0, "/tests")

import test_suite_h_parser_coverage as h
from test_suite_h_parser_coverage import (  # noqa: E402
    GENERATORS, PARSER_PLAN, _create_kb, _upload, _parse, _wait_parse,
    RAGFLOW_URL, HEADERS, _facts_slice,
)
from generate_kb_test_data import TOPICS  # noqa: E402
import requests  # noqa: E402

N_PER_KB = int(os.environ.get("N_PER_KB", "25"))
SINGLE_FMT_N = int(os.environ.get("SINGLE_FMT_N", "25"))   # single-format method: docs/format
MULTI_FMT_N = int(os.environ.get("MULTI_FMT_N", "12"))      # multi-format method: docs/format
ATTACH = os.environ.get("ATTACH_ASSISTANT", "692d3e0e739811f1b88e4a9997523c67")
TS = int(time.time())
TOPIC_LIST = list(TOPICS.keys())


def _facts_text(seq, n=8):
    if not h.FACTS:
        return "(empty)"
    start = (seq * n) % len(h.FACTS)
    pairs = [h.FACTS[(start + i) % len(h.FACTS)] for i in range(min(n, len(h.FACTS)))]
    return "\n".join(f"Q:{q}\nA:{a}" for q, a, _ in pairs)


# ---- extra generators for formats suite_h lacks ----
def gen_prose_csv(seq):
    buf = io.StringIO()
    w = csv.writer(buf)
    w.writerow(["question", "answer"])
    if h.FACTS:
        start = (seq * 6) % len(h.FACTS)
        for i in range(min(6, len(h.FACTS))):
            q, a, _ = h.FACTS[(start + i) % len(h.FACTS)]
            w.writerow([q, a])
    return f"doc_{seq:03d}.csv", buf.getvalue().encode("utf-8")


def gen_prose_json(seq):
    start = (seq * 6) % len(h.FACTS) if h.FACTS else 0
    items = []
    if h.FACTS:
        for i in range(min(6, len(h.FACTS))):
            q, a, kw = h.FACTS[(start + i) % len(h.FACTS)]
            items.append({"question": q, "answer": a, "keywords": kw})
    return f"doc_{seq:03d}.json", _json.dumps(items, ensure_ascii=False, indent=2).encode("utf-8")


def gen_prose_html(seq):
    body = "".join(f"<p>{_facts_text(seq)}</p>".replace("\n", "<br/>"))
    html = f"<html><body><h1>doc{seq}</h1>{body}</body></html>"
    return f"doc_{seq:03d}.html", html.encode("utf-8")


def gen_prose_xlsx(seq):
    from openpyxl import Workbook
    wb = Workbook(); ws = wb.active
    ws.append(["question", "answer"])
    if h.FACTS:
        start = (seq * 6) % len(h.FACTS)
        for i in range(min(6, len(h.FACTS))):
            q, a, _ = h.FACTS[(start + i) % len(h.FACTS)]
            ws.append([q, a])
    buf = io.BytesIO(); wb.save(buf)
    return f"doc_{seq:03d}.xlsx", buf.getvalue()


def gen_picture_jpg(seq):
    from PIL import Image, ImageDraw, ImageFont
    img = Image.new("RGB", (900, 500), "white"); d = ImageDraw.Draw(img)
    font = None
    for fp in ("/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc",
               "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"):
        try:
            font = ImageFont.truetype(fp, 22); break
        except Exception:
            continue
    y = 20
    if h.FACTS:
        start = (seq * 4) % len(h.FACTS)
        for i in range(min(4, len(h.FACTS))):
            q, a, _ = h.FACTS[(start + i) % len(h.FACTS)]
            d.text((20, y), q, fill="black", font=font); y += 50
            d.text((20, y), a, fill="black", font=font); y += 70
    buf = io.BytesIO(); img.save(buf, format="JPEG")
    return f"pic_{seq:03d}.jpg", buf.getvalue()


GEN = dict(GENERATORS)
GEN.update({"prose_csv": gen_prose_csv, "prose_json": gen_prose_json,
            "prose_html": gen_prose_html, "prose_xlsx": gen_prose_xlsx,
            "picture_jpg": gen_picture_jpg})


def gen_prose_pdf(seq):
    """PDF with embedded WenQuanYi TTF so ragflow DeepDOC extracts clean Chinese.
    Overrides suite_h version: reportlab CID font (STSong-Light) extracts as
    U+FFFD garbage, which made PDF chunks unreadable for retrieval/LLM."""
    from reportlab.lib.pagesizes import A4
    from reportlab.pdfgen import canvas
    from reportlab.pdfbase import pdfmetrics
    from reportlab.pdfbase.ttfonts import TTFont
    try:
        pdfmetrics.registerFont(TTFont('WQY', '/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc', subfontIndex=0))
        font = 'WQY'
    except Exception:
        font = 'Helvetica'
    buf = io.BytesIO()
    c = canvas.Canvas(buf, pagesize=A4)
    y = 800
    c.setFont(font, 14)
    c.drawString(50, y, f"军事装备技术论文 No.{seq + 1}")
    y -= 30
    c.setFont(font, 11)
    for q, a, _ in _facts_slice(seq):
        for seg in (f"问题：{q}", f"解答：{a}", ""):
            c.drawString(50, y, seg[:60])
            y -= 18
            if y < 60:
                c.showPage(); c.setFont(font, 11); y = 800
    c.showPage(); c.save()
    return f"doc_{seq:03d}.pdf", buf.getvalue()


GEN["prose_pdf"] = gen_prose_pdf  # override garbled CID version with clean TTF

# chunk_method -> FULL supported format set per ragflow spec (generatable subset)
METHOD_FORMATS = {
    "naive":        ["prose_txt", "prose_pdf", "prose_docx", "prose_xlsx", "prose_csv",
                     "prose_json", "prose_html", "picture_png", "email_eml"],
    "book":         ["prose_docx", "prose_pdf", "prose_txt"],
    "laws":         ["prose_docx", "prose_pdf", "law_txt"],
    "manual":       ["prose_pdf"],
    "paper":        ["prose_pdf"],
    "presentation": ["prose_pdf"],  # pptx lib absent -> PDF (spec allows)
    "one":          ["prose_txt"],
    "qa":           ["qa_xlsx"],
    "table":        ["table_xlsx", "prose_csv", "prose_txt"],
    "tag":          ["tag_xlsx"],
    "picture":      ["picture_png", "picture_jpg"],
    "email":        ["email_eml"],
}

print(f"=== 12-KB ingest v2 (FULL formats): 1 KB per (chunk_method+topic), "
      f"~{N_PER_KB} docs/KB cycling method's formats ===", flush=True)
for m, fmts in METHOD_FORMATS.items():
    print(f"  {m:13s}: {fmts}", flush=True)

created = []
t_start = time.time()
for mi, (method, _, _) in enumerate(PARSER_PLAN, 1):
    topic = TOPIC_LIST[(mi - 1) % len(TOPIC_LIST)]
    tinfo = TOPICS[topic]
    h.FACTS = [(p["question"], p["answer"], p.get("keywords", []))
               for p in tinfo.get("qa_pairs", [])]
    if not h.FACTS:
        print(f"[{mi}/12] {method}/{topic}: no qa_pairs, skip", flush=True); continue
    formats = METHOD_FORMATS[method]
    n_per_fmt = SINGLE_FMT_N if len(formats) == 1 else MULTI_FMT_N
    ds_id = _create_kb(f"ingest_{topic}_{method}_{TS}", method)
    ids = []
    seq = 0
    for fmt in formats:
        for _ in range(n_per_fmt):
            try:
                fn, content = GEN[fmt](seq)
                did = _upload(ds_id, fn, content)
                if did:
                    ids.append(did)
            except Exception as e:
                print(f"    {topic}/{method}/{fmt} seq{seq} fail: {e}", flush=True)
            seq += 1
    print(f"    [{method}] {len(formats)} fmt x {n_per_fmt} = {len(ids)} docs", flush=True)
    _parse(ds_id, ids)
    done, fail, chunks, docs = _wait_parse(ds_id, timeout=1200)
    print(f"[{mi}/12] {topic}/{method:13s} kb={ds_id} docs={len(ids)} "
          f"done={done} fail={fail} chunks={chunks} ({time.time()-t_start:.0f}s)", flush=True)
    created.append((method, topic, ds_id))

with open("/tmp/ingest_kbs.txt", "w", encoding="utf-8") as f:
    for m, t, d in created:
        f.write(f"{m}\t{t}\t{d}\n")

print(f"\n=== attach {len(created)} KBs to assistant {ATTACH} ===", flush=True)
ds_ids = [d for _, _, d in created]
r = requests.put(f"{RAGFLOW_URL}/api/v1/chats/{ATTACH}", headers=HEADERS,
                 json={"dataset_ids": ds_ids}, timeout=60)
print("attach:", r.json().get("code"), str(r.json().get("message"))[:80], flush=True)

print("\n=== SUMMARY ===", flush=True)
total = 0
for m, t, d in created:
    try:
        r = requests.get(f"{RAGFLOW_URL}/api/v1/datasets?page=1&page_size=200",
                         headers=HEADERS, timeout=30)
        cc = 0
        for ds in r.json().get("data", []):
            if ds.get("id") == d:
                cc = ds.get("chunk_count", 0); break
    except Exception:
        cc = -1
    total += cc
    print(f"  {m:13s}/{t} {d} chunks={cc}", flush=True)
print(f"TOTAL: {len(created)} KBs, {total} chunks, {time.time()-t_start:.0f}s", flush=True)
print("DONE", flush=True)
