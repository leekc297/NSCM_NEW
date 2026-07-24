CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0000"
AS

PROCEDURE P_DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*====================================================================================================
 * Program ID  : DMF0000_GET_EXCHANGE_POPUP_DATA
 * Description : 사용자 환율 관리 프로그램 (개발기준, Sales Price,Sales Plan,Fcst&Price에서 사용)
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *====================================================================================================
 *	  Date		In Charge		Description
 *====================================================================================================
 * 2025.04.24	dsiol			[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율 관리 프로그램
 *								DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE 참고해서 만듬
 * 2026.03.16   jcnam           [PJ20264226] NextSCM Pilot 설계 및 개발
 * EXEC [DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE] '20250401','20260401'
====================================================================================================*/
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
    SELECT MIN(BASIS_START_DATE) AS BASIS_START_DATE
         , CALENDAR_YYYY
         , CALENDAR_MONTH
    FROM   SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD >= P_START_YYYYMMDD
    AND    BASIS_YYYYMMDD <= P_END_YYYYMMDD
    GROUP BY CALENDAR_YYYY, CALENDAR_MONTH
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
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD
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

END P_DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE;


PROCEDURE P_DMF0000_GET_EXCHANGE_POPUP_DATA
(
    P_DIVISION_ID     IN VARCHAR2,
    P_FROM_YYYYMMDD   IN VARCHAR2,
    P_TO_YYYYMMDD     IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*====================================================================================================
 * Program ID  : [DMF0000_GET_EXCHANGE_POPUP_DATA]
 * Description : 사용자 환율 관리 프로그램 (개발기준, Sales Price,Sales Plan,Fcst&Price에서 사용)
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *====================================================================================================
 *	  Date		In Charge		Description
 *====================================================================================================
 * 2025.04.24	dsiol			[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율 관리 프로그램
 * 								DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP 참고 해서 만듬
 * EXEC [DMF0000_GET_EXCHANGE_POPUP_DATA] '40','20250401','20260401'
 * EXEC DMF0000_GET_EXCHANGE_POPUP_DATA('40', '20250101','20260301', :RC1, :RC2);
 * 2026.03.16  jcnam            [PJ20264226] NextSCM Pilot 설계 및 개발
 *===================================================================================================*/
AS

    V_COLUMNS        VARCHAR2(32767 CHAR);
    V_SQL            VARCHAR2(32767 CHAR);

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

    -- YYYYMMDD 컬럼 목록 구성 (동적 PIVOT용)
    V_COLUMNS := '';

    -- P_DIVISION_ID = 'ALL' 분기와 특정 사업부 분기를 UNION ALL로 분리 (Case 17)
    FOR R IN (
        SELECT DISTINCT 'D' || YYYYMMDD AS YYYYMMDD
        FROM   DM_MST_EXCHANGE_RATE
        WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
        AND    YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_DIVISION_ID = 'ALL'

        UNION ALL

        SELECT DISTINCT 'D' || YYYYMMDD AS YYYYMMDD
        FROM   DM_MST_EXCHANGE_RATE
        WHERE  YYYYMMDD >= P_FROM_YYYYMMDD
        AND    YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_DIVISION_ID <> 'ALL'
        AND    DIVISION_ID IN (
                   SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )

        ORDER BY YYYYMMDD
    ) LOOP
        V_COLUMNS := V_COLUMNS || '''' || R.YYYYMMDD || ''',';
    END LOOP;

    -- 뒤쪽 콤마 제거
    IF V_COLUMNS IS NOT NULL THEN
        V_COLUMNS := SUBSTR(V_COLUMNS, 1, LENGTH(V_COLUMNS) - 1);
    END IF;

    --혹시나 EXRT_TP_CD 컬럼을 다시 추가 하면 아래의 동적쿼리를 꼭 수정하세요!!!
    V_SQL :=
    'SELECT * ' ||
    'FROM ( ' ||
    '    SELECT DIVISION_ID, CURRENCY, UNIT_CURRENCY ' ||
    '         , ''D'' || YYYYMMDD AS YYYYMMDD ' ||
    '         , EXCHANGE_PRICE ' ||
    '         , TO_CHAR(FIRST_VALUE(LAST_UPDATE_DATE) OVER (PARTITION BY DIVISION_ID, CURRENCY, UNIT_CURRENCY ORDER BY LAST_UPDATE_DATE DESC), ''YYYY-MM-DD HH24:MI:SS'') AS LAST_UPDATE_DATE ' ||
    '         , FIRST_VALUE(LAST_UPDATED_BY) OVER (PARTITION BY DIVISION_ID, CURRENCY, UNIT_CURRENCY ORDER BY LAST_UPDATE_DATE DESC) AS LAST_UPDATED_BY ' ||

    '         , NVL(T2.EDIT_YN,''N'') AS EDIT_YN ' ||

    '    FROM   DM_MST_EXCHANGE_RATE T1 ' ||

    '    INNER JOIN (SELECT * ' ||
    '           FROM SCM_ADM_USER_MNU_EDIT_AUTH_V  ' ||
    '           WHERE USER_ID = ''' || P_USER_ID || ''' ' ||
    '             AND MNU_ID = ''' || P_MNU_ID || ''' ' ||
    '            AND UNIT_TP_CD = ''D'') T2 ' ||
    '    ON T1.DIVISION_ID = T2.UNIT_ID ' ||

    '    WHERE  YYYYMMDD >= ''' || P_FROM_YYYYMMDD || ''' ' ||
    '    AND    YYYYMMDD <= ''' || P_TO_YYYYMMDD || ''' ' ||
    '    AND    ( ' ||
    '               ( ''' || P_DIVISION_ID || ''' = ''ALL'' ) ' ||
    '            OR ( ''' || P_DIVISION_ID || ''' <> ''ALL'' ' ||
    '                 AND DIVISION_ID IN ( ' ||
    '                     SELECT TRIM(REGEXP_SUBSTR(''' || P_DIVISION_ID || ''', ''[^,]+'', 1, LEVEL)) ' ||
    '                     FROM   DUAL ' ||
    '                     CONNECT BY REGEXP_SUBSTR(''' || P_DIVISION_ID || ''', ''[^,]+'', 1, LEVEL) IS NOT NULL ' ||
    '                 ) ' ||
    '               ) ' ||
    '           ) ' ||
    '    AND    UNIT_CURRENCY IN ( ' ||
    '               SELECT SEGMENT1 ' ||
    '               FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A ' ||
    '               WHERE  LOOKUP_TYPE = ''CURRENCY_LIST'' ' || --CURRENCY_LIST에 있는 데이터만 가져 온다.
    '               AND    VALID_YN = ''Y'' ' ||
    '           ) ' ||
    '    AND    CURRENCY = ''KRW'' ' ||



    ') A ' ||
    'PIVOT ( SUM(EXCHANGE_PRICE) FOR YYYYMMDD IN (' || V_COLUMNS || ') ) ' ||
    'ORDER BY DIVISION_ID, CURRENCY, UNIT_CURRENCY';

    -- DBMS_OUTPUT.PUT_LINE(V_SQL);

    OPEN O_RC1 FOR V_SQL;

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
                'P_USER_ID'   VALUE P_USER_ID,
                'P_MNU_ID'   VALUE P_MNU_ID
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

END P_DMF0000_GET_EXCHANGE_POPUP_DATA;

PROCEDURE P_DMF0000_GET_UPDATE_HISTORY
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/***************************************************************************************************
 Program ID  : DMF0000_GET_UPDATE_HISTORY
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

--------------------------------------------------------------------------------------------------
 Date        In Charge    Description
--------------------------------------------------------------------------------------------------
 2023/11/30	kjj			PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - EDI STATUS UPDATE HISTORY 조회
 2026.03.16  jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
**************************************************************************************************/
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
    SELECT
    (
        SELECT TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') FROM SCM_SYS_LOG_BATCH
        WHERE  PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
        AND    LOG_TYPE = 'START'
    ) AS SDATE,
    (
        SELECT TO_CHAR(MAX(LAST_UPDATE_DATE), 'YYYY-MM-DD HH24:MI:SS') FROM SCM_SYS_LOG_BATCH
        WHERE  PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
        AND    LOG_TYPE = 'END'
    ) AS EDATE,
    (
        SELECT LAST_UPDATED_BY FROM SCM_SYS_LOG_BATCH
        WHERE  LAST_UPDATE_DATE =
        (
            SELECT MAX(LAST_UPDATE_DATE) FROM SCM_SYS_LOG_BATCH
            WHERE  PROGRAM_NAME = 'PR_DM_DNM_EDI_CALLOFF_STATUS'
            AND    LOG_TYPE = 'START'
        )
        AND    ROWNUM = 1
    ) AS UPDATED_BY
    FROM DUAL;

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

END P_DMF0000_GET_UPDATE_HISTORY;

PROCEDURE         P_DMF0000_GET_COMMON_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_PROGRAM_ID      IN VARCHAR2,
    P_SHEET_NAME      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,       -- 20180607 추가
    --P_USER_ID         IN VARCHAR2, -- For EditYn
    --P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0000_GET_COMMON_SPREAD_TITLE                                               */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 20180607		JYE			소형 관련 수정                                                            */
/* 2026.03.16   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */
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
    -- 사용자 타이틀셋 존재 여부 확인 (Case 28: 전건 COUNT 회피)
    -- ================================================================
    BEGIN
        SELECT 1
        INTO   V_EXISTS
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  U.PROGRAM_ID  = P_PROGRAM_ID
            AND    U.SHEET_NAME  = P_SHEET_NAME
            AND    U.USER_ID     = P_CREATED_BY
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_EXISTS := 0;
    END;

    IF V_EXISTS = 0 THEN
        -- ============================================================
        -- 사용자 설정 없음 → 기본 컬럼 조회
        -- ============================================================
        IF P_DIVISION_ID IS NULL OR P_DIVISION_ID = '' THEN    -- 20180607 분기 추가

            OPEN O_RC1 FOR
            SELECT
                 C.PROGRAM_ID
               , C.SHEET_NAME
               , C.COLUMN_NAME
               , C.COLUMN_LABEL_NAME
               , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
               , C.DATA_SORT_METHOD_CODE
               , C.SMALL_CLASS_LABEL_NAME
               , C.LARGE_CLASS_LABEL_NAME
               , '' AS DAY_CODE
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
               --, C.VALID_YN
               , CASE C.VALID_YN WHEN 'Y' THEN -- 20180620 추가
                    CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
                 ELSE C.VALID_YN END AS VALID_YN
               , 0 AS SEQ
               --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
            FROM SCM_MST_SHEET_COLUMNS C
                /*
                INNER JOIN ( SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

            WHERE 1 = 1
                AND    C.PROGRAM_ID  = P_PROGRAM_ID
                AND    C.SHEET_NAME  = P_SHEET_NAME

                --AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가

                AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )



            ORDER BY SEQ, SORT_ORDER_NO;

        ELSE -- 20180607 ELSE 추가

            OPEN O_RC1 FOR
            SELECT
                 C.PROGRAM_ID
               , C.SHEET_NAME
               , C.COLUMN_NAME
               , C.COLUMN_LABEL_NAME
               , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
               , C.DATA_SORT_METHOD_CODE
               , C.SMALL_CLASS_LABEL_NAME
               , C.LARGE_CLASS_LABEL_NAME
               , '' AS DAY_CODE
               , C.FIXED_FLAG
               , C.COLUMN_WIDTH
               , C.CELL_CONTROL_OBJECT_TYPE_CODE
               , C.CELL_COMBO_DATA_TYPE
               , C.DATA_SCALE_NUMBER
               , C.DATA_MAX_LENGTH
               , C.HORIZONTAL_ALIGN_CODE
               , C.UPPERCASE_APPLY_FLAG
               , C.VISIBLE_FLAG
               , CASE C.VALID_YN WHEN 'Y' THEN -- 20180607 추가
                    CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
                 ELSE C.VALID_YN END AS VALID_YN
               , C.DEFAULT_FLAG
               , C.USER_SELECTABLE_FLAG
               --, C.VALID_YN
               , 0 AS SEQ
               --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
            FROM SCM_MST_SHEET_COLUMNS C
                /*
                INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

            WHERE 1 = 1
                AND    C.PROGRAM_ID  = P_PROGRAM_ID
                AND    C.SHEET_NAME  = P_SHEET_NAME
                -- AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가
                AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
            ORDER BY SEQ, SORT_ORDER_NO;

        END IF;

    ELSE -- V_EXISTS <> 0

        OPEN O_RC1 FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , U.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
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
             --, C.VALID_YN
             , CASE C.VALID_YN WHEN 'Y' THEN -- 20180607 추가
                  CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
               ELSE C.VALID_YN END AS VALID_YN
             , 1 AS SEQ
             --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM   SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_COLUMNS C
                /*
                INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = P_PROGRAM_ID
        AND    U.SHEET_NAME  = P_SHEET_NAME
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        -- AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가
        AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )

        UNION ALL

        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
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
             --, C.VALID_YN
             , CASE C.VALID_YN WHEN 'Y' THEN -- 20180607 추가
                  CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
               ELSE C.VALID_YN END AS VALID_YN
             , 2 AS SEQ
             --, NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM   SCM_MST_SHEET_COLUMNS C
                /*
               INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T2.UNIT_ID in (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
                */

        WHERE  1 = 1
        AND    C.PROGRAM_ID  = P_PROGRAM_ID
        AND    C.SHEET_NAME  = P_SHEET_NAME
        AND    C.VISIBLE_FLAG = 'N'
        AND    C.DEFAULT_FLAG = ''
        AND    C.VALID_YN     = 'Y'
        -- AND P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.STRING_SPLIT(C.DIVISION_ID, ',')))    -- 20180620 division 추가
        AND P_DIVISION_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
        ORDER BY SEQ, SORT_ORDER_NO;

    END IF;

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
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_PROGRAM_ID'     VALUE P_PROGRAM_ID,
            'P_SHEET_NAME'     VALUE P_SHEET_NAME,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID
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
END P_DMF0000_GET_COMMON_SPREAD_TITLE;



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
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_D000_RESULTS';
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

    N_MERGE_COUNT := N_MERGE_COUNT + SQL%ROWCOUNT;

    ---------------------------------------------------------------------------------
    -- 저장이 성공한 이후에 실행되는 프로시저 (START)
    ---------------------------------------------------------------------------------
    -- 환율이 변경되면, Sales Price, Sales Plan AMT 가 같이 업데이트 되어야 한다.
    -- 환율화면에서 환율이 변경되면 아래 2개의 프로시저가  호출되어야 한다.

    -- Sales Price Update
    SCM_MGR.PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION(V_DIVISION_ID, V_RC1);

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



END PKG_DMF0000;
/
