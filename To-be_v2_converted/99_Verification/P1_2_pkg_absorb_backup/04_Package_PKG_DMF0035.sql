/*=============================================================================================
 * File         : 04_Package_PKG_DMF0035.sql
 * Description  : Package — PKG_DMF0035
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
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0035 AS
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

PROCEDURE P_DMF0035_GET_MKT_FCST_WATERFALL
(
    P_DIVISION_ID      IN VARCHAR2
  , P_DEPT_ID          IN VARCHAR2
  , P_END_CUSTOMER     IN VARCHAR2
  , P_SCM_SITE_ID      IN VARCHAR2
  , P_PROJECT_CODE     IN VARCHAR2
  , P_ITEM_ID          IN VARCHAR2
  , P_ITEM_TYPE        IN VARCHAR2
  , P_FROM_YYYYMMDD    IN VARCHAR2
  , P_TO_YYYYMMDD      IN VARCHAR2
  , P_CREATED_BY       IN VARCHAR2
  , P_PLANT_SITE_ID    IN VARCHAR2
  , P_BIZ_TYPE         IN VARCHAR2
  , P_OWNER            IN VARCHAR2
  , P_VERSION_NO       IN VARCHAR2
  , P_BUCKET           IN VARCHAR2  -- 20211103 MKT FCST WATERFALL 속도 개선
  , P_USER_DEPT_ID     IN VARCHAR2  -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
  , P_GROUP_ID         IN VARCHAR2  -- JV Planner 일지 확인하기 위해 추가
  , P_CELL_YN          IN VARCHAR2
  , P_SENDER_CODE      IN VARCHAR2  -- SENDER_CODE 추가
  , P_USER_ID          IN VARCHAR2
  , P_MENU_ID          IN VARCHAR2
  
  , O_RC1              OUT SYS_REFCURSOR
  , O_RC2              OUT SYS_REFCURSOR
  , O_RC3              OUT SYS_REFCURSOR
  , O_RESULT_CURSOR    OUT SYS_REFCURSOR
);

END PKG_DMF0035;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0035 AS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0053                                                                        */
/* Description : PKG_DMF0053                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.26  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0035_GET_MKT_FCST_WATERFALL
(
    P_DIVISION_ID      IN VARCHAR2
  , P_DEPT_ID          IN VARCHAR2
  , P_END_CUSTOMER     IN VARCHAR2
  , P_SCM_SITE_ID      IN VARCHAR2
  , P_PROJECT_CODE     IN VARCHAR2
  , P_ITEM_ID          IN VARCHAR2
  , P_ITEM_TYPE        IN VARCHAR2
  , P_FROM_YYYYMMDD    IN VARCHAR2
  , P_TO_YYYYMMDD      IN VARCHAR2
  , P_CREATED_BY       IN VARCHAR2
  , P_PLANT_SITE_ID    IN VARCHAR2
  , P_BIZ_TYPE         IN VARCHAR2
  , P_OWNER            IN VARCHAR2
  , P_VERSION_NO       IN VARCHAR2
  , P_BUCKET           IN VARCHAR2  -- 20211103 MKT FCST WATERFALL 속도 개선
  , P_USER_DEPT_ID     IN VARCHAR2  -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
  , P_GROUP_ID         IN VARCHAR2  -- JV Planner 일지 확인하기 위해 추가
  , P_CELL_YN          IN VARCHAR2
  , P_SENDER_CODE      IN VARCHAR2  -- SENDER_CODE 추가
  , P_USER_ID          IN VARCHAR2
  , P_MENU_ID          IN VARCHAR2
  
  , O_RC1              OUT SYS_REFCURSOR
  , O_RC2              OUT SYS_REFCURSOR
  , O_RC3              OUT SYS_REFCURSOR
  , O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*=====================================================================================================================================================
 * Program ID   : DMF0035_GET_MKT_FCST_WATERFALL
 * Description  : MKT FCST Waterfall 조회
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 속도개선을 위해서 SALES PLAN을 참조해서 수정한 버전임
 * 2021.10.20 hwi1993   누락컬럼 추가 및 컬럼리스트 생성로직 변경
 * 2021.11.18 kdw2819   [과제]  자동차 사업부 JV Planner 의 조회 권한 추가
 * 2021.11.19 ROSIA27   [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
 * 2021.11.24 rosia27   [C20211118-000259] [SCM PI팀] GSCM 시스템 데이터를 마케팅(채권)자료로 활용하기 위한 기능 변경 건
 * 2021.12.03 rosia27   [C20211129-000286][SCM PI팀] GSCM 시스템 용량 정보를 마케팅(판가) 자료로 활용하기 위한 기능 변경건
 * 2021.12.07 rosia27   [C20211130-000420][ESS영업관리팀] RTF{R+P] Energy Measure MWh 단위로 수정 요청의 건
 * 2021.12.08 rosia27   [C20211129-000218][ SCM PI팀] GSCM 데이터를 마케팅(판가) 자료로 활용키 위한 기능 변경 건
 * 2021.12.15 kdw2819   [C20211215-000076] 1년 이상 조회기간을 설정하여도 가능하도록 변경 건
 * 2022.02.24 HWI1993     [C20220218-000409] GSCM-DM AS Inventory 메저 계산 로직 수정 -- INV 메저 표시방법 변경, INTRANSIT 메저의 ATTR10 오류 수정
 * 2022.04.25 HWI1993   GM JV 작업
 * 2022.06.23 kdw2819   [C20220620-000557] GSCM DM 영역내, Version에 주차표기
 * 2022.06.30 HWI1993   [C20220615-000093] [영업마케팅PI] MKT_FCST Waterfall 內 SaftyStock LevelGap measure 추가 요청 건
 * 2022.07.28 kdw2819   [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
 * 2022.12.14 rosia27   [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
 * 2023.01.25 rosia27   [C20230102-000937] MKT FCST Waterfall 조회 시 공란을 '0'으로 채울 수 있는 기능 구현 가능성 여부
 * 2023.02.02   heesan91  [E20230130-000233] [ESS영업관리팀] Waterfall 화면의 Version 값 주차(Week) 추가 요청의 건
 * 2023.03.16 rosia27   [E20230306-000253] MKT FCST Waterfall Cell Qty 표시 기능 구현 요청드립니다
 * 2023.05.03 kdmcc14   [EDI과제]
 * 2023.08.25   HMIN        [E20230802-000878] 자동차- MKT FCST Waterfall 화면에 AS From Site 칼럼 추가 건  
 * 2023.09.14   HMIN        [E20230906-000992] ESS 사업부 용량정보 표기 수정 - 1)Energy 관련 메저 누락 (21년도 기반영 CSR 에서 형식오류로 표출되지않았던 부분 수정)
 * 2023.10.25   HMIN        [E20231017-000634] [영업/마케팅 PI팀] MKT FCST Report 화면 칼럼추가 (SCP테이블정보) (요청자: 오윤종님)
 * 2023.12.07   kcw3408     [개발요청] 수요분석시스템_4_고객수요 Measure 통합 
 * 2023.12.19   JSSBAE      [E20231128-000738][마케팅PI] 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall
 * 2024.01.15   JSSBAE      [E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
 * 2024.01.15   JSSBAE      [E20240102-000545] [마케팅PI] 82번 사업부 - VMI표기 로직 개선
 * 2024.03.07   kcw3408     DM 프로시저 속도개선(CNS 전정관 책임님이 지원)
 * 2024.05.17   kcw3408   이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
 * 2024.06.24   kjj     이동계획 판가 매출 GROUP_ID 화면 표시
 * 2024.08.02   JSSBAE    [E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선
 * 2024.08.28 KJJ     [PJ2024-50461] Team Mapping
 * 2024.09.12 JSSBAE    [E20240920-000300]_SCM.DM 화면 조회 속도 개선
 * 2024.11.04 JSSBAE    [E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건 
 *                           SSPM에 신규 추가 요청드린 'Project(S&OP Report)' 컬럼 MKT FCST Waterfall 사용자 화면에 추가 요청
 * 2024.11.12 JSSBAE    [E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건
 * 2024.11.15 KANG.H.J  [PJ2024-50611] 소형 매출 프로세스 개선    
 * 2024.11.26 JSSBAE      [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 
 * 2025.03.18 dsiol   [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.03.27 jssbae    [E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
 * 2025.04.23 dsiol   [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가 - %SF% 추가
 * 2025.06.02   kjiyoon   [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
 * 2025.07.07 KANG.H.J  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.08.06   JSSBAE    [E20250805-000706]_MKT FCST Waterfall 계획구간 Cell Prod Site 구분
 * 2025.08.11   JSSBAE    [E20250807-001418]_MKT FCST Waterfall UI Measure 오류 수정
 * 2026.01.23 JSSBAE    [E20260123-001715]_E20241015-000415 CSR 원복 요청
 *===================================================================================================================================================*/
