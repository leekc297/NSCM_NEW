#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_deploy_rtfgate2_20260818.py — RTFGATE2 + MSG01001 사내 적용 + 배포 검증 (2026-08-18)

룰 #136: 배포 검증은 "대상 객체" 실측으로만 한다 (엉뚱한 객체 상태 출력 금지).
"""
import os
import sys
import time

import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")

BODY = os.path.join(HERE, "PKG_DMF0021_BODY_RTFGATE2_20260818.sql")
MSGF = os.path.join(HERE, "MSG01001_RTF_CUTOFF_20260818.sql")


def connect(retries=10, wait=10):
    import ora

    u, p, d = ora.conn_info()
    last = None
    for _ in range(retries):
        try:
            return oracledb.connect(user=u, password=p, dsn=d)
        except Exception as e:  # noqa: BLE001
            last = e
            time.sleep(wait)
    raise SystemExit(f"접속 실패: {last}")


def main():
    con = connect()
    cur = con.cursor()

    # 1) MSG01001 채번 (MERGE 3문 + COMMIT)
    with open(MSGF, encoding="utf-8") as f:
        msg_sql = f.read()
    stmts = [s.strip() for s in msg_sql.split(";") if s.strip() and not s.strip().startswith("--")]
    for s in stmts:
        body = "\n".join(ln for ln in s.splitlines() if not ln.strip().startswith("--")).strip()
        if not body or body.upper() == "COMMIT":
            continue
        cur.execute(body)
    con.commit()
    print("[1] MSG01001 채번 완료")

    # 2) PKG BODY 재배포 — 라이브 PKG 핀 대비 DDL_LOCK_TIMEOUT
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    with open(BODY, encoding="utf-8") as f:
        ddl = f.read().rstrip()
    if ddl.endswith("/"):
        ddl = ddl[:-1].rstrip()
    try:
        cur.execute(ddl)
        print("[2] PKG_DMF0021 BODY 재배포 실행 완료")
    except Exception as e:  # noqa: BLE001
        print(f"[2] 배포 실패: {e}")
        cur.close()
        con.close()
        raise SystemExit(1)

    # 3) 배포 검증 — 대상 객체 실측 (#136)
    checks = [
        (
            "상태",
            """SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
                 FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0021' ORDER BY 1""",
        ),
        (
            "컴파일 오류",
            """SELECT LINE, POSITION, SUBSTR(TEXT,1,120) TXT FROM ALL_ERRORS
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021' ORDER BY SEQUENCE""",
        ),
        (
            "마커 실재 (RTFGATE2 / MSG01001 / 잔존 MSG00704)",
            """SELECT LINE, RTRIM(SUBSTR(TEXT,1,90)) SRC FROM ALL_SOURCE
                WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0021' AND TYPE='PACKAGE BODY'
                  AND (TEXT LIKE '%RTFGATE2%' OR TEXT LIKE '%MSG01001%' OR TEXT LIKE '%MSG00704%')
                ORDER BY LINE""",
        ),
        (
            "MSG01001 원장",
            """SELECT MSG_ID, LANG_CD, SUBSTR(MSG_NM,1,70) MSG_NM, CREATED_BY, USE_YN
                 FROM SCM_ADM_MSG_M WHERE MSG_ID='MSG01001' ORDER BY LANG_CD""",
        ),
    ]
    for title, sql in checks:
        print(f"\n{'=' * 100}\n[검증] {title}\n{'=' * 100}")
        cur.execute(sql)
        cols = [c[0] for c in cur.description]
        rows = cur.fetchall()
        print(" | ".join(cols))
        print("-" * 100)
        for r in rows:
            print(" | ".join("" if v is None else str(v) for v in r))
        print(f"({len(rows)} rows)")

    cur.close()
    con.close()


if __name__ == "__main__":
    main()
