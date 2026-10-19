
/*
 * Program ID   : PR_DM_XIF_ERP_PR_DETAIL_S
 * Description  : NERP 대응 관련 신규I/F 
 *                DM_PLN_PR_DETAIL -> XIF_ERP_PR_DETAIL_S_SN 테이블로 I/F 처리 Procedure
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2024.11.11	P.C.I			[PJ20228272] NERP 대응
 * ---------------------------------------------------------------------------------------------------
 * 	● 제약 조건 상세화 (DM → NERP)
 * 	- ESS 사업부만 대상
 *  - DM -> SSP로 전송되는 데이터를 NERP에 그대로 전송
 *  - REQUEST_NO 기준으로 데이터 생성
 * ---------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_DM_XIF_ERP_PR_DETAIL_S]

	-- Add the parameters for the stored procedure here
	@P_REQUEST_NO			NVARCHAR(MAX)   -- REQUEST_NO 전달받음

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- 변수 설정
    DECLARE @V_TRANSFER_FLAG        NVARCHAR(1)  = 'N'; -- IF_FLAG 인터페이스전송상태 (N:미처리,P:처리중,Y:처리완료) 
    DECLARE @V_TRANSFER_DATE        DATETIME = GETDATE(); -- IF_FLAG 인터페이스전송시간
	DECLARE @V_SEND_TIME			NVARCHAR(50) = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_XIF_ERP_PR_DETAIL_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


		-- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = @V_TRANSFER_DATE;

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 트랜잭션 (START)
		BEGIN TRANSACTION 

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		-- I/F 테이블에 INSERT 처리
		BEGIN

			INSERT INTO XIF_ERP_PR_DETAIL_S_SN
					( SEND_TIME
					, SERI_NO
					, REQUEST_NO
					, ITEM_SEQ
					, DIVISION_ID
					, PROJECT_CODE
					, SCM_SITE_ID
					, ITEM_ID
					, DOM_EXP
					, FCST_TYPE
					, INCOTERMS
					, PLANT_SITE_ID
					, REQ_YYYYMMDD
					, YYYYMMDD
					, UOM
					, PLAN_QTY
					, STORAGE_ID
					, STORAGE_PLANT_ID
					, PUCH_MGR
					, PUCH_GROUP
					, PR_HEADER
					, PR_ITEM_DETAIL
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
					, SSP_TRANSFER_FLAG
					, TRANSFER_FLAG
					, TRANSFER_DATE
										)
			SELECT @V_SEND_TIME
			     , ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS SERI_NO
			     , REQUEST_NO
				 , ITEM_SEQ
				 , DIVISION_ID
				 , PROJECT_CODE
				 , SCM_SITE_ID
				 , ITEM_ID
				 , DOM_EXP
				 , FCST_TYPE
				 , INCOTERMS
				 , PLANT_SITE_ID
				 , SUBSTRING(REQUEST_NO, 1, 8) AS REQ_YYYYMMDD
				 , YYYYMMDD
				 , UOM
				 , PLAN_QTY
				 , STORAGE_ID
				 , STORAGE_PLANT_ID
				 , PUCH_MGR
				 , PUCH_GROUP
				 , PR_HEADER
				 , PR_ITEM_DETAIL
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
				 , SSP_TRANSFER_FLAG
				 , @V_TRANSFER_FLAG
				 , @V_TRANSFER_DATE
			FROM   DM_PLN_PR_DETAIL WITH(NOLOCK)
			WHERE  REQUEST_NO = @P_REQUEST_NO 



		END
		
		-- HISTORY LOG    
		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'INSERT INTO XIF_ERP_PR_DETAIL_S_SN';
		SET @v_description = '@P_REQUEST_NO : ' +  @P_REQUEST_NO;
		SET @d_event_date  = @V_TRANSFER_DATE;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
  		-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION 
			
		-- ERROR LOG
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
		SET @d_event_date  = @V_TRANSFER_DATE;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	
		
	-- 종료 LOG
	SET @v_log_type    = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = ''
	SET @d_event_date  = @V_TRANSFER_DATE;
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

