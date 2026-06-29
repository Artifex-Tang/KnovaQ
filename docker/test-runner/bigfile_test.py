#!/usr/bin/env python3
"""Large-file upload + parse test against ragflow /api/v1/datasets."""
import os, time, requests, sys

KEY = os.environ["RAGFLOW_API_KEY"]
BASE = os.environ.get("RAGFLOW_BASE", "http://ragflow-server")
DS = os.environ.get("DS", "87d50ea873b211f1bdbc4a9997523c67")
H = {"Authorization": "Bearer " + KEY}

# ~1KB text unit (varied so chunks are non-trivial)
UNIT = ("装备技术问答测试。第%d条：本段用于验证大文件上传与naive切块解析。"
        "涉及导弹武器/电子对抗/雷达系统等领域知识，内容应被切分为多个语义块。"
        "重复填充以构造目标体积，检测ragflow对大体积文档的处理能力与稳定性。\n") % 0
# make unit ~1KB
UNIT = (UNIT * 8)

sizes = [("1M", 1), ("10M", 10), ("50M", 50), ("100M", 100)]
doc_ids = {}

print(f"=== upload (dataset {DS}, limit nginx 1024M) ===")
for name, mb in sizes:
    target = mb * 1024 * 1024
    # vary text per doc so chunks differ
    rep = target // len(UNIT.encode("utf-8")) + 1
    content = (UNIT * rep)[:target].encode("utf-8")
    t0 = time.time()
    try:
        r = requests.post(f"{BASE}/api/v1/datasets/{DS}/documents",
                          headers=H, files={"file": (f"big_{name}.txt", content)}, timeout=900)
        dt = time.time() - t0
        d = r.json()
        data = d.get("data")
        did = (data[0]["id"] if isinstance(data, list) else data.get("id")) if data else None
        rate = (len(content) / 1e6) / dt if dt else 0
        print(f"[{name}] {len(content)/1e6:6.1f}MB  upload={dt:6.1f}s ({rate:5.1f}MB/s)  code={d.get('code')}  msg={str(d.get('message'))[:60]}  docid={did}")
        if did:
            doc_ids[name] = did
    except Exception as e:
        print(f"[{name}] EXCEPTION: {e}")

ids = list(doc_ids.values())
if not ids:
    print("nothing uploaded; abort"); sys.exit(1)

print("\n=== trigger parse ===")
pr = requests.post(f"{BASE}/api/v1/datasets/{DS}/chunks", headers=H,
                   json={"document_ids": ids}, timeout=60)
print("parse resp code:", pr.json().get("code"))

print("\n=== wait for parse (max ~15min) ===")
docs = []
t0 = time.time()
while time.time() - t0 < 900:
    r = requests.get(f"{BASE}/api/v1/datasets/{DS}/documents?page_size=50",
                     headers=H, timeout=30)
    docs = r.json().get("data", {}).get("docs", [])
    running = [d for d in docs if d.get("run") in ("RUNNING", "UNSTART")]
    if not running and docs:
        break
    time.sleep(8)

print(f"parse wait: {time.time()-t0:.0f}s")
print("\n=== result ===")
for d in docs:
    sz = d.get("size", 0)
    print(f"  {d.get('name'):16s} run={str(d.get('run')):8s} chunks={d.get('chunk_count'):5d} size={sz/1e6:6.1f}MB")
