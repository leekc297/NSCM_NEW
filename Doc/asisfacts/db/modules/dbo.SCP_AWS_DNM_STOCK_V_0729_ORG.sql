



CREATE VIEW [dbo].[SCP_AWS_DNM_STOCK_V_0729_ORG] AS
/*
 * Program ID   : SCP_AWS_DNM_STOCK_V
 * Description  : AWS 향 재고 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.03.08   KSG            Initial Release E20240307-001294 생산계획/실적/재고 View 생성 요청
 * 
 */
-- DIVISION_ID, CUTOFF_DATE 조건으로 조회
SELECT	  A.DIVISION_ID
        , A.cutoff_date                 AS CUTOFF_DATE
        , buc.YYYY                      AS PLAN_YYYY
        , SUBSTRING(buc.yyyymm, 5,2)    AS PLAN_MM
        , SUBSTRING(buc.yyyymmdd, 7, 2) AS PLAN_DD
        , SUBSTRING(buc.yyyyww, 5, 2)   AS PLAN_WEEK
        , A.SCM_SITE_ID
        , A.COMPANY_ID
        , A.PLANT_ID
        , A.STORAGE_ID
        , f.OPERATION_GROUP
        , f.FLOW_ID
        , DBO.FN_GET_ITEM_PROD_OP(A.DIVISION_ID, f.OPERATION_GROUP, A.ITEM_ID) AS ITEM_ID_CELL
        , A.ITEM_ID                                                            AS ITEM_ID
        , SUBSTRING(A.ITEM_ID, 1, 12)                                         AS MODEL_CODE
        ,(
          SELECT TOP 1
                (
                 CASE WHEN X.NICK_NAME IS NULL OR X.NICK_NAME = '' THEN '-'
                      ELSE X.NICK_NAME
                 END
                )
          FROM   DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)
          WHERE  X.ITEM_ID  = A.ITEM_ID
         )  AS NICK_NAME
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
        , A.SCM_QTY
        , f.convert_qty_cell AS CELL_CONVERSION
        , A.SCM_QTY * ISNULL( f.convert_qty_cell, 0)AS SCM_QTY_CELL

FROM scm_dnm_stock A WITH(NOLOCK)

INNER JOIN SCP_MST_FINAL_ITEM f with(nolock)
ON  a.division_id  = f.division_id
AND a.item_id  = f.item_id
and f.flow_id IN ('A3000', 'A9000', 'P5500', 'P9500', 'P5200')

INNER JOIN SCM_MST_BUCKET buc with(nolock)
ON a.CUTOFF_DATE  = buc.yyyymmdd

WHERE  1=1
AND    A.stock_type = 'INVENTORY'
AND    f.OPERATION_GROUP IN ('A', 'P')
AND    ISNULL(a.scm_site_id,'') = CASE WHEN a.storage_id = '5552' and ISNULL(a.scm_site_id,'') <> '' THEN 'NO' ELSE ISNULL(a.scm_site_id,'') END -- 5552 할당 재고 제외

