/****************************************************************************************************
* Program ID  : SCP0100_GET_PLAN_DATE) UP_FX_GetCommonDataList > DATE_WEEKLY 참고                                          
* Description : SCP Plan date                                                                                                             
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2023/11/22  vadabi3			Initial Release  
* 2023/11/29  vadabi3			Plan 있는 경우만 조회 
* 2024.08.21   cys     			고도화(JV 사업부 포함)
*--------------------------------------------------------------------------------------------------
* ex)
* EXEC SCP0100_GET_PLAN_DATE @p_division_id='81', @p_bucket = 'MONTHLY', @p_program_id='SCP0100'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0100_GET_PLAN_DATE]
    @p_division_id NVARCHAR(MAX) = '81'
   ,@p_bucket      NVARCHAR(MAX) = 'MONTHLY'
   ,@p_program_id  NVARCHAR(MAX) = 'SCP0100'
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TMP_PLAN') IS NOT NULL
	DROP TABLE #TMP_PLAN;


	IF @p_program_id =  'SCP0100'
	BEGIN
			--------------------------------------------------------------------------------------------------
			SELECT A.plan_start_yyyymmdd AS code
 	  			 , CASE WHEN FP_TARGET_YN = 'Y' 
						THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'
 	  		 			ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' 
						END name
			  INTO #TMP_PLAN
  			  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)
  		INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd
  			 LEFT JOIN 
  			 (
  		 		SELECT DIVISION_ID
		 			, PLAN_START_YYYYMMDD
		 			, FP_TARGET_YN
		 			, MRP_TARGET_YN
		 			, DM_RTF_YN	 
	  			 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
				WHERE 1=1
				  --AND PLAN_START_YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)
	   			  --AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	   
	   			  AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			  AND  DIVISION_ID LIKE '81%'------고도화
  			 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD
			 WHERE 1=1
			   AND (( @p_division_id IS NULL OR  @p_division_id='' ) OR A.division_id= @p_division_id)
			   AND  FP_TARGET_YN = 'Y'
			 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN

			--------------------------------------------------------------------------------------------------
			IF @p_bucket =  'MONTHLY'
			BEGIN
				SELECT CODE , NAME
				  FROM #TMP_PLAN
				 WHERE CODE IN (SELECT DISTINCT plan_start_yyyymmdd FROM SCP_RPT_GLOBAL_PSI_MD_MM)
			  ORDER BY CODE DESC
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT CODE , NAME
				  FROM #TMP_PLAN
				 WHERE CODE IN (SELECT DISTINCT plan_start_yyyymmdd FROM SCP_RPT_GLOBAL_PSI_MD_WW)
			  ORDER BY CODE DESC
			END
	END
END
