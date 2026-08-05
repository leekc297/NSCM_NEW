# -*- coding: utf-8 -*-
"""PKG_SYS0017 조립 — 기존 VALID standalone 7본 본문 무수정(헤더/END만 치환) + INVALID 2본 재변환.
   산출: PKG_SYS0017_SPEC.sql / PKG_SYS0017_BODY.sql"""
import pathlib, re

HERE = pathlib.Path(__file__).resolve().parent
ORIG = HERE / "_orig"

MEMBERS = [  # (신 멤버명, 원본 파일, 승계 여부)
    ("P_SYS0017_GET_RECIPIENT_MASTER",  "SCM0006_GET_RECIPIENT_MASTER",  True),
    ("P_SYS0017_GET_RECIPIENT_MESSAGE", "SCM0006_GET_RECIPIENT_MESSAGE", True),
    ("P_SYS0017_GET_RECIPIENT_ASSIGN",  "SCM0006_GET_RECIPIENT_ASSIGN",  False),
    ("P_SYS0017_GET_USERINFO_LIST",     "SCM0006_GET_USERINFO_LIST",     False),
    ("P_SYS0017_GET_SQL_LONG_TEXT",     "SCM0006_GET_SQL_LONG_TEXT",     True),
    ("P_SYS0017_SAVE_RECIPIENT_MASTER", "SCM0006_SAVE_RECIPIENT_MASTER", True),
    ("P_SYS0017_SAVE_RECIPIENT_MESSAGE","SCM0006_SAVE_RECIPIENT_MESSAGE",True),
    ("P_SYS0017_SAVE_RECIPIENT_ASSIGN", "SCM0006_SAVE_RECIPIENT_ASSIGN", True),
    ("P_SYS0017_SAVE_RECIPIENT_MASTER_U","SCM0006_SAVE_RECIPIENT_MASTER_U",True),
]

HOUSE_EXC = """EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := {params_json};
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
"""

DECLS = """    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
"""

NEW_BODIES = {}

NEW_BODIES["P_SYS0017_GET_RECIPIENT_ASSIGN"] = f"""PROCEDURE P_SYS0017_GET_RECIPIENT_ASSIGN
(
    P_USE_TYPE        IN  VARCHAR2,
    P_CATEGORYID      IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : P_SYS0017_GET_RECIPIENT_ASSIGN
 * Description  : 카테고리별 수신자 리스트 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/20   ygkim   Initial Release PJ20170278
 * 2026/07/29   admin   MS-SQL -> Oracle 재변환 (구 standalone INVALID 정정, AS-IS SP6_DDL L29220 원문 기준)
 */
AS
{DECLS}BEGIN

    OPEN O_RC1 FOR
    SELECT A.USE_TYPE_CODE
         , A.CATEGORY_ID
         , B.CATEGORY_DESC
         , A.USER_ID   AS USERID
         , E.USER_NAME AS USERNAME
         , CASE C.LANGUAGE
               WHEN 'KO' THEN D.DEPT_NAME_KO
               WHEN 'EN' THEN D.DEPT_NAME_EN
               WHEN 'CN' THEN D.DEPT_NAME_CN
               ELSE D.DEPT_NAME_KO
           END AS DEPT_NAME
         , C.EMAIL
         , C.CELLPHONENUM
         , C.LANGUAGE
    FROM SCM_ADM_RECIPIENT_ASSIGN                A
         INNER JOIN SCM_ADM_RECIPIENT_LIST       B ON A.CATEGORY_ID = B.CATEGORY_ID
         LEFT  JOIN SCM_MST_SSO_USER_INFO        E ON E.USER_ID = A.USER_ID
         LEFT  JOIN TB_FX_USER                   C ON C.USERID = A.USER_ID
         LEFT  JOIN SCM_MST_SSO_DEPT_INFO        D ON E.DEPT_ID = D.DEPT_ID
    WHERE A.USE_TYPE_CODE = P_USE_TYPE
      AND A.CATEGORY_ID   = P_CATEGORYID
    ORDER BY C.DEPT_ID, A.USER_ID;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

{HOUSE_EXC.format(params_json="JSON_OBJECT('P_USE_TYPE' VALUE P_USE_TYPE, 'P_CATEGORYID' VALUE P_CATEGORYID)")}
END P_SYS0017_GET_RECIPIENT_ASSIGN;
"""

