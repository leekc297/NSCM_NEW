
/*=====================================================================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING
 * Description  : CustomerPR_DM_PLN_MKT_FCST_WEEKLY_ROLLING
 * Program History
 *=====================================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================================
 * 2017.12		DWOK/DWPARK		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28	KHSONG			DW I/F 테이블 생성 Procedure 호출 추가(개발기만 적용/운영 반영시 주석처리함) 20180703 임시 주석처리함
 * 2018.06.07	KHSONG			MKT_FCST MEASURE로 RTF생성하는부분 주석처리함
 * 2018.07.06	KHSONG			BALANCE MAKE PROCEDURE 호출추가
 * 2018.07.26	KHSONG			주석처리 PR_DM_PLN_SALES_PLAN_CUTOFF 내에서 호출되도록 변경함
 * 2018.08.06	KHSONG			주석처리 DMS_RCCP_CONV_AUTO
 * 2019.06.10	KHSONG			[CSR ID:4011692] DM 주간 Cut off 수행 기능 추가
 * 2020.07.13	P.C.I			[PJ202001380] 82사업부는 화요일 Sales Plan Weekly Cutoff 제외
 * 2020.07.22	P.C.I			[PJ202001380] Sales Plan Weekly Cutoff 제외
 * 2023.04.10	heesan91		[E20230403-000148] Active가 N으로 변경된 대상은 MKT FCST Waterfall 컷오프 될 때도 제외되게 변경 요청
 * 2024.10.30	JSSAE			[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
 * 2024.11.15	KANG.H.J		[PJ2024-50611] 소형 매출 프로세스 개선	
 * 2024.12.02	KANG.H.J		[PJ2024-50611] FROM_SITE_ID가 추가된 'DM_PLN_RTF_ALLOCATION_C' 테이블 MKT Fcst Cutoff(전 사업부대상)
 * 2025.01.07	JSSBAE			[PJ20228272]_KPI 완료 후 생성에서 NET DEMAND 생성 후로 위치 변경 
 * 2025.02.05	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025.04.08	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.24	KANG.H.J		[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 조건절 보완
 * 2025.05.07	KANG.H.J		[PJ2025-50188] 기준수요 (SCM_FCST 기반 NET_DEMAND 생성)
 * 2025.05.13	KANG.H.J		[PJ2025-50188] 기준수요 - MF_W/SF_W 모든 상황에서 NET_DEMAND 생성됨.
 * 2025.05.20	KANG.H.J		[PJ2025-50188] 기준수요 - DM_PLN_MKT_FCST에 SCM_FCST MEASURE 동기화 로직 추가.
 * 2025.05.29	JSSBAE			[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 * 2025.06.13	JSSBAE			[E20250612-001460]_KPI 배치 중단 요청
 * 2025.06.23	KANG.H.J		[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.25	KANG.H.J		[PJ2025-50188] WEEKLY CUTOFF시 PRICE 부문 / EXCHANGE 부문도 CUTOFF 처리
 * 2025.08.25	JSSBAE			[E20250805-000632]_MKT FCST Cutoff 프로시저 모니터링용 SMS 발송
 * 2026.01.21	JSSBAE			[E20260107-001651]_BPS 전송 데이터 From_Site_ID 생성 로직 개선
 *====================================================================================================================================================================*/
 CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING]
	  @p_division_id			NVARCHAR(MAX)
	, @p_ver_description		NVARCHAR(MAX)
	, @p_ver_type				NVARCHAR(MAX)
	, @p_rolling_type			NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	--================================================================================================================
	-- 000	: VARIABLE DECLARATION
	--================================================================================================================	
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_ver_description		NVARCHAR(MAX);
	DECLARE @v_ver_type				NVARCHAR(MAX);
	DECLARE @v_rolling_type			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE	@v_ver_return_no		NVARCHAR(100);	-- cut off Generated Number	
	DECLARE @n_history_seq			INTEGER;
	DECLARE @v_plan_week			NVARCHAR(MAX);
	DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	
	DECLARE @v_delimiter			NVARCHAR(1)
	DECLARE @max_loop_cnt			INTEGER = 0; 
	DECLARE @mst_loop_cnt			INTEGER = 0;

	SET		@v_division_id			= NULL;	
	SET		@v_ver_description		= NULL;	
	SET		@v_ver_type				= NULL;	
	SET		@v_rolling_type			= NULL;	
	SET		@v_created_by			= NULL;	
	SET		@v_delimiter			= '^'
	
	--================================================================================================================
	-- LOG 용 변수 설정
	--================================================================================================================
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	
	--================================================================================================================
	-- 100 : START LOG
	--================================================================================================================
	SET @v_log_type		= 'START';
	SET @v_log_message	= '########## Start of procedure ##########';
	SET @v_description	= 'Div: ' + @p_division_id +' / ' + @p_ver_type;
	SET @d_event_date	= SYSDATETIME();
	
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET	@v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	--------------------------------------------------------------------------------------------------------------------
	-- [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (START)
	--------------------------------------------------------------------------------------------------------------------
    DECLARE @v_category_name			NVARCHAR(150) = 'MKT FCST WEEKLY CUTOFF';

	IF @p_ver_type != 'MF_D'
		EXEC [dbo].[PR_DM_SMS_LOG_BATCH] @v_category_name, @v_log_type, @v_description, @d_event_date;
	--------------------------------------------------------------------------------------------------------------------
	-- [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (END)
	--------------------------------------------------------------------------------------------------------------------

	BEGIN TRAN 	
	--================================================================================================================
	-- 200 : MAIN LOGIC
	--================================================================================================================
	BEGIN TRY
		--------------------------------------------------------------------------------------------------------------
		-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (START)
		--------------------------------------------------------------------------------------------------------------
		IF ( @p_ver_type = 'MF_W' OR @p_ver_type = 'SF_W' ) -- [PJ2025-50188] SF_W도 추가됨.
		AND	( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			  WHERE LOOKUP_TYPE = 'WEEKLY_CUTOFF_YN'
			  AND SEGMENT1 = @p_division_id
			  AND VALID_YN = 'Y') <> 'Y'
		BEGIN
			SET @v_log_type = 'INVALID'
			SELECT N'LOOKUP 테이블에 WEEKLY_CUTOFF_YN 값의 설정이 실행불가로 설정되어 있습니다!'
			SET @v_description = 'Div: ' + @p_division_id + ' / ' + N'LOOKUP 테이블에 WEEKLY_CUTOFF_YN 값의 설정이 실행불가로 설정되어 있습니다!'
			GOTO ERR_RTN
		END
		
		--------------------------------------------------------------------------------------------------------------
		-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (END)
		--------------------------------------------------------------------------------------------------------------
		BEGIN
			SET @v_division_id = @p_division_id;
			SELECT @v_division_id

			BEGIN
				SET @v_plan_week = ( SELECT A.ISO_YYYYWW FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
									 WHERE  A.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112))
			END
			SELECT @v_plan_week;

			SET @v_ver_description = @p_ver_description;
			SELECT @v_ver_description

			SET @v_ver_type = @p_ver_type;
			SELECT @v_ver_type

			SET @v_rolling_type = @p_rolling_type;
			SELECT @v_rolling_type

			SET @v_created_by = @p_created_by;
			SELECT @v_created_by
		END

		BEGIN
			EXEC PR_DM_PLN_VERSION_CREATE @v_division_id, @v_ver_description, @v_ver_type, @v_created_by, @v_ver_return_no  OUTPUT,	@v_OK_description OUTPUT
					
			SELECT @v_ver_return_no; --Output;
			SELECT @v_OK_description;

		/* [2018-03-29][PROCEDURE로 분리] */-----------------------------BEGIN
		--select '2'

		--	SELECT RIGHT(@v_ver_type,1);

		--	IF RIGHT(@v_ver_type,1) = 'W'		-- WEEKLY로 인입되었을때 [QTY] = 0 값들을 삭제처리
		--	BEGIN
		--		DELETE FROM [dbo].[DM_PLN_MKT_FCST]
		--		WHERE		[DIVISION_ID] = @v_division_id
		--				AND [YYYYMMDD]	 >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		--				AND [QTY] = 0
		--		;
				
		--		-- 전주차의  'MKT_FCST',  'CUST_FCST' ,'MKT_FCST_LATEST', 'CUST_FCST_LATEST' 값을 실적 table로 옮김
		--		DELETE FROM [dbo].[DM_PLN_MKT_FCST_RESULT]
		--		WHERE		[DIVISION_ID] = @v_division_id
		--			--AND [MEASURE]   IN ( 'MKT_FCST', 'CUST_FCST', 'MKT_FCST_LATEST', 'CUST_FCST_LATEST' )			-- [2018-03-28][수정]
		--			AND [MEASURE]   IN ( 'MKT_FCST', 'CUST_FCST' )
		--			AND [YYYYMMDD]  <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		--			AND [YYYYMMDD]  >=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		--		;

		--		INSERT INTO [dbo].[DM_PLN_MKT_FCST_RESULT]
		--			(
		--				[DIVISION_ID]
  --                      ,[PROJECT_CODE]
  --                      ,[SCM_SITE_ID]
  --                      ,[ITEM_ID]
  --                      ,[DOM_EXP]
  --                      ,[FCST_TYPE]
  --                      ,[INCOTERMS]
  --                      ,[MEASURE]
  --                      ,[PLANT_SITE_ID]
  --                      ,[YYYYMMDD]
  --                      ,[QTY]
  --                      ,[CREATED_BY]
  --                      ,[CREATION_DATE]
  --                      ,[LAST_UPDATED_BY]
  --                      ,[LAST_UPDATE_DATE]
  --                      ,[ATTRIBUTE1]
  --                      ,[ATTRIBUTE2]
  --                      ,[ATTRIBUTE3]
  --                      ,[ATTRIBUTE4]
  --                      ,[ATTRIBUTE5]
  --                      ,[ATTRIBUTE6]
  --                      ,[ATTRIBUTE7]
  --                      ,[ATTRIBUTE8]
  --                      ,[ATTRIBUTE9]
  --                      ,[ATTRIBUTE10]
		--			)
		--		SELECT [DIVISION_ID]
  --                      ,[PROJECT_CODE]
  --                      ,[SCM_SITE_ID]
  --                      ,[ITEM_ID]
  --                      ,[DOM_EXP]
  --                      ,[FCST_TYPE]
  --                      ,[INCOTERMS]
  --                      ,[MEASURE]
  --                      ,[PLANT_SITE_ID]
  --                      ,[YYYYMMDD]
  --                      ,[QTY]
  --                      ,[CREATED_BY]
  --                      ,[CREATION_DATE]
  --                      ,[LAST_UPDATED_BY]
  --                      ,[LAST_UPDATE_DATE]
  --                      ,[ATTRIBUTE1]
  --                      ,[ATTRIBUTE2]
  --                      ,[ATTRIBUTE3]
  --                      ,[ATTRIBUTE4]
  --                      ,[ATTRIBUTE5]
  --                      ,[ATTRIBUTE6]
  --                      ,[ATTRIBUTE7]
  --                      ,[ATTRIBUTE8]
  --                      ,[ATTRIBUTE9]
  --                      ,[ATTRIBUTE10]
		--			FROM [dbo].[DM_PLN_MKT_FCST]
  --                  WHERE [DIVISION_ID] = @v_division_id
		--			AND [MEASURE]   IN ( 'MKT_FCST', 'CUST_FCST', 'MKT_FCST_LATEST','CUST_FCST_LATEST' )
		--			AND [YYYYMMDD]  <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		--			AND [YYYYMMDD]  >=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 

		--	END
		/* [2018-03-29][PROCEDURE로 분리] */-----------------------------END

/*  -- 20180607 KHSONG MKT_FCST MEASURE로 RTF생성하는부분 주석처리함
			------------------------------------------------------------------------------------------------------------------------------------------------
			-- [20180402 SONGKEEHO ADDED] SCP Open(2018.06월)전까지는 Sales Plan계산을 위하여 MKT FCST와 RTF를 맞춰주는 작업필요하여 RTF INSERT  (START)
			BEGIN
			  -- INSERT 전 삭제
			  DELETE  FROM	[dbo].[DM_PLN_MKT_FCST]
						WHERE	[DIVISION_ID]  = @v_division_id
							AND [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
							AND MEASURE = 'RTF'

			  -- INSERT 수행
			  INSERT   [dbo].[DM_PLN_MKT_FCST]
						( DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
						,MEASURE
						,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
						,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						)
				 SELECT 
						 DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
						,'RTF'  AS  MEASURE
						,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
						,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
					FROM [dbo].[DM_PLN_MKT_FCST] WITH(NOLOCK) 
					  WHERE	 [DIVISION_ID]  = @v_division_id
							 AND [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
							 AND MEASURE = 'MKT_FCST'

			END
			-- [20180402 SONGKEEHO ADDED] SCP Open(2018.06월)전까지는 Sales Plan계산을 위하여 MKT FCST와 RTF를 맞춰주는 작업필요하여 RTF INSERT  (END)
			------------------------------------------------------------------------------------------------------------------------------------------------
*/  -- 20180607 KHSONG MKT_FCST MEASURE로 RTF생성하는부분 주석처리함

SELECT '0'			
			----------------------------------------------------------------------------------------------------------
			-- [PJ2025-50188] 기준수요 기반 CUTOFF 기능 추가 (START)
			----------------------------------------------------------------------------------------------------------
			BEGIN 
				------------------------------------------------------------------------------------
				-- 화.00시(MKT_FCST) 일 때는 SCM_FCST Delete ==> Insert 처리
				-- 화.14시(SCM_FCST) 일 때는 SCM_FCST CUTOFF 처리
				------------------------------------------------------------------------------------
				IF ( @v_division_id = '40' AND @p_ver_type = 'MF_W' )		--[PJ2025-50188] SF_W CUTOFF 시점에 DM_PLN_CFM_MKT_DEMAND_PLAN (MKT_FCST ==> SCM_FCST 동기화)
				BEGIN
					------------------------------------------------------------------------------------
					-- [PJ2025-50188] DM_PLN_MKT_FCST (MKT_FCST ==> SCM_FCST) 동기화
					-- [PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN (MKT_FCST ==> SCM_FCST) 동기화
					------------------------------------------------------------------------------------
					DELETE DM_PLN_MKT_FCST
					WHERE DIVISION_ID = @v_division_id
					AND   YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					AND   MEASURE = 'SCM_FCST';

					INSERT INTO DM_PLN_MKT_FCST 
					( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
					, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
					SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'SCM_FCST' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY
						 , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
					FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.MEASURE		= 'MKT_FCST'
					AND	  A.YYYYMMDD	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);
					
					DELETE DM_PLN_CFM_MKT_DEMAND_PLAN
					WHERE DIVISION_ID = @v_division_id
					AND   YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					AND   MEASURE = 'SCM_FCST';

					INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN 
					( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY
					, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
					SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'SCM_FCST' AS MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
						 , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
					FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
					WHERE A.DIVISION_ID	= @v_division_id
					AND   A.MEASURE		= 'MKT_FCST'
					AND	  A.YYYYMMDD	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);
				END
			END			
SELECT '1'		
			BEGIN
				INSERT DM_PLN_MKT_FCST_C
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
				, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
				, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
				SELECT @v_division_id AS DIVISION_ID, @v_ver_return_no AS VERSION_NO, @v_ver_type AS CUTOFF_TYPE, CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD
					 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,	A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, @v_created_by AS CREATED_BY
					 , A.CREATION_DATE,	A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7
					 , A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
				FROM ( SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID, F.YYYYMMDD, F.QTY
							, F.CREATED_BY, F.CREATION_DATE, F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE1, F.ATTRIBUTE2, F.ATTRIBUTE3, F.ATTRIBUTE4, F.ATTRIBUTE5
							, F.ATTRIBUTE6, F.ATTRIBUTE7, F.ATTRIBUTE8, F.ATTRIBUTE9, F.ATTRIBUTE10
					   FROM	DM_PLN_MKT_FCST F WITH(NOLOCK)
					   INNER JOIN SCM_MST_SITE_ITEM	T2 WITH(NOLOCK)  --20230410 JHS [E20230403-000148]
							   ON F.DIVISION_ID		= T2.DIVISION_ID
							  AND F.PROJECT_CODE	= T2.PROJECT_CODE
						      AND F.SCM_SITE_ID		= T2.SCM_SITE_ID
						      AND F.ITEM_ID			= T2.ITEM_ID
						      AND T2.VALID_YN		= 'Y'
					   WHERE F.DIVISION_ID  = @v_division_id
					   AND   F.YYYYMMDD	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					   AND   F.MEASURE NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
					   UNION ALL
					   SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID, F.YYYYMMDD, F.QTY
							, F.CREATED_BY, F.CREATION_DATE, F.LAST_UPDATED_BY, F.LAST_UPDATE_DATE, F.ATTRIBUTE1, F.ATTRIBUTE2, F.ATTRIBUTE3, F.ATTRIBUTE4, F.ATTRIBUTE5
							, F.ATTRIBUTE6, F.ATTRIBUTE7, F.ATTRIBUTE8, F.ATTRIBUTE9, F.ATTRIBUTE10
					   FROM	DM_PLN_MKT_FCST F WITH(NOLOCK)
					   INNER JOIN SCM_MST_SITE_ITEM	T2 WITH(NOLOCK)  --20230410 JHS [E20230403-000148]
							   ON F.DIVISION_ID		= T2.DIVISION_ID
							  AND F.PROJECT_CODE	= T2.PROJECT_CODE
						      AND F.SCM_SITE_ID		= T2.SCM_SITE_ID
						      AND F.ITEM_ID			= T2.ITEM_ID
						      AND T2.VALID_YN		= 'Y'
					   WHERE F.DIVISION_ID  = @v_division_id
					   AND   F.YYYYMMDD	 >=  CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 최근 1년치
					   AND   F.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
					 ) A		
			END	
SELECT '3'		
			BEGIN
				INSERT DM_PLN_MKT_FCST_RESULT_C
				( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
				, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
				, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID --	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				)
				SELECT @v_division_id AS DIVISION_ID, @v_ver_return_no AS VERSION_NO, @v_ver_type AS CUTOFF_TYPE, CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD
					 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,	A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE
					 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.CELL_PROD_SITE_ID	 -- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가			
				FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY
							, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7
							, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					   FROM	DM_PLN_MKT_FCST_RESULT WITH(NOLOCK)  
					   WHERE DIVISION_ID  =  @v_division_id
					   AND   YYYYMMDD	  <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	 -- [2018-03-28][추가][금주 월요일 이전]
					   AND   YYYYMMDD	  >= CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 최근 1년치
					 ) A		
			END	
SELECT '4'		
						
		END;

		BEGIN
			----------------------------------------------------------------------------------------------------------
			--[PJ2025-50188]  DM_PLN_CFM_MKT_DEMAND_PLAN CUTOFF  (START)
			----------------------------------------------------------------------------------------------------------
			DELETE DM_PLN_CFM_MKT_DEMAND_PLAN_C
			WHERE DIVISION_ID		= @v_division_id
			AND   VERSION_NO		= @v_ver_return_no
			AND   CUTOFF_TYPE		= @v_ver_type
			AND   CUTOFF_YYYYMMDD	= CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);

			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C 
			( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
			, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
			, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE 
			--[E20260107-001651]_ATTRIBUTE 영역 추가 START
			, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
			--[E20260107-001651]_ATTRIBUTE 영역 추가 END
			SELECT A.DIVISION_ID, @v_ver_return_no AS VERSION_NO, @v_ver_type AS CUTOFF_TYPE, CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS CUTOFF_YYYYMMDD
				 , A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
				 , A.YYYYMMDD, A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
				 --[E20260107-001651]_ATTRIBUTE 영역 추가 START
				 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
				 --[E20260107-001651]_ATTRIBUTE 영역 추가 END
			FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
			INNER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)  
					ON A.DIVISION_ID	= B.DIVISION_ID
				   AND A.PROJECT_CODE	= B.PROJECT_CODE		
				   AND A.END_CUSTOMER	= CASE WHEN A.DIVISION_ID = '40' THEN B.PROJECT_CODE ELSE '' END -- 중요 (PROJECT_CODE와 END_CUSTOMER)
				   AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				   AND A.ITEM_ID		= B.ITEM_ID
				   AND B.VALID_YN		= 'Y'
			WHERE A.DIVISION_ID			= @v_division_id
			AND	  A.YYYYMMDD			>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);
			----------------------------------------------------------------------------------------------------------
			--[PJ2025-50188] DM_PLN_CFM_MKT_DEMAND_PLAN CUTOFF (END)
			----------------------------------------------------------------------------------------------------------
		END
				
		--------------------------------------------------------------------------------------------------------------
		-- [PJ2025-50188] 기준수요 기반 CUTOFF 기능 추가 END
		--------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------
		--20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
		--EXEC [dbo].PR_DM_TO_XIF_DM_PLN_MKT_FCST_C @p_division_id, @v_ver_return_no
		--------------------------------------------------------------------------------------------------------------
		COMMIT TRAN ;	 
	END TRY
	
	--================================================================================================================
	--300 : ERROR TRAP
	--================================================================================================================

	BEGIN CATCH
