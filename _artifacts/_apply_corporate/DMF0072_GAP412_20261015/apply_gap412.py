"""GAP 412 — DMF0072 신규(I) 행 키 중복 시 기존 행 덮어쓰기 → AS-IS 처럼 저장 실패 (사내 ZIOUI1 적용기).

AS-IS DMF0072_SAVE_NNMASTER_MAPPING (LGCE_SCMDEV modify 2025-01-21):
    MERGE ... ON (PK 15컬럼 대응 ... AND B.ACT_TYPE = 'M') WHEN NOT MATCHED THEN INSERT
    → I 행은 항상 INSERT. 기존 행과 PK(DM_CUST_MODEL_MAPPING_M_PK 15컬럼, END_CUSTOMER 미포함)가 같으면
      PK 위반 → CATCH → 'F' + 오류 메시지. MERGE 1문장이라 같이 보낸 행 전부 미반영.
TO-BE PKG_DMF0072.P_DMF0072_SAVE_NNMASTER_MAPPING: 커서 ACT_TYPE IN ('M','I') (2026.08.13 AJS) + 존재 시 UPDATE
    → I 행이 기존 행의 Valid From/To · Active · Mapping Item 을 오류 없이 덮어씀.
보완: 루프 안 존재 확인 직후, I 행이 PK 동일 기존 행(센티널 '-'/'--'/'/'/공백 동치, GAP413 과 같은 정규화)과 겹치면
      RAISE → 기존 EXCEPTION 이 ROLLBACK (= AS-IS 저장 실패, 같이 보낸 행 전부 미반영). M 행 처리 · AJS 커서 변경 유지.

절차(#152): fetch(착수 조회본 백업) → apply(FRESH-GATE 재조회==기준본 → 구간 내 고유 1건 치환 → CREATE OR REPLACE
           → VALID·오류 0·적용본==DB 원문·의존 INVALID 0, 실패 시 원문 복원) / rollback
사용: python apply_gap412.py fetch | apply | rollback
"""
import os, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ASIS = os.path.join(HERE, "PKG_DMF0072_BODY.ASIS.sql")
TOBE = os.path.join(HERE, "PKG_DMF0072_BODY.TOBE.sql")
PKG = "PKG_DMF0072"
MARK = "GAP412 2026-10-15"
P_A = "\nPROCEDURE P_DMF0072_SAVE_NNMASTER_MAPPING\n"
P_B = "\nEND P_DMF0072_SAVE_NNMASTER_MAPPING;"

OLD = "        IF V_EXISTS_CNT > 0 THEN\n"
NV = lambda c: f"NVL(NULLIF(NULLIF(NULLIF(TRIM({c}),'-'),'--'),'/'), '@#@#@#')"
NEW = f"""        -- [{MARK}] AS-IS parity: new(I) row with the same PK as an existing row -> save fails
        --   (AS-IS MERGE inserts every I row -> PK violation -> nothing saved). No overwrite of the existing row.
        IF REC.ACT_TYPE = 'I' THEN
            DECLARE
                L_DUP_CNT  PLS_INTEGER := 0;
            BEGIN
                SELECT COUNT(1)
                INTO   L_DUP_CNT
                FROM   SCM_MGR.DM_CUST_MODEL_MAPPING_M A
                WHERE  A.DATA_TYPE_CODE  = REC.DATA_TYPE_CODE
                  AND  A.DIVISION_ID     = P_DIVISION_ID
                  AND  A.COMPANY_ID      = REC.COMPANY_ID
                  AND  A.SOLDTO_CODE     = REC.SOLDTO_CODE
                  AND  A.SHIPTO_CODE     = REC.SHIPTO_CODE
                  AND  {NV('A.UNLOADING_POINT')} = {NV('REC.UNLOADING_POINT')}
                  AND  {NV('A.CUSTOMER_PLANT')} = {NV('REC.CUSTOMER_PLANT')}
                  AND  {NV('A.CUSTOMER_ITEM_ID')} = {NV('REC.CUSTOMER_ITEM_ID')}
                  AND  A.SCM_SITE_ID     = REC.SCM_SITE_ID
                  AND  A.PROJECT_CODE    = REC.PROJECT_CODE
                  AND  A.FCST_TYPE       = REC.FCST_TYPE
                  AND  A.INCOTERMS       = REC.INCOTERMS
                  AND  A.DOM_EXP         = REC.DOM_EXP
                  AND  A.ITEM_ID         = REC.ITEM_ID
                  AND  A.MAPPING_ITEM_ID = REC.MAPPING_ITEM_ID;
                IF L_DUP_CNT > 0 THEN
                    RAISE_APPLICATION_ERROR(-20072,
                        'Duplicate key: the same mapping already exists. Nothing was saved. ('
                        || 'Data Type=' || REC.DATA_TYPE_CODE || ', Company=' || REC.COMPANY_ID
                        || ', Sold To=' || REC.SOLDTO_CODE || ', Ship To=' || REC.SHIPTO_CODE
                        || ', Sales Site=' || REC.SCM_SITE_ID || ', Project=' || REC.PROJECT_CODE
                        || ', Customer Item=' || REC.CUSTOMER_ITEM_ID || ', Item=' || REC.ITEM_ID
                        || ', Mapping Item=' || REC.MAPPING_ITEM_ID || ')');
                END IF;
            END;
        END IF;

        IF V_EXISTS_CNT > 0 THEN
"""


