CREATE PROCEDURE [dbo].[PR_UI_FP00629_ETC]
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
/** 프로그램 ID   : PR_UI_FP00629_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00629_ETC                                               **/
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
/** 2021/05/18   CYS				Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP00629_ETC';
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
	DECLARE @p_in_active	NVARCHAR(MAX);
	DECLARE @p_amend_instance	NVARCHAR(MAX);
	DECLARE @p_release_flag	NVARCHAR(MAX);

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
	
	--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@in_columns,'xx',@runstart, @runend
	--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@in_row,'xx2',@runstart, @runend
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
		END ELSE IF @tmp_column = 'IN_ACTIVE' BEGIN
			SET @p_in_active	=		@tmp_value ;
		END ELSE IF @tmp_column = 'AMEND_INSTANCE' BEGIN
			SET @p_amend_instance	=	@tmp_value ;
		END ELSE IF @tmp_column = 'RELEASE_FLAG' BEGIN
			SET @p_release_flag	=	@tmp_value ;
			
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
	
	IF OBJECT_ID('tempdb..#MATERIAL_PLAN') IS NOT NULL
		DROP TABLE #MATERIAL_PLAN

	CREATE TABLE 
		#MATERIAL_PLAN
		(
			COMPANY_ID nvarchar(30) NOT NULL,
			DIVISION_ID nvarchar(30) NOT NULL,
			SITE_ID nvarchar(30) NOT NULL,
			PLANT_ID nvarchar(30) NOT NULL,
			MODEL_ID nvarchar(150) NULL,
			PRODUCT_ID nvarchar(150) NULL,
			OPERATION_ID nvarchar(30) NOT NULL,
			MATERIAL_ID nvarchar(150) NULL,
			MATERIAL_NAME nvarchar(150) NULL,
			CLASS_NAME nvarchar(150) NULL
		)

	IF @p_sys_flag = 'COM_BOH'	-- findInstanceList_common
	BEGIN
		
		SELECT @v_dSql  = ''
        SELECT @v_dSql += '    WITH FP_PLAN AS (                                           ' + char(10)
        SELECT @v_dSql += '           SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
        SELECT @v_dSql += '               , TOP_ITEM_ID AS MODEL_ID, ITEM_ID AS PRODUCT_ID ' + char(10)
        SELECT @v_dSql += '               , OPERATION_ID, LINE_ID, PLAN_DATE               ' + char(10)
		IF(@p_release_flag = 'Y') BEGIN
                SELECT @v_dSql += '               , CEILING(SUM(PLAN_IN_QTY)) AS PLAN_IN_QTY ' + char(10)
        END ELSE BEGIN
                SELECT @v_dSql += '               , CEILING(SUM(IN_QTY)) AS PLAN_IN_QTY      ' + char(10)
        END
        SELECT @v_dSql += '           FROM 	' + TRY_CONVERT(NVARCHAR, @p_amend_table) +' A WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '           WHERE 1=1 ' + char(10)
		SELECT @v_dSql += '           AND 		A.PLAN_DATE BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''    ' + char(10)
			SELECT @v_dSql += '           AND  EXISTS (SELECT 1                                       ' + char(10)
        SELECT @v_dSql += '                           FROM  FP_INSTANCE_LINE_V X WITH(NOLOCK)     ' + char(10)
        SELECT @v_dSql += '                           WHERE 1=1                                   ' + char(10)
        SELECT @v_dSql += '                           AND   X.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
        SELECT @v_dSql += '                           AND   A.COMPANY_ID   = X.COMPANY_ID         ' + char(10)
        SELECT @v_dSql += '                           AND   A.SITE_ID      = X.SITE_ID            ' + char(10)
        SELECT @v_dSql += '                           AND   A.DIVISION_ID  = X.DIVISION_ID        ' + char(10)
        SELECT @v_dSql += '                           AND   A.FACTORY_ID   = X.FACTORY_ID         ' + char(10)
        SELECT @v_dSql += '                           AND   A.OPERATION_ID = X.OPERATION_ID       ' + char(10)
        SELECT @v_dSql += '                           AND   A.LINE_ID      = X.LINE_ID            ' + char(10)
        SELECT @v_dSql += '                           AND   A.ELECTRODE_TYPE = X.ELECTRODE_TYPE   ' + char(10)
        SELECT @v_dSql += '           )                                                   ' + char(10)
        IF(@p_release_flag = 'Y') BEGIN
                SELECT @v_dSql += '           AND 	A.PLAN_TYPE = ''RELEASE'' ' + char(10)
                SELECT @v_dSql += '           AND 	A.PLAN_IN_QTY > 0         ' + char(10)
        END ELSE BEGIN
                SELECT @v_dSql += '           AND 	A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
				SELECT @v_dSql += '           AND 	A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
                SELECT @v_dSql += '           AND 	A.IN_QTY      > 0 ' + char(10)
        END
        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' ,  'EQ', @p_division_id))  + char(10)
        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,     'EQ', @p_plant_id))     + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
        IF(LEN(@p_site_id) > 0)
			BEGIN
			    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))   + char(10)
            END
        SELECT @v_dSql += '           GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
        SELECT @v_dSql += '               , TOP_ITEM_ID, ITEM_ID                 ' + char(10)
        SELECT @v_dSql += '               , OPERATION_ID, PLAN_DATE, LINE_ID     ' + char(10)
        SELECT @v_dSql += '      )                                               ' + char(10)
        SELECT @v_dSql += '    , MATERIAL_CLASS AS (                             ' + char(10)
        SELECT @v_dSql += '           SELECT SEGMENT2 AS CLASS_ID                ' + char(10)
        SELECT @v_dSql += '           FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '           WHERE  1=1                                 ' + char(10)
        SELECT @v_dSql += '           AND    SEGMENT1 = '''+ @p_instance_id +'''     ' + char(10)
        SELECT @v_dSql += '           AND    LOOKUP_TYPE_CODE = ''MATERIAL_SIMUL_ITEM_DEFINIT'' ' + char(10)
        SELECT @v_dSql += '    )                           ' + char(10)
        SELECT @v_dSql += '    , MATERIAL_PLAN_1 AS (                     ' + char(10)
        SELECT @v_dSql += '          SELECT A.*                           ' + char(10)
        SELECT @v_dSql += '              , ISNULL(E.NEW_ALT_ID, B.CHILD_ITEM_ID) AS MATERIAL_ID ' + char(10)
        SELECT @v_dSql += '              , C.ITEM_NAME AS MATERIAL_NAME   ' + char(10)
        SELECT @v_dSql += '              , D.CLASS_NAME                   ' + char(10)
        SELECT @v_dSql += '              , ROUND(B.CHILD_QTY / B.PARENT_QTY, 4) AS BOM_RATE ' + char(10)
        SELECT @v_dSql += '          FROM 	FP_PLAN A WITH(NOLOCK)            ' + char(10)
        SELECT @v_dSql += '             , SCM_BOM_M B WITH(NOLOCK)           ' + char(10)
		SELECT @v_dSql += '				LEFT OUTER JOIN FP_PACK_NEW_ALT_ID E								' + char(10)
		SELECT @v_dSql += '				ON	1=1                                                             ' + char(10)
		SELECT @v_dSql += '				AND 	B.COMPANY_ID 		= E.COMPANY_ID                              ' + char(10)
		SELECT @v_dSql += '				AND 	B.DIVISION_ID 		= E.DIVISION_ID                         ' + char(10)
		SELECT @v_dSql += '				AND 	B.SITE_ID 			= E.SITE_ID                             ' + char(10)
		SELECT @v_dSql += '				AND 	B.PLANT_ID 			= E.PLANT_ID                            ' + char(10)
		SELECT @v_dSql += '				AND 	''ALT_'' + B.PARENT_ITEM_ID + ''_'' + B.ALT_ID = E.ALT_ID   ' + char(10)
        SELECT @v_dSql += '             , SCM_ITEM_M C WITH(NOLOCK)          ' + char(10)
        SELECT @v_dSql += '             , SCM_ITEM_CLASS_M D WITH(NOLOCK)    ' + char(10)
        SELECT @v_dSql += '          WHERE 1=1                               ' + char(10)
        SELECT @v_dSql += '          AND 	B.ACTIVE_FLAG = ''Y''             ' + char(10)
        SELECT @v_dSql += '          AND 	C.ACTIVE_FLAG = ''Y''             ' + char(10)
        SELECT @v_dSql += '          AND 	A.COMPANY_ID   = B.COMPANY_ID     ' + char(10)
        SELECT @v_dSql += '          AND 	A.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
        SELECT @v_dSql += '          AND 	A.SITE_ID      = B.SITE_ID        ' + char(10)
        SELECT @v_dSql += '          AND 	A.PLANT_ID     = B.PLANT_ID       ' + char(10)
        SELECT @v_dSql += '          AND 	A.PRODUCT_ID   = B.PARENT_ITEM_ID ' + char(10)
        SELECT @v_dSql += '          AND 	A.PLAN_DATE   >= B.EFF_START_DATE ' + char(10)
        SELECT @v_dSql += '          AND 	A.PLAN_DATE   <  B.EFF_END_DATE   ' + char(10)
        SELECT @v_dSql += '          AND 	A.COMPANY_ID    = C.COMPANY_ID    ' + char(10)
        SELECT @v_dSql += '          AND 	A.DIVISION_ID   = C.DIVISION_ID   ' + char(10)
        SELECT @v_dSql += '          AND 	A.SITE_ID       = C.SITE_ID       ' + char(10)
        SELECT @v_dSql += '          AND 	B.CHILD_ITEM_ID = C.ITEM_ID       ' + char(10)
        SELECT @v_dSql += '          AND 	C.ITEM_CLASS = D.CLASS_ID         ' + char(10)
        SELECT @v_dSql += '          AND 	(B.ALT_PRIORITY IS NULL OR B.ALT_PRIORITY = 1) ' + char(10)
        SELECT @v_dSql += '    )                      ' + char(10)
        SELECT @v_dSql += '    , MATERIAL_PLAN_2 AS ( ' + char(10)
        SELECT @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
        SELECT @v_dSql += '              , A.PLANT_ID, A.MODEL_ID, A.PRODUCT_ID    ' + char(10)
        SELECT @v_dSql += '              , A.OPERATION_ID, A.LINE_ID, A.PLAN_DATE  ' + char(10)
        SELECT @v_dSql += '              , A.PLAN_IN_QTY, ISNULL(B.REPLACE_ITEM_ID, A.MATERIAL_ID) AS MATERIAL_ID ' + char(10)
        SELECT @v_dSql += '              , CASE WHEN B.REPLACE_ITEM_ID IS NULL THEN A.BOM_RATE            ' + char(10)
        SELECT @v_dSql += '                     ELSE ROUND(B.CHILD_QTY / B.PARENT_QTY, 4) END AS BOM_RATE ' + char(10)
		SELECT @v_dSql += '              , A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
        SELECT @v_dSql += '          FROM   MATERIAL_PLAN_1 A WITH(NOLOCK)                 ' + char(10)
        SELECT @v_dSql += '          LEFT OUTER JOIN FP_LINE_BOM_PRIORITY_M B WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '          ON 	1=1                            ' + char(10)
        SELECT @v_dSql += '          AND A.PRODUCT_ID  = B.PARENT_ITEM_ID ' + char(10)
        SELECT @v_dSql += '          AND A.MATERIAL_ID = B.CHILD_ITEM_ID  ' + char(10)
        SELECT @v_dSql += '          AND A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
        SELECT @v_dSql += '          AND A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
        SELECT @v_dSql += '          AND A.SITE_ID     = B.SITE_ID        ' + char(10)
        SELECT @v_dSql += '          AND A.LINE_ID     = B.LINE_ID        ' + char(10)
        SELECT @v_dSql += '          AND A.PLAN_DATE  >= B.EFF_START_DATE ' + char(10)
        SELECT @v_dSql += '          AND A.PLAN_DATE  <  B.EFF_END_DATE   ' + char(10)
        SELECT @v_dSql += '          WHERE 1=1                            ' + char(10)
        SELECT @v_dSql += '    )                                          ' + char(10)
        SELECT @v_dSql += '          INSERT INTO #MATERIAL_PLAN                     ' + char(10)
		--SELECT @v_dSql += '          INSERT INTO BUF_MATERIAL_PLAN                     ' + char(10)
        SELECT @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.PRODUCT_ID                           ' + char(10)
		SELECT @v_dSql += '				, A.OPERATION_ID,  A.MATERIAL_ID , A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
        SELECT @v_dSql += '          FROM (                     ' + char(10)
        SELECT @v_dSql += '          		SELECT A.COMPANY_ID  ' + char(10)
        SELECT @v_dSql += '                    , A.DIVISION_ID  ' + char(10)
        SELECT @v_dSql += '                    , A.SITE_ID      ' + char(10)
        SELECT @v_dSql += '                    , A.PLANT_ID     ' + char(10)
		SELECT @v_dSql += '                    , A.MODEL_ID     ' + char(10)
        SELECT @v_dSql += '                    , A.PRODUCT_ID   ' + char(10)
        SELECT @v_dSql += '                    , A.OPERATION_ID ' + char(10)
        SELECT @v_dSql += '                    , ISNULL(B.REPLACE_ITEM_ID, A.MATERIAL_ID) AS MATERIAL_ID   ' + char(10)
        SELECT @v_dSql += '					, A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
        SELECT @v_dSql += '          		FROM 	MATERIAL_PLAN_2 A WITH(NOLOCK)                    ' + char(10)
        SELECT @v_dSql += '          		LEFT OUTER HASH JOIN FP_MRP_BOM_PRIORITY_M B WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '          		ON 	1=1                              ' + char(10)
        SELECT @v_dSql += '          		AND A.PRODUCT_ID  = B.PARENT_ITEM_ID ' + char(10)
        SELECT @v_dSql += '          		AND A.MATERIAL_ID = B.CHILD_ITEM_ID  ' + char(10)
        SELECT @v_dSql += '          		AND A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
        SELECT @v_dSql += '          		AND A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
        SELECT @v_dSql += '          		AND A.SITE_ID     = B.SITE_ID        ' + char(10)
        SELECT @v_dSql += '          		AND A.PLAN_DATE  >= B.EFF_START_DATE ' + char(10)
        SELECT @v_dSql += '          		AND A.PLAN_DATE  <  B.EFF_END_DATE   ' + char(10)
        SELECT @v_dSql += '          		WHERE 1=1                            ' + char(10)
        SELECT @v_dSql += '          		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID           ' + char(10)
        SELECT @v_dSql += '                    , A.PLANT_ID, A.MODEL_ID, A.PRODUCT_ID                ' + char(10)
        SELECT @v_dSql += '                    , A.OPERATION_ID, ISNULL(B.REPLACE_ITEM_ID, A.MATERIAL_ID) , A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
        SELECT @v_dSql += '          ) A                                 ' + char(10)
            
		EXEC sp_executesql @v_dSql -- temp table create

		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'COMTEMP',@runstart, @runend

		SELECT @v_dSql  = ''
        SELECT @v_dSql += '    WITH FP_PLAN AS (                                           ' + char(10)
        SELECT @v_dSql += '           SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
        SELECT @v_dSql += '               , TOP_ITEM_ID AS MODEL_ID, ITEM_ID AS PRODUCT_ID ' + char(10)
        SELECT @v_dSql += '               , OPERATION_ID, LINE_ID, PLAN_DATE               ' + char(10)
		IF(@p_release_flag = 'Y') BEGIN
                SELECT @v_dSql += '               , CEILING(SUM(PLAN_IN_QTY)) AS PLAN_IN_QTY ' + char(10)
        END ELSE BEGIN
                SELECT @v_dSql += '               , CEILING(SUM(IN_QTY)) AS PLAN_IN_QTY      ' + char(10)
        END
        SELECT @v_dSql += '           FROM 	' + TRY_CONVERT(NVARCHAR, @p_amend_table) +' A WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '           WHERE 1=1 ' + char(10)
		SELECT @v_dSql += '           AND 		A.PLAN_DATE BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''    ' + char(10)
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_top_item_id)) + char(10)
			SELECT @v_dSql += '           AND  EXISTS (SELECT 1                                       ' + char(10)
        SELECT @v_dSql += '                           FROM  FP_INSTANCE_LINE_V X WITH(NOLOCK)     ' + char(10)
        SELECT @v_dSql += '                           WHERE 1=1                                   ' + char(10)
        SELECT @v_dSql += '                           AND   X.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
        SELECT @v_dSql += '                           AND   A.COMPANY_ID   = X.COMPANY_ID         ' + char(10)
        SELECT @v_dSql += '                           AND   A.SITE_ID      = X.SITE_ID            ' + char(10)
        SELECT @v_dSql += '                           AND   A.DIVISION_ID  = X.DIVISION_ID        ' + char(10)
        SELECT @v_dSql += '                           AND   A.FACTORY_ID   = X.FACTORY_ID         ' + char(10)
        SELECT @v_dSql += '                           AND   A.OPERATION_ID = X.OPERATION_ID       ' + char(10)
        SELECT @v_dSql += '                           AND   A.LINE_ID      = X.LINE_ID            ' + char(10)
        SELECT @v_dSql += '                           AND   A.ELECTRODE_TYPE = X.ELECTRODE_TYPE   ' + char(10)
        SELECT @v_dSql += '           )                                                   ' + char(10)
        IF(@p_release_flag = 'Y') BEGIN
                SELECT @v_dSql += '           AND 	A.PLAN_TYPE = ''RELEASE'' ' + char(10)
                SELECT @v_dSql += '           AND 	A.PLAN_IN_QTY > 0         ' + char(10)
        END ELSE BEGIN
                SELECT @v_dSql += '           AND 	A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
				SELECT @v_dSql += '           AND 	A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
                SELECT @v_dSql += '           AND 	A.IN_QTY      > 0 ' + char(10)
        END
        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' ,  'EQ', @p_division_id))  + char(10)
        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,     'EQ', @p_plant_id))     + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
        IF(LEN(@p_site_id) > 0)
			BEGIN
			    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))   + char(10)
            END
        SELECT @v_dSql += '           GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
        SELECT @v_dSql += '               , TOP_ITEM_ID, ITEM_ID                 ' + char(10)
        SELECT @v_dSql += '               , OPERATION_ID, PLAN_DATE, LINE_ID     ' + char(10)
        SELECT @v_dSql += '      )                                               ' + char(10)
        SELECT @v_dSql += '    , MATERIAL_CLASS AS (                             ' + char(10)
        SELECT @v_dSql += '           SELECT SEGMENT2 AS CLASS_ID                ' + char(10)
        SELECT @v_dSql += '           FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '           WHERE  1=1                                 ' + char(10)
        SELECT @v_dSql += '           AND    SEGMENT1 = '''+ @p_instance_id +'''     ' + char(10)
        SELECT @v_dSql += '           AND    LOOKUP_TYPE_CODE = ''MATERIAL_SIMUL_ITEM_DEFINIT'' ' + char(10)
        SELECT @v_dSql += '    )                           ' + char(10)
        SELECT @v_dSql += '    , SHARE_MATERIAL_PLANT AS ( ' + char(10)
        SELECT @v_dSql += '           SELECT	DISTINCT A.ITEM_ID, C.DIVISION_ID, B.PLANT_ID, D.DIVISION_ID AS OTHER_DIVISION_ID, B.OTHER_PLANT_ID ' + char(10)
        SELECT @v_dSql += '           FROM	FP_MRP_SUM_PROCURE_ITEM_M A WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '               , (                                       ' + char(10)
        SELECT @v_dSql += '                  SELECT INSTANCE_ID, MIN(PLANT_ID) AS PLANT_ID, MAX(PLANT_ID) AS OTHER_PLANT_ID ' + char(10)
        SELECT @v_dSql += '                  FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '                  WHERE  1=1                               ' + char(10)
        SELECT @v_dSql += '                  GROUP BY INSTANCE_ID                     ' + char(10)
        SELECT @v_dSql += '                  HAVING   MAX(PLANT_ID) != MIN(PLANT_ID)  ' + char(10)
        SELECT @v_dSql += '                ) B                                        ' + char(10)
        SELECT @v_dSql += '               , SCM_PLANT_M C WITH(NOLOCK)                ' + char(10)
        SELECT @v_dSql += '               , SCM_PLANT_M D WITH(NOLOCK)                ' + char(10)
        SELECT @v_dSql += '           WHERE	1=1                                    ' + char(10)
        SELECT @v_dSql += '           AND 	B.INSTANCE_ID = '''+ @p_instance_id +'''       ' + char(10)
        SELECT @v_dSql += '           AND 	((A.PLANT_ID = B.PLANT_ID AND A.OTHER_PLANT_ID = B.OTHER_PLANT_ID) OR (A.PLANT_ID = B.OTHER_PLANT_ID AND A.OTHER_PLANT_ID = B.PLANT_ID)) ' + char(10)
        SELECT @v_dSql += '           AND 	B.PLANT_ID = C.PLANT_ID        ' + char(10)
        SELECT @v_dSql += '           AND 	B.OTHER_PLANT_ID = D.PLANT_ID  ' + char(10)
        SELECT @v_dSql += '           AND 	A.ACTIVE_FLAG = ''Y''          ' + char(10)
        SELECT @v_dSql += '    )                                          ' + char(10)
        SELECT @v_dSql += '    , MATERIAL_BOH_1 AS (                     ' + char(10)
        SELECT @v_dSql += '          SELECT A.COMPANY_ID                 ' + char(10)
        SELECT @v_dSql += '          	 , ISNULL(F.DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID ' + char(10)
        SELECT @v_dSql += '          	 , A.SITE_ID                                  ' + char(10)
        SELECT @v_dSql += '          	 , ISNULL(F.PLANT_ID, A.PLANT_ID) AS PLANT_ID ' + char(10)
        SELECT @v_dSql += '          	 , A.ITEM_ID AS MATERIAL_ID                   ' + char(10)
        SELECT @v_dSql += '          	 , CEILING(ISNULL(SUM(CASE WHEN LEFT(A.STORAGE_ID,1) = ''1'' THEN A.QTY END),0)) AS LWH_BOH -- 물류 창고 ' + char(10)
        SELECT @v_dSql += '          	 , CEILING(ISNULL(SUM(CASE WHEN LEFT(A.STORAGE_ID,1) = ''2'' THEN A.QTY END),0)) AS PWH_BOH -- 생산 창고 ' + char(10)
        SELECT @v_dSql += '          	 , ISNULL(SUM(A.QTY),0) AS M_BOH ' + char(10)
        SELECT @v_dSql += '          FROM   FP_MRP_CUTOFF_SUPPLY_H A WITH(NOLOCK) -- 공급 정보를 MRP 재고 기준으로 변경... 20210819  ' + char(10)
        SELECT @v_dSql += '          LEFT OUTER JOIN SHARE_MATERIAL_PLANT F WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '          ON 	1=1                         ' + char(10)
        SELECT @v_dSql += '          AND A.ITEM_ID  = F.ITEM_ID        ' + char(10)
        SELECT @v_dSql += '          AND A.PLANT_ID = F.OTHER_PLANT_ID ' + char(10)
        SELECT @v_dSql += '          , SCM_ITEM_M B WITH(NOLOCK)       ' + char(10)
        SELECT @v_dSql += '          , SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
        SELECT @v_dSql += '          , (                               ' + char(10)
        SELECT @v_dSql += '              SELECT DISTINCT INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
        SELECT @v_dSql += '              FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)  ' + char(10)
        SELECT @v_dSql += '              WHERE  1=1                                ' + char(10)
        SELECT @v_dSql += '              AND    INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
        SELECT @v_dSql += '          ) E                                           ' + char(10)
        SELECT @v_dSql += '          WHERE 1=1                                     ' + char(10)
        SELECT @v_dSql += '          AND 	A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')      ' + char(10)
        SELECT @v_dSql += '          AND 	A.SUPPLY_TYPE = ''STOCK''           ' + char(10)
        SELECT @v_dSql += '          AND 	(LEFT(A.STORAGE_ID,1) = ''1'' OR LEFT(A.STORAGE_ID,1) = ''2'') ' + char(10)
        SELECT @v_dSql += '          AND 	A.DIVISION_ID = E.DIVISION_ID      ' + char(10)
        SELECT @v_dSql += '          AND 	A.SITE_ID     = E.SITE_ID          ' + char(10)
        SELECT @v_dSql += '          AND 	A.PLANT_ID    = E.PLANT_ID         ' + char(10)
        SELECT @v_dSql += '          AND 	A.COMPANY_ID  = B.COMPANY_ID       ' + char(10)
        SELECT @v_dSql += '          AND 	A.DIVISION_ID = B.DIVISION_ID      ' + char(10)
        SELECT @v_dSql += '          AND 	A.SITE_ID     = B.SITE_ID          ' + char(10)
        SELECT @v_dSql += '          AND 	A.ITEM_ID     = B.ITEM_ID          ' + char(10)
        SELECT @v_dSql += '          AND 	B.ITEM_CLASS  = C.CLASS_ID         ' + char(10)
        SELECT @v_dSql += '          GROUP BY A.COMPANY_ID, ISNULL(F.DIVISION_ID, A.DIVISION_ID) ' + char(10)
        SELECT @v_dSql += '              , A.SITE_ID, ISNULL(F.PLANT_ID,A.PLANT_ID), A.ITEM_ID   ' + char(10)
        SELECT @v_dSql += '    ) ' + char(10)
		SELECT @v_dSql += '	, MATERIAL_BOH_2 AS (  																																							' + char(10)
		SELECT @v_dSql += '			SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NEW_ALT_ID AS MATERIAL_ID, SUM(B.LWH_BOH) AS LWH_BOH, SUM(B.PWH_BOH) AS PWH_BOH, SUM(B.M_BOH) AS M_BOH    ' + char(10)
		SELECT @v_dSql += '			FROM 	FP_PACK_ALT_MATERIAL_DEFINIT A WITH(NOLOCK)                                                                                                                                  ' + char(10)
		SELECT @v_dSql += '						LEFT OUTER JOIN MATERIAL_BOH_1 B                                                                                                                            ' + char(10)
		SELECT @v_dSql += '						ON 	1=1                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += '						AND 	A.COMPANY_ID = B.COMPANY_ID                                                                                                                         ' + char(10)
		SELECT @v_dSql += '						AND 	A.DIVISION_ID = B.DIVISION_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += '						AND 	A.SITE_ID = B.SITE_ID                                                                                                                               ' + char(10)
		SELECT @v_dSql += '						AND 	A.PLANT_ID = B.PLANT_ID                                                                                                                             ' + char(10)
		SELECT @v_dSql += '						AND 	A.MATERIAL_ID = B.MATERIAL_ID			                                                                                                            ' + char(10)
		SELECT @v_dSql += '			WHERE 	1=1                                                                                                                                                             ' + char(10)
		SELECT @v_dSql += '			AND 		B.M_BOH IS NOT NULL                                                                                                                                         ' + char(10)
		SELECT @v_dSql += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NEW_ALT_ID                                                                                               ' + char(10)
		SELECT @v_dSql += '		)                                                                                                                                                                           ' + char(10)
        SELECT @v_dSql += '    , MATERIAL_BOH AS (        ' + char(10)
        SELECT @v_dSql += '          SELECT *             ' + char(10)
        SELECT @v_dSql += '          FROM 	MATERIAL_BOH_1 ' + char(10)
        SELECT @v_dSql += '          UNION ALL            ' + char(10)
		SELECT @v_dSql += '          SELECT *             ' + char(10)
        SELECT @v_dSql += '          FROM 	MATERIAL_BOH_2 ' + char(10)
        SELECT @v_dSql += '          UNION ALL            ' + char(10)
        SELECT @v_dSql += '          SELECT A.COMPANY_ID, B.OTHER_DIVISION_ID, A.SITE_ID, B.OTHER_PLANT_ID, A.MATERIAL_ID, A.LWH_BOH, A.PWH_BOH, A.M_BOH ' + char(10)
        SELECT @v_dSql += '          FROM 	 MATERIAL_BOH_1 A, SHARE_MATERIAL_PLANT B ' + char(10)
        SELECT @v_dSql += '          WHERE  1=1                                ' + char(10)
        SELECT @v_dSql += '          AND 	 A.MATERIAL_ID = B.ITEM_ID          ' + char(10)
        SELECT @v_dSql += '    )                                               ' + char(10)
		SELECT @v_dSql += '    SELECT	DISTINCT A.*                                               ' + char(10)
		SELECT @v_dSql += '    FROM		MATERIAL_BOH A                                              ' + char(10)
		SELECT @v_dSql += '    		INNER JOIN #MATERIAL_PLAN B                                              ' + char(10)
		SELECT @v_dSql += '    		ON  1=1                                              ' + char(10)
		SELECT @v_dSql += '			AND A.PLANT_ID    = B.PLANT_ID          ' + char(10)
		SELECT @v_dSql += '			AND A.MATERIAL_ID = B.MATERIAL_ID       ' + char(10)


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
