# -*- coding: utf-8 -*-
"""힌트 적용본(E20261014-DMF0005NOPUSH) 조회 문장 계획 줄별 실측 — QA 조건 모사 (사내 ZIOUI1, 읽기 전용)

세션: _optim_peek_user_binds = FALSE · optimizer_adaptive_plans = FALSE · statistics_level = ALL
사업부별 1회 실행 → DBMS_XPLAN ALLSTATS LAST (A-Rows · Starts · A-Time · Buffers) 출력 + 함수 내부 SQL 실행 횟수.

  python _profile_qa_mode.py [div ...]     # 기본 81 82 40
"""
import sys, time, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIVS = sys.argv[1:] or ["81", "82", "40"]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), SYS_CONTEXT('USERENV','SID') FROM dual")
host, now, sid = cur.fetchone()
print("DB", d, host, now)
for s in ('ALTER SESSION SET "_optim_peek_user_binds" = FALSE', "ALTER SESSION SET optimizer_adaptive_plans = FALSE",
          "ALTER SESSION SET statistics_level = ALL"):
    cur.execute(s)

FN_SQL = """SELECT NVL(SUM(executions),0), NVL(SUM(elapsed_time),0), NVL(SUM(buffer_gets),0) FROM v$sql
             WHERE program_id IN (SELECT object_id FROM user_objects WHERE object_name IN ('FN_GET_MULTI_OWNER_NAME','FN_GET_DEPT_LIST'))"""
for div in DIVS:
    cur.execute(FN_SQL); f0 = cur.fetchone()
    o1, o2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    t = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION",
                 [div, "ALL", "ALL", "ALL", None, None, "ALL", None, "minyonglee1", o1, o2])
    c = o1.getvalue(); c.arraysize = 5000
    n = len(c.fetchall())
    el = time.time() - t
    con.rollback()
    cur.execute(FN_SQL); f1 = cur.fetchone()
    cur.execute("""SELECT prev_sql_id, prev_child_number FROM v$session WHERE sid = :s""", s=sid)
    cur.execute("""SELECT sql_id, child_number FROM (SELECT sql_id, child_number FROM v$sql
                    WHERE sql_text LIKE 'WITH ITEM_AGG AS%' AND DBMS_LOB.INSTR(sql_fulltext, 'NO_PUSH_PRED') > 0
                    ORDER BY last_active_time DESC) WHERE ROWNUM = 1""")
    sq, ch = cur.fetchone()
    print(f"\n### div {div} | {el:.2f}s | {n}행 | {sq}/{ch} | 함수 내부 SQL {f1[0]-f0[0]}회 {((f1[1]-f0[1])/1e6):.2f}s BG {f1[2]-f0[2]}")
    cur.execute("SELECT plan_table_output FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s, :c, 'ALLSTATS LAST -PREDICATE -NOTE'))", s=sq, c=ch)
    on = False
    for (l,) in cur:
        on = on or bool(l and l.startswith("Plan hash value"))
        if on:
            print("   ", l)
