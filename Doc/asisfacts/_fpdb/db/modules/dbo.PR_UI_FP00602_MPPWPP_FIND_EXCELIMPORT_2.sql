CREATE PROCEDURE [dbo].[PR_UI_FP00602_MPPWPP_FIND_EXCELIMPORT_2]
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
/** 프로그램 ID   : PR_UI_FP00602_MPPWPP_FIND_EXCELIMPORT_2                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_MPPWPP_FIND_EXCELIMPORT_2                                                                          **/
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
/** 2021-06-30     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_MPPWPP_FIND_EXCELIMPORT_2
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_MPPWPP_FIND_EXCELIMPORT_2'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  --DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_item_name nvarchar(max) = ''
  DECLARE @p_prod_type nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_mpp_wpp nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_operation_lt nvarchar(max) = ''
  DECLARE @p_line_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_master_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  --DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_item_name nvarchar(max)
  DECLARE @v_prod_type nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_mpp_wpp nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_operation_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2item_id nvarchar(max)
  DECLARE @opt_3item_name nvarchar(max)
  DECLARE @opt_4prod_type nvarchar(max)
  DECLARE @opt_5top_item_id nvarchar(max)
  DECLARE @opt_6site_id nvarchar(max)
  DECLARE @opt_7operation_id nvarchar(max)
  DECLARE @opt_8item_id nvarchar(max)
  DECLARE @opt_9item_name nvarchar(max)
  DECLARE @opt_10prod_type nvarchar(max)
  DECLARE @opt_11top_item_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
      SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_NAME' BEGIN
      SET @p_item_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
      SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MPP_WPP' BEGIN
      SET @p_mpp_wpp =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
    --  SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_master_id ='''' + @p_master_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  --SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_item_name ='''' + @p_item_name + ''''
  SET @v_prod_type ='''' + @p_prod_type + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_mpp_wpp ='''' + @p_mpp_wpp + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_operation_lt ='''' + @p_operation_lt + ''''
  SET @v_line_lt ='''' + @p_line_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  --SET @STRLEN = LEN(@p_operation_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_1operation_id = ''
  --END ELSE BEGIN
  --  SET @opt_1operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  --END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2item_id = ''
  END ELSE BEGIN
    SET @opt_2item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_name = ''
  END ELSE BEGIN
    SET @opt_3item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_4prod_type = ''
  END ELSE BEGIN
    SET @opt_4prod_type = 'AND    A.PRODUCTION_TYPE = ' + @v_prod_type+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5top_item_id = ''
  END ELSE BEGIN
    SET @opt_5top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6site_id = ''
  END ELSE BEGIN
    SET @opt_6site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  --SET @STRLEN = LEN(@p_operation_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_7operation_id = ''
  --END ELSE BEGIN
  --  SET @opt_7operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  --END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8item_id = ''
  END ELSE BEGIN
    SET @opt_8item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_9item_name = ''
  END ELSE BEGIN
    SET @opt_9item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_10prod_type = ''
  END ELSE BEGIN
    SET @opt_10prod_type = 'AND    A.PRODUCTION_TYPE = ' + @v_prod_type+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11top_item_id = ''
  END ELSE BEGIN
    SET @opt_11top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END


  -- FP00602_MPPWPP find_ExcelImport_2  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '           , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '           , A.OPERATION_ID'+char(10)
  SET @v_dSql += '           , A.FACTORY_ID, A.LOCATION, A.PLM_EC_NO, A.VERSION '+char(10) -- version 추가... 20230908
  SET @v_dSql += '           , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '           , A.LINE_ID, A.ELECTRODE_TYPE, ISNULL(D.LINE_NAME,''-'') AS LINE_NAME'+char(10)
  SET @v_dSql += '           , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  IF isnull(@p_MPP_WPP,'') = 'WPP_OUT_QTY' 
  BEGIN
	  SET @v_dSql += ', A.WPP_CELL_OUT_QTY AS QTY'+char(10)
  END ELSE BEGIN
	  SET @v_dSql += ', A.MPP_CELL_OUT_QTY AS QTY'+char(10)
  END
  --SET @v_dSql += '
  --{
  --            var sql="";
  --            var sType = $data.MPP_WPP;
  --
  --            if(sType == "WPP_OUT_QTY")  sql = ", A.WPP_CELL_OUT_QTY AS QTY";
  --            else                        sql = ", A.MPP_CELL_OUT_QTY AS QTY";
  --
  --            sql;
  --           }

  --'
  SET @v_dSql += '           , A.DATE_SEQ AS SEQ'+char(10)
  SET @v_dSql += '      FROM   FP_AMEND_PLAN_CELL_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      INNER JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID        = C.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.TOP_ITEM_ID    = C.ITEM_ID'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON     A.COMPANY_ID     = D.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID    = D.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID        = D.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.PLANT_ID       = D.PLANT_ID'+char(10)
  SET @v_dSql += '      AND    A.FACTORY_ID     = D.FACTORY_ID'+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID   = D.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND    A.LINE_ID        = D.LINE_ID'+char(10)
  SET @v_dSql += '      AND    A.ELECTRODE_TYPE = D.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      WHERE  A.INSTANCE_ID    ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '      AND    A.FP_PLAN_ID     ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '      AND    A.' + @p_mpp_wpp + ' > 0'+char(10)

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sDiv = $data.DIVISION_LT;
  --        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --        sql;
  --      }

  --'
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sPlt = $data.PLANT_LT;
  --        sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --        sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sFac = $data.FACTORY_LT;
  --        sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --        sql;
  --      }

  --'
  --SET @v_dSql += ' ' +@opt_1operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.OPERATION_LT != null && $data.OPERATION_LT != ""){
  --      		sql+= "AND A.OPERATION_ID IN (" + $data.OPERATION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sLine = $data.LINE_LT;
  --        sql="AND    A.LINE_ID IN (" + sLine + ")";
  --        sql;
  --      }

  --'
  SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_3item_name +' '+''+char(10)--AND    C.NICK_NAME LIKE '%' + #ITEM_NAME# + '%'
  --SET @v_dSql += ' ' +@opt_4prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE = #PROD_TYPE#
  SET @v_dSql += ' ' +@opt_5top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  SET @v_dSql += '      ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '      		, A.PLAN_DATE'+char(10)
  SET @v_dSql += '      		, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '      		, A.MARKET'+char(10)
  SET @v_dSql += '      		, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '      		, A.OPERATION_ID DESC'+char(10)
  SET @v_dSql += '      		, A.ITEM_ID, A.PLM_EC_NO, A.VERSION '+char(10) -- version 추가... 20230908
  SET @v_dSql += '      		, A.LINE_ID'+char(10)
  SET @v_dSql += '      		, A.ELECTRODE_TYPE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00602_MPPWPP","find_ExcelImport_2",param);
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
