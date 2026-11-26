import sys,time,oracledb
env={}
for l in open('.env.asis',encoding='utf-8'):
    l=l.strip()
    if '=' in l and not l.startswith('#'):
        k,v=l.split('=',1); env[k]=v.strip().strip('"')
cx=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cx.call_timeout=60000
c=cx.cursor(); c.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
c.execute("select sys_context('USERENV','SERVER_HOST'),to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); print('DB',c.fetchone())
Q={
'Q1 header rows':"""select division_id,from_site,change_req_no,change_req_status,change_type,valid_yn,request_user,approval_user,delegatee_user,to_char(request_time,'YYYY-MM-DD HH24:MI:SS') rt,origin_from_division_id from SSP_ANL_SHIP_CONFIRM_CHG_REQ where change_req_no in ('R20261125542412','R20261125542414','R20261125542410') order by change_req_no""",
'Q2 header PK':"""select c.constraint_name,c.constraint_type,listagg(cc.column_name,',') within group(order by cc.position) cols from all_constraints c join all_cons_columns cc on cc.owner=c.owner and cc.constraint_name=c.constraint_name where c.owner='SCM_MGR' and c.table_name in ('SSP_ANL_SHIP_CONFIRM_CHG_REQ','SSP_MST_DELEGATE','SCM_ADM_USER_M') and c.constraint_type in ('P','U') group by c.table_name,c.constraint_name,c.constraint_type""",
'Q3 delegate rows for approval user':"""select e.division_id,e.user_id,e.delegatee_id,e.from_date,e.to_date,e.valid_yn from SSP_MST_DELEGATE e where (e.division_id,e.user_id) in (select division_id,approval_user from SSP_ANL_SHIP_CONFIRM_CHG_REQ where change_req_no in ('R20261125542412','R20261125542414')) order by 1,2,3""",
'Q4 user dup':"""select user_id,count(*) cnt from SCM_ADM_USER_M where use_yn='Y' and user_id in (select request_user from SSP_ANL_SHIP_CONFIRM_CHG_REQ where change_req_no in ('R20261125542412','R20261125542414') union select approval_user from SSP_ANL_SHIP_CONFIRM_CHG_REQ where change_req_no in ('R20261125542412','R20261125542414') union select delegatee_user from SSP_ANL_SHIP_CONFIRM_CHG_REQ where change_req_no in ('R20261125542412','R20261125542414')) group by user_id""",
'Q5 DE rows':"""select division_id,change_req_no,item_id,to_site,count(*) from SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE where change_req_no in ('R20261125542412','R20261125542414') group by division_id,change_req_no,item_id,to_site""",
'Q6 header dup in whole table':"""select division_id,change_req_no,count(*) cnt from SSP_ANL_SHIP_CONFIRM_CHG_REQ where valid_yn='Y' and request_time>=date '2026-11-01' group by division_id,change_req_no having count(*)>1 order by 2""",
}
for k,s in Q.items():
    t=time.time(); c.execute(s); rows=c.fetchall()
    print(f'== {k} ({round(time.time()-t,2)}s) cols={[d[0] for d in c.description]}')
    for r in rows: print(r)
