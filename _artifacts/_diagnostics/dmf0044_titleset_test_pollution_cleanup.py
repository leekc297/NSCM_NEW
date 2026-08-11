#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""dmf0044_titleset_test_pollution_cleanup.py — 검증 중 생성된 titleset 행 원복 (2026-08-11)

`P_DMF0044_GET_SALES_REPORTS_DATA` 는 P_CREATED_BY 사용자에게 titleset 이 없으면
SHEET_NAME='MDF Reports' 로 **자동 생성**한다. ETCWB 검증에서 타 사용자 계정으로 GET 을
호출하면서 dong.lee2 / jssbae 의 행이 생성되었다 — 내가 만든 것이므로 되돌린다.

⚠ 삭제 대상은 **2026-08-11 에 생성된 'MDF Reports' 행**으로 한정한다.
   minyonglee1 의 'MDF Reports'(07-30)·각 계정의 'mdfReports'(레거시)는 건드리지 않는다.
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

TARGETS = ("dong.lee2", "jssbae")
T = "SCM_MGR.SCM_MST_TITLESET_USER"
WHERE = ("PROGRAM_ID='DMF0044' AND SHEET_NAME='MDF Reports' "
         "AND USER_ID IN ('dong.lee2','jssbae') "
         "AND CREATION_DATE >= TO_DATE('2026-08-11','YYYY-MM-DD') "
         "AND CREATION_DATE <  TO_DATE('2026-08-12','YYYY-MM-DD')")


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute(f"SELECT USER_ID, COUNT(*) FROM {T} WHERE {WHERE} GROUP BY USER_ID ORDER BY 1")
        before = cur.fetchall()
        print("[대상] %s" % (before or "없음"))
        if not before:
            return 0
        cur.execute(f"DELETE FROM {T} WHERE {WHERE}")
        print("  삭제 %d행" % cur.rowcount)
        con.commit()
        for uid in TARGETS:
            cur.execute(f"""SELECT SHEET_NAME, COUNT(*) FROM {T}
                            WHERE PROGRAM_ID='DMF0044' AND USER_ID=:u
                            GROUP BY SHEET_NAME ORDER BY 1""", {"u": uid})
            print("  %-12s 잔여 %s" % (uid, cur.fetchall()))
    return 0


if __name__ == "__main__":
    sys.exit(main())
