


/*===================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_RESULT_MOVE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date		In Charge          Description
 *===================================================================================================
 * 2018.03.29	JHBAEK             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *                                  [DM_PLN_MKT_FCST] -> [DM_PLN_MKT_FCST_RESULT] 테이블에 자료(과거 1주일) INSERT PROCEDURE
 *									WEEKLY RUNNNG.
 * 2019.07.12	KHSONG				[CSR ID:4023158] 'RTF_SYS_RP' MEASURE 추가
 * 2020.02.13	HWI1993				COMPANY_ID 추가 안되서 오류발생
 * 2020.03.09	KHSONG				TMM_FCST ADD
 * 2022.04.07	hwi1993				GM JV 작업
 * 2025.04.22	JSSBAE				[E20250401-000548]_선감지(SMS) 대상 기준 정리
 * 2025.06.23	KANG.H.J			[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.28	KANG.H.J			[PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성
 * =================================================================================================*/

 /* TO TEST
	SELECT * FROM DM_PLN_MKT_FCST
	SELECT * FROM DM_PLN_MKT_FCST_RESULT

 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_SALES_PLAN_RESULT_MOVE]
	@p_division_id         NVARCHAR(30)  -- division_id 전달받음
AS

BEGIN
	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	/*-----------------------------------------------------------------------------------------
		000: VARIABLE DECLARATION
	------------------------------------------------------------------------------------------*/

    DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_PLN_SALES_PLAN_RESULT_MOVE';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
	DECLARE @v_division_id		NVARCHAR(MAX);

	SET @v_division_id		 = NULL;	
	
	/*-----------------------------------------------------------------------------------------
		001: START LOG
	------------------------------------------------------------------------------------------*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET	@v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN

	BEGIN TRY

		IF @p_division_id = 'ALL' 
			SET @v_division_id = ''
		ELSE
			SET @v_division_id = @p_division_id
				
		/* RESULT DATA DELETE */
		DELETE FROM [dbo].DM_PLN_SALES_PLAN_RESULT
		WHERE	[DIVISION_ID] LIKE '%' + @v_division_id + '%'
			AND [YYYYMMDD]  <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND [YYYYMMDD]  >=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START - RTF_SYS_RP와 RTF 는 RESULT_MAPPING에서 생성되므로 제외함.
			--AND MEASURE     in ('MKT_FCST','CUST_FCST','RTF_SYS_RP','TMM_FCST')  --20180417 modify skh  -- 20190712 KHSONG [CSR ID:4023158] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD
			AND [MEASURE]     not in ('RTF_SYS_RP','RTF','BALANCE','VMI_In_Plan','VMI_In_Req','VMI_Inv','MKT_AMT_LOC', 'SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'MKT_AMT_KRW')	
			-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 END
		;

		/* RESULT DATA INSERT */
		INSERT INTO [dbo].DM_PLN_SALES_PLAN_RESULT
		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
		, PLANT_SITE_ID, YYYYMMDD
		, CURRENCY
		, QTY
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3 
		, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
		, COMPANY_ID
		, CELL_PROD_SITE_ID				--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		)
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
			 , A.PLANT_SITE_ID, A.YYYYMMDD
			 , ISNULL(A.CURRENCY,'') AS CURRENCY -- 20180319 skh modify
			 , SUM(A.QTY) AS QTY --[E20250401-000548]_SALES_PLAN테이블에 CELL_PROD_SITE가 추가되었으나 RESULT에 없으니 SUM 
			 , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, getdate(), A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
			 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
			 ,'' AS COMPANY_ID  --20200213
			 , A.CELL_PROD_SITE_ID		--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
			FROM [dbo].[DM_PLN_SALES_PLAN] A WITH(NOLOCK) INNER JOIN SCM_MST_DIVISION B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID
																AND B.DIVISION_ID LIKE '%' + @v_division_id + '%'
			WHERE 1 =1 
			AND [YYYYMMDD]  <  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND [YYYYMMDD]  >=  CONVERT(CHAR(8), DATEADD(DD, -7*2, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
			-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 START - RTF_SYS_RP와 RTF 는 RESULT_MAPPING에서 생성되므로 제외함.
			--AND MEASURE     in ('MKT_FCST','CUST_FCST','RTF_SYS_RP','TMM_FCST')  --20180417 modify skh  -- 20190712 KHSONG [CSR ID:4023158] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD
			--AND MEASURE     in ('MKT_FCST','CUST_FCST','RTF_SYS_RP','TMM_FCST','RTF_SCP')  --20180417 modify skh  -- 20190712 KHSONG [CSR ID:4023158] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD
			AND [MEASURE]     not in ('RTF_SYS_RP','RTF','BALANCE','VMI_In_Plan','VMI_In_Req','VMI_Inv','MKT_AMT_LOC', 'SalesAmt_KRW', 'SalesAmt_LOC', 'SalesAmt_USD', 'MKT_AMT_KRW')	
			-- [PJ2025-50188] SALES_PLAN(CURRENT)의 RTF_SCP 생성 END
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, ISNULL(A.CURRENCY,'')
			   , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7
			   , A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
			   , A.CELL_PROD_SITE_ID	--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가

		COMMIT TRAN ;	
	END TRY
	
	/*-----------------------------------------------------------------------------------------
		002: ERROR TRAP
	------------------------------------------------------------------------------------------*/
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
	
	/*-----------------------------------------------------------------------------------------
		003: END LOG
	------------------------------------------------------------------------------------------*/

    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

