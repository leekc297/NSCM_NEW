
/*
 * Program ID   : PR_SCP_IF_CHECK_SMS_SEND
 * Description  : SCP-ERP,FP 간 I/F DATA Check
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020.02.24   hwwoonins		Initial Release [] 전지GSCM(SCP) SM 운영
 * 2021.01.26   KSG             SO Reserved Stock Check 추가
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_IF_CHECK_SMS_SEND]
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_IF_CHECK_SMS_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;   
    
    BEGIN TRY
      BEGIN
    
        declare @rs nvarchar(10);
		declare @message nvarchar(100);

		--========================= 해상재고 Intransit ===========================
		set @rs = '';
		set @message = '';

		WITH RS AS (
			SELECT RESULT_DATE, COUNT(IFSEQNO) CNT
			FROM XIF_ERP_INTRANSIT_R_SN WITH(NOLOCK)
			WHERE RESULT_DATE>=CONVERT(CHAR(8),GETDATE()-4,112)
			GROUP BY RESULT_DATE
		)
		SELECT @rs = (CASE WHEN RS1.RESULT_DATE IS NULL THEN 'false'
							WHEN RS1.RESULT_DATE IS NOT NULL AND RS2.RESULT_DATE IS NULL THEN 'true' 
							WHEN RS2.CNT*0.8>RS1.CNT THEN 'false' 
							ELSE 'true'
						END) 
		FROM (SELECT 'TEST' AS T) A
		LEFT JOIN RS RS1 ON RS1.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-1,112)
		LEFT JOIN RS RS2 ON RS2.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-2,112)
		;

		IF(@rs='false')
			BEGIN
				--PRINT 'ERP In-transit False!';
				SET @message = N'ERP In-transit 해상재고 I/F Check'
				EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
			END
		;

		--========================= 해상재고 Tracking ===========================
		set @rs = '';
		set @message = '';

		WITH RS AS (
			SELECT TRANSFER_DATE, COUNT(IFSEQNO) CNT
			FROM XIF_ERP_DELIVERY_TRACKING_R_SN WITH(NOLOCK)
			WHERE TRANSFER_DATE>=CONVERT(CHAR(8),GETDATE()-4,112)
			GROUP BY TRANSFER_DATE
		)
		SELECT @rs = (CASE WHEN RS1.TRANSFER_DATE IS NULL THEN 'false'
							WHEN RS1.TRANSFER_DATE IS NOT NULL AND RS2.TRANSFER_DATE IS NULL THEN 'true' 
							WHEN RS2.CNT*0.8>RS1.CNT THEN 'false' 
							ELSE 'true'
						END)
		FROM (SELECT 'TEST' AS T) A
		LEFT JOIN RS RS1 ON RS1.TRANSFER_DATE=CONVERT(CHAR(8),GETDATE()-1,112)
		LEFT JOIN RS RS2 ON RS2.TRANSFER_DATE=CONVERT(CHAR(8),GETDATE()-2,112)
		;

		IF(@rs='false')
			BEGIN
				--PRINT 'ERP In-transit Tracking False!';
				SET @message = N'ERP 해상재고(GTS) Tracking I/F Check'
				EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
			END
		;

		--========================= 법인간 미착재고 ===========================
		set @rs = '';
		set @message = '';

		WITH RS AS (
			SELECT RESULT_DATE, COUNT(IFSEQNO) CNT
			FROM XIF_ERP_INTRANSIT_CO_SUMMARY_R_SN WITH(NOLOCK)
			WHERE RESULT_DATE>=CONVERT(CHAR(8),GETDATE()-4,112)
			GROUP BY RESULT_DATE
		)
		SELECT @rs = (CASE WHEN RS1.RESULT_DATE IS NULL THEN 'false'
							WHEN RS1.RESULT_DATE IS NOT NULL AND RS2.RESULT_DATE IS NULL THEN 'true' 
							WHEN RS2.CNT*0.8>RS1.CNT THEN 'false' 
							ELSE 'true'
						END)
		FROM (SELECT 'TEST' AS T) A
		LEFT JOIN RS RS1 ON RS1.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-1,112)
		LEFT JOIN RS RS2 ON RS2.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-2,112)
		;

		IF(@rs='false')
			BEGIN
				--PRINT N'ERP 법인간 미착재고 False!';
				SET @message = N'ERP 법인간 미착재고 I/F Check'
				EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
			END
		;

		--========================= 고객위탁재고 ===========================
		set @rs = '';
		set @message = '';

		WITH RS AS (
			SELECT RESULT_DATE, COUNT(IFSEQNO) CNT
			FROM XIF_ERP_CUSTOMER_CONSIGN_STOCK_R_SN WITH(NOLOCK)
			WHERE RESULT_DATE>=CONVERT(CHAR(8),GETDATE()-4,112)
			AND ATTRIBUTE1='A'
			GROUP BY RESULT_DATE
		)
		SELECT @rs = (CASE WHEN RS1.RESULT_DATE IS NULL THEN 'false'
							WHEN RS1.RESULT_DATE IS NOT NULL AND RS2.RESULT_DATE IS NULL THEN 'true' 
							WHEN RS2.CNT*0.8>RS1.CNT THEN 'false' 
							ELSE 'true'
						END)
		FROM (SELECT 'TEST' AS T) A
		LEFT JOIN RS RS1 ON RS1.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-1,112)
		LEFT JOIN RS RS2 ON RS2.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-2,112)
		;

		IF(@rs='false')
			BEGIN
				--PRINT N'ERP S/O Stock (고객 위탁 재고) False!';
				SET @message = N'ERP 고객 위탁 재고 I/F Check'
				EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
			END
		;

		--========================= SO Reserved Stock ===========================
        --  20210126 SO Reserved Stock Check 추가
		set @rs = '';
		set @message = '';

		WITH RS AS (
			SELECT RESULT_DATE, COUNT(IFSEQNO) CNT
			FROM XIF_ERP_CUSTOMER_CONSIGN_STOCK_R_SN WITH(NOLOCK)
			WHERE RESULT_DATE>=CONVERT(CHAR(8),GETDATE()-4,112)
			AND ATTRIBUTE1='B'
			GROUP BY RESULT_DATE
		)
		SELECT @rs = (CASE WHEN RS1.RESULT_DATE IS NULL THEN 'false'
							WHEN RS1.RESULT_DATE IS NOT NULL AND RS2.RESULT_DATE IS NULL THEN 'true' 
							WHEN RS2.CNT*0.8>RS1.CNT THEN 'false' 
							ELSE 'true'
						END)
		FROM (SELECT 'TEST' AS T) A
		LEFT JOIN RS RS1 ON RS1.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-1,112)
		LEFT JOIN RS RS2 ON RS2.RESULT_DATE=CONVERT(CHAR(8),GETDATE()-2,112)
		;

		IF(@rs='false')
			BEGIN
				--PRINT N'ERP S/O Stock (고객 위탁 재고) False!';
				SET @message = N'ERP SO Reserved Stock I/F Check'
				EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
			END
		;

		--========================= VMI STOCK재고 ===========================
		set @rs = '';
		set @message = '';

		WITH RS AS (
			SELECT IFDAT, COUNT(IFSEQNO) CNT
			FROM XIF_ERP_VMI_STOCK_R_SN WITH(NOLOCK)
			WHERE IFDAT>=CONVERT(CHAR(8),GETDATE()-4,112)
			GROUP BY IFDAT

		)
		SELECT @rs = (CASE WHEN RS1.IFDAT IS NULL THEN 'false'
							WHEN RS1.IFDAT IS NOT NULL AND RS2.IFDAT IS NULL THEN 'true' 
							WHEN RS2.CNT*0.8>RS1.CNT THEN 'false' 
							ELSE 'true'
						END)
		FROM (SELECT 'TEST' AS T) A
		LEFT JOIN RS RS1 ON RS1.IFDAT=CONVERT(CHAR(8),GETDATE()-1,112)
		LEFT JOIN RS RS2 ON RS2.IFDAT=CONVERT(CHAR(8),GETDATE()-2,112)
		;

		IF(@rs='false')
			BEGIN
				--PRINT N'ERP VMISTOCK(국내) False!';
				SET @message = N'ERP VMISTOCK(국내) I/F Check'
				EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
			END
		;

		--========================= 출하실적 ===========================
		set @rs = '';
		set @message = '';

		WITH RS AS (
			SELECT TRNF_DATE, COUNT(IFSEQNO) CNT
			FROM XIF_ERP_EXFACTORY_RESULT_R_SN WITH(NOLOCK)
			WHERE TRNF_DATE>=CONVERT(CHAR(8),GETDATE()-4,112)
			GROUP BY TRNF_DATE
		)
		SELECT @rs = (CASE WHEN RS1.TRNF_DATE IS NULL THEN 'false' 
							ELSE 'true' 
						END)
		FROM (SELECT 'TEST' AS T) A
		LEFT JOIN RS RS1 ON RS1.TRNF_DATE=CONVERT(CHAR(8),GETDATE()-1,112)
		;

		IF(@rs='false')
			BEGIN
				--PRINT N'FP 출하실적 False!';
				SET @message = N'FP 출하실적 I/F Check'
				EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
			END
		;

      END;

    END TRY

    BEGIN CATCH        
      
      -- ERROR LOG
	  INSERT INTO scm_sys_log_batch (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

      return -1 
    END CATCH;

    -- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description  = N'';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    return 1 

  END;

