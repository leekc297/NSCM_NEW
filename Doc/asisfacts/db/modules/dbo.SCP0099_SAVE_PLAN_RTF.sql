
/*
 * Program ID   : [SCP0099_SAVE_PLAN_RTF]
 * Description  : 중장기계획 등록- RTF
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/07/06   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기계획 등록- RTF
 */
CREATE PROCEDURE [dbo].[SCP0099_SAVE_PLAN_RTF]
	 @SCP0099_RTF			AS DBO.SCP0099_RTF       READONLY
	 ,@P_DIV						NVARCHAR(MAX)
	 ,@P_PLAN						NVARCHAR(MAX)
	 ,@P_USER_ID					NVARCHAR(MAX)
	 ,@P_DEL_YN						NVARCHAR(1) = 'Y'
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0099_SAVE_PLAN_RTF]';
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

	IF(@P_DEL_YN = 'Y') --엑셀 업로드시에는 전체 삭제후 INSERT
	BEGIN
		--기존 데이터 있으면 삭제============================
		DELETE FROM SCP_ANL_BUSINESS_PLAN_RTF
		WHERE DIVISION_ID = @P_DIV
		AND PLAN_ID = @P_PLAN
		--=====================================================
	END

	INSERT INTO SCP_ANL_BUSINESS_PLAN_RTF
	SELECT 
		@P_DIV
      ,@P_PLAN
	,[SALES_SITE]
	,[BIZ_TYPE]
	,[CUST]
	,[PROJECT]
	,[PROJECT_DESC]
	,[MODEL]
	,[MODEL_CODE]
	,[CELL_NICKNAME]
	,[CELL_CODE]
	,[ELECTRODE]
	,[CELL]
	,[PACK]
	,[UNIT]
	,[INCOTERMS]
	,[MEASURE]
      ,[M1_QTY]
      ,[M2_QTY]
      ,[M3_QTY]
      ,[M4_QTY]
      ,[M5_QTY]
      ,[M6_QTY]
      ,[M7_QTY]
      ,[M8_QTY]
      ,[M9_QTY]
      ,[M10_QTY]
      ,[M11_QTY]
      ,[M12_QTY]
      ,[M13_QTY]
      ,[M14_QTY]
      ,[M15_QTY]
      ,[M16_QTY]
      ,[M17_QTY]
      ,[M18_QTY]
      ,[M19_QTY]
      ,[M20_QTY]
      ,[M21_QTY]
      ,[M22_QTY]
      ,[M23_QTY]
      ,[M24_QTY]
      ,[M25_QTY]
      ,[M26_QTY]
      ,[M27_QTY]
      ,[M28_QTY]
      ,[M29_QTY]
      ,[M30_QTY]
      ,[M31_QTY]
      ,[M32_QTY]
      ,[M33_QTY]
      ,[M34_QTY]
      ,[M35_QTY]
      ,[M36_QTY]
      ,[M37_QTY]
      ,[M38_QTY]
      ,[M39_QTY]
      ,[M40_QTY]
      ,[M41_QTY]
      ,[M42_QTY]
      ,[M43_QTY]
      ,[M44_QTY]
      ,[M45_QTY]
      ,[M46_QTY]
      ,[M47_QTY]
      ,[M48_QTY]
      ,[M49_QTY]
      ,[M50_QTY]
      ,[M51_QTY]
      ,[M52_QTY]
      ,[M53_QTY]
      ,[M54_QTY]
      ,[M55_QTY]
      ,[M56_QTY]
      ,[M57_QTY]
      ,[M58_QTY]
      ,[M59_QTY]
      ,[M60_QTY]
      ,@P_USER_ID
      ,GETDATE()
      ,@P_USER_ID
      ,GETDATE()
	  ,NEWID()
	  ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	FROM @SCP0099_RTF

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




