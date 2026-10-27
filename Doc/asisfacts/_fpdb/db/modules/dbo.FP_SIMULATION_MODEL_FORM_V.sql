


CREATE VIEW [dbo].[FP_SIMULATION_MODEL_FORM_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_MODEL_FORM_V
--
-- Program Name        : FP_SIMULATION_MODEL_FORM_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_AMEND_PLAN_CELL_SALES_R, FP_AMEND_PLAN_CELL_R
-- Destination Table   : 
--
-- Create(Update) Date : 2019.10.03
-- Author              : KIMCD
-- Version             : 2019-10-03 KIMCD 신규 생성
-- ================================================================================================
AS 
	SELECT A.INSTANCE_ID
		   , FP_PLAN_ID
		   , A.TOP_ITEM_ID AS MODEL_ID
		   , ISNULL(C.NICK_NAME,'-') AS NICK_NAME
	  FROM (
			SELECT A.INSTANCE_ID
				   , A.FP_PLAN_ID
				   , A.COMPANY_ID
				   , A.DIVISION_ID
				   , A.SITE_ID
				   , A.TOP_ITEM_ID
			  FROM FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)
			 WHERE ( A.WPP_OUT_QTY <> 0 OR A.OUT_QTY <> 0  OR  ISNULL(A.AVAILABILITY,0) <> 0 OR  ISNULL(A.AGING_WIP,0) <> 0 OR (A.FACTORY_ID = '-' AND  (A.SALES_QTY <> 0 OR A.CARRYOVER_QTY <> 0) )  )
		   ) A
		   INNER JOIN SCM_ITEM_M C WITH(NOLOCK)
				   ON A.COMPANY_ID   = C.COMPANY_ID
				  AND A.DIVISION_ID  = C.DIVISION_ID
				  AND A.SITE_ID      = C.SITE_ID
				  AND A.TOP_ITEM_ID  = C.ITEM_ID
	 GROUP BY A.INSTANCE_ID
		   , FP_PLAN_ID
		   , A.TOP_ITEM_ID
		   , ISNULL(C.NICK_NAME,'-')