IS
    -- ===================== 로깅 변수 =====================
    $$PLSQL_UNIT   VARCHAR2(200 CHAR);
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100  CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100  CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER  := 0;
    D_EVENT_DATE     DATE         := SYSDATE;

    -- ===================== 프로그램 고정 변수 =====================
    V_P_PROGRAM_ID   VARCHAR2(50  CHAR) := 'DMF0035';
    V_P_SHEET_NAME   VARCHAR2(50  CHAR) := 'mktFcstWaterfall';

    -- ===================== 업무 변수 =====================
    V_NOW_YYYYMMDD   CHAR(8);
    --V_MEASURE        PLS_INTEGER := 0;
    V_I_COUNT        PLS_INTEGER := 0;
    V_EXISTS_CNT     PLS_INTEGER := 0;

    --=================================================================================================================
    -- 20200316 KHSONG C20200224-000109 (START)
    --=================================================================================================================
    V_USER_MEA_CNT   PLS_INTEGER := 0;
    --=================================================================================================================
    -- 20200316 KHSONG C20200224-000109 (END)
    --=================================================================================================================

    --=================================================================================================================
    -- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
    --=================================================================================================================
    V_START_YYYYMMDD VARCHAR2(8 CHAR);

    -- Dynamic SQL 변수
    V_SQL_TEXT       VARCHAR2(32767 CHAR);
    V_PV_LIST        VARCHAR2(32767 CHAR);
    V_PV_COL_LIST    VARCHAR2(32767 CHAR);
    V_PV_COL         VARCHAR2(32767 CHAR);
    --V_COLUMN_NAME    VARCHAR2(100  CHAR);
    --V_COLUMN         VARCHAR2(1000 CHAR);
    --V_ORDERBY        VARCHAR2(1000 CHAR);
    V_COLUMN_TEXT    VARCHAR2(4000  CHAR);
    --V_PV_COLUMN_NAME VARCHAR2(100  CHAR);
    --V_PV_NAME        VARCHAR2(50   CHAR);
    --V_COLUMN_TYPE    VARCHAR2(50   CHAR);
    V_COLUMN_VALUE   VARCHAR2(4000  CHAR);
    --V_SORT_ORDER_NO  VARCHAR2(50   CHAR);
    V_SQL_SELECT     VARCHAR2(32767 CHAR);
    V_SQL_GROUPBY    VARCHAR2(32767 CHAR);
    V_I              PLS_INTEGER;
    V_CNT            PLS_INTEGER;

    -- 컬럼 리스트 조합 변수
    --V_PROD           VARCHAR2(32767 CHAR);
    V_COL_LIST       VARCHAR2(32767 CHAR);
    V_ORDER_LIST     VARCHAR2(32767 CHAR);

    -- CURSOR (날짜 컬럼 생성용)
    CURSOR C_BUCKET IS
        SELECT
             '''D_' || A.BASIS_YYYYMMDD || '''  AS D_' || A.BASIS_YYYYMMDD  AS COLUMN_NAME
           , 'D_' || A.BASIS_YYYYMMDD || ' '                             AS PV_NAME
           , A.BASIS_YYYYMMDD || '_' || LPAD('31', 2, '0')               AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET = 'DAILY'
        UNION ALL
        SELECT '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || '''  AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ' '                                          AS PV_NAME
             , A.BASIS_START_DATE || '_' || LPAD('21', 2, '0')                                       AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET != 'ONLY_WEEKLY'
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM   AS COLUMN_NAME
             , 'M_' || A.BASIS_YYYYMM || ' '                             AS PV_NAME
             , MIN(A.BASIS_START_DATE) || '_' || LPAD('1', 2, '0')       AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET != 'ONLY_WEEKLY'
        GROUP BY A.BASIS_YYYYMM
        UNION ALL
        SELECT '''W_' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK || ''' AS W_' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK  AS COLUMN_NAME
             , 'W_' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK || ' '                                                               AS PV_NAME
             , MAX(A.BASIS_YYYYMMDD) || '_' || LPAD('21', 2, '0')                                                                               AS SORT_ORDER_NO
        FROM SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND    A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        AND    P_BUCKET = 'ONLY_WEEKLY'
        GROUP BY A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME
        ORDER BY SORT_ORDER_NO;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --=================================================================================================================
    -- GTT 초기화 (이전에 일반 테이블 DML 없음 → TRUNCATE 사용 가능)
    --=================================================================================================================
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_VERSION';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_RAW_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_RAW_DATA_FINAL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_SCP_ITEM_INFO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_T_LAST_SETUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_T_LAST_SETUP_C';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_SEL_MEASURE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_DM_PLN_MKT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_EDI_SENDER';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_EDI_END_CUST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_RPA_END_CUST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_ORI';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_A';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_B';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_ITEM_SINGLE_V';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_SITE_ITEM';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_TEMP_VMI_INV';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_VMI_INV_RESULT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_CALENDAR';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_CAL_MONTH_END';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_CAL_WEEK_END';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_TEMP_SCM_SITE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_T_COLUMN_SETUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_DM35_T';

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'A001--TRUNCATE GTT';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --=================================================================================================================
    -- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
    --=================================================================================================================
    SELECT BASIS_START_DATE
    INTO   V_START_YYYYMMDD
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_NOW_YYYYMMDD := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
    V_COL_LIST   := '';
    V_ORDER_LIST := '';
    --V_PROD       := '';

    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'A002--START DATE';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --=================================================================================================================
    -- #T_VERSION : 버전 정보 적재
    --=================================================================================================================
    IF P_VERSION_NO LIKE '%MF%' OR P_VERSION_NO LIKE '%ME%' OR P_VERSION_NO LIKE '%SF%' --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
    THEN
        INSERT INTO SCM_MGR.GT_DM35_VERSION (VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD)
        SELECT A.TOKEN
             , CASE WHEN D.DM_RTF_YN = ''
                    THEN A.TOKEN || '(' || C.WEEK_NAME || ') (NO PLAN)'
                    ELSE A.TOKEN || '(' || C.WEEK_NAME || ')'
               END
             , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(B.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
        FROM (
            SELECT TRIM(
                       CASE WHEN INSTR(TOKEN, '(') = 0 THEN TOKEN
                            ELSE SUBSTR(TOKEN, 1, INSTR(TOKEN, '(') - 1)
                       END
                   ) AS TOKEN
            FROM (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_VERSION_NO,',')) P)
        ) A
        JOIN SCM_MGR.DM_MST_VERSION B ON A.TOKEN = B.VERSION_NO AND B.DIVISION_ID = P_DIVISION_ID
        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C ON B.YYYYMMDD = C.BASIS_YYYYMMDD
        LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN D
               ON B.DIVISION_ID        = D.DIVISION_ID
              AND C.BASIS_START_DATE   = D.PLAN_START_YYYYMMDD;
    END IF;

    ------------------------------------------------------------------------------------------
    -- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
    ------------------------------------------------------------------------------------------
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'A003--VERSION';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
       과거 구간은 전체 Data가 포함되어야 함.
       단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
       단위 환산이 되어야 함.*/

    --=================================================================================================================
    -- 20200316 KHSONG C20200224-000109 (START)
    --=================================================================================================================
    SELECT COUNT(*)
    INTO   V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  U.PROGRAM_ID                  = V_P_PROGRAM_ID
    AND    U.SHEET_NAME                  = V_P_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID                     = P_CREATED_BY;

    IF V_USER_MEA_CNT = 0
    THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
        , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME
              , C.SORT_ORDER_NO, '', '', P_CREATED_BY, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
              , P_CREATED_BY, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  C.PROGRAM_ID    = V_P_PROGRAM_ID
        AND    C.SHEET_NAME    = V_P_SHEET_NAME
        AND    C.DEFAULT_FLAG  = 'Y'
        AND    C.VALID_YN      = 'Y';
    END IF;

    --=================================================================================================================
    -- [E20250807-001418]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 START
    -- SCM_FCST은 40 사업부만 사용하나, 하단에서 생성하는 경우에 사업부에서 진행하게 되면서, 모든 사업부에 메져가 노출됨.
    --=================================================================================================================
  -- 원소스 주석처리함
  /*
  -------------------------------------------------------------------------
  -- 20200316 KHSONG C20200224-000109 (END)
  -------------------------------------------------------------------------
  SELECT DISTINCT
    ISNULL(U.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
    ,U.SHEET_NAME
    ,U.USER_ID
    ,CASE  WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO'  )  THEN 'CUST. PSI' 
        WHEN U.COLUMN_NAME IN ( 'MKT_INV_I' ,'MKT_PRODUCT_S' ,'MKT_WHIN_P' ,'MKT_DIO'   )  THEN 'MKT PSI'  
        ELSE U.COLUMN_NAME 
      END AS MEASURE_GROUP
    ,U.COLUMN_NAME AS MEASURE
    , CASE WHEN U.COLUMN_NAME IN ( 'CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG' )  THEN SMSM.SORT_ORDER_NO  -- 20231212 kcw3408 4_고객수요 Measure 통합
        ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO  
    ,'' AS SYSTEM_ADD
  INTO #SELECT_MEASURE 
  FROM SCM_MST_TITLESET_USER U  WITH(NOLOCK)
      JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
        ON U.PROGRAM_ID = SMSM.PROGRAM_ID
      AND U.SHEET_NAME = SMSM.SHEET_NAME
      AND U.COLUMN_NAME = SMSM.COLUMN_NAME
      AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
      AND SMSM.VALID_YN     = 'Y' 
  LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK) ON (U.USER_ID = T.SEGMENT4)  -- 20200309 KHSONG TMM MEASURE 권한추가
        AND @p_created_by = T.SEGMENT4  -- USER_ID
        AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
        AND T.VALID_YN    = 'Y'       -- VALID_YN 여부
  WHERE 1 = 1
  AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
  AND U.PROGRAM_ID            = 'DMF0035'
  AND U.SHEET_NAME            = 'Mkt Fcst Waterfall'
  AND U.USER_ID           = @p_created_by
  and U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by END
  */

    -- USER TITLE 정보와 MEASURE MASTER 정보를 JOIN하여 사업부별 정보를 보관한다. 
    INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO, SYSTEM_ADD)
    SELECT DISTINCT NVL(U.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID, U.SHEET_NAME, U.USER_ID
         , CASE WHEN U.COLUMN_NAME IN ('CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO') THEN 'CUST. PSI'
                WHEN U.COLUMN_NAME IN ('MKT_INV_I','MKT_PRODUCT_S','MKT_WHIN_P','MKT_DIO')    THEN 'MKT PSI'
                ELSE U.COLUMN_NAME
           END AS MEASURE_GROUP
         , U.COLUMN_NAME AS MEASURE
         , CASE WHEN U.COLUMN_NAME IN ('CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG') THEN SMSM.SORT_ORDER_NO -- 20231212 kcw3408 4_고객수요 Measure 통합
                ELSE U.SORT_ORDER_NO
           END AS SORT_ORDER_NO
         , '' AS SYSTEM_ADD
    FROM (
        SELECT A.PROGRAM_ID, A.USER_ID, A.COLUMN_NAME, A.SORT_ORDER_NO, A.SYSTEM_ADD, A.USER_INQUIRY_COLUMN_TYPE_CODE, A.SHEET_NAME, TOKEN AS DIVISION_ID
        FROM (
            SELECT U.PROGRAM_ID, U.USER_ID, U.COLUMN_NAME, U.SORT_ORDER_NO, B.DIVISION_ID, U.USER_INQUIRY_COLUMN_TYPE_CODE, U.SHEET_NAME, '' AS SYSTEM_ADD
            FROM SCM_MGR.SCM_MST_TITLESET_USER U
            INNER JOIN SCM_MGR.SCM_MST_SHEET_MEASURE B
                    ON U.PROGRAM_ID   = B.PROGRAM_ID
                   AND U.SHEET_NAME   = B.SHEET_NAME
                   AND U.COLUMN_NAME  = B.COLUMN_NAME
            WHERE  U.PROGRAM_ID                    = V_P_PROGRAM_ID
            AND    U.SHEET_NAME                    = V_P_SHEET_NAME
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
            AND    U.USER_ID                       = P_CREATED_BY
            AND    B.VALID_YN                      = 'Y'
        ) A
        CROSS JOIN (
            SELECT TRIM(REGEXP_SUBSTR(A.DIVISION_ID, '[^,]+', 1, LEVEL)) AS TOKEN
            FROM (SELECT DIVISION_ID FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID = V_P_PROGRAM_ID AND SHEET_NAME = V_P_SHEET_NAME AND ROWNUM = 1) A
            CONNECT BY REGEXP_SUBSTR(A.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
        )
    ) U
    JOIN SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
      ON  U.PROGRAM_ID   = SMSM.PROGRAM_ID
     AND  U.SHEET_NAME   = SMSM.SHEET_NAME
     AND  U.COLUMN_NAME  = SMSM.COLUMN_NAME
     AND  U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
     AND  SMSM.VALID_YN  = 'Y'
    LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
           ON (U.USER_ID   = T.SEGMENT4)  -- 20200309 KHSONG TMM MEASURE 권한추가
          AND P_CREATED_BY = T.SEGMENT4   -- USER_ID
          AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
          AND T.VALID_YN    = 'Y'         -- VALID_YN 여부
    WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND   U.PROGRAM_ID                    = V_P_PROGRAM_ID
    AND   U.SHEET_NAME                    = V_P_SHEET_NAME
    AND   U.USER_ID                       = P_CREATED_BY
    AND   U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE P_CREATED_BY END
    AND   U.DIVISION_ID = P_DIVISION_ID;
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [E20250807-001418]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 END
    -----------------------------------------------------------------------------------------------------------------------------------

    INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO, SYSTEM_ADD)
    SELECT NVL(A.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
         , A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE, A.SORT_ORDER_NO + B.SORT_ORDER_NO
         , '' AS SYSTEM_ADD
    FROM (
        SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID
             --[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START
             --, 'CUST_FCST_EDI' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
             , 'CUST_FCST' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
             --[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END
             , SMSM.SORT_ORDER_NO            -- 20231212 kcw3408 4_고객수요 Measure 통합
        FROM SCM_MGR.SCM_MST_TITLESET_USER U
             JOIN SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
               ON U.PROGRAM_ID = SMSM.PROGRAM_ID
              AND U.SHEET_NAME = SMSM.SHEET_NAME
              AND U.COLUMN_NAME = SMSM.COLUMN_NAME
              AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
              AND SMSM.VALID_YN = 'Y'
        WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND   U.PROGRAM_ID   = 'DMF0035'
        AND   U.SHEET_NAME   = 'mktFcstWaterfall'
        AND   U.USER_ID      = P_CREATED_BY
        --[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START
        --AND   U.COLUMN_NAME  = 'CUST_FCST_EDI'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
        AND   U.COLUMN_NAME  = 'CUST_FCST'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
        --[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END
    ) A
    CROSS JOIN (
        --[E20241126-000426]_CUST_FCST_EDI 추가 및 순서 변경 START
        --SELECT 'Immidiate' MEASURE, 0.14 AS SORT_ORDER_NO
        SELECT 'Immidiate'                   MEASURE, 0.15 AS SORT_ORDER_NO FROM DUAL UNION ALL
        --SELECT 'Planning_Forecast' MEASURE, 0.17 AS SORT_ORDER_NO
        SELECT 'Planning_Forecast'           MEASURE, 0.18 AS SORT_ORDER_NO FROM DUAL UNION ALL
        --SELECT 'Commercial_Agreement' MEASURE, 0.12 AS SORT_ORDER_NO
        SELECT 'Commercial_Agreement'        MEASURE, 0.13 AS SORT_ORDER_NO FROM DUAL UNION ALL
        --SELECT 'Firm_Temp' MEASURE, 0.13 AS SORT_ORDER_NO
        SELECT 'Firm_Temp'                   MEASURE, 0.14 AS SORT_ORDER_NO FROM DUAL UNION ALL
        --SELECT 'Manumacturing_Material_Temp' MEASURE, 0.15 AS SORT_ORDER_NO
        SELECT 'Manumacturing_Material_Temp' MEASURE, 0.16 AS SORT_ORDER_NO FROM DUAL UNION ALL
        --SELECT 'Material_Temp' MEASURE, 0.16 AS SORT_ORDER_NO
        SELECT 'Material_Temp'               MEASURE, 0.17 AS SORT_ORDER_NO FROM DUAL UNION ALL
        --SELECT 'Backorder' MEASURE, 0.11 AS SORT_ORDER_NO
        SELECT 'Backorder'                   MEASURE, 0.12 AS SORT_ORDER_NO FROM DUAL UNION ALL
        SELECT 'CUST_FCST_EDI'               MEASURE, 0.11 AS SORT_ORDER_NO FROM DUAL  --[E20241126-000426]_신규 추가
        --[E20241126-000426]_CUST_FCST_EDI 추가 및 순서 변경 END
    ) B
    WHERE 1=1
    GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE, A.SORT_ORDER_NO + B.SORT_ORDER_NO;

    --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
    /*
    INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE ... (CUST_FCST_EDI_ORG 관련 - 주석처리됨)
    */
    --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END

    INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO, SYSTEM_ADD)
    SELECT DISTINCT
        'DMF0035'             AS PROGRAM_ID
      , 'mktFcstWaterfall'  AS SHEET_NAME
      , P_CREATED_BY          AS USER_ID
      , 'CUST_FCST'           AS MEASURE_GROUP
      , C.MEASURE             AS MEASURE
      , (SELECT SMSM.SORT_ORDER_NO       -- 20231212 kcw3408 4_고객수요 Measure 통합
           FROM SCM_MGR.SCM_MST_TITLESET_USER U
                JOIN SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                  ON U.PROGRAM_ID = SMSM.PROGRAM_ID
                 AND U.SHEET_NAME = SMSM.SHEET_NAME
                 AND U.COLUMN_NAME = SMSM.COLUMN_NAME
                 AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND SMSM.VALID_YN = 'Y'
          WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
          AND   U.PROGRAM_ID  = 'DMF0035'
          AND   U.SHEET_NAME  = 'mktFcstWaterfall'
          AND   U.USER_ID     = P_CREATED_BY
          AND   U.COLUMN_NAME = 'CUST_FCST') + 0.1 AS SORT_ORDER_NO
      , '' AS SYSTEM_ADD
    FROM SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE C.MEASURE_GROUP = 'CUST_FCST'
    AND   C.MEASURE       IS NOT NULL
    AND   C.VALID_YN      = 'Y'
    AND   EXISTS (SELECT 1
                  FROM SCM_MGR.SCM_MST_TITLESET_USER X
                  WHERE X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                  AND   X.PROGRAM_ID  = 'DMF0035'
                  AND   X.SHEET_NAME  = 'mktFcstWaterfall'
                  AND   X.USER_ID     = P_CREATED_BY
                  AND   X.COLUMN_NAME = 'CUST_FCST'
                  AND   X.COLUMN_NAME = C.MEASURE_GROUP);

    INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE
        (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO, SYSTEM_ADD)
    SELECT DISTINCT
        'DMF0035'             AS PROGRAM_ID
      , 'mktFcstWaterfall'  AS SHEET_NAME
      , P_CREATED_BY          AS USER_ID
      , 'CUST_FCST_ORG'       AS MEASURE_GROUP
      , 'Customer Fcst[Org.]' AS MEASURE
      , (SELECT SMSM.SORT_ORDER_NO         -- 20231212 kcw3408 4_고객수요 Measure 통합
           FROM SCM_MGR.SCM_MST_TITLESET_USER U
                JOIN SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
                  ON U.PROGRAM_ID = SMSM.PROGRAM_ID
                 AND U.SHEET_NAME = SMSM.SHEET_NAME
                 AND U.COLUMN_NAME = SMSM.COLUMN_NAME
                 AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                 AND SMSM.VALID_YN = 'Y'
          WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
          AND   U.PROGRAM_ID  = 'DMF0035'
          AND   U.SHEET_NAME  = 'mktFcstWaterfall'
          AND   U.USER_ID     = P_CREATED_BY
          AND   U.COLUMN_NAME = 'CUST_FCST') + 0.1 AS SORT_ORDER_NO
      , '' AS SYSTEM_ADD
    FROM SCM_MGR.DM_MST_CUSTOMER_FCST C
    WHERE C.MEASURE_GROUP = 'CUST_FCST'
    AND   C.MEASURE       IS NOT NULL
    AND   C.VALID_YN      = 'Y'
    AND   EXISTS (SELECT 1
                  FROM SCM_MGR.SCM_MST_TITLESET_USER X
                  WHERE X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                  AND   X.PROGRAM_ID  = 'DMF0035'
                  AND   X.SHEET_NAME  = 'mktFcstWaterfall'
                  AND   X.USER_ID     = P_CREATED_BY
                  AND   X.COLUMN_NAME = 'CUST_FCST_ORG');

    --select * from GT_DM35_SEL_MEASURE;

    ------------------------------------------------------------------------------------------------------------------
    -- 변환 또는 환산이 필요할 경우 해당 본 메저도 추가해준다.
    ------------------------------------------------------------------------------------------------------------------
    V_EXISTS_CNT := 0;

    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE WHERE MEASURE LIKE 'MKT_FCST_RP%';

    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD)
        SELECT 'DMF0035', 'mktFcstWaterfall', P_CREATED_BY, A.MEASURE_GROUP, A.MEASURE, 'Y'
        FROM (
            SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE FROM DUAL
            UNION ALL
            SELECT 'MKT_FCST' AS MEASURE_GROUP, 'MKT_FCST' AS MEASURE FROM DUAL
        ) A
        LEFT OUTER JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        WHERE B.MEASURE IS NULL;
    END IF;

    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE WHERE MEASURE LIKE 'RTF_SYS_RP%';
    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD)
        SELECT 'DMF0035', 'mktFcstWaterfall', P_CREATED_BY, A.MEASURE_GROUP, A.MEASURE, 'Y'
        FROM (
            SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE FROM DUAL
        ) A
        LEFT OUTER JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        WHERE B.MEASURE IS NULL;
    END IF;

    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE WHERE MEASURE = 'LOC';
    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD)
        SELECT 'DMF0035', 'mktFcstWaterfall', P_CREATED_BY, A.MEASURE_GROUP, A.MEASURE, 'Y'
        FROM (
            SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE FROM DUAL
            UNION ALL
            SELECT 'SALESAMT' AS MEASURE_GROUP, 'SalesAmt_LOC' AS MEASURE FROM DUAL
        ) A
        LEFT OUTER JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        WHERE B.MEASURE IS NULL;
    END IF;

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
    -- SCM_FCST 메저의 실적구간은 RTF_SYS_RP 를 가져와 보여주도록 한다.
    -----------------------------------------------------------------------------------------------------------------------------------
    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE WHERE MEASURE IN ('SCM_FCST');
    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_SEL_MEASURE (PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD)
        SELECT 'DMF0035', 'mktFcstWaterfall', P_CREATED_BY, A.MEASURE_GROUP, A.MEASURE, 'Y'
        FROM (
            SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE FROM DUAL
        ) A
        LEFT OUTER JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        WHERE B.MEASURE IS NULL;
    END IF;


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'D--SELECT MEASURE';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --#T_EDI_SENDER 
    INSERT INTO SCM_MGR.GT_DM35_EDI_SENDER (SCM_SITE_ID, SENDER_CODE, SENDER_NAME)
    SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
    FROM SCM_MGR.SCM_MST_SITE A
    JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
      ON A.END_CUSTOMER = B.SEGMENT2
     AND A.DIVISION_ID  = B.SEGMENT1
     AND B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
    GROUP BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6;


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'D1--GT_DM35_EDI_SENDER';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --------------------------------------------------
    -- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')
    --------------------------------------------------
    IF P_VERSION_NO LIKE '%CURRENT%'
    THEN
        --GT_DM35_T_LAST_SETUP
        INSERT INTO SCM_MGR.GT_DM35_T_LAST_SETUP
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
        FROM (
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 --[E20241126-000426]_CUST_FCST Measure 추가 START
                 --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                 , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                    --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
                    /*, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'*/
                    --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
                    ) THEN
                    (CASE WHEN NVL(MAX(A.ATTRIBUTE9), '@#@#@#') = '@#@#@#' THEN
                               MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
                          ELSE MAX(A.ATTRIBUTE9) END)
                 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
                 , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM (
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     , F.ATTRIBUTE9, F.LAST_UPDATE_DATE, F.LAST_UPDATED_BY
                FROM SCM_MGR.DM_PLN_MKT_FCST F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
                UNION ALL
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     , F.ATTRIBUTE9, F.LAST_UPDATE_DATE, F.LAST_UPDATED_BY
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
            ) A
            JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
              ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
                                   WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
                                   WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                   WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                   ELSE B.MEASURE END)
            WHERE A.DIVISION_ID = P_DIVISION_ID
            AND   A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD'), -12), 'YYYYMMDD')
            AND   A.YYYYMMDD   <= P_TO_YYYYMMDD
            AND   A.QTY        <> 0
            GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
            UNION ALL
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 --[E20241126-000426]_CUST_FCST Measure 추가 START
                 , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                    --[E20241126-000426]_CUST_FCST Measure 추가 END
                          , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN
                    (CASE WHEN NVL(MAX(A.ATTRIBUTE9), '@#@#@#') = '@#@#@#' THEN
                               MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
                          ELSE MAX(A.ATTRIBUTE9) END)
                 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
                 , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT A
            JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
              ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
                                   WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
                                   WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
                                   WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                   ELSE B.MEASURE END)
            WHERE A.DIVISION_ID = P_DIVISION_ID
            AND   A.YYYYMMDD   >= TO_CHAR(ADD_MONTHS(TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD'), -12), 'YYYYMMDD')
            AND   A.YYYYMMDD   <= P_TO_YYYYMMDD
            AND   A.QTY        <> 0
            GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        ) X
        WHERE NVL(X.PROJECT_CODE, '@#@#@#') <> '@#@#@#'
        AND   NVL(X.SCM_SITE_ID,  '@#@#@#') <> '@#@#@#'
        AND   NVL(X.ITEM_ID,      '@#@#@#') <> '@#@#@#'
        GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D2--GT_DM35_T_LAST_SETUP';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        -- EDI LOOKUP 기간

        --GT_DM35_EDI_END_CUST
        --EDI END_CUSTOMER별 기간 설정
        INSERT INTO SCM_MGR.GT_DM35_EDI_END_CUST (DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE)
        SELECT A.DIVISION_ID AS DIVISION_ID
             , A.END_CUSTOMER AS END_CUSTOMER
             , NVL(B.SEGMENT4, '-') AS SCM_SITE_ID
             , (CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN
                     NVL(B.ATTRIBUTE1, '-1')
                ELSE '-52' END) AS FROM_WEEK
             , NVL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
             , NVL(B.ATTRIBUTE3, '0') AS TO_WEEK
             , NVL(B.ATTRIBUTE4, 'MON') AS TO_DAY
             , NVL(B.SEGMENT5, 'On') AS ACTIVE
        FROM SCM_MGR.SCM_MST_SITE A
        LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
         AND A.DIVISION_ID  = B.SEGMENT1
         AND A.END_CUSTOMER = B.SEGMENT2
         AND B.VALID_YN     = 'Y'
        WHERE NVL(A.END_CUSTOMER, '@#@#@#') <> '@#@#@#'
        GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D3--GT_DM35_EDI_END_CUST';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
        /*
        -- EDI[Org.] LOOKUP 기간 - 주석처리됨
        */
        --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END

        -- RPA LOOKUP 기간
        --GT_DM35_RPA_END_CUST
        --RPA END_CUSTOMER별 기간 설정
        INSERT INTO SCM_MGR.GT_DM35_RPA_END_CUST (DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE)
        SELECT A.DIVISION_ID AS DIVISION_ID
             , A.END_CUSTOMER AS END_CUSTOMER
             , NVL(B.SEGMENT4, '-') AS SCM_SITE_ID
             , (CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN
                     NVL(B.ATTRIBUTE1, '-1')
                ELSE '-52' END) AS FROM_WEEK
             , NVL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
             , NVL(B.ATTRIBUTE3, '0') AS TO_WEEK
             , NVL(B.ATTRIBUTE4, 'MON') AS TO_DAY
             , NVL(B.SEGMENT5, 'On') AS ACTIVE
        FROM SCM_MGR.SCM_MST_SITE A
        LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON B.LOOKUP_TYPE  = 'RPA_END_CUSTOMER'
         AND A.DIVISION_ID  = B.SEGMENT1
         AND A.END_CUSTOMER = B.SEGMENT2
         AND B.VALID_YN     = 'Y'
        WHERE NVL(A.END_CUSTOMER, '@#@#@#') <> '@#@#@#'
        GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D4--GT_DM35_RPA_END_CUST';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
        /*
        -- RPA[Org.] LOOKUP 기간 - 주석처리됨
        */
        --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END

        -- [20240312] start

        -- GT_DM35_DM_PLN_MKT 생성 (미래구간 MKT_FCST 계획 적재)
        INSERT INTO SCM_MGR.GT_DM35_DM_PLN_MKT
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.YYYYMMDD, A.QTY, A.ATTRIBUTE10, A.CELL_PROD_SITE_ID
             , A.LAST_UPDATED_BY, A.ATTRIBUTE4, A.ATTRIBUTE5
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
        FROM (
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY, F.ATTRIBUTE4, F.ATTRIBUTE5
            FROM SCM_MGR.DM_PLN_MKT_FCST F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
            UNION ALL
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY, F.ATTRIBUTE4, F.ATTRIBUTE5
            FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
        ) A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
        WHERE A.YYYYMMDD    >= V_NOW_YYYYMMDD
        AND   A.YYYYMMDD    <= P_TO_YYYYMMDD
        AND   A.DIVISION_ID  = P_DIVISION_ID
        AND   A.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                                --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
                                /*
                                , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
                                , 'Material_Temp[Org.]', 'Backorder[Org.]'
                                */
                                --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
                                , 'CUST_FCST', 'Customer FCST')
        AND   A.QTY <> 0;

        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D5--GT_DM35_DM_PLN_MKT';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        -- GT_DM35_DM_PLN_MKT에 INDEX 역할 (GTT JOIN 통계 수집)
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_DM_PLN_MKT', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(
            ownname          => 'SCM_MGR'
          , tabname          => 'GT_DM35_DM_PLN_MKT'
          , estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE
          , method_opt       => 'FOR ALL COLUMNS SIZE 1'
        );

        -- GT_DM35_RAW_DATA INSERT (미래구간 계획)
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT 'CURRENT' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , A.MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'P', 1
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      --[E20241126-000426]_CUST_FCST 추가 START
                      --AND    LS.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      AND    LS.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      --[E20241126-000426]_CUST_FCST 추가 END
                WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      AND    LS.MEASURE IN ('CUST_FCST', 'Customer FCST'))
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
                ELSE (SELECT LS.CREATE_DATE FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.MEASURE = A.MEASURE)
               END)
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
                     (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA'
                           --[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
                           -- ELSE A.LAST_UPDATED_BY || '_EXCEL' END)
                           ELSE A.LAST_UPDATED_BY END)
                     --[E20241126-000426]_CUST_FCST 추가 START
                     --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID) || '_EDI'
                          ELSE A.ATTRIBUTE5 || '_' || A.LAST_UPDATED_BY END)
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.LAST_UPDATED_BY) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
                      AND    LS.CREATE_DATE = (SELECT MAX(LS2.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS2
                                               WHERE  LS2.DIVISION_ID = A.DIVISION_ID AND LS2.PROJECT_CODE = A.PROJECT_CODE AND LS2.SCM_SITE_ID = A.SCM_SITE_ID AND LS2.ITEM_ID = A.ITEM_ID
                                               AND    LS2.DOM_EXP = A.DOM_EXP AND LS2.FCST_TYPE = A.FCST_TYPE AND LS2.INCOTERMS = A.INCOTERMS
                                               AND    LS2.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
                ELSE (SELECT LS.LAST_UPDATED_BY FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.MEASURE = A.MEASURE)
               END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE4, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_CODE) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE4 END)
                ELSE NULL END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE5 END)
                ELSE NULL END)
             --[E20231121-000493] 82번사업부_mktFcstWaterfall 화면 내 AS From Site 추가 요청
             , CASE WHEN A.DIVISION_ID IN ('81', '82') THEN A.ATTRIBUTE10 ELSE NULL END AS AS_FROM_SITE --20230825
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_DM_PLN_MKT A;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D61--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        -- [20240312] end

        --EDI 계획(CUST_FCST_EDI)

        -- [20240312] 개별 insert 함
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        WITH T_EDI_END_CUST_SUBQRY AS (
            SELECT EC.DIVISION_ID, EC.END_CUSTOMER, EC.SCM_SITE_ID, MAX(EC.SCM_SITE_ID) AS MAX_SCM_SITE_ID
            FROM SCM_MGR.GT_DM35_EDI_END_CUST EC
            GROUP BY EC.DIVISION_ID, EC.END_CUSTOMER, EC.SCM_SITE_ID
        )
        SELECT 'CURRENT' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'P'    AS PLAN_RESULT
             , 1      AS GUBUN
             , (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                AND    LS.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')) 
                      AS CREATE_DATE
             , (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                          (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID) || '_EDI'
                     ELSE A.ATTRIBUTE5 || '_' || A.LAST_UPDATED_BY END)  AS LAST_UPDATED_BY
             , (CASE WHEN NVL(A.ATTRIBUTE4, '@#@#@#') = '@#@#@#' THEN
                          (SELECT MAX(ES.SENDER_CODE) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                     ELSE A.ATTRIBUTE4 END)                              AS SENDER_CODE
             , (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                          (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                     ELSE A.ATTRIBUTE5 END)                              AS SENDER_NAME
             , NULL AS AS_FROM_SITE
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM (
              SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                   , F.LAST_UPDATED_BY, F.ATTRIBUTE4, F.ATTRIBUTE5
              FROM SCM_MGR.DM_PLN_MKT_FCST F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
              UNION ALL
              SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                   , F.LAST_UPDATED_BY, F.ATTRIBUTE4, F.ATTRIBUTE5
              FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
              ) A
              JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
              LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE C
                ON A.DIVISION_ID = C.DIVISION_ID
               AND A.SCM_SITE_ID = C.SCM_SITE_ID
               AND C.SITE_TYPE   = 'SALES'
               AND C.VALID_YN    = 'Y'
               AND (CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.END_CUSTOMER, '-')
                         ELSE NVL(REPLACE(C.END_CUSTOMER, '-', ''), '@#@#@#') END) <> '@#@#@#'
              --ORA-01799: 열은 하위 질의에 포괄 조인될 수 없습니다.  오류로 변경함
              LEFT OUTER JOIN T_EDI_END_CUST_SUBQRY D
                ON D.DIVISION_ID  = A.DIVISION_ID
               AND D.END_CUSTOMER = C.END_CUSTOMER
               AND D.SCM_SITE_ID  = COALESCE(D.MAX_SCM_SITE_ID, '-') -- COALESCE 사용
              /*LEFT OUTER JOIN SCM_MGR.GT_DM35_EDI_END_CUST D
                ON A.DIVISION_ID  = D.DIVISION_ID
               AND D.END_CUSTOMER = C.END_CUSTOMER
               AND D.SCM_SITE_ID  = NVL((SELECT MAX(EC.SCM_SITE_ID)
                                         FROM   SCM_MGR.GT_DM35_EDI_END_CUST EC
                                         WHERE  EC.DIVISION_ID  = A.DIVISION_ID
                                         AND    EC.END_CUSTOMER = C.END_CUSTOMER
                                         AND    EC.SCM_SITE_ID  = A.SCM_SITE_ID), '-')*/
        WHERE 1 = 1
        --[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. START
        /*
        AND A.ATTRIBUTE9 >= (SELECT ...) AND A.ATTRIBUTE9 <= (SELECT ...)
        */
        --[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. END
        AND A.YYYYMMDD    >= P_FROM_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
        AND A.DIVISION_ID  = P_DIVISION_ID
        AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
        AND A.QTY <> 0;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D62--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 하여, 주석처리한다. START
        /*
        --EDI Org.계획(CUST_FCST_EDI[Org.]) - 주석처리됨
        */
        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 하여, 주석처리한다. END

        --RPA계획(CUST_FCST) 
        -- [20240312] 개별 insert 함
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT 'CURRENT' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'P', 1
             , (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                --[E20241126-000426]_Customer Fcst용으로 만든다 START
                --AND    LS.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
                AND    LS.MEASURE IN ('CUSTOMER FCST'))
                --[E20241126-000426]_Customer Fcst용으로 만든다 END
             , (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA'
                     --[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
                     -- ELSE A.LAST_UPDATED_BY || '_EXCEL' END)
                     ELSE A.LAST_UPDATED_BY END)
             , NULL
             , NULL
             , NULL AS AS_FROM_SITE
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM (
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY
            FROM SCM_MGR.DM_PLN_MKT_FCST F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
            UNION ALL
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY
            FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
        ) A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
          ON A.MEASURE = B.MEASURE
        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE C
          ON A.DIVISION_ID = C.DIVISION_ID
         AND A.SCM_SITE_ID = C.SCM_SITE_ID
         AND C.SITE_TYPE   = 'SALES'
         AND C.VALID_YN    = 'Y'
         AND (CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.END_CUSTOMER, '-')
                   ELSE NVL(REPLACE(C.END_CUSTOMER, '-', ''), '@#@#@#') END) <> '@#@#@#'
        --ORA-01799: 열은 하위 질의에 포괄 조인될 수 없습니다.  오류로 변경함
        LEFT OUTER JOIN (SELECT RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                               ,MAX(RC.SCM_SITE_ID) AS MAX_SCM_SITE_ID
                         FROM   SCM_MGR.GT_DM35_EDI_END_CUST RC
                         WHERE  1=1
                         GROUP BY RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                        ) RC
         ON  RC.DIVISION_ID  = A.DIVISION_ID
         AND RC.END_CUSTOMER = C.END_CUSTOMER
         AND RC.SCM_SITE_ID  = A.SCM_SITE_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM35_RPA_END_CUST D
          ON D.DIVISION_ID  = A.DIVISION_ID
         AND D.END_CUSTOMER = C.END_CUSTOMER
         AND D.SCM_SITE_ID  = NVL(RC.MAX_SCM_SITE_ID,'-')
         /*AND D.SCM_SITE_ID  = NVL((SELECT MAX(RC.SCM_SITE_ID)
                                   FROM   SCM_MGR.GT_DM35_EDI_END_CUST RC
                                   WHERE  RC.DIVISION_ID  = A.DIVISION_ID
                                   AND    RC.END_CUSTOMER = C.END_CUSTOMER
                                   AND    RC.SCM_SITE_ID  = A.SCM_SITE_ID), '-')*/
        WHERE 1 = 1
        --[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. START
        /*
        AND CONVERT(...) >= ... AND CONVERT(...) <= ...
        */
        --[E20241126-000426]_화면에서 보이지 않는 데이터는 배치에서 삭제하도록 한다. END
        AND A.YYYYMMDD    >= V_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
        AND A.DIVISION_ID  = P_DIVISION_ID
        --[E20241126-000426]_Customer Fcst용으로 만든다 START
        --AND A.MEASURE IN ('CUST_FCST', 'Customer FCST')
        AND A.MEASURE IN ('Customer FCST')
        --[E20241126-000426]__Customer Fcst으로 만든다 END
        AND A.QTY <> 0;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D63--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241126-000426]_CUST_FCST용으로 만든다 START
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT 'CURRENT' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'P', 1
             , (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                AND    LS.MEASURE IN ('CUST_FCST'))
             , A.LAST_UPDATED_BY
             , NULL
             , NULL
             , NULL AS AS_FROM_SITE
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM (
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY
            FROM SCM_MGR.DM_PLN_MKT_FCST F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
            UNION ALL
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY
            FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
        ) A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
          ON A.MEASURE = B.MEASURE
        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE C
          ON A.DIVISION_ID = C.DIVISION_ID
         AND A.SCM_SITE_ID = C.SCM_SITE_ID
         AND C.SITE_TYPE   = 'SALES'
         AND C.VALID_YN    = 'Y'
         AND (CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.END_CUSTOMER, '-')
                   ELSE NVL(REPLACE(C.END_CUSTOMER, '-', ''), '@#@#@#') END) <> '@#@#@#'
        --ORA-01799: 열은 하위 질의에 포괄 조인될 수 없습니다.  오류로 변경함
        LEFT OUTER JOIN (SELECT RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                               ,MAX(RC.SCM_SITE_ID) AS MAX_SCM_SITE_ID
                         FROM   SCM_MGR.GT_DM35_EDI_END_CUST RC
                         WHERE  1=1
                         GROUP BY RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                        ) RC
         ON  RC.DIVISION_ID  = A.DIVISION_ID
         AND RC.END_CUSTOMER = C.END_CUSTOMER
         AND RC.SCM_SITE_ID  = A.SCM_SITE_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM35_RPA_END_CUST D
          ON D.DIVISION_ID  = A.DIVISION_ID
         AND D.END_CUSTOMER = C.END_CUSTOMER
         AND D.SCM_SITE_ID  = NVL(RC.MAX_SCM_SITE_ID,'-')
         /*AND D.SCM_SITE_ID  = NVL((SELECT EC.SCM_SITE_ID FROM SCM_MGR.GT_DM35_EDI_END_CUST EC
                                   WHERE  EC.DIVISION_ID  = A.DIVISION_ID
                                   AND    EC.END_CUSTOMER = C.END_CUSTOMER
                                   AND    EC.SCM_SITE_ID  = A.SCM_SITE_ID), '-')*/
        WHERE 1 = 1
        AND A.YYYYMMDD    >= V_NOW_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
        AND A.DIVISION_ID  = P_DIVISION_ID
        AND A.MEASURE IN ('CUST_FCST')
        AND A.QTY <> 0;
        --[E20241126-000426]_CUST_FCST용으로 만든다 END


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D64--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        -- GT_DM35_RAW_DATA INSERT (실적)
        -- [20240312] 개별 insert 함
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT 'CURRENT' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'R', 2
             , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      --[E20241126-000426]_CUST_FCST 추가 START
                      --AND    LS.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      AND    LS.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      --[E20241126-000426]_CUST_FCST 추가 END
                WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      AND    LS.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
                ELSE (SELECT LS.CREATE_DATE FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.MEASURE = A.MEASURE)
               END)
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
                     (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA'
                           --[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
                           -- ELSE A.LAST_UPDATED_BY || '_EXCEL' END)
                           ELSE A.LAST_UPDATED_BY END)
                     --[E20241126-000426]_CUST_FCST 추가 START
                     --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID) || '_EDI'
                          ELSE A.ATTRIBUTE5 || '_' || A.LAST_UPDATED_BY END)
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.LAST_UPDATED_BY) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
                      AND    LS.CREATE_DATE = (SELECT MAX(LS2.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS2
                                               WHERE  LS2.DIVISION_ID = A.DIVISION_ID AND LS2.PROJECT_CODE = A.PROJECT_CODE AND LS2.SCM_SITE_ID = A.SCM_SITE_ID AND LS2.ITEM_ID = A.ITEM_ID
                                               AND    LS2.DOM_EXP = A.DOM_EXP AND LS2.FCST_TYPE = A.FCST_TYPE AND LS2.INCOTERMS = A.INCOTERMS
                                               AND    LS2.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
                ELSE (SELECT LS.LAST_UPDATED_BY FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.MEASURE = A.MEASURE)
               END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE4, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_CODE) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE4 END)
                ELSE NULL END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST','Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE5 END)
                ELSE NULL END)
             --[E20231121-000493] 82번사업부_mktFcstWaterfall 화면 내 AS From Site 추가 요청
             , CASE WHEN A.DIVISION_ID IN ('81', '82') THEN A.ATTRIBUTE10 ELSE NULL END AS AS_FROM_SITE
             --, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
             , A.CELL_PROD_SITE_ID  -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        WHERE A.YYYYMMDD    >= P_FROM_YYYYMMDD AND A.YYYYMMDD < V_NOW_YYYYMMDD
        AND   A.DIVISION_ID  = P_DIVISION_ID
        AND   A.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'                           
                             --[E20241126-000426]_ORG데이터는 화면에서 보여주지 않기로 했으므로 주석처리한다. START
                             /*
                             , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
                             , 'Material_Temp[Org.]', 'Backorder[Org.]'             
                             */
                             --[E20241126-000426]_ORG데이터는 화면에서 보여주지 않기로 했으므로 주석처리한다. END
                             , 'CUST_FCST', 'Customer FCST'
                             ,'SCM_FCST') --SCM_FCST 조건 추가 [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
        AND   A.QTY         <> 0;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D65--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --PRINT ( 'A1--07--09 : ' + CONVERT(NVARCHAR(30), GETDATE(), 121))

        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
        /*
        IF EXISTS (SELECT 1 FROM GT_DM35_SEL_MEASURE WHERE MEASURE IN ('CUST_FCST_ORG', 'Customer Fcst[Org.]'))
        BEGIN ... END
        */
        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
        

        --RPA 실적(CUST_FCST)
        -- [20240312] 개별 insert 함
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT 'CURRENT' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'R', 2
             , (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                --[E20241126-000426]_Customer Fcst용으로 만든다 START
                --AND    LS.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
                AND    LS.MEASURE IN ('CUSTOMER FCST'))
                --[E20241126-000426]_Customer Fcst용으로 만든다 START
             , (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA'
                     --[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
                     --ELSE A.LAST_UPDATED_BY || '_EXCEL' END)
                     ELSE A.LAST_UPDATED_BY END)
             , NULL
             , NULL
             , NULL AS AS_FROM_SITE
             --, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
             , A.CELL_PROD_SITE_ID  -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE C
          ON A.DIVISION_ID = C.DIVISION_ID
         AND A.SCM_SITE_ID = C.SCM_SITE_ID
         AND C.SITE_TYPE   = 'SALES'
         AND C.VALID_YN    = 'Y'
         AND (CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.END_CUSTOMER, '-')
                   ELSE NVL(REPLACE(C.END_CUSTOMER, '-', ''), '@#@#@#') END) <> '@#@#@#'
        --ORA-01799: 열은 하위 질의에 포괄 조인될 수 없습니다.  오류로 변경함
        LEFT OUTER JOIN (SELECT RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                               ,MAX(RC.SCM_SITE_ID) AS MAX_SCM_SITE_ID
                         FROM   SCM_MGR.GT_DM35_EDI_END_CUST RC
                         WHERE  1=1
                         GROUP BY RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                        ) RC
         ON  RC.DIVISION_ID  = A.DIVISION_ID
         AND RC.END_CUSTOMER = C.END_CUSTOMER
         AND RC.SCM_SITE_ID  = A.SCM_SITE_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM35_RPA_END_CUST D
          ON D.DIVISION_ID  = A.DIVISION_ID
         AND D.END_CUSTOMER = C.END_CUSTOMER
         AND D.SCM_SITE_ID  = NVL(RC.MAX_SCM_SITE_ID,'-')
         /*AND D.SCM_SITE_ID  = NVL((SELECT EC.SCM_SITE_ID FROM SCM_MGR.GT_DM35_EDI_END_CUST EC
                                   WHERE  EC.DIVISION_ID  = A.DIVISION_ID
                                   AND    EC.END_CUSTOMER = C.END_CUSTOMER
                                   AND    EC.SCM_SITE_ID  = A.SCM_SITE_ID), '-')*/
        WHERE 1 = 1
        --[E20241126-000426]_화면에서 보여주지 않을 데이터는 배치에서 삭제하도록 한다. START
        /*
        AND CONVERT(...) >= ... AND CONVERT(...) <= ...
        */
        --[E20241126-000426]_화면에서 보여주지 않을 데이터는 배치에서 삭제하도록 한다. END
        AND A.YYYYMMDD    >= P_FROM_YYYYMMDD AND A.YYYYMMDD < V_NOW_YYYYMMDD
        AND A.DIVISION_ID  = P_DIVISION_ID
        --[E20241126-000426]_Customer Fcst용으로 만든다 START
        --AND A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST')
        AND A.MEASURE IN ('CUSTOMER FCST')
        --[E20241126-000426]_Customer Fcst용으로 만든다 END
        AND A.QTY <> 0;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D66--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241126-000426]_CUST_FCST용으로 만든다 START
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT 'CURRENT' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'R', 2
             , (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP LS
                WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS
                AND    LS.MEASURE IN ('CUST_FCST'))
             , A.LAST_UPDATED_BY
             , NULL
             , NULL
             , NULL AS AS_FROM_SITE
             , A.CELL_PROD_SITE_ID  -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE C
          ON A.DIVISION_ID = C.DIVISION_ID
         AND A.SCM_SITE_ID = C.SCM_SITE_ID
         AND C.SITE_TYPE   = 'SALES'
         AND C.VALID_YN    = 'Y'
         AND (CASE WHEN A.DIVISION_ID = '40' THEN NVL(C.END_CUSTOMER, '-')
                   ELSE NVL(REPLACE(C.END_CUSTOMER, '-', ''), '@#@#@#') END) <> '@#@#@#'
        --ORA-01799: 열은 하위 질의에 포괄 조인될 수 없습니다.  오류로 변경함
        LEFT OUTER JOIN (SELECT RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                               ,MAX(RC.SCM_SITE_ID) AS MAX_SCM_SITE_ID
                         FROM   SCM_MGR.GT_DM35_EDI_END_CUST RC
                         WHERE  1=1
                         GROUP BY RC.DIVISION_ID ,RC.SCM_SITE_ID ,RC.END_CUSTOMER
                        ) RC
         ON  RC.DIVISION_ID  = A.DIVISION_ID
         AND RC.END_CUSTOMER = C.END_CUSTOMER
         AND RC.SCM_SITE_ID  = A.SCM_SITE_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM35_RPA_END_CUST D
          ON D.DIVISION_ID  = D.DIVISION_ID
         AND D.END_CUSTOMER = C.END_CUSTOMER
         AND D.SCM_SITE_ID  = NVL(RC.MAX_SCM_SITE_ID,'-')
         /*AND D.SCM_SITE_ID  = NVL((SELECT EC.SCM_SITE_ID FROM SCM_MGR.GT_DM35_EDI_END_CUST EC
                                   WHERE  EC.DIVISION_ID  = A.DIVISION_ID
                                   AND    EC.END_CUSTOMER = C.END_CUSTOMER
                                   AND    EC.SCM_SITE_ID  = A.SCM_SITE_ID), '-')*/
        WHERE 1 = 1
        AND A.YYYYMMDD    >= P_FROM_YYYYMMDD AND A.YYYYMMDD < V_NOW_YYYYMMDD
        AND A.DIVISION_ID  = P_DIVISION_ID
        AND A.MEASURE IN ('CUST_FCST')
        AND A.QTY <> 0;
        --[E20241126-000426]_CUST_FCST용으로 만든다 END

        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'D67--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    END IF; -- IF P_VERSION_NO LIKE '%CURRENT%'
    
    
    -- E1-- 로깅
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E1--CURRENT';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    IF P_VERSION_NO LIKE '%MF%' OR P_VERSION_NO LIKE '%SF%' --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
    THEN
        INSERT INTO SCM_MGR.GT_DM35_T_LAST_SETUP_C
        SELECT X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
        FROM (
            SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 --[E20241126-000426]_CUST_FCST 추가 START
                 --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                 , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                    --[E20241126-000426]_CUST_FCST 추가 END
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
                    -- , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
                    ) THEN
                    (CASE WHEN NVL(MAX(A.ATTRIBUTE9), '@#@#@#') = '@#@#@#' THEN
                               MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
                          ELSE MAX(A.ATTRIBUTE9) END)
                 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
                 , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM (
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     , F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE9, F.VERSION_NO, F.CUTOFF_TYPE
                FROM SCM_MGR.DM_PLN_MKT_FCST_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
                UNION ALL
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     , F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE9, F.VERSION_NO, F.CUTOFF_TYPE
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
            ) A
            JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
              ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
                                   WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
                                   ELSE B.MEASURE END)
            JOIN SCM_MGR.GT_DM35_VERSION C
              ON A.VERSION_NO = C.VERSION_NO
             AND (A.CUTOFF_TYPE LIKE '%MF%' OR A.CUTOFF_TYPE LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
            WHERE A.DIVISION_ID = P_DIVISION_ID
            AND   A.QTY <> 0
            GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
            UNION ALL
            SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 --[E20241126-000426]_CUST_FCST 추가 START
                 --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                 , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                    --[E20241126-000426]_CUST_FCST 추가 END
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
                    --, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
                    ) THEN
                    (CASE WHEN NVL(MAX(A.ATTRIBUTE9), '@#@#@#') = '@#@#@#' THEN
                               MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
                          ELSE MAX(A.ATTRIBUTE9) END)
                 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
                 , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A
            JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
              ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
                                   WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
                                   ELSE B.MEASURE END)
            JOIN SCM_MGR.GT_DM35_VERSION C
              ON A.VERSION_NO = C.VERSION_NO
             AND (A.CUTOFF_TYPE LIKE '%MF%' OR A.CUTOFF_TYPE LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
            WHERE A.DIVISION_ID = P_DIVISION_ID
            AND   A.QTY <> 0
            GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        ) X
        WHERE NVL(X.PROJECT_CODE, '@#@#@#') <> '@#@#@#'
        AND   NVL(X.SCM_SITE_ID,  '@#@#@#') <> '@#@#@#'
        AND   NVL(X.ITEM_ID,      '@#@#@#') <> '@#@#@#'
        GROUP BY X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E11--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        -- MF/SF 버전 계획 데이터 INSERT (미래구간 - DM_PLN_MKT_FCST_C)
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT CASE WHEN P_DIVISION_ID = '82' THEN E.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'P', 3
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      --[E20241126-000426]_CUST_FCST 추가 START
                      --AND    LS.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      AND    LS.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      --[E20241126-000426]_CUST_FCST 추가 START
                WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      AND    LS.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
                ELSE (SELECT LS.CREATE_DATE FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO AND LS.MEASURE = A.MEASURE)
               END)
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
                     (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA'
                           --[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
                           -- ELSE A.LAST_UPDATED_BY || '_EXCEL' END)
                           ELSE A.LAST_UPDATED_BY END)
                     --[E20241126-000426]_CUST_FCST 추가 START
                     --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID) || '_EDI'
                          ELSE A.ATTRIBUTE5 || '_' || A.LAST_UPDATED_BY END)
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.LAST_UPDATED_BY) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
                      AND    LS.CREATE_DATE = (SELECT MAX(LS2.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS2
                                               WHERE  LS2.DIVISION_ID = A.DIVISION_ID AND LS2.PROJECT_CODE = A.PROJECT_CODE AND LS2.SCM_SITE_ID = A.SCM_SITE_ID AND LS2.ITEM_ID = A.ITEM_ID
                                               AND    LS2.DOM_EXP = A.DOM_EXP AND LS2.FCST_TYPE = A.FCST_TYPE AND LS2.INCOTERMS = A.INCOTERMS AND LS2.VERSION_NO = A.VERSION_NO
                                               AND    LS2.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
                ELSE (SELECT LS.LAST_UPDATED_BY FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO AND LS.MEASURE = A.MEASURE)
               END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE4, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_CODE) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE4 END)
                ELSE NULL END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE5 END)
                ELSE NULL END)
             --[E20231121-000493] 82번사업부_mktFcstWaterfall 화면 내 AS From Site 추가 요청
             , CASE WHEN A.DIVISION_ID IN ('81', '82') THEN A.ATTRIBUTE10 ELSE NULL END AS AS_FROM_SITE
             --[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 START
             --, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
             , A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
             --[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 END
        FROM (
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE4, F.ATTRIBUTE5, F.ATTRIBUTE9, F.VERSION_NO, F.CUTOFF_TYPE, F.CUTOFF_YYYYMMDD
            FROM SCM_MGR.DM_PLN_MKT_FCST_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
            UNION ALL
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE4, F.ATTRIBUTE5, F.ATTRIBUTE9, F.VERSION_NO, F.CUTOFF_TYPE, F.CUTOFF_YYYYMMDD
            FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
        ) A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
        JOIN SCM_MGR.GT_DM35_VERSION E
          ON A.VERSION_NO = E.VERSION_NO
         AND (E.VERSION_NO LIKE '%MF%' OR E.VERSION_NO LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
        WHERE A.YYYYMMDD >= P_FROM_YYYYMMDD AND A.YYYYMMDD <= P_TO_YYYYMMDD
        AND   A.YYYYMMDD >= E.NOW_YYYYMMDD
        AND   A.DIVISION_ID = P_DIVISION_ID
        AND   A.MEASURE NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
        AND   A.QTY <> 0;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E12--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
        /*
        UNION ALL SELECT ... (ORG 데이터 - 주석처리됨)
        */
        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END

        -- MF/SF 버전 실적 데이터 INSERT (과거구간 - DM_PLN_MKT_FCST_RESULT_C)
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT CASE WHEN P_DIVISION_ID = '82' THEN C.VERSION_NO_W ELSE A.VERSION_NO END AS VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
                    WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
                    ELSE '' END AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'R', 4
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 START
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      --[E20241126-000426]_CUST_FCST 추가 START
                      --AND    LS.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      AND    LS.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'))
                      --[E20241126-000426]_CUST_FCST 추가 END
                WHEN A.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      AND    LS.MEASURE IN ('CUST_FCST', 'CUSTOMER FCST'))
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST'))
                ELSE (SELECT LS.CREATE_DATE FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO AND LS.MEASURE = A.MEASURE)
               END)
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'Customer FCST') THEN
                     (CASE WHEN A.LAST_UPDATED_BY LIKE '%robot' THEN A.LAST_UPDATED_BY || '_RPA'
                           --[E20250325-000681]_CUST_FCST Measure LAST_UPDATE 생성 로직 변경
                           -- ELSE A.LAST_UPDATED_BY || '_EXCEL' END)
                           ELSE A.LAST_UPDATED_BY END)
                     --[E20241126-000426]_CUST_FCST 추가 START
                     --WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
                     --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID) || '_EDI'
                          ELSE A.ATTRIBUTE5 || '_' || A.LAST_UPDATED_BY END)
                WHEN A.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST') THEN
                     (SELECT MAX(LS.LAST_UPDATED_BY) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                      AND    LS.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')
                      AND    LS.CREATE_DATE = (SELECT MAX(LS2.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS2
                                               WHERE  LS2.DIVISION_ID = A.DIVISION_ID AND LS2.PROJECT_CODE = A.PROJECT_CODE AND LS2.SCM_SITE_ID = A.SCM_SITE_ID AND LS2.ITEM_ID = A.ITEM_ID
                                               AND    LS2.DOM_EXP = A.DOM_EXP AND LS2.FCST_TYPE = A.FCST_TYPE AND LS2.INCOTERMS = A.INCOTERMS AND LS2.VERSION_NO = A.VERSION_NO
                                               AND    LS2.MEASURE IN ('RTF', 'RTF_SYS_RP', 'MKT_FCST')))
                ELSE (SELECT LS.LAST_UPDATED_BY FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                      WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                      AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO AND LS.MEASURE = A.MEASURE)
               END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE4, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_CODE) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE4 END)
                ELSE NULL END)
             --[E20241126-000426]_CUST_FCST 추가 START
             --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder') THEN
             --[E20241126-000426]_CUST_FCST 추가 END
                     (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                                (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                          ELSE A.ATTRIBUTE5 END)
                ELSE NULL END)
             --[E20231121-000493] 82번사업부_mktFcstWaterfall 화면 내 AS From Site 추가 요청
             , CASE WHEN A.DIVISION_ID IN ('81', '82') THEN A.ATTRIBUTE10 ELSE NULL END AS AS_FROM_SITE
             --, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
             , A.CELL_PROD_SITE_ID  -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        JOIN SCM_MGR.GT_DM35_VERSION C
          ON A.VERSION_NO = C.VERSION_NO
         AND (C.VERSION_NO LIKE '%MF%' OR C.VERSION_NO LIKE '%SF%') --[PJ2025-50188] Version 팝업에서 SF를 선택해서 조회하기 위해서 %SF% 추가
        WHERE A.YYYYMMDD    >= P_FROM_YYYYMMDD
        AND   A.YYYYMMDD    <  C.NOW_YYYYMMDD
        AND   A.DIVISION_ID  = P_DIVISION_ID
        AND   A.MEASURE NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
                                , 'SCM_FCST') --SCM_FCST 조건 추가 [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
        AND   A.QTY <> 0;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E13--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
        /*
        IF EXISTS ( SELECT 1 FROM GT_DM35_SEL_MEASURE WHERE MEASURE IN ('CUST_FCST_ORG', 'Customer Fcst[Org.]')) BEGIN ... END
        */
        --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END

    END IF; -- IF P_VERSION_NO LIKE '%MF%' OR '%SF%'

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E2--P_VERSION_NO LIKE ''%MF%'' OR ''%SF%''';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --EDI 소급적용
    IF P_VERSION_NO LIKE '%ME%'
    THEN
        INSERT INTO SCM_MGR.GT_DM35_T_LAST_SETUP_C
        SELECT X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
        FROM (
            SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 --[E20241126-000426]_CUST_FCST 추가 START
                 --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                 , (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                    --[E20241126-000426]_CUST_FCST 추가 END
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
                    --, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
                    ) THEN
                    (CASE WHEN NVL(MAX(A.ATTRIBUTE9), '@#@#@#') = '@#@#@#' THEN
                               MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
                          ELSE MAX(A.ATTRIBUTE9) END)
                 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
                 , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM (
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     , F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE9, F.VERSION_NO
                FROM SCM_MGR.DM_PLN_MKT_FCST_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
                UNION ALL
                SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     , F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE9, F.VERSION_NO
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
            ) A
            JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
              ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
                                   WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
                                   ELSE B.MEASURE END)
            JOIN SCM_MGR.GT_DM35_VERSION C
              ON A.VERSION_NO = C.VERSION_NO
             AND C.VERSION_NO LIKE '%ME%'
            WHERE A.DIVISION_ID = P_DIVISION_ID
            AND   A.QTY <> 0
            GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
            UNION ALL
            SELECT A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                 --[E20241126-000426]_CUST_FCST 추가 START
                 --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                 , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                    --[E20241126-000426]_CUST_FCST 추가 END
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
                    --, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
                    --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
                    ) THEN
                    (CASE WHEN NVL(MAX(A.ATTRIBUTE9), '@#@#@#') = '@#@#@#' THEN
                               MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
                          ELSE MAX(A.ATTRIBUTE9) END)
                 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
                 , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
            FROM SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A
            JOIN SCM_MGR.GT_DM35_SEL_MEASURE B
              ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
                                   WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
                                   ELSE B.MEASURE END)
            JOIN SCM_MGR.GT_DM35_VERSION C
              ON A.VERSION_NO = C.VERSION_NO
             AND C.VERSION_NO LIKE '%ME%'
            WHERE A.DIVISION_ID = P_DIVISION_ID
            AND   A.QTY <> 0
            GROUP BY A.VERSION_NO, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
        ) X
        WHERE NVL(X.PROJECT_CODE, '@#@#@#') <> '@#@#@#'
        AND   NVL(X.SCM_SITE_ID,  '@#@#@#') <> '@#@#@#'
        AND   NVL(X.ITEM_ID,      '@#@#@#') <> '@#@#@#'
        GROUP BY X.VERSION_NO, X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E21--GT_DM35_T_LAST_SETUP_C';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
           , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
           , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT A.VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.MEASURE
             , '' AS MEASURE_GROUP
             , A.YYYYMMDD
             , A.QTY
             , 'P', 5
             , (SELECT MAX(LS.CREATE_DATE) FROM SCM_MGR.GT_DM35_T_LAST_SETUP_C LS
                WHERE  LS.DIVISION_ID = A.DIVISION_ID AND LS.PROJECT_CODE = A.PROJECT_CODE AND LS.SCM_SITE_ID = A.SCM_SITE_ID AND LS.ITEM_ID = A.ITEM_ID
                AND    LS.DOM_EXP = A.DOM_EXP AND LS.FCST_TYPE = A.FCST_TYPE AND LS.INCOTERMS = A.INCOTERMS AND LS.VERSION_NO = A.VERSION_NO
                --[E20241126-000426]_CUST_FCST 추가 START
                --AND    LS.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                AND    LS.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
                --[E20241126-000426]_CUST_FCST 추가 END
                       --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. START
                       --, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'
                       --[E20241126-000426]_ORG 데이터는 보여주지 않기로 했으므로 주석처리한다. END
                       ))
             , (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                          (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID) || '_EDI'
                     ELSE A.ATTRIBUTE5 || '_' || A.LAST_UPDATED_BY END)
             , (CASE WHEN NVL(A.ATTRIBUTE4, '@#@#@#') = '@#@#@#' THEN
                          (SELECT MAX(ES.SENDER_CODE) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                     ELSE A.ATTRIBUTE4 END)
             , (CASE WHEN NVL(A.ATTRIBUTE5, '@#@#@#') = '@#@#@#' THEN
                          (SELECT MAX(ES.SENDER_NAME) FROM SCM_MGR.GT_DM35_EDI_SENDER ES WHERE ES.SCM_SITE_ID = A.SCM_SITE_ID)
                     ELSE A.ATTRIBUTE5 END)
             --[E20231121-000493] 82번사업부_mktFcstWaterfall 화면 내 AS From Site 추가 요청
             , CASE WHEN A.DIVISION_ID IN ('81', '82') THEN A.ATTRIBUTE10 ELSE NULL END AS AS_FROM_SITE
             --[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 START
             --, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
             , A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
             --[E20250805-000706]_CELL_PROD_SITE_ID는 하단에서 다 처리함으로 A.CELL_PROD_SITE_ID로 쓰는게 맞다. 버그 수정 END
        FROM (
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY, F.ATTRIBUTE4, F.ATTRIBUTE5, F.VERSION_NO, F.CUTOFF_YYYYMMDD
            FROM SCM_MGR.DM_PLN_MKT_FCST_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 2
            UNION ALL
            SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                 , F.LAST_UPDATED_BY, F.ATTRIBUTE4, F.ATTRIBUTE5, F.VERSION_NO, F.CUTOFF_YYYYMMDD
            FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C F WHERE (CASE WHEN P_DIVISION_ID = '40' THEN 1 ELSE 2 END) = 1
        ) A
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE B ON A.MEASURE = B.MEASURE
        JOIN SCM_MGR.SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
        JOIN SCM_MGR.GT_DM35_VERSION E
          ON A.VERSION_NO = E.VERSION_NO
         AND E.VERSION_NO LIKE '%ME%'
        WHERE A.YYYYMMDD    >= P_FROM_YYYYMMDD
        AND   A.YYYYMMDD    <= P_TO_YYYYMMDD
        AND   A.DIVISION_ID  = P_DIVISION_ID
        AND   A.QTY         <> 0;


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E22--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    END IF; -- IF P_VERSION_NO LIKE '%ME%'

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A--P_VERSION_NO LIKE ''%ME%''';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
    /*
    --[E20241015-000415]_MKT FCST, mktFcstWaterfall 화면 신규 환산자 컬럼 추가 요청 건 START
    CREATE TABLE #TEMP_W_CELL_CF_DATA / #TEMP_CELL_CF / #TEMP_SCM_MST_SITE_ITEM_CELL ... 주석처리됨
    */
    --[E20260123-001715]_소스원복으로 원요청내역 주석처리 START

    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START

    -- --> SCM_MST_ITEM_SN 테이블을 GTT로 넣는다.
    INSERT INTO SCM_MGR.GT_DM35_ITEM_SINGLE_ORI
         (DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
         , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE, CELL_QUANTITY
         , SCP_EXTRA_SPEC, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
         , DOE
         --, ATTRIBUTE1, OPERATION_GROUP
         , FLOW_ID
         --, LEVEL2_CODE
         --, GROUP_CODE1, GROUP_CODE4, GROUP_CODE5, GROUP_CODE6, GROUP_CODE7, ATTRIBUTE8
         )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
         , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE, CELL_QUANTITY
         , SCP_EXTRA_SPEC, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
         , DOE
         --, ATTRIBUTE1, OPERATION_GROUP
         , FLOW_ID
         --, LEVEL2_CODE
         --, GROUP_CODE1, GROUP_CODE4, GROUP_CODE5, GROUP_CODE6, GROUP_CODE7, ATTRIBUTE8
    FROM SCM_MGR.SCM_MST_ITEM_SN
    WHERE DIVISION_ID = P_DIVISION_ID;


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A1--GT_DM35_ITEM_SINGLE_ORI';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- 멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    INSERT INTO SCM_MGR.GT_DM35_ITEM_SINGLE_A
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)          AS ITEM_NAME
         , MAX(T1.ITEM_CLASS)         AS ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME)    AS ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME)          AS NICK_NAME
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                    ELSE 4 END)
                WHEN 1 THEN 'P'
                WHEN 2 THEN 'H'
                WHEN 3 THEN 'Q'
                ELSE 'R' END          AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME) AS MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM)           AS ITEM_UOM
         , MAX(T1.SPEC)               AS SPEC
         , MAX(T1.MDM_PROJECT_NAME)   AS MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY)       AS MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG)        AS ACTIVE_FLAG
         , MAX(T1.ENERGE)             AS ENERGE
         , MAX(T1.CELL_QUANTITY)      AS CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC)     AS SCP_EXTRA_SPEC
    FROM SCM_MGR.GT_DM35_ITEM_SINGLE_ORI T1
    WHERE 1=1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A2--GT_DM35_ITEM_SINGLE_A';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- 멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
    INSERT INTO SCM_MGR.GT_DM35_ITEM_SINGLE_B
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE)                     AS CELL_TYPE
    FROM SCM_MGR.GT_DM35_ITEM_SINGLE_ORI T2
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A3--GT_DM35_ITEM_SINGLE_B';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- GTT를 JOIN하므로 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_ITEM_SINGLE_A', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_ITEM_SINGLE_A', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_ITEM_SINGLE_B', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_ITEM_SINGLE_B', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    -- GTT를 JOIN한다.
    INSERT INTO SCM_MGR.GT_DM35_ITEM_SINGLE_V
    SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
         , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
         , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
         , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
    FROM SCM_MGR.GT_DM35_ITEM_SINGLE_A T1
    INNER JOIN SCM_MGR.GT_DM35_ITEM_SINGLE_B T2
            ON T1.DIVISION_ID = T2.DIVISION_ID
           AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
    WHERE T1.DIVISION_ID = P_DIVISION_ID
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE
           , T1.MATERIAL_CLASS_NAME, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY
           , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
           , T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
           , T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC;


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A4--GT_DM35_ITEM_SINGLE_V';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END

    -- 해당 테이블의 데이터를 쓰므로, 데이터 완료된 후 KWH로 변경한다.
    UPDATE SCM_MGR.GT_DM35_ITEM_SINGLE_V
    SET ENERGE = CASE WHEN TO_NUMBER(ENERGE) IS NOT NULL THEN TO_CHAR(ROUND(TO_NUMBER(ENERGE)/1000, 4)) ELSE NULL END
    WHERE REGEXP_LIKE(ENERGE, '^[0-9.]+$');
    --[E20240731-000856]_[공급 SCM PI팀] Wh → KWh 환산 로직개선 END


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A5--UPDATE GT_DM35_ITEM_SINGLE_V';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    -- GT_DM35_ITEM_SINGLE_V JOIN 통계 수집
    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_ITEM_SINGLE_V', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_ITEM_SINGLE_V', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    -- GT_DM35_SITE_ITEM 적재
    INSERT INTO SCM_MGR.GT_DM35_SITE_ITEM
          (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, VALID_YN
         , CELL_PER_CAR, CELL_PER_MODULE
         --, VMI_YN
         , OWNER
         , OWNER_NAME
         , OWNER_NAME_KO
         , DEPT_ID
         --, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8
         --, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
         --, REPORT_GROUP6
         --, SALES_COMPANY
         --, SOLDTO_CODE
         --, SOLDTO_CUSTOMER
         --, PROJECT_S_OP_REPORT
          )
    SELECT DISTINCT
           A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.VALID_YN
         , A.CELL_PER_CAR, A.CELL_PER_MODULE
         --, A.VMI_YN
         , A.OWNER
         , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'EN' ) AS OWNER_NAME
         , SCM_MGR.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
         , (SELECT SU.DEPT_ID  
            FROM   SCM_MST_SSO_USER_INFO SU
            WHERE  SU.USER_ID = (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(A.OWNER,',')) P WHERE ROWNUM = 1)) AS DEPT_ID
         --, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE5, A.ATTRIBUTE7, A.ATTRIBUTE8
         --, A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE
         --, A.REPORT_GROUP6
         --, A.SALES_COMPANY
         --, A.SOLDTO_CODE
         --, A.SOLDTO_CUSTOMER
         --, A.PROJECT_S_OP_REPORT --[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건 
    FROM SCM_MGR.SCM_MST_SITE_ITEM A
         INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
                     FROM   SCM_MGR.GT_DM35_RAW_DATA
                     GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID) B 
             ON A.DIVISION_ID = B.DIVISION_ID
            AND A.SCM_SITE_ID = B.SCM_SITE_ID
            AND A.PROJECT_CODE = B.PROJECT_CODE
            AND A.ITEM_ID = B.ITEM_ID
    WHERE A.DIVISION_ID = P_DIVISION_ID
    ;


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A6--GT_DM35_SITE_ITEM';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_SITE_ITEM', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_SITE_ITEM', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');



    DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
    WHERE (A.VERSION_NO = 'CURRENT' AND A.PLAN_RESULT = 'P')
    AND EXISTS (
        SELECT 1
        FROM   SCM_MGR.GT_DM35_SITE_ITEM B
        WHERE  B.DIVISION_ID  = A.DIVISION_ID
          AND  B.PROJECT_CODE = A.PROJECT_CODE
          AND  B.SCM_SITE_ID  = A.SCM_SITE_ID
          AND  B.ITEM_ID      = A.ITEM_ID
          AND  NVL(B.VALID_YN, '@#@#@#') <> 'Y'
    )
    ;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A7--DELETE GT_DM35_RAW_DATA';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

   
    
    DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
    WHERE NOT EXISTS (
        SELECT 1
        FROM   SCM_MGR.GT_DM35_SITE_ITEM B
        WHERE  B.DIVISION_ID  = A.DIVISION_ID
          AND  B.PROJECT_CODE = A.PROJECT_CODE
          AND  B.SCM_SITE_ID  = A.SCM_SITE_ID
          AND  B.ITEM_ID      = A.ITEM_ID
    );


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E3A8--DELETE GT_DM35_RAW_DATA';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_RAW_DATA', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_RAW_DATA', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');


    -- MKT_FCST_RP 기반 INSERT
    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE WHERE MEASURE = 'MKT_FCST_RP';

    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
           , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
             , 'MKT_FCST_RP' AS MEASURE
             , CASE WHEN A.DIVISION_ID = '40' THEN 'MKT_FCST_RP' ELSE '' END AS MEASURE_GROUP
             , YYYYMMDD, QTY, PLAN_RESULT, 5
             , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, AS_FROM_SITE
             , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_RAW_DATA A
        WHERE MEASURE = 'MKT_FCST'
        AND   A.PLAN_RESULT = 'P';
            

        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E3A8--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

            
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
           , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
             , 'MKT_FCST_RP' AS MEASURE
             , CASE WHEN A.DIVISION_ID = '40' THEN 'MKT_FCST_RP' ELSE '' END AS MEASURE_GROUP
             , YYYYMMDD, QTY, PLAN_RESULT, 6
             , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, AS_FROM_SITE
             , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_RAW_DATA A
        WHERE MEASURE = 'RTF_SYS_RP'
        AND   A.PLAN_RESULT = 'R';


        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E3A9--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    END IF;
       

    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 START
    -----------------------------------------------------------------------------------------------------------------------------------

    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE WHERE MEASURE = 'SCM_FCST';
    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
           , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , AS_FROM_SITE, CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
             , 'SCM_FCST' AS MEASURE
             , CASE WHEN A.DIVISION_ID = '40' THEN 'SCM_FCST' ELSE '' END AS MEASURE_GROUP
             , YYYYMMDD, QTY, PLAN_RESULT, 6
             , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, AS_FROM_SITE
             , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_RAW_DATA A
        WHERE MEASURE = 'RTF_SYS_RP'
        AND   A.PLAN_RESULT = 'R';

        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E3A9--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    END IF;
    -----------------------------------------------------------------------------------------------------------------------------------
    -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 END
    -----------------------------------------------------------------------------------------------------------------------------------


    -- RAW_DATA 인덱스 역할 통계 갱신
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_RAW_DATA', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    SELECT COUNT(1)
    INTO   N_LOG_COUNT
    FROM   GT_DM35_RAW_DATA;

    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E5--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    --------------------------------------------------------------------------------------------------------------------------------------------
    -- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
    --------------------------------------------------------------------------------------------------------------------------------------------
    BEGIN -- 필터링 시작

        IF NVL(P_PROJECT_CODE,'@#@#@#') <> '@#@#@#' -- 소형은 UI 에서 PROJECT DISABLE 됨
        THEN
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
                AND NOT EXISTS (
                    SELECT 1 FROM (
                        SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TOKEN
                        FROM DUAL CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                    ) C
                    WHERE B.PROJECT_CODE LIKE '%' || C.TOKEN || '%'
                    OR    B.PROJECT_NAME LIKE '%' || C.TOKEN || '%'
                )
            );


            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E51--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF NVL(P_ITEM_ID,'@#@#@#') <> '@#@#@#'
        THEN
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1 FROM (
                    SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) AS TOKEN
                    FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                ) C
                WHERE A.ITEM_ID LIKE '%' || C.TOKEN || '%'
            )
            AND NOT EXISTS (
                SELECT 1 FROM SCM_MGR.GT_DM35_ITEM_SINGLE_V B
                WHERE B.ITEM_ID = A.ITEM_ID
                AND EXISTS (
                    SELECT 1 FROM (
                        SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) AS TOKEN
                        FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                    ) D
                    WHERE B.NICK_NAME LIKE '%' || D.TOKEN || '%'
                )
            );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E52--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF NVL(P_OWNER,'@#@#@#') <> '@#@#@#'
        THEN
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1 FROM SCM_MGR.GT_DM35_SITE_ITEM B
                WHERE A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
                AND (
                    EXISTS (SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_OWNER, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER, '[^,]+', 1, LEVEL) IS NOT NULL) C WHERE B.OWNER LIKE '%' || C.TOKEN || '%')
                    OR EXISTS (SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_OWNER, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER, '[^,]+', 1, LEVEL) IS NOT NULL) D WHERE B.OWNER_NAME LIKE '%' || D.TOKEN || '%')
                    OR EXISTS (SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_OWNER, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER, '[^,]+', 1, LEVEL) IS NOT NULL) E WHERE B.OWNER_NAME_KO LIKE '%' || E.TOKEN || '%')
                )
            );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E53--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF P_DEPT_ID <> 'ALL'
        THEN
            --[PJ2024-50461] Team Mapping------------------------------------
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1 FROM SCM_MGR.GT_DM35_SITE_ITEM B
                WHERE A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
                AND EXISTS (
                    SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL) IS NOT NULL) C
                    WHERE B.DEPT_ID = C.TOKEN
                )
            );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E54--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF P_END_CUSTOMER <> 'ALL'
        THEN
            IF P_DIVISION_ID = '40'
            THEN
                DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
                WHERE NOT EXISTS (
                    SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL) C
                    WHERE A.PROJECT_CODE = C.TOKEN
                );
            ELSE
                DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
                WHERE NOT EXISTS (
                    SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                    WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
                    AND EXISTS (
                        SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL) C
                        WHERE B.END_CUSTOMER = C.TOKEN
                    )
                );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E55--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

            END IF;
        END IF;

        IF P_SCM_SITE_ID <> 'ALL'
        THEN
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL) C
                WHERE A.SCM_SITE_ID = C.TOKEN
            );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E56--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF P_PLANT_SITE_ID <> 'ALL'
        THEN
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL) C
                WHERE A.PLANT_SITE_ID = C.TOKEN
            );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E57--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF P_ITEM_TYPE <> 'ALL'
        THEN
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1 FROM SCM_MGR.GT_DM35_ITEM_SINGLE_V B
                WHERE B.ITEM_ID = A.ITEM_ID
                AND EXISTS (
                    SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL) C
                    WHERE B.ITEM_TYPE = C.TOKEN
                )
            );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E58--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF P_BIZ_TYPE <> 'ALL'
        THEN
            IF P_DIVISION_ID = '40'
            THEN
                DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
                WHERE NOT EXISTS (
                    SELECT 1 FROM SCM_MGR.GT_DM35_ITEM_SINGLE_V B
                    WHERE B.ITEM_ID = A.ITEM_ID
                    AND EXISTS (
                        SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL) C
                        WHERE B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
                    )
                );
            ELSE
                DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
                WHERE NOT EXISTS (
                    SELECT 1 FROM SCM_MGR.SCM_MST_PROJECT B
                    WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
                    AND EXISTS (
                        SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL) C
                        WHERE B.BIZ_TYPE LIKE '%' || C.TOKEN || '%'
                    )
                );
            END IF;

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E59--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

        IF P_SENDER_CODE <> 'ALL'
        THEN
            DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE NOT EXISTS (
                SELECT 1 FROM (SELECT TRIM(REGEXP_SUBSTR(P_SENDER_CODE, '[^,]+', 1, LEVEL)) AS TOKEN FROM DUAL CONNECT BY REGEXP_SUBSTR(P_SENDER_CODE, '[^,]+', 1, LEVEL) IS NOT NULL) C
                WHERE A.SENDER_CODE = C.TOKEN
            );

            N_LOG_COUNT   := SQL%ROWCOUNT;
            V_LOG_TYPE    := 'INFO';
            V_LOG_MESSAGE := 'E591--DELETE GT_DM35_RAW_DATA';
            D_EVENT_DATE  := SYSDATE;
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        END IF;

    END; -- 필터링 끝

    --select * from GT_DM35_RAW_DATA;return;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'E6--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- 계획구간 PRICE 처리

    SELECT COUNT(1) INTO V_EXISTS_CNT FROM SCM_MGR.GT_DM35_SEL_MEASURE WHERE MEASURE = 'LOC';
    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
           , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME)
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, C.MEASURE, 'MKT_FCST_RP' AS MEASURE_GROUP, A.YYYYMMDD, C.PRICE, 'P', 9
             , A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
        FROM (
            SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
                 , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
            FROM SCM_MGR.GT_DM35_RAW_DATA A
            WHERE A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN V_NOW_YYYYMMDD
                                     ELSE TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                END
            AND   A.YYYYMMDD <= P_TO_YYYYMMDD
            AND   A.MEASURE IN ('RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP')
        ) A
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
        JOIN SCM_MGR.SCM_MST_FUTURE_PRICE C
          ON A.DIVISION_ID   = C.DIVISION_ID
         AND A.PROJECT_CODE  = C.PROJECT_CODE
         AND A.SCM_SITE_ID   = C.SCM_SITE_ID
         AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
         AND A.ITEM_ID       = C.ITEM_ID
         AND A.INCOTERMS     = C.INCOTERMS
         AND A.DOM_EXP       = C.DOM_EXP
         AND A.FCST_TYPE     = C.FCST_TYPE
         AND B.BASIS_START_DATE = C.YYYYMMDD
         AND C.YYYYMMDD      <= P_TO_YYYYMMDD
        JOIN SCM_MGR.GT_DM35_SEL_MEASURE D ON C.MEASURE = D.MEASURE;

        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E61--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    END IF;



    -- MKT_FCST_RP 관련 파생 메저 INSERT

    SELECT COUNT(1) INTO V_EXISTS_CNT
    FROM SCM_MGR.GT_DM35_SEL_MEASURE
    WHERE MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY');

    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
           , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, B.MEASURE_CALC, A.MEASURE_GROUP, A.YYYYMMDD
             , CASE WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
                        CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY / D.CELL_PER_CAR
                             WHEN INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN A.QTY / (D.CELL_PER_CAR / D.CELL_PER_MODULE)
                             WHEN INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0 THEN A.QTY
                             ELSE 0
                        END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
                        CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
                             WHEN (INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
                             ELSE 0
                        END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
                    -- 20211119 ROSIA27 [C20211103-000146] [ESS영업관리팀] GSCM 용량 Measure 값 생성 요청의 건
                    WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
                        CASE WHEN REGEXP_LIKE(C.ENERGE, '^[0-9.]+$')
                             THEN (TO_NUMBER(C.ENERGE) * A.QTY) / 1000
                        END
                    -- 20221214 rosia27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
                    WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' THEN
                        CASE WHEN REGEXP_LIKE(C.ENERGE, '^[0-9.]+$')
                             THEN (TO_NUMBER(C.ENERGE) * A.QTY) / 1000
                        END
                    ELSE 0
               END
             , A.PLAN_RESULT, 7
             , A.CREATE_DATE
             , A.LAST_UPDATED_BY
             , A.SENDER_CODE
             , A.SENDER_NAME
             , A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_RAW_DATA A
        JOIN (
            SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP' ELSE 'RTF_SYS_RP' END AS MEASURE_ORI
                 , A.MEASURE AS MEASURE_CALC
            FROM SCM_MGR.GT_DM35_SEL_MEASURE A
            WHERE MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY')
        ) B ON A.MEASURE = B.MEASURE_ORI
        JOIN SCM_MGR.GT_DM35_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
        LEFT OUTER JOIN SCM_MGR.GT_DM35_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
        WHERE A.MEASURE IN ('MKT_FCST_RP', 'RTF_SYS_RP');

        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'E62--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    END IF;

    
    --select * from GT_DM35_RAW_DATA;return;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'F--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    -- 20221214 rosia27 [C20221207-000080] [ESS영업관리팀] GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy

    SELECT COUNT(1) INTO V_EXISTS_CNT
    FROM SCM_MGR.GT_DM35_SEL_MEASURE
    WHERE MEASURE IN ('MKT_FCST_ENERGY');

    IF V_EXISTS_CNT > 0 THEN
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA
            (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
           , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
           , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
             , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, B.MEASURE_CALC, A.MEASURE_GROUP, A.YYYYMMDD
             , CASE WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND A.PLAN_RESULT = 'P' THEN
                        CASE WHEN REGEXP_LIKE(C.ENERGE, '^[0-9.]+$')
                             THEN (TO_NUMBER(C.ENERGE) * A.QTY) / 1000
                        END
                    ELSE 0
               END
             , A.PLAN_RESULT, 8
             , A.CREATE_DATE
             , A.LAST_UPDATED_BY
             , A.SENDER_CODE
             , A.SENDER_NAME
             , A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_RAW_DATA A
        JOIN (
            SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC
            FROM SCM_MGR.GT_DM35_SEL_MEASURE A
            WHERE MEASURE IN ('MKT_FCST_ENERGY')
        ) B ON A.MEASURE = B.MEASURE_ORI
        JOIN SCM_MGR.GT_DM35_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
        WHERE A.MEASURE IN ('MKT_FCST_RP');

        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'INFO';
        V_LOG_MESSAGE := 'F1--GT_DM35_RAW_DATA';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    END IF;


    --select * from GT_DM35_RAW_DATA;return;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'F6--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    --불필요한 메저 삭제
    DELETE FROM SCM_MGR.GT_DM35_RAW_DATA A
    WHERE EXISTS (SELECT 1 FROM SCM_MGR.GT_DM35_SEL_MEASURE B WHERE A.MEASURE = B.MEASURE AND B.SYSTEM_ADD = 'Y');


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'G1--DELETE GT_DM35_RAW_DATA';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    ------------------------------------------------------------------------------------------
    --  [개발요청] 수요분석시스템_4_고객수요 Measure 통합 (20231207)
    --  [E20241030-000923] CUST_FCST 데이터를 생성하기 때문에, 만들어 줄 필요가 없음. START
    /*
    IF EXISTS (SELECT 1 FROM GT_DM35_RAW_DATA WHERE MEASURE IN ('CUST_FCST_EDI','CUST_FCST_EDI_ORG')) BEGIN
        INSERT INTO GT_DM35_RAW_DATA ... 주석처리됨
    END
    */
    --[E20241030-000923] END
    ------------------------------------------------------------------------------------------
    --  컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
    ------------------------------------------------------------------------------------------

    -- 컬럼리스트 생성
    V_PV_LIST     := '';
    V_PV_COL_LIST := '';
    V_PV_COL      := '';

    FOR R_BUCKET IN C_BUCKET LOOP
        V_PV_COL_LIST := V_PV_COL_LIST || CASE WHEN V_PV_COL_LIST IS NOT NULL AND LENGTH(V_PV_COL_LIST) > 0 THEN ',' ELSE '' END || R_BUCKET.COLUMN_NAME;
        V_PV_LIST     := V_PV_LIST     || CASE WHEN V_PV_LIST     IS NOT NULL AND LENGTH(V_PV_LIST)     > 0 THEN ',' ELSE '' END || R_BUCKET.PV_NAME;
        V_PV_COL      := V_PV_COL      || CASE WHEN V_PV_COL      IS NOT NULL AND LENGTH(V_PV_COL)      > 0 THEN ',' ELSE '' END || 'NVL(' || R_BUCKET.PV_NAME || ', 0) AS ' || R_BUCKET.PV_NAME;
    END LOOP;

    /* 20240518 KCW3408 속도개선_템프사용 */
    INSERT INTO SCM_MGR.GT_DM35_TEMP_SCM_SITE
          (SCM_SITE_ID, DIVISION_ID, PROJECT_CODE, ITEM_ID, DEPT_ID
         , SOLDTO_CODE, VMI_YN, END_CUSTOMER, SOLDTO_CUSTOMER
         , CITY_NAME, COUNTRY_NAME, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION
          )
    SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.PROJECT_CODE, B.ITEM_ID, B.DEPT_ID
         , K.SOLDTO_CODE, B.VMI_YN, B.END_CUSTOMER, B.SOLDTO_CUSTOMER
         , H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION
    FROM (SELECT A.DIVISION_ID, B.PROJECT_CODE, A.SCM_SITE_ID, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.SOLDTO_CUSTOMER, A.CITY, A.COUNTRY
              FROM SCM_MGR.SCM_MST_SITE A
                   LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                        ON A.DIVISION_ID = B.DIVISION_ID 
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID 
             WHERE 1=1
             GROUP BY A.DIVISION_ID, B.PROJECT_CODE, A.SCM_SITE_ID, B.ITEM_ID, B.DEPT_ID, A.END_CUSTOMER, A.VMI_YN, A.SOLDTO_CUSTOMER, A.CITY, A.COUNTRY
            ) B    
    LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER K
               ON B.DIVISION_ID = K.DIVISION_ID
              AND B.SCM_SITE_ID = K.SCM_SITE_ID
              AND K.REP_YN      = 'Y'
    LEFT OUTER JOIN SCM_MGR.SCM_MST_CITY H ON B.CITY = H.CITY
    LEFT OUTER JOIN SCM_MGR.SCM_MST_COUNTRY J ON B.COUNTRY = J.COUNTRY
    LEFT OUTER JOIN SCM_MGR.SCM_MST_CUSTOMER L
               ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE;


    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'G1--GT_DM35_TEMP_SCM_SITE';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_TEMP_SCM_SITE', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_TEMP_SCM_SITE', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    SELECT COUNT(1)
    INTO   N_LOG_COUNT
    FROM   GT_DM35_RAW_DATA
    ;
    
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'G2--GT_DM35_RAW_DATA COUNT';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    ----- 일반 컬럼 -----------------------------------------------------------------------------------------------------------
    --V_COLUMN_NAME := '';
    --V_COLUMN      := '';
    --V_ORDERBY     := '';
    V_COL_LIST    := '';
    V_ORDER_LIST  := '';

    SELECT COUNT(*) INTO V_I_COUNT
    FROM SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE U.PROGRAM_ID                    = V_P_PROGRAM_ID
    AND   U.SHEET_NAME                    = V_P_SHEET_NAME
    AND   U.USER_ID                       = P_CREATED_BY
    AND   U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

    IF V_I_COUNT = 0
    THEN
        SELECT LISTAGG(' ' || COLUMN_NAME || ',', '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
             , LISTAGG(' ' || COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE || ',', '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
        INTO   V_COL_LIST, V_ORDER_LIST
        FROM (
            SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE
            FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
            WHERE C.PROGRAM_ID = V_P_PROGRAM_ID
            AND   C.SHEET_NAME = V_P_SHEET_NAME
            AND   (C.DEFAULT_FLAG = 'Y'
                OR (C.VISIBLE_FLAG = '' AND C.DEFAULT_FLAG = 'Y' AND C.VALID_YN = 'Y'))
        ) TBCOLLIST;
    ELSE
        SELECT LISTAGG(' ' || COLUMN_NAME || ',', '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
             , LISTAGG(' ' || COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE || ',', '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
        INTO   V_COL_LIST, V_ORDER_LIST
        FROM (
            SELECT CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(TU.SORT_ORDER_NO, 95) - 0.5 ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
                 , C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
            FROM SCM_MGR.SCM_MST_TITLESET_USER U
            INNER JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS C
                    ON U.PROGRAM_ID  = C.PROGRAM_ID
                   AND U.SHEET_NAME  = C.SHEET_NAME
                   AND U.COLUMN_NAME = C.COLUMN_NAME
                   AND U.PROGRAM_ID  = V_P_PROGRAM_ID
                   AND U.SHEET_NAME  = V_P_SHEET_NAME
                   AND U.USER_ID     = P_CREATED_BY
                   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                   AND U.COLUMN_NAME NOT IN ('MEASURE','VERSION_NO')
            LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER TU
                         ON TU.PROGRAM_ID  = C.PROGRAM_ID
                        AND TU.SHEET_NAME  = C.SHEET_NAME
                        AND TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                        AND TU.COLUMN_NAME IN ('ITEM_ID')
                        AND TU.USER_ID     = P_CREATED_BY
            UNION ALL
            SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
            FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
            WHERE C.PROGRAM_ID   = V_P_PROGRAM_ID
            AND   C.SHEET_NAME   = V_P_SHEET_NAME
            AND   C.VISIBLE_FLAG = ''
            AND   C.DEFAULT_FLAG = 'Y'
            AND   C.VALID_YN     = 'Y'
            AND   ROWNUM         <= 100
        ) TBCOLLIST;
    END IF;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'G3--V_COL_LIST,V_ORDER_LIST';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;


    -- 마지막 콤마 제거
    V_COL_LIST   := RTRIM(V_COL_LIST, ',');
    V_ORDER_LIST := RTRIM(V_ORDER_LIST, ',');

    --[E20231128-000738] 해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
    V_COL_LIST   := V_COL_LIST || ',NOTATION';

    V_COL_LIST   := REPLACE(V_COL_LIST,   'VERSION_NO', 'VERSION_SORT,VERSION_NO');
    V_COL_LIST   := REPLACE(V_COL_LIST,   'MEASURE',    'MEASURE_GROUP,MEASURE,SORT_ORDER_NO');
    V_ORDER_LIST := REPLACE(V_ORDER_LIST, 'VERSION_NO', 'VERSION_SORT DESC,VERSION_NO');
    V_ORDER_LIST := REPLACE(V_ORDER_LIST, 'MEASURE',    'SORT_ORDER_NO');

    -- CTE 에서 사용할 SELECT COLUMN 정리
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('DIVISION_ID', 'A.DIVISION_ID');
    --[PJ2024-50461] Team Mapping------------------------------------
    --INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('DEPT_ID', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('DEPT_ID', 'C.DEPT_ID');
    --[PJ2024-50461] Team Mapping------------------------------------
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('END_CUSTOMER40', 'CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE '' '' END AS END_CUSTOMER40');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('END_CUSTOMER', 'NVL(B.END_CUSTOMER,'' '') AS END_CUSTOMER');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('BIZ_TYPE_NAME', 'G.BIZ_TYPE AS BIZ_TYPE_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('COUNTRY_NAME', 'B.COUNTRY_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CITY_NAME', 'B.CITY_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SCM_SITE_ID', 'A.SCM_SITE_ID');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PROJECT_CODE', 'A.PROJECT_CODE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PROJECT_NAME', 'G.PROJECT_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PROJECT_STATUS', 'G.PROJECT_STATUS');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PROJECT_OWNER', 'G.PROJECT_OWNER');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('GROUP_ID', 'NVL(I.GROUP_ID,'' '') AS GROUP_ID');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('ITEM_ID', 'A.ITEM_ID');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('ITEM_ID40', 'A.ITEM_ID AS ITEM_ID40');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('ITEM_NAME', 'NVL(D.ITEM_NAME, '''') AS ITEM_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('NICK_NAME', 'NVL(D.NICK_NAME, '''') AS NICK_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('INCOTERMS', 'A.INCOTERMS');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('ITEM_TYPE', 'NVL(D.ITEM_TYPE, '''') AS ITEM_TYPE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FCST_TYPE', 'A.FCST_TYPE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('DOM_EXP', 'A.DOM_EXP');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PLANT_SITE_ID', 'A.PLANT_SITE_ID');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('VERSION_NO', 'A.VERSION_NO');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CUST_GROUP', 'C.CUST_GROUP');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CUST_GROUP_DTL', 'C.CUST_GROUP_DTL');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('OWNER', 'C.OWNER_NAME AS OWNER');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('APPLICATION', 'C.APPLICATION');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('ROUTE', 'C.ROUTE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('MIN_CAPACITY', 'D.MIN_CAPACITY');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FORECAST_INFO_CELL_MODEL', 'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC || D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CELL_MODEL_NICK_NAME', 'NVL(F.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('VMI_YN', 'B.VMI_YN');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CELL_TYPE', 'E.SEGMENT2 AS CELL_TYPE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CELL_PER_CAR', 'C.CELL_PER_CAR');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CELL_PER_MODULE', 'C.CELL_PER_MODULE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('MODULE_PER_CAR', 'CASE WHEN C.CELL_PER_MODULE <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('ENERGE', 'D.ENERGE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CELL_QUANTITY', 'D.CELL_QUANTITY');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PRIORITY', 'C.ATTRIBUTE7 AS PRIORITY');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('MEASURE',
        'CASE WHEN A.MEASURE = ''Customer FCST'' THEN ' ||
        '(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA[P+P]'' ELSE ''Cust.FCST_EXCEL[P+P]'' END) ' ||
        'WHEN A.MEASURE = ''Customer FCST[Org.]'' THEN ' ||
        '(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA[Org.]'' ELSE ''Cust.FCST_EXCEL[Org.]'' END) ' ||
        'ELSE A.MEASURE END AS MEASURE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('MEASURE_GROUP', 'M.MEASURE_GROUP');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('DMS_SALES', 'NVL(C.ATTRIBUTE1,'''') AS DMS_SALES');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('DMS_CUSTOMER', 'NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('REPORT_GROUP6', 'C.REPORT_GROUP6');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('TEAM_NAME_KO', 'N.DEPT_NAME_KO AS TEAM_NAME_KO');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('DEPT_NAME_KO', 'O.DEPT_NAME_KO');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('FORECAST_INFO_BIZ_TYPE', 'D.FORECAST_INFO_BIZ_TYPE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('BIZ_TYPE', 'G.BIZ_TYPE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SOLDTO_CUSTOMER', 'B.SOLDTO_CUSTOMER');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SCM_SITE_ID40', 'CASE WHEN A.DIVISION_ID = ''40'' THEN A.SCM_SITE_ID ELSE '''' END AS SCM_SITE_ID40');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SCP_USE_YN',
        'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Req'' THEN ''Y'' ' ||
        'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE IN ( ''MKT_FCST_RP'',''MKT_FCST'' ) THEN ''Y'' ' ||
        'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Plan'' THEN ''Y'' ' ||
        'WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE in (''RTF'',''RTF_SCP'',''RTF_SYS_RP'') THEN ''Y'' ' ||
        'ELSE '''' END AS SCP_USE_YN');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SCP_EXTRA_SPEC', 'D.SCP_EXTRA_SPEC');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SALES_COMPANY', 'C.SALES_COMPANY');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SOLDTO_CODE', 'B.SOLDTO_CODE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('KWH_CELL', 'C.ATTRIBUTE8 AS KWH_CELL');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('KWH_MODULE',
        'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' ' ||
        'THEN TO_NUMBER(C.CELL_PER_MODULE * C.ATTRIBUTE8) ELSE NULL END AS KWH_MODULE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('KWH_PACK',
        'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' ' ||
        'THEN TO_NUMBER(C.CELL_PER_CAR * C.ATTRIBUTE8) ELSE NULL END AS KWH_PACK');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('LAST_UPDATE_DATE', 'A.CREATE_DATE AS LAST_UPDATE_DATE');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('LAST_UPDATED_BY', 'A.LAST_UPDATED_BY AS LAST_UPDATED_BY');
    --[E20241030-000923]_CUST_FCST 메져 추가
    --INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SENDER_CODE', 'CASE WHEN A.MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ...
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SENDER_CODE',
        'CASE WHEN A.MEASURE IN (''CUST_FCST'', ''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''' ||
        ', ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN A.SENDER_CODE ELSE '' '' END AS SENDER_CODE');
    --[E20241030-000923]_CUST_FCST 메져 추가
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('SENDER_NAME',
        'CASE WHEN A.MEASURE IN (''CUST_FCST'', ''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''' ||
        ', ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN A.SENDER_NAME ELSE '' '' END AS SENDER_NAME');
    --[E20231121-000493] 82번사업부_mktFcstWaterfall 화면 내 AS From Site 추가 요청
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('AS_FROM_SITE', 'CASE WHEN A.DIVISION_ID IN ( ''81'', ''82'') THEN A.AS_FROM_SITE ELSE NULL END AS AS_FROM_SITE'); --20230825

    --[E20231017-000634]
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('CELL_NICKNAME',  'A.CELL_NICKNAME AS CELL_NICKNAME');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PRODUCT_LEVEL1', 'A.PRODUCT_LEVEL1 AS PRODUCT_LEVEL1');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PRODUCT_LEVEL2', 'A.PRODUCT_LEVEL2 AS PRODUCT_LEVEL2');
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('PRODUCT_LEVEL3', 'A.PRODUCT_LEVEL3 AS PRODUCT_LEVEL3');
    --[E20231128-000738] 해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
    INSERT INTO SCM_MGR.GT_DM35_T_COLUMN_SETUP (COLUMN_NAME, COLUMN_STRING) VALUES ('NOTATION', 'A.NOTATION AS NOTATION');

    INSERT INTO SCM_MGR.GT_DM35_T (COLUMN_STRING, SEQ)
    SELECT B.COLUMN_STRING, ROW_NUMBER() OVER (ORDER BY B.SORT_KEY) AS SEQ
    FROM (SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(V_COL_LIST,',')) P
          ) A
    JOIN SCM_MGR.GT_DM35_T_COLUMN_SETUP B ON A.TOKEN = B.COLUMN_NAME;

    V_I := 1;
    V_SQL_SELECT  := ' ';
    V_SQL_GROUPBY := ' ';

    SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.GT_DM35_T;

    WHILE V_I <= V_CNT LOOP
        SELECT CASE WHEN V_I = 1 THEN '' ELSE ',' END || COLUMN_STRING
             , CASE WHEN V_I = 1 THEN '' ELSE ',' END ||
               CASE WHEN INSTR(UPPER(COLUMN_STRING), ' AS ') > 0
                    THEN SUBSTR(COLUMN_STRING, 1, INSTR(UPPER(COLUMN_STRING), ' AS ') - 1)
                    ELSE COLUMN_STRING
               END
        INTO V_COLUMN_TEXT, V_COLUMN_VALUE
        FROM SCM_MGR.GT_DM35_T
        WHERE SEQ = V_I;

        V_SQL_SELECT  := V_SQL_SELECT  || V_COLUMN_TEXT || CHR(10);
        V_SQL_GROUPBY := V_SQL_GROUPBY || V_COLUMN_VALUE || CHR(10);

        V_I := V_I + 1;
    END LOOP;
    -- CTE 에서 사용할 SELECT COLUMN 정리

    --select * from GT_DM35_RAW_DATA; return;

    --[E20231017-000634] SCP정보수집
    INSERT INTO SCM_MGR.GT_DM35_SCP_ITEM_INFO
        (DIVISION_ID, ITEM_ID, CELL_NICKNAME, BASIC_NICKNAME_CELL40, NICKNAME_40
       , GROUP_CODE1, GROUP_CODE4, GROUP_CODE5, GROUP_CODE6, GROUP_CODE7, CELL_TYPE_GROUP_NAME)
    SELECT *
    FROM (
        SELECT SCP_P.DIVISION_ID
             , SCP_P.ITEM_ID
             , SCP_P.CELL_NICKNAME
             , SCP_P.BASIC_NICKNAME_CELL40
             , SCP_P.NICKNAME_40
             , SCP_P.GROUP_CODE1
             , SCP_P.GROUP_CODE4
             , SCP_P.GROUP_CODE5
             , SCP_P.GROUP_CODE6
             , SCP_P.GROUP_CODE7
             , CASE WHEN SCP_P.LEVEL_EXCEPT = 'EC' THEN 'POUCH'
                    WHEN SCP_P.LEVEL_EXCEPT = 'AM' THEN 'CYLINDRICAL'
                    WHEN SUBSTR(SCP_P.ITEM_ID, 3, 1) = 'M' AND SCP_P.OPERATION_ID = 'P9500' THEN 'POUCH'
                    ELSE SCP_G.CELL_TYPE_GROUP_NAME END AS CELL_TYPE_GROUP_NAME
        FROM (
            SELECT DIVISION_ID
                 , FLOW_ID                      AS OPERATION_ID
                 , ITEM_ID
                 , SUBSTR(A.ITEM_ID, 3, 1)      AS CELL_TYPE_CODE
                 , SUBSTR(A.ITEM_ID, 1, 2)      AS LEVEL_EXCEPT -- 예외적용
                 , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' THEN GROUP_CODE1
                         WHEN A.DIVISION_ID = '82'               THEN LEVEL2_CODE
                    ELSE '' END AS CELL_NICKNAME
                 , CASE WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'EC' THEN 'ESS'
                        WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AM' THEN 'M50L'
                   ELSE CASE WHEN A.OPERATION_GROUP = 'P' THEN
                                  (SELECT NICK_NAME FROM SCM_MGR.SCP_MST_FINAL_ITEM B
                                   WHERE B.DIVISION_ID = A.DIVISION_ID
                                   --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 원소스 주석처리
                                   --AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL)
                                   AND B.ITEM_ID = (SELECT DOE FROM SCM_MGR.GT_DM35_ITEM_SINGLE_ORI B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL AND ROWNUM = 1))
                              ELSE
                                  (SELECT NICK_NAME FROM SCM_MGR.SCP_MST_FINAL_ITEM B
                                   WHERE B.DIVISION_ID = A.DIVISION_ID
                                   --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 원소스 주석처리
                                   --AND B.ITEM_ID = (SELECT TOP 1 DOE FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)
                                   AND B.ITEM_ID = (SELECT DOE FROM SCM_MGR.GT_DM35_ITEM_SINGLE_ORI B WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL AND ROWNUM = 1))
                        END
                   END AS BASIC_NICKNAME_CELL40
                 , A.NICK_NAME  AS NICKNAME_40
                 , A.GROUP_CODE4, A.GROUP_CODE5, A.GROUP_CODE6, A.GROUP_CODE7, A.GROUP_CODE1
                 , CASE WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C' ELSE 'E' END AS FLOW_TYPE
            FROM SCM_MGR.SCP_MST_FINAL_ITEM A
            WHERE 1=1
            AND (SUBSTR(A.ATTRIBUTE8, 1, 2) <> 'CA' OR NVL(A.ATTRIBUTE8,'@#@#@#') = '@#@#@#' OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
            AND A.DIVISION_ID = P_DIVISION_ID
            AND ((P_ITEM_ID IS NULL OR NVL(P_ITEM_ID,'@#@#@#') = '@#@#@#') OR A.ITEM_ID IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL))
        ) SCP_P
        LEFT OUTER JOIN (
            SELECT A.SEGMENT1 AS CELL_TYPE_CODE
                 , SUBSTR(A.SEGMENT2, 1, 1) AS FLOW_TYPE  -- 실제 FLOW_TYPE은 NAME 첫 글자
                 , A.SEGMENT3 AS CELL_TYPE_GROUP_CODE
                 , G.SEGMENT2 AS CELL_TYPE_GROUP_NAME
                 , A.DISPLAY_SEQ
            FROM (
                SELECT B.SEGMENT1, B.SEGMENT2, B.SEGMENT3, B.DISPLAY_SEQ
                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER A
                JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
                WHERE A.LOOKUP_TYPE = 'CELL_TYPE_ITEM_CODE' AND A.VALID_YN = 'Y'
            ) A
            JOIN (
                SELECT B.SEGMENT1, B.SEGMENT2
                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER A2
                JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B ON A2.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'
                WHERE A2.LOOKUP_TYPE = 'CELL_TYPE_ITEM_GROUP' AND A2.VALID_YN = 'Y'
            ) G ON A.SEGMENT3 = G.SEGMENT1
        ) SCP_G ON SCP_G.FLOW_TYPE = SCP_P.FLOW_TYPE AND SCP_G.CELL_TYPE_CODE = SCP_P.CELL_TYPE_CODE
    ) T;

    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_SCP_ITEM_INFO', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_SCP_ITEM_INFO', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    /* (DM + SCP) */
    INSERT INTO SCM_MGR.GT_DM35_RAW_DATA_FINAL (
        VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
      , PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP
      , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN
      , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME
      , PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
      , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
    )
    SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
         , A.PLANT_SITE_ID
         , A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.MEASURE_GROUP
         , A.YYYYMMDD, A.QTY, A.VALID_YN, A.PLAN_RESULT, A.GUBUN
         , A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME, A.AS_FROM_SITE
         , B.CELL_NICKNAME /* SUBSTR(A.DIVISION_ID,1,2)='81' (GROUP_CODE1) 82 ESS (LEVEL2_CODE) 40 소형 ('') */
         , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' OR A.DIVISION_ID = '82' THEN B.GROUP_CODE6
                ELSE B.CELL_TYPE_GROUP_NAME END AS PRODUCT_LEVEL1
         , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' OR A.DIVISION_ID = '82' THEN B.GROUP_CODE7
                ELSE B.BASIC_NICKNAME_CELL40 END AS PRODUCT_LEVEL2
         , CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' THEN B.GROUP_CODE5
                WHEN A.DIVISION_ID = '82'              THEN B.GROUP_CODE4
                ELSE B.NICKNAME_40 END AS PRODUCT_LEVEL3
         , NVL(C.SEGMENT3, 'DEFAULT') AS NOTATION
         , A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
    FROM SCM_MGR.GT_DM35_RAW_DATA A
    LEFT OUTER JOIN SCM_MGR.GT_DM35_SCP_ITEM_INFO B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
    LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C ON C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION' AND A.MEASURE = C.SEGMENT2 AND A.DIVISION_ID = C.SEGMENT1
    WHERE 1=1;

    DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_RAW_DATA_FINAL', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
    DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_RAW_DATA_FINAL', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

    --[E20240102-000545]_[마케팅PI] 82번 사업부 - VMI표기 로직 개선  START

    DBMS_OUTPUT.PUT_LINE('VMIINV--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

    IF P_DIVISION_ID = '82'
    THEN
        IF P_VERSION_NO LIKE '%CURRENT%'
        THEN

            --1). 해당 PERIOD 기간내의 VMI_INV, MKT_FCST, VMI_In_Plan, VMI_In_Req가 존재하는 데이터를 우선 구해서 GTT에 넣어둔다.
            INSERT INTO SCM_MGR.GT_DM35_TEMP_VMI_INV
            (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CELL_PROD_SITE_ID)
            SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.YYYYMMDD, B.PLANT_SITE_ID, B.QTY
                 , B.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            FROM (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                     , RANK() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, CELL_PROD_SITE_ID ORDER BY YYYYMMDD DESC) AS SEQ -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                FROM (
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                         , '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                    FROM DM_PLN_MKT_FCST
                    WHERE DIVISION_ID = P_DIVISION_ID
                    AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
                    AND QTY <> 0
                    AND YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                    UNION ALL
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                         , CELL_PROD_SITE_ID -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
                    FROM DM_PLN_MKT_FCST_RESULT
                    WHERE DIVISION_ID = P_DIVISION_ID
                    AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
                    AND QTY <> 0
                    AND YYYYMMDD >= p_from_yyyymmdd
                    AND YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') --RESULT 데이터를 참고하는 경우에는 당주 월요일 이전 데이터를 가져와야된다.
                ) A
            ) B
            WHERE SEQ = 1;
        ELSE
          
            INSERT INTO SCM_MGR.GT_DM35_TEMP_VMI_INV
            (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CELL_PROD_SITE_ID)
            SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.YYYYMMDD, B.PLANT_SITE_ID, B.QTY
                 , B.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            FROM (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                     , RANK() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE ORDER BY YYYYMMDD DESC) AS SEQ
                     , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                FROM (
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                         , '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                    FROM DM_PLN_MKT_FCST_C
                    WHERE DIVISION_ID = P_DIVISION_ID
                    AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
                    AND QTY <> 0
                    AND YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                    UNION ALL
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                         , '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                    FROM DM_PLN_MKT_FCST_RESULT_C
                    WHERE DIVISION_ID = P_DIVISION_ID
                    AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
                    AND QTY <> 0
                    AND YYYYMMDD >= P_FROM_YYYYMMDD
                    AND YYYYMMDD <  TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') --RESULT 데이터를 참고하는 경우에는 당주 월요일 이전 데이터를 가져와야된다.
                ) A
            ) B
            WHERE SEQ = 1;

        END IF; -- P_VERSION_NO LIKE '%CURRENT%' 내부

    		--2). 아이템둘 중, 'VMI_INV'메져의 YYYYMMDD보다 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req'메져는 대상정보에서 삭제한다. 

        DELETE FROM SCM_MGR.GT_DM35_TEMP_VMI_INV C
        WHERE EXISTS (
                SELECT 1
                FROM (
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                         , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                    FROM SCM_MGR.GT_DM35_TEMP_VMI_INV
                    WHERE MEASURE = 'VMI_INV'
                    ) A
                    JOIN (
                        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
                             , CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                        FROM SCM_MGR.GT_DM35_TEMP_VMI_INV
                        WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
                    ) B
                    ON  A.DIVISION_ID        = B.DIVISION_ID
                    AND A.PROJECT_CODE       = B.PROJECT_CODE
                    AND A.SCM_SITE_ID        = B.SCM_SITE_ID
                    AND A.ITEM_ID            = B.ITEM_ID
                    AND A.DOM_EXP            = B.DOM_EXP
                    AND A.FCST_TYPE          = B.FCST_TYPE
                    AND A.INCOTERMS          = B.INCOTERMS
                    AND A.PLANT_SITE_ID      = B.PLANT_SITE_ID
                    AND B.YYYYMMDD           >= A.YYYYMMDD + 1
                    AND A.CELL_PROD_SITE_ID  = B.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                WHERE C.DIVISION_ID        = A.DIVISION_ID
                AND   C.PROJECT_CODE       = A.PROJECT_CODE
                AND   C.SCM_SITE_ID        = A.SCM_SITE_ID
                AND   C.ITEM_ID            = A.ITEM_ID
                AND   C.DOM_EXP            = A.DOM_EXP
                AND   C.FCST_TYPE          = A.FCST_TYPE
                AND   C.INCOTERMS          = A.INCOTERMS
                AND   C.PLANT_SITE_ID      = A.PLANT_SITE_ID
                AND   C.CELL_PROD_SITE_ID  = A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        );


        --3). 'VMI_INV' 메져 외의 타 데이터는 모두 삭제한다. 
        DELETE
        FROM   SCM_MGR.GT_DM35_TEMP_VMI_INV
        WHERE  MEASURE IN ('MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req');



        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_TEMP_VMI_INV', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_TEMP_VMI_INV', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

		    --4). 들어가있는 데이터와 형식을 동일하게 맞추기위해서, 데이터 형식을 맞춰주는 작업을 진행한다.
        INSERT INTO SCM_MGR.GT_DM35_VMI_INV_RESULT
              (VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE
           , MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, AS_FROM_SITE
           , CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
           , CELL_PROD_SITE_ID)
        SELECT B.VERSION_NO, B.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE
           , B.MEASURE_GROUP, A.YYYYMMDD, A.QTY, B.VALID_YN, B.PLAN_RESULT, B.GUBUN, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.AS_FROM_SITE
           , B.CELL_NICKNAME, B.PRODUCT_LEVEL1, B.PRODUCT_LEVEL2, B.PRODUCT_LEVEL3, B.NOTATION
           , B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_TEMP_VMI_INV A
             INNER JOIN SCM_MGR.GT_DM35_RAW_DATA_FINAL B 
                ON A.DIVISION_ID    = B.DIVISION_ID
               AND A.PROJECT_CODE   = B.PROJECT_CODE
               AND A.SCM_SITE_ID    = B.SCM_SITE_ID
               AND A.ITEM_ID      = B.ITEM_ID
               AND A.DOM_EXP      = B.DOM_EXP
               AND A.FCST_TYPE    = B.FCST_TYPE
               AND A.INCOTERMS    = B.INCOTERMS
               AND A.MEASURE      = B.MEASURE
               AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID
               AND A.YYYYMMDD     = B.YYYYMMDD
               AND A.CELL_PROD_SITE_ID= B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
         ;

        --5). PERIOD 기간만큼 데이터를 생성한다. 
        INSERT INTO SCM_MGR.GT_DM35_VMI_INV_RESULT
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
            , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
            , SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION 
            , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            )
        SELECT DISTINCT B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE
           , B.MEASURE, B.MEASURE_GROUP, A.BASIS_YYYYMMDD, B.QTY, B.VALID_YN, B.PLAN_RESULT, B.GUBUN, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE
           , B.SENDER_NAME, B.AS_FROM_SITE, B.CELL_NICKNAME, B.PRODUCT_LEVEL1, B.PRODUCT_LEVEL2, B.PRODUCT_LEVEL3, B.NOTATION
           , B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_SYS_CALENDAR_M A
              LEFT OUTER JOIN SCM_MGR.GT_DM35_VMI_INV_RESULT B 
                     ON A.BASIS_YYYYMMDD  > B.YYYYMMDD  
        WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
        AND A.BASIS_YYYYMMDD > B.YYYYMMDD 
        ;
        
        --모수로 잡았던 데이터는 삭제한다.
        DELETE FROM SCM_MGR.GT_DM35_VMI_INV_RESULT A
        WHERE  A.DIVISION_ID = '82'
        AND    A.MEASURE = 'VMI_INV'
        AND EXISTS ( SELECT DIVISION_ID 
                     FROM   SCM_MGR.GT_DM35_TEMP_VMI_INV Z
                     WHERE  1=1
                     AND    A.DIVISION_ID    = Z.DIVISION_ID      
                     AND    A.PROJECT_CODE   = Z.PROJECT_CODE   
                     AND    A.SCM_SITE_ID    = Z.SCM_SITE_ID  
                     AND    A.ITEM_ID        = Z.ITEM_ID      
                     AND    A.DOM_EXP        = Z.DOM_EXP      
                     AND    A.FCST_TYPE      = Z.FCST_TYPE    
                     AND    A.INCOTERMS      = Z.INCOTERMS    
                     AND    A.PLANT_SITE_ID  = Z.PLANT_SITE_ID
                     AND    A.YYYYMMDD       = Z.YYYYMMDD
                     AND    A.CELL_PROD_SITE_ID = Z.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
                     );


        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_VMI_INV_RESULT', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_VMI_INV_RESULT', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');

        --6). 임시로 만든 데이터를, 주 임시테이블에 INSERT 한다.  
        INSERT INTO SCM_MGR.GT_DM35_RAW_DATA_FINAL
        (  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
         , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
         , SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
         , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
         )
        SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
           , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
             , SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
           , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
        FROM SCM_MGR.GT_DM35_VMI_INV_RESULT
        ;

            
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_DM35_RAW_DATA_FINAL', 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
        DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'GT_DM35_RAW_DATA_FINAL', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, method_opt => 'FOR ALL COLUMNS SIZE 1');
        

    END IF; -- P_DIVISION_ID = '82'

    --[E20240102-000545]_[마케팅PI] 82번 사업부 - VMI표기 로직 개선  END

    /* @v_sql_text 안쪽데이타 빼냄 */
    INSERT INTO SCM_MGR.GT_DM35_CALENDAR (BASIS_YYYYMMWW, ISO_YYYYWW, ISO_WEEK, BASIS_YYYYMMDD, END_FLAG, BASIS_YYYYMM)
    SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM
    FROM (
        SELECT SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW, ISO_WEEK
        FROM SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
        AND   BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        GROUP BY ISO_YYYYWW, ISO_WEEK
    ) A
    JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.ISO_YYYYWW = B.ISO_YYYYWW AND A.ISO_WEEK = B.ISO_WEEK;

    INSERT INTO SCM_MGR.GT_DM35_CAL_MONTH_END (MONTH_END_DATE)
    SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP BY BASIS_YYYYMM;

    INSERT INTO SCM_MGR.GT_DM35_CAL_WEEK_END (WEEK_END_DATE)
    SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
    GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'H--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    --[E20230906-000992] ENERGY MEASURE에 한해 표기형식변경 (MKT FCST 화면값과 일치화)
    V_SQL_TEXT := ' WITH T_WF_DATA AS (' ||
        CHR(10) || 'SELECT CASE WHEN A.MEASURE IN (''RTF_ENERGY'', ''MKT_FCST_ENERGY'') THEN ' ||
        CHR(10) || '   CAST(CASE WHEN ''' || P_CELL_YN || ''' = ''Y'' AND A.MEASURE_GROUP NOT IN ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) AND NVL(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1 THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END AS NUMBER(30,10)) ' ||
        CHR(10) || '   ELSE ' ||
        CHR(10) || '   CAST(CASE WHEN ''' || P_CELL_YN || ''' = ''Y'' AND A.MEASURE_GROUP NOT IN ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) AND NVL(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1 THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END AS NUMBER(19,0)) ' ||
        CHR(10) || '   END AS QTY ' ||
        CHR(10) || ' , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD ' ||
        CHR(10) || ' , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW ' ||
        CHR(10) || ' , M.SORT_ORDER_NO ' ||
        CHR(10) || ' , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE '''' END AS MONTH_END_YN ' ||
        CHR(10) || ' , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE '''' END AS WEEK_END_YN ' ||
        CHR(10) || ' , C.PROJECT_S_OP_REPORT  --[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건 ' ||
        CHR(10) || ' , CASE WHEN LENGTH(NVL(EE.ATTRIBUTE1,'''')) = 0 THEN ''Common'' ELSE EE.ATTRIBUTE1 END AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가 ' ||
        CHR(10) || ' , ' || V_SQL_SELECT ||
        CHR(10) || ' , EDY.EDIT_YN ' ||
        CHR(10) || ' FROM SCM_MGR.GT_DM35_RAW_DATA_FINAL A ' ||
        CHR(10) || '      INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY ' ||
        CHR(10) || '           ON EDY.USER_ID = ''' || P_USER_ID || '''' ||
        CHR(10) || '          AND EDY.MNU_ID  = ''' || P_MENU_ID || '''' ||
        CHR(10) || '          AND EDY.UNIT_ID = A.DIVISION_ID ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM35_TEMP_SCM_SITE B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM35_SITE_ITEM C ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM35_ITEM_SINGLE_V D ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL E ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE'' ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM35_ITEM_SINGLE_V F ON D.DIVISION_ID = F.DIVISION_ID AND NVL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.SCM_MST_PROJECT G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.SCP_MST_ITEM_GROUP_DETAIL I ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID ' ||
        CHR(10) || ' JOIN SCM_MGR.GT_DM35_SEL_MEASURE M ON A.MEASURE = M.MEASURE ' ||
        CHR(10) || ' --[PJ2024-50461] Team Mapping------------------------------------ ' ||
        CHR(10) || ' --LEFT OUTER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO N ON CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END = N.DEPT_ID ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO N ON C.DEPT_ID = N.DEPT_ID ' ||
        CHR(10) || ' --[PJ2024-50461] Team Mapping------------------------------------ ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO O ON N.UPPER_DEPT_ID = O.DEPT_ID ' ||
        CHR(10) || ' JOIN SCM_MGR.GT_DM35_CALENDAR CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM35_CAL_MONTH_END C2 ON A.YYYYMMDD = C2.MONTH_END_DATE ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.GT_DM35_CAL_WEEK_END C3 ON A.YYYYMMDD = C3.WEEK_END_DATE ' ||
        CHR(10) || ' LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL EE ' ||
        CHR(10) || ' ON EE.LOOKUP_TYPE = ''SP_CELL_PROD_SITE'' ' ||
        CHR(10) || ' AND EE.SEGMENT1 = CASE WHEN LENGTH(NVL(A.CELL_PROD_SITE_ID,'''')) = 0 THEN ''-'' ELSE A.CELL_PROD_SITE_ID END -- [PJ2025-50017] CELL_PROD_SITE_ID 추가 ' ||
        CHR(10) || ' AND EE.SEGMENT2 = ''-'' AND EE.SEGMENT3 = ''-'' AND EE.SEGMENT4 = ''-'' AND EE.SEGMENT5 = ''-'' AND EE.VALID_YN = ''Y'' ' ||
        CHR(10) || ' )'
        ;

    -- Oracle에서는 MSSQL의 SELECT ... INTO #WF 를 Dynamic SQL 내부에서 처리할 수 없으므로
    -- #WF 해당하는 집계 결과를 직접 PIVOT 쿼리로 구성하여 O_RC1 커서로 반환한다.
    -- (Oracle에는 PIVOT 구문이 있으나 동적 컬럼은 Dynamic SQL로 처리)

    -- Dynamic SQL 최종 구성 (PIVOT 포함)
    IF P_DIVISION_ID = '40'
    THEN
        V_SQL_TEXT := V_SQL_TEXT ||
            ' SELECT ' || V_COL_LIST || ', EDIT_YN, ' || V_PV_COL ||
            CHR(10) || ' FROM ( ';
    ELSE
        V_SQL_TEXT := V_SQL_TEXT ||
            ' SELECT ' || V_COL_LIST || ', EDIT_YN, ' || V_PV_LIST ||
            CHR(10) || ' FROM ( ';
    END IF;

    IF P_BUCKET = 'DAILY'
    THEN
        V_SQL_TEXT := V_SQL_TEXT ||
            CHR(10) || ' SELECT ' || V_COL_LIST || ', ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY, F.EDIT_YN ' ||
            CHR(10) || ' FROM   T_WF_DATA F ' ||
            CHR(10) || ' WHERE F.QTY <> 0 ' ||
            CHR(10) || ' UNION ALL ';
    END IF;

    IF P_BUCKET != 'ONLY_WEEKLY'
    THEN
        V_SQL_TEXT := V_SQL_TEXT ||
            CHR(10) || ' SELECT ' || V_COL_LIST || ', YYYYMMDD , SUM(QTY) AS QTY , EDIT_YN' ||
            CHR(10) || ' FROM   ( ' ||
            CHR(10) || ' SELECT ' || V_COL_LIST || ', ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD, F.EDIT_YN ' ||
            CHR(10) || '     , SUM(CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'') THEN'||
            CHR(10) || '                     CASE WHEN F.WEEK_END_YN = ''Y'' THEN F.QTY ELSE 0 END  ' ||
            CHR(10) || '                WHEN F.MEASURE = ''LOC'' THEN 0 ' ||
            CHR(10) || '                ELSE F.QTY END) + ' ||
            CHR(10) || '       AVG(CASE WHEN F.MEASURE = ''LOC'' THEN F.QTY ELSE 0 END) AS QTY ' ||
            CHR(10) || ' FROM T_WF_DATA F ' ||
            CHR(10) || ' WHERE F.QTY <> 0 ' ||
            CHR(10) || ' GROUP BY ' || V_COL_LIST || ', F.BASIS_YYYYMM, F.ISO_WEEK, F.EDIT_YN ' ||
            CHR(10) || ' UNION ALL ' ||
            CHR(10) || ' SELECT ' || V_COL_LIST || ', ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD, F.EDIT_YN ' ||
            CHR(10) || '     , SUM(CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'') THEN'||
            CHR(10) || '                     CASE WHEN F.MONTH_END_YN = ''Y'' THEN F.QTY ELSE 0 END  ' ||
            CHR(10) || '                WHEN F.MEASURE = ''LOC'' THEN 0 ' ||
            CHR(10) || '                ELSE F.QTY END) + ' ||
            CHR(10) || '       AVG(CASE WHEN F.MEASURE = ''LOC'' THEN F.QTY ELSE 0 END) AS QTY ' ||
            CHR(10) || ' FROM T_WF_DATA F ' ||
            CHR(10) || ' WHERE F.QTY <> 0 ' ||
            CHR(10) || ' GROUP BY ' || V_COL_LIST || ', F.BASIS_YYYYMM, F.EDIT_YN ' ||
            CHR(10) || ' ) GROUP BY ' || V_COL_LIST || ', YYYYMMDD, EDIT_YN ';
    ELSIF P_BUCKET = 'ONLY_WEEKLY'
    THEN
        V_SQL_TEXT := V_SQL_TEXT ||
            CHR(10) || ' SELECT ' || V_COL_LIST || ', YYYYMMDD , SUM(QTY) AS QTY, EDIT_YN' ||
            CHR(10) || ' FROM   ( ' ||
            CHR(10) || ' SELECT ' || V_COL_LIST || ', ''W_'' || F.BASIS_YYYYMMWW AS YYYYMMDD, F.EDIT_YN ' ||
            CHR(10) || '     , SUM(CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'') THEN'||
            CHR(10) || '                     CASE WHEN F.WEEK_END_YN = ''Y'' THEN F.QTY ELSE 0 END  ' ||
            CHR(10) || '                WHEN F.MEASURE = ''LOC'' THEN 0 ' ||
            CHR(10) || '                ELSE F.QTY END) + ' ||
            CHR(10) || '       AVG(CASE WHEN F.MEASURE = ''LOC'' THEN F.QTY ELSE 0 END) AS QTY ' ||
            CHR(10) || ' FROM T_WF_DATA F ' ||
            CHR(10) || ' WHERE F.QTY <> 0 ' ||
            CHR(10) || ' GROUP BY ' || V_COL_LIST || ', F.BASIS_YYYYMMWW, F.ISO_WEEK, F.EDIT_YN ' ||
            CHR(10) || ' ) GROUP BY ' || V_COL_LIST || ', YYYYMMDD, EDIT_YN ';
    END IF;

    V_SQL_TEXT := V_SQL_TEXT ||
        CHR(10) || ' ) F ' ||
        CHR(10) || ' PIVOT (SUM(QTY) FOR YYYYMMDD IN (' || V_PV_COL_LIST || ')) PVT ' ||
        CHR(10) || ' ORDER BY ' || V_ORDER_LIST;

    -- Oracle에서 Dynamic SQL은 DBMS_SQL 또는 OPEN RC FOR로 반환
    -- WF_DATA는 GT_DM35_RAW_DATA_FINAL 기반 인라인 뷰로 처리
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'H_p--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- V_SQL_TEXT 내 플레이스홀더 치환 (Oracle: [] 브래킷은 열 별칭에만 사용, 실제 쿼리에서는 제거)
    /*V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_PV_COL_LIST]', V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_PV_LIST]',     V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_column]',      V_SQL_SELECT);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@v_orderby]',     V_ORDER_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@SQL_SELECT]',    V_SQL_SELECT);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@SQL_GROUPBY]',   V_SQL_GROUPBY);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@CellQtyYN]',     P_CELL_YN);*/
    
    DBMS_OUTPUT.ENABLE(1000000);

    DBMS_OUTPUT.PUT_LINE('=============================');
    DBMS_OUTPUT.PUT_LINE('V_PV_LIST : '||V_PV_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_PV_COL_LIST : '||V_PV_COL_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_PV_COL : '||V_PV_COL ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_COL_LIST : '||V_COL_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_ORDER_LIST :'||V_ORDER_LIST ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_SELECT :'||V_SQL_SELECT ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('V_SQL_GROUPBY :'||V_SQL_GROUPBY ||CHR(10)||CHR(10));
    DBMS_OUTPUT.PUT_LINE('=============================');


    DBMS_OUTPUT.PUT_LINE(v_sql_text);

    -- RC1: 메인 결과셋 (Pivot 결과)
    OPEN O_RC1 FOR V_SQL_TEXT;

    -- RC2: 현재 주차/날짜 정보
    OPEN O_RC2 FOR
        SELECT ISO_WEEK, BASIS_DATE
        FROM SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    -- 테스트용 코드
    --OPEN O_RC2 FOR SELECT ISO_WEEK, BASIS_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = '20220725';

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'I--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- 20190711 정렬 관련 추가 (주석처리된 원본 코드)
    /*
    DECLARE V_ORDER VARCHAR2(32767 CHAR) := '';
    --SELECT @ORDER = @ORDER + T1.COLUMN_NAME + ' ' + T1.DATA_SORT_METHOD_CODE + ','
    FROM ....
    */

    /* 2024/05/17   kcw3408   이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
    /*
     kjj 수정(2024.6.24)
     - GROUP_ID 화면표시 위해 [SCM_MST_TITLESET_USER] 조인 추가
     - ITEM_ID의 정렬보다 무조건 바로 앞에 GROUP_ID가 위치하게 
     =>2024.06.25. 불필요한 정렬이므로 위의 정렬 값 그대로 리턴..추후 화면에서도 제거해야 함
    */

    -- 정렬 컬럼 문자열에서 브래킷 제거
    V_ORDER_LIST := REPLACE(V_ORDER_LIST, '[', '');
    V_ORDER_LIST := REPLACE(V_ORDER_LIST, ']', '');

    -- RC3: 정렬 컬럼 정보 반환
    -- (O_RESULT_CURSOR로 성공 반환)
    OPEN O_RC3 FOR
        SELECT V_ORDER_LIST FROM DUAL;

    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'INFO';
    V_LOG_MESSAGE := 'J--';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    COMMIT;

    -- RC3: 정렬 컬럼 정보 반환
    -- (O_RESULT_CURSOR로 성공 반환)
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
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_DEPT_ID'      VALUE P_DEPT_ID,
            'P_END_CUSTOMER' VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'  VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE' VALUE P_PROJECT_CODE,
            'P_ITEM_ID'      VALUE P_ITEM_ID,
            'P_ITEM_TYPE'    VALUE P_ITEM_TYPE,
            'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'  VALUE P_TO_YYYYMMDD,
            'P_CREATED_BY'   VALUE P_CREATED_BY,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_BIZ_TYPE'     VALUE P_BIZ_TYPE,
            'P_OWNER'        VALUE P_OWNER,
            'P_VERSION_NO'   VALUE P_VERSION_NO,
            'P_BUCKET'       VALUE P_BUCKET,
            'P_USER_DEPT_ID' VALUE P_USER_DEPT_ID,
            'P_GROUP_ID'     VALUE P_GROUP_ID,
            'P_CELL_YN'      VALUE P_CELL_YN,
            'P_SENDER_CODE'  VALUE P_SENDER_CODE
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
END P_DMF0035_GET_MKT_FCST_WATERFALL;

END PKG_DMF0035;
/
