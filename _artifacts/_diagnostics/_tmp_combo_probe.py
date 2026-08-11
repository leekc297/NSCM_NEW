# -*- coding: utf-8 -*-
"""환율 Modal 셀 콤보(Division / CurrencyList) 바인드 토큰 실측 + HTTP 반환 확인"""
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

print("== SCM_ADM_CMBO_SQL_M 원문 (Division / CurrencyList) ==")
cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS
                WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_ADM_CMBO_SQL_M' ORDER BY COLUMN_ID""")
cols = [r[0] for r in cur.fetchall()]
print("  컬럼:", cols)
idcol = "SQL_ID"
sqlcol = "SQL_DTL_CTN"
cur.execute("SELECT %s, %s FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE %s IN ('Division','CurrencyList','MyDivision')"
            % (idcol, sqlcol, idcol))
for cid, s in cur.fetchall():
    body = s.read() if hasattr(s, "read") else (s or "")
    toks = sorted({t for t in ("@param1", "@param2", "@param3", "@divisionId", "@division_id",
                               "@userId", "@sesUserId") if t in body})
    print("\n  [%s] 바인드 토큰 = %s" % (cid, toks or "없음"))
    print("  " + " ".join(body.split())[:400])
con.close()

print("\n== HTTP /admin/combo 실호출 (FE 동일 경로) ==")


class _R:
    def __getattr__(self, _):
        return lambda *a, **k: None


BASE = "http://localhost:8080"
sess, _ = m.login(BASE, "minyonglee1", _R())
for payload in ({"comboId": "Division"},
                {"comboId": "Division", "divisionId": "'40'"},
                {"comboId": "CurrencyList"},
                {"comboId": "CurrencyList", "divisionId": "'40'"}):
    r = sess.post("%s/admin/combo" % BASE, json=payload, timeout=180)
    n = None
    if r.status_code == 200:
        res = (r.json() or {}).get("result")
        if isinstance(res, list):
            n = len(res[0]) if res and isinstance(res[0], list) else len(res)
        elif isinstance(res, dict):
            n = {k: (len(v) if isinstance(v, list) else v) for k, v in res.items()}
    print("  %-46s HTTP %s  rows=%s" % (json.dumps(payload, ensure_ascii=False), r.status_code, n))
