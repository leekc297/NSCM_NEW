
/*
 * Program ID   : SCP0099_CreatePlanPopup
 * Description  : 중장기 계획 등록
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/06/29   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기 계획 등록
 * ex)
    EXEC SCP0099_SAVE_LONGTERM_PLAN @p_division_id='81',@p_sale_ver='',@p_plan_start_date='20230620',@p_plan_end_date='20280620',@p_plan_desc='', @p_user_id='' 
 */

create PROCEDURE [dbo].[SCP0099_SAVE_LONGTERM_PLAN_20230904]
	
	 @p_division_id				NVARCHAR(MAX)
	,@p_sale_ver				NVARCHAR(MAX)
	,@p_plan_start_date			NVARCHAR(MAX)
	,@p_plan_end_date 			NVARCHAR(MAX)
	,@p_plan_desc				NVARCHAR(MAX)
	,@p_user_id					NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0099_SAVE_LONGTERM_PLAN]';
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
	
	--PLAN_ID 채번===============================================================
	--형식:YYYYMMDD_001

	DECLARE @V_PLAN_ID NVARCHAR(MAX)

	DECLARE @V_YYYYMMDD NVARCHAR(MAX)
	SET @V_YYYYMMDD = (select convert(varchar(8), getdate(), 112))


	DECLARE @SEQ NVARCHAR(MAX)  
	DECLARE @MAXTMP NVARCHAR(MAX)

	SET @MAXTMP = (SELECT MAX(PLAN_ID) FROM SCP_ANL_BUSINESS_PLAN_INFO WITH(NOLOCK) WHERE DIVISION_ID = @P_DIVISION_ID AND PLAN_ID LIKE '%' + @V_YYYYMMDD + '%')


	IF (ISNULL(@MAXTMP, '') = '')
	BEGIN
		SET @SEQ = '_001'
	END
	ELSE
	BEGIN
		DECLARE @V_TMPSEQ  INT
		SET @V_TMPSEQ = CONVERT(INTEGER, SUBSTRING(@MAXTMP, 10,3)) + 1

		DECLARE @V_PADDINGVAL  NVARCHAR(MAX)

		SET @SEQ = '_' + FORMAT(@V_TMPSEQ,'000')
	END

	SET @V_PLAN_ID = @V_YYYYMMDD + @SEQ
--==================================================================================

INSERT INTO [dbo].[SCP_ANL_BUSINESS_PLAN_INFO]
           ([DIVISION_ID]
           ,[PLAN_ID]
           ,[SALE_VER]
           ,[PLAN_START_DATE]
           ,[PLAN_END_DATE]
           ,[PLAN_DESC]
           ,[VALID_YN]
           ,[CREATED_BY]
           ,[CREATION_DATE]
           ,[LAST_UPDATED_BY]
           ,[LAST_UPDATE_DATE]
)
     VALUES
           (@p_division_id
           ,@V_PLAN_ID
           ,@p_sale_ver
           ,@p_plan_start_date
           ,@p_plan_end_date
           ,@p_plan_desc
           ,'Y'
			,@p_user_id
			,SYSDATETIME()
			,@p_user_id 
			,SYSDATETIME()
			);



	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 결과코드, 결과 카운트 반환
	SELECT  'S' AS result_code,  1 AS result_cnt ;

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
