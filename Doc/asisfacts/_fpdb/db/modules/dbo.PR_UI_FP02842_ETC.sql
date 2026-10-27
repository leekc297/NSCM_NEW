



--CREATE 
CREATE 
PROCEDURE [dbo].[PR_UI_FP02842_ETC]
	@p_sys_type			NVARCHAR(MAX),  
	@p_sys_flag			NVARCHAR(MAX),
	@p_sys_gubun		NVARCHAR(MAX),  
	@p_user_id			NVARCHAR(MAX),
	@in_columns			NVARCHAR(MAX),
	@in_row				NVARCHAR(MAX),
	@opt_none			NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP02842_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP02842_ETC                                               **/
/** 설 명         :                                                                           **/
/** Version       :				                                                              **/
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
/** 2022/03/11      LJS			Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP02842_ETC';
	DECLARE @runstart		DATETIME;
	DECLARE @runend			DATETIME;
	DECLARE @v_dSql			NVARCHAR(MAX) ='';
	DECLARE @STRLEN			NVARCHAR(MAX);
	DECLARE @v_Err			NVARCHAR(MAX);
	DECLARE @v_Log			NVARCHAR(MAX); 

	DECLARE @v_delimiter    NVARCHAR(1);
	DECLARE @max_loop_cnt	INTEGER = 0;
	DECLARE @mst_loop_cnt	INTEGER = 0;

	DECLARE @p__save_auth	NVARCHAR(MAX);
	DECLARE @p__non_auth	NVARCHAR(MAX);

	-- filter
	DECLARE @p_instance_id				NVARCHAR(MAX);
	DECLARE @p_plan_date				NVARCHAR(MAX);
	DECLARE @p_plan_id					NVARCHAR(MAX);
	DECLARE @p_release_flag				NVARCHAR(MAX);
	DECLARE @p_division_id 		   	    NVARCHAR(MAX);
	DECLARE @p_site_id 			   	    NVARCHAR(MAX);
	DECLARE @p_plant_id 		   	    NVARCHAR(MAX);
	DECLARE @p_factory_id		   	    NVARCHAR(MAX);
	DECLARE @p_operation_id		   	    NVARCHAR(MAX);
	DECLARE @p_line_id	 		   	    NVARCHAR(MAX);
	DECLARE @p_cell_type				NVARCHAR(MAX);
	DECLARE @p_pancake_type				NVARCHAR(MAX);
	DECLARE @p_model_id					NVARCHAR(MAX);
	DECLARE @p_model_nick_name			NVARCHAR(MAX);
	DECLARE @p_model_nick_name_list		NVARCHAR(MAX);
	DECLARE @p_item_id					NVARCHAR(MAX);
	DECLARE @p_nick_name				NVARCHAR(MAX);
	DECLARE @p_uom_type					NVARCHAR(MAX);
	DECLARE @p_unit						NVARCHAR(MAX);
	DECLARE @p_bucket_from				NVARCHAR(MAX);
	DECLARE @p_bucket_to				NVARCHAR(MAX);
	DECLARE @p_bucket					NVARCHAR(MAX);
	DECLARE @p_plan_type				NVARCHAR(MAX);
	DECLARE @p_description				NVARCHAR(MAX);
	DECLARE @p_read_only				NVARCHAR(MAX);
	DECLARE @p_plan_name				NVARCHAR(MAX);
	DECLARE @p_curr_date				NVARCHAR(MAX);
	DECLARE @p_chk_planid				NVARCHAR(MAX);
	DECLARE @p_chk_total_include		NVARCHAR(MAX);
	DECLARE @p_round_point				NVARCHAR(MAX);
	DECLARE @p_amend_instance			NVARCHAR(MAX);
	DECLARE @p_uom						NVARCHAR(MAX);

	-- week
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);

	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);
	DECLARE @p_amend_cutoff_boh_table	NVARCHAR(MAX);
	DECLARE @p_amend_bor_table			NVARCHAR(MAX);
	DECLARE @p_amend_util_table			NVARCHAR(MAX);
	DECLARE @p_amend_capa_table			NVARCHAR(MAX);

	DECLARE @p_result_qty	NVARCHAR(MAX);

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);

	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @v_delimiter , @mst_loop_cnt);
		SET @tmp_value	= [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		IF @tmp_column = '_SAVE_AUTH' BEGIN
			SET @p__save_auth =			@tmp_value ;
		END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
			SET @p__non_auth =			@tmp_value ;

		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'RELEASE_FLAG' BEGIN
			SET @p_release_flag =			@tmp_value ;
		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'OPERAION_ID' BEGIN
			SET @p_operation_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'LINE_ID' BEGIN
			SET @p_line_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_TYPE' BEGIN
			SET @p_cell_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'PANCAKE_TYPE' BEGIN
			SET @p_pancake_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME' BEGIN
			SET @p_model_nick_name =			@tmp_value ;
		END ELSE IF @tmp_column = 'MODEL_NICK_NAME_LIST' BEGIN
			SET @p_model_nick_name_list =			@tmp_value ;
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name =			@tmp_value ;
		END ELSE IF @tmp_column = 'UOM_TYPE' BEGIN
			SET @p_uom_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'UNIT' BEGIN
			SET @p_unit =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'DESCRIPTION' BEGIN
			SET @p_description =			@tmp_value ;
		END ELSE IF @tmp_column = 'READ_ONLY' BEGIN
			SET @p_read_only =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_NAME' BEGIN
			SET @p_plan_name =			@tmp_value ;
		END ELSE IF @tmp_column = 'CURR_DATE' BEGIN
			SET @p_curr_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'CHK_PLANID' BEGIN
			SET @p_chk_planid =			@tmp_value ;
		END ELSE IF @tmp_column = 'CHK_TOTAL_INCLUDE' BEGIN
			SET @p_chk_total_include =			@tmp_value ;
		END ELSE IF @tmp_column = 'ROUND_POINT' BEGIN
			SET @p_round_point =			@tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_INSTANCE' BEGIN
			SET @p_amend_instance =			@tmp_value ;
		END ELSE IF @tmp_column = 'UOM' BEGIN
			SET @p_uom =				@tmp_value ;
		
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value ;
		
		END

	END


	SET @p_amend_table = 'FP_AMEND_DAILY_PLAN_R';
	SET @p_amend_cutoff_boh_table = 'FP_AMEND_CUTOFF_BOH_R';
	SET @p_amend_bor_table = 'FP_AMEND_DAILY_BOR_R';
	SET @p_amend_sales_table = 'FP_AMEND_DAILY_SALES_R';
	SET @p_amend_util_table = 'FP_AMEND_DAILY_UTIL_R';
	SET @p_amend_capa_table = 'FP_AMEND_DAILY_CAPA_R';

	IF @p_plan_type = 'RELEASE' OR @p_release_flag = 'Y' BEGIN
		SET @p_amend_table = 'FP_AMEND_DAILY_PLAN_H' ;
		SET @p_amend_cutoff_boh_table = 'FP_AMEND_CUTOFF_BOH_H' ;
		SET @p_amend_bor_table = 'FP_AMEND_DAILY_BOR_H';
		SET @p_amend_sales_table = 'FP_AMEND_DAILY_SALES_H';
		SET @p_amend_util_table = 'FP_AMEND_DAILY_UTIL_H';
		SET @p_amend_capa_table = 'FP_AMEND_DAILY_CAPA_H';
	END


	/*	Parameter Setting End */

	/* Loop Settting */

	DECLARE @sub_mst_loop_cnt integer = 0
	DECLARE @sub_max_loop_cnt integer = 0
	DECLARE @sub_tmp_column NVARCHAR(MAX);
	DECLARE @sub_param_0 NVARCHAR(MAX);
	DECLARE @sub_param_1 NVARCHAR(MAX);
	DECLARE @sub_param_2 NVARCHAR(MAX);
	DECLARE @sub_param_3 NVARCHAR(MAX);
	DECLARE @sub_param_4 NVARCHAR(MAX);

	DECLARE @sub_total	NVARCHAR(MAX);
	DECLARE @total		NVARCHAR(MAX);
	DECLARE @capa_total	NVARCHAR(MAX);

	DECLARE @v_row_delimiter	NVARCHAR(2);
	DECLARE @sub_v_delimiter	NVARCHAR(2);

	DECLARE @max_day_loop_cnt	integer = 0;
	DECLARE @max_week_loop_cnt	integer = 0;
	DECLARE @max_month_loop_cnt	integer = 0;
	DECLARE @max_category_loop_cnt	integer = 0;
	
	SET @v_row_delimiter	= '!';  -- row column 데이터 구분자
	SET @sub_v_delimiter	= '#';  -- column  데이타 구분자 (추후 변경)

	SET @max_loop_cnt		= [dbo].[SCM_ARR_SPL_CNT](@p_bucket		, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_week_loop_cnt	= [dbo].[SCM_ARR_SPL_CNT](@p_week_info	, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_month_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
	--SET @max_category_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단

	SET	@v_dSql = '';

	IF @p_sys_flag = 'PLAN_PERIOD'
	BEGIN
		/*
		-- 당주 일주일 구간 조회
		SELECT @v_dSql += N'SELECT MIN(YYYYMMDD) AS START_DATE, MAX(YYYYMMDD) AS END_DATE, MAX(ISO_YYYYWW) AS PLAN_WEEK ' + char(10)
		SELECT @v_dSql += N'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    ISO_YYYYWW IN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT ISO_YYYYWW ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  YYYYMMDD = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		

		--SELECT @v_dSql += N'SELECT MIN(YYYYMMDD)   AS START_DATE, ' + char(10) -- 당주 첫날 기준
		SELECT @v_dSql += N'SELECT ''' + @p_plan_date + '''   AS START_DATE, ' + char(10) -- 계획시작일 -- 계획일~당주말
		SELECT @v_dSql += N'       MAX(YYYYMMDD)   AS END_DATE, ' + char(10)
		SELECT @v_dSql += N'       MAX(ISO_YYYYWW) AS PLAN_WEEK ' + char(10)
		SELECT @v_dSql += N'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1 = 1 ' + char(10)
		SELECT @v_dSql += N'AND    ISO_YYYYWW IN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT ISO_YYYYWW ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1 = 1 ' + char(10)
		SELECT @v_dSql += N'	AND    YYYYMMDD = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		--SELECT @v_dSql += N'AND    YYYYMMDD BETWEEN ''' + @p_plan_date + ''' AND CONVERT(VARCHAR, CONVERT(DATETIME,''' + @p_plan_date + ''')+4, 112)' + char(10)
		*/

		-- 계획일~계획일+4 : 5일 구간 고정
		SELECT @v_dSql += N'SELECT ''' + @p_plan_date + ''' AS START_DATE ' + char(10)
		SELECT @v_dSql += N'     , CONVERT(VARCHAR, CONVERT(DATETIME,''' + @p_plan_date + ''')+(5-1), 112) AS END_DATE ' + char(10)
		SELECT @v_dSql += N'	 , A.ISO_YYYYWW AS PLAN_WEEK ' + char(10)
		SELECT @v_dSql += N'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    A.YYYYMMDD = ''' + @p_plan_date + ''' ' + char(10)

	END

	IF @p_sys_flag = 'LIST_DATA'
	BEGIN
		
		SELECT @v_dSql += N'SELECT INSTANCE_ID, FP_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'      , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'	  --, WORK_ORDER_SPL_ID, WORK_ORDER_ID, DEMAND_ID ' + char(10)
		SELECT @v_dSql += N'      , ITEM_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID ' + char(10)
		SELECT @v_dSql += N'      , CONVERT(VARCHAR,PLAN_DATE,112) AS PLAN_DATE, SHIFT ' + char(10)
		SELECT @v_dSql += N'      , PC_IN_QTY, PC_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'      , JR_IN_QTY, JR_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'      , PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'FROM    FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE   1=0 ' + char(10)

	END

	IF @p_sys_flag = 'UOM_TYPE'
	BEGIN
		/*
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'     , A.ITEM_ID, ISNULL(A.PROD_VERSION_TYPE, ''GENERAL'') AS PROD_VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'	 , A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_ITEM_LANE_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LANE_QTY ' + char(10)
		

		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, ISNULL(B.LANE_QTY, ISNULL(B.LANE_QTY, C.LANE_QTY)) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += N'FROM   ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MAX( A.LANE_QTY ) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1' + char(10)
		SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MAX( A.LANE_QTY ) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'	AND    A.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N') B ' + char(10)
		SELECT @v_dSql += N'ON   1=1 ' + char(10)
		SELECT @v_dSql += N'AND  B.COMPANY_ID 	= A.COMPANY_ID' + char(10)
		SELECT @v_dSql += N'AND  B.DIVISION_ID 	= A.DIVISION_ID' + char(10)
		SELECT @v_dSql += N'AND  B.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.FACTORY_ID 	= A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.ITEM_ID 		= A.ITEM_ID	' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, MAX( A.LANE_QTY ) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N') C ' + char(10)
		SELECT @v_dSql += N'ON   1=1 ' + char(10)
		SELECT @v_dSql += N'AND  C.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.ITEM_ID 		= A.ITEM_ID	 ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		*/

		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE ' + char(10)
		--SELECT @v_dSql += N'     , MAX(CASE WHEN A.FLOW_ID = ''E2000E3000'' THEN 1 ELSE ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY))) END) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += N'     , MAX(ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY)))) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += N'     , MAX( B.JUMBO_ROLL_LENGTH ) AS JUMBO_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'     , MAX( B.PC_ROLL_LENGTH ) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, ''B'') AS ATTR_TYPE ' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			INNER HASH JOIN ( ' + char(10)
		SELECT @v_dSql += N'					SELECT DISTINCT COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'					FROM  FP_INSTANCE_LINE_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'					WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'					AND   INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'			) B ' + char(10)
		SELECT @v_dSql += N'			ON 1=1 ' + char(10)
		SELECT @v_dSql += N'			AND  B.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND  B.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND  B.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND  B.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'			INNER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			ON   1=1 ' + char(10)
		SELECT @v_dSql += N'			AND  A.COMPANY_ID	= C.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND  A.DIVISION_ID	= C.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND  A.SITE_ID		= C.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND  A.ITEM_ID		= C.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'			AND  C.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'					SELECT DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT ' + char(10)
		SELECT @v_dSql += N'					FROM   SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'					JOIN   FP_INSTANCE_INFO_V FII WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'					ON     1=1 ' + char(10)
		SELECT @v_dSql += N'					AND    LV.SEGMENT1 = FII.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'					WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'					AND    LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT'' ' + char(10)
		SELECT @v_dSql += N'			) E ' + char(10)
		SELECT @v_dSql += N'			ON 	  1=1 ' + char(10)
		SELECT @v_dSql += N'			AND   C.NICK_NAME LIKE E.ATTR_DEFINIT ' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'            ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, ''B'') ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += N'				 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'            ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			AND    A.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N') B ' + char(10)
		SELECT @v_dSql += N'ON 1=1 ' + char(10)
		SELECT @v_dSql += N'AND  B.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.FACTORY_ID 	= A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.ITEM_ID 		= A.ITEM_ID	' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += N'				 , MAX( A.LANE_QTY ) AS LANE_QTY	, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'            ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N') C ' + char(10)
		SELECT @v_dSql += N'ON 1=1 ' + char(10)
		SELECT @v_dSql += N'AND  C.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND  B.FACTORY_ID 	= A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND  C.ITEM_ID 		= A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += N'				 , MAX( A.LANE_QTY ) AS LANE_QTY	, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'            ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			AND    A.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N') D ' + char(10)
		SELECT @v_dSql += N'ON  1=1 ' + char(10)
		SELECT @v_dSql += N'AND  D.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND  D.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND  D.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND  D.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND  D.ITEM_ID 		= A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += N'				 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'				 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'            ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N') E ' + char(10)
		SELECT @v_dSql += N'ON 1=1 ' + char(10)
		SELECT @v_dSql += N'AND  E.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND  E.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND  E.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND  E.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND  E.ITEM_ID 		= A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE ' + char(10)

	END

	IF @p_sys_flag = 'ROLL_DATA'
	BEGIN
		
		/*
		SELECT @v_dSql += N'WITH STOCK AS ( ' + char(10)
		SELECT @v_dSql += N'			SELECT 	A.FACTORY_ID, A.FP_APPLY_ITEM_ID AS ITEM_ID, B.NICK_NAME, B.FLOW_ID, ' + char(10)
		SELECT @v_dSql += N'						CASE WHEN A.FP_APPLY_ITEM_ID LIKE ''APCA%'' THEN ''Anode'' ' + char(10)
		SELECT @v_dSql += N'							 WHEN A.FP_APPLY_ITEM_ID LIKE ''APCC%'' THEN ''Cathode'' ' + char(10)
		SELECT @v_dSql += N'							 ELSE ''-'' END 	AS ELECTROD_TYPE, ' + char(10)
		SELECT @v_dSql += N'						CASE WHEN A.OPERATION_ID > ''E4000'' THEN ''P'' ' + char(10)
		SELECT @v_dSql += N'							 WHEN A.OPERATION_ID = ''E4000'' THEN ''J'' ' + char(10)
		SELECT @v_dSql += N'							 ELSE ''J'' END AS ROLL_TYPE, ' + char(10)
		SELECT @v_dSql += N'						CASE WHEN A.OPERATION_ID > ''E4000'' THEN ISNULL(C.SEGMENT2, ''B'') ' + char(10)
		SELECT @v_dSql += N'							 ELSE ''-'' END AS ATTR_TYPE, ' + char(10)
		SELECT @v_dSql += N'						A.LANE, QTY, A.FP_APPLY_WIPQTY, ' + char(10)
		SELECT @v_dSql += N'						A.FP_APPLY_OPERATION_ID, ' + char(10)
		SELECT @v_dSql += N'						A.POSITION_CATEGORY, A.DETAIL_POSITION, A.LOT_COUNT, ' + char(10)
		SELECT @v_dSql += N'						A.COATING_LINE_ID ' + char(10)
		SELECT @v_dSql += N'			FROM 	SCM_STOCK_H_V A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			ON 	    1=1 ' + char(10)
		SELECT @v_dSql += N'			AND 	C.LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT'' ' + char(10)
		SELECT @v_dSql += N'			AND 	C.SEGMENT1 = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N'			AND 	B.NICK_NAME LIKE C.SEGMENT4 ' + char(10)
		SELECT @v_dSql += N'			WHERE 	1=1 ' + char(10)
		SELECT @v_dSql += N'			AND 	A.CUTOFF_DATE = ''' + @p_bucket_from + ''' ' + char(10)
		SELECT @v_dSql += N' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			AND 	A.FP_APPLY_ITEM_ID LIKE ''APC%'' ' + char(10)
		SELECT @v_dSql += N'			AND 	A.COMPANY_ID = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	A.SITE_ID = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	A.ITEM_ID = B.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'			AND 	A.STOCK_TYPE = ''WIP'' ' + char(10)
		SELECT @v_dSql += N'			AND 	A.WIPHOLD_YN = ''N'' ' + char(10)
		SELECT @v_dSql += N'			AND 	A.FACTORY_ID LIKE ''E%'' ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N', ITEM_STOCK AS ( ' + char(10)
		SELECT @v_dSql += N'			SELECT 	FACTORY_ID, ITEM_ID, ROLL_TYPE, SUM(QTY)/SUM(LOT_COUNT) AS M_ROLL ' + char(10)
		SELECT @v_dSql += N'			FROM 	STOCK ' + char(10)
		SELECT @v_dSql += N'			WHERE 	1=1 ' + char(10)
		SELECT @v_dSql += N'			GROUP BY FACTORY_ID, ITEM_ID, ROLL_TYPE ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N', FACTORY_STOCK AS ( ' + char(10)
		SELECT @v_dSql += N'			SELECT 	FACTORY_ID, ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE, SUM(QTY)/SUM(LOT_COUNT) AS M_ROLL ' + char(10)
		SELECT @v_dSql += N'			FROM 	STOCK ' + char(10)
		SELECT @v_dSql += N'			WHERE 	1=1 ' + char(10)
		SELECT @v_dSql += N'			GROUP BY FACTORY_ID, ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N', SITE_STOCK AS ( ' + char(10)
		SELECT @v_dSql += N'			SELECT 	ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE, SUM(QTY)/SUM(LOT_COUNT) AS M_ROLL ' + char(10)
		SELECT @v_dSql += N'			FROM 	STOCK ' + char(10)
		SELECT @v_dSql += N'			WHERE 	1=1 ' + char(10)
		SELECT @v_dSql += N'			GROUP BY ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N', PLAN_ITEM AS ( ' + char(10)
		SELECT @v_dSql += N'			SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, B.NICK_NAME, ' + char(10)
		SELECT @v_dSql += N'					CASE WHEN A.ITEM_ID LIKE ''APCA%'' THEN ''Cathode'' ELSE ''Anode'' END AS ELECTROD_TYPE, A.ATTR_TYPE, B.FLOW_ID, CONVERT(NUMERIC(20,10), ATTB_5) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += N'			FROM 	FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'			WHERE 	1=1 ' + char(10)
		SELECT @v_dSql += N'			AND 	A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'			AND 	A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
		SELECT @v_dSql += N'			AND 	A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	A.SITE_ID = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	A.ITEM_ID = B.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'			AND 	B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, B.NICK_NAME, A.ATTR_TYPE, B.FLOW_ID, ATTB_5 ' + char(10)
		SELECT @v_dSql += N')' + char(10)
		SELECT @v_dSql += N', M_PRIORITY AS ( ' + char(10)
		SELECT @v_dSql += N'			SELECT 	SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS A1, ATTRIBUTE2 AS A2, ATTRIBUTE3 AS A3, ATTRIBUTE4 AS A4 ' + char(10)
		SELECT @v_dSql += N'			FROM 	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			WHERE 	1=1 ' + char(10)
		SELECT @v_dSql += N'			AND 	LOOKUP_TYPE_CODE = ''E_POST_ROLL_DEFAULT_DEFINIT'' ' + char(10)
		SELECT @v_dSql += N'            AND 	SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10) + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N'SELECT 	A.*, ' + char(10)
		SELECT @v_dSql += N'			CASE WHEN A1 = ''SITE_STOCK'' THEN G.M_ROLL ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' ) THEN E.M_ROLL ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 = ''SITE_STOCK'' OR A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'' ) THEN ISNULL(E.M_ROLL, G.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  AND A4 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  THEN C.M_ROLL' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 != ''FACTORY_STOCK'' AND A3 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  E.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'') AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'')  THEN ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL)) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   AND A4 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   THEN B.JUMBO_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, G.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(E.M_ROLL, G.M_ROLL)) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 != ''SITE_STOCK'' OR A4 != ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, E.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 = ''FACTORY_STOCK'' AND A4 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL))) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND (A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, E.M_ROLL)) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 != ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, G.M_ROLL)) ' + char(10)
		SELECT @v_dSql += N'				 ELSE NULL END AS JR_M_ROLL, ' + char(10)
		SELECT @v_dSql += N'			CASE WHEN A1 = ''SITE_STOCK'' THEN G.M_ROLL ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' ) THEN E.M_ROLL * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 = ''SITE_STOCK'' OR A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'' ) THEN ISNULL(E.M_ROLL, G.M_ROLL) * A.LANE_QTY  ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  AND A4 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  THEN C.M_ROLL * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) * A.LANE_QTY' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 != ''FACTORY_STOCK'' AND A3 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  E.M_ROLL) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'') AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'')  THEN ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL)) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   AND A4 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   THEN B.JUMBO_ROLL_LENGTH * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, G.M_ROLL) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(E.M_ROLL, G.M_ROLL)) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 != ''SITE_STOCK'' OR A4 != ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, E.M_ROLL) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 = ''FACTORY_STOCK'' AND A4 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL))) * A.LANE_QTY  ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND (A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, E.M_ROLL)) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 != ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, G.M_ROLL)) * A.LANE_QTY ' + char(10)
		SELECT @v_dSql += N'				 ELSE NULL END AS JR_PC_M_ROLL, ' + char(10)
		SELECT @v_dSql += N'			CASE WHEN A1 = ''SITE_STOCK'' THEN H.M_ROLL ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' ) THEN F.M_ROLL ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 = ''SITE_STOCK'' OR A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'' ) THEN ISNULL(F.M_ROLL, H.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  AND A4 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  THEN D.M_ROLL ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 = ''SITE_STOCK'' THEN ISNULL(D.M_ROLL,  H.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND A2 != ''FACTORY_STOCK'' AND A3 = ''SITE_STOCK'' THEN ISNULL(D.M_ROLL,  H.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(D.M_ROLL,  F.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'') AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'')  THEN ISNULL(D.M_ROLL, ISNULL(F.M_ROLL, H.M_ROLL)) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   AND A4 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   THEN B.PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''SITE_STOCK'' THEN ISNULL(B.PC_ROLL_LENGTH, H.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(F.M_ROLL, H.M_ROLL)) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 != ''SITE_STOCK'' OR A4 != ''SITE_STOCK'') THEN ISNULL(B.PC_ROLL_LENGTH, F.M_ROLL) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 = ''FACTORY_STOCK'' AND A4 = ''SITE_STOCK'' THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(D.M_ROLL, ISNULL(F.M_ROLL, H.M_ROLL))) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND (A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(D.M_ROLL, F.M_ROLL)) ' + char(10)
		SELECT @v_dSql += N'				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 != ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(D.M_ROLL, H.M_ROLL))  ' + char(10)
		SELECT @v_dSql += N'				 ELSE NULL END AS PC_M_ROLL ' + char(10)
		SELECT @v_dSql += N'FROM 	PLAN_ITEM A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN SCM_ITEM_LANE_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.COMPANY_ID = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND A.SITE_ID = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND A.PLANT_ID = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND A.FACTORY_ID = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND A.ITEM_ID = B.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'AND B.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ITEM_STOCK C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.FACTORY_ID = C.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND A.ITEM_ID = C.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'AND C.ROLL_TYPE = ''J'' ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ITEM_STOCK D WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.FACTORY_ID = D.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND A.ITEM_ID = D.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'AND D.ROLL_TYPE = ''P'' ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN FACTORY_STOCK E WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.FACTORY_ID = E.FACTORY_ID  ' + char(10)
		SELECT @v_dSql += N'AND A.ELECTROD_TYPE = E.ELECTROD_TYPE ' + char(10)
		SELECT @v_dSql += N'AND E.ROLL_TYPE = ''J'' ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN FACTORY_STOCK F WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.FACTORY_ID = F.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND A.ELECTROD_TYPE = F.ELECTROD_TYPE ' + char(10)
		SELECT @v_dSql += N'AND A.ATTR_TYPE = F.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += N'AND F.ROLL_TYPE = ''P'' ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN SITE_STOCK G WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.ELECTROD_TYPE = G.ELECTROD_TYPE ' + char(10)
		SELECT @v_dSql += N'AND G.ROLL_TYPE = ''J'' ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN SITE_STOCK H WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.ELECTROD_TYPE = H.ELECTROD_TYPE ' + char(10)
		SELECT @v_dSql += N'AND A.ATTR_TYPE = H.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += N'AND H.ROLL_TYPE = ''P'', ' + char(10)
		SELECT @v_dSql += N'M_PRIORITY I ' + char(10)
		SELECT @v_dSql += N'WHERE 	1=1' + char(10)
		*/

		SELECT @v_dSql += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE, LANE_QTY ' + char(10)
		SELECT @v_dSql += '     , ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) AS JR_M_ROLL ' + char(10)
		SELECT @v_dSql += '     , (CASE WHEN ''' + @p_uom + ''' = ''JR'' THEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) ' + char(10)
		SELECT @v_dSql += '     		 ELSE  ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) * LANE_QTY END) AS JR_PC_M_ROLL ' + char(10)
		SELECT @v_dSql += '     , ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) AS PC_M_ROLL ' + char(10)
		SELECT @v_dSql += 'FROM ( ' + char(10)
		SELECT @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += '		 , CASE WHEN A.ITEM_ID LIKE ''APCA%'' THEN ''ANODE'' ' + char(10)
		SELECT @v_dSql += '		 		WHEN A.ITEM_ID LIKE ''APCC%'' THEN ''CATHODE'' ' + char(10)
		SELECT @v_dSql += '		 	    END AS ELECTRODE_TYPE ' + char(10)
		--SELECT @v_dSql += '		 , MAX(CASE WHEN A.FLOW_ID = ''E2000E3000'' THEN 1 ELSE ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY))) END) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += '		 , MAX(ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY)))) AS LANE_QTY ' + char(10)
		SELECT @v_dSql += '		 , MAX( B.JUMBO_ROLL_LENGTH ) AS JUMBO_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '		 , MAX( B.PC_ROLL_LENGTH ) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '	FROM ( ' + char(10)
		SELECT @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, ''B'') AS ATTR_TYPE ' + char(10)
		SELECT @v_dSql += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '				INNER HASH JOIN ( ' + char(10)
		SELECT @v_dSql += '						SELECT DISTINCT COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += '						FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '						WHERE  1=1 ' + char(10)
		SELECT @v_dSql += '						AND    INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += '				) B ' + char(10)
		SELECT @v_dSql += '				ON   1=1 ' + char(10)
		SELECT @v_dSql += '				AND  B.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += '				AND  B.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += '				AND  B.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += '				AND  B.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += '				INNER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '				ON   1=1 ' + char(10)
		SELECT @v_dSql += '				AND  A.COMPANY_ID	= C.COMPANY_ID ' + char(10)
		SELECT @v_dSql += '				AND  A.DIVISION_ID	= C.DIVISION_ID ' + char(10)
		SELECT @v_dSql += '				AND  A.SITE_ID		= C.SITE_ID ' + char(10)
		SELECT @v_dSql += '				AND  A.ITEM_ID		= C.ITEM_ID ' + char(10)
		SELECT @v_dSql += '				AND  C.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += '				LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += '						SELECT DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT ' + char(10)
		SELECT @v_dSql += '						FROM   SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '						JOIN   FP_INSTANCE_INFO_V FII WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '						ON 	   1=1 ' + char(10)
		SELECT @v_dSql += '						AND    LV.SEGMENT1 = FII.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += '						WHERE  1=1 ' + char(10)
		SELECT @v_dSql += '						AND    LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT'' ' + char(10)
		SELECT @v_dSql += '				) E ' + char(10)
		SELECT @v_dSql += '				ON 	  1=1 ' + char(10)
		SELECT @v_dSql += '				AND   C.NICK_NAME LIKE E.ATTR_DEFINIT ' + char(10)
		SELECT @v_dSql += '				WHERE 1=1 ' + char(10)
		SELECT @v_dSql += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, ''B'') ' + char(10)
		SELECT @v_dSql += '	) A ' + char(10)
		SELECT @v_dSql += '	LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += '				AND    A.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
		SELECT @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += '	) B ' + char(10)
		SELECT @v_dSql += '	ON   1=1 ' + char(10)
		SELECT @v_dSql += '	AND  B.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += '	AND  B.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += '	AND  B.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += '	AND  B.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += '	AND  B.FACTORY_ID 	= A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += '	AND  B.ITEM_ID 		= A.ITEM_ID	' + char(10)
		SELECT @v_dSql += '	LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += '	) C ' + char(10)
		SELECT @v_dSql += '	ON   1=1 ' + char(10)
		SELECT @v_dSql += '	AND  C.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += '	AND  C.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += '	AND  C.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += '	AND  C.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += '	AND  B.FACTORY_ID 	= A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += '	AND  C.ITEM_ID 		= A.ITEM_ID ' + char(10)
		SELECT @v_dSql += '	LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
		SELECT @v_dSql += '				AND    A.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
		SELECT @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += '	) D ' + char(10)
		SELECT @v_dSql += '	ON   1=1 ' + char(10)
		SELECT @v_dSql += '	AND  D.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += '	AND  D.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += '	AND  D.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += '	AND  D.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += '	AND  D.ITEM_ID 		= A.ITEM_ID ' + char(10)
		SELECT @v_dSql += '	LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		--SELECT @v_dSql += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.LANE_QTY = 0 THEN NULL ELSE A.LANE_QTY END ) AS LANE_QTY ' + char(10) -- 0 수량 관련 처리.... 20220531
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.JUMBO_ROLL_LENGTH = 0 THEN NULL ELSE A.JUMBO_ROLL_LENGTH END ) AS JUMBO_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '					 , MAX( CASE WHEN A.PC_ROLL_LENGTH = 0 THEN NULL ELSE A.PC_ROLL_LENGTH END ) AS PC_ROLL_LENGTH' + char(10)
		SELECT @v_dSql += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '				WHERE  1=1 ' + char(10)
		SELECT @v_dSql += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
		SELECT @v_dSql += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += '	) E ' + char(10)
		SELECT @v_dSql += '	ON   1=1 ' + char(10)
		SELECT @v_dSql += '	AND  E.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
		SELECT @v_dSql += '	AND  E.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
		SELECT @v_dSql += '	AND  E.SITE_ID 		= A.SITE_ID ' + char(10)
		SELECT @v_dSql += '	AND  E.PLANT_ID 	= A.PLANT_ID ' + char(10)
		SELECT @v_dSql += '	AND  E.ITEM_ID 		= A.ITEM_ID	' + char(10)
		SELECT @v_dSql += '	WHERE 1=1 ' + char(10)
		SELECT @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += ') A ' + char(10)
		SELECT @v_dSql += 'LEFT OUTER HASH JOIN ( ' + char(10)
		SELECT @v_dSql += '		SELECT FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += '			 , MAX(JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '		FROM ( ' + char(10)
		SELECT @v_dSql += '				SELECT FACTORY_ID, ELECTRODE_TYPE, B.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += '						, CASE WHEN B.UOM_TYPE = ''JR'' THEN JR_COL END AS JUMBO_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '						, CASE WHEN B.UOM_TYPE = ''PC'' AND B.ATTR_TYPE = ''A'' THEN A_TYPE_COL ' + char(10)
		SELECT @v_dSql += '						       WHEN B.UOM_TYPE = ''PC'' AND B.ATTR_TYPE = ''B'' THEN B_TYPE_COL ' + char(10)
		SELECT @v_dSql += '						       ELSE 0 END AS PC_ROLL_LENGTH ' + char(10)
		SELECT @v_dSql += '				FROM ( ' + char(10)
		SELECT @v_dSql += '						SELECT FACTORY_ID, ELECTRODE_TYPE, ISNULL([-],0) AS JR_COL, ISNULL([A],0) AS A_TYPE_COL, ISNULL([B],0) AS B_TYPE_COL ' + char(10)
		SELECT @v_dSql += '						FROM ( ' + char(10)
		SELECT @v_dSql += '							SELECT SEGMENT2 AS FACTORY_ID, ' + char(10)
		SELECT @v_dSql += '									CASE WHEN SEGMENT3 = ''A'' THEN ''ANODE'' ' + char(10)
		SELECT @v_dSql += '										 WHEN SEGMENT3 = ''C'' THEN ''CATHODE'' ' + char(10)
		SELECT @v_dSql += '										 ELSE SEGMENT3 END AS ELECTRODE_TYPE, SEGMENT4 AS ATTR_TYPE, ATTRIBUTE1 AS ROLL_QTY ' + char(10)
		SELECT @v_dSql += '							FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += '							WHERE	A.LOOKUP_TYPE_CODE = ''E_POST_JR_DEFAULT_DEFINIT'' ' + char(10)
		SELECT @v_dSql += '							AND		A.SEGMENT1         = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += '							AND		A.ACTIVE_FLAG      = ''Y'' ' + char(10)
		SELECT @v_dSql += '						) AS RESULT ' + char(10)
		SELECT @v_dSql += '						PIVOT (	' + char(10)
		SELECT @v_dSql += '							MAX(ROLL_QTY) FOR ATTR_TYPE IN ([-], [A], [B]) ' + char(10)
		SELECT @v_dSql += '						) AS PIV ' + char(10)
		SELECT @v_dSql += '				) A ' + char(10)
		SELECT @v_dSql += '				JOIN ( ' + char(10)
		SELECT @v_dSql += '						SELECT ''JR'' AS UOM_TYPE , ''A'' AS ATTR_TYPE UNION ' + char(10)
		SELECT @v_dSql += '						SELECT ''JR'' AS UOM_TYPE , ''B'' AS ATTR_TYPE UNION ' + char(10)
		SELECT @v_dSql += '						SELECT ''PC'' AS UOM_TYPE , ''A'' AS ATTR_TYPE UNION ' + char(10)
		SELECT @v_dSql += '						SELECT ''PC'' AS UOM_TYPE , ''B'' AS ATTR_TYPE ' + char(10)
		SELECT @v_dSql += '				) B ' + char(10)
		SELECT @v_dSql += '				ON 1=1 ' + char(10)
		SELECT @v_dSql += '				WHERE 1=1 ' + char(10)
		SELECT @v_dSql += '		) A ' + char(10)
		SELECT @v_dSql += '		GROUP BY FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += ') B ' + char(10)
		SELECT @v_dSql += 'ON  1=1 ' + char(10)
		SELECT @v_dSql += 'AND A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += 'AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += 'AND A.ATTR_TYPE      = B.ATTR_TYPE ' + char(10)
		SELECT @v_dSql += 'WHERE 1=1 ' + char(10)

	END

	IF @p_sys_flag = 'LOAD_DATA'
	BEGIN
		
		SELECT @v_dSql += N'WITH LINE_OFF_CAL AS ( ' + char(10)
		/*
		-- 일별 loss
		SELECT @v_dSql += N'			SELECT A.*, B.WORK_DATE, SUM(ISNULL(B.TIME_TERM, 0)) * 60 AS OFF_TIME, 86400 - (SUM(ISNULL(B.TIME_TERM, 0)) * 60) AS WORK_TIME ' + char(10)
		SELECT @v_dSql += N'			FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_WORK_CALENDAR_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'			AND A.COMPANY_ID = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.PLANT_ID = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.FACTORY_ID = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.LINE_ID = B.LINE_ID ' + char(10)
		SELECT @v_dSql += N'			AND	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'			AND B.LOSS_CODE IN ( ' + char(10)
		SELECT @v_dSql += N'					SELECT SEGMENT1 AS LOSS_CODE ' + char(10)
		SELECT @v_dSql += N'					FROM   SCM_SYS_LOOKUP_VALUE KK WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'					WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'					AND    LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + char(10)
		SELECT @v_dSql += N'					AND    ATTRIBUTE4 = ''Y'' ' + char(10)
		SELECT @v_dSql += N'			) ' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'			AND   A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'			AND   WORK_DATE BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.SITE_ID, A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MODEL_TYPE, B.WORK_DATE ' + char(10)
		*/

		-- 일별-shift별 loss
		SELECT @v_dSql += N'			SELECT A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MODEL_TYPE, A.WORK_DATE ' + char(10)
		SELECT @v_dSql += N'			     , A.OFF_TIME/2 AS OFF_TIME, A.WORK_TIME/2 AS WORK_TIME ' + char(10)
		SELECT @v_dSql += N'			     , E.SHIFT ' + char(10)
		SELECT @v_dSql += N'			FROM ( ' + char(10)
		SELECT @v_dSql += N'				SELECT A.*, B.WORK_DATE ' + char(10)
		SELECT @v_dSql += N'				 	 , SUM(ISNULL(B.TIME_TERM, 0)) * 60 AS OFF_TIME, 86400 - (SUM(ISNULL(B.TIME_TERM, 0)) * 60) AS WORK_TIME ' + char(10)
		SELECT @v_dSql += N'				FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				LEFT OUTER JOIN SCM_WORK_CALENDAR_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'				AND A.COMPANY_ID = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'				AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'				AND A.SITE_ID = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'				AND A.PLANT_ID = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'				AND A.FACTORY_ID = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'				AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'				AND A.LINE_ID = B.LINE_ID ' + char(10)
		SELECT @v_dSql += N'				AND	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'				AND B.LOSS_CODE IN ( ' + char(10)
		SELECT @v_dSql += N'						SELECT SEGMENT1 AS LOSS_CODE ' + char(10)
		SELECT @v_dSql += N'						FROM   SCM_SYS_LOOKUP_VALUE KK WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'						WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'						AND    LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + char(10)
		SELECT @v_dSql += N'						AND    ATTRIBUTE4 = ''Y'' ' + char(10)
		SELECT @v_dSql += N'				) ' + char(10)
		SELECT @v_dSql += N'				WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'				AND   A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'				AND   WORK_DATE BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
		SELECT @v_dSql += N'				GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.SITE_ID, A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MODEL_TYPE, B.WORK_DATE ' + char(10)
		SELECT @v_dSql += N'			) A ' + char(10)
		SELECT @v_dSql += N'			INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			 	SELECT ''1''  AS SHIFT ' + char(10) 
		SELECT @v_dSql += N'			 	UNION ALL ' + char(10)
		SELECT @v_dSql += N'			 	SELECT ''2''  AS SHIFT ' + char(10)
		SELECT @v_dSql += N'			) E ' + char(10)
		SELECT @v_dSql += N'			ON 1=1 ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N', LINE_LOSS_CAL AS ( ' + char(10)
		SELECT @v_dSql += N'			SELECT A.*, B.WORK_MONTH, SUM(ISNULL(B.LOSS_RATE, 0)) AS LOSS_RATE, 1 - SUM(ISNULL(B.LOSS_RATE, 0)) AS UTILIZATION ' + char(10)
		SELECT @v_dSql += N'			FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_LOSS_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			ON 	1=1 ' + char(10)
		SELECT @v_dSql += N'			AND A.COMPANY_ID = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.SITE_ID = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.PLANT_ID = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.FACTORY_ID = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'			AND A.LINE_ID = B.LINE_ID ' + char(10)
		SELECT @v_dSql += N'			AND	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'			AND B.LOSS_CODE IN ( ' + char(10)
		SELECT @v_dSql += N'					SELECT SEGMENT1 AS LOSS_CODE ' + char(10)
		SELECT @v_dSql += N'					FROM   SCM_SYS_LOOKUP_VALUE KK WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'					WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'					AND    LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + char(10)
		SELECT @v_dSql += N'					AND    ATTRIBUTE4 = ''Y'' ' + char(10)
		SELECT @v_dSql += N'			)' + char(10)
		SELECT @v_dSql += N'			WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'			AND   A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'			AND   WORK_MONTH BETWEEN SUBSTRING(''' + @p_bucket_from + ''',1,6) AND SUBSTRING(''' + @p_bucket_to + ''',1,6) ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.SITE_ID, A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MODEL_TYPE, B.WORK_MONTH ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N'SELECT A.* ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(JR_IN_QTY, 0) AS JR_IN_QTY ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(JR_OUT_QTY, 0) AS JR_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'	 , (CASE WHEN F.YIELD IS NULL OR F.YIELD = 0 THEN 1 ELSE F.YIELD END) AS YIELD ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(E.TACT_TIME,0) AS TACT_TIME ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(D.UTILIZATION,1) AS UTILIZATION ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(C.WORK_TIME, 43200) AS WORK_TIME ' + char(10)
		SELECT @v_dSql += N'	 -- LOAD BY ITEM : {OUT JR} / {YIELD} * {TACT TIME} / {UTILIZATION} / {WORK TIME} * 100 ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(B.JR_OUT_QTY,0) / (CASE WHEN F.YIELD IS NULL OR F.YIELD = 0 THEN 1 ELSE F.YIELD END) * ISNULL(E.TACT_TIME,0) / ISNULL(D.UTILIZATION,1) / ISNULL(C.WORK_TIME, 43200) * 100 AS LOAD ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(B.JR_IN_QTY,0) * ISNULL(E.TACT_TIME,0) / ISNULL(D.UTILIZATION,1) / ISNULL(C.WORK_TIME, 43200) * 100 AS LOAD2 ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, B.DT AS PLAN_DATE, B.YYYYMMDD AS PLAN_DT, E.SHIFT ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK), TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	 	SELECT ''1''  AS SHIFT ' + char(10) 
		SELECT @v_dSql += N'	 	UNION ALL ' + char(10)
		SELECT @v_dSql += N'	 	SELECT ''2''  AS SHIFT ' + char(10)
		SELECT @v_dSql += N'	) E ' + char(10)
		SELECT @v_dSql += N'	ON 1=1 ' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'	AND   A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'	AND   A.MONTH BETWEEN SUBSTRING(''' + @p_bucket_from + ''',1,6) AND SUBSTRING(''' + @p_bucket_to + ''',1,6) ' + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'	AND   B.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.PLAN_DATE, A.SHIFT ' + char(10)
		SELECT @v_dSql += N'		 , SUM(A.JR_IN_QTY) AS JR_IN_QTY, SUM(A.JR_OUT_QTY) AS JR_OUT_QTY ' + char(10)
		SELECT @v_dSql += N'	FROM   FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))    + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		SELECT @v_dSql += N'	AND    A.PLAN_DATE BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
		SELECT @v_dSql += N'	AND    A.SHIFT IN (''1'',''2'') ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.PLAN_DATE, A.SHIFT ' + char(10)
		SELECT @v_dSql += N') B ' + char(10)
		SELECT @v_dSql += N'on  1=1 ' + char(10)
		SELECT @v_dSql += N'AND   A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.SITE_ID        = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.PLANT_ID       = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.LINE_ID        = B.LINE_ID ' + char(10)
		SELECT @v_dSql += N'AND	  A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'AND	  A.ITEM_ID        = B.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.PLAN_DATE      = B.PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'AND   A.SHIFT          = B.SHIFT ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER HASH JOIN LINE_OFF_CAL C ' + char(10)
		SELECT @v_dSql += N'ON 	  1=1 ' + char(10)
		SELECT @v_dSql += N'AND   A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.SITE_ID        = C.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.PLANT_ID       = C.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.LINE_ID        = C.LINE_ID ' + char(10)
		SELECT @v_dSql += N'AND	  A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'AND   A.PLAN_DATE      = C.WORK_DATE ' + char(10)
		SELECT @v_dSql += N'AND   A.SHIFT          = C.SHIFT ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER HASH JOIN LINE_LOSS_CAL D ' + char(10)
		SELECT @v_dSql += N'ON 	  1=1 ' + char(10)
		SELECT @v_dSql += N'AND   A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.SITE_ID        = D.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.PLANT_ID       = D.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.FACTORY_ID     = D.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.LINE_ID        = D.LINE_ID ' + char(10)
		SELECT @v_dSql += N'AND	  A.ELECTRODE_TYPE = D.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'AND   CONVERT(CHAR(6), A.PLAN_DATE, 112) = D.WORK_MONTH ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN SCM_TACT_TIME_M E WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	  1=1 ' + char(10)
		SELECT @v_dSql += N'AND   A.COMPANY_ID     = E.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.DIVISION_ID    = E.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.SITE_ID        = E.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.PLANT_ID       = E.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.FACTORY_ID     = E.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.OPERATION_ID   = E.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.LINE_ID        = E.LINE_ID ' + char(10)
		SELECT @v_dSql += N'AND	  A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'AND   A.ITEM_ID        = E.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'AND   CONVERT(CHAR(6), A.PLAN_DATE, 112) = E.MONTH ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN SCM_YIELD_M F WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON 	  1=1 ' + char(10)
		SELECT @v_dSql += N'AND   A.COMPANY_ID     = F.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.DIVISION_ID    = F.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.SITE_ID        = F.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.PLANT_ID       = F.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.FACTORY_ID     = F.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.OPERATION_ID   = F.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.LINE_ID        = F.LINE_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.ITEM_ID        = F.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'AND   CONVERT(CHAR(6), A.PLAN_DATE, 112) = F.MONTH ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.PLAN_DATE, A.SHIFT ' + char(10)

	END

	IF @p_sys_flag = 'PRODUCTION_TYPE'
	BEGIN
		
		SELECT @v_dSql += N'SELECT A.SEGMENT2 AS CODE, A.SEGMENT2 AS NAME ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  A.LOOKUP_TYPE_CODE = ''E_POST_PROD_TYPE'' ' + char(10)
		SELECT @v_dSql += N'AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'ORDER BY SORT_ORDER, SEGMENT2 ' + char(10)

	END






	IF @p_sys_flag = 'CELL_TYPE'	-- find_cellType
	BEGIN
		
		SELECT @v_dSql += N'SELECT '''' AS CODE, ''ALL'' AS CODE_NAME ' + char(10)
		SELECT @v_dSql += N'UNION ALL ' + char(10)
		SELECT @v_dSql += N'SELECT A.CELL_TYPE AS CODE, A.CELL_TYPE AS CODE_NAME ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'  	SELECT DISTINCT (CASE WHEN LEVEL_4_NAME = ''-'' THEN LEVEL_2_NAME ELSE LEVEL_4_NAME END) AS CELL_TYPE' + char(10)
		SELECT @v_dSql += N'  	FROM 	 SCM_ITEM_CLASS_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'  	WHERE LEVEL_1_NAME = ''Model'' ' + char(10)
		SELECT @v_dSql += N'  	AND   USE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'   	AND   SCP_OPERATION_GROUP = ''A'' ' + char(10)
		SELECT @v_dSql += N'   	AND   CASE WHEN LEVEL_4_NAME = ''-'' THEN LEVEL_2_NAME ELSE LEVEL_4_NAME END != ''-'' ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'ORDER BY CODE ' + char(10)

	END
	
	IF @p_sys_flag = 'PANCAKE_TYPE'	-- find_pancakeType
	BEGIN

		SELECT @v_dSql += N'SELECT '''' AS CODE, ''ALL'' AS CODE_NAME ' + char(10)
		SELECT @v_dSql += N'UNION ALL ' + char(10)
		SELECT @v_dSql += N'SELECT DISTINCT LEVEL_3_NAME AS CODE, LEVEL_3_NAME AS CODE_NAME ' + char(10)
		SELECT @v_dSql += N'FROM 	 SCM_ITEM_CLASS_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  LEVEL_2_CODE = ''APC'' ' + char(10)
		SELECT @v_dSql += N'AND 	 LEVEL_3_CODE NOT IN (''-'',''APCSR'') ' + char(10)
		SELECT @v_dSql += N'ORDER BY CODE ' + char(10)

	END

	IF @p_sys_flag = 'CURR_DATE'	-- find_isPast
	BEGIN

		SELECT @v_dSql += N'SELECT AA.* ' + char(10)
		SELECT @v_dSql += N'     , (SELECT DATED1 FROM TH_UIS_CALENDAR T1 WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = AA.CURR_DATE)) AS PLAN_START_DATE ' + char(10)
		SELECT @v_dSql += N'     , CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR _T2 WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = AA.CURR_DATE)))), 112) AS PLAN_END_DATE ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'    SELECT A.BASIS_START_TIME ' + char(10)
		SELECT @v_dSql += N'  		   , CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,dbo.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME ' + char(10)
		SELECT @v_dSql += N'  				  THEN CONVERT(VARCHAR, DATEADD(DD,-1,dbo.FN_SITE_TIME(B.SITE_ID)), 112) ' + char(10)
		SELECT @v_dSql += N'  				  ELSE CONVERT(VARCHAR, dbo.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE ' + char(10)
		SELECT @v_dSql += N'    FROM   FP_INSTANCE_START_TIME_V A, ( ' + char(10)
		SELECT @v_dSql += N'    		SELECT MAX(B.SITE_ID) AS SITE_ID ' + char(10)
		SELECT @v_dSql += N'    		FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'    		WHERE  A.FACTORY_ID = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'    		AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'    		AND    B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'    		AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'	  ) B ' + char(10)
		SELECT @v_dSql += N'    WHERE  A.INSTANCE_ID = '''+ @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N') AA ' + char(10)

	END

	IF @p_sys_flag = 'UNIT'
	BEGIN

		SELECT @v_dSql += N'SELECT ''1'' AS CODE, ''1'' AS CODE_NAME ' + char(10)
		SELECT @v_dSql += N'UNION ALL ' + char(10)
		SELECT @v_dSql += N'SELECT ''1000'' AS CODE, ''1,000'' AS CODE_NAME ' + char(10)

	END

	IF @p_sys_flag = 'ELEC_FACTORY'
	BEGIN

		SELECT @v_dSql += N'SELECT A.FACTORY_ID AS CODE, A.FACTORY_ID + ''('' + MAX(B.FACTORY_NAME) + '')'' AS NAME ' + char(10)
		SELECT @v_dSql += N'FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'AND    B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'GROUP BY A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'ORDER BY A.FACTORY_ID ' + char(10)

	END

	IF @p_sys_flag = 'INSTANCE_ID'
	BEGIN

		SELECT @v_dSql += N'SELECT A.INSTANCE_ID AS CODE_ID, B.SEGMENT2 AS CODE_NAME, B.SORT_ORDER ' + char(10)
		SELECT @v_dSql += N'     , B.ATTRIBUTE3 AS USE_WOW_STATUS ' + char(10)
		SELECT @v_dSql += N'     , B.ATTRIBUTE1 AS CONFIRM_AREA ' + char(10)
		SELECT @v_dSql += N'     , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'     , B.ATTRIBUTE14 AS ROUND_POINT ' + char(10)
		SELECT @v_dSql += N'     , C.SITE_ID ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'  	SELECT DISTINCT A.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'  	FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'  	WHERE  USER_ID = ''' + @p_user_id + ''' ' + char(10)
		SELECT @v_dSql += N') A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK), ( ' + char(10)
		SELECT @v_dSql += N'    SELECT B.INSTANCE_ID, MAX(A.SITE_ID) AS SITE_ID ' + char(10)
		SELECT @v_dSql += N'    FROM   SCM_FACTORY_M A WITH(NOLOCK), FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'    WHERE  A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'    AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'    AND    B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'    GROUP BY B.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N') C ' + char(10)
		SELECT @v_dSql += N'WHERE A.INSTANCE_ID      = B.SEGMENT1 ' + char(10)
		SELECT @v_dSql += N'AND   A.INSTANCE_ID      = C.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
		SELECT @v_dSql += N'AND   B.SEGMENT1 IN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'    FROM   FP_AMEND_UI_V ' + char(10)
		SELECT @v_dSql += N'    WHERE  AMEND_UI_NAME = ''' + @p_amend_instance + ''' ' + char(10)
		SELECT @v_dSql += N'    AND    USE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N'AND   A.INSTANCE_ID NOT LIKE ''%_M'' ' + char(10)
		SELECT @v_dSql += N'ORDER BY B.SORT_ORDER ' + char(10)

	END

	IF @p_sys_flag = 'FP_PLAN_ID'
	BEGIN

		SELECT @v_dSql += N'WITH RELEASE_PLAN AS ( ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT ' + char(10)
		SELECT @v_dSql += N'           A.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'          ,A.RELEASE_PLAN_ID AS PLAN_ID ' + char(10)
		SELECT @v_dSql += N'          ,STUFF(( SELECT '','' + FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'                   FROM   FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'                   WHERE  A.INSTANCE_ID     = B.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'                   AND    A.INSTANCE_DATE   = B.INSTANCE_DATE ' + char(10)
		SELECT @v_dSql += N'                   AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'                   FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT ' + char(10)
		SELECT @v_dSql += N'          ,A.PLAN_GROUP_ID, A.INSTANCE_DATE AS PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'    FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'    WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'    AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'    AND    A.INSTANCE_DATE = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N'SELECT A.PLAN_ID AS CODE_ID, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS CODE_NAME ' + char(10)
		SELECT @v_dSql += N'    ,A.PLAN_ID ' + char(10)
		SELECT @v_dSql += N'    ,A.PLAN_TYPE ' + char(10)
		SELECT @v_dSql += N'    ,A.PLAN_START_TIME ' + char(10)
		SELECT @v_dSql += N'    ,A.PLAN_HORIZON ' + char(10)
		SELECT @v_dSql += N'    ,A.PLAN_HORIZON_UOM ' + char(10)
		SELECT @v_dSql += N'    ,A.DEMAND_HORIZON ' + char(10)
		SELECT @v_dSql += N'    ,A.DEMAND_HORIZON_UOM ' + char(10)
		SELECT @v_dSql += N'    ,A.CONFIG_SET_ID ' + char(10)
		SELECT @v_dSql += N'    ,A.BASIS_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'    ,A.DEMAND_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'    ,A.SCP_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'    ,A.PLAN_WEEK ' + char(10)
		SELECT @v_dSql += N'    ,''' + @p_plan_date + ''' AS PLAN_START_DATE ' + char(10)
		SELECT @v_dSql += N'    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = ''' + @p_plan_date + ''')))), 112) AS PLAN_END_DATE' + char(10)
		SELECT @v_dSql += N'    ,''' + @p_plan_date + ''' AS DEFAULT_START_DATE' + char(10)
		SELECT @v_dSql += N'    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = ''' + @p_plan_date + ''')))), 112) AS DEFAULT_END_DATE' + char(10)
		SELECT @v_dSql += N'    ,A.INSTANCE_ID, A.SITE_ID, A.DESCRIPTION, A.PLAN_TYPE ' + char(10)
		SELECT @v_dSql += N'    ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID' + char(10)
		SELECT @v_dSql += N'    ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME' + char(10)
		SELECT @v_dSql += N'    ,CASE WHEN A.RELEASE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'    	  THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID ) ' + char(10)
		SELECT @v_dSql += N'          ELSE A.DESCRIPTION END AS DESCS ' + char(10)
		SELECT @v_dSql += N'    ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION ' + char(10)
		SELECT @v_dSql += N'    ,C.FACTORY_LT ' + char(10)
		SELECT @v_dSql += N'    ,(CASE WHEN PLAN_TYPE = ''RELEASE''		THEN ''Y'' ' + char(10)
		SELECT @v_dSql += N'           WHEN RIGHT(A.PLAN_ID,2) = ''00''	THEN ''Y'' ' + char(10)
		SELECT @v_dSql += N'           ELSE ( CASE WHEN CONVERT(VARCHAR,A.PLAN_START_TIME,112) <> ' + char(10)
		SELECT @v_dSql += N'    																		( ' + char(10)
		SELECT @v_dSql += N'    																			SELECT (CASE WHEN FORMAT(DBO.FN_SITE_TIME(A.SITE_ID) ,''yyyyMMddHHmmss'') < (FORMAT(DBO.FN_SITE_TIME(A.SITE_ID) ,''yyyyMMdd'') + V.BASIS_START_TIME)' + char(10)
		SELECT @v_dSql += N'    																					 THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(DBO.FN_SITE_TIME(A.SITE_ID) ,''yyyyMMdd'')),112) ' + char(10)
		SELECT @v_dSql += N'    																					 ELSE FORMAT(DBO.FN_SITE_TIME(A.SITE_ID) ,''yyyyMMdd'') END) AS CURR_DATE ' + char(10)
		SELECT @v_dSql += N'    																			FROM   FP_INSTANCE_START_TIME_V V' + char(10)
		SELECT @v_dSql += N'    																			WHERE  A.INSTANCE_ID = V.INSTANCE_ID' + char(10)
		SELECT @v_dSql += N'    																		)' + char(10)
		SELECT @v_dSql += N'    						THEN ''Y'' ELSE ''N'' END )' + char(10)
		SELECT @v_dSql += N'    	  END) READ_ONLY' + char(10)
		SELECT @v_dSql += N'FROM   SCM_FP_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON    A.INSTANCE_ID = C.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'AND   A.PLAN_ID     = C.PLAN_ID ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'AND   CHARINDEX(''-00'',A.PLAN_ID) = 0 ' + char(10)
		SELECT @v_dSql += N'AND   A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND   CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N'ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)

	END
	
	IF @p_sys_flag = 'CHK_PLAN_ID'
	BEGIN
		SELECT @v_dSql += N'SELECT A.* ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
		SELECT @v_dSql += N'			    , RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
		SELECT @v_dSql += N'			    , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
		SELECT @v_dSql += N'			                		ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
		SELECT @v_dSql += N'		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		WHERE	1=1 ' + char(10)
		SELECT @v_dSql += N'		AND   	A.INSTANCE_ID IN ( ' + char(10)
		SELECT @v_dSql += N'									SELECT A.SEGMENT2 AS ASSY_ID ' + char(10)
		SELECT @v_dSql += N'									FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'									WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
		SELECT @v_dSql += N'									AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'								 ) ' + char(10)
		SELECT @v_dSql += N'		AND		A.INSERT_TIME > ( ' + char(10)
		SELECT @v_dSql += N'									SELECT DISTINCT A.INSERT_TIME ' + char(10)
		SELECT @v_dSql += N'									FROM   SCM_FP_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'									WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'									AND    A.INSTANCE_ID = '''+ @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'									AND    A.PLAN_ID =  ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N'									AND    CONVERT(VARCHAR,A.INSERT_TIME,112) = (  ' + char(10)
		SELECT @v_dSql += N'																					   SELECT CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,dbo.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME ' + char(10)
		SELECT @v_dSql += N'																								        THEN CONVERT(VARCHAR, DATEADD(DD,-1,dbo.FN_SITE_TIME(B.SITE_ID)), 112) ' + char(10)
		SELECT @v_dSql += N'																								        ELSE CONVERT(VARCHAR, dbo.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE ' + char(10)
		SELECT @v_dSql += N'																						FROM   FP_INSTANCE_START_TIME_V A, ( ' + char(10)
		SELECT @v_dSql += N'																							SELECT MAX(B.SITE_ID) AS SITE_ID ' + char(10)
		SELECT @v_dSql += N'																							FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'																							WHERE  A.FACTORY_ID = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'																							AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'																							AND    B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'																							AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'																						) B ' + char(10)
		SELECT @v_dSql += N'																						WHERE  A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'																				) ' + char(10)
		SELECT @v_dSql += N'									) ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'WHERE A.ROW_NUM = 1 ' + char(10)

	END

	IF @p_sys_flag = 'PLAN_INFO_POPUP'	-- find_planInfo_P
	BEGIN

		SELECT @v_dSql +=	N'	WITH COATER_PLAN AS (																																							' + char(10)
		SELECT @v_dSql +=	N'					        	SELECT ''COATER_PLAN'' AS PLAN_TYPE, A.*                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'					        	FROM (                                                                                                                                              ' + char(10)
		SELECT @v_dSql +=	N'						        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID= ''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE                        ' + char(10)
		SELECT @v_dSql +=	N'						                		, RELEASE_PLAN_ID, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, B.INSERT_ID                                                 ' + char(10)
		SELECT @v_dSql +=	N'						                		, ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)       ' + char(10)
		SELECT @v_dSql +=	N'						                						ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM                                                                        ' + char(10)
		SELECT @v_dSql +=	N'						        		FROM   	FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ,                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'						        			   	SCM_FP_PLAN_H B WITH(NOLOCK)                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'						        		WHERE  	1=1                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'						        		AND 	A.INSTANCE_ID = B.INSTANCE_ID                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'										AND		A.RELEASE_PLAN_ID = B.PLAN_ID                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'						        		AND	   	A.INSTANCE_DATE <= '''+ @p_plan_date +'''                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'					        		) A                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'					        	WHERE A.ROW_NUM = 1                                                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'					        	AND   A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                 ' + char(10)
		
		IF @p_release_flag = 'Y' BEGIN
			SELECT @v_dSql +=	N'							AND   1=1                                                      ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql +=	N'							AND   1=0	                                                      ' + char(10)
		END
		
		SELECT @v_dSql +=	N'					          	UNION ALL                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'								SELECT  ''COATER_PLAN'' AS PLAN_TYPE, A.INSTANCE_ID, ''-'' AS RELEASE_VALUE, A.PLAN_ID AS RELEASE_PLAN_ID                                   ' + char(10)
		SELECT @v_dSql +=	N'										, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, A.INSERT_ID, 1 AS ROW_NM                                                             ' + char(10)
		SELECT @v_dSql +=	N'								FROM SCM_FP_PLAN_H A WITH(NOLOCK)                                                                                                                   ' + char(10)
		
		IF @p_release_flag = 'Y' BEGIN
			SELECT @v_dSql +=	N'							WHERE  1=0	                                                      ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql +=	N'							WHERE  1=1	                                                      ' + char(10)
		END
		
		SELECT @v_dSql +=	N'								AND A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'								AND A.PLAN_ID =  '''+ @p_plan_id +'''                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'					        	                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'					)                                                                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'	-- Assy Plan                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'	, ASSY_PLAN AS (                                                                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'			        	SELECT ''ASSY_PLAN'' AS PLAN_TYPE, A.*                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'			        	FROM (                                                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'				        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE                                ' + char(10)
		SELECT @v_dSql +=	N'				                	 , RELEASE_PLAN_ID, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, B.INSERT_ID                                                            ' + char(10)
		SELECT @v_dSql +=	N'				                	 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)                  ' + char(10)
		SELECT @v_dSql +=	N'				                						 ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM                                                                               ' + char(10)
		SELECT @v_dSql +=	N'				        		FROM   	FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ,                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'				        				    SCM_FP_PLAN_H B WITH(NOLOCK)                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'				        		WHERE	1=1                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'				        		AND 	A.INSTANCE_ID = B.INSTANCE_ID                                                                                                               ' + char(10)
		SELECT @v_dSql +=	N'								    AND		A.RELEASE_PLAN_ID = B.PLAN_ID                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'				        		AND   	A.INSTANCE_ID IN (                                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'											        		SELECT A.SEGMENT2 AS ASSY_ID                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'											        		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql +=	N'											        		WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP''                                                              ' + char(10)
		SELECT @v_dSql +=	N'											        		AND    A.SEGMENT1 = '''+ @p_instance_id +'''                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'											          	 )                                                                                                                          ' + char(10)
		
		IF @p_release_flag = 'Y' OR @p_chk_planid = 'Y' BEGIN
			SELECT @v_dSql +=	N'							AND  A.INSTANCE_DATE <= '''+ @p_plan_date +'''	                                                      ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql +=	N'							AND  A.INSERT_TIME <= ( SELECT INSERT_TIME FROM COATER_PLAN )	                                                      ' + char(10)
		END
		
		SELECT @v_dSql +=	N'			        	) A                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'			        	WHERE A.ROW_NUM = 1                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'				                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'				)                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'	SELECT *                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'	FROM	COATER_PLAN                                                                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'	UNION ALL                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'	SELECT *                                                                                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'	FROM	ASSY_PLAN                                                                                                                                                               ' + char(10)

	END

	IF @p_sys_flag = 'UOM_INFO'
	BEGIN
		SELECT @v_dSql += N'SELECT A.* ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'				, A.OPERATION, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'				, UPPER(A.CATEGORY) AS CATEGORY ' + char(10)
		SELECT @v_dSql += N'				, A.PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'				, ''-'' AS MODEL_ID' + char(10)
		SELECT @v_dSql += N'				, MAX(A.VALUE) AS VALUE ' + char(10)
		SELECT @v_dSql += N'				, A.APPLY_DATE ' + char(10)
		SELECT @v_dSql += N'		FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY ' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC'' ' + char(10)
		SELECT @v_dSql += N'			AND    A.ATTRIBUTE2 = ''Y'' ' + char(10)
		SELECT @v_dSql += N'		) D ' + char(10)
		SELECT @v_dSql += N'		ON     A.CATEGORY = D.E_CATEGORY ' + char(10)
		SELECT @v_dSql += N'		INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'			SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'			FROM ( ' + char(10)
		SELECT @v_dSql += N'				SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'				FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				WHERE  A.MAX_VER_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'				AND    A.VALUE > 0 ' + char(10)
		SELECT @v_dSql += N'				AND    A.CATEGORY IN (  ''Jumbo Roll (cell/m)'', ''Lane Number'', ''Pancake (m/batch)'', ''cell/batch'', ''Jumbo Roll (m/batch)'', ''Pancake (cell/m)'' ) ' + char(10)
		SELECT @v_dSql += N'				GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'				HAVING COUNT(1) = 6 ' + char(10)
		SELECT @v_dSql += N'			) A ' + char(10)
		SELECT @v_dSql += N'			GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'		) E ' + char(10)
		SELECT @v_dSql += N'		ON     A.COMPANY_ID         = E.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'		AND    A.DIVISION_ID        = E.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'		AND    A.SITE_ID            = E.SITE_ID ' + char(10)
		SELECT @v_dSql += N'		AND    A.PLANT_ID           = E.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'		AND    A.FACTORY_ID         = E.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'		AND    A.OPERATION          = E.OPERATION ' + char(10)
		SELECT @v_dSql += N'		AND    A.ITEM_ID            = E.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'		AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'		AND    A.VERSION_TYPE       = E.VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'		WHERE  A.MAX_VER_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'		AND    A.CATEGORY IN (''cell/batch'',''Pancake (m/batch)'',''Jumbo Roll (m/batch)'')' + char(10)
		SELECT @v_dSql += N'		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
		SELECT @v_dSql += N'				, A.OPERATION, A.ITEM_ID' + char(10)
		SELECT @v_dSql += N'				, A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE, A.APPLY_DATE' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'        , A.OPERATION, A.ITEM_ID --, A.MODEL_ID ' + char(10)
		SELECT @v_dSql += N'        , A.APPLY_DATE DESC ' + char(10)
		SELECT @v_dSql += N'        , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE' + char(10)

	END

	IF @p_sys_flag = 'YIELD_INFO_CHILD'
	BEGIN
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'     , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.EQUIPMENT_ID, A.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'     , CONVERT(VARCHAR,A.START_DATE,112) AS START_DATE ' + char(10)
		SELECT @v_dSql += N'     , CONVERT(VARCHAR,A.END_DATE,112) AS END_DATE ' + char(10)
		SELECT @v_dSql += N'     , A.YIELD AS YIELD, A.CHILD_YIELD AS CHILD_YIELD ' + char(10)
		SELECT @v_dSql += N'FROM   ' + @p_amend_bor_table + ' A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)

		IF @p_release_flag = 'Y' BEGIN
			SELECT @v_dSql += N'AND    A.FP_PLAN_ID IN ( ' + char(10)
			SELECT @v_dSql += N'		SELECT DISTINCT RELEASE_PLAN_ID ' + char(10)
			SELECT @v_dSql += N'		FROM ( ' + char(10)
			SELECT @v_dSql += N'			SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql += N'      				, RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
			SELECT @v_dSql += N'      				, ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
			SELECT @v_dSql += N'                  						ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
			SELECT @v_dSql += N'			FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'			WHERE  A.INSTANCE_DATE <= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'		) A' + char(10)
			SELECT @v_dSql += N'		WHERE  A.ROW_NUM = 1' + char(10)
			SELECT @v_dSql += N'		AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N') ' + char(10)

		END
		ELSE BEGIN
			SELECT @v_dSql += N'AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			
		END
		
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'AND    A.OPERATION_ID   = ''E2000'' ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += N'ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'    , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'    , A.EQUIPMENT_ID, A.ITEM_ID, START_DATE ' + char(10)

	END

	IF @p_sys_flag = 'PROD_VERSION_TYPE'
	BEGIN
		SELECT @v_dSql += N'SELECT DISTINCT A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'	 , CASE WHEN B.PROD_VERSION_TYPE IS NOT NULL THEN 1 ELSE 2 END IDX1 ' + char(10)
		SELECT @v_dSql += N'	 , CASE WHEN A.PROD_VERSION_TYPE=''GENERAL'' THEN 1 ' + char(10)
		SELECT @v_dSql += N'	 	    WHEN A.PROD_VERSION_TYPE=''WIDE'' THEN 2 ' + char(10)
		SELECT @v_dSql += N'	 	    WHEN A.PROD_VERSION_TYPE=''PREWET_UNIT2'' THEN 3 ' + char(10)
		SELECT @v_dSql += N'	 	    WHEN A.PROD_VERSION_TYPE=''PREWET_UNIT3'' THEN 4 ' + char(10)
		SELECT @v_dSql += N'	 	    WHEN A.PROD_VERSION_TYPE=''UNIT2'' THEN 5 ' + char(10)
		SELECT @v_dSql += N'	 	    ELSE 6 END AS IDX2 ' + char(10)
		SELECT @v_dSql += N'FROM  SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'INNER JOIN FP_INSTANCE_FACTORY_M C WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON    A.FACTORY_ID  = C.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND	  C.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND	  C.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'		SELECT  DISTINCT A.SEGMENT4 AS FACTORY_ID, A.ATTRIBUTE1 AS PROD_VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		WHERE  A.LOOKUP_TYPE_CODE = ''LINE_PROD_VERSION_TYPE'' ' + char(10)
		SELECT @v_dSql += N') B ' + char(10)
		SELECT @v_dSql += N'ON  A.FACTORY_ID = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE ' + char(10)
		SELECT @v_dSql += N'WHERE  	1=1 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'AND		A.OPERATION = ''E2000'' ' + char(10)
		SELECT @v_dSql += N'AND		A.MAX_VER_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'AND		A.CATEGORY IN (''cell/batch'',''Pancake (m/batch)'',''Jumbo Roll (m/batch)'') ' + char(10)
		SELECT @v_dSql += N'ORDER BY A.FACTORY_ID, A.ITEM_ID, IDX1, IDX2 ' + char(10)

	END

	IF @p_sys_flag = 'POST_YIELD'
	BEGIN
		SELECT @v_dSql += N'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(CASE WHEN A.Y3 IS NULL OR A.Y3 = 0 THEN 1 ELSE A.Y3 END, 1) * ISNULL(CASE WHEN A.Y4 IS NULL OR A.Y4 = 0 THEN 1 ELSE A.Y4 END, 1) AS POST_YIELD ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'        SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID  , ITEM_ID , MONTH ' + char(10)
		SELECT @v_dSql += N'             , MIN(CASE WHEN OPERATION_ID = ''E3000'' THEN YIELD ELSE 1 END) AS Y3 ' + char(10)
		SELECT @v_dSql += N'             , MIN(CASE WHEN OPERATION_ID = ''E4000'' THEN YIELD ELSE 1 END) AS Y4 ' + char(10)
		SELECT @v_dSql += N'        FROM   ( ' + char(10)
		SELECT @v_dSql += N'            SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID,  MIN(A.YIELD) AS YIELD ' + char(10)
		SELECT @v_dSql += N'            FROM 	 SCM_YIELD_M A WITH(NOLOCK), ( ' + char(10)
		SELECT @v_dSql += N'                SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'                FROM   SCM_FACTORY_M A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'                INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'                ON    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'                AND   B.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'                WHERE A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'                AND   B.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'            ) B ' + char(10)
		SELECT @v_dSql += N'            WHERE  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'            AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'            AND    A.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'            AND    A.PLANT_ID    = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'            AND    A.OPERATION_ID IN (''E3000'', ''E4000'') ' + char(10)
		SELECT @v_dSql += N'            AND    A.MONTH BETWEEN CONVERT(VARCHAR(6),''' + @p_bucket_from + ''') AND CONVERT(VARCHAR(6),''' + @p_bucket_to + ''' )' + char(10)
		SELECT @v_dSql += N'            GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'        ) A ' + char(10)
		SELECT @v_dSql += N'        WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'        GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH ' + char(10)

	END

	IF @p_sys_flag = 'VERSION_TYPE'
	BEGIN
		SELECT @v_dSql += N'SELECT A.SEGMENT3 AS PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'     , A.ATTRIBUTE1 AS VERSION_TYPE_1 ' + char(10)
		SELECT @v_dSql += N'     , A.ATTRIBUTE2 AS VERSION_TYPE_2 ' + char(10)
		SELECT @v_dSql += N'     , A.ATTRIBUTE3 AS VERSION_TYPE_3 ' + char(10)
		SELECT @v_dSql += N'     , A.ATTRIBUTE4 AS VERSION_TYPE_4 ' + char(10)
		SELECT @v_dSql += N'     , A.ATTRIBUTE5 AS VERSION_TYPE_5 ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_CONV_PRIORITY'' ' + char(10)
		SELECT @v_dSql += N'AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'AND    A.SEGMENT1    = ''' + @p_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND    A.SEGMENT3   <> ''DEFAULT'' ' + char(10)
		SELECT @v_dSql += N'ORDER BY A.SORT_ORDER ' + char(10)

	END

	IF @p_sys_flag = 'START_END'
	BEGIN
		SELECT @v_dSql += N'SELECT A.BUCKET_FROM AS START_DATE, B.D_VALUE AS START_D_VALUE ' + char(10)
		SELECT @v_dSql += N'     , A.BUCKET_TO AS END_DATE, C.D_VALUE AS END_D_VALUE ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'	SELECT MIN(YYYYMMDD) AS BUCKET_FROM, MAX(YYYYMMDD) AS BUCKET_TO ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' -- BUCKET_FROM ~ BUCKET_TO ' + char(10)
		SELECT @v_dSql += N'	AND    YYYYMMDD >= ''' + @p_plan_date + ''' -- PLAN_DATE ' + char(10)
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT YYYYMMDD ' + char(10)
		SELECT @v_dSql += N'	    , ''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_VALUE ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
		SELECT @v_dSql += N') B ' + char(10)
		SELECT @v_dSql += N'ON A.BUCKET_FROM = B.YYYYMMDD ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT YYYYMMDD ' + char(10)
		SELECT @v_dSql += N'	    , ''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_VALUE ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
		SELECT @v_dSql += N') C ' + char(10)
		SELECT @v_dSql += N'ON A.BUCKET_TO = C.YYYYMMDD ' + char(10)

	END

	
	IF @p_sys_type = 'SQL'
    BEGIN
		
		DECLARE @log_id INTEGER = 0
		EXEC	@log_id = PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'sql',@runstart, @runend

		SELECT	QUERY_VALUE 
		FROM	TH_UIS_SQL_LOG WITH(NOLOCK)  
		WHERE	PROG_ID = @v_proc_name AND JOB_TYPE = @p_sys_type AND INST_SEQ = @log_id
		ORDER BY QUERY_SEQ ASC

    END ELSE BEGIN

		SET @runstart = GetDate()
		BEGIN TRY
		     BEGIN TRAN
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend

    END
	
  
END

