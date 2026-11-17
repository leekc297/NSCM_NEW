import sys, oracledb
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
sys.stdout.reconfigure(encoding='utf-8')
con = dbconn.connect('tobe'); cur = con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('NOW', cur.fetchone()[0])
cur.execute("SELECT DIVISION_ID, COUNT(*) , MIN(ITEM_ID), MAX(ITEM_ID) FROM SSP_MST_SHIP_MASTER_EE GROUP BY DIVISION_ID")
for r in cur: print(r)
def run(proc, args):
    rc = cur.var(oracledb.CURSOR); rr = cur.var(oracledb.CURSOR)
    cur.callproc('PKG_SSP0024.'+proc, args+[rc, rr])
    rows = rc.getvalue().fetchall(); return rows
cases = sys.argv[1:]
for c in cases:
    proc, div, site, mat = c.split('|')
    if proc=='M':
        rows = run('P_SSP0024_GET_SHIP_MASTER', [div, site, mat, '', ''])
    else:
        rows = run('P_SSP0024_GET_ITEM_BY_DIVISION_POPUP', [div, site, mat])
    print(proc, repr(div), repr(site), repr(mat), 'rows=', len(rows), sorted(set(r[3] for r in rows))[:5])
