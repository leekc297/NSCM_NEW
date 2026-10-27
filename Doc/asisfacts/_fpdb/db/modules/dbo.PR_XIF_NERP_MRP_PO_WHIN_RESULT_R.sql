





/*
 * Program ID   : [PR_XIF_NERP_MRP_PO_WHIN_RESULT_R]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025/11/30	OHIJ		Receive MRP Po Whin Info (NMM0274)
 *
 */
CREATE PROCEDURE [dbo].[PR_XIF_NERP_MRP_PO_WHIN_RESULT_R]
    @p_param 		AS DBO.PARAM_XIF_MRP_PO_WHIN_RESULT_R       READONLY	                            
AS
BEGIN

SET NOCOUNT ON;
		print '[PR_XIF_NERP_MRP_PO_WHIN_RESULT_R]'
        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'NMM0274';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_XIF_NERP_MRP_PO_WHIN_RESULT_R';
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
               
			INSERT INTO [LGCE_INF].[dbo].[XIF_MRP_PO_WHIN_RESULT_R] (
				IF_SEQ
				, IF_TYPE
				, IF_ID
				, IF_RCV_DATE
				, PROC_FLAG
				, PROC_DATE
				, PROC_MSG
				, PLANT_CD
				, DOC_YYYYY
				, DOC_NO
				, PO_NO
				, PO_ITEM_NO
				, HOUSE_BL_NO
				, GR_DT
				, GR_QTY
				, REG_DTTM
				, VNDR_CD
				, ITEM_CD
				, VAL_CLASS
				, ACCUM_COUNT
				, ACCUM_DATE
				, ATTR_01
				, ATTR_02
				, ATTR_03
				, ATTR_04
				, ATTR_05
				, ATTR_06
				, ATTR_07
				, ATTR_08
				, ATTR_09
				, ATTR_10
			)
			SELECT 	
			IF_SEQ
			, IF_TYPE
			, IF_ID
			, GetDate() AS IF_RCV_DATE
			, 'N' AS PROC_FLAG
			, NULL AS PROC_DATE
			, NULL AS PROC_MSG
			, PLANT_CD
			, DOC_YYYYY
			, DOC_NO
			, PO_NO
			, PO_ITEM_NO
			, HOUSE_BL_NO
			, GR_DT
			, GR_QTY
			, REG_DTTM
			, VNDR_CD
			, ITEM_CD
			, VAL_CLASS
			, ACCUM_COUNT
			, ACCUM_DATE
			, ATTR_01
			, ATTR_02
			, ATTR_03
			, ATTR_04
			, ATTR_05
			, ATTR_06
			, ATTR_07
			, ATTR_08
			, ATTR_09
			, ATTR_10
			FROM @p_param ;
      
			-- HISTORY LOG    
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = 'TXN';
			SET @v_log_message = 'INSERT INTO PR_XIF_NERP_MRP_PO_WHIN_RESULT_R';
			SET @v_description = '@NMM0274' 
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






