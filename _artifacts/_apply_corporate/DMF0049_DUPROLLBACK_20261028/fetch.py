import sys, re, datetime
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
now=datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' AND OBJECT_TYPE='PACKAGE BODY'")
ddl,st=cur.fetchone()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' ORDER BY LINE")
base="".join(r[0] for r in cur)
fn=f"PKG_DMF0044_BODY.ASIS_{now}.sql"
open(fn,'w',encoding='utf-8',newline='').write(base)
print("FETCHED",now,"LAST_DDL",ddl,st,"lines",base.count('\n'),"->",fn)
lines=base.split('\n')
# locate MOBILE_REPORT_CREATE body range & every early RETURN
s=[i for i,x in enumerate(lines) if re.match(r'\s*PROCEDURE\s+P_DMF0044_MOBILE_REPORT_CREATE\b',x,re.I)]
e=[i for i,x in enumerate(lines) if re.match(r'\s*END\s+P_DMF0044_MOBILE_REPORT_CREATE\s*;',x,re.I)]
print("proc start/end lines", [i+1 for i in s], [i+1 for i in e])
for i in range(s[-1], e[-1]+1):
    if re.search(r'\bRETURN\s*;|ROLLBACK|COMMIT',lines[i]) and not lines[i].strip().startswith('--'):
        print(i+1, lines[i].rstrip())
