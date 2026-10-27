
--CREATE
CREATE
PROCEDURE [dbo].[PR_UI_FP00599_AMEND_INFO]
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
/** 프로그램 ID   : PR_UI_FP00599_AMEND_INFO												  **/
/** 프로그램 명   : Procedure PR_UI_FP00599_AMEND_INFO										  **/
/** 설 명         : P in-out 수량 조회                                                        **/
/** Version       : 1.5.0(Auto)                                                               **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2023-06-01     leejsthira2      Initial Setting								              **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599_AMEND_INFO
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00599_FIND_FP00599'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_item_name nvarchar(max) = ''
  DECLARE @p_prod_type nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_week_info nvarchar(max) = ''
  DECLARE @p_month_info nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  --DECLARE @p_operation_lt nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_prodtype_id nvarchar(max) = ''
  DECLARE @p_cate_info nvarchar(max) = ''
  DECLARE @p_cell_group nvarchar(max) = ''
  DECLARE @p_amend_table nvarchar(max) = ''
  DECLARE @p_amend_sales_table nvarchar(max) = ''
  DECLARE @p_AMEND_CUTOFF_BOH_TABLE nvarchar(max) = ''
  DECLARE @p_amend_util_table nvarchar(max) = ''
  DECLARE @p__save_auth nvarchar(max) = ''
  DECLARE @p__non_auth nvarchar(max) = ''



  DECLARE @v_plan_date nvarchar(max)
  DECLARE @v_master_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_item_name nvarchar(max)
  DECLARE @v_prod_type nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_week_info nvarchar(max)
  DECLARE @v_month_info nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  --DECLARE @v_operation_lt nvarchar(max)
  --DECLARE @_amend_table nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_prodtype_id nvarchar(max)
  DECLARE @v_cate_info nvarchar(max)
  DECLARE @v_cell_group nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  DECLARE @v__non_auth nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  --DECLARE @opt_0plan_date nvarchar(max)
  --DECLARE @opt_1plan_date nvarchar(max)
  ----DECLARE @opt_2site_id nvarchar(max)
  ----DECLARE @opt_3operation_id nvarchar(max)
  ----DECLARE @opt_4top_item_id nvarchar(max)
  --DECLARE @opt_5item_id nvarchar(max)
  ----DECLARE @opt_6site_id nvarchar(max)
  ----DECLARE @opt_7operation_id nvarchar(max)
  ----DECLARE @opt_8top_item_id nvarchar(max)
  --DECLARE @opt_9item_id nvarchar(max)
  ----DECLARE @opt_10site_id nvarchar(max)
  --DECLARE @opt_11item_name nvarchar(max)
  ----DECLARE @opt_12site_id nvarchar(max)
  --DECLARE @opt_13operation_id nvarchar(max)
  ----DECLARE @opt_14site_id nvarchar(max)
  --DECLARE @opt_15operation_id nvarchar(max)
  --DECLARE @opt_16master_id nvarchar(max)
  --DECLARE @opt_17master_id nvarchar(max)
  --DECLARE @opt_18master_id nvarchar(max)
  ----DECLARE @opt_19site_id nvarchar(max)
  --DECLARE @opt_20operation_id nvarchar(max)
  --DECLARE @opt_21top_item_id nvarch
  DECLARE @dbg_txt NVARCHAR(MAX) = ''
  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
      SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
		SET @dbg_txt += @tmp_column
		SET @dbg_txt += @p_bucket_from
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
		--SET @dbg_txt += @tmp_column
		--SET @dbg_txt += @p_bucket_to
    --END ELSE IF @tmp_column = 'BASIS_START_TIME' BEGIN
		--SET @dbg_txt += @tmp_column
		--SET @dbg_txt += [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
  --  END ELSE IF @tmp_column = 'PRODTYPE_ID' BEGIN
		--SET @dbg_txt += @tmp_column
		--SET @dbg_txt += [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_NAME' BEGIN
      SET @p_item_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
      SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PROTYPE_ID' BEGIN
      SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
      SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
      SET @p_cell_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
      SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
		SET @dbg_txt += @tmp_column
		SET @dbg_txt += @p_month_info
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
      SET @p_amend_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'AMEND_SALES_TABLE' BEGIN
      SET @p_amend_sales_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'AMEND_CUTOFF_BOH_TABLE' BEGIN
      SET @p_AMEND_CUTOFF_BOH_TABLE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'AMEND_UTIL_TABLE' BEGIN
      SET @p_amend_util_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);

    --END ELSE IF @tmp_column = 'OPERATION_LT' BEGIN
    --  SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PRODTYPE_ID' BEGIN
      SET @p_prodtype_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
      SET @p_cate_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END

  END
  
  --SET @v_amend_table  = @p_amend_table 
  SET @v_plan_date ='''' + @p_plan_date + ''''
  SET @v_master_id ='''' + @p_master_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  --SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_item_name ='''' + @p_item_name + ''''
  SET @v_prod_type ='''' + @p_prod_type + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_week_info ='''' + @p_week_info + ''''
  SET @v_month_info ='''' + @p_month_info + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_factory_id ='''' + @p_factory_id + ''''
  --SET @v_operation_lt ='''' + @p_operation_lt + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_prodtype_id ='''' + @p_prodtype_id + ''''
  SET @v_cate_info ='''' + @p_cate_info + ''''
  SET @v_cell_group ='''' + @p_cell_group + ''''
  SET @v__non_auth ='''' + @p__non_auth + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''


  SET @v_dSql = ''

  SET @v_dSql += 'SELECT A.* '+char(10)
  SET @v_dSql += '     , ISNULL(B.IN_QTY, 0) AS IN_QTY, ISNULL(B.OUT_QTY, 0) AS OUT_QTY, ISNULL(B.CELL_IN_QTY, 0) AS CELL_IN_QTY, ISNULL(B.CELL_OUT_QTY, 0) AS CELL_OUT_QTY '+char(10)
  SET @v_dSql += '     , ISNULL(B.WPP_IN_QTY, 0) AS WPP_IN_QTY, ISNULL(B.WPP_OUT_QTY, 0) AS WPP_OUT_QTY, ISNULL(B.WPP_CELL_IN_QTY, 0) AS WPP_CELL_IN_QTY, ISNULL(B.WPP_CELL_OUT_QTY, 0) AS WPP_CELL_OUT_QTY '+char(10)
  SET @v_dSql += '     , ISNULL(B.MPP_IN_QTY, 0) AS MPP_IN_QTY, ISNULL(B.MPP_OUT_QTY, 0) AS MPP_OUT_QTY, ISNULL(B.MPP_CELL_IN_QTY, 0) AS MPP_CELL_IN_QTY, ISNULL(B.MPP_CELL_OUT_QTY, 0) AS MPP_CELL_OUT_QTY '+char(10)
  SET @v_dSql += 'FROM ( '+char(10)
					-- p 품번 기준으로 입력가능한 날짜까지의 셋을 가져온다.
  SET @v_dSql += '	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '		 , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID '+char(10)
  SET @v_dSql += '		 , B.YYYYMMDD AS PLAN_DATE '+char(10)
  SET @v_dSql += '	FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK), TH_UIS_CAL B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '	WHERE  A.INSTANCE_ID  = ''' + @p_instance_id + ''' '+char(10)
  SET @v_dSql += '	AND    A.FP_PLAN_ID   = ''' + @p_plan_id + ''' '+char(10)
  SET @v_dSql += '	AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' '+char(10)
  SET @v_dSql += '	AND    B.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' '+char(10)
  SET @v_dSql += '	AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)  '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
  SET @v_dSql += ') A '+char(10)
  SET @v_dSql += 'LEFT OUTER JOIN ( '+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '		 , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID '+char(10)
  SET @v_dSql += '		 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE '+char(10)
  SET @v_dSql += '		 , A.IN_QTY, A.OUT_QTY, A.CELL_IN_QTY, A.CELL_OUT_QTY '+char(10)
  SET @v_dSql += '		 , A.WPP_IN_QTY, A.WPP_OUT_QTY, A.WPP_CELL_IN_QTY, A.WPP_CELL_OUT_QTY '+char(10)
  SET @v_dSql += '		 , A.MPP_IN_QTY, A.MPP_OUT_QTY, A.MPP_CELL_IN_QTY, A.MPP_CELL_OUT_QTY '+char(10)
  SET @v_dSql += '	FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK) '+char(10)
  SET @v_dSql += '	WHERE  A.INSTANCE_ID  = ''' + @p_instance_id + ''' '+char(10)
  SET @v_dSql += '	AND    A.FP_PLAN_ID   = ''' + @p_plan_id + ''' '+char(10)
  SET @v_dSql += '	AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' '+char(10)
  SET @v_dSql += '	AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)  '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
  SET @v_dSql += ') B '+char(10)
  SET @v_dSql += 'ON  1=1 '+char(10)
  SET @v_dSql += 'AND A.COMPANY_ID      = B.COMPANY_ID '+char(10)
  SET @v_dSql += 'AND A.DIVISION_ID     = B.DIVISION_ID '+char(10)
  SET @v_dSql += 'AND A.SITE_ID         = B.SITE_ID '+char(10)
  SET @v_dSql += 'AND A.PLANT_ID        = B.PLANT_ID '+char(10)
  SET @v_dSql += 'AND A.FACTORY_ID      = B.FACTORY_ID '+char(10)
  SET @v_dSql += 'AND A.OPERATION_ID    = B.OPERATION_ID '+char(10)
  SET @v_dSql += 'AND A.LINE_ID         = B.LINE_ID '+char(10)
  SET @v_dSql += 'AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += 'AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE '+char(10)
  SET @v_dSql += 'AND A.MARKET          = B.MARKET '+char(10)
  SET @v_dSql += 'AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID '+char(10)
  SET @v_dSql += 'AND A.ITEM_ID         = B.ITEM_ID '+char(10)
  SET @v_dSql += 'AND A.PLAN_DATE       = B.PLAN_DATE '+char(10)
  SET @v_dSql += 'ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '	   , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID '+char(10)
  SET @v_dSql += '	   , A.PLAN_DATE '+char(10)

  IF @p_sys_type = 'SQL'
  BEGIN
    DECLARE @log_id integer=0
	exec @log_id = PR_UI_SQL_LOG 'PR_UI_FP00599_AMEND_INFO',  @p_user_id,'','',@v_dSql,'sql',@runstart, @runend
	select query_value from TH_UIS_SQL_LOG WITH( NOLOCK)  where prog_id = 'PR_UI_FP00599_AMEND_INFO' and JOB_TYPE = 'sql' and INST_SEQ = @log_id
	 ORDER BY QUERY_SEQ ASC
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00599_AMEND_INFO',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00599_AMEND_INFO',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END

