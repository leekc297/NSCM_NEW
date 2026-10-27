




--CREATE 
CREATE
PROCEDURE [dbo].[PR_UI_FP02845_ETC]
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
/** 프로그램 ID   : PR_UI_FP02845_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP02845_ETC                                               **/
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
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP02845_ETC';
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
	DECLARE @p_factory_id		   	    NVARCHAR(MAX);
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
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			@tmp_value ;
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
		SET @p_amend_table = 'FP_AMEND_CUTOFF_BOH_H' ;
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
		
		SELECT @v_dSql += N'SELECT MIN(YYYYMMDD) AS START_DATE, MAX(YYYYMMDD) AS END_DATE ' + char(10)
		SELECT @v_dSql += N'	 , MIN(ISO_YYYYWW) AS MIN_PLAN_WEEK, MAX(ISO_YYYYWW) AS MAX_PLAN_WEEK ' + char(10)
		SELECT @v_dSql += N'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  DT BETWEEN CONVERT(DATETIME,''' + @p_plan_date + ''')-3 AND CONVERT(DATETIME,''' + @p_plan_date + ''') + 5 ' + char(10) -- 현재-3 ~ 현재+5 구간
		/*
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    ISO_YYYYWW IN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT ISO_YYYYWW ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  (YYYYMMDD = ''' + @p_plan_date + ''' OR DT = CONVERT(DATETIME,''' + @p_plan_date + ''')+7) ' + char(10) -- 주단위 구간
		SELECT @v_dSql += N') ' + char(10)
		*/

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

