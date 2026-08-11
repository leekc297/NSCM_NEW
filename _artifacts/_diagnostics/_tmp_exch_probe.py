# -*- coding: utf-8 -*-
"""환율 Modal 3 SP 를 FE 와 동일 경로(HTTP call-proc)로 호출해 실제 반환을 본다."""
import sys
import pathlib
import json

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import ui_http_e2e as m  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


class _R:
    def __getattr__(self, _):
        return lambda *a, **k: None


BASE = "http://localhost:8080"
sess, _ = m.login(BASE, "minyonglee1", _R())

CASES = [
    ("데이터 보유 버전", "R_S_20251126_V002_C", "2026"),
    ("데이터 보유 버전(연도 2025)", "R_S_20251126_V002_C", "2025"),
    ("사용자가 쓴 빈 버전", "REPORT_SP_W_20260310_V003_R01", "2026"),
]

for label, ver, year in CASES:
    print("=" * 70)
    print("[%s] versionNo=%s year=%s" % (label, ver, year))
    base_body = {"divisionId": "40", "year": year, "versionNo": ver,
                 "sesUserId": "minyonglee1", "userId": "minyonglee1", "mnuId": "DMF0044"}
    for btn in ("SEARCH", "SEARCH_DATA", "TITLE"):
        r = sess.post("%s/DMF0044/exchangeRate/%s/call-proc" % (BASE, btn), json=base_body, timeout=300)
        if r.status_code != 200:
            print("  %-12s HTTP %s  %s" % (btn, r.status_code, r.text[:160]))
            continue
        res = (r.json() or {}).get("result") or {}
        keys = list(res.keys()) if isinstance(res, dict) else type(res).__name__
        rows = res.get("data") if isinstance(res, dict) else None
        n = len(rows) if isinstance(rows, list) else None
        print("  %-12s HTTP 200  keys=%s  data=%s행" % (btn, keys, n))
        if isinstance(rows, list) and rows:
            print("      샘플: %s" % json.dumps(rows[0], ensure_ascii=False)[:220])
        elif isinstance(res, dict):
            for k, v in res.items():
                if isinstance(v, list) and v:
                    print("      %s[0]: %s" % (k, json.dumps(v[0], ensure_ascii=False)[:220]))
