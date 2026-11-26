import oracledb, time, datetime
env=dict(l.strip().split('=',1) for l in open(r'c:\Projects\NSCM\.env.asis',encoding='utf-8') if '=' in l and not l.startswith('#'))
c=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}"); c.call_timeout=300000
cur=c.cursor(); cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
print('RUN', datetime.datetime.now().strftime('%F %T'))
C=[('GET_SHIPMENT_REQUEST',['Pack Biz','81',None,None,None,None,None,None,'20261126','20261231','admin']),
   ('GET_SPREAD_TITLE',['20261101','20261231','admin','Pack Biz','81']),
   ('GET_BUCKET_TYPE_CODE',[]),('GET_TEAM_BY_DIVISION',['81']),('GET_CUSTOMER_BY_DIVISION',['81','ALL']),
   ('GET_SITE_BY_DIVISION',['81','ALL','ALL']),('GET_BODITEM_FOR_PRJROUTE_POPUP',['81','AMCOME782-A1-0K0',None]),
   ('GET_ITEM_BY_DIVISION_POPUPEX',['81','ALL','ALL',None,'ALL','AMC','P']),
   ('GET_ITEM_BY_DIVISION_POPUPEX',['82','ALL','ALL',None,'ALL','EA019170PC01','P']),
   ('GET_PROJECT_BY_DIVISION_POPUPEX',['81','ALL','ALL','ALL',None,'N']),('GET_PROJECT_BY_DIVISION_POPUPEX',['81','ALL','ALL','ALL',None,'Y']),
   ('GET_COMMON_SPREAD_TITLE',[None,None,'admin','SSP0046','ItemPopup','81']),('GET_COMMON_SPREAD_TITLE_EX',[None,None,'admin','SSP0046','ProjectPopup'])]
for n,p in C:
    r1,r2=cur.var(oracledb.CURSOR),cur.var(oracledb.CURSOR); t=time.time()
    cur.callproc(f'PKG_SSP0046.P_SSP0046_{n}',p+[r1,r2])
    print(n,p[:2],'rows',len(r1.getvalue().fetchall()),'res',r2.getvalue().fetchall(),'sec',round(time.time()-t,1),flush=True)
cur.execute("select object_name,object_type,status from all_objects where object_name like '%SSP0046%' and status<>'VALID'"); print('INVALID',cur.fetchall())
cur.execute("select count(*) from all_objects where owner='SCM_MGR' and object_name='PKG_SSP0046_CHK'"); print('CHK left',cur.fetchone()[0])
