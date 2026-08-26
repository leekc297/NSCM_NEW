#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_dmf0021_5859_recheck2.py — No.58/59 보완 재확인 2차 (2026-08-18)
  C  MSG00704 원장 등재 (컬럼 구조 실측 후 조회)
  E  배포본 GET 측 RTFGATE 블록 원문 (EDIT_AUTH_RTF_SYS_RP 산출부)
"""
import os
import sys
import time

import oracledb

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

QUERIES = [
    (
        "C-0 SCM_ADM_MSG_M 컬럼 구조",
        """SELECT COLUMN_NAME, DATA_TYPE
             FROM ALL_TAB_COLUMNS
            WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = 'SCM_ADM_MSG_M'
            ORDER BY COLUMN_ID""",
    ),
    (
        "C-1 MSG00704 원장 행 (전 컬럼 축약)",
        """SELECT * FROM SCM_ADM_MSG_M WHERE MSG_ID = 'MSG00704'""",
    ),
    (
        "E 배포본 GET 측 RTFGATE 블록 원문 (L286~320)",
        """SELECT LINE, RTRIM(SUBSTR(TEXT, 1, 130)) AS SRC
             FROM ALL_SOURCE
            WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0021' AND TYPE = 'PACKAGE BODY'
              AND LINE BETWEEN 286 AND 320
            ORDER BY LINE""",
    ),
    (
        "E-2 배포본 SAVE 측 RTFGATE 블록 원문 (L2739~2770)",
        """SELECT LINE, RTRIM(SUBSTR(TEXT, 1, 130)) AS SRC
             FROM ALL_SOURCE
            WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0021' AND TYPE = 'PACKAGE BODY'
              AND LINE BETWEEN 2739 AND 2770
            ORDER BY LINE""",
    ),
]


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
    raise SystemExit(f"접속 실패({retries}회): {last}")


def main():
    con = connect()
    cur = con.cursor()
    for title, sql in QUERIES:
        print(f"\n{'=' * 110}\n[{title}]\n{'=' * 110}")
        try:
            cur.execute(sql)
            cols = [c[0] for c in cur.description]
            rows = cur.fetchall()
            print(" | ".join(cols))
            print("-" * 110)
            for r in rows:
                print(" | ".join("" if v is None else str(v)[:120] for v in r))
            print(f"({len(rows)} rows)")
        except Exception as e:  # noqa: BLE001
            print(f"ERROR: {e}")
    cur.close()
    con.close()


if __name__ == "__main__":
    main()
