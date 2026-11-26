import sys
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect('tobe').cursor()
c.execute("select table_owner, table_name, db_link from all_synonyms where synonym_name='SCM_FORMATION_POST_CELL_V_SN'"); s = c.fetchall(); print(s)
o, n = s[0][0], s[0][1]
c.execute("select object_type from all_objects where owner=:o and object_name=:n", o=o, n=n); print(c.fetchall())
c.execute("select text from all_views where owner=:o and view_name=:n", o=o, n=n)
r = c.fetchone(); print(r[0] if r else None)
