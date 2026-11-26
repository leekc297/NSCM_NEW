import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn, oracledb
cx=dbconn.connect('tobe'); cx.call_timeout=180000; cur=cx.cursor()
cur.execute("SELECT SCM_SITE_ID FROM SCM_MGR.SCM_MST_SITE WHERE SCM_SITE_ID LIKE 'VW_CZ%' AND DIVISION_ID='81'"); print([r[0] for r in cur])
rcs=[cx.cursor() for _ in range(6)]
t=time.time()
cur.callproc('SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA',['81','ALL','ALL','ALL','20261101','20270430','VW_CZ_MBV',None,'Current','N','minyonglee1','ADMIN','ALL','ALL','ALL','ALL']+rcs)
cols=[d[0] for d in rcs[0].description]; data=rcs[0].fetchall()
print('rows',len(data), round(time.time()-t,1),'s')
print(rcs[5].fetchall())
ix={c:i for i,c in enumerate(cols)}
show=['M_202611']+sorted([c for c in cols if c.startswith('W_202611')])+['M_202612']
keys=[c for c in ('PROJECT_CODE','ITEM_ID','INCOTERMS','PLANT_SITE_ID','CURRENCY') if c in ix]
print(keys, show)
for r in data:
    m=r[ix['MEASURE']] if 'MEASURE' in ix else None
    if 'PROJECT_CODE' in ix and r[ix['PROJECT_CODE']]!='A17VA4001': continue
    print([r[ix[k]] for k in keys], m, [None if r[ix[c]] is None else round(float(r[ix[c]]),3) for c in show])
