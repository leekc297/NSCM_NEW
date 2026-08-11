#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_copy_retest.py — VERSION COPY 재검증 (d_Result_Date NULL 정정 후, 2026-08-10)

CREATE → COPY(실적 미포함) → COPY(실적 포함) → DELETE(전량 정리) 를 한 번에 돌린다.
COPY 는 REPORT 버전을 원천으로 하므로 CREATE 로 먼저 만든다.

⚠ 안전장치 — 본 런에서 만든 버전만 삭제. DELETE 후 `DM_PLN_SALES_ETC_REPORT_C` 고아행까지 확인/정리
   (SP 의 'D' 분기가 ETC 테이블을 지우지 않는 것을 2026-08-10 실측 — 별도 결함으로 보고).
"""
import sys
import pathlib
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

BASE = "http://localhost:8080"
USER = "minyonglee1"
DIV = "40"
SRC = "SP_W_20260730_V002"
LED = (
    "DM_PLN_SALES_PLAN_REPORT_C",
    "DM_PLN_SALES_ETC_REPORT_C",
    "DM_PLN_SALES_REPORT_EXCHANGE_C",
    "DM_PLN_BP_FCST_REPORT_C",
)


class _R:
    def __getattr__(self, _):
        return lambda *a, **k: None


def main():
    import oracledb
    import ui_http_e2e as m

    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT VERSION_NO FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d", {"d": DIV})
    pre = {r[0] for r in cur.fetchall()}
    sess, _ = m.login(BASE, USER, _R())
    created = []

    def cnt(v):
        o = {}
        for t in LED:
            cur.execute(
                "SELECT COUNT(*) FROM SCM_MGR.%s WHERE DIVISION_ID=:d AND VERSION_NO=:v" % t,
                {"d": DIV, "v": v},
            )
            o[t.replace("DM_PLN_", "").replace("_REPORT_C", "").replace("_C", "")] = cur.fetchone()[0]
        return o

    def call(label, payload):
        cur.execute("SELECT SYSDATE FROM DUAL")
        t0 = cur.fetchone()[0]
        st = time.time()
        try:
            r = sess.post("%s/DMF0044/unitedVersion/ACTION/call-proc" % BASE, json=payload, timeout=2400)
            code = r.status_code
            ok = code == 200 and str((r.json() or {}).get("code")) == "0"
        except Exception as e:  # noqa: BLE001
            code, ok = "EXC", False
            print("  %-28s EXC %s" % (label, e))
        el = time.time() - st
        cur.execute(
            """SELECT SUBSTR(EXCT_MSG_CTN,1,220) FROM SCM_MGR.SCM_COM_SYS_LOG
                WHERE MNU_ID='DMF0044' AND CREATION_DATE > :t0 AND EXCT_MSG_CTN IS NOT NULL
                ORDER BY CREATION_DATE DESC FETCH FIRST 1 ROWS ONLY""",
            {"t0": t0},
        )
        err = cur.fetchone()
        cur.execute(
            """SELECT VERSION_NO FROM SCM_MGR.DM_MDF_VERSION
                WHERE DIVISION_ID=:d AND CREATION_DATE > :t0 ORDER BY CREATION_DATE""",
            {"d": DIV, "t0": t0},
        )
        new = [x[0] for x in cur.fetchall() if x[0] not in pre and x[0] not in created]
        created.extend(new)
        print("  %-28s %-4s %6.1fs  %s" % (label, "PASS" if ok else "FAIL", el,
                                           (("→ %s " % new[0]) + str(cnt(new[0]))) if new else ""))
        if err and not ok:
            print("      ⛔ %s" % err[0].replace("\n", " ")[:210])
        return ok, (new[0] if new else None)

    print("== VERSION COPY 재검증 (d_Result_Date NULL 정정 후) ==")
    ok, base = call("CREATE (원천 %s)" % SRC,
                    {"divisionId": DIV, "versionNo": SRC, "versionDescription": "RETEST_CR",
                     "resultDate": "", "actionType": "CR", "mvPlanYyyymm": "", "updateYn": "N"})
    if base:
        call("COPY 실적 미포함",
             {"divisionId": DIV, "versionNo": base, "versionDescription": "RETEST_CP1",
              "resultDate": "", "actionType": "CP", "mvPlanYyyymm": "", "updateYn": "Y"})
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYYMMDD') FROM DUAL")
        today = cur.fetchone()[0]
        call("COPY 실적 포함(%s)" % today,
             {"divisionId": DIV, "versionNo": base, "versionDescription": "RETEST_CP2",
              "resultDate": today, "actionType": "CP", "mvPlanYyyymm": "", "updateYn": "Y"})

    print("\n== 정리 (DELETE + 고아행 확인) ==")
    for v in list(created):
        call("DELETE %s" % v,
             {"divisionId": DIV, "versionNo": v, "versionDescription": "",
              "resultDate": "", "actionType": "D", "mvPlanYyyymm": "", "updateYn": "N"})
        left = cnt(v)
        if sum(left.values()):
            print("      ⚠ DELETE 후 잔존 %s → 수동 정리" % left)
            for t in LED:
                cur.execute(
                    "DELETE FROM SCM_MGR.%s WHERE DIVISION_ID=:d AND VERSION_NO=:v" % t,
                    {"d": DIV, "v": v},
                )
        cur.execute("DELETE FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
                    {"d": DIV, "v": v})
        con.commit()

    print("\n== 잔존 검증 ==")
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.DM_MDF_VERSION WHERE CREATION_DATE > TRUNC(SYSDATE)")
    print("  DM_MDF_VERSION 오늘생성 = %d" % cur.fetchone()[0])
    for t in LED:
        cur.execute("SELECT COUNT(*) FROM SCM_MGR.%s WHERE CREATION_DATE > TRUNC(SYSDATE)" % t)
        print("  %-32s 오늘생성 = %d" % (t, cur.fetchone()[0]))
    con.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
