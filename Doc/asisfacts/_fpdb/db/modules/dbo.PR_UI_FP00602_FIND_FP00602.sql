
CREATE PROCEDURE [dbo].[PR_UI_FP00602_FIND_FP00602]
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
    --END ELSE IF @tmp_column = 'PRODTYPE_ID' BEGIN
	END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
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

  SET @v_dSql += 'if object_id(''tempdb..#MAIN'') is not null	drop table #MAIN ' + char(10)
  
  SET @v_dSql += '  CREATE TABLE [dbo].[#MAIN] ( ' + char(10)
  SET @v_dSql += '	[COMPANY_ID] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[DIVISION_ID] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[SITE_ID] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[PLANT_ID] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[FACTORY_ID] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[LOCATION] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[OPERATION_ID] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[LINE_ID] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[LINE_NAME] [nvarchar](150) NOT NULL, ' + char(10)
  SET @v_dSql += '	[ELECTRODE_TYPE] [nvarchar](50) NOT NULL, ' + char(10)
  SET @v_dSql += '	[EQUIPMENT_ID] [varchar](1) NOT NULL, ' + char(10)
  SET @v_dSql += '	[ITEM_ID] [nvarchar](150) NOT NULL, ' + char(10)
  SET @v_dSql += '	[TOP_ITEM_ID] [nvarchar](150) NOT NULL, ' + char(10)
  SET @v_dSql += '	[NICK_NAME] [nvarchar](50) NOT NULL, ' + char(10)
  SET @v_dSql += '	[CELL_GROUP] [nvarchar](50) NULL, ' + char(10)
  SET @v_dSql += '	[PRODUCTION_TYPE] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[MARKET] [nvarchar](30) NOT NULL, ' + char(10)
  SET @v_dSql += '	[ITEM_TYPE] [nvarchar](150) NULL, ' + char(10)
  SET @v_dSql += '	[CATE] [varchar](9) NOT NULL, ' + char(10)
  SET @v_dSql += '	[MEASURE_NAME] [varchar](4) NOT NULL, ' + char(10)

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		--SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				
				SET @v_dSql += '	[M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY] [numeric](38, 10) NULL, '+char(10)
				SET @v_dSql += '	[M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR] [varchar](20) NULL, '+char(10)

			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1

				SET @v_dSql += '	[W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY] [numeric](38, 10) NULL, '+char(10)
				SET @v_dSql += '	[W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR] [varchar](20) NULL, '+char(10)

  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1

				SET @v_dSql += '	[D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY] [numeric](38, 10) NULL, '+char(10)
				SET @v_dSql += '	[D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR] [varchar](20) NULL, '+char(10)
				
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  SET @v_dSql += '	[CATEGORY_ID] [varchar](6) NOT NULL, ' + char(10)
  SET @v_dSql += '	[MEASURE_ID] [varchar](4) NOT NULL, ' + char(10)
  SET @v_dSql += '	[CATEGORY_ORDER] [int] NOT NULL, ' + char(10)
  SET @v_dSql += '	[DATA_TYPE] [varchar](4) NOT NULL ' + char(10)
  SET @v_dSql += '	, [PLM_EC_NO] [varchar](150) NOT NULL ' + char(10) -- PDS 2차 고도화
  SET @v_dSql += '	, [VERSION] [varchar](50) NOT NULL ' + char(10)
  SET @v_dSql += ');  ' + char(10)+char(10)

  SET @v_dSql += '      INSERT INTO #MAIN SELECT A.*'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '      		SELECT A.*'+char(10)
  SET @v_dSql += '      		FROM ('+char(10)
  SET @v_dSql += '		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '		               , A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '		               , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		               , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '		               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, J.CELL_GROUP'+char(10)
  SET @v_dSql += '		               , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SET @v_dSql += '		               , A.ITEM_TYPE'+char(10)
  SET @v_dSql += '		               , B.CATEGORY_NAME AS CATE'+char(10)
  SET @v_dSql += '		               , B.MEASURE_NAME AS MEASURE_NAME'+char(10)
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
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END -- MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END -- MONTHNAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END -- MONTHCOUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- M_VALUE
				--SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)

				SET @v_dSql += '               , SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' AND B.MEASURE_ID=''UOM'' THEN A.IN_QTY '+char(10)
				SET @v_dSql += '                                                                								WHEN B.CATEGORY_ID=''P_IN'' AND B.MEASURE_ID=''CELL'' THEN A.CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                								WHEN B.CATEGORY_ID=''P_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.OUT_QTY '+char(10)
				SET @v_dSql += '                                                                								WHEN B.CATEGORY_ID=''P_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                            		WHEN B.CATEGORY_ID=''W_IN'' AND B.MEASURE_ID=''UOM'' THEN A.WPP_IN_QTY '+char(10)
				SET @v_dSql += '                                                                            		WHEN B.CATEGORY_ID=''W_IN'' AND B.MEASURE_ID=''CELL'' THEN A.WPP_CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''W_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.WPP_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''W_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.WPP_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                            		WHEN B.CATEGORY_ID=''M_IN'' AND B.MEASURE_ID=''UOM'' THEN A.MPP_IN_QTY '+char(10)
				SET @v_dSql += '                                                                            		WHEN B.CATEGORY_ID=''M_IN'' AND B.MEASURE_ID=''CELL'' THEN A.MPP_CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''M_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.MPP_OUT_QTY'+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''M_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.MPP_CELL_OUT_QTY'+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''RESULT'' AND B.MEASURE_ID=''UOM'' THEN A.RESULT_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''RESULT'' AND B.MEASURE_ID=''CELL'' THEN A.RESULT_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''TARGET'' AND B.MEASURE_ID=''CELL'' THEN A.TARGET_CELL_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''TARGET'' AND B.MEASURE_ID=''UOM'' THEN A.TARGET_QTY'+char(10)
				SET @v_dSql += '                                                            										ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)+ '_QTY '+char(10)
				SET @v_dSql += '               , NULL AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)+ '_COLOR '+char(10)

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
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END -- WEEK
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END -- WEEKNAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END -- WEEKCOUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- WVALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END -- ISDATYVIEW

				--SET @v_dSql += '               , SUM(CASE WHEN A.PLAN_WEEK<=''' + @sub_param_0 + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' +@p_plan_date+''' THEN ( CASE 	WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY' + char(10)
				--SET @v_dSql += '               																																							WHEN B.CATEGORY_ID = ''I_CELL'' THEN A.CELL_EOH_QTY ' + char(10)
				--SET @v_dSql += '               																																							ELSE 0 END)ELSE 0 END)ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)
  			
				SET @v_dSql += '                , SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' AND B.MEASURE_ID=''UOM'' THEN A.IN_QTY '+char(10)
				SET @v_dSql += '                                                                									WHEN B.CATEGORY_ID=''P_IN'' AND B.MEASURE_ID=''CELL'' THEN A.CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                									WHEN B.CATEGORY_ID=''P_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.OUT_QTY '+char(10)
				SET @v_dSql += '                                                                									WHEN B.CATEGORY_ID=''P_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                            			WHEN B.CATEGORY_ID=''W_IN'' AND B.MEASURE_ID=''UOM'' THEN A.WPP_IN_QTY '+char(10)
				SET @v_dSql += '                                                                            		WHEN B.CATEGORY_ID=''W_IN'' AND B.MEASURE_ID=''CELL'' THEN A.WPP_CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''W_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.WPP_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''W_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.WPP_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                            		WHEN B.CATEGORY_ID=''M_IN'' AND B.MEASURE_ID=''UOM'' THEN A.MPP_IN_QTY '+char(10)
				SET @v_dSql += '                                                                            		WHEN B.CATEGORY_ID=''M_IN'' AND B.MEASURE_ID=''CELL'' THEN A.MPP_CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''M_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.MPP_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''M_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.MPP_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''RESULT'' AND B.MEASURE_ID=''UOM'' THEN A.RESULT_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''RESULT'' AND B.MEASURE_ID=''CELL'' THEN A.RESULT_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''TARGET'' AND B.MEASURE_ID=''CELL'' THEN A.TARGET_CELL_QTY '+char(10)
				SET @v_dSql += '                                                                                WHEN B.CATEGORY_ID=''TARGET'' AND B.MEASURE_ID=''UOM'' THEN A.TARGET_QTY '+char(10)
				SET @v_dSql += '                                                            											ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)+ '_QTY '+char(10)
				SET @v_dSql += '               , NULL AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)+ '_COLOR '+char(10)
			
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
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END

		  		SET @v_dSql += '              , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' AND B.MEASURE_ID=''UOM'' THEN A.IN_QTY '+char(10)
				SET @v_dSql += '                                                                                     						 WHEN B.CATEGORY_ID=''P_IN'' AND B.MEASURE_ID=''CELL'' THEN A.CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                               																	 WHEN B.CATEGORY_ID=''P_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.OUT_QTY '+char(10)
				SET @v_dSql += '                                                               																	 WHEN B.CATEGORY_ID=''P_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                           											 WHEN B.CATEGORY_ID=''W_IN'' AND B.MEASURE_ID=''UOM'' THEN A.WPP_IN_QTY '+char(10)
				SET @v_dSql += '                                                                           		WHEN B.CATEGORY_ID=''W_IN'' AND B.MEASURE_ID=''CELL'' THEN A.WPP_CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''W_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.WPP_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''W_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.WPP_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                           		WHEN B.CATEGORY_ID=''M_IN'' AND B.MEASURE_ID=''UOM'' THEN A.MPP_IN_QTY '+char(10)
				SET @v_dSql += '                                                                           		WHEN B.CATEGORY_ID=''M_IN'' AND B.MEASURE_ID=''CELL'' THEN A.MPP_CELL_IN_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''M_OUT'' AND B.MEASURE_ID=''UOM'' THEN A.MPP_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''M_OUT'' AND B.MEASURE_ID=''CELL'' THEN A.MPP_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''RESULT'' AND B.MEASURE_ID=''UOM'' THEN A.RESULT_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''RESULT'' AND B.MEASURE_ID=''CELL'' THEN A.RESULT_CELL_OUT_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''TARGET'' AND B.MEASURE_ID=''CELL'' THEN A.TARGET_CELL_QTY '+char(10)
				SET @v_dSql += '                                                                               WHEN B.CATEGORY_ID=''TARGET'' AND B.MEASURE_ID=''UOM'' THEN A.TARGET_QTY '+char(10)
				SET @v_dSql += '                                                           																			 ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)+ '_QTY '+char(10)
				SET @v_dSql += '              , NULL AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)+ '_COLOR '+char(10)
			
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_bucket,'') <> ''

  SET @v_dSql += '		        			 , B.CATEGORY_ID, B.MEASURE_ID, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '		               , ''DATA'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '		               , A.PLM_EC_NO, A.VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '		          FROM ('+char(10)
  SET @v_dSql += '				              SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '				                   		, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '					                   , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '					                   , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '					                   , A.PLAN_DATE'+char(10)
  SET @v_dSql += '					                   , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '					                   , A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '					                   , A.MARKET'+char(10)
  SET @v_dSql += '					                   , B.ITEM_TYPE'+char(10)
  SET @v_dSql += '					                   , A.PLAN_TYPE'+char(10)
  SET @v_dSql += '					                   , A.SEQ'+char(10)
  SET @v_dSql += '					                   , A.IN_QTY'+char(10)
  SET @v_dSql += '					                   , A.OUT_QTY'+char(10)
  SET @v_dSql += '					                   , A.CELL_IN_QTY'+char(10)
  SET @v_dSql += '					                   , A.CELL_OUT_QTY'+char(10)
  SET @v_dSql += '					                    , A.MPP_IN_QTY'+char(10)
  SET @v_dSql += '			                          , A.MPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '			                          , A.MPP_OUT_QTY'+char(10)
  SET @v_dSql += '			                          , A.MPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '			                          , A.WPP_IN_QTY'+char(10)
  SET @v_dSql += '			                          , A.WPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '			                          , A.WPP_OUT_QTY'+char(10)
  SET @v_dSql += '			                          , A.WPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '			                          , A.RESULT_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '			                          , A.RESULT_OUT_QTY'+char(10)
  SET @v_dSql += '					                   , A.TARGET_QTY'+char(10)
  SET @v_dSql += '					                  , A.TARGET_CELL_QTY'+char(10)
  SET @v_dSql += '					                  , A.PLM_EC_NO, A.VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '				           FROM ('+char(10)
  SET @v_dSql += '										SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '												, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '												, A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '												, '''' AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '												, A.PLAN_DATE'+char(10)
  SET @v_dSql += '												, A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME'+char(10)
  SET @v_dSql += '												, A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '												, A.MARKET'+char(10)
  SET @v_dSql += '												, ''DPP'' AS PLAN_TYPE'+char(10)
  SET @v_dSql += '												, DATE_SEQ AS SEQ'+char(10)
  SET @v_dSql += '												, A.IN_QTY'+char(10)
  SET @v_dSql += '												, A.OUT_QTY'+char(10)
  SET @v_dSql += '												, A.CELL_IN_QTY'+char(10)
  SET @v_dSql += '												, A.CELL_OUT_QTY'+char(10)
  SET @v_dSql += '												, A.MPP_IN_QTY'+char(10)
  SET @v_dSql += '												, A.MPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '												, A.MPP_OUT_QTY'+char(10)
  SET @v_dSql += '												, A.MPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '												, A.WPP_IN_QTY'+char(10)
  SET @v_dSql += '												, A.WPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '												, A.WPP_OUT_QTY'+char(10)
  SET @v_dSql += '												, A.WPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '												, A.RESULT_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '												, A.RESULT_OUT_QTY'+char(10)
  SET @v_dSql += '												, 0 TARGET_QTY'+char(10)
  SET @v_dSql += '												, 0 AS TARGET_CELL_QTY'+char(10)
  SET @v_dSql += '												, A.PLM_EC_NO, A.VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '										FROM   ' + @p_amend_table + ' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										WHERE  A.INSTANCE_ID      ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '										AND    A.FP_PLAN_ID       ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '										AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)  
  SET @v_dSql += '										AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += ' ' +@opt_5top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_6item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  --SET @v_dSql += ' ' +@opt_7prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)
   SET @v_dSql += '	                          UNION ALL'+char(10)
  SET @v_dSql += '	                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '				                              , A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '				                              , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '				                              , '''' AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '				                              , A.PLAN_DATE'+char(10)
  SET @v_dSql += '				                              , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME'+char(10)
  SET @v_dSql += '				                              , A.PRODUCTION_TYPE'+char(10)
  SET @v_dSql += '				                              , A.MARKET'+char(10)
  SET @v_dSql += '				                              , ''DPP'' AS PLAN_TYPE'+char(10)
  SET @v_dSql += '				                              , '''' AS SEQ'+char(10)
  SET @v_dSql += '				                              , 0 IN_QTY'+char(10)
  SET @v_dSql += '				                              , 0 OUT_QTY'+char(10)
  SET @v_dSql += '				                              , 0 CELL_IN_QTY'+char(10)
  SET @v_dSql += '				                              , 0 CELL_OUT_QTY'+char(10)
  SET @v_dSql += '				                              , 0 MPP_IN_QTY'+char(10)
  SET @v_dSql += '				                              , 0 MPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '				                              , 0 MPP_OUT_QTY'+char(10)
  SET @v_dSql += '				                              , 0 MPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '				                              , 0 WPP_IN_QTY'+char(10)
  SET @v_dSql += '				                              , 0 WPP_CELL_IN_QTY'+char(10)
  SET @v_dSql += '				                              , 0 WPP_OUT_QTY'+char(10)
  SET @v_dSql += '				                              , 0 WPP_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '				                              , 0 RESULT_CELL_OUT_QTY'+char(10)
  SET @v_dSql += '				                              , 0 RESULT_OUT_QTY'+char(10)
  SET @v_dSql += '				                              , ISNULL(A.SALES_QTY,0) AS TARGET_QTY'+char(10)
  SET @v_dSql += '				                              , ISNULL(A.CELL_SALES_QTY,0) AS TARGET_CELL_QTY'+char(10)
  SET @v_dSql += '				                              , A.PLM_EC_NO, A.VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '							              FROM   '+@p_amend_sales_table +' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '							              WHERE  A.INSTANCE_ID      ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '							              AND    A.FP_PLAN_ID       ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '							              AND    ISNULL(A.SALES_QTY,0) <> 0'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)  
   SET @v_dSql += '							              AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += ' ' +@opt_5top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_6item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)

  SET @v_dSql += '							      ) A'+char(10)
  SET @v_dSql += '							      INNER JOIN ('+char(10)
  SET @v_dSql += '					                          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,'+char(10)
  SET @v_dSql += '					                                 A.ITEM_ID,'+char(10)
  SET @v_dSql += '					                                 (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SET @v_dSql += '					                                 	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '					                                 	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,'+char(10)
  SET @v_dSql += '					                                 ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '					                          FROM	 SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SET @v_dSql += '					                            		 SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '					                          WHERE	 A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nickname_id)) + char(10)
  SET @v_dSql += '			                    ) B'+char(10)
  SET @v_dSql += '			                    ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '					              AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '					              AND    A.SITE_ID        = B.SITE_ID'+char(10)
  --SET @v_dSql += '					              AND    A.ITEM_ID    = B.ITEM_ID'+char(10)
  SET @v_dSql += '					              AND    A.TOP_ITEM_ID    = B.ITEM_ID'+char(10)  -- 2021-11-15 AS-IS 점검
  SET @v_dSql += '					              INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '					              ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
  SET @v_dSql += '					              AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
  SET @v_dSql += '					              AND    A.SITE_ID        = C.SITE_ID'+char(10)
  SET @v_dSql += '					              AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
  SET @v_dSql += '					              AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
  SET @v_dSql += '					              AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
  SET @v_dSql += '					              AND    A.LINE_ID        = C.LINE_ID'+char(10)
  SET @v_dSql += '					              AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '					              WHERE  1=1'+char(10)
  SET @v_dSql += ' ' +@opt_13item_name +' '+''+char(10)--AND    B.NICK_NAME LIKE '%' + #ITEM_NAME# + '%'
  SET @v_dSql += '		          ) A'+char(10)
  SET @v_dSql += '		          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		          ON 1=1'+char(10)
  SET @v_dSql += '		          AND CONVERT(VARCHAR, C.DT, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '		          AND A.PLAN_DATE = C.DT'+char(10)
  SET @v_dSql += '		          INNER JOIN ('+char(10)
  SET @v_dSql += '		          			SELECT *'+char(10)
  SET @v_dSql += '		          			FROM ('+char(10)
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
  DECLARE @bMemo Integer = 0


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
					END ELSE IF isnull(@sub_param_0,'') = 'chk_target' and isnull(@sub_param_1,'')='true' BEGIN--ELSE IF @tmp_column = 'chk_target' BEGIN
						SET @bTarget = 1
					END ELSE IF isnull(@sub_param_0,'') = 'chk_memo' and isnull(@sub_param_1,'')='true' BEGIN--ELSE IF @tmp_column = 'chk_target' BEGIN
						SET @bMemo = 1
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

			IF @bMemo = 1 BEGIN
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 700 AS CATEGORY_ORDER '+char(10)
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
               SET @v_dSql += 'UNION ALL '+char(10)
               SET @v_dSql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 700 AS CATEGORY_ORDER '+char(10)
  
	END

  SET @v_dSql += '			                ) BB'+char(10)
  SET @v_dSql += '			                WHERE CATEGORY_ID <> ''X'''+char(10)
  SET @v_dSql += '		          ) B'+char(10)
  SET @v_dSql += '		          ON 1=1'+char(10)
  --SET @v_dSql += '      				INNER JOIN FP_CELL_GROUP_V J WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      				INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)'+char(10) -- 20211115 AS-IS 비교
  SET @v_dSql += '      				ON  A.COMPANY_ID  = J.COMPANY_ID'+char(10)
  SET @v_dSql += '      				AND A.DIVISION_ID = J.DIVISION_ID'+char(10)
  SET @v_dSql += '      				AND A.SITE_ID     = J.SITE_ID'+char(10)
  SET @v_dSql += '      				AND A.TOP_ITEM_ID = J.ITEM_ID'+char(10)
  SET @v_dSql += '      				WHERE 1=1'+char(10)
  SET @v_dSql += ' ' +@opt_40cell_group +' '+''+char(10)--AND   J.CELL_GROUP LIKE '%' + #CELL_GROUP# + '%'
  SET @v_dSql += '             	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                 , A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                 , A.EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, J.CELL_GROUP'+char(10)
  SET @v_dSql += '                 , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '                 , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_ID, B.MEASURE_NAME, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                 , A.PLM_EC_NO, A.VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '		    		) A'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += 'option (maxdop 1) ;'+char(10)
  SET @v_dSql += ' '+char(10)


  SET @v_dSql += '      WITH CAPA_VALUE AS ('+char(10)
  SET @v_dSql += '      		SELECT *'+char(10)
  SET @v_dSql += '      		FROM ('+char(10)
  SET @v_dSql += '  		         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		               ,'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AS PLAN_DATE'+char(10)
  SET @v_dSql += '		               , NULL AS OFF_TIME'+char(10)
  SET @v_dSql += '		               , NULL AS SETUP_TIME'+char(10)
  SET @v_dSql += '		               , NULL AS UTILIZATION'+char(10)
  SET @v_dSql += '		          FROM   ' + @p_amend_table + ' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		          INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		          ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '		          AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '		          AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '		          AND    A.ITEM_ID        = B.ITEM_ID'+char(10)
  SET @v_dSql += '		          WHERE  INSTANCE_ID      ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '		          AND    FP_PLAN_ID       ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '		          AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)

  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)  
 
  SET @v_dSql += ' ' +@opt_5top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_6item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_13item_name +' '+''+char(10)--AND    B.NICK_NAME LIKE '%' + #ITEM_NAME# + '%'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)

  SET @v_dSql += '		          AND	A.OUT_QTY > 0'+char(10)
  SET @v_dSql += '		          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		          UNION ALL'+char(10)
  SET @v_dSql += '		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		               , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '		               , SUM(A.OFF_TIME) AS OFF_TIME'+char(10)
  SET @v_dSql += '		               , SUM(A.SETUP_TIME) AS SETUP_TIME'+char(10)
  SET @v_dSql += '		               , AVG(A.UTILIZATION) AS UTILIZATION'+char(10)
  SET @v_dSql += '		          FROM   '+ @p_AMEND_UTIL_TABLE + ' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		          WHERE  A.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '		          AND    A.FP_PLAN_ID  ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '		          AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)  
  
  SET @v_dSql += '		          AND    EXISTS ('+char(10)
  SET @v_dSql += '		              SELECT 1'+char(10)
  SET @v_dSql += '		              FROM   ' + @p_amend_table + ' AAA WITH(NOLOCK), SCM_ITEM_M BBB WITH(NOLOCK)'+char(10)
  SET @v_dSql += '		              WHERE  AAA.COMPANY_ID   = BBB.COMPANY_ID'+char(10)
  SET @v_dSql += '		              AND    AAA.DIVISION_ID  = BBB.DIVISION_ID'+char(10)
  SET @v_dSql += '		              AND    AAA.SITE_ID      = BBB.SITE_ID'+char(10)
  SET @v_dSql += '		              AND    AAA.ITEM_ID      = BBB.ITEM_ID'+char(10)
  SET @v_dSql += '		              AND    A.COMPANY_ID     = AAA.COMPANY_ID'+char(10)
  SET @v_dSql += '		              AND    A.DIVISION_ID    = AAA.DIVISION_ID'+char(10)
  SET @v_dSql += '		              AND    A.SITE_ID        = AAA.SITE_ID'+char(10)
  SET @v_dSql += '		              AND    A.PLANT_ID       = AAA.PLANT_ID'+char(10)
  SET @v_dSql += '		              AND    A.FACTORY_ID     = AAA.FACTORY_ID'+char(10)
  SET @v_dSql += '		              AND    A.LOCATION       = AAA.LOCATION'+char(10)
  SET @v_dSql += '		              AND    A.OPERATION_ID   = AAA.OPERATION_ID'+char(10)
  SET @v_dSql += '		              AND    A.LINE_ID        = AAA.LINE_ID'+char(10)
  SET @v_dSql += '		              AND    A.ELECTRODE_TYPE = AAA.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		              AND    CONVERT(VARCHAR, AAA.PLAN_DATE, 112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '		              AND    AAA.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '		              AND    AAA.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
   
   SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  
  SET @v_dSql += ' ' +@opt_51top_item_id +' '+''+char(10)--AND    AAA.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_52item_id +' '+''+char(10)--AND    AAA.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_53item_name +' '+''+char(10)--AND    BBB.NICK_NAME LIKE '%' + #ITEM_NAME# + '%'
  --SET @v_dSql += ' ' +@opt_54prod_type +' '+''+char(10)--AND    AAA.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)

  SET @v_dSql += '		          )'+char(10)
  SET @v_dSql += '		          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '		                 , CONVERT(VARCHAR, A.PLAN_DATE, 112)'+char(10)
  SET @v_dSql += '		      	) A'+char(10)

  IF @bSubTotal = 0 BEGIN
     SET @v_dSql += 'WHERE 1=0 '+char(10)
  END
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --          	var sql = ""
  --          	if( bSubTotal != "Y" ) {
  --          		sql = "WHERE 1=0 "
  --          	}
  --          }

  --'
  SET @v_dSql += '      )'+char(10)
  --SET @v_dSql += '       , T_MEMO AS ('+char(10)
  --SET @v_dSql += '      			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  --SET @v_dSql += '		               , A.OPERATION_ID'+char(10)
  --SET @v_dSql += '		               , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  --SET @v_dSql += '		               , A.EQUIPMENT_ID'+char(10)
  --SET @v_dSql += '		               , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  --SET @v_dSql += '		               , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --  IF isnull(@p_bucket,'') <> '' BEGIN
		--SET @mst_loop_cnt = 0
		--SET @v_delimiter            = '!'  -- 데이터 구분자
		--SET @sub_v_delimiter = '#'
		--SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		--IF @max_loop_cnt > 0 BEGIN
		--	-- bucket
		--	SET @mst_loop_cnt = 0	
		--	SET @max_loop_cnt = 0
		--	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		--	WHILE @mst_loop_cnt < @max_loop_cnt
		--	BEGIN
		--		--SET @v_dSql += '               , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)
		--		SET @mst_loop_cnt =  @mst_loop_cnt +1
		--		SET @tmp_column = ''
		--		SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
		--		SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
		--		IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
		--		IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END
		--		IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END
		--		IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- D0
		--		SET @v_dSql += '               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0 + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_MO ' + char(10)
		--	END -- end of @mst_loop_cnt < @max_loop_cnt
		--END --end of @max_loop_cnt
  --  END -- end of isnull(@p_bucket,'') <> '
  --SET @v_dSql += '
  --{
  --	        				var sql="";
  --	        				var list = $data.bucket;
  --	        				for(var i = 0; i < list.size(); i++) {
  --			                    SET @v_dSql += '              , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' AND A.MEMO IS NOT NULL THEN ''''Y'''' ELSE NULL END) AS D" + i + "_MO '+char(10)
  --                    		}
  --		        	   }

  --'
  --SET @v_dSql += '	          FROM FP_AMEND_MEMO_M A WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '	          WHERE 1=1'+char(10)
  --SET @v_dSql += '	          AND    A.INSTANCE_ID  ='+char(10)
  --SET @v_dSql += '' + @v_instance_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --   SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)  
  --  SET @v_dSql += ' ' +@opt_5top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%'
  --SET @v_dSql += ' ' +@opt_6item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  ----SET @v_dSql += ' ' +@opt_7prod_type +' '+''+char(10)--AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%'
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prodtype_id)) + char(10)
  --  SET @v_dSql += '	          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  --SET @v_dSql += '          				 , A.OPERATION_ID'+char(10)
  --SET @v_dSql += '          			   , A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  --SET @v_dSql += '          			   , A.EQUIPMENT_ID'+char(10)
  --SET @v_dSql += '          			   , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  --SET @v_dSql += '          			   , A.PRODUCTION_TYPE, A.MARKET'+char(10)
  --SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT A.*'+char(10)
  SET @v_dSql += '           , NULL AS LV1'+char(10)
  SET @v_dSql += '           , B.APPLIED_MODEL'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --  IF isnull(@p_bucket,'') <> '' BEGIN
		--SET @mst_loop_cnt = 0
		--SET @v_delimiter            = '!'  -- 데이터 구분자
		--SET @sub_v_delimiter = '#'
		--SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		--IF @max_loop_cnt > 0 BEGIN

		--	-- bucket
		--	SET @mst_loop_cnt = 0	
		--	SET @max_loop_cnt = 0
		--	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
		--	WHILE @mst_loop_cnt < @max_loop_cnt
		--	BEGIN
		--		SET @v_dSql += '  , C.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_MO' + char(10)
		--		SET @mst_loop_cnt =  @mst_loop_cnt + 1
		--	END -- end of @mst_loop_cnt < @max_loop_cnt
		--END --end of @max_loop_cnt
  --  END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --      				var sql="";
  --      				var list = $data.bucket;
  --      				for(var i = 0; i < list.size(); i++) {
  --                SET @v_dSql += ' , C.D" + i + "_MO '+char(10)
  --          		}
  --    	      }

  --'
  SET @v_dSql += '           , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'''+char(10)
  SET @v_dSql += '           		  WHEN ''RELEASE'' ='+char(10)
  SET @v_dSql += '' + @v_plan_type+''+char(10)
  SET @v_dSql += ' THEN ''Y'''+char(10)
  SET @v_dSql += '                  WHEN D.PRODUCTION_TYPE IS NULL /*OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'')*/ THEN ''N'''+char(10)
  SET @v_dSql += '                  WHEN I.DIVISION_ID IS NOT NULL THEN ''Y'''+char(10)
  SET @v_dSql += '                  ELSE ''Y'' END AS EDIT_YN'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '          SELECT * FROM #MAIN'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  SET @v_dSql += '                ,A.MEASURE_NAME'+char(10)
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
				SET @v_dSql += '               , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
				
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --          				var sql="";
  --          				var list = $data.bucket;
  --          				var weekInfo  = $data.WEEK_INFO;
  --          				var monthInfo = $data.MONTH_INFO;
  --
  --          				if(list.size() > 0) {
  --          				  for(var i = 0; i < monthInfo.size(); i++) {
  --          				    SET @v_dSql += '               ,SUM(M" + i + "_QTY) AS M" + i + "_QTY, NULL AS M" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          				  for(var i = 0; i < weekInfo.size(); i++) {
  --          				    SET @v_dSql += '               ,SUM(W" + i + "_QTY) AS W" + i + "_QTY, NULL AS W" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          					for(var i = 0; i < list.size(); i++) {
  --                      SET @v_dSql += '               ,SUM(D" + i + "_QTY) AS D" + i + "_QTY, NULL AS D" + i + "_COLOR '+char(10)
  --          					}
  --          				}
  --          			}

  --'
  SET @v_dSql += '          			,A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , NULL AS PLM_EC_NO, NULL AS VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '          FROM   #MAIN A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF @bSubTotal = 0 BEGIN
    SET @v_dSql += 'WHERE 1=0 '+char(10)
  END
  
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                  ,A.CATE, A.MEASURE_NAME, A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER'+char(10)
  --SET @v_dSql += '          -- Off Calendar, Setup'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE'+char(10)
  SET @v_dSql += '                ,B.CATEGORY_NAME AS CATE'+char(10)
  SET @v_dSql += '                ,NULL AS MEASURE_NAME'+char(10)
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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END -- MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END -- MONTHNAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END -- MONTHCOUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- M_VALUE

				--SET @v_dSql += '               , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
            	SET @v_dSql += '                   ,SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY '+char(10)
                SET @v_dSql += '                   ,NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR '+char(10)
				
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
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END -- WEEK
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END -- WEEKNAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END -- WEEKCOUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- WVALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END -- ISDATYVIEW

				SET @v_dSql += '                   ,SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY '+char(10)
            	SET @v_dSql += '                   ,NULL AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR '+char(10)				
								
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
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
				
				SET @v_dSql += '                   ,SUM(CASE WHEN C.YYYYMMDD='''+ @sub_param_0 +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY '+char(10)
            	SET @v_dSql += '                   ,NULL AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR '+char(10)
			
			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  --SET @v_dSql += '
  --{
  --          				var sql="";
  --          				var list = $data.bucket;
  --          				var weekInfo  = $data.WEEK_INFO;
  --          				var monthInfo = $data.MONTH_INFO;
  --
  --          				if(list.size() > 0) {
  --          				  for(var i = 0; i < monthInfo.size(); i++) {
  --          				    SET @v_dSql += '                   ,SUM(CASE WHEN C.YYYYMM=''''" + monthInfo[i].month + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''OFF'''' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M" + i + "_QTY '+char(10)
  --                      SET @v_dSql += '                   ,NULL AS M" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          				  for(var i = 0; i < weekInfo.size(); i++) {
  --          				    SET @v_dSql += '                   ,SUM(CASE WHEN C.ISO_YYYYWW=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''OFF'''' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W" + i + "_QTY '+char(10)
  --          				    SET @v_dSql += '                   ,NULL AS W" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          					for(var i = 0; i < list.size(); i++) {
  --          					  SET @v_dSql += '                   ,SUM(CASE WHEN C.YYYYMMDD=''''" + list[i].VALUE + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''OFF'''' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS D" + i + "_QTY '+char(10)
  --          					  SET @v_dSql += '                   ,NULL AS D" + i + "_COLOR '+char(10)
  --          					}
  --          				}
  --          			}

  --'
  SET @v_dSql += '          			,B.CATEGORY_ID, NULL AS MEASURE_ID, B.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , NULL AS PLM_EC_NO, NULL AS VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '          FROM   CAPA_VALUE A'+char(10)
  SET @v_dSql += '          INNER JOIN ('+char(10)
  SET @v_dSql += '              SELECT ''OFF'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '              UNION ALL'+char(10)
  SET @v_dSql += '              SELECT ''SETUP'' AS CATEGORY_ID, ''M/C(min)'' AS CATEGORY_NAME, 500 AS CATEGORY_ORDER'+char(10)
  --SET @v_dSql += '              UNION ALL'+char(10)
  --SET @v_dSql += '              SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, 700 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '          ) B'+char(10)
  SET @v_dSql += '          ON 1=1'+char(10)
  SET @v_dSql += '          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON  A.PLAN_DATE = C.YYYYMMDD'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    IF @bSubTotal = 0 BEGIN
    SET @v_dSql += 'WHERE 1=0 '+char(10)
  END
  --SET @v_dSql += '
  --{
  --          	var sql = ""
  --          	if( bSubTotal != "Y" ) {
  --          		sql = "WHERE 1=0 "
  --          	}
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '                  ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER'+char(10)
  --SET @v_dSql += '          -- Capa'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'+char(10)
  SET @v_dSql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE'+char(10)
  SET @v_dSql += '               ,''Load(%)'' AS CATE'+char(10)
  SET @v_dSql += '               ,NULL AS MEASURE_NAME'+char(10)
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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_MONTH_INFO,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END -- MONTH
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END -- MONTHNAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END -- MONTHCOUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- M_VALUE

				--SET @v_dSql += '               , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
            	--SET @v_dSql += '                   ,SUM(CASE WHEN C.YYYYMM=''''' + @sub_param_0 + ''''' THEN (CASE WHEN B.CATEGORY_ID=''''OFF'''' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY '+char(10)
             --   SET @v_dSql += '                   ,NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR '+char(10)
				
			    SET @v_dSql += '                   ,CEILING(AVG(CASE WHEN C.YYYYMM='''+@sub_param_0+''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY '+char(10)
			    SET @v_dSql += '                   ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMM='''+@sub_param_0+''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END  AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR '+char(10)
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
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END -- WEEK
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END -- WEEKNAME
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END -- WEEKCOUNT
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END -- WVALUE
				IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END -- ISDATYVIEW

				--SET @v_dSql += '                   ,SUM(CASE WHEN C.ISO_YYYYWW=''' + @sub_param_0 +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_QTY '+char(10)
    --        	SET @v_dSql += '                   ,NULL AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '+char(10)				
								
			    SET @v_dSql += '                   ,CEILING(AVG(CASE WHEN C.ISO_YYYYWW='''+@sub_param_0+''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY '+char(10)
			    SET @v_dSql += '                   ,CASE WHEN (CEILING(AVG(CASE WHEN C.ISO_YYYYWW='''+@sub_param_0+''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR '+char(10)
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
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
				
				SET @v_dSql += '                   ,CEILING(AVG(CASE WHEN C.YYYYMMDD='''+ @sub_param_0 +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_QTY '+char(10)
            	SET @v_dSql += '                   ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMMDD='''+ @sub_param_0 +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_COLOR '+char(10)
			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  --SET @v_dSql += '
  --{
  --          				var sql="";
  --          				var list = $data.bucket;
  --          				var weekInfo  = $data.WEEK_INFO;
  --          				var monthInfo = $data.MONTH_INFO;
  --
  --          				if(list.size() > 0) {
  --          				  for(var i = 0; i < monthInfo.size(); i++) {
  --          				    SET @v_dSql += '                   ,CEILING(AVG(CASE WHEN C.YYYYMM=''''" + monthInfo[i].month + "'''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M" + i + "_QTY '+char(10)
  --          				    SET @v_dSql += '                   ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMM=''''" + monthInfo[i].month + "'''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''''red'''' ELSE NULL END  AS M" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          				  for(var i = 0; i < weekInfo.size(); i++) {
  --          				    SET @v_dSql += '                   ,CEILING(AVG(CASE WHEN C.ISO_YYYYWW=''''" + weekInfo[i].week + "'''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W" + i + "_QTY '+char(10)
  --          				    SET @v_dSql += '                   ,CASE WHEN (CEILING(AVG(CASE WHEN C.ISO_YYYYWW=''''" + weekInfo[i].week + "'''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''''red'''' ELSE NULL END AS W" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          					for(var i = 0; i < list.size(); i++) {
  --          					  SET @v_dSql += '                   ,CEILING(AVG(CASE WHEN C.YYYYMMDD=''''" + list[i].VALUE + "'''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D" + i + "_QTY '+char(10)
  --          					  SET @v_dSql += '                   ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMMDD=''''" + list[i].VALUE + "'''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''''red'''' ELSE NULL END AS D" + i + "_COLOR '+char(10)
  --          					}
  --          				}
  --          			}

  --'
  SET @v_dSql += '          			,''CAPA'' AS CATEGORY_ID, NULL AS MEASURE_ID, 600 AS CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , NULL AS PLM_EC_NO, NULL AS VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '          FROM   CAPA_VALUE A'+char(10)
  SET @v_dSql += '          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON  A.PLAN_DATE = C.YYYYMMDD'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    IF @bSubTotal = 0 BEGIN
    SET @v_dSql += 'WHERE 1=0 '+char(10)
  END ELSE IF @bCapa = 0 BEGIN
    SET @v_dSql += 'WHERE 1=0 '+char(10)
  END

  --SET @v_dSql += '
  --{
  --          	var sql = ""
  --          	if( bSubTotal != "Y" ) {
  --          		sql = "WHERE 1=0 "
  --          	} else {
  --          		if( bCapa != "Y" ) {
  --          			sql = "WHERE 1=0 "
  --          		}
  --          	}
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  --SET @v_dSql += '          -- Total'+char(10)
  SET @v_dSql += '          UNION ALL'+char(10)
  SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID'+char(10)
  SET @v_dSql += '                ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
  SET @v_dSql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS CELL_GROUP'+char(10)
  SET @v_dSql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE'+char(10)
  SET @v_dSql += '                ,A.CATE'+char(10)
  SET @v_dSql += '                ,A.MEASURE_NAME'+char(10)
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
				SET @v_dSql += '               , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END-- end of @mst_loop_cnt < @max_loop_cnt

			-- weekinfo
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  			END -- end of @mst_loop_cnt < @max_loop_cnt

			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '               , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_QTY) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_QTY, NULL AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_COLOR '  +char(10)
				
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  --SET @v_dSql += '
  --{
  --          				var sql="";
  --          				var list = $data.bucket;
  --          				var weekInfo  = $data.WEEK_INFO;
  --          				var monthInfo = $data.MONTH_INFO;
  --
  --          				if(list.size() > 0) {
  --          				  for(var i = 0; i < monthInfo.size(); i++) {
  --          				    SET @v_dSql += '                   ,SUM(M" + i + "_QTY) AS M" + i + "_QTY, NULL AS M" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          				  for(var i = 0; i < weekInfo.size(); i++) {
  --          				    SET @v_dSql += '                   ,SUM(W" + i + "_QTY) AS W" + i + "_QTY, NULL AS W" + i + "_COLOR '+char(10)
  --          				  }
  --
  --          					for(var i = 0; i < list.size(); i++) {
  --          					  SET @v_dSql += '                   ,SUM(D" + i + "_QTY) AS D" + i + "_QTY, NULL AS D" + i + "_COLOR '+char(10)
  --          					}
  --          				}
  --          			}

  --'
  SET @v_dSql += '          			,A.CATEGORY_ID, A.MEASURE_NAME, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '                ,''TOTAL_2'' AS DATA_TYPE'+char(10)
  SET @v_dSql += '                , NULL AS PLM_EC_NO, NULL AS VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '          FROM   #MAIN A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      IF @bTotal = 0 BEGIN
    SET @v_dSql += 'WHERE 1=0 '+char(10)
  END
  --SET @v_dSql += '
  --{
  --          	var sql = ""
  --          	if( bTotal != "Y" ) {
  --          		sql = "WHERE 1=0 "
  --          	}
  --          }

  --'
  SET @v_dSql += '          GROUP BY A.OPERATION_ID, A.CATE, A.CATEGORY_ID, A.MEASURE_NAME, A.MEASURE_ID, A.CATEGORY_ORDER'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND A.ITEM_ID     = B.ITEM_ID'+char(10)
  --SET @v_dSql += '      LEFT OUTER JOIN T_MEMO C WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '        ON  A.COMPANY_ID      = C.COMPANY_ID'+char(10)
  --SET @v_dSql += '        AND A.DIVISION_ID     = C.DIVISION_ID'+char(10)
  --SET @v_dSql += '        AND A.SITE_ID         = C.SITE_ID'+char(10)
  --SET @v_dSql += '        AND A.PLANT_ID        = C.PLANT_ID'+char(10)
  --SET @v_dSql += '        AND A.FACTORY_ID      = C.FACTORY_ID'+char(10)
  --SET @v_dSql += '        AND A.OPERATION_ID    = C.OPERATION_ID'+char(10)
  --SET @v_dSql += '        AND A.LINE_ID         = C.LINE_ID'+char(10)
  --SET @v_dSql += '        AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE'+char(10)
  --SET @v_dSql += '        AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE'+char(10)
  --SET @v_dSql += '        AND A.MARKET          = C.MARKET'+char(10)
  --SET @v_dSql += '        AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID'+char(10)
  --SET @v_dSql += '        AND A.ITEM_ID         = C.ITEM_ID'+char(10)
  SET @v_dSql += '	  LEFT OUTER JOIN'+char(10)
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
  --					   SET @v_dSql += 'UNION ALL '+char(10)
  --					   SET @v_dSql += 'SELECT DISTINCT A.DIVISION_ID, ''''M/C'''' AS PRODUCTION_TYPE '+char(10)
  --					   SET @v_dSql += 'FROM   SCM_FACTORY_M A(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK) '+char(10)
  --					   SET @v_dSql += 'ON     A.FACTORY_ID=B.FACTORY_ID '+char(10)
  --					   SET @v_dSql += 'AND	  B.ACTIVE_FLAG = ''''Y'''' '+char(10)
  --					   SET @v_dSql += 'WHERE 1=1 '+char(10)
  --					   SET @v_dSql += 'AND	  A.ACTIVE_FLAG = ''''Y'''' '+char(10)
  --					   SET @v_dSql += 'AND    B.INSTANCE_ID = ''''KR_CELL'''' '+char(10)
  --				}
  --
  --				sql;
  --			}

  --'
  SET @v_dSql += '      	) D'+char(10)
  SET @v_dSql += '      	ON A.DIVISION_ID = D.DIVISION_ID'+char(10)
  SET @v_dSql += '      	AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE'+char(10)
  --SET @v_dSql += '      	AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE'+char(10)
  --SET @v_dSql += '      	AND (CASE WHEN A.SITE_ID NOT IN (''A002'',''A004'') AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE'+char(10) -- 남경, 폴란드에 대해서 E,D-TEST 허용 -- 사이트 제약조건 제거(23/5/23)
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
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '				) R'+char(10)
  SET @v_dSql += '				ON		1=1'+char(10)
  SET @v_dSql += '				AND		A.COMPANY_ID		= R.COMPANY_ID'+char(10)
  SET @v_dSql += '				AND		A.DIVISION_ID		= R.DIVISION_ID'+char(10)
  SET @v_dSql += '				AND		A.SITE_ID			= R.SITE_ID'+char(10)
  SET @v_dSql += '				AND		A.PLANT_ID			= R.PLANT_ID'+char(10)
  SET @v_dSql += '				AND		A.FACTORY_ID		= R.FACTORY_ID'+char(10)
  SET @v_dSql += '				AND		A.OPERATION_ID		= R.OPERATION_ID'+char(10)
  SET @v_dSql += '				AND		A.LINE_ID			= R.LINE_ID'+char(10)
  SET @v_dSql += '      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '             , A.LINE_ID, A.LOCATION'+char(10)
  SET @v_dSql += '             , (CASE WHEN A.TOP_ITEM_ID IS NOT NULL THEN A.TOP_ITEM_ID ELSE ''ZZZZZ'' END)'+char(10)
  SET @v_dSql += '             , A.OPERATION_ID DESC'+char(10)
  SET @v_dSql += '             , A.EQUIPMENT_ID, A.ITEM_ID, A.PLM_EC_NO, A.VERSION '+char(10) -- version 컬럼 추가... 20230906
  SET @v_dSql += '             , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '             , A.CATEGORY_ORDER'+char(10)+char(10)

  SET @v_dSql += 'if object_id(''tempdb..#MAIN'') is not null	drop table #MAIN ' + char(10)

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
