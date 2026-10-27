CREATE PROCEDURE [dbo].[PR_UI_FP01624_EXCEL_2_FIND_FP01624_IMPORT]
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
/** 프로그램 ID   : PR_UI_FP01624_EXCEL_2_FIND_FP01624_IMPORT                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP01624_EXCEL_2_FIND_FP01624_IMPORT                                                                          **/
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
/** 2021-07-19     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01624_EXCEL_2_FIND_FP01624_IMPORT
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01624_EXCEL_2_FIND_FP01624_IMPORT'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_mpp_wpp_plan_type nvarchar(max) = ''
  DECLARE @p_main_plan_week nvarchar(max) = ''
  DECLARE @p_plan_revision nvarchar(max) = ''
  DECLARE @p_plan_revision2 nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_mpp_wpp_plan_type nvarchar(max)
  DECLARE @v_main_plan_week nvarchar(max)
  DECLARE @v_plan_revision nvarchar(max)
  DECLARE @v_plan_revision2 nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2line_id nvarchar(max)
  DECLARE @opt_3item_id nvarchar(max)
  DECLARE @opt_4site_id nvarchar(max)
  DECLARE @opt_5operation_id nvarchar(max)
  DECLARE @opt_6line_id nvarchar(max)
  DECLARE @opt_7item_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MPP_WPP_PLAN_TYPE' BEGIN
      SET @p_mpp_wpp_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MAIN_PLAN_WEEK' BEGIN
      SET @p_main_plan_week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_REVISION' BEGIN
      SET @p_plan_revision =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_REVISION2' BEGIN
      SET @p_plan_revision2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_mpp_wpp_plan_type ='''' + @p_mpp_wpp_plan_type + ''''
  SET @v_main_plan_week ='''' + @p_main_plan_week + ''''
  SET @v_plan_revision ='''' + @p_plan_revision + ''''
  SET @v_plan_revision2 ='''' + @p_plan_revision2 + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND   A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND   A.OPERATION_ID=' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2line_id = ''
  END ELSE BEGIN
    SET @opt_2line_id = 'AND   A.LINE_ID=' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_id = ''
  END ELSE BEGIN
    SET @opt_3item_id = 'AND   UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4site_id = ''
  END ELSE BEGIN
    SET @opt_4site_id = 'AND   A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5operation_id = ''
  END ELSE BEGIN
    SET @opt_5operation_id = 'AND   A.OPERATION_ID=' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6line_id = ''
  END ELSE BEGIN
    SET @opt_6line_id = 'AND   A.LINE_ID=' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7item_id = ''
  END ELSE BEGIN
    SET @opt_7item_id = 'AND   UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END


  -- FP01624_excel_2 find_FP01624_import  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.PLAN_WEEK, A.PLAN_REVISION'+char(10)
  SET @v_dSql += '           , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '           , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '           , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '           , A.PLAN_QTY'+char(10)
  SET @v_dSql += '      FROM   FP_MPP_WPP_BASE_PLAN_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON    A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND   A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND   A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND   A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '      INNER JOIN ('+char(10)
  SET @v_dSql += '          SELECT DISTINCT B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID,B.PLANT_ID, B.FACTORY_ID'+char(10)
  SET @v_dSql += '          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE  USER_ID     ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '      ) C'+char(10)
  SET @v_dSql += '      ON    A.COMPANY_ID  = C.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND   A.DIVISION_ID = C.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND   A.SITE_ID     = C.SITE_ID'+char(10)
  SET @v_dSql += '      AND   A.PLANT_ID    = C.PLANT_ID'+char(10)
  SET @v_dSql += '      AND   A.FACTORY_ID  = C.FACTORY_ID'+char(10)
  SET @v_dSql += '      INNER JOIN FP_MPP_WPP_BASE_PLAN_H D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON    A.PLAN_WEEK     = D.PLAN_WEEK'+char(10)
  SET @v_dSql += '      AND   A.PLAN_REVISION = D.PLAN_REVISION'+char(10)
  SET @v_dSql += '      WHERE 1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += 'AND   D.' + @p_MPP_WPP_PLAN_TYPE + '=''Y''' + char(10)
  IF @p_MPP_WPP_PLAN_TYPE = 'WPP' OR @p_MPP_WPP_PLAN_TYPE = 'MPP' OR @p_MPP_WPP_PLAN_TYPE = 'WO' BEGIN
	SET @v_dSql += 'AND   A.PLAN_WEEK   = ''' + @p_MAIN_PLAN_WEEK + ''' ' + char(10)
	
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_REVISION' , 'EQ', @p_PLAN_REVISION)) + char(10)

	--IF ISNULL(@p_PLAN_REVISION,'') <> '' BEGIN
	--	SET @v_dSql += 'AND   A.PLAN_REVISION IN (' + @p_PLAN_REVISION + ')' + char(10)
	--END
  END -- end of   @p_MPP_WPP_PLAN_TYPE = 'WPP'
  ELSE BEGIN
    IF ISNULL(@p_PLAN_REVISION2,'') <> '' BEGIN
		SET @v_dSql += 'AND EXISTS ( ' + char(10)
		SET @v_dSql += '    SELECT 1 ' + char(10)
		SET @v_dSql += '    FROM ( ' + char(10)
		SET @v_dSql += @p_PLAN_REVISION2
		SET @v_dSql += '   ) _MPP ' + char(10)
		SET @v_dSql += '    WHERE A.PLAN_WEEK     = _MPP._WEEK ' + char(10)
		SET @v_dSql += '    AND   A.PLAN_REVISION = _MPP._REV ' + char(10)
		SET @v_dSql += ') ' + char(10)
	END
  END

  --SET @v_dSql += '
  --{
  --        var sql = "";
  --        var sType = $data.MPP_WPP_PLAN_TYPE;
  --
  --        sql+="AND   D." + sType + "=''''Y''''\r\n";
  --
  --        if(sType == "WPP" || sType == "MRP" || sType == "WO") {
  --          sql+="AND   A.PLAN_WEEK   = ''''" + $data.MAIN_PLAN_WEEK + "'''' \r\n";
  --
  --        	if($data.PLAN_REVISION != null && $data.PLAN_REVISION != ""){
  --        	  sql+= "AND   A.PLAN_REVISION IN (" + $data.PLAN_REVISION + ")\r\n";
  --        	}
  --
  --        }
  --        else if(sType == "MPP") {
  --        	if($data.PLAN_REVISION2 != null && $data.PLAN_REVISION2 != ""){
  --            sql+="AND EXISTS ( \r\n"
  --            sql+="    SELECT 1 \r\n"
  --            sql+="    FROM ( \r\n"
  --            sql+=$data.PLAN_REVISION2;
  --            sql+="   ) _MPP \r\n"
  --            sql+="    WHERE A.PLAN_WEEK     = _MPP._WEEK \r\n"
  --            sql+="    AND   A.PLAN_REVISION = _MPP._REV \r\n"
  --            sql+=") \r\n"
  --        	}
  --        }
  --
  --        sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND   A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND   A.SITE_ID=#SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --      		sql+= "AND   A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --      		sql+= "AND   A.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += ' ' +@opt_1operation_id +' '+''+char(10)--AND   A.OPERATION_ID=#OPERATION_ID#
  SET @v_dSql += ' ' +@opt_2line_id +' '+''+char(10)--AND   A.LINE_ID=#LINE_ID#
  SET @v_dSql += ' ' +@opt_3item_id +' '+''+char(10)--AND   UPPER(A.ITEM_ID) LIKE '%' + UPPER(#ITEM_ID#) + '%'
  SET @v_dSql += '      AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '      ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '             , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '             , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '             , CONVERT(VARCHAR,A.PLAN_DATE,112)'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --    		var param = $data.param;
  --    		$data.querySet1 = $jdbc.queryList("FP01624_excel_2","find_FP01624_import",param);
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
