
/*=====================================================================================================================================================
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW
 * Description  : Sales Plan AMT Create ( Local/KRW ) 
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      	Description
 *=====================================================================================================================================================
 * 2017.02.05	DWOK/KHSONG	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.08				SALES_PLAN_CUTOFF  주석처리
 * 2019.07.09	KHSONG 		[CSR ID:4034895]  GSCM RTF[system] Measure 관련 요청건
 * 2019.11.14	KHSONG 		SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
 * 2020.02.13	HWI1993 	자동차사업부 SALES AMT 메저를 RTF_SCP 기준으로 생성
 * 2020.03.09	KHSONG 		TMM_FCST ADD
 * 2020.05.07	KHSONG 		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.08.06	hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020.12.08    P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2021.07.02	HWI1993		[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2021.08.25	HWI1993		성능이슈로 긴급 수정함.
 * 2022.01.04	kdw2819		[C20211215-000199][ESS영업관리팀] GSCM Sales Price 내 Batch Job 버튼 실행 불가의 건
 * 2022.01.25   kdw2819		[C20220125-000410]Sales Plan, Sales Plan Waterfall Current 버전의 RTF없는 금액 표기 오류 수정 요청의 건
 * 2022.04.05   hwi1993     GM JV 작업
 * 2024.11.15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선		
 * 2024.11.29	KJJ			[PJ2024-50611] Catch Up 메저 삭제 금지
 * 2024.12.01	KANG.H.J	[PJ2024-50611] BPS 매출(RTF_SYS_RP Measrue) 전송 시 전 사업부 FROM_SITE_ID 추가 -- 기존 로직과 동일하도록 수정이 필요 함..
 * 2025.01.21	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.02.11	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 SCM_FCST MEASURE 추가
 * 2025.03.25	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 'AMT 부문' 업데이트
 * 2025.04.08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제
 * 2025.04.28	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
 * 2025.05.12	JSSBAE		[E20250507-000390]_Sales Plan UI 환율 재계산 기능 추가
 * 2025.05.13	KANG.H.J	[PJ2025-50188] 환율 변경시 DM_PLN_SALES_PLAN_RESULT SALES_AMT_KRW / MKT_AMT_KRW 재생성
 * 2025.06.10	KANG.H.J	[PJ2025-50188] 임시테이블 DROP 처리
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.28	KANG.H.J	[PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성
 *===================================================================================================================================================*/
-- Weekly Cutoff 시에 이 로직이 수행되어야 함.  

CREATE PROCEDURE [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_20250814]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(MAX)		,
	@p_CREATED_BY               NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	


	-- CUTOFF 변수 설정

	-- 스플릿관련 변수
	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
    DECLARE @v_division_id      NVARCHAR(MAX);
	DECLARE @v_created_by       NVARCHAR(MAX);

	-- [PJ2025-50188] 환율 변경시 DM_PLN_SALES_PLAN_RESULT에 SALES_AMT_KRW / MKT_AMT_KRW 재생성 Start
	DECLARE @v_start_yyyymmdd             nvarchar(08);
	DECLARE @v_end_yyyymmdd               nvarchar(08);

--	SET @v_start_yyyymmdd	= substring(CONVERT(CHAR(8), dateadd(month,	CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END	,getdate()), 112),1,6) + '01'	-- 전월1일/1일은 전전월1일 (yyyymmdd)
	SET @v_start_yyyymmdd	= substring(CONVERT(CHAR(8), dateadd(month, 0, getdate()), 112),1,6) + '01' --  [PJ2025-50188]  전월1일/1일은 전전월1일 (yyyymmdd) ==> 당월 1일로 변경
	SET @v_end_yyyymmdd		= CONVERT(CHAR(8), getdate(), 112)                                          -- 당일 (yyyymmdd)
	-- [PJ2025-50188] 환율 변경시 DM_PLN_SALES_PLAN_RESULT에 SALES_AMT_KRW / MKT_AMT_KRW 재생성 End

	--[2018-03-15][추가][사용자를 매개변수로 받아서 처리]
	--            [있는경우][매개변수로 처리]
	--			  [없는경우][ROLLING 에서 처리하므로 'CUTOFF'로 처리]
	IF ISNULL(@p_CREATED_BY, '') = ''
		SET @v_created_by = 'CUTOFF';
	ELSE
		SET @v_created_by = @p_CREATED_BY;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '@p_division_id : ' + @p_division_id + ' / ' +'@v_created_by : ' +  ISNULL(@v_created_by, 'NULL');
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);    
		-- SELECT @max_loop_cnt  as '@max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
		-- SELECT Convert(NVARCHAR(10), @max_loop_cnt)  as '@max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
