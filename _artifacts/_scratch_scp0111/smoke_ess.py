import sys
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn, oracledb
c = dbconn.connect('tobe'); cur = c.cursor()
rc, rs = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
cur.callproc('SCM_MGR.PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE', [rc, rs])
r = rc.getvalue(); cols = [d[0] for d in r.description]; rows = r.fetchall()
print('o_rc cols', cols, 'rows', len(rows)); print(rows[:5])
s = rs.getvalue(); print('result', [d[0] for d in s.description], s.fetchall())
c.rollback()
