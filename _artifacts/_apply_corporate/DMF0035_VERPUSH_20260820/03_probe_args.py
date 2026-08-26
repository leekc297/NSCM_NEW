# -*- coding: utf-8 -*-
"""P_DMF0035_GET_MKT_FCST_WATERFALL 시그니처 + MF 버전 후보 실측 (읽기 전용).

capture_mkt.py 의 기존 ARGS 는 P_VERSION_NO='CURRENT' 라 **패치 대상 IF 블록에 진입하지 않는다**.
값 동등성 검증이 패치 경로를 실제로 덮도록 MF/SF 버전 인자를 확정한다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
                WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0035'
                  AND OBJECT_NAME='P_DMF0035_GET_MKT_FCST_WATERFALL'
                ORDER BY POSITION""")
for r in cur.fetchall():
    print(f"  {r[0]:>3} {str(r[1]):<28} {r[2]:<12} {r[3]}")

print("\n=== DM_MST_VERSION (DIVISION 40) MF/SF 버전 후보 ===")
cur.execute("""SELECT VERSION_NO, YYYYMMDD FROM SCM_MGR.DM_MST_VERSION
                WHERE DIVISION_ID='40' AND (VERSION_NO LIKE '%MF%' OR VERSION_NO LIKE '%SF%')
                ORDER BY YYYYMMDD DESC FETCH FIRST 12 ROWS ONLY""")
for r in cur.fetchall():
    print("   ", r)

print("\n=== 원장 실존 확인: 각 표의 해당 버전 행수 ===")
cur.execute("""SELECT VERSION_NO, CUTOFF_TYPE, COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_C
                WHERE DIVISION_ID='40' GROUP BY VERSION_NO, CUTOFF_TYPE
                ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY""")
for r in cur.fetchall():
    print("    MKT_FCST_C      ", r)
cur.execute("""SELECT VERSION_NO, CUTOFF_TYPE, COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C
                WHERE DIVISION_ID='40' GROUP BY VERSION_NO, CUTOFF_TYPE
                ORDER BY 3 DESC FETCH FIRST 10 ROWS ONLY""")
for r in cur.fetchall():
    print("    MKT_FCST_RESULT_C", r)
con.close()
