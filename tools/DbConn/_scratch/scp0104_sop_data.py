import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
c = connect('tobe'); cur = c.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
for t in ['SCP_MST_CAPA_LINE_SOP','SCP_MST_CAPA_ELTR_LINE_SOP']:
    cur.execute(f"select count(*) from {t}"); print('==',t,'rows',cur.fetchone()[0])
    cur.execute(f"""select division_id,site_id,plant_id,factory_id,line_id,operation_id,eltr_ln_tp_cd,valid_yn,count(*) from {t}
      group by division_id,site_id,plant_id,factory_id,line_id,operation_id,eltr_ln_tp_cd,valid_yn order by 1,2,3,4,5,6,7,8""")
    rows=cur.fetchall(); print('groups',len(rows))
    for r in rows[:60]: print(r)
    cur.execute(f"select division_id,site_id,valid_yn,count(*) from {t} group by division_id,site_id,valid_yn order by 1,2,3")
    print('-- by div/site/valid'); [print(r) for r in cur]
