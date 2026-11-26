import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
c = dbconn.connect(sys.argv[1]); cur = c.cursor()
for sql in sys.argv[2:]:
    cur.execute(sql); cols=[d[0] for d in cur.description]
    print('##', sql[:120]); print(cols)
    for r in cur.fetchmany(40): print(r)
c.rollback(); c.close()
