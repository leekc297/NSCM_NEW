
/*
 * Program ID   : [PR_XIF_NERP_LSP_STOCK_R]
 * Description  : LSP Call 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/11/05	chkim.68		Receive LSP Stock (neif00305pp)
 *
 */
CREATE PROCEDURE [dbo].[PR_XIF_NERP_LSP_STOCK_R]
    @p_param 		AS DBO.PARAM_XIF_LSP_STOCK_R       READONLY	                            
AS
BEGIN

SET NOCOUNT ON;
		print '[PR_XIF_LSP_STOCK_R]'
        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'neif00305';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_XIF_NERP_LSP_STOCK_R';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;
		DECLARE @v_ifseqno      NVARCHAR(30); 
		DECLARE @n_history_seq  BIGINT;

		---- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();

		--EXEC PR_XIF_LOG @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description,NULL, @d_event_date;

        BEGIN TRY
			BEGIN TRAN
               
			INSERT INTO [LGCE_INFDEV].[dbo].[XIF_LSP_STOCK_R]
           ([IF_SEQ]
           ,[MASTER_IF_SEQ]
           ,[IF_TYPE]
           ,[IF_ID]
           ,[IF_RCV_DATE]
           ,[PROC_FLAG]
           ,[PROC_DATE]
           ,[PROC_MSG]
           ,[ITEM_ID]
           ,[PALLET_ID]
           ,[STOCK_QTY]
           ,[AVAILABLE_QTY]
           ,[NON_QC_QTY]
           ,[ALLOCATION_QTY]
           ,[BLOCK_QTY]
           ,[PACKING_QTY]
           ,[MOVING_QTY]
           ,[RCVLOC_QTY]
           ,[EXPIRATION_QTY]
           ,[LONG_QTY]
           ,[PROD_GROUP]
           ,[LOT_ID]
           ,[PLANT_ID]
           ,[GRADE]
           ,[PACKING_STATUS]
           ,[STOCK_STATUS]
           ,[STORAGE_ID]
           ,[CUSTOMER_CODE]
           ,[CUSTOMER_NAME]
           ,[LOT_DATE]
           ,[SOC]
           ,[CAPACITY_GRADE]
           ,[CREATION_DATE]
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
				 SELECT 			 
	 		[IF_SEQ]
           ,[MASTER_IF_SEQ]
           ,[IF_TYPE]
           ,[IF_ID]
           ,GetDate() AS [IF_RCV_DATE]
           ,'N' AS [PROC_FLAG]
           ,NULL AS [PROC_DATE]
           ,NULL AS [PROC_MSG]
           ,[ITEM_ID]
           ,[PALLET_ID]
           ,[STOCK_QTY]
           ,[AVAILABLE_QTY]
           ,[NON_QC_QTY]
           ,[ALLOCATION_QTY]
           ,[BLOCK_QTY]
           ,[PACKING_QTY]
           ,[MOVING_QTY]
           ,[RCVLOC_QTY]
           ,[EXPIRATION_QTY]
           ,[LONG_QTY]
           ,[PROD_GROUP]
           ,[LOT_ID]
           ,[PLANT_ID]
           ,[GRADE]
           ,[PACKING_STATUS]
           ,[STOCK_STATUS]
           ,[STORAGE_ID]
           ,[CUSTOMER_CODE]
           ,[CUSTOMER_NAME]
           ,[LOT_DATE]
           ,[SOC]
           ,[CAPACITY_GRADE]
           ,GetDate() AS [CREATE_DATE]
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

			  FROM @p_param ;
      
		--		-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO SY_XIF_ERP_EXFACTORY_RESULT_R';
				SET @v_description = '@neif00305' 
				SET @d_event_date  = SYSDATETIME();
				--EXEC PR_XIF_LOG @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description,NULL, @d_event_date;

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
				--EXEC PR_XIF_LOG @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description,NULL, @d_event_date;
        END CATCH      

		-- 종료 LOG
		SET @v_log_type    = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();
		--EXEC PR_XIF_LOG @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description,NULL, @d_event_date;

        SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

        SET NOCOUNT OFF

END






