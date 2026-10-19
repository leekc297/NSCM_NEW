
/*
 * Program ID   : PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_ESS
 * Description  : CustomerPR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_ESS
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12.     DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180528		 KHSONG			  DW I/F 테이블 생성 Procedure 호출 추가(개발기만 적용/운영 반영시 주석처리함) 20180703 임시 주석처리함
 * 20180607 KHSONG MKT_FCST MEASURE로 RTF생성하는부분 주석처리함
 * 20180706 KHSONG BALANCE MAKE PROCEDURE 호출추가
 * 20180726 KHSONG 주석처리 PR_DM_PLN_SALES_PLAN_CUTOFF 내에서 호출되도록 변경함
 * 20180806 KHSONG 주석처리 DMS_RCCP_CONV_AUTO
 * 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가
 * 20200713 P.C.I   [PJ202001380] 82사업부는 화요일 Sales Plan Weekly Cutoff 제외
 * 20200722 P.C.I   [PJ202001380] Sales Plan Weekly Cutoff 제외
 * 20230410 heesan91 [E20230403-000148] Active가 N으로 변경된 대상은 MKT FCST Waterfall 컷오프 될 때도 제외되게 변경 요청
 */

 --EXEC PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_ESS '82', N'INVENTORY DAYS 영향도분석', 'MF_W', 'Weekly Rolling', 'SYSTEM'

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_ESS]
	@p_division_id			NVARCHAR(MAX),
	@p_ver_description		NVARCHAR(MAX),
	@p_ver_type				NVARCHAR(MAX),
	@p_rolling_type			NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)

AS

