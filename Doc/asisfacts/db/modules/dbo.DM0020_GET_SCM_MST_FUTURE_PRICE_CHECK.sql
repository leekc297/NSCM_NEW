/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DM0020_GET_SCM_MST_FUTURE_PRICE_CHECK]    
    @p_division_id              NVARCHAR(30),
	@p_scm_site_id              NVARCHAR(30),
	@p_plant_site_id              NVARCHAR(30),
    @p_project_code             NVARCHAR(50),
	@p_item_id                  NVARCHAR(50),	
	@p_currency                  NVARCHAR(MAX),
	@p_measure                  NVARCHAR(MAX),
	@p_dom_exp                  NVARCHAR(MAX),
	@p_fcst_type                 NVARCHAR(MAX),
	@p_incoterms                  NVARCHAR(MAX),
	@p_from_yyyymmdd            NVARCHAR(8),
	@p_to_yyyymmdd             NVARCHAR(8),
	@p_created_by              NVARCHAR(MAX)
 
AS  
  -- DM0020_GET_SCM_MST_FUTURE_PRICE '', '', '', '', '', ''
BEGIN
  SET NOCOUNT ON;
  -- DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ;;;YYYYMMDD, 
SELECT *
FROM SCM_MST_FUTURE_PRICE AS A WITH(NOLOCK)
WHERE (YYYYMMDD >= @p_from_yyyymmdd and YYYYMMDD <= @p_to_yyyymmdd)
		AND DIVISION_ID = @p_division_id
		AND SCM_SITE_ID = @p_scm_site_id
		AND PLANT_SITE_ID = @p_plant_site_id
		AND PROJECT_CODE = @p_project_code
		AND ITEM_ID = @p_item_id
		AND CURRENCY = @p_currency
		AND MEASURE = @p_measure
		AND DOM_EXP = @p_dom_exp
		AND FCST_TYPE = @p_fcst_type
		AND INCOTERMS = @p_incoterms

END

