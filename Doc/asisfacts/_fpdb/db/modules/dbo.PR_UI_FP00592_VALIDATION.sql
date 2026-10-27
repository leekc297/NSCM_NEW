
CREATE PROCEDURE [dbo].[PR_UI_FP00592_VALIDATION]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : [PR_UI_FP00592_VALIDATION]                                                            **/
/** 프로그램 명   : Procedure [PR_UI_FP00592_VALIDATION]                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.0                                                                  **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2025-04-01     chkim.68      Initial Setup Validation                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599_FIND_TOTALVALUE
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  --DECLARE BASE PARAMETER START
  DECLARE @STRLEN nvarchar(max)
  DECLARE @runstart datetime
  DECLARE @runend datetime
  DECLARE @v_dSql nvarchar(max)
  DECLARE @v_Err nvarchar(max)
  DECLARE @v_Log nvarchar(max) 
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00592_VALIDATION'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  --DECLARE @p_master_id nvarchar(max) = ''
  --DECLARE @p_plan_id nvarchar(max) = ''
  --DECLARE @p_plan_date nvarchar(max) = ''
  --DECLARE @p_plan_type nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_setup_code nvarchar(max) = ''
  --DECLARE @p_operation_id nvarchar(max) = ''
  --DECLARE @p_top_item_id nvarchar(max) = ''
  --DECLARE @p_item_id nvarchar(max) = ''
  --DECLARE @p_past_plan_type nvarchar(max) = ''
  --DECLARE @p_bucket_from nvarchar(max) = ''
  --DECLARE @p_bucket_to nvarchar(max) = ''
  --DECLARE @p_item_name nvarchar(max) = ''
  --DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  --DECLARE @p_operation_lt nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SETUP_CODE' BEGIN
      SET @p_setup_code =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END 
  
  if @p_setup_code = N'Tact Time / Daily Capa' begin

	  SET @v_dSql = N''
	  SET @v_dSql += N'      SELECT ''PLANT'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  SET @v_dSql += N' UNION      SELECT ''B'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  SET @v_dSql += N' UNION     SELECT ''C'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  SET @v_dSql += N' UNION     SELECT ''D'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  SET @v_dSql += N' UNION     SELECT ''' + @p_setup_code + ''' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id) + char(10)
	  --SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id) + char(10)
  end else if @p_setup_code = 'Equipment' begin
	  
	  SET @v_dSql = N''
	  --SET @v_dSql += N'      SELECT ''ITEM'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += N' UNION      SELECT ''B'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += N' UNION     SELECT ''C'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += N' UNION     SELECT ''D'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += N' UNION     SELECT ''' + @p_setup_code + ''' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  -- 개발 임시데이터 조회
	  SET @v_dSql += N'SELECT TOP_ITEM_ID as ''Demand Material'' ' + char(10)
	  SET @v_dSql += N'     , C.NICK_NAME as ''Nick Name'' ' + char(10)
	  SET @v_dSql += N'     , PROBLEM_DATA as ''Problem Material'' ' + char(10)
	  SET @v_dSql += N'     , PROBLEM_TYPE as ''Problem Group'' ' + char(10)
	  SET @v_dSql += N'     , CHECK_UI as ''Problem Type'' ' + char(10)
	  SET @v_dSql += N'     , PROBLEM_DESCRIPTION as ''Problem Description'' ' + char(10)
	  SET @v_dSql += N'FROM   FP_MASTER_VALIDATION_H A WITH(NOLOCK) ' + char(10)
	  SET @v_dSql += N'LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
	  SET @v_dSql += N'ON  A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
	  SET @v_dSql += N'AND A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
	  SET @v_dSql += N'AND A.SITE_ID      = B.SITE_ID ' + char(10)
	  SET @v_dSql += N'AND A.PROBLEM_DATA = B.ITEM_ID ' + char(10)
	  SET @v_dSql += N'LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
	  SET @v_dSql += N'ON  A.COMPANY_ID   = C.COMPANY_ID ' + char(10)
	  SET @v_dSql += N'AND A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
	  SET @v_dSql += N'AND A.SITE_ID      = C.SITE_ID ' + char(10)
	  SET @v_dSql += N'AND A.TOP_ITEM_ID  = C.ITEM_ID ' + char(10)
	  SET @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
	  SET @v_dSql += N'    SELECT A.SEGMENT1 AS INSTANCE_ID,A.SEGMENT2 AS INSTANCE_NAME ' + char(10)
	  SET @v_dSql += N'    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
	  SET @v_dSql += N'    WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
	  SET @v_dSql += N'    AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
	  SET @v_dSql += N') D ' + char(10)
	  SET @v_dSql += N'ON  A.INSTANCE_ID = D.INSTANCE_ID ' + char(10)
	  SET @v_dSql += N'WHERE 1=1 ' + char(10)
	  SET @v_dSql += N'AND   A.INSTANCE_ID = ''KR_E_PRE_M'' ' + char(10)
	  SET @v_dSql += N'AND   A.PLAN_DATE   = CONVERT(DATETIME, ''20250414'') ' + char(10)
	  SET @v_dSql += N'ORDER BY A.INSTANCE_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.PROBLEM_TYPE, A.CHECK_UI, A.PROBLEM_DATA ' + char(10)

	  --SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id) + char(10)
	  --SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id) + char(10)
  END
  ELSE BEGIN
 
      SET @v_dSql = N''
	  --SET @v_dSql += N'      SELECT '''' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += N' UNION      SELECT ''B'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += N' UNION     SELECT ''C'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  --SET @v_dSql += N' UNION     SELECT ''D'' AS [한글컬럼] ,''google'' AS [구루구루] ' + char(10)
	  SET @v_dSql += N'      SELECT ''-' + @p_setup_code + N'-'' AS [한글컬럼2222] ,''google'' AS [구루구루2222] ' + char(10)
	  --SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id) + char(10)
	  --SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id) + char(10)

  END


  IF @p_sys_type = 'SQL'
  BEGIN
    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
  END ELSE BEGIN
    SET @runstart = GetDate()

    BEGIN TRY
      BEGIN TRAN
        -- run dynamic sql
        exec sp_executesql @v_dSql
      COMMIT TRAN
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @runend = GetDate()
      exec PR_UI_SQL_LOG 'PR_UI_FP00592_VALIDATION',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00592_VALIDATION',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
