CREATE PROCEDURE [dbo].[PR_UI_FP00599_FIND_WEEKCNT]
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
/** 프로그램 ID   : PR_UI_FP00599_FIND_WEEKCNT                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00599_FIND_WEEKCNT                                                                          **/
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
/** 2021-03-15     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599_FIND_WEEKCNT
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00599_FIND_WEEKCNT'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p_queryset2 nvarchar(max) = ''
  DECLARE @p_queryset3 nvarchar(max) = ''
  DECLARE @p_queryset4 nvarchar(max) = ''


  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)
  DECLARE @v_queryset2 nvarchar(max)
  DECLARE @v_queryset3 nvarchar(max)
  DECLARE @v_queryset4 nvarchar(max)

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
	--IF @tmp_column = '_SAVE_AUTH' BEGIN
	--	SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE 
	IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET2' BEGIN
      SET @p_queryset2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET3' BEGIN
      SET @p_queryset3 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET4' BEGIN
      SET @p_queryset4 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	--END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
	--	SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''
  SET @v_queryset2 ='''' + @p_queryset2 + ''''
  SET @v_queryset3 ='''' + @p_queryset3 + ''''
  SET @v_queryset4 ='''' + @p_queryset4 + ''''



  -- FP00599 find_WeekCnt  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT ISO_YYYYWW AS WEEK'+char(10)
  SET @v_dSql += '           , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS WEEK_NAME'+char(10)
  SET @v_dSql += '           , COUNT(*) AS WEEK_COUNT'+char(10)
  SET @v_dSql += '           , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS W_VALUE'+char(10)
  SET @v_dSql += '           , ''1'' AS IS_DAY_VIEW'+char(10)
  SET @v_dSql += '      FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE  CAL.DT >= CONVERT(DATETIME,'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ', 112)'+char(10)
  SET @v_dSql += '      AND    CAL.DT <= CONVERT(DATETIME,'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += ', 112)'+char(10)
  SET @v_dSql += '      GROUP BY ISO_YYYYWW'+char(10)
  SET @v_dSql += '      ORDER BY ISO_YYYYWW'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00599","find_WeekCnt",param);
  --        $data.querySet2 = $jdbc.queryList("FP00599","find_DateMap",param);
  --        $data.querySet3 = $jdbc.queryList("FP00599","find_MonthCnt",param);
  --        $data.querySet4 = $jdbc.queryList("FP00599","find_bukInfo",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00599_FIND_WEEKCNT',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00599_FIND_WEEKCNT',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
