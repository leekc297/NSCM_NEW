
/*
 * Program ID   : [SCP0099_SAVE_PLAN_PROD_EDIT]
 * Description  : 중장기계획 수정- PRODUCTION
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/07/13   KJJ			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기계획 수정- PRODUCTION
 */
CREATE PROCEDURE [dbo].[SCP0099_SAVE_PLAN_PROD_EDIT]
	 @SCP0099_PROD					AS DBO.SCP0099_PROD       READONLY
	 ,@P_USER_ID					NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0099_SAVE_PLAN_PROD_EDIT]';
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
	
	
UPDATE SCP_ANL_BUSINESS_PLAN_PROD
   SET
		[M1_QTY] = B.M1_QTY
      ,[M2_QTY] = B.M2_QTY
      ,[M3_QTY] = B.M3_QTY
      ,[M4_QTY] = B.M4_QTY
      ,[M5_QTY] = B.M5_QTY
      ,[M6_QTY] = B.M6_QTY
      ,[M7_QTY] = B.M7_QTY
      ,[M8_QTY] = B.M8_QTY
      ,[M9_QTY] = B.M9_QTY
      ,[M10_QTY] = B.M10_QTY
      ,[M11_QTY] = B.M11_QTY
      ,[M12_QTY] = B.M12_QTY
      ,[M13_QTY] = B.M13_QTY
      ,[M14_QTY] = B.M14_QTY
      ,[M15_QTY] = B.M15_QTY
      ,[M16_QTY] = B.M16_QTY
      ,[M17_QTY] = B.M17_QTY
      ,[M18_QTY] = B.M18_QTY
      ,[M19_QTY] = B.M19_QTY
      ,[M20_QTY] = B.M20_QTY
      ,[M21_QTY] = B.M21_QTY
      ,[M22_QTY] = B.M22_QTY
      ,[M23_QTY] = B.M23_QTY
      ,[M24_QTY] = B.M24_QTY
      ,[M25_QTY] = B.M25_QTY
      ,[M26_QTY] = B.M26_QTY
      ,[M27_QTY] = B.M27_QTY
      ,[M28_QTY] = B.M28_QTY
      ,[M29_QTY] = B.M29_QTY
      ,[M30_QTY] = B.M30_QTY
      ,[M31_QTY] = B.M31_QTY
      ,[M32_QTY] = B.M32_QTY
      ,[M33_QTY] = B.M33_QTY
      ,[M34_QTY] = B.M34_QTY
      ,[M35_QTY] = B.M35_QTY
      ,[M36_QTY] = B.M36_QTY
      ,[M37_QTY] = B.M37_QTY
      ,[M38_QTY] = B.M38_QTY
      ,[M39_QTY] = B.M39_QTY
      ,[M40_QTY] = B.M40_QTY
      ,[M41_QTY] = B.M41_QTY
      ,[M42_QTY] = B.M42_QTY
      ,[M43_QTY] = B.M43_QTY
      ,[M44_QTY] = B.M44_QTY
      ,[M45_QTY] = B.M45_QTY
      ,[M46_QTY] = B.M46_QTY
      ,[M47_QTY] = B.M47_QTY
      ,[M48_QTY] = B.M48_QTY
      ,[M49_QTY] = B.M49_QTY
      ,[M50_QTY] = B.M50_QTY
      ,[M51_QTY] = B.M51_QTY
      ,[M52_QTY] = B.M52_QTY
      ,[M53_QTY] = B.M53_QTY
      ,[M54_QTY] = B.M54_QTY
      ,[M55_QTY] = B.M55_QTY
      ,[M56_QTY] = B.M56_QTY
      ,[M57_QTY] = B.M57_QTY
      ,[M58_QTY] = B.M58_QTY
      ,[M59_QTY] = B.M59_QTY
      ,[M60_QTY] = B.M60_QTY
      ,[LAST_UPDATED_BY] = @P_USER_ID
      ,[LAST_UPDATE_DATE] = GETDATE()
	  FROM SCP_ANL_BUSINESS_PLAN_PROD A
	  INNER JOIN @SCP0099_PROD B
		ON A.KEYVALUE = B.UNIT

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




