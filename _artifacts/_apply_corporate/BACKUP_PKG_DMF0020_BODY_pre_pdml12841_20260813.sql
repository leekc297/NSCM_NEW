CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0020"
AS


PROCEDURE P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE
(
/* 보류 PCI 협의 3/19
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
*/
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/04  kuniid         [C20210127-000163] GSCM Sales Price 일괄입력 기능 개선 요청
 * 2025.01.13	KJJ			[PJ2024-50611] Sales Price 로직 수정 - 별도 룩업이 아니라 해당화면의 메저에서 가져오게 변경
 * 2026.03.16  jcnam          [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT DISTINCT T1.COLUMN_LABEL_NAME AS LOOKUP_CODE
         , T1.COLUMN_LABEL_NAME AS DESCRIPTION
         , 99                AS DISPLAY_ALL
         -- ,NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   SCM_MST_SHEET_MEASURE T1
    /* 보류 PCI 협의 3/19
        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
     ON T2.UNIT_ID in (
         SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
         FROM   DUAL
         CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
     )
    */

    WHERE  T1.PROGRAM_ID  = 'DMF0020'
    AND    T1.SHEET_NAME  = 'Sales Price'
    AND    T1.VALID_YN    = 'Y'
    AND    T1.COLUMN_NAME = 'LOC';

    ----SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL
    ----FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    ----WHERE VALID_YN = 'Y'
    ----AND SEGMENT1 <> 'LOC'
    ----AND LOOKUP_TYPE = 'FUTUREMEASURE'
    ----UNION ALL
    /*
     SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 [DESCRIPTION], 99 AS DISPLAY_ALL
     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE VALID_YN = 'Y'
     AND SEGMENT1 = 'LOC'
     AND LOOKUP_TYPE = 'FUTUREMEASURE'
   */

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        /* 보류 PCI 협의 3/19
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_USER_ID'   VALUE P_USER_ID,
                'P_MNU_ID'   VALUE P_MNU_ID
            );
        */
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE;



PROCEDURE P_DMF0020_GET_MEASURE_COUNTINFO
(
/*
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
*/
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024/05/17  KJJ         이동계획 판가 - DISPLAY_SEQ로 정렬 추가
 * 2025.01.13	KJJ			[PJ2024-50611] Sales Price 로직 수정 - 별도 룩업이 아니라 해당화면의 메저에서 가져오게 변경
 * 2026.03.16  jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 */

    -- EXCEPTION 블록 필수 변수
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

    -- ================================================================
    -- START 로그
    -- ================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- ================================================================
    -- 메인 조회
    -- ================================================================
    OPEN O_RC1 FOR
    SELECT
        DISTINCT
         T1.COLUMN_LABEL_NAME AS LOOKUP_CODE
       , T1.COLUMN_LABEL_NAME AS DESCRIPTION
       , 99 AS DISPLAY_ALL
       , T1.SORT_ORDER_NO AS DISPLAY_SEQ
       -- , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  SCM_MST_SHEET_MEASURE T1
    /*
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID
    */
    WHERE  PROGRAM_ID = 'DMF0020'
    AND SHEET_NAME = 'Sales Price'
    AND VALID_YN = 'Y'
    ORDER BY SORT_ORDER_NO;
    /*
    SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL,DISPLAY_SEQ
    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE VALID_YN = 'Y'
    AND SEGMENT1 <> 'LOC'
    AND LOOKUP_TYPE = 'FUTUREMEASURE'
    UNION ALL
    SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL,DISPLAY_SEQ
    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE VALID_YN = 'Y'
    AND SEGMENT1 = 'LOC'
    AND LOOKUP_TYPE = 'FUTUREMEASURE'
    order by DISPLAY_SEQ
    */

    -- ================================================================
    -- 조회 성공 O_RESULT_CURSOR (Case 3 표준 패턴)
    -- ================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    -- ================================================================
    -- END 로그
    -- ================================================================
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
        /*
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_USER_ID'   VALUE P_USER_ID,
                'P_MNU_ID'   VALUE P_MNU_ID
            );
        */
        V_PROC_INPUT  := '{}';
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
END P_DMF0020_GET_MEASURE_COUNTINFO;



PROCEDURE P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE                                            */
/* Description : Procedure 작성 가이드																*/
/* Usage       : Procedure 작성 시 참조하세요!														*/
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/04/01  JYE		     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트	*/
/* 2022/10/24	ROSIA27		 [C20221024-000510]DM UI 소스 정리 요청									*/
/* 2026.03.16  jcnam         [PJ20264226] NextSCM Pilot 설계 및 개발                                 */
/*                                                                                                  */
/****************************************************************************************************/

    -- EXCEPTION 블록 필수 변수
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

    -- ================================================================
    -- START 로그
    -- ================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- ================================================================
    -- 메인 조회
    -- ================================================================
    OPEN O_RC1 FOR
    SELECT   MIN(BASIS_START_DATE) AS BASIS_START_DATE, CALENDAR_YYYY, CALENDAR_MONTH
    FROM SCM_SYS_CALENDAR_M
    WHERE
    BASIS_YYYYMMDD >= P_START_YYYYMMDD AND BASIS_YYYYMMDD <= P_END_YYYYMMDD
    GROUP BY CALENDAR_YYYY, CALENDAR_MONTH
    ORDER BY BASIS_START_DATE;

    -- ================================================================
    -- 조회 성공 O_RESULT_CURSOR (Case 3 표준 패턴)
    -- ================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    -- ================================================================
    -- END 로그
    -- ================================================================
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
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD
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
END P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE;



PROCEDURE P_DMF0020_GET_FUTUREPRICE_INFO
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,

    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0020_GET_FUTUREPRICE_INFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.16  jcnam         [PJ20264226] NextSCM Pilot 설계 및 개발
 */

    -- EXCEPTION 블록 필수 변수
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

    -- ================================================================
    -- START 로그
    -- ================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- ================================================================
    -- 메인 조회
    -- ================================================================
    OPEN O_RC1 FOR
    SELECT DISTINCT T1.YYYYMMDD, SUBSTR(T1.YYYYMMDD, 1, 6) AS YYYYMM, T1.DIVISION_ID, T1.CURRENCY, T1.UNIT_CURRENCY, T1.EXCHANGE_PRICE, NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM DM_MST_EXCHANGE_RATE T1
                INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE
    T1.YYYYMMDD >= P_START_YYYYMMDD AND T1.YYYYMMDD <= P_END_YYYYMMDD;

    -- ================================================================
    -- 조회 성공 O_RESULT_CURSOR (Case 3 표준 패턴)
    -- ================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    -- ================================================================
    -- END 로그
    -- ================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0020_GET_FUTUREPRICE_INFO;


PROCEDURE P_DMF0000_SAVE_EXCHANGE_POPUP_DATA
(
      P_ACTIVE_FLAG            IN VARCHAR2
    , P_DIVISION_ID            IN VARCHAR2
    , P_YYYYMMDD               IN VARCHAR2
    , P_CURRENCY               IN VARCHAR2
    , P_UNIT_CURRENCY          IN VARCHAR2
    , P_EXCHANGE_PRICE         IN VARCHAR2
    , P_CREATED_BY             IN VARCHAR2
    , P_LAST_UPDATED_BY        IN VARCHAR2
    , O_RESULT_CURSOR          OUT SYS_REFCURSOR
)
AS
/*====================================================================================================
 * Description  : 사용자 환율 관리 프로그램 (개발기준, Sales Price,Sales Plan,Fcst&Price에서 사용)
 * Program ID  : DMF0000_GET_EXCHANGE_POPUP_DATA
 * Usage       : DM_MST_EXCHANGE_RATE TABLE INSERT/UPDATE/DELETE
 * Parameter   :
 *====================================================================================================
 *	  Date		In Charge		Description
 *====================================================================================================
 * 2025.04.24	dsiol			[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율 관리 프로그램
 * 								DMF0042_SAVE_DM_BP_EXCHANGE_RATE 참고 해서 만듬
 * 2026.03.16  jcnam            [PJ20264226] NextSCM Pilot 설계 및 개발
 *===================================================================================================*/

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

    ---------------------------------------------------------------------------------
    -- 스플릿관련 변수
    ---------------------------------------------------------------------------------
    V_RECV_ACTIVE_FLAG  VARCHAR2(4000 CHAR);

    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_YYYYMMDD          VARCHAR2(4000 CHAR);
    V_CURRENCY          VARCHAR2(4000 CHAR);
    V_UNIT_CURRENCY     VARCHAR2(4000 CHAR);
    V_EXCHANGE_PRICE    VARCHAR2(4000 CHAR);
    V_CREATED_BY        VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR);

    V_DELIMITER         VARCHAR2(1 CHAR) := '^';

    -- 파싱용 로컬 복사본 (IN 파라미터는 수정 불가하므로)
    V_P_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
    V_P_DIVISION_ID     VARCHAR2(4000 CHAR);
    V_P_YYYYMMDD        VARCHAR2(4000 CHAR);
    V_P_CURRENCY        VARCHAR2(4000 CHAR);
    V_P_UNIT_CURRENCY   VARCHAR2(4000 CHAR);
    V_P_EXCHANGE_PRICE  VARCHAR2(4000 CHAR);
    V_P_CREATED_BY      VARCHAR2(4000 CHAR);
    V_P_LAST_UPDATED_BY VARCHAR2(4000 CHAR);

    V_IDX_AF            PLS_INTEGER;
    V_IDX_DI            PLS_INTEGER;
    V_IDX_YM            PLS_INTEGER;
    V_IDX_CR            PLS_INTEGER;
    V_IDX_UC            PLS_INTEGER;
    V_IDX_EP            PLS_INTEGER;
    V_IDX_CB            PLS_INTEGER;
    V_IDX_LU            PLS_INTEGER;

    N_DELETE_COUNT      PLS_INTEGER := 0;
    N_MERGE_COUNT       PLS_INTEGER := 0;

    V_EXISTS            PLS_INTEGER := 0;

    V_RC1               SYS_REFCURSOR;

BEGIN

    -- ================================================================
    -- GTT 초기화
    -- ================================================================
    DELETE FROM SCM_MGR.GT_D000_RESULTS;
    -- EXECUTE IMMEDIATE 'ALTER SESSION SET GLOBAL_TEMP_TABLE_STATS = SESSION';

    -- ================================================================
    -- START 로그
    -- ================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    ---------------------------------------------------------------------------------
    -- recv init
    ---------------------------------------------------------------------------------
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_ACTIVE_FLAG     := NULL;
    V_DIVISION_ID     := NULL;
    V_YYYYMMDD        := NULL;
    V_CURRENCY        := NULL;
    V_UNIT_CURRENCY   := NULL;
    V_EXCHANGE_PRICE  := NULL;
    V_CREATED_BY      := NULL;
    V_LAST_UPDATED_BY := NULL;

    ---------------------------------------------------------------------------------
    -- 마지막 데이터 처리를 위한 구분자 추가
    ---------------------------------------------------------------------------------
    V_P_ACTIVE_FLAG     := RTRIM(P_ACTIVE_FLAG)     || '^';
    V_P_DIVISION_ID     := RTRIM(P_DIVISION_ID)     || '^';
    V_P_YYYYMMDD        := RTRIM(P_YYYYMMDD)        || '^';
    V_P_CURRENCY        := RTRIM(P_CURRENCY)        || '^';
    V_P_UNIT_CURRENCY   := RTRIM(P_UNIT_CURRENCY)   || '^';
    V_P_EXCHANGE_PRICE  := RTRIM(P_EXCHANGE_PRICE)  || '^';
    V_P_CREATED_BY      := RTRIM(P_CREATED_BY)      || '^';
    V_P_LAST_UPDATED_BY := RTRIM(P_LAST_UPDATED_BY) || '^';

    ---------------------------------------------------------------------------------
    -- GT_D000_RESULTS 테이블에 split후 insert (START)
    ---------------------------------------------------------------------------------
    WHILE LENGTH(V_P_DIVISION_ID) > 0
    LOOP
        V_IDX_AF := INSTR(V_P_ACTIVE_FLAG,     '^');
        V_IDX_DI := INSTR(V_P_DIVISION_ID,     '^');
        V_IDX_YM := INSTR(V_P_YYYYMMDD,        '^');
        V_IDX_CR := INSTR(V_P_CURRENCY,        '^');
        V_IDX_UC := INSTR(V_P_UNIT_CURRENCY,   '^');
        V_IDX_EP := INSTR(V_P_EXCHANGE_PRICE,  '^');
        V_IDX_CB := INSTR(V_P_CREATED_BY,      '^');
        V_IDX_LU := INSTR(V_P_LAST_UPDATED_BY, '^');

        IF V_IDX_DI > 0 THEN
            V_ACTIVE_FLAG     := SUBSTR(V_P_ACTIVE_FLAG,     1, V_IDX_AF - 1);
            V_P_ACTIVE_FLAG   := SUBSTR(V_P_ACTIVE_FLAG,     V_IDX_AF + 1);

            V_DIVISION_ID     := SUBSTR(V_P_DIVISION_ID,     1, V_IDX_DI - 1);
            V_P_DIVISION_ID   := SUBSTR(V_P_DIVISION_ID,     V_IDX_DI + 1);

            V_YYYYMMDD        := SUBSTR(V_P_YYYYMMDD,        1, V_IDX_YM - 1);
            V_P_YYYYMMDD      := SUBSTR(V_P_YYYYMMDD,        V_IDX_YM + 1);

            V_CURRENCY        := SUBSTR(V_P_CURRENCY,        1, V_IDX_CR - 1);
            V_P_CURRENCY      := SUBSTR(V_P_CURRENCY,        V_IDX_CR + 1);

            V_UNIT_CURRENCY   := SUBSTR(V_P_UNIT_CURRENCY,   1, V_IDX_UC - 1);
            V_P_UNIT_CURRENCY := SUBSTR(V_P_UNIT_CURRENCY,   V_IDX_UC + 1);

            V_EXCHANGE_PRICE  := SUBSTR(V_P_EXCHANGE_PRICE,  1, V_IDX_EP - 1);
            V_P_EXCHANGE_PRICE:= SUBSTR(V_P_EXCHANGE_PRICE,  V_IDX_EP + 1);

            V_CREATED_BY      := SUBSTR(V_P_CREATED_BY,      1, V_IDX_CB - 1);
            V_P_CREATED_BY    := SUBSTR(V_P_CREATED_BY,      V_IDX_CB + 1);

            V_LAST_UPDATED_BY := SUBSTR(V_P_LAST_UPDATED_BY, 1, V_IDX_LU - 1);
            V_P_LAST_UPDATED_BY := SUBSTR(V_P_LAST_UPDATED_BY, V_IDX_LU + 1);

            --■■■■■■■■■■ 40 Validation 필요 대상 : UNIT_CURRENCY 유무
            IF V_UNIT_CURRENCY IS NULL OR V_UNIT_CURRENCY = '' THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'Unit이 입력되어있지 않습니다.' || CHR(10) || CHR(13) || 'LOOKUP : CURRENCY_LIST 에서 통화를 등록해주세요.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            --■■■■■■■■■■ 40 Validation 필요 대상 : EXCHANGE_PRICE는 0보다 커야 한다. (음수거나 0이면 안됨)
            IF NVL(TO_NUMBER(V_EXCHANGE_PRICE), 0) <= 0 THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '0 보다 크게 입력 해주세요.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            INSERT INTO SCM_MGR.GT_D000_RESULTS
                ( ACTIVE_FLAG, DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, LAST_UPDATED_BY )
            VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_YYYYMMDD, V_CURRENCY, V_UNIT_CURRENCY, V_EXCHANGE_PRICE, V_CREATED_BY, V_LAST_UPDATED_BY );

        ELSE
            V_DIVISION_ID   := V_P_DIVISION_ID;
            V_P_DIVISION_ID := NULL;

            INSERT INTO SCM_MGR.GT_D000_RESULTS
                ( ACTIVE_FLAG, DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, LAST_UPDATED_BY )
            VALUES
                ( V_ACTIVE_FLAG, V_DIVISION_ID, V_YYYYMMDD, V_CURRENCY, V_UNIT_CURRENCY, V_EXCHANGE_PRICE, V_CREATED_BY, V_LAST_UPDATED_BY );
        END IF;

        -- Division_id Null Validation
        BEGIN
            SELECT 1 INTO V_EXISTS FROM DUAL
            WHERE EXISTS (
                SELECT 1 FROM SCM_MST_DIVISION WHERE 1 = 1 AND DIVISION_ID = V_DIVISION_ID
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LOG_TYPE    := 'END';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := 'Division 값이 존재하지 않습니다.';
                D_EVENT_DATE  := SYSDATE;
                BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
        END;

    END LOOP;
    ---------------------------------------------------------------------------------
    -- GT_D000_RESULTS 테이블에 split후 insert (END)
    ---------------------------------------------------------------------------------

    -- GTT COMMIT (ON COMMIT PRESERVE ROWS)
    COMMIT;

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        ownname          => 'SCM_MGR',
        tabname          => 'GT_D000_RESULTS',
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        method_opt       => 'FOR ALL COLUMNS SIZE 1'
    );

    ---------------------------------------------------------------------------------
    --■■■■■■■■■■ Validation Check : 중복된 데이터 확인 (START)
    ---------------------------------------------------------------------------------
    BEGIN
        SELECT 1 INTO V_EXISTS FROM DUAL
        WHERE EXISTS (
            SELECT 1
            FROM DM_MST_EXCHANGE_RATE A
            INNER JOIN SCM_MGR.GT_D000_RESULTS B
                    ON A.DIVISION_ID   = B.DIVISION_ID
                   AND A.YYYYMMDD      = B.YYYYMMDD
                   AND A.CURRENCY      = B.CURRENCY
                   AND A.UNIT_CURRENCY = B.UNIT_CURRENCY
            WHERE B.ACTIVE_FLAG = 'I'
        );

        -- 존재하면 중복
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '중복된 데이터가 존재 합니다.';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- 중복 없음 → 정상 진행
    END;
    ---------------------------------------------------------------------------------
    --■■■■■■■■■■ Validation Check : 중복된 데이터 확인 (END)
    ---------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------
    -- DELETE (START)
    ---------------------------------------------------------------------------------
    DELETE
    FROM DM_MST_EXCHANGE_RATE
    WHERE EXISTS (
        SELECT 1 FROM SCM_MGR.GT_D000_RESULTS R
        WHERE R.ACTIVE_FLAG = 'D'
        AND DM_MST_EXCHANGE_RATE.DIVISION_ID   = R.DIVISION_ID
        AND DM_MST_EXCHANGE_RATE.YYYYMMDD      = R.YYYYMMDD
        AND DM_MST_EXCHANGE_RATE.CURRENCY      = R.CURRENCY
        AND DM_MST_EXCHANGE_RATE.UNIT_CURRENCY = R.UNIT_CURRENCY
    );

    N_DELETE_COUNT := SQL%ROWCOUNT;
    ---------------------------------------------------------------------------------
    -- DELETE (END)
    ---------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------
    -- UPDATE, INSERT (START)
    ---------------------------------------------------------------------------------
    MERGE INTO DM_MST_EXCHANGE_RATE A
    USING (
        SELECT DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY
             , MAX(EXCHANGE_PRICE)  AS EXCHANGE_PRICE
             , MAX(CREATED_BY)      AS CREATED_BY
             , MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM  SCM_MGR.GT_D000_RESULTS
        WHERE ACTIVE_FLAG <> 'D'   -- DELETE값이 아닌경우만
        GROUP BY DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY
    ) B
        ON (    A.DIVISION_ID   = B.DIVISION_ID
            AND A.YYYYMMDD      = B.YYYYMMDD
            AND A.CURRENCY      = B.CURRENCY
            AND A.UNIT_CURRENCY = B.UNIT_CURRENCY )
    WHEN MATCHED THEN
    UPDATE SET A.EXCHANGE_PRICE   = B.EXCHANGE_PRICE
             , A.LAST_UPDATED_BY  = B.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
    INSERT ( DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    VALUES ( B.DIVISION_ID, B.YYYYMMDD, B.CURRENCY, B.UNIT_CURRENCY, B.EXCHANGE_PRICE, B.CREATED_BY, SYSDATE, B.LAST_UPDATED_BY, SYSDATE );

    N_MERGE_COUNT := SQL%ROWCOUNT;

    INSERT INTO DM_MST_EXCHANGE_RATE_H
    ( HISTORY_SEQ
    , DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE
    , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    SELECT SEQ1_DM_MST_EXCHANGE_RATE.NEXTVAL
         , T.DIVISION_ID, T.YYYYMMDD, T.CURRENCY, T.UNIT_CURRENCY, T.EXCHANGE_PRICE
         , T.CREATED_BY, SYSDATE AS CREATION_DATE, T.LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
    FROM (
        SELECT DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY
             , MAX(EXCHANGE_PRICE)  AS EXCHANGE_PRICE
             , MAX(CREATED_BY)      AS CREATED_BY
             , MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY
        FROM SCM_MGR.GT_D000_RESULTS
        WHERE ACTIVE_FLAG <> 'D'
        GROUP BY DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY
    ) T;

    ---------------------------------------------------------------------------------
    -- 저장이 성공한 이후에 실행되는 프로시저 (START)
    ---------------------------------------------------------------------------------
    -- 환율이 변경되면, Sales Price, Sales Plan AMT 가 같이 업데이트 되어야 한다.
    -- 환율화면에서 환율이 변경되면 아래 2개의 프로시저가  호출되어야 한다.

    -- Sales Price Update
    SCM_MGR.DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION(V_DIVISION_ID, V_RC1);

    -- Sales Plan Update
    /* TO-DO 4/1 전환 예정
    SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(V_DIVISION_ID, 'EXCHANGE_RATE_UI');
    */
    ---------------------------------------------------------------------------------
    -- 저장이 성공한 이후에 실행되는 프로시저 (END)
    ---------------------------------------------------------------------------------

    -- COMMIT
    IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
        COMMIT;
    END IF;

    -- ================================================================
    -- DML 성공 O_RESULT_CURSOR (Case 3 표준 패턴)
    -- ================================================================
    N_LOG_COUNT := N_DELETE_COUNT + N_MERGE_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- ================================================================
    -- END 로그
    -- ================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(N_DELETE_COUNT) || ' / merge_count: ' || TO_CHAR(N_MERGE_COUNT);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_ACTIVE_FLAG'     VALUE P_ACTIVE_FLAG,
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_UNIT_CURRENCY'   VALUE P_UNIT_CURRENCY,
            'P_EXCHANGE_PRICE'  VALUE P_EXCHANGE_PRICE,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0000_SAVE_EXCHANGE_POPUP_DATA;

PROCEDURE P_DMF0020_EXCEL_UPLOAD
(
    P_MODE            IN PLS_INTEGER,
    P_CREATED_BY      IN VARCHAR2,
    P_PROGRAM_ID      IN VARCHAR2,  -- 3/26 추가 결정
    P_SHEET_NAME      IN VARCHAR2,  -- 3/26 추가 결정

    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0020_EXCEL_UPLOAD]
 * Description  : PR_DETAIL_AUTO 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.05.27   KJJ			최초 작성
 * 2024.12.31	KJJ			[E20241217-000632]_Sales Price 화면 엑셀 업로드 시 중복데이터 입력 제한
 * 2026.03.19   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 * validation: 필수값, 모델중복, Currency 중복, Division 오류, TEAM 오류
 *
 */
IS
/*


1.81 사업부만 대상임


2. LOC 값이 없을 경우 0으로 간주하여 처리(skip 이 아님)
=>기존 저장 SP(DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL) 는 무조건 삭제 후 0 값이 아닌 것들(구분자 D 가 아닌것들)만 insert 하는 것으로 되어 있으나
본 SP는 Merge into 구문으로 구현하여 0으로 처리


=>2024.06.12 로직 변경
0 으로 넣은 경우: Validation 에서 Invalid 처리
빈값으로 넣은 경우: SKIP, 기존 Sales Price 데이터를 유지



3.입력된 엑셀 row 중복체크
=>1)동일모델 입력 방지 위해 Div / Team /	End Customer /	Project Code /	Model 로 중복체크
=>2)위 체크조건 통과했을 경우 여러개 Currency 입력방지 위해 중복체크



4.ItemID가 입력되지 않은 것들과  ItemID가 입력된 건들을 나누어서 추출 후 병합(row순서는 고려하지 않음)
=>
81	자동차.마케팅.OTS.OTS2팀	Corvus Norway	A22CR1001	USD	 AMVAGBEVM-A4-D13  300	300	300	300	300
81	자동차.마케팅.OTS.OTS2팀	Corvus Norway	A22CR1001	USD					   100	100	100	100	100


81	자동차.마케팅.아시아.현대기아차팀	KIA	A22MZ1002	USD	ACHP2005I-A1T007	500	500	500	500


순서로 입력되어 있어도 ItemID가 입력되지 않은 것 먼저 처리함(2024.05.29 박필수 책임 확인사항)

=>이를 위해 ItemID 없는 건들 먼저 추출(전체 데이터셋)
=>ItemID 있는 건들 추출(ItemID 데이터셋)
=>merge into 처리


5.SCM_MST_FUTURE_PRICE , SCM_MST_FUTURE_PRICE_H 저장시 화면에서 수동으로 등록한 것과 구분하기 위해 ATTRIBUTE8 컬럼에 EXCEL UPLOAD 표시

*/

    V_PROGRAM_ID        VARCHAR2(40 CHAR) := P_PROGRAM_ID; -- 'DMF0020';
    V_SHEET_NAME        VARCHAR2(40 CHAR) := P_SHEET_NAME; -- 'Sales Price';
    V_CREATION_DATE     VARCHAR2(40 CHAR);
    V_COUNT             PLS_INTEGER;
    V_DIVISION          VARCHAR2(10 CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

    -- EXCEPTION 용 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);


BEGIN

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- v_creation_date 조회
    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
      INTO V_CREATION_DATE
      FROM SCM_ADM_EXCEL_UPLOAD T
     WHERE T.PROGRAM_ID = V_PROGRAM_ID
       AND T.SHEET_NAME = V_SHEET_NAME
       AND T.CREATED_BY = P_CREATED_BY;

    IF V_CREATION_DATE IS NULL THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        -- V_DESCRIPTION := 'Data Not Found [' || V_CREATION_DATE || ']';
        V_DESCRIPTION := to_char(0); -- 3/26 실패 시, 3번째 컬럼 0 리턴
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;

    BEGIN
        SELECT ATTRIBUTE1
          INTO V_DIVISION
          FROM SCM_ADM_EXCEL_UPLOAD
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'SUCCESS'
           AND ROWNUM             = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_DIVISION := NULL;
    END;

    -- @p_mode = 0 이면 Validation
    IF NVL(P_MODE, 0) = 0 THEN

        -- RESET Status = UPLOAD
        UPDATE SCM_ADM_EXCEL_UPLOAD T
           SET UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL
         WHERE T.PROGRAM_ID    = V_PROGRAM_ID
           AND T.SHEET_NAME    = V_SHEET_NAME
           AND T.CREATED_BY    = P_CREATED_BY
           AND TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND NVL(T.UPLOAD_STATUS_CODE, 'X') <> 'UPLOAD';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
        V_LOG_TYPE    := '1';
        V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -- SKIP EMPTY LINE
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'SKIP'
         WHERE PROGRAM_ID    = V_PROGRAM_ID
           AND SHEET_NAME    = V_SHEET_NAME
           AND CREATED_BY    = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND (   ATTRIBUTE1 IS NULL
                OR UPPER(ATTRIBUTE1) = 'TOTAL');

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
        V_LOG_TYPE    := '2';
        V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -- @TITLE Header Line
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = '@TITLE'
         WHERE PROGRAM_ID    = V_PROGRAM_ID
           AND SHEET_NAME    = V_SHEET_NAME
           AND CREATED_BY    = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPPER(ATTRIBUTE1) = 'DIV';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
        V_LOG_TYPE    := '3';
        V_LOG_MESSAGE := '########## TITLE Header Line ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        --본격적 VALIDATION 시작

        /* #################################################### */
        /* 필수 값 NULL 값 체크									*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* #################################################### */
        --Div	Team	End Customer	Project Code	Currency
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = CASE WHEN NVL(ATTRIBUTE1, '') = '' THEN 'NULL DIVISION.'
                                        WHEN NVL(ATTRIBUTE2, '') = '' THEN 'NULL TEAM.'
                                        WHEN NVL(ATTRIBUTE3, '') = '' THEN 'NULL END CUSTOMER.'
                                        WHEN NVL(ATTRIBUTE4, '') = '' THEN 'NULL PROJECT CODE.'
                                        WHEN NVL(ATTRIBUTE5, '') = '' THEN 'NULL CURRENCY.'
                                   END
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                NVL(ATTRIBUTE1, '') = '' OR NVL(ATTRIBUTE2, '') = '' OR NVL(ATTRIBUTE3, '') = '' OR NVL(ATTRIBUTE4, '') = '' OR NVL(ATTRIBUTE5, '') = ''
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## ERROR NULL Column Data ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 동일아이템 중복 체크									*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* ATTRIBUTE6 : Model									*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Duplication Model.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND EXISTS (
                SELECT 1
                FROM (
                    SELECT X.ATTRIBUTE1 AS COL1/* ATTRIBUTE1  : Div		*/
                         , X.ATTRIBUTE2 AS COL2/* ATTRIBUTE2  : Team		*/
                         , X.ATTRIBUTE3 AS COL3/* ATTRIBUTE3  : End Customer	*/
                         , X.ATTRIBUTE4 AS COL4/* ATTRIBUTE4 : Project Code	*/
                         , X.ATTRIBUTE6 AS COL6/*ATTRIBUTE6  : Model			*/
                      FROM SCM_ADM_EXCEL_UPLOAD X
                     WHERE X.PROGRAM_ID    = V_PROGRAM_ID
                       AND X.SHEET_NAME    = V_SHEET_NAME
                       AND X.CREATED_BY    = P_CREATED_BY
                       AND TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                       AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                     GROUP BY X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE6
                    HAVING COUNT(*) > 1
                ) T
                WHERE T.COL1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                  AND T.COL2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                  AND T.COL3 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                  AND T.COL4 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                  AND T.COL6 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
               );

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        V_LOG_TYPE    := '4';
        V_LOG_MESSAGE := '########## ERROR Model Duplication ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 위 체크 통과했을 경우 Currency 체크					*/
        /*두 개 이상의 Currency가 중복으로 입력되면 안됨		*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* ATTRIBUTE6 : Model									*/
        /* #################################################### */
        DECLARE
            V_MODEL_DUP_EXISTS PLS_INTEGER;
        BEGIN
            SELECT 1 INTO V_MODEL_DUP_EXISTS FROM DUAL WHERE EXISTS (
                SELECT 1
                  FROM SCM_ADM_EXCEL_UPLOAD X
                 WHERE X.PROGRAM_ID    = V_PROGRAM_ID
                   AND X.SHEET_NAME    = V_SHEET_NAME
                   AND X.CREATED_BY    = P_CREATED_BY
                   AND TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                 GROUP BY X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE6
                HAVING COUNT(*) > 1
            );
            -- 모델 중복이 존재하면 Currency 체크 skip
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- 모델 중복 없을 때만 Multiple Currency 체크
                UPDATE SCM_ADM_EXCEL_UPLOAD
                   SET UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Multiple Currency.'
                 WHERE PROGRAM_ID         = V_PROGRAM_ID
                   AND SHEET_NAME         = V_SHEET_NAME
                   AND CREATED_BY         = P_CREATED_BY
                   AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                   AND UPLOAD_STATUS_CODE = 'UPLOAD'
                   AND EXISTS (
                        SELECT 1
                        FROM (
                            SELECT COL1, COL2, COL3, COL4
                            FROM (
                                SELECT X.ATTRIBUTE1 AS COL1
                                     , X.ATTRIBUTE2 AS COL2
                                     , X.ATTRIBUTE3 AS COL3
                                     , X.ATTRIBUTE4 AS COL4
                                     , X.ATTRIBUTE5 AS COL5
                                  FROM SCM_ADM_EXCEL_UPLOAD X
                                 WHERE X.PROGRAM_ID    = V_PROGRAM_ID
                                   AND X.SHEET_NAME    = V_SHEET_NAME
                                   AND X.CREATED_BY    = P_CREATED_BY
                                   AND TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                 GROUP BY X.ATTRIBUTE1, X.ATTRIBUTE2, X.ATTRIBUTE3, X.ATTRIBUTE4, X.ATTRIBUTE5
                            ) A
                            GROUP BY COL1, COL2, COL3, COL4
                           HAVING COUNT(*) > 1
                        ) T
                        WHERE T.COL1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                          AND T.COL2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                          AND T.COL3 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                          AND T.COL4 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                       );
        END;

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
        V_LOG_TYPE    := '4';
        V_LOG_MESSAGE := '########## ERROR Multiple Currency ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* DIVISION  체크											*/
        /* #################################################### */
        --81 사업부만 처리
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Division.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND ATTRIBUTE1 NOT LIKE '81%';

        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
        V_LOG_TYPE    := '5';
        V_LOG_MESSAGE := '########## Invalid Division ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* TEAM 체크											*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid TEAM.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SSO_DEPT_INFO DI
                 WHERE DI.DEPT_NAME_KO = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                   AND DI.VALID_YN     = 'Y'
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid TEAM. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* END CUSTOMER 체크									*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid END CUSTOMER.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SITE MS
                 WHERE MS.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                   AND MS.VALID_YN     = 'Y'
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid END CUSTOMER. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* PROJECT CODE 체크									*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid PROJECT CODE.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_PROJECT MP
                 WHERE MP.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND MP.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid PROJECT CODE. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* CURRENCY 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid CURRENCY.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (
                SELECT 1
                  FROM DM_MST_EXCHANGE_RATE ER
                 WHERE ER.DIVISION_ID   = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND ER.UNIT_CURRENCY = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid CURRENCY. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* MODEL 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid MODEL.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(ATTRIBUTE6, '') <> ''
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SITE MS
                 INNER JOIN SCM_MST_SITE_ITEM ITM
                    ON ITM.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                   AND ITM.ITEM_ID      = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
                   AND ITM.VALID_YN     = 'Y'
                 INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                    ON ITM.DEPT_ID      = DI.DEPT_ID
                   AND DI.DEPT_NAME_KO = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                   AND DI.VALID_YN     = 'Y'
                 WHERE MS.DIVISION_ID  = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                   AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                   AND MS.VALID_YN     = 'Y'
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid MODEL. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 숫자여부 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid NUMERIC.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                (NVL(ATTRIBUTE7,  '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE7, '^[+-]?\d+\.?\d*$')) OR--M0
                (NVL(ATTRIBUTE8,  '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE8, '^[+-]?\d+\.?\d*$')) OR--M1
                (NVL(ATTRIBUTE9,  '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE9, '^[+-]?\d+\.?\d*$')) OR--M2
                (NVL(ATTRIBUTE10, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE10, '^[+-]?\d+\.?\d*$')) OR--M3
                (NVL(ATTRIBUTE11, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE11, '^[+-]?\d+\.?\d*$')) OR--M4
                (NVL(ATTRIBUTE12, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE12, '^[+-]?\d+\.?\d*$')) OR--M5
                (NVL(ATTRIBUTE13, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE13, '^[+-]?\d+\.?\d*$')) OR--M6
                (NVL(ATTRIBUTE14, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE14, '^[+-]?\d+\.?\d*$')) OR--M7
                (NVL(ATTRIBUTE15, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE15, '^[+-]?\d+\.?\d*$')) OR--M8
                (NVL(ATTRIBUTE16, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE16, '^[+-]?\d+\.?\d*$')) OR--M9
                (NVL(ATTRIBUTE17, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE17, '^[+-]?\d+\.?\d*$')) OR--M10
                (NVL(ATTRIBUTE18, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE18, '^[+-]?\d+\.?\d*$')) OR--M11
                (NVL(ATTRIBUTE19, '') <> '' AND NOT REGEXP_LIKE(ATTRIBUTE19, '^[+-]?\d+\.?\d*$'))   --M12
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Invalid NUMERIC. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 마이너스 여부 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Negative Number.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                (NVL(ATTRIBUTE7,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE7, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE7)  < 0) OR--M0
                (NVL(ATTRIBUTE8,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE8, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE8)  < 0) OR--M1
                (NVL(ATTRIBUTE9,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE9, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE9)  < 0) OR--M2
                (NVL(ATTRIBUTE10, '') <> '' AND REGEXP_LIKE(ATTRIBUTE10, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE10) < 0) OR--M3
                (NVL(ATTRIBUTE11, '') <> '' AND REGEXP_LIKE(ATTRIBUTE11, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE11) < 0) OR--M4
                (NVL(ATTRIBUTE12, '') <> '' AND REGEXP_LIKE(ATTRIBUTE12, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE12) < 0) OR--M5
                (NVL(ATTRIBUTE13, '') <> '' AND REGEXP_LIKE(ATTRIBUTE13, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE13) < 0) OR--M6
                (NVL(ATTRIBUTE14, '') <> '' AND REGEXP_LIKE(ATTRIBUTE14, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE14) < 0) OR--M7
                (NVL(ATTRIBUTE15, '') <> '' AND REGEXP_LIKE(ATTRIBUTE15, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE15) < 0) OR--M8
                (NVL(ATTRIBUTE16, '') <> '' AND REGEXP_LIKE(ATTRIBUTE16, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE16) < 0) OR--M9
                (NVL(ATTRIBUTE17, '') <> '' AND REGEXP_LIKE(ATTRIBUTE17, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE17) < 0) OR--M10
                (NVL(ATTRIBUTE18, '') <> '' AND REGEXP_LIKE(ATTRIBUTE18, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE18) < 0) OR--M11
                (NVL(ATTRIBUTE19, '') <> '' AND REGEXP_LIKE(ATTRIBUTE19, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE19) < 0)   --M12
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Negative Number. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        /* #################################################### */
        /* 0 여부 체크										*/
        /* #################################################### */
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Zero Number.'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (
                (NVL(ATTRIBUTE7,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE7, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE7)  = 0) OR--M0
                (NVL(ATTRIBUTE8,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE8, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE8)  = 0) OR--M1
                (NVL(ATTRIBUTE9,  '') <> '' AND REGEXP_LIKE(ATTRIBUTE9, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE9)  = 0) OR--M2
                (NVL(ATTRIBUTE10, '') <> '' AND REGEXP_LIKE(ATTRIBUTE10, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE10) = 0) OR--M3
                (NVL(ATTRIBUTE11, '') <> '' AND REGEXP_LIKE(ATTRIBUTE11, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE11) = 0) OR--M4
                (NVL(ATTRIBUTE12, '') <> '' AND REGEXP_LIKE(ATTRIBUTE12, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE12) = 0) OR--M5
                (NVL(ATTRIBUTE13, '') <> '' AND REGEXP_LIKE(ATTRIBUTE13, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE13) = 0) OR--M6
                (NVL(ATTRIBUTE14, '') <> '' AND REGEXP_LIKE(ATTRIBUTE14, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE14) = 0) OR--M7
                (NVL(ATTRIBUTE15, '') <> '' AND REGEXP_LIKE(ATTRIBUTE15, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE15) = 0) OR--M8
                (NVL(ATTRIBUTE16, '') <> '' AND REGEXP_LIKE(ATTRIBUTE16, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE16) = 0) OR--M9
                (NVL(ATTRIBUTE17, '') <> '' AND REGEXP_LIKE(ATTRIBUTE17, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE17) = 0) OR--M10
                (NVL(ATTRIBUTE18, '') <> '' AND REGEXP_LIKE(ATTRIBUTE18, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE18) = 0) OR--M11
                (NVL(ATTRIBUTE19, '') <> '' AND REGEXP_LIKE(ATTRIBUTE19, '^[+-]?\d+\.?\d*$') AND TO_NUMBER(ATTRIBUTE19) = 0)   --M12
               );

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## Zero Number. ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241217-000632]_Sales Price 화면 엑셀 업로드 시 중복데이터 입력 제한 START
        /* #################################################### */
        /*  item별로 1개의 currency만 등록되게 기존 데이터 체크하여 튕겨냄					*/
        /* ATTRIBUTE1  : Div									*/
        /* ATTRIBUTE2  : Team									*/
        /* ATTRIBUTE3  : End Customer							*/
        /* ATTRIBUTE4 : Project Code							*/
        /* ATTRIBUTE5 : Currency								*/
        /* ATTRIBUTE6 : Model									*/
        /* #################################################### */

        --ITEM 입력 안된 경우는 프로젝트 하위의 전체 ITEM을 체크
        -- M0~M12 각 월별 기존 FP 데이터와 Currency 불일치 여부를 UNION ALL 기반으로 체크
        UPDATE SCM_ADM_EXCEL_UPLOAD EU
           SET EU.UPLOAD_STATUS_CODE = 'ERROR'
             , EU.MESSAGE_TEXT       = '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
         WHERE EU.PROGRAM_ID         = V_PROGRAM_ID
           AND EU.SHEET_NAME         = V_SHEET_NAME
           AND EU.CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(EU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND EU.UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(EU.ATTRIBUTE6, '') = '' --item_id 입력 안된건
           AND EXISTS (
                SELECT 1
                FROM SCM_MST_SITE MS
                INNER JOIN SCM_MST_SITE_ITEM ITM
                    ON ITM.DIVISION_ID  = MS.DIVISION_ID
                   AND ITM.PROJECT_CODE = EU.ATTRIBUTE4
                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                   AND ITM.VALID_YN     = 'Y'
                INNER JOIN SCM_MST_FUTURE_PRICE FP
                    ON FP.DIVISION_ID   = ITM.DIVISION_ID
                   AND FP.PROJECT_CODE  = ITM.PROJECT_CODE
                   AND FP.SCM_SITE_ID   = ITM.SCM_SITE_ID
                   AND FP.MEASURE       = 'LOC'
                   AND FP.ITEM_ID       = ITM.ITEM_ID
                   AND FP.CURRENCY     <> EU.ATTRIBUTE5
                WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1
                  AND MS.END_CUSTOMER = EU.ATTRIBUTE3
                  AND MS.VALID_YN     = 'Y'
                  AND (
                       (NVL(EU.ATTRIBUTE7,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(SYSDATE, 'YYYYMM'))                      --M0
                    OR (NVL(EU.ATTRIBUTE8,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  1), 'YYYYMM'))  --M1
                    OR (NVL(EU.ATTRIBUTE9,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  2), 'YYYYMM'))  --M2
                    OR (NVL(EU.ATTRIBUTE10, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  3), 'YYYYMM'))  --M3
                    OR (NVL(EU.ATTRIBUTE11, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  4), 'YYYYMM'))  --M4
                    OR (NVL(EU.ATTRIBUTE12, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  5), 'YYYYMM'))  --M5
                    OR (NVL(EU.ATTRIBUTE13, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  6), 'YYYYMM'))  --M6
                    OR (NVL(EU.ATTRIBUTE14, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  7), 'YYYYMM'))  --M7
                    OR (NVL(EU.ATTRIBUTE15, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  8), 'YYYYMM'))  --M8
                    OR (NVL(EU.ATTRIBUTE16, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  9), 'YYYYMM'))  --M9
                    OR (NVL(EU.ATTRIBUTE17, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 10), 'YYYYMM'))  --M10
                    OR (NVL(EU.ATTRIBUTE18, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 11), 'YYYYMM'))  --M11
                    OR (NVL(EU.ATTRIBUTE19, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM'))  --M12
                  )
           );

        --ITEM 입력된 경우
        UPDATE SCM_ADM_EXCEL_UPLOAD EU
           SET EU.UPLOAD_STATUS_CODE = 'ERROR'
             , EU.MESSAGE_TEXT       = '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
         WHERE EU.PROGRAM_ID         = V_PROGRAM_ID
           AND EU.SHEET_NAME         = V_SHEET_NAME
           AND EU.CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(EU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND EU.UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(EU.ATTRIBUTE6, '') <> '' --item_id 입력 된건
           AND EXISTS (
                SELECT 1
                FROM SCM_MST_SITE MS
                INNER JOIN SCM_MST_SITE_ITEM ITM
                    ON ITM.DIVISION_ID  = MS.DIVISION_ID
                   AND ITM.PROJECT_CODE = EU.ATTRIBUTE4
                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                   AND ITM.VALID_YN     = 'Y'
                INNER JOIN SCM_MST_FUTURE_PRICE FP
                    ON FP.DIVISION_ID   = ITM.DIVISION_ID
                   AND FP.PROJECT_CODE  = ITM.PROJECT_CODE
                   AND FP.SCM_SITE_ID   = ITM.SCM_SITE_ID
                   AND FP.MEASURE       = 'LOC'
                   AND FP.ITEM_ID       = ITM.ITEM_ID
                   AND FP.ITEM_ID       = EU.ATTRIBUTE6
                   AND FP.CURRENCY     <> EU.ATTRIBUTE5
                WHERE MS.DIVISION_ID  = EU.ATTRIBUTE1
                  AND MS.END_CUSTOMER = EU.ATTRIBUTE3
                  AND MS.VALID_YN     = 'Y'
                  AND (
                       (NVL(EU.ATTRIBUTE7,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(SYSDATE, 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE8,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  1), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE9,  '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  2), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE10, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  3), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE11, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  4), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE12, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  5), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE13, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  6), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE14, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  7), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE15, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  8), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE16, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE,  9), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE17, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 10), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE18, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 11), 'YYYYMM'))
                    OR (NVL(EU.ATTRIBUTE19, '') <> '' AND SUBSTR(FP.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM'))
                  )
           );

        --[E20241217-000632]_Sales Price 화면 엑셀 업로드 시 중복데이터 입력 제한 END

        N_LOG_COUNT   := N_LOG_COUNT + 1;
        V_LOG_TYPE    := 'UPDATE';
        V_LOG_MESSAGE := '########## ERROR Multiple Currency ##########';
        V_DESCRIPTION := TO_CHAR(SQL%ROWCOUNT);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        -- 정상(SUCCESS) 처리
        UPDATE SCM_ADM_EXCEL_UPLOAD
           SET UPLOAD_STATUS_CODE = 'SUCCESS'
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND SHEET_NAME         = V_SHEET_NAME
           AND CREATED_BY         = P_CREATED_BY
           AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
           AND UPLOAD_STATUS_CODE = 'UPLOAD';

        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := '16';
        V_LOG_MESSAGE := '########## SUCCESS ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ----------------------------------------------------------------------------

    END IF; -- END OF p_mode = 0

------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------
------------------------------------- validation 로직 종료 ----------------------------------------------

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    V_LOG_TYPE    := '17';
    V_LOG_MESSAGE := '########## INSERT DATA START ##########';
    V_DESCRIPTION := TO_CHAR(P_MODE);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ----------------------------------------------------------------------------

    --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
    --//======================================================================================
    SELECT COUNT(1)
      INTO V_COUNT
      FROM SCM_ADM_EXCEL_UPLOAD T
     WHERE T.PROGRAM_ID         = V_PROGRAM_ID
       AND T.SHEET_NAME         = V_SHEET_NAME
       AND T.CREATED_BY         = P_CREATED_BY
       AND TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
       AND T.UPLOAD_STATUS_CODE = 'ERROR';

    --실제 업무처리
    IF P_MODE > 0 AND V_COUNT > 0 THEN
        -- Validation 실패 상태에서 저장 시도 → 조기 리턴
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        -- V_DESCRIPTION := 'Validation ERROR exists: ' || TO_CHAR(V_COUNT) || ' rows';
        V_DESCRIPTION := TO_CHAR(V_COUNT);  -- 3/26 실패 시, to_char(0) 리턴
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;

    IF P_MODE > 0 AND V_COUNT = 0 THEN

        --------------------------------------------------
        -- 엑셀 업로드용 TMP 테이블 생성 및 데이터 저장
        --------------------------------------------------
        -- EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

        -- GTT TRUNCATE
        DELETE FROM SCM_MGR.GT_F020_EXCEL_UPLOAD;
        DELETE FROM SCM_MGR.GT_F020_UPLOAD_MASTER_STEP1;
        DELETE FROM SCM_MGR.GT_F020_UPLOAD_MASTER_WITH_ITEM;
        DELETE FROM SCM_MGR.GT_F020_UPLOAD_MASTER_STEP2;
        DELETE FROM SCM_MGR.GT_F020_UPLOAD_MASTER_FINAL;
        DELETE FROM SCM_MGR.GT_F020_EXCH;

        BEGIN
            --그냥 빈값을 넣어도 되나 추후 UNPIVOT시 제대로 되지 않을까 우려하여 0으로 놓고 나중에 걸러내기로 함
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_EXCEL_UPLOAD
            (DIVISION_ID, TEAM_NAME, END_CUST, PROJECT_CODE, CURRENCY, MODEL,
             M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
            SELECT
                ATTRIBUTE1   --DIVISION_ID
              , ATTRIBUTE2   --TEAM_NAME
              , ATTRIBUTE3   --END_CUST
              , ATTRIBUTE4   --PROJECT_CODE
              , ATTRIBUTE5   --CURRENCY
              , ATTRIBUTE6   --MODEL
              , CASE WHEN ATTRIBUTE7  = '' THEN '0' ELSE ATTRIBUTE7  END  --M0 빈값이면 0 처리
              , CASE WHEN ATTRIBUTE8  = '' THEN '0' ELSE ATTRIBUTE8  END  --M1
              , CASE WHEN ATTRIBUTE9  = '' THEN '0' ELSE ATTRIBUTE9  END  --M2
              , CASE WHEN ATTRIBUTE10 = '' THEN '0' ELSE ATTRIBUTE10 END  --M3
              , CASE WHEN ATTRIBUTE11 = '' THEN '0' ELSE ATTRIBUTE11 END  --M4
              , CASE WHEN ATTRIBUTE12 = '' THEN '0' ELSE ATTRIBUTE12 END  --M5
              , CASE WHEN ATTRIBUTE13 = '' THEN '0' ELSE ATTRIBUTE13 END  --M6
              , CASE WHEN ATTRIBUTE14 = '' THEN '0' ELSE ATTRIBUTE14 END  --M7
              , CASE WHEN ATTRIBUTE15 = '' THEN '0' ELSE ATTRIBUTE15 END  --M8
              , CASE WHEN ATTRIBUTE16 = '' THEN '0' ELSE ATTRIBUTE16 END  --M9
              , CASE WHEN ATTRIBUTE17 = '' THEN '0' ELSE ATTRIBUTE17 END  --M10
              , CASE WHEN ATTRIBUTE18 = '' THEN '0' ELSE ATTRIBUTE18 END  --M11
              , CASE WHEN ATTRIBUTE19 = '' THEN '0' ELSE ATTRIBUTE19 END  --M12
              FROM SCM_ADM_EXCEL_UPLOAD
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND UPLOAD_STATUS_CODE = 'SUCCESS'
               AND TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE;

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname          => 'SCM_MGR',
                tabname          => 'GT_F020_EXCEL_UPLOAD',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
                method_opt       => 'FOR ALL COLUMNS SIZE 1'
            );

            --------------------------------------------------
            --item_id 없는 데이터셋 추출
            --------------------------------------------------
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_STEP1
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE,
             M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                FP.INCOTERMS, FP.DOM_EXP, FP.PLANT_SITE_ID, FP.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_FUTURE_PRICE FP
                ON FP.DIVISION_ID   = TMP.DIVISION_ID
               AND FP.PROJECT_CODE  = TMP.PROJECT_CODE
               AND FP.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND FP.ITEM_ID       = ITM.ITEM_ID
               AND FP.MEASURE       = 'LOC'
             WHERE NVL(TMP.MODEL, '') = '' --item_id 입력 안된건(전체데이터셋)
            UNION
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                PN.INCOTERMS, PN.DOM_EXP, PN.PLANT_SITE_ID, PN.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN DM_PLN_SALES_PLAN PN
                ON PN.DIVISION_ID   = TMP.DIVISION_ID
               AND PN.PROJECT_CODE  = TMP.PROJECT_CODE
               AND PN.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND PN.ITEM_ID       = ITM.ITEM_ID
               AND PN.MEASURE       = 'RTF_SYS_RP'
             WHERE NVL(TMP.MODEL, '') = ''; --item_id 입력 안된건(전체데이터셋)

            COMMIT;

            --------------------------------------------------
            --item_id 있는 데이터셋 추출
            --------------------------------------------------
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_WITH_ITEM
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE,
             M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                FP.INCOTERMS, FP.DOM_EXP, FP.PLANT_SITE_ID, FP.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.ITEM_ID      = TMP.MODEL
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_FUTURE_PRICE FP
                ON FP.DIVISION_ID   = TMP.DIVISION_ID
               AND FP.PROJECT_CODE  = TMP.PROJECT_CODE
               AND FP.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND FP.ITEM_ID       = ITM.ITEM_ID
               AND FP.MEASURE       = 'LOC'
            UNION
            SELECT
                TMP.DIVISION_ID, MS.SCM_SITE_ID, TMP.PROJECT_CODE, ITM.ITEM_ID, TMP.CURRENCY,
                PN.INCOTERMS, PN.DOM_EXP, PN.PLANT_SITE_ID, PN.FCST_TYPE,
                TMP.M0, TMP.M1, TMP.M2, TMP.M3, TMP.M4, TMP.M5,
                TMP.M6, TMP.M7, TMP.M8, TMP.M9, TMP.M10, TMP.M11, TMP.M12
              FROM GT_F020_EXCEL_UPLOAD TMP
             INNER JOIN SCM_MST_SITE MS
                ON MS.DIVISION_ID  = TMP.DIVISION_ID
               AND MS.END_CUSTOMER = TMP.END_CUST
               AND MS.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SITE_ITEM ITM
                ON ITM.DIVISION_ID  = TMP.DIVISION_ID
               AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
               AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
               AND ITM.ITEM_ID      = TMP.MODEL
               AND ITM.VALID_YN     = 'Y'
             INNER JOIN SCM_MST_SSO_DEPT_INFO DI
                ON ITM.DEPT_ID      = DI.DEPT_ID
               AND DI.DEPT_NAME_KO = TMP.TEAM_NAME
               AND DI.VALID_YN     = 'Y'
             INNER JOIN DM_PLN_SALES_PLAN PN
                ON PN.DIVISION_ID   = TMP.DIVISION_ID
               AND PN.PROJECT_CODE  = TMP.PROJECT_CODE
               AND PN.SCM_SITE_ID   = MS.SCM_SITE_ID
               AND PN.ITEM_ID       = ITM.ITEM_ID
               AND PN.MEASURE       = 'RTF_SYS_RP';

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_STEP1',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );
            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_WITH_ITEM',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            ----===============================================================================
            --두 데이터셋 합치기
            /* ITEM있는 항목(GT_F020_UPLOAD_MASTER_WITH_ITEM)의 값이 '0'이면 원래값 유지*/
            MERGE INTO GT_F020_UPLOAD_MASTER_STEP1 A
            USING GT_F020_UPLOAD_MASTER_WITH_ITEM B
               ON (
                    A.DIVISION_ID  = B.DIVISION_ID
                AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.ITEM_ID      = B.ITEM_ID
                AND A.CURRENCY     = B.CURRENCY
                AND A.INCOTERMS    = B.INCOTERMS
                AND A.DOM_EXP      = B.DOM_EXP
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                AND A.FCST_TYPE    = B.FCST_TYPE
                  )
            WHEN MATCHED THEN
                UPDATE SET
                    A.M0  = CASE WHEN B.M0  = '0' THEN A.M0  ELSE B.M0  END
                  , A.M1  = CASE WHEN B.M1  = '0' THEN A.M1  ELSE B.M1  END
                  , A.M2  = CASE WHEN B.M2  = '0' THEN A.M2  ELSE B.M2  END
                  , A.M3  = CASE WHEN B.M3  = '0' THEN A.M3  ELSE B.M3  END
                  , A.M4  = CASE WHEN B.M4  = '0' THEN A.M4  ELSE B.M4  END
                  , A.M5  = CASE WHEN B.M5  = '0' THEN A.M5  ELSE B.M5  END
                  , A.M6  = CASE WHEN B.M6  = '0' THEN A.M6  ELSE B.M6  END
                  , A.M7  = CASE WHEN B.M7  = '0' THEN A.M7  ELSE B.M7  END
                  , A.M8  = CASE WHEN B.M8  = '0' THEN A.M8  ELSE B.M8  END
                  , A.M9  = CASE WHEN B.M9  = '0' THEN A.M9  ELSE B.M9  END
                  , A.M10 = CASE WHEN B.M10 = '0' THEN A.M10 ELSE B.M10 END
                  , A.M11 = CASE WHEN B.M11 = '0' THEN A.M11 ELSE B.M11 END
                  , A.M12 = CASE WHEN B.M12 = '0' THEN A.M12 ELSE B.M12 END
            WHEN NOT MATCHED THEN
                INSERT (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
                        INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE,
                        M0, M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12)
                VALUES (B.DIVISION_ID, B.SCM_SITE_ID, B.PROJECT_CODE, B.ITEM_ID, B.CURRENCY,
                        B.INCOTERMS, B.DOM_EXP, B.PLANT_SITE_ID, B.FCST_TYPE,
                        B.M0, B.M1, B.M2, B.M3, B.M4, B.M5, B.M6, B.M7, B.M8, B.M9, B.M10, B.M11, B.M12);

            COMMIT;

            --------------------------------------------------
            -- 5. 추출된 PK 기준으로 LOC Measure의 가격을 Upload Master 기준 가격으로 Calendar Join해서 주차별 반영(Insert / Update, 52주 구간)
            --------------------------------------------------
            --월별로 UNPIVOT하여 실제 월 구하기(GT_F020_UPLOAD_MASTER_STEP2)
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_STEP2
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2)
            SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
                   INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM,
                   CASE MM
                       WHEN 'M0'  THEN TO_CHAR(SYSDATE, 'YYYYMM')
                       WHEN 'M1'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  1), 'YYYYMM')
                       WHEN 'M2'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  2), 'YYYYMM')
                       WHEN 'M3'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  3), 'YYYYMM')
                       WHEN 'M4'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  4), 'YYYYMM')
                       WHEN 'M5'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  5), 'YYYYMM')
                       WHEN 'M6'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  6), 'YYYYMM')
                       WHEN 'M7'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  7), 'YYYYMM')
                       WHEN 'M8'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  8), 'YYYYMM')
                       WHEN 'M9'  THEN TO_CHAR(ADD_MONTHS(SYSDATE,  9), 'YYYYMM')
                       WHEN 'M10' THEN TO_CHAR(ADD_MONTHS(SYSDATE, 10), 'YYYYMM')
                       WHEN 'M11' THEN TO_CHAR(ADD_MONTHS(SYSDATE, 11), 'YYYYMM')
                       WHEN 'M12' THEN TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM')
                   END AS MM2
              FROM GT_F020_UPLOAD_MASTER_STEP1
            UNPIVOT (
                LOC FOR MM IN (
                    M0  AS 'M0',  M1  AS 'M1',  M2  AS 'M2',  M3  AS 'M3',
                    M4  AS 'M4',  M5  AS 'M5',  M6  AS 'M6',  M7  AS 'M7',
                    M8  AS 'M8',  M9  AS 'M9',  M10 AS 'M10', M11 AS 'M11',
                    M12 AS 'M12'
                )
            );

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_STEP2',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            --5-1)Upload Master와 CALENDAR 테이블 조인하여 주차별로 ROW 생성
            --52주차
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT DISTINCT
                TMP.DIVISION_ID, TMP.SCM_SITE_ID, TMP.PROJECT_CODE, TMP.ITEM_ID, TMP.CURRENCY,
                TMP.INCOTERMS, TMP.DOM_EXP, TMP.PLANT_SITE_ID, TMP.FCST_TYPE,
                TMP.LOC, TMP.MM, TMP.MM2, CAL.BASIS_START_DATE,
                'LOC' --엑셀 입력값은 LOC 메저로 간주
              FROM GT_F020_UPLOAD_MASTER_STEP2 TMP
             INNER JOIN (
                SELECT DISTINCT
                    SUBSTR(BASIS_START_DATE, 1, 6) AS YYYYMM,
                    BASIS_START_DATE
                  FROM SCM_SYS_CALENDAR_M CAL
                 WHERE CAL.BASIS_YYYYMMDD >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                   AND CAL.BASIS_YYYYMMDD <  TO_CHAR(SYSDATE + 52 * 7, 'YYYYMMDD')
             ) CAL
                ON TMP.MM2 = CAL.YYYYMM
             WHERE TO_NUMBER(TMP.LOC) > 0; -- 0 이상만 처리 (빈값 제외)

            COMMIT;

            --5-2)환율데이터 생성
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_EXCH
            (DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE)
            SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
              FROM DM_MST_EXCHANGE_RATE A
              JOIN GT_F020_UPLOAD_MASTER_STEP2 B
                ON A.DIVISION_ID = B.DIVISION_ID
               AND A.YYYYMMDD    = B.MM2 || '01'
               AND A.CURRENCY    = 'KRW';

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_FINAL',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );
            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_EXCH',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            --5-3) CURRENCY가 'KRW', 'USD'일 경우 해당 CURRENCY로 메저생성
            --환율 계산할 필요 없으므로 LOC값 그대로 저장
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT
                A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.CURRENCY,
                A.INCOTERMS, A.DOM_EXP, A.PLANT_SITE_ID, A.FCST_TYPE,
                A.LOC, A.MM, A.MM2, A.BASIS_START_DATE,
                A.CURRENCY AS MEASURE
              FROM GT_F020_UPLOAD_MASTER_FINAL A
             WHERE A.MEASURE  = 'LOC'
               AND A.CURRENCY IN ('KRW', 'USD');

            COMMIT;

            --5-4) KRW 메저 생성(기준값)  : 환율금액을 곱하여 KRW 생성
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT
                A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.CURRENCY,
                A.INCOTERMS, A.DOM_EXP, A.PLANT_SITE_ID, A.FCST_TYPE,
                TO_CHAR(ROUND(TO_NUMBER(A.LOC) * B.EXCHANGE_PRICE, 3)),
                A.MM, A.MM2, A.BASIS_START_DATE,
                'KRW'
              FROM GT_F020_UPLOAD_MASTER_FINAL A
              JOIN GT_F020_EXCH B
                ON B.UNIT_CURRENCY = A.CURRENCY
               AND B.YYYYMMDD      = A.MM2 || '01'
             WHERE A.MEASURE   = 'LOC'
               AND A.CURRENCY <> 'KRW';

            COMMIT;

            --5-5) USD 메저 생성 : KRW 기준으로 계산
            INSERT /*+ APPEND PARALLEL(4) */ INTO GT_F020_UPLOAD_MASTER_FINAL
            (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, CURRENCY,
             INCOTERMS, DOM_EXP, PLANT_SITE_ID, FCST_TYPE, LOC, MM, MM2, BASIS_START_DATE, MEASURE)
            SELECT
                A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.CURRENCY,
                A.INCOTERMS, A.DOM_EXP, A.PLANT_SITE_ID, A.FCST_TYPE,
                TO_CHAR(ROUND(TO_NUMBER(A.LOC) / B.EXCHANGE_PRICE, 3)),
                A.MM, A.MM2, A.BASIS_START_DATE,
                'USD'
              FROM GT_F020_UPLOAD_MASTER_FINAL A
              JOIN GT_F020_EXCH B
                ON B.UNIT_CURRENCY = 'USD'
               AND B.YYYYMMDD      = A.MM2 || '01'
             WHERE A.MEASURE   = 'KRW'
               AND A.CURRENCY <> 'USD';

            COMMIT;

            DBMS_STATS.GATHER_TABLE_STATS(
                ownname => 'SCM_MGR', tabname => 'GT_F020_UPLOAD_MASTER_FINAL',
                estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1'
            );

            ----------------------------------------------------
            --6) SCM_MST_FUTURE_PRICE 저장
            ----------------------------------------------------
            MERGE INTO SCM_MST_FUTURE_PRICE A
            USING GT_F020_UPLOAD_MASTER_FINAL B
               ON (
                    A.DIVISION_ID   = B.DIVISION_ID
                AND A.PROJECT_CODE  = B.PROJECT_CODE
                AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                AND A.ITEM_ID       = B.ITEM_ID
                AND A.YYYYMMDD      = B.BASIS_START_DATE
                AND A.CURRENCY      = B.CURRENCY
                AND A.MEASURE       = B.MEASURE
                AND A.DOM_EXP       = B.DOM_EXP
                AND A.FCST_TYPE     = B.FCST_TYPE
                AND A.INCOTERMS     = B.INCOTERMS
                  )
            WHEN MATCHED THEN
                UPDATE SET
                    A.PRICE            = TO_NUMBER(B.LOC)
                  , A.LAST_UPDATED_BY  = P_CREATED_BY
                  , A.LAST_UPDATE_DATE = SYSDATE
                  , A.ATTRIBUTE8       = 'EXCEL UPLOAD' --엑셀업로드 여부 표시
            WHEN NOT MATCHED THEN
                INSERT (
                    DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,
                    ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE,
                    INCOTERMS, PRICE, CREATED_BY, CREATION_DATE,
                    LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE8
                )
                VALUES (
                    NVL(B.DIVISION_ID, '-'), NVL(B.PROJECT_CODE, '-'), NVL(B.SCM_SITE_ID, '-'), NVL(B.PLANT_SITE_ID, '-'),
                    NVL(B.ITEM_ID, '-'), NVL(B.BASIS_START_DATE, '-'), NVL(B.CURRENCY, '-'), NVL(B.MEASURE, '-'), NVL(B.DOM_EXP, '-'), NVL(B.FCST_TYPE, '-'),
                    NVL(B.INCOTERMS, '-'), TO_NUMBER(B.LOC), P_CREATED_BY, SYSDATE,
                    P_CREATED_BY, SYSDATE, 'EXCEL UPLOAD' --엑셀업로드 여부 표시
                );

            N_LOG_COUNT := SQL%ROWCOUNT;

            ----------------------------------------------------
            --7) SCM_MST_FUTURE_PRICE_H 저장
            ----------------------------------------------------
            INSERT INTO SCM_MST_FUTURE_PRICE_H
            (
                DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,
                ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE,
                INCOTERMS, PRICE, CREATED_BY, CREATION_DATE,
                LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE8
            )
            SELECT
                DIVISION_ID,
                SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL,
                PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID,
                ITEM_ID, BASIS_START_DATE, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE,
                INCOTERMS, TO_NUMBER(LOC), P_CREATED_BY, SYSDATE,
                P_CREATED_BY, SYSDATE,
                'EXCEL UPLOAD' --엑셀업로드 여부 표시
              FROM GT_F020_UPLOAD_MASTER_FINAL;

            COMMIT;

            EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

            ----------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '21';
            V_LOG_MESSAGE := '########## INSERT DMF0020_EXCEL_UPLOAD END ##########';
            V_DESCRIPTION := TO_CHAR(P_MODE);
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
            ----------------------------------------------------------------------------

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

                V_SQL_CODE   := TO_CHAR(SQLCODE);
                V_SQL_ERRMSG := SQLERRM;
                V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                V_PROC_INPUT := JSON_OBJECT(
                    'P_MODE'       VALUE P_MODE,
                    'P_CREATED_BY' VALUE P_CREATED_BY
                );

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
                    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                    ' / PARAMS=' || V_PROC_INPUT
                );
                RAISE;
        END;

    END IF; -- END OF p_mode > 0

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## INSERT DATA END ##########';
    V_DESCRIPTION := TO_CHAR(P_MODE);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ----------------------------------------------------------------------------

    -- 결과 반환 분기
    IF NVL(P_MODE, 0) = 0 THEN
        -- 조회(Validation) 성공: EVENT는 NULL (Case 3 조회 성공 패턴)
        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;
    ELSE
        -- DML 성공: EVENT에 처리 건수 반환
        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_MODE'       VALUE P_MODE,
            'P_CREATED_BY' VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0020_EXCEL_UPLOAD;


