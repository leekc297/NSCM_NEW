
/*
 * Program ID   : FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP                                                              
 * Description  : JV Real Line과 ESS virtual line 매핑 정보 반환 함수
 *				  JV Real Line : ESS Virtual Line = 1 : 1 
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2025.11.04	hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *
 */

CREATE FUNCTION [dbo].[FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP] ( 
)   
RETURNS @RETURN_TABLE TABLE
(
	  VL_COMPANY_ID			NVARCHAR(30)	NOT NULL
	, VL_DIVISION_ID		NVARCHAR(30)	NOT NULL
	, VL_SITE_ID			NVARCHAR(30)	NOT NULL
	, VL_PLANT_ID			NVARCHAR(30)	NOT NULL
	, VL_FACTORY_ID			NVARCHAR(30)	NOT NULL
	--, VL_OPERATION_ID		NVARCHAR(30)	NOT NULL
	, VL_LINE_ID			NVARCHAR(30)	NOT NULL
	, RL_COMPANY_ID			NVARCHAR(30)	NOT NULL
	, RL_DIVISION_ID		NVARCHAR(30)	NOT NULL
	, RL_SITE_ID			NVARCHAR(30)	NOT NULL
	, RL_PLANT_ID			NVARCHAR(30)	NOT NULL
	, RL_FACTORY_ID			NVARCHAR(30)	NOT NULL
	--, RL_OPERATION_ID		NVARCHAR(30)	NOT NULL
	, RL_LINE_ID			NVARCHAR(30)	NOT NULL
)

BEGIN

		------------------------------------------------------------------------------------------------------------------------------------------------
		--PRINT convert(varchar(30), getdate(), 121) +  N' ### JV Real Line과 ESS VIrtual Line 매핑 정보 반환 : @RETURN_TABLE' 
		------------------------------------------------------------------------------------------------------------------------------------------------
		insert into @RETURN_TABLE (
			  VL_COMPANY_ID
			, VL_DIVISION_ID
			, VL_SITE_ID
			, VL_PLANT_ID
			, VL_FACTORY_ID
			--, VL_OPERATION_ID
			, VL_LINE_ID
			, RL_COMPANY_ID
			, RL_DIVISION_ID
			, RL_SITE_ID
			, RL_PLANT_ID
			, RL_FACTORY_ID
			--, RL_OPERATION_ID
			, RL_LINE_ID
		)
		SELECT 
			  VL_COMPANY_ID
			, VL_DIVISION_ID
			, VL_SITE_ID
			, VL_PLANT_ID
			, VL_FACTORY_ID
			--, VL_OPERATION_ID
			, VL_LINE_ID
			, RL_COMPANY_ID
			, RL_DIVISION_ID
			, RL_SITE_ID
			, RL_PLANT_ID
			, RL_FACTORY_ID
			--, RL_OPERATION_ID
			, RL_LINE_ID
		 FROM (
				SELECT VL.COMPANY_ID	AS VL_COMPANY_ID
					  ,VL.DIVISION_ID	AS VL_DIVISION_ID
					  ,VL.SITE_ID		AS VL_SITE_ID
					  ,VL.PLANT_ID		AS VL_PLANT_ID
					  ,VL.FACTORY_ID	AS VL_FACTORY_ID
					  --,VL.OPERATION_ID	AS VL_OPERATION_ID
					  ,VL.LINE_ID		AS VL_LINE_ID
					  ,RL.COMPANY_ID	AS RL_COMPANY_ID
					  ,RL.DIVISION_ID	AS RL_DIVISION_ID
					  ,RL.SITE_ID		AS RL_SITE_ID
					  ,RL.PLANT_ID		AS RL_PLANT_ID
					  ,RL.FACTORY_ID	AS RL_FACTORY_ID
					  --,RL.OPERATION_ID	AS RL_OPERATION_ID
					  ,RL.LINE_ID		AS RL_LINE_ID
					  ,ROW_NUMBER()		OVER (PARTITION BY VL.COMPANY_ID
														  ,VL.DIVISION_ID
														  ,VL.SITE_ID
														  ,VL.PLANT_ID
														  ,VL.FACTORY_ID
														  --,VL.OPERATION_ID
														  ,VL.LINE_ID
												 ORDER BY CASE WHEN RL.DIVISION_ID LIKE '81_%' THEN 1 ELSE 2 END	-- JV Real 
														 ,RL.DIVISION_ID
														 ,RL.LINE_ID DESC ) AS VL_RN 
					  ,ROW_NUMBER()		OVER (PARTITION BY RL.COMPANY_ID
														  ,RL.DIVISION_ID
														  ,RL.SITE_ID
														  ,RL.PLANT_ID
														  ,RL.FACTORY_ID
														  --,RL.OPERATION_ID
														  ,RL.LINE_ID
												 ORDER BY CASE WHEN VL.DIVISION_ID LIKE '82' THEN 1 ELSE 2 END	-- ESS
														 ,VL.DIVISION_ID
														 ,VL.LINE_ID DESC ) AS RL_RN 
				 FROM SCM_MST_LINE_SN VL WITH(NOLOCK)
					  INNER JOIN SCM_MST_LINE_SN RL WITH(NOLOCK)
							  ON RL.LINE_ID			= VL.LINK_LINE_ID
							 AND RL.OPERATION_ID	= VL.OPERATION_ID
							 AND RL.ELECTRODE_TYPE	= VL.ELECTRODE_TYPE 
				WHERE 1=1
				  AND VL.VIRTUAL_LINE_YN	= 'Y'
				  AND VL.ACTIVE_FLAG		= 'Y'	) SUB_QUERY 
		WHERE 1=1
		  AND VL_RN = 1 
		  AND RL_RN = 1 

    RETURN;
END







