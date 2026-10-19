
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



/****************************************************************************************************
* Program ID  : PR_DM_PLN_ESS_VMI_REFRESH
* Description : 월요일 저녁에 ESS VMI 메저를 리프레시 한다.
* Usage       :                                 
* Parameter   :                                                                                    
*                                                                                                  
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2021.06.09	HWI1993	신규생성 C20210603-000166 ESS VMI Request 월요일 배치 추가건
* 2021.08.26	HWI1993	[C20210825-000022] ess 사업부 refresh 기능 적용 구간 변경
* 2021.09.02	HWI1993 [C20210825-000022] 대상에서 누락되는 건이 있어서 모든 VMI SITE 를 대상으로 변경함.
* 2023.07.18	CHANO0612   [E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선
* 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


*/
CREATE PROC [dbo].[PR_DM_PLN_ESS_VMI_REFRESH]
AS
SET NOCOUNT ON

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_ESS_VMI_REFRESH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @dispatch_serial_no INT;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

BEGIN TRY
	
	
	--IF OBJECT_ID (N'tempdb..#T_PLAN', N'U') IS NOT NULL 		DROP TABLE #T_PLAN
	--IF OBJECT_ID (N'tempdb..#T_RESULT', N'U') IS NOT NULL 		DROP TABLE #T_RESULT
	--IF OBJECT_ID (N'tempdb..#T_MAIN', N'U') IS NOT NULL 		DROP TABLE #T_MAIN

	CREATE TABLE #RESULTS (
	V_DIVISION_ID		NVARCHAR(30)
	, V_PROJECT_CODE	NVARCHAR(50)
	, V_SCM_SITE_ID		NVARCHAR(30)
	, V_ITEM_ID			NVARCHAR(50)
	, V_DOM_EXP			NVARCHAR(3)
	, V_FCST_TYPE		NVARCHAR(20)
	, V_INCOTERMS		NVARCHAR(10)
	, V_PLANT_SITE_ID	NVARCHAR(30)
	)


	-- 대상을 선정한다. ( VMI SITE 이고, 계획구간에 MKT FCST 가 있는 모든 건 )
	INSERT INTO #RESULTS ( V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID )
	SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
	FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
	JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
	WHERE A.DIVISION_ID = '82'
	AND A.MEASURE = 'MKT_FCST'
	AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	-- 오늘(금주 월요일)
	AND A.QTY <> 0

	DECLARE @V_CREATED_BY NVARCHAR(150) = N'VMI_REFRESH';

	-- 여기서부터는 DMF0003_SAVE_MKT_FCST 와 완전히 동일함.( 커서 선언 SELECT 문 제외 )


				DECLARE @EV_DIVISION_ID			NVARCHAR(30)
						, @EV_SCM_SITE_ID       NVARCHAR(50)
						, @EV_PROJECT_CODE		NVARCHAR(50)
						, @EV_ITEM_ID			NVARCHAR(50)
						, @EV_DOM_EXP			NVARCHAR(3)
						, @EV_FCST_TYPE			NVARCHAR(20)
						, @EV_INCOTERMS			NVARCHAR(10)
						, @EV_PLANT_SITE_ID		NVARCHAR(30)
						, @EV_DIO				INT				-- 재고일수
						, @EV_BINV				INT				-- 기초재고


				IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_ESSVMI')
				BEGIN
					CLOSE CURSOR_ESSVMI
					DEALLOCATE CURSOR_ESSVMI
				END;

				-- 원본 주석처리
				/*
				DECLARE CURSOR_ESSVMI CURSOR FAST_FORWARD FOR
				SELECT DISTINCT A.V_DIVISION_ID, A.V_SCM_SITE_ID, A.V_PROJECT_CODE, A.V_ITEM_ID, A.V_DOM_EXP
						, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
						, CASE WHEN ISNUMERIC(ISNULL(ATTRIBUTE5, '')) > 0 THEN ATTRIBUTE5 ELSE 0 END AS V_DIO
				FROM  #results A
				JOIN SCM_MST_SITE B ON A.V_DIVISION_ID = B.DIVISION_ID AND A.V_SCM_SITE_ID = B.SCM_SITE_ID
				WHERE 1=1
					AND B.VMI_YN = 'Y'
					AND A.V_DIVISION_ID = '82'
				*/
				-- 원본 주석처리

				--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건으로 기존 SCM_MST_SITE ATTRIBUTE5에서 SSPM INVENTORY DAYS 컬럼으로 변경 [START]
				DECLARE CURSOR_ESSVMI CURSOR FAST_FORWARD FOR
				SELECT DISTINCT A.V_DIVISION_ID, A.V_SCM_SITE_ID, A.V_PROJECT_CODE, A.V_ITEM_ID, A.V_DOM_EXP
						, A.V_FCST_TYPE, A.V_INCOTERMS, A.V_PLANT_SITE_ID
						, CASE WHEN ISNUMERIC(ISNULL(C.INVENTORY_DAY, '')) > 0 THEN C.INVENTORY_DAY ELSE 0 END AS V_DIO
				FROM  #results A WITH(NOLOCK)
				JOIN SCM_MST_SITE B ON A.V_DIVISION_ID = B.DIVISION_ID AND A.V_SCM_SITE_ID = B.SCM_SITE_ID
				--JOIN SCM_MST_SITE_ITEM C ON A.V_DIVISION_ID = C.DIVISION_ID AND A.V_SCM_SITE_ID = C.SCM_SITE_ID AND A.V_ITEM_ID = C.ITEM_ID -- 추가
				JOIN SCM_MST_SITE_ITEM C ON A.V_DIVISION_ID = C.DIVISION_ID AND A.V_SCM_SITE_ID = C.SCM_SITE_ID AND A.V_ITEM_ID = C.ITEM_ID AND A.V_PROJECT_CODE = C.PROJECT_CODE
				WHERE 1=1
					AND B.VMI_YN = 'Y'
					AND A.V_DIVISION_ID = '82'
				--[E20230619-000273] ESS 법인향 Inventory Days 모델별 설정 개선건으로 기존 SCM_MST_SITE ATTRIBUTE5에서 SSPM INVENTORY DAYS 컬럼으로 변경 [END]
				
				BEGIN
					OPEN CURSOR_ESSVMI;
					FETCH NEXT FROM CURSOR_ESSVMI INTO @EV_DIVISION_ID, @EV_SCM_SITE_ID, @EV_PROJECT_CODE, @EV_ITEM_ID
														, @EV_DOM_EXP, @EV_FCST_TYPE, @EV_INCOTERMS, @EV_PLANT_SITE_ID, @EV_DIO
				END
				---------------------------------------------------------------------------------------- WHILE_m4 LOOP START
				WHILE @@FETCH_STATUS = 0   
				----------------------------------------------------------------------------------------
				BEGIN

