

CREATE VIEW [dbo].[SCM_LGTM_MGMT_V2]
AS
/****************************************************************************
* PROJECT       : LGES SCM
* VIEW NAME     : SCM_LGTM_MGMT_V
* DESCRIPTION   : SCPF0113 Long Term Stock Mgmt
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE        IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2024.09.09   yangsh         Initial Release.
****************************************************************************/



WITH GROUP_CD AS ( SELECT     I.DIVISION_ID
                            , I.ITEM_ID
                            , MAX(CASE WHEN ISNULL(F1.GROUP_CODE1, '') != '' THEN F1.GROUP_CODE1
                                        WHEN ISNULL(F3.GROUP_CODE1, '') != '' THEN F3.GROUP_CODE1
                                        WHEN ISNULL(F2.GROUP_CODE1, '') != '' THEN F2.GROUP_CODE1
                                        WHEN ISNULL(I.DOE, '') = '' THEN ISNULL(I3.NICK_NAME, I.NICK_NAME)
                                        ELSE ISNULL(I2.NICK_NAME, I.NICK_NAME) END
                                        ) AS GROUP_CODE1
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
    , BASE     AS ( SELECT PLAN_START_YYYYMMDD--, MIN(PLAN_YYYYMM) BASE_YYYYMM
                        ,SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, CONVERT(DATETIME, CONCAT(MIN(PLAN_YYYYMM) , '01'))),112),1,6)  AS BASE_YYYYMM
                        ,MAX(PLAN_YYYYMM) AS LAST_YYYYMM
                   FROM   SCM_LGTM_INV_PSI_SUMMARY WITH(NOLOCK)
                   WHERE  DATA_TP_CD = 'BOH'
                   GROUP BY PLAN_START_YYYYMMDD )
    , RTF    AS ( SELECT PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID,  '-' AS PLANT_ID, DATA_TP_CD, PLAN_YYYYMM, SUM(QTY) AS QTY
					  FROM   SCM_LGTM_INV_PSI_SUMMARY WITH(NOLOCK)
					 WHERE  DATA_TP_CD          = 'S'
					GROUP BY PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID, DATA_TP_CD, PLAN_YYYYMM 
					UNION ALL
					SELECT PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID,  '-' AS PLANT_ID, '-' AS DATA_TP_CD, PLAN_YYYYMM, SUM(QTY) AS QTY
					  FROM SCM_LGTM_INV_PSI_SUMMARY_SPRD WITH(NOLOCK)
					 WHERE DATA_TP_CD          = 'S'
					GROUP BY PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID, PLAN_YYYYMM 
					UNION ALL
					SELECT PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID, PLANT_ID, '-' AS DATA_TP_CD, PLAN_YYYYMM, SUM(QTY) AS QTY
					  FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL WITH(NOLOCK)
					 WHERE DATA_TP_CD          = 'S'
					GROUP BY PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, PLANT_ID, ITEM_ID, PLAN_YYYYMM 
					UNION ALL
					SELECT PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID, '-' AS PLANT_ID, '-' AS DATA_TP_CD, PLAN_YYYYMM, SUM(QTY) AS QTY
					  FROM SCM_LGTM_INV_PSI_SUMMARY_GODS WITH(NOLOCK)
					 WHERE DATA_TP_CD          = 'S'
					GROUP BY PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID, PLAN_YYYYMM  ) 
	, TTTT AS ( SELECT PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID, 
			          CASE WHEN SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) = (SELECT BAS.LAST_YYYYMM FROM BASE AS BAS WHERE BAS.PLAN_START_YYYYMMDD = SSS.PLAN_START_YYYYMMDD )
                          THEN ''
                     ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) END AS MIN_EXHT_YYYYMM
         FROM   SCM_LGTM_INV_PSI_SUMMARY SSS WITH(NOLOCK)
         WHERE  1=1
         AND    DATA_TP_CD          <> 'RESULT'
         AND    DATA_TP_CD          = 'EOH'
         AND    LONG_TERM_TYPE      IN ( N'부실 징후',N'부실' ) 
		 GROUP BY PLAN_START_YYYYMMDD, PLAN_TP_CD, DIVISION_ID, ITEM_ID)

