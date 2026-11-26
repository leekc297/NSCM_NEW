import sys,time,os
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
with connect('tobe') as cx:
    cx.call_timeout=300000
    cur=cx.cursor(); cur.execute("alter session set current_schema=SCM_MGR")
    rc=[cx.cursor() for _ in range(6)]
    cur.callproc('SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA',['40','ALL','ALL','ALL','20260101','20270430','ALL','MCSS22561-C1',sys.argv[1],'N','minyonglee1','ADMIN','ALL','ALL','ALL','ALL']+rc)
    c=rc[0]; cols=[d[0] for d in c.description]
    for r in c.fetchall():
        d=dict(zip(cols,r))
        if d['SCM_SITE_ID']!='BYD Electronics_CN_SZX' or d['MEASURE'] not in ('MKT_FCST','SCM_FCST','RTF_SYS_RP','MKT_FCST_PP'): continue
        vals=[(k,v) for k,v in d.items() if k[:1].isdigit() or k.startswith(('W','M2','D2'))]
        nz=[(k,v) for k,v in vals if v not in (None,0,'0','')][:4]
        print(d['MEASURE'],d.get('MEASURE_GROUP'),nz)
