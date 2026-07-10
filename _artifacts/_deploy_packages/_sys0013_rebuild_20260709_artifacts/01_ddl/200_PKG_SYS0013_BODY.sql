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
         , NVL(ATTRIBUTE1, '0') AS SEQNO,
   NVL(ATTRIBUTE2, '') AS DEFAULT_VALUE
   
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
            , NVL((SELECT MAX(T2A.EDIT_YN) FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2A
                    WHERE T2A.USER_ID=P_USER_ID AND T2A.MNU_ID=P_MNU_ID AND T2A.UNIT_TP_CD='D'
                      AND (A.DIVISION_ID=T2A.UNIT_ID OR A.DIVISION_ID='-')), 'N') AS EDIT_YN
        FROM SCM_ADM_DQ_LIST A
        WHERE EXISTS (
            SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V T2
            WHERE T2.USER_ID=P_USER_ID AND T2.MNU_ID=P_MNU_ID AND T2.UNIT_TP_CD='D'
              AND (A.DIVISION_ID=T2.UNIT_ID OR A.DIVISION_ID='-')
        )
          AND 1 = 1
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
      AND (NVL(P_ROLE,'')='' OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%'))
     ORDER BY TO_NUMBER(DQ_ID);

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
          ,A.ATTRIBUTE2 AS AGGREGATE   -- AGGREGATE(SUM/MAX/MIN/COUNT)=ATTRIBUTE2 (2026-06-26)
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



  PROCEDURE P_SYS0013_SAVE_QUERY_LIST
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  )
  AS
    V_SQL_CODE    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_NEW_DQ_ID   NUMBER;
    V_AFFECTED    NUMBER := 0;
    V_USER        VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
    V_NEW_IDS     VARCHAR2(2000 CHAR);   -- [2026-07-09 v3] 신규 채번 DQ_ID '#' 연결 (AS-IS SYS0013_SAVE_QUERY SEQNO 관례)
  BEGIN
    FOR rec IN (
      SELECT *
        FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
            CRUD_TYPE       VARCHAR2(10)   PATH '$.crudType',
            DQ_ID           NUMBER         PATH '$.dqId',
            DIVISION_ID     VARCHAR2(50)   PATH '$.divisionId',
            DQ_NAME         VARCHAR2(2000) PATH '$.dqName',
            DESCRIPTION     VARCHAR2(4000) PATH '$.description',
            DQ_TEXT         CLOB           PATH '$.dqText',
            VALID_YN        VARCHAR2(4)    PATH '$.validYn',
            ADMIN_ONLY_YN   VARCHAR2(4)    PATH '$.adminOnlyYn'
        ))
    ) LOOP
      IF rec.CRUD_TYPE = 'I' THEN
        SELECT NVL(MAX(DQ_ID), 0) + 1 INTO V_NEW_DQ_ID FROM SCM_ADM_DQ_LIST;
        -- [2026-07-09 v3] 신규 ID 누적 반환 — 모달 신규 흐름(Role/Columns/Condition 후속 저장) 완결용
        V_NEW_IDS := CASE WHEN V_NEW_IDS IS NULL THEN TO_CHAR(V_NEW_DQ_ID)
                          ELSE V_NEW_IDS || '#' || TO_CHAR(V_NEW_DQ_ID) END;
        INSERT INTO SCM_ADM_DQ_LIST (
          DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT,
          VALID_YN, ADMIN_ONLY_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        ) VALUES (
          V_NEW_DQ_ID,
          NVL(rec.DIVISION_ID, '-'),
          NVL(rec.DQ_NAME, ''),
          NVL(rec.DESCRIPTION, ''),
          rec.DQ_TEXT,
          NVL(rec.VALID_YN, 'Y'),
          NVL(rec.ADMIN_ONLY_YN, 'N'),
          V_USER, SYSDATE, V_USER, SYSDATE
        );
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_LIST_H)
        INSERT INTO SCM_ADM_DQ_LIST_H (
          HISTORY_SEQ, DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT,
          VALID_YN, ADMIN_ONLY_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL, DQ_ID, NVL(DIVISION_ID, '-'), NVL(DQ_NAME, '-'),
               NVL(DESCRIPTION, '-'), NVL(DQ_TEXT, '-'), NVL(VALID_YN, 'Y'), NVL(ADMIN_ONLY_YN, 'Y'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), NVL(LAST_UPDATED_BY, 'system'), NVL(LAST_UPDATE_DATE, SYSDATE),
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_LIST
         WHERE DQ_ID = V_NEW_DQ_ID;
        V_AFFECTED := V_AFFECTED + 1;
      ELSIF rec.CRUD_TYPE = 'M' THEN
        UPDATE SCM_ADM_DQ_LIST
           SET DIVISION_ID      = NVL(rec.DIVISION_ID, DIVISION_ID),
               DQ_NAME          = NVL(rec.DQ_NAME, DQ_NAME),
               DESCRIPTION      = NVL(rec.DESCRIPTION, DESCRIPTION),
               DQ_TEXT          = NVL(rec.DQ_TEXT, DQ_TEXT),
               VALID_YN         = NVL(rec.VALID_YN, VALID_YN),
               ADMIN_ONLY_YN    = NVL(rec.ADMIN_ONLY_YN, ADMIN_ONLY_YN),
               LAST_UPDATED_BY  = V_USER,
               LAST_UPDATE_DATE = SYSDATE
         WHERE DQ_ID = rec.DQ_ID;
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_LIST_H)
        INSERT INTO SCM_ADM_DQ_LIST_H (
          HISTORY_SEQ, DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT,
          VALID_YN, ADMIN_ONLY_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL, DQ_ID, NVL(DIVISION_ID, '-'), NVL(DQ_NAME, '-'),
               NVL(DESCRIPTION, '-'), NVL(DQ_TEXT, '-'), NVL(VALID_YN, 'Y'), NVL(ADMIN_ONLY_YN, 'Y'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), NVL(LAST_UPDATED_BY, 'system'), NVL(LAST_UPDATE_DATE, SYSDATE),
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_LIST
         WHERE DQ_ID = rec.DQ_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_LIST_H)
        INSERT INTO SCM_ADM_DQ_LIST_H (
          HISTORY_SEQ, DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT,
          VALID_YN, ADMIN_ONLY_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL, DQ_ID, NVL(DIVISION_ID, '-'), NVL(DQ_NAME, '-'),
               NVL(DESCRIPTION, '-'), NVL(DQ_TEXT, '-'), NVL(VALID_YN, 'Y'), NVL(ADMIN_ONLY_YN, 'Y'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), V_USER, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_LIST
         WHERE DQ_ID = rec.DQ_ID;
        DELETE FROM SCM_ADM_DQ_LIST WHERE DQ_ID = rec.DQ_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      END IF;
    END LOOP;

    OPEN O_RC1 FOR
      SELECT V_AFFECTED AS AFFECTED, V_NEW_IDS AS NEW_DQ_IDS FROM DUAL;   -- [2026-07-09 v3] NEW_DQ_IDS 확장 (additive)
    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1=2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      V_SQL_CODE   := TO_CHAR(SQLCODE);
      V_SQL_ERRMSG := SQLERRM;
      V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_SQL_ERRMSG ||
        ' / BACKTRACE=' || V_BACKTRACE);
  END P_SYS0013_SAVE_QUERY_LIST;


  PROCEDURE P_SYS0013_SAVE_COLUMNS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  )
  AS
    V_SQL_CODE    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_AFFECTED    NUMBER := 0;
    V_USER        VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
  BEGIN
    FOR rec IN (
      SELECT *
        FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
            CRUD_TYPE       VARCHAR2(10)   PATH '$.crudType',
            DQ_ID           NUMBER         PATH '$.dqId',
            COLUMN_NAME     VARCHAR2(200)  PATH '$.columnName',
            VALUE_YN        VARCHAR2(4)    PATH '$.valueYn',
            VALUE_TYPE      VARCHAR2(200)  PATH '$.valueType',
            VALID_YN        VARCHAR2(4)    PATH '$.validYn',
            SEQNO           VARCHAR2(20)   PATH '$.seqno',
            AGGREGATE       VARCHAR2(20)   PATH '$.aggregate'
        ))
    ) LOOP
      IF rec.CRUD_TYPE = 'I' THEN
        INSERT INTO SCM_ADM_DQ_COLUMN (
          DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
        ) VALUES (
          rec.DQ_ID, rec.COLUMN_NAME,
          NVL(rec.VALUE_YN, 'Y'), NVL(rec.VALUE_TYPE, 'System.String'), NVL(rec.VALID_YN, 'Y'),
          V_USER, SYSDATE, V_USER, SYSDATE, NVL(rec.SEQNO, '0'), rec.AGGREGATE
        );
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_COLUMN_H)
        INSERT INTO SCM_ADM_DQ_COLUMN_H (
          HISTORY_SEQ, DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL, DQ_ID, COLUMN_NAME, NVL(VALUE_YN, 'Y'),
               NVL(VALUE_TYPE, 'System.String'), NVL(VALID_YN, 'Y'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), NVL(LAST_UPDATED_BY, 'system'), NVL(LAST_UPDATE_DATE, SYSDATE),
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_COLUMN
         WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME;
        V_AFFECTED := V_AFFECTED + 1;
      ELSIF rec.CRUD_TYPE = 'M' THEN
        UPDATE SCM_ADM_DQ_COLUMN
           SET VALUE_YN         = NVL(rec.VALUE_YN, VALUE_YN),
               VALUE_TYPE       = NVL(rec.VALUE_TYPE, VALUE_TYPE),
               VALID_YN         = NVL(rec.VALID_YN, VALID_YN),
               ATTRIBUTE1       = NVL(rec.SEQNO, ATTRIBUTE1),
               ATTRIBUTE2       = NVL(rec.AGGREGATE, ATTRIBUTE2),
               LAST_UPDATED_BY  = V_USER,
               LAST_UPDATE_DATE = SYSDATE
         WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME;
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_COLUMN_H)
        INSERT INTO SCM_ADM_DQ_COLUMN_H (
          HISTORY_SEQ, DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL, DQ_ID, COLUMN_NAME, NVL(VALUE_YN, 'Y'),
               NVL(VALUE_TYPE, 'System.String'), NVL(VALID_YN, 'Y'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), NVL(LAST_UPDATED_BY, 'system'), NVL(LAST_UPDATE_DATE, SYSDATE),
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_COLUMN
         WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_COLUMN_H)
        INSERT INTO SCM_ADM_DQ_COLUMN_H (
          HISTORY_SEQ, DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL, DQ_ID, COLUMN_NAME, NVL(VALUE_YN, 'Y'),
               NVL(VALUE_TYPE, 'System.String'), NVL(VALID_YN, 'Y'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), V_USER, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_COLUMN
         WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME;
        DELETE FROM SCM_ADM_DQ_COLUMN WHERE DQ_ID = rec.DQ_ID AND COLUMN_NAME = rec.COLUMN_NAME;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      END IF;
    END LOOP;

    OPEN O_RC1 FOR SELECT V_AFFECTED AS AFFECTED FROM DUAL;
    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1=2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      V_SQL_CODE   := TO_CHAR(SQLCODE);
      V_SQL_ERRMSG := SQLERRM;
      V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_SQL_ERRMSG ||
        ' / BACKTRACE=' || V_BACKTRACE);
  END P_SYS0013_SAVE_COLUMNS;

  PROCEDURE P_SYS0013_SAVE_PARAMETERS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  )
  AS
    V_SQL_CODE    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_AFFECTED    NUMBER := 0;
    V_USER        VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
  BEGIN
    FOR rec IN (
      SELECT *
        FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
            CRUD_TYPE       VARCHAR2(10)   PATH '$.crudType',
            DQ_ID           NUMBER         PATH '$.dqId',
            PARAMETER_ID    VARCHAR2(200)  PATH '$.parameterId',
            PARAMETER_TYPE  VARCHAR2(50)   PATH '$.parameterType',
            OPERATION_ID    VARCHAR2(10)   PATH '$.operationId',
            VALID_YN        VARCHAR2(4)    PATH '$.validYn',
            REP_YN          VARCHAR2(4)    PATH '$.repYn',
            SEQNO           VARCHAR2(20)   PATH '$.seqno',
            DEFAULT_VALUE   VARCHAR2(600)  PATH '$.defaultValue'
        ))
    ) LOOP
      IF rec.CRUD_TYPE = 'I' THEN
        INSERT INTO SCM_ADM_DQ_PARAMETER (
          DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID,
          VALID_YN, REP_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2
        ) VALUES (
          rec.DQ_ID, rec.PARAMETER_ID,
          NVL(rec.PARAMETER_TYPE, 'Parameter'),
          NVL(rec.OPERATION_ID, '-'),
          NVL(rec.VALID_YN, 'Y'),
          NVL(rec.REP_YN, 'N'),
          V_USER, SYSDATE, V_USER, SYSDATE,
          NVL(rec.SEQNO, '0'),
          rec.DEFAULT_VALUE
        );
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_PARAMETER_H)
        INSERT INTO SCM_ADM_DQ_PARAMETER_H (
          HISTORY_SEQ, DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL, DQ_ID, PARAMETER_ID, NVL(PARAMETER_TYPE, 'Parameter'),
               NVL(OPERATION_ID, '-'), NVL(VALID_YN, 'Y'), NVL(REP_YN, 'N'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), NVL(LAST_UPDATED_BY, 'system'), NVL(LAST_UPDATE_DATE, SYSDATE),
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_PARAMETER
         WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID;
        V_AFFECTED := V_AFFECTED + 1;
      ELSIF rec.CRUD_TYPE = 'M' THEN
        UPDATE SCM_ADM_DQ_PARAMETER
           SET PARAMETER_TYPE   = NVL(rec.PARAMETER_TYPE, PARAMETER_TYPE),
               OPERATION_ID     = NVL(rec.OPERATION_ID, OPERATION_ID),
               VALID_YN         = NVL(rec.VALID_YN, VALID_YN),
               REP_YN           = NVL(rec.REP_YN, REP_YN),
               ATTRIBUTE1       = NVL(rec.SEQNO, ATTRIBUTE1),
               ATTRIBUTE2       = NVL(rec.DEFAULT_VALUE, ATTRIBUTE2),
               LAST_UPDATED_BY  = V_USER,
               LAST_UPDATE_DATE = SYSDATE
         WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID;
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_PARAMETER_H)
        INSERT INTO SCM_ADM_DQ_PARAMETER_H (
          HISTORY_SEQ, DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL, DQ_ID, PARAMETER_ID, NVL(PARAMETER_TYPE, 'Parameter'),
               NVL(OPERATION_ID, '-'), NVL(VALID_YN, 'Y'), NVL(REP_YN, 'N'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), NVL(LAST_UPDATED_BY, 'system'), NVL(LAST_UPDATE_DATE, SYSDATE),
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_PARAMETER
         WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
        -- [2026-07-09 D1] 이력 기록 (SCM_ADM_DQ_PARAMETER_H)
        INSERT INTO SCM_ADM_DQ_PARAMETER_H (
          HISTORY_SEQ, DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
          ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
          ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL, DQ_ID, PARAMETER_ID, NVL(PARAMETER_TYPE, 'Parameter'),
               NVL(OPERATION_ID, '-'), NVL(VALID_YN, 'Y'), NVL(REP_YN, 'N'),
               NVL(CREATED_BY, 'system'), NVL(CREATION_DATE, SYSDATE), V_USER, SYSDATE,
               ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
               ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
          FROM SCM_ADM_DQ_PARAMETER
         WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID;
        DELETE FROM SCM_ADM_DQ_PARAMETER
         WHERE DQ_ID = rec.DQ_ID AND PARAMETER_ID = rec.PARAMETER_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      END IF;
    END LOOP;

    OPEN O_RC1 FOR SELECT V_AFFECTED AS AFFECTED FROM DUAL;
    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1=2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      V_SQL_CODE   := TO_CHAR(SQLCODE);
      V_SQL_ERRMSG := SQLERRM;
      V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
      RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_SQL_ERRMSG ||
        ' / BACKTRACE=' || V_BACKTRACE);
  END P_SYS0013_SAVE_PARAMETERS;


  -- ==========================================================================
  -- [2026-07-09] PKG 통합 — standalone 흡수 4종 (본문 1:1 이식, 이름만 변경)
  -- ==========================================================================

  PROCEDURE P_SYS0013_GET_HISTORY
  (
    P_DQ_ID           IN  VARCHAR2,
    P_USER_ID         IN  VARCHAR2,
    P_MNU_ID          IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
  )
  /* 원본: SYS0013_GET_HISTORY (2026-06-15 신설) — Dynamic Query 실행 이력 조회. P_USER_ID/P_MNU_ID 미사용(원본 보존) */
  IS
  BEGIN
    OPEN O_RC1 FOR
    SELECT HISTORY_SEQ
         , DQ_ID
         , DQ_TEXT
         , CREATED_BY
         , CREATION_DATE
         , LAST_UPDATED_BY
         , LAST_UPDATE_DATE
      FROM SCM_MGR.SCM_ADM_DQ_EXECUTE_H
     WHERE (P_DQ_ID IS NULL OR P_DQ_ID = '' OR DQ_ID = P_DQ_ID)
     ORDER BY HISTORY_SEQ DESC;

    OPEN O_RESULT_CURSOR FOR
    SELECT 0 AS RESULT_CODE
         , 'SUCCESS' AS RESULT_MESSAGE
      FROM DUAL;
  END P_SYS0013_GET_HISTORY;

  PROCEDURE P_SYS0013_SAVE_USER_GROUP
  (
    P_DQ_ID             IN VARCHAR2,
    P_GROUP_ID          IN VARCHAR2,
    P_VALID_YN          IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
  )
  /* 원본: SYS0013_SAVE_USER_GROUP — _H 이력 + MERGE upsert */
  IS
  BEGIN
    INSERT INTO SCM_ADM_DQ_USER_GROUP_H (HISTORY_SEQ, DQ_ID, GROUP_ID, VALID_YN,
                                         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (SEQ1_SCM_ADM_DQ_USER_GROUP_H.NEXTVAL, NVL(P_DQ_ID,'-'), NVL(P_GROUP_ID,'-'), NVL(P_VALID_YN,'Y'),
            NVL(P_CREATED_BY,'system'), SYSDATE, NVL(P_LAST_UPDATED_BY,'system'), SYSDATE);

    MERGE INTO SCM_ADM_DQ_USER_GROUP t
    USING (SELECT NVL(P_DQ_ID,'-') AS DQ_ID, NVL(P_GROUP_ID,'-') AS GROUP_ID FROM DUAL) s
       ON (t.DQ_ID = s.DQ_ID AND t.GROUP_ID = s.GROUP_ID)
    WHEN MATCHED THEN
        UPDATE SET t.VALID_YN=NVL(P_VALID_YN,'Y'),
                   t.LAST_UPDATED_BY=NVL(P_LAST_UPDATED_BY,'system'),
                   t.LAST_UPDATE_DATE=SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (DQ_ID, GROUP_ID, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (s.DQ_ID, s.GROUP_ID, NVL(P_VALID_YN,'Y'), NVL(P_CREATED_BY,'system'), SYSDATE,
                NVL(P_LAST_UPDATED_BY,'system'), SYSDATE);

    OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL;
  END P_SYS0013_SAVE_USER_GROUP;

  PROCEDURE P_SYS0013_DELETE_USER_GROUP
  (
    P_DQ_ID             IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
  )
  /* 원본: SYS0013_DELETE_USER_GROUP — _H 보존 후 DELETE */
  IS
  BEGIN
    -- HIST 보존
    INSERT INTO SCM_ADM_DQ_USER_GROUP_H (HISTORY_SEQ, DQ_ID, GROUP_ID, VALID_YN,
                                         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT SEQ1_SCM_ADM_DQ_USER_GROUP_H.NEXTVAL, DQ_ID, GROUP_ID, 'N',
           CREATED_BY, CREATION_DATE, NVL(P_LAST_UPDATED_BY,'system'), SYSDATE
      FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID = P_DQ_ID;

    DELETE FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID = P_DQ_ID;

    OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL;
  END P_SYS0013_DELETE_USER_GROUP;

  PROCEDURE P_SYS0013_EXECUTE_HIST
  (
    P_DQ_ID             IN VARCHAR2,
    P_DQ_TEXT           IN CLOB,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
  )
  /* 원본: SYS0013_EXECUTE_HIST — 실행 이력 INSERT (경량) */
  IS
  BEGIN
    INSERT INTO SCM_ADM_DQ_EXECUTE_H (HISTORY_SEQ, DQ_ID, DQ_TEXT,
                                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (SEQ1_SCM_ADM_DQ_EXECUTE_H.NEXTVAL, NVL(P_DQ_ID,'-'), NVL(P_DQ_TEXT,'-'),
            NVL(P_CREATED_BY,'system'), SYSDATE, NVL(P_LAST_UPDATED_BY,'system'), SYSDATE);

    OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL;
  END P_SYS0013_EXECUTE_HIST;

  -- ==========================================================================
  -- [2026-07-09 D2] SQL 사전검증 — DBMS_SQL PARSE + DESCRIBE (실행 없음, side-effect 0)
  --   AS-IS SCM0005 팝업 Confirm('SELECT TOP 0' 시험실행 → 컬럼 역추출)의 Oracle 등가 구현
  -- ==========================================================================

  PROCEDURE P_SYS0013_VALIDATE_QUERY
  (
    P_SQL_TEXT        IN  CLOB,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
  )
  AS
    V_SQL_CODE    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_CURSOR_ID   INTEGER;
    V_COL_CNT     INTEGER;
    V_DESC_TAB    DBMS_SQL.DESC_TAB2;
    V_FIRST_WORD  VARCHAR2(30 CHAR);
    V_TYPE_NM     VARCHAR2(30 CHAR);
    V_LIST        SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
  BEGIN
    -- SELECT 전용 가드 (DML/DDL 검증 차단)
    V_FIRST_WORD := UPPER(REGEXP_SUBSTR(DBMS_LOB.SUBSTR(P_SQL_TEXT, 100, 1), '[A-Za-z]+', 1, 1));
    IF V_FIRST_WORD NOT IN ('SELECT', 'WITH') THEN
      RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] SELECT/WITH 구문만 검증할 수 있습니다. (첫 키워드=' || NVL(V_FIRST_WORD, 'NULL') || ')');
    END IF;

    V_CURSOR_ID := DBMS_SQL.OPEN_CURSOR;
    BEGIN
      DBMS_SQL.PARSE(V_CURSOR_ID, P_SQL_TEXT, DBMS_SQL.NATIVE);   -- PARSE 만 수행, EXECUTE 없음
      DBMS_SQL.DESCRIBE_COLUMNS2(V_CURSOR_ID, V_COL_CNT, V_DESC_TAB);
      DBMS_SQL.CLOSE_CURSOR(V_CURSOR_ID);
    EXCEPTION
      WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(V_CURSOR_ID) THEN
          DBMS_SQL.CLOSE_CURSOR(V_CURSOR_ID);
        END IF;
        RAISE;
    END;

    -- 컬럼 타입 → AS-IS System.* 표기 (SCM_ADM_DQ_COLUMN.VALUE_TYPE 계약)
    FOR i IN 1 .. V_COL_CNT LOOP
      V_TYPE_NM := CASE
                     WHEN V_DESC_TAB(i).COL_TYPE IN (2, 100, 101) THEN 'System.Int'      -- NUMBER/BINARY_FLOAT/DOUBLE
                     WHEN V_DESC_TAB(i).COL_TYPE IN (12, 180, 181, 231) THEN 'System.Date' -- DATE/TIMESTAMP 계열
                     ELSE 'System.String'                                                 -- VARCHAR2/CHAR/CLOB 외
                   END;
      V_LIST.EXTEND;
      V_LIST(V_LIST.COUNT) := V_DESC_TAB(i).COL_NAME || '^' || V_TYPE_NM;
    END LOOP;

    OPEN O_RC1 FOR
      SELECT SUBSTR(COLUMN_VALUE, 1, INSTR(COLUMN_VALUE, '^') - 1) AS COLUMN_NAME
           , SUBSTR(COLUMN_VALUE, INSTR(COLUMN_VALUE, '^') + 1)   AS VALUE_TYPE
           , ROWNUM                                               AS SEQNO
        FROM TABLE(V_LIST);

    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1=2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

  EXCEPTION
    WHEN OTHERS THEN
      V_SQL_CODE   := TO_CHAR(SQLCODE);
      V_SQL_ERRMSG := SQLERRM;
      RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_SQL_ERRMSG ||
        ' / SQL(500)=' || DBMS_LOB.SUBSTR(P_SQL_TEXT, 500, 1));
  END P_SYS0013_VALIDATE_QUERY;

END PKG_SYS0013;
/

