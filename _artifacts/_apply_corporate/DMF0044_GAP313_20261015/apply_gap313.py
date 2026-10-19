"""GAP 313 — DMF0044 Cutoff 저장 후 전송 완료(SEND_YN='Y') 버전 전송 데이터 재생성 (사내 ZIOUI1 적용기).

AS-IS DMF0044_SAVE_SALES_PLAN_REPORT_C_CF (LGCE_SCMDEV, modify 2026-02-03) L2773~2781:
    IF EXISTS (... DM_MDF_VERSION ... SEND_YN = 'Y') EXEC DMF0044_MOBILE_REPORT_CREATE @div, @ver, @cutoff_type, N'T', @created_by
TO-BE PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF: 같은 호출이 '/* TODO ... */' 주석으로 차단 → 재생성 미실행.
보완: 주석 해제 + 패키지 내 P_DMF0044_MOBILE_REPORT_CREATE(6인자) 호출.
      (주석 원문은 존재하지 않는 standalone SCM_MGR.DMF0044_MOBILE_REPORT_CREATE 5인자 호출이라 그대로 풀면 컴파일 불가)
      재생성 실패(검증 메시지 반환 포함) = RAISE → CF EXCEPTION ROLLBACK (AS-IS 중첩 트랜잭션에서 내부 ROLLBACK = 저장 전체 취소와 동일).

절차(#152): ① 착수 시 ALL_SOURCE 조회본(base) 백업 ② FRESH-GATE 적용 직전 재조회 == base ③ 외과 치환(고유 1건 assert)
           ④ CREATE OR REPLACE ⑤ VALID · 오류 0 · 적용본 == DB 원문 · 의존 INVALID 0
사용: python apply_gap313.py fetch | apply | rollback
"""
import os, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ASIS = os.path.join(HERE, "PKG_DMF0044_BODY.ASIS.sql")      # 원복용 = 착수 시 DB 조회본
TOBE = os.path.join(HERE, "PKG_DMF0044_BODY.TOBE.sql")
MARK = "GAP313 2026-10-15"

OLD = """    /* TODO DMF0044_MOBILE_REPORT_CREATE
    IF V_EXISTS = 1 THEN
        SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(V_DIVISION_ID, V_VERSION_NO, V_CUTOFF_TYPE, 'T', V_CREATED_BY);
    END IF;
    */
"""
NEW = """    /* [GAP313 2026-10-15] TODO released - AS-IS DMF0044_SAVE_SALES_PLAN_REPORT_C_CF parity:
       SEND_YN='Y' version -> regenerate transfer data (ACTION 'T') after cutoff save.
       Regeneration failure (validation message or error) -> RAISE -> whole save ROLLBACK (AS-IS nested TRAN rollback). */
    IF V_EXISTS = 1 THEN
        DECLARE
            L_MOB_RC   SYS_REFCURSOR;
            L_MOB_MSG  VARCHAR2(4000 CHAR);
        BEGIN
            P_DMF0044_MOBILE_REPORT_CREATE(V_DIVISION_ID, V_VERSION_NO, V_CUTOFF_TYPE, 'T', V_CREATED_BY, L_MOB_RC);
            FETCH L_MOB_RC INTO L_MOB_MSG;
            CLOSE L_MOB_RC;
            IF NVL(L_MOB_MSG, '-') <> 'success' THEN
                RAISE_APPLICATION_ERROR(-20044, L_MOB_MSG);
            END IF;
        END;
    END IF;
"""
# 대상 = CF 프로시저 구간 안에서만 (같은 TODO 형태가 다른 SP 에 있어도 건드리지 않도록 구간 고정)
P_A = "\nPROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF\n"
P_B = "\nEND P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF;"


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
                "WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' AND OBJECT_TYPE='PACKAGE BODY'")
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' "
                "AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return "".join(r[0] for r in cur), meta


def ddl(src):
    return "CREATE OR REPLACE " + src


def transform(src, old, new):
    a = src.index(P_A); b = src.index(P_B, a)
    seg = src[a:b]
    assert seg.count(old) == 1, f"대상 매칭 {seg.count(old)} != 1 — 원문이 바뀌었거나 이미 반영됨"
    return src[:a] + seg.replace(old, new) + src[b:]


def compile_and_check(cur, src, expect):
    cur.execute(ddl(src))
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS "
                "WHERE OBJECT_NAME='PKG_DMF0044' AND OBJECT_TYPE='PACKAGE BODY'")
    st = cur.fetchone()
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE")
    errs = cur.fetchall()
    now, _ = fetch(cur)
    cur.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE STATUS<>'VALID' AND OBJECT_NAME IN "
                "(SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0044')")
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
        ok = compile_and_check(cur, tobe, tobe)
        if not ok:
            cur.execute(ddl(base)); print("컴파일/검증 실패 → 원문 복원")
            sys.exit(1)
        print("APPLIED", MARK, meta)
    elif mode == "rollback":
        assert now == tobe, "FRESH-GATE 실패: 현재 DB 원문 != 적용본 — 중단"
        print("ROLLED BACK" if compile_and_check(cur, base, base) else "ROLLBACK 검증 실패")


if __name__ == "__main__":
    main()
