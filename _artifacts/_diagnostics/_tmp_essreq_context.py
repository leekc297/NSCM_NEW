# -*- coding: utf-8 -*-
"""PR_SSP_ANL_ESS_REQ — 분석 JSON 문맥 확인 + GSCM 스캔 커버리지 검증"""
import io
import json
import pathlib
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(r"C:\Projects\NSCM")

# ── 커버리지 검증 ──
SKIP = {"node_modules", ".git", "obj", "bin", "packages", "dist", "build", ".vs"}
cnt = {}
for q in (ROOT / "GSCM").rglob("*"):
    if q.is_file() and not any(p in SKIP for p in q.parts):
        cnt[q.suffix.lower()] = cnt.get(q.suffix.lower(), 0) + 1
top = sorted(cnt.items(), key=lambda x: -x[1])[:12]
print("== GSCM 파일 분포(스킵 제외) ==")
for e, n in top:
    print("  %-10s %d" % (e or "(무확장)", n))

# ── JSON 문맥 ──
for name, lines in (("phase1_db.json", [19909, 25404, 62234, 62249, 62287]),
                    ("phase3_ssp.json", [311])):
    p = ROOT / "_analysis" / "_scan" / name
    if not p.exists():
        continue
    txt = io.open(p, encoding="utf-8", errors="replace").read().splitlines()
    print("\n== %s 문맥 ==" % name)
    for ln in lines:
        lo, hi = max(0, ln - 12), min(len(txt), ln + 12)
        print("  --- L%d 주변 ---" % ln)
        for i in range(lo, hi):
            print("   %6d| %s" % (i + 1, txt[i].rstrip()[:170]))

# ── 다른 SP 본문이 호출하는지: JSON 안의 SP 레코드 전수 훑기 ──
p = ROOT / "_analysis" / "_scan" / "phase1_db.json"
if p.exists():
    try:
        data = json.loads(io.open(p, encoding="utf-8", errors="replace").read())
        print("\n== phase1_db.json 최상위 키 ==")
        print("  ", list(data.keys())[:20] if isinstance(data, dict) else type(data).__name__)
    except Exception as e:  # noqa: BLE001
        print("\nJSON 파싱 실패:", str(e)[:120])