PRINT @v_program_name +' : A001--' + CONVERT(VARCHAR(30), GETDATE(), 121);
        /*---------------------------------------------------------------*/
		WHILE LEN(@recv_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN	
			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				-- Loop Count +1씩 증가시킴
				SET @mst_loop_cnt = @mst_loop_cnt + 1;
				SET @v_division_id  = [dbo].[SCM_ARR_SPL_VAL] (@p_division_id  ,  @v_delimiter , @mst_loop_cnt) ;    
			END

          /*----------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/
		  /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
          IF       @mst_loop_cnt <= @max_loop_cnt  

		    BEGIN
				-- [PJ2025-50188] 임시테이블 DROP 처리 Start
				BEGIN
					IF OBJECT_ID('tempdb..#T2_MKT_FCST') IS NOT NULL
						DROP TABLE  #T2_MKT_FCST;         
					IF OBJECT_ID('tempdb..#T2_PRICE') IS NOT NULL
						DROP TABLE  #T2_PRICE;          
				END
				-- [PJ2025-50188] 임시테이블 DROP 처리 End


				-- 기존 정보 삭제
				delete dbo.dm_pln_sales_plan
				-- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
				 where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				   and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and NOT EXISTS (
							select A.DIVISION_ID
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
							   and a.division_id    = dm_pln_sales_plan.division_id
							   and a.project_code   = dm_pln_sales_plan.project_code
							   and a.scm_site_id    = dm_pln_sales_plan.scm_site_id
							   and a.item_id        = dm_pln_sales_plan.item_id
				       ) 
					AND MEASURE NOT IN ('CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up') --[PJ2024-50611] Catch Up 메저 삭제 금지
				 ;        
PRINT @v_program_name +' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121);    
                -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
				delete dbo.dm_pln_sales_plan
				 where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				   and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START
				   --and MEASURE in ( 'MKT_FCST','CUST_FCST', 'RTF','RTF_SYS_RP','TMM_FCST', 'SCM_FCST', 'RTF_PR')				-- 20180417 modify skh  -- 20190709 KHSONG [CSR ID:4034895] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD -- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가 
				   and MEASURE in ( 'MKT_FCST','CUST_FCST', 'RTF','RTF_SYS_RP','TMM_FCST', 'SCM_FCST', 'RTF_PR', 'RTF_SCP')		-- 20180417 modify skh  -- 20190709 KHSONG [CSR ID:4034895] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD -- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가 
				   -- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 END
				;
PRINT @v_program_name +' : A003--' + CONVERT(VARCHAR(30), GETDATE(), 121);
				-- 2021.08.25
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
				INTO #T_PRICE
				FROM SCM_MST_FUTURE_PRICE A
				WHERE DIVISION_ID = @v_division_id
					AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
					AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' )

				-- [PJ2025-50017] 소형 매출계획 동기화 개선 Start	(#T2_PRICE는 CELL_PROD_SITE_ID까지 포함됨)
				CREATE TABLE #T2_PRICE (		
				  DIVISION_ID		NVARCHAR(30)
				, PROJECT_CODE		NVARCHAR(50)
				, SCM_SITE_ID		NVARCHAR(30)
				, PLANT_SITE_ID		NVARCHAR(30)
				, CELL_PROD_SITE_ID	NVARCHAR(30)				-- [PJ2025-50017] 추가
				, ITEM_ID			NVARCHAR(50)
				, YYYYMMDD			NCHAR(8)
				, CURRENCY			NVARCHAR(3)
				, MEASURE			NVARCHAR(50)
				, DOM_EXP			NVARCHAR(3)
				, FCST_TYPE			NVARCHAR(20)
				, INCOTERMS			NVARCHAR(10)
				, PRICE				NUMERIC(30,10)
				)

				-- [PJ2025-50017] 40사업부는 DM_PLN_CFM_SELLING_PRICE / 그외는 SCM_MST_FUTURE_PRICE 기반으로 데이터 생성 START
				IF (@v_division_id = '40')
				BEGIN
					INSERT INTO #T2_PRICE
					(	
						   DIVISION_ID
						 , PROJECT_CODE					
						 , SCM_SITE_ID, PLANT_SITE_ID
						 , CELL_PROD_SITE_ID					-- [PJ2025-50017] 추가
						 , ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					)
					SELECT DIVISION_ID
						 , END_CUSTOMER					AS PROJECT_CODE
						 , SCM_SITE_ID, PLANT_SITE_ID
						 , CELL_PROD_SITE_ID					-- [PJ2025-50017] 추가
						 , ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					FROM DM_PLN_CFM_SELLING_PRICE A
					WHERE A.DIVISION_ID = @v_division_id
					AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
					AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' )
				END
				ELSE 
				BEGIN
					INSERT INTO #T2_PRICE
					(	
						   DIVISION_ID
						 , PROJECT_CODE					
						 , SCM_SITE_ID, PLANT_SITE_ID
						 , CELL_PROD_SITE_ID					-- [PJ2025-50017] 추가
						 , ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					)
					SELECT DIVISION_ID
						 , PROJECT_CODE					
						 , SCM_SITE_ID, PLANT_SITE_ID
						 , '-'							AS CELL_PROD_SITE_ID		-- [PJ2025-50017] 추가
						 , ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
					FROM SCM_MST_FUTURE_PRICE A
					WHERE A.DIVISION_ID = @v_division_id
					AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
					AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' )
				END
				-- [PJ2025-50017] 40사업부는 DM_PLN_CFM_SELLING_PRICE / 그외는 SCM_MST_FUTURE_PRICE 기반으로 데이터 생성 END
				
PRINT @v_program_name +' : A004--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
/*
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CREATED_BY, CREATION_DATE
				INTO #T_MKT_FCST
				FROM DM_PLN_MKT_FCST A
				WHERE A.DIVISION_ID = @v_division_id
					-- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
					and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					and A.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST', 'RTF','RTF_SYS_RP', 'SCM_FCST', 'RTF_PR')			-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가
					and A.ITEM_ID in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
*/
				CREATE TABLE #T2_MKT_FCST (						-- [PJ2025-50017] (#T2_MKT_FCST는 CELL_PROD_SITE_ID까지 포함됨)
				  DIVISION_ID		NVARCHAR(30)
				, PROJECT_CODE		NVARCHAR(50)
				, SCM_SITE_ID		NVARCHAR(30)
				, ITEM_ID			NVARCHAR(50)
				, DOM_EXP			NVARCHAR(3)
				, FCST_TYPE			NVARCHAR(20)
				, INCOTERMS			NVARCHAR(10)
				, MEASURE			NVARCHAR(50)
				, YYYYMMDD			NCHAR(8)
				, PLANT_SITE_ID		NVARCHAR(30)
				, CELL_PROD_SITE_ID	NVARCHAR(30)				-- [PJ2025-50017] 추가
				, FROM_SITE_ID		NVARCHAR(30)				-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
				, QTY				NUMERIC(30,10)
				, CREATED_BY		NVARCHAR(150)
				, CREATION_DATE		DATETIME
				)

				-- [PJ2025-50017] 40사업부는 DM_PLN_CFM_MKT_DEMAND_PLAN / 그외는 DM_PLN_MKT_FCST 기반으로 데이터 생성 START
				IF (@v_division_id = '40')
				BEGIN
					INSERT INTO #T2_MKT_FCST 
					(
						DIVISION_ID
					  , PROJECT_CODE
					  , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
					  , CELL_PROD_SITE_ID								-- [PJ2025-50017] 추가
					  , FROM_SITE_ID									-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
					  , QTY, CREATED_BY, CREATION_DATE
					)
					SELECT DIVISION_ID
						, END_CUSTOMER			AS PROJECT_CODE
						, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
						, CELL_PROD_SITE_ID								-- [PJ2025-50017] 추가
						, ATTRIBUTE2			AS FROM_SITE_ID			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
						, QTY, CREATED_BY, CREATION_DATE
					FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
					WHERE A.DIVISION_ID = @v_division_id
					and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START
					--and A.MEASURE IN ('MKT_FCST', 'RTF', 'RTF_SYS_RP', 'SCM_FCST', 'RTF_PR')					-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가	
					and A.MEASURE IN ('MKT_FCST', 'RTF', 'RTF_SYS_RP', 'SCM_FCST', 'RTF_PR', 'RTF_SCP')			-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가	
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 END
					and A.ITEM_ID in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
					UNION 
					SELECT DIVISION_ID
						, PROJECT_CODE
						, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
						, '-'					AS CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
						, '-'					AS FROM_SITE_ID			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
						, QTY, CREATED_BY, CREATION_DATE
					FROM DM_PLN_MKT_FCST A
					WHERE A.DIVISION_ID = @v_division_id
					and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					and A.MEASURE IN ('CUST_FCST','TMM_FCST')			
					and A.ITEM_ID in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
				END
				ELSE
				BEGIN
					INSERT INTO #T2_MKT_FCST 
					(
						DIVISION_ID
					  , PROJECT_CODE
					  , SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
					  , CELL_PROD_SITE_ID
					  , FROM_SITE_ID									-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
					  , QTY, CREATED_BY, CREATION_DATE
					)
					SELECT DIVISION_ID
						, PROJECT_CODE
						, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
						, '-'					AS CELL_PROD_SITE_ID	-- [PJ2025-50017] 추가
						, '-'					AS FROM_SITE_ID			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
						, QTY, CREATED_BY, CREATION_DATE
					FROM DM_PLN_MKT_FCST A
					WHERE A.DIVISION_ID = @v_division_id
					and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					and A.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST', 'SCM_FCST')			
					and A.ITEM_ID in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
					UNION ALL
					SELECT DIVISION_ID
						, PROJECT_CODE
						, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID
						, CELL_PROD_SITE_ID								-- [PJ2025-50017] 추가
						, ATTRIBUTE2			AS FROM_SITE_ID			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
						, QTY, CREATED_BY, CREATION_DATE
					FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
					WHERE A.DIVISION_ID = @v_division_id
					and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START
					--and A.MEASURE IN ('RTF','RTF_SYS_RP', 'RTF_PR')													-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가
					and A.MEASURE IN ('RTF','RTF_SYS_RP', 'RTF_PR', 'RTF_SCP')											-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가 
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START
					and A.ITEM_ID in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
				END
				-- [PJ2025-50017] 40사업부는 DM_PLN_CFM_MKT_DEMAND_PLAN / 그외는 DM_PLN_MKT_FCST 기반으로 데이터 생성 END

				-- [PJ2025-50017] 소형 매출계획 동기화 개선 End
				
