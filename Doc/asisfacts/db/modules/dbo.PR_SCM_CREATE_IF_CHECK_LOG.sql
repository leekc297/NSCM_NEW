CREATE PROCEDURE dbo.PR_SCM_CREATE_IF_CHECK_LOG
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; 
 
    /* ───────────────────────────────────────────────────────────────────
       1) DM 모듈
       ─────────────────────────────────────────────────────────────────── */
    BEGIN TRY
        PRINT 'ING'
    END TRY
    BEGIN CATCH
        PRINT 'ING'        
    END CATCH;
 
    /* ───────────────────────────────────────────────────────────────────
       2) FP 모듈 
       ─────────────────────────────────────────────────────────────────── */
    BEGIN TRY
		-----------------------------------------------------------------------------
		--XIF_ERP_INVENTORY_R -> SCM_STOCK_H
		-----------------------------------------------------------------------------
		--PLANT_ID 마다 CUTOFF 시각이 다르므로 그 시각마다 체크해야함.
		--각 Plant 별 CUTOFF 시각
		-----------------------------------------------------------------------------
		;WITH W_FP_PLANT_CUTOFF AS (
		SELECT PLANT_ID
			 , START_TIME
			 , LOCAL_TIME
		  FROM (SELECT A.SEGMENT1 AS PLANT_ID
					 , A.SEGMENT2 AS START_TIME --현지 CUTOFF 예정시각
					 , FORMAT([lgce_fpdev_tr].[dbo].[FN_SITE_TIME](P.SITE_ID), 'HHmmss') AS LOCAL_TIME --현재 현지 시각
				  FROM [10.34.220.88,7433].[lgce_fp_tr].dbo.SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
				 INNER JOIN [lgce_fpdev_tr].dbo.SCM_PLANT_M P WITH(NOLOCK)
					ON A.SEGMENT1 = P.PLANT_ID
				 WHERE A.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
				   AND A.ACTIVE_FLAG = 'Y') A
		 WHERE 1=1
		   AND A.START_TIME <= A.LOCAL_TIME --CUTOFF 시각이 지난 PLANT 만 대상으로 함
		)
		-----------------------------------------------------------------------------
        INSERT TB_SCM_IF_CHECK_LOG
          ( LOG_DATE
		  , SYSTEM_CODE
		  , IF_TABLE_NAME
		  , BIZ_TABLE_NAME
		  , PLANT_ID
		  , TOTAL_QTY_IF
		  , TOTAL_QTY_BIZ
		  , DIFF_QTY
		  , BATCH_PROC_NAME
		  , STATUS_CODE
		  , NOTES)
		SELECT GETDATE()								AS LOG_DATE
			 , 'FP'										AS SYSTEM_CODE
			 , 'XIF_ERP_INVENTORY_R'					AS IF_TABLE_NAME
			 , 'SCM_STOCK_H'							AS BIZ_TABLE_NAME
			 , COF.PLANT_ID								AS PLANT_ID
			 , A.ORG_SUM								AS TOTAL_QTY_IF
			 , A.SCM_SUM								AS TOTAL_QTY_BIZ
			 , A.DIFF_QTY								AS DIFF_QTY
			 , 'PR_XIF_ERP_INVENTORY_R'					AS BATCH_PROC_NAME
			 , CASE WHEN ISNULL(A.ORG_SUM,0) = 0	THEN 'CHECK_IF_DATA'
					WHEN ISNULL(A.SCM_SUM,0) = 0	THEN 'CHECK_BATCH'
					WHEN A.DIFF_QTY <> 0			THEN 'DIFF'
					ELSE 'MATCH'					END	AS STATUS_CODE
			 , ''										AS NOTES
		  FROM W_FP_PLANT_CUTOFF COF -- CUTOFF 가 지난 PLANT를 대상으로 INSERT 하기 위해 MAIN VIEW 로 함.
		  LEFT JOIN ( SELECT ORG.PLANT_ID								AS PLANT_ID
						   , SUM(ORG.ORG_SUM)							AS ORG_SUM
						   , SUM(SCM.SCM_SUM)							AS SCM_SUM
						   , ABS(SUM(ORG.ORG_SUM)-SUM(SCM.SCM_SUM))		AS DIFF_QTY
						FROM (SELECT A.COMPANY
							  	   , A.PLANT_ID
							  	   , ISNULL(A.SLOC, '-') AS SLOC
							  	   , MAX(A.TRANSFER_DATE) AS TRANSFER_DATE
							  	   , SUM(CONVERT(NUMERIC(20,10), ISNULL(GOOD_QTY,0)) + CONVERT(NUMERIC(20,10), ISNULL(QT_ISP_QTY,0))) AS ORG_SUM
							    FROM [10.34.220.88,7433].[lgce_inf].DBO.XIF_ERP_INVENTORY_R A WITH(NOLOCK)
							   WHERE 1=1
							     AND A.EX_DATE = FORMAT(GETDATE(), 'yyyyMMdd')
							     AND A.TRANSFER_DATE >= GETDATE()-1
							     AND A.TRANSFER_FLAG = 'Y'
							   GROUP BY A.EX_DATE
							   		  , A.COMPANY
							   		  , A.PLANT_ID
							   		  , ISNULL(A.SLOC, '-')
						       ) ORG
						  LEFT JOIN (SELECT A.COMPANY_ID
										  , A.PLANT_ID
										  , ISNULL(A.STORAGE_ID, '-') AS STORAGE_ID
										  , MAX(A.INSERT_TIME) AS INSERT_TIME
										  , SUM(ISNULL(QTY,0)) AS SCM_SUM
									   FROM [10.34.220.88,7433].[lgce_fp_tr].DBO.SCM_STOCK_H A WITH(NOLOCK)
									  WHERE 1=1
										AND A.CUTOFF_DATE = FORMAT(GETDATE(), 'yyyy-MM-dd')
										AND A.STOCK_TYPE IN ('SUPPLY', 'INVENTORY')
									  GROUP BY A.CUTOFF_DATE
											 , A.COMPANY_ID
											 , A.PLANT_ID
											 , ISNULL(A.STORAGE_ID,'-')) SCM
							ON (ORG.COMPANY = SCM.COMPANY_ID
							AND ORG.PLANT_ID = SCM.PLANT_ID
							AND ORG.SLOC = SCM.STORAGE_ID)
						  GROUP BY ORG.PLANT_ID
				 ) A
			  ON COF.PLANT_ID = A.PLANT_ID
	       WHERE 1=1
    END TRY
    BEGIN CATCH
        INSERT dbo.TB_SCM_IF_CHECK_LOG
          (LOG_DATE
		  ,SYSTEM_CODE
		  ,IF_TABLE_NAME
		  ,BIZ_TABLE_NAME
		  ,STATUS_CODE
		  ,NOTES)
        VALUES 
		  (GETDATE()
		  ,'FP'
		  ,'XIF_ERP_INVENTORY_R'
		  ,'SCM_STOCK_H'
		  ,'ERROR'
		  , CONCAT(N'ERR: ',ERROR_MESSAGE()))
    END CATCH;
 
    /* ───────────────────────────────────────────────────────────────────
       3) SSP 
       ─────────────────────────────────────────────────────────────────── */
    BEGIN TRY
        PRINT 'ING'
    END TRY
    BEGIN CATCH
        PRINT 'ING'        
    END CATCH;
END

--EXECUTE PR_SCM_CREATE_IF_CHECK_LOG