-- SOURCE-FRESH: SCM_MGR.PKG_DMF0020 PACKAGE BODY LAST_DDL=2026-09-11 09:32:07 FETCHED=2026-09-15 18:54 DB=ZIOUI1
SET DEFINE OFF
CREATE OR REPLACE PACKAGE BODY SCM_MGR."PKG_DMF0020"
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
    T1.YYYYMMDD >= P_START_YYYYMMDD AND T1.YYYYMMDD <= P_END_YYYYMMDD
    AND    SUBSTR(T1.YYYYMMDD, 5, 2) BETWEEN '01' AND '12'; -- 2026.08.31 AJS

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
    P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION(   /* [E20260824-PKGCONSOL] 단독 SP 호출 -> PKG 내부 호출 */ V_DIVISION_ID, V_RC1);

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
                  CASE WHEN INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0 THEN C.VISIBLE_FLAG ELSE 'N' END   /* [E20260824-DIVYN] 행별 함수(CONNECT BY 토큰화) -> 토큰 완전일치 INSTR */
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
        -- [hook#150-MAX 2026-09-07] AS-IS: INNER JOIN SCM_MST_SITE_ITEM IM
            -- [hook#150-MAX 2026-09-07] AS-IS: ON MS.DIVISION_ID = IM.DIVISION_ID
            -- [hook#150-MAX 2026-09-07] AS-IS: AND MS.SCM_SITE_ID = IM.SCM_SITE_ID
        -- 2026-09-07 hook#150: site 대표부서 = (DIVISION_ID, SCM_SITE_ID) 기준 MAX(DEPT_ID) 1건 (룰 §3-1, 사용자 지시).
        --   AS-IS 는 IM 을 DIV+SITE 단독 INNER JOIN 하여 SITE_ITEM 행수만큼 증식한다(실측: 키당 최대 3,506행).
        --   DI 는 유효부서 필터 전용(출력 DEPT_ID 는 PK grain 의 TEAM 에서 나온다)이므로
        --   MAX 를 유효부서 집합 '안에서' 취해 통과 키 집합을 보존한다(룰 §3-4 / G150-7).
        INNER JOIN (SELECT SA.DIVISION_ID, SA.SCM_SITE_ID, MAX(SA.DEPT_ID) AS DEPT_ID
                      FROM SCM_MST_SITE_ITEM SA
                     INNER JOIN SCM_MST_SSO_DEPT_INFO SD
                        ON SD.DEPT_ID  = SA.DEPT_ID
                       AND SD.VALID_YN = 'Y'
                     WHERE SA.DEPT_ID IS NOT NULL
                     GROUP BY SA.DIVISION_ID, SA.SCM_SITE_ID) IM
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
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
                -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                -- [hook#150 2026-09-06 AJS] AS-IS: FROM SCM_MST_SSO_USER_INFO B
                -- [hook#150 2026-09-06 AJS] AS-IS: INNER JOIN SCM_MST_SSO_DEPT_INFO C
                -- [hook#150 2026-09-06 AJS] AS-IS: ON B.DEPT_ID = C.DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
            -- [hook#150 2026-09-06 AJS] AS-IS: ON
            -- [hook#150 2026-09-06 AJS] AS-IS: TEAM.USER_ID = TRIM(
                -- [hook#150 2026-09-06 AJS] AS-IS: CASE
                    -- [hook#150 2026-09-06 AJS] AS-IS: WHEN INSTR(SI.OWNER, ',') > 0
                    -- [hook#150 2026-09-06 AJS] AS-IS: THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                    -- [hook#150 2026-09-06 AJS] AS-IS: ELSE SI.OWNER
                -- [hook#150 2026-09-06 AJS] AS-IS: END
            -- [hook#150 2026-09-06 AJS] AS-IS: )
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            ON TEAM.DEPT_ID = SI.DEPT_ID
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

        -- [hook#150-MAX 2026-09-07] AS-IS: INNER JOIN SCM_MST_SITE_ITEM IM
            -- [hook#150-MAX 2026-09-07] AS-IS: ON MS.DIVISION_ID = IM.DIVISION_ID
            -- [hook#150-MAX 2026-09-07] AS-IS: AND MS.SCM_SITE_ID = IM.SCM_SITE_ID
        -- 2026-09-07 hook#150: site 대표부서 = (DIVISION_ID, SCM_SITE_ID) 기준 MAX(DEPT_ID) 1건 (룰 §3-1, 사용자 지시).
        --   AS-IS 는 IM 을 DIV+SITE 단독 INNER JOIN 하여 SITE_ITEM 행수만큼 증식한다(실측: 키당 최대 3,506행).
        --   DI 는 유효부서 필터 전용(출력 DEPT_ID 는 PK grain 의 TEAM 에서 나온다)이므로
        --   MAX 를 유효부서 집합 '안에서' 취해 통과 키 집합을 보존한다(룰 §3-4 / G150-7).
        INNER JOIN (SELECT SA.DIVISION_ID, SA.SCM_SITE_ID, MAX(SA.DEPT_ID) AS DEPT_ID
                      FROM SCM_MST_SITE_ITEM SA
                     INNER JOIN SCM_MST_SSO_DEPT_INFO SD
                        ON SD.DEPT_ID  = SA.DEPT_ID
                       AND SD.VALID_YN = 'Y'
                     WHERE SA.DEPT_ID IS NOT NULL
                     GROUP BY SA.DIVISION_ID, SA.SCM_SITE_ID) IM
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
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
                -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                -- [hook#150 2026-09-06 AJS] AS-IS: FROM SCM_MST_SSO_USER_INFO B
                -- [hook#150 2026-09-06 AJS] AS-IS: INNER JOIN SCM_MST_SSO_DEPT_INFO C
                -- [hook#150 2026-09-06 AJS] AS-IS: ON B.DEPT_ID = C.DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
            -- [hook#150 2026-09-06 AJS] AS-IS: ON
            -- [hook#150 2026-09-06 AJS] AS-IS: TEAM.USER_ID = TRIM(
                -- [hook#150 2026-09-06 AJS] AS-IS: CASE
                    -- [hook#150 2026-09-06 AJS] AS-IS: WHEN INSTR(SI.OWNER, ',') > 0
                    -- [hook#150 2026-09-06 AJS] AS-IS: THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                    -- [hook#150 2026-09-06 AJS] AS-IS: ELSE SI.OWNER
                -- [hook#150 2026-09-06 AJS] AS-IS: END
            -- [hook#150 2026-09-06 AJS] AS-IS: )
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            ON TEAM.DEPT_ID = SI.DEPT_ID
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
    --    CASE WHEN INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0 THEN C.VISIBLE_FLAG ELSE 'N' END   /* [E20260824-DIVYN] 행별 함수(CONNECT BY 토큰화) -> 토큰 완전일치 INSTR */
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
             -- [hook#150 2026-09-06 AJS] AS-IS: , SCM_MST_SSO_USER_INFO B
             , SCM_MST_SSO_DEPT_INFO C
        WHERE  A.DEPT_ID     = C.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: A.OWNER = B.USER_ID AND B.DEPT_ID = C.DEPT_ID)
        -- [hook#150 2026-09-06 AJS] AS-IS: AND    B.DEPT_ID     = C.DEPT_ID
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
                 -- [hook#150 2026-09-06 AJS] AS-IS: , SCM_MST_SSO_USER_INFO B
                 , SCM_MST_SSO_DEPT_INFO C
            WHERE  A.DEPT_ID     = C.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: A.OWNER = B.USER_ID AND B.DEPT_ID = C.DEPT_ID)
            -- [hook#150 2026-09-06 AJS] AS-IS: AND    B.DEPT_ID     = C.DEPT_ID
            AND    A.DIVISION_ID = P_DIVISION_ID
            UNION ALL
            SELECT DISTINCT SEGMENT1 AS DEPT_ID
            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP
            WHERE  LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
            AND    LOOKUP.VALID_YN    = 'Y'
            AND    LOOKUP.SEGMENT3 IN (
                       SELECT DISTINCT C.DEPT_ID
                       FROM   SCM_MST_SITE_ITEM A
                            -- [hook#150 2026-09-06 AJS] AS-IS: , SCM_MST_SSO_USER_INFO B
                            , SCM_MST_SSO_DEPT_INFO C
                       WHERE  A.DEPT_ID     = C.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: A.OWNER = B.USER_ID AND B.DEPT_ID = C.DEPT_ID)
                       -- [hook#150 2026-09-06 AJS] AS-IS: AND    B.DEPT_ID     = C.DEPT_ID
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
-- SELECT TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,     '[^\^]+', 1, LEVEL)) AS ACTIVE_FLAG   --*[2026-09-07] POJ 원본    
         -- , TRIM(REGEXP_SUBSTR(P_DIVISION_ID,     '[^\^]+', 1, LEVEL)) AS DIVISION_ID   --*[2026-09-07] POJ 원본
         -- , TRIM(REGEXP_SUBSTR(P_YYYYMMDD,        '[^\^]+', 1, LEVEL)) AS YYYYMMDD   --*[2026-09-07] POJ 원본
         -- , TRIM(REGEXP_SUBSTR(P_CURRENCY,        '[^\^]+', 1, LEVEL)) AS CURRENCY   --*[2026-09-07] POJ 원본
         -- , TRIM(REGEXP_SUBSTR(P_UNIT_CURRENCY,   '[^\^]+', 1, LEVEL)) AS UNIT_CURRENCY   --*[2026-09-07] POJ 원본
         -- , TRIM(REGEXP_SUBSTR(P_EXCHANGE_PRICE,  '[^\^]+', 1, LEVEL)) AS EXCHANGE_PRICE   --*[2026-09-07] POJ 원본
         -- , TRIM(REGEXP_SUBSTR(P_CREATED_BY,      '[^\^]+', 1, LEVEL)) AS CREATED_BY   --*[2026-09-07] POJ 원본
         -- , TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY, '[^\^]+', 1, LEVEL)) AS LAST_UPDATED_BY   --*[2026-09-07] POJ 원본
    SELECT TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS ACTIVE_FLAG   --*[2026-09-07] POJ 빈값 보존형 split 적용
         , TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS DIVISION_ID   --*[2026-09-07] POJ 빈값 보존형 split 적용         
         , TRIM(REGEXP_SUBSTR(P_YYYYMMDD, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS YYYYMMDD   --*[2026-09-07] POJ 빈값 보존형 split 적용         
         , TRIM(REGEXP_SUBSTR(P_CURRENCY, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS CURRENCY   --*[2026-09-07] POJ 빈값 보존형 split 적용         
         , TRIM(REGEXP_SUBSTR(P_UNIT_CURRENCY, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS UNIT_CURRENCY   --*[2026-09-07] POJ 빈값 보존형 split 적용         
         , TRIM(REGEXP_SUBSTR(P_EXCHANGE_PRICE, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS EXCHANGE_PRICE   --*[2026-09-07] POJ 빈값 보존형 split 적용         
         , TRIM(REGEXP_SUBSTR(P_CREATED_BY, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS CREATED_BY   --*[2026-09-07] POJ 빈값 보존형 split 적용         
         , TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS LAST_UPDATED_BY   --*[2026-09-07] POJ 빈값 보존형 split 적용
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
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE != -12841 THEN
                RAISE;
            END IF;
    END;

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



    /* ============================================================================
       [E20260824-PKGCONSOL] 단독 SP -> PKG 통합 (UI별 PKG 원칙)
         편입 4본: P_DMF0020_GET_SCM_MST_FUTURE_PRICE, P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL, P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP, P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP
         원본 단독 SP 는 배선 전환 후 폐기 대상. 본문은 무수정 이식(개명만).
       ============================================================================ */

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE
(
    P_DIVISION_ID            IN  VARCHAR2,
    P_DEPT_ID                IN  VARCHAR2,   --Department
    P_END_CUSTOMER           IN  VARCHAR2,   --Endcustomer
    P_SCM_SITE_ID            IN  VARCHAR2,
    P_PLANT_SITE_ID          IN  VARCHAR2,
    P_PROJECT_CODE           IN  VARCHAR2,
    P_ITEM_ID                IN  VARCHAR2,
    P_CUSTOMER_PROJECT_CODE  IN  VARCHAR2,
    P_CUSTOMER_MODEL         IN  VARCHAR2,
    P_FROM_YYYYMMDD          IN  VARCHAR2,
    P_TO_YYYYMMDD            IN  VARCHAR2,
    P_BIZTYPE                IN  VARCHAR2,
    P_CREATED_BY             IN  VARCHAR2,
    P_USERINFO               IN  VARCHAR2,
    P_OWNER                  IN  VARCHAR2,
    P_OVER_RANGE             IN  VARCHAR2,   -- [PJ20200138]범위 초과 Flag
    P_INVALID_EXEC           IN  VARCHAR2,   -- [C20200612-000174] ESS사업부 New Model Flag
    P_VERSION_TYPE           IN  VARCHAR2,
    O_RC1                    OUT SYS_REFCURSOR,
    O_RESULT_CURSOR          OUT SYS_REFCURSOR
)
    IS
    V_PROGRAM_NAME    VARCHAR2(200 CHAR);
    V_LOG_TYPE        VARCHAR2(20 CHAR);
    N_LOG_COUNT       NUMBER := 0;
    V_LOG_MESSAGE     VARCHAR2(4000 CHAR);
    V_DESCRIPTION     VARCHAR2(4000 CHAR);
    D_EVENT_DATE      DATE;
    V_SQL_CODE        VARCHAR2(100 CHAR);
    V_SQL_ERRMSG      VARCHAR2(4000 CHAR);
    V_PROC_INPUT      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);

    --DECLARE @v_dept_id nvarchar(max)='';
    V_GROUP_ID        VARCHAR2(50 CHAR) := '';
    V_PROGRAM_ID      VARCHAR2(100 CHAR) := 'DMF0020';  -- 20180605 수정
    V_TO_YYYYMMDD2    VARCHAR2(8 CHAR);                  -- [PJ20200138] 비교 날짜
    V_VALID_YN        VARCHAR2(10 CHAR) := 'Y';          --[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공

    V_PROD            VARCHAR2(32767);
    V_NSQL            VARCHAR2(32767);

    V_EXISTS          NUMBER;

    V_FROM_YYYYMMDD   VARCHAR2(10 CHAR);
    V_TO_YYYYMMDD     VARCHAR2(10 CHAR);

    -- STRING_SPLIT용 TYPE 변수
    T_SCM_SITE       T_STR_TAB := T_STR_TAB();
    T_PLANT_SITE     T_STR_TAB := T_STR_TAB();
    T_DEPT           T_STR_TAB := T_STR_TAB();
    T_END_CUST       T_STR_TAB := T_STR_TAB();
    T_BIZTYPE        T_STR_TAB := T_STR_TAB();
    T_PROJECT        T_STR_TAB := T_STR_TAB();
    T_ITEM           T_STR_TAB := T_STR_TAB();
    T_OWNER          T_STR_TAB := T_STR_TAB();
    T_VERSION        T_STR_TAB := T_STR_TAB();

BEGIN
    -- 로깅: 프로시저명 자동 기록
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- GTT 초기화 (DML 없으므로 TRUNCATE 가능하나 다수이므로 DELETE 사용)
    DELETE FROM SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN;
    DELETE FROM SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE;
    DELETE FROM SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE_OVER;
    DELETE FROM SCM_MGR.GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V;
    DELETE FROM SCM_MGR.GT_FTPR_TMPITEM;
    DELETE FROM SCM_MGR.GT_FTPR_TMPPLANDATA;
    DELETE FROM SCM_MGR.GT_FTPR_TMPDATA;
    DELETE FROM SCM_MGR.GT_FTPR_TMPOVERRANGE;
    DELETE FROM SCM_MGR.GT_FTPR_TMPOVERRANGELIST;
    DELETE FROM SCM_MGR.GT_FTPR_TMPSALESSITEMODELALL;
    DELETE FROM SCM_MGR.GT_FTPR_TMPSALESSITEMODEL;
    DELETE FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL;
    DELETE FROM SCM_MGR.GT_FTPR_TMPOUTPUTOMISSION;
    DELETE FROM SCM_MGR.GT_FTPR_TMPOUTPUT;

    /* [E20260824-DEPTAUTH] 부서권한 1회 실현.
       종전: FN_GET_DEPT_LIST(P_CREATED_BY, DEPT_ID) 를 **행마다** 호출 -> 같은 SELECT 를 데이터 건수만큼 반복.
       P_CREATED_BY 는 실행 내내 상수라 허용 부서 집합이 고정 -> GTT 1회 적재 후 JOIN 으로 판정.
       동등성: 함수는 MA.SEGMENT3 = P_DEPT_ID 존재 여부만 본다(NULL 은 = 비교에서 항상 거짓). 전 부서 대조 불일치 0 실측. */
    DELETE FROM SCM_MGR.GT_DMF0020_DEPT_AUTH;
    INSERT INTO SCM_MGR.GT_DMF0020_DEPT_AUTH (DEPT_ID, HAS_AUTH)
    SELECT DISTINCT MA.SEGMENT3, 'Y'
      FROM ( SELECT LOOK.SEGMENT3
               FROM SCM_MGR.SCM_ADM_USER_M USR
                  , SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
              WHERE USR.DEPT_ID = LOOK.SEGMENT1
                AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                AND LOOK.VALID_YN = 'Y'
                AND UPPER(USR.USER_ID) = UPPER(P_CREATED_BY)
             UNION ALL
             SELECT DEPT_ID
               FROM SCM_MGR.SCM_ADM_USER_M
              WHERE UPPER(USER_ID) = UPPER(P_CREATED_BY) ) MA
     WHERE MA.SEGMENT3 IS NOT NULL;

    /* [E20260824-PARAMTOKEN] 조회조건 토큰을 GTT 에 1회 실현 (DMF0082 정본 방식).
       종전: 파라미터마다 PL/SQL 컬렉션(T_STR_TAB) BULK COLLECT 후 TABLE(T_xxx) 소비.
             컬렉션은 통계가 없어 옵티마이저가 카디널리티를 고정 추정(8168)한다.
       지금: GT_DMF0020_PARAM_TOKEN(PARAM_NM 인덱스) 적재 후 IN/EXISTS 소비 -> 실제 카디널리티 사용.
       ⚠ 구분자 원형 보존: 화면은 '^' 로 보내고 VERSION_TYPE 만 ',' 다.
       ⚠ UF_FX_String_SplitForIN 은 내부 TRIM (종전 TRIM(REGEXP_SUBSTR(...)) 와 동일 — 실측 확인).
       ⚠ 빈 문자열/NULL 이면 0행을 반환하므로, 종전과 같이 'ALL' 가드가 앞에서 걸러야 한다(원형 보존). */
    DELETE FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN;

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_SCM_SITE_ID, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_PLANT_SITE_ID, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_dept_id', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_DEPT_ID, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_end_customer', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_END_CUSTOMER, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_biztype', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_BIZTYPE, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_project_code', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_PROJECT_CODE, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_item_id', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_ITEM_ID, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_owner', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(P_OWNER, '^'));

    INSERT INTO SCM_MGR.GT_DMF0020_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_version_type', COLUMN_VALUE FROM TABLE(SCM_MGR.UF_FX_String_SplitForIN(UPPER(P_VERSION_TYPE), ','));

    /* [E20260824-PARAMTOKEN] GTT 동적샘플링 강제 (사용자 지시 2026-08-24) — DMF0082 정본과 동일.
       근거: 클라우드 세션은 OPTIMIZER_DYNAMIC_SAMPLING 기본 0 이라 GTT 가 무통계면 파국계획이 나온다
             (DMF0082 실증: 사내 12초 / 클라우드 16분+).
       ⚠ 사내 측정 기록(2026-08-24): 넣은 뒤 SP 내부 16.4/8.0/9.2초, 뺀 뒤 9.2/9.3/8.5초로
         **유의차를 확인하지 못했다**(같은 구간 FETCH 가 4.5~43초로 요동쳐 신호/잡음 분리 실패).
         즉 사내 기준으로는 비용 근거가 없고, 클라우드 파국계획 방지가 채택 사유다. */
    EXECUTE IMMEDIATE 'ALTER SESSION SET OPTIMIZER_DYNAMIC_SAMPLING = 2';

    /* [E20260824-INJOIN] 조회 대상 VERSION / MEASURE 를 1회 실현 후 JOIN.
       종전: 같은 IN 서브쿼리(TABLE(T_VERSION) 언네스트 · SHEET_MEASURE 조회)를 문장마다 반복 평가.
       DISTINCT 적재 -> JOIN 전환해도 행 증식 없음(SHEET_MEASURE.COLUMN_NAME 유일성 4/4 실측). */
    DELETE FROM SCM_MGR.GT_DMF0020_SEL_VERSION;
    INSERT INTO SCM_MGR.GT_DMF0020_SEL_VERSION (VERSION_NO)
    SELECT DISTINCT CASE WHEN INSTR(TOKEN, '(') = 0 THEN TOKEN
                         ELSE SUBSTR(TOKEN, 1, INSTR(TOKEN, '(') - 1) END
      FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_version_type';

    DELETE FROM SCM_MGR.GT_DMF0020_SEL_MEASURE;
    INSERT INTO SCM_MGR.GT_DMF0020_SEL_MEASURE (MEASURE)
    SELECT DISTINCT COLUMN_NAME
      FROM SCM_MGR.SCM_MST_SHEET_MEASURE
     WHERE PROGRAM_ID = 'DMF0020'
       AND SHEET_NAME = 'Sales Price'
       AND COLUMN_NAME <> 'RTF_SYS_RP'
       AND VALID_YN = 'Y';

    --IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
    --	SET @v_group_id = 'ADMIN'

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    BEGIN
        SELECT 1 INTO V_EXISTS
        FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
              AND VALID_YN = 'Y'
              AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
              AND (SEGMENT1 = P_USERINFO OR SEGMENT1 = P_CREATED_BY OR SEGMENT1 IN (SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M /* [AUTHUNION 2026-08-05] */
                               WHERE USER_ID IN (P_USERINFO, P_CREATED_BY) AND USE_YN = 'Y'))
        );
        V_GROUP_ID := 'ADMIN';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
    END;
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    V_PROD := '';

    -- [PJ20200138] 범위 초과 대상
    /*
      2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
        범위 초과 대상 처리  from ,to 정의
    */
    V_TO_YYYYMMDD2 := TO_CHAR(TO_DATE(P_TO_YYYYMMDD, 'YYYYMMDD') + 7, 'YYYYMMDD');

    IF P_OVER_RANGE = 'Y' THEN
        IF UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' THEN
            INSERT INTO SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE_OVER (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                     , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE, YYYYMMDD)
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE --2026-07-03 perf: INSERT 컬럼 목록 순서와 1:1 정렬 (ORA-12899 — AS-IS 원본도 동일 뒤섞임, 교정 승인분)
                , MAX(YYYYMMDD) AS YMD
            FROM SCM_MGR.SCM_MST_FUTURE_PRICE A
            WHERE DIVISION_ID = P_DIVISION_ID
              AND MEASURE = 'LOC'
              AND YYYYMMDD < P_FROM_YYYYMMDD
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS;
        END IF;

        IF UPPER(P_VERSION_TYPE) LIKE '%SP_%' THEN
            INSERT INTO SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE_OVER (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                     , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE, YYYYMMDD)
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE --2026-07-03 perf: INSERT 컬럼 목록 순서와 1:1 정렬 (ORA-12899 — AS-IS 원본도 동일 뒤섞임, 교정 승인분)
                , MAX(YYYYMMDD) AS YMD
            FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        JOIN SCM_MGR.GT_DMF0020_SEL_VERSION SV ON SV.VERSION_NO = A.VERSION_NO   /* [E20260824-INJOIN] IN 서브쿼리 -> JOIN */
            WHERE DIVISION_ID = P_DIVISION_ID
              AND MEASURE = 'LOC'
              AND YYYYMMDD < P_FROM_YYYYMMDD
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS;
        END IF;
    END IF;

    /*
      2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
      RTF Measure 추출, 대상 데이타 템프 처리
    */
    IF UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' THEN
        INSERT INTO SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE, YYYYMMDD, QTY)
        SELECT 'CURRENT' AS VERSION_NO
          , NULL AS CUTOFF_YYYYMMDD
          , A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID AS PLANT_SITE_ID --2026-07-02 placeholder('--',' ',NULL) 정규화: 판가('-') vs 판매계획('--',' ') 표기차로 PIVOT 행 분열(중복 2행) 방지
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , NVL(A.CURRENCY, '-') AS CURRENCY --2024.06.26 Philsu Park: Currency NULL인 경우 화면 조회 불가 현상 임시조치.
          --,A.CURRENCY
          , A.MEASURE
          , CASE WHEN SUBSTR(D.BASIS_START_DATE, 1, 6) = SUBSTR(A.YYYYMMDD, 1, 6) THEN D.BASIS_START_DATE ELSE SUBSTR(A.YYYYMMDD, 1, 6) || '01' END AS YYYYMMDD
          , SUM(A.QTY) AS QTY
        FROM SCM_MGR.DM_PLN_SALES_PLAN A
        JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
        WHERE A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND A.DIVISION_ID = P_DIVISION_ID
          AND A.MEASURE = 'RTF_SYS_RP'
        -- AND A.QTY <> 0
        GROUP BY A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID --2026-07-02 placeholder 정규화 (SELECT 와 동일식)
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , NVL(A.CURRENCY, '-') --2024.06.26 Philsu Park: Currency NULL인 경우 화면 조회 불가 현상 임시조치.
          , A.MEASURE
          , D.BASIS_START_DATE
          , SUBSTR(A.YYYYMMDD, 1, 6);

        INSERT INTO SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE, YYYYMMDD, PRICE)
        SELECT 'CURRENT' AS VERSION_NO
          , NULL AS CUTOFF_YYYYMMDD
          , A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID AS PLANT_SITE_ID --2026-07-02 placeholder('--',' ',NULL) 정규화: 판가('-') vs 판매계획('--',' ') 표기차로 PIVOT 행 분열(중복 2행) 방지
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , A.CURRENCY
          , A.MEASURE
          , A.YYYYMMDD
          , A.PRICE
        FROM SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN SCM_MGR.GT_DMF0020_SEL_MEASURE SM ON SM.MEASURE = A.MEASURE   /* [E20260824-INJOIN] IN 서브쿼리 -> JOIN */
        JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
        WHERE A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD2
          AND A.DIVISION_ID = P_DIVISION_ID
        --AND A.PRICE <> 0
        UNION ALL
        SELECT 'CURRENT' AS VERSION_NO
          , NULL AS CUTOFF_YYYYMMDD
          , A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID AS PLANT_SITE_ID --2026-07-02 placeholder('--',' ',NULL) 정규화: 판가('-') vs 판매계획('--',' ') 표기차로 PIVOT 행 분열(중복 2행) 방지
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , A.CURRENCY
          , A.MEASURE
          , A.YYYYMMDD
          , A.PRICE
        FROM SCM_MGR.SCM_MST_FUTURE_PRICE A
        JOIN SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE_OVER B
             ON A.DIVISION_ID = B.DIVISION_ID
            AND A.PROJECT_CODE = B.PROJECT_CODE
            AND A.SCM_SITE_ID = B.SCM_SITE_ID
            AND A.PLANT_SITE_ID = B.PLANT_SITE_ID --2026-07-02 placeholder 정규화 (GTT 는 정규화 적재됨)
            AND A.ITEM_ID = B.ITEM_ID
            AND A.CURRENCY = B.CURRENCY
            AND A.MEASURE = B.MEASURE
            AND A.DOM_EXP = B.DOM_EXP
            AND A.FCST_TYPE = B.FCST_TYPE
            AND A.INCOTERMS = B.INCOTERMS
            AND A.YYYYMMDD = B.YYYYMMDD
            AND P_OVER_RANGE = 'Y';
    END IF;

    IF UPPER(P_VERSION_TYPE) LIKE '%SP_%' THEN
        INSERT INTO SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE, YYYYMMDD, QTY)
        SELECT CASE WHEN P_DIVISION_ID = '82' AND E.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ') (NO PLAN)'
                    WHEN P_DIVISION_ID = '82' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ')'
                    ELSE A.VERSION_NO END AS VERSION_NO
          , A.CUTOFF_YYYYMMDD
          , A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID AS PLANT_SITE_ID --2026-07-02 placeholder('--',' ',NULL) 정규화: 판가('-') vs 판매계획('--',' ') 표기차로 PIVOT 행 분열(중복 2행) 방지
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , NVL(A.CURRENCY, '-') AS CURRENCY --2024.06.26 Philsu Park: Currency NULL인 경우 화면 조회 불가 현상 임시조치.
          --,A.CURRENCY
          , A.MEASURE
          , CASE WHEN SUBSTR(F.BASIS_START_DATE, 1, 6) = SUBSTR(A.YYYYMMDD, 1, 6) THEN F.BASIS_START_DATE ELSE SUBSTR(A.YYYYMMDD, 1, 6) || '01' END AS YYYYMMDD
          , SUM(A.QTY) AS QTY
        FROM SCM_MGR.DM_PLN_SALES_PLAN_C A
        JOIN SCM_MGR.GT_DMF0020_SEL_VERSION SV ON SV.VERSION_NO = A.VERSION_NO   /* [E20260824-INJOIN] IN 서브쿼리 -> JOIN */
        JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M F ON A.YYYYMMDD = F.BASIS_YYYYMMDD
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD
        LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN E ON A.DIVISION_ID = E.DIVISION_ID
          AND D.BASIS_START_DATE = E.PLAN_START_YYYYMMDD --[E20230130-000233]
        WHERE A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
          AND A.DIVISION_ID = P_DIVISION_ID
          AND A.MEASURE = 'RTF_SYS_RP'
          -- AND A.QTY <> 0
        GROUP BY (CASE WHEN P_DIVISION_ID = '82' AND E.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ') (NO PLAN)'
                       WHEN P_DIVISION_ID = '82' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ')'
                       ELSE A.VERSION_NO END)
          , A.CUTOFF_YYYYMMDD
          , A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID --2026-07-02 placeholder 정규화 (SELECT 와 동일식)
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , NVL(A.CURRENCY, '-') --2024.06.26 Philsu Park: Currency NULL인 경우 화면 조회 불가 현상 임시조치.
          , A.MEASURE
          , F.BASIS_START_DATE
          , SUBSTR(A.YYYYMMDD, 1, 6);

        INSERT INTO SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
              , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, MEASURE, YYYYMMDD, PRICE)
        SELECT CASE WHEN P_DIVISION_ID = '82' AND E.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ') (NO PLAN)'
                    WHEN P_DIVISION_ID = '82' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ')'
                    ELSE A.VERSION_NO END AS VERSION_NO
          , A.CUTOFF_YYYYMMDD
          , A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID AS PLANT_SITE_ID --2026-07-02 placeholder('--',' ',NULL) 정규화: 판가('-') vs 판매계획('--',' ') 표기차로 PIVOT 행 분열(중복 2행) 방지
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , A.CURRENCY
          , A.MEASURE
          , A.YYYYMMDD
          , A.PRICE
        FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        JOIN SCM_MGR.GT_DMF0020_SEL_VERSION SV ON SV.VERSION_NO = A.VERSION_NO   /* [E20260824-INJOIN] IN 서브쿼리 -> JOIN */
        JOIN SCM_MGR.GT_DMF0020_SEL_MEASURE SM ON SM.MEASURE = A.MEASURE   /* [E20260824-INJOIN] IN 서브쿼리 -> JOIN */
        JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD
        LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN E ON A.DIVISION_ID = E.DIVISION_ID
          AND D.BASIS_START_DATE = E.PLAN_START_YYYYMMDD --[E20230130-000233]
        WHERE A.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD2
          AND A.DIVISION_ID = P_DIVISION_ID
        UNION ALL
        SELECT CASE WHEN P_DIVISION_ID = '82' AND E.DM_RTF_YN = 'N' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ') (NO PLAN)'
                    WHEN P_DIVISION_ID = '82' THEN A.VERSION_NO || '(' || D.WEEK_NAME || ')'
                    ELSE A.VERSION_NO END AS VERSION_NO
          , A.CUTOFF_YYYYMMDD
          , A.DIVISION_ID
          , A.PROJECT_CODE
          , A.SCM_SITE_ID
      , A.PLANT_SITE_ID AS PLANT_SITE_ID --2026-07-02 placeholder('--',' ',NULL) 정규화: 판가('-') vs 판매계획('--',' ') 표기차로 PIVOT 행 분열(중복 2행) 방지
          , A.ITEM_ID
          , A.INCOTERMS
          , A.DOM_EXP
          , A.FCST_TYPE
          , A.CURRENCY
          , A.MEASURE
          , A.YYYYMMDD
          , A.PRICE
        FROM SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        JOIN SCM_MGR.GT_DMF0020_SEL_VERSION SV ON SV.VERSION_NO = A.VERSION_NO   /* [E20260824-INJOIN] IN 서브쿼리 -> JOIN */
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD
        LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN E ON A.DIVISION_ID = E.DIVISION_ID
          AND D.BASIS_START_DATE = E.PLAN_START_YYYYMMDD --[E20230130-000233]
        JOIN SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE_OVER B
             ON A.DIVISION_ID = B.DIVISION_ID
            AND A.PROJECT_CODE = B.PROJECT_CODE
            AND A.SCM_SITE_ID = B.SCM_SITE_ID
            AND A.PLANT_SITE_ID = B.PLANT_SITE_ID --2026-07-02 placeholder 정규화 (GTT 는 정규화 적재됨)
            AND A.ITEM_ID = B.ITEM_ID
            AND A.CURRENCY = B.CURRENCY
            AND A.MEASURE = B.MEASURE
            AND A.DOM_EXP = B.DOM_EXP
            AND A.FCST_TYPE = B.FCST_TYPE
            AND A.INCOTERMS = B.INCOTERMS
            AND A.YYYYMMDD = B.YYYYMMDD
            AND P_OVER_RANGE = 'Y'
        WHERE 1=1;
    END IF;

    --SM 추가내용 20240627
    -- 아래서부터는 CURRENCY를 사용해야 하므로 여기서 UPDATE 한다.
    -- ORA-38104 방지: ON절 컬럼(CURRENCY) UPDATE 불가 → 상관 서브쿼리 UPDATE
    UPDATE SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN A
    SET A.CURRENCY = NVL((
        SELECT B.CURRENCY
        FROM SCM_MGR.SCM_MST_SITE_ITEM B
        WHERE A.DIVISION_ID  = B.DIVISION_ID
          AND A.PROJECT_CODE = B.PROJECT_CODE
          AND A.SCM_SITE_ID  = B.SCM_SITE_ID
          AND A.ITEM_ID      = B.ITEM_ID
          AND ROWNUM = 1
    ), A.CURRENCY)
    WHERE NVL(A.CURRENCY, '-') = '-';

    -- [PJ20200138] 범위 초과 대상
    IF P_OVER_RANGE = 'Y' THEN
        V_TO_YYYYMMDD2 := TO_CHAR(TO_DATE(P_TO_YYYYMMDD, 'YYYYMMDD') + 7, 'YYYYMMDD');

        INSERT INTO SCM_MGR.GT_FTPR_TMPOVERRANGE (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD)
        SELECT DISTINCT AA.DIVISION_ID, AA.PROJECT_CODE, AA.SCM_SITE_ID, AA.PLANT_SITE_ID, AA.ITEM_ID, AA.CURRENCY, AA.MEASURE, AA.DOM_EXP, AA.FCST_TYPE, AA.INCOTERMS, AA.YYYYMMDD
        FROM
            -- 기준데이터
            (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
                , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS RN --2026-07-03 perf: 예약어 별칭 ROWNUM → RN (ORA-00923)
            FROM SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE A
            WHERE DIVISION_ID = P_DIVISION_ID
              AND MEASURE = 'LOC'
              AND YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
            ) AA
            -- 비교용 데이터 ( 다음주 )
        LEFT OUTER JOIN
            (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
                , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS RN --2026-07-03 perf: 예약어 별칭 ROWNUM → RN (ORA-00923)
            FROM SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE A
            WHERE DIVISION_ID = P_DIVISION_ID
              AND MEASURE = 'LOC'
              AND YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND V_TO_YYYYMMDD2
            ) BB ON AA.DIVISION_ID = BB.DIVISION_ID
                AND AA.PROJECT_CODE = BB.PROJECT_CODE
                AND AA.SCM_SITE_ID = BB.SCM_SITE_ID
                AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID
                AND AA.ITEM_ID = BB.ITEM_ID
                AND AA.CURRENCY = BB.CURRENCY
                AND AA.MEASURE = BB.MEASURE
                AND AA.DOM_EXP = BB.DOM_EXP
                AND AA.FCST_TYPE = BB.FCST_TYPE
                AND AA.INCOTERMS = BB.INCOTERMS
                AND AA.RN = BB.RN + 1
            -- 비교용 데이터 ( 직전주차-없으면 마지막 주차 )
        LEFT JOIN
            (
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
                , A.YYYYMMDD
            FROM SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE A
            JOIN SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE_OVER B
                 ON A.DIVISION_ID = B.DIVISION_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                AND A.ITEM_ID = B.ITEM_ID
                AND A.CURRENCY = B.CURRENCY
                AND A.MEASURE = B.MEASURE
                AND A.DOM_EXP = B.DOM_EXP
                AND A.FCST_TYPE = B.FCST_TYPE
                AND A.INCOTERMS = B.INCOTERMS
                AND A.YYYYMMDD = B.YYYYMMDD
            ) CC ON AA.DIVISION_ID = CC.DIVISION_ID
                AND AA.PROJECT_CODE = CC.PROJECT_CODE
                AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
                AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID
                AND AA.ITEM_ID = CC.ITEM_ID
                AND AA.CURRENCY = CC.CURRENCY
                AND AA.MEASURE = CC.MEASURE
                AND AA.DOM_EXP = CC.DOM_EXP
                AND AA.FCST_TYPE = CC.FCST_TYPE
                AND AA.INCOTERMS = CC.INCOTERMS
                AND AA.RN = 1
        JOIN (SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS LIMIT_VAL
                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE VALID_YN = 'Y'
                  AND LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE') L
        ON AA.DIVISION_ID = L.DIVISION_ID
        WHERE CASE WHEN AA.RN = 1  AND (AA.PRICE * TO_NUMBER(L.LIMIT_VAL)) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
                   WHEN AA.RN <> 1 AND (BB.PRICE * TO_NUMBER(L.LIMIT_VAL)) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
                   ELSE 'N'
              END = 'Y'
        UNION ALL
        SELECT DISTINCT AA2.DIVISION_ID, AA2.PROJECT_CODE, AA2.SCM_SITE_ID, AA2.PLANT_SITE_ID, AA2.ITEM_ID, AA2.CURRENCY, AA2.MEASURE, AA2.DOM_EXP
             , AA2.FCST_TYPE, AA2.INCOTERMS, AA2.YYYYMMDD
        FROM SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN AA2;

        -- PIVOT → LISTAGG 로 COL_LIST 생성
        INSERT INTO SCM_MGR.GT_FTPR_TMPOVERRANGELIST (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS, COL_LIST)
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
             , LISTAGG('W_' || YYYYMMDD, ',') WITHIN GROUP (ORDER BY YYYYMMDD) AS COL_LIST
        FROM (
            SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD
            FROM SCM_MGR.GT_FTPR_TMPOVERRANGE
        )
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS;
    END IF;

    --[C20200506-000201] 속도개선 임시테이블 #tmpItem, #tmpPlanData 추가

    --2026-07-03 perf: GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V 적재는 유일 사용처인 ESS 분기(P_DIVISION_ID='82' AND P_INVALID_EXEC='Z')로 이동
    --                 (일반 경로에서 ITEM 마스터 이중 적재 제거 — TMPITEM 은 아래에서 SCM_MST_ITEM_SN 직접 조회)

    IF P_DIVISION_ID <> '40' OR P_BIZTYPE = 'ALL' THEN
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
        INSERT INTO SCM_MGR.GT_FTPR_TMPITEM
        SELECT T1.DIVISION_ID
             , T1.ITEM_ID
             , MAX(T1.ITEM_NAME) AS ITEM_NAME
             , MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME) AS NICK_NAME
             , '-' AS FORECAST_INFO_BIZ_TYPE
             , MAX(T1.ITEM_TYPE) AS ITEM_TYPE
        FROM SCM_MGR.SCM_MST_ITEM_SN T1 --2026-07-03 perf: 중간 GTT 제거 (기존 ORI_V 적재 필터와 동일 WHERE)
        WHERE T1.DIVISION_ID = P_DIVISION_ID
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
    ELSE
        --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
        INSERT INTO SCM_MGR.GT_FTPR_TMPITEM
        SELECT T1.DIVISION_ID
             , T1.ITEM_ID
             , MAX(T1.ITEM_NAME) AS ITEM_NAME
             , MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME) AS NICK_NAME
--             , CAST(NULL AS VARCHAR2(10 CHAR)) AS FORECAST_INFO_BIZ_TYPE 
             , MAX(T2.FORECAST_INFO_BIZ_TYPE) 	AS FORECAST_INFO_BIZ_TYPE	--*[2026-09-09] POJ AS-IS누락로직 추가
             , MAX(T1.ITEM_TYPE) AS ITEM_TYPE
        FROM SCM_MGR.SCM_MST_ITEM_SN T1 --2026-07-03 perf: 중간 GTT 제거
        INNER JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID					--*[2026-09-09] POJ AS-IS누락로직 추가
				          , MAX(FORECAST_INFO_BIZ_TYPE) 		AS FORECAST_INFO_BIZ_TYPE	--*[2026-09-09] POJ AS-IS누락로직 추가
					 FROM   SCM_MGR.SCM_MST_ITEM_SN T2										--*[2026-09-09] POJ AS-IS누락로직 추가
					 GROUP  BY T2.DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)						--*[2026-09-09] POJ AS-IS누락로직 추가
			 	   ) T2																		--*[2026-09-09] POJ AS-IS누락로직 추가
		ON   T1.DIVISION_ID = T2.DIVISION_ID												--*[2026-09-09] POJ AS-IS누락로직 추가
		AND  SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID											--*[2026-09-09] POJ AS-IS누락로직 추가
        WHERE T1.DIVISION_ID = P_DIVISION_ID
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
    END IF;

    /*
      2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
        TEMP 처리
    */
    /* 2024/03/05   kcw3408		        DM 프로시저 속도개선(대상건 한정후 작업)  */
    INSERT INTO SCM_MGR.GT_FTPR_TMPPLANDATA (DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP)
    SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP
    FROM (
        SELECT DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP
        FROM SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE
        WHERE YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
        UNION ALL
        SELECT DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP
        FROM SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN
        WHERE YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    ) A
    WHERE 1 = 1
      AND (P_SCM_SITE_ID = 'ALL' OR A.SCM_SITE_ID IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id'))
      AND (P_PLANT_SITE_ID = 'ALL' OR A.PLANT_SITE_ID IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id'))
      -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (START)
      AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                  WHERE A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y')
      AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_ITEM B
                  WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y')
      -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (END)
    GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.PROJECT_CODE, A.ITEM_ID, A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP;

    -- #tmpData 생성
    INSERT INTO SCM_MGR.GT_FTPR_TMPDATA (DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION,
        END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS, PROJECT_OWNER, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME,
        INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP, AUTHORITY_YN, NICK_NAME)
    WITH NEW_DEPT_ID_TBL AS (
        SELECT DISTINCT T1.DIVISION_ID, T1.SCM_SITE_ID, MAX(T2.DEPT_ID) DEPT_ID
        FROM SCM_MGR.SCM_MST_SITE T1
            INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM T2 ON T1.DIVISION_ID = T2.DIVISION_ID
            AND T1.SCM_SITE_ID = T2.SCM_SITE_ID
        GROUP BY T1.DIVISION_ID, T1.SCM_SITE_ID
    )
    SELECT
       A.DIVISION_ID,
       B.DIVISION_NAME,
       DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
       --[PJ2024-50461] Team Mapping
       PJT.DEPT_ID,
       A.SCM_SITE_ID,
       A.PLANT_SITE_ID,
       C.SITE_DESCRIPTION,
       NVL(C.END_CUSTOMER, '-') AS END_CUSTOMER,
       A.PROJECT_CODE,
       PJT.PROJECT_NAME,
       PJT.BIZ_TYPE AS BIZ_TYPE_NAME,
       PJT.PROJECT_STATUS,
       PJT.PROJECT_OWNER,
       A.ITEM_ID,
       ITEM.ITEM_CLASS_NAME,
       NVL(ITEM.ITEM_NAME, '-') AS ITEM_NAME,
       A.INCOTERMS,
       A.CURRENCY,
       A.FCST_TYPE,
       A.DOM_EXP,
       CASE WHEN (V_GROUP_ID = 'ADMIN' OR DA.DEPT_ID IS NOT NULL) THEN 'Y' ELSE 'N' END /* [E20260824-DEPTAUTH] */ AS AUTHORITY_YN,
       ITEM.NICK_NAME --20180711
    FROM SCM_MGR.GT_FTPR_TMPPLANDATA A
    JOIN SCM_MGR.SCM_MST_DIVISION B
        ON A.DIVISION_ID = B.DIVISION_ID AND B.VALID_YN = 'Y'
    JOIN SCM_MGR.SCM_MST_SITE C
        ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.SITE_TYPE = 'SALES' AND C.VALID_YN = 'Y'
    LEFT JOIN SCM_MGR.SCM_MST_SITE D
        ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND C.SITE_TYPE = 'PLANT' AND D.VALID_YN = 'Y'
    LEFT JOIN NEW_DEPT_ID_TBL D1
        ON D.DIVISION_ID = D1.DIVISION_ID
        AND D.SCM_SITE_ID = D1.SCM_SITE_ID
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
        -- ON C.DEPT_ID = TEAM.DEPT_ID AND TEAM.VALID_YN = 'Y'
        ON D1.DEPT_ID = TEAM.DEPT_ID AND TEAM.VALID_YN = 'Y'
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DEPRTMENT
        ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID AND DEPRTMENT.VALID_YN = 'Y'
    JOIN SCM_MGR.GT_FTPR_TMPITEM ITEM
        ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.ITEM_ID = ITEM.ITEM_ID
    LEFT JOIN (
        SELECT SI.DIVISION_ID
            , SI.PROJECT_CODE
            , CASE WHEN SI.DIVISION_ID = '40' THEN '-' ELSE MPJT.PROJECT_NAME END AS PROJECT_NAME
            , SI.OWNER AS PROJECT_OWNER
            , CASE WHEN SI.DIVISION_ID = '40' THEN '-' ELSE MPJT.PROJECT_STATUS END AS PROJECT_STATUS
            , CASE WHEN SI.DIVISION_ID = '40' THEN '-' ELSE MPJT.BIZ_TYPE END AS BIZ_TYPE
            , SI.SCM_SITE_ID
            , SI.ITEM_ID
            , SI.DEPT_ID  -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기) (AS-IS: SU.DEPT_ID)
        FROM SCM_MGR.SCM_MST_SITE_ITEM SI
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO SU
            -- [hook#150 2026-09-06 AJS] AS-IS: ON SU.USER_ID = TRIM(CASE WHEN INSTR(SI.OWNER, ',') > 0 THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1) ELSE SI.OWNER END)
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT MPJT
            ON SI.DIVISION_ID = MPJT.DIVISION_ID AND SI.PROJECT_CODE = MPJT.PROJECT_CODE
    ) PJT
        ON A.DIVISION_ID = PJT.DIVISION_ID AND A.PROJECT_CODE = PJT.PROJECT_CODE
        AND PJT.SCM_SITE_ID = A.SCM_SITE_ID AND PJT.ITEM_ID = A.ITEM_ID
    LEFT JOIN SCM_MGR.GT_DMF0020_DEPT_AUTH DA   /* [E20260824-DEPTAUTH] DEPT_ID DISTINCT 적재 -> 행 증식 없음 */
        ON DA.DEPT_ID = PJT.DEPT_ID
    LEFT JOIN (SELECT * FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y') SITE_ITEM
        ON SITE_ITEM.DIVISION_ID = A.DIVISION_ID AND SITE_ITEM.PROJECT_CODE = A.PROJECT_CODE
        AND SITE_ITEM.SCM_SITE_ID = A.SCM_SITE_ID AND SITE_ITEM.ITEM_ID = A.ITEM_ID
    -------------------------- Project --------------2018/07/30  Son Young Suk---------------------
    WHERE 1 = 1
      AND (P_PROJECT_CODE IS NULL OR P_PROJECT_CODE = '-' OR P_PROJECT_CODE = 'ALL'
           OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (UPPER(PJT.PROJECT_CODE) LIKE '%' || UPPER(T.TOKEN) || '%'   /* [E20260824-TOKENPAREN] */
                         OR UPPER(PJT.PROJECT_NAME) LIKE '%' || UPPER(T.TOKEN) || '%')))  --260820 조회조건 Upper 처리
    ------------ 20180806 -------------------------------------------------------------------
      AND (P_OWNER IS NULL OR P_OWNER = '-' OR P_OWNER = 'ALL'
           OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_ITEM X2
                      WHERE X2.DIVISION_ID = P_DIVISION_ID
                        AND NVL(SITE_ITEM.OWNER, 'xxxx') = X2.OWNER
                        AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T3 WHERE T3.PARAM_NM = 'p_owner' AND ( SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '1') LIKE '%' || T3.TOKEN || '%'   /* [E20260824-TOKENPAREN] OR 그룹 괄호 누락 정정 */
                                       OR X2.OWNER LIKE '%' || T3.TOKEN || '%'
                                       OR SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '2') LIKE '%' || T3.TOKEN || '%'))))
    -----------------------------------------------------------------------------------------------
      AND (P_DEPT_ID = 'ALL' OR PJT.DEPT_ID IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_dept_id'))
      AND (P_END_CUSTOMER = 'ALL'
           OR NVL(CASE WHEN P_DIVISION_ID <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END, '-')
              IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_end_customer'))
      AND (P_BIZTYPE = 'ALL'  --20180822
           OR NVL(CASE WHEN P_DIVISION_ID <> '40' THEN PJT.BIZ_TYPE ELSE ITEM.FORECAST_INFO_BIZ_TYPE END, '-')
              IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_biztype'))
    GROUP BY
        A.DIVISION_ID, B.DIVISION_NAME, DEPRTMENT.DEPT_ID, TEAM.DEPT_ID, PJT.DEPT_ID,
        A.SCM_SITE_ID, A.PLANT_SITE_ID, C.SITE_DESCRIPTION, NVL(C.END_CUSTOMER, '-'),
        A.PROJECT_CODE, PJT.PROJECT_NAME, PJT.BIZ_TYPE, PJT.PROJECT_STATUS, PJT.PROJECT_OWNER,
        A.ITEM_ID, ITEM.ITEM_CLASS_NAME, NVL(ITEM.ITEM_NAME, '-'),
        A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.CURRENCY,
        CASE WHEN (V_GROUP_ID = 'ADMIN' OR DA.DEPT_ID IS NOT NULL) THEN 'Y' ELSE 'N' END /* [E20260824-DEPTAUTH] */,
        ITEM.NICK_NAME;

    -- 1. 실데이타와 조인
    -- [PJ20200138] 범위 초과 대상
    IF P_OVER_RANGE = 'Y' THEN
        --[E20251113-001347]_중복 데이터 발생건으로 데이터 모두 조회한 후 GROUP BY하여 데이터 중복건 제거 (START)
        -- 현상: ITEM_ID, NICK_NAME 조회 시 LIKE로 조회하면서 중복 데이터 발생건
        -- 조치내역: 모두 데이터를 조회한 후 중복 제거 로직 추가 및 소스정리
        INSERT INTO SCM_MGR.GT_FTPR_TMPOUTPUTALL
        SELECT T.DIVISION_ID, T.DIVISION_NAME, T.UPPER_DEPT_ID, T.DEPT_ID, T.SCM_SITE_ID, T.PLANT_SITE_ID, T.SITE_DESCRIPTION, T.END_CUSTOMER, T.END_CUSTOMER40, T.PROJECT_CODE
             , T.PROJECT_NAME, T.BIZ_TYPE_NAME, T.PROJECT_STATUS, T.ITEM_ID, T.ITEM_CLASS_NAME, T.ITEM_NAME, T.INCOTERMS, T.CURRENCY, T.FCST_TYPE, T.DOM_EXP
             , T.MEASURE, T.DISPLAY_SEQ, T.AUTHORITY_YN, T.YYYYMMDD, T.PRICE, T.NICK_NAME, T.COL_LIST
        FROM (
            SELECT A.DIVISION_ID, A.DIVISION_NAME, A.UPPER_DEPT_ID, A.DEPT_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.SITE_DESCRIPTION, A.END_CUSTOMER, A.PROJECT_CODE AS END_CUSTOMER40, A.PROJECT_CODE
                 , A.PROJECT_NAME, A.BIZ_TYPE_NAME, A.PROJECT_STATUS, A.ITEM_ID, A.ITEM_CLASS_NAME, A.ITEM_NAME, A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP
                 , B.MEASURE, MEASURE.DISPLAY_SEQ, A.AUTHORITY_YN, 'W_' || B.YYYYMMDD AS YYYYMMDD, NVL(B.PRICE, 0) AS PRICE, A.NICK_NAME, C.COL_LIST
            FROM SCM_MGR.GT_FTPR_TMPDATA A
            JOIN SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE B
                ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.CURRENCY = B.CURRENCY
                AND A.DOM_EXP = B.DOM_EXP AND A.FCST_TYPE = B.FCST_TYPE AND A.INCOTERMS = B.INCOTERMS
            JOIN SCM_MGR.GT_FTPR_TMPOVERRANGELIST C
                ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID
                AND A.PLANT_SITE_ID = C.PLANT_SITE_ID AND A.ITEM_ID = C.ITEM_ID AND A.CURRENCY = C.CURRENCY
                AND A.DOM_EXP = C.DOM_EXP AND A.FCST_TYPE = C.FCST_TYPE AND A.INCOTERMS = C.INCOTERMS
            -------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
            JOIN (SELECT COLUMN_NAME AS LOOKUP_CODE, COLUMN_LABEL_NAME AS DESCRIPTION, SORT_ORDER_NO AS DISPLAY_SEQ
                  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                  WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price' AND VALID_YN = 'Y'/*[PJ2024-50611]*/) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
            WHERE B.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD --[PJ20200138] 속도개선
              AND (P_ITEM_ID IS NULL OR P_ITEM_ID = '-' OR P_ITEM_ID = 'ALL'
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_item_id' AND (UPPER(A.ITEM_ID) LIKE '%' || UPPER(T.TOKEN) || '%' OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(T.TOKEN) || '%'))) --260820 조회조건 Upper 처리   /* [E20260824-TOKENPAREN] (PARAM_NM AND A) OR B 로 해석되어 B 가 공유 GTT 전체 토큰과 매칭되던 결함 */
            UNION ALL
            /*  2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
                SALES_PLAN 처리	*/
            SELECT A.DIVISION_ID, A.DIVISION_NAME, A.UPPER_DEPT_ID, A.DEPT_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.SITE_DESCRIPTION, A.END_CUSTOMER, A.PROJECT_CODE AS END_CUSTOMER40, A.PROJECT_CODE
                 , A.PROJECT_NAME, A.BIZ_TYPE_NAME, A.PROJECT_STATUS, A.ITEM_ID, A.ITEM_CLASS_NAME, A.ITEM_NAME, A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP
                 , B.MEASURE, MEASURE.DISPLAY_SEQ, A.AUTHORITY_YN, 'W_' || B.YYYYMMDD AS YYYYMMDD, NVL(B.QTY, 0) AS PRICE, A.NICK_NAME, C.COL_LIST
            FROM SCM_MGR.GT_FTPR_TMPDATA A
            JOIN SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN B
                ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.CURRENCY = B.CURRENCY
                AND A.DOM_EXP = B.DOM_EXP AND A.FCST_TYPE = B.FCST_TYPE AND A.INCOTERMS = B.INCOTERMS
            JOIN SCM_MGR.GT_FTPR_TMPOVERRANGELIST C
                ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID
                AND A.PLANT_SITE_ID = C.PLANT_SITE_ID AND A.ITEM_ID = C.ITEM_ID AND A.CURRENCY = C.CURRENCY
                AND A.DOM_EXP = C.DOM_EXP AND A.FCST_TYPE = C.FCST_TYPE AND A.INCOTERMS = C.INCOTERMS
            JOIN (SELECT COLUMN_NAME AS LOOKUP_CODE, COLUMN_LABEL_NAME AS DESCRIPTION, SORT_ORDER_NO AS DISPLAY_SEQ
                  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                  WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price' AND VALID_YN = 'Y' /*[PJ2024-50611]*/) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
            WHERE B.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD /*[PJ20200138] 속도개선*/
              AND (P_ITEM_ID IS NULL OR P_ITEM_ID = '-' OR P_ITEM_ID = 'ALL'
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_item_id' AND (A.ITEM_ID LIKE '%' || T.TOKEN || '%' OR A.NICK_NAME LIKE '%' || T.TOKEN || '%')))   /* [E20260824-TOKENPAREN] (PARAM_NM AND A) OR B 로 해석되어 B 가 공유 GTT 전체 토큰과 매칭되던 결함 */
        ) T
        GROUP BY T.DIVISION_ID, T.DIVISION_NAME, T.UPPER_DEPT_ID, T.DEPT_ID, T.SCM_SITE_ID, T.PLANT_SITE_ID, T.SITE_DESCRIPTION, T.END_CUSTOMER, T.END_CUSTOMER40, T.PROJECT_CODE
               , T.PROJECT_NAME, T.BIZ_TYPE_NAME, T.PROJECT_STATUS, T.ITEM_ID, T.ITEM_CLASS_NAME, T.ITEM_NAME, T.INCOTERMS, T.CURRENCY, T.FCST_TYPE, T.DOM_EXP
               , T.MEASURE, T.DISPLAY_SEQ, T.AUTHORITY_YN, T.YYYYMMDD, T.PRICE, T.NICK_NAME, T.COL_LIST;
        --[E20251113-001347]_중복 데이터 발생건으로 데이터 모두 조회한 후 GROUP BY하여 데이터 중복건 제거 (END)
    ELSE
        --[E20251113-001347]_중복 데이터 발생건으로 데이터 모두 조회한 후 GROUP BY하여 데이터 중복건 제거 (START)
        INSERT INTO SCM_MGR.GT_FTPR_TMPOUTPUTALL
        SELECT T.DIVISION_ID, T.DIVISION_NAME, T.UPPER_DEPT_ID, T.DEPT_ID, T.SCM_SITE_ID, T.PLANT_SITE_ID, T.SITE_DESCRIPTION, T.END_CUSTOMER, T.END_CUSTOMER40, T.PROJECT_CODE
             , T.PROJECT_NAME, T.BIZ_TYPE_NAME, T.PROJECT_STATUS, T.ITEM_ID, T.ITEM_CLASS_NAME, T.ITEM_NAME, T.INCOTERMS, T.CURRENCY, T.FCST_TYPE, T.DOM_EXP
             , T.MEASURE, T.DISPLAY_SEQ, T.AUTHORITY_YN, T.YYYYMMDD, T.PRICE, T.NICK_NAME, T.COL_LIST
        FROM (
            SELECT A.DIVISION_ID, A.DIVISION_NAME, A.UPPER_DEPT_ID, A.DEPT_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.SITE_DESCRIPTION, A.END_CUSTOMER, A.PROJECT_CODE AS END_CUSTOMER40, A.PROJECT_CODE
                 , A.PROJECT_NAME, A.BIZ_TYPE_NAME, A.PROJECT_STATUS, A.ITEM_ID, A.ITEM_CLASS_NAME, A.ITEM_NAME, A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP
                 , B.MEASURE, MEASURE.DISPLAY_SEQ, A.AUTHORITY_YN, 'W_' || B.YYYYMMDD AS YYYYMMDD, NVL(B.PRICE, 0) AS PRICE, A.NICK_NAME, '-' AS COL_LIST
            FROM SCM_MGR.GT_FTPR_TMPDATA A
            JOIN SCM_MGR.GT_FTPR_SCM_MST_FUTURE_PRICE B
                ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.CURRENCY = B.CURRENCY
                AND A.DOM_EXP = B.DOM_EXP AND A.FCST_TYPE = B.FCST_TYPE AND A.INCOTERMS = B.INCOTERMS
            JOIN (SELECT COLUMN_NAME AS LOOKUP_CODE, COLUMN_LABEL_NAME AS DESCRIPTION, SORT_ORDER_NO AS DISPLAY_SEQ
                  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                  WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price' AND VALID_YN = 'Y' /*[PJ2024-50611]*/) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
            WHERE B.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD --[PJ20200138] 속도개선
              AND (P_ITEM_ID IS NULL OR P_ITEM_ID = '-' OR P_ITEM_ID = 'ALL'
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_item_id' AND (A.ITEM_ID LIKE '%' || T.TOKEN || '%' OR A.NICK_NAME LIKE '%' || T.TOKEN || '%')))   /* [E20260824-TOKENPAREN] (PARAM_NM AND A) OR B 로 해석되어 B 가 공유 GTT 전체 토큰과 매칭되던 결함 */
            UNION ALL
            /* 2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
               SALES_PLAN 처리 */
            SELECT A.DIVISION_ID, A.DIVISION_NAME, A.UPPER_DEPT_ID, A.DEPT_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.SITE_DESCRIPTION, A.END_CUSTOMER, A.PROJECT_CODE AS END_CUSTOMER40
                 , A.PROJECT_CODE, A.PROJECT_NAME, A.BIZ_TYPE_NAME, A.PROJECT_STATUS, A.ITEM_ID, A.ITEM_CLASS_NAME, A.ITEM_NAME, A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP
                 , B.MEASURE, MEASURE.DISPLAY_SEQ, A.AUTHORITY_YN, 'W_' || B.YYYYMMDD AS YYYYMMDD, NVL(B.QTY, 0) AS PRICE, A.NICK_NAME, '-' AS COL_LIST
            FROM SCM_MGR.GT_FTPR_TMPDATA A
            JOIN SCM_MGR.GT_FTPR_DM_PLN_SALES_PLAN B
                ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.CURRENCY = B.CURRENCY
                AND A.DOM_EXP = B.DOM_EXP AND A.FCST_TYPE = B.FCST_TYPE AND A.INCOTERMS = B.INCOTERMS
            JOIN (SELECT COLUMN_NAME AS LOOKUP_CODE, COLUMN_LABEL_NAME AS DESCRIPTION, SORT_ORDER_NO AS DISPLAY_SEQ
                  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
                  WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price' AND VALID_YN = 'Y' /*[PJ2024-50611]*/) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
            WHERE B.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD /*[PJ20200138] 속도개선*/
              AND (P_ITEM_ID IS NULL OR P_ITEM_ID = '-' OR P_ITEM_ID = 'ALL'
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_item_id' AND (A.ITEM_ID LIKE '%' || T.TOKEN || '%' OR A.NICK_NAME LIKE '%' || T.TOKEN || '%')))   /* [E20260824-TOKENPAREN] (PARAM_NM AND A) OR B 로 해석되어 B 가 공유 GTT 전체 토큰과 매칭되던 결함 */
        ) T
        GROUP BY T.DIVISION_ID, T.DIVISION_NAME, T.UPPER_DEPT_ID, T.DEPT_ID, T.SCM_SITE_ID, T.PLANT_SITE_ID, T.SITE_DESCRIPTION, T.END_CUSTOMER, T.END_CUSTOMER40, T.PROJECT_CODE
               , T.PROJECT_NAME, T.BIZ_TYPE_NAME, T.PROJECT_STATUS, T.ITEM_ID, T.ITEM_CLASS_NAME, T.ITEM_NAME, T.INCOTERMS, T.CURRENCY, T.FCST_TYPE, T.DOM_EXP
               , T.MEASURE, T.DISPLAY_SEQ, T.AUTHORITY_YN, T.YYYYMMDD, T.PRICE, T.NICK_NAME, T.COL_LIST;
        --[E20251113-001347]_중복 데이터 발생건으로 데이터 모두 조회한 후 GROUP BY하여 데이터 중복건 제거 (END)
    END IF;

    ----------------------------------------------------------------------------------------------------------------------------------------
    --[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 START
    /*
        SALES PRICE 저장시에, 환율이 없는 경우나 메져가 4건이 되지 않는경우 저장 시에 정상적으로 저장되지 않는 경우가 발생.
        저장부분에 대해서 위의 내용을 수정을 완료하였으나, 혹여나 로직상 새는 부분이 발생한다하더라도 다음 저장할 데이터에 영향이 가지 않도록
        보완하는 부분으로 해당 부분을 추가함.
    */
    ----------------------------------------------------------------------------------------------------------------------------------------
    INSERT INTO SCM_MGR.GT_FTPR_TMPOUTPUTOMISSION
    SELECT B.DIVISION_ID, B.DIVISION_NAME, B.UPPER_DEPT_ID, B.DEPT_ID, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.SITE_DESCRIPTION, B.END_CUSTOMER
         , B.PROJECT_CODE AS END_CUSTOMER40, B.PROJECT_CODE, B.PROJECT_NAME, B.BIZ_TYPE_NAME, B.PROJECT_STATUS, B.ITEM_ID, B.ITEM_CLASS_NAME, B.ITEM_NAME
         , B.INCOTERMS, B.CURRENCY, B.FCST_TYPE, B.DOM_EXP
         , MEASURE.LOOKUP_CODE AS MEASURE, MEASURE.DISPLAY_SEQ, B.AUTHORITY_YN, B.YYYYMMDD, 0 AS PRICE, B.NICK_NAME, B.COL_LIST
    FROM (
        --데이터 중 메져가 LOC, KRW, USD 세쌍으로 이루어지지 않은 데이터를 추출한다.
        SELECT DISTINCT B2.DIVISION_ID, B2.DIVISION_NAME, B2.UPPER_DEPT_ID, B2.DEPT_ID, B2.SCM_SITE_ID
             , B2.PLANT_SITE_ID, B2.SITE_DESCRIPTION, B2.END_CUSTOMER, B2.PROJECT_CODE, B2.PROJECT_NAME
             , B2.BIZ_TYPE_NAME, B2.PROJECT_STATUS, B2.ITEM_ID, B2.ITEM_CLASS_NAME, B2.ITEM_NAME
             , B2.INCOTERMS, B2.CURRENCY, B2.FCST_TYPE, B2.DOM_EXP, B2.AUTHORITY_YN
             , B2.YYYYMMDD, B2.NICK_NAME, B2.COL_LIST
        FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL B2
        GROUP BY B2.DIVISION_ID, B2.DIVISION_NAME, B2.UPPER_DEPT_ID, B2.DEPT_ID, B2.SCM_SITE_ID
               , B2.PLANT_SITE_ID, B2.SITE_DESCRIPTION, B2.END_CUSTOMER, B2.PROJECT_CODE, B2.PROJECT_NAME
               , B2.BIZ_TYPE_NAME, B2.PROJECT_STATUS, B2.ITEM_ID, B2.ITEM_CLASS_NAME, B2.ITEM_NAME
               , B2.INCOTERMS, B2.CURRENCY, B2.FCST_TYPE, B2.DOM_EXP, B2.AUTHORITY_YN
               , B2.YYYYMMDD, B2.NICK_NAME, B2.COL_LIST
        HAVING COUNT(*) < 4
    ) B
    CROSS JOIN (
        SELECT COLUMN_NAME AS LOOKUP_CODE, COLUMN_LABEL_NAME AS DESCRIPTION, SORT_ORDER_NO AS DISPLAY_SEQ
        FROM SCM_MGR.SCM_MST_SHEET_MEASURE
        WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price'
          AND VALID_YN = 'Y'--[PJ2024-50611] Sales Price 로직 수정 - 메저 가져올때 VALID_YN = 'Y' 추가
    ) MEASURE
    --누락된 메져의 강제생성된 부분의 기본값들의 데이터를 매칭한다.
    LEFT OUTER JOIN SCM_MGR.GT_FTPR_TMPOUTPUTALL A
        ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.YYYYMMDD = B.YYYYMMDD
        AND A.CURRENCY = B.CURRENCY AND A.DOM_EXP = B.DOM_EXP AND A.FCST_TYPE = B.FCST_TYPE
        AND A.INCOTERMS = B.INCOTERMS AND A.MEASURE = MEASURE.LOOKUP_CODE
    WHERE A.MEASURE IS NULL;

    --선행에서 생성된 데이터와, 메져가 4쌍이 존재하지 않은데이터들을 강제로 생성한다.
    /*
      2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
        PRICE_EXIST 처리 / GROUP_ID 처리
      2026-07-03 perf: GROUP_ID MERGE(52.8만행 전체 UPDATE, 문장별 elapsed 1위)를 INSERT 시점 LEFT JOIN 선계산으로 대체.
        - SCP_MST_ITEM_GROUP_DETAIL (div,proj,item) 키 유일 실측 확인 — 매칭 시 NVL(GROUP_ID,'-'), 미매칭 시 ITEM_ID
          (원본 MERGE WHEN MATCHED 등가)
        - PRICE_EXIST MERGE 는 원본 유지 (집계 대상이 LOC/RTF 부분집합이라 비용 낮음 실측 0.5s —
          분석함수 통합안은 실측상 오히려 느려(4.6s vs 2.7s) 채택하지 않음)
    */
    INSERT INTO SCM_MGR.GT_FTPR_TMPOUTPUT
    SELECT T.DIVISION_ID, T.DIVISION_NAME, T.UPPER_DEPT_ID, T.DEPT_ID, T.SCM_SITE_ID, T.PLANT_SITE_ID, T.SITE_DESCRIPTION, T.END_CUSTOMER, T.END_CUSTOMER40
         , T.PROJECT_CODE, T.PROJECT_NAME, T.BIZ_TYPE_NAME, T.PROJECT_STATUS, T.ITEM_ID, T.ITEM_CLASS_NAME, T.ITEM_NAME, T.INCOTERMS, T.CURRENCY, T.FCST_TYPE, T.DOM_EXP
         , T.MEASURE, T.DISPLAY_SEQ, T.AUTHORITY_YN, T.YYYYMMDD, T.PRICE, T.NICK_NAME, T.COL_LIST, 'Y' AS PRICE_EXIST
         , CASE WHEN G.PROJECT_CODE IS NOT NULL THEN NVL(G.GROUP_ID, '-') ELSE T.ITEM_ID END AS GROUP_ID
    FROM (
        SELECT * FROM SCM_MGR.GT_FTPR_TMPOUTPUTALL
        UNION ALL
        SELECT * FROM SCM_MGR.GT_FTPR_TMPOUTPUTOMISSION
    ) T
    LEFT JOIN (
        SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, MAX(GROUP_ID) AS GROUP_ID
        FROM SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL
        GROUP BY DIVISION_ID, PROJECT_CODE, ITEM_ID
    ) G ON G.DIVISION_ID = T.DIVISION_ID AND G.PROJECT_CODE = T.PROJECT_CODE AND G.ITEM_ID = T.ITEM_ID;

    /*
        2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
        PRICE_EXIST 처리
    */
    V_FROM_YYYYMMDD := '';  -- From 주차 월요일
    V_TO_YYYYMMDD   := '';  -- To 주차 월요일(52주차)

    -- @v_from_yyyymmdd :  당주 월요일
    BEGIN
        SELECT 'W_' || BASIS_START_DATE INTO V_FROM_YYYYMMDD
        FROM SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE 1 = 1
          AND BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- @v_to_yyyymmdd: 52주차 월요일
    BEGIN
        SELECT 'W_' || BASIS_START_DATE INTO V_TO_YYYYMMDD
        FROM SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE 1 = 1
          AND BASIS_YYYYMMDD = TO_CHAR(SYSDATE + (52 * 7), 'YYYYMMDD');
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    MERGE INTO SCM_MGR.GT_FTPR_TMPOUTPUT T1
    USING (
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
             , 'N' AS PRICE_EXIST   /* [E20260824-MERGEHAVING] 아래 HAVING 이 'N' 대상만 남긴다 */
        FROM SCM_MGR.GT_FTPR_TMPOUTPUT A
        WHERE 1 = 1
          AND A.MEASURE IN ('LOC', 'RTF_SYS_RP')
          AND A.YYYYMMDD >= V_FROM_YYYYMMDD
          AND A.YYYYMMDD < V_TO_YYYYMMDD
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
               , A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
        /* [E20260824-MERGEHAVING] 종전: 전 키의 'Y'/'N' 을 만들어 ON 절에서 'N' 만 골랐다
           -> 68행 갱신하려고 558,704행 대상 조인(실측 1.43s / LIO 40,163).
           지금: HAVING 으로 'N' 대상만 만들어 조인 자체를 줄인다. 판정식은 종전 CASE 와 동일. */
        HAVING NVL(SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.PRICE END), 0) > 0
           AND NVL(SUM(CASE WHEN A.MEASURE = 'LOC' THEN A.PRICE END), 0) = 0
    ) T2
    ON (    T2.DIVISION_ID = T1.DIVISION_ID AND T2.PROJECT_CODE = T1.PROJECT_CODE
        AND T2.SCM_SITE_ID = T1.SCM_SITE_ID AND T2.PLANT_SITE_ID = T1.PLANT_SITE_ID
        AND T2.ITEM_ID = T1.ITEM_ID AND T2.INCOTERMS = T1.INCOTERMS
        AND T2.CURRENCY = T1.CURRENCY AND T2.FCST_TYPE = T1.FCST_TYPE
        AND T2.DOM_EXP = T1.DOM_EXP AND T2.YYYYMMDD = T1.YYYYMMDD   /* [E20260824-MERGEHAVING] T2 는 이미 'N' 만 */
    )
    WHEN MATCHED THEN UPDATE SET T1.PRICE_EXIST = T2.PRICE_EXIST;

    /*
        2024/05/14   kcw3408	이동계획 판가 매출(RTF Measure ,@p_version_type,PRICE_EXIST 추가)
        RTF 는 PRICE는 SUM
    */
    -- 월 데이터 평균 값 산정
    INSERT INTO SCM_MGR.GT_FTPR_TMPOUTPUT
    SELECT A.DIVISION_ID, A.DIVISION_NAME, A.UPPER_DEPT_ID, A.DEPT_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.SITE_DESCRIPTION, A.END_CUSTOMER
         , A.PROJECT_CODE AS END_CUSTOMER40, A.PROJECT_CODE, A.PROJECT_NAME, A.BIZ_TYPE_NAME, A.PROJECT_STATUS, A.ITEM_ID, A.ITEM_CLASS_NAME, A.ITEM_NAME
         , A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP, A.MEASURE, A.DISPLAY_SEQ, A.AUTHORITY_YN
         , 'M_' || SUBSTR(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6) || '01' AS YYYYMMDD
         , CASE WHEN A.MEASURE = 'RTF_SYS_RP'
                THEN SUM(NVL(PRICE, 0))
                ELSE SUM(NVL(PRICE, 0)) / COUNT(YYYYMMDD)
           END AS PRICE  ----수정
         , A.NICK_NAME, A.COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
         , A.PRICE_EXIST, A.GROUP_ID
    FROM SCM_MGR.GT_FTPR_TMPOUTPUT A
    GROUP BY A.DIVISION_ID, A.DIVISION_NAME, A.UPPER_DEPT_ID, A.DEPT_ID, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.SITE_DESCRIPTION, A.END_CUSTOMER
           , A.END_CUSTOMER40, A.PROJECT_CODE, A.PROJECT_NAME, A.BIZ_TYPE_NAME, A.PROJECT_STATUS, A.ITEM_ID, A.ITEM_CLASS_NAME, A.ITEM_NAME
           , A.INCOTERMS, A.CURRENCY, A.FCST_TYPE, A.DOM_EXP, A.MEASURE, A.DISPLAY_SEQ, A.AUTHORITY_YN
           , A.NICK_NAME, A.COL_LIST, A.PRICE_EXIST, A.GROUP_ID
           , SUBSTR(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6);

    /* tmpPlanData 에 대한 처리들  */
    V_PROD := '';
    FOR REC IN (SELECT DISTINCT YYYYMMDD FROM SCM_MGR.GT_FTPR_TMPOUTPUT ORDER BY YYYYMMDD) LOOP
        V_PROD := V_PROD || '''' || REC.YYYYMMDD || ''' AS "' || REC.YYYYMMDD || '",';
    END LOOP;

    IF V_PROD IS NULL OR V_PROD = '' THEN
        V_PROD := '''D_99999999''';
    ELSE
        V_PROD := RTRIM(V_PROD, ',');
    END IF;

    --Start [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공  --(화면 수정후 원위치)
    --IF @p_division_id = '82' and @p_invalid_exec = 'N'
    IF P_DIVISION_ID = '82' AND P_INVALID_EXEC = 'Z' THEN
        -- ESS 사업부 전용 로직 (tmpSalesSiteModelAll → tmpSalesSiteModel)
        --2026-07-03 perf: ORI_V 적재를 유일 사용처인 본 분기로 이동 (내용 원본 동일)
        INSERT INTO SCM_MGR.GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V
        SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
        FROM SCM_MGR.SCM_MST_ITEM_SN
        WHERE DIVISION_ID = P_DIVISION_ID;
        INSERT INTO SCM_MGR.GT_FTPR_TMPSALESSITEMODELALL
        SELECT SITE_PROJECT.DIVISION_ID, TEAM.DEPT_ID, SITE.END_CUSTOMER, SITE.END_CUSTOMER AS END_CUSTOMER40
             , SITE_PROJECT.SCM_SITE_ID, SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40
             , SITE_PROJECT.PROJECT_CODE, PJT.PROJECT_NAME, PJT.PROJECT_STATUS
             , SITE_ITEM.SALES_PLAN_ADJUST_YN, SITE_ITEM.ITEM_CLASS_NAME, SITE_ITEM.ITEM_ID
             , SITE_ITEM.ITEM_NAME, SITE_ITEM.NICK_NAME, SITE_ITEM.CURRENCY
        FROM (
            SELECT DISTINCT A.DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, NVL(MAX(VALID_YN), 'Y') AS VALID_YN
            FROM SCM_MGR.SCM_MST_SITE_ITEM A
               , SCM_MGR.GT_FTPR_DM_MST_ITEM_SINGLE_ORI_V B --[E20240920-000300]
            WHERE A.ITEM_ID = B.ITEM_ID AND A.DIVISION_ID = B.DIVISION_ID
            GROUP BY A.DIVISION_ID, SCM_SITE_ID, PROJECT_CODE
        ) SITE_PROJECT
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT PJT ON SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE AND SITE_PROJECT.DIVISION_ID = PJT.DIVISION_ID
        LEFT JOIN SCM_MGR.SCM_MST_SITE SITE ON SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID AND SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
        LEFT JOIN (
            SELECT T1.DIVISION_ID, T1.SCM_SITE_ID, T1.PROJECT_CODE, T1.ITEM_ID, T2.ITEM_NAME, T2.ITEM_TYPE, T2.ITEM_CLASS_NAME
                 , T1.SALES_PLAN_ADJUST_YN, T2.NICK_NAME, T1.CURRENCY, T1.VALID_YN, T1.OWNER, T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */
            FROM SCM_MGR.SCM_MST_SITE_ITEM T1
            JOIN SCM_MGR.GT_FTPR_TMPITEM T2 ON T1.DIVISION_ID = T2.DIVISION_ID AND T1.ITEM_ID = T2.ITEM_ID
            WHERE (T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END
                OR T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END)
        ) SITE_ITEM
            ON SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID AND SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
            AND SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
        --[PJ2024-50461] Team Mapping
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
            -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B.USER_ID, B.DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: FROM SCM_MGR.SCM_MST_SSO_USER_INFO B
            -- [hook#150 2026-09-06 AJS] AS-IS: JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C2 ON B.DEPT_ID = C2.DEPT_ID
        -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
            -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.USER_ID = TRIM(CASE WHEN INSTR(SITE_ITEM.OWNER, ',') > 0 THEN SUBSTR(SITE_ITEM.OWNER, 1, INSTR(SITE_ITEM.OWNER, ',') - 1) ELSE SITE_ITEM.OWNER END)
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
            ON TEAM.DEPT_ID = SITE_ITEM.DEPT_ID
        LEFT JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER SITE_CUST
            ON SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID AND SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID AND SITE_CUST.REP_YN = 'Y'
        LEFT JOIN SCM_MGR.SCM_MST_CUSTOMER CUST
            ON SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE AND SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE AND SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
        LEFT JOIN (
            SELECT DIVISION_ID, MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
            FROM SCM_MGR.DM_MST_CUSTOMER_MODEL WHERE VALID_YN = 'Y'
            GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
        ) CUST_ITEM
            ON SITE_ITEM.ITEM_ID = CUST_ITEM.ITEM_ID AND SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
            AND SITE_ITEM.DIVISION_ID = CUST_ITEM.DIVISION_ID AND SITE_ITEM.SCM_SITE_ID = CUST_ITEM.SCM_SITE_ID
        LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO SU ON SITE_ITEM.OWNER = SU.USER_ID
        WHERE 1 = 1
          AND SITE_PROJECT.DIVISION_ID = P_DIVISION_ID
          AND SITE.SITE_TYPE <> 'PLANT'
          AND (P_ITEM_ID IS NULL OR P_ITEM_ID = '-' OR P_ITEM_ID = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_item_id' AND (SITE_ITEM.ITEM_ID LIKE '%' || T.TOKEN || '%' OR SITE_ITEM.NICK_NAME LIKE '%' || T.TOKEN || '%')))   /* [E20260824-TOKENPAREN] (PARAM_NM AND A) OR B 로 해석되어 B 가 공유 GTT 전체 토큰과 매칭되던 결함 */
          AND (P_PROJECT_CODE IS NULL OR P_PROJECT_CODE = '-' OR P_PROJECT_CODE = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T WHERE T.PARAM_NM = 'p_project_code' AND (PJT.PROJECT_CODE LIKE '%' || T.TOKEN || '%' OR PJT.PROJECT_NAME LIKE '%' || T.TOKEN || '%')))   /* [E20260824-TOKENPAREN] (PARAM_NM AND A) OR B 로 해석되어 B 가 공유 GTT 전체 토큰과 매칭되던 결함 */
          AND (P_OWNER IS NULL OR P_OWNER = '-' OR P_OWNER = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE_ITEM X2
                          WHERE X2.DIVISION_ID = P_DIVISION_ID
                            AND NVL(SITE_ITEM.OWNER, 'xxxx') = X2.OWNER
                            AND EXISTS (SELECT 1 FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN T3 WHERE T3.PARAM_NM = 'p_owner' AND ( SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '1') LIKE '%' || T3.TOKEN || '%'   /* [E20260824-TOKENPAREN] OR 그룹 괄호 누락 정정 */
                                           OR X2.OWNER LIKE '%' || T3.TOKEN || '%'
                                           OR SCM_MGR.FN_GET_MULTI_OWNER_NAME(X2.OWNER, ',', '2') LIKE '%' || T3.TOKEN || '%'))))
          AND (P_DEPT_ID = 'ALL' OR TEAM.DEPT_ID IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_dept_id'))
          AND (P_END_CUSTOMER = 'ALL' OR SITE.END_CUSTOMER IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_end_customer'))
          AND (P_SCM_SITE_ID = 'ALL' OR SITE_PROJECT.SCM_SITE_ID IN (SELECT TOKEN FROM SCM_MGR.GT_DMF0020_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id'));

        INSERT INTO SCM_MGR.GT_FTPR_TMPSALESSITEMODEL
        SELECT A.DIVISION_ID, A.DEPT_ID, A.END_CUSTOMER, A.END_CUSTOMER40, A.SCM_SITE_ID, A.SCM_SITE_ID40
             , A.PROJECT_CODE, A.PROJECT_NAME, A.PROJECT_STATUS, A.SALES_PLAN_ADJUST_YN, A.ITEM_CLASS_NAME
             , A.ITEM_ID, A.ITEM_NAME, A.NICK_NAME, A.CURRENCY, B.MEASURE, B.DISPLAY_SEQ
        FROM SCM_MGR.GT_FTPR_TMPSALESSITEMODELALL A
        CROSS JOIN (
            SELECT COLUMN_NAME AS MEASURE, COLUMN_LABEL_NAME AS DESCRIPTION, SORT_ORDER_NO AS DISPLAY_SEQ
            FROM SCM_MGR.SCM_MST_SHEET_MEASURE
            WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price'
              AND VALID_YN = 'Y'--[PJ2024-50611] Sales Price 로직 수정 - 메저 가져올때 VALID_YN = 'Y' 추가
        ) B;

        V_NSQL := '
        SELECT *
        FROM (
            SELECT A.DIVISION_ID, B.DIVISION_NAME, B.UPPER_DEPT_ID, A.DEPT_ID, A.SCM_SITE_ID, B.PLANT_SITE_ID, B.SITE_DESCRIPTION
                 , A.END_CUSTOMER, B.END_CUSTOMER40, A.PROJECT_CODE, A.PROJECT_NAME, B.BIZ_TYPE_NAME, A.PROJECT_STATUS
                 , NVL(B.GROUP_ID, A.ITEM_ID) AS GROUP_ID, A.ITEM_ID, A.ITEM_CLASS_NAME, A.ITEM_NAME
                 , B.INCOTERMS
                 , CASE WHEN B.DIVISION_NAME IS NULL THEN A.CURRENCY ELSE B.CURRENCY END AS CURRENCY
                 , B.FCST_TYPE, B.DOM_EXP
                 , CASE WHEN B.DIVISION_NAME IS NULL
                        THEN CASE WHEN (NVL((SELECT MAX(DA.HAS_AUTH) FROM SCM_MGR.GT_DMF0020_DEPT_AUTH DA WHERE DA.DEPT_ID = A.DEPT_ID), ''N'') = ''Y'' OR ''' || V_GROUP_ID || ''' = ''ADMIN'') THEN ''Y'' ELSE ''N'' END
                        ELSE B.AUTHORITY_YN
                   END AS AUTHORITY_YN
                 , A.DISPLAY_SEQ, A.NICK_NAME, B.COL_LIST
                 , CASE WHEN B.DIVISION_NAME IS NULL THEN ''Y'' ELSE ''N'' END AS NEW_FLAG
                 , NVL(B.PRICE_EXIST, ''Y'') AS PRICE_EXIST
                 , A.MEASURE, B.PRICE, B.YYYYMMDD
            FROM SCM_MGR.GT_FTPR_TMPSALESSITEMODEL A
            LEFT JOIN SCM_MGR.GT_FTPR_TMPOUTPUT B
                ON A.DIVISION_ID = B.DIVISION_ID AND A.DEPT_ID = B.DEPT_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.ITEM_ID = B.ITEM_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.MEASURE = B.MEASURE
        ) T
        PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || V_PROD || '))
        ORDER BY DIVISION_ID, DIVISION_NAME, DEPT_ID, END_CUSTOMER, SCM_SITE_ID, PROJECT_CODE, PROJECT_STATUS, BIZ_TYPE_NAME
               , GROUP_ID, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PLANT_SITE_ID
               , DISPLAY_SEQ, MEASURE, COL_LIST';

    ELSE
        --End [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
        V_NSQL := '
        SELECT *
        FROM (
            SELECT DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION
                 , END_CUSTOMER, END_CUSTOMER40, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS
                 , GROUP_ID, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP
                 , AUTHORITY_YN, DISPLAY_SEQ, NICK_NAME, COL_LIST, ''N'' AS NEW_FLAG, PRICE_EXIST
                 , MEASURE, PRICE, YYYYMMDD
            FROM SCM_MGR.GT_FTPR_TMPOUTPUT
        ) T
        PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || V_PROD || '))
        ORDER BY DIVISION_ID, DEPT_ID, END_CUSTOMER, SCM_SITE_ID, PROJECT_CODE, PROJECT_STATUS, BIZ_TYPE_NAME
               , GROUP_ID, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PLANT_SITE_ID
               , DISPLAY_SEQ, MEASURE, COL_LIST';
    END IF;

    OPEN O_RC1 FOR V_NSQL;


    DBMS_OUTPUT.PUT_LINE('V_NSQL:'||V_NSQL);

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'           VALUE P_DIVISION_ID,
            'P_DEPT_ID'               VALUE P_DEPT_ID,
            'P_END_CUSTOMER'          VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'           VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID'         VALUE P_PLANT_SITE_ID,
            'P_PROJECT_CODE'          VALUE P_PROJECT_CODE,
            'P_ITEM_ID'               VALUE P_ITEM_ID,
            'P_CUSTOMER_PROJECT_CODE' VALUE P_CUSTOMER_PROJECT_CODE,
            'P_CUSTOMER_MODEL'        VALUE P_CUSTOMER_MODEL,
            'P_FROM_YYYYMMDD'         VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'           VALUE P_TO_YYYYMMDD,
            'P_BIZTYPE'               VALUE P_BIZTYPE,
            'P_CREATED_BY'            VALUE P_CREATED_BY,
            'P_USERINFO'              VALUE P_USERINFO,
            'P_OWNER'                 VALUE P_OWNER,
            'P_OVER_RANGE'            VALUE P_OVER_RANGE,
            'P_INVALID_EXEC'          VALUE P_INVALID_EXEC,
            'P_VERSION_TYPE'          VALUE P_VERSION_TYPE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0020_GET_SCM_MST_FUTURE_PRICE;

    PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL
(
    P_ACTIVE_FLAG       IN  VARCHAR2,
    P_DIVISION_ID       IN  VARCHAR2,
    P_PROJECT_CODE      IN  VARCHAR2,
    P_SCM_SITE_ID       IN  VARCHAR2,
    P_PLANT_SITE_ID     IN  VARCHAR2,
    P_ITEM_ID           IN  VARCHAR2,
    P_YYYYMMDD          IN  VARCHAR2,
    P_CURRENCY          IN  VARCHAR2,
    P_MEASURE           IN  VARCHAR2,
    P_DOM_EXP           IN  VARCHAR2,
    P_FCST_TYPE         IN  VARCHAR2,
    P_INCOTERMS         IN  VARCHAR2,
    P_PRICE             IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    P_CREATION_DATE     IN  VARCHAR2,
    P_LAST_UPDATED_BY   IN  VARCHAR2,
    P_ROWNUM            IN  VARCHAR2,                 --[PJ20200138] RowNum 추가
    O_RC1               OUT SYS_REFCURSOR,        -- Range Rate 위반 결과셋
    O_RESULT_CURSOR     OUT SYS_REFCURSOR         -- 작업결과 (항상 마지막)
)
    IS
    -- 로깅 표준 변수
    V_PROGRAM_NAME    VARCHAR2(150 CHAR);
    V_LOG_TYPE        VARCHAR2(30  CHAR);
    N_LOG_COUNT       NUMBER(10) := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500  CHAR);
    D_EVENT_DATE      DATE;
    V_SQL_CODE        VARCHAR2(30  CHAR);
    V_SQL_ERRMSG      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);
    V_PROC_INPUT      CLOB;

    -- 카운터
    N_DELETE_COUNT    NUMBER(10) := 0;
    N_INSERT_COUNT    NUMBER(10) := 0;

    -- Validation 변수
    V_FIRST_DIVISION  VARCHAR2(30  CHAR);
    V_INVALID_CHK     NUMBER(10);
    V_VALID_ITEM_ID   VARCHAR2(50  CHAR);
    V_INVALID_SITE    VARCHAR2(200 CHAR);
    V_INVALID_DUP     VARCHAR2(200 CHAR);
    V_INVALID_DUP_DATA VARCHAR2(200 CHAR);
    N_DFLAG_CHK       NUMBER(10) := 0;
BEGIN
    -- 프로그램명 자동 기록
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    -- 시작 LOG (START)
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure @@@##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;
    V_LOG_MESSAGE := NULL;  -- <- 변수 재사용을 위하여 초기화

    -- GTT 초기화 (시작 시점, 일반 테이블 DML 없음 → TRUNCATE 사용 가능)
    DELETE FROM SCM_MGR.GT_FCSV_RESULTS_MST;
    DELETE FROM SCM_MGR.GT_FCSV_RESULTS;

    --===================================================================================== GT_FCSV_RESULTS_MST 테이블에 split후 insert start
    -- '^' 구분자로 모든 입력 파라미터를 일괄 파싱하여 GTT에 적재
    -- (MSSQL의 WHILE LEN(@p_DIVISION_ID) > 0 PATINDEX 루프를 SET 단위로 변환)
    --*[2026-09-07] POJ 배열 길이가 달라도 값이 밀리지 않는다 — 빈 자리는 NULL 로 나오고
    --   수량·행번호는 아래 NVL(...,0), 문자 컬럼은 본 테이블 INSERT 의 NVL(...,-) 가 받는다.
    
    INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST
    (
         V_ACTIVE_FLAG
        ,V_DIVISION_ID
        ,V_PROJECT_CODE
        ,V_SCM_SITE_ID
        ,V_PLANT_SITE_ID
        ,V_ITEM_ID
        ,V_YYYYMMDD
        ,V_CURRENCY
        ,V_MEASURE
        ,V_DOM_EXP
        ,V_FCST_TYPE
        ,V_INCOTERMS
        ,V_PRICE
        ,V_CREATED_BY
        ,V_CREATION_DATE
        ,V_LAST_UPDATED_BY
        ,V_ROWNUM
    )
    WITH SPLIT_DATA AS
    (
        SELECT  LEVEL AS LV
               -- ,TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG     , '[^\^]+', 1, LEVEL)) AS V_ACTIVE_FLAG   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_DIVISION_ID     , '[^\^]+', 1, LEVEL)) AS V_DIVISION_ID   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_PROJECT_CODE    , '[^\^]+', 1, LEVEL)) AS V_PROJECT_CODE   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID     , '[^\^]+', 1, LEVEL)) AS V_SCM_SITE_ID   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID   , '[^\^]+', 1, LEVEL)) AS V_PLANT_SITE_ID   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_ITEM_ID         , '[^\^]+', 1, LEVEL)) AS V_ITEM_ID_RAW   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_YYYYMMDD        , '[^\^]+', 1, LEVEL)) AS V_YYYYMMDD   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_CURRENCY        , '[^\^]+', 1, LEVEL)) AS V_CURRENCY   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_MEASURE         , '[^\^]+', 1, LEVEL)) AS V_MEASURE   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_DOM_EXP         , '[^\^]+', 1, LEVEL)) AS V_DOM_EXP   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_FCST_TYPE       , '[^\^]+', 1, LEVEL)) AS V_FCST_TYPE   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_INCOTERMS       , '[^\^]+', 1, LEVEL)) AS V_INCOTERMS   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_PRICE           , '[^\^]+', 1, LEVEL)) AS V_PRICE   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_CREATED_BY      , '[^\^]+', 1, LEVEL)) AS V_CREATED_BY   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY , '[^\^]+', 1, LEVEL)) AS V_LAST_UPDATED_BY   --*[2026-09-07] POJ 원본
               -- ,TRIM(REGEXP_SUBSTR(P_ROWNUM          , '[^\^]+', 1, LEVEL)) AS V_ROWNUM   --*[2026-09-07] POJ 원본
               ,TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_ACTIVE_FLAG   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_DIVISION_ID   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_PROJECT_CODE   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_SCM_SITE_ID   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_PLANT_SITE_ID   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_ITEM_ID, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_ITEM_ID_RAW   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_YYYYMMDD, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_YYYYMMDD   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_CURRENCY, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_CURRENCY   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_MEASURE, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_MEASURE   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_DOM_EXP, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_DOM_EXP   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_FCST_TYPE, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_FCST_TYPE   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_INCOTERMS, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_INCOTERMS   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_PRICE, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_PRICE   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_CREATED_BY, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_CREATED_BY   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_LAST_UPDATED_BY   --*[2026-09-07] POJ 빈값 보존형 split 적용               
               ,TRIM(REGEXP_SUBSTR(P_ROWNUM, '(.*?)(\^|$)', 1, LEVEL, NULL, 1)) AS V_ROWNUM   --*[2026-09-07] POJ 빈값 보존형 split 적용
        FROM   DUAL
        -- CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^\^]+', 1, LEVEL) IS NOT NULL   --*[2026-09-07] POJ 원본
        CONNECT BY LEVEL <= REGEXP_COUNT(P_DIVISION_ID, '\^') + 1   --*[2026-09-07] POJ 빈값 보존형 split 적용
    )
    SELECT
         V_ACTIVE_FLAG
        ,V_DIVISION_ID
        ,V_PROJECT_CODE
        ,V_SCM_SITE_ID
        ,V_PLANT_SITE_ID
        -- [E20250522-001188]_TRIM 처리를 했음에도 지워지지 않는 데이터가 존재하는 것 확인하여 ITEM에 추가처리
        -- 1).RTRIM / 2).LTRIM / 3).CHR(13): Carriage return / 4).CHR(10): Line feed / 5).CHR(9): TAB / 6).' '공백을 ''
        ,REPLACE(REPLACE(REPLACE(REPLACE(TRIM(V_ITEM_ID_RAW), CHR(13), ''), CHR(10), ''), CHR(9), ''), ' ', '') AS V_ITEM_ID
        ,V_YYYYMMDD
        ,V_CURRENCY
        ,V_MEASURE
        ,V_DOM_EXP
        ,V_FCST_TYPE
        ,V_INCOTERMS
        -- ,TO_NUMBER(V_PRICE DEFAULT 0 ON CONVERSION ERROR)   --*[2026-09-07] POJ 원본
        ,NVL(TO_NUMBER(V_PRICE DEFAULT 0 ON CONVERSION ERROR), 0)   --*[2026-09-07] POJ AS-IS 파리티 — 빈 값은 0 (MSSQL 은 NUMERIC NOT NULL 이라 '' → 0)
        ,V_CREATED_BY
        ,SYSDATE                                              -- @v_CREATION_DATE 대신 GETDATE()
        ,V_LAST_UPDATED_BY
        -- ,TO_NUMBER(V_ROWNUM DEFAULT 0 ON CONVERSION ERROR)    --[PJ20200138] RowNum 추가   --*[2026-09-07] POJ 원본
        ,NVL(TO_NUMBER(V_ROWNUM DEFAULT 0 ON CONVERSION ERROR), 0)    --[PJ20200138] RowNum 추가   --*[2026-09-07] POJ AS-IS 파리티 — 빈 값은 0 (MSSQL 은 NUMERIC NOT NULL 이라 '' → 0)
    FROM   SPLIT_DATA;

    -- GTT 통계 수집 (1000건 이상 + JOIN/UPDATE 사용 → 조건 충족)
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_FCSV_RESULTS_MST', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_FCSV_RESULTS_MST',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );

    --[PJ2025-50017] 소형사업부 편집 제외 Validation 추가
    BEGIN
        SELECT V_DIVISION_ID
        INTO   V_FIRST_DIVISION
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_FIRST_DIVISION := NULL;
    END;

    IF V_FIRST_DIVISION = '40' THEN
        V_LOG_TYPE    := 'INVALID';
        V_LOG_MESSAGE := '########## END of procedure @@@##########';
        V_DESCRIPTION := '해당 사업부 편집은 Demand - Demand Plan - FcstPrice MGMT 에서 할 수 있습니다.';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;

        OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;

    --[E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가 START
    -- 원본 MSSQL의 UPDATE #results_MST FROM ... JOIN T 구문은 외부 alias A와 서브쿼리 T가
    -- 모두 LOC 행에 매칭되어 A.v_CURRENCY = T.v_CURRENCY 가 되므로
    -- WHERE A.v_CURRENCY <> T.v_CURRENCY 조건이 항상 False 가 되어 0건 갱신.
    -- 원본과 100% 동일 결과 유지를 위해 Oracle 변환에서도 No-op 처리.
    --[E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가 END

    ---------------------------------[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 START-----------------------------------
    -- LOC메져만 수정할 수 있는 시스템으로, KRW나 USD에 들어온 값과 관계없이 ACTIVE_FLAG를 LOC기준으로 변경작업 진행
    -- 발생한현상: 환율이 없는 경우 KRW나 USD가 0으로 들어오는데, ACTIVE_FLAG가 D로 변경되어 VALIDATION에 걸려 데이터 수정이 불가능함
    -- 원본 MSSQL의 UPDATE 구문은 위 Currency 동기화와 동일한 패턴 (외부 A = LOC, T 내부 A = LOC)으로
    -- WHERE A.v_ACTIVE_FLAG <> T.v_ACTIVE_FLAG 조건이 항상 False 가 되어 0건 갱신.
    -- 원본과 100% 동일 결과 유지를 위해 Oracle 변환에서도 No-op 처리.
    ----------------------------------[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 END------------------------------------

    --###############################################   GT_FCSV_RESULTS_MST 테이블에 split후 insert (END)
    -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
    BEGIN
        --[E20250306-001052]_비정상적으로 3쌍이 아닌 메져가 들어오는 경우가 발생함(매번 발생하는 건이 아닌, 가끔 발생하는 부분임)
        --VALIDATION을 추가하여, 3쌍이 아닌 메져가 들어오는 경우 체크 START
        --데이터 중 메져가 LOC, KRW, USD 세쌍으로 이루어지지 않은 데이터를 추출한다.
        SELECT COUNT(1)
        INTO   V_INVALID_CHK
        FROM
        (
            SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_CURRENCY, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_CURRENCY, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS
            HAVING COUNT(*) < 3
        );

        -- DBMS_OUTPUT.PUT_LINE('입력하신 데이터의 메져: LOC값을 확인 후 재저장 하시기 바랍니다.>V_INVALID_CHK:' || V_INVALID_CHK);

        IF V_INVALID_CHK > 0 THEN
            --MSG00452: 입력하신 데이터의 메져: LOC값을 확인 후 재저장 하시기 바랍니다.
            BEGIN
                SELECT MSG_NM -- KO
                INTO V_DESCRIPTION
                FROM   SCM_MGR.SCM_ADM_MSG_M -- SCM_MGR.TB_FX_MESSAGEINFO
                WHERE  MSG_ID = 'MSG00452' -- MESSAGEID = 'MSG00452'
                AND LANG_CD = 'KO'
                ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_DESCRIPTION := '입력하신 데이터의 메져: LOC값을 확인 후 재저장 하시기 바랍니다.';
            END;

            V_LOG_TYPE    := 'INVALID';
            V_LOG_MESSAGE := '########## END of procedure @@@##########';
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;

            OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        END IF;
        --VALIDATION을 추가하여, 3쌍이 아닌 메져가 들어오는 경우 체크 END

        IF V_FIRST_DIVISION <> '40' THEN
            -- Project Code 검증
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT P
                WHERE  P.PROJECT_CODE = R.V_PROJECT_CODE
            );

            -- DBMS_OUTPUT.PUT_LINE('Project Code 검증>V_INVALID_CHK:' || V_INVALID_CHK);

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.PC || '] Invalid Project Code !'
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_PROJECT_CODE AS PC
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT P
                            WHERE  P.PROJECT_CODE = R.V_PROJECT_CODE
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Project Code !';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            -- Item ID 검증
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                WHERE  I.ITEM_ID = R.V_ITEM_ID
            );

            -- DBMS_OUTPUT.PUT_LINE('Item ID 검증>V_INVALID_CHK:' || V_INVALID_CHK);

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.IID || '] Invalid Item ID !'
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_ITEM_ID AS IID
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                            WHERE  I.ITEM_ID = R.V_ITEM_ID
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Item ID !';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            --[V20260708-DMF0020] 신규/수정 행 마스터 정합 검증 START (조회 JOIN 미통과 = 저장 차단 + 사유 반환)
            -- 배경: 저장은 되지만 조회 SP(DMF0020_GET_SCM_MST_FUTURE_PRICE)의 하드 JOIN 을 통과하지 못해
            --       화면에서 보이지 않는 사고. 조회와 동일 기준으로 저장 전 검증한다.
            --   (a) SCM_MST_SITE  : DIVISION_ID + SCM_SITE_ID, SITE_TYPE='SALES', VALID_YN='Y' (조회 L301/L683 동일)
            --   (b) SCM_MST_ITEM_SN: DIVISION_ID + ITEM_ID (조회 TMPITEM L597~599 동일 — 기존 Item 검증은 사업부 무관이라 격차)
            --   삭제행(V_ACTIVE_FLAG='D')은 검증 제외 (무효 마스터의 기존 데이터 삭제 허용).
            -- (a) Sales Site 마스터 검증
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG <> 'D'
            AND    NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_SITE S
                WHERE  S.DIVISION_ID = R.V_DIVISION_ID
                AND    S.SCM_SITE_ID = R.V_SCM_SITE_ID
                AND    S.SITE_TYPE   = 'SALES'
                AND    S.VALID_YN    = 'Y'
            );

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.DIV || '/' || X.SITE || '] Invalid Sales Site !'
                           || ' (Sales Site 마스터 미등록/무효 - 저장해도 조회되지 않아 저장 차단)'
                           || CASE WHEN V_INVALID_CHK > 1 THEN ' 외 ' || (V_INVALID_CHK - 1) || '건' ELSE '' END
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_DIVISION_ID AS DIV, R.V_SCM_SITE_ID AS SITE
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  R.V_ACTIVE_FLAG <> 'D'
                        AND    NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_SITE S
                            WHERE  S.DIVISION_ID = R.V_DIVISION_ID
                            AND    S.SCM_SITE_ID = R.V_SCM_SITE_ID
                            AND    S.SITE_TYPE   = 'SALES'
                            AND    S.VALID_YN    = 'Y'
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Sales Site ! (Sales Site 마스터 미등록/무효 - 저장 차단)';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;

            -- (b) 사업부 Item 마스터 검증 (기존 Item 검증은 사업부 무관 — 조회는 DIVISION 범위로 필터되므로 보강)
            SELECT COUNT(1) INTO V_INVALID_CHK
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG <> 'D'
            AND    NOT EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                WHERE  I.DIVISION_ID = R.V_DIVISION_ID
                AND    I.ITEM_ID     = R.V_ITEM_ID
            );

            IF V_INVALID_CHK > 0 THEN
                BEGIN
                    SELECT '[' || X.DIV || '/' || X.IID || '] Invalid Item for Division !'
                           || ' (해당 사업부 Item 마스터 미등록 - 저장해도 조회되지 않아 저장 차단)'
                           || CASE WHEN V_INVALID_CHK > 1 THEN ' 외 ' || (V_INVALID_CHK - 1) || '건' ELSE '' END
                    INTO   V_DESCRIPTION
                    FROM
                    (
                        SELECT R.V_DIVISION_ID AS DIV, R.V_ITEM_ID AS IID
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                        WHERE  R.V_ACTIVE_FLAG <> 'D'
                        AND    NOT EXISTS (
                            SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                            WHERE  I.DIVISION_ID = R.V_DIVISION_ID
                            AND    I.ITEM_ID     = R.V_ITEM_ID
                        )
                        AND ROWNUM = 1
                    ) X;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DESCRIPTION := 'Invalid Item for Division ! (사업부 Item 마스터 미등록 - 저장 차단)';
                END;

                V_LOG_TYPE    := 'INVALID';
                V_LOG_MESSAGE := '########## END of procedure @@@##########';
                D_EVENT_DATE  := SYSDATE;
                BEGIN
                    SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END;

                OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                RETURN;
            END IF;
            --[V20260708-DMF0020] 마스터 정합 검증 END

            -- 20180814 KHSONG Invalid Site Item validation 추가
            V_VALID_ITEM_ID := NULL;

            -- 자동차, 소형인경우
            BEGIN
                SELECT 1 INTO V_INVALID_CHK FROM DUAL
                WHERE  EXISTS (
                    SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST
                    WHERE  V_DIVISION_ID LIKE '81%' OR V_DIVISION_ID = '40'
                );
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_INVALID_CHK := 0;
            END;

            IF V_INVALID_CHK = 1 THEN
                BEGIN
                    SELECT X.IID INTO V_VALID_ITEM_ID
                    FROM
                    (
                        SELECT A.V_ITEM_ID AS IID
                        FROM   SCM_MGR.GT_FCSV_RESULTS_MST A
                        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITEM
                            ON  ITEM.DIVISION_ID  = A.V_DIVISION_ID
                            AND ITEM.PROJECT_CODE = A.V_PROJECT_CODE
                            AND ITEM.SCM_SITE_ID  = A.V_SCM_SITE_ID
                            AND ITEM.ITEM_ID      = A.V_ITEM_ID
                            AND ITEM.VALID_YN     = 'Y'
                        LEFT OUTER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V SN
                            ON  ITEM.DIVISION_ID = SN.DIVISION_ID
                            AND ITEM.ITEM_ID     = SN.ITEM_ID
                            AND SN.ACTIVE_FLAG   = 'Y'
                        WHERE  A.V_PRICE <> 0
                        AND   (ITEM.ITEM_ID IS NULL OR SN.ITEM_ID IS NULL)
                    ) X
                    WHERE ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_VALID_ITEM_ID := NULL;
                END;

                IF V_VALID_ITEM_ID IS NOT NULL THEN
                    V_DESCRIPTION := '[' || V_VALID_ITEM_ID || '] Invalid Site Item ID !';
                    V_LOG_TYPE    := 'INVALID';
                    V_LOG_MESSAGE := '########## END of procedure @@@##########';
                    D_EVENT_DATE  := SYSDATE;
                    BEGIN
                        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    END;

                    OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
                    OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
                    RETURN;
                END IF;
            END IF;
        END IF;
        -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end -----------------------------------------------
    END;
    --===================================================================================== GT_FCSV_RESULTS_MST 테이블에 split후 insert end

    --------------------------------------------------------------------------------------------------------------------------------
    --                                                                 20200422 KHSONG C20200102-000131 Validation 로직 추가 (BEGIN)
    --------------------------------------------------------------------------------------------------------------------------------
    V_INVALID_SITE := NULL;

    -------------------------------------------------------------------------------------------------------------------------------------
    --[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 START
    --ACTIVE_FLAG가 한건이라도 D인경우에만 처리한다.
    -------------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   N_DFLAG_CHK
    FROM   SCM_MGR.GT_FCSV_RESULTS_MST
    WHERE  V_ACTIVE_FLAG = 'D';

    IF N_DFLAG_CHK > 0 THEN
        --52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다.
        BEGIN
            SELECT '★ Sales Site : ' || SCM_SITE_ID || ' / ★ Model : ' || ITEM_ID
            INTO   V_INVALID_SITE
            FROM
            (
                SELECT F.SCM_SITE_ID, F.ITEM_ID
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                JOIN   SCM_MGR.SCM_SYS_CALENDAR_M B
                  ON   F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE  EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.GT_FCSV_RESULTS_MST A
                    JOIN   SCM_MGR.SCM_SYS_CALENDAR_M D
                      ON   A.V_YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE  A.V_ACTIVE_FLAG = 'D'
                    AND    F.DIVISION_ID   = A.V_DIVISION_ID
                    AND    F.PROJECT_CODE  = A.V_PROJECT_CODE
                    AND    F.SCM_SITE_ID   = A.V_SCM_SITE_ID
                    AND    F.PLANT_SITE_ID = A.V_PLANT_SITE_ID
                    AND    F.ITEM_ID       = A.V_ITEM_ID
                    AND    F.DOM_EXP       = A.V_DOM_EXP
                    AND    F.FCST_TYPE     = A.V_FCST_TYPE
                    AND    F.INCOTERMS     = A.V_INCOTERMS
                    AND    F.MEASURE      IN ('MKT_FCST','RTF_SCP','AS_In_Req')  -- 대상 MEASURE
                    -----------------------------------------------------------------------------------------------------------------------------------
                    -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (START)
                    --AND F.YYYYMMDD  >  CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 7 + 7 * 52, 'YYYYMMDD')
                    -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (END)
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    B.ISO_YYYYWW = D.ISO_YYYYWW
                    AND    F.QTY <> 0  -- 제로값은 제외함
                    AND    F.FCST_TYPE NOT IN (
                        SELECT MST.SEGMENT1  -- FCST_TYPE
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                        WHERE  MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    MST.SEGMENT4    = 'FREE'  -- 무상 제공인경우
                        GROUP BY MST.SEGMENT1
                    )  -- 무상제공인경우는 Validation 에서 제외
                )
                AND ROWNUM = 1
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_INVALID_SITE := NULL;
        END;

        IF V_INVALID_SITE IS NOT NULL THEN
            V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || V_INVALID_SITE;
            V_LOG_TYPE    := 'INVALID';
            V_LOG_MESSAGE := '########## END of procedure @@@##########';
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;

            OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        END IF;

        V_INVALID_SITE := NULL;
        BEGIN
            SELECT '★ Sales Site : ' || SCM_SITE_ID || ' / ★ Model : ' || ITEM_ID
            INTO   V_INVALID_SITE
            FROM
            (
                SELECT F.SCM_SITE_ID, F.ITEM_ID
                FROM   SCM_MGR.DM_PLN_MKT_FCST F
                WHERE  EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.GT_FCSV_RESULTS_MST
                    WHERE  V_ACTIVE_FLAG  = 'D'
                    AND    F.DIVISION_ID  = V_DIVISION_ID
                    AND    F.PROJECT_CODE = V_PROJECT_CODE
                    AND    F.SCM_SITE_ID  = V_SCM_SITE_ID
                    AND    F.PLANT_SITE_ID= V_PLANT_SITE_ID
                    AND    F.ITEM_ID      = V_ITEM_ID
                    AND    F.DOM_EXP      = V_DOM_EXP
                    AND    F.FCST_TYPE    = V_FCST_TYPE
                    AND    F.INCOTERMS    = V_INCOTERMS
                    -- [C20211126-000348] AS_In_Req 메저 추가
                    AND    F.MEASURE     IN ('MKT_FCST','RTF_SCP','AS_In_Req')  -- 대상 MEASURE
                    -----------------------------------------------------------------------------------------------------------------------------------
                    -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
                    /*
                    AND F.YYYYMMDD           BETWEEN  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후건만 확인
                                             AND      CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- SCP PLANNING 구간이 52주 */
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    F.YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD')               -- 당주 월요일부터
                    AND    F.YYYYMMDD <  TO_CHAR(TRUNC(SYSDATE, 'IW') - 7 + 7 * 52, 'YYYYMMDD')      -- 52주후 월요일까지
                    -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
                    -----------------------------------------------------------------------------------------------------------------------------------
                    AND    F.QTY <> 0  -- 제로값은 제외함
                    AND    F.FCST_TYPE NOT IN (
                        SELECT MST.SEGMENT1  -- FCST_TYPE
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                        WHERE  MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    MST.SEGMENT4    = 'FREE'  -- 무상 제공인경우
                        GROUP BY MST.SEGMENT1
                    )  -- 무상제공인경우는 Validation 에서 제외
                )
                AND ROWNUM = 1
            );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_INVALID_SITE := NULL;
        END;

        IF V_INVALID_SITE IS NOT NULL THEN
            V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || V_INVALID_SITE;
            V_LOG_TYPE    := 'INVALID';
            V_LOG_MESSAGE := '########## END of procedure @@@##########';
            D_EVENT_DATE  := SYSDATE;
            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            END;

            OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
            RETURN;
        END IF;
    END IF;
    --------------------------------------------------------------------------------------------------------------------------------
    --                                                                   20200422 KHSONG C20200102-000131 Validation 로직 추가 (END)
    --------------------------------------------------------------------------------------------------------------------------------

    --Start [C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인
    V_INVALID_DUP := NULL;
    BEGIN
        SELECT V_ITEM_ID
        INTO   V_INVALID_DUP
        FROM
        (
            SELECT V_ITEM_ID
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST
            WHERE  NVL(V_PRICE, 0) <> 0
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE
            HAVING COUNT(V_CURRENCY) > 1
        )
        WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_INVALID_DUP := NULL;
    END;

    IF V_INVALID_DUP IS NOT NULL THEN
        V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
        V_LOG_TYPE    := 'INVALID';
        V_LOG_MESSAGE := '########## END of procedure @@@##########';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;

        OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;
    --End [C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인

    --[E20241125-000026]_Sales Price Validation 추가 START
    V_INVALID_DUP_DATA := NULL;
    BEGIN
        SELECT ITEM_ID
        INTO   V_INVALID_DUP_DATA
        FROM
        (
            SELECT S.ITEM_ID
            FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S
            WHERE  EXISTS (
                SELECT 1
                FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
                WHERE  S.DIVISION_ID   = R.V_DIVISION_ID
                AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
                AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
                AND    S.PLANT_SITE_ID = R.V_PLANT_SITE_ID
                AND    S.ITEM_ID       = R.V_ITEM_ID
                AND    S.YYYYMMDD      = R.V_YYYYMMDD
                --AND    S.CURRENCY    = R.V_CURRENCY
                AND    S.MEASURE       = R.V_MEASURE
                AND    S.DOM_EXP       = R.V_DOM_EXP
                AND    S.FCST_TYPE     = R.V_FCST_TYPE
                AND    S.INCOTERMS     = R.V_INCOTERMS
                AND    R.V_ACTIVE_FLAG = 'I'
            )
        )
        WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_INVALID_DUP_DATA := NULL;
    END;

    IF V_INVALID_DUP_DATA IS NOT NULL THEN
        V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
        V_LOG_TYPE    := 'INVALID';
        V_LOG_MESSAGE := '########## END of procedure @@@##########';
        D_EVENT_DATE  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END;

        OPEN O_RC1 FOR SELECT NULL FROM DUAL WHERE 1 = 2;
        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, V_DESCRIPTION AS MSG, V_DESCRIPTION AS EVENT FROM DUAL;
        RETURN;
    END IF;
    --[E20241125-000026]_Sales Price Validation 추가 END

    /*
    --START 20220826 - LOC를 제외한 MEASURE의 PRICE값이 0인 것 체크
    -- (원소스에서 주석처리되어 있어 그대로 유지)
    --END 20220826 - LOC를 제외한 MEASURE의 PRICE값이 0인 것 체크
    --===================================================================================== #results_MST delete start
    -- (원소스 주석블록 - 변환 생략)
    --===================================================================================== #results_MST delete end
    */

    --===================================================================================== delete start
    BEGIN
         -- DELETE COUNT 확인
        -- 필수: 빈값 표현이 레거시(스페이스)와 신규('-')로 갈려 있다.
        --       INSERT 가 NVL(...,'-')로 저장하므로 비교식도 '-'로 맞춰야 기존 행을 잡는다.
        --       대상은 실제 스페이스 행이 존재하는 4개 컬럼만 (나머지는 '=' 유지 = 인덱스 보존).
        SELECT COUNT(DIVISION_ID)
        INTO   N_DELETE_COUNT
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG = 'D'
            AND    S.DIVISION_ID   = R.V_DIVISION_ID
            AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
            AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
            AND    S.ITEM_ID       = R.V_ITEM_ID
            AND    S.YYYYMMDD      = R.V_YYYYMMDD
            --AND    S.CURRENCY    = R.V_CURRENCY
            AND    S.MEASURE       = R.V_MEASURE
            AND    NVL(TRIM(S.PLANT_SITE_ID), '-') = NVL(R.V_PLANT_SITE_ID, '-')
            AND    NVL(TRIM(S.DOM_EXP)      , '-') = NVL(R.V_DOM_EXP      , '-')
            AND    NVL(TRIM(S.FCST_TYPE)    , '-') = NVL(R.V_FCST_TYPE    , '-')
            AND    NVL(TRIM(S.INCOTERMS)    , '-') = NVL(R.V_INCOTERMS    , '-')
        );

        DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  R.V_ACTIVE_FLAG = 'D'
            AND    S.DIVISION_ID   = R.V_DIVISION_ID
            AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
            AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
            AND    S.ITEM_ID       = R.V_ITEM_ID
            AND    S.YYYYMMDD      = R.V_YYYYMMDD
            --AND    S.CURRENCY    = R.V_CURRENCY
            AND    S.MEASURE       = R.V_MEASURE
            AND    NVL(TRIM(S.PLANT_SITE_ID), '-') = NVL(R.V_PLANT_SITE_ID, '-')
            AND    NVL(TRIM(S.DOM_EXP)      , '-') = NVL(R.V_DOM_EXP      , '-')
            AND    NVL(TRIM(S.FCST_TYPE)    , '-') = NVL(R.V_FCST_TYPE    , '-')
            AND    NVL(TRIM(S.INCOTERMS)    , '-') = NVL(R.V_INCOTERMS    , '-')
        );
    END;
    --===================================================================================== delete end


    --===================================================================================== update, insert start
    -- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (START)
    BEGIN
        -- INSERT COUNT 확인
        SELECT COUNT(V_DIVISION_ID)
        INTO   N_INSERT_COUNT
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';

        -- INSERT전 동일대상 delete 수행
        -- 필수: 아래 INSERT 가 NVL(...,'-')로 저장하므로 비교식도 같은 규칙으로 정규화한다.
        --       종전에는 기존 스페이스 행(' ')과 신규 '-' 가 다른 키로 취급되어
        --       기존 행이 안 지워지고 '-' 행이 중복 생성되었다.
        DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
            WHERE  NVL(R.V_ACTIVE_FLAG, 'X') <> 'D'
            AND    S.DIVISION_ID   = R.V_DIVISION_ID
            AND    S.PROJECT_CODE  = R.V_PROJECT_CODE
            AND    S.SCM_SITE_ID   = R.V_SCM_SITE_ID
            AND    S.ITEM_ID       = R.V_ITEM_ID
            AND    S.YYYYMMDD      = R.V_YYYYMMDD
            --AND    S.CURRENCY    = R.V_CURRENCY
            AND    S.MEASURE       = R.V_MEASURE
            AND    NVL(TRIM(S.PLANT_SITE_ID), '-') = NVL(R.V_PLANT_SITE_ID, '-')
            AND    NVL(TRIM(S.DOM_EXP)      , '-') = NVL(R.V_DOM_EXP      , '-')
            AND    NVL(TRIM(S.FCST_TYPE)    , '-') = NVL(R.V_FCST_TYPE    , '-')
            AND    NVL(TRIM(S.INCOTERMS)    , '-') = NVL(R.V_INCOTERMS    , '-')
        );

        -- INSERT 수행
        INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE
        (
             DIVISION_ID
            ,PROJECT_CODE
            ,SCM_SITE_ID
            ,PLANT_SITE_ID
            ,ITEM_ID
            ,YYYYMMDD
            ,CURRENCY
            ,MEASURE
            ,DOM_EXP
            ,FCST_TYPE
            ,INCOTERMS
            ,PRICE
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
        )
        SELECT
             NVL(V_DIVISION_ID, '-')
            ,NVL(V_PROJECT_CODE, '-')
            ,NVL(V_SCM_SITE_ID, '-')
            ,NVL(V_PLANT_SITE_ID, '-')
            ,NVL(V_ITEM_ID, '-')
            ,NVL(V_YYYYMMDD, '-')
            ,NVL(V_CURRENCY, '-')
            ,NVL(V_MEASURE, '-')
            ,NVL(V_DOM_EXP, '-')
            ,NVL(V_FCST_TYPE, '-')
            ,NVL(V_INCOTERMS, '-')
            ,CAST(V_PRICE AS NUMBER(20,10))
            ,V_CREATED_BY
            ,SYSDATE
            ,V_LAST_UPDATED_BY
            ,SYSDATE
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';
        -- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (END)

        /*
                            --[2018-03-20][수정][기존소스]
                            -- HISTORY 생성
                               BEGIN
                                  EXEC [dbo].[PR_DM_ANL_SALES_PRICE_HIST]
                                                        ,@v_project_code
                                                        ,@v_scm_site_id
                                                        ,@v_plant_site_id
                                                        ,@v_item_id
                                                        ,@v_yyyymmdd
                                                        ,@v_currency
                                                        ,@v_measure
                                                        ,@v_dom_exp
                                                        ,@v_fcst_type
                                                        ,@v_incoterms
                                                        ,@v_price
                                                        ,@v_created_by
                                                        ,@v_last_updated_by
                               END
        */

        -- [2018-03-20][수정][수정소스]
        INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE_H
        (
             DIVISION_ID
            ,HISTORY_SEQ
            ,PROJECT_CODE
            ,SCM_SITE_ID
            ,PLANT_SITE_ID
            ,ITEM_ID
            ,YYYYMMDD
            ,CURRENCY
            ,MEASURE
            ,DOM_EXP
            ,FCST_TYPE
            ,INCOTERMS
            ,PRICE
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
        )
        SELECT
             V_DIVISION_ID
            ,SCM_MGR.SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL
            ,V_PROJECT_CODE
            ,V_SCM_SITE_ID
            ,V_PLANT_SITE_ID
            ,V_ITEM_ID
            ,V_YYYYMMDD
            ,V_CURRENCY
            ,V_MEASURE
            ,V_DOM_EXP
            ,V_FCST_TYPE
            ,V_INCOTERMS
            ,V_PRICE
            ,V_CREATED_BY
            ,SYSDATE
            ,V_LAST_UPDATED_BY
            ,SYSDATE
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';   -- DELETE값이 아닌경우만

        --------------------------------------------------------------------------------------  20180510 SKH ADD START
        INSERT INTO SCM_MGR.GT_FCSV_RESULTS
        (
             V_DIVISION_ID
            ,V_PROJECT_CODE
            ,V_SCM_SITE_ID
            ,V_ITEM_ID
            ,V_DOM_EXP
            ,V_FCST_TYPE
            ,V_INCOTERMS
            ,V_MEASURE
            ,V_PLANT_SITE_ID
            ,V_YYYYMMDD
            ,V_CURRENCY
            ,V_PRICE
            ,V_CREATED_BY
        )
        SELECT
             V_DIVISION_ID
            ,V_PROJECT_CODE
            ,V_SCM_SITE_ID
            ,V_ITEM_ID
            ,V_DOM_EXP
            ,V_FCST_TYPE
            ,V_INCOTERMS
            ,V_MEASURE
            ,V_PLANT_SITE_ID
            ,V_YYYYMMDD
            ,V_CURRENCY
            ,V_PRICE
            ,V_CREATED_BY
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST
        WHERE  V_ACTIVE_FLAG <> 'D';   -- DELETE값이 아닌경우만

        -- Procedure 호출 #results 테이블의 데이터를 전달하여 처리함
        P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE;
        --------------------------------------------------------------------------------------  20180510 SKH ADD END
    END;
    --===================================================================================== update, insert end

    --[PJ20200138] 입력된 Price가 주변 주차와 Range Rate 가 초과되어 차이나는 데이터 Return
    OPEN O_RC1 FOR
    WITH W_MIN_MAX_DATE (ROWNUMVAL, YYYYMMDD, MIN_YYYYMMDD, MAX_YYYYMMDD) AS
    (
        SELECT
             R.V_ROWNUM AS ROWNUMVAL
            ,R.V_YYYYMMDD
            ,(SELECT NVL(MAX(S_MIN.YYYYMMDD), '')
              FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S_MIN
              WHERE  S_MIN.DIVISION_ID  = R.V_DIVISION_ID
              AND    S_MIN.PROJECT_CODE = R.V_PROJECT_CODE
              AND    S_MIN.SCM_SITE_ID  = R.V_SCM_SITE_ID
              AND    S_MIN.PLANT_SITE_ID= R.V_PLANT_SITE_ID
              AND    S_MIN.ITEM_ID      = R.V_ITEM_ID
              AND    S_MIN.CURRENCY     = R.V_CURRENCY
              AND    S_MIN.MEASURE      = R.V_MEASURE
              AND    S_MIN.DOM_EXP      = R.V_DOM_EXP
              AND    S_MIN.FCST_TYPE    = R.V_FCST_TYPE
              AND    S_MIN.INCOTERMS    = R.V_INCOTERMS
              AND    S_MIN.MEASURE      = 'LOC'
              AND    S_MIN.YYYYMMDD     < R.V_YYYYMMDD) AS MIN_YYYYMMDD
            ,(SELECT NVL(MIN(S_MAX.YYYYMMDD), '')
              FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S_MAX
              WHERE  S_MAX.DIVISION_ID  = R.V_DIVISION_ID
              AND    S_MAX.PROJECT_CODE = R.V_PROJECT_CODE
              AND    S_MAX.SCM_SITE_ID  = R.V_SCM_SITE_ID
              AND    S_MAX.PLANT_SITE_ID= R.V_PLANT_SITE_ID
              AND    S_MAX.ITEM_ID      = R.V_ITEM_ID
              AND    S_MAX.CURRENCY     = R.V_CURRENCY
              AND    S_MAX.MEASURE      = R.V_MEASURE
              AND    S_MAX.DOM_EXP      = R.V_DOM_EXP
              AND    S_MAX.FCST_TYPE    = R.V_FCST_TYPE
              AND    S_MAX.INCOTERMS    = R.V_INCOTERMS
              AND    S_MAX.MEASURE      = 'LOC'
              AND    S_MAX.YYYYMMDD     > R.V_YYYYMMDD) AS MAX_YYYYMMDD
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
        WHERE  1 = 1
        AND    R.V_MEASURE = 'LOC'
        AND    R.V_ACTIVE_FLAG <> 'D'   -- 2022.07.22
    )
    , W_RETURN AS
    (
        SELECT
             R.V_ROWNUM
            ,(CASE WHEN S.DIVISION_ID = '40' THEN S.PROJECT_CODE ELSE C.END_CUSTOMER END) AS END_CUSTOMER
            ,S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID, S.INCOTERMS, S.FCST_TYPE, S.CURRENCY
            ,S.DIVISION_ID, S.PLANT_SITE_ID, S.MEASURE, S.DOM_EXP
            ,R.V_YYYYMMDD AS CH_YYYYMMDD, CAST(R.V_PRICE AS NUMBER(13,3)) AS CH_PRICE
            ,S.YYYYMMDD   AS ST_YYYYMMDD, CAST(S.PRICE   AS NUMBER(13,3)) AS ST_PRICE
            ,ROW_NUMBER() OVER (PARTITION BY R.V_ROWNUM, R.V_YYYYMMDD ORDER BY R.V_ROWNUM, R.V_YYYYMMDD) AS REP_ROWNUM
        FROM   SCM_MGR.GT_FCSV_RESULTS_MST R
        INNER JOIN SCM_MGR.SCM_MST_FUTURE_PRICE S
            ON  S.DIVISION_ID  = R.V_DIVISION_ID
            AND S.PROJECT_CODE = R.V_PROJECT_CODE
            AND S.SCM_SITE_ID  = R.V_SCM_SITE_ID
            AND S.PLANT_SITE_ID= R.V_PLANT_SITE_ID
            AND S.ITEM_ID      = R.V_ITEM_ID
            AND S.CURRENCY     = R.V_CURRENCY
            AND S.MEASURE      = R.V_MEASURE
            AND S.DOM_EXP      = R.V_DOM_EXP
            AND S.FCST_TYPE    = R.V_FCST_TYPE
            AND S.INCOTERMS    = R.V_INCOTERMS
        INNER JOIN W_MIN_MAX_DATE W
            ON  R.V_ROWNUM     = W.ROWNUMVAL
            AND R.V_YYYYMMDD   = W.YYYYMMDD
        LEFT JOIN SCM_MGR.SCM_MST_SITE C
            ON  S.DIVISION_ID = C.DIVISION_ID
            AND S.SCM_SITE_ID = C.SCM_SITE_ID
            AND C.SITE_TYPE   = 'SALES'
        JOIN
        (
            SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS RANGE_VAL
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  VALID_YN    = 'Y'
            AND    LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE'
        ) L
            ON  S.DIVISION_ID = L.DIVISION_ID
        WHERE  S.MEASURE  = 'LOC'
        AND    C.VALID_YN = 'Y'
        AND    (S.PRICE * L.RANGE_VAL) < ABS(S.PRICE - R.V_PRICE)
        AND    S.YYYYMMDD IN (W.MIN_YYYYMMDD, W.MAX_YYYYMMDD)
    )
    SELECT *
    FROM   W_RETURN
    WHERE  REP_ROWNUM = 1
    ORDER BY 1, 2, 3, 8, 9;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure @@@##########';
    V_DESCRIPTION := 'delete_count: ' || TO_CHAR(N_DELETE_COUNT) || ' / insert_count: ' || TO_CHAR(N_INSERT_COUNT);
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    -- DML 결과 반환 커서 (DML 직후 SQL%ROWCOUNT는 마지막 INSERT 건수이므로 N_INSERT_COUNT 사용)
    N_LOG_COUNT := N_INSERT_COUNT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    -- 트랜잭션 (COMMIT) - 프로시저 종료 직전 1회
    COMMIT;

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
            'P_PROJECT_CODE'    VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'     VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID'   VALUE P_PLANT_SITE_ID,
            'P_ITEM_ID'         VALUE P_ITEM_ID,
            'P_YYYYMMDD'        VALUE P_YYYYMMDD,
            'P_CURRENCY'        VALUE P_CURRENCY,
            'P_MEASURE'         VALUE P_MEASURE,
            'P_DOM_EXP'         VALUE P_DOM_EXP,
            'P_FCST_TYPE'       VALUE P_FCST_TYPE,
            'P_INCOTERMS'       VALUE P_INCOTERMS,
            'P_PRICE'           VALUE P_PRICE,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_CREATION_DATE'   VALUE P_CREATION_DATE,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY,
            'P_ROWNUM'          VALUE P_ROWNUM
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || V_BACKTRACE
        );
