
/*
 * Program ID   : [DMF0073_SAVE_VERSION_SALESPRICE]
 * Description  : VERSION_SALESPRICE 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024. 05. 13   KJJ			최초 작성

 exec DMF0073_SAVE_VERSION_SALESPRICE 
@P_DIVISION_ID=N'81'
,@P_VERSION_NO=N'I'
,@P_MONTHLY_ROLLING_FCST=N'Y'
,@P_USER_ID=N'kjj0070'

 */
CREATE PROCEDURE [dbo].[DMF0073_SAVE_VERSION_SALESPRICE]
		
	@P_DIVISION_ID			NVARCHAR(MAX),
	@P_VERSION_NO			NVARCHAR(MAX), 
	@P_MONTHLY_ROLLING_FCST	NVARCHAR(MAX), 
	@P_USER_ID     			NVARCHAR(100)

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0073_SAVE_VERSION_SALESPRICE';
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
	
	SELECT 
		B1.TOKEN AS VERSION_NO
		, B2.TOKEN AS MONTHLY_ROLLING_FCST

	INTO #T_MAIN
	FROM DBO.UF_FX_STRING_SPLIT(@P_VERSION_NO, '^') B1
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@P_MONTHLY_ROLLING_FCST			, '^') B2  ON B1.NR = B2.NR



	UPDATE M_VER
	SET
		M_VER.ATTRIBUTE7 = T_LIST.MONTHLY_ROLLING_FCST
		,LAST_UPDATED_BY = @P_USER_ID
		,LAST_UPDATE_DATE = GETDATE()
	FROM DM_MST_VERSION M_VER
	INNER JOIN #T_MAIN T_LIST
		ON M_VER.DIVISION_ID = @P_DIVISION_ID
		AND M_VER.VERSION_NO = T_LIST.VERSION_NO

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