--SELECT 'x0', @EV_DIVISION_ID, @EV_SCM_SITE_ID, @EV_PROJECT_CODE, @EV_ITEM_ID
--														, @EV_DOM_EXP, @EV_FCST_TYPE, @EV_INCOTERMS, @EV_PLANT_SITE_ID, @EV_DIO
					-- 기초재고를 가져온다.
					SET @EV_BINV = 0;

					SELECT @EV_BINV = ISNULL(QTY,0)
					FROM DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
					WHERE A.DIVISION_ID = '82'
						AND A.MEASURE = 'VMI_Inv'
						AND A.YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -8, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	--	실적구간 마지막일자
						AND A.SCM_SITE_ID = @EV_SCM_SITE_ID
						AND A.PROJECT_CODE = @EV_PROJECT_CODE
						AND A.ITEM_ID = @EV_ITEM_ID
						AND A.DOM_EXP = @EV_DOM_EXP
						AND A.FCST_TYPE = @EV_FCST_TYPE
						AND A.INCOTERMS = @EV_INCOTERMS
						AND A.PLANT_SITE_ID = @EV_PLANT_SITE_ID
						AND A.CELL_PROD_SITE_ID = '-'				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (82사이트는 CELL_PROD_SITE_ID '-'로 고정됨 / 또한 VMI_INV는 전사이트 '-'로 고정이므로 '-'로 처리함)
					
						
					-- 해당 SITE 의 미래구간의 VMI_IN_REQ 를 모두 지운다.									   
				   DELETE A
				   FROM DM_PLN_MKT_FCST A
				   WHERE A.DIVISION_ID = '82'
						AND A.MEASURE = 'VMI_In_Req'
						AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	--	계획구간만
						AND A.SCM_SITE_ID = @EV_SCM_SITE_ID
						AND A.PROJECT_CODE = @EV_PROJECT_CODE
						AND A.ITEM_ID = @EV_ITEM_ID
						AND A.DOM_EXP = @EV_DOM_EXP
						AND A.FCST_TYPE = @EV_FCST_TYPE
						AND A.INCOTERMS = @EV_INCOTERMS
						AND A.PLANT_SITE_ID = @EV_PLANT_SITE_ID
