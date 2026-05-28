/*=============================================================================================
 * File         : 04_Package_PKG_DMF0053.sql
 * Description  : Package — PKG_DMF0053
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0053 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0053                                                                        */
/* Description : PKG_DMF0053                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.25  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0053_GET_CUST_FCST_WATERFALL
(
     P_DIVISION_ID      IN VARCHAR2
    ,P_DEPT_ID          IN VARCHAR2
    ,P_END_CUSTOMER     IN VARCHAR2
    ,P_SCM_SITE_ID      IN VARCHAR2
    ,P_PROJECT_CODE     IN VARCHAR2
    ,P_ITEM_ID          IN VARCHAR2
    ,P_ITEM_TYPE        IN VARCHAR2
    ,P_FROM_YYYYMMDD    IN VARCHAR2
    ,P_TO_YYYYMMDD      IN VARCHAR2
    ,P_CREATED_BY       IN VARCHAR2
    ,P_PLANT_SITE_ID    IN VARCHAR2
    ,P_BIZ_TYPE         IN VARCHAR2
    ,P_OWNER            IN VARCHAR2
    ,P_BUCKET           IN VARCHAR2
    ,P_USER_DEPT_ID     IN VARCHAR2
    ,P_GROUP_ID         IN VARCHAR2
    ,P_VERSION_NO       IN VARCHAR2
    ,P_FROM_CREATEDATE  IN VARCHAR2
    ,P_TO_CREATEDATE    IN VARCHAR2
    ,P_USER_ID          IN VARCHAR2
    ,P_MENU_ID          IN VARCHAR2
    
    ,O_RC1              OUT SYS_REFCURSOR
    ,O_RC2              OUT SYS_REFCURSOR
    ,O_RC3              OUT SYS_REFCURSOR
    ,O_RESULT_CURSOR    OUT SYS_REFCURSOR
);


END PKG_DMF0053;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0053 IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0053                                                                        */
/* Description : PKG_DMF0053                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.25  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0053_GET_CUST_FCST_WATERFALL
(
     P_DIVISION_ID      IN VARCHAR2
    ,P_DEPT_ID          IN VARCHAR2
    ,P_END_CUSTOMER     IN VARCHAR2
    ,P_SCM_SITE_ID      IN VARCHAR2
    ,P_PROJECT_CODE     IN VARCHAR2
    ,P_ITEM_ID          IN VARCHAR2
    ,P_ITEM_TYPE        IN VARCHAR2
    ,P_FROM_YYYYMMDD    IN VARCHAR2
    ,P_TO_YYYYMMDD      IN VARCHAR2
    ,P_CREATED_BY       IN VARCHAR2
    ,P_PLANT_SITE_ID    IN VARCHAR2
    ,P_BIZ_TYPE         IN VARCHAR2
    ,P_OWNER            IN VARCHAR2
    ,P_BUCKET           IN VARCHAR2
    ,P_USER_DEPT_ID     IN VARCHAR2
    ,P_GROUP_ID         IN VARCHAR2
    ,P_VERSION_NO       IN VARCHAR2
    ,P_FROM_CREATEDATE  IN VARCHAR2
    ,P_TO_CREATEDATE    IN VARCHAR2
    ,P_USER_ID          IN VARCHAR2
    ,P_MENU_ID          IN VARCHAR2
    
    ,O_RC1              OUT SYS_REFCURSOR
    ,O_RC2              OUT SYS_REFCURSOR
    ,O_RC3              OUT SYS_REFCURSOR
    ,O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0053_GET_CUST_FCST_WATERFALL
 * Description  : CUST Fcst Waterfall 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.03.27 chano0612   
   2023/12/05   kjj     PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 예외처리 항목 추가 작업중
 * 2023.12.07    kcw3408       [개발요청] 수요분석시스템_4_고객수요 Measure 통합 
 * 2023.12.20    hmin          [E20231124-001795] Customer FCST Waterfall 화면 조회 시 조건 적용 불완전함 개선
 * 2024.03.06    kcw3408       DM 프로시저 속도개선  
 * 2024.04.23    kcw3408       SENDER_NAME 30--> 200 으로 수정
 * 2024/08/28  KJJ      [PJ2024-50461] Team Mapping
 **************************************************************************************************
 */
