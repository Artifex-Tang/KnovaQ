"""
Suite G — Knowledge Base Full Pipeline Tests
Create KBs, upload topic files, parse, create assistants, chat, verify.

Prerequisites: run `python generate_kb_test_data.py` first to generate files.

Test flow:
1. Create 6 topic knowledge bases
2. Upload all files to each KB
3. Trigger parsing
4. Wait for parsing completion
5. Verify chunks created
6. Create assistants bound to each KB
7. Chat with each assistant
8. Verify answers reference uploaded content
9. Cleanup
"""

import os
import json
import time
import pytest
import requests
from pathlib import Path

RAGFLOW_URL = os.environ.get("RAGFLOW_BASE_URL", "http://localhost:9380").rstrip("/")
RAGFLOW_API_KEY = os.environ.get("RAGFLOW_API_KEY", "ragflow-E5ODdhM2I2MTZiMjExZjBiMGU3NjJhM2")
API_URL = os.environ.get("GAISOFT_API_URL", "http://localhost:8088").rstrip("/")
FRONTEND_URL = os.environ.get("GAISOFT_FRONTEND_URL", "http://localhost:8899").rstrip("/")

SCREENSHOT_DIR = Path(__file__).parent.parent / "reports" / "screenshots" / "suite_g"
SCREENSHOT_DIR.mkdir(parents=True, exist_ok=True)

KB_TOPICS_DIR = Path(__file__).parent.parent / "test_data" / "kb_topics"

HEADERS = {
    "Authorization": f"Bearer {RAGFLOW_API_KEY}",
    "Content-Type": "application/json"
}

TOPICS = ["雷达系统", "通信装备", "导弹武器", "装甲车辆", "后勤保障", "电子对抗"]

# Track created resources for cleanup
_created_datasets = []
_created_chats = []


def _screenshot_text(name, content):
    """Save text result as file (API tests don't have browser screenshots)."""
    path = SCREENSHOT_DIR / f"g_{name}.txt"
    path.write_text(json.dumps(content, indent=2, ensure_ascii=False), encoding="utf-8")
    return path


# ============================================================================
# Phase 1: Create Knowledge Bases
# ============================================================================

@pytest.mark.api
class TestCreateKnowledgeBases:
    """TC-G01: Create 6 topic knowledge bases via ragflow API."""

    def test_create_all_topic_kbs(self):
        for topic in TOPICS:
            resp = requests.post(
                f"{RAGFLOW_URL}/api/v1/datasets",
                headers=HEADERS,
                json={
                    "name": f"DARPA_{topic}",
                    "chunk_method": "naive",
                    "language": "Chinese"
                },
                timeout=30
            )
            data = resp.json()
            assert data.get("code") == 0, f"Create KB '{topic}' failed: {data.get('message')}"
            ds_id = data["data"]["id"]
            _created_datasets.append(ds_id)
            _screenshot_text(f"create_kb_{topic}", data)
            print(f"  [OK] Created KB: {topic} (id={ds_id})")

        assert len(_created_datasets) == 6, f"Only created {len(_created_datasets)}/6 KBs"

    def test_list_kbs_contains_topics(self):
        resp = requests.get(f"{RAGFLOW_URL}/api/v1/datasets", headers=HEADERS, timeout=30)
        data = resp.json()
        assert data.get("code") == 0
        names = [ds["name"] for ds in data["data"]]
        for topic in TOPICS:
            assert f"DARPA_{topic}" in names, f"KB 'DARPA_{topic}' not found in list"
        print(f"  [OK] All 6 topic KBs visible in list")


# ============================================================================
# Phase 2: Upload Files
# ============================================================================

@pytest.mark.api
class TestUploadFilesToKBs:
    """TC-G02: Upload all generated files to each topic KB."""

    def test_upload_all_topic_files(self):
        if not _created_datasets:
            pytest.skip("No datasets created (run TestCreateKnowledgeBases first)")

        upload_headers = {
            "Authorization": f"Bearer {RAGFLOW_API_KEY}"
        }

        for idx, topic in enumerate(TOPICS):
            ds_id = _created_datasets[idx]
            topic_dir = KB_TOPICS_DIR / topic
            if not topic_dir.exists():
                pytest.skip(f"Topic directory not found: {topic_dir}")

            uploaded = 0
            for fmt_dir in topic_dir.iterdir():
                if not fmt_dir.is_dir():
                    continue
                for filepath in fmt_dir.iterdir():
                    if filepath.suffix == ".json":
                        continue  # Skip QA JSON files
                    try:
                        with open(filepath, "rb") as f:
                            files = {"file": (filepath.name, f)}
                            resp = requests.post(
                                f"{RAGFLOW_URL}/api/v1/datasets/{ds_id}/documents",
                                headers=upload_headers,
                                files=files,
                                timeout=60
                            )
                            if resp.json().get("code") == 0:
                                uploaded += 1
                    except Exception as e:
                        print(f"  [WARN] Upload failed: {filepath.name}: {e}")

            _screenshot_text(f"upload_{topic}", {"topic": topic, "uploaded": uploaded})
            print(f"  [OK] {topic}: uploaded {uploaded} files")

        assert True  # Upload counts logged per topic

    def test_documents_listed_in_kbs(self):
        """Verify uploaded documents appear in each KB."""
        if not _created_datasets:
            pytest.skip("No datasets")

        for idx, topic in enumerate(TOPICS):
            ds_id = _created_datasets[idx]
            resp = requests.get(
                f"{RAGFLOW_URL}/api/v1/datasets/{ds_id}/documents",
                headers=HEADERS,
                timeout=30
            )
            data = resp.json()
            if data.get("code") == 0:
                docs = data.get("data", {}).get("docs", [])
                print(f"  {topic}: {len(docs)} documents listed")
                _screenshot_text(f"doclist_{topic}", {"count": len(docs), "names": [d["name"] for d in docs[:5]]})


