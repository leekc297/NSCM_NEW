import sys, re, datetime
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
now=datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0049' AND OBJECT_TYPE='PACKAGE BODY'")
print("FETCHED", now, cur.fetchone())
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' ORDER BY LINE")
base="".join(r[0] for r in cur); fn=f"PKG_DMF0049_BODY.ASIS_{now}.sql"
open(fn,'w',encoding='utf-8',newline='').write(base); print(fn, base.count('\n'))
L=base.split('\n')
for i in range(985,1100): print(f"{i+1:>5}: {L[i][:200]}")
