CREATE VIEW [dbo].[SCM_LGTM_INV_PSI_SUMMARY_RMTL_V]
AS
/****************************************************************************
* PROJECT       : LGES SCM
* VIEW NAME     : SCM_LGTM_INV_PSI_SUMMARY_RMTL_V
* DESCRIPTION   : 원재료 Plant, ITEM별 PSI / 원재료 ITEM GR별 PSI 조회
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE         IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2024.09.24    Philsu Park         Initial Release.
* 2024.10.18    Philsu Park         PLAN_TP_CD 구분을 위한 Lookup 처리 적용.
* 2025.01.21    OIJ                 예외모델 표기 기준 변경
****************************************************************************/
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
SELECT PLAN_TP_CD  
            ,PLAN_START_YYYYMMDD
            ,PLAN_START_YYYYWW
            ,DATA_TP_CD
            ,SRCE_TP_CD
            ,DIVISION_ID
            ,ORIGIN_DIVISION_ID
            ,GROUP_CODE1
            -- 2025.01.21    OIJ    
            ,CASE WHEN (    SELECT   CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN MAX(LV.ATTRIBUTE2) ELSE '' END
                            FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                            WHERE    1=1
                            AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
                            AND      LV.SEGMENT1     = RMTL.PLAN_TP_CD_CODE
                            AND      LV.SEGMENT2     = ISNULL(RMTL.MD_ATTR3,RMTL.DIVISION_ID)
                            AND      ( RMTL.END_CUSTOMER = LV.SEGMENT4
                                    OR RMTL.ITEM_ID     = LV.SEGMENT4
                                    OR RMTL.SRCE_TP_CD  = LV.SEGMENT4
                                    )
                            ) IS NULL AND EXHT_FLAG = 'Y' THEN 'Policy' 
                  ELSE ( SELECT   CASE WHEN ISNULL(MAX(LV.SEGMENT4),'') <> '' THEN MAX(LV.ATTRIBUTE2) ELSE '' END
                            FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                            WHERE    1=1
                            AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
                            AND      LV.SEGMENT1     = RMTL.PLAN_TP_CD_CODE
                            AND      LV.SEGMENT2     = ISNULL(RMTL.MD_ATTR3,RMTL.DIVISION_ID)
                            AND      ( RMTL.END_CUSTOMER = LV.SEGMENT4
                                    OR RMTL.ITEM_ID     = LV.SEGMENT4
                                    OR RMTL.SRCE_TP_CD  = LV.SEGMENT4
                                    ) )
                   END    AS EXCEPTION_MODEL 
        /*,STUFF(( SELECT    DISTINCT ','+ '(' + LV.SEGMENT3 + ')' + LV.ATTRIBUTE1
                FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                WHERE    1=1
                AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
                AND      LV.SEGMENT1     = RMTL.PLAN_TP_CD_CODE
                AND      LV.SEGMENT2     = ISNULL(RMTL.MD_ATTR3,RMTL.DIVISION_ID)
                AND      ( RMTL.END_CUSTOMER = LV.SEGMENT4
                        OR RMTL.ITEM_ID     = LV.SEGMENT4
                        OR RMTL.SRCE_TP_CD  = LV.SEGMENT4
                        )
                FOR  XML PATH('')
                ) , 1, 1, '' )                     AS EXCEPTION_DESC*/  
             -- 2025.01.21    OIJ   
            ,CASE WHEN (STUFF(( SELECT    DISTINCT ','+ '(' + LV.SEGMENT3 + ')' + LV.ATTRIBUTE1
                            FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                            WHERE    1=1
                            AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
                            AND      LV.SEGMENT1     = RMTL.PLAN_TP_CD_CODE
                            AND      LV.SEGMENT2     = ISNULL(RMTL.MD_ATTR3,RMTL.DIVISION_ID)
                            AND      ( RMTL.END_CUSTOMER = LV.SEGMENT4
                                    OR RMTL.ITEM_ID     = LV.SEGMENT4
                                    OR RMTL.SRCE_TP_CD  = LV.SEGMENT4
                                    )
                            FOR  XML PATH('')
                            ) , 1, 1, '' )  
                        ) IS NULL AND EXHT_FLAG = 'Y' THEN 'Policy Inv Plan' 
                  ELSE (STUFF(( SELECT    DISTINCT ','+ '(' + LV.SEGMENT3 + ')' + LV.ATTRIBUTE1
                            FROM     SCM_ADM_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                            WHERE    1=1
                            AND      LV.LOOKUP_TYPE = 'SCM_LGTM_EXCEPTION_GROUP_CODE_ALL'
                            AND      LV.SEGMENT1     = RMTL.PLAN_TP_CD_CODE
                            AND      LV.SEGMENT2     = ISNULL(RMTL.MD_ATTR3,RMTL.DIVISION_ID)
                            AND      ( RMTL.END_CUSTOMER = LV.SEGMENT4
                                    OR RMTL.ITEM_ID     = LV.SEGMENT4
                                    OR RMTL.SRCE_TP_CD  = LV.SEGMENT4
                                    )
                            FOR  XML PATH('')
                            ) , 1, 1, '' )  
                        )
                  END                   AS EXCEPTION_DESC    
            ,PLANT_ID
            ,ITEM_ID
            ,ITEM_NAME
            ,ORIGIN_ITEM_ID
            ,ITEM_CLASS
            ,CLASS_NAME
            ,SRCE_YYYYMM
            ,PLAN_YYYYMM
            ,QTY
            ,CURRENCY
            ,STANDARD_COST
            ,AMT
            ,SCM_SITE_ID
            ,OPERATION_GROUP
            ,OPERATION_ID
            ,DEVALUATION_AGE
            ,LONG_TERM_TYPE_CODE
            ,LONG_TERM_TYPE
            ,VERSION_NO
            ,CST_CTN
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
            ,UOM
            ,GROUP_CODE3
            ,GROUP_CODE8
            ,PLANT_CD
            ,EVAL_CLASS
            ,ITEM_CLASS_BY_ITEM
            ,ITEM_CLASS_NAME_BY_ITEM
            ,END_CUSTOMER
            ,PROCESS_GROUP
            ,PROCESS_DETAIL
            ,EXHT_FLAG
