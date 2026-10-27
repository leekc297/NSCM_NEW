

--CREATE 
CREATE PROCEDURE [dbo].[PR_UI_FP00640_ETC]
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
/** 프로그램 ID   : PR_UI_FP00640_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00640_ETC                                               **/
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
/** 2022/08/04      LJS			Initial Release UI통합                                    **/
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00640_ETC';
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
	DECLARE @p_instance_id				NVARCHAR(MAX); -- pack instance id
	DECLARE @p_ilt_instance_id			NVARCHAR(MAX); -- ILT instance id
	DECLARE @p_plan_date				NVARCHAR(MAX);
	DECLARE @p_plan_id					NVARCHAR(MAX);
	DECLARE @p_division_id		   	    NVARCHAR(MAX);
	DECLARE @p_site_id			   	    NVARCHAR(MAX);
	DECLARE @p_plant_id			   	    NVARCHAR(MAX);

	DECLARE @p_model_id					NVARCHAR(MAX);
	DECLARE @p_module_id				NVARCHAR(MAX);
	DECLARE @p_cell_id					NVARCHAR(MAX);
	DECLARE @p_nick_name				NVARCHAR(MAX);

	DECLARE @p_bucket_from				NVARCHAR(MAX);
	DECLARE @p_bucket_to				NVARCHAR(MAX);
	DECLARE @p_bucket					NVARCHAR(MAX);
	DECLARE @p_read_only				NVARCHAR(MAX);
	DECLARE @p_amend_instance			NVARCHAR(MAX);
	DECLARE @p_category					NVARCHAR(MAX);

	-- week
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);

	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);


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
		END ELSE IF @tmp_column = 'ILT_INSTANCE_ID' BEGIN
			SET @p_ilt_instance_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value ;

		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value ;

		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'MODULE_ID' BEGIN
			SET @p_module_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_ID' BEGIN
			SET @p_cell_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name =			@tmp_value ;

		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =			@tmp_value ;
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'READ_ONLY' BEGIN
			SET @p_read_only =			@tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_INSTANCE' BEGIN
			SET @p_amend_instance =			@tmp_value ;
		END ELSE IF @tmp_column = 'CATEGORY_ID' BEGIN
			SET @p_category =			@tmp_value ;
		
		END

	END


	SET @p_amend_table = 'FP_AMEND_DAILY_PLAN_R';
	SET @p_amend_sales_table = 'FP_AMEND_DAILY_SALES_R';



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

	IF @p_sys_flag = 'INSTANCE_ID'
	BEGIN
		/*
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
		*/

		SELECT @v_dSql += N'SELECT A.SEGMENT1 AS CODE, A.ATTRIBUTE1 AS NAME ' + char(10)
		SELECT @v_dSql += N'     , A.SEGMENT1 AS ILT_INSTNACE_ID, A.SEGMENT2 AS PACK_INSTNACE_ID ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'INNER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT A.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'	FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  USER_ID = ''' + @p_user_id + ''' ' + char(10)
		SELECT @v_dSql += N') B ' + char(10)
		SELECT @v_dSql += N'ON  1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.SEGMENT2 = B.INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    LOOKUP_TYPE_CODE = ''INSTANCE_ILT2PACK'' ' + char(10)
		SELECT @v_dSql += N'ORDER BY A.SORT_ORDER ' + char(10)

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
		SELECT @v_dSql += N'    AND    A.INSTANCE_ID = ''' + @p_ilt_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'    AND    A.INSTANCE_DATE = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N') ' + char(10)
		SELECT @v_dSql += N'SELECT A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME ' + char(10)
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
		SELECT @v_dSql += N'          WHEN A.CONFIRM_FLAG = ''Y'' THEN ''Confirmed : '' + CONVERT(VARCHAR, A.CONFIRM_TIME, 20) + ''('' + CONFIRM_ID + '')'' ' + char(10) -- 확정 plan 에 대해서 메세지 추가... 20220914
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
		SELECT @v_dSql += N'AND   A.INSTANCE_ID = ''' + @p_ilt_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND   CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N'ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)

	END

	IF @p_sys_flag = 'PLAN_PERIOD'
	BEGIN
		-- 날짜구간 : 기준일 ~ 차주 막날
		--SELECT @v_dSql += N'SELECT ''' + @p_plan_date + ''' AS START_DATE, MAX(YYYYMMDD) AS END_DATE ' + char(10)
		SELECT @v_dSql += N'SELECT CONVERT(VARCHAR, DATEADD(DAY, -7, ''' + @p_plan_date + '''), 112) AS START_DATE, MAX(YYYYMMDD) AS END_DATE ' + char(10) -- 과거 7일부터
		SELECT @v_dSql += N'	 , MIN(ISO_YYYYWW) AS MIN_PLAN_WEEK, MAX(ISO_YYYYWW) AS MAX_PLAN_WEEK ' + char(10)
		SELECT @v_dSql += N'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    ISO_YYYYWW IN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT ISO_YYYYWW ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  (YYYYMMDD = ''' + @p_plan_date + ''' OR DT = CONVERT(DATETIME,''' + @p_plan_date + ''')+7) ' + char(10) -- 주단위 구간
		SELECT @v_dSql += N') ' + char(10)

	END

	IF @p_sys_flag = 'SSP_PLAN_ID'
	BEGIN
		
		SELECT @v_dSql += N'SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1	 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
		SELECT @v_dSql += N'AND    A.SHIP_DATE BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)

	END

	IF @p_sys_flag = 'LIST_DATA'
	BEGIN

		SELECT @v_dSql += N'SELECT INSTANCE_ID, FP_PLAN_ID ' + char(10)
		SELECT @v_dSql += N'     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
		SELECT @v_dSql += N'     , MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID ' + char(10)
		SELECT @v_dSql += N'     , CATEGORY_ID ' + char(10)
		SELECT @v_dSql += N'     , OPERATION_ID, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE ' + char(10)
		SELECT @v_dSql += N'     , CONVERT(VARCHAR,PLAN_DATE,112) AS PLAN_DATE, QTY ' + char(10)
		SELECT @v_dSql += N'FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK)' + char(10)
		SELECT @v_dSql += N'WHERE  1=0 ' + char(10)

	END
	-- 최종 확정 plan 정보 조회
	IF @p_sys_flag = 'REF_PLAN'
	BEGIN

		SELECT @v_dSql += N'SELECT TOP 1 A.PLAN_ID, A.CONFIRM_ID, A.CONFIRM_TIME, CONVERT(VARCHAR, A.PLAN_START_TIME, 112) AS PLAN_DATE ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_FP_PLAN_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'AND    A.INSTANCE_ID = ''' + @p_ilt_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND    A.CONFIRM_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'ORDER BY CONFIRM_TIME DESC ' + char(10)

	END
	-- 재고 상세 데이터
	IF @p_sys_flag = 'INV_DETAIL'
	BEGIN

		SELECT @v_dSql += N'SELECT A.* ' + char(10)
		SELECT @v_dSql += N'	 , B.NICK_NAME, B.ITEM_UOM ' + char(10)
		SELECT @v_dSql += N'	 , C.OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'	 , ISNULL(D.MODEL_ID, A.ITEM_ID) AS MODEL_ID ' + char(10)
		SELECT @v_dSql += N'	 , (CASE WHEN A.AVAILABLE_DATE = ''1999-01-01'' THEN NULL ELSE A.AVAILABLE_DATE END) AS AVAILABLE_DATE_CPY ' + char(10)
		SELECT @v_dSql += N'	 , A.QMS_HOLD_YN AS QMS_HOLD_YN_CPY ' + char(10)
		SELECT @v_dSql += N'	 , A.WIPHOLD_YN AS WIPHOLD_YN_CPY ' + char(10)
		SELECT @v_dSql += N'	 , A.LONG_TERM_FLAG AS LONG_TERM_FLAG_CPY ' + char(10)
		SELECT @v_dSql += N'	 , A.OPERATION_ID AS OPERATION_ID_CPY ' + char(10)
		SELECT @v_dSql += N'	 , (CASE WHEN A.STOCK_TYPE = ''INVENTORY'' THEN ''DW(oWMS)'' WHEN A.STOCK_TYPE = ''WIP'' THEN ''GMES'' ELSE A.STOCK_TYPE END) AS STOCK_TYPE_CPY ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_STOCK_H_V A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'INNER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'ON  1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'AND A.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT A.SEGMENT1 AS OPERATION_ID, A.ATTRIBUTE1 AS OPERATION_NAME ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	AND    A.LOOKUP_TYPE_CODE = ''FP_OPERATION'' ' + char(10)
		--SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N') C ' + char(10)
		SELECT @v_dSql += N'ON  1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.OPERATION_ID = C.OPERATION_ID ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT ' + char(10)
		SELECT @v_dSql += N'		   A.SEGMENT2 AS MODEL_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.SEGMENT3 AS MODULE_ID ' + char(10)
		SELECT @v_dSql += N'		 , A.SEGMENT4 AS CELL_ID ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.LOOKUP_TYPE_CODE = ''ILT_ITEM_LIST'' ' + char(10)
		SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'	AND    A.SEGMENT1 = ''' + @p_ilt_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N') D ' + char(10)
		SELECT @v_dSql += N'ON  1=1 ' + char(10)
		SELECT @v_dSql += N'AND A.ITEM_ID   = D.MODULE_ID ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
		SELECT @v_dSql += N'AND   A.CUTOFF_DATE = ''' + @p_plan_date + ''' ' + char(10)
		SELECT @v_dSql += N'AND   A.DIVISION_ID = ''' + @p_division_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND   A.SITE_ID = ''' + @p_site_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND   A.PLANT_ID = ''' + @p_plant_id + ''' ' + char(10)
		SELECT @v_dSql += N'AND   A.ITEM_ID IN (''' + @p_model_id + ''',''' + @p_module_id + ''') ' + char(10)
		SELECT @v_dSql += N'AND   A.STOCK_TYPE = ''WIP'' ' + char(10)
		SELECT @v_dSql += N'AND   A.OPERATION_ID NOT IN (''PR000'',''PS000'') ' + char(10)

		if @p_category = 'CATEGORY_12'
		begin
			-- CATEGORY_12 : In house inventory
			SELECT @v_dSql += N'AND   (A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS != ''PROC'') ' + char(10)
		end
		else if @p_category = 'CATEGORY_08'
		begin
			-- CATEGORY_08 : Aging Stock
			--SELECT @v_dSql += N'AND     ((A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5310'' AND A.STOCK_STATUS != ''PROC'')) ' + char(10)
			--SELECT @v_dSql += N'AND   ((A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5310'') OR (A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS != ''PROC'')) ' + char(10)
			SELECT @v_dSql += N'AND   (((A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5310'') OR (A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS != ''PROC'')) AND SECOND_OCV_EXP_DATE >= ''' + @p_plan_date + ''') ' + char(10)
		end
		else if @p_category = 'CATEGORY_07'
		begin
			-- CATEGORY_07 : Estimated Aging Completed
			--SELECT @v_dSql += N'AND   ((A.OPERATION_ID = ''P5310'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS != ''PROC'')) ' + char(10)
			SELECT @v_dSql += N'AND   (((A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5310'') OR (A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS != ''PROC'')) AND SECOND_OCV_EXP_DATE < ''' + @p_plan_date + ''') ' + char(10)
			--SELECT @v_dSql += N'AND   (((A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5310'') OR (A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS != ''PROC'')) AND SECOND_OCV_EXP_DATE < ''' + @p_plan_date + ''' AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2,  CONVERT(DATETIME,''' + @p_plan_date + '''))) ' + char(10)
		end
		else if @p_category = 'CATEGORY_06'
		begin
			-- CATEGORY_06 : Waiting Discharge
			SELECT @v_dSql += N'AND   ((A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5430'' AND A.STOCK_STATUS != ''PROC'')) ' + char(10)
		end
		else if @p_category = 'CATEGORY_02'
		begin
			-- CATEGORY_02 : CMA PKG(P5500)
			SELECT @v_dSql += N'AND   (( A.OPERATION_ID = ''P5430'' AND A.STOCK_STATUS = ''PROC'') OR A.OPERATION_ID IN (''P5000'',''P5500'',''P5480'') OR A.ITEM_ID = D.MODEL_ID ) ' + char(10)
			-- INVENTORY 조건 추가
			SELECT @v_dSql += N'UNION ALL ' + char(10)
			SELECT @v_dSql += N'SELECT A.* ' + char(10)
			SELECT @v_dSql += N'	 , B.NICK_NAME, B.ITEM_UOM ' + char(10)
			SELECT @v_dSql += N'	 , C.OPERATION_NAME ' + char(10)
			SELECT @v_dSql += N'	 , ISNULL(D.MODEL_ID, A.ITEM_ID) AS MODEL_ID ' + char(10)
			SELECT @v_dSql += N'	 , (CASE WHEN A.AVAILABLE_DATE = ''1999-01-01'' THEN NULL ELSE A.AVAILABLE_DATE END) AS AVAILABLE_DATE_CPY ' + char(10)
			SELECT @v_dSql += N'	 , ISNULL(A.QMS_HOLD_YN,''N'') AS QMS_HOLD_YN_CPY ' + char(10)
			SELECT @v_dSql += N'	 , ISNULL(A.WIPHOLD_YN,''N'') AS WIPHOLD_YN_CPY ' + char(10)
			SELECT @v_dSql += N'	 , ISNULL(A.LONG_TERM_FLAG,''N'') AS LONG_TERM_FLAG_CPY ' + char(10)
			SELECT @v_dSql += N'	 , A.STORAGE_ID AS OPERATION_ID_CPY ' + char(10)
			SELECT @v_dSql += N'	 , (CASE WHEN A.STOCK_TYPE = ''INVENTORY'' THEN ''DW(oWMS)'' WHEN A.STOCK_TYPE = ''WIP'' THEN ''GMES'' ELSE A.STOCK_TYPE END) AS STOCK_TYPE_CPY ' + char(10)
			SELECT @v_dSql += N'FROM   SCM_STOCK_H_V A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'INNER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'ON  1=1 ' + char(10)
			SELECT @v_dSql += N'AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql += N'AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql += N'AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql += N'AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'	SELECT DISTINCT A.SEGMENT1 AS OPERATION_ID, A.ATTRIBUTE1 AS OPERATION_NAME ' + char(10)
			SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
			SELECT @v_dSql += N'	AND    A.LOOKUP_TYPE_CODE = ''FP_OPERATION'' ' + char(10)
			--SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N') C ' + char(10)
			SELECT @v_dSql += N'ON  1=1 ' + char(10)
			SELECT @v_dSql += N'AND A.OPERATION_ID = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += N'	SELECT DISTINCT ' + char(10)
			SELECT @v_dSql += N'		   A.SEGMENT2 AS MODEL_ID ' + char(10)
			SELECT @v_dSql += N'		 , A.SEGMENT3 AS MODULE_ID ' + char(10)
			SELECT @v_dSql += N'		 , A.SEGMENT4 AS CELL_ID ' + char(10)
			SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += N'	WHERE  A.LOOKUP_TYPE_CODE = ''ILT_ITEM_LIST'' ' + char(10)
			SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql += N'	AND    A.SEGMENT1 = ''' + @p_ilt_instance_id + ''' ' + char(10)
			SELECT @v_dSql += N') D ' + char(10)
			SELECT @v_dSql += N'ON  1=1 ' + char(10)
			SELECT @v_dSql += N'AND A.ITEM_ID   = D.MODULE_ID ' + char(10)
			SELECT @v_dSql += N'WHERE 1=1 ' + char(10)
			SELECT @v_dSql += N'AND   A.CUTOFF_DATE = ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql += N'AND   A.DIVISION_ID = ''' + @p_division_id + ''' ' + char(10)
			SELECT @v_dSql += N'AND   A.SITE_ID = ''' + @p_site_id + ''' ' + char(10)
			SELECT @v_dSql += N'AND   A.PLANT_ID = ''' + @p_plant_id + ''' ' + char(10)
			SELECT @v_dSql += N'AND   A.ITEM_ID IN (''' + @p_model_id + ''',''' + @p_module_id + ''') ' + char(10)
			SELECT @v_dSql += N'AND   A.STOCK_TYPE = ''DW'' ' + char(10)
			--SELECT @v_dSql += N'AND   A.STORAGE_ID IN (''520P'',''532E'') ' + char(10)
			SELECT @v_dSql += N'AND   A.STORAGE_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00640_ETC'' AND SEGMENT1  = ''0'' AND ACTIVE_FLAG = ''Y'')' + char(10)


		end

		SELECT @v_dSql += N'ORDER BY A.STOCK_TYPE, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.FP_APPLY_OPERATION_ID, A.LINE_ID, A.STORAGE_ID, A.CUTOFF_DATE ' + char(10)
		SELECT @v_dSql += N'	   , A.FP_APPLY_ITEM_ID, A.LANE ' + char(10)

	END
	-- SSP, Assy 시간 조회
	IF @p_sys_flag = 'SSP_ASSY_TIME'
	BEGIN

		SELECT @v_dSql += N'SELECT A.SSP_TIME, B.ASSY_PLAN_ID, B.ASSY_TIME ' + char(10)
		SELECT @v_dSql += N'FROM ( ' + char(10)
		SELECT @v_dSql += N'	SELECT CONVERT(VARCHAR, ISNULL(MAX(A.INSERT_TIME),  GETDATE()), 20) AS SSP_TIME ' + char(10)
		SELECT @v_dSql += N'	FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'	AND    A.INSTANCE_ID = ''' + @p_ilt_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
		SELECT @v_dSql += N'	AND    A.CATEGORY_ID = ''CATEGORY_01'' ' + char(10)
		/*
		SELECT @v_dSql += N'	SELECT CONVERT(VARCHAR, MAX(INSERT_TIME), 20) AS SSP_TIME ' + char(10)
		SELECT @v_dSql += N'	FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1 ' + char(10)
		SELECT @v_dSql += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
		SELECT @v_dSql += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
		SELECT @v_dSql += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
		SELECT @v_dSql += N'	AND    A.SHOP_GROUP_ID = ''P'' ' + char(10)
		SELECT @v_dSql += N'	AND    A.SHIP_DATE BETWEEN CONVERT(DATETIME,''' + @p_bucket_from + ''') AND CONVERT(DATETIME,''' + @p_bucket_to + ''')  ' + char(10)
		SELECT @v_dSql += N'	AND    A.SCP_PLAN_ID = ( ' + char(10)
		SELECT @v_dSql += N'		SELECT MAX(SCP_PLAN_ID) ' + char(10)
		SELECT @v_dSql += N'		FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'		WHERE  1=1 ' + char(10)
		SELECT @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
		SELECT @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
		SELECT @v_dSql += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
		SELECT @v_dSql += N'		AND    A.SHOP_GROUP_ID = ''P'' ' + char(10)
		SELECT @v_dSql += N'		AND    A.SHIP_DATE BETWEEN CONVERT(DATETIME,''' + @p_bucket_from + ''') AND CONVERT(DATETIME,''' + @p_bucket_to + ''')  ' + char(10)
		SELECT @v_dSql += N'	) ' + char(10)
		*/
		SELECT @v_dSql += N') A ' + char(10)
		SELECT @v_dSql += N', ( ' + char(10)
		SELECT @v_dSql += N'	SELECT A.* ' + char(10)
		SELECT @v_dSql += N'	FROM ( ' + char(10)
		SELECT @v_dSql += N'		SELECT ROW_NUMBER() OVER(ORDER BY INSERT_TIME DESC) AS ROW_NUM,  ' + char(10)
		SELECT @v_dSql += N'			   A.AMEND_PLAN_ID AS ASSY_PLAN_ID, CONVERT(VARCHAR, A.INSERT_TIME, 20) AS ASSY_TIME  ' + char(10)
		SELECT @v_dSql += N'		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)  ' + char(10)
		SELECT @v_dSql += N'		WHERE  1=1 ' + char(10)
		SELECT @v_dSql += N'		AND    A.INSTANCE_ID = ( ' + char(10)
		SELECT @v_dSql += N'			SELECT MAX(A.SEGMENT3) AS ASSY_INSTANCE_ID ' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'			WHERE  1 = 1 ' + char(10)
		SELECT @v_dSql += N'			AND    A.LOOKUP_TYPE_CODE = ''INSTANCE_ILT2PACK'' ' + char(10)
		SELECT @v_dSql += N'			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
		SELECT @v_dSql += N'			AND    A.SEGMENT1 = ''' + @p_ilt_instance_id + ''' ' + char(10)
		SELECT @v_dSql += N'		) ' + char(10)
		SELECT @v_dSql += N'	) A ' + char(10)
		SELECT @v_dSql += N'	WHERE ROW_NUM = 1 ' + char(10)
		SELECT @v_dSql += N') B  ' + char(10)

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

