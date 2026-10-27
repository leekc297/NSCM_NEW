CREATE PROCEDURE [dbo].[PR_UI_FP00595_FIND_FP00595]
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
/** 프로그램 ID   : PR_UI_FP00595_FIND_FP00595                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00595_FIND_FP00595                                                                          **/
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
/** 2021-11-09     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00595_FIND_FP00595
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00595_FIND_FP00595'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_day_info      NVARCHAR(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_prod_type nvarchar(max) = ''
  DECLARE @p_prodtype_lt nvarchar(max) = ''
  DECLARE @p_item_name nvarchar(max) = ''
  DECLARE @p_fp_site_id nvarchar(max) = ''
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_cell_group nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_week_info nvarchar(max) = ''
  DECLARE @p_month_info nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_plan_type nvarchar(max)=''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_line_lt nvarchar(max) = ''
  DECLARE @p_curr_date_col nvarchar(max) = ''
  DECLARE @p_model_lt nvarchar(max) = ''
  DECLARE @p_operation_lt nvarchar(max) = ''
  DECLARE @p_nickname_lt nvarchar(max) = ''
  DECLARE @p_nickname nvarchar(max) = ''
  DECLARE @p_day2month nvarchar(max) = ''
  DECLARE @p_day2week nvarchar(max) = ''
  --DECLARE @p_curr_date_col nvarchar(max) = ''
  DECLARE @p_ROUND_POINT nvarchar(max) = ''
  DECLARE @v_ROUND_POINT int= 1
  DECLARE @p_confirm_area nvarchar(max) = ''
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p_cate_info nvarchar(max) = ''

  DECLARE @v_plan_date nvarchar(max)
  DECLARE @v_plan_type nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_prod_type nvarchar(max)
  DECLARE @v_item_name nvarchar(max)
  DECLARE @v_fp_site_id nvarchar(max)
  DECLARE @v_master_id nvarchar(max)

  DECLARE @v_cell_group nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_week_info nvarchar(max)
  DECLARE @v_month_info nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_model_lt nvarchar(max)
  DECLARE @v_operation_lt nvarchar(max)
  DECLARE @v_nickname_lt nvarchar(max)
  DECLARE @v_day2month nvarchar(max)
  DECLARE @v_day2week nvarchar(max)
  DECLARE @v_curr_date_col nvarchar(max)
  DECLARE @v_confirm_area nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0bucket_from nvarchar(max)
  DECLARE @opt_1bucket_from nvarchar(max)
  DECLARE @opt_2bucket_from nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4top_item_id nvarchar(max)
  DECLARE @opt_5item_id nvarchar(max)
  DECLARE @opt_6site_id nvarchar(max)
  DECLARE @opt_7top_item_id nvarchar(max)
  DECLARE @opt_8item_id nvarchar(max)
  DECLARE @opt_9site_id nvarchar(max)
  DECLARE @opt_10operation_id nvarchar(max)
  DECLARE @opt_11top_item_id nvarchar(max)
  DECLARE @opt_12item_id nvarchar(max)
  DECLARE @opt_13prod_type nvarchar(max)
  DECLARE @opt_14site_id nvarchar(max)
  DECLARE @opt_15operation_id nvarchar(max)
  DECLARE @opt_16top_item_id nvarchar(max)
  DECLARE @opt_17item_id nvarchar(max)
  DECLARE @opt_18prod_type nvarchar(max)
  DECLARE @opt_19site_id nvarchar(max)
  DECLARE @opt_20operation_id nvarchar(max)
  DECLARE @opt_21site_id nvarchar(max)
  DECLARE @opt_22item_id nvarchar(max)
  DECLARE @opt_23item_name nvarchar(max)
  DECLARE @opt_24cell_group nvarchar(max)
  DECLARE @opt_25bucket_from nvarchar(max)
  DECLARE @opt_26site_id nvarchar(max)
  DECLARE @opt_27top_item_id nvarchar(max)
  DECLARE @opt_28item_id nvarchar(max)
  DECLARE @opt_29site_id nvarchar(max)
  DECLARE @opt_30top_item_id nvarchar(max)
  DECLARE @opt_31item_id nvarchar(max)
  DECLARE @opt_32site_id nvarchar(max)
  DECLARE @opt_33item_id nvarchar(max)
  DECLARE @opt_34item_name nvarchar(max)
  DECLARE @opt_35cell_group nvarchar(max)
  DECLARE @opt_36instance_id nvarchar(max)
  DECLARE @opt_37site_id nvarchar(max)
  DECLARE @opt_38top_item_id nvarchar(max)
  DECLARE @opt_39item_id nvarchar(max)
  DECLARE @opt_40site_id nvarchar(max)
  DECLARE @opt_41top_item_id nvarchar(max)
  DECLARE @opt_42item_id nvarchar(max)
  DECLARE @opt_43site_id nvarchar(max)
  DECLARE @opt_44operation_id nvarchar(max)
  DECLARE @opt_45top_item_id nvarchar(max)
  DECLARE @opt_46item_id nvarchar(max)
  DECLARE @opt_47prod_type nvarchar(max)
  DECLARE @opt_48site_id nvarchar(max)
  DECLARE @opt_49operation_id nvarchar(max)
  DECLARE @opt_50top_item_id nvarchar(max)
  DECLARE @opt_51item_id nvarchar(max)
  DECLARE @opt_52prod_type nvarchar(max)
  DECLARE @opt_53site_id nvarchar(max)
  DECLARE @opt_54operation_id nvarchar(max)
  DECLARE @opt_55site_id nvarchar(max)
  DECLARE @opt_56item_id nvarchar(max)
  DECLARE @opt_57item_name nvarchar(max)
  DECLARE @opt_58cell_group nvarchar(max)
  DECLARE @opt_59site_id nvarchar(max)
  DECLARE @opt_60top_item_id nvarchar(max)
  DECLARE @opt_61item_id nvarchar(max)
  DECLARE @opt_62site_id nvarchar(max)
  DECLARE @opt_63top_item_id nvarchar(max)
  DECLARE @opt_64item_id nvarchar(max)
  DECLARE @opt_65site_id nvarchar(max)
  DECLARE @opt_66item_id nvarchar(max)
  DECLARE @opt_67item_name nvarchar(max)
  DECLARE @opt_68cell_group nvarchar(max)

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
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
      SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PRODTYPE_LT' BEGIN
      SET @p_prodtype_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_NAME' BEGIN
      SET @p_item_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FP_SITE_ID' BEGIN
      SET @p_fp_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
      SET @p_cell_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CURR_DATE_COL' BEGIN
      SET @p_curr_date_col =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DAY_INFO' BEGIN
      SET @p_day_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
      SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
      SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
      SET @p_model_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICKNAME' BEGIN
      SET @p_nickname =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICKNAME_LT' BEGIN
      SET @p_nickname_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DAY2MONTH' BEGIN
      SET @p_day2month =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DAY2WEEK' BEGIN
      SET @p_day2week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CURR_DATE_COL' BEGIN
      SET @p_curr_date_col =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
      SET @p_confirm_area =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
      SET @p_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ROUND_POINT' BEGIN
      SET @p_ROUND_POINT =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
      SET @p_cate_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  SET @v_ROUND_POINT = TRY_CONVERT(INTEGER,@p_ROUND_POINT)
  SET @v_ROUND_POINT = ISNULL(@v_ROUND_POINT, 1)

  --SELECT @v_ROUND_POINT AS 'SQL' RETURN

  SET @v_plan_date = '''' + @p_plan_date + ''''
  SET @v_plan_type = '''' + @p_plan_type + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_prod_type ='''' + @p_prod_type + ''''
  SET @v_item_name ='''' + @p_item_name + ''''
  SET @v_fp_site_id ='''' + @p_fp_site_id + ''''
  SET @v_master_id ='''' + @p_master_id + ''''

  SET @v_cell_group ='''' + @p_cell_group + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
    SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_week_info ='''' + @p_week_info + ''''
  SET @v_month_info ='''' + @p_month_info + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_line_lt ='''' + @p_line_lt + ''''
  SET @v_model_lt ='''' + @p_model_lt + ''''
  SET @v_operation_lt ='''' + @p_operation_lt + ''''
  SET @v_nickname_lt ='''' + @p_nickname_lt + ''''
  SET @v_curr_date_col ='''' + @p_curr_date_col + ''''
  SET @v_confirm_area ='''' + @p_confirm_area + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_bucket_from)
  IF @STRLEN< 1  BEGIN
    SET @opt_0bucket_from = ''
  END ELSE BEGIN
    SET @opt_0bucket_from = 'i'
  END
  SET @STRLEN = LEN(@p_bucket_from)
  IF @STRLEN< 1  BEGIN
    SET @opt_1bucket_from = ''
  END ELSE BEGIN
    SET @opt_1bucket_from = 'i'
  END
  SET @STRLEN = LEN(@p_bucket_from)
  IF @STRLEN< 1  BEGIN
    SET @opt_2bucket_from = ''
  END ELSE BEGIN
    SET @opt_2bucket_from = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4top_item_id = ''
  END ELSE BEGIN
    SET @opt_4top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5item_id = ''
  END ELSE BEGIN
    SET @opt_5item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6site_id = ''
  END ELSE BEGIN
    SET @opt_6site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7top_item_id = ''
  END ELSE BEGIN
    SET @opt_7top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8item_id = ''
  END ELSE BEGIN
    SET @opt_8item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9site_id = ''
  END ELSE BEGIN
    SET @opt_9site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END

  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11top_item_id = ''
  END ELSE BEGIN
    SET @opt_11top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_12item_id = ''
  END ELSE BEGIN
    SET @opt_12item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_13prod_type = ''
  END ELSE BEGIN
    SET @opt_13prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_14site_id = ''
  END ELSE BEGIN
    SET @opt_14site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END

  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_16top_item_id = ''
  END ELSE BEGIN
    SET @opt_16top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_17item_id = ''
  END ELSE BEGIN
    SET @opt_17item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_18prod_type = ''
  END ELSE BEGIN
    SET @opt_18prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_19site_id = ''
  END ELSE BEGIN
    SET @opt_19site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_21site_id = ''
  END ELSE BEGIN
    SET @opt_21site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_22item_id = ''
  END ELSE BEGIN
    SET @opt_22item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_23item_name = ''
  END ELSE BEGIN
    SET @opt_23item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_cell_group)
  IF @STRLEN< 1  BEGIN
    SET @opt_24cell_group = ''
  END ELSE BEGIN
    SET @opt_24cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group+' + ''%'''
  END
  SET @STRLEN = LEN(@p_bucket_from)
  IF @STRLEN< 1  BEGIN
    SET @opt_25bucket_from = ''
  END ELSE BEGIN
    SET @opt_25bucket_from = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_26site_id = ''
  END ELSE BEGIN
    SET @opt_26site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_27top_item_id = ''
  END ELSE BEGIN
    SET @opt_27top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_28item_id = ''
  END ELSE BEGIN
    SET @opt_28item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_29site_id = ''
  END ELSE BEGIN
    SET @opt_29site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_30top_item_id = ''
  END ELSE BEGIN
    SET @opt_30top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_31item_id = ''
  END ELSE BEGIN
    SET @opt_31item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_32site_id = ''
  END ELSE BEGIN
    SET @opt_32site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_33item_id = ''
  END ELSE BEGIN
    SET @opt_33item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_34item_name = ''
  END ELSE BEGIN
    SET @opt_34item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_cell_group)
  IF @STRLEN< 1  BEGIN
    SET @opt_35cell_group = ''
  END ELSE BEGIN
    SET @opt_35cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group+' + ''%'''
  END
  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_36instance_id = ''
  END ELSE BEGIN
    SET @opt_36instance_id = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_37site_id = ''
  END ELSE BEGIN
    SET @opt_37site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_38top_item_id = ''
  END ELSE BEGIN
    SET @opt_38top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_39item_id = ''
  END ELSE BEGIN
    SET @opt_39item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_40site_id = ''
  END ELSE BEGIN
    SET @opt_40site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_41top_item_id = ''
  END ELSE BEGIN
    SET @opt_41top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_42item_id = ''
  END ELSE BEGIN
    SET @opt_42item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_43site_id = ''
  END ELSE BEGIN
    SET @opt_43site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END

  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_45top_item_id = ''
  END ELSE BEGIN
    SET @opt_45top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_46item_id = ''
  END ELSE BEGIN
    SET @opt_46item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_47prod_type = ''
  END ELSE BEGIN
    SET @opt_47prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_48site_id = ''
  END ELSE BEGIN
    SET @opt_48site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END

  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_50top_item_id = ''
  END ELSE BEGIN
    SET @opt_50top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_51item_id = ''
  END ELSE BEGIN
    SET @opt_51item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_prod_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_52prod_type = ''
  END ELSE BEGIN
    SET @opt_52prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_53site_id = ''
  END ELSE BEGIN
    SET @opt_53site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_55site_id = ''
  END ELSE BEGIN
    SET @opt_55site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_56item_id = ''
  END ELSE BEGIN
    SET @opt_56item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_57item_name = ''
  END ELSE BEGIN
    SET @opt_57item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_cell_group)
  IF @STRLEN< 1  BEGIN
    SET @opt_58cell_group = ''
  END ELSE BEGIN
    SET @opt_58cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_59site_id = ''
  END ELSE BEGIN
    SET @opt_59site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_60top_item_id = ''
  END ELSE BEGIN
    SET @opt_60top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_61item_id = ''
  END ELSE BEGIN
    SET @opt_61item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_62site_id = ''
  END ELSE BEGIN
    SET @opt_62site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_63top_item_id = ''
  END ELSE BEGIN
    SET @opt_63top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_64item_id = ''
  END ELSE BEGIN
    SET @opt_64item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_65site_id = ''
  END ELSE BEGIN
    SET @opt_65site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_66item_id = ''
  END ELSE BEGIN
    SET @opt_66item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_67item_name = ''
  END ELSE BEGIN
    SET @opt_67item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_cell_group)
  IF @STRLEN< 1  BEGIN
    SET @opt_68cell_group = ''
  END ELSE BEGIN
    SET @opt_68cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group+' + ''%'''
  END

  SET @v_dSql = ''
	SET @v_dSql += '      WITH MAIN AS (' + char(10)
	SET @v_dSql += '      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SET @v_dSql += '		               , A.LOCATION, A.OPERATION_ID' + char(10)
	SET @v_dSql += '		               , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + char(10)
	SET @v_dSql += '		               , A.EQUIPMENT_ID' + char(10)
	SET @v_dSql += '		               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + char(10)
	SET @v_dSql += '		               , A.PRODUCTION_TYPE, A.MARKET' + char(10)
	SET @v_dSql += '		               , A.CATE' + char(10)
	SET @v_dSql += '	                   , ISNULL(E.SLURRY_1,F.SLURRY_1) AS BATCH_ID, ISNULL(E.SLURRY_2,F.SLURRY_2) AS BATCH_ID_2' + char(10)
	SET @v_dSql += '		               , ISNULL(E.PRE_DISPERSION_ID,F.PRE_DISPERSION_ID) AS PRE_DISPERSION_ID' + char(10)
	SET @v_dSql += '           			   , ISNULL(E.PRE_DISPERSION_NAME,F.PRE_DISPERSION_NAME) AS PRE_DISPERSION_NAME' + char(10)
	SET @v_dSql += '                       , ISNULL(E.ACTIVE_MATERIAL_1,F.ACTIVE_MATERIAL_1) AS ACTIVE_MATERIAL_1' + char(10)
	SET @v_dSql += '                       , ISNULL(E.ACTIVE_MATERIAL_2,F.ACTIVE_MATERIAL_2) AS ACTIVE_MATERIAL_2' + char(10)
	SET @v_dSql += '                       , ISNULL(E.ACTIVE_MATERIAL_3,F.ACTIVE_MATERIAL_3) AS ACTIVE_MATERIAL_3' + char(10)
	SET @v_dSql += '                       , ISNULL(E.BINDER_1,F.BINDER_1) AS BINDER_1' + char(10)
	SET @v_dSql += '                       , ISNULL(E.BINDER_2,F.BINDER_2) AS BINDER_2' + char(10)
	SET @v_dSql += '                       , ISNULL(E.BINDER_3,F.BINDER_3) AS BINDER_3' + char(10)
	SET @v_dSql += '                       , ISNULL(E.CMC,F.CMC) AS CMC' + char(10)
	SET @v_dSql += '                       , ISNULL(E.PROD_VERSION,F.PROD_VERSION) AS VERSION' + char(10)
	SET @v_dSql += '                       , G.FOIL_CODE  -- modify' + char(10)
	SET @v_dSql += '		               , G.FOIL  -- modify' + char(10)
	SET @v_dSql += '		               , Z.DAILY_CAPA_PPM  AS DC_PPM' + char(10)
	SET @v_dSql += '	                   , ISNULL(D.DAILY_CAPA_M, H.DAILY_CAPA_M) AS DC_M' + char(10)
	SET @v_dSql += '	                   , ISNULL(D.DAILY_CAPA_EA, H.DAILY_CAPA_EA) AS DC_CELL' + char(10)
	SET @v_dSql += '	                   , ISNULL(D.DAILY_CAPA_KG, H.DAILY_CAPA_KG) AS DC_KG' + char(10)
	SET @v_dSql += '	                   , ISNULL(D.DAILY_CAPA_JR, H.DAILY_CAPA_JR) AS DC_JR' + char(10)
	SET @v_dSql += '	                   , ISNULL(D.DAILY_CAPA_BATCH, H.DAILY_CAPA_BATCH) AS DC_BATCH' + char(10)
	SET @v_dSql += '	                   , CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''N'' ELSE ISNULL(D.DC_FLAG, H.DC_FLAG) END AS DC_FLAG' + char(10)
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



    IF isnull(@p_day_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단

				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @max_loop_cnt) +char(10)
				--SET @v_dSql += @p_MONTH_INFO  +char(10)
				--SET @v_dSql += '  KKKKKKKKKK ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_columns +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_row +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@p_MONTH_INFO +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_MONTH_INFO +char(10)
				--SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_delimiter +char(10)
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END
				-- //SAMPLE SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
    SET @v_dSql += '               , M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)
    SET @v_dSql += '               , M' +TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL' + char(10)
    SET @v_dSql += '               , M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR' + char(10)
    SET @v_dSql += '               , M' +TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)
    SET @v_dSql += '               , M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ' + char(10)
    SET @v_dSql += '               , M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR' + char(10)
				--SET @mst_loop_cnt =  @mst_loop_cnt + 1
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
    SET @v_dSql += '               , W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)
    SET @v_dSql += '               , W' +TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL' + char(10)
    SET @v_dSql += '               , W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR' + char(10)
    SET @v_dSql += '               , W' +TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)
    SET @v_dSql += '               , W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ' + char(10)
    SET @v_dSql += '               , W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)

				-- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)
    SET @v_dSql += '               , D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)
    SET @v_dSql += '               , D' +TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL' + char(10)
    SET @v_dSql += '               , D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR' + char(10)
    SET @v_dSql += '               , D' +TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)
    SET @v_dSql += '               , D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ' + char(10)
    SET @v_dSql += '               , D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR' + char(10)            				SET @v_dSql +='         , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_2 +''' THEN (CASE WHEN D.CATE_ID = ''P_IN'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY  ' + char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt
		
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
    SET @v_dSql += '               , T' +TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''

  SET @v_dSql += '	 , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '		               , A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '		               , A.DATA_TYPE'+char(10)
  SET @v_dSql += '	         		   , ISNULL(B.LINE_SEQ, 9999) LINE_SEQ'+char(10)
  SET @v_dSql += '	         		   , A.DPP_OMIT_ZERO, A.MPP_OMIT_ZERO, A.WPP_OMIT_ZERO, A.RESULT_OMIT_ZERO '+char(10)
  SET @v_dSql += '      		FROM ('+char(10)
  SET @v_dSql += '		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '		               , A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '		               , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		               , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME'+char(10)
  SET @v_dSql += '		               , A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE'+char(10)
  SET @v_dSql += '		               , B.CATEGORY_NAME AS CATE'+char(10)

    IF isnull(@p_day_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END--MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END--MONTH_NAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END--MONTH_COUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END--M_VALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END
				
								-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				-- //SAMPLE SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
    --SET @v_dSql += '               , M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)
		SET @v_dSql += '               , SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_M)' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_M)' + char(10)
		SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_M)' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_M)' + char(10)
		SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_M)' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_M)' + char(10)
		SET @v_dSql += '                                                            					  ELSE CEILING(A.RESULT_OUT_QTY_M) END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)
        SET @v_dSql += '               , SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_CELL)' + char(10)
        SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_CELL)' + char(10)
		SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_CELL)' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_CELL)' + char(10)
		SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_WPP_I'' THEN CEILING(A.WPP_IN_QTY_CELL)' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_CELL)' + char(10)
        SET @v_dSql += '                                                            					  ELSE CEILING(A.RESULT_OUT_QTY_CELL) END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL' + char(10)
        SET @v_dSql += '               , SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0 + '''  THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_JR)' + char(10)
        SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_JR)' + char(10)
        SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_JR)' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_JR)' + char(10)
		SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_JR)' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_JR)' + char(10)
		SET @v_dSql += '                                                            					  ELSE CEILING(A.RESULT_OUT_QTY_JR) END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR' + char(10)
		SET @v_dSql += '               , SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0 + '''  THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_OUT'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
		SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN ROUND(A.MPP_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN ROUND(A.MPP_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
		SET @v_dSql += '               																  WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN ROUND(A.WPP_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
		SET @v_dSql += '                                                            					  WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN ROUND(A.WPP_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
		SET @v_dSql += '                                                            					  ELSE ROUND(A.RESULT_OUT_QTY_BATCH,'+@v_ROUND_POINT +') END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)
		SET @v_dSql += '               , NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ' + char(10)
		SET @v_dSql += '               , NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR' + char(10)
				--SET @mst_loop_cnt =  @mst_loop_cnt + 1
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
  SET @v_dSql += '               , SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_M)' + char(10)
  SET @v_dSql += '                                                                					WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_M)' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_M)' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_M)' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_M)' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_M)' + char(10)
  SET @v_dSql += '                                                                					ELSE CEILING(A.RESULT_OUT_QTY_M) END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)
  SET @v_dSql += '               , SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                                					WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_CELL)' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_CELL)' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                                					ELSE CEILING(A.RESULT_OUT_QTY_CELL) END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL' + char(10)
  SET @v_dSql += '               , SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_JR)' + char(10)
  SET @v_dSql += '                                                                					WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_JR)' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_JR)' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_JR)' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_JR)' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_JR)' + char(10)
  SET @v_dSql += '                                                                					ELSE CEILING(A.RESULT_OUT_QTY_JR) END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR' + char(10)
  SET @v_dSql += '               , SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                                					WHEN B.CATEGORY_ID=''P_OUT'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN ROUND(A.MPP_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN ROUND(A.MPP_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '               																  	WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN ROUND(A.WPP_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                            					  	WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN ROUND(A.WPP_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                                					ELSE ROUND(A.RESULT_OUT_QTY_BATCH,'+@v_ROUND_POINT +') END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + 'BATCH' + char(10)
  SET @v_dSql += '               , NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ' + char(10)
  SET @v_dSql += '               , NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)

				-- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)
  SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_3 +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_M)' + char(10)
  SET @v_dSql += '                                                                                      			 WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_M)' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_M)' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_M)' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_M)' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_M)' + char(10)
  SET @v_dSql += '                                                                                      			 ELSE CEILING(A.RESULT_OUT_QTY_M) END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)
  SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_3 +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                                                      			 WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_CELL)' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_CELL)' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_CELL)' + char(10)
  SET @v_dSql += '                                                                                      			 ELSE CEILING(A.RESULT_OUT_QTY_CELL) END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL' + char(10)
  SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_3 +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_JR)' + char(10)
  SET @v_dSql += '                                                                                      			 WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_JR)' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN CEILING(A.MPP_IN_QTY_JR)' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN CEILING(A.MPP_OUT_QTY_JR)' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN CEILING(A.WPP_IN_QTY_JR)' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN CEILING(A.WPP_OUT_QTY_JR)' + char(10)
  SET @v_dSql += '                                                                                      			 ELSE CEILING(A.RESULT_OUT_QTY_JR) END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR' + char(10)
  SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_3 +'''THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                                                      			 WHEN B.CATEGORY_ID=''P_OUT'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_MPP_IN'' THEN ROUND(A.MPP_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_MPP_OUT'' THEN ROUND(A.MPP_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '               																  					 WHEN B.CATEGORY_ID=''P_WPP_IN'' THEN ROUND(A.WPP_IN_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                            					  					 WHEN B.CATEGORY_ID=''P_WPP_OUT'' THEN ROUND(A.WPP_OUT_QTY_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                                                      			 ELSE ROUND(A.RESULT_OUT_QTY_BATCH,'+@v_ROUND_POINT +') END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)
  SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_3 +''' THEN A.SEQ ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ' + char(10)
  SET @v_dSql += '               , null AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR' + char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt
		
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
  SET @v_dSql += '               , SUM(CASE WHEN C.ISO_YYYYWW='''+@sub_param_0+ ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN ROUND(A.TOTAL_BATCH,'+@v_ROUND_POINT +')' + char(10)
  SET @v_dSql += '                                                                ELSE 0 END) ELSE 0 END) AS T' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''

  SET @v_dSql += '    , B.CATEGORY_ID, B.CATEGORY_ORDER' +char(10)
  SET @v_dSql += ' 		               , ''DATA'' AS DATA_TYPE' +char(10)
  SET @v_dSql += ' 		               ,  CASE WHEN A.DPPTYPE = 0 AND ( PATINDEX( ''P_IN%'', B.CATEGORY_ID) > 0 OR  PATINDEX( ''P_OUT%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS DPP_OMIT_ZERO' +char(10)
  SET @v_dSql += ' 					   ,  CASE WHEN A.MPPTYPE = 0 AND ( PATINDEX( ''P_MPP%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS MPP_OMIT_ZERO' +char(10)
  SET @v_dSql += ' 					   ,  CASE WHEN A.WPPTYPE = 0 AND ( PATINDEX( ''P_WPP%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS WPP_OMIT_ZERO' +char(10)
  SET @v_dSql += ' 					   ,  CASE WHEN A.RESULTTYPE = 0 AND ( PATINDEX( ''P_RESULT%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS RESULT_OMIT_ZERO' +char(10)
  SET @v_dSql += ' 		          FROM (' +char(10)
  SET @v_dSql += ' 		              	SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' +char(10)
  SET @v_dSql += ' 								, A.LOCATION, A.OPERATION_ID' +char(10)
  SET @v_dSql += ' 								, A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE' +char(10)
  SET @v_dSql += ' 								, A.EQUIPMENT_ID' +char(10)
  SET @v_dSql += ' 								, A.PLAN_DATE' +char(10)
  SET @v_dSql += ' 								, A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME' +char(10)
  SET @v_dSql += ' 								, A.PRODUCTION_TYPE' +char(10)
  SET @v_dSql += ' 								, A.MARKET' +char(10)
  SET @v_dSql += ' 								, A.SEQ' +char(10)
  SET @v_dSql += ' 								, A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR' +char(10)
  SET @v_dSql += ' 								, A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 								, A.MPP_IN_QTY_BATCH, A.MPP_IN_QTY, A.MPP_IN_QTY_M, A.MPP_IN_QTY_CELL, A.MPP_IN_QTY_JR' +char(10)
  SET @v_dSql += ' 								, A.MPP_OUT_QTY_BATCH, A.MPP_OUT_QTY, A.MPP_OUT_QTY_M, A.MPP_OUT_QTY_CELL, A.MPP_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 								, A.WPP_IN_QTY_BATCH, A.WPP_IN_QTY, A.WPP_IN_QTY_M, A.WPP_IN_QTY_CELL, A.WPP_IN_QTY_JR' +char(10)
  SET @v_dSql += ' 								, A.WPP_OUT_QTY_BATCH, A.WPP_OUT_QTY, A.WPP_OUT_QTY_M, A.WPP_OUT_QTY_CELL, A.WPP_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 								, A.RESULT_OUT_QTY_BATCH,  A.RESULT_OUT_QTY, A.RESULT_OUT_QTY_M, A.RESULT_OUT_QTY_CELL, A.RESULT_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 								, A.TOTAL_BATCH' +char(10)
  SET @v_dSql += ' 								, A.BGCOLOR' +char(10)
  SET @v_dSql += ' 								, C.PROD_VERSION_TYPE' +char(10)
  SET @v_dSql += ' 								, A.DPPTYPE, A.MPPTYPE, A.WPPTYPE, A.RESULTTYPE ' +char(10)
  SET @v_dSql += ' 		                   FROM (' +char(10)
  SET @v_dSql += ' 					               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' +char(10)
  SET @v_dSql += ' 					                   , A.LOCATION, A.OPERATION_ID' +char(10)
  SET @v_dSql += ' 					                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE' +char(10)
  SET @v_dSql += ' 					                   , A.EQUIPMENT_ID' +char(10)
  SET @v_dSql += ' 					                   , A.PLAN_DATE' +char(10)
  SET @v_dSql += ' 					                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' +char(10)
  SET @v_dSql += ' 					                   , A.PRODUCTION_TYPE' +char(10)
  SET @v_dSql += ' 					                   , A.MARKET' +char(10)
  SET @v_dSql += ' 					                   , A.SEQ' +char(10)
  SET @v_dSql += ' 					                   , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR' +char(10)
  SET @v_dSql += ' 					                   , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 					                   , A.MPP_IN_QTY_BATCH, A.MPP_IN_QTY, A.MPP_IN_QTY_M, A.MPP_IN_QTY_CELL, A.MPP_IN_QTY_JR' +char(10)
  SET @v_dSql += ' 					                   , A.MPP_OUT_QTY_BATCH, A.MPP_OUT_QTY, A.MPP_OUT_QTY_M, A.MPP_OUT_QTY_CELL, A.MPP_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 					                   , A.WPP_IN_QTY_BATCH, A.WPP_IN_QTY, A.WPP_IN_QTY_M, A.WPP_IN_QTY_CELL, A.WPP_IN_QTY_JR' +char(10)
  SET @v_dSql += ' 					                   , A.WPP_OUT_QTY_BATCH, A.WPP_OUT_QTY, A.WPP_OUT_QTY_M, A.WPP_OUT_QTY_CELL, A.WPP_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 					                   , A.RESULT_OUT_QTY_BATCH,  A.RESULT_OUT_QTY, A.RESULT_OUT_QTY_M, A.RESULT_OUT_QTY_CELL, A.RESULT_OUT_QTY_JR' +char(10)
  SET @v_dSql += ' 					                   , A.TOTAL_BATCH' +char(10)
  SET @v_dSql += ' 					                   , NULL AS BGCOLOR' +char(10)
  SET @v_dSql += ' 					                   , SUM( ISNULL(A.ADJUST_IN_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' +char(10)
  SET @v_dSql += ' 																								, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS DPPTYPE' +char(10)
  SET @v_dSql += ' 										, SUM( ISNULL(A.MPP_IN_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' +char(10)
  SET @v_dSql += ' 																								, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS MPPTYPE' +char(10)
  SET @v_dSql += ' 										, SUM( ISNULL(A.MPP_IN_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' +char(10)
  SET @v_dSql += ' 																								, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS WPPTYPE' +char(10)
  SET @v_dSql += ' 										, SUM( ISNULL(A.RESULT_OUT_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' +char(10)
  SET @v_dSql += ' 																									, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS RESULTTYPE' +char(10)
  SET @v_dSql += '						              WHERE  INSTANCE_ID      ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '						              AND    FP_PLAN_ID       ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '						              AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'LK', @p_prod_type)) + char(10)

  SET @v_dSql += '						              AND 	  ( ISNULL(A.ADJUST_IN_QTY_BATCH,0)  <> 0 OR ISNULL(A.MPP_IN_QTY_BATCH,0)  <> 0 OR ISNULL(A.WPP_IN_QTY_BATCH,0)  <> 0 OR ISNULL(A.RESULT_OUT_QTY_BATCH,0)  <> 0 )'+char(10)
  SET @v_dSql += '							      ) A'+char(10)
  SET @v_dSql += '								  INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						              ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '						              AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '						              AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '						              AND    A.TOP_ITEM_ID    = B.ITEM_ID'+char(10)

  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AND    ISNULL(B.NICK_NAME,''-'')' , 'EQ', @p_nickname_lt)) + char(10)

  SET @v_dSql += '						          INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						              ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
  SET @v_dSql += '						              AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
  SET @v_dSql += '						              AND    A.SITE_ID        = C.SITE_ID'+char(10)
  SET @v_dSql += '						              AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
  SET @v_dSql += '						              AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
  SET @v_dSql += '						              AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
  SET @v_dSql += '						              AND    A.LINE_ID        = C.LINE_ID'+char(10)
  SET @v_dSql += '						              AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '						              WHERE 1=1'+char(10)
  
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AND  B.NICK_NAME' , 'LK', @p_nickname)) + char(10)

  SET @v_dSql += '			          ) A'+char(10)
  SET @v_dSql += '			          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			          ON  1=1'+char(10)
  SET @v_dSql += '			          AND CONVERT(VARCHAR, C.DT, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '			          AND A.PLAN_DATE = C.DT'+char(10)
  SET @v_dSql += '			          INNER JOIN ('+char(10)
  SET @v_dSql += '				          	  SELECT *'+char(10)
  SET @v_dSql += '				              FROM ('+char(10)

  DECLARE @bInqty integer = 0
  DECLARE @bOutqty  integer = 0
  DECLARE @bMppInqty  integer = 0
  DECLARE @bMppOutqty integer = 0
  DECLARE @bWppInqty integer = 0
  DECLARE @bWppOutqty integer = 0
  DECLARE @bResultIn integer = 0
  DECLARE @bResultOut integer = 0
  DECLARE @bResult integer = 0
  DECLARE @bSeq integer = 0
  DECLARE @bMemo  integer = 0
  DECLARE @bOffTime integer = 0
  DECLARE @bCapa  integer = 0
  DECLARE @bSetup  integer = 0

  DECLARE @bPc integer = 0
  DECLARE @bJr  integer = 0
  DECLARE @bCell  integer = 0
  DECLARE @bBatch integer = 0
		      
  DECLARE @bTotal integer = 0
  DECLARE @bSubTotal integer = 0      

      IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			  WHILE @mst_loop_cnt < @max_loop_cnt
				  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
					SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

					SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info			    ,@v_delimiter, @mst_loop_cnt);
					SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				    IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				    IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				    IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				    IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- D0

					--SET @v_dSql +=@tmp_column + char(10)
					--SET @v_dSql +=@sub_param_0 + char(10)
					--SET @v_dSql +=@sub_param_1 + char(10)
					--SET @v_dSql +=@sub_param_2 + char(10)
					--SET @v_dSql +=@sub_param_3 + char(10)
					
					IF isnull(@sub_param_0,'') = 'chk_inqty' and isnull(@sub_param_1,'')='true' BEGIN
						SET @bInqty = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_outqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_mpp_outqty' BEGIN
						SET @bOutqty = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_mpp_inqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_wpp_inqty' BEGIN
						SET @bMppInqty = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_mpp_outqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_wpp_outqty' BEGIN
						SET @bMppOutqty = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_wpp_inqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_inqty' BEGIN
						SET @bWppInqty = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_wpp_outqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_outqty' BEGIN
						SET @bWppOutqty = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_result_in' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_result' BEGIN
						SET @bResultIn = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_result_out' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_cell' BEGIN
						SET @bResultOut = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_result' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_uom' BEGIN
						SET @bResult = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_seq' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_total' BEGIN
						SET @bSeq = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_memo' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_subTotal' BEGIN
						SET @bMemo = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_off' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bOffTime = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_capa' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bCapa = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_setup' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bSetup = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_pc' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bPc = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_jr' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bJr = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_cell' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bCell = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_batch' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bBatch = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_total' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bTotal = 1
					END else IF isnull(@sub_param_0,'') = 'chk_subTotal' and isnull(@sub_param_1,'')='true' BEGIN--ELSE IF @tmp_column = 'chk_target' BEGIN
						SET @bSubTotal = 1
					END 
			END-- END OF WHILE

			SET @v_dSql += '	SELECT ''X'' AS CATEGORY_ID, ''X'' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER '+char(10)
        							
					IF @bMppInqty = 1 BEGIN
						 SET @v_dSql += 'UNION ALL                                                                                           ' + char(10)
						 SET @v_dSql += 'SELECT ''P_MPP_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER			' + char(10)
					END
					
					IF @bMppOutqty = 1 BEGIN
						 SET @v_dSql += 'UNION ALL                                                                                                  ' + char(10)
						 SET @v_dSql += 'SELECT ''P_MPP_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER       ' + char(10)
					END
					
					IF @bWppInqty = 1 BEGIN
						 SET @v_dSql += 'UNION ALL                                                                                                  ' + char(10)
						 SET @v_dSql += 'SELECT ''P_WPP_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER         ' + char(10)
					END
					
					IF @bWppOutqty = 1 BEGIN
						 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
						 SET @v_dSql += 'SELECT ''P_WPP_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER       ' + char(10)
					END
					
					IF @bInqty = 1 BEGIN
						 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
						 SET @v_dSql += 'SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER            ' + char(10)	
					END
					
					IF @bOutqty = 1 BEGIN
						 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
						 SET @v_dSql += 'SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER          ' + char(10)
					END
					
					IF @bResult = 1 BEGIN
						 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
						 SET @v_dSql += 'SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER            ' + char(10)
			
      			
							
	      	END ELSE BEGIN
	      		
	      			 SET @v_dSql += 'SELECT ''P_MPP_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER			' + char(10)
					 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
					 SET @v_dSql += 'SELECT ''P_MPP_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER       ' + char(10)
					 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
					 SET @v_dSql += 'SELECT ''P_WPP_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER         ' + char(10)
					 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
					 SET @v_dSql += 'SELECT ''P_WPP_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER       ' + char(10)
					 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
					 SET @v_dSql += 'SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER            ' + char(10)
					 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
					 SET @v_dSql += 'SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER          ' + char(10)
					 SET @v_dSql += 'UNION ALL                                                                                  ' + char(10)
					 SET @v_dSql += 'SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER            ' + char(10)
				
	      	END

			END


  SET @v_dSql += '				              ) A'+char(10)
  SET @v_dSql += '				              WHERE CATEGORY_ID <> ''X'''+char(10)
  SET @v_dSql += '			          ) B'+char(10)
  SET @v_dSql += '			          ON 1=1'+char(10)
  SET @v_dSql += '             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                 , A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                 , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME'+char(10)
  SET @v_dSql += '                 , A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE'+char(10)
  SET @v_dSql += '                 , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                 , A.DPPTYPE, A.MPPTYPE, A.WPPTYPE, A.RESULTTYPE'+char(10)
  SET @v_dSql += '		    	) A'+char(10)
  SET @v_dSql += '		    	LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '							              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '							                   , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '							                   , A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '							                   , ROUND(A.DAILY_CAPA_M,0) AS DAILY_CAPA_M'+char(10)
  SET @v_dSql += '							                   , ROUND(A.DAILY_CAPA_EA,0) AS DAILY_CAPA_EA'+char(10)
  SET @v_dSql += '							                   , ROUND(A.DAILY_CAPA_KG,0) AS DAILY_CAPA_KG'+char(10)
  SET @v_dSql += '							                   , ROUND(A.DAILY_CAPA_JR,0) AS DAILY_CAPA_JR'+char(10)
  SET @v_dSql += '							                   , ROUND(A.DAILY_CAPA_BATCH,@ROUND_POINT@) AS DAILY_CAPA_BATCH'+char(10)
  SET @v_dSql += '							                   , CAPA_VALIDATION_FLAG AS DC_FLAG'+char(10)
  SET @v_dSql += '							                   , A.CALC_TYPE'+char(10)
  SET @v_dSql += '							              FROM   @AMEND_CAPA_TABLE@ A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '							              WHERE  1=1'+char(10)
  SET @v_dSql += '							              AND	A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '							              AND    A.FP_PLAN_ID  ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)

  SET @v_dSql += '							          ) D'+char(10)
  SET @v_dSql += '							          ON  A.COMPANY_ID      = D.COMPANY_ID'+char(10)
  SET @v_dSql += '							          AND A.DIVISION_ID     = D.DIVISION_ID'+char(10)
  SET @v_dSql += '							          AND A.SITE_ID         = D.SITE_ID'+char(10)
  SET @v_dSql += '							          AND A.PLANT_ID        = D.PLANT_ID'+char(10)
  SET @v_dSql += '							          AND A.FACTORY_ID      = D.FACTORY_ID'+char(10)
  SET @v_dSql += '							          AND A.LOCATION        = D.LOCATION'+char(10)
  SET @v_dSql += '							          AND A.OPERATION_ID    = D.OPERATION_ID'+char(10)
  SET @v_dSql += '							          AND A.LINE_ID         = D.LINE_ID'+char(10)
  SET @v_dSql += '							          AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '							          AND A.EQUIPMENT_ID    = D.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '							          --AND A.TOP_ITEM_ID     = D.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '							          AND A.ITEM_ID         = D.ITEM_ID'+char(10)
  SET @v_dSql += '							          AND (CASE WHEN (A.PRODUCTION_TYPE = ''TEST'' OR A.PRODUCTION_TYPE = ''S-TEST'') THEN ''TEST'' ELSE ''MASS'' END) = D.CALC_TYPE'+char(10)
  SET @v_dSql += '							          LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '		       										SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, MAX(A.PAN_PROD_VERSION)  AS PROD_VERSION'+char(10)
  SET @v_dSql += '															, A.PC_ITEM_ID'+char(10)
  SET @v_dSql += '															, NULL AS BATCH_ID'+char(10)
  SET @v_dSql += '															, MAX(CASE WHEN A.UI_COLUMN = ''Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1'+char(10)
  SET @v_dSql += '															, MAX(CASE WHEN A.UI_COLUMN = ''Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 1'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 2'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 3'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Binder 3'' THEN A.DESCRIPTION END) AS BINDER_3'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.CLASS_NAME = ''Pre Dispersion Slurry'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.CLASS_NAME = ''Pre Dispersion Slurry'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.CLASS_NAME = ''CMC'' then A.DESCRIPTION END) AS CMC'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 2'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2'+char(10)
  SET @v_dSql += '						FROM   SCM_PANCAKE_MATERIAL_V A  WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						WHERE  1=1'+char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PC_ITEM_ID' , 'LK', @p_item_id)) + char(10)

  SET @v_dSql += '						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, A.PC_ITEM_ID'+char(10)
  SET @v_dSql += '		          ) E'+char(10)
  SET @v_dSql += '		          ON  A.COMPANY_ID      = E.COMPANY_ID'+char(10)
  SET @v_dSql += '		          AND A.DIVISION_ID     = E.DIVISION_ID'+char(10)
  SET @v_dSql += '		          AND A.SITE_ID         = E.SITE_ID'+char(10)
  SET @v_dSql += '		          AND A.PLANT_ID        = E.PLANT_ID'+char(10)
  SET @v_dSql += '		          AND A.FACTORY_ID    	= E.FACTORY_ID'+char(10)
  SET @v_dSql += '		          AND A.ITEM_ID         = E.PC_ITEM_ID'+char(10)
  SET @v_dSql += '		          AND A.PROD_VERSION_TYPE = E.PROD_VERSION_TYPE'+char(10)
  SET @v_dSql += '		          AND (CASE WHEN (A.PRODUCTION_TYPE = ''TEST'' OR A.PRODUCTION_TYPE = ''S-TEST'') THEN ''TEST'' ELSE ''MASS'' END) = E.PROD_TYPE'+char(10)
  SET @v_dSql += '		          LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '		          		SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, MAX(A.PAN_PROD_VERSION)  AS PROD_VERSION'+char(10)
  SET @v_dSql += '								, A.PC_ITEM_ID'+char(10)
  SET @v_dSql += '								, NULL AS BATCH_ID'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 1'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 2'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 3'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Binder 3'' THEN A.DESCRIPTION END) AS BINDER_3'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.CLASS_NAME = ''Pre Dispersion Slurry'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.CLASS_NAME = ''Pre Dispersion Slurry'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.CLASS_NAME = ''CMC'' then A.DESCRIPTION END) AS CMC'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1'+char(10)
  SET @v_dSql += '								, MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 2'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2'+char(10)
  SET @v_dSql += '						FROM   SCM_PANCAKE_MATERIAL_V A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						WHERE  1=1'+char(10)

    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PC_ITEM_ID' , 'LK', @p_item_id)) + char(10)

  SET @v_dSql += '						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, A.PC_ITEM_ID'+char(10)
  SET @v_dSql += '		          ) F'+char(10)
  SET @v_dSql += '		          ON  A.COMPANY_ID      = F.COMPANY_ID'+char(10)
  SET @v_dSql += '		          AND A.DIVISION_ID     = F.DIVISION_ID'+char(10)
  SET @v_dSql += '		          AND A.SITE_ID         = F.SITE_ID'+char(10)
  SET @v_dSql += '		          AND A.PLANT_ID        = F.PLANT_ID'+char(10)
  SET @v_dSql += '		          AND A.FACTORY_ID    	= F.FACTORY_ID'+char(10)
  SET @v_dSql += '		          AND A.ITEM_ID         = F.PC_ITEM_ID'+char(10)
  SET @v_dSql += '		          AND A.PROD_VERSION_TYPE = F.PROD_VERSION_TYPE'+char(10)
  SET @v_dSql += '		          AND (CASE WHEN (A.PRODUCTION_TYPE = ''TEST'' OR A.PRODUCTION_TYPE = ''S-TEST'') THEN ''TEST'' ELSE ''MASS'' END) <> F.PROD_TYPE'+char(10)
  SET @v_dSql += '							          LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '							            			SELECT   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'+char(10)
  SET @v_dSql += '													       	, MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/A.TACT_TIME, 0) ELSE 0 END) DAILY_CAPA_PPM'+char(10)
  SET @v_dSql += '					       								 	, MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/(A.TACT_TIME*2), 0) ELSE 0 END) DAILY_CAPA_PPM2'+char(10)
  SET @v_dSql += '													FROM SCM_TACT_TIME_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '													WHERE  1=1'+char(10)

      SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)

  SET @v_dSql += '										            AND    A.MONTH = SUBSTRING('+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ',1,6)'+char(10)
  SET @v_dSql += '													GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'+char(10)
  SET @v_dSql += '							          ) Z'+char(10)
  SET @v_dSql += '							          ON  A.COMPANY_ID      = Z.COMPANY_ID'+char(10)
  SET @v_dSql += '							          AND A.DIVISION_ID     = Z.DIVISION_ID'+char(10)
  SET @v_dSql += '							          AND A.SITE_ID         = Z.SITE_ID'+char(10)
  SET @v_dSql += '							          AND A.PLANT_ID        = Z.PLANT_ID'+char(10)
  SET @v_dSql += '							          AND A.FACTORY_ID      = Z.FACTORY_ID'+char(10)
  SET @v_dSql += '							          AND A.OPERATION_ID    = Z.OPERATION_ID'+char(10)
  SET @v_dSql += '							          AND A.LINE_ID         = Z.LINE_ID'+char(10)
  SET @v_dSql += '							          AND A.ELECTRODE_TYPE  = Z.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '							          AND A.ITEM_ID         = Z.ITEM_ID'+char(10)
  SET @v_dSql += '							          	LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '							                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_CODE, A.FOIL, A.PROD_VERSION_TYPE, A.LINE_ID'+char(10)
  SET @v_dSql += '															FROM   ('+char(10)
  SET @v_dSql += '																		SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID'+char(10)
  SET @v_dSql += '																			   ,ROW_NUMBER() OVER ( 	PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID'+char(10)
  SET @v_dSql += '																										ORDER BY V.APPLY_DATE DESC )	 AS NUM'+char(10)
  SET @v_dSql += '																		FROM  	SCM_ITEM_FOIL_M        A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '																			   ,FP_PROD_VERSION_M      V WITH(NOLOCK)'+char(10)
  SET @v_dSql += '																			   ,SCM_ITEM_M             B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '																			   ,SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '																		WHERE 1=1'+char(10)
  SET @v_dSql += '																		AND   A.FACTORY_ID    = V.FACTORY_ID'+char(10)
  SET @v_dSql += '																		AND   A.MODEL_ID      = V.MODEL_ID'+char(10)
  SET @v_dSql += '																		AND   A.ITEM_ID       = V.ITEM_ID'+char(10)
  SET @v_dSql += '																		AND   A.PROD_VERSION  = V.PROD_VERSION'+char(10)
  SET @v_dSql += '																		AND   A.PROD_SEQ      = V.PROD_SEQ'+char(10)
  SET @v_dSql += '																		AND   A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '																		AND   A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '																		AND   A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '																		AND   A.FOIL_ID = B.ITEM_ID'+char(10)
  SET @v_dSql += '																		AND   A.COMPANY_ID = C.COMPANY_ID'+char(10)
  SET @v_dSql += '																		AND   A.DIVISION_ID = C.DIVISION_ID'+char(10)
  SET @v_dSql += '																		AND   A.SITE_ID = C.SITE_ID'+char(10)
  SET @v_dSql += '																		AND   A.PLANT_ID = C.PLANT_ID'+char(10)
  SET @v_dSql += '																		AND   A.FACTORY_ID = C.FACTORY_ID'+char(10)
  SET @v_dSql += '																		AND   A.ITEM_ID = C.ITEM_ID'+char(10)

        SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)

  SET @v_dSql += '															) A'+char(10)
  SET @v_dSql += '															WHERE  NUM = 1'+char(10)
  SET @v_dSql += '							                              ) G'+char(10)
  SET @v_dSql += '							              ON 1=1'+char(10)
  SET @v_dSql += '							              AND A.COMPANY_ID      = G.COMPANY_ID'+char(10)
  SET @v_dSql += '					  			          AND A.DIVISION_ID     = G.DIVISION_ID'+char(10)
  SET @v_dSql += '					  			          AND A.SITE_ID         = G.SITE_ID'+char(10)
  SET @v_dSql += '					  			          AND A.PLANT_ID        = G.PLANT_ID'+char(10)
  SET @v_dSql += '					  			          AND A.FACTORY_ID      = G.FACTORY_ID'+char(10)
  SET @v_dSql += '					  			          AND A.LINE_ID         = G.LINE_ID'+char(10)
  SET @v_dSql += '						              	  AND A.ITEM_ID         = G.ITEM_ID'+char(10)
  SET @v_dSql += '							              AND A.PROD_VERSION_TYPE = G.PROD_VERSION_TYPE'+char(10)
  SET @v_dSql += '							          LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '					        					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '					          						 , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '					          						 --, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '					          						 , A.ITEM_ID'+char(10)
  SET @v_dSql += '							          						 , MAX(ROUND(A.DAILY_CAPA_M,0)) AS DAILY_CAPA_M'+char(10)
  SET @v_dSql += '							          						 , MAX(ROUND(A.DAILY_CAPA_EA,0)) AS DAILY_CAPA_EA'+char(10)
  SET @v_dSql += '							          						 , MAX(ROUND(A.DAILY_CAPA_KG,0)) AS DAILY_CAPA_KG'+char(10)
  SET @v_dSql += '							          						 , MAX(ROUND(A.DAILY_CAPA_JR,0)) AS DAILY_CAPA_JR'+char(10)
  SET @v_dSql += '							          						 , MAX(ROUND(A.DAILY_CAPA_BATCH,3)) AS DAILY_CAPA_BATCH'+char(10)
  SET @v_dSql += '							          						 , MAX(CAPA_VALIDATION_FLAG) AS DC_FLAG'+char(10)
  SET @v_dSql += '											              FROM   @AMEND_CAPA_TABLE@ A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '											              WHERE  1=1'+char(10)
  SET @v_dSql += '											              AND 	 A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '											              AND    A.FP_PLAN_ID  ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)

          SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)

  SET @v_dSql += '									        					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '									          						   , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '									          						   --, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '									          						   , A.ITEM_ID'+char(10)
  SET @v_dSql += '									          ) H'+char(10)
  SET @v_dSql += '									          ON  A.COMPANY_ID      = H.COMPANY_ID'+char(10)
  SET @v_dSql += '									          AND A.DIVISION_ID     = H.DIVISION_ID'+char(10)
  SET @v_dSql += '									          AND A.SITE_ID         = H.SITE_ID'+char(10)
  SET @v_dSql += '									          AND A.PLANT_ID        = H.PLANT_ID'+char(10)
  SET @v_dSql += '									          AND A.FACTORY_ID      = H.FACTORY_ID'+char(10)
  SET @v_dSql += '									          AND A.LOCATION        = H.LOCATION'+char(10)
  SET @v_dSql += '									          AND A.OPERATION_ID    = H.OPERATION_ID'+char(10)
  SET @v_dSql += '									          AND A.LINE_ID         = H.LINE_ID'+char(10)
  SET @v_dSql += '									          AND A.ELECTRODE_TYPE  = H.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '									          AND A.EQUIPMENT_ID    = H.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '									          AND A.ITEM_ID         = H.ITEM_ID'+char(10)
  SET @v_dSql += '		  		LEFT OUTER JOIN  ('+char(10)
  SET @v_dSql += '		               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '			                   , A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '			                   , A.LINE_ID'+char(10)
  SET @v_dSql += '			                   , A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '			                   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '			                   , MIN(LINE_SEQ) LINE_SEQ'+char(10)
  SET @v_dSql += '		               FROM ('+char(10)
  SET @v_dSql += '		                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '				                   , A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '				                   , A.LINE_ID'+char(10)
  SET @v_dSql += '				                   , A.PLAN_DATE'+char(10)
  SET @v_dSql += '				                   , A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '				                   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '				                   , A.SEQ'+char(10)
  SET @v_dSql += '				                   , RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID'+char(10)
  SET @v_dSql += '                                  				  ORDER     BY A.PLAN_DATE, A.SEQ ) LINE_SEQ'+char(10)
  SET @v_dSql += '				              FROM   @AMEND_TABLE@ A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				              INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				              ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '				              AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '				              AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '				              AND    A.ITEM_ID        = B.ITEM_ID'+char(10)
  SET @v_dSql += '				              WHERE  INSTANCE_ID      ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '				              AND    FP_PLAN_ID       ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '				              AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)

      SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'LK', @p_prod_type)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LK', @p_item_name)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)

  SET @v_dSql += '				              AND 	ISNULL(A.SEQ, 0) <> 0'+char(10)
  SET @v_dSql += '				              AND 	A.ADJUST_IN_QTY_BATCH > 0'+char(10)
  SET @v_dSql += '				          ) A'+char(10)
  SET @v_dSql += '				          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '		                         , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '		                         , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '      		)B'+char(10)
  SET @v_dSql += '             	ON  A.COMPANY_ID      = B.COMPANY_ID'+char(10)
  SET @v_dSql += '				AND A.DIVISION_ID     = B.DIVISION_ID'+char(10)
  SET @v_dSql += '				AND A.SITE_ID         = B.SITE_ID'+char(10)
  SET @v_dSql += '				AND A.PLANT_ID        = B.PLANT_ID'+char(10)
  SET @v_dSql += '				AND A.FACTORY_ID      = B.FACTORY_ID'+char(10)
  SET @v_dSql += '				AND A.LOCATION        = B.LOCATION'+char(10)
  SET @v_dSql += '				AND A.OPERATION_ID    = B.OPERATION_ID'+char(10)
  SET @v_dSql += '				AND A.LINE_ID         = B.LINE_ID'+char(10)
  SET @v_dSql += '				AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '				AND A.ITEM_ID         = B.ITEM_ID'+char(10)
  SET @v_dSql += '				AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '				AND A.MARKET         	= B.MARKET'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , CAPA_VALUE AS ('+char(10)
  SET @v_dSql += '			         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '			               , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE, D.YYYYMM, D.ISO_YYYYWW'+char(10)
  SET @v_dSql += '			               , AVG(ISNULL(C.OFF_TIME,0)) AS OFF_TIME'+char(10)
  SET @v_dSql += '					       , AVG(ISNULL(C.SETUP_TIME,0)) AS SETUP_TIME'+char(10)
  SET @v_dSql += '					       , AVG(ISNULL(C.UTILIZATION,0)) AS UTILIZATION'+char(10)
  SET @v_dSql += '			          FROM   @AMEND_TABLE@ A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				          INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				          ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '				          AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '				          AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '				          AND    A.ITEM_ID        = B.ITEM_ID'+char(10)
  SET @v_dSql += '				          INNER HASH JOIN TH_UIS_CAL D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				          ON  1=1'+char(10)
  SET @v_dSql += '				          AND CONVERT(VARCHAR, D.YYYYMMDD, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '				          AND	A.PLAN_DATE = D.YYYYMMDD'+char(10)
  SET @v_dSql += '				          LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '				          		 SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '						               	, A.PLAN_DATE'+char(10)
  SET @v_dSql += '						               	, A.OFF_TIME AS OFF_TIME'+char(10)
  SET @v_dSql += '			               				, A.SETUP_TIME AS SETUP_TIME'+char(10)
  SET @v_dSql += '			               				, A.UTILIZATION AS UTILIZATION'+char(10)
  SET @v_dSql += '						          FROM   @AMEND_UTIL_TABLE@ A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						          WHERE  A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '						          AND    A.FP_PLAN_ID  ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '						          AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)

        SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'LK', @p_prod_type)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LK', @p_item_name)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)

  SET @v_dSql += '			          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '			               	 , CONVERT(VARCHAR, A.PLAN_DATE, 112), D.YYYYMM, D.ISO_YYYYWW'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , T_MEMO AS ('+char(10)
  SET @v_dSql += '      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '		               , A.OPERATION_ID'+char(10)
  SET @v_dSql += '		               , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		               , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		               , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '		               , A.PRODUCTION_TYPE, A.MARKET'+char(10)



  SET @v_dSql += '				          ) C'+char(10)
  SET @v_dSql += '				          ON  	1=1'+char(10)
  SET @v_dSql += '				          AND    A.SITE_ID        	= C.SITE_ID'+char(10)
  SET @v_dSql += '				          AND    A.PLANT_ID       	= C.PLANT_ID'+char(10)
  SET @v_dSql += '				          AND    A.FACTORY_ID     	= C.FACTORY_ID'+char(10)
  SET @v_dSql += '				          AND    A.LOCATION       	= C.LOCATION'+char(10)
  SET @v_dSql += '				          AND    A.OPERATION_ID   	= C.OPERATION_ID'+char(10)
  SET @v_dSql += '				          AND    A.LINE_ID        	= C.LINE_ID'+char(10)
  SET @v_dSql += '				          AND    A.ELECTRODE_TYPE 	= C.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '				          AND    A.EQUIPMENT_ID   	= C.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '				          AND    A.PLAN_DATE   		= C.PLAN_DATE'+char(10)
  SET @v_dSql += '			          WHERE  INSTANCE_ID      ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '			          AND    FP_PLAN_ID       ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '			          AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)

        SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)

    IF isnull(@p_day_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)
  SET @v_dSql +='   , D.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_MO ' + char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)

				-- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)
  SET @v_dSql += '  ,	CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85''  ' + char(10)
  SET @v_dSql += '  		 WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2''  ' + char(10)
  SET @v_dSql += '  		 WHEN A.CATEGORY_ID=''P_IN'' THEN (CASE WHEN E.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BG IS NOT NULL THEN E.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BG   ' + char(10)
  SET @v_dSql += '												  WHEN ''' + @sub_param_3 +''' >= '+ @V_PLAN_DATE +' AND '+ @V_PLAN_TYPE + ' <> ''RELEASE'' THEN ( CASE WHEN H.PRODUCTION_TYPE IS NOT NULL THEN ''#FFFF0055'' ELSE '''' END )   ' + char(10)
  SET @v_dSql += '												  ELSE '''''''' END )  ' + char(10)
  SET @v_dSql += '  		 WHEN A.CATEGORY_ID=''P_MPP_IN'' OR A.CATEGORY_ID=''P_WPP_IN'' THEN ( CASE WHEN '+ @v_PLAN_TYPE +' = ''RELEASE'' AND R_T.CURR_DATE <= ''' + @sub_param_3 +''' AND R_T.IS_LATEST_PLAN = ''Y'' THEN ''#FFFF0055'' ELSE '''' END )   ' + char(10)
  SET @v_dSql += '  		 ELSE '''' END AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BG ' + char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''

  SET @v_dSql += '    	   , CASE WHEN H.PRODUCTION_TYPE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS EDIT_YN'+char(10)


  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '          SELECT * FROM MAIN'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
  SET @v_dSql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_ID'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'+char(10)
  SET @v_dSql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3'+char(10)
  SET @v_dSql += '                ,NULL AS CMC'+char(10)
  SET @v_dSql += '                ,NULL AS VERSION'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL_CODE'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL'+char(10)
  SET @v_dSql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH'+char(10)
  SET @v_dSql += '                ,NULL AS DC_FLAG'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)

    IF isnull(@p_day_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END--MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END--MONTH_NAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END--MONTH_COUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END--M_VALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END
				
								-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				-- //SAMPLE SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
		SET @v_dSql += '                ,SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR, SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH, NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ , NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)
				--SET @mst_loop_cnt =  @mst_loop_cnt + 1
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
		SET @v_dSql += '                ,SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR, SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH, NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ , NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)

  SET @v_dSql += '                ,SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '"_JR, SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH, NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ , NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt
		
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
  SET @v_dSql += '               	, SUM(T' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS T' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''

  SET @v_dSql += '                ,A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , '''' LINE_SEQ'+char(10)
  SET @v_dSql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO'+char(10)
  SET @v_dSql += '          FROM   MAIN A'+char(10)

  IF @bSubTotal <> 1 BEGIN
     SET @v_dSql += 'WHERE 1=0'+char(10)
  END

  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                  ,A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '          -- Off Calendar, Setup'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
  SET @v_dSql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_ID'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'+char(10)
  SET @v_dSql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3'+char(10)
  SET @v_dSql += '                ,NULL AS CMC'+char(10)
  SET @v_dSql += '                ,NULL AS VERSION'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL_CODE'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL'+char(10)
  SET @v_dSql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH'+char(10)
  SET @v_dSql += '                ,NULL AS DC_FLAG'+char(10)
  SET @v_dSql += '                ,B.CATEGORY_NAME AS CATE'+char(10)

    IF isnull(@p_day_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END--MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END--MONTH_NAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END--MONTH_COUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END--M_VALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END
				
								-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
  SET @v_dSql += '                    ,NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR ' + char(10)
  SET @v_dSql += '                    ,SUM(CASE WHEN A.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)
  SET @v_dSql += '                    ,NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ ' + char(10)
  SET @v_dSql += '                    ,NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)

				--SET @mst_loop_cnt =  @mst_loop_cnt + 1
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
  SET @v_dSql += '                    ,NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR ' + char(10)
  SET @v_dSql += '                    ,SUM(CASE WHEN A.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)
  SET @v_dSql += '                    ,NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ ' + char(10)
  SET @v_dSql += '                    ,NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)
  

  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)
  SET @v_dSql += '                    ,NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR ' + char(10)
  SET @v_dSql += '                    ,SUM(CASE WHEN A.PLAN_DATE='''+ @sub_param_3 +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)
  SET @v_dSql += '                    ,NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ ' + char(10)
  SET @v_dSql += '                    ,NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)

			END -- end of @mst_loop_cnt < @max_loop_cnt
		
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW	
				
				  SET @v_dSql += '               	, NULL AS T' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''

  SET @v_dSql += '                ,B.CATEGORY_ID, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , '''' LINE_SEQ'+char(10)
  SET @v_dSql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO'+char(10)
  SET @v_dSql += '          FROM   CAPA_VALUE A'+char(10)
  SET @v_dSql += '          INNER JOIN ('+char(10)
  SET @v_dSql += '              SELECT ''OFF'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '              UNION ALL'+char(10)
  SET @v_dSql += '              SELECT ''SETUP'' AS CATEGORY_ID, ''M/C(min)'' AS CATEGORY_NAME, 200 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '          ) B'+char(10)
  SET @v_dSql += '          ON 1=1'+char(10)
  SET @v_dSql += '          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON  1=1'+char(10)
  SET @v_dSql += '          AND CONVERT(VARCHAR, C.YYYYMMDD, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '          AND A.PLAN_DATE = C.YYYYMMDD'+char(10)

  IF @bSubTotal <> 1 BEGIN
     SET @v_dSql += 'WHERE 1=0'+char(10)
  END

  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                  ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '          -- Capa'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
  SET @v_dSql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_ID'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'+char(10)
  SET @v_dSql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3'+char(10)
  SET @v_dSql += '                ,NULL AS CMC'+char(10)
  SET @v_dSql += '                ,NULL AS VERSION'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL_CODE'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL'+char(10)
  SET @v_dSql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH'+char(10)
  SET @v_dSql += '                ,NULL AS DC_FLAG'+char(10)
  SET @v_dSql += '                ,''Load(%)'' AS CATE'+char(10)

  
    IF isnull(@p_day_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END--MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END--MONTH_NAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END--MONTH_COUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END--M_VALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END
				
								-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE

  SET @v_dSql += '                    ,NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR ' + char(10)
  SET @v_dSql += '                    ,CEILING(AVG(CASE WHEN A.YYYYMM=''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)
  SET @v_dSql += '                    ,NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ ' + char(10)
  SET @v_dSql += '                    ,CASE WHEN (CEILING(AVG(CASE WHEN A.YYYYMM=''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END  AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)

				--SET @mst_loop_cnt =  @mst_loop_cnt + 1
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
  
  SET @v_dSql += '                    ,NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR ' + char(10)
  SET @v_dSql += '                    ,CEILING(AVG(CASE WHEN A.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)
  SET @v_dSql += '                    ,NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ ' + char(10)
  SET @v_dSql += '                    ,CASE WHEN (CEILING(AVG(CASE WHEN A.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)

  SET @v_dSql += '                    ,NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR ' + char(10)
  SET @v_dSql += '                    ,CEILING(AVG(CASE WHEN A.PLAN_DATE='''+ @sub_param_3 +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)
  SET @v_dSql += '                    ,NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ ' + char(10)
  SET @v_dSql += '                    ,CASE WHEN (CEILING(AVG(CASE WHEN A.PLAN_DATE='''+ @sub_param_3 +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)

			END -- end of @mst_loop_cnt < @max_loop_cnt
		
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW	
				
				  SET @v_dSql += '               	, NULL AS T' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)
  			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''

  SET @v_dSql += '                ,''CAPA'' AS CATEGORY_ID, 300 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , '''' LINE_SEQ'+char(10)
  SET @v_dSql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO'+char(10)
  SET @v_dSql += '          FROM   CAPA_VALUE A'+char(10)

  IF @bSubTotal <> 1 OR @bCapa <> 1 BEGIN
     SET @v_dSql += 'WHERE 1=0'+char(10)
  END

  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '          -- Total'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS OPERATION_ID'+char(10)
  SET @v_dSql += '                ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
  SET @v_dSql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_ID'+char(10)
  SET @v_dSql += '                ,NULL AS PRE_DISPERSION_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'+char(10)
  SET @v_dSql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3'+char(10)
  SET @v_dSql += '                ,NULL AS CMC'+char(10)
  SET @v_dSql += '                ,NULL AS VERSION'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL_CODE'+char(10)
  SET @v_dSql += '                ,NULL AS FOIL'+char(10)
  SET @v_dSql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH'+char(10)
  SET @v_dSql += '                ,NULL AS DC_FLAG'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)


    IF isnull(@p_day_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END--MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END--MONTH_NAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END--MONTH_COUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END--M_VALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END
				
								-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				-- //SAMPLE SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
  SET @v_dSql += '                ,SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR, SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH, NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ, NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)
				--SET @mst_loop_cnt =  @mst_loop_cnt + 1
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
  SET @v_dSql += '                ,SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR, SUM(W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH, NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ, NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => MONth
				-- @sub_param_0 => MONTH_NAME
				-- @sub_param_0 => MONTH_COUNT
				-- @sub_param_0 => M_VALUE
				--SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)
				--SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)

  SET @v_dSql += '                    ,SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M, SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CELL, SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_JR, SUM(D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH, NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_SEQ, NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_CR ' + char(10)
			END -- end of @mst_loop_cnt < @max_loop_cnt
		
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
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END

				-- @sub_param_0 => WEEK
				-- @sub_param_0 => WEEK_NAME
				-- @sub_param_0 => WEEK_COUNT
				-- @sub_param_0 => W_VALUE
				-- @sub_param_0 => IS_DAY_VIEW		
  SET @v_dSql += '               	, SUM(T' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH) AS T' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_BATCH ' + char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''

  SET @v_dSql += '                ,A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL_2'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , '''' LINE_SEQ'+char(10)
  SET @v_dSql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO'+char(10)
  SET @v_dSql += '          FROM   MAIN A'+char(10)

    IF @bTotal <> 1 BEGIN
     SET @v_dSql += 'WHERE 1=0'+char(10)
  END

  SET @v_dSql += '          GROUP BY A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID        = C.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
  SET @v_dSql += '      AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND    A.LINE_ID        = C.LINE_ID'+char(10)
  SET @v_dSql += '      AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN T_MEMO D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        ON  A.COMPANY_ID      = D.COMPANY_ID'+char(10)
  SET @v_dSql += '        AND A.DIVISION_ID     = D.DIVISION_ID'+char(10)
  SET @v_dSql += '        AND A.SITE_ID         = D.SITE_ID'+char(10)
  SET @v_dSql += '        AND A.PLANT_ID        = D.PLANT_ID'+char(10)
  SET @v_dSql += '        AND A.FACTORY_ID      = D.FACTORY_ID'+char(10)
  SET @v_dSql += '        AND A.OPERATION_ID    = D.OPERATION_ID'+char(10)
  SET @v_dSql += '        AND A.LINE_ID         = D.LINE_ID'+char(10)
  SET @v_dSql += '        AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '        AND A.EQUIPMENT_ID    = D.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '        AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '        AND A.MARKET          = D.MARKET'+char(10)
  SET @v_dSql += '        AND A.TOP_ITEM_ID     = D.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '        AND A.ITEM_ID         = D.ITEM_ID'+char(10)
  SET @v_dSql += '        LEFT OUTER JOIN T_CHANGE E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        ON  A.COMPANY_ID      = E.COMPANY_ID'+char(10)
  SET @v_dSql += '        AND A.DIVISION_ID     = E.DIVISION_ID'+char(10)
  SET @v_dSql += '        AND A.SITE_ID         = E.SITE_ID'+char(10)
  SET @v_dSql += '        AND A.PLANT_ID        = E.PLANT_ID'+char(10)
  SET @v_dSql += '        AND A.FACTORY_ID      = E.FACTORY_ID'+char(10)
  SET @v_dSql += '        AND A.OPERATION_ID    = E.OPERATION_ID'+char(10)
  SET @v_dSql += '        AND A.LINE_ID         = E.LINE_ID'+char(10)
  SET @v_dSql += '        AND A.ELECTRODE_TYPE  = E.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '        AND A.EQUIPMENT_ID    = E.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '        AND A.PRODUCTION_TYPE = E.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '        AND A.MARKET          = E.MARKET'+char(10)
  SET @v_dSql += '        AND A.TOP_ITEM_ID     = E.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '        AND A.ITEM_ID         = E.ITEM_ID'+char(10)
  SET @v_dSql += '        /*'+char(10)
  SET @v_dSql += '        LEFT OUTER JOIN T_VERSION G WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        ON     A.COMPANY_ID     = G.COMPANY_ID'+char(10)
  SET @v_dSql += '        AND    A.DIVISION_ID    = G.DIVISION_ID'+char(10)
  SET @v_dSql += '        AND    A.SITE_ID        = G.SITE_ID'+char(10)
  SET @v_dSql += '        AND    A.PLANT_ID       = G.PLANT_ID'+char(10)
  SET @v_dSql += '        AND    A.FACTORY_ID     = G.FACTORY_ID'+char(10)
  SET @v_dSql += '        AND    A.OPERATION_ID   = G.OPERATION_ID'+char(10)
  SET @v_dSql += '        AND    B.APPLIED_MODEL  = G.MODEL_ID'+char(10)
  SET @v_dSql += '        AND    A.ITEM_ID        = G.ITEM_ID'+char(10)
  SET @v_dSql += '        AND    C.PROD_VERSION_TYPE = G.PROD_VERSION_TYPE'+char(10)
  SET @v_dSql += '        AND    (CASE WHEN (A.PRODUCTION_TYPE = ''TEST'' OR A.PRODUCTION_TYPE = ''S-TEST'') THEN ''TEST'' ELSE ''MASS'' END) = G.VERSION_TYPE'+char(10)
  SET @v_dSql += '        */'+char(10)
  SET @v_dSql += '        LEFT OUTER JOIN'+char(10)
  SET @v_dSql += '      	('+char(10)
  SET @v_dSql += '	        SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '	        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	        WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'''+char(10)
  SET @v_dSql += '	        AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '      	) H'+char(10)
  SET @v_dSql += '      	ON A.DIVISION_ID = H.DIVISION_ID'+char(10)
  SET @v_dSql += '      	AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '      	LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '            SELECT CONVERT(VARCHAR, dbo.FN_SITE_TIME('+char(10)
  SET @v_dSql += '' + @v_fp_site_id+''+char(10)
  SET @v_dSql += ')-(SELECT CONVERT(NUMERIC,ISNULL(SEGMENT1,''0'')) FROM SCM_SYS_LOOKUP_VALUE LLL WITH(NOLOCK) WHERE LLL.LOOKUP_TYPE_CODE = ''WPP_DAY_RANGE''),112) AS CURR_DATE'+char(10)
  SET @v_dSql += '                 , A.RELEASE_PLAN_ID, (CASE WHEN A.RELEASE_PLAN_ID ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += ' THEN ''Y'' ELSE ''N'' END) AS IS_LATEST_PLAN, A.RELEASE_TYPE AS RELEASE_VALUE'+char(10)
  SET @v_dSql += '            FROM ('+char(10)
  SET @v_dSql += '            	SELECT A.*'+char(10)
  SET @v_dSql += '            		   , ROW_NUMBER() OVER (ORDER BY A.INSERT_TIME DESC) AS ROW_NUM'+char(10)
  SET @v_dSql += '            		   , B.RELEASE_TYPE'+char(10)
  SET @v_dSql += '            	FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            	INNER JOIN ('+char(10)
  SET @v_dSql += '              		SELECT RR.INSTANCE_ID, (CASE WHEN RR.FACTORY_ID =''-'' THEN RR.PLAN_GROUP_ID ELSE RR.FACTORY_ID END) AS RELEASE_TYPE'+char(10)
  SET @v_dSql += '              		FROM   FP_RELEASE_PLAN_INFO_H RR WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              		WHERE  INSTANCE_ID     ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '              		AND    RELEASE_PLAN_ID ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '            	) B'+char(10)
  SET @v_dSql += '            	ON  A.INSTANCE_ID = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '            	AND (CASE WHEN'+char(10)
  SET @v_dSql += '' + @v_confirm_area+''+char(10)
  SET @v_dSql += ' = ''BUILDING'' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END) = B.RELEASE_TYPE'+char(10)
  SET @v_dSql += '            ) A'+char(10)
  SET @v_dSql += '            WHERE A.ROW_NUM = 1'+char(10)
  SET @v_dSql += '	  	) R_T'+char(10)
  SET @v_dSql += '	  	ON 1=1'+char(10)  

  SET @v_dSql += '      ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999 END)'+char(10)
  SET @v_dSql += '             , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID'+char(10)
  SET @v_dSql += '             , (CASE WHEN A.DATA_TYPE=''DATA'' THEN 1 ELSE A.CATEGORY_ORDER END), LV1'+char(10)
  SET @v_dSql += '             , (CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''0'' ELSE LINE_SEQ END)'+char(10)
  SET @v_dSql += '             --, LINE_SEQ'+char(10)
  SET @v_dSql += '             , A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '             , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '             , A.CATEGORY_ORDER'+char(10)

 ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00595","find_FP00595",param);
  --
  --}


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
