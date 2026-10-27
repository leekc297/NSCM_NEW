CREATE PROCEDURE [dbo].[PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST]
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
/** 프로그램 ID   : PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST                                                                          **/
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
/** 2021-04-12     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_production_type nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_model_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_production_type nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_model_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0nick_name nvarchar(max)
  DECLARE @opt_1nick_name nvarchar(max)
  DECLARE @opt_2nick_name nvarchar(max)
  DECLARE @opt_3nick_name nvarchar(max)

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
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PRODUCTION_TYPE' BEGIN
      SET @p_production_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
      SET @p_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_production_type ='''' + @p_production_type + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_model_id ='''' + @p_model_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_0nick_name = ''
  END ELSE BEGIN
    SET @opt_0nick_name = 'AND    A.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_1nick_name = ''
  END ELSE BEGIN
    SET @opt_1nick_name = 'AND    A.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_2nick_name = ''
  END ELSE BEGIN
    SET @opt_2nick_name = 'AND    A.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_3nick_name = ''
  END ELSE BEGIN
    SET @opt_3nick_name = 'AND    A.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END


  -- FP00602_addLine find_ItemList_byTEST  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT DISTINCT A.*'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '        	SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID'+char(10)
  SET @v_dSql += '        		, UPPER('+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += ') AS MODEL_ID'+char(10)
  SET @v_dSql += '        		, UPPER('+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += ') AS ITEM_ID, A.NICK_NAME'+char(10)
  SET @v_dSql += '        		, (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND  ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '        				WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '        				ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE'+char(10)
  SET @v_dSql += '        	FROM   SCM_ITEM_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	INNER HASH JOIN ('+char(10)
  SET @v_dSql += '          		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '          		FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          		WHERE  1=1'+char(10)
  SET @v_dSql += '          		AND    A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '          		AND    A.SAVE_FLAG   = ''Y'''+char(10)
  SET @v_dSql += '          		AND    A.USER_ID     ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '        	) B'+char(10)
  SET @v_dSql += '        	ON     A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON     A.ITEM_CLASS = C.CLASS_ID'+char(10)
  SET @v_dSql += '        	WHERE  1=1'+char(10)
  SET @v_dSql += '        	AND'+char(10)
  SET @v_dSql += '' + @v_production_type+''+char(10)
  SET @v_dSql += ' IN (''TEST'',''D-TEST'',''E-TEST'')'+char(10)
  SET @v_dSql += '        	AND    RIGHT(A.FLOW_ID,5) IN ( ''A2000'',''A3000'',''A5000'',''A6000'',''A7000'',''A7100'',''A7400'',''A8000'',''A8100'',''A8200'',''A8400'',''A9000'' )'+char(10) -- A7400, A8400 add
  SET @v_dSql += '        	AND    A.ITEM_ID ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += ' ' +@opt_0nick_name +' '+''+char(10)--AND    A.NICK_NAME LIKE '%' + #NICK_NAME# + '%'
  SET @v_dSql += '        	-- TEST 타입 : model 기준 item'+char(10)
  SET @v_dSql += '        	UNION ALL'+char(10)
  SET @v_dSql += '        	SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID'+char(10)
  SET @v_dSql += '        		, UPPER('+char(10)
  SET @v_dSql += '' + @v_model_id+''+char(10)
  SET @v_dSql += ') AS MODEL_ID'+char(10)
  SET @v_dSql += '        		, UPPER('+char(10)
  SET @v_dSql += '' + @v_model_id+''+char(10)
  SET @v_dSql += ') AS ITEM_ID, A.NICK_NAME'+char(10)
  SET @v_dSql += '        		, (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND  ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '        				WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '        				ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE'+char(10)
  SET @v_dSql += '        	FROM   SCM_ITEM_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	INNER HASH JOIN ('+char(10)
  SET @v_dSql += '          		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '          		FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          		WHERE  1=1'+char(10)
  SET @v_dSql += '          		AND    A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '          		AND    A.SAVE_FLAG   = ''Y'''+char(10)
  SET @v_dSql += '          		AND    A.USER_ID     ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '        	) B'+char(10)
  SET @v_dSql += '        	ON     A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON     A.ITEM_CLASS = C.CLASS_ID'+char(10)
  SET @v_dSql += '        	WHERE  1=1'+char(10)
  SET @v_dSql += '        	AND'+char(10)
  SET @v_dSql += '' + @v_production_type+''+char(10)
  SET @v_dSql += ' IN (''TEST'',''D-TEST'',''E-TEST'')'+char(10)
  SET @v_dSql += '        	AND    RIGHT(A.FLOW_ID,5) IN ( ''A2000'',''A3000'',''A5000'',''A6000'',''A7000'',''A7100'',''A7400'',''A8000'',''A8100'',''A8200'',''A8400'',''A9000'' )'+char(10)
  SET @v_dSql += '        	AND    A.ITEM_ID ='+char(10)
  SET @v_dSql += '' + @v_model_id+''+char(10)
  SET @v_dSql += ' ' +@opt_0nick_name +' '+''+char(10)--AND    A.NICK_NAME LIKE '%' + #NICK_NAME# + '%'
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID, NICK_NAME, ITEM_TYPE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00602_addLine","find_ItemList_byTEST",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00602_ADDLINE_FIND_ITEMLIST_BYTEST',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
