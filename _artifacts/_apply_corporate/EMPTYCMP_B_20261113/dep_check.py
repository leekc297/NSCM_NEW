# -*- coding: utf-8 -*-
import sys, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
con = dbconn.connect('tobe'); cur = con.cursor()
print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
for n in ('PKG_SDM2010', 'PKG_SDM2020', 'PR_SCP_OPT_ENG_EE_INPUT_INCOMING_STOCK', 'PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH'):
    cur.execute("""SELECT O.OBJECT_NAME, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'),
                          (SELECT COUNT(*) FROM ALL_ERRORS E WHERE E.OWNER=O.OWNER AND E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE)
                     FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR' AND O.STATUS='INVALID' AND (O.OBJECT_NAME, O.OBJECT_TYPE) IN
                          (SELECT NAME, TYPE FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=n)
    for r in cur.fetchall():
        print(n, '←', r)
        cur.execute("SELECT REFERENCED_NAME, REFERENCED_TYPE, (SELECT MAX(STATUS) FROM ALL_OBJECTS X WHERE X.OWNER=D.REFERENCED_OWNER AND X.OBJECT_NAME=D.REFERENCED_NAME AND X.OBJECT_TYPE=D.REFERENCED_TYPE) FROM ALL_DEPENDENCIES D WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t AND REFERENCED_OWNER='SCM_MGR'", n=r[0], t=r[1])
        bad = [x for x in cur.fetchall() if x[2] != 'VALID']
        print('     참조 대상 중 VALID 아닌 것:', bad[:8])
        cur.execute("SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=r[0], t=r[1])
        for e in cur.fetchall()[:3]: print('     ERR L%s %s' % (e[0], e[1].strip()[:150]))
con.close()
