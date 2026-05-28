/*=============================================================================================
 * File         : 03_View_SCM_DNM_PRODUCT_RESULT_V.sql
 * Description  : View — SCM_DNM_PRODUCT_RESULT_V
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : ANSI OUTER JOIN → (+) 변환은 자동변환 위험으로 수동 검토 필요.
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 04_Views 단계 (Tables 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN ... ON → WHERE A.x = B.x(+) 변환 (사내 표준 §7.1.6)
 *===========================================================================================*/

-- SCM_MGR.SCM_DNM_PRODUCT_RESULT_V source

CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCM_DNM_PRODUCT_RESULT_V" ("SCM_SITE_ID", "SCP_OPERATION_GROUP", "COMPANY_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "TOP_ITEM_ID", "ITEM_ID", "ORIGIN_ITEM_ID", "OPERATION_ID", "LOCATION", "PRODUCTION_TYPE", "MARKET", "LINE_ID", "ELECTRODE_TYPE", "PLAN_DATE", "ACTUAL_QTY", "ACTUAL_GOOD_QTY", "ACTUAL_SCRAP_QTY", "INSERT_ID", "INSERT_TIME", "UPDATE_ID", "UPDATE_TIME", "QTY", "QTY_LANE", "DFCT_QTY2", "LOSS_QTY2", "PRDT_REQ_QTY2", "TOP_COATING_QTY2", "YIELD_LOSS_QTY", "EQUIPMENT_ID", "FP_PRODUCTION_TYPE", "ROLL_IN_QTY", "ROLL_OUT_QTY", "JR_IN_QTY", "JR_OUT_QTY", "BATCH_IN_QTY", "BATCH_OUT_QTY", "CELL_IN_QTY", "CELL_OUT_QTY") AS 
  SELECT PR.SCM_SITE_ID
      ,PR.SCP_OPERATION_GROUP
      ,PR.COMPANY_ID
      ,PR.DIVISION_ID
      ,PR.SITE_ID
      ,PR.PLANT_ID
      ,PR.FACTORY_ID
      ,PR.TOP_ITEM_ID
      ,NVL(FI.PACKER_PLAN_ITEM_ID, PR.ITEM_ID) AS ITEM_ID  --2018.06.29
      ,PR.ITEM_ID AS ORIGIN_ITEM_ID                        --2018.06.29
      ,PR.OPERATION_ID
      ,PR.LOCATION
      ,PR.PRODUCTION_TYPE
      ,PR.MARKET
      ,PR.LINE_ID
      ,FI.ELECTRODE_TYPE  -- 2018.07.12
      ,PR.PLAN_DATE
      ,PR.ACTUAL_QTY
      ,PR.ACTUAL_GOOD_QTY
      ,PR.ACTUAL_SCRAP_QTY
      ,PR.INSERT_ID
      ,PR.INSERT_TIME
      ,PR.UPDATE_ID
      ,PR.UPDATE_TIME
      ,PR.QTY
      ,PR.QTY_LANE
      ,PR.DFCT_QTY2
      ,PR.LOSS_QTY2
      ,PR.PRDT_REQ_QTY2
      ,PR.TOP_COATING_QTY2
      ,PR.YIELD_LOSS_QTY
      ,PR.EQUIPMENT_ID
      ,PR.FP_PRODUCTION_TYPE
      ,PR.ROLL_IN_QTY
      ,PR.ROLL_OUT_QTY
      ,PR.JR_IN_QTY
      ,PR.JR_OUT_QTY
      ,PR.BATCH_IN_QTY
      ,PR.BATCH_OUT_QTY
      ,PR.CELL_IN_QTY
      ,PR.CELL_OUT_QTY
