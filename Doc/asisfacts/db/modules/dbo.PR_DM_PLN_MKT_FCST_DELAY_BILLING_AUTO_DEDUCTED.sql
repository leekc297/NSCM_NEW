

/*==============================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED
 * Description  : 23시에 발생한 실적과 13시에 발생한 실적이 다른 경우 룩업에 등록한 대상에 대해서만 MKT FCST에서 차감
 * Program History
 * 요청배경: 매출실적 지연처리로 인한 수요계획 입력 시 혼선이 있어 특정 팀/모델에 대해 개선안 적용요청
 * 요청내용: 실적업데이트 시점 기준 월 13시~월 23시 사이에 매출실적이 추가 발생하면 이를 수요계획 구간에서 자동 차감하는 안
 *  ※ 23시 데이터가 13시 데이터보다 많은 경우에만 적용되며, 13시 데이터가 더 큰 경우에는 해당 없음 ※
 *  ※ MKT FCST 데이터를 새로 생성해주지는 않고, 계획수량에 있는 내에서의 수량에 대해서까지만 뺴준다 ※
 *==============================================================================================================================
 *   Date       In Charge		Description
 *==============================================================================================================================
 * 2025.04.14	JSSBAE			[E20250404-001534]_[공급생산 SCM PI팀] 지연 빌링 발생 시 수요계획 보정 기능 개발 요청
 * 2025.06.23	KANG.H.J		[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 ==============================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED]
	 @p_division_id		NVARCHAR(MAX)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	/*=====================================================================================================================================
	-- LOG 용 변수 설정
	=====================================================================================================================================*/
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	DECLARE @v_batch_user			NVARCHAR(150) = 'AUTO_DEDUCTED';
	DECLARE @v_version				NVARCHAR(50);	  
	DECLARE @ROWCNT					INT;

	--버전설정(MF_D와 V000은 고정이다)
	SET @v_version = 'MF_D_'+CONVERT(VARCHAR(8), GETDATE(), 112)+'_V000';

	/*=====================================================================================================================================
	-- TEMP 테이블 삭제한 후 시작한다. 
	=====================================================================================================================================*/	
	--DM_PLN_MKT_FCST에서 데이터를 차감하는 대상이 될 데이터 TEMP
	IF OBJECT_ID (N'tempdb..#TEMP_DEDUCTED_ITEM', N'U')			
	   IS NOT NULL	DROP TABLE #TEMP_DEDUCTED_ITEM

	--실적차이가 발생한 데이터의 수치와 DM_PLN_MKT_FCST KEY값 보관 TEMP
	IF OBJECT_ID (N'tempdb..#TEMP_DEDUCTED_DATA', N'U')			
	   IS NOT NULL	DROP TABLE #TEMP_DEDUCTED_DATA
	   
	-- MKT FCST에서 차감해야하는 대상 데이터를 담아둔다.	   
	IF OBJECT_ID (N'tempdb..#TEMP_MKT_FCST_DATA', N'U')			
	   IS NOT NULL	DROP TABLE #TEMP_MKT_FCST_DATA	   
	   
	-- MKT FCST에서 UPDATE 해줘야하는 데이터를 TEMP로 담아둔다 
	IF OBJECT_ID (N'tempdb..#TEMP_UPDATE_MKT_FCST', N'U')			
	   IS NOT NULL	DROP TABLE #TEMP_UPDATE_MKT_FCST 
	   
	/*=====================================================================================================================================
	-- 시작 LOG (START)
	=====================================================================================================================================*/	
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	/*=====================================================================================================================================
	-- 시작 LOG (END)
	=====================================================================================================================================*/	
	
	/*=====================================================================================================================================
	-- 트랜잭션 (START)
	=====================================================================================================================================*/	
	BEGIN TRANSACTION AUTO_DEDUCTED;	
	BEGIN TRY				

		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--1. DM_PLN_MKT_FCST에서 데이터를 차감하는 대상이 될 데이터를 추출하여 TEMP에 담는다.
		-- (1). 룩업에 등록된 대상 기준으로 DIVISION_ID, ITEM, TEAM정보로 SCM_MST_SITE_ITEM에서 TEAM은 없으므로 OWNER로 TEAM정보를 추출한다. 		
		-- (2). 현재 구조상 SCM_MST_SITE_ITEM에는 여러명의 OWNER가 존재한다. 하여 여러명의 OWNER의 DEPT_ID를 모두 추출한다.
		-- (3). 대상 데이터로 잡을 수 있는 데이터에서 SCM_MST_SITE_ITEM PK값을 최대한 추출하여 담는다.
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		
		SET @ROWCNT = 0	
		
		SELECT A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID
		INTO #TEMP_DEDUCTED_ITEM
		FROM 
		(   SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.OWNER, A.REAL_OWNER, B.DEPT_ID
			FROM 
			(  
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.OWNER, TOKEN AS REAL_OWNER
				FROM SCM_MST_SITE_ITEM A WITH (NOLOCK) 
				CROSS APPLY STRING_SPLIT(OWNER, ',')
				WHERE A.VALID_YN = 'Y'
				AND ISNULL(A.OWNER, '') != ''
			) A
			INNER JOIN SCM_MST_SSO_USER_INFO B
					ON A.REAL_OWNER = B.USER_ID
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
					ON A.DIVISION_ID = @p_division_id
					AND A.ITEM_ID	 = C.SEGMENT2
					AND B.DEPT_ID	 = C.SEGMENT3
					AND C.LOOKUP_TYPE = 'DM_DELAY_BILLING_AUTO_DEDUCTED'
		) A
		GROUP BY  A.DIVISION_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.ITEM_ID		
				
		SET @ROWCNT = @@ROWCOUNT					

