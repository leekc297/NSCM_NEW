import time,oracledb
env={}
for l in open('.env.asis',encoding='utf-8'):
    l=l.strip()
    if '=' in l and not l.startswith('#'):
        k,v=l.split('=',1); env[k]=v.strip().strip('"')
cx=oracledb.connect(user=env['TOBE_DB_USER'],password=env['TOBE_DB_PASS'],dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
cx.call_timeout=60000
c=cx.cursor(); c.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
Q={
'D1 delegate cols':"""select column_name,data_type,nullable from all_tab_columns where owner='SCM_MGR' and table_name='SSP_MST_DELEGATE' order by column_id""",
'D2 delegate indexes':"""select i.index_name,i.uniqueness,listagg(ic.column_name,',') within group(order by ic.column_position) from all_indexes i join all_ind_columns ic on ic.index_owner=i.owner and ic.index_name=i.index_name where i.table_owner='SCM_MGR' and i.table_name='SSP_MST_DELEGATE' group by i.index_name,i.uniqueness""",
'D3 delegate overlap today':"""select division_id,user_id,count(*) cnt,listagg(delegatee_id||':'||from_date||'~'||to_date,' | ') within group(order by from_date) det from SSP_MST_DELEGATE where valid_yn='Y' and to_char(sysdate,'YYYYMMDD') between from_date and to_date group by division_id,user_id having count(*)>1""",
'D4 delegate total':"""select count(*),sum(case when valid_yn='Y' and to_char(sysdate,'YYYYMMDD') between from_date and to_date then 1 else 0 end) from SSP_MST_DELEGATE""",
'D5 status codes':"""select change_req_status,count(*) from SSP_ANL_SHIP_CONFIRM_CHG_REQ where request_time>=date '2026-11-01' group by change_req_status""",
'D6 max req no':"""select max(change_req_no),to_char(max(request_time),'YYYY-MM-DD HH24:MI:SS') from SSP_ANL_SHIP_CONFIRM_CHG_REQ""",
'D7 delegate procs writing':"""select name,type,line,trim(text) from all_source where owner='SCM_MGR' and upper(text) like '%INSERT%INTO%SSP_MST_DELEGATE%'""",
}
for k,s in Q.items():
    t=time.time(); c.execute(s); rows=c.fetchall()
    print(f'== {k} ({round(time.time()-t,2)}s)')
    for r in rows: print(r)