------------------------------------------------------------------------------
-- 완제품
------------------------------------------------------------------------------
SELECT SUM.PLAN_START_YYYYMMDD                              AS PLAN_DATE
      ,SUM.PLAN_YYYYMM                                      AS END_MONTH
      ,SUM.DIVISION_ID                                      AS DIV
      ,'*'                                                  AS PLANT_ID
      ,SUBSTRING(SUM.PLAN_TP_CD,1,4)                        AS PLAN_TP_CD
      ,SUM.DATA_TP_CD                                       AS DATA_TP_CD
      ,SUM.SRCE_TP_CD                                       AS SRCE_TP_CD
      ,N'완제품'                                            AS ITEM_TYPE
      ,LK.ATTRIBUTE1                                        AS CREATION_TYPE
      ,SUM.GROUP_CODE1                                      AS GROUP_CODE
      ,FI.MKT_DEPT                                          AS MKT_DEPT
      ,FI.END_CUSTOMER                                      AS END_CUSTOMER
      ,SUM.ITEM_ID                                          AS ITEM_ID
      ,SIM.ITEM_NAME                                        AS ITEM_NAME
      ,SIM.UOM                                              AS UOM
      ,( SELECT SUM(QTY)
         FROM   RTF WITH(NOLOCK)
         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
         AND    DIVISION_ID         = SUM.DIVISION_ID
         AND    ITEM_ID             = SUM.ITEM_ID
         AND    DATA_TP_CD          = 'S'
         AND    PLAN_YYYYMM         <= SUM.PLAN_YYYYMM )    AS RTF
      ,MAX(SUM.STANDARD_COST)                               AS PRICE   
      ,SUM(SUM.AMT)                                         AS AMT
      --,SUM(QTY)                                             AS TOTAL
      ,ROUND(SUM(QTY),2)                                     AS TOTAL
      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실', QTY, 0))        AS LONG_TERM_QTY
      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실 징후', QTY, 0))    AS LONG_TERM_EXPECT_QTY
	  ,SUM(IIF(SUM.DEVALUATION_AGE = N'GRM03', QTY, 0))     AS LONG_TERM_EXPECT_QTY1
      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'비대상', QTY, 0))      AS NORMAL_QTY

      ,(SELECT BASE_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD ) AS BASE_YYYYMM
      ,NULL                                                  AS PIC
      ,( SELECT MIN_EXHT_YYYYMM
         FROM   TTTT WITH(NOLOCK)
         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
         AND    DIVISION_ID         = SUM.DIVISION_ID
         AND    ITEM_ID             = SUM.ITEM_ID) AS MIN_EXHT_YYYYMM
      ,( SELECT CASE WHEN SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) = (SELECT LAST_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD )
                          THEN ''
                     ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) END
         FROM   SCM_LGTM_INV_PSI_SUMMARY WITH(NOLOCK)
         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
         AND    DIVISION_ID         = SUM.DIVISION_ID
         AND    ITEM_ID             = SUM.ITEM_ID
         AND    DATA_TP_CD          <> 'RESULT'
         AND    DATA_TP_CD          = 'EOH'
         AND    LONG_TERM_TYPE      IN ( N'부실 징후',N'부실' ) ) AS MIN_EXHT_YYYYMM2
       --,NULL                                                     AS MIN_EXHT_YYYYMM  
FROM   SCM_LGTM_INV_PSI_SUMMARY SUM WITH(NOLOCK)
       LEFT OUTER JOIN SCP_MST_FINAL_ITEM  FI  WITH(NOLOCK)	 
            ON   FI.DIVISION_ID  = SUM.DIVISION_ID
            AND  FI.ITEM_ID      = SUM.ITEM_ID
       LEFT OUTER JOIN ( SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_UOM) AS UOM, MAX(ITEM_NAME) AS ITEM_NAME
                         FROM    SCM_ITEM_M_SN WITH(NOLOCK) 
                         GROUP BY DIVISION_ID, ITEM_ID 
                        ) SIM
            ON  SIM.DIVISION_ID = SUM.DIVISION_ID
            AND SIM.ITEM_ID     = SUM.ITEM_ID
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
            AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
            AND     LK.VALID_YN     = 'Y'
            AND     LK.SEGMENT1     = 'SRCE_TP_CD'
