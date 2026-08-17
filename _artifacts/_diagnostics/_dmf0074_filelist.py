#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0074 이관 패키지 _FILELIST.md 생성 (파일 실측 — 손작성 금지)."""
import hashlib
import io
import pathlib
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
PKG = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0074_CLOUD_20260818")

rows, total = [], 0
for f in sorted(PKG.rglob("*")):
    if not f.is_file() or f.name.startswith("_FILELIST"):
        continue
    b = f.read_bytes()
    total += len(b)
    lines = len(b.splitlines()) if f.suffix in (".sql", ".md", ".ts", ".tsx", ".scss", ".json") else "-"
    rows.append((f.relative_to(PKG).as_posix(), len(b), lines,
                 hashlib.sha256(b).hexdigest()[:12]))

out = ["# DMF0074_CLOUD_20260818 — 파일 목록 (실측)", "",
       f"총 **{len(rows)} 파일 / {total:,} bytes**. 해시는 sha256 앞 12자.", "",
       "| # | 경로 | bytes | lines | sha256 |", "|---:|---|---:|---:|---|"]
for i, (p, b, l, h) in enumerate(rows, 1):
    out.append(f"| {i} | `{p}` | {b:,} | {l} | `{h}` |")
out += ["", "## 구성 요약", "",
        f"- `A_DB` : {sum(1 for p, *_ in rows if p.startswith('A_DB'))} 파일 (GTT DDL · PKG SPEC/BODY · 메타 8축 · 검증)",
        f"- `B_FE` : {sum(1 for p, *_ in rows if p.startswith('B_FE'))} 파일 (화면 폴더 전체 + locales 3본)",
        f"- `C_BE` : 0 파일 (BE 이관분 없음 — grep 실측 0건)",
        f"- `_survey` : {sum(1 for p, *_ in rows if p.startswith('_survey'))} 파일 (축 스윕·취합 근거 JSON)"]
(PKG / "_FILELIST.md").write_text("\n".join(out) + "\n", encoding="utf-8")
print(f"_FILELIST.md — {len(rows)} 파일 / {total:,} bytes")
