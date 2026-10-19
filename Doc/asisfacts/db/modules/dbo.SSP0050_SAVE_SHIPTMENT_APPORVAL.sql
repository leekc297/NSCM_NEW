/*
 * Program ID   : [SSP0050_SAVE_SHIPTMENT_APPORVAL]
 * Description  : Shipment Apporval
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/02/21   jilee		   SSP 전자 결재 연동 승인자 기준 정보	
 
 */
CREATE PROCEDURE [dbo].[SSP0050_SAVE_SHIPTMENT_APPORVAL]
	 @p_user_id 			NVARCHAR(MAX)
	,@p_period_from			NVARCHAR(MAX)
	,@p_period_to			NVARCHAR(MAX)    
	,@p_days_mon_yn         NVARCHAR(MAX) 
	,@p_days_mon_from_to	NVARCHAR(MAX)
	,@p_days_tue_yn			NVARCHAR(MAX)
	,@p_days_tue_from_to	NVARCHAR(MAX)
	,@p_days_wed_yn			NVARCHAR(MAX)
	,@p_days_wed_from_to	NVARCHAR(MAX)
	,@p_days_thu_yn			NVARCHAR(MAX)
	,@p_days_thu_from_to	NVARCHAR(MAX)
	,@p_days_fri_yn			NVARCHAR(MAX)
	,@p_days_fri_from_to	NVARCHAR(MAX)
	,@p_days_sat_yn			NVARCHAR(MAX)
	,@p_days_sat_from_to	NVARCHAR(MAX)
	,@p_days_sun_yn			NVARCHAR(MAX)
	,@p_days_sun_from_to	NVARCHAR(MAX)
	,@p_valid_yn			NVARCHAR(MAX)
	,@p_active_flag         NVARCHAR(MAX)
	,@p_requester           NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	
	DECLARE @v_user_id   		    NVARCHAR(MAX);
	DECLARE @v_period_from		    NVARCHAR(MAX);
	DECLARE @v_period_to			NVARCHAR(MAX);
	DECLARE @v_days_mon_yn      	NVARCHAR(MAX);
	DECLARE @v_days_mon_from_to		NVARCHAR(MAX);
	DECLARE @v_days_tue_yn			NVARCHAR(MAX);
	DECLARE @v_days_tue_from_to		NVARCHAR(MAX);
	DECLARE @v_days_wed_yn			NVARCHAR(MAX);
	DECLARE @v_days_wed_from_to		NVARCHAR(MAX);
	DECLARE @v_days_thu_yn			NVARCHAR(MAX);
	DECLARE @v_days_thu_from_to		NVARCHAR(MAX);
	DECLARE @v_days_fri_yn			NVARCHAR(MAX);
	DECLARE @v_days_fri_from_to		NVARCHAR(MAX);
	DECLARE @v_days_sat_yn			NVARCHAR(MAX);
	DECLARE @v_days_sat_from_to		NVARCHAR(MAX);
	DECLARE @v_days_sun_yn			NVARCHAR(MAX);
	DECLARE @v_days_sun_from_to		NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_requester            NVARCHAR(100);

	SET @v_user_id                 = NULL;	
	SET @v_period_from		       = NULL;
	SET @v_period_to			   = NULL;
	SET @v_days_mon_yn      	   = NULL;
	SET @v_days_mon_from_to		   = NULL;
	SET @v_days_tue_yn			   = NULL;
	SET @v_days_tue_from_to		   = NULL;
	SET @v_days_wed_yn			   = NULL;
	SET @v_days_wed_from_to		   = NULL;
	SET @v_days_thu_yn			   = NULL;
	SET @v_days_thu_from_to		   = NULL;
	SET @v_days_fri_yn			   = NULL;
	SET @v_days_fri_from_to		   = NULL;
	SET @v_days_sat_yn			   = NULL;
	SET @v_days_sat_from_to		   = NULL;
	SET @v_days_sun_yn			   = NULL;
	SET @v_days_sun_from_to		   = NULL;
	SET @v_valid_yn				   = NULL;
	SET @v_active_flag	           = NULL;
	SET @v_requester               = @p_requester;  

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0050_SAVE_SHIPTMENT_APPORVAL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
	
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    	
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_user_id             = [dbo].[SCM_ARR_SPL_VAL](@p_user_id  	        , @v_delimiter , @mst_loop_cnt) ;    
				SET @v_period_from		   = [dbo].[SCM_ARR_SPL_VAL](@p_period_from	        , @v_delimiter , @mst_loop_cnt) ;    
				SET @v_period_to		   = [dbo].[SCM_ARR_SPL_VAL](@p_period_to	        , @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_mon_yn         = [dbo].[SCM_ARR_SPL_VAL](@p_days_mon_yn      	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_mon_from_to	   = [dbo].[SCM_ARR_SPL_VAL](@p_days_mon_from_to	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_tue_yn		   = [dbo].[SCM_ARR_SPL_VAL](@p_days_tue_yn			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_tue_from_to	   = [dbo].[SCM_ARR_SPL_VAL](@p_days_tue_from_to	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_wed_yn		   = [dbo].[SCM_ARR_SPL_VAL](@p_days_wed_yn			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_wed_from_to	   = [dbo].[SCM_ARR_SPL_VAL](@p_days_wed_from_to	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_thu_yn		   = [dbo].[SCM_ARR_SPL_VAL](@p_days_thu_yn			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_thu_from_to	   = [dbo].[SCM_ARR_SPL_VAL](@p_days_thu_from_to	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_fri_yn		   = [dbo].[SCM_ARR_SPL_VAL](@p_days_fri_yn			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_fri_from_to	   = [dbo].[SCM_ARR_SPL_VAL](@p_days_fri_from_to	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_sat_yn		   = [dbo].[SCM_ARR_SPL_VAL](@p_days_sat_yn			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_sat_from_to	   = [dbo].[SCM_ARR_SPL_VAL](@p_days_sat_from_to	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_sun_yn		   = [dbo].[SCM_ARR_SPL_VAL](@p_days_sun_yn			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_days_sun_from_to	   = [dbo].[SCM_ARR_SPL_VAL](@p_days_sun_from_to	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_valid_yn			   = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_active_flag	       = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	    	, @v_delimiter , @mst_loop_cnt) ; 
			END			

			--SSP0050_Save시 24시 입력하면 23:59 강제 변경 00:00~23:59					
			IF(SUBSTRING(@v_days_mon_from_to,7,8) = '24' OR SUBSTRING(@v_days_tue_from_to,7,8) = '24' OR SUBSTRING(@v_days_wed_from_to,7,8) = '24' OR
			   SUBSTRING(@v_days_thu_from_to,7,8) = '24' OR SUBSTRING(@v_days_fri_from_to,7,8) = '24' OR SUBSTRING(@v_days_sat_from_to,7,8) = '24' OR
			   SUBSTRING(@v_days_sun_from_to,7,8) = '24'
			   )
				BEGIN
					SELECT  'X' AS result_code,  @max_loop_cnt AS result_cnt ;
					RETURN;
				END

			--SSP0050_Save시 To시간이 작으면 체크	
			IF(SUBSTRING(@v_days_mon_from_to,1,2) > SUBSTRING(@v_days_mon_from_to,7,8) OR
			   SUBSTRING(@v_days_tue_from_to,1,2) > SUBSTRING(@v_days_tue_from_to,7,8) OR			   
			   SUBSTRING(@v_days_wed_from_to,1,2) > SUBSTRING(@v_days_wed_from_to,7,8) OR
			   SUBSTRING(@v_days_thu_from_to,1,2) > SUBSTRING(@v_days_thu_from_to,7,8) OR 
			   SUBSTRING(@v_days_fri_from_to,1,2) > SUBSTRING(@v_days_fri_from_to,7,8) OR
			   SUBSTRING(@v_days_sat_from_to,1,2) > SUBSTRING(@v_days_sat_from_to,7,8) OR
			   SUBSTRING(@v_days_sun_from_to,1,2) > SUBSTRING(@v_days_sun_from_to,7,8)
			   )
				BEGIN
					SELECT  'Z' AS result_code,  @max_loop_cnt AS result_cnt ;
					RETURN;
				END

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN
				    
					MERGE INTO SSP_MST_APPROVAL A
					USING (
							SELECT 
									 @v_user_id      as user_id
									,@v_period_from  as period_from
									,@v_period_to    as period_to
						  ) B
					ON    (
									a.user_id       = b.user_id
								AND a.period_from   = b.period_from
								AND	a.period_to     = b.period_to
					      )
					WHEN MATCHED THEN
							UPDATE SET							
								  days_mon_yn       = @v_days_mon_yn      
								 ,days_mon_from_to  = @v_days_mon_from_to	
								 ,days_tue_yn		= @v_days_tue_yn		
								 ,days_tue_from_to  = @v_days_tue_from_to	
								 ,days_wed_yn		= @v_days_wed_yn		
								 ,days_wed_from_to  = @v_days_wed_from_to	
								 ,days_thu_yn		= @v_days_thu_yn		
								 ,days_thu_from_to  = @v_days_thu_from_to	
								 ,days_fri_yn		= @v_days_fri_yn		
								 ,days_fri_from_to  = @v_days_fri_from_to	
								 ,days_sat_yn		= @v_days_sat_yn		
								 ,days_sat_from_to  = @v_days_sat_from_to	
								 ,days_sun_yn		= @v_days_sun_yn		
								 ,days_sun_from_to  = @v_days_sun_from_to	
								 ,valid_yn		    = @v_valid_yn
								 ,last_updated_by   = @v_requester
								 ,last_update_date  = sysdatetime()
					WHEN NOT MATCHED THEN
					INSERT	(		
					              USER_ID
								 ,PERIOD_FROM
								 ,PERIOD_TO
								 ,DAYS_MON_YN     
								 ,DAYS_MON_FROM_TO
								 ,DAYS_TUE_YN		
								 ,DAYS_TUE_FROM_TO
								 ,DAYS_WED_YN		
								 ,DAYS_WED_FROM_TO
								 ,DAYS_THU_YN		
								 ,DAYS_THU_FROM_TO
								 ,DAYS_FRI_YN		
								 ,DAYS_FRI_FROM_TO
								 ,DAYS_SAT_YN		
								 ,DAYS_SAT_FROM_TO
								 ,DAYS_SUN_YN		
								 ,DAYS_SUN_FROM_TO
								 ,VALID_YN
								 ,CREATED_BY
								 ,CREATION_DATE
								 ,LAST_UPDATED_BY
								 ,LAST_UPDATE_DATE
							)
					VALUES  (
					 			 @v_user_id, @v_period_from, @v_period_to, @v_days_mon_yn, @v_days_mon_from_to, @v_days_tue_yn, @v_days_tue_from_to,
								 @v_days_wed_yn, @v_days_wed_from_to, @v_days_thu_yn, @v_days_thu_from_to, @v_days_fri_yn, @v_days_fri_from_to,
								 @v_days_sat_yn, @v_days_sat_from_to, @v_days_sun_yn, @v_days_sun_from_to, @v_valid_yn,
								 @v_requester, sysdatetime(), @v_requester, sysdatetime()								
							);

				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END
