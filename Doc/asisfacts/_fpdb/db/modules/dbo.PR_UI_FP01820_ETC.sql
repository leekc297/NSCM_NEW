


CREATE
PROCEDURE [dbo].[PR_UI_FP01820_ETC]
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
/** 프로그램 ID   : PR_UI_FP01820_ETC                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP01820_ETC                                               **/
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
/** 2022/04/19   LJS				Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FP01820_ETC';
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

	DECLARE @p_division_id				NVARCHAR(MAX);

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
		
		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =			@tmp_value ;
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
	--SET @max_category_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단

	SET	@v_dSql = '';

	IF @p_sys_flag = 'JOBLIST'
	BEGIN
		
		SELECT @v_dSql += N'SELECT GROUP_ID AS CODE_ID, GROUP_NAME AS CODE_NAME ' + char(10)
		SELECT @v_dSql += N'FROM   JOB_SCHEDULE_MASTER A WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'WHERE  1 = 1 ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += N'ORDER BY GROUP_ID ' + char(10)

	END

	ELSE IF @p_sys_flag = 'BASIS_TIME'
	BEGIN
		
		SELECT @v_dSql += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'     , ISNULL(C.BASIS_TIME, B.BASIS_TIME) AS BASIS_TIME ' + char(10)
		SELECT @v_dSql += N'     , CONVERT(VARCHAR,dbo.FN_SITE_TIME(A.SITE_ID),112) AS SITE_DATE ' + char(10)
		SELECT @v_dSql += N'FROM   SCM_FACTORY_M A ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'    SELECT A.SEGMENT1 AS BASIS_TIME ' + char(10)
		SELECT @v_dSql += N'    FROM   SCM_SYS_LOOKUP_VALUE A ' + char(10)
		SELECT @v_dSql += N'    WHERE  A.LOOKUP_TYPE_CODE = ''BASIS_START_TIME'' ' + char(10)
		SELECT @v_dSql += N') B' + char(10)
		SELECT @v_dSql += N'ON  1=1 ' + char(10)
		SELECT @v_dSql += N'LEFT OUTER JOIN ( ' + char(10)
		SELECT @v_dSql += N'    SELECT A.SEGMENT1 AS PLANT_ID, A.SEGMENT2 AS BASIS_TIME ' + char(10)
		SELECT @v_dSql += N'    FROM   SCM_SYS_LOOKUP_VALUE A ' + char(10)
		SELECT @v_dSql += N'    WHERE  A.LOOKUP_TYPE_CODE = ''BASIS_START_TIME_PLANT'' ' + char(10)
		SELECT @v_dSql += N') C ' + char(10)
		SELECT @v_dSql += N'ON  A.PLANT_ID = C.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'WHERE A.ACTIVE_FLAG = ''Y'' ' + char(10)

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
