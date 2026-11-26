import sys, os
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora, oracledb
u,p,d = ora.conn_info()
con = oracledb.connect(user=u,password=p,dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
def q(sql, b=None):
    cols, rows = ora.fetch(cur, sql, b); ora.show(cols, rows)
if __name__ == '__main__':
    q(open(sys.argv[1], encoding='utf-8').read().rstrip().rstrip(';'))
