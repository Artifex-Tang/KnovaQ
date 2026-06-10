"""Ragflow API client for test suites.

Wraps ragflow 0.18.0 REST API with API Key auth.
Used by test_suite_b_issues.py for direct ragflow operations.
"""

import json
import time
import os
import requests


class RagflowClient:
    """Lightweight ragflow API client."""

    def __init__(self, base_url: str, api_key: str = ""):
        self.base_url = base_url.rstrip("/")
        self.api_key = api_key
        self.session = requests.Session()
        if api_key:
            self.session.headers["Authorization"] = f"Bearer {api_key}"

    def _url(self, path: str) -> str:
        return f"{self.base_url}{path}"

    def _get(self, path: str, **kwargs) -> dict:
        kwargs.setdefault("timeout", 60)
        resp = self.session.get(self._url(path), **kwargs)
        resp.raise_for_status()
        return resp.json()

    def _post(self, path: str, **kwargs) -> dict:
        kwargs.setdefault("timeout", 60)
        resp = self.session.post(self._url(path), **kwargs)
        resp.raise_for_status()
        return resp.json()

    def _delete(self, path: str, **kwargs) -> dict:
        kwargs.setdefault("timeout", 60)
        resp = self.session.delete(self._url(path), **kwargs)
        resp.raise_for_status()
        return resp.json()

    # ── Health ──────────────────────────────────────────────────

    def wait_healthy(self, timeout: int = 120, interval: int = 5) -> bool:
        deadline = time.time() + timeout
        while time.time() < deadline:
            try:
                resp = self.session.get(self._url("/"), timeout=10)
                if resp.status_code == 200:
                    return True
            except Exception:
                pass
            time.sleep(interval)
        return False

    # ── Dataset ─────────────────────────────────────────────────

    def create_dataset(self, name: str, **kwargs) -> dict:
        body = {"name": name, **kwargs}
        result = self._post("/api/v1/datasets", json=body)
        return result.get("data", result)

    def list_datasets(self, page: int = 1, page_size: int = 100) -> dict:
        return self._get(f"/api/v1/datasets?page={page}&page_size={page_size}")

    def delete_dataset(self, dataset_id: str) -> dict:
        return self._delete("/api/v1/datasets", json={"ids": [dataset_id]})

    # ── Document ────────────────────────────────────────────────

    def upload_document(self, dataset_id: str, file_path: str) -> dict:
        with open(file_path, "rb") as f:
            fname = os.path.basename(file_path)
            resp = self.session.post(
                self._url(f"/api/v1/datasets/{dataset_id}/documents"),
                files={"file": (fname, f)},
                timeout=120,
            )
        resp.raise_for_status()
        result = resp.json()
        data = result.get("data", result)
        if isinstance(data, list) and len(data) > 0:
            return data[0]
        return data

    def upload_documents(self, dataset_id: str, file_paths: list) -> list:
        docs = []
        for fp in file_paths:
            doc = self.upload_document(dataset_id, fp)
            docs.append(doc)
        return docs

    def get_document(self, dataset_id: str, doc_id: str) -> dict:
        result = self._get(f"/api/v1/datasets/{dataset_id}/documents?ids={doc_id}")
        data = result.get("data", {})
        if isinstance(data, dict):
            docs = data.get("docs", [])
            if docs:
                return docs[0]
        elif isinstance(data, list):
            for d in data:
                if isinstance(d, dict) and d.get("id") == doc_id:
                    return d
        return data

    def list_documents(self, dataset_id: str) -> dict:
        return self._get(f"/api/v1/datasets/{dataset_id}/documents?page=1&page_size=100")

    def parse_documents(self, dataset_id: str, doc_ids: list) -> dict:
        return self._post(
            f"/api/v1/datasets/{dataset_id}/chunks",
            json={"document_ids": doc_ids},
        )

    def wait_for_parsing(self, dataset_id: str, timeout: int = 180, interval: int = 5) -> bool:
        deadline = time.time() + timeout
        while time.time() < deadline:
            try:
                result = self.list_documents(dataset_id)
                data = result.get("data", {})
                if isinstance(data, dict):
                    docs = data.get("docs", data.get("doc_ids", []))
                elif isinstance(data, list):
                    docs = data
                else:
                    docs = []

                if not docs:
                    time.sleep(interval)
                    continue

                all_done = True
                for doc in docs:
                    if not isinstance(doc, dict):
                        continue
                    status = doc.get("run", doc.get("progress", -1))
                    if status not in ("DONE", "FAIL", 3, 4):
                        all_done = False
                        break
                if all_done:
                    return True
            except Exception:
                pass
            time.sleep(interval)
        return False

    # ── Chat / Assistant ────────────────────────────────────────

    def create_chat(self, name: str, dataset_ids: list = None, **kwargs) -> dict:
        body = {"name": name}
        if dataset_ids:
            body["dataset_ids"] = dataset_ids
        body.update(kwargs)
        result = self._post("/api/v1/chats", json=body)
        return result.get("data", result)

    def update_chat(self, chat_id: str, **kwargs) -> dict:
        resp = self.session.put(
            self._url(f"/api/v1/chats/{chat_id}"),
            json=kwargs,
            timeout=60,
        )
        resp.raise_for_status()
        return resp.json()

    def delete_chat(self, chat_id: str) -> dict:
        return self._delete("/api/v1/chats", json={"ids": [chat_id]})

    def list_chats(self, page: int = 1, page_size: int = 100) -> dict:
        return self._get(f"/api/v1/chats?page={page}&page_size={page_size}")

    # ── Session ─────────────────────────────────────────────────

    def create_session(self, chat_id: str, name: str = "") -> dict:
        body = {}
        if name:
            body["name"] = name
        result = self._post(f"/api/v1/chats/{chat_id}/sessions", json=body)
        return result.get("data", result)

    def delete_session(self, chat_id: str, session_ids: list) -> dict:
        return self._delete(
            f"/api/v1/chats/{chat_id}/sessions",
            json={"ids": session_ids},
        )

    def list_sessions(self, chat_id: str) -> dict:
        return self._get(f"/api/v1/chats/{chat_id}/sessions?page=1&page_size=100")

    # ── Chat Completion ─────────────────────────────────────────

    def chat_completion(self, chat_id: str, question: str, session_id: str,
                        stream: bool = False) -> dict:
        if stream:
            return self._chat_stream(chat_id, question, session_id)

        result = self._post(
            f"/api/v1/chats/{chat_id}/completions",
            json={
                "question": question,
                "session_id": session_id,
                "stream": False,
            },
            timeout=120,
        )
        return result.get("data", result)

    def _chat_stream(self, chat_id: str, question: str, session_id: str) -> dict:
        resp = self.session.post(
            self._url(f"/api/v1/chats/{chat_id}/completions"),
            json={
                "question": question,
                "session_id": session_id,
                "stream": True,
            },
            headers={"Accept": "text/event-stream"},
            stream=True,
            timeout=120,
        )
        resp.raise_for_status()
        chunks = []
        for line in resp.iter_lines():
            if line:
                decoded = line.decode("utf-8") if isinstance(line, bytes) else line
                chunks.append(decoded)
        return {"chunks": chunks, "answer": self._extract_answer(chunks)}

    @staticmethod
    def _extract_answer(chunks: list) -> str:
        answer_parts = []
        for chunk in chunks:
            if chunk.startswith("data:"):
                data_str = chunk[5:].strip()
                if data_str == "[DONE]":
                    break
                try:
                    data = json.loads(data_str)
                    if isinstance(data, dict):
                        ans = data.get("answer", "")
                        if ans:
                            answer_parts.append(ans)
                except json.JSONDecodeError:
                    pass
        return "".join(answer_parts)

    # ── Retrieval ───────────────────────────────────────────────

    def retrieval(self, question: str, dataset_ids: list = None,
                  page: int = 1, page_size: int = 10) -> dict:
        body = {
            "question": question,
            "page": page,
            "page_size": page_size,
        }
        if dataset_ids:
            body["dataset_ids"] = dataset_ids
        result = self._post("/api/v1/retrieval", json=body)
        return result.get("data", result)
