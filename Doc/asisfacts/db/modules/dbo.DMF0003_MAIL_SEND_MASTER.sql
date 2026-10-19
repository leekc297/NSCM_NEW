

/*************************************************************************************************
* Program ID  : DMF0003_MAIL_SEND_MASTER                                            
* Description : Procedure 작성 가이드                                                             
* Usage       : PR Request 자동 생성할 때 사용
* Parameter   :                                                                                  
* 
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2024-01-25   kjj		 신규생성
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_A', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_A', 2
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_B', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_B', 2
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_C', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_C', 2
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_D', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_D', 2
***************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0003_MAIL_SEND_MASTER]

AS  
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_MAIL_SEND_MASTER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_log_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count INTEGER = 0;
    DECLARE @n_input_count     INTEGER = 0;
    DECLARE @n_logo_count      INTEGER = 0;
	DECLARE @n_Invalid_item		nvarchar(50)
	DECLARE @n_msg			nvarchar(1000)
	DECLARE @V_BF_REQ_NO	NVARCHAR(30)
	DECLARE @V_BF_QTY		INT = 0;
	DECLARE @V_THIS_QTY		INT = 0;

	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch'
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 


	--BEGIN TRANSACTION
	BEGIN TRANSACTION 
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------


	--메일발송 주기(케이스 별)
	/*
	*1차
(A) Incoterms= EXW => D-91(13주)
(B) Incoterms = C* or F*, Country=KR => D-119(17주)
(C) Incoterms = D*, Country=JP => D-119(17주)
(D) Incoterms = D*, Country = not KR => D-175(25주)


	*2차
(A) Incoterms= EXW => D-20 (3주 전)
(B) Incoterms = C* or F*, Country=KR => D-48 (7주 전)
(C) Incoterms = D*, Country=JP => D-48 (7주 전)
(D) Incoterms = D*, Country = not KR => D-104 (15주 전)
	*/

EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_A', 1
EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_A', 2
EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_B', 1
EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_B', 2
EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_C', 1
EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_C', 2
EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_D', 1
EXEC DMF0003_MAIL_SEND_AUTO 'TYPE_D', 2



		IF XACT_STATE() > 0 and @@trancount > 0
		BEGIN
			COMMIT TRAN 
		END
	------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- 트랜잭션 (END)
		--select XACT_STATE() as xact_state_1, @@trancount 
		--select XACT_STATE() as xact_state_2, @@trancount, 'A21'
		IF @@trancount > 0
		BEGIN 
			ROLLBACK TRAN
		END
		
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch';


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch';


  END;










