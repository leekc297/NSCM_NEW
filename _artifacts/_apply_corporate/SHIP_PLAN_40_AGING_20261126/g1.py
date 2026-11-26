import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("select table_name, temporary, duration from all_tables where owner='SCM_MGR' and table_name like 'GT_SSP_ANL_SHIP%'"); print(c.fetchall())
c.execute("select dbms_stats.get_prefs('GLOBAL_TEMP_TABLE_STATS','SCM_MGR','GT_SSP_ANL_SHIP_PLAN_40') from dual"); print(c.fetchall())
