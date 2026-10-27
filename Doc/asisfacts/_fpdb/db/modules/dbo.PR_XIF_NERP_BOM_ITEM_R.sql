
/*
 * Program ID   : [PR_PP_XIF_ERP_BOM_ITEM_R]
 * Description  : NERP BOM ITEM  수신
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description (
 *===================================================================================================
 * 2024/06/24	chkim.68		Create Receive Table (NPP0133 Erp BOM ITEM  (Receive this, After work PR_XIF_ERP_BOM_ITEM_R by NPP0133 pp
 * NPP0133 Consists BOH HEADER + BOM ITEM
 *
 */
CREATE PROCEDURE [dbo].[PR_XIF_NERP_BOM_ITEM_R]
    @p_param 		AS DBO.PARAM_XIF_ERP_BOM_ITEM_R       READONLY	                            
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'NPP0133';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_XIF_NERP_BOM_ITEM_R';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;
		DECLARE @v_ifseqno      NVARCHAR(30); 
		DECLARE @n_history_seq  BIGINT;

		--DECLARE @if_seq_table table ( ifseqno Nvarchar(40))

		-- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();
		
		-- ERROR_LINE
		DECLARE @v_temp1     NVARCHAR(1000)
		DECLARE @v_temp2     NVARCHAR(1000)

		SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
		SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

		EXEC PR_XIF_LOG @v_program_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @d_event_date
        BEGIN TRY
			BEGIN TRAN

			--;INSERT INTO @if_seq_table (IFSEQNO) select ifseqno from @p_param
               
			INSERT INTO [dbo].[SY_XIF_ERP_BOM_ITEM_R]
					   ( 
 [IFSEQNO]
      ,[COMPANY]
      ,[DIVISION]
      ,[SITE_ID]
      ,[PLANT_ID]
      ,[PARENT_ITEM_ID]
      ,[BOM_VERSION]
      ,[KEYDATE]
      ,[PRODUCE_QTY]
      ,[PARENT_ITEM_UOM]
      ,[BOM_NO]
      ,[CHILD_ITEM_ID]
      ,[CONSUME_QTY]
      ,[CHILD_ITEM_UOM]
      ,[ECO_NUMBER]
      ,[EFF_START_DATE]
      ,[EFF_END_DATE]
      ,[ALTERNATE]
      ,[ALTERYN]
      ,[PRIORITY]
      ,[PHANTOM]
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
      ,[USE_RATE]
      ,[BOM_USAGE]
					   )
				 SELECT 
 [IFSEQNO]
      ,[COMPANY]
      ,[DIVISION]
      ,[SITE_ID]
      ,[PLANT_ID]
      ,[PARENT_ITEM_ID]
      ,[BOM_VERSION]
      ,[KEYDATE]
      ,[PRODUCE_QTY]
      ,[PARENT_ITEM_UOM]
      ,[BOM_NO]
      ,[CHILD_ITEM_ID]
      ,[CONSUME_QTY]
      ,[CHILD_ITEM_UOM]
      ,[ECO_NUMBER]
      ,[EFF_START_DATE]
      ,[EFF_END_DATE]
      ,[ALTERNATE]
      ,[ALTERYN]
      ,[PRIORITY]
      ,[PHANTOM]
      ,'T' AS [TRANSFER_FLAG]
      ,GetDate() AS [TRANSFER_DATE]
      ,'NPP0133' AS [CREATE_USER_ID]
      ,GetDate() AS [CREATE_DATE]
      ,'NPP0133' AS [MODIFY_USER_ID]
      ,GetDate() AS [MODIFY_DATE]
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
      ,[USE_RATE]
      ,[BOM_USAGE]

				  FROM @p_param ;
      
				-- HISTORY LOG    
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = 'TXN';
				SET @v_log_message = 'INSERT INTO XIF_ERP_BOM_ITEM_R';
				SET @v_description = '@NPP0133' 
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
				EXEC PR_XIF_LOG @v_program_name, NULL, 'ERROR', NULL, @v_description, '############### Start of procedure ###############', NULL, @d_event_date
        END CATCH      



		-- 종료 LOG
		SET @v_log_type    = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();

		EXEC PR_XIF_LOG @v_program_name, NULL, 'END', NULL, @v_temp2, '############### End of procedure ###############', NULL, @d_event_date

        SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE
		-- SELECT IFSEQNO just receive
		select ifseqno from dbo.SY_XIF_ERP_BOM_ITEM_R with(nolock) where  TRANSFER_FLAG = 'T' 
	    group by ifseqno
		-- Update Ifseqno to 'N'
		update dbo.SY_XIF_ERP_BOM_ITEM_R set TRANSFER_FLAG = 'N' where transfer_flag = 'T'


        SET NOCOUNT OFF

END






