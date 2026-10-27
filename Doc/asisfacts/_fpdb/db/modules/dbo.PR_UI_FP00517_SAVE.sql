

/*
 * Program ID   : PR_UI_FP00517_SAVE
 * Description  : DOMESTIC MODEL MASTER
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/05   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00517_SAVE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_company_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_production_type	NVARCHAR(MAX),
  @p_market				NVARCHAR(MAX),
  @p_active_flag		NVARCHAR(MAX)
  
AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00517_SAVE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	DECLARE @v_log_message	NVARCHAR(MAX) = '';
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	        INTEGER = 0;
	DECLARE @recv_active_flag       NVARCHAR(MAX);		

	DECLARE @v_sys_type			    NVARCHAR(MAX);  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag			    NVARCHAR(MAX);  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun			NVARCHAR(MAX); 
	DECLARE @v_user_id			    NVARCHAR(MAX);
	DECLARE @v_company_id           NVARCHAR(MAX);
	DECLARE @v_division_id          NVARCHAR(MAX);
	DECLARE @v_site_id              NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);  
	DECLARE @v_production_type		NVARCHAR(MAX);
	DECLARE @v_market				NVARCHAR(MAX);
	DECLARE @v_active_flag          NVARCHAR(MAX);
	DECLARE @v_delimiter            NVARCHAR(1);

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
							SET @v_company_id           = [dbo].[SCM_ARR_SPL_VAL]( @p_company_id            ,@v_delimiter, @mst_loop_cnt);
							SET @v_division_id          = [dbo].[SCM_ARR_SPL_VAL]( @p_division_id           ,@v_delimiter, @mst_loop_cnt);
							SET @v_site_id              = [dbo].[SCM_ARR_SPL_VAL]( @p_site_id               ,@v_delimiter, @mst_loop_cnt);
							SET @v_item_id				= [dbo].[SCM_ARR_SPL_VAL]( @p_item_id				,@v_delimiter, @mst_loop_cnt);  
							SET @v_production_type      = [dbo].[SCM_ARR_SPL_VAL]( @p_production_type       ,@v_delimiter, @mst_loop_cnt);
							SET @v_market				= [dbo].[SCM_ARR_SPL_VAL]( @p_market				,@v_delimiter, @mst_loop_cnt);
							SET @v_active_flag          = [dbo].[SCM_ARR_SPL_VAL]( @p_active_flag			,@v_delimiter, @mst_loop_cnt);
						
						END

						BEGIN
					
							IF (@v_sys_flag IN ('I','M'))
							BEGIN
							
								SET @v_dSql = ''
								SET @v_dSql += '	MERGE INTO SCM_MODEL_MARKET_M A																							' + char(10);
								SET @v_dSql += '	USING (	SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID, '''+ @v_item_id +''' AS ITEM_ID     ' + char(10);
								SET @v_dSql += '			      , ''D'' AS DEFAULT_MARKET, ''Y'' AS ACTIVE_FLAG, A.PRODUCTION_TYPE                                        ' + char(10);
								SET @v_dSql += '			FROM (                                                                                                          ' + char(10);
								SET @v_dSql += '			      SELECT  DISTINCT A.SEGMENT2 AS PRODUCTION_TYPE                                                            ' + char(10);
								SET @v_dSql += '			      FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                               ' + char(10);
								SET @v_dSql += '			      WHERE   A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''                                                     ' + char(10);
								SET @v_dSql += '			      AND     A.ACTIVE_FLAG = ''Y''                                                                             ' + char(10);
								SET @v_dSql += '			      AND     A.ATTRIBUTE3 = ''Y''                                                                              ' + char(10);
								SET @v_dSql += '			      AND     A.SEGMENT1 = '''+ @v_division_id +'''                                                             ' + char(10);
								SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT2' , 'EQ', @v_production_type)) + char(10);
								SET @v_dSql += '			) A                                                                                                             ' + char(10);
								SET @v_dSql += '	   	) B                                                                                                                 ' + char(10);
								SET @v_dSql += '	ON (      A.COMPANY_ID 	= B.COMPANY_ID                                                                                  ' + char(10);
								SET @v_dSql += '		AND A.DIVISION_ID 	= B.DIVISION_ID                                                                                 ' + char(10);
								SET @v_dSql += '	  	AND A.SITE_ID 		= B.SITE_ID                                                                                     ' + char(10);
								SET @v_dSql += '	  	AND A.ITEM_ID 		= B.ITEM_ID                                                                                     ' + char(10);
								SET @v_dSql += '	  	AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE )                                                                         ' + char(10);
								SET @v_dSql += '	WHEN NOT MATCHED THEN                                                                                                   ' + char(10);
								SET @v_dSql += '	INSERT (                                                                                                                ' + char(10);
								SET @v_dSql += '	          COMPANY_ID                                                                                                    ' + char(10);
								SET @v_dSql += '	        , DIVISION_ID                                                                                                   ' + char(10);
								SET @v_dSql += '	        , SITE_ID                                                                                                       ' + char(10);
								SET @v_dSql += '	        , ITEM_ID                                                                                                       ' + char(10);
								SET @v_dSql += '	        , DEFAULT_MARKET                                                                                                ' + char(10);
								SET @v_dSql += '	        , ACTIVE_FLAG                                                                                                   ' + char(10);
								SET @v_dSql += '	        , PRODUCTION_TYPE                                                                                               ' + char(10);
								SET @v_dSql += '	        , INSERT_ID, UPDATE_ID                                                                                          ' + char(10);
								SET @v_dSql += '	        , UPDATE_TIME, INSERT_TIME                                                                                      ' + char(10);
								SET @v_dSql += '	  )                                                                                                                     ' + char(10);
								SET @v_dSql += '	  VALUES (                                                                                                              ' + char(10);
								SET @v_dSql += '	      '''+ @v_company_id +'''                                                                                                      ' + char(10);
								SET @v_dSql += '	    , '''+ @v_division_id +'''                                                                                                     ' + char(10);
								SET @v_dSql += '	    , '''+ @v_site_id +'''                                                                                                         ' + char(10);
								SET @v_dSql += '	    , '''+ @v_item_id +'''                                                                                                         ' + char(10);
								SET @v_dSql += '	    , ''D''                                                                                                             ' + char(10);
								SET @v_dSql += '	    , ''Y''                                                                                                             ' + char(10);
								SET @v_dSql += '	    , B.PRODUCTION_TYPE                                                                                                 ' + char(10);
								SET @v_dSql += '	    , '''+ @v_user_id +''', '''+ @v_user_id +'''                                                                                              ' + char(10);
								SET @v_dSql += '	    , dbo.SYSDATE1() , dbo.SYSDATE1()                                                                                   ' + char(10);
								SET @v_dSql += '	  )                                                                                                                     ' + char(10);
								SET @v_dSql += '	  ;                                                                                                                     ' + char(10);

								SET @v_dSql += '	INSERT INTO HIS_MODEL_MARKET_M (        					' + char(10);
								SET @v_dSql += '	      	  COMPANY_ID                                        ' + char(10);
								SET @v_dSql += '	        , DIVISION_ID                                       ' + char(10);
								SET @v_dSql += '	        , SITE_ID                                           ' + char(10);
								SET @v_dSql += '	        , ITEM_ID                                           ' + char(10);
								SET @v_dSql += '	        , DEFAULT_MARKET                                    ' + char(10);
								SET @v_dSql += '	        , ACTIVE_FLAG                                       ' + char(10);
								SET @v_dSql += '	        , PRODUCTION_TYPE                                   ' + char(10);
								SET @v_dSql += '	        , INSERT_ID, UPDATE_ID                              ' + char(10);
								SET @v_dSql += '	        , UPDATE_TIME, INSERT_TIME                          ' + char(10);
								SET @v_dSql += '	      	, JOB_USER_ID, JOB_TIME, JOB_TYPE                   ' + char(10);
								SET @v_dSql += '	)                                                           ' + char(10);
								SET @v_dSql += '	SELECT 	  COMPANY_ID                                        ' + char(10);
								SET @v_dSql += '	        , DIVISION_ID                                       ' + char(10);
								SET @v_dSql += '	        , SITE_ID                                           ' + char(10);
								SET @v_dSql += '	        , ITEM_ID                                           ' + char(10);
								SET @v_dSql += '	        , DEFAULT_MARKET                                    ' + char(10);
								SET @v_dSql += '	        , ACTIVE_FLAG                                       ' + char(10);
								SET @v_dSql += '	        , PRODUCTION_TYPE                                   ' + char(10);
								SET @v_dSql += '	        , INSERT_ID, UPDATE_ID                              ' + char(10);
								SET @v_dSql += '	        , UPDATE_TIME, INSERT_TIME                          ' + char(10);
								SET @v_dSql += '	        , '''+ @v_user_id +''', dbo.SYSDATE1(), ''MERGE''	             ' + char(10);
								SET @v_dSql += '	FROM   SCM_MODEL_MARKET_M A(NOLOCK)                         ' + char(10);
								SET @v_dSql += '	WHERE  COMPANY_ID    = RTRIM(LTRIM('''+ @v_company_id +'''))           ' + char(10);
								SET @v_dSql += '	AND    DIVISION_ID   = RTRIM(LTRIM('''+ @v_division_id +'''))          ' + char(10);
								SET @v_dSql += '	AND    SITE_ID       = RTRIM(LTRIM('''+ @v_site_id +'''))              ' + char(10);
								SET @v_dSql += '	AND    ITEM_ID       = RTRIM(LTRIM('''+ @v_item_id +'''))              ' + char(10);
								SET @v_dSql += '	AND    PRODUCTION_TYPE	= RTRIM(LTRIM('''+ @v_production_type +'''))   ' + char(10);
								SET @v_dSql += '	  ;                                                                    ' + char(10);

							END -- @v_sys_type END

							IF (@v_sys_flag = 'U')
							BEGIN

								SET @v_dSql += '	UPDATE SCM_MODEL_MARKET_M SET               	' + char(10);
								SET @v_dSql += '	     ACTIVE_FLAG  = '''+ @v_active_flag +'''    ' + char(10);
								SET @v_dSql += '	   , UPDATE_ID    = '''+ @v_user_id +'''        ' + char(10);
								SET @v_dSql += '	   , UPDATE_TIME  = DBO.SYSDATE1()				' + char(10);
								SET @v_dSql += '	WHERE  COMPANY_ID    = RTRIM(LTRIM('''+ @v_company_id +'''))           ' + char(10);
								SET @v_dSql += '	AND    DIVISION_ID   = RTRIM(LTRIM('''+ @v_division_id +'''))          ' + char(10);
								SET @v_dSql += '	AND    SITE_ID       = RTRIM(LTRIM('''+ @v_site_id +'''))              ' + char(10);
								SET @v_dSql += '	AND    ITEM_ID       = RTRIM(LTRIM('''+ @v_item_id +'''))              ' + char(10);
								SET @v_dSql += '	AND    PRODUCTION_TYPE	= RTRIM(LTRIM('''+ @v_production_type +'''))   ' + char(10);
								SET @v_dSql += '	  ;                                                                    ' + char(10);

								SET @v_dSql += '	INSERT INTO HIS_MODEL_MARKET_M (        					' + char(10);
								SET @v_dSql += '	      	  COMPANY_ID                                        ' + char(10);
								SET @v_dSql += '	        , DIVISION_ID                                       ' + char(10);
								SET @v_dSql += '	        , SITE_ID                                           ' + char(10);
								SET @v_dSql += '	        , ITEM_ID                                           ' + char(10);
								SET @v_dSql += '	        , DEFAULT_MARKET                                    ' + char(10);
								SET @v_dSql += '	        , ACTIVE_FLAG                                       ' + char(10);
								SET @v_dSql += '	        , PRODUCTION_TYPE                                   ' + char(10);
								SET @v_dSql += '	        , INSERT_ID, UPDATE_ID                              ' + char(10);
								SET @v_dSql += '	        , UPDATE_TIME, INSERT_TIME                          ' + char(10);
								SET @v_dSql += '	      	, JOB_USER_ID, JOB_TIME, JOB_TYPE                   ' + char(10);
								SET @v_dSql += '	)                                                           ' + char(10);
								SET @v_dSql += '	SELECT 	  COMPANY_ID                                        ' + char(10);
								SET @v_dSql += '	        , DIVISION_ID                                       ' + char(10);
								SET @v_dSql += '	        , SITE_ID                                           ' + char(10);
								SET @v_dSql += '	        , ITEM_ID                                           ' + char(10);
								SET @v_dSql += '	        , DEFAULT_MARKET                                    ' + char(10);
								SET @v_dSql += '	        , ACTIVE_FLAG                                       ' + char(10);
								SET @v_dSql += '	        , PRODUCTION_TYPE                                   ' + char(10);
								SET @v_dSql += '	        , INSERT_ID, UPDATE_ID                              ' + char(10);
								SET @v_dSql += '	        , UPDATE_TIME, INSERT_TIME                          ' + char(10);
								SET @v_dSql += '	        , '''+ @v_user_id +''', dbo.SYSDATE1(), ''MERGE''	             ' + char(10);
								SET @v_dSql += '	FROM   SCM_MODEL_MARKET_M A(NOLOCK)                         ' + char(10);
								SET @v_dSql += '	WHERE  COMPANY_ID    = RTRIM(LTRIM('''+ @v_company_id +'''))           ' + char(10);
								SET @v_dSql += '	AND    DIVISION_ID   = RTRIM(LTRIM('''+ @v_division_id +'''))          ' + char(10);
								SET @v_dSql += '	AND    SITE_ID       = RTRIM(LTRIM('''+ @v_site_id +'''))              ' + char(10);
								SET @v_dSql += '	AND    ITEM_ID       = RTRIM(LTRIM('''+ @v_item_id +'''))              ' + char(10);
								SET @v_dSql += '	AND    PRODUCTION_TYPE	= RTRIM(LTRIM('''+ @v_production_type +'''))   ' + char(10);
								SET @v_dSql += '	  ;                                                                    ' + char(10);
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

