# d01_dump_src.py — 후보 SP 원문을 사내 DB(USER_SOURCE)에서 새로 받아 _src_corp/ 에 저장 (읽기 전용, SOURCE-FRESH)
import sys, os, io, datetime
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora, oracledb
u, p, d = ora.conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
OBJS = [('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE','PROCEDURE'),('PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE','PROCEDURE'),
        ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_BATCH','PROCEDURE'),('PR_DM_SSP_CONFIRM_SYNC','PROCEDURE'),
        ('PR_DM_LONGPLAN_40_DELETE_IMPORT','PROCEDURE'),('PKG_DMF0082','PACKAGE BODY'),('PKG_DMF0003','PACKAGE BODY')] + \
       [(a, 'PROCEDURE') for a in sys.argv[1:]]
here = os.path.dirname(os.path.abspath(__file__))
cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
db, now = cur.fetchone()
print('DB', db, 'FETCHED', now)
for n, t in OBJS:
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=n, t=t)
    r = cur.fetchone()
    if not r: print('MISSING', n); continue
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE=:t ORDER BY LINE", n=n, t=t)
    lines = [x[0] or '\n' for x in cur]
    with io.open(os.path.join(here, '_src_corp', n + '.sql'), 'w', encoding='utf-8', newline='') as f:
        f.write(''.join(lines))
    print(f'{n:48s} {t:13s} LAST_DDL={r[0]} {r[1]} lines={len(lines)}')
