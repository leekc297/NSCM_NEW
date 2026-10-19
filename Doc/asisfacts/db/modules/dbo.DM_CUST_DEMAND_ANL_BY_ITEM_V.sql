
CREATE VIEW [dbo].[DM_CUST_DEMAND_ANL_BY_ITEM_V]
AS
/****************************************************************************************************************************************
* PROJECT       : LGES SCM
* VIEW NAME     : DM_CUST_DEMAND_ANL_BY_ITEM_V
* DESCRIPTION   : 고객수요분석 - ITEM별 SUMMARY 및 DETAIL 수량 조회
* PROGRAM HISTORY
*----------------------------------------------------------------------------------------------------------------------------------------
*  DATE         IN CHARGE           DESCRIPTION
*----------------------------------------------------------------------------------------------------------------------------------------
* 2025.02.11    Philsu Park         Initial Release.
* 2025.03.04    Philsu Park         [E20250228-001385]_SCM View 테이블 관련 정보 추가 요청 건 [KWH_PER_CELL 추가(SSPM의 ATTRIBUTE8번 값 사용)]
****************************************************************************************************************************************/
WITH TEMP_CELL_CF AS (
                        SELECT CT.COMPANY_ID
                                , MAX(CT.DIVISION_ID) AS DIVISION_ID
                                , CT.SITE_ID
                                , CT.PLANT_ID
                                , CT.MODEL_ID
                                , CT.CHILD_ITEM_ID
                                , SUM(CT.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
                                , MAX(CT.CHILD_UOM) AS CHILD_UOM
                        FROM  (	SELECT    CT.COMPANY_ID
                                        , CT.DIVISION_ID
                                        , CT.SITE_ID 
                                        , CT.PARENT_ITEM_ID
                                        , CT.MODEL_ID
                                        , CT.CHILD_ITEM_ID 
                                        , CT.PLANT_ID
                                        , CT.ACCUMULATED_CHILD_QTY
                                        , CT.CHILD_UOM
                                        , CT.ALT_PRIORITY
                                FROM    (   SELECT    COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID
                                                    , PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM
                                                    , ACCUMULATED_CHILD_QTY, ALT_PRIORITY
                                            FROM    SCM_MODEL_COMP_TEMP_SN WITH(NOLOCK)
                                            WHERE   DIVISION_ID LIKE '81%' --속도 이슈 감안해서 81사업부 한정 조건 적용.
                                            GROUP BY      COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID
                                                        , PARENT_ITEM_ID, CHILD_ITEM_ID, CHILD_QTY, CHILD_UOM
                                                        , ACCUMULATED_CHILD_QTY, ALT_PRIORITY
                                        ) CT
                                    ,   (   SELECT  SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
                                            FROM    SCM_MST_ITEM_SN SIM WITH(NOLOCK)
                                            INNER JOIN SCM_MST_ITEM_CLASS_SN ICM WITH(NOLOCK)
                                                ON  ICM.CLASS_ID    = SIM.ITEM_CLASS
                                            INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
                                                ON  B.LOOKUP_TYPE   = 'DM_CELL_ITEM_LEVEL_ID'
                                                AND ICM.LEVEL_1_ID  = B.SEGMENT1
                                            GROUP BY SIM.DIVISION_ID, SIM.COMPANY_ID, SIM.SITE_ID, SIM.ITEM_ID, SIM.FLOW_ID
                                        ) CL
                                WHERE   CT.COMPANY_ID       = CL.COMPANY_ID
                                AND     CT.DIVISION_ID      = CL.DIVISION_ID
                                AND     CT.SITE_ID          = CL.SITE_ID
                                AND     CT.CHILD_ITEM_ID    = CL.ITEM_ID
                                AND    ((CL.FLOW_ID IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID')/*('P5500', 'P9500')*/
                                            AND CT.PARENT_ITEM_ID <>  '*')
                                        OR CL.FLOW_ID NOT IN (SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = 'DM_CELL_FLOW_ID'))
                                AND     CT.ALT_PRIORITY      = 'Y'
                            )  CT
                        GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID
                    )
, CELL_PER_BIZ AS   (
                    SELECT  C.DIVISION_ID, C.ITEM_ID
                            , IIF(MAX(D.ACCUMULATED_CHILD_QTY) IS NULL, MAX(E.ACCUMULATED_CHILD_QTY), MAX(D.ACCUMULATED_CHILD_QTY)) AS ACCUMULATED_CHILD_QTY
                            , MAX(C.KWH_PER_CELL) AS KWH_PER_CELL --[E20250228-001385]_KWH_PER_CELL 추가
                    FROM (  SELECT	A.ITEM_ID, A.DIVISION_ID
								  , MAX(ATTRIBUTE8) AS KWH_PER_CELL --[E20250228-001385]_KWH_PER_CELL 추가
                            FROM	SCM_MST_SITE_ITEM A  WITH(NOLOCK),
                                    (   SELECT	DIVISION_ID, ITEM_ID
                                        FROM	SCM_MST_ITEM_SN  WITH(NOLOCK)
                                        GROUP BY DIVISION_ID, ITEM_ID
                                    ) B
                            WHERE	 1=1
                            AND      A.DIVISION_ID   LIKE '81%'  --속도 이슈 감안해서 81사업부 한정 조건 적용.
                            AND      A.VALID_YN         = 'Y'
                            AND		 A.DIVISION_ID      = B.DIVISION_ID
                            AND		 A.ITEM_ID          = B.ITEM_ID
                            GROUP BY A.ITEM_ID, A.DIVISION_ID
                        ) C
                    LEFT OUTER JOIN (   SELECT  MODEL_ID, MAX(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
                                        FROM    TEMP_CELL_CF
                                        GROUP BY    MODEL_ID
                                        ) D
                                    ON D.MODEL_ID = C.ITEM_ID
                    LEFT OUTER JOIN (   SELECT  MODEL_ID, MAX(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
                                        FROM    TEMP_CELL_CF
                                        GROUP BY    MODEL_ID
                                        ) E
                                    ON E.MODEL_ID LIKE CONCAT(SUBSTRING(C.ITEM_ID, 1, 10), '%')
                    GROUP BY C.DIVISION_ID, C.ITEM_ID
                    )
SELECT  TOP 100 PERCENT
        TT.DIVISION_ID
        , TT.END_CUSTOMER
        , TT.PROJECT_CODE
        , TT.ITEM_ID
        , TT.MEASURE
        , TT.PLAN_YYYYMM
        , TT.REQ_RSN_CD
        , TT.DIF_ANLS_TP_CD
        , TT.ANLS_DIF_RSN_CD
        , TT.REQ_RSN_DTL_CTN
        , TT.QTY
        , TT.CFCST_QTY
        , TT.MFCST_QTY
        , TT.CELL_PER_BIZ
        , TT.CELL_QTY
        , TT.CFCST_CELL_QTY
        , TT.MFCST_CELL_QTY
        , CASE WHEN TT.ITEM_ID IS NULL THEN NULL ELSE TT.KWH_PER_CELL END AS KWH_PER_CELL --[E20250228-001385]_KWH_PER_CELL 추가
FROM    (
        SELECT MM.DIVISION_ID, MM.END_CUSTOMER, MM.PROJECT_CODE, MM.ITEM_ID, MM.MEASURE, MM.PLAN_YYYYMM -- Summary
            , NULL                                                                  AS REQ_RSN_CD
            , NULL                                                                  AS DIF_ANLS_TP_CD
            , NULL                                                                  AS ANLS_DIF_RSN_CD
            , NULL                                                                  AS REQ_RSN_DTL_CTN             -- Detail
            , SUM(ROUND(MM.GAP_QTY, 0))                                             AS QTY
            , SUM(ROUND(MM.CUST_FCST_QTY, 0))                                       AS CFCST_QTY
            , SUM(ROUND(MM.MKT_FCST_QTY, 0))                                        AS MFCST_QTY
            , MAX(CL.ACCUMULATED_CHILD_QTY)                                         AS CELL_PER_BIZ
            , SUM(ROUND(MM.GAP_QTY, 0) * ISNULL(CL.ACCUMULATED_CHILD_QTY, 1))       AS CELL_QTY
            , SUM(ROUND(MM.CUST_FCST_QTY, 0) * ISNULL(CL.ACCUMULATED_CHILD_QTY, 1)) AS CFCST_CELL_QTY
            , SUM(ROUND(MM.MKT_FCST_QTY, 0) * ISNULL(CL.ACCUMULATED_CHILD_QTY, 1))  AS MFCST_CELL_QTY
            , MAX(CL.KWH_PER_CELL)                                                  AS KWH_PER_CELL --[E20250228-001385]_KWH_PER_CELL 추가
        FROM (
                SELECT  DIVISION_ID, END_CUSTOMER, PROJECT_CODE, ITEM_ID, MEASURE, PLAN_YYYYMM
                        , CUST_FCST_QTY AS CUST_FCST_QTY
                        , MKT_FCST_QTY AS MKT_FCST_QTY
                        , MKT_FCST_QTY - CUST_FCST_QTY AS GAP_QTY
                FROM    DM_CUST_DEMAND_BY_ITEM_SUMMARY A WITH(NOLOCK)
                ) MM
        INNER JOIN CELL_PER_BIZ CL
            ON  CL.DIVISION_ID  = MM.DIVISION_ID
            AND CL.ITEM_ID      = MM.ITEM_ID
        WHERE  1=1
        AND    MM.PLAN_YYYYMM  >= '202401'
        AND    (MM.CUST_FCST_QTY <> 0 OR MM.MKT_FCST_QTY <> 0)
        GROUP BY ROLLUP(MM.ITEM_ID), MM.DIVISION_ID, MM.END_CUSTOMER, MM.PROJECT_CODE, MM.MEASURE, MM.PLAN_YYYYMM
        UNION ALL
        SELECT MM.DIVISION_ID, MM.END_CUSTOMER, MM.PROJECT_CODE, MM.ITEM_ID, MM.MEASURE, MM.PLAN_YYYYMM -- Summary
            , DTL.REQ_RSN_CD, DTL.DIF_ANLS_TP_CD, DTL.ANLS_DIF_RSN_CD, DTL.REQ_RSN_DTL_CTN             -- Detail
            , ROUND(MM.GAP_QTY * DTL.DETAIL_RATIO, 0)                                               AS QTY
            , ROUND(MM.CUST_FCST_QTY * DTL.DETAIL_RATIO, 0)                                         AS CFCST_QTY
            , ROUND(MM.MKT_FCST_QTY * DTL.DETAIL_RATIO, 0)                                          AS MFCST_QTY
            , CL.ACCUMULATED_CHILD_QTY                                                              AS CELL_PER_BIZ
            , ROUND(MM.GAP_QTY * DTL.DETAIL_RATIO, 0) * ISNULL(CL.ACCUMULATED_CHILD_QTY, 1)         AS CELL_QTY
            , ROUND(MM.CUST_FCST_QTY * DTL.DETAIL_RATIO, 0) * ISNULL(CL.ACCUMULATED_CHILD_QTY, 1)   AS CFCST_CELL_QTY
            , ROUND(MM.MKT_FCST_QTY * DTL.DETAIL_RATIO, 0) * ISNULL(CL.ACCUMULATED_CHILD_QTY, 1)    AS MFCST_CELL_QTY
            , CL.KWH_PER_CELL                                                                       AS KWH_PER_CELL --[E20250228-001385]_KWH_PER_CELL 추가
        FROM (
                SELECT  DIVISION_ID, END_CUSTOMER, PROJECT_CODE, ITEM_ID, MEASURE, PLAN_YYYYMM
                        , CUST_FCST_QTY AS CUST_FCST_QTY
                        , MKT_FCST_QTY AS MKT_FCST_QTY
                        , MKT_FCST_QTY - CUST_FCST_QTY AS GAP_QTY
                FROM    DM_CUST_DEMAND_BY_ITEM_SUMMARY A WITH(NOLOCK)
                ) MM
        INNER JOIN CELL_PER_BIZ CL
            ON  CL.DIVISION_ID  = MM.DIVISION_ID
            AND CL.ITEM_ID      = MM.ITEM_ID
        INNER JOIN (SELECT  SEQ_NO, DIVISION_ID, END_CUSTOMER, PROJECT_CODE, MEASURE, PLAN_YYYYMM, REQ_RSN_CD, DIF_ANLS_TP_CD, ANLS_DIF_RSN_CD, REQ_RSN_DTL_CTN, QTY
                            , CASE WHEN SUM(ABS(QTY))OVER(PARTITION BY DIVISION_ID, END_CUSTOMER, PROJECT_CODE, MEASURE, PLAN_YYYYMM) = 0 THEN 0
                                    ELSE ABS(QTY)/SUM(ABS(QTY))OVER(PARTITION BY DIVISION_ID, END_CUSTOMER, PROJECT_CODE, MEASURE, PLAN_YYYYMM)
                                END AS DETAIL_RATIO
                    FROM    DM_CUST_DEMAND_ANL_DETAIL T WITH(NOLOCK)
                    ) DTL
            ON  DTL.DIVISION_ID     = MM.DIVISION_ID
            AND DTL.END_CUSTOMER    = MM.END_CUSTOMER
            AND DTL.PROJECT_CODE    = MM.PROJECT_CODE
            AND DTL.MEASURE         = MM.MEASURE
            AND DTL.PLAN_YYYYMM     = MM.PLAN_YYYYMM
        WHERE  1=1
        AND    MM.PLAN_YYYYMM  >= '202401'
        AND    (MM.CUST_FCST_QTY <> 0 OR MM.MKT_FCST_QTY <> 0)
        ) TT
ORDER BY DIVISION_ID, END_CUSTOMER, PROJECT_CODE, MEASURE DESC, PLAN_YYYYMM, ITEM_ID, (CASE WHEN REQ_RSN_CD IS NULL THEN 0 ELSE 1 END)
