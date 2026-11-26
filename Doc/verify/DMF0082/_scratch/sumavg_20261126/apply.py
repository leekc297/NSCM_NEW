import sys,time
sys.path.insert(0, r'C:/Projects/NSCM/tools/DbConn')
import dbconn
A=r'C:/Projects/NSCM/_artifacts/_apply_corporate/DMF0082_PRICE_AVG_QTY_20261126/'
asis=open(A+'00_BACKUP_PKG_DMF0082_BODY.ASIS.sql',encoding='utf-8').read()
tobe=open(A+'01_PKG_DMF0082_BODY.TOBE.sql',encoding='utf-8').read()
cx=dbconn.connect('tobe'); cx.call_timeout=120000; cur=cx.cursor()
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
now=''.join(r[0] for r in cur)
assert now==asis, 'FRESH-GATE 실패'
print('FRESH-GATE ok')
t=time.time()
cur.execute('CREATE OR REPLACE '+tobe)
print('compile', round(time.time()-t,1),'s')
cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'"); print(cur.fetchone())
cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'"); print('errors', cur.fetchall())
cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
print('db==tobe', ''.join(r[0] for r in cur)==tobe)
cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_NAME LIKE '%DMF0082%'"); print('invalid', cur.fetchone())
