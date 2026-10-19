

/*
 * Program ID   : [DM0036_SAVE_CAPACITY_ALLOCATION_RATE]
 * Description  : Capacity Allodation Rate item별 월 Rate 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/08/29	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */
CREATE PROCEDURE [dbo].[DM0036_SAVE_CAPACITY_ALLOCATION_RATE]
	 @p_active_flag 	     NVARCHAR(1)
	,@p_division_id          NVARCHAR(2)
	,@p_item_id				 NVARCHAR(MAX)
	,@p_yyyymm				 NVARCHAR(6)
	,@p_capacity_rate        NVARCHAR(MAX)
	,@p_project_code		 NVARCHAR(MAX)
	,@p_scm_site_id          NVARCHAR(MAX)
	,@p_user_id              NVARCHAR(MAX)
	,@p_loc_flag             NVARCHAR(1) 
	,@p_program_id           NVARCHAR(200) ='DM0036'
	,@debug_mode             NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_created_by       NVARCHAR(MAX)=@p_user_id;
	DECLARE @v_creation_date    datetime =SYSDATETIME(); 
	DECLARE @v_last_updated_by  NVARCHAR(MAX)=@p_user_id;
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[DM0036_SAVE_CAPACITY_ALLOCATION_RATE]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	

	IF( @p_program_id = 'DM0036' )
		SET @v_program_name ='DM0036';

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		IF( ISNULL(@p_loc_flag,'') ='F' OR ISNULL(@p_loc_flag,'') ='A')
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



		-- LOOP 파라미터 출력 DEBUG용			
		IF (@debug_mode ='T') 
		BEGIN		
			PRINT '===============================================';			
			PRINT '@p_active_flag		  = ' + ISNULL(@p_active_flag        ,'') ;
			PRINT '@p_division_id         = ' + ISNULL(@p_division_id        ,'') ;
			PRINT '@p_item_id             = ' + ISNULL(@p_item_id            ,'') ;
			PRINT '@p_yyyymm			  = ' + ISNULL(@p_yyyymm             ,'') ;
			PRINT '@p_capacity_rate		  = ' + ISNULL(@p_capacity_rate      ,'') ;
			PRINT '@p_project_code		  = ' + ISNULL(@p_project_code       ,'') ;
			PRINT '@p_scm_site_id         = ' + ISNULL(@p_scm_site_id        ,'') ;
			PRINT '@p_user_id			  = ' + ISNULL(@p_user_id			 ,'') ;
			PRINT '@p_loc_flag			  = ' + ISNULL(@p_loc_flag			 ,'') ;
			PRINT '@p_program_id		  = ' + ISNULL(@p_program_id		 ,'') ;
		END;

		-- 수정
		IF( @p_active_flag ='M') 
			BEGIN
				--이력저장
				EXEC [dbo].[PR_DM_MST_CAPACITY_ALLOCATION_RATE_HIST] @p_division_id, @p_item_id, @p_project_code, @p_scm_site_id, @p_yyyymm, @p_capacity_rate, @v_created_by, @v_creation_date, @v_last_updated_by

				MERGE INTO DM_MST_CAPACITY_ALLOCATION A
				USING (
						SELECT 
								 @p_division_id         AS DIVISION_ID          					                                       
								,@p_item_id				AS ITEM_ID  
								,@p_project_code        AS END_CUSTOMER
								,@p_scm_site_id			AS SCM_SITE_ID                  
								,@p_yyyymm				AS YYYYMM
											
						) B
				ON(
								A.DIVISION_ID			= B.DIVISION_ID          
							AND A.ITEM_ID				= B.ITEM_ID  
							AND A.END_CUSTOMER          = B.END_CUSTOMER            
							AND A.SCM_SITE_ID           = B.SCM_SITE_ID                  
							AND A.YYYYMM				= B.YYYYMM      

					)
				WHEN MATCHED THEN
						UPDATE 
							 SET CAPACITY_RATE		= @p_capacity_rate         
								,LAST_UPDATED_BY	= @v_last_updated_by     
								,LAST_UPDATE_DATE	= @v_creation_date
					                
				WHEN NOT MATCHED THEN
					INSERT 
								(DIVISION_ID                     
								,ITEM_ID             
								,END_CUSTOMER                       
								,SCM_SITE_ID                             
								,YYYYMM                 
								,CAPACITY_RATE                     
								,CREATED_BY                      
								,CREATION_DATE                   
								,LAST_UPDATED_BY                 
								,LAST_UPDATE_DATE                
								)                                 
							VALUES                                 
								(@p_division_id                 
								,@p_item_id         
								,@p_project_code                   
								,@p_scm_site_id                         
								,@p_yyyymm             
								,@p_capacity_rate                 
								,@v_created_by                  
								,@v_creation_date               
								,@v_last_updated_by             
								,@v_creation_date            
							)
							;		
			END ;

		ELSE IF(@p_active_flag ='D')
			BEGIN
				--이력저장
				EXEC [dbo].[PR_DM_MST_CAPACITY_ALLOCATION_RATE_HIST_BY_ITEM] @p_division_id, @p_item_id, @v_created_by, @v_creation_date, @v_last_updated_by

				DELETE FROM DM_MST_CAPACITY_ALLOCATION
				WHERE DIVISION_ID = @p_division_id
				AND ITEM_ID=@p_item_id
				;
				     
			END; 	

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		
		IF( ISNULL(@p_loc_flag,'') ='L' OR ISNULL(@p_loc_flag,'') ='A')
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

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


