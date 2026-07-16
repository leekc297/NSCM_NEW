CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0082"
AS

PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO
(
    P_START_YYYYMMDD   IN  VARCHAR2,
    P_END_YYYYMMDD     IN  VARCHAR2,
    P_USER_ID          IN VARCHAR2, -- For EditYn
    P_MNU_ID           IN VARCHAR2, -- For EditYn
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : DMF0020_GET_FUTUREPRICE_INFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
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
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT YYYYMMDD,
               SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM,
               t1.DIVISION_ID,
               CURRENCY,
               UNIT_CURRENCY,
               EXCHANGE_PRICE,
               NVL(T2.EDIT_YN,'N') AS EDIT_YN
          FROM SCM_MGR.DM_MST_EXCHANGE_RATE t1
              INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T1.DIVISION_ID = T2.UNIT_ID
                     WHERE YYYYMMDD >= P_START_YYYYMMDD
                       AND YYYYMMDD <= P_END_YYYYMMDD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE,
               'SUCCESS' AS MSG,
               CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT
          FROM DUAL;

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
                             'P_USER_ID'        VALUE P_USER_ID,
                             'P_MNU_ID'         VALUE P_MNU_ID
                         );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0082_POPUP_GET_FUTUREPRICE_INFO;


PROCEDURE P_DMF0082_POPUP_GET_WEEKDATA
(
    P_YYYYMMDD          IN  VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_WEEKDATA
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
IS
    -- LOG 용 변수
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
    SELECT BASIS_START_DATE, BASIS_YYYYMMDD
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD <= P_YYYYMMDD
    ORDER BY BASIS_YYYYMMDD DESC
    FETCH FIRST 7 ROWS ONLY;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

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
            'P_YYYYMMDD' VALUE P_YYYYMMDD
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
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0082_POPUP_GET_WEEKDATA;


PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2026.03.24   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
IS
    -- LOG 용 변수
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
    SELECT DISTINCT
    --column_label_name as LOOKUP_CODE
    --,column_label_name as DESCRIPTION
    COLUMN_NAME AS LOOKUP_CODE
    ,COLUMN_NAME AS DESCRIPTION
    , 99 AS DISPLAY_ALL
    , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  SCM_MGR.SCM_MST_SHEET_MEASURE T1
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

    WHERE  PROGRAM_ID = 'DMF0082'
    AND SHEET_NAME = 'FcstNPrice'
    AND VALID_YN = 'Y'
    AND COLUMN_NAME = 'LOC';
    ----SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL
    ----FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    ----WHERE VALID_YN = 'Y'
    ----AND SEGMENT1 <> 'LOC'
    ----AND LOOKUP_TYPE = 'FUTUREMEASURE'
    ----UNION ALL
    /*
     SELECT SEGMENT1 LOOKUP_CODE, SEGMENT2 DESCRIPTION, 99 AS DISPLAY_ALL
     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE VALID_YN = 'Y'
     AND SEGMENT1 = 'LOC'
     AND LOOKUP_TYPE = 'FUTUREMEASURE'
   */

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

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
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
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
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
END P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE;


PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0020_GET_MEASURE_COUNTINFO
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025-02-25   dsiol     Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 */
IS
    -- LOG 용 변수
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

    -- EXCEPTION 블록 필수 변수
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
    SELECT
    -- column_label_name as LOOKUP_CODE
    --,column_label_name as DESCRIPTION
     CASE WHEN COLUMN_NAME = 'RTF_SYS_RP' THEN 'RTF' ELSE COLUMN_NAME END AS LOOKUP_CODE
    ,CASE WHEN COLUMN_NAME = 'RTF_SYS_RP' THEN 'RTF' ELSE COLUMN_NAME END AS DESCRIPTION
    , 99 AS DISPLAY_ALL
    ,SORT_ORDER_NO AS DISPLAY_SEQ
    ,NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  SCM_MGR.SCM_MST_SHEET_MEASURE T1
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
    WHERE  PROGRAM_ID = 'DMF0082'
    AND SHEET_NAME = 'FcstNPrice'
    AND VALID_YN = 'Y'
    AND COLUMN_NAME IN ('RTF_SYS_RP','KRW','USD','LOC')
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

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

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
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
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
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
END P_DMF0082_POPUP_GET_MEASURE_COUNTINFO;

PROCEDURE P_DMF0082_GET_MAIN_DATA
(
    p_division_id    IN  VARCHAR2
  , p_team_id        IN  VARCHAR2
  , p_customer       IN  VARCHAR2
  , p_biz_type       IN  VARCHAR2
  , p_from_yyyymmdd  IN  VARCHAR2
  , p_to_yyyymmdd    IN  VARCHAR2
  , p_scm_site_id    IN  VARCHAR2
  , p_item_id        IN  VARCHAR2
  , p_version_type   IN  VARCHAR2
  , p_qty_yn         IN  VARCHAR2
  , p_created_by     IN  VARCHAR2
  , p_user_group     IN  VARCHAR2
  , O_RC1            OUT SYS_REFCURSOR
  , O_RC2            OUT SYS_REFCURSOR
  , O_RC3            OUT SYS_REFCURSOR
  , O_RC4            OUT SYS_REFCURSOR
  , O_RC5            OUT SYS_REFCURSOR
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID  : P_DMF0082_GET_MAIN_DATA
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *=====================================================================================================================================================
 * Date             In Charge    Description
 *=====================================================================================================================================================
 * 2025.01.23       dsiol        Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2025.04.15       dsiol        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가
 * 2025.04.24       dsiol        [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_NAME 제거 CELL_PROD_SITE_ID 단독 사용
 * 2025.05.20       dsiol        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정
 * 2025.06.02       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 조회 시, 실적수량 Measure는 #TempSelectMeasure 의 RESULT_MEASURE 컬럼으로 매핑
 * 2025.06.09       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : M+3 월까지 Monthly 버킷으로 MKT FCST 입력 불가
 * 2025.06.09       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가
 * 2025.06.09       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT FCST Amt. /RTF[R+P])
 * 2025.06.27       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
 * 2025.07.07       KANG.H.J     [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.10       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
 * 2025.07.23       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : FCST Gap 메저 추가 (MKT FCST - SCM FCST)
 * 2025.07.24       kjiyoon      [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 계획구간 LOC 데이터 SP버전-> MF, SF버전으로 변경
 * 2025.07.30       jssbae       [E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시 MKT FCST 수정 불가하도록 시스템 개선
 * 2026.01.30       jssbae       [E20260130-001907]_FCST&PRICE MGMT Cutoff 버전 조회 대상 테이블 변경
 *=====================================================================================================================================================*/
/****** 개체:  StoredProcedure [dbo].[P_DMF0082_GET_MAIN_DATA]    스크립트 날짜: 2026-04-22 오전 10:57:37 ******/
IS
    -- ===== 사용자 컬럼 및 메저 세팅 관련 변수 =====
    V_USER_COL_CNT      NUMBER := 0;
    V_USER_MEA_CNT      NUMBER := 0;
    VA_PROGRAM_ID       VARCHAR2(50 CHAR);
    VA_SHEET_NAME       VARCHAR2(50 CHAR);

    -- ===== BUCKET 관련 변수 =====
    V_EXP_YYYYMMDD      VARCHAR2(8 CHAR);
    V_PV_LIST           CLOB;
    V_PV_COL_LIST       CLOB;
    V_QTY_SUM           CLOB;
    V_PV_COLUMN_NAME    VARCHAR2(100 CHAR);
    V_PV_NAME           VARCHAR2(200 CHAR);
    V_SORT_ORDER_NO     VARCHAR2(50 CHAR);

    -- ===== 날짜 범위 변수 =====
    V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
    V_TO_RESULT         VARCHAR2(8 CHAR);

    -- ===== C_TITLE 커서 변수 =====
    V_CUR_COLUMN_NAME   VARCHAR2(100 CHAR);
    V_CUR_PROGRAM_ID    VARCHAR2(10 CHAR);
    V_CUR_SHEET_NAME    VARCHAR2(100 CHAR);
    V_CUR_SORT_ORDER_NO VARCHAR2(50 CHAR);
    V_COLUMN            VARCHAR2(4000 CHAR);
    V_GROUPBY           VARCHAR2(4000 CHAR);
    V_ORDERBY           VARCHAR2(4000 CHAR);

    -- ===== 권한 그룹 변수 =====
    V_GROUP_ID          VARCHAR2(50 CHAR);

    -- ===== 동적 SQL 변수 =====
    V_SQL               CLOB;

    -- ===== 로그 변수 =====
    V_LOG_TYPE          VARCHAR2(10 CHAR) := 'I';
    N_LOG_COUNT         NUMBER(10)        := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE              := SYSDATE;
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);

    -- ===== C_BUCKET 커서 =====
    -- Oracle PIVOT IN 구문: 'literal_value' AS alias_name 형식 필수
    -- COLUMN_NAME = 외부 SELECT 의 PIVOT 결과 컬럼 alias 참조 (brackets 없음)
    -- PV_NAME     = PIVOT IN 절의 'value' AS alias (literal 필수)
    CURSOR C_BUCKET IS
        SELECT 'D_' || A.BASIS_YYYYMMDD                                                               AS COLUMN_NAME
              , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD                          AS PV_NAME
              , A.BASIS_YYYYMMDD || '_31'                                                             AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0')                                       AS COLUMN_NAME
              , '''W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0') || ''' AS W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0')  AS PV_NAME
              , A.BASIS_START_DATE || '_21'                                                           AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM                                                                 AS COLUMN_NAME
              , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM                              AS PV_NAME
              , MIN(A.BASIS_START_DATE) || '_01'                                                      AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY SORT_ORDER_NO;

    -- ===== C_TITLE 커서 =====
    CURSOR C_TITLE IS
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                    WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                    ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
             , SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = VA_PROGRAM_ID
        AND    U.SHEET_NAME  = VA_SHEET_NAME
        AND    U.USER_ID     = p_created_by
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        UNION ALL
        /* 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID(Item은 Group 기준으로 정렬) 추가) */
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , TO_CHAR(CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO,85) - 0.5 ELSE C.SORT_ORDER_NO END) AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
            ON  U.PROGRAM_ID  = C.PROGRAM_ID
            AND U.SHEET_NAME  = C.SHEET_NAME
            AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND U.COLUMN_NAME IN ('ITEM_ID')
            AND U.USER_ID = p_created_by
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = ' ' -- [FIX 2026-07-12] AS-IS "DEFAULT_FLAG = ''"(비 default 컬럼만) 오변환('Y') → branch1 사용자 titleset 과 전 컬럼 중복 = ORA-00960
        AND    C.VALID_YN     = 'Y'
        ORDER BY SORT_ORDER_NO;

BEGIN

    V_PROC_INPUT := JSON_OBJECT(
        'p_division_id'   VALUE p_division_id,
        'p_team_id'       VALUE p_team_id,
        'p_customer'      VALUE p_customer,
        'p_biz_type'      VALUE p_biz_type,
        'p_from_yyyymmdd' VALUE p_from_yyyymmdd,
        'p_to_yyyymmdd'   VALUE p_to_yyyymmdd,
        'p_scm_site_id'   VALUE p_scm_site_id,
        'p_item_id'       VALUE p_item_id,
        'p_version_type'  VALUE p_version_type,
        'p_qty_yn'        VALUE p_qty_yn,
        'p_created_by'    VALUE p_created_by,
        'p_user_group'    VALUE p_user_group
    );

    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, '시작', 'P_DMF0082_GET_MAIN_DATA START',
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

    -- [DEFECT_GUARD] p_from_yyyymmdd / p_to_yyyymmdd 형식 검증 (ORA-01841 방어)
    IF p_from_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_from_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_from_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_from_yyyymmdd: ' || NVL(p_from_yyyymmdd, '<NULL>'));
    END IF;
    IF p_to_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_to_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_to_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_to_yyyymmdd: ' || NVL(p_to_yyyymmdd, '<NULL>'));
    END IF;

    ----------------------------------------------------------------------------------------------------
    /* 사용자 컬럼 및 메저 세팅 관련 변수 */
    /* 사용자 컬럼 및 메저 세팅 시작 */
    /* 사용자 컬럼 및 메저 세팅 시작 */
    /* 사용자 컬럼 및 메저 세팅 시작 */
    -- ====================================================================================================
    -- 사용자 컬럼 및 메저 세팅
    -- ====================================================================================================

    VA_PROGRAM_ID := 'DMF0082';
    VA_SHEET_NAME := 'fcstNPrice';

    /* 사용자 컬럼 처리 */
    SELECT COUNT(*) INTO V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_COL_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* 메저 처리 */
    SELECT COUNT(*) INTO V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , VA_SHEET_NAME -- [FIX 2026-07-12] seed INSERT 는 titleSet 표준명(fcstNPrice) — 카운트/적재 기준 정합
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
             , p_created_by
             , SYSDATE -- [FIX 2026-07-12] DATE 컬럼에 NLS 의존 문자열 대입(ORA-01861, hook #109/C-11) → SYSDATE 직접
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = 'FcstNPrice' -- [FIX 2026-07-12] SHEET_MEASURE 등록명='FcstNPrice' (L235/346 정합 — 메저 seed 0행 사고)
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    /* 사용자 컬럼 및 메저 세팅 종료 */
    /* 사용자 컬럼 및 메저 세팅 종료 */
    /* 사용자 컬럼 및 메저 세팅 종료 */
    ----------------------------------------------------------------------------------------------------
    /* BUCKET 관련 변수 */
    /* BUCKET 관련 세팅 시작 */
    /* BUCKET 관련 세팅 시작 */
    /* BUCKET 관련 세팅 시작 */
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CURSOR 선언에 LOCAL 추가
    -- ====================================================================================================
    -- BUCKET 관련 세팅
    -- ====================================================================================================

    /* V_EXP_YYYYMMDD: p_from_yyyymmdd + 50 weeks */
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD');

    DBMS_LOB.CREATETEMPORARY(V_PV_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_PV_COL_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_QTY_SUM, TRUE);

    OPEN C_BUCKET;
    LOOP
        FETCH C_BUCKET INTO V_PV_COLUMN_NAME, V_PV_NAME, V_SORT_ORDER_NO;
        EXIT WHEN C_BUCKET%NOTFOUND;
        IF DBMS_LOB.GETLENGTH(V_PV_COL_LIST) = 0 THEN
            V_PV_COL_LIST := V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_NAME;
            V_QTY_SUM     := 'NVL(' || V_PV_COLUMN_NAME || ',0)';
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || V_PV_NAME;
            V_QTY_SUM     := V_QTY_SUM     || '+NVL(' || V_PV_COLUMN_NAME || ',0)';
        END IF;
    END LOOP;
    CLOSE C_BUCKET;

    /* BUCKET 관련 세팅 종료 */
    /* BUCKET 관련 세팅 종료 */
    /* BUCKET 관련 세팅 종료 */
    ----------------------------------------------------------------------------------------------------
    /* Version 관련 세팅 시작 */
    /* Version 관련 세팅 시작 */
    /* Version 관련 세팅 시작 */
    -- ====================================================================================================
    -- Version 관련 세팅
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_T_VERSION';

    IF p_version_type LIKE '%SP%' OR p_version_type LIKE '%MF%' OR p_version_type LIKE '%SF%' THEN
        --2025.03.14 Philsu Park: MF_W, SP_W Cutoff 버전에서 Amount 실적을 찾기위한 SP_VERSION_NO 추가.
        INSERT INTO SCM_MGR.GT_DMF0082_T_VERSION (VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD, SP_VERSION_NO)
        SELECT A.TOKEN      AS VERSION_NO
             , CASE WHEN D.DM_RTF_YN = 'N' THEN A.TOKEN || '(' || C.ISO_YYYYWW || ') (NO PLAN)'
                    ELSE A.TOKEN || '(' || C.ISO_YYYYWW || ')'
               END          AS VERSION_NO_W
             , TO_CHAR(TO_DATE(B.YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD') AS NOW_YYYYMMDD
             , (SELECT MAX(V2.VERSION_NO)
                FROM   SCM_MGR.DM_MST_VERSION V2
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M CM
                    ON  V2.YYYYMMDD = CM.BASIS_YYYYMMDD
                WHERE  V2.VERSION_TYPE LIKE 'SP%'
                AND    V2.DIVISION_ID  = B.DIVISION_ID
                AND    CM.ISO_YYYYWW   = C.ISO_YYYYWW) AS SP_VERSION_NO
        FROM   (SELECT REGEXP_SUBSTR(p_version_type, '[^,]+', 1, LEVEL) AS TOKEN
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_version_type, ',') + 1) A
        INNER JOIN SCM_MGR.DM_MST_VERSION B
            ON  B.VERSION_NO  = A.TOKEN
            AND B.DIVISION_ID = p_division_id
        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
            ON  C.BASIS_YYYYMMDD = B.YYYYMMDD
        LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN D
            ON  D.DIVISION_ID        = B.DIVISION_ID
            AND D.PLAN_START_YYYYMMDD = C.BASIS_START_DATE;
    END IF;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_VERSION', NO_INVALIDATE => FALSE);

    /* Version 관련 세팅 종료 */
    /* Version 관련 세팅 종료 */
    /* Version 관련 세팅 종료 */
    ----------------------------------------------------------------------------------------------------
    /* #TempSiteItem 만들기 */
    /* 1. #TEMP_DM_MST_ITEM_SINGLE_V 만들기 위해서 ORI_V , A_V , B_V 3개 만들기 그 후 최종적으로 완성 */
    /* 2. #TempSiteItemAll에서 위에서 만든 #TEMP_DM_MST_ITEM_SINGLE_V 사용해서 만들기 */
    /* 3. #TempSiteItemAll를 만든뒤 최종적으로 #TempSiteItem 만들기 */
    -- ====================================================================================================
    -- WS FCST 타입 세팅
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_T_WS_FCST';

    INSERT INTO SCM_MGR.GT_DMF0082_T_WS_FCST (FCST_TYPE)
    SELECT DISTINCT A.SEGMENT1 AS FCST_TYPE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'SALES_TYPE_CODE';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_WS_FCST', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- 날짜 범위 계산
    -- ====================================================================================================

    V_FROM_YYYYMMDD := p_from_yyyymmdd;
    V_TO_YYYYMMDD   := p_to_yyyymmdd;

    /* V_TO_RESULT: 현재 버전의 NOW_YYYYMMDD (기준일) */
    BEGIN
        SELECT TO_CHAR(TRUNC(TO_DATE(MIN(NOW_YYYYMMDD), 'YYYYMMDD'), 'MM'), 'YYYYMMDD')
        INTO   V_TO_RESULT
        FROM   SCM_MGR.GT_DMF0082_T_VERSION;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := p_from_yyyymmdd;
        WHEN TOO_MANY_ROWS THEN V_TO_RESULT := p_from_yyyymmdd;
    END;

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_ORI_V — SCM_ITEM_M_SN 에서 23컬럼 로드
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V';

    -- #TEMP_DM_MST_ITEM_SINGLE_ORI_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , T1.ITEM_NAME
         , T1.ITEM_CLASS
         , T1.ITEM_CLASS_NAME
         , T1.NICK_NAME
         , T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME
         , T1.ITEM_UOM
         , T1.SPEC
         , T1.MDM_PROJECT_NAME
         , T1.MIN_CAPACITY
         , T1.ACTIVE_FLAG
         , T1.ENERGE
         , T1.CELL_QUANTITY
         , T1.SCP_EXTRA_SPEC
         , T1.FORECAST_INFO_BIZ_TYPE
         , T1.FORECAST_INFO_PRODUCT_GROUP
         , T1.FORECAST_INFO_CELL_MODEL
         , T1.FORECAST_INFO_CELL_PACK_COUNT
         , T1.FORECAST_INFO_SPEC
         , T1.FORECAST_INFOR_VERSION
         , T1.CELL_TYPE
    --FROM FP_MGR.SCM_ITEM_M T1   -- linked server 원본 [LGCE_FP_TR].[DBO].[SCM_ITEM_M]
    FROM   SCM_MGR.SCM_ITEM_M_SN T1
    WHERE  T1.DIVISION_ID = p_division_id
      AND  T1.ACTIVE_FLAG = 'Y';
    -- #TEMP_DM_MST_ITEM_SINGLE_ORI_V 만들기 종료

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_ORI_V', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_A_V — ORI_V GROUP BY DIVISION_ID, ITEM_ID
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V';

    -- #TEMP_DM_MST_ITEM_SINGLE_A_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)                                AS ITEM_NAME
         , MAX(T1.ITEM_CLASS)                               AS ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME)                          AS ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME)                                AS NICK_NAME
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END)
                WHEN 1 THEN 'P'
                WHEN 2 THEN 'H'
                WHEN 3 THEN 'Q'
                ELSE 'R'
           END                                              AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME)                      AS MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM)                                 AS ITEM_UOM
         , MAX(T1.SPEC)                                     AS SPEC
         , MAX(T1.MDM_PROJECT_NAME)                         AS MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY)                             AS MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG)                              AS ACTIVE_FLAG
         , MAX(T1.ENERGE)                                   AS ENERGE
         , MAX(T1.CELL_QUANTITY)                            AS CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC)                           AS SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V T1
    WHERE  1 = 1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
    -- #TEMP_DM_MST_ITEM_SINGLE_A_V 만들기 종료

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_A_V', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_B_V — ORI_V GROUP BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V';

    -- #TEMP_DM_MST_ITEM_SINGLE_B_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V
    (
        DIVISION_ID, ITEM_ID
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12)                           AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)                      AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)                 AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL)                    AS FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)               AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC)                          AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)                      AS FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE)                                   AS CELL_TYPE
    FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);
    -- #TEMP_DM_MST_ITEM_SINGLE_B_V 만들기 종료

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_B_V', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- #TEMP_DM_MST_ITEM_SINGLE_V — A_V + B_V 조인, ENERGE WH→KWH, STRING_SPLIT 필터 (p_item_id)
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V';

    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    )
    SELECT DIVISION_ID
         , ITEM_ID
         , ITEM_NAME
         , ITEM_CLASS
         , ITEM_CLASS_NAME
         , NICK_NAME
         , ITEM_TYPE
         , MATERIAL_CLASS_NAME
         , ITEM_UOM
         , SPEC
         , MDM_PROJECT_NAME
         , MIN_CAPACITY
         , FORECAST_INFO_BIZ_TYPE
         , FORECAST_INFO_PRODUCT_GROUP
         , FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT
         , FORECAST_INFO_SPEC
         , FORECAST_INFOR_VERSION
         , ACTIVE_FLAG
         , CELL_TYPE
         , CASE WHEN TO_NUMBER(ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL
                THEN ROUND(TO_NUMBER(ENERGE) / 1000, 4)
                ELSE NULL
           END                                              AS ENERGE  -- WH → KWH 환산
         , CELL_QUANTITY
         , SCP_EXTRA_SPEC
    FROM (
        SELECT T2X.DIVISION_ID
             , T2X.ITEM_ID
             , T2X.ITEM_NAME
             , T2X.ITEM_CLASS
             , T2X.ITEM_CLASS_NAME
             , T2X.NICK_NAME
             , T2X.ITEM_TYPE
             , T2X.MATERIAL_CLASS_NAME
             , T2X.ITEM_UOM
             , T2X.SPEC
             , T2X.MDM_PROJECT_NAME
             , T2X.MIN_CAPACITY
             , T2X.FORECAST_INFO_BIZ_TYPE
             , T2X.FORECAST_INFO_PRODUCT_GROUP
             , T2X.FORECAST_INFO_CELL_MODEL
             , T2X.FORECAST_INFO_CELL_PACK_COUNT
             , T2X.FORECAST_INFO_SPEC
             , T2X.FORECAST_INFOR_VERSION
             , T2X.ACTIVE_FLAG
             , T2X.CELL_TYPE
             , T2X.ENERGE
             , T2X.CELL_QUANTITY
             , T2X.SCP_EXTRA_SPEC
        FROM (
            SELECT T1.DIVISION_ID
                 , T1.ITEM_ID
                 , T1.ITEM_NAME
                 , T1.ITEM_CLASS
                 , T1.ITEM_CLASS_NAME
                 , T1.NICK_NAME
                 , T1.ITEM_TYPE
                 , T1.MATERIAL_CLASS_NAME
                 , T1.ITEM_UOM
                 , T1.SPEC
                 , T1.MDM_PROJECT_NAME
                 , T1.MIN_CAPACITY
                 , T2.FORECAST_INFO_BIZ_TYPE
                 , T2.FORECAST_INFO_PRODUCT_GROUP
                 , T2.FORECAST_INFO_CELL_MODEL
                 , T2.FORECAST_INFO_CELL_PACK_COUNT
                 , T2.FORECAST_INFO_SPEC
                 , T2.FORECAST_INFOR_VERSION
                 , T1.ACTIVE_FLAG
                 , T2.CELL_TYPE
                 , T1.ENERGE
                 , T1.CELL_QUANTITY
                 , T1.SCP_EXTRA_SPEC
            FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V T1
            INNER JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V T2
                ON  T1.DIVISION_ID = T2.DIVISION_ID
                AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
            WHERE 1 = 1
        ) T2X
        INNER JOIN (
            SELECT DISTINCT '%' || TOKEN || '%' AS TST
            FROM (
                SELECT REGEXP_SUBSTR(p_item_id, '[^,]+', 1, LEVEL) AS TOKEN
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id, ',') + 1
            )
        ) B
            ON  T2X.ITEM_ID   LIKE B.TST
             OR T2X.NICK_NAME LIKE B.TST
        WHERE  T2X.DIVISION_ID = p_division_id
    )
    GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
           , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
           , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
           , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;
    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 종료

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_V', NO_INVALIDATE => FALSE);

    ----------------------------------------------------------------------------------------------------
    /* #TempSiteItem 만들기 시작 */
    -- ====================================================================================================
    -- #TempSiteItemAll — SCM_MST_SITE_ITEM + _V + 마스터 8테이블 조인 (원본 47컬럼 → GTT 44컬럼 매핑)
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL';

    -- #TempSiteItemAll 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
      , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER
      , DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
      , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
      , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
      , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
      , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
      , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
      , SORT_ORDER_NO, ENERGE, CELL_QUANTITY, PLANT_SITE_ID
      , ITEM_VALID_YN, END_CUSTOMER, PROJECT_S_OP_REPORT
    )
    SELECT F.DIVISION_ID
         , F.PROJECT_CODE
         , F.SCM_SITE_ID
         , F.ITEM_ID
         , F.ATTRIBUTE5                                     AS CELL_MODEL
         , T2.NICK_NAME
         , F.ATTRIBUTE1                                     AS DMS_SALES
         , F.ATTRIBUTE2                                     AS DMS_CUSTOMER
         , (SELECT LISTAGG(X.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY X.USER_NAME_EN)
            FROM   (SELECT DISTINCT ZA.USER_NAME_EN
                    FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
                    WHERE  ZA.USER_ID IN (
                        SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL)
                        FROM   DUAL
                        CONNECT BY LEVEL <= REGEXP_COUNT(F.OWNER, ',') + 1
                    )) X
           )                                                AS OWNER
         , TEAM.DEPT_ID
         , TEAM.DEPT_NAME_KO
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL
                THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT DEFAULT NULL ON CONVERSION ERROR)
                ELSE T2.FORECAST_INFO_CELL_PACK_COUNT
           END                                              AS FORECAST_INFO_CELL_PACK_COUNT
         , T2.ITEM_TYPE
         , F.PROJECT_CODE                                   AS PROJECT_NAME
         , J.USER_NAME_EN                                   AS PROJECT_OWNER
         , ''                                               AS BIZ_TYPE
         , S.SOLDTO_CUSTOMER
         , I.COUNTRY_NAME
         , H.CITY_NAME
         , ''                                               AS PROJECT_STATUS
         , T2.ITEM_NAME
         , S.VMI_YN
         , F.CUST_GROUP
         , F.CUST_GROUP_DTL
         , F.APPLICATION
         , F.ROUTE
         , T2.MDM_PROJECT_NAME
         , TO_NUMBER(T2.MIN_CAPACITY DEFAULT NULL ON CONVERSION ERROR) AS MIN_CAPACITY
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                ELSE T2.FORECAST_INFO_BIZ_TYPE
           END                                              AS FORECAST_INFO_BIZ_TYPE
         , LOOK.NAME                                        AS CELL_TYPE
         , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
         , T2.FORECAST_INFO_SPEC
         , T2.FORECAST_INFOR_VERSION
         , T4.NICK_NAME                                     AS CELL_MODEL_NICK_NAME
         , TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_CAR
         , TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_MODULE
         , TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR)
           / CASE WHEN NVL(TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR), 0) = 0 THEN 1
                  ELSE TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR)
             END                                             AS MODULE_PER_CAR
         , NULL                                             AS SORT_ORDER_NO
         , TO_CHAR(T2.ENERGE)                               AS ENERGE
         , TO_NUMBER(T2.CELL_QUANTITY DEFAULT NULL ON CONVERSION ERROR) AS CELL_QUANTITY
         , NULL                                              AS PLANT_SITE_ID        -- 원본 GTT 에 없는 컬럼
         , F.VALID_YN                                       AS ITEM_VALID_YN
         , S.END_CUSTOMER
         , NULL                                              AS PROJECT_S_OP_REPORT  -- Case: 20260416 SCM_MST_SITE_ITEM.PROJECT_S_OP_REPORT 삭제
    FROM   SCM_MGR.SCM_MST_SITE_ITEM F
    INNER JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V T2
        ON  F.DIVISION_ID = T2.DIVISION_ID
        AND F.ITEM_ID     = T2.ITEM_ID
    INNER JOIN (
        SELECT DISTINCT '%' || TOKEN || '%' AS TST
        FROM (
            SELECT REGEXP_SUBSTR(p_item_id, '[^,]+', 1, LEVEL) AS TOKEN
            FROM   DUAL
            CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id, ',') + 1
        )
    ) B
        ON  F.ITEM_ID     LIKE B.TST
         OR T2.NICK_NAME  LIKE B.TST
    INNER JOIN SCM_MGR.SCM_MST_SITE S
        ON  F.DIVISION_ID = S.DIVISION_ID
        AND F.SCM_SITE_ID = S.SCM_SITE_ID
        AND S.SITE_TYPE   = 'SALES'
    INNER JOIN SCM_MGR.SCM_MST_CITY H
        ON  S.CITY        = H.CITY
    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY     = I.COUNTRY
    LEFT JOIN (
        SELECT B2.USER_ID, B2.USER_NAME, B2.USER_NAME_EN, B2.DEPT_ID, C.DEPT_NAME_KO
        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B2
        INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
            ON B2.DEPT_ID = C.DEPT_ID
    ) TEAM
        ON TEAM.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                                THEN F.OWNER
                                ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                           END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
        ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                             THEN F.OWNER
                             ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                        END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
        ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                             ELSE F.DEPT_ID   -- Case 39: SCM_MST_SITE.DEPT_ID 삭제, SCM_MST_SITE_ITEM.DEPT_ID 사용
                        END
    LEFT JOIN (
        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
    ) LOOK
        ON LOOK.CODE = T2.CELL_TYPE
    LEFT JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V T4
        ON  T2.DIVISION_ID = T4.DIVISION_ID
        AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
    LEFT JOIN (
        SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
        FROM (
            SELECT SEGMENT2 AS MODEL
                 , SEGMENT3 AS BIZ_TYPE
                 , SEGMENT4 AS CELL_PACK_COUNT
                 , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
              AND  SEGMENT1    = '40'
        ) A
        WHERE MODEL_RANK = 1
    ) LOOKA
        ON LOOKA.MODEL = F.ITEM_ID
    WHERE  F.DIVISION_ID = p_division_id
    AND    (p_scm_site_id = 'ALL' OR F.SCM_SITE_ID IN (
                SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
    AND    (p_customer = 'ALL' OR F.PROJECT_CODE IN (
                SELECT REGEXP_SUBSTR(p_customer, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_customer, ',') + 1))
    AND    (p_biz_type = 'ALL' OR
                CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                     ELSE T2.FORECAST_INFO_BIZ_TYPE
                END IN (
                    SELECT REGEXP_SUBSTR(p_biz_type, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= REGEXP_COUNT(p_biz_type, ',') + 1));
    -- #TempSiteItemAll 만들기 종료

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM_ALL', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- #TempSiteItem — TempSiteItemAll GROUP BY + MAX dedup
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM';

    -- #TempSiteItem 만들기 시작
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
      , CELL_MODEL, DMS_SALES, DMS_CUSTOMER, OWNER
      , DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
      , ITEM_TYPE, PROJECT_OWNER, BIZ_TYPE
      , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
      , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
      , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
      , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
      , SORT_ORDER_NO, ENERGE, CELL_QUANTITY, PLANT_SITE_ID
      , ITEM_VALID_YN, END_CUSTOMER, PROJECT_S_OP_REPORT
    )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)                      AS CELL_MODEL
         , MAX(DMS_SALES)                       AS DMS_SALES
         , MAX(DMS_CUSTOMER)                    AS DMS_CUSTOMER
         , MAX(OWNER)                           AS OWNER
         , MAX(DEPT_ID)                         AS DEPT_ID
         , MAX(DEPT_NAME_KO)                    AS DEPT_NAME_KO
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)   AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(ITEM_TYPE)                       AS ITEM_TYPE
         , MAX(PROJECT_OWNER)                   AS PROJECT_OWNER
         , MAX(BIZ_TYPE)                        AS BIZ_TYPE
         , MAX(SOLDTO_CUSTOMER)                 AS SOLDTO_CUSTOMER
         , MAX(COUNTRY_NAME)                    AS COUNTRY_NAME
         , MAX(CITY_NAME)                       AS CITY_NAME
         , MAX(PROJECT_STATUS)                  AS PROJECT_STATUS
         , MAX(ITEM_NAME)                       AS ITEM_NAME
         , MAX(VMI_YN)                          AS VMI_YN
         , MAX(CUST_GROUP)                      AS CUST_GROUP
         , MAX(CUST_GROUP_DTL)                  AS CUST_GROUP_DTL
         , MAX(APPLICATION)                     AS APPLICATION
         , MAX(ROUTE)                           AS ROUTE
         , MAX(MDM_PROJECT_NAME)                AS MDM_PROJECT_NAME
         , MAX(MIN_CAPACITY)                    AS MIN_CAPACITY
         , MAX(FORECAST_INFO_BIZ_TYPE)          AS FORECAST_INFO_BIZ_TYPE
         , MAX(CELL_TYPE)                       AS CELL_TYPE
         , MAX(FORECAST_INFO_ALL)               AS FORECAST_INFO_ALL
         , MAX(FORECAST_INFO_SPEC)              AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)          AS FORECAST_INFOR_VERSION
         , MAX(CELL_MODEL_NICK_NAME)            AS CELL_MODEL_NICK_NAME
         , MAX(CELL_PER_CAR)                    AS CELL_PER_CAR
         , MAX(CELL_PER_MODULE)                 AS CELL_PER_MODULE
         , MAX(MODULE_PER_CAR)                  AS MODULE_PER_CAR
         , MAX(SORT_ORDER_NO)                   AS SORT_ORDER_NO
         , MAX(ENERGE)                          AS ENERGE
         , MAX(CELL_QUANTITY)                   AS CELL_QUANTITY
         , MAX(PLANT_SITE_ID)                   AS PLANT_SITE_ID
         , MAX(ITEM_VALID_YN)                   AS ITEM_VALID_YN
         , MAX(END_CUSTOMER)                    AS END_CUSTOMER
         , MAX(PROJECT_S_OP_REPORT)             AS PROJECT_S_OP_REPORT
    FROM   SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
    -- #TempSiteItem 만들기 종료

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM', NO_INVALIDATE => FALSE);

    /* #TempSiteItem 만들기 종료 */
    ----------------------------------------------------------------------------------------------------
    /* 조회 할 때 쓸 MKT_FCST, SALE_PRICE 의 RAW DATA 는 #TempFcstNPrice 에 넣는다. */
    /* 최종적으로 #TempFcstNPrice 만듬 */
    -- #TempSelectMeasure 만들기 시작
    -- ====================================================================================================
    -- TempSelectMeasure — 사용자 선택 메저
    -- ====================================================================================================





    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE';

    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
        (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    SELECT U.COLUMN_NAME                          AS MEASURE
         , NVL(M.ATTRIBUTE5, U.COLUMN_NAME)       AS RESULT_MEASURE
         , U.COLUMN_NAME                          AS MEASURE_GROUP
         , U.SORT_ORDER_NO
         , U.USER_ID
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    INNER JOIN SCM_MGR.SCM_MST_SHEET_MEASURE M
        ON  M.PROGRAM_ID  = U.PROGRAM_ID
        AND M.SHEET_NAME  = U.SHEET_NAME
        AND M.COLUMN_NAME = U.COLUMN_NAME
        AND M.VALID_YN    = 'Y'
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;



    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, 'ING', 'VA_PROGRAM_ID:' || VA_PROGRAM_ID || + ',VA_SHEET_NAME:' || VA_SHEET_NAME || ',p_created_by:' ||p_created_by,
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

    -- 강제 포함 메저: LOC, KRW, FCST_GAP (USER_ID = 'DM_ADMIN' 로 표식 — 최종 삭제 대상)
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
        (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    SELECT M.COLUMN_NAME, M.COLUMN_NAME, M.COLUMN_NAME, M.SORT_ORDER_NO, 'DM_ADMIN'
    FROM   SCM_MGR.SCM_MST_SHEET_MEASURE M
    WHERE  M.PROGRAM_ID  = VA_PROGRAM_ID
    AND    M.SHEET_NAME  = VA_SHEET_NAME
    AND    M.COLUMN_NAME IN ('LOC', 'KRW', 'FCST_GAP', 'RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW', 'SCM_FCST', 'MKT_FCST')
    AND    NOT EXISTS (
               SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE X
               WHERE X.MEASURE = M.COLUMN_NAME
           );

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SELECT_MEASURE', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- T_LAST_DATA_SETUP_FCST / PRICE (Current 버전 최신 데이터 로드)
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE';

    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;

    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST',  NO_INVALIDATE => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- T_LAST_DATA_SETUP_FCST_C / PRICE_C (Cutoff 버전 최신 데이터 로드)
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C';

    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, VERSION_NO, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO;

    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST_C',  NO_INVALIDATE => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- TempFcstNPrice 구성 시작
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE';

    -- ============================================================
    -- Current 버전 데이터 INSERT
    -- ============================================================
    IF p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%' THEN

        -- 계획구간 수요 (DM_PLN_CFM_MKT_DEMAND_PLAN)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
                WHERE  LD.DIVISION_ID  = A.DIVISION_ID
                AND    LD.PROJECT_CODE = A.PROJECT_CODE
                AND    LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND    LD.ITEM_ID      = A.ITEM_ID
                AND    LD.DOM_EXP      = A.DOM_EXP
                AND    LD.FCST_TYPE    = A.FCST_TYPE
                AND    LD.INCOTERMS    = A.INCOTERMS
                AND    LD.MEASURE      = A.MEASURE
                ORDER BY LD.CREATE_DATE DESC
                FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;

        -- 판가 (DM_PLN_CFM_SELLING_PRICE)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , NVL(A.PRICE, 0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , '-' AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE LD
                WHERE  LD.DIVISION_ID  = A.DIVISION_ID
                AND    LD.PROJECT_CODE = A.PROJECT_CODE
                AND    LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND    LD.ITEM_ID      = A.ITEM_ID
                AND    LD.DOM_EXP      = A.DOM_EXP
                AND    LD.FCST_TYPE    = A.FCST_TYPE
                AND    LD.INCOTERMS    = A.INCOTERMS
                AND    LD.MEASURE      = A.MEASURE
                ORDER BY LD.CREATE_DATE DESC
                FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD;

        -- 실적 수량 (DM_PLN_SALES_PLAN_RESULT)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = B.RESULT_MEASURE
            AND B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST LD
                WHERE  LD.DIVISION_ID  = A.DIVISION_ID
                AND    LD.PROJECT_CODE = A.PROJECT_CODE
                AND    LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND    LD.ITEM_ID      = A.ITEM_ID
                AND    LD.DOM_EXP      = A.DOM_EXP
                AND    LD.FCST_TYPE    = A.FCST_TYPE
                AND    LD.INCOTERMS    = A.INCOTERMS
                AND    LD.MEASURE      = A.MEASURE
                ORDER BY LD.CREATE_DATE DESC
                FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- Current 버전

    -- ============================================================
    -- MF 버전 데이터 INSERT
    -- ============================================================
    IF p_version_type LIKE '%MF%' THEN

        -- 계획구간 수요 (Cutoff)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , F.VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LD
                WHERE  LD.DIVISION_ID  = A.DIVISION_ID
                AND    LD.PROJECT_CODE = A.PROJECT_CODE
                AND    LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND    LD.ITEM_ID      = A.ITEM_ID
                AND    LD.DOM_EXP      = A.DOM_EXP
                AND    LD.FCST_TYPE    = A.FCST_TYPE
                AND    LD.INCOTERMS    = A.INCOTERMS
                AND    LD.MEASURE      = A.MEASURE
                ORDER BY LD.CREATE_DATE DESC
                FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;

        -- 판가 MF (DM_PLN_CFM_SELLING_PRICE_C)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD;

        -- 실적 수량 MF (DM_PLN_SALES_PLAN_RESULT_C)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- MF 버전

    -- ============================================================
    -- SF 버전 데이터 INSERT
    -- ============================================================
    IF p_version_type LIKE '%SF%' THEN

        -- 계획구간 수요 (SF Cutoff)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

        -- MKT_FCST_PP SF 계획구간 (DM_PLN_CFM_MKT_DEMAND_PLAN_C)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  A.MEASURE = 'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;

        -- 실적 수량 SF (DM_PLN_SALES_PLAN_RESULT_C)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

        -- 판가 SF 계획구간 (DM_PLN_CFM_SELLING_PRICE_C)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;

    END IF; -- SF 버전

    -- ====================================================================================================
    -- SP 버전 데이터 INSERT (SP 버전별 판가 + 실적 수량)
    -- ====================================================================================================
    IF p_version_type LIKE '%SP%' THEN

        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        -- 계획구간 판가 SP
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;

        -- 실적 수량 SP
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN LATERAL (
                SELECT CREATE_DATE, LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C LD
                WHERE  LD.DIVISION_ID=A.DIVISION_ID AND LD.PROJECT_CODE=A.PROJECT_CODE
                AND    LD.SCM_SITE_ID=A.SCM_SITE_ID AND LD.ITEM_ID=A.ITEM_ID
                AND    LD.DOM_EXP=A.DOM_EXP AND LD.FCST_TYPE=A.FCST_TYPE
                AND    LD.INCOTERMS=A.INCOTERMS AND LD.MEASURE=A.MEASURE
                ORDER BY LD.CREATE_DATE DESC FETCH FIRST 1 ROWS ONLY
            ) LD ON 1=1
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF; -- SP 버전

    -- ====================================================================================================
    -- CURRENCY 업데이트 (계획구간 통화코드 보완)
    -- ====================================================================================================

    UPDATE SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    SET    A.CURRENCY = (
               SELECT MAX(SP.CURRENCY)
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE SP
               WHERE  SP.DIVISION_ID      = A.DIVISION_ID
               AND    SP.PROJECT_CODE     = A.PROJECT_CODE
               AND    SP.SCM_SITE_ID      = A.SCM_SITE_ID
               AND    SP.PLANT_SITE_ID    = A.PLANT_SITE_ID
               AND    SP.ITEM_ID          = A.ITEM_ID
               AND    SP.INCOTERMS        = A.INCOTERMS
               AND    SP.DOM_EXP          = A.DOM_EXP
               AND    SP.FCST_TYPE        = A.FCST_TYPE
               AND    SP.CELL_PROD_SITE_ID= A.CELL_PROD_SITE_ID
               AND    SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               AND    SP.MEASURE = 'LOC'
           )
    WHERE  A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
    AND    A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- LOC/KRW Unit Price 계산 — MKT_AMT / RTF_SYS_RP
    -- ====================================================================================================

    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
    -- LOC/KRW Unit Price
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
         , CASE D.MEASURE
               WHEN 'LOC' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                    THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                                       / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                    ELSE 0 END
               WHEN 'KRW' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                    THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                                       / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                    ELSE 0 END
           END AS QTY
         , MAX(D.MEASURE_GROUP)
         , MAX(A.CELL_MODEL), MAX(A.NICK_NAME), MAX(A.DMS_SALES), MAX(A.DMS_CUSTOMER)
         , MAX(A.OWNER), MAX(A.DEPT_ID), MAX(A.DEPT_NAME_KO)
         , MAX(A.FORECAST_INFO_CELL_PACK_COUNT), MAX(A.ITEM_TYPE)
         , MAX(A.PROJECT_NAME), MAX(A.PROJECT_OWNER), MAX(A.BIZ_TYPE)
         , MAX(A.SOLDTO_CUSTOMER), MAX(A.COUNTRY_NAME), MAX(A.CITY_NAME)
         , MAX(A.PROJECT_STATUS), MAX(A.ITEM_NAME), MAX(A.VMI_YN)
         , MAX(A.CUST_GROUP), MAX(A.CUST_GROUP_DTL), MAX(A.APPLICATION)
         , MAX(A.ROUTE), MAX(A.MDM_PROJECT_NAME), MAX(A.MIN_CAPACITY)
         , MAX(A.FORECAST_INFO_BIZ_TYPE), MAX(A.CELL_TYPE)
         , MAX(A.FORECAST_INFO_ALL), MAX(A.FORECAST_INFO_SPEC)
         , MAX(A.FORECAST_INFOR_VERSION), MAX(A.CELL_MODEL_NICK_NAME)
         , MAX(A.CELL_PER_CAR), MAX(A.CELL_PER_MODULE), MAX(A.MODULE_PER_CAR)
         , MAX(D.SORT_ORDER_NO), MAX(A.ENERGE), MAX(A.CELL_QUANTITY)
         , MAX(A.AS_FROM_SITE), MAX(A.CREATE_DATE), MAX(A.LAST_UPDATED_BY)
         , MAX(A.SENDER_CODE), MAX(A.SENDER_NAME), MAX(A.PROJECT_S_OP_REPORT)
         , MAX(A.CURRENCY), A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    JOIN   SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
    WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
    AND    A.YYYYMMDD >= p_from_yyyymmdd
    AND    A.YYYYMMDD < V_TO_RESULT
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    UNION ALL
    -- FCST_GAP = MKT_FCST - SCM_FCST
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
         , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
         , MAX(D.MEASURE_GROUP)
         , MAX(A.CELL_MODEL), MAX(A.NICK_NAME), MAX(A.DMS_SALES), MAX(A.DMS_CUSTOMER)
         , MAX(A.OWNER), MAX(A.DEPT_ID), MAX(A.DEPT_NAME_KO)
         , MAX(A.FORECAST_INFO_CELL_PACK_COUNT), MAX(A.ITEM_TYPE)
         , MAX(A.PROJECT_NAME), MAX(A.PROJECT_OWNER), MAX(A.BIZ_TYPE)
         , MAX(A.SOLDTO_CUSTOMER), MAX(A.COUNTRY_NAME), MAX(A.CITY_NAME)
         , MAX(A.PROJECT_STATUS), MAX(A.ITEM_NAME), MAX(A.VMI_YN)
         , MAX(A.CUST_GROUP), MAX(A.CUST_GROUP_DTL), MAX(A.APPLICATION)
         , MAX(A.ROUTE), MAX(A.MDM_PROJECT_NAME), MAX(A.MIN_CAPACITY)
         , MAX(A.FORECAST_INFO_BIZ_TYPE), MAX(A.CELL_TYPE)
         , MAX(A.FORECAST_INFO_ALL), MAX(A.FORECAST_INFO_SPEC)
         , MAX(A.FORECAST_INFOR_VERSION), MAX(A.CELL_MODEL_NICK_NAME)
         , MAX(A.CELL_PER_CAR), MAX(A.CELL_PER_MODULE), MAX(A.MODULE_PER_CAR)
         , MAX(D.SORT_ORDER_NO), MAX(A.ENERGE), MAX(A.CELL_QUANTITY)
         , MAX(A.AS_FROM_SITE), MAX(A.CREATE_DATE), MAX(A.LAST_UPDATED_BY)
         , MAX(A.SENDER_CODE), MAX(A.SENDER_NAME), MAX(A.PROJECT_S_OP_REPORT)
         , MAX(A.CURRENCY), A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , 'INTEGER' AS NOTATION
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    JOIN   SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
    WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- [PJ2025-50188] Unit Price 계산에 사용된 보조 메저 삭제
    -- ====================================================================================================

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    WHERE EXISTS (
        SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
        WHERE  B.MEASURE  = A.MEASURE
        AND    B.USER_ID  = 'DM_ADMIN'
    );

    -- ====================================================================================================
    -- QTY 필터 (P_QTY_YN = 'Y' 이면 QTY=0 제거)
    -- ====================================================================================================

    IF p_qty_yn = 'Y' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE QTY = 0;
    END IF;

    -- ====================================================================================================
    -- C_TITLE 커서 — 동적 컬럼 목록 생성
    -- ====================================================================================================

    V_COLUMN  := '';
    V_GROUPBY := '';
    V_ORDERBY := '';

    OPEN C_TITLE;
    LOOP
        FETCH C_TITLE INTO V_CUR_PROGRAM_ID, V_CUR_SHEET_NAME, V_CUR_COLUMN_NAME, V_CUR_SORT_ORDER_NO;
        EXIT WHEN C_TITLE%NOTFOUND;
        IF V_COLUMN IS NULL THEN
            V_COLUMN  := V_CUR_COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, ' || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN V_CUR_COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || V_CUR_COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := V_ORDERBY || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN ', ' || V_CUR_COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;
    CLOSE C_TITLE;

    --[E20240812-000094] NOTATION 컬럼 추가
    -- C_TITLE 0행일 때 V_COLUMN NULL 방어 (leading comma 방지로 ORA-00936 회피)
    V_COLUMN  := CASE WHEN V_COLUMN  IS NULL THEN 'NOTATION'              ELSE V_COLUMN  || ', NOTATION' END;
    V_GROUPBY := CASE WHEN V_GROUPBY IS NULL THEN ' GROUP BY EDIT_FLAG, SORT_ORDER_NO' ELSE V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO' END;
    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');

    -- ====================================================================================================
    -- 권한 그룹 조회
    -- ====================================================================================================

    V_GROUP_ID := '';

    DECLARE
        V_ADMIN_CNT NUMBER;
    BEGIN
        SELECT COUNT(1) INTO V_ADMIN_CNT
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN    = 'Y'
        AND    SEGMENT1    = p_user_group
        AND    SEGMENT2    = 'ALL';

        IF V_ADMIN_CNT > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    END;

    -- ====================================================================================================
    -- TEMP_INTO_GROUP_MEASURE — 메저별 수정권한 그룹 매핑
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_TEMP_INTO_GROUP_MEASURE';

    -- #TEMP_INTO_GROUP_MEASURE: GET_ADMIN_GROUP_MEASURE 룩업에서 권한 그룹별 메저 적재
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_INTO_GROUP_MEASURE (MEASURE, GROUP_MEASURE)
    SELECT A.SEGMENT4 AS MEASURE
         , A.SEGMENT1 AS GROUP_MEASURE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    A.VALID_YN    = 'Y'
    AND    A.SEGMENT1    = p_user_group
    AND    A.SEGMENT2    = VA_PROGRAM_ID
    AND    A.SEGMENT3    = p_division_id;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_INTO_GROUP_MEASURE', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- TEMP_ADMIN_GROUP_MEASURE — 메저별 당일 수정권한
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE';

    -- #TEMP_ADMIN_GROUP_MEASURE: 전체 관리 메저 목록에서 현재 사용자 권한 매핑
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE (MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST)
    SELECT A.SEGMENT4 AS MEASURE
         , CASE WHEN EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.GT_DMF0082_TEMP_INTO_GROUP_MEASURE B
                    WHERE  B.MEASURE = A.SEGMENT4
               ) THEN 'Y' ELSE 'N' END AS EDIT_AUTH_YN
         , CASE WHEN A.ATTRIBUTE1 IS NOT NULL THEN 'Y' ELSE 'N' END AS TODAY_LIMIT_YN
         , A.ATTRIBUTE1 AS TODAY_DAY_LIST
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    A.VALID_YN    = 'Y'
    AND    A.SEGMENT2    = VA_PROGRAM_ID
    GROUP BY A.SEGMENT4, A.ATTRIBUTE1;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- CAL_MONTH_END_DATE / CAL_WEEK_END_DATE
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_CAL_MONTH_END_DATE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE';

    INSERT INTO SCM_MGR.GT_DMF0082_CAL_MONTH_END_DATE (BASIS_YYYYMM, MONTH_END_DATE, M3_CUTOFF_DATE)
    SELECT A.BASIS_YYYYMM
         , MAX(A.BASIS_YYYYMMDD) AS MONTH_END_DATE
         , TO_CHAR(ADD_MONTHS(TO_DATE(MIN(A.BASIS_YYYYMMDD),'YYYYMMDD'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.BASIS_YYYYMM;

    INSERT INTO SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE (ISO_WEEK, BASIS_YYYYMM, WEEK_END_DATE, M3_CUTOFF_DATE)
    SELECT A.ISO_WEEK
         , A.BASIS_YYYYMM
         , MAX(A.BASIS_YYYYMMDD) AS WEEK_END_DATE
         , TO_CHAR(ADD_MONTHS(TO_DATE(MIN(A.BASIS_YYYYMMDD),'YYYYMMDD'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.ISO_WEEK, A.BASIS_YYYYMM;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_CAL_MONTH_END_DATE', NO_INVALIDATE => FALSE);
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_CAL_WEEK_END_DATE',  NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- MF_SP — 동적 PIVOT 대상 기본 데이터 구성
    -- BUCKET_CONVERSION PIVOT: MSSQL PIVOT(MAX(BUCKET_PER) FOR YYYYMMDD IN (SUN,MON,...))
    --   → Oracle PIVOT (MAX(BUCKET_PER) FOR YYYYMMDD IN ('SUN' AS SUN,'MON' AS MON,...))
    -- ====================================================================================================

    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DMF0082_MF_SP';

    INSERT /*+ APPEND PARALLEL(4) */ INTO SCM_MGR.GT_DMF0082_MF_SP
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, BUCKET_TYPE, BUCKET_KEY, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION, EDIT_FLAG, SORT_KEY, GROUP_ID
    , SUN, MON, TUE, WED, THU, FRI, SAT)
    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
         , F.CELL_PROD_SITE_ID
         , CAL.BUCKET_TYPE
         , CAL.BUCKET_KEY
         , SUM(F.QTY) AS QTY
         , MAX(F.MEASURE_GROUP)
         , MAX(F.CELL_MODEL), MAX(F.NICK_NAME), MAX(F.DMS_SALES), MAX(F.DMS_CUSTOMER)
         , MAX(F.OWNER), MAX(F.DEPT_ID), MAX(F.DEPT_NAME_KO)
         , MAX(F.FORECAST_INFO_CELL_PACK_COUNT), MAX(F.ITEM_TYPE)
         , MAX(F.PROJECT_NAME), MAX(F.PROJECT_OWNER), MAX(F.BIZ_TYPE)
         , MAX(F.SOLDTO_CUSTOMER), MAX(F.COUNTRY_NAME), MAX(F.CITY_NAME)
         , MAX(F.PROJECT_STATUS), MAX(F.ITEM_NAME), MAX(F.VMI_YN)
         , MAX(F.CUST_GROUP), MAX(F.CUST_GROUP_DTL), MAX(F.APPLICATION)
         , MAX(F.ROUTE), MAX(F.MDM_PROJECT_NAME), MAX(F.MIN_CAPACITY)
         , MAX(F.FORECAST_INFO_BIZ_TYPE), MAX(F.CELL_TYPE)
         , MAX(F.FORECAST_INFO_ALL), MAX(F.FORECAST_INFO_SPEC)
         , MAX(F.FORECAST_INFOR_VERSION), MAX(F.CELL_MODEL_NICK_NAME)
         , MAX(F.CELL_PER_CAR), MAX(F.CELL_PER_MODULE), MAX(F.MODULE_PER_CAR)
         , MAX(F.SORT_ORDER_NO), MAX(F.ENERGE), MAX(F.CELL_QUANTITY)
         , MAX(F.AS_FROM_SITE), MAX(F.CREATE_DATE), MAX(F.LAST_UPDATED_BY)
         , MAX(F.SENDER_CODE), MAX(F.SENDER_NAME), MAX(F.PROJECT_S_OP_REPORT)
         , MAX(F.CURRENCY), MAX(F.VERSION_NO), MAX(F.CUTOFF_YYYYMMDD)
         , MAX(F.NOTATION)
         /* EDIT_FLAG: 수정권한 — MA.EDIT_AUTH_YN 기반 */
         , CASE WHEN V_GROUP_ID = 'ADMIN' THEN 'Y'
                WHEN EXISTS (
                    SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE MA
                    WHERE  MA.MEASURE = F.MEASURE
                    AND    MA.EDIT_AUTH_YN = 'Y'
                    AND   (MA.TODAY_LIMIT_YN = 'N'
                           OR (MA.TODAY_LIMIT_YN = 'Y'
                               AND INSTR(
                                       REPLACE(TRIM(MA.TODAY_DAY_LIST),' ',''),
                                       CASE TO_NUMBER(TO_CHAR(SYSDATE,'D'))
                                           WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON'
                                           WHEN 3 THEN 'TUE' WHEN 4 THEN 'WED'
                                           WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
                                           WHEN 7 THEN 'SAT'
                                       END) > 0))
                ) THEN 'Y'
                ELSE 'N'
           END AS EDIT_FLAG
         /* SORT_KEY */
         , F.MEASURE_GROUP || LPAD(TO_CHAR(F.SORT_ORDER_NO), 10, '0') AS SORT_KEY
         /* GROUP_ID from user profile (DM_MST_USER or SCM_MST_USER) */
         , NULL AS GROUP_ID
         /* BUCKET PIVOT 컬럼: SUN~SAT */
         , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
    INNER JOIN (
        /* Daily bucket → date key */
        SELECT D.BASIS_YYYYMMDD
             , D.BASIS_YYYYMM || D.ISO_WEEK AS WEEK_KEY
             , CASE WHEN D.BASIS_YYYYMM || D.ISO_WEEK = WE.ISO_WEEK || WE.BASIS_YYYYMM
                    THEN WE.WEEK_END_DATE ELSE D.BASIS_YYYYMMDD END AS BUCKET_TYPE_KEY
             , TO_CHAR(D.BASIS_YYYYMMDD) AS BUCKET_KEY
             , 'D' AS BUCKET_TYPE
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M D
        LEFT JOIN SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE WE
            ON  WE.ISO_WEEK     = D.ISO_WEEK
            AND WE.BASIS_YYYYMM = D.BASIS_YYYYMM
        WHERE  D.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND V_EXP_YYYYMMDD
    ) CAL ON CAL.BASIS_YYYYMMDD = F.YYYYMMDD
    /* BUCKET_PER PIVOT: DM_MST_BUCKET_CONVERSION (DIVISION+SCM_SITE+INCOTERMS 기준) */
    LEFT JOIN LATERAL (
        SELECT PIVOT_DATA.SUN, PIVOT_DATA.MON, PIVOT_DATA.TUE
             , PIVOT_DATA.WED, PIVOT_DATA.THU, PIVOT_DATA.FRI, PIVOT_DATA.SAT
        FROM (
            SELECT BC.YYYYMMDD AS BUCKET_YYYYMMDD
                 , CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END AS BUCKET_PER
            FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
            WHERE  BC.DIVISION_ID = F.DIVISION_ID
            AND    BC.SCM_SITE_ID = F.SCM_SITE_ID
            AND    BC.INCOTERMS   = F.INCOTERMS
        ) SRC
        PIVOT (MAX(BUCKET_PER) FOR BUCKET_YYYYMMDD IN (
            'SUN' AS SUN, 'MON' AS MON, 'TUE' AS TUE, 'WED' AS WED,
            'THU' AS THU, 'FRI' AS FRI, 'SAT' AS SAT
        )) PIVOT_DATA
    ) PVT ON 1=1
    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
           , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
           , F.CELL_PROD_SITE_ID, CAL.BUCKET_TYPE, CAL.BUCKET_KEY, F.MEASURE_GROUP
           , F.SORT_ORDER_NO
           , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MF_SP', NO_INVALIDATE => FALSE);

    -- ====================================================================================================
    -- [DEFECT_GUARD] PIVOT IN 리스트 비어있음 방어 — C_BUCKET 이 0행 반환 시 빈 결과셋 조기 반환
    -- (SCM_SYS_CALENDAR_M 에 요청 날짜 범위의 데이터가 없으면 V_PV_LIST 공백 → ORA-00936)
    -- ====================================================================================================
    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_QTY_SUM);     EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC3 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC4 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC5 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS RESULT_CODE, 'NO_BUCKET_DATA' AS MESSAGE, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    -- ====================================================================================================
    -- 동적 SQL 구성 및 실행 (Case 86: CLOB 승격)
    -- ====================================================================================================

    DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

    -- V_QTY_SUM = NVL(pivot_col1,0)+NVL(pivot_col2,0)+... (PIVOT 후 QTY 컬럼 소실 대응)
    V_SQL := 'SELECT ' || V_COLUMN || '
    , (' || V_QTY_SUM || ') AS QTY
    , ' || V_PV_COL_LIST || '
    FROM (
        SELECT MSP.*, MSP.DEPT_ID AS TEAM_ID, MSP.CELL_MODEL AS FORECAST_INFO_CELL_MODEL, NVL(TO_CHAR(MSP.CREATE_DATE, ''YYYY-MM-DD HH24:MI:SS''), '' '') AS LAST_UPDATE_DATE, NVL(TO_CHAR(MSP.SUN),''0'')||NVL(TO_CHAR(MSP.MON),''0'')||NVL(TO_CHAR(MSP.TUE),''0'')||NVL(TO_CHAR(MSP.WED),''0'')||NVL(TO_CHAR(MSP.THU),''0'')||NVL(TO_CHAR(MSP.FRI),''0'')||NVL(TO_CHAR(MSP.SAT),''0'') AS BUCKET -- [FIX 2026-07-12] AS-IS #MF_SP alias 복원(TEAM_ID=DEPT_ID/FORECAST_INFO_CELL_MODEL=CELL_MODEL/LAST_UPDATE_DATE=CREATE_DATE/BUCKET=SUN..SAT) : GT 미보유 컬럼 ORA-00904 방지
             , CASE BUCKET_TYPE
                   WHEN ''D'' THEN ''D_'' || BUCKET_KEY
                   WHEN ''W'' THEN ''W_'' || BUCKET_KEY
                   WHEN ''M'' THEN ''M_'' || BUCKET_KEY
               END AS PIVOT_BUCKET
        FROM   SCM_MGR.GT_DMF0082_MF_SP MSP
    ) SRC
    PIVOT (SUM(QTY) FOR PIVOT_BUCKET IN (' || V_PV_LIST || '))
    ' || V_ORDERBY;

    OPEN O_RC1 FOR V_SQL;

    DBMS_LOB.FREETEMPORARY(V_SQL);
    DBMS_LOB.FREETEMPORARY(V_PV_LIST);
    DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST);
    DBMS_LOB.FREETEMPORARY(V_QTY_SUM);

    -- ====================================================================================================
    -- Result Set 2: M+3 까지의 Monthly 캘린더 정보
    -- ====================================================================================================

    OPEN O_RC2 FOR
        SELECT A.BASIS_YYYYMM
             , MAX(A.BASIS_YYYYMMDD) AS MONTH_END_DATE
             , TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(MIN(A.BASIS_YYYYMMDD), 'YYYYMMDD'), 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY A.BASIS_YYYYMM;

    -- ====================================================================================================
    -- Result Set 3: 현재 주차 / 오늘 시각 정보
    -- ====================================================================================================

    OPEN O_RC3 FOR
        SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') AS TODAY_DATE
             , CASE TO_NUMBER(TO_CHAR(SYSDATE, 'D'))
                   WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON' WHEN 3 THEN 'TUE'
                   WHEN 4 THEN 'WED' WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
                   WHEN 7 THEN 'SAT'
               END AS TODAY_DAY
             , SUBSTR(REPLACE(TO_CHAR(SYSDATE, 'HH24:MI:SS'), ':', ''), 1, 4) AS TODAY_TIME
        FROM   DUAL;

    -- ====================================================================================================
    -- Result Set 4: 메저별 수정권한 (ADMIN GROUP MEASURE)
    -- ====================================================================================================

    OPEN O_RC4 FOR
        SELECT MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST
        FROM   SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
        ORDER BY MEASURE;

    -- ====================================================================================================
    -- Result Set 5: 캘린더 주간 분포 (BUCKET CONVERSION)
    -- ====================================================================================================

    -- Result Set 5: 캘린더 주간 배분 정보 (M+4 월간 물량 배분용)
    OPEN O_RC5 FOR
        SELECT A.BASIS_YYYYMMDD
             , A.BASIS_YYYYMM
             , CASE WHEN SUBSTR(A.BASIS_START_DATE, -2) = '01' THEN 'Y' ELSE 'N' END AS FIRST_WEEK_FLAG
             , CASE WHEN SUBSTR(TO_CHAR(TO_DATE(A.BASIS_START_DATE,'YYYYMMDD')+7,'YYYYMMDD'),1,6)
                         = SUBSTR(A.BASIS_START_DATE,1,6)
                    THEN 'N' ELSE 'Y' END AS END_MONTH_FLAG
             , COUNT(*) OVER (PARTITION BY A.BASIS_YYYYMM) AS MONTH_DAY_CNT
             , COUNT(*) OVER (PARTITION BY A.ISO_WEEK) AS WEEK_DAY_CNT
             , A.ISO_WEEK
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        ORDER BY A.BASIS_YYYYMMDD;

    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- 소스 주석 보존 (legacy comment preservation)
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------
    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 시작
    -- #TEMP_DM_MST_ITEM_SINGLE_V 만들기 종료
    /* #TEMP_DM_MST_ITEM_SINGLE_V 만들기 시작 */
    /* #TEMP_DM_MST_ITEM_SINGLE_V 만들기 종료 */
    /* 조회 할 때 쓸 날짜 변수 세팅 시작 */
    /* 조회 할 때 쓸 날짜 변수 세팅 종료 */
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START ---------------------------------------------------------------------
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END ---------------------------------------------------------------------
    --기존 쿼리 주석 처리 후 일괄 변경
    --1.LAST_UPDATE_DATE 값을 가져올 때, CASE WHEN 에 소형사업부에서 사용하지 않는 메저들만 있어서 해당 로직 제거
    --2.가장 최근 데이터를 입력한 사용자ID가 아니라 MAX사용자ID로 가져와서 수정함
    --AND A.QTY <> 0
    -- #TempFcstNPrice 만들기
    -- #TempFcstNPrice 에 INSERT 한 메저들을 이용하여 판가 실적 계산
    -- 기본적인 MEASURE 포함
    -- MKT_FCST [R+P]의 P부분 (기준일 이후)
    -- MKT_FCST [P+P]의 P부분 (기준일 이전)
    -- MKT_FCST [P+P]의 P부분 (기준일 이후)
    -- RTF [R+P]의 R부분 (기준일 이전)
    -- LOC = MKT_AMT_LOC/RTF_SYS_RP
    -- KRW = MKT_AMT_KRW/RTF_SYS_RP
    -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
    -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 START---------
    -- 속도향상 위해 OUTER APPLY로 변경 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선 END---------
    -- 불필요 로직 제거 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
    -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 속도개선
    -- [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 실적 Unit Price 로직 변경 (MKT FCST Amt. /RTF[R+P]) START
    -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 ('-' ==> CELL_PROD_SITE_ID 추가됨)
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 'MKT_AMT_LOC', 'MKT_AMT_KRW' 메저 소숫점3자리 표현을 위해 NOTATION 변경 (INTEGER -> POINT3)
    --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 조회 시, 실적수량 Measure는 #TempSelectMeasure 의 RESULT_MEASURE 컬럼으로 매핑
    --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
    --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
    -- 소수점 타입 설정 POINT3은 소수점 3자리 INEGER는 정수
    --AND A.QTY <> 0 -- 0인 수량은 CREATE_DATE, LAST_UPDATED_BY가 NULL이 되어 PIVOT 에서 동일 KEY 인데 분리되는 현상 발생되어 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화
    --AND A.MEASURE IN ('') -- 필요한 경우 추가
    --AND A.MEASURE NOT IN ('') -- 필요한 경우 추가
    --AND A.PRICE <> 0) AS CREATE_DATE
    --AND QTY <> 0) AS CREATE_DATE
    --AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE
    --AND DOM_EXP = A.DOM_EXP AND FCST_TYPE = A.FCST_TYPE AND INCOTERMS = A.INCOTERMS AND MEASURE = A.MEASURE) AS LAST_UPDATED_BY
    --WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID
    -- WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID
    --, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
    --, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_FCST WITH(NOLOCK)
    --, (SELECT MAX(CREATE_DATE) FROM #T_LAST_DATA_SETUP_PRICE WITH(NOLOCK)
    --, (SELECT MAX(LAST_UPDATED_BY) FROM #T_LAST_DATA_SETUP_PRICE WITH(NOLOCK)
    --, (SELECT TOP 1 SENDER_CODE FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_CODE
    --, (SELECT TOP 1 SENDER_NAME FROM #T_EDI_SENDER WHERE SCM_SITE_ID = A.SCM_SITE_ID) AS SENDER_NAME
    --, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (주석처리)
    --ON  A.MEASURE = 'RTF_SYS_RP'
    --SELECT A.DIVISION_ID
    --    , A.PROJECT_CODE
    --    , A.PROJECT_CODE AS END_CUSTOMER
    --    , A.SCM_SITE_ID
    --    , A.ITEM_ID
    --    , A.DOM_EXP
    --    , A.FCST_TYPE
    --    , A.INCOTERMS
    --    , A.PLANT_SITE_ID
    --    , '-' AS CELL_PROD_SITE_ID
    --    , A.YYYYMMDD
    --    , A.QTY
    --    , B.MEASURE_GROUP
    --    , C.CELL_MODEL
    --    , C.NICK_NAME
    --    , C.DMS_SALES
    --    , C.DMS_CUSTOMER
    --    , C.[OWNER]
    --    , C.DEPT_ID
    --    , C.DEPT_NAME_KO
    --    , C.FORECAST_INFO_CELL_PACK_COUNT
    --    , C.ITEM_TYPE
    --    , C.PROJECT_NAME
    --    , C.PROJECT_OWNER
    --    , C.BIZ_TYPE
    --    , C.SOLDTO_CUSTOMER
    --    , C.COUNTRY_NAME
    --    , C.CITY_NAME
    --    , C.PROJECT_STATUS
    --    , C.ITEM_NAME
    --    , C.VMI_YN
    --    , C.CUST_GROUP
    --    , C.CUST_GROUP_DTL
    --    , C.[APPLICATION]
    --    , C.[ROUTE]
    --    , C.MDM_PROJECT_NAME
    --    , C.MIN_CAPACITY
    --    , C.FORECAST_INFO_BIZ_TYPE
    --    , C.CELL_TYPE
    --    , C.WHERE DIVISION_ID = A.DIVISION_ID AND PROJECT_CODE = A.PROJECT_CODE AND SCM_SITE_ID = A.SCM_SITE_ID AND ITEM_ID = A.ITEM_ID
    --SELECT '#TempFcstNPrice',* FROM #TempFcstNPrice -- 테스트
    /* DM_PLN_MKT_FCST_RESULT 테이블 기준 MEASURE */
    /* DM_PLN_CFM_MKT_DEMAND_PLAN_C 테이블 기준 MEASURE */
    /* DM_PLN_MKT_FCST_RESULT_C 테이블 기준 MEASURE */
    -----------------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- ====================================================================================================
    -- O_RESULT_CURSOR: 성공 응답
    -- ====================================================================================================

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG FROM DUAL;

    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, '정상종료', 'P_DMF0082_GET_MAIN_DATA END',
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_QTY_SUM); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'E', 0
              , 'ERROR: ' || V_SQL_ERRMSG
              , 'P_DMF0082_GET_MAIN_DATA ERROR'
              , SYSDATE
              , V_PROC_INPUT
              , V_SQL_CODE
              , V_SQL_ERRMSG
              , V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001, '['|| $$PLSQL_UNIT ||'] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_GET_MAIN_DATA;

END PKG_DMF0082;
/
