

CREATE PROCEDURE [dbo].[PR_UI_FP00641_ETC]
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
/** 프로그램 ID   : PR_UI_FP00641_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00641_ETC                                               **/
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
/** 2022/09/28   CYS				Initial				                                      **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00641_ETC';
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
	DECLARE @p_all_line		NVARCHAR(MAX);
	DECLARE @p_confirm_area	NVARCHAR(MAX);
	DECLARE @p_amend_main_flag	NVARCHAR(MAX);
	DECLARE @p_past_plan_type	NVARCHAR(MAX);
	DECLARE @p_planner_yn	NVARCHAR(MAX);
	DECLARE @p_shop_type	NVARCHAR(MAX);
	DECLARE @p_cell_item_id	NVARCHAR(MAX);
	DECLARE @p_pack_item_id	NVARCHAR(MAX);
	DECLARE @p_item_in		NVARCHAR(MAX);
	DECLARE @p_group_cell_yn	NVARCHAR(MAX);
	DECLARE @p_group_cell_code	NVARCHAR(MAX);

	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);

	-- table
	DECLARE @p_amend_table	NVARCHAR(MAX);
	DECLARE @p_amend_sales_table		NVARCHAR(MAX);
	DECLARE @p_amend_cutoff_boh_table	NVARCHAR(MAX);
	DECLARE @p_amend_bor_table			NVARCHAR(MAX);
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
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_bucket_from
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
		END ELSE IF @tmp_column = 'ALL_LINE' BEGIN
			SET @p_all_line =			@tmp_value ;
		END ELSE IF @tmp_column = 'CONFIRM_AREA' BEGIN
			SET @p_confirm_area =		@tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_MAIN_FLAG' BEGIN
			SET @p_amend_main_flag =	@tmp_value ;
		END ELSE IF @tmp_column = 'PAST_PLAN_TYPE' BEGIN
			SET @p_past_plan_type  =	@tmp_value ;
		END ELSE IF @tmp_column = 'PLANNER_YN' BEGIN
			SET @p_planner_yn	  =	@tmp_value ;
		END ELSE IF @tmp_column = 'SHOP_TYPE' BEGIN
			SET @p_shop_type	  =	@tmp_value ;
		END ELSE IF @tmp_column = 'CELL_ITEM_ID' BEGIN
			SET @p_cell_item_id	  =	@tmp_value ;
		END ELSE IF @tmp_column = 'PACK_ITEM_ID' BEGIN
			SET @p_pack_item_id	  =	@tmp_value ;
		END ELSE IF @tmp_column = 'ITEM_IN' BEGIN
			SET @p_item_in =		@tmp_value ;
		END ELSE IF @tmp_column = 'GROUP_CELL_YN' BEGIN
			SET @p_group_cell_yn =		@tmp_value ;
		END ELSE IF @tmp_column = 'GROUP_CELL_CODE' BEGIN
			SET @p_group_cell_code	  =	@tmp_value ;

		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value ;
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value ;
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_month_info

		END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
			SET @p_amend_table =		@tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_SALES_TABLE' BEGIN
			SET @p_amend_sales_table =  @tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_CUTOFF_BOH_TABLE' BEGIN
			SET @p_amend_cutoff_boh_table =  @tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_BOR_TABLE' BEGIN
			SET @p_amend_bor_table =  @tmp_value ;
		END ELSE IF @tmp_column = 'RESULT_QTY' BEGIN
			SET @p_result_qty =		@tmp_value ;
		END

	END
	/*	Parameter Setting End */

	SET	@v_dSql = '';

	IF @p_sys_flag = 'INSTANCE'	-- findInstanceList_common
	BEGIN

		
		SELECT @v_dSql += N'	SELECT A.INSTANCE_ID AS CODE_ID, B.SEGMENT2 AS CODE_NAME, B.SORT_ORDER	' + char(10)
		SELECT @v_dSql += N'		   , B.ATTRIBUTE3 AS USE_WOW_STATUS                                 ' + char(10)
		SELECT @v_dSql += N'		   , B.ATTRIBUTE1 AS CONFIRM_AREA                                   ' + char(10)
		SELECT @v_dSql += N'		   , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID                                ' + char(10)
		SELECT @v_dSql += N'	FROM 	(                                                               ' + char(10)
		SELECT @v_dSql += N'		  		SELECT DISTINCT B.INSTANCE_ID                               ' + char(10)
		SELECT @v_dSql += N'		      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                   ' + char(10)
		SELECT @v_dSql += N'		      	WHERE  B.USER_ID     = '''+ @p_user_id +'''                 ' + char(10)
		SELECT @v_dSql += N'			) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                        ' + char(10)
		SELECT @v_dSql += N'	WHERE A.INSTANCE_ID      = B.SEGMENT1                                   ' + char(10)
		SELECT @v_dSql += N'	AND   B.LOOKUP_TYPE_CODE = '''+ @p_instance_id +'''                     ' + char(10)
		SELECT @v_dSql += N'	AND   B.SEGMENT1 IN (                                                   ' + char(10)
		SELECT @v_dSql += N'						  SELECT  A.SEGMENT1                                ' + char(10)
		SELECT @v_dSql += N'						  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
		SELECT @v_dSql += N'						  WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI'' ' + char(10)
		SELECT @v_dSql += N'						  AND    A.ATTRIBUTE1       = ''PSI AMEND UI''      ' + char(10)
		SELECT @v_dSql += N'					    )                                                   ' + char(10)
		SELECT @v_dSql += N'	ORDER BY B.SORT_ORDER                                                   ' + char(10)

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

	IF @p_sys_flag = 'PLAN_INFO'	-- findFpPlan_info
	BEGIN

		SELECT @v_dSql += N'	WITH RELEASE_PLAN AS (                           																																									' + char(10)
		SELECT @v_dSql += N'							  SELECT DISTINCT                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'							         A.INSTANCE_ID                                                                                                                                                                      ' + char(10)
		SELECT @v_dSql += N'							        ,A.RELEASE_PLAN_ID AS PLAN_ID                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							        ,STUFF(( SELECT '','' + FACTORY_ID                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'							                 FROM   FP_RELEASE_PLAN_INFO_H B                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'							                 WHERE  A.INSTANCE_ID     = B.INSTANCE_ID                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							                 AND    A.INSTANCE_DATE   = B.INSTANCE_DATE                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'							                 AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'							                 FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'							        ,A.PLAN_GROUP_ID                                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'							        ,A.INSTANCE_DATE AS PLAN_DATE                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							  FROM   FP_RELEASE_PLAN_INFO_H A                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'							  WHERE  1=1                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_DATE' , 'EQ', @p_plan_date)) + char(10)
		SELECT @v_dSql += N'						)                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT 	A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_ID                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_TYPE                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_START_TIME                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_HORIZON                                                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_HORIZON_UOM                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		    ,A.DEMAND_HORIZON                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    ,A.DEMAND_HORIZON_UOM                                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		    ,A.CONFIG_SET_ID                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		    ,A.BASIS_PLAN_ID                                                                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		    ,A.DEMAND_PLAN_ID                                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    ,A.SCP_PLAN_ID                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_WEEK                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'		    --,CONVERT(VARCHAR(8), DATEADD(DAY,-28, A.PLAN_START_TIME), 112) AS PLAN_START_DATE                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		    --,CONVERT(VARCHAR(8), DATEADD(DAY, 55, A.PLAN_START_TIME), 112) AS PLAN_END_DATE                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @p_plan_date +''')) AS PLAN_START_DATE                                                        ' + char(10)
		SELECT @v_dSql += N'		    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @p_plan_date +''')))), 112) AS PLAN_END_DATE     ' + char(10)
		SELECT @v_dSql += N'		    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @p_plan_date +''')) AS DEFAULT_START_DATE                                                     ' + char(10)
		SELECT @v_dSql += N'		    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @p_plan_date +''')))), 112) AS DEFAULT_END_DATE  ' + char(10)
		SELECT @v_dSql += N'		    ,CONVERT(VARCHAR, DATEADD(DD, D.ATTRIBUTE15 * 7, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @p_plan_date +''')))), 112) AS UI_END_DATE  ' + char(10)
		SELECT @v_dSql += N'		    ,A.INSTANCE_ID                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,A.SITE_ID                                                                                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'		    ,A.DESCRIPTION                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,A.PLAN_TYPE                                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'		    ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		    ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME                                                                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		    ,CASE WHEN A.RELEASE_FLAG = ''Y''                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		    	  THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID )                                                                    ' + char(10)
		SELECT @v_dSql += N'		    	  ELSE A.DESCRIPTION END AS DESCS                                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'		    ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		    ,C.FACTORY_LT                                                                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'		    ,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''Y''	 WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) AS READ_ONLY  ' + char(10)
		SELECT @v_dSql += N'	FROM   	SCM_FP_PLAN_H A WITH(NOLOCK)                                                                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK)                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			ON  A.INSTANCE_ID = C.INSTANCE_ID                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND A.PLAN_ID = C.PLAN_ID                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK)                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'			ON	A.INSTANCE_ID = D.SEGMENT1                                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND D.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			AND D.ACTIVE_FLAG = ''Y''                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	WHERE  1=1                                                                                                                                                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CONVERT(VARCHAR(8), PLAN_START_TIME, 112)' , 'EQ', @p_plan_date)) + char(10)
		--IF @p_plan_date <> '' BEGIN
		--	SELECT @v_dSql += N'	AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = '''+ @p_plan_date +'''                                                                                                                                                    ' + char(10)
		--END
		SELECT @v_dSql += N'	ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC                                                                                                                                                ' + char(10)

	END

	IF @p_sys_flag = 'LIST_DATA'	-- find_ListData
	BEGIN
		SELECT @v_dSql += N'	SELECT A.INSTANCE_ID, A.FP_PLAN_ID																								' + char(10)
		SELECT @v_dSql += N'			, A.COMPANY_ID, A.DIVISION_ID, A.CATEGORY_ID, A.SITE_ID, A.PLANT_ID                                                     ' + char(10)
		SELECT @v_dSql += N'			, A.ITEM_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.MARKET, A.FACTORY_ID                                                  ' + char(10)
		SELECT @v_dSql += N'			, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_TYPE    ' + char(10)
		SELECT @v_dSql += N'			, A.IN_QTY, A.OUT_QTY                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	FROM   '+ @p_amend_table +' A WITH(NOLOCK)                                                                                      ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''																                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.CATEGORY_ID  = ''PLAN''                                                                                                ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE          ' + char(10)
		SELECT @v_dSql += N'	      ,A.ITEM_ID, A.ITEM_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE                                                         ' + char(10)
	END

	IF @p_sys_flag = 'LIST_DATA_BOH'	-- find_ListData_BOH
	BEGIN
		SELECT @v_dSql += N'	SELECT	A.INSTANCE_ID, A.FP_PLAN_ID							' + char(10)
		SELECT @v_dSql += N'	   		, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID            ' + char(10)
		SELECT @v_dSql += N'		   	, A.PLANT_ID, A.ITEM_ID, A.TOP_ITEM_ID              ' + char(10)
		SELECT @v_dSql += N'		   	, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION          ' + char(10)
		SELECT @v_dSql += N'		   	, ISNULL(ISNULL(A.MODIFY_QTY, A.QTY), 0) AS QTY     ' + char(10)
		SELECT @v_dSql += N'		   	, '''+ @p_plan_date +''' AS PLAN_DATE                          ' + char(10)
		SELECT @v_dSql += N'	FROM   '+ @p_amend_cutoff_boh_table +' A WITH(NOLOCK)       ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''              ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'			, A.FACTORY_ID, A.OPERATION_ID, A.LOCATION          ' + char(10)
	END

	IF @p_sys_flag = 'AGING_YIELD'	-- find_YieldInfo
	BEGIN
		SELECT @v_dSql +=	N'	-- T_AGING_YIELD               ' + char(10)
		SELECT @v_dSql +=	N'	SELECT		A.COMPANY_ID 																																																			' + char(10)
		SELECT @v_dSql +=	N'				, A.DIVISION_ID                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'				, A.SITE_ID                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'				, A.PLANT_ID                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'				, A.FACTORY_ID                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'				, A.LINE_ID                                                                                                           ' + char(10)
		--SELECT @v_dSql +=	N'				, A.ITEM_ID                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'				, B.CELL_PRODUCT_ITEM_ID AS ITEM_ID ' + char(10) -- cell prduct 로 비교
		SELECT @v_dSql +=	N'				, A.MONTH                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'				, A.FORMATION1_YIELD                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				, A.DEGAS_YIELD                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'				, A.FORMATION2_YIELD                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'				, A.GRADE_YIELD                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'				, A.FORMATION1_YIELD * A.DEGAS_YIELD  AS BEFORE_DEGAS_YIELD                                                           ' + char(10)
		SELECT @v_dSql +=	N'				, A.FORMATION2_YIELD * A.GRADE_YIELD  AS AFTER_DEGAS_YIELD                                                            ' + char(10)
		SELECT @v_dSql +=	N'				, A.F6000_YIELD                                                            ' + char(10)
		SELECT @v_dSql +=	N'	FROM (                                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'				SELECT 	  A.COMPANY_ID                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'							, A.DIVISION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'							, A.SITE_ID                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'							, A.PLANT_ID                                                                                                    ' + char(10)
		SELECT @v_dSql +=	N'							, A.FACTORY_ID                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'							, A.R_LINE_ID AS LINE_ID                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'							, A.ITEM_ID                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'							, A.MONTH                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'							, CASE WHEN SUM(FORMATION1_YIELD) <= 0 THEN 1 ELSE  SUM(FORMATION1_YIELD)  END AS FORMATION1_YIELD              ' + char(10)
		SELECT @v_dSql +=	N'							, CASE WHEN SUM(DEGAS_YIELD) <= 0 THEN 1 ELSE  SUM(DEGAS_YIELD)  END AS DEGAS_YIELD                             ' + char(10)
		SELECT @v_dSql +=	N'							, CASE WHEN SUM(FORMATION2_YIELD) <= 0 THEN 1 ELSE  SUM(FORMATION2_YIELD)  END AS FORMATION2_YIELD              ' + char(10)
		SELECT @v_dSql +=	N'							, CASE WHEN SUM(GRADE_YIELD) <= 0 THEN 1 ELSE  SUM(GRADE_YIELD)  END AS GRADE_YIELD                             ' + char(10)
		SELECT @v_dSql +=	N'							, CASE WHEN SUM(F6000_YIELD) <= 0 THEN 1 ELSE  SUM(F6000_YIELD)  END AS F6000_YIELD                             ' + char(10)
		SELECT @v_dSql +=	N'				FROM (                                                                                                                ' + char(10)
		SELECT @v_dSql +=	N'							SELECT	A.*                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'									, CASE WHEN A.OPERATION_ID = ''F1000'' THEN A.YIELD ELSE 0 END AS FORMATION1_YIELD	                        ' + char(10)
		SELECT @v_dSql +=	N'									, CASE WHEN A.OPERATION_ID = ''F4000'' THEN A.YIELD ELSE 0 END AS DEGAS_YIELD	                              ' + char(10)
		SELECT @v_dSql +=	N'									, CASE WHEN A.OPERATION_ID = ''F4500'' THEN A.YIELD ELSE 0 END AS FORMATION2_YIELD	                        ' + char(10)
		SELECT @v_dSql +=	N'									, CASE WHEN A.OPERATION_ID = ''F4700'' THEN A.YIELD ELSE 0 END AS GRADE_YIELD	                              ' + char(10)
		SELECT @v_dSql +=	N'									, CASE WHEN A.OPERATION_ID = ''F6000'' THEN A.YIELD ELSE 0 END AS F6000_YIELD	                              ' + char(10)
		SELECT @v_dSql +=	N'							FROM (                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'										SELECT	A.* , ISNULL(C.SEGMENT5,A.LINE_ID)   AS R_LINE_ID                                                 ' + char(10)
		SELECT @v_dSql +=	N'										FROM		SCM_YIELD_M A WITH(NOLOCK)                                                  ' + char(10)
		SELECT @v_dSql +=	N'													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C                                                              ' + char(10)
		SELECT @v_dSql +=	N'														ON  C.LOOKUP_TYPE_CODE = ''FORMATION_LINE_REPLACEMENT''                                           ' + char(10)
		SELECT @v_dSql +=	N'														AND C.ACTIVE_FLAG = ''Y''                                                                         ' + char(10)
		SELECT @v_dSql +=	N'														AND A.COMPANY_ID = C.SEGMENT1                                                                     ' + char(10)
		SELECT @v_dSql +=	N'														AND A.DIVISION_ID =  C.SEGMENT2                                                                   ' + char(10)
		SELECT @v_dSql +=	N'														AND A.SITE_ID =  C.SEGMENT3                                                                       ' + char(10)
		SELECT @v_dSql +=	N'														AND A.LINE_ID = C.SEGMENT4                                                                        ' + char(10)
		SELECT @v_dSql +=	N'														,                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'													(                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'														SELECT	SEGMENT1+''F6000'' AS  SEGMENT1                    ' + char(10)
		SELECT @v_dSql +=	N'														FROM	SCM_SYS_LOOKUP_VALUE                                                                        ' + char(10)
		SELECT @v_dSql +=	N'														WHERE	LOOKUP_TYPE_CODE = ''FORMATION_YILED_DEFINE''                                               ' + char(10)
		SELECT @v_dSql +=	N'														AND		SEGMENT3	= ''FORMATION_TOTAL_YIELD''                                                       ' + char(10)
		SELECT @v_dSql +=	N'														AND 	ACTIVE_FLAG = ''Y''                                                                         ' + char(10)
		SELECT @v_dSql +=	N'													) B                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'										WHERE 1=1                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'										AND		A.SITE_ID = '''+ @p_site_id +'''                         ' + char(10)
		SELECT @v_dSql +=	N'										AND		B.SEGMENT1 LIKE ''%''+A.OPERATION_ID +''%''                                                         ' + char(10)
		SELECT @v_dSql +=	N'										AND 	A.MONTH BETWEEN CONVERT(NVARCHAR(6), '''+ @p_bucket_from +''', 112) AND CONVERT(NVARCHAR(6), '''+ @p_bucket_to +''', 112)		' + char(10)
		SELECT @v_dSql +=	N'							) A                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'						) A			                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'				GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID ,  A.R_LINE_ID , A.ITEM_ID , A.MONTH    ' + char(10)
		SELECT @v_dSql +=	N'			) A                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'	INNER JOIN FP_CELL_ASSY_PRODUCT_MAP_V B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql +=	N'	ON  1=1 ' + char(10)
		SELECT @v_dSql +=	N'	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql +=	N'	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql +=	N'	AND A.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql +=	N'	AND A.ITEM_ID     = B.CELL_ASSY_ITEM_ID ' + char(10) -- cell assy 기준정보
		SELECT @v_dSql +=	N'	WHERE 1=1                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'	      ;               ' + char(10)
	END
	
	IF @p_sys_flag = 'AGING_LT'	-- find_YieldInfo
	BEGIN

		--SELECT @v_dSql +=	N'	SELECT	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, ROUTE_TYPE																																		' + char(10)
		--SELECT @v_dSql +=	N'			, MAX(CEILING(STANDARD_LT/1440)) AS STANDARD_LT, MAX(CEILING(STANDARD_LT_SUM/1440)) AS STANDARD_LT_SUM                                                      ' + char(10)
		SELECT @v_dSql +=	N'	SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID ' + char(10)
		SELECT @v_dSql +=	N'		  , B.CELL_PRODUCT_ITEM_ID AS ITEM_ID ' + char(10) -- cell prduct 로 비교
		SELECT @v_dSql +=	N'		  , A.ROUTE_TYPE ' + char(10)
		SELECT @v_dSql +=	N'		  , MAX(CEILING(A.STANDARD_LT/1440)) AS STANDARD_LT, MAX(CEILING(A.STANDARD_LT_SUM/1440)) AS STANDARD_LT_SUM ' + char(10)
		SELECT @v_dSql +=	N'	FROM	(                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'				SELECT 	 COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ROUTE_ID, LINE_ID, ITEM_ID, ROUTE_TYPE, STANDARD_LT                                      ' + char(10)
		SELECT @v_dSql +=	N'							, SUM( ISNULL(STANDARD_LT,0) ) OVER  (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID ) AS STANDARD_LT_SUM    ' + char(10)
		SELECT @v_dSql +=	N'				FROM 	(                                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'								SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ROUTE_ID, LINE_ID, ITEM_ID, ROUTE_TYPE,                                           ' + char(10)
		SELECT @v_dSql +=	N'											SUM(ISNULL(STANDARD_LT,0)) AS STANDARD_LT                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'								FROM	SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'								WHERE	1=1                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'								AND		DEFAULT_ROUTE = ''Y''            -- DEFAULT_ROUTE 가 있는 기종이 대상                                                                       ' + char(10)
		SELECT @v_dSql +=	N'								AND		STANDARD_LT IS NOT NULL        -- ISNULL 0 하면 안됨, NULL 과 0 은 대상이 다름..                                                            ' + char(10)
		SELECT @v_dSql +=	N'								AND		EXISTS (	-- ROUTE : LINE 는 1:1 이며 복수일 경우 MIN 으로 처리 2020-01-09 BY CYS                                                           ' + char(10)
		SELECT @v_dSql +=	N'												SELECT 1                                                                                                                                  ' + char(10)
		SELECT @v_dSql +=	N'												FROM	(                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'															SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, ROUTE_TYPE, MIN(ROUTE_ID) AS ROUTE_ID             ' + char(10)
		SELECT @v_dSql +=	N'															FROM 	SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)								                                                                          ' + char(10)
		SELECT @v_dSql +=	N'															WHERE	1=1                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'															AND		A.SITE_ID = '''+ @p_site_id +'''                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'															AND		ROUTE_TYPE IN ( ''C'', ''D'')                                                                                                 ' + char(10)
		SELECT @v_dSql +=	N'															AND		DEFAULT_ROUTE = ''Y''                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'															GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, ROUTE_TYPE                                       ' + char(10)
		SELECT @v_dSql +=	N'														) B                                                                                                                                   ' + char(10)
		SELECT @v_dSql +=	N'												WHERE	A.COMPANY_ID	= B.COMPANY_ID                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.DIVISION_ID	= B.DIVISION_ID                                                                                                       ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.SITE_ID		= B.SITE_ID                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.PLANT_ID		= B.PLANT_ID                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.FACTORY_ID	= B.FACTORY_ID	                                                                                                      ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.ITEM_ID		= B.ITEM_ID	                                                                                                            ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.LINE_ID		= B.LINE_ID                                                                                                             ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.ROUTE_ID		= B.ROUTE_ID                                                                                                          ' + char(10)
		SELECT @v_dSql +=	N'												AND		A.ROUTE_TYPE	= B.ROUTE_TYPE                                                                                                        ' + char(10)
		SELECT @v_dSql +=	N'											)                                                                                                                                           ' + char(10)
		SELECT @v_dSql +=	N'							GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ROUTE_ID, LINE_ID, ITEM_ID, ROUTE_TYPE                                             ' + char(10)
		SELECT @v_dSql +=	N'					) A                                                                                                                                                     ' + char(10)
		SELECT @v_dSql +=	N'			) A                                                                                                                                                         ' + char(10)
		SELECT @v_dSql +=	N'	INNER JOIN FP_CELL_ASSY_PRODUCT_MAP_V B WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql +=	N'	ON  1=1 ' + char(10)
		SELECT @v_dSql +=	N'	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql +=	N'	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql +=	N'	AND A.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql +=	N'	AND A.ITEM_ID     = B.CELL_ASSY_ITEM_ID ' + char(10) -- cell assy 기준정보
		SELECT @v_dSql +=	N'	WHERE 1=1                                                                                                                                                       ' + char(10)
		--SELECT @v_dSql +=	N'	GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ITEM_ID, ROUTE_TYPE                                                                   ' + char(10)
		SELECT @v_dSql +=	N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, B.CELL_PRODUCT_ITEM_ID, A.ROUTE_TYPE ' + char(10)
		SELECT @v_dSql +=	N'	;                                                                                                                                                               ' + char(10)

	END

	-- 재고 상세 데이터
	IF @p_sys_flag = 'INV_DETAIL'
	BEGIN
		
		SET	@v_dSql = ''

		BEGIN
			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#T_ITEM'') IS NOT NULL ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #T_ITEM ' + char(10)

			SELECT @v_dSql += N'IF OBJECT_ID(''tempdb..#T_BOM_INFO'') IS NOT NULL  ' + char(10)
			SELECT @v_dSql += N'DROP TABLE #T_BOM_INFO ' + char(10)
		END

		SELECT @v_dSql +=	N'	SELECT *																																																		' + char(10)
		SELECT @v_dSql +=	N'	INTO #T_ITEM                                ' + char(10)
		SELECT @v_dSql +=	N'	FROM (                                      ' + char(10)
		SELECT @v_dSql +=	N'			SELECT CC.COMPANY_ID, CC.DIVISION_ID, CC.SITE_ID, CC.ITEM_ID, CC.NICK_NAME, CC.ITEM_CLASS, CC.FLOW_ID, DD.CLASS_NAME  ' + char(10)
		SELECT @v_dSql +=	N'					, DD.LEVEL_1_CODE , DD.LEVEL_1_NAME , DD.LEVEL_1_ID                                                 ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_2_CODE , DD.LEVEL_2_NAME , DD.LEVEL_2_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_3_CODE , DD.LEVEL_3_NAME , DD.LEVEL_3_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_4_CODE , DD.LEVEL_4_NAME , DD.LEVEL_4_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_5_CODE , DD.LEVEL_5_NAME , DD.LEVEL_5_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'					, ''PACK'' AS SHOP_FLAG             ' + char(10)
		SELECT @v_dSql +=	N'			FROM   SCM_ITEM_M CC WITH(NOLOCK),	SCM_ITEM_CLASS_M DD WITH(NOLOCK)                                    ' + char(10)
		SELECT @v_dSql +=	N'			WHERE  1=1                              ' + char(10)
		SELECT @v_dSql +=	N'			AND	   CC.SITE_ID = '''+ @p_site_id +'''                                                                    ' + char(10)
		SELECT @v_dSql +=	N'			AND    CC.ITEM_CLASS  = DD.CLASS_ID        ' + char(10)
		SELECT @v_dSql +=	N'			AND    CC.ACTIVE_FLAG = ''Y''           ' + char(10)
		SELECT @v_dSql +=	N'			AND    DD.USE_FLAG    = ''Y''           ' + char(10)
		SELECT @v_dSql +=	N'			AND    DD.LEVEL_3_NAME IN (''Pack'', ''Module'' )                                                       ' + char(10)
		SELECT @v_dSql +=	N'			AND    LEFT(ISNULL(CC.FLOW_ID,''Z''),5)  IN ( ''P9500'',''P5500'')                                      ' + char(10)
		SELECT @v_dSql +=	N'			UNION ALL                               ' + char(10)
		SELECT @v_dSql +=	N'			SELECT CC.COMPANY_ID, CC.DIVISION_ID, CC.SITE_ID, CC.ITEM_ID, CC.NICK_NAME, CC.ITEM_CLASS, CC.FLOW_ID, DD.CLASS_NAME  ' + char(10)
		SELECT @v_dSql +=	N'					, DD.LEVEL_1_CODE , DD.LEVEL_1_NAME , DD.LEVEL_1_ID                                                 ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_2_CODE , DD.LEVEL_2_NAME , DD.LEVEL_2_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_3_CODE , DD.LEVEL_3_NAME , DD.LEVEL_3_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_4_CODE , DD.LEVEL_4_NAME , DD.LEVEL_4_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'	  				, DD.LEVEL_5_CODE , DD.LEVEL_5_NAME , DD.LEVEL_5_ID                                               ' + char(10)
		SELECT @v_dSql +=	N'					, ''CELL'' AS SHOP_FLAG             ' + char(10)
		SELECT @v_dSql +=	N'			FROM   SCM_ITEM_M CC WITH(NOLOCK), SCM_ITEM_CLASS_M DD WITH(NOLOCK)                                     ' + char(10)
		SELECT @v_dSql +=	N'			WHERE  1=1                              ' + char(10)
		SELECT @v_dSql +=	N'			AND	   CC.SITE_ID = '''+ @p_site_id +'''          ' + char(10)
		SELECT @v_dSql +=	N'			AND    CC.ITEM_CLASS  = DD.CLASS_ID        ' + char(10)
		SELECT @v_dSql +=	N'			AND    CC.ACTIVE_FLAG = ''Y''           ' + char(10)
		SELECT @v_dSql +=	N'			AND    DD.USE_FLAG    = ''Y''           ' + char(10)
		SELECT @v_dSql +=	N'			AND    LEFT(ISNULL(CC.FLOW_ID,''Z''),5) IN (''A9000'')                                                  ' + char(10)
		SELECT @v_dSql +=	N'			AND    DD.LEVEL_3_NAME = ''Cell''          ' + char(10)
		SELECT @v_dSql +=	N'		) A                                       ' + char(10)
		SELECT @v_dSql +=	N'	WHERE 1=1                                   ' + char(10)
		SELECT @v_dSql +=	N'	;                                   				' + char(10)

		IF @p_shop_type = 'PACK' BEGIN
				SELECT @v_dSql +=	N'	      	-- BOM ?? ?? :  1?? --                                       ' + char(10)
				SELECT @v_dSql +=	N'	        SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                                                   ' + char(10)
				SELECT @v_dSql +=	N'	      			, A.PARENT_ITEM_ID, A.PARENT_UOM                         ' + char(10)
				SELECT @v_dSql +=	N'	      			, A.CHILD_ITEM_ID AS P5000_ITEM_ID, A.CHILD_UOM          ' + char(10)
				SELECT @v_dSql +=	N'	      			, A.CHILD_QTY/A.PARENT_QTY AS BOM_RATE_P5000             ' + char(10)
				SELECT @v_dSql +=	N'	      			, A.ALT_ID, A.ALT_PRIORITY                               ' + char(10)
				SELECT @v_dSql +=	N'	      			, A.EFF_START_DATE, A.EFF_END_DATE                       ' + char(10)
				SELECT @v_dSql +=	N'	      			, B.CHILD_ITEM_ID AS CELL_ITEM_ID , B.BOM_RATE_CELL ,B.ALT_ID AS CELL_ALT_ID, B.ALT_PRIORITY AS CELL_ALT_PRIORITY -- BOM_RATE_CELL ?? cell request ? ??                 ' + char(10)
				SELECT @v_dSql +=	N'	      			--, B.FACTORY_ID                                           ' + char(10)
				SELECT @v_dSql +=	N'	      			, B.MONTH , B.PRIORITY                                   ' + char(10)
				SELECT @v_dSql +=	N'	      			, CASE WHEN B.PRIORITY IS NULL THEN 99 ELSE B.PRIORITY END S1                                                            ' + char(10)
				SELECT @v_dSql +=	N'	      			, CASE WHEN B.ALT_PRIORITY IS NULL THEN 99 ELSE B.ALT_PRIORITY END S2                                                    ' + char(10)
				SELECT @v_dSql +=	N'	      			, CASE WHEN A.ALT_PRIORITY IS NULL THEN 99 ELSE A.ALT_PRIORITY END S3                                                    ' + char(10)
				SELECT @v_dSql +=	N'	      			, RANK() OVER(  PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID , A.EFF_START_DATE, A.EFF_END_DATE                                    ' + char(10)
				SELECT @v_dSql +=	N'	              							ORDER BY    CASE WHEN B.PRIORITY IS NULL THEN 99 ELSE B.PRIORITY END                                     ' + char(10)
				SELECT @v_dSql +=	N'	              									,	CASE WHEN B.ALT_PRIORITY IS NULL THEN 99 ELSE B.ALT_PRIORITY END                                   ' + char(10)
				SELECT @v_dSql +=	N'	              									,	CASE WHEN A.ALT_PRIORITY IS NULL THEN 99 ELSE A.ALT_PRIORITY END                                   ' + char(10)
				SELECT @v_dSql +=	N'	              					 ) RNK                                       ' + char(10)
				SELECT @v_dSql +=	N'	      	INTO	#T_BOM_INFO                              ' + char(10)
				SELECT @v_dSql +=	N'	      	FROM	SCM_BOM_M A WITH(NOLOCK)                               ' + char(10)
				SELECT @v_dSql +=	N'	      			INNER  JOIN ( --: PACK ITEM ????                         ' + char(10)
				SELECT @v_dSql +=	N'	      							SELECT	A.*                                          ' + char(10)
				SELECT @v_dSql +=	N'									FROM	#T_ITEM A                                          ' + char(10)
				SELECT @v_dSql +=	N'									WHERE	1=1                                                ' + char(10)
				SELECT @v_dSql +=	N'									AND		A.SHOP_FLAG = ''PACK''                             ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_pack_item_id))       + char(10)
				SELECT @v_dSql +=	N'	      			) CC          ' + char(10)
				SELECT @v_dSql +=	N'	      			ON   1=1                                                     ' + char(10)
				SELECT @v_dSql +=	N'	      			AND  A.COMPANY_ID  = CC.COMPANY_ID                           ' + char(10)
				SELECT @v_dSql +=	N'	      			AND  A.DIVISION_ID = CC.DIVISION_ID                          ' + char(10)
				SELECT @v_dSql +=	N'	      			AND  A.SITE_ID     = CC.SITE_ID                              ' + char(10)
				SELECT @v_dSql +=	N'	      			AND  A.PARENT_ITEM_ID = CC.ITEM_ID                           ' + char(10)
				SELECT @v_dSql +=	N'	      			INNER  JOIN ( ---B: CELL ITEM ??                         ' + char(10)
				SELECT @v_dSql +=	N'	      					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.PARENT_ITEM_ID , A.CHILD_ITEM_ID , A.CHILD_QTY/A.PARENT_QTY AS BOM_RATE_CELL , A.ALT_ID, A.ALT_PRIORITY, A.ALT_RATE, A.EFF_START_DATE , A.EFF_END_DATE                   ' + char(10)
				SELECT @v_dSql +=	N'	      							, B1.MONTH , B1.PRIORITY	-- , B1.FACTORY_ID               ' + char(10)
				SELECT @v_dSql +=	N'	      					FROM    SCM_BOM_M A WITH(NOLOCK)                         ' + char(10)
				SELECT @v_dSql +=	N'	      							INNER HASH JOIN  (                                       ' + char(10)
				SELECT @v_dSql +=	N'											SELECT	A.*                                              ' + char(10)
				SELECT @v_dSql +=	N'											FROM	#T_ITEM A                                          ' + char(10)
				SELECT @v_dSql +=	N'											WHERE	1=1                                                ' + char(10)
				SELECT @v_dSql +=	N'											AND		A.SHOP_FLAG = ''CELL''                             ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_cell_item_id))       + char(10)
				SELECT @v_dSql +=	N'	      							) EE                                                     ' + char(10)
				SELECT @v_dSql +=	N'	      							ON   1=1                                                 ' + char(10)
				SELECT @v_dSql +=	N'	      							AND  A.COMPANY_ID  = EE.COMPANY_ID                       ' + char(10)
				SELECT @v_dSql +=	N'	      							AND  A.DIVISION_ID = EE.DIVISION_ID                      ' + char(10)
				SELECT @v_dSql +=	N'	      							AND  A.SITE_ID     = EE.SITE_ID                          ' + char(10)
				SELECT @v_dSql +=	N'	      							AND  A.CHILD_ITEM_ID = EE.ITEM_ID                        ' + char(10)
				SELECT @v_dSql +=	N'	      							LEFT OUTER HASH JOIN ( --- ???? LINE ASSIGN? ?? ? ???.                                                                   ' + char(10)
				SELECT @v_dSql +=	N'	      								SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,  A.MONTH, A.PRIORITY	-- , A.FACTORY_ID , B.ASSY_FACTORY_ID                                        ' + char(10)
				SELECT @v_dSql +=	N'							    		FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)          ' + char(10)
				SELECT @v_dSql +=	N'	      								WHERE 1=1                                            ' + char(10)
				SELECT @v_dSql +=	N'										AND	  A.SITE_ID = '''+ @p_site_id +'''                               ' + char(10)
				SELECT @v_dSql +=	N'	          							AND   A.ACTIVE_FLAG = ''Y''                        ' + char(10)
				SELECT @v_dSql +=	N'	          							AND   A.MONTH BETWEEN SUBSTRING('''+ @p_bucket_from +''',1,6) AND SUBSTRING('''+ @p_bucket_to +''',1,6)                                  ' + char(10)
				SELECT @v_dSql +=	N'	          							AND   A.PRIORITY NOT IN (0,9)                      ' + char(10)
				SELECT @v_dSql +=	N'									) B1                                                 ' + char(10)
				SELECT @v_dSql +=	N'									ON    1=1                                            ' + char(10)
				SELECT @v_dSql +=	N'									AND   A.COMPANY_ID     = B1.COMPANY_ID               ' + char(10)
				SELECT @v_dSql +=	N'									AND   A.DIVISION_ID    = B1.DIVISION_ID              ' + char(10)
				SELECT @v_dSql +=	N'									AND   A.SITE_ID        = B1.SITE_ID                  ' + char(10)
				SELECT @v_dSql +=	N'									AND   A.CHILD_ITEM_ID  = B1.ITEM_ID                  ' + char(10)
				SELECT @v_dSql +=	N'									AND   B1.MONTH <   = CONVERT(VARCHAR(6),A.EFF_END_DATE,112)                                                          ' + char(10)
				SELECT @v_dSql +=	N'	      					WHERE 1=1                                                ' + char(10)
				SELECT @v_dSql +=	N'							AND	  A.SITE_ID = '''+ @p_site_id +'''                                   ' + char(10)
				SELECT @v_dSql +=	N'	      					AND   CONVERT(NVARCHAR(8),A.EFF_END_DATE,112) > '''+ @p_plan_date +'''                                                              ' + char(10)
				SELECT @v_dSql +=	N'					) B           ' + char(10)
				SELECT @v_dSql +=	N'					ON    1=1                                                    ' + char(10)
				SELECT @v_dSql +=	N'					AND   A.COMPANY_ID     = B.COMPANY_ID                        ' + char(10)
				SELECT @v_dSql +=	N'					AND   A.DIVISION_ID    = B.DIVISION_ID                       ' + char(10)
				SELECT @v_dSql +=	N'					AND   A.SITE_ID        = B.SITE_ID                           ' + char(10)
				SELECT @v_dSql +=	N'					AND   A.CHILD_ITEM_ID  = B.PARENT_ITEM_ID                    ' + char(10)
				SELECT @v_dSql +=	N'	        WHERE 1=1                                                    ' + char(10)
				SELECT @v_dSql +=	N'			AND	  A.SITE_ID = '''+ @p_site_id +'''                                       ' + char(10)
				SELECT @v_dSql +=	N'	        AND   CONVERT(NVARCHAR(8),A.EFF_END_DATE,112) >'''+ @p_plan_date +'''                                                                  ' + char(10)
				SELECT @v_dSql +=	N'	      ;               ' + char(10)

				SELECT @v_dSql +=	N'	SELECT (CASE WHEN A.STOCK_TYPE = ''INVENTORY'' THEN ''DW(oWMS)'' WHEN A.STOCK_TYPE = ''WIP'' THEN ''GMES'' ELSE A.STOCK_TYPE END) AS STOCK_TYPE_CPY  				' + char(10)
				SELECT @v_dSql +=	N'			, A.LINE_ID                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'			, B.CELL_ITEM_ID AS MODEL_ID                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, A.FP_APPLY_ITEM_ID AS ITEM_ID                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'			, A.NICK_NAME                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'			, A.OPERATION_ID AS OPERATION_ID_CPY                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'			, C.OPERATION_NAME AS OPERATION_NAME                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'			, A.PRODUCTION_TYPE                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			, A.STOCK_STATUS                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, A.STORAGE_ID                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, A.QTY                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'			, A.WIPHOLD_YN AS WIPHOLD_YN_CPY                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'			, A.QMS_HOLD_YN AS QMS_HOLD_YN_CPY                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'			, A.LONG_TERM_FLAG AS LONG_TERM_FLAG_CPY                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'			, A.QLTY_NO_INSP_FLAG AS UNINSPECTED_FLAG                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'			, (CASE WHEN A.AVAILABLE_DATE = ''1999-01-01'' THEN NULL ELSE A.AVAILABLE_DATE END) AS AVAILABLE_DATE_CPY                                               ' + char(10)
				SELECT @v_dSql +=	N'	FROM   (                                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    	/* PACK ERP BOH ?? ?? */                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	SELECT	A.*  , IM.NICK_NAME                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    	FROM  SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    	INNER  JOIN (                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    			SELECT	A.*                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'						FROM	#T_ITEM AS A                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'						WHERE	1=1                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'						AND		A.SHOP_FLAG = ''PACK''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    	) IM                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    	ON   1=1                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.ITEM_ID          = A.FP_APPLY_ITEM_ID                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.COMPANY_ID       = A.COMPANY_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.DIVISION_ID      = A.DIVISION_ID                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.SITE_ID          = A.SITE_ID                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    	INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			SELECT B.LOOKUP_TYPE_CODE                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    					, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT    ' + char(10)                          
				SELECT @v_dSql +=	N'		    				 	, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                ' + char(10)                          
				SELECT @v_dSql +=	N'		    			FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    			WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    			AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			AND    B.SEGMENT1         = ''CELL_SIMULATION''                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			AND    B.SEGMENT2         = '''+ @p_site_id +'''                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    			AND    B.ATTRIBUTE1        = ''DW''                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    	) V                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    	ON   A.SITE_ID               = V.SITE_ID                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.DIVISION_ID           = V.DIVISION_ID                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.PLANT_ID              = V.PLANT_ID                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STOCK_TYPE            = V.STOCK_TYPE                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  V.PACK_BOH              = ''Y''                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    	WHERE  CUTOFF_DATE = '''+ @p_plan_date +'''                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'				AND	 A.SITE_ID = '''+ @p_site_id +'''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.QTY2 > 0                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    	UNION ALL                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    	/* PACK MES BOH ?? */                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'		    	SELECT A.*  , IM.NICK_NAME                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    	FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    	INNER  JOIN ( --<IM: ITEM CODE ??? >--                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			SELECT	A.*                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'						FROM	#T_ITEM AS A                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'						WHERE	1=1                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'						AND		A.SHOP_FLAG = ''PACK''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    	) IM                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    	ON   1=1                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.COMPANY_ID  = A.COMPANY_ID                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.DIVISION_ID = A.DIVISION_ID                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  IM.SITE_ID     = A.SITE_ID                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    	INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			SELECT B.LOOKUP_TYPE_CODE                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    					, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT    ' + char(10)                          
				SELECT @v_dSql +=	N'		    					, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                ' + char(10)                          
				SELECT @v_dSql +=	N'		    			FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    			WHERE  B.ACTIVE_FLAG = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    			AND    B.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			AND    B.SEGMENT1         = ''CELL_SIMULATION''                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			AND    B.SEGMENT2         = '''+ @p_site_id +'''                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	) V                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    	ON   A.SITE_ID               = V.SITE_ID                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.DIVISION_ID           = V.DIVISION_ID                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.PLANT_ID              = V.PLANT_ID                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STOCK_TYPE            = V.STOCK_TYPE                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.FP_APPLY_OPERATION_ID = V.STOCK_POINT                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  V.PACK_BOH              = ''Y''                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    	WHERE  A.CUTOFF_DATE ='''+ @p_plan_date +'''                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'				AND	 A.SITE_ID = '''+ @p_site_id +'''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STORAGE_ID    =  ''MES''                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STOCK_TYPE    =  ''WIP''                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.FP_APPLY_WIPQTY > 0                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'			) A                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			-- bom 정보를 이용해서 cell item 정보 가져옴                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'	      	INNER HASH JOIN (                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'	      			SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.PARENT_ITEM_ID, MAX(B.CELL_ITEM_ID) AS CELL_ITEM_ID                                ' + char(10)
				SELECT @v_dSql +=	N'	      			FROM   #T_BOM_INFO B WITH(NOLOCK)                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'	      			WHERE  B.RNK = 1                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'	      			GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.PARENT_ITEM_ID                                                                   ' + char(10)
				SELECT @v_dSql +=	N'	      	) B                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'	      	ON  A.COMPANY_ID   = B.COMPANY_ID                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'	      	AND A.DIVISION_ID  = B.DIVISION_ID                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'	      	AND A.SITE_ID      = B.SITE_ID                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'	      	AND A.PLANT_ID     = B.PLANT_ID                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'	      	AND A.FP_APPLY_ITEM_ID = B.PARENT_ITEM_ID                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'			LEFT OUTER JOIN (                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'				SELECT DISTINCT A.SEGMENT1 AS OPERATION_ID, A.ATTRIBUTE1 AS OPERATION_NAME                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				WHERE  1=1                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				AND    A.LOOKUP_TYPE_CODE = ''FP_OPERATION''                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'			) C                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			ON  1=1                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'			AND A.FP_APPLY_OPERATION_ID = C.OPERATION_ID                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'	WHERE 1=1                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'	AND A.FP_APPLY_ITEM_ID = '''+ @p_pack_item_id +'''                                                                                                                            ' + char(10)
				
		END -- shop type pack

		IF @p_shop_type = 'FORM' BEGIN
				SELECT @v_dSql +=	N'	SELECT (CASE WHEN A.STOCK_TYPE = ''INVENTORY'' THEN ''ERP'' WHEN A.STOCK_TYPE = ''WIP'' THEN ''GMES'' ELSE A.STOCK_TYPE END) AS STOCK_TYPE_CPY							 ' + char(10)
				SELECT @v_dSql +=	N'			, A.LINE_ID                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'			, A.FP_APPLY_ITEM_ID AS MODEL_ID                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'			, A.FP_APPLY_ITEM_ID AS ITEM_ID                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'			, A.NICK_NAME                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'			, CASE WHEN A.STOCK_TYPE =''INVENTORY'' THEN A.STORAGE_ID ELSE A.OPERATION_ID END AS OPERATION_ID_CPY                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'			, CASE WHEN A.STOCK_TYPE =''INVENTORY'' THEN NULL ELSE C.OPERATION_NAME END AS OPERATION_NAME                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'			, A.PRODUCTION_TYPE                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'			, A.STOCK_STATUS                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'			, A.QTY                                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'			, A.WIPHOLD_YN AS WIPHOLD_YN_CPY                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'			, A.QMS_HOLD_YN AS QMS_HOLD_YN_CPY                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'			, A.LONG_TERM_FLAG AS LONG_TERM_FLAG_CPY                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			, A.QLTY_NO_INSP_FLAG AS UNINSPECTED_FLAG                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'			, (CASE WHEN A.AVAILABLE_DATE = ''1999-01-01'' THEN NULL ELSE A.AVAILABLE_DATE END) AS AVAILABLE_DATE_CPY                                                    ' + char(10)
				SELECT @v_dSql +=	N'	FROM   (                                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'	    		SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.PLANT_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FACTORY_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FP_APPLY_OPERATION_ID                       ' + char(10)        
	    		SELECT @v_dSql +=	N'	    				, A.FP_APPLY_ITEM_ID                           	' + char(10)
	    		SELECT @v_dSql +=	N'	    				, A.LINE_ID                          			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.OPERATION_ID                                ' + char(10)                   
				SELECT @v_dSql +=	N'	    				, A.PRODUCTION_TYPE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STORAGE_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STOCK_STATUS                                ' + char(10)            
				SELECT @v_dSql +=	N'	    				, A.STOCK_TYPE                                  ' + char(10)          
				SELECT @v_dSql +=	N'	    				, CASE WHEN ISNULL(A.WIPHOLD_YN,''N'') = ''Y'' OR V.STOCK_OPT = ''HOLD'' THEN ISNULL(A.QTY2,0) + ISNULL(A.DEFECT_QTY,0) ELSE ISNULL(A.QTY2,0) END AS QTY     							' + char(10)
				SELECT @v_dSql +=	N'						, CASE WHEN ISNULL(A.WIPHOLD_YN,''N'') = ''Y'' OR V.STOCK_OPT = ''HOLD'' THEN ''Y'' ELSE ''N'' END AS WIPHOLD_YN      ' + char(10)
				SELECT @v_dSql +=	N'	    				, A.QMS_HOLD_YN QMS_HOLD_YN						' + char(10)                                                                                                       
				SELECT @v_dSql +=	N'	    				, A.LONG_TERM_FLAG AS LONG_TERM_FLAG            ' + char(10)
				SELECT @v_dSql +=	N'						, CASE WHEN (A.QLTY_NO_INSP_FLAG = ''Y'' AND WIPHOLD_YN = ''N'' AND A.LONG_TERM_FLAG =  ''N'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'') OR V.STOCK_OPT = ''UNINSPECT'' THEN  ''Y''  ELSE NULL END AS QLTY_NO_INSP_FLAG              ' + char(10)
				SELECT @v_dSql +=	N'	    				, A.AVAILABLE_DATE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, IM.NICK_NAME           						' + char(10)
				SELECT @v_dSql +=	N'	    		FROM   SCM_STOCK_H_V A WITH(NOLOCK)                            ' + char(10)
				SELECT @v_dSql +=	N'							INNER HASH JOIN                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'									(                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'									SELECT  I.COMPANY_ID , I.DIVISION_ID, I.SITE_ID , I.ITEM_ID , I.ITEM_CLASS ,RIGHT(I.FLOW_ID,5) AS FLOW_ID , S.CLASS_NAME , S.LEVEL              ' + char(10)                    
				SELECT @v_dSql +=	N'											, S.LEVEL_1_CODE , S.LEVEL_1_NAME , S.LEVEL_1_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_2_CODE , S.LEVEL_2_NAME , S.LEVEL_2_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_3_CODE , S.LEVEL_3_NAME , S.LEVEL_3_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_4_CODE , S.LEVEL_4_NAME , S.LEVEL_4_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_5_CODE , S.LEVEL_5_NAME , S.LEVEL_5_ID   , I.NICK_NAME                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'									FROM    SCM_ITEM_M I WITH(NOLOCK), SCM_ITEM_CLASS_M S WITH(NOLOCK)                                                                               ' + char(10)
				SELECT @v_dSql +=	N'									WHERE  1=1                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'									AND	   I.SITE_ID = '''+ @p_site_id +'''                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'									AND    I.ITEM_CLASS   = S.CLASS_ID                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'									AND    I.ACTIVE_FLAG  = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'									AND    S.USE_FLAG     = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'									AND    S.LEVEL_3_NAME IN ( ''Cell'' , ''Module Automotive Assembly'' )                                                                           ' + char(10)
				SELECT @v_dSql +=	N'									AND    RIGHT(I.FLOW_ID,5) IN ( ''A9000'',''A3000'',''P5000'' )                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'							) IM                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'							ON   1=1                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.COMPANY_ID  = A.COMPANY_ID                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.DIVISION_ID = A.DIVISION_ID                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.SITE_ID     = A.SITE_ID                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'	    				INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       ' + char(10)
				SELECT @v_dSql +=	N'	    						SELECT B.LOOKUP_TYPE_CODE                            ' + char(10)
				SELECT @v_dSql +=	N'	    									, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      ' + char(10)
				SELECT @v_dSql +=	N'	    									, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS, B.ATTRIBUTE11 AS STOCK_OPT         ' + char(10)
				SELECT @v_dSql +=	N'	    						FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   ' + char(10)
				SELECT @v_dSql +=	N'	    						WHERE  A.ACTIVE_FLAG = ''Y''                         ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.ACTIVE_FLAG = ''Y''                         ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''       ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.SEGMENT1         = ''CELL_SIMULATION''      ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.SEGMENT2         = '''+ @p_site_id +'''            ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.ATTRIBUTE3       = ''Y''            ' + char(10)
				SELECT @v_dSql +=	N'	    				) V                                                      ' + char(10)
				SELECT @v_dSql +=	N'	    				ON   A.DIVISION_ID           = V.DIVISION_ID             ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.SITE_ID               = V.SITE_ID                 ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.PLANT_ID              = V.PLANT_ID                ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.STOCK_TYPE            = V.STOCK_TYPE              ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.STORAGE_ID            = V.STOCK_POINT             ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  V.CELL_BOH              = ''Y''         --- ??BOH ?? ??                                            ' + char(10)
				SELECT @v_dSql +=	N'	    		WHERE 1=1                                                    ' + char(10)
				SELECT @v_dSql +=	N'				AND	 A.CUTOFF_DATE ='''+ @p_plan_date +'''---> instance date             ' + char(10)
				SELECT @v_dSql +=	N'				AND  A.SITE_ID = '''+ @p_site_id +'''                                      ' + char(10)
				SELECT @v_dSql +=	N'	    		AND  A.STOCK_TYPE  = ''INVENTORY''  ---  ERP ??              ' + char(10)
				SELECT @v_dSql +=	N'	    		AND  ( ISNULL(A.QTY2,0) > 0 OR ISNULL(A.DEFECT_QTY,0) > 0)                                             ' + char(10)
				SELECT @v_dSql +=	N'				UNION ALL                                                                     ' + char(10)
				-- GOOD 창고이고  defect qty 가 있는경우에 별도로 표시해 준다.
				SELECT @v_dSql +=	N'	    		SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.PLANT_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FACTORY_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FP_APPLY_OPERATION_ID                       ' + char(10)        
	    		SELECT @v_dSql +=	N'	    				, A.FP_APPLY_ITEM_ID                           	' + char(10)
	    		SELECT @v_dSql +=	N'	    				, A.LINE_ID                          			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.OPERATION_ID                                ' + char(10)                   
				SELECT @v_dSql +=	N'	    				, A.PRODUCTION_TYPE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STORAGE_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STOCK_STATUS                                ' + char(10)            
				SELECT @v_dSql +=	N'	    				, A.STOCK_TYPE                                  ' + char(10)          
				SELECT @v_dSql +=	N'	    				, ISNULL(A.DEFECT_QTY,0) AS QTY     							' + char(10)
				SELECT @v_dSql +=	N'						, ''Y'' AS WIPHOLD_YN      ' + char(10)
				SELECT @v_dSql +=	N'	    				, A.QMS_HOLD_YN QMS_HOLD_YN						' + char(10)                                                                                                       
				SELECT @v_dSql +=	N'	    				, A.LONG_TERM_FLAG AS LONG_TERM_FLAG            ' + char(10)
				SELECT @v_dSql +=	N'						, CASE WHEN (A.QLTY_NO_INSP_FLAG = ''Y'' AND WIPHOLD_YN = ''N'' AND A.LONG_TERM_FLAG =  ''N'' AND ISNULL(A.PACK_MOVE_FLAG, ''N'') != ''Y'') OR V.STOCK_OPT = ''UNINSPECT'' THEN  ''Y''  ELSE NULL END AS QLTY_NO_INSP_FLAG              ' + char(10)
				SELECT @v_dSql +=	N'	    				, A.AVAILABLE_DATE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, IM.NICK_NAME           						' + char(10)
				SELECT @v_dSql +=	N'	    		FROM   SCM_STOCK_H_V A WITH(NOLOCK)                            ' + char(10)
				SELECT @v_dSql +=	N'							INNER HASH JOIN                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'									(                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'									SELECT  I.COMPANY_ID , I.DIVISION_ID, I.SITE_ID , I.ITEM_ID , I.ITEM_CLASS ,RIGHT(I.FLOW_ID,5) AS FLOW_ID , S.CLASS_NAME , S.LEVEL              ' + char(10)                    
				SELECT @v_dSql +=	N'											, S.LEVEL_1_CODE , S.LEVEL_1_NAME , S.LEVEL_1_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_2_CODE , S.LEVEL_2_NAME , S.LEVEL_2_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_3_CODE , S.LEVEL_3_NAME , S.LEVEL_3_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_4_CODE , S.LEVEL_4_NAME , S.LEVEL_4_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'											, S.LEVEL_5_CODE , S.LEVEL_5_NAME , S.LEVEL_5_ID   , I.NICK_NAME                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'									FROM    SCM_ITEM_M I WITH(NOLOCK), SCM_ITEM_CLASS_M S WITH(NOLOCK)                                                                               ' + char(10)
				SELECT @v_dSql +=	N'									WHERE  1=1                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'									AND	   I.SITE_ID = '''+ @p_site_id +'''                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'									AND    I.ITEM_CLASS   = S.CLASS_ID                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'									AND    I.ACTIVE_FLAG  = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'									AND    S.USE_FLAG     = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'									AND    S.LEVEL_3_NAME IN ( ''Cell'' , ''Module Automotive Assembly'' )                                                                           ' + char(10)
				SELECT @v_dSql +=	N'									AND    RIGHT(I.FLOW_ID,5) IN ( ''A9000'',''A3000'',''P5000'' )                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'							) IM                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'							ON   1=1                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.COMPANY_ID  = A.COMPANY_ID                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.DIVISION_ID = A.DIVISION_ID                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.SITE_ID     = A.SITE_ID                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'							AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'	    				INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       ' + char(10)
				SELECT @v_dSql +=	N'	    						SELECT B.LOOKUP_TYPE_CODE                            ' + char(10)
				SELECT @v_dSql +=	N'	    									, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      ' + char(10)
				SELECT @v_dSql +=	N'	    									, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS, B.ATTRIBUTE11 AS STOCK_OPT         ' + char(10)
				SELECT @v_dSql +=	N'	    						FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   ' + char(10)
				SELECT @v_dSql +=	N'	    						WHERE  A.ACTIVE_FLAG = ''Y''                         ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.ACTIVE_FLAG = ''Y''                         ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''       ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.SEGMENT1         = ''CELL_SIMULATION''      ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.SEGMENT2         = '''+ @p_site_id +'''            ' + char(10)
				SELECT @v_dSql +=	N'	    						AND    B.ATTRIBUTE3       = ''Y''            ' + char(10)
				SELECT @v_dSql +=	N'	    				) V                                                      ' + char(10)
				SELECT @v_dSql +=	N'	    				ON   A.DIVISION_ID           = V.DIVISION_ID             ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.SITE_ID               = V.SITE_ID                 ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.PLANT_ID              = V.PLANT_ID                ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.STOCK_TYPE            = V.STOCK_TYPE              ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  A.STORAGE_ID            = V.STOCK_POINT             ' + char(10)
				SELECT @v_dSql +=	N'	    				AND  V.CELL_BOH              = ''Y''         --- ??BOH ?? ??                                            ' + char(10)
				SELECT @v_dSql +=	N'	    		WHERE 1=1                                                    ' + char(10)
				SELECT @v_dSql +=	N'				AND	 A.CUTOFF_DATE ='''+ @p_plan_date +'''---> instance date             ' + char(10)
				SELECT @v_dSql +=	N'				AND  A.SITE_ID = '''+ @p_site_id +'''                                      ' + char(10)
				SELECT @v_dSql +=	N'	    		AND  A.STOCK_TYPE  = ''INVENTORY''  ---  ERP ??              ' + char(10)
				SELECT @v_dSql +=	N'	    		AND  ( V.STOCK_OPT IN (''GOOD'',''UNINSPECT'') AND ISNULL(A.DEFECT_QTY,0) > 0 )                                             ' + char(10)
				SELECT @v_dSql +=	N'				UNION ALL                                                                     ' + char(10)
				SELECT @v_dSql +=	N'	    		SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.PLANT_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FACTORY_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FP_APPLY_OPERATION_ID                       ' + char(10)        
	    		SELECT @v_dSql +=	N'	    				, A.FP_APPLY_ITEM_ID                           	' + char(10)
	    		SELECT @v_dSql +=	N'	    				, A.LINE_ID                          			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.OPERATION_ID                                ' + char(10)                   
				SELECT @v_dSql +=	N'	    				, A.PRODUCTION_TYPE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STORAGE_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STOCK_STATUS                                ' + char(10)            
				SELECT @v_dSql +=	N'	    				, A.STOCK_TYPE                                  ' + char(10)          
				SELECT @v_dSql +=	N'	    				, A.QTY2 AS QTY     							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.WIPHOLD_YN      							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.QMS_HOLD_YN QMS_HOLD_YN						' + char(10)                                                                                                       
				SELECT @v_dSql +=	N'	    				, A.LONG_TERM_FLAG AS LONG_TERM_FLAG            ' + char(10)                                                                                                         
				SELECT @v_dSql +=	N'	    				, A.QLTY_NO_INSP_FLAG                           ' + char(10)                                                                                     
				SELECT @v_dSql +=	N'	    				, A.AVAILABLE_DATE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, IM.NICK_NAME           						' + char(10)
				SELECT @v_dSql +=	N'		    	FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER HASH JOIN                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    					(                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT  I.COMPANY_ID , I.DIVISION_ID, I.SITE_ID , I.ITEM_ID , I.ITEM_CLASS ,RIGHT(I.FLOW_ID,5) AS FLOW_ID , S.CLASS_NAME , S.LEVEL              ' + char(10)                    
				SELECT @v_dSql +=	N'		    							, S.LEVEL_1_CODE , S.LEVEL_1_NAME , S.LEVEL_1_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    							, S.LEVEL_2_CODE , S.LEVEL_2_NAME , S.LEVEL_2_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    							, S.LEVEL_3_CODE , S.LEVEL_3_NAME , S.LEVEL_3_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    							, S.LEVEL_4_CODE , S.LEVEL_4_NAME , S.LEVEL_4_ID                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    							, S.LEVEL_5_CODE , S.LEVEL_5_NAME , S.LEVEL_5_ID   , I.NICK_NAME                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    					FROM    SCM_ITEM_M I WITH(NOLOCK), SCM_ITEM_CLASS_M S WITH(NOLOCK)                                                                               ' + char(10)
				SELECT @v_dSql +=	N'		    					WHERE  1=1                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'								AND	   I.SITE_ID = '''+ @p_site_id +'''                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'								AND    I.ITEM_CLASS   = S.CLASS_ID                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    I.ACTIVE_FLAG  = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    S.USE_FLAG     = ''Y''                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    S.LEVEL_3_NAME IN ( ''Cell'' , ''Module Automotive Assembly'' )                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    RIGHT(I.FLOW_ID,5) IN ( ''A9000'',''A3000'',''P5000'' )                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    			) IM                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   1=1                                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.COMPANY_ID  = A.COMPANY_ID                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.DIVISION_ID = A.DIVISION_ID                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.SITE_ID     = A.SITE_ID                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT B.LOOKUP_TYPE_CODE                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT   ' + char(10)                    
				SELECT @v_dSql +=	N'		    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS ' + char(10)                                                  
				SELECT @v_dSql +=	N'		    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    					WHERE  A.ACTIVE_FLAG = ''Y''                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.ACTIVE_FLAG = ''Y''                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT1         = ''CELL_SIMULATION''                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT2         = '''+ @p_site_id +'''                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			) V                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   A.SITE_ID          = V.SITE_ID                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.DIVISION_ID      = V.DIVISION_ID                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.PLANT_ID         = V.PLANT_ID                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.STOCK_TYPE       = V.STOCK_TYPE                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.OPERATION_ID		= V.STOCK_POINT                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.STOCK_STATUS		= CASE WHEN V.STOCK_STATUS IS NULL THEN A.STOCK_STATUS ELSE V.STOCK_STATUS END                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  V.CELL_BOH         = ''Y''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    			LEFT OUTER HASH JOIN (                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.PARENT_ITEM_ID , A.CHILD_ITEM_ID , A.ALT_PRIORITY                                  ' + char(10)                    
				SELECT @v_dSql +=	N'		    							, A.CHILD_QTY/A.PARENT_QTY AS BOM_RATE                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    					FROM	SCM_BOM_M A WITH(NOLOCK)                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    							INNER HASH JOIN  ( --: ???? CELL ?? ??                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'												SELECT *                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'												FROM	#T_ITEM                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'												WHERE	1=1                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'												AND		SHOP_FLAG = ''CELL''                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    							) EE                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    							ON   1=1                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    							AND  A.COMPANY_ID  = EE.COMPANY_ID                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    							AND  A.DIVISION_ID = EE.DIVISION_ID                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    							AND  A.SITE_ID     = EE.SITE_ID                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    							AND  A.CHILD_ITEM_ID = EE.ITEM_ID                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    					WHERE 1=1                                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'								AND	  A.SITE_ID = '''+ @p_site_id +'''                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    					AND   CONVERT(NVARCHAR(8),A.EFF_END_DATE,112)   >'''+ @p_plan_date +'''                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    					AND   CONVERT(NVARCHAR(8),A.EFF_START_DATE,112) <='''+ @p_plan_date +'''                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					AND   ISNULL(A.ALT_PRIORITY,1) = 1                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'		    			) BB                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			ON  1=1                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.SITE_ID          = BB.SITE_ID                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.DIVISION_ID      = BB.DIVISION_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.PLANT_ID         = BB.PLANT_ID                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.FP_APPLY_ITEM_ID = BB.PARENT_ITEM_ID                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    	WHERE 1=1                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'				AND	 A.CUTOFF_DATE = '''+ @p_plan_date +'''                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'				AND  A.SITE_ID = '''+ @p_site_id +'''                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STORAGE_ID   = ''MES''                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STOCK_TYPE   = ''WIP''     --- MES ??                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.FP_APPLY_WIPQTY > 0                                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'				UNION ALL                                                                                   									                                             ' + char(10)
				SELECT @v_dSql +=	N'	    		SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.PLANT_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FACTORY_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.FP_APPLY_OPERATION_ID                       ' + char(10)        
	    		SELECT @v_dSql +=	N'	    				, A.FP_APPLY_ITEM_ID                           	' + char(10)
	    		SELECT @v_dSql +=	N'	    				, A.LINE_ID                          			' + char(10)
				SELECT @v_dSql +=	N'	    				, A.OPERATION_ID                                ' + char(10)                   
				SELECT @v_dSql +=	N'	    				, A.PRODUCTION_TYPE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STORAGE_ID									' + char(10)
				SELECT @v_dSql +=	N'	    				, A.STOCK_STATUS                                ' + char(10)            
				SELECT @v_dSql +=	N'	    				, A.STOCK_TYPE                                  ' + char(10)          
				SELECT @v_dSql +=	N'	    				, A.QTY2 AS QTY     							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.WIPHOLD_YN      							' + char(10)
				SELECT @v_dSql +=	N'	    				, A.QMS_HOLD_YN QMS_HOLD_YN						' + char(10)                                                                                                       
				SELECT @v_dSql +=	N'	    				, A.LONG_TERM_FLAG AS LONG_TERM_FLAG            ' + char(10)                                                                                                         
				SELECT @v_dSql +=	N'	    				, A.QLTY_NO_INSP_FLAG                           ' + char(10)                                                                                     
				SELECT @v_dSql +=	N'	    				, A.AVAILABLE_DATE  							' + char(10)
				SELECT @v_dSql +=	N'	    				, IM.NICK_NAME           						' + char(10)
				SELECT @v_dSql +=	N'		    	FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER HASH JOIN                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    					(                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'								SELECT *                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'								FROM	#T_ITEM                                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'								WHERE	1=1                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'								AND		SHOP_FLAG = ''CELL''                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    			) IM                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   IM.COMPANY_ID  = A.COMPANY_ID                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.DIVISION_ID = A.DIVISION_ID                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.SITE_ID     = A.SITE_ID                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT B.LOOKUP_TYPE_CODE                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT   ' + char(10)                    
				SELECT @v_dSql +=	N'		    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                               ' + char(10)                    
				SELECT @v_dSql +=	N'		    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                ' + char(10)
				SELECT @v_dSql +=	N'		    					WHERE  A.ACTIVE_FLAG = ''Y''                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.ACTIVE_FLAG = ''Y''                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT1         = ''CELL_SIMULATION''                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT2         = '''+ @p_site_id +'''                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			) V                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   A.DIVISION_ID           = V.DIVISION_ID                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.SITE_ID               = V.SITE_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.PLANT_ID              = V.PLANT_ID                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.STOCK_TYPE            = V.STOCK_TYPE                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.STORAGE_ID            = V.STOCK_POINT                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  V.CELL_BOH              = ''Y''                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    	WHERE 1=1                                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'				AND	 A.CUTOFF_DATE ='''+ @p_plan_date +'''                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'				AND  A.SITE_ID = '''+ @p_site_id +'''                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STORAGE_ID  = ''MES''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STOCK_TYPE  = ''WIP''                                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.PACK_MOVE_QTY > 0                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		) A                                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			LEFT OUTER JOIN (                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'				SELECT DISTINCT A.SEGMENT1 AS OPERATION_ID, A.ATTRIBUTE1 AS OPERATION_NAME                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				WHERE  1=1                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				AND    A.LOOKUP_TYPE_CODE = ''FP_OPERATION''                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'			) C                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			ON  1=1                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'			AND A.OPERATION_ID = C.OPERATION_ID                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'	WHERE 1=1                                                                                                                                                      ' + char(10)
				--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_APPLY_ITEM_ID' , 'LIKE', @p_cell_item_id))       + char(10)
				--SELECT @v_dSql +=	N'	AND A.FP_APPLY_ITEM_ID = '''+ @p_cell_item_id +'''                                                                                                                            ' + char(10)
				IF @p_group_cell_yn = 'Y' BEGIN
					SELECT @v_dSql +=	N'	AND A.FP_APPLY_ITEM_ID IN (										' + char(10)
					SELECT @v_dSql +=	N'						SELECT ITEM_ID AS ITEM_ID				' + char(10)
					SELECT @v_dSql +=	N'						FROM SCM_GROUP_CELL_M WITH(NOLOCK)						' + char(10)
					SELECT @v_dSql +=	N'						WHERE 1=1									' + char(10)
					SELECT @v_dSql +=	N'						AND GROUP_CELL_ID = '''+ @p_group_cell_code +'''			' + char(10)
					SELECT @v_dSql +=	N'						UNION ALL									' + char(10)
					SELECT @v_dSql +=	N'						SELECT  '''+ @p_group_cell_code +''' AS ITEM_ID		' + char(10)
					SELECT @v_dSql +=	N'				 )													' + char(10)
				END ELSE BEGIN
					SELECT @v_dSql +=	N'	AND A.FP_APPLY_ITEM_ID = '''+ @p_cell_item_id +'''     ' + char(10)      
				END
		END

		IF @p_shop_type = 'CELL' BEGIN
				SELECT @v_dSql +=	N'	SELECT (CASE WHEN A.STOCK_TYPE = ''INVENTORY'' THEN ''DW(oWMS)'' WHEN A.STOCK_TYPE = ''WIP'' THEN ''GMES'' ELSE A.STOCK_TYPE END) AS STOCK_TYPE_CPY								' + char(10)
				SELECT @v_dSql +=	N'			, A.LINE_ID                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, A.FP_APPLY_ITEM_ID AS MODEL_ID                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, A.FP_APPLY_ITEM_ID AS ITEM_ID                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'			, A.NICK_NAME        ' + char(10)
				SELECT @v_dSql +=	N'			, A.OPERATION_ID AS OPERATION_ID_CPY                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'			, C.OPERATION_NAME AS OPERATION_NAME                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'			, A.PRODUCTION_TYPE                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'			, A.STOCK_STATUS                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'			, A.QTY                                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'			, A.WIPHOLD_YN AS WIPHOLD_YN_CPY                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'			, A.QMS_HOLD_YN AS QMS_HOLD_YN_CPY                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'			, A.LONG_TERM_FLAG AS LONG_TERM_FLAG_CPY                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'			, A.QLTY_NO_INSP_FLAG AS UNINSPECTED_FLAG                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'			, (CASE WHEN A.AVAILABLE_DATE = ''1999-01-01'' THEN NULL ELSE A.AVAILABLE_DATE END) AS AVAILABLE_DATE_CPY                                                     ' + char(10)
				SELECT @v_dSql +=	N'	FROM   (                                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    	/* ?? ERP BOH ?? ?? */                                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    	SELECT	A.*, IM.NICK_NAME                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    	FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER HASH JOIN ( --< ITEM CODE ??? >--                                                                                                               ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT	*                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'								FROM	#T_ITEM                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'								WHERE	1=1                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'								AND		SHOP_FLAG = ''CELL''                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    			) IM                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   1=1                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.COMPANY_ID  = A.COMPANY_ID                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.DIVISION_ID = A.DIVISION_ID                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.SITE_ID     = A.SITE_ID                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER HASH JOIN (                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT B.LOOKUP_TYPE_CODE                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT    ' + char(10)                
				SELECT @v_dSql +=	N'		    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                ' + char(10)                
				SELECT @v_dSql +=	N'		    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    					WHERE  A.ACTIVE_FLAG = ''Y''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.ACTIVE_FLAG = ''Y''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT1         = ''CELL_SIMULATION''                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT2         = '''+ @p_site_id +'''                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			) V                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   A.SITE_ID               = V.SITE_ID                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.DIVISION_ID           = V.DIVISION_ID                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.PLANT_ID              = V.PLANT_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.STOCK_TYPE            = V.STOCK_TYPE                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.STORAGE_ID            = V.STOCK_POINT                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  V.ASSY_BOH              = ''Y''                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    	WHERE  CUTOFF_DATE = '''+ @p_plan_date +'''                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'				AND		A.SITE_ID = '''+ @p_site_id +'''                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STOCK_TYPE  = ''INVENTORY''                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.QTY2 > 0                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    	UNION ALL                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    	/* ?? MES BOH ?? */                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    	SELECT	A.*, IM.NICK_NAME                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    	FROM   SCM_STOCK_H_V A WITH(NOLOCK)                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER HASH JOIN (                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT	*                                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'								FROM	#T_ITEM                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'								WHERE	1=1                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'								AND		SHOP_FLAG = ''CELL''                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    			) IM                                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   1=1                                                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.COMPANY_ID  = A.COMPANY_ID                                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.DIVISION_ID = A.DIVISION_ID                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  IM.SITE_ID     = A.SITE_ID                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'		    			INNER JOIN (                                                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    					SELECT B.LOOKUP_TYPE_CODE                                                                                                                         ' + char(10)
				SELECT @v_dSql +=	N'		    							, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT      ' + char(10)                
				SELECT @v_dSql +=	N'		    							, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                  ' + char(10)                
				SELECT @v_dSql +=	N'		    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                                                                 ' + char(10)
				SELECT @v_dSql +=	N'		    					WHERE  A.ACTIVE_FLAG = ''Y''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.ACTIVE_FLAG = ''Y''                                                                                                                      ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''                                                                                                    ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT1         = ''CELL_SIMULATION''                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    					AND    B.SEGMENT2         = '''+ @p_site_id +'''                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			) V                                                                                                                                                   ' + char(10)
				SELECT @v_dSql +=	N'		    			ON   A.SITE_ID               = V.SITE_ID                                                                                                              ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.DIVISION_ID           = V.DIVISION_ID                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.PLANT_ID              = V.PLANT_ID                                                                                                             ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.STOCK_TYPE            = V.STOCK_TYPE                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  A.FP_APPLY_OPERATION_ID = V.STOCK_POINT                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'		    			AND  V.ASSY_BOH              = ''Y''                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    	WHERE A.CUTOFF_DATE = '''+ @p_plan_date +'''                                                                                                                        ' + char(10)
				SELECT @v_dSql +=	N'				AND		A.SITE_ID = '''+ @p_site_id +'''                                                                                                                                  ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STORAGE_ID    =  ''MES''                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.STOCK_TYPE    =  ''WIP''                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'		    	AND  A.FP_APPLY_WIPQTY > 0                                                                                                                                ' + char(10)
				SELECT @v_dSql +=	N'			) A                                                                                                                                                           ' + char(10)
				SELECT @v_dSql +=	N'			LEFT OUTER JOIN (                                                                                                                                       ' + char(10)
				SELECT @v_dSql +=	N'				SELECT DISTINCT A.SEGMENT1 AS OPERATION_ID, A.ATTRIBUTE1 AS OPERATION_NAME                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				WHERE  1=1                                                                                                                                            ' + char(10)
				SELECT @v_dSql +=	N'				AND    A.LOOKUP_TYPE_CODE = ''FP_OPERATION''                                                                                                          ' + char(10)
				SELECT @v_dSql +=	N'			) C                                                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'			ON  1=1                                                                                                                                                 ' + char(10)
				SELECT @v_dSql +=	N'			AND A.OPERATION_ID = C.OPERATION_ID                                                                                                                     ' + char(10)
				SELECT @v_dSql +=	N'	WHERE 1=1                                                                                                                                                         ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_APPLY_ITEM_ID' , 'LIKE', @p_cell_item_id))       + char(10)
		END

		SELECT @v_dSql +=	N'	ORDER BY A.STOCK_TYPE, A.FACTORY_ID, A.FP_APPLY_OPERATION_ID, A.LINE_ID, A.STORAGE_ID, A.FP_APPLY_ITEM_ID                                                   ' + char(10)

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