BEGIN


	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	/*
		-----------------------------------------------------------------------------------------
		000
			: VARIABLE DECLARATION
		-----------------------------------------------------------------------------------------
	*/
	
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

	SET @v_division_id		 = NULL;	
	SET @v_ver_description	 = NULL;	
	SET @v_ver_type			 = NULL;	
	SET @v_rolling_type		 = NULL;	
	SET @v_created_by		 = NULL;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	---- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_ESS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	/*
		-----------------------------------------------------------------------------------------
		100
			: START LOG
		-----------------------------------------------------------------------------------------
	*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = 'Div: '+@p_division_id;
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN 

	/*
		-----------------------------------------------------------------------------------------
		200
			: MAIN LOGIC
		-----------------------------------------------------------------------------------------
	*/
	BEGIN TRY

		------------------------------------------------------------------------------------
		-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (BEGIN)
		------------------------------------------------------------------------------------
		IF @p_ver_type = 'MF_W'  AND
			(SELECT SEGMENT2
				FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
				WHERE LOOKUP_TYPE = 'WEEKLY_CUTOFF_YN'
					AND SEGMENT1 = @p_division_id
					AND VALID_YN = 'Y') <> 'Y'

			BEGIN
				SET @v_log_type = 'INVALID'
				SELECT N'LOOKUP 테이블에 WEEKLY_CUTOFF_YN 값의 설정이 실행불가로 설정되어 있습니다!'
				SET @v_description = 'Div: ' + @p_division_id + ' / ' + N'LOOKUP 테이블에 WEEKLY_CUTOFF_YN 값의 설정이 실행불가로 설정되어 있습니다!'
				GOTO ERR_RTN
			END

		------------------------------------------------------------------------------------
		-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (END)
		------------------------------------------------------------------------------------
		BEGIN
			SET @v_division_id = @p_division_id;
			SELECT @v_division_id
			BEGIN
				SET @v_plan_week = 
				(
					SELECT a.ISO_YYYYWW   
					FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
					WHERE  a.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				)
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
			EXEC	[dbo].[PR_DM_PLN_VERSION_CREATE]	--@return_value = [dbo].[PR_DM_PLN_VERSION_CREATE]
			@v_division_id,
			@v_ver_description,
			@v_ver_type,
			@v_created_by,
			@v_ver_return_no  OUTPUT,
			@v_OK_description OUTPUT
					
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

		select '1'

			BEGIN
				INSERT [dbo].[DM_PLN_MKT_FCST_C]
				(
					[DIVISION_ID]
					,[VERSION_NO]
					,[CUTOFF_TYPE]
					,[CUTOFF_YYYYMMDD]
					,[PROJECT_CODE]
					,[SCM_SITE_ID]
					,[ITEM_ID]
					,[DOM_EXP]
					,[FCST_TYPE]
					,[INCOTERMS]
					,[MEASURE]
					,[PLANT_SITE_ID]
					,[YYYYMMDD]
					,[QTY]
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE]
					,[ATTRIBUTE1]
					,[ATTRIBUTE2]
					,[ATTRIBUTE3]
					,[ATTRIBUTE4]
					,[ATTRIBUTE5]
					,[ATTRIBUTE6]
					,[ATTRIBUTE7]
					,[ATTRIBUTE8]
					,[ATTRIBUTE9]
					,[ATTRIBUTE10]						
				)
				SELECT 
					@v_division_id AS [DIVISION_ID], 
					@v_ver_return_no AS [VERSION_NO],
					@v_ver_type AS [CUTOFF_TYPE],
					CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS [CUTOFF_YYYYMMDD],
					A.[PROJECT_CODE] AS [PROJECT_CODE],
					A.[SCM_SITE_ID] AS [SCM_SITE_ID],
					A.[ITEM_ID] AS [ITEM_ID],
					A.[DOM_EXP] AS [DOM_EXP],
					A.[FCST_TYPE] AS [FCST_TYPE],
					A.[INCOTERMS] AS [INCOTERMS],
					A.[MEASURE] AS [MEASURE],
					A.[PLANT_SITE_ID] AS [PLANT_SITE_ID],
					A.[YYYYMMDD] AS [YYYYMMDD],
					A.[QTY] AS [QTY],
					@v_created_by AS [CREATED_BY],
					A.[CREATION_DATE] AS [CREATION_DATE],
					A.[LAST_UPDATED_BY] AS [LAST_UPDATED_BY],
					A.[LAST_UPDATE_DATE] AS [LAST_UPDATE_DATE],
					A.[ATTRIBUTE1] AS [ATTRIBUTE1],
					A.[ATTRIBUTE2] AS [ATTRIBUTE2],
					A.[ATTRIBUTE3] AS [ATTRIBUTE3],
					A.[ATTRIBUTE4] AS [ATTRIBUTE4],
					A.[ATTRIBUTE5] AS [ATTRIBUTE5],
					A.[ATTRIBUTE6] AS [ATTRIBUTE6],
					A.[ATTRIBUTE7] AS [ATTRIBUTE7],
					A.[ATTRIBUTE8] AS [ATTRIBUTE8],
					A.[ATTRIBUTE9] AS [ATTRIBUTE9],
					A.[ATTRIBUTE10]	AS [ATTRIBUTE10]					
				FROM
				(
						SELECT F.[DIVISION_ID]
								,F.[PROJECT_CODE]
								,F.[SCM_SITE_ID]
								,F.[ITEM_ID]
								,F.[DOM_EXP]
								,F.[FCST_TYPE]
								,F.[INCOTERMS]
								,F.[MEASURE]
								,F.[PLANT_SITE_ID]
								,F.[YYYYMMDD]
								,F.[QTY]
								,F.[CREATED_BY]
								,F.[CREATION_DATE]
								,F.[LAST_UPDATED_BY]
								,F.[LAST_UPDATE_DATE]
								,F.[ATTRIBUTE1]
								,F.[ATTRIBUTE2]
								,F.[ATTRIBUTE3]
								,F.[ATTRIBUTE4]
								,F.[ATTRIBUTE5]
								,F.[ATTRIBUTE6]
								,F.[ATTRIBUTE7]
								,F.[ATTRIBUTE8]
								,F.[ATTRIBUTE9]
								,F.[ATTRIBUTE10]
						FROM	[dbo].[DM_PLN_MKT_FCST] F  WITH  (NOLOCK)
						INNER JOIN 	SCM_MST_SITE_ITEM	T2  WITH(NOLOCK)  --20230410 JHS [E20230403-000148]
						   ON	F.DIVISION_ID	= T2.DIVISION_ID
						  AND	F.PROJECT_CODE	= T2.PROJECT_CODE
						  AND	F.SCM_SITE_ID	= T2.SCM_SITE_ID
						  AND	F.ITEM_ID		= T2.ITEM_ID
						  AND	T2.VALID_YN = 'Y'
						WHERE	F.[DIVISION_ID]  = @v_division_id
							AND F.[YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
							AND F.[MEASURE] NOT IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')

						UNION ALL
						SELECT F.[DIVISION_ID]
								 , F.[PROJECT_CODE]
								 , F.[SCM_SITE_ID]
								 , F.[ITEM_ID]
								 , F.[DOM_EXP]
								 , F.[FCST_TYPE]
								 , F.[INCOTERMS]
								 , F.[MEASURE]
								 , F.[PLANT_SITE_ID]
								 , F.[YYYYMMDD]
								 , F.[QTY]
								 , F.[CREATED_BY]
								 , F.[CREATION_DATE]
								 , F.[LAST_UPDATED_BY]
								 , F.[LAST_UPDATE_DATE]
								 , F.[ATTRIBUTE1]
								 , F.[ATTRIBUTE2]
								 , F.[ATTRIBUTE3]
								 , F.[ATTRIBUTE4]
								 , F.[ATTRIBUTE5]
								 , F.[ATTRIBUTE6]
								 , F.[ATTRIBUTE7]
								 , F.[ATTRIBUTE8]
								 , F.[ATTRIBUTE9]
								 , F.[ATTRIBUTE10]
						FROM [dbo].[DM_PLN_MKT_FCST] F WITH(NOLOCK)  
						INNER JOIN SCM_MST_SITE_ITEM T2 WITH(NOLOCK)  --20230410 JHS [E20230403-000148]
						ON F.DIVISION_ID = T2.DIVISION_ID
							AND F.PROJECT_CODE	= T2.PROJECT_CODE
							AND F.SCM_SITE_ID	= T2.SCM_SITE_ID
							AND F.ITEM_ID		= T2.ITEM_ID
							AND T2.VALID_YN	= 'Y'
						WHERE F.[DIVISION_ID] = @v_division_id
							AND F.[YYYYMMDD]	 >=  CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 최근 1년치
							AND F.[MEASURE] IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
				) A		
			END

		select '3'

			BEGIN
				INSERT [dbo].[DM_PLN_MKT_FCST_RESULT_C]
				(
						[DIVISION_ID]
					,[VERSION_NO]
					,[CUTOFF_TYPE]
					,[CUTOFF_YYYYMMDD]
					,[PROJECT_CODE]
					,[SCM_SITE_ID]
					,[ITEM_ID]
					,[DOM_EXP]
					,[FCST_TYPE]
					,[INCOTERMS]
					,[MEASURE]
					,[PLANT_SITE_ID]
					,[YYYYMMDD]
					,[QTY]
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE]
					,[ATTRIBUTE1]
					,[ATTRIBUTE2]
					,[ATTRIBUTE3]
					,[ATTRIBUTE4]
					,[ATTRIBUTE5]
					,[ATTRIBUTE6]
					,[ATTRIBUTE7]
					,[ATTRIBUTE8]
					,[ATTRIBUTE9]
					,[ATTRIBUTE10]						
				)
				SELECT 
					@v_division_id AS [DIVISION_ID], 
					@v_ver_return_no AS [VERSION_NO],
					@v_ver_type AS [CUTOFF_TYPE],
					CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS [CUTOFF_YYYYMMDD],
					A.[PROJECT_CODE] AS [PROJECT_CODE],
					A.[SCM_SITE_ID] AS [SCM_SITE_ID],
					A.[ITEM_ID] AS [ITEM_ID],
					A.[DOM_EXP] AS [DOM_EXP],		
					A.[FCST_TYPE] AS [FCST_TYPE],
					A.[INCOTERMS] AS [INCOTERMS],
					A.[MEASURE] AS [MEASURE],
					A.[PLANT_SITE_ID] AS [PLANT_SITE_ID],
					A.[YYYYMMDD] AS [YYYYMMDD],
					A.[QTY] AS [QTY],
					A.[CREATED_BY] AS [CREATED_BY],
					A.[CREATION_DATE] AS [CREATION_DATE],
					A.[LAST_UPDATED_BY] AS [LAST_UPDATED_BY],
					A.[LAST_UPDATE_DATE] AS [LAST_UPDATE_DATE],
					A.[ATTRIBUTE1] AS [ATTRIBUTE1],
					A.[ATTRIBUTE2] AS [ATTRIBUTE2],
					A.[ATTRIBUTE3] AS [ATTRIBUTE3],
					A.[ATTRIBUTE4] AS [ATTRIBUTE4],
					A.[ATTRIBUTE5] AS [ATTRIBUTE5],
					A.[ATTRIBUTE6] AS [ATTRIBUTE6],
					A.[ATTRIBUTE7] AS [ATTRIBUTE7],
					A.[ATTRIBUTE8] AS [ATTRIBUTE8],
					A.[ATTRIBUTE9] AS [ATTRIBUTE9],
					A.[ATTRIBUTE10]	AS [ATTRIBUTE10]					
				FROM
				(
						SELECT [DIVISION_ID]
								,[PROJECT_CODE]
								,[SCM_SITE_ID]
								,[ITEM_ID]
								,[DOM_EXP]
								,[FCST_TYPE]
								,[INCOTERMS]
								,[MEASURE]
								,[PLANT_SITE_ID]
								,[YYYYMMDD]
								,[QTY]
								,[CREATED_BY]
								,[CREATION_DATE]
								,[LAST_UPDATED_BY]
								,[LAST_UPDATE_DATE]
								,[ATTRIBUTE1]
								,[ATTRIBUTE2]
								,[ATTRIBUTE3]
								,[ATTRIBUTE4]
								,[ATTRIBUTE5]
								,[ATTRIBUTE6]
								,[ATTRIBUTE7]
								,[ATTRIBUTE8]
								,[ATTRIBUTE9]
								,[ATTRIBUTE10]
						FROM	[dbo].[DM_PLN_MKT_FCST_RESULT]  WITH  (NOLOCK)  
						WHERE	[DIVISION_ID]  = @v_division_id
						  AND   [YYYYMMDD]	<   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)			-- [2018-03-28][추가][금주 월요일 이전]
						  AND   [YYYYMMDD]	>=  CONVERT(CHAR(8), DATEADD(DD, -7*54, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 최근 1년치
				) A		
			END	
						
		END;
						
		--------------------------------------------------------------------------- 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
		--EXEC [dbo].PR_DM_TO_XIF_DM_PLN_MKT_FCST_C @p_division_id, @v_ver_return_no
		---------------------------------------------------------------------------

		COMMIT TRAN ;	
 
	END TRY

	/*
		-----------------------------------------------------------------------------------------
		300
			: ERROR TRAP
		-----------------------------------------------------------------------------------------
	*/
    BEGIN CATCH
	    select 'error1'

			ROLLBACK TRAN  ;	

			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date = SYSDATETIME();

		select 'error2'

			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']_O' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		select 'error3'

			SELECT @@TRANCOUNT AS trancnt2;SELECT @@error ;

		select 'error4'

			IF @v_OK_description <> 'OK'
			SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));

		select XACT_STATE()	as 'XACT_STATE';
  
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH

	SET NOCOUNT OFF;

	/*
		-----------------------------------------------------------------------------------------
		400
			: SUB PROCEDURE CALL
		-----------------------------------------------------------------------------------------
	*/


	if  @p_ver_type <> 'MF_M'   -- ui에서 수행한 수동 CutOff 인경우는 별도 다른 Procedure 를 호출하지 않음
	  BEGIN
		-- 수행결과 성공여부 DISPLAY
		-- Weekly Rolling 시에 [dbo].[DM_PLN_MKT_FCST] 에 당주 이후  MKT_FCST_LATEST 값을 다 Delete 하고 
		-- MKT_FCST 값을 그대로 select 해다가 Measure 값 MKT_FCST_LATEST로 Insert 하는 Procedure
		--EXEC	[dbo].[PR_DM_PLN_MKT_FCST_LASTEST_MEASURE]			
		--			@v_division_id

		-- RTF 값에 Sales Price가 곱해져서 KRW, LOC, USD Measure를 정상적으로 생성하는 프로시저
		EXEC	[dbo].[PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW]	
					@v_division_id
					, ''

		/*  20180726 KHSONG 주석처리 PR_DM_PLN_SALES_PLAN_CUTOFF 내에서 호출되도록 변경함
		-- [2018-02-12][추가][Sales Price의 SCM_MST_FUTURE_PRICE_C 테이블 INSERT]
		EXEC	[dbo].[PR_SCM_MST_FUTURE_PRICE_CUTOFF]	
					@v_division_id
		*/

		-- [2018-02-12][추가][Sales Price의 SCM_MST_FUTURE_PRICE_C 테이블 INSERT]
		IF @v_ver_type = 'MF_W'
			BEGIN

	        	EXEC	[dbo].[PR_DM_PLN_MKT_FCST_LASTEST_MEASURE]			
					       @v_division_id

		        -- [2018-03-29][SONGKEEHO추가][DM_PLN_MKT_FCST_C 데이터로 -> DM_PLN_NET_DEMAND 데이터 생성]
		        EXEC	[dbo].[PR_DM_PLN_MKT_FCST_TO_NET_DEMAND]	
				     	@v_division_id

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
				--EXEC	[dbo].[DMS_RCCP_CONV_AUTO] --20180806 KHSONG 주석처리

				-- [2018-04-20][추가][KPI PROCEDURE]
				EXEC [dbo].[PR_DM_PLN_MKT_FCST_KPI]		21, @v_division_id

				EXEC [dbo].[PR_DM_PLN_MKT_FCST_KPI_CFCR]	@v_division_id

				-- [2018-04-27][추가][PEGGING PROCEDURE]
				EXEC [dbo].[PR_DM_PLN_DEMANDID_PEGGING]		@v_division_id

			END
		ELSE
			BEGIN
				EXEC	[dbo].[PR_DM_PLN_SALES_PLAN_CUTOFF]
							@v_division_id
						   ,'DM_PLN_SALES_PLAN DAILY CUTOFF' -- @v_ver_description  -- DAILY 배치작업과 수동작업을 구분함
						   ,'SP_D'  --@p_ver_type
						   ,@p_created_by

				-- 20180706 KHSONG BALANCE MAKE PROCEDURE 호출추가
					BEGIN
						EXEC PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_ESS
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


	  END
   
	/*
		-----------------------------------------------------------------------------------------
		500
			: END LOG
		-----------------------------------------------------------------------------------------
	*/

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'Div: '+@p_division_id;
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	-- 트랜잭션 (END)

	------------------------------------------------------------------------------------
	-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (BEGIN)
	------------------------------------------------------------------------------------
	ERR_RTN:
	IF @v_log_type = 'INVALID'
		BEGIN
			ROLLBACK TRAN

			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	------------------------------------------------------------------------------------
	-- 20190610 KHSONG [CSR ID:4011692] DM 주간 Cut off 수행 기능 추가 (END)
	------------------------------------------------------------------------------------
  END;  
