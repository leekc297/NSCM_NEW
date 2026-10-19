
CREATE VIEW [dbo].[SCM_LGTM_MGMT_DETAIL_FOR_EXPORT_V]
AS
/****************************************************************************
* PROJECT       : LGES SCM
* VIEW NAME     : SCM_LGTM_MGMT_DETAIL_FOR_EXPORT_V
* DESCRIPTION   : SCPF0113 Long Term Stock Mgmt
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE        IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2025.01.15    yangsh         Initial Release.
****************************************************************************/
------------------------------------------------------------------------------
-- 완제품
------------------------------------------------------------------------------
SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
      ,SUM.DIVISION_ID                              AS DIV
      ,SUM.ORIGIN_DIVISION_ID                       AS ORIGIN_DIV
	  ,SUM.COMPANY_ID								AS COMPANY_ID
      ,'*'                                          AS PLANT_ID
      ,N'완제품'                                     AS PLAN_TYPE
      ,SUM.GROUP_CODE1                              AS GROUP_CODE
      ,SUM.ITEM_ID                                  AS MATERIAL
      ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
      ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
            WHEN SUM.DATA_TP_CD = 'P'   THEN 2
            WHEN SUM.DATA_TP_CD = 'S'   THEN 3
            WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'DATA_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'SRCE_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD
        AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
      ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
       ELSE '-' END AS LONG_TERM_TYPE
      ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
      ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
      ,SUM(SUM.QTY)                                 AS QTY 
      ,MAX(SUM.STANDARD_COST)                       AS PRICE
      ,SUM(SUM.AMT)                                 AS AMT 
FROM  SCM_LGTM_INV_PSI_SUMMARY SUM
WHERE 1=1
AND   DATA_TP_CD     <> 'RESULT'
AND   SUM.PLAN_TP_CD  = 'FERT_INIT'
GROUP BY SUM.PLAN_START_YYYYMMDD
      ,SUM.DIVISION_ID
      ,SUM.ORIGIN_DIVISION_ID
	  ,SUM.COMPANY_ID
      ,SUM.GROUP_CODE1
      ,SUM.ITEM_ID
      ,SUM.ORIGIN_ITEM_ID
      ,SUM.DATA_TP_CD
      ,SUM.SRCE_TP_CD
      ,SUM.LONG_TERM_TYPE 
      ,SUM.SRCE_YYYYMM
      ,SUM.PLAN_YYYYMM
------------------------------------------------------------------------------
UNION ALL
------------------------------------------------------------------------------
-- 반제품
------------------------------------------------------------------------------
SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
      ,SUM.DIVISION_ID                              AS DIV
      ,SUM.DIVISION_ID                               AS ORIGIN_DIV
	  ,SUM.COMPANY_ID								AS COMPANY_ID
      ,'*'                                          AS PLANT_ID
      ,N'반제품'                                     AS PLAN_TYPE
      ,SUM.GROUP_CODE1                              AS GROUP_CODE
      ,SUM.ITEM_ID                                  AS MATERIAL
      ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
      ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
            WHEN SUM.DATA_TP_CD = 'P'   THEN 2
            WHEN SUM.DATA_TP_CD = 'S'   THEN 3
            WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'DATA_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'SRCE_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD
        AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
      ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
       ELSE '-' END AS LONG_TERM_TYPE
      ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
      ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
      ,SUM(SUM.QTY)                                 AS QTY 
      ,MAX(SUM.STANDARD_COST)                       AS PRICE
      ,SUM(SUM.AMT)                                 AS AMT 
FROM  SCM_LGTM_INV_PSI_SUMMARY_SPRD SUM
WHERE 1=1
AND   DATA_TP_CD      <> 'RESULT'
AND   SUM.PLAN_TP_CD  = 'SPRD_INIT'
GROUP BY SUM.PLAN_START_YYYYMMDD
      ,SUM.DIVISION_ID
      ,SUM.DIVISION_ID
	  ,SUM.COMPANY_ID
      ,SUM.GROUP_CODE1
      ,SUM.ITEM_ID
      ,SUM.ORIGIN_ITEM_ID
      ,SUM.DATA_TP_CD
      ,SUM.SRCE_TP_CD
      ,SUM.LONG_TERM_TYPE 
      ,SUM.SRCE_YYYYMM
      ,SUM.PLAN_YYYYMM