END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL;

    PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP
(
	-- Add the parameters for the stored procedure here
    p_active_flag             IN  VARCHAR2,
    p_DIVISION_ID             IN  VARCHAR2,
    p_PROJECT_CODE            IN  VARCHAR2,
    p_SCM_SITE_ID             IN  VARCHAR2,
    p_PLANT_SITE_ID           IN  VARCHAR2,
    p_ITEM_ID                 IN  VARCHAR2,
    p_YYYYMMDD                IN  VARCHAR2,
    p_CURRENCY                IN  VARCHAR2,
    p_MEASURE                 IN  VARCHAR2,
    p_DOM_EXP                 IN  VARCHAR2,
    p_FCST_TYPE               IN  VARCHAR2,
    p_INCOTERMS               IN  VARCHAR2,
    p_PRICE                   IN  VARCHAR2,
    p_CREATED_BY              IN  VARCHAR2,
    p_CREATION_DATE           IN  VARCHAR2,
    p_LAST_UPDATED_BY         IN  VARCHAR2,
    p_result_cursor           OUT SYS_REFCURSOR
)
    IS

	-- 스플릿관련 변수

    v_active_flag        VARCHAR2(4000 CHAR);
    v_DIVISION_ID        VARCHAR2(4000 CHAR);
    v_PROJECT_CODE       VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID        VARCHAR2(4000 CHAR);
    v_PLANT_SITE_ID      VARCHAR2(4000 CHAR);
    v_ITEM_ID            VARCHAR2(4000 CHAR);
    v_YYYYMMDD           VARCHAR2(4000 CHAR);
    v_CURRENCY           VARCHAR2(4000 CHAR);
    v_MEASURE            VARCHAR2(4000 CHAR);
    v_DOM_EXP            VARCHAR2(4000 CHAR);
    v_FCST_TYPE          VARCHAR2(4000 CHAR);
    v_INCOTERMS          VARCHAR2(4000 CHAR);
    v_PRICE              VARCHAR2(4000 CHAR);
    v_CREATED_BY         VARCHAR2(4000 CHAR);
    v_CREATION_DATE      VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY    VARCHAR2(4000 CHAR);

    -- 입력 파라미터 복사본 (IN 파라미터를 직접 변경할 수 없으므로 로컬 변수에 복사)
    l_active_flag        VARCHAR2(32767);
    l_DIVISION_ID        VARCHAR2(32767);
    l_PROJECT_CODE       VARCHAR2(32767);
    l_SCM_SITE_ID        VARCHAR2(32767);
    l_PLANT_SITE_ID      VARCHAR2(32767);
    l_ITEM_ID            VARCHAR2(32767);
    l_YYYYMMDD           VARCHAR2(32767);
    l_CURRENCY           VARCHAR2(32767);
    l_MEASURE            VARCHAR2(32767);
    l_DOM_EXP            VARCHAR2(32767);
    l_FCST_TYPE          VARCHAR2(32767);
    l_INCOTERMS          VARCHAR2(32767);
    l_PRICE              VARCHAR2(32767);
    l_CREATED_BY         VARCHAR2(32767);
    l_LAST_UPDATED_BY    VARCHAR2(32767);

	v_delimiter VARCHAR2(1 CHAR);
	max_loop_cnt		PLS_INTEGER := 0;
	mst_loop_cnt		PLS_INTEGER := 0;

	-- LOG 용 변수 설정
    v_program_name VARCHAR2(150 CHAR) := 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP';
    v_log_type     VARCHAR2(30 CHAR); -- START/END/ERROR/...
    n_log_count    PLS_INTEGER := 0;
    v_log_message  VARCHAR2(1000 CHAR);
    v_description  VARCHAR2(500 CHAR);
    d_event_date   DATE;
    n_delete_count    PLS_INTEGER := 0;
    n_insert_count     PLS_INTEGER := 0;
    n_logo_count      PLS_INTEGER := 0;

    -- 결과 메시지 보관 (MSSQL SELECT '...' 대체)
    v_result_message  VARCHAR2(4000 CHAR);

    index_DIVISION_ID     PLS_INTEGER;
    index_active_flag     PLS_INTEGER;
    index_PROJECT_CODE    PLS_INTEGER;
    index_SCM_SITE_ID     PLS_INTEGER;
    index_PLANT_SITE_ID   PLS_INTEGER;
    index_ITEM_ID         PLS_INTEGER;
    index_YYYYMMDD        PLS_INTEGER;
    index_CURRENCY        PLS_INTEGER;
    index_MEASURE         PLS_INTEGER;
    index_DOM_EXP         PLS_INTEGER;
    index_FCST_TYPE       PLS_INTEGER;
    index_INCOTERMS       PLS_INTEGER;
    index_PRICE           PLS_INTEGER;
    index_CREATED_BY      PLS_INTEGER;
    --index_CREATION_DATE   PLS_INTEGER;
    index_LAST_UPDATED_BY PLS_INTEGER;

    -- 20180814 KHSONG Invalid Site Item validation 추가
    valid_item_id        VARCHAR2(32767);

    -- 사용자 정의 예외 (INVALID 상태 처리용)
    e_invalid_data EXCEPTION;

