CREATE PROCEDURE [dbo].[PR_UI_FP00591_ETC]
	@p_sys_type			NVARCHAR(MAX),  
	@p_sys_flag			NVARCHAR(MAX),
	@p_sys_gubun		NVARCHAR(MAX),  
	@p_user_id			NVARCHAR(MAX),
	@in_columns			NVARCHAR(MAX),
	@in_row				NVARCHAR(MAX),
	@opt_none			NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00591_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00591_ETC                                               **/
/** 설 명         :                                                                           **/
/** Version       :				                                                              **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2024/11/2   CYS				Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00591_ETC';
	DECLARE @runstart		DATETIME;
	DECLARE @runend			DATETIME;
	DECLARE @v_dSql			NVARCHAR(MAX) ='';
	DECLARE @STRLEN			NVARCHAR(MAX);
	DECLARE @v_Err			NVARCHAR(MAX);
	DECLARE @v_Log			NVARCHAR(MAX); 

	DECLARE @v_delimiter    NVARCHAR(1);
	DECLARE @max_loop_cnt	INTEGER = 0;
	DECLARE @mst_loop_cnt	INTEGER = 0;

	DECLARE @p__save_auth	NVARCHAR(MAX);
	DECLARE @p__non_auth	NVARCHAR(MAX);

	-- filter
	DECLARE @p_plan_date	NVARCHAR(MAX);
	DECLARE @p_total_instance_id	NVARCHAR(MAX);

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);

	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @v_delimiter , @mst_loop_cnt);
		SET @tmp_value	= [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		IF @tmp_column = '_SAVE_AUTH' BEGIN
			SET @p__save_auth =			@tmp_value ;
		END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
			SET @p__non_auth =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'TOTAL_INSTANCE_ID' BEGIN
			SET @p_total_instance_id =		@tmp_value ;
		
		END

	END
	/*	Parameter Setting End */

	SET	@v_dSql = '';

	IF @p_sys_flag = 'FIX_DATE'
	BEGIN

		SELECT @v_dSql += N'SELECT CONVERT(VARCHAR, CONVERT(DATETIME, ''' + @p_plan_date + ''') + MAX(CONVERT(NUMERIC,ISNULL(A.ATTRIBUTE15,''8'')))* 7, 112) AS DEFAULT_DATE ' + char(10)
		SELECT @v_dSql += N'     , CONVERT(VARCHAR, CONVERT(DATETIME, ''' + @p_plan_date + ''') + MAX(CONVERT(NUMERIC,ISNULL(A.ATTRIBUTE15,''8'')))* 7, 112) AS LIMIT_DATE ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
		SELECT @v_dSql += N'AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'AND    A.SEGMENT1 IN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT SEGMENT2 AS INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.LOOKUP_TYPE_CODE = ''TOTAL_INSTANCE_INFO'' ' + char(10)
		SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'	AND    A.SEGMENT1 = ''' + @p_total_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N') ' + char(10)

	END
	

	IF @p_sys_type = 'SQL'
    BEGIN
			
			DECLARE @log_id INTEGER = 0
			EXEC	@log_id = PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'sql',@runstart, @runend

			SELECT	QUERY_VALUE 
			FROM	TH_UIS_SQL_LOG WITH(NOLOCK)  
			WHERE	PROG_ID = @v_proc_name AND JOB_TYPE = @p_sys_type AND INST_SEQ = @log_id
			ORDER BY QUERY_SEQ ASC

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
	
  
END
