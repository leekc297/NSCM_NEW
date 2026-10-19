# -*- coding: utf-8 -*-
"""QA 조건 모사 2 (사내 ZIOUI1, 읽기 전용 — 조회 프로시저만 호출).

QA [S5]: Peeked Binds 없음 · SCM_MST_SITE_ITEM 추정 15,930 (= 127,440 / 8, 히스토그램이 있는데도 평균) · 커서 BIND_SENSITIVE = N
 → 바인드 값을 보지 않고 계획을 만드는 설정(_optim_peek_user_binds = FALSE)으로 추정.
여기서는 세션에서 바인드 엿보기 · adaptive plans 를 끄고 새로 파싱시켜 QA 계획(262803485 — NESTED LOOPS + VIEW PUSHED PREDICATE)이 재현되는지 본다.

  python _repro_nopeek.py [pkg]      # pkg 기본 PKG_DMF0005 (복제 패키지 검증 시 이름 지정)
"""
import sys, time, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

PKG = sys.argv[1] if len(sys.argv) > 1 else "PKG_DMF0005"
TIMEOUT_MS = 120000
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = TIMEOUT_MS
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
print("DB", d, cur.fetchone(), "PKG", PKG)
for stmt in ('ALTER SESSION SET "_optim_peek_user_binds" = FALSE', "ALTER SESSION SET optimizer_adaptive_plans = FALSE"):
    try:
        cur.execute(stmt); print("OK ", stmt)
    except oracledb.Error as e:
        print("ERR", stmt, str(e).split("\n")[0])

cur.execute("SELECT object_id FROM user_objects WHERE object_name = :n AND object_type = 'PACKAGE BODY'", n=PKG)
body_id = cur.fetchone()[0]


def last_cursor():
    cur.execute("""SELECT sql_id, child_number, plan_hash_value FROM (
                     SELECT sql_id, child_number, plan_hash_value FROM v$sql
                      WHERE program_id = :b AND sql_text LIKE 'WITH ITEM_AGG AS%' AND sql_text LIKE '%OWNER_NM%'
                      ORDER BY last_active_time DESC, last_load_time DESC) WHERE ROWNUM = 1""", b=body_id)
    return cur.fetchone()


shown = set()
for div in ("40", "82", "81"):
    o1, o2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
    t = time.time(); n = 0; err = None
    try:
        cur.callproc(f"SCM_MGR.{PKG}.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION",
                     [div, "ALL", "ALL", "ALL", None, None, "ALL", None, "minyonglee1", o1, o2])
        c = o1.getvalue(); c.arraysize = 5000
        while True:
            rows = c.fetchmany(5000)
            if not rows:
                break
            n += len(rows)
    except oracledb.Error as e:
        err = str(e).split("\n")[0][:80]
    el = time.time() - t
    try:
        con.rollback()
    except oracledb.Error:
        pass
    lc = last_cursor() or ("-", "-", "-")
    print(f"div {div} | {el:7.2f}s | rows {n:>6} | {lc[0]}/{lc[1]} PHV {lc[2]}{'  ❌ ' + err if err else ''}")
    if lc[0] != "-" and (lc[0], lc[2]) not in shown:
        shown.add((lc[0], lc[2]))
        cur.execute("SELECT plan_table_output FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s, :c, 'BASIC +ROWS +PEEKED_BINDS +NOTE'))", s=lc[0], c=lc[1])
        on = False
        for (l,) in cur:
            if l and l.startswith("Plan hash value"):
                on = True
            if on:
                print("    ", l)
