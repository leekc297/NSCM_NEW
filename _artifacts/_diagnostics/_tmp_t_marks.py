#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_marks.py — live BODY 마커 현황만 확인 (읽기 전용, 백업파일 생성 안 함)"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MARKS = ["TUNE-M2 2026-08-10", "TUNE-M 2026-08-10", "TUNE-T2 2026-08-10", "TUNE-T 2026-08-10",
         "DESCNULL 2026-08-10", "DESCDEF 2026-08-10", "MSRDUP", "EDITFLAGSTD",
         "DYNSAMP3 2026-08-10", "DYNSAMP2 2026-08-10", "DYNSAMP 2026-08-10",
         "NODATAGUARD 2026-08-10", "SEQGRP 2026-08-10", "ETCDEL 2026-08-10",
         "RPTGRP-STUB 2026-08-10", "AUTHUNION 2026-08-09", "PIVOTSEL 2026-08-10",
         "PRODUCTDETAIL 2026-08-10"]


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("""SELECT TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS
                        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044'
                          AND OBJECT_TYPE='PACKAGE BODY'""")
        print("BODY LAST_DDL/STATUS =", cur.fetchone())
        for m in MARKS:
            cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                            WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""",
                        {"m": m.replace("-", "\\-")})
            print("  %-26s = %s" % (m, cur.fetchone()[0]))
        print("\n활성 세션:")
        cur.execute("""SELECT SID, SUBSTR(PROGRAM,1,24), SUBSTR(EVENT,1,30), SECONDS_IN_WAIT, SQL_ID
                         FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE'""")
        for r in cur.fetchall():
            print("  ", r)


if __name__ == "__main__":
    main()
