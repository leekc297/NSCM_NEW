/*
 * Program ID   : SSP0014_SAVE_SHIPMENT_MODEL_PIC
 * Description  : Shipment Model PIC 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/22   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/06/17	AYJ			   [CSR ID:4017374] [요청] Shipment Model PIC Part Leader/ Team Leader 추가
 * 2022/01/25   jilee          SSP_MST_MODEL_USER 등록된 추가 사용자 메일 발송 (ATTRIBUTE*)

 */
CREATE PROCEDURE [dbo].[SSP0014_SAVE_SHIPMENT_MODEL_PIC]
	 @p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id 			NVARCHAR(MAX)
	,@p_user_id 			NVARCHAR(MAX)
	,@p_valid_yn 			NVARCHAR(MAX)
	,@p_create_id			NVARCHAR(MAX)
	,@p_part_leader			NVARCHAR(MAX)
	,@p_team_leader			NVARCHAR(MAX)
	,@p_mail_user1          NVARCHAR(MAX)
	,@p_mail_user2          NVARCHAR(MAX)
	,@p_mail_user3          NVARCHAR(MAX)
	,@p_mail_user4          NVARCHAR(MAX)
	,@p_mail_user5          NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_from_site 			NVARCHAR(MAX);
	DECLARE @v_item_id 				NVARCHAR(MAX);
	DECLARE @v_user_id				NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_part_leader			NVARCHAR(MAX);
	DECLARE @v_team_leader			NVARCHAR(MAX);
	DECLARE @v_mail_user1		    NVARCHAR(MAX);
	DECLARE @v_mail_user2	     	NVARCHAR(MAX);
	DECLARE @v_mail_user3	     	NVARCHAR(MAX);
	DECLARE @v_mail_user4	     	NVARCHAR(MAX);
	DECLARE @v_mail_user5	     	NVARCHAR(MAX);

	SET @v_active_flag	= NULL;
	SET @v_division_id	= NULL;
	SET @v_from_site	= NULL;
	SET @v_item_id		= NULL;
	SET @v_user_id		= NULL;
	SET @v_valid_yn		= NULL;
	SET @v_part_leader	= NULL;
	SET @v_team_leader	= NULL;
	SET @v_mail_user1   = NULL;
	SET @v_mail_user2   = NULL;
	SET @v_mail_user3   = NULL;
	SET @v_mail_user4   = NULL;
	SET @v_mail_user5   = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0014_SAVE_SHIPMENT_MODEL_PIC';
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
				SET @v_from_site		= [dbo].[SCM_ARR_SPL_VAL](@p_from_site		, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_user_id			= [dbo].[SCM_ARR_SPL_VAL](@p_user_id		, @v_delimiter , @mst_loop_cnt) ; 				   				
				SET @v_valid_yn			= [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn		, @v_delimiter , @mst_loop_cnt) ;  
				SET @v_part_leader		= [dbo].[SCM_ARR_SPL_VAL](@p_part_leader	, @v_delimiter , @mst_loop_cnt) ;  
				SET @v_team_leader		= [dbo].[SCM_ARR_SPL_VAL](@p_team_leader	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_mail_user1   	= [dbo].[SCM_ARR_SPL_VAL](@p_mail_user1     , @v_delimiter , @mst_loop_cnt) ;  
				SET @v_mail_user2	    = [dbo].[SCM_ARR_SPL_VAL](@p_mail_user2     , @v_delimiter , @mst_loop_cnt) ;
				SET @v_mail_user3	    = [dbo].[SCM_ARR_SPL_VAL](@p_mail_user3     , @v_delimiter , @mst_loop_cnt) ;
				SET @v_mail_user4	    = [dbo].[SCM_ARR_SPL_VAL](@p_mail_user4     , @v_delimiter , @mst_loop_cnt) ;
				SET @v_mail_user5	    = [dbo].[SCM_ARR_SPL_VAL](@p_mail_user5     , @v_delimiter , @mst_loop_cnt) ;
			END

			IF @v_mail_user1 = ''
				BEGIN
					SET @v_mail_user1 = NULL;
				END
			IF @v_mail_user2 = ''
				BEGIN
					SET @v_mail_user2 = NULL;
				END
			IF @v_mail_user3 = ''
				BEGIN
					SET @v_mail_user3 = NULL;
				END
			IF @v_mail_user4 = ''
				BEGIN
					SET @v_mail_user4 = NULL;
				END
			IF @v_mail_user5 = ''
				BEGIN
					SET @v_mail_user5 = NULL;
				END

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					MERGE INTO SSP_MST_MODEL_USER A
					USING (
							SELECT 
									 @v_division_id as division_id
									,@v_from_site as from_site
									,@v_item_id as item_id
							) B
					ON(
									a.division_id = b.division_id
								AND a.from_site = b.from_site
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
					            ,attribute1             = @v_mail_user1
								,attribute2             = @v_mail_user2
								,attribute3             = @v_mail_user3
								,attribute4             = @v_mail_user4
								,attribute5             = @v_mail_user5
    
					WHEN NOT MATCHED THEN
					INSERT	(		
								 DIVISION_ID
								,FROM_SITE
								,ITEM_ID
								,USER_ID
								,VALID_YN
								,PART_LEADER
								,TEAM_LEADER
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
								,ATTRIBUTE1
								,ATTRIBUTE2
								,ATTRIBUTE3
								,ATTRIBUTE4
								,ATTRIBUTE5
							)
					VALUES  (
					 			 @v_division_id,@v_from_site,@v_item_id, @v_user_id, @v_valid_yn, @v_part_leader, @v_team_leader
								,@p_create_id, SYSDATETIME(), @p_create_id, SYSDATETIME(), @v_mail_user1, @v_mail_user2, @v_mail_user3, @v_mail_user4, @v_mail_user5
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
