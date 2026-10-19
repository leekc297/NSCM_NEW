
/*
 * Program ID   : [SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL]
 * Description  : Shipment Plan 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/12   PJS			   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/06/07   ygkim	       @p_project_code 추가
 * 2018/07/03   ygkim		   @p_Confirm_ID 추가	
 */
CREATE PROCEDURE [dbo].[SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL]
	 @p_active_flag		     NVARCHAR(MAX)
	,@p_division_id          NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(MAX)
	,@p_plan_type            NVARCHAR(MAX)
	,@p_seq                  NVARCHAR(MAX)
	,@p_item_id              NVARCHAR(MAX)
	,@p_from_site            NVARCHAR(MAX)
	,@p_to_site              NVARCHAR(MAX)
	,@p_measure              NVARCHAR(MAX)
	,@p_yyyymmdd             NVARCHAR(MAX)
	,@p_bod_id               NVARCHAR(MAX)
	,@p_qty                  NVARCHAR(MAX)
	,@p_fcst_type            NVARCHAR(MAX)
	,@p_project_code         NVARCHAR(MAX)
	,@p_Confirm_ID           NVARCHAR(MAX)

	,@p_user_id              NVARCHAR(MAX)
	,@debug_mode			 NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag          NVARCHAR(MAX);
	DECLARE @v_division_id          NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(MAX);
	DECLARE @v_plan_type            NVARCHAR(MAX);
	DECLARE @v_seq                  NVARCHAR(MAX);
	DECLARE @v_item_id              NVARCHAR(MAX);
	DECLARE @v_from_site            NVARCHAR(MAX);
	DECLARE @v_to_site              NVARCHAR(MAX);
	DECLARE @v_measure              NVARCHAR(MAX);
	DECLARE @v_yyyymmdd             NVARCHAR(MAX);
	DECLARE @v_bod_id               NVARCHAR(MAX);
	DECLARE @v_qty                  NVARCHAR(MAX);
	DECLARE @v_fcst_type            NVARCHAR(MAX);
	DECLARE @v_project_code         NVARCHAR(MAX);
	DECLARE @v_Confirm_ID           NVARCHAR(MAX);

	DECLARE @v_confirm_flag         NVARCHAR(MAX);
	DECLARE @v_last_updated_by      NVARCHAR(MAX);
	DECLARE @v_last_update_date     datetime;

	--DECLARE @v_last_update_date NVARCHAR(MAX);


	SET @v_active_flag         = NULL;
	SET @v_division_id         = NULL;
	SET @v_plan_start_yyyymmdd = NULL;
	SET @v_plan_type           = NULL;
	SET @v_seq                 = NULL;
	SET @v_item_id             = NULL;
	SET @v_from_site           = NULL;
	SET @v_to_site             = NULL;
	SET @v_measure             = NULL;
	SET @v_yyyymmdd            = NULL;
	SET @v_bod_id              = NULL;
	SET @v_qty                 = NULL;
	SET @v_fcst_type           = NULL;
	SET @v_project_code        = NULL;
	SET @v_project_code        = NULL;

	--SET @v_confirm_flag        = 'Y';
	SET @v_confirm_id          = null;

	SET @v_last_updated_by     = @p_user_id;
	SET @v_last_update_date    = SYSDATETIME(); ;


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SSP0001_SAVE_SHIPMENT_PLAN_CONFIRM_DETAIL]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	--BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN			
				SET @v_active_flag         = dbo.SCM_ARR_SPL_VAL(@p_active_flag        , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id         = dbo.SCM_ARR_SPL_VAL(@p_division_id        , @v_delimiter, @mst_loop_cnt );
				SET @v_plan_start_yyyymmdd = dbo.SCM_ARR_SPL_VAL(@p_plan_start_yyyymmdd, @v_delimiter, @mst_loop_cnt );
				SET @v_plan_type           = dbo.SCM_ARR_SPL_VAL(@p_plan_type          , @v_delimiter, @mst_loop_cnt );
				SET @v_seq                 = dbo.SCM_ARR_SPL_VAL(@p_seq                , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id             = dbo.SCM_ARR_SPL_VAL(@p_item_id            , @v_delimiter, @mst_loop_cnt );
				SET @v_from_site           = dbo.SCM_ARR_SPL_VAL(@p_from_site          , @v_delimiter, @mst_loop_cnt );
				SET @v_to_site             = dbo.SCM_ARR_SPL_VAL(@p_to_site            , @v_delimiter, @mst_loop_cnt );
				SET @v_measure             = dbo.SCM_ARR_SPL_VAL(@p_measure            , @v_delimiter, @mst_loop_cnt );
				SET @v_yyyymmdd            = dbo.SCM_ARR_SPL_VAL(@p_yyyymmdd           , @v_delimiter, @mst_loop_cnt );
				SET @v_bod_id              = dbo.SCM_ARR_SPL_VAL(@p_bod_id             , @v_delimiter, @mst_loop_cnt );
				SET @v_qty                 = dbo.SCM_ARR_SPL_VAL(@p_qty                , @v_delimiter, @mst_loop_cnt );
				SET @v_fcst_type           = dbo.SCM_ARR_SPL_VAL(@p_fcst_type          , @v_delimiter, @mst_loop_cnt );
				SET @v_project_code        = dbo.SCM_ARR_SPL_VAL(@p_project_code       , @v_delimiter, @mst_loop_cnt );
				SET @v_confirm_id          = dbo.SCM_ARR_SPL_VAL(@p_Confirm_ID         , @v_delimiter, @mst_loop_cnt );
			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '===============================================';			
				PRINT '@v_data_dup_cnt = ' +CONVERT(VARCHAR,@v_data_dup_cnt);
				PRINT ' @v_active_flag         = '''+@v_active_flag        	+'''';
				PRINT ' @v_division_id         = '''+@v_division_id         +'''';
				PRINT ' @v_plan_start_yyyymmdd = '''+@v_plan_start_yyyymmdd +'''';
				PRINT ' @v_plan_type           = '''+@v_plan_type           +'''';
				PRINT ' @v_seq                 = '''+@v_seq                 +'''';
				PRINT ' @v_item_id             = '''+@v_item_id             +'''';
				PRINT ' @v_from_site           = '''+@v_from_site           +'''';
				PRINT ' @v_to_site             = '''+@v_to_site             +'''';
				PRINT ' @v_measure             = '''+@v_measure             +'''';
				PRINT ' @v_yyyymmdd            = '''+@v_yyyymmdd            +'''';
				PRINT ' @v_bod_id              = '''+@v_bod_id              +'''';
				PRINT ' @v_qty                 = '''+@v_qty                 +'''';
				PRINT ' @v_fcst_type           = '''+@v_fcst_type           +'''';
				PRINT ' @v_project_code        = '''+@v_project_code        +'''';
				PRINT ' @v_confirm_id        = '''+@v_confirm_id        +'''';
			END;
		  	
			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					-- 수정
					IF( @v_active_flag ='M' OR @v_active_flag ='I') 
						BEGIN
							UPDATE dbo.SSP_ANL_SHIP_PLAN                       
							   SET QTY                 = @v_qty                
								  --,CONFIRM_FLAG        = @v_confirm_flag    --배치가 가져가면서 Y값 기록함   
								  --,CONFIRM_ID          = @v_confirm_id         
								  ,LAST_UPDATED_BY     = @v_last_updated_by    
								  ,LAST_UPDATE_DATE    = @v_last_update_date   
							 WHERE DIVISION_ID         = @v_division_id        
							   AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							   AND PLAN_TYPE           = @v_plan_type          
							   AND SEQ                 = @v_seq                
							   AND ITEM_ID             = @v_item_id            
							   AND FROM_SITE           = @v_from_site          
							   AND TO_SITE             = @v_to_site            
							   AND MEASURE             = @v_measure            
							   AND YYYYMMDD            = @v_yyyymmdd           
							   AND BOD_ID              = @v_bod_id  
							   AND FCST_TYPE		   = @v_fcst_type
							   AND PROJECT_CODE		   = @v_project_code
							   AND CONFIRM_ID		   = @v_confirm_id
							   ;
							   
							  EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL @v_division_id, @v_item_id, @v_from_site, @v_yyyymmdd, @v_last_updated_by         
						END; 	
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
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

