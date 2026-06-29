#!/usr/bin/env python3
"""Ingest 12 chunk_method KBs x N docs each (default 25 = 300), persistent.
Reuses suite_h GENERATORS + helpers. Serial per-KB to bound embedding load.
"""
import os, sys, time
sys.path.insert(0, "/tests/tests")
sys.path.insert(0, "/tests")

from test_suite_h_parser_coverage import (  # noqa: E402
    GENERATORS, PARSER_PLAN, _create_kb, _upload, _parse, _wait_parse,
    RAGFLOW_URL, HEADERS,
)
import requests  # noqa: E402

N = int(os.environ.get("INGEST_DOCS_PER_PARSER", "25"))
ATTACH_ASSISTANT = os.environ.get("ATTACH_ASSISTANT", "692d3e0e739811f1b88e4a9997523c67")
TS = int(time.time())

print(f"=== ingest {len(PARSER_PLAN)} chunk_methods x {N} docs = {len(PARSER_PLAN)*N} ===", flush=True)
created = []
for parser_id, gen_kind, qa_targetable in PARSER_PLAN:
    gen = GENERATORS[gen_kind]
    t0 = time.time()
    ds_id = _create_kb(f"ingest_{parser_id}_{TS}", parser_id)
    ids = []
    for seq in range(N):
        fn, content = gen(seq)
        did = _upload(ds_id, fn, content)
        if did:
            ids.append(did)
    _parse(ds_id, ids)
    done, fail, chunks, docs = _wait_parse(ds_id, timeout=1800)
    dt = time.time() - t0
    print(f"[{parser_id:13s}] kb={ds_id} docs={len(ids)} done={done} fail={fail} "
          f"chunks={chunks} ({dt:.0f}s)", flush=True)
    created.append((parser_id, ds_id))

# persist KB list
with open("/tmp/ingest_kbs.txt", "w") as f:
    for p, d in created:
        f.write(f"{p} {d}\n")

print("\n=== attach all KBs to assistant {} ===".format(ATTACH_ASSISTANT), flush=True)
ds_ids = [d for _, d in created]
r = requests.put(f"{RAGFLOW_URL}/api/v1/chats/{ATTACH_ASSISTANT}",
                 headers=HEADERS, json={"dataset_ids": ds_ids}, timeout=30)
print("attach resp:", r.json().get("code"), str(r.json().get("message"))[:80], flush=True)

print("\n=== SUMMARY ===", flush=True)
total_chunks = 0
for p, d in created:
    r = requests.get(f"{RAGFLOW_URL}/api/v1/datasets/{d}", headers=HEADERS, timeout=30)
    info = r.json().get("data", {})
    cc = info.get("chunk_count", 0)
    total_chunks += cc
    print(f"  {p:13s} {d}  chunks={cc}  docs={info.get('document_count')}", flush=True)
print(f"TOTAL chunks across {len(created)} KBs: {total_chunks}", flush=True)
print("DONE", flush=True)
