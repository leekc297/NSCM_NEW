
/*
 * Program ID   : PR_GSCM_XIF_SCP_SD0201_R
 * Description  : GERP VMI W/H 재고 정보 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/11/28   hwyoon		   Initial Release [PS02199094B] 전지 GSCM(SCP) 운영
 * 2024/04/17   vadabi5		   NERP) AUART,VBELN_S -> BSART,EBELN
 */

CREATE PROCEDURE [dbo].[PR_GSCM_XIF_SCP_SD0201_R]
    @ZSDGT50770			AS DBO.ZSDGT50770       READONLY
	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';
	
        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		DECLARE @INTERFACEID		NVARCHAR(35)  = '';
		SET @INTERFACEID = ISNULL((
									SELECT MAX(INTERFACEID) 
									FROM @ZSDGT50770  
									WHERE 1=1
								  ),'');

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_GSCM_XIF_SCP_SD0201_R';
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
				
				INSERT INTO [dbo].[XIF_ERP_VMI_STOCK_R_SN]
						   ( [IFSEQNO]
							,[INTERFACEID]
							,[IFDAT]
							,[IFTYPE]
							,[IFSEQ]
							,[WERKS]
							,[LGORT]
							,[MATNR]
							,[BSART]
							,[EBELN]	
							,[VKORG]
							,[VTWEG]
							,[SPART]
							,[TKNUM]
							,[VBELN_D]
							,[INVN_QTY]
							,[UNIT]
							,[ACT_IN_DATE]
							,[BASE_DT]
							,[STATUS_CD]
							,[TRANSFER_DATE]
							,[TRANSFER_FLAG]
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

					 SELECT CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_XIF_ERP_VMI_STOCK_R),6)
							--,INTERFACEID
							,ISNULL(@INTERFACEID,'-')
							,IFDAT
							,IFTYPE
							,IFSEQ
							,WERKS
							,LGORT
							,MATNR
							,BSART
							,EBELN
							,VKORG
							,VTWEG
							,SPART
							,TKNUM
							,VBELN_D
							,INVN_QTY
							,UNIT
							,ACT_IN_DATE
							,BASE_DT
							,STATUS_CD
							,@TRANSFER_DATE
							,@TRANSFER_FLAG
							,''
							,''
							,''
							,''
							,''
							,''
							,''
							,''
							,''
							,''
					  FROM @ZSDGT50770 ;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_VMI_STOCK_R_SN';
				SET @v_description = '@ZSDGT50770' 
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