------------------------------------------------------------------------------
UNION ALL
------------------------------------------------------------------------------
-- 원재료
------------------------------------------------------------------------------
SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
      ,SUM.DIVISION_ID                              AS DIV
      ,SUM.DIVISION_ID                               AS ORIGIN_DIV
	  ,SUM.COMPANY_ID								AS COMPANY_ID
      ,PLANT_ID                                      AS PLANT_ID
      ,N'원재료'                                     AS PLAN_TYPE
      ,SUM.GROUP_CODE1                              AS GROUP_CODE
      ,SUM.ITEM_ID                                  AS MATERIAL
      ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
      ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
            WHEN SUM.DATA_TP_CD = 'P'   THEN 2
            WHEN SUM.DATA_TP_CD = 'S'   THEN 3
            WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'DATA_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'SRCE_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD
        AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
      ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
       ELSE '-' END AS LONG_TERM_TYPE
      ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
      ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
      ,SUM(SUM.QTY)                                 AS QTY 
      ,MAX(SUM.STANDARD_COST)                       AS PRICE
      ,SUM(SUM.AMT)                                 AS AMT 
FROM  SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM
WHERE 1=1
AND   DATA_TP_CD      <> 'RESULT'
AND   SUM.PLAN_TP_CD  = 'RMTL_INIT'
GROUP BY SUM.PLAN_START_YYYYMMDD
      ,SUM.DIVISION_ID
      ,SUM.DIVISION_ID
	  ,SUM.COMPANY_ID
      ,SUM.PLANT_ID
      ,SUM.GROUP_CODE1
      ,SUM.ITEM_ID
      ,SUM.ORIGIN_ITEM_ID
      ,SUM.DATA_TP_CD
      ,SUM.SRCE_TP_CD
      ,SUM.LONG_TERM_TYPE 
      ,SUM.SRCE_YYYYMM
      ,SUM.PLAN_YYYYMM      

------------------------------------------------------------------------------
UNION ALL
------------------------------------------------------------------------------
-- 상품
------------------------------------------------------------------------------
SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
      ,SUM.DIVISION_ID                              AS DIV
      ,SUM.DIVISION_ID                               AS ORIGIN_DIV
	  ,SUM.COMPANY_ID								AS COMPANY_ID
      ,'*'                                          AS PLANT_ID
      ,N'상품'                                     AS PLAN_TYPE
      ,SUM.GROUP_CODE1                              AS GROUP_CODE
      ,SUM.ITEM_ID                                  AS MATERIAL
      ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
      ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
            WHEN SUM.DATA_TP_CD = 'P'   THEN 2
            WHEN SUM.DATA_TP_CD = 'S'   THEN 3
            WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'DATA_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'SRCE_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD
        AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
      ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
       ELSE '-' END AS LONG_TERM_TYPE
      ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
      ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
      ,SUM(SUM.QTY)                                 AS QTY 
      ,MAX(SUM.STANDARD_COST)                       AS PRICE
      ,SUM(SUM.AMT)                                 AS AMT 
FROM  SCM_LGTM_INV_PSI_SUMMARY_GODS SUM
WHERE 1=1
AND   DATA_TP_CD      <> 'RESULT'
AND   SUM.PLAN_TP_CD  = 'GODS_INIT'
GROUP BY SUM.PLAN_START_YYYYMMDD
      ,SUM.DIVISION_ID
      ,SUM.DIVISION_ID
	  ,SUM.COMPANY_ID
      ,SUM.GROUP_CODE1
      ,SUM.ITEM_ID
      ,SUM.ORIGIN_ITEM_ID
      ,SUM.DATA_TP_CD
      ,SUM.SRCE_TP_CD
      ,SUM.LONG_TERM_TYPE 
      ,SUM.SRCE_YYYYMM
      ,SUM.PLAN_YYYYMM            
