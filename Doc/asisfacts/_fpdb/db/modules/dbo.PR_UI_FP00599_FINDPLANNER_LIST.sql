CREATE PROCEDURE [dbo].[PR_UI_FP00599_FINDPLANNER_LIST]
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
/** 프로그램 ID   : PR_UI_FP00599_FINDPLANNER_LIST                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00599_FINDPLANNER_LIST                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                                     **/
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
/** 2021-03-09     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599_FINDPLANNER_LIST
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00599_FINDPLANNER_LIST'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
    DECLARE @p__save_auth nvarchar(max) = ''
  DECLARE @p__non_auth nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  --DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  	SET @v_dSql = ''
  if @p_instance_id ='PL_PACK' OR @p_instance_id = 'PL_CELL' BEGIN
  	--"findPlanner_List_exception"
	  SET @v_dSql +='	SELECT A.ATTRIBUTE6 AS CODE, ISNULL(B.USER_NAME,''-'') + '' ('' + A.ATTRIBUTE6 + '')'' AS NAME'+char(10)
	  SET @v_dSql +='      	, (CASE WHEN A.ATTRIBUTE6 = '+@v_user_id+' THEN ''Y'' ELSE ''N'' END) AS DEFAULT_CHECK'+char(10)
	  SET @v_dSql +='      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
	  SET @v_dSql +='      LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)'+char(10)
	  SET @v_dSql +='      ON     A.ATTRIBUTE6 = B.USER_ID'+char(10)
	  SET @v_dSql +='      WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
	  SET @v_dSql +='      AND    A.SEGMENT1         = '+@v_instance_id++char(10)
	  SET @v_dSql +='      AND    A.ACTIVE_FLAG      = ''Y'''+char(10)
	  SET @v_dSql +='      ORDER BY A.SORT_ORDER'+char(10)
  END
  ELSE BEGIN

	  SET @v_dSql +='      SELECT DISTINCT A.USER_ID AS CODE, ISNULL(B.USER_NAME,''-'') + '' ('' +A.USER_ID + '')'' AS NAME'+ char(10)
	  SET @v_dSql +='           , (CASE WHEN A.USER_ID = ' + @v_user_id + ' THEN ''Y'' ELSE ''N'' END) AS DEFAULT_CHECK'+ char(10)
	  SET @v_dSql +='      FROM   FP_USER_LINE_GROUP_M A WITH(NOLOCK)'+ char(10)
	  SET @v_dSql +='      LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)'+ char(10)
	  SET @v_dSql +='      ON     A.USER_ID = B.USER_ID'+ char(10)
	  SET @v_dSql +='      WHERE  A.INSTANCE_ID = ' + @v_instance_id +  char(10)
	  SET @v_dSql +='      ORDER BY NAME'+ char(10)
  END


  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --
  --        // PL_PACK 예외처리... 20200128, PL_CELL 예외처리... 20201113
  --        if(param.INSTANCE_ID == "PL_PACK" || param.INSTANCE_ID == "PL_CELL" ) {
  --          $data.querySet1 = $jdbc.queryList("FP00599","findPlanner_List_exception",param);
  --        }
  --        else {
  --          $data.querySet1 = $jdbc.queryList("FP00599","findPlanner_List",param);
  --        }
  --
  --}

  --'


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
      exec PR_UI_SQL_LOG 'PR_UI_FP00599_FINDPLANNER_LIST',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00599_FINDPLANNER_LIST',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