PRINT ( 'A--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

		/*=====================================================================================================================================
		-- 대상데이터 LOG (START)
		=====================================================================================================================================*/	
		SET @v_log_type    = N'APPEND';  
		SET @v_log_message = N'TARGET DATA';  
		SET @v_description = N'#TEMP_DEDUCTED_ITEM INSERT: DIVISION_ID: ' + @p_division_id;
		SET @d_event_date  = SYSDATETIME();
		SET @n_log_count   = @ROWCNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		/*=====================================================================================================================================
		-- 대상데이터 LOG (END)
		=====================================================================================================================================*/	
		
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--2. 23시에 받은 실적 데이터와 13시에 MF_D에 보관한 실적 데이터를 비교하여 실제 빠져야 하는 데이터와 현시점의 QTY 모두 보관
		-- (1). 1차로 데이터 비교할 당시는 23시 데이터 기준으로 13시 데이터를 비교한다 (날짜별로 수치를 비교한다)
		--		비교 대상은 DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD		
		-- (2). 갭차이가 발생하는 경우에는 총 데이터의 갭차이로 MKT FCST에서 차감할 예정이므로 
		--		DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID 기준으로 SUM한 데이터의 수치를 구한다. 
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

		SET @ROWCNT = 0		

		-- ◈ 실제 차감할때는 총 데이터의 갭차이가 중요하기때문에 KEY값과 실제 차감할 데이터의 SUM만 보관한다. START 
		SELECT T.DIVISION_ID, T.PROJECT_CODE, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE
			 , T.INCOTERMS, T.PLANT_SITE_ID, SUM(T.DEDUCTED_QTY) AS DEDUCTED_QTY
		INTO #TEMP_DEDUCTED_DATA
		FROM
		(	-- ◈ 차감할 대상 데이터를 구하기 이전에 날짜별로 데이터 갭차이를 확인한다. START
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
				 , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.SALES_QTY_23, ISNULL(B.SALES_QTY_13,0) AS SALES_QTY_13
				 , A.SALES_QTY_23 - ISNULL(B.SALES_QTY_13,0) AS DEDUCTED_QTY
			FROM
			(	--23시 실적 받은 데이터 
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
						, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						------------------------------------------------------------------------------------------------------------------------------------------
						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID가 있어서 GROUP BY에 의한 SUM(QTY) 처리함. 
						-- ==> DM_PLN_MKT_FCST에 수량을 업데이트 하므로 CELL_PROD_SITE_ID별로 수량 집계할 필요 없음
						--, A.QTY AS SALES_QTY_23
						, SUM(A.QTY)	AS SALES_QTY_23
						------------------------------------------------------------------------------------------------------------------------------------------
				FROM DM_PLN_MKT_FCST_RESULT A WITH(NOLOCK)
				INNER JOIN #TEMP_DEDUCTED_ITEM B 
						ON A.DIVISION_ID	= B.DIVISION_ID
					   AND A.SCM_SITE_ID	= B.SCM_SITE_ID
					   AND A.PROJECT_CODE	= B.PROJECT_CODE
					   AND A.ITEM_ID		= B.ITEM_ID
				WHERE A.MEASURE = 'RTF_SYS_RP'
				AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112) --전주 월요일
				AND A.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112)  --당주 월요일 이전	
				------------------------------------------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID가 있어서 GROUP BY에 의한 SUM(QTY) 처리함. 
				-- ==> DM_PLN_MKT_FCST에 수량을 업데이트 하므로 CELL_PROD_SITE_ID별로 수량 집계할 필요 없음
				GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
						, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
				------------------------------------------------------------------------------------------------------------------------------------------
			) A
			LEFT OUTER JOIN 
			(	--13시 실적 받아 MF_D에 보관한 데이터
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
						, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
						------------------------------------------------------------------------------------------------------------------------------------------
						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID가 있어서 GROUP BY에 의한 SUM(QTY) 처리함.
						-- ==> DM_PLN_MKT_FCST에 수량을 업데이트 하므로 CELL_PROD_SITE_ID별로 수량 집계할 필요 없음
						--, A.QTY AS SALES_QTY_13
						, SUM(A.QTY)	AS SALES_QTY_13
						------------------------------------------------------------------------------------------------------------------------------------------
				FROM DM_PLN_MKT_FCST_RESULT_C A WITH(NOLOCK)
				INNER JOIN #TEMP_DEDUCTED_ITEM B 
						ON A.DIVISION_ID = B.DIVISION_ID
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.ITEM_ID = B.ITEM_ID
				WHERE A.MEASURE = 'RTF_SYS_RP'
				AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112) --전주 월요일
				AND A.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112)  --당주 월요일 이전
				AND A.VERSION_NO = @v_version
				------------------------------------------------------------------------------------------------------------------------------------------
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST_RESULT에 CELL_PROD_SITE_ID가 있어서 GROUP BY에 의한 SUM(QTY) 처리함. 
				-- ==> DM_PLN_MKT_FCST에 수량을 업데이트 하므로 CELL_PROD_SITE_ID별로 수량 집계할 필요 없음
				GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
						, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
				------------------------------------------------------------------------------------------------------------------------------------------
			) B
						ON A.DIVISION_ID = B.DIVISION_ID
						AND A.PROJECT_CODE = B.PROJECT_CODE
						AND A.SCM_SITE_ID = B.SCM_SITE_ID
						AND A.ITEM_ID = B.ITEM_ID
						AND A.DOM_EXP = B.DOM_EXP
						AND A.FCST_TYPE = B.FCST_TYPE
						AND A.INCOTERMS = B.INCOTERMS
						AND A.MEASURE = B.MEASURE
						AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
						AND A.YYYYMMDD = B.YYYYMMDD
			WHERE ((ISNULL(A.SALES_QTY_23,0) > ISNULL(B.SALES_QTY_13, 0)) OR B.DIVISION_ID IS NULL)
			-- ◈ 차감할 대상 데이터를 구하기 이전에 날짜별로 데이터 갭차이를 확인한다. END
		) T
		GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE
			   , T.INCOTERMS, T.PLANT_SITE_ID					   
		-- ◈ 실제 차감할때는 총 데이터의 갭차이가 중요하기때문에 KEY값과 실제 차감할 데이터의 SUM만 보관한다. END 
		
		SET @ROWCNT = @@ROWCOUNT				

