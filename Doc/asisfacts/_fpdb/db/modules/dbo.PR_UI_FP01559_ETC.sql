CREATE PROCEDURE [dbo].[PR_UI_FP01559_ETC]
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
/** 프로그램 ID   : PR_UI_FP01559_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP01559_ETC                                               **/
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
/** 2021/08/18   CYS				Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP01559_ETC';
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

	DECLARE @p_company_id	NVARCHAR(MAX);
	DECLARE @p_instance_id	NVARCHAR(MAX);
	DECLARE @p_master_id	NVARCHAR(MAX);
	DECLARE @p_plan_date	NVARCHAR(MAX);
	DECLARE @p_plan_id		NVARCHAR(MAX);
	DECLARE @p_bucket_from	NVARCHAR(MAX);
	DECLARE @p_bucket_to	NVARCHAR(MAX);

	DECLARE @p_division_id	NVARCHAR(MAX);
	DECLARE @p_site_id		NVARCHAR(MAX);
	DECLARE @p_plant_id		NVARCHAR(MAX);
	DECLARE @p_factory_id	NVARCHAR(MAX);
	DECLARE @p_operation_id NVARCHAR(MAX);
	DECLARE @p_line_id		NVARCHAR(MAX);
	
	DECLARE @p_top_item_id	NVARCHAR(MAX);
	DECLARE @p_item_id		NVARCHAR(MAX);
	DECLARE @p_nick_name	NVARCHAR(MAX);
	DECLARE @p_prod_type	NVARCHAR(MAX);
	DECLARE @p_prodtype_id	NVARCHAR(MAX);
	DECLARE @p_cate_info	NVARCHAR(MAX);
	DECLARE @p_cell_group	NVARCHAR(MAX);
	DECLARE @p_user_lt		NVARCHAR(MAX);
	DECLARE @p_plan_type	NVARCHAR(MAX);

	DECLARE @p_category_type	NVARCHAR(MAX);
	DECLARE @p_pack_instance_id	NVARCHAR(MAX);
	DECLARE @p_form_instance_id	NVARCHAR(MAX);
	DECLARE @p_cell_factory_id	NVARCHAR(MAX);
	DECLARE @p_pack_factory_id	NVARCHAR(MAX);

	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);
	
	DECLARE @p_sel_type		NVARCHAR(MAX);
	DECLARE @p_sel_instance_id	NVARCHAR(MAX);

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
		
		END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
			SET @p_company_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
			SET @p_master_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =		@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			@tmp_value ;

		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
			SET @p_operation_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'LINE_ID' BEGIN
			SET @p_line_id =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
			SET @p_top_item_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
			SET @p_item_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
			SET @p_nick_name =			@tmp_value ;
		END ELSE IF @tmp_column = 'PROD_TYPE' BEGIN
			SET @p_prod_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
			SET @p_cell_group =			@tmp_value ;
		END ELSE IF @tmp_column = 'USER_LT'	   BEGIN
			SET @p_user_lt =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value ;
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value ;

		END ELSE IF @tmp_column = 'PACK_INSTANCE_ID' BEGIN
			SET @p_pack_instance_id =	@tmp_value ;
		END ELSE IF @tmp_column = 'SEL_TYPE' BEGIN
			SET @p_sel_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'SEL_INSTANCE_ID' BEGIN
			SET @p_sel_instance_id =	@tmp_value ;
		
		END ELSE IF @tmp_column = 'FORM_INSTANCE_ID' BEGIN
			SET @p_form_instance_id =	@tmp_value ;
		END ELSE IF @tmp_column = 'CATEGORY_TYPE' BEGIN
			SET @p_category_type =		@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_FACTORY_ID' BEGIN
			SET @p_cell_factory_id =	@tmp_value ;
		END ELSE IF @tmp_column = 'PACK_FACTORY_ID' BEGIN
			SET @p_pack_factory_id =	@tmp_value ;
		
		END

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
	SET @max_category_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단

	SET	@v_dSql = '';

	IF @p_sys_flag = 'INSTANCE'	-- findInstanceList_common
	BEGIN
		
		SELECT @v_dSql += N'	SELECT A.SEGMENT1 AS SITE_ID										' + char(10)
		SELECT @v_dSql += N'	    , A.SEGMENT2 AS INSTANCE_ID                                     ' + char(10)
		SELECT @v_dSql += N'	    , A.SEGMENT3 AS INSTANCE_NAME                                   ' + char(10)
		SELECT @v_dSql += N'	    , A.SEGMENT4 AS PLAN_GROUP                                      ' + char(10)
		SELECT @v_dSql += N'	    , A.SEGMENT5 AS PLAN_GROUP_NAME                                 ' + char(10)
		SELECT @v_dSql += N'	    , A.ATTRIBUTE1 AS PACK_INSTANCE_ID                              ' + char(10)
		SELECT @v_dSql += N'	    , A.ATTRIBUTE2 AS DIVISION                                      ' + char(10)
		SELECT @v_dSql += N'	    , A.ATTRIBUTE3 AS CELL_INSTANCE_ID                              ' + char(10)
		SELECT @v_dSql += N'	    , B.INSTANCE_NAME AS PACK_INSTANCE_NAME                         ' + char(10)
		SELECT @v_dSql += N'	    , C.INSTANCE_NAME AS CELL_INSTANCE_NAME                         ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                          ' + char(10)
		SELECT @v_dSql += N'	LEFT OUTER JOIN (                                                   ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS INSTANCE_NAME     ' + char(10)
		SELECT @v_dSql += N'	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                        ' + char(10)
		SELECT @v_dSql += N'	  WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                       ' + char(10)
		SELECT @v_dSql += N'	  AND    A.ACTIVE_FLAG = ''Y''                                      ' + char(10)
		SELECT @v_dSql += N'	) B                                                                 ' + char(10)
		SELECT @v_dSql += N'	ON A.ATTRIBUTE1 = B.INSTANCE_ID                                     ' + char(10)
		SELECT @v_dSql += N'	LEFT OUTER JOIN (                                                   ' + char(10)
		SELECT @v_dSql += N'	  SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS INSTANCE_NAME     ' + char(10)
		SELECT @v_dSql += N'	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                        ' + char(10)
		SELECT @v_dSql += N'	  WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                       ' + char(10)
		SELECT @v_dSql += N'	  AND    A.ACTIVE_FLAG = ''Y''                                      ' + char(10)
		SELECT @v_dSql += N'	) C                                                                 ' + char(10)
		SELECT @v_dSql += N'	ON A.ATTRIBUTE3 = C.INSTANCE_ID                                     ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.LOOKUP_TYPE_CODE = ''FORMATION_ID_MAPPING''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG      = ''Y''                                   ' + char(10)
		SELECT @v_dSql += N'	and A.SEGMENT1 IN (''A001'',''A004'') -- 임시처리                   ' + char(10)
		SELECT @v_dSql += N'	/*** 임시 주석처리                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    EXISTS (                                                     ' + char(10)
		SELECT @v_dSql += N'			SELECT 1                                                    ' + char(10)
		SELECT @v_dSql += N'			FROM   SCM_SYS_LOOKUP_VALUE DD WITH(NOLOCK)                 ' + char(10)
		SELECT @v_dSql += N'			WHERE  1=1                                                  ' + char(10)
		SELECT @v_dSql += N'			AND    A.SEGMENT2   = DD.SEGMENT1 -- FROM                   ' + char(10)
		SELECT @v_dSql += N'			AND    A.ATTRIBUTE1 = DD.SEGMENT2 -- PACK                   ' + char(10)
		SELECT @v_dSql += N'			AND    DD.LOOKUP_TYPE_CODE = ''INHOUSE_CELL_INTEG_UI''      ' + char(10)
		SELECT @v_dSql += N'			AND    DD.ACTIVE_FLAG = ''Y''                               ' + char(10)
		SELECT @v_dSql += N'	)                                                                   ' + char(10)
		SELECT @v_dSql += N'	*/                                                                  ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.SORT_ORDER                                               ' + char(10)

	END
	
	IF @p_sys_flag = 'WEEK_CNT'	-- find_WeekCnt
	BEGIN

		SELECT @v_dSql += N'	SELECT ISO_YYYYWW AS WEEK															' + char(10)
		SELECT @v_dSql += N'	   , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS WEEK_NAME   ' + char(10)
		SELECT @v_dSql += N'	   , COUNT(*) AS WEEK_COUNT                                                         ' + char(10)
		SELECT @v_dSql += N'	   , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS W_VALUE ' + char(10)
		SELECT @v_dSql += N'	   , ''1'' AS IS_DAY_VIEW                                                           ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                               ' + char(10)
		SELECT @v_dSql += N'	WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @p_bucket_from +''', 112)                   ' + char(10)
		SELECT @v_dSql += N'	AND    CAL.DT <= CONVERT(DATETIME, '''+ @p_bucket_to +''', 112)                     ' + char(10)
		SELECT @v_dSql += N'	GROUP BY ISO_YYYYWW                                                                 ' + char(10)
		SELECT @v_dSql += N'	ORDER BY ISO_YYYYWW                                                                 ' + char(10)

	END

	IF @p_sys_flag = 'DATE_MAP'	-- find_DateMap
	BEGIN

		SELECT @v_dSql += N'	SELECT (CASE WHEN YYYYMMDD >= '''+ @p_plan_date +''' THEN ''Y'' ELSE ''N'' END) AS IS_PLAN									' + char(10)
		SELECT @v_dSql += N'		    ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_VALUE                           ' + char(10)
		SELECT @v_dSql += N'		    ,YYYYMMDD AS _DATE                                                                                      ' + char(10)
		SELECT @v_dSql += N'		    ,ISO_YYYYWW AS _WEEK                                                                                    ' + char(10)
		SELECT @v_dSql += N'		    ,MONTH AS _MONTH                                                                                        ' + char(10)
		SELECT @v_dSql += N'		    ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' ''    ' + char(10)
		SELECT @v_dSql += N'		    +(CASE WHEN DAY_SEQ=2 THEN ''(Mon.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=3 THEN ''(Tue.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=4 THEN ''(Wed.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=5 THEN ''(Thu.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=6 THEN ''(Fri.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           WHEN DAY_SEQ=7 THEN ''(Sat.)''                                                                   ' + char(10)
		SELECT @v_dSql += N'		           ELSE ''(SUN.)'' END)                                                                             ' + char(10)
		SELECT @v_dSql += N'		    AS _DATE_TXT                                                                                            ' + char(10)
		SELECT @v_dSql += N'		    ,DAY_SEQ                                                                                                ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                                ' + char(10)
		SELECT @v_dSql += N'	WHERE  YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                     ' + char(10)
		SELECT @v_dSql += N'	ORDER BY YYYYMMDD                                                                                               ' + char(10)

	END

	IF @p_sys_flag = 'MONTH_CNT'	-- find_MonthCnt
	BEGIN

		SELECT @v_dSql += N'	SELECT 	YYYYMM AS MONTH																	' + char(10)
		SELECT @v_dSql += N'	   		, SUBSTRING(YYYYMM,1,4) + ''-'' +                                               ' + char(10)
		SELECT @v_dSql += N'		     (CASE WHEN MONTH = ''01'' THEN ''Jan''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''02'' THEN ''Feb''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''03'' THEN ''Mar''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''04'' THEN ''Apr''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''05'' THEN ''May''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''06'' THEN ''Jun''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''07'' THEN ''Jul''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''08'' THEN ''Aug''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''09'' THEN ''Sep''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''10'' THEN ''Oct''                                         ' + char(10)
		SELECT @v_dSql += N'		           WHEN MONTH = ''11'' THEN ''Nov''                                         ' + char(10)
		SELECT @v_dSql += N'		           ELSE ''Dec'' END) AS MONTH_NAME                                          ' + char(10)
		SELECT @v_dSql += N'		   , COUNT(*) AS MONTH_COUNT                                                        ' + char(10)
		SELECT @v_dSql += N'		   , ''M'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMM))-1) AS M_VALUE     ' + char(10)
		SELECT @v_dSql += N'	FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                                   ' + char(10)
		SELECT @v_dSql += N'	WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @p_bucket_from +''', 112)                       ' + char(10)
		SELECT @v_dSql += N'	AND    CAL.DT <= CONVERT(DATETIME, '''+ @p_bucket_to +''', 112)                         ' + char(10)
		SELECT @v_dSql += N'	GROUP BY YYYYMM, MONTH                                                                  ' + char(10)
		SELECT @v_dSql += N'	ORDER BY YYYYMM                                                                         ' + char(10)

	END

	IF @p_sys_flag = 'BUCKET_INFO'	-- find_bukInfo
	BEGIN

		SELECT @v_dSql += N'	SELECT A.*                                                                                                         		' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'			  SELECT YYYYMMDD AS _DATE                                                                                      ' + char(10)
		SELECT @v_dSql += N'			        ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' ''    ' + char(10)
		SELECT @v_dSql += N'			        +(CASE WHEN DAY_SEQ=2 THEN ''(Mon)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=3 THEN ''(Tue)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=4 THEN ''(Wed)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=5 THEN ''(Thu)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=6 THEN ''(Fri)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               WHEN DAY_SEQ=7 THEN ''(Sat)''                                                                    ' + char(10)
		SELECT @v_dSql += N'			               ELSE ''(SUN)'' END)                                                                              ' + char(10)
		SELECT @v_dSql += N'			        AS _NAME                                                                                                ' + char(10)
		SELECT @v_dSql += N'			        , 1 AS _COUNT                                                                                           ' + char(10)
		SELECT @v_dSql += N'			        ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE                            ' + char(10)
		SELECT @v_dSql += N'			        , 1 AS _DATE_SEQ                                                                                        ' + char(10)
		SELECT @v_dSql += N'			        , ISO_YYYYWW AS WEEK_SEQ                                                                                ' + char(10)
		SELECT @v_dSql += N'			        , ''D'' AS _TYPE                                                                                        ' + char(10)
		SELECT @v_dSql += N'			  FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                              ' + char(10)
		SELECT @v_dSql += N'			  WHERE  YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                   ' + char(10)
		SELECT @v_dSql += N'			  UNION ALL                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			  SELECT ISO_YYYYWW AS _DATE                                                                                    ' + char(10)
		SELECT @v_dSql += N'			       , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME                               ' + char(10)
		SELECT @v_dSql += N'			       , COUNT(*) AS _COUNT                                                                                     ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE                          ' + char(10)
		SELECT @v_dSql += N'			       , 1 AS _DATE_SEQ                                                                                         ' + char(10)
		SELECT @v_dSql += N'			       , ISO_YYYYWW AS WEEK_SEQ                                                                                 ' + char(10)
		SELECT @v_dSql += N'			       , ''W'' AS _TYPE                                                                                         ' + char(10)
		SELECT @v_dSql += N'			  FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                                                         ' + char(10)
		SELECT @v_dSql += N'			  WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @p_bucket_from +''', 112)                                             ' + char(10)
		SELECT @v_dSql += N'			  AND    CAL.DT <= CONVERT(DATETIME, '''+ @p_bucket_to +''', 112)                                               ' + char(10)
		SELECT @v_dSql += N'			  GROUP BY ISO_YYYYWW                                                                                           ' + char(10)
		SELECT @v_dSql += N'		) A                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = ''W'' THEN 1 ELSE 2 END), _DATE                                                   ' + char(10)

	END

	IF @p_sys_flag = 'DATE_TEMP'	-- find_date_tmp
	BEGIN

		SELECT @v_dSql += N'	SELECT '''+ @p_plan_date +''' AS PLAN_DATE                                    			' + char(10)
		SELECT @v_dSql += N'	       , '''+ @p_plan_date +''' AS PLAN_START_DATE                                     ' + char(10)
		SELECT @v_dSql += N'	       , (	SELECT 	CONVERT(VARCHAR,CONVERT(DATETIME,DATED7) + 29,112)      ' + char(10)
		SELECT @v_dSql += N'	       		FROM 	TH_UIS_CALENDAR K WITH(NOLOCK)                          ' + char(10)
		SELECT @v_dSql += N'	       		WHERE 	D0 = (                                                  ' + char(10)
		SELECT @v_dSql += N'	       						SELECT 	ISO_YYYYWW                              ' + char(10)
		SELECT @v_dSql += N'	       						FROM 	TH_UIS_CAL A WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	       						WHERE 	YYYYMMDD = '''+ @p_plan_date +'''                  ' + char(10)
		SELECT @v_dSql += N'	       					)                                                   ' + char(10)
		SELECT @v_dSql += N'	       	 ) AS PLAN_END_DATE                                                 ' + char(10)
	
	END

	IF @p_sys_flag = 'PLAN_INFO'	-- find_plan
	BEGIN

		SELECT @v_dSql += N'	SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME						' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_FP_PLAN_H A WITH(NOLOCK)                             ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1                                                      ' + char(10)
		SELECT @v_dSql += N'	AND    A.INSTANCE_ID = '''+ @p_sel_instance_id +'''                            ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR,A.PLAN_START_TIME,112) = '''+ @p_plan_date +'''     ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLAN_TYPE = ''PRE''                                    ' + char(10)
		SELECT @v_dSql += N'	AND    RIGHT(A.PLAN_ID,2) <> ''00''                             ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.PLAN_ID DESC                                         ' + char(10)
		
	END
	

	IF @p_sys_flag = 'CURR_DATE'	-- find_currdate
	BEGIN

		SELECT @v_dSql += N'	WITH SITE_T AS (																																																		' + char(10)		
		SELECT @v_dSql += N'	  SELECT DISTINCT A.INSTANCE_ID, A.SITE_ID                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  FROM FP_INSTANCE_INFO_V A WITH(NOLOCK)                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	  WHERE A.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	)                                                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	SELECT AA.CURR_DATE                                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	   , AA.CURR_DATE AS PLAN_START_DATE                                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	   , (SELECT CONVERT(VARCHAR,CONVERT(DATETIME,DATED7) + 29,112) FROM TH_UIS_CALENDAR K WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = (AA.CURR_DATE))) AS PLAN_END_DATE     ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'		SELECT (CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < (FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') + A.BASIS_START_TIME)                                                                ' + char(10)
		SELECT @v_dSql += N'						THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'')),112)                                                                                                          ' + char(10)
		SELECT @v_dSql += N'					  ELSE FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') END) AS CURR_DATE                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		FROM   FP_INSTANCE_START_TIME_V A, SITE_T B                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		WHERE  A.INSTANCE_ID = B.INSTANCE_ID                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	) AA                                                                                                                                                                                                                    ' + char(10)

	END

	IF @p_sys_flag = 'OPERATION_BOD'	-- find_operationBOD
	BEGIN

		SELECT @v_dSql += N'	-- BOD : item-operation 먼저 보고 없으면 opration 체크. 최종결과가 0 이면 기본 LT 인 1일을 지정															' + char(10)									
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'	   , (CASE WHEN A.MOVING_TIME_DAY IS NULL OR A.MOVING_TIME_DAY = 0 THEN 1 ELSE A.MOVING_TIME_DAY END) AS MOVING_TIME_DAY                                ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, ''-'' AS ITEM_ID                                                             ' + char(10)
		SELECT @v_dSql += N'		, MAX(CASE WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/1440)                                      ' + char(10)
		SELECT @v_dSql += N'	  		       WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/24)                                        ' + char(10)
		SELECT @v_dSql += N'	  		       WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(BB.BUFFER_TIME,0))                                           ' + char(10)
		SELECT @v_dSql += N'	  		       END) AS MOVING_TIME_DAY                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	FROM  SCM_OPERATION_MOVE_2_V A WITH(NOLOCK)                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	LEFT OUTER JOIN SCM_OPERATION_MOVE_M BB WITH(NOLOCK)                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	ON    A.COMPANY_ID    = BB.COMPANY_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND   A.DIVISION_ID   = BB.DIVISION_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND   A.SITE_ID       = BB.SITE_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	AND   A.PLANT_ID      = BB.PLANT_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	AND   A.FACTORY_ID    = BB.FACTORY_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND   A.OPERATION_ID  = BB.OPERATION_ID                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	AND   A.MODEL_TYPE    = BB.MODEL_TYPE                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND   ISNULL(BB.ACTIVE_FLAG, ''Y'')  = ''Y''                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	INNER HASH JOIN (                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'	    FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	    WHERE  1=1                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	    AND    A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	) CC                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	ON    A.COMPANY_ID    = CC.COMPANY_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND   A.DIVISION_ID   = CC.DIVISION_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND   A.SITE_ID       = CC.SITE_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	AND   A.PLANT_ID      = CC.PLANT_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	WHERE 1=1                                                                                                                                               ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += N'	AND    A.OPERATION_ID = ''F6000''                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'		 , MAX(CASE WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(A.BUFFER_TIME,0)/1440)                                       ' + char(10)
		SELECT @v_dSql += N'				WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(A.BUFFER_TIME,0)/24)                                             ' + char(10)
		SELECT @v_dSql += N'				WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(A.BUFFER_TIME,0))                                                ' + char(10)
		SELECT @v_dSql += N'				END) AS MOVING_TIME_DAY                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		INNER JOIN SCM_OPERATION_MOVE_2_V BB WITH(NOLOCK)                                                                                                   ' + char(10)
		SELECT @v_dSql += N'		ON    A.COMPANY_ID    = BB.COMPANY_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		AND   A.DIVISION_ID   = BB.DIVISION_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		AND   A.SITE_ID       = BB.SITE_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'		AND   A.PLANT_ID      = BB.PLANT_ID                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		AND   A.FACTORY_ID    = BB.FACTORY_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		AND   A.OPERATION_ID  = BB.OPERATION_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'		AND   A.MODEL_TYPE    = BB.MODEL_TYPE                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	INNER HASH JOIN (                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	    SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'	    FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	    WHERE  1=1                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'	    AND    A.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	) CC                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	ON    A.COMPANY_ID    = CC.COMPANY_ID                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND   A.DIVISION_ID   = CC.DIVISION_ID                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND   A.SITE_ID       = CC.SITE_ID                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'	AND   A.PLANT_ID      = CC.PLANT_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1                                                                                                                                              ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SELECT @v_dSql += N'	AND    A.OPERATION_ID = ''F6000''                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	AND    A.ACTIVE_FLAG = ''Y''                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'	) A                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	ORDER BY PLANT_ID, OPERATION_ID, (CASE WHEN ITEM_ID = ''-'' THEN 2 ELSE 1 END), ITEM_ID                                                                 ' + char(10)

	END
	
	IF @p_sys_flag = 'PLANT_FACTORY'	-- find_PlantFactory
	BEGIN

		SELECT @v_dSql += N'	SELECT DISTINCT 																		' + char(10)
		IF @p_sel_type = 'PLANT' BEGIN
			SELECT @v_dSql += N'	BB.PLANT_ID AS CODE, BB.PLANT_ID AS NAME         ' + char(10)
		END ELSE BEGIN
			SELECT @v_dSql += N'	BB.FACTORY_ID AS CODE, BB.FACTORY_ID AS NAME      ' + char(10)
		END
		SELECT @v_dSql += N'	FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK)                                            ' + char(10)
		SELECT @v_dSql += N'	INNER HASH JOIN SCM_FACTORY_M BB WITH(NOLOCK)                                           ' + char(10)
		SELECT @v_dSql += N'	ON     AA.FACTORY_ID   = BB.FACTORY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    BB.ACTIVE_FLAG  = ''Y''                                                          ' + char(10)
		SELECT @v_dSql += N'	WHERE  AA.INSTANCE_ID  = '''+ @p_sel_instance_id +'''                                                    ' + char(10)
		SELECT @v_dSql += N'	AND    AA.ACTIVE_FLAG  = ''Y''                                                          ' + char(10)

	END	

	IF @p_sys_flag = 'ADD_FACTORY'	-- find_PlantFactory
	BEGIN

		SELECT @v_dSql += N'	SELECT DISTINCT BB.FACTORY_ID AS CODE, BB.FACTORY_ID AS NAME, ''FAC'' AS _TYPE	' + char(10)
		SELECT @v_dSql += N'	FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK)                                    ' + char(10)
		SELECT @v_dSql += N'	INNER HASH JOIN SCM_FACTORY_M BB WITH(NOLOCK)                                   ' + char(10)
		SELECT @v_dSql += N'	ON     AA.FACTORY_ID   = BB.FACTORY_ID                                          ' + char(10)
		SELECT @v_dSql += N'	AND    BB.ACTIVE_FLAG  = ''Y''                                                  ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1                                                                      ' + char(10)
		SELECT @v_dSql += N'	AND    AA.INSTANCE_ID  = '''+ @p_sel_instance_id +'''                                          ' + char(10)
		SELECT @v_dSql += N'	AND    AA.ACTIVE_FLAG  = ''Y''                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('BB.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		SELECT @v_dSql += N'	ORDER BY 1                                                                      ' + char(10)

	END	

	IF @p_sys_flag = 'ADD_DUP'	-- find_add_dup
	BEGIN

		SELECT @v_dSql += N'	SELECT COUNT(*) AS CNT                						' + char(10)
		SELECT @v_dSql += N'	FROM   FP_CELL_MOVE_PLAN_H A WITH(NOLOCK)                   ' + char(10)
		
		SELECT @v_dSql += N'	WHERE  A.CATEGORY        = '''+ @p_category_type +'''                       ' + char(10)
		SELECT @v_dSql += N'	AND    A.COMPANY_ID      = '''+ @p_company_id +'''                     ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID     = '''+ @p_division_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID         = '''+ @p_site_id +'''                        ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLANT_ID        = '''+ @p_plant_id +'''                       ' + char(10)
		SELECT @v_dSql += N'	AND    A.ITEM_ID         = '''+ @p_item_id +'''                        ' + char(10)
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) = '''+ @p_plan_date +'''     ' + char(10)
		SELECT @v_dSql += N'	AND    A.CELL_FACTORY_ID = '''+ @p_cell_factory_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.PACK_FACTORY_ID = '''+ @p_pack_factory_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.QTY > 0                                            ' + char(10)

	END	

	IF @p_sys_flag = 'ADD_AUTH'	-- find_add_Auth
	BEGIN

		SELECT @v_dSql += N'	SELECT	A.*																							' + char(10)
		SELECT @v_dSql += N'			, R.FACTORY_ID AS PACK_FAC                                                                  ' + char(10)
		SELECT @v_dSql += N'			, R2.FACTORY_ID AS FORM_FAC                                                                 ' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                              ' + char(10)
		SELECT @v_dSql += N'			SELECT '''+ @p_pack_instance_id +''' AS PACK_INSTANCE_ID                                               ' + char(10)
		SELECT @v_dSql += N'			    	, '''+ @p_form_instance_id +''' AS FORM_INSTANCE_ID                                            ' + char(10)
		SELECT @v_dSql += N'			    	, '''+ @p_company_id +''' AS COMPANY_ID                                                        ' + char(10)
		SELECT @v_dSql += N'			    	, '''+ @p_division_id +''' AS DIVISION_ID                                                      ' + char(10)
		SELECT @v_dSql += N'			    	, '''+ @p_site_id +''' AS SITE_ID                                                              ' + char(10)
		SELECT @v_dSql += N'			    	, '''+ @p_plant_id +''' AS PLANT_ID                                                            ' + char(10)
		SELECT @v_dSql += N'			    	, '''+ @p_cell_factory_id +''' AS CELL_FACTORY_ID                                              ' + char(10)
		SELECT @v_dSql += N'			    	, '''+ @p_pack_factory_id +''' AS PACK_FACTORY_ID                                              ' + char(10)
		SELECT @v_dSql += N'		) A                                                                                             ' + char(10)
		SELECT @v_dSql += N'		LEFT OUTER  JOIN (                                                                              ' + char(10)
		SELECT @v_dSql += N'				  SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID      ' + char(10)
		SELECT @v_dSql += N'				  FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                             ' + char(10)
		SELECT @v_dSql += N'				  WHERE  1=1                                                                            ' + char(10)
		SELECT @v_dSql += N'				  AND    R.USER_ID   = '''+ @p_user_id +'''                                                        ' + char(10)
		SELECT @v_dSql += N'				  AND    R.SAVE_FLAG = ''Y''                                                            ' + char(10)
		SELECT @v_dSql += N'				  AND    R.INSTANCE_ID = '''+ @p_pack_instance_id +'''                                             ' + char(10)
		SELECT @v_dSql += N'		) R                                                                                             ' + char(10)
		SELECT @v_dSql += N'		ON  A.COMPANY_ID  = R.COMPANY_ID                                                                ' + char(10)
		SELECT @v_dSql += N'		AND A.DIVISION_ID = R.DIVISION_ID                                                               ' + char(10)
		SELECT @v_dSql += N'		AND A.SITE_ID     = R.SITE_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'		AND A.PLANT_ID    = R.PLANT_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'		AND A.PACK_FACTORY_ID = R.FACTORY_ID                                                            ' + char(10)
		SELECT @v_dSql += N'		LEFT OUTER JOIN (                                                                               ' + char(10)
		SELECT @v_dSql += N'				SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID        ' + char(10)
		SELECT @v_dSql += N'				FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                               ' + char(10)
		SELECT @v_dSql += N'				WHERE  1=1                                                                              ' + char(10)
		SELECT @v_dSql += N'				AND    R.USER_ID   = '''+ @p_user_id +'''                                                          ' + char(10)
		SELECT @v_dSql += N'				AND    R.SAVE_FLAG = ''Y''                                                              ' + char(10)
		SELECT @v_dSql += N'				AND    R.INSTANCE_ID = '''+ @p_form_instance_id +'''                                               ' + char(10)
		SELECT @v_dSql += N'		) R2                                                                                            ' + char(10)
		SELECT @v_dSql += N'		ON  A.COMPANY_ID  = R2.COMPANY_ID                                                               ' + char(10)
		SELECT @v_dSql += N'		AND A.DIVISION_ID = R2.DIVISION_ID                                                              ' + char(10)
		SELECT @v_dSql += N'		AND A.SITE_ID     = R2.SITE_ID                                                                  ' + char(10)
		SELECT @v_dSql += N'		AND A.PLANT_ID    = R2.PLANT_ID                                                                 ' + char(10)
		SELECT @v_dSql += N'		AND A.CELL_FACTORY_ID = R2.FACTORY_ID                                                           ' + char(10)

	END	

	IF @p_sys_flag = 'ADD_ITEM'	-- find_add_item
	BEGIN

		SELECT @v_dSql +=	N'	SELECT A.*                                                                									' + char(10)					
		SELECT @v_dSql +=	N'	FROM (                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'			  SELECT	DISTINCT D.COMPANY_ID, D.DIVISION_ID, D.SITE_ID, F.PLANT_ID, D.ITEM_ID, D.NICK_NAME     ' + char(10)
		SELECT @v_dSql +=	N'			  FROM  	SCM_ITEM_M D WITH(NOLOCK), SCM_ITEM_CLASS_M E WITH(NOLOCK)                              ' + char(10)
		SELECT @v_dSql +=	N'					  , (                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'					      	SELECT DISTINCT BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID              ' + char(10)
		SELECT @v_dSql +=	N'					      	FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK)                                        ' + char(10)
		SELECT @v_dSql +=	N'					      	INNER HASH JOIN SCM_FACTORY_M BB WITH(NOLOCK)                                       ' + char(10)
		SELECT @v_dSql +=	N'					      	ON     AA.FACTORY_ID   = BB.FACTORY_ID                                              ' + char(10)
		SELECT @v_dSql +=	N'					      	AND    BB.ACTIVE_FLAG  = ''Y''                                                      ' + char(10)
		SELECT @v_dSql +=	N'					      	WHERE  AA.INSTANCE_ID IN ( '''+ @p_form_instance_id +''' )                                     ' + char(10)
		SELECT @v_dSql +=	N'					      	AND    AA.ACTIVE_FLAG  = ''Y''                                                      ' + char(10)
		SELECT @v_dSql +=	N'					  ) F                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'			  WHERE  1=1                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'			  AND	 D.ITEM_CLASS  = E.CLASS_ID                                                                 ' + char(10)
		SELECT @v_dSql +=	N'			  AND    D.COMPANY_ID  = F.COMPANY_ID                                                               ' + char(10)
		SELECT @v_dSql +=	N'			  AND    D.DIVISION_ID = F.DIVISION_ID                                                              ' + char(10)
		SELECT @v_dSql +=	N'			  AND    D.SITE_ID     = F.SITE_ID                                                                  ' + char(10)
		SELECT @v_dSql +=	N'			  AND	 D.ACTIVE_FLAG = ''Y''                                                                      ' + char(10)
		SELECT @v_dSql +=	N'			  AND    E.USE_FLAG = ''Y''                                                                         ' + char(10)
		SELECT @v_dSql +=	N'			  AND    E.LEVEL_3_NAME = ''CELL''                                                                  ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('D.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SELECT @v_dSql +=	N'		) A                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'		INNER JOIN (                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'			SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID                                  ' + char(10)
		SELECT @v_dSql +=	N'			FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                           ' + char(10)
		SELECT @v_dSql +=	N'			WHERE  1=1                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'			AND	   R.USER_ID   = '''+ @p_user_id +'''                                                                      ' + char(10)
		SELECT @v_dSql +=	N'			AND	   R.SAVE_FLAG = ''Y''                                                                          ' + char(10)
		SELECT @v_dSql +=	N'		) R                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'		ON  A.COMPANY_ID  = R.COMPANY_ID                                                                        ' + char(10)
		SELECT @v_dSql +=	N'		AND A.DIVISION_ID = R.DIVISION_ID                                                                       ' + char(10)
		SELECT @v_dSql +=	N'		AND A.SITE_ID     = R.SITE_ID                                                                           ' + char(10)
		SELECT @v_dSql +=	N'		AND A.PLANT_ID    = R.PLANT_ID                                                                          ' + char(10)
		SELECT @v_dSql +=	N'	ORDER BY 1,2,3,4,5                                                                                          ' + char(10)

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
