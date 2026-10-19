"""GAP 418 — DMF0072 저장 방식: 존재 확인에 End Customer 포함 → AS-IS MERGE ON 과 같은 키로 (사내 ZIOUI1 적용기).

AS-IS DMF0072_SAVE_NNMASTER_MAPPING (LGCE_SCMDEV 2025-01-21) MERGE ON:
    DATA_TYPE_CODE · DIVISION_ID · COMPANY_ID · SOLDTO · SHIPTO · UNLOADING_POINT · CUSTOMER_PLANT · CUSTOMER_ITEM_ID
    · SCM_SITE_ID · PROJECT_CODE · FCST_TYPE · INCOTERMS · DOM_EXP · ITEM_ID · MAPPING_ITEM_ID(=ORIGINAL) · ACT_TYPE='M'
    `--AND A.END_CUSTOMER = B.END_CUSTOMER` 주석 (End Customer 는 PK 아님 → 매칭 키 제외)
TO-BE P_DMF0072_SAVE_NNMASTER_MAPPING: 행별 존재 확인 + UPDATE WHERE 에 END_CUSTOMER 포함.
    SCM 기존 행은 End Customer 편집 가능(AS-IS .cs L1443 SCM 행 미잠금 · TO-BE beginningEdit 동일)
    → End Customer 만 바꾼 수정(M) 행: AS-IS = 같은 원장 행 UPDATE(End Customer 는 미갱신) / TO-BE = 미매칭 → INSERT → ORA-00001(PK) 저장 실패.
보완: 존재 확인 SELECT · UPDATE WHERE 의 END_CUSTOMER 조건 2줄을 AS-IS 처럼 주석 처리. 행별 루프 구조는 유지
      (MERGE 는 ON 컬럼 MAPPING_ITEM_ID 를 갱신해야 해 ORA-38104 — 원문 주석 사유. 결과는 AS-IS 와 같다).

⚠ 선행 = GAP412 (신규 I 행 PK 중복 → 저장 실패). 412 없이 418 만 적용하면, End Customer 만 다른 같은 PK 신규 행이
  ORA-00001 대신 기존 행 UPDATE(덮어쓰기)로 바뀐다 → apply 는 DB 원문 == GAP412 적용본일 때만 진행.

절차(#152): fetch(착수 조회본 = ALL_SOURCE 새로고침 기록 · 412 적용본 위 418 적용본 생성)
           → apply(FRESH-GATE 재조회 == 412 적용본 → 2줄 치환 → CREATE OR REPLACE → VALID·오류 0·적용본==DB, 실패 시 원문 복원) / rollback
사용: python apply_gap418.py fetch | apply | rollback
"""
import os, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
G412 = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0072_GAP412_20261015"
FETCHED = os.path.join(HERE, "PKG_DMF0072_BODY.FETCHED.sql")   # 착수 시 DB 조회본 (기록)
BASE = os.path.join(HERE, "PKG_DMF0072_BODY.ASIS.sql")         # 418 기준본 = GAP412 적용본 (원복 대상)
TOBE = os.path.join(HERE, "PKG_DMF0072_BODY.TOBE.sql")
PKG = "PKG_DMF0072"
MARK = "GAP418 2026-10-15"
MARK412 = "GAP412 2026-10-15"
P_A = "\nPROCEDURE P_DMF0072_SAVE_NNMASTER_MAPPING\n"
P_B = "\nEND P_DMF0072_SAVE_NNMASTER_MAPPING;"
REPL = [
    ("          AND  A.END_CUSTOMER    = REC.END_CUSTOMER\n",
     f"          --AND  A.END_CUSTOMER    = REC.END_CUSTOMER  -- [{MARK}] AS-IS MERGE ON excludes END_CUSTOMER (not in PK)\n"),
    ("              AND A.END_CUSTOMER    = REC.END_CUSTOMER\n",
     f"              --AND A.END_CUSTOMER    = REC.END_CUSTOMER  -- [{MARK}] AS-IS MERGE ON excludes END_CUSTOMER (not in PK)\n"),
]


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


def rd(path):
    return open(path, encoding="utf-8", newline="").read()


def ddl(src):
    return "CREATE OR REPLACE " + src


def transform(src, pairs):
    a = src.index(P_A); b = src.index(P_B, a)
    seg = src[a:b]
    for old, new in pairs:
        assert seg.count(old) == 1, f"대상 매칭 {seg.count(old)} != 1 — 원문이 바뀌었거나 이미 반영됨: {old.strip()}"
        seg = seg.replace(old, new)
    return src[:a] + seg + src[b:]


def compile_and_check(cur, src, expect):
    try:
        cur.execute(ddl(src))
    except oracledb.DatabaseError as e:
        print("CREATE 예외(컴파일 오류 동반 가능):", str(e).splitlines()[0])
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=PKG)
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE", n=PKG)
    errs = cur.fetchall()
    now, meta = fetch(cur)
    cur.execute("SELECT COUNT(*) FROM USER_OBJECTS WHERE STATUS<>'VALID' AND OBJECT_NAME IN "
                "(SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME=:n)", n=PKG)
    dep_invalid = cur.fetchone()[0]
    print("STATUS", st, meta, "ERRORS", len(errs), "DEP_INVALID", dep_invalid, "DB==expect", now == expect)
    for e in errs[:10]:
        print("  ERR", e)
    return st == "VALID" and not errs and now == expect


def main():
    mode = sys.argv[1]
    con, cur = connect()
    g412_pre, g412_tobe = rd(os.path.join(G412, "PKG_DMF0072_BODY.ASIS.sql")), rd(os.path.join(G412, "PKG_DMF0072_BODY.TOBE.sql"))
    if mode == "fetch":
        now, meta = fetch(cur)
        open(FETCHED, "w", encoding="utf-8", newline="").write(now)
        state = "GAP412 적용본" if now == g412_tobe else ("GAP412 수정 전" if now == g412_pre else "기타(변경됨)")
        assert state != "기타(변경됨)", "착수 조회본이 GAP412 전/후 어느 쪽과도 다름 — 412·418 재조회·재병합"
        open(BASE, "w", encoding="utf-8", newline="").write(g412_tobe)
        open(TOBE, "w", encoding="utf-8", newline="").write(transform(g412_tobe, REPL))
        print("FETCHED", meta, datetime.datetime.now(), "DB 상태 =", state)
        return
    base, tobe = rd(BASE), rd(TOBE)
    # FRESH-GATE: 적용 직전 DB 원문 재조회
    now, meta = fetch(cur)
    if mode == "apply":
        assert now == base, ("FRESH-GATE 실패: DB 원문 != GAP412 적용본 — "
                             + ("GAP412 를 먼저 적용" if now == g412_pre else "착수 후 변경됨, 재조회·재병합"))
        assert transform(base, REPL) == tobe and tobe.count(MARK) == 2 and tobe.count(MARK412) == 1
        if not compile_and_check(cur, tobe, tobe):
            try:
                cur.execute(ddl(base))
            finally:
                print("컴파일/검증 실패 → GAP412 적용본으로 복원")
            sys.exit(1)
        print("APPLIED", MARK, meta)
    elif mode == "rollback":
        assert now == tobe, "FRESH-GATE 실패: 현재 DB 원문 != 418 적용본 — 중단"
        print("ROLLED BACK (GAP412 적용본으로)" if compile_and_check(cur, base, base) else "ROLLBACK 검증 실패")


if __name__ == "__main__":
    main()
