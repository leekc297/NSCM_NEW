


/*
 * Program ID   : SCP0002_SAVE_LINE_MASTER_OSP
 * Description  : Line Master OSP 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/01/21   YHW				Initial Release [] GSCM(SCP) 운영 - [C20200116-000114] ESS 외주 Packer Line 계획 수립
 * 2023/03/07   vadabi3         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  : SCS Prod Amend 추가
 */
CREATE PROCEDURE [dbo].[SCP0002_SAVE_LINE_MASTER_OSP]
	 @p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_scm_site_id			NVARCHAR(MAX)
	,@p_line_id 			NVARCHAR(MAX)
	,@p_line_name 			NVARCHAR(MAX)
	,@p_operation_id		NVARCHAR(MAX)
	,@p_scs_prod_amend		NVARCHAR(MAX)
	,@p_valid_yn 			NVARCHAR(MAX)
	,@p_created_by			NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id 			NVARCHAR(MAX);
	DECLARE @v_line_id 				NVARCHAR(MAX);
	DECLARE @v_line_name			NVARCHAR(MAX);
	DECLARE @v_operation_id			NVARCHAR(MAX);
	DECLARE @v_scs_prod_amend	    NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);


	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_line_id = NULL;
	SET @v_line_name = NULL;
	SET @v_operation_id = NULL;
	SET @v_scs_prod_amend = NULL;
	SET @v_valid_yn = NULL;
	SET @v_created_by = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0002_SAVE_LINE_MASTER_OSP';
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

		--PRINT '2';
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
				SET @v_scm_site_id		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_line_id			= [dbo].[SCM_ARR_SPL_VAL](@p_line_id		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_line_name		= [dbo].[SCM_ARR_SPL_VAL](@p_line_name		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_operation_id		= [dbo].[SCM_ARR_SPL_VAL](@p_operation_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scs_prod_amend	= [dbo].[SCM_ARR_SPL_VAL](@p_scs_prod_amend	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_valid_yn			= [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_created_by		= [dbo].[SCM_ARR_SPL_VAL](@p_created_by		, @v_delimiter , @mst_loop_cnt) ; 

			END

			-- 이력 저장



			--이력저장
			INSERT INTO SCM_MST_LINE_OSP_H
			(HISTORY_SEQ,	DIVISION_ID,	SCM_SITE_ID,	LINE_ID,			LINE_NAME,			OPERATION_ID,
			 VALID_YN,		CREATED_BY,		CREATION_DATE,	LAST_UPDATED_BY,	LAST_UPDATE_DATE,
			 ATTRIBUTE1,	ATTRIBUTE2,		HISTORY_CREATION_DATE)
			VALUES
			((NEXT VALUE FOR SEQ1_SCM_MST_LINE_OSP_H)
			 ,@v_division_id
			 ,@v_scm_site_id
			 ,@v_line_id
			 ,@v_line_name
			 ,@v_operation_id
			 ,@v_valid_yn
			 ,@v_created_by
			 ,SYSDATETIME()
			 ,@v_created_by
			 ,SYSDATETIME()
			 ,@v_active_flag
			 ,@v_scs_prod_amend
			 ,SYSDATETIME())
			;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		

					IF( @v_active_flag ='M') 
						BEGIN

							UPDATE SCM_MST_LINE_OSP
							SET  LINE_NAME			= @v_line_name
								,VALID_YN			= @v_valid_yn
								,ATTRIBUTE1			= @v_scs_prod_amend
							    ,LAST_UPDATED_BY	= @v_created_by
								,LAST_UPDATE_DATE	= SYSDATETIME()
							WHERE DIVISION_ID   = @v_division_id
							  AND SCM_SITE_ID	= @v_scm_site_id
							  AND LINE_ID		= @v_line_id
							;
							  
						END
					ELSE IF(@v_active_flag ='I') 
						BEGIN

							INSERT INTO SCM_MST_LINE_OSP (
									 DIVISION_ID
									 , SCM_SITE_ID
									 , LINE_ID
									 , LINE_NAME
									 , OPERATION_ID
									 , VALID_YN
									 , ATTRIBUTE1
									 , CREATED_BY
									 , CREATION_DATE
									 , LAST_UPDATED_BY
									 , LAST_UPDATE_DATE
								)
							VALUES  (
					 				 @v_division_id
									 , @v_scm_site_id
									 , @v_line_id
									 , @v_line_name
									 , @v_operation_id
									 , @v_valid_yn
									 , @v_scs_prod_amend
									 , @v_created_by
									 , SYSDATETIME()
									 , @v_created_by
									 , SYSDATETIME()
								);
	
						END
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


