CREATE PROCEDURE [dbo].[PR_UI_FP01624_FIND_FP01624]
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
/** 프로그램 ID   : PR_UI_FP01624_FIND_FP01624                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP01624_FIND_FP01624                                                                          **/
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
/** 2021-04-29     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01624_FIND_FP01624
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01624_FIND_FP01624'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_uom_type nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_mpp_wpp_plan_type nvarchar(max) = ''
  DECLARE @p_plan_week nvarchar(max) = ''
  DECLARE @p_plan_revision nvarchar(max) = ''
  DECLARE @p_plan_revision2 nvarchar(max) = ''
  DECLARE @p_dimension nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_unit_type nvarchar(max) = ''
  DECLARE @p_unit_value nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_uom_type nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_mpp_wpp_plan_type nvarchar(max)
  DECLARE @v_plan_week nvarchar(max)
  DECLARE @v_plan_revision nvarchar(max)
  DECLARE @v_plan_revision2 nvarchar(max)
  DECLARE @v_dimension nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_unit_type nvarchar(max)
  DECLARE @v_unit_value nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2line_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4operation_id nvarchar(max)
  DECLARE @opt_5line_id nvarchar(max)
  DECLARE @opt_6item_id nvarchar(max)
  DECLARE @opt_7site_id nvarchar(max)
  DECLARE @opt_8operation_id nvarchar(max)
  DECLARE @opt_9line_id nvarchar(max)
  DECLARE @opt_10site_id nvarchar(max)
  DECLARE @opt_11operation_id nvarchar(max)
  DECLARE @opt_12line_id nvarchar(max)
  DECLARE @opt_13item_id nvarchar(max)

  -- SRC FOR DELIMETER
  DECLARE @loop_src NVARCHAR(MAX) = ''
  DECLARE @_max_length integer = 0
  DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_4 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_5 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_6 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_7 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_8 NVARCHAR(MAX) = '' 

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
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'UOM_TYPE' BEGIN
      SET @p_uom_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MPP_WPP_PLAN_TYPE' BEGIN
      SET @p_mpp_wpp_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_WEEK' BEGIN
      SET @p_plan_week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_REVISION' BEGIN
      SET @p_plan_revision =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_REVISION2' BEGIN
      SET @p_plan_revision2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIMENSION' BEGIN
      SET @p_dimension =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'UNIT_TYPE' BEGIN
      SET @p_unit_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'UNIT_VALUE' BEGIN
      SET @p_unit_value =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_uom_type ='''' + @p_uom_type + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_factory_lt ='''' + @p_factory_id + ''''
  SET @v_mpp_wpp_plan_type ='''' + @p_mpp_wpp_plan_type + ''''
  SET @v_plan_week ='''' + @p_plan_week + ''''
  SET @v_plan_revision ='''' + @p_plan_revision + ''''
  SET @v_plan_revision2 ='''' + @p_plan_revision2 + ''''
  SET @v_dimension ='''' + @p_dimension + ''''
  SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_unit_type ='''' + @p_unit_type + ''''
  SET @v_unit_value ='''' + @p_unit_value + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID      = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2line_id = ''
  END ELSE BEGIN
    SET @opt_2line_id = 'AND    A.LINE_ID      = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND   A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4operation_id = ''
  END ELSE BEGIN
    SET @opt_4operation_id = 'AND   A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5line_id = ''
  END ELSE BEGIN
    SET @opt_5line_id = 'AND   A.LINE_ID      = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6item_id = ''
  END ELSE BEGIN
    SET @opt_6item_id = 'AND   UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7site_id = ''
  END ELSE BEGIN
    SET @opt_7site_id = 'AND    A.SITE_ID      = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8operation_id = ''
  END ELSE BEGIN
    SET @opt_8operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9line_id = ''
  END ELSE BEGIN
    SET @opt_9line_id = 'AND    A.LINE_ID      = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10site_id = ''
  END ELSE BEGIN
    SET @opt_10site_id = 'AND   A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11operation_id = ''
  END ELSE BEGIN
    SET @opt_11operation_id = 'AND   A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_12line_id = ''
  END ELSE BEGIN
    SET @opt_12line_id = 'AND   A.LINE_ID      = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_13item_id = ''
  END ELSE BEGIN
    SET @opt_13item_id = 'AND   UPPER(A.ITEM_ID) LIKE ''%'' + UPPER(' + @v_item_id+') + ''%'''
  END


  -- FP01624 find_FP01624  
  SET @v_dSql = ''
  --SET @v_dSql += @p_uom_type + char(10)

  SET @v_dSql += '      WITH MAIN AS ('+char(10)
  SET @v_dSql += '        SELECT A.PLAN_WEEK, A.PLAN_REVISION'+char(10)
  SET @v_dSql += '             , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '             , A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '             , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, RE.LINE_NAME'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF @p_uom_type = 'I' BEGIN
    SET @v_dSql += ', A.PLAN_QTY' + char(10)
  END ELSE IF @p_uom_type = 'R' BEGIN
    SET @v_dSql += ', A.ROLL_QTY AS PLAN_QTY' + char(10)
  END ELSE IF @p_uom_type = 'B' BEGIN
    SET @v_dSql += ', A.BATCH_QTY AS PLAN_QTY' + char(10)
  END ELSE IF @p_uom_type = 'J' BEGIN
    SET @v_dSql += ', A.JR_QTY AS PLAN_QTY' + char(10)
  END ELSE BEGIN
    SET @v_dSql += ', A.PLAN_QTY' + char(10)
  END


  --SET @v_dSql += '
  --{
  --                var sql="' + char(10)
  --                var uomtype = $data.UOM_TYPE;
  --
  --            		if(uomtype=="I") {
  --SET @v_dSql += ', A.PLAN_QTY' + char(10)
  ----            		} else if(uomtype=="R") {
  --SET @v_dSql += ', A.ROLL_QTY AS PLAN_QTY' + char(10)
  ----            		} else if(uomtype=="B") {
  --SET @v_dSql += ', A.BATCH_QTY AS PLAN_QTY' + char(10)
  ----            		} else if(uomtype=="J") {
  --SET @v_dSql += ', A.JR_QTY AS PLAN_QTY' + char(10)
  ----            		} else {
  --SET @v_dSql += ', A.PLAN_QTY' + char(10)
  --            		}
  --            		sql;
  --            	}

  --'
  SET @v_dSql += '            , EE.INSTANCE_ID, (CASE WHEN FF.MEMO IS NOT NULL THEN ''Y'' ELSE ''N'' END) AS MEMO'+char(10)
  SET @v_dSql += '        FROM   FP_MPP_WPP_BASE_PLAN_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        ON    A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '        AND   A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '        AND   A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '        AND   A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '        INNER JOIN FP_MPP_WPP_BASE_PLAN_H D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        ON    A.PLAN_WEEK     = D.PLAN_WEEK'+char(10)
  SET @v_dSql += '        AND   A.PLAN_REVISION = D.PLAN_REVISION'+char(10)
  SET @v_dSql += '    		LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '    		      SELECT A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, MAX(A.LINE_NAME) AS LINE_NAME'+char(10)
  SET @v_dSql += '							FROM   SCM_LINE_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						  WHERE  A.ACTIVE_FLAG = ''Y'''+char(10)
  --       select @v_dSql as [QUERY_VALUE]
  --RETURN 0
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  --         select @v_dSql as [QUERY_VALUE]
  --RETURN 0
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  --SET @v_dSql +=  @p_line_id
  --           select @v_dSql as [QUERY_VALUE]
  --RETURN 0
  SET @v_dSql += ' ' +@opt_2line_id +' '+''+char(10)--AND    A.LINE_ID      = #LINE_ID#
  --     select @v_dSql as [QUERY_VALUE]
  --RETURN 0
  SET @v_dSql += '						  GROUP BY A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID'+char(10)
  SET @v_dSql += '				) RE'+char(10)
  SET @v_dSql += '  			ON     A.COMPANY_ID   = RE.COMPANY_ID'+char(10)
  SET @v_dSql += '  			AND    A.DIVISION_ID  = RE.DIVISION_ID'+char(10)
  SET @v_dSql += '  			AND    A.SITE_ID      = RE.SITE_ID'+char(10)
  SET @v_dSql += '  			AND    A.PLANT_ID     = RE.PLANT_ID'+char(10)
  SET @v_dSql += '  			AND    A.FACTORY_ID   = RE.FACTORY_ID'+char(10)
  SET @v_dSql += '  			AND    A.OPERATION_ID = RE.OPERATION_ID'+char(10)
  SET @v_dSql += '  			AND    A.LINE_ID      = RE.LINE_ID'+char(10)
  SET @v_dSql += '        LEFT OUTER JOIN FP_MPP_WPP_BASE_PLAN_H EE WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        ON     A.PLAN_WEEK      = EE.PLAN_WEEK'+char(10)
  SET @v_dSql += '        AND    A.PLAN_REVISION  = EE.PLAN_REVISION'+char(10)
  SET @v_dSql += '        LEFT OUTER JOIN FP_AMEND_MEMO_M FF WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        ON     A.COMPANY_ID   = FF.COMPANY_ID'+char(10)
  SET @v_dSql += '        AND    A.DIVISION_ID  = FF.DIVISION_ID'+char(10)
  SET @v_dSql += '        AND    A.SITE_ID      = FF.SITE_ID'+char(10)
  SET @v_dSql += '        AND    A.PLANT_ID     = FF.PLANT_ID'+char(10)
  SET @v_dSql += '        AND    A.FACTORY_ID   = FF.FACTORY_ID'+char(10)
  SET @v_dSql += '        AND    A.OPERATION_ID = FF.OPERATION_ID'+char(10)
  SET @v_dSql += '        AND    A.LINE_ID      = FF.LINE_ID'+char(10)
  SET @v_dSql += '        AND    A.EQUIPMENT_ID = FF.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '        AND    A.PLAN_DATE    = FF.PLAN_DATE'+char(10)
  SET @v_dSql += '        AND    A.MARKET       = FF.MARKET'+char(10)
  SET @v_dSql += '        AND    A.PRODUCTION_TYPE = FF.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '        AND    EE.INSTANCE_ID = FF.INSTANCE_ID'+char(10)
  

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += ' AND    FF.MEMO_TYPE   = ''' + @p_MPP_WPP_PLAN_TYPE + '''' + char(10)
  --SET @v_dSql += '
  --{
  --          var sql = "' + char(10)
  --          var sType = $data.MPP_WPP_PLAN_TYPE;
  --
  --          sql = "AND    FF.MEMO_TYPE   = ''''" + sType + "''''"
  --
  --          sql;
  --        }

  --'
  SET @v_dSql += '        WHERE EXISTS ('+char(10)
  SET @v_dSql += '            SELECT 1'+char(10)
  SET @v_dSql += '            FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '            AND    A.PLANT_ID     = B.PLANT_ID'+char(10)
  SET @v_dSql += '            AND    A.FACTORY_ID   = B.FACTORY_ID'+char(10)
  SET @v_dSql += '            AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '            AND    A.LINE_ID      = B.LINE_ID'+char(10)
  SET @v_dSql += '            AND    EE.INSTANCE_ID = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '            AND    B.USER_ID      ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '        )'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  SET @v_dSql += 'AND   D.' + @p_MPP_WPP_PLAN_TYPE + '=''Y''' + char(10)
  IF ISNULL(@p_MPP_WPP_PLAN_TYPE,'') = 'WPP' OR ISNULL(@p_MPP_WPP_PLAN_TYPE,'') = 'MRP' OR ISNULL(@p_MPP_WPP_PLAN_TYPE,'') = 'WO' BEGIN
	SET @v_dSql += 'AND   A.PLAN_WEEK   = ''' + @p_PLAN_WEEK + ''' ' + char(10)
	
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
  --          var sql = "' + char(10)
  --          var sType = $data.MPP_WPP_PLAN_TYPE;
  --
  --  SET @v_dSql += 'AND   D." + sType + "=''''Y''''' + char(10)
  --
  --          if(sType == "WPP" || sType == "MRP" || sType == "WO") {
  --            SET @v_dSql += 'AND   A.PLAN_WEEK   = ''''" + $data.PLAN_WEEK + "'''' ' + char(10)
  --
  --          	if($data.PLAN_REVISION != null && $data.PLAN_REVISION != ""){
  --          	  SET @v_dSql += 'AND   A.PLAN_REVISION IN (" + $data.PLAN_REVISION + ")' + char(10)
  --          	}
  --
  --          }
  --          else if(sType == "MPP") {
  --          	if($data.PLAN_REVISION2 != null && $data.PLAN_REVISION2 != ""){
  --              SET @v_dSql += 'AND EXISTS ( ' + char(10)
  --              SET @v_dSql += '    SELECT 1 ' + char(10)
  --              SET @v_dSql += '    FROM ( ' + char(10)
  --              sql+=$data.PLAN_REVISION2;
  --              SET @v_dSql += '   ) _MPP ' + char(10)
  --              SET @v_dSql += '    WHERE A.PLAN_WEEK     = _MPP._WEEK ' + char(10)
  --              SET @v_dSql += '    AND   A.PLAN_REVISION = _MPP._REV ' + char(10)
  --              SET @v_dSql += ') ' + char(10)
  --          	}
  --          }
  --
  --          sql;
  --        }

  --'
  SET @v_dSql += '        AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)

  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += ' ' +@opt_2line_id +' '+''+char(10)--AND    A.LINE_ID      = #LINE_ID#
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' UPPER(A.ITEM_ID)' , 'LK', @p_item_id)) + char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT'+char(10)

		--    	  											          select @v_dSql as [QUERY_VALUE]
  --RETURN 0
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
	SET @loop_src = @p_dimension
	--SET @v_dSql += @loop_src + char(10)
	SET @mst_loop_cnt = 0
	SET @max_loop_cnt = 0
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단

	WHILE @mst_loop_cnt < @max_loop_cnt AND ISNULL(@loop_src,'') <> ''
	BEGIN
		SET @mst_loop_cnt =  @mst_loop_cnt + 1
		SET @tmp_column = ''
		-- @tmp_column에 개별ROW값이 기록되어 있음
		SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
		-- OPTION (BY INDEX)
		-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
		SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
		IF @mst_loop_cnt = 1 BEGIN
					--SET @v_dSql +='?????????????????' + char(10)
				SET @v_dSql += [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM')+char(10)
		END
		ELSE BEGIN
				--SET @v_dSql +='?????????????????' + char(10)
				SET @v_dSql +=',' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM')+char(10)
		END
	END-- end of @mst_loop_cnt < @max_loop_cnt

  --SET @v_dSql += '
  --{
  --              var list=$data.dimension;
  --              var sql="' + char(10)
  --
  --          		if(list.size() > 0){
  --          			for(var i = 0; i < list.size(); i++){
  --          				if(i == 0) {
  --          				  sql+= list[i].DIM_COL_NM;
  --          				} else {
  --          					SET @v_dSql += ', " + list[i].DIM_COL_NM;
  --          				}
  --          			}
  --          		}
  --
  --          		sql;
  --          	}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			SET @loop_src = @p_bucket
			--SET @v_dSql += @loop_src + char(10)
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				-- @tmp_column에 개별ROW값이 기록되어 있음
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
				-- OPTION (BY INDEX)
				-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
				SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')

				IF LEN(@p_unit_value) > 1 BEGIN
					IF @p_unit_type = 'H' BEGIN
						SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + ''' THEN A.PLAN_QTY ELSE 0 END) / ' + @p_unit_value + '),0) AS D' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + char(10)
					END ELSE BEGIN
						SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + ''' THEN A.PLAN_QTY ELSE 0 END) / ' + @p_unit_value + '),0) AS D' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE')  + char(10)
 					END
				END
				ELSE  BEGIN
					IF @p_UOM_TYPE = 'B' BEGIN
                        SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + ''' THEN A.PLAN_QTY ELSE 0 END)*10.)/10. ,0) AS D' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + char(10)
					END ELSE BEGIN
                        SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + ''' THEN A.PLAN_QTY ELSE 0 END)),0) AS D' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + char(10)
					END
				END


			END-- end of @mst_loop_cnt < @max_loop_cnt

			  --              if(unitvalue=="") SET @v_dSql += ',ISNULL(CEILING(SUM(PLAN_QTY) / 1),0) AS TOTAL ' + char(10)
  --              else              SET @v_dSql += ',ISNULL(CEILING(SUM(PLAN_QTY) / " + unitvalue + "),0) AS TOTAL ' + char(10)

			IF ISNULL(@p_unit_value,'') ='' BEGIN
				SET @v_dSql += ',ISNULL(CEILING(SUM(PLAN_QTY) / 1),0) AS TOTAL ' + char(10)
			END ELSE BEGIN
				SET @v_dSql += ',ISNULL(CEILING(SUM(PLAN_QTY) / ' + @p_unit_value + '),0) AS TOTAL ' + char(10)
			END

  --SET @v_dSql += '
  --{
  --              var sql="' + char(10)
  --              var list       = $data.bucket;
  --              var unittype   = $data.UNIT_TYPE;
  --              var unitvalue  = $data.UNIT_VALUE;
  --          		var roundPoint = "0' + char(10)
  --
  --              if(list.size()>0) {
  --                for(var i=0;i<list.size();i++) {
  --                  var buckettype = list[i].TYPE;
  --                  if(unitvalue.length > 0) {
  --    							  if(unittype=="H") {
  --    								  SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''''" + list[i].VALUE + "'''' THEN A.PLAN_QTY ELSE 0 END) / " + unitvalue + "),0) AS " + list[i].COL_NM + " ' + char(10)
  --    							  } else {
  --    								  SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''''" + list[i].VALUE + "'''' THEN A.PLAN_QTY ELSE 0 END) / " + unitvalue + "),0) AS " + list[i].COL_NM + " ' + char(10)
  --    							  }
  --                  }
  --                  else {
  --                    if($data.UOM_TYPE=="B") {
  --                      SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''''" + list[i].VALUE + "'''' THEN A.PLAN_QTY ELSE 0 END)*10.)/10. ,0) AS " + list[i].COL_NM + " ' + char(10)
  --                    } else {
  --                      SET @v_dSql += '      ,ISNULL(CEILING(SUM(CASE WHEN A.PLAN_DATE = ''''" + list[i].VALUE + "'''' THEN A.PLAN_QTY ELSE 0 END)),0) AS " + list[i].COL_NM + " ' + char(10)
  --                    }
  --                  }
  --                }
  --              }
  --
  --              sql;
  --            }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --              var sql="' + char(10)
  --
  --              if(unitvalue=="") SET @v_dSql += ',ISNULL(CEILING(SUM(PLAN_QTY) / 1),0) AS TOTAL ' + char(10)
  --              else              SET @v_dSql += ',ISNULL(CEILING(SUM(PLAN_QTY) / " + unitvalue + "),0) AS TOTAL ' + char(10)
  --
  --              sql;
  --            }

  --'


  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
	SET @loop_src = @p_bucket
	--SET @v_dSql += @loop_src + char(10)
	SET @mst_loop_cnt = 0
	SET @max_loop_cnt = 0
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단

	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
		SET @mst_loop_cnt =  @mst_loop_cnt + 1
		SET @tmp_column = ''
		-- @tmp_column에 개별ROW값이 기록되어 있음
		SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
		-- OPTION (BY INDEX)
		-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
		SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')

		SET @v_dSql += '      ,ISNULL(MAX(CASE WHEN A.PLAN_DATE = ''' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') + ''' THEN A.MEMO ELSE NULL END), NULL) AS M' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','_DATE') +  char(10)
	END-- end of @mst_loop_cnt < @max_loop_cnt  --SET @v_dSql += '


  --{
  --              var sql = "' + char(10)
  --              var list = $data.bucket;
  --
  --              if(list.size()>0) {
  --                for(var i=0;i<list.size();i++) {
  --                  SET @v_dSql += '      ,ISNULL(MAX(CASE WHEN A.PLAN_DATE = ''''" + list[i].VALUE + "'''' THEN A.MEMO ELSE NULL END), NULL) AS M" + list[i].VALUE + " ' + char(10)
  --                }
  --              }
  --
  --              sql;
  --            }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

	SET @loop_src = @p_dimension
	--SET @v_dSql += @loop_src + char(10)
	SET @mst_loop_cnt = 0
	SET @max_loop_cnt = 0
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단
	IF @max_loop_cnt > 0 AND isnull(@loop_src,'') <> '' BEGIN
		SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @max_loop_cnt-1)
		SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
		--SET @v_dSql += @tmp_column + char(10)
		SET @v_dSql += ',CASE WHEN '+[dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM')+' IS NULL THEN ''TOTAL'' ELSE ''DATA'' END AS GRID_TYPE ' + char(10)
	END


	 --        select @v_dSql as [QUERY_VALUE]
  --RETURN 0
  --SET @v_dSql += '
  --{
  --              var sql="' + char(10)
  --              var list=$data.dimension;
  --              var lsize=list.size()-1;
  --
  --              sql=",CASE WHEN "+list[lsize].DIM_COL_NM+" IS NULL THEN ''''TOTAL'''' ELSE ''''DATA'''' END AS GRID_TYPE ' + char(10)
  --              sql;
  --            }

  --'
  SET @v_dSql += '            , A.COMPANY_ID'+char(10)
  SET @v_dSql += '            , A.INSTANCE_ID'+char(10)
  SET @v_dSql += '      FROM   MAIN A'+char(10)

    SET @v_dSql += '      GROUP BY'+char(10)

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @loop_src = @p_dimension
	--SET @v_dSql += @loop_src + char(10)
	SET @mst_loop_cnt = 0
	SET @max_loop_cnt = 0
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단

	WHILE @mst_loop_cnt < @max_loop_cnt  AND ISNULL(@loop_src,'') <> ''
	BEGIN
		SET @mst_loop_cnt =  @mst_loop_cnt + 1
		SET @tmp_column = ''
		-- @tmp_column에 개별ROW값이 기록되어 있음
		SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
		-- OPTION (BY INDEX)
		-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
		SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
		IF @mst_loop_cnt = 1 BEGIN
					
				SET @v_dSql += [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM')
		END
		ELSE BEGIN
				SET @v_dSql +=',' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM')
		END
	END-- end of @mst_loop_cnt < @max_loop_cnt

  --SET @v_dSql += '
  --{
  --        				var sql="' + char(10)
  --        				var dim = $data.dimension;
  --
  --        				for(var i = 0; i < dim.size(); i++) {
  --        					if(i == 0) {
  --          					SET @v_dSql += '" + dim[i].DIM_COL_NM + "' + char(10)
  --        					} else {
  --        						SET @v_dSql += '," + dim[i].DIM_COL_NM + "' + char(10)
  --        					}
  --        				}
  --
  --        				sql;
  --        			}

  --'
  SET @v_dSql += '			        ,A.COMPANY_ID'+char(10)
  SET @v_dSql += '			        ,A.INSTANCE_ID'+char(10)

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @loop_src = @p_dimension
	--SET @v_dSql += @loop_src + char(10)
	SET @mst_loop_cnt = 0
	SET @max_loop_cnt = 0
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@loop_src, '!') -- 프로시저 LOOP 길이를 판단
	IF ISNULL(@loop_src,'') <> '' BEGIN
	  SET @v_dSql += '      ORDER BY'+char(10)
	END
	WHILE @mst_loop_cnt < @max_loop_cnt AND ISNULL(@loop_src,'') <> ''
	BEGIN
		SET @mst_loop_cnt =  @mst_loop_cnt + 1
		SET @tmp_column = ''
		-- @tmp_column에 개별ROW값이 기록되어 있음
		SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @loop_src,'!', @mst_loop_cnt)
				
		-- OPTION (BY INDEX)
		-- # 문자가 ROW 내의 컬럼값을 구분하는 문자임 컬럼:값 형식의 튜플로 기록되어 있음
		SET @_max_length = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, '#')
		IF @mst_loop_cnt = 1 BEGIN
					
				SET @v_dSql += '(CASE WHEN A.' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM') + ' IS NULL THEN 1 ELSE 2 END), ' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM')+  char(10)
		END
		ELSE BEGIN
				SET @v_dSql +=',(CASE WHEN A.' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM') + ' IS NULL THEN 1 ELSE 2 END), ' + [dbo].[SCM_ARR_SPL_KEY_VALUE_ENTITY]( @tmp_column,@_max_length,'#','DIM_COL_NM') + char(10)
		END
	END-- end of @mst_loop_cnt < @max_loop_cnt


  --SET @v_dSql += '
  --{
  --        				var sql="' + char(10)
  --        				var dim = $data.dimension;
  --
  --        				for(var i = 0; i < dim.size(); i++) {
  --        					if(i == 0) {
  --        					  SET @v_dSql += '(CASE WHEN A." + dim[i].DIM_COL_NM + " IS NULL THEN 1 ELSE 2 END), " + dim[i].DIM_COL_NM + "' + char(10)
  --        					} else {
  --        					  SET @v_dSql += ',(CASE WHEN A." + dim[i].DIM_COL_NM + " IS NULL THEN 1 ELSE 2 END), " + dim[i].DIM_COL_NM + "' + char(10)
  --        					}
  --        				}
  --
  --        				sql;
  --        			}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --      var param = $data.param;
  --      $data.querySet1 = $jdbc.queryList("FP01624","find_FP01624",param);
  --
  --}

  --'
  			  			  --select @v_dSql as [QUERY_VALUE]
  --RETURN 0
  --select @p_sys_type as [QUERY_VALUE]
  --RETURN 0
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
      exec PR_UI_SQL_LOG 'PR_UI_FP01624_FIND_FP01624',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP01624_FIND_FP01624',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
