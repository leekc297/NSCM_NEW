

/*
 * Program ID   : PR_DM_PLN_MKT_FCST_RESULT_MOVE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date          In Charge          Description
 *===================================================================================================
 * 2018. 03. 29    JHBAEK             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *                                    [DM_PLN_MKT_FCST] -> [DM_PLN_MKT_FCST_RESULT] 테이블에 자료(과거 1주일) INSERT PROCEDURE
 *									  WEEKLY RUNNNG.
 * 20180611 KHSONG		<> 'RTF' -> not in ('RTF','BALANCE') 로 수정 / DATEADD(DD, -7 -> DATEADD(DD, -14 로 수정
 * 20180917 KHSONG		테스트용 MEASURE 제외조건 추가
 * 20190709 KHSONG		[CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건
 * 20200416 KHSONG		C20200413-000593 ESS사업부 RTF Measure 추가
 * 20220405 hwi1993     GM JV 작업
 * 20250623 KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 20250729 KANG.H.J	[PJ2025-50188] RTF_SYS_RP 미생성 - PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING에서 생성하기 때문에 불필요

 * 
 * 
 * 
 * 
 */

 /* TO TEST
	SELECT * FROM DM_PLN_MKT_FCST
	SELECT * FROM DM_PLN_MKT_FCST_RESULT

 */

 CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_RESULT_MOVE]
	@p_division_id         NVARCHAR(30)  -- division_id 전달받음
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

    DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_RESULT_MOVE';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
	DECLARE @v_division_id		NVARCHAR(30);

	SET @v_division_id		 = NULL;	

	/*
		-----------------------------------------------------------------------------------------
			: START LOG
		-----------------------------------------------------------------------------------------
	*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL');
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET	@v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함)
	IF OBJECT_ID (N'tempdb..#T_RESULT_MOVE_MKT_FCST', N'U') IS NOT NULL 
		DROP TABLE #T_RESULT_MOVE_MKT_FCST


	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함)
	CREATE TABLE #T_RESULT_MOVE_MKT_FCST (
				 DIVISION_ID        nvarchar(30)   
				,PROJECT_CODE       nvarchar(50)   
				,SCM_SITE_ID        nvarchar(30)   
				,ITEM_ID            nvarchar(50)   
				,DOM_EXP            nvarchar(3)    
				,FCST_TYPE          nvarchar(20)   
				,INCOTERMS          nvarchar(10)   
				,PLANT_SITE_ID      nvarchar(30)   
				,CELL_PROD_SITE_ID  nvarchar(30)				
				,MEASURE        	nvarchar(50)				
				,YYYYMMDD           nvarchar(8)    
				,QTY                numeric(20, 10)
				,CREATED_BY			nvarchar(150)	
				,CREATION_DATE		datetime
				,LAST_UPDATED_BY	nvarchar(150)	
				,LAST_UPDATE_DATE	datetime
				,ATTRIBUTE1			nvarchar(150)	
				,ATTRIBUTE2			nvarchar(150)	
				,ATTRIBUTE3			nvarchar(150)	
				,ATTRIBUTE4			nvarchar(150)	
				,ATTRIBUTE5			nvarchar(150)	
				,ATTRIBUTE6			nvarchar(150)	
				,ATTRIBUTE7			nvarchar(150)	
				,ATTRIBUTE8			nvarchar(150)	
				,ATTRIBUTE9			nvarchar(150)	
				,ATTRIBUTE10		nvarchar(150)	
	)
	;

	BEGIN TRAN

	BEGIN TRY
		IF @p_division_id = 'ALL' 
			SET @v_division_id = ''
		ELSE
			SET @v_division_id = @p_division_id


		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함) START
		IF @p_division_id = '40' 
		BEGIN
			INSERT INTO #T_RESULT_MOVE_MKT_FCST
			(	  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
				, CELL_PROD_SITE_ID
				, MEASURE, YYYYMMDD, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			)
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
				, CELL_PROD_SITE_ID
				, MEASURE, YYYYMMDD, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM DM_PLN_CFM_MKT_DEMAND_PLAN WITH(NOLOCK)
			WHERE	DIVISION_ID = @v_division_id 
			AND		YYYYMMDD	<   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND		YYYYMMDD	>=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND     MEASURE NOT IN ('MKT_AMT_LOC', 'SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'MKT_AMT_KRW')	-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_MKT_FCST 에는 없는 MEASURE임. 참고적으로 MKT_AMT_KRW 추가시 QTY 칼럼의 자리수 에러 발생)
		;
		END
		ELSE
		BEGIN
			INSERT INTO #T_RESULT_MOVE_MKT_FCST
			(	  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
				, CELL_PROD_SITE_ID
				, MEASURE, YYYYMMDD, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			)
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
				, '-'						AS CELL_PROD_SITE_ID
				, MEASURE, YYYYMMDD, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
				, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM DM_PLN_MKT_FCST WITH(NOLOCK)
			WHERE	DIVISION_ID = @v_division_id 
			AND		YYYYMMDD	<   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND		YYYYMMDD	>=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		;
		END
		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (임시테이블 생성. 40사업부와 그외 사업부 구분을 위함) END

				
		DELETE FROM [dbo].[DM_PLN_MKT_FCST]
		WHERE		[DIVISION_ID] = @v_division_id 
				AND [YYYYMMDD]	 >=  CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 20180611 KHSONG DATEADD(DD, -7 -> DATEADD(DD, -14 로 수정
				AND [QTY] = 0
		;

		DELETE FROM [dbo].[DM_PLN_CFM_MKT_DEMAND_PLAN]
		WHERE		[DIVISION_ID] = @v_division_id 
				AND [YYYYMMDD]	 >=  CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 20180611 KHSONG DATEADD(DD, -7 -> DATEADD(DD, -14 로 수정
				AND [QTY] = 0
		;

		DELETE FROM [dbo].[DM_PLN_MKT_FCST_RESULT]
		WHERE		[DIVISION_ID] = @v_division_id 
			--AND [MEASURE]   IN ( 'MKT_FCST', 'CUST_FCST', 'MKT_FCST_LATEST', 'CUST_FCST_LATEST' )			-- [2018-03-28][수정]
			AND [YYYYMMDD]          <   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND [YYYYMMDD]          >=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			-- [PJ2025-50188] RTF_SYS_RP 미생성 - PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING에서 생성하기 때문에 불필요 START
			--AND [MEASURE]           not in ('RTF','BALANCE','VMI_In_Plan','VMI_In_Req','VMI_Inv')	-- 20180611 KHSONG <> 'RTF' -> not in ('RTF','BALANCE') 로 수정
			AND [MEASURE]           not in ('RTF','BALANCE','VMI_In_Plan','VMI_In_Req','VMI_Inv', 'RTF_SYS_RP')	
			-- [PJ2025-50188] RTF_SYS_RP 미생성 - PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING에서 생성하기 때문에 불필요 END
		;

		INSERT INTO [dbo].[DM_PLN_MKT_FCST_RESULT]
			(
				[DIVISION_ID]
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
				,CELL_PROD_SITE_ID						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			)
		SELECT   A.[DIVISION_ID]
                ,A.[PROJECT_CODE]
                ,A.[SCM_SITE_ID]
                ,A.[ITEM_ID]
                ,A.[DOM_EXP]
                ,A.[FCST_TYPE]
                ,A.[INCOTERMS]
				,A.MEASURE
                ,A.[PLANT_SITE_ID]
                ,A.[YYYYMMDD]
                ,A.[QTY]
                ,A.[CREATED_BY]
                ,A.[CREATION_DATE]
                ,A.[LAST_UPDATED_BY]
                ,getdate()  --A.[LAST_UPDATE_DATE]
                ,A.[ATTRIBUTE1]
                ,A.[ATTRIBUTE2]
                ,A.[ATTRIBUTE3]
                ,A.[ATTRIBUTE4]
                ,A.[ATTRIBUTE5]
                ,A.[ATTRIBUTE6]
                ,A.[ATTRIBUTE7]
                ,A.[ATTRIBUTE8]
                ,A.[ATTRIBUTE9]
                ,A.[ATTRIBUTE10]
				,A.CELL_PROD_SITE_ID						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			--FROM [dbo].[DM_PLN_MKT_FCST] A WITH(NOLOCK) 
			FROM #T_RESULT_MOVE_MKT_FCST A WITH(NOLOCK)		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (40:DM_PLN_CFM_MKT_DEMAND_PLAN / 그외 : DM_PLN_MKT_FCST)
			INNER JOIN SCM_MST_DIVISION B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND B.DIVISION_ID = @v_division_id 
           WHERE 1 = 1
			 AND [YYYYMMDD]         <   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			 AND [YYYYMMDD]         >=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			 --AND [MEASURE]   IN ( 'MKT_FCST', 'CUST_FCST', 'MKT_FCST_LATEST', 'CUST_FCST_LATEST' )
			 AND [MEASURE]          not in ('RTF_SYS_RP','RTF','BALANCE','VMI_In_Plan','VMI_In_Req','VMI_Inv')	-- 20180611 KHSONG <> 'RTF' -> not in ('RTF','BALANCE') 로 수정 --20190729 KHSONG RTF_SYS_RP MEASURE 추가

/*		-- [PJ2025-50188] RTF_SYS_RP 미생성 - PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING에서 생성하기 때문에 불필요
		-- 20190709 KHSONG [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건 (BEGIN)
		INSERT INTO [dbo].[DM_PLN_MKT_FCST_RESULT]
			(
				[DIVISION_ID]
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
				,CELL_PROD_SITE_ID						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			)
		SELECT   A.[DIVISION_ID]
                ,A.[PROJECT_CODE]
                ,A.[SCM_SITE_ID]
                ,A.[ITEM_ID]
                ,A.[DOM_EXP]
                ,A.[FCST_TYPE]
                ,A.[INCOTERMS]
				,'RTF_SYS_RP' AS MEASURE
                ,A.[PLANT_SITE_ID]
                ,A.[YYYYMMDD]
                ,A.[QTY]
                ,A.[CREATED_BY]
                ,A.[CREATION_DATE]
                ,A.[LAST_UPDATED_BY]
                ,getdate()  --A.[LAST_UPDATE_DATE]
                ,A.[ATTRIBUTE1]
                ,A.[ATTRIBUTE2]
                ,A.[ATTRIBUTE3]
                ,A.[ATTRIBUTE4]
                ,A.[ATTRIBUTE5]
                ,A.[ATTRIBUTE6]
                ,A.[ATTRIBUTE7]
                ,A.[ATTRIBUTE8]
                ,A.[ATTRIBUTE9]
                ,A.[ATTRIBUTE10]
				,A.CELL_PROD_SITE_ID					-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			FROM [dbo].[DM_PLN_MKT_FCST_RESULT] A WITH(NOLOCK) 
			INNER JOIN SCM_MST_DIVISION B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND B.DIVISION_ID = @v_division_id 
           WHERE 1 = 1
			 AND [YYYYMMDD]         <   CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			 AND [YYYYMMDD]         >=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			 AND [MEASURE]          = 'RTF'
			 --AND A.DIVISION_ID IN ('40','81')  -- 20200416 KHSONG C20200413-000593 주석처리 ESS사업부 추가되면서 구분이 필요없이 코드 간소화됨

		-- 20190709 KHSONG [CSR ID:4027463] RTF_System[R+P] Measure 추가 요청의 건 (END)
*/

		COMMIT TRAN ;	

		-- [PJ2025-50188] 임시테이블 #T_SCP_PLN_RTF_ALLOCATION_V ==> #T_MF_RTF_ALLOCATION 이름변경
		IF OBJECT_ID (N'tempdb..#T_RESULT_MOVE_MKT_FCST', N'U') IS NOT NULL 
			DROP TABLE #T_RESULT_MOVE_MKT_FCST


	END TRY

	/*
		-----------------------------------------------------------------------------------------
			: ERROR TRAP
		-----------------------------------------------------------------------------------------
	*/
    BEGIN CATCH
		ROLLBACK TRAN ;

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

	SET NOCOUNT OFF;

	/*
		-----------------------------------------------------------------------------------------
			: END LOG
		-----------------------------------------------------------------------------------------
	*/

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '@p_division_id : ' + ISNULL(@p_division_id,'NULL');
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
