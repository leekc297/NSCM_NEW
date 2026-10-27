CREATE PROCEDURE [dbo].[PR_UI_FP00461_FIND_FP00461]
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
/** 프로그램 ID   : PR_UI_FP00461_FIND_FP00461                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00461_FIND_FP00461                                                                          **/
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
/** 2021-05-26     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00461_FIND_FP00461
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00461_FIND_FP00461'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p_queryset2 nvarchar(max) = ''
  DECLARE @p_queryset3 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)
  DECLARE @v_queryset2 nvarchar(max)
  DECLARE @v_queryset3 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2line_id nvarchar(max)
  DECLARE @opt_3item_id nvarchar(max)
  DECLARE @opt_4nick_name nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6operation_id nvarchar(max)
  DECLARE @opt_7line_id nvarchar(max)
  DECLARE @opt_8item_id nvarchar(max)
  DECLARE @opt_9nick_name nvarchar(max)

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
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET2' BEGIN
      SET @p_queryset2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET3' BEGIN
      SET @p_queryset3 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_factory_lt ='''' + @p_factory_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''
  SET @v_queryset2 ='''' + @p_queryset2 + ''''
  SET @v_queryset3 ='''' + @p_queryset3 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2line_id = ''
  END ELSE BEGIN
    SET @opt_2line_id = 'AND A.LINE_ID = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_id = ''
  END ELSE BEGIN
    SET @opt_3item_id = 'AND UPPER(A.ITEM_ID) LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_4nick_name = ''
  END ELSE BEGIN
    SET @opt_4nick_name = 'AND   D.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6operation_id = ''
  END ELSE BEGIN
    SET @opt_6operation_id = 'AND A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7line_id = ''
  END ELSE BEGIN
    SET @opt_7line_id = 'AND A.LINE_ID = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8item_id = ''
  END ELSE BEGIN
    SET @opt_8item_id = 'AND UPPER(A.ITEM_ID) LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_9nick_name = ''
  END ELSE BEGIN
    SET @opt_9nick_name = 'AND   D.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END


  -- FP00461 find_FP00461  
  SET @v_dSql = ''
  SET @v_dSql += '  		SELECT DISTINCT A.COMPANY_ID'+char(10)
  SET @v_dSql += '  		       ,A.DIVISION_ID'+char(10)
  SET @v_dSql += '  		       ,A.SITE_ID'+char(10)
  SET @v_dSql += '  		       ,A.PLANT_ID'+char(10)
  SET @v_dSql += '  		       ,A.FACTORY_ID'+char(10)
  SET @v_dSql += '  		       ,A.ITEM_ID'+char(10)
  SET @v_dSql += '  		       ,A.OPERATION_ID'+char(10)
  SET @v_dSql += '  		       ,A.LINE_ID'+char(10)
  SET @v_dSql += '  			     ,C.LINE_NAME'+char(10)
  SET @v_dSql += '  		       ,D.NICK_NAME'+char(10)
  SET @v_dSql += '  		       ,B.WORKER_QTY'+char(10)
  SET @v_dSql += '  		       ,B.INSERT_ID'+char(10)
  SET @v_dSql += '  		       ,B.INSERT_TIME'+char(10)
  SET @v_dSql += '  		       ,B.UPDATE_ID'+char(10)
  SET @v_dSql += '  		       ,B.UPDATE_TIME'+char(10)
  SET @v_dSql += '  		       ,(CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN'+char(10)
  SET @v_dSql += '  		FROM 	  SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '  		LEFT OUTER JOIN SCM_PACK_WORKER_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '  		ON 	A.COMPANY_ID        = B.COMPANY_ID'+char(10)
  SET @v_dSql += '  		AND A.DIVISION_ID       = B.DIVISION_ID'+char(10)
  SET @v_dSql += '  		AND A.SITE_ID           = B.SITE_ID'+char(10)
  SET @v_dSql += '  		AND A.PLANT_ID          = B.PLANT_ID'+char(10)
  SET @v_dSql += '  		AND A.FACTORY_ID        = B.FACTORY_ID'+char(10)
  SET @v_dSql += '  		AND A.ITEM_ID           = B.ITEM_ID'+char(10)
  SET @v_dSql += '  		AND A.LINE_ID           = B.LINE_ID'+char(10)
  SET @v_dSql += '  		LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '  		ON 	A.COMPANY_ID        = C.COMPANY_ID'+char(10)
  SET @v_dSql += '  		AND A.DIVISION_ID       = C.DIVISION_ID'+char(10)
  SET @v_dSql += '  		AND A.SITE_ID           = C.SITE_ID'+char(10)
  SET @v_dSql += '  		AND A.PLANT_ID          = C.PLANT_ID'+char(10)
  SET @v_dSql += '  		AND A.FACTORY_ID        = C.FACTORY_ID'+char(10)
  SET @v_dSql += '  		AND	A.OPERATION_ID      = C.OPERATION_ID'+char(10)
  SET @v_dSql += '  		AND A.LINE_ID           = C.LINE_ID'+char(10)
  SET @v_dSql += '  		INNER JOIN SCM_ITEM_M D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID        = D.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID       = D.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID           = D.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.ITEM_ID           = D.ITEM_ID'+char(10)
  SET @v_dSql += '      AND D.ACTIVE_FLAG       = ''Y'''+char(10)
  SET @v_dSql += '      INNER JOIN SCM_SYS_LOOKUP_VALUE E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON  A.SITE_ID           = E.SEGMENT2'+char(10)
  SET @v_dSql += '      AND	A.DIVISION_ID       = E.SEGMENT3'+char(10)
  SET @v_dSql += '      AND	A.OPERATION_ID      = E.SEGMENT4'+char(10)
  SET @v_dSql += '      AND E.LOOKUP_TYPE_CODE  = ''PACK_WORKER_OPERATION'''+char(10)
  SET @v_dSql += '      AND E.SEGMENT5          = ''Y'''+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '           SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID'+char(10)
  SET @v_dSql += '           FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '           WHERE  R.USER_ID   ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '           AND    R.SAVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '      ) R'+char(10)
  SET @v_dSql += '      ON   A.COMPANY_ID   = R.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND  A.DIVISION_ID  = R.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND  A.SITE_ID      = R.SITE_ID'+char(10)
  SET @v_dSql += '      AND  A.PLANT_ID     = R.PLANT_ID'+char(10)
  SET @v_dSql += '      AND  A.FACTORY_ID   = R.FACTORY_ID'+char(10)
  SET @v_dSql += '      AND  A.OPERATION_ID = R.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND  A.LINE_ID      = R.LINE_ID'+char(10)
  SET @v_dSql += '  		WHERE EXISTS ('+char(10)
  SET @v_dSql += '            SELECT 1'+char(10)
  SET @v_dSql += '            FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '            AND    A.PLANT_ID     = B.PLANT_ID'+char(10)
  SET @v_dSql += '            AND    A.FACTORY_ID   = B.FACTORY_ID'+char(10)
  SET @v_dSql += '            AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '            AND    A.LINE_ID      = B.LINE_ID'+char(10)
  SET @v_dSql += '            AND    B.USER_ID      ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '  		AND A.PRIORITY NOT IN (0,9)'+char(10)
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND A.SITE_ID = #SITE_ID#
  SET @v_dSql += ' ' +@opt_1operation_id +' '+''+char(10)--AND A.OPERATION_ID = #OPERATION_ID#
  SET @v_dSql += ' ' +@opt_2line_id +' '+''+char(10)--AND A.LINE_ID = #LINE_ID#
  SET @v_dSql += ' ' +@opt_3item_id +' '+''+char(10)--AND UPPER(A.ITEM_ID) LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_4nick_name +' '+''+char(10)--AND   D.NICK_NAME LIKE '%' + #NICK_NAME# + '%'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  
  SET @v_dSql += '  		ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, A.LINE_ID'+char(10)
 
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00461_FIND_FP00461',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00461_FIND_FP00461',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
