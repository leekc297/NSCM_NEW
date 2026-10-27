

/*
 * Program ID   : PR_UI_FP00596_AMEND_LINE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/11/16   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00596_AMEND_LINE]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_instance_id                NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_factory_id                 NVARCHAR(MAX),
  @p_line_id                    NVARCHAR(MAX),
  @p_operation_id               NVARCHAR(MAX),
  @p_master_id                  NVARCHAR(MAX),
  @p_plan_date                  NVARCHAR(MAX),
  @p_plan_id                    NVARCHAR(MAX),
  @p_plan_type                  NVARCHAR(MAX),
  @p_prod_type                  NVARCHAR(MAX),
  @p_top_item_id                NVARCHAR(MAX),
  @p_item_id                    NVARCHAR(MAX),
  @p_nick_name                  NVARCHAR(MAX),
  @p_nick_name_lt               NVARCHAR(MAX),
  @p_bucket_from                NVARCHAR(MAX),
  @p_bucket_to                  NVARCHAR(MAX),
  @p_day_info                   NVARCHAR(MAX),
  @p_week_info                  NVARCHAR(MAX),
  @p_month_info                 NVARCHAR(MAX),
  @p_cate_info                  NVARCHAR(MAX),
  @p_cate_value                 NVARCHAR(MAX),
  @p_cate_type                  NVARCHAR(MAX),
  @p_amend_table                NVARCHAR(100),
  @p_amend_cutoff_boh_table     NVARCHAR(100),
  @p_amend_bor_table            NVARCHAR(100),
  @p_amend_boh_table            NVARCHAR(100),
  @p_amend_sales_table          NVARCHAR(100),
  @p_amend_util_table           NVARCHAR(100),
  @p_amend_capa_table           NVARCHAR(100)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
    DECLARE @v_instance_id                NVARCHAR(MAX)
    DECLARE @v_company_id                 NVARCHAR(MAX)
    DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_factory_id                 NVARCHAR(MAX)
    DECLARE @v_line_id                    NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_master_id                  NVARCHAR(MAX)
    DECLARE @v_plan_date                  NVARCHAR(MAX)
    DECLARE @v_plan_id                    NVARCHAR(MAX)
	DECLARE @v_plan_type                  NVARCHAR(MAX)
    DECLARE @v_prod_type                  NVARCHAR(MAX)
	DECLARE @v_top_item_id                NVARCHAR(MAX)
    DECLARE @v_item_id                    NVARCHAR(MAX)
    DECLARE @v_nick_name                  NVARCHAR(MAX)
    DECLARE @v_bucket_from_date           NVARCHAR(MAX)
    DECLARE @v_bucket_to_date             NVARCHAR(MAX)
    DECLARE @v_day_info                   NVARCHAR(MAX)
    DECLARE @v_week_info                  NVARCHAR(MAX)
    DECLARE @v_month_info                 NVARCHAR(MAX)
    DECLARE @v_cate_info                  NVARCHAR(MAX)
	DECLARE @v_cate_value                 NVARCHAR(MAX)
    DECLARE @v_cate_type                  NVARCHAR(MAX)
    DECLARE @v_amend_table                NVARCHAR(100) = 'FP_AMEND_DAILY_PLAN_R'
    DECLARE @v_amend_cutoff_boh_table     NVARCHAR(100) = 'FP_AMEND_CUTOFF_BOH_R'
    DECLARE @v_amend_bor_table            NVARCHAR(100) = 'FP_AMEND_DAILY_BOR_R'
	DECLARE @v_amend_boh_table            NVARCHAR(100) = 'FP_AMEND_DAILY_BOH_R'
    DECLARE @v_amend_sales_table          NVARCHAR(100) = 'FP_AMEND_DAILY_SALES_R'
    DECLARE @v_amend_util_table           NVARCHAR(100) = 'FP_AMEND_DAILY_UTIL_R'
	DECLARE @v_amend_capa_table           NVARCHAR(100) = 'FP_AMEND_DAILY_CAPA_R'

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00596_AMEND_LINE'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''
	DECLARE @v_dSql4                NVARCHAR(MAX)=''
	DECLARE @v_dSql5                NVARCHAR(MAX)=''

    DECLARE @pSql                   NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''
	DECLARE @v_tmp3                 NVARCHAR(MAX)=''


	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_instance_id              = ''
    SET @v_company_id               = ''
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_line_id                  = ''
    SET @v_operation_id             = ''
    SET @v_master_id                = ''
    SET @v_plan_date                = ''
    SET @v_plan_id                  = ''
    SET @v_plan_type                = ''
	SET @v_prod_type                = ''
	SET @v_top_item_id              = ''
    SET @v_item_id                  = ''
    SET @v_nick_name                = ''

    SET @v_bucket_from_date         = ''
    SET @v_bucket_to_date           = ''
    SET @v_day_info                 = ''
    SET @v_week_info                = ''
    SET @v_month_info               = ''
    SET @v_cate_info                = ''
    SET @v_cate_value               = ''
    SET @v_cate_type                = ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

	SET	@pSql                 = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)

			SELECT @pSql = ''
		  
			SELECT @v_dSql1 = ''
			SELECT @v_dSql1 = '------------------------------------v_dSql1-----------------------------' + char(10)
			SELECT @v_dSql1 += ' WITH MAIN AS (                                       ' + char(10)
			SELECT @v_dSql1 += '        SELECT A.*, ISNULL(B.LINE_SEQ, 9999) LINE_SEQ ' + char(10)
			SELECT @v_dSql1 += '        FROM (                                        ' + char(10)
			SELECT @v_dSql1 += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '                  , A.LOCATION, A.OPERATION_ID                       ' + char(10)
			SELECT @v_dSql1 += '                  , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE         ' + char(10)
			SELECT @v_dSql1 += '                  , A.EQUIPMENT_ID                                   ' + char(10)
			SELECT @v_dSql1 += '                  , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME            ' + char(10)
			SELECT @v_dSql1 += '                  , A.PRODUCTION_TYPE, A.MARKET                      ' + char(10)
			SELECT @v_dSql1 += '                  , E.BINDER_1, E.BINDER_2                           ' + char(10)
			SELECT @v_dSql1 += '                  , E.CONDUCTING_MATERIAL                            ' + char(10)
			SELECT @v_dSql1 += '                  , E.SOLVENT                                        ' + char(10)
			SELECT @v_dSql1 += '                  , CONVERT(NUMERIC(12,2), D.DAILY_CAPA_KG)  AS DC_KG      ' + char(10)
			SELECT @v_dSql1 += '                  , CONVERT(NUMERIC(12,2), D.DAILY_CAPA_BATCH) AS DC_BATCH ' + char(10)
			SELECT @v_dSql1 += '                  , D.DC_FLAG                                              ' + char(10)
			SELECT @v_dSql1 += '                  , B.CATEGORY_NAME AS CATE                                ' + char(10)

			IF(LEN(@p_day_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

			                SELECT @v_tmp1 += '                  , SUM(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_KG) ' + char(10)
			                SELECT @v_tmp1 += '                                                            WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_KG)    ' + char(10)
			                SELECT @v_tmp1 += '                                                            ELSE CEILING(A.ADJUST_RESULT_QTY_KG) END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG  ' + char(10)
			                SELECT @v_tmp1 += '                  , SUM(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
			                SELECT @v_tmp1 += '                                                            WHEN B.CATEGORY_ID=''P_OUT'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2)  ' + char(10)
			                SELECT @v_tmp1 += '                                                            ELSE ROUND(A.ADJUST_RESULT_QTY_BATCH,2) END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)
			                SELECT @v_tmp1 += '                  , NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ    ' + char(10)
			                SELECT @v_tmp1 += '                  , NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR  ' + char(10)

			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                             SELECT @v_tmp2 += '                  , SUM(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_KG) ' + char(10)	
                             SELECT @v_tmp2 += '                                                                WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_KG) ' + char(10)	
                             SELECT @v_tmp2 += '                                                                ELSE CEILING(A.ADJUST_RESULT_QTY_KG) END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG ' + char(10)	
                             SELECT @v_tmp2 += '                  , SUM(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)	
                             SELECT @v_tmp2 += '                                                                WHEN B.CATEGORY_ID=''P_OUT'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)	
                             SELECT @v_tmp2 += '                                                                ELSE ROUND(A.ADJUST_RESULT_QTY_BATCH,2) END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)	
                             SELECT @v_tmp2 += '                  , NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ ' + char(10)	
                             SELECT @v_tmp2 += '                  , NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)	
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                             SELECT @v_tmp3 += '                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN CEILING(A.ADJUST_IN_QTY_KG) ' + char(10)	
                             SELECT @v_tmp3 += '                                                                WHEN B.CATEGORY_ID=''P_OUT'' THEN CEILING(A.ADJUST_OUT_QTY_KG) ' + char(10)	
                             SELECT @v_tmp3 += '                                                                ELSE CEILING(A.ADJUST_RESULT_QTY_KG) END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG ' + char(10)	
                             SELECT @v_tmp3 += '                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)	
                             SELECT @v_tmp3 += '                                                                WHEN B.CATEGORY_ID=''P_OUT'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)	
                             SELECT @v_tmp3 += '                                                                ELSE ROUND(A.ADJUST_RESULT_QTY_BATCH,2) END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)	
                             SELECT @v_tmp3 += '                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN A.SEQ ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ ' + char(10)	
                             SELECT @v_tmp3 += '                   , NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)	
			             END 

				END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '           , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)	
			SELECT @v_dSql1 += '           , ''DATA'' AS DATA_TYPE           ' + char(10)	
			SELECT @v_dSql1 += ' 		FROM (                               ' + char(10)	
			SELECT @v_dSql1 += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.LOCATION, A.OPERATION_ID                                          ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.EQUIPMENT_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.PLAN_DATE       ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.MARKET          ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.SEQ             ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_KG              ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_KG           ' + char(10)
			SELECT @v_dSql1 += ' 		          , A.ADJUST_RESULT_QTY_BATCH, A.ADJUST_RESULT_QTY, A.ADJUST_RESULT_QTY_KG  ' + char(10)
			SELECT @v_dSql1 += ' 		      FROM (                                                                        ' + char(10)
			SELECT @v_dSql1 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.EQUIPMENT_ID                                 ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.PLAN_DATE                                    ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.PRODUCTION_TYPE                              ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.MARKET                                       ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.SEQ                                          ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_KG    ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_KG ' + char(10)
			SELECT @v_dSql1 += ' 		                , 0 AS ADJUST_RESULT_QTY_BATCH, 0 AS ADJUST_RESULT_QTY, 0 AS ADJUST_RESULT_QTY_KG ' + char(10)

			SELECT @v_dSql1 += ' 		            FROM '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		            WHERE  INSTANCE_ID      = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		            AND    FP_PLAN_ID       = '''+ @p_plan_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		            AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +''' ' + char(10)

			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.PRODUCTION_TYPE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		            AND   A.ADJUST_IN_QTY_BATCH > 0 ' + char(10)
			SELECT @v_dSql1 += ' 		            UNION ALL                       ' + char(10)

			SELECT @v_dSql1 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.EQUIPMENT_ID                                 ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.PLAN_DATE                                    ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.PRODUCTION_TYPE                              ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.MARKET                                       ' + char(10)
			SELECT @v_dSql1 += ' 		                   , '''' SEQ                                       ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.BATCH_IN_QTY AS ADJUST_IN_QTY_BATCH, A.PLAN_IN_QTY AS ADJUST_IN_QTY, A.PLAN_IN_QTY AS ADJUST_IN_QTY_KG ' + char(10)
			SELECT @v_dSql1 += ' 		               , A.BATCH_OUT_QTY AS ADJUST_OUT_QTY_BATCH, A.PLAN_QTY AS ADJUST_OUT_QTY, A.PLAN_QTY AS ADJUST_OUT_QTY_KG       ' + char(10)
			SELECT @v_dSql1 += ' 		               , 0 AS ADJUST_RESULT_QTY_BATCH, 0 AS ADJUST_RESULT_QTY, 0 AS ADJUST_RESULT_QTY_KG                              ' + char(10)
			SELECT @v_dSql1 += ' 		            FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		            WHERE  1=1                                      ' + char(10)
			SELECT @v_dSql1 += ' 		            AND    A.PLAN_TYPE = ''RELEASE''                ' + char(10)
			SELECT @v_dSql1 += ' 		            AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_plan_date +'''  -1 ' + char(10)
			
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.PRODUCTION_TYPE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		            UNION ALL ' + char(10)
			SELECT @v_dSql1 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.EQUIPMENT_ID                                 ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.PLAN_DATE                                    ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE        ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.MARKET                                       ' + char(10)
			SELECT @v_dSql1 += ' 		                   , '''' SEQ                                       ' + char(10)
			SELECT @v_dSql1 += ' 		                   , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_KG    ' + char(10)
			SELECT @v_dSql1 += ' 		                   , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_KG ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.BATCH_OUT_QTY AS ADJUST_RESULT_QTY_BATCH, A.QTY AS ADJUST_RESULT_QTY, A.QTY AS ADJUST_RESULT_QTY_KG ' + char(10)
			SELECT @v_dSql1 += ' 		            FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		            WHERE  1=1                                     ' + char(10)
			SELECT @v_dSql1 += ' 		            AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)

			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		            AND    A.PRODUCTION_TYPE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END

            SELECT @v_dSql1 += ' 		        ) A                                     ' + char(10)
            SELECT @v_dSql1 += ' 		        INNER JOIN SCM_ITEM_M B WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql1 += ' 		        ON     A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.SITE_ID        = B.SITE_ID     ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.ITEM_ID        = B.ITEM_ID     ' + char(10)

			IF (LEN(@p_nick_name_lt) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(B.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt))    + char(10)
				END

            SELECT @v_dSql1 += ' 		        INNER JOIN SCM_LINE_M C WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql1 += ' 		        ON     A.COMPANY_ID     = C.COMPANY_ID     ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.DIVISION_ID    = C.DIVISION_ID    ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.SITE_ID        = C.SITE_ID        ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.PLANT_ID       = C.PLANT_ID       ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.FACTORY_ID     = C.FACTORY_ID     ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.OPERATION_ID   = C.OPERATION_ID   ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.LINE_ID        = C.LINE_ID        ' + char(10)
            SELECT @v_dSql1 += ' 		        AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql1 += ' 		        WHERE 1=1                                  ' + char(10)

			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		        AND    B.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END
            SELECT @v_dSql1 += ' 		   ) A              ' + char(10)
            SELECT @v_dSql1 += ' 		   INNER JOIN (     ' + char(10)
            SELECT @v_dSql1 += ' 		       SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER   ' + char(10)
            SELECT @v_dSql1 += ' 		       UNION ALL    ' + char(10)
            SELECT @v_dSql1 += ' 		       SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER ' + char(10)
            SELECT @v_dSql1 += ' 		       UNION ALL    ' + char(10)
            SELECT @v_dSql1 += ' 		       SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER   ' + char(10)
            SELECT @v_dSql1 += ' 		       UNION ALL    ' + char(10)
            SELECT @v_dSql1 += ' 		       SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER   ' + char(10)
            SELECT @v_dSql1 += ' 		   ) B              ' + char(10)
            SELECT @v_dSql1 += ' 		   ON 1=1           ' + char(10)
            SELECT @v_dSql1 += ' 		   INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += ' 		   ON  A.PLAN_DATE = C.DT                    ' + char(10)
            SELECT @v_dSql1 += ' 		   LEFT OUTER HASH JOIN (                    ' + char(10)
            SELECT @v_dSql1 += ' 		         SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql1 += ' 		              , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID   ' + char(10)
            SELECT @v_dSql1 += ' 		              , A.TOP_ITEM_ID, A.ITEM_ID                        ' + char(10)
            SELECT @v_dSql1 += ' 		              , ROUND(A.DAILY_CAPA_KG,0) AS DAILY_CAPA_KG       ' + char(10)
            SELECT @v_dSql1 += ' 		              , ROUND(A.DAILY_CAPA_BATCH,2) AS DAILY_CAPA_BATCH ' + char(10)
            SELECT @v_dSql1 += ' 		              , CAPA_VALIDATION_FLAG AS DC_FLAG                 ' + char(10)
            SELECT @v_dSql1 += ' 		         FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_capa_table) +' A WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql1 += ' 		         WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''        ' + char(10)
            SELECT @v_dSql1 += ' 		         AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''            ' + char(10)

			SELECT @v_dSql1 += ' 		         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		         AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		         AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		         AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		         AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		     ) D                                      ' + char(10)
			SELECT @v_dSql1 += ' 		     ON  A.COMPANY_ID      = D.COMPANY_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.DIVISION_ID     = D.DIVISION_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.SITE_ID         = D.SITE_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.PLANT_ID        = D.PLANT_ID       ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.FACTORY_ID      = D.FACTORY_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.LOCATION        = D.LOCATION       ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.OPERATION_ID    = D.OPERATION_ID   ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.LINE_ID         = D.LINE_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.EQUIPMENT_ID    = D.EQUIPMENT_ID   ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.TOP_ITEM_ID     = D.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		     AND A.ITEM_ID         = D.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		     LEFT OUTER JOIN (                        ' + char(10)

			SELECT @v_dSql1 += ' 		           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PMIX_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                , MAX(CASE WHEN A.CLASS_NAME = ''Binder''  AND A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1 ' + char(10)
			SELECT @v_dSql1 += ' 		                , MAX(CASE WHEN A.CLASS_NAME = ''Binder''  AND A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2 ' + char(10)
			SELECT @v_dSql1 += ' 		                , MAX(CASE WHEN A.CLASS_NAME = ''Conducting Material'' AND A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTING_MATERIAL ' + char(10)
			SELECT @v_dSql1 += ' 		                , MAX(CASE WHEN A.CLASS_NAME = ''Solvent''  AND A.UI_COLUMN = ''Solvent 1'' THEN A.DESCRIPTION END) AS SOLVENT ' + char(10)
			SELECT @v_dSql1 += ' 		           FROM   SCM_PDS_MATERIAL_V A ' + char(10)
			SELECT @v_dSql1 += ' 		           WHERE  1=1                  ' + char(10)

			SELECT @v_dSql1 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		           AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)

			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		         AND    A.PMIX_ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PMIX_ITEM_ID ' + char(10)

			SELECT @v_dSql1 += ' 		            ) E                                    ' + char(10)
			SELECT @v_dSql1 += ' 		            ON  A.COMPANY_ID      = E.COMPANY_ID   ' + char(10)
			SELECT @v_dSql1 += ' 		            AND A.DIVISION_ID     = E.DIVISION_ID  ' + char(10)
			SELECT @v_dSql1 += ' 		            AND A.SITE_ID         = E.SITE_ID      ' + char(10)
			SELECT @v_dSql1 += ' 		            AND A.PLANT_ID        = E.PLANT_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		            AND A.ITEM_ID         = E.PMIX_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.LOCATION, A.OPERATION_ID               ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.EQUIPMENT_ID                           ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME    ' + char(10)
			SELECT @v_dSql1 += ' 		                , A.PRODUCTION_TYPE, A.MARKET              ' + char(10)
			SELECT @v_dSql1 += ' 		                , D.DAILY_CAPA_KG, D.DAILY_CAPA_BATCH      ' + char(10)
			SELECT @v_dSql1 += ' 		                , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ' 		                , E.BINDER_1, E.BINDER_2 ' + char(10)
			SELECT @v_dSql1 += ' 		                , E.CONDUCTING_MATERIAL  ' + char(10)
			SELECT @v_dSql1 += ' 		                , E.SOLVENT              ' + char(10)
			SELECT @v_dSql1 += ' 		                , D.DC_FLAG              ' + char(10)
			SELECT @v_dSql1 += ' 		       ) A                               ' + char(10)

			SELECT @v_dSql1 += ' 		       LEFT OUTER JOIN  (                ' + char(10)
			SELECT @v_dSql1 += ' 		             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.LOCATION, A.OPERATION_ID  ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.LINE_ID                   ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.TOP_ITEM_ID, A.ITEM_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += ' 		                 , MIN(LINE_SEQ) LINE_SEQ      ' + char(10)
			SELECT @v_dSql1 += ' 		             FROM (                            ' + char(10)
			SELECT @v_dSql1 += ' 		                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                           , A.LOCATION, A.OPERATION_ID  ' + char(10)
			SELECT @v_dSql1 += ' 		                           , A.LINE_ID                   ' + char(10)
			SELECT @v_dSql1 += ' 		                           , A.PLAN_DATE                 ' + char(10)
			SELECT @v_dSql1 += ' 		                           , A.TOP_ITEM_ID, A.ITEM_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		                           , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += ' 		                           , A.SEQ                       ' + char(10)
			SELECT @v_dSql1 += ' 		                           , RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                                    , A.LOCATION, A.OPERATION_ID, A.LINE_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                          		ORDER     BY A.PLAN_DATE, A.SEQ ) LINE_SEQ  ' + char(10)
			SELECT @v_dSql1 += ' 		                   FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK)                ' + char(10)
			SELECT @v_dSql1 += ' 		                   INNER JOIN SCM_ITEM_M B WITH(NOLOCK)               ' + char(10)
			SELECT @v_dSql1 += ' 		                   ON     A.COMPANY_ID     = B.COMPANY_ID             ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.DIVISION_ID    = B.DIVISION_ID            ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.SITE_ID        = B.SITE_ID                ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.ITEM_ID        = B.ITEM_ID                ' + char(10)
			SELECT @v_dSql1 += ' 		                   INNER JOIN SCM_LINE_M C WITH(NOLOCK)               ' + char(10)
			SELECT @v_dSql1 += ' 		                   ON     A.COMPANY_ID     = C.COMPANY_ID             ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.DIVISION_ID    = C.DIVISION_ID            ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.SITE_ID        = C.SITE_ID                ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.PLANT_ID       = C.PLANT_ID               ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.FACTORY_ID     = C.FACTORY_ID             ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.OPERATION_ID   = C.OPERATION_ID           ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.LINE_ID        = C.LINE_ID                ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE         ' + char(10)
			SELECT @v_dSql1 += ' 		                   WHERE  INSTANCE_ID      = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    FP_PLAN_ID       = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)

			SELECT @v_dSql1 += ' 		                   '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                   AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		                   '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		                   '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                   AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		                   '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                   AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                   AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                   AND    B.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                   AND    A.PRODUCTION_TYPE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql1 += ' 		                   AND 	ISNULL(A.SEQ, 0) <> 0     ' + char(10)
			SELECT @v_dSql1 += ' 		                   AND 	A.ADJUST_IN_QTY_BATCH > 0 ' + char(10)

			SELECT @v_dSql1 += ' 		               ) A                                ' + char(10)
			SELECT @v_dSql1 += ' 		               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		                   , A.PRODUCTION_TYPE, A.MARKET                                         ' + char(10)

			SELECT @v_dSql1 += ' 		          ) B                                       ' + char(10)
			SELECT @v_dSql1 += ' 		          ON  A.COMPANY_ID      = B.COMPANY_ID      ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.DIVISION_ID     = B.DIVISION_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.SITE_ID         = B.SITE_ID         ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.PLANT_ID        = B.PLANT_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.FACTORY_ID      = B.FACTORY_ID      ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.LOCATION        = B.LOCATION        ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.OPERATION_ID    = B.OPERATION_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.LINE_ID         = B.LINE_ID         ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.ITEM_ID         = B.ITEM_ID         ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		          AND A.MARKET         	= B.MARKET          ' + char(10)
			SELECT @v_dSql1 += ' 		     ) ' + char(10)

			SELECT @v_dSql2 = ''
			SELECT @v_dSql2 += '------------------ v_dsql2 --------------------- ' + char(10)
			SELECT @v_dSql2 += ' 		     , CAPA_VALUE AS (                   ' + char(10)
			SELECT @v_dSql2 += ' 		           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		                , '''+ @p_bucket_from +''' AS PLAN_DATE       ' + char(10)
			SELECT @v_dSql2 += ' 		                , NULL AS OFF_TIME                            ' + char(10)
			SELECT @v_dSql2 += ' 		                , NULL AS SETUP_TIME                          ' + char(10)
			SELECT @v_dSql2 += ' 		                , NULL AS UTILIZATION                         ' + char(10)
			SELECT @v_dSql2 += ' 		           FROM  '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK)                ' + char(10)
			SELECT @v_dSql2 += ' 		           INNER JOIN SCM_ITEM_M B WITH(NOLOCK)               ' + char(10)
			SELECT @v_dSql2 += ' 		           ON     A.COMPANY_ID     = B.COMPANY_ID             ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    A.DIVISION_ID    = B.DIVISION_ID            ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    A.SITE_ID        = B.SITE_ID                ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    A.ITEM_ID        = B.ITEM_ID                ' + char(10)
			SELECT @v_dSql2 += ' 		           WHERE  INSTANCE_ID      = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    FP_PLAN_ID       = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)

			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND    B.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND    A.PRODUCTION_TYPE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql2 += ' 		           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		           UNION ALL ' + char(10)
			SELECT @v_dSql2 += ' 		           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE   ' + char(10)
			SELECT @v_dSql2 += ' 		                , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql2 += ' 		                , SUM(A.OFF_TIME) AS OFF_TIME                     ' + char(10)
			SELECT @v_dSql2 += ' 		                , SUM(A.SETUP_TIME) AS SETUP_TIME                 ' + char(10)
			SELECT @v_dSql2 += ' 		                , AVG(A.UTILIZATION) AS UTILIZATION               ' + char(10)
			SELECT @v_dSql2 += ' 		           FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_util_table) +' A WITH(NOLOCK)               ' + char(10)
			SELECT @v_dSql2 += ' 		           WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''        ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''            ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			SELECT @v_dSql2 += ' 		           AND    EXISTS (        ' + char(10)
			SELECT @v_dSql2 += ' 		                         SELECT 1 ' + char(10)
			SELECT @v_dSql2 += ' 		                         FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' AAA WITH(NOLOCK), SCM_ITEM_M BBB WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		                         WHERE  AAA.COMPANY_ID   = BBB.COMPANY_ID           ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    AAA.DIVISION_ID  = BBB.DIVISION_ID          ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    AAA.SITE_ID      = BBB.SITE_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    AAA.ITEM_ID      = BBB.ITEM_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.COMPANY_ID     = AAA.COMPANY_ID           ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.DIVISION_ID    = AAA.DIVISION_ID          ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.SITE_ID        = AAA.SITE_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.PLANT_ID       = AAA.PLANT_ID             ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.FACTORY_ID     = AAA.FACTORY_ID           ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.LOCATION       = AAA.LOCATION             ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.OPERATION_ID   = AAA.OPERATION_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.LINE_ID        = AAA.LINE_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.ELECTRODE_TYPE = AAA.ELECTRODE_TYPE       ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    A.EQUIPMENT_ID   = AAA.EQUIPMENT_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    CONVERT(VARCHAR, AAA.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    AAA.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		                         AND    AAA.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)

			SELECT @v_dSql2 += ' 		                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		                         AND  AAA.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		                         AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql2 += ' 		                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		                         AND    AAA.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		                         AND    AAA.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		                         AND    BBB.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		                         AND    AAA.PRODUCTION_TYPE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql2 += ' 		                         ) ' + char(10)
			SELECT @v_dSql2 += ' 		                         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		                             , CONVERT(VARCHAR, A.PLAN_DATE, 112) ' + char(10)


			SELECT @v_dSql2 += ' 		       )             ' + char(10)
			SELECT @v_dSql2 += ' 		       , T_MEMO AS ( ' + char(10)
			SELECT @v_dSql2 += ' 		             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.EQUIPMENT_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.ITEM_ID, A.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			
			IF(LEN(@p_day_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

			                SELECT @v_tmp1 += ' 		          , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO ' + char(10)
			            END 
                END

			SELECT @v_dSql2 = @v_dSql2 + @v_tmp1

			SELECT @v_dSql2 += ' 		             FROM FP_AMEND_MEMO_M A WITH(NOLOCK)              ' + char(10)
			SELECT @v_dSql2 += ' 		             WHERE 1=1                                        ' + char(10)
			SELECT @v_dSql2 += ' 		             AND    A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)

			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
				END

			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_top_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND    A.PRODUCTION_TYPE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql2 += ' 		             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.EQUIPMENT_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.ITEM_ID, A.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql2 += ' 		       )                                       ' + char(10)

			SELECT @v_dSql3  = ''
		    SELECT @v_dSql3  = '------------------------------------v_dSql3-----------------------------' + char(10)
			SELECT @v_dSql3 += ' 		       SELECT A.* ' + char(10)
			SELECT @v_dSql3 += ' 		            , DENSE_RANK() OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID) AS LV1 ' + char(10)
			SELECT @v_dSql3 += ' 		            , B.APPLIED_MODEL ' + char(10)

			IF(LEN(@p_day_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

			                SELECT @v_tmp1 += ' 		            , C.D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO ' + char(10)
			            END 
                END

			SELECT @v_dSql3 = @v_dSql3 + @v_tmp1
			SELECT @v_dSql3 += ' 		            , CASE WHEN D.PRODUCTION_TYPE IS NOT NULL AND R.FACTORY_ID IS NOT NULL THEN ''Y'' ELSE ''N'' END AS EDIT_YN ' + char(10)
			SELECT @v_dSql3 += ' 		       FROM (                  ' + char(10)
			SELECT @v_dSql3 += ' 		            SELECT * FROM MAIN ' + char(10)
			SELECT @v_dSql3 += ' 		            UNION ALL          ' + char(10)
			SELECT @v_dSql3 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql3 += ' 		                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME                   ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS BINDER_1, NULL AS BINDER_2      ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS CONDUCTING_MATERIAL             ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS SOLVENT                         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS DC_KG, NULL AS DC_BATCH         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS DC_FLAG                         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,A.CATE                                  ' + char(10)


			IF(LEN(@p_day_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

							SELECT @v_tmp1 += ' 		                , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG, SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH, NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ, NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp2 += ' 		                , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG, SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH, NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ, NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
                         END

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp3 += ' 		                , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG, SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH, NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ, NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
			             END 
				END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3


			SELECT @v_dSql3 += ' 		                , A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		                , ''TOTAL'' AS DATA_TYPE          ' + char(10)
			SELECT @v_dSql3 += ' 		                , '''' LINE_SEQ                   ' + char(10)

			SELECT @v_dSql3 += ' 		            FROM   MAIN A                         ' + char(10)
			SELECT @v_dSql3 += ' 		            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		                ,A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		            -- Off Calendar, Setup                       ' + char(10)
			SELECT @v_dSql3 += ' 		            UNION ALL                                    ' + char(10)

			SELECT @v_dSql3 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql3 += ' 		                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME                   ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS BINDER_1, NULL AS BINDER_2      ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS CONDUCTING_MATERIAL             ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS SOLVENT                         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS DC_KG, NULL AS DC_BATCH         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS DC_FLAG                         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,B.CATEGORY_NAME AS CATE                 ' + char(10)

			IF(LEN(@p_day_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

							SELECT @v_tmp1 += ' 		                ,NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG    ' + char(10)
							SELECT @v_tmp1 += ' 		                ,SUM(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)
							SELECT @v_tmp1 += ' 		                ,NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ   ' + char(10)
							SELECT @v_tmp1 += ' 		                ,NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)		            
						END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp2 += ' 		                ,NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG    ' + char(10)
							 SELECT @v_tmp2 += ' 		                ,SUM(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)
							 SELECT @v_tmp2 += ' 		                ,NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ   ' + char(10)
							 SELECT @v_tmp2 += ' 		                ,NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)						 
						 END

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp3 += ' 		                ,NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG    ' + char(10)
							 SELECT @v_tmp3 += ' 		                ,SUM(CASE WHEN C.YYYYMMDD='''+ @v_day_info +'''  THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)
							 SELECT @v_tmp3 += ' 		                ,NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ   ' + char(10)
							 SELECT @v_tmp3 += ' 		                ,NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
						 END 
				END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql3 += ' 		                , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		                , ''TOTAL'' AS DATA_TYPE          ' + char(10)
			SELECT @v_dSql3 += ' 		                , '''' LINE_SEQ                   ' + char(10)

			SELECT @v_dSql3 += ' 		            FROM   CAPA_VALUE A ' + char(10)
			SELECT @v_dSql3 += ' 		            INNER JOIN (        ' + char(10)
			SELECT @v_dSql3 += ' 		                  SELECT ''OFF'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		                  UNION ALL ' + char(10)
			SELECT @v_dSql3 += ' 		                  SELECT ''SETUP'' AS CATEGORY_ID, ''M/C(min)'' AS CATEGORY_NAME, 200 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		            ) B    ' + char(10)
			SELECT @v_dSql3 += ' 		            ON 1=1 ' + char(10)
			SELECT @v_dSql3 += ' 		            INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += ' 		            ON  A.PLAN_DATE = C.YYYYMMDD              ' + char(10)
			SELECT @v_dSql3 += ' 		            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		                ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		            -- Capa   ' + char(10)
			SELECT @v_dSql3 += ' 		            UNION ALL ' + char(10)
			SELECT @v_dSql3 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql3 += ' 		                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS BINDER_1, NULL AS BINDER_2      ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS CONDUCTING_MATERIAL             ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS SOLVENT                         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS DC_KG, NULL AS DC_BATCH         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,NULL AS DC_FLAG                         ' + char(10)
			SELECT @v_dSql3 += ' 		                ,''Load(%)'' AS CATE                     ' + char(10)

			IF(LEN(@p_day_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

							SELECT @v_tmp1 += ' 		                ,NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG ' + char(10)
 							SELECT @v_tmp1 += ' 		                ,CEILING(AVG(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)
 							SELECT @v_tmp1 += ' 		                ,NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ ' + char(10)
 							SELECT @v_tmp1 += ' 		                ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
						END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp2 += ' 		                ,NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG ' + char(10)
							 SELECT @v_tmp2 += ' 		                ,CEILING(AVG(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)
							 SELECT @v_tmp2 += ' 		                ,NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ ' + char(10)
							 SELECT @v_tmp2 += ' 		                ,CASE WHEN (CEILING(AVG(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
						 END

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp3 += ' 		                ,NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG ' + char(10)
							 SELECT @v_tmp3 += ' 		                ,CEILING(AVG(CASE WHEN C.YYYYMMDD='''+ @v_day_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH ' + char(10)
							 SELECT @v_tmp3 += ' 		                ,NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ ' + char(10)
							 SELECT @v_tmp3 += ' 		                ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMMDD='''+ @v_day_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)

						 END 
				END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql3 += ' 		                , ''CAPA'' AS CATEGORY_ID, 300 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		                , ''TOTAL'' AS DATA_TYPE             ' + char(10)
			SELECT @v_dSql3 += ' 		                , '''' LINE_SEQ                      ' + char(10)
			SELECT @v_dSql3 += ' 		           FROM   CAPA_VALUE A                       ' + char(10)
			SELECT @v_dSql3 += ' 		           INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += ' 		           ON  A.PLAN_DATE = C.YYYYMMDD              ' + char(10)
			SELECT @v_dSql3 += ' 		           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		           -- Total  ' + char(10)
			SELECT @v_dSql3 += ' 		           UNION ALL ' + char(10)

			SELECT @v_dSql3 += ' 		           SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS OPERATION_ID ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS BINDER_1, NULL AS BINDER_2      ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS CONDUCTING_MATERIAL             ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS SOLVENT                         ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS DC_KG, NULL AS DC_BATCH         ' + char(10)
			SELECT @v_dSql3 += ' 		               ,NULL AS DC_FLAG                         ' + char(10)
			SELECT @v_dSql3 += ' 		               ,A.CATE                                  ' + char(10)

			IF(LEN(@p_day_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

							SELECT @v_tmp1 += ' 		                ,SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG, SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH, NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ, NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
						END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp2 += ' 		                ,SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG, SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH, NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ, NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
						 END

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

							 SELECT @v_tmp3 += ' 		                ,SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_KG, SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BATCH, NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_SEQ, NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' + char(10)
						 END 
				END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql3 += ' 		               , A.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		               , ''TOTAL_2'' AS DATA_TYPE        ' + char(10)
			SELECT @v_dSql3 += ' 		               , '''' LINE_SEQ                   ' + char(10)

			SELECT @v_dSql3 += ' 		          FROM   MAIN A ' + char(10)
			SELECT @v_dSql3 += ' 		          INNER JOIN (  ' + char(10)
			SELECT @v_dSql3 += ' 		              SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, 1 AS CATEGORY_ORDER   ' + char(10)
			SELECT @v_dSql3 += ' 		              UNION ALL ' + char(10)
			SELECT @v_dSql3 += ' 		              SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 2 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		              UNION ALL ' + char(10)
			SELECT @v_dSql3 += ' 		              SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 3 AS CATEGORY_ORDER   ' + char(10)
			SELECT @v_dSql3 += ' 		          ) B                                              ' + char(10)
			SELECT @v_dSql3 += ' 		          ON A.CATEGORY_ID = B.CATEGORY_ID                 ' + char(10)
			SELECT @v_dSql3 += ' 		          GROUP BY A.CATE, A.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3 += ' 		     ) A                                       ' + char(10)
			SELECT @v_dSql3 += ' 		     LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)

			SELECT @v_dSql3 += ' 		     ON  A.COMPANY_ID  = B.COMPANY_ID          ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.DIVISION_ID = B.DIVISION_ID         ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.SITE_ID     = B.SITE_ID             ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.ITEM_ID     = B.ITEM_ID             ' + char(10)
			SELECT @v_dSql3 += ' 		     LEFT OUTER JOIN T_MEMO C WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql3 += ' 		     ON  A.COMPANY_ID      = C.COMPANY_ID      ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.DIVISION_ID     = C.DIVISION_ID     ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.SITE_ID         = C.SITE_ID         ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.PLANT_ID        = C.PLANT_ID        ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.FACTORY_ID      = C.FACTORY_ID      ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.OPERATION_ID    = C.OPERATION_ID    ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.LINE_ID         = C.LINE_ID         ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE  ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.EQUIPMENT_ID    = C.EQUIPMENT_ID    ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.MARKET          = C.MARKET          ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.ITEM_ID         = C.ITEM_ID         ' + char(10)
			SELECT @v_dSql3 += ' 		     LEFT OUTER JOIN                           ' + char(10)
			SELECT @v_dSql3 += ' 		     (                                         ' + char(10)
			SELECT @v_dSql3 += ' 		           SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		           FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
			SELECT @v_dSql3 += ' 		           WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
			SELECT @v_dSql3 += ' 		           AND    A.ACTIVE_FLAG = ''Y''        ' + char(10)
			SELECT @v_dSql3 += ' 		     ) D                                       ' + char(10)
			SELECT @v_dSql3 += ' 		     ON A.DIVISION_ID = D.DIVISION_ID          ' + char(10)
			SELECT @v_dSql3 += ' 		     AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		     AND ( CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		     LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql3 += ' 		           SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
			SELECT @v_dSql3 += ' 		           FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql3 += ' 		           WHERE  1=1                                      ' + char(10)
			SELECT @v_dSql3 += ' 		           AND    R.USER_ID	= '''+ @p_user_id +'''         ' + char(10)
			SELECT @v_dSql3 += ' 		           AND    R.SAVE_FLAG	= ''Y''                    ' + char(10)
			SELECT @v_dSql3 += ' 		           AND    R.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql3 += ' 		     ) R                                    ' + char(10)
			SELECT @v_dSql3 += ' 		     ON    1=1                              ' + char(10)
			SELECT @v_dSql3 += ' 		     AND   A.COMPANY_ID    = R.COMPANY_ID   ' + char(10)
			SELECT @v_dSql3 += ' 		     AND   A.DIVISION_ID   = R.DIVISION_ID  ' + char(10)
			SELECT @v_dSql3 += ' 		     AND   A.SITE_ID	   = R.SITE_ID      ' + char(10)
			SELECT @v_dSql3 += ' 		     AND   A.PLANT_ID	   = R.PLANT_ID     ' + char(10)
			SELECT @v_dSql3 += ' 		     AND   A.FACTORY_ID    = R.FACTORY_ID   ' + char(10)
			SELECT @v_dSql3 += ' 		     AND   A.OPERATION_ID  = R.OPERATION_ID ' + char(10)
			SELECT @v_dSql3 += ' 		     AND   A.LINE_ID       = R.LINE_ID      ' + char(10)
			SELECT @v_dSql3 += ' 		     ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999 END) ' + char(10)
			SELECT @v_dSql3 += ' 		         , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID ' + char(10)
			SELECT @v_dSql3 += ' 		         , (CASE WHEN A.DATA_TYPE=''DATA'' THEN 1 ELSE A.CATEGORY_ORDER END), LV1 ' + char(10)
			SELECT @v_dSql3 += ' 		         , LINE_SEQ                                      ' + char(10)
			SELECT @v_dSql3 += ' 		         , A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID      ' + char(10)
			SELECT @v_dSql3 += ' 		         , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		         , A.CATEGORY_ORDER                              ' + char(10)


		    SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3

		    IF @p_sys_type = 'SQL'
		  	    BEGIN
		  	  	  EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
		  	  	  SELECT @v_dSql as [QUERY_VALUE]
		  	  
		  	  END  
		    ELSE 
		  	    BEGIN
		  	  	  SET @runstart = GetDate()
		  	  	  --쿼리실행
		  	  	  EXEC sp_executesql @v_dSql
		  	  	  
		  	  	  SET @runend = GetDate()
		  	  	  EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
		  	  END
        END	--IF( END )
	/************************************************************************************************/
	/* SELECT인경우 :FIND_AMEND_VALIDATION_PMIX                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='FIND_AMEND_VALIDATION_PMIX')
		BEGIN --ELSE IF(START)

			SELECT @v_dSql = ''
			    SELECT @v_dSql += '  ' + char(10)
			    SELECT @v_dSql += ' SELECT A.* ' + char(10)
			    SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' THEN (CASE WHEN MSG99 = '''' THEN '''' ELSE MSG99 END) ' + char(10)
			    SELECT @v_dSql += '           ELSE (CASE WHEN MSG99 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG99 END) ' + char(10)
			    SELECT @v_dSql += '           END AS _MSG ' + char(10)
			    SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS _VALID ' + char(10)
			    SELECT @v_dSql += ' FROM ( ' + char(10)
			    SELECT @v_dSql += '     SELECT TT.* ' + char(10)
			    SELECT @v_dSql += '         ,MSG1 ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''')                                                                                                                                               THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''')                                                                                                                                 THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''')                                                                                                                   THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''')                                                                                                     THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''')                                                                                       THEN MSG6 ELSE (CASE WHEN MSG6 = '''' THEN '''' ELSE '','' + MSG6 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''')                                                                         THEN MSG7 ELSE (CASE WHEN MSG7 = '''' THEN '''' ELSE '','' + MSG7 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''')                                                           THEN MSG8 ELSE (CASE WHEN MSG8 = '''' THEN '''' ELSE '','' + MSG8 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''')                                             THEN MSG9 ELSE (CASE WHEN MSG9 = '''' THEN '''' ELSE '','' + MSG9 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''')                               THEN MSG10 ELSE (CASE WHEN MSG10 = '''' THEN '''' ELSE '','' + MSG10 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''')                THEN MSG11 ELSE (CASE WHEN MSG11 = '''' THEN '''' ELSE '','' + MSG11 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''' AND MSG11 = '''') THEN MSG12 ELSE (CASE WHEN MSG12 = '''' THEN '''' ELSE '','' + MSG12 END) END) ' + char(10)
			    SELECT @v_dSql += '         +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''' AND MSG11 = '''' AND MSG11 = '''')  THEN MSG13 ELSE (CASE WHEN MSG13 = '''' THEN '''' ELSE '','' + MSG13 END) END) ' + char(10)
			    SELECT @v_dSql += '         + '' Not Found'' AS __MSG ' + char(10)
			    SELECT @v_dSql += '     FROM ( ' + char(10)
			    SELECT @v_dSql += '         SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID ' + char(10)
			    SELECT @v_dSql += '              ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '              ,A.FACTORY_ID, A.LOCATION ' + char(10)
			    SELECT @v_dSql += '              ,A.OPERATION_ID, A.LINE_ID, D.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
			    SELECT @v_dSql += '              ,A.PLAN_DATE ' + char(10)
			    SELECT @v_dSql += '              ,A.TOP_ITEM_ID, A.ITEM_ID, B.NICK_NAME ' + char(10)
			    SELECT @v_dSql += '              ,A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			    SELECT @v_dSql += '              ,A.SEQ, A.QTY ' + char(10)
			    SELECT @v_dSql += '              ,A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY_KG ' + char(10)
			    SELECT @v_dSql += '              ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN A.COMPANY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG1 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN B.ITEM_ID IS NULL THEN ''Material'' ELSE '''' END AS MSG2 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN C.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG3 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN D.LINE_ID IS NULL THEN ''Line or Electrode Type'' ELSE '''' END AS MSG4 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN E.CODE_ID IS NULL THEN ''Production Type'' ELSE '''' END AS MSG5 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN F.CODE_ID IS NULL THEN ''Market'' ELSE '''' END AS MSG6 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN L.EQUIPMENT_ID IS NULL THEN ''Equipment'' ELSE '''' END AS MSG7 ' + char(10)
			    SELECT @v_dSql += '              ,'''' AS MSG8 ' + char(10)
			    SELECT @v_dSql += '              ,'''' AS MSG9 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN ''Line Assign'' ELSE '''' END ) ELSE '''' END AS MSG10 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN K.KEY_VALUE = ''DAILY_CAPA'' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN ''Daily Capa'' ELSE '''' END) ' + char(10)
			    SELECT @v_dSql += '                                               ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN ''Tact Time'' ELSE '''' END) END ) ELSE '''' END AS MSG11 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN M.ITEM_ID IS NULL THEN ''Model Measure Conversion'' ELSE '''' END AS MSG12 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN R.FACTORY_ID IS NULL THEN ''Permissions'' ELSE '''' END AS MSG13 ' + char(10)
			    SELECT @v_dSql += '              ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE ' + char(10)
			    SELECT @v_dSql += '                          ORDER BY     A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE)>1 THEN ''Data Overlap'' ' + char(10)
			    SELECT @v_dSql += '                    ELSE '''' END AS MSG99 ' + char(10)
			    SELECT @v_dSql += '         FROM ( ' + char(10)
			    SELECT @v_dSql += '             SELECT A.INSTANCE_ID, A.FP_PLAN_ID ' + char(10)
			    SELECT @v_dSql += '                  , ISNULL(B.COMPANY_ID,''-'') AS COMPANY_ID, ISNULL(B.DIVISION_ID,''-'') AS DIVISION_ID, ISNULL(B.SITE_ID,''-'') AS SITE_ID, ISNULL(B.PLANT_ID,''-'') AS PLANT_ID ' + char(10)
			    SELECT @v_dSql += '                  , A.FACTORY_ID, A.LOCATION ' + char(10)
			    SELECT @v_dSql += '                  , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
			    SELECT @v_dSql += '                  , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
			    SELECT @v_dSql += '                  , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '                  , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			    SELECT @v_dSql += '                  , A.SEQ, A.QTY ' + char(10)
			    SELECT @v_dSql += '                  , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY_KG ' + char(10)
			    SELECT @v_dSql += '                  , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER ' + char(10)
			    SELECT @v_dSql += '             FROM   BUF_AMEND_DAILY_PLAN_R A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '             LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '             ON     A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '             AND    A.SITE_ID     = B.SITE_ID ' + char(10)
			    SELECT @v_dSql += '             AND    A.PLANT_ID    = B.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '             AND    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '             AND    B.ACTIVE_FLAG = ''Y'' ' + char(10)
			    SELECT @v_dSql += '             WHERE  A.JOB_USER_ID = '''+ @p_user_id +''' ' + char(10)
			    SELECT @v_dSql += '             AND    A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			    SELECT @v_dSql += '         ) A ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN ( ' + char(10)
			    SELECT @v_dSql += '               SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
			    SELECT @v_dSql += '                      A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			    SELECT @v_dSql += '               FROM   SCM_ITEM_M A WITH(NOLOCK), ' + char(10)
			    SELECT @v_dSql += '                      SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '               WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
			    SELECT @v_dSql += '               AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			    SELECT @v_dSql += '               AND    C.USE_FLAG    = ''Y'' ' + char(10)
			    SELECT @v_dSql += '         ) B ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID      = B.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID     = B.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID         = B.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.ITEM_ID         = B.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN SCM_OPERATION_M C WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID      = C.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID     = C.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID         = C.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.OPERATION_ID    = C.OPERATION_ID ' + char(10)
			    SELECT @v_dSql += '         AND C.ACTIVE_FLAG     = ''Y'' ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID      = D.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID     = D.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID         = D.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.PLANT_ID        = D.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.FACTORY_ID      = D.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.OPERATION_ID    = D.OPERATION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.LINE_ID         = D.LINE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE ' + char(10)
			    SELECT @v_dSql += '         AND D.ACTIVE_FLAG     = ''Y'' ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN ( ' + char(10)
			    SELECT @v_dSql += '                SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID ' + char(10)
			    SELECT @v_dSql += '                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '                WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
			    SELECT @v_dSql += '                AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
			    SELECT @v_dSql += '         ) E ' + char(10)
			    SELECT @v_dSql += '         ON  A.PRODUCTION_TYPE = E.CODE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID     = E.SEGMENT1 ' + char(10)
			    SELECT @v_dSql += '         AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = E.CODE_ID ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN ( ' + char(10)
			    SELECT @v_dSql += '             SELECT A.SEGMENT1 AS CODE_ID ' + char(10)
			    SELECT @v_dSql += '             FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '             WHERE  A.LOOKUP_TYPE_CODE = ''DEMAND_MARKET_TYPE'' ' + char(10)
			    SELECT @v_dSql += '             AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
			    SELECT @v_dSql += '         ) F ' + char(10)
			    SELECT @v_dSql += '         ON  A.MARKET = F.CODE_ID ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN ( ' + char(10)
			    SELECT @v_dSql += '             SELECT DISTINCT H.* ' + char(10)
			    SELECT @v_dSql += '             FROM ( ' + char(10)
			    SELECT @v_dSql += '                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '                  FROM   FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '                  WHERE  (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SCP_PLAN_ID) IN (SELECT A.DIVISION_ID+A.SHOP_GROUP_ID+MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) GROUP BY A.DIVISION_ID, A.SHOP_GROUP_ID) ' + char(10)
			    SELECT @v_dSql += '                  UNION ALL ' + char(10)
			    SELECT @v_dSql += '                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '                  FROM   FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '                  WHERE  A.SCP_PLAN_ID = (SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK)) ' + char(10)
			    SELECT @v_dSql += '                  UNION ALL ' + char(10)
			    SELECT @v_dSql += '                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '                  FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '                  WHERE  A.DUE_DATE >= (SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) ' + char(10)
			    SELECT @v_dSql += '                                        FROM   SCM_FP_PLAN_H ' + char(10)
			    SELECT @v_dSql += '                                        WHERE  PLAN_ID = '''+ @p_plan_id +''' ) ' + char(10)
			    SELECT @v_dSql += '                  UNION ALL ' + char(10)
			    SELECT @v_dSql += '                  SELECT  DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '                  FROM   FP_DAILY_INSTANCE_DEMAND_H A ' + char(10)
			    SELECT @v_dSql += '                  WHERE  1=1 ' + char(10)
			    SELECT @v_dSql += '                  AND   INSTANCE_ID = CASE WHEN '''+ @p_instance_id +''' = ''KR_E_PRE_A'' OR '''+ @p_instance_id +''' = ''KR_E_PRE_M'' THEN ''KR_E_PRE'' ' + char(10)
			    SELECT @v_dSql += '                                      ELSE '''+ @p_instance_id +''' END ' + char(10)
			    SELECT @v_dSql += '                  AND   INSTANCE_DATE = '''+ @p_plan_date +''' ' + char(10)
			    SELECT @v_dSql += '                  AND   CONVERT(VARCHAR, INSTANCE_DATE,102) = ( SELECT CONVERT(VARCHAR, PLAN_START_TIME,102) ' + char(10)
			    SELECT @v_dSql += '                                                                FROM   SCM_FP_PLAN_H ' + char(10)
			    SELECT @v_dSql += '                                                                WHERE  PLAN_ID = '''+ @p_plan_id +''' ' + char(10)
			    SELECT @v_dSql += '                                                                ) ' + char(10)
			    SELECT @v_dSql += '             ) H ' + char(10)
			    SELECT @v_dSql += '         ) H ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID  = H.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID     = H.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.PLANT_ID    = H.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.MARKET      = H.MARKET ' + char(10)
			    SELECT @v_dSql += '         AND A.ITEM_ID     = H.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID     = I.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID    = I.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID        = I.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.PLANT_ID       = I.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.FACTORY_ID     = I.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.ITEM_ID        = I.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.OPERATION_ID   = I.OPERATION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.LINE_ID        = I.LINE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.ELECTRODE_TYPE = I.ELECTRODE_TYPE ' + char(10)
			    SELECT @v_dSql += '         AND SUBSTRING(A.PLAN_DATE,1,6) = I.MONTH ' + char(10)
			    SELECT @v_dSql += '         AND I.ACTIVE_FLAG    = ''Y'' ' + char(10)
			    SELECT @v_dSql += '         AND I.PRIORITY NOT IN (''0'',''9'') ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN SCM_TACT_TIME_M J WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID      = J.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID     = J.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID         = J.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.PLANT_ID        = J.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.FACTORY_ID      = J.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.ITEM_ID         = J.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.OPERATION_ID    = J.OPERATION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.LINE_ID         = J.LINE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE ' + char(10)
			    SELECT @v_dSql += '         AND SUBSTRING(A.PLAN_DATE,1,6) = J.MONTH ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN FP_INSTANCE_CONFIG_M K WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '         ON  A.INSTANCE_ID     = K.INSTANCE_ID ' + char(10)
			    SELECT @v_dSql += '         AND K.KEY_ID          = ''FINAL_OP_CAPA'' ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN SCM_EQUIPMENT_M L WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID      = L.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID     = L.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID         = L.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.PLANT_ID        = L.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.FACTORY_ID      = L.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.OPERATION_ID    = L.OPERATION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.LINE_ID         = L.LINE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.EQUIPMENT_ID    = L.EQUIPMENT_ID ' + char(10)
			    SELECT @v_dSql += '         AND L.ACTIVE_FLAG 	  = ''Y'' ' + char(10)
			    SELECT @v_dSql += '         LEFT OUTER JOIN ( ' + char(10)
			    SELECT @v_dSql += '             SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID ' + char(10)
			    SELECT @v_dSql += ' 	            FROM   SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '         ) M ' + char(10)
			    SELECT @v_dSql += '         ON  A.COMPANY_ID    = M.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.DIVISION_ID   = M.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.SITE_ID       = M.SITE_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.PLANT_ID      = M.PLANT_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.FACTORY_ID    = M.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.OPERATION_ID  = M.OPERATION_ID ' + char(10)
			    SELECT @v_dSql += '         AND A.ITEM_ID       = M.ITEM_ID ' + char(10)
			    SELECT @v_dSql += '         	LEFT OUTER JOIN ( ' + char(10)
			    SELECT @v_dSql += ' 				SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
			    SELECT @v_dSql += ' 				FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += ' 				WHERE	1=1 ' + char(10)
			    SELECT @v_dSql += ' 				AND		R.USER_ID	= '''+ @p_user_id +''' ' + char(10)
			    SELECT @v_dSql += ' 				AND		R.SAVE_FLAG	= ''Y'' ' + char(10)
			    SELECT @v_dSql += ' 				AND		R.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			    SELECT @v_dSql += ' 		) R ' + char(10)
			    SELECT @v_dSql += ' 		ON		1=1 ' + char(10)
			    SELECT @v_dSql += ' 		AND		A.COMPANY_ID		= R.COMPANY_ID ' + char(10)
			    SELECT @v_dSql += ' 		AND		A.DIVISION_ID		= R.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += ' 		AND		A.SITE_ID			= R.SITE_ID ' + char(10)
			    SELECT @v_dSql += ' 		AND		A.PLANT_ID			= R.PLANT_ID ' + char(10)
			    SELECT @v_dSql += ' 		AND		A.FACTORY_ID		= R.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += ' 		AND		A.OPERATION_ID		= R.OPERATION_ID ' + char(10)
			    SELECT @v_dSql += ' 		AND		A.LINE_ID			= R.LINE_ID ' + char(10)
			    SELECT @v_dSql += '     ) TT ' + char(10)
			    SELECT @v_dSql += ' ) A ' + char(10)
			    SELECT @v_dSql += ' ORDER BY A.JOB_ORDER ' + char(10)

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END
	    END	--ELSE IF( END )

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,    @v_delimiter,  @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,    @v_delimiter,  @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,   @v_delimiter,  @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_instance_id              = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id , @v_delimiter,  @mst_loop_cnt)
                        , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,  @v_delimiter,  @mst_loop_cnt)
                        , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id , @v_delimiter,  @mst_loop_cnt)
                        , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,    @v_delimiter,  @mst_loop_cnt)
                        , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter,  @mst_loop_cnt)
                        , @v_line_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_date                = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,   @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_type                = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type ,   @v_delimiter,  @mst_loop_cnt)


					   /******************************************************************************/
					   /* EXECUTE  경우  :  EXEC_PAICALCUL                                       */
					   /******************************************************************************/
					   IF(@v_sys_flag ='EXEC_PAICALCUL')  
                           BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI] @v_instance_id, @v_plan_id
								
								SELECT	'Result' = @rtnCount

                            END
					  
					IF @v_sys_type = 'SQL'
						BEGIN
							--EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,'','',@v_dSql,'select',@runstart, @runend
							SELECT @v_dSql as [QUERY_VALUE]

						END
					ELSE
						BEGIN
							SET @runstart = GetDate()
							--쿼리실행
							EXEC sp_executesql @v_dSql

							SET @runend = GetDate()
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,@v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
						END

			    END --WHILE 내(END)

		END --ELSE (END)
 		
        -- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @v_sys_type <> 'SQL'
		    SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

		END TRY
		BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
			ROLLBACK TRAN                                                                                                                                                                                                                                                 
			-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
			SET @v_log_message = ERROR_MESSAGE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		END CATCH    

END --MAIN END

