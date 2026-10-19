

/*
 * Program ID   : PR_DM_XIF_ERP_NSD0001_R
 * Description  : NERP EDI Call Off 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
   2024.06.27	P.C.I			NERP 대응
 *
 */

--EXEC PR_GSCM_XIF_DM_NSD0001_R
create PROCEDURE [dbo].[PR_DM_XIF_ERP_NSD0001_R]
	  @ET_NEDIHEADER				AS DBO.ET_NEDIHEADER        READONLY
	, @ET_NEDIPARTNER				AS DBO.ET_NEDIPARTNER       READONLY
	, @ET_NEDIITEM					AS DBO.ET_NEDIITEM			READONLY
	          
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_UPDATE_DATE	NVARCHAR(8)      = CONVERT(VARCHAR(8), GETDATE(), 112);
        DECLARE @TRANSFER_UPDATE_TIEM	NVARCHAR(6)      = REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108),':','');
        DECLARE @TRANSFER_UPDATE_ID		NVARCHAR(12)  = 'XIF_NSD0001';
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_GSCM_XIF_DM_NSD0001_R';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;
		DECLARE @v_ifseqno      NVARCHAR(30); 
		DECLARE @n_history_seq  BIGINT;

		DECLARE @COUNT          INT
		DECLARE @COUNT1         INT
		DECLARE @COUNT2         INT
		DECLARE @COUNT3         INT

		SELECT @COUNT1 = COUNT(*) FROM @ET_NEDIHEADER         
		SELECT @COUNT2 = COUNT(*) FROM @ET_NEDIPARTNER
		SELECT @COUNT3 = COUNT(*) FROM @ET_NEDIITEM

		SET @COUNT = @COUNT1 + @COUNT2 + @COUNT3

		--IF (@COUNT > 0 )
		BEGIN

			-- 시작 LOG
			SET @v_log_type    = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date  = SYSDATETIME();

			--SET @v_description = + 'I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT)--, @@ROWCOUNT)

			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			BEGIN TRY
				BEGIN TRAN
				-- ET_NEDIHEADER
				--IF @COUNT1 > 0
					BEGIN
						SET @COUNT1 = 0
						SELECT @COUNT1 = COUNT(*) FROM @ET_NEDIHEADER
						SET @v_description = + 'ET_NEDIHEADER I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT1)--, @@ROWCOUNT)
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						DECLARE @IFSEQNO NVARCHAR(30)
						SELECT @IFSEQNO = IFSEQNO FROM @ET_NEDIHEADER GROUP BY IFSEQNO
						SET @v_description = + 'IFSEQNO : ' + CONVERT(VARCHAR(30), ISNULL(@IFSEQNO, 'NO COUNT'))--, @@ROWCOUNT)
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						INSERT INTO [XIF_ERP_EDI_CALLOFF_HEAD_R_SN]
								   ( [IFSEQNO] 
								, [SOLDTO_CODE] 
								, [COMPANY_ID] 
								, [MESSAGE_REFERENCE] 
								, [MESSAGE_TYPE] 
								, [DOC_IDENTIFINER] 
								, [EDI_INTERCHANGE_NO] 
								, [DOC_ISSUE_DATE] 
								, [RDD_TYPE] 
								, [COMPANY_NAME] 
								, [SOLDTO_NAME] 
								, [EDI_IF_SEQ] 
								, [TRANSACTION_FLAG] 
								, [CREATE_USER_ID] 
								, [CREATE_DATE] 
								, [CREATE_TIME] 
								, [UPDATE_USER_ID] 
								, [UPDATE_DATE] 
								, [UPDATE_TIME]
								, [TRANSFER_CREATE_USER_ID]
								, [TRANSFER_CREATE_DATE]
								, [TRANSFER_CREATE_TIME]
								, [TRANSFER_UPDATE_USER_ID]
								, [TRANSFER_UPDATE_DATE] 
								, [TRANSFER_UPDATE_TIME] 
								, [TRANSFER_FLAG] 
								, [DOC_STATUS] 
								, [STATUS_MSG] 
								, [SENDER_CODE] 
								, [SENDER_NAME] 
								, [ATTRIBUTE1] 
								, [ATTRIBUTE2] 
								, [ATTRIBUTE3] 
								, [ATTRIBUTE4] 
								, [ATTRIBUTE5] 
								, [ATTRIBUTE6] 
								, [ATTRIBUTE7] 
								, [ATTRIBUTE8] 
								, [ATTRIBUTE9] 
								, [ATTRIBUTE10]
								, [ATTRIBUTE11]
								, [ATTRIBUTE12]
								, [ATTRIBUTE13]
								, [ATTRIBUTE14]
								, [ATTRIBUTE15]
								   )
							 SELECT DISTINCT [IFSEQNO] 
								, [SOLDTO_CODE] 
								, [COMPANY_ID] 
								, [MESSAGE_REFERENCE] 
								, [MESSAGE_TYPE] 
								, [DOC_IDENTIFINER] 
								, [EDI_INTERCHANGE_NO] 
								, [DOC_ISSUE_DATE] 
								, [RDD_TYPE] 
								, [COMPANY_NAME] 
								, [SOLDTO_NAME] 
								, [EDI_IF_SEQ] 
								, [TRANSACTION_FLAG] 
								, [CREATE_USER_ID] 
								, [CREATE_DATE] 
								, [CREATE_TIME] 
								, [UPDATE_USER_ID] 
								, [UPDATE_DATE] 
								, [UPDATE_TIME]
								, [TRANSFER_CREATE_USER_ID]
								, [TRANSFER_CREATE_DATE]
								, [TRANSFER_CREATE_TIME]
								, @TRANSFER_UPDATE_ID
								, @TRANSFER_UPDATE_DATE 
								, @TRANSFER_UPDATE_TIEM 
								, @TRANSFER_FLAG
								, [DOC_STATUS] 
								, [STATUS_MSG] 
								, [SENDER_CODE] 
								, [SENDER_NAME] 
								, [ATTRIBUTE1] 
								, [ATTRIBUTE2] 
								, [ATTRIBUTE3] 
								, [ATTRIBUTE4] 
								, [ATTRIBUTE5] 
								, [ATTRIBUTE6] 
								, [ATTRIBUTE7] 
								, [ATTRIBUTE8] 
								, [ATTRIBUTE9] 
								, [ATTRIBUTE10]
								, [ATTRIBUTE11]
								, [ATTRIBUTE12]
								, [ATTRIBUTE13]
								, [ATTRIBUTE14]
								, [ATTRIBUTE15]
							  FROM @ET_NEDIHEADER ;
					END
					

					BEGIN
						SET @COUNT2 = 0
						SELECT @COUNT2 = COUNT(*) FROM @ET_NEDIPARTNER
						SET @v_description = + 'ET_NEDIPARTNER I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT2)
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						INSERT INTO [XIF_ERP_EDI_CALLOFF_PARTNER_R_SN]
								   ([IFSEQNO] 
								, [SOLDTO_CODE] 
								, [COMPANY_ID] 
								, [MESSAGE_REFERENCE] 
								, [MESSAGE_TYPE] 
								, [DOC_IDENTIFINER] 
								, [SHIPTO_CODE] 
								, [PARTNER_TYPE] 
								, [SHIPTO_SEQ] 
								, [COMPANY_NAME]
								, [SHIPTO_NAME1]
								, [SHIPTO_NAME2]
								, [CITY_NAME]
								, [POSTAL_CODE] 
								, [COUNTRY] 
								, [SHIPTO_DUNS_NO]
								, [EDI_IF_SEQ] 
								, [TRANSACTION_FLAG]
								, [SHIP_FROM_PLANT] 
								, [CREATE_USER_ID] 
								, [CREATE_DATE] 
								, [CREATE_TIME] 
								, [UPDATE_USER_ID] 
								, [UPDATE_DATE] 
								, [UPDATE_TIME]
								, [TRANSFER_CREATE_USER_ID]
								, [TRANSFER_CREATE_DATE]
								, [TRANSFER_CREATE_TIME]
								, [TRANSFER_UPDATE_USER_ID]
								, [TRANSFER_UPDATE_DATE] 
								, [TRANSFER_UPDATE_TIME] 
								, [TRANSFER_FLAG] 
								, [DOC_STATUS] 
								, [STATUS_MSG] 
								, [SENDER_CODE] 
								, [SENDER_NAME] 
								, [ATTRIBUTE1] 
								, [ATTRIBUTE2] 
								, [ATTRIBUTE3] 
								, [ATTRIBUTE4] 
								, [ATTRIBUTE5] 
								, [ATTRIBUTE6] 
								, [ATTRIBUTE7] 
								, [ATTRIBUTE8] 
								, [ATTRIBUTE9] 
								, [ATTRIBUTE10]
								, [ATTRIBUTE11]
								, [ATTRIBUTE12]
								, [ATTRIBUTE13]
								, [ATTRIBUTE14]
								, [ATTRIBUTE15]
								   )
							 SELECT DISTINCT [IFSEQNO] 
								, [SOLDTO_CODE] 
								, [COMPANY_ID] 
								, [MESSAGE_REFERENCE] 
								, [MESSAGE_TYPE] 
								, [DOC_IDENTIFINER] 
								, [SHIPTO_CODE] 
								, [PARTNER_TYPE] 
								, [SHIPTO_SEQ] 
								, [COMPANY_NAME]
								, [SHIPTO_NAME1]
								, [SHIPTO_NAME2]
								, [CITY_NAME]
								, [POSTAL_CODE] 
								, [COUNTRY] 
								, [SHIPTO_DUNS_NO]
								, [EDI_IF_SEQ] 
								, [TRANSACTION_FLAG]
								, [SHIP_FROM_PLANT] 
								, [CREATE_USER_ID] 
								, [CREATE_DATE] 
								, [CREATE_TIME] 
								, [UPDATE_USER_ID] 
								, [UPDATE_DATE] 
								, [UPDATE_TIME]
								, [TRANSFER_CREATE_USER_ID]
								, [TRANSFER_CREATE_DATE]
								, [TRANSFER_CREATE_TIME]
								, @TRANSFER_UPDATE_ID
								, @TRANSFER_UPDATE_DATE 
								, @TRANSFER_UPDATE_TIEM 
								, @TRANSFER_FLAG
								, [DOC_STATUS] 
								, [STATUS_MSG] 
								, [SENDER_CODE] 
								, [SENDER_NAME] 
								, [ATTRIBUTE1] 
								, [ATTRIBUTE2] 
								, [ATTRIBUTE3] 
								, [ATTRIBUTE4] 
								, [ATTRIBUTE5] 
								, [ATTRIBUTE6] 
								, [ATTRIBUTE7] 
								, [ATTRIBUTE8] 
								, [ATTRIBUTE9] 
								, [ATTRIBUTE10]
								, [ATTRIBUTE11]
								, [ATTRIBUTE12]
								, [ATTRIBUTE13]
								, [ATTRIBUTE14]
								, [ATTRIBUTE15]
							  FROM @ET_NEDIPARTNER ;
					END


					BEGIN
						SET @COUNT3 = 0
						SELECT @COUNT3 = COUNT(*) FROM @ET_NEDIITEM
						SET @v_description = + 'ET_NEDIITEM I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT3)
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						INSERT INTO [XIF_ERP_EDI_CALLOFF_ITEM_R_SN]
								   ( 
								[IFSEQNO]
								, [SOLDTO_CODE] 
								, [COMPANY_ID]
								, [MESSAGE_REFERENCE] 
								, [MESSAGE_TYPE] 
								, [DOC_IDENTIFINER] 
								, [SHIPTO_CODE] 
								, [PARTNER_TYPE] 
								, [SHIPTO_SEQ] 
								, [SHIP_TO_ITEM_SEQ] 
								, [ITEM_ID] 
								, [CUSTOMER_PLANT]  
								, [UNLOADING_POINT] 
								, [SCHEDULING_TYPE] 
								, [RDD_START] 
								, [QTY] 
								, [UOM] 
								, [RDD_END] 
								, [CUSTOMER_PO_NO]
								, [CUSTOMER_CALL_OFF_NO] 
								, [CUSTOMER_CALL_OFF_DATE] 
								, [PREVIOUS_CALL_OFF_NO] 
								, [PREVIOUS_CALL_OFF_DATE] 
								, [COMPANY_NAME] 
								, [SHIPTO_NAME1] 
								, [SHIPTO_NAME2] 
								, [EDI_IF_SEQ] 
								, [TRANSACTION_FLAG] 
								, [ERP_FCST_TYPE] 
								, [CUST_MATERIAL_CODE]
								, [PLANNER_NAME]
								, [CREATE_USER_ID] 
								, [CREATE_DATE] 
								, [CREATE_TIME] 
								, [UPDATE_USER_ID] 
								, [UPDATE_DATE] 
								, [UPDATE_TIME]
								, [TRANSFER_CREATE_USER_ID]
								, [TRANSFER_CREATE_DATE]
								, [TRANSFER_CREATE_TIME]
								, [TRANSFER_UPDATE_USER_ID]
								, [TRANSFER_UPDATE_DATE] 
								, [TRANSFER_UPDATE_TIME] 
								, [TRANSFER_FLAG] 
								, [DOC_STATUS] 
								, [STATUS_MSG] 
								, [SENDER_CODE] 
								, [SENDER_NAME] 
								, [ATTRIBUTE1] 
								, [ATTRIBUTE2] 
								, [ATTRIBUTE3] 
								, [ATTRIBUTE4] 
								, [ATTRIBUTE5] 
								, [ATTRIBUTE6] 
								, [ATTRIBUTE7] 
								, [ATTRIBUTE8] 
								, [ATTRIBUTE9] 
								, [ATTRIBUTE10]
								, [ATTRIBUTE11]
								, [ATTRIBUTE12]
								, [ATTRIBUTE13]
								, [ATTRIBUTE14]
								, [ATTRIBUTE15]
								   )
							 SELECT DISTINCT [IFSEQNO]
								, [SOLDTO_CODE] 
								, [COMPANY_ID]
								, [MESSAGE_REFERENCE] 
								, [MESSAGE_TYPE] 
								, [DOC_IDENTIFINER] 
								, [SHIPTO_CODE] 
								, [PARTNER_TYPE] 
								, [SHIPTO_SEQ] 
								, [SHIP_TO_ITEM_SEQ] 
								, [ITEM_ID] 
								, [CUSTOMER_PLANT]  
								, [UNLOADING_POINT] 
								, [SCHEDULING_TYPE] 
								, [RDD_START] 
								, [QTY] 
								, [UOM] 
								, [RDD_END] 
								, [CUSTOMER_PO_NO]
								, [CUSTOMER_CALL_OFF_NO] 
								, [CUSTOMER_CALL_OFF_DATE] 
								, [PREVIOUS_CALL_OFF_NO] 
								, [PREVIOUS_CALL_OFF_DATE] 
								, [COMPANY_NAME] 
								, [SHIPTO_NAME1] 
								, [SHIPTO_NAME2] 
								, [EDI_IF_SEQ] 
								, [TRANSACTION_FLAG] 
								, [ERP_FCST_TYPE] 
								, [CUST_MATERIAL_CODE]
								, [PLANNER_NAME]
								, [CREATE_USER_ID] 
								, [CREATE_DATE] 
								, [CREATE_TIME] 
								, [UPDATE_USER_ID] 
								, [UPDATE_DATE] 
								, [UPDATE_TIME]
								, [TRANSFER_CREATE_USER_ID]
								, [TRANSFER_CREATE_DATE]
								, [TRANSFER_CREATE_TIME]
								, @TRANSFER_UPDATE_ID
								, @TRANSFER_UPDATE_DATE 
								, @TRANSFER_UPDATE_TIEM 
								, @TRANSFER_FLAG
								, [DOC_STATUS] 
								, [STATUS_MSG] 
								, [SENDER_CODE] 
								, [SENDER_NAME] 
								, [ATTRIBUTE1] 
								, [ATTRIBUTE2] 
								, [ATTRIBUTE3] 
								, [ATTRIBUTE4] 
								, [ATTRIBUTE5] 
								, [ATTRIBUTE6] 
								, [ATTRIBUTE7] 
								, [ATTRIBUTE8] 
								, [ATTRIBUTE9] 
								, [ATTRIBUTE10]
								, [ATTRIBUTE11]
								, [ATTRIBUTE12]
								, [ATTRIBUTE13]
								, [ATTRIBUTE14]
								, [ATTRIBUTE15]
							  FROM @ET_NEDIITEM ;
					END

      

				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_EDI_CALLOFF';
				SET @v_description = '@ET_NEDIHEADER,@ET_NEDIPARTNER,@ET_NEDIITEM' 
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
				 COMMIT TRAN;
			END TRY

			BEGIN CATCH
				   ROLLBACK TRAN;
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
			SET @v_description = + 'I/F COUNT : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

			SET NOCOUNT OFF
		
		END
		 

	

END