def connect():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL")
    print("DB", d, cur.fetchone())
    return con, cur


def fetch(cur):
    """ALL_SOURCE 최신 원문 + LAST_DDL_TIME (새로고침)."""
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=PKG)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=PKG)
    return "".join(r[0] for r in cur), meta


def ddl(src):
    return "CREATE OR REPLACE " + src


def transform(src, old, new):
    a = src.index(P_A); b = src.index(P_B, a)
    seg = src[a:b]
    assert seg.count(old) == 1, f"대상 매칭 {seg.count(old)} != 1 — 원문이 바뀌었거나 이미 반영됨"
    return src[:a] + seg.replace(old, new) + src[b:]


def compile_and_check(cur, src, expect):
    try:
        cur.execute(ddl(src))
    except oracledb.DatabaseError as e:
        print("CREATE 예외(컴파일 오류 동반 가능):", str(e).splitlines()[0])
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS "
                "WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=PKG)
    st = cur.fetchone()
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", n=PKG)
    errs = cur.fetchall()
    now, _ = fetch(cur)
    cur.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE STATUS<>'VALID' AND OBJECT_NAME IN "
                "(SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME=:n)", n=PKG)
    dep_invalid = cur.fetchone()[0]
    print("STATUS", st, "ERRORS", len(errs), "DEP_INVALID", dep_invalid, "DB==expect", now == expect)
    for e in errs[:10]:
        print("  ERR", e)
    return st[0] == "VALID" and not errs and now == expect


def main():
    mode = sys.argv[1]
    con, cur = connect()
    if mode == "fetch":
        base, meta = fetch(cur)
        open(ASIS, "w", encoding="utf-8", newline="").write(base)
        open(TOBE, "w", encoding="utf-8", newline="").write(transform(base, OLD, NEW))
        print("FETCHED", meta, datetime.datetime.now(), "lines", base.count("\n"))
        return
    base = open(ASIS, encoding="utf-8", newline="").read()
    tobe = open(TOBE, encoding="utf-8", newline="").read()
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    now, meta = fetch(cur)
    if mode == "apply":
        assert now == base, "FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합"
        assert transform(base, OLD, NEW) == tobe and tobe.count(MARK) == 1
        if not compile_and_check(cur, tobe, tobe):
            try:
                cur.execute(ddl(base))
            finally:
                print("컴파일/검증 실패 → 원문 복원")
            sys.exit(1)
        print("APPLIED", MARK, meta)
    elif mode == "rollback":
        assert now == tobe, "FRESH-GATE 실패: 현재 DB 원문 != 적용본 — 중단"
        print("ROLLED BACK" if compile_and_check(cur, base, base) else "ROLLBACK 검증 실패")


if __name__ == "__main__":
    main()
