-- PKG_DMF0082 — standalone 복원 (DROP 직전 원문 = 생성 시점 DB 재조회본 · SCM_MGR 로 실행)
-- ⚠ STEP 1 백업이 아니라 현재 원문을 쓴다: STEP 2 에서 바뀐 standalone(예: DMF0043_GET_MAIN_SPREAD_TITLE → _CORE 호출)을 옛 본문으로 되돌리면 INVALID
SET DEFINE OFF
-- SOURCE-FRESH: SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI PROCEDURE LAST_DDL=2026-09-15 11:53:24 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_SCM_MST_EXCHANGE_RATE_UI" (
    P_BATCH_YN      IN  VARCHAR2 DEFAULT 'N',
    O_RESULT_CURSOR OUT SYS_REFCURSOR
) AS
    V_ERR        VARCHAR2(200 CHAR);
    V_TARGET_CNT NUMBER;
BEGIN
    --[E20260915-BPSIFNODATA] 반영 대상 0건 안내 (사용자 지시 2026-09-15).
    --  공유 배치 PR_SCM_MST_EXCHANGE_RATE 는 대상이 없어도 오류 없이 끝나 이 래퍼가 항상 success 를 돌려줬고,
    --  화면은 "정상 반영" 토스트 후 값이 그대로여서 반영된 것으로 오인됐다(사내 XIF 0행 실측).
    --  → 배치 CUR_E 와 **동일 조건**으로 대상 건수를 먼저 세고, 0건이면 배치를 호출하지 않고 안내를 돌려준다.
    --  CODE <> '0' 이면 FE(ExchangeRateModal handleBpsIf)가 RESULT_MSG 를 Alert 로 표시한다 — FE 무변경.
    --  공유 배치 본문은 무수정(야간 배치 P_BATCH_YN='Y' 경로 영향 없음).
    IF P_BATCH_YN = 'Y' THEN
        SELECT COUNT(*)
          INTO V_TARGET_CNT
          FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN E
         WHERE NVL(E.TRANSF_FLAG, 'N') = 'N'
           AND E.SCENARIO_TYPE_CD IN ('ML', 'RF');
    ELSE
        SELECT COUNT(*)
          INTO V_TARGET_CNT
          FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN E
         WHERE E.TRANSF_DATE = (SELECT MAX(A.TRANSF_DATE)
                                  FROM SCM_MGR.XIF_GSC_MOVE_EXCHANGE_RATE_SN A
                                 WHERE A.SCENARIO_TYPE_CD IN ('ML', 'RF'))
           AND E.SCENARIO_TYPE_CD IN ('ML', 'RF');
    END IF;

    IF V_TARGET_CNT = 0 THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS CODE, '반영할 환율 정보가 없습니다' AS RESULT_MSG, CAST(NULL AS VARCHAR2(200 CHAR)) AS EVENT FROM DUAL;
        RETURN;
    END IF;

    SCM_MGR.PR_SCM_MST_EXCHANGE_RATE(P_BATCH_YN);
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'success' AS RESULT_MSG, CAST(NULL AS VARCHAR2(200 CHAR)) AS EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        V_ERR := SUBSTR(SQLERRM, 1, 200);
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR
            SELECT '9' AS CODE, 'fail' AS RESULT_MSG, V_ERR AS EVENT FROM DUAL;
END PR_SCM_MST_EXCHANGE_RATE_UI;
/
-- SOURCE-FRESH: SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST PROCEDURE LAST_DDL=2026-09-15 10:50:42 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_DM_PLN_CFM_TO_MKT_FCST" 
(
    p_created_by        IN  VARCHAR2
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
--EXEC PR_DM_PLN_CFM_TO_MKT_FCST '81'
/*=====================================================================================================================================================
 * Program ID   : PR_DM_PLN_CFM_TO_MKT_FCST
 * Description  :
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 2025-01-23	KANG.H.J		[PJ2025-50017] [소형매출동기화] Cell_Prod_Site 기반으로 데이터 생성 - 최초 개발
 * 2025-01-23	KANG.H.J		[PJ2025-50188] [소형매출동기화] 기준수요 반영
 * 2025-05-20	KANG.H.J		[PJ2025-50017] #SEND_TARGET_DATA에 CELL_PROD_SITE_ID 추가
 * 2025-11-04	JSSBAE			[E20251021-000634]_FCST&PRICE MGMT SALES PLAN 데이터 동기화 속도개선
 * 2025-12-29	JSSBAE			[E20251223-000672]_Sales Price 동기화 배치 생성 요청
 * 2026-03-09	JSSBAE			[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선
*===================================================================================================================================================*/
IS
    --=====================================================================================================================================================
    -- LOG 용 변수 설정 (START)
    v_log_type      VARCHAR2(30 CHAR);  -- START/END/ERROR/...
    n_log_count     PLS_INTEGER := 0;
    v_log_message   VARCHAR2(1000 CHAR);
    v_description   VARCHAR2(500 CHAR);
    d_event_date    DATE;
    v_proc_input    VARCHAR2(4000 CHAR);
    v_sql_code      VARCHAR2(20 CHAR);
    v_sql_errmsg    VARCHAR2(2000 CHAR);
    v_backtrace     VARCHAR2(4000 CHAR);
    -- LOG 용 변수 설정 (END)
    --=====================================================================================================================================================

    --=====================================================================================================================================================
    -- 프로시져 사용 변수 설정  (START)
    v_division_id           VARCHAR2(30 CHAR);
    v_created_by            VARCHAR2(100 CHAR);
    --[E20251223-000672]_변수 사용시 규칙에 맞게 변경 원소스 주석처리 후 변수명 변경 (START)
    --DECLARE @plan_start_yyyymmdd			NVARCHAR(8);
    v_plan_start_yyyymmdd   VARCHAR2(8 CHAR);
    --[E20251223-000672]_변수 사용시 규칙에 맞게 변경 원소스 주석처리 후 변수명 변경 (END)

    n_send_count    PLS_INTEGER := 0;
    n_result_count  PLS_INTEGER := 0;
    v_qty_balance_rc SYS_REFCURSOR;
    -- 프로시져 사용 변수 설정  (END)
    --=====================================================================================================================================================

BEGIN
    --=====================================================================================================================================================
    -- 프로시져 사용 변수 초기화
    v_proc_input := JSON_OBJECT('p_created_by' VALUE p_created_by);

    --SET @plan_start_yyyymmdd	= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 월요일
    v_plan_start_yyyymmdd := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');  -- 월요일

    --SET @p_created_by			= RTRIM(@p_created_by    ) + '^';
    --SET @v_created_by			= LEFT(@P_created_by, CASE WHEN PATINDEX('%^%', @P_created_by) > 1 THEN PATINDEX('%^%', @P_created_by) ELSE 100 END -1)
    v_created_by := SUBSTR(p_created_by, 1, CASE WHEN INSTR(p_created_by || '^', '^') > 1 THEN INSTR(p_created_by || '^', '^') - 1 ELSE 99 END);
    v_division_id := '40';
    --=====================================================================================================================================================

    --=====================================================================================================================================================
    -- 시작 LOG  (START)
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '@p_created_by : ' || p_created_by;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, v_created_by, v_proc_input, NULL, NULL, NULL); END;
    v_log_message := NULL;
    -- 시작 LOG  (END)
    --=====================================================================================================================================================

    --=====================================================================================================================================================
    -- TEMP 테이블 초기화 (GTT TRUNCATE)
    -------------------------------------------------------------------------------------------------------------------------------------------------------
    -- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 데이터 DM_PLN_MKT_FCST 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_TEMP_MKT_DEMAND_PLAN';
    -------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------
    -- DM_PLN_CFM_SELLING_PRICE 테이블 데이터 SCM_MST_FUTURE_PRICE 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_TEMP_SELLING_PRICE';
    -------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------
    -- #SEND_TARGET_DATA 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP & CREATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_SEND_TARGET_DATA';
    -------------------------------------------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------------------------------------
    -- #results 기준 테이블 데이터로 임시 테이블 존재 여부 확인 후 DROP & CREATE
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_RESULTS';
    -- TEMP 테이블 초기화 (END)
    --=====================================================================================================================================================

    --=====================================================================================================================================================
    -- [E20251223-000672]_굳이 TEMP로 계속 담아 작업을 하지 않아도됨. 간략하게 진행하기 위해 원소스 주석 후 생성한다 (START)
    -- [E20251223-000672]_굳이 TEMP로 계속 담아 작업을 하지 않아도됨. 간략하게 진행하기 위해 원소스 주석 후 생성한다 (END)

    --=============================================================================================================================================
    -- 1. 받아온 데이터 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (START)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 1). #T_MAIN 테이블 데이터를 DM_PLN_MKT_FCST 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]에 INSERT (START)

    INSERT INTO SCM_MGR.GT_PRDM_TEMP_MKT_DEMAND_PLAN
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
    , QTY )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
           --[E20260309-000271]_ISNULL처리 추가 (START)
           --, SUM(QTY_PRICE) AS QTY --[E20260309-000271]_원소스 주석처리
           , SUM(NVL(QTY_PRICE, 0)) AS QTY --[E20260309-000271]_ISNULL처리 추가
           --[E20260309-000271]_ISNULL처리 추가 (END)
    FROM SCM_MGR.GT_PRDM_T_MAIN
    WHERE DIVISION_ID   = v_division_id
    AND   MEASURE       IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ')          -- [PJ2025-50188] 기준수요 포함
    AND   YYYYMMDD      >= v_plan_start_yyyymmdd
    GROUP BY  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM_TEMP_MKT_DEMAND_PLAN', NO_INVALIDATE => FALSE);

    -- 1). #T_MAIN 테이블 데이터를 DM_PLN_MKT_FCST 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]에 INSERT(END)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 DM_PLN_MKT_FCST 데이터를 삭제한다 (START)

    DELETE SCM_MGR.DM_PLN_MKT_FCST A
    WHERE EXISTS (
        SELECT 1
        FROM SCM_MGR.GT_PRDM_TEMP_MKT_DEMAND_PLAN B
        WHERE A.DIVISION_ID   = B.DIVISION_ID
          AND A.PROJECT_CODE  = B.PROJECT_CODE
          AND A.SCM_SITE_ID   = B.SCM_SITE_ID
          AND A.ITEM_ID       = B.ITEM_ID
          AND A.DOM_EXP       = B.DOM_EXP
          AND A.FCST_TYPE     = B.FCST_TYPE
          AND A.INCOTERMS     = B.INCOTERMS
          AND A.MEASURE       = B.MEASURE
          AND A.YYYYMMDD      = B.YYYYMMDD
          AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
    )
    AND A.DIVISION_ID = v_division_id
    AND A.YYYYMMDD   >= v_plan_start_yyyymmdd
    AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ');

    -- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 DM_PLN_MKT_FCST 데이터를 삭제한다 (END)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]데이터로 -> MKT FCST 데이터를 적재한다 (START)

    INSERT INTO SCM_MGR.DM_PLN_MKT_FCST
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
    , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
         , A.QTY, p_created_by, SYSDATE, p_created_by, SYSDATE
    FROM SCM_MGR.GT_PRDM_TEMP_MKT_DEMAND_PLAN A;

    -- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_MKT_DEMAND_PLAN]데이터로 -> MKT FCST 데이터를 적재한다 (END)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 1. 받아온 데이터 기준으로 DM_PLN_MKT_FCST 데이터 동기화 (END)
    --=============================================================================================================================================
    --=============================================================================================================================================
    -- 2. 받아온 데이터 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (START)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 1). #T_MAIN 테이블 데이터를 DM_PLN_CFM_SELLING_PRICE 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]에 INSERT (START)
    -- 데이터가 하나 이상인 경우가 존재할 수 있으므로, 평균값으로 저장한다.

    INSERT INTO SCM_MGR.GT_PRDM_TEMP_SELLING_PRICE
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE
    , INCOTERMS, PRICE )
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS
         --[E20260309-000271]_ISNULL처리 추가 (START)
         --, AVG(A.QTY_PRICE) AS PRICE--[E20260309-000271]_원소스 주석처리
         , AVG(NVL(A.QTY_PRICE, 0)) AS PRICE
         --[E20260309-000271]_ISNULL처리 추가 (END)
    FROM SCM_MGR.GT_PRDM_T_MAIN A
    WHERE A.DIVISION_ID = v_division_id
      AND A.MEASURE IN ('LOC', 'KRW', 'USD')
      AND A.YYYYMMDD >= v_plan_start_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
           , A.INCOTERMS;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM_TEMP_SELLING_PRICE', NO_INVALIDATE => FALSE);

    -- 1). DM_PLN_CFM_SELLING_PRICE테이블 데이터를 SCM_MST_FUTURE_PRICE 적재기준으로 -> TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]에 INSERT (END)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 SCM_MST_FUTURE_PRICE 데이터를 삭제한다 (START)

    DELETE SCM_MGR.SCM_MST_FUTURE_PRICE A
    WHERE EXISTS (
        SELECT 1
        FROM SCM_MGR.GT_PRDM_TEMP_SELLING_PRICE B
        WHERE A.DIVISION_ID   = B.DIVISION_ID
          AND A.PROJECT_CODE  = B.PROJECT_CODE
          AND A.SCM_SITE_ID   = B.SCM_SITE_ID
          AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
          AND A.ITEM_ID       = B.ITEM_ID
          AND A.YYYYMMDD      = B.YYYYMMDD
          AND A.MEASURE       = B.MEASURE
          AND A.DOM_EXP       = B.DOM_EXP
          AND A.FCST_TYPE     = B.FCST_TYPE
          AND A.INCOTERMS     = B.INCOTERMS
    )
    AND A.DIVISION_ID = v_division_id
    AND A.YYYYMMDD   >= v_plan_start_yyyymmdd
    AND A.MEASURE IN ('LOC', 'KRW', 'USD');

    -- 2). 당주 월요일 이후 TEMP 테이블에 적재된 데이터와 동일한 SCM_MST_FUTURE_PRICE 데이터를 삭제한다 (END)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]데이터로 -> SCM_MST_FUTURE_PRICE 데이터를 적재한다 (START)

    INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE
    , INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE
         , A.INCOTERMS, A.PRICE, p_created_by, SYSDATE, p_created_by, SYSDATE
    FROM SCM_MGR.GT_PRDM_TEMP_SELLING_PRICE A;

    -- 3). TEMP TABLE[#TEMP_DM_PLN_CFM_SELLING_PRICE]데이터로 -> SCM_MST_FUTURE_PRICE 데이터를 적재한다 (END)
    -----------------------------------------------------------------------------------------------------------------------------------------------
    -- 2. DM_PLN_CFM_SELLING_PRICE 기준으로 SCM_MST_FUTURE_PRICE 데이터 동기화 (END)
    --=============================================================================================================================================
    -- [E20251223-000672]_굳이 TEMP로 계속 담아 작업을 하지 않아도됨. 간략하게 진행하기 위해 원소스 주석 후 생성한다 (END)

    -- [PJ2025-50017] MKT_FCST 수정으로 DM_PLN_MKT_FCST의 BALANCE 데이터 재생성
    -- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (START)
    /*
    IF OBJECT_ID (N'tempdb..#SEND_TARGET_DATA', N'U') IS NOT NULL THEN
        DROP TABLE #SEND_TARGET_DATA

    CREATE TABLE #SEND_TARGET_DATA
    ( DIVISION_ID		NVARCHAR(30) NOT NULL
    , PROJECT_CODE		NVARCHAR(50) NOT NULL
    , SCM_SITE_ID		NVARCHAR(30) NOT NULL
    , ITEM_ID			NVARCHAR(50) NOT NULL
    , DOM_EXP			NVARCHAR(03) NOT NULL
    , FCST_TYPE			NVARCHAR(20) NOT NULL
    , INCOTERMS			NVARCHAR(10) NOT NULL
    , PLANT_SITE_ID		NVARCHAR(30) NOT NULL
    , CELL_PROD_SITE_ID NVARCHAR(30) NULL
    , VMI_YN			NVARCHAR(01) NULL)*/
    -- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (END)

    -- [E20251223-000672]_해당 변수의 사용이유를 모르겠으니 주석처리
    --DECLARE @c_division_id         NVARCHAR(MAX);

    INSERT INTO SCM_MGR.GT_PRDM_SEND_TARGET_DATA
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, VMI_YN )
    SELECT DIVISION_ID, END_CUSTOMER AS PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, 'N' -- vmi_yn 초기값
      -- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(START)
      -- FROM  #results_MKT_FCST
    FROM SCM_MGR.GT_PRDM_T_MAIN
      -- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(END)
    WHERE MEASURE IN ('MKT_FCST', 'VMI_IN_REQ')
    GROUP BY DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM_SEND_TARGET_DATA', NO_INVALIDATE => FALSE);

    SELECT NVL(COUNT(1), 0) INTO n_send_count FROM SCM_MGR.GT_PRDM_SEND_TARGET_DATA;

    IF n_send_count > 0 THEN
        -- [E20251223-000672]_해당 변수의 사용이유를 모르겠으니 주석처리
        --SET @c_division_id = (SELECT TOP 1 DIVISION_ID FROM #SEND_TARGET_DATA)
        --EXEC PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE @c_division_id, @p_plan_id = 'CALL'
        SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(p_division_id => v_division_id, p_plan_id => 'CALL', o_result_cursor => v_qty_balance_rc);
        IF v_qty_balance_rc%ISOPEN THEN CLOSE v_qty_balance_rc; END IF;
    END IF;

    -- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (START)
    /*
    -- [PJ2025-50017] MKT_FCST 수정으로 DM_PLN_MKT_FCST의 MKT_AMT 데이터 업데이트
    IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL THEN
        DROP TABLE #results

    CREATE TABLE #results
    ( v_division_id		NVARCHAR(30) NOT NULL
    , v_project_code	NVARCHAR(50) NOT NULL
    , v_scm_site_id		NVARCHAR(30) NOT NULL
    , v_item_id			NVARCHAR(50) NOT NULL
    , v_dom_exp			NVARCHAR(03) NOT NULL
    , v_fcst_type		NVARCHAR(20) NOT NULL
    , v_incoterms		NVARCHAR(10) NOT NULL
    , v_measure			NVARCHAR(50) NOT NULL
    , v_plant_site_id	NVARCHAR(30) NOT NULL
    , v_yyyymmdd		NVARCHAR(08) NOT NULL
    , v_created_by		NVARCHAR(150) NULL )
    */
    -- [E20251223-000672]_DROP, TEMP 테이블은 가장 상단으로 이동한다 (END)

    INSERT INTO SCM_MGR.GT_PRDM_RESULTS
    ( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD, V_CREATED_BY )
    SELECT DIVISION_ID, END_CUSTOMER AS PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, p_created_by AS CREATED_BY
    -- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(START)
    --FROM  #results_MKT_FCST
    FROM SCM_MGR.GT_PRDM_T_MAIN
    -- [E20251223-000672]_굳이 TEMP로 담을 필요 없이, 전달받은 데이터를 사용한다. TEMP 주석 후 전달받은 TABLE 사용하도록 수정(END)
    WHERE DIVISION_ID   = v_division_id
      AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ', 'LOC', 'KRW', 'USD') -- [E20251223-000672]_'LOC', 'KRW', 'USD'메져를 추가하여 한번에 조회한다
      AND YYYYMMDD  >= v_plan_start_yyyymmdd
    GROUP BY DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD;
    -- [E20251223-000672]_굳이 해당 부분으로 담을 필요 없이, 한번에 전달받은 TEMP 테이블에서 담는다. 필요없는 부분 주석처리 (START)
    /*
    UNION
    SELECT DISTINCT
             DIVISION_ID
           , END_CUSTOMER	AS PROJECT_CODE
           , SCM_SITE_ID
           , ITEM_ID
           , DOM_EXP
           , FCST_TYPE
           , INCOTERMS
           , MEASURE
           , PLANT_SITE_ID
           , YYYYMMDD
           , @v_created_by		AS CREATED_BY
    FROM  #results_FUTURE_PRICE
    WHERE DIVISION_ID	= @v_division_id
    AND   MEASURE IN ('LOC', 'KRW', 'USD')
    AND   YYYYMMDD		>= @v_plan_start_yyyymmdd
    GROUP BY DIVISION_ID
           , END_CUSTOMER
           , SCM_SITE_ID
           , ITEM_ID
           , DOM_EXP
           , FCST_TYPE
           , INCOTERMS
           , MEASURE
           , PLANT_SITE_ID
           , YYYYMMDD
    */
    -- [E20251223-000672]_굳이 해당 부분으로 담을 필요 없이, 한번에 전달받은 TEMP 테이블에서 담는다. 필요없는 부분 주석처리 (END)

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM_RESULTS', NO_INVALIDATE => FALSE);

    --[E20251021-000634]_주석처리한 부분 주석 삭제
    SELECT NVL(COUNT(1), 0) INTO n_result_count FROM SCM_MGR.GT_PRDM_RESULTS WHERE V_DIVISION_ID = '40';

    IF n_result_count > 0 THEN
        SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE;
    END IF;

    ---------------------------------------------------------------------------------------------------------------------------------------------------
    -- [E20251223-000672]_작업이 모두 종료되었으므로, 사용했던 모든 TEMP 테이블 종료 시 DROP 작업 진행 (START)
    -- GTT는 ON COMMIT PRESERVE ROWS이므로 TRUNCATE로 정리
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_T_MAIN';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_RESULTS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_SEND_TARGET_DATA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_TEMP_MKT_DEMAND_PLAN';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_PRDM_TEMP_SELLING_PRICE';
    -- [E20251223-000672]_작업이 모두 종료되었으므로, 사용했던 모든 TEMP 테이블 종료 시 DROP 작업 진행 (END)
    ---------------------------------------------------------------------------------------------------------------------------------------------------

    COMMIT;

    --=====================================================================================================================================================
    -- 종료 LOG (START)
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    --SET @v_description = '@p_division_id : ' + @p_division_id ;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, v_created_by, v_proc_input, NULL, NULL, NULL); END;
    -- 종료 LOG (END)
    --=====================================================================================================================================================

    OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MESSAGE FROM DUAL;

EXCEPTION
    --=====================================================================================================================================================
    -- 오류 발생시 TRANSACTION 롤백 및 로그적재 (START)
    WHEN OTHERS THEN
        ---------------------------------------------------------------------------------------------------------------------------------------------------
        -- ERROR LOG VALUE SAVE (START)
        --[E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (START)
        --ROLLBACK TRANSACTION PR_DM_PLN_CFM_TO_MKT_FCST;  --[E20260309-000271]_원소스주석처리
        ROLLBACK;
        --[E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (END)

        v_log_type    := 'ERROR';
        v_sql_code    := TO_CHAR(SQLCODE);
        v_sql_errmsg  := SQLERRM;
        v_backtrace   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        v_log_message := SUBSTR(v_sql_errmsg, 1, 1000);
        v_description := SUBSTR(v_backtrace, 1, 500);
        d_event_date  := SYSDATE;

        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date, v_created_by, v_proc_input, v_sql_code, v_sql_errmsg, v_backtrace); END;
        -- ERROR LOG VALUE SAVE (END)
        ---------------------------------------------------------------------------------------------------------------------------------------------------

        RAISE_APPLICATION_ERROR(-20001, '[' || v_sql_code || '] ' || v_sql_errmsg || ' | ' || v_backtrace);
    -- 오류 발생시 TRANSACTION 롤백 및 로그적재 (END)
    --=====================================================================================================================================================

END PR_DM_PLN_CFM_TO_MKT_FCST;
/
-- SOURCE-FRESH: SCM_MGR.PR_SCM_MST_EXCHANGE_RATE PROCEDURE LAST_DDL=2026-09-02 17:30:37 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_SCM_MST_EXCHANGE_RATE" 
(
      P_BATCH_YN  VARCHAR2 DEFAULT 'Y'  /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가하여 배치수행/화면수행 구분 */
)
/*
    * Program ID   : PR_SCM_MST_EXCHANGE_RATE
    * Description  : Chempion 환율 I/F Procedure
    * PARAMETER    : N/A
    * DESCRIPTION  : Chempion 환율 I/F
    * I/F Table    : XIF_GSC_MOVE_EXCHANGE_RATE_SN
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2021.05.13   P.C.I          PJ20209642R Chempion 환율 I/F
    * 2022.03.25   sclee          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
    * 2022.05.11   HWI1993        GM JV 수정
    * 2022.11.17   kdw2819        [C20221116-000471]환율정보 수신 배치 오류
    * 2022.11.28   chano0612      [C20221124-000290]환율 IF관련 수정 요청 건
    * 2025.06.24   kjiyoon        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 - 화면 호출용 프로시저 수행 성공/실패 output 추가
    * 2025.07.03   kjiyoon        [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가
    * 2025.09.15   김준규           IT20250117A NERP ROLLIN 3차 현재 CNY를 RMB로 변경 저장하는 것을 CNY 그대로 저장변경
    * 2026.03.24   김준규           [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
    */
 AS
    /* ------------------------------------------------------------------------- */
    C_DIVISION_ID       VARCHAR2(30 CHAR);
    C_SCENARIO_TYPE_CD  VARCHAR2(06 CHAR);
    C_PLN_PERIOD_YYYYMM VARCHAR2(06 CHAR);
    C_CURRENCY_CD       VARCHAR2(15 CHAR);
    C_IF_SEQ            NUMBER(16, 0);
    V_RECEIVE_CNT       NUMBER(16, 0);
    V_BATCH_USER        VARCHAR2(150 CHAR) := 'scm_batch';
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    N_HISTORY_SEQ       NUMBER;
    V_IFSEQNO           VARCHAR2(30 CHAR);
    V_IN_PARA_DATA      VARCHAR2(4000 CHAR);
    V_RESULT_CURSOR     SYS_REFCURSOR;
    CUR_E               SYS_REFCURSOR;

    CURSOR CUR_D IS
        SELECT DIVISION_ID
          FROM GT_SMER_I_DIVISION;
BEGIN

    /* ------------------------------------------------------------------------- */
    /* LOG 용 변수 설정 */
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := ('P_BATCH_YN = ' || NVL(P_BATCH_YN, 'X')); /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 */
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* GTT 초기화 : TRUNCATE 는 DDL 이라 암시 COMMIT 이 발생해 상위 트랜잭션의 ROLLBACK 을 무력화한다 -> DELETE 사용 */
    DELETE FROM GT_SMER_I_DIVISION;

    /* 자동차, ESS, 소형 작업 */
    /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 START */
    /* 기존로직 주석처리 */
    /* INSERT +NO_PARALLEL INTO GT_SMER_I_DIVISION (division_id) */
    /* SELECT DIVISION_ID */
    /* FROM SCM_MST_DIVISION */
    /* WHERE ATTRIBUTE3 IN ('40','81', '82' ) */
    IF P_BATCH_YN = 'Y' THEN
        /* 대상 사업부 */
        INSERT
          INTO GT_SMER_I_DIVISION
             ( DIVISION_ID )
        SELECT DIVISION_ID
          FROM SCM_MST_DIVISION
         WHERE ATTRIBUTE3 IN ('81', '82');

        /* 대상 IF 환율 */

        /* CUR_E CURSOR LOCAL FOR */
        OPEN CUR_E FOR
        SELECT SCENARIO_TYPE_CD
             , PLN_PERIOD_YYYYMM
             , CURRENCY_CD
             , IF_SEQ
          FROM (SELECT E.SCENARIO_TYPE_CD
                     , E.PLN_PERIOD_YYYYMM
                     , E.CURRENCY_CD
                     , E.IF_SEQ
                  FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN E
                 WHERE NVL(E.TRANSF_FLAG, 'N') = 'N'
                   AND SCENARIO_TYPE_CD IN ('ML', 'RF') /* [C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다.. */
                 GROUP BY E.SCENARIO_TYPE_CD, E.PLN_PERIOD_YYYYMM, E.CURRENCY_CD, E.IF_SEQ) X
         ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD;
    ELSE
        /* 대상 사업부 */
        INSERT
          INTO GT_SMER_I_DIVISION
             ( DIVISION_ID )
        SELECT DIVISION_ID
          FROM SCM_MST_DIVISION
         WHERE ATTRIBUTE3 IN ('40');

        /* 대상 IF 환율 */

        /* CUR_E CURSOR LOCAL FOR */
        OPEN CUR_E FOR
        SELECT SCENARIO_TYPE_CD
             , PLN_PERIOD_YYYYMM
             , CURRENCY_CD
             , IF_SEQ
          FROM (SELECT E.SCENARIO_TYPE_CD
                     , E.PLN_PERIOD_YYYYMM
                     , E.CURRENCY_CD
                     , E.IF_SEQ
                  FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN E
                 WHERE E.TRANSF_DATE = (SELECT MAX(A.TRANSF_DATE)
                                          FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN A
                                         WHERE 1 = 1
                                           AND A.SCENARIO_TYPE_CD IN ('ML', 'RF'))
                   AND SCENARIO_TYPE_CD IN ('ML', 'RF') /* [C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다.. */
                 GROUP BY E.SCENARIO_TYPE_CD, E.PLN_PERIOD_YYYYMM, E.CURRENCY_CD, E.IF_SEQ) X
         ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD;
    END IF;

    /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 END */
    /* DELETE FROM DM_MST_EXCHANGE_RATE WHERE YYYYMMDD BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, 0), 'YYYYMMDD') || '01' AND TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMMDD') || '01' */
    /* [C20221124-000290] DM_MST_EXCHANGE_RATE 에 존재하는 기존 데이터를 삭제한다. */
    /* 위로 로직 이동해서 아래 CURSOR 주석처리 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 */
    /* CURSOR 환율 정보 수신 (KEY : SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ) */

    /* CUR_E CURSOR LOCAL FOR */
    /* select SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ */
    /* from ( select E.SCENARIO_TYPE_CD */
    /*           , E.PLN_PERIOD_YYYYMM */
    /*           , E.CURRENCY_CD */
    /*           , E.IF_SEQ */
    /*       from XIF_GSC_MOVE_EXCHANGE_RATE_SN E */

    /*       AND SCENARIO_TYPE_CD IN ('ML', 'RF') [C20221124-000290] SCENARIO_TYPE_CD를 ML, RF만 등록한다.. */
    /*       group by E.SCENARIO_TYPE_CD */
    /*           , E.PLN_PERIOD_YYYYMM */
    /*           , E.CURRENCY_CD */
    /*           , E.IF_SEQ */
    /*           ) x */
    /* ORDER BY PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ, SCENARIO_TYPE_CD */
    /* CURSOR 환율 정보 수신 (KEY : SCENARIO_TYPE_CD, PLN_PERIOD_YYYYMM, CURRENCY_CD, IF_SEQ) */

    /* CUR_D CURSOR FOR */

    NULL;

    /* ------------------------------------------------------------------------- */

    /* Start 환율 Cursor */
    V_RECEIVE_CNT := 0;

    FETCH CUR_E
        INTO C_SCENARIO_TYPE_CD, C_PLN_PERIOD_YYYYMM, C_CURRENCY_CD, C_IF_SEQ;
    WHILE (CUR_E%FOUND) LOOP
        /* ----------------------------------------------------------------- */
        /* * IT20250117A NERP ROLLIN 3차 현재 CNY를 RMB로 변경 저장하는 것을 CNY 그대로 저장변경 시작 */
        /* 변경전 상태 USING ( SELECT B.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, REPLACE(A.UNIT_CURRENCY, 'CNY', 'RMB') UNIT_CURRENCY, A.EXCHANGE_PRICE */
        MERGE INTO DM_MST_EXCHANGE_RATE DME
        USING (SELECT B.DIVISION_ID
                    , A.YYYYMMDD
                    , A.CURRENCY
                    , /*REPLACE(A.UNIT_CURRENCY, 'CNY', 'RMB')*/ A.UNIT_CURRENCY AS UNIT_CURRENCY
                    , A.EXCHANGE_PRICE
                 FROM (SELECT PLN_YYYYMM || '01' AS YYYYMMDD
                            , 'KRW' AS CURRENCY
                            , CURRENCY_CD UNIT_CURRENCY
                            , KRW_CNVT_RATE EXCHANGE_PRICE
                         FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN
                        WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
                          AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
                          AND CURRENCY_CD = C_CURRENCY_CD
                          AND IF_SEQ = C_IF_SEQ
                        UNION ALL
                       SELECT PLN_YYYYMM || '01' AS YYYYMMDD
                            , 'USD' AS CURRENCY
                            , CURRENCY_CD UNIT_CURRENCY
                            , USD_CNVT_RATE EXCHANGE_PRICE
                         FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN
                        WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
                          AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
                          AND CURRENCY_CD = C_CURRENCY_CD
                          AND IF_SEQ = C_IF_SEQ
                        UNION ALL
                       SELECT PLN_YYYYMM || '01' AS YYYYMMDD
                            , 'EUR' AS CURRENCY
                            , CURRENCY_CD UNIT_CURRENCY
                            , EUR_CNVT_RATE EXCHANGE_PRICE
                         FROM XIF_GSC_MOVE_EXCHANGE_RATE_SN
                        WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
                          AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
                          AND CURRENCY_CD = C_CURRENCY_CD
                          AND IF_SEQ = C_IF_SEQ) A
                    , GT_SMER_I_DIVISION B) XXX
        /* * IT20250117A NERP ROLLIN 3차 현재 CNY를 RMB로 변경 저장하는 것을 CNY 그대로 저장변경 종료 */
        ON (DME.DIVISION_ID = XXX.DIVISION_ID AND DME.YYYYMMDD = XXX.YYYYMMDD AND DME.CURRENCY = XXX.CURRENCY AND DME.UNIT_CURRENCY = XXX.UNIT_CURRENCY)
        WHEN MATCHED THEN
            UPDATE SET DME.EXCHANGE_PRICE = XXX.EXCHANGE_PRICE
                     , DME.LAST_UPDATED_BY = 'SYSTEM'
                     , DME.LAST_UPDATE_DATE = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT
                 ( DIVISION_ID
                 , YYYYMMDD
                 , CURRENCY
                 , UNIT_CURRENCY
                 , EXCHANGE_PRICE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES ( XXX.DIVISION_ID
                   , XXX.YYYYMMDD
                   , XXX.CURRENCY
                   , XXX.UNIT_CURRENCY
                   , XXX.EXCHANGE_PRICE
                   , 'SYSTEM'
                   , SYSDATE
                   , 'SYSTEM'
                   , SYSDATE );
        /* ----------------------------------------------------------------- */
        /* 배치일때만 업데이트하도록 조건추가 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : P_BATCH_YN 파라미터 추가 */
        IF P_BATCH_YN = 'Y' THEN
            /* I/F Table TRANSF_FLAG 변경 */
            UPDATE XIF_GSC_MOVE_EXCHANGE_RATE_SN
               SET TRANSF_FLAG = 'Y'
             WHERE SCENARIO_TYPE_CD = C_SCENARIO_TYPE_CD
               AND PLN_PERIOD_YYYYMM = C_PLN_PERIOD_YYYYMM
               AND CURRENCY_CD = C_CURRENCY_CD
               AND IF_SEQ = C_IF_SEQ;
        END IF;

        V_RECEIVE_CNT := V_RECEIVE_CNT + 1;
        /* ----------------------------------------------------------------- */
        FETCH CUR_E
            INTO C_SCENARIO_TYPE_CD, C_PLN_PERIOD_YYYYMM, C_CURRENCY_CD, C_IF_SEQ;
    END LOOP;
    CLOSE CUR_E;

    /* End  환율 Cursor */
    /* Start  Sales Price, Sales Plan Cursor */
    /* select 'V_RECEIVE_CNT', V_RECEIVE_CNT */
    IF (V_RECEIVE_CNT > 0) THEN

        OPEN CUR_D;
        FETCH CUR_D
            INTO C_DIVISION_ID;
        WHILE (CUR_D%FOUND) LOOP

            /* select 'C_DIVISION_ID', C_DIVISION_ID */
            /* Sales Price Update */
            PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION(C_DIVISION_ID, V_RESULT_CURSOR);   /* [E20260824-PKGCONSOL] 단독 SP -> PKG 내부 프로시저. 시그니처 동일(2-arg) 실측 확인 */

            /* Sales Plan Update */
            PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(C_DIVISION_ID, 'EXCHANGE_RATE');

            FETCH CUR_D
                INTO C_DIVISION_ID;
        END LOOP;
        CLOSE CUR_D;

    END IF;
    /* End  Sales Price, Sales Plan Cursor */
    /* 트랜잭션 종료 */
    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;
    NULL; /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 */


EXCEPTION
    WHEN OTHERS THEN

        /* ERROR LOG */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
        D_EVENT_DATE  := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        NULL;
        /* [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 사용자 환율팝업 적용 */


        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
-- 권한 (SCM_MGR)
GRANT EXECUTE ON SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.PR_SCM_MST_EXCHANGE_RATE TO SCMP_APP;
GRANT EXECUTE ON SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI TO SCMP_APP;
-- 시노님 (SCMP_APP 로 실행할 것)
-- CREATE OR REPLACE SYNONYM SCMP_APP.PR_DM_PLN_CFM_TO_MKT_FCST FOR SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST;
-- CREATE OR REPLACE SYNONYM SCMP_APP.PR_SCM_MST_EXCHANGE_RATE FOR SCM_MGR.PR_SCM_MST_EXCHANGE_RATE;
-- CREATE OR REPLACE SYNONYM SCMP_APP.PR_SCM_MST_EXCHANGE_RATE_UI FOR SCM_MGR.PR_SCM_MST_EXCHANGE_RATE_UI;
-- PROC_M (standalone PROC_NM · 멱등 MERGE)
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'PR_SCM_MST_EXCHANGE_RATE_UI' PROC_NM, 'batchYn' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T USING (SELECT 'PR_SCM_MST_EXCHANGE_RATE_UI' PROC_NM, 'o_result_cursor' COL_NM, 'PROC_RESULT' DATA_TP_CD, 'OUT' COL_TP_CD, 2 SORT_ORD FROM DUAL) S ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD) WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;