NEW_BODIES["P_SYS0017_GET_USERINFO_LIST"] = f"""PROCEDURE P_SYS0017_GET_USERINFO_LIST
(
    P_USER            IN  VARCHAR2,
    P_DEPT            IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : P_SYS0017_GET_USERINFO_LIST
 * Description  : 사용자 목록 (SSO 기준, ID·이름·부서 부분일치)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/21   ygkim   Initial Release PJ20170278
 * 2026/07/29   admin   MS-SQL -> Oracle 재변환 (구 standalone INVALID 정정, AS-IS SP6_DDL L29414 원문 기준.
 *                      T-SQL 의 p='' 비교는 Oracle 에서 ''=NULL 이므로 IS NULL 로 등가 흡수)
 */
AS
{DECLS}BEGIN

    OPEN O_RC1 FOR
    SELECT *
    FROM (
        SELECT A.USER_ID                     AS USERID
             , A.USER_NAME                   AS USERNAME
             , A.USER_NAME_EN                AS USERNAME_E
             , A.USER_ID || '@lgensol.com'   AS EMAIL
             , A.DEPT_ID
             , CASE B.LANGUAGE
                   WHEN 'KO' THEN (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
                   WHEN 'EN' THEN (SELECT DEPT_NAME_EN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
                   WHEN 'CN' THEN (SELECT DEPT_NAME_CN FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
                   ELSE           (SELECT DEPT_NAME_KO FROM SCM_MST_SSO_DEPT_INFO WHERE DEPT_ID = A.DEPT_ID)
               END                           AS DEPT_NAME
             , B.CELLPHONENUM
             , B.LANGUAGE
             , B.USEYN
        FROM SCM_MST_SSO_USER_INFO A
        LEFT JOIN TB_FX_USER       B ON A.USER_ID = B.USERID
    ) A
    WHERE (P_USER IS NULL
           OR A.USERID     LIKE '%' || P_USER || '%'
           OR A.USERNAME   LIKE '%' || P_USER || '%'
           OR A.USERNAME_E LIKE '%' || P_USER || '%')
      AND (P_DEPT IS NULL
           OR A.DEPT_ID    LIKE '%' || P_DEPT || '%'
           OR A.DEPT_NAME  LIKE '%' || P_DEPT || '%')
    ORDER BY A.DEPT_ID, A.USERID;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

{HOUSE_EXC.format(params_json="JSON_OBJECT('P_USER' VALUE P_USER, 'P_DEPT' VALUE P_DEPT)")}
END P_SYS0017_GET_USERINFO_LIST;
"""

def carry(new_name, orig_name):
    src = (ORIG / f"{orig_name}.sql").read_text(encoding="utf-8")
    # 헤더: PROCEDURE "SCM0006_X" -> PROCEDURE P_SYS0017_X (본문 무수정 — 헤더/END 라벨만)
    src = re.sub(r'^PROCEDURE\s+"?' + orig_name + r'"?', "PROCEDURE " + new_name, src, count=1)
    # END 라벨 치환 (END SCM0006_X; 형태만 — 없으면 마지막 END; 를 라벨 부여)
    if re.search(r'END\s+' + orig_name + r'\s*;\s*$', src):
        src = re.sub(r'END\s+' + orig_name + r'\s*;\s*$', f"END {new_name};", src)
    else:
        src = re.sub(r'END\s*;\s*$', f"END {new_name};", src)
    return src.rstrip() + "\n"

