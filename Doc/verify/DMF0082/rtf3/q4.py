import sys,time,collections,os
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
ver=sys.argv[1]
with connect('tobe') as cx:
    cx.call_timeout=300000
    cur=cx.cursor()
    cur.execute("alter session set current_schema=SCM_MGR")
    rc=[cx.cursor() for _ in range(6)]
    t=time.time()
    cur.callproc('SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA',
      [os.environ.get('DIV','40'),'ALL','ALL','ALL',os.environ.get('FR','20261101'),'20270430','ALL',(os.environ.get('ITEM') or None),ver,'N',os.environ.get('USR','minyonglee1'),'ADMIN','ALL','ALL','ALL','ALL']+rc)
    print('call',round(time.time()-t,1),'s')
    for n,x in enumerate(rc):
        try: print('rc',n,[d[0] for d in x.description][:6])
        except Exception as e: print('rc',n,e)
    for gt in ('GT_DMF0082_TEMP_SITE_ITEM','GT_DMF0082_T_VERSION','GT_DMF0082_TEMP_SELECT_MEASURE','GT_DMF0082_TEMP_FCST_N_PRICE','GT_DMF0082_T_WS_FCST'):
        cur.execute('select count(*) from SCM_MGR.'+gt); print(gt,cur.fetchone())
    print('result',rc[5].fetchall())
    c=rc[int(sys.argv[2]) if len(sys.argv)>2 else 0]; cols=[d[0] for d in c.description]; rows=c.fetchall()
    print('rows',len(rows))
    i=cols.index('MEASURE'); g=cols.index('MEASURE_GROUP') if 'MEASURE_GROUP' in cols else None
    key=[k for k in ('DIVISION_ID','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','INCOTERMS','FCST_TYPE','DOM_EXP','VERSION_NO','CELL_PROD_SITE_ID') if k in cols]
    cnt=collections.Counter(); grp=collections.defaultdict(set)
    for r in rows:
        k=tuple(r[cols.index(x)] for x in key)+(r[i],)
        cnt[k]+=1
        if g is not None: grp[k].add(r[g])
    dist=collections.Counter()
    for k,v in cnt.items(): dist[(k[-1],v)]+=1
    for k in sorted(dist): print(k,dist[k])
    ex=[k for k,v in cnt.items() if v>1][:3]
    for k in ex: print('dup',k,cnt[k],sorted(grp[k]))
rc_cols=None
