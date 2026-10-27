 
CREATE PROCEDURE [dbo].[PR_UI_FP00605_FIND_FP00605]
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
/** 프로그램 ID   : PR_UI_FP00605_FIND_FP00605                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00605_FIND_FP00605                                                                          **/
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
/** 2021-11-09     XPDbToProcedure      Auto Generated With Initial Setting                                **/
/** 2026-05-13     SYngsn               E20260421-000487 acc gap - weeksum error - plan by line ( fomation)**/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00605_FIND_FP00605
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00605_FIND_FP00605'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_day_info      NVARCHAR(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_prod_type nvarchar(max) = ''
  DECLARE @p_item_name nvarchar(max) = ''
  DECLARE @p_cell_group nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_week_info nvarchar(max) = ''
  DECLARE @p_month_info nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_line_lt nvarchar(max) = ''
  DECLARE @p_curr_date_col nvarchar(max) = ''
  DECLARE @p_model_lt nvarchar(max) = ''
  DECLARE @p_model_id nvarchar(max) = ''
  DECLARE @p_operation_lt nvarchar(max) = ''
  DECLARE @p_nickname_lt nvarchar(max) = ''
  DECLARE @p_nickname_id nvarchar(max) = ''
  DECLARE @p_day2month nvarchar(max) = ''
  DECLARE @p_day2week nvarchar(max) = ''
  --DECLARE @p_curr_date_col nvarchar(max) = ''
  DECLARE @p_confirm_area nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_prod_type nvarchar(max)
  DECLARE @v_item_name nvarchar(max)
  DECLARE @v_cell_group nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_week_info nvarchar(max)
  DECLARE @v_month_info nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_model_lt nvarchar(max)
  DECLARE @v_model_id nvarchar(max)
  DECLARE @v_operation_lt nvarchar(max)
  DECLARE @v_nickname_lt nvarchar(max)
  DECLARE @v_nickname_id nvarchar(max)
  DECLARE @v_day2month nvarchar(max)
  DECLARE @v_day2week nvarchar(max)
  DECLARE @v_curr_date_col nvarchar(max)
  DECLARE @v_confirm_area nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)
  DECLARE @p_curr_date_gap	NVARCHAR(MAX); -- 인스턴스별 현재일자를 구한다.

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
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
    --  SET @p_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
      SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_NAME' BEGIN
      SET @p_item_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MODEL_LT' BEGIN
      SET @p_model_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICKNAME_ID' BEGIN
      SET @p_nickname_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'NICK_NAME_LT' BEGIN
	  SET @p_nickname_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DAY2MONTH' BEGIN
      SET @p_day2month =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DAY2WEEK' BEGIN
      SET @p_day2week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CURR_DATE_COL' BEGIN
      SET @p_curr_date_col =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
      SET @p_confirm_area =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_prod_type ='''' + @p_prod_type + ''''
  SET @v_item_name ='''' + @p_item_name + ''''
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
  SET @v_model_id = '''' + @p_model_id + ''''
  SET @v_operation_lt ='''' + @p_operation_lt + ''''
  SET @v_nickname_lt ='''' + @p_nickname_lt + ''''
  SET @v_nickname_id ='''' + @p_nickname_id + ''''
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
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10operation_id = ''
  END ELSE BEGIN
    SET @opt_10operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
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
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_15operation_id = ''
  END ELSE BEGIN
    SET @opt_15operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
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
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_20operation_id = ''
  END ELSE BEGIN
    SET @opt_20operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
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
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_44operation_id = ''
  END ELSE BEGIN
    SET @opt_44operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
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
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_49operation_id = ''
  END ELSE BEGIN
    SET @opt_49operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
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
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_54operation_id = ''
  END ELSE BEGIN
    SET @opt_54operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
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


  -- FP00605 findPlanAmend  
  SET @v_dSql = ''

  SET @p_curr_date_gap = (
			SELECT CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,'yyyyMMddHHmmss') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME
						THEN CONVERT(VARCHAR, DATEADD(DD,-1,DBO.FN_SITE_TIME(B.SITE_ID)), 112) 
						ELSE CONVERT(VARCHAR, DBO.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE 
			FROM   FP_INSTANCE_START_TIME_V A,
			(
					SELECT MAX(B.SITE_ID) AS SITE_ID 
					FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)
					WHERE  A.FACTORY_ID = B.FACTORY_ID 
					AND    A.ACTIVE_FLAG = 'Y'
					AND    B.ACTIVE_FLAG = 'Y'
					AND    A.INSTANCE_ID = @p_instance_id
			) B
			WHERE  A.INSTANCE_ID = @p_instance_id
		)

  DECLARE @sub_mst_loop_cnt integer = 0
  DECLARE @sub_max_loop_cnt integer = 0
  DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
  DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_4 NVARCHAR(MAX) = '' 

  SET @v_dSql += 'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
  SET @v_dSql += '	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
  SET @v_dSql += 'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
  SET @v_dSql += '	drop table #MAIN_GAP_WPP ' + char(10)+char(10)

  SET @v_dSql += 'SELECT A.* ' + char(10)
  SET @v_dSql += '     , B.YYYYMMDD AS PLAN_DATE, B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
  SET @v_dSql += '     , ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME ' + char(10)
  SET @v_dSql += '     , ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, '''' AS EQUIPMENT_ID ' + char(10)
  SET @v_dSql += '     , ISNULL(BB.NICK_NAME,''-'') AS NICK_NAME, BB.ITEM_TYPE, ISNULL(BB.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME ' + char(10)
  SET @v_dSql += '     , ISNULL(E.GROUP_ITEM_ID, A.ITEM_ID) AS CELL_GROUP_CODE ' + char(10)
  SET @v_dSql += '     , ''-'' AS CUSTOMER_ID, J.CELL_GROUP ' + char(10)
  SET @v_dSql += 'INTO #MAIN_ITEM_WPP_GAP ' + char(10)
  SET @v_dSql += 'FROM ( ' + char(10)
					-- RESULT
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
  SET @v_dSql += '		 , A.LOCATION, A.OPERATION_ID ' + char(10)
  SET @v_dSql += '		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '		 , A.TOP_ITEM_ID, A.ITEM_ID, A.CELL_MATERIAL_ID ' + char(10)
  SET @v_dSql += '		 , ''-'' AS PRODUCTION_TYPE ' + char(10)
  SET @v_dSql += '		 , A.MARKET ' + char(10)
  SET @v_dSql += '	FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	WHERE  1=1 ' + char(10)
  SET @v_dSql += '	AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
  SET @v_dSql += '	AND    A.ACTUAL_GOOD_QTY > 0 ' + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += '  ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += ' '  +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
  SET @v_dSql += '	' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '	' +@opt_13prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
					-- WPP(OUT)
  SET @v_dSql += '	UNION ' + char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
  SET @v_dSql += '		 , A.LOCATION, A.OPERATION_ID ' + char(10)
  SET @v_dSql += '		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '		 , A.TOP_ITEM_ID, A.ITEM_ID, A.CELL_MATERIAL_ID ' + char(10)
  SET @v_dSql += '		 , ''-'' AS PRODUCTION_TYPE ' + char(10)
  SET @v_dSql += '		 , A.MARKET ' + char(10)
  SET @v_dSql += '	FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	WHERE  1=1 ' + char(10)
  SET @v_dSql += '	AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
  SET @v_dSql += '	AND    A.PLAN_TYPE IN (''WPP'', ''RELEASE'') ' + char(10) -- WPP 는 WPP(OUT), RELEASE 는 미래 실적
  SET @v_dSql += '	AND    (A.PLAN_IN_QTY > 0 OR  A.PLAN_QTY > 0) ' + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += '  ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  SET @v_dSql += ' '  +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
  SET @v_dSql += '	' +(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
  SET @v_dSql += '	' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '	' +@opt_13prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
  SET @v_dSql += ') A ' + char(10)
  SET @v_dSql += 'INNER JOIN ( ' + char(10)
  SET @v_dSql += '		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
  SET @v_dSql += '				A.ITEM_ID, ' + char(10)
  SET @v_dSql += '				(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
  SET @v_dSql += '	                  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
  SET @v_dSql += '	                  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
  SET @v_dSql += '				ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME ' + char(10)
  SET @v_dSql += '		FROM   SCM_ITEM_M A WITH(NOLOCK), ' + char(10)
  SET @v_dSql += '	           SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '		WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += '		' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nickname_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nickname_id)) + char(10)
  SET @v_dSql += ') BB ' + char(10)
  SET @v_dSql += 'ON     A.COMPANY_ID     = BB.COMPANY_ID ' + char(10)
  SET @v_dSql += 'AND    A.DIVISION_ID    = BB.DIVISION_ID ' + char(10)
  SET @v_dSql += 'AND    A.SITE_ID        = BB.SITE_ID ' + char(10)
  SET @v_dSql += 'AND    A.TOP_ITEM_ID     = BB.ITEM_ID ' + char(10)
  SET @v_dSql += 'INNER JOIN SCM_LINE_M C WITH(NOLOCK) ' + char(10)
  SET @v_dSql += 'ON     A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
  SET @v_dSql += 'AND    A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
  SET @v_dSql += 'AND    A.SITE_ID        = C.SITE_ID ' + char(10)
  SET @v_dSql += 'AND    A.PLANT_ID       = C.PLANT_ID ' + char(10)
  SET @v_dSql += 'AND    A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
  SET @v_dSql += 'AND    A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
  SET @v_dSql += 'AND    A.LINE_ID        = C.LINE_ID ' + char(10)
  SET @v_dSql += 'AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += 'INNER JOIN SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
  SET @v_dSql += 'ON     A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
  SET @v_dSql += 'AND    A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
  SET @v_dSql += 'AND    A.SITE_ID        = D.SITE_ID ' + char(10)
  SET @v_dSql += 'AND    A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
  SET @v_dSql += 'LEFT OUTER JOIN ( ' + char(10)
  SET @v_dSql += '	SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER ' + char(10)
  SET @v_dSql += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
  SET @v_dSql += '	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
  SET @v_dSql += ') E ' + char(10)
  SET @v_dSql += 'ON  A.DIVISION_ID = E.DIVISION_ID ' + char(10)
  SET @v_dSql += 'AND A.SITE_ID     = E.SITE_ID ' + char(10)
  SET @v_dSql += 'AND A.ITEM_ID     = E.ITEM_ID ' + char(10)
  SET @v_dSql += 'INNER JOIN FP_CELL_GROUP_V J WITH(NOLOCK) ' + char(10)
  SET @v_dSql += 'ON  A.COMPANY_ID  = J.COMPANY_ID ' + char(10)
  SET @v_dSql += 'AND A.DIVISION_ID = J.DIVISION_ID ' + char(10)
  SET @v_dSql += 'AND A.SITE_ID     = J.SITE_ID ' + char(10)
  SET @v_dSql += 'AND A.TOP_ITEM_ID = J.ITEM_ID ' + char(10)
  SET @v_dSql += ', TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
  SET @v_dSql += 'WHERE 1=1 ' + char(10)
  SET @v_dSql += 'AND   B.YYYYMMDD BETWEEN (SUBSTRING(' + @v_bucket_from + ',1,6) + ''01'') AND ' + @v_bucket_to + ' ' + char(10)
  SET @v_dSql += ' ' +@opt_24cell_group +' '+''+char(10)--AND    J.CELL_GROUP LIKE '%' + #CELL_GROUP# + '%'
  SET @v_dSql += 'OPTION (FORCE ORDER) ' + char(10)
  SET @v_dSql += '; ' + char(10)+char(10)

  SET @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '	 , A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
  SET @v_dSql += '	 , A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
  SET @v_dSql += '	 , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID, A.PSI ' + char(10)
  SET @v_dSql += '	 , A.FACTORY_ID, A.LOCATION, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '	 , A.CATE ' + char(10)
  
  ----------------
  set @sub_mst_loop_cnt = 0
  set @sub_max_loop_cnt = 0
  set @sub_v_delimiter = '#'
  set @sub_tmp_column  = ''
  
  set @sub_param_0 = '' 
  set @sub_param_1 = '' 
  set @sub_param_2 = '' 
  set @sub_param_3 = '' 
  set @sub_param_4 = '' 

  IF isnull(@p_day_info,'') <> '' BEGIN
  	SET @mst_loop_cnt = 0
  	SET @v_delimiter = '!'  -- 데이터 구분자
  	SET @sub_v_delimiter = '#'
  	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	declare @d_seq integer = 0;
  
  	IF @max_loop_cnt > 0 BEGIN
  		-- 1. monthinfo
  		SET @mst_loop_cnt = 0
  		SET @max_loop_cnt = 0
  		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
		set @d_seq = 0
  
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

			SELECT @v_dSql += '	 , A.D' +  CONVERT(VARCHAR, (@d_seq + CONVERT(integer, @sub_param_2) - 1)) + ' AS ' + @sub_param_3 + char(10) -- 월 별 일갯수만큼 누적됨

			set @d_seq += @sub_param_2

  		END
  
  		-- 2. weekinfo
  		SET @mst_loop_cnt = 0	
  		SET @max_loop_cnt = 0
  		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
		set @d_seq = 0

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
  			
			SELECT @v_dSql += '	 , A.D' +  CONVERT(VARCHAR, (@d_seq + CONVERT(integer, @sub_param_2) - 1)) + ' AS ' + @sub_param_3 + char(10) -- 주 별 일갯수만큼 누적됨
						 
			SET @d_seq += @sub_param_2

  		END
  
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
  			
          	SET @v_dSql +='	 , A.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)

  		END

  	END
  END

  SET @v_dSql += '	 , A.CATEGORY_ID, A.CATEGORY_ORDER, A.DATA_TYPE, A.S_ROW ' + char(10)
  SET @v_dSql += 'INTO #MAIN_GAP_WPP ' + char(10)
  SET @v_dSql += 'FROM ( ' + char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '		 , A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
  SET @v_dSql += '		 , A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
  SET @v_dSql += '		 , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID, ''P'' AS PSI ' + char(10)
  SET @v_dSql += '		 , A.FACTORY_ID, A.LOCATION, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '		 , A.CELL_GROUP_CODE, A.CELL_MATERIAL_ID ' + char(10)
  SET @v_dSql += '		 , B.CATEGORY_NAME AS CATE ' + char(10)

  IF isnull(@p_day_info,'') <> '' 
  BEGIN
  	SET @mst_loop_cnt    = 0
  	SET @v_delimiter     = '!'  -- 데이터 구분자
  	SET @sub_v_delimiter = '#'
  	SET @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  	    
  	IF @max_loop_cnt > 0 
  	BEGIN
  		-- bucket
  		SET @mst_loop_cnt = 0	
  		SET @max_loop_cnt = 0
  		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  		--SET @v_Tmp1       = ''
  		WHILE @mst_loop_cnt < @max_loop_cnt
  		BEGIN
  			SET @mst_loop_cnt     =  @mst_loop_cnt +1
  			SET @tmp_column       = ''
  			SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
  			SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
  
  			SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN (Y/N)
  			SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => D_Value (D0...DN)
  			SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 => _DATE(20210221)
  			--SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
  			--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
  			--SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))
  
  			SET @v_dSql += '		 , SUM(CASE WHEN A.PLAN_DATE >= (SUBSTRING(''' + @sub_param_2 + ''',1,6)+''01'') AND A.PLAN_DATE <= ''' + @sub_param_2 + ''' THEN A.GAP_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' ' + char(10)
  			
  		END 
  	END
  END

  SET @v_dSql += '		 , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
  SET @v_dSql += '		 , ''DATA'' AS DATA_TYPE, NULL AS S_ROW ' + char(10)
  SET @v_dSql += '	FROM ( ' + char(10)
  SET @v_dSql += '		SELECT A.* ' + char(10)
  SET @v_dSql += '			 , ISNULL(B.GAP_QTY,0) AS GAP_QTY ' + char(10)
  SET @v_dSql += '		FROM   #MAIN_ITEM_WPP_GAP A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '		LEFT OUTER JOIN ( ' + char(10)
  SET @v_dSql += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '				 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
  SET @v_dSql += '				 , A.OPERATION_ID ' + char(10)
  SET @v_dSql += '				 , A.FACTORY_ID, A.LOCATION ' + char(10)
  SET @v_dSql += '				 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
  SET @v_dSql += '				 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '				 , A.PLAN_DATE ' + char(10)
  SET @v_dSql += '				 , SUM(ISNULL(A.RESULT_QTY,0)) AS RESULT_QTY ' + char(10)
  SET @v_dSql += '				 , SUM(ISNULL(A.OUT_QTY,0)) AS OUT_QTY ' + char(10)
  SET @v_dSql += '				 , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY ' + char(10)
  SET @v_dSql += '			FROM ( ' + char(10)
								-- WPP(OUT) : 1일부터 end date 까지
  SET @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
  SET @v_dSql += '					 , A.OPERATION_ID ' + char(10)
  SET @v_dSql += '					 , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION ' + char(10)
  SET @v_dSql += '					 , ''-'' AS PRODUCTION_TYPE, A.MARKET ' + char(10)
  SET @v_dSql += '					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '					 , A.PLAN_DATE ' + char(10)
  SET @v_dSql += '					 , A.PLAN_QTY AS OUT_QTY ' + char(10)
  SET @v_dSql += '					 , 0 AS RESULT_QTY ' + char(10)
  SET @v_dSql += '				FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '				WHERE  1=1 ' + char(10)
  SET @v_dSql += '				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, SUBSTRING(' + @v_bucket_from + ',1,6)+''01'') AND CONVERT(DATETIME, ' + @v_bucket_to + ') ' + char(10)
  SET @v_dSql += '				AND    A.PLAN_TYPE = ''WPP'' ' + char(10)
  SET @v_dSql += '				AND    (A.PLAN_IN_QTY > 0 OR  A.PLAN_QTY > 0) ' + char(10)
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt))
  SET @v_dSql += '				' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt))
  SET @v_dSql += '				' +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id))
  SET @v_dSql += '				' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '				' +@opt_13prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
								-- 과거 RESULT : 1일부터 당일(20230428)까지
  SET @v_dSql += '				UNION ALL ' + char(10)
  SET @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
  SET @v_dSql += '					 , A.OPERATION_ID ' + char(10)
  SET @v_dSql += '					 , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION ' + char(10)
  SET @v_dSql += '					 , ''-'' AS PRODUCTION_TYPE, A.MARKET ' + char(10)
  SET @v_dSql += '					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '					 , A.PLAN_DATE ' + char(10)
  SET @v_dSql += '					 , 0 OUT_QTY ' + char(10)
  SET @v_dSql += '					 , A.ACTUAL_GOOD_QTY AS RESULT_QTY ' + char(10)
  SET @v_dSql += '				FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '				WHERE  1=1 ' + char(10)
  SET @v_dSql += '				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, SUBSTRING(' + @v_bucket_from + ',1,6) + ''01'') AND CONVERT(DATETIME, ''' + @p_curr_date_gap + ''')-1 ' + char(10)
  SET @v_dSql += '				AND    A.ACTUAL_GOOD_QTY > 0 ' + char(10)
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt))
  SET @v_dSql += '				' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt))
  SET @v_dSql += '				' +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id))
  SET @v_dSql += '				' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '				' +@opt_13prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
								-- 미래 RESULT : 당일(20230428)부터 end date 까지
  SET @v_dSql += '				UNION ALL ' + char(10)
  SET @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
  SET @v_dSql += '					 , A.OPERATION_ID ' + char(10)
  SET @v_dSql += '					 , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION ' + char(10)
  SET @v_dSql += '					 , ''-'' AS PRODUCTION_TYPE, A.MARKET ' + char(10)
  SET @v_dSql += '					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '					 , A.PLAN_DATE ' + char(10)
  SET @v_dSql += '					 , 0 AS OUT_QTY ' + char(10)
  SET @v_dSql += '					 , A.PLAN_QTY AS RESULT_QTY ' + char(10)
  SET @v_dSql += '				FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '				WHERE  1=1 ' + char(10)
  SET @v_dSql += '				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ' + @v_bucket_to + ') ' + char(10)
  SET @v_dSql += '				AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
  SET @v_dSql += '				AND    (A.PLAN_IN_QTY > 0 OR  A.PLAN_QTY > 0) ' + char(10)
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt))
  SET @v_dSql += '				' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt))
  SET @v_dSql += '				' +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt))
  SET @v_dSql += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id))
  SET @v_dSql += '				' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '				' +@opt_13prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
  SET @v_dSql += '			) A ' + char(10)
  SET @v_dSql += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '				   , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
  SET @v_dSql += '				   , A.OPERATION_ID ' + char(10)
  SET @v_dSql += '				   , A.FACTORY_ID, A.LOCATION ' + char(10)
  SET @v_dSql += '				   , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
  SET @v_dSql += '				   , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '				   , A.PLAN_DATE ' + char(10)
  SET @v_dSql += '		) B ' + char(10)
  SET @v_dSql += '		ON  1=1 ' + char(10)
  SET @v_dSql += '		AND A.COMPANY_ID      = B.COMPANY_ID ' + char(10)
  SET @v_dSql += '		AND A.DIVISION_ID     = B.DIVISION_ID ' + char(10)
  SET @v_dSql += '		AND A.SITE_ID         = B.SITE_ID ' + char(10)
  SET @v_dSql += '		AND A.PLANT_ID        = B.PLANT_ID ' + char(10)
  SET @v_dSql += '		AND A.FACTORY_ID      = B.FACTORY_ID ' + char(10)
  SET @v_dSql += '		AND A.LOCATION        = B.LOCATION ' + char(10)
  SET @v_dSql += '		AND A.OPERATION_ID    = B.OPERATION_ID ' + char(10)
  SET @v_dSql += '		AND A.LINE_ID         = B.LINE_ID ' + char(10)
  SET @v_dSql += '		AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '		AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID ' + char(10)
  SET @v_dSql += '		AND A.ITEM_ID         = B.ITEM_ID ' + char(10)
  SET @v_dSql += '		AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
  SET @v_dSql += '		AND A.MARKET          = B.MARKET ' + char(10)
  SET @v_dSql += '		AND A.PLAN_DATE       = B.PLAN_DATE ' + char(10)
  SET @v_dSql += '	) A ' + char(10)
  SET @v_dSql += '	INNER JOIN ( ' + char(10)
  SET @v_dSql += '		SELECT * ' + char(10)
  SET @v_dSql += '		FROM ( ' + char(10)
  SET @v_dSql += '			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER ' + char(10)
  SET @v_dSql += '			UNION ALL ' + char(10)
  SET @v_dSql += '			SELECT ''GAP_WPP'' AS CATEGORY_ID, ''Accu. GAP(WPP)'' AS CATEGORY_NAME, 76 AS CATEGORY_ORDER ' + char(10)
  SET @v_dSql += '		) BB ' + char(10)
  SET @v_dSql += '		WHERE CATEGORY_ID <> ''X'' ' + char(10)
  SET @v_dSql += '	) B ' + char(10)
  SET @v_dSql += '	ON 1=1 ' + char(10)
  SET @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
  SET @v_dSql += '		   , A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
  SET @v_dSql += '		   , A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
  SET @v_dSql += '		   , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID ' + char(10)
  SET @v_dSql += '		   , A.FACTORY_ID, A.LOCATION, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '		   , A.CELL_GROUP_CODE, A.CELL_MATERIAL_ID ' + char(10)
  SET @v_dSql += '		   , B.CATEGORY_ID, B.CATEGORY_ORDER, B.CATEGORY_NAME ' + char(10)
  SET @v_dSql += ') A ' + char(10)
  SET @v_dSql += 'OPTION (FORCE ORDER) ' + char(10)
  SET @v_dSql += '; ' + char(10)+char(10)

  --SET @v_dSql += @p_model_id + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)

  --SET @v_dSql += '      -- P : model, item, operation, market, production type, building, line, customer'+char(10)
  SET @v_dSql += '      WITH MAIN_P AS ('+char(10)
  SET @v_dSql += '      		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                 , J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '                 , A.OPERATION_ID, ISNULL(F.OPERATION_NAME, ''-'') AS OPERATION_NAME'+char(10)
  SET @v_dSql += '                 , A.MARKET, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '                 , A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '                 , ''P'' AS PSI'+char(10)
  SET @v_dSql += '                 , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                 , A.LINE_ID, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                 , D.CATE_NAME AS CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  --SELECT 'xxx' AS SQL
  --RETURN

  /*
  DECLARE @sub_mst_loop_cnt integer = 0
  DECLARE @sub_max_loop_cnt integer = 0
  DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
  DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_4 NVARCHAR(MAX) = '' 
  */
  set @sub_mst_loop_cnt = 0
  set @sub_max_loop_cnt = 0
  set @sub_v_delimiter = '#'
  set @sub_tmp_column  = ''
  
  set @sub_param_0 = '' 
  set @sub_param_1 = '' 
  set @sub_param_2 = '' 
  set @sub_param_3 = '' 
  set @sub_param_4 = '' 

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
                              SET @v_dSql += '               , SUM(CASE WHEN G.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN D.CATE_ID = ''P_IN'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY 		' + char(10)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''P_OUT'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY 		' + char(10)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''M_IN'' AND A.PLAN_TYPE = ''MPP'' THEN A.IN_QTY 			' + char(10)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''M_OUT'' AND A.PLAN_TYPE = ''MPP'' THEN A.OUT_QTY 			' + char(10)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''W_IN'' AND A.PLAN_TYPE = ''WPP'' THEN A.IN_QTY 			' + char(10)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''W_OUT'' AND A.PLAN_TYPE = ''WPP'' THEN A.OUT_QTY			' + char(10)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY			' + char(10)
							  SET @v_dSql += '               																  WHEN D.CATE_ID = ''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- Result(+Exp.)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''P_OFFTIME'' THEN A.OFF_TIME			' + char(10)
                              SET @v_dSql += '               																  WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
            				 
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

				-- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN A.PLAN_WEEK<=''' + @sub_param_0 + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' +@p_plan_date+''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY' + char(10)
  --        				    sql+="               , SUM(CASE WHEN G.ISO_YYYYWW=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN D.CATE_ID = ''''P_IN'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.IN_QTY 			' + char(10)
  --            				sql+="																					WHEN D.CATE_ID = ''''P_OUT'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.OUT_QTY 		' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''M_IN'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.IN_QTY 				' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''M_OUT'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.OUT_QTY 			' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''W_IN'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.IN_QTY 				' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''W_OUT'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.OUT_QTY 			' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''P_RESULT'''' THEN A.RESULT_QTY 			' + char(10)
  --							sql+="               																  	WHEN D.CATE_ID = ''''P_OFFTIME'''' THEN A.OFF_TIME			' + char(10)
  --        				    sql+="																			        WHEN D.CATE_ID = ''''P_MEMO'''' THEN NULL ELSE 0 END ) ELSE 0 END) AS W" + i + "' + char(10)
							SET @v_dSql += '         , SUM(CASE WHEN G.ISO_YYYYWW='''+ @sub_param_0 +''' THEN (CASE WHEN D.CATE_ID = ''P_IN'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY   ' + char(10)
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''P_OUT'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY  	 ' + char(10)
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''M_IN'' AND A.PLAN_TYPE = ''MPP'' THEN A.IN_QTY     ' + char(10)    
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''M_OUT'' AND A.PLAN_TYPE = ''MPP'' THEN A.OUT_QTY   ' + char(10)    
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''W_IN'' AND A.PLAN_TYPE = ''WPP'' THEN A.IN_QTY     ' + char(10)      
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''W_OUT'' AND A.PLAN_TYPE = ''WPP'' THEN A.OUT_QTY   ' + char(10)   	
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY     	                ' + char(10)
							SET @v_dSql += '                         WHEN D.CATE_ID = ''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- Result(+Exp.)
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''P_OFFTIME'' THEN A.OFF_TIME                        ' + char(10)  
            				SET @v_dSql += '                         WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)   

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
            				SET @v_dSql +='         , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_2 +''' THEN (CASE WHEN D.CATE_ID = ''P_IN'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY  ' + char(10)
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''P_OUT'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY ' + char(10)
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''M_IN'' AND A.PLAN_TYPE = ''MPP'' THEN A.IN_QTY       ' + char(10)
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''M_OUT'' AND A.PLAN_TYPE = ''MPP'' THEN A.OUT_QTY     ' + char(10)  
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''W_IN'' AND A.PLAN_TYPE = ''WPP'' THEN A.IN_QTY       ' + char(10) 
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''W_OUT'' AND A.PLAN_TYPE = ''WPP'' THEN A.OUT_QTY     ' + char(10)    
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY                         ' + char(10)
							SET @v_dSql +='                        WHEN D.CATE_ID = ''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- Result(+Exp.)
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''P_OFFTIME'' THEN A.OFF_TIME                          ' + char(10)	   
            				SET @v_dSql +='                        WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)


			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_day_info,'') <> ''



  --SET @v_dSql += '
  --{
  --          				var sql="";
  --          				var list = $data.bucket;
  --          				var weekInfo  = $data.WEEK_INFO;
  --          				var monthInfo = $data.MONTH_INFO;
  --
  --          				if(list.size() > 0) {
  --        				  for(var i = 0; i < monthInfo.size(); i++) {
  --        				    sql+="               , SUM(CASE WHEN G.YYYYMM=''''" + monthInfo[i].month + "'''' THEN (CASE WHEN D.CATE_ID = ''''P_IN'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.IN_QTY 		' + char(10)
  --        					sql+="               																  WHEN D.CATE_ID = ''''P_OUT'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.OUT_QTY 		' + char(10)
  --							sql+="               																  WHEN D.CATE_ID = ''''M_IN'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.IN_QTY 			' + char(10)
  --							sql+="               																  WHEN D.CATE_ID = ''''M_OUT'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.OUT_QTY 			' + char(10)
  --							sql+="               																  WHEN D.CATE_ID = ''''W_IN'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.IN_QTY 			' + char(10)
  --							sql+="               																  WHEN D.CATE_ID = ''''W_OUT'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.OUT_QTY			' + char(10)
  --        				    sql+="               																  WHEN D.CATE_ID = ''''P_RESULT'''' THEN A.RESULT_QTY			' + char(10)
  --        				    sql+="               																  WHEN D.CATE_ID = ''''P_OFFTIME'''' THEN A.OFF_TIME			' + char(10)
  --        				    sql+="               																  WHEN D.CATE_ID = ''''P_MEMO'''' THEN NULL ELSE 0 END ) ELSE 0 END) AS M" + i + "' + char(10)
  --        				  }
  --
  --        				  for(var i = 0; i < weekInfo.size(); i++) {
  --        				    sql+="               , SUM(CASE WHEN G.ISO_YYYYWW=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN D.CATE_ID = ''''P_IN'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.IN_QTY 			' + char(10)
  --            				sql+="																					WHEN D.CATE_ID = ''''P_OUT'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.OUT_QTY 		' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''M_IN'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.IN_QTY 				' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''M_OUT'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.OUT_QTY 			' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''W_IN'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.IN_QTY 				' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''W_OUT'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.OUT_QTY 			' + char(10)
  --							sql+="																					WHEN D.CATE_ID = ''''P_RESULT'''' THEN A.RESULT_QTY 			' + char(10)
  --							sql+="               																  	WHEN D.CATE_ID = ''''P_OFFTIME'''' THEN A.OFF_TIME			' + char(10)
  --        				    sql+="																			        WHEN D.CATE_ID = ''''P_MEMO'''' THEN NULL ELSE 0 END ) ELSE 0 END) AS W" + i + "' + char(10)
  --        				  }
  --
  --	    					for(var i = 0; i < list.size(); i++) {
  --	                			sql+="       , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN (CASE WHEN D.CATE_ID = ''''P_IN'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.IN_QTY 			' + char(10)
  --	                			sql+="																							 WHEN D.CATE_ID = ''''P_OUT'''' AND A.PLAN_TYPE = ''''RELEASE'''' THEN A.OUT_QTY 		' + char(10)
  --								sql+="																							 WHEN D.CATE_ID = ''''M_IN'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.IN_QTY 				' + char(10)
  --								sql+="																							 WHEN D.CATE_ID = ''''M_OUT'''' AND A.PLAN_TYPE = ''''MPP'''' THEN A.OUT_QTY 			' + char(10)
  --								sql+="																							 WHEN D.CATE_ID = ''''W_IN'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.IN_QTY 				' + char(10)
  --								sql+="																							 WHEN D.CATE_ID = ''''W_OUT'''' AND A.PLAN_TYPE = ''''WPP'''' THEN A.OUT_QTY 			' + char(10)
  --								sql+="																							 WHEN D.CATE_ID = ''''P_RESULT'''' THEN A.RESULT_QTY 			' + char(10)
  --								sql+="               																  			 WHEN D.CATE_ID = ''''P_OFFTIME'''' THEN A.OFF_TIME			' + char(10)
  --								sql+="																							 WHEN D.CATE_ID = ''''P_MEMO'''' THEN NULL ELSE 0 END ) ELSE 0 END) AS D" + i + "' + char(10)
  --	    					}
  --        				}
  --
  --          			}

  --'
  SET @v_dSql += '                 , D.CATE_ID AS CATEGORY_ID'+char(10)
  SET @v_dSql += '                 , D.CATE_ORDER AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                 , ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                 , NULL AS S_ROW'+char(10)
  SET @v_dSql += '            FROM ('+char(10)
  SET @v_dSql += '               SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                      ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE'+char(10)
  SET @v_dSql += '                      ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                      ,A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '                      ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE'+char(10)
  SET @v_dSql += '                      ,A.PLAN_TYPE'+char(10)
  SET @v_dSql += '                      ,SUM(A.IN_QTY) IN_QTY'+char(10)
  SET @v_dSql += '                      ,SUM(A.OUT_QTY) OUT_QTY, SUM(A.RESULT_QTY) RESULT_QTY'+char(10)
  SET @v_dSql += '                      ,SUM(A.AGING_WIP) AGING_WIP, SUM(A.AVAILABILITY) ACTIVATED'+char(10)
  SET @v_dSql += '                      ,AVG(A.OFF_TIME) AS OFF_TIME'+char(10)
  SET @v_dSql += '                      ,A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '                      , SUM(A.RESULT_QTY2) AS RESULT_QTY2 '+char(10) -- Result(+Exp.)
  SET @v_dSql += '               FROM ('+char(10)
  SET @v_dSql += '			       		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '			                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '			                       , A.OPERATION_ID'+char(10)
  SET @v_dSql += '			                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '			                       , ''-'' AS PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '			                       , ''P'' AS PSI'+char(10)
  SET @v_dSql += '			                       , A.LINE_ID'+char(10)
  SET @v_dSql += '			                       , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '			                       , A.PLAN_DATE'+char(10)
  SET @v_dSql += '			                       , A.PLAN_IN_QTY AS IN_QTY'+char(10)
  SET @v_dSql += '			                       , A.PLAN_QTY AS OUT_QTY'+char(10)
  SET @v_dSql += '			                       , 0 AS RESULT_QTY'+char(10)
  SET @v_dSql += '			                       , 0 AGING_WIP'+char(10)
  SET @v_dSql += '			                       , 0 AVAILABILITY'+char(10)
  SET @v_dSql += '			                       , 0 AS OFF_TIME'+char(10)
  SET @v_dSql += '			                       , ''-'' AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '			                       , A.PLAN_TYPE'+char(10)
  SET @v_dSql += '			                       , 0 AS RESULT_QTY2 '+char(10) -- Result(+Exp.)
  SET @v_dSql += '			                  FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			                  WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '			                  AND 	A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' )'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sDiv = $data.DIVISION_LT;
  --			                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sPlt = $data.PLANT_LT;
  --			                    sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --			                    sql;
  --			                  }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sFac = $data.FACTORY_LT;
  --			                    sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += '			                  AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sLine = $data.LINE_LT;
  --			                    sql="AND    A.LINE_ID IN (" + sLine + ")";
  --			                    sql;
  --			                  }

  --'
  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sModelLt = $data.MODEL_LT;
  --
  --			                    if(sModelLt!="" && sModelLt!=null)  sql="AND    A.TOP_ITEM_ID IN (" + sModelLt + ")' + char(10)
  --
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '			                  AND    (A.PLAN_IN_QTY > 0 OR  A.PLAN_QTY > 0)'+char(10) 
  --SET @v_dSql += '			                  AND    (A.PLAN_IN_QTY <> 0 OR  A.PLAN_QTY <> 0)'+char(10) -- 마이너스 처리를 위한 수정
  SET @v_dSql += '			                  UNION ALL'+char(10)
  SET @v_dSql += '			                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '			                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '			                       , A.OPERATION_ID'+char(10)
  SET @v_dSql += '			                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '			                       , ''-'' AS PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '			                       , ''P'' AS PSI'+char(10)
  SET @v_dSql += '			                       , A.LINE_ID'+char(10)
  SET @v_dSql += '			                       , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '			                       , A.PLAN_DATE'+char(10)
  SET @v_dSql += '			                       , 0 IN_QTY'+char(10)
  SET @v_dSql += '			                       , 0 OUT_QTY'+char(10)
  SET @v_dSql += '			                       , A.ACTUAL_GOOD_QTY AS RESULT_QTY'+char(10)
  SET @v_dSql += '			                       , 0 AGING_WIP'+char(10)
  SET @v_dSql += '			                       , 0 AVAILABILITY'+char(10)
  SET @v_dSql += '			                       , 0 AS OFF_TIME'+char(10)
  SET @v_dSql += '			                       , ''-'' AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '			                       , ''P_RESULT'' AS PLAN_TYPE'+char(10)
  SET @v_dSql += '			                       , A.ACTUAL_GOOD_QTY AS RESULT_QTY2 '+char(10) -- Result(+Exp.)
  SET @v_dSql += '			                  FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			                  WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sDiv = $data.DIVISION_LT;
  --			                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sPlt = $data.PLANT_LT;
  --			                    sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --			                    sql;
  --			                  }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sFac = $data.FACTORY_LT;
  --			                    sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += '			                  AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sLine = $data.LINE_LT;
  --			                    sql="AND    A.LINE_ID IN (" + sLine + ")";
  --			                    sql;
  --			                  }

  --'
  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sModelLt = $data.MODEL_LT;
  --
  --			                    if(sModelLt!="" && sModelLt!=null)  sql="AND    A.TOP_ITEM_ID IN (" + sModelLt + ")' + char(10)
  --
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '			                  AND    A.ACTUAL_GOOD_QTY > 0'+char(10) 
  --SET @v_dSql += '			                  AND    A.ACTUAL_GOOD_QTY <> 0'+char(10) -- 마이너스 처리를 위한 수정
                                              -- 미래 실적 수량 : 계획수량으로 보여준다.
  SET @v_dSql += '			       		      UNION ALL '+char(10)
  SET @v_dSql += '			       		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID '+char(10)
  SET @v_dSql += '			                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE '+char(10)
  SET @v_dSql += '			                       , A.OPERATION_ID '+char(10)
  SET @v_dSql += '			                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION '+char(10)
  SET @v_dSql += '			                       , ''-'' AS PRODUCTION_TYPE, A.MARKET '+char(10)
  SET @v_dSql += '			                       , ''P'' AS PSI '+char(10)
  SET @v_dSql += '			                       , A.LINE_ID '+char(10)
  SET @v_dSql += '			                       , A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '			                       , A.PLAN_DATE '+char(10)
  SET @v_dSql += '			                       , 0 AS IN_QTY'+char(10)
  SET @v_dSql += '			                       , 0 AS OUT_QTY'+char(10)
  SET @v_dSql += '			                       , 0 AS RESULT_QTY'+char(10)
  SET @v_dSql += '			                       , 0 AGING_WIP'+char(10)
  SET @v_dSql += '			                       , 0 AVAILABILITY'+char(10)
  SET @v_dSql += '			                       , 0 AS OFF_TIME'+char(10)
  SET @v_dSql += '			                       , ''-'' AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '			                       , ''RESULT_EXP'' AS PLAN_TYPE'+char(10)
  SET @v_dSql += '			                       , A.PLAN_QTY AS RESULT_QTY2 '+char(10) -- Result(+Exp.)
  SET @v_dSql += '			                  FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			                  WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_curr_date_gap + ''' AND ' + @v_bucket_to + ' ' + char(10)
  SET @v_dSql += '			                  AND 	 A.PLAN_TYPE = ''RELEASE'' '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id))
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  SET @v_dSql += '			                  AND    A.OPERATION_ID =' + @v_operation_id + ' ' +char(10)
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '			                  AND    (A.PLAN_IN_QTY > 0 OR  A.PLAN_QTY > 0)'+char(10) 
  SET @v_dSql += '			                  UNION ALL'+char(10)
  SET @v_dSql += '			                              SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '							                     , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '							                     , A.OPERATION_ID'+char(10)
  SET @v_dSql += '							                     , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '							                     , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '				      		                   	 , ''P'' AS PSI'+char(10)
  SET @v_dSql += '							                     , A.LINE_ID'+char(10)
  SET @v_dSql += '							                     , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '							                     , B.OFF_DATE AS PLAN_DATE'+char(10)
  SET @v_dSql += '				      		                     , 0 AS IN_QTY'+char(10)
  SET @v_dSql += '                     							 , 0 AS OUT_QTY'+char(10)
  SET @v_dSql += '                     							 , 0 AS RESULT_QTY'+char(10)
  SET @v_dSql += '                     							 , 0 AS AGING_WIP'+char(10)
  SET @v_dSql += '			                       				 , 0 AS AVAILABILITY'+char(10)
  SET @v_dSql += '		  	                                     , B.OFF_TIME AS OFF_TIME'+char(10)
  SET @v_dSql += '		  	                                   	 , ''-'' AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '		  	                                   	 , ''P_OFFTIME'' AS PLAN_TYPE'+char(10)
  SET @v_dSql += '		  	                                   	 , 0 AS RESULT_QTY2 '+char(10) -- Result(+Exp.)
  SET @v_dSql += '				                          FROM ('+char(10)
  SET @v_dSql += '				                                  	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '      												FROM ('+char(10)
  SET @v_dSql += '						                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		                                                       		, '''' AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		                                                       		, A.TOP_ITEM_ID, A.ITEM_ID, ''-'' AS PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '						                                      FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						                                      WHERE  1=1'+char(10)
  SET @v_dSql += '										                      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '										                      AND    A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' )'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
	--SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sDiv = $data.DIVISION_LT;
  --												                sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --												                sql;
  --												              }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sPlt = $data.PLANT_LT;
  --												                sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --												                sql;
  --												              }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sFac = $data.FACTORY_LT;
  --												                sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --												                sql;
  --												              }

  --'
  SET @v_dSql += ' ' +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --																      	var sql = "";
  --																      	if($data.OPERATION_LT != null && $data.OPERATION_LT != ""){
  --																      		sql+= "AND A.OPERATION_ID IN (" + $data.OPERATION_LT + ")' + char(10)
  --																      	}
  --																      	sql;
  --																      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sLine = $data.LINE_LT;
  --												                sql="AND    A.LINE_ID IN (" + sLine + ")";
  --												                sql;
  --												              }

  --'
  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --											                    var sql="";
  --											                    var sModelLt = $data.MODEL_LT;
  --
  --											                    if(sModelLt!="" && sModelLt!=null)  sql="AND    A.TOP_ITEM_ID IN (" + sModelLt + ")' + char(10)
  --
  --											                    sql;
  --											                  }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_13prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
  SET @v_dSql += '												               AND   (A.PLAN_IN_QTY + A.PLAN_QTY) > 0'+char(10) 
  --SET @v_dSql += '												               AND   (A.PLAN_IN_QTY + A.PLAN_QTY) <> 0'+char(10) -- 마이너스 표시를 위한 수정
  SET @v_dSql += '												              UNION ALL'+char(10)
  SET @v_dSql += '						                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		                                                       		, '''' AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		                                                       		, A.TOP_ITEM_ID, A.ITEM_ID, ''-'' AS PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '						                                      FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '						                                      WHERE  1=1'+char(10)
  SET @v_dSql += '										                      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
  --SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sDiv = $data.DIVISION_LT;
  --												                sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --												                sql;
  --												              }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sPlt = $data.PLANT_LT;
  --												                sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --												                sql;
  --												              }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sFac = $data.FACTORY_LT;
  --												                sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --												                sql;
  --												              }

  --'
  SET @v_dSql += ' ' +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --																      	var sql = "";
  --																      	if($data.OPERATION_LT != null && $data.OPERATION_LT != ""){
  --																      		sql+= "AND A.OPERATION_ID IN (" + $data.OPERATION_LT + ")' + char(10)
  --																      	}
  --																      	sql;
  --																      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --												                var sql="";
  --												                var sLine = $data.LINE_LT;
  --												                sql="AND    A.LINE_ID IN (" + sLine + ")";
  --												                sql;
  --												              }

  --'
  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --											                    var sql="";
  --											                    var sModelLt = $data.MODEL_LT;
  --
  --											                    if(sModelLt!="" && sModelLt!=null)  sql="AND    A.TOP_ITEM_ID IN (" + sModelLt + ")' + char(10)
  --
  --											                    sql;
  --											                  }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_13prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
  SET @v_dSql += '												              AND 	(A.ACTUAL_GOOD_QTY) > 0'+char(10) 
  --SET @v_dSql += '												              AND 	(A.ACTUAL_GOOD_QTY) <> 0'+char(10) -- 마이너스 표시를 위한 수정
  SET @v_dSql += '										          ) A'+char(10)
  SET @v_dSql += '											      WHERE 1=1'+char(10)
  SET @v_dSql += '											      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '					                          ) A'+char(10)
  SET @v_dSql += '					                          LEFT OUTER JOIN'+char(10)
  SET @v_dSql += '					                          ('+char(10)
  SET @v_dSql += '				                                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '				                                            , CONVERT(VARCHAR, A.OFF_DATE, 112) AS OFF_DATE, A.OFF_TIME_TERM AS OFF_TIME'+char(10)
  SET @v_dSql += '				                                      FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				                                      INNER JOIN SCM_LINE_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '				                                      ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '				                                      AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '				                                      AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '				                                      AND    A.PLANT_ID       = B.PLANT_ID'+char(10)
  SET @v_dSql += '	                                      AND    A.FACTORY_ID     = B.FACTORY_ID'+char(10)
  SET @v_dSql += '                                      AND    A.OPERATION_ID   = B.OPERATION_ID'+char(10)
  SET @v_dSql += '                                      AND    A.LINE_ID        = B.LINE_ID'+char(10)
  SET @v_dSql += '                                      AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                                      WHERE  B.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '                                      AND    CONVERT(VARCHAR, A.OFF_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
    --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
  --SET @v_dSql += '
  --{
  --						                var sql="";
  --						                var sDiv = $data.DIVISION_LT;
  --						                sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --							            sql;
  --						              }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --						                var sql="";
  --						                var sPlt = $data.PLANT_LT;
  --						                sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --						                sql;
  --						              }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --						                var sql="";
  --						                var sFac = $data.FACTORY_LT;
  --						                sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --						                sql;
  --						              }

  --'
  SET @v_dSql += ' ' +@opt_10operation_id +' '+''+char(10)--AND    A.OPERATION_ID   = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --										      	var sql = "";
  --										      	if($data.OPERATION_LT != null && $data.OPERATION_LT != ""){
  --										      		sql+= "AND A.OPERATION_ID IN (" + $data.OPERATION_LT + ")' + char(10)
  --										      	}
  --										      	sql;
  --										      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --						                var sql="";
  --						                var sLine = $data.LINE_LT;
  --						                sql="AND    A.LINE_ID IN (" + sLine + ")";
  --						                sql;
  --						              }

  --'
  SET @v_dSql += '	                          ) B'+char(10)
  SET @v_dSql += '	                          ON    A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '	                          AND   A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '	                          AND   A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '	                          AND   A.PLANT_ID       = B.PLANT_ID'+char(10)
  SET @v_dSql += '	                          AND   A.FACTORY_ID     = B.FACTORY_ID'+char(10)
  SET @v_dSql += '	                          AND   A.OPERATION_ID   = B.OPERATION_ID'+char(10)
  SET @v_dSql += '	                          AND   A.LINE_ID        = B.LINE_ID'+char(10)
  SET @v_dSql += '	                          AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '               ) A'+char(10)
  SET @v_dSql += '               INNER JOIN ('+char(10)
  SET @v_dSql += '                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,'+char(10)
  SET @v_dSql += '                         A.ITEM_ID,'+char(10)
  SET @v_dSql += '                         (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '                         	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '                         	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,'+char(10)
  SET @v_dSql += '                         ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '                  FROM	 SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SET @v_dSql += '                    		 SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  WHERE	 A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nickname_lt)) + char(10)
      SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nickname_id)) + char(10)
  --SET @v_dSql += '
  --{
  --		                var sql="";
  --		                var sNickNameLt = $data.NICKNAME_LT;
  --
  --		                if(sNickNameLt!="" && sNickNameLt!=null)  sql="AND   ISNULL(A.NICK_NAME,''''-'''') IN (" + sNickNameLt + ")' + char(10)
  --
  --		                sql;
  --		              }

  --'
  SET @v_dSql += '               ) B'+char(10)
  SET @v_dSql += '               ON     A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '               AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '               AND    A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '               AND    A.ITEM_ID     = B.ITEM_ID'+char(10)
  SET @v_dSql += '               WHERE  1=1'+char(10)
  SET @v_dSql += '               AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                          ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE'+char(10)
  SET @v_dSql += '                          ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                          ,A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '                          ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE'+char(10)
  SET @v_dSql += '                          ,A.CUSTOMER_ID, A.PLAN_TYPE'+char(10)
  SET @v_dSql += '            ) A'+char(10)
  SET @v_dSql += '            INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            ON     A.COMPANY_ID   = C.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID      = C.SITE_ID'+char(10)
  SET @v_dSql += '            AND    A.TOP_ITEM_ID      = C.ITEM_ID'+char(10)
  SET @v_dSql += '            INNER JOIN ('+char(10)
  SET @v_dSql += '                 SELECT 10 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 20 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 30 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 40 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 50 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''P_IN'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 60 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''P_OUT'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 70 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 71 AS CATE_ORDER, ''Result(+Exp.)'' AS CATE_NAME, ''RESULT_EXP'' AS CATE_ID '+char(10) -- Result(+Exp.)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 80 AS CATE_ORDER, ''Off Cal.'' AS CATE_NAME, ''P_OFFTIME'' AS CATE_ID'+char(10)
  SET @v_dSql += '	             UNION ALL'+char(10)
  SET @v_dSql += '	             SELECT 90 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID'+char(10)
  SET @v_dSql += '            ) D'+char(10)
  SET @v_dSql += '            ON     1=1'+char(10)
  SET @v_dSql += '            INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            ON     A.COMPANY_ID     = E.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID    = E.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID        = E.SITE_ID'+char(10)
  SET @v_dSql += '            AND    A.PLANT_ID       = E.PLANT_ID'+char(10)
  SET @v_dSql += '            AND    A.FACTORY_ID     = E.FACTORY_ID'+char(10)
  SET @v_dSql += '            AND    A.OPERATION_ID   = E.OPERATION_ID'+char(10)
  SET @v_dSql += '            AND    A.LINE_ID        = E.LINE_ID'+char(10)
  SET @v_dSql += '            AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '            INNER JOIN SCM_OPERATION_M F WITH(NOLOCK)'+char(10)
  SET @v_dSql += '    	  	  ON     A.COMPANY_ID     = F.COMPANY_ID'+char(10)
  SET @v_dSql += '          	AND    A.DIVISION_ID    = F.DIVISION_ID'+char(10)
  SET @v_dSql += '          	AND    A.SITE_ID        = F.SITE_ID'+char(10)
  SET @v_dSql += '          	AND    A.OPERATION_ID   = F.OPERATION_ID'+char(10)
  SET @v_dSql += '            INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            ON  A.PLAN_DATE    = G.DT'+char(10)
  SET @v_dSql += '            INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            ON  A.COMPANY_ID  = J.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND A.DIVISION_ID = J.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND A.SITE_ID     = J.SITE_ID'+char(10)
  SET @v_dSql += '            AND A.TOP_ITEM_ID = J.ITEM_ID'+char(10)
  SET @v_dSql += '            WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  --SET @v_dSql += '
  --{
  --              var sql="";
  --              var sDiv = $data.DIVISION_LT;
  --              sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --              sql;
  --            }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --              var sql="";
  --              var sPlt = $data.PLANT_LT;
  --              sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --              sql;
  --            }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --              var sql="";
  --              var sFac = $data.FACTORY_LT;
  --              sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --              sql;
  --            }

  --'
  SET @v_dSql += '            AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --              var sql="";
  --              var sLine = $data.LINE_LT;
  --              sql="AND    A.LINE_ID IN (" + sLine + ")";
  --              sql;
  --            }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_23item_name +' '+''+char(10)--AND    C.NICK_NAME LIKE '%' + #ITEM_NAME# + '%'
  SET @v_dSql += ' ' +@opt_24cell_group +' '+''+char(10)--AND    J.CELL_GROUP LIKE '%' + #CELL_GROUP# + '%'
  SET @v_dSql += '            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                   , J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'')'+char(10)
  SET @v_dSql += '                   , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'')'+char(10)
  SET @v_dSql += '                   , A.MARKET, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '                   , A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '                   , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                   , A.LINE_ID, ISNULL(E.LINE_NAME,''-''), A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                   , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , MAIN_GAP AS ('+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                , A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                , A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '                , A.PSI'+char(10)
  SET @v_dSql += '                , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			--SET @v_dSql += @p_day2month
			--SET @v_dSql += @p_day2week
            --2026-05-13 E20260421-000487 acc gap - weeksum error - plan by line ( fomation)
			SELECT @v_dSql += dbo.FN_GET_LAST_D_ALIAS(@p_day2month) 
			SELECT @v_dSql += dbo.FN_GET_LAST_D_ALIAS(@p_day2week) 

			IF ISNULL(@p_day_info,'') <> '' 
				BEGIN
					SET @mst_loop_cnt     = 0
					SET @v_delimiter      = '!'  -- 데이터 구분자
					SET @sub_v_delimiter  = '#'
					SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					--SET @v_Tmp1           = ''
					IF @max_loop_cnt > 0 
						BEGIN
            			  -- bucket
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_dSql += '          , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
						END 
				END
  --SET @v_dSql += '
  --{
  --                  var sql="";
  --
  --                  sql+=$data.DAY2MONTH+"' + char(10)
  --                  sql+=$data.DAY2WEEK+"' + char(10)
  --
  --                  for(var i = 0; i < list.size(); i++) {
  --                    sql+="            , A.D" + i + " AS D" + i + "' + char(10)
  --                  }
  --
  --                  sql;
  --                }

  --'
  SET @v_dSql += '                , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                , A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                , A.DATA_TYPE'+char(10)
  SET @v_dSql += '                , A.S_ROW'+char(10)
  SET @v_dSql += '      		FROM ('+char(10)
  SET @v_dSql += '      				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                      , A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                      , A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                      , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '                      , A.PSI'+char(10)
  SET @v_dSql += '                      , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                      , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                      , A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  			IF(@p_curr_date_col = '-999')
				BEGIN
					IF ISNULL(@p_day_info,'') <> '' 
						BEGIN
							SET @mst_loop_cnt     = 0
							SET @v_delimiter      = '!'  -- 데이터 구분자
							SET @sub_v_delimiter  = '#'
							SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
							--SET @v_Tmp1           = ''

							IF @max_loop_cnt > 0 
								BEGIN
                    				-- bucket
                    				SET @mst_loop_cnt = 0	
                    				SET @max_loop_cnt = 0
                    				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    
				    				WHILE @mst_loop_cnt < @max_loop_cnt
                    					BEGIN
                    	        			  SET @v_dSql += '                 , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
                    	        			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    					END
								END 
	        			END
				END
			ELSE
				BEGIN
					IF ISNULL(@p_day_info,'') <> '' 
						BEGIN
							SET @mst_loop_cnt     = 0
							SET @v_delimiter      = '!'  -- 데이터 구분자
							SET @sub_v_delimiter  = '#'
							SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
							--SET @v_Tmp1           = ''

							IF @max_loop_cnt > 0 
								BEGIN
				    
				    				 DECLARE @vFlag   NVARCHAR(1) = 'N'
                    				 -- bucket
                    				 SET @mst_loop_cnt = 0	
                    				 SET @max_loop_cnt = 0
                    				 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	     
				    				 WHILE @mst_loop_cnt < @max_loop_cnt
				    					 BEGIN
				    						 IF(@v_curr_date_col = 'D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt))
                    							 BEGIN
                    	                 			  SET @v_dSql += '                 , 0  AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
				    								  SET @vFlag = 'Y'
                    							 END
				    						 ELSE
				    							 BEGIN
				    								 IF(@vFlag = 'Y')
				    									 BEGIN
				    										 SET @v_dSql += '                 , 0 AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
				    									 END
				    								 ELSE
				    									 BEGIN
				    										 SET @v_dSql += '                 , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
				    									 END
				    							 END
				    						 SET @mst_loop_cnt =  @mst_loop_cnt + 1
				    					 END
								END 
	        			END
				END
 
  --SET @v_dSql += '
  --{
  --                			  var sql="";
  --                			  var list = $data.bucket;
  --
  --                			  if($data.CURR_DATE_COL == "-999") {
  --        		        				if(list.size() > 0) {
  --        			        		      for(var i = 0; i < list.size(); i++) {
  --        			        				    sql+="          			, A.D" + i + "' + char(10)
  --        			        				  }
  --        			        			}
  --                			  }
  --                			  else {
  --                  			    if(list.size() > 0) {
  --                  			        var bFlag = true;
  --                  			        for(var i = 0; i < list.size(); i++) {
  --                  			          if($data.CURR_DATE_COL == "D" + i) {
  --                  			            bFlag = false;
  --                  			            sql+="          			, 0 AS D" + i + "' + char(10)
  --                  			          }
  --                  			          else {
  --                  			            if(!bFlag) {
  --                  			              sql+="          			, 0 AS D" + i + "' + char(10)
  --                  			            }
  --                  			            else {
  --          			        				      sql+="          			, A.D" + i + "' + char(10)
  --                  			            }
  --                  			          }
  --                  			        }
  --                  			    }
  --                			  }
  --
  --                			  sql;
  --                			}

  --'
  SET @v_dSql += '                      , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                      , A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                      , A.DATA_TYPE'+char(10)
  SET @v_dSql += '                      , A.S_ROW'+char(10)
  SET @v_dSql += '      				FROM ('+char(10)
  SET @v_dSql += '      						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                           , J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, C.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '                           , A.OPERATION_ID, ISNULL(F.OPERATION_NAME, ''-'') AS OPERATION_NAME'+char(10)
  SET @v_dSql += '                           , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '                           , ''P'' AS PSI'+char(10)
  SET @v_dSql += '                           , A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                           , A.LINE_ID, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                           , D.CATE_NAME AS CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			IF isnull(@p_day_info,'') <> '' 
				BEGIN
    				SET @mst_loop_cnt    = 0
    				SET @v_delimiter     = '!'  -- 데이터 구분자
    				SET @sub_v_delimiter = '#'
    				SET @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    	    
    				IF @max_loop_cnt > 0 
    					 BEGIN
    					 -- bucket
    					 SET @mst_loop_cnt = 0	
    					 SET @max_loop_cnt = 0
    					 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    					 --SET @v_Tmp1       = ''
    					 WHILE @mst_loop_cnt < @max_loop_cnt
    						 BEGIN
    							 SET @mst_loop_cnt     =  @mst_loop_cnt +1
    							 SET @tmp_column       = ''
    							 SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
    							 SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

    							 SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN (Y/N)
								 SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => D_Value (D0...DN)
								 SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 => _DATE(20210221)
								 --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
								 --SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
								 --SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))
    							  SET @v_dSql += '                      , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''' + @sub_param_2 + ''' AND A.PLAN_DATE >= H.INSTANCE_DATE THEN A.GAP_QTY ELSE 0 END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
    						 
							 END 
    					END
				END
  --SET @v_dSql += '
  --{
  --                              var sql="";
  --                              var list = $data.bucket;
  --
  --          		        				if(list.size() > 0) {
  --          			        				  for(var i = 0; i < list.size(); i++) {
  --          			        				    sql+="                           , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''''" + list[i].VALUE + "'''' AND A.PLAN_DATE >= H.INSTANCE_DATE THEN A.GAP_QTY ELSE 0 END) AS D" + i + "' + char(10)
  --          			        				  }
  --          			        			}
  --
  --                              sql;
  --                            }

  --'
  SET @v_dSql += '                           , D.CATE_ID AS CATEGORY_ID'+char(10)
  SET @v_dSql += '                           , D.CATE_ORDER AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                           , ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                           , NULL AS S_ROW'+char(10)
  SET @v_dSql += '      						FROM ('+char(10)
  SET @v_dSql += '      								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                              , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '                              , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                              , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '                              , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                              , A.PLAN_DATE'+char(10)
  SET @v_dSql += '                              , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY'+char(10)
  SET @v_dSql += '                              , A.CUSTOMER_ID, A.PLAN_TYPE'+char(10)
  SET @v_dSql += '      								FROM ('+char(10)
  SET @v_dSql += '      								  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '      									   , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '      									   , A.OPERATION_ID'+char(10)
  SET @v_dSql += '      									   , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '      									   , ''-'' AS PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '      									   , A.LINE_ID'+char(10)
  SET @v_dSql += '      									   , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      									   , A.PLAN_DATE'+char(10)
  SET @v_dSql += '      									   , A.PLAN_QTY AS OUT_QTY'+char(10)
  SET @v_dSql += '      									   , 0 AS RESULT_QTY'+char(10)
  SET @v_dSql += '      									   , ''-'' AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '      									   , A.PLAN_TYPE'+char(10)
  SET @v_dSql += '			                  FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			                  WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '			                  AND 	A.PLAN_TYPE = ''RELEASE'''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sDiv = $data.DIVISION_LT;
  --			                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sPlt = $data.PLANT_LT;
  --			                    sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --			                    sql;
  --			                  }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sFac = $data.FACTORY_LT;
  --			                    sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += '			                  AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sLine = $data.LINE_LT;
  --			                    sql="AND    A.LINE_ID IN (" + sLine + ")";
  --			                    sql;
  --			                  }

  --'
  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sModelLt = $data.MODEL_LT;
  --
  --			                    if(sModelLt!="" && sModelLt!=null)  sql="AND    A.TOP_ITEM_ID IN (" + sModelLt + ")' + char(10)
  --
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '			                  AND    (A.PLAN_IN_QTY > 0 OR  A.PLAN_QTY > 0)'+char(10) 
  --SET @v_dSql += '			                  AND    (A.PLAN_IN_QTY <> 0 OR  A.PLAN_QTY <> 0)'+char(10) -- 마이너스 처리를 위한 수정
  SET @v_dSql += '			                  UNION ALL'+char(10)
  SET @v_dSql += '      								  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '      									   , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE'+char(10)
  SET @v_dSql += '      									   , A.OPERATION_ID'+char(10)
  SET @v_dSql += '      									   , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '      									   , ''-'' AS PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '      									   , A.LINE_ID'+char(10)
  SET @v_dSql += '      									   , A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      									   , A.PLAN_DATE'+char(10)
  SET @v_dSql += '      									   , 0 AS OUT_QTY'+char(10)
  SET @v_dSql += '      									   , A.ACTUAL_GOOD_QTY AS RESULT_QTY'+char(10)
  SET @v_dSql += '      									   , ''-'' AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '      									   , ''P_RESULT'' AS PLAN_TYPE'+char(10)
  SET @v_dSql += '			                  FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			                  WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_model_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_model_id)) + char(10)
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sDiv = $data.DIVISION_LT;
  --			                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sPlt = $data.PLANT_LT;
  --			                    sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --			                    sql;
  --			                  }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sFac = $data.FACTORY_LT;
  --			                    sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += '			                  AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sLine = $data.LINE_LT;
  --			                    sql="AND    A.LINE_ID IN (" + sLine + ")";
  --			                    sql;
  --			                  }

  --'
  --SET @v_dSql += ' ' +@opt_4top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --			                    var sql="";
  --			                    var sModelLt = $data.MODEL_LT;
  --
  --			                    if(sModelLt!="" && sModelLt!=null)  sql="AND    A.TOP_ITEM_ID IN (" + sModelLt + ")' + char(10)
  --
  --			                    sql;
  --			                  }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += '			                  AND    A.ACTUAL_GOOD_QTY > 0'+char(10)
  --SET @v_dSql += '			                  AND    A.ACTUAL_GOOD_QTY <> 0'+char(10)  -- 마이너스 처리를 위한 수정
  SET @v_dSql += '  			              ) A'+char(10)
  SET @v_dSql += '    									-- 확정시점 가져오기'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF(ISNULL(@p_confirm_area,'') = 'BUILDING') --factory 단위
				BEGIN

			        SET @v_dSql += '                          INNER JOIN (                                                                       ' + char(10)
			        SET @v_dSql += '                                     SELECT A.FACTORY_ID, CONVERT(DATETIME,A.INSTANCE_DATE) AS INSTANCE_DATE ' + char(10)
			        SET @v_dSql += '                                     FROM (                                                                  ' + char(10)
			        SET @v_dSql += '                                           SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME     ' + char(10)
			        SET @v_dSql += '                                              , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
			        SET @v_dSql += '                                           FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                ' + char(10)
			        SET @v_dSql += '                                           WHERE  A.INSTANCE_ID = ' + @v_instance_id + '               ' + char(10)
			        SET @v_dSql += '                                           AND    A.FACTORY_ID IN (                                    ' + char(10)
			        SET @v_dSql += '                                                          SELECT DISTINCT B.FACTORY_ID                 ' + char(10)
			        SET @v_dSql += '                                                          FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)  ' + char(10)
			        SET @v_dSql += '                                                          INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)      ' + char(10)
			        SET @v_dSql += '                                                          ON    A.FACTORY_ID  = B.FACTORY_ID           ' + char(10)
			        SET @v_dSql += '                                                          AND   A.ACTIVE_FLAG = ''Y''                  ' + char(10)
			        SET @v_dSql += '                                                          AND   B.ACTIVE_FLAG = ''Y''                  ' + char(10)
			        SET @v_dSql += '                                                          AND   A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			        SET @v_dSql += '                                                          )           ' + char(10)
			        SET @v_dSql += '                                     ) A                              ' + char(10)
			        SET @v_dSql += '                                     WHERE A.ROW_NUM = 1              ' + char(10)
			        SET @v_dSql += '                                 ) B                                  ' + char(10)
			        SET @v_dSql += '                                 ON    A.FACTORY_ID = B.FACTORY_ID    ' + char(10)
			        SET @v_dSql += '                                 WHERE A.PLAN_DATE >= B.INSTANCE_DATE ' + char(10)
                END
			ELSE  --plan groupd 단위
				BEGIN

			        SET @v_dSql += '                          INNER JOIN SCM_LINE_M C WITH(NOLOCK)    ' + char(10)
			        SET @v_dSql += '                          ON  A.COMPANY_ID     = C.COMPANY_ID     ' + char(10)
			        SET @v_dSql += '                          AND A.DIVISION_ID    = C.DIVISION_ID    ' + char(10)
			        SET @v_dSql += '                          AND A.SITE_ID        = C.SITE_ID        ' + char(10)
			        SET @v_dSql += '                          AND A.PLANT_ID       = C.PLANT_ID       ' + char(10)
			        SET @v_dSql += '                          AND A.FACTORY_ID     = C.FACTORY_ID     ' + char(10)
			        SET @v_dSql += '                          AND A.OPERATION_ID   = C.OPERATION_ID   ' + char(10)
			        SET @v_dSql += '                          AND A.LINE_ID        = C.LINE_ID        ' + char(10)
			        SET @v_dSql += '                          AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			        SET @v_dSql += '                          INNER JOIN (                            ' + char(10)
			        SET @v_dSql += '                                SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE ' + char(10)
			        SET @v_dSql += '                                FROM (                                  ' + char(10)
			        SET @v_dSql += '                                       SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME     ' + char(10)
			        SET @v_dSql += '                                          , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
			        SET @v_dSql += '                                       FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)               ' + char(10)
			        SET @v_dSql += '                                       WHERE  A.INSTANCE_ID = ' + @v_instance_id + '              ' + char(10)
			        SET @v_dSql += '                                       AND    A.PLAN_GROUP_ID IN (                                ' + char(10)
			        SET @v_dSql += '                                                      SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID ' + char(10)
			        SET @v_dSql += '                                                      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  ' + char(10)
			        SET @v_dSql += '                                                      WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
			        SET @v_dSql += '                                                      AND    A.ACTIVE_FLAG = ''Y''                ' + char(10)
			        SET @v_dSql += '                                                      AND    A.SEGMENT1 = ' + @v_instance_id + '  ' + char(10)
			        SET @v_dSql += '                                                      )        ' + char(10)
			        SET @v_dSql += '                                ) A                            ' + char(10)
			        SET @v_dSql += '                                WHERE A.ROW_NUM = 1            ' + char(10)
			        SET @v_dSql += '                          ) B                                  ' + char(10)
			        SET @v_dSql += '                          ON    C.MODEL_TYPE = B.PLAN_GROUP_ID ' + char(10)
			        SET @v_dSql += '                          WHERE A.PLAN_DATE >= B.INSTANCE_DATE ' + char(10)
			    END    
  --SET @v_dSql += '
  --{
  --                        var sql = "";
  --                        var sType = $data.CONFIRM_AREA;
  --
  --                        if(sType == "BUILDING") { // factory 단위
  --                          sql+="INNER JOIN (' + char(10)
  --                          sql+="            								SELECT A.FACTORY_ID, CONVERT(DATETIME,A.INSTANCE_DATE) AS INSTANCE_DATE' + char(10)
  --                          sql+="            								FROM (' + char(10)
  --                          sql+="            									SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME' + char(10)
  --                          sql+="            										 , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM' + char(10)
  --                          sql+="            									FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)' + char(10)
  --                          sql+="            									WHERE  A.INSTANCE_ID = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                          sql+="            									AND    A.FACTORY_ID IN (' + char(10)
  --                          sql+="              										SELECT DISTINCT B.FACTORY_ID' + char(10)
  --                          sql+="              										FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)' + char(10)
  --                          sql+="              										INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)' + char(10)
  --                          sql+="              										ON    A.FACTORY_ID  = B.FACTORY_ID' + char(10)
  --                          sql+="              										AND   A.ACTIVE_FLAG = ''''Y''''' + char(10)
  --                          sql+="              										AND   B.ACTIVE_FLAG = ''''Y''''' + char(10)
  --                          sql+="              										AND   A.INSTANCE_ID = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                          sql+="            									)' + char(10)
  --                          sql+="            								) A' + char(10)
  --                          sql+="            								WHERE A.ROW_NUM = 1' + char(10)
  --                          sql+="            							) B' + char(10)
  --                          sql+="            							ON    A.FACTORY_ID = B.FACTORY_ID' + char(10)
  --                          sql+="            							WHERE A.PLAN_DATE >= B.INSTANCE_DATE' + char(10)
  --                        }
  --                        else { // plan groupd 단위
  --                          sql+="INNER JOIN SCM_LINE_M C WITH(NOLOCK)' + char(10)
  --                          sql+="                          ON  A.COMPANY_ID     = C.COMPANY_ID' + char(10)
  --                          sql+="                          AND A.DIVISION_ID    = C.DIVISION_ID' + char(10)
  --                          sql+="                          AND A.SITE_ID        = C.SITE_ID' + char(10)
  --                          sql+="                          AND A.PLANT_ID       = C.PLANT_ID' + char(10)
  --                          sql+="                          AND A.FACTORY_ID     = C.FACTORY_ID' + char(10)
  --                          sql+="                          AND A.OPERATION_ID   = C.OPERATION_ID' + char(10)
  --                          sql+="                          AND A.LINE_ID        = C.LINE_ID' + char(10)
  --                          sql+="                          AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE' + char(10)
  --                          sql+="                          INNER JOIN (' + char(10)
  --                          sql+="                          	SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE' + char(10)
  --                          sql+="                          	FROM (' + char(10)
  --                          sql+="                          		SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME' + char(10)
  --                          sql+="                          			 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM' + char(10)
  --                          sql+="                          		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)' + char(10)
  --                          sql+="                          		WHERE  A.INSTANCE_ID = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                          sql+="                          		AND    A.PLAN_GROUP_ID IN (' + char(10)
  --                          sql+="                          				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID' + char(10)
  --                          sql+="                          				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
  --                          sql+="                          				WHERE  A.LOOKUP_TYPE_CODE = ''''INSTANCE_PLANNING_GROUP''''' + char(10)
  --                          sql+="                          				AND    A.ACTIVE_FLAG = ''''Y''''' + char(10)
  --                          sql+="                          				AND    A.SEGMENT1 = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                          sql+="                          		)' + char(10)
  --                          sql+="                          	) A' + char(10)
  --                          sql+="                          	WHERE A.ROW_NUM = 1' + char(10)
  --                          sql+="                          ) B' + char(10)
  --                          sql+="                          ON    C.MODEL_TYPE = B.PLAN_GROUP_ID' + char(10)
  --                          sql+="                          WHERE A.PLAN_DATE >= B.INSTANCE_DATE' + char(10)
  --                        }
  --
  --                        sql;
  --                      }

  --'
  SET @v_dSql += '        							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '        			                       , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '        			                       , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION'+char(10)
  SET @v_dSql += '        			                       , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '        			                       , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '        			                       , A.PLAN_DATE, A.CUSTOMER_ID, A.PLAN_TYPE'+char(10)
  SET @v_dSql += '                ) A'+char(10)
  SET @v_dSql += '                INNER HASH JOIN ('+char(10)
  SET @v_dSql += '              				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '              					 , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '                                 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '                                 ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE'+char(10)
  SET @v_dSql += '              					 , ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '              				FROM   SCM_ITEM_M A WITH(NOLOCK),SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              				WHERE  A.ITEM_CLASS = C.CLASS_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nickname_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nickname_id)) + char(10)
  --SET @v_dSql += '
  --{
  --    		                var sql="";
  --    		                var sNickNameLt = $data.NICKNAME_LT;
  --
  --    		                if(sNickNameLt!="" && sNickNameLt!=null)  sql="AND   ISNULL(A.NICK_NAME,''''-'''') IN (" + sNickNameLt + ")' + char(10)
  --
  --    		                sql;
  --    		              }

  --'
  SET @v_dSql += '                ) C'+char(10)
  SET @v_dSql += '                ON     A.COMPANY_ID  = C.COMPANY_ID'+char(10)
  SET @v_dSql += '                AND    A.DIVISION_ID = C.DIVISION_ID'+char(10)
  SET @v_dSql += '                AND    A.SITE_ID     = C.SITE_ID'+char(10)
  SET @v_dSql += '                AND    A.TOP_ITEM_ID = C.ITEM_ID'+char(10)
  SET @v_dSql += '                INNER JOIN ('+char(10)
  SET @v_dSql += '                     SELECT 75 AS CATE_ORDER, ''Accu. Gap'' AS CATE_NAME, ''GAP'' AS CATE_ID'+char(10)
  SET @v_dSql += '                ) D'+char(10)
  SET @v_dSql += '                ON     1=1'+char(10)
  SET @v_dSql += '                INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                ON     A.COMPANY_ID     = E.COMPANY_ID'+char(10)
  SET @v_dSql += '                AND    A.DIVISION_ID    = E.DIVISION_ID'+char(10)
  SET @v_dSql += '                AND    A.SITE_ID        = E.SITE_ID'+char(10)
  SET @v_dSql += '                AND    A.PLANT_ID       = E.PLANT_ID'+char(10)
  SET @v_dSql += '                AND    A.FACTORY_ID     = E.FACTORY_ID'+char(10)
  SET @v_dSql += '                AND    A.OPERATION_ID   = E.OPERATION_ID'+char(10)
  SET @v_dSql += '                AND    A.LINE_ID        = E.LINE_ID'+char(10)
  SET @v_dSql += '                AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                INNER JOIN SCM_OPERATION_M F WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                ON     A.COMPANY_ID     = F.COMPANY_ID'+char(10)
  SET @v_dSql += '                AND    A.DIVISION_ID    = F.DIVISION_ID'+char(10)
  SET @v_dSql += '                AND    A.SITE_ID        = F.SITE_ID'+char(10)
  SET @v_dSql += '                AND    A.OPERATION_ID   = F.OPERATION_ID'+char(10)
  SET @v_dSql += '                INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                ON  A.PLAN_DATE    = G.DT'+char(10)
  SET @v_dSql += '                -- 확정시점 가져오기'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
