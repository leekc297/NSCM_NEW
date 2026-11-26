import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor(); c.callTimeout = 120000
c.execute("select plan_start_yyyymmdd, attribute10, count(*) from scm_mgr.ssp_anl_ship_plan_40 where division_id='40' and plan_start_yyyymmdd >= '20261115' group by plan_start_yyyymmdd, attribute10 order by 1,2"); print(c.fetchall())
c.execute("select count(*), count(distinct plan_start_yyyymmdd), min(plan_start_yyyymmdd), max(plan_start_yyyymmdd) from scm_mgr.ssp_anl_hold_stock"); print('HOLD', c.fetchall())
c.execute("select plan_start_yyyymmdd, count(*) from scm_mgr.ssp_anl_hold_stock group by plan_start_yyyymmdd order by 1 desc fetch first 5 rows only"); print(c.fetchall())
c.execute("select index_name, listagg(column_name, ',') within group (order by column_position) from all_ind_columns where table_owner='SCM_MGR' and table_name='SSP_ANL_HOLD_STOCK' group by index_name"); print(c.fetchall())
c.execute("select num_rows from all_tab_statistics where owner='SCM_MGR' and table_name='SSP_ANL_HOLD_STOCK' and object_type='TABLE'"); print(c.fetchall())
