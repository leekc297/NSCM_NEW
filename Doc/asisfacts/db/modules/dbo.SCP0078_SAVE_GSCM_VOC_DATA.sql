/* =============================================================================
프로그램ID	: SCP0078_SAVE_GSCM_VOC_DATA
업  무  명	: VOC > 상세, 비고 등 특정 컬럼 값 저장
프로그램명	: GSCM system VOC
최초작성일	: 2022.02.09
최종작성일	: 2022.02.09
개  발  자	: vadabi3
입  력  값	: 
출  력  값	: 
*===================================================================================================      
*   Date       In Charge	Description      
*===================================================================================================      
* 2022.02.09   vadabi3		Create   

============================================================================= */

--CREATE PROCEDURE dbo.SCP0078_SAVE_GSCM_VOC_DATA
CREATE PROCEDURE [dbo].[SCP0078_SAVE_GSCM_VOC_DATA]
 @p_active_flag                NVARCHAR(MAX) , 
 @p_edit_type                  NVARCHAR(MAX) , 
 @p_voc_no              	   NVARCHAR(MAX) ,      
 @p_voc_type             	   NVARCHAR(MAX) ,   
 @p_voc_name             	   NVARCHAR(MAX) , 
 @p_voc_detail           	   NVARCHAR(MAX) , 
 @p_request_date         	   NVARCHAR(MAX) ,
 @p_request_user_id      	   NVARCHAR(MAX) ,
 @p_scm_pi_user_id       	   NVARCHAR(MAX) , 
 @p_scm_solution_user_id 	   NVARCHAR(MAX) , 
 @p_csr_no               	   NVARCHAR(MAX) ,
 @p_remark               	   NVARCHAR(MAX) ,
 @p_use_yn               	   NVARCHAR(MAX)  	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	SET @v_active_flag = NULL;

	DECLARE @v_voc_no              	   	   NVARCHAR(MAX) ;      
	DECLARE @v_voc_type             	   NVARCHAR(MAX) ;   
	DECLARE @v_voc_name             	   NVARCHAR(MAX) ; 
	DECLARE @v_voc_detail           	   NVARCHAR(MAX) ; 
	DECLARE @v_request_date         	   NVARCHAR(MAX) ;
	DECLARE @v_request_user_id      	   NVARCHAR(MAX) ;;	
	DECLARE @v_scm_pi_user_id       	   NVARCHAR(MAX) ; 
	DECLARE @v_scm_solution_user_id 	   NVARCHAR(MAX) ; 
	DECLARE @v_csr_no               	   NVARCHAR(MAX) ;
	DECLARE @v_remark               	   NVARCHAR(MAX) ;
	DECLARE @v_use_yn               	   NVARCHAR(MAX) ;

	SET @v_voc_no              	 = NULL;
	SET @v_voc_type              = NULL;
	SET @v_voc_name              = NULL;
	SET @v_voc_detail            = NULL;
	SET @v_request_date          = NULL;
	SET @v_request_user_id       = NULL;
	SET @v_scm_pi_user_id        = NULL;
	SET @v_scm_solution_user_id  = NULL;
	SET @v_csr_no                = NULL;
	SET @v_remark                = NULL;
	SET @v_use_yn                = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0078_SAVE_GSCM_VOC_DATA';
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

				SET @v_active_flag					= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_voc_no              			= [dbo].[SCM_ARR_SPL_VAL](@p_voc_no                 , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_voc_type             		= [dbo].[SCM_ARR_SPL_VAL](@p_voc_type             	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_voc_name             		= [dbo].[SCM_ARR_SPL_VAL](@p_voc_name             	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_voc_detail           		= [dbo].[SCM_ARR_SPL_VAL](@p_voc_detail           	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_request_date         		= [dbo].[SCM_ARR_SPL_VAL](@p_request_date         	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_request_user_id      		= [dbo].[SCM_ARR_SPL_VAL](@p_request_user_id      	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_pi_user_id       		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_pi_user_id       	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_solution_user_id 		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_solution_user_id 	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_csr_no               		= [dbo].[SCM_ARR_SPL_VAL](@p_csr_no               	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_remark               		= [dbo].[SCM_ARR_SPL_VAL](@p_remark               	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_use_yn               		= [dbo].[SCM_ARR_SPL_VAL](@p_use_yn               	, @v_delimiter , @mst_loop_cnt) ; 

			END

			--SELECT @v_classify_date;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		

					IF( @v_active_flag ='M') 
						BEGIN


							
							IF LEN(@p_edit_type) > 1 AND @p_edit_type = 'VOC_DETAIL'
								BEGIN 
								UPDATE SCM_ADM_SYS_VOC 
								SET VOC_DETAIL =	@v_voc_detail
								WHERE VOC_NO = @v_voc_no;
								END 

							ELSE IF LEN(@p_edit_type) > 1 AND @p_edit_type = 'REMARK'
								BEGIN 
								UPDATE SCM_ADM_SYS_VOC 
								SET REMARK =	@v_remark
								WHERE VOC_NO = @v_voc_no;
								END 

							-- 구체화 부터 solution 개입
							-- UI에서 구현 위해 다음 배포까지 임시 사용
							ELSE IF LEN(@v_scm_solution_user_id) > 1 AND @p_edit_type = 'SCM_SOLUTION_USER_ID'
								BEGIN 
								UPDATE SCM_ADM_SYS_VOC 
								SET SCM_SOLUTION_USER_ID =	@v_scm_solution_user_id
								WHERE VOC_NO = @v_voc_no;
								END 

							-- 과제 접수/협의 부터 PI 개입
							-- UI에서 구현 위해 다음 배포까지 임시 사용
							ELSE IF LEN(@v_scm_pi_user_id) > 1 AND @p_edit_type = 'SCM_PI_USER_ID'
								BEGIN 
								UPDATE SCM_ADM_SYS_VOC
								SET SCM_PI_USER_ID		=	@v_scm_pi_user_id
								WHERE VOC_NO = @v_voc_no;
								END 
						END

					ELSE IF(@v_active_flag ='I') 
						BEGIN

									INSERT INTO SCM_ADM_SYS_VOC
									(	
										VOC_NO,
										VOC_NAME,
										VOC_DETAIL,
										REQUEST_DATE,
										REQUEST_USER_ID,
										USE_YN
									)
									VALUES
									(
										NEXT VALUE FOR SEQ_SCM_ADM_SYS_VOC,
										@v_voc_name,
										@p_voc_detail,
										GETDATE(),
										@v_request_user_id,
										'Y'
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
