
/*
 * Program ID   : PR_GSCM_XIF_DM_GSD0004_R
 * Description  : GERP Call Off Schedule 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/05   HWYOON		   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_GSCM_XIF_DM_GSD0004_R]
    @ZSDE1020T			AS DBO.ZSDE1020T       READONLY
	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_GSCM_XIF_DM_GSD0004_R';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;
		DECLARE @v_ifseqno      NVARCHAR(30); 
		DECLARE @n_history_seq  BIGINT;

		-- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        BEGIN TRY
			BEGIN TRAN
               
			INSERT INTO [dbo].[XIF_ERP_EDI_CALL_OFF_SCHEDULE_R_SN]
					   ( [CLIENT]
						,[IFSEQNO]
						,[COMPANY_ID]
						,[COMPANY_NAME]
						,[DOC_IDENTIFINER]
						,[SHIPTO_ITEM_NUMBER]
						,[LINE_ITEM_NUMBER]
						,[SCHEDULING_CONDITION]
						,[SCHEDULING_CONDITION_NAME]
						,[SCHEDULING_ITEM_NUMBER]
						,[TOBE_DELIVERED_QTY]
						,[UOM]
						,[REQ_DELIVERY_DATE]
						,[REQ_SHIPMENT_DATE]
						,[LAST_DELIVERY_DATE]
						,[EARLIEST_DELIVERY_DATE]
						,[START_DATE]
						,[END_DATE]
						,[TRANSACTION_FLAG]
						,[CREATE_USER_ID]
						,[CREATE_DATE]
						,[CREATE_TIME]
						,[UPDATE_USER_ID]
						,[UPDATE_DATE]
						,[UPDATE_TIME]
						,[TRANSFER_DATE]
						,[TRANSFER_FLAG]
					   )
				 SELECT MANDT
				       ,ZIFDOC_NO
					   ,BUKRS
					   ,BUTXT
					   ,ZDOCU_IDF
					   ,ZSHIPTO_POS
					   ,ZLINEITEM_POS
					   ,ZDLVPCL_CODE
					   ,DESC2
					   ,ZSCHEDULE_POS
					   ,ZSCHDDLV_QTY
					   ,ZUOM_CODE
					   ,ZDLVDATE_RDD
					   ,ZSHIPDATE_RDD
					   ,ZDLVDATE_LAST
					   ,ZDLVDATE_EST
					   ,ZATSTART_DATE
					   ,ZATEND_DATE
					   ,ZPROCS_TY
					   ,ZIF_ERNAM
					   ,ZIF_ERDAT
					   ,ZIF_ERZET
					   ,ZIF_AENAM
					   ,ZIF_AEDAT
					   ,ZIF_AEZET
					   ,@TRANSFER_DATE
					   ,@TRANSFER_FLAG
				  FROM @ZSDE1020T ;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_EDI_CALL_OFF_SCHEDULE_R_SN';
				SET @v_description = '@ZSDE1020T' 
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			 COMMIT TRAN;
        END TRY

        BEGIN CATCH
               ROLLBACK TRAN;
               --PRINT ERROR_MESSAGE();
               SET @E_TYPE = 'E';
               SET @E_MESSAGE = ERROR_MESSAGE();

				-- ERROR LOG
				SET @v_log_type    = 'ERROR';
				SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
				SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END CATCH     

		-- 종료 LOG
		SET @v_log_type    = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date; 

        SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

        SET NOCOUNT OFF

END






