"""Ragflow 0.18.0 HTTP API client for E2E tests."""

import os
import time
from pathlib import Path

import requests
from requests_toolbelt import MultipartEncoder


class RagflowClient:
    """Wraps ragflow HTTP API v1 endpoints."""

    def __init__(self, base_url: str, api_key: str = ""):
        self.base_url = base_url.rstrip("/")
        self.api_key = api_key
        self.session = requests.Session()
        if api_key:
            self.session.headers["Authorization"] = f"Bearer {api_key}"

    # ── System ──────────────────────────────────────────────

    def health_check(self) -> dict:
        """Check ragflow health. v0.18.0 lacks /healthz, use dataset listing."""
        resp = self.session.get(
            f"{self.base_url}/api/v1/datasets",
            params={"page": 1, "page_size": 1},
        )
        resp.raise_for_status()
        return resp.json()

    def wait_healthy(self, timeout: int = 120, interval: int = 5) -> bool:
        deadline = time.time() + timeout
        while time.time() < deadline:
            try:
                data = self.health_check()
                if data.get("code") == 0:
                    return True
            except Exception:
                pass
            time.sleep(interval)
        return False

    # ── Dataset ─────────────────────────────────────────────

    def create_dataset(self, name: str, **kwargs) -> dict:
        payload = {"name": name, **kwargs}
        resp = self.session.post(
            f"{self.base_url}/api/v1/datasets", json=payload
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def list_datasets(self, page: int = 1, page_size: int = 100) -> list:
        resp = self.session.get(
            f"{self.base_url}/api/v1/datasets",
            params={"page": page, "page_size": page_size},
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def get_dataset(self, dataset_id: str) -> dict:
        resp = self.session.get(
            f"{self.base_url}/api/v1/datasets/{dataset_id}"
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def update_dataset(self, dataset_id: str, **kwargs) -> dict:
        resp = self.session.put(
            f"{self.base_url}/api/v1/datasets/{dataset_id}", json=kwargs
        )
        resp.raise_for_status()
        return resp.json().get("data", resp.json())

    def delete_dataset(self, dataset_id: str) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/api/v1/datasets", json={"ids": [dataset_id]}
        )
        resp.raise_for_status()
        return resp.json()

    def delete_datasets(self, dataset_ids: list) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/api/v1/datasets", json={"ids": dataset_ids}
        )
        resp.raise_for_status()
        return resp.json()

    # ── Document ────────────────────────────────────────────

    def upload_document(self, dataset_id: str, file_path: str) -> dict:
        path = Path(file_path)
        with path.open("rb") as f:
            m = MultipartEncoder(fields={"file": (path.name, f)})
            resp = self.session.post(
                f"{self.base_url}/api/v1/datasets/{dataset_id}/documents",
                headers={"Content-Type": m.content_type},
                data=m,
            )
        resp.raise_for_status()
        data = resp.json()["data"]
        return data[0] if isinstance(data, list) else data

    def upload_documents(self, dataset_id: str, file_paths: list) -> list:
        fields = []
        file_objects = []
        for fp in file_paths:
            p = Path(fp)
            f = p.open("rb")
            fields.append(("file", (p.name, f)))
            file_objects.append(f)
        try:
            m = MultipartEncoder(fields=fields)
            resp = self.session.post(
                f"{self.base_url}/api/v1/datasets/{dataset_id}/documents",
                headers={"Content-Type": m.content_type},
                data=m,
            )
            resp.raise_for_status()
            return resp.json()["data"]
        finally:
            for f in file_objects:
                f.close()

    def list_documents(self, dataset_id: str, page: int = 1, page_size: int = 100) -> dict:
        resp = self.session.get(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/documents",
            params={"page": page, "page_size": page_size},
        )
        resp.raise_for_status()
        data = resp.json().get("data")
        if data is None:
            return {}
        # data may be a dict with "docs" list, or a bare list
        return data

    def get_document(self, dataset_id: str, document_id: str) -> dict:
        resp = self.session.get(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/documents/{document_id}"
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def delete_documents(self, dataset_id: str, document_ids: list) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/documents",
            json={"ids": document_ids},
        )
        resp.raise_for_status()
        return resp.json()

    # ── Parsing ─────────────────────────────────────────────

    def parse_documents(self, dataset_id: str, document_ids: list) -> dict:
        resp = self.session.post(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/chunks",
            json={"document_ids": document_ids},
        )
        resp.raise_for_status()
        return resp.json()

    def stop_parsing(self, dataset_id: str, document_ids: list) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/chunks",
            json={"document_ids": document_ids},
        )
        resp.raise_for_status()
        return resp.json()

    def wait_for_parsing(
        self, dataset_id: str, timeout: int = 300, interval: int = 5
    ) -> bool:
        """Poll until all documents in dataset reach DONE or FAIL."""
        deadline = time.time() + timeout
        while time.time() < deadline:
            data = self.list_documents(dataset_id)
            if data is None:
                time.sleep(interval)
                continue
            # data may be a dict with "docs" key, a dict that IS the doc list, or a list
            if isinstance(data, dict):
                docs = data.get("docs", data.get("doc_ids", []))
                if not isinstance(docs, list):
                    docs = []
            elif isinstance(data, list):
                docs = data
            else:
                docs = []
            if not docs:
                time.sleep(interval)
                continue
            statuses = [
                d.get("run", d.get("progress", -1))
                for d in docs
                if isinstance(d, dict)
            ]
            if all(s in ("DONE", "FAIL", 3, 4) for s in statuses):
                return all(s in ("DONE", 3) for s in statuses)
            time.sleep(interval)
        return False

    # ── Chunk ───────────────────────────────────────────────

    def add_chunk(self, dataset_id: str, document_id: str, content: str, **kwargs) -> dict:
        payload = {"content": content, **kwargs}
        resp = self.session.post(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/documents/{document_id}/chunks",
            json=payload,
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def list_chunks(self, dataset_id: str, document_id: str, page: int = 1, page_size: int = 100) -> dict:
        resp = self.session.get(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/documents/{document_id}/chunks",
            params={"page": page, "page_size": page_size},
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def update_chunk(self, dataset_id: str, document_id: str, chunk_id: str, **kwargs) -> dict:
        resp = self.session.put(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/documents/{document_id}/chunks/{chunk_id}",
            json=kwargs,
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def delete_chunks(self, dataset_id: str, document_id: str, chunk_ids: list) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/documents/{document_id}/chunks",
            json={"ids": chunk_ids},
        )
        resp.raise_for_status()
        return resp.json()

    # ── Retrieval ───────────────────────────────────────────

    def retrieval(self, question: str, dataset_ids: list, **kwargs) -> dict:
        payload = {"question": question, "dataset_ids": dataset_ids, **kwargs}
        resp = self.session.post(
            f"{self.base_url}/api/v1/retrieval", json=payload
        )
        resp.raise_for_status()
        result = resp.json().get("data")
        return result if result is not None else {}

    # ── Chat Assistant ──────────────────────────────────────

    def create_chat(self, name: str, dataset_ids: list = None, **kwargs) -> dict:
        payload = {"name": name}
        if dataset_ids:
            payload["dataset_ids"] = dataset_ids
        payload.update(kwargs)
        resp = self.session.post(
            f"{self.base_url}/api/v1/chats", json=payload
        )
        resp.raise_for_status()
        return resp.json().get("data", resp.json())

    def list_chats(self, page: int = 1, page_size: int = 100) -> list:
        resp = self.session.get(
            f"{self.base_url}/api/v1/chats",
            params={"page": page, "page_size": page_size},
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def get_chat(self, chat_id: str) -> dict:
        resp = self.session.get(
            f"{self.base_url}/api/v1/chats/{chat_id}"
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def update_chat(self, chat_id: str, **kwargs) -> dict:
        resp = self.session.put(
            f"{self.base_url}/api/v1/chats/{chat_id}", json=kwargs
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def delete_chat(self, chat_id: str) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/api/v1/chats", json={"ids": [chat_id]}
        )
        resp.raise_for_status()
        return resp.json()

    # ── Session ─────────────────────────────────────────────

    def create_session(self, chat_id: str, name: str = "") -> dict:
        payload = {}
        if name:
            payload["name"] = name
        resp = self.session.post(
            f"{self.base_url}/api/v1/chats/{chat_id}/sessions", json=payload
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def list_sessions(self, chat_id: str) -> list:
        resp = self.session.get(
            f"{self.base_url}/api/v1/chats/{chat_id}/sessions"
        )
        resp.raise_for_status()
        return resp.json()["data"]

    def delete_session(self, chat_id: str, session_ids: list) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/api/v1/chats/{chat_id}/sessions",
            json={"ids": session_ids},
        )
        resp.raise_for_status()
        return resp.json()

    # ── Conversation ────────────────────────────────────────

    def chat_completion(self, chat_id: str, question: str, session_id: str = "", stream: bool = False, **kwargs) -> dict:
        payload = {"question": question, "stream": stream, **kwargs}
        if session_id:
            payload["session_id"] = session_id
        if stream:
            resp = self.session.post(
                f"{self.base_url}/api/v1/chats/{chat_id}/completions",
                json=payload,
                stream=True,
            )
            chunks = []
            for line in resp.iter_lines():
                if line:
                    decoded = line.decode("utf-8") if isinstance(line, bytes) else line
                    chunks.append(decoded)
            return {"chunks": chunks}
        else:
            resp = self.session.post(
                f"{self.base_url}/api/v1/chats/{chat_id}/completions",
                json=payload,
            )
            resp.raise_for_status()
            return resp.json()["data"]

    # ── OpenAI Compatible ───────────────────────────────────

    def openai_completion(self, chat_id: str, messages: list, stream: bool = False, **kwargs) -> dict:
        payload = {"model": "model", "messages": messages, "stream": stream, **kwargs}
        resp = self.session.post(
            f"{self.base_url}/api/v1/chats_openai/{chat_id}/chat/completions",
            json=payload,
        )
        resp.raise_for_status()
        return resp.json()

    # ── GraphRAG ────────────────────────────────────────────

    def run_graphrag(self, dataset_id: str) -> dict:
        resp = self.session.post(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/run_graphrag"
        )
        resp.raise_for_status()
        return resp.json()

    def trace_graphrag(self, dataset_id: str) -> dict:
        resp = self.session.get(
            f"{self.base_url}/api/v1/datasets/{dataset_id}/trace_graphrag"
        )
        resp.raise_for_status()
        return resp.json()