PRINT @v_program_name +' : A005--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
				IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP_LOC') IS NOT NULL
					BEGIN 
						DROP TABLE  #SALES_PLAN_TEMP_LOC          
					END 
			  	--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				CREATE TABLE #SALES_PLAN_TEMP_LOC (
				DIVISION_ID			NVARCHAR(30)
				, PROJECT_CODE		NVARCHAR(50)
				, SCM_SITE_ID		NVARCHAR(30)
				, ITEM_ID			NVARCHAR(50)
				, DOM_EXP			NVARCHAR(3)
				, FCST_TYPE			NVARCHAR(20)
				, INCOTERMS			NVARCHAR(10)
				, MEASURE			NVARCHAR(50)
				, PLANT_SITE_ID		NVARCHAR(30)
				, CELL_PROD_SITE_ID	NVARCHAR(30)		-- [PJ2025-50017] 소형 매출계획 동기화 개선
				, FROM_SITE_ID		NVARCHAR(30)		-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성
				, YYYYMMDD			NCHAR(8)
				, CURRENCY			NVARCHAR(3)
				, QTY				NUMERIC(30,10)
				, CREATED_BY		NVARCHAR(150)
				, CREATION_DATE		DATETIME
				)

--SELECT * FROM #T_PRICE
PRINT @v_program_name +' : A006--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
				--PRINT 'EXEC_001                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

				-- 신규 정보 추가

				-- Temp 테이블에 저장
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				INSERT INTO #SALES_PLAN_TEMP_LOC
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
					,PLANT_SITE_ID, CELL_PROD_SITE_ID					-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					,FROM_SITE_ID										-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
					,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE)
				-- MKT FCST 값을 update 함.
				select   distinct
				         w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,w.MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID							-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.FROM_SITE_ID									-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
						,w.YYYYMMDD
						,si.CURRENCY
						,w.QTY
						,w.CREATED_BY
						,w.CREATION_DATE
					from #T2_MKT_FCST w  WITH(NOLOCK)
					left outer join #T2_PRICE si WITH(NOLOCK)
					on ( 1=1
						and w.DIVISION_ID   = si.DIVISION_ID
						and w.PROJECT_CODE  = si.PROJECT_CODE
						and w.SCM_SITE_ID   = si.SCM_SITE_ID
						and w.ITEM_ID       = si.ITEM_ID
						and w.DOM_EXP       = si.dom_exp
						and w.fcst_type     = si.fcst_type
						and w.INCOTERMS     = si.INCOTERMS
						and w.plant_site_id = si.plant_site_id
						and w.cell_prod_site_id = si.cell_prod_site_id	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가			
						-- and w.yyyymmdd      = si.yyyymmdd
						and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
					)
					where w.measure in ('MKT_FCST','CUST_FCST','TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD
				------------------------------------------------------------------------------------------------------------------------
				-- 2020/08/06		hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
				------------------------------------------------------------------------------------------------------------------------
				UNION ALL 
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						, CASE WHEN FP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW' 
								WHEN FP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
								END AS MEASURE
						,w.PLANT_SITE_ID
						,w.CELL_PROD_SITE_ID							-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,w.FROM_SITE_ID									-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
						,w.YYYYMMDD
						,fp.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								END AS QTY
						, NULL, NULL
					from #T2_MKT_FCST w  WITH(NOLOCK)
					join #T2_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						and FP.cell_prod_site_id = w.cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						AND FP.MEASURE IN ( 'KRW' , 'LOC' )
					   )
					where w.measure = 'MKT_FCST'
				;

				IF (@v_division_id = '40')
				BEGIN
				
					INSERT INTO #SALES_PLAN_TEMP_LOC
						(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
						,PLANT_SITE_ID, CELL_PROD_SITE_ID						-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,FROM_SITE_ID											-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
						,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE)
					select   distinct
							 w.DIVISION_ID
							,w.PROJECT_CODE
							,w.SCM_SITE_ID
							,w.ITEM_ID
							,w.DOM_EXP
							,w.FCST_TYPE
							,w.INCOTERMS
							,w.MEASURE
							,w.PLANT_SITE_ID
							,w.CELL_PROD_SITE_ID								-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							,w.FROM_SITE_ID										-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
							,w.YYYYMMDD
							,si.CURRENCY
							,w.QTY
							,w.CREATED_BY
							,w.CREATION_DATE
						from #T2_MKT_FCST w  WITH(NOLOCK)
						left outer join #T2_PRICE si WITH(NOLOCK)
						on ( 1=1
							and w.DIVISION_ID   = si.DIVISION_ID
							and w.PROJECT_CODE  = si.PROJECT_CODE
							and w.SCM_SITE_ID   = si.SCM_SITE_ID
							and w.ITEM_ID       = si.ITEM_ID
							and w.DOM_EXP       = si.dom_exp
							and w.fcst_type     = si.fcst_type
							and w.INCOTERMS     = si.INCOTERMS
							and w.plant_site_id = si.plant_site_id
							and w.cell_prod_site_id = si.cell_prod_site_id		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							-- and w.yyyymmdd      = si.yyyymmdd
							and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
						)
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START
						--where w.measure in ('RTF','RTF_SYS_RP', 'RTF_PR')				-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가 
						where w.measure in ('RTF','RTF_SYS_RP', 'RTF_PR', 'RTF_SCP')	-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가 
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 END
					UNION ALL 
					-- KRW 값을 계산
					select   w.DIVISION_ID
							,w.PROJECT_CODE
							,w.SCM_SITE_ID
							,w.ITEM_ID 
							,w.DOM_EXP
							,w.FCST_TYPE
							,w.INCOTERMS
							, CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
									WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
									WHEN FP.MEASURE = 'USD' THEN  'SalesAmt_USD'
									ELSE FP.MEASURE 
									END AS MEASURE
							,w.PLANT_SITE_ID
							,w.CELL_PROD_SITE_ID								-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							,w.FROM_SITE_ID										-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
							,w.YYYYMMDD
							,fp.CURRENCY
							, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
									WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
									WHEN FP.MEASURE = 'USD' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
									end as qty
							, NULL, NULL
						from #T2_MKT_FCST w  WITH(NOLOCK)
						join #T2_PRICE FP  WITH(NOLOCK)
						on (    FP.DIVISION_ID   = w.DIVISION_ID
							AND FP.PROJECT_CODE  = w.PROJECT_CODE
							AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
							AND FP.ITEM_ID       = w.ITEM_ID
							AND FP.DOM_EXP       = w.DOM_EXP
							AND FP.FCST_TYPE     = w.FCST_TYPE
							AND FP.INCOTERMS     = w.INCOTERMS
							and FP.plant_site_id = w.plant_site_id
							and FP.cell_prod_site_id = w.cell_prod_site_id	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
							--AND FP.MEASURE = 'KRW' 
						   )
						where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
					   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
					   and NOT EXISTS (
								select A.DIVISION_ID
								  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
									  ,dm_pln_sales_plan b WITH(NOLOCK)
								 where sales_plan_adjust_yn = 'N'
								   and a.ITEM_ID = b.ITEM_ID
								   and a.DIVISION_ID = b.DIVISION_ID
								   and a.PROJECT_CODE = b.PROJECT_CODE
								   and a.SCM_SITE_ID = b.SCM_SITE_ID
								   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
								   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
								   and a.division_id    = w.division_id
								   and a.project_code   = w.project_code
								   and a.scm_site_id    = w.scm_site_id
								   and a.item_id        = w.item_id
						   ) 
					;
				
				END
				ELSE
				BEGIN
				
					INSERT INTO #SALES_PLAN_TEMP_LOC
						(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
						,PLANT_SITE_ID, CELL_PROD_SITE_ID				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,FROM_SITE_ID									-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
						,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE)
					select   distinct
							 w.DIVISION_ID
							,w.PROJECT_CODE
							,w.SCM_SITE_ID
							,w.ITEM_ID
							,w.DOM_EXP
							,w.FCST_TYPE
							,w.INCOTERMS
							,w.MEASURE
							,w.PLANT_SITE_ID
							,w.CELL_PROD_SITE_ID						-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							,w.FROM_SITE_ID								-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
							,w.YYYYMMDD
							,si.CURRENCY
							,w.QTY
							,w.CREATED_BY
							,w.CREATION_DATE
						from #T2_MKT_FCST w  WITH(NOLOCK)
						left outer join #T2_PRICE si WITH(NOLOCK)
						on ( 1=1
							and w.DIVISION_ID   = si.DIVISION_ID
							and w.PROJECT_CODE  = si.PROJECT_CODE
							and w.SCM_SITE_ID   = si.SCM_SITE_ID
							and w.ITEM_ID       = si.ITEM_ID
							and w.DOM_EXP       = si.dom_exp
							and w.fcst_type     = si.fcst_type
							and w.INCOTERMS     = si.INCOTERMS
							and w.plant_site_id = si.plant_site_id
							--and w.cell_prod_site_id = si.cell_prod_site_id		-- 81/82 사업부는 CELL_PROD_SITE_ID 조건 필요없음
							-- and w.yyyymmdd      = si.yyyymmdd
							and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
						)
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START
						--where w.measure in ('RTF','RTF_SYS_RP', 'RTF_PR')				-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가 
						where w.measure in ('RTF','RTF_SYS_RP', 'RTF_PR', 'RTF_SCP')	-- [PJ2025-50017] SCM_FCST/RTF_PR MEASURE 추가 
					-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 END
					UNION ALL 
					-- KRW 값을 계산
					select   w.DIVISION_ID
							,w.PROJECT_CODE
							,w.SCM_SITE_ID
							,w.ITEM_ID 
							,w.DOM_EXP
							,w.FCST_TYPE
							,w.INCOTERMS
							, CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
									WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
									WHEN FP.MEASURE = 'USD' THEN  'SalesAmt_USD'
									ELSE FP.MEASURE 
									END AS MEASURE
							,w.PLANT_SITE_ID
							,w.CELL_PROD_SITE_ID									-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
							,w.FROM_SITE_ID											-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
							,w.YYYYMMDD	
							,fp.CURRENCY
							, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
									WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
									WHEN FP.MEASURE = 'USD' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
									end as qty
							, NULL, NULL
						from #T2_MKT_FCST w  WITH(NOLOCK)
						join #T2_PRICE FP  WITH(NOLOCK)
						on (    FP.DIVISION_ID   = w.DIVISION_ID
							AND FP.PROJECT_CODE  = w.PROJECT_CODE
							AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
							AND FP.ITEM_ID       = w.ITEM_ID
							AND FP.DOM_EXP       = w.DOM_EXP
							AND FP.FCST_TYPE     = w.FCST_TYPE
							AND FP.INCOTERMS     = w.INCOTERMS
							and FP.plant_site_id = w.plant_site_id
							--and FP.cell_prod_site_id = w.cell_prod_site_id		-- 81/82 사업부도 CELL_PROD_SITE_ID에 데이터 존재함
							AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
							--AND FP.MEASURE = 'KRW' 
						   )
						where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
					   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
					   and NOT EXISTS (
								select A.DIVISION_ID
								  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
									  ,dm_pln_sales_plan b WITH(NOLOCK)
								 where sales_plan_adjust_yn = 'N'
								   and a.ITEM_ID = b.ITEM_ID
								   and a.DIVISION_ID = b.DIVISION_ID
								   and a.PROJECT_CODE = b.PROJECT_CODE
								   and a.SCM_SITE_ID = b.SCM_SITE_ID
								   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
								   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
								   and a.division_id    = w.division_id
								   and a.project_code   = w.project_code
								   and a.scm_site_id    = w.scm_site_id
								   and a.item_id        = w.item_id
						   ) 
					;
								
				END

				
				-- [PJ2025-50188] 2025.07.31 RTF_SYS_RP 가 없고, MKT_FCST 만 존재하는 경우에 RTF_SYS_RP 는 0 데이터로 생성 함(Sales Plan 화면에서 수량 변경을하기 위함) - 필요시 사용 Start
				
				IF (@v_division_id = '40')
				BEGIN
					INSERT INTO #SALES_PLAN_TEMP_LOC
					SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'RTF_SYS_RP' AS MEASURE
						 , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, MAX(FROM_SITE_ID) AS FROM_SITE_ID, A.YYYYMMDD, MAX(CURRENCY) AS CURRENCY
						 , SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)  AS QTY
						 , MIN(CREATED_BY) AS CREATED_BY
						 , MIN(CREATION_DATE) AS CREATION_DATE
					FROM  #SALES_PLAN_TEMP_LOC	A WITH(NOLOCK)
					WHERE 1=1
					AND   A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST')				
					GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
					HAVING SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) = 0 
					AND    SUM(CASE WHEN A.MEASURE = 'MKT_FCST' THEN A.QTY ELSE 0 END) <> 0
					;		
				END
				-- [PJ2025-50188] 2025.07.31 RTF_SYS_RP 가 없고, MKT_FCST 만 존재하는 경우에 RTF_SYS_RP 는 0 데이터로 생성 함(Sales Plan 화면에서 수량 변경을하기 위함) - 필요시 사용 End

				
