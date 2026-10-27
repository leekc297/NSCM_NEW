
/*
 * Program ID   : [PR_PP_XIF_ERP_INVENTORY_R]
 * Description  : GERP WORK ORDER 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/05/27	chkim.68		Create Receive Table (NPP0214 Erp Work Order
 * * 2025-03-21   chkim.68        긴급 수정 (Q 재고)
 */
CREATE PROCEDURE [dbo].[PR_XIF_NERP_INVENTORY_R]
    @p_param 		AS DBO.PARAM_XIF_ERP_INVENTORY_R       READONLY	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'NPP0214';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_PP_XIF_ERP_INVENTORY_R';
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
               
			INSERT INTO [dbo].[SY_XIF_ERP_INVENTORY_R]
					   (
[IFSEQNO]
      ,[COMPANY]
      ,[DIVISION]
      ,[PLANT_ID]
      ,[BUILDING]
      ,[ITEM_ID]
      ,[SLOC]
      ,[VENDOR_CODE]
      ,[EX_DATE]
      ,[EX_TIME]
      ,[GOOD_QTY]
      ,[DEFECT_QTY]
      ,[HOLD_QTY]
      ,[QT_ISP_QTY]
      ,[UOM]
      ,[TRANSFER_FLAG]
      ,[TRANSFER_DATE]
      ,[CREATE_USER_ID]
      ,[CREATE_DATE]
      ,[MODIFY_USER_ID]
      ,[MODIFY_DATE]
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
      ,[ATTRIBUTE11]
      ,[ATTRIBUTE12]
      ,[ATTRIBUTE13]
      ,[ATTRIBUTE14]
      ,[ATTRIBUTE15]
      ,[MOVING_QTY] )
				 SELECT 			 
	[IFSEQNO]
      ,[COMPANY]
      ,[DIVISION]
      ,[PLANT_ID]
      ,[BUILDING]
      ,[ITEM_ID]
      ,[SLOC]
      ,[VENDOR_CODE]
      ,[EX_DATE]
      ,[EX_TIME]
      ,[GOOD_QTY]
      ,[DEFECT_QTY]
      ,[HOLD_QTY]
      ,[QT_ISP_QTY]
      ,[UOM]
      ,'N' AS [TRANSFER_FLAG]
      ,GetDate() AS [TRANSFER_DATE]
      ,'NPP0214_pp' AS [CREATE_USER_ID]
      ,GetDate() AS [CREATE_DATE]
      ,null AS [MODIFY_USER_ID]
      ,null AS [MODIFY_DATE]
      ,[FROM_PLANT_ID] AS [ATTRIBUTE1]
      ,[RESTRICT_QTY] AS [ATTRIBUTE2]
      ,CUSTOMER_ID AS [ATTRIBUTE3]
      ,SPECIAL_STOCK_INDICATOR AS [ATTRIBUTE4]
      ,null as [ATTRIBUTE5]
      ,null as [ATTRIBUTE6]
      ,null as [ATTRIBUTE7]
      ,null as [ATTRIBUTE8]
      ,null as [ATTRIBUTE9]
      ,null as [ATTRIBUTE10]
      ,null as [ATTRIBUTE11]
      ,null as [ATTRIBUTE12]
      ,null as [ATTRIBUTE13]
      ,null as [ATTRIBUTE14]
      ,null as [ATTRIBUTE15]
      ,[MOVING_QTY]
     
				  FROM @p_param ;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO SY_XIF_ERP_INVENTORY_R';
				SET @v_description = '@NPP0214' 
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