PROCEDURE        P_DMF0020_GET_SPREAD_TITLE
(
    P_START_DT     IN VARCHAR2,
    P_END_DT       IN VARCHAR2,
    P_CREATED_BY   IN VARCHAR2,
    P_DIVISION_ID  IN VARCHAR2,
    O_RC1          OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DMF0020_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/08/10     JYE				Div별로 연동                    */
/* 2024/05/14   kcw3408		       이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가,GROUP_ID( Item은 Group 기준으로 정렬) 추가)           */
/* 2026.03.13   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
/****************************************************************************************************/
/*
VAR RC1 REFCURSOR
VAR RC2 REFCURSOR
EXEC DMF0020_GET_SPREAD_TITLE('20260101', '20260330', 'bindy122678', '40',  :rc1, :rc2);
PRINT RC1
PRINT RC2
*/

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

    -- 로컬 변수
    p_program_id    VARCHAR2(50 CHAR) := 'DMF0020';
    p_sheet_name    VARCHAR2(50 CHAR) := 'Sales Price';
    V_EXISTS        PLS_INTEGER := 0;

BEGIN

    -- ================================================================
    -- START 로그
    -- ================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- ================================================================
    -- 1. 등록여부 (Case 28: 전건 COUNT 회피)
    -- ================================================================
    BEGIN
        SELECT 1
        INTO   V_EXISTS
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  1 = 1
            --AND    U.PROGRAM_ID  = C.PROGRAM_ID
            --AND    U.SHEET_NAME  = C.SHEET_NAME
            --AND    U.COLUMN_NAME = C.COLUMN_NAME
            AND    U.PROGRAM_ID  = p_program_id
            AND    U.SHEET_NAME  = p_sheet_name
            AND    U.USER_ID     = P_CREATED_BY
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_EXISTS := 0;
    END;

    -- ================================================================
    -- 2. 분기 처리
    -- ================================================================
    IF V_EXISTS = 0 THEN

        -- 일반 데이터 칼럼 + 날짜 데이터 칼럼
        OPEN O_RC1 FOR
        SELECT
             C.PROGRAM_ID
           , C.SHEET_NAME
           , C.COLUMN_NAME
           , C.COLUMN_LABEL_NAME
           , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO  --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
           , C.DATA_SORT_METHOD_CODE
           , C.SMALL_CLASS_LABEL_NAME
           , C.LARGE_CLASS_LABEL_NAME
           , '' AS DAY_CODE
           , C.FIXED_FLAG
           , TO_CHAR(C.COLUMN_WIDTH) AS COLUMN_WIDTH
           , C.CELL_CONTROL_OBJECT_TYPE_CODE
           , C.CELL_COMBO_DATA_TYPE
           , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
           , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
           , C.HORIZONTAL_ALIGN_CODE
           , C.UPPERCASE_APPLY_FLAG
           , C.VISIBLE_FLAG
           , C.DEFAULT_FLAG
           , C.USER_SELECTABLE_FLAG
           , C.VALID_YN
           --, CASE C.VALID_YN	 WHEN 'Y' THEN -- 20180607 추가
           --		CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
           --	ELSE C.VALID_YN END VALID_YN
           , '0' AS SEQ
           --INTO #tmpTitleO
        FROM SCM_MST_SHEET_COLUMNS C
        WHERE 1 = 1
            AND    C.PROGRAM_ID  = p_program_id
            AND    C.SHEET_NAME  = p_sheet_name
            AND    ( C.DEFAULT_FLAG = 'Y' OR
                (    C.VISIBLE_FLAG = 'N'
                AND    C.DEFAULT_FLAG = ''
                AND    C.VALID_YN     = 'Y'
                )
                )
            AND P_DIVISION_ID IN (                                                  -- 20180604 division 추가
                SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                FROM DUAL
                CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
            )
        -- 날짜 데이터 칼럼
        UNION ALL
        SELECT
            p_program_id   AS PROGRAM_ID
            , p_sheet_name AS SHEET_NAME
            , MA.COLUMN_NAME
            , MA.COLUMN_LABEL_NAME
            , MA.SORT_ORDER_NO
            , ''         AS DATA_SORT_METHOD_CODE
            , MA.SMALL_CLASS_LABEL_NAME
            , MA.LARGE_CLASS_LABEL_NAME
            , MA.DAY_CODE
            , ''         AS FIXED_FLAG
            , '120'      AS COLUMN_WIDTH
            , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
            , ''         AS CELL_COMBO_DATA_TYPE
            --, '2'         AS DATA_SCALE_NUMBER
            , '3'         AS DATA_SCALE_NUMBER -- 20181029
            , ''         AS DATA_MAX_LENGTH
            , 'R'        AS HORIZONTAL_ALIGN_CODE
            , 'Y'        AS UPPERCASE_APPLY_FLAG
            , 'Y'        AS VISIBLE_FLAG
            , ''         AS DEFAULT_FLAG
            , ''         AS USER_SELECTABLE_FLAG
            , ''         AS VALID_YN
            , ''         AS SEQ
        FROM  (
            SELECT
                'W_' || MIN(BASIS_START_DATE)           AS COLUMN_NAME
                , SUBSTR(BASIS_START_DATE, 5, 4)        AS COLUMN_LABEL_NAME
                , WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                , MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                , ''                                    AS DAY_CODE
                , MIN(BASIS_START_DATE)                 AS SORT_ORDER_NO
                , 'FPNumber'                            AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
                AND    BASIS_YYYYMMDD <= P_END_DT
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

            UNION ALL

            SELECT
                'M_' || MIN(BASIS_START_DATE)           AS COLUMN_NAME
                , SUBSTR(BASIS_START_DATE, 5, 4)        AS COLUMN_LABEL_NAME
                , WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                , MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                , ''                                    AS DAY_CODE
                , MIN(BASIS_START_DATE)                 AS SORT_ORDER_NO
                , 'FPNumber'                            AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
                AND BASIS_YYYYMMDD <= P_END_DT
                AND CALENDAR_DAY = '01'
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

        ) MA
        ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;

--      ORDER BY SEQ, SORT_ORDER_NO

    ELSE -- V_EXISTS <> 0

        -- 일반 데이터 칼럼 (사용자 설정 + 비노출 기본 + 날짜)
        OPEN O_RC1 FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO  --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , U.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , TO_CHAR(C.COLUMN_WIDTH) AS COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
             , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             --, C.VALID_YN
             , CASE C.VALID_YN WHEN 'Y' THEN -- 20180607 추가
                  CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
               ELSE C.VALID_YN END AS VALID_YN
             , '1' AS SEQ
        FROM   SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = p_program_id
        AND    U.SHEET_NAME  = p_sheet_name
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND P_DIVISION_ID IN (                                                      -- 20180604 division 추가
            SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        UNION ALL
        /* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN TO_CHAR(NVL(U.SORT_ORDER_NO, 85) - 0.5) ELSE TO_CHAR(C.SORT_ORDER_NO) END AS SORT_ORDER_NO  --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , TO_CHAR(C.COLUMN_WIDTH) AS COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
             , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , '2' AS SEQ
        FROM   SCM_MST_SHEET_COLUMNS C
        LEFT OUTER JOIN SCM_MST_TITLESET_USER U
        ON     U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    U.COLUMN_NAME IN ('ITEM_ID')
        AND    U.USER_ID = P_CREATED_BY
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = p_program_id
        AND    C.SHEET_NAME  = p_sheet_name
        AND    C.VISIBLE_FLAG = 'N'
        AND    C.DEFAULT_FLAG = ''
        AND    C.VALID_YN     = 'Y'
        AND P_DIVISION_ID IN (                                                      -- 20180604 division 추가
            SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        --ORDER BY SEQ, SORT_ORDER_NO
        -- 날짜 데이터 칼럼
        UNION ALL
        SELECT
            p_program_id   AS PROGRAM_ID
            , p_sheet_name AS SHEET_NAME
            , MA.COLUMN_NAME
            , MA.COLUMN_LABEL_NAME
            , MA.SORT_ORDER_NO
            , ''         AS DATA_SORT_METHOD_CODE
            , MA.SMALL_CLASS_LABEL_NAME
            , MA.LARGE_CLASS_LABEL_NAME
            , MA.DAY_CODE
            , ''         AS FIXED_FLAG
            , '120'      AS COLUMN_WIDTH
            , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
            , ''         AS CELL_COMBO_DATA_TYPE
            --, '2'         AS DATA_SCALE_NUMBER
            , '3'         AS DATA_SCALE_NUMBER -- 20181029
            , ''         AS DATA_MAX_LENGTH
            , 'R'        AS HORIZONTAL_ALIGN_CODE
            , 'Y'        AS UPPERCASE_APPLY_FLAG
            , 'Y'        AS VISIBLE_FLAG
            , ''         AS DEFAULT_FLAG
            , ''         AS USER_SELECTABLE_FLAG
            , ''         AS VALID_YN
            , ''         AS SEQ
        FROM  (
            SELECT
                'W_' || MIN(BASIS_START_DATE)           AS COLUMN_NAME
                , SUBSTR(BASIS_START_DATE, 5, 4)        AS COLUMN_LABEL_NAME
                , WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                , MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                , ''                                    AS DAY_CODE
                , MIN(BASIS_START_DATE)                 AS SORT_ORDER_NO
                , 'FPNumber'                            AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
                AND    BASIS_YYYYMMDD <= P_END_DT
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

            UNION ALL

            SELECT
                'M_' || MIN(BASIS_START_DATE)           AS COLUMN_NAME
                , SUBSTR(BASIS_START_DATE, 5, 4)        AS COLUMN_LABEL_NAME
                , WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                , MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                , ''                                    AS DAY_CODE
                , MIN(BASIS_START_DATE)                 AS SORT_ORDER_NO
                , 'FPNumber'                            AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
                AND BASIS_YYYYMMDD <= P_END_DT
                AND CALENDAR_DAY = '01'
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

        ) MA
        ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;

    END IF;

    /*-- 날짜 부분 -------------------------------
    SELECT
        'W_' || MIN(BASIS_START_DATE) AS BASIS_START_DATE2,
        MIN(BASIS_START_DATE) AS BASIS_START_DATE, BASIS_YYYYMM,
        WEEK_NAME, SUBSTR(BASIS_START_DATE,5,4) AS MMDD
        , CALENDAR_YYYY AS YER, CALENDAR_MONTH AS MON
    FROM SCM_SYS_CALENDAR_M
    WHERE
        BASIS_YYYYMMDD >= P_START_DT AND BASIS_YYYYMMDD <= P_END_DT
    GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE,5,4), CALENDAR_YYYY, CALENDAR_MONTH

    UNION ALL

    SELECT  'M_' || MIN(BASIS_START_DATE) AS BASIS_START_DATE2,
        MIN(BASIS_START_DATE) AS BASIS_START_DATE
        , BASIS_YYYYMM,
        WEEK_NAME, SUBSTR(BASIS_START_DATE,5,4) AS MMDD
        , CALENDAR_YYYY AS YER, CALENDAR_MONTH AS MON
    FROM SCM_SYS_CALENDAR_M
    WHERE
        BASIS_YYYYMMDD >= P_START_DT AND BASIS_YYYYMMDD <= P_END_DT
        AND CALENDAR_DAY = '01'
    GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE,5,4), CALENDAR_YYYY, CALENDAR_MONTH
    ORDER BY YER, MMDD, BASIS_START_DATE2 --DESC
    -- 날짜 부분 -------------------------------
    */

    -- ================================================================
    -- 조회 성공 O_RESULT_CURSOR (Case 3 표준 패턴)
    -- ================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    -- ================================================================
    -- END 로그
    -- ================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_DT'    VALUE P_START_DT,
            'P_END_DT'      VALUE P_END_DT,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_DIVISION_ID' VALUE P_DIVISION_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0020_GET_SPREAD_TITLE;



PROCEDURE P_DMF0020_GET_SALES_PRICE_TEMPLATE
(
    P_DIVISION_ID   IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/********************************************************************************************************************************************************/
/* Program ID  : [DMF0020_GET_SALES_PRICE_TEMPLATE]																										*/
/* Description : Procedure 작성 가이드																													*/
/* Usage       : Procedure 작성 시 참조하세요!																												*/
/* Parameter   :																																		*/
/*																																						*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* Date			In Charge			Description																											*/
/*------------------------------------------------------------------------------------------------------------------------------------------------------*/
/* 2024.07.17		KJJ      최초 작성- [PJ2024-50611]Sales Price 템플릿 다운 기능추가                                                                      */
/* 2026.03.16   jcnam         [PJ20264226] NextSCM Pilot 설계 및 개발                                                                                     */
/*------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*
VAR RC1 REFCURSOR
VAR RC2 REFCURSOR
EXEC DMF0020_GET_SALES_PRICE_TEMPLATE('40',   :rc1, :rc2);
PRINT RC1
PRINT RC2
*/

    -- EXCEPTION 블록 필수 변수
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

    -- ================================================================
    -- START 로그
    -- ================================================================
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- ================================================================
    -- 메인 조회
    -- ================================================================
    OPEN O_RC1 FOR
    WITH TEMP_VERSION_NO AS (
        --DIV별 최신 버전(2024.10.04)---------------------
        SELECT /*+ MATERIALIZE */
               A.DIVISION_ID, A.VERSION_NO, A.YYYYMMDD, B.BASIS_YYYYMM AS YYYYMM
        FROM
        (
            SELECT DIVISION_ID, MAX(VERSION_NO) AS VERSION_NO, MAX(YYYYMMDD) AS YYYYMMDD
            FROM DM_MST_VERSION
            WHERE DIVISION_ID = P_DIVISION_ID
            AND VERSION_TYPE = 'SP_W'
            --AND NVL(ATTRIBUTE7, 'N') = 'Y'
            GROUP BY DIVISION_ID
        ) A
        INNER JOIN SCM_SYS_CALENDAR_M B
                ON B.BASIS_YYYYMMDD = A.YYYYMMDD
    )
    SELECT DISTINCT
        A.DIVISION_ID
        , A.DEPT_NAME_KO AS DEPT_NAME
        , A.END_CUSTOMER
        , A.PROJECT_CODE
        , MAX(A.CURRENCY) AS CURRENCY -- Model별로 하나의 CURRENCY만 있어야 하므로 MAX값 취함
        , A.ITEM_ID
        , '' AS M0
        , '' AS M1
        , '' AS M2
        , '' AS M3
        , '' AS M4
        , '' AS M5
        , '' AS M6
        , '' AS M7
        , '' AS M8
        , '' AS M9
        , '' AS M10
        , '' AS M11
        , '' AS M12
        , EDIT_YN
    FROM
    (
        SELECT
        SP.DIVISION_ID
        , TEAM.DEPT_ID
        , TEAM.DEPT_NAME_KO
        , MS.END_CUSTOMER
        , SP.PROJECT_CODE
        , MP.PROJECT_NAME
        , SP.ITEM_ID
        , SP.SCM_SITE_ID
        , CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY--CURRENCY가 없을 경우 SSPM의 값을 가져옴
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN

        FROM DM_PLN_SALES_PLAN_C SP

            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON SP.DIVISION_ID = T2.UNIT_ID

        INNER JOIN SCM_MST_SITE MS
            ON MS.DIVISION_ID = SP.DIVISION_ID
            AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
            AND MS.VALID_YN = 'Y'
        -- 변경된 DEPT_ID
        INNER JOIN SCM_MST_SITE_ITEM IM
            ON MS.DIVISION_ID = IM.DIVISION_ID
            AND MS.SCM_SITE_ID = IM.SCM_SITE_ID

        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            -- ON DI.DEPT_ID = MS.DEPT_ID
            ON DI.DEPT_ID = IM.DEPT_ID
            AND DI.VALID_YN = 'Y'

        /* DEPT_ID 테이블 변경
        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            ON DI.DEPT_ID = MS.DEPT_ID
            AND DI.VALID_YN = 'Y'
        */

        INNER JOIN SCM_MST_PROJECT MP
            ON MP.DIVISION_ID = SP.DIVISION_ID
            AND MP.PROJECT_CODE = SP.PROJECT_CODE --2026-07-03 perf: AS-IS 원문 활성 조인 복원 (주석 시 사업부 단위 준-카티전 → 86s/60행)

        INNER JOIN SCM_MST_SITE_ITEM SI
            ON SI.DIVISION_ID = SP.DIVISION_ID
            AND SI.PROJECT_CODE = SP.PROJECT_CODE
            AND SI.SCM_SITE_ID = SP.SCM_SITE_ID
            AND SI.ITEM_ID = SP.ITEM_ID
            AND SI.VALID_YN = 'Y'
        INNER JOIN TEMP_VERSION_NO T_VER--DIV별 최신버전(2024.10.04)
            ON SP.DIVISION_ID = T_VER.DIVISION_ID
            AND SP.VERSION_NO = T_VER.VERSION_NO
        LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                FROM SCM_MST_SSO_USER_INFO B
                INNER JOIN SCM_MST_SSO_DEPT_INFO C
                ON B.DEPT_ID = C.DEPT_ID
            ) TEAM
            ON
            TEAM.USER_ID = TRIM(
                CASE
                    WHEN INSTR(SI.OWNER, ',') > 0
                    THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                    ELSE SI.OWNER
                END
            )
        WHERE SP.DIVISION_ID = P_DIVISION_ID
        AND SP.QTY <> 0
        AND SP.MEASURE = 'RTF_SYS_RP'
        --버전의 날짜로 처리(2024.10.04)
        AND SP.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(T_VER.YYYYMMDD, 'MON') - 7, 'YYYYMMDD')
        AND SP.YYYYMMDD <= TO_CHAR(TO_DATE(TO_CHAR(FN_NEXT_DAY(T_VER.YYYYMMDD, 'MON') - 7, 'YYYYMMDD'), 'YYYYMMDD') + (52 * 7) - 1, 'YYYYMMDD')
        UNION ALL

        SELECT
        SP.DIVISION_ID
        , TEAM.DEPT_ID
        , TEAM.DEPT_NAME_KO
        , MS.END_CUSTOMER
        , SP.PROJECT_CODE
        , MP.PROJECT_NAME
        , SP.ITEM_ID
        , SP.SCM_SITE_ID
        , CASE WHEN NVL(SP.CURRENCY, '') = '' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY--CURRENCY가 없을 경우 SSPM의 값을 가져옴
        , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM DM_PLN_SALES_PLAN_RESULT_C SP

        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON SP.DIVISION_ID = T2.UNIT_ID


        INNER JOIN SCM_MST_SITE MS
            ON MS.DIVISION_ID = SP.DIVISION_ID
            AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
            AND MS.VALID_YN = 'Y'

        INNER JOIN SCM_MST_SITE_ITEM IM
            ON MS.DIVISION_ID = IM.DIVISION_ID
            AND MS.SCM_SITE_ID = IM.SCM_SITE_ID

        -- 변경된 DEPT_ID
        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            -- ON DI.DEPT_ID = MS.DEPT_ID
            ON DI.DEPT_ID = IM.DEPT_ID
            AND DI.VALID_YN = 'Y'

        /* DEPT_ID 테이블 변경
        INNER JOIN SCM_MST_SSO_DEPT_INFO DI
            ON DI.DEPT_ID = MS.DEPT_ID
            AND DI.VALID_YN = 'Y'
        */

        INNER JOIN SCM_MST_PROJECT MP
            ON MP.DIVISION_ID = SP.DIVISION_ID
            AND MP.PROJECT_CODE = SP.PROJECT_CODE
        INNER JOIN SCM_MST_SITE_ITEM SI
            ON SI.DIVISION_ID = SP.DIVISION_ID
            AND SI.PROJECT_CODE = SP.PROJECT_CODE
            AND SI.SCM_SITE_ID = SP.SCM_SITE_ID
            AND SI.ITEM_ID = SP.ITEM_ID
            AND SI.VALID_YN = 'Y'
        INNER JOIN TEMP_VERSION_NO T_VER--DIV별 최신버전(2024.10.04)
            ON SP.DIVISION_ID = T_VER.DIVISION_ID
            AND SP.VERSION_NO = T_VER.VERSION_NO
        LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                FROM SCM_MST_SSO_USER_INFO B
                INNER JOIN SCM_MST_SSO_DEPT_INFO C
                ON B.DEPT_ID = C.DEPT_ID
            ) TEAM
            ON
            TEAM.USER_ID = TRIM(
                CASE
                    WHEN INSTR(SI.OWNER, ',') > 0
                    THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                    ELSE SI.OWNER
                END
            )
        WHERE SP.DIVISION_ID = P_DIVISION_ID
        AND SP.QTY <> 0
        AND SP.MEASURE = 'RTF_SYS_RP'
        AND SP.YYYYMMDD >= T_VER.YYYYMM || '01'
        AND SP.YYYYMMDD < TO_CHAR(FN_NEXT_DAY(T_VER.YYYYMMDD, 'MON') - 7, 'YYYYMMDD')
    ) A
    GROUP BY
    A.DIVISION_ID
    , A.DEPT_ID
    , A.DEPT_NAME_KO
    , A.END_CUSTOMER
    , A.PROJECT_CODE
    , A.PROJECT_NAME
    , A.ITEM_ID
    , A.SCM_SITE_ID
    , A.EDIT_YN
    ;
    --, A.CURRENCY

    -- ================================================================
    -- 조회 성공 O_RESULT_CURSOR (Case 3 표준 패턴)
    -- ================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    -- ================================================================
    -- END 로그
    -- ================================================================
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END P_DMF0020_GET_SALES_PRICE_TEMPLATE;


PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP
(
    P_DIVISION_ID     IN VARCHAR2,
    P_FROM_YYYYMMDD   IN VARCHAR2,
    P_TO_YYYYMMDD     IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP]                                           */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2021.05.13	P.C.I		 [PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))*/
/* 2022.10.24	ROSIA27				[C20221024-000510]DM UI 소스 정리 요청							*/
/* 2026.03.20  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/
AS
  -- DM0020_GET_SCM_MST_FUTURE_PRICE '', '', '', '', '', ''

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    -- CASE WHEN 'ALL' 패턴 → UNION ALL 분기 (Case 17)
    OPEN O_RC1 FOR
    SELECT DIVISION_ID
         , CURRENCY
         , UNIT_CURRENCY
         , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   DM_MST_EXCHANGE_RATE T1

        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
    AND    YYYYMMDD <= P_TO_YYYYMMDD
    AND    P_DIVISION_ID = 'ALL'
    --[PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
    AND    UNIT_CURRENCY IN (
               SELECT SEGMENT1
               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A
               WHERE  LOOKUP_TYPE = 'DMF0020_CURRENCY'
               AND    VALID_YN    = 'Y'
           )
    AND    CURRENCY = 'KRW'
    GROUP BY DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN

    UNION ALL

    SELECT DIVISION_ID
         , CURRENCY
         , UNIT_CURRENCY
         , CURRENCY || '/' || UNIT_CURRENCY AS CURRENCY_UNITCURRENCY
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN

    FROM   DM_MST_EXCHANGE_RATE T1

        INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
    AND    YYYYMMDD <= P_TO_YYYYMMDD
    AND    P_DIVISION_ID <> 'ALL'
    AND    DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    --[PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
    AND    UNIT_CURRENCY IN (
               SELECT SEGMENT1
               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A
               WHERE  LOOKUP_TYPE = 'DMF0020_CURRENCY'
               AND    VALID_YN    = 'Y'
           )
    AND    CURRENCY = 'KRW'
    GROUP BY DIVISION_ID, CURRENCY, UNIT_CURRENCY, EDIT_YN
    ORDER BY 1, 2, 3;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_DIVISION_ID'   VALUE P_DIVISION_ID,
                'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
                'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
                'P_CREATED_BY'    VALUE P_CREATED_BY
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP;


PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA
(
    P_DIVISION_ID     IN VARCHAR2,
    P_FROM_YYYYMMDD   IN VARCHAR2,
    P_TO_YYYYMMDD     IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : [DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA]                                      */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!														*/
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2021.05.13	P.C.I		 [PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))*/
/* 2022.10.25	rosia27		 [C20221024-000510]DM UI 소스 정리 요청									*/
/* 2026.03.20  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/
AS
  -- DMF0020_GET_SCM_MST_FUTURE_PRICE '', '', '', '', '', ''

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    -- CASE WHEN 'ALL' 패턴 → UNION ALL 분기 (Case 17)
    OPEN O_RC1 FOR
    SELECT DIVISION_ID
         , CURRENCY
         , UNIT_CURRENCY
         , 'D' || YYYYMMDD AS YYYYMMDD
         , EXCHANGE_PRICE
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   DM_MST_EXCHANGE_RATE T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID

    WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
    AND    YYYYMMDD <= P_TO_YYYYMMDD
    AND    P_DIVISION_ID = 'ALL'
    --[PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
    AND    UNIT_CURRENCY IN (
               SELECT SEGMENT1
               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A
               WHERE  LOOKUP_TYPE = 'DMF0020_CURRENCY'
               AND    VALID_YN    = 'Y'
           )
    AND    CURRENCY = 'KRW'

    UNION ALL

    SELECT DIVISION_ID
         , CURRENCY
         , UNIT_CURRENCY
         , 'D' || YYYYMMDD AS YYYYMMDD
         , EXCHANGE_PRICE
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM   DM_MST_EXCHANGE_RATE T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
        ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
    AND    YYYYMMDD <= P_TO_YYYYMMDD
    AND    P_DIVISION_ID <> 'ALL'
    AND    DIVISION_ID IN (
               SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    --[PJ20209642R] Chempion 환율 적용(GSCM에서 관리중인 환율만 조회 Currency = 'KRW', Unit_Currency IN ( 'RMB', 'USD', 'EUR', 'JPY', 'AUD' ))
    AND    UNIT_CURRENCY IN (
               SELECT SEGMENT1
               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A
               WHERE  LOOKUP_TYPE = 'DMF0020_CURRENCY'
               AND    VALID_YN    = 'Y'
           )
    AND    CURRENCY = 'KRW';

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_DIVISION_ID'   VALUE P_DIVISION_ID,
                'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
                'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
                'P_CREATED_BY'    VALUE P_CREATED_BY
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA;


PROCEDURE P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE
(
    P_START_DT        IN VARCHAR2,
    P_END_DT          IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0020_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2021/03/04  kuniid         [C20210127-000163] GSCM Sales Price 일괄입력 기능 개선 요청 */
