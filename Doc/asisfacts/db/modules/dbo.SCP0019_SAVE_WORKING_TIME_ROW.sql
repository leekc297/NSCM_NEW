/*
 * Program ID   : [SCP0019_SAVE_WORKING_TIME]
 * Description  : Working Time 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/14   pjs   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트\
 * 2018/05/29   PJS   Working Time Default 저장기능 추가
 *
 */
CREATE PROCEDURE [dbo].[SCP0019_SAVE_WORKING_TIME_ROW]
	 @p_active_flag 	 NVARCHAR(MAX)
	,@p_division_id      NVARCHAR(MAX)
	,@p_plant_site_id    NVARCHAR(MAX)
	,@p_factory_id       NVARCHAR(MAX)
	,@p_operation_id     NVARCHAR(MAX)
	,@p_line_id          NVARCHAR(MAX)
	,@p_yyyymmdd         NVARCHAR(MAX)
	,@p_working_time     NVARCHAR(MAX)
	,@p_created_by       NVARCHAR(MAX)
	,@p_last_updated_by  NVARCHAR(MAX)
	,@p_loc_flag         NVARCHAR(1) 
	,@p_is_save_defalut  NVARCHAR(1) 
	,@p_working_time_default NVARCHAR(MAX)
	,@debug_mode         NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_creation_date    datetime ;
	SET @v_creation_date    = SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0019_SAVE_WORKING_TIME_ROW]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	BEGIN TRY


	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	
	IF( ISNULL(@p_loc_flag,'') ='F')	
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--데이터 저장
	
	-- WORKING TIME저장
	IF ( @p_is_save_defalut = 'N')
		BEGIN

			--이력저장
			EXEC [dbo].[PR_SCP_MST_WORKING_TIME_HIST] @p_division_id, @p_plant_site_id, @p_factory_id,@p_operation_id,@p_line_id,@p_yyyymmdd,@p_working_time,@p_created_by,@v_creation_date,@p_last_updated_by;

			IF( @p_active_flag ='M' OR @p_active_flag ='I') 
				BEGIN
					MERGE INTO [SCP_MST_WORKING_TIME] A
					USING (
							SELECT 
									 @p_division_id   as division_id
									,@p_plant_site_id as plant_site_id
									,@p_factory_id    as factory_id
									,@p_operation_id  as operation_id
									,@p_line_id       as line_id
									,@p_yyyymmdd      as yyyymmdd
											
							) B
					ON(
								A.division_id = B.division_id
							AND A.plant_site_id = B.plant_site_id
							AND A.factory_id = B.factory_id
							AND A.operation_id = B.operation_id
							AND A.line_id = B.line_id
							AND A.yyyymmdd = B.yyyymmdd
						)
					WHEN MATCHED THEN
							UPDATE SET 
									WORKING_TIME	  = @p_working_time
								,last_updated_by	  = @p_last_updated_by
								,last_update_date	  = sysdatetime() 
					                
					WHEN NOT MATCHED THEN
							                                             
						INSERT 	   (division_id                    
									,plant_site_id                  
									,factory_id                     
									,operation_id                   
									,line_id                        
									,yyyymmdd                       
									,working_time                   
									,created_by                     
									,creation_date                  
									,last_updated_by                
									,last_update_date               
									)                   
								VALUES                                  
									(@p_division_id     
									,@p_plant_site_id   
									,@p_factory_id      
									,@p_operation_id    
									,@p_line_id         
									,@p_yyyymmdd        
									,@p_working_time    
									,@p_created_by      
									,sysdatetime()
									,@p_last_updated_by 
									,sysdatetime()
									)  ;
					END ;
			ELSE IF(@p_active_flag ='D')
				BEGIN
					DELETE FROM dbo.[SCP_MST_WORKING_TIME]
					WHERE division_id     = @p_division_id 
						AND plant_site_id = @p_plant_site_id 
						AND factory_id    = @p_factory_id
						AND operation_id  = @p_operation_id
						AND line_id       = @p_line_id
						AND yyyymmdd      = @p_yyyymmdd
					;     
				END; 	
		END;
	ELSE -- WORKING TIME DEFAULT 저장
		BEGIN
			IF( @p_active_flag ='M' OR @p_active_flag ='I') 
				BEGIN
					MERGE INTO SCP_MST_WORKING_TIME_DEFAULT A
					USING (
							SELECT 
									 @p_division_id   as division_id
									,@p_plant_site_id as plant_site_id
									,@p_factory_id    as factory_id
									,@p_operation_id  as operation_id
									,@p_line_id       as line_id
							) B
					ON(
								A.division_id   = B.division_id
							AND A.plant_site_id = B.plant_site_id
							AND A.factory_id    = B.factory_id
							AND A.operation_id  = B.operation_id
							AND A.line_id       = B.line_id
						)
					WHEN MATCHED THEN
							UPDATE SET 
								 working_time_default = @p_working_time_default
								,last_updated_by	  = @p_last_updated_by
								,last_update_date	  = sysdatetime() 
					                
					WHEN NOT MATCHED THEN
						
						INSERT (DIVISION_ID
							   ,PLANT_SITE_ID
							   ,FACTORY_ID
							   ,OPERATION_ID
							   ,LINE_ID
							   ,WORKING_TIME_DEFAULT
							   ,VALID_YN
							   ,CREATED_BY
							   ,CREATION_DATE
							   ,LAST_UPDATED_BY
							   ,LAST_UPDATE_DATE
								)
						 VALUES
							   (@p_division_id
							   ,@p_plant_site_id
							   ,@p_factory_id
							   ,@p_operation_id
							   ,@p_line_id
							   ,@p_working_time_default
							   ,'Y'
							   ,@p_created_by      
							   ,sysdatetime()
							   ,@p_last_updated_by 
							   ,sysdatetime()
							   );
	                   
					END ;
			ELSE IF(@p_active_flag ='D')
				BEGIN
					DELETE FROM dbo.SCP_MST_WORKING_TIME_DEFAULT
					WHERE division_id     = @p_division_id 
						AND plant_site_id = @p_plant_site_id 
						AND factory_id    = @p_factory_id
						AND operation_id  = @p_operation_id
						AND line_id       = @p_line_id
					;     
				END; 	

		END;


	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	IF( ISNULL(@p_loc_flag,'') ='L')
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
