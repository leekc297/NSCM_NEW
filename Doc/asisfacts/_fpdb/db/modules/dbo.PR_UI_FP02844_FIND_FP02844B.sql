CREATE PROCEDURE [dbo].[PR_UI_FP02844_FIND_FP02844B]
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
/** 프로그램 ID   : PR_UI_FP02844_FIND_FP02844                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP02844_FIND_FP02844                                                                          **/
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
  EXEC PR_UI_FP02844_FIND_FP02844
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP02844_FIND_FP02844B'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_plan_DATE nvarchar(max) = ''
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
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_DATE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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

 -- FP02844 find_FP02844  
  SET @v_dSql = ''
 
    DECLARE @sub_mst_loop_cnt integer = 0
  DECLARE @sub_max_loop_cnt integer = 0
  DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
  DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_4 NVARCHAR(MAX) = '' 
  
  
  SET @v_dSql += '	WITH WH_CAPA AS'+ char(10)
  SET @v_dSql += '			('+ char(10)
  SET @v_dSql += '				SELECT 	  FA.DIVISION_ID'+ char(10)
  SET @v_dSql += '					, FA.SITE_ID'+ char(10)
  SET @v_dSql += '					, FA.PLANT_ID'+ char(10)
  SET @v_dSql += '					, MAX(PW.FACTORY_ID) AS FACTORY_ID'+ char(10)
  SET @v_dSql += '					, MAX(PWR.MTRL_CLSS_CODE) AS ROLL_TYPE'+ char(10)
  SET @v_dSql += '					, MAX(PWR.ELECTRODE_TYPE) AS ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '					,  PW.WH_ID'+ char(10)
  SET @v_dSql += '					, MAX(PW.WH_NAME) AS WH_NAME'+ char(10)
  SET @v_dSql += '					, MAX(RW.ATTR_TYPE) AS ATTR_TYPE'+ char(10)
  SET @v_dSql += '					, COUNT(*) AS WH_CAPA'+ char(10)
  SET @v_dSql += '					, SUM(RW.WH_TEMP_CAPA) AS WH_TEMP_CAPA'+ char(10)
  SET @v_dSql += '				FROM 	SCM_MMD_PRDT_WH_RACK_M AS PWR'+ char(10)
  SET @v_dSql += '					JOIN SCM_MMD_MCS_RACK_M AS MR'+ char(10)
  SET @v_dSql += '						ON	1=1'+ char(10)
  SET @v_dSql += '						AND 	PWR.RACK_ID = MR.RACK_ID'+ char(10)
  SET @v_dSql += '					JOIN SCM_MMD_PRDT_WH_M AS PW'+ char(10)
  SET @v_dSql += '						ON 	1=1'+ char(10)
  SET @v_dSql += '						AND 	PWR.WH_ID = PW.WH_ID'+ char(10)
  SET @v_dSql += '					LEFT OUTER JOIN SCM_ROLL_WAREHOUSE_M RW'+ char(10)
  SET @v_dSql += '						ON 	1=1'+ char(10)
  SET @v_dSql += '						AND 	PW.WH_ID = RW.WH_ID'+ char(10)
  SET @v_dSql += '					JOIN SCM_FACTORY_M FA'+ char(10)
  SET @v_dSql += '						ON 	1=1'+ char(10)
  SET @v_dSql += '						AND 	PW.FACTORY_ID = FA.FACTORY_ID'+ char(10)
  SET @v_dSql += '				WHERE 	1=1'+ char(10)
  SET @v_dSql += '				AND 	PWR.USE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '				AND 	MR.USE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '				AND  	PW.USE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '				AND 	PW.FACTORY_ID IN (SELECT FACTORY_ID FROM SCM_FACTORY_M WHERE SITE_ID = ''A004'' AND SHOP_GROUP_ID = ''E'')'+ char(10)
  SET @v_dSql += '				GROUP BY FA.DIVISION_ID, FA.SITE_ID, FA.PLANT_ID, PW.WH_ID'+ char(10)
  SET @v_dSql += '			)'+ char(10)
  SET @v_dSql += '			, WH_CAPA_GROUP AS'+ char(10)
  SET @v_dSql += '			('+ char(10)
  SET @v_dSql += '				SELECT 	DISTINCT  SEGMENT1 AS INSTANCE_ID'+ char(10)
  SET @v_dSql += '						, FII.COMPANY_ID'+ char(10)
  SET @v_dSql += '						, FII.DIVISION_ID'+ char(10)
  SET @v_dSql += '						, FII.SITE_ID'+ char(10)
  SET @v_dSql += '						, FII.PLANT_ID'+ char(10)
  SET @v_dSql += '						, SEGMENT2 AS FACTORY_ID'+ char(10)
  SET @v_dSql += '						, SEGMENT3 AS ROLL_TYPE'+ char(10)
  SET @v_dSql += '						, SEGMENT4 AS ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '						, SEGMENT5 AS ATTR_TYPE'+ char(10)
  SET @v_dSql += '						, ATTRIBUTE2 AS ATTR_TYPE_NAME'+ char(10)
  SET @v_dSql += '						, ATTRIBUTE1 AS TEMP_CAPA'+ char(10)
  SET @v_dSql += '						, ATTRIBUTE3 AS WH_GROUP_NAME'+ char(10)
  SET @v_dSql += '				FROM 	SCM_SYS_LOOKUP_VALUE	LV'+ char(10)
  SET @v_dSql += '						INNER JOIN FP_INSTANCE_INFO_V FII'+ char(10)
  SET @v_dSql += '						ON 	1=1'+ char(10)
  SET @v_dSql += '						AND	LV.SEGMENT1 = FII.INSTANCE_ID'+ char(10)
  SET @v_dSql += '				WHERE 	1=1'+ char(10)
  SET @v_dSql += '				AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT'''+ char(10)
  SET @v_dSql += '			)'+ char(10)
  --SELECT '====' AS sql
  --return;
  SET @v_dSql += '			, WH_CAPA_TOTAL AS ('+ char(10)
  SET @v_dSql += '						SELECT 	  WCG.WH_GROUP_NAME'+ char(10)
  SET @v_dSql += '								, WCG.COMPANY_ID'+ char(10)
  SET @v_dSql += '								, WCG.DIVISION_ID'+ char(10)
  SET @v_dSql += '								, WCG.SITE_ID'+ char(10)
  SET @v_dSql += '								, WCG.PLANT_ID'+ char(10)
  SET @v_dSql += '								, WCG.FACTORY_ID'+ char(10)
  SET @v_dSql += '								, WCG.ROLL_TYPE'+ char(10)
  SET @v_dSql += '								, (CASE WHEN WCG.ELECTRODE_TYPE = ''A'' OR WCG.ELECTRODE_TYPE = ''ANODE''  THEN ''ANODE'' ELSE ''CATHODE'' END) AS ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '								, WCG.ATTR_TYPE'+ char(10)
  SET @v_dSql += '								, WCG.ATTR_TYPE_NAME'+ char(10)
  SET @v_dSql += '								, SUM(ISNULL(WC.WH_CAPA,0)) AS WH_CAPA'+ char(10)
  SET @v_dSql += '								, ISNULL(WCG.TEMP_CAPA,0) AS TEMP_CAPA'+ char(10)
  SET @v_dSql += '								, SUM(ISNULL(WC.WH_CAPA,0)) + WCG.TEMP_CAPA AS TOTAL_WH_CAPA'+ char(10)
  SET @v_dSql += '  							,CASE WHEN WCG.ATTR_TYPE = ''-'' THEN 1'+ char(10)
  SET @v_dSql += '							   WHEN WCG.ATTR_TYPE = ''A'' THEN 2'+ char(10)
  SET @v_dSql += '							   WHEN WCG.ATTR_TYPE = ''B'' THEN 3'+ char(10)
  SET @v_dSql += '							   ELSE 4 END   AS CATEGORY_ORDER'+ char(10)
  SET @v_dSql += '						FROM 	WH_CAPA_GROUP WCG'+ char(10)
  SET @v_dSql += '							LEFT  OUTER HASH JOIN 	WH_CAPA WC'+ char(10)
  SET @v_dSql += '							ON 	1=1'+ char(10)
  SET @v_dSql += '							AND 	WCG.FACTORY_ID = WC.FACTORY_ID'+ char(10)
  SET @v_dSql += '							AND 	WCG.ROLL_TYPE = WC.ROLL_TYPE'+ char(10)
  SET @v_dSql += '							AND 	WCG.ELECTRODE_TYPE = WC.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '							AND 	WCG.ATTR_TYPE = WC.ATTR_TYPE'+ char(10)
  SET @v_dSql += '						WHERE 	1=1'+ char(10)
  SET @v_dSql += '						GROUP BY WCG.WH_GROUP_NAME'+ char(10)
  SET @v_dSql += '	 						, WCG.COMPANY_ID'+ char(10)
  SET @v_dSql += '							, WCG.DIVISION_ID'+ char(10)
  SET @v_dSql += '							, WCG.SITE_ID'+ char(10)
  SET @v_dSql += '							, WCG.PLANT_ID'+ char(10)
  SET @v_dSql += '							, WCG.FACTORY_ID'+ char(10)
  SET @v_dSql += '							, WCG.ROLL_TYPE'+ char(10)
  SET @v_dSql += '							, WCG.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '							, WCG.ATTR_TYPE'+ char(10)
  SET @v_dSql += '							, WCG.ATTR_TYPE_NAME'+ char(10)
  SET @v_dSql += '							, WCG.TEMP_CAPA'+ char(10)
  SET @v_dSql += '			)'+ char(10)
  SET @v_dSql += '	, STOCK AS'+ char(10)
  SET @v_dSql += '				('+ char(10)
  SET @v_dSql += '				SELECT 	DISTINCT ST.ITEM_ID, IT.NICK_NAME, ISNULL(MP.ELEC_FACTORY_ID, ST.FACTORY_ID)  AS FACTORY_ID'+ char(10)
  SET @v_dSql += '							, SUM(ST.FP_APPLY_WIPQTY) AS TOTAL_QTY'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''A%'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS ASSY_PC'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E2000'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_RP_JR'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID <= ''E4000'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_ST_JR'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID > ''E4000''  THEN ST.FP_APPLY_WIPQTY'+ char(10)
  SET @v_dSql += '											 WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E4000'' AND OPERATION_ID > ''E4000'' THEN ST.FP_APPLY_WIPQTY'+ char(10)
  SET @v_dSql += '											 ELSE 0 END) AS POST_ST_PC'+ char(10)
  SET @v_dSql += '							, SUM(ST.LOT_COUNT) AS TOTAL_LOT_COUNT'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''A%'' THEN ST.LOT_COUNT  ELSE 0 END) AS ASSY_PC_R'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E2000'' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_R'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID <= ''E4000'' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_R'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID > ''E4000''  THEN ST.LOT_COUNT'+ char(10)
  SET @v_dSql += '											 WHEN ST.FACTORY_ID LIKE ''E%'' AND FP_APPLY_OPERATION_ID = ''E4000'' AND OPERATION_ID > ''E4000'' THEN ST.LOT_COUNT'+ char(10)
  SET @v_dSql += '											 ELSE 0 END) AS POST_ST_PC_R'+ char(10)
  SET @v_dSql += '				FROM 	SCM_STOCK_H_V ST'+ char(10)
  SET @v_dSql += '							JOIN SCM_ITEM_M IT'+ char(10)
  SET @v_dSql += '							ON 	1=1'+ char(10)
  SET @v_dSql += '							AND 		ST.COMPANY_ID = IT.COMPANY_ID'+ char(10)
  SET @v_dSql += '							AND 		ST.DIVISION_ID = IT.DIVISION_ID'+ char(10)
  SET @v_dSql += '							AND 		ST.SITE_ID = IT.SITE_ID'+ char(10)
  SET @v_dSql += '							AND 		ST.ITEM_ID = IT.ITEM_ID'+ char(10)
  SET @v_dSql += '							LEFT OUTER JOIN (SELECT 	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS ELEC_FACTORY_ID, SEGMENT4 AS ASSY_FACTORY_ID'+ char(10)
  SET @v_dSql += '									FROM 	SCM_SYS_LOOKUP_VALUE'+ char(10)
  SET @v_dSql += '									WHERE 	1=1'+ char(10)
  SET @v_dSql += '									AND 		LOOKUP_TYPE_CODE = ''ELEC_POST_FACTORY_MAP'') AS MP'+ char(10)
  SET @v_dSql += '							ON 	1=1'+ char(10)
  SET @v_dSql += '							AND 	CASE WHEN ST.FACTORY_ID LIKE ''E%'' THEN MP.ELEC_FACTORY_ID ELSE MP.ASSY_FACTORY_ID END = ST.FACTORY_ID'+ char(10)
  SET @v_dSql += '							AND 	ST.FACTORY_ID = ASSY_FACTORY_ID'+ char(10)
  SET @v_dSql += '				WHERE 	1=1'+ char(10)
  SET @v_dSql += '				AND 		ST.CUTOFF_DATE = ''' + @P_PLAN_DATE +''''+ char(10)
  SET @v_dSql += '				AND 		ST.SITE_ID = ''A004'''+ char(10)
  SET @v_dSql += '				AND 		ST.ITEM_ID LIKE ''APC%'''+ char(10)
  SET @v_dSql += '				AND 		ST.STOCK_TYPE = ''WIP'''+ char(10)
  SET @v_dSql += '				AND 		IT.ACTIVE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '				AND			ST.WIPHOLD_YN = ''N'''+ char(10)
  SET @v_dSql += '				GROUP BY ST.ITEM_ID, IT.NICK_NAME,  ISNULL(MP.ELEC_FACTORY_ID, ST.FACTORY_ID)'+ char(10)
  SET @v_dSql += '				)'+ char(10)
  SET @v_dSql += '				, ATTR_TYPE AS'+ char(10)
  SET @v_dSql += '				('+ char(10)
  SET @v_dSql += '				SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT'+ char(10)
  SET @v_dSql += '				FROM 	SCM_SYS_LOOKUP_VALUE LV'+ char(10)
  SET @v_dSql += '							JOIN 	FP_INSTANCE_INFO_V FII'+ char(10)
  SET @v_dSql += '							ON 	1=1'+ char(10)
  SET @v_dSql += '							AND 	LV.SEGMENT1 = FII.INSTANCE_ID'+ char(10)
  SET @v_dSql += '				WHERE 	1=1'+ char(10)
  SET @v_dSql += '				AND 		LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT'''+ char(10)
  SET @v_dSql += '				)'+ char(10)
  SET @v_dSql += '		, STOCK_T AS (	SELECT	A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE, ISNULL(B.LANE_QTY, 1) AS LANE_QTY'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.TOTAL_QTY ELSE A.TOTAL_QTY / ISNULL(B.LANE_QTY, 1) END AS TOTAL_QTY'+ char(10)
  SET @v_dSql += '							, A.TOTAL_LOT_COUNT'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.JR_QTY ELSE A.JR_QTY / ISNULL(B.LANE_QTY, 1) END AS JR_QTY'+ char(10)
  SET @v_dSql += '							, A.JR_QTY_LOT_COUNT'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.ASSY_PC ELSE A.ASSY_PC / ISNULL(B.LANE_QTY, 1) END AS ASSY_PC'+ char(10)
  SET @v_dSql += '							, A.ASSY_PC_R AS ASSY_PC_R'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.PRE_RP_JR ELSE A.PRE_RP_JR / ISNULL(B.LANE_QTY, 1) END AS PRE_RP_JR'+ char(10)
  SET @v_dSql += '							, A.PRE_RP_JR_R AS PRE_RP_JR_R'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.PRE_ST_JR ELSE A.PRE_ST_JR / ISNULL(B.LANE_QTY, 1) END AS PRE_ST_JR'+ char(10)
  SET @v_dSql += '							, A.PRE_ST_JR_R AS PRE_ST_JR_R'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.POST_ST_PC ELSE A.POST_ST_PC / ISNULL(B.LANE_QTY, 1) END AS POST_ST_PC'+ char(10)
  SET @v_dSql += '							, A.POST_ST_PC_R AS POST_ST_PC_R'+ char(10)
  SET @v_dSql += '					FROM	('+ char(10)
  SET @v_dSql += '								SELECT 	A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME'+ char(10)
  SET @v_dSql += '											, CASE WHEN B.ATTR_DEFINIT IS NULL THEN ''B'' ELSE ''A'' END AS ATTR_TYPE'+ char(10)
  SET @v_dSql += '											, SUM(TOTAL_QTY) AS TOTAL_QTY'+ char(10)
  SET @v_dSql += '											, SUM(TOTAL_LOT_COUNT) AS TOTAL_LOT_COUNT'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR)  AS JR_QTY'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR_R)  AS JR_QTY_LOT_COUNT'+ char(10)
  SET @v_dSql += '											, SUM(ASSY_PC) AS ASSY_PC'+ char(10)
  SET @v_dSql += '											, SUM(ASSY_PC_R) AS ASSY_PC_R'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR) AS PRE_RP_JR'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR_R) AS PRE_RP_JR_R'+ char(10)
  SET @v_dSql += '											, SUM(PRE_ST_JR) AS PRE_ST_JR'+ char(10)
  SET @v_dSql += '											, SUM(PRE_ST_JR_R) AS PRE_ST_JR_R'+ char(10)
  SET @v_dSql += '											, SUM(POST_ST_PC) AS POST_ST_PC'+ char(10)
  SET @v_dSql += '											, SUM(POST_ST_PC_R) AS POST_ST_PC_R'+ char(10)
  SET @v_dSql += '								FROM 	STOCK A'+ char(10)
  SET @v_dSql += '											LEFT OUTER JOIN ATTR_TYPE B'+ char(10)
  SET @v_dSql += '											ON 	1=1'+ char(10)
  SET @v_dSql += '											AND 	A.NICK_NAME LIKE B.ATTR_DEFINIT'+ char(10)
  SET @v_dSql += '								GROUP BY A.FACTORY_ID, ITEM_ID, NICK_NAME, B.ATTR_DEFINIT'+ char(10)
  SET @v_dSql += '							) A'+ char(10)
  SET @v_dSql += '							LEFT OUTER JOIN ('+ char(10)
  SET @v_dSql += '								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MAX( A.LANE_QTY ) AS LANE_QTY'+ char(10)
  SET @v_dSql += '								FROM SCM_ITEM_LANE_M A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '								GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID'+ char(10)
  SET @v_dSql += '							) B'+ char(10)
  SET @v_dSql += '							ON 1=1'+ char(10)
  SET @v_dSql += '							AND  B.FACTORY_ID 	= A.FACTORY_ID'+ char(10)
  SET @v_dSql += '							AND  B.ITEM_ID 		= A.ITEM_ID'+ char(10)
  SET @v_dSql += '					WHERE 1=1'+ char(10)
  SET @v_dSql += '		) -- STOCK_T END'+ char(10)
  SET @v_dSql += '		, DEFAULT_ROLL AS ('+ char(10)
  SET @v_dSql += '				SELECT FACTORY_ID, ELECTRODE_TYPE, ISNULL([-],0) AS JR_COL, ISNULL([A],0) AS A_TYPE_COL, ISNULL([B],0) AS B_TYPE_COL'+ char(10)
  SET @v_dSql += '				FROM('+ char(10)
  SET @v_dSql += '					SELECT	SEGMENT2 AS FACTORY_ID,'+ char(10)
  SET @v_dSql += '							CASE WHEN SEGMENT3 = ''A'' THEN ''ANODE'''+ char(10)
  SET @v_dSql += '								 WHEN SEGMENT3 = ''C'' THEN ''CATHODE'''+ char(10)
  SET @v_dSql += '								 ELSE SEGMENT3 END AS ELECTRODE_TYPE    , SEGMENT4 AS ATTR_TYPE, ATTRIBUTE1 AS ROLL_QTY'+ char(10)
  SET @v_dSql += '					FROM	SCM_SYS_LOOKUP_VALUE A'+ char(10)
  SET @v_dSql += '					WHERE	A.LOOKUP_TYPE_CODE = ''E_POST_JR_DEFAULT_DEFINIT'''+ char(10)
  SET @v_dSql += '					AND		A.SEGMENT1 = ''PL_E_POST'''+ char(10)
  SET @v_dSql += '					AND		A.ACTIVE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '				) AS RESULT'+ char(10)
  SET @v_dSql += '				PIVOT ('+ char(10)
  SET @v_dSql += '					 MAX(ROLL_QTY) FOR ATTR_TYPE IN ([-], [A], [B])'+ char(10)
  SET @v_dSql += '				) AS PIV'+ char(10)
  SET @v_dSql += '			)'+ char(10)



  SET @v_dSql += '	, MAIN_P AS ('+ char(10)
  SET @v_dSql += '				SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '						, A.ITEM_ID, A.NP_ITEM_ID  , A.NICK_NAME, A.FLOW_ID'+ char(10)
  SET @v_dSql += '						, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '						, A.CATEGORY_ID, A.CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '						, SUM(A.QTY) AS QTY'+ char(10)
  SET @v_dSql += '				FROM	('+ char(10)
  SET @v_dSql += '							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '									, A.ITEM_ID, NULL AS NP_ITEM_ID , E.NICK_NAME, E.FLOW_ID'+ char(10)
  SET @v_dSql += '									, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN ''ANODE'''+ char(10)
  SET @v_dSql += '										   WHEN A.ELECTRODE_TYPE = ''C'' THEN ''CATHODE'''+ char(10)
  SET @v_dSql += '										   ELSE A.ELECTRODE_TYPE END ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '									, ''MASS''  AS PRODUCTION_TYPE'+ char(10)
  SET @v_dSql += '									, CASE WHEN B.ATTR_DEFINIT IS NULL THEN ''B'' ELSE ''A'' END AS ATTR_TYPE'+ char(10)
  SET @v_dSql += '									, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '									, A.CATEGORY_ID, A.CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '									, CASE WHEN ''JR'' = ''JR'' THEN A.OUT_JR_QTY ELSE A.OUT_PC_QTY END AS QTY'+ char(10)
  SET @v_dSql += '							FROM	('+ char(10)
  SET @v_dSql += '										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '												, A.ITEM_ID, A.NP_ITEM_ID'+ char(10)
  SET @v_dSql += '												, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE'+ char(10)
  SET @v_dSql += '												, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+ char(10)
  SET @v_dSql += '												, SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) AS CATEGORY_ID'+ char(10)
  SET @v_dSql += '												, SUBSTRING(A.CATEGORY,0,2) AS CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.OUT_JR_QTY,0) END AS OUT_JR_QTY'+ char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.OUT_PC_QTY,0) END AS OUT_PC_QTY'+ char(10)
  SET @v_dSql += '										FROM   FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '										WHERE  A.INSTANCE_ID = ''PL_E_POST'''+ char(10)
  SET @v_dSql += '										AND    A.FP_PLAN_ID  = ''' + @P_PLAN_ID +''''+ char(10)
  SET @v_dSql += '										AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+@p_bucket_from+''') AND CONVERT(DATETIME,'''+@p_bucket_to+''')'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '									) A'+ char(10)
  SET @v_dSql += '										INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '										ON  A.COMPANY_ID  = E.COMPANY_ID'+ char(10)
  SET @v_dSql += '										AND A.DIVISION_ID = E.DIVISION_ID'+ char(10)
  SET @v_dSql += '										AND A.SITE_ID	  = E.SITE_ID'+ char(10)
  SET @v_dSql += '										AND A.ITEM_ID	  = E.ITEM_ID'+ char(10)
  SET @v_dSql += '										AND E.ACTIVE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '										LEFT OUTER JOIN ATTR_TYPE B'+ char(10)
  SET @v_dSql += '										ON 	1=1'+ char(10)
  SET @v_dSql += '										AND E.NICK_NAME LIKE B.ATTR_DEFINIT'+ char(10)
  SET @v_dSql += '								WHERE 1=1'+ char(10)
  SET @v_dSql += '						) A'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '				WHERE	1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '						, A.ITEM_ID, A.NP_ITEM_ID, A.NICK_NAME , A.FLOW_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '						, A.CATEGORY_ID, A.CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '	)'+ char(10)



  SET @v_dSql += '	, MAIN_I AS ('+ char(10)
  SET @v_dSql += '				  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '				       , A.ITEM_ID, ISNULL(E.NICK_NAME,''-'') AS NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID'+ char(10)
  SET @v_dSql += '				       , A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE'+ char(10)
  SET @v_dSql += '				       , ISNULL(F.LEVEL_3_NAME,''-'') AS LEVEL_3_NAME'+ char(10)
  SET @v_dSql += '				  	   , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '							, ''I'' AS PSI'+ char(10)
  SET @v_dSql += '						, ''DATA'' AS DATA_TYPE'+ char(10)

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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
			
  SET @v_dSql += '			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A'+ char(10)
  SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B'+ char(10)
  SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A'+ char(10)
  SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B'+ char(10)
  SET @v_dSql += '					   ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  --SET @v_dSql += '			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220502'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220502'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220502'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220502'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B'+ char(10)
  --SET @v_dSql += '					   ELSE 0 END) AS D0'+ char(10)
  
  
  
  --SET @v_dSql += '			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220503'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220503'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220503'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220503'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B'+ char(10)
  --SET @v_dSql += '					   ELSE 0 END) AS D1'+ char(10)
  --SET @v_dSql += '			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220504'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220504'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220504'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220504'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B'+ char(10)
  --SET @v_dSql += '					   ELSE 0 END) AS D2'+ char(10)
  --SET @v_dSql += '			, SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220505'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220505'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220505'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A'+ char(10)
  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''20220505'' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B'+ char(10)
  --SET @v_dSql += '					   ELSE 0 END) AS D3'+ char(10)
  SET @v_dSql += '		  FROM   ('+ char(10)
  SET @v_dSql += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, ''' + @P_PLAN_DATE +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(D.PRE_ST_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) END AS EOH_JR_QTY_A'+ char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, ''' + @P_PLAN_DATE +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_QTY_B'+ char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, ''' + @P_PLAN_DATE +''') THEN (ISNULL(D.POST_ST_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_PC_QTY_A'+ char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, ''' + @P_PLAN_DATE +''') THEN (ISNULL(D.ASSY_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_PC_QTY_B'+ char(10)
  SET @v_dSql += '					FROM	('+ char(10)
  SET @v_dSql += '								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '										, SUM(NOTCHING_PLAN) AS NOTCHING_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(COATING_PLAN) AS COATING_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(INTRANSIT) AS INTRANSIT'+ char(10)
  SET @v_dSql += '										, SUM(SHIPMENT_PLAN) AS SHIPMENT_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(SLITTING_PLAN) AS SLITTING_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(ROLL_PRESS_PLAN) AS ROLL_PRESS_PLAN'+ char(10)
  SET @v_dSql += '								FROM	('+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''NOTCHING_PLAN'' THEN A.QTY ELSE 0 END AS NOTCHING_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''COATING_PLAN'' THEN A.QTY ELSE 0 END AS COATING_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''INTRANSIT'' THEN A.QTY ELSE 0 END AS INTRANSIT'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''SHIPMENT_PLAN'' THEN A.QTY ELSE 0 END AS SHIPMENT_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''SLITTING_PLAN'' THEN A.QTY ELSE 0 END AS SLITTING_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''ROLL_PRESS_PLAN'' THEN A.QTY ELSE 0 END AS ROLL_PRESS_PLAN'+ char(10)
  SET @v_dSql += '											FROM	('+ char(10)
  SET @v_dSql += '														SELECT *'+ char(10)
  SET @v_dSql += '														FROM	MAIN_P A'+ char(10)
  SET @v_dSql += '														WHERE	1=1'+ char(10)
  SET @v_dSql += '													) A'+ char(10)
  SET @v_dSql += '											WHERE	1=1'+ char(10)
  SET @v_dSql += '										) A'+ char(10)
  SET @v_dSql += '								WHERE	1=1'+ char(10)
  SET @v_dSql += '								GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '							) A'+ char(10)
  SET @v_dSql += '							 LEFT OUTER HASH JOIN ('+ char(10)
  SET @v_dSql += '									SELECT *'+ char(10)
  SET @v_dSql += '									FROM STOCK_T AS A'+ char(10)
  SET @v_dSql += '								) D'+ char(10)
  SET @v_dSql += '							  ON 1=1'+ char(10)
  SET @v_dSql += '							  AND A.FACTORY_ID = D.FACTORY_ID'+ char(10)
  SET @v_dSql += '							  AND A.ITEM_ID = D.ITEM_ID'+ char(10)
  SET @v_dSql += '							  AND A.ATTR_TYPE = D.ATTR_TYPE'+ char(10)
  SET @v_dSql += '					WHERE	1=1'+ char(10)
  SET @v_dSql += '				      ) A'+ char(10)
  SET @v_dSql += '				      INNER JOIN ('+ char(10)
  SET @v_dSql += '							      	SELECT *'+ char(10)
  SET @v_dSql += '							      	FROM ('+ char(10)
  SET @v_dSql += '							      			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, '''' AS CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '	 										UNION ALL'+ char(10)
  SET @v_dSql += '	 										SELECT ''EOH_JR_QTY'' AS CATEGORY_ID, ''EOH(J/R)'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER, ''70'' AS CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '	 										UNION ALL'+ char(10)
  SET @v_dSql += '											SELECT ''EOH_PC_QTY'' AS CATEGORY_ID, ''EOH(P/C)'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER, ''100'' AS CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '					      				) BB'+ char(10)
  SET @v_dSql += '					      			WHERE CATEGORY_ID <> ''X'''+ char(10)
  SET @v_dSql += '				      ) B'+ char(10)
  SET @v_dSql += '				      ON 1=1'+ char(10)
  SET @v_dSql += '				      INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '				      ON  A.PLAN_DATE = C.YYYYMMDD'+ char(10)
  SET @v_dSql += '				      INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '				      ON  A.COMPANY_ID  = E.COMPANY_ID'+ char(10)
  SET @v_dSql += '				      AND A.DIVISION_ID = E.DIVISION_ID'+ char(10)
  SET @v_dSql += '				      AND A.SITE_ID	  = E.SITE_ID'+ char(10)
  SET @v_dSql += '				      AND A.ITEM_ID	  = E.ITEM_ID'+ char(10)
  SET @v_dSql += '				      AND E.ACTIVE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '				      INNER HASH JOIN SCM_ITEM_CLASS_M F WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '				      ON  E.ITEM_CLASS = F.CLASS_ID'+ char(10)
  SET @v_dSql += '					  AND F.USE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '				      WHERE 1=1'+ char(10)
  SET @v_dSql += '				      AND NOT EXISTS ('+ char(10)
  SET @v_dSql += '										SELECT	1'+ char(10)
  SET @v_dSql += '										FROM	SCM_SYS_LOOKUP_VALUE AA'+ char(10)
  SET @v_dSql += '										WHERE	1=1'+ char(10)
  SET @v_dSql += '										AND		AA.LOOKUP_TYPE_CODE = ''E_POST_EXCEPT_PANCAKE'''+ char(10)
  SET @v_dSql += '										AND		AA.ACTIVE_FLAG = ''Y'''+ char(10)
  SET @v_dSql += '										AND		AA.SEGMENT1 = ''PL_E_POST'''+ char(10)
  SET @v_dSql += '										AND		AA.SEGMENT2 = A.ITEM_ID'+ char(10)
  SET @v_dSql += '									 )'+ char(10)
  SET @v_dSql += '				      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '				             , A.ITEM_ID, ISNULL(E.NICK_NAME,''-''),  A.FLOW_ID, A.NP_ITEM_ID, ISNULL(F.LEVEL_3_NAME,''-'')'+ char(10)
  SET @v_dSql += '							 , A.ELECTRODE_TYPE, A.ATTR_TYPE , A.PRODUCTION_TYPE, A.ATTR_TYPE'+ char(10)
  SET @v_dSql += '				      	     , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '	)'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += ',MAIN_PLAN AS (	SELECT	A.*'+ char(10)
  SET @v_dSql += '	FROM	('+ char(10)
  SET @v_dSql += '				SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '						, B.WH_GROUP_NAME AS CATEGORY_NAME'+ char(10)
  SET @v_dSql += '						, CASE WHEN B.ATTR_TYPE = ''-'' THEN 11'+ char(10)
  SET @v_dSql += '							   WHEN B.ATTR_TYPE = ''A'' THEN 21'+ char(10)
  SET @v_dSql += '							   WHEN B.ATTR_TYPE = ''B'' THEN 31'+ char(10)
  SET @v_dSql += '							   ELSE 41 END   AS CATEGORY_ORDER'+ char(10)

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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
			
  SET @v_dSql += '							  , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
  SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_PC_QTY'' THEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
  SET @v_dSql += '								    ELSE 0 END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			
			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  --SET @v_dSql += '							  , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN D0'+ char(10)
  --SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_PC_QTY'' THEN D0'+ char(10)
  --SET @v_dSql += '								    ELSE 0 END ) AS D0'+ char(10)
  --SET @v_dSql += '						  , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN D1'+ char(10)
  --SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_PC_QTY'' THEN D1'+ char(10)
  --SET @v_dSql += '								    ELSE 0 END )  AS D1'+ char(10)
  --SET @v_dSql += '						  , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN D2'+ char(10)
  --SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_PC_QTY'' THEN D2'+ char(10)
  --SET @v_dSql += '								    ELSE 0 END )  AS D2'+ char(10)
  --SET @v_dSql += '					    , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN D3'+ char(10)
  --SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_PC_QTY'' THEN D3'+ char(10)
  --SET @v_dSql += '								    ELSE 0 END )  AS D3'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '				FROM ('+ char(10)
  SET @v_dSql += '						  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '							   , A.ITEM_ID AS ITEM_ID, NULL AS NICK_NAME, NULL AS FLOW_ID, NULL AS NP_ITEM_ID, A.ELECTRODE_TYPE AS ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, A.ATTR_TYPE AS ATTR_TYPE'+ char(10)
  SET @v_dSql += '							   , NULL AS  LEVEL_3_NAME'+ char(10)
  SET @v_dSql += '							   , CATEGORY_ID AS CATEGORY_ID, CATEGORY_NAME AS CATEGORY_NAME, CATEGORY_ORDER AS CATEGORY_ORDER, CATEGORY_GROUP AS CATEGORY_GROUP'+ char(10)

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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
			
  --SET @v_dSql += '							  , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
  --SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_PC_QTY'' THEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
  --SET @v_dSql += '								    ELSE 0 END ) AS'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
  SET @v_dSql += '							  , SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+' < 0 THEN 0 ELSE CEILING(D0 / ISNULL(C.ROLL_QTY,A.ROLL_QTY)) END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)		
			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  --SET @v_dSql += '							  , SUM( CASE WHEN D0 < 0 THEN 0 ELSE CEILING(D0 / ISNULL(C.ROLL_QTY,A.ROLL_QTY)) END ) AS D0'+ char(10)
  --SET @v_dSql += '	    					  , SUM( CASE WHEN D1 < 0 THEN 0 ELSE CEILING(D1 / ISNULL(C.ROLL_QTY,A.ROLL_QTY)) END ) AS D1'+ char(10)
  --SET @v_dSql += '	    					  , SUM( CASE WHEN D2 < 0 THEN 0 ELSE CEILING(D2 / ISNULL(C.ROLL_QTY,A.ROLL_QTY)) END ) AS D2'+ char(10)
  --SET @v_dSql += '	    					  , SUM( CASE WHEN D3 < 0 THEN 0 ELSE CEILING(D3 / ISNULL(C.ROLL_QTY,A.ROLL_QTY)) END ) AS D3'+ char(10)
  SET @v_dSql += '	    				  FROM'+ char(10)
  SET @v_dSql += '	      						('+ char(10)
  SET @v_dSql += '	      							SELECT	A.*'+ char(10)
  SET @v_dSql += '	      									, CASE WHEN ''JR'' = ''JR'' THEN D.JR_COL'+ char(10)
  SET @v_dSql += '	      										WHEN A.ATTR_TYPE = ''A'' THEN D.A_TYPE_COL'+ char(10)
  SET @v_dSql += '	      										WHEN A.ATTR_TYPE = ''B'' THEN D.B_TYPE_COL'+ char(10)
  SET @v_dSql += '	      										ELSE 1 END AS ROLL_QTY'+ char(10)
  SET @v_dSql += '	      							FROM	MAIN_I A'+ char(10)
  SET @v_dSql += '	      									LEFT OUTER HASH JOIN DEFAULT_ROLL D'+ char(10)
  SET @v_dSql += '	      									ON 1=1'+ char(10)
  SET @v_dSql += '	      									AND  D.FACTORY_ID 	= A.FACTORY_ID'+ char(10)
  SET @v_dSql += '	      									AND  D.ELECTRODE_TYPE 	= A.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '	      							WHERE	1=1'+ char(10)
  SET @v_dSql += '								) A'+ char(10)
  SET @v_dSql += '								LEFT OUTER HASH JOIN ('+ char(10)
  SET @v_dSql += '													SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MAX( (CASE WHEN ''JR'' = ''JR'' THEN A.JUMBO_ROLL_LENGTH ELSE A.PC_ROLL_LENGTH END) ) AS ROLL_QTY'+ char(10)
  SET @v_dSql += '													FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '													WHERE	1=1'+ char(10)
  SET @v_dSql += '													AND		SITE_ID = ''A004'''+ char(10)
  SET @v_dSql += '													GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID'+ char(10)
  SET @v_dSql += '											) C'+ char(10)
  SET @v_dSql += '								ON 1=1'+ char(10)
  SET @v_dSql += '								AND  C.COMPANY_ID 	= A.COMPANY_ID'+ char(10)
  SET @v_dSql += '								AND  C.DIVISION_ID 	= A.DIVISION_ID'+ char(10)
  SET @v_dSql += '								AND  C.SITE_ID 		= A.SITE_ID'+ char(10)
  SET @v_dSql += '								AND  C.PLANT_ID 	= A.PLANT_ID'+ char(10)
  SET @v_dSql += '								AND  C.FACTORY_ID 	= A.FACTORY_ID'+ char(10)
  SET @v_dSql += '								AND  C.ITEM_ID 		= A.ITEM_ID'+ char(10)
  SET @v_dSql += '						  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.ELECTRODE_TYPE , A.ATTR_TYPE'+ char(10)
  SET @v_dSql += '									, CATEGORY_ID, CATEGORY_NAME, CATEGORY_ORDER, CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '					) A'+ char(10)
  SET @v_dSql += '					INNER JOIN WH_CAPA_TOTAL B'+ char(10)
  SET @v_dSql += '					ON 1=1'+ char(10)
  SET @v_dSql += '					AND A.FACTORY_ID = B.FACTORY_ID'+ char(10)
  SET @v_dSql += '					AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '				WHERE 1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '						, B.WH_GROUP_NAME , B.ATTR_TYPE'+ char(10)
  SET @v_dSql += '		) A'+ char(10)

  SET @v_dSql += ')'+ char(10)

  SET @v_dSql += 'SELECT * FROM (SELECT *,''PLAN'' AS CATE,''DATA'' AS ROW_TYPE FROM MAIN_PLAN) A'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)

