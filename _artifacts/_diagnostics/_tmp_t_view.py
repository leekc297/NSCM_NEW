#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_view.py — DM_MST_ITEM_SINGLE_V 단독 산출 비용 실측 (읽기 전용 SELECT 만)"""
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        cur.execute("""SELECT TEXT FROM ALL_VIEWS WHERE OWNER='SCM_MGR' AND VIEW_NAME='DM_MST_ITEM_SINGLE_V'""")
        r = cur.fetchone()
        print("=== DM_MST_ITEM_SINGLE_V 정의 ===")
        print((r[0] if r else "(없음)")[:3000])

        for label, sql in [
            ("전체 COUNT", "SELECT COUNT(*) FROM SCM_MGR.DM_MST_ITEM_SINGLE_V"),
            ("division 40 COUNT", "SELECT COUNT(*) FROM SCM_MGR.DM_MST_ITEM_SINGLE_V WHERE DIVISION_ID='40'"),
            ("SCM_ITEM_M 전체", "SELECT COUNT(*) FROM SCM_MGR.SCM_ITEM_M"),
        ]:
            t = time.time()
            cur.execute(sql)
            n = cur.fetchone()[0]
            print("\n[%s] = %s  (%.2f초)" % (label, n, time.time() - t))

        print("\n=== 대상 버전 원장 행수 ===")
        for label, sql in [
            ("PLAN_REPORT_C R_S_20260128_V002_C",
             "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C'"),
            ("  ↳ MEASURE IN (RTF,Business_Plan,SalesAmt_KRW)",
             "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C' AND MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')"),
            ("ETC_REPORT_C R_S_20260128_V002_C",
             "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C'"),
            ("  ↳ MEASURE IN (...)",
             "SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C WHERE DIVISION_ID='40' AND VERSION_NO='R_S_20260128_V002_C' AND MEASURE IN ('RTF','Business_Plan','SalesAmt_KRW')"),
        ]:
            t = time.time()
            cur.execute(sql)
            print("  %-50s = %8s  (%.2f초)" % (label, cur.fetchone()[0], time.time() - t))

        print("\n=== DM_MDF_VERSION 대상 버전 헤더 ===")
        cur.execute("""SELECT VERSION_NO, VERSION_TYPE, SEND_YN, YYYYMMDD, ORI_VERSION_NO
                         FROM SCM_MGR.DM_MDF_VERSION
                        WHERE DIVISION_ID='40' AND VERSION_NO IN ('R_S_20260128_V002_C','R_S_20251126_V002_C')""")
        for row in cur.fetchall():
            print("  ", row)


if __name__ == "__main__":
    main()
