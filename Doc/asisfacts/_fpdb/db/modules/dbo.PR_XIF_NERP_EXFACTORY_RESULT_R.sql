
/*
 * Program ID   : [PR_PP_XIF_ERP_EXFACTORY_RESULT_R]
 * Description  : GERP Call Off 수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/05/09	chkim.68		Create Receive Table (NPP0132 Erp Route (Receive this, After work PR_XIF_ERP_EXFACTORY_RESULT_R by NPP0132 pp
 *
 */
CREATE PROCEDURE [dbo].[PR_XIF_NERP_EXFACTORY_RESULT_R]
    @p_param 		AS DBO.PARAM_XIF_ERP_EXFACTORY_RESULT_R       READONLY	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'NLE0030';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_PP_XIF_ERP_EXFACTORY_RESULT_R';
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

		--EXEC PR_XIF_LOG @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description,NULL, @d_event_date;

        BEGIN TRY
			BEGIN TRAN
               
			INSERT INTO [dbo].[SY_XIF_ERP_EXFACTORY_RESULT_R]
					   (
					[IFSEQNO]
      ,[SO_NO]
      ,[SO_ITEM_SEQ]
      ,[ORDER_TYPE]
      ,[ORDER_TYPE_NAME]
      ,[COMPANY]
      ,[DIVISION]
      ,[PLANT_ID]
      ,[SLOC]
      ,[ORDER_CREATE_DATE]
      ,[PO_NO]
      ,[BILLTO_CODE]
      ,[BILTO_NAME]
      ,[SHIPTO_CODE]
      ,[SHIPTO_NAME]
      ,[DELIVERY_DATE]
      ,[DELIVERY_NO]
      ,[DELIVERY_PARTNO]
      ,[ITEM_ID]
      ,[ITEM_NAME]
      ,[ORDER_QTY]
      ,[UOM]
      ,[EXFACTORY_QTY]
      ,[ON_BOARD_DATE]
      ,[ETD]
      ,[ETA]
      ,[ACTUAL_EXFACTORY_DATE]
      ,[SYSTEM_EXFACTORY_DATE]
      ,[DOC_TYPE]
      ,[DOC_SEQ]
      ,[TRNF_DATE]
      ,[TRNF_TIME]
      ,[TRANSFER_FLAG]
      ,[TRANSFER_DATE]
      ,[CREATE_USER_ID]
      ,[CREATE_DATE]
      ,[MODIFY_USER_ID]
      ,[MODIFY_DATE]
      ,[PROJECT_CD]
      ,[TRANSPORT_MODE]
      ,[INCOTERMS]
      ,[PLANT_ISSUE_DATE]
      ,[SSP_TYPE]
      ,[CONFIRM_ID]
      ,[PLAN_EXFACTORY_DATE]
      ,[ACTUAL_DELIVERY_DATE]
      ,[INTRANSIT_DATE]
      ,[FACTORY_OUT_DATE]
      ,[CURRENCY_CODE]
      ,[NET_PRICE]
      ,[SALES_AMOUNT]
      ,[KRW_XRATE]
      ,[SALES_KRW_AMOUNT]   
      ,[ATTRIBUTE1]
      ,[ATTRIBUTE2]
      ,[ATTRIBUTE3]
      ,[ATTRIBUTE4]
      ,[ATTRIBUTE5]
	

					   )
				 SELECT 			 
				 			[IFSEQNO]
      ,[SO_NO]
      ,[SO_ITEM_SEQ]
      ,[ORDER_TYPE]
      ,[ORDER_TYPE_NAME]
      ,[COMPANY]
      ,[DIVISION]
      ,[PLANT_ID]
      ,[SLOC]
      ,[ORDER_CREATE_DATE]
      ,[PO_NO]
      ,[BILLTO_CODE]
      ,[BILTO_NAME]
      ,[SHIPTO_CODE]
      ,[SHIPTO_NAME]
      ,[DELIVERY_DATE]
      ,[DELIVERY_NO]
      ,[DELIVERY_PARTNO]
      ,[ITEM_ID]
      ,[ITEM_NAME]
      ,[ORDER_QTY]
      ,[UOM]
      ,[EXFACTORY_QTY]
      ,[ON_BOARD_DATE]
      ,[ETD]
      ,[ETA]
      ,[ACTUAL_EXFACTORY_DATE]
      ,[SYSTEM_EXFACTORY_DATE]
      ,[DOC_TYPE]
      ,[DOC_SEQ]
      ,[TRNF_DATE]
      ,[TRNF_TIME]
      ,'N' AS [TRANSFER_FLAG]
      ,GetDate() AS [TRANSFER_DATE]
      ,'NLE0030_PP' AS [CREATE_USER_ID]
      ,GetDate() AS [CREATE_DATE]
      ,NULL AS [MODIFY_USER_ID]
      ,NULL AS [MODIFY_DATE]
      ,[PROJECT_CD]
      ,[TRANSPORT_MODE]
      ,[INCOTERMS]
      ,[PLANT_ISSUE_DATE]
      ,[SSP_TYPE]
      ,[CONFIRM_ID]
      ,[PLAN_EXFACTORY_DATE]
      ,[ACTUAL_DELIVERY_DATE]
      ,[INTRANSIT_DATE]
      ,[FACTORY_OUT_DATE]
      ,[CURRENCY_CODE]
      ,[NET_PRICE]
      ,[SALES_AMOUNT]
      ,[KRW_XRATE]
      ,[SALES_KRW_AMOUNT]   
      ,[ATTRIBUTE1]
      ,[ATTRIBUTE2]
      ,[ATTRIBUTE3]
      ,[ATTRIBUTE4]
      ,[ATTRIBUTE5]
				  FROM @p_param ;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO SY_XIF_ERP_EXFACTORY_RESULT_R';
				SET @v_description = '@NLE0030' 
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