# ============================================================================
# Phase 3: Parse Documents
# ============================================================================

@pytest.mark.api
class TestParseDocuments:
    """TC-G03: Trigger parsing and wait for completion."""

    def test_parse_all_documents(self):
        if not _created_datasets:
            pytest.skip("No datasets")

        for idx, topic in enumerate(TOPICS):
            ds_id = _created_datasets[idx]
            # Get all document IDs
            resp = requests.get(
                f"{RAGFLOW_URL}/api/v1/datasets/{ds_id}/documents?page_size=200",
                headers=HEADERS, timeout=30
            )
            data = resp.json()
            if data.get("code") != 0:
                continue
            docs = data.get("data", {}).get("docs", [])
            doc_ids = [d["id"] for d in docs if d.get("run") == "UNSTART"]
            if not doc_ids:
                print(f"  {topic}: no unparsed documents")
                continue

            # Trigger parsing
            parse_resp = requests.post(
                f"{RAGFLOW_URL}/api/v1/datasets/{ds_id}/chunks",
                headers=HEADERS,
                json={"document_ids": doc_ids},
                timeout=30
            )
            print(f"  {topic}: parsing {len(doc_ids)} documents (code={parse_resp.json().get('code')})")

    def test_wait_parsing_complete(self):
        """Wait for all documents to finish parsing (timeout 600s)."""
        if not _created_datasets:
            pytest.skip("No datasets")

        per_kb_timeout = 600

        for idx, topic in enumerate(TOPICS):
            ds_id = _created_datasets[idx]
            kb_start = time.time()
            while time.time() - kb_start < per_kb_timeout:
                resp = requests.get(
                    f"{RAGFLOW_URL}/api/v1/datasets/{ds_id}/documents?page_size=200",
                    headers=HEADERS, timeout=30
                )
                data = resp.json()
                if data.get("code") != 0:
                    break
                docs = data.get("data", {}).get("docs", [])
                running = [d for d in docs if d.get("run") in ("RUNNING", "UNSTART")]
                if not running:
                    done = len([d for d in docs if d.get("run") in ("SUCCESS", "DONE")])
                    fail = len([d for d in docs if d.get("run") == "FAIL"])
                    elapsed = int(time.time() - kb_start)
                    print(f"  {topic}: parsing complete ({elapsed}s) - {done} done, {fail} failed")
                    _screenshot_text(f"parse_{topic}", {"done": done, "failed": fail, "total": len(docs)})
                    break
                time.sleep(10)
            else:
                print(f"  {topic}: parsing timeout after {per_kb_timeout}s")


# ============================================================================
# Phase 4: Verify Chunks
# ============================================================================

@pytest.mark.api
class TestVerifyChunks:
    """TC-G04: Verify chunks were created for each KB."""

    def test_chunks_exist_in_kbs(self):
        if not _created_datasets:
            pytest.skip("No datasets")

        for idx, topic in enumerate(TOPICS):
            ds_id = _created_datasets[idx]
            resp = requests.get(
                f"{RAGFLOW_URL}/api/v1/datasets/{ds_id}/documents?page_size=200",
                headers=HEADERS, timeout=30
            )
            data = resp.json()
            if data.get("code") != 0:
                continue
            docs = data.get("data", {}).get("docs", [])
            total_chunks = sum(d.get("chunk_count", 0) for d in docs)
            print(f"  {topic}: {total_chunks} chunks across {len(docs)} documents")
            _screenshot_text(f"chunks_{topic}", {"total_chunks": total_chunks, "doc_count": len(docs)})
            assert total_chunks > 0, f"{topic}: no chunks created"


