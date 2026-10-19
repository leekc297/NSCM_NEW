"""GAP 476 — SYS0014 Group User: 사업부 권한 한 줄을 지워도 그 사업부에 딸린 하위(공장·고객) 권한 줄이 남음 (사내 ZIOUI1 적용기).

AS-IS UP_FX_DeleteUserGroupAuthExtention (LGCE_SCMDEV 직접 조회 2026-10-15, GroupUserInfo.cs L605 DeleteQueryId):
    DELETE TB_FX_UserGroupAuthExtention WHERE GroupID, UserID, AuthType, Code, PrntCode      -- 그 줄
    DELETE SCM_MST_AUTH_REQUEST ...                                                           -- (GAP473 반영)
    IF @AuthType = 'D' → DELETE TB_FX_UserGroupAuthExtention WHERE GroupID, UserID, PrntCode = @Code   -- ★ 하위 권한 전부
TO-BE PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M unit_auth DELETE: 고른 줄(4키)만 삭제 → 하위 권한 잔존.
보완: unit_auth DELETE 문 바로 앞에 'UNIT_TP_CD=D 삭제 행 → 같은 그룹·사용자의 UPPR_UNIT_ID = 그 UNIT_ID 행 삭제' 1문장 삽입.
      (TO-BE 매핑: AuthType=UNIT_TP_CD · Code=UNIT_ID · PrntCode=UPPR_UNIT_ID)

절차(#152): fetch(착수 조회본 백업) → apply(FRESH-GATE 재조회==기준본 → 구간 내 고유 1건 치환 → CREATE OR REPLACE
           → VALID·오류 0·적용본==DB 원문·의존 INVALID 0, 실패 시 원문 복원) / rollback
사용: python apply_gap476.py fetch | apply | rollback
"""
import os, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ASIS = os.path.join(HERE, "PKG_SYS0014_BODY.ASIS.sql")
TOBE = os.path.join(HERE, "PKG_SYS0014_BODY.TOBE.sql")
PKG = "PKG_SYS0014"
MARK = "GAP476 2026-10-15"
P_A = "\nPROCEDURE P_SYS0014_SAVE_GROUP_USER_M ("
P_B = "\nEND P_SYS0014_SAVE_GROUP_USER_M;"

OLD1 = """    DELETE FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M T
     WHERE (T.USER_GR_ID, T.USER_ID, T.UNIT_TP_CD, T.UNIT_ID) IN (
"""
NEW1 = f"""    -- [{MARK}] AS-IS UP_FX_DeleteUserGroupAuthExtention parity: deleting a division (UNIT_TP_CD='D') row
    --   also deletes the sub auth rows under it (same group/user, UPPR_UNIT_ID = that division)
    DELETE FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M C
     WHERE EXISTS (
         SELECT 1 FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
             V_SHT_NM     VARCHAR2(30) PATH '$.SHT_NM',
             V_CRUD_TYPE  VARCHAR2(1)  PATH '$.CRUD_TYPE',
             V_USER_GR_ID VARCHAR2(50) PATH '$.USER_GR_ID',
             V_USER_ID    VARCHAR2(50) PATH '$.USER_ID',
             V_UNIT_TP_CD VARCHAR2(10) PATH '$.UNIT_TP_CD',
             V_UNIT_ID    VARCHAR2(50) PATH '$.UNIT_ID'
         )) J
          WHERE J.V_SHT_NM = 'Division' AND J.V_CRUD_TYPE = 'D' AND J.V_UNIT_TP_CD = 'D'
            AND C.USER_GR_ID   = J.V_USER_GR_ID
            AND C.USER_ID      = J.V_USER_ID
            AND C.UPPR_UNIT_ID = J.V_UNIT_ID
     );
{OLD1}"""

PAIRS = [(OLD1, NEW1)]


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


def transform(src, pairs):
    a = src.index(P_A); b = src.index(P_B, a)
    seg = src[a:b]
    for old, new in pairs:
        assert seg.count(old) == 1, f"대상 매칭 {seg.count(old)} != 1 — 원문이 바뀌었거나 이미 반영됨: {old!r}"
        seg = seg.replace(old, new)
    return src[:a] + seg + src[b:]


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
        open(TOBE, "w", encoding="utf-8", newline="").write(transform(base, PAIRS))
        print("FETCHED", meta, datetime.datetime.now(), "lines", base.count("\n"))
        return
    base = open(ASIS, encoding="utf-8", newline="").read()
    tobe = open(TOBE, encoding="utf-8", newline="").read()
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
    now, meta = fetch(cur)
    if mode == "apply":
        assert now == base, "FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합"
        assert transform(base, PAIRS) == tobe and tobe.count(MARK) == 1
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
