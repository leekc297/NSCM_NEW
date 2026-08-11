# -*- coding: utf-8 -*-
"""Version Delete 를 두 번 호출해 1회차/2회차 원장 변화를 실측한다.

사용자 신고: "처음에는 '성공적으로 저장되었습니다' 나오지만 삭제되지 않고,
             한번 더 Delete 하면 삭제된다."
"""
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


TARGET = "R_S_20260810_V003_C"      # 내 테스트 잔여분
DIV = "40"
LED = ("DM_PLN_SALES_PLAN_REPORT_C", "DM_PLN_SALES_ETC_REPORT_C",
       "DM_PLN_SALES_REPORT_EXCHANGE_C", "DM_PLN_BP_FCST_REPORT_C")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def snap(tag):
    cur.execute("""SELECT SEND_YN, VERSION_DESCRIPTION FROM SCM_MGR.DM_MDF_VERSION
                    WHERE DIVISION_ID=:d AND VERSION_NO=:v""", {"d": DIV, "v": TARGET})
    r = cur.fetchone()
    parts = ["SEND_YN=%s" % (r[0] if r else "<헤더없음>")]
    for t in LED:
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.%s WHERE DIVISION_ID=:d AND VERSION_NO=:v" % t,
                    {"d": DIV, "v": TARGET})
        parts.append("%s=%d" % (t.replace("DM_PLN_", "").replace("_REPORT_C", "").replace("_C", ""), cur.fetchone()[0]))
    print("  [%s] %s" % (tag, "  ".join(parts)))


BASE = "http://localhost:8080"
sess, _ = m.login(BASE, "minyonglee1", _R())
print("대상:", TARGET)
snap("BEFORE")

for i in (1, 2):
    cur.execute("SELECT SYSDATE FROM DUAL")
    t0 = cur.fetchone()[0]
    st = time.time()
    r = sess.post(BASE + "/DMF0044/unitedVersion/ACTION/call-proc", json={
        "divisionId": DIV, "versionNo": TARGET, "versionDescription": "",
        "resultDate": "", "actionType": "D", "mvPlanYyyymm": "", "updateYn": "N"}, timeout=900)
    print("\n== DELETE %d회차 == HTTP %s (%.1fs)" % (i, r.status_code, time.time() - st))
    print("   body:", r.text[:200])
    snap("AFTER %d" % i)
    cur.execute("""SELECT SUBSTR(EXCT_MSG_CTN,1,250) FROM SCM_MGR.SCM_COM_SYS_LOG
                    WHERE MNU_ID='DMF0044' AND CREATION_DATE > :t0 AND EXCT_MSG_CTN IS NOT NULL
                    ORDER BY CREATION_DATE DESC FETCH FIRST 1 ROWS ONLY""", {"t0": t0})
    e = cur.fetchone()
    if e:
        body = e[0].read() if hasattr(e[0], "read") else e[0]
        print("   SYS_LOG:", (body or "").replace("\n", " ")[:220])

print("\n== 목록 SP 가 이 버전을 돌려주는가 (SEND_YN<>'D' 필터) ==")
for tag in ("현재",):
    r = sess.post(BASE + "/DMF0044/unitedVersion/SEARCH/call-proc", json={
        "divisionId": DIV, "sdt": "20260101", "edt": "20261231", "versionType": "REPORT_SP_W",
        "description": "", "userId": "minyonglee1", "mnuId": "DMF0044"}, timeout=300)
    rows = ((r.json() or {}).get("result") or {}).get("data") or []
    hit = [x for x in rows if x.get("VERSION_NO") == TARGET]
    print("  목록 %d행 중 대상 포함 = %s" % (len(rows), bool(hit)))
con.close()
