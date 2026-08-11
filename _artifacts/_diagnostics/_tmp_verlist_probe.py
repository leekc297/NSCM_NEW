# -*- coding: utf-8 -*-
"""버전 팝업 목록을 FE 와 동일 경로로 호출해 복사본이 나오는지 확인"""
import sys
import pathlib

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
    ("모달 기본기간(당월-1 ~ +5개월)", "20260710", "20270110", "REPORT_SP_W"),
    ("넓게(2026 전체)", "20260101", "20261231", "REPORT_SP_W"),
    ("Type=SP_W(원본계열)", "20260710", "20270110", "SP_W"),
]
for label, sdt, edt, vtype in CASES:
    body = {"divisionId": "40", "sdt": sdt, "edt": edt, "versionType": vtype,
            "description": "", "userId": "minyonglee1", "mnuId": "DMF0044"}
    r = sess.post("%s/DMF0044/unitedVersion/SEARCH/call-proc" % BASE, json=body, timeout=300)
    print("== %s [%s~%s type=%s] HTTP %s" % (label, sdt, edt, vtype, r.status_code))
    if r.status_code != 200:
        print("   ", r.text[:200])
        continue
    rows = ((r.json() or {}).get("result") or {}).get("data") or []
    print("   행수 =", len(rows))
    for x in rows[:6]:
        print("     %-24s %-14s send=%s edit=%s created=%s"
              % (x.get("VERSION_NO"), str(x.get("VERSION_DESCRIPTION"))[:14],
                 x.get("SEND_YN"), x.get("EDIT_YN"), str(x.get("CREATION_DATE"))[:19]))
    hit = [x for x in rows if str(x.get("VERSION_NO", "")).startswith("R_S_20260810")]
    print("   오늘 생성분 포함 =", [x.get("VERSION_NO") for x in hit] or "없음")
