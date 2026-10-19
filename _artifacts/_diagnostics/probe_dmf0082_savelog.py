"""DMF0082 저장 호출이 SCM_COM_SQL_LOG / SCM_COM_SYS_LOG 에 남는 형태 확인 (사내)"""
import sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL"); print(cur.fetchone())
    for t in ("SCM_COM_SQL_LOG", "SCM_COM_SYS_LOG"):
        cur.execute("SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY COLUMN_ID", t=t)
        print(t, cur.fetchall())
    cur.execute("""SELECT SQL_TYPE, REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT,400,1),'PKG_DMF0082\\.[A-Z0-9_]+') PROC, COUNT(*),
                          MAX(DBMS_LOB.GETLENGTH(PARAMS)) MAXLEN, TO_CHAR(MAX(CREATE_DATE),'YYYY-MM-DD HH24:MI') LAST
                     FROM SCM_MGR.SCM_COM_SQL_LOG
                    WHERE DBMS_LOB.INSTR(SQL_TEXT,'PKG_DMF0082')>0
                    GROUP BY SQL_TYPE, REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT,400,1),'PKG_DMF0082\\.[A-Z0-9_]+') ORDER BY 4 DESC NULLS LAST""")
    for r in cur: print(r)
    cur.execute("""SELECT LOG_SEQ, DBMS_LOB.SUBSTR(SQL_TEXT,600,1), DBMS_LOB.GETLENGTH(SQL_TEXT), DBMS_LOB.GETLENGTH(PARAMS), DBMS_LOB.SUBSTR(PARAMS,700,1)
                     FROM (SELECT * FROM SCM_MGR.SCM_COM_SQL_LOG WHERE DBMS_LOB.INSTR(SQL_TEXT,'P_DMF0082_SAVE')>0 ORDER BY DBMS_LOB.GETLENGTH(PARAMS) DESC NULLS LAST)
                    WHERE ROWNUM<=1""")
    for r in cur: print(r)
