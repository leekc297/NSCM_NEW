import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
for t in ['SCM_MST_ITEM_SN', 'SCM_MST_SITE']:
    c.execute("""select c.constraint_name, c.constraint_type, listagg(cc.column_name, ',') within group (order by cc.position)
      from all_constraints c join all_cons_columns cc on cc.owner=c.owner and cc.constraint_name=c.constraint_name
     where c.owner='SCM_MGR' and c.table_name=:t and c.constraint_type in ('P','U') group by c.constraint_name, c.constraint_type""", t=t)
    print(t, c.fetchall())
    c.execute("select index_name, uniqueness, (select listagg(column_name, ',') within group (order by column_position) from all_ind_columns ic where ic.index_owner=i.owner and ic.index_name=i.index_name) from all_indexes i where owner='SCM_MGR' and table_name=:t", t=t)
    print('  idx', c.fetchall())
c.execute("select column_name, nullable from all_tab_columns where owner='SCM_MGR' and table_name='SCM_MST_SITE' and column_name in ('SCM_SITE_ID','PLANT_ID','OPERATION_GROUP','SITE_TYPE','VALID_YN')"); print(c.fetchall())
c.execute("select count(*), count(distinct division_id||'|'||item_id) from scm_mgr.scm_mst_item_sn"); print('ITEM_SN rows/distinct', c.fetchall())
