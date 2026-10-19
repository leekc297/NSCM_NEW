

/*
 * Program ID   : SCP0023_SAVE_OUTSOURCING_CAPA
 * Description  : 외주 Packer Capa 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.19   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */
CREATE PROCEDURE [dbo].[SCP0023_SAVE_OUTSOURCING_CAPA]
	  @p_active_flag 			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_daily_capa_qty			NVARCHAR(MAX)
	, @p_valid_yn				NVARCHAR(MAX)	
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag 			NVARCHAR(MAX) = null;
	DECLARE @v_division_id			NVARCHAR(MAX) = null;
	DECLARE @v_plant_site_id		NVARCHAR(MAX) = null;
	DECLARE @v_item_id				NVARCHAR(MAX) = null;
	DECLARE @v_daily_capa_qty		NVARCHAR(MAX) = null;
	DECLARE @v_valid_yn				NVARCHAR(MAX) = null;
	DECLARE @v_created_by			NVARCHAR(MAX) = null;
	DECLARE @v_last_updated_by	    NVARCHAR(MAX) = null;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0023_SAVE_OUTSOURCING_CAPA';
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
	BEGIN TRAN;

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
				SET @v_active_flag		= dbo.SCM_ARR_SPL_VAL( @p_active_flag	    , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id      = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_site_id    = dbo.SCM_ARR_SPL_VAL( @p_plant_site_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id			= dbo.SCM_ARR_SPL_VAL( @p_item_id			, @v_delimiter, @mst_loop_cnt );
				SET @v_daily_capa_qty   = dbo.SCM_ARR_SPL_VAL( @p_daily_capa_qty    , @v_delimiter, @mst_loop_cnt );
				SET @v_valid_yn			= dbo.SCM_ARR_SPL_VAL( @p_valid_yn			, @v_delimiter, @mst_loop_cnt );

				--PRINT '6';
				--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

			-- 0420 수정 : total 로 들어오는 항목을 '-'로 바꿔서 저장
			if UPPER( RTRIM( LTRIM(@v_item_id))) = 'TOTAL'
				set @v_item_id = '-';

			declare @p_creation_date datetime =  SYSDATETIME();

		   --이력저장
			EXEC [dbo].[PR_SCP_MST_OUTSOURCING_CAPA_HIST] 
				@v_division_id, @v_plant_site_id, @v_item_id , @v_daily_capa_qty , @v_valid_yn ,
				@p_created_by, @p_creation_date, @p_last_updated_by 
			;
			
			--데이터 저장
			IF @mst_loop_cnt > 0
			BEGIN
				MERGE INTO SCP_MST_OUTSOURCING_CAPA A
				USING (
					SELECT 
						 @v_division_id as division_id
						,@v_plant_site_id as plant_site_id
						,@v_item_id as item_id
				) B
				ON(
						A.division_id = B.division_id
					AND A.plant_site_id = B.plant_site_id
					AND A.item_id = B.item_id
				)
				WHEN MATCHED THEN
					UPDATE SET 
						 daily_capa_qty			= @v_daily_capa_qty
						,valid_yn				= 'Y'
						,last_updated_by		= @p_last_updated_by
						,last_update_date		= sysdatetime()
				WHEN NOT MATCHED THEN		
					
					INSERT 
						( DIVISION_ID                      
						,PLANT_SITE_ID                    
						,ITEM_ID                                             
						,DAILY_CAPA_QTY                            
						,VALID_YN                         
						,CREATED_BY                       
						,CREATION_DATE                    
						,LAST_UPDATED_BY                  
						,LAST_UPDATE_DATE  )           
					VALUES                                    
						 (@v_division_id            
						,@v_plant_site_id          
						,@v_item_id                             
						,@v_daily_capa_qty                  
						,'Y'
						,@p_created_by
						,sysdatetime()
						,@p_last_updated_by 
						,sysdatetime()
						)
					  ;
			END
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		---- 결과코드, 결과 카운트 반환
		--SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

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



