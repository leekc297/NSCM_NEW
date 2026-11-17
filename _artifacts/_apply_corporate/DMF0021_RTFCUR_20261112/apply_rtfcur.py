# -*- coding: utf-8 -*-
"""사내(ZIOUI1) PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 보완 [E20261112-RTFCUR] (2026-11-12)
증상: 환율 적용 후 DMF0021 에 같은 키의 RTF 행이 통화 없는 행으로 하나 더 생김.
원인: RTF/RTF_SYS_RP/RTF_PR 원장 행 재생성 시 통화를 '같은 기간 단가'에서만 가져옴 → 단가 없는 기간(수량 0)은 통화 NULL.
보완: 단가에서 통화를 못 얻으면 원장의 같은 키·같은 일자 RTF 계열 행 통화를 유지.
절차: 최신 원문 조회 → 기준 문구 단언 → ASIS 백업 → FRESH-GATE → CREATE OR REPLACE → VALID/오류 0 확인.
사용: python apply_rtfcur.py [--apply]"""
import sys, pathlib, oracledb
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info
HERE = pathlib.Path(__file__).resolve().parent
OWNER, NAME = "SCM_MGR", "PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW"
MARK = "[E20261112-RTFCUR]"
SPLIT = "/* ==================== RTF 기반 SalesAmt 생성 -> #SALES_PLAN_TEMP_LOC (40 / 그외) ==================== */"
OLD = ", W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD, SI.CURRENCY\n"
NEW = (", W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD\n"
       "                                  -- , SI.CURRENCY   -- 2026.11.12 원본\n"
       "                                  /* " + MARK + " 단가 없는 기간은 통화가 비어 조회 화면에 통화 없는 행이 따로 생김 → 원장의 같은 키·같은 일자 RTF 계열 통화 유지 */\n"
       "                                  , COALESCE( SI.CURRENCY\n"
       "                                            , ( SELECT MAX(SP.CURRENCY)\n"
       "                                                  FROM DM_PLN_SALES_PLAN SP\n"
       "                                                 WHERE SP.DIVISION_ID       = W.DIVISION_ID\n"
       "                                                   AND SP.PROJECT_CODE      = W.PROJECT_CODE\n"
       "                                                   AND SP.SCM_SITE_ID       = W.SCM_SITE_ID\n"
       "                                                   AND SP.ITEM_ID           = W.ITEM_ID\n"
       "                                                   AND SP.DOM_EXP           = W.DOM_EXP\n"
       "                                                   AND SP.FCST_TYPE         = W.FCST_TYPE\n"
       "                                                   AND SP.INCOTERMS         = W.INCOTERMS\n"
       "                                                   AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID\n"
       "                                                   AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID\n"
       "                                                   AND SP.YYYYMMDD          = W.YYYYMMDD\n"
       "                                                   AND SP.MEASURE IN ( 'RTF', 'RTF_SYS_RP', 'RTF_SCP', 'RTF_PR' ) ) ) AS CURRENCY\n")

def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE='PROCEDURE'", o=OWNER, n=NAME)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", o=OWNER, n=NAME)
    return ddl, st, "".join(r[0] for r in cur)

def invalid(cur):
    cur.execute("SELECT OBJECT_TYPE||' '||OBJECT_NAME FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS='INVALID' ORDER BY 1", o=OWNER)
    return [r[0] for r in cur]

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST')||'/'||SYS_CONTEXT('USERENV','SERVICE_NAME')||' '||TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print("DB", cur.fetchone()[0])
    ddl0, st0, src = fetch(cur)
    print("기준본 LAST_DDL", ddl0, st0, "글자", len(src), "줄", src.count("\n"))
    assert MARK not in src, "이미 적용됨"
    assert src.count(SPLIT) == 1, ("구간 머리말", src.count(SPLIT))
    head, tail = src.split(SPLIT)
    assert head.count(OLD) == 1 and tail.count(OLD) == 2, ("기준 문구", head.count(OLD), tail.count(OLD))
    new = head + SPLIT + tail.replace(OLD, NEW)
    assert new.count(MARK) == 2
    (HERE / f"{NAME}.ASIS.sql").write_text(src, encoding="utf-8", newline="")
    (HERE / f"{NAME}.TOBE.sql").write_text(new, encoding="utf-8", newline="")
    print("TOBE 글자", len(new), "줄", new.count("\n"), "늘어난 줄", new.count("\n") - src.count("\n"))
    if "--apply" not in sys.argv:
        print("미적용(점검만)"); sys.exit(0)
    inv0 = invalid(cur)
    ddl1, _, src1 = fetch(cur)
    assert ddl1 == ddl0 and src1 == src, "FRESH-GATE 불일치 — 중단"
    print("FRESH-GATE 통과")
    cur.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
    cur.execute("CREATE OR REPLACE " + new.rstrip().rstrip("/").rstrip())
    ddl2, st2, src2 = fetch(cur)
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n ORDER BY SEQUENCE", o=OWNER, n=NAME)
    errs = cur.fetchall()
    print("적용 후 LAST_DDL", ddl2, st2, "오류", len(errs), errs[:5])
    print("적용본 == DB 원문", src2.rstrip() == new.rstrip().rstrip("/").rstrip())
    inv1 = invalid(cur)
    print("INVALID 전", len(inv0), "후", len(inv1), "새로 무효", sorted(set(inv1) - set(inv0)))
