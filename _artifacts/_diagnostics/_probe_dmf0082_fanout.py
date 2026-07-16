# -*- coding: utf-8 -*-
import sys, time
import oracledb
from ora import conn_info

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD'")
cur.execute("ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYYMMDD HH24:MI:SS'")

# div40 golden range (AS-IS 2508행 대조구간), user=minyonglee1 (6 measures incl KRW/USD/LOC)
IN = ['40','ALL','ALL','ALL','20250201','20250731','ALL','','Current','N','minyonglee1','minyonglee1']
outs = [cn.cursor() for _ in range(6)]
t0 = time.time()
cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", IN + outs)
elapsed = time.time() - t0

# 메인 결과 커서 = O_RESULT_CURSOR (마지막)
main = outs[-1]
mrows = main.fetchall()
mcols = [c[0] for c in main.description] if main.description else []
print(f"PROC_ELAPSED_SEC={elapsed:.1f}  MAIN_ROWS={len(mrows)}  MAIN_COLS={len(mcols)}")

# 같은 세션 GTT per-measure (pivot 前 grain)
cur.execute("SELECT MEASURE, COUNT(*) CNT FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE GROUP BY MEASURE ORDER BY CNT DESC")
print("--- GT_DMF0082_TEMP_FCST_N_PRICE per MEASURE ---")
tot=0
for m,c in cur.fetchall():
    print(f"  {m:<16} {c}"); tot+=c
print(f"  TOTAL_PREPIVOT={tot}")

# SELECT_MEASURE 내용 (중복 여부)
cur.execute("SELECT MEASURE, RESULT_MEASURE, USER_ID, COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE GROUP BY MEASURE, RESULT_MEASURE, USER_ID ORDER BY 1")
print("--- GT_DMF0082_TEMP_SELECT_MEASURE (measure/result/user/dupcnt) ---")
for row in cur.fetchall():
    print(f"  {row}")

# 폭증 measure grain 분해 (LOC 예: distinct 키 vs 행수)
cur.execute("""SELECT COUNT(*) ROWS_, COUNT(DISTINCT ITEM_ID||'|'||CELL_PROD_SITE_ID||'|'||PLANT_SITE_ID||'|'||INCOTERMS||'|'||DOM_EXP||'|'||YYYYMMDD) KEYS_
               FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE MEASURE='LOC'""")
r=cur.fetchone(); print(f"--- LOC: rows={r[0]} distinct_full_key={r[1]}  (row/key={r[0]/max(r[1],1):.2f})")
cn.close()
