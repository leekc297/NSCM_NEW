
/*
 * Program ID   : PR_SSP_XIF_ERP_SHIP_PO_R
 * Description  : ESS PO 생성 정보 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/19   KIMYONGHO	   신규추가
 *
 */

create PROCEDURE [dbo].[PR_SSP_XIF_ERP_SHIP_PO_R]
    @TAB_DISP_MM0502			AS DBO.TAB_DISP_MM0502       READONLY
	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @IF_SEQNO              NVARCHAR(50) = '';
        DECLARE @TRANSFER_DATE        DATETIME         = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';


		-- PK IFSEQNO 생성
		SELECT @IF_SEQNO= 'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)
		FROM XIF_ERP_PO_INFO_R_SN
		--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_XIF_ERP_SHIP_PO_R';
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
				
				INSERT INTO [dbo].[XIF_ERP_PO_INFO_R_SN]
						   ( [IF_SEQ]
							,[IF_TYPE]
							,[IF_ID]
							,[IF_RCV_DATE]
							,[PROC_FLAG]
							,[PROC_DATE]
							,[PROC_MSG]
							,[IFSEQNO]
							,[PR_NO]
							,[PO_NO]	
							,[PO_ITEM_SEQ]
							,[PO_ITEM_ID]
							,[ERP_PO_STATUS]
							,[ERP_PO_MESSAGE]
							,[VENDOE_CODE]
							,[VENDOR_NAME]
							,[PO_CREATED_DATE]
							,[PO_END_FLAG]
							,[PO_YYYYMMDD]
							,[PO_QTY]
							,[UOM]
							,[PO_CREATE_BY]
							,[PO_CREATE_DATE]
							,[PO_UPDATE_BY]
							,[PO_UPDATE_DATE]
							,[ATTRIBUTE1]
							,[ATTRIBUTE2]
							,[ATTRIBUTE3]
							,[ATTRIBUTE4]
							,[ATTRIBUTE5]
							,[ATTRIBUTE6]
							,[ATTRIBUTE7]
							,[ATTRIBUTE8]
							,[ATTRIBUTE9]
							,[ATTRIBUTE10]
						   )
					 SELECT @IF_SEQNO
							, 'I'
							, 'OERP_OSCM_PO_INFO_R'
							, @TRANSFER_DATE
							, @TRANSFER_FLAG
							, NULL
							, NULL
							, IFSEQNO
							, PREQ_NO
							, PO_NO
							, PO_ITEM
							, MATERIAL
							, ERP_PO_STATUS
							, ERP_PO_MESSAGE
							, VENDOE_CODE
							, VENDOR_NAME
							, AEDAT
							, NO_MORE_GR
							, DELIV_DATE
							, QUANTITY
							, PO_UNIT
							, USERNAME
							, UDATE
							, USERNAME2
							, UDATE2
							, ATTRIBUTE1
							, ATTRIBUTE2
							, ATTRIBUTE3
							, ATTRIBUTE4
							, ATTRIBUTE5
							, ATTRIBUTE6
							, ATTRIBUTE7
							, ATTRIBUTE8
							, ATTRIBUTE9
							, ATTRIBUTE10
					  FROM @TAB_DISP_MM0502 ;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_PO_INFO_R_S_SN';
				SET @v_description = '@TAB_DISP_MM0502' 
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