BEGIN

    /* [E20260824-SAVEGTTINIT] 스테이징 GTT 세션 초기화 (실측 결함 2026-08-24).
       증상: 한 세션에서 두 번째 저장부터 code=0 을 돌려주면서 원장이 전혀 안 바뀐다(허위 성공).
             단일 세션 반복 실측 — #1 0.34s 원장반영 OK / #2~#4 각 0.01s 미반영, GTT 행수 3 고정.
       원인: 이 SP 는 GT_DMF0020_RESULTS_MST 등 스테이징 GTT 를 초기화하지 않는다.
             GTT 는 ON COMMIT PRESERVE ROWS 라 직전 호출 행이 남고, 이후 호출이 조용히 건너뛴다.
       영향: BE 커넥션 풀(10) 때문에 화면에서는 '가끔 저장됨' 으로 보인다 — 재현이 어려운 형태.
       ⚠ TRUNCATE 대신 DELETE — TRUNCATE 는 GTT 에 DDL 배타락을 잡는다(ORA-14452 위험). */
    DELETE FROM SCM_MGR.GT_DMF0020_RESULTS_MST;
    DELETE FROM SCM_MGR.GT_DMF0020_RESULTS;
    DELETE FROM SCM_MGR.GT_DMF0020_EXCH;

    -- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    -- SET NOCOUNT ON;
    -- SET XACT_ABORT ON;

	v_delimiter := '^';  -- 데이터 구분자

	-- 마지막 데이터 처리를 위한 구분자 추가
	l_active_flag      := RTRIM(p_active_flag     ) || '^';
	l_DIVISION_ID      := RTRIM(p_DIVISION_ID     ) || '^';
	l_PROJECT_CODE     := RTRIM(p_PROJECT_CODE    ) || '^';
	l_SCM_SITE_ID      := RTRIM(p_SCM_SITE_ID     ) || '^';
	l_PLANT_SITE_ID    := RTRIM(p_PLANT_SITE_ID   ) || '^';
	l_ITEM_ID          := RTRIM(p_ITEM_ID         ) || '^';
	l_YYYYMMDD         := RTRIM(p_YYYYMMDD        ) || '^';
	l_CURRENCY         := RTRIM(p_CURRENCY        ) || '^';
	l_MEASURE          := RTRIM(p_MEASURE         ) || '^';
	l_DOM_EXP          := RTRIM(p_DOM_EXP         ) || '^';
	l_FCST_TYPE        := RTRIM(p_FCST_TYPE       ) || '^';
	l_INCOTERMS        := RTRIM(p_INCOTERMS       ) || '^';
	l_PRICE            := RTRIM(p_PRICE           ) || '^';
	l_CREATED_BY       := RTRIM(p_CREATED_BY      ) || '^';
	--l_CREATION_DATE    := RTRIM(p_CREATION_DATE   ) || '^';
	l_LAST_UPDATED_BY  := RTRIM(p_LAST_UPDATED_BY ) || '^';


