"""CREATED_BY='E20260921-000253' 출처 추적 (사내) — 소스 문자열 · 원장 행"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb

TOK = "E20260921-000253"
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); print("HOST", cur.fetchone())
    cur.execute("SELECT OWNER, NAME, TYPE, LINE, SUBSTR(TEXT,1,200) FROM ALL_SOURCE WHERE TEXT LIKE :t ORDER BY OWNER, NAME, LINE", t=f"%{TOK}%")
    rows = cur.fetchall(); print("SOURCE hits", len(rows))
    for r in rows: print(r)
    for t in ("DM_PLN_MKT_FCST", "DM_PLN_SALES_PLAN", "DM_PLN_CUST_FCST"):
        try:
            cur.execute(f"""SELECT MEASURE, NVL(CURRENCY,'(NULL)'), MIN(YYYYMMDD), MAX(YYYYMMDD), COUNT(*),
                                   TO_CHAR(MIN(CREATION_DATE),'YYYY-MM-DD HH24:MI') FROM SCM_MGR.{t}
                             WHERE CREATED_BY = :t GROUP BY MEASURE, CURRENCY ORDER BY 1""", t=TOK)
            print(t, cur.fetchall())
        except oracledb.DatabaseError as e:
            print(t, "ERR", e)
    cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='DM_PLN_MKT_FCST' ORDER BY COLUMN_ID")
    print("MKT_FCST cols", [r[0] for r in cur])
