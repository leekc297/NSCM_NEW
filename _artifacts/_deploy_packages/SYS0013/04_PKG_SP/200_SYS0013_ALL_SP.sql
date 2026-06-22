-- ============================================================
-- SYS0013_* standalone procedures (14)
-- 실행 계정: SCM_MGR · dev/local DDL extract 2026-06-22
-- ============================================================

-- ===== SYS0013_DELETE_USER_GROUP =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_DELETE_USER_GROUP" (
    P_DQ_ID             IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
) IS
BEGIN
    -- HIST 보존
    INSERT INTO SCM_ADM_DQ_USER_GROUP_H (HISTORY_SEQ, DQ_ID, GROUP_ID, VALID_YN,
                                         CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT SEQ1_SCM_ADM_DQ_USER_GROUP_H.NEXTVAL, DQ_ID, GROUP_ID, 'N',
           CREATED_BY, CREATION_DATE, NVL(P_LAST_UPDATED_BY,'system'), SYSDATE
      FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID = P_DQ_ID;

    DELETE FROM SCM_ADM_DQ_USER_GROUP WHERE DQ_ID = P_DQ_ID;

    OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL;
END SYS0013_DELETE_USER_GROUP;
/

-- ===== SYS0013_EXECUTE_HIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_EXECUTE_HIST" (
    P_DQ_ID             IN VARCHAR2,
    P_DQ_TEXT           IN CLOB,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
) IS
BEGIN
    INSERT INTO SCM_ADM_DQ_EXECUTE_H (HISTORY_SEQ, DQ_ID, DQ_TEXT,
                                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (SEQ1_SCM_ADM_DQ_EXECUTE_H.NEXTVAL, NVL(P_DQ_ID,'-'), NVL(P_DQ_TEXT,'-'),
            NVL(P_CREATED_BY,'system'), SYSDATE, NVL(P_LAST_UPDATED_BY,'system'), SYSDATE);

    OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL;
END SYS0013_EXECUTE_HIST;
/

-- ===== SYS0013_EXECUTE_QUERY =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_EXECUTE_QUERY" 
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

END SYS0013_EXECUTE_QUERY;
/

-- ===== SYS0013_GET_COLUMNS =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_GET_COLUMNS" 
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
END SYS0013_GET_COLUMNS;
/

-- ===== SYS0013_GET_DYNAMIC_QUERYS =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_GET_DYNAMIC_QUERYS" 
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

END SYS0013_GET_DYNAMIC_QUERYS;
/

-- ===== SYS0013_GET_HISTORY =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_GET_HISTORY" 
(
    P_DQ_ID            IN  VARCHAR2,
    P_USER_ID          IN  VARCHAR2,
    P_MNU_ID           IN  VARCHAR2,
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : SYS0013_GET_HISTORY                                                                  */
/* Description : Dynamic Query 실행 이력 조회                                                          */
/* Created     : 2026-06-15 — AS-IS DB 에 history GET SP 미존재, SCM_ADM_DQ_EXECUTE_H SELECT 신규 작성 */
/****************************************************************************************************/
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
END SYS0013_GET_HISTORY;
/

-- ===== SYS0013_GET_PARAMETERS =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_GET_PARAMETERS" 
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

END SYS0013_GET_PARAMETERS;
/

-- ===== SYS0013_GET_QUERY_LIST =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_GET_QUERY_LIST" 
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
          AND EXISTS (SELECT 1 FROM SPLIT_DQ_ID P WHERE A.DQ_ID LIKE P.TOKEN || '%')
          AND EXISTS (SELECT 1 FROM SPLIT_DQ_NAME P WHERE A.DQ_NAME LIKE P.TOKEN || '%')
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
      AND EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%');

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
END SYS0013_GET_QUERY_LIST;
/

-- ===== SYS0013_GET_QUERY_LIST_COMMON =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_GET_QUERY_LIST_COMMON" 
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

END SYS0013_GET_QUERY_LIST_COMMON;
/

-- ===== SYS0013_GET_ROLE_DATA =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_GET_ROLE_DATA" 
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

END SYS0013_GET_ROLE_DATA;
/

-- ===== SYS0013_SAVE_COLUMNS =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_SAVE_COLUMNS" (
/**
 * 2026-06-18 Dynmaic Query List 컬럼정보 Multiple Row 데이터 변경이 가능하도록 프로시저 수정 by byunmj0223
 */
/*
    P_ACTIVE_FLAG       IN VARCHAR2,
    P_DQ_ID             IN VARCHAR2,
    P_COLUMN_NAME       IN VARCHAR2,
    P_VALUE_YN          IN VARCHAR2,
    P_VALUE_TYPE        IN VARCHAR2,
    P_VALID_YN          IN VARCHAR2,
    P_ATTRIBUTE1        IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    */
	P_DATA				IN CLOB,
    O_RC1               OUT SYS_REFCURSOR
) IS
	V_ACTIVE_FLAG       VARCHAR2(1);
    V_DQ_ID             NUMBER(10, 0);
    V_COLUMN_NAME       VARCHAR2(200);
    V_VALUE_YN          VARCHAR2(1);
    V_VALUE_TYPE        VARCHAR2(30);
    V_VALID_YN          VARCHAR2(1);
    V_ATTRIBUTE1        VARCHAR2(150);
    V_CREATED_BY        VARCHAR2(150);
    V_LAST_UPDATED_BY   VARCHAR2(150);
BEGIN
    FOR JT IN (
          SELECT
                JT.ACTIVE_FLAG        AS V_ACTIVE_FLAG
              , JT.DQ_ID    		  AS V_DQ_ID
              , JT.COLUMN_NAME        AS V_COLUMN_NAME
              , JT.VALUE_YN        	  AS V_VALUE_YN
              , JT.VALUE_TYPE		  AS V_VALUE_TYPE
              , JT.VALID_YN			  AS V_VALID_YN
              , JT.ATTRIBUTE1	  	  AS V_ATTRIBUTE1
              , JT.CREATED_BY		  AS V_CREATED_BY
              , JT.LAST_UPDATED_BY	  AS V_LAST_UPDATED_BY
          FROM JSON_TABLE(
              P_DATA
            , '$[*]'
              COLUMNS (
                    ACTIVE_FLAG        VARCHAR2(1)    		PATH '$.CRUD_TYPE'
                  , DQ_ID    		   NUMBER(10,0)   		PATH '$.DQ_ID' NULL ON EMPTY NULL ON ERROR
                  , COLUMN_NAME        VARCHAR2(30 CHAR)  	PATH '$.COLUMN_NAME' NULL ON EMPTY NULL ON ERROR
                  , VALUE_YN           VARCHAR2(1 CHAR) 	PATH '$.VALUE_YN' NULL ON EMPTY NULL ON ERROR
                  , VALUE_TYPE		   VARCHAR2(30 CHAR)	PATH '$.VALUE_TYPE' NULL ON EMPTY NULL ON ERROR
                  , VALID_YN		   VARCHAR2(1 CHAR)		PATH '$.VALID_YN' NULL ON EMPTY NULL ON ERROR
                  , ATTRIBUTE1	   	   VARCHAR2(150 CHAR)	PATH '$.ATTRIBUTE1'
                  , CREATED_BY		   VARCHAR2(150 CHAR)	PATH '$.CREATED_BY' NULL ON EMPTY NULL ON ERROR
                  , LAST_UPDATED_BY	   VARCHAR2(150 CHAR)	PATH '$.LAST_UPDATED_BY' NULL ON EMPTY NULL ON ERROR
              )
          ) JT
      ) LOOP
	    V_ACTIVE_FLAG := JT.V_ACTIVE_FLAG;
		V_DQ_ID := JT.V_DQ_ID;
		V_COLUMN_NAME := JT.V_COLUMN_NAME;
		V_VALUE_YN := JT.V_VALUE_YN;
		V_VALUE_TYPE := JT.V_VALUE_TYPE;
		V_VALID_YN := JT.V_VALID_YN;
		V_ATTRIBUTE1 := JT.V_ATTRIBUTE1;
		V_CREATED_BY := JT.V_CREATED_BY;
		V_LAST_UPDATED_BY := JT.V_LAST_UPDATED_BY;

	    INSERT INTO SCM_ADM_DQ_COLUMN_H (HISTORY_SEQ, DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN, ATTRIBUTE1,
	                                     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
	    VALUES (SEQ1_SCM_ADM_DQ_COLUMN_H.NEXTVAL, NVL(V_DQ_ID, 0), NVL(V_COLUMN_NAME,'-'),
	            NVL(V_VALUE_YN,'N'), NVL(V_VALUE_TYPE,'STR'), NVL(V_VALID_YN,'Y'), V_ATTRIBUTE1,
	            NVL(V_CREATED_BY,'system'), SYSDATE, NVL(V_LAST_UPDATED_BY,'system'), SYSDATE);
	
	    IF V_ACTIVE_FLAG = 'I' THEN
	        DELETE FROM SCM_ADM_DQ_COLUMN WHERE DQ_ID=V_DQ_ID AND COLUMN_NAME=V_COLUMN_NAME;
	        INSERT INTO SCM_ADM_DQ_COLUMN (DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN, ATTRIBUTE1,
	                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
	        VALUES (NVL(V_DQ_ID, 0), NVL(V_COLUMN_NAME,'-'), NVL(V_VALUE_YN,'N'), NVL(V_VALUE_TYPE,'STR'),
	                NVL(V_VALID_YN,'Y'), V_ATTRIBUTE1, NVL(V_CREATED_BY,'system'), SYSDATE,
	                NVL(V_LAST_UPDATED_BY,'system'), SYSDATE);
	    ELSIF V_ACTIVE_FLAG = 'M' THEN
	        UPDATE SCM_ADM_DQ_COLUMN
	           SET VALUE_YN=NVL(V_VALUE_YN,'N'), VALUE_TYPE=NVL(V_VALUE_TYPE,'STR'),
	               VALID_YN=NVL(V_VALID_YN,'Y'), ATTRIBUTE1=V_ATTRIBUTE1,
	               LAST_UPDATED_BY=NVL(V_LAST_UPDATED_BY,'system'), LAST_UPDATE_DATE=SYSDATE
	         WHERE DQ_ID=V_DQ_ID AND COLUMN_NAME=V_COLUMN_NAME;
	    ELSIF V_ACTIVE_FLAG = 'D' THEN
	        DELETE FROM SCM_ADM_DQ_COLUMN WHERE DQ_ID=V_DQ_ID AND COLUMN_NAME=V_COLUMN_NAME;
	    END IF;
	END LOOP;    

    OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL;
END SYS0013_SAVE_COLUMNS;
/

-- ===== SYS0013_SAVE_PARAMETERS =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_SAVE_PARAMETERS" (
/**
 * 2026-06-18 Dynmaic Query List 파라미터 정보 Multiple Row 데이터 변경이 가능하도록 프로시저 수정 by byunmj0223
 */
/*	
    P_ACTIVE_FLAG       IN VARCHAR2,
    P_DQ_ID             IN VARCHAR2,
    P_PARAMETER_ID      IN VARCHAR2,
    P_PARAMETER_TYPE    IN VARCHAR2,
    P_OPERATION_ID      IN VARCHAR2,
    P_VALID_YN          IN VARCHAR2,
    P_REP_YN            IN VARCHAR2,
    P_ATTRIBUTE1        IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,    
*/  
	P_DATA				IN CLOB,
    O_RC1               OUT SYS_REFCURSOR
) IS
	V_ACTIVE_FLAG       VARCHAR2(1);
    V_DQ_ID             NUMBER(10, 0);
    V_PARAMETER_ID      VARCHAR2(150);
    V_PARAMETER_TYPE    VARCHAR2(50);
    V_OPERATION_ID      VARCHAR2(30);
    V_VALID_YN          VARCHAR2(1);
    V_REP_YN            VARCHAR2(1);
    V_ATTRIBUTE1        VARCHAR2(150);
    V_CREATED_BY        VARCHAR2(150);
    V_LAST_UPDATED_BY   VARCHAR2(150);
BEGIN
    FOR JT IN (
          SELECT
                JT.ACTIVE_FLAG        AS V_ACTIVE_FLAG
              , JT.DQ_ID    		  AS V_DQ_ID
              , JT.PARAMETER_ID       AS V_PARAMETER_ID
              , JT.PARAMETER_TYPE     AS V_PARAMETER_TYPE
              , JT.OPERATION_ID		  AS V_OPERATION_ID
              , JT.VALID_YN			  AS V_VALID_YN
              , JT.REP_YN			  AS V_REP_YN
              , JT.ATTRIBUTE1	  	  AS V_ATTRIBUTE1
              , JT.CREATED_BY		  AS V_CREATED_BY
              , JT.LAST_UPDATED_BY	  AS V_LAST_UPDATED_BY
          FROM JSON_TABLE(
              P_DATA
            , '$[*]'
              COLUMNS (
                    ACTIVE_FLAG        VARCHAR2(1)    		PATH '$.CRUD_TYPE'
                  , DQ_ID    		   NUMBER(10,0)   		PATH '$.DQ_ID' NULL ON EMPTY NULL ON ERROR
                  , PARAMETER_ID       VARCHAR2(150 CHAR)  	PATH '$.PARAMETER_ID' NULL ON EMPTY NULL ON ERROR
                  , PARAMETER_TYPE     VARCHAR2(50 CHAR) 	PATH '$.PARAMETER_TYPE' NULL ON EMPTY NULL ON ERROR
                  , OPERATION_ID	   VARCHAR2(30 CHAR)	PATH '$.OPERATION_ID'
                  , VALID_YN		   VARCHAR2(1 CHAR)		PATH '$.VALID_YN' NULL ON EMPTY NULL ON ERROR
                  , REP_YN		   	   VARCHAR2(1 CHAR)		PATH '$.REP_YN'
                  , ATTRIBUTE1	   	   VARCHAR2(150 CHAR)	PATH '$.ATTRIBUTE1'
                  , CREATED_BY		   VARCHAR2(150 CHAR)	PATH '$.CREATED_BY' NULL ON EMPTY NULL ON ERROR
                  , LAST_UPDATED_BY	   VARCHAR2(150 CHAR)	PATH '$.LAST_UPDATED_BY' NULL ON EMPTY NULL ON ERROR
              )
          ) JT
      ) LOOP
	    V_ACTIVE_FLAG := JT.V_ACTIVE_FLAG;
		V_DQ_ID := JT.V_DQ_ID;
		V_PARAMETER_ID := JT.V_PARAMETER_ID;
		V_PARAMETER_TYPE := JT.V_PARAMETER_TYPE;
		V_OPERATION_ID := JT.V_OPERATION_ID;
		V_VALID_YN := JT.V_VALID_YN;
		V_REP_YN := JT.V_REP_YN;
		V_ATTRIBUTE1 := JT.V_ATTRIBUTE1;
		V_CREATED_BY := JT.V_CREATED_BY;
		V_LAST_UPDATED_BY := JT.V_LAST_UPDATED_BY;
	    
	    INSERT INTO SCM_ADM_DQ_PARAMETER_H (HISTORY_SEQ, DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID,
	                                        VALID_YN, REP_YN, ATTRIBUTE1, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
	    VALUES (SEQ1_SCM_ADM_DQ_PARAMETER_H.NEXTVAL, NVL(V_DQ_ID, 0), NVL(V_PARAMETER_ID,'-'),
	            NVL(V_PARAMETER_TYPE,'TEXT'), NVL(V_OPERATION_ID,'-'), NVL(V_VALID_YN,'Y'), NVL(V_REP_YN,'N'),
	            V_ATTRIBUTE1, NVL(V_CREATED_BY,'system'), SYSDATE, NVL(V_LAST_UPDATED_BY,'system'), SYSDATE);
	
	    IF V_ACTIVE_FLAG = 'I' THEN
	        DELETE FROM SCM_ADM_DQ_PARAMETER WHERE DQ_ID=V_DQ_ID AND PARAMETER_ID=V_PARAMETER_ID;
	        INSERT INTO SCM_ADM_DQ_PARAMETER (DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN,
	                                          ATTRIBUTE1, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
	        VALUES (NVL(V_DQ_ID, 0), NVL(V_PARAMETER_ID,'-'), NVL(V_PARAMETER_TYPE,'TEXT'),
	                NVL(V_OPERATION_ID,'-'), NVL(V_VALID_YN,'Y'), NVL(V_REP_YN,'N'), V_ATTRIBUTE1,
	                NVL(V_CREATED_BY,'system'), SYSDATE, NVL(V_LAST_UPDATED_BY,'system'), SYSDATE);
	    ELSIF V_ACTIVE_FLAG = 'M' THEN
	        UPDATE SCM_ADM_DQ_PARAMETER
	           SET PARAMETER_TYPE=NVL(V_PARAMETER_TYPE,'TEXT'), OPERATION_ID=NVL(V_OPERATION_ID,'-'),
	               VALID_YN=NVL(V_VALID_YN,'Y'), REP_YN=NVL(V_REP_YN,'N'), ATTRIBUTE1=V_ATTRIBUTE1,
	               LAST_UPDATED_BY=NVL(V_LAST_UPDATED_BY,'system'), LAST_UPDATE_DATE=SYSDATE
	         WHERE DQ_ID=V_DQ_ID AND PARAMETER_ID=V_PARAMETER_ID;
	    ELSIF V_ACTIVE_FLAG = 'D' THEN
	        DELETE FROM SCM_ADM_DQ_PARAMETER WHERE DQ_ID=V_DQ_ID AND PARAMETER_ID=V_PARAMETER_ID;
	    END IF;
	END LOOP;  

    OPEN O_RC1 FOR SELECT 'success' AS CODE FROM DUAL;
END SYS0013_SAVE_PARAMETERS;
/

-- ===== SYS0013_SAVE_QUERY =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_SAVE_QUERY" (
/**
 * 2026-06-18 Dynmaic Query List QUERY 정보 Multiple Row 데이터 변경이 가능하도록 프로시저 수정 by byunmj0223
 */
/*
    P_ACTIVE_FLAG       IN VARCHAR2,
    P_DQ_ID             IN VARCHAR2,
    P_DIVISION_ID       IN VARCHAR2,
    P_DQ_NAME           IN VARCHAR2,
    P_DESCRIPTION       IN VARCHAR2,
    P_DQ_TEXT           IN CLOB,
    P_VALID_YN          IN VARCHAR2,
    P_ADMIN_ONLY_YN     IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
*/
	P_DATA				IN CLOB,
    O_RC1               OUT SYS_REFCURSOR
) IS
	V_ACTIVE_FLAG       VARCHAR2(1);
    V_DQ_ID             NUMBER;
    V_DIVISION_ID       VARCHAR2(30);
    V_DQ_NAME           VARCHAR2(500);
    V_DESCRIPTION       VARCHAR2(1000);
    V_DQ_TEXT           CLOB;
    V_VALID_YN          VARCHAR2(1);
    V_ADMIN_ONLY_YN     VARCHAR2(1);
    V_CREATED_BY        VARCHAR2(150);
    V_LAST_UPDATED_BY   VARCHAR2(150);  
    V_NEW_ID    		VARCHAR2(1000);
BEGIN
    V_NEW_ID := '';

	FOR JT IN (
          SELECT
                JT.ACTIVE_FLAG        AS V_ACTIVE_FLAG
              , JT.DQ_ID    		  AS V_DQ_ID
              , JT.DIVISION_ID        AS V_DIVISION_ID
              , JT.DQ_NAME        	  AS V_DQ_NAME
              , JT.DESCRIPTION        AS V_DESCRIPTION
              , JT.DQ_TEXT            AS V_DQ_TEXT
              , JT.VALID_YN			  AS V_VALID_YN
              , JT.ADMIN_ONLY_YN	  AS V_ADMIN_ONLY_YN
              , JT.CREATED_BY		  AS V_CREATED_BY
              , JT.LAST_UPDATED_BY	  AS V_LAST_UPDATED_BY
          FROM JSON_TABLE(
              P_DATA
            , '$[*]'
              COLUMNS (
                    ACTIVE_FLAG        VARCHAR2(1)    		PATH '$.CRUD_TYPE'
                  , DQ_ID    		   NUMBER(10,0)   		PATH '$.DQ_ID' NULL ON EMPTY NULL ON ERROR
                  , DIVISION_ID        VARCHAR2(30 CHAR)  	PATH '$.DIVISION_ID' NULL ON EMPTY NULL ON ERROR
                  , DQ_NAME        	   VARCHAR2(500 CHAR) 	PATH '$.DQ_NAME' NULL ON EMPTY NULL ON ERROR
                  , DESCRIPTION        VARCHAR2(1000 CHAR)  PATH '$.DESCRIPTION' NULL ON EMPTY NULL ON ERROR
                  , DQ_TEXT			   CLOB			  		PATH '$.DQ_TEXT' NULL ON EMPTY NULL ON ERROR
                  , VALID_YN		   VARCHAR2(1 CHAR)		PATH '$.VALID_YN' NULL ON EMPTY NULL ON ERROR
                  , ADMIN_ONLY_YN	   VARCHAR2(1 CHAR)		PATH '$.ADMIN_ONLY_YN' NULL ON EMPTY NULL ON ERROR
                  , CREATED_BY		   VARCHAR2(150 CHAR)	PATH '$.CREATED_BY' NULL ON EMPTY NULL ON ERROR
                  , LAST_UPDATED_BY	   VARCHAR2(150 CHAR)	PATH '$.LAST_UPDATED_BY' NULL ON EMPTY NULL ON ERROR
              )
          ) JT
      ) LOOP
	    V_ACTIVE_FLAG := JT.V_ACTIVE_FLAG;
		V_DQ_ID := JT.V_DQ_ID;
		V_DIVISION_ID := JT.V_DIVISION_ID;
		V_DQ_NAME := JT.V_DQ_NAME;
		V_DESCRIPTION := JT.V_DESCRIPTION;
		V_DQ_TEXT := JT.V_DQ_TEXT;
		V_VALID_YN := JT.V_VALID_YN;
		V_ADMIN_ONLY_YN := JT.V_ADMIN_ONLY_YN;
		V_CREATED_BY := JT.V_CREATED_BY;
		V_LAST_UPDATED_BY := JT.V_LAST_UPDATED_BY;		

	    -- HIST INSERT
	    INSERT INTO SCM_ADM_DQ_LIST_H (HISTORY_SEQ, DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT, VALID_YN, ADMIN_ONLY_YN,
	                                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
	    VALUES (SEQ1_SCM_ADM_DQ_LIST_H.NEXTVAL, NVL(V_DQ_ID, 0), NVL(V_DIVISION_ID,'-'), NVL(V_DQ_NAME,'-'),
	            NVL(V_DESCRIPTION,'-'), NVL(V_DQ_TEXT,'-'), NVL(V_VALID_YN,'Y'), NVL(V_ADMIN_ONLY_YN,'Y'),
	            NVL(V_CREATED_BY,'system'), SYSDATE, NVL(V_LAST_UPDATED_BY,'system'), SYSDATE);
	
	    IF V_ACTIVE_FLAG = 'I' THEN
	        SELECT NVL(MAX(TO_NUMBER(DQ_ID)),0)+1 INTO V_NEW_ID FROM SCM_ADM_DQ_LIST;
	        INSERT INTO SCM_ADM_DQ_LIST (DQ_ID, DIVISION_ID, DQ_NAME, DESCRIPTION, DQ_TEXT, VALID_YN, ADMIN_ONLY_YN,
	                                     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
	        VALUES (TO_CHAR(V_NEW_ID), NVL(V_DIVISION_ID,'-'), NVL(V_DQ_NAME,'-'), NVL(V_DESCRIPTION,'-'),
	                NVL(V_DQ_TEXT,'-'), NVL(V_VALID_YN,'Y'), NVL(V_ADMIN_ONLY_YN,'Y'),
	                NVL(V_CREATED_BY,'system'), SYSDATE, NVL(V_LAST_UPDATED_BY,'system'), SYSDATE);
	    ELSIF V_ACTIVE_FLAG = 'M' THEN
	        UPDATE SCM_ADM_DQ_LIST
	           SET DIVISION_ID=NVL(V_DIVISION_ID,'-'), DQ_NAME=NVL(V_DQ_NAME,'-'),
	               DESCRIPTION=NVL(V_DESCRIPTION,'-'), DQ_TEXT=NVL(V_DQ_TEXT,'-'),
	               VALID_YN=NVL(V_VALID_YN,'Y'), ADMIN_ONLY_YN=NVL(V_ADMIN_ONLY_YN,'Y'),
	               LAST_UPDATED_BY=NVL(V_LAST_UPDATED_BY,'system'), LAST_UPDATE_DATE=SYSDATE
	         WHERE DQ_ID = V_DQ_ID;
	    
	    	IF LENGTH(V_NEW_ID) > 0 THEN
		        V_NEW_ID := V_NEW_ID || '#' || TO_NUMBER(V_DQ_ID);
	    	ELSE
	    		V_NEW_ID := TO_NUMBER(V_DQ_ID);
	    	END IF;
	    ELSIF V_ACTIVE_FLAG = 'D' THEN
	        DELETE FROM SCM_ADM_DQ_LIST WHERE DQ_ID = V_DQ_ID;
	        
	    	IF LENGTH(V_NEW_ID) > 0 THEN
		        V_NEW_ID := V_NEW_ID || '#' || TO_NUMBER(V_DQ_ID);
	    	ELSE
	    		V_NEW_ID := TO_NUMBER(V_DQ_ID);
	    	END IF;
	    END IF;
	  END LOOP;
	    
	  COMMIT;  

    OPEN O_RC1 FOR SELECT 'success' AS CODE, V_NEW_ID AS SEQNO FROM DUAL;
END SYS0013_SAVE_QUERY;
/

-- ===== SYS0013_SAVE_USER_GROUP =====
CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."SYS0013_SAVE_USER_GROUP" (
    P_DQ_ID             IN VARCHAR2,
    P_GROUP_ID          IN VARCHAR2,
    P_VALID_YN          IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
) IS
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
END SYS0013_SAVE_USER_GROUP;
/
