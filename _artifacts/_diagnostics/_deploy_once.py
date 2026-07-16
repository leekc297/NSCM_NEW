# -*- coding: utf-8 -*-
import time, oracledb
from collections import Counter
from ora import conn_info
time.sleep(90)  # 소켓 TIME_WAIT 배수 (재시도 없음)
u,p,d=conn_info()
cn=oracledb.connect(user=u,password=p,dsn=d); cur=cn.cursor()
src=open(r'C:\Projects\NSCM\_artifacts\_apply_corporate\PKG_DMF0082_body_datefix_20260712.sql',encoding='utf-8').read().rstrip()
if src.endswith('/'): src=src[:-1].rstrip()
cur.execute(src); cn.commit()
cur.execute("SELECT status FROM user_objects WHERE object_name='PKG_DMF0082' AND object_type='PACKAGE BODY'")
print('BODY STATUS=',cur.fetchone()[0])
cur.execute("SELECT line,text FROM user_errors WHERE name='PKG_DMF0082' ORDER BY sequence")
errs=cur.fetchall()
if errs:
    for e in errs[:8]: print(' ERR',e)
else:
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
    print(f"PIVOTFIX {el:.1f}s MAIN(RC1)_rows={len(rows)} cols={len(cols)}")
    print(" MEASURE:", dict(sorted(cc.items(), key=lambda x:-x[1])))
cn.close()
