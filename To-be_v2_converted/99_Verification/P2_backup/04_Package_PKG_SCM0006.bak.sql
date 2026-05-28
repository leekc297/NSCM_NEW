/*=============================================================================================
 * File         : 04_Package_PKG_SCM0006.sql
 * Description  : Package — PKG_SCM0006
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCM0006 IS
/*
 * Program ID   : PKG_SCM0006
 * Description  : PKG_SCM0006
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.31   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */

    PROCEDURE P_SCM0006_GET_RECIPIENT_ASSIGN
    (
        P_USE_TYPE      IN VARCHAR2,
        P_CATEGORYID    IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0006_GET_RECIPIENT_MASTER
    (
        P_USE_TYPE      IN VARCHAR2,
        P_MODULE        IN VARCHAR2,
        P_SUBMODULE     IN VARCHAR2,
        P_ACTIVE        IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_SCM0006;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCM0006 IS

/* ============================================================
   4. SCM0006_GET_RECIPIENT_ASSIGN
   ============================================================ */
PROCEDURE P_SCM0006_GET_RECIPIENT_ASSIGN
(
    P_USE_TYPE      IN VARCHAR2,
    P_CATEGORYID    IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0006_GET_RECIPIENT_ASSIGN
 * Description  : 카테고리별 수신자 리스트 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/20   ygkim     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/15   hwyoon    메일링 분단위 발송 추가
 * 2026.03.31   kimcd     [PJ20264226] NextSCM Pilot 설계 및 개발.
 */
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT A.USE_TYPE_CODE
             , A.CATEGORY_ID
             , B.CATEGORY_DESC
             , A.USER_ID    AS USERID
             , E.USER_NAME  AS USERNAME
             , CASE C.LANG_CD
                   WHEN 'KO' THEN D.DEPT_NAME_KO
                   WHEN 'EN' THEN D.DEPT_NAME_EN
                   WHEN 'CN' THEN D.DEPT_NAME_CN
                   ELSE D.DEPT_NAME_KO
               END          AS DEPT_NAME
             , C.USER_EML   AS EMAIL
             , C.USER_HPHN  AS CELLPHONENUM
             , C.LANG_CD    AS LANGUAGE
        FROM   SCM_MGR.SCM_ADM_RECIPIENT_ASSIGN  A
        INNER JOIN SCM_MGR.SCM_ADM_RECIPIENT_LIST   B ON A.CATEGORY_ID = B.CATEGORY_ID
        LEFT  JOIN SCM_MGR.SCM_MST_SSO_USER_INFO    E ON E.USER_ID     = A.USER_ID
        LEFT  JOIN SCM_MGR.SCM_ADM_USER_M           C ON C.USER_ID     = A.USER_ID
        LEFT OUTER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO D ON E.DEPT_ID   = D.DEPT_ID
        WHERE  A.USE_TYPE_CODE = P_USE_TYPE
        AND    A.CATEGORY_ID   = P_CATEGORYID
        ORDER BY C.DEPT_ID, A.USER_ID;

        /*
        SELECT a.use_type_code
              ,a.category_id
              ,b.category_desc
              ,a.user_id userid
              ,c.username username
              ,CASE C.Language
                        WHEN 'KO' THEN D.DEPT_NAME_KO
                        WHEN 'EN' THEN D.DEPT_NAME_EN
                        WHEN 'CN' THEN D.DEPT_NAME_CN
                    END     dept_name
               ,c.email
               ,c.cellphonenum
               ,c.language
        FROM SCM_ADM_RECIPIENT_ASSIGN A WITH(NOLOCK)
        INNER JOIN SCM_ADM_RECIPIENT_LIST B WITH(NOLOCK) ON a.category_id = b.category_id
        INNER JOIN TB_FX_User C WITH(NOLOCK) ON c.userid = a.user_id
        LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D WITH(NOLOCK) ON C.Dept_ID = D.DEPT_ID
        WHERE a.use_type_code = @p_use_type
          AND a.category_id   = @p_categoryID
          ORDER BY C.Dept_ID, A.USER_ID
        */

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_USE_TYPE'   VALUE P_USE_TYPE,
            'P_CATEGORYID' VALUE P_CATEGORYID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0006_GET_RECIPIENT_ASSIGN;



/* ============================================================
   5. SCM0006_GET_RECIPIENT_MASTER
   ============================================================ */
PROCEDURE P_SCM0006_GET_RECIPIENT_MASTER
(
    P_USE_TYPE      IN VARCHAR2,
    P_MODULE        IN VARCHAR2,
    P_SUBMODULE     IN VARCHAR2,
    P_ACTIVE        IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0006_GET_RECIPIENT_MASTER
 * Description  : MAIL SET MASTER 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/05   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/15	hwyoon	메일링 분단위 발송 추가
 * 2026.03.31   kimcd   [PJ20264226] NextSCM Pilot 설계 및 개발.
 */
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT M.USE_TYPE_CODE
             , M.MODULE_CODE
             , M.SUB_MODULE_CODE
             , M.CATEGORY_ID
             , M.CATEGORY_DESC
             , M.CYCLE_CLASS_CODE
             , M.DETAIL_CLASS_CODE
             , M.SEND_TIME_TEXT
             , M.SEND_MIN_TIME_TEXT
             , M.VALID_YN  AS ACTIVE_FLAG
        FROM   SCM_MGR.SCM_ADM_RECIPIENT_LIST M
        WHERE  1 = 1
        AND    M.USE_TYPE_CODE = P_USE_TYPE
        AND    (
                   P_MODULE IS NULL
                   OR M.MODULE_CODE IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_MODULE, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_MODULE, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (
                   P_SUBMODULE IS NULL
                   OR M.SUB_MODULE_CODE IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_SUBMODULE, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_SUBMODULE, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (
                   P_ACTIVE IS NULL
                   OR M.VALID_YN IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_ACTIVE, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_ACTIVE, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        ORDER BY M.USE_TYPE_CODE
               , M.MODULE_CODE
               , M.SUB_MODULE_CODE
               , M.CATEGORY_DESC
               , M.CYCLE_CLASS_CODE
               , M.DETAIL_CLASS_CODE
               , M.SEND_TIME_TEXT
               , M.SEND_MIN_TIME_TEXT
               , M.VALID_YN;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_USE_TYPE'  VALUE P_USE_TYPE,
            'P_MODULE'    VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_ACTIVE'    VALUE P_ACTIVE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0006_GET_RECIPIENT_MASTER;

END PKG_SCM0006;
/