PRINT @v_program_name +' : A007--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
				-- 확인용
				-- select * from #SALES_PLAN_TEMP_LOC;
				-- 테이블의 중복제거
				   BEGIN
					   DELETE 
					   FROM dbo.dm_pln_sales_plan 
					   WHERE exists(
								SELECT B.DIVISION_ID 
								  FROM #SALES_PLAN_TEMP_LOC B WITH(NOLOCK)
								 where 1=1
								   and dm_pln_sales_plan.DIVISION_ID    =  B.DIVISION_ID  
								   and dm_pln_sales_plan.PROJECT_CODE   =  B.PROJECT_CODE                          
								   and dm_pln_sales_plan.SCM_SITE_ID    =  B.SCM_SITE_ID                           
								   and dm_pln_sales_plan.ITEM_ID        =  B.ITEM_ID                               
								   and dm_pln_sales_plan.DOM_EXP        =  B.DOM_EXP                               
								   and dm_pln_sales_plan.FCST_TYPE      =  B.FCST_TYPE                             
								   and dm_pln_sales_plan.INCOTERMS      =  B.INCOTERMS                             
								   and dm_pln_sales_plan.MEASURE        =  B.MEASURE                               
								   and dm_pln_sales_plan.PLANT_SITE_ID  =  B.PLANT_SITE_ID                         
								   and dm_pln_sales_plan.CELL_PROD_SITE_ID  =  B.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가                    
								   and dm_pln_sales_plan.YYYYMMDD       =  B.YYYYMMDD                              
							  )
				   END
