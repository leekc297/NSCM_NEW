





/*
 * Program ID   : [SCP0046_SAVE_MODEL_ALLOCATION_DATASET]
 * Description  : Model Allocation 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/10	YHW				Initial Release [PJ20189106] 전지GSCM 고도화
 */
CREATE PROCEDURE [dbo].[SCP0046_SAVE_MODEL_ALLOCATION_DATASET]
	 @SCP0046			AS DBO.SCP0046       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_creation_date    datetime =SYSDATETIME(); 
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0046_SAVE_MODEL_ALLOCATION_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	DECLARE @v_data_dup_msg  NVARCHAR(300)='';
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

    -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    


	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 중복체크
		SET @v_data_dup_cnt = 0;
		SET @v_data_dup_msg = '';

		SELECT @v_data_dup_cnt = COUNT(*) 
		FROM @SCP0046 A 
		JOIN SCP_MST_MODEL_ALLOCATION B WITH(NOLOCK) ON A.p_division_id=B.DIVISION_ID
													 AND A.p_cell_plant_site_id = B.CELL_PLANT_SITE_ID
													 AND A.p_cell_item_id = B.CELL_ITEM_ID
													 AND A.p_cell_line_id = B.CELL_LINE_ID
													 AND ISNULL(NULLIF(A.p_elec_item_id,''),'-') = ISNULL(NULLIF(B.ELEC_ITEM_ID,''),'-')
													 AND A.p_elec_plant_site_id = B.ELEC_PLANT_SITE_ID
													 AND ISNULL(NULLIF(A.p_elec_line_id,''),'-') = ISNULL(NULLIF(B.ELEC_LINE_ID,''),'-')
													 AND ISNULL(NULLIF(A.p_tr_mode,''),'-') = ISNULL(NULLIF(B.TR_MODE,''),'-')
													 AND A.p_yyyymmdd = B.YYYYMMDD
													 AND A.p_active_flag = 'I'
		;

		IF( @v_data_dup_cnt>0) 
			BEGIN
				SET @v_data_dup_msg = (
								SELECT TOP 1 A.p_cell_item_id+'/'+A.p_cell_plant_site_id+'/'+A.p_cell_line_id+'/'+A.p_elec_plant_site_id+'/'+A.p_yyyymmdd AS DUP_MSG
								FROM @SCP0046 A 
								JOIN SCP_MST_MODEL_ALLOCATION B WITH(NOLOCK) ON A.p_division_id								= B.DIVISION_ID
																			 AND A.p_cell_plant_site_id						= B.CELL_PLANT_SITE_ID
																			 AND A.p_cell_item_id							= B.CELL_ITEM_ID
																			 AND A.p_cell_line_id							= B.CELL_LINE_ID
																			 AND ISNULL(NULLIF(A.p_elec_item_id,''),'-')	= ISNULL(NULLIF(B.ELEC_ITEM_ID,''),'-')
																			 AND A.p_elec_plant_site_id						= B.ELEC_PLANT_SITE_ID
																			 AND ISNULL(NULLIF(A.p_elec_line_id,''),'-')	= ISNULL(NULLIF(B.ELEC_LINE_ID,''),'-')
																			 AND ISNULL(NULLIF(A.p_tr_mode,''),'-')			= ISNULL(NULLIF(B.TR_MODE,''),'-')
																			 AND A.p_yyyymmdd								= B.YYYYMMDD
																			 AND A.p_active_flag							= 'I'
								);
				SET @v_err_code    = 99020 ; 
				SET @v_err_message = N'중복 데이터가 입력되었습니다. '+@v_data_dup_msg;
				THROW @v_err_code, @v_err_message , 1; --예외발생
									 
			END;
		
		--수정
		UPDATE A
		SET A.VALID_YN = B.p_valid_yn
			, A.LAST_UPDATED_BY	= B.p_user_id
			, A.LAST_UPDATE_DATE = @d_event_date
		FROM SCP_MST_MODEL_ALLOCATION A WITH(NOLOCK)
		JOIN @SCP0046 B ON B.p_division_id							= A.DIVISION_ID
						AND B.p_cell_plant_site_id					= A.CELL_PLANT_SITE_ID
						AND B.p_cell_item_id						= A.CELL_ITEM_ID
						AND B.p_cell_line_id						= A.CELL_LINE_ID
						AND ISNULL(NULLIF(B.p_elec_item_id,''),'-') = ISNULL(NULLIF(A.ELEC_ITEM_ID,''),'-')
						AND B.p_elec_plant_site_id					= A.ELEC_PLANT_SITE_ID
						AND ISNULL(NULLIF(B.p_elec_line_id,''),'-') = ISNULL(NULLIF(A.ELEC_LINE_ID,''),'-')
						AND ISNULL(NULLIF(B.p_tr_mode,''),'-')		= ISNULL(NULLIF(A.TR_MODE,''),'-')
						AND B.p_yyyymmdd							= A.YYYYMMDD
		;

		--신규
		INSERT INTO SCP_MST_MODEL_ALLOCATION
		(DIVISION_ID,		CELL_PLANT_SITE_ID, CELL_ITEM_ID,		CELL_LINE_ID
		 , ELEC_ITEM_ID,	ELEC_LINE_ID,		ELEC_PLANT_SITE_ID,	TR_MODE,			YYYYMMDD,	VALID_YN
		 , CREATED_BY,		CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE)
		SELECT A.p_division_id
			   , A.p_cell_plant_site_id
			   , A.p_cell_item_id
			   , A.p_cell_line_id
			   , A.p_elec_item_id
			   , A.p_elec_line_id
			   , A.p_elec_plant_site_id
			   , A.p_tr_mode
			   , A.p_yyyymmdd
			   , A.p_valid_yn
			   , A.p_user_id
			   , @d_event_date
			   , A.p_user_id
			   , @d_event_date
		FROM @SCP0046 A
		WHERE 1=1 
		AND NOT EXISTS (	SELECT 'X' 
							FROM SCP_MST_MODEL_ALLOCATION B WITH(NOLOCK)
							WHERE B.DIVISION_ID							= A.p_division_id
							AND B.CELL_PLANT_SITE_ID					= A.p_cell_plant_site_id
							AND B.CELL_ITEM_ID							= A.p_cell_item_id
							AND B.CELL_LINE_ID							= A.p_cell_line_id
							AND ISNULL(NULLIF(B.ELEC_ITEM_ID,''),'-')	= ISNULL(NULLIF(A.p_elec_item_id,''),'-')
							AND B.ELEC_PLANT_SITE_ID					= A.p_elec_plant_site_id
							AND ISNULL(NULLIF(B.ELEC_LINE_ID,''),'-')	= ISNULL(NULLIF(A.p_elec_line_id,''),'-')
							AND ISNULL(NULLIF(B.TR_MODE,''),'-')		= ISNULL(NULLIF(A.p_tr_mode,''),'-')
							AND B.YYYYMMDD								= A.p_yyyymmdd
						)
		;

		--히스토리
		INSERT INTO SCP_MST_MODEL_ALLOCATION_H
		(DIVISION_ID,		CELL_PLANT_SITE_ID, CELL_ITEM_ID,		CELL_LINE_ID
		 , ELEC_ITEM_ID,	ELEC_LINE_ID,		ELEC_PLANT_SITE_ID,	TR_MODE,			YYYYMMDD,	VALID_YN
		 , CREATED_BY,		CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE,	ATTRIBUTE1,	HISTORY_CREATION_DATE)
		SELECT A.p_division_id
			   , A.p_cell_plant_site_id
			   , A.p_cell_item_id
			   , A.p_cell_line_id
			   , A.p_elec_item_id
			   , A.p_elec_line_id
			   , A.p_elec_plant_site_id
			   , A.p_tr_mode
			   , A.p_yyyymmdd
			   , A.p_valid_yn
			   , A.p_user_id
			   , @d_event_date
			   , A.p_user_id
			   , @d_event_date
			   , A.p_active_flag
			   , @d_event_date
		FROM @SCP0046 A



		-- 임시 운영반영시에 주석처리 할것.    
		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();
		
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- EXECUTE 후 트랜잭션 개수 불일치 에러 대응(요청 - 김성기 책임, 수정 - 최정훈 차장 2024-12-18 START)
			IF @@TRANCOUNT > 0
			  COMMIT WORK;
			-- EXECUTE 후 트랜잭션 개수 불일치 에러 대응(요청 - 김성기 책임, 수정 - 최정훈 차장 2024-12-18 END)

			-- error코드, errror 메시지 반환
			IF( @v_err_message IS NULL OR @v_err_message ='')
				SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			ELSE
				SELECT 'N' AS result_code, @v_err_message AS ERR_MESSAGE ;

			/*
			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			*/
						
			/* 에러 메시지, 에러 데이터  반환   */	
			/*
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
			*/
			; 
		END;
	END CATCH;
END