--SELECT 'X1', @@ROWCOUNT

				-------------------------------		계산			-----------------------------------------------------------
					INSERT INTO DM_PLN_MKT_FCST ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
								, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
								, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )

					SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE
							, X.INCOTERMS, 'VMI_In_Req' as MEASURE
							, CONVERT(CHAR(8), DATEADD(DAY, -@EV_DIO, X.YYYYMMDD), 112)		-- MKT FCST 의 일자를 기준으로 집계했으므로 재고일수만큼 앞으로 밀어준다.
							, X.PLANT_SITE_ID
							, CASE	WHEN ROW_NUM <= @EV_DIO THEN 0
									WHEN ROW_NUM = @EV_DIO + 1 THEN CASE WHEN SUM_QTY > @EV_BINV THEN SUM_QTY - @EV_BINV ELSE 0 END		-- 재고일수를 처음 넘어가는 날
									WHEN SUM_QTY > @EV_BINV AND BF_SUM <= @EV_BINV THEN SUM_QTY - @EV_BINV	-- 처음으로 기초재고를 넘어가는 행
									WHEN BF_SUM > @EV_BINV  THEN QTY
									ELSE 0
									END AS QTY
							, @V_CREATED_BY, GETDATE(), @V_CREATED_BY, GETDATE()
					FROM (
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
							, A.INCOTERMS, A.YYYYMMDD, A.PLANT_SITE_ID
							, SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ) AS SUM_QTY
							, SUM(A.QTY) OVER ( ORDER BY A.YYYYMMDD ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ) AS BF_SUM
							, QTY
							, ROW_NUMBER() OVER ( ORDER BY A.YYYYMMDD ) AS ROW_NUM
						FROM (
							SELECT A.BASIS_YYYYMMDD AS YYYYMMDD, 'MKT_FCST' AS MEASURE, ISNULL(B.QTY, 0) AS QTY
								, @EV_DIVISION_ID AS DIVISION_ID, @EV_SCM_SITE_ID AS SCM_SITE_ID, @EV_PROJECT_CODE AS PROJECT_CODE, @EV_ITEM_ID AS ITEM_ID
								, @EV_DOM_EXP AS DOM_EXP, @EV_FCST_TYPE AS FCST_TYPE, @EV_INCOTERMS AS INCOTERMS, @EV_PLANT_SITE_ID AS PLANT_SITE_ID
							FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
							LEFT OUTER JOIN DM_PLN_MKT_FCST B ON A.BASIS_YYYYMMDD = B.YYYYMMDD AND B.MEASURE = 'MKT_FCST'
															AND B.DIVISION_ID = '82'	
															AND B.SCM_SITE_ID = @EV_SCM_SITE_ID
															AND B.PROJECT_CODE = @EV_PROJECT_CODE
															AND B.ITEM_ID = @EV_ITEM_ID
															AND B.DOM_EXP = @EV_DOM_EXP
															AND B.FCST_TYPE = @EV_FCST_TYPE
															AND B.INCOTERMS = @EV_INCOTERMS
															AND B.PLANT_SITE_ID = @EV_PLANT_SITE_ID
							WHERE A.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	--	계획구간만
								--AND A.BASIS_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(WW, 82, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112) -- [C20201217-000126]
								-- [C20210825-000022]
								AND A.BASIS_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, CASE WHEN @EV_DIO > 0 THEN @EV_DIO + 1 ELSE @EV_DIO + 10 END + 7*84, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112) 
							) A
						) X
					WHERE CASE	WHEN ROW_NUM <= @EV_DIO THEN 0
								WHEN ROW_NUM = @EV_DIO + 1 THEN CASE WHEN SUM_QTY > @EV_BINV THEN SUM_QTY - @EV_BINV ELSE 0 END		-- 재고일수를 처음 넘어가는 날
								WHEN SUM_QTY > @EV_BINV AND BF_SUM <= @EV_BINV THEN SUM_QTY - @EV_BINV	-- 처음으로 기초재고를 넘어가는 행
								WHEN BF_SUM > @EV_BINV  THEN QTY
								ELSE 0
								END > 0
--select 'x2', @@Rowcount


					FETCH NEXT FROM CURSOR_ESSVMI INTO @EV_DIVISION_ID, @EV_SCM_SITE_ID, @EV_PROJECT_CODE, @EV_ITEM_ID
														, @EV_DOM_EXP, @EV_FCST_TYPE, @EV_INCOTERMS, @EV_PLANT_SITE_ID, @EV_DIO
				---------------------------------------------------------------------------------------- 
				END;
				---------------------------------------------------------------------------------------- WHILE_m4 LOOP END

				CLOSE CURSOR_ESSVMI;  
				DEALLOCATE CURSOR_ESSVMI;




END TRY
			
BEGIN CATCH

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END CATCH

	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;







