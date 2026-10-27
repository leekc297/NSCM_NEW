

/*
 * Program ID   : [PR_XIF_NERP_MRP_OUT_ITEM_CONSUM_R]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025/11/30	OHIJ		Receive MRP Bps Mat Plan Info (NMM0273)
 *
 */
CREATE PROCEDURE [dbo].[PR_XIF_NERP_MRP_OUT_ITEM_CONSUM_R]
    @p_param 		AS DBO.PARAM_XIF_MRP_OUT_ITEM_CONSUM_R       READONLY	                            
AS
BEGIN

SET NOCOUNT ON;
		print '[PR_XIF_NERP_MRP_OUT_ITEM_CONSUM_R]'
        DECLARE @TRANSFER_DATE        DATETIME      = GETDATE();    
        DECLARE @TRANSFER_FLAG        NVARCHAR(50)  = 'N';

        DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
        DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';

		-- LOG 용 변수 설정
		DECLARE @v_batch_user   NVARCHAR(150) = 'NMM0273';
		DECLARE @v_program_name NVARCHAR(150) = 'PR_XIF_NERP_MRP_OUT_ITEM_CONSUM_R';
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
               
			INSERT INTO [LGCE_INF].[dbo].[XIF_MRP_TB_RS_ITEM_CONSUM_R] (
			IF_SEQ
			, IF_TYPE
			, IF_ID
			, IF_RCV_DATE
			, PROC_FLAG
			, PROC_DATE
			, PROC_MSG
			, VRSN_ID
			, PLAN_TYP
			, BUCKET_TYP
			, MRP_GRP_CD
			, MRP_CD
			, PROD_PLAN_CD
			, PLANT_CD
			, DONG_CD
			, OPER_CD
			, LINE_CD
			, WC_CD
			, PROD_TYP
			, MKT_FLAG
			, ITEM_CD
			, P_ITEM_CD
			, BASE_UOM
			, CONSUM_DT
			, CONSUM_YWK
			, CONSUM_YPWK
			, CONSUM_YYYYMM
			, CONSUM_QTY
			, MDM_CD
			, PJCT_NICK_NM
			, CUM_C_UNIT_QTY
			, MODEL_CD
			, CELL_PLANT_CD
			, PLAN_VRSN_ID
			, PLAN_SRC_TYP
			, ATTRBT_1_VAL
			, ATTRBT_2_VAL
			, ATTRBT_3_VAL
			, ATTRBT_4_VAL
			, ATTRBT_5_VAL
			, ATTRBT_6_VAL
			, ATTRBT_7_VAL
			, ATTRBT_8_VAL
			, ATTRBT_9_VAL
			, REG_DTTM
			, REG_USER_ID
			, CHNG_DTTM
			, CHNG_USER_ID
			, ACCUM_COUNT
			, ACCUM_DATE
			, BIZ_NM
			, CUR_CD
			, UNIT_PRICE
			)
			SELECT 	
			IF_SEQ
			, IF_TYPE
			, IF_ID
			, GetDate() AS IF_RCV_DATE
			, 'N' AS PROC_FLAG
			, NULL AS PROC_DATE
			, NULL AS PROC_MSG
			, VRSN_ID
			, PLAN_TYP
			, BUCKET_TYP
			, MRP_GRP_CD
			, MRP_CD
			, PROD_PLAN_CD
			, PLANT_CD
			, DONG_CD
			, OPER_CD
			, LINE_CD
			, WC_CD
			, PROD_TYP
			, MKT_FLAG
			, ITEM_CD
			, P_ITEM_CD
			, BASE_UOM
			, CONSUM_DT
			, CONSUM_YWK
			, CONSUM_YPWK
			, CONSUM_YYYYMM
			, CONSUM_QTY
			, MDM_CD
			, PJCT_NICK_NM
			, CUM_C_UNIT_QTY
			, MODEL_CD
			, CELL_PLANT_CD
			, PLAN_VRSN_ID
			, PLAN_SRC_TYP
			, ATTRBT_1_VAL
			, ATTRBT_2_VAL
			, ATTRBT_3_VAL
			, ATTRBT_4_VAL
			, ATTRBT_5_VAL
			, ATTRBT_6_VAL
			, ATTRBT_7_VAL
			, ATTRBT_8_VAL
			, ATTRBT_9_VAL
			, GetDate() AS REG_DTTM
			, REG_USER_ID
			, GetDate() AS CHNG_DTTM
			, CHNG_USER_ID
			, ACCUM_COUNT
			, ACCUM_DATE
			, BIZ_NM
			, CUR_CD
			, UNIT_PRICE
			FROM @p_param ;
      
			-- HISTORY LOG    
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = 'TXN';
			SET @v_log_message = 'INSERT INTO PR_XIF_NERP_MRP_OUT_ITEM_CONSUM_R';
			SET @v_description = '@NMM0273' 
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






