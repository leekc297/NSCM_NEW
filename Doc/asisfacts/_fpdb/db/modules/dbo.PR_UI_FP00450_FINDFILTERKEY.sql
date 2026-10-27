CREATE PROCEDURE [dbo].[PR_UI_FP00450_FINDFILTERKEY]
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
/** 프로그램 ID   : PR_UI_FP00450_FINDFILTERKEY                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00450_FINDFILTERKEY                                                                          **/
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
/** 2021-06-01     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00450_FINDFILTERKEY
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00450_FINDFILTERKEY'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_setup_category_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_setup_category_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2setup_category_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4operation_id nvarchar(max)
  DECLARE @opt_5setup_category_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SETUP_CATEGORY_ID' BEGIN
      SET @p_setup_category_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_setup_category_id ='''' + @p_setup_category_id + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_setup_category_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2setup_category_id = ''
  END ELSE BEGIN
    SET @opt_2setup_category_id = 'AND    A.SETUP_CATEGORY_ID = ' + @v_setup_category_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4operation_id = ''
  END ELSE BEGIN
    SET @opt_4operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_setup_category_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5setup_category_id = ''
  END ELSE BEGIN
    SET @opt_5setup_category_id = 'AND    A.SETUP_CATEGORY_ID = ' + @v_setup_category_id+''
  END


  -- FP00450 findFilterKey  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT DISTINCT A.SETUP_KEY_ID AS CODE, A.SETUP_KEY_ID AS NAME'+char(10)
  SET @v_dSql += '      FROM   SCM_ITEM_SETUP_GROUP_M A(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE  1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID = #SITE_ID#
  SET @v_dSql += ' ' +@opt_1operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
  SET @v_dSql += ' ' +@opt_2setup_category_id +' '+''+char(10)--AND    A.SETUP_CATEGORY_ID = #SETUP_CATEGORY_ID#
  SET @v_dSql += '      ORDER BY SETUP_KEY_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00450","findFilterKey",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00450_FINDFILTERKEY',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00450_FINDFILTERKEY',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
