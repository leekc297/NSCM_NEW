import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("""select i.index_name, i.uniqueness, i.index_type, listagg(ic.column_name, ',') within group (order by ic.column_position)
 from all_indexes i join all_ind_columns ic on ic.index_owner=i.owner and ic.index_name=i.index_name
 where i.owner='SCM_MGR' and i.table_name='SSP_ANL_SHIP_PLAN_40' group by i.index_name, i.uniqueness, i.index_type"""); 
for r in c.fetchall(): print(r)
c.execute("select constraint_name, constraint_type, status from all_constraints where owner='SCM_MGR' and table_name='SSP_ANL_SHIP_PLAN_40' and constraint_type in ('P','U','R')"); print(c.fetchall())
c.execute("select trigger_name, status from all_triggers where table_owner='SCM_MGR' and table_name='SSP_ANL_SHIP_PLAN_40'"); print('TRG', c.fetchall())
c.execute("select num_rows, blocks, last_analyzed, partitioned from all_tables t left join all_tab_statistics s using (owner, table_name) where owner='SCM_MGR' and table_name='SSP_ANL_SHIP_PLAN_40' and s.object_type='TABLE'"); print(c.fetchall())
