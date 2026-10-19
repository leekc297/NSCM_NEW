"""GAP 473 — SYS0014 Group User: 사용자를 그룹에서 빼거나 사업부 권한을 지워도 권한 요청 기록(SCM_MST_AUTH_REQUEST)이 남음 (사내 ZIOUI1 적용기).

AS-IS (LGCE_SCMDEV 직접 조회 2026-10-15, GroupUserInfo.cs L536/L605 의 DeleteQueryId):
    UP_FX_DeleteUserGroupInfo        : TB_FX_UserGroupInfo · TB_FX_UserGroupAuthExtention 삭제 +
                                       DELETE SCM_MST_AUTH_REQUEST WHERE GROUP_ID=@GroupID AND USER_ID=@UserID
    UP_FX_DeleteUserGroupAuthExtention: TB_FX_UserGroupAuthExtention 삭제 +
                                       DELETE SCM_MST_AUTH_REQUEST WHERE GROUP_ID, USER_ID, DIVISION_ID=@PrntCode, PLANT_ID=@Code
                                       IF @AuthType='D' → DELETE SCM_MST_AUTH_REQUEST WHERE GROUP_ID, USER_ID, DIVISION_ID=@Code
TO-BE PKG_SYS0014.P_SYS0014_SAVE_GROUP_USER_M: userInfo D · Division D 블록에 AUTH_REQUEST 삭제 없음 → 기록 잔존.
보완: 두 DELETE 블록 머리에 AS-IS 와 같은 키의 AUTH_REQUEST 삭제 1문장씩 삽입 (UNIT_TP_CD=AuthType, UNIT_ID=Code, UPPR_UNIT_ID=PrntCode).
      GroupInfo(그룹) 삭제는 AS-IS(UP_FX_DeleteGroupInfo, 별도 화면 GroupInfo.cs)에도 AUTH_REQUEST 삭제가 없어 손대지 않음.

절차(#152): fetch(착수 조회본 백업) → apply(FRESH-GATE 재조회==기준본 → 구간 내 고유 1건 치환 2곳 → CREATE OR REPLACE
           → VALID·오류 0·적용본==DB 원문·의존 INVALID 0, 실패 시 원문 복원) / rollback
사용: python apply_gap473.py fetch | apply | rollback
"""
import os, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
ASIS = os.path.join(HERE, "PKG_SYS0014_BODY.ASIS.sql")
TOBE = os.path.join(HERE, "PKG_SYS0014_BODY.TOBE.sql")
PKG = "PKG_SYS0014"
MARK = "GAP473 2026-10-15"
P_A = "\nPROCEDURE P_SYS0014_SAVE_GROUP_USER_M ("
P_B = "\nEND P_SYS0014_SAVE_GROUP_USER_M;"

OLD1 = "    -- userInfo DELETE\n"
NEW1 = f"""    -- userInfo DELETE
    -- [{MARK}] AS-IS UP_FX_DeleteUserGroupInfo parity: remove the user's auth request records of this group too
    DELETE FROM SCM_MGR.SCM_MST_AUTH_REQUEST R
     WHERE (R.GROUP_ID, R.USER_ID) IN (
         SELECT V_USER_GR_ID, V_USER_ID FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
             V_SHT_NM     VARCHAR2(30) PATH '$.SHT_NM',
             V_CRUD_TYPE  VARCHAR2(1)  PATH '$.CRUD_TYPE',
             V_USER_GR_ID VARCHAR2(50) PATH '$.USER_GR_ID',
             V_USER_ID    VARCHAR2(50) PATH '$.USER_ID'
         )) WHERE V_SHT_NM='UserInfo' AND V_CRUD_TYPE='D'
     );
"""

OLD2 = "    -- unit_auth DELETE\n"
NEW2 = f"""    -- unit_auth DELETE
    -- [{MARK}] AS-IS UP_FX_DeleteUserGroupAuthExtention parity: remove matching auth request records too
    --   (DIVISION_ID=UPPR_UNIT_ID AND PLANT_ID=UNIT_ID) / UNIT_TP_CD='D' -> every request of that division
    DELETE FROM SCM_MGR.SCM_MST_AUTH_REQUEST R
     WHERE EXISTS (
         SELECT 1 FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
             V_SHT_NM       VARCHAR2(30) PATH '$.SHT_NM',
             V_CRUD_TYPE    VARCHAR2(1)  PATH '$.CRUD_TYPE',
             V_USER_GR_ID   VARCHAR2(50) PATH '$.USER_GR_ID',
             V_USER_ID      VARCHAR2(50) PATH '$.USER_ID',
             V_UNIT_TP_CD   VARCHAR2(10) PATH '$.UNIT_TP_CD',
             V_UNIT_ID      VARCHAR2(50) PATH '$.UNIT_ID',
             V_UPPR_UNIT_ID VARCHAR2(50) PATH '$.UPPR_UNIT_ID'
         )) J
          WHERE J.V_SHT_NM = 'Division' AND J.V_CRUD_TYPE = 'D'
            AND R.GROUP_ID = J.V_USER_GR_ID
            AND R.USER_ID  = J.V_USER_ID
            AND (   (R.DIVISION_ID = J.V_UPPR_UNIT_ID AND R.PLANT_ID = J.V_UNIT_ID)
                 OR (J.V_UNIT_TP_CD = 'D' AND R.DIVISION_ID = J.V_UNIT_ID))
     );
"""

PAIRS = [(OLD1, NEW1), (OLD2, NEW2)]


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
        assert transform(base, PAIRS) == tobe and tobe.count(MARK) == 2
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
