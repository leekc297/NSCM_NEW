/*
 * Program ID   : SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP
 * Description  : 출하일 관리
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/01/31   lwy			   Initial Release [] - PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - (외주) 출하일 관리 저장
 * 
 */

create PROCEDURE [dbo].[SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP]
	
	 @P_DIVISION_ID				NVARCHAR(MAX)
	,@P_PLANT_SITE_ID			NVARCHAR(MAX)
	,@P_YYYYMMDD				NVARCHAR(MAX)
	,@P_MEASURE 				NVARCHAR(MAX)
	,@P_SHIPMENT_YN				NVARCHAR(MAX)
	,@P_WORKING_TIME_DEFAULT	NVARCHAR(MAX)
	,@P_IS_SAVE_DEFALUT			NVARCHAR(1) 
	,@P_USER_ID					NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP]';
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
	
	
	-- WORKING TIME저장
	IF ( @p_is_save_defalut = 'N')
		BEGIN
			
			MERGE INTO [SCP_MST_SHIPMENT_WORKING_DAY_OSP] A
			USING (
					SELECT 
							 @P_DIVISION_ID		AS DIVISION_ID
							,@P_PLANT_SITE_ID	AS PLANT_SITE_ID
							,@P_YYYYMMDD		AS YYYYMMDD
							,@P_MEASURE			AS MEASURE
							,@P_SHIPMENT_YN		AS SHIPMENT_YN
							,@P_WORKING_TIME_DEFAULT AS WORKING_TIME_DEFAULT											
					) B
			   ON(
						A.DIVISION_ID   = B.DIVISION_ID
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
					AND A.YYYYMMDD		= B.YYYYMMDD
					AND A.MEASURE		= B.MEASURE
				 )
			WHEN MATCHED THEN
				UPDATE SET 
					 SHIPMENT_YN	  = @P_SHIPMENT_YN
					,LAST_UPDATED_BY  = @P_USER_ID
					,LAST_UPDATE_DATE = SYSDATETIME()
					                
			WHEN NOT MATCHED THEN
							                                             
				INSERT 	   ( DIVISION_ID
							,PLANT_SITE_ID
							,YYYYMMDD
							,MEASURE							
							,SHIPMENT_YN
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							)                   
						VALUES                                  
							(@P_DIVISION_ID
							,@P_PLANT_SITE_ID
							,@P_YYYYMMDD
							,@P_MEASURE
							,@P_SHIPMENT_YN
							,@P_USER_ID
							,SYSDATETIME()
							,@P_USER_ID 
							,SYSDATETIME()
							)  ;
					
			
		END;
	ELSE -- WORKING TIME DEFAULT 저장
		BEGIN
			
			MERGE INTO SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT A
			USING (
					SELECT
							 @P_DIVISION_ID   AS DIVISION_ID
							,@P_PLANT_SITE_ID AS PLANT_SITE_ID
				  ) B
			   ON(
				        A.DIVISION_ID   = B.DIVISION_ID
					AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
			  )
			WHEN MATCHED THEN
				UPDATE SET
					 WORKING_TIME_DEFAULT = @P_WORKING_TIME_DEFAULT
					,LAST_UPDATED_BY	  = @P_USER_ID
					,LAST_UPDATE_DATE	  = SYSDATETIME()

			WHEN NOT MATCHED THEN

				INSERT ( DIVISION_ID
						,PLANT_SITE_ID
						,WORKING_TIME_DEFAULT
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
					VALUES
						(@P_DIVISION_ID
						,@P_PLANT_SITE_ID
						,@P_WORKING_TIME_DEFAULT
						,@P_USER_ID
						,SYSDATETIME()
						,@P_USER_ID
						,SYSDATETIME()
						);
			

		END;


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