FROM (                                          
        SELECT --SUM.PLAN_TP_CD
            (SELECT  LK.ATTRIBUTE1
                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
                WHERE   1=1
                AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_REPORT'
                AND     LK.VALID_YN     = 'Y'
                AND     LK.SEGMENT1     = 'PLAN_TP_CD'
                AND     LK.SEGMENT2     = SUM.PLAN_TP_CD)                                 AS PLAN_TP_CD
            ,SUM.PLAN_TP_CD AS PLAN_TP_CD_CODE      
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
            ,SUM.PROCESS_DETAIL                       AS GROUP_CODE1
            ,'' AS EXCEPTION_MODEL
            ,''                     AS EXCEPTION_DESC  
            ,SUM.PLANT_ID
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
            ,MD.ATTRIBUTE3                            AS MD_ATTR3
            -- 2025.01.21    OIJ
            ,CASE WHEN (SUM(CASE WHEN SRCE_TP_CD = 'S_EXHT' THEN 1 ELSE 0 END )  OVER (PARTITION BY SUM.DIVISION_ID, SUM.PLANT_ID, SUM.ITEM_ID ) ) > 0 THEN 'Y' ELSE 'N' END AS EXHT_FLAG
        FROM  SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM WITH(NOLOCK)
                LEFT OUTER JOIN SCM_MST_DIVISION MD WITH(NOLOCK)
                    ON MD.DIVISION_ID = SUM.DIVISION_ID
                LEFT OUTER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, MAX(ITEM_CLASS) AS ITEM_CLASS, MAX(ITEM_NAME) AS ITEM_NAME
                                FROM   SCM_ITEM_M_SN WITH(NOLOCK)
                                GROUP BY DIVISION_ID, ITEM_ID ) SIM
                    ON  SIM.DIVISION_ID = SUM.DIVISION_ID
                    AND SIM.ITEM_ID     = SUM.ITEM_ID
        WHERE 1=1
) RMTL