PRINT @v_program_name +' : A008--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
SELECT * FROM #SALES_PLAN_TEMP_LOC

				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				INSERT  INTO  dbo.dm_pln_sales_plan 
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
				,PLANT_SITE_ID, CELL_PROD_SITE_ID				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1																				
				,ATTRIBUTE2																			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
				,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
				SELECT distinct 
					   DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE
					  ,PLANT_SITE_ID, CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,YYYYMMDD,CURRENCY,QTY
					  ,ISNULL(CREATED_BY, @v_created_by) , ISNULL(CREATION_DATE, GETDATE())
					  ,@v_created_by, SYSDATETIME() as LAST_UPDATE_DATE
					  , NULL						AS ATTRIBUTE1									-- SALES_AMT MEASURE에 부서코드 사용하고 있음.
					  , FROM_SITE_ID				AS ATTRIBUTE2									-- [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
					  , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
				FROM #SALES_PLAN_TEMP_LOC WITH(NOLOCK) 
PRINT @v_program_name +' : A009--' + CONVERT(VARCHAR(30), GETDATE(), 121);	
		    END
			
PRINT @v_program_name +' : A010--' + CONVERT(VARCHAR(30), GETDATE(), 121);	

          /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/


		  --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 START
				DELETE DM_PLN_SALES_ETC_PLAN
				WHERE 1=1
				AND   DIVISION_ID = @v_division_id
				AND   YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				AND   MEASURE IN ('SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up') --Catch_Up 관련 메저만 삭제

				INSERT INTO DM_PLN_SALES_ETC_PLAN (DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
							,INCOTERMS,MEASURE,PLANT_SITE_ID
							,YYYYMMDD,QTY,CURRENCY,CREATED_BY,CREATION_DATE
							,LAST_UPDATED_BY,LAST_UPDATE_DATE,REMARK_TEXT
							)
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE,A.INCOTERMS
						, CASE WHEN B.MEASURE = 'KRW' THEN 'SalesAmt_KRW_Catch_Up'
							WHEN B.MEASURE = 'LOC' THEN 'SalesAmt_LOC_Catch_Up'
							WHEN B.MEASURE = 'USD' THEN  'SalesAmt_USD_Catch_Up'
							ELSE B.MEASURE 
						END AS MEASURE
						, A.PLANT_SITE_ID
						, A.YYYYMMDD
						, CASE WHEN B.MEASURE = 'KRW' THEN CAST( STR( A.QTY * ISNULL (B.PRICE , 0) , 20, 5 ) AS NUMERIC(30, 10))
							WHEN B.MEASURE = 'LOC' THEN CAST( STR( A.QTY * ISNULL (B.PRICE , 0) , 20, 5 ) AS NUMERIC(30, 10))
							WHEN B.MEASURE = 'USD' THEN CAST( STR( A.QTY * ISNULL (B.PRICE , 0) , 20, 5 ) AS NUMERIC(30, 10))
						END AS QTY
						, B.CURRENCY 
						, A.CREATED_BY, A.CREATION_DATE
						, A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE
						, A.REMARK_TEXT
				FROM DM_PLN_SALES_ETC_PLAN A  WITH(NOLOCK)
				JOIN #T_PRICE B  WITH(NOLOCK)
				ON (    A.DIVISION_ID   = B.DIVISION_ID
					AND A.PROJECT_CODE  = B.PROJECT_CODE
					AND A.SCM_SITE_ID   = B.SCM_SITE_ID
					AND A.ITEM_ID       = B.ITEM_ID
					AND A.DOM_EXP       = B.DOM_EXP
					AND A.FCST_TYPE     = B.FCST_TYPE
					AND A.INCOTERMS     = B.INCOTERMS
					AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
					AND B.YYYYMMDD = ( SELECT BASIS_START_DATE FROM [DBO].[SCM_SYS_CALENDAR_M] WHERE BASIS_YYYYMMDD = A.YYYYMMDD )
					)
				WHERE A.MEASURE = 'Catch_Up' 
				AND   A.DIVISION_ID = @v_division_id
				AND   B.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				AND   B.MEASURE IN ( 'KRW', 'LOC', 'USD' )

		  --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 END
  
		  --[E20250507-000390]_Sales Plan UI 환율 재계산 기능 추가 START
		  		DELETE DM_PLN_SALES_ETC_PLAN
				WHERE 1=1
				AND   DIVISION_ID = @v_division_id
				AND   YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				AND   MEASURE IN ('SalesAmt_KRW', 'SalesAmt_USD')
				AND   FCST_TYPE = 'ETC'

				--SalesAmt_KRW 계산하기
				INSERT INTO DM_PLN_SALES_ETC_PLAN 
				( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT
				, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				, YYYYMMDD, CURRENCY
				, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
				, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
				, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10	)
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.REMARK_TEXT
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'SalesAmt_KRW' AS MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , QTY =  (SELECT CASE WHEN A.CURRENCY = 'KRW' THEN A.QTY 
									  	   ELSE
												CASE WHEN A.CURRENCY = 'USD' THEN ISNULL(CAST(A.QTY AS NUMERIC(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) 
													 																	   FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																														   WHERE DIVISION_ID = A.DIVISION_ID  
																														   AND YYYYMMDD = SUBSTRING(A.YYYYMMDD, 1, 6) + '01' 
																														   AND UNIT_CURRENCY = 'USD' 
																														   AND CURRENCY = 'KRW' 
																														   GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0)
													 ELSE
														 CASE WHEN A.CURRENCY NOT IN ('KRW','USD') THEN ISNULL(CAST(A.QTY AS NUMERIC(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) 
																																				 FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																																				 WHERE DIVISION_ID = A.DIVISION_ID  
																																				 AND YYYYMMDD = SUBSTRING(A.YYYYMMDD, 1, 6) + '01' 
																																				 AND UNIT_CURRENCY = A.CURRENCY 
																																				 AND CURRENCY = 'KRW' 
																																				 GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0) 
														END
												END
									  END )
					 , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1
					 , A.ATTRIBUTE2, A.ATTRIBUTE3 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
					 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
				FROM DM_PLN_SALES_ETC_PLAN A WITH(NOLOCK)
				WHERE A.MEASURE = 'SalesAmt_LOC' 
				AND   A.DIVISION_ID = @v_division_id
				AND   A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				AND   A.FCST_TYPE = 'ETC'

				INSERT INTO DM_PLN_SALES_ETC_PLAN 
				( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT
				, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				, YYYYMMDD, CURRENCY
				, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
				, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
				, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10	)
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.REMARK_TEXT
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , QTY = ( SELECT CASE WHEN A.CURRENCY = 'KRW' THEN ISNULL(CAST(A.QTY AS NUMERIC(30,10)) / (SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) 
										   																		FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																												WHERE DIVISION_ID = A.DIVISION_ID  
																												AND YYYYMMDD = SUBSTRING(A.YYYYMMDD, 1, 6) + '01' 
																												AND UNIT_CURRENCY = 'USD' 
																												AND CURRENCY = 'KRW' 
																												GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0)
										   ELSE
									  CASE WHEN A.CURRENCY = 'USD' THEN A.QTY 
										   ELSE
									  CASE WHEN A.CURRENCY NOT IN ('KRW','USD') THEN ISNULL(CAST(A.QTY AS NUMERIC(30,10)) * (SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) 
																															FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																															WHERE DIVISION_ID = A.DIVISION_ID  
																															AND YYYYMMDD = SUBSTRING(A.YYYYMMDD, 1, 6) + '01' 
																															AND UNIT_CURRENCY = A.CURRENCY 
																															AND CURRENCY = 'KRW' 
																															GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))),0)
																															/ (SELECT CAST(EXCHANGE_PRICE AS NUMERIC(14,4)) 
																															   FROM DM_MST_EXCHANGE_RATE WITH(NOLOCK) 
																															   WHERE DIVISION_ID = A.DIVISION_ID  
																															   AND YYYYMMDD = SUBSTRING(A.YYYYMMDD, 1, 6) + '01' 
																															   AND UNIT_CURRENCY = 'USD' 
																															   AND CURRENCY = 'KRW' 
																															   GROUP BY CAST(EXCHANGE_PRICE AS NUMERIC(14,4))) 
									  END
									  END
									  END )
					 , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1
					 , A.ATTRIBUTE2, A.ATTRIBUTE3 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
					 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
				FROM DM_PLN_SALES_ETC_PLAN A  WITH(NOLOCK)
				WHERE A.MEASURE = 'SalesAmt_LOC' 
				AND   A.DIVISION_ID = @v_division_id
				AND   A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				AND   A.FCST_TYPE = 'ETC'
		  --[E20250507-000390]_Sales Plan UI 환율 재계산 기능 추가 END

		END	
        /*---------------------------------------------------------------*/

		--[PJ2025-50017] 소형 매출계획 동기화 개선 Start - DM_PLN_CFM_MKT_DEMAND_PLAN 의 MKT_AMT 업데이트
		BEGIN
			MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN A
			USING 
			(
				SELECT A.DIVISION_ID
						,A.PROJECT_CODE
						,A.END_CUSTOMER
						,A.SCM_SITE_ID
						,A.ITEM_ID 
						,A.DOM_EXP
						,A.FCST_TYPE
						,A.INCOTERMS
						, CASE	WHEN B.MEASURE = 'KRW' THEN 'MKT_AMT_KRW' 
								WHEN B.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
							END					AS MEASURE
						,A.PLANT_SITE_ID
						,A.CELL_PROD_SITE_ID					-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,A.YYYYMMDD
						, CASE WHEN B.MEASURE = 'KRW' THEN cast( STR( A.QTY * isnull (B.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN B.MEASURE = 'LOC' THEN cast( STR( A.QTY * isnull (B.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								END				AS QTY
					  , ISNULL(A.CREATED_BY, @v_created_by)			AS CREATED_BY
					  , ISNULL(A.CREATION_DATE, GETDATE())			AS CREATION_DATE
					  ,@v_created_by								AS LAST_UPDATED_BY
					  , SYSDATETIME()								AS LAST_UPDATE_DATE
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
				INNER JOIN DM_PLN_CFM_SELLING_PRICE B WITH(NOLOCK)
				ON  A.DIVISION_ID		= B.DIVISION_ID
				AND A.PROJECT_CODE		= B.PROJECT_CODE
				AND A.END_CUSTOMER		= B.END_CUSTOMER
				AND A.SCM_SITE_ID		= B.SCM_SITE_ID
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.DOM_EXP			= B.DOM_EXP
				AND A.FCST_TYPE			= B.FCST_TYPE
				AND A.INCOTERMS			= B.INCOTERMS
				AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
				AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID	-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				AND B.MEASURE IN ( 'KRW' , 'LOC' )
				AND (select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = A.YYYYMMDD) = B.YYYYMMDD			 
				WHERE A.DIVISION_ID = @p_division_id
				AND   A.MEASURE = 'MKT_FCST'
			) B
			ON (		 A.DIVISION_ID			=  B.DIVISION_ID
					AND  A.PROJECT_CODE			=  B.PROJECT_CODE                         
					AND  A.END_CUSTOMER			=  B.END_CUSTOMER                         
					AND  A.SCM_SITE_ID			=  B.SCM_SITE_ID                         
					AND  A.ITEM_ID				=  B.ITEM_ID   
					AND  A.DOM_EXP				=  B.DOM_EXP                         
					AND  A.FCST_TYPE			=  B.FCST_TYPE                         
					AND  A.INCOTERMS			=  B.INCOTERMS 
					AND  A.MEASURE				=  B.MEASURE                         
					AND  A.PLANT_SITE_ID		=  B.PLANT_SITE_ID                         
					AND  A.CELL_PROD_SITE_ID	=  B.CELL_PROD_SITE_ID		-- [PJ2025-50017] CELL_PROD_SITE_ID 추가                    
					AND  A.YYYYMMDD				=  B.YYYYMMDD 
			)
			WHEN MATCHED THEN
				UPDATE 
					SET   A.QTY					= B.QTY
						, A.LAST_UPDATED_BY		= B.LAST_UPDATED_BY	
						, A.LAST_UPDATE_DATE	= B.LAST_UPDATE_DATE
			WHEN NOT MATCHED THEN
				INSERT ( DIVISION_ID
						,PROJECT_CODE
						,END_CUSTOMER
						,SCM_SITE_ID
						,ITEM_ID
						,DOM_EXP
						,FCST_TYPE
						,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID
						,CELL_PROD_SITE_ID				-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
						,YYYYMMDD
						,QTY
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
				) 
				VALUES(  B.DIVISION_ID
						,B.PROJECT_CODE
						,B.END_CUSTOMER
						,B.SCM_SITE_ID
						,B.ITEM_ID
						,B.DOM_EXP
						,B.FCST_TYPE
						,B.INCOTERMS
						,B.MEASURE
						,B.PLANT_SITE_ID
						,B.CELL_PROD_SITE_ID			-- [PJ2025-50017] CELL_PROD_SITE_ID 추가		
						,B.YYYYMMDD
						,B.QTY
						,B.CREATED_BY
						,B.CREATION_DATE
						,B.LAST_UPDATED_BY
						,B.LAST_UPDATE_DATE
				)
			;
		END
		--[PJ2025-50017] 소형 매출계획 동기화 개선 End


		-- [PJ2025-50188] 환율 변경시 DM_PLN_SALES_PLAN_RESULT에 SALES_AMT_KRW / MKT_AMT_KRW 재생성 Start
		IF (@p_division_id = '40')
		BEGIN

			DELETE 
			FROM	dbo.DM_PLN_SALES_PLAN_RESULT
			WHERE	DIVISION_ID = @p_division_id
			AND     MEASURE in ('SalesAmt_KRW', 'MKT_AMT_KRW')
			AND		YYYYMMDD >= @v_start_yyyymmdd		-- 당월 1일 (yyyymmdd)
			AND		YYYYMMDD <  @v_end_yyyymmdd			-- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
			;

			-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW 생성 Start
			INSERT dbo.DM_PLN_SALES_PLAN_RESULT
				( DIVISION_ID,COMPANY_ID,PROJECT_CODE,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
				,INCOTERMS
				,MEASURE
				,YYYYMMDD,CURRENCY
				,QTY
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2
				,CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)
			SELECT A.DIVISION_ID, A.COMPANY_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
				, A.INCOTERMS
				, C.MEASURE						-- [PJ2025-50188] SalesAmt_LOC*QTY ==> MKT_AMT_KRW / SalesAmt_KRW 생성함.	SalesAmt_LOC와 MKT_AMT_LOC 값은 동일하므로 SalesAmt_LOC 데이터 기반으로 생성함.
				, A.YYYYMMDD, A.CURRENCY
				, A.QTY * B.EXCHANGE_PRICE				AS QTY
				, A.CREATED_BY
				, GETDATE()				AS CREATION_DATE
				, A.LAST_UPDATED_BY
				, GETDATE()				AS LAST_UPDATE_DATE
				, A.ATTRIBUTE1,A.ATTRIBUTE2
				, A.CELL_PROD_SITE_ID				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			FROM dbo.DM_PLN_SALES_PLAN_RESULT A WITH(NOLOCK)
			INNER JOIN DM_MST_EXCHANGE_RATE B WITH(NOLOCK)
			ON	A.DIVISION_ID	= B.DIVISION_ID
			AND	SUBSTRING(A.YYYYMMDD,1,6) + '01'= B.YYYYMMDD		-- EXCHANGE는 월별로 1일에 데이터가 있음 
			AND	A.CURRENCY		= B.UNIT_CURRENCY
			AND B.CURRENCY		= 'KRW'
			INNER JOIN (SELECT 'MKT_AMT_KRW' AS MEASURE UNION ALL SELECT 'SalesAmt_KRW' AS MEASURE ) C
			ON 1=1
			WHERE A.DIVISION_ID = @p_division_id
			AND A.MEASURE = 'SalesAmt_LOC'
			AND A.YYYYMMDD >= @v_start_yyyymmdd			-- 당월 1일 (yyyymmdd)
			AND A.YYYYMMDD <  @v_end_yyyymmdd			-- 당일 (yyyymmdd) / [PJ2025-50188] 당일은 제외되어야 함.
			-- [PJ2025-50188] 환율반영한 SALES_AMT_KRW 생성 End


		END
		-- [PJ2025-50188] 환율 변경시 DM_PLN_SALES_PLAN_RESULT에 SALES_AMT_KRW / MKT_AMT_KRW 재생성 End



		-- [PJ2025-50188] 임시테이블 DROP 처리 Start
		BEGIN
			IF OBJECT_ID('tempdb..#T2_MKT_FCST') IS NOT NULL
				DROP TABLE  #T2_MKT_FCST;         
			IF OBJECT_ID('tempdb..#T2_PRICE') IS NOT NULL
				DROP TABLE  #T2_PRICE;          
		END
		-- [PJ2025-50188] 임시테이블 DROP 처리 End


     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    IF @v_log_message IS NULL
		BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '@p_division_id : ' + @p_division_id + ' / ' +'@v_created_by : ' +  ISNULL(@v_created_by, 'NULL');
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END

  END;