WHERE   1=1          
AND     SUM.DATA_TP_CD      = 'EOH'         
AND     SUM.LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
AND     SUM.PLAN_TP_CD      = 'FERT_INIT'
/*AND     EXISTS ( SELECT 'X'
                    FROM   SCM_LGTM_INV_PSI_SUMMARY_IGR IGR WITH(NOLOCK)
                    WHERE  IGR.PLAN_START_YYYYMMDD  = SUM.PLAN_START_YYYYMMDD
                    AND    IGR.PLAN_TP_CD           = 'FERT_INIT_GC'
                    AND    IGR.PLAN_YYYYMM          = SUM.PLAN_YYYYMM
                    AND    IGR.LONG_TERM_TYPE       IN (N'부실',N'부실 징후')
                    AND    IGR.PLAN_START_YYYYMMDD  = SUM.PLAN_START_YYYYMMDD
                    AND    IGR.DIVISION_ID          = SUM.DIVISION_ID
                    AND    IGR.GROUP_CODE1          = SUM.GROUP_CODE1
                )*/
AND      EXISTS ( SELECT 'X'
                    FROM   SCM_LGTM_INV_PSI_SUMMARY_IGR IGR WITH(NOLOCK)
                    WHERE  IGR.PLAN_START_YYYYMMDD  = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
                    AND    IGR.PLAN_TP_CD           = 'FERT_INIT_GC'
                    AND    IGR.PLAN_YYYYMM          = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.PLAN_YYYYMM ELSE IGR.PLAN_YYYYMM END
                    AND    IGR.LONG_TERM_TYPE       IN (N'부실',N'부실 징후')
                    AND    IGR.PLAN_START_YYYYMMDD  = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
                    AND    IGR.DIVISION_ID          = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.DIVISION_ID ELSE IGR.DIVISION_ID END
                    AND    IGR.GROUP_CODE1          = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.GROUP_CODE1 ELSE IGR.GROUP_CODE1 END
                )                
GROUP BY SUM.PLAN_START_YYYYMMDD
        ,SUM.PLAN_YYYYMM
        ,SUM.DIVISION_ID
        ,SUM.PLAN_TP_CD
        ,SUM.DATA_TP_CD
        ,SUM.SRCE_TP_CD
        ,LK.ATTRIBUTE1
        ,SUM.GROUP_CODE1
        ,FI.MKT_DEPT
        ,FI.END_CUSTOMER
        ,SUM.ITEM_ID
        ,SIM.ITEM_NAME
        ,SIM.UOM
