

/*
 * Program ID   : SCP0037_SAVE_OPERATION_LT
 * Description  : Operation LT 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/25   YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/11/19	YHW				[IT서비스 C20191107-000099] 외주 Packer 후공정 L/T 적용 요청
 * 2021/08/23   kmj				PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - INV_FLAG 저장 추가(SCP_MST_OPERATION_LT.ATTRIBUTE1)
 */
CREATE PROCEDURE [dbo].[SCP0037_SAVE_OPERATION_LT]
	 @p_active_flag		NVARCHAR(MAX)
	,@p_division_id		NVARCHAR(MAX)
	,@p_scm_site_id		NVARCHAR(MAX)
	,@p_item_id 		NVARCHAR(MAX)
	,@p_lt_operation 	NVARCHAR(MAX)
	,@p_lt_day 			NVARCHAR(MAX)
	,@p_created_by		NVARCHAR(MAX)
	,@p_creation_date	NVARCHAR(MAX)
	,@p_last_updated_by	NVARCHAR(MAX)
	,@p_inv_flag		NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;


	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='FALSE';
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='TRUE';

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id 			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_lt_operation			NVARCHAR(MAX);
	DECLARE @v_lt_day				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_creation_date		DATETIME;
	DECLARE @v_last_updated_by		NVARCHAR(MAX);
	DECLARE @v_inv_flag				NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id= NULL;
	SET @v_scm_site_id = NULL;
	SET @v_item_id = NULL;
	SET @v_lt_operation = NULL;
	SET @v_lt_day = NULL;
	SET @v_created_by = NULL;	  
	SET @v_creation_date = NULL;
	SET @v_last_updated_by = NULL;
	SET @v_inv_flag = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0037_SAVE_OPERATION_LT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- Project Route 체크용 변수
	DECLARE @v_data_no_cnt  INT=0;
	DECLARE @v_data_no_msg  NVARCHAR(300)='';

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0037') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0037
	;

	CREATE TABLE #TblDynamic_SCP0037 (
		active_flag	nvarchar(1),
		division_id	nvarchar(30),
		plant_site_id	nvarchar(30),
		item_id		nvarchar(50)
	);

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


		-- 1. Validation 체크(Project Route)
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			BEGIN
				SET @v_active_flag		= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_scm_site_id		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter , @mst_loop_cnt) ;
			END

			INSERT INTO #TblDynamic_SCP0037
			SELECT @v_active_flag			AS active_flag
					, @v_division_id		AS division_id
					, @v_scm_site_id		AS plant_site_id
					, @v_item_id			AS item_id
			;
		END

		IF @mst_loop_cnt > 0
		BEGIN
			-- project route 체크
			SET @v_data_no_cnt = 0;
			SET @v_data_no_msg = '';

			SELECT @v_data_no_cnt = COUNT(*) 
			FROM #TblDynamic_SCP0037 A 
			WHERE A.active_flag='I'
			  AND NOT EXISTS (
								SELECT 'X' FROM SCM_MST_SITE_ITEM_PRIORITY B WITH(NOLOCK)
								WHERE B.DIVISION_ID = A.division_id
								AND B.PLANT_SITE_ID = A.plant_site_id
								AND B.ITEM_ID		= A.item_id
								AND B.VALID_YN		= 'Y'
							 )
			;

			IF( @v_data_no_cnt>0) 
				BEGIN
					SET @v_data_no_msg = (
									SELECT TOP 1 A.division_id+'/'+A.plant_site_id+'/'+A.item_id AS NO_MSG
									FROM #TblDynamic_SCP0037 A 
									WHERE A.active_flag='I'
									  AND NOT EXISTS (
														SELECT 'X' FROM SCM_MST_SITE_ITEM_PRIORITY B WITH(NOLOCK)
														WHERE B.DIVISION_ID = A.division_id
														AND B.PLANT_SITE_ID = A.plant_site_id
														AND B.ITEM_ID		= A.item_id
														AND B.VALID_YN		= 'Y'
													 )
									);
					SET @v_err_code    = 99020 ; 
					SET @v_err_message = N'Project Route 정보가 없습니다. '+@v_data_no_msg;
					THROW @v_err_code, @v_err_message , 1; --예외발생
				END

		END


		SET @mst_loop_cnt = 0;

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
			--PRINT '3';	
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag		= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_site_id		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id		, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_lt_operation		= [dbo].[SCM_ARR_SPL_VAL](@p_lt_operation	, @v_delimiter , @mst_loop_cnt) ; 				   				
				SET @v_lt_day			= [dbo].[SCM_ARR_SPL_VAL](@p_lt_day			, @v_delimiter , @mst_loop_cnt) ;    

				SET @v_created_by		= [dbo].[SCM_ARR_SPL_VAL](@p_created_by		, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_creation_date	= [dbo].[SCM_ARR_SPL_VAL](@p_creation_date	, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_last_updated_by	= [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @mst_loop_cnt) ; 

				SET @v_inv_flag			= [dbo].[SCM_ARR_SPL_VAL](@p_inv_flag		, @v_delimiter , @mst_loop_cnt) ;    
			END

			-- LOOP 파라미터 출력 DEBUG용			
			BEGIN		
				PRINT '===============================================';			
				PRINT '@v_active_flag     = ''' +@v_active_flag +'''';
				PRINT '@v_division_id     = ''' +@v_division_id +'''';
				PRINT '@v_scm_site_id     = ''' +@v_scm_site_id +'''';
				PRINT '@v_item_id         = ''' +@v_item_id +'''';
				PRINT '@v_lt_operation    = ''' +@v_lt_operation +'''';
				PRINT '@v_lt_day          = ''' +@v_lt_day +'''';
				PRINT '@v_last_updated_by = ''' +@v_last_updated_by +'''';
				PRINT '@v_inv_flag		  = ''' +@v_inv_flag +'''';
				PRINT '@mst_loop_cnt      = ''' +CONVERT(VARCHAR(10), @mst_loop_cnt) +'''';				
			END;

		   --이력저장
			IF (@v_inv_flag = NULL OR @v_inv_flag = '')
				BEGIN
					EXEC [PR_SCP_MST_OPERATION_LT_HIST] @v_division_id,@v_scm_site_id,@v_item_id,@v_lt_operation,@v_lt_day,@v_created_by,@v_creation_date,@v_last_updated_by ; 
				END
			ELSE
				BEGIN
					INSERT INTO SCP_MST_OPERATION_LT_H (
						HISTORY_SEQ
						, DIVISION_ID
						, SCM_SITE_ID
						, ITEM_ID
						, LT_OPERATION
						, LT_DAY
						, CREATED_BY
						, CREATION_DATE
						, LAST_UPDATED_BY
						, LAST_UPDATE_DATE
						, ATTRIBUTE1
						, HISTORY_CREATION_DATE

					)
					VALUES (
						NEXT VALUE FOR SEQ1_SCP_MST_OPERATION_LT_H
						,@v_division_id
						,@v_scm_site_id
						,@v_item_id
						,@v_lt_operation
						,@v_lt_day
						,@v_created_by
						,@v_creation_date
						,@v_last_updated_by
						,SYSDATETIME()
						,IIF(@v_inv_flag='N', NULL, @v_inv_flag)
						,SYSDATETIME()
					);

				END
			
			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					MERGE INTO SCP_MST_OPERATION_LT A
					USING (
							SELECT 
									 @v_division_id		as division_id
									,@v_scm_site_id		as scm_site_id
									,@v_item_id			as item_id
									,@v_lt_operation	as lt_operation
							) B
					ON(
									a.division_id = b.division_id
								AND a.scm_site_id = b.scm_site_id
								AND	a.item_id = b.item_id
								AND	a.lt_operation = b.lt_operation
						)
					WHEN MATCHED THEN
							UPDATE SET 	
								 lt_day				= @v_lt_day
								 ,ATTRIBUTE1		 = IIF(@v_inv_flag='N', NULL, @v_inv_flag)
								 ,last_updated_by	= @v_last_updated_by
								 ,last_update_date	= sysdatetime()
					                
					WHEN NOT MATCHED THEN
					INSERT	(		
								 division_id,scm_site_id,item_id,LT_OPERATION,LT_DAY
								,created_by, creation_date, last_updated_by, last_update_date, attribute1
							)
					VALUES  (
					 			 @v_division_id,@v_scm_site_id,@v_item_id,@v_lt_operation,@v_lt_day
								,@v_created_by, SYSDATETIME(), @v_created_by, SYSDATETIME(), IIF(@v_inv_flag='N', NULL, @v_inv_flag)
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
		  --SELECT 'F' AS result_code;
		  --SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();


		  -- error코드, errror 메시지 반환
			IF( @v_err_message IS NULL OR @v_err_message ='')
				BEGIN
					SELECT 'F' AS result_code;
					SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
				END
			ELSE
				BEGIN
					SELECT 'N' AS result_code;
					SELECT @v_err_message AS ERR_MESSAGE ;
				END

		END CATCH;
	END

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0037') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0037
	;

