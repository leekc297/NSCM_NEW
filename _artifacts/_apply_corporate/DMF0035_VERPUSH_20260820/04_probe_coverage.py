# -*- coding: utf-8 -*-
"""값 동등성 케이스 설계용 실측 (읽기 전용).

패치 대상 3분기 커버리지:
  분기1 DM_PLN_MKT_FCST_C        : (CASE WHEN P_DIVISION_ID='40' THEN 1 ELSE 2 END)=2 → DIVISION <> '40'
  분기2 DM_PLN_CFM_MKT_DEMAND_PLAN_C : 동 =1                                          → DIVISION  = '40'
  분기3 DM_PLN_MKT_FCST_RESULT_C : 분기 없음 (항상)
  INSERT#2 는 P_VERSION_NO LIKE '%ME%'
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

print("=== DIVISION 분포: DM_PLN_MKT_FCST_C (분기1 커버용, <>40 필요) ===")
cur.execute("""SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_C
                GROUP BY DIVISION_ID ORDER BY 2 DESC""")
print("   ", cur.fetchall())

print("\n=== DIVISION 분포: DM_PLN_CFM_MKT_DEMAND_PLAN_C ===")
cur.execute("""SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C
                GROUP BY DIVISION_ID ORDER BY 2 DESC""")
print("   ", cur.fetchall())

print("\n=== DIVISION 분포: DM_PLN_MKT_FCST_RESULT_C ===")
cur.execute("""SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C
                GROUP BY DIVISION_ID ORDER BY 2 DESC""")
print("   ", cur.fetchall())

for div in ("81", "82", "41", "50", "10", "20", "30"):
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_MST_VERSION
                    WHERE DIVISION_ID=:v AND (VERSION_NO LIKE '%MF%' OR VERSION_NO LIKE '%SF%')""", {"v": div})
    n = cur.fetchone()[0]
    if n:
        cur.execute("""SELECT VERSION_NO FROM SCM_MGR.DM_MST_VERSION
                        WHERE DIVISION_ID=:v AND (VERSION_NO LIKE '%MF%' OR VERSION_NO LIKE '%SF%')
                        ORDER BY YYYYMMDD DESC FETCH FIRST 3 ROWS ONLY""", {"v": div})
        print(f"  DIV {div}: MF/SF 버전 {n}건 — 예시 {[r[0] for r in cur.fetchall()]}")

print("\n=== ME 버전 (INSERT#2 커버용) ===")
cur.execute("""SELECT DIVISION_ID, VERSION_NO FROM SCM_MGR.DM_MST_VERSION
                WHERE VERSION_NO LIKE '%ME%' ORDER BY YYYYMMDD DESC FETCH FIRST 15 ROWS ONLY""")
print("   ", cur.fetchall())
con.close()