SELECT 'ERROR1'
		--------------------------------------------------------------------------------------------------------------
		-- ERROR 발생시 ROLLBACK 후 ERROR 로그 생성
		--------------------------------------------------------------------------------------------------------------
		ROLLBACK TRAN;	

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		
SELECT 'ERROR2'
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']_O' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		
SELECT 'ERROR3'
		SELECT @@TRANCOUNT AS trancnt2;SELECT @@error ;
		
SELECT 'ERROR4'
		IF @v_OK_description <> 'OK'
		SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));

		select XACT_STATE()	AS 'XACT_STATE';  
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH

	SET NOCOUNT OFF;
	
	--================================================================================================================
	-- 400 : SUB PROCEDURE CALL
	--================================================================================================================	
	------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50188] WEEKLY CUTOFF시 PRICE 부문 / EXCHANGE 부문도 CUTOFF 처리 (40사업부에 한정) (START)
	------------------------------------------------------------------------------------------------------------------
	IF ((@v_division_id = '40') AND (@v_ver_type = 'MF_D' OR @v_ver_type = 'MF_W' OR @v_ver_type = 'SF_W'))				
	BEGIN
		EXEC PR_SCM_MST_FUTURE_PRICE_CUTOFF	@v_division_id, @p_ver_type, @p_created_by, @v_ver_return_no;			
	END
	------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50188] WEEKLY CUTOFF시 PRICE 부문 / EXCHANGE 부문도 CUTOFF 처리 (40사업부에 한정) (END)
	------------------------------------------------------------------------------------------------------------------	
	------------------------------------------------------------------------------------------------------------------
	-- UI 에서 수행한 수동 CutOff 인경우는 별도 다른 Procedure 를 호출하지 않음
	------------------------------------------------------------------------------------------------------------------
	IF @p_ver_type <> 'MF_M'  
	BEGIN
		--------------------------------------------------------------------------------------------------------------
		-- 수행결과 성공여부 DISPLAY
		-- Weekly Rolling 시에 [dbo].[DM_PLN_MKT_FCST] 에 당주 이후  MKT_FCST_LATEST 값을 다 Delete 하고 
		-- MKT_FCST 값을 그대로 select 해다가 Measure 값 MKT_FCST_LATEST로 Insert 하는 Procedure
		--EXEC	[dbo].[PR_DM_PLN_MKT_FCST_LASTEST_MEASURE]			
		--			@v_division_id
		--------------------------------------------------------------------------------------------------------------
		
		--------------------------------------------------------------------------------------------------------------
		-- RTF 값에 Sales Price가 곱해져서 KRW, LOC, USD Measure를 정상적으로 생성하는 프로시저 -> Sales Plan 데이터 생성
		--------------------------------------------------------------------------------------------------------------
		EXEC PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW @v_division_id					, ''

		/*  20180726 KHSONG 주석처리 PR_DM_PLN_SALES_PLAN_CUTOFF 내에서 호출되도록 변경함
		-- [2018-02-12][추가][Sales Price의 SCM_MST_FUTURE_PRICE_C 테이블 INSERT]
		EXEC	[dbo].[PR_SCM_MST_FUTURE_PRICE_CUTOFF]	
					@v_division_id */					
		--------------------------------------------------------------------------------------------------------------
		-- [2018-02-12][추가][Sales Price의 SCM_MST_FUTURE_PRICE_C 테이블 INSERT]
		--------------------------------------------------------------------------------------------------------------
		IF (@v_ver_type = 'MF_W' OR @v_ver_type = 'SF_W') -- [PJ2025-50188] SF_W 추가
		BEGIN
			----------------------------------------------------------------------------------------------------------
			-- 전주 MKT FCST 데이터를 생성함 => MKT_FCST_LATEST
			----------------------------------------------------------------------------------------------------------
			EXEC PR_DM_PLN_MKT_FCST_LASTEST_MEASURE @v_division_id

			--IF (( @v_division_id = '40' AND @v_ver_type = 'SF_W' ) OR ( @v_division_id != '40' )) 	--[PJ2025-50188] 40사업부는 SCM_FCST 기반으로만 생성. 그외는 MKT_FCST 기반으로만 생성 ==> 수정 (모든 상황에서 net_demand 생성됨.)
			BEGIN	
				----------------------------------------------------------------------------------------------------------
				-- 전사업부 모든 버젼에서 DM_PLN_NET_DEMAND 생성함.
				----------------------------------------------------------------------------------------------------------
				-- [2018-03-29][SONGKEEHO추가][DM_PLN_MKT_FCST_C 데이터로 -> DM_PLN_NET_DEMAND 데이터 생성]
				EXEC [dbo].[PR_DM_PLN_MKT_FCST_TO_NET_DEMAND]	@v_division_id
				-- [PJ20228272]_KPI 완료 후 생성에서 NET DEMAND 생성 후로 위치 변경 
				-- [2018-04-27][추가][PEGGING PROCEDURE]
				EXEC [dbo].[PR_DM_PLN_DEMANDID_PEGGING]		@v_division_id
			END
			
			----------------------------------------------------------------------------------------------------------
			--[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
			--24.10.30 확인 당시에는 SP_D를 보여주는 화면이 존재하지 않고,
			--해당 작업은 SALES CUTOFF시 SALES PLAN RESULT에 데이터를 반영하기 위함으로 확인됨
			--현재 SALES PLAN CUTOFF 시간이 변경되면 MKT FCST CUTOFF와 RTF DIFF가 발생함에 따라,
			--해당 작업을 MKT FCST CUTOFF시 진행하는 부분으로 변경하여, MKT FCST CUTOFF와의 DIFF를 없애는 방법 진행
			--하여 MF_W에 진행하는 부분으로 수정함
			----------------------------------------------------------------------------------------------------------

			IF (@v_ver_type = 'MF_W' )	--[PJ2025-50188] MF_W 기준에서만 DALIY_CUTOFF 수행. SF_W에서도 수행할 경우 V002가 생성되지 많도록 처리
			BEGIN
				EXEC PR_DM_PLN_SALES_PLAN_CUTOFF
				  @v_division_id
				, 'DM_PLN_SALES_PLAN DAILY CUTOFF' -- @v_ver_description  -- DAILY 배치작업과 수동작업을 구분함
				, 'SP_D'  --@p_ver_type
				, @p_created_by
			END

			--[PJ202001380] 화요일 Sales Plan Weekly Cutoff 제외
			/*IF @v_division_id <> '82'
			BEGIN
				EXEC	[dbo].[PR_DM_PLN_SALES_PLAN_CUTOFF]
							@v_division_id
							,'DM_PLN_SALES_PLAN WEEKLY CUTOFF' -- @v_ver_description  -- DAILY 배치작업과 수동작업을 구분함
							,'SP_W'  --@p_ver_type
							,@p_created_by
			END*/

			-- [2018-04-09][추가][자동차 사업부 MKT FCST데이터를 DMS_RCCP_DP_VIEW 테이블 INSERT]
			--EXEC [dbo].[DMS_RCCP_CONV_AUTO] --20180806 KHSONG 주석처리

			-- [2018-04-20][추가][KPI PROCEDURE]
			--[E20250612-001460]_KPI 배치 중지 현재 사용하는 부분이 없는 것으로 확인되어 배치를 중단한다. START
			/*
			--KPI 두 배치 중지 이유: ① 사용하지 않는 메져 ② 해당 프로시져 수행시간이 오래걸려 프로시져로 인하여 타시스템도 영향감
			--PR_DM_PLN_MKT_FCST_KPI 생성하는 메져는: 'OVER_FCST', 'LESS_FCST', 'CFA', 'SFA'
			--해당 메져를 사용하는 화면: MKT_FCST, MKT_FCST_WATERALL / 사업부: 전사업부
			--UI CATEGORY에서도 메져는 VALID_YN N처리 진행
			EXEC [dbo].[PR_DM_PLN_MKT_FCST_KPI]		21, @v_division_id 
				
			--PR_DM_PLN_MKT_FCST_KPI_CFCR 생성하는 메져는: 'CFCR'
			--해당 메져를 사용하는 화면: MKT_FCST, MKT_FCST_WATERALL / 사업부: 전사업부
			--UI CATEGORY에서도 메져는 VALID_YN N처리 진행
			EXEC [dbo].[PR_DM_PLN_MKT_FCST_KPI_CFCR]	@v_division_id 
			*/
			--[E20250612-001460]_KPI 배치 중지 현재 사용하는 부분이 없는 것으로 확인되어 배치를 중단한다. END

			-----------------------------------------------------------------------------------------------------------------------------------
			--[E20250529-001289]_MKT FCST CUTOFF가 완료되고나면 메일을 발송한다.  
			-----------------------------------------------------------------------------------------------------------------------------------
			EXEC PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND @p_division_id, @v_ver_return_no

		END
		ELSE
		BEGIN
			--[E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
			--24.10.30 확인 당시에는 SP_D를 보여주는 화면이 존재하지 않고,
			--해당 작업은 SALES CUTOFF시 SALES PLAN RESULT에 데이터를 반영하기 위함으로 확인됨
			--현재 SALES PLAN CUTOFF 시간이 변경되면 MKT FCST CUTOFF와 RTF DIFF가 발생함에 따라,
			--해당 작업을 MKT FCST CUTOFF시 진행하는 부분으로 변경하여, MKT FCST CUTOFF와의 DIFF를 없애는 방법 진행
			--하여 해당 작업은 주석처리하고, MF_W에 진행하는 부분으로 수정함
			/*
			EXEC	[dbo].[PR_DM_PLN_SALES_PLAN_CUTOFF]
						@v_division_id
						,'DM_PLN_SALES_PLAN DAILY CUTOFF' -- @v_ver_description  -- DAILY 배치작업과 수동작업을 구분함
						,'SP_D'  --@p_ver_type
						,@p_created_by
			*/

			-- 20180706 KHSONG BALANCE MAKE PROCEDURE 호출추가
			BEGIN
				EXEC PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 
					 @v_division_id    -- DIVISION ID
				   , NULL              -- plan_id
			END
		END

		-- [2018-03-29][SONGKEEHO추가][DM_PLN_MKT_FCST_C 데이터로 -> DM_PLN_NET_DEMAND 데이터 생성]
		--EXEC	[dbo].[PR_DM_PLN_MKT_FCST_TO_NET_DEMAND]	
		--			@v_division_id

		-- [2018-03-28][추가]
		--IF @v_ver_type = 'MF_D'
		--BEGIN
		--	-- [2018-03-28][추가][DM_PLN_MKT_FCST_C][Daily Batch에 CUTOFF PROCEDURE 추가]
		--	EXEC	[dbo].[PR_DM_PLN_MKT_FCST_CUTOFF]	@v_division_id

		--	-- [2018-03-28][추가][DM_PLN_MKT_FCST_RESULT_C][Daily Batch에 CUTOFF PROCEDURE 추가]
		--	EXEC	[dbo].[PR_DM_PLN_MKT_FCST_RESULT_CUTOFF]	@v_division_id	
		--END

		----------------------------------------------------------------------------------------------------------
	END
   
	--================================================================================================================
	-- 500 : END LOG
	--================================================================================================================
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'Div: ' + @p_division_id +' / ' + @p_ver_type;
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------------------------------------------------------------
	-- [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (START)
	--------------------------------------------------------------------------------------------------------------------
	IF @p_ver_type != 'MF_D'
		EXEC [dbo].[PR_DM_SMS_LOG_BATCH] @v_category_name, @v_log_type, @v_description, @d_event_date;
	--------------------------------------------------------------------------------------------------------------------
	-- [E20250805-000632]_MKT FCST Cutoff WEEKLY [MF_D가 아닌 경우 모두 발송] 모니터링용 SMS 발송 (END)
	--------------------------------------------------------------------------------------------------------------------	
	--================================================================================================================
	-- 트랜잭션 (END)	
	--================================================================================================================
	--================================================================================================================
	-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (START)
	--================================================================================================================
	ERR_RTN:
	IF @v_log_type = 'INVALID'
	BEGIN
		ROLLBACK TRAN

		SET @v_log_message = '########## END of procedure ##########';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END
	--================================================================================================================
	-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (END)
	--================================================================================================================
  END;  
