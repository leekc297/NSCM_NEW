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
main=outs[0]  # RC1 = main pivoted
cols=[c[0] for c in main.description]
# MEASURE 컬럼 인덱스
mi=None
for i,c in enumerate(cols):
    if c.upper()=='MEASURE': mi=i;break
rows=main.fetchall()
cc=Counter(str(r[mi]) for r in rows) if mi is not None else {}
print(f"POST-FIX {el:.1f}s  MAIN(RC1)_rows={len(rows)} cols={len(cols)}")
print("  MEASURE dist:", dict(sorted(cc.items(), key=lambda x:-x[1])))
cn.close()
