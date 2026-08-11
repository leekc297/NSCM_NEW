# -*- coding: utf-8 -*-
"""AS-IS 소스에서 특정 SP 사용처 전수 검색 (다중 패턴 — anti-simplification 준수)

⚠ 단일 정규식 금지. AS-IS 는 SP 를 여러 경로로 호출한다:
  ① `.cs` 의 `FoxDataRequest("DM.XXX")` 직접 호출
  ② `.foxml` / `.xml` 쿼리 정의 파일 (QueryID → SP 매핑)
  ③ BIZ/WSL 레이어의 문자열 상수·변수
  ④ 접두사 변형(스키마·모듈 prefix 유무, 대소문자)
  ⑤ Designer.resx 등 리소스에 박힌 QueryID
⇒ 토큰을 여러 형태로 만들어 **확장자 무관 전 파일**을 훑는다.
"""
import io
import pathlib
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

TARGET = sys.argv[1] if len(sys.argv) > 1 else "PR_SSP_ANL_ESS_REQ"
ROOT = pathlib.Path(r"C:\Projects\NSCM")

# 검색 변형 (대소문자 무시)
core = TARGET.upper()
variants = {core}
if core.startswith("PR_"):
    variants.add(core[3:])          # 접두사 제거형
variants.add(core.replace("_", ""))  # 언더스코어 제거형(드묾)

SKIP_DIR = {"node_modules", ".git", "obj", "bin", "packages", "dist", "build", ".vs"}
TEXT_EXT = {".cs", ".xml", ".foxml", ".resx", ".config", ".sql", ".txt", ".json",
            ".vb", ".aspx", ".ascx", ".asax", ".cshtml", ".js", ".ts", ".csproj", ".xaml"}

scan_roots = [ROOT / "GSCM"]
extra = [ROOT / "_artifacts" / "_asis_program_dump", ROOT / "_analysis"]
scan_roots += [q for q in extra if q.exists()]

hits = {}
files_scanned = 0
for base in scan_roots:
    if not base.exists():
        continue
    for q in base.rglob("*"):
        if not q.is_file():
            continue
        if any(part in SKIP_DIR for part in q.parts):
            continue
        if q.suffix.lower() not in TEXT_EXT:
            continue
        try:
            txt = io.open(q, encoding="utf-8", errors="replace").read()
        except Exception:  # noqa: BLE001
            continue
        files_scanned += 1
        up = txt.upper()
        if not any(v in up for v in variants):
            continue
        rel = str(q.relative_to(ROOT))
        for i, line in enumerate(txt.splitlines(), 1):
            lu = line.upper()
            if any(v in lu for v in variants):
                hits.setdefault(rel, []).append((i, line.strip()[:180]))

print("검색 토큰: %s  (변형 %s)" % (TARGET, sorted(variants)))
print("스캔 파일 %d개 / 적중 파일 %d개\n" % (files_scanned, len(hits)))
if not hits:
    print("⛔ AS-IS 소스에서 사용처 0건")
for rel in sorted(hits):
    print("=== %s ===" % rel)
    for ln, s in hits[rel]:
        print("  L%-6d %s" % (ln, s))
    print()
