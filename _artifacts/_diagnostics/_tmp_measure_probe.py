# -*- coding: utf-8 -*-
"""DMF0044 measure 시트(P_DMF0044_GET_MEASURE) 실제 반환 확인 — Insert 행수 결정 원천"""
import sys
import pathlib
import json

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402
import ui_http_e2e as m  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
print("== measure 시트 배선 ==")
cur.execute("""SELECT B.MNU_BTN_CD, A.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B
                JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID=B.API_ID
               WHERE B.MNU_ID='DMF0044' AND B.SHT_NM='measure'""")
for r in cur.fetchall():
    print("  ", r)
print("\n== SP 인자 ==")
cur.execute("""SELECT ARGUMENT_NAME, POSITION, IN_OUT FROM ALL_ARGUMENTS
                WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0044'
                  AND OBJECT_NAME='P_DMF0044_GET_MEASURE' ORDER BY POSITION""")
for r in cur.fetchall():
    print("  %-20s %s %s" % r)
con.close()


class _R:
    def __getattr__(self, _):
        return lambda *a, **k: None


BASE = "http://localhost:8080"
sess, _ = m.login(BASE, "minyonglee1", _R())
for dt in ("2",):
    body = {"divisionId": "40", "mdfType": "REPORT_SP_W", "dataType": dt,
            "userId": "minyonglee1", "mnuId": "DMF0044", "sesUserId": "minyonglee1"}
    r = sess.post("%s/DMF0044/measure/SEARCH/call-proc" % BASE, json=body, timeout=300)
    print("\n== measure SEARCH (dataType=%s) HTTP %s ==" % (dt, r.status_code))
    if r.status_code != 200:
        print(r.text[:300])
        continue
    res = (r.json() or {}).get("result") or {}
    rows = res.get("data") or []
    print("   행수 =", len(rows))
    for x in rows:
        print("     ", json.dumps(x, ensure_ascii=False)[:160])
