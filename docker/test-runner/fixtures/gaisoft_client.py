"""Gaisoft-mes API client for E2E tests.

Handles login, session management, chat CRUD, and ragflow proxy calls.
"""

import json
import time

import requests


class GaisoftClient:
    """Wraps gaisoft-mes REST API endpoints."""

    def __init__(self, base_url: str, username: str = "", password: str = ""):
        self.base_url = base_url.rstrip("/")
        self.session = requests.Session()
        self.username = username
        self.password = password
        self.token = ""
        self._login()

    def _login(self):
        """Authenticate with gaisoft-mes and store Bearer token."""
        resp = self.session.post(
            f"{self.base_url}/login",
            json={
                "username": self.username,
                "password": self.password,
            },
        )
        resp.raise_for_status()
        data = resp.json()
        token = data.get("token", "")
        if not token:
            raise RuntimeError(f"Gaisoft login failed: {data}")
        self.token = token
        self.session.headers["Authorization"] = f"Bearer {token}"

    # ── KB Session ──────────────────────────────────────────

    def list_kb_sessions(self, params: dict = None) -> dict:
        resp = self.session.get(
            f"{self.base_url}/aftersales/session/list", params=params
        )
        resp.raise_for_status()
        return resp.json()

    def create_kb_session(self, payload: dict) -> dict:
        resp = self.session.post(
            f"{self.base_url}/aftersales/session", json=payload
        )
        resp.raise_for_status()
        return resp.json()

    def get_kb_session(self, session_id: int) -> dict:
        resp = self.session.get(
            f"{self.base_url}/aftersales/session/{session_id}"
        )
        resp.raise_for_status()
        return resp.json()

    def delete_kb_sessions(self, ids: str) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/aftersales/session/{ids}"
        )
        resp.raise_for_status()
        return resp.json()

    # ── KB Chat ─────────────────────────────────────────────

    def list_kb_chats(self, params: dict = None) -> dict:
        resp = self.session.get(
            f"{self.base_url}/aftersales/chat/list", params=params
        )
        resp.raise_for_status()
        return resp.json()

    def add_kb_chats(self, payload: list) -> dict:
        resp = self.session.post(
            f"{self.base_url}/aftersales/chat", json=payload
        )
        resp.raise_for_status()
        return resp.json()

    def get_kb_chat(self, chat_id: int) -> dict:
        resp = self.session.get(
            f"{self.base_url}/aftersales/chat/{chat_id}"
        )
        resp.raise_for_status()
        return resp.json()

    def delete_kb_chats(self, ids: str) -> dict:
        resp = self.session.delete(
            f"{self.base_url}/aftersales/chat/{ids}"
        )
        resp.raise_for_status()
        return resp.json()

    # ── Stream Proxy ────────────────────────────────────────

    def stream_proxy(self, url: str, params: dict, timeout: int = 60) -> list:
        """Call /proxy/stream, collect SSE chunks."""
        payload = {"url": url, **params}
        resp = self.session.post(
            f"{self.base_url}/proxy/stream",
            json=payload,
            headers={"Accept": "text/event-stream"},
            stream=True,
            timeout=timeout,
        )
        resp.raise_for_status()
        chunks = []
        for line in resp.iter_lines():
            if line:
                decoded = line.decode("utf-8") if isinstance(line, bytes) else line
                chunks.append(decoded)
        return chunks

    # ── Ragflow Common Proxy ────────────────────────────────

    def ragflow_common(self, url: str, method: str = "get", params: str = "") -> dict:
        """Call /ragflow/common — generic ragflow proxy."""
        payload = {"url": url, "method": method, "params": params}
        resp = self.session.post(
            f"{self.base_url}/ragflow/common", json=payload
        )
        resp.raise_for_status()
        return resp.json()

    # ── Auth Info ───────────────────────────────────────────

    def get_info(self) -> dict:
        resp = self.session.get(f"{self.base_url}/getInfo")
        resp.raise_for_status()
        return resp.json()

    def get_routers(self) -> dict:
        resp = self.session.get(f"{self.base_url}/getRouters")
        resp.raise_for_status()
        return resp.json()
