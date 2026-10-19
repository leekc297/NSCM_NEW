
/*
 * Program ID   : PR_GSCM_XIF_DM_SD0078_R
 * Description  : GERP Call Off 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/03/27   chano0612		   Initial Release EDI 기준 정보 정비 프로세스 구축 및 신규 화면 개발
 *
 */

--EXEC PR_GSCM_XIF_DM_SD0078_R
CREATE PROCEDURE [dbo].[PR_GSCM_XIF_DM_SD0078_R]
	  @ET_ZCUST_MAT			    AS DBO.ET_ZCUST_MAT        READONLY
	, @ET_ZEDI_MODEL			AS DBO.ET_ZEDI_MODEL       READONLY
	, @ET_ZEDI_STRUCT			AS DBO.ET_ZEDI_STRUCT      READONLY
	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_GSCM_XIF_DM_SD0078_R';
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

		SELECT @COUNT1 = COUNT(*) FROM @ET_ZCUST_MAT         
		SELECT @COUNT2 = COUNT(*) FROM @ET_ZEDI_MODEL
		SELECT @COUNT3 = COUNT(*) FROM @ET_ZEDI_STRUCT

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
				-- ET_ZCUST_MAT
				--IF @COUNT1 > 0
					BEGIN
					SET @COUNT1 = 0
					SELECT @COUNT1 = COUNT(*) FROM @ET_ZCUST_MAT
					SET @v_description = + 'ET_ZCUST_MAT I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT1)--, @@ROWCOUNT)
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

					DECLARE @IFSEQNO NVARCHAR(30)
					SELECT @IFSEQNO = IFSEQNO FROM @ET_ZCUST_MAT GROUP BY IFSEQNO
					SET @v_description = + 'IFSEQNO : ' + CONVERT(VARCHAR(30), ISNULL(@IFSEQNO, 'NO COUNT'))--, @@ROWCOUNT)
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

					INSERT INTO [XIF_ERP_EDI_MST_CUST_MAT_R_SN]
							   ( [IFSEQNO] 
								,[SALES_ORG] 
								,[DISTRIBUTION_CHANNEL] 
								,[CUSTOMER_CODE] 
								,[ITEM_ID] 
								,[ENTRY_USER_ID] 
								,[ENTRY_DATE] 
								,[SORT] 
								,[CUSTOMER_ITEM_ID] 
								,[CUSTOMER_ITEM_NAME] 
								,[DELIVERY_PRIORITY] 
								,[MIN_DELIVERY_QTY] 
								,[UNIT] 
								--,[BATCH_SPLIT_ALLOWED] 
								--,[PARTIAL_DELIVERY] 
								,[MAX_NUMBER] 
								,[UNDER_LIMIT] 
								,[OVER_LIMIT] 
								--,[UNLIMITED_OVERDELIVERY] 
								,[PLANT] 
								--,[ROUNDING_PROFILE] 
								--,[MEASURE_GROUP_UNIT] 
								--,[TAX_CODE] 
								--,[ITEM_USAGE] 
								,[CREATE_USER_ID] 
								,[CREATE_DATE] 
								,[CREATE_TIME] 
								,[UPDATE_USER_ID] 
								,[UPDATE_DATE] 
								,[UPDATE_TIME] 
								,[TRANSFER_DATE]
								,[TRANSFER_FLAG]
							   )
						 SELECT DISTINCT [IFSEQNO] 
								,[SALES_ORG] 
								,[DISTRIBUTION_CHANNEL] 
								,[CUSTOMER_CODE] 
								,[ITEM_ID] 
								,[ENTRY_USER_ID] 
								,[ENTRY_DATE] 
								,[SORT] 
								,LTRIM(RTRIM(ISNULL([CUSTOMER_ITEM_ID], '')))
								,[CUSTOMER_ITEM_NAME] 
								,[DELIVERY_PRIORITY] 
								,[MIN_DELIVERY_QTY] 
								,[UNIT] 
								--,[BATCH_SPLIT_ALLOWED] 
								--,[PARTIAL_DELIVERY] 
								,[MAX_NUMBER] 
								,[UNDER_LIMIT] 
								,[OVER_LIMIT] 
								--,[UNLIMITED_OVERDELIVERY]
								,[PLANT] 
								--,[ROUNDING_PROFILE] 
								--,[MEASURE_GROUP_UNIT] 
								--,[TAX_CODE] 
								--,[ITEM_USAGE] 
								,[CREATE_USER_ID] 
								,[CREATE_DATE] 
								,[CREATE_TIME] 
								,[UPDATE_USER_ID] 
								,[UPDATE_DATE] 
								,[UPDATE_TIME] 
							   ,@TRANSFER_DATE
							   ,@TRANSFER_FLAG
						  FROM @ET_ZCUST_MAT ;
					END
					

				-- ET_ZEDI_MODEL
				--IF @COUNT2 > 0
					BEGIN
					SET @COUNT2 = 0
					SELECT @COUNT2 = COUNT(*) FROM @ET_ZEDI_MODEL
					SET @v_description = + 'ET_ZEDI_MODEL I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT2)
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

					INSERT INTO [XIF_ERP_EDI_MST_MODEL_R_SN]
							   ( [IFSEQNO]
								,[COMPANY_ID]
								,[SALES_ORG]
								,[CUSTOMER_CODE]
								,[LANGUAGE]
								,[OBJECT_TYPE]
								,[CODE_KEY1]
								,[CODE_KEY2]
								,[CODE_KEY3]
								,[DESC1]
								,[DESC2]
								,[DESC3]
								,[REMARKS]
								,[DELETE_FLAG]
								,[ENTRY_USER_ID]
								,[ENTRY_DATE]
								,[ENTRY_TIME]
								,[CHANGED_USER_ID]
								,[CHANGED_DATE]
								,[CHANGED_TIME]
								,[CREATE_USER_ID]
								,[CREATE_DATE]
								,[CREATE_TIME]
								,[UPDATE_USER_ID]
								,[UPDATE_DATE]
								,[UPDATE_TIME]
								,[TRANSFER_DATE]
								,[TRANSFER_FLAG]
							   )
						 SELECT DISTINCT [IFSEQNO]
								,[COMPANY_ID]
								,[SALES_ORG]
								,ISNULL([CUSTOMER_CODE], '')
								,[LANGUAGE]
								,[OBJECT_TYPE]
								,ISNULL([CODE_KEY1], '')
								,ISNULL([CODE_KEY2], '')
								,ISNULL([CODE_KEY3], '')
								,[DESC1]
								,[DESC2]
								,[DESC3]
								,[REMARKS]
								,[DELETE_FLAG]
								,[ENTRY_USER_ID]
								,[ENTRY_DATE]
								,[ENTRY_TIME]
								,[CHANGED_USER_ID]
								,[CHANGED_DATE]
								,[CHANGED_TIME]
								,[CREATE_USER_ID]
								,[CREATE_DATE]
								,[CREATE_TIME]
								,[UPDATE_USER_ID]
								,[UPDATE_DATE]
								,[UPDATE_TIME]
							   ,@TRANSFER_DATE
							   ,@TRANSFER_FLAG
						  FROM @ET_ZEDI_MODEL ;
					END


				-- ET_ZEDI_STRUCT
				--IF @COUNT3 > 0
					BEGIN
					SET @COUNT3 = 0
					SELECT @COUNT3 = COUNT(*) FROM @ET_ZEDI_STRUCT
					SET @v_description = + 'ET_ZEDI_STRUCT I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT3)
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

					INSERT INTO [XIF_ERP_EDI_MST_STRUCT_R_SN]
							   ( [IFSEQNO]
								,[SALES_ORG]
								,[EDI_TYPE]
								,[EDI_TRANSACTION]
								,[EDI_CUST_GROUP]
								,[CODE_KEY1]
								,[CODE_KEY2]
								,[CODE_KEY3]
								,[CODE_VALUE]
								,[DESC1]
								--,[DESC2]
								,[REMARKS]
								--,[DELETE_FLAG]
								,[ENTRY_USER_ID]
								,[ENTRY_DATE]
								,[ENTRY_TIME]
								--,[CHANGED_USER_ID]
								,[CHANGED_DATE]
								,[CHANGED_TIME]
								,[CREATE_USER_ID]
								,[CREATE_DATE]
								,[CREATE_TIME]
								--,[UPDATE_USER_ID]
								,[UPDATE_DATE]
								,[UPDATE_TIME]
								,[TRANSFER_DATE]
								,[TRANSFER_FLAG]
							   )
						 SELECT DISTINCT [IFSEQNO]
								,[SALES_ORG]
								,[EDI_TYPE]
								,[EDI_TRANSACTION]
								,ISNULL([EDI_CUST_GROUP], '')
								,[CODE_KEY1]--ISNULL([CODE_KEY1], '')
								,[CODE_KEY2]--ISNULL([CODE_KEY2], '')
								,[CODE_KEY3]--ISNULL([CODE_KEY3], '')
								,[CODE_VALUE]
								,[DESC1]
								--,[DESC2]
								,[REMARKS]
								--,[DELETE_FLAG]
								,[ENTRY_USER_ID]
								,[ENTRY_DATE]
								,[ENTRY_TIME]
								--,[CHANGED_USER_ID]
								,[CHANGED_DATE]
								,[CHANGED_TIME]
								,[CREATE_USER_ID]
								,[CREATE_DATE]
								,[CREATE_TIME]
								--,[UPDATE_USER_ID]
								,[UPDATE_DATE]
								,[UPDATE_TIME]
							   ,@TRANSFER_DATE
							   ,@TRANSFER_FLAG
						  FROM @ET_ZEDI_STRUCT ;
					END

      
				--BEGIN
				--	EXEC PR_DM_ERP_EDI_MST_CUST_MAT
				--END

				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_EDI_MST';
				SET @v_description = '@ET_ZCUST_MAT1,@ET_ZEDI_MODEL1,@ET_ZEDI_STRUCT1' 
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
					--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			END CATCH      

			-- 종료 LOG
			SET @v_log_type    = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = + 'I/F COUNT : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

			SET NOCOUNT OFF
		
		END
		 

	

END






