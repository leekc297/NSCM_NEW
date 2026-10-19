
/*
 * Program ID   : FN_GET_JV_REAL_ESS_VIRTUAL_PLANT_MAP                                                              
 * Description  : JV Real Plant와 ESS virtual Plant 매핑 정보 반환 함수
 *				  JV Real Plant : ESS Virtual Plant = 1 : 1 
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2025.11.04	hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *
 */

CREATE FUNCTION [dbo].[FN_GET_JV_REAL_ESS_VIRTUAL_PLANT_MAP] (   
)   
RETURNS @RETURN_TABLE TABLE
(
	  VP_COMPANY_ID			NVARCHAR(30)	NOT NULL
	, VP_DIVISION_ID		NVARCHAR(30)	NOT NULL
	, VP_SITE_ID			NVARCHAR(30)	NOT NULL
	, VP_PLANT_ID			NVARCHAR(30)	NOT NULL
	, RP_COMPANY_ID			NVARCHAR(30)	NOT NULL
	, RP_DIVISION_ID		NVARCHAR(30)	NOT NULL
	, RP_SITE_ID			NVARCHAR(30)	NOT NULL
	, RP_PLANT_ID			NVARCHAR(30)	NOT NULL
)

BEGIN

		------------------------------------------------------------------------------------------------------------------------------------------------
		--PRINT convert(varchar(30), getdate(), 121) +  N' ### JV Real Plant와 ESS virtual Plant 매핑 정보 반환 : @RETURN_TABLE' 
		------------------------------------------------------------------------------------------------------------------------------------------------
		insert into @RETURN_TABLE (
			  VP_COMPANY_ID
			, VP_DIVISION_ID
			, VP_SITE_ID
			, VP_PLANT_ID
			, RP_COMPANY_ID
			, RP_DIVISION_ID
			, RP_SITE_ID
			, RP_PLANT_ID
		)
		SELECT 
			  VP_COMPANY_ID
			, VP_DIVISION_ID
			, VP_SITE_ID
			, VP_PLANT_ID
			, RP_COMPANY_ID
			, RP_DIVISION_ID
			, RP_SITE_ID
			, RP_PLANT_ID
		 FROM (
				SELECT VP.COMPANY_ID	AS VP_COMPANY_ID
					  ,VP.DIVISION_ID	AS VP_DIVISION_ID
					  ,VP.SITE_ID		AS VP_SITE_ID
					  ,VP.PLANT_ID		AS VP_PLANT_ID
					  ,RP.COMPANY_ID	AS RP_COMPANY_ID
					  ,RP.DIVISION_ID	AS RP_DIVISION_ID
					  ,RP.SITE_ID		AS RP_SITE_ID
					  ,RP.PLANT_ID		AS RP_PLANT_ID
					  ,ROW_NUMBER()		OVER (PARTITION BY VP.COMPANY_ID
														  ,VP.DIVISION_ID
														  ,VP.SITE_ID
														  ,VP.PLANT_ID
												  ORDER BY RP.UPDATE_TIME DESC) AS VP_RN 
					  ,ROW_NUMBER()		OVER (PARTITION BY RP.COMPANY_ID
														  ,RP.DIVISION_ID
														  ,RP.SITE_ID
														  ,RP.PLANT_ID
												  ORDER BY VP.UPDATE_TIME DESC) AS RP_RN 
				 FROM SCM_MST_PLANT_SN VP WITH(NOLOCK)
					  INNER JOIN SCM_MST_PLANT_SN RP WITH(NOLOCK)
							  ON RP.PLANT_ID = VP.LINK_PLANT_ID
				WHERE 1=1
				  AND VP.PLANT_TYPE = 'VIRTUAL'				) SUB_QUERY 
		WHERE 1=1
		  AND VP_RN = 1 
		  AND RP_RN = 1 

    RETURN;
END







