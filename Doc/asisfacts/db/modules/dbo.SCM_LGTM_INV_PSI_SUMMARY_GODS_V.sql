CREATE VIEW [dbo].[SCM_LGTM_INV_PSI_SUMMARY_GODS_V]
AS
/****************************************************************************
* PROJECT       : LGES SCM
* VIEW NAME     : SCM_LGTM_INV_PSI_SUMMARY_GODS_V
* DESCRIPTION   : 원재료 ITEM별 PSI
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE         IN CHARGE       DESCRIPTION
*--------------------------------------------------------------
* 2024.08.22    yangsh          Initial Release.
* 2024.10.18    Philsu Park     PLAN_TP_CD 구분을 위한 Lookup 처리 반영.
****************************************************************************/
/*WITH ITGR AS ( SELECT    PLAN_START_YYYYMMDD
                        ,GROUP_CODE1
                        ,ITEM_ID
                        ,SUM(QTY) QTY 
                FROM     SCM_LGTM_INV_PSI_SUMMARY WITH(NOLOCK)
                GROUP BY PLAN_START_YYYYMMDD
                        ,GROUP_CODE1
                        ,ITEM_ID)*/
WITH GROUP_CD AS ( SELECT     I.DIVISION_ID
                            , I.ITEM_ID
                            , MAX(CASE WHEN ISNULL(F1.GROUP_CODE1, '') != '' THEN F1.GROUP_CODE1
                                        WHEN ISNULL(F3.GROUP_CODE1, '') != '' THEN F3.GROUP_CODE1
                                        WHEN ISNULL(F2.GROUP_CODE1, '') != '' THEN F2.GROUP_CODE1
                                        WHEN ISNULL(I.DOE, '') = '' THEN ISNULL(I3.NICK_NAME, I.NICK_NAME)
                                        ELSE ISNULL(I2.NICK_NAME, I.NICK_NAME) END
                                        ) AS GROUP_CODE1
                            , MAX(CASE WHEN ISNULL(F1.GROUP_CODE9, '') != '' THEN F1.GROUP_CODE9
                                        WHEN ISNULL(F3.GROUP_CODE9, '') != '' THEN F3.GROUP_CODE9
                                        WHEN ISNULL(F2.GROUP_CODE9, '') != '' THEN F2.GROUP_CODE9
                                        WHEN ISNULL(I.DOE, '') = '' THEN ISNULL(I3.NICK_NAME, I.NICK_NAME)
                                        ELSE ISNULL(I2.NICK_NAME, I.NICK_NAME) END
                                        ) AS GROUP_CODE9
                    FROM    SCM_ITEM_M_SN I WITH(NOLOCK)
                    LEFT OUTER JOIN SCM_ITEM_M_SN I2 WITH(NOLOCK)
                    ON      I2.ITEM_ID      = CASE WHEN ISNULL(I.DOE, '') = '' THEN I.APPLIED_MODEL ELSE ISNULL(I.DOE, '') END
                    AND     I2.DIVISION_ID  = I.DIVISION_ID
                    LEFT OUTER JOIN SCM_ITEM_M_SN I3 WITH(NOLOCK)
                    ON      I3.ITEM_ID      = I2.DOE
                    AND     I3.DIVISION_ID  = I2.DIVISION_ID
                    LEFT OUTER JOIN SCP_MST_FINAL_ITEM F1 WITH(NOLOCK)
                    ON      F1.ITEM_ID      = I.ITEM_ID
                    AND     F1.DIVISION_ID  = I.DIVISION_ID
                    LEFT OUTER JOIN SCP_MST_FINAL_ITEM F2 WITH(NOLOCK)
                    ON      F2.ITEM_ID      = CASE WHEN ISNULL(I.DOE, '') = '' THEN I.APPLIED_MODEL ELSE ISNULL(I.DOE, '') END
                    AND     F2.DIVISION_ID  = I.DIVISION_ID
                    LEFT OUTER JOIN SCP_MST_FINAL_ITEM F3 WITH(NOLOCK)
                    ON      F3.ITEM_ID      = I2.DOE
                    AND     F3.DIVISION_ID  = I2.DIVISION_ID
                    WHERE   1=1
                    GROUP BY I.DIVISION_ID
                            , I.ITEM_ID )                         
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
      ,(SELECT  LK.ATTRIBUTE1
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
        WHERE   1=1
        AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
        AND     LK.VALID_YN     = 'Y'
        AND     LK.SEGMENT1     = 'SRCE_TP_CD'
        AND     LK.SEGMENT2     = SUM.DATA_TP_CD
        AND     LK.SEGMENT3     = SUM.SRCE_TP_CD )  AS SRCE_TP_CD
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
      --,SUM.GROUP_CODE1
      ,SUM.PROCESS_DETAIL                       AS GROUP_CODE1
      --,CASE WHEN ISNULL(LV.SEGMENT3,'') <> '' THEN 'Y' ELSE '' END AS EXCEPTION_MODEL
      --,LV.ATTRIBUTE1                                               AS EXCEPTION_DESC
      ,( --SELECT  CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN 'Y' ELSE '' END
        SELECT   CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN MAX(LV.ATTRIBUTE2) ELSE '' END
        FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        WHERE    1=1
        AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
        AND      LV.SEGMENT1     = SUM.PLAN_TP_CD
        AND      LV.SEGMENT2     = ISNULL(MD.ATTRIBUTE3,SUM.DIVISION_ID) 
        AND      (      (SELECT TOP 1 IIF(SUM.DIVISION_ID='40', GR2.GROUP_CODE9, GR2.GROUP_CODE1) AS GROUP_CODE1
                         FROM   SCM_MST_BOM_EFFECTIVE_SN BOM2 WITH(NOLOCK)
                                LEFT OUTER JOIN GROUP_CD GR2 
                                ON   GR2.ITEM_ID             = BOM2.MODEL_ID
                                AND  GR2.DIVISION_ID         = SUM.DIVISION_ID
                         WHERE  1=1
                         AND    BOM2.DIVISION_ID   = SUM.DIVISION_ID
                         AND    BOM2.CHILD_ITEM_ID = SUM.ITEM_ID) = LV.SEGMENT4
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
                AND      (      (SELECT TOP 1 IIF(SUM.DIVISION_ID='40', GR2.GROUP_CODE9, GR2.GROUP_CODE1) AS GROUP_CODE1
                                FROM   SCM_MST_BOM_EFFECTIVE_SN BOM2 WITH(NOLOCK)
                                        LEFT OUTER JOIN GROUP_CD GR2 
                                        ON   GR2.ITEM_ID             = BOM2.MODEL_ID
                                        AND  GR2.DIVISION_ID         = SUM.DIVISION_ID
                                WHERE  1=1
                                AND    BOM2.DIVISION_ID   = SUM.DIVISION_ID
                                AND    BOM2.CHILD_ITEM_ID = SUM.ITEM_ID) = LV.SEGMENT4
                        OR SUM.ITEM_ID     = LV.SEGMENT4
                        OR SUM.SRCE_TP_CD  = LV.SEGMENT4
                        )
                FOR  XML PATH('')
                ) , 1, 1, '' )                     AS EXCEPTION_DESC  
      ,SUM.ITEM_ID
      ,SIM.ITEM_NAME
      ,SUM.ORIGIN_ITEM_ID
      ,'-'                                      AS ITEM_CLASS
      ,'-'                                      AS CLASS_NAME
      ,SUM.SRCE_YYYYMM
      ,SUM.PLAN_YYYYMM
      ,SUM.QTY
      ,SUM.CURRENCY
      ,SUM.STANDARD_COST
      ,SUM.AMT
      ,ISNULL(SUM.SCM_SITE_ID, '-')             AS SCM_SITE_ID
      ,ISNULL(SUM.OPERATION_GROUP, '-')         AS OPERATION_GROUP
      ,ISNULL(SUM.OPERATION_ID, '-')            AS OPERATION_ID
      ,REPLACE(SUM.DEVALUATION_AGE,'GRM','')+N'개월'     AS DEVALUATION_AGE
      ,SUM.LONG_TERM_TYPE_CODE
      ,CASE WHEN SUM.LONG_TERM_TYPE = N'비대상' THEN  N'정상' ELSE SUM.LONG_TERM_TYPE  END AS LONG_TERM_TYPE 
      ,ISNULL(SUM.VERSION_NO, '-')              AS VERSION_NO
      ,ISNULL(SUM.CST_CTN, '-')                 AS CST_CTN
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
      /*,STUFF((  SELECT  DISTINCT ','+ A.END_CUSTOMER
                FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
                WHERE   DIVISION_ID = SUM.DIVISION_ID
                AND     ITEM_ID     = SUM.ITEM_ID
                FOR  XML PATH('')
            ) , 1, 1, '' )                      AS END_CUSTOMER*/
      /*,(SELECT TOP 1 GR.GROUP_CODE1
        FROM   SCM_MST_BOM_SN BOM WITH(NOLOCK)
            LEFT OUTER JOIN ITGR GR 
            ON   GR.ITEM_ID             = BOM.MODEL_ID
            AND  GR.PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
        WHERE  1=1
        AND    BOM.CHILD_ITEM_ID = SUM.ITEM_ID
        ORDER BY ISNULL(GR.QTY,0) DESC)         AS END_CUSTOMER*/
      ,(SELECT  TOP 1
                IIF(SUM.DIVISION_ID='40', GR2.GROUP_CODE9, GR2.GROUP_CODE1) AS GROUP_CODE1
        FROM    SCM_MST_BOM_EFFECTIVE_SN BOM2 WITH(NOLOCK)
        LEFT OUTER JOIN GROUP_CD GR2 
        ON   GR2.ITEM_ID            = BOM2.MODEL_ID
        AND  GR2.DIVISION_ID        = SUM.DIVISION_ID
        WHERE   1=1
        AND     BOM2.DIVISION_ID   = SUM.DIVISION_ID
        AND     BOM2.CHILD_ITEM_ID = SUM.ITEM_ID) AS END_CUSTOMER        
      ,SUM.PROCESS_GROUP                        AS PROCESS_GROUP
      ,SUM.PROCESS_DETAIL                       AS PROCESS_DETAIL           
  FROM  SCM_LGTM_INV_PSI_SUMMARY_GODS SUM WITH(NOLOCK)
        LEFT OUTER JOIN SCM_MST_DIVISION MD WITH(NOLOCK)
            ON MD.DIVISION_ID = SUM.DIVISION_ID
        LEFT OUTER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS, MAX(ITEM_NAME) AS ITEM_NAME
                          FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                          GROUP BY DIVISION_ID, ITEM_ID ) SIM
            ON  SIM.DIVISION_ID = SUM.DIVISION_ID
            AND SIM.ITEM_ID     = SUM.ITEM_ID
        --LEFT OUTER JOIN  SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
        --    ON     SUM.DIVISION_ID = LV.SEGMENT2
            /*AND    LV.SEGMENT3     =   (SELECT TOP 1 GR.GROUP_CODE1
                                        FROM   SCM_MST_BOM_SN BOM WITH(NOLOCK)
                                            LEFT OUTER JOIN ITGR GR 
                                            ON   GR.ITEM_ID             = BOM.MODEL_ID
                                            AND  GR.PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
                                        WHERE  1=1
                                        AND    BOM.CHILD_ITEM_ID = SUM.ITEM_ID
                                        ORDER BY ISNULL(GR.QTY,0) DESC)*/ 
        --    AND    LV.SEGMENT3     =    (SELECT TOP 1 IIF(SUM.DIVISION_ID='40', GR2.GROUP_CODE9, GR2.GROUP_CODE1) AS GROUP_CODE1
        --                                FROM   SCM_MST_BOM_EFFECTIVE_SN BOM2 WITH(NOLOCK)
        --                                        LEFT OUTER JOIN GROUP_CD GR2 
        --                                        ON   GR2.ITEM_ID             = BOM2.MODEL_ID
        --                                       AND  GR2.DIVISION_ID         = SUM.DIVISION_ID
        --                                WHERE  1=1
        --                                AND    BOM2.DIVISION_ID   = SUM.DIVISION_ID
        --                                AND    BOM2.CHILD_ITEM_ID = SUM.ITEM_ID)                                        
        --    AND    LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE'
        --    AND    SEGMENT1    = SUM.PLAN_TP_CD
  WHERE 1=1