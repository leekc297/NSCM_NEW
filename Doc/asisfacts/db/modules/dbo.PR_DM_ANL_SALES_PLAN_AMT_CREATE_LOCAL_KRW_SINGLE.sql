
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
*===================================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE]
	-- Add the parameters for the stored procedure here
	--@p_division_id				NVARCHAR(MAX)		,
	--@p_CREATED_BY               NVARCHAR(MAX)	
AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    DECLARE @v_division_id      NVARCHAR(MAX);
	DECLARE @v_created_by       NVARCHAR(MAX);
	
	--=====================================================================================================================================================
	-- LOG 용 변수 설정 (START)
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	-- LOG 용 변수 설정 (END)
	--=====================================================================================================================================================
	
	--=====================================================================================================================================================	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
	--=====================================================================================================================================================

	-- 트랜잭션 (START)
	BEGIN TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE;
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------			
        /*------------------------------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/
		BEGIN			
			-- 사용자정보값 변수에 저장 20180824 KHSONG
			SET @v_created_by = (SELECT TOP 1 v_CREATED_BY FROM #results)

			-- 기존 정보 삭제
			DELETE DM_PLN_SALES_PLAN
			-- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
			WHERE YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			----------------------------------------------------------- 20180510 skh add start
			AND EXISTS ( SELECT v_DIVISION_ID
						  FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
						 WHERE 1=1
						   AND DIVISION_ID        = v_DIVISION_ID         
						   AND PROJECT_CODE       = v_PROJECT_CODE      
						   AND SCM_SITE_ID        = v_SCM_SITE_ID
						   AND ITEM_ID            = v_ITEM_ID     
						   AND DOM_EXP            = v_DOM_EXP      
						   AND FCST_TYPE          = v_FCST_TYPE      
						   AND INCOTERMS          = v_INCOTERMS  
						   AND PLANT_SITE_ID      = v_PLANT_SITE_ID ) 
			----------------------------------------------------------- 20180510 skh add end
			-- MKT/금형비처럼 사람이 넣은것 삭제.
			AND ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
			-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
			AND NOT EXISTS ( SELECT A.DIVISION_ID
							   FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
								  , DM_PLN_SALES_PLAN B WITH(NOLOCK)
							  WHERE SALES_PLAN_ADJUST_YN = 'N'
							    AND A.ITEM_ID			= B.ITEM_ID
							    AND A.DIVISION_ID		= B.DIVISION_ID
							    AND A.PROJECT_CODE		= B.PROJECT_CODE
							    AND A.SCM_SITE_ID		= B.SCM_SITE_ID
							    AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF')
							    AND B.YYYYMMDD			>= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
							    AND A.DIVISION_ID		= DM_PLN_SALES_PLAN.DIVISION_ID
							    AND A.PROJECT_CODE		= DM_PLN_SALES_PLAN.PROJECT_CODE
							    AND A.SCM_SITE_ID		= DM_PLN_SALES_PLAN.SCM_SITE_ID
							    AND A.ITEM_ID			= DM_PLN_SALES_PLAN.ITEM_ID ) 
			--[E20250121-000405]_Sales Plan에서 Catch-up 메저 삭제되는 현상 조정
			AND MEASURE NOT IN ('CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up') --Catch Up 메저 삭제 금지
			;   
				                  
            -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
			DELETE DM_PLN_SALES_PLAN
			WHERE YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			----------------------------------------------------------- 20180510 skh add start
			AND EXISTS ( SELECT v_DIVISION_ID 
						   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
						  WHERE 1=1
						    AND DIVISION_ID        = v_DIVISION_ID         
						    AND PROJECT_CODE       = v_PROJECT_CODE      
						    AND SCM_SITE_ID        = v_SCM_SITE_ID
						    AND ITEM_ID            = v_ITEM_ID     
						    AND DOM_EXP            = v_DOM_EXP      
						    AND FCST_TYPE          = v_FCST_TYPE      
						    AND INCOTERMS          = v_INCOTERMS  
						    AND PLANT_SITE_ID      = v_PLANT_SITE_ID )
			----------------------------------------------------------- 20180510 skh add end
			-- MKT/금형비처럼 사람이 넣은것 삭제.
			AND ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
			AND MEASURE IN ( 'MKT_FCST','CUST_FCST', 'RTF' ,'RTF_SYS_RP','TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD--[PJ2025-50017] SCM_FCST 추가
			;

			-- 임시테이블 확인후 삭제
			IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
			BEGIN 
				DROP TABLE #SALES_PLAN_TEMP          
			END 

			-- 임시테이블 생성
			-- 20191114 KHSONG 컬럼값 미지정에서 지정으로 보완
			SELECT TOP 0 
				   DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
				 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			 INTO #SALES_PLAN_TEMP  
			 FROM DM_PLN_SALES_PLAN WITH(NOLOCK)

			-- 신규 정보 추가
			-- Temp 테이블에 저장
			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY
			, QTY
			, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
			, ATTRIBUTE9, ATTRIBUTE10 )
			-- MKT FCST 값을 update 함.
			SELECT DISTINCT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID	-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, SI.CURRENCY
				 , W.QTY
				 , ISNULL(W.CREATED_BY,'SYSTEM'), W.CREATION_DATE --,w.LAST_UPDATED_BY	--[2018-03-15][수정] 	--,w.LAST_UPDATE_DATE --[2018-03-15][수정]
				 , @v_created_by, GETDATE()	--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
				 , NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			  FROM DM_PLN_MKT_FCST W WITH(NOLOCK)
			  LEFT OUTER JOIN SCM_MST_FUTURE_PRICE SI WITH(NOLOCK)
						   ON ( 1=1
						  AND W.DIVISION_ID   = SI.DIVISION_ID
						  AND W.PROJECT_CODE  = SI.PROJECT_CODE
						  AND W.SCM_SITE_ID   = SI.SCM_SITE_ID
						  AND W.ITEM_ID       = SI.ITEM_ID
						  AND W.DOM_EXP       = SI.DOM_EXP
						  AND W.FCST_TYPE     = SI.FCST_TYPE
						  AND W.INCOTERMS     = SI.INCOTERMS
						  AND W.PLANT_SITE_ID = SI.PLANT_SITE_ID
						  -- AND W.YYYYMMDD      = si.YYYYMMDD
						  AND ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD ) = SI.YYYYMMDD )
			  WHERE W.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST', 'SCM_FCST')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD --[PJ2025-50017] SCM_FCST 추가
				AND EXISTS ( SELECT v_DIVISION_ID 
							   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
							  WHERE 1=1
							    AND W.DIVISION_ID        = v_DIVISION_ID         
							    AND W.PROJECT_CODE       = v_PROJECT_CODE      
							    AND W.SCM_SITE_ID        = v_SCM_SITE_ID
							    AND W.ITEM_ID            = v_ITEM_ID     
							    AND W.DOM_EXP            = v_DOM_EXP      
							    AND W.FCST_TYPE          = v_FCST_TYPE      
							    AND W.INCOTERMS          = v_INCOTERMS  
							    AND W.PLANT_SITE_ID      = v_PLANT_SITE_ID ) 
				AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
			------------------------------------------------------------------------------------------------------------------------
			-- 2020/08/06		hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
			------------------------------------------------------------------------------------------------------------------------
			UNION ALL 
			-- KRW 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'MKT_AMT_KRW' AS MEASURE, W.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID			-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY
				 , CAST( STR( W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) AS QTY -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --, W.CREATED_BY --[2018-03-15][수정] --, W.CREATION_DATE --[2018-03-15][수정] --, W.LAST_UPDATED_BY --[2018-03-15][수정] --, W.LAST_UPDATE_DATE --[2018-03-15][수정]
				 , @v_created_by, GETDATE()	--[2018-03-15][수정]
				 , 'SYSTEM' /*--[2018-03-15][수정]*/	, GETDATE() --[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
				 , NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			  FROM DM_PLN_MKT_FCST W WITH(NOLOCK)
			  LEFT OUTER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
						   ON ( FP.DIVISION_ID   = W.DIVISION_ID
						  AND	FP.PROJECT_CODE  = W.PROJECT_CODE
						  AND	FP.SCM_SITE_ID   = W.SCM_SITE_ID
						  AND	FP.ITEM_ID       = W.ITEM_ID
						  AND	FP.DOM_EXP       = W.DOM_EXP
						  AND	FP.FCST_TYPE     = W.FCST_TYPE
						  AND	FP.INCOTERMS     = W.INCOTERMS
						  and	FP.PLANT_SITE_ID = W.PLANT_SITE_ID
						  AND	FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
						  AND	FP.MEASURE = 'KRW' )
				--where w.measure = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
			  WHERE W.MEASURE = 'MKT_FCST'
				AND W.DIVISION_ID = '40'
				AND EXISTS ( SELECT v_DIVISION_ID 
							   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
							  WHERE 1=1
							    AND W.DIVISION_ID        = v_DIVISION_ID         
							    AND W.PROJECT_CODE       = v_PROJECT_CODE      
							    AND W.SCM_SITE_ID        = v_SCM_SITE_ID
							    AND W.ITEM_ID            = v_ITEM_ID     
							    AND W.DOM_EXP            = v_DOM_EXP      
							    AND W.FCST_TYPE          = v_FCST_TYPE      
							    AND W.INCOTERMS          = v_INCOTERMS  
							    AND W.PLANT_SITE_ID      = v_PLANT_SITE_ID )
				AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				AND W.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
			UNION ALL 
			-- LOC 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'MKT_AMT_LOC' AS MEASURE, W.PLANT_SITE_ID, '-'	AS CELL_PROD_SITE_ID			-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY
				 --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST( STR( W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --, W.CREATED_BY --[2018-03-15][수정]	--, W.CREATION_DATE --[2018-03-15][수정] --, W.LAST_UPDATED_BY --[2018-03-15][수정] --, W.LAST_UPDATE_DATE --[2018-03-15][수정]
				 , @v_created_by, GETDATE()	--[2018-03-15][수정]
				 , 'SYSTEM' /*--[2018-03-15][수정]*/	, GETDATE()	--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
				 , NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
			  FROM DM_PLN_MKT_FCST W WITH(NOLOCK)
			  LEFT OUTER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)
						   ON ( FP.DIVISION_ID   = W.DIVISION_ID
						  AND   FP.PROJECT_CODE  = W.PROJECT_CODE
						  AND   FP.SCM_SITE_ID   = W.SCM_SITE_ID
						  AND   FP.ITEM_ID       = W.ITEM_ID
						  AND   FP.DOM_EXP       = W.DOM_EXP
						  AND   FP.FCST_TYPE     = W.FCST_TYPE
						  AND   FP.INCOTERMS     = W.INCOTERMS
						  AND   FP.PLANT_SITE_ID = W.PLANT_SITE_ID
						  AND   FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
						  AND   FP.MEASURE = 'LOC' )
			  WHERE W.MEASURE = 'MKT_FCST'
				AND W.DIVISION_ID ='40'
				AND EXISTS ( SELECT v_DIVISION_ID   
							   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
							  WHERE 1=1
							    AND W.DIVISION_ID        = v_DIVISION_ID         
							    AND W.PROJECT_CODE       = v_PROJECT_CODE      
							    AND W.SCM_SITE_ID        = v_SCM_SITE_ID
							    AND W.ITEM_ID            = v_ITEM_ID     
							    AND W.DOM_EXP            = v_DOM_EXP      
							    AND W.FCST_TYPE          = v_FCST_TYPE      
							    AND W.INCOTERMS          = v_INCOTERMS  
							    AND W.PLANT_SITE_ID      = v_PLANT_SITE_ID ) 
				AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   
				AND W.ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
				;

			--[PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. (Start)

			INSERT INTO #SALES_PLAN_TEMP
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY
			, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7 ,ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			-- RTF 값을 update 함.
			SELECT DISTINCT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID --[PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가	
				 , W.YYYYMMDD, SI.CURRENCY, W.QTY
				 , ISNULL(W.CREATED_BY, 'SYSTEM'), W.CREATION_DATE
				  --, W.LAST_UPDATED_BY --[2018-03-15][수정] --, W.LAST_UPDATE_DATE --[2018-03-15][수정]
				 , @v_created_by, GETDATE()	--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
				 , NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
				--from dbo.dm_pln_mkt_fcst w WITH(NOLOCK)
			  FROM DM_PLN_CFM_MKT_DEMAND_PLAN W WITH(NOLOCK)		
			  LEFT OUTER JOIN SCM_MST_FUTURE_PRICE SI WITH(NOLOCK)		
						   ON ( 1=1
						  AND	W.DIVISION_ID   = SI.DIVISION_ID
						  AND	W.PROJECT_CODE  = SI.PROJECT_CODE
						  AND	W.SCM_SITE_ID   = SI.SCM_SITE_ID
						  AND	W.ITEM_ID       = SI.ITEM_ID
						  AND	W.DOM_EXP       = SI.dom_exp
						  AND	W.FCST_TYPE     = SI.FCST_TYPE
						  AND	W.INCOTERMS     = SI.INCOTERMS
						  AND	W.PLANT_SITE_ID = SI.PLANT_SITE_ID
						  -- AND W.YYYYMMDD      = SI.YYYYMMDD
						  AND ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD ) = SI.YYYYMMDD )
			  WHERE W.MEASURE IN ('RTF','RTF_SYS_RP')
				AND EXISTS ( SELECT v_DIVISION_ID   
							   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
							  WHERE 1=1
							    AND W.DIVISION_ID        = v_DIVISION_ID         
							    AND W.PROJECT_CODE       = v_PROJECT_CODE      
							    AND W.SCM_SITE_ID        = v_SCM_SITE_ID
							    AND W.ITEM_ID            = v_ITEM_ID     
							    AND W.DOM_EXP            = v_DOM_EXP      
							    AND W.FCST_TYPE          = v_FCST_TYPE      
							    AND W.INCOTERMS          = v_INCOTERMS  
							    AND W.PLANT_SITE_ID      = v_PLANT_SITE_ID ) 
				AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
			UNION ALL
			-- KRW 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_KRW' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID -- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가				
				 , W.YYYYMMDD, FP.CURRENCY
				 --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST( STR( W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))   -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --, W.CREATED_BY --[2018-03-15][수정] --, W.CREATION_DATE --[2018-03-15][수정] --, W.LAST_UPDATED_BY --[2018-03-15][수정] --, W.LAST_UPDATE_DATE	 --[2018-03-15][수정]
				 , @v_created_by, GETDATE()	--[2018-03-15][수정]
				 , 'SYSTEM' /*--[2018-03-15][수정]*/	, GETDATE() --[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
				 , NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
				--from dbo.dm_pln_mkt_fcst w WITH(NOLOCK)
			  FROM DM_PLN_CFM_MKT_DEMAND_PLAN W WITH(NOLOCK)		
			  LEFT OUTER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)		
						   ON ( FP.DIVISION_ID   = W.DIVISION_ID
						  AND	FP.PROJECT_CODE  = W.PROJECT_CODE
						  AND	FP.SCM_SITE_ID   = W.SCM_SITE_ID
						  AND	FP.ITEM_ID       = W.ITEM_ID
						  AND	FP.DOM_EXP       = W.DOM_EXP
						  AND	FP.FCST_TYPE     = W.FCST_TYPE
						  AND	FP.INCOTERMS     = W.INCOTERMS
						  AND	FP.PLANT_SITE_ID = W.PLANT_SITE_ID
						  AND	FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
						  AND	FP.MEASURE = 'KRW' )
				--where w.measure = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
				--where w.measure = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
			  WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
				AND EXISTS ( SELECT v_DIVISION_ID 
							   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
							  WHERE 1=1
							    AND W.DIVISION_ID        = v_DIVISION_ID         
							    AND W.PROJECT_CODE       = v_PROJECT_CODE      
							    AND W.SCM_SITE_ID        = v_SCM_SITE_ID
							    AND W.ITEM_ID            = v_ITEM_ID     
							    AND W.DOM_EXP            = v_DOM_EXP      
							    AND W.FCST_TYPE          = v_FCST_TYPE      
							    AND W.INCOTERMS          = v_INCOTERMS  
							    AND W.PLANT_SITE_ID      = v_PLANT_SITE_ID )
				AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
				AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
				-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				AND NOT EXISTS ( SELECT A.DIVISION_ID
								   FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
									  , DM_PLN_SALES_PLAN B WITH(NOLOCK)
								  WHERE SALES_PLAN_ADJUST_YN = 'N'
								  AND A.ITEM_ID				= B.ITEM_ID
								  AND A.DIVISION_ID			= B.DIVISION_ID
								  AND A.PROJECT_CODE		= B.PROJECT_CODE
								  AND A.SCM_SITE_ID			= B.SCM_SITE_ID
								  AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF')
								  AND B.YYYYMMDD			>= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
								  AND A.DIVISION_ID			= W.DIVISION_ID
								  AND A.PROJECT_CODE		= W.PROJECT_CODE
								  AND A.SCM_SITE_ID			= W.SCM_SITE_ID
								  AND A.ITEM_ID				= W.ITEM_ID ) 
			UNION ALL
			-- LOC 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_LOC' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID 							-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY
				 --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST( STR( W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --, w.CREATED_BY --[2018-03-15][수정] --, W.CREATION_DATE	--[2018-03-15][수정] --, W.LAST_UPDATED_BY	--[2018-03-15][수정]	--, W.LAST_UPDATE_DATE	--[2018-03-15][수정]
				 , @v_created_by, GETDATE()	--[2018-03-15][수정]
				 , 'SYSTEM' /*--[2018-03-15][수정]*/	, GETDATE()	--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
				 , NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
				--from dbo.dm_pln_mkt_fcst w WITH(NOLOCK)
			  FROM DM_PLN_CFM_MKT_DEMAND_PLAN W WITH(NOLOCK)		
			  LEFT OUTER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)	
						   ON ( FP.DIVISION_ID   = W.DIVISION_ID
						  AND   FP.PROJECT_CODE	 = W.PROJECT_CODE
						  AND   FP.SCM_SITE_ID   = W.SCM_SITE_ID
						  AND   FP.ITEM_ID       = W.ITEM_ID
						  AND   FP.DOM_EXP       = W.DOM_EXP
						  AND   FP.FCST_TYPE     = W.FCST_TYPE
						  AND   FP.INCOTERMS     = W.INCOTERMS
						  AND   FP.PLANT_SITE_ID = W.PLANT_SITE_ID
						  AND   FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
						  AND   FP.MEASURE = 'LOC' )
				--where w.measure = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
				--where w.measure = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
			  WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
				AND EXISTS ( SELECT v_DIVISION_ID   
							   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
							  WHERE 1=1
							    AND W.DIVISION_ID        = v_DIVISION_ID         
							    AND W.PROJECT_CODE       = v_PROJECT_CODE      
							    AND W.SCM_SITE_ID        = v_SCM_SITE_ID
							    AND W.ITEM_ID            = v_ITEM_ID     
							    AND W.DOM_EXP            = v_DOM_EXP      
							    AND W.FCST_TYPE          = v_FCST_TYPE      
							    AND W.INCOTERMS          = v_INCOTERMS  
							    AND W.PLANT_SITE_ID      = v_PLANT_SITE_ID ) 
				AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   
				AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
				-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				AND NOT EXISTS ( SELECT A.DIVISION_ID
								   FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
									  , DM_PLN_SALES_PLAN B WITH(NOLOCK)
								  WHERE SALES_PLAN_ADJUST_YN = 'N'
									AND A.ITEM_ID				= b.ITEM_ID
									AND A.DIVISION_ID			= b.DIVISION_ID
									AND A.PROJECT_CODE			= b.PROJECT_CODE
									AND A.SCM_SITE_ID			= b.SCM_SITE_ID
									AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM','CUTOFF')
									AND B.YYYYMMDD				>= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
									AND A.DIVISION_ID			= W.DIVISION_ID
									AND A.PROJECT_CODE			= W.PROJECT_CODE
									AND A.SCM_SITE_ID			= W.SCM_SITE_ID
									AND A.ITEM_ID				= W.ITEM_ID ) 
			UNION ALL 
			-- LOC 값을 계산
			SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, 'SalesAmt_USD' AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID 							-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
				 , W.YYYYMMDD, FP.CURRENCY
				 --,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
				 , CAST( STR( W.QTY * ISNULL(FP.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
				 --, W.CREATED_BY --[2018-03-15][수정] --, W.CREATION_DATE --[2018-03-15][수정] --, W.LAST_UPDATED_BY --[2018-03-15][수정] --, W.LAST_UPDATE_DATE	 --[2018-03-15][수정]
				 , @v_created_by, GETDATE()	--[2018-03-15][수정]
				 , 'SYSTEM' /*--[2018-03-15][수정]*/	, GETDATE()	--[2018-03-15][수정]
				 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
				 , NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
				--from dbo.dm_pln_mkt_fcst w WITH(NOLOCK)
			  FROM DM_PLN_CFM_MKT_DEMAND_PLAN W WITH(NOLOCK)		
			  LEFT OUTER JOIN SCM_MST_FUTURE_PRICE FP WITH(NOLOCK)	
						   ON ( FP.DIVISION_ID   = W.DIVISION_ID
						  AND   FP.PROJECT_CODE  = W.PROJECT_CODE
						  AND   FP.SCM_SITE_ID   = W.SCM_SITE_ID
						  AND   FP.ITEM_ID       = W.ITEM_ID
						  AND   FP.DOM_EXP       = W.DOM_EXP
						  AND   FP.FCST_TYPE     = W.FCST_TYPE
						  AND   FP.INCOTERMS     = W.INCOTERMS
						  AND   FP.PLANT_SITE_ID = W.PLANT_SITE_ID
						  AND   FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
						  AND   FP.MEASURE = 'USD' )
			  --where w.measure = CASE WHEN W.DIVISION_ID = '81' THEN 'RTF_SCP' ELSE 'RTF' END -- 20200213 HWI1993
			  --where w.measure = CASE WHEN W.DIVISION_ID in ('81','40') THEN 'RTF_SYS_RP' ELSE 'RTF' END -- 20200507 KHSONG C20200507-000035
			  WHERE W.MEASURE = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
				AND EXISTS ( SELECT v_DIVISION_ID
							   FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
							  WHERE 1=1
							    AND W.DIVISION_ID        = v_DIVISION_ID         
							    AND W.PROJECT_CODE       = v_PROJECT_CODE      
							    AND W.SCM_SITE_ID        = v_SCM_SITE_ID
							    AND W.ITEM_ID            = v_ITEM_ID     
							    AND W.DOM_EXP            = v_DOM_EXP      
							    AND W.FCST_TYPE          = v_FCST_TYPE      
							    AND W.INCOTERMS          = v_INCOTERMS  
							    AND W.PLANT_SITE_ID      = v_PLANT_SITE_ID )
				AND W.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)     
				AND W.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN WITH(NOLOCK) GROUP BY ITEM_ID )
				-- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				AND NOT EXISTS ( SELECT A.DIVISION_ID
								   FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
									  , DM_PLN_SALES_PLAN B WITH(NOLOCK)
								  WHERE SALES_PLAN_ADJUST_YN = 'N'
									AND A.ITEM_ID				= B.ITEM_ID
									AND A.DIVISION_ID			= B.DIVISION_ID
									AND A.PROJECT_CODE			= B.PROJECT_CODE
									AND A.SCM_SITE_ID			= B.SCM_SITE_ID
									AND B.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									AND B.YYYYMMDD				>= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
									AND A.DIVISION_ID			= W.DIVISION_ID
									AND A.PROJECT_CODE			= W.PROJECT_CODE
									AND A.SCM_SITE_ID			= W.SCM_SITE_ID
									AND A.ITEM_ID				= W.ITEM_ID )
			;
			--[PJ2025-50017] 소형 매출계획 동기화 개선 - 모든 사업부가 RTF의 경우 CELL_PROD_SITE_ID를 단위로 업데이트 필요. (End)

			-- select * from #SALES_PLAN_TEMP;
			-- 테이블의 중복제거
			BEGIN
				DELETE 
				FROM DM_PLN_SALES_PLAN
				WHERE EXISTS ( SELECT B.DIVISION_ID
								 FROM #SALES_PLAN_TEMP B WITH(NOLOCK)
								WHERE 1=1
								  AND DM_PLN_SALES_PLAN.DIVISION_ID    = B.DIVISION_ID  
								  AND DM_PLN_SALES_PLAN.PROJECT_CODE   = B.PROJECT_CODE                          
								  AND DM_PLN_SALES_PLAN.SCM_SITE_ID    = B.SCM_SITE_ID                           
								  AND DM_PLN_SALES_PLAN.ITEM_ID        = B.ITEM_ID                               
								  AND DM_PLN_SALES_PLAN.DOM_EXP        = B.DOM_EXP                               
								  AND DM_PLN_SALES_PLAN.FCST_TYPE      = B.FCST_TYPE                             
								  AND DM_PLN_SALES_PLAN.INCOTERMS      = B.INCOTERMS                             
								  AND DM_PLN_SALES_PLAN.MEASURE        = B.MEASURE                               
								  AND DM_PLN_SALES_PLAN.PLANT_SITE_ID  = B.PLANT_SITE_ID                         
								  AND DM_PLN_SALES_PLAN.YYYYMMDD       = B.YYYYMMDD )
			END

			-- 20191114 KHSONG 컬럼값 미지정에서 지정으로 보완
			INSERT INTO DM_PLN_SALES_PLAN
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID -- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
			, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
			, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID	-- [PJ2025-50017] SALES_PLAN에 CELL_PROD_SITE_ID 추가
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, SYSDATETIME() AS LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
				 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM #SALES_PLAN_TEMP WITH(NOLOCK) 

		END

		-- [PJ2024-50611] 소형 매출 프로세스 개선 (Start)
		SET @v_division_id = ( SELECT TOP 1 v_DIVISION_ID FROM #results )
		--[PJ2025-50017] 소형 매출계획 동기화 개선 (End)

		--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 (Start)
		DELETE DM_PLN_SALES_ETC_PLAN 
		 WHERE 1=1
		   AND DIVISION_ID = @v_division_id
		   AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		   AND MEASURE IN ( 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up') --Catch_Up 관련 메저만 삭제
		   AND EXISTS ( SELECT v_DIVISION_ID
						  FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
						 WHERE 1=1
						   AND DIVISION_ID        = v_DIVISION_ID         
						   AND PROJECT_CODE       = v_PROJECT_CODE      
						   AND SCM_SITE_ID        = v_SCM_SITE_ID
						   AND ITEM_ID            = v_ITEM_ID     
						   AND DOM_EXP            = v_DOM_EXP      
						   AND FCST_TYPE          = v_FCST_TYPE      
						   AND INCOTERMS          = v_INCOTERMS  
						   AND PLANT_SITE_ID      = v_PLANT_SITE_ID	/*-- PLANT_SITE_ID 고려하지 않고 모두 삭제 후 신규 생성*/	) 

		INSERT INTO DM_PLN_SALES_ETC_PLAN 
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
		, MEASURE, PLANT_SITE_ID, YYYYMMDD
		, QTY, CURRENCY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK_TEXT )
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
			 , CASE WHEN B.MEASURE = 'KRW' THEN 'SalesAmt_KRW_Catch_Up'
					WHEN B.MEASURE = 'LOC' THEN 'SalesAmt_LOC_Catch_Up'
					WHEN B.MEASURE = 'USD' THEN  'SalesAmt_USD_Catch_Up'
					ELSE B.MEASURE END AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
			 , CASE WHEN B.MEASURE = 'KRW' THEN CAST( STR( A.QTY * ISNULL(B.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))
					WHEN B.MEASURE = 'LOC' THEN CAST( STR( A.QTY * ISNULL(B.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))
					WHEN B.MEASURE = 'USD' THEN CAST( STR( A.QTY * ISNULL(B.PRICE, 0), 20, 5 ) AS NUMERIC(30, 10))
					END AS QTY, B.CURRENCY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE, A.REMARK_TEXT
		FROM DM_PLN_SALES_ETC_PLAN A WITH(NOLOCK)
		JOIN SCM_MST_FUTURE_PRICE B WITH(NOLOCK)
		  ON ( A.DIVISION_ID   = B.DIVISION_ID
		 AND   A.PROJECT_CODE  = B.PROJECT_CODE
		 AND   A.SCM_SITE_ID   = B.SCM_SITE_ID
		 AND   A.ITEM_ID       = B.ITEM_ID
		 AND   A.DOM_EXP       = B.DOM_EXP
		 AND   A.FCST_TYPE     = B.FCST_TYPE
		 AND   A.INCOTERMS     = B.INCOTERMS
		 AND   A.PLANT_SITE_ID = B.PLANT_SITE_ID
		 AND   B.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = A.YYYYMMDD ))
		WHERE A.MEASURE = 'Catch_Up' 
		  AND A.DIVISION_ID = @v_division_id
		  AND B.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		  AND B.MEASURE IN ( 'KRW', 'LOC', 'USD' )
		  AND EXISTS (	SELECT v_DIVISION_ID
						  FROM #results -- DM0020_SAVE_SCM_MST_FUTURE_PRICE_ALL 에서 전달된 임시테이블 데이터
						 WHERE 1=1
						   AND A.DIVISION_ID        = v_DIVISION_ID         
						   AND A.PROJECT_CODE       = v_PROJECT_CODE      
						   AND A.SCM_SITE_ID        = v_SCM_SITE_ID
						   AND A.ITEM_ID            = v_ITEM_ID     
						   AND A.DOM_EXP            = v_DOM_EXP      
						   AND A.FCST_TYPE          = v_FCST_TYPE      
						   AND A.INCOTERMS          = v_INCOTERMS  
						   AND A.PLANT_SITE_ID      = v_PLANT_SITE_ID ) 
		--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 END
        /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/

  	-- 트랜잭션 (COMMIT)
    --COMMIT WORK;
    COMMIT TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE; 
	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
		--[E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (START)
		BEGIN --[E20260309-000271]_BEGIN / END 추가
			--ROLLBACK TRANSACTION SALES_PLAN_LOCAL_KRW_SINGLE;
			ROLLBACK
			--[E20260309-000271]_오류가 발생하는 경우 정상적으로 찍히지 않아서 수정함 (END)

			-- ERROR LOG VALUE SAVE
			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			--[E20260309-000271]_오류가 발생하는 경우 사용자의 ID까지 찍히도록 수정 (START)
			--SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()); -- [E20260309-000271]_원소스주석처리
			SET @v_description	= '@v_created_by: ' + @v_created_by + '/ ERROR_LINE : ' + STR(ERROR_LINE());
			--[E20260309-000271]_오류가 발생하는 경우 사용자의 ID까지 찍히도록 수정 (START)
			SET @d_event_date = SYSDATETIME();

			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  	END  --[E20260309-000271]_BEGIN / END 추가
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
