#!/usr/bin/env python3
"""Generate a set of assistant + user avatars via ZHIPU CogView.
Saves avatar_assistant_{n}.png + avatar_user_{n}.png to /out (mounted host imgs dir)."""
import os, sys, time, requests

KEY = os.environ["ZHIPU_KEY"]
OUT = os.environ.get("OUT", "/out")
N = int(os.environ.get("N_AVATARS", "6"))
URL = "https://open.bigmodel.cn/api/paas/v4/images/generations"
H = {"Authorization": "Bearer " + KEY, "Content-Type": "application/json"}

ASSISTANT_STYLES = [
    "cute friendly robot face, blue gradient background, flat minimalist",
    "AI orb glowing green, dark background, futuristic, flat icon",
    "purple spark AI assistant icon, gradient, minimalist app avatar",
    "teal robot head, clean, modern app icon, centered",
    "orange glowing AI core, minimalist, app avatar",
    "white robot mascot on indigo gradient, friendly, flat design",
]
USER_STYLES = [
    "person silhouette avatar, blue, minimalist flat, centered, no text",
    "smiling user profile icon, green, modern flat avatar",
    "gender-neutral person bust, purple gradient, minimalist",
    "friendly face avatar, teal, flat design, app profile",
    "user icon with headset, orange, flat minimalist",
    "abstract user portrait, indigo, modern app avatar",
]

def gen(prompt, name):
    for attempt in range(3):
        try:
            r = requests.post(URL, headers=H, timeout=120,
                              json={"model": "cogview-4", "prompt": prompt + ", no text, high quality, centered, app avatar, square",
                                    "size": "1024x1024"})
            data = r.json().get("data", [])
            if not data:
                print(f"  {name}: no data, resp={str(r.text)[:120]}", flush=True); time.sleep(3); continue
            img_url = data[0]["url"]            # full signed URL
            img = requests.get(img_url, timeout=120).content
            if len(img) < 1000:
                print(f"  {name}: tiny image {len(img)}B, retry", flush=True); time.sleep(3); continue
            path = f"{OUT}/{name}.png"
            with open(path, "wb") as f:
                f.write(img)
            print(f"  {name}: OK {len(img)}B -> {path}", flush=True)
            return True
        except Exception as e:
            print(f"  {name}: attempt{attempt} err {e}", flush=True); time.sleep(3)
    return False

os.makedirs(OUT, exist_ok=True)
print(f"=== generate {N} assistant + {N} user avatars via CogView ===", flush=True)
ok = 0
for i in range(N):
    p = ASSISTANT_STYLES[i % len(ASSISTANT_STYLES)]
    ok += gen(p, f"avatar_assistant_{i+1}")
    time.sleep(1)
for i in range(N):
    p = USER_STYLES[i % len(USER_STYLES)]
    ok += gen(p, f"avatar_user_{i+1}")
    time.sleep(1)
print(f"DONE: {ok}/{2*N} avatars saved to {OUT}", flush=True)
