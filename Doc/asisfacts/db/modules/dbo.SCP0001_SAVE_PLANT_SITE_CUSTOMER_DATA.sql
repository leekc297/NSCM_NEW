/****************************************************************************************************/
/* Program ID  : [SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA]														*/
/* Description : SCM_MST_SITE HISTORYT INSERT														*/
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/05/02  ygkim	   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2021/01/20  khj79	   [C20210115-000214] (1)Sales Site (Sales Customer) - Active 이력 저장관련 오류사항  */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA]
	
	--@p_success_yn			NVARCHAR(1) OUTPUT
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_soldto_code			NVARCHAR(MAX),
	@p_soldto_description	NVARCHAR(MAX),
	@p_shipto_code			NVARCHAR(MAX),
	@p_shipto_description	NVARCHAR(MAX),
	@p_rep_yn				NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
	
AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_soldto_code			NVARCHAR(MAX);
	DECLARE @v_soldto_description	NVARCHAR(MAX);
	DECLARE @v_shipto_code			NVARCHAR(MAX);
	DECLARE @v_shipto_description	NVARCHAR(MAX);
	DECLARE @v_rep_yn				NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	--DECLARE	@v_OK_description		NVARCHAR(1200);	-- 자식 프로시저 성공/에러 셋팅

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_soldto_code = NULL;
	SET @v_soldto_description = NULL;	 
	SET @v_shipto_code = NULL;	 
	SET @v_shipto_description = NULL;	 
	SET @v_rep_yn = NULL;	 
	SET @v_valid_yn = NULL;	
	SET @v_created_by = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- @results TEMP TABLE(20180418 ADD SKH)
	DECLARE @results TABLE (
             division_id      NVARCHAR(MAX)
			,scm_site_id      NVARCHAR(MAX)
			,soldto_code      NVARCHAR(MAX)
			,shipto_code      NVARCHAR(MAX)
			)
	DECLARE @v_dup_scm_site_id		NVARCHAR(MAX);
	SET @v_dup_scm_site_id = '';

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN;

		BEGIN TRY

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_active_flag
					  
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_division_id

				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_scm_site_id

				SET @v_soldto_code = [dbo].[SCM_ARR_SPL_VAL](@p_soldto_code, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_soldto_code
			
				SET @v_soldto_description = [dbo].[SCM_ARR_SPL_VAL](@p_soldto_description, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_soldto_description

				SET @v_shipto_code = [dbo].[SCM_ARR_SPL_VAL](@p_shipto_code, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_shipto_code

				SET @v_shipto_description = [dbo].[SCM_ARR_SPL_VAL](@p_shipto_description, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_shipto_description

				SET @v_rep_yn = [dbo].[SCM_ARR_SPL_VAL](@p_rep_yn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_rep_yn

				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_valid_yn

				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_created_by
						
			END

			--HISTORY INSERT
			EXEC	[dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]
						@v_division_id,
						@v_scm_site_id,
						@v_soldto_code,
						@v_shipto_code,		
						@v_rep_yn,
						@v_created_by,
						@v_valid_yn    -- [C20210115-000214] khj79 추가

						--,@v_OK_description OUTPUT
						--SELECT @v_OK_description;

			IF @mst_loop_cnt > 0 

				BEGIN       
				
				-- 	SCM_MST_SITE_CUSTOMER MASTER SAVE LOGIC
					
					IF EXISTS
					(
						SELECT 
							A.division_id,A.scm_site_id,A.soldto_code,A.shipto_code  
						FROM	
						[dbo].[SCM_MST_SITE_CUSTOMER] A  WITH(NOLOCK)	,
						(
								SELECT 
									@v_division_id	as division_id, 
									@v_scm_site_id	as scm_site_id, 
									@v_soldto_code	as soldto_code, 
									@v_shipto_code	as shipto_code
						) B
						WHERE  1 = 1	
								AND A.division_id  = B.division_id
								AND A.scm_site_id  = B.scm_site_id
								AND A.soldto_code  = B.soldto_code
								AND A.shipto_code  = B.shipto_code
					)

						IF @v_rep_yn = 'Y'

							BEGIN

								 UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET
										REP_YN = 'N'
								 WHERE 
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
								;	
						
								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;

							END

						ELSE

							BEGIN

								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;

							END

					ELSE
					
						INSERT INTO	[dbo].[SCM_MST_SITE_CUSTOMER]
								(  
								    division_id		
								   ,scm_site_id							   
								   ,soldto_code
								   ,shipto_code
								   ,rep_yn
								   ,valid_yn
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								)
						 VALUES (   
									@v_division_id
								   ,@v_scm_site_id	
								   ,@v_soldto_code
								   ,@v_shipto_code
								   ,@v_rep_yn
								   ,@v_valid_yn
								   --,CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10)))
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								);


				END

			ELSE    --단일 ROW 일때
			 
				BEGIN        
					SET @v_active_flag			= @p_active_flag        
					SET @p_active_flag			= NULL       
					SET @v_division_id			= @p_division_id        
					SET @p_division_id			= NULL      
					SET @v_soldto_code			= @p_soldto_code        
					SET @p_soldto_code			= NULL  
					SET @v_soldto_description	= @p_soldto_description        
					SET @p_soldto_description	= NULL  
					SET @v_shipto_code			= @p_shipto_code        
					SET @p_shipto_code			= NULL  
					SET @v_shipto_description	= @p_shipto_description     
					SET @p_shipto_description	= NULL  
					SET @v_rep_yn				= @p_rep_yn      
					SET @p_rep_yn				= NULL  
					SET @v_valid_yn				= @p_valid_yn      
					SET @p_valid_yn				= NULL  
					SET @v_created_by = @p_created_by
					SET @p_created_by = NULL
			 
				--HISTORY INSERT

				EXEC	[dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]
						@v_division_id,
						@v_scm_site_id,
						@v_soldto_code,
						@v_shipto_code,		
						@v_rep_yn,
						@v_created_by,
						@v_valid_yn    -- [C20210115-000214] khj79 추가

						--SELECT @v_OK_description;
						--@v_OK_description OUTPUT
					
					IF EXISTS
					(
						SELECT 
							A.division_id,A.scm_site_id,A.soldto_code,A.shipto_code  
						FROM	
						[dbo].[SCM_MST_SITE_CUSTOMER] A  WITH(NOLOCK)	,
						(
								SELECT 
									@v_division_id	as division_id, 
									@v_scm_site_id	as scm_site_id, 
									@v_soldto_code	as soldto_code, 
									@v_shipto_code	as shipto_code
						) B
						WHERE  1 = 1	
								AND A.division_id  = B.division_id
								AND A.scm_site_id  = B.scm_site_id
								AND A.soldto_code  = B.soldto_code
								AND A.shipto_code  = B.shipto_code
					)

						IF @v_rep_yn = 'Y'

							BEGIN

								 UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET
										REP_YN = 'N'
								 WHERE 
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
								;	
						
								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;
							END

						ELSE

							BEGIN

								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;

							END


					ELSE
					
						INSERT INTO	[dbo].[SCM_MST_SITE_CUSTOMER]
								(  
								    division_id		
								   ,scm_site_id							   
								   ,soldto_code
								   ,shipto_code
								   ,rep_yn
								   ,valid_yn
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								)
						 VALUES (   
									@v_division_id
								   ,@v_scm_site_id	
								   ,@v_soldto_code
								   ,@v_shipto_code
								   ,@v_rep_yn
								   ,@v_valid_yn
								   --,CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10)))
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								);

				END

			--------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (start)
			   /*
			   IF isnull((select count(1) from SCM_MST_SITE_CUSTOMER 
			                where 1=1
  							  and division_id = @v_division_id
  							  and shipto_code = @v_shipto_code
							  and VALID_YN = 'Y'                    -- VALID_YN = 'Y' 것만 중복체크
			                group by division_id, shipto_code
							HAVING COUNT(*) > 1                     -- ui에서 input받은 데이터 포함하여 2건이상인것 체크
				   ),0) > 1
				   begin  -- 중복 발생인경우의 logic
					   
					   set @v_dup_scm_site_id = ''
					   set @v_dup_scm_site_id = (select top 1 scm_site_id from SCM_MST_SITE_CUSTOMER   -- 정상인경우 2건이상일수 없지만 현재 데이터정비가 되어있지 않아 top 1 으로 한건만 추출
			                where 1=1
  							  and division_id = @v_division_id
  							  and shipto_code = @v_shipto_code
							  and scm_site_id <> @v_scm_site_id      -- ui에서 input받은 scm_site_id 제외하고 존재하고있는 scm_site_id 를 추출
							  and VALID_YN = 'Y')

					   SET @v_log_type = 'INVALID';
					   SELECT N'MSG00179',@v_dup_scm_site_id,@v_shipto_code     -- ui측에 전달하여 중복대상인 scm_site_id와 shipto_code를 pop_up 시킴
					   --  ' Ford_US_RDF Sales Site 에서 USH000534A Ship-To Code가 이미 사용중입니다.'
					   --   {0} Sales Site 에서  {1} Ship-To Code가 이미 사용중입니다.
					   goto err_rtn
				   end
				   */
			--------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (end)
			END


			COMMIT TRAN ;	

		END TRY

	BEGIN CATCH

		ROLLBACK TRAN ;	

		  -- ERROR LOG
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		  SET @d_event_date = SYSDATETIME();

		  --IF @v_OK_description <> 'OK'
		  --SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));
		  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

	END CATCH;

	SET NOCOUNT OFF;


	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END;
	
    --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (start)
	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRAN
		end
    --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (end)


