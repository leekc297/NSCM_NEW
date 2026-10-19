/*
 * Program ID   : SSP0025_SAVE_SHIPMENTOR_REQUEST_PIC
 * Description  : Shipment Requestor PIC 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/06/23   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 */
 
CREATE PROCEDURE [dbo].[SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC]
	 @p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_item_id 			NVARCHAR(MAX)
	,@p_user_id 			NVARCHAR(MAX)
	,@p_create_id			NVARCHAR(MAX)
	,@p_part_leader			NVARCHAR(MAX)
	,@p_team_leader			NVARCHAR(MAX)
	,@p_valid_yn			NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;
	SET @recv_active_flag = @p_active_flag;

	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_to_site				NVARCHAR(MAX);
	DECLARE @v_item_id 				NVARCHAR(MAX);
	DECLARE @v_user_id				NVARCHAR(MAX);
	DECLARE @v_part_leader			NVARCHAR(MAX);
	DECLARE @v_team_leader			NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);


	SET @v_active_flag	= NULL;
	SET @v_division_id	= NULL;
	SET @v_to_site		= NULL;
	SET @v_item_id		= NULL;
	SET @v_user_id		= NULL;
	SET @v_part_leader	= NULL;
	SET @v_team_leader	= NULL;
	SET @v_valid_yn		= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC';
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
				SET @v_active_flag		= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_to_site			= [dbo].[SCM_ARR_SPL_VAL](@p_to_site		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id			= [dbo].[SCM_ARR_SPL_VAL](@p_user_id		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_part_leader		= [dbo].[SCM_ARR_SPL_VAL](@p_part_leader	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_team_leader		= [dbo].[SCM_ARR_SPL_VAL](@p_team_leader	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_valid_yn			= [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn		, @v_delimiter , @mst_loop_cnt) ;
			END

			--데이터 저장
			IF @mst_loop_cnt > 0
				BEGIN		
					MERGE INTO SSP_MST_MODEL_USER_EE A
					USING (
							SELECT 
									 @v_division_id as division_id
									,@v_to_site as to_site
									,@v_item_id as item_id
									,@v_user_id as user_id
							) B
					ON(
									a.division_id = b.division_id
								AND a.to_site = b.to_site
								AND	a.item_id = b.item_id
						)
					WHEN MATCHED THEN
							UPDATE SET 	
								 user_id				= @v_user_id
								,valid_yn				= @v_valid_yn
								,part_leader			= @v_part_leader
								,team_leader			= @v_team_leader
								,last_updated_by		= @p_create_id
								,last_update_date		= sysdatetime()
					                
					WHEN NOT MATCHED THEN
					INSERT	(		
								 DIVISION_ID
								,TO_SITE
								,ITEM_ID
								,USER_ID
								,VALID_YN
								,PART_LEADER
								,TEAM_LEADER
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
							)
					VALUES  (
					 			 @v_division_id,@v_to_site,@v_item_id, @v_user_id, @v_valid_yn, @v_part_leader, @v_team_leader
								,@p_create_id, SYSDATETIME(), @p_create_id, SYSDATETIME()
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
