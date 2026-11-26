import time,oracledb,collections
env={}
for l in open('.env.asis',encoding='utf-8'):
    l=l.strip()
    if '=' in l and not l.startswith('#'):
        k,v=l.split('=',1); env[k]=v.strip().strip('"')
cx=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cx.call_timeout=60000
c=cx.cursor(); c.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
c.execute("""select approval_user,count(*),min(to_char(request_time,'YYYYMMDD')),max(to_char(request_time,'YYYYMMDD')) from SSP_ANL_SHIP_CONFIRM_CHG_REQ where division_id='40' and valid_yn='Y' and approval_user in ('chahg') group by approval_user"""); print('header chahg',c.fetchall())
c.execute("""select to_char(max(request_time),'YYYYMMDD') from SSP_ANL_SHIP_CONFIRM_CHG_REQ where division_id='40' and approval_user='chahg' and valid_yn='Y'"""); mx=c.fetchone()[0]
fr=mx[:6]+'01'
rc1=c.var(oracledb.DB_TYPE_CURSOR); rc2=c.var(oracledb.DB_TYPE_CURSOR)
t=time.time()
c.callproc('PKG_SSP0003.P_SSP0003_GET_CHG_REQ_CONFIRM',['40','ALL','ALL',fr,mx,'ALL','KO','','ALL',rc1,rc2])
rows=rc1.getvalue().fetchall(); cols=[d[0] for d in rc1.getvalue().description]
print('SP',fr,mx,round(time.time()-t,2),'s rows',len(rows), rc2.getvalue().fetchall())
ix=cols.index('CHANGE_REQ_NO'); ia=cols.index('APPROVAL_USER')
cnt=collections.Counter(r[ix] for r in rows)
d=[(k,v) for k,v in cnt.items() if v>1]
print('dup req_no',len(d),'distinct',len(cnt))
for k,v in d[:10]:
    rr=[r for r in rows if r[ix]==k]
    print(k,v,'approval',rr[0][ia],'identical_rows',len(set(rr))==1, 'deleg',[ (r[cols.index('DELEGATEE_USER')],r[cols.index('SHIPMENT_STATUS')]) for r in rr])
print('dup approval users',collections.Counter(r[ia] for r in rows if cnt[r[ix]]>1))
