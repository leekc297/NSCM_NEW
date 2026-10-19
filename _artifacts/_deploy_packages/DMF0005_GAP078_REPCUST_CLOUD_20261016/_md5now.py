import sys,hashlib;sys.path.insert(0,r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora,oracledb
u,p,d=ora.conn_info();con=oracledb.connect(user=u,password=p,dsn=d);cur=con.cursor()
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0005' AND OBJECT_TYPE='PACKAGE BODY'");m=cur.fetchone()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0005' AND TYPE='PACKAGE BODY' ORDER BY LINE")
t="".join(r[0] for r in cur).replace("\r\n","\n");print("NOW md5",hashlib.md5(t.encode()).hexdigest(),m)
