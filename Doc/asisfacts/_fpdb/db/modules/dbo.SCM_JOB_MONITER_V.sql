









CREATE VIEW [dbo].[SCM_JOB_MONITER_V]
-- ================================================================================================
-- Program ID          : SCM_JOB_MONITER_V
--
-- Program Name        : SCM_JOB_MONITER_V
-- Param               :
-- Batch Period        : 
-- Description         : DM,SCP,FP,SSP Job Monitering View
--
-- Source System       : FP SDB, SCM SDB
-- Destination System  :
-- Source Table        : LGCE_SCMPROD.DBO.SCM_SYS_LOG_BATCH, LGCE_INF.DBO.XIF_LOG_HISTORY, LGCE_FP_TR.DBO.SCM_MAILING_H
--                       LGCE_FP_TR.DBO.JOB_SCHEDULE_MASTER
-- Destination Table   : 
--
-- Create(Update) Date : 2022.10.31
-- Author              : kim choon dong
-- Version             : 2022-07-08 kimcd  initial creation
--                       2022-09-02 kimcd  PR_SCM_MST_PROJECT SCP -> DM으로 조정
--                       2022-09-15 kimcd  XIF_ERP_CUSTOMER_R  제거
--                       2022-10-31 kimcd  SCP 이동 중 수량 수신 07시 작업 제거
--                       2022-11-16 kimcd  PR_SCM_MST_EXCHANGE_RATE DM으로 변경
-- ================================================================================================
AS
    -- DM, SCP, SSP Error Log
    SELECT  CASE WHEN PROGRAM_NAME LIKE '%SSP%'
				 OR PROGRAM_NAME IN  (  'FN_ERP_UI_TransferPosting',
										'FN_ERP_UIWebService',
										'FN_UIC0001',
										'FN_ERP_PR_UI_TransferPosting_PROD',
										'DMF0045_SAVE_SHIPMENT_REQUEST'
										) THEN 'SSP'
	             WHEN PROGRAM_NAME LIKE '%DM%'
				 OR PROGRAM_NAME IN  (  'XIF_ERP_CUSTOMER_R',
										'XIF_ERP_FI_MDF_R',
										'XIF_ERP_SALES_RESULT_R',
										'XIF_ERP_SALES_STOCK_R',
										'XIF_ERP_SLOC_R',
										'PR_SCM_MST_PROJECT', -- 2022-09-02 PR_SCM_MST_PROJECT 관련 DM에 추가
										'PR_SCM_MST_PROJECT_DV_MASTER',
										'PR_SCM_MST_PROJECT_ITEM',
										'PR_SCM_MST_PROJECT_MODEL_QUANTITY',
										'PR_SCM_MST_PROJECT_SCHEDULE',
										'PR_SCM_MST_PROJECTBOM',
										'PR_SCM_MST_EXCHANGE_RATE' -- 2022-11-16 kimcd DM으로 변경
										) THEN 'DM'
			     WHEN PROGRAM_NAME LIKE '%SCP%'
				 OR PROGRAM_NAME IN  (  'XIF_ERP_BEGIN_END_STOCK_R',
										'XIF_ERP_DELIVERY_TRACKING_R',
										'XIF_ERP_INTRANSIT_CO_R',
										'XIF_ERP_INTRANSIT_R',
										'XIF_ERP_LONG_TERM_STOCK_R',
										'XIF_ERP_MAT_PO_R',
										'XIF_ERP_VENDOR_R'
                                        ) THEN 'SCP'
                 WHEN PROGRAM_NAME LIKE '%SCM%' THEN 'SCP'
			     ELSE
			         'FP'
			     END    AS MODULE
		   ,PROGRAM_NAME
		   ,LOG_TYPE
		   ,LOG_MESSAGE
		   ,DESCRIPTION
		   ,CREATION_DATE
	FROM    LGCE_SCMDEV.DBO.SCM_SYS_LOG_BATCH T WITH(NOLOCK)
    WHERE   1=1
    AND     LOG_TYPE = 'ERROR'
    AND     CREATION_DATE > DATEADD( HH, -1, GETDATE())
	AND     PROGRAM_NAME != 'ExcelDownload'
	AND     PROGRAM_NAME != 'sp_send_dbmail'
	AND     PROGRAM_NAME != 'XIF_ERP_MAT_IMPORT_BL_R'
	AND     PROGRAM_NAME != 'XIF_ERP_MAT_INBOUND_DO_R'
	AND     PROGRAM_NAME != 'XIF_ERP_MAT_PO_RECEIPT_R'
	AND     PROGRAM_NAME != 'XIF_ERP_BEGIN_END_STOCK_R'
	AND     PROGRAM_NAME != 'XIF_ERP_CUSTOMER_R ' -- 2022-09-15 kimcd  XIF_ERP_CUSTOMER_R  제거
	AND     PROGRAM_NAME != 'PR_DM_DNM_CREATE_WS_RTF'
	AND     PROGRAM_NAME + '::' + DESCRIPTION + '::' + REPLACE(CONVERT(CHAR(2), CREATION_DATE, 108), ':', '') != 'XIF_ERP_INTRANSIT_CO_R::No data::07'  -- 2022-10-31 kimcd  SCP 이동 중 수량 수신 07시 작업 제거
    UNION   ALL
	-- FP Error Log
	SELECT  'FP' AS MODULE
	       ,PROC_NAME
		   ,LOG_TYPE
		   ,MESSAGE
		   ,DESCR
		   ,EVENT_DTTM
	FROM    LGCE_INFDEV.DBO.XIF_LOG_HISTORY WITH(NOLOCK)
    WHERE   LOG_TYPE = 'ERROR'
    AND     EVENT_DTTM > DATEADD( HH, -1, GETDATE())
    UNION   ALL
	-- FP Process Abnormal Check
	SELECT  'FP' AS MODULE
	       ,MAIL_SUBJECT
		   ,'FP PROCESS'  AS LOG_TYPE
		   ,MAIL_BODY
		   ,NULL
		   ,MAIL_DATETIME 
	FROM    LGCE_FPDEV_TR.DBO.SCM_MAILING_H WITH(NOLOCK)
	WHERE   CREATE_DATE > DATEADD( HH, -1, GETDATE())
	AND     MAIL_PKEY IN  ('FP_MAILING_IF12','FP_MAILING_IF15','FP_MAILING_IF18','FP_MAILING_IF20','FP_MAILING_IF22','FP_MAILING_IF31', 'FP_MAILING_IF6', 'FP_MAILING_IF8')
	UNION ALL
    -- FP Job too long
	SELECT  'FP' AS MODULE
		    ,PROC_NAME
			,'FP LONG'  AS LOG_TYPE
			,PROC_NAME + ' IS TOO LONG' AS MESSAGE
			,PROC_NAME + ' IS TOO LONG' AS DESCR
			,EVENT_DTTM
	FROM    ( SELECT PROC_NAME, EVENT_DTTM 
		      FROM   LGCE_INFDEV.DBO.XIF_LOG_HISTORY WITH(NOLOCK)
			  WHERE  EVENT_DTTM > DATEADD( MI, -90, GETDATE())
			  AND    PROC_NAME <> 'PR_SCM_MAIL_PERIOD'
			  AND    LOG_TYPE  = 'START' ) W 
	WHERE   NOT EXISTS ( SELECT 1
	                     FROM   LGCE_INFDEV.DBO.XIF_LOG_HISTORY X WITH(NOLOCK)
		                 WHERE  W.PROC_NAME  =  X.PROC_NAME
					     AND    W.EVENT_DTTM <= X.EVENT_DTTM
					     AND    X.LOG_TYPE = 'END' )
	AND     EVENT_DTTM < DATEADD( MI, -30, GETDATE())
	UNION ALL
    SELECT  'FP'         AS MODULE
	       ,'FP NET JOB' AS PROC_NAME
		   ,'ERROR'      AS LOG_TYPE
		   ,'FP NET JOB ERROR' AS MESSAGE
		   ,'FP NET JOB ERROR' AS DESCR
		   ,MAX(LATEST_RUN_DATE) AS CREATE_DATE
    FROM    LGCE_FPDEV_TR.DBO.JOB_SCHEDULE_MASTER WITH(NOLOCK)
    HAVING  MAX(LATEST_RUN_DATE) < DATEADD( MI, -10, GETDATE())
