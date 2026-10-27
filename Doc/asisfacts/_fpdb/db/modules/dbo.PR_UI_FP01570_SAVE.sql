

/*
 * Program ID   : PR_UI_FP01570_SAVE
 * Description  : Plan ID History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/23   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01570_SAVE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_instance_id		NVARCHAR(MAX),
  @p_plan_id			NVARCHAR(MAX),
  @p_plan_type			NVARCHAR(MAX),
  @p_description		NVARCHAR(MAX),
  @p_relDescription		NVARCHAR(MAX)
  
AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP01570_SAVE';
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
	
	DECLARE @v_instance_id          NVARCHAR(MAX);
	DECLARE @v_plan_id		        NVARCHAR(MAX);
	DECLARE @v_plan_type	        NVARCHAR(MAX);
	DECLARE @v_description			NVARCHAR(MAX);  
	DECLARE @v_relDescription		NVARCHAR(MAX);  
	

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
							
							SET @v_instance_id          = [dbo].[SCM_ARR_SPL_VAL]( @p_instance_id           ,@v_delimiter, @mst_loop_cnt);
							SET @v_plan_id				= [dbo].[SCM_ARR_SPL_VAL]( @p_plan_id				,@v_delimiter, @mst_loop_cnt);  
							SET @v_plan_type			= [dbo].[SCM_ARR_SPL_VAL]( @p_plan_type				,@v_delimiter, @mst_loop_cnt);
							SET @v_description			= [dbo].[SCM_ARR_SPL_VAL]( @p_description			,@v_delimiter, @mst_loop_cnt);
							SET @v_relDescription		= [dbo].[SCM_ARR_SPL_VAL]( @p_relDescription		,@v_delimiter, @mst_loop_cnt);
							
						END

						BEGIN
					
							IF (@v_sys_flag = 'U')
							BEGIN
								
								SET @v_dSql = '';
								SET @v_dSql += '	UPDATE	SCM_FP_PLAN_H													' + char(10)
								SET @v_dSql += '	SET		 DESCRIPTION		= N'''+ @v_description +'''					' + char(10)
								SET @v_dSql += '			,REL_DESC		    = N'''+ @v_relDescription +'''						' + char(10)
								SET @v_dSql += '			,DESC_UPDATE_ID		= '''+ @v_user_id +'''						' + char(10)
								SET @v_dSql += '			,DESC_UPDATE_TIME	= dbo.SYSDATE1()							' + char(10)
								SET @v_dSql += '	WHERE	INSTANCE_ID			= RTRIM(LTRIM('''+ @v_instance_id +'''))	' + char(10)
								SET @v_dSql += '	AND		PLAN_ID            	= RTRIM(LTRIM('''+ @v_plan_id +'''))		' + char(10)
								SET @v_dSql += '	AND		PLAN_TYPE			= RTRIM(LTRIM('''+ @v_plan_type +'''))		' + char(10)
								SET @v_dSql += '	;		' + char(10)

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