-- 20180718  KHSONG  기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경 (START)
	-- #results_MST TEMP TABLE
	-- GTT 변환: GT_DMF0020_RESULTS_MST (별도 DDL 파일 PKG_DMF0020_GTT_DDL.sql 참조)
	-- CLUSTERED INDEX IDX_RESULTS_N1 → GTT 에는 인덱스 별도 정의 (DDL 파일 참조)

	-- #results TEMP TABLE (PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE 로 전달할 대상)
	-- GTT 변환: GT_DMF0020_RESULTS (별도 DDL 파일 PKG_DMF0020_GTT_DDL.sql 참조)
	-- CLUSTERED INDEX IDX_RESULTS_N2 → GTT 에는 인덱스 별도 정의 (DDL 파일 참조)

	-- 환율 테이블
	-- GTT 변환: GT_DMF0020_EXCH (별도 DDL 파일 PKG_DMF0020_GTT_DDL.sql 참조)
-- 20180718  KHSONG  기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경 (END)

		-- 시작 LOG  (START)
		v_log_type := 'START';
		v_log_message := '########## Start of procedure @@@##########';
		v_description := '';
		d_event_date := SYSDATE;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		-- Oracle 은 명시적 SAVEPOINT 사용 (BEGIN TRANSACTION 대체)
		SAVEPOINT SCM_MST_FUTURE_PRICE_ALL;  -- sss

	--------------------------------------------------------------------------------------------
		BEGIN
	--------------------------------------------------------------------------------------------	 DECIMAL

