PACKAGE BODY           "PKG_SYS0013" 
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
    P_DQ_NAME            IN VARCHAR2,
    P_DESCRIPTION        IN VARCHAR2,
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
/* Date        In Charge    Description                                                              */
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
    WITH SPLIT_DESCRIPTION AS (
        SELECT TRIM(REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL)) AS TOKEN
        FROM DUAL
        CONNECT BY REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL) IS NOT NULL
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
        AND (P_DQ_NAME IS NULL OR EXISTS (SELECT 1 FROM SPLIT_DQ_NAME P WHERE UPPER(A.DQ_NAME) LIKE UPPER(P.TOKEN) || '%'))
        AND (P_DESCRIPTION IS NULL OR EXISTS (SELECT 1 FROM SPLIT_DESCRIPTION P WHERE UPPER(A.DESCRIPTION) LIKE UPPER(P.TOKEN) || '%'))
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
      AND (P_ROLE IS NULL OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%'))
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
            'P_DQ_NAME' VALUE P_DQ_NAME,
            'P_DESCRIPTION'   VALUE P_DESCRIPTION,
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
    O_RC2           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  )
  AS
    V_SQL_CODE    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG  VARCHAR2(1000 CHAR);
    V_BACKTRACE   VARCHAR2(4000 CHAR);
    V_NEW_DQ_ID   NUMBER;
    V_AFFECTED    NUMBER := 0;
    V_USER        VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
  	V_INDEX       NUMBER := 0;
  	V_NEW_DQ_ID_LIST  VARCHAR2(4000 CHAR);
  BEGIN
    FOR rec IN (
      SELECT *
        FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
            CRUD_TYPE       VARCHAR2(10)   PATH '$.CRUD_TYPE',
            DQ_ID           NUMBER         PATH '$.DQ_ID',
            DIVISION_ID     VARCHAR2(50)   PATH '$.DIVISION_ID',
            DQ_NAME         VARCHAR2(2000) PATH '$.DQ_NAME',
            DESCRIPTION     VARCHAR2(4000) PATH '$.DESCRIPTION',
            DQ_TEXT         CLOB           PATH '$.DQ_TEXT',
            VALID_YN        VARCHAR2(4)    PATH '$.VALID_YN',
            ADMIN_ONLY_YN   VARCHAR2(4)    PATH '$.ADMIN_ONLY_YN'
        ))
    ) LOOP
      IF rec.CRUD_TYPE = 'I' THEN
        SELECT NVL(MAX(DQ_ID), 0) + 1 INTO V_NEW_DQ_ID FROM SCM_ADM_DQ_LIST;
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
        V_AFFECTED := V_AFFECTED + 1;

		IF V_INDEX = 0 THEN
			V_NEW_DQ_ID_LIST := TO_CHAR(V_NEW_DQ_ID);
		ELSE
			V_NEW_DQ_ID_LIST := ',' || TO_CHAR(V_NEW_DQ_ID);
		END IF;

   		V_INDEX := V_INDEX + 1;
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
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
        DELETE FROM SCM_ADM_DQ_LIST WHERE DQ_ID = rec.DQ_ID;
   		-- 굳이 아래 P_SYS0013_SAVE_COLUMNS, P_SYS0013_SAVE_PARAMETERS 프로시저에서 개별로 삭제하는 것이 아니라
   		-- 마스터성 SCM_ADM_DQ_LIST 테이블의 데이터가 지워지는 시점에 같이 지울 수 있도록 처리.
   		DELETE FROM SCM_ADM_DQ_COLUMN WHERE DQ_ID = rec.DQ_ID;
   		DELETE FROM SCM_ADM_DQ_PARAMETER WHERE DQ_ID = rec.DQ_ID;
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      END IF;
    END LOOP;



    OPEN O_RC1 FOR
      SELECT V_AFFECTED AS AFFECTED FROM DUAL;
    OPEN O_RC2 FOR
      SELECT LISTAGG(V_NEW_DQ_ID_LIST, ',') AS DQ_ID FROM DUAL;
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
            CRUD_TYPE       VARCHAR2(10)   PATH '$.CRUD_TYPE',
            DQ_ID           NUMBER         PATH '$.DQ_ID',
            COLUMN_NAME     VARCHAR2(200)  PATH '$.COLUMN_NAME',
            VALUE_YN        VARCHAR2(4)    PATH '$.VALUE_YN',
            VALUE_TYPE      VARCHAR2(200)  PATH '$.VALUE_TYPE',
            VALID_YN        VARCHAR2(4)    PATH '$.VALID_YN',
            SEQNO           VARCHAR2(20)   PATH '$.SEQNO',
            AGGREGATE       VARCHAR2(20)   PATH '$.AGGREGATE'
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
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
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
            CRUD_TYPE       VARCHAR2(10)   PATH '$.CRUD_TYPE',
            DQ_ID           NUMBER         PATH '$.DQ_ID',
            PARAMETER_ID    VARCHAR2(200)  PATH '$.PARAMETER_ID',
            PARAMETER_TYPE  VARCHAR2(50)   PATH '$.PARAMETER_TYPE',
            OPERATION_ID    VARCHAR2(10)   PATH '$.OPERATION_ID',
            VALID_YN        VARCHAR2(4)    PATH '$.VALID_YN',
            REP_YN          VARCHAR2(4)    PATH '$.REP_YN',
            SEQNO           VARCHAR2(20)   PATH '$.SEQNO',
            DEFAULT_VALUE   VARCHAR2(600)  PATH '$.DEFAULT_VALUE'
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
          rec.OPERATION_ID,
          NVL(rec.VALID_YN, 'Y'),
          NVL(rec.REP_YN, 'N'),
          V_USER, SYSDATE, V_USER, SYSDATE,
          NVL(rec.SEQNO, '0'),
          rec.DEFAULT_VALUE
        );
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
        V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
      ELSIF rec.CRUD_TYPE = 'D' THEN
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


  -- ▼▼▼ 추가 (2026-07-15) — 사내 PKG_SYS0013 원문 1:1 ▼▼▼
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
  -- ▲▲▲ 추가 끝 ▲▲▲

END PKG_SYS0013;