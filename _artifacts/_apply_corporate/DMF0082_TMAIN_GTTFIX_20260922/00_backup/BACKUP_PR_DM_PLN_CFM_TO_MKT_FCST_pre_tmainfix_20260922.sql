PROCEDURE           "PR_DM_PLN_CFM_TO_MKT_FCST" 
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