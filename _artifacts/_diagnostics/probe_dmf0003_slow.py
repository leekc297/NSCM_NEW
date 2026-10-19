"""사내 — DMF0003 저장 호출 중 120초 초과 건 (건수·결과)"""
import sys, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("""SELECT LOG_SEQ, TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI:SS'), CREATED_BY, ELAPSED_MS, SQL_TEXT,
                          CASE WHEN EXCEPTION IS NULL THEN 'OK' ELSE DBMS_LOB.SUBSTR(EXCEPTION,200,1) END
                     FROM SCM_MGR.SCM_COM_SQL_LOG
                    WHERE SQL_ID='com.lgcns.nscm.callProc' AND DBMS_LOB.INSTR(SQL_TEXT,'PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST(')>0
                      AND ELAPSED_MS > 120000 ORDER BY ELAPSED_MS DESC""")
    for seq, dt, by, ms, txt, res in cur:
        t = txt.read()
        first = re.match(r"\{call [^(]+\( '([^']*)'", t)
        print(seq, dt, by, ms, "len", len(t), "rows", first.group(1).count("^") + 1 if first else "?", res, "|", t[:200])
