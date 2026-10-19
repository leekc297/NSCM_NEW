
/*
 * Program ID   : PR_GSCM_XIF_MRP_NO_USE_3M_OUT_IF_R
 * Description  : NERP IF) NMM0266
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/03/18   vadabi5		   NERP) Initial Release 
 ----------------------------------------------------------------------------------------------------
  select * from XIF_MRP_NO_USE_3M_OUT_IF_R_SN
 */



CREATE PROCEDURE [dbo].[PR_GSCM_XIF_MRP_NO_USE_3M_OUT_IF_R]
    @ZNMMSCP_0266S			AS DBO.ZNMMSCP_0266S       READONLY
AS

BEGIN

SET NOCOUNT ON;

        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';
	
        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_GSCM_XIF_MRP_NO_USE_3M_OUT_IF_R';
		DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @n_log_count    INTEGER = 0;
		DECLARE @v_log_message  NVARCHAR(1000);
		DECLARE @v_description  NVARCHAR(500);
		DECLARE @d_event_date   DATETIME;
		DECLARE @v_ifseqno      NVARCHAR(30); 
		DECLARE @n_history_seq  BIGINT;


		DECLARE @IF_RCV_DATE    datetime = Getdate()
		DECLARE @PROC_FLAG      NVARCHAR(2) = 'N'  -- 2025-07-08 kimcd 오류 보완
		DECLARE @PROC_DATE      datetime = Getdate()
		DECLARE @PROC_MSG		NVARCHAR(30) = NULL


		-- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '@ZNMMSCP_0266S COUNT';
		SET @d_event_date  = SYSDATETIME();
		SELECT @n_log_count = count(*) from @ZNMMSCP_0266S;

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        BEGIN TRY
			BEGIN TRAN
				
				--[XIF_ERP_ATR_R_SN] INSERT
				INSERT INTO [dbo].[XIF_MRP_NO_USE_3M_OUT_IF_R_SN]
						   (     IF_SEQ			,IF_TYPE		,IF_ID
								,IF_RCV_DATE	,PROC_FLAG		,PROC_DATE		,PROC_MSG
								,CMPY_ID		,PLANT_CD		,OPER_NM		
								,MDM_GRP_01_NM	,MDM_GRP_02_NM	,ITEM_CD		,ITEM_NM
								,STOCK_QTY		,CUR_CD			,STOCK_AMT		,BASE_UOM
								,PIC_NO			,PIC_NM
								,ATTR_01		,ATTR_02		,ATTR_03		,ATTR_04		,ATTR_05
						   )
					 SELECT      IF_SEQ			,IF_TYPE		,IF_ID
								,@IF_RCV_DATE	,@PROC_FLAG		,@PROC_DATE		,@PROC_MSG	
								,CMPY_ID		,PLANT_CD		,OPER_NM
								,MDM_GRP_01_NM	,MDM_GRP_02_NM	,ITEM_CD		,ITEM_NM
								,STOCK_QTY		,CUR_CD			,STOCK_AMT		,BASE_UOM
								,PIC_NO			,PIC_NM
								,ATTR01			,ATTR02			,ATTR03			,ATTR04			,ATTR05					   
					  FROM @ZNMMSCP_0266S ;

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
