"""DMF0003 GET_SPREAD_TITLE PROC_M 등록 — PIVOT 동적컬럼 param (2026-06-28).
  DMF0003_GET_SPREAD_TITLE = 6 IN + O_RC1. PROC_M 0행 → BE 가 인자 없이 호출 → 동적컬럼 미반환.
  COL_NM = camelCase(=FE store spreadTitle filter key), SORT_ORD = SP positional.
  멱등: DELETE+INSERT. 검증: SP arg 수 == PROC_M 수.
"""
import os, sys
import oracledb
sys.stdout.reconfigure(line_buffering=True)
u=os.getenv("NSCM_ORA_USER"); p=os.getenv("NSCM_ORA_PASS"); d=os.getenv("NSCM_ORA_DSN")
assert u and p and d
conn=oracledb.connect(user=u,password=p,dsn=d); cur=conn.cursor()
PROC="DMF0003_GET_SPREAD_TITLE"
ROWS=[  # (COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD)  — SP: P_START_YYYYMMDD..P_TYPE + O_RC1
 ("startYyyymmdd","VARCHAR","IN",1),("endYyyymmdd","VARCHAR","IN",2),
 ("createdBy","VARCHAR","IN",3),("divisionId","VARCHAR","IN",4),
 ("userGroup","VARCHAR","IN",5),("type","VARCHAR","IN",6),
 ("o_rc1","CURSOR","OUT",7),
]
cur.execute("DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n",{"n":PROC})
ins="""INSERT INTO SCM_MGR.SCM_ADM_PROC_M
 (PROC_NM,COL_NM,DATA_TP_CD,COL_TP_CD,SORT_ORD,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
 VALUES (:n,:c,:dt,:ct,:so,'admin',SYSDATE,'admin',SYSDATE)"""
for c,dt,ct,so in ROWS:
    cur.execute(ins,{"n":PROC,"c":c,"dt":dt,"ct":ct,"so":so})
conn.commit()
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n",{"n":PROC})
pm=cur.fetchone()[0]
cur.execute("SELECT COUNT(*) FROM USER_ARGUMENTS WHERE OBJECT_NAME=:n",{"n":PROC})
sp=cur.fetchone()[0]
print(f"[OK] {PROC}: PROC_M={pm} / SP_ARGS={sp} {'MATCH' if pm==sp else 'MISMATCH!'}")
conn.close()
