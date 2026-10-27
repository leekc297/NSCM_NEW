CREATE PROCEDURE [dbo].[PR_UI_FP00602_FIND_FP00602_XX]
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
/** 프로그램 ID   : PR_UI_FP00602_FIND_FP00602                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_FIND_FP00602                                                                          **/
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
/** 2021-04-15     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_FIND_FP00602
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_FIND_FP00602'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  --DECLARE @p_prod_type_id nvarchar(max) = ''
  DECLARE @p_item_name nvarchar(max) = ''
  DECLARE @p_cell_group nvarchar(max) = ''
  DECLARE @p_plan_type nvarchar(max) = ''
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_week_info nvarchar(max) = ''
  DECLARE @p_month_info nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  --DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_prodtype_id nvarchar(max) = ''
  DECLARE @p_nickname_id nvarchar(max) = ''
  DECLARE @p_cate_info nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  
  DECLARE @p_amend_table nvarchar(max) = ''
  DECLARE @p_amend_sales_table nvarchar(max) = ''
  DECLARE @p_AMEND_UTIL_TABLE nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_prod_type_id nvarchar(max)
  DECLARE @v_item_name nvarchar(max)
  DECLARE @v_cell_group nvarchar(max)
  DECLARE @v_plan_type nvarchar(max)
  DECLARE @v_master_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_week_info nvarchar(max)
  DECLARE @v_month_info nvarchar(max)
  --DECLARE @v_division_lt nvarchar(max)
  --DECLARE @v_plant_lt nvarchar(max)
  --DECLARE @v_factory_lt nvarchar(max)
  --DECLARE @v_operation_lt nvarchar(max)
  --DECLARE @v_line_lt nvarchar(max)
  --DECLARE @v_prodtype_lt nvarchar(max)
  --DECLARE @v_nickname_lt nvarchar(max)
  DECLARE @v_cate_info nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0instance_id nvarchar(max)
  DECLARE @opt_1instance_id nvarchar(max)
  DECLARE @opt_2instance_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4operation_id nvarchar(max)
  DECLARE @opt_5top_item_id nvarchar(max)
  DECLARE @opt_6item_id nvarchar(max)
  DECLARE @opt_7prod_type nvarchar(max)
  DECLARE @opt_8site_id nvarchar(max)
  DECLARE @opt_9operation_id nvarchar(max)
  DECLARE @opt_10top_item_id nvarchar(max)
  DECLARE @opt_11item_id nvarchar(max)
  DECLARE @opt_12prod_type nvarchar(max)
  DECLARE @opt_13item_name nvarchar(max)
  
  DECLARE @opt_40cell_group nvarchar(max)
  DECLARE @opt_41site_id nvarchar(max)
  DECLARE @opt_42operation_id nvarchar(max)
  DECLARE @opt_43top_item_id nvarchar(max)
  DECLARE @opt_44item_id nvarchar(max)
  DECLARE @opt_45item_name nvarchar(max)
  DECLARE @opt_46prod_type nvarchar(max)
  DECLARE @opt_47site_id nvarchar(max)
  DECLARE @opt_48operation_id nvarchar(max)
  DECLARE @opt_49site_id nvarchar(max)
  DECLARE @opt_50operation_id nvarchar(max)
  DECLARE @opt_51top_item_id nvarchar(max)
  DECLARE @opt_52item_id nvarchar(max)
  DECLARE @opt_53item_name nvarchar(max)
  DECLARE @opt_54prod_type nvarchar(max)
  DECLARE @opt_55instance_id nvarchar(max)
  DECLARE @opt_56site_id nvarchar(max)
  DECLARE @opt_57operation_id nvarchar(max)
  DECLARE @opt_58top_item_id nvarchar(max)
  DECLARE @opt_59item_id nvarchar(max)
  DECLARE @opt_60prod_type nvarchar(max)
  DECLARE @opt_61master_id nvarchar(max)
  DECLARE @opt_62master_id nvarchar(max)
  DECLARE @opt_63master_id nvarchar(max)
  DECLARE @opt_64master_id nvarchar(max)
  DECLARE @opt_65master_id nvarchar(max)
  DECLARE @opt_66master_id nvarchar(max)
  DECLARE @opt_67master_id nvarchar(max)
  DECLARE @opt_68master_id nvarchar(max)
  DECLARE @opt_69master_id nvarchar(max)
  DECLARE @opt_70site_id nvarchar(max)
  DECLARE @opt_71operation_id nvarchar(max)
  DECLARE @opt_72top_item_id nvarchar(max)
  DECLARE @opt_73item_id nvarchar(max)
  DECLARE @opt_74prod_type nvarchar(max)
  DECLARE @opt_75site_id nvarchar(max)
  DECLARE @opt_76operation_id nvarchar(max)
  DECLARE @opt_77top_item_id nvarchar(max)
  DECLARE @opt_78item_id nvarchar(max)
  DECLARE @opt_79prod_type nvarchar(max)
  DECLARE @opt_80item_name nvarchar(max)
  DECLARE @opt_81cell_group nvarchar(max)
  DECLARE @opt_82site_id nvarchar(max)
  DECLARE @opt_83operation_id nvarchar(max)
  DECLARE @opt_84top_item_id nvarchar(max)
  DECLARE @opt_85item_id nvarchar(max)
  DECLARE @opt_86item_name nvarchar(max)
  DECLARE @opt_87prod_type nvarchar(max)
  DECLARE @opt_88site_id nvarchar(max)
  DECLARE @opt_89operation_id nvarchar(max)
  DECLARE @opt_90site_id nvarchar(max)
  DECLARE @opt_91operation_id nvarchar(max)
  DECLARE @opt_92top_item_id nvarchar(max)
  DECLARE @opt_93item_id nvarchar(max)
  DECLARE @opt_94item_name nvarchar(max)
  DECLARE @opt_95prod_type nvarchar(max)
  DECLARE @opt_96site_id nvarchar(max)
  DECLARE @opt_97operation_id nvarchar(max)
  DECLARE @opt_98top_item_id nvarchar(max)
  DECLARE @opt_99item_id nvarchar(max)
  DECLARE @opt_100prod_type nvarchar(max)

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
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'PRODTYPE_ID' BEGIN
    --  SET @p_prod_type_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_NAME' BEGIN
      SET @p_item_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
      SET @p_cell_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
      SET @p_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
      SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
      SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'OPERATION_LT' BEGIN
    --  SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PRODTYPE_ID' BEGIN
      SET @p_prodtype_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICKNAME' BEGIN
      SET @p_nickname_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CATE_INFO' BEGIN
      SET @p_cate_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);

	END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
      SET @p_amend_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'AMEND_SALES_TABLE' BEGIN
      SET @p_amend_sales_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'AMEND_UTIL_TABLE' BEGIN
      SET @p_AMEND_UTIL_TABLE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	  
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  --SET @v_prod_type_id ='''' + @p_prod_type_id + ''''
  SET @v_item_name ='''' + @p_item_name + ''''
  SET @v_cell_group ='''' + @p_cell_group + ''''
  SET @v_plan_type ='''' + @p_plan_type + ''''
  SET @v_master_id ='''' + @p_master_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_week_info ='''' + @p_week_info + ''''
  SET @v_month_info ='''' + @p_month_info + ''''
  --SET @v_division_lt ='''' + @p_division_lt + ''''
  --SET @v_plant_lt ='''' + @p_plant_lt + ''''
  --SET @v_factory_lt ='''' + @p_factory_lt + ''''
  --SET @v_operation_lt ='''' + @p_operation_lt + ''''
  --SET @v_line_lt ='''' + @p_line_lt + ''''
  --SET @v_prodtype_lt ='''' + @p_prodtype_lt + ''''
  --SET @v_nickname_lt ='''' + @p_nickname_lt + ''''
  SET @v_cate_info ='''' + @p_cate_info + ''''
  SET @v_param ='''' + @p_param + ''''
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
  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2instance_id = ''
  END ELSE BEGIN
    SET @opt_2instance_id = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4operation_id = ''
  END ELSE BEGIN
    SET @opt_4operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5top_item_id = ''
  END ELSE BEGIN
    SET @opt_5top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6item_id = ''
  END ELSE BEGIN
    SET @opt_6item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_7prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_7prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8site_id = ''
  END ELSE BEGIN
    SET @opt_8site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9operation_id = ''
  END ELSE BEGIN
    SET @opt_9operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10top_item_id = ''
  END ELSE BEGIN
    SET @opt_10top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11item_id = ''
  END ELSE BEGIN
    SET @opt_11item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_12prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_12prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_13item_name = ''
  END ELSE BEGIN
    SET @opt_13item_name = 'AND    B.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END



  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_17cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_17cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_18cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_18cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_19cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_19cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_20cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_20cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_21cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_21cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_22cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_22cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_23cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_23cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_24cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_24cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_25cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_25cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_26cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_26cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_27cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_27cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_28cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_28cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_29cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_29cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_30cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_30cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_31cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_31cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_32cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_32cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_33cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_33cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_34cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_34cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_35cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_35cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_36cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_36cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_37cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_37cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_38cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_38cell_group = 'i'
  --END
  --SET @STRLEN = LEN(@p_cell_group)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_39cell_group = ''
  --END ELSE BEGIN
  --  SET @opt_39cell_group = 'i'
  --END
  SET @STRLEN = LEN(@p_cell_group)
  IF @STRLEN< 1  BEGIN
    SET @opt_40cell_group = ''
  END ELSE BEGIN
    SET @opt_40cell_group = 'AND   J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_41site_id = ''
  END ELSE BEGIN
    SET @opt_41site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_42operation_id = ''
  END ELSE BEGIN
    SET @opt_42operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_43top_item_id = ''
  END ELSE BEGIN
    SET @opt_43top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_44item_id = ''
  END ELSE BEGIN
    SET @opt_44item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_45item_name = ''
  END ELSE BEGIN
    SET @opt_45item_name = 'AND    B.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_46prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_46prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_47site_id = ''
  END ELSE BEGIN
    SET @opt_47site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_48operation_id = ''
  END ELSE BEGIN
    SET @opt_48operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_49site_id = ''
  END ELSE BEGIN
    SET @opt_49site_id = 'AND    AAA.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_50operation_id = ''
  END ELSE BEGIN
    SET @opt_50operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_51top_item_id = ''
  END ELSE BEGIN
    SET @opt_51top_item_id = 'AND    AAA.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_52item_id = ''
  END ELSE BEGIN
    SET @opt_52item_id = 'AND    AAA.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_53item_name = ''
  END ELSE BEGIN
    SET @opt_53item_name = 'AND    BBB.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_54prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_54prod_type = 'AND    AAA.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_55instance_id = ''
  END ELSE BEGIN
    SET @opt_55instance_id = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_56site_id = ''
  END ELSE BEGIN
    SET @opt_56site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_57operation_id = ''
  END ELSE BEGIN
    SET @opt_57operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_58top_item_id = ''
  END ELSE BEGIN
    SET @opt_58top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_59item_id = ''
  END ELSE BEGIN
    SET @opt_59item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_60prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_60prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_61master_id = ''
  END ELSE BEGIN
    SET @opt_61master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_62master_id = ''
  END ELSE BEGIN
    SET @opt_62master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_63master_id = ''
  END ELSE BEGIN
    SET @opt_63master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_64master_id = ''
  END ELSE BEGIN
    SET @opt_64master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_65master_id = ''
  END ELSE BEGIN
    SET @opt_65master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_66master_id = ''
  END ELSE BEGIN
    SET @opt_66master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_67master_id = ''
  END ELSE BEGIN
    SET @opt_67master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_68master_id = ''
  END ELSE BEGIN
    SET @opt_68master_id = 'i'
  END
  SET @STRLEN = LEN(@p_master_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_69master_id = ''
  END ELSE BEGIN
    SET @opt_69master_id = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_70site_id = ''
  END ELSE BEGIN
    SET @opt_70site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_71operation_id = ''
  END ELSE BEGIN
    SET @opt_71operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_72top_item_id = ''
  END ELSE BEGIN
    SET @opt_72top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_73item_id = ''
  END ELSE BEGIN
    SET @opt_73item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_74prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_74prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_75site_id = ''
  END ELSE BEGIN
    SET @opt_75site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_76operation_id = ''
  END ELSE BEGIN
    SET @opt_76operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_77top_item_id = ''
  END ELSE BEGIN
    SET @opt_77top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_78item_id = ''
  END ELSE BEGIN
    SET @opt_78item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_79prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_79prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_80item_name = ''
  END ELSE BEGIN
    SET @opt_80item_name = 'AND    B.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_cell_group)
  IF @STRLEN< 1  BEGIN
    SET @opt_81cell_group = ''
  END ELSE BEGIN
    SET @opt_81cell_group = 'AND   J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_82site_id = ''
  END ELSE BEGIN
    SET @opt_82site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_83operation_id = ''
  END ELSE BEGIN
    SET @opt_83operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_84top_item_id = ''
  END ELSE BEGIN
    SET @opt_84top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_85item_id = ''
  END ELSE BEGIN
    SET @opt_85item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_86item_name = ''
  END ELSE BEGIN
    SET @opt_86item_name = 'AND    B.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_87prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_87prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_88site_id = ''
  END ELSE BEGIN
    SET @opt_88site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_89operation_id = ''
  END ELSE BEGIN
    SET @opt_89operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_90site_id = ''
  END ELSE BEGIN
    SET @opt_90site_id = 'AND    AAA.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_91operation_id = ''
  END ELSE BEGIN
    SET @opt_91operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_92top_item_id = ''
  END ELSE BEGIN
    SET @opt_92top_item_id = 'AND    AAA.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_93item_id = ''
  END ELSE BEGIN
    SET @opt_93item_id = 'AND    AAA.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_94item_name = ''
  END ELSE BEGIN
    SET @opt_94item_name = 'AND    BBB.NICK_NAME LIKE ''%'' + ' + @v_item_name+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_95prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_95prod_type = 'AND    AAA.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_96site_id = ''
  END ELSE BEGIN
    SET @opt_96site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_97operation_id = ''
  END ELSE BEGIN
    SET @opt_97operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_98top_item_id = ''
  END ELSE BEGIN
    SET @opt_98top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_99item_id = ''
  END ELSE BEGIN
    SET @opt_99item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  --SET @STRLEN = LEN(@p_prod_type_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_100prod_type = ''
  --END ELSE BEGIN
  --  SET @opt_100prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type_id+' + ''%'''
  --END


  -- FP00602 find_FP00602  
  SET @v_dSql = ''
  --SET @v_dSql += @p_prodtype_id +char(10)

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

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  DECLARE @bMppIn integer = 0
  DECLARE @bMppOut integer = 0
  DECLARE @bWppIn integer = 0
  DECLARE @bWppOut integer = 0
  DECLARE @bDppIn integer = 0
  DECLARE @bDppOut integer = 0
  DECLARE @bResult integer = 0
  DECLARE @bCell integer = 0
  DECLARE @bUom integer = 0
  DECLARE @bTotal integer = 0
  DECLARE @bSubTotal integer = 0
  DECLARE @bCapa integer = 0
  DECLARE @bTarget integer = 0


      IF isnull(@p_cate_info,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter            = '#'  -- 데이터 구분자
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

					SET @v_dSql +=@tmp_column + char(10)
					SET @v_dSql +=@sub_param_0 + char(10)
					SET @v_dSql +=@sub_param_1 + char(10)
					SET @v_dSql +=@sub_param_2 + char(10)
					SET @v_dSql +=@sub_param_3 + char(10)
					
					IF isnull(@sub_param_0,'') = 'chk_mpp_inqty' and isnull(@sub_param_1,'')='true' BEGIN
						SET @bMppIn = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_mpp_outqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_mpp_outqty' BEGIN
						SET @bMppOut = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_wpp_inqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_wpp_inqty' BEGIN
						SET @bWppIn = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_wpp_outqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_wpp_outqty' BEGIN
						SET @bWppOut = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_inqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_inqty' BEGIN
						SET @bDppIn = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_outqty' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_outqty' BEGIN
						SET @bDppOut = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_result' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_result' BEGIN
						SET @bResult = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_cell' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_cell' BEGIN
						SET @bCell = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_uom' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_uom' BEGIN
						SET @bUom = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_total' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_total' BEGIN
						SET @bTotal = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_subTotal' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_subTotal' BEGIN
						SET @bSubTotal = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_capa' and isnull(@sub_param_1,'')='true' BEGIN--IF @tmp_column = 'chk_capa' BEGIN
						SET @bCapa = 1
					END IF isnull(@sub_param_0,'') = 'chk_target' and isnull(@sub_param_1,'')='true' BEGIN--ELSE IF @tmp_column = 'chk_target' BEGIN
						SET @bTarget = 1
					END 
			END-- END OF WHILE

			SET @v_dSql += '	SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 0 AS CATEGORY_ORDER '+char(10)
  --
  --		          				if( bMppIn == "Y" && bCell == "Y" ) {
  		    IF @bMppIn = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 20 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bMppIn == "Y" && bUom == "Y" ) {
			IF @bMppIn = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 30 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bMppOut == "Y" && bCell == "Y" ) {
			IF @bMppOut = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 40 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bMppOut == "Y" && bUom == "Y" ) {
			IF @bMppOut = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 50 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bWppIn == "Y" && bCell == "Y" ) {
			IF @bWppIn = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 60 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bWppIn == "Y" && bUom == "Y" ) {
			IF @bWppIn = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 70 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bWppOut == "Y" && bCell == "Y" ) {
			IF @bWppOut = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 80 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bWppOut == "Y" && bUom == "Y" ) {
			IF @bWppOut = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 90 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bDppIn == "Y" && bCell == "Y" ) {
			IF @bDppIn = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 100 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bDppIn == "Y" && bUom == "Y" ) {
			IF @bDppIn = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 110 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bDppOut == "Y" && bCell == "Y" ) {
			IF @bDppOut = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bDppOut == "Y" && bUom == "Y" ) {
			IF @bDppOut = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bResult == "Y" && bCell == "Y" ) {
			IF @bResult = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 140 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bResult == "Y" && bUom == "Y" ) {
			IF @bResult = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 150 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bTarget == "Y" && bCell == "Y" ) {
			IF @bTarget = 1 AND @bCell = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 5 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
  --
  --		          				if( bTarget == "Y" && bUom == "Y" ) {
			IF @bTarget = 1 AND @bUom = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 10 AS CATEGORY_ORDER '+char(10)
			END
  --		          				}
    END ELSE BEGIN
	-- CATEGORY 정보 없는 경우임
               SET @v_dSql += 'SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 20 AS CATEGORY_ORDER 		 '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 30 AS CATEGORY_ORDER        '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 40 AS CATEGORY_ORDER    '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 50 AS CATEGORY_ORDER      '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 60 AS CATEGORY_ORDER      '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 70 AS CATEGORY_ORDER        '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 80 AS CATEGORY_ORDER    '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 90 AS CATEGORY_ORDER      '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 100 AS CATEGORY_ORDER     '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 110 AS CATEGORY_ORDER      '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER  '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER    '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 140 AS CATEGORY_ORDER    '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 150 AS CATEGORY_ORDER      '+char(10)
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 5 AS CATEGORY_ORDER    '+char(10)
               SET @v_dSql += 'UNION ALL                                                                                                                         '+char(10)
               SET @v_dSql += 'SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 10 AS CATEGORY_ORDER      '+char(10)
  
	END

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00602","find_FP00602",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00602_FIND_FP00602',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00602_FIND_FP00602',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
