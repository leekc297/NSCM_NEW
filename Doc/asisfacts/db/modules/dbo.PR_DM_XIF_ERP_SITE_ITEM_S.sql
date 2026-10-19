
/*
 * Program ID   : PR_DM_XIF_ERP_SITE_ITEM_S
 * Description  : NERP 대응 관련 신규I/F 
 *                SCM_MST_SITE_ITEM -> XIF_ERP_SITE_ITEM_S_SN 테이블로 I/F 처리 Procedure
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2024.11.11	P.C.I			[PJ20228272] NERP 대응
 * ---------------------------------------------------------------------------------------------------
 * 	● 제약 조건 상세화 (DM → NERP)
 * 	- 자동차 사업부만 대상
 *  - SCM_MST_SITE_ITEM에 신규로 추가되는 데이터를 NERP에 전송
 *  - #XIF_ERP_SITE_ITEM 기준으로 데이터 생성
 * ---------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_DM_XIF_ERP_SITE_ITEM_S]

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- 변수 설정
    DECLARE @V_TRANSFER_FLAG        NVARCHAR(1)  = 'N'; -- IF_FLAG 인터페이스전송상태 (N:미처리,P:처리중,Y:처리완료) 
    DECLARE @V_TRANSFER_DATE        DATETIME = GETDATE(); -- IF_FLAG 인터페이스전송시간
	DECLARE @V_SEND_TIME			NVARCHAR(50) = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');
	DECLARE @V_INPUT_COUNT			INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_XIF_ERP_SITE_ITEM_S';
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

		SELECT @V_INPUT_COUNT = COUNT(*) 
		FROM #XIF_ERP_SITE_ITEM WITH(NOLOCK);

		IF( @V_INPUT_COUNT ) > 0 

		-- I/F 테이블에 INSERT 처리
		BEGIN
		
			INSERT INTO XIF_ERP_SITE_ITEM_S_SN
					  ( SEND_TIME
					  , SERI_NO
					  , DIVISION_ID
					  , SCM_SITE_ID
					  , END_CUSTOMER
					  , SOLDTO_CODE
					  , SHIPTO_CODE
					  , PROJECT_CODE
					  , ITEM_ID
					  , CREATED_BY
					  , CREATION_DATE
					  , LAST_UPDATED_BY
					  , LAST_UPDATE_DATE
					  , TRANSFER_FLAG
					  , TRANSFER_DATE
					  )
			SELECT @V_SEND_TIME
			     , ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS SERI_NO
				 , XESI.DIVISION_ID
				 , XESI.SCM_SITE_ID
				 , SMS.END_CUSTOMER
				 , SMSC.SOLDTO_CODE
				 , SMSC.SHIPTO_CODE
				 , XESI.PROJECT_CODE
				 , XESI.ITEM_ID
				 , XESI.CREATED_BY
				 , XESI.CREATION_DATE
				 , XESI.LAST_UPDATED_BY
				 , XESI.LAST_UPDATE_DATE
				 , @V_TRANSFER_FLAG
				 , @V_TRANSFER_DATE
			FROM   #XIF_ERP_SITE_ITEM XESI WITH(NOLOCK)
			LEFT JOIN SCM_MST_SITE   SMS  WITH(NOLOCK)
			ON     XESI.DIVISION_ID = SMS.DIVISION_ID
			AND    XESI.SCM_SITE_ID = SMS.SCM_SITE_ID
			LEFT JOIN SCM_MST_SITE_CUSTOMER   SMSC  WITH(NOLOCK)
			ON     XESI.DIVISION_ID = SMSC.DIVISION_ID
			AND    XESI.SCM_SITE_ID = SMSC.SCM_SITE_ID
			WHERE  XESI.DIVISION_ID LIKE '81%'
			AND    SMSC.REP_YN = 'Y'
			

		END
		
		-- HISTORY LOG    
		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = 'TXN';
		SET @v_log_message = 'INSERT INTO XIF_ERP_SITE_ITEM_S_SN';
		SET @v_description = '';
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

