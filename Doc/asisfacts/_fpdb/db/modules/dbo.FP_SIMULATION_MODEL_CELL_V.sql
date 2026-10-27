

CREATE VIEW [dbo].[FP_SIMULATION_MODEL_CELL_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_MODEL_CELL_V
--
-- Program Name        : FP_SIMULATION_MODEL_CELL_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_AMEND_PLAN_CELL_SALES_R, FP_AMEND_PLAN_CELL_R
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.01
-- Author              : PIYONG
-- Version             : 2019-08-01 PIYONG 신규 생성
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
			  FROM FP_AMEND_PLAN_CELL_SALES_R A WITH(NOLOCK)
			 WHERE ( ISNULL(A.SALES_QTY,0) > 0 OR ISNULL(A.PAST_SALES_QTY,0) > 0)
			UNION
			SELECT A.INSTANCE_ID
				   , A.FP_PLAN_ID
				   , A.COMPANY_ID
				   , A.DIVISION_ID
				   , A.SITE_ID
				   , A.TOP_ITEM_ID
			  FROM FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)
			 WHERE ( A.OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0 )
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


