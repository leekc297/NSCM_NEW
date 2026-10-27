


CREATE VIEW [dbo].[FP_SIMULATION_MODEL_ELEC_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_MODEL_ELEC_V
--
-- Program Name        : FP_SIMULATION_MODEL_ELEC_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_AMEND_DAILY_PLAN_R, FP_AMEND_DAILY_SALES_R
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.08 1.0 PIYONG
-- Author              : PIYONG
-- Version             : 1.0 신규 생성
-- ================================================================================================
AS 
	SELECT A.INSTANCE_ID
		   , FP_PLAN_ID
		   , A.ITEM_ID
		   , ISNULL(C.NICK_NAME,'-') AS NICK_NAME
	  FROM (
			SELECT A.INSTANCE_ID
				   , A.FP_PLAN_ID
				   , A.COMPANY_ID
				   , A.DIVISION_ID
				   , A.SITE_ID
				   , A.ITEM_ID
			  FROM FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
			 WHERE A.OPERATION_ID = 'E2000'
			UNION
			SELECT A.INSTANCE_ID
				   , A.FP_PLAN_ID
				   , A.COMPANY_ID
				   , A.DIVISION_ID
				   , A.SITE_ID
				   , A.ITEM_ID
			  FROM FP_AMEND_DAILY_SALES_R A WITH(NOLOCK)
			 WHERE A.CATEGORY_ID  = 'PRODUCT_TARGET'
			   AND A.OPERATION_ID = 'E2000'
		   ) A
		   INNER JOIN SCM_ITEM_M C WITH(NOLOCK)
				   ON A.COMPANY_ID   = C.COMPANY_ID
				  AND A.DIVISION_ID  = C.DIVISION_ID
				  AND A.SITE_ID      = C.SITE_ID
				  AND A.ITEM_ID  = C.ITEM_ID
	 GROUP BY A.INSTANCE_ID
		   , FP_PLAN_ID
		   , A.ITEM_ID
		   , ISNULL(C.NICK_NAME,'-')