/* 2026.03.17  jcnam          [PJ20264226] NextSCM Pilot 설계 및 개발                                */
/****************************************************************************************************/
/*
VAR RC1 REFCURSOR;
VAR RC2 REFCURSOR;
EXEC DMF0020_GET_SPREAD_TITLE_SAVE_PRICE('20250101','20260301','bindy122678','40',:RC1, :RC2);
PRINT RC1;
PRINT RC2;
*/
AS

    v_program_id     VARCHAR2(50 CHAR) := 'DMF0020';
    v_sheet_name     VARCHAR2(50 CHAR) := 'Sales Price Save All';

    I_COUNT          PLS_INTEGER := 0;

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    -- 1. 등록여부
    SELECT COUNT(*)
    INTO   I_COUNT
    FROM   SCM_MST_TITLESET_USER U
    --     , SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID
    --AND    U.SHEET_NAME  = C.SHEET_NAME
    --AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = v_program_id
    AND    U.SHEET_NAME  = v_sheet_name
    AND    U.USER_ID     = P_CREATED_BY
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

    -- 2.
    --IF I_COUNT = 0 THEN
    -- 일반 데이터 칼럼
    OPEN O_RC1 FOR
    SELECT C.PROGRAM_ID
         , C.SHEET_NAME
         , C.COLUMN_NAME
         , C.COLUMN_LABEL_NAME
         , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
         , C.DATA_SORT_METHOD_CODE
         , C.SMALL_CLASS_LABEL_NAME
         , C.LARGE_CLASS_LABEL_NAME
         , ''                     AS DAY_CODE
         , C.FIXED_FLAG
         , C.COLUMN_WIDTH
         , C.CELL_CONTROL_OBJECT_TYPE_CODE
         , C.CELL_COMBO_DATA_TYPE
         , C.DATA_SCALE_NUMBER
         , C.DATA_MAX_LENGTH
         , C.HORIZONTAL_ALIGN_CODE
         , C.UPPERCASE_APPLY_FLAG
         , C.VISIBLE_FLAG
         , C.DEFAULT_FLAG
         , C.USER_SELECTABLE_FLAG
         , C.VALID_YN
         --, CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가
         --  CASE dbo.FN_GET_DIVISION_YN(C.DIVISION_ID, @p_division_id) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
         -- ELSE C.VALID_YN END VALID_YN
         , '0'                      AS SEQ
    --INTO #tmpTitleO
    FROM   SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    AND    C.PROGRAM_ID  = v_program_id
    AND    C.SHEET_NAME  = v_sheet_name
    AND    ( C.DEFAULT_FLAG = 'Y'
          OR (    C.VISIBLE_FLAG = 'N'
              AND (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ')   -- MSSQL '' = Oracle NULL
              AND C.VALID_YN     = 'Y'
             )
           )
    AND    P_DIVISION_ID IN (                                              -- 20180604 division 추가
               SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
               FROM   DUAL
               CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
           )
    -- 날짜 데이터 칼럼
    UNION ALL
    SELECT v_program_id            AS PROGRAM_ID
         , v_sheet_name            AS SHEET_NAME
         , MA.COLUMN_NAME
         , MA.COLUMN_LABEL_NAME
         , TO_NUMBER(MA.SORT_ORDER_NO) AS SORT_ORDER_NO   -- VARCHAR2 → NUMBER (ORA-01790 방지)
         , ''                      AS DATA_SORT_METHOD_CODE
         , MA.SMALL_CLASS_LABEL_NAME
         , MA.LARGE_CLASS_LABEL_NAME
         , MA.DAY_CODE
         , ''                      AS FIXED_FLAG
         , 120                     AS COLUMN_WIDTH
         , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
         , ''                      AS CELL_COMBO_DATA_TYPE
         --, 2                     AS DATA_SCALE_NUMBER
         , 3                       AS DATA_SCALE_NUMBER    -- 20181029  NUMBER 리터럴 (ORA-01790 방지)
         , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- NUMBER NULL (ORA-01790 방지)
         , 'R'                     AS HORIZONTAL_ALIGN_CODE
         , 'Y'                     AS UPPERCASE_APPLY_FLAG
         , 'Y'                     AS VISIBLE_FLAG
         , ''                      AS DEFAULT_FLAG
         , ''                      AS USER_SELECTABLE_FLAG
         , ''                      AS VALID_YN
         , ''                      AS DIVISION_ID
    FROM (
            SELECT 'W_' || MIN(BASIS_START_DATE)               AS COLUMN_NAME
                 , SUBSTR(BASIS_START_DATE, 5, 4)              AS COLUMN_LABEL_NAME
                 , WEEK_NAME                                   AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                                  AS LARGE_CLASS_LABEL_NAME
                 , ''                                          AS DAY_CODE
                 , MIN(BASIS_START_DATE)                        AS SORT_ORDER_NO
                 , 'FPNumber'                                  AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM   SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
            AND    BASIS_YYYYMMDD <= P_END_DT
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

            UNION ALL

            SELECT 'M_' || MIN(BASIS_START_DATE)               AS COLUMN_NAME
                 , SUBSTR(BASIS_START_DATE, 5, 4)              AS COLUMN_LABEL_NAME
                 , WEEK_NAME                                   AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                                  AS LARGE_CLASS_LABEL_NAME
                 , ''                                          AS DAY_CODE
                 , MIN(BASIS_START_DATE)                        AS SORT_ORDER_NO
                 , 'FPNumber'                                  AS CELL_CONTROL_OBJECT_TYPE_CODE
            FROM   SCM_SYS_CALENDAR_M
            WHERE  BASIS_YYYYMMDD >= P_START_DT
            AND    BASIS_YYYYMMDD <= P_END_DT
            AND    CALENDAR_DAY = '01'
            GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

         ) MA
    ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;

    --ELSE --IF I_COUNT <> 0
    --BEGIN
    -- -- 일반 데이터 칼럼
    -- SELECT U.PROGRAM_ID
    --   , U.SHEET_NAME
    --   , U.COLUMN_NAME
    --   , C.COLUMN_LABEL_NAME
    --   , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
    --   , U.DATA_SORT_METHOD_CODE
    --   , C.SMALL_CLASS_LABEL_NAME
    --   , C.LARGE_CLASS_LABEL_NAME
    --   , '' AS DAY_CODE
    --   , C.FIXED_FLAG
    --   , C.COLUMN_WIDTH
    --   , C.CELL_CONTROL_OBJECT_TYPE_CODE
    --   , C.CELL_COMBO_DATA_TYPE
    --   , C.DATA_SCALE_NUMBER
    --   , C.DATA_MAX_LENGTH
    --   , C.HORIZONTAL_ALIGN_CODE
    --   , C.UPPERCASE_APPLY_FLAG
    --   , C.VISIBLE_FLAG
    --   , C.DEFAULT_FLAG
    --   , C.USER_SELECTABLE_FLAG
    --   --, C.VALID_YN
    --   , CASE C.VALID_YN  WHEN 'Y' THEN -- 20180607 추가
    --    CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
    --   ELSE C.VALID_YN END VALID_YN
    --   , 1 AS SEQ
    -- FROM   SCM_MST_TITLESET_USER U
    --   , SCM_MST_SHEET_COLUMNS C
    -- WHERE  1 = 1
    -- AND    U.PROGRAM_ID  = C.PROGRAM_ID
    -- AND    U.SHEET_NAME  = C.SHEET_NAME
    -- AND    U.COLUMN_NAME = C.COLUMN_NAME
    -- AND    U.PROGRAM_ID  = v_program_id
    -- AND    U.SHEET_NAME  = v_sheet_name
    -- AND    U.USER_ID     = P_CREATED_BY
    -- AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    -- AND    P_DIVISION_ID IN (
    --            SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
    --            FROM   DUAL
    --            CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    --        )  -- 20180604 division 추가
    -- UNION ALL
    -- SELECT C.PROGRAM_ID
    --   , C.SHEET_NAME
    --   , C.COLUMN_NAME
    --   , C.COLUMN_LABEL_NAME
    --   , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
    --   , C.DATA_SORT_METHOD_CODE
    --   , C.SMALL_CLASS_LABEL_NAME
    --   , C.LARGE_CLASS_LABEL_NAME
    --   , '' AS DAY_CODE
    --   , C.FIXED_FLAG
    --   , C.COLUMN_WIDTH
    --   , C.CELL_CONTROL_OBJECT_TYPE_CODE
    --   , C.CELL_COMBO_DATA_TYPE
    --   , C.DATA_SCALE_NUMBER
    --   , C.DATA_MAX_LENGTH
    --   , C.HORIZONTAL_ALIGN_CODE
    --   , C.UPPERCASE_APPLY_FLAG
    --   , C.VISIBLE_FLAG
    --   , C.DEFAULT_FLAG
    --   , C.USER_SELECTABLE_FLAG
    --   , C.VALID_YN
    --   , 2 AS SEQ
    -- FROM   SCM_MST_SHEET_COLUMNS C
    -- WHERE  1 = 1
    -- AND    C.PROGRAM_ID   = v_program_id
    -- AND    C.SHEET_NAME   = v_sheet_name
    -- AND    C.VISIBLE_FLAG = 'N'
    -- AND    (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ')
    -- AND    C.VALID_YN     = 'Y'
    -- AND    P_DIVISION_ID IN (
    --            SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
    --            FROM   DUAL
    --            CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
    --        )  -- 20180604 division 추가
    -- --ORDER BY SEQ, SORT_ORDER_NO
    -- -- 날짜 데이터 칼럼
    -- UNION ALL
    -- SELECT
    --  v_program_id             AS PROGRAM_ID
    --  , v_sheet_name           AS SHEET_NAME
    --  , MA.COLUMN_NAME
    --  , MA.COLUMN_LABEL_NAME
    --  , TO_NUMBER(MA.SORT_ORDER_NO) AS SORT_ORDER_NO
    --  , ''                     AS DATA_SORT_METHOD_CODE
    --  , MA.SMALL_CLASS_LABEL_NAME
    --  , MA.LARGE_CLASS_LABEL_NAME
    --  , MA.DAY_CODE
    --  , ''                     AS FIXED_FLAG
    --  , 120                    AS COLUMN_WIDTH
    --  , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
    --  , ''                     AS CELL_COMBO_DATA_TYPE
    --  --, 2                    AS DATA_SCALE_NUMBER
    --  , 3                      AS DATA_SCALE_NUMBER -- 20181029
    --  , TO_NUMBER(NULL)        AS DATA_MAX_LENGTH
    --  , 'R'                    AS HORIZONTAL_ALIGN_CODE
    --  , 'Y'                    AS UPPERCASE_APPLY_FLAG
    --  , 'Y'                    AS VISIBLE_FLAG
    --  , ''                     AS DEFAULT_FLAG
    --  , ''                     AS USER_SELECTABLE_FLAG
    --  , ''                     AS VALID_YN
    --  , ''                     AS DIVISION_ID
    -- FROM  (
    --  SELECT
    --   'W_' || MIN(BASIS_START_DATE)              AS COLUMN_NAME
    --   , SUBSTR(BASIS_START_DATE, 5, 4)           AS COLUMN_LABEL_NAME
    --   , WEEK_NAME                                AS SMALL_CLASS_LABEL_NAME
    --   , MONTH_NAME                               AS LARGE_CLASS_LABEL_NAME
    --   , ''                                       AS DAY_CODE
    --   , MIN(BASIS_START_DATE)                     AS SORT_ORDER_NO
    --   , 'FPNumber'                               AS CELL_CONTROL_OBJECT_TYPE_CODE
    --  FROM SCM_SYS_CALENDAR_M
    --  WHERE  BASIS_YYYYMMDD >= P_START_DT
    --   AND    BASIS_YYYYMMDD <= P_END_DT
    --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME
    --
    --  UNION ALL
    --
    --  SELECT
    --   'M_' || MIN(BASIS_START_DATE)              AS COLUMN_NAME
    --   , SUBSTR(BASIS_START_DATE, 5, 4)           AS COLUMN_LABEL_NAME
    --   , WEEK_NAME                                AS SMALL_CLASS_LABEL_NAME
    --   , MONTH_NAME                               AS LARGE_CLASS_LABEL_NAME
    --   , ''                                       AS DAY_CODE
    --   , MIN(BASIS_START_DATE)                     AS SORT_ORDER_NO
    --   , 'FPNumber'                               AS CELL_CONTROL_OBJECT_TYPE_CODE
    --  FROM SCM_SYS_CALENDAR_M
    --  WHERE  BASIS_YYYYMMDD >= P_START_DT
    --   AND BASIS_YYYYMMDD <= P_END_DT
    --   AND CALENDAR_DAY = '01'
    --  GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME
    --
    -- ) MA
    -- ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;
    --END IF;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_START_DT'    VALUE P_START_DT,
                'P_END_DT'      VALUE P_END_DT,
                'P_CREATED_BY'  VALUE P_CREATED_BY,
                'P_DIVISION_ID' VALUE P_DIVISION_ID
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE;


PROCEDURE P_DMF0020_GET_SPREAD_TITLE_DATE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************/
/* Program ID  : DMF0020_GET_SPREAD_TITLE_DATE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2020/03/06  P.C.I        [PJ20200138]DM->DMF 명칭 변경                                                       */
/* 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
/*
VAR RC1 REFCURSOR;
VAR RC2 REFCURSOR;
EXEC P_DMF0020_GET_SPREAD_TITLE_DATE('20250101','20260301','bindy122678',:RC1, :RC2);
PRINT RC1;
PRINT RC2;
*/
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT MIN(BASIS_START_DATE)          AS BASIS_START_DATE
         , BASIS_YYYYMM
         , WEEK_NAME
         , SUBSTR(BASIS_START_DATE, 5, 4) AS DATE_SHORT1_NAME
    FROM   SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD >= P_START_YYYYMMDD
    AND    BASIS_YYYYMMDD <= P_END_YYYYMMDD
    GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4)
    ORDER BY BASIS_START_DATE;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_GET_SPREAD_TITLE_DATE;


PROCEDURE P_DMF0020_GET_OWNER_DATA
(
    P_DIVISION_ID     IN VARCHAR2,
    P_DEPT_ID         IN VARCHAR2,
    P_END_CUSTOMER    IN VARCHAR2,
    P_PROJECT_CODE    IN VARCHAR2,
    P_SCM_SITE_ID     IN VARCHAR2,
    P_OWNER_ID        IN VARCHAR2,

    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*--------------------------------------------------------------------------------------------------*/
/* Program ID  : [DMF0020_GET_OWNER_DATA]                                                           */
/* Description : 상단 owner 조회조건 'Owner By DivisionPopup'                                       */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/06/21  JYE       Initial Release - OWNER 조회
** 2019/01/23  JYE           42, 44 사업부 추가
** 20200423    KHSONG    C20200422-000403 WS Owner 정보추가요청건 반영
** 2022.04.06  rosia27	 [과제PJ20216891R]GM_JV
* 2024/08/14	KJJ			[PJ2024-50461] Team Mapping
* 2026.03.17   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
*/
/*--------------------------------------------------------------------------------------------------*/
/*
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
*/
/*--------------------------------------------------------------------------------------------------*/
/*
VAR RC1 REFCURSOR;
VAR RC2 REFCURSOR;
EXEC DMF0020_GET_OWNER_DATA('40','58666055','ALL','','ALL','sunny.kim', :RC1, :RC2);
PRINT RC1;
PRINT RC2;
*/
AS

    /*
    DMF000_GET_OWNER_DATA(Multi Owner 조회창)과 동일하게 쿼리 수정(2024.10.17)

    아래 룩업 사용
    --GET_ADMIN_GROUP
    --DM_OWNER_DEPT
    */

    --쿼리 전체 수정

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    v_ADMIN_GROUP    T_STR_TAB := T_STR_TAB();
    v_group_id       VARCHAR2(50 CHAR) := '';

    T_LEVEL2_DEPT_ID T_STR_TAB := T_STR_TAB();  -- 전지본부의 LEVEL2 아이디가 들어간다.
    T_LEVEL1_DEPT_ID T_STR_TAB := T_STR_TAB();  -- 기타 추가하고자 하는 부서의 아이디가 들어간다.
    V_TMPDEPT        T_STR_TAB := T_STR_TAB();

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    SELECT SEGMENT1
    BULK COLLECT INTO v_ADMIN_GROUP
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'ALL'
    AND    SEGMENT1    = 'ADMIN'; --조건 빠지면 안됨

    SELECT SEGMENT1
    BULK COLLECT INTO T_LEVEL2_DEPT_ID
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_OWNER_DEPT'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'LEVEL_2';

    SELECT SEGMENT1
    BULK COLLECT INTO T_LEVEL1_DEPT_ID
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_OWNER_DEPT'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'LEVEL_1';

    -- GroupID JOIN 조건에 사용
    v_ADMIN_GROUP.EXTEND(2);
    v_ADMIN_GROUP(v_ADMIN_GROUP.COUNT - 1) := 'DM Planner';
    v_ADMIN_GROUP(v_ADMIN_GROUP.COUNT)     := 'DM Planner (W/S)'; -- [C20220228-000147]

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -- 소형사업부, 82 사업부
    --IF v_group_id = 'ADMIN' AND (P_DIVISION_ID = '40' OR P_DIVISION_ID = '82')
    IF P_DIVISION_ID = '40' OR P_DIVISION_ID = '82' THEN
        SELECT DISTINCT C.DEPT_ID
        BULK COLLECT INTO V_TMPDEPT
        FROM   SCM_MST_SITE_ITEM A
             , SCM_MST_SSO_USER_INFO B
             , SCM_MST_SSO_DEPT_INFO C
        WHERE  A.OWNER       = B.USER_ID
        AND    B.DEPT_ID     = C.DEPT_ID
        AND    A.DIVISION_ID = P_DIVISION_ID;-- Admin 이고 40 사업부의 경우에 해당 사업부의 Owner만 조회 / 82 사업부추가[PJ2024-50461] Team Mapping
    END IF;

    -- 자동차 사업부
    --IF v_group_id = 'ADMIN' AND P_DIVISION_ID LIKE '81%'
    IF P_DIVISION_ID LIKE '81%' THEN
        SELECT DISTINCT DEPT_ID
        BULK COLLECT INTO V_TMPDEPT
        FROM (
            SELECT C.DEPT_ID
            FROM   SCM_MST_SITE_ITEM A
                 , SCM_MST_SSO_USER_INFO B
                 , SCM_MST_SSO_DEPT_INFO C
            WHERE  A.OWNER       = B.USER_ID
            AND    B.DEPT_ID     = C.DEPT_ID
            AND    A.DIVISION_ID = P_DIVISION_ID
            UNION ALL
            SELECT DISTINCT SEGMENT1 AS DEPT_ID
            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP
            WHERE  LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
            AND    LOOKUP.VALID_YN    = 'Y'
            AND    LOOKUP.SEGMENT3 IN (
                       SELECT DISTINCT C.DEPT_ID
                       FROM   SCM_MST_SITE_ITEM A
                            , SCM_MST_SSO_USER_INFO B
                            , SCM_MST_SSO_DEPT_INFO C
                       WHERE  A.OWNER       = B.USER_ID
                       AND    B.DEPT_ID     = C.DEPT_ID
                       AND    A.DIVISION_ID = P_DIVISION_ID
                   )
        );
    END IF;

    OPEN O_RC1 FOR
    SELECT FxUGA.unit_id                                                      AS DIVISION_ID
         , FxU.Dept_ID
         , DEPT_INFO.DEPT_NAME_KO
         , FxU.USER_NM
         , FxU.User_ID                                                      AS OWNER_NAME
         , ROW_NUMBER() OVER (ORDER BY FxU.User_ID, FxU.USER_NM) * 100     AS SORT_ORDER_NO
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  (SELECT * FROM SCM_ADM_USER_M WHERE Use_YN = 'Y') FxU
    INNER JOIN (
                SELECT T.DEPT_ID      AS DEPT_ID
                     , T.DEPT_NAME_KO AS DEPT_NAME_KO
                     , T.VALID_YN
                FROM   SCM_MST_SSO_DEPT_INFO D
                     , SCM_MST_SSO_DEPT_INFO T
                WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
                AND    T."2LEVEL_DEPT_ID" IN ( SELECT COLUMN_VALUE FROM TABLE(T_LEVEL2_DEPT_ID) ) -- '58174290'  -- 전지사업부

                UNION ALL
                SELECT T.DEPT_ID      AS DEPT_ID
                     , T.DEPT_NAME_KO AS DEPT_NAME_KO
                     , T.VALID_YN
                FROM   SCM_MST_SSO_DEPT_INFO D
                     , SCM_MST_SSO_DEPT_INFO T
                WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
                AND    T.DEPT_ID IN ( SELECT COLUMN_VALUE FROM TABLE(T_LEVEL1_DEPT_ID) ) -- '58174290'  -- 전지사업부
                AND    D.VALID_YN = 'Y'
                AND    T.VALID_YN = 'Y'
              ) DEPT_INFO
        ON FxU.DEPT_ID = DEPT_INFO.DEPT_ID AND DEPT_INFO.VALID_YN = 'Y'
    INNER JOIN SCM_MST_SSO_USER_INFO USER_INFO
        ON FxU.User_ID = USER_INFO.USER_ID
    INNER JOIN SCM_ADM_USER_GR_UNIT_AUTH_MPG_M FxUGA
        ON FxU.User_ID = FxUGA.User_ID
        AND USER_GR_ID IN (SELECT COLUMN_VALUE FROM TABLE(v_ADMIN_GROUP))  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리

    INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
    ON FxUGA.UNIT_ID = T2.UNIT_ID


    WHERE 1 = 1
    AND   FxUGA.unit_id = P_DIVISION_ID
    -- P_DEPT_ID 'ALL' 분기 (Case 17)
    AND   (
              ( P_DEPT_ID = 'ALL' )
           OR ( P_DEPT_ID <> 'ALL'
                AND FxU.DEPT_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
              )
          )
    -- P_OWNER_ID 조건 (Oracle: '' IS NULL)
    AND   (
              P_OWNER_ID IS NULL
           OR FxU.User_ID IN (
                  SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                  FROM   DUAL
                  CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
              )
           OR FxU.USER_NM IN (
                  SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                  FROM   DUAL
                  CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
              )
           OR USER_INFO.USER_NAME_EN IN (
                  SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                  FROM   DUAL
                  CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
              )
          )
    AND   FxU.Dept_ID IN ( SELECT COLUMN_VALUE FROM TABLE(V_TMPDEPT) ) --Dept_ID Table
    GROUP BY FxUGA.unit_id, FxU.User_ID, FxU.USER_NM, USER_INFO.USER_NAME_EN, FxU.Dept_ID, DEPT_INFO.DEPT_NAME_KO, USER_INFO.JOB_NAME, T2.EDIT_YN
    ORDER BY DEPT_INFO.DEPT_NAME_KO, FxU.USER_NM, FxU.User_ID;

    /*
    -----------------------------------------------------------------------
    -- 하단 주석 블록 (DIVISION_ID = '40' / '81','82' 분기) 원본 유지
    -- ... (원본 MSSQL 주석 그대로 보존 - 생략)
    -----------------------------------------------------------------------
    */

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_DIVISION_ID'   VALUE P_DIVISION_ID,
                'P_DEPT_ID'       VALUE P_DEPT_ID,
                'P_END_CUSTOMER'  VALUE P_END_CUSTOMER,
                'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
                'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
                'P_OWNER_ID'      VALUE P_OWNER_ID
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_GET_OWNER_DATA;

-- 3/23
PROCEDURE P_DMF0020_GET_WEEKDATA
(
    P_YYYYMMDD        IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_WEEKDATA
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.17  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT BASIS_START_DATE
         , BASIS_YYYYMMDD
    FROM   SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD <= P_YYYYMMDD
    ORDER BY BASIS_YYYYMMDD DESC
    FETCH FIRST 7 ROWS ONLY;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_YYYYMMDD' VALUE P_YYYYMMDD
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_GET_WEEKDATA;


PROCEDURE P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL
(
    P_ACTIVE_FLAG       IN VARCHAR2,
    P_DIVISION_ID       IN VARCHAR2,
    P_YYYYMMDD          IN VARCHAR2,
    P_CURRENCY          IN VARCHAR2,
    P_UNIT_CURRENCY     IN VARCHAR2,
    P_EXCHANGE_PRICE    IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL
 * Description  : DMF0020_SalesFuturePricePopUp ('DM_MST_EXCHANGE_RATE' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20180807 KHSONG Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180807 KHSONG Split 구조변경
 * 20221025	ROSIA27	[C20221024-000510]DM UI 소스 정리 요청
 * 2026.03.17  jcnam   [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    v_delimiter      VARCHAR2(1 CHAR) := '^';  -- 데이터 구분자
    v_max_cnt        PLS_INTEGER := 0;
    v_exists         PLS_INTEGER;

    -- LOG 용 변수 설정
    v_log_type       VARCHAR2(30 CHAR); -- START/END/ERROR/...
    n_log_count      PLS_INTEGER := 0;
    v_log_message    VARCHAR2(1000 CHAR);
    v_description    VARCHAR2(500 CHAR);
    d_event_date     DATE;
    n_delete_count   PLS_INTEGER := 0;
    n_merge_count    PLS_INTEGER := 0;

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE_E     VARCHAR2(100 CHAR);
    V_LOG_MESSAGE_E  VARCHAR2(4000 CHAR);
    V_DESCRIPTION_E  VARCHAR2(4000 CHAR);

BEGIN

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- GTT TRUNCATE
    DELETE FROM SCM_MGR.GT_F020_EXCHANGE_RATE;

    --###############################################  GTT에 split후 insert (START)
    -- MSSQL WHILE 루프 → Oracle 집합 기반 INSERT
    -- '^' 구분자로 분리된 각 파라미터를 REGEXP_SUBSTR로 파싱하여 한번에 INSERT

    -- 레코드 수 계산 (DIVISION_ID 기준)
    SELECT REGEXP_COUNT(P_DIVISION_ID, '\^') + 1
    INTO   v_max_cnt
    FROM   DUAL;

    INSERT INTO SCM_MGR.GT_F020_EXCHANGE_RATE
    (ACTIVE_FLAG, DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, CREATED_BY, LAST_UPDATED_BY)
    SELECT TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,     '[^\^]+', 1, LEVEL)) AS ACTIVE_FLAG
         , TRIM(REGEXP_SUBSTR(P_DIVISION_ID,     '[^\^]+', 1, LEVEL)) AS DIVISION_ID
         , TRIM(REGEXP_SUBSTR(P_YYYYMMDD,        '[^\^]+', 1, LEVEL)) AS YYYYMMDD
         , TRIM(REGEXP_SUBSTR(P_CURRENCY,        '[^\^]+', 1, LEVEL)) AS CURRENCY
         , TRIM(REGEXP_SUBSTR(P_UNIT_CURRENCY,   '[^\^]+', 1, LEVEL)) AS UNIT_CURRENCY
         , TRIM(REGEXP_SUBSTR(P_EXCHANGE_PRICE,  '[^\^]+', 1, LEVEL)) AS EXCHANGE_PRICE
         , TRIM(REGEXP_SUBSTR(P_CREATED_BY,      '[^\^]+', 1, LEVEL)) AS CREATED_BY
         , TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY, '[^\^]+', 1, LEVEL)) AS LAST_UPDATED_BY
    FROM   DUAL
    CONNECT BY LEVEL <= v_max_cnt;

    COMMIT;

    --###############################################  GTT에 split후 insert (END)

    -- 20180806 KHSONG Division_id Null Validation 추가
    BEGIN
        SELECT 1
        INTO   v_exists
        FROM   DUAL
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F020_EXCHANGE_RATE R
            WHERE  NOT EXISTS (
                       SELECT 1
                       FROM   SCM_MST_DIVISION D
                       WHERE  D.DIVISION_ID = R.DIVISION_ID
                   )
        );

        -- Division 값이 존재하지 않는 레코드가 있음
        v_log_type    := 'INVALID';
        v_log_message := '########## END of procedure ##########';
        v_description := 'Division 값이 존재하지 않습니다.';
        d_event_date  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, v_description AS EVENT FROM DUAL;
        RETURN;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL; -- 모든 Division이 유효함 → 정상 진행
    END;

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_F020_EXCHANGE_RATE',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1',
        NO_INVALIDATE    => FALSE
    );

    --===================================================================================== delete start
    DELETE FROM DM_MST_EXCHANGE_RATE
    WHERE  EXISTS (
               SELECT 1
               FROM   GT_F020_EXCHANGE_RATE R
               WHERE  R.ACTIVE_FLAG                       = 'D'
               AND    DM_MST_EXCHANGE_RATE.DIVISION_ID    = R.DIVISION_ID
               AND    DM_MST_EXCHANGE_RATE.YYYYMMDD       = R.YYYYMMDD
               AND    DM_MST_EXCHANGE_RATE.CURRENCY       = R.CURRENCY
               AND    DM_MST_EXCHANGE_RATE.UNIT_CURRENCY  = R.UNIT_CURRENCY
           );

    n_delete_count := SQL%ROWCOUNT;
    --===================================================================================== delete end

    --===================================================================================== update, insert start
    MERGE INTO DM_MST_EXCHANGE_RATE A
    USING (
            SELECT DIVISION_ID
                 , YYYYMMDD
                 , CURRENCY
                 , UNIT_CURRENCY
                 , MAX(EXCHANGE_PRICE)  AS EXCHANGE_PRICE
                 , MAX(CREATED_BY)      AS CREATED_BY
                 , MAX(LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM   GT_F020_EXCHANGE_RATE
            WHERE  ACTIVE_FLAG <> 'D'   -- DELETE값이 아닌경우만
            GROUP BY DIVISION_ID
                   , YYYYMMDD
                   , CURRENCY
                   , UNIT_CURRENCY
          ) B
    ON (
            A.DIVISION_ID   = B.DIVISION_ID
        AND A.YYYYMMDD      = B.YYYYMMDD
        AND A.CURRENCY      = B.CURRENCY
        AND A.UNIT_CURRENCY = B.UNIT_CURRENCY
       )
    WHEN MATCHED THEN
        UPDATE SET
            A.EXCHANGE_PRICE   = TO_NUMBER(B.EXCHANGE_PRICE),
            A.CREATED_BY       = B.CREATED_BY,
            A.CREATION_DATE    = SYSDATE,
            A.LAST_UPDATED_BY  = B.LAST_UPDATED_BY,
            A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (
            DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY,
            EXCHANGE_PRICE, CREATED_BY, CREATION_DATE,
            LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
            B.DIVISION_ID, B.YYYYMMDD, B.CURRENCY, B.UNIT_CURRENCY,
            TO_NUMBER(B.EXCHANGE_PRICE), B.CREATED_BY, SYSDATE,
            B.LAST_UPDATED_BY, SYSDATE
        );

    n_merge_count := SQL%ROWCOUNT;
    --===================================================================================== update, insert end

    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count: ' || TO_CHAR(n_delete_count) || ' / merge_count: ' || TO_CHAR(n_merge_count);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류.
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_delete_count + n_merge_count) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE_E    := 'ERROR';
        V_LOG_MESSAGE_E := 'EXCEPTION';
        V_DESCRIPTION_E := '';
        V_SQL_CODE      := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG    := SQLERRM;
        V_PROC_INPUT    :=
            JSON_OBJECT(
                'P_ACTIVE_FLAG'     VALUE SUBSTR(P_ACTIVE_FLAG, 1, 500),
                'P_DIVISION_ID'     VALUE SUBSTR(P_DIVISION_ID, 1, 500),
                'P_YYYYMMDD'        VALUE SUBSTR(P_YYYYMMDD, 1, 500),
                'P_CURRENCY'        VALUE SUBSTR(P_CURRENCY, 1, 500),
                'P_UNIT_CURRENCY'   VALUE SUBSTR(P_UNIT_CURRENCY, 1, 500),
                'P_EXCHANGE_PRICE'  VALUE SUBSTR(P_EXCHANGE_PRICE, 1, 500),
                'P_CREATED_BY'      VALUE P_CREATED_BY,
                'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
            );
        V_BACKTRACE     := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE_E, n_log_count, V_LOG_MESSAGE_E,
                V_DESCRIPTION_E, SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL;


PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION
(
    P_DIVISION_ID     IN VARCHAR2,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION
 * Description  : SCM_MST_FUTURE_PRICE Data Conversion
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 22    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180720 KHSONG 주석처리 전체를 다시 계산함
 * 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021.05.13	P.C.I		[PJ20209642R] Chempion 환율 적용
 * 2022.10.24	ROSIA27		[C20221024-000510]DM UI 소스 정리 요청
 * 2025.03.25	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_SELLING_PRICE 재생성
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
-- Weekly Cutoff 시에 이 로직이 수행되어야 함.
AS

    -- 당주 월요일 - 7일 (MSSQL: DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')))
    v_cutoff_yyyymmdd  VARCHAR2(8 CHAR);

    -- LOG 용 변수 설정
    v_log_type         VARCHAR2(30 CHAR); -- START/END/ERROR/...
    n_log_count        PLS_INTEGER := 0;
    v_log_message      VARCHAR2(1000 CHAR);
    v_description      VARCHAR2(500 CHAR);
    d_event_date       DATE;
    n_merge_count1     PLS_INTEGER := 0;
    n_merge_count2     PLS_INTEGER := 0;

    V_PROC_INPUT       VARCHAR2(4000 CHAR);
    V_BACKTRACE        VARCHAR2(4000 CHAR);
    V_SQL_CODE         VARCHAR2(100 CHAR);
    V_SQL_ERRMSG       VARCHAR2(1000 CHAR);
    V_LOG_TYPE_E       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE_E    VARCHAR2(4000 CHAR);
    V_DESCRIPTION_E    VARCHAR2(4000 CHAR);

BEGIN

    -- 당주 월요일 - 7일 계산
    v_cutoff_yyyymmdd := TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD');

    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := 'DIVISION_ID : ' || P_DIVISION_ID;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    -- GTT TRUNCATE
    DELETE FROM SCM_MGR.GT_F020_FUTURE_PRICE_TEMP2;
    DELETE FROM SCM_MGR.GT_F020_CFM_SELLING_PRICE_TEMP2;

    -- =====================================================================================
    -- STEP 1: #FUTURE_PRICE_TEMP1 → WITH절, #FUTURE_PRICE_TEMP2 → GTT INSERT
    -- =====================================================================================
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F020_FUTURE_PRICE_TEMP2
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY)
    WITH FUTURE_PRICE_TEMP1 AS (
        SELECT /*+ FULL(F) PARALLEL(F,4) */
               DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY
        FROM   SCM_MST_FUTURE_PRICE F
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    YYYYMMDD   >= v_cutoff_yyyymmdd  -- 당주 월요일이후 데이터만 대상으로함
        AND    MEASURE     = 'LOC'
    )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, ROUND(PRICE, 3) AS PRICE, CREATED_BY
    FROM (
        SELECT A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'KRW'
                    WHEN A.CURRENCY = 'USD' THEN 'USD'
                    ELSE 'KRW' END                                        AS MEASURE
             , DOM_EXP, FCST_TYPE, INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN PRICE
                    WHEN A.CURRENCY = 'USD' THEN PRICE
                    ELSE PRICE * NVL(B.EXCHANGE_PRICE, 1) END             AS PRICE
             , A.CREATED_BY
        FROM   FUTURE_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY      = 'KRW'
            AND A.CURRENCY      = B.UNIT_CURRENCY

        UNION ALL

        SELECT A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'USD'
                    WHEN A.CURRENCY = 'USD' THEN 'KRW'
                    ELSE 'USD' END                                        AS MEASURE
             , DOM_EXP, FCST_TYPE, INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN NVL(PRICE / NVL(B.EXCHANGE_PRICE, 1), 0)
                    WHEN A.CURRENCY = 'USD' THEN NVL(PRICE * NVL(B.EXCHANGE_PRICE, 1), 0)
                    ELSE NVL(
                            (A.PRICE * NVL(
                                (SELECT DMER.EXCHANGE_PRICE
                                 FROM   DM_MST_EXCHANGE_RATE DMER
                                 WHERE  DMER.DIVISION_ID   = A.DIVISION_ID
                                 AND    DMER.YYYYMMDD      = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                 AND    DMER.UNIT_CURRENCY  = A.CURRENCY
                                 AND    DMER.CURRENCY       = 'KRW'), 1))
                            / NVL(B.EXCHANGE_PRICE, 1), 0)
               END                                                        AS PRICE
             , A.CREATED_BY
        FROM   FUTURE_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY       = 'KRW'
            AND B.UNIT_CURRENCY  = 'USD'
    ) C
    WHERE PRICE > 0;

    COMMIT;

    --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => 'GT_F020_FUTURE_PRICE_TEMP2',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE
    );

    -- =====================================================================================
    -- STEP 2: MERGE INTO SCM_MST_FUTURE_PRICE
    -- =====================================================================================
    MERGE INTO SCM_MST_FUTURE_PRICE A
    USING GT_F020_FUTURE_PRICE_TEMP2 B
    ON (    A.DIVISION_ID   = B.DIVISION_ID
        AND A.PROJECT_CODE  = B.PROJECT_CODE
        AND A.SCM_SITE_ID   = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
        AND A.ITEM_ID       = B.ITEM_ID
        AND A.YYYYMMDD      = B.YYYYMMDD
        AND A.CURRENCY      = B.CURRENCY
        AND A.MEASURE       = B.MEASURE
        AND A.DOM_EXP       = B.DOM_EXP
        AND A.FCST_TYPE     = B.FCST_TYPE
        AND A.INCOTERMS     = B.INCOTERMS
       )
    WHEN MATCHED THEN
        UPDATE SET A.PRICE            = B.PRICE,
                   A.CREATION_DATE    = SYSDATE,
                   A.LAST_UPDATED_BY  = 'SYSTEM',
                   A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE,
                DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        VALUES (NVL(B.DIVISION_ID, '-'), NVL(B.PROJECT_CODE, '-'), NVL(B.SCM_SITE_ID, '-'), NVL(B.PLANT_SITE_ID, '-'), NVL(B.ITEM_ID, '-'), NVL(B.YYYYMMDD, '-'), NVL(B.CURRENCY, '-'), NVL(B.MEASURE, '-'),
                NVL(B.DOM_EXP, '-'), NVL(B.FCST_TYPE, '-'), NVL(B.INCOTERMS, '-'), B.PRICE, B.CREATED_BY, SYSDATE, 'SYSTEM', SYSDATE,
                NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

    n_merge_count1 := SQL%ROWCOUNT;

    -- =====================================================================================
    -- STEP 3: [PJ2025-50017] #CFM_SELLING_PRICE_TEMP1 → WITH절, TEMP2 → GTT INSERT
    -- =====================================================================================
    --EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_F020_CFM_SELLING_PRICE_TEMP2
    (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE)
    WITH CFM_SELLING_PRICE_TEMP1 AS (
        SELECT /*+ FULL(F) PARALLEL(F,4) */
               DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE
        FROM   DM_PLN_CFM_SELLING_PRICE F
        WHERE  DIVISION_ID = P_DIVISION_ID
        AND    YYYYMMDD   >= v_cutoff_yyyymmdd  -- 당주 월요일이후 데이터만 대상으로함
        AND    MEASURE     = 'LOC'
    )
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, ROUND(PRICE, 3) AS PRICE, CREATED_BY, CREATION_DATE
    FROM (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'KRW'
                    WHEN A.CURRENCY = 'USD' THEN 'USD'
                    ELSE 'KRW' END                                        AS MEASURE
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN A.PRICE
                    WHEN A.CURRENCY = 'USD' THEN A.PRICE
                    ELSE A.PRICE * NVL(B.EXCHANGE_PRICE, 1) END           AS PRICE
             , A.CREATED_BY, A.CREATION_DATE
        FROM   CFM_SELLING_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY      = 'KRW'
            AND A.CURRENCY      = B.UNIT_CURRENCY

        UNION ALL

        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY
             , CASE WHEN A.CURRENCY = 'KRW' THEN 'USD'
                    WHEN A.CURRENCY = 'USD' THEN 'KRW'
                    ELSE 'USD' END                                        AS MEASURE
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , CASE WHEN A.CURRENCY = 'KRW' THEN NVL(A.PRICE / NVL(B.EXCHANGE_PRICE, 1), 0)
                    WHEN A.CURRENCY = 'USD' THEN NVL(A.PRICE * NVL(B.EXCHANGE_PRICE, 1), 0)
                    ELSE NVL(
                            (A.PRICE * NVL(
                                (SELECT DMER.EXCHANGE_PRICE
                                 FROM   DM_MST_EXCHANGE_RATE DMER
                                 WHERE  DMER.DIVISION_ID   = A.DIVISION_ID
                                 AND    DMER.YYYYMMDD      = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                 AND    DMER.UNIT_CURRENCY  = A.CURRENCY
                                 AND    DMER.CURRENCY       = 'KRW'), 1))
                            / NVL(B.EXCHANGE_PRICE, 1), 0)
               END                                                        AS PRICE
             , A.CREATED_BY, A.CREATION_DATE
        FROM   CFM_SELLING_PRICE_TEMP1 A
        LEFT OUTER JOIN DM_MST_EXCHANGE_RATE B
            ON  A.DIVISION_ID = B.DIVISION_ID
            AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
            AND B.CURRENCY       = 'KRW'
            AND B.UNIT_CURRENCY  = 'USD'
    ) C
    WHERE PRICE > 0;

    COMMIT;

    --EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    -- GTT 통계 수집
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME => 'SCM_MGR', TABNAME => 'GT_F020_CFM_SELLING_PRICE_TEMP2',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE
    );

    -- =====================================================================================
    -- STEP 4: [PJ2025-50017] MERGE INTO DM_PLN_CFM_SELLING_PRICE
    -- =====================================================================================
    MERGE INTO DM_PLN_CFM_SELLING_PRICE A
    USING GT_F020_CFM_SELLING_PRICE_TEMP2 B
    ON (    A.DIVISION_ID      = B.DIVISION_ID
        AND A.PROJECT_CODE     = B.PROJECT_CODE
        AND A.END_CUSTOMER     = B.END_CUSTOMER
        AND A.SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
        AND A.ITEM_ID          = B.ITEM_ID
        AND A.YYYYMMDD         = B.YYYYMMDD
        AND A.CURRENCY         = B.CURRENCY
        AND A.MEASURE          = B.MEASURE
        AND A.DOM_EXP          = B.DOM_EXP
        AND A.FCST_TYPE        = B.FCST_TYPE
        AND A.INCOTERMS        = B.INCOTERMS
       )
    WHEN MATCHED THEN
        UPDATE SET A.PRICE            = B.PRICE,
                   A.LAST_UPDATED_BY  = 'EXCHANGE_RATE',
                   A.LAST_UPDATE_DATE = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID,
                ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS,
                PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID,
                B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS,
                B.PRICE, B.CREATED_BY, B.CREATION_DATE, 'EXCHANGE_RATE', SYSDATE);

    n_merge_count2 := SQL%ROWCOUNT;
    --[PJ2025-50017] 소형 매출계획 동기화 개선 Start - DM_PLN_CFM_MKT_DEMAND_PLAN 의 MKT_AMT 업데이트

    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'merge_count1: ' || TO_CHAR(n_merge_count1) || ' / merge_count2: ' || TO_CHAR(n_merge_count2);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류.
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_merge_count1 + n_merge_count2) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        V_LOG_TYPE_E    := 'ERROR';
        V_LOG_MESSAGE_E := 'EXCEPTION';
        V_DESCRIPTION_E := '';
        V_SQL_CODE      := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG    := SQLERRM;
        V_PROC_INPUT    :=
            JSON_OBJECT(
                'P_DIVISION_ID' VALUE P_DIVISION_ID
            );
        V_BACKTRACE     := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE_E, n_log_count, V_LOG_MESSAGE_E,
                V_DESCRIPTION_E, SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION;


END PKG_DMF0020;