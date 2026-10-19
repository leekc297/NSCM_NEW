"""DMF0082 SAVE_MAIN_DATA 로그 SQL_TEXT 의 꼬리·줄바꿈·인자 수 확인 (사내)"""
import sys, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("""SELECT LOG_SEQ, SQL_TEXT, TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI:SS'), CREATED_BY, ELAPSED_MS, EXCEPTION FROM
                    (SELECT * FROM SCM_MGR.SCM_COM_SQL_LOG WHERE DBMS_LOB.INSTR(SQL_TEXT,'P_DMF0082_SAVE_MAIN_DATA')>0
                      ORDER BY DBMS_LOB.GETLENGTH(SQL_TEXT) DESC) WHERE ROWNUM=1""")
    seq, txt, dt, by, el, ex = cur.fetchone()
    t = txt.read()
    print(seq, dt, by, el, len(t), "CR", t.count("\r"), "LF", t.count("\n"), "TAB", t.count("\t"))
    print("HEAD", t[:120]); print("TAIL", t[-400:])
    print("quotes", t.count("'"), "doubled", t.count("''"))
    lits = re.findall(r"'((?:[^']|'')*)'", t)
    print("literals", len(lits), "max literal len", max(len(x) for x in lits))
    cur.execute("SELECT COUNT(*) FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082' AND OBJECT_NAME='P_DMF0082_SAVE_MAIN_DATA'")
    print("args", cur.fetchone())
