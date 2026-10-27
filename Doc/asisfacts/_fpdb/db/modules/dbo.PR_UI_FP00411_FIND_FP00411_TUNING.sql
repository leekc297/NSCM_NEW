CREATE  PROCEDURE [dbo].[PR_UI_FP00411_FIND_FP00411_TUNING]
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
/** 프로그램 ID   : PR_UI_FP00411_FIND_FP00411                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00411_FIND_FP00411                                                                          **/
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
/** 2021-08-24     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00411_FIND_FP00411
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00411_FIND_FP00411_TUNING'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1item_id nvarchar(max)
  DECLARE @opt_2nick_name nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4item_id nvarchar(max)
  DECLARE @opt_5nick_name nvarchar(max)

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
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_factory_lt ='''' + @p_factory_id + ''''
  SET @v_line_lt ='''' + @p_line_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND   A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1item_id = ''
  END ELSE BEGIN
    SET @opt_1item_id = 'AND   A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_2nick_name = ''
  END ELSE BEGIN
    SET @opt_2nick_name = 'AND   A.NICK_NAME LIKE ''%'' + RTRIM(LTRIM(' + @v_nick_name+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND   A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4item_id = ''
  END ELSE BEGIN
    SET @opt_4item_id = 'AND   A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_5nick_name = ''
  END ELSE BEGIN
    SET @opt_5nick_name = 'AND   A.NICK_NAME LIKE ''%'' + RTRIM(LTRIM(' + @v_nick_name+')) + ''%'''
  END

  --DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += 'P_SYS_TYPE:' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_FLAG:' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_GUBUN:' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += 'P_USER_ID:' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += 'IN_COLUMNS:' +ISNULL(@IN_COLUMNS,'') +CHAR(10)
--SET @PARAMS += 'IN_ROW:' +ISNULL(@IN_ROW,'') +CHAR(10)
--SET @PARAMS += 'OPT_NONE:' +ISNULL(@OPT_NONE,'') +CHAR(10)
--SELECT @PARAMS AS SQL
--RETURN

  -- FP00411 find_FP00411  
  SET @v_dSql = ''
  SET @v_dSql += '    	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.ITEM_ID, A.NICK_NAME'+char(10)
  SET @v_dSql += '		       , A.BEFORE_DEGAS_ROUTE_ID, A.BEFORE_DEGAS_ROUTE_DESCRIPTION, A.BEFORE_DEGAS_ROUTE_TYPE, A.BEFORE_DEGAS_LT, ROUND(A.BEFORE_DEGAS_LT/60/24,2) AS BEFORE_DEGAS_LT_DAY'+char(10)
  SET @v_dSql += '		       , A.AFTER_DEGAS_ROUTE_ID, A.AFTER_DEGAS_ROUTE_DESCRIPTION, A.AFTER_DEGAS_ROUTE_TYPE, A.AFTER_DEGAS_LT, ROUND(A.AFTER_DEGAS_LT/60/24,2) AS AFTER_DEGAS_LT_DAY'+char(10)
  SET @v_dSql += '		       , A.SHORTER_OPERATION_ID AS OPERATION_ID, B.SHORTER_LT'+char(10)
  SET @v_dSql += '		       , ROUND(A.BEFORE_DEGAS_LT/60/24,2) + ROUND(A.AFTER_DEGAS_LT/60/24,2) AS TOTAL_LT'+char(10)
  SET @v_dSql += '		       , ROUND(A.BEFORE_DEGAS_LT/60/24,2) + ROUND(A.AFTER_DEGAS_LT/60/24,2) + ISNULL(B.SHORTER_LT,0) AS TOTAL_CHG_LT'+char(10)
  SET @v_dSql += '		       , CONVERT(VARCHAR,B.INSERT_TIME,20) AS INSERT_TIME'+char(10)
  SET @v_dSql += '		       , CONVERT(VARCHAR,B.UPDATE_TIME,20) AS UPDATE_TIME'+char(10)
  SET @v_dSql += '		       , B.INSERT_ID, B.UPDATE_ID'+char(10)
  SET @v_dSql += '		       , CASE WHEN A.BEFORE_DEGAS_ROUTE_ID IS NULL THEN ''Y'' ELSE ''N'' END AS CHK_BEFORE'+char(10)
  SET @v_dSql += '		       , CASE WHEN A.AFTER_DEGAS_ROUTE_ID IS NULL THEN ''Y'' ELSE ''N'' END AS CHK_AFTER'+char(10)
  SET @v_dSql += '		       , (CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN'+char(10)
  SET @v_dSql += '  		FROM FP_FORMATION_LT_V A WITH(NOLOCK)'+char(10)

  SET @v_dSql += '  		LEFT OUTER JOIN FP_FORMATION_SHORTER_LT_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '  		ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '  		AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '  		AND A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '  		AND A.PLANT_ID    = B.PLANT_ID'+char(10)
  SET @v_dSql += '  		AND A.FACTORY_ID  = B.FACTORY_ID'+char(10)
  SET @v_dSql += '  		AND A.LINE_ID     = B.LINE_ID'+char(10)
  SET @v_dSql += '  		AND A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '  		AND A.SHORTER_OPERATION_ID = B.OPERATION_ID'+char(10)


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
  SET @v_dSql += '      AND  A.SHORTER_OPERATION_ID = R.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND  A.LINE_ID      = R.LINE_ID'+char(10)


  
  --SET @v_dSql += '  		LEFT OUTER JOIN FP_FORMATION_SHORTER_LT_M B WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '  		ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  --SET @v_dSql += '  		AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
  --SET @v_dSql += '  		AND A.SITE_ID     = B.SITE_ID'+char(10)
  --SET @v_dSql += '  		AND A.PLANT_ID    = B.PLANT_ID'+char(10)
  --SET @v_dSql += '  		AND A.FACTORY_ID  = B.FACTORY_ID'+char(10)
  --SET @v_dSql += '  		AND A.LINE_ID     = B.LINE_ID'+char(10)
  --SET @v_dSql += '  		AND A.ITEM_ID     = B.ITEM_ID'+char(10)
  --SET @v_dSql += '  		AND A.SHORTER_OPERATION_ID = B.OPERATION_ID'+char(10)

  --SET @v_dSql += '  		WHERE EXISTS ('+char(10)
  --SET @v_dSql += '            SELECT 1'+char(10)
  --SET @v_dSql += '            FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '            WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  --SET @v_dSql += '            AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  --SET @v_dSql += '            AND    A.SITE_ID      = B.SITE_ID'+char(10)
  --SET @v_dSql += '            AND    A.PLANT_ID     = B.PLANT_ID'+char(10)
  --SET @v_dSql += '            AND    A.FACTORY_ID   = B.FACTORY_ID'+char(10)
  --SET @v_dSql += '            AND    A.SHORTER_OPERATION_ID = B.OPERATION_ID'+char(10)
  --SET @v_dSql += '            AND    A.LINE_ID      = B.LINE_ID'+char(10)
  --SET @v_dSql += '            AND    B.USER_ID      ='+char(10)
  --SET @v_dSql += '' + @v_user_id+''+char(10)
  --SET @v_dSql += '      )'+char(10)



  SET @v_dSql += '      INNER JOIN ('+char(10)
  SET @v_dSql += '           SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID'+char(10)
  SET @v_dSql += '           FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '           WHERE  R.USER_ID   ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '      ) V'+char(10)
  SET @v_dSql += '            ON  A.COMPANY_ID   = V.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID  = V.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID      = V.SITE_ID'+char(10)
  SET @v_dSql += '            AND    A.PLANT_ID     = V.PLANT_ID'+char(10)
  SET @v_dSql += '            AND    A.FACTORY_ID   = V.FACTORY_ID'+char(10)
  SET @v_dSql += '            AND    A.SHORTER_OPERATION_ID = V.OPERATION_ID'+char(10)
  SET @v_dSql += '            AND    A.LINE_ID      = V.LINE_ID'+char(10)
  SET @v_dSql += '            WHERE  1   = 1 '+char(10)


  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  PRINT 'prin sql line 237 : ' +ISNULL( @v_dSql, '(null)');
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += '
  --{
  --  			var sql="";
  --  			var sDiv=$data.DIVISION_LT;
  --  			var sPlt=$data.PLANT_LT;
  --  			var sFac=$data.FACTORY_LT;
  --  			var sLin=$data.LINE_LT;
  --
  --  			if(sDiv!=null && sDiv!="") {
  --  				sql+="AND   A.DIVISION_ID IN (" + sDiv + ")\r\n"
  --  			}
  --  			if(sPlt!=null && sPlt!="") {
  --  				sql+="AND   A.PLANT_ID IN (" + sPlt + ")\r\n"
  --  			}
  --  			if(sFac!=null && sFac!="") {
  --  				sql+="AND   A.FACTORY_ID IN (" + sFac + ")\r\n"
  --  			}
  --  			if(sLin!=null && sLin!="") {
  --  				sql+="AND   A.LINE_ID IN (" + sLin + ")\r\n"
  --  			}
  --
  --  			sql;
  --  		}

  --'
  SET @v_dSql += '  		AND   A.SHORTER_OPERATION_ID IS NOT NULL'+char(10)
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND   A.SITE_ID = #SITE_ID#
  SET @v_dSql += ' ' +@opt_1item_id +' '+''+char(10)--AND   A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += ' ' +@opt_2nick_name +' '+''+char(10)--AND   A.NICK_NAME LIKE '%' + RTRIM(LTRIM(#NICK_NAME#)) + '%'
  SET @v_dSql += '  		ORDER BY A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.ITEM_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --
  --        $data.querySet1 = $jdbc.queryList("FP00411","find_FP00411",param);
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
      --exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    --exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