# 스펙 시그니처 = 사내 ALL_ARGUMENTS 실측 (2026-07-29) — 본문과 positional 일치
SIGS = {
    "P_SYS0017_GET_RECIPIENT_MASTER":  [("P_USE_TYPE","IN"),("P_MODULE","IN"),("P_SUBMODULE","IN"),("P_ACTIVE","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_GET_RECIPIENT_MESSAGE": [("P_USE_TYPE","IN"),("P_CATEGORYID","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_GET_RECIPIENT_ASSIGN":  [("P_USE_TYPE","IN"),("P_CATEGORYID","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_GET_USERINFO_LIST":     [("P_USER","IN"),("P_DEPT","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_GET_SQL_LONG_TEXT":     [("P_USE_TYPE","IN"),("P_MODULE","IN"),("P_SUBMODULE","IN"),("P_CATEGORY_ID","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_SAVE_RECIPIENT_MASTER": [("P_ACTIVE_FLAG","IN"),("P_USE_TYPE","IN"),("P_MODULE","IN"),("P_SUBMODULE","IN"),("P_CATEGORY_ID","IN"),("P_CATEGORY_DESC","IN"),("P_CYCLE_CLASS_CODE","IN"),("P_DETAIL_CLASS_CODE","IN"),("P_SEND_TIME_TEXT","IN"),("P_SEND_MIN_TIME_TEXT","IN"),("P_ACTIVE","IN"),("P_CREATED_BY","IN"),("P_CREATION_DATE","IN"),("P_LAST_UPDATED_BY","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_SAVE_RECIPIENT_MESSAGE":[("P_ACTIVE_FLAG","IN"),("P_USE_TYPE","IN"),("P_CATEGORY_ID","IN"),("P_LANGUAGE","IN"),("P_TITLE","IN"),("P_CONTENT","IN"),("P_CREATED_BY","IN"),("P_CREATION_DATE","IN"),("P_LAST_UPDATED_BY","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_SAVE_RECIPIENT_ASSIGN": [("P_ACTIVE_FLAG","IN"),("P_USE_TYPE","IN"),("P_CATEGORY_ID","IN"),("P_USER_ID","IN"),("P_CREATED_BY","IN"),("P_CREATION_DATE","IN"),("P_LAST_UPDATED_BY","IN"),("O_RESULT_CURSOR","OUT")],
    "P_SYS0017_SAVE_RECIPIENT_MASTER_U":[("P_USE_TYPE","IN"),("P_MODULE","IN"),("P_SUBMODULE","IN"),("P_CATEGORY_ID","IN"),("P_SQL","IN"),("P_LAST_UPDATED_BY","IN"),("O_RC1","OUT"),("O_RESULT_CURSOR","OUT")],
}

def sig_text(name):
    lines = [f"PROCEDURE {name}", "("]
    args = SIGS[name]
    for i, (an, io) in enumerate(args):
        typ = "SYS_REFCURSOR" if io == "OUT" else "VARCHAR2"
        comma = "," if i < len(args) - 1 else ""
        lines.append(f"    {an:<22} {io:<3} {typ}{comma}")
    lines.append(");")
    return "\n".join(lines) + "\n"

spec_lines = []
body_parts = []
for new_name, orig_name, is_carry in MEMBERS:
    body = NEW_BODIES[new_name] if not is_carry else carry(new_name, orig_name)
    body_parts.append(body)
    spec_lines.append(sig_text(new_name))

HDR = """-- =============================================================================
-- PKG_SYS0017 — Mail Setup (AS-IS SCM0006) UI 전용 패키지
-- 생성: 2026-07-29 admin. 구성: 기존 사내 VALID standalone 7본 본문 무수정 승계(헤더/END 라벨만 치환)
--       + INVALID 2본(GET_RECIPIENT_ASSIGN/GET_USERINFO_LIST) AS-IS 원문 기준 재변환.
-- 구 standalone SCM0006_* 9본은 존치(참고) — 배선은 PKG 한정. 근거: SYS0017 화면설계서 v1.0 시트8.
-- =============================================================================
"""

spec = HDR + "CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0017\nAS\n\n" + "\n".join(spec_lines) + "\nEND PKG_SYS0017;\n/\n"
body = HDR + "CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0017\nAS\n\n" + "\n".join(body_parts) + "\nEND PKG_SYS0017;\n/\n"

(HERE / "PKG_SYS0017_SPEC.sql").write_text(spec, encoding="utf-8")
(HERE / "PKG_SYS0017_BODY.sql").write_text(body, encoding="utf-8")
print("SPEC", len(spec.splitlines()), "lines / BODY", len(body.splitlines()), "lines")
