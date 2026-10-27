CREATE PROCEDURE [dbo].[PR_UI_FP02844_FIND_FP02844]
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
/**2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 뷰로 변경                                                    **/

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
  
  DECLARE @p_unit nvarchar(max);
  DECLARE @p_unit_digit nvarchar(max);
  DECLARE @p_round_point		NVARCHAR(MAX);

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
	
	END ELSE IF @tmp_column = 'UNIT' BEGIN
      SET @p_unit =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'ROUND_POINT' BEGIN
      SET @p_round_point =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
	IF @p_unit = 'K' BEGIN	--Roll
		SET @p_unit_digit = 1000;
		--SET @p_round_point = 2;
	END ELSE BEGIN
		SET @p_unit_digit = 1;
		SET @p_round_point = 0;
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

 
    DECLARE @sub_mst_loop_cnt integer = 0
  DECLARE @sub_max_loop_cnt integer = 0
  DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
  DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  DECLARE @sub_param_4 NVARCHAR(MAX) = '' 
	
	DECLARE @p_inner_company_id	NVARCHAR(MAX);
	DECLARE @p_inner_division_id	NVARCHAR(MAX);
	DECLARE @p_inner_site_id		NVARCHAR(MAX);
	
	SELECT	DISTINCT  @p_inner_company_id = A.SEGMENT2
			, @p_inner_division_id = A.SEGMENT3
			, @p_inner_site_id = A.SEGMENT4
	FROM	SCM_SYS_LOOKUP_VALUE A                                                                                   
	WHERE	A.LOOKUP_TYPE_CODE = 'INSTANCE_INFO'                                                                     
	AND		A.ACTIVE_FLAG = 'Y'                                                                                      
	AND		A.SEGMENT1 IN	(                                                                                          
								SELECT	A.SEGMENT3                                                                               
								FROM	SCM_SYS_LOOKUP_VALUE A                                                                     
								WHERE	A.LOOKUP_TYPE_CODE = 'ELEC_ASSY_INSTANCE_MAP'                                              
								AND		A.SEGMENT3 = ''+ @p_instance_id +''                                                                   
								AND		A.ACTIVE_FLAG = 'Y'                                                                        
							)                       

	IF OBJECT_ID('tempdb..#LANE_T') IS NOT NULL
	DROP TABLE #LANE_T

	IF OBJECT_ID('tempdb..#DEFAULT_M_PER_ROLL') IS NOT NULL
	DROP TABLE #DEFAULT_M_PER_ROLL

	BEGIN	-- Temp Lane

			SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID, A.ELECTRODE_TYPE
					, CASE WHEN X.ROLL_TYPE = 'J' THEN '-' ELSE ISNULL(B.ATTR_TYPE, 'B') END AS ATTR_TYPE
					, X.ROLL_TYPE
					, CASE WHEN X.ROLL_TYPE = 'J' AND SUM(PRE_RP_JR + PRE_ST_JR) > 0 THEN ROUND(SUM(PRE_RP_JR + PRE_ST_JR) / SUM(PRE_RP_JR_LOT + PRE_ST_JR_LOT) ,2)
						   WHEN X.ROLL_TYPE = 'P' AND SUM(POST_ST_PC) > 0 THEN ROUND(SUM(POST_ST_PC) / SUM(POST_ST_PC_LOT), 2)
						   ELSE NULL
					  END AS M_PER_ROLL
			INTO #DEFAULT_M_PER_ROLL
			FROM	(
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID, A.ITEM_ID 
								, IT.NICK_NAME, A.OPERATION_ID, A.FP_APPLY_OPERATION_ID
								, CASE WHEN CHARINDEX('ANODE', IT.SPEC) > 0 THEN 'ANODE' ELSE 'CATHODE' END AS ELECTRODE_TYPE
								, SUM(QTY) AS QTY, SUM(LOT_COUNT)AS LOT_COUNT

								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E2000' THEN A.QTY ELSE 0 END) AS PRE_RP_JR				                                                
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN A.QTY ELSE 0 END) AS PRE_ST_JR
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID IN ('E3000','E4000') AND OPERATION_ID > 'E4000'  THEN A.QTY ELSE 0 END) AS POST_ST_PC

								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E2000' THEN A.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_LOT				                                                
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID = 'E3000' AND OPERATION_ID <= 'E4000' THEN A.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_LOT
								, SUM(CASE WHEN FP_APPLY_OPERATION_ID IN ('E3000','E4000') AND OPERATION_ID > 'E4000'  THEN A.LOT_COUNT ELSE 0 END) AS POST_ST_PC_LOT
						FROM SCM_STOCK_H_V A 
								INNER HASH JOIN SCM_ITEM_M IT WITH(NOLOCK)				                                                                                                                                                          
								ON 	1=1	
								AND IT.ACTIVE_FLAG = 'Y'		                                                                                                                                                                        
								AND A.COMPANY_ID = IT.COMPANY_ID 		                                                                                                                                          
								AND A.DIVISION_ID = IT.DIVISION_ID 		                                                                                                                                        
								AND A.SITE_ID = IT.SITE_ID 		                                                                                         
								AND A.ITEM_ID = IT.ITEM_ID
						WHERE CUTOFF_DATE = '' + @P_PLAN_DATE +''
						AND A.SITE_ID = ''+ @p_inner_site_id +''      
						AND	A.ITEM_ID LIKE 'APC%'					                                                                                                                                                
						AND	A.STOCK_TYPE = 'WIP'
						AND EXISTS (
										SELECT 1
										FROM (
												SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
												FROM SCM_FACTORY_M WITH(NOLOCK)
												WHERE 1=1
												AND SITE_ID = ''+ @p_inner_site_id +''      
												AND SHOP_GROUP_ID = 'E'
											) X
										WHERE 1=1
										AND A.COMPANY_ID = X.COMPANY_ID
										AND A.DIVISION_ID = X.DIVISION_ID
										AND A.SITE_ID = X.SITE_ID
										AND A.PLANT_ID = X.PLANT_ID
										AND A.FACTORY_ID = X.FACTORY_ID
									)
						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID, A.ITEM_ID 
								,  IT.NICK_NAME, A.OPERATION_ID, A.FP_APPLY_OPERATION_ID
								, CASE WHEN CHARINDEX('ANODE', IT.SPEC) > 0 THEN 'ANODE' ELSE 'CATHODE' END
					) A
					LEFT OUTER JOIN (
									SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT					
									FROM 	SCM_SYS_LOOKUP_VALUE LV	WITH(NOLOCK)					                                                                                                                                                  
											JOIN 	FP_INSTANCE_INFO_V FII			                                                                                                                                                  
											ON 	1=1			                                                                                                                                                                        
											AND 	LV.SEGMENT1 = FII.INSTANCE_ID 			                                                                                                                                               
									WHERE 	1=1						                                                                                                                                                                    
									AND 	LOOKUP_TYPE_CODE = 'E_POST_WH_ATTR_TYPE_DEFINIT'	
									AND		LV.ACTIVE_FLAG = 'Y'
					) B
					ON 	1=1						                                                                                                                                                                  
					AND 	A.NICK_NAME LIKE B.ATTR_DEFINIT
					JOIN (
							SELECT 'J' AS ROLL_TYPE UNION
							SELECT 'P' AS ROLL_TYPE 
					) X
					ON 1=1
			WHERE	1=1
			AND		ISNULL(FP_APPLY_OPERATION_ID,'') <> ''
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A. FACTORY_ID,A.ELECTRODE_TYPE, CASE WHEN X.ROLL_TYPE = 'J' THEN '-' ELSE ISNULL(B.ATTR_TYPE, 'B') END, X.ROLL_TYPE

	END

	BEGIN	-- Temp Lane

		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE																							
				, LANE_QTY     
				, CASE WHEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) = 0 THEN 1 ELSE ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) END AS JUMBO_ROLL_LENGTH                                                                                                                                         
				, CASE WHEN ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) = 0 THEN 1 ELSE ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) END AS PC_ROLL_LENGTH                       
				, CASE WHEN 'JR' = 'JR' THEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH)	
						ELSE  ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) * LANE_QTY END AS M_PER_ROLL_QTY
				, CASE WHEN 'JR' = 'JR' THEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH)	
								ELSE  ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) * LANE_QTY END AS JR_M_PER_ROLL_QTY	
						, CASE WHEN 'JR' = 'JR' THEN ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) / LANE_QTY
								ELSE  ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH)  END AS PC_M_PER_ROLL_QTY	
		INTO #LANE_T
		FROM (                                                                                                                                                                                                                  
				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE                                                                                                    
						,CASE WHEN A.ITEM_ID LIKE 'APCA%' THEN 'ANODE'                                                                                                                                                      
								WHEN A.ITEM_ID LIKE 'APCC%' THEN 'CATHODE'                                                                                                                                                    
							END AS ELECTRODE_TYPE                                                                                                                                                                                  
						--, MAX(CASE WHEN A.FLOW_ID = 'E2000E3000' THEN 1 ELSE ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY))) END) AS LANE_QTY		 
						, MAX(ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY)))) AS LANE_QTY
						, MAX( B.JUMBO_ROLL_LENGTH ) AS JUMBO_ROLL_LENGTH		                                                                                                                                                
						, MAX( B.PC_ROLL_LENGTH ) AS PC_ROLL_LENGTH		                                                                                                                                                        
				FROM	(                                                                                                                                                                                                       
							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, 'B') AS ATTR_TYPE                                                 
							FROM	SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                                                                                                             
									INNER HASH JOIN(                                                                                                                                                                            
											SELECT DISTINCT COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                                                                                      
											FROM FP_INSTANCE_LINE_V A WITH(NOLOCK)                                                                                                                                              
											WHERE	1=1	                                                                                                                                                                        
											AND INSTANCE_ID = ''+ @p_instance_id +''                                                                                                                                                  
									)  B                                                                                                                                                                                        
									ON 1=1                                                                                                                                                                                      
									AND  B.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                          
									AND  B.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                         
									AND  B.SITE_ID 		= A.SITE_ID                                                                                                                                                             
									AND  B.PLANT_ID 	= A.PLANT_ID                                                                                                                                                            
									INNER JOIN SCM_ITEM_M C WITH(NOLOCK)                                                                                                                                                        
									ON 1=1                                                                                                                                                                                      
									AND  A.COMPANY_ID	= C.COMPANY_ID                                                                                                                                                          
									AND  A.DIVISION_ID	= C.DIVISION_ID                                                                                                                                                         
									AND  A.SITE_ID		= C.SITE_ID                                                                                                                                                             
									AND  A.ITEM_ID		= C.ITEM_ID                                                                                                                                                             
									AND  C.ACTIVE_FLAG = 'Y'                                                                                                                                                                  
									LEFT OUTER JOIN (							                                                                                                                                                                            
										SELECT 	DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT					
										FROM 	SCM_SYS_LOOKUP_VALUE LV						                                                                                                                                                  
													JOIN 	FP_INSTANCE_INFO_V FII			                                                                                                                                                  
													ON 	1=1			                                                                                                                                                                        
													AND 	LV.SEGMENT1 = FII.INSTANCE_ID 			                                                                                                                                          
										WHERE 	1=1						                                                                                                                                                                    
										AND 		LOOKUP_TYPE_CODE = 'E_POST_WH_ATTR_TYPE_DEFINIT'
										AND 		LV.ACTIVE_FLAG = 'Y'
									) E	                                                                                                                                                                                        
									ON 	1=1						                                                                                                                                                                
									AND C.NICK_NAME LIKE E.ATTR_DEFINIT	                                                                                                                                                        
							WHERE	1=1                                                                                                                                                                                         
							AND		A.SITE_ID = ''+ @p_inner_site_id +''                                                                                                                                                                       
							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, 'B')                                                            
						) A                                                                                                                                                                                                     
						LEFT OUTER JOIN (                                                                                                                                                                                       
							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                  
									, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
									, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
									, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH                                                                   
							FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
							WHERE	1=1	                                                                                                                                                                                        
							AND		A.SITE_ID = ''+ @p_inner_site_id +''                                                                                                                                                                      
							AND  A.PROD_VERSION_TYPE = 'E3000E4000'                                                                                                                                                           
							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                
						) B                                                                                                                                                                                                     
						ON 1=1                                                                                                                                                                                                  
						AND  B.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
						AND  B.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
						AND  B.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
						AND  B.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
						AND  B.FACTORY_ID 	= A.FACTORY_ID                                                                                                                                                                      
						AND  B.ITEM_ID 		= A.ITEM_ID	                                                                                                                                                                        
						LEFT OUTER JOIN (                                                                                                                                                                                       
							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                  
									, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
									, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
									, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH                     
							FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
							WHERE	1=1	                                                                                                                                                                                        
							AND		SITE_ID = ''+ @p_inner_site_id +''	                                                                                                                                                                        
							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID                                                                                                                
						) C                                                                                                                                                                                                     
						ON 1=1                                                                                                                                                                                                  
						AND  C.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
						AND  C.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
						AND  C.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
						AND  C.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
						AND  B.FACTORY_ID 	= A.FACTORY_ID                                                                                                                                                                      
						AND  C.ITEM_ID 		= A.ITEM_ID                                                                                                                                                                         
						LEFT OUTER JOIN (                                                                                                                                                                                       
							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                                
									, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
									, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
									, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH                     
							FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
							WHERE	1=1	                                                                                                                                                                                        
							AND		A.SITE_ID = ''+ @p_inner_site_id +''                                                                                                                                                                       
							AND  A.PROD_VERSION_TYPE = 'E3000E4000'                                                                                                                                                           
							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                              
						) D                                                                                                                                                                                                     
						ON 1=1                                                                                                                                                                                                  
						AND  D.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
						AND  D.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
						AND  D.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
						AND  D.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
						AND  D.ITEM_ID 		= A.ITEM_ID	                                                                                                                                                                        
						LEFT OUTER JOIN (                                                                                                                                                                                       
							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                                
									, MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY	
									, MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH
									, MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH                     
							FROM SCM_ITEM_LANE_M A  WITH(NOLOCK)                                                                   																							    
							WHERE	1=1	                                                                                                                                                                                        
							AND		SITE_ID = ''+ @p_inner_site_id +''                                                                                                                                                                        
							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                                                                                              
						) E                                                                                                                                                                                                     
						ON 1=1                                                                                                                                                                                                  
						AND  E.COMPANY_ID 	= A.COMPANY_ID                                                                                                                                                                      
						AND  E.DIVISION_ID 	= A.DIVISION_ID                                                                                                                                                                     
						AND  E.SITE_ID 		= A.SITE_ID                                                                                                                                                                         
						AND  E.PLANT_ID 	= A.PLANT_ID                                                                                                                                                                        
						AND  E.ITEM_ID 		= A.ITEM_ID	                                                                                                                                                                        
				WHERE 1=1                                                                                                                                                                                                       
				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE                                                                                                  
			) A                                                                                                                                                                                                                 
			LEFT OUTER HASH JOIN (                                                                                                                                                                                              
					SELECT FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE                                                                                                                                                              
							, MAX(JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(PC_ROLL_LENGTH) AS PC_ROLL_LENGTH                                                                                                                
					FROM	(                                                                                                                                                                                                   
								SELECT FACTORY_ID, ELECTRODE_TYPE, B.ATTR_TYPE                                                                                                                                                  
										, CASE WHEN B.UOM_TYPE = 'JR' THEN JR_COL END AS JUMBO_ROLL_LENGTH                                                                                                                    
										, CASE WHEN B.UOM_TYPE = 'PC' AND B.ATTR_TYPE = 'A' THEN A_TYPE_COL                                                                                                                 
												WHEN B.UOM_TYPE = 'PC' AND B.ATTR_TYPE = 'B' THEN B_TYPE_COL                                                                                                                
												ELSE 0 END AS PC_ROLL_LENGTH                                                                                                                                                    
								FROM	(                                                                                                                                                                                       
											SELECT FACTORY_ID, ELECTRODE_TYPE, ISNULL([-],0) AS JR_COL, ISNULL([A],0) AS A_TYPE_COL, ISNULL([B],0) AS B_TYPE_COL	                                                            
											FROM(																													                                                            
													--SELECT	SEGMENT2 AS FACTORY_ID, 																					                                                        
													--		CASE WHEN SEGMENT3 = 'A' THEN 'ANODE'																	                                                        
													--				WHEN SEGMENT3 = 'C' THEN 'CATHODE' 																                                                        
													--				ELSE SEGMENT3 END AS ELECTRODE_TYPE    , SEGMENT4 AS ATTR_TYPE, ATTRIBUTE1 AS ROLL_QTY                                                                      
													--FROM	SCM_SYS_LOOKUP_VALUE A                                                                     					                                                        
													--WHERE	A.LOOKUP_TYPE_CODE = 'E_POST_JR_DEFAULT_DEFINIT'                                              			                                                        
													--AND		A.SEGMENT1 = ''+ @p_instance_id +''                                                                  				                                                        
													--AND		A.ACTIVE_FLAG = 'Y'     
													SELECT	FACTORY_ID, ELECTRODE_TYPE,  ATTR_TYPE,  M_PER_ROLL AS ROLL_QTY
													FROM	#DEFAULT_M_PER_ROLL
												) AS RESULT																												                                                        
												PIVOT (																													                                                        
														MAX(ROLL_QTY) FOR ATTR_TYPE IN ([-], [A], [B])																		                                                    
												) AS PIV                                                                                                                                                                        
										) A                                                                                                                                                                                     
										JOIN (                                                                                                                                                                                  
												SELECT 'JR' AS UOM_TYPE , 'A' AS ATTR_TYPE UNION                                                                                                                            
												SELECT 'JR' AS UOM_TYPE , 'B' AS ATTR_TYPE UNION                                                                                                                            
												SELECT 'PC' AS UOM_TYPE , 'A' AS ATTR_TYPE UNION                                                                                                                            
												SELECT 'PC' AS UOM_TYPE , 'B' AS ATTR_TYPE                                                                                                                                  
											) B                                                                                                                                                                                 
										ON 1=1                                                                                                                                                                                  
								WHERE 1=1                                                                                                                                                                                       
					) A                                                                                                                                                                                                         
					GROUP BY FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE                                                                                                                                                            
				) B                                                                                                                                                                                                             
				ON 1=1                                                                                                                                                                                                          
				AND A.FACTORY_ID = B.FACTORY_ID                                                                                                                                                                                 
				AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE                                                                                                                                                                         
				AND A.ATTR_TYPE = B.ATTR_TYPE                                                                                                                                                                                   
		WHERE 1=1                                                                                                                                                                                                               
		
END	-- TEMP LANE
  
  	





	


  SET @v_dSql = '' 
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
  SET @v_dSql += '				AND 	PW.FACTORY_ID IN (SELECT FACTORY_ID FROM SCM_FACTORY_M WHERE SITE_ID = '''+ @p_inner_site_id +'''  AND SHOP_GROUP_ID = ''E'')'+ char(10)
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
  SET @v_dSql += '						, ATTRIBUTE4 AS GRAPH_WH_GROUP_NAME'+ char(10)
  SET @v_dSql += '				FROM 	SCM_SYS_LOOKUP_VALUE	LV'+ char(10)
  SET @v_dSql += '						INNER JOIN FP_INSTANCE_INFO_V FII'+ char(10)
  SET @v_dSql += '						ON 	1=1'+ char(10)
  SET @v_dSql += '						AND	LV.SEGMENT1 = FII.INSTANCE_ID'+ char(10)
  SET @v_dSql += '				WHERE 	1=1'+ char(10)
  SET @v_dSql += '				AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT'' AND LV.ACTIVE_FLAG=''Y'''+ char(10)
  SET @v_dSql += '			)'+ char(10)
 
  --SET @v_dSql += '			, DEFAULT_M_PER_ROLL AS																													'+ char(10)
  --SET @v_dSql += '			(																																		'+ char(10)
  --SET @v_dSql += '				SELECT FACTORY_ID, ELECTRODE_TYPE, ISNULL([-],0) AS JR_COL, ISNULL([A],0) AS A_TYPE_COL, ISNULL([B],0) AS B_TYPE_COL	            '+ char(10)                                                
  --SET @v_dSql += '				FROM(																													            '+ char(10)                                                
  --SET @v_dSql += '						SELECT	SEGMENT2 AS FACTORY_ID, 																					        '+ char(10)                                                
  --SET @v_dSql += '								CASE WHEN SEGMENT3 = ''A'' THEN ''ANODE''																	        '+ char(10)                                                
  --SET @v_dSql += '									WHEN SEGMENT3 = ''C'' THEN ''CATHODE'' 																            '+ char(10)                                            
  --SET @v_dSql += '									ELSE SEGMENT3 END AS ELECTRODE_TYPE    																			'+ char(10)
  --SET @v_dSql += '								, SEGMENT4 AS ATTR_TYPE, ATTRIBUTE1 AS ROLL_QTY                                                                     '+ char(10) 
  --SET @v_dSql += '						FROM	SCM_SYS_LOOKUP_VALUE A                                                                     					        '+ char(10)                                                
  --SET @v_dSql += '						WHERE	A.LOOKUP_TYPE_CODE = ''E_POST_JR_DEFAULT_DEFINIT''                                              			        '+ char(10)                                                
  --SET @v_dSql += '						AND		A.SEGMENT1 = ''PL_E_POST''                                                                   				        '+ char(10)                                                
  --SET @v_dSql += '						AND		A.ACTIVE_FLAG = ''Y''              																			        '+ char(10)                                                
  --SET @v_dSql += '				) AS RESULT																												            '+ char(10)                                            
  --SET @v_dSql += '				PIVOT (																													            '+ char(10)                                            
  --SET @v_dSql += '						MAX(ROLL_QTY) FOR ATTR_TYPE IN ([-], [A], [B])																		        '+ char(10)                                            
  --SET @v_dSql += '				) AS PIV                                                                                                                            '+ char(10)                                            
  --SET @v_dSql += '																																					'+ char(10)
  --SET @v_dSql += '			)																																		'+ char(10)
  SET @v_dSql += '			, WH_CAPA_TOTAL AS ('+ char(10)
  SET @v_dSql += '				SELECT WCG.*																									'+ char(10)
  SET @v_dSql += '						, ROUND(CONVERT(FLOAT, WCG.WH_CAPA * MR.M_PER_ROLL ) / '+@p_unit_digit+', '+ @p_round_point +')	AS WH_CAPA_M										'+ char(10)
  SET @v_dSql += '						, ROUND(CONVERT(FLOAT, WCG.TEMP_CAPA * MR.M_PER_ROLL ) / '+@p_unit_digit+', '+ @p_round_point +')	AS WH_TEMP_M										'+ char(10)
  SET @v_dSql += '						, ROUND(CONVERT(FLOAT, WCG.TOTAL_WH_CAPA * MR.M_PER_ROLL )  / '+@p_unit_digit+', '+ @p_round_point +')	AS TOTAL_CAPA_M										'+ char(10)
  SET @v_dSql += '				FROM (																											'+ char(10)
  SET @v_dSql += '						SELECT 	  WCG.WH_GROUP_NAME'+ char(10)
  SET @v_dSql += '								, WCG.GRAPH_WH_GROUP_NAME'+ char(10)
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
  SET @v_dSql += '								, CONVERT(INTEGER, ISNULL(WCG.TEMP_CAPA,0)) AS TEMP_CAPA'+ char(10)
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
  SET @v_dSql += '								, WCG.GRAPH_WH_GROUP_NAME'+ char(10)
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
  SET @v_dSql += '					) WCG											'+ char(10)
  SET @v_dSql += '					LEFT  OUTER HASH JOIN 	#DEFAULT_M_PER_ROLL MR	'+ char(10)
  SET @v_dSql += '					ON 	1=1											'+ char(10)
  SET @v_dSql += '					AND 	WCG.FACTORY_ID = MR.FACTORY_ID			'+ char(10)
  SET @v_dSql += '					AND 	WCG.ELECTRODE_TYPE = MR.ELECTRODE_TYPE	'+ char(10)
  SET @v_dSql += '					AND 	WCG.ATTR_TYPE = MR.ATTR_TYPE	'+ char(10)
  SET @v_dSql += '					AND 	WCG.ROLL_TYPE = MR.ROLL_TYPE	'+ char(10)
  SET @v_dSql += '					WHERE 1=1										'+ char(10)
  SET @v_dSql += '			)'+ char(10)
	
  -- DEFAULT_M_PER_ROLL 사용 쿼리
  /*
  SET @v_dSql += '			, WH_CAPA_TOTAL AS ('+ char(10)
  SET @v_dSql += '				SELECT WCG.*																									'+ char(10)
  SET @v_dSql += '						, CASE WHEN WCG.ROLL_TYPE = ''J'' THEN WCG.WH_CAPA * MR.JR_COL / '+@p_unit_digit+'											'+ char(10)
  SET @v_dSql += '										WHEN WCG.ROLL_TYPE = ''P'' AND WCG.ATTR_TYPE = ''A'' THEN WCG.WH_CAPA * MR.A_TYPE_COL / '+@p_unit_digit+'		'+ char(10)
  SET @v_dSql += '										WHEN WCG.ROLL_TYPE = ''P'' AND WCG.ATTR_TYPE = ''B'' THEN WCG.WH_CAPA * MR.B_TYPE_COL / '+@p_unit_digit+'		'+ char(10)
  SET @v_dSql += '										ELSE 0 END AS WH_CAPA_M 																'+ char(10)
  SET @v_dSql += '						,CASE WHEN WCG.ROLL_TYPE = ''J'' THEN WCG.TEMP_CAPA * MR.JR_COL / '+@p_unit_digit+'											'+ char(10)
  SET @v_dSql += '										WHEN WCG.ROLL_TYPE = ''P'' AND WCG.ATTR_TYPE = ''A'' THEN WCG.TEMP_CAPA * MR.A_TYPE_COL / '+@p_unit_digit+'		'+ char(10)
  SET @v_dSql += '										WHEN WCG.ROLL_TYPE = ''P'' AND WCG.ATTR_TYPE = ''B'' THEN WCG.TEMP_CAPA * MR.B_TYPE_COL / '+@p_unit_digit+'		'+ char(10)
  SET @v_dSql += '										ELSE 0 END AS TEMP_CAPA_M																'+ char(10)
  SET @v_dSql += '						,CASE WHEN WCG.ROLL_TYPE = ''J'' THEN WCG.TOTAL_WH_CAPA * MR.JR_COL / '+@p_unit_digit+'										'+ char(10)
  SET @v_dSql += '										WHEN WCG.ROLL_TYPE = ''P'' AND WCG.ATTR_TYPE = ''A'' THEN WCG.TOTAL_WH_CAPA * MR.A_TYPE_COL / '+@p_unit_digit+'	'+ char(10)
  SET @v_dSql += '										WHEN WCG.ROLL_TYPE = ''P'' AND WCG.ATTR_TYPE = ''B'' THEN WCG.TOTAL_WH_CAPA * MR.B_TYPE_COL / '+@p_unit_digit+'	'+ char(10)
  SET @v_dSql += '									ELSE 0 END AS TOTAL_CAPA_M																	'+ char(10)
  SET @v_dSql += '				FROM (																											'+ char(10)
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
  SET @v_dSql += '								, CONVERT(INTEGER, ISNULL(WCG.TEMP_CAPA,0)) AS TEMP_CAPA'+ char(10)
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
  SET @v_dSql += '					) WCG											'+ char(10)
  SET @v_dSql += '					LEFT  OUTER HASH JOIN 	DEFAULT_M_PER_ROLL MR	'+ char(10)
  SET @v_dSql += '					ON 	1=1											'+ char(10)
  SET @v_dSql += '					AND 	WCG.FACTORY_ID = MR.FACTORY_ID			'+ char(10)
  SET @v_dSql += '					AND 	WCG.ELECTRODE_TYPE = MR.ELECTRODE_TYPE	'+ char(10)
  SET @v_dSql += '					WHERE 1=1										'+ char(10)
  SET @v_dSql += '			)'+ char(10)
*/	

  SET @v_dSql += '	, STOCK AS'+ char(10)
  SET @v_dSql += '				('+ char(10)
  SET @v_dSql += '				SELECT 	DISTINCT ST.ITEM_ID, IT.NICK_NAME, ISNULL(MP.ELEC_FACTORY_ID, ST.FACTORY_ID)  AS FACTORY_ID'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.WIPHOLD_YN IN (''Y'', ''N'') THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS TOTAL_QTY '+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''A%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS ASSY_PC'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E2000'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_RP_JR'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID <= ''E4000'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_ST_JR'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID > ''E4000''  THEN ST.FP_APPLY_WIPQTY'+ char(10)
  SET @v_dSql += '									   WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E4000'' AND OPERATION_ID > ''E4000'' THEN ST.FP_APPLY_WIPQTY'+ char(10)
  SET @v_dSql += '									   ELSE 0 END) AS POST_ST_PC'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.WIPHOLD_YN IN (''Y'', ''N'') THEN ST.LOT_COUNT ELSE 0 END) AS TOTAL_LOT_COUNT'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''A%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') THEN ST.LOT_COUNT  ELSE 0 END) AS ASSY_PC_R'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E2000'' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_R'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID <= ''E4000'' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_R'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID > ''E4000''  THEN ST.LOT_COUNT'+ char(10)
  SET @v_dSql += '									   WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN IN (''Y'', ''N'') AND FP_APPLY_OPERATION_ID = ''E4000'' AND OPERATION_ID > ''E4000'' THEN ST.LOT_COUNT'+ char(10)
  SET @v_dSql += '									   ELSE 0 END) AS POST_ST_PC_R'+ char(10)
  
  SET @v_dSql += '							, SUM(CASE WHEN ST.WIPHOLD_YN = ''Y'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS TOTAL_QTY_HOLD '+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''A%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS ASSY_PC_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E2000'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_RP_JR_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID <= ''E4000'' THEN ST.FP_APPLY_WIPQTY ELSE 0 END) AS PRE_ST_JR_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID > ''E4000''  THEN ST.FP_APPLY_WIPQTY'+ char(10)
  SET @v_dSql += '									   WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E4000'' AND OPERATION_ID > ''E4000'' THEN ST.FP_APPLY_WIPQTY'+ char(10)
  SET @v_dSql += '									   ELSE 0 END) AS POST_ST_PC_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.WIPHOLD_YN = ''Y'' THEN ST.LOT_COUNT ELSE 0 END) AS TOTAL_LOT_COUNT_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''A%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' THEN ST.LOT_COUNT  ELSE 0 END) AS ASSY_PC_R_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E2000'' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_RP_JR_R_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID <= ''E4000'' THEN ST.LOT_COUNT ELSE 0 END) AS PRE_ST_JR_R_HOLD'+ char(10)
  SET @v_dSql += '							, SUM(CASE WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E3000'' AND OPERATION_ID > ''E4000''  THEN ST.LOT_COUNT'+ char(10)
  SET @v_dSql += '									   WHEN ST.FACTORY_ID LIKE ''E%'' AND ST.ELEC_POST_HOLD_YN = ''Y'' AND FP_APPLY_OPERATION_ID = ''E4000'' AND OPERATION_ID > ''E4000'' THEN ST.LOT_COUNT'+ char(10)
  SET @v_dSql += '									   ELSE 0 END) AS POST_ST_PC_R_HOLD'+ char(10)
  
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
  SET @v_dSql += '				AND 		ST.SITE_ID = '''+ @p_inner_site_id +''' '+ char(10)
  SET @v_dSql += '				AND 		ST.ITEM_ID LIKE ''APC%'''+ char(10)
  SET @v_dSql += '				AND 		ST.STOCK_TYPE = ''WIP'''+ char(10)
  SET @v_dSql += '				AND 		IT.ACTIVE_FLAG = ''Y'''+ char(10)
  -- TOTAL 은 hold 포함하여 산출하도록 변경함 by cys 20220519
  --SET @v_dSql += '				AND			ST.WIPHOLD_YN = ''N'''+ char(10)
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
  
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.TOTAL_QTY_HOLD ELSE A.TOTAL_QTY_HOLD / ISNULL(B.LANE_QTY, 1) END AS TOTAL_QTY_HOLD'+ char(10)
  SET @v_dSql += '							, A.TOTAL_LOT_COUNT_HOLD'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.JR_QTY_HOLD ELSE A.JR_QTY_HOLD / ISNULL(B.LANE_QTY, 1) END AS JR_QTY_HOLD'+ char(10)
  SET @v_dSql += '							, A.JR_QTY_LOT_COUNT_HOLD'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.ASSY_PC_HOLD ELSE A.ASSY_PC_HOLD / ISNULL(B.LANE_QTY, 1) END AS ASSY_PC_HOLD'+ char(10)
  SET @v_dSql += '							, A.ASSY_PC_R_HOLD AS ASSY_PC_R_HOLD'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.PRE_RP_JR_HOLD ELSE A.PRE_RP_JR_HOLD / ISNULL(B.LANE_QTY, 1) END AS PRE_RP_JR_HOLD'+ char(10)
  SET @v_dSql += '							, A.PRE_RP_JR_R_HOLD AS PRE_RP_JR_R_HOLD'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.PRE_ST_JR_HOLD ELSE A.PRE_ST_JR_HOLD / ISNULL(B.LANE_QTY, 1) END AS PRE_ST_JR_HOLD'+ char(10)
  SET @v_dSql += '							, A.PRE_ST_JR_R_HOLD AS PRE_ST_JR_R_HOLD'+ char(10)
  SET @v_dSql += '							, CASE WHEN ''JR'' = ''PC'' THEN A.POST_ST_PC_HOLD ELSE A.POST_ST_PC_HOLD / ISNULL(B.LANE_QTY, 1) END AS POST_ST_PC_HOLD'+ char(10)
  SET @v_dSql += '							, A.POST_ST_PC_R_HOLD AS POST_ST_PC_R_HOLD'+ char(10)
 

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

  SET @v_dSql += '											, SUM(TOTAL_QTY_HOLD) AS TOTAL_QTY_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(TOTAL_LOT_COUNT_HOLD) AS TOTAL_LOT_COUNT_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR_HOLD)  AS JR_QTY_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR_R_HOLD)  AS JR_QTY_LOT_COUNT_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(ASSY_PC_HOLD) AS ASSY_PC_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(ASSY_PC_R_HOLD) AS ASSY_PC_R_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR_HOLD) AS PRE_RP_JR_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(PRE_RP_JR_R_HOLD) AS PRE_RP_JR_R_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(PRE_ST_JR_HOLD) AS PRE_ST_JR_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(PRE_ST_JR_R_HOLD) AS PRE_ST_JR_R_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(POST_ST_PC_HOLD) AS POST_ST_PC_HOLD'+ char(10)
  SET @v_dSql += '											, SUM(POST_ST_PC_R_HOLD) AS POST_ST_PC_R_HOLD'+ char(10)

  SET @v_dSql += '								FROM 	STOCK A'+ char(10)
  SET @v_dSql += '											LEFT OUTER JOIN ATTR_TYPE B'+ char(10)
  SET @v_dSql += '											ON 	1=1'+ char(10)
  SET @v_dSql += '											AND 	A.NICK_NAME LIKE B.ATTR_DEFINIT'+ char(10)
  SET @v_dSql += '								GROUP BY A.FACTORY_ID, ITEM_ID, NICK_NAME, B.ATTR_DEFINIT'+ char(10)
  SET @v_dSql += '							) A'+ char(10)
  SET @v_dSql += '							LEFT OUTER JOIN #LANE_T B'+ char(10)
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
  SET @v_dSql += '						, SUM(A.IN_QTY) AS IN_QTY'+ char(10)
  SET @v_dSql += '				FROM	('+ char(10)
  SET @v_dSql += '							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '									, A.ITEM_ID, NULL AS NP_ITEM_ID , E.NICK_NAME, E.FLOW_ID'+ char(10)
  SET @v_dSql += '									, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN ''ANODE'''+ char(10)
  SET @v_dSql += '										   WHEN A.ELECTRODE_TYPE = ''C'' THEN ''CATHODE'''+ char(10)
  SET @v_dSql += '										   ELSE A.ELECTRODE_TYPE END ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '									, ''MASS''  AS PRODUCTION_TYPE'+ char(10)
  --MOVING PLAN data 가 ed 에서 넘어오면 A type 아이템으로 넘어와 문제가 있어 하드코딩 함
  SET @v_dSql += '						            , CASE WHEN A.FACTORY_ID = ''EB'' THEN ''B'' ELSE ( CASE WHEN B.ATTR_DEFINIT IS NULL THEN ''B'' ELSE ''A'' END ) END AS ATTR_TYPE                        ' + char(10)
  SET @v_dSql += '									, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '									, A.CATEGORY_ID, A.CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '									, CASE WHEN ''JR'' = ''JR'' THEN A.OUT_JR_QTY ELSE A.OUT_PC_QTY END AS QTY'+ char(10)
  SET @v_dSql += '									, CASE WHEN ''JR'' = ''JR'' THEN A.IN_JR_QTY ELSE A.IN_PC_QTY END AS IN_QTY'+ char(10)
  SET @v_dSql += '							FROM	('+ char(10)
  SET @v_dSql += '										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '												, A.ITEM_ID, A.NP_ITEM_ID'+ char(10)
  SET @v_dSql += '												, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE'+ char(10)
  SET @v_dSql += '												, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+ char(10)
  SET @v_dSql += '												, SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) AS CATEGORY_ID'+ char(10)
  SET @v_dSql += '												, SUBSTRING(A.CATEGORY,0,2) AS CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)    ' + char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.OUT_JR_QTY,0) END AS OUT_JR_QTY'+ char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)    ' + char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.OUT_PC_QTY,0) END AS OUT_PC_QTY'+ char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)    ' + char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.IN_JR_QTY,0) END AS IN_JR_QTY'+ char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)    ' + char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.IN_PC_QTY,0) END AS IN_PC_QTY'+ char(10)
  SET @v_dSql += '										FROM   FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)'+ char(10)
  SET @v_dSql += '										WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''	'+ char(10)
  SET @v_dSql += '										AND    A.FP_PLAN_ID  = ''' + @P_PLAN_ID +''''+ char(10)
  SET @v_dSql += '										AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+@p_bucket_from+''') AND CONVERT(DATETIME,'''+@p_bucket_to+''')'+ char(10)
  SET @v_dSql += '							            UNION ALL                                                                                                                                                                                               ' + char(10)
  SET @v_dSql += '							            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ATTB_4 AS FACTORY_ID                                                                                                                                 ' + char(10)
  SET @v_dSql += '							            		, A.ITEM_ID, A.NP_ITEM_ID                                                                                                                                                                       ' + char(10)
  SET @v_dSql += '							            		, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE                                                                                                                                              ' + char(10)
  SET @v_dSql += '							            		, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                                                                                                                                                 ' + char(10)
  SET @v_dSql += '							            		, SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) AS CATEGORY_ID                                                                                                           ' + char(10)
  SET @v_dSql += '							            		, SUBSTRING(A.CATEGORY,0,2) AS CATEGORY_GROUP                                                                                                                                                   ' + char(10)
  SET @v_dSql += '							            		, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)                                                                      ' + char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)                                                                  ' + char(10)
  SET @v_dSql += '							            			   ELSE ROUND(A.OUT_JR_QTY,0) END AS OUT_JR_QTY                                                                                                                                             ' + char(10)
  SET @v_dSql += '							            		, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)                                                                      ' + char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)                                                                  ' + char(10)
  SET @v_dSql += '							            			   ELSE ROUND(A.OUT_PC_QTY,0) END AS OUT_PC_QTY                                                                                                                                             ' + char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_JR_QTY,0)    ' + char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_JR_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.IN_JR_QTY,0) END AS IN_JR_QTY'+ char(10)
  SET @v_dSql += '												, CASE WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''NOTCHING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '							            			   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''MOVING_PLAN'' THEN ROUND(A.IN_PC_QTY,0)    ' + char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''INTRANSIT'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   WHEN SUBSTRING(REPLACE(UPPER(A.CATEGORY),'' '', ''_''),4,LEN(A.CATEGORY)) = ''SHIPMENT_PLAN'' THEN ROUND(A.IN_PC_QTY,0)'+ char(10)
  SET @v_dSql += '													   ELSE ROUND(A.IN_PC_QTY,0) END AS IN_PC_QTY'+ char(10)
  SET @v_dSql += '							            FROM   FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)                                                                                                                                                          ' + char(10)
  SET @v_dSql += '							            WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
  SET @v_dSql += '							            AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
  SET @v_dSql += '							            AND    A.CATEGORY  = ''12-Moving Plan''                                                                                                                                                           ' + char(10)
  SET @v_dSql += '							            AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
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
  SET @v_dSql += '						INNER JOIN (																								' + char(10)
  SET @v_dSql += '							SELECT DISTINCT A.COMPANY_ID, A.SITE_ID, A.PLANT_ID,  A.ITEM_ID				' + char(10)
  SET @v_dSql += '							FROM SCM_ITEM_LANE_M A WITH(NOLOCK)															' + char(10)
  SET @v_dSql += '							WHERE 1=1																					' + char(10)
  SET @v_dSql += '							AND A.SITE_ID = '''+ @p_inner_site_id +'''																		' + char(10)
  SET @v_dSql += '							AND A.ACTIVE_FLAG = ''Y''																		' + char(10)
  SET @v_dSql += '							AND A.PROD_VERSION_TYPE = ''E3000E4000''																		' + char(10)
  SET @v_dSql += '						) C																								' + char(10)
  SET @v_dSql += '						ON 1=1																							' + char(10)
  SET @v_dSql += '						AND A.SITE_ID = C.SITE_ID																		' + char(10)
  SET @v_dSql += '						AND A.PLANT_ID = C.PLANT_ID																		' + char(10)
  -- ED 동 데이타가 누락되어 임시로 막음
  SET @v_dSql += '						--AND A.FACTORY_ID = C.FACTORY_ID																	' + char(10)
  SET @v_dSql += '						AND A.ITEM_ID = C.ITEM_ID																		' + char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '				WHERE	1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+ char(10)
  SET @v_dSql += '						, A.ITEM_ID, A.NP_ITEM_ID, A.NICK_NAME , A.FLOW_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '						, A.CATEGORY_ID, A.CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '	)'+ char(10)



  SET @v_dSql += '	, MAIN_I AS ('+ char(10)
  SET @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.FLOW_ID, A.NP_ITEM_ID                                        ' + char(10)
  SET @v_dSql += '		     , A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.LEVEL_3_NAME                                                              ' + char(10)
  SET @v_dSql += '			   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.CATEGORY_GROUP                                      ' + char(10)
  SET @v_dSql += '		       , A.PSI               ' + char(10)
  SET @v_dSql += '		       , A.DATA_TYPE                                     ' + char(10)

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
				  
				  SET @v_dSql += '			, CASE WHEN A.CATEGORY_ID = ''EOH_ELEC_QTY'' AND D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + ' < 0 THEN 0 ' +  char(10)
   				  SET @v_dSql += '				   WHEN A.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) + ' < 0 THEN 0 ELSE D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  ' END AS D'+ TRY_CONVERT(NVARCHAR,(@mst_loop_cnt-1)) +  char(10)
			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  SET @v_dSql += '		FROM (                                    ' + char(10)

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
					
					IF ''+ @sub_param_0 +'' <= '' + @p_plan_date + '' BEGIN
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A ' + char(10)
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B ' + char(10)
					END ELSE BEGIN
						-- 누적값으로 계산되어 더블 누적으로 계산
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A + EOH_ASSY_QTY2 ' + char(10)
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B + EOH_ASSY_QTY2 ' + char(10)
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A + (CASE WHEN EOH_ASSY_QTY > 0 THEN 0 ELSE EOH_ASSY_QTY END)  ' + char(10)
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B + (CASE WHEN EOH_ASSY_QTY > 0 THEN 0 ELSE EOH_ASSY_QTY END) ' + char(10)
					END

				  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A + EOH_ASSY_QTY2 ' + char(10)
				  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B + EOH_ASSY_QTY2 ' + char(10)

				  SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_JR_QTY_A_HOLD'+ char(10)
				  SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_JR_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_JR_QTY_B_HOLD'+ char(10)
				  SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_PC_QTY_A_HOLD'+ char(10)
				  SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+@sub_param_0+''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @P_PLAN_DATE +''' AND B.CATEGORY_ID = ''EOH_PC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_PC_QTY_B_HOLD'+ char(10)
				  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A_HOLD + EOH_ASSY_QTY2_HOLD ' + char(10)
				  --SET @v_dSql += '					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B_HOLD + EOH_ASSY_QTY2_HOLD ' + char(10)
					IF ''+ @sub_param_0 +'' <= '' + @p_plan_date + '' BEGIN
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A_HOLD ' + char(10)
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B_HOLD ' + char(10)
					END ELSE BEGIN
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A_HOLD + EOH_ASSY_QTY2_HOLD ' + char(10)
						--SELECT @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B_HOLD + EOH_ASSY_QTY2_HOLD ' + char(10)
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000E4000'' THEN A.EOH_ELEC_QTY_A_HOLD + (CASE WHEN EOH_ASSY_QTY_HOLD > 0 THEN 0 ELSE EOH_ASSY_QTY_HOLD END)  ' + char(10)
						SET @v_dSql += N'					   WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' AND B.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' AND A.FLOW_ID = ''E2000E3000'' THEN A.EOH_ELEC_QTY_B_HOLD + (CASE WHEN EOH_ASSY_QTY_HOLD > 0 THEN 0 ELSE EOH_ASSY_QTY_HOLD END) ' + char(10)
					END

  SET @v_dSql += '					   ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  SET @v_dSql += '	  FROM   (                                                         ' + char(10)
  SET @v_dSql += '					SELECT	A.*                       ' + char(10)
  SET @v_dSql += '							, (CASE WHEN SUM(EOH_ASSY_QTY) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) > 0 THEN 0                        ' + char(10)
  SET @v_dSql += '									ELSE SUM(EOH_ASSY_QTY) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) END ) AS EOH_ASSY_QTY2                       ' + char(10)
  SET @v_dSql += '							, (CASE WHEN SUM(EOH_ASSY_QTY_HOLD) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) > 0 THEN 0                        ' + char(10)
  SET @v_dSql += '									ELSE SUM(EOH_ASSY_QTY_HOLD) OVER ( PARTITION BY A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.PLAN_DATE) END ) AS EOH_ASSY_QTY2_HOLD                       ' + char(10)	 
  SET @v_dSql += '		  FROM   ('+ char(10)
  SET @v_dSql += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(D.PRE_ST_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) END AS EOH_JR_QTY_A     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_QTY_B     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_PRE_QTY     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_ST_JR,0) - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_POST_QTY     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)  - ISNULL(MOVING_PLAN,0)) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_A	' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) +ISNULL(D.ASSY_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_B	' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.ASSY_PC,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ' + char(10)
  SET @v_dSql += '								WHEN A.PLAN_DATE < CONVERT(DATE, '''+ @p_plan_date +''') THEN 0 ELSE (0 - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_ASSY_QTY' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_A	' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) END AS EOH_ELEC_QTY_B	' + char(10)
  
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(D.PRE_ST_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(SLITTING_PLAN,0)) END AS EOH_JR_QTY_A_HOLD     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_QTY_B_HOLD     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_RP_JR_HOLD,0) + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 + ISNULL(COATING_PLAN,0) - ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_PRE_QTY_HOLD     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.PRE_ST_JR_HOLD,0) - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) ELSE (0 - ISNULL(SLITTING_PLAN,0) + ISNULL(ROLL_PRESS_PLAN,0)) END AS EOH_JR_POST_QTY_HOLD     ' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_A_HOLD	' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) +ISNULL(D.ASSY_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_PC_QTY_B_HOLD	' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.ASSY_PC_HOLD,0) - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0) ) ' + char(10)
  SET @v_dSql += '								WHEN A.PLAN_DATE < CONVERT(DATE, '''+ @p_plan_date +''') THEN 0 ELSE (0 - ISNULL(NOTCHING_PLAN,0) + ISNULL(INTRANSIT,0) - ISNULL(SHIPMENT_PLAN,0)) END AS EOH_ASSY_QTY_HOLD' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(SLITTING_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_A_HOLD	' + char(10)
  SET @v_dSql += '						,  CASE WHEN A.PLAN_DATE = CONVERT(DATE, '''+ @p_plan_date +''') THEN (ISNULL(D.POST_ST_PC_HOLD,0) + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0) ) ELSE (0 + ISNULL(ROLL_PRESS_PLAN,0) - ISNULL(MOVING_PLAN,0)) END AS EOH_ELEC_QTY_B_HOLD	' + char(10)

  SET @v_dSql += '					FROM	('+ char(10)
  SET @v_dSql += '								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '										, SUM(NOTCHING_PLAN) AS NOTCHING_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(COATING_PLAN) AS COATING_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(INTRANSIT) AS INTRANSIT'+ char(10)
  SET @v_dSql += '										, SUM(SHIPMENT_PLAN) AS SHIPMENT_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(SLITTING_PLAN) AS SLITTING_PLAN'+ char(10)
  SET @v_dSql += '										, SUM(ROLL_PRESS_PLAN) AS ROLL_PRESS_PLAN'+ char(10)
  --	case 1) EB -> ED 동으로 가는 Moving plan
  --  EB동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// ED동에서 moving plan(in) 만큼 EOH(P/C)에 더함
  --case2) ED -> EB동으로 가는 moving plan
  --  ED동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// EB동에서 moving plan(in) 만큼 EOH(P/C)에 차감하지 않음, 전극 창고를 통하지 않고 즉시 ass(P/C)로 입고됨
  --Case1은 coating – R/P – S/L (EB)  -> Rewinder(ED ) -> 조립 이동
  --case2는 coating – R/P – S/L – Rewinder(EB) -> 조립 이동
  SET @v_dSql += '										, SUM( CASE WHEN ISNULL(B.MOVING_FACTORY,'''') = '''' AND A.FACTORY_ID = ''EB'' THEN 0 WHEN ISNULL(B.MOVING_FACTORY,'''') = '''' THEN MOVING_PLAN * -1 ELSE MOVING_PLAN END) AS MOVING_PLAN    ' + char(10)
  SET @v_dSql += '								FROM	('+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.PLAN_DATE'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''NOTCHING_PLAN'' THEN A.QTY ELSE 0 END AS NOTCHING_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''COATING_PLAN'' THEN A.QTY ELSE 0 END AS COATING_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''INTRANSIT'' THEN A.QTY ELSE 0 END AS INTRANSIT'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''SHIPMENT_PLAN'' THEN A.QTY ELSE 0 END AS SHIPMENT_PLAN'+ char(10)
  --SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''SLITTING_PLAN'' THEN A.QTY ELSE 0 END AS SLITTING_PLAN'+ char(10)
  --SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''ROLL_PRESS_PLAN'' THEN A.QTY ELSE 0 END AS ROLL_PRESS_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''SLITTING_PLAN'' THEN A.IN_QTY ELSE 0 END AS SLITTING_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''ROLL_PRESS_PLAN'' THEN A.IN_QTY ELSE 0 END AS ROLL_PRESS_PLAN'+ char(10)
  SET @v_dSql += '													, CASE WHEN CATEGORY_ID = ''MOVING_PLAN'' THEN A.QTY ELSE 0 END AS MOVING_PLAN               ' + char(10)
  SET @v_dSql += '											FROM	('+ char(10)
  SET @v_dSql += '														SELECT *'+ char(10)
  SET @v_dSql += '														FROM	MAIN_P A'+ char(10)
  SET @v_dSql += '														WHERE	1=1'+ char(10)
  SET @v_dSql += '													) A'+ char(10)
  SET @v_dSql += '											WHERE	1=1'+ char(10)
  SET @v_dSql += '											UNION ALL																																													' + char(10)
  SET @v_dSql += '											SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,  A.FLOW_ID, A.NP_ITEM_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, '''+ @p_plan_date +''' AS PLAN_DATE     ' + char(10)   
  SET @v_dSql += '													, 0 AS NOTCHING_PLAN                   																																				' + char(10)
  SET @v_dSql += '													, 0 AS COATING_PLAN                     																																			' + char(10)
  SET @v_dSql += '													, 0 AS INTRANSIT                           																																			' + char(10)
  SET @v_dSql += '													, 0 AS SHIPMENT_PLAN                   																																				' + char(10)
  SET @v_dSql += '													, 0 AS SLITTING_PLAN                   																																				' + char(10)
  SET @v_dSql += '													, 0 AS ROLL_PRESS_PLAN               																																				' + char(10)
  SET @v_dSql += '													, 0 AS MOVING_PLAN               																																				' + char(10)
  SET @v_dSql += '											FROM	(                                                                                                    																				' + char(10)
  SET @v_dSql += '														SELECT *                                                                                             																			' + char(10)
  SET @v_dSql += '														FROM	MAIN_P A                                                                                       																			' + char(10)
  SET @v_dSql += '														WHERE	1=1                                                                                            																			' + char(10)
  SET @v_dSql += '													) A                                                                                                    																				' + char(10)
  SET @v_dSql += '											WHERE	1=1  																																												' + char(10)
		
  SET @v_dSql += '										) A'+ char(10)
  SET @v_dSql += '										LEFT OUTER JOIN (																			 ' + char(10)
  SET @v_dSql += '												SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, CASE WHEN A.ELECTRODE_TYPE = ''A'' THEN  ''ANODE'' ELSE ''CATHODE'' END AS ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.ATTR_TYPE, A.ATTB_4 AS MOVING_FACTORY	   ' + char(10)
  SET @v_dSql += '												FROM FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)																															   ' + char(10)
  SET @v_dSql += '												WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                       ' + char(10)
  SET @v_dSql += '												AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                                                                                                                                           ' + char(10)
  SET @v_dSql += '												AND    A.CATEGORY  = ''12-Moving Plan''                                                                                                                                                           ' + char(10)
  SET @v_dSql += '												AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_bucket_from +''') AND CONVERT(DATETIME,'''+ @p_bucket_to +''')                                                                                  ' + char(10)
  SET @v_dSql += '										) B																																												   ' + char(10)
  SET @v_dSql += '										ON 1=1																																											   ' + char(10)
  SET @v_dSql += '										AND		A.FACTORY_ID		= B.FACTORY_ID                                                                                                  									   ' + char(10)
  SET @v_dSql += '										AND		A.ITEM_ID			= B.ITEM_ID                                                                                                 										   ' + char(10)
  SET @v_dSql += '										AND		A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE                                                                                                     								   ' + char(10)
  SET @v_dSql += '										--AND		A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE                                                                                                    							   ' + char(10)
  SET @v_dSql += '										AND		A.ATTR_TYPE			= B.ATTR_TYPE     																																	   ' + char(10)
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
  SET @v_dSql += '				WHERE	1=1                                                                                                    ' + char(10)
  SET @v_dSql += '				) A                                                                                                                ' + char(10)
  SET @v_dSql += '				      INNER JOIN ('+ char(10)
  SET @v_dSql += '							      	SELECT *'+ char(10)
  SET @v_dSql += '							      	FROM ('+ char(10)
  SET @v_dSql += '							      			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER, '''' AS CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '	 										UNION ALL'+ char(10)
  SET @v_dSql += '	 										SELECT ''EOH_JR_QTY'' AS CATEGORY_ID, ''EOH(J/R)'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER, ''70'' AS CATEGORY_GROUP'+ char(10)
  SET @v_dSql += '	 										UNION ALL'+ char(10)
  --SET @v_dSql += '											SELECT ''EOH_PC_QTY'' AS CATEGORY_ID, ''EOH(P/C)'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER, ''100'' AS CATEGORY_GROUP'+ char(10)
  --SET @v_dSql += '	 						                UNION ALL                                                                                                  ' + char(10)
  SET @v_dSql += '							                SELECT ''EOH_ELEC_QTY'' AS CATEGORY_ID, ''Elec EOH(P/C)'' AS CATEGORY_NAME, 110 AS CATEGORY_ORDER, ''110'' AS CATEGORY_GROUP       ' + char(10)
  SET @v_dSql += '	 										UNION ALL'+ char(10)
  SET @v_dSql += '							                SELECT ''EOH_ELEC_QTY_HOLD'' AS CATEGORY_ID, ''Elec EOH(P/C) + Hold'' AS CATEGORY_NAME, 120 AS CATEGORY_ORDER, ''120'' AS CATEGORY_GROUP       ' + char(10)
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
  SET @v_dSql += '			) A                                                                                                                             ' + char(10)
  SET @v_dSql += '		WHERE 1=1                                                                                                                            ' + char(10)
  SET @v_dSql += '	)'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += ',MAIN_PLAN AS (	SELECT	A.*'+ char(10)
  SET @v_dSql += '	FROM	('+ char(10)
  SET @v_dSql += '				SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID , A.ELECTRODE_TYPE'+ char(10)
  SET @v_dSql += '						, B.WH_GROUP_NAME AS CATEGORY_NAME	'+ char(10)
  SET @v_dSql += '						, CASE WHEN B.ATTR_TYPE = ''-'' THEN 11'+ char(10)
  SET @v_dSql += '							   WHEN B.ATTR_TYPE = ''A'' THEN 21'+ char(10)
  SET @v_dSql += '							   WHEN B.ATTR_TYPE = ''B'' THEN 31'+ char(10)
  SET @v_dSql += '							   ELSE 41 END   AS CATEGORY_ORDER'+ char(10)
  SET @v_dSql += '						, B.ROLL_TYPE, B.ATTR_TYPE, B.GRAPH_WH_GROUP_NAME AS GRAPH_NAME	'+ char(10)
  
  
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
				
				IF @p_unit = 'R' BEGIN	--Roll
					SET @v_dSql += '							  , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
					SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_ELEC_QTY'' THEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
					SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
					SET @v_dSql += '								    ELSE 0 END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END ELSE BEGIN	-- KM/M
					SET @v_dSql += '							  , SUM( CASE WHEN A.CATEGORY_ID = ''EOH_JR_QTY'' AND B.ATTR_TYPE = ''-'' THEN ROUND(CONVERT(FLOAT, D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ' ) / ' + @p_unit_digit +', '+ @p_round_point +') ' + char(10)
					SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_ELEC_QTY'' THEN ROUND(CONVERT(FLOAT, D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ' ) / ' + @p_unit_digit +', '+ @p_round_point +') ' + char(10)
					SET @v_dSql += '									WHEN B.ATTR_TYPE = A.ATTR_TYPE AND A.CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN ROUND(CONVERT(FLOAT, D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ' ) / ' + @p_unit_digit +', '+ @p_round_point +') ' + char(10)
					SET @v_dSql += '								    ELSE 0 END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
				END

			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

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
				
				IF @p_unit = 'R' BEGIN	--Roll
					--SET @v_dSql += '				, SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+' < 0 THEN 0 ELSE CEILING(D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+' / ISNULL(C.ROLL_QTY,A.ROLL_QTY)) END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)		
					SET @v_dSql += '	    	  , SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' < 0 THEN 0 ELSE (CASE WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / ISNULL(A.LANE_QTY,1) / ISNULL(A.JUMBO_ROLL_LENGTH,1))		' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / ISNULL(A.JUMBO_ROLL_LENGTH,1))							' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / ISNULL(A.PC_ROLL_LENGTH,1))							' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' * ISNULL(A.LANE_QTY,1) / ISNULL(A.PC_ROLL_LENGTH,1))			' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / ISNULL(A.PC_ROLL_LENGTH,1))							' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' * ISNULL(A.LANE_QTY,1) / ISNULL(A.PC_ROLL_LENGTH,1))			' + char(10)
					SET @v_dSql += '	    	  																					   ELSE D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' END ) END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + char(10)
				END ELSE BEGIN	-- KM/M
					--SET @v_dSql += '	    	  , SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' < 0 THEN 0 ELSE (CASE WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / '+@p_unit_digit+' )		' + char(10)
					--SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / '+@p_unit_digit+' )							' + char(10)
					--SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / '+@p_unit_digit+' )							' + char(10)
					--SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' * ISNULL(A.LANE_QTY,1) / '+@p_unit_digit+' )			' + char(10)
					--SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' / '+@p_unit_digit+' )							' + char(10)
					--SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' * ISNULL(A.LANE_QTY,1) / '+@p_unit_digit+' )			' + char(10)
					--SET @v_dSql += '	    	  																					   ELSE D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' END ) END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + char(10)

					SET @v_dSql += '	    	  , SUM( CASE WHEN D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' < 0 THEN 0 ELSE (CASE WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' )		' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_JR_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  +' )							' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  +' )							' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' * ISNULL(A.LANE_QTY,1)  )			' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''PC'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  +' )							' + char(10)
					SET @v_dSql += '	    	  																					   WHEN ''JR'' = ''JR'' AND CATEGORY_ID = ''EOH_ELEC_QTY_HOLD'' THEN CEILING( D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' * ISNULL(A.LANE_QTY,1)  )			' + char(10)
					SET @v_dSql += '	    	  																					   ELSE D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + ' END ) END ) AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + char(10)
						
				END

			--SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''

  SET @v_dSql += '	    				  FROM'+ char(10)
  SET @v_dSql += '	      						('+ char(10)
  SET @v_dSql += '	      			                SELECT	A.* , C.LANE_QTY, C.JUMBO_ROLL_LENGTH, C.PC_ROLL_LENGTH						' + char(10)
  SET @v_dSql += '	      			                FROM	MAIN_I A  												' + char(10)
  SET @v_dSql += '					                		LEFT OUTER HASH JOIN #LANE_T C                                                 ' + char(10)
  SET @v_dSql += '					                		ON 1=1                                                          ' + char(10)
  SET @v_dSql += '					                		AND  C.COMPANY_ID 	= A.COMPANY_ID                              ' + char(10)
  SET @v_dSql += '					                		AND  C.DIVISION_ID 	= A.DIVISION_ID                             ' + char(10)
  SET @v_dSql += '					                		AND  C.SITE_ID 		= A.SITE_ID                                 ' + char(10)
  SET @v_dSql += '					                		AND  C.PLANT_ID 	= A.PLANT_ID                                ' + char(10)
  SET @v_dSql += '					                		AND  C.FACTORY_ID 	= A.FACTORY_ID                              ' + char(10)
  SET @v_dSql += '					                		AND  C.ITEM_ID 		= A.ITEM_ID		' + char(10)
  SET @v_dSql += '	      			                WHERE	1=1														' + char(10)
  SET @v_dSql += '	      			                AND		A.CATEGORY_ID IN (''EOH_JR_QTY'', ''EOH_ELEC_QTY'')												' + char(10)
  SET @v_dSql += '								) A'+ char(10)
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
  SET @v_dSql += '						, B.WH_GROUP_NAME , B.ATTR_TYPE, B.ROLL_TYPE, B.GRAPH_WH_GROUP_NAME	'+ char(10)
  SET @v_dSql += '		) A'+ char(10)

  SET @v_dSql += ')'+ char(10)

  SET @v_dSql += 'SELECT	A.*	'+ char(10)
 
	IF @p_unit = 'R' BEGIN	--Roll
		SET @v_dSql += ', NULL AS M_PER_ROLL '
	END ELSE BEGIN
		SET @v_dSql += ', CASE WHEN ISNULL(MR.M_PER_ROLL,0) > 0 THEN  ROUND(CONVERT(FLOAT, MR.M_PER_ROLL ) / '+@p_unit_digit+', '+ @p_round_point +') ELSE NULL END AS M_PER_ROLL '
	END
 
 SET @v_dSql += 'FROM		(	'+ char(10)
  	
  SET @v_dSql += 'SELECT * FROM (SELECT *,''PLAN'' AS CATE,''DATA'' AS ROW_TYPE FROM MAIN_PLAN) A'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)

--- GRAPH PART START
  SET @v_dSql += 'UNION'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ELECTRODE_TYPE,WH_GROUP_NAME AS  CATEGROY_NAME, T.CATEGORY_ORDER*10 AS CATEGORY_ORDER, ROLL_TYPE, ATTR_TYPE, GRAPH_WH_GROUP_NAME AS GRAPH_NAME	'+ char(10)
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
  SET @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ELECTRODE_TYPE,WH_GROUP_NAME AS  CATEGROY_NAME, T.CATEGORY_ORDER*10 +2 AS CATEGORY_ORDER, ROLL_TYPE, ATTR_TYPE, GRAPH_WH_GROUP_NAME AS GRAPH_NAME	'+ char(10)
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
				
				IF @p_unit = 'R' BEGIN	--Roll
					SET @v_dSql += ',T.WH_CAPA AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)	
				END ELSE BEGIN
					SET @v_dSql += ',T.WH_CAPA_M AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)	
				END
 
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
  SET @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ELECTRODE_TYPE,WH_GROUP_NAME AS  CATEGROY_NAME, T.CATEGORY_ORDER*10 +3 AS CATEGORY_ORDER, ROLL_TYPE, ATTR_TYPE, GRAPH_WH_GROUP_NAME AS GRAPH_NAME  '+ char(10)
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
				
				IF @p_unit = 'R' BEGIN	--Roll
					SET @v_dSql += ',T.TOTAL_WH_CAPA AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)	+ char(10)
				END ELSE BEGIN
					SET @v_dSql += ',T.TOTAL_CAPA_M AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)	
				END
 
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
    END -- end of isnull(@p_bucket,'') <> ''
  SET @v_dSql += ',''Capa+Temp'' AS CATE, ''DATA'' AS ROW_TYPE'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += 'FROM WH_CAPA_TOTAL T'+ char(10)
  SET @v_dSql += 'WHERE 1=1'+ char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('T.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += '		) A	'+ char(10)
  SET @v_dSql += '		LEFT OUTER HASH JOIN #DEFAULT_M_PER_ROLL MR	'+ char(10)
  SET @v_dSql += '		ON 	1=1											'+ char(10)
  SET @v_dSql += '		AND A.FACTORY_ID = MR.FACTORY_ID			'+ char(10)
  SET @v_dSql += '		AND A.ELECTRODE_TYPE = MR.ELECTRODE_TYPE	'+ char(10)
  SET @v_dSql += '		AND A.ATTR_TYPE = MR.ATTR_TYPE	'+ char(10)
  SET @v_dSql += '		AND A.ROLL_TYPE = MR.ROLL_TYPE	'+ char(10)
  SET @v_dSql += 'WHERE 1=1	'+ char(10)

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
