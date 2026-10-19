CREATE VIEW [dbo].[SCM_LGTM_INV_PSI_SUMMARY_SPRD_V]
AS
/****************************************************************************
* PROJECT       : LGES SCM
* VIEW NAME     : SCM_LGTM_INV_PSI_SUMMARY_V
* DESCRIPTION   : 완제품 ITEM별 PSI / 완제품 ITEM GR별 PSI 조회
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE         IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2024.07.31    yangsh              Initial Release.
* 2024.10.18    Philsu Park         PLAN_TP_CD 룩업 적용.
****************************************************************************/
SELECT --SUM.PLAN_TP_CD
       (SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'PLAN_TP_CD'
        AND     LK.SEGMENT2     = SUM.PLAN_TP_CD)                                 AS PLAN_TP_CD   
      ,SUM.PLAN_START_YYYYMMDD
      ,(SELECT CALENDAR_YYYY+WEEK_NAME
        FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
        WHERE  BASIS_YYYYMMDD = SUM.PLAN_START_YYYYMMDD ) AS PLAN_START_YYYYWW
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'DATA_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD) AS DATA_TP_CD
      ,(SELECT  CASE  WHEN SUM.SRCE_TP_CD = 'BOH_SPRD' AND CLS.PROCESS_GROUP = N'전극'   THEN N'수요<재고(전극)'
                      WHEN SUM.SRCE_TP_CD = 'BOH_SPRD' AND CLS.PROCESS_GROUP = N'조립'   THEN N'수요<재고(조립)'
                      ELSE LK.ATTRIBUTE1 END 
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'SRCE_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD
        AND     LK.SEGMENT3     = SUM.SRCE_TP_CD ) AS SRCE_TP_CD
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'DIVISION_ID'
        AND     LK.SEGMENT2     = SUM.DIVISION_ID ) AS DIVISION_ID
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'ORIGIN_DIVISION_ID'
        AND     LK.SEGMENT2     = ISNULL(MD.ATTRIBUTE3,SUM.DIVISION_ID) ) AS ORIGIN_DIVISION_ID
      ,SUM.GROUP_CODE1
      --,CASE WHEN ISNULL(LV.SEGMENT3,'') <> '' THEN 'Y' ELSE '' END AS EXCEPTION_MODEL
      --,LV.ATTRIBUTE1                                               AS EXCEPTION_DESC
      ,( --SELECT  CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN 'Y' ELSE '' END
        SELECT   CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN MAX(LV.ATTRIBUTE2) ELSE '' END   
        FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        WHERE    1=1
        AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
        AND      LV.SEGMENT1     = SUM.PLAN_TP_CD
        AND      LV.SEGMENT2     = ISNULL(MD.ATTRIBUTE3,SUM.DIVISION_ID)
        AND      (    SUM.GROUP_CODE1 = LV.SEGMENT4
                   OR SUM.ITEM_ID     = LV.SEGMENT4
                   OR SUM.SRCE_TP_CD  = LV.SEGMENT4
                 )
        ) AS EXCEPTION_MODEL
      ,STUFF(( SELECT    DISTINCT ','+ '(' + LV.SEGMENT3 + ')' + LV.ATTRIBUTE1 
                FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                WHERE    1=1
                AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
                AND      LV.SEGMENT1     = SUM.PLAN_TP_CD
                AND      LV.SEGMENT2     = ISNULL(MD.ATTRIBUTE3,SUM.DIVISION_ID)
                AND      (    SUM.GROUP_CODE1 = LV.SEGMENT4
                        OR SUM.ITEM_ID     = LV.SEGMENT4
                        OR SUM.SRCE_TP_CD  = LV.SEGMENT4
                        )
                FOR  XML PATH('')
                ) , 1, 1, '' )                     AS EXCEPTION_DESC  
      ,SUM.ITEM_ID
      ,SIM.ITEM_NAME
      ,SUM.ORIGIN_ITEM_ID
      ,'-'                                       AS ITEM_CLASS
      ,'-'                                       AS CLASS_NAME
      ,SUM.SRCE_YYYYMM
      ,SUM.PLAN_YYYYMM
      ,SUM.QTY
      ,SUM.CURRENCY
      ,SUM.STANDARD_COST
      ,SUM.AMT
      ,ISNULL(SUM.SCM_SITE_ID, '-')         AS SCM_SITE_ID
      ,ISNULL(SUM.OPERATION_GROUP, '-')     AS OPERATION_GROUP
      ,ISNULL(SUM.OPERATION_ID, '-')        AS OPERATION_ID
      ,REPLACE(SUM.DEVALUATION_AGE,'GRM','')+N'개월' AS DEVALUATION_AGE
      ,SUM.LONG_TERM_TYPE_CODE
      ,CASE WHEN SUM.LONG_TERM_TYPE = N'비대상' THEN  N'정상' ELSE SUM.LONG_TERM_TYPE  END AS LONG_TERM_TYPE 
      ,ISNULL(SUM.VERSION_NO, '-')          AS VERSION_NO
      ,ISNULL(SUM.CST_CTN, '-')             AS CST_CTN
      ,SUM.CREATED_BY
      ,SUM.CREATION_DATE
      ,SUM.LAST_UPDATED_BY
      ,SUM.LAST_UPDATE_DATE
      ,STUFF((  SELECT  DISTINCT ','+ ITEM_UOM
                FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS UOM
      ,STUFF((  SELECT  DISTINCT ','+ GROUP_CODE3
                FROM    SCP_MST_FINAL_ITEM WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID     = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS GROUP_CODE3
      ,STUFF((  SELECT  DISTINCT ','+ GROUP_CODE8
                FROM    SCP_MST_FINAL_ITEM WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID     = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS GROUP_CODE8
      ,STUFF((  SELECT  DISTINCT ','+ SITE_ID
                FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS PLANT_CD
      ,STUFF((  SELECT  DISTINCT ','+ EVAL_CLASS
                FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS EVAL_CLASS
      ,STUFF((  SELECT  DISTINCT ','+ ITEM_CLASS
                FROM    SCM_ITEM_M_SN WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS ITEM_CLASS_BY_ITEM
      ,STUFF((  SELECT  DISTINCT ','+ D.CLASS_NAME
                FROM    SCM_ITEM_M_SN A WITH(NOLOCK)
                        LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK)
                        ON A.ITEM_CLASS = D.CLASS_ID
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS ITEM_CLASS_NAME_BY_ITEM
      ,STUFF((  SELECT  DISTINCT ','+ A.END_CUSTOMER
                FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID     = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS END_CUSTOMER 
      ,CLS.PROCESS_GROUP                        AS PROCESS_GROUP
      ,CLS.PROCESS_DETAIL                       AS PROCESS_DETAIL
      ,CASE WHEN (SUM(CASE WHEN SRCE_TP_CD = 'S_EXHT' THEN 1 ELSE 0 END )  OVER (PARTITION BY SUM.DIVISION_ID) ) > 0 THEN 'Y' ELSE 'N' END AS EXHT_FLAG
  FROM  SCM_LGTM_INV_PSI_SUMMARY_SPRD SUM
        LEFT OUTER JOIN SCM_MST_DIVISION MD WITH(NOLOCK)
            ON MD.DIVISION_ID = SUM.DIVISION_ID
        --LEFT OUTER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, ITEM_CLASS
        --                FROM   SCM_ITEM_M_SN WITH(NOLOCK) ) SIM
        LEFT OUTER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS, MAX(ITEM_NAME) AS ITEM_NAME
                          FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                          GROUP BY DIVISION_ID, ITEM_ID ) SIM
            ON  SIM.DIVISION_ID = SUM.DIVISION_ID
            AND SIM.ITEM_ID     = SUM.ITEM_ID
        LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
            ON SIM.ITEM_CLASS = CLS.CLASS_ID    
        --LEFT OUTER JOIN  SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        --    ON     SUM.DIVISION_ID = LV.SEGMENT2
        --    AND    SUM.GROUP_CODE1 = LV.SEGMENT3
        --    AND    LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE'
        --    AND    SEGMENT1    = SUM.PLAN_TP_CD
  WHERE 1=1
  ----------------------------------------------------------------------
  UNION ALL
  ----------------------------------------------------------------------
  SELECT --SUM2.PLAN_TP_CD
         (SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'PLAN_TP_CD'
        AND     LK.SEGMENT2     = SUM2.PLAN_TP_CD)                                 AS PLAN_TP_CD  
        ,SUM2.PLAN_START_YYYYMMDD
       ,(SELECT CALENDAR_YYYY+WEEK_NAME
         FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
         WHERE  BASIS_YYYYMMDD = SUM2.PLAN_START_YYYYMMDD ) AS PLAN_START_YYYYWW
       ,(SELECT  LK.ATTRIBUTE1
         FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
         WHERE   1=1
         AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
         AND     LK.VALID_YN     = 'Y'
         AND     LK.SEGMENT1     = 'DATA_TP_CD'
         AND     LK.SEGMENT2     = SUM2.DATA_TP_CD)          AS DATA_TP_CD
       ,(SELECT  CASE WHEN SUM2.SRCE_TP_CD = 'BOH_SPRD' AND SUM2.ITEM_CLASS = 'ELTR'   THEN N'수요<재고(전극)'
                      WHEN SUM2.SRCE_TP_CD = 'BOH_SPRD' AND SUM2.ITEM_CLASS = '*'      THEN N'수요<재고(조립)'
                      ELSE LK.ATTRIBUTE1 END 
         FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
         WHERE   1=1
         AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
         AND     LK.VALID_YN     = 'Y'
         AND     LK.SEGMENT1     = 'SRCE_TP_CD'
         AND     LK.SEGMENT2     = SUM2.DATA_TP_CD
         AND     LK.SEGMENT3     = SUM2.SRCE_TP_CD )         AS SRCE_TP_CD
       ,(SELECT  LK.ATTRIBUTE1
         FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
         WHERE   1=1
         AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
         AND     LK.VALID_YN     = 'Y'
         AND     LK.SEGMENT1     = 'DIVISION_ID'
         AND     LK.SEGMENT2     = SUM2.DIVISION_ID )       AS DIVISION_ID
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'ORIGIN_DIVISION_ID'
        AND     LK.SEGMENT2     = ISNULL(MD2.ATTRIBUTE3,SUM2.DIVISION_ID)) AS ORIGIN_DIVISION_ID
        ,SUM2.GROUP_CODE1
      --,CASE WHEN ISNULL(LV.SEGMENT3,'') <> '' THEN 'Y' ELSE '' END AS EXCEPTION_MODEL
      --,LV.ATTRIBUTE1                                               AS EXCEPTION_DESC
      ,( --SELECT  CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN 'Y' ELSE '' END
        SELECT   CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN MAX(LV.ATTRIBUTE2) ELSE '' END
        FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        WHERE    1=1
        AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
        AND      LV.SEGMENT1     = SUM2.PLAN_TP_CD
        AND      LV.SEGMENT2     = ISNULL(MD2.ATTRIBUTE3,SUM2.DIVISION_ID)
        AND      (    SUM2.GROUP_CODE1 = LV.SEGMENT4
                   OR SUM2.SRCE_TP_CD  = LV.SEGMENT4
                 )
        ) AS EXCEPTION_MODEL
      ,STUFF(( SELECT    DISTINCT ','+ '(' + LV.SEGMENT3 + ')' + LV.ATTRIBUTE1 
                FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                WHERE    1=1
                AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
                AND      LV.SEGMENT1     = SUM2.PLAN_TP_CD
                AND      LV.SEGMENT2     = ISNULL(MD2.ATTRIBUTE3,SUM2.DIVISION_ID)
                AND      (    SUM2.GROUP_CODE1 = LV.SEGMENT4
                        OR    SUM2.SRCE_TP_CD  = LV.SEGMENT4
                        )
                FOR  XML PATH('')
                ) , 1, 1, '' )                     AS EXCEPTION_DESC  
        ,''                                                 AS ITEM_ID
        ,''                                                 AS ITEM_NAME
        ,''                                                 AS ORIGIN_ITEM_ID
        ,SUM2.ITEM_CLASS
        ,CASE WHEN SUM2.CLASS_NAME = 'ELTR' THEN N'전극' ELSE SUM2.CLASS_NAME END AS CLASS_NAME
        ,SUM2.SRCE_YYYYMM
        ,SUM2.PLAN_YYYYMM
        ,SUM2.QTY
        ,SUM2.CURRENCY
        ,SUM2.STANDARD_COST
        ,SUM2.AMT
        ,'-'                                                AS SCM_SITE_ID
        ,'-'                                                AS OPERATION_GROUP
        ,'-'                                                AS OPERATION_ID
        ,REPLACE(SUM2.DEVALUATION_AGE,'GRM','')+N'개월'     AS DEVALUATION_AGE
        ,SUM2.LONG_TERM_TYPE_CODE
        ,CASE WHEN SUM2.LONG_TERM_TYPE = N'비대상' THEN  N'정상' ELSE SUM2.LONG_TERM_TYPE  END AS LONG_TERM_TYPE 
        ,'-'                                                AS VERSION_NO
        ,'-'                                                AS CST_CTN
        ,SUM2.CREATED_BY
        ,SUM2.CREATION_DATE
        ,SUM2.LAST_UPDATED_BY
        ,SUM2.LAST_UPDATE_DATE
        ,'-'                                                AS UOM
        ,'-'                                                AS GROUP_CODE3
        ,'-'                                                AS GROUP_CODE8
        ,'-'                                                AS PLANT_CD
        ,'-'                                                AS EVAL_CLASS
        ,'-'                                                AS ITEM_CLASS_BY_ITEM
        ,'-'                                                AS ITEM_CLASS_NMAME_BY_ITEM
        ,'-'                                                AS END_CUSTOMER
        ,CLS.PROCESS_GROUP                                  AS PROCESS_GROUP
        ,CLS.PROCESS_DETAIL                                 AS PROCESS_DETAIL
      ,CASE WHEN (SUM(CASE WHEN SRCE_TP_CD = 'S_EXHT' THEN 1 ELSE 0 END )  OVER (PARTITION BY SUM2.DIVISION_ID) ) > 0 THEN 'Y' ELSE 'N' END AS EXHT_FLAG     
  FROM SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR SUM2
        LEFT OUTER JOIN SCM_MST_DIVISION MD2 WITH(NOLOCK)
            ON MD2.DIVISION_ID = SUM2.DIVISION_ID
        LEFT OUTER JOIN SCM_MST_ITEM_CLASS_M CLS WITH(NOLOCK)
            ON SUM2.ITEM_CLASS = CLS.CLASS_ID    
        --LEFT OUTER JOIN  SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        --    ON     SUM2.DIVISION_ID = LV.SEGMENT2
        --    AND    SUM2.GROUP_CODE1 = LV.SEGMENT3
        --    AND    LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE'
        --    AND    SEGMENT1    = SUM2.PLAN_TP_CD
  WHERE 1=1