IF(@p_confirm_area = 'BUILDING') --factory 단위
				BEGIN

			        SET @v_dSql += '                     INNER JOIN ( ' + char(10)
			        SET @v_dSql += '                          SELECT A.FACTORY_ID, A.INSTANCE_DATE ' + char(10)
			        SET @v_dSql += '                          FROM ( ' + char(10)
			        SET @v_dSql += '                              SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME ' + char(10)
			        SET @v_dSql += '                              , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
			        SET @v_dSql += '                              FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			        SET @v_dSql += '                              WHERE  A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			        SET @v_dSql += '                              AND    A.FACTORY_ID IN ( ' + char(10)
			        SET @v_dSql += '                                  SELECT DISTINCT B.FACTORY_ID ' + char(10)
			        SET @v_dSql += '                                  FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK) ' + char(10)
			        SET @v_dSql += '                                  INNER JOIN SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
			        SET @v_dSql += '                                  ON    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			        SET @v_dSql += '                                  AND   A.ACTIVE_FLAG = ''Y'' ' + char(10)
			        SET @v_dSql += '                                  AND   B.ACTIVE_FLAG = ''Y'' ' + char(10)
			        SET @v_dSql += '                                  AND   A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			        SET @v_dSql += '                              ) ' + char(10)
			        SET @v_dSql += '                          ) A ' + char(10)
			        SET @v_dSql += '                          WHERE A.ROW_NUM = 1 ' + char(10)
			        SET @v_dSql += '                      ) H ' + char(10)
			        SET @v_dSql += '                      ON    A.FACTORY_ID = H.FACTORY_ID ' + char(10)
                END
			ELSE --plan groupd 단위
				BEGIN
			        SET @v_dSql += '                     INNER JOIN (                                  ' + char(10)
			        SET @v_dSql += '                           SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE ' + char(10)
			        SET @v_dSql += '                           FROM (                                  ' + char(10)
			        SET @v_dSql += '                                SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME    ' + char(10)
			        SET @v_dSql += '                                  , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
			        SET @v_dSql += '                                FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                ' + char(10)
			        SET @v_dSql += '                                WHERE  A.INSTANCE_ID = ' + @v_instance_id + '               ' + char(10)
			        SET @v_dSql += '                                AND    A.PLAN_GROUP_ID IN (                                 ' + char(10)
			        SET @v_dSql += '                                    SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID             ' + char(10)
			        SET @v_dSql += '                                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
			        SET @v_dSql += '                                    WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
			        SET @v_dSql += '                                    AND    A.ACTIVE_FLAG = ''Y''                            ' + char(10)
			        SET @v_dSql += '                                    AND    A.SEGMENT1 = ' + @v_instance_id + '              ' + char(10)
			        SET @v_dSql += '                                )                           ' + char(10)
			        SET @v_dSql += '                           ) A                              ' + char(10)
			        SET @v_dSql += '                           WHERE A.ROW_NUM = 1              ' + char(10)
			        SET @v_dSql += '                       ) H                                  ' + char(10)
			        SET @v_dSql += '                       ON    E.MODEL_TYPE = H.PLAN_GROUP_ID ' + char(10)
                END
  --SET @v_dSql += '
  --{
  --                  var sql = "";
  --                  var sType = $data.CONFIRM_AREA;
  --
  --                  if(sType == "BUILDING") { // factory 단위
  --                    sql+="INNER JOIN (' + char(10)
  --                    sql+="                        SELECT A.FACTORY_ID, A.INSTANCE_DATE' + char(10)
  --                    sql+="                        FROM (' + char(10)
  --                    sql+="                            SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME' + char(10)
  --                    sql+="                            , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM' + char(10)
  --                    sql+="                            FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)' + char(10)
  --                    sql+="                            WHERE  A.INSTANCE_ID = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                    sql+="                            AND    A.FACTORY_ID IN (' + char(10)
  --                    sql+="                                SELECT DISTINCT B.FACTORY_ID' + char(10)
  --                    sql+="                                FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)' + char(10)
  --                    sql+="                                INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)' + char(10)
  --                    sql+="                                ON    A.FACTORY_ID  = B.FACTORY_ID' + char(10)
  --                    sql+="                                AND   A.ACTIVE_FLAG = ''''Y''''' + char(10)
  --                    sql+="                                AND   B.ACTIVE_FLAG = ''''Y''''' + char(10)
  --                    sql+="                                AND   A.INSTANCE_ID = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                    sql+="                            )' + char(10)
  --                    sql+="                        ) A' + char(10)
  --                    sql+="                        WHERE A.ROW_NUM = 1' + char(10)
  --                    sql+="                    ) H' + char(10)
  --                    sql+="                    ON    A.FACTORY_ID = H.FACTORY_ID' + char(10)
  --                  }
  --                  else { // plan groupd 단위
  --                    sql+="INNER JOIN (' + char(10)
  --                    sql+="                          	SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE' + char(10)
  --                    sql+="                          	FROM (' + char(10)
  --                    sql+="                          		SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME' + char(10)
  --                    sql+="                          			 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM' + char(10)
  --                    sql+="                          		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)' + char(10)
  --                    sql+="                          		WHERE  A.INSTANCE_ID = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                    sql+="                          		AND    A.PLAN_GROUP_ID IN (' + char(10)
  --                    sql+="                          				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID' + char(10)
  --                    sql+="                          				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
  --                    sql+="                          				WHERE  A.LOOKUP_TYPE_CODE = ''''INSTANCE_PLANNING_GROUP''''' + char(10)
  --                    sql+="                          				AND    A.ACTIVE_FLAG = ''''Y''''' + char(10)
  --                    sql+="                          				AND    A.SEGMENT1 = ''''" + $data.INSTANCE_ID + "''''' + char(10)
  --                    sql+="                          		)' + char(10)
  --                    sql+="                          	) A' + char(10)
  --                    sql+="                          	WHERE A.ROW_NUM = 1' + char(10)
  --                    sql+="                          ) H' + char(10)
  --                    sql+="                          ON    E.MODEL_TYPE = H.PLAN_GROUP_ID' + char(10)
  --                  }
  --
  --                  sql;
  --                }

  --'
  SET @v_dSql += '                INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                ON  A.COMPANY_ID  = J.COMPANY_ID'+char(10)
  SET @v_dSql += '                AND A.DIVISION_ID = J.DIVISION_ID'+char(10)
  SET @v_dSql += '                AND A.SITE_ID     = J.SITE_ID'+char(10)
  SET @v_dSql += '                AND A.TOP_ITEM_ID = J.ITEM_ID'+char(10)
  SET @v_dSql += '                WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_lt)) + char(10)
  --SET @v_dSql += '
  --{
  --                  var sql="";
  --                  var sDiv = $data.DIVISION_LT;
  --                  sql="AND    A.DIVISION_ID IN (" + sDiv + ")";
  --                  sql;
  --                }

  --'
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND    A.SITE_ID   = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --                  var sql="";
  --                  var sPlt = $data.PLANT_LT;
  --                  sql="AND    A.PLANT_ID IN (" + sPlt + ")";
  --                  sql;
  --                }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --                  var sql="";
  --                  var sFac = $data.FACTORY_LT;
  --                  sql="AND    A.FACTORY_ID IN (" + sFac + ")";
  --                  sql;
  --                }

  --'
  SET @v_dSql += '                AND    A.OPERATION_ID ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --                  var sql="";
  --                  var sLine = $data.LINE_LT;
  --                  sql="AND    A.LINE_ID IN (" + sLine + ")";
  --                  sql;
  --                }

  --'
  SET @v_dSql += ' ' +@opt_5item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_23item_name +' '+''+char(10)--AND    C.NICK_NAME LIKE '%' + #ITEM_NAME# + '%'
  SET @v_dSql += ' ' +@opt_24cell_group +' '+''+char(10)--AND    J.CELL_GROUP LIKE '%' + #CELL_GROUP# + '%'
  SET @v_dSql += '          			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                           , J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, C.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'')'+char(10)
  SET @v_dSql += '                           , A.OPERATION_ID, ISNULL(F.OPERATION_NAME, ''-'')'+char(10)
  SET @v_dSql += '                           , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '                           , A.FACTORY_ID, A.LOCATION, A.LINE_ID, ISNULL(E.LINE_NAME,''-''), A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                           , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER'+char(10)
  SET @v_dSql += '              ) A'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , T_RELEASE AS ('+char(10)
  SET @v_dSql += '        SELECT A.FACTORY_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			IF isnull(@p_day_info,'') <> '' 
				BEGIN
    				SET @mst_loop_cnt    = 0
    				SET @v_delimiter     = '!'  -- 데이터 구분자
    				SET @sub_v_delimiter = '#'
    				SET @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    	    
    				IF @max_loop_cnt > 0 
    					 BEGIN
    					 -- bucket
    					 SET @mst_loop_cnt = 0	
    					 SET @max_loop_cnt = 0
    					 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    					 --SET @v_Tmp1       = ''
    					 WHILE @mst_loop_cnt < @max_loop_cnt
    						 BEGIN
    							 SET @mst_loop_cnt     =  @mst_loop_cnt +1
    							 SET @tmp_column       = ''
    							 SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
    							 SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

    							 SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN (Y/N)
								 SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => D_Value (D0...DN)
								 SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 => _DATE(20210221)
								 --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
								 --SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
								 --SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))
    							 SET @v_dSql += '        , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112)=''' + @sub_param_2 + '''  THEN ''Y'' ELSE NULL END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG' + char(10)
    						 
							 END 
    					END
				END
  --SET @v_dSql += '
  --{
  --                var sql="";
  --                var list = $data.bucket;
  --                for(var i = 0; i < list.size(); i++) {
  --                  sql+="               , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112)=''''" + list[i].VALUE + "'''' THEN ''''Y'''' ELSE NULL END) AS D" + i + "_BG ' + char(10)
  --                }
  --              }

  --'
  SET @v_dSql += '        FROM ('+char(10)
  SET @v_dSql += '          SELECT A.FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '            SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA'+char(10)
  SET @v_dSql += '                 , A.FACTORY_ID, A.INSERT_TIME'+char(10)
  SET @v_dSql += '                 , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER'+char(10)
  SET @v_dSql += '            FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            , ('+char(10)
  SET @v_dSql += '              SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '              FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              WHERE  A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '              AND    A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '            ) B'+char(10)
  SET @v_dSql += '            WHERE  A.INSTANCE_ID  = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '            AND    A.FACTORY_ID   = B.FACTORY_ID'+char(10)
  SET @v_dSql += '            AND    A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          , SCM_FP_PLAN_H B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE A.INSTANCE_ID  = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '          AND   A.PLAN_ID      = B.PLAN_ID'+char(10)
  SET @v_dSql += '          AND   A.SORT_ORDER   = 1'+char(10)
  SET @v_dSql += '          AND   A.CONFIRM_AREA IN ('+char(10)
  SET @v_dSql += '            SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA'+char(10)
  SET @v_dSql += '            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'''+char(10)
  SET @v_dSql += '            AND    A.SEGMENT1         ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '            AND    A.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '          )'+char(10)
  SET @v_dSql += '        ) A'+char(10)
  SET @v_dSql += '        GROUP BY A.FACTORY_ID'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT A.*'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			IF isnull(@p_day_info,'') <> '' 
				BEGIN
    				SET @mst_loop_cnt    = 0
    				SET @v_delimiter     = '!'  -- 데이터 구분자
    				SET @sub_v_delimiter = '#'
    				SET @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    	    
    				IF @max_loop_cnt > 0 
    					 BEGIN
    					 -- bucket
    					 SET @mst_loop_cnt = 0	
    					 SET @max_loop_cnt = 0
    					 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    					 --SET @v_Tmp1       = ''
    					 WHILE @mst_loop_cnt < @max_loop_cnt
    						 BEGIN
    							 SET @mst_loop_cnt     =  @mst_loop_cnt +1
    							 SET @tmp_column       = ''
    							 SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
    							 SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

    							 SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN (Y/N)
								 SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => D_Value (D0...DN)
								 SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 => _DATE(20210221)
								 --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
								 --SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
								 --SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))
    							   SET @v_dSql += '      , CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85'' ' + char(10)
								   SET @v_dSql += '             WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2'' ' + char(10)
								   SET @v_dSql += '             WHEN A.DATA_TYPE=''DATA'' THEN (CASE WHEN F.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG = ''Y'' THEN ''#FFFFE6'' ELSE '''' END ) ' + char(10)
								  SET @v_dSql += '        ELSE '''' END AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG ' + char(10)
    						 
							 END 
    					END
				END
  --SET @v_dSql += '
  --{
  --              var sql="";
  --              var list = $data.bucket;
  --              for(var i = 0; i < list.size(); i++) {
  --                sql+=" ,	CASE WHEN A.DATA_TYPE=''''TOTAL_2'''' THEN ''''#FFBA85''''  ' + char(10)
  --                sql+="  		   WHEN A.DATA_TYPE=''''TOTAL'''' THEN ''''#FFE5C2''''  ' + char(10)
  --                sql+="  		   WHEN A.DATA_TYPE=''''DATA'''' THEN (CASE WHEN F.D" + i + "_BG = ''''Y'''' THEN ''''#FFFFE6'''' ELSE '''''''' END )  ' + char(10)
  --                sql+="  		   ELSE '''''''' END AS D" + i + "_BG ' + char(10)
  --              }
  --            }

  --'
  SET @v_dSql += '      FROM  ('+char(10)
  SET @v_dSql += '          SELECT * FROM MAIN_P'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT * FROM MAIN_GAP'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT * FROM #MAIN_GAP_WPP'+char(10)
							-- p : sub total
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                ,A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                ,A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                , NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '                ,''P'' AS PSI'+char(10)
  SET @v_dSql += '                ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			IF ISNULL(@p_day_info,'') <> ''
                BEGIN
                    SET @mst_loop_cnt     = 0
                    SET @v_delimiter      = '!'  -- 데이터 구분자
                    SET @sub_v_delimiter  = '#'
                    SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

                    IF @max_loop_cnt > 0 
                        BEGIN
                    	    -- monthinfo
                    	    SET @mst_loop_cnt = 0
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp1       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                    	    
                    	    -- weekinfo
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp2       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1						
                    	        END
                    	    
                    	    -- bucket
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp3       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                    	            
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                        END 
                END

  SET @v_dSql += '                ,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                , (CASE WHEN A.CATEGORY_ID=''M_IN'' THEN 100'+char(10)
  SET @v_dSql += '               		   WHEN A.CATEGORY_ID=''M_OUT'' THEN 200'+char(10)
  SET @v_dSql += '               		   WHEN A.CATEGORY_ID=''W_IN'' THEN 300'+char(10)
  SET @v_dSql += '               		   WHEN A.CATEGORY_ID=''W_OUT'' THEN 400'+char(10)
  SET @v_dSql += '               		   WHEN A.CATEGORY_ID=''P_IN'' THEN 500'+char(10)
  SET @v_dSql += '               		   WHEN A.CATEGORY_ID=''P_OUT'' THEN 600'+char(10)
  SET @v_dSql += '               		   WHEN A.CATEGORY_ID=''P_RESULT'' THEN 650'+char(10) -- Result
  SET @v_dSql += '               		   ELSE 800 END) AS CATEGORY_ORDER'+char(10) -- Result(+Exp.)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                ,NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   MAIN_P A'+char(10)
  SET @v_dSql += '          WHERE A.CATEGORY_ID <> ''P_YIELD'''+char(10)
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                  ,A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                  ,A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                  ,A.CATE,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                ,A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                ,A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                , NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '                ,''P'' AS PSI'+char(10)
  SET @v_dSql += '                ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			IF ISNULL(@p_day_info,'') <> ''
                BEGIN
                    SET @mst_loop_cnt     = 0
                    SET @v_delimiter      = '!'  -- 데이터 구분자
                    SET @sub_v_delimiter  = '#'
                    SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

                    IF @max_loop_cnt > 0 
                        BEGIN
                    	    -- monthinfo
                    	    SET @mst_loop_cnt = 0
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp1       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                    	    
                    	    -- weekinfo
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp2       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1						
                    	        END
                    	    
                    	    -- bucket
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp3       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                    	            
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                        END 
                END

  SET @v_dSql += '                ,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                ,850 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                ,NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   MAIN_GAP A'+char(10)
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                  ,A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                  ,A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                  ,A.CATE,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                ,A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                ,A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                , NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '                ,''P'' AS PSI'+char(10)
  SET @v_dSql += '                ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF ISNULL(@p_day_info,'') <> ''
  BEGIN
	SET @mst_loop_cnt     = 0
	SET @v_delimiter      = '!'  -- 데이터 구분자
	SET @sub_v_delimiter  = '#'
	SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
  
	IF @max_loop_cnt > 0 
    BEGIN
        -- 1. monthinfo
        SET @mst_loop_cnt = 0
        SET @max_loop_cnt = 0
        SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
        --SET @v_Tmp1       = ''
        WHILE @mst_loop_cnt < @max_loop_cnt
        BEGIN
            SET @v_dSql += '                , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            SET @mst_loop_cnt =  @mst_loop_cnt + 1
        END
                  	    
        -- 2. weekinfo
        SET @mst_loop_cnt = 0	
        SET @max_loop_cnt = 0
        SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
        --SET @v_Tmp2       = ''
        WHILE @mst_loop_cnt < @max_loop_cnt
        BEGIN
            SET @v_dSql += '                , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            SET @mst_loop_cnt =  @mst_loop_cnt + 1						
        END
                  	    
        -- 3. bucket
        SET @mst_loop_cnt = 0	
        SET @max_loop_cnt = 0
        SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
        --SET @v_Tmp3       = ''
        WHILE @mst_loop_cnt < @max_loop_cnt
        BEGIN
            SET @v_dSql += '                , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            SET @mst_loop_cnt =  @mst_loop_cnt + 1
        END

	END 
  END

  SET @v_dSql += '                ,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                ,870 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                ,NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   #MAIN_GAP_WPP A'+char(10)
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '                  ,A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SET @v_dSql += '                  ,A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '                  ,A.CATE,A.CATEGORY_ID'+char(10)
                            -- total
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS CELL_GROUP, NULL AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS OPERATION_ID, NULL AS OPERATION_NAME'+char(10)
  SET @v_dSql += '                , NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '                ,''P'' AS PSI'+char(10)
  SET @v_dSql += '                ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
			IF ISNULL(@p_day_info,'') <> ''
                BEGIN
                    SET @mst_loop_cnt     = 0
                    SET @v_delimiter      = '!'  -- 데이터 구분자
                    SET @sub_v_delimiter  = '#'
                    SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

                    IF @max_loop_cnt > 0 
                        BEGIN
                    	    -- monthinfo
                    	    SET @mst_loop_cnt = 0
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp1       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                    	    
                    	    -- weekinfo
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp2       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1						
                    	        END
                    	    
                    	    -- bucket
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp3       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	            SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                    	            
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                        END 
                END

  SET @v_dSql += '                ,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                , (CASE WHEN A.CATEGORY_ID=''M_IN'' THEN 1000'+char(10)
  SET @v_dSql += '               						  WHEN A.CATEGORY_ID=''M_OUT'' THEN 2000'+char(10)
  SET @v_dSql += '               						  WHEN A.CATEGORY_ID=''W_IN'' THEN 3000'+char(10)
  SET @v_dSql += '               						  WHEN A.CATEGORY_ID=''W_OUT'' THEN 4000'+char(10)
  SET @v_dSql += '               						  WHEN A.CATEGORY_ID=''P_IN'' THEN 5000'+char(10)
  SET @v_dSql += '               						  WHEN A.CATEGORY_ID=''P_OUT'' THEN 6000'+char(10)
  SET @v_dSql += '               						  WHEN A.CATEGORY_ID=''P_RESULT'' THEN 6500'+char(10) -- result
  SET @v_dSql += '               						  ELSE 7000 END) AS CATEGORY_ORDER'+char(10) -- Result(+Exp.)
  SET @v_dSql += '                ,''TOTAL_2'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                ,NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   MAIN_P A'+char(10)
  SET @v_dSql += '          WHERE A.CATEGORY_ID <> ''P_YIELD'''+char(10)
  SET @v_dSql += '          GROUP BY A.CATE, A.CATEGORY_ID'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS CELL_GROUP, NULL AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS OPERATION_ID, NULL AS OPERATION_NAME'+char(10)
  SET @v_dSql += '                , NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '                ,''P'' AS PSI'+char(10)
  SET @v_dSql += '                ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
			IF ISNULL(@p_day_info,'') <> ''
                BEGIN
                    SET @mst_loop_cnt     = 0
                    SET @v_delimiter      = '!'  -- 데이터 구분자
                    SET @sub_v_delimiter  = '#'
                    SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

                    IF @max_loop_cnt > 0 
                        BEGIN
                    	    -- monthinfo
                    	    SET @mst_loop_cnt = 0
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp1       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	              SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                    	    
                    	    -- weekinfo
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp2       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	              SET @v_dSql += '           , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1						
                    	        END
                    	    
                    	    -- bucket
                    	    SET @mst_loop_cnt = 0	
                    	    SET @max_loop_cnt = 0
                    	    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    --SET @v_Tmp3       = ''
                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
                      	              SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                    	            
                      	            SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    	        END
                        END 
                END

  SET @v_dSql += '                ,A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                ,7500 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL_2'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                ,NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   MAIN_GAP A'+char(10)
  SET @v_dSql += '          GROUP BY A.CATE, A.CATEGORY_ID'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS CELL_GROUP, NULL AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME'+char(10)
  SET @v_dSql += '                ,NULL AS OPERATION_ID, NULL AS OPERATION_NAME'+char(10)
  SET @v_dSql += '                , NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID'+char(10)
  SET @v_dSql += '                ,''P'' AS PSI'+char(10)
  SET @v_dSql += '                ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  IF ISNULL(@p_day_info,'') <> ''
  BEGIN
  		SET @mst_loop_cnt     = 0
  		SET @v_delimiter      = '!'  -- 데이터 구분자
  		SET @sub_v_delimiter  = '#'
  		SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
  
  		IF @max_loop_cnt > 0 
  		BEGIN
  			-- monthinfo
  			SET @mst_loop_cnt = 0
  			SET @max_loop_cnt = 0
  			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			--SET @v_Tmp1       = ''
  			WHILE @mst_loop_cnt < @max_loop_cnt
  			BEGIN
                SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                SET @mst_loop_cnt =  @mst_loop_cnt + 1
  			END
                  	    
  			-- weekinfo
  			SET @mst_loop_cnt = 0	
  			SET @max_loop_cnt = 0
  			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			--SET @v_Tmp2       = ''
  			WHILE @mst_loop_cnt < @max_loop_cnt
  			BEGIN
                SET @v_dSql += '           , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END
                  	    
  			-- bucket
  			SET @mst_loop_cnt = 0	
  			SET @max_loop_cnt = 0
  			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  			--SET @v_Tmp3       = ''
  			WHILE @mst_loop_cnt < @max_loop_cnt
  			BEGIN
                SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
                SET @mst_loop_cnt =  @mst_loop_cnt + 1
  			END
  		END 
  END

  SET @v_dSql += '                , A.CATEGORY_ID'+char(10)
  SET @v_dSql += '                , 8000 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                , ''TOTAL_2'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , NULL AS S_ROW'+char(10)
  SET @v_dSql += '          FROM   #MAIN_GAP_WPP A'+char(10)
  SET @v_dSql += '          GROUP BY A.CATE, A.CATEGORY_ID'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN T_RELEASE F WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON 1=1'+char(10)
  SET @v_dSql += '      AND A.FACTORY_ID = F.FACTORY_ID'+char(10)
  SET @v_dSql += '      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID'+char(10)
  SET @v_dSql += '             , (CASE WHEN A.DATA_TYPE = ''TOTAL'' THEN A.CATEGORY_ORDER ELSE 1 END) -- SUB TOTAL : BOTTOM'+char(10)
  SET @v_dSql += '             , A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID'+char(10)
  SET @v_dSql += '             , A.FACTORY_ID, A.LINE_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '; '+char(10)+char(10)

  SET @v_dSql += 'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
  SET @v_dSql += '	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
  SET @v_dSql += 'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
  SET @v_dSql += '	drop table #MAIN_GAP_WPP ' + char(10)

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

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
