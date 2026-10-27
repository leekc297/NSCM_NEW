

/*
 * Program ID   : PR_UI_FP00519_SAVE
 * Description  : PJT Status & Production Type
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/09   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00519_SAVE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_division_id		NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_applied_model		NVARCHAR(MAX),
  @p_production_type	NVARCHAR(MAX)
  
AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00519_SAVE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	DECLARE @v_log_message	NVARCHAR(MAX) = '';
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	        INTEGER = 0;
	DECLARE @recv_active_flag       NVARCHAR(MAX);		
	DECLARE @v_delimiter            NVARCHAR(1);

	DECLARE @v_sys_type			    NVARCHAR(MAX);  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag			    NVARCHAR(MAX);  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun			NVARCHAR(MAX); 
	DECLARE @v_user_id			    NVARCHAR(MAX);
	
	DECLARE @v_company_id           NVARCHAR(MAX);
	DECLARE @v_division_id          NVARCHAR(MAX);
	DECLARE @v_applied_model        NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);  
	DECLARE @v_production_type		NVARCHAR(MAX);
	

	SET @recv_active_flag       = @p_sys_flag;
	SET @v_delimiter            = '^';  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter); -- 프로시저 LOOP 길이를 판단 


	BEGIN TRY
		BEGIN TRAN		

			BEGIN 
				--max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
				WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
					BEGIN --WHILE 내(START)
					 
						BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
							SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

							SET @v_sys_type			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_type			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_sys_flag			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_flag			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_sys_gubun			= [dbo].[SCM_ARR_SPL_VAL]( @p_sys_gubun			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_user_id			    = [dbo].[SCM_ARR_SPL_VAL]( @p_user_id			    ,@v_delimiter, @mst_loop_cnt);
							
							SET @v_division_id          = [dbo].[SCM_ARR_SPL_VAL]( @p_division_id           ,@v_delimiter, @mst_loop_cnt);
							SET @v_item_id				= [dbo].[SCM_ARR_SPL_VAL]( @p_item_id				,@v_delimiter, @mst_loop_cnt);  
							SET @v_applied_model        = [dbo].[SCM_ARR_SPL_VAL]( @p_applied_model         ,@v_delimiter, @mst_loop_cnt);
							SET @v_production_type      = [dbo].[SCM_ARR_SPL_VAL]( @p_production_type       ,@v_delimiter, @mst_loop_cnt);
							
						END

						BEGIN
					
							IF (@v_sys_flag = 'U')
							BEGIN

								SET @v_dSql = '';
								SET @v_dSql += '	UPDATE FP_PLM_PJT_MODEL_MASTER  																	' + char(10);
								SET @v_dSql += '	SET    PRODUCTION_TYPE = '''+ @v_production_type +'''                                               ' + char(10);
								SET @v_dSql += '		 , UPDATE_ID = '''+ @v_user_id +'''																' + char(10);
								SET @v_dSql += '		 , UPDATE_TIME = GETDATE()																		' + char(10);
								SET @v_dSql += '	WHERE  1=1                                                                                          ' + char(10);
								SET @v_dSql += '	AND    DIVISION_ID = '''+ @v_division_id +'''                                                       ' + char(10);
								SET @v_dSql += '	AND    MODEL_ID    = '''+ @v_applied_model +'''                                                     ' + char(10);
								SET @v_dSql += '	;                                                                                                   ' + char(10);
								SET @v_dSql += '	                                                                                                    ' + char(10);
								SET @v_dSql += '	INSERT INTO HIS_PLM_PJT_MODEL_MASTER (                                                              ' + char(10);
								SET @v_dSql += '	     PROJECT_ID                                                                                     ' + char(10);
								SET @v_dSql += '	    ,PROJECT_NAME                                                                                   ' + char(10);
								SET @v_dSql += '	    ,DIVISION_ID                                                                                    ' + char(10);
								SET @v_dSql += '	    ,MODEL_ID                                                                                       ' + char(10);
								SET @v_dSql += '	    ,PJT_PROGRESS_STEP_ID                                                                           ' + char(10);
								SET @v_dSql += '	    ,PJT_STATUS_ID                                                                                  ' + char(10);
								SET @v_dSql += '	    ,PJT_SCHEDULE_DATE                                                                              ' + char(10);
								SET @v_dSql += '	    ,PRODUCTION_TYPE                                                                                ' + char(10);
								SET @v_dSql += '	    ,FP_PJT_SCHEDULE_DATE                                                                           ' + char(10);
								SET @v_dSql += '	    ,INSERT_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	    ,INSERT_ID                                                                                      ' + char(10);
								SET @v_dSql += '	    ,UPDATE_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	    ,UPDATE_ID                                                                                      ' + char(10);
								SET @v_dSql += '	    ,JOB_USER_ID, JOB_TIME, JOB_TYPE                                                                ' + char(10);
								SET @v_dSql += '	)                                                                                                   ' + char(10);
								SET @v_dSql += '	SELECT PROJECT_ID                                                                                   ' + char(10);
								SET @v_dSql += '	    ,PROJECT_NAME                                                                                   ' + char(10);
								SET @v_dSql += '	    ,DIVISION_ID                                                                                    ' + char(10);
								SET @v_dSql += '	    ,MODEL_ID                                                                                       ' + char(10);
								SET @v_dSql += '	    ,PJT_PROGRESS_STEP_ID                                                                           ' + char(10);
								SET @v_dSql += '	    ,PJT_STATUS_ID                                                                                  ' + char(10);
								SET @v_dSql += '	    ,PJT_SCHEDULE_DATE                                                                              ' + char(10);
								SET @v_dSql += '	    ,PRODUCTION_TYPE                                                                                ' + char(10);
								SET @v_dSql += '	    ,FP_PJT_SCHEDULE_DATE                                                                           ' + char(10);
								SET @v_dSql += '	    ,INSERT_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	    ,INSERT_ID                                                                                      ' + char(10);
								SET @v_dSql += '	    ,UPDATE_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	    ,UPDATE_ID                                                                                      ' + char(10);
								SET @v_dSql += '	    ,'''+ @v_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''UPDATE'' AS JOB_TYPE             ' + char(10);
								SET @v_dSql += '	FROM 	FP_PLM_PJT_MODEL_MASTER A WITH(NOLOCK)                                                      ' + char(10);
								SET @v_dSql += '	WHERE	1=1                                                                                         ' + char(10);
								SET @v_dSql += '	AND   A.DIVISION_ID   = '''+ @v_division_id +'''                                                    ' + char(10);
								SET @v_dSql += '	AND   A.MODEL_ID    	= '''+ @v_applied_model +'''                                                ' + char(10);
								SET @v_dSql += '	;                                                                                                   ' + char(10);
								SET @v_dSql += '	                                                                                                    ' + char(10);
								SET @v_dSql += '	INSERT INTO HIS_PLM_PJT_MODEL_MASTER (                                                              ' + char(10);
								SET @v_dSql += '	     PROJECT_ID                                                                                     ' + char(10);
								SET @v_dSql += '	   , PROJECT_NAME                                                                                   ' + char(10);
								SET @v_dSql += '	   , DIVISION_ID                                                                                    ' + char(10);
								SET @v_dSql += '	   , MODEL_ID                                                                                       ' + char(10);
								SET @v_dSql += '	   , PJT_PROGRESS_STEP_ID                                                                           ' + char(10);
								SET @v_dSql += '	   , PJT_STATUS_ID                                                                                  ' + char(10);
								SET @v_dSql += '	   , PJT_SCHEDULE_DATE                                                                              ' + char(10);
								SET @v_dSql += '	   , PRODUCTION_TYPE                                                                                ' + char(10);
								SET @v_dSql += '	   , FP_PJT_SCHEDULE_DATE                                                                           ' + char(10);
								SET @v_dSql += '	   , INSERT_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	   , INSERT_ID                                                                                      ' + char(10);
								SET @v_dSql += '	   , UPDATE_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	   , UPDATE_ID                                                                                      ' + char(10);
								SET @v_dSql += '	   , JOB_USER_ID, JOB_TIME, JOB_TYPE                                                                ' + char(10);
								SET @v_dSql += '	)                                                                                                   ' + char(10);
								SET @v_dSql += '	SELECT NULL AS PROJECT_ID                                                                           ' + char(10);
								SET @v_dSql += '	   , NULL AS PROJECT_NAME                                                                           ' + char(10);
								SET @v_dSql += '	   , A.DIVISION_ID                                                                                  ' + char(10);
								SET @v_dSql += '	   , A.MODEL_ID                                                                                     ' + char(10);
								SET @v_dSql += '	   , NULL AS PJT_PROGRESS_STEP_ID                                                                   ' + char(10);
								SET @v_dSql += '	   , NULL AS PJT_STATUS_ID                                                                          ' + char(10);
								SET @v_dSql += '	   , NULL AS PJT_SCHEDULE_DATE                                                                      ' + char(10);
								SET @v_dSql += '	   , A.PRODUCTION_TYPE                                                                              ' + char(10);
								SET @v_dSql += '	   , NULL AS FP_PJT_SCHEDULE_DATE                                                                   ' + char(10);
								SET @v_dSql += '	   , GETDATE() AS INSERT_TIME                                                                       ' + char(10);
								SET @v_dSql += '	   , A.USER_ID AS INSERT_ID                                                                         ' + char(10);
								SET @v_dSql += '	   , GETDATE() AS UPDATE_TIME                                                                       ' + char(10);
								SET @v_dSql += '	   , A.USER_ID AS UPDATE_ID                                                                         ' + char(10);
								SET @v_dSql += '	   , A.USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''INSERT'' AS JOB_TYPE                        ' + char(10);
								SET @v_dSql += '	FROM	(                                                                                           ' + char(10);
								SET @v_dSql += '				SELECT '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_applied_model +''' AS MODEL_ID  ' + char(10);
								SET @v_dSql += '					 , '''+ @v_production_type +''' AS PRODUCTION_TYPE, '''+ @v_user_id +''' AS USER_ID	' + char(10);
								SET @v_dSql += '			) A                                                                                         ' + char(10);
								SET @v_dSql += '	WHERE NOT EXISTS (                                                                                  ' + char(10);
								SET @v_dSql += '		SELECT 1                                                                                        ' + char(10);
								SET @v_dSql += '		FROM   FP_PLM_PJT_MODEL_MASTER BB                                                               ' + char(10);
								SET @v_dSql += '		WHERE  A.DIVISION_ID = BB.DIVISION_ID                                                           ' + char(10);
								SET @v_dSql += '		AND    A.MODEL_ID    = BB.MODEL_ID                                                              ' + char(10);
								SET @v_dSql += '	)                                                                                                   ' + char(10);
								SET @v_dSql += '	;                                                                                                   ' + char(10);
								SET @v_dSql += '	                                                                                                    ' + char(10);
								SET @v_dSql += '	INSERT INTO FP_PLM_PJT_MODEL_MASTER (                                                               ' + char(10);
								SET @v_dSql += '	     PROJECT_ID                                                                                     ' + char(10);
								SET @v_dSql += '	   , PROJECT_NAME                                                                                   ' + char(10);
								SET @v_dSql += '	   , DIVISION_ID                                                                                    ' + char(10);
								SET @v_dSql += '	   , MODEL_ID                                                                                       ' + char(10);
								SET @v_dSql += '	   , PJT_PROGRESS_STEP_ID                                                                           ' + char(10);
								SET @v_dSql += '	   , PJT_STATUS_ID                                                                                  ' + char(10);
								SET @v_dSql += '	   , PJT_SCHEDULE_DATE                                                                              ' + char(10);
								SET @v_dSql += '	   , PRODUCTION_TYPE                                                                                ' + char(10);
								SET @v_dSql += '	   , FP_PJT_SCHEDULE_DATE                                                                           ' + char(10);
								SET @v_dSql += '	   , INSERT_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	   , INSERT_ID                                                                                      ' + char(10);
								SET @v_dSql += '	   , UPDATE_TIME                                                                                    ' + char(10);
								SET @v_dSql += '	   , UPDATE_ID                                                                                      ' + char(10);
								SET @v_dSql += '	)                                                                                                   ' + char(10);
								SET @v_dSql += '	SELECT NULL AS PROJECT_ID                                                                           ' + char(10);
								SET @v_dSql += '	   , NULL AS PROJECT_NAME                                                                           ' + char(10);
								SET @v_dSql += '	   , A.DIVISION_ID                                                                                  ' + char(10);
								SET @v_dSql += '	   , A.MODEL_ID                                                                                     ' + char(10);
								SET @v_dSql += '	   , NULL AS PJT_PROGRESS_STEP_ID                                                                   ' + char(10);
								SET @v_dSql += '	   , NULL AS PJT_STATUS_ID                                                                          ' + char(10);
								SET @v_dSql += '	   , NULL AS PJT_SCHEDULE_DATE                                                                      ' + char(10);
								SET @v_dSql += '	   , A.PRODUCTION_TYPE                                                                              ' + char(10);
								SET @v_dSql += '	   , NULL AS FP_PJT_SCHEDULE_DATE                                                                   ' + char(10);
								SET @v_dSql += '	   , GETDATE() AS INSERT_TIME                                                                       ' + char(10);
								SET @v_dSql += '	   , A.USER_ID AS INSERT_ID                                                                         ' + char(10);
								SET @v_dSql += '	   , GETDATE() AS UPDATE_TIME                                                                       ' + char(10);
								SET @v_dSql += '	   , A.USER_ID AS UPDATE_ID                                                                         ' + char(10);
								SET @v_dSql += '	FROM	(                                                                                           ' + char(10);
								SET @v_dSql += '				SELECT '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_applied_model +''' AS MODEL_ID  ' + char(10);
								SET @v_dSql += '					 , '''+ @v_production_type +''' AS PRODUCTION_TYPE, '''+ @v_user_id +''' AS USER_ID	' + char(10);
								SET @v_dSql += '			) A                                                                                         ' + char(10);
								SET @v_dSql += '	WHERE NOT EXISTS (                                                                                  ' + char(10);
								SET @v_dSql += '		SELECT 1                                                                                        ' + char(10);
								SET @v_dSql += '		FROM   FP_PLM_PJT_MODEL_MASTER BB                                                               ' + char(10);
								SET @v_dSql += '		WHERE  A.DIVISION_ID = BB.DIVISION_ID                                                           ' + char(10);
								SET @v_dSql += '		AND    A.MODEL_ID    = BB.MODEL_ID                                                              ' + char(10);
								SET @v_dSql += '	)                                                                                                   ' + char(10);
								SET @v_dSql += '	;                                                                                                   ' + char(10);

							END

						END
	
						IF @p_sys_type = 'SQL'
						BEGIN
							select @v_dSql as [QUERY_VALUE]
						END ELSE BEGIN
							SET @runstart = GetDate()
							BEGIN TRY
									BEGIN TRAN
										exec sp_executesql @v_dSql
									COMMIT TRAN
							END TRY
							BEGIN CATCH
									ROLLBACK
							END CATCH
							SET @runend = GetDate()
							exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
						END

					END --WHILE 내(END)
			END
 		
		-- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @p_sys_type <> 'SQL'
			SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

	END TRY

	BEGIN CATCH                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                     
		ROLLBACK TRAN                                                                                                                                                                                                                                                 
		-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
		SET @v_log_message = ERROR_MESSAGE()
		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
	END CATCH   
END

