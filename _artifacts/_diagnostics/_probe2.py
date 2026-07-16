# -*- coding: utf-8 -*-
import time, oracledb
from ora import conn_info
u,p,d = conn_info()

def run(rng_from, rng_to, user='minyonglee1', grp='minyonglee1'):
    cn = oracledb.connect(user=u,password=p,dsn=d); cur=cn.cursor()
    cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD'")
    cur.execute("ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYYMMDD HH24:MI:SS'")
    IN=['40','ALL','ALL','ALL',rng_from,rng_to,'ALL','','Current','N',user,grp]
    outs=[cn.cursor() for _ in range(6)]
    t0=time.time()
    cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", IN+outs)
    el=time.time()-t0
    counts=[]
    for i,oc in enumerate(outs):
        try:
            rows=oc.fetchall(); nc=len(oc.description) if oc.description else 0
            counts.append(f"RC{i+1 if i<5 else 'RES'}={len(rows)}x{nc}")
        except Exception as e:
            counts.append(f"RC{i}=ERR")
    cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE")
    gtt=cur.fetchone()[0]
    print(f"[{rng_from}-{rng_to} {user}/{grp}] {el:.1f}s GTT={gtt} :: {' '.join(counts)}")
    if gtt>0:
        cur.execute("SELECT MEASURE,COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE GROUP BY MEASURE ORDER BY 2 DESC")
        for m,c in cur.fetchall(): print(f"     {m:<16}{c}")
    cn.close()
    return gtt

for (f,t) in [('20260101','20260731'),('20250201','20250731'),('20260701','20270131')]:
    try: 
        if run(f,t)>0: break
    except Exception as e: print(f"[{f}-{t}] EXC {e}")
