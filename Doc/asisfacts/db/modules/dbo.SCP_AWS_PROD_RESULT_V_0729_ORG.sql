



CREATE VIEW [dbo].[SCP_AWS_PROD_RESULT_V_0729_ORG] AS
/*
 * Program ID   : SCP_AWS_PROD_RESULT_V
 * Description  : AWS 향 생산실적 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.03.08   KSG            Initial Release E20240307-001294 생산계획/실적/재고 View 생성 요청
 * 
 */
-- DIVISION_ID, PLAN_DATE 조건으로 조회
SELECT A.DIVISION_ID
     , A.PLAN_DATE                   AS PLAN_DATE
     , buc.YYYY                      AS PLAN_YYYY
     , SUBSTRING(buc.yyyymm, 5,2)    AS PLAN_MM
     , SUBSTRING(buc.yyyymmdd, 7, 2) AS PLAN_DD
     , SUBSTRING(buc.yyyyww, 5, 2)   AS PLAN_WEEK
     , A.COMPANY_ID
     , A.PLANT_ID
     , A.LINE_ID
     , f.OPERATION_GROUP
     , A.OPERATION_ID
     , CASE WHEN f.OPERATION_GROUP != 'A' THEN A.ITEM_ID ELSE D.ITEM_ID_PROD END AS ITEM_ID_CELL
     , A.ITEM_ID                                                                 AS ITEM_ID
     , SUBSTRING(A.ITEM_ID, 1, 12)                                               AS MODEL_CODE
     , C.NICK_NAME
     , CASE WHEN a.division_id = '40' THEN (
                                            SELECT B.SEGMENT2 NAME
                                            FROM   SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
                                              JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
                                              ON  A.LOOKUP_TYPE = B.LOOKUP_TYPE
                                              AND B.VALID_YN    = 'Y'
                                            WHERE 1=1
                                            AND   A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_GROUP'
                                            AND   A.VALID_YN      = 'Y'
                                            AND   B.SEGMENT1      = f.cell_type_group_code
                                           )
		ELSE f.group_code6
		END AS PRODUCT_LEVEL1
     , A.ACTUAL_QTY
     , A.ACTUAL_GOOD_QTY
     , A.ACTUAL_SCRAP_QTY

FROM   scp_mst_final_item f with(nolock)
     INNER LOOP JOIN SCM_DNM_DAILY_PRODUCT_RESULT_SN  A WITH(NOLOCK)  -- [LGCE_FPDEV_TR].[DBO].[SCM_DAILY_PRODUCT_RESULT_H]
				  ON  a.division_id  = f.division_id
				 AND a.item_id = f.item_id
                 AND a.OPERATION_ID IN ('A3000', 'A9000', 'P5500', 'P9500', 'P5200')
     OUTER APPLY ( SELECT TOP 1 ( CASE WHEN X.NICK_NAME IS NULL OR X.NICK_NAME = '' THEN '-' ELSE X.NICK_NAME END ) NICK_NAME
                     FROM DBO.SCM_MST_ITEM_SN X WITH(NOLOCK)
                    WHERE X.ITEM_ID  = A.ITEM_ID
				 ) C
     OUTER APPLY ( SELECT TOP 1 ISNULL(ITEM_ID_PROD, A.ITEM_ID) ITEM_ID_PROD
					 FROM DBO.SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
					WHERE 1=1
					  AND DIVISION_ID          = A.DIVISION_ID
					  AND ITEM_ID_ASSY         = A.ITEM_ID
				 ) D

     INNER JOIN SCM_MST_BUCKET buc with(nolock)
     ON a.PLAN_DATE  = buc.yyyymmdd

WHERE  1=1
AND    f.OPERATION_GROUP IN ('A', 'P')
AND    A.PRODUCTION_TYPE  NOT IN ('REWORK', 'PILOT')