--- GRAPH PART START
  SET @v_dSql += 'UNION'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ELECTRODE_TYPE,WH_GROUP_NAME AS  CATEGROY_NAME, T.CATEGORY_ORDER*10 AS CATEGORY_ORDER'+ char(10)
  SET @v_dSql += ''+ char(10)

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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
			
			 SET @v_dSql += ',NULL AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)	
 
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  SET @v_dSql += ',''GRAPH'' AS CATE, ''GRAPH'' AS ROW_TYPE '+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'FROM WH_CAPA_TOTAL T'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('T.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)

--- CAPA PART START
  SET @v_dSql += 'UNION'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ELECTRODE_TYPE,WH_GROUP_NAME AS  CATEGROY_NAME,T.CATEGORY_ORDER*10 +2 AS CATEGORY_ORDER'+ char(10)
  SET @v_dSql += ''+ char(10)

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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
			
			 SET @v_dSql += ',T.WH_CAPA AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)	
 
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  SET @v_dSql += ',''Capa'' AS CATE, ''DATA'' AS ROW_TYPE '+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'FROM WH_CAPA_TOTAL T'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('T.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)


  --- CAPA + TEMP PART START
  SET @v_dSql += 'UNION'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ELECTRODE_TYPE,WH_GROUP_NAME AS  CATEGROY_NAME, T.CATEGORY_ORDER*10 +3 AS CATEGORY_ORDER '+ char(10)
  SET @v_dSql += ''+ char(10)

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
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
			
			 SET @v_dSql += ',T.TOTAL_WH_CAPA AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)	+ char(10)
 
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  SET @v_dSql += ',''Capa Temp'' AS CATE, ''DATA'' AS ROW_TYPE'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'FROM WH_CAPA_TOTAL T'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('T.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)



  SET @v_dSql += 'ORDER BY FACTORY_ID, ELECTRODE_TYPE, CATEGORY_ORDER'+ char(10)


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
      exec PR_UI_SQL_LOG 'PR_UI_FP02844_FIND_FP02844',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP02844_FIND_FP02844',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
