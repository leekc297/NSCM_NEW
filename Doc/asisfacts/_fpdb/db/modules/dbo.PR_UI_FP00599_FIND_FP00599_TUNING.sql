CREATE PROCEDURE [dbo].[PR_UI_FP00599_FIND_FP00599_TUNING]
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
/** 프로그램 ID   : PR_UI_FP00599_FIND_FP00599                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00599_FIND_FP00599                                                                        **/
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
/** 2021-03-15     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599_FIND_FP00599
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


--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += '@P_SYS_TYPE=' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_FLAG=' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_GUBUN=' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += '@P_USER_ID=' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += '@in_columns=' +ISNULL(@in_columns,'') +CHAR(10)
--SET @PARAMS += '@in_row=' +ISNULL(@in_row,'') +CHAR(10)

--SELECT @PARAMS AS SQL
--RETURN


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

  --SET @STRLEN = LEN(@p_plan_date)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_0plan_date = ''
  --END ELSE BEGIN
  --  SET @opt_0plan_date = 'i'
  --END
  --SET @STRLEN = LEN(@p_plan_date)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_1plan_date = ''
  --END ELSE BEGIN
  --  SET @opt_1plan_date = 'i'
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_2site_id = ''
  --END ELSE BEGIN
  --  SET @opt_2site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_operation_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_3operation_id = ''
  --END ELSE BEGIN
  --  SET @opt_3operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  --END
  --SET @STRLEN = LEN(@p_top_item_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_4top_item_id = ''
  --END ELSE BEGIN
  --  SET @opt_4top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_top_item_id+')) + ''%'''
  --END
  --SET @STRLEN = LEN(@p_item_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_5item_id = ''
  --END ELSE BEGIN
  --  SET @opt_5item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  --END
 

  -- FP00599 findPlanAmend  

  SET @v_dSql = ''

  SET @v_dSql += '      IF OBJECT_ID(''tempdb..#TblFP_AMEND_PLAN_CELL_H_TEMP'') IS NOT NULL DROP TABLE #TblFP_AMEND_PLAN_CELL_H_TEMP;'+char(10)
  SET @v_dSql += '		SELECT * INTO #TblFP_AMEND_PLAN_CELL_H_TEMP  FROM  ' + @p_amend_table + ' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										                      WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '										                      AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10) 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += '										                      AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '										                      AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 

  SET @v_dSql += '      IF OBJECT_ID(''tempdb..#Tblp_AMEND_CUTOFF_BOH_TABLE_TEMP'') IS NOT NULL DROP TABLE #Tblp_AMEND_CUTOFF_BOH_TABLE_TEMP;'+char(10)
  SET @v_dSql += '		SELECT * INTO #Tblp_AMEND_CUTOFF_BOH_TABLE_TEMP  FROM   '+ @p_AMEND_CUTOFF_BOH_TABLE  +' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								                      WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '								                      AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)


  SET @v_dSql += '      IF OBJECT_ID(''tempdb..#Tblp_p_amend_sales_table_temp'') IS NOT NULL DROP TABLE #Tblp_p_amend_sales_table_temp;'+char(10)
  SET @v_dSql += '		SELECT * INTO #Tblp_p_amend_sales_table_temp  FROM   '+@p_amend_sales_table +' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '												                      WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '												                      AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '												                      AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 

  SET @v_dSql += '      IF OBJECT_ID(''tempdb..#TblFP00599_TEMP'') IS NOT NULL DROP TABLE #TblFP00599_TEMP;'+char(10)
  SET @v_dSql += '      CREATE TABLE #TblFP00599_TEMP('+char(10)
  SET @v_dSql += '      [CATE_ORDER] [int] NOT NULL   ,'+char(10)
  SET @v_dSql += '      [CATE_NAME] [nvarchar](30) NOT NULL   ,'+char(10)
  SET @v_dSql += '      [CATE_ID] [nvarchar](30) NOT NULL   ,'+char(10)
  SET @v_dSql += '      [MEASURE_ID] [nvarchar](30) NOT NULL   ,'+char(10)
  SET @v_dSql += '      [MEASURE_NAME] [nvarchar](30) NOT NULL'+char(10)
  SET @v_dSql += '      );'+char(10)
  SET @v_dSql += '      insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME, CATE_ID, MEASURE_ID, MEASURE_NAME)'+char(10)
  SET @v_dSql += '      values(20,''MPP(In)''    ,''M_IN_CELL''    ,''CELL''      ,''CELL''     );'+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME, CATE_ID, MEASURE_ID, MEASURE_NAME)		'+char(10)
  SET @v_dSql += '         values (23,''MPP(In)''  ,''M_IN''       ,''UOM''     ,''UOM''            );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (26,''MPP(Out)''    ,''M_OUT_CELL''    ,''CELL''       ,''CELL''  )  ;                  '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (29,''MPP(Out)''  ,''M_OUT''       ,''UOM''      ,''UOM''         );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (32,''WPP(In)''    ,''W_IN_CELL''    ,''CELL''      ,''CELL''     )	;                   '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (35,''WPP(In)''  ,''W_IN''       ,''UOM''     ,''UOM''            )	;			        '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (38,''WPP(Out)''    ,''W_OUT_CELL''    ,''CELL''       ,''CELL''  );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (41,''WPP(Out)''  ,''W_OUT''       ,''UOM''      ,''UOM''         );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (44,''Plan(In)''   ,''P_IN_CELL''    ,''CELL''      ,''CELL''     );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (47,''Plan(In)''  ,''P_IN''        ,''UOM''      ,''UOM''         );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (50,''Plan(Out)''   ,''P_OUT_CELL''    ,''CELL''       ,''CELL''  );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (53,''Plan(Out)''         ,''P_OUT''    ,''UOM'' ,''UOM''  );                           '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (56,''Result''         ,''P_RESULT_CELL''    ,''CELL'' ,''CELL''  );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (59,''Result''    ,''P_RESULT''    ,''UOM''      ,''UOM''         );                    '+char(10)
  SET @v_dSql += ' insert into #TblFP00599_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID, MEASURE_ID, MEASURE_NAME)       '+char(10)
  SET @v_dSql += '         values (60,''Memo''    ,''P_MEMO''    ,''''       ,''''                  );                    '+char(10)


  --SET @v_dSql += @dbg_txt
  --SET @v_dSql += '      -- I : builing, location'+char(10)
  SET @v_dSql += '      WITH MAIN_I AS ('+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '               , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '               , ISNULL(MAX(A.QTY),0) AS BOH_QTY'+char(10)
  SET @v_dSql += '               , ISNULL(MAX(A.BOH_CELL_QTY),0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS MARKET'+char(10)
  SET @v_dSql += '               , ''I'' AS PSI'+char(10)
  SET @v_dSql += '               , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , B.CATEGORY_NAME AS CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  DECLARE @sub_mst_loop_cnt integer = 0
  DECLARE @sub_max_loop_cnt integer = 0
  DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
  DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_4 NVARCHAR(MAX) = '' 

    IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @max_loop_cnt) +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_columns +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_row +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@p_MONTH_INFO +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_MONTH_INFO +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_delimiter +char(10)
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_week_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		

				SET @v_dSql += ', SUM(CASE WHEN A.PLAN_WEEK<=''' + @sub_param_0 + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' +@p_plan_date+''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY' + char(10)
				SET @v_dSql += 'WHEN B.CATEGORY_ID = ''I_CELL'' THEN A.CELL_EOH_QTY ' + char(10)
				--SET @v_dSql += 'WHEN B.CATEGORY_ID = ''P_MEMO'' THEN NULL' + char(10)
				SET @v_dSql += 'ELSE 0 END)ELSE 0 END)ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)

				SET @v_dSql += ', SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)
				SET @v_dSql += 'WHEN B.CATEGORY_ID = ''I_CELL'' THEN A.CELL_EOH_QTY '+ char(10)
				--SET @v_dSql += 'WHEN B.CATEGORY_ID = ''P_MEMO'' THEN NULL '+ char(10)
				SET @v_dSql += 'ELSE 0 END)ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +  char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_bucket,'') <> ''

	--select @v_dSql as [QUERY_VALUE]
	--RETURN 1
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo  = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				 if(list.size() > 0) {
  --							for(var i = 0; i < monthInfo.size(); i++) {
  --								sql+="               , NULL AS M" + i + "\r\n";
  --							}
  --
  --							for(var i = 0; i < weekInfo.size(); i++) {
  --								sql+="               , SUM(CASE WHEN A.PLAN_WEEK<=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''''" + $data.PLAN_DATE + "'''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''''I'''' THEN A.EOH_QTY \r\n";
  --								sql+="               																																							WHEN B.CATEGORY_ID = ''''I_CELL'''' THEN A.CELL_EOH_QTY \r\n";
  --								sql+="               																																							ELSE 0 END)ELSE 0 END)ELSE 0 END) AS W" + i + "\r\n";
  --							}
  --
  --							for(var i = 0; i < list.size(); i++) {
  --								sql+="               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''''" + list[i].VALUE + "'''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''''" + $data.PLAN_DATE + "'''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''''I'''' THEN A.EOH_QTY \r\n";
  --								sql+="               																																							WHEN B.CATEGORY_ID = ''''I_CELL'''' THEN A.CELL_EOH_QTY \r\n";
  --								sql+="               																																							ELSE 0 END)ELSE 0 END) AS D" + i + "\r\n";
  --							}
  --						}
  --        			}

  --'
  SET @v_dSql += '        	   , B.CATEGORY_ID'+char(10)
  SET @v_dSql += '               , B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '        	   , B.MEASURE_ID, B.MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   ('+char(10)
  SET @v_dSql += '          			SELECT AAA.COMPANY_ID, AAA.DIVISION_ID, AAA.SITE_ID, AAA.PLANT_ID'+char(10)
  SET @v_dSql += '							, AAA.TOP_ITEM_ID, AAA.ITEM_ID, AAA.ITEM_TYPE, AAA.NICK_NAME,AAA.CELL_GROUP, AAA.PLM_EC_NO '+char(10)
  SET @v_dSql += '							, AAA.OPERATION_ID'+char(10)
  SET @v_dSql += '							, AAA.FACTORY_ID, AAA.LOCATION'+char(10)
  SET @v_dSql += '							, AAA.PLAN_DATE, AAA.PLAN_WEEK, AAA.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '							, AAA.QTY, AAA.BOH_CELL_QTY'+char(10)
  SET @v_dSql += '							, AAA.EOH_QTY'+char(10)
  SET @v_dSql += '							, ( AAA.EOH_QTY / dbo.FN_GET_REQ_QTY_MODEL(AAA.PLANT_ID, AAA.TOP_ITEM_ID, AAA.ITEM_ID, AAA.PLAN_DATE) ) AS CELL_EOH_QTY'+char(10)
  SET @v_dSql += '					FROM ('+char(10)
  SET @v_dSql += '								              SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID'+char(10)
  SET @v_dSql += '								                   , AA.TOP_ITEM_ID, AA.ITEM_ID, AA.ITEM_TYPE, AA.NICK_NAME,AA.CELL_GROUP, AA.PLM_EC_NO '+char(10)
  SET @v_dSql += '								                   , AA.OPERATION_ID'+char(10)
  SET @v_dSql += '								                   , AA.FACTORY_ID, AA.LOCATION'+char(10)
  SET @v_dSql += '								                   , AA.PLAN_DATE, AA.ISO_YYYYWW AS PLAN_WEEK, AA.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '								                   , D.QTY, D.BOH_CELL_QTY'+char(10)
  SET @v_dSql += '								                   , CASE WHEN AA.PLAN_DATE = CONVERT(DATE,'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ') THEN (D.QTY - SALES_QTY + OUT_QTY) ELSE (0 - SALES_QTY + OUT_QTY) END AS EOH_QTY'+char(10)
  SET @v_dSql += '								              FROM ('+char(10)
  SET @v_dSql += '										                 SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '										                       , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.ITEM_TYPE,''-'') AS ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME,J.CELL_GROUP, A.PLM_EC_NO'+char(10)
  SET @v_dSql += '										                       , A.OPERATION_ID'+char(10)
  SET @v_dSql += '										                       , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '										                       , E.DT AS PLAN_DATE ' + char(10) --A.PLAN_DATE'+char(10)
  SET @v_dSql += '										                       , E.ISO_YYYYWW'+char(10)
  SET @v_dSql += '										                       , E.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '										                       , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.OUT_QTY ELSE 0 END)    AS OUT_QTY'+char(10)
  SET @v_dSql += '										                       , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.SALES_QTY ELSE 0 END)  AS SALES_QTY'+char(10)
  SET @v_dSql += '										                  FROM ('+char(10)
  SET @v_dSql += '										                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '										                           , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '										                           , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '										                           , A.OPERATION_ID'+char(10)
  SET @v_dSql += '										                           , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '										                           , NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '										                           , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '										                           , ''I'' AS PSI'+char(10)
  SET @v_dSql += '										                           , A.LINE_ID'+char(10)
  SET @v_dSql += '										                           , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '										                           , A.PLAN_DATE'+char(10)
  SET @v_dSql += '										                           , A.PLM_EC_NO '+char(10)
  SET @v_dSql += '										                           , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' THEN A.OUT_QTY ELSE 0 END AS OUT_QTY'+char(10)
  SET @v_dSql += '										                           , 0 AS SALES_QTY'+char(10) 
  SET @v_dSql += '										                      FROM  #TblFP_AMEND_PLAN_CELL_H_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										                      WHERE  1 = 1 '+char(10)
  --SET @v_dSql += '										                      FROM  ' + @p_amend_table + ' A WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '										                      WHERE  A.INSTANCE_ID  ='+char(10)
  --SET @v_dSql += '' + @v_master_id+''+char(10)
  --SET @v_dSql += '										                      AND    A.FP_PLAN_ID   ='+char(10)
  --SET @v_dSql += '' + @v_plan_id+''+char(10)
  ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  ----SET @v_dSql += '
  ----{
  ----										                        var sql="";
  ----										                        var sDiv = $data.DIVISION_LT;
  ----										                        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  ----										                        sql;
  ----										                      }

  ----'
  ----SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  --	  --print @v_dSql
  ----RETURN 200
  ----SET @v_dSql += '
  ----{
  ----										                        var sql="";
  ----										                        var sPlt = $data.PLANT_LT;
  ----										                        sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  ----										                        sql;
  ----										                      }

  ----'
  ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  ----SET @v_dSql += '
  ----{
  ----										                        var sql="";
  ----										                        var sFac = $data.FACTORY_LT;
  ----										                        sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  ----										                        sql;
  ----										                      }

  ----'
  ----SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
  ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  ----SET @v_dSql += '
  ----{
  ----										                        var sql="";
  ----										                        var sOper = $data.OPERATION_LT;
  ----
  ----										                        if(sOper!=null && sOper!="") {
  ----										                          sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
  ----										                        }
  ----
  ----										                        sql;
  ----										                      }

  ----'
  ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  ----SET @v_dSql += '
  ----{
  ----										                        var sql="";
  ----										                        var sLine = $data.LINE_LT;
  ----										                        sql="AND    A.LINE_ID IN (" + sLine + ")";
  ----										                        sql;
  ----										                      }

  ----'
  --SET @v_dSql += '										                      AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  --SET @v_dSql += '' + @v_bucket_from+''+char(10)
  --SET @v_dSql += ' AND'+char(10)
  --SET @v_dSql += '' + @v_bucket_to+''+char(10)
  --SET @v_dSql += '										                      AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)'+char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
--SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
  --SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '										                      UNION ALL'+char(10)
  SET @v_dSql += '												                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '												                           , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '												                           , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '												                           , A.OPERATION_ID'+char(10)
  SET @v_dSql += '												                           , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '												                           , NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '												                           , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '												                           , ''I'' AS PSI'+char(10)
  SET @v_dSql += '												                           , A.LINE_ID'+char(10)
  SET @v_dSql += '												                           , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '												                           , A.PLAN_DATE'+char(10)
  SET @v_dSql += '												                           , A.PLM_EC_NO '+char(10)
  SET @v_dSql += '												                           , 0 AS OUT_QTY'+char(10)
  SET @v_dSql += '												                           , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' THEN ISNULL(A.SALES_QTY,0) ELSE 0 END AS SALES_QTY'+char(10)
  SET @v_dSql += '												                      FROM   #Tblp_p_amend_sales_table_temp A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '												                      WHERE   1 = 1'+char(10)
  --SET @v_dSql += '												                      FROM   '+@p_amend_sales_table +' A WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '												                      WHERE  A.INSTANCE_ID  ='+char(10)
  --SET @v_dSql += '' + @v_master_id+''+char(10)
  --SET @v_dSql += '												                      AND    A.FP_PLAN_ID   ='+char(10)
  --SET @v_dSql += '' + @v_plan_id+''+char(10)
  --SET @v_dSql += '												                      AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  --SET @v_dSql += '' + @v_bucket_from+''+char(10)
  --SET @v_dSql += ' AND'+char(10)
  --SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '												                      AND    A.SALES_QTY > 0'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
--  --{
--  --												                        var sql="";
--  --												                        var sDiv = $data.DIVISION_LT;
--  --												                        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
--  --												                        sql;
--  --												                      }

--  --'
--  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
--  --SET @v_dSql += '
--  --{
--  --												                        var sql="";
--  --												                        var sPlt = $data.PLANT_LT;
--  --												                        sql="AND    A.PLANT_ID IN (" + sPlt + ")";
--  --												                        sql;
--  --												                      }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
-- SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
-- --SET @v_dSql += '
--  --{
--  --												                        var sql="";
--  --												                        var sFac = $data.FACTORY_LT;
--  --												                        sql="AND    A.FACTORY_ID IN (" + sFac + ")";
--  --												                        sql;
--  --												                      }

--  --'
--  --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
--  --SET @v_dSql += '
--  --{
--  --												                        var sql="";
--  --												                        var sOper = $data.OPERATION_LT;
--  --
--  --												                        if(sOper!=null && sOper!="") {
																	  
--  --												                          sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
--  --												                        }
--  --
--  --												                        sql;
--  --												                      }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
 
--  --SET @v_dSql += '
--  --{
--  --												                        var sql="";
--  --												                        var sLine = $data.LINE_LT;
--  --												                        sql="AND    A.LINE_ID IN (" + sLine + ")";
--  --												                        sql;
--  --												                      }

--  --'
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
--SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
  --SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '								                  ) A'+char(10)
  SET @v_dSql += '								                  INNER JOIN ('+char(10)
  SET @v_dSql += '												              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,'+char(10)
  SET @v_dSql += '												                     A.ITEM_ID,'+char(10)
  SET @v_dSql += '												                     (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '												                     	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '												                     	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,'+char(10)
  SET @v_dSql += '												                     ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '												              FROM	 SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SET @v_dSql += '												                	 SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '												              WHERE	 A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  -- print @v_dSql
  --RETURN 201
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --{
  --										                        var sql="";
  --										                        var sDiv = $data.DIVISION_LT;
  --										                        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --										                        sql;
  --										                      }

  --'
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
--SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '										          ) B'+char(10)
  SET @v_dSql += '										          ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '										          AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '										          AND A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '										          AND A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '								                  INNER JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								                  ON     A.COMPANY_ID   = C.COMPANY_ID'+char(10)
  SET @v_dSql += '								                  AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
  SET @v_dSql += '								                  AND    A.SITE_ID      = C.SITE_ID'+char(10)
  SET @v_dSql += '								                  AND    A.TOP_ITEM_ID  = C.ITEM_ID'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_item_name)) + char(10) 
  --SET @v_dSql += ' ' +@opt_11item_name +' '+''+char(10)--AND   C.NICK_NAME LIKE '%' + RTRIM(LTRIM(#ITEM_NAME#)) + '%'
  SET @v_dSql += '								                  INNER JOIN ('+char(10)
  SET @v_dSql += '											                 SELECT A.* , B.YYYYMMDD AS WEEK_ENDDATE'+char(10)
  SET @v_dSql += '											                 FROM TH_UIS_CAL A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '											                    , TH_UIS_CAL B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '											                 WHERE 1=1'+char(10)
  SET @v_dSql += '											                 AND CONVERT(VARCHAR,A.DT,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '											                 AND A.ISO_YYYYWW = B.ISO_YYYYWW'+char(10)
  SET @v_dSql += '											                 AND B.DAY_SEQ = ''1'''+char(10)
  SET @v_dSql += '									              ) E'+char(10)
  --SET @v_dSql += '									              --ON     AA.PLAN_DATE    = E.DT'+char(10)
  SET @v_dSql += '									              ON    1=1'+char(10)
  SET @v_dSql += 'INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)'+char(10)
  SET @v_dSql += 'ON  A.COMPANY_ID  = J.COMPANY_ID'+char(10)
  SET @v_dSql += 'AND A.DIVISION_ID = J.DIVISION_ID'+char(10)
  SET @v_dSql += 'AND A.SITE_ID     = J.SITE_ID'+char(10)
  SET @v_dSql += 'AND A.TOP_ITEM_ID = J.ITEM_ID'+char(10)
  SET @v_dSql += '									              WHERE 1=1'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LK', @p_cell_group)) + char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)
  --SET @v_dSql += '
  --{
  --                                  var sql="";
  --                                  var sProdType = $data.PRODTYPE_LT;
  --                                  if(sProdType != null && sProdType != ""){
  --                                    sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")";
  --                                  }
  --                                  sql;
  --                                }

  --'
  SET @v_dSql += '								                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '								                         , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.ITEM_TYPE,''-''), ISNULL(C.NICK_NAME,''-''),J.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '								                         , A.OPERATION_ID'+char(10)
  SET @v_dSql += '								                         , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '								                         , E.DT '+char(10) --A.PLAN_DATE'+char(10)
  SET @v_dSql += '								                         , E.ISO_YYYYWW'+char(10)
  SET @v_dSql += '							                       		 , E.WEEK_ENDDATE'+char(10)
  SET @v_dSql += '						              ) AA'+char(10)
  SET @v_dSql += '						              LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '							                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '							                       , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '							                       , SUM(A.QTY) AS QTY'+char(10)
  SET @v_dSql += '							                       , ROUND(( SUM(A.QTY) / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, CONVERT(DATE,'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')) ) ,0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '							                  FROM ('+char(10)
  SET @v_dSql += '								                      SELECT DISTINCT'+char(10)
  SET @v_dSql += '								                             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '								                           , A.OPERATION_ID, A.LOCATION, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '								                           , A.ITEM_ID, A.TOP_ITEM_ID, 0 AS QTY'+char(10)
  SET @v_dSql += '										                      FROM  #TblFP_AMEND_PLAN_CELL_H_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										                      WHERE  1 = 1 '+char(10)
--  SET @v_dSql += '								                      FROM   '+@p_amend_table + ' A WITH(NOLOCK)'+char(10)
--  SET @v_dSql += '								                      WHERE  A.INSTANCE_ID  ='+char(10)
--  SET @v_dSql += '' + @v_master_id+''+char(10)
--  SET @v_dSql += '								                      AND    A.FP_PLAN_ID   ='+char(10)
--  SET @v_dSql += '' + @v_plan_id+''+char(10)
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  -- print @v_dSql
--  --RETURN 202
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
----SET @v_dSql += '
--  --{
--  --								                        var sql="";
--  --								                        var sDiv = $data.DIVISION_LT;
--  --								                        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
--  --								                        sql;
--  --								                      }

--  --'
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
--  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
----SET @v_dSql += '
--  --{
--  --								                        var sql="";
--  --								                        var sPlt = $data.PLANT_LT;
--  --								                        sql="AND    A.PLANT_ID IN (" + sPlt + ")";
--  --								                        sql;
--  --								                      }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  --SET @v_dSql += '
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
--  --{
--  --								                        var sql="";
--  --								                        var sFac = $data.FACTORY_LT;
--  --								                        sql="AND    A.FACTORY_ID IN (" + sFac + ")";
--  --								                        sql;
--  --								                      }

--  --'
--  --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  --SET @v_dSql += '
--    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
--  --{
--  --								                        var sql="";
--  --								                        var sOper = $data.OPERATION_LT;
--  --
--  --								                        if(sOper!=null && sOper!="") {
																  
--  --								                          sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
--  --								                        }
--  --
--  --								                        sql;
--  --								                      }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
 
--  --SET @v_dSql += '
--  --{
--  --								                        var sql="";
--  --								                        var sLine = $data.LINE_LT;
--  --								                        sql="AND    A.LINE_ID IN (" + sLine + ")";
--  --								                        sql;
--  --								                      }

--  --'
--  SET @v_dSql += '								                      AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
--  SET @v_dSql += '' + @v_bucket_from+''+char(10)
--  SET @v_dSql += ' AND'+char(10)
--  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '								                      UNION ALL'+char(10)
  SET @v_dSql += '								                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '								                           , A.OPERATION_ID, A.LOCATION, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '								                           , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY'+char(10)
  SET @v_dSql += '								                      FROM   #Tblp_AMEND_CUTOFF_BOH_TABLE_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								                      WHERE  1 = 1'+char(10)
  --SET @v_dSql += '' + @v_master_id+''+char(10)
  --SET @v_dSql += '								                      FROM   '+ @p_AMEND_CUTOFF_BOH_TABLE  +' A WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '								                      WHERE  A.INSTANCE_ID  ='+char(10)
  --SET @v_dSql += '' + @v_master_id+''+char(10)
  --SET @v_dSql += '								                      AND    A.FP_PLAN_ID   ='+char(10)
  --SET @v_dSql += '' + @v_plan_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)  
--SET @v_dSql += '
  --{
  --								                        var sql="";
  --								                        var sDiv = $data.DIVISION_LT;
  --								                        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --								                        sql;
  --								                      }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
 SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
 --SET @v_dSql += '
  --{
  --								                        var sql="";
  --								                        var sPlt = $data.PLANT_LT;
  --								                        sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --								                        sql;
  --								                      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  --{
  --								                        var sql="";
  --								                        var sFac = $data.FACTORY_LT;
  --								                        sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --								                        sql;
  --								                      }

  --'
  --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  --SET @v_dSql += '
  --{
  --								                        var sql="";
  --								                        var sOper = $data.OPERATION_LT;
  --
  --								                        if(sOper!=null && sOper!="") {
  --								                          sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
  --								                        }
  --
  --								                        sql;
  --								                      }

  --'
  SET @v_dSql += '							                  ) A'+char(10)
  SET @v_dSql += '							                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '							                         , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '						              ) D'+char(10)
  SET @v_dSql += '						              ON     AA.COMPANY_ID   = D.COMPANY_ID'+char(10)
  SET @v_dSql += '						              AND    AA.DIVISION_ID  = D.DIVISION_ID'+char(10)
  SET @v_dSql += '						              AND    AA.SITE_ID      = D.SITE_ID'+char(10)
  SET @v_dSql += '						              AND    AA.PLANT_ID     = D.PLANT_ID'+char(10)
  SET @v_dSql += '						              AND    AA.FACTORY_ID   = D.FACTORY_ID'+char(10)
  SET @v_dSql += '						              AND    AA.OPERATION_ID = D.OPERATION_ID'+char(10)
  SET @v_dSql += '						              AND    AA.LOCATION     = D.LOCATION'+char(10)
  SET @v_dSql += '						              AND    AA.ITEM_ID      = D.ITEM_ID'+char(10)
  SET @v_dSql += '						              AND    AA.TOP_ITEM_ID  = D.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '						              AND    AA.PLM_EC_NO    = D.PLM_EC_NO '+char(10)
  SET @v_dSql += '					) AAA'+char(10)
  SET @v_dSql += '					WHERE 1=1'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          INNER JOIN ('+char(10)
  SET @v_dSql += '          			SELECT ''I'' AS CATEGORY_ID, ''I'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '        				UNION ALL'+char(10)
  SET @v_dSql += '        				SELECT ''I_CELL'' AS CATEGORY_ID, ''I'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '    	    ) B'+char(10)
  SET @v_dSql += '			    ON 1=1'+char(10)
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                 , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                 , B.CATEGORY_NAME'+char(10)
  SET @v_dSql += '                 , B.CATEGORY_ID'+char(10)
  SET @v_dSql += '                 , B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                 , B.MEASURE_ID, B.MEASURE_NAME'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , MAIN_S AS ('+char(10)
  --SET @v_dSql += '          -- S : builing, location, production type, market'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME,J.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '               , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '               , ISNULL(D.QTY,0) AS BOH_QTY'+char(10)
  SET @v_dSql += '               , ISNULL(D.BOH_CELL_QTY,0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '               , A.PSI'+char(10)
  SET @v_dSql += '               , A.LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --   print @v_dSql
  --RETURN 203
  
    IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				if(list.size() > 0) {
  --	        				for(var i = 0; i < monthInfo.size(); i++) {
  --	        					sql+="               , A.M" + i + "\r\n";
  --	        				}
  --
  --	        				for(var i = 0; i < weekInfo.size(); i++) {
  --	                    		sql+="               , A.W" + i + "\r\n";
  --	        				}
  --
  --        					for(var i = 0; i < list.size(); i++) {
  --			                    sql+="               , A.D" + i + "\r\n";
  --			        		}
  --        				}
  --        			}

  --'
  SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , A.MEASURE_ID AS MEASURE_ID, A.MEASURE_NAME AS MEASURE_NAME'+char(10)
  SET @v_dSql += '               , A.DATA_TYPE'+char(10)
  SET @v_dSql += '               , A.S_ROW'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '		              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '		                   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '		                   , A.OPERATION_ID'+char(10)
  SET @v_dSql += '		                   , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '		                   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '		                   , ''S'' AS PSI'+char(10)
  SET @v_dSql += '		                   , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '		                   , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		                   , B.CATEGORY_NAME AS CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
   IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				--SET @v_dSql += '               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				-- @sub_param_0 => MONTH
				-- @sub_param_1 => MONTH_NAME
				-- @sub_param_2 => MONTH_COUNT
				-- @sub_param_3 => M_VALUE

				SET @v_dSql += '               , SUM(CASE WHEN E.YYYYMM =''' + @sub_param_0+ ''' THEN (CASE WHEN B.CATEGORY_ID=''S'' THEN A.SALES_QTY ' + char(10)
				SET @v_dSql += 'WHEN B.CATEGORY_ID=''S_CELL'' THEN A.CELL_SALES_QTY ELSE A.PAST_SALES_QTY '+ char(10)
				--SET @v_dSql += 'WHEN B.CATEGORY_ID=''P_MEMO'' THEN NULL'+ char(10)
				SET @v_dSql += 'END)  ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +  char(10)
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				--SET @v_dSql += '               , A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_week_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				---- @sub_param_0 => WEEK
				---- @sub_param_0 => WEEK_NAME
				---- @sub_param_0 => WEEK_COUNT
				---- @sub_param_0 => W_VALUE
				---- @sub_param_0 => IS_DAY_VIEW		
				SET @v_dSql += '                   , SUM(CASE WHEN E.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''S'' THEN A.SALES_QTY WHEN B.CATEGORY_ID=''S_CELL'' THEN A.CELL_SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +  char(10)
  
				--SET @v_dSql += '               , SUM(CASE WHEN A.PLAN_WEEK<=''' + @sub_param_0 + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' +@p_plan_date+''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY' + char(10)
				--SET @v_dSql += '               																																							WHEN B.CATEGORY_ID = ''I_CELL'' THEN A.CELL_EOH_QTY ' + char(10)
				--SET @v_dSql += '               																																							ELSE 0 END)ELSE 0 END)ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				--SET @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				--SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				-- @sub_param_0 => Date 20210322
				-- @sub_param_0 => Name 2021-03022(M...)
				-- @sub_param_0 => Count 1
				-- @sub_param_0 => Value D0
				--SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_3 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)
				SET @v_dSql += '                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_0 +''' THEN (CASE WHEN B.CATEGORY_ID=''S'' THEN A.SALES_QTY WHEN B.CATEGORY_ID=''S_CELL'' THEN A.CELL_SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)
  		END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

	--	select @v_dSql as [QUERY_VALUE]
	--RETURN 1
  --SET @v_dSql += '
  --{
  --		            				var sql="";
  --		            				var list = $data.bucket;
  --		            				var weekInfo  = $data.WEEK_INFO;
  --		        				    var monthInfo = $data.MONTH_INFO;
  --
  --		            				if(list.size() > 0) {
  --		            				  for(var i = 0; i < monthInfo.size(); i++) {
  --		            				    sql+="               , SUM(CASE WHEN E.YYYYMM =''''" + monthInfo[i].month + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''S'''' THEN A.SALES_QTY WHEN B.CATEGORY_ID=''''S_CELL'''' THEN A.CELL_SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS M" + i + "\r\n";
  --		            				  }
  --
  --		            				  for(var i = 0; i < weekInfo.size(); i++) {
  --		                        sql+="                   , SUM(CASE WHEN E.ISO_YYYYWW=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''S'''' THEN A.SALES_QTY WHEN B.CATEGORY_ID=''''S_CELL'''' THEN A.CELL_SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS W" + i + "\r\n";
  --		            				  }
  --
  --		            					for(var i = 0; i < list.size(); i++) {
  --		                        sql+="                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''S'''' THEN A.SALES_QTY WHEN B.CATEGORY_ID=''''S_CELL'''' THEN A.CELL_SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS D" + i + "\r\n";
  --		            					}
  --		            				}
  --		            			}

  --'
  --SET @STRLEN = LEN(@v_dSql)
  --SELECT @STRLEN as [QUERY_LENGTH]
  --return 1
 --   			select @v_dSql as [QUERY_VALUE]
	--RETURN 1
  SET @v_dSql += '		                   , B.CATEGORY_ID, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '		                   , B.MEASURE_ID, B.MEASURE_NAME'+char(10)
  SET @v_dSql += '		                   , ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '		                   , ROW_NUMBER() OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '		                                        ORDER BY     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, B.CATEGORY_ORDER) AS S_ROW'+char(10)
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
  SET @v_dSql += '				                       , A.PLM_EC_NO '+char(10)
  SET @v_dSql += '				                       , A.SALES_QTY'+char(10)
  SET @v_dSql += '				                       , A.PAST_SALES_QTY'+char(10)
  SET @v_dSql += '				                       , A.CELL_SALES_QTY'+char(10)
    SET @v_dSql += '							FROM   #Tblp_p_amend_sales_table_temp A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								WHERE   1 = 1'+char(10)
  --SET @v_dSql += '				                  FROM   '+@p_amend_sales_table +' A WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '				                  WHERE  A.INSTANCE_ID  ='+char(10)
  --SET @v_dSql += '' + @v_master_id+''+char(10)
  --SET @v_dSql += '				                  AND    A.FP_PLAN_ID   ='+char(10)
  --SET @v_dSql += '' + @v_plan_id+''+char(10)
  --SET @v_dSql += '				                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  --SET @v_dSql += '' + @v_bucket_from+''+char(10)
  --SET @v_dSql += ' AND'+char(10)
  --SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '				                  AND    ( ISNULL(A.SALES_QTY,0) > 0 OR ISNULL(A.PAST_SALES_QTY,0) > 0)'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
--  --{
--  --				                    var sql="";
--  --				                    var sDiv = $data.DIVISION_LT;
--  --				                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
--  --				                    sql;
--  --				                  }

--  --'
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
--  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
--  --SET @v_dSql += '
--  --{
--  --				                    var sql="";
--  --				                    var sPlt = $data.PLANT_LT;
--  --				                    sql="AND    A.PLANT_ID IN (" + sPlt + ")";
--  --				                    sql;
--  --				                  }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  --SET @v_dSql += '
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
--  --{
--  --				                    var sql="";
--  --				                    var sFac = $data.FACTORY_LT;
--  --				                    sql="AND    A.FACTORY_ID IN (" + sFac + ")";
--  --				                    sql;
--  --				                  }

--  --'
--  --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
--  --SET @v_dSql += '
--  --{
--  --				                    var sql="";
--  --				                    var sOper = $data.OPERATION_LT;
--  --
--  --				                    if(sOper!=null && sOper!="") {
														  
--  --				                      sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
--  --				                    }
--  --
--  --				                    sql;
--  --				                  }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--   SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
--   --SET @v_dSql += '
--  --{
--  --				                    var sql="";
--  --				                    var sLine = $data.LINE_LT;
--  --				                    sql="AND    A.LINE_ID IN (" + sLine + ")";
--  --				                    sql;
--  --				                  }

--  --'
--  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
--SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
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
  SET @v_dSql += '				                       , A.PLM_EC_NO '+char(10)
  SET @v_dSql += '				                       , 0 AS SALES_QTY'+char(10)
  SET @v_dSql += '				                       , 0 AS PAST_SALES_QTY'+char(10)
  SET @v_dSql += '				                       , 0 AS CELL_SALES_QTY'+char(10)
  SET @v_dSql += '										                      FROM  #TblFP_AMEND_PLAN_CELL_H_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										                      WHERE  1 = 1 '+char(10)
 -- SET @v_dSql += '				                  FROM   '+@p_amend_table + ' A WITH(NOLOCK)'+char(10)
 -- SET @v_dSql += '				                  WHERE  A.INSTANCE_ID  ='+char(10)
 -- SET @v_dSql += '' + @v_master_id+''+char(10)
 -- SET @v_dSql += '				                  AND    A.FP_PLAN_ID   ='+char(10)
 -- SET @v_dSql += '' + @v_plan_id+''+char(10)
 -- SET @v_dSql += '				                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
 -- SET @v_dSql += '' + @v_bucket_from+''+char(10)
 -- SET @v_dSql += ' AND'+char(10)
 -- SET @v_dSql += '' + @v_bucket_to+''+char(10)
 -- ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
 -- --SET @v_dSql += '
 -- SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
 -- --{
 -- --				                    var sql="";
 -- --				                    var sDiv = $data.DIVISION_LT;
 -- --				                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
 -- --				                    sql;
 -- --				                  }

 -- --'
 -- SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
 -- --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
 -- ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
 -- --SET @v_dSql += '
 -- SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
 -- --{
 -- --				                    var sql="";
 -- --				                    var sPlt = $data.PLANT_LT;
 -- --				                    sql="AND    A.PLANT_ID IN (" + sPlt + ")";
 -- --				                    sql;
 -- --				                  }

 -- --'
 -- ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
 -- --SET @v_dSql += '
 -- SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
 -- --{
 -- --				                    var sql="";
 -- --				                    var sFac = $data.FACTORY_LT;
 -- --				                    sql="AND    A.FACTORY_ID IN (" + sFac + ")";
 -- --				                    sql;
 -- --				                  }

 -- --'
 -- --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
 -- ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
 --   SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
 -- --SET @v_dSql += '
 -- --{
 -- --				                    var sql="";
 -- --				                    var sOper = $data.OPERATION_LT;
 -- --
 -- --				                    if(sOper!=null && sOper!="") {
 -- --				                      sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
 -- --				                    }
 -- --
 -- --				                    sql;
 -- --				                  }

 -- --'
 -- ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
 --    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
 ----SET @v_dSql += '
 -- --{
 -- --				                    var sql="";
 -- --				                    var sLine = $data.LINE_LT;
 -- --				                    sql="AND    A.LINE_ID IN (" + sLine + ")";
 -- --				                    sql;
 -- --				                  }

 -- --'
 -- SET @v_dSql += '				                  AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)'+char(10)
 -- --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
 -- SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
 --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
 --SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '		              ) A'+char(10)
  SET @v_dSql += '      		        INNER JOIN ('+char(10)
  SET @v_dSql += '                				SELECT ''S_CELL'' AS CATEGORY_ID, ''S'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '                				UNION ALL'+char(10)
  SET @v_dSql += '                				SELECT ''S'' AS CATEGORY_ID, ''S'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '                				UNION ALL'+char(10)
  SET @v_dSql += '                				SELECT ''PAST_SALES'' AS CATEGORY_ID, ''S(W-1)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER, '''' AS MEASURE_ID, '''' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '    	            ) B'+char(10)
  SET @v_dSql += '    	            	ON 1=1'+char(10)
  SET @v_dSql += '			              INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			              ON     A.PLAN_DATE    = E.DT'+char(10)
  SET @v_dSql += '			              WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '			              AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '			              AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --{
  --			                var sql="";
  --			                var sDiv = $data.DIVISION_LT;
  --			                sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --			                sql;
  --			              }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  --SET @v_dSql += '
  --{
  --			                var sql="";
  --			                var sPlt = $data.PLANT_LT;
  --			                sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --			                sql;
  --			              }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  --{
  --			                var sql="";
  --			                var sFac = $data.FACTORY_LT;
  --			                sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --			                sql;
  --			              }

  --'
  --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  --SET @v_dSql += '
  --{
  --			                var sql="";
  --			                var sOper = $data.OPERATION_LT;
  --
  --			                if(sOper!=null && sOper!="") {
  --			                  sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
  --			                }
  --
  --			                sql;
  --			              }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
   SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
   --SET @v_dSql += '
  --{
  --			                var sql="";
  --			                var sLine = $data.LINE_LT;
  --			                sql="AND    A.LINE_ID IN (" + sLine + ")";
  --			                sql;
  --			              }

  --'
  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
  --SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  --SET @v_dSql += ' ' +@opt_31prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE = #PROD_TYPE#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)
  --SET @v_dSql += '
  --{
  --                      var sql="";
  --                      var sProdType = $data.PRODTYPE_LT;
  --                      if(sProdType != null && sProdType != ""){
  --                        sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")";
  --                      }
  --                      sql;
  --                    }

  --'
  SET @v_dSql += '			              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '			                     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '			                     , A.OPERATION_ID'+char(10)
  SET @v_dSql += '			                     , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '			                     , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '			                     , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '			                     , B.MEASURE_ID, B.MEASURE_NAME'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          INNER JOIN ('+char(10)
  SET @v_dSql += '              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,'+char(10)
  SET @v_dSql += '                     A.ITEM_ID,'+char(10)
  SET @v_dSql += '                     (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '                     	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '                     	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,'+char(10)
  SET @v_dSql += '                     ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '              FROM	 SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SET @v_dSql += '                	 SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              WHERE	 A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --{
  --                var sql="";
  --                var sDiv = $data.DIVISION_LT;
  --                sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --                sql;
  --              }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '          ) B'+char(10)
  SET @v_dSql += '          ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '          AND A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '          INNER JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON     A.COMPANY_ID   = C.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND    A.SITE_ID      = C.SITE_ID'+char(10)
  SET @v_dSql += '          AND    A.TOP_ITEM_ID  = C.ITEM_ID'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_item_name)) + char(10) 
  --SET @v_dSql += ' ' +@opt_11item_name +' '+''+char(10)--AND   C.NICK_NAME LIKE '%' + RTRIM(LTRIM(#ITEM_NAME#)) + '%'
  SET @v_dSql += '          LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '		              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '		                   , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID, SUM(ISNULL(A.MODIFY_QTY, A.QTY)) AS QTY'+char(10)
  SET @v_dSql += '		                   , ROUND(( SUM(ISNULL(A.MODIFY_QTY, A.QTY)) / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, CONVERT(DATE,'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')) ) ,0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '								                      FROM   #Tblp_AMEND_CUTOFF_BOH_TABLE_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								                      WHERE  1 = 1'+char(10)
  --SET @v_dSql += '		              FROM   '+ @p_AMEND_CUTOFF_BOH_TABLE  +' A WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '		              WHERE  A.INSTANCE_ID  ='+char(10)
  --SET @v_dSql += '' + @v_master_id+''+char(10)
  --SET @v_dSql += '		              AND    A.FP_PLAN_ID   ='+char(10)
  --SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += '		              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '		                     , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '          ) D'+char(10)
  SET @v_dSql += '          ON     A.COMPANY_ID   = D.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID  = D.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND    A.SITE_ID      = D.SITE_ID'+char(10)
  SET @v_dSql += '          AND    A.PLANT_ID     = D.PLANT_ID'+char(10)
  SET @v_dSql += '          AND    A.FACTORY_ID   = D.FACTORY_ID'+char(10)
  SET @v_dSql += '          AND    A.OPERATION_ID = D.OPERATION_ID'+char(10)
  SET @v_dSql += '          AND    A.LOCATION     = D.LOCATION'+char(10)
  SET @v_dSql += '          AND    A.ITEM_ID      = D.ITEM_ID'+char(10)
  SET @v_dSql += '          AND    A.TOP_ITEM_ID  = D.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '          AND    A.PLM_EC_NO    = D.PLM_EC_NO '+char(10)
  SET @v_dSql += '          INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON     A.COMPANY_ID  = J.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID = J.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND    A.SITE_ID     = J.SITE_ID'+char(10)
  SET @v_dSql += '          AND    A.TOP_ITEM_ID = J.ITEM_ID'+char(10)
  SET @v_dSql += '		WHERE 	1=1'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LK', @p_cell_group)) + char(10)
  SET @v_dSql += '		AND 	NOT EXISTS (	' + char(10) --하위공정은 찾을 수 없어 빼준다.'+char(10)
  SET @v_dSql += '								SELECT 	*'+char(10)
  SET @v_dSql += '								FROM 	('+char(10)
  SET @v_dSql += '											SELECT 	DISTINCT OPERATION_ID, ''PAST_SALES'' AS CATEGORY_ID'+char(10)
  SET @v_dSql += '											FROM 	FP_INSTANCE_OPERATION_V'+char(10)
  SET @v_dSql += '											WHERE 	INSTANCE_ID='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '											AND 	AMEND_MAIN_FLAG = ''N'''+char(10)
  SET @v_dSql += '										) X'+char(10)
  SET @v_dSql += '								WHERE 1=1'+char(10)
  SET @v_dSql += '								AND A.OPERATION_ID = X.OPERATION_ID'+char(10)
  SET @v_dSql += '								AND A.CATEGORY_ID = X.CATEGORY_ID'+char(10)
  SET @v_dSql += '							)'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , MAIN_P AS ('+char(10)
  --SET @v_dSql += '          -- P : builing, location, production type, market, line'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '               , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '               , ISNULL(MAX(F.QTY),0) AS BOH_QTY'+char(10)
  SET @v_dSql += '               , ISNULL(MAX(F.BOH_CELL_QTY),0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '               , ''P'' AS PSI'+char(10)
  SET @v_dSql += '               , A.LINE_ID'+char(10)
  SET @v_dSql += '               , A.LINE_NAME'+char(10)
  SET @v_dSql += '               , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , D.CATE_NAME AS CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				--SET @v_dSql += '               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				-- @sub_param_0 => MONTH
				-- @sub_param_1 => MONTH_NAME
				-- @sub_param_2 => MONTH_COUNT
				-- @sub_param_3 => M_VALUE
                SET @v_dSql += '               , SUM(CASE WHEN G.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN D.CATE_ID = ''M_IN_CELL'' THEN ROUND(A.MPP_CELL_IN_QTY,0) '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''M_IN'' THEN A.MPP_IN_QTY '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''M_OUT_CELL'' THEN ROUND(A.MPP_CELL_OUT_QTY,0) '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''M_OUT'' THEN A.MPP_OUT_QTY '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''W_IN_CELL'' THEN ROUND(A.WPP_CELL_IN_QTY,0) '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''W_IN'' THEN A.WPP_IN_QTY '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''W_OUT_CELL'' THEN ROUND(A.WPP_CELL_OUT_QTY,0) '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''W_OUT'' THEN A.WPP_OUT_QTY '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''P_IN_CELL'' THEN ROUND(A.CELL_IN_QTY,0) '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''P_IN'' THEN A.IN_QTY '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''P_OUT_CELL'' THEN ROUND(A.CELL_OUT_QTY,0) '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY  '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN ROUND(A.RESULT_CELL_OUT_QTY,0)  '+  char(10)
                SET @v_dSql += '															WHEN D.CATE_ID = ''P_RESULT'' THEN ROUND(A.RESULT_OUT_QTY,0) '+  char(10)
                SET @v_dSql += '															ELSE 0 END ) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +  char(10)
  
				--SET @v_dSql += '               , SUM(CASE WHEN E.YYYYMM =''' + @sub_param_0+ ''' THEN (CASE WHEN B.CATEGORY_ID=''S'' THEN A.SALES_QTY WHEN B.CATEGORY_ID=''S_CELL'' THEN A.CELL_SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +  char(10)
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				--SET @v_dSql += '               , A.W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_week_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		

				SET @v_dSql += '               , SUM(CASE WHEN G.ISO_YYYYWW=''' +@sub_param_0  + ''' THEN (CASE WHEN D.CATE_ID = ''M_IN_CELL'' THEN ROUND(A.MPP_CELL_IN_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''M_IN'' THEN A.MPP_IN_QTY' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''M_OUT_CELL'' THEN ROUND(A.MPP_CELL_OUT_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''M_OUT'' THEN A.MPP_OUT_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_IN_CELL'' THEN ROUND(A.WPP_CELL_IN_QTY,0)' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_IN'' THEN A.WPP_IN_QTY' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_OUT_CELL'' THEN ROUND(A.WPP_CELL_OUT_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_OUT'' THEN A.WPP_OUT_QTY' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_IN_CELL'' THEN ROUND(A.CELL_IN_QTY,0)' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_IN'' THEN A.IN_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_OUT_CELL'' THEN ROUND(A.CELL_OUT_QTY,0)' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN ROUND(A.RESULT_CELL_OUT_QTY,0)' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_RESULT'' THEN ROUND(A.RESULT_OUT_QTY,0)' + char(10)
				SET @v_dSql += '															ELSE 0 END ) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +  char(10)

				--SET @v_dSql += '               , SUM(CASE WHEN A.PLAN_WEEK<=''' + @sub_param_0 + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' +@p_plan_date+''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY' + char(10)
				--SET @v_dSql += '               																																							WHEN B.CATEGORY_ID = ''I_CELL'' THEN A.CELL_EOH_QTY ' + char(10)
				--SET @v_dSql += '               																																							ELSE 0 END)ELSE 0 END)ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				--SET @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

				-- @sub_param_0 => MONth
				-- @sub_param_1 => MONTH_NAME
				-- @sub_param_2 => MONTH_COUNT
				-- @sub_param_3 => M_VALUE
				SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_3+ ''' THEN (CASE WHEN D.CATE_ID = ''M_IN_CELL'' THEN ROUND(A.MPP_CELL_IN_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''M_IN'' THEN A.MPP_IN_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''M_OUT_CELL'' THEN ROUND(A.MPP_CELL_OUT_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''M_OUT'' THEN A.MPP_OUT_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_IN_CELL'' THEN ROUND(A.WPP_CELL_IN_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_IN'' THEN A.WPP_IN_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_OUT_CELL'' THEN ROUND(A.WPP_CELL_OUT_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''W_OUT'' THEN A.WPP_OUT_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_IN_CELL'' THEN ROUND(A.CELL_IN_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_IN'' THEN A.IN_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_OUT_CELL'' THEN ROUND(A.CELL_OUT_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN ROUND(A.RESULT_CELL_OUT_QTY,0) ' + char(10)
				SET @v_dSql += '															WHEN D.CATE_ID = ''P_RESULT'' THEN ROUND(A.RESULT_OUT_QTY,0) ' + char(10)
				SET @v_dSql += '															ELSE 0 END ) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +  char(10)
  		END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  SET @v_dSql += '               , D.CATE_ID AS CATEGORY_ID'+char(10)
  SET @v_dSql += '               , D.CATE_ORDER AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , D.MEASURE_ID, D.MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '			             SELECT   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '			                    , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE'+char(10)
  SET @v_dSql += '			                    , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '			                    , A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '			                    , A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE'+char(10)
  SET @v_dSql += '			                    , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME,J.CELL_GROUP'+char(10)
  SET @v_dSql += '			                    , ISNULL(E.LINE_NAME,''-'') AS LINE_NAME'+char(10)
  SET @v_dSql += '			                    , A.PLM_EC_NO '+char(10)
  SET @v_dSql += '			                    , A.IN_QTY'+char(10)
  SET @v_dSql += '								, A.OUT_QTY'+char(10)
  SET @v_dSql += '								, A.CELL_IN_QTY'+char(10)
  SET @v_dSql += '								, A.CELL_OUT_QTY'+char(10)
  SET @v_dSql += '								, A.MPP_IN_QTY'+char(10)
  SET @v_dSql += '								, A.MPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '								, A.MPP_OUT_QTY'+char(10)
  SET @v_dSql += '								, A.MPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '								, A.WPP_IN_QTY'+char(10)
  SET @v_dSql += '								, A.WPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '								, A.WPP_OUT_QTY'+char(10)
  SET @v_dSql += '								, A.WPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '								, A.RESULT_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '								, A.RESULT_OUT_QTY'+char(10)
  SET @v_dSql += '			             FROM ('+char(10)
  SET @v_dSql += '				                SELECT 	A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '										, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '										, A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '										, A.OPERATION_ID'+char(10)
  SET @v_dSql += '										, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '										, NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '										, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '										, ''P'' AS PSI'+char(10)
  SET @v_dSql += '										, A.LINE_ID'+char(10)
  SET @v_dSql += '										, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '										, A.PLAN_DATE'+char(10)
  SET @v_dSql += '										, A.IN_QTY'+char(10)
  SET @v_dSql += '										, A.OUT_QTY'+char(10)
  SET @v_dSql += '										, A.CELL_IN_QTY'+char(10)
  SET @v_dSql += '										, A.CELL_OUT_QTY'+char(10)
  SET @v_dSql += '										, A.MPP_IN_QTY'+char(10)
  SET @v_dSql += '										, A.MPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '										, A.MPP_OUT_QTY'+char(10)
  SET @v_dSql += '										, A.MPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '										, A.WPP_IN_QTY'+char(10)
  SET @v_dSql += '										, A.WPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '										, A.WPP_OUT_QTY'+char(10)
  SET @v_dSql += '										, A.WPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '										, A.RESULT_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '										, A.RESULT_OUT_QTY AS RESULT_OUT_QTY'+char(10)
  SET @v_dSql += '										, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '										                      FROM  #TblFP_AMEND_PLAN_CELL_H_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										                      WHERE  1 = 1 '+char(10)
--  SET @v_dSql += '				                FROM   '+@p_amend_table + ' A WITH(NOLOCK)'+char(10)
--  SET @v_dSql += '				                WHERE  A.INSTANCE_ID  ='+char(10)
--  SET @v_dSql += '' + @v_master_id+''+char(10)
--  SET @v_dSql += '				                AND    A.FP_PLAN_ID   ='+char(10)
--  SET @v_dSql += '' + @v_plan_id+''+char(10)
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  --SET @v_dSql += '
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
--  --{
--  --				                  var sql="";
--  --				                  var sDiv = $data.DIVISION_LT;
--  --				                  sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
--  --				                  sql;
--  --				                }

--  --'
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
--  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  --SET @v_dSql += '
--  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
--  --{
--  --				                  var sql="";
--  --				                  var sPlt = $data.PLANT_LT;
--  --				                  sql="AND    A.PLANT_ID IN (" + sPlt + ")";
--  --				                  sql;
--  --				                }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--  --SET @v_dSql += '
-- SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
-- --{
--  --				                  var sql="";
--  --				                  var sFac = $data.FACTORY_LT;
--  --				                  sql="AND    A.FACTORY_ID IN (" + sFac + ")";
--  --				                  sql;
--  --				                }

--  --'
--  --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
--  --SET @v_dSql += '
--  --{
--  --				                  var sql="";
--  --				                  var sOper = $data.OPERATION_LT;
--  --
--  --				                  if(sOper!=null && sOper!="") {
														
--  --				                    sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
--  --				                  }
--  --
--  --				                  sql;
--  --				                }

--  --'
--  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
--     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
-- --SET @v_dSql += '
--  --{
--  --				                  var sql="";
--  --				                  var sLine = $data.LINE_LT;
--  --				                  sql="AND    A.LINE_ID IN (" + sLine + ")";
--  --				                  sql;
--  --				                }

--  --'
--  SET @v_dSql += '				                AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
--  SET @v_dSql += '' + @v_bucket_from+''+char(10)
--  SET @v_dSql += ' AND'+char(10)
--  SET @v_dSql += '' + @v_bucket_to+''+char(10)
--  SET @v_dSql += '				                AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)'+char(10)
--  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
--    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
--  --SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
  SET @v_dSql += '			             ) A'+char(10)
  SET @v_dSql += '			             INNER JOIN ('+char(10)
  SET @v_dSql += '				                SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,'+char(10)
  SET @v_dSql += '				                       A.ITEM_ID,'+char(10)
  SET @v_dSql += '				                       (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '				                       	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '				                       	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,'+char(10)
  SET @v_dSql += '				                       ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '				                FROM	 SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SET @v_dSql += '				                  		 SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				                WHERE	 A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --{
  --			                        var sql="";
  --			                        var sDiv = $data.DIVISION_LT;
  --			                        sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --			                        sql;
  --			                      }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '				         ) B'+char(10)
  SET @v_dSql += '			             ON     A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '			             AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '			             AND    A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '			             AND    A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '			             INNER JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				         ON     A.COMPANY_ID   = C.COMPANY_ID'+char(10)
  SET @v_dSql += '				         AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
  SET @v_dSql += '				         AND    A.SITE_ID      = C.SITE_ID'+char(10)
  SET @v_dSql += '				         AND    A.TOP_ITEM_ID  = C.ITEM_ID'+char(10)
  --SET @v_dSql += ' ' +@opt_11item_name +' '+''+char(10)--AND   C.NICK_NAME LIKE '%' + RTRIM(LTRIM(#ITEM_NAME#)) + '%'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_item_name)) + char(10) 
  SET @v_dSql += '			            INNER JOIN SCM_LINE_M E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						ON     A.COMPANY_ID     = E.COMPANY_ID'+char(10)
  SET @v_dSql += '						AND    A.DIVISION_ID    = E.DIVISION_ID'+char(10)
  SET @v_dSql += '						AND    A.SITE_ID        = E.SITE_ID'+char(10)
  SET @v_dSql += '						AND    A.PLANT_ID       = E.PLANT_ID'+char(10)
  SET @v_dSql += '						AND    A.FACTORY_ID     = E.FACTORY_ID'+char(10)
  SET @v_dSql += '						AND    A.OPERATION_ID   = E.OPERATION_ID'+char(10)
  SET @v_dSql += '						AND    A.LINE_ID        = E.LINE_ID'+char(10)
  SET @v_dSql += '						AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '						INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						ON     A.COMPANY_ID  = J.COMPANY_ID'+char(10)
  SET @v_dSql += '						AND    A.DIVISION_ID = J.DIVISION_ID'+char(10)
  SET @v_dSql += '						AND    A.SITE_ID     = J.SITE_ID'+char(10)
  SET @v_dSql += '						AND    A.TOP_ITEM_ID = J.ITEM_ID'+char(10)
  SET @v_dSql += '						WHERE  1=1'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LK', @p_cell_group)) + char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          INNER JOIN #TblFP00599_TEMP D '+char(10) 
  --SET @v_dSql += '          INNER JOIN ('+char(10) 
  --SET @v_dSql += '              SELECT 20 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 23 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 26 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 29 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 32 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 35 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 38 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 41 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 44 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''P_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 47 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''P_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 50 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''P_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 53 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''P_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 56 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 59 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT 60 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID, '''' AS MEASURE_ID, '''' AS MEASURE_NAME'+char(10)
  --SET @v_dSql += '          ) D'+char(10)
  SET @v_dSql += '          ON     1=1'+char(10)
  SET @v_dSql += '          LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                 , A.OPERATION_ID, A.LOCATION, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                 , A.ITEM_ID, A.TOP_ITEM_ID, SUM(ISNULL(A.MODIFY_QTY, A.QTY)) AS QTY'+char(10)
  SET @v_dSql += '                 , ROUND(( SUM(ISNULL(A.MODIFY_QTY, A.QTY)) / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, CONVERT(DATE,'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')) ) ,0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '								                      FROM   #Tblp_AMEND_CUTOFF_BOH_TABLE_TEMP A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '								                      WHERE  1 = 1'+char(10)
  --SET @v_dSql += '            FROM   '+ @p_AMEND_CUTOFF_BOH_TABLE  +' A WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '            WHERE  A.INSTANCE_ID  ='+char(10)
  --SET @v_dSql += '' + @v_master_id+''+char(10)
  --SET @v_dSql += '            AND    A.FP_PLAN_ID   ='+char(10)
  --SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                   , A.OPERATION_ID, A.LOCATION, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                   , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '          ) F'+char(10)
  SET @v_dSql += '          ON  A.COMPANY_ID   = F.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND A.DIVISION_ID  = F.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND A.SITE_ID      = F.SITE_ID'+char(10)
  SET @v_dSql += '          AND A.PLANT_ID     = F.PLANT_ID'+char(10)
  SET @v_dSql += '          AND A.FACTORY_ID   = F.FACTORY_ID'+char(10)
  SET @v_dSql += '          AND A.OPERATION_ID = F.OPERATION_ID'+char(10)
  SET @v_dSql += '          AND A.LOCATION     = F.LOCATION'+char(10)
  SET @v_dSql += '          AND A.ITEM_ID      = F.ITEM_ID'+char(10)
  SET @v_dSql += '          AND A.TOP_ITEM_ID  = F.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '          AND A.PLM_EC_NO    = F.PLM_EC_NO '+char(10)
  SET @v_dSql += '          INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON  A.PLAN_DATE    = G.DT'+char(10)
  SET @v_dSql += '          WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --{
  --            var sql="";
  --            var sDiv = $data.DIVISION_LT;
  --            sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --            sql;
  --          }

  --'
  --SET @STRLEN = LEN(@v_dSql)
  --SELECT @STRLEN as [QUERY_LENGTH]
  --return
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
 SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10
 ) --{
  --            var sql="";
  --            var sPlt = $data.PLANT_LT;
  --            sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --            sql;
  --          }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  --{
  --            var sql="";
  --            var sFac = $data.FACTORY_LT;
  --            sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --            sql;
  --          }

  --'
  --SET @v_dSql += ' ' +@opt_3operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --            var sql="";
  --            var sOper = $data.OPERATION_LT;
  --
  --            if(sOper!=null && sOper!="") {
  --              sql+="AND    A.OPERATION_ID IN (" + sOper + ")";
  --            }
  --
  --            sql;
  --          }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
 --SET @v_dSql += '
  --{
  --            var sql="";
  --            var sLine = $data.LINE_LT;
  --            sql="AND    A.LINE_ID IN (" + sLine + ")";
  --            sql;
  --          }

  --'
  --SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  --SET @v_dSql += ' ' +@opt_48item_name +' '+''+char(10)--AND    A.NICK_NAME LIKE '%' + RTRIM(LTRIM(#ITEM_NAME#)) + '%'
     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_item_name)) + char(10)
  --SET @v_dSql += ' ' +@opt_31prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE = #PROD_TYPE#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)
  --SET @v_dSql += '
  --{
  --            var sql="";
  --            var sProdType = $data.PRODTYPE_LT;
  --            if(sProdType != null && sProdType != ""){
  --              sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")";
  --            }
  --            sql;
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                 , A.OPERATION_ID'+char(10)
  SET @v_dSql += '                 , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                 , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '                 , A.LINE_ID, A.LINE_NAME'+char(10)
  SET @v_dSql += '                 , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                 , D.CATE_NAME'+char(10)
  SET @v_dSql += '                 , D.CATE_ORDER, D.CATE_NAME, D.CATE_ID'+char(10)
  SET @v_dSql += '                 , D.MEASURE_ID, D.MEASURE_NAME'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , MAIN_P_SUBT AS ('+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '               , ''Total'' AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_CELL_QTY),0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS MARKET'+char(10)
  SET @v_dSql += '               , A.PSI'+char(10)
  SET @v_dSql += '               , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10) --               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(W' + +TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10) --               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D' + +TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10) --               , A.M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo  = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				if(list.size() > 0) {
  --        				  for(var i = 0; i < monthInfo.size(); i++) {
  --        				    sql+="               , SUM(M" + i + ") AS M" + i + "\r\n";
  --        				  }
  --
  --        				  for(var i = 0; i < weekInfo.size(); i++) {
  --        				    sql+="               , SUM(W" + i + ") AS W" + i + "\r\n";
  --        				  }
  --
  --        					for(var i = 0; i < list.size(); i++) {
  --        					  sql+="               , SUM(D" + i + ") AS D" + i + "\r\n";
  --        					}
  --        				}
  --        			}

  --'
  SET @v_dSql += '               , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '               , (CASE WHEN A.CATEGORY_ID=''M_IN_CELL'' THEN 600'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''M_IN'' THEN 610'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''M_OUT_CELL'' THEN 620'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''M_OUT'' THEN 630'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''W_IN_CELL'' THEN 640'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''W_IN'' THEN 650'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''W_OUT_CELL'' THEN 660'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''W_OUT'' THEN 670'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''P_IN_CELL'' THEN 680'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''P_IN'' THEN 690'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''P_OUT_CELL'' THEN 700'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''P_OUT'' THEN 710'+char(10)
  SET @v_dSql += '                       WHEN A.CATEGORY_ID=''P_RESULT_CELL'' THEN 720'+char(10)
  SET @v_dSql += '                       ELSE 800 END ) AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                   , A.OPERATION_ID'+char(10)
  SET @v_dSql += '                   , ''Total'' AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SET @v_dSql += '                   , A.BOH_QTY'+char(10)
  SET @v_dSql += '                   , A.BOH_CELL_QTY'+char(10)
  SET @v_dSql += '                   , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '                   , NULL AS MARKET'+char(10)
  SET @v_dSql += '                   , A.PSI'+char(10)
  SET @v_dSql += '                   , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '                   , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '                   , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                   , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

	--		select @v_dSql as [QUERY_VALUE]
	--RETURN 1
  --SET @v_dSql += '
  --{
  --            				var sql="";
  --            				var list = $data.bucket;
  --            				var weekInfo  = $data.WEEK_INFO;
  --            				var monthInfo = $data.MONTH_INFO;
  --
  --            				if(list.size() > 0) {
  --            				  for(var i = 0; i < monthInfo.size(); i++) {
  --            				    sql+="               , SUM(M" + i + ") AS M" + i + "\r\n";
  --            				  }
  --
  --            				  for(var i = 0; i < weekInfo.size(); i++) {
  --            				    sql+="               , SUM(W" + i + ") AS W" + i + "\r\n";
  --            				  }
  --
  --            					for(var i = 0; i < list.size(); i++) {
  --            					  sql+="               , SUM(D" + i + ") AS D" + i + "\r\n";
  --            					}
  --            				}
  --            			}

  --'
  SET @v_dSql += '                   , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                   , A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '                   , ''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                   , NULL AS S_ROW'+char(10)
  SET @v_dSql += '                   , ROW_NUMBER( ) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PLM_EC_NO, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE'+char(10)
  SET @v_dSql += '                                         ORDER BY     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PLM_EC_NO, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE ) AS BOH_ROWNUM'+char(10)
  SET @v_dSql += '              FROM MAIN_P A'+char(10)
  SET @v_dSql += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                     , A.OPERATION_ID'+char(10)
  SET @v_dSql += '                     , A.CATEGORY_ID, A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '                     , A.PSI, A.CATE'+char(10)
  SET @v_dSql += '                     , A.BOH_QTY, A.BOH_CELL_QTY'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                 , A.OPERATION_ID'+char(10)
  SET @v_dSql += '                 , A.CATEGORY_ID, A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '                 , A.PSI, A.CATE'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , T_MEMO AS ('+char(10)
  SET @v_dSql += '      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '		               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '		               , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		               , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		               , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '		               , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				--SET @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt +1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				SET @v_dSql += '               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_3 + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_MO ' + char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --    	        				var sql="";
  --    	        				var list = $data.bucket;
  --    	        				for(var i = 0; i < list.size(); i++) {
  --		                    sql+="               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' AND A.MEMO IS NOT NULL THEN ''''Y'''' ELSE NULL END) AS D" + i + "_MO \r\n";
  --                  		}
  --	                }

  --'
  SET @v_dSql += '	          FROM FP_AMEND_MEMO_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	          WHERE 1=1'+char(10)
  SET @v_dSql += '	          AND    A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += '
  --{
  --                var sql="";
  --                var sDiv = $data.DIVISION_LT;
  --                sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --                sql;
  --              }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  --{
  --                var sql="";
  --                var sPlt = $data.PLANT_LT;
  --                sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --                sql;
  --              }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  --{
  --                var sql="";
  --                var sFac = $data.FACTORY_LT;
  --                sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --                sql;
  --              }

  --'
  --SET @v_dSql += ' ' +@opt_52operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
 
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
     SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
 --SET @v_dSql += '
  --{
  --                var sql="";
  --                var sLine = $data.LINE_LT;
  --                sql="AND    A.LINE_ID IN (" + sLine + ")";
  --                sql;
  --              }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)

  --SET @v_dSql += ' ' +@opt_53top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  --SET @v_dSql += ' ' +@opt_54item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  --SET @v_dSql += ' ' +@opt_55prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)
  --SET @v_dSql += '
  --{
  --                var sql="";
  --                var sProdType = $data.PRODTYPE_LT;
  --                if(sProdType != null && sProdType != ""){
  --                  sql="AND    A.
  --IN (" + sProdType + ")";
  --                }
  --                sql;
  --              }

  --'
  SET @v_dSql += '	          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '          				 , A.OPERATION_ID'+char(10)
  SET @v_dSql += '          				 , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '          			   , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '          				 , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '          			 	 , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT A.*'+char(10)
  SET @v_dSql += '          , DENSE_RANK() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                              ORDER BY     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID) AS LV1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '  , C.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_MO' + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --    				var sql="";
  --    				var list = $data.bucket;
  --    				for(var i = 0; i < list.size(); i++) {
  --                sql+="  , C.D" + i + "_MO \r\n";
  --        		}
  --  	      }

  --'
  SET @v_dSql += '  	       , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'''+char(10)
  SET @v_dSql += '  	       		  WHEN D.PRODUCTION_TYPE IS NULL /*OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'')*/ THEN ''N'''+char(10)
  SET @v_dSql += '          		  WHEN I.DIVISION_ID IS NOT NULL THEN ''Y'''+char(10)
  SET @v_dSql += '          	   	  ELSE ''Y'' END AS EDIT_YN'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '          SELECT * FROM MAIN_S'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT * FROM MAIN_P'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT * FROM MAIN_I'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '               , ''Total'' AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_CELL_QTY),0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS MARKET'+char(10)
  SET @v_dSql += '               , A.PSI'+char(10)
  SET @v_dSql += '               , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo  = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				if(list.size() > 0) {
  --        				  for(var i = 0; i < monthInfo.size(); i++) {
  --        				    sql+="               , SUM(M" + i + ") AS M" + i + "\r\n";
  --        				  }
  --
  --        				  for(var i = 0; i < weekInfo.size(); i++) {
  --        				    sql+="               , SUM(W" + i + ") AS W" + i + "\r\n";
  --        				  }
  --
  --        					for(var i = 0; i < list.size(); i++) {
  --        					  sql+="               , SUM(D" + i + ") AS D" + i + "\r\n";
  --        					}
  --        				}
  --        			}

  --'
  SET @v_dSql += '               , A.CATEGORY_ID, (CASE WHEN A.CATEGORY_ID = ''S'' THEN 410 ELSE 400 END) AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , '''' AS MEASURE_ID, '''' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM MAIN_S A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			  WHILE @mst_loop_cnt < @max_loop_cnt
				  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,@v_delimiter, @mst_loop_cnt);
					IF @tmp_column = 'chk_total' BEGIN
						SET @v_dSql += 'WHERE 1=0' +char(10)
					END 
				  END
    END
  --SET @v_dSql += '
  --{
  --            var sql = "";
  --            var cateInfo = $data.CATE_INFO;
  --
  --            if(cateInfo != null) {
  --    					for(var i=0; i<cateInfo.size(); i++) {
  --                if(cateInfo[i].TYPE == "CATEGORY" && cateInfo[i].MEA_ID == "chk_total") {
  --                  if(cateInfo[i].MEA_VALUE == "false") {
  --                    sql="WHERE 1=0";
  --                  }
  --                }
  --    					}
  --            }
  --
  --            sql;
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                 , A.OPERATION_ID'+char(10)
  SET @v_dSql += '                 , A.PSI, A.CATE, A.CATEGORY_ID'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT * FROM MAIN_P_SUBT'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			  WHILE @mst_loop_cnt < @max_loop_cnt
				  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,@v_delimiter, @mst_loop_cnt);
					IF @tmp_column = 'chk_total' BEGIN
						SET @v_dSql += 'WHERE 1=0' +char(10)
					END 
				  END
    END
  --SET @v_dSql += '
  --{
  --            var sql = "";
  --            var cateInfo = $data.CATE_INFO;
  --
  --            if(cateInfo != null) {
  --    					for(var i=0; i<cateInfo.size(); i++) {
  --                if(cateInfo[i].TYPE == "CATEGORY" && cateInfo[i].MEA_ID == "chk_total") {
  --                  if(cateInfo[i].MEA_VALUE == "false") {
  --                    sql="WHERE 1=0";
  --                  }
  --                }
  --    					}
  --            }
  --
  --            sql;
  --          }

  --'
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '               , ''Total'' AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SET @v_dSql += '               , SUM(A.BOH_QTY) AS  BOH_QTY'+char(10)
  SET @v_dSql += '               , SUM(A.BOH_CELL_QTY) AS  BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS MARKET'+char(10)
  SET @v_dSql += '               , A.PSI'+char(10)
  SET @v_dSql += '               , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D' +TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo = $data.WEEK_INFO;
  --
  --        				if(list.size() > 0) {
  --        				  for(var i = 0; i < monthInfo.size(); i++) {
  --        				    sql+="               , NULL AS M" + i + "\r\n";
  --        				  }
  --
  --        				  for(var i = 0; i < weekInfo.size(); i++) {
  --        				    sql+="               , NULL AS W" + i + "\r\n";
  --        				  }
  --
  --        					for(var i = 0; i < list.size(); i++) {
  --        					  sql+="               , SUM(D" + i + ") AS D" + i + "\r\n";
  --        					}
  --        				}
  --        			}

  --'
  SET @v_dSql += '               , ''I'' AS CATEGORY_ID, 900 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , '''' AS MEASURE_ID, '''' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM MAIN_I A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			  WHILE @mst_loop_cnt < @max_loop_cnt
				  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,@v_delimiter, @mst_loop_cnt);
					IF @tmp_column = 'chk_total' BEGIN
						SET @v_dSql += 'WHERE 1=0' +char(10)
					END 
				  END
    END
  --SET @v_dSql += '
  --{
  --            var sql = "";
  --            var cateInfo = $data.CATE_INFO;
  --
  --            if(cateInfo != null) {
  --    					for(var i=0; i<cateInfo.size(); i++) {
  --                if(cateInfo[i].TYPE == "CATEGORY" && cateInfo[i].MEA_ID == "chk_total") {
  --                  if(cateInfo[i].MEA_VALUE == "false") {
  --                    sql="WHERE 1=0";
  --                  }
  --                }
  --    					}
  --            }
  --
  --            sql;
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME,A.CELL_GROUP, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '                 , A.OPERATION_ID'+char(10)
  SET @v_dSql += '                 , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                 , A.PSI, A.CATE'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID'+char(10)
  SET @v_dSql += '               , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME,NULL AS CELL_GROUP, NULL AS PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID AS OPERATION_ID'+char(10)
  SET @v_dSql += '               , NULL AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_CELL_QTY),0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS MARKET'+char(10)
  SET @v_dSql += '               , A.PSI'+char(10)
  SET @v_dSql += '               , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo  = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				if(list.size() > 0) {
  --        				  for(var i = 0; i < monthInfo.size(); i++) {
  --        				    sql+="               , SUM(M" + i + ") AS M" + i + "\r\n";
  --        				  }
  --
  --        				  for(var i = 0; i < weekInfo.size(); i++) {
  --        				    sql+="               , SUM(W" + i + ") AS W" + i + "\r\n";
  --        				  }
  --
  --        					for(var i = 0; i < list.size(); i++) {
  --        					  sql+="               , SUM(D" + i + ") AS D" + i + "\r\n";
  --        					}
  --        				}
  --        			}

  --'
  SET @v_dSql += '               , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '               , (CASE WHEN A.CATEGORY_ID = ''S'' THEN 810 ELSE 800 END) AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''TOTAL_2'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   MAIN_S A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			  WHILE @mst_loop_cnt < @max_loop_cnt
				  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,@v_delimiter, @mst_loop_cnt);
					IF @tmp_column = 'chk_total_2' BEGIN
						SET @v_dSql += 'WHERE 1=0' +char(10)
					END 
				  END
    END
  --SET @v_dSql += '
  --{
  --            var sql = "";
  --            var cateInfo = $data.CATE_INFO;
  --
  --            if(cateInfo != null) {
  --    					for(var i=0; i<cateInfo.size(); i++) {
  --                if(cateInfo[i].TYPE == "CATEGORY" && cateInfo[i].MEA_ID == "chk_total_2") {
  --                  if(cateInfo[i].MEA_VALUE == "false") {
  --                    sql="WHERE 1=0";
  --                  }
  --                }
  --    					}
  --            }
  --
  --            sql;
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID, A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID'+char(10)
  SET @v_dSql += '               , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME,NULL AS CELL_GROUP, NULL AS PLM_EC_NO'+char(10)
  SET @v_dSql += '               , A.OPERATION_ID AS OPERATION_ID'+char(10)
  SET @v_dSql += '               , NULL AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY'+char(10)
  SET @v_dSql += '               , ISNULL(SUM(A.BOH_CELL_QTY),0) AS BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS MARKET'+char(10)
  SET @v_dSql += '               , A.PSI'+char(10)
  SET @v_dSql += '               , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo  = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				if(list.size() > 0) {
  --        				  for(var i = 0; i < monthInfo.size(); i++) {
  --        				    sql+="               , SUM(M" + i + ") AS M" + i + "\r\n";
  --        				  }
  --
  --        				  for(var i = 0; i < weekInfo.size(); i++) {
  --        				    sql+="               , SUM(W" + i + ") AS W" + i + "\r\n";
  --        				  }
  --
  --        					for(var i = 0; i < list.size(); i++) {
  --        					  sql+="               , SUM(D" + i + ") AS D" + i + "\r\n";
  --        					}
  --        				}
  --        			}

  --'
  SET @v_dSql += '               , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '               , (CASE WHEN A.CATEGORY_ID=''M_IN_CELL'' THEN 2000'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''M_IN'' THEN 2100'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''M_OUT_CELL'' THEN 2200'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''M_OUT'' THEN 2300'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''W_IN_CELL'' THEN 2400'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''W_IN'' THEN 2500'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''W_OUT_CELL'' THEN 2600'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''W_OUT'' THEN 2700'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''P_IN_CELL'' THEN 2800'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''P_IN'' THEN 2900'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''P_OUT_CELL'' THEN 3000'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''P_OUT'' THEN 3100'+char(10)
  SET @v_dSql += '          					   WHEN A.CATEGORY_ID=''P_RESULT_CELL'' THEN 3200'+char(10)
  SET @v_dSql += '          					   ELSE 4000'+char(10)
  SET @v_dSql += '          					   END) AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW'+char(10)
  SET @v_dSql += '          FROM MAIN_P_SUBT A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			  WHILE @mst_loop_cnt < @max_loop_cnt
				  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,@v_delimiter, @mst_loop_cnt);
					IF @tmp_column = 'chk_total' BEGIN
						SET @v_dSql += 'WHERE 1=0' +char(10)
					END 
				  END
    END
  --SET @v_dSql += '
  --{
  --            var sql = "";
  --            var cateInfo = $data.CATE_INFO;
  --
  --            if(cateInfo != null) {
  --    					for(var i=0; i<cateInfo.size(); i++) {
  --                if(cateInfo[i].TYPE == "CATEGORY" && cateInfo[i].MEA_ID == "chk_total_2") {
  --                  if(cateInfo[i].MEA_VALUE == "false") {
  --                    sql="WHERE 1=0";
  --                  }
  --                }
  --    					}
  --            }
  --
  --            sql;
  --          }

  --'
  --     print @v_dSql
  --RETURN 599
  SET @v_dSql += '          GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID, A.MEASURE_ID, A.MEASURE_NAME'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID'+char(10)
  SET @v_dSql += '               , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME,NULL AS CELL_GROUP, NULL AS PLM_EC_NO '+char(10)
  SET @v_dSql += '               , A.OPERATION_ID AS OPERATION_ID'+char(10)
  SET @v_dSql += '               , NULL AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SET @v_dSql += '               , SUM(A.BOH_QTY) AS  BOH_QTY'+char(10)
  SET @v_dSql += '               , SUM(A.BOH_CELL_QTY) AS  BOH_CELL_QTY'+char(10)
  SET @v_dSql += '               , NULL AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '               , NULL AS MARKET'+char(10)
  SET @v_dSql += '               , A.PSI'+char(10)
  SET @v_dSql += '               , NULL AS LINE_ID'+char(10)
  SET @v_dSql += '               , NULL AS LINE_NAME'+char(10)
  SET @v_dSql += '               , NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , NULL AS W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D' +TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --        				var sql="";
  --        				var list = $data.bucket;
  --        				var weekInfo  = $data.WEEK_INFO;
  --        				var monthInfo = $data.MONTH_INFO;
  --
  --        				if(list.size() > 0) {
  --        				  for(var i = 0; i < monthInfo.size(); i++) {
  --        				    sql+="               , NULL AS M" + i + "\r\n";
  --        				  }
  --
  --        				  for(var i = 0; i < weekInfo.size(); i++) {
  --        				    sql+="               , NULL AS W" + i + "\r\n";
  --        				  }
  --
  --        					for(var i = 0; i < list.size(); i++) {
  --        					  sql+="               , SUM(D" + i + ") AS D" + i + "\r\n";
  --        					}
  --        				}
  --        			}

  --'
  SET @v_dSql += '               , A.CATEGORY_ID, 5000 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '               , '''' AS MEASURE_ID, '''' AS MEASURE_NAME'+char(10)
  SET @v_dSql += '               , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   MAIN_I A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_cate_info,'') <> '' BEGIN
    SET @mst_loop_cnt = 0
    SET @v_delimiter            = '!'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  		  WHILE @mst_loop_cnt < @max_loop_cnt
			  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
				SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,@v_delimiter, @mst_loop_cnt);
				IF @tmp_column = 'chk_total_2' BEGIN
					SET @v_dSql += 'WHERE 1=0' +char(10)
			  END 
	     END
  END
  --SET @v_dSql += '
  --{
  --            var sql = "";
  --            var cateInfo = $data.CATE_INFO;
  --
  --            if(cateInfo != null) {
  --    					for(var i=0; i<cateInfo.size(); i++) {
  --                if(cateInfo[i].TYPE == "CATEGORY" && cateInfo[i].MEA_ID == "chk_total_2") {
  --                  if(cateInfo[i].MEA_VALUE == "false") {
  --                    sql="WHERE 1=0";
  --                  }
  --                }
  --    					}
  --            }
  --
  --            sql;
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN T_MEMO C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID      = C.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID     = C.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID         = C.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.PLANT_ID        = C.PLANT_ID'+char(10)
  SET @v_dSql += '      AND A.FACTORY_ID      = C.FACTORY_ID'+char(10)
  SET @v_dSql += '      AND A.OPERATION_ID    = C.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND A.LINE_ID         = C.LINE_ID'+char(10)
  SET @v_dSql += '      AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '      AND A.MARKET          = C.MARKET'+char(10)
  SET @v_dSql += '      AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '      AND A.ITEM_ID         = C.ITEM_ID'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN'+char(10)
  SET @v_dSql += '      	('+char(10)
  SET @v_dSql += '	        SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '	        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	        WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'''+char(10)
  SET @v_dSql += '	        AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF @p_instance_id = 'KR_CELL' BEGIN
  SET @v_dSql += 'UNION ALL '+char(10)
  SET @v_dSql += 'SELECT DISTINCT A.DIVISION_ID, ''M/C'' AS PRODUCTION_TYPE '+char(10)
  SET @v_dSql += 'FROM   SCM_FACTORY_M A(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK) '+char(10)
  SET @v_dSql += 'ON     A.FACTORY_ID=B.FACTORY_ID '+char(10)
  SET @v_dSql += 'AND	  B.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += 'WHERE 1=1 '+char(10)
  SET @v_dSql += 'AND	  A.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += 'AND    B.INSTANCE_ID = ''KR_CELL'' '+char(10)
  END
  --SET @v_dSql += '
  --{
  --				var sql = "";
  --				var sMst = $data.INSTANCE_ID;
  --
  --				if(sMst == "KR_CELL") {
  --					sql += "UNION ALL \r\n";
  --					sql += "SELECT DISTINCT A.DIVISION_ID, ''''M/C'''' AS PRODUCTION_TYPE \r\n";
  --					sql += "FROM   SCM_FACTORY_M A(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK) \r\n";
  --					sql += "ON     A.FACTORY_ID=B.FACTORY_ID \r\n";
  --					sql += "AND	  B.ACTIVE_FLAG = ''''Y'''' \r\n";
  --					sql += "WHERE 1=1 \r\n";
  --					sql += "AND	  A.ACTIVE_FLAG = ''''Y'''' \r\n";
  --					sql += "AND    B.INSTANCE_ID = ''''KR_CELL'''' \r\n";
  --				}
  --
  --				sql;
  --			}

  --'
  SET @v_dSql += '      	) D'+char(10)
  SET @v_dSql += '      	ON A.DIVISION_ID = D.DIVISION_ID'+char(10)
  SET @v_dSql += '      	AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE'+char(10)
  --SET @v_dSql += '      	AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE'+char(10) -- 사이트 제약조건 제거(23/5/23)
  SET @v_dSql += '	  LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '  			SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS SITE_ID, A.SEGMENT4 AS PLANT_ID, A.SEGMENT5 AS MODEL_ID'+char(10)
  SET @v_dSql += '  			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '  			WHERE  A.LOOKUP_TYPE_CODE = ''AMEND_VALIDATION_EXCEPTION'''+char(10)
  SET @v_dSql += '  			AND    A.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '  			AND    A.SEGMENT1         ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '	  ) I'+char(10)
  SET @v_dSql += '	  ON  A.DIVISION_ID = I.DIVISION_ID'+char(10)
  SET @v_dSql += '	  AND A.SITE_ID     = I.SITE_ID'+char(10)
  SET @v_dSql += '	  AND A.PLANT_ID    = I.PLANT_ID'+char(10)
  SET @v_dSql += '	  AND A.TOP_ITEM_ID = I.MODEL_ID'+char(10)
  SET @v_dSql += '	  			LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '						SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID'+char(10)
  SET @v_dSql += '						FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						WHERE	1=1'+char(10)
  SET @v_dSql += '						AND		R.USER_ID	='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '						AND		R.SAVE_FLAG	= ''Y'''+char(10)
  SET @v_dSql += '						AND		R.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '				) R'+char(10)
  SET @v_dSql += '				ON		1=1'+char(10)
  SET @v_dSql += '				AND		A.COMPANY_ID		= R.COMPANY_ID'+char(10)
  SET @v_dSql += '				AND		A.DIVISION_ID		= R.DIVISION_ID'+char(10)
  SET @v_dSql += '				AND		A.SITE_ID			= R.SITE_ID'+char(10)
  SET @v_dSql += '				AND		A.PLANT_ID			= R.PLANT_ID'+char(10)
  SET @v_dSql += '				AND		A.FACTORY_ID		= R.FACTORY_ID'+char(10)
  SET @v_dSql += '				AND		A.OPERATION_ID		= R.OPERATION_ID'+char(10)
  SET @v_dSql += '				AND		A.LINE_ID			= R.LINE_ID'+char(10)
  SET @v_dSql += '      ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '              ,A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '              ,A.OPERATION_ID DESC'+char(10)
  SET @v_dSql += '              ,A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.PLM_EC_NO '+char(10)
  SET @v_dSql += '              ,(CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE 999 END)'+char(10)
  SET @v_dSql += '              ,A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '              ,(CASE WHEN CATEGORY_ID=''I'' OR CATEGORY_ID=''I_CELL'' THEN 999 ELSE 1 END)'+char(10)
  SET @v_dSql += '              ,A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '              ,(CASE WHEN CATEGORY_ID=''PAST_SALES'' THEN 1 WHEN CATEGORY_ID=''S_CELL'' THEN 2 ELSE 3 END)'+char(10)
  SET @v_dSql += '              ,A.LINE_ID, A.ELECTRODE_TYPE, CATEGORY_ORDER'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00599","findPlanAmend",param);
  --
  --}

  --'

  --SET @STRLEN = LEN(@v_dSql)
  --print @STRLEN

           --print @v_dSql
  --RETURN 650

  IF @p_sys_type = 'SQL'
  BEGIN
    DECLARE @log_id integer=0
	exec @log_id = PR_UI_SQL_LOG 'PR_UI_FP00599_FIND_FP00599',  @p_user_id,'','',@v_dSql,'sql',@runstart, @runend
	select query_value from TH_UIS_SQL_LOG WITH( NOLOCK)  where prog_id = 'PR_UI_FP00599_FIND_FP00599' and JOB_TYPE = 'sql' and INST_SEQ = @log_id
	 ORDER BY QUERY_SEQ ASC

	 select @v_dSql
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00599_FIND_FP00599',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00599_FIND_FP00599',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
