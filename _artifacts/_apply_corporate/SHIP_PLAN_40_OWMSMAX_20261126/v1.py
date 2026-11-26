import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("select owner, object_name, object_type, status, last_ddl_time from all_objects where object_name='SCM_DNM_STOCK_AGING_V'"); print(c.fetchall())
c.execute("select table_owner, table_name from all_synonyms where synonym_name='SCM_DNM_STOCK_AGING_V' and owner='SCM_MGR'"); print(c.fetchall())
c.execute("select owner, text from all_views where view_name='SCM_DNM_STOCK_AGING_V'")
for o, t in c.fetchall(): print('== VIEW', o); print(t)
