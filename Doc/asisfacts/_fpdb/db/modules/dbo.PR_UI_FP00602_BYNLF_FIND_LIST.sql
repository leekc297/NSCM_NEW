CREATE PROCEDURE [dbo].[PR_UI_FP00602_BYNLF_FIND_LIST]
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
/** 프로그램 ID   : PR_UI_FP00602_BYNLF_FIND_LIST                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_BYNLF_FIND_LIST                                                                          **/
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
/** 2021-04-13     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_BYNLF_FIND_LIST
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_BYNLF_FIND_LIST'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_fp_plan_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_market nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_week_info nvarchar(max) = ''
  DECLARE @p_month_info nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_categoryinfo nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_plan_date nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_fp_plan_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_market nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_week_info nvarchar(max)
  DECLARE @v_month_info nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_categoryinfo nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0instance_id nvarchar(max)
  DECLARE @opt_1instance_id nvarchar(max)
  DECLARE @opt_2item_id nvarchar(max)
  DECLARE @opt_3item_id nvarchar(max)
  DECLARE @opt_4plan_date nvarchar(max)
  DECLARE @opt_5item_id nvarchar(max)
  DECLARE @opt_6item_id nvarchar(max)
  DECLARE @opt_7division_id nvarchar(max)
  DECLARE @opt_8item_id nvarchar(max)
  DECLARE @opt_9item_id nvarchar(max)
  DECLARE @opt_10item_id nvarchar(max)
  DECLARE @opt_11item_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FP_PLAN_ID' BEGIN
      SET @p_fp_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MARKET' BEGIN
      SET @p_market =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
      SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
      SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CATEGORYINFO' BEGIN
      SET @p_categoryinfo =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_plan_date ='''' + @p_plan_date + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_fp_plan_id ='''' + @p_fp_plan_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_market ='''' + @p_market + ''''
  SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_week_info ='''' + @p_week_info + ''''
  SET @v_month_info ='''' + @p_month_info + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_categoryinfo ='''' + @p_categoryinfo + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0instance_id = ''
  END ELSE BEGIN
    SET @opt_0instance_id = 'i'
  END
  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1instance_id = ''
  END ELSE BEGIN
    SET @opt_1instance_id = 'i'
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2item_id = ''
  END ELSE BEGIN
    SET @opt_2item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_id = ''
  END ELSE BEGIN
    SET @opt_3item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_plan_date)
  IF @STRLEN< 1  BEGIN
    SET @opt_4plan_date = ''
  END ELSE BEGIN
    SET @opt_4plan_date = 'i'
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5item_id = ''
  END ELSE BEGIN
    SET @opt_5item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6item_id = ''
  END ELSE BEGIN
    SET @opt_6item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7division_id = ''
  END ELSE BEGIN
    SET @opt_7division_id = 'i'
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8item_id = ''
  END ELSE BEGIN
    SET @opt_8item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9item_id = ''
  END ELSE BEGIN
    SET @opt_9item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10item_id = ''
  END ELSE BEGIN
    SET @opt_10item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11item_id = ''
  END ELSE BEGIN
    SET @opt_11item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END


  -- FP00602_byNLF find_List  
  SET @v_dSql = ''
  SET @v_dSql += '      WITH STOCK_T AS ('+char(10)
  SET @v_dSql += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                   , A.OPERATION_ID, A.LOCATION, A.ITEM_ID'+char(10)
  SET @v_dSql += '                   , SUM(BOH_QTY) AS BOH_QTY, SUM(BOH_CELL_QTY) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '            FROM	('+char(10)
  SET @v_dSql += '						  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '			                   , A.OPERATION_ID, A.LOCATION, A.ITEM_ID'+char(10)
  SET @v_dSql += '			                   , A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '			                   , SUM(A.QTY) AS BOH_QTY'+char(10)
  SET @v_dSql += '			                   , ROUND(( SUM(A.QTY) / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, CONVERT(DATE,'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')) ) ,0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '			              FROM ('+char(10)
  SET @v_dSql += '									SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '											, A.OPERATION_ID, A.LOCATION'+char(10)
  SET @v_dSql += '											, A.ITEM_ID, A.TOP_ITEM_ID, 0 AS QTY'+char(10)
  SET @v_dSql += '									FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '									WHERE  A.INSTANCE_ID     ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '									AND    A.FP_PLAN_ID      ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '									AND    A.DIVISION_ID     ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '									AND    A.SITE_ID         ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '									AND    A.PLANT_ID        ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '									AND    A.FACTORY_ID      ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '									AND    A.OPERATION_ID    ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '									AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '									AND    A.ITEM_ID      ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '									UNION ALL'+char(10)
  SET @v_dSql += '									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '											, A.OPERATION_ID, A.LOCATION'+char(10)
  SET @v_dSql += '											, A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY'+char(10)
  SET @v_dSql += '									FROM   FP_AMEND_CUTOFF_BOH_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '									WHERE  A.INSTANCE_ID     ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '									AND    A.FP_PLAN_ID      ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '									AND    A.DIVISION_ID     ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '									AND    A.SITE_ID         ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '									AND    A.PLANT_ID        ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '									AND    A.FACTORY_ID      ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '									AND    A.OPERATION_ID    ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '									AND    A.ITEM_ID      ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '			              ) A'+char(10)
  SET @v_dSql += '			              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '			                     , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '					) A'+char(10)
  SET @v_dSql += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '			         , A.OPERATION_ID, A.LOCATION, A.ITEM_ID'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '       -- P'+char(10)
  SET @v_dSql += '      , MAIN_P AS ('+char(10)
  SET @v_dSql += '      	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '      		   , ISNULL(D.LOCATION,''-'') AS LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '      		   , B.LINE_ID, B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      		   , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '      		   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      				var sql="";
  --      				var list = $data.bucket;
  --      				var weekInfo  = $data.WEEK_INFO;
  --  				    var monthInfo = $data.MONTH_INFO;
  --
  --      				if(list.size() > 0) {
  --      					for(var i = 0; i < list.size(); i++) {
  --      					  sql+="      		, SUM(CASE WHEN A.PLAN_DATE = ''''" + list[i].VALUE + "'''' THEN ( CASE WHEN A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE THEN ( CASE WHEN C.MEASURE_ID = ''''CELL'''' THEN A.CELL_OUT_QTY ELSE A.OUT_QTY END ) ELSE 0 END ) ELSE 0 END) AS D" + i + "_QTY \r\n";
  --      					  sql+="      		--, NULL AS D" + i + "_COLOR \r\n";
  --      					}
  --      				}
  --      			}

  --'
  SET @v_dSql += '      		   , C.CATEGORY_ID, C.CATEGORY_NAME, C.MEASURE_ID, C.MEASURE_NAME, C.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '      		   , ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '      		   , ''P'' AS PSI'+char(10)
  SET @v_dSql += '      	FROM'+char(10)
  SET @v_dSql += '      		('+char(10)
  SET @v_dSql += '	      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '	      			   , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '	      			   , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '	      			   , A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '	      			   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '	      			   , A.OUT_QTY, A.CELL_OUT_QTY'+char(10)
  SET @v_dSql += '	      		FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      		WHERE  A.INSTANCE_ID     ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '	      		AND    A.FP_PLAN_ID      ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '	      		AND    A.DIVISION_ID     ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '	      		AND    A.SITE_ID         ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '	      		AND    A.PLANT_ID        ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '	      		AND    A.FACTORY_ID      ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '	      		AND    A.OPERATION_ID    ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '	      		AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '	      		AND    A.ITEM_ID      ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '	      		AND    ISNULL(A.OUT_QTY,0)>0'+char(10)
  SET @v_dSql += '      		) A'+char(10)
  SET @v_dSql += '	      	LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '		      		-- fix factor :  PLANT_ID, TOP_ITEM_ID, ITEM_ID, MARKET, PRODUCTION_TYPE, NICK_NAME'+char(10)
  SET @v_dSql += '	      		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '	      		FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      		WHERE  1=1'+char(10)
  SET @v_dSql += '	      		AND    A.DIVISION_ID  ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '	      		AND    A.SITE_ID      ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '	      		AND    A.PLANT_ID     ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '	      		AND    A.FACTORY_ID   ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '	      		AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '	      		AND    A.ITEM_ID      ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '	      		AND    A.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '	      		AND    A.PRIORITY IN (1,2,3,4,5,6,7,8)'+char(10)
  SET @v_dSql += '	      		AND    A.MONTH BETWEEN SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ',1,6) AND SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += ',1,6)'+char(10)
  SET @v_dSql += '	      	) B'+char(10)
  SET @v_dSql += '	      	ON  A.COMPANY_ID      = B.COMPANY_ID'+char(10)
  SET @v_dSql += '	      	AND A.DIVISION_ID     = B.DIVISION_ID'+char(10)
  SET @v_dSql += '	      	AND A.SITE_ID         = B.SITE_ID'+char(10)
  SET @v_dSql += '	      	AND A.PLANT_ID        = B.PLANT_ID'+char(10)
  SET @v_dSql += '	      	AND A.FACTORY_ID      = B.FACTORY_ID'+char(10)
  SET @v_dSql += '	      	AND A.OPERATION_ID    = B.OPERATION_ID'+char(10)
  SET @v_dSql += '	      	AND A.ITEM_ID         = B.ITEM_ID'+char(10)
  SET @v_dSql += '	      	--AND A.LINE_ID         = B.LINE_ID'+char(10)
  SET @v_dSql += '	      	--AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '	      	INNER JOIN ('+char(10)
  SET @v_dSql += '	      		SELECT *'+char(10)
  SET @v_dSql += '	      		FROM ('+char(10)
  SET @v_dSql += '	      			SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '	      			UNION ALL'+char(10)
  SET @v_dSql += '	      			SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '	      		) BB'+char(10)
  SET @v_dSql += '	      		WHERE CATEGORY_ID <> ''X'''+char(10)
  SET @v_dSql += '	      	) C'+char(10)
  SET @v_dSql += '	      	ON 1=1'+char(10)
  SET @v_dSql += '	      	LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      	ON     A.COMPANY_ID     = D.COMPANY_ID'+char(10)
  SET @v_dSql += '	      	AND    A.DIVISION_ID    = D.DIVISION_ID'+char(10)
  SET @v_dSql += '	      	AND    A.SITE_ID        = D.SITE_ID'+char(10)
  SET @v_dSql += '	      	AND    A.PLANT_ID       = D.PLANT_ID'+char(10)
  SET @v_dSql += '	      	AND    A.FACTORY_ID     = D.FACTORY_ID'+char(10)
  SET @v_dSql += '	      	AND    A.OPERATION_ID   = D.OPERATION_ID'+char(10)
  SET @v_dSql += '	      	AND    B.LINE_ID        = D.LINE_ID'+char(10)
  SET @v_dSql += '	      	AND    B.ELECTRODE_TYPE = D.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '	      	AND    D.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '      		   , ISNULL(D.LOCATION,''-''), A.OPERATION_ID'+char(10)
  SET @v_dSql += '      		   , B.LINE_ID, B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      		   , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '      		   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '      		   , C.CATEGORY_ID, C.CATEGORY_NAME, C.MEASURE_ID, C.MEASURE_NAME, C.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , MAIN_S AS ('+char(10)
  SET @v_dSql += '	          -- S : builing, location, production type, market'+char(10)
  SET @v_dSql += '	          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '	          		, ''-'' AS LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '      		   		, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      		   		, A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '	        		, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --	        				var sql="";
  --	        				var list = $data.bucket;
  --	        				var weekInfo = $data.WEEK_INFO;
  --	        				var monthInfo = $data.MONTH_INFO;
  --
  --	        				if(list.size() > 0) {
  --		        				for(var i = 0; i < list.size(); i++) {
  --				                    sql+="               , A.D" + i + "_QTY \r\n";
  --				        		}
  --	        				}
  --	        			}

  --'
  SET @v_dSql += '					, A.CATEGORY_ID, A.CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '      		   		, ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '      		   		, ''S'' AS PSI'+char(10)
  SET @v_dSql += '	          FROM ('+char(10)
  SET @v_dSql += '		              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '		                   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '		                   , A.OPERATION_ID'+char(10)
  SET @v_dSql += '		                   , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '		                   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '		                   , ''S'' AS PSI'+char(10)
  SET @v_dSql += '		                   , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '		                   , NULL AS ELECTRODE_TYPE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --		            				var sql="";
  --		            				var list = $data.bucket;
  --		            				var weekInfo  = $data.WEEK_INFO;
  --		        				    var monthInfo = $data.MONTH_INFO;
  --
  --		            				if(list.size() > 0) {
  --		            				  	for(var i = 0; i < list.size(); i++) {
  --		                        			sql+="                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN A.SALES_QTY ELSE 0 END) AS D" + i + "_QTY \r\n";
  --		            					}
  --		            				}
  --		            			}

  --'
  SET @v_dSql += '		            	   , '''' AS CATEGORY_NAME'+char(10)
  SET @v_dSql += '		                   , ''S'' AS CATEGORY_ID, 10 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '		              FROM   ('+char(10)
  SET @v_dSql += '				                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '				                       , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '				                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '				                       , A.OPERATION_ID'+char(10)
  SET @v_dSql += '				                       , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '				                       , NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '				                       , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '				                       , ''S'' AS PSI'+char(10)
  SET @v_dSql += '				                       , A.LINE_ID'+char(10)
  SET @v_dSql += '				                       , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '				                       , A.PLAN_DATE'+char(10)
  SET @v_dSql += '				                       , A.SALES_QTY'+char(10)
  SET @v_dSql += '				                  FROM   FP_AMEND_PLAN_CELL_SALES_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				                  WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '				                  AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '				                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '				                  AND    ISNULL(A.SALES_QTY,0) > 0'+char(10)
  SET @v_dSql += '				                  AND    A.DIVISION_ID     ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.SITE_ID         ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.PLANT_ID        ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.FACTORY_ID      ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.OPERATION_ID    ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '				                  UNION ALL'+char(10)
  SET @v_dSql += '				                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '				                       , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '				                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '				                       , A.OPERATION_ID'+char(10)
  SET @v_dSql += '				                       , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '				                       , NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '				                       , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '				                       , ''S'' AS PSI'+char(10)
  SET @v_dSql += '				                       , A.LINE_ID'+char(10)
  SET @v_dSql += '				                       , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '				                       , A.PLAN_DATE'+char(10)
  SET @v_dSql += '				                       , 0 AS SALES_QTY'+char(10)
  SET @v_dSql += '				                  FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				                  WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '				                  AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '				                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '				                  AND    A.DIVISION_ID     ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.SITE_ID         ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.PLANT_ID        ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.FACTORY_ID      ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.OPERATION_ID    ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '						      	  AND    A.OUT_QTY <> 0'+char(10)
  SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '		              		) A'+char(10)
  SET @v_dSql += '	      		              INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				              ON     A.PLAN_DATE    = E.DT'+char(10)
  SET @v_dSql += '			              WHERE  1=1'+char(10)
  SET @v_dSql += '			              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '			                     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '			                     , A.OPERATION_ID'+char(10)
  SET @v_dSql += '			                     , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '			                     , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , MAIN_I AS ('+char(10)
  SET @v_dSql += '			SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '          			, ''-'' AS LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '          			, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      		   		, A.ITEM_ID, NULL AS TOP_ITEM_ID'+char(10)
  SET @v_dSql += '	        		, NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo  = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				 if(list.size() > 0) {
  --							for(var i = 0; i < list.size(); i++) {
  --								sql+="               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''''" + list[i].VALUE + "'''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''''" + $data.PLAN_DATE + "'''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''''I'''' THEN A.EOH_QTY \r\n";
  --								sql+="               																																							WHEN B.CATEGORY_ID = ''''I_CELL'''' THEN A.CELL_EOH_QTY \r\n";
  --								sql+="               																																							ELSE 0 END)ELSE 0 END) AS D" + i + "_QTY \r\n";
  --							}
  --						}
  --        			}

  --'
  SET @v_dSql += '        	  		, B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_ID AS MEASURE_ID, B.MEASURE_NAME AS MEASURE_NAME, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '      		   		, ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '      		   		, ''I'' AS PSI'+char(10)
  SET @v_dSql += '          FROM   ('+char(10)
  SET @v_dSql += '          			SELECT AAA.COMPANY_ID, AAA.DIVISION_ID, AAA.SITE_ID, AAA.PLANT_ID'+char(10)
  SET @v_dSql += '							, AAA.TOP_ITEM_ID, AAA.ITEM_ID'+char(10)
  SET @v_dSql += '							, AAA.OPERATION_ID'+char(10)
  SET @v_dSql += '							, AAA.FACTORY_ID, AAA.LOCATION'+char(10)
  SET @v_dSql += '							, AAA.PLAN_DATE, AAA.PLAN_WEEK, AAA.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '							, AAA.BOH_QTY, AAA.BOH_CELL_QTY'+char(10)
  SET @v_dSql += '							, AAA.EOH_QTY'+char(10)
  SET @v_dSql += '							, AAA.CELL_EOH_QTY --( AAA.EOH_QTY / dbo.FN_GET_REQ_QTY_MODEL(AAA.PLANT_ID, AAA.TOP_ITEM_ID, AAA.ITEM_ID, AAA.PLAN_DATE) ) AS CELL_EOH_QTY'+char(10)
  SET @v_dSql += '					FROM ('+char(10)
  SET @v_dSql += '					              SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID'+char(10)
  SET @v_dSql += '					                   , AA.TOP_ITEM_ID, AA.ITEM_ID'+char(10)
  SET @v_dSql += '					                   , AA.OPERATION_ID'+char(10)
  SET @v_dSql += '					                   , AA.FACTORY_ID, AA.LOCATION'+char(10)
  SET @v_dSql += '					                   , AA.PLAN_DATE, AA.ISO_YYYYWW AS PLAN_WEEK, AA.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '					                   , D.BOH_QTY, D.BOH_CELL_QTY'+char(10)
  SET @v_dSql += '					                   , CASE WHEN AA.PLAN_DATE = CONVERT(DATE,'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ') THEN (D.BOH_QTY - SALES_QTY + OUT_QTY) ELSE (0 - SALES_QTY + OUT_QTY) END AS EOH_QTY'+char(10)
  SET @v_dSql += '					                   , CASE WHEN AA.PLAN_DATE = CONVERT(DATE,'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ') THEN (D.BOH_CELL_QTY - CELL_SALES_QTY + CELL_OUT_QTY) ELSE (0 - CELL_SALES_QTY + CELL_OUT_QTY) END AS CELL_EOH_QTY'+char(10)
  SET @v_dSql += '					              FROM ('+char(10)
  SET @v_dSql += '							                 SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '							                       , NULL AS TOP_ITEM_ID --A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '							                       , A.ITEM_ID'+char(10)
  SET @v_dSql += '							                       , A.OPERATION_ID'+char(10)
  SET @v_dSql += '							                       , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '							                       , E.DT AS PLAN_DATE --A.PLAN_DATE'+char(10)
  SET @v_dSql += '							                       , E.ISO_YYYYWW'+char(10)
  SET @v_dSql += '							                       , E.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '							                       , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.OUT_QTY ELSE 0 END)    AS OUT_QTY'+char(10)
  SET @v_dSql += '							                       , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.CELL_OUT_QTY ELSE 0 END)    AS CELL_OUT_QTY'+char(10)
  SET @v_dSql += '												   , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.SALES_QTY ELSE 0 END)  AS SALES_QTY'+char(10)
  SET @v_dSql += '							                       , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.CELL_SALES_QTY ELSE 0 END)  AS CELL_SALES_QTY'+char(10)
  SET @v_dSql += '							                  FROM ('+char(10)
  SET @v_dSql += '								                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '								                           , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '								                           , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '								                           , A.OPERATION_ID'+char(10)
  SET @v_dSql += '								                           , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '								                           , NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '								                           , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '								                           , ''I'' AS PSI'+char(10)
  SET @v_dSql += '								                           , A.LINE_ID'+char(10)
  SET @v_dSql += '								                           , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '								                           , A.PLAN_DATE'+char(10)
  SET @v_dSql += '								                           , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' THEN A.OUT_QTY ELSE 0 END AS OUT_QTY'+char(10)
  SET @v_dSql += '								                           , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' THEN A.OUT_QTY / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE) ELSE 0 END AS CELL_OUT_QTY'+char(10)
  SET @v_dSql += '								                           , 0 AS SALES_QTY'+char(10)
  SET @v_dSql += '								                           , 0 AS CELL_SALES_QTY'+char(10)
  SET @v_dSql += '								                      FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								                      WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '									                  AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '									                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '									                  AND    A.DIVISION_ID     ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.SITE_ID         ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.PLANT_ID        ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.FACTORY_ID      ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.OPERATION_ID    ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.OUT_QTY <> 0'+char(10)
  SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '							                      	  UNION ALL'+char(10)
  SET @v_dSql += '									                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '									                           , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '									                           , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '									                           , A.OPERATION_ID'+char(10)
  SET @v_dSql += '									                           , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '									                           , NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '									                           , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '									                           , ''I'' AS PSI'+char(10)
  SET @v_dSql += '									                           , A.LINE_ID'+char(10)
  SET @v_dSql += '									                           , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '									                           , A.PLAN_DATE'+char(10)
  SET @v_dSql += '									                           , 0 AS OUT_QTY'+char(10)
  SET @v_dSql += '									                           , 0 AS CELL_OUT_QTY'+char(10)
  SET @v_dSql += '									                           , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' THEN ISNULL(A.SALES_QTY,0) ELSE 0 END AS SALES_QTY'+char(10)
  SET @v_dSql += '									                           , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' THEN ISNULL(A.SALES_QTY,0) / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE) ELSE 0 END AS CELL_SALES_QTY'+char(10)
  SET @v_dSql += '								                      FROM   FP_AMEND_PLAN_CELL_SALES_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								                      WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '									                  AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '									                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '									                  AND    A.DIVISION_ID     ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.SITE_ID         ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.PLANT_ID        ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.FACTORY_ID      ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.OPERATION_ID    ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '											      	  AND    A.SALES_QTY > 0'+char(10)
  SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '							                  ) A'+char(10)
  SET @v_dSql += '							                  INNER JOIN ('+char(10)
  SET @v_dSql += '										                 SELECT A.* , B.YYYYMMDD AS WEEK_ENDDATE'+char(10)
  SET @v_dSql += '										                 FROM TH_UIS_CAL A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										                    , TH_UIS_CAL B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										                 WHERE 1=1'+char(10)
  SET @v_dSql += '										                 AND CONVERT(VARCHAR,A.DT,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '										                 AND A.ISO_YYYYWW = B.ISO_YYYYWW'+char(10)
  SET @v_dSql += '										                 AND B.DAY_SEQ = ''1'''+char(10)
  SET @v_dSql += '								              ) E'+char(10)
  SET @v_dSql += '								              --ON     AA.PLAN_DATE    = E.DT'+char(10)
  SET @v_dSql += '								              ON    1=1'+char(10)
  SET @v_dSql += '						              WHERE 1=1'+char(10)
  SET @v_dSql += '                   	                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '					                         --, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '					                         , A.ITEM_ID'+char(10)
  SET @v_dSql += '					                         , A.OPERATION_ID'+char(10)
  SET @v_dSql += '					                         , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '					                         , E.DT --A.PLAN_DATE'+char(10)
  SET @v_dSql += '					                         , E.ISO_YYYYWW'+char(10)
  SET @v_dSql += '				                       		 , E.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '			              ) AA'+char(10)
  SET @v_dSql += '			              LEFT OUTER HASH JOIN STOCK_T D'+char(10)
  SET @v_dSql += '			              ON     AA.COMPANY_ID   = D.COMPANY_ID'+char(10)
  SET @v_dSql += '			              AND    AA.DIVISION_ID  = D.DIVISION_ID'+char(10)
  SET @v_dSql += '			              AND    AA.SITE_ID      = D.SITE_ID'+char(10)
  SET @v_dSql += '			              AND    AA.PLANT_ID     = D.PLANT_ID'+char(10)
  SET @v_dSql += '			              AND    AA.FACTORY_ID   = D.FACTORY_ID'+char(10)
  SET @v_dSql += '			              AND    AA.OPERATION_ID = D.OPERATION_ID'+char(10)
  SET @v_dSql += '			              AND    AA.LOCATION     = D.LOCATION'+char(10)
  SET @v_dSql += '			              AND    AA.ITEM_ID      = D.ITEM_ID'+char(10)
  SET @v_dSql += '			             -- AND    AA.TOP_ITEM_ID  = D.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '					) AAA'+char(10)
  SET @v_dSql += '					WHERE 1=1'+char(10)
  SET @v_dSql += '          		) A'+char(10)
  SET @v_dSql += '          		INNER JOIN ('+char(10)
  SET @v_dSql += '          				SELECT ''I'' AS CATEGORY_ID, ''I'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '        				UNION ALL'+char(10)
  SET @v_dSql += '        				SELECT ''I_CELL'' AS CATEGORY_ID, ''I'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '    	    	) B'+char(10)
  SET @v_dSql += '			    ON 1=1'+char(10)
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '          			, A.OPERATION_ID'+char(10)
  SET @v_dSql += '          			, A.ITEM_ID'+char(10)
  SET @v_dSql += '                 	, B.CATEGORY_NAME'+char(10)
  SET @v_dSql += '                 	, B.CATEGORY_ID'+char(10)
  SET @v_dSql += '                 	, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                 	, B.MEASURE_ID, B.MEASURE_NAME'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      -- UTIL, OFF'+char(10)
  SET @v_dSql += '      , CAPA_VALUE AS ('+char(10)
  SET @v_dSql += '      	SELECT A.*, B.LINE_NAME, ISNULL(B.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '      	FROM ('+char(10)
  SET @v_dSql += '	      		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '	      				 ,'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AS PLAN_DATE'+char(10)
  SET @v_dSql += '	      				 , NULL AS OFF_TIME, NULL AS SETUP_TIME, NULL AS UTILIZATION'+char(10)
  SET @v_dSql += '	      		FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      		WHERE  1=1'+char(10)
  SET @v_dSql += '	      		AND    A.DIVISION_ID  ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '	      		AND    A.SITE_ID      ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '	      		AND    A.PLANT_ID     ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '	      		AND    A.FACTORY_ID   ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '	      		AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '	      		AND    A.ITEM_ID      ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '	      		AND    A.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '	      		AND    A.PRIORITY IN (1,2,3,4,5,6,7,8)'+char(10)
  SET @v_dSql += '	      		AND    A.MONTH BETWEEN SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ',1,6) AND SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += ',1,6)'+char(10)
  SET @v_dSql += '	      		UNION ALL'+char(10)
  SET @v_dSql += '	      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '	      				 , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '	      				 , SUM(A.OFF_TIME) AS OFF_TIME'+char(10)
  SET @v_dSql += '	      				 , SUM(A.SETUP_TIME) AS SETUP_TIME'+char(10)
  SET @v_dSql += '	      				 , AVG(A.UTILIZATION) AS UTILIZATION'+char(10)
  SET @v_dSql += '	      		FROM   FP_AMEND_PLAN_CELL_UTIL_R A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      		WHERE  A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '	      		AND    A.FP_PLAN_ID  ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '	      		AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '	      		AND    A.DIVISION_ID  ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '	      		AND    A.SITE_ID      ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '	      		AND    A.PLANT_ID     ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '	      		AND    A.FACTORY_ID   ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '	      		AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '	      		AND    EXISTS ('+char(10)
  SET @v_dSql += '				      			SELECT 1'+char(10)
  SET @v_dSql += '				      			FROM   SCM_ITEM_LINE_ASSIGN_M AAA WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				      			WHERE  1=1'+char(10)
  SET @v_dSql += '				      			AND    AAA.COMPANY_ID     = A.COMPANY_ID'+char(10)
  SET @v_dSql += '				      			AND    AAA.DIVISION_ID    = A.DIVISION_ID'+char(10)
  SET @v_dSql += '				      			AND    AAA.SITE_ID        = A.SITE_ID'+char(10)
  SET @v_dSql += '				      			AND    AAA.PLANT_ID       = A.PLANT_ID'+char(10)
  SET @v_dSql += '				      			AND    AAA.FACTORY_ID     = A.FACTORY_ID'+char(10)
  SET @v_dSql += '				      			AND    AAA.OPERATION_ID   = A.OPERATION_ID'+char(10)
  SET @v_dSql += '				      			AND    AAA.LINE_ID        = A.LINE_ID'+char(10)
  SET @v_dSql += '				      			AND    AAA.ELECTRODE_TYPE = A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '				      			AND    AAA.DIVISION_ID    ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '				      			AND    AAA.SITE_ID        ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '				      			AND    AAA.PLANT_ID       ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '				      			AND    AAA.FACTORY_ID     ='+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += '				      			AND    AAA.OPERATION_ID   ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '				      			AND    AAA.ITEM_ID        ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '				      			AND    AAA.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '				      			AND    AAA.PRIORITY IN (1,2,3,4,5,6,7,8)'+char(10)
  SET @v_dSql += '				      			AND    AAA.MONTH BETWEEN SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ',1,6) AND SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += ',1,6)'+char(10)
  SET @v_dSql += '	      					)'+char(10)
  SET @v_dSql += '      		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, CONVERT(VARCHAR, A.PLAN_DATE, 112)'+char(10)
  SET @v_dSql += '      	) A'+char(10)
  SET @v_dSql += '      	LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      	ON  A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      	AND A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      	AND A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '      	AND A.PLANT_ID       = B.PLANT_ID'+char(10)
  SET @v_dSql += '      	AND A.FACTORY_ID     = B.FACTORY_ID'+char(10)
  SET @v_dSql += '      	AND A.OPERATION_ID   = B.OPERATION_ID'+char(10)
  SET @v_dSql += '      	AND A.LINE_ID        = B.LINE_ID'+char(10)
  SET @v_dSql += '      	AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      	AND B.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT A.*'+char(10)
  SET @v_dSql += '      		 , ISNULL(B.NICK_NAME, '''') AS NICK_NAME'+char(10)
  SET @v_dSql += '			 , ISNULL(C.NICK_NAME, '''') AS MODEL_NICK_NAME'+char(10)
  SET @v_dSql += '			 , ISNULL(B.ITEM_TYPE, '''') AS ITEM_TYPE'+char(10)
  SET @v_dSql += '			 , K.BOH_QTY AS BOH'+char(10)
  SET @v_dSql += '			 , K.BOH_CELL_QTY AS BOH_CELL'+char(10)
  SET @v_dSql += '           	 , CASE WHEN ''RELEASE'' = ''PRE'' THEN ''Y'''+char(10)
  SET @v_dSql += '                    WHEN I.DIVISION_ID IS NOT NULL THEN ''Y'''+char(10)
  SET @v_dSql += '                    WHEN D.PRODUCTION_TYPE IS NULL'+char(10)
  SET @v_dSql += '                         OR (A.OPERATION_ID IN (''A3000'',''A9000'') AND H.MARKET IS NULL AND ('+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += ' <> ''KR_CELL_A2''))'+char(10)
  SET @v_dSql += '                    	 OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'') THEN ''N'' ELSE ''Y'' END AS EDIT_YN'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '      	SELECT * FROM MAIN_S'+char(10)
  SET @v_dSql += '      	UNION ALL'+char(10)
  SET @v_dSql += '      	SELECT * FROM MAIN_P'+char(10)
  SET @v_dSql += '      	UNION ALL'+char(10)
  SET @v_dSql += '      	SELECT * FROM MAIN_I'+char(10)
  SET @v_dSql += '      	-- Capa'+char(10)
  SET @v_dSql += '      	UNION ALL'+char(10)
  SET @v_dSql += '      	SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '      			, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      		 	,'+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += ' AS ITEM_ID, NULL AS TOP_ITEM_ID'+char(10)
  SET @v_dSql += '      		 	, NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --    				var sql="";
  --    				var list = $data.bucket;
  --    				var weekInfo  = $data.WEEK_INFO;
  --    				var monthInfo = $data.MONTH_INFO;
  --
  --    				if(list.size() > 0) {
  --    					for(var i = 0; i < list.size(); i++) {
  --    					  sql+="      		 , CEILING(AVG(CASE WHEN A.PLAN_DATE = ''''" + list[i].VALUE + "'''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D" + i + "_QTY \r\n";
  --    					}
  --    				}
  --    			}

  --'
  SET @v_dSql += '      		 , ''CAPA'' AS CATEGORY_ID, ''Load(%)'' AS CATEGORY_NAME, NULL AS MEASURE_ID, ''Load(%)'' AS MEASURE_NAME, 3000 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '      		 , ''TOTAL'' AS DATA_TYPE, ''P'' AS PSI'+char(10)
  SET @v_dSql += '      	FROM   CAPA_VALUE A'+char(10)
  SET @v_dSql += '      	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LINE_NAME'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '		LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,'+char(10)
  SET @v_dSql += '						(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '							  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '							  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,'+char(10)
  SET @v_dSql += '						ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '				FROM	SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SET @v_dSql += '						SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				WHERE	A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  SET @v_dSql += '				AND		A.DIVISION_ID ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '				AND		A.SITE_ID	  ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '				AND		A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '				AND		A.ITEM_ID	  ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '		) B'+char(10)
  SET @v_dSql += '		ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '		AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '		AND A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '		AND A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '		LEFT OUTER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
  SET @v_dSql += '		AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
  SET @v_dSql += '		AND    A.SITE_ID        = C.SITE_ID'+char(10)
  SET @v_dSql += '		AND    A.TOP_ITEM_ID	= C.ITEM_ID'+char(10)
  SET @v_dSql += '		AND    C.ACTIVE_FLAG	= ''Y'''+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '      	SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '      	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      	WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'''+char(10)
  SET @v_dSql += '      	AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --  				var sql = "";
  --  				var sMst = $data.INSTANCE_ID;
  --
  --  				if(sMst == "KR_CELL") {
  --  					sql += "UNION ALL \r\n";
  --  					sql += "SELECT DISTINCT A.DIVISION_ID, ''''M/C'''' AS PRODUCTION_TYPE \r\n";
  --  					sql += "FROM   SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) \r\n";
  --  					sql += "ON     A.FACTORY_ID  = B.FACTORY_ID \r\n";
  --  					sql += "AND    B.ACTIVE_FLAG = ''''Y'''' \r\n";
  --  					sql += "WHERE  1=1 \r\n";
  --  					sql += "AND    A.ACTIVE_FLAG = ''''Y'''' \r\n";
  --  					sql += "AND    B.INSTANCE_ID = ''''KR_CELL'''' \r\n";
  --  				}
  --
  --  				sql;
  --  			}

  --'
  SET @v_dSql += '      ) D'+char(10)
  SET @v_dSql += '      ON A.DIVISION_ID = D.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '      AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '	      	SELECT DISTINCT H.*'+char(10)
  SET @v_dSql += '	      	FROM ('+char(10)
  SET @v_dSql += '	      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MARKET, A.ITEM_ID, (CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST'' ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '	      			FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      			WHERE  1=1'+char(10)
  SET @v_dSql += '	      			AND    A.DIVISION_ID ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '	      			AND    A.SITE_ID     ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '	      			AND    A.PLANT_ID    ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '	      			AND	   A.ITEM_ID	 ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '	      			AND	   EXISTS ('+char(10)
  SET @v_dSql += '										SELECT 1'+char(10)
  SET @v_dSql += '										FROM	('+char(10)
  SET @v_dSql += '													SELECT A.DIVISION_ID, A.SHOP_GROUP_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID'+char(10)
  SET @v_dSql += '	      											FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      											WHERE  1=1'+char(10)
  SET @v_dSql += '	      											AND    A.DIVISION_ID ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '									      			AND    A.SITE_ID     ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '									      			AND    A.PLANT_ID    ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '									      			AND	   A.SHOP_GROUP_ID = ''A'''+char(10)
  SET @v_dSql += '	      											GROUP BY A.DIVISION_ID, A.SHOP_GROUP_ID'+char(10)
  SET @v_dSql += '												) SA'+char(10)
  SET @v_dSql += '										WHERE	1=1'+char(10)
  SET @v_dSql += '										AND		A.DIVISION_ID = SA.DIVISION_ID'+char(10)
  SET @v_dSql += '										AND		A.SHOP_GROUP_ID = SA.SHOP_GROUP_ID'+char(10)
  SET @v_dSql += '										AND		A.SCP_PLAN_ID	= SA.SCP_PLAN_ID'+char(10)
  SET @v_dSql += '								  )'+char(10)
  SET @v_dSql += '	      			UNION'+char(10)
  SET @v_dSql += '	      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,'+char(10)
  SET @v_dSql += '' + @v_market+''+char(10)
  SET @v_dSql += ') AS MARKET, A.ITEM_ID, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '	      			FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      			WHERE  1=1'+char(10)
  SET @v_dSql += '	      			AND    A.DIVISION_ID ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '	      			AND    A.SITE_ID     ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '	      			AND    A.PLANT_ID    ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '	      			AND	   A.ITEM_ID	 ='+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '	      			AND    A.DUE_DATE >= (SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112))'+char(10)
  SET @v_dSql += '	      			                      FROM   SCM_FP_PLAN_H KK WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      								            WHERE  PLAN_ID ='+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += ' )'+char(10)
  SET @v_dSql += '	      	) H'+char(10)
  SET @v_dSql += '      ) H'+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID  = H.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID = H.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID     = H.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.PLANT_ID    = H.PLANT_ID'+char(10)
  SET @v_dSql += '      AND A.MARKET      = H.MARKET'+char(10)
  SET @v_dSql += '      AND A.TOP_ITEM_ID = H.ITEM_ID'+char(10)
  SET @v_dSql += '      AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '        	SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS SITE_ID, A.SEGMENT4 AS PLANT_ID, A.SEGMENT5 AS MODEL_ID'+char(10)
  SET @v_dSql += '        	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	WHERE  A.LOOKUP_TYPE_CODE = ''AMEND_VALIDATION_EXCEPTION'''+char(10)
  SET @v_dSql += '        	AND    A.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '        	AND    A.SEGMENT1         ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '      ) I'+char(10)
  SET @v_dSql += '      ON  A.DIVISION_ID = I.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID     = I.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.PLANT_ID    = I.PLANT_ID'+char(10)
  SET @v_dSql += '      AND A.TOP_ITEM_ID = I.MODEL_ID'+char(10)
  SET @v_dSql += '      			LEFT OUTER HASH JOIN STOCK_T K'+char(10)
  SET @v_dSql += '				ON     A.COMPANY_ID   = K.COMPANY_ID'+char(10)
  SET @v_dSql += '				AND    A.DIVISION_ID  = K.DIVISION_ID'+char(10)
  SET @v_dSql += '				AND    A.SITE_ID      = K.SITE_ID'+char(10)
  SET @v_dSql += '				AND    A.PLANT_ID     = K.PLANT_ID'+char(10)
  SET @v_dSql += '				AND    A.FACTORY_ID   = K.FACTORY_ID'+char(10)
  SET @v_dSql += '				AND    A.OPERATION_ID = K.OPERATION_ID'+char(10)
  SET @v_dSql += '				AND    A.LOCATION     = K.LOCATION'+char(10)
  SET @v_dSql += '				AND    A.ITEM_ID      = K.ITEM_ID'+char(10)
  SET @v_dSql += '      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '			 , (CASE WHEN A.PSI = ''S'' THEN 10 WHEN A.PSI = ''P'' THEN 20 ELSE 99 END)'+char(10)
  SET @v_dSql += '			 , (CASE WHEN A.TOP_ITEM_ID IS NOT NULL THEN A.TOP_ITEM_ID ELSE ''ZZZZZ'' END)'+char(10)
  SET @v_dSql += '             , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '			 , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '             , A.CATEGORY_ORDER'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param     = $data.param;
  --        var weekInfo  = $jdbc.queryList("FP00602","find_WeekCnt",param);
  --        var monthInfo = $jdbc.queryList("FP00602","find_MonthCnt",param);
  --
  --        param.WEEK_INFO  = weekInfo;
  --        param.MONTH_INFO = monthInfo;
  --
  --        var cateInfo = $data.categoryinfo;
  --        param.CATE_INFO = cateInfo;
  --
  --        $data.querySet1 = $jdbc.queryList("FP00602_byNLF","find_List",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00602_BYNLF_FIND_LIST',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00602_BYNLF_FIND_LIST',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
