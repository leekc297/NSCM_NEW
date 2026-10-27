CREATE PROCEDURE [dbo].[PR_UI_FP02841_ADD]
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
/** 프로그램 ID   : PR_UI_FP02841_ADD                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP02841_ADD                                               **/
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
/** 2021/04/23   CYS				Initial Release UI통합                                    **/
/** 2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 뷰로 변경                               **/
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP02841_ADD';
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
	DECLARE @p_date			NVARCHAR(MAX);
	DECLARE @p_model_id		NVARCHAR(MAX);
	DECLARE @p_market		NVARCHAR(MAX);
	DECLARE @p_out_qty		NVARCHAR(MAX);
	DECLARE @p_electrode_type	NVARCHAR(MAX);
	DECLARE @p_wh_type		NVARCHAR(MAX);
	DECLARE @p_category_id	NVARCHAR(MAX);

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
		END ELSE IF @tmp_column = 'DATE' BEGIN
			SET @p_date			   =	@tmp_value ;
		END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
			SET @p_model_id		   =	@tmp_value ;
		END ELSE IF @tmp_column = 'MARKET' BEGIN
			SET @p_market		   =	@tmp_value ;
		END ELSE IF @tmp_column = 'OUT_QTY' BEGIN
			SET @p_out_qty		   =	@tmp_value ;
		END ELSE IF @tmp_column = 'PRODUCTION_TYPE' BEGIN
			SET @p_prod_type	   =	@tmp_value ;
		END ELSE IF @tmp_column = 'ELECTRODE_TYPE' BEGIN
			SET @p_electrode_type	   =	@tmp_value ;
		END ELSE IF @tmp_column = 'WH_TYPE' BEGIN
			SET @p_wh_type	   =	@tmp_value ;
		END ELSE IF @tmp_column = 'CATEGORY_ID' BEGIN
			SET @p_category_id	   =	@tmp_value ;

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
	DECLARE @ssp_total	NVARCHAR(MAX);

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

	IF @p_sys_flag = 'ITEM_LIST'	-- find_ItemList
	BEGIN
		
		SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, IT.NICK_NAME, IT.ITEM_TYPE       																							' + char(10)
		SELECT @v_dSql += N'	FROM (                                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'			SELECT 	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID                                                  ' + char(10)     
		SELECT @v_dSql += N'			FROM 	SCM_STOCK_H_V A					                                                                                        ' + char(10)                                                                  
		SELECT @v_dSql += N'				                                                                                                                            ' + char(10)              
		SELECT @v_dSql += N'						JOIN (SELECT 	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS ELEC_FACTORY_ID, SEGMENT4 AS ASSY_FACTORY_ID			        ' + char(10)                                                                        
		SELECT @v_dSql += N'								FROM 	SCM_SYS_LOOKUP_VALUE	                                                                            ' + char(10)                                                                        
		SELECT @v_dSql += N'								WHERE 	1=1	                                                                                                ' + char(10)                                                                    
		SELECT @v_dSql += N'								AND 		LOOKUP_TYPE_CODE = ''ELEC_POST_FACTORY_MAP'') AS MP                                             ' + char(10)                                                                        
		SELECT @v_dSql += N'						ON 	1=1			                                                                                                    ' + char(10)                                                                    
		SELECT @v_dSql += N'						AND 	CASE WHEN A.FACTORY_ID LIKE ''E%'' THEN MP.ELEC_FACTORY_ID ELSE MP.ASSY_FACTORY_ID END = A.FACTORY_ID		' + char(10)	                                                                  
		SELECT @v_dSql += N'			WHERE 	1=1						                                                                                                ' + char(10)                                                                    
		SELECT @v_dSql += N'			AND 		A.CUTOFF_DATE = '''+ @p_date +''' 					                                                                    ' + char(10)                                                                      
		SELECT @v_dSql += N'			AND 		A.SITE_ID = '''+ @p_site_id +'''					                                                                            ' + char(10)                                                                        
		SELECT @v_dSql += N'			AND 		A.ITEM_ID LIKE ''APC%''					                                                                            ' + char(10)                                                                    
		SELECT @v_dSql += N'			AND 		A.STOCK_TYPE = ''WIP''					                                                                            ' + char(10)                                                                      
		SELECT @v_dSql += N'			UNION ALL                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'			SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CHILD_ITEM_ID AS ITEM_ID                                          ' + char(10)
		SELECT @v_dSql += N'			FROM 	SCM_BOM_M A	WITH(NOLOCK)                                                                                                ' + char(10)
		SELECT @v_dSql += N'					LEFT OUTER HASH JOIN SCM_ITEM_LINE_ASSIGN_M B WITH(NOLOCK)		                                                        ' + char(10)
		SELECT @v_dSql += N'					ON 	1=1	                                                                                                                ' + char(10)
		SELECT @v_dSql += N'					AND A.COMPANY_ID = B.COMPANY_ID		                                                                                    ' + char(10)
		SELECT @v_dSql += N'					AND CASE WHEN A.SITE_ID = ''A001'' AND A.DIVISION_ID = ''82'' THEN ''81''		                                        ' + char(10)
		SELECT @v_dSql += N'								WHEN A.SITE_ID = ''A002'' AND A.DIVISION_ID = ''82'' THEN ''40''                                            ' + char(10)
		SELECT @v_dSql += N'								ELSE A.DIVISION_ID END = B.DIVISION_ID                                                                      ' + char(10)
		SELECT @v_dSql += N'					AND A.SITE_ID = B.SITE_ID		                                                                                        ' + char(10)
		SELECT @v_dSql += N'					AND A.CHILD_ITEM_ID = B.ITEM_ID		                                                                                    ' + char(10)
		SELECT @v_dSql += N'					AND B.MONTH = SUBSTRING('''+ @p_date +''',1,6)                                                                               ' + char(10)
		SELECT @v_dSql += N'					AND B.ACTIVE_FLAG = ''Y''		                                                                                        ' + char(10)
		SELECT @v_dSql += N'					AND B.PRIORITY NOT IN (0,9)		                                                                                        ' + char(10)
		SELECT @v_dSql += N'			WHERE 	1=1			                                                                                                            ' + char(10)
		--SELECT @v_dSql += N'			AND 	A.PLANT_ID != ''3050''                                                                                                  ' + char(10)
		SELECT @v_dSql += N'            AND     A.PLANT_ID not in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP02841_ADD'' AND SEGMENT1  = ''0'' AND ACTIVE_FLAG = ''Y'')' + char(10)
		SELECT @v_dSql += N'			AND 	A.CHILD_ITEM_ID LIKE ''APC%''			                                                                                ' + char(10)
		SELECT @v_dSql += N'			AND 	A.CHILD_ITEM_ID NOT LIKE ''APCSR%''			                                                                            ' + char(10)
		SELECT @v_dSql += N'			AND 	A.ACTIVE_FLAG = ''Y''			                                                                                        ' + char(10)
		SELECT @v_dSql += N'			AND   A.SITE_ID = '''+ @p_site_id +'''                                                                                                      ' + char(10)
		SELECT @v_dSql += N'			AND 	A.EFF_END_DATE >= '''+ @p_date +'''			                                                                                ' + char(10)
		SELECT @v_dSql += N'			AND 	B.LINE_ID IS NOT NULL			                                                                                        ' + char(10)
		SELECT @v_dSql += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.CHILD_ITEM_ID                                                     ' + char(10)
		SELECT @v_dSql += N'		) A                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'		JOIN SCM_ITEM_M IT				                                                                                                    ' + char(10)                                                      
		SELECT @v_dSql += N'		ON 	1=1	                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'		AND 		IT.ACTIVE_FLAG = ''Y''		                                                                                            ' + char(10)
		SELECT @v_dSql += N'		AND 		A.COMPANY_ID = IT.COMPANY_ID 		                                                                                    ' + char(10)                                                      
		SELECT @v_dSql += N'		AND 		A.DIVISION_ID = IT.DIVISION_ID 		                                                                                    ' + char(10)                                                    
		SELECT @v_dSql += N'		AND 		A.SITE_ID = IT.SITE_ID 		                                                                                            ' + char(10)                                                    
		SELECT @v_dSql += N'		AND 		A.ITEM_ID = IT.ITEM_ID 		                                                                                            ' + char(10)
		SELECT @v_dSql += N'WHERE 1=1                                                                                                       ' + char(10)
		SELECT @v_dSql += N'				AND    EXISTS ( SELECT 1                                                                                                        ' + char(10)
		SELECT @v_dSql += N'				        				FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                               ' + char(10)
		SELECT @v_dSql += N'				        				WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                     ' + char(10)
		SELECT @v_dSql += N'				        				AND    A.DIVISION_ID = B.DIVISION_ID                                                                    ' + char(10)
		SELECT @v_dSql += N'				        				AND    A.SITE_ID     = B.SITE_ID                                                                        ' + char(10)
		SELECT @v_dSql += N'				        				AND    B.USER_ID     = '''+ @p_user_id +'''                                                                        ' + char(10)
		SELECT @v_dSql += N'				        				AND	   B.SAVE_FLAG	 = ''Y'' )                                                                          ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('IT.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'	ORDER BY PLANT_ID, ITEM_ID                                                                                                              ' + char(10)

	END
	


	IF @p_sys_flag = 'INSTANCE_TYPE'	-- find_instanceType
	BEGIN
		
		SELECT @v_dSql += N'	SELECT ISNULL(ATTRIBUTE1,''BUILDING'') AS CONFIRM_AREA   ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)               ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''              ' + char(10)
		SELECT @v_dSql += N'	AND    A.SEGMENT1 = '''+ @p_instance_id +'''             ' + char(10)

	END	


	
	IF @p_sys_flag = 'DUP'	-- find_dup
	BEGIN
		
		SELECT @v_dSql += N'	SELECT COUNT(*) AS CNT  								' + char(10)	
		SELECT @v_dSql += N'	FROM   FP_ELECTRODE_POST_PLAN_H A WITH(NOLOCK)              ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID     = '''+ @p_instance_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID      = '''+ @p_plan_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.DIVISION_ID     = '''+ @p_division_id +'''                ' + char(10)
		SELECT @v_dSql += N'	AND    A.SITE_ID         = '''+ @p_site_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.PLANT_ID        = '''+ @p_plant_id +'''                   ' + char(10)
		SELECT @v_dSql += N'	AND    A.FACTORY_ID      = '''+ @p_factory_id +'''                 ' + char(10)
		SELECT @v_dSql += N'	AND    A.ITEM_ID         = '''+ @p_item_id +'''                    ' + char(10)
		SELECT @v_dSql += N'	AND    A.ELECTRODE_TYPE  = CASE WHEN '''+ @p_electrode_type +''' = ''ANODE'' THEN ''A'' ELSE ''C'' END             ' + char(10)
		SELECT @v_dSql += N'	AND    A.PRODUCTION_TYPE = '''+ @p_prod_type +'''            ' + char(10)
		SELECT @v_dSql += N'	AND    A.CATEGORY		 IN (''21-Slitting Plan'', ''31-Roll Press Plan'')          ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112)    = '''+ @p_date +'''   ' + char(10)
		SELECT @v_dSql += N'	AND	   A.OUT_QTY > 0                                      ' + char(10)

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
