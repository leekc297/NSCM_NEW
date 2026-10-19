

/*
 * Program ID   : SCP0099_DEL_LONGTERM_PLAN
 * Description  : 중장기 계획 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/06/30   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기 계획 삭제
 * ex)
    EXEC SCP0099_DEL_LONGTERM_PLAN @p_division_id='81',@v_plan_id='20230629_002' 
 */

CREATE PROCEDURE [dbo].[SCP0099_DEL_LONGTERM_PLAN]
	
	 @p_division_id				NVARCHAR(MAX)
	,@v_plan_id				NVARCHAR(MAX)
	,@p_user_id					NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0099_DEL_LONGTERM_PLAN]';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	BEGIN TRY

	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	

	UPDATE SCP_ANL_BUSINESS_PLAN_INFO
	SET
	VALID_YN = 'N'
	,LAST_UPDATE_DATE = GETDATE()
	,LAST_UPDATED_BY = @p_user_id
	WHERE DIVISION_ID = @p_division_id
	AND PLAN_ID IN (SELECT TOKEN  FROM DBO.STRING_SPLIT(@v_plan_id, ','))
	
	DECLARE @ROWCNT INT
	SET @ROWCNT = @@ROWCOUNT


	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 결과코드, 결과 카운트 반환

	SELECT  'S' AS result_code,  @ROWCNT AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN

			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END
