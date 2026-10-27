"""CELL_PROD_SITE_ID '/'·' ' → '-' 전환 사전 실측 (조회 전용)"""
import sys; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
u,p,d = conn_info(); cur = oracledb.connect(user=u,password=p,dsn=d).cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("DB", cur.fetchone())
cur.execute("""SELECT C.TABLE_NAME, C.DATA_DEFAULT, C.DEFAULT_ON_NULL, C.NULLABLE,
   (SELECT COUNT(*) FROM USER_TAB_COLUMNS D WHERE D.TABLE_NAME=C.TABLE_NAME AND D.COLUMN_NAME='DIVISION_ID') HAS_DIV
 FROM USER_TAB_COLUMNS C JOIN USER_TABLES T ON T.TABLE_NAME=C.TABLE_NAME AND T.TEMPORARY='N'
 WHERE C.COLUMN_NAME='CELL_PROD_SITE_ID' AND NOT REGEXP_LIKE(C.TABLE_NAME,'(BAK|_SNAPSHOT|_TMP|_TEST|^CMP[0-9][$])') ORDER BY 1""")
for t, dflt, onn, nl, hd in cur.fetchall():
    dflt = (dflt or "").strip(); g = "DIVISION_ID" if hd else "'(no div)'"
    cur.execute(f"SELECT {g}, COUNT(*) FROM SCM_MGR.{t} WHERE CELL_PROD_SITE_ID IN ('/',' ') GROUP BY {g} ORDER BY 1")
    rows = cur.fetchall()
    cur.execute("SELECT cc.column_name FROM user_constraints c JOIN user_cons_columns cc ON cc.constraint_name=c.constraint_name WHERE c.table_name=:t AND c.constraint_type='P' ORDER BY cc.position", t=t)
    pk = [r[0] for r in cur]; coll = "PK무관"
    if "CELL_PROD_SITE_ID" in pk and rows:
        on = " AND ".join(f"B.{c} = A.{c}" for c in pk if c != "CELL_PROD_SITE_ID")
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} A WHERE A.CELL_PROD_SITE_ID IN ('/',' ') AND EXISTS (SELECT 1 FROM SCM_MGR.{t} B WHERE B.CELL_PROD_SITE_ID='-' AND {on})")
        coll = cur.fetchone()[0]
    print(f"{t:40s} DEFAULT={dflt!r:6s} ON_NULL={onn:3s} NULL={nl} PK충돌={coll} | '/' 행 {rows}")