FROM
(
    SELECT
         (SELECT NVL(I.SCM_SITE_ID, '-')
            FROM SCM_MGR.SCM_MST_SITE I
           WHERE 1 = 1
             AND I.PLANT_ID        = A.PLANT_ID
             AND I.OPERATION_GROUP = B.SCP_OPERATION_GROUP
             AND I.SITE_TYPE       = 'PLANT'
             AND I.VALID_YN        = 'Y'
             AND ROWNUM            = 1
         ) AS SCM_SITE_ID
        ,B.SCP_OPERATION_GROUP
        ,A.COMPANY_ID
        ,A.DIVISION_ID
        ,A.SITE_ID
        ,A.PLANT_ID
        ,A.FACTORY_ID
        ,A.TOP_ITEM_ID
        ,A.ITEM_ID
        ,A.OPERATION_ID
        ,A.LOCATION
        ,A.PRODUCTION_TYPE
        ,A.MARKET
        ,A.LINE_ID
        ,A.ELECTRODE_TYPE
        ,A.PLAN_DATE
        ,A.ACTUAL_QTY
        ,A.ACTUAL_GOOD_QTY
        ,A.ACTUAL_SCRAP_QTY
        ,A.INSERT_ID
        ,A.INSERT_TIME
        ,A.UPDATE_ID
        ,A.UPDATE_TIME
        ,A.QTY
        ,A.QTY_LANE
        ,A.DFCT_QTY2
        ,A.LOSS_QTY2
        ,A.PRDT_REQ_QTY2
        ,A.TOP_COATING_QTY2
        ,A.YIELD_LOSS_QTY
        ,A.EQUIPMENT_ID
        ,A.FP_PRODUCTION_TYPE
        ,A.ROLL_IN_QTY
        ,A.ROLL_OUT_QTY
        ,A.JR_IN_QTY
        ,A.JR_OUT_QTY
        ,A.BATCH_IN_QTY
        ,A.BATCH_OUT_QTY
        ,A.CELL_IN_QTY
        ,A.CELL_OUT_QTY
    FROM   SCM_MGR.SCM_DNM_DAILY_PRODUCT_RESULT_SN A
    JOIN   SCM_MGR.SCM_MST_ITEM_SN B
      ON   A.COMPANY_ID  = B.COMPANY_ID
      AND  A.DIVISION_ID = B.DIVISION_ID
      AND  A.SITE_ID     = B.SITE_ID
      AND  A.ITEM_ID     = B.ITEM_ID
    WHERE  B.SCP_OPERATION_GROUP IS NOT NULL
    AND    A.PRODUCTION_TYPE     NOT IN ('REWORK', 'PILOT')

    -- 20211006 C20210915-000381 외주 생산실적 테이블 변경 : ERP -> SCS
    -- Line 별 Plan 수행 대상 Site
    UNION ALL
    SELECT
         A.SCM_SITE_ID
        ,B.SCP_OPERATION_GROUP
        ,C.COMPANY_ID
        ,A.DIVISION_ID
        ,C.SITE_ID
        ,C.PLANT_ID                                      AS PLANT_ID
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS FACTORY_ID
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS TOP_ITEM_ID
        ,A.ITEM_ID
        ,C.PLANT_ID                                      AS OPERATION_ID
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS LOCATION
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS PRODUCTION_TYPE
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS MARKET
        ,A.LINE_ID
        ,CAST(NULL AS VARCHAR2(50 CHAR))                 AS ELECTRODE_TYPE
        ,TO_DATE(A.PROD_DATE, 'YYYYMMDD')                AS PLAN_DATE
        ,CAST(A.PROD_QTY + A.DEFECT_QTY AS NUMBER(20,4)) AS ACTUAL_QTY
        ,CAST(A.PROD_QTY                AS NUMBER(20,4)) AS ACTUAL_GOOD_QTY
        ,CAST(A.DEFECT_QTY              AS NUMBER(20,4)) AS ACTUAL_SCRAP_QTY
        ,A.CREATED_BY                                    AS INSERT_ID
        ,A.CREATION_DATE                                 AS INSERT_TIME
        ,A.LAST_UPDATED_BY                               AS UPDATE_ID
        ,A.LAST_UPDATE_DATE                              AS UPDATE_TIME
        ,CAST(NULL AS NUMBER(18,5))                      AS QTY
        ,CAST(NULL AS NUMBER(18,5))                      AS QTY_LANE
        ,CAST(NULL AS NUMBER(18,5))                      AS DFCT_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS LOSS_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS PRDT_REQ_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS TOP_COATING_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS YIELD_LOSS_QTY
        ,CAST(NULL AS VARCHAR2(30 CHAR))                 AS EQUIPMENT_ID
        ,CAST(NULL AS VARCHAR2(30 CHAR))                 AS FP_PRODUCTION_TYPE
        ,CAST(NULL AS NUMBER(20,5))                      AS ROLL_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS ROLL_OUT_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS JR_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS JR_OUT_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS BATCH_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS BATCH_OUT_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS CELL_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS CELL_OUT_QTY
    FROM   SCM_MGR.SCM_DNM_SCS_PROD_RESULT A
    JOIN   SCM_MGR.SCM_MST_SITE C
      ON   A.DIVISION_ID = C.DIVISION_ID
      AND  A.SCM_SITE_ID = C.SCM_SITE_ID
    JOIN   SCM_MGR.SCM_MST_ITEM_SN B
      ON   C.COMPANY_ID  = B.COMPANY_ID
      AND  A.DIVISION_ID = B.DIVISION_ID
      AND  C.SITE_ID     = B.SITE_ID
      AND  A.ITEM_ID     = B.ITEM_ID
    WHERE  B.SCP_OPERATION_GROUP IS NOT NULL
    AND    NVL(C.OSP_YN,     '') = 'Y'  -- 외주
    AND    NVL(C.ATTRIBUTE1, '') = 'Y'  -- Line 별 Plan 수행 대상 Site

    -- 20211006 C20210915-000381 외주 생산실적 테이블 변경 : ERP -> SCS
    -- Plant 별 Plan 수행 대상 : Line 구분 없음
    UNION ALL
    SELECT
         A.SCM_SITE_ID
        ,B.SCP_OPERATION_GROUP
        ,C.COMPANY_ID
        ,A.DIVISION_ID
        ,C.SITE_ID
        ,C.PLANT_ID                                      AS PLANT_ID
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS FACTORY_ID
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS TOP_ITEM_ID
        ,A.ITEM_ID
        ,C.PLANT_ID                                      AS OPERATION_ID
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS LOCATION
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS PRODUCTION_TYPE
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS MARKET
        ,CAST('-'  AS VARCHAR2(30 CHAR))                 AS LINE_ID
        ,CAST(NULL AS VARCHAR2(50 CHAR))                 AS ELECTRODE_TYPE
        ,TO_DATE(A.PROD_DATE, 'YYYYMMDD')                AS PLAN_DATE
        ,CAST(A.PROD_QTY + A.DEFECT_QTY AS NUMBER(20,4)) AS ACTUAL_QTY
        ,CAST(A.PROD_QTY                AS NUMBER(20,4)) AS ACTUAL_GOOD_QTY
        ,CAST(A.DEFECT_QTY              AS NUMBER(20,4)) AS ACTUAL_SCRAP_QTY
        ,A.CREATED_BY                                    AS INSERT_ID
        ,A.CREATION_DATE                                 AS INSERT_TIME
        ,A.LAST_UPDATED_BY                               AS UPDATE_ID
        ,A.LAST_UPDATE_DATE                              AS UPDATE_TIME
        ,CAST(NULL AS NUMBER(18,5))                      AS QTY
        ,CAST(NULL AS NUMBER(18,5))                      AS QTY_LANE
        ,CAST(NULL AS NUMBER(18,5))                      AS DFCT_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS LOSS_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS PRDT_REQ_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS TOP_COATING_QTY2
        ,CAST(NULL AS NUMBER(18,5))                      AS YIELD_LOSS_QTY
        ,CAST(NULL AS VARCHAR2(30 CHAR))                 AS EQUIPMENT_ID
        ,CAST(NULL AS VARCHAR2(30 CHAR))                 AS FP_PRODUCTION_TYPE
        ,CAST(NULL AS NUMBER(20,5))                      AS ROLL_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS ROLL_OUT_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS JR_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS JR_OUT_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS BATCH_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS BATCH_OUT_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS CELL_IN_QTY
        ,CAST(NULL AS NUMBER(20,5))                      AS CELL_OUT_QTY
    FROM   SCM_MGR.SCM_DNM_SCS_PROD_RESULT A
    JOIN   SCM_MGR.SCM_MST_SITE C
      ON   A.DIVISION_ID = C.DIVISION_ID
      AND  A.SCM_SITE_ID = C.SCM_SITE_ID
    JOIN   SCM_MGR.SCM_MST_ITEM_SN B
      ON   C.COMPANY_ID  = B.COMPANY_ID
      AND  A.DIVISION_ID = B.DIVISION_ID
      AND  C.SITE_ID     = B.SITE_ID
      AND  A.ITEM_ID     = B.ITEM_ID
    WHERE  B.SCP_OPERATION_GROUP IS NOT NULL
    AND    NVL(C.OSP_YN,     '') = 'Y'  -- 외주
    AND    NVL(C.ATTRIBUTE1, '') = ''  -- Plant 별 Plan 수행 대상 : Line 구분 없음

    /* -- 주석 START 20211006 C20210915-000381 외주 생산실적 테이블 변경 : ERP -> SCS
    UNION ALL --2018. 5. 28
    SELECT
         A.SCM_SITE_ID
        ,B.SCP_OPERATION_GROUP
        ,A.COMPANY_ID
        ,A.DIVISION_ID
        ,A.SITE_ID
        ,VENDOR_CODE AS PLANT_ID
        ,'-' AS FACTORY_ID
        ,'-' AS TOP_ITEM_ID
        ,A.ITEM_ID
        ,VENDOR_CODE AS OPERATION_ID
        ,'-' AS LOCATION
        ,'-' AS PRODUCTION_TYPE
        ,'-' AS MARKET
        ,'-' AS LINE_ID
        ,NULL AS ELECTRODE_TYPE
        ,PROD_DATE AS PLAN_DATE
        ,GOOD_QTY + DEFECT_QTY AS ACTUAL_QTY
        ,GOOD_QTY AS ACTUAL_GOOD_QTY
        ,DEFECT_QTY AS ACTUAL_SCRAP_QTY
        ,CREATED_BY AS INSERT_ID
        ,CREATION_DATE AS INSERT_TIME
        ,LAST_UPDATED_BY AS UPDATE_ID
        ,LAST_UPDATE_DATE AS UPDATE_TIME
        ,NULL AS QTY
        ,NULL AS QTY_LANE
        ,NULL AS DFCT_QTY2
        ,NULL AS LOSS_QTY2
        ,NULL AS PRDT_REQ_QTY2
        ,NULL AS TOP_COATING_QTY2
        ,NULL AS YIELD_LOSS_QTY
        ,NULL AS EQUIPMENT_ID
        ,NULL AS FP_PRODUCTION_TYPE
        ,NULL AS ROLL_IN_QTY
        ,NULL AS ROLL_OUT_QTY
        ,NULL AS JR_IN_QTY
        ,NULL AS JR_OUT_QTY
        ,NULL AS BATCH_IN_QTY
        ,NULL AS BATCH_OUT_QTY
        ,NULL AS CELL_IN_QTY
        ,NULL AS CELL_OUT_QTY
    FROM   SCM_DNM_PACKER_PROD_RESULT A WITH(NOLOCK)
    JOIN   SCM_MST_ITEM_SN B WITH(NOLOCK)
    ON     A.COMPANY_ID  = B.COMPANY_ID
    AND    A.DIVISION_ID = B.DIVISION_ID
    AND    A.SITE_ID     = B.SITE_ID
    AND    A.ITEM_ID     = B.ITEM_ID
    WHERE  B.SCP_OPERATION_GROUP IS NOT NULL
    */ -- 주석 END
) PR
LEFT JOIN SCM_MGR.SCP_MST_FINAL_ITEM FI  --2018.06.29
    ON PR.DIVISION_ID = FI.DIVISION_ID
    AND PR.ITEM_ID    = FI.ITEM_ID;


-- SCM_MGR.SCM_MST_ALTER_BOM_V source
