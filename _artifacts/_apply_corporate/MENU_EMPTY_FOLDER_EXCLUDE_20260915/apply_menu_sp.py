"""PR_GET_MENU_LIST_V2 — 실제 사용 화면이 없는 메뉴 폴더(트리) 원천 배제.
usage: python apply_menu_sp.py backup|compare|apply|verify
  backup  : 현재 SP 원문 → 00_BACKUP_ASIS/ , 신규 DDL → 01_APPLY/ (DB 무변경)
  compare : 활성 사용자 전원에 대해 기존 SP 결과 vs 신규 SELECT(동일 본문, 바인드) 비교 (DB 무변경)
  apply   : 게이트(현재 원문 == 백업) 통과 시 신규 DDL 배포 → STATUS/ERRORS/GRANT 확인
  verify  : 배포 후 SP 결과 == compare 의 신규 SELECT 결과 (전원) + bottle 결과 출력
"""
import pathlib, sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
import ora  # noqa: E402

ASIS = HERE / "00_BACKUP_ASIS" / "PR_GET_MENU_LIST_V2.ASIS.sql"
TOBE = HERE / "01_APPLY" / "PR_GET_MENU_LIST_V2.sql"

# 신규 본문의 SELECT (P_USER_ID 자리 = :P_USER_ID) — compare 와 DDL 이 같은 텍스트를 쓴다
NEW_SELECT = """        WITH AUTH_MNU AS (
            -- ① 사용자 권한 메뉴 = 기존 조건 그대로 (그룹 매핑 · USE_YN · POPUP 제외)
            SELECT  DISTINCT
                    M.MNU_ID
                  , M.UPPR_MNU_ID
                  , M.MNU_URL
                  , M.ROUTE_PATH
                  , M.MNU_MSG_ID
                  , M.MNU_DESC
                  , M.SORT_ORD
                  , M.MNU_TP_CD
            FROM    SCM_ADM_MNU_M M
                INNER JOIN SCM_ADM_USER_GR_MNU_MPG_M GM
                    ON  M.MNU_ID = GM.MNU_ID
                INNER JOIN SCM_ADM_USER_GR_MPG_M UG
                    ON  GM.USER_GR_ID = UG.USER_GR_ID
            WHERE   1=1
            AND     M.USE_YN  = 'Y'
            AND     UG.USE_YN = 'Y'
            AND     GM.USE_YN = 'Y'
            AND     M.MNU_ID <> 'Popup'
            AND     M.MNU_ID NOT LIKE '%Popup'
            AND     M.MNU_TP_CD <> 'POPUP'
            AND     UG.USER_ID = P_USER_ID
        )
        , USED_FOLDER AS (
            -- ② [E20260915-MENUEMPTY] 실제 사용 화면(권한 SCREEN)의 상위 폴더 체인 전체.
            --    이 체인에 없는 폴더 = 하위에 쓸 수 있는 화면이 없는 폴더 → 메뉴 트리에서 원천 배제.
            --    (예: 그룹에 Admin/System 폴더만 매핑되고 하위 화면 매핑이 0 → Admin 트리 전체 미노출)
            SELECT  DISTINCT P.MNU_ID
            FROM    SCM_ADM_MNU_M P
            START WITH P.MNU_ID IN (SELECT A.UPPR_MNU_ID FROM AUTH_MNU A WHERE A.MNU_TP_CD = 'SCREEN')
            CONNECT BY NOCYCLE P.MNU_ID = PRIOR P.UPPR_MNU_ID
        )
        SELECT  A.MNU_ID        AS MNU_ID
              , A.UPPR_MNU_ID   AS UPPR_MNU_ID
              , A.MNU_URL       AS MNU_URL
              , A.ROUTE_PATH    AS ROUTE_PATH
              , A.MNU_MSG_ID    AS MNU_MSG_ID
              , A.MNU_DESC      AS MNU_DESC
              , A.SORT_ORD      AS SORT_ORD
              , NVL2(B.MNU_ID, 'Y', 'N') AS BMK_YN
        FROM    AUTH_MNU A
            LEFT JOIN SCM_ADM_USER_BMK_M B
                ON  B.USER_ID = P_USER_ID
                AND B.MNU_ID  = A.MNU_ID
        WHERE   A.MNU_TP_CD <> 'MENU'
        OR      A.MNU_ID IN (SELECT F.MNU_ID FROM USED_FOLDER F)
        ORDER BY A.SORT_ORD ASC"""

