CREATE PROCEDURE [dbo].[PR_UI_FP01624_FIND_FP01624_REVISIONINFO]
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
/** 프로그램 ID   : PR_UI_FP01624_FIND_FP01624_REVISIONINFO                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP01624_FIND_FP01624_REVISIONINFO                                                                          **/
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
/** 2021-07-21     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01624_FIND_FP01624_REVISIONINFO
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01624_FIND_FP01624_REVISIONINFO'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_plan_revision nvarchar(max) = ''
  DECLARE @p_mpp_wpp_plan_type nvarchar(max) = ''
  DECLARE @p_plan_revision2 nvarchar(max) = ''
  DECLARE @p_plan_week nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_plan_revision nvarchar(max)
  DECLARE @v_mpp_wpp_plan_type nvarchar(max)
  DECLARE @v_plan_revision2 nvarchar(max)
  DECLARE @v_plan_week nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

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
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_REVISION' BEGIN
      SET @p_plan_revision =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MPP_WPP_PLAN_TYPE' BEGIN
      SET @p_mpp_wpp_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_REVISION2' BEGIN
      SET @p_plan_revision2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_WEEK' BEGIN
      SET @p_plan_week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_plan_revision ='''' + @p_plan_revision + ''''
  SET @v_mpp_wpp_plan_type ='''' + @p_mpp_wpp_plan_type + ''''
  SET @v_plan_revision2
 ='''' + @p_plan_revision2
 + ''''
  SET @v_plan_week ='''' + @p_plan_week + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''



  -- FP01624 find_FP01624_revisionInfo  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.PLAN_WEEK, A.PLAN_REVISION'+char(10)
  SET @v_dSql += '           , ISNULL(A.WPP,''N'') AS WPP'+char(10)
  SET @v_dSql += '           , ISNULL(A.MPP,''N'') AS MPP'+char(10)
  SET @v_dSql += '           , ISNULL(A.MRP,''N'') AS MRP'+char(10)
  SET @v_dSql += '           , ISNULL(A.WO,''N'') AS WO'+char(10)
  SET @v_dSql += '           , A.PLAN_DESCRIPTION, A.FACTORY_ID'+char(10)
  SET @v_dSql += '           , A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME, 20) AS INSERT_TIME'+char(10)
  SET @v_dSql += '      FROM   FP_MPP_WPP_BASE_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE  1=1'+char(10)

  SET @v_dSql += 'AND    A.' + @p_MPP_WPP_PLAN_TYPE + '=''Y'''+char(10)
  IF ISNULL(@p_MPP_WPP_PLAN_TYPE,'') = 'MPP' BEGIN
	  SET @v_dSql += 'AND    EXISTS '+char(10)
	  SET @v_dSql += '( '+char(10)
	  SET @v_dSql += '  SELECT 1 '+char(10)
	  SET @v_dSql += '  FROM ( '+char(10)
	  SET @v_dSql += @p_PLAN_REVISION2
	  SET @v_dSql += '  ) BB '+char(10)
	  --SET @v_dSql += '  WHERE A.PLAN_WEEK = BB.PLAN_WEEK '+char(10)
	  --SET @v_dSql += '  AND   A.PLAN_REVISION = BB.PLAN_REVISION '+char(10)
	  SET @v_dSql += '  WHERE A.PLAN_WEEK     = BB._WEEK '+char(10)
	  SET @v_dSql += '  AND   A.PLAN_REVISION = BB._REV '+char(10)
	  SET @v_dSql += ') '+char(10)
  END ELSE BEGIN
    IF ISNULL(@p_PLAN_REVISION,'') <> '' BEGIN
	  SET @v_dSql += 'AND    A.PLAN_WEEK   = ''' + @p_PLAN_WEEK + ''' '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_REVISION' , 'EQ', @p_PLAN_REVISION)) + char(10)	
	--SET @v_dSql += 'AND    A.PLAN_REVISION IN (' +@p_PLAN_REVISION +') '+char(10)
	END
    --          if(sRev!="" && sRev!=null) {
  --            sql+="AND    A.PLAN_WEEK   = ''''" + $data.PLAN_WEEK + "'''' \r\n";
  --            sql+="AND    A.PLAN_REVISION IN (" + sRev + ") \r\n";
  --          }
  END
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sRev  = $data.PLAN_REVISION;
  --        var sType = $data.MPP_WPP_PLAN_TYPE;
  --
  --        sql+="AND    A." + sType + "=''''Y''''\r\n";
  --
  --        if(sType == "MPP") {
  --          sql+="AND    EXISTS \r\n";
  --          sql+="( \r\n";
  --          sql+="  SELECT 1 \r\n";
  --          sql+="  FROM ( \r\n";
  --          sql+=     $data.PLAN_REVISION2
  --          sql+="  ) BB \r\n";
  --          sql+="  WHERE A.PLAN_WEEK = BB.PLAN_WEEK \r\n";
  --          sql+="  AND   A.PLAN_REVISION = BB.PLAN_REVISION \r\n";
  --          sql+=") \r\n";
  --
  --        } else {
  --          if(sRev!="" && sRev!=null) {
  --            sql+="AND    A.PLAN_WEEK   = ''''" + $data.PLAN_WEEK + "'''' \r\n";
  --            sql+="AND    A.PLAN_REVISION IN (" + sRev + ") \r\n";
  --          }
  --        }
  --
  --        sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --    		var param = $data.param;
  --    		$data.querySet1 = $jdbc.queryList("FP01624","find_FP01624_revisionInfo",param);
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
      exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
