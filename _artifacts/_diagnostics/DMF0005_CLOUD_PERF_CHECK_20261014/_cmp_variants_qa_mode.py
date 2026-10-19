# -*- coding: utf-8 -*-
"""변형 패키지들의 QA 조건 모사 계획 비교 (사내 ZIOUI1, 읽기 전용 — 조회 프로시저만 호출)

  python _cmp_variants_qa_mode.py PKG_DMF0005 PKG_DMF0005_V2A PKG_DMF0005_V2B
세션: _optim_peek_user_binds = FALSE · optimizer_adaptive_plans = FALSE · statistics_level = ALL
패키지마다 82 · 81 · 40 1회 → 시간 · 계획의 VW_DCL / VIEW PUSHED PREDICATE / NESTED LOOPS 줄과 그 Starts · A-Time
"""
import sys, time, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual")
print("DB", d, cur.fetchone())
for s in ('ALTER SESSION SET "_optim_peek_user_binds" = FALSE', "ALTER SESSION SET optimizer_adaptive_plans = FALSE",
          "ALTER SESSION SET statistics_level = ALL"):
    cur.execute(s)
for pkg in sys.argv[1:]:
    cur.execute("SELECT object_id FROM user_objects WHERE object_name = :n AND object_type = 'PACKAGE BODY'", n=pkg)
    for div in ("82", "81", "40"):
        o1, o2 = cur.var(oracledb.DB_TYPE_CURSOR), cur.var(oracledb.DB_TYPE_CURSOR)
        t = time.time()
        cur.callproc(f"SCM_MGR.{pkg}.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION",
                     [div, "ALL", "ALL", "ALL", None, None, "ALL", None, "minyonglee1", o1, o2])
        c = o1.getvalue(); c.arraysize = 5000
        n = len(c.fetchall()); el = time.time() - t
        con.rollback()
        cur.execute("""SELECT sql_id, child_number, plan_hash_value FROM (SELECT sql_id, child_number, plan_hash_value FROM v$sql
                        WHERE sql_text LIKE 'WITH ITEM_AGG AS%' ORDER BY last_active_time DESC) WHERE ROWNUM = 1""")
        sq, ch, phv = cur.fetchone()
        cur.execute("""SELECT id, LPAD(' ', depth) || operation || ' ' || options op, object_name, last_starts, ROUND(last_elapsed_time/1e6, 2)
                         FROM v$sql_plan_statistics_all WHERE sql_id = :s AND child_number = :c
                          AND (options = 'PUSHED PREDICATE' OR object_name LIKE 'VW_DCL%' OR object_name LIKE 'VW_LAT%' OR operation = 'NESTED LOOPS'
                               OR object_name IN ('SCM_MST_SITE_CUSTOMER','IDX01_SCM_MST_SITE_ITEM'))
                        ORDER BY id""", s=sq, c=ch)
        rows = cur.fetchall()
        print(f"{pkg:<16} div {div} | {el:6.2f}s | {n}행 | {sq}/{ch} PHV {phv}")
        for r in rows:
            print(f"      {r[0]:>3} {r[1]:<44} {str(r[2] or ''):<28} starts {r[3]:>6} {r[4]:>7}s")
