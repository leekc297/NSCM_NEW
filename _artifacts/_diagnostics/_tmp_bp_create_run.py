# -*- coding: utf-8 -*-
"""BP CREATE 재실측 (DYNSAMP + DYNSAMP2 적용 후) — 종료 후 즉시 정리"""
import sys
import pathlib
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402
import ui_http_e2e as m  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


class _R:
    def __getattr__(self, _):
        return lambda *a, **k: None


LED = ("DM_PLN_SALES_PLAN_REPORT_C", "DM_PLN_SALES_ETC_REPORT_C",
       "DM_PLN_BP_FCST_REPORT_C", "DM_PLN_SALES_REPORT_EXCHANGE_C")
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYSDATE FROM DUAL")
t0 = cur.fetchone()[0]
BASE = "http://localhost:8080"
sess, _ = m.login(BASE, "minyonglee1", _R())
st = time.time()
r = sess.post(BASE + "/DMF0044/unitedVersion/ACTION/call-proc", json={
    "divisionId": "40", "versionNo": "BP_M_20260810_V001", "versionDescription": "BP_CR_TEST2",
    "resultDate": "", "actionType": "CR", "mvPlanYyyymm": "", "updateYn": "N"}, timeout=3600)
el = time.time() - st
print("BP CREATE HTTP %s (%.1fs = %.1f분)" % (r.status_code, el, el / 60))
print(r.text[:200])
cur.execute("SELECT VERSION_NO FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID='40' AND CREATION_DATE > :t0",
            {"t0": t0})
new = [x[0] for x in cur.fetchall()]
print("신규 버전:", new)
for v in new:
    for t in LED:
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.%s WHERE DIVISION_ID='40' AND VERSION_NO=:v" % t, {"v": v})
        print("   %-32s %d" % (t, cur.fetchone()[0]))
if not new:
    cur.execute("""SELECT SUBSTR(EXCT_MSG_CTN,1,280) FROM SCM_MGR.SCM_COM_SYS_LOG WHERE MNU_ID='DMF0044'
        AND CREATION_DATE > :t0 AND EXCT_MSG_CTN IS NOT NULL ORDER BY CREATION_DATE DESC FETCH FIRST 1 ROWS ONLY""",
                {"t0": t0})
    e = cur.fetchone()
    print("오류:", e[0] if e else "(없음)")
# 정리 — 본 런 생성분 DELETE + 헤더 제거 + 잔존 검증
for v in new:
    r2 = sess.post(BASE + "/DMF0044/unitedVersion/ACTION/call-proc", json={
        "divisionId": "40", "versionNo": v, "versionDescription": "", "resultDate": "",
        "actionType": "D", "mvPlanYyyymm": "", "updateYn": "N"}, timeout=1800)
    print("DELETE %s -> %s" % (v, r2.status_code))
    cur.execute("DELETE FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID='40' AND VERSION_NO=:v", {"v": v})
    con.commit()
for t in LED + ("DM_MDF_VERSION",):
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.%s WHERE CREATION_DATE > :t0" % t, {"t0": t0})
    print("잔존 %-32s %d" % (t, cur.fetchone()[0]))
con.close()
