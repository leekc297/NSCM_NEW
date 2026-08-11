#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_e2e.py — Transfer 전/후 실측 (FE 와 동일한 HTTP 경로)

⚠ SEND_YN 원복 정책 (실측 근거):
   대상 두 버전 모두 **이미 SEND_YN='Y'** 이다 (DM_MDF_VERSION 실측).
   SP L6754 는 `SET SEND_YN = CASE WHEN P_ACTION_TYPE='T' THEN 'Y' ELSE 'C' END` —
   즉 'T' 는 Y→Y 로 **무변화(멱등)**, 반대로 'C' 를 태우면 Y→'C' 로 **오히려 값이 바뀐다**.
   따라서 여기서는 'C' 를 태우지 않는다. 'C' 실행이야말로 원장 훼손이 된다.
   원복 증명은 SEND_YN + 하위 4표 행수의 전/후 동일성으로 한다(T 는 delete-then-insert 멱등).
"""
import argparse
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
from ui_http_e2e import login  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

BASE = "http://localhost:8080"
DIV = "40"


class Rep:
    def ok(self, t):
        print("  [ok] %s" % t)

    def fail(self, t):
        print("  [FAIL] %s" % t)


SNAP = [
    ("DM_MDF_VERSION.SEND_YN",
     "SELECT MAX(SEND_YN) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v"),
    ("PLAN_REPORT_C DATA_TYPE=2",
     "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v AND DATA_TYPE='2'"),
    ("PLAN_REPORT_C 전체",
     "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v"),
    ("ETC_REPORT_C 전체",
     "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v"),
    ("DM_MOBILE_REPORT_PRODUCT",
     "SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT WHERE DIVISION_ID=:d AND VERSION_NO=:v"),
    ("DM_MOBILE_REPORT_DEPT",
     "SELECT COUNT(*) FROM SCM_MGR.DM_MOBILE_REPORT_DEPT WHERE DIVISION_ID=:d AND VERSION_NO=:v"),
    ("PLAN_REPORT_C QTY 합",
     "SELECT NVL(ROUND(SUM(QTY),3),0) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID=:d AND VERSION_NO=:v"),
]


def snapshot(cur, ver):
    out = {}
    for label, sql in SNAP:
        cur.execute(sql, {"d": DIV, "v": ver})
        out[label] = cur.fetchone()[0]
    return out


def show_snap(title, s):
    print("\n--- %s ---" % title)
    for k, v in s.items():
        print("  %-28s %s" % (k, v))


def sql_stats(cur, tag):
    print("\n--- V$SQL (PKG_DMF0044, %s) ---" % tag)
    cur.execute("""SELECT s.PROGRAM_LINE#, s.SQL_ID, s.EXECUTIONS,
                          ROUND(s.ELAPSED_TIME/1e6,1),
                          ROUND(s.ELAPSED_TIME/1e6/GREATEST(s.EXECUTIONS,1),2),
                          s.BUFFER_GETS, s.ROWS_PROCESSED,
                          TO_CHAR(s.LAST_ACTIVE_TIME,'HH24:MI:SS')
                     FROM V$SQL s JOIN ALL_OBJECTS o ON o.OBJECT_ID=s.PROGRAM_ID
                    WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
                      AND s.LAST_ACTIVE_TIME > SYSDATE - 20/1440
                    ORDER BY s.ELAPSED_TIME DESC FETCH FIRST 10 ROWS ONLY""")
    print("  SRC_LINE | SQL_ID        | EXEC | ELAPSED_S | PER_EXEC | BUFFER_GETS | ROWS | LAST")
    for r in cur.fetchall():
        print("  %8s | %-13s | %4s | %9s | %8s | %11s | %4s | %s" % r)


def pushed_pred(cur, tag):
    print("\n--- VIEW PUSHED PREDICATE 잔존 확인 (%s) ---" % tag)
    cur.execute("""SELECT p.SQL_ID, p.OPERATION||' '||NVL(p.OPTIONS,'') AS OP, p.OBJECT_NAME
                     FROM V$SQL_PLAN p JOIN V$SQL s ON s.SQL_ID=p.SQL_ID AND s.CHILD_NUMBER=p.CHILD_NUMBER
                     JOIN ALL_OBJECTS o ON o.OBJECT_ID=s.PROGRAM_ID
                    WHERE o.OWNER='SCM_MGR' AND o.OBJECT_NAME='PKG_DMF0044'
                      AND p.OPTIONS = 'PUSHED PREDICATE'
                      AND s.LAST_ACTIVE_TIME > SYSDATE - 20/1440""")
    rows = cur.fetchall()
    if not rows:
        print("  없음 ✅")
    for r in rows:
        print("  ", r)


def main():
    import oracledb
    import requests  # noqa: F401

    ap = argparse.ArgumentParser()
    ap.add_argument("--version", default="R_S_20260128_V002_C")
    a = ap.parse_args()
    ver = a.version

    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()

    before = snapshot(cur, ver)
    show_snap("BEFORE (%s)" % ver, before)
    if before["DM_MDF_VERSION.SEND_YN"] != "Y":
        sys.exit("[중단] SEND_YN=%s — 'Y' 전제(무변화 멱등)가 깨짐. 원복 경로 재설계 필요."
                 % before["DM_MDF_VERSION.SEND_YN"])

    rep = Rep()
    sess, info = login(BASE, "minyonglee1", rep)
    if not sess:
        sys.exit("[중단] 로그인 실패")

    body = {"divisionId": DIV, "versionNo": ver, "versionType": "REPORT_SP_W", "actionType": "T"}
    print("\n>>> POST /DMF0044/unitedVersion/TRANSFER/call-proc  %s" % body)
    t0 = time.time()
    r = sess.post("%s/DMF0044/unitedVersion/TRANSFER/call-proc" % BASE, json=body, timeout=7200)
    el = time.time() - t0
    print("<<< HTTP %s  —  왕복 %.1f초" % (r.status_code, el))
    print("    body: %s" % r.text[:600])

    after = snapshot(cur, ver)
    show_snap("AFTER", after)

    print("\n--- 원장 불변 검증 (T 는 delete-then-insert 멱등) ---")
    drift = 0
    for k in before:
        same = before[k] == after[k]
        drift += 0 if same else 1
        print("  %-28s %s → %s   %s" % (k, before[k], after[k], "동일 ✅" if same else "⚠ 변동"))
    print("  변동 항목 = %d 건 %s" % (drift, "(잔존 0 증명)" if drift == 0 else ""))

    sql_stats(cur, "실행 직후")
    pushed_pred(cur, "실행 직후")
    con.close()
    return 0 if r.status_code == 200 else 1


if __name__ == "__main__":
    sys.exit(main())
