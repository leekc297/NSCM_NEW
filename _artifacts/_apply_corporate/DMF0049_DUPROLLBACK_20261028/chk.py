import sys, re
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
import oracledb
u,p,d = conn_info(); c = oracledb.connect(user=u,password=p,dsn=d); cur=c.cursor()
cur.execute("SELECT name, line, TRIM(text) FROM all_source WHERE owner='SCM_MGR' AND name IN ('PR_DM_SYS_LOG_BATCH','PR_SCM_SYS_LOG_BATCH') AND UPPER(text) LIKE '%AUTONOMOUS%'")
print('AUTONOMOUS', cur.fetchall())
cur.execute("SELECT name, type, line, SUBSTR(TRIM(text),1,140) FROM all_source WHERE owner='SCM_MGR' AND UPPER(text) LIKE '%MOBILE_REPORT_CREATE%(%' AND NOT REGEXP_LIKE(text,'^\s*--') AND UPPER(text) NOT LIKE '%PROCEDURE%' ORDER BY 1,3")
for r in cur: print('CALLER', r)
cur.execute("SELECT line, TRIM(text) FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0049' AND type='PACKAGE BODY' AND line BETWEEN 690 AND 1357 AND REGEXP_LIKE(text,'(COMMIT|ROLLBACK)\s*;') AND NOT REGEXP_LIKE(text,'^\s*--') ORDER BY line")
for r in cur: print('DMF0049 TX', r)
cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type='PACKAGE' AND UPPER(text) LIKE '%MOBILE_REPORT_CREATE%'"); print('SPEC', cur.fetchall())