NEW_DDL = """CREATE OR REPLACE PROCEDURE SCM_MGR."PR_GET_MENU_LIST_V2" (
    P_USER_ID   IN  VARCHAR2,
    DATA        OUT SYS_REFCURSOR
) IS
BEGIN
    -- PKG_NSCM_UI_COM_MENU.PR_GET_MENU_LIST 와 동일 + ROUTE_PATH (화면 모듈 경로) 추가
    --[E20260915-MENUEMPTY] 하위에 실제 사용 화면이 없는 폴더(MENU)는 반환하지 않는다 (사용자 지시 2026-09-15:
    --  "실제 사용하지 않는 메뉴는 대상에서 원천 배제 / 하위에 실제 메뉴가 없으면 메뉴 TREE 도 보이지 않도록").
    --  권한 판정(그룹 매핑·USE_YN·POPUP 제외)은 종전과 동일하고, 폴더 노출 조건만 추가했다.
    OPEN DATA FOR
""" + NEW_SELECT + """
        ;
END;
"""


def current_src(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PR_GET_MENU_LIST_V2' ORDER BY LINE")
    return "".join(r[0] for r in cur.fetchall())


def call_sp(cur, oracledb, user):
    rc = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc("SCM_MGR.PR_GET_MENU_LIST_V2", [user, rc])
    return sorted(tuple(r) for r in rc.getvalue().fetchall())


def call_new(cur, user):
    cur.execute(NEW_SELECT.replace("P_USER_ID", ":P_USER_ID"), {"P_USER_ID": user})
    return sorted(tuple(r) for r in cur.fetchall())


def users(cur):
    cur.execute("SELECT DISTINCT USER_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USE_YN='Y' ORDER BY 1")
    return [r[0] for r in cur.fetchall()]


def main():
    mode = sys.argv[1]
    import oracledb
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR")
        if mode == "backup":
            src = current_src(cur)
            ASIS.parent.mkdir(parents=True, exist_ok=True)
            TOBE.parent.mkdir(parents=True, exist_ok=True)
            ASIS.write_text("CREATE OR REPLACE " + src.replace('PROCEDURE           "PR_GET_MENU_LIST_V2"', 'PROCEDURE SCM_MGR."PR_GET_MENU_LIST_V2"', 1).rstrip() + "\n/\n", encoding="utf-8")
            TOBE.write_text(NEW_DDL + "/\n", encoding="utf-8")
            print("ASIS/TOBE written; asis lines", src.count("\n"))
        elif mode == "compare":
            cur.execute("SELECT MNU_ID, MNU_TP_CD FROM SCM_MGR.SCM_ADM_MNU_M")
            tp = dict(cur.fetchall())
            us = users(cur)
            changed, removed_all, added_all = 0, [], []
            for user in us:
                old, new = call_sp(cur, oracledb, user), call_new(cur, user)
                if old != new:
                    changed += 1
                    rem = sorted(set(old) - set(new))
                    add = sorted(set(new) - set(old))
                    removed_all += [(user, r[0], tp.get(r[0])) for r in rem]
                    added_all += [(user, r[0]) for r in add]
            print(f"users={len(us)} changed_users={changed} removed_rows={len(removed_all)} added_rows={len(added_all)}")
            for x in removed_all:
                print("  REMOVED", x)
            for x in added_all:
                print("  ADDED", x)
            non_menu = [x for x in removed_all if x[2] != "MENU"]
            print("removed non-MENU rows (must be 0):", len(non_menu))
        elif mode == "apply":
            src = current_src(cur)
            asis = ASIS.read_text(encoding="utf-8")
            expect = "CREATE OR REPLACE " + src.replace('PROCEDURE           "PR_GET_MENU_LIST_V2"', 'PROCEDURE SCM_MGR."PR_GET_MENU_LIST_V2"', 1).rstrip() + "\n/\n"
            assert expect == asis, "게이트 실패: 현재 SP != 백업본 — 중단"
            cur.execute(TOBE.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip())
            cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PR_GET_MENU_LIST_V2'")
            print("status", cur.fetchall())
            cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PR_GET_MENU_LIST_V2' ORDER BY SEQUENCE")
            print("errors", cur.fetchall() or 0)
            cur.execute("SELECT GRANTEE, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME='PR_GET_MENU_LIST_V2'")
            print("grants", cur.fetchall())
        elif mode == "verify":
            bad = 0
            for user in users(cur):
                if call_sp(cur, oracledb, user) != call_new(cur, user):
                    bad += 1
            print("SP == NEW_SELECT for all users; mismatches:", bad)
            rows = call_sp(cur, oracledb, "bottle")
            print("bottle rows", len(rows), "| Admin/System present:",
                  [r[0] for r in rows if r[0] in ("Admin", "System", "Admin_Menu")])


if __name__ == "__main__":
    main()
