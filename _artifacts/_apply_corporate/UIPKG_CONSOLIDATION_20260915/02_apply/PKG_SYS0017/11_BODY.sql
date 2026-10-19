-- SOURCE-FRESH: SCM_MGR.PKG_SYS0017 PACKAGE BODY LAST_DDL=2026-09-15 15:13:21 FETCHED=2026-09-15 18:54 DB=ZIOUI1
SET DEFINE OFF
CREATE OR REPLACE PACKAGE BODY SCM_MGR."PKG_SYS0017" 
AS

PROCEDURE P_SYS0017_GET_RECIPIENT_MASTER
(
    P_USE_TYPE  IN VARCHAR2,
    P_MODULE    IN VARCHAR2,
    P_SUBMODULE IN VARCHAR2,
    P_ACTIVE    IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_GET_RECIPIENT_MASTER
 * Description  : MAIL SET MASTER 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/05   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/15    hwyoon    메일링 분단위 발송 추가
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

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
         , M.VALID_YN ACTIVE_FLAG
    FROM SCM_ADM_RECIPIENT_LIST M
    WHERE 1 = 1
      AND M.USE_TYPE_CODE = P_USE_TYPE
      AND ( P_MODULE IS NULL
            OR M.MODULE_CODE IN (
                                    SELECT VALUE
                                    FROM JSON_TABLE( '["' || REPLACE( P_MODULE, ',', '","' ) || '"]', '$[*]' COLUMNS (VALUE VARCHAR2(4000) PATH '$') )
                                )
          )
      AND ( P_SUBMODULE IS NULL
            OR M.SUB_MODULE_CODE IN (
                                    SELECT VALUE
                                    FROM JSON_TABLE( '["' || REPLACE( P_SUBMODULE, ',', '","' ) || '"]', '$[*]' COLUMNS (VALUE VARCHAR2(4000) PATH '$') )
                                    )
          )
      AND ( P_ACTIVE IS NULL
            OR M.VALID_YN IN (
                                    SELECT VALUE
                                    FROM JSON_TABLE( '["' || REPLACE( P_ACTIVE, ',', '","' ) || '"]', '$[*]' COLUMNS (VALUE VARCHAR2(4000) PATH '$') )
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
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_ACTIVE' VALUE P_ACTIVE
        );
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

END P_SYS0017_GET_RECIPIENT_MASTER;

PROCEDURE P_SYS0017_GET_RECIPIENT_MESSAGE
(
    P_USE_TYPE        IN  VARCHAR2,
    P_CATEGORYID      IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_GET_RECIPIENT_MESSAGE
 * Description  : MAIL SET MESSAGE 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/19   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    OPEN O_RC1 FOR
    SELECT M.USE_TYPE_CODE
         , M.CATEGORY_ID
         , R.CATEGORY_DESC AS CATEGORY_DESC
         , M.LANGUAGE_CODE
         , LD.SEGMENT2        LANGUAGE
         , M.MAIL_TITLE
         , M.MESSAGE_CONTENT
    FROM SCM_ADM_RECIPIENT_MESSAGE                   M
             INNER JOIN SCM_ADM_RECIPIENT_LIST       R
             ON R.CATEGORY_ID = M.CATEGORY_ID
             INNER JOIN SCM_ADM_LOOKUP_MASTER        LM
             ON LM.LOOKUP_TYPE = 'LANGUAGE' AND LM.VALID_YN = 'Y'
             INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD
             ON LD.LOOKUP_TYPE = LM.LOOKUP_TYPE AND LD.SEGMENT1 = M.LANGUAGE_CODE AND LD.VALID_YN = 'Y'
    WHERE M.USE_TYPE_CODE = P_USE_TYPE
      AND M.CATEGORY_ID = P_CATEGORYID;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_CATEGORYID' VALUE P_CATEGORYID
        );
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

END P_SYS0017_GET_RECIPIENT_MESSAGE;

PROCEDURE P_SYS0017_GET_RECIPIENT_ASSIGN
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
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

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

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT('P_USE_TYPE' VALUE P_USE_TYPE, 'P_CATEGORYID' VALUE P_CATEGORYID);
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

END P_SYS0017_GET_RECIPIENT_ASSIGN;

PROCEDURE P_SYS0017_GET_USERINFO_LIST
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
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

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

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT('P_USER' VALUE P_USER, 'P_DEPT' VALUE P_DEPT);
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

END P_SYS0017_GET_USERINFO_LIST;

PROCEDURE P_SYS0017_GET_SQL_LONG_TEXT
(
    P_USE_TYPE    IN VARCHAR2,
    P_MODULE      IN VARCHAR2,
    P_SUBMODULE   IN VARCHAR2,
    P_CATEGORY_ID IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_GET_SQL_LONG_TEXT
 * Description  : 등록된 Query를 새창에 보여준다.
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/30   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN
	/*
    OPEN O_RC1 FOR
    SELECT FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 1 ) AS TEXT1
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 2 ) AS TEXT2
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 3 ) AS TEXT3
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 4 ) AS TEXT4
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 5 ) AS TEXT5
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 6 ) AS TEXT6
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 7 ) AS TEXT7
         , FN_GET_SOURCE_CODE( P_USE_TYPE, P_MODULE, P_SUBMODULE, P_CATEGORY_ID, 8 ) AS TEXT8
    FROM DUAL;
	*/
    OPEN O_RC1 FOR
    SELECT A.SQL_LONG_TEXT AS SQL_TEXT
      FROM SCM_ADM_RECIPIENT_LIST A
     WHERE A.USE_TYPE_CODE   = P_USE_TYPE
       AND A.MODULE_CODE     = P_MODULE
       AND A.SUB_MODULE_CODE = P_SUBMODULE
       AND A.CATEGORY_ID     = P_CATEGORY_ID; 


    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_CATEGORY_ID' VALUE P_CATEGORY_ID
        );
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

END P_SYS0017_GET_SQL_LONG_TEXT;

PROCEDURE P_SYS0017_SAVE_RECIPIENT_MASTER
(
    P_ACTIVE_FLAG            IN VARCHAR2,
    P_USE_TYPE                IN VARCHAR2,
    P_MODULE                 IN VARCHAR2,
    P_SUBMODULE             IN VARCHAR2,
    P_CATEGORY_ID            IN VARCHAR2,
    P_CATEGORY_DESC         IN VARCHAR2,
    P_CYCLE_CLASS_CODE     IN VARCHAR2,
    P_DETAIL_CLASS_CODE    IN VARCHAR2,
    P_SEND_TIME_TEXT        IN VARCHAR2,
    P_SEND_MIN_TIME_TEXT    IN VARCHAR2,
    P_ACTIVE                IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    P_CREATION_DATE        IN VARCHAR2,
    P_LAST_UPDATED_BY        IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_SAVE_RECIPIENT_MASTER
 * Description  : SMS/MAIL 수신자 Master 저장(CATEGORY_ID는 채번으로 저장)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/29   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/14   ygkim   Mail, SMS 구분 추가
 * 2018/10/15    hwyoon    메일링 분단위 발송 추가
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_USE_TYPE VARCHAR2(4000 CHAR);
    V_MODULE VARCHAR2(4000 CHAR);
    V_SUBMODULE VARCHAR2(4000 CHAR);
    V_CATEGORY_ID VARCHAR2(4000 CHAR);
    V_CATEGORY_DESC VARCHAR2(4000 CHAR);
    V_CYCLE_CLASS_CODE VARCHAR2(4000 CHAR);
    V_DETAIL_CLASS_CODE VARCHAR2(4000 CHAR);
    V_SEND_TIME_TEXT VARCHAR2(4000 CHAR);
    V_SEND_MIN_TIME_TEXT VARCHAR2(4000 CHAR);
    V_ACTIVE VARCHAR2(4000 CHAR);
    V_CREATED_BY VARCHAR2(4000 CHAR);
    V_CREATION_DATE VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    V_SQL_LONG_TEXT VARCHAR2(4000 CHAR);
    V_DELIMITER VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT INTEGER := 0;
    V_MST_LOOP_CNT INTEGER := 0;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'SCM0006_SAVE_RECIPIENT_MASTER';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;
    N_HISTORY_SEQ INTEGER;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_ACTIVE_FLAG := NULL;
    V_USE_TYPE := NULL;
    V_MODULE := NULL;
    V_SUBMODULE := NULL;
    V_CATEGORY_ID := NULL;
    V_CATEGORY_DESC := NULL;
    V_CYCLE_CLASS_CODE := NULL;
    V_DETAIL_CLASS_CODE := NULL;
    V_SEND_TIME_TEXT := NULL;
    V_SEND_MIN_TIME_TEXT := NULL;
    V_ACTIVE := NULL;
    V_CREATED_BY := NULL;
    V_CREATION_DATE := NULL;
    V_LAST_UPDATED_BY := NULL;
    V_SQL_LONG_TEXT := NULL;

    V_DELIMITER := '^';

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT( P_ACTIVE_FLAG, V_DELIMITER);

    WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            BEGIN

                -- v_mst_loop_cnt 1증가
--                v_mst_loop_cnt := v_mst_loop_cnt || 1;
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;                                     -- 2026.09.14 AJS

                -- 각 컬럼들에 대한 스플릿처리로직 스타트
                BEGIN
                    V_ACTIVE_FLAG := SCM_ARR_SPL_VAL( P_ACTIVE_FLAG, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_USE_TYPE := SCM_ARR_SPL_VAL( P_USE_TYPE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_MODULE := SCM_ARR_SPL_VAL(P_MODULE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_SUBMODULE := SCM_ARR_SPL_VAL(P_SUBMODULE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CATEGORY_ID := SCM_ARR_SPL_VAL(P_CATEGORY_ID, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CATEGORY_DESC := SCM_ARR_SPL_VAL(P_CATEGORY_DESC, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_CYCLE_CLASS_CODE := SCM_ARR_SPL_VAL(P_CYCLE_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_DETAIL_CLASS_CODE := SCM_ARR_SPL_VAL(P_DETAIL_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_SEND_TIME_TEXT := SCM_ARR_SPL_VAL(P_SEND_TIME_TEXT, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_SEND_MIN_TIME_TEXT := SCM_ARR_SPL_VAL(P_SEND_MIN_TIME_TEXT, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_ACTIVE := SCM_ARR_SPL_VAL(P_ACTIVE, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_CREATED_BY := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CREATION_DATE := SCM_ARR_SPL_VAL(P_CREATION_DATE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER , V_MST_LOOP_CNT) ;
                END;

                IF (NVL(v_category_id, NULL) IS NULL) THEN
                    SELECT SEQ1_SCM_ADM_RECIPIENT_LIST.NEXTVAL
                    INTO N_HISTORY_SEQ
                    FROM DUAL;
                ELSE
                    N_HISTORY_SEQ := V_CATEGORY_ID;
                END IF;

                --HISTORY INSERT INTO
                PR_SCM_ADM_RECIPIENT_LIST_HIST(
                    V_USE_TYPE
                    ,V_MODULE
                    ,V_SUBMODULE
--                    ,V_CATEGORY_ID
                    ,TO_CHAR(N_HISTORY_SEQ)                                               -- 2026.09.14 AJS
                    ,V_CATEGORY_DESC
                    ,V_CYCLE_CLASS_CODE
                    ,V_DETAIL_CLASS_CODE
                    ,V_SEND_TIME_TEXT
                    ,V_SEND_MIN_TIME_TEXT
                    ,V_ACTIVE
                    ,V_SQL_LONG_TEXT
                    ,V_CREATED_BY
                    ,V_CREATION_DATE
                    ,V_LAST_UPDATED_BY
                );

                IF V_MST_LOOP_CNT > 0 THEN
                    IF V_ACTIVE_FLAG != 'D' THEN
                            BEGIN

                                MERGE INTO SCM_ADM_RECIPIENT_LIST A
                                USING (
                                    SELECT V_USE_TYPE    AS USE_TYPE_CODE
                                         , N_HISTORY_SEQ AS CATEGORY_ID
                                         , V_MODULE      AS MODULE_CODE
                                         , V_SUBMODULE   AS SUB_MODULE_CODE
                                    FROM DUAL
                                      ) B
                                ON (A.USE_TYPE_CODE = B.USE_TYPE_CODE AND A.CATEGORY_ID = B.CATEGORY_ID AND A.MODULE_CODE = B.MODULE_CODE AND A.SUB_MODULE_CODE = B.SUB_MODULE_CODE)
                                WHEN MATCHED THEN
                                    UPDATE
                                    SET CATEGORY_DESC      = V_CATEGORY_DESC
                                      , CYCLE_CLASS_CODE   = V_CYCLE_CLASS_CODE
                                      , DETAIL_CLASS_CODE  = V_DETAIL_CLASS_CODE
                                      , SEND_TIME_TEXT     = V_SEND_TIME_TEXT
                                      , SEND_MIN_TIME_TEXT = V_SEND_MIN_TIME_TEXT
                                      , VALID_YN           = V_ACTIVE
                                      , LAST_UPDATED_BY    = V_LAST_UPDATED_BY
                                      , LAST_UPDATE_DATE   = SYSTIMESTAMP
                                WHEN NOT MATCHED THEN
                                    INSERT
                                    (
                                        USE_TYPE_CODE
                                    ,   CATEGORY_ID
                                    ,   SUB_MODULE_CODE
                                    ,   MODULE_CODE
                                    ,   CATEGORY_DESC
                                    ,   CYCLE_CLASS_CODE
                                    ,   DETAIL_CLASS_CODE
                                    ,   SEND_TIME_TEXT
                                    ,   SEND_MIN_TIME_TEXT
                                    ,   VALID_YN
                                    ,   CREATED_BY
                                    ,   CREATION_DATE
                                    ,   LAST_UPDATED_BY
                                    ,   LAST_UPDATE_DATE
                                    )
                                    VALUES
                                        (
                                            V_USE_TYPE
                                        ,   N_HISTORY_SEQ
                                        ,   V_SUBMODULE
                                        ,   V_MODULE
                                        ,   V_CATEGORY_DESC
                                        ,   V_CYCLE_CLASS_CODE
                                        ,   V_DETAIL_CLASS_CODE
                                        ,   V_SEND_TIME_TEXT
                                        ,   V_SEND_MIN_TIME_TEXT
                                        ,   V_ACTIVE
                                        ,   V_CREATED_BY
                                        ,   SYSTIMESTAMP
                                        ,   V_LAST_UPDATED_BY
                                        ,   SYSTIMESTAMP
                                        );

                            END;
                    ELSIF v_active_flag = 'D' THEN
                        DELETE FROM SCM_ADM_RECIPIENT_LIST
                        WHERE USE_TYPE_CODE = V_USE_TYPE
                          AND MODULE_CODE = V_MODULE
                          AND SUB_MODULE_CODE = V_SUBMODULE
                          AND CATEGORY_ID = N_HISTORY_SEQ;

                        /*해당 MAIL/SMS의 CATEGORY_ID로 등록되어 있는 메세지와 수신자를 같이 삭제한다.*/
                        DELETE FROM SCM_ADM_RECIPIENT_MESSAGE
                        WHERE USE_TYPE_CODE = V_USE_TYPE
                          AND CATEGORY_ID = N_HISTORY_SEQ;

                        /*수신자삭제 : MAIL/SMS 분기처리*/
                        IF V_USE_TYPE = 'SMS' THEN
                                DELETE FROM SCM_ADM_RECIPIENT_SMS_ASSIGN
                                WHERE CATEGORY_ID = N_HISTORY_SEQ;
                        ELSE
                                DELETE FROM SCM_ADM_RECIPIENT_ASSIGN
                                WHERE USE_TYPE_CODE = V_USE_TYPE
                                  AND CATEGORY_ID = N_HISTORY_SEQ;
                        END IF;
                    END IF;
                END IF;

            END;

        END LOOP;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG' VALUE P_ACTIVE_FLAG,
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_CATEGORY_ID' VALUE P_CATEGORY_ID,
            'P_CATEGORY_DESC' VALUE P_CATEGORY_DESC,
            'P_CYCLE_CLASS_CODE' VALUE P_CYCLE_CLASS_CODE,
            'P_DETAIL_CLASS_CODE' VALUE P_DETAIL_CLASS_CODE,
            'P_SEND_TIME_TEXT' VALUE P_SEND_TIME_TEXT,
            'P_SEND_MIN_TIME_TEXT' VALUE P_SEND_MIN_TIME_TEXT,
            'P_ACTIVE' VALUE P_ACTIVE,
            'P_CREATED_BY' VALUE P_CREATED_BY,
            'P_CREATION_DATE' VALUE P_CREATION_DATE,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
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

END P_SYS0017_SAVE_RECIPIENT_MASTER;

PROCEDURE P_SYS0017_SAVE_RECIPIENT_MESSAGE
(
    P_ACTIVE_FLAG     IN VARCHAR2,
    P_USE_TYPE        IN VARCHAR2,
    P_CATEGORY_ID     IN VARCHAR2,
    P_LANGUAGE        IN VARCHAR2,
    P_TITLE           IN VARCHAR2,
    P_CONTENT         IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_CREATION_DATE   IN VARCHAR2,
    P_LAST_UPDATED_BY IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_SAVE_RECIPIENT_MESSAGE
 * Description  : SMS/MAIL별 Category_ID별 메세지 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/20   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */

/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.05.21  최용훈       MS-SQL -> Oracle 변환                                  */
/*                                                                                                  */
/****************************************************************************************************/
AS
    V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_ACTIVE_FLAG      VARCHAR2(4000 CHAR);
    V_USE_TYPE         VARCHAR2(4000 CHAR);
    V_CATEGORY_ID      VARCHAR2(4000 CHAR);
    V_LANGUAGE         VARCHAR2(4000 CHAR);
    V_TITLE            VARCHAR2(4000 CHAR);
    V_CONTENT          VARCHAR2(4000 CHAR);
    V_CREATED_BY       VARCHAR2(4000 CHAR);
    V_CREATION_DATE    VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY  VARCHAR2(4000 CHAR);
    V_DELIMITER        VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT     INTEGER            := 0;
    V_MST_LOOP_CNT     INTEGER            := 0;
    V_PROGRAM_NAME     VARCHAR2(150 CHAR) := 'SCM0006_SAVE_RECIPIMENT_MESSAGE';
    V_LOG_TYPE         VARCHAR2(30 CHAR);
    V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
    V_DESCRIPTION      VARCHAR2(500 CHAR);
    D_EVENT_DATE       DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_ACTIVE_FLAG := NULL;
    V_USE_TYPE := NULL;
    V_CATEGORY_ID := NULL;
    V_LANGUAGE := NULL;
    V_CONTENT := NULL;
    V_CREATED_BY := NULL;
    V_CREATION_DATE := NULL;
    V_LAST_UPDATED_BY := NULL;

    V_DELIMITER := '^';

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE );

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT( P_ACTIVE_FLAG, V_DELIMITER );
    --SELECT    v_max_loop_cnt;
    --    WHILE LENGTH(p_active_flag) > 0
    WHILE LENGTH( V_RECV_ACTIVE_FLAG ) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            BEGIN

                -- v_mst_loop_cnt 1증가
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                -- 각 컬럼들에 대한 스플릿처리로직 스타트
                BEGIN
                    V_ACTIVE_FLAG := SCM_ARR_SPL_VAL( P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT );
                    V_USE_TYPE := SCM_ARR_SPL_VAL( P_USE_TYPE, V_DELIMITER, V_MST_LOOP_CNT );
                    V_CATEGORY_ID := SCM_ARR_SPL_VAL( P_CATEGORY_ID, V_DELIMITER, V_MST_LOOP_CNT );
                    V_LANGUAGE := SCM_ARR_SPL_VAL( P_LANGUAGE, V_DELIMITER, V_MST_LOOP_CNT );
                    V_TITLE := SCM_ARR_SPL_VAL( P_TITLE, V_DELIMITER, V_MST_LOOP_CNT );
                    V_CONTENT := SCM_ARR_SPL_VAL( P_CONTENT, V_DELIMITER, V_MST_LOOP_CNT );
                    V_CREATED_BY := SCM_ARR_SPL_VAL( P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT );
                    V_CREATION_DATE := SCM_ARR_SPL_VAL( P_CREATION_DATE, V_DELIMITER, V_MST_LOOP_CNT );
                    V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL( P_LAST_UPDATED_BY, V_DELIMITER, V_MST_LOOP_CNT );
                END;

                --HISTORY INSERT INTO
                PR_SCM_ADM_RECIPIENT_MESSAGE_HIST(
                    V_USE_TYPE,
                    V_CATEGORY_ID,
                    V_LANGUAGE,
                    V_TITLE,
                    V_CONTENT,
                    V_CREATED_BY,
                    V_CREATION_DATE,
                    V_LAST_UPDATED_BY
                );

                IF V_MST_LOOP_CNT > 0 THEN
                    IF V_ACTIVE_FLAG != 'D' THEN
                        MERGE INTO SCM_ADM_RECIPIENT_MESSAGE A
                        USING (
                                    SELECT V_USE_TYPE    AS USE_TYPE_CODE
                                         , V_CATEGORY_ID AS CATEGORY_ID
                                         , V_LANGUAGE    AS LANGUAGE
                                    FROM DUAL
                              ) B
                        ON  (       A.USE_TYPE_CODE = B.USE_TYPE_CODE
                                AND A.CATEGORY_ID = B.CATEGORY_ID
                                AND A.LANGUAGE_CODE = B.LANGUAGE
                            )
                        WHEN MATCHED THEN
                            UPDATE
                            SET MAIL_TITLE       = V_TITLE
                              , MESSAGE_CONTENT  = V_CONTENT
                              , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                              , LAST_UPDATE_DATE = SYSTIMESTAMP
                        WHEN NOT MATCHED THEN
                            INSERT
                            (
                                USE_TYPE_CODE
                            ,   CATEGORY_ID
                            ,   LANGUAGE_CODE
                            ,   MAIL_TITLE
                            ,   MESSAGE_CONTENT
                            ,   CREATED_BY
                            ,   CREATION_DATE
                            ,   LAST_UPDATED_BY
                            ,   LAST_UPDATE_DATE
                            )
                            VALUES
                                (
                                    V_USE_TYPE
                                ,   V_CATEGORY_ID
                                ,   V_LANGUAGE
                                ,   V_TITLE
                                ,   V_CONTENT
                                ,   V_CREATED_BY
                                ,   SYSTIMESTAMP
                                ,   V_LAST_UPDATED_BY
                                ,   SYSTIMESTAMP
                                );

                    END IF;

                ELSIF V_ACTIVE_FLAG = 'D' THEN

                    DELETE
                    FROM SCM_ADM_RECIPIENT_MESSAGE
                    WHERE USE_TYPE_CODE = V_USE_TYPE
                      AND CATEGORY_ID = V_CATEGORY_ID
                      AND LANGUAGE_CODE = V_LANGUAGE;

                END IF;

            END;

        END LOOP;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE );

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG' VALUE P_ACTIVE_FLAG,
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_CATEGORY_ID' VALUE P_CATEGORY_ID,
            'P_LANGUAGE' VALUE P_LANGUAGE,
            'P_TITLE' VALUE P_TITLE,
            'P_CONTENT' VALUE P_CONTENT,
            'P_CREATED_BY' VALUE P_CREATED_BY,
            'P_CREATION_DATE' VALUE P_CREATION_DATE,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
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

END P_SYS0017_SAVE_RECIPIENT_MESSAGE;

PROCEDURE P_SYS0017_SAVE_RECIPIENT_ASSIGN
(
    P_ACTIVE_FLAG            IN VARCHAR2,
    P_USE_TYPE                IN VARCHAR2,
    P_CATEGORY_ID            IN VARCHAR2,
    P_USER_ID                 IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    P_CREATION_DATE        IN VARCHAR2,
    P_LAST_UPDATED_BY        IN VARCHAR2,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
/*
 * Program ID   : SCM0006_SAVE_RECIPIENT_ASSIGN
 * Description  : SMS/MAIL별 Category_ID별 수신자 리스트 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/20   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
)
AS
    V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_USE_TYPE VARCHAR2(4000 CHAR);
    V_CATEGORY_ID VARCHAR2(4000 CHAR);
    V_USER_ID VARCHAR2(4000 CHAR);
    V_CREATED_BY VARCHAR2(4000 CHAR);
    V_CREATION_DATE VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    V_DELIMITER VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT INTEGER := 0;
    V_MST_LOOP_CNT INTEGER := 0;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'SCM0006_SAVE_RECIPIENT_ASSIGN';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN
    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_ACTIVE_FLAG := NULL;
    V_USE_TYPE := NULL;
    V_CATEGORY_ID := NULL;
    V_USER_ID := NULL;
    V_CREATED_BY := NULL;
    V_CREATION_DATE := NULL;
    V_LAST_UPDATED_BY := NULL;

    V_DELIMITER := '^';

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

        -- 프로시저 LOOP 길이를 판단
        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);
        --SELECT    v_max_loop_cnt;
        --    WHILE LENGTH(p_active_flag) > 0
    WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP
            BEGIN
                -- v_mst_loop_cnt 1증가
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                -- 각 컬럼들에 대한 스플릿처리로직 스타트
                BEGIN
                    V_ACTIVE_FLAG := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_USE_TYPE := SCM_ARR_SPL_VAL(P_USE_TYPE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CATEGORY_ID := SCM_ARR_SPL_VAL(P_CATEGORY_ID, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_USER_ID := SCM_ARR_SPL_VAL(P_USER_ID, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CREATED_BY := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CREATION_DATE := SCM_ARR_SPL_VAL(P_CREATION_DATE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER , V_MST_LOOP_CNT) ;
                END;

                --HISTORY INSERT INTO
                P_PR_SCM_ADM_RECIPIENT_ASSIGN_HIST(
                     V_USE_TYPE
                    ,V_CATEGORY_ID
                    ,V_USER_ID
                    ,V_CREATED_BY
                    ,V_CREATION_DATE
                    ,V_LAST_UPDATED_BY
                );

                IF V_MST_LOOP_CNT > 0 THEN

                    IF V_ACTIVE_FLAG != 'D' THEN

                        MERGE INTO SCM_ADM_RECIPIENT_ASSIGN A
                        USING (
                                SELECT V_USE_TYPE    AS USE_TYPE_CODE
                                     , V_CATEGORY_ID AS CATEGORY_ID
                                     , V_USER_ID     AS USERID
                                FROM DUAL
                              ) B
                        ON (A.USE_TYPE_CODE = B.USE_TYPE_CODE AND A.CATEGORY_ID = B.CATEGORY_ID AND A.USER_ID = B.USERID)
                        WHEN MATCHED THEN
                            UPDATE
                            SET LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                              , LAST_UPDATE_DATE = SYSTIMESTAMP
                        WHEN NOT MATCHED THEN
                            INSERT
                            (
                                USE_TYPE_CODE
                            ,   CATEGORY_ID
                            ,   USER_ID
                            ,   CREATED_BY
                            ,   CREATION_DATE
                            ,   LAST_UPDATED_BY
                            ,   LAST_UPDATE_DATE
                            )
                            VALUES
                                (
                                    V_USE_TYPE
                                ,   V_CATEGORY_ID
                                ,   V_USER_ID
                                ,   V_CREATED_BY
                                ,   SYSTIMESTAMP
                                ,   V_LAST_UPDATED_BY
                                ,   SYSTIMESTAMP
                                );

                    ELSIF V_ACTIVE_FLAG = 'D' THEN

                        DELETE FROM SCM_ADM_RECIPIENT_ASSIGN
                        WHERE USE_TYPE_CODE = V_USE_TYPE
                          AND CATEGORY_ID = V_CATEGORY_ID
                          AND USER_ID = V_USER_ID;

                    END IF;

                END IF;

            END;
        END LOOP;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG' VALUE P_ACTIVE_FLAG,
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_CATEGORY_ID' VALUE P_CATEGORY_ID,
            'P_USER_ID' VALUE P_USER_ID,
            'P_CREATED_BY' VALUE P_CREATED_BY,
            'P_CREATION_DATE' VALUE P_CREATION_DATE,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
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

END P_SYS0017_SAVE_RECIPIENT_ASSIGN;

PROCEDURE P_SYS0017_SAVE_RECIPIENT_MASTER_U
(
    P_USE_TYPE            IN VARCHAR2,
    P_MODULE                IN VARCHAR2,
    P_SUBMODULE            IN VARCHAR2,
    P_CATEGORY_ID        IN VARCHAR2,
    P_SQL                IN VARCHAR2,
    P_LAST_UPDATED_BY    IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * PROGRAM ID   : SCM0006_SAVE_RECIPIENT_MASTER_U
 * DESCRIPTION  : MAIL SET MASTER SQL LONG TEXT UPDATE
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2018/01/30   YGKIM   INITIAL RELEASE PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'SCM0006_SAVE_RECIPIENT_MASTER_U';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    UPDATE SCM_ADM_RECIPIENT_LIST
       SET SQL_LONG_TEXT = P_SQL
          ,LAST_UPDATED_BY = P_LAST_UPDATED_BY
          ,LAST_UPDATE_DATE = SYSDATE
    WHERE USE_TYPE_CODE = P_USE_TYPE
      AND MODULE_CODE = P_MODULE
      AND SUB_MODULE_CODE = P_SUBMODULE
      AND CATEGORY_ID = P_CATEGORY_ID;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_CATEGORY_ID' VALUE P_CATEGORY_ID,
            'P_SQL' VALUE P_SQL,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
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

END P_SYS0017_SAVE_RECIPIENT_MASTER_U;

    -- [2026-09-15 UIPKG] standalone PR_SCM_ADM_RECIPIENT_ASSIGN_HIST 취합
PROCEDURE P_PR_SCM_ADM_RECIPIENT_ASSIGN_HIST 

(
    P_USE_TYPE        IN VARCHAR2
  , P_CATEGORY_ID     IN VARCHAR2
  , P_USER_ID         IN VARCHAR2
  , P_CREATED_BY      IN VARCHAR2
  , P_CREATION_DATE   IN VARCHAR2
  , P_LAST_UPDATED_BY IN VARCHAR2
)
/*
 * Program ID   : PR_SCM_ADM_RECIPIENT_ASSIGN_HIST
 * Description  : SMS/MAIL 수신자 History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.20   ygkim      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 */
AS
    N_HISTORY_SEQ INTEGER;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCM_ADM_RECIPIENT_ASSIGN_HIST';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        SELECT SEQ1_SCM_ADM_RECIPIENT_ASSIGN_H.NEXTVAL
          INTO N_HISTORY_SEQ
          FROM DUAL;

        BEGIN
            INSERT
              INTO SCM_ADM_RECIPIENT_ASSIGN_H
                 ( HISTORY_SEQ
                 , USE_TYPE_CODE
                 , CATEGORY_ID
                 , USER_ID
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES ( N_HISTORY_SEQ
                   , P_USE_TYPE
                   , P_CATEGORY_ID
                   , P_USER_ID
                   , P_CREATED_BY
, TO_DATE(P_CREATION_DATE, 'YYYYMMDD')   -- ★ 여기만 바뀜 (원래: P_CREATION_DATE)
--                   , P_CREATION_DATE
                   , P_LAST_UPDATED_BY
                   , SYSTIMESTAMP );
        END;
    END;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE
          , 'P_CATEGORY_ID' VALUE P_CATEGORY_ID
          , 'P_USER_ID' VALUE P_USER_ID
          , 'P_CREATED_BY' VALUE P_CREATED_BY
          , 'P_CREATION_DATE' VALUE P_CREATION_DATE
          , 'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION'
              , '', SYSDATE, V_PROC_INPUT
              , V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001
          , '[' ||$$PLSQL_UNIT||'] SQLCODE=' ||V_SQL_CODE||
            ' / SQLERRM=' ||V_SQL_ERRMSG||
            ' / BACKTRACE=' ||V_BACKTRACE||
            ' / PARAMS=' ||V_PROC_INPUT
        );
        RAISE;

END P_PR_SCM_ADM_RECIPIENT_ASSIGN_HIST;

END PKG_SYS0017;
/