--===================================================================================== #results_MST 테이블에 split후 insert start
--###############################################  #results_MST 테이블에 split후 insert (START)
WHILE LENGTH(l_DIVISION_ID) > 0
LOOP

    index_DIVISION_ID      := INSTR(l_DIVISION_ID,      '^');
	index_active_flag      := INSTR(l_active_flag,      '^');
	index_PROJECT_CODE     := INSTR(l_PROJECT_CODE,     '^');
	index_SCM_SITE_ID      := INSTR(l_SCM_SITE_ID,      '^');
	index_PLANT_SITE_ID    := INSTR(l_PLANT_SITE_ID,    '^');
	index_ITEM_ID          := INSTR(l_ITEM_ID,          '^');
	index_YYYYMMDD         := INSTR(l_YYYYMMDD,         '^');
	index_CURRENCY         := INSTR(l_CURRENCY,         '^');
	index_MEASURE          := INSTR(l_MEASURE,          '^');
	index_DOM_EXP          := INSTR(l_DOM_EXP,          '^');
	index_FCST_TYPE        := INSTR(l_FCST_TYPE,        '^');
	index_INCOTERMS        := INSTR(l_INCOTERMS,        '^');
	index_PRICE            := INSTR(l_PRICE,            '^');
	index_CREATED_BY       := INSTR(l_CREATED_BY,       '^');
	--index_CREATION_DATE    := INSTR(l_CREATION_DATE,    '^');
	index_LAST_UPDATED_BY  := INSTR(l_LAST_UPDATED_BY,  '^');


	--확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
    IF index_DIVISION_ID > 0 THEN

			-- MSSQL SUBSTRING(s, 0, n) 은 1번째부터 (n-1)글자 반환과 동일 → Oracle SUBSTR(s, 1, n-1)
			v_active_flag := SUBSTR(l_active_flag, 1, index_active_flag - 1);
			l_active_flag := SUBSTR(l_active_flag, LENGTH(v_active_flag || '^') + 1, LENGTH(l_active_flag));

			v_DIVISION_ID := SUBSTR(l_DIVISION_ID, 1, index_DIVISION_ID - 1);
			l_DIVISION_ID := SUBSTR(l_DIVISION_ID, LENGTH(v_DIVISION_ID || '^') + 1, LENGTH(l_DIVISION_ID));

			v_PROJECT_CODE := SUBSTR(l_PROJECT_CODE , 1, index_PROJECT_CODE - 1);
			l_PROJECT_CODE := SUBSTR(l_PROJECT_CODE , LENGTH(v_PROJECT_CODE || '^') + 1, LENGTH(l_PROJECT_CODE ));

			v_SCM_SITE_ID := SUBSTR(l_SCM_SITE_ID, 1, index_SCM_SITE_ID - 1);
			l_SCM_SITE_ID := SUBSTR(l_SCM_SITE_ID, LENGTH(v_SCM_SITE_ID || '^') + 1, LENGTH(l_SCM_SITE_ID));

			v_PLANT_SITE_ID := SUBSTR(l_PLANT_SITE_ID, 1, index_PLANT_SITE_ID - 1);
			l_PLANT_SITE_ID := SUBSTR(l_PLANT_SITE_ID, LENGTH(v_PLANT_SITE_ID || '^') + 1, LENGTH(l_PLANT_SITE_ID));

			v_ITEM_ID := SUBSTR(l_ITEM_ID, 1, index_ITEM_ID - 1);
			l_ITEM_ID := SUBSTR(l_ITEM_ID, LENGTH(v_ITEM_ID || '^') + 1, LENGTH(l_ITEM_ID));

			v_YYYYMMDD := SUBSTR(l_YYYYMMDD, 1, index_YYYYMMDD - 1);
			l_YYYYMMDD := SUBSTR(l_YYYYMMDD, LENGTH(v_YYYYMMDD || '^') + 1, LENGTH(l_YYYYMMDD));

			v_CURRENCY := SUBSTR(l_CURRENCY, 1, index_CURRENCY - 1);
			l_CURRENCY := SUBSTR(l_CURRENCY, LENGTH(v_CURRENCY || '^') + 1, LENGTH(l_CURRENCY));

			v_MEASURE := SUBSTR(l_MEASURE, 1, index_MEASURE - 1);
			l_MEASURE := SUBSTR(l_MEASURE, LENGTH(v_MEASURE || '^') + 1, LENGTH(l_MEASURE));

			v_DOM_EXP := SUBSTR(l_DOM_EXP, 1, index_DOM_EXP - 1);
			l_DOM_EXP := SUBSTR(l_DOM_EXP, LENGTH(v_DOM_EXP || '^') + 1, LENGTH(l_DOM_EXP));

			v_FCST_TYPE := SUBSTR(l_FCST_TYPE, 1, index_FCST_TYPE - 1);
			l_FCST_TYPE := SUBSTR(l_FCST_TYPE, LENGTH(v_FCST_TYPE || '^') + 1, LENGTH(l_FCST_TYPE));

			v_INCOTERMS := SUBSTR(l_INCOTERMS, 1, index_INCOTERMS - 1);
			l_INCOTERMS := SUBSTR(l_INCOTERMS, LENGTH(v_INCOTERMS || '^') + 1, LENGTH(l_INCOTERMS));

			v_PRICE := SUBSTR(l_PRICE, 1, index_PRICE - 1);
			l_PRICE := SUBSTR(l_PRICE, LENGTH(v_PRICE || '^') + 1, LENGTH(l_PRICE));

			v_CREATED_BY := SUBSTR(l_CREATED_BY, 1, index_CREATED_BY - 1);
			l_CREATED_BY := SUBSTR(l_CREATED_BY, LENGTH(v_CREATED_BY || '^') + 1, LENGTH(l_CREATED_BY));

			v_LAST_UPDATED_BY := SUBSTR(l_LAST_UPDATED_BY, 1, index_LAST_UPDATED_BY - 1);
			l_LAST_UPDATED_BY := SUBSTR(l_LAST_UPDATED_BY, LENGTH(v_LAST_UPDATED_BY || '^') + 1, LENGTH(l_LAST_UPDATED_BY));

			--20181005 khsong 공백제거로직추가 (START)
			v_active_flag    	:= rtrim(ltrim(v_active_flag));
			v_DIVISION_ID    	:= rtrim(ltrim(v_DIVISION_ID));
			v_PROJECT_CODE   	:= rtrim(ltrim(v_PROJECT_CODE));
			v_SCM_SITE_ID    	:= rtrim(ltrim(v_SCM_SITE_ID));
			v_PLANT_SITE_ID  	:= rtrim(ltrim(v_PLANT_SITE_ID));
			v_ITEM_ID        	:= rtrim(ltrim(v_ITEM_ID));
			v_YYYYMMDD       	:= rtrim(ltrim(v_YYYYMMDD));
			v_CURRENCY       	:= rtrim(ltrim(v_CURRENCY));
			v_MEASURE        	:= rtrim(ltrim(v_MEASURE));
			v_DOM_EXP        	:= rtrim(ltrim(v_DOM_EXP));
			v_FCST_TYPE      	:= rtrim(ltrim(v_FCST_TYPE));
			v_INCOTERMS      	:= rtrim(ltrim(v_INCOTERMS));
			v_PRICE          	:= rtrim(ltrim(v_PRICE));
			v_CREATED_BY     	:= rtrim(ltrim(v_CREATED_BY));
			v_LAST_UPDATED_BY	:= rtrim(ltrim(v_LAST_UPDATED_BY));
			--20181005 khsong 공백제거로직추가 (END)

			INSERT INTO GT_DMF0020_RESULTS_MST (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,TO_NUMBER(v_PRICE)
									,v_CREATED_BY
									,SYSDATE -- @v_CREATION_DATE
									,v_LAST_UPDATED_BY
			);

    ELSE

			v_DIVISION_ID := l_DIVISION_ID;
			l_DIVISION_ID := NULL;

			--20181005 khsong 공백제거로직추가 (START)
			v_active_flag    	:= rtrim(ltrim(v_active_flag));
			v_DIVISION_ID    	:= rtrim(ltrim(v_DIVISION_ID));
			v_PROJECT_CODE   	:= rtrim(ltrim(v_PROJECT_CODE));
			v_SCM_SITE_ID    	:= rtrim(ltrim(v_SCM_SITE_ID));
			v_PLANT_SITE_ID  	:= rtrim(ltrim(v_PLANT_SITE_ID));
			v_ITEM_ID        	:= rtrim(ltrim(v_ITEM_ID));
			v_YYYYMMDD       	:= rtrim(ltrim(v_YYYYMMDD));
			v_CURRENCY       	:= rtrim(ltrim(v_CURRENCY));
			v_MEASURE        	:= rtrim(ltrim(v_MEASURE));
			v_DOM_EXP        	:= rtrim(ltrim(v_DOM_EXP));
			v_FCST_TYPE      	:= rtrim(ltrim(v_FCST_TYPE));
			v_INCOTERMS      	:= rtrim(ltrim(v_INCOTERMS));
			v_PRICE          	:= rtrim(ltrim(v_PRICE));
			v_CREATED_BY     	:= rtrim(ltrim(v_CREATED_BY));
			v_LAST_UPDATED_BY	:= rtrim(ltrim(v_LAST_UPDATED_BY));

			--20181005 khsong 공백제거로직추가 (END)

			INSERT INTO GT_DMF0020_RESULTS_MST (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,TO_NUMBER(v_PRICE)
									,v_CREATED_BY
									,SYSDATE --@v_CREATION_DATE
									,v_LAST_UPDATED_BY
			);
    END IF;
