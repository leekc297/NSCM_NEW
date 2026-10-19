

/*
 * Program ID   : [DMF0071_SAVE_BPCUTOFF]
 * Description  : 화면에서 BP 컷오프 수행
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024-03-18   KJJ				LGES SCM 역량 강화 위한 개선과제 이행 - 화면에서 BP 컷오프 수행
 */
CREATE PROCEDURE [dbo].[DMF0071_SAVE_BPCUTOFF]
  	 @P_DIVISION_ID		NVARCHAR(30)  
	 ,@P_FROMDT			NVARCHAR(8)  
	 ,@P_TODT			NVARCHAR(8)  
	 ,@P_FCST_VER		NVARCHAR(50)  
	 ,@P_RTF_VER		NVARCHAR(50) 
	 ,@P_BPYEAR			NVARCHAR(4)  
	 ,@P_CUTOFF_YEAR	NVARCHAR(4)  
	 ,@P_DESC			NVARCHAR(MAX)
	 ,@P_USER_ID		NVARCHAR(30)  
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[DMF0071_SAVE_BPCUTOFF]';
    DECLARE @v_log_type     NVARCHAR(30);
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	BEGIN TRY

	------------------------------------------------------------------------------------------------------------------
	/*
		1. DMF0051_1_TRANSFER_TO_BIZPLAN 실행
	*/
	------------------------------------------------------------------------------------------------------------------
	--EXEC DMF0051_1_TRANSFER_TO_BIZPLAN @P_DIVISION_ID, @P_FCST_VER, '', '', 'ALL', 'ALL', 'ALL', 'ALL', @P_USER_ID
	EXEC DMF0051_1_TRANSFER_TO_BIZPLAN @P_DIVISION_ID, @P_FCST_VER, '', '', 'ALL', 'ALL', 'ALL', 'ALL', ''--사용자 정보 필요 없음(2024.03.20 - 김충원 부장님 확인)

	--EXEC DMF0051_1_TRANSFER_TO_BIZPLAN '81', 'MF_D_20240312_V001', '', '', 'ALL', 'ALL', 'ALL', 'ALL', 'kjj0070'


	------------------------------------------------------------------------------------------------------------------
	/*
		2. DMF0051_1_BIZPLAN_CUTOFF 실행
	*/
	------------------------------------------------------------------------------------------------------------------

	EXEC DMF0051_1_BIZPLAN_CUTOFF @P_DIVISION_ID, @P_BPYEAR/*, @P_CUTOFF_YEAR*/, @P_DESC, @P_USER_ID, @P_FCST_VER, @P_RTF_VER
	--EXEC DMF0051_1_BIZPLAN_CUTOFF '81', '2025', 'test2', 'kjj0070', 'MF_D_20240312_V001', '24BP_SCP_2023_W44_V01_001'


	------------------------------------------------------------------------------------------------------------------
	/*
		3. DMF0051_1_CREATE_RTF_MEASURE 실행(3단계 내부에서 4단계 호출)
		4. DMF0051_1_RTF_RATIO_DIVIDE_BIZPLAN 실행
	*/
	------------------------------------------------------------------------------------------------------------------

	EXEC DMF0051_1_CREATE_RTF_MEASURE @P_DIVISION_ID, @P_RTF_VER, @P_BPYEAR
	--EXEC DMF0051_1_CREATE_RTF_MEASURE '81', '24BP_SCP_2023_W44_V01_001', '2025'

	------------------------------------------------------------------------------------------------------------------
	/*
		4. DMF0051_1_RTF_RATIO_DIVIDE_BIZPLAN 실행
	*/
	------------------------------------------------------------------------------------------------------------------

	--EXEC DMF0051_1_RTF_RATIO_DIVIDE_BIZPLAN @P_DIVISION_ID,@P_FCST_VER, @P_RTF_VER
	--EXEC DMF0051_1_RTF_RATIO_DIVIDE_BIZPLAN '81','MF_D_20240312_V001', '24BP_SCP_2023_W44_V01_001'

	-----------------------------------------------------------------------

	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	-- 결과코드 반환
	SELECT  'S' AS result_code ;



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