PRINT ( 'B--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

		/*=====================================================================================================================================
		-- 대상데이터 LOG (START)
		=====================================================================================================================================*/	
			SET @v_log_type    = N'APPEND';  
			SET @v_log_message = N'TARGET DATA';  
			SET @v_description = N'#TEMP_DEDUCTED_DATA INSERT: DIVISION_ID: ' + @p_division_id;
			SET @d_event_date  = SYSDATETIME();
			SET @n_log_count   = @ROWCNT;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		/*=====================================================================================================================================
		-- 대상데이터 LOG (END)
		=====================================================================================================================================*/	
		
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--※ DIFF 건수가 발생하지 않은 경우에는 다음으로 수행하지 않고, 종료한다. ※ 
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		IF (SELECT COUNT(1) FROM #TEMP_DEDUCTED_DATA ) > 0
		BEGIN 
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			--3. DM_PLN_MKT_FCST와 현재 룩업에 존재하는 데이터를 대상으로 데이터를 잡는다. 
			--(1). DM_PLN_MKT_FCST에 데이터가 없다면 빠질 대상이 없기때문에 (신규로 빼는 내역을 생성하지는 않는다.) MKT FCST 대상이 있는지를 잡는다.
			--(2). 기준일자: 당주 월요일 이후 데이터
			--(3). 대상메져: MKT_FCST
			--(4). 수량: 0 이상인 데이터만 대상 
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		
			SET @ROWCNT = 0		
			
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
				 , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID ORDER BY A.YYYYMMDD ASC) AS ROW_NUM
			INTO #TEMP_MKT_FCST_DATA
			FROM DM_PLN_MKT_FCST A WITH (NOLOCK)
			INNER JOIN #TEMP_DEDUCTED_DATA B
					ON A.DIVISION_ID	= B.DIVISION_ID
					AND A.PROJECT_CODE	= B.PROJECT_CODE 
					AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
					AND A.ITEM_ID		= B.ITEM_ID 
					AND A.DOM_EXP		= B.DOM_EXP 
					AND A.FCST_TYPE		= B.FCST_TYPE 
					AND A.INCOTERMS		= B.INCOTERMS 
					AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID 
			WHERE A.MEASURE = 'MKT_FCST'
			AND A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CAST(GETDATE() as datetime), 'MON')), 112)
			AND A.QTY > 0

			SET @ROWCNT = @@ROWCOUNT				

			/*=====================================================================================================================================
			-- 대상데이터 LOG (START)
			=====================================================================================================================================*/	
				SET @v_log_type    = N'APPEND';  
				SET @v_log_message = N'TARGET DATA';  
				SET @v_description = N'#TEMP_MKT_FCST_DATA: DIVISION_ID: ' + @p_division_id;
				SET @d_event_date  = SYSDATETIME();
				SET @n_log_count   = @ROWCNT;
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			/*=====================================================================================================================================
			-- 대상데이터 LOG (END)
			=====================================================================================================================================*/	
	
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			--4. 3번에서 생성한 데이터를 기준으로 순서로 데이터를 생성한다.
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		
			SET @ROWCNT = 0		
		
			--LOOP만들 대상 테이블 잡기
			CREATE TABLE #TEMP_MKT_FCST_DATA_LOOP 
			(	DIVISION_ID		NVARCHAR(30)
			  , PROJECT_CODE	NVARCHAR(50)
			  , SCM_SITE_ID		NVARCHAR(30)
			  , ITEM_ID			NVARCHAR(50)
			  , DOM_EXP			NVARCHAR(3)
			  , FCST_TYPE		NVARCHAR(20)
			  , INCOTERMS		NVARCHAR(10)
			  , MEASURE			NVARCHAR(50)
			  , PLANT_SITE_ID	NVARCHAR(30)
			  , SEQ		INT		IDENTITY(1,1)
			)		

			INSERT INTO #TEMP_MKT_FCST_DATA_LOOP
			(DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID )
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID 
			FROM #TEMP_MKT_FCST_DATA
			GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID 
		
			SET @ROWCNT = @@ROWCOUNT				
	
	PRINT ( 'C--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

			/*=====================================================================================================================================
			-- 대상데이터 LOG (START)
			=====================================================================================================================================*/	
				SET @v_log_type    = N'APPEND';  
				SET @v_log_message = N'TARGET DATA';  
				SET @v_description = N'#TEMP_TARGET_MKT_FCST: DIVISION_ID: ' + @p_division_id;
				SET @d_event_date  = SYSDATETIME();
				SET @n_log_count   = @ROWCNT;
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			/*=====================================================================================================================================
			-- 대상데이터 LOG (END)
			=====================================================================================================================================*/	

			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			--5. MKT FCST 테이블의 대상으로 잡은 데이터에서 일자별로 순차 차감한다.  
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

			SET @ROWCNT = 0			
		
			CREATE TABLE #TEMP_UPDATE_MKT_FCST
			(	DIVISION_ID		NVARCHAR(30)
			  , PROJECT_CODE	NVARCHAR(50)
			  , SCM_SITE_ID		NVARCHAR(30)
			  , ITEM_ID			NVARCHAR(50)
			  , DOM_EXP			NVARCHAR(3)
			  , FCST_TYPE		NVARCHAR(20)
			  , INCOTERMS		NVARCHAR(10)
			  , MEASURE			NVARCHAR(50)
			  , YYYYMMDD		NVARCHAR(8)
			  , PLANT_SITE_ID	NVARCHAR(30)
			  , QTY				NUMERIC(30,10)
			  , BEFORE_QTY		NUMERIC(30,10)
			)

			DECLARE @V_DIVISION_ID		VARCHAR(30)
				  , @V_PROJECT_CODE		VARCHAR(50)
				  , @V_SCM_SITE_ID		VARCHAR(30)
				  , @V_ITEM_ID			VARCHAR(50)
				  , @V_DOM_EXP			VARCHAR(3)
				  , @V_FCST_TYPE		VARCHAR(20)
				  , @V_INCOTERMS		VARCHAR(10)
				  , @V_PLANT_SITE_ID	VARCHAR(100)
				  , @V_YYYYMMDD			VARCHAR(8)
				  , @V_MEASURE			VARCHAR(100)
				  , @V_DEDUCTED_QTY		NUMERIC(30,10)		-- 실제 차감해야 하는 실적 수량
				  , @V_MKT_FCST_QTY		NUMERIC(30,10)		-- 현재 MKT FCST 
				  , @V_REM_QTY			NUMERIC(30,10)		-- 차감하고 남은 수량
				  , @V_TARGET_QTY		NUMERIC(30,10)		-- 실제 MKT FCST에서 차감한 수량
				  , @I					INT
				  , @CNT				INT			
				  , @MKT_I				INT
				  , @MKT_CNT			INT			
				  
			SELECT @I = 1, @CNT = COUNT(*)
			FROM #TEMP_MKT_FCST_DATA_LOOP
	
	PRINT @I
	PRINT @CNT	
	PRINT ( 'CC--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

			WHILE ( @I <= @CNT )
			BEGIN			
				SELECT @V_DIVISION_ID	= A.DIVISION_ID
					 , @V_PROJECT_CODE	= A.PROJECT_CODE
					 , @V_SCM_SITE_ID	= A.SCM_SITE_ID
					 , @V_ITEM_ID		= A.ITEM_ID
					 , @V_DOM_EXP		= A.DOM_EXP
					 , @V_FCST_TYPE		= A.FCST_TYPE
					 , @V_INCOTERMS		= A.INCOTERMS
					 , @V_PLANT_SITE_ID	= A.PLANT_SITE_ID
					 , @V_MEASURE		= A.MEASURE
				FROM #TEMP_MKT_FCST_DATA_LOOP A
				WHERE SEQ = @I	

				--MKT FCST에 대상 데이터가 존재하는 건들중에 실제로 차감해야 하는 실적 수량을 구한다.
				SELECT @V_DEDUCTED_QTY = A.DEDUCTED_QTY	--차감대상 수량
				FROM #TEMP_DEDUCTED_DATA A
				WHERE A.DIVISION_ID		= @V_DIVISION_ID
				AND A.PROJECT_CODE		= @V_PROJECT_CODE
				AND A.SCM_SITE_ID		= @V_SCM_SITE_ID
				AND A.ITEM_ID			= @V_ITEM_ID
				AND A.DOM_EXP			= @V_DOM_EXP
				AND A.FCST_TYPE			= @V_FCST_TYPE
				AND A.INCOTERMS			= @V_INCOTERMS
				AND A.PLANT_SITE_ID		= @V_PLANT_SITE_ID
				
			/*=====================================================================================================================================
			-- 대상데이터 LOG (START)
			=====================================================================================================================================*/	
				SET @v_log_type    = N'APPEND';  
				SET @v_log_message = N'TARGET DATA';  
				SET @v_description = N'#TEMP_UPDATE_MKT_FCST: DIVISION_ID: ' + @p_division_id + ' / PROJECT_CODE: ' + @V_PROJECT_CODE 
									+ ' / SCM_SITE_ID: '+ @V_SCM_SITE_ID + ' / ITEM_ID: '+ @V_ITEM_ID + ' / DOM_EXP: '+ @V_DOM_EXP + ' / FCST_TYPE: '+ @V_FCST_TYPE
									+ ' / INCOTERMS: '+ @V_INCOTERMS + ' / PLANT_SITE_ID: '+ @V_PLANT_SITE_ID + ' / DEDUCTED_QTY: '+ Convert(NVARCHAR(20), @V_DEDUCTED_QTY);
				SET @d_event_date  = SYSDATETIME();
				SET @n_log_count   = @I;
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			/*=====================================================================================================================================
			-- 대상데이터 LOG (END)
			=====================================================================================================================================*/	

	PRINT @V_DEDUCTED_QTY
	PRINT ( 'BB--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

				--실제 차감하려는 대상의 데이터
				SELECT @MKT_I = 1, @MKT_CNT = COUNT(*)
				FROM #TEMP_MKT_FCST_DATA
				WHERE DIVISION_ID = @V_DIVISION_ID
				AND PROJECT_CODE = @V_PROJECT_CODE
				AND SCM_SITE_ID = @V_SCM_SITE_ID
				AND ITEM_ID = @V_ITEM_ID
				AND DOM_EXP = @V_DOM_EXP
				AND FCST_TYPE = @V_FCST_TYPE
				AND INCOTERMS = @V_INCOTERMS
				AND PLANT_SITE_ID = @V_PLANT_SITE_ID

	PRINT ( 'D--' + CONVERT(NVARCHAR(30), GETDATE(), 121))

				WHILE ( @MKT_I <= @MKT_CNT )
				BEGIN					
					SELECT @V_MEASURE = A.MEASURE
						 , @V_YYYYMMDD = A.YYYYMMDD
						 , @V_MKT_FCST_QTY = A.QTY
						 , @V_TARGET_QTY = CASE WHEN ISNULL(A.QTY, 0) - @V_DEDUCTED_QTY < 0 THEN ISNULL(A.QTY, 0) - ISNULL(A.QTY, 0) ELSE ISNULL(A.QTY, 0) - @V_DEDUCTED_QTY END
						 , @V_REM_QTY = @V_DEDUCTED_QTY - ISNULL(A.QTY, 0)  --MKT FCST에서 실적수량을 빼고 남은 수량
					FROM #TEMP_MKT_FCST_DATA A
					WHERE DIVISION_ID = @V_DIVISION_ID
					AND PROJECT_CODE = @V_PROJECT_CODE
					AND SCM_SITE_ID = @V_SCM_SITE_ID
					AND ITEM_ID = @V_ITEM_ID
					AND DOM_EXP = @V_DOM_EXP
					AND FCST_TYPE = @V_FCST_TYPE
					AND INCOTERMS = @V_INCOTERMS
					AND PLANT_SITE_ID = @V_PLANT_SITE_ID
					AND ROW_NUM = @MKT_I

					INSERT INTO #TEMP_UPDATE_MKT_FCST
					( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
					, YYYYMMDD, PLANT_SITE_ID, QTY, BEFORE_QTY)
					VALUES
					( @V_DIVISION_ID, @V_PROJECT_CODE, @V_SCM_SITE_ID, @V_ITEM_ID, @V_DOM_EXP, @V_FCST_TYPE, @V_INCOTERMS, 'MKT_FCST'
					, @V_YYYYMMDD, @V_PLANT_SITE_ID, @V_TARGET_QTY, @V_MKT_FCST_QTY)
					
					SET @V_DEDUCTED_QTY = @V_REM_QTY

					--차감할 수치가 0보다 작은경우는 더이상 돌리지 않는다
					IF (@V_DEDUCTED_QTY < 0)
					BEGIN
						SET @MKT_I = @MKT_CNT+1
					END
					ELSE
					BEGIN
						SET @MKT_I += 1
					END
				END
				SET @I += 1
			END
		
			SET @ROWCNT = @@ROWCOUNT		

	PRINT ( 'J--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
	
			/*=====================================================================================================================================
			-- 대상데이터 LOG (START)
			=====================================================================================================================================*/	
				SET @v_log_type    = N'APPEND';  
				SET @v_log_message = N'TARGET DATA';  
				SET @v_description = N'#TEMP_UPDATE_MKT_FCST_적재완료: DIVISION_ID: ' + @p_division_id;
				SET @d_event_date  = SYSDATETIME();
				SET @n_log_count   = @ROWCNT;
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			/*=====================================================================================================================================
			-- 대상데이터 LOG (END)
			=====================================================================================================================================*/			
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			--6. 5번에서 생성한 데이터로 MKT FCST 테이블 데이터에 UPDATE 한다
			--(1). 기존수량은 ATTRIBUTE6에 보관한다.
			--(2). 해당 프로시져로 인하여 UPDATE한 데이터의 LAST_UPDATED_BY는 AUTO_DEDUCTED로 잡는다
			--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
			
			SET @ROWCNT = 0			

			UPDATE A
			SET QTY = B.QTY
			  , ATTRIBUTE6 =  B.BEFORE_QTY
			  , LAST_UPDATED_BY = @v_batch_user
			  , LAST_UPDATE_DATE = GETDATE()
			FROM DM_PLN_MKT_FCST A
			INNER JOIN #TEMP_UPDATE_MKT_FCST B
					ON A.DIVISION_ID = B.DIVISION_ID
				   AND A.PROJECT_CODE = B.PROJECT_CODE
				   AND A.SCM_SITE_ID = B.SCM_SITE_ID
				   AND A.ITEM_ID = B.ITEM_ID
				   AND A.DOM_EXP = B.DOM_EXP
				   AND A.FCST_TYPE = B.FCST_TYPE
				   AND A.INCOTERMS = B.INCOTERMS
				   AND A.MEASURE = B.MEASURE
				   AND A.YYYYMMDD = B.YYYYMMDD
				   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID

			SET @ROWCNT = @@ROWCOUNT		
						   
			/*=====================================================================================================================================
			-- UPDATE 데이터 LOG (START)
			=====================================================================================================================================*/	
			SET @v_log_type    = N'APPEND';  
			SET @v_log_message = N'MKT FCST UPDATE DATA';  
			SET @v_description = N'MKT FCST UPDATE: DIVISION_ID: ' + @p_division_id;
			SET @d_event_date  = SYSDATETIME();
			SET @n_log_count   = @ROWCNT;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
			/*=====================================================================================================================================
			-- UPDATE 데이터 LOG (END)
			=====================================================================================================================================*/	
		END

        COMMIT WORK;		
		END TRY

    BEGIN CATCH	 
	  ROLLBACK TRANSACTION AUTO_DEDUCTED;

      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  SET @v_description = '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러로그 --*/
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	  
    END CATCH;	

	/*=====================================================================================================================================
	 -- 트랜잭션 (END)
	=====================================================================================================================================*/	
	
	/*=====================================================================================================================================
	-- 종료 LOG (START)
	=====================================================================================================================================*/	

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'MKT FCST UPDATE DATA= ' + Convert(NVARCHAR(10), @ROWCNT) + '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	/*=====================================================================================================================================
	-- 종료 LOG (END)
	=====================================================================================================================================*/	

	ERR_RTN:
	IF @v_log_type = 'INVALID'
	  BEGIN
	     ROLLBACK TRANSACTION AUTO_DEDUCTED
         EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	  END 
END	