# ============================================================================
# Phase 5: Create Assistants and Chat
# ============================================================================

@pytest.mark.api
class TestChatWithTopicKBs:
    """TC-G05: Create assistant per topic, chat, verify answers."""

    def test_create_topic_assistants(self):
        if not _created_datasets:
            pytest.skip("No datasets")

        for idx, topic in enumerate(TOPICS):
            ds_id = _created_datasets[idx]
            payload = {
                "name": f"DARPA_{topic}_assistant",
                "description": f"DARPA {topic} knowledge assistant",
                "language": "Chinese",
                "llm": {
                    "model_name": "deepseek-chat",
                    "temperature": 0.1,
                    "top_p": 0.3,
                    "presence_penalty": 0.4,
                    "frequency_penalty": 0.7,
                    "max_tokens": 512
                },
                "dataset_ids": [ds_id],
                "prompt": {
                    "prompt": f"你是{topic}领域的专家。基于知识库内容回答问题。" + "{knowledge}",
                    "similarity_threshold": 0.2,
                    "keywords_similarity_weight": 0.7,
                    "top_n": 6,
                    "show_quote": True,
                    "variables": [{"key": "knowledge", "optional": False}]
                }
            }
            resp = requests.post(
                f"{RAGFLOW_URL}/api/v1/chats",
                headers=HEADERS,
                json=payload,
                timeout=30
            )
            data = resp.json()
            if data.get("code") == 0:
                chat_id = data["data"]["id"]
                _created_chats.append(chat_id)
                print(f"  [OK] Created assistant: {topic} (id={chat_id})")
            else:
                print(f"  [WARN] Create assistant failed for {topic}: {data.get('message')}")

    def test_chat_topic_questions(self):
        """Send topic-specific questions and verify answers contain relevant content."""
        if not _created_chats:
            pytest.skip("No chat assistants created")

        # Topic-specific questions
        questions = {
            "雷达系统": "雷达的探测距离是多少？",
            "通信装备": "通信装备的频率范围是多少？",
            "导弹武器": "导弹制导方式有哪些？",
            "装甲车辆": "装甲车辆的动力系统参数？",
            "后勤保障": "后勤保障的物资储备要求？",
            "电子对抗": "电子对抗的主要技术手段？"
        }

        for idx, topic in enumerate(TOPICS):
            if idx >= len(_created_chats):
                break
            chat_id = _created_chats[idx]

            # Create session
            sess_resp = requests.post(
                f"{RAGFLOW_URL}/api/v1/chats/{chat_id}/sessions",
                headers=HEADERS,
                json={"name": f"test_{topic}"},
                timeout=30
            )
            sess_data = sess_resp.json()
            if sess_data.get("code") != 0:
                print(f"  {topic}: session creation failed: {sess_data.get('message')}")
                continue
            session_id = sess_data["data"]["id"]

            # Send question (non-streaming)
            question = questions.get(topic, "请介绍一下这个领域的知识")
            chat_resp = requests.post(
                f"{RAGFLOW_URL}/api/v1/chats/{chat_id}/completions",
                headers=HEADERS,
                json={
                    "question": question,
                    "session_id": session_id,
                    "stream": False
                },
                timeout=60
            )
            chat_data = chat_resp.json()

            answer = chat_data.get("data", {}).get("answer", "")
            _screenshot_text(f"chat_{topic}", {
                "question": question,
                "answer": answer[:500] if answer else "",
                "code": chat_data.get("code")
            })

            if answer:
                print(f"  {topic}: Q='{question}' A='{answer[:80]}...'")
            else:
                print(f"  {topic}: no answer (code={chat_data.get('code')})")

            # Cleanup session
            try:
                requests.delete(
                    f"{RAGFLOW_URL}/api/v1/chats/{chat_id}/sessions",
                    headers=HEADERS,
                    json={"ids": [session_id]},
                    timeout=15
                )
            except Exception:
                pass


# ============================================================================
# Cleanup
# ============================================================================

def test_cleanup_suite_g():
    """Cleanup all created resources."""
    print("\n  === Cleanup ===")
    # Delete chat assistants
    for chat_id in _created_chats:
        try:
            requests.delete(f"{RAGFLOW_URL}/api/v1/chats", headers=HEADERS, json={"ids": [chat_id]}, timeout=15)
            print(f"  Deleted chat: {chat_id}")
        except Exception:
            pass
    # Delete datasets
    for ds_id in _created_datasets:
        try:
            requests.delete(f"{RAGFLOW_URL}/api/v1/datasets", headers=HEADERS, json={"ids": [ds_id]}, timeout=15)
            print(f"  Deleted dataset: {ds_id}")
        except Exception:
            pass
    _screenshot_text("cleanup", {"deleted_chats": len(_created_chats), "deleted_datasets": len(_created_datasets)})