IS
    V_PROGRAM_NAME    VARCHAR2(200 CHAR);
    V_PROC_INPUT      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);
    V_SQL_CODE        VARCHAR2(100 CHAR);
    V_SQL_ERRMSG      VARCHAR2(1000 CHAR);
    V_LOG_TYPE        VARCHAR2(100 CHAR);
    V_LOG_MESSAGE     VARCHAR2(4000 CHAR);
    V_DESCRIPTION     VARCHAR2(4000 CHAR);
    N_LOG_COUNT       PLS_INTEGER := 0;
    D_EVENT_DATE      DATE := SYSDATE;

    V_COLLIST         VARCHAR2(32767 CHAR);
    V_ORDERLIST       VARCHAR2(32767 CHAR);
    --V_NSQL            VARCHAR2(32767 CHAR);
    V_P_PROGRAM_ID    VARCHAR2(50 CHAR)  := 'DMF0053';
    V_P_SHEET_NAME    VARCHAR2(50 CHAR)  := 'custFcstWaterfall';

    V_I_COUNT         PLS_INTEGER := 0;
    V_USER_MEA_CNT    PLS_INTEGER := 0;

    -- 날짜 컬럼 동적 생성용
    V_PV_LIST         VARCHAR2(32767 CHAR) := '';
    V_PV_COL_LIST     VARCHAR2(32767 CHAR) := '';
    V_PV_COL          VARCHAR2(32767 CHAR) := '';

    -- 일반 컬럼 동적 생성용
    V_SQL_SELECT      VARCHAR2(32767 CHAR) := '';
    V_SQL_GROUPBY     VARCHAR2(32767 CHAR) := '';
    V_SQL_TEXT        VARCHAR2(32767 CHAR);
    --V_COL_CHUNK       VARCHAR2(4000 CHAR);
    
    V_RAW_DATA_CNT1   PLS_INTEGER := 0;
    --V_RAW_DATA_CNT2   PLS_INTEGER := 0;

    -- CURSOR FOR c_bucket
    CURSOR C_BUCKET IS
        SELECT
             '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
            ,'D_' || A.BASIS_YYYYMMDD || ' '                            AS PV_NAME
            , A.BASIS_YYYYMMDD || '_31'                                 AS SORT_ORDER_NO
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET = 'DAILY'

        UNION ALL

        SELECT '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
              ,'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' '                                      AS PV_NAME
              , A.BASIS_START_DATE || '_21'                                                     AS SORT_ORDER_NO
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET != 'ONLY_WEEKLY'
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE

        UNION ALL

        SELECT '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM AS COLUMN_NAME
              ,'M_' || A.BASIS_YYYYMM || ' '                        AS PV_NAME
              , MIN(A.BASIS_START_DATE) || '_01'                    AS SORT_ORDER_NO
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET != 'ONLY_WEEKLY'
        GROUP BY A.BASIS_YYYYMM

        UNION ALL

        SELECT '''W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK || '''  AS W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK AS COLUMN_NAME
              ,'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK || ' '                                                          AS PV_NAME
              , MAX(BASIS_YYYYMMDD) || '_21'                                                                                         AS SORT_ORDER_NO
        FROM   SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET = 'ONLY_WEEKLY'
        GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
        ORDER BY SORT_ORDER_NO;

    V_PV_COLUMN_NAME  VARCHAR2(500 CHAR);
    V_PV_NAME         VARCHAR2(500 CHAR);
    V_SORT_ORDER_NO   VARCHAR2(50 CHAR);

    V_I               PLS_INTEGER;
    V_CNT             PLS_INTEGER;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
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

    DBMS_OUTPUT.PUT_LINE('A--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

    ------------------------------------------------------------------------------------------
    --                                                       GTT 초기화
    -- (이전 일반 테이블 DML 없음 → TRUNCATE 사용 가능)
    ------------------------------------------------------------------------------------------
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_RAW_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_EDI_CALLOFF';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_ITEM_SINGLE_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_SITE_ITEM';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_SCM_MST_SITE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_ITEM_SINGLE_VT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_COLUMN_SETUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_CALENDAR';

    DBMS_OUTPUT.PUT_LINE('B--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    ------------------------------------------------------------------------------------------
    --  사용자 Measure 설정 체크 및 기본값 INSERT
    ------------------------------------------------------------------------------------------
    SELECT COUNT(*)
    INTO   V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID                     = V_P_PROGRAM_ID
    AND    U.SHEET_NAME                     = V_P_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE  = 'M'
    AND    U.USER_ID                        = P_CREATED_BY;

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
        SELECT P_CREATED_BY
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , ''
             , ''
             , P_CREATED_BY
             , SYSDATE
             , P_CREATED_BY
             , SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = V_P_PROGRAM_ID
        AND    C.SHEET_NAME   = V_P_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

    DBMS_OUTPUT.PUT_LINE('C1--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    ------------------------------------------------------------------------------------------
    -- #SELECT_MEASURE → TYPE T_SELECT_MEASURE (GTT 미사용: JOIN에만 활용되므로 WITH절 내재화)
    -- 단, #SELECT_MEASURE는 여러 단계에서 JOIN 사용 → GT_DM53_CALENDAR 없이 인라인으로 처리
    -- 실제 구현에서는 동적 SQL 내 WITH 절로 풀어서 사용
    ------------------------------------------------------------------------------------------

    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: DM_DNM_EDI_CALLOFF_ITEM 템프사용 */
    INSERT INTO SCM_MGR.GT_DM53_EDI_CALLOFF
               ( DIVISION_ID
               , SENDER_CODE
               , UNLOADING_POINT
               , CUST_MATERIAL_CODE
               , EXCEPTION_FLAG
               , EXCEPTION_DATE
               )
    SELECT DIVISION_ID
         , SENDER_CODE
         , UNLOADING_POINT
         , CUST_MATERIAL_CODE
         , MAX(EXCEPTION_FLAG)                       AS EXCEPTION_FLAG
         , MAX(TO_CHAR(EXCEPTION_DATE, 'YYYYMMDD'))  AS EXCEPTION_DATE
    FROM   DM_DNM_EDI_CALLOFF_ITEM
    WHERE  DIVISION_ID = P_DIVISION_ID
    GROUP BY DIVISION_ID
           , SENDER_CODE
           , UNLOADING_POINT
           , CUST_MATERIAL_CODE;

    DBMS_OUTPUT.PUT_LINE('D1--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- GTT 통계 수집 (JOIN 사용)
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM53_EDI_CALLOFF', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_DM53_EDI_CALLOFF',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );


    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: 불필요 컬럼 삭제 */
    INSERT INTO SCM_MGR.GT_DM53_RAW_DATA
               ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, YYYYMMDD
               , CUST_ITEM_ID, COUNTRY, CITY, FCST_TYPE, DOM_EXP, SENDER_NAME
               , PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT, MEASURE, MEASURE_GROUP
               , QTY, CREATE_DATE
               , LAST_UPDATED_BY
               , LAST_UPDATE_DATE
               , EDI_IF_SEQ
               , CUSTOMER_PLANT
               , EXCEPTION_FLAG
               , EXCEPTION_DATE
               )
    SELECT DISTINCT
              A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.YYYYMMDD
            , A.CUST_MATERIAL_CODE, A.COUNTRY, A.CITY, A.FCST_TYPE, A.DOM_EXP, A.SENDER_NAME
            , A.PLANT_SITE_ID, A.INCOTERMS, A.UNLOADING_POINT, A.MEASURE
            , (CASE WHEN A.DIVISION_ID = '40' AND E.MEASURE_GROUP IS NULL THEN ''
                    WHEN A.DIVISION_ID = '40' THEN E.MEASURE_GROUP
                    ELSE '' END) AS MEASURE_GROUP
            , A.QTY
            , A.CREATE_DATE
            , A.LAST_UPDATED_BY
            , REPLACE(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'), '-', '') AS LAST_UPDATE_DATE
            , A.EDI_IF_SEQ
            , A.CUSTOMER_PLANT
            , CITM.EXCEPTION_FLAG
            , CITM.EXCEPTION_DATE
    FROM   SCM_MGR.DM_PLN_CUST_FCST_H A
    JOIN  (
               /* #SELECT_MEASURE 인라인 : 사용자 선택 Measure 목록 */
               SELECT DISTINCT
                      SMSM.COLUMN_NAME AS MEASURE_GROUP
                    , U.COLUMN_NAME    AS MEASURE
                    , SMSM.SORT_ORDER_NO
                    , ''              AS SYSTEM_ADD
               FROM   SCM_MST_TITLESET_USER U
               JOIN   SCM_MST_SHEET_MEASURE SMSM
                   ON  U.PROGRAM_ID  = SMSM.PROGRAM_ID
                   AND U.SHEET_NAME  = SMSM.SHEET_NAME
                   AND U.COLUMN_NAME = SMSM.COLUMN_NAME
                   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                   AND SMSM.VALID_YN = 'Y'
               LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
                   ON  U.USER_ID      = T.SEGMENT4
                   AND P_CREATED_BY   = T.SEGMENT4
                   AND T.LOOKUP_TYPE  = 'TMM_MEASURE_ADMIN'
                   AND T.VALID_YN     = 'Y'
               WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
               AND    U.PROGRAM_ID = 'DMF0053'
               AND    U.SHEET_NAME = 'custFcstWaterfall'
               AND    U.USER_ID    = P_CREATED_BY
               AND    U.USER_ID    = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE P_CREATED_BY END

               UNION ALL

               SELECT A2.MEASURE_GROUP
                    , B2.MEASURE
                    , A2.SORT_ORDER_NO + B2.SORT_ORDER_NO AS SORT_ORDER_NO
                    , '' AS SYSTEM_ADD
               FROM  (
                          SELECT U.PROGRAM_ID
                               , U.SHEET_NAME
                               , U.USER_ID
                               , 'CUST_FCST_EDI' AS MEASURE_GROUP
                               , SMSM.SORT_ORDER_NO
                          FROM   SCM_MST_TITLESET_USER U
                          JOIN   SCM_MST_SHEET_MEASURE SMSM
                              ON  U.PROGRAM_ID  = SMSM.PROGRAM_ID
                              AND U.SHEET_NAME  = SMSM.SHEET_NAME
                              AND U.COLUMN_NAME = SMSM.COLUMN_NAME
                              AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                              AND SMSM.VALID_YN = 'Y'
                          WHERE  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND    U.PROGRAM_ID  = 'DMF0053'
                          AND    U.SHEET_NAME  = 'custFcstWaterfall'
                          AND    U.USER_ID     = P_CREATED_BY
                          AND    U.COLUMN_NAME = 'CUST_FCST_EDI'
                     ) A2,
                     (
                          SELECT 'Immidiate'                       AS MEASURE, 0.14 AS SORT_ORDER_NO FROM DUAL
                          UNION ALL SELECT 'Planning_Forecast',          0.17 FROM DUAL
                          UNION ALL SELECT 'Commercial_Agreement',        0.12 FROM DUAL
                          UNION ALL SELECT 'Firm_Temp',                   0.13 FROM DUAL
                          UNION ALL SELECT 'Manumacturing_Material_Temp', 0.15 FROM DUAL
                          UNION ALL SELECT 'Material_Temp',               0.16 FROM DUAL
                          UNION ALL SELECT 'Backorder',                   0.11 FROM DUAL
                     ) B2
               GROUP BY A2.PROGRAM_ID, A2.SHEET_NAME, A2.USER_ID
                      , A2.MEASURE_GROUP, B2.MEASURE
                      , A2.SORT_ORDER_NO + B2.SORT_ORDER_NO

               UNION ALL

               SELECT DISTINCT
                      'CUST_FCST' AS MEASURE_GROUP
                    , C2.MEASURE
                    , (SELECT SMSM2.SORT_ORDER_NO
                       FROM   SCM_MST_TITLESET_USER U2
                       JOIN   SCM_MST_SHEET_MEASURE SMSM2
                           ON  U2.PROGRAM_ID  = SMSM2.PROGRAM_ID
                           AND U2.SHEET_NAME  = SMSM2.SHEET_NAME
                           AND U2.COLUMN_NAME = SMSM2.COLUMN_NAME
                           AND U2.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                           AND SMSM2.VALID_YN = 'Y'
                       WHERE  U2.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                       AND    U2.PROGRAM_ID  = 'DMF0053'
                       AND    U2.SHEET_NAME  = 'custFcstWaterfall'
                       AND    U2.USER_ID     = P_CREATED_BY
                       AND    U2.COLUMN_NAME = 'CUST_FCST') + 0.1 AS SORT_ORDER_NO
                    , '' AS SYSTEM_ADD
               FROM   DM_MST_CUSTOMER_FCST C2
               WHERE  1 = 1
               AND    C2.MEASURE_GROUP = 'CUST_FCST'
               AND    C2.MEASURE      IS NOT NULL
               AND    C2.VALID_YN      = 'Y'
               AND    EXISTS (
                          SELECT 1
                          FROM   SCM_MST_TITLESET_USER X
                          WHERE  X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                          AND    X.PROGRAM_ID  = 'DMF0053'
                          AND    X.SHEET_NAME  = 'custFcstWaterfall'
                          AND    X.USER_ID     = P_CREATED_BY
                          AND    X.COLUMN_NAME = 'CUST_FCST'
                          AND    X.COLUMN_NAME = C2.MEASURE_GROUP
                     )
          ) E
        ON A.MEASURE = E.MEASURE
    LEFT OUTER JOIN SCM_MGR.GT_DM53_EDI_CALLOFF CITM
        ON  CITM.DIVISION_ID        = A.DIVISION_ID
        AND CITM.SENDER_CODE        = A.SENDER_CODE
        AND CITM.UNLOADING_POINT    = A.UNLOADING_POINT
        AND CITM.CUST_MATERIAL_CODE = A.CUST_MATERIAL_CODE
    WHERE  A.DIVISION_ID   = P_DIVISION_ID
    AND    A.YYYYMMDD     >= P_FROM_YYYYMMDD
    AND    A.YYYYMMDD     <= P_TO_YYYYMMDD
    AND    A.CREATE_DATE  >= TO_DATE(P_FROM_CREATEDATE, 'YYYYMMDD')
    AND    A.CREATE_DATE  <= TO_DATE(P_TO_CREATEDATE,   'YYYYMMDD') + 1 - 1/86400;

    DBMS_OUTPUT.PUT_LINE('E1--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- GTT 통계 수집 (JOIN/DELETE 대상)
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM53_RAW_DATA', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_DM53_RAW_DATA',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );

    DBMS_OUTPUT.PUT_LINE('E2--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: #TEMP_DM_MST_ITEM_SINGLE_V 테이블 변경 */
    INSERT INTO SCM_MGR.GT_DM53_ITEM_SINGLE_V
               ( DIVISION_ID, ITEM_ID, ITEM_CLASS
               , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
               , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
               , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
               , ENERGE, CELL_QUANTITY
               , MDM_PROJECT_NAME, CELL_TYPE, SCP_EXTRA_SPEC
               )
    SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.ITEM_CLASS
         , A.ITEM_NAME, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MIN_CAPACITY
         , A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_PRODUCT_GROUP
         , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
         , A.ENERGE, A.CELL_QUANTITY
         , A.MDM_PROJECT_NAME, A.CELL_TYPE, A.SCP_EXTRA_SPEC
    FROM  (
               SELECT T1.DIVISION_ID
                    , T1.ITEM_ID
                    , MAX(T1.ITEM_NAME)           AS ITEM_NAME
                    , MAX(T1.ITEM_CLASS)           AS ITEM_CLASS
                    , MAX(T1.ITEM_CLASS_NAME)      AS ITEM_CLASS_NAME
                    , MAX(T1.NICK_NAME)            AS NICK_NAME
                    , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                                    WHEN T1.ITEM_TYPE = 'H' THEN 2
                                    WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                    ELSE 4 END)
                           WHEN 1 THEN 'P'
                           WHEN 2 THEN 'H'
                           WHEN 3 THEN 'Q'
                           ELSE 'R' END              AS ITEM_TYPE
                    , MAX(T1.MATERIAL_CLASS_NAME)  AS MATERIAL_CLASS_NAME
                    , MAX(T1.ITEM_UOM)             AS ITEM_UOM
                    , MAX(T1.SPEC)                 AS SPEC
                    , MAX(T1.MDM_PROJECT_NAME)     AS MDM_PROJECT_NAME
                    , MAX(T1.MIN_CAPACITY)         AS MIN_CAPACITY
                    , MAX(T2.FORECAST_INFO_BIZ_TYPE)           AS FORECAST_INFO_BIZ_TYPE
                    , MAX(T2.FORECAST_INFO_PRODUCT_GROUP)      AS FORECAST_INFO_PRODUCT_GROUP
                    , MAX(T2.FORECAST_INFO_CELL_MODEL)         AS FORECAST_INFO_CELL_MODEL
                    , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT)    AS FORECAST_INFO_CELL_PACK_COUNT
                    , MAX(T2.FORECAST_INFO_SPEC)               AS FORECAST_INFO_SPEC
                    , MAX(T2.FORECAST_INFOR_VERSION)           AS FORECAST_INFOR_VERSION
                    , MAX(T1.ACTIVE_FLAG)          AS ACTIVE_FLAG
                    , MAX(T2.CELL_TYPE)            AS CELL_TYPE
                    , MAX(T1.ENERGE)               AS ENERGE
                    , MAX(T1.CELL_QUANTITY)        AS CELL_QUANTITY
                    , MAX(T1.SCP_EXTRA_SPEC)       AS SCP_EXTRA_SPEC
               FROM   SCM_MST_ITEM_SN T1
               INNER JOIN (
                               SELECT DIVISION_ID
                                    , SUBSTR(ITEM_ID, 1, 12)             AS ITEM_ID
                                    , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                                    , MAX(FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
                                    , MAX(FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
                                    , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                                    , MAX(FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
                                    , MAX(FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
                                    , MAX(CELL_TYPE)                     AS CELL_TYPE
                               FROM   SCM_MST_ITEM_SN T2
                               WHERE  DIVISION_ID = P_DIVISION_ID
                               GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
                          ) T2
                   ON  T1.DIVISION_ID          = T2.DIVISION_ID
                   AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
               WHERE  T1.DIVISION_ID = P_DIVISION_ID
               GROUP BY T1.DIVISION_ID, T1.ITEM_ID
          ) A
    JOIN  ( SELECT DISTINCT DIVISION_ID, ITEM_ID
            FROM   SCM_MGR.GT_DM53_RAW_DATA ) B
        ON  A.DIVISION_ID = B.DIVISION_ID
        AND A.ITEM_ID     = B.ITEM_ID
    WHERE  A.DIVISION_ID = P_DIVISION_ID;

    DBMS_OUTPUT.PUT_LINE('E3--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- GTT 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM53_ITEM_SINGLE_V', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_DM53_ITEM_SINGLE_V',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );


    -- #CALENDAR → GT_DM53_CALENDAR
    INSERT INTO SCM_MGR.GT_DM53_CALENDAR
               ( BASIS_YYYYMMWW, ISO_YYYYWW, ISO_WEEK, BASIS_YYYYMMDD, END_FLAG, BASIS_YYYYMM )
    SELECT A.BASIS_YYYYMMWW
         , A.ISO_YYYYWW
         , A.ISO_WEEK
         , B.BASIS_YYYYMMDD
         , B.END_FLAG
         , B.BASIS_YYYYMM
    FROM  (
               SELECT SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW
                    , ISO_YYYYWW
                    , ISO_WEEK
               FROM   SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
               AND    BASIS_YYYYMMDD <= P_TO_YYYYMMDD
               GROUP BY ISO_YYYYWW, ISO_WEEK
          ) A
    JOIN   SCM_SYS_CALENDAR_M B
        ON  A.ISO_YYYYWW = B.ISO_YYYYWW
        AND A.ISO_WEEK   = B.ISO_WEEK;

    DBMS_OUTPUT.PUT_LINE('E3.1--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- #TEMP_SCM_MST_SITE_ITEM → GT_DM53_SITE_ITEM
    INSERT INTO SCM_MGR.GT_DM53_SITE_ITEM
               ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
               , APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL
               , CELL_PER_CAR, CELL_PER_MODULE, SALES_COMPANY
               , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8
               , REPORT_GROUP6
               , OWNER, OWNER_NAME, OWNER_NAME_KO
               , DEPT_ID
               , VALID_YN
               )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.APPLICATION, A.CUST_GROUP, A.ROUTE, A.CUST_GROUP_DTL
         , A.CELL_PER_CAR, A.CELL_PER_MODULE, A.SALES_COMPANY
         , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE5, A.ATTRIBUTE7, A.ATTRIBUTE8
         , NULL   AS REPORT_GROUP6
         , A.OWNER
         , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'EN') AS OWNER_NAME
         , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'KO') AS OWNER_NAME_KO
         , ( SELECT SU.DEPT_ID
             FROM   SCM_MST_SSO_USER_INFO SU
             WHERE  SU.USER_ID = TRIM(REGEXP_SUBSTR(A.OWNER, '[^,]+', 1, 1)) ) AS DEPT_ID
         , A.VALID_YN
    FROM   SCM_MST_SITE_ITEM A
    JOIN  ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
            FROM   SCM_MGR.GT_DM53_RAW_DATA ) B
        ON  A.DIVISION_ID  = B.DIVISION_ID
        AND A.SCM_SITE_ID  = B.SCM_SITE_ID
        AND A.PROJECT_CODE = B.PROJECT_CODE
        AND A.ITEM_ID      = B.ITEM_ID
    WHERE  A.DIVISION_ID = P_DIVISION_ID;

    DBMS_OUTPUT.PUT_LINE('E4--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- GTT 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM53_SITE_ITEM', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_DM53_SITE_ITEM',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );


    --------------------------------------------------------------------------------------------------------------------------------------------
    -- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
    --------------------------------------------------------------------------------------------------------------------------------------------
    -- 필터링 시작

    IF NVL(P_PROJECT_CODE,'@#@#@#') <> '@#@#@#' THEN  -- 소형은 UI 에서 PROJECT DISABLE 됨

        --[E20231124-001795] Customer FCST Waterfall 화면 조회 시 조건 적용 불완전함 개선===
        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA
        WHERE NVL(PROJECT_CODE, '@#@#@#') = '@#@#@#';

        DBMS_OUTPUT.PUT_LINE('E5.1--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
        --===============================================================================

        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
        WHERE NOT EXISTS (
            SELECT 1
            FROM   SCM_MGR.SCM_MST_PROJECT B
            WHERE  A.DIVISION_ID  = B.DIVISION_ID
            AND    A.PROJECT_CODE = B.PROJECT_CODE
            AND    (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE B.PROJECT_CODE LIKE P.TOKEN ||'%')
                    OR
                    EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PROJECT_CODE,',')) P WHERE B.PROJECT_NAME LIKE P.TOKEN ||'%')
                   )
        );

        DBMS_OUTPUT.PUT_LINE('E5.2--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF NVL(P_ITEM_ID,'@#@#@#') <> '@#@#@#' THEN
        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
        WHERE NOT EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE A.ITEM_ID LIKE P.TOKEN ||'%')
        AND   NOT EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_DM53_ITEM_SINGLE_V B
            WHERE  A.ITEM_ID = B.ITEM_ID
            AND    EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_ID,',')) P WHERE B.NICK_NAME LIKE P.TOKEN ||'%')
        );

        DBMS_OUTPUT.PUT_LINE('E5.3--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF NVL(P_OWNER,'@#@#@#') <> '@#@#@#' THEN
        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
        WHERE NOT EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_DM53_SITE_ITEM B
            WHERE  A.ITEM_ID      = B.ITEM_ID
            AND    A.SCM_SITE_ID  = B.SCM_SITE_ID
            AND    A.PROJECT_CODE = B.PROJECT_CODE
            AND    (EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER LIKE P.TOKEN ||'%')
                    OR
                    EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER_NAME LIKE P.TOKEN ||'%')
                    OR
                    EXISTS (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,',')) P WHERE B.OWNER_NAME_KO LIKE P.TOKEN ||'%')
                   )
        );

        DBMS_OUTPUT.PUT_LINE('E5.4--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_DEPT_ID != 'ALL' THEN
        --[PJ2024-50461] Team Mapping------------------------------------
        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
        WHERE NOT EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_DM53_SITE_ITEM B
            JOIN  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_OWNER,','))) C
                   ON B.DEPT_ID = C.TOKEN
            WHERE  A.ITEM_ID      = B.ITEM_ID
            AND    A.SCM_SITE_ID  = B.SCM_SITE_ID
            AND    A.PROJECT_CODE = B.PROJECT_CODE
        );

        DBMS_OUTPUT.PUT_LINE('E5.5--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_END_CUSTOMER != 'ALL' THEN
        IF P_DIVISION_ID = '40' THEN
            DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1
                FROM  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,','))) C
                WHERE A.PROJECT_CODE = C.TOKEN
            );
        ELSE
            DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1
                FROM   SCM_MST_SITE B
                JOIN  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER,','))) C
                       ON B.END_CUSTOMER = C.TOKEN
                WHERE  A.SCM_SITE_ID = B.SCM_SITE_ID
                AND    B.DIVISION_ID = P_DIVISION_ID
            );
        END IF;

        DBMS_OUTPUT.PUT_LINE('E5.6--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_SCM_SITE_ID != 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
        WHERE NOT EXISTS (
            SELECT 1
            FROM  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_SCM_SITE_ID,','))) C
            WHERE A.SCM_SITE_ID = C.TOKEN
        );

        DBMS_OUTPUT.PUT_LINE('E5.7--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_PLANT_SITE_ID != 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
        WHERE NOT EXISTS (
            SELECT 1
            FROM  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_PLANT_SITE_ID,','))) C
            WHERE A.PLANT_SITE_ID = C.TOKEN
        );

        DBMS_OUTPUT.PUT_LINE('E5.8--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_ITEM_TYPE != 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
        WHERE NOT EXISTS (
            SELECT 1
            FROM   SCM_MGR.GT_DM53_ITEM_SINGLE_V B
            JOIN  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_ITEM_TYPE,','))) C
                   ON B.ITEM_TYPE = C.TOKEN
            WHERE  A.ITEM_ID = B.ITEM_ID
        );

        DBMS_OUTPUT.PUT_LINE('E5.9--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    IF P_BIZ_TYPE != 'ALL' THEN
        IF P_DIVISION_ID = '40' THEN
            DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1
                FROM   SCM_MGR.GT_DM53_ITEM_SINGLE_V B
                JOIN  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_BIZ_TYPE,','))) C
                       ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
                WHERE  A.ITEM_ID = B.ITEM_ID
            );
        ELSE
            DELETE FROM SCM_MGR.GT_DM53_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1
                FROM   SCM_MST_PROJECT B
                JOIN  (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_BIZ_TYPE,','))) C
                       ON B.BIZ_TYPE LIKE '%' || C.TOKEN || '%'
                WHERE  A.DIVISION_ID  = B.DIVISION_ID
                AND    A.PROJECT_CODE = B.PROJECT_CODE
            );
        END IF;

        DBMS_OUTPUT.PUT_LINE('E5.10--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));
    END IF;

    -- 필터링 끝
    SELECT COUNT(1)
    INTO   V_RAW_DATA_CNT1
    FROM   SCM_MGR.GT_DM53_RAW_DATA A
    ;

    DBMS_OUTPUT.PUT_LINE('F--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT)||' : '||V_RAW_DATA_CNT1);

    ------------------------------------------------------------------------------------------
    --   [개발요청] 수요분석시스템_4_고객수요 Measure 통합(Cust. Fcst에 CUST_FCST_EDI를 추가) 20231207
    ------------------------------------------------------------------------------------------
    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: 불 필요 컬럼 삭제 */
    INSERT INTO SCM_MGR.GT_DM53_RAW_DATA
               ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, YYYYMMDD
               , CUST_ITEM_ID, COUNTRY, CITY, FCST_TYPE, DOM_EXP, SENDER_NAME
               , PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT, MEASURE, MEASURE_GROUP
               , QTY, CREATE_DATE
               , LAST_UPDATED_BY
               , LAST_UPDATE_DATE
               , EDI_IF_SEQ
               , CUSTOMER_PLANT
               , EXCEPTION_FLAG
               , EXCEPTION_DATE
               )
    SELECT DISTINCT
              DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, YYYYMMDD
            , CUST_ITEM_ID, COUNTRY, CITY, FCST_TYPE, DOM_EXP, SENDER_NAME
            , PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT
            , 'CUST_FCST'   AS MEASURE
            , 'CUST_FCST'   AS MEASURE_GROUP
            , QTY, CREATE_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
            , EDI_IF_SEQ
            , CUSTOMER_PLANT
            , EXCEPTION_FLAG
            , EXCEPTION_DATE
    FROM   SCM_MGR.GT_DM53_RAW_DATA A
    WHERE  A.MEASURE = 'CUST_FCST_EDI';

    DBMS_OUTPUT.PUT_LINE('F_1--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    ------------------------------------------------------------------------------------------
    --  컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
    ------------------------------------------------------------------------------------------

    -- 컬럼리스트 생성

    -- 날짜컬럼 생성 (CURSOR c_bucket)
    V_PV_LIST     := ' ';
    V_PV_COL_LIST := ' ';
    V_PV_COL      := ' ';

    OPEN C_BUCKET;
    LOOP
        FETCH C_BUCKET INTO V_PV_COLUMN_NAME, V_PV_NAME, V_SORT_ORDER_NO;
        EXIT WHEN C_BUCKET%NOTFOUND;

        V_PV_COL_LIST := V_PV_COL_LIST || CASE WHEN V_PV_COL_LIST != ' ' THEN ',' ELSE ' ' END || V_PV_COLUMN_NAME || CHR(10);
        V_PV_LIST     := V_PV_LIST     || CASE WHEN V_PV_LIST     != ' ' THEN ',' ELSE ' ' END || V_PV_NAME || CHR(10);
        V_PV_COL      := V_PV_COL      || CASE WHEN V_PV_COL      != ' ' THEN ',' ELSE ' ' END || 'NVL(' || V_PV_NAME || ', 0) AS ' || V_PV_NAME || CHR(10);
    END LOOP;
    CLOSE C_BUCKET;

    -- #TEMP_SCM_MST_SITE → GT_DM53_SCM_MST_SITE
    INSERT INTO SCM_MGR.GT_DM53_SCM_MST_SITE
               ( SCM_SITE_ID, PROJECT_CODE, DIVISION_ID, ITEM_ID, DEPT_ID, SOLDTO_CODE
               , VMI_YN, END_CUSTOMER, SOLDTO_CUSTOMER
               , CITY_NAME, COUNTRY_NAME )
    SELECT B.SCM_SITE_ID
         , B.PROJECT_CODE
         , B.DIVISION_ID
         , B.ITEM_ID
         , B.DEPT_ID
         , K.SOLDTO_CODE
         , B.VMI_YN
         , B.END_CUSTOMER
         , B.SOLDTO_CUSTOMER
         , H.CITY_NAME
         , J.COUNTRY_NAME
    FROM   (SELECT A.DIVISION_ID, B.PROJECT_CODE, A.SCM_SITE_ID, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.SOLDTO_CUSTOMER, A.CITY, A.COUNTRY
              FROM SCM_MGR.SCM_MST_SITE A
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                        ON A.DIVISION_ID = B.DIVISION_ID 
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID 
             WHERE 1=1
             GROUP BY A.DIVISION_ID, B.PROJECT_CODE, A.SCM_SITE_ID, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.SOLDTO_CUSTOMER, A.CITY, A.COUNTRY
            ) B
    LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER K
        ON  B.DIVISION_ID = K.DIVISION_ID
        AND B.SCM_SITE_ID = K.SCM_SITE_ID
        AND K.REP_YN = 'Y'
    LEFT OUTER JOIN SCM_MGR.SCM_MST_CITY H
        ON  B.CITY = H.CITY
    LEFT OUTER JOIN SCM_MGR.SCM_MST_COUNTRY J
        ON  B.COUNTRY = J.COUNTRY;

    DBMS_OUTPUT.PUT_LINE('F_1.1--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- GTT 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM53_SCM_MST_SITE', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_DM53_SCM_MST_SITE',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );

    -- #TEMP_DM_MST_ITEM_SINGLE_V_T → GT_DM53_ITEM_SINGLE_VT
    INSERT INTO SCM_MGR.GT_DM53_ITEM_SINGLE_VT
               ( DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME
               , NICK_NAME, ITEM_TYPE, MIN_CAPACITY
               , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
               , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
               , ENERGE, CELL_QUANTITY, MDM_PROJECT_NAME, CELL_TYPE, SCP_EXTRA_SPEC
               , SEGMENT2, CELL_MODEL_NICK_NAME
               )
    SELECT D.DIVISION_ID, D.ITEM_ID, D.ITEM_CLASS, D.ITEM_NAME, D.ITEM_CLASS_NAME
         , D.NICK_NAME, D.ITEM_TYPE, D.MIN_CAPACITY
         , D.FORECAST_INFO_BIZ_TYPE, D.FORECAST_INFO_CELL_PACK_COUNT, D.FORECAST_INFO_PRODUCT_GROUP
         , D.FORECAST_INFO_CELL_MODEL, D.FORECAST_INFO_SPEC, D.FORECAST_INFOR_VERSION
         , D.ENERGE, D.CELL_QUANTITY, D.MDM_PROJECT_NAME, D.CELL_TYPE, D.SCP_EXTRA_SPEC
         , E.SEGMENT2
         , NVL(F.NICK_NAME, '') AS CELL_MODEL_NICK_NAME
    FROM   SCM_MGR.GT_DM53_ITEM_SINGLE_V D
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E
        ON  D.CELL_TYPE   = E.SEGMENT1
        AND E.LOOKUP_TYPE = 'CELL_TYPE'
    LEFT OUTER JOIN SCM_MGR.GT_DM53_ITEM_SINGLE_V F
        ON  D.DIVISION_ID              = F.DIVISION_ID
        AND NVL(D.FORECAST_INFO_CELL_MODEL, '') = F.ITEM_ID;

    DBMS_OUTPUT.PUT_LINE('F_1.2--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- GTT 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM53_ITEM_SINGLE_VT', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => 'GT_DM53_ITEM_SINGLE_VT',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
    );

    -- 일반 컬럼 생성
    V_COLLIST   := '';
    V_ORDERLIST := '';

    SELECT COUNT(*)
    INTO   V_I_COUNT
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID                    = V_P_PROGRAM_ID
    AND    U.SHEET_NAME                    = V_P_SHEET_NAME
    AND    U.USER_ID                       = P_CREATED_BY
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

    IF V_I_COUNT = 0 THEN
        SELECT LISTAGG(' ' || COLUMN_NAME || ' ', ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
             , LISTAGG(' ' || COLUMN_NAME || '  ' || DATA_SORT_METHOD_CODE, ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
        INTO   V_COLLIST, V_ORDERLIST
        FROM  (
                   SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                   FROM   SCM_MST_SHEET_COLUMNS C
                   WHERE  1 = 1
                   AND    C.PROGRAM_ID  = V_P_PROGRAM_ID
                   AND    C.SHEET_NAME  = V_P_SHEET_NAME
                   AND    ( C.DEFAULT_FLAG = 'Y'
                            OR (    C.VISIBLE_FLAG = ''
                                AND C.DEFAULT_FLAG  = 'Y'
                                AND C.VALID_YN      = 'Y'
                               )
                           )
              );
    ELSE
        SELECT LISTAGG(' ' || COLUMN_NAME || ' ', ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
             , LISTAGG(' ' || COLUMN_NAME || '  ' || DATA_SORT_METHOD_CODE, ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
        INTO   V_COLLIST, V_ORDERLIST
        FROM  (
                   SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
                   FROM   SCM_MST_TITLESET_USER U
                   INNER JOIN SCM_MST_SHEET_COLUMNS C
                       ON  U.PROGRAM_ID  = C.PROGRAM_ID
                       AND U.SHEET_NAME  = C.SHEET_NAME
                       AND U.COLUMN_NAME = C.COLUMN_NAME
                       AND U.PROGRAM_ID  = V_P_PROGRAM_ID
                       AND U.SHEET_NAME  = V_P_SHEET_NAME
                       AND U.USER_ID     = P_CREATED_BY
                       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                       AND U.COLUMN_NAME NOT IN ('MEASURE')

                   UNION ALL

                   SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                   FROM   SCM_MST_SHEET_COLUMNS C
                   WHERE  1 = 1
                   AND    C.PROGRAM_ID  = V_P_PROGRAM_ID
                   AND    C.SHEET_NAME  = V_P_SHEET_NAME
                   AND    C.VISIBLE_FLAG = ''
                   AND    C.DEFAULT_FLAG = 'Y'
                   AND    C.VALID_YN     = 'Y'
                   AND    ROWNUM        <= 100
              );
    END IF;

    DBMS_OUTPUT.PUT_LINE('F_1.3--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    -- [MEASURE] → [MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO] 치환
    V_COLLIST   := REPLACE(V_COLLIST,   'MEASURE', 'MEASURE_GROUP,MEASURE,SORT_ORDER_NO');

    IF P_DIVISION_ID = '81' THEN
        V_ORDERLIST := REPLACE(V_ORDERLIST, ',EDI_IF_SEQ ASC,CREATE_DATE ASC', '');
    ELSIF P_DIVISION_ID = '40' THEN
        V_ORDERLIST := REPLACE(V_ORDERLIST, ',CREATE_DATE ASC', '');
    END IF;

    V_ORDERLIST := REPLACE(V_ORDERLIST, 'MEASURE', 'SORT_ORDER_NO');

    -- CTE 에서 사용할 SELECT COLUMN 정리
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM53_COLUMN_SETUP';

    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DIVISION_ID',                  'A.DIVISION_ID');
    --[PJ2024-50461] Team Mapping------------------------------------
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID',                      'C.DEPT_ID');
    --[PJ2024-50461] Team Mapping------------------------------------
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER40',               'CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE '''' END AS END_CUSTOMER40');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER',                 'NVL(B.END_CUSTOMER, '' '') AS END_CUSTOMER');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME',                'G.BIZ_TYPE AS BIZ_TYPE_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'COUNTRY_NAME',                 'B.COUNTRY_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CITY_NAME',                    'B.CITY_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID',                  'A.SCM_SITE_ID');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_CODE',                 'A.PROJECT_CODE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_NAME',                 'G.PROJECT_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_STATUS',               'G.PROJECT_STATUS');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_OWNER',                'G.PROJECT_OWNER');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID',                      'A.ITEM_ID');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID40',                    'A.ITEM_ID AS ITEM_ID40');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_NAME',                    'NVL(D.ITEM_NAME, '''') AS ITEM_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NICK_NAME',                    'NVL(D.NICK_NAME, '''') AS NICK_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'INCOTERMS',                    'A.INCOTERMS');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_TYPE',                    'NVL(D.ITEM_TYPE, '''') AS ITEM_TYPE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FCST_TYPE',                    'A.FCST_TYPE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DOM_EXP',                      'A.DOM_EXP');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PLANT_SITE_ID',                'A.PLANT_SITE_ID');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP',                   'C.CUST_GROUP');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP_DTL',               'C.CUST_GROUP_DTL');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OWNER',                        'C.OWNER_NAME AS OWNER');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'APPLICATION',                  'C.APPLICATION');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ROUTE',                        'C.ROUTE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MDM_PROJECT_NAME',             'D.MDM_PROJECT_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MIN_CAPACITY',                 'D.MIN_CAPACITY');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME40',              'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_PRODUCT_GROUP',  'D.FORECAST_INFO_PRODUCT_GROUP');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_MODEL',     'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_PACK_COUNT','D.FORECAST_INFO_CELL_PACK_COUNT');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_ALL',            'D.FORECAST_INFO_SPEC || D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_SPEC',           'D.FORECAST_INFO_SPEC');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFOR_VERSION',       'D.FORECAST_INFOR_VERSION');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_MODEL_NICK_NAME',         'NVL(D.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VMI_YN',                       'B.VMI_YN');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_TYPE',                    'D.SEGMENT2 AS CELL_TYPE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_CAR',                 'C.CELL_PER_CAR');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_MODULE',              'C.CELL_PER_MODULE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MODULE_PER_CAR',               'CASE WHEN C.CELL_PER_MODULE <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ENERGE',                       'D.ENERGE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QUANTITY',                'D.CELL_QUANTITY');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRIORITY',                     'C.ATTRIBUTE7 AS PRIORITY');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE',
           CHR(10) || 'CASE WHEN A.MEASURE = ''Customer FCST'' THEN '
        || CHR(10) || '(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA'' '
        || CHR(10) || '     ELSE ''Cust.FCST_EXCEL'' END) '
        || CHR(10) || 'ELSE A.MEASURE END AS MEASURE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE_GROUP',                'M.MEASURE_GROUP');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_SALES',                    'NVL(C.ATTRIBUTE1,'''') AS DMS_SALES');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_CUSTOMER',                 'NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'REPORT_GROUP6',                'C.REPORT_GROUP6');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'TEAM_NAME_KO',                 'N.DEPT_NAME_KO AS TEAM_NAME_KO');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_NAME_KO',                 'O.DEPT_NAME_KO');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_BIZ_TYPE',       'D.FORECAST_INFO_BIZ_TYPE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE',                     'G.BIZ_TYPE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CUSTOMER',              'B.SOLDTO_CUSTOMER');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID40',                'CASE WHEN A.DIVISION_ID = ''40'' THEN A.SCM_SITE_ID ELSE '''' END AS SCM_SITE_ID40');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_USE_YN',
           CHR(10) || 'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Req'' THEN ''Y'' '
        || CHR(10) || 'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE IN (''MKT_FCST_RP'',''MKT_FCST'') THEN ''Y'' '
        || CHR(10) || 'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Plan'' THEN ''Y'' '
        || CHR(10) || 'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE IN (''RTF'',''RTF_SCP'',''RTF_SYS_RP'') THEN ''Y'' '
        || CHR(10) || 'ELSE '''' END AS SCP_USE_YN');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_EXTRA_SPEC',               'D.SCP_EXTRA_SPEC');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SALES_COMPANY',                'C.SALES_COMPANY');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CODE',                  'B.SOLDTO_CODE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_CELL',                     'C.ATTRIBUTE8 AS KWH_CELL');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_MODULE',
           CHR(10) || 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' '
        || CHR(10) || 'THEN TO_NUMBER(C.CELL_PER_MODULE * C.ATTRIBUTE8) ELSE NULL END AS KWH_MODULE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_PACK',
           CHR(10) || 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' '
        || CHR(10) || 'THEN TO_NUMBER(C.CELL_PER_CAR * C.ATTRIBUTE8) ELSE NULL END AS KWH_PACK');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_ITEM_ID',                 'A.CUST_ITEM_ID');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_NAME',                  'A.SENDER_NAME');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'UNLOADING_POINT',              'A.UNLOADING_POINT');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CREATE_DATE',                  'A.CREATE_DATE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATE_DATE',             'A.LAST_UPDATE_DATE');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATED_BY',              'A.LAST_UPDATED_BY');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CITY',                         'A.CITY');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'COUNTRY',                      'A.COUNTRY');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'EDI_IF_SEQ',                   'A.EDI_IF_SEQ');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUSTOMER_PLANT',               'A.CUSTOMER_PLANT');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'EXCEPTION_FLAG',               'A.EXCEPTION_FLAG');
    INSERT INTO SCM_MGR.GT_DM53_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'EXCEPTION_DATE',               'A.EXCEPTION_DATE');

    -- V_SQL_SELECT, V_SQL_GROUPBY 동적 생성
    V_SQL_SELECT  := ' ';
    V_SQL_GROUPBY := ' ';
    V_I           := 1;

    SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.GT_DM53_COLUMN_SETUP;

    FOR REC IN (
        SELECT B.COLUMN_STRING, ROW_NUMBER() OVER (ORDER BY B.SORT_KEY) AS SEQ
        FROM  (
                   SELECT TRIM(REGEXP_SUBSTR(V_COLLIST, '[^\,]+', 1, LEVEL)) AS TOKEN
                        , LEVEL AS LVL
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(V_COLLIST, '[^\,]+', 1, LEVEL) IS NOT NULL
              ) A
        JOIN   SCM_MGR.GT_DM53_COLUMN_SETUP B
            ON  REPLACE(REPLACE(REPLACE(A.TOKEN, '[', ''), ']', ''),' ','') = B.COLUMN_NAME
        ORDER BY SEQ
    ) LOOP
        V_SQL_SELECT  := V_SQL_SELECT  || CASE WHEN V_I = 1 THEN ' ' ELSE ',' END || REC.COLUMN_STRING || CHR(10) ;
        V_SQL_GROUPBY := V_SQL_GROUPBY || CASE WHEN V_I = 1 THEN ' ' ELSE ',' END
                      || CASE WHEN INSTR(REC.COLUMN_STRING, ' AS ') > 0
                               THEN SUBSTR(REC.COLUMN_STRING, 1, INSTR(REC.COLUMN_STRING, ' AS ') - 1)
                               ELSE REC.COLUMN_STRING
                          END || CHR(10) ;
        V_I := V_I + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('F_2--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' : '||TO_CHAR(SQL%ROWCOUNT));

    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: 템프 사용 변경 */
    -- SELECT_MEASURE 인라인 WITH 절로 참조 (동적 SQL 내부)
    V_SQL_TEXT :=
        'WITH SELECT_MEASURE AS ('
        || CHR(10) || '    SELECT DISTINCT SMSM.COLUMN_NAME AS MEASURE_GROUP, U.COLUMN_NAME AS MEASURE, SMSM.SORT_ORDER_NO'
        || CHR(10) || '    FROM SCM_MST_TITLESET_USER U'
        || CHR(10) || '    JOIN SCM_MST_SHEET_MEASURE SMSM'
        || CHR(10) || '        ON U.PROGRAM_ID = SMSM.PROGRAM_ID AND U.SHEET_NAME = SMSM.SHEET_NAME'
        || CHR(10) || '        AND U.COLUMN_NAME = SMSM.COLUMN_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE = ''M'' AND SMSM.VALID_YN = ''Y'''
        || CHR(10) || '    LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T'
        || CHR(10) || '        ON U.USER_ID = T.SEGMENT4 AND ''' || P_CREATED_BY || ''' = T.SEGMENT4'
        || CHR(10) || '        AND T.LOOKUP_TYPE = ''TMM_MEASURE_ADMIN'' AND T.VALID_YN = ''Y'''
        || CHR(10) || '    WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = ''M'' AND U.PROGRAM_ID = ''DMF0053'''
        || CHR(10) || '    AND U.SHEET_NAME = ''custFcstWaterfall'' AND U.USER_ID = ''' || P_CREATED_BY || ''''
        || CHR(10) || '    AND U.USER_ID = CASE WHEN U.COLUMN_NAME = ''TMM_FCST'' THEN T.SEGMENT4 ELSE ''' || P_CREATED_BY || ''' END'
        || CHR(10) || '    UNION ALL'
        || CHR(10) || '    SELECT A2.MEASURE_GROUP, B2.MEASURE, A2.SORT_ORDER_NO + B2.SORT_ORDER_NO'
        || CHR(10) || '    FROM (SELECT ''CUST_FCST_EDI'' AS MEASURE_GROUP, SMSM.SORT_ORDER_NO'
        || CHR(10) || '          FROM SCM_MST_TITLESET_USER U JOIN SCM_MST_SHEET_MEASURE SMSM'
        || CHR(10) || '              ON U.PROGRAM_ID=SMSM.PROGRAM_ID AND U.SHEET_NAME=SMSM.SHEET_NAME'
        || CHR(10) || '              AND U.COLUMN_NAME=SMSM.COLUMN_NAME AND U.USER_INQUIRY_COLUMN_TYPE_CODE=''M'' AND SMSM.VALID_YN=''Y'''
        || CHR(10) || '          WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE=''M'' AND U.PROGRAM_ID=''DMF0053'''
        || CHR(10) || '          AND U.SHEET_NAME=''custFcstWaterfall'' AND U.USER_ID=''' || P_CREATED_BY || ''''
        || CHR(10) || '          AND U.COLUMN_NAME=''CUST_FCST_EDI'') A2,'
        || CHR(10) || '         (SELECT ''Immidiate'' MEASURE,0.14 AS SORT_ORDER_NO FROM DUAL'
        || CHR(10) || '          UNION ALL SELECT ''Planning_Forecast'',0.17 FROM DUAL'
        || CHR(10) || '          UNION ALL SELECT ''Commercial_Agreement'',0.12 FROM DUAL'
        || CHR(10) || '          UNION ALL SELECT ''Firm_Temp'',0.13 FROM DUAL'
        || CHR(10) || '          UNION ALL SELECT ''Manumacturing_Material_Temp'',0.15 FROM DUAL'
        || CHR(10) || '          UNION ALL SELECT ''Material_Temp'',0.16 FROM DUAL'
        || CHR(10) || '          UNION ALL SELECT ''Backorder'',0.11 FROM DUAL) B2'
        || CHR(10) || '    GROUP BY A2.MEASURE_GROUP, B2.MEASURE, A2.SORT_ORDER_NO + B2.SORT_ORDER_NO'
        || CHR(10) || '    UNION ALL'
        || CHR(10) || '    SELECT DISTINCT ''CUST_FCST'', C2.MEASURE,'
        || CHR(10) || '           (SELECT SMSM2.SORT_ORDER_NO FROM SCM_MST_TITLESET_USER U2 JOIN SCM_MST_SHEET_MEASURE SMSM2'
        || CHR(10) || '            ON U2.PROGRAM_ID=SMSM2.PROGRAM_ID AND U2.SHEET_NAME=SMSM2.SHEET_NAME'
        || CHR(10) || '            AND U2.COLUMN_NAME=SMSM2.COLUMN_NAME AND U2.USER_INQUIRY_COLUMN_TYPE_CODE=''M'' AND SMSM2.VALID_YN=''Y'''
        || CHR(10) || '            WHERE U2.USER_INQUIRY_COLUMN_TYPE_CODE=''M'' AND U2.PROGRAM_ID=''DMF0053'''
        || CHR(10) || '            AND U2.SHEET_NAME=''custFcstWaterfall'' AND U2.USER_ID=''' || P_CREATED_BY || ''''
        || CHR(10) || '            AND U2.COLUMN_NAME=''CUST_FCST'') + 0.1'
        || CHR(10) || '    FROM DM_MST_CUSTOMER_FCST C2'
        || CHR(10) || '    WHERE C2.MEASURE_GROUP=''CUST_FCST'' AND C2.MEASURE!='' '' AND C2.VALID_YN=''Y'''
        || CHR(10) || '    AND EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER X'
        || CHR(10) || '                WHERE X.USER_INQUIRY_COLUMN_TYPE_CODE=''M'' AND X.PROGRAM_ID=''DMF0053'''
        || CHR(10) || '                AND X.SHEET_NAME=''custFcstWaterfall'' AND X.USER_ID=''' || P_CREATED_BY || ''''
        || CHR(10) || '                AND X.COLUMN_NAME=''CUST_FCST'' AND X.COLUMN_NAME=C2.MEASURE_GROUP)'
        || CHR(10) || ')'
        || CHR(10) || ',WF_DATA AS ('
        || CHR(10) || ' SELECT CAST(CASE WHEN ''Y'' = '''''  -- [@CellQtyYN] placeholder (파라미터 미존재로 N 고정)
        || CHR(10) || '                  AND A.MEASURE_GROUP NOT IN (''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'')'
        || CHR(10) || '                  AND NVL(TO_NUMBER(D.FORECAST_INFO_CELL_PACK_COUNT), 1) <> 1'
        || CHR(10) || '             THEN A.QTY * TO_NUMBER(D.FORECAST_INFO_CELL_PACK_COUNT)'
        || CHR(10) || '             ELSE A.QTY END AS NUMBER(30,10)) AS QTY'
        || CHR(10) || '      , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD'
        || CHR(10) || '      , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW'
        || CHR(10) || '      , M.SORT_ORDER_NO'
        || CHR(10) || '      , CASE WHEN C2X.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE '''' END AS MONTH_END_YN'
        || CHR(10) || '      , CASE WHEN C3X.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE '''' END AS WEEK_END_YN'
        || CHR(10) || '      , EDY.EDIT_YN'
        || CHR(10) || '      ,' || V_SQL_SELECT
        || CHR(10) || ' FROM SCM_MGR.GT_DM53_RAW_DATA A'
        || CHR(10) || '      INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY'
        || CHR(10) || '           ON EDY.USER_ID = ''' || P_USER_ID || ''''
        || CHR(10) || '          AND EDY.MNU_ID  = ''' || P_MENU_ID || ''''
        || CHR(10) || '          AND EDY.UNIT_ID = A.DIVISION_ID'
        || CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM53_SCM_MST_SITE    B   ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID'
        || CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM53_SITE_ITEM        C   ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID'
        || CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM53_ITEM_SINGLE_VT   D   ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID'
        || CHR(10) || ' LEFT OUTER JOIN SCM_MST_PROJECT                   G   ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE'
        || CHR(10) || ' JOIN SELECT_MEASURE                               M   ON A.MEASURE = M.MEASURE'
        || CHR(10) || ' --[PJ2024-50461] Team Mapping------------------------------------'
        || CHR(10) || ' --LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N ON CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END = N.DEPT_ID'
        || CHR(10) || ' LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO              N   ON C.DEPT_ID = N.DEPT_ID'
        || CHR(10) || ' --[PJ2024-50461] Team Mapping------------------------------------'
        || CHR(10) || ' LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO              O   ON N.UPPER_DEPT_ID = O.DEPT_ID'
        || CHR(10) || ' JOIN SCM_MGR.GT_DM53_CALENDAR                     CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD'
        || CHR(10) || ' LEFT OUTER JOIN (SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE'
        || CHR(10) || '                  FROM SCM_SYS_CALENDAR_M'
        || CHR(10) || '                  WHERE BASIS_YYYYMMDD BETWEEN ''' || P_FROM_YYYYMMDD || ''' AND ''' || P_TO_YYYYMMDD || ''''
        || CHR(10) || '                  GROUP BY BASIS_YYYYMM) C2X ON A.YYYYMMDD = C2X.MONTH_END_DATE'
        || CHR(10) || ' LEFT OUTER JOIN (SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE'
        || CHR(10) || '                  FROM SCM_SYS_CALENDAR_M'
        || CHR(10) || '                  WHERE BASIS_YYYYMMDD BETWEEN ''' || P_FROM_YYYYMMDD || ''' AND ''' || P_TO_YYYYMMDD || ''''
        || CHR(10) || '                  GROUP BY ISO_YYYYWW||PARTIAL_WEEK_NAME) C3X ON A.YYYYMMDD = C3X.WEEK_END_DATE'
        || CHR(10) || ')' || CHR(10);

    DBMS_OUTPUT.PUT_LINE('F_3--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

    -- PIVOT 외부 쿼리 구성
    DECLARE
        V_OUTER_SQL VARCHAR(32000);
    BEGIN
        IF P_DIVISION_ID = '40' THEN
            V_OUTER_SQL := 'SELECT ' || V_COLLIST || ', ' || V_PV_COL || ' ,EDIT_YN FROM (';
        ELSE
            V_OUTER_SQL := 'SELECT ' || V_COLLIST || ', ' || V_PV_LIST || ',EDIT_YN FROM (';
        END IF;

        IF P_BUCKET = 'DAILY' THEN
            V_OUTER_SQL := V_OUTER_SQL
                || CHR(10) || 'SELECT ' || V_COLLIST || ', ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY, F.EDIT_YN'
                || CHR(10) || ' FROM WF_DATA F'
                || CHR(10) || ' WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',''Material_Temp'',''Backorder'') THEN -9999999999 ELSE 0 END)'
                || CHR(10) || ' UNION ALL ';
        END IF;

        IF P_BUCKET != 'ONLY_WEEKLY' THEN
            V_OUTER_SQL := V_OUTER_SQL
                || CHR(10) || 'SELECT ' || V_COLLIST || ', ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD'
                || CHR(10) || '     , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'',''SS_LVL'',''SS_GAP'') THEN'
                || CHR(10) || '              CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END'
                || CHR(10) || '            WHEN F.MEASURE = ''LOC'' THEN AVG(F.QTY)'
                || CHR(10) || '            ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || '     , F.EDIT_YN'
                || CHR(10) || ' FROM WF_DATA F'
                || CHR(10) || ' WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',''Material_Temp'',''Backorder'') THEN -9999999999 ELSE 0 END)'
                || CHR(10) || ' GROUP BY ' || V_COLLIST || ', F.BASIS_YYYYMM, F.ISO_WEEK, F.WEEK_END_YN'
                || CHR(10) || '     , F.EDIT_YN'
                || CHR(10) || ' UNION ALL'
                || CHR(10) || ' SELECT ' || V_COLLIST || ', ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD'
                || CHR(10) || '      , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'',''SS_LVL'',''SS_GAP'') THEN'
                || CHR(10) || '               CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END'
                || CHR(10) || '             WHEN F.MEASURE = ''LOC'' THEN AVG(F.QTY)'
                || CHR(10) || '             ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || '     , F.EDIT_YN'
                || CHR(10) || ' FROM WF_DATA F'
                || CHR(10) || ' WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',''Material_Temp'',''Backorder'') THEN -9999999999 ELSE 0 END)'
                || CHR(10) || ' GROUP BY ' || V_COLLIST || ', F.BASIS_YYYYMM, F.MONTH_END_YN'
                || CHR(10) || '     , F.EDIT_YN'
                || CHR(10) || ') F'
                || CHR(10) || ' PIVOT (SUM(QTY) FOR YYYYMMDD IN (' || V_PV_COL_LIST || '))'
                || CHR(10) || ' PVT'
                || CHR(10) || ' ORDER BY ' || V_ORDERLIST;
        ELSIF P_BUCKET = 'ONLY_WEEKLY' THEN
            V_OUTER_SQL := V_OUTER_SQL
                || CHR(10) || 'SELECT ' || V_COLLIST || ', ''W_'' || F.BASIS_YYYYMMWW AS YYYYMMDD'
                || CHR(10) || '     , CASE WHEN F.MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'',''SS_LVL'',''SS_GAP'') THEN'
                || CHR(10) || '              CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END'
                || CHR(10) || '            WHEN F.MEASURE = ''LOC'' THEN AVG(F.QTY)'
                || CHR(10) || '            ELSE SUM(F.QTY) END AS QTY'
                || CHR(10) || '     , F.EDIT_YN'
                || CHR(10) || ' FROM WF_DATA F'
                || CHR(10) || ' WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast'',''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp'',''Material_Temp'',''Backorder'') THEN -9999999999 ELSE 0 END)'
                || CHR(10) || ' GROUP BY ' || V_COLLIST || ', F.BASIS_YYYYMMWW, F.ISO_WEEK, F.WEEK_END_YN'
                || CHR(10) || '     , F.EDIT_YN'
                || CHR(10) || ') F'
                || CHR(10) || ' PIVOT (SUM(QTY) FOR YYYYMMDD IN (' || V_PV_COL_LIST || '))'
                || CHR(10) || ' PVT'
                || CHR(10) || ' ORDER BY ' || V_ORDERLIST;
        END IF;

        -- WF_DATA WITH 절 포함 최종 SQL 조합
        V_SQL_TEXT := V_SQL_TEXT || V_OUTER_SQL;
    END;

    -- Oracle은 PIVOT 문법을 직접 지원하므로 동적 SQL 실행 (결과 커서 반환)
    DBMS_OUTPUT.PUT_LINE('G--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

    DBMS_OUTPUT.ENABLE(1000000);

    DBMS_OUTPUT.PUT_LINE('=============================');
    DBMS_OUTPUT.PUT_LINE('V_PV_LIST : '||V_PV_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_PV_COL_LIST : '||V_PV_COL_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_PV_COL : '||V_PV_COL ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_COLLIST : '||V_COLLIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_ORDERLIST :'||V_ORDERLIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_SELECT :'||V_SQL_SELECT ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_GROUPBY :'||V_SQL_GROUPBY ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('=============================');


    DBMS_OUTPUT.PUT_LINE(v_sql_text);

    OPEN O_RC1 FOR V_SQL_TEXT;

    -- RC2: 현재 날짜의 ISO_WEEK, BASIS_DATE 반환
    OPEN O_RC2 FOR
        SELECT ISO_WEEK, BASIS_DATE
        FROM   SCM_SYS_CALENDAR_M
        WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    -- 20190711 정열 관련 추가
    DECLARE
        V_ORDER VARCHAR2(4000 CHAR) := '';
    BEGIN
        SELECT LISTAGG(COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE, ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
        INTO   V_ORDER
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
        WHERE  1 = 1
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    U.PROGRAM_ID                    = 'DMF0053'
        AND    U.SHEET_NAME                    = 'custFcstWaterfall'
        AND    U.USER_ID                       = P_CREATED_BY;

        /* 20231212 kcw3408 EDI_IF_SEQ DESC 삭제(컬럼선택시 하지 않으면 오류 발생) */
        OPEN O_RC3 FOR
            SELECT V_ORDER || 'CREATE_DATE DESC,' || 'SORT_ORDER_NO' AS DATA_ORDER
            FROM   DUAL;
    END;

    DBMS_OUTPUT.PUT_LINE('H--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

    COMMIT;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    DBMS_OUTPUT.PUT_LINE('I--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

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
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_DEPT_ID'         VALUE P_DEPT_ID,
            'P_END_CUSTOMER'    VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'     VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE'    VALUE P_PROJECT_CODE,
            'P_ITEM_ID'         VALUE P_ITEM_ID,
            'P_ITEM_TYPE'       VALUE P_ITEM_TYPE,
            'P_FROM_YYYYMMDD'   VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'     VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'      VALUE P_CREATED_BY,
            'P_PLANT_SITE_ID'   VALUE P_PLANT_SITE_ID,
            'P_BIZ_TYPE'        VALUE P_BIZ_TYPE,
            'P_OWNER'           VALUE P_OWNER,
            'P_BUCKET'          VALUE P_BUCKET,
            'P_USER_DEPT_ID'    VALUE P_USER_DEPT_ID,
            'P_GROUP_ID'        VALUE P_GROUP_ID,
            'P_VERSION_NO'      VALUE P_VERSION_NO,
            'P_FROM_CREATEDATE' VALUE P_FROM_CREATEDATE,
            'P_TO_CREATEDATE'   VALUE P_TO_CREATEDATE
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
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE
            || ' / SQLERRM=' || V_SQL_ERRMSG
            || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
            || ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0053_GET_CUST_FCST_WATERFALL;


END PKG_DMF0053;
/
