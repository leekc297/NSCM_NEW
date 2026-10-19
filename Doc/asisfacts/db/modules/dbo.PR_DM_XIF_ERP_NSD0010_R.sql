
/*================================================================================================================================
 * Program ID   : PR_DM_XIF_ERP_NSD0010_R
 * Description  : NERP EDI Call Off 수신
 * Program History
 *================================================================================================================================
 *   Date       In Charge      Description
 *================================================================================================================================
 * 2024.11.04	KANG.H.J		[PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 - NERP 대응 
 * 2025.10.22	JSSBAE			[E20251016-001453]_ERP NN Mapping 데이터 반영 수행시간 단축 및 로그 보완
 * 2026.07.06	JSSBAE			[E20260701-001086]_ERP NN Master 프로시저 쿼리 튜닝 요청
 *================================================================================================================================*/
CREATE PROCEDURE [dbo].[PR_DM_XIF_ERP_NSD0010_R]
	  @ET_CUST_DEMAND_MAPPING				AS DBO.ET_CUST_DEMAND_MAPPING        READONLY	          
AS

BEGIN

SET NOCOUNT ON;

	DECLARE @TRANSFER_UPDATE_DATE	NVARCHAR(8)		= CONVERT(VARCHAR(8), GETDATE(), 112);
    DECLARE @TRANSFER_UPDATE_TIEM	NVARCHAR(6)		= REPLACE(CONVERT(VARCHAR(8), GETDATE(), 108),':','');
    DECLARE @TRANSFER_UPDATE_ID		NVARCHAR(12)	= 'XIF_NSD0010';
    DECLARE @TRANSFER_FLAG			NVARCHAR(50)	= 'N';
    DECLARE @E_TYPE					NVARCHAR(50)	= N'S'; --메시지 유형: S 성공, E 오류
    DECLARE @E_MESSAGE				NVARCHAR(100)	= N'SUCCESS';
	
	--================================================================================================================================	
	-- LOG 용 변수 설정 (START)
	--================================================================================================================================	
	DECLARE @v_batch_user			NVARCHAR(150)	= 'scm_batch';
	DECLARE @v_program_name			NVARCHAR(150)	= 'PR_DM_XIF_ERP_NSD0010_R';
	DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
	DECLARE @n_log_count			INTEGER = 0;
	DECLARE @v_log_message			NVARCHAR(1000);
	DECLARE @v_description			NVARCHAR(500);
	DECLARE @d_event_date			DATETIME;
	DECLARE @v_ifseqno				NVARCHAR(30); 
	DECLARE @n_history_seq			BIGINT;

	--================================================================================================================================	
	-- LOG 용 변수 설정 (END)
	--================================================================================================================================	

	DECLARE @COUNT					INT
	SELECT	@COUNT = COUNT(*) FROM @ET_CUST_DEMAND_MAPPING     

	BEGIN	
		--================================================================================================================================
		-- 시작 LOG (START)
		--================================================================================================================================
		SET @v_log_type			= 'START';
		SET @v_log_message		= '########## Start of procedure ##########';
		SET @v_description		= '';
		SET @d_event_date		= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--================================================================================================================================
		-- 시작 LOG (END)
		--================================================================================================================================

		BEGIN TRY
			BEGIN
				SET		@COUNT = 0
				SELECT	@COUNT = COUNT(*) FROM @ET_CUST_DEMAND_MAPPING
				--SET @v_description = + 'ET_CUST_DEMAND_MAPPING I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT)--, @@ROWCOUNT)
				--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
				------------------------------------------------------------------------------------------------------------------------------------
				-- ET_CUST_DEMAND_MAPPING I/F COUNT LOG (START)
				------------------------------------------------------------------------------------------------------------------------------------
				SET @v_log_type		= 'APPEND';
				SET @v_log_message	= N'ET_CUST_DEMAND_MAPPING I/F COUNT';
				SET @v_description	= + 'ET_CUST_DEMAND_MAPPING I/F COUNT : ' + CONVERT(VARCHAR(10), @COUNT)--, @@ROWCOUNT)
				SET @d_event_date	= SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				------------------------------------------------------------------------------------------------------------------------------------
				-- ET_CUST_DEMAND_MAPPING I/F COUNT LOG (END)
				------------------------------------------------------------------------------------------------------------------------------------

				DECLARE @SCM_IF_NR NVARCHAR(30)
				SELECT	@SCM_IF_NR = SCM_IF_NR FROM @ET_CUST_DEMAND_MAPPING GROUP BY SCM_IF_NR
				--SET @v_description = + 'SCM_IF_NR : ' + CONVERT(VARCHAR(30), ISNULL(@SCM_IF_NR, 'NO COUNT'))--, @@ROWCOUNT)
				--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
				------------------------------------------------------------------------------------------------------------------------------------
				-- XIF_CUST_DEMAND_MAPPING_MST_R_SN SCM_IF_NR LOG (START)
				------------------------------------------------------------------------------------------------------------------------------------
				SET @v_log_type		= 'APPEND';
				SET @v_log_message	= N'XIF_CUST_DEMAND_MAPPING_MST_R_SN 데이터 적재 START';
				SET @v_description	= + 'SCM_IF_NR : ' + CONVERT(VARCHAR(30), ISNULL(@SCM_IF_NR, 'NO COUNT'))--, @@ROWCOUNT)
				SET @d_event_date	= SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				------------------------------------------------------------------------------------------------------------------------------------
				-- XIF_CUST_DEMAND_MAPPING_MST_R_SN SCM_IF_NR LOG (END)
				------------------------------------------------------------------------------------------------------------------------------------
				
				------------------------------------------------------------------------------------------------------------------------------------
				-- XIF_CUST_DEMAND_MAPPING_MST_R_SN DATA INSERT (START)
				------------------------------------------------------------------------------------------------------------------------------------
				INSERT INTO [XIF_CUST_DEMAND_MAPPING_MST_R_SN]
				( [IF_SEQ], [SEQ], [ERP_SA_ORG_ID], [DISTRB_CHNL_CD], [DIVISION_ID], [SOLDTO_CODE], [SHIPTO_CODE], [UNLOADING_POINT]
				, [CUSTOMER_PLANT], [CUST_MATERIAL_CODE], [ITEM_ID], [VALID_FROM_DATE], [VALID_TO_DATE], [TRANSFER_DATE], [TRANSFER_FLAG] )
				SELECT DISTINCT [SCM_IF_NR]	AS [IF_SEQ], [SEQ], [VKORG] AS [ERP_SA_ORG_ID], [VTWEG] AS [DISTRB_CHNL_CD], [SPART] AS [DIVISION_ID], [KUNAG] AS [SOLDTO_CODE], [KUNWE] AS [SHIPTO_CODE], [ABLAD] AS [UNLOADING_POINT]
							  , [KNREF]	AS [CUSTOMER_PLANT], [KDMAT] AS [CUST_MATERIAL_CODE], [MATNR] AS [ITEM_ID], [DATAB]	AS [VALID_FROM_DATE], [DATBI] AS [VALID_TO_DATE], GETDATE()	AS [TRANSFER_DATE], 'N' AS [TRANSFER_FLAG]
				FROM @ET_CUST_DEMAND_MAPPING ;
				------------------------------------------------------------------------------------------------------------------------------------
				-- XIF_CUST_DEMAND_MAPPING_MST_R_SN DATA INSERT (END)
				------------------------------------------------------------------------------------------------------------------------------------
				
				------------------------------------------------------------------------------------------------------------------------------------
				-- APPEND LOG (START)
				------------------------------------------------------------------------------------------------------------------------------------
				SET @v_log_type    = 'APPEND';
				SET @v_log_message = N'XIF_CUST_DEMAND_MAPPING_MST_R_SN 데이터 적재';
				SET @v_description = + N'[XIF_CUST_DEMAND_MAPPING_MST_R_SN] : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				------------------------------------------------------------------------------------------------------------------------------------
				-- APPEND LOG (END)
				------------------------------------------------------------------------------------------------------------------------------------
			END
				
			-- [E20260701-001086]_웹서비스 자기 본분에 맞는 역할을 하도록 수정한다. ERP -> SCM 데이터 Insert 작업까지만 한다. 주석처리 (START)
			-- 해당 작업은 [JOB.PR_DM_CUST_MODEL_MAPPING_IF] 작업에서 수행하도록 따로 뺌
			/*
			------------------------------------------------------------------------------------------------------------------------------------
			-- PR_DM_CUST_MODEL_MAPPING_IF 호출 START LOG (START)
			------------------------------------------------------------------------------------------------------------------------------------
			SET @v_log_type    = 'APPEND';
			SET @v_log_message = N'PR_DM_CUST_MODEL_MAPPING_IF 호출 START';
			SET @v_description = + N'PR_DM_CUST_MODEL_MAPPING_IF 호출 START  '
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------------------------------------------------------------------
			-- PR_DM_CUST_MODEL_MAPPING_IF 호출 START LOG (START)
			------------------------------------------------------------------------------------------------------------------------------------				
			------------------------------------------------------------------------------------------------------------------------------------
			-- ERP I/F -> SCM DATA INSERT
			------------------------------------------------------------------------------------------------------------------------------------
			-- EXEC PR_DM_CUST_MODEL_MAPPING_IF 'ERP'	;				
			------------------------------------------------------------------------------------------------------------------------------------
			-- PR_DM_CUST_MODEL_MAPPING_IF 호출 END LOG (START)
			------------------------------------------------------------------------------------------------------------------------------------
			SET @v_log_type    = 'APPEND';
			SET @v_log_message = N'PR_DM_CUST_MODEL_MAPPING_IF 호출 END';
			SET @v_description = + N'PR_DM_CUST_MODEL_MAPPING_IF 호출 END  '
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			------------------------------------------------------------------------------------------------------------------------------------
			-- PR_DM_CUST_MODEL_MAPPING_IF 호출 END LOG (START)
			------------------------------------------------------------------------------------------------------------------------------------
			*/
			-- [E20260701-001086]_웹서비스 자기 본분에 맞는 역할을 하도록 수정한다. ERP -> SCM 데이터 Insert 작업까지만 한다. 주석처리 (END)
		END TRY

		BEGIN CATCH
			ROLLBACK TRAN;
			SET @E_TYPE		= 'E';
			SET @E_MESSAGE	= ERROR_MESSAGE();
				
			--================================================================================================================================
			-- ERROR LOG (START)
			--================================================================================================================================
			SET @v_log_type		= 'ERROR';
			SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description	= 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
			SET @d_event_date	= SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			--================================================================================================================================
			-- ERROR LOG (END)
			--================================================================================================================================
		END CATCH      
		
		--================================================================================================================================
		-- 종료 LOG (START)
		--================================================================================================================================
		SET @v_log_type		= 'END';
		SET @v_log_message	= '########## END of procedure ##########';
		SET @v_description	= + 'I/F COUNT : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--================================================================================================================================
		-- 종료 LOG (END)
		--================================================================================================================================
		
		--================================================================================================================================
		-- 실패 메시지 전달
		--================================================================================================================================
		SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE

		SET NOCOUNT OFF		
	END	
END