END LOOP;

BEGIN

	INSERT INTO GT_DMF0020_EXCH (DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE)
	SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
	FROM DM_MST_EXCHANGE_RATE A
	JOIN GT_DMF0020_RESULTS_MST B
		ON A.DIVISION_ID	= B.v_DIVISION_ID
		AND A.YYYYMMDD		= SUBSTR(B.v_YYYYMMDD, 1, 6) || '01'
		AND A.CURRENCY		= 'KRW';

	-- LOC 동일값
		INSERT INTO GT_DMF0020_RESULTS_MST ( v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY)
		SELECT v_active_flag
				,v_DIVISION_ID
				,v_PROJECT_CODE
				,v_SCM_SITE_ID
				,v_PLANT_SITE_ID
				,v_ITEM_ID
				,v_YYYYMMDD
				,v_CURRENCY
				,v_CURRENCY AS v_MEASURE
				,v_DOM_EXP
				,v_FCST_TYPE
				,v_INCOTERMS
				,v_PRICE
				,v_CREATED_BY
				,v_CREATION_DATE
				,v_LAST_UPDATED_BY
		FROM GT_DMF0020_RESULTS_MST A
		WHERE A.v_MEASURE = 'LOC'
		AND A.v_CURRENCY IN('KRW', 'USD');

		-- KRW값 구하기
		INSERT INTO GT_DMF0020_RESULTS_MST ( v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY)
		SELECT v_active_flag
				,v_DIVISION_ID
				,v_PROJECT_CODE
				,v_SCM_SITE_ID
				,v_PLANT_SITE_ID
				,v_ITEM_ID
				,v_YYYYMMDD
				,v_CURRENCY
				,'KRW' AS v_MEASURE
				,v_DOM_EXP
				,v_FCST_TYPE
				,v_INCOTERMS
				,ROUND(A.v_PRICE * B.EXCHANGE_PRICE, 3)
				,v_CREATED_BY
				,v_CREATION_DATE
				,v_LAST_UPDATED_BY
		FROM GT_DMF0020_RESULTS_MST A
		JOIN GT_DMF0020_EXCH B
		ON B.UNIT_CURRENCY = A.v_CURRENCY
		AND B.YYYYMMDD = SUBSTR(A.v_YYYYMMDD, 1, 6) || '01'
		WHERE A.v_MEASURE = 'LOC'
		AND A.v_CURRENCY <> 'KRW';

		-- USD값 구하기
		INSERT INTO GT_DMF0020_RESULTS_MST ( v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY)
		SELECT  v_active_flag
				,v_DIVISION_ID
				,v_PROJECT_CODE
				,v_SCM_SITE_ID
				,v_PLANT_SITE_ID
				,v_ITEM_ID
				,v_YYYYMMDD
				,v_CURRENCY
				,'USD' AS v_MEASURE
				,v_DOM_EXP
				,v_FCST_TYPE
				,v_INCOTERMS
				,ROUND(A.v_PRICE / B.EXCHANGE_PRICE, 3)
				,v_CREATED_BY
				,v_CREATION_DATE
				,v_LAST_UPDATED_BY
		FROM GT_DMF0020_RESULTS_MST A
		JOIN GT_DMF0020_EXCH B
		ON B.UNIT_CURRENCY = 'USD'
		AND B.YYYYMMDD = SUBSTR(A.v_YYYYMMDD, 1, 6) || '01'
		WHERE A.v_MEASURE = 'KRW'
		AND A.v_CURRENCY <> 'USD';
END;

	--###############################################   #results_MST 테이블에 split후 insert (END)
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
		   DECLARE
		       v_chk_cnt PLS_INTEGER;
		   BEGIN
		   IF v_DIVISION_ID <> '40' THEN

			   SELECT count(1) INTO v_chk_cnt
			     FROM GT_DMF0020_RESULTS_MST R
			    WHERE ( SELECT count(1) FROM scm_mst_project WHERE project_code = R.v_PROJECT_CODE ) = 0;

			   IF v_chk_cnt > 0 THEN
				   v_log_type := 'INVALID';
				   v_result_message := '['|| v_PROJECT_CODE ||']'|| ' Invalid Project Code !';
				   RAISE e_invalid_data;
			   END IF;


			   SELECT count(1) INTO v_chk_cnt
			     FROM GT_DMF0020_RESULTS_MST R
			    WHERE ( SELECT count(1) FROM SCM_MST_ITEM_SN WHERE ITEM_ID = R.v_ITEM_ID ) = 0;

			   IF v_chk_cnt > 0 THEN
				   v_log_type := 'INVALID';
				   v_result_message := '['|| v_ITEM_ID ||']'|| ' Invalid Item ID !';
				   RAISE e_invalid_data;
			   END IF;

				-- 20180814 KHSONG Invalid Site Item validation 추가
				valid_item_id := NULL;

		----------------------------------------------------------------------------------------------------------◎◎◎◎
			SELECT count(1) INTO v_chk_cnt
			  FROM GT_DMF0020_RESULTS_MST
			 WHERE v_division_id IN ('81','40');  -- 자동차,소형인경우

			IF v_chk_cnt > 0 THEN

					BEGIN
						SELECT A.v_item_id INTO valid_item_id
							FROM GT_DMF0020_RESULTS_MST A
							WHERE 1=1
							AND NOT EXISTS (SELECT  ITEM.division_id
												FROM scm_mst_site_item ITEM
													,DM_MST_ITEM_SINGLE_V SN
												where 1=1
 													and ITEM.division_id   = A.v_division_id
													and ITEM.PROJECT_CODE  = A.v_project_code
													and ITEM.scm_site_id   = A.v_scm_site_id
													and ITEM.ITEM_ID       = A.v_ITEM_ID
													and ITEM.division_id   = SN.division_id
													and ITEM.ITEM_ID       = SN.ITEM_ID
													and SN.ACTIVE_FLAG	   = 'Y'
													and ITEM.VALID_YN	   = 'Y'
													and ITEM.division_id IN ('81','40')
											  )
								AND A.v_division_id IN ('81','40')
								AND ROWNUM = 1;
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							valid_item_id := NULL;
					END;
						-------------------------------------------------------------------◎◎◎◎
						IF valid_item_id IS NOT NULL THEN
								v_log_type := 'INVALID';
								v_result_message := '['|| valid_item_id ||']'|| ' Invalid Site Item ID !';
								v_description := '['|| valid_item_id ||']'|| ' Invalid Site Item ID !';
								RAISE e_invalid_data;
						END IF;
						-------------------------------------------------------------------◎◎◎◎
			END IF;
				----------------------------------------------------------------------------------◎◎◎◎


		   END IF;
		   END;
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------


--===================================================================================== #results_MST 테이블에 split후 insert end

--  SELECT * FROM #results_MST;  -- 확인용
--===================================================================================== delete start
BEGIN
		   -- DELETE COUNT 확인
		   SELECT COUNT(DIVISION_ID) INTO n_delete_count
		     FROM SCM_MST_FUTURE_PRICE TGT
		    WHERE (
							SELECT count(1)
							  FROM GT_DMF0020_RESULTS_MST
							 where v_active_flag      = 'D'
							   and TGT.DIVISION_ID    =   v_DIVISION_ID
							   AND TGT.PROJECT_CODE   =   v_PROJECT_CODE
							   AND TGT.SCM_SITE_ID    =   v_SCM_SITE_ID
							   AND TGT.PLANT_SITE_ID  =   v_PLANT_SITE_ID
							   AND TGT.ITEM_ID        =   v_ITEM_ID
							   AND TGT.YYYYMMDD       =   v_YYYYMMDD
							   --AND TGT.CURRENCY       =   v_CURRENCY
							   AND TGT.MEASURE        =   v_MEASURE
							   AND TGT.DOM_EXP        =   v_DOM_EXP
							   AND TGT.FCST_TYPE      =   v_FCST_TYPE
							   AND TGT.INCOTERMS      =   v_INCOTERMS
						  ) > 0;

		   --  select * from #results_MST
		   DELETE
           FROM SCM_MST_FUTURE_PRICE TGT
           WHERE (
                    SELECT count(1)
					  FROM GT_DMF0020_RESULTS_MST
					 where v_active_flag      = 'D'
                       and TGT.DIVISION_ID    =   v_DIVISION_ID
                       AND TGT.PROJECT_CODE   =   v_PROJECT_CODE
                       AND TGT.SCM_SITE_ID    =   v_SCM_SITE_ID
                       AND TGT.PLANT_SITE_ID  =   v_PLANT_SITE_ID
                       AND TGT.ITEM_ID        =   v_ITEM_ID
                       AND TGT.YYYYMMDD       =   v_YYYYMMDD
                       --AND TGT.CURRENCY       =   v_CURRENCY
                       AND TGT.MEASURE        =   v_MEASURE
                       AND TGT.DOM_EXP        =   v_DOM_EXP
                       AND TGT.FCST_TYPE      =   v_FCST_TYPE
                       AND TGT.INCOTERMS      =   v_INCOTERMS
				  ) > 0;
END;
--===================================================================================== delete end


