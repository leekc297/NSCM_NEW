/****************************************************************************************************
* Program ID  : UP_FX_GetCommonDataList) FromSiteByDivision  ->   SCP0100_GET_SITE                                           
* Description : SCP 칼렌더 생성위한 프로시저                                                                                                              
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2023/10/17  vadabi3			Initial Release  
* 2024.08.21   cys     			고도화(JV 사업부 포함)
* ex)
* EXEC SCP0100_GET_SITE @p_site_tpye='FROM_SITE', @p_division_id='81', @p_bucket='MONTHLY'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0100_GET_SITE]
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
				FROM SCP_RPT_GLOBAL_PSI_MD_MM
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			  AND  DIVISION_ID LIKE '81%'---고도화
				GROUP BY FROM_SITE
				ORDER BY FROM_SITE
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT FROM_SITE AS CODE
					 , FROM_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_WW
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE '81%'---고도화
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
				FROM SCP_RPT_GLOBAL_PSI_MD_MM
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE '81%'---고도화
				GROUP BY TO_SITE
				ORDER BY TO_SITE
			END
			ELSE IF @p_bucket =  'WEEKLY'
			BEGIN
				SELECT TO_SITE AS CODE
					 , TO_SITE AS NAME
				FROM SCP_RPT_GLOBAL_PSI_MD_WW
				WHERE 1=1
				AND (
	   			  		(@p_division_id IS NULL OR  @p_division_id='' ) 
	   			  		OR DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))	
	   			  	   )---고도화
	   			AND  DIVISION_ID LIKE '81%'---고도화
				GROUP BY TO_SITE
				ORDER BY TO_SITE
			END
	END

END
