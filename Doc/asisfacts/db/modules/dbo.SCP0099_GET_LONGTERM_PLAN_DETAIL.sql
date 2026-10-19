
/*
 * Program ID   : [SCP0099_GET_LONGTERM_PLAN_DETAIL]
 * Description  : 중장기계획 세부조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023-07-12   KJJ				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기 계획 세부조회

 * ex)
    EXEC SCP0099_GET_LONGTERM_PLAN_DETAIL @p_division_id='81',@P_PLAN_ID='20230703_004', @P_OPERATION_GROUP='',@P_SITE='',@P_LINE='',@P_MODEL=''
 */
CREATE PROCEDURE [dbo].[SCP0099_GET_LONGTERM_PLAN_DETAIL]
 (
  	 @P_DIVISION_ID		NVARCHAR(MAX)  
	,@P_PLAN_ID  		NVARCHAR(MAX)
	,@P_OPERATION_GROUP	NVARCHAR(MAX)
	,@P_SITE			NVARCHAR(MAX)
	,@P_LINE			NVARCHAR(MAX)
	,@P_MODEL			NVARCHAR(MAX)  
 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

SELECT [DIVISION_ID]
      --,[PLAN_ID]
	,[OPERATION_GROUP]
	,[SITE_ID]
	,[BUILDING]
	,[LINE_ID]
	,[NICKNAME]
	,[MODEL]
	,[CUST]
	,[PROJECT]
	,[UNIT]
	,[MEASURE] 
      ,[M1_QTY]
      ,[M2_QTY]
      ,[M3_QTY]
      ,[M4_QTY]
      ,[M5_QTY]
      ,[M6_QTY]
      ,[M7_QTY]
      ,[M8_QTY]
      ,[M9_QTY]
      ,[M10_QTY]
      ,[M11_QTY]
      ,[M12_QTY]
      ,[M13_QTY]
      ,[M14_QTY]
      ,[M15_QTY]
      ,[M16_QTY]
      ,[M17_QTY]
      ,[M18_QTY]
      ,[M19_QTY]
      ,[M20_QTY]
      ,[M21_QTY]
      ,[M22_QTY]
      ,[M23_QTY]
      ,[M24_QTY]
      ,[M25_QTY]
      ,[M26_QTY]
      ,[M27_QTY]
      ,[M28_QTY]
      ,[M29_QTY]
      ,[M30_QTY]
      ,[M31_QTY]
      ,[M32_QTY]
      ,[M33_QTY]
      ,[M34_QTY]
      ,[M35_QTY]
      ,[M36_QTY]
      ,[M37_QTY]
      ,[M38_QTY]
      ,[M39_QTY]
      ,[M40_QTY]
      ,[M41_QTY]
      ,[M42_QTY]
      ,[M43_QTY]
      ,[M44_QTY]
      ,[M45_QTY]
      ,[M46_QTY]
      ,[M47_QTY]
      ,[M48_QTY]
      ,[M49_QTY]
      ,[M50_QTY]
      ,[M51_QTY]
      ,[M52_QTY]
      ,[M53_QTY]
      ,[M54_QTY]
      ,[M55_QTY]
      ,[M56_QTY]
      ,[M57_QTY]
      ,[M58_QTY]
      ,[M59_QTY]
      ,[M60_QTY]
      ,[KEYVALUE]
  FROM [dbo].[SCP_ANL_BUSINESS_PLAN_PROD] WITH(NOLOCK)
		WHERE DIVISION_ID = @P_DIVISION_ID
		AND PLAN_ID = @P_PLAN_ID
		--AND ( (@P_OPERATION_GROUP=NULL OR @P_OPERATION_GROUP='') OR OPERATION_GROUP LIKE '%' + @P_OPERATION_GROUP + '%')
		AND ( (@P_OPERATION_GROUP=NULL OR @P_OPERATION_GROUP='') OR OPERATION_GROUP = @P_OPERATION_GROUP)
		AND ( (@P_SITE=NULL OR @P_SITE='') OR SITE_ID LIKE '%' + @P_SITE + '%')
		--AND ( (@P_LINE=NULL OR @P_LINE='') OR LINE_ID IN (SELECT token FROM dbo.String_Split(@P_LINE,',')))
		AND ( (@P_LINE=NULL OR @P_LINE='') OR LINE_ID LIKE '%' + @P_LINE + '%')
		AND ( (@P_MODEL=NULL OR @P_MODEL='') OR MODEL LIKE '%' + @P_MODEL + '%')


	SELECT [DIVISION_ID]
		  --,[PLAN_ID]
		,[SALES_SITE]
		,[BIZ_TYPE]
		,[CUST]
		,[PROJECT]
		,[PROJECT_DESC]
		,[MODEL]
		,[MODEL_CODE]
		,[CELL_NICKNAME]
		,[CELL_CODE]
		,[ELECTRODE]
		,[CELL]
		,[PACK]
		,[UNIT]
		,[INCOTERMS]
		,[MEASURE]
		  ,[M1_QTY]
		  ,[M2_QTY]
		  ,[M3_QTY]
		  ,[M4_QTY]
		  ,[M5_QTY]
		  ,[M6_QTY]
		  ,[M7_QTY]
		  ,[M8_QTY]
		  ,[M9_QTY]
		  ,[M10_QTY]
		  ,[M11_QTY]
		  ,[M12_QTY]
		  ,[M13_QTY]
		  ,[M14_QTY]
		  ,[M15_QTY]
		  ,[M16_QTY]
		  ,[M17_QTY]
		  ,[M18_QTY]
		  ,[M19_QTY]
		  ,[M20_QTY]
		  ,[M21_QTY]
		  ,[M22_QTY]
		  ,[M23_QTY]
		  ,[M24_QTY]
		  ,[M25_QTY]
		  ,[M26_QTY]
		  ,[M27_QTY]
		  ,[M28_QTY]
		  ,[M29_QTY]
		  ,[M30_QTY]
		  ,[M31_QTY]
		  ,[M32_QTY]
		  ,[M33_QTY]
		  ,[M34_QTY]
		  ,[M35_QTY]
		  ,[M36_QTY]
		  ,[M37_QTY]
		  ,[M38_QTY]
		  ,[M39_QTY]
		  ,[M40_QTY]
		  ,[M41_QTY]
		  ,[M42_QTY]
		  ,[M43_QTY]
		  ,[M44_QTY]
		  ,[M45_QTY]
		  ,[M46_QTY]
		  ,[M47_QTY]
		  ,[M48_QTY]
		  ,[M49_QTY]
		  ,[M50_QTY]
		  ,[M51_QTY]
		  ,[M52_QTY]
		  ,[M53_QTY]
		  ,[M54_QTY]
		  ,[M55_QTY]
		  ,[M56_QTY]
		  ,[M57_QTY]
		  ,[M58_QTY]
		  ,[M59_QTY]
		  ,[M60_QTY]
		  ,[KEYVALUE]
	  FROM [dbo].[SCP_ANL_BUSINESS_PLAN_RTF] WITH(NOLOCK)
		WHERE DIVISION_ID = @P_DIVISION_ID
		AND PLAN_ID = @P_PLAN_ID
		--AND ( (@P_OPERATION_GROUP=NULL OR @P_OPERATION_GROUP='') OR BIZ_TYPE LIKE '%' + @P_OPERATION_GROUP + '%')
		AND ( (@P_OPERATION_GROUP=NULL OR @P_OPERATION_GROUP='') OR BIZ_TYPE = @P_OPERATION_GROUP)
		AND ( (@P_SITE=NULL OR @P_SITE='') OR CUST LIKE '%' + @P_SITE + '%')
		AND ( (@P_MODEL=NULL OR @P_MODEL='') OR MODEL_CODE LIKE '%' + @P_MODEL + '%')

END