--===================================================================================== update, insert start
-- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (START)
BEGIN
		   -- INSERT COUNT 확인
		   SELECT count(v_DIVISION_ID) INTO n_insert_count
		    		FROM GT_DMF0020_RESULTS_MST
						where v_active_flag      <> 'D';

		   -- INSERT전 동일대상 delete 수행
		   DELETE
           FROM SCM_MST_FUTURE_PRICE TGT
           WHERE (
                    SELECT count(1)
					  FROM GT_DMF0020_RESULTS_MST
					 where v_active_flag      <> 'D'
                       and TGT.DIVISION_ID    =   v_DIVISION_ID
                       AND TGT.PROJECT_CODE   =   v_PROJECT_CODE
                       AND TGT.SCM_SITE_ID    =   v_SCM_SITE_ID
                       AND TGT.PLANT_SITE_ID  =   v_PLANT_SITE_ID
                       AND TGT.ITEM_ID        =   v_ITEM_ID
                       AND TGT.YYYYMMDD       =   v_YYYYMMDD
                       --AND TGT.CURRENCY       =   v_CURRENCY
                       AND TGT.MEASURE        =   v_MEASURE
                       AND TGT.DOM_EXP        =   v_DOM_EXP
                       AND TGT.FCST_TYPE      =   v_FCST_TYPE
                       AND TGT.INCOTERMS      =   v_INCOTERMS
				  ) > 0;

		   -- INSERT 수행
			INSERT INTO SCM_MST_FUTURE_PRICE
					( DIVISION_ID
					,PROJECT_CODE
					,SCM_SITE_ID
					,PLANT_SITE_ID
					,ITEM_ID
					,YYYYMMDD
					,CURRENCY
					,MEASURE
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					,PRICE
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT   NVL(V_DIVISION_ID, '-')
					,NVL(V_PROJECT_CODE, '-')
					,NVL(V_SCM_SITE_ID, '-')
					,NVL(V_PLANT_SITE_ID, '-')
					,NVL(V_ITEM_ID, '-')
					,NVL(V_YYYYMMDD, '-')
					,NVL(V_CURRENCY, '-')
					,NVL(V_MEASURE, '-')
					,NVL(V_DOM_EXP, '-')
					,NVL(V_FCST_TYPE, '-')
					,NVL(V_INCOTERMS, '-')
					,cast(V_PRICE as NUMBER(20,10))
					,V_CREATED_BY
					,SYSDATE
					,V_LAST_UPDATED_BY
					,SYSDATE
				FROM GT_DMF0020_RESULTS_MST
					where v_active_flag    <> 'D';

							INSERT INTO  SCM_MST_FUTURE_PRICE_H
									   ( DIVISION_ID
										,HISTORY_SEQ
										,PROJECT_CODE
										,SCM_SITE_ID
										,PLANT_SITE_ID
										,ITEM_ID
										,YYYYMMDD
										,CURRENCY
										,MEASURE
										,DOM_EXP
										,FCST_TYPE
										,INCOTERMS
										,PRICE
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
									  )
								SELECT
										 v_DIVISION_ID
										,SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL
										,v_PROJECT_CODE
										,v_SCM_SITE_ID
										,v_PLANT_SITE_ID
										,v_ITEM_ID
										,v_YYYYMMDD
										,v_CURRENCY
										,v_MEASURE
										,v_DOM_EXP
										,v_FCST_TYPE
										,v_INCOTERMS
										,v_PRICE
										,v_CREATED_BY
										,SYSDATE
										,v_LAST_UPDATED_BY
										,SYSDATE
								 FROM  GT_DMF0020_RESULTS_MST  WHERE v_active_flag <> 'D';   -- DELETE값이 아닌경우만

						--------------------------------------------------------------------------------------  20180510 SKH ADD START
                        INSERT INTO GT_DMF0020_RESULTS
									(v_DIVISION_ID
								    ,v_PROJECT_CODE
								    ,v_SCM_SITE_ID
								    ,v_ITEM_ID
								    ,v_DOM_EXP
								    ,v_FCST_TYPE
								    ,v_INCOTERMS
								    ,v_MEASURE
								    ,v_PLANT_SITE_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_PRICE
									,v_CREATED_BY
									)

						SELECT       v_DIVISION_ID
								    ,v_PROJECT_CODE
								    ,v_SCM_SITE_ID
								    ,v_ITEM_ID
								    ,v_DOM_EXP
								    ,v_FCST_TYPE
								    ,v_INCOTERMS
								    ,v_MEASURE
								    ,v_PLANT_SITE_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_PRICE
									,v_CREATED_BY
						  FROM  GT_DMF0020_RESULTS_MST  WHERE v_active_flag <> 'D';   -- DELETE값이 아닌경우만

						-- Procedure 호출 #results 테이블의 데이터를 전달하여 처리함
						P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE;
						--------------------------------------------------------------------------------------  20180510 SKH ADD END

END;
--===================================================================================== update, insert end

  	-- 트랜잭션 (COMMIT)
        COMMIT;  -- sss
	--------------------------------------------------------------------------------------------
		EXCEPTION
			WHEN e_invalid_data THEN
				--------------------------------------------------------------
				--  	err_rtn:
				IF v_log_type = 'INVALID' THEN
						ROLLBACK TO SAVEPOINT SCM_MST_FUTURE_PRICE_ALL;
						v_log_message := '########## END of procedure @@@##########';
						v_description := 'delete_count: '|| TO_CHAR(n_delete_count) || ' / insert_count: ' || TO_CHAR(n_insert_count);
						d_event_date := SYSDATE;
						PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
				END IF;
				--------------------------------------------------------------
			WHEN OTHERS THEN
				--------------------------------------------------------------
				--[C20200909-000203] LOG 표준화 적용
				-- 트랜잭션 (END)
				ROLLBACK TO SAVEPOINT SCM_MST_FUTURE_PRICE_ALL;  -- sss

				v_log_type := 'ERROR';
				v_log_message := SUBSTR(SQLERRM, 1, 1000);
				v_description := 'ERROR_LINE : ' || TO_CHAR($$PLSQL_LINE);
				d_event_date := SYSDATE;

				v_result_message := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;  /*-- 에러메시지 DISPLAY --*/

				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
				--------------------------------------------------------------
	--------------------------------------------------------------------------------------------
		END;
	--------------------------------------------------------------------------------------------

	-- 수행결과 성공여부 DISPLAY
    IF v_log_message IS NULL THEN
		v_result_message := 'success';

	END IF;

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure @@@##########';
    v_description := 'delete_count: '|| TO_CHAR(n_delete_count) || ' / insert_count: ' || TO_CHAR(n_insert_count);
    d_event_date := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 결과셋 반환 (MSSQL SELECT 결과셋 → SYS_REFCURSOR OUT)
	OPEN p_result_cursor FOR
		SELECT v_result_message AS RESULT_MSG FROM DUAL;

END P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP;

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP
(
    p_division_id            IN  VARCHAR2,
    p_dept_id                IN  VARCHAR2,    --Department
    p_end_customer           IN  VARCHAR2,    --Endcustomer
    p_scm_site_id            IN  VARCHAR2,
    p_plant_site_id          IN  VARCHAR2,
    p_project_code           IN  VARCHAR2,
    p_item_id                IN  VARCHAR2,
    p_customer_project_code  IN  VARCHAR2,
    p_customer_model         IN  VARCHAR2,
    p_from_yyyymmdd          IN  VARCHAR2,
    p_to_yyyymmdd            IN  VARCHAR2,
    p_biztype                IN  VARCHAR2,
    p_created_by             IN  VARCHAR2,
    p_userinfo               IN  VARCHAR2,
    p_owner                  IN  VARCHAR2,
    p_over_range             IN  VARCHAR2,   -- [PJ20200138]범위 초과 Flag
    p_invalid_exec           IN  VARCHAR2,   -- [C20200612-000174] ESS사업부 New Model Flag
    O_RC1                    OUT SYS_REFCURSOR   /* [E20260824-POPCUR] P_CUR -> O_RC1 : PROC_M 계약/FE(o_rc1) 정렬 */
)
    IS
/* 2026.05.20  ZIONEX        [PJ202650304]  NextSCM Migration */

    -- SET NOCOUNT ON;
    -- SET ANSI_WARNINGS OFF;

    --SELECT 'TEST01' AS DIVISION_ID , '1' AS SCM_SITE_ID , 'M1' AS MEASURE
    --UNION ALL
    --SELECT 'TEST02' AS DIVISION_ID , '2' AS SCM_SITE_ID , 'M2' AS MEASURE

    --DECLARE @v_dept_id nvarchar(max)='';
    v_group_id          VARCHAR2(50 CHAR) := '';
    v_program_id        VARCHAR2(4000 CHAR) := 'DMF0020';       -- 20180605 수정
    v_to_yyyymmdd2      VARCHAR2(8 CHAR);                       -- [PJ20200138] 비교 날짜
    v_valid_yn          VARCHAR2(10 CHAR) := 'Y';  --[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공

    --IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
    --    SET @v_group_id = 'ADMIN'

    v_prod              CLOB;
    v_prod_pivot        CLOB;  /* 2026.08.14 AJS PIVOT IN 절 전용(상수+별칭). v_prod 는 SELECT 목록용 식별자 목록이라 형식이 다름 */
    v_nsql              CLOB;
    v_admin_cnt         NUMBER;
BEGIN

    /* [E20260824-POPDELIM] 조회조건 구분자 ',' -> '^' (실사고 2026-08-24: Sales Site 다중선택 시 0행).
       화면은 다중선택을 '^' 로 join 해 보낸다 (PriceBatchInputModal: salesSite.join('^')).
       메인 SP 는 이미 '^' 인데 이 팝업만 ',' 라서 'A^B' 가 1개 토큰으로 뭉쳐 매칭 0 이 됐다.
       ⚠ 구조는 그대로 둔다 — 이 술어들을 GTT+JOIN 으로 바꾸면 옵티마이저가 토큰 소스를
         CARD=1 로 보고 전 구간 NESTED LOOPS 로 붕괴한다(실측 1,044초). 구분자만 바꾼다.
       적용 범위: TABLE(FN_String_Split) 11곳 + 인라인 CONNECT BY REGEXP_SUBSTR 12곳 = 23곳.
       컬럼 split(SI.OWNER)은 [E20260824-OWNERSPLIT] 로 이미 문자열 연산이라 대상 아님. */


    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    SELECT NVL(COUNT(1), 0)
      INTO v_admin_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
       AND (SEGMENT1 = p_userinfo
            OR SEGMENT1 IN (SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M /* [AUTHUNION 2026-08-05] */
                            WHERE USER_ID IN (p_userinfo, p_created_by) AND USE_YN = 'Y'));

    IF v_admin_cnt > 0 THEN
        v_group_id := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    v_prod := ''; v_prod_pivot := '';

    --[C20200506-000201] 속도개선 임시테이블 #tmpItem, #tmpPlanData 추가
    -- GTT 사용: TRUNCATE 로 세션 데이터 초기화
    /* [E20260824-POPDEPT] 부서권한 1회 실현 (메인 SP [E20260824-DEPTAUTH] 와 동일 방식).
       종전: FN_GET_DEPT_LIST(p_created_by, DEPT_ID) 를 최종 동적 SELECT 에서 **행마다** 호출.
             실측 1회 조회에 38,652 회 / 579,546 LIO — 최종 SELECT 비용(2.87s)의 사실상 전부였다.
       p_created_by 는 실행 내내 상수라 허용 부서 집합이 고정 -> GTT 1회 적재 후 대조로 판정.
       동등성: 함수는 MA.SEGMENT3 = P_DEPT_ID 존재 여부만 본다(NULL 은 = 비교에서 항상 거짓). */
    DELETE FROM SCM_MGR.GT_DMF0020_DEPT_AUTH;
    INSERT INTO SCM_MGR.GT_DMF0020_DEPT_AUTH (DEPT_ID, HAS_AUTH)
    SELECT DISTINCT MA.SEGMENT3, 'Y'
      FROM ( SELECT LOOK.SEGMENT3
               FROM SCM_MGR.SCM_ADM_USER_M USR
                  , SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
              WHERE USR.DEPT_ID = LOOK.SEGMENT1
                AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                AND LOOK.VALID_YN = 'Y'
                AND UPPER(USR.USER_ID) = UPPER(p_created_by)
             UNION ALL
             SELECT DEPT_ID
               FROM SCM_MGR.SCM_ADM_USER_M
              WHERE UPPER(USER_ID) = UPPER(p_created_by) ) MA
     WHERE MA.SEGMENT3 IS NOT NULL;

    DELETE FROM GT_DMF0020_ITEM;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */
    DELETE FROM GT_DMF0020_PLAN_DATA;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */
    DELETE FROM GT_DMF0020_DATA;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */
    DELETE FROM GT_DMF0020_OUTPUT;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */
    -- [PJ20200138] 범위를 초과하는 대상 테이블
    DELETE FROM GT_DMF0020_OVER_RANGE;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */
    DELETE FROM GT_DMF0020_OVER_RANGE_LIST;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */
    --[C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
    DELETE FROM GT_DMF0020_SALES_SITE_MODEL_ALL;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */
    DELETE FROM GT_DMF0020_SALES_SITE_MODEL;   /* [E20260824-GTTDEL] TRUNCATE(DDL 배타락) -> DELETE */


    -- [PJ20200138] 범위 초과 대상
    IF (p_over_range = 'Y') THEN
        v_to_yyyymmdd2 := TO_CHAR(TO_DATE(p_to_yyyymmdd, 'YYYYMMDD') + 7, 'YYYYMMDD');

        INSERT INTO GT_DMF0020_OVER_RANGE (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, YYYYMMDD)
        SELECT DISTINCT AA.DIVISION_ID, AA.PROJECT_CODE, AA.SCM_SITE_ID, AA.PLANT_SITE_ID, AA.ITEM_ID, AA.CURRENCY, AA.MEASURE, AA.DOM_EXP, AA.FCST_TYPE, AA.INCOTERMS, AA.YYYYMMDD
          FROM
            -- 기준데이터
            (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
                , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS ROW_NO
            FROM SCM_MST_FUTURE_PRICE  A
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'LOC'
            AND   YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
            ) AA,
            -- 비교용 데이터 ( 다음주 )
            (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, YYYYMMDD
                , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS ROW_NO
            FROM SCM_MST_FUTURE_PRICE   A
            WHERE DIVISION_ID = p_division_id
            AND   MEASURE = 'LOC'
            AND   YYYYMMDD BETWEEN p_from_yyyymmdd AND v_to_yyyymmdd2
            ) BB,
            -- 비교용 데이터 ( 직전주차-없으면 마지막 주차 )
            (
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
                , A.YYYYMMDD
            FROM SCM_MST_FUTURE_PRICE  A,
                (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
                    , MAX(YYYYMMDD) AS YMD
                FROM SCM_MST_FUTURE_PRICE  A
                WHERE DIVISION_ID = p_division_id
                AND   MEASURE = 'LOC'
                AND   YYYYMMDD < p_from_yyyymmdd
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
                ) B
                WHERE A.DIVISION_ID = B.DIVISION_ID
                    AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                    AND A.ITEM_ID = B.ITEM_ID
                    AND A.CURRENCY = B.CURRENCY
                    AND A.MEASURE = B.MEASURE
                    AND A.DOM_EXP = B.DOM_EXP
                    AND A.FCST_TYPE = B.FCST_TYPE
                    AND A.INCOTERMS = B.INCOTERMS
                    AND A.YYYYMMDD = B.YMD
            ) CC,
            (SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS LIMIT_RATE
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE  VALID_YN = 'Y'
                AND    LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE' ) L
         WHERE AA.DIVISION_ID = BB.DIVISION_ID(+)
           AND AA.PROJECT_CODE = BB.PROJECT_CODE(+)
           AND AA.SCM_SITE_ID = BB.SCM_SITE_ID(+)
           AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID(+)
           AND AA.ITEM_ID = BB.ITEM_ID(+)
           AND AA.CURRENCY = BB.CURRENCY(+)
           AND AA.MEASURE = BB.MEASURE(+)
           AND AA.DOM_EXP = BB.DOM_EXP(+)
           AND AA.FCST_TYPE = BB.FCST_TYPE(+)
           AND AA.INCOTERMS = BB.INCOTERMS(+)
           AND AA.ROW_NO = BB.ROW_NO(+) + 1
           AND AA.DIVISION_ID = CC.DIVISION_ID(+)
           AND AA.PROJECT_CODE = CC.PROJECT_CODE(+)
           AND AA.SCM_SITE_ID = CC.SCM_SITE_ID(+)
           AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID(+)
           AND AA.ITEM_ID = CC.ITEM_ID(+)
           AND AA.CURRENCY = CC.CURRENCY(+)
           AND AA.MEASURE = CC.MEASURE(+)
           AND AA.DOM_EXP = CC.DOM_EXP(+)
           AND AA.FCST_TYPE = CC.FCST_TYPE(+)
           AND AA.INCOTERMS = CC.INCOTERMS(+)
           AND AA.ROW_NO = 1
           AND AA.DIVISION_ID = L.DIVISION_ID
           AND CASE WHEN AA.ROW_NO = '1'  AND (AA.PRICE * L.LIMIT_RATE) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
                    WHEN AA.ROW_NO <> '1' AND (BB.PRICE * L.LIMIT_RATE) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
                    ELSE 'N'
               END = 'Y';


        INSERT INTO GT_DMF0020_OVER_RANGE_LIST (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS, COL_LIST)
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
            ,REPLACE(NVL("1",''),',','') ||NVL("2",'') ||NVL("3",'') ||NVL("4",'')||NVL("5",'')||NVL("6",'')||NVL("7",'')||NVL("8",'')||NVL("9",'')||NVL("10",'')
            ||NVL("11",'')||NVL("12",'')||NVL("13",'')||NVL("14",'')||NVL("15",'')||NVL("16",'')||NVL("17",'')||NVL("18",'')||NVL("19",'')||NVL("20",'')
            ||NVL("21",'')||NVL("22",'')||NVL("23",'')||NVL("24",'')||NVL("25",'')||NVL("26",'')||NVL("27",'')||NVL("28",'')||NVL("29",'')||NVL("30",'')
            ||NVL("31",'')||NVL("32",'')||NVL("33",'')||NVL("34",'')||NVL("35",'')||NVL("36",'')||NVL("37",'')||NVL("38",'')||NVL("39",'')||NVL("40",'')
            ||NVL("41",'')||NVL("42",'')||NVL("43",'')||NVL("44",'')||NVL("45",'')||NVL("46",'')||NVL("47",'')||NVL("48",'')||NVL("49",'')||NVL("50",'')
            ||NVL("51",'')||NVL("52",'') AS COL_LIST
        FROM (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, ',W_' || YYYYMMDD AS YYYYMMDD
                , ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD ) AS ROW_NUM
            FROM GT_DMF0020_OVER_RANGE
            ) A
        PIVOT (
            MAX(YYYYMMDD) FOR ROW_NUM IN ( 1 AS "1",2 AS "2",3 AS "3",4 AS "4",5 AS "5",6 AS "6",7 AS "7",8 AS "8",9 AS "9",10 AS "10"
                                            ,11 AS "11",12 AS "12",13 AS "13",14 AS "14",15 AS "15",16 AS "16",17 AS "17",18 AS "18",19 AS "19",20 AS "20"
                                            ,21 AS "21",22 AS "22",23 AS "23",24 AS "24",25 AS "25",26 AS "26",27 AS "27",28 AS "28",29 AS "29",30 AS "30"
                                            ,31 AS "31",32 AS "32",33 AS "33",34 AS "34",35 AS "35",36 AS "36",37 AS "37",38 AS "38",39 AS "39",40 AS "40"
                                            ,41 AS "41",42 AS "42",43 AS "43",44 AS "44",45 AS "45",46 AS "46",47 AS "47",48 AS "48",49 AS "49",50 AS "50"
                                            ,51 AS "51",52 AS "52" )
            ) UNPVT;




    END IF;


    --[C20200506-000201] 속도개선 임시테이블 #tmpItem, #tmpPlanData 추가

    INSERT INTO GT_DMF0020_ITEM (DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, FORECAST_INFO_BIZ_TYPE, ITEM_TYPE)
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, FORECAST_INFO_BIZ_TYPE, ITEM_TYPE
    FROM DM_MST_ITEM_SINGLE_V
    WHERE DIVISION_ID = p_division_id;

    INSERT INTO GT_DMF0020_PLAN_DATA (DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP)
    SELECT
       A.DIVISION_ID,
       A.SCM_SITE_ID,
       A.PLANT_SITE_ID,
       A.PROJECT_CODE,
       A.ITEM_ID,
       A.INCOTERMS,
       A.CURRENCY,
       A.FCST_TYPE,
       A.DOM_EXP
    FROM SCM_MST_FUTURE_PRICE A
    WHERE   (A.YYYYMMDD >= p_from_yyyymmdd and A.YYYYMMDD <= p_to_yyyymmdd)
            AND CASE WHEN p_division_id = 'ALL' THEN 'ALL'
                     ELSE A.DIVISION_ID
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_division_id, '[^^]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_division_id, '[^^]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.column_value
                       )
            AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
                     ELSE A.SCM_SITE_ID
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_scm_site_id, '[^^]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_scm_site_id, '[^^]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.column_value
                       )
            AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL'
                     ELSE A.PLANT_SITE_ID
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_plant_site_id, '[^^]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_plant_site_id, '[^^]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.column_value
                       )
            -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (START)
            AND EXISTS (  SELECT B.DIVISION_ID
                                FROM SCM_MST_SITE B
                                WHERE A.DIVISION_ID   = B.DIVISION_ID
                                AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                AND B.VALID_YN    = 'Y' )
            AND EXISTS (  SELECT B.DIVISION_ID
                               FROM SCM_MST_SITE_ITEM B
                              WHERE A.DIVISION_ID    = B.DIVISION_ID
                                AND A.PROJECT_CODE  = B.PROJECT_CODE
                                AND A.SCM_SITE_ID    = B.SCM_SITE_ID
                                AND A.ITEM_ID        = B.ITEM_ID
                                AND B.VALID_YN    = 'Y'   )
            -- 20180816 KHSONG 미래구간은 VALID_YN='Y' 인것만 추출 (END)
    GROUP BY
       A.DIVISION_ID,
       A.SCM_SITE_ID,
       A.PLANT_SITE_ID,
       A.PROJECT_CODE,
       A.ITEM_ID,
       A.INCOTERMS,
       A.CURRENCY,
       A.FCST_TYPE,
       A.DOM_EXP;



    /* 2026.08.14 AJS PJT 원본을 물리 GTT 에 1회 실현 후 hash join */
    DELETE FROM SCM_MGR.GT_DMF0020_PJT;
    INSERT INTO SCM_MGR.GT_DMF0020_PJT (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PROJECT_OWNER,
        PROJECT_STATUS, BIZ_TYPE, SCM_SITE_ID, ITEM_ID, DEPT_ID, DEPT_NAME_KO, USER_ID, USER_NAME, USER_NAME_EN)
            SELECT B.DIVISION_ID
                , B.PROJECT_CODE
                , B.PROJECT_NAME
                , B.PROJECT_OWNER
                , B.PROJECT_STATUS
                , B.BIZ_TYPE
                , '' SCM_SITE_ID
                , '' ITEM_ID
                , '' DEPT_ID
                , '' DEPT_NAME_KO
                ,SU.USER_ID
                ,SU.USER_NAME
                ,SU.USER_NAME_EN
            FROM SCM_MST_PROJECT B
                ,SCM_MST_SSO_USER_INFO SU
            WHERE B.DIVISION_ID <> '40'
                AND B.DIVISION_ID = p_division_id /* 2026.08.14 AJS 전 사업부 실현 방지(성능) */
                AND UPPER(TRIM(B.PROJECT_OWNER)) = UPPER(TRIM(SU.USER_ID)) /* 2026.08.14 AJS MSSQL CI collation 대응 */
            UNION
            SELECT SI.DIVISION_ID
                ,SI.PROJECT_CODE PROJECT_CODE
                ,'' PROJECT_NAME
                ,SI.OWNER PROJECT_OWNER
                ,'' PROJECT_STATUS
                ,'' BIZ_TYPE
                ,SI.SCM_SITE_ID
                ,SI.ITEM_ID
                ,SI.DEPT_ID  -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기) (AS-IS: SU.DEPT_ID)
                ,TM.DEPT_NAME_KO
                ,SU.USER_ID
                ,SU.USER_NAME
                ,SU.USER_NAME_EN
        -- 20180810 ------------------------------------------
                FROM SCM_MST_SITE_ITEM SI

                    LEFT JOIN SCM_MST_SSO_USER_INFO SU
                        ON UPPER(TRIM(SU.USER_ID)) = UPPER(TRIM((CASE WHEN INSTR(SI.OWNER, ',') > 0 THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1) ELSE SI.OWNER END))) /* 2026.08.14 AJS 동일 사유 */   /* [E20260824-OWNERSPLIT] 컬럼을 행마다 split -> 파이프라인 함수가 LATERAL(VW_LAT_) 로 변환되어 MERGE JOIN OUTER + BUFFER SORT, cost 5.6e10. 문자열 연산으로 대체(첫 토큰 동일) */

                    LEFT JOIN SCM_MST_SSO_DEPT_INFO TM
                        ON SI.DEPT_ID = TM.DEPT_ID  -- 2026-09-06 hook#150 AJS (AS-IS: SU.DEPT_ID)

            WHERE SI.DIVISION_ID = '40'
                  AND p_division_id = '40' /* 2026.08.14 AJS 40 전용 분기 - 타 사업부 조회 시 SITE_ITEM 전건 상관서브쿼리 실행 방지 */
            -- 20180810 ------------------------------------------
    ;

    INSERT INTO GT_DMF0020_DATA (DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS, PROJECT_OWNER, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP, AUTHORITY_YN, NICK_NAME)
    SELECT
       A.DIVISION_ID,
       B.DIVISION_NAME,
       DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
       --TEAM.DEPT_ID,         --20180625
       CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END DEPT_ID,
       --CASE WHEN isnull(TEAM.DEPT_NAME_KO,'') = '' THEN '' ELSE RIGHT(isnull(TEAM.DEPT_NAME_KO,''), CHARINDEX('.',REVERSE(isnull(TEAM.DEPT_NAME_KO,''))) -1) END AS TEAM_INCHARGE,
       A.SCM_SITE_ID,
       A.PLANT_SITE_ID,
       C.SITE_DESCRIPTION,
       NVL(C.END_CUSTOMER,'') AS END_CUSTOMER,
       A.PROJECT_CODE,
       PJT.PROJECT_NAME,
       PJT.BIZ_TYPE as BIZ_TYPE_NAME,
       --PJT.BIZ_TYPE_NAME,
       PJT.PROJECT_STATUS,
       PJT.PROJECT_OWNER,
       A.ITEM_ID,
       ITEM.ITEM_CLASS_NAME,
       NVL(ITEM.ITEM_NAME,'') AS ITEM_NAME,
       A.INCOTERMS,
       --SITE_ITEM.CURRENCY,
       A.CURRENCY,
       A.FCST_TYPE,
       A.DOM_EXP,
       --MEASURE.LOOKUP_CODE AS MEASURE,
       --MEASURE.DISPLAY_SEQ,
       --CASE WHEN (RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
       /* [E20260824-POPDEPT] FN_GET_DEPT_LIST 행별 호출 -> GTT 대조 (DEPT_ID DISTINCT 적재라 행 증식 없음) */
       CASE WHEN (NVL((SELECT MAX(DA.HAS_AUTH) FROM SCM_MGR.GT_DMF0020_DEPT_AUTH DA
                        WHERE DA.DEPT_ID = CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END), 'N') = 'Y'
                  OR v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
       --,A.YYYYMMDD
       ,ITEM.NICK_NAME --20180711
       --,A.PRICE
    FROM GT_DMF0020_PLAN_DATA A
        INNER JOIN SCM_MST_DIVISION B
            ON A.DIVISION_ID = B.DIVISION_ID
            AND B.VALID_YN = 'Y'

        INNER JOIN SCM_MST_SITE C
            ON  A.DIVISION_ID = C.DIVISION_ID
            AND A.SCM_SITE_ID = C.SCM_SITE_ID
            AND C.SITE_TYPE = 'SALES'
            AND C.VALID_YN = 'Y'

        LEFT JOIN SCM_MST_SITE D
            ON  A.DIVISION_ID = D.DIVISION_ID
            AND A.SCM_SITE_ID = D.SCM_SITE_ID
            AND C.SITE_TYPE = 'PLANT'
            AND D.VALID_YN = 'Y'

        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            -- [hook#150 2026-09-06 AJS] AS-IS: ON C.DEPT_ID = TEAM.DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: AND TEAM.VALID_YN = 'Y'

        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT
            -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: AND DEPRTMENT.VALID_YN = 'Y'

        INNER JOIN GT_DMF0020_ITEM ITEM
            ON  A.DIVISION_ID = ITEM.DIVISION_ID
            AND A.ITEM_ID  = ITEM.ITEM_ID
        LEFT JOIN GT_DMF0020_PJT PJT /* 2026.08.14 AJS 물리 GTT 사전 실현 (인라인 서브쿼리를 옵티마이저가 decorrelate -> 카테시안 폭발) */
            ON  A.DIVISION_ID = PJT.DIVISION_ID
            AND A.PROJECT_CODE = PJT.PROJECT_CODE
            AND CASE WHEN p_division_id = '40' THEN PJT.SCM_SITE_ID ELSE A.SCM_SITE_ID END =  A.SCM_SITE_ID    -- modified by ytchoi 180802
            AND CASE WHEN p_division_id = '40' THEN PJT.ITEM_ID ELSE A.ITEM_ID END = A.ITEM_ID

        LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y') SITE_ITEM
            ON SITE_ITEM.DIVISION_ID = A.DIVISION_ID
            AND SITE_ITEM.PROJECT_CODE = A.PROJECT_CODE
            AND SITE_ITEM.SCM_SITE_ID = A.SCM_SITE_ID
            AND SITE_ITEM.ITEM_ID = A.ITEM_ID
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기) / TEAM,DEPRTMENT 조인을 SITE_ITEM 뒤로 이동
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
            ON SITE_ITEM.DEPT_ID = TEAM.DEPT_ID
            AND TEAM.VALID_YN = 'Y'
        LEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT
            ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
            AND DEPRTMENT.VALID_YN = 'Y'

        LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO    --20180724
            ON SITE_ITEM.OWNER = USER_INFO.USER_ID
            -------------------------- Project --------------2018/07/30  Son Young Suk---------------------
                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_project_code, '^')) WHERE p_project_code IS NOT NULL AND p_project_code NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_project_code IS NULL OR p_project_code IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b1
                ON (b1.tst IS NULL OR PJT.PROJECT_CODE like b1.tst OR PJT.PROJECT_NAME like b1.tst)
            -----------------------------------------------------------------------------------------------
        ------------  20180806  -------------------------------------------------------------------
        INNER JOIN (
                        SELECT DISTINCT X.OWNER
                            FROM SCM_MST_SITE_ITEM X
                            LEFT JOIN SCM_MST_SSO_USER_INFO UI
                            ON X.PROJECT_CODE = UI.USER_ID
                            INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_owner, '^')) WHERE p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_owner IS NULL OR p_owner IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) c
                  ON (c.tst IS NULL OR FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') like c.tst
                      OR X.OWNER like c.tst
                      OR FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') like c.tst)
                        where X.DIVISION_ID = p_division_id
                            AND p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-')
                            UNION all
                            select '11' FROM DUAL
                            where p_owner IN ('','ALL','-')
            ) X
        ON  NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN (p_owner IS NULL OR p_owner IN ('ALL','-')) THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END
        -----------------------------------------------------------------------------------------------
        /*CROSS JOIN
        (
        SELECT  COLUMN_NAME AS LOOKUP_CODE,
                COLUMN_LABEL_NAME AS "DESCRIPTION",
                SORT_ORDER_NO AS DISPLAY_SEQ
        FROM     SCM_MST_SHEET_MEASURE
            WHERE  (PROGRAM_ID = @p_program_id AND SHEET_NAME = 'Sales Price')
                    AND COLUMN_NAME <> 'LOC'

        UNION

        SELECT  COLUMN_NAME AS LOOKUP_CODE,
                COLUMN_LABEL_NAME AS [DESCRIPTION],
                SORT_ORDER_NO AS DISPLAY_SEQ
        FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
            WHERE  (PROGRAM_ID = @p_program_id AND SHEET_NAME = 'Sales Price')
                    AND COLUMN_NAME = 'LOC'
        ) AS MEASURE*/

    WHERE   1=1
            AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
                     --ELSE TEAM.DEPT_ID
                     ELSE CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_dept_id, '[^^]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_dept_id, '[^^]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE
                            --TEAM.DEPT_ID
                            CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
                        END) = P.column_value
                       )
            AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
                     ELSE NVL(
                        CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END
                     ,'')
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_end_customer, '[^^]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_end_customer, '[^^]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
                            CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END
                        ,'') END) = P.column_value
                       )
            AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'  --20180822
                     ELSE --PJT.BIZ_TYPE
                        CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
                END IN (
                        Select column_value from ( SELECT TRIM(REGEXP_SUBSTR(p_biztype, '[^^]+', 1, LEVEL)) AS column_value
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(p_biztype, '[^^]+', 1, LEVEL) IS NOT NULL ) P Where
                        (CASE WHEN p_biztype = 'ALL' THEN 'ALL' ELSE
                        --PJT.BIZ_TYPE
                        CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
                        END) = P.column_value
                       )
    GROUP BY
            A.DIVISION_ID,
            B.DIVISION_NAME,
            DEPRTMENT.DEPT_ID,
            TEAM.DEPT_ID,
            PJT.DEPT_ID,
            A.SCM_SITE_ID,
            A.PLANT_SITE_ID,
            C.SITE_DESCRIPTION,
            NVL(C.END_CUSTOMER,''),
            A.PROJECT_CODE,
            PJT.PROJECT_NAME,
            PJT.BIZ_TYPE,
            PJT.PROJECT_STATUS,
            PJT.PROJECT_OWNER,
            A.ITEM_ID,
            ITEM.ITEM_CLASS_NAME,
            NVL(ITEM.ITEM_NAME,''),
            A.INCOTERMS,
            A.FCST_TYPE,
            A.DOM_EXP,
            A.CURRENCY,
            --MEASURE.LOOKUP_CODE,
            --MEASURE.DISPLAY_SEQ,
            --CASE WHEN RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) THEN 'Y' ELSE 'N' END  --20200312 KHSONG @v_dept_id 값이 셋팅되는 곳이 없어서 필요없는 조건으로 주석처리
            --A.YYYYMMDD,
            ITEM.NICK_NAME;


    -- CREATE INDEX IDX_PRICE_KEYS ON #tmpData(DIVISION_ID ASC, PROJECT_CODE ASC, SCM_SITE_ID ASC, PLANT_SITE_ID ASC, ITEM_ID ASC, CURRENCY ASC, DOM_EXP ASC, FCST_TYPE ASC, INCOTERMS ASC );
    -- Oracle GTT 인덱스는 GTT DDL 파일에 사전 정의


    -- CREATE TABLE #tmpOutput (DIVISION_ID NVARCHAR(30) ... );
    -- Oracle GTT 사전 정의

    -- 1. 실데이타와 조인

    -- [PJ20200138] 범위 초과 대상
    IF (p_over_range = 'Y') THEN
        INSERT INTO GT_DMF0020_OUTPUT (DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION, END_CUSTOMER, END_CUSTOMER40, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP, MEASURE, DISPLAY_SEQ, AUTHORITY_YN, YYYYMMDD, PRICE, NICK_NAME, COL_LIST)
        SELECT
                A.DIVISION_ID,
                A.DIVISION_NAME,
                A.UPPER_DEPT_ID,
                A.DEPT_ID    ,
                A.SCM_SITE_ID,
                A.PLANT_SITE_ID,
                A.SITE_DESCRIPTION,
                A.END_CUSTOMER,
                A.PROJECT_CODE AS END_CUSTOMER40,
                A.PROJECT_CODE,
                A.PROJECT_NAME,
                A.BIZ_TYPE_NAME,
                A.PROJECT_STATUS,
                A.ITEM_ID,
                A.ITEM_CLASS_NAME,
                A.ITEM_NAME,
                A.INCOTERMS,
                A.CURRENCY,
                A.FCST_TYPE,
                A.DOM_EXP,
                B.MEASURE,
                MEASURE.DISPLAY_SEQ,
                A.AUTHORITY_YN,
                'W_' || B.YYYYMMDD AS YYYYMMDD,
                NVL(B.PRICE,0) AS PRICE
                , A.NICK_NAME
                , C.COL_LIST
        FROM GT_DMF0020_DATA A
            JOIN SCM_MST_FUTURE_PRICE B
                ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.CURRENCY = B.CURRENCY
                   --AND A.MEASURE = B.MEASURE
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   --AND A.YYYYMMDD = B.YYYYMMDD
            JOIN   GT_DMF0020_OVER_RANGE_LIST C
                ON A.DIVISION_ID = C.DIVISION_ID
                   AND A.PROJECT_CODE = C.PROJECT_CODE
                   AND A.SCM_SITE_ID = C.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
                   AND A.ITEM_ID = C.ITEM_ID
                   AND A.CURRENCY = C.CURRENCY
                   --AND A.MEASURE = C.MEASURE
                   AND A.DOM_EXP = C.DOM_EXP
                   AND A.FCST_TYPE = C.FCST_TYPE
                   AND A.INCOTERMS = C.INCOTERMS
                   --AND A.YYYYMMDD = C.YYYYMMDD
            -------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
            INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_item_id, '^')) WHERE p_item_id IS NOT NULL AND p_item_id NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_item_id IS NULL OR p_item_id IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b2
                ON (b2.tst IS NULL OR A.ITEM_ID like b2.tst OR A.NICK_NAME like b2.tst)
            -----------------------------------------------------------------------------------------------
            JOIN (  SELECT  COLUMN_NAME AS LOOKUP_CODE,
                            COLUMN_LABEL_NAME AS "DESCRIPTION",
                            SORT_ORDER_NO AS DISPLAY_SEQ
                    FROM    SCM_MST_SHEET_MEASURE
                    WHERE  (PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price') ) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
        WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
              AND B.MEASURE = 'LOC';   /* [E20260824-LOCONLY] 최종 SELECT 는 LOC 만 소비한다 */ --[PJ20200138] 속도개선
    ELSE
        INSERT INTO GT_DMF0020_OUTPUT (DIVISION_ID, DIVISION_NAME, UPPER_DEPT_ID, DEPT_ID, SCM_SITE_ID, PLANT_SITE_ID, SITE_DESCRIPTION, END_CUSTOMER, END_CUSTOMER40, PROJECT_CODE, PROJECT_NAME, BIZ_TYPE_NAME, PROJECT_STATUS, ITEM_ID, ITEM_CLASS_NAME, ITEM_NAME, INCOTERMS, CURRENCY, FCST_TYPE, DOM_EXP, MEASURE, DISPLAY_SEQ, AUTHORITY_YN, YYYYMMDD, PRICE, NICK_NAME, COL_LIST)
        SELECT
                A.DIVISION_ID,
                A.DIVISION_NAME,
                A.UPPER_DEPT_ID,
                A.DEPT_ID    ,
                A.SCM_SITE_ID,
                A.PLANT_SITE_ID,
                A.SITE_DESCRIPTION,
                A.END_CUSTOMER,
                A.PROJECT_CODE AS END_CUSTOMER40,
                A.PROJECT_CODE,
                A.PROJECT_NAME,
                A.BIZ_TYPE_NAME,
                A.PROJECT_STATUS,
                A.ITEM_ID,
                A.ITEM_CLASS_NAME,
                A.ITEM_NAME,
                A.INCOTERMS,
                A.CURRENCY,
                A.FCST_TYPE,
                A.DOM_EXP,
                B.MEASURE,
                MEASURE.DISPLAY_SEQ,
                A.AUTHORITY_YN,
                'W_' || B.YYYYMMDD AS YYYYMMDD,
                NVL(B.PRICE,0) AS PRICE
                , A.NICK_NAME
                , '' AS COL_LIST
        FROM GT_DMF0020_DATA A
            JOIN SCM_MST_FUTURE_PRICE B
                ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.CURRENCY = B.CURRENCY
                   --AND A.MEASURE = B.MEASURE
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   --AND A.YYYYMMDD = B.YYYYMMDD
            -------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
            INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_item_id, '^')) WHERE p_item_id IS NOT NULL AND p_item_id NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_item_id IS NULL OR p_item_id IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b2
                ON (b2.tst IS NULL OR A.ITEM_ID like b2.tst OR A.NICK_NAME like b2.tst)
            -----------------------------------------------------------------------------------------------
            JOIN (  SELECT  COLUMN_NAME AS LOOKUP_CODE,
                            COLUMN_LABEL_NAME AS "DESCRIPTION",
                            SORT_ORDER_NO AS DISPLAY_SEQ
                    FROM    SCM_MST_SHEET_MEASURE
                    WHERE  (PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'Sales Price') ) MEASURE
                ON B.MEASURE = MEASURE.LOOKUP_CODE
        WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
              AND B.MEASURE = 'LOC';   /* [E20260824-LOCONLY] 최종 SELECT 는 LOC 만 소비한다 */ --[PJ20200138] 속도개선
    END IF;

    -----------------------------------------------------------------------------------------------

    ------ 월 데이터 평균 값 산정
    ----INSERT #tmpOutput
    ----SELECT
    ----        A.DIVISION_ID,
    ----        A.DIVISION_NAME,
    ----        A.UPPER_DEPT_ID,
    ----        A.DEPT_ID    ,
    ----        A.SCM_SITE_ID,
    ----        A.PLANT_SITE_ID,
    ----        A.SITE_DESCRIPTION,
    ----        A.END_CUSTOMER,
    ----        A.PROJECT_CODE AS END_CUSTOMER40,
    ----        A.PROJECT_CODE,
    ----        A.PROJECT_NAME,
    ----        A.BIZ_TYPE_NAME,
    ----        A.PROJECT_STATUS,
    ----        A.ITEM_ID,
    ----        A.ITEM_CLASS_NAME,
    ----        A.ITEM_NAME,
    ----        A.INCOTERMS,
    ----        A.CURRENCY,
    ----        A.FCST_TYPE,
    ----        A.DOM_EXP,
    ----        A.MEASURE,
    ----        A.DISPLAY_SEQ,
    ----        A.AUTHORITY_YN,
    ----        'M_' + SUBSTRING(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6) + '01' AS YYYYMMDD,
    ----        --MIN(ISNULL(PRICE, 0)) AS PRICE
    ----        SUM(ISNULL(PRICE, 0)) / COUNT(YYYYMMDD) AS PRICE
    ----        , A.NICK_NAME
    ----        , A.COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
    ----FROM #tmpOutput  AS A
    ----group by A.DIVISION_ID,
    ----        A.DIVISION_ID,
    ----        A.DIVISION_NAME,
    ----        A.UPPER_DEPT_ID,
    ----        A.DEPT_ID    ,
    ----        A.SCM_SITE_ID,
    ----        A.PLANT_SITE_ID,
    ----        A.SITE_DESCRIPTION,
    ----        A.END_CUSTOMER,
    ----        A.END_CUSTOMER40,
    ----        A.PROJECT_CODE,
    ----        A.PROJECT_NAME,
    ----        A.BIZ_TYPE_NAME,
    ----        A.PROJECT_STATUS,
    ----        A.ITEM_ID,
    ----        A.ITEM_CLASS_NAME,
    ----        A.ITEM_NAME,
    ----        A.INCOTERMS,
    ----        A.CURRENCY,
    ----        A.FCST_TYPE,
    ----        A.DOM_EXP,
    ----        A.MEASURE,
    ----        A.DISPLAY_SEQ,
    ----        A.AUTHORITY_YN,
    ----        A.NICK_NAME,
    ----        A.COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
    ----        SUBSTRING(REPLACE(A.YYYYMMDD, 'W_', ''), 1, 6)

    /* tmpPlanData 에 대한 처리들  */
    FOR rec IN (SELECT DISTINCT YYYYMMDD FROM GT_DMF0020_OUTPUT) LOOP
        v_prod       := v_prod       || '"' || rec.YYYYMMDD || '",';
        v_prod_pivot := v_prod_pivot || '''' || rec.YYYYMMDD || ''' AS "' || rec.YYYYMMDD || '",';  /* 2026.08.14 AJS PIVOT IN 절은 상수값 필요(식별자만 넣으면 ORA-56901) */
    END LOOP;

    IF v_prod IS NULL OR v_prod = '' THEN
        v_prod := '"D_99999999"'; v_prod_pivot := '''D_99999999'' AS "D_99999999"';
    ELSE
        v_prod := SUBSTR(v_prod, 1, LENGTH(v_prod) - 1);
        v_prod_pivot := SUBSTR(v_prod_pivot, 1, LENGTH(v_prod_pivot) - 1);
    END IF;


    --Start [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
    IF p_division_id = '82' and p_invalid_exec = 'N' THEN

            INSERT INTO GT_DMF0020_SALES_SITE_MODEL_ALL (DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40, PROJECT_CODE, PROJECT_NAME, PROJECT_STATUS, SALES_PLAN_ADJUST_YN, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY)
            SELECT   SITE_PROJECT.DIVISION_ID,
                            TEAM.DEPT_ID,
                            SITE.END_CUSTOMER,
                            SITE.END_CUSTOMER AS END_CUSTOMER40,
                            SITE_PROJECT.SCM_SITE_ID,
                            SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40,
                            SITE_PROJECT.PROJECT_CODE,
                            PJT.PROJECT_NAME,
                            PJT.PROJECT_STATUS,
                            SITE_ITEM.SALES_PLAN_ADJUST_YN,
                            SITE_ITEM.ITEM_CLASS_NAME,
                            SITE_ITEM.ITEM_ID,
                            SITE_ITEM.ITEM_NAME,
                            SITE_ITEM.NICK_NAME,
                            SITE_ITEM.CURRENCY

            FROM           (SELECT  A.DIVISION_ID,
                                    SCM_SITE_ID,
                                    PROJECT_CODE,
                                    NVL(MAX(VALID_YN),'Y') AS VALID_YN
                            FROM    SCM_MST_SITE_ITEM A
                                    ,SCM_MST_ITEM_SN B
                            WHERE   A.ITEM_ID = B.ITEM_ID
                            /* [E20260824-POPDIV] division 술어 pushdown.
                               종전: 전 사업부 SITE_ITEM(117,866) x ITEM_SN(789,067) 을 조인/집계한 뒤
                                     바깥 WHERE 에서 division 을 걸렀다 -> 인라인뷰 결과 6,129행 중 82 는 2,155행(35%)만 필요.
                               안전 근거: 이 블록은 IF p_division_id = '82' 가드 안에서만 실행되고(단일값 확정),
                                     바깥 필터도 SITE_PROJECT.DIVISION_ID IN (p_division_id 토큰) 이라 집합이 동일하다.
                               DISTINCT 제거: GROUP BY 가 이미 중복을 없앤다(동일 결과, 중복 정렬 제거). */
                            AND     A.DIVISION_ID = p_division_id
                            GROUP BY A.DIVISION_ID,
                                        SCM_SITE_ID,
                                        PROJECT_CODE
                                                            )                   SITE_PROJECT
            LEFT JOIN       SCM_MST_PROJECT                                  PJT
            ON              SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
            AND             SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID
            LEFT JOIN       SCM_MST_SITE                                     SITE
            ON              SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
            AND             SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN       SCM_MST_SSO_DEPT_INFO                            TEAM
            -- [hook#150 2026-09-06 AJS] AS-IS: ON              SITE.DEPT_ID = TEAM.DEPT_ID

            LEFT JOIN       (SELECT T1.DIVISION_ID,
                                    T1.SCM_SITE_ID,
                                    T1.PROJECT_CODE,
                                    T1.ITEM_ID,
                                    T2.ITEM_NAME,
                                    T2.ITEM_TYPE,
                                    T2.ITEM_CLASS_NAME,
                                    T1.SALES_PLAN_ADJUST_YN,
                                    T2.NICK_NAME,
                                    T1.CURRENCY,
                                    T1.VALID_YN,
                                    T1.OWNER,
                                    T1.PARTIAL_PLAN_YN, T1.DEPT_ID /* 2026-09-06 hook#150 AJS */ --[C20200610-000265] ESS - Project 별 Ship Plan (Partial) Flag 추가
                                    -----------------------
                                FROM    SCM_MST_SITE_ITEM       T1
                                JOIN    DM_MST_ITEM_SINGLE_V    T2
                                ON  T1.DIVISION_ID = T2.DIVISION_ID
                                AND T1.ITEM_ID   = T2.ITEM_ID

                                WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END
                                OR   T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END)
                                                            )                   SITE_ITEM

            ON              SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
            AND             SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
            AND             SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
            -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
            LEFT JOIN       SCM_MST_SSO_DEPT_INFO                            TEAM
            ON              SITE_ITEM.DEPT_ID = TEAM.DEPT_ID

            LEFT JOIN       SCM_MST_SITE_CUSTOMER                            SITE_CUST
            ON              SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
            AND             SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
            AND             SITE_CUST.REP_YN      = 'Y'

            LEFT JOIN       SCM_MST_CUSTOMER                                 CUST
            ON              SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
            AND             SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
            AND             SITE_CUST.DIVISION_ID = CUST.DIVISION_ID

            LEFT JOIN       (SELECT DIVISION_ID,
                                        MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
                                        SCM_SITE_ID,
                                        PROJECT_CODE,
                                        ITEM_ID
                                FROM   DM_MST_CUSTOMER_MODEL
                                WHERE  VALID_YN = 'Y'
                                GROUP BY DIVISION_ID,
                                        SCM_SITE_ID,
                                        PROJECT_CODE,
                                        ITEM_ID         )                   CUST_ITEM
            ON              SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
            AND             SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
            AND             SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
            AND             SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID

            LEFT JOIN SCM_MST_SSO_USER_INFO SU
            ON SITE_ITEM.owner = SU.USER_ID

                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_item_id, '^')) WHERE p_item_id IS NOT NULL AND p_item_id NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_item_id IS NULL OR p_item_id IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b
                ON (b.tst IS NULL OR SITE_ITEM.ITEM_ID like b.tst OR SITE_ITEM.NICK_NAME like b.tst)
                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_project_code, '^')) WHERE p_project_code IS NOT NULL AND p_project_code NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_project_code IS NULL OR p_project_code IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) b1
                ON (b1.tst IS NULL OR PJT.PROJECT_CODE like b1.tst OR PJT.PROJECT_NAME like b1.tst)
            INNER JOIN (
                            SELECT DISTINCT X.OWNER
                                FROM SCM_MST_SITE_ITEM X
                                LEFT JOIN SCM_MST_SSO_USER_INFO UI
                                ON X.PROJECT_CODE = UI.USER_ID
                                INNER JOIN ( SELECT '%'||token||'%' tst FROM TABLE(FN_String_Split(p_owner, '^')) WHERE p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-') /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */
                UNION ALL SELECT NULL FROM DUAL WHERE (p_owner IS NULL OR p_owner IN ('ALL','-')) /* 2026.08.14 AJS Oracle 은 ''=NULL 이라 IN 목록에 NULL 이 섞여 결과가 UNKNOWN → 조건 무력화 */ ) c
                  ON (c.tst IS NULL OR FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') like c.tst
                      OR X.OWNER like c.tst
                      OR FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') like c.tst)
                                where X.DIVISION_ID = p_division_id
                                    AND p_owner IS NOT NULL AND p_owner NOT IN ('ALL','-')
                                    UNION all
                                    select '11' FROM DUAL
                                    where p_owner IN ('','ALL','-')
                    ) X
            ON  NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN (p_owner IS NULL OR p_owner IN ('ALL','-')) THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END
            WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
            AND    CASE WHEN p_division_id = 'ALL' THEN p_division_id
                        ELSE SITE_PROJECT.DIVISION_ID
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_division_id,'^')) )
            AND    CASE WHEN p_dept_id = 'ALL' THEN p_dept_id
                        ELSE TEAM.DEPT_ID
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_dept_id,'^')) )
            AND    CASE WHEN p_end_customer = 'ALL' THEN p_end_customer
                        ELSE SITE.END_CUSTOMER
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_end_customer,'^')) )
            AND    CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id
                        ELSE SITE_PROJECT.SCM_SITE_ID  -- 20181220 KHSONG modify SITE_ITEM.SCM_SITE_ID -> SITE_PROJECT.SCM_SITE_ID
                    END  IN ( SELECT token FROM TABLE(FN_String_Split(p_scm_site_id,'^')) )
            AND   SITE.SITE_TYPE <> 'PLANT';


            INSERT INTO GT_DMF0020_SALES_SITE_MODEL (DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40, PROJECT_CODE, PROJECT_NAME, PROJECT_STATUS, SALES_PLAN_ADJUST_YN, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY, MEASURE, DISPLAY_SEQ)
            select DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40, PROJECT_CODE, PROJECT_NAME
            , PROJECT_STATUS,SALES_PLAN_ADJUST_YN, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY, B.MEASURE, B.DISPLAY_SEQ
            from   GT_DMF0020_SALES_SITE_MODEL_ALL a
            cross join (SELECT  COLUMN_NAME AS MEASURE,
                                COLUMN_LABEL_NAME AS DESCRIPTION,
                                SORT_ORDER_NO AS DISPLAY_SEQ
                        FROM    SCM_MST_SHEET_MEASURE
                        WHERE   PROGRAM_ID = 'DMF0020'
                        AND     SHEET_NAME = 'Sales Price'
                        AND     COLUMN_NAME = 'LOC'   /* [E20260824-LOCONLY] CROSS JOIN 4배(LOC/KRW/USD/RTF_SYS_RP) -> 소비되는 LOC 만 */ )  b;



        v_nsql := '
            SELECT
                    DIVISION_ID,
                    DIVISION_NAME,
                    UPPER_DEPT_ID,
                    DEPT_ID    ,
                    SCM_SITE_ID,
                    PLANT_SITE_ID,
                    SITE_DESCRIPTION,
                    END_CUSTOMER,
                    END_CUSTOMER40,
                    PROJECT_CODE,
                    PROJECT_NAME,
                    BIZ_TYPE_NAME,
                    PROJECT_STATUS,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    CURRENCY,
                    FCST_TYPE,
                    DOM_EXP,
                    AUTHORITY_YN,
                    DISPLAY_SEQ,
                    NICK_NAME,
                    COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
                    NEW_FLAG,
                    MEASURE,
                    ' || v_prod || '
            From(
                SELECT a.DIVISION_ID,
                    b.DIVISION_NAME,
                    b.UPPER_DEPT_ID,
                    a.DEPT_ID    ,
                    a.SCM_SITE_ID,
                    b.PLANT_SITE_ID,
                    b.SITE_DESCRIPTION,
                    a.END_CUSTOMER,
                    b.END_CUSTOMER40,
                    a.PROJECT_CODE,
                    a.PROJECT_NAME,
                    b.BIZ_TYPE_NAME,
                    a.PROJECT_STATUS,
                    a.ITEM_ID,
                    a.ITEM_CLASS_NAME,
                    a.ITEM_NAME,
                    b.INCOTERMS,
                    (CASE WHEN division_name is null THEN a.CURRENCY
                          ELSE b.CURRENCY
                     END) AS CURRENCY, --[C20200702-000136] ESS사업부 조회 구간 Currency 변경
                    b.FCST_TYPE,
                    b.DOM_EXP,
                    (CASE WHEN division_name is null
                               THEN (CASE WHEN ((NVL((SELECT MAX(DA.HAS_AUTH) FROM SCM_MGR.GT_DMF0020_DEPT_AUTH DA WHERE DA.DEPT_ID = a.DEPT_ID), ''N'') = ''Y'')  OR ''' || v_group_id || ''' =''ADMIN'') THEN ''Y''
                                          ELSE ''N''
                                     END )
                          ELSE b.AUTHORITY_YN
                     END) AS AUTHORITY_YN,
                    a.DISPLAY_SEQ,
                    a.NICK_NAME,
                    b.COL_LIST,
                    (CASE WHEN division_name is null THEN ''Y'' ELSE ''N'' END) AS NEW_FLAG,
                    a.MEASURE,
                    b.PRICE,
                    b.YYYYMMDD
                FROM GT_DMF0020_SALES_SITE_MODEL A
                    LEFT JOIN GT_DMF0020_OUTPUT B ON(   a.division_id =  b.division_id
                                                and a.dept_id = b.dept_id
                                                and a.scm_site_id = b.scm_site_id
                                                and a.item_id = b.item_id
                                                and a.project_code = b.project_code
                                                and a.measure = b.measure
                                            )
                WHERE A.MEASURE = ''LOC''
                ) T
            PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod_pivot || ')
            ) PVT
            ORDER BY

                    DIVISION_ID,
                    division_name,
                    DEPT_ID,
                    END_CUSTOMER,
                    SCM_SITE_ID,
                    PROJECT_CODE,
                    PROJECT_STATUS,
                    BIZ_TYPE_NAME,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    FCST_TYPE,
                    DOM_EXP,
                    CURRENCY,
                    PLANT_SITE_ID,
                    DISPLAY_SEQ,
                    MEASURE,
                    COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
            ';
        --End [C20200612-000174] ESS사업부 Sales Site Project Model 데이터 제공
    ELSE

        v_nsql := '
            SELECT
                    DIVISION_ID,
                    DIVISION_NAME,
                    UPPER_DEPT_ID,
                    DEPT_ID    ,
                    SCM_SITE_ID,
                    PLANT_SITE_ID,
                    SITE_DESCRIPTION,
                    END_CUSTOMER,
                    END_CUSTOMER40,
                    PROJECT_CODE,
                    PROJECT_NAME,
                    BIZ_TYPE_NAME,
                    PROJECT_STATUS,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    CURRENCY,
                    FCST_TYPE,
                    DOM_EXP,
                    AUTHORITY_YN,
                    DISPLAY_SEQ,
                    NICK_NAME,
                    COL_LIST, --[PJ20200138] 범위를 초과하는 YYYYMMDD List
                    ''N'' AS NEW_FLAG,
                    MEASURE,
                    ' || v_prod || '
            From(
                SELECT
                    *
                FROM GT_DMF0020_OUTPUT
                WHERE MEASURE = ''LOC''
                ) T
            PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod_pivot || ')
            ) PVT
            ORDER BY

                    DIVISION_ID,
                    DEPT_ID,
                    END_CUSTOMER,
                    SCM_SITE_ID,
                    PROJECT_CODE,
                    PROJECT_STATUS,
                    BIZ_TYPE_NAME,
                    ITEM_ID,
                    ITEM_CLASS_NAME,
                    ITEM_NAME,
                    INCOTERMS,
                    FCST_TYPE,
                    DOM_EXP,
                    CURRENCY,
                    PLANT_SITE_ID,
                    DISPLAY_SEQ,
                    MEASURE,
                    COL_LIST --[PJ20200138] 범위를 초과하는 YYYYMMDD List
            ';

    END IF;

    --PRINT @NSQL
    OPEN O_RC1 FOR v_nsql;


    --SELECT CONVERT(TEXT, @NSQL)
    --FOR XML PATH('')--,ROOT('x')


EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP ERROR: ' || SQLERRM);
END P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP;

    -- [2026-09-15 UIPKG] standalone PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE 취합
PROCEDURE P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE 
/*=====================================================================================================================================================
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE
 * Description  : Sales Plan AMT Create ( Local/KRW )
 * Program History
 *=====================================================================================================================================================
 *   Date		In Charge	Description
 *=====================================================================================================================================================
 * 2018.05.10	KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 수행시 PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE Procedure 를 호출하여
 * sales price 화면에서 Batch Job 누른 것과 같은 로직을 수행하도록함
 * ---------------------------------------------------------------------------------------------------
 * 2018.08.24	KHSONG		사용자정보 변수값 사용으로 적용 / [SCM_MST_FUTURE_PRICE] JOIN 조건 보완
 * 2019.11.14	KHSONG		컬럼값 미지정에서 지정으로 보완
 * 2020.02.13	HWI1993		자동차사업부 SALES AMT 메저를 RTF_SCP 기준으로 생성
 * 2020.03.09	KHSONG		TMM_FCST ADD
 * 2020.05.07	KHSONG		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.08.06	hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020.12.08	P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2024.11.15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선
 * 2025.01.21	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.01.21	JSSBAE		[E20250121-000405]_Sales Plan에서 Catch-up 메저 삭제되는 현상 조정
 * 2025.02.11	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 SCM_FCST MEASURE 추가
 * 2025.04.03	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요.
 * 2025.04.08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.28	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 CELL_PROD_SITE_ID 추가
 * 2026.03.09	JSSBAE		[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 *===================================================================================================*/
IS

    /* 원본 MSSQL 지역변수 (NVARCHAR(MAX) -> 호출부 실값이 짧은 코드/사용자ID 이므로 VARCHAR2, SOP H-14) */
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_CREATED_BY        VARCHAR2(4000 CHAR);

    /* LOG 용 변수 설정 (START) */
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE          VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    /* LOG 용 변수 설정 (END) */


    V_SQL_ERR_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERR_MSG       VARCHAR2(1000 CHAR);
    V_SQL_BACKTRACE     VARCHAR2(4000 CHAR);

    /* 주차 기준일 = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) */
    V_THIS_WEEK_MON     VARCHAR2(8 CHAR);

BEGIN

    /* 원본 SET NOCOUNT ON / SET TRANSACTION ISOLATION LEVEL READ COMMITTED / SET XACT_ABORT ON */

    V_THIS_WEEK_MON := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

    /* 원본 #SALES_PLAN_TEMP 는 매 실행 시 DROP 후 SELECT TOP 0 으로 재생성(=빈 상태 보장).
     * GTT 는 재생성 대신 DELETE 로 초기화(TRUNCATE 는 DDL 이라 암시 COMMIT 발생 -> 호출자 트랜잭션 파괴). */
    DELETE FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE;

    /* 시작 LOG (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;   /* 변수 재사용을 위하여 초기화해야함 */
    /* 시작 LOG (END) */

    /* 트랜잭션 (START)
     * 원본 BEGIN TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE; */
    BEGIN

        /*----------------------------- MULTI & SINGLE ROW START -----------------------------*/

        /* 사용자정보값 변수에 저장 20180824 KHSONG
         * 원본 SET @v_created_by = (SELECT TOP 1 v_CREATED_BY FROM #results) */
        BEGIN
            SELECT A.V_CREATED_BY
              INTO V_CREATED_BY
              FROM GT_DMF0020_RESULTS A
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_CREATED_BY := NULL;
        END;

        /* 기존 정보 삭제 */
        DELETE
          FROM DM_PLN_SALES_PLAN A
         WHERE EXISTS ( SELECT 1                                   /* 20180510 skh add : DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS B
                         WHERE B.V_DIVISION_ID   = A.DIVISION_ID
                           AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND B.V_ITEM_ID       = A.ITEM_ID
                           AND B.V_DOM_EXP       = A.DOM_EXP
                           AND B.V_FCST_TYPE     = A.FCST_TYPE
                           AND B.V_INCOTERMS     = A.INCOTERMS
                           AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT C.ITEM_ID                     /* MKT/금형비처럼 사람이 넣은것 삭제. */
                                FROM SCM_MST_ITEM_SN C
                               GROUP BY C.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM D
                                 , DM_PLN_SALES_PLAN E
                             WHERE D.ITEM_ID              = E.ITEM_ID
                               AND D.DIVISION_ID          = E.DIVISION_ID
                               AND D.PROJECT_CODE         = E.PROJECT_CODE
                               AND D.SCM_SITE_ID          = E.SCM_SITE_ID
                               AND D.DIVISION_ID          = A.DIVISION_ID
                               AND D.PROJECT_CODE         = A.PROJECT_CODE
                               AND D.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND D.ITEM_ID              = A.ITEM_ID
                               AND D.SALES_PLAN_ADJUST_YN = 'N'
                               AND E.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND E.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE NOT IN ( 'CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up' )   /* [E20250121-000405] Catch Up 메저 삭제 금지 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON;

        /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산. */
        DELETE
          FROM DM_PLN_SALES_PLAN A
         WHERE EXISTS ( SELECT 1                                   /* 20180510 skh add : DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS B
                         WHERE B.V_DIVISION_ID   = A.DIVISION_ID
                           AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND B.V_ITEM_ID       = A.ITEM_ID
                           AND B.V_DOM_EXP       = A.DOM_EXP
                           AND B.V_FCST_TYPE     = A.FCST_TYPE
                           AND B.V_INCOTERMS     = A.INCOTERMS
                           AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT C.ITEM_ID                     /* MKT/금형비처럼 사람이 넣은것 삭제. */
                                FROM SCM_MST_ITEM_SN C
                               GROUP BY C.ITEM_ID )
           AND A.MEASURE IN ( 'MKT_FCST', 'CUST_FCST', 'RTF', 'RTF_SYS_RP', 'TMM_FCST', 'SCM_FCST' )   /* 20180417 modify skh / 20200309 KHSONG TMM_FCST ADD / [PJ2025-50017] SCM_FCST 추가 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON;

        /* 임시테이블 확인후 삭제 / 임시테이블 생성
         * 원본 IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL DROP TABLE #SALES_PLAN_TEMP
         *      SELECT TOP 0 ... INTO #SALES_PLAN_TEMP FROM DM_PLN_SALES_PLAN
         * -> GTT 는 사전 생성 객체이므로 본문 상단의 DELETE 초기화로 대체(20191114 KHSONG 컬럼값 미지정에서 지정으로 보완). */

        /* 신규 정보 추가 / Temp 테이블에 저장 */
        INSERT
          INTO GT_PRDM_SALES_PLAN_TEMP_SINGLE
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID   /* [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가 */
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT DISTINCT                                            /* MKT FCST 값을 update 함. */
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-'                                                 /* CELL_PROD_SITE_ID [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , A.QTY
             , NVL(A.CREATED_BY, 'SYSTEM')
             , A.CREATION_DATE
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , IA.CREATED_BY
                      , IA.CREATION_DATE
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_MKT_FCST IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE IN ( 'MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'SCM_FCST' )   /* 20180417 modify skh / 20200309 KHSONG TMM_FCST ADD / [PJ2025-50017] SCM_FCST 추가 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        /* 2020/08/06 hwi1993 [C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건 */
        UNION ALL
        SELECT A.DIVISION_ID                                       /* KRW 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_AMT_KRW'                                       /* MEASURE */
             , A.PLANT_SITE_ID
             , '-'                                                 /* CELL_PROD_SITE_ID [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 원본 CAST(STR(x, 20, 5) AS NUMERIC(30,10)) = 소수 5자리 반올림, 20180404 SongKH */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_MKT_FCST IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'KRW'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE     = 'MKT_FCST'
           AND A.DIVISION_ID = '40'
           AND A.YYYYMMDD   >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID                                       /* LOC 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_AMT_LOC'                                       /* MEASURE */
             , A.PLANT_SITE_ID
             , '-'                                                 /* CELL_PROD_SITE_ID [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_MKT_FCST IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'LOC'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE     = 'MKT_FCST'
           AND A.DIVISION_ID = '40'
           AND A.YYYYMMDD   >= V_THIS_WEEK_MON;

        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. (Start) */
        INSERT
          INTO GT_PRDM_SALES_PLAN_TEMP_SINGLE
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID   /* [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가 */
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT DISTINCT                                            /* RTF 값을 update 함. */
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , A.QTY
             , NVL(A.CREATED_BY, 'SYSTEM')
             , A.CREATION_DATE
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , IA.CREATED_BY
                      , IA.CREATION_DATE
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND A.MEASURE IN ( 'RTF', 'RTF_SYS_RP' )
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID                                       /* KRW 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_KRW'                                      /* MEASURE */
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'KRW'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM E
                                 , DM_PLN_SALES_PLAN F
                             WHERE E.ITEM_ID              = F.ITEM_ID
                               AND E.DIVISION_ID          = F.DIVISION_ID
                               AND E.PROJECT_CODE         = F.PROJECT_CODE
                               AND E.SCM_SITE_ID          = F.SCM_SITE_ID
                               AND E.DIVISION_ID          = A.DIVISION_ID
                               AND E.PROJECT_CODE         = A.PROJECT_CODE
                               AND E.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND E.ITEM_ID              = A.ITEM_ID
                               AND E.SALES_PLAN_ADJUST_YN = 'N'
                               AND F.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND F.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE   = 'RTF_SYS_RP'                          /* [C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID                                       /* LOC 값을 계산 */
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_LOC'                                      /* MEASURE */
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'LOC'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM E
                                 , DM_PLN_SALES_PLAN F
                             WHERE E.ITEM_ID              = F.ITEM_ID
                               AND E.DIVISION_ID          = F.DIVISION_ID
                               AND E.PROJECT_CODE         = F.PROJECT_CODE
                               AND E.SCM_SITE_ID          = F.SCM_SITE_ID
                               AND E.DIVISION_ID          = A.DIVISION_ID
                               AND E.PROJECT_CODE         = A.PROJECT_CODE
                               AND E.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND E.ITEM_ID              = A.ITEM_ID
                               AND E.SALES_PLAN_ADJUST_YN = 'N'
                               AND F.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND F.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE   = 'RTF_SYS_RP'                          /* [C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON
        UNION ALL
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_USD'                                      /* MEASURE */
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , B.CURRENCY
             , ROUND(A.QTY * NVL(B.PRICE, 0), 5)                   /* 20180404 SongKH numeric->numeric(30,10)으로 수정 */
             , V_CREATED_BY                                        /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , 'SYSTEM'                                            /* [2018-03-15][수정] */
             , SYSDATE                                             /* [2018-03-15][수정] */
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM ( SELECT IA.DIVISION_ID
                      , IA.PROJECT_CODE
                      , IA.SCM_SITE_ID
                      , IA.ITEM_ID
                      , IA.DOM_EXP
                      , IA.FCST_TYPE
                      , IA.INCOTERMS
                      , IA.MEASURE
                      , IA.PLANT_SITE_ID
                      , IA.CELL_PROD_SITE_ID
                      , IA.YYYYMMDD
                      , IA.QTY
                      , ( SELECT SA.BASIS_START_DATE
                            FROM SCM_SYS_CALENDAR_M SA
                           WHERE SA.BASIS_YYYYMMDD = IA.YYYYMMDD ) AS BASIS_START_DATE
                   FROM DM_PLN_CFM_MKT_DEMAND_PLAN IA ) A
             , SCM_MST_FUTURE_PRICE B
         WHERE B.DIVISION_ID(+)      = A.DIVISION_ID
           AND B.PROJECT_CODE(+)     = A.PROJECT_CODE
           AND B.SCM_SITE_ID(+)      = A.SCM_SITE_ID
           AND B.ITEM_ID(+)          = A.ITEM_ID
           AND B.DOM_EXP(+)          = A.DOM_EXP
           AND B.FCST_TYPE(+)        = A.FCST_TYPE
           AND B.INCOTERMS(+)        = A.INCOTERMS
           AND B.PLANT_SITE_ID(+)    = A.PLANT_SITE_ID
           AND B.YYYYMMDD(+)         = A.BASIS_START_DATE
           AND B.MEASURE(+)          = 'USD'
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.ITEM_ID IN ( SELECT D.ITEM_ID
                                FROM SCM_MST_ITEM_SN D
                               GROUP BY D.ITEM_ID )
           AND NOT EXISTS ( SELECT 1                               /* Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음. */
                              FROM SCM_MST_SITE_ITEM E
                                 , DM_PLN_SALES_PLAN F
                             WHERE E.ITEM_ID              = F.ITEM_ID
                               AND E.DIVISION_ID          = F.DIVISION_ID
                               AND E.PROJECT_CODE         = F.PROJECT_CODE
                               AND E.SCM_SITE_ID          = F.SCM_SITE_ID
                               AND E.DIVISION_ID          = A.DIVISION_ID
                               AND E.PROJECT_CODE         = A.PROJECT_CODE
                               AND E.SCM_SITE_ID          = A.SCM_SITE_ID
                               AND E.ITEM_ID              = A.ITEM_ID
                               AND E.SALES_PLAN_ADJUST_YN = 'N'
                               AND F.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                               AND F.YYYYMMDD            >= V_THIS_WEEK_MON )
           AND A.MEASURE   = 'RTF_SYS_RP'                          /* [C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용 */
           AND A.YYYYMMDD >= V_THIS_WEEK_MON;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. (End) */

        /* 테이블의 중복제거 */
        BEGIN
            DELETE
              FROM DM_PLN_SALES_PLAN A
             WHERE EXISTS ( SELECT 1
                              FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE B
                             WHERE B.DIVISION_ID   = A.DIVISION_ID
                               AND B.PROJECT_CODE  = A.PROJECT_CODE
                               AND B.SCM_SITE_ID   = A.SCM_SITE_ID
                               AND B.ITEM_ID       = A.ITEM_ID
                               AND B.DOM_EXP       = A.DOM_EXP
                               AND B.FCST_TYPE     = A.FCST_TYPE
                               AND B.INCOTERMS     = A.INCOTERMS
                               AND B.MEASURE       = A.MEASURE
                               AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
                               AND B.YYYYMMDD      = A.YYYYMMDD );
        END;

        /* 20191114 KHSONG 컬럼값 미지정에서 지정으로 보완 */
        INSERT
          INTO DM_PLN_SALES_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID   /* [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가 */
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10 )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                 /* [PJ2025-50017] */
             , A.YYYYMMDD
             , A.CURRENCY
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , SYSDATE
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
          FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE A;

        /* [PJ2024-50611] 소형 매출 프로세스 개선 (Start)
         * 원본 SET @v_division_id = ( SELECT TOP 1 v_DIVISION_ID FROM #results ) */
        BEGIN
            SELECT A.V_DIVISION_ID
              INTO V_DIVISION_ID
              FROM GT_DMF0020_RESULTS A
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_DIVISION_ID := NULL;
        END;
        /* [PJ2025-50017] 소형 매출계획 동기화 개선 (End) */

        /* [PJ2024-50611] 기타매출, Catch Up 테이블 분리 (Start) */
        DELETE
          FROM DM_PLN_SALES_ETC_PLAN A
         WHERE EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS B
                         WHERE B.V_DIVISION_ID   = A.DIVISION_ID
                           AND B.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND B.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND B.V_ITEM_ID       = A.ITEM_ID
                           AND B.V_DOM_EXP       = A.DOM_EXP
                           AND B.V_FCST_TYPE     = A.FCST_TYPE
                           AND B.V_INCOTERMS     = A.INCOTERMS
                           AND B.V_PLANT_SITE_ID = A.PLANT_SITE_ID )   /* PLANT_SITE_ID 고려하지 않고 모두 삭제 후 신규 생성 */
           AND A.MEASURE IN ( 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up' )   /* Catch_Up 관련 메저만 삭제 */
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.YYYYMMDD   >= V_THIS_WEEK_MON;

        INSERT
          INTO DM_PLN_SALES_ETC_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY
             , CURRENCY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , REMARK_TEXT )
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN B.MEASURE = 'KRW' THEN 'SalesAmt_KRW_Catch_Up'
                    WHEN B.MEASURE = 'LOC' THEN 'SalesAmt_LOC_Catch_Up'
                    WHEN B.MEASURE = 'USD' THEN 'SalesAmt_USD_Catch_Up'
                    ELSE B.MEASURE
               END                                                 /* MEASURE */
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , CASE WHEN B.MEASURE = 'KRW' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                    WHEN B.MEASURE = 'LOC' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                    WHEN B.MEASURE = 'USD' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
               END                                                 /* QTY */
             , B.CURRENCY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , A.REMARK_TEXT
          FROM DM_PLN_SALES_ETC_PLAN A
             , SCM_MST_FUTURE_PRICE B
         WHERE A.DIVISION_ID   = B.DIVISION_ID
           AND A.PROJECT_CODE  = B.PROJECT_CODE
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND A.ITEM_ID       = B.ITEM_ID
           AND A.DOM_EXP       = B.DOM_EXP
           AND A.FCST_TYPE     = B.FCST_TYPE
           AND A.INCOTERMS     = B.INCOTERMS
           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
           AND B.YYYYMMDD      = ( SELECT SA.BASIS_START_DATE
                                     FROM SCM_SYS_CALENDAR_M SA
                                    WHERE SA.BASIS_YYYYMMDD = A.YYYYMMDD )
           AND EXISTS ( SELECT 1                                   /* DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터 */
                          FROM GT_DMF0020_RESULTS C
                         WHERE C.V_DIVISION_ID   = A.DIVISION_ID
                           AND C.V_PROJECT_CODE  = A.PROJECT_CODE
                           AND C.V_SCM_SITE_ID   = A.SCM_SITE_ID
                           AND C.V_ITEM_ID       = A.ITEM_ID
                           AND C.V_DOM_EXP       = A.DOM_EXP
                           AND C.V_FCST_TYPE     = A.FCST_TYPE
                           AND C.V_INCOTERMS     = A.INCOTERMS
                           AND C.V_PLANT_SITE_ID = A.PLANT_SITE_ID )
           AND A.MEASURE = 'Catch_Up'
           AND B.MEASURE IN ( 'KRW', 'LOC', 'USD' )
           AND A.DIVISION_ID = V_DIVISION_ID
           AND B.YYYYMMDD   >= V_THIS_WEEK_MON;
        /* [PJ2024-50611] 기타매출, Catch Up 테이블 분리 (End) */

        /*----------------------------- MULTI & SINGLE ROW END -----------------------------*/

        /* 트랜잭션 (COMMIT)
         * 원본 --COMMIT WORK;
         *      COMMIT TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE;
         * -> 호출자(DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL / _POPUP)가 BEGIN TRANSACTION 후 호출하므로
         *    MSSQL 에서 이 COMMIT 은 중첩 카운트 감소일 뿐 실제 확정이 아니다. Oracle 에는 중첩 트랜잭션이 없어
         *    여기서 COMMIT 하면 호출자 작업까지 조기 확정되어 원자성이 깨지므로 제거한다(SOP H-7).
         *    전수확인: 호출자 2곳 모두 자기 COMMIT 보유 / 앱 등록표(SCM_ADM_PROC_M) 미등록 / NSCM BE 직접호출 0건 */

    EXCEPTION
        WHEN OTHERS THEN
        /* 트랜잭션 (END)
         * [E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (START)
         *   --ROLLBACK TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE;
         *   ROLLBACK        <- 무명 ROLLBACK(전체 롤백)으로 개정됨
         * [E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (END) */
            ROLLBACK;

            /* ERROR LOG VALUE SAVE */
            V_LOG_TYPE      := 'ERROR';
            V_SQL_ERR_CODE  := TO_CHAR(SQLCODE);
            V_SQL_ERR_MSG   := SQLERRM;
            V_SQL_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            V_LOG_MESSAGE   := SUBSTR(V_SQL_ERR_MSG, 1, 1000);
            /* [E20260309-000271]_오류가 발생하는 경우 사용자의 ID까지 찍히도록 수정 (START)
             *   --SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()); -- [E20260309-000271]_원소스주석처리
             * ERROR_LINE() 대응 구문이 없어 FORMAT_ERROR_BACKTRACE 로 대체(행번호 포함). */
            V_DESCRIPTION   := SUBSTR('@v_created_by: ' || V_CREATED_BY || '/ ERROR_LINE : ' || V_SQL_BACKTRACE, 1, 500);
            /* [E20260309-000271]_오류가 발생하는 경우 사용자의 ID까지 찍히도록 수정 (END) */
            D_EVENT_DATE    := SYSDATE;

            /* 원본 SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  --에러메시지 DISPLAY */

            PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                                , NULL
                                , V_SQL_ERR_CODE, V_SQL_ERR_MSG, V_SQL_BACKTRACE );


            RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_ERR_CODE
                                         || ' / SQLERRM=' || V_SQL_ERR_MSG
                                         || ' / BACKTRACE=' || V_SQL_BACKTRACE);
    END;

    /* 수행결과 성공여부 DISPLAY
     *   IF @v_log_message IS NULL
     *    SELECT 'success' */

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE;

END PKG_DMF0020;
/
