CREATE OR REPLACE PACKAGE BODY           "PKG_SYS0013"
AS

PROCEDURE P_SYS0013_EXECUTE_QUERY
(
    P_SQL_TEXT        IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2019/04/16  JYE         쿼리 인젝션 방비 수정                                                    */
/* 2019/04/25  JYE         쿼리 인젝션 방비 수정2                                                   */
/* 2026.03.18  jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
AS
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    D_EVENT_DATE    DATE;
    V_S_QUERY       VARCHAR2(32767 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);

BEGIN

    V_S_QUERY := FN_GET_NORMAL_STRING2(P_SQL_TEXT);

    OPEN O_RC1 FOR V_S_QUERY;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_SQL_TEXT' VALUE SUBSTR(P_SQL_TEXT, 1, 500)
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

END P_SYS0013_EXECUTE_QUERY;


PROCEDURE P_SYS0013_GET_DYNAMIC_QUERYS
(
    P_SQL_TEXT        IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.18  jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
AS
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    D_EVENT_DATE    DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
BEGIN

    OPEN O_RC1 FOR P_SQL_TEXT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;


EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_SQL_TEXT' VALUE SUBSTR(P_SQL_TEXT, 1, 500)
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

END P_SYS0013_GET_DYNAMIC_QUERYS;



PROCEDURE P_SYS0013_GET_ROLE_DATA
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0001_GET_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/12  SeungJae.Hwnag         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.18  jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    OPEN O_RC1 FOR
    SELECT
        USER_GR_ID AS CODE,
        USER_GR_NM AS NAME
    FROM SCM_ADM_USER_GR_M
    WHERE USE_YN = 'Y';

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
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

END P_SYS0013_GET_ROLE_DATA;


PROCEDURE P_SYS0013_GET_PARAMETERS
(
    P_DQ_ID           IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.18  jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    OPEN O_RC1 FOR
    SELECT DQ_ID
         , PARAMETER_ID
         , PARAMETER_TYPE
         , OPERATION_ID
         , VALID_YN
         , REP_YN
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
         , NVL(ATTRIBUTE1, '0') AS SEQNO
    FROM   SCM_ADM_DQ_PARAMETER A
    WHERE  DQ_ID = P_DQ_ID
    ORDER BY TO_NUMBER(NVL(ATTRIBUTE1, '0')), LAST_UPDATE_DATE;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DQ_ID' VALUE P_DQ_ID
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

END P_SYS0013_GET_PARAMETERS;

PROCEDURE P_SYS0013_GET_QUERY_LIST_COMMON
(
    P_NICKNAME        IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.18  jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
AS
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    IF P_NICKNAME = 'COLTYPES' THEN

        OPEN O_RC1 FOR
        SELECT 'System.String' AS CODE, 'String' AS NAME FROM DUAL
        UNION ALL
        SELECT 'System.Int' AS CODE, 'Int' AS NAME FROM DUAL
        UNION ALL
        SELECT 'System.Date' AS CODE, 'Date' AS NAME FROM DUAL;

    ELSIF P_NICKNAME = 'COMBO' THEN

        OPEN O_RC1 FOR
        SELECT 'DIVISION_ID' AS CODE, 'DIVISION_ID' AS NAME FROM DUAL
        UNION ALL
        SELECT 'SCM_SITE_ID' AS CODE, 'SCM_SITE_ID' AS NAME FROM DUAL;

    ELSIF P_NICKNAME = 'AGGREGATE' THEN

        OPEN O_RC1 FOR
        --SELECT 'GROUP' AS CODE, 'GROUP' AS NAME FROM DUAL
        --UNION ALL
        SELECT 'SUM' AS CODE, 'SUM' AS NAME FROM DUAL
        UNION ALL
        SELECT 'MAX' AS CODE, 'MAX' AS NAME FROM DUAL
        UNION ALL
        SELECT 'MIN' AS CODE, 'MIN' AS NAME FROM DUAL
        UNION ALL
        SELECT 'COUNT' AS CODE, 'COUNT' AS NAME FROM DUAL;

    ELSIF P_NICKNAME = 'OPORATOR' THEN

        OPEN O_RC1 FOR
        SELECT '=' AS CODE, '=' AS NAME FROM DUAL
        UNION ALL
        SELECT 'IN' AS CODE, 'IN' AS NAME FROM DUAL
        UNION ALL
        SELECT 'LIKE' AS CODE, 'LIKE' AS NAME FROM DUAL
        UNION ALL
        SELECT '>' AS CODE, '>' AS NAME FROM DUAL
        UNION ALL
        SELECT '<' AS CODE, '<' AS NAME FROM DUAL;

    ELSIF P_NICKNAME = 'ROLES' THEN

        OPEN O_RC1 FOR
        SELECT  USER_GR_ID AS CODE,
                USER_GR_NM AS NAME
        FROM   SCM_ADM_USER_GR_M
        WHERE  USE_YN = 'Y';

    ELSIF P_NICKNAME = 'BIZ_TYPE' THEN

        OPEN O_RC1 FOR
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
        ORDER BY DISPLAY_SEQ;

    ELSIF P_NICKNAME = 'ITEM_TYPE_CODE' THEN

        OPEN O_RC1 FOR
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  VALID_YN     = 'Y'
        AND    LOOKUP_TYPE  = 'ITEM_TYPE_CODE'
        ORDER BY DISPLAY_SEQ;

    ELSIF P_NICKNAME = 'INCOTERMS' THEN

        OPEN O_RC1 FOR
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  VALID_YN     = 'Y'
        AND    LOOKUP_TYPE  = 'INCOTERMS'
        ORDER BY DISPLAY_SEQ;

    ELSE

        OPEN O_RC1 FOR
        SELECT NULL AS CODE, NULL AS NAME FROM DUAL WHERE 1 = 0;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_NICKNAME' VALUE P_NICKNAME
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

END P_SYS0013_GET_QUERY_LIST_COMMON;


PROCEDURE P_SYS0013_GET_QUERY_LIST
(
    P_DQ_ID              IN VARCHAR2,
    P_DQ_NAME            IN VARCHAR2,
    P_ROLE               IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1                OUT SYS_REFCURSOR,
    O_RESULT_CURSOR      OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.17   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/****************************************************************************************************/
IS
    -- [SYS0013_GET_QUERY_LIST] '','','DM/SCP'
    -- EXEC SYS0013_GET_QUERY_LIST @p_dq_id='33', @p_dq_name='', @p_role=''

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    WITH SPLIT_DQ_ID AS (
        SELECT TRIM(REGEXP_SUBSTR(P_DQ_ID, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DQ_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    ),
    SPLIT_DQ_NAME AS (
        SELECT TRIM(REGEXP_SUBSTR(P_DQ_NAME, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DQ_NAME, '[^,]+', 1, LEVEL) IS NOT NULL
    ),
    SPLIT_ROLE AS (
        SELECT TRIM(REGEXP_SUBSTR(P_ROLE, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_ROLE, '[^,]+', 1, LEVEL) IS NOT NULL
    ),
    TMPDQ AS (
        SELECT
             A.DQ_ID
            ,A.DIVISION_ID
            ,A.DQ_NAME
            ,A.DESCRIPTION
            ,A.DQ_TEXT
            ,A.VALID_YN
            ,A.ADMIN_ONLY_YN
            ,A.CREATED_BY
            ,A.CREATION_DATE
            ,A.LAST_UPDATED_BY
            ,A.LAST_UPDATE_DATE
            ,'ALL,' || NVL(
                (SELECT LISTAGG(B.GROUP_ID, ',') WITHIN GROUP (ORDER BY B.GROUP_ID)
                 FROM SCM_ADM_DQ_USER_GROUP B
                 LEFT JOIN SCM_ADM_USER_GR_M C
                   ON B.GROUP_ID = C.USER_GR_ID
                  AND C.USE_YN = 'Y'
                 WHERE B.VALID_YN = 'Y'
                   AND B.DQ_ID = A.DQ_ID
                ), '') AS GROUP_ID
            ,NVL(
                (SELECT LISTAGG(C.USER_GR_NM, ',') WITHIN GROUP (ORDER BY C.USER_GR_NM)
                 FROM SCM_ADM_DQ_USER_GROUP B
                 LEFT JOIN SCM_ADM_USER_GR_M C
                   ON B.GROUP_ID = C.USER_GR_ID
                  AND C.USE_YN = 'Y'
                 WHERE B.VALID_YN = 'Y'
                   AND B.DQ_ID = A.DQ_ID
                ), 'ALL') AS GROUP_NAME
            , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM SCM_ADM_DQ_LIST A
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON A.DIVISION_ID = T2.UNIT_ID

        WHERE 1 = 1
          AND (NVL(P_DQ_ID,'')='' OR EXISTS (SELECT 1 FROM SPLIT_DQ_ID P WHERE A.DQ_ID LIKE P.TOKEN || '%'))
          AND (NVL(P_DQ_NAME,'')='' OR EXISTS (SELECT 1 FROM SPLIT_DQ_NAME P WHERE A.DQ_NAME LIKE P.TOKEN || '%'))
    )
    SELECT
         DQ_ID
        ,DIVISION_ID
        ,DQ_NAME
        ,DESCRIPTION
        ,DQ_TEXT
        ,VALID_YN
        ,ADMIN_ONLY_YN
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
        ,GROUP_ID
        ,GROUP_NAME
        ,EDIT_YN
    FROM TMPDQ
    WHERE 1 = 1
      AND (NVL(P_ROLE,'')='' OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%'));

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DQ_ID'   VALUE P_DQ_ID,
            'P_DQ_NAME' VALUE P_DQ_NAME,
            'P_ROLE'    VALUE P_ROLE,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_SYS0013_GET_QUERY_LIST;

PROCEDURE P_SYS0013_GET_COLUMNS
(
    P_DQ_ID              IN VARCHAR2,
    --P_DQ_NAME            IN VARCHAR2,
    --P_ROLE               IN VARCHAR2,
    O_RC1                OUT SYS_REFCURSOR,
    O_RESULT_CURSOR      OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/*2018/03/12  SeungJae.Hwnag     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/*                                                                                                  */
/****************************************************************************************************/
IS
    -- [] '2','',''
    -- EXEC SYS0013_GET_COLUMNS @p_dq_id='27'

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT A.DQ_ID
          ,A.COLUMN_NAME
          ,A.VALUE_YN
          ,A.VALUE_TYPE
          ,A.VALID_YN
          ,A.CREATED_BY
          ,A.CREATION_DATE
          ,A.LAST_UPDATED_BY
          ,A.LAST_UPDATE_DATE
          ,NVL(A.ATTRIBUTE1, '0') AS SEQNO
    FROM SCM_ADM_DQ_COLUMN A
    WHERE A.VALID_YN = 'Y'
      AND A.DQ_ID = P_DQ_ID
    ORDER BY TO_NUMBER(NVL(A.ATTRIBUTE1, '0')), A.LAST_UPDATE_DATE;
    /*
    WHERE
    CASE WHEN @p_dq_id = '' THEN ''
            ELSE A.[DQ_ID]
    END IN (
            Select * from dbo.UF_FX_String_SplitForIN (@p_dq_id,',') as P Where
            (CASE WHEN @p_dq_id = '' THEN '' ELSE A.[DQ_ID] END) = P.data
            )
    AND
    Exists (Select * from dbo.UF_FX_String_Split (@p_dq_name,',') as P Where A.DQ_NAME LIKE P.token +'%')
    */

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DQ_ID' VALUE P_DQ_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_SYS0013_GET_COLUMNS;


END PKG_SYS0013;
/