----------------------------------------------------------------------------
--UNION ALL
--------------------------------------------------------------------------------
---- 반제품
--------------------------------------------------------------------------------
--SELECT SUM.PLAN_START_YYYYMMDD                              AS PLAN_DATE
--      ,SUM.PLAN_YYYYMM                                      AS END_MONTH
--      ,SUM.DIVISION_ID                                      AS DIV
--      ,'*'                                                  AS PLANT_ID
--      ,SUBSTRING(SUM.PLAN_TP_CD,1,4)                        AS PLAN_TP_CD
--      ,SUM.DATA_TP_CD                                       AS DATA_TP_CD
--      ,SUM.SRCE_TP_CD                                       AS SRCE_TP_CD
--      ,N'반제품'                                            AS ITEM_TYPE
--      ,LK.ATTRIBUTE2                                        AS CREATION_TYPE
--      ,SUM.GROUP_CODE1                                      AS GROUP_CODE
--      ,FI.MKT_DEPT                                          AS MKT_DEPT
--      ,FI.END_CUSTOMER                                      AS END_CUSTOMER
--      ,SUM.ITEM_ID                                          AS ITEM_ID
--      ,SIM.ITEM_NAME                                        AS ITEM_NAME
--      ,SIM.UOM                                              AS UOM
--      ,( SELECT SUM(QTY)
--         FROM   RTF_SPRD WITH(NOLOCK)
--         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
--         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
--         AND    DIVISION_ID         = SUM.DIVISION_ID
--         AND    ITEM_ID             = SUM.ITEM_ID
--         AND    DATA_TP_CD          = 'S'
--         AND    PLAN_YYYYMM         <= SUM.PLAN_YYYYMM )    AS RTF
--      ,MAX(SUM.STANDARD_COST)                               AS PRICE   
--      ,SUM(SUM.AMT)                                         AS AMT
--      --,SUM(QTY)                                             AS TOTAL
--      ,ROUND(SUM(QTY),2)                                     AS TOTAL
--      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실', QTY, 0))       AS LONG_TERM_QTY
--      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실 징후', QTY, 0))    AS LONG_TERM_EXPECT_QTY
--      ,(SELECT BASE_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD ) AS BASE_YYYYMM
--      ,NULL                                                   AS PIC
--      /*,( SELECT CASE WHEN SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) = (SELECT LAST_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD )
--                          THEN ''
--                     ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) END
--         FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD WITH(NOLOCK)
--         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
--         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
--         AND    DIVISION_ID         = SUM.DIVISION_ID
--         AND    ITEM_ID             = SUM.ITEM_ID
--         AND    DATA_TP_CD          <> 'RESULT'
--         AND    DATA_TP_CD          = 'EOH'
--         AND    LONG_TERM_TYPE      IN ( N'부실 징후',N'부실' ) ) AS MIN_EXHT_YYYYMM*/
--       ,NULL                                                     AS MIN_EXHT_YYYYMM  
--FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD SUM WITH(NOLOCK)
--       LEFT OUTER JOIN SCP_MST_FINAL_ITEM  FI  WITH(NOLOCK)	 
--            ON   FI.DIVISION_ID  = SUM.DIVISION_ID
--            AND  FI.ITEM_ID      = SUM.ITEM_ID
--       LEFT OUTER JOIN ( SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_UOM) AS UOM, MAX(ITEM_NAME) AS ITEM_NAME
--                         FROM    SCM_ITEM_M_SN WITH(NOLOCK) 
--                         GROUP BY DIVISION_ID, ITEM_ID 
--                        ) SIM
--            ON  SIM.DIVISION_ID = SUM.DIVISION_ID
--            AND SIM.ITEM_ID     = SUM.ITEM_ID
--        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
--            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
--            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
--            AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
--            AND     LK.VALID_YN     = 'Y'
--            AND     LK.SEGMENT1     = 'SRCE_TP_CD'
--WHERE   1=1          
--AND     SUM.DATA_TP_CD      = 'EOH'         
--AND     SUM.LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
--AND     SUM.PLAN_TP_CD      = 'SPRD_INIT'
--/*AND     EXISTS ( SELECT 'X'
--                    FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR IGR WITH(NOLOCK)
--                    WHERE  IGR.PLAN_START_YYYYMMDD  = SUM.PLAN_START_YYYYMMDD
--                    AND    IGR.PLAN_TP_CD           = 'SPRD_INIT_GC'
--                    AND    IGR.PLAN_YYYYMM          = SUM.PLAN_YYYYMM
--                    AND    IGR.LONG_TERM_TYPE       IN (N'부실',N'부실 징후')
--                    AND    IGR.PLAN_START_YYYYMMDD  = SUM.PLAN_START_YYYYMMDD
--                    AND    IGR.DIVISION_ID          = SUM.DIVISION_ID
--                    AND    IGR.GROUP_CODE1          = SUM.GROUP_CODE1
--                )*/
----AND      EXISTS ( SELECT 'X'
----                    FROM   SCM_LGTM_INV_PSI_SUMMARY_SPRD_IGR IGR WITH(NOLOCK)
----                    WHERE  IGR.PLAN_START_YYYYMMDD  = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
----                    AND    IGR.PLAN_TP_CD           = 'SPRD_INIT_GC'
----                    AND    IGR.PLAN_YYYYMM          = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.PLAN_YYYYMM ELSE IGR.PLAN_YYYYMM END
----                    AND    IGR.LONG_TERM_TYPE       IN (N'부실',N'부실 징후')
----                    AND    IGR.PLAN_START_YYYYMMDD  = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.PLAN_START_YYYYMMDD ELSE IGR.PLAN_START_YYYYMMDD END
----                    AND    IGR.DIVISION_ID          = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.DIVISION_ID ELSE IGR.DIVISION_ID END
----                    AND    IGR.GROUP_CODE1          = CASE WHEN SUM.DIVISION_ID = '81' THEN SUM.GROUP_CODE1 ELSE IGR.GROUP_CODE1 END
----                )                
--GROUP BY SUM.PLAN_START_YYYYMMDD
--        ,SUM.PLAN_YYYYMM
--        ,SUM.DIVISION_ID
--        ,SUM.PLAN_TP_CD
--        ,SUM.DATA_TP_CD
--        ,SUM.SRCE_TP_CD
--        ,LK.ATTRIBUTE2
--        ,SUM.GROUP_CODE1
--        ,FI.MKT_DEPT
--        ,FI.END_CUSTOMER
--        ,SUM.ITEM_ID
--        ,SIM.ITEM_NAME
--        ,SIM.UOM
--------------------------------------------------------------------------------
--UNION ALL
--------------------------------------------------------------------------------
---- 원재료
--------------------------------------------------------------------------------
--SELECT SUM.PLAN_START_YYYYMMDD                              AS PLAN_DATE
--      ,SUM.PLAN_YYYYMM                                      AS END_MONTH
--      ,SUM.DIVISION_ID                                      AS DIV
--      ,SUM.PLANT_ID                                         AS PLANT_ID
--      ,SUBSTRING(SUM.PLAN_TP_CD,1,4)                        AS PLAN_TP_CD
--      ,SUM.DATA_TP_CD                                       AS DATA_TP_CD
--      ,SUM.SRCE_TP_CD                                       AS SRCE_TP_CD
--      ,N'원재료'                                            AS ITEM_TYPE
--      ,LK.ATTRIBUTE3                                        AS CREATION_TYPE
--      ,SUM.PROCESS_DETAIL                                   AS GROUP_CODE
--      ,FI.MKT_DEPT                                          AS MKT_DEPT
--      --,FI.END_CUSTOMER                                      AS END_CUSTOMER
--      ,(SELECT TOP 1 GR2.GROUP_CODE1
--        FROM   SCM_MST_BOM_EFFECTIVE_SN BOM2 WITH(NOLOCK)
--                LEFT OUTER JOIN GROUP_CD GR2 
--                ON   GR2.ITEM_ID             = BOM2.MODEL_ID
--                AND  GR2.DIVISION_ID         = SUM.DIVISION_ID
--        WHERE  1=1
--        AND    BOM2.EFF_START_DATE >= GETDATE()
--        AND    BOM2.DIVISION_ID   = SUM.DIVISION_ID
--        AND    BOM2.CHILD_ITEM_ID = SUM.ITEM_ID
--        )            AS END_CUSTOMER
--      ,SUM.ITEM_ID                                          AS ITEM_ID
--      ,SIM.ITEM_NAME                                        AS ITEM_NAME
--      ,SIM.UOM                                              AS UOM
--      ,( SELECT SUM(QTY)
--         FROM   RTF_RMTL WITH(NOLOCK)
--         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
--         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
--         AND    DIVISION_ID         = SUM.DIVISION_ID
--         AND    PLANT_ID            = SUM.PLANT_ID
--         AND    ITEM_ID             = SUM.ITEM_ID
--         AND    DATA_TP_CD          = 'S'
--         AND    PLAN_YYYYMM         <= SUM.PLAN_YYYYMM )    AS RTF
--      ,MAX(SUM.STANDARD_COST)                               AS PRICE   
--      ,SUM(SUM.AMT)                                         AS AMT
--      --,SUM(QTY)                                             AS TOTAL
--      ,ROUND(SUM(QTY),2)                                     AS TOTAL
--      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실', QTY, 0))       AS LONG_TERM_QTY
--      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실 징후', QTY, 0))  AS LONG_TERM_EXPECT_QTY
--      ,(SELECT BASE_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD ) AS BASE_YYYYMM
--      ,PIC.PIC_NM                                           AS PIC
--      /*,( SELECT CASE WHEN SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) = (SELECT LAST_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD )
--                          THEN ''
--                     ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) END
--         FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL WITH(NOLOCK)
--         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
--         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
--         AND    DIVISION_ID         = SUM.DIVISION_ID
--         AND    ITEM_ID             = SUM.ITEM_ID
--         AND    DATA_TP_CD          <> 'RESULT'
--         AND    DATA_TP_CD          = 'EOH'
--         AND    LONG_TERM_TYPE      IN ( N'부실 징후',N'부실' ) ) AS MIN_EXHT_YYYYMM*/
--       ,NULL                                                     AS MIN_EXHT_YYYYMM  
--FROM   SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM WITH(NOLOCK)
--       LEFT OUTER JOIN SCP_MST_FINAL_ITEM  FI  WITH(NOLOCK)	 
--            ON   FI.DIVISION_ID  = SUM.DIVISION_ID
--            AND  FI.ITEM_ID      = SUM.ITEM_ID
--       LEFT OUTER JOIN ( SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_UOM) AS UOM, MAX(ITEM_NAME) AS ITEM_NAME
--                         FROM    SCM_ITEM_M_SN WITH(NOLOCK) 
--                         GROUP BY DIVISION_ID, ITEM_ID 
--                        ) SIM
--            ON  SIM.DIVISION_ID = SUM.DIVISION_ID
--            AND SIM.ITEM_ID     = SUM.ITEM_ID
--        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
--            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
--            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
--            AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
--            AND     LK.VALID_YN     = 'Y'
--            AND     LK.SEGMENT1     = 'SRCE_TP_CD'
--        LEFT JOIN SCP_MST_PIC_INFO PIC WITH(NOLOCK)
--            ON  PIC.PLANT_ID= SUM.PLANT_ID 
--            AND PIC.ITEM_ID = SUM.ITEM_ID    
--WHERE   1=1          
--AND     SUM.DATA_TP_CD      = 'EOH'         
--AND     SUM.LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
--AND     SUM.PLAN_TP_CD      = 'RMTL_INIT'
--GROUP BY SUM.PLAN_START_YYYYMMDD
--        ,SUM.PLAN_YYYYMM
--        ,SUM.DIVISION_ID
--        ,SUM.PLANT_ID
--        ,SUM.PLAN_TP_CD
--        ,SUM.DATA_TP_CD
--        ,SUM.SRCE_TP_CD
--        ,LK.ATTRIBUTE3
--        ,SUM.PROCESS_DETAIL
--        ,SUM.GROUP_CODE1
--        ,FI.MKT_DEPT
--        ,FI.END_CUSTOMER
--        ,SUM.ITEM_ID
--        ,SIM.ITEM_NAME
--        ,SIM.UOM  
--        ,PIC.PIC_NM      
--------------------------------------------------------------------------------
--UNION ALL
--------------------------------------------------------------------------------
---- 상품
--------------------------------------------------------------------------------
--SELECT SUM.PLAN_START_YYYYMMDD                              AS PLAN_DATE
--      ,SUM.PLAN_YYYYMM                                      AS END_MONTH
--      ,SUM.DIVISION_ID                                      AS DIV
--      ,'*'                                                  AS PLANT_ID
--      ,SUBSTRING(SUM.PLAN_TP_CD,1,4)                        AS PLAN_TP_CD
--      ,SUM.DATA_TP_CD                                       AS DATA_TP_CD
--      ,SUM.SRCE_TP_CD                                       AS SRCE_TP_CD
--      ,N'상품'                                               AS ITEM_TYPE
--      ,LK.ATTRIBUTE4                                        AS CREATION_TYPE
--      --,SUM.GROUP_CODE1                                      AS GROUP_CODE
--      ,SUM.PROCESS_DETAIL                                   AS GROUP_CODE
--      ,FI.MKT_DEPT                                          AS MKT_DEPT
--      ,FI.END_CUSTOMER                                      AS END_CUSTOMER
--      ,SUM.ITEM_ID                                          AS ITEM_ID
--      ,SIM.ITEM_NAME                                        AS ITEM_NAME
--      ,SIM.UOM                                              AS UOM
--      ,( SELECT SUM(QTY)
--         FROM   RTF_GODS WITH(NOLOCK)
--         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
--         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
--         AND    DIVISION_ID         = SUM.DIVISION_ID
--         AND    ITEM_ID             = SUM.ITEM_ID
--         AND    DATA_TP_CD          = 'S'
--         AND    PLAN_YYYYMM         <= SUM.PLAN_YYYYMM )    AS RTF
--      ,MAX(SUM.STANDARD_COST)                               AS PRICE   
--      ,SUM(SUM.AMT)                                         AS AMT
--      --,SUM(QTY)                                             AS TOTAL
--      ,ROUND(SUM(QTY),2)                                     AS TOTAL
--      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실', QTY, 0))        AS LONG_TERM_QTY
--      ,SUM(IIF(SUM.LONG_TERM_TYPE = N'부실 징후', QTY, 0))    AS LONG_TERM_EXPECT_QTY
--      ,(SELECT BASE_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD ) AS BASE_YYYYMM
--      ,NULL                                                   AS PIC
--      /*,( SELECT CASE WHEN SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) = (SELECT LAST_YYYYMM FROM BASE WHERE PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD )
--                          THEN ''
--                     ELSE SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, +1, CONVERT(DATETIME, CONCAT(MAX(PLAN_YYYYMM) , '01'))),112),1,6) END
--         FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS WITH(NOLOCK)
--         WHERE  PLAN_START_YYYYMMDD = SUM.PLAN_START_YYYYMMDD
--         AND    PLAN_TP_CD          = SUM.PLAN_TP_CD
--         AND    DIVISION_ID         = SUM.DIVISION_ID
--         AND    ITEM_ID             = SUM.ITEM_ID
--         AND    DATA_TP_CD          <> 'RESULT'
--         AND    DATA_TP_CD          = 'EOH'
--         AND    LONG_TERM_TYPE      IN ( N'부실 징후',N'부실' ) ) AS MIN_EXHT_YYYYMM*/
--       ,NULL                                                     AS MIN_EXHT_YYYYMM  
--FROM   SCM_LGTM_INV_PSI_SUMMARY_GODS SUM WITH(NOLOCK)
--       LEFT OUTER JOIN SCP_MST_FINAL_ITEM  FI  WITH(NOLOCK)	 
--            ON   FI.DIVISION_ID  = SUM.DIVISION_ID
--            AND  FI.ITEM_ID      = SUM.ITEM_ID
--       LEFT OUTER JOIN ( SELECT  DIVISION_ID, ITEM_ID, MAX(ITEM_UOM) AS UOM, MAX(ITEM_NAME) AS ITEM_NAME
--                         FROM    SCM_ITEM_M_SN WITH(NOLOCK) 
--                         GROUP BY DIVISION_ID, ITEM_ID 
--                        ) SIM
--            ON  SIM.DIVISION_ID = SUM.DIVISION_ID
--            AND SIM.ITEM_ID     = SUM.ITEM_ID
--        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
--            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
--            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
--            AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
--            AND     LK.VALID_YN     = 'Y'
--            AND     LK.SEGMENT1     = 'SRCE_TP_CD'
--WHERE   1=1          
--AND     SUM.DATA_TP_CD      = 'EOH'         
--AND     SUM.LONG_TERM_TYPE  IN (N'부실',N'부실 징후')   
--AND     SUM.PLAN_TP_CD      = 'GODS_INIT'
--GROUP BY SUM.PLAN_START_YYYYMMDD
--        ,SUM.PLAN_YYYYMM
--        ,SUM.DIVISION_ID
--        ,SUM.PLAN_TP_CD
--        ,SUM.DATA_TP_CD
--        ,SUM.SRCE_TP_CD
--        ,LK.ATTRIBUTE4
--        --,SUM.GROUP_CODE1
--        ,SUM.PROCESS_DETAIL
--        ,FI.MKT_DEPT
--        ,FI.END_CUSTOMER
--        ,SUM.ITEM_ID
--        ,SIM.ITEM_NAME
--        ,SIM.UOM
