# -*- coding: utf-8 -*-
import time, oracledb
from collections import Counter
from ora import conn_info
u,p,d=conn_info()
cn=oracledb.connect(user=u,password=p,dsn=d);cur=cn.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD'")
cur.execute("ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYYMMDD HH24:MI:SS'")
IN=['40','ALL','ALL','ALL','20260101','20260731','ALL','','Current','N','minyonglee1','minyonglee1']
outs=[cn.cursor() for _ in range(6)]
t0=time.time()
cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", IN+outs)
el=time.time()-t0
main=outs[0]; cols=[c[0] for c in main.description]
mi=[i for i,c in enumerate(cols) if c.upper()=='MEASURE']
rows=main.fetchall()
cc=Counter(str(r[mi[0]]) for r in rows) if mi else {}
print(f"DATEFIX {el:.1f}s  MAIN(RC1)_rows={len(rows)} cols={len(cols)}")
print("  MEASURE:", dict(sorted(cc.items(), key=lambda x:-x[1])))
cur.execute("SELECT MEASURE,COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE GROUP BY MEASURE ORDER BY 2 DESC")
print("  GTT pre-pivot:", dict(cur.fetchall()))
cn.close()
