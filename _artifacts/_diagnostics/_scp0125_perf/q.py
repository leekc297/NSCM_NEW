import sys; sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect
sql = sys.stdin.read()
with connect('tobe') as cx:
    cur = cx.cursor()
    for st in [s for s in sql.split('\n/\n') if s.strip()]:
        cur.execute(st)
        if cur.description:
            cols=[d[0] for d in cur.description]; print('|'.join(cols))
            for r in cur.fetchall(): print('|'.join('' if v is None else str(v.read() if hasattr(v,'read') else v) for v in r))
        print('---')
