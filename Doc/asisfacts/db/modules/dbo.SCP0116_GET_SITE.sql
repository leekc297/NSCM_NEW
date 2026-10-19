/****************************************************************************************************
* Program ID  : UP_FX_GetCommonDataList) FromSiteByDivision  ->   SCP0116_GET_SITE                                           
* Description : SCP 칼렌더 생성위한 프로시저                                                                                                              
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2024/11/20  Haru			Clone from SCP0100
* ex)
* EXEC SCP0116_GET_SITE @p_site_tpye='FROM_SITE', @p_division_id='81', @p_bucket='MONTHLY'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0116_GET_SITE]
	@p_site_tpye NVARCHAR(MAX)  = 'FROM_SITE'
   ,@p_division_id NVARCHAR(MAX) = '81'
   ,@p_bucket NVARCHAR(MAX) = 'MONTHLY'
AS
BEGIN
	SET NOCOUNT ON;

	IF @p_site_tpye =  'FROM_SITE'
	BEGIN


			IF @p_bucket =  'MONTHLY'
			BEGIN
				SELECT FROM_SITE AS CODE
					 , FROM_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_MM_ESS
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			  AND  DIVISION_ID LIKE  @p_division_id +'%'--'81%'---고도화
				GROUP BY FROM_SITE
				ORDER BY FROM_SITE
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT FROM_SITE AS CODE
					 , FROM_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_WW_ESS
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE  @p_division_id +'%'--'81%'---고도화
				GROUP BY FROM_SITE
				ORDER BY FROM_SITE
			END




	END

	ELSE IF @p_site_tpye =  'TO_SITE'
	BEGIN
			IF @p_bucket =  'MONTHLY'
			BEGIN
				SELECT TO_SITE AS CODE
					 , TO_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_MM_ESS
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE  @p_division_id +'%'--'81%'---고도화
				GROUP BY TO_SITE
				ORDER BY TO_SITE
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT TO_SITE AS CODE
					 , TO_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_WW_ESS
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE  @p_division_id +'%'--'81%'---고도화
				GROUP BY TO_SITE
				ORDER BY TO_SITE
			END
	END

END
