/*
 * Program ID   : SCP0069
 * Description  : Global PSI EE 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/10/14   LWY             PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - GlobalPSI_ESS (전극) 신규
 */


CREATE PROCEDURE [dbo].[SCP0069_LOOKUP_DATA]
(
     @p_division_id   NVARCHAR(010)
	,@p_user_id       NVARCHAR(150)  -- 'max.ts.lee'
 )  
AS
BEGIN
	
  SET NOCOUNT ON;

  DECLARE @p_plan_start_yyyymmdd  NVARCHAR(8) = ''

	-----------------------------------------
	-- #1. WORKING TIME & TACT TIME : 팝업창
	-----------------------------------------
	BEGIN
	SELECT TOP 1  @p_plan_start_yyyymmdd = PLAN_START_YYYYMMDD FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)

	SELECT    
			  A.DIVISION_ID
			, A.FROM_SITE_ID AS SUPPLY_SITE
			, A.ITEM_ID
			, A.LINE_ID
			, B.YYYYMMDD
			, A.MEASURE
			, A.WORKING_TIME
			, A.TACT_TIME
			, A.UPDATE_TIME
      FROM (
				SELECT DISTINCT
					  TM.DIVISION_ID
					--, TM.PLANT_ID AS FROM_SITE_ID
					, GE.FROM_SITE_ID
					, AN.ITEM_ID
					, TM.LINE_ID
					, TM.MONTH
					, ISNULL(TM.DAILY_CAPA, 0) / 30 AS WORKING_TIME
					, TM.TACT_TIME
					, AN.UPDATE_TIME
					, GE.MEASURE
				FROM  SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
					 ,SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
					 ,SCP_XLS_PSI_GLOBAL_ELECTRODE GE WITH (NOLOCK)
				WHERE AN.ITEM_ID = GE.ITEM_ID
		
				-- ★ TEST 위해 주석처리
				--AND AN.UPDATE_TIME >= dateadd(D, -7, getdate())
		
				-- ★ :: test id		
				AND AN.UPDATE_ID        = @p_user_id				

				AND AN.OPERATION_ID     = 'E2000'
				AND TM.DIVISION_ID		= AN.DIVISION_ID
				AND TM.COMPANY_ID		= AN.COMPANY_ID
				AND TM.SITE_ID			= AN.SITE_ID
				AND TM.PLANT_ID			= AN.PLANT_ID
				AND TM.FACTORY_ID		= AN.FACTORY_ID
				AND TM.OPERATION_ID		= AN.OPERATION_ID
				AND TM.LINE_ID			= AN.LINE_ID
				AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
				AND TM.ITEM_ID			= AN.ITEM_ID
				AND GE.MEASURE = 'PROD_PLAN_AMEND'
		) A
		INNER JOIN
			(SELECT C.BASIS_YYYYMMDD AS YYYYMMDD, C.BASIS_YYYYMM AS YYYYMM
				FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
				WHERE 1=1  
				AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
				AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)
				--AND C.BASIS_YYYYMMDD >= '20211001'
				--AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,'20211001',112)),112)
				AND C.DAYOFWEEK = 'MON'
			) B
			ON A.MONTH = B.YYYYMM 
		ORDER BY A.FROM_SITE_ID, A.LINE_ID, A.ITEM_ID, B.YYYYMMDD
;

	END;

  RETURN;

END
