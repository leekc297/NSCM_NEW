import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("select owner, object_type, last_ddl_time from all_objects where object_name='SSP_FORMATION_POST_CELL_V'"); print(c.fetchall())
c.execute("select owner, text from all_views where view_name='SSP_FORMATION_POST_CELL_V'")
for o, t in c.fetchall(): print('== VIEW', o); print(t)
