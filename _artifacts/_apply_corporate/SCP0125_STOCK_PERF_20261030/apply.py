import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
body = open(sys.argv[1], encoding='utf-8').read()
with connect('tobe') as cx:
    c=cx.cursor()
    c.execute("CREATE OR REPLACE " + body.rstrip().rstrip('/'))
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SCP0125' ORDER BY OBJECT_TYPE"); print(c.fetchall())
    c.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_SCP0125'"); print('errors', c.fetchall())
