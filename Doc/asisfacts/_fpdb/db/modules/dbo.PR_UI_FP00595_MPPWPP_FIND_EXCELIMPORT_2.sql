CREATE PROCEDURE [dbo].[PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2]
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
/** 프로그램 ID   : PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2                                                                          **/
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
/** 2022-01-20     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_item_name nvarchar(max) = ''
  DECLARE @p_prod_type nvarchar(max) = ''
  DECLARE @p_round_point nvarchar(max) = ''
  DECLARE @p_mpp_wpp nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_line_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_item_name nvarchar(max)
  DECLARE @v_prod_type nvarchar(max)
  DECLARE @v_round_point nvarchar(max)
  DECLARE @v_mpp_wpp nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2top_item_id nvarchar(max)
  DECLARE @opt_3item_id nvarchar(max)
  DECLARE @opt_4item_name nvarchar(max)
  DECLARE @opt_5prod_type nvarchar(max)
  DECLARE @opt_6site_id nvarchar(max)
  DECLARE @opt_7operation_id nvarchar(max)
  DECLARE @opt_8top_item_id nvarchar(max)
  DECLARE @opt_9item_id nvarchar(max)
  DECLARE @opt_10item_name nvarchar(max)
  DECLARE @opt_11prod_type nvarchar(max)

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
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
      SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_NAME' BEGIN
      SET @p_item_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
      SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ROUND_POINT' BEGIN
      SET @p_round_point =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MPP_WPP' BEGIN
      SET @p_mpp_wpp =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_LT' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_LT' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_LT' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_LT' BEGIN
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
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_item_name ='''' + @p_item_name + ''''
  SET @v_prod_type ='''' + @p_prod_type + ''''
  SET @v_round_point ='''' + @p_round_point + ''''
  SET @v_mpp_wpp ='''' + @p_mpp_wpp + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_line_lt ='''' + @p_line_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2top_item_id = ''
  END ELSE BEGIN
    SET @opt_2top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_id = ''
  END ELSE BEGIN
    SET @opt_3item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_4item_name = ''
  END ELSE BEGIN
    SET @opt_4item_name = 'AND    B.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_5prod_type = ''
  END ELSE BEGIN
    SET @opt_5prod_type = 'AND    A.PRODUCTION_TYPE = ' + @v_prod_type+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6site_id = ''
  END ELSE BEGIN
    SET @opt_6site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7operation_id = ''
  END ELSE BEGIN
    SET @opt_7operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8top_item_id = ''
  END ELSE BEGIN
    SET @opt_8top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9item_id = ''
  END ELSE BEGIN
    SET @opt_9item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_10item_name = ''
  END ELSE BEGIN
    SET @opt_10item_name = 'AND    B.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_11prod_type = ''
  END ELSE BEGIN
    SET @opt_11prod_type = 'AND    A.PRODUCTION_TYPE = ' + @v_prod_type+''
  END


  -- FP00595_MPPWPP find_ExcelImport_2  
  SET @v_dSql = ''
  SET @v_dSql += '    		SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '		           , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '		           , A.OPERATION_ID, A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		           , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '		           , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '		           , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  DECLARE @qty_batch NVARCHAR(100) = 'WPP_IN_QTY_BATCH'
  DECLARE @qty_cell NVARCHAR(100) = 'WPP_IN_QTY_CELL'
  DECLARE @qty_m NVARCHAR(100) = 'WPP_IN_QTY_M'
  DECLARE @qty_jr NVARCHAR(100) = 'WPP_IN_QTY_JR'
  
  IF @p_MPP_WPP = 'WPP' BEGIN
	SET @qty_batch = 'WPP_IN_QTY_BATCH'
	--SET @qty_cell = 'WPP_IN_QTY_CELL'
	--SET @qty_m = 'WPP_IN_QTY_M'
	--SET @qty_jr = 'WPP_IN_QTY_JR'
  END ELSE BEGIN -- @p_MPP_WPP = 'WPP
	SET @qty_batch = 'MPP_IN_QTY_BATCH'
	SET @qty_cell = 'MPP_IN_QTY_CELL'
	SET @qty_m = 'MPP_IN_QTY_M'
	SET @qty_jr = 'MPP_IN_QTY_JR'
  END

  
  	SET @v_dSql += ', ROUND(A.' + @qty_batch + ', '+ @p_round_point +') AS QTY' +char(10)
  	SET @v_dSql += ', ROUND(A.' + @qty_batch + ', '+ @p_round_point +') AS ADJUST_IN_QTY_BATCH' +char(10)
  	SET @v_dSql += ', A.' + @qty_m + ' AS ADJUST_IN_QTY_M' +char(10)
  	SET @v_dSql += ', A.' + @qty_cell + ' AS ADJUST_IN_QTY_CELL' +char(10)
  	SET @v_dSql += ', A.' + @qty_jr + ' AS ADJUST_IN_QTY_JR' +char(10)
  --SET @v_dSql += '
  --{
  --		                var sql = "";
  --		                var qty_batch = "";
  --		                var qty_cell = "";
  --		                var qty_m = "";
  --		                var qty_jr = "";
  --		                var round_point = $data.ROUND_POINT;
  --
  --		                if($data.MPP_WPP == "WPP"){
  --		                	qty_batch = "WPP_IN_QTY_BATCH";
  --		                	qty_cell  = "WPP_IN_QTY_CELL";
  --		                	qty_m 	  = "WPP_IN_QTY_M";
  --		                	qty_jr    = "WPP_IN_QTY_JR";
  --		                } else {
  --		                	qty_batch = "MPP_IN_QTY_BATCH";
  --		                	qty_cell  = "MPP_IN_QTY_CELL";
  --		                	qty_m 	  = "MPP_IN_QTY_M";
  --		                	qty_jr 	  = "MPP_IN_QTY_JR";
  --		                }
  --
  --		                sql += ", ROUND(A." + qty_batch + ", "+ round_point +") AS QTY						\r\n";
  --		                sql += ", ROUND(A." + qty_batch + ", "+ round_point +") AS ADJUST_IN_QTY_BATCH		\r\n";
  --		                sql += ", A." + qty_m + " AS ADJUST_IN_QTY_M			\r\n";
  --		                sql += ", A." + qty_cell + " AS ADJUST_IN_QTY_CELL		\r\n";
  --		                sql += ", A." + qty_jr + " AS ADJUST_IN_QTY_JR		\r\n";
  --
  --		                sql;
  --	               }

  --'
  SET @v_dSql += '		           , A.SEQ'+char(10)
  SET @v_dSql += '		           , A.WORK_REQUEST_MODEL_ID, A.WORK_REQUEST_MODEL_ID AS PC_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '		      FROM   FP_AMEND_DAILY_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		      INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		      ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '		      AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '		      AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '		      AND    A.ITEM_ID        = B.ITEM_ID'+char(10)
  SET @v_dSql += '		      INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		      ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
  SET @v_dSql += '		      AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
  SET @v_dSql += '		      AND    A.SITE_ID        = C.SITE_ID'+char(10)
  SET @v_dSql += '		      AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
  SET @v_dSql += '		      AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
  SET @v_dSql += '		      AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
  SET @v_dSql += '		      AND    A.LINE_ID        = C.LINE_ID'+char(10)
  SET @v_dSql += '		      AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		      WHERE  INSTANCE_ID      ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '		      AND    FP_PLAN_ID       ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '		      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  --SET @v_dSql += '
  --{
  --		        var sql="";
  --		        var sDiv = $data.DIVISION_LT;
  --		        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --		        sql;
  --		      }

  --'
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --		        var sql="";
  --		        var sPlt = $data.PLANT_LT;
  --		        sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --		        sql;
  --		      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --		        var sql="";
  --		        var sFac = $data.FACTORY_LT;
  --		        sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --		        sql;
  --		      }

  --'
  --SET @v_dSql += ' ' +@opt_1operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --		        var sql="";
  --		        var sLine = $data.LINE_LT;
  --		        sql="AND    A.LINE_ID IN (" + sLine + ")";
  --		        sql;
  --		      }

  --'
  SET @v_dSql += ' ' +@opt_2top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_3item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_4item_name +' '+''+char(10)--AND    B.NICK_NAME LIKE '%' + #ITEM_NAME# + '%'
  SET @v_dSql += ' ' +@opt_5prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE = #PROD_TYPE#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF @p_MPP_WPP = 'WPP' BEGIN
	SET @v_dSql += 'AND A.WPP_IN_QTY_BATCH > 0'+char(10)
  END ELSE BEGIN
	SET @v_dSql += 'AND A.MPP_IN_QTY_BATCH > 0'+char(10)
  END
  --SET @v_dSql += '
  --{
  --	                var sql = "";
  --	                var round_point = $data.ROUND_POINT;
  --
  --	                if($data.MPP_WPP == "WPP"){
  --	                	sql += "AND 	  A.WPP_IN_QTY_BATCH > 0						\r\n";
  --	                } else {
  --	                	sql += "AND 	  A.MPP_IN_QTY_BATCH > 0						\r\n";
  --	                }
  --
  --	                sql;
  --               }

  --'
  SET @v_dSql += '		      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '		             , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		             , A.ITEM_ID, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '		             , A.PLAN_DATE, (CASE WHEN A.ADJUST_IN_QTY_BATCH > 0 THEN A.SEQ ELSE 999 END)'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00595_MPPWPP","find_ExcelImport_2",param);
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
