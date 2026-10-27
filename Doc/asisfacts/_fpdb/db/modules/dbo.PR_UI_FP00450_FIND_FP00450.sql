CREATE PROCEDURE [dbo].[PR_UI_FP00450_FIND_FP00450]
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
/** 프로그램 ID   : PR_UI_FP00450_FIND_FP00450                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00450_FIND_FP00450                                                                          **/
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
  EXEC PR_UI_FP00450_FIND_FP00450
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00450_FIND_FP00450'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_group_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_setup_category_id nvarchar(max) = ''
  DECLARE @p_setup_key_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_group_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_setup_category_id nvarchar(max)
  DECLARE @v_setup_key_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_group_id nvarchar(max)
  DECLARE @opt_2operation_id nvarchar(max)
  DECLARE @opt_3setup_category_id nvarchar(max)
  DECLARE @opt_4setup_key_id nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6operation_group_id nvarchar(max)
  DECLARE @opt_7operation_id nvarchar(max)
  DECLARE @opt_8setup_category_id nvarchar(max)
  DECLARE @opt_9setup_key_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'OPERATION_GROUP_ID' BEGIN
      SET @p_operation_group_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SETUP_CATEGORY_ID' BEGIN
      SET @p_setup_category_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SETUP_KEY_ID' BEGIN
      SET @p_setup_key_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_group_id ='''' + @p_operation_group_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_setup_category_id ='''' + @p_setup_category_id + ''''
  SET @v_setup_key_id ='''' + @p_setup_key_id + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'and    a.site_id = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_group_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_group_id = ''
  END ELSE BEGIN
    SET @opt_1operation_group_id = 'AND    B.OPERATION_GROUP_ID = ' + @v_operation_group_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2operation_id = ''
  END ELSE BEGIN
    SET @opt_2operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_setup_category_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3setup_category_id = ''
  END ELSE BEGIN
    SET @opt_3setup_category_id = 'AND    A.SETUP_CATEGORY_ID = ' + @v_setup_category_id+''
  END
  SET @STRLEN = LEN(@p_setup_key_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4setup_key_id = ''
  END ELSE BEGIN
    SET @opt_4setup_key_id = 'AND    A.SETUP_KEY_ID = ' + @v_setup_key_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'and    a.site_id = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_group_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6operation_group_id = ''
  END ELSE BEGIN
    SET @opt_6operation_group_id = 'AND    B.OPERATION_GROUP_ID = ' + @v_operation_group_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7operation_id = ''
  END ELSE BEGIN
    SET @opt_7operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_setup_category_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8setup_category_id = ''
  END ELSE BEGIN
    SET @opt_8setup_category_id = 'AND    A.SETUP_CATEGORY_ID = ' + @v_setup_category_id+''
  END
  SET @STRLEN = LEN(@p_setup_key_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9setup_key_id = ''
  END ELSE BEGIN
    SET @opt_9setup_key_id = 'AND    A.SETUP_KEY_ID = ' + @v_setup_key_id+''
  END


  -- FP00450 find_FP00450  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.COMPANY_ID, A.DIVISION_ID ,A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '            ,A.OPERATION_ID, B.OPERATION_GROUP_ID'+char(10)
  SET @v_dSql += '            ,A.LINE_SETUP_GROUP_ID'+char(10)
  SET @v_dSql += '            ,A.SETUP_CATEGORY_ID'+char(10)
  SET @v_dSql += '            ,A.SETUP_KEY_ID'+char(10)
  SET @v_dSql += '            ,A.SETUP_CONDITION_ID'+char(10)
  SET @v_dSql += '            ,A.SETUP_TIME, A.SETUP_TIME_UOM'+char(10)
  SET @v_dSql += '            ,A.DESCRIPTION'+char(10)
  SET @v_dSql += '            ,(CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN'+char(10)
  SET @v_dSql += '      FROM  SCM_SETUP_CONDITION_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '  		INNER HASH JOIN SCM_OPERATION_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON    A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND   A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND   A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND   A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '           SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.OPERATION_ID'+char(10)
  SET @v_dSql += '           FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '           WHERE  R.USER_ID   ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '           AND    R.SAVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '      ) R'+char(10)
  SET @v_dSql += '      ON   A.COMPANY_ID   = R.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND  A.DIVISION_ID  = R.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND  A.SITE_ID      = R.SITE_ID'+char(10)
  SET @v_dSql += '      AND  A.PLANT_ID     = R.PLANT_ID'+char(10)
  SET @v_dSql += '      AND  A.OPERATION_ID = R.OPERATION_ID'+char(10)
  SET @v_dSql += '      WHERE EXISTS ('+char(10)
  SET @v_dSql += '            SELECT 1'+char(10)
  SET @v_dSql += '            FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '            AND    A.PLANT_ID     = B.PLANT_ID'+char(10)
  SET @v_dSql += '            AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '            AND    B.USER_ID      ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '      )'+char(10)
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
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--and    a.site_id = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --      		sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += ' ' +@opt_1operation_group_id +' '+''+char(10)--AND    B.OPERATION_GROUP_ID = #OPERATION_GROUP_ID#
  SET @v_dSql += ' ' +@opt_2operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
  SET @v_dSql += ' ' +@opt_3setup_category_id +' '+''+char(10)--AND    A.SETUP_CATEGORY_ID = #SETUP_CATEGORY_ID#
  SET @v_dSql += ' ' +@opt_4setup_key_id +' '+''+char(10)--AND    A.SETUP_KEY_ID = #SETUP_KEY_ID#
  SET @v_dSql += '      ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID'+char(10)
  SET @v_dSql += '              ,A.LINE_SETUP_GROUP_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00450","find_FP00450",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00450_FIND_FP00450',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00450_FIND_FP00450',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
