"""사내 — DMF0082/DMF0003/DMF0021 저장 계열 callProc 로그: 프로시저별 호출 수 · 문장 길이 · 행 수(인자별 '^' 토큰 최대) 분포"""
import sys, re, collections
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("""SELECT REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT,300,1),'PKG_DMF00(82|03|21)\\.[A-Z0-9_]+') PROC, COUNT(*), MAX(DBMS_LOB.GETLENGTH(SQL_TEXT))
                     FROM SCM_MGR.SCM_COM_SQL_LOG
                    WHERE SQL_ID='com.lgcns.nscm.callProc'
                      AND REGEXP_LIKE(DBMS_LOB.SUBSTR(SQL_TEXT,300,1),'PKG_DMF00(82|03|21)\\.')
                    GROUP BY REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT,300,1),'PKG_DMF00(82|03|21)\\.[A-Z0-9_]+') ORDER BY 1""")
    procs = cur.fetchall()
    for r in procs: print(r)
    # 이름에 SAVE/UPLOAD/INSERT/DELETE 가 든 것 — 호출별 최대 토큰 수
    targets = [r[0] for r in procs if r[0] and re.search(r"SAVE|UPLOAD|INSERT|DELETE|UPDATE|CONFIRM|APPLY|COPY", r[0])]
    print("targets", targets)
    for pr in targets:
        cur.execute("""SELECT LOG_SEQ, TO_CHAR(CREATE_DATE,'YYYY-MM-DD HH24:MI:SS'), CREATED_BY, ELAPSED_MS, SQL_TEXT,
                              CASE WHEN EXCEPTION IS NULL THEN 'OK' ELSE 'EXC' END
                         FROM SCM_MGR.SCM_COM_SQL_LOG
                        WHERE SQL_ID='com.lgcns.nscm.callProc' AND DBMS_LOB.INSTR(SQL_TEXT, :p || '(')>0
                          AND DBMS_LOB.GETLENGTH(SQL_TEXT) > 3000""", p=pr)
        rows = []
        for seq, dt, by, ms, txt, st in cur:
            t = txt.read()
            lits = re.findall(r"'((?:[^']|'')*)'", t)
            mx = max((x.count("^") + 1 for x in lits), default=0)
            rows.append((mx, seq, dt, by, ms, st, len(t), len(lits), t[:160]))
        rows.sort(reverse=True)
        print("==", pr, "calls>3000chars", len(rows))
        for r in rows[:6]: print("  ", r[:8]);
        if rows: print("   HEAD", rows[0][8])
