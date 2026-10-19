/*************************************************************************************************
* Program ID  : DMF0044_SAVE_TEXTBOX                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : TEXTBOX POPUP 에서 Request 를 생성할 때 사용
* Parameter   :                                                                                  
* 
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2021-09-16   ROSIA27		[과제] TEXTBOX POPUP
***************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0044_SAVE_TEXTBOX]
			@P_VERSION_NO		NVARCHAR(50)
			, @P_YYYYMM			NVARCHAR(6)
			, @P_DESCRIPTION1	NVARCHAR(4000)
			, @P_DESCRIPTION2	NVARCHAR(4000)
			, @P_DESCRIPTION3	NVARCHAR(4000)
			, @P_DESCRIPTION4	NVARCHAR(4000)
			, @P_DESCRIPTION5	NVARCHAR(4000)
			, @P_DESCRIPTION6	NVARCHAR(4000)
			, @P_DESCRIPTION7	NVARCHAR(4000)
			, @P_DESCRIPTION8	NVARCHAR(4000)
			, @P_DESCRIPTION9	NVARCHAR(4000)
			, @P_DESCRIPTION10	NVARCHAR(4000)
			, @P_DESCRIPTION11	NVARCHAR(4000)
			, @P_DESCRIPTION12	NVARCHAR(4000)
			, @P_DESCRIPTION13	NVARCHAR(4000)
			, @P_CREATED_BY		NVARCHAR(150)

AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0044_SAVE_TEXTBOX';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_log_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_merge_count     INTEGER = 0;

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, @p_CREATED_BY
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 
	
	--BEGIN TRANSACTION
	BEGIN TRANSACTION 
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------

		UPDATE DM_MDF_VERSION
		SET
			TEXT_START_YYYYMM = @P_YYYYMM
			, DESCRIPTION1 = ISNULL(@P_DESCRIPTION1, '')
			, DESCRIPTION2 = ISNULL(@P_DESCRIPTION2, '')
			, DESCRIPTION3 = ISNULL(@P_DESCRIPTION3, '')
			, DESCRIPTION4 = ISNULL(@P_DESCRIPTION4, '')
			, DESCRIPTION5 = ISNULL(@P_DESCRIPTION5, '')
			, DESCRIPTION6 = ISNULL(@P_DESCRIPTION6, '')
			, DESCRIPTION7 = ISNULL(@P_DESCRIPTION7, '')
			, DESCRIPTION8 = ISNULL(@P_DESCRIPTION8, '')
			, DESCRIPTION9 = ISNULL(@P_DESCRIPTION9, '')
			, DESCRIPTION10 = ISNULL(@P_DESCRIPTION10, '')
			, DESCRIPTION11 = ISNULL(@P_DESCRIPTION11, '')
			, DESCRIPTION12 = ISNULL(@P_DESCRIPTION12, '')
			, DESCRIPTION13 = ISNULL(@P_DESCRIPTION13, '')
			, LAST_UPDATED_BY = @P_CREATED_BY
			, LAST_UPDATE_DATE = GETDATE()
		WHERE
			DIVISION_ID = '82'
			AND VERSION_NO = @P_VERSION_NO

		-- VERSION_NO Null Validation
		IF NOT EXISTS ( SELECT 1 FROM [dbo].[DM_MDF_VERSION] WITH (NOLOCK) WHERE 1=1
									AND DIVISION_ID = '82' AND VERSION_NO = @P_VERSION_NO ) 
			BEGIN 
				SET @v_log_type = 'INVALID'
				GOTO ERR_RTN
			END

		-- 트랜잭션 (COMMIT)
			COMMIT WORK;

		ERR_RTN:
		IF @v_log_type = 'INVALID'
			BEGIN
				ROLLBACK TRANSACTION;
				SET @v_log_message = '########## END of procedure ##########';
				SET @v_log_description = '';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;
				SELECT N'해당 VERSION 이 존재하지 않습니다.'
			END			
	------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION;

		
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, @p_CREATED_BY;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success';

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_log_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;

END
