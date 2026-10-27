


/*
 * Program ID   : PR_UI_FP00594_AMEND_MODEL
 * Description  : Buidling BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/15   JYJ				Initial Release UI통합
 * 2022/08/31   CYS				속도개선
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00594_AMEND_MODEL_NEW]
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
  @p_prod_type                  NVARCHAR(MAX),
  @p_item_id                    NVARCHAR(MAX),
  @p_nick_name                  NVARCHAR(MAX),
  @p_top_item_id                NVARCHAR(MAX),
  @p_bucket_from_date           NVARCHAR(MAX),
  @p_bucket_to_date             NVARCHAR(MAX),
  @p_day_info                   NVARCHAR(MAX),
  @p_week_info                  NVARCHAR(MAX),
  @p_month_info                 NVARCHAR(MAX),
  @p_cate_info                  NVARCHAR(MAX),
  @p_cate_value                 NVARCHAR(MAX),
  @p_cate_type                  NVARCHAR(MAX),
  @p_amend_table                NVARCHAR(100),
  @p_amend_cutoff_boh_table     NVARCHAR(100),
  @p_amend_bor_table            NVARCHAR(100),
  @p_amend_sales_table          NVARCHAR(100),
  @p_amend_util_table           NVARCHAR(100)

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
    DECLARE @v_prod_type                  NVARCHAR(MAX)
    DECLARE @v_item_id                    NVARCHAR(MAX)
    DECLARE @v_nick_name                  NVARCHAR(MAX)
    DECLARE @v_top_item_id                NVARCHAR(MAX)
    DECLARE @v_bucket_from_date           NVARCHAR(MAX)
    DECLARE @v_bucket_to_date             NVARCHAR(MAX)
    DECLARE @v_day_info                   NVARCHAR(MAX)
    DECLARE @v_week_info                  NVARCHAR(MAX)
    DECLARE @v_month_info                 NVARCHAR(MAX)
    DECLARE @v_cate_info                  NVARCHAR(MAX)
	DECLARE @v_cate_value                 NVARCHAR(MAX)
    DECLARE @v_cate_type                  NVARCHAR(MAX)
    DECLARE @v_amend_table                NVARCHAR(100) = 'FP_AMEND_PLAN_CELL_R'
    DECLARE @v_amend_cutoff_boh_table     NVARCHAR(100) = 'FP_AMEND_CUTOFF_BOH_R'
    DECLARE @v_amend_bor_table            NVARCHAR(100) = 'FP_AMEND_PLAN_CELL_BOR_R'
    DECLARE @v_amend_sales_table          NVARCHAR(100) = 'FP_AMEND_PLAN_CELL_SALES_R'
    DECLARE @v_amend_util_table           NVARCHAR(100) = 'FP_AMEND_PLAN_CELL_UTIL_R'

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00594_AMEND_MODEL'
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

    DECLARE @v_pSql                 NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''
	DECLARE @v_tmp3                 NVARCHAR(MAX)=''
    DECLARE @bSales                 NVARCHAR(2)= ''
    DECLARE @bDppIn                 NVARCHAR(2)= ''
    DECLARE @bDppOut                NVARCHAR(2)= ''
    DECLARE @bResult                NVARCHAR(2)= ''
    DECLARE @bInv                   NVARCHAR(2)= ''
    DECLARE @bWppIn                 NVARCHAR(2)= ''
    DECLARE @bWppOut                NVARCHAR(2)= ''
    DECLARE @bMppIn                 NVARCHAR(2)= ''
    DECLARE @bMppOut                NVARCHAR(2)= ''
    DECLARE @bUom                   NVARCHAR(2)= ''
    DECLARE @bCell                  NVARCHAR(2)= ''
    DECLARE @bTotal                 NVARCHAR(2)= ''
    DECLARE @bTotal2                NVARCHAR(2)= ''
    DECLARE @bEngIn                 NVARCHAR(2)= ''
    DECLARE @bEngOut                NVARCHAR(2)= ''
    DECLARE @bMemo					NVARCHAR(2)= ''

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
    SET @v_prod_type                = ''
    SET @v_item_id                  = ''
    SET @v_nick_name                = ''
    SET @v_top_item_id              = ''
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

	SET	@v_pSql                 = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''

/*	Parameter Setting End */

--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += 'P_SYS_TYPE:' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_FLAG:' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_GUBUN:' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += 'P_USER_ID:' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += 'P_COMPANY_ID            : ' + ISNULL(@p_company_id				, '') + char(10)         
--SET @PARAMS += 'P_DIVISION_ID           : ' + ISNULL(@p_division_id           	, '') + char(10)
--SET @PARAMS += 'P_SITE_ID               : ' + ISNULL(@p_site_id               	, '') + char(10)
--SET @PARAMS += 'P_PLANT_ID              : ' + ISNULL(@p_plant_id              	, '') + char(10)
--SET @PARAMS += 'P_FACTORY_ID            : ' + ISNULL(@p_factory_id            	, '') + char(10)
--SET @PARAMS += 'P_LINE_ID               : ' + ISNULL(@p_line_id               	, '') + char(10)
--SET @PARAMS += 'P_OPERATION_ID          : ' + ISNULL(@p_operation_id          	, '') + char(10)
--SET @PARAMS += 'P_MASTER_ID             : ' + ISNULL(@p_master_id             	, '') + char(10)
--SET @PARAMS += 'P_PLAN_DATE             : ' + ISNULL(@p_plan_date             	, '') + char(10)
--SET @PARAMS += 'P_PLAN_ID               : ' + ISNULL(@p_plan_id               	, '') + char(10)
--SET @PARAMS += 'P_PROD_TYPE             : ' + ISNULL(@p_prod_type             	, '') + char(10)
--SET @PARAMS += 'P_ITEM_ID               : ' + ISNULL(@p_item_id               	, '') + char(10)
--SET @PARAMS += 'P_NICK_NAME             : ' + ISNULL(@p_nick_name             	, '') + char(10)
--SET @PARAMS += 'P_TOP_ITEM_ID           : ' + ISNULL(@p_top_item_id           	, '') + char(10)
--SET @PARAMS += 'P_BUCKET_FROM_DATE      : ' + ISNULL(@p_bucket_from_date      	, '') + char(10)
--SET @PARAMS += 'P_BUCKET_TO_DATE        : ' + ISNULL(@p_bucket_to_date        	, '') + char(10)
--SET @PARAMS += 'P_DAY_INFO              : ' + ISNULL(@p_day_info              	, '') + char(10)
--SET @PARAMS += 'P_WEEK_INFO             : ' + ISNULL(@p_week_info             	, '') + char(10)
--SET @PARAMS += 'P_MONTH_INFO            : ' + ISNULL(@p_month_info            	, '') + char(10)
--SET @PARAMS += 'P_CATE_INFO             : ' + ISNULL(@p_cate_info             	, '') + char(10)
--SET @PARAMS += 'P_CATE_VALUE            : ' + ISNULL(@p_cate_value            	, '') + char(10)
--SET @PARAMS += 'P_CATE_TYPE             : ' + ISNULL(@p_cate_type             	, '') + char(10)
--SET @PARAMS += 'P_AMEND_TABLE           : ' + ISNULL(@p_amend_table           	, '') + char(10)
--SET @PARAMS += 'P_AMEND_CUTOFF_BOH_TABLE: ' + ISNULL(@p_amend_cutoff_boh_table	, '') + char(10)
--SET @PARAMS += 'P_AMEND_BOR_TABLE       : ' + ISNULL(@p_amend_bor_table       	, '') + char(10)
--SET @PARAMS += 'P_AMEND_SALES_TABLE     : ' + ISNULL(@p_amend_sales_table     	, '') + char(10)
--SET @PARAMS += 'P_AMEND_UTIL_TABLE      : ' + ISNULL(@p_amend_util_table      	, '') + char(10)

--SELECT @PARAMS AS SQL
--RETURN


	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
            SELECT @v_dSql1 = ''
			SELECT @v_dSql1 = '------------------------------------v_dSql1-----------------------------' + char(10)
      -- I : builing, location


	  if object_id('tempdb..#MAIN_I') is not null
		drop table #MAIN_I

            --SELECT @v_dSql1 += ' WITH MAIN_I AS (  ' + char(10)
            SELECT @v_dSql1 += '    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += '       , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME       ' + char(10)
            SELECT @v_dSql1 += '       , A.OPERATION_ID, A.FACTORY_ID, convert(nvarchar(50), A.LOCATION ) as [LOCATION]                 ' + char(10)
            SELECT @v_dSql1 += '       , ISNULL(MAX(A.QTY),0) AS BOH_QTY, convert(nvarchar(30), NULL) AS PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql1 += '       , convert(nvarchar(30), NULL) AS MARKET, ''I'' AS PSI, convert(nvarchar(30), NULL) AS LINE_ID            ' + char(10)
            SELECT @v_dSql1 += '       , convert(nvarchar(150), NULL) AS LINE_NAME, convert(nvarchar(50), NULL) AS ELECTRODE_TYPE, convert(nvarchar(50), NULL) AS CATE  ' + char(10)

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
                            SELECT @v_tmp1 += '       , NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                        END 

                    SELECT @v_tmp2 = ''
                    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
					SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_tmp2 += '       , SUM(CASE WHEN A.PLAN_WEEK <= ''' + @v_week_info + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' THEN A.EOH_QTY ELSE 0 END) ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                        END 

                    SELECT @v_tmp3 = ''
                    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_day_info     = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_tmp3 += '       , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''' + @v_day_info + ''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' THEN A.EOH_QTY ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                        END
				END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

            SELECT @v_dSql1 += '       , ''I'' AS CATEGORY_ID, 40 AS CATEGORY_ORDER ' + char(10)
            SELECT @v_dSql1 += '       , convert(nvarchar(50), NULL) AS MEASURE_ID, convert(nvarchar(50), NULL) AS MEASURE_NAME   ' + char(10)
            SELECT @v_dSql1 += '       , ''DATA'' AS DATA_TYPE, NULL AS S_ROW       ' + char(10)
  			SELECT @v_dSql1 += '  INTO #MAIN_I ' + char(10)          
			SELECT @v_dSql1 += '  FROM ( ' + char(10)
            SELECT @v_dSql1 += '        SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += '              , AA.TOP_ITEM_ID, AA.ITEM_ID, AA.ITEM_TYPE, AA.NICK_NAME    ' + char(10)
            SELECT @v_dSql1 += '              , AA.OPERATION_ID, AA.FACTORY_ID, AA.LOCATION, AA.PLAN_DATE ' + char(10)
            SELECT @v_dSql1 += '              , AA.ISO_YYYYWW AS PLAN_WEEK, AA.WEEK_ENDDATE, D.QTY        ' + char(10)
            SELECT @v_dSql1 += '              , CASE WHEN AA.PLAN_DATE = CONVERT(DATE,''' + @p_plan_date + ''') THEN (D.QTY - SALES_QTY + OUT_QTY) ELSE (0 - SALES_QTY + OUT_QTY) END AS EOH_QTY ' + char(10)
            SELECT @v_dSql1 += '        FROM ( ' + char(10)
            SELECT @v_dSql1 += '               SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql1 += '                  , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.ITEM_TYPE,''-'') AS ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql1 += '                  , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, E.DT AS PLAN_DATE, E.ISO_YYYYWW, E.WEEK_ENDDATE ' + char(10)
            SELECT @v_dSql1 += '                  , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.OUT_QTY ELSE 0 END)    AS OUT_QTY   ' + char(10)
            SELECT @v_dSql1 += '                  , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.SALES_QTY ELSE 0 END)  AS SALES_QTY ' + char(10)
            SELECT @v_dSql1 += '               FROM (                                                                    ' + char(10)
            SELECT @v_dSql1 += '                         SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID ' + char(10)
            SELECT @v_dSql1 += '                              , A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID          ' + char(10)
            SELECT @v_dSql1 += '                              , NULL ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
            SELECT @v_dSql1 += '                              , NULL AS BOH_QTY, A.PRODUCTION_TYPE, A.MARKET             ' + char(10)
            SELECT @v_dSql1 += '                              , ''I'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE   ' + char(10)
            SELECT @v_dSql1 += '                              , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' THEN A.OUT_QTY ELSE 0 END AS OUT_QTY ' + char(10)
            SELECT @v_dSql1 += '                              , 0 AS SALES_QTY                            ' + char(10)
            SELECT @v_dSql1 += '                         FROM   '+ @p_amend_table +' A WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql1 += '                         WHERE  A.INSTANCE_ID  = ''' + @p_master_id + ''' ' + char(10)
            SELECT @v_dSql1 += '                         AND    A.FP_PLAN_ID   = ''' + @p_plan_id + '''   ' + char(10)
            SELECT @v_dSql1 += '                         AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' + char(10)
            SELECT @v_dSql1 += '                         AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)                  ' + char(10)
            SELECT @v_dSql1 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql1 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql1 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql1 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql1 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql1 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
		    IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '                         AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''        ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '                         AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''                ' + char(10)
			    END	

            SELECT @v_dSql1 += '                      UNION ALL                                                         ' + char(10)
            SELECT @v_dSql1 += '                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID   ' + char(10)
            SELECT @v_dSql1 += '                           , A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID            ' + char(10)
            SELECT @v_dSql1 += '                           , NULL ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION   ' + char(10)
            SELECT @v_dSql1 += '                           , NULL AS BOH_QTY, A.PRODUCTION_TYPE, A.MARKET, ''I'' AS PSI ' + char(10)
            SELECT @v_dSql1 += '                           , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, 0 AS OUT_QTY     ' + char(10)
            SELECT @v_dSql1 += '                           , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' THEN ISNULL(A.SALES_QTY,0) ELSE 0 END AS SALES_QTY ' + char(10)
            SELECT @v_dSql1 += '                      FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID  = ''' + @p_master_id + ''' ' + char(10)
            SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID   = ''' + @p_plan_id + '''   ' + char(10)
            SELECT @v_dSql1 += '                      AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' + char(10)
            SELECT @v_dSql1 += '                      AND    A.SALES_QTY <> 0                          ' + char(10)
            SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
		    IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '                      AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '                      AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
            SELECT @v_dSql1 += '              ) A         ' + char(10)
            SELECT @v_dSql1 += '             INNER JOIN ( ' + char(10)
            SELECT @v_dSql1 += '                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, ' + char(10)
            SELECT @v_dSql1 += '                        (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
            SELECT @v_dSql1 += '                              WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
            SELECT @v_dSql1 += '                              ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
            SELECT @v_dSql1 += '                       ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME      ' + char(10)
            SELECT @v_dSql1 += '                 FROM	 SCM_ITEM_M A WITH(NOLOCK),                 ' + char(10)
            SELECT @v_dSql1 += '                   	 SCM_ITEM_CLASS_M C WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql1 += '                 WHERE	 A.ITEM_CLASS  = C.CLASS_ID                 ' + char(10)
            SELECT @v_dSql1 += '                 ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql1 += '                 ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
		    IF LEN(@p_nick_name) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '                 AND  A.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			    END	
            SELECT @v_dSql1 += '            ) B                                   ' + char(10)
            SELECT @v_dSql1 += '            ON  A.COMPANY_ID  = B.COMPANY_ID      ' + char(10)
            SELECT @v_dSql1 += '            AND A.DIVISION_ID = B.DIVISION_ID     ' + char(10)
            SELECT @v_dSql1 += '            AND A.SITE_ID     = B.SITE_ID         ' + char(10)
            SELECT @v_dSql1 += '            AND A.ITEM_ID     = B.ITEM_ID         ' + char(10)
            SELECT @v_dSql1 += '            INNER JOIN SCM_ITEM_M C WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql1 += '            ON     A.COMPANY_ID   = C.COMPANY_ID  ' + char(10)
            SELECT @v_dSql1 += '            AND    A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
            SELECT @v_dSql1 += '            AND    A.SITE_ID      = C.SITE_ID     ' + char(10)
            SELECT @v_dSql1 += '            AND    A.TOP_ITEM_ID  = C.ITEM_ID     ' + char(10)
            SELECT @v_dSql1 += '            INNER JOIN (                          ' + char(10)
            --SELECT @v_dSql1 += '                 SELECT A.* , B.YYYYMMDD AS WEEK_ENDDATE ' + char(10)
			SELECT @v_dSql1 += '                 SELECT A.DT, A.YYYYMMDD, A.ISO_YYYYWW, B.YYYYMMDD AS WEEK_ENDDATE  ' + char(10)
            SELECT @v_dSql1 += '                 FROM TH_UIS_CAL A WITH(NOLOCK)          ' + char(10)
            SELECT @v_dSql1 += '                    , TH_UIS_CAL B WITH(NOLOCK)          ' + char(10)
            SELECT @v_dSql1 += '                 WHERE 1=1                               ' + char(10)
            --SELECT @v_dSql1 += '                 AND CONVERT(VARCHAR,A.DT,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''   ' + char(10)
            SELECT @v_dSql1 += '                 AND A.DT BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''   ' + char(10)
			SELECT @v_dSql1 += '                 AND A.ISO_YYYYWW = B.ISO_YYYYWW  ' + char(10)
            SELECT @v_dSql1 += '                 AND B.DAY_SEQ = ''1''            ' + char(10)
            SELECT @v_dSql1 += '          ) E       ' + char(10)
            SELECT @v_dSql1 += '          ON    1=1 ' + char(10)
            SELECT @v_dSql1 += '          WHERE 1=1 ' + char(10)
            SELECT @v_dSql1 += '          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            SELECT @v_dSql1 += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                        ' + char(10)
            SELECT @v_dSql1 += '            , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.ITEM_TYPE,''-''), ISNULL(C.NICK_NAME,''-'') ' + char(10)
            SELECT @v_dSql1 += '            , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, E.DT, E.ISO_YYYYWW, E.WEEK_ENDDATE   ' + char(10)
            SELECT @v_dSql1 += '    ) AA                       ' + char(10)
            SELECT @v_dSql1 += '    LEFT OUTER HASH JOIN (     ' + char(10)
            SELECT @v_dSql1 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID      ' + char(10)
            SELECT @v_dSql1 += '            , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID, SUM(A.QTY) AS QTY  ' + char(10)
            SELECT @v_dSql1 += '          FROM (               ' + char(10)
            SELECT @v_dSql1 += '               SELECT DISTINCT ' + char(10)
            SELECT @v_dSql1 += '                      A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql1 += '                    , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID, 0 AS QTY   ' + char(10)
            SELECT @v_dSql1 += '               FROM   '+ @p_amend_table +' A WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql1 += '               WHERE  A.INSTANCE_ID  = ''' + @p_master_id + '''  ' + char(10)
            SELECT @v_dSql1 += '               AND    A.FP_PLAN_ID   = ''' + @p_plan_id + '''    ' + char(10)
            SELECT @v_dSql1 += '               ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql1 += '               ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql1 += '               ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql1 += '               ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql1 += '               ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql1 += '               ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
            SELECT @v_dSql1 += '               AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' + char(10)
            SELECT @v_dSql1 += '               UNION ALL                                                                                    ' + char(10)
            SELECT @v_dSql1 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                      ' + char(10)
            SELECT @v_dSql1 += '                 , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY ' + char(10)
            SELECT @v_dSql1 += '               FROM   '+ @p_amend_cutoff_boh_table +' A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '               WHERE  A.INSTANCE_ID  = ''' + @p_master_id + '''      ' + char(10)
            SELECT @v_dSql1 += '               AND    A.FP_PLAN_ID   = ''' + @p_plan_id + '''        ' + char(10)
            SELECT @v_dSql1 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql1 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql1 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql1 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql1 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql1 += '           ) A ' + char(10)
            SELECT @v_dSql1 += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql1 += '                  , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID             ' + char(10)
            SELECT @v_dSql1 += '     ) D       ' + char(10)
            SELECT @v_dSql1 += '     ON     AA.COMPANY_ID   = D.COMPANY_ID   ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.DIVISION_ID  = D.DIVISION_ID  ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.SITE_ID      = D.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.PLANT_ID     = D.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.FACTORY_ID   = D.FACTORY_ID   ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.OPERATION_ID = D.OPERATION_ID ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.LOCATION     = D.LOCATION     ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.ITEM_ID      = D.ITEM_ID      ' + char(10)
            SELECT @v_dSql1 += '     AND    AA.TOP_ITEM_ID  = D.TOP_ITEM_ID  ' + char(10)
            SELECT @v_dSql1 += ' ) A        ' + char(10)
            SELECT @v_dSql1 += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql1 += '    , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME     ' + char(10)
            SELECT @v_dSql1 += '    , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION               ' + char(10)
            --SELECT @v_dSql1 += ' )          ' + char(10)

            SELECT @v_dSql2  = ''
		    SELECT @v_dSql2  = '------------------------------------------v_dSql2------------------------------------------------------' +char(10)
		    --SELECT @v_dSql2 += ' , MAIN_S AS ( ' + char(10)
            SELECT @v_dSql2 += '     -- S : builing, location, production type, market                                    ' + char(10)
            
			
			if object_id('tempdb..#MAIN_S') is not null
				drop table #MAIN_S

			
			SELECT @v_dSql2 += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                            ' + char(10)
            SELECT @v_dSql2 += '          , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql2 += '          , A.OPERATION_ID, A.FACTORY_ID, convert(nvarchar(50), A.LOCATION ) as [LOCATION], ISNULL(D.QTY,0) AS BOH_QTY          ' + char(10)
            SELECT @v_dSql2 += '          , A.PRODUCTION_TYPE, A.MARKET, A.PSI, convert(nvarchar(30), A.LINE_ID) AS LINE_ID ' + char(10)
            SELECT @v_dSql2 += '          , convert(nvarchar(150),null) AS LINE_NAME, convert(nvarchar(50), A.ELECTRODE_TYPE) AS ELECTRODE_TYPE, A.CATE   ' + char(10)
		 
		    IF ( LEN(@p_day_info) > 0)
		      BEGIN
                 SELECT @v_tmp1 = ''
                 SELECT @max_loop_cnt = 0
                 SELECT @mst_loop_cnt = 0
                 SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                       
                 WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                     BEGIN
                         SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                         SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                         SELECT @v_tmp1 += '          , A.M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                     END 

                 SELECT @v_tmp2 = ''
                 SELECT @max_loop_cnt = 0
                 SELECT @mst_loop_cnt = 0
                 SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                       
                 WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                     BEGIN
                         SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                         SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
                         SELECT @v_tmp2 += '          , A.W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                     END 
                     
                 SELECT @v_tmp3 = ''
                 SELECT @max_loop_cnt = 0
                 SELECT @mst_loop_cnt = 0
                 SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                 
                 WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                     BEGIN
                         SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                         SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
                         SELECT @v_tmp3 += '          , A.D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                     END 
              END

            SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 +  @v_tmp2 +  @v_tmp3
		  
            SELECT @v_dSql2 += '          , A.CATEGORY_ID, A.CATEGORY_ORDER, convert(nvarchar(50), NULL) AS MEASURE_ID         ' + char(10)
            SELECT @v_dSql2 += '          , convert(nvarchar(50), NULL) AS MEASURE_NAME, A.DATA_TYPE, A.S_ROW                  ' + char(10)
            SELECT @v_dSql2 += '     INTO #MAIN_S                                                             ' + char(10)
			SELECT @v_dSql2 += '     FROM (                                                             ' + char(10)
            SELECT @v_dSql2 += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
            SELECT @v_dSql2 += '                , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql2 += '                , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
            SELECT @v_dSql2 += '                , ''S'' AS PSI, NULL AS LINE_ID, NULL AS ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql2 += '                , B.CATEGORY_NAME AS CATE                               ' + char(10)

		    IF ( LEN(@p_day_info) > 0)
		      BEGIN
                  SELECT @v_tmp1 =''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                      BEGIN
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info     = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '               , SUM(CASE WHEN E.YYYYMM =''' + @v_month_info + ''' THEN (CASE WHEN B.CATEGORY_ID=''S'' THEN A.SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                      END 

                      SELECT @v_tmp2 =''                      
                      SELECT @max_loop_cnt = 0
                      SELECT @mst_loop_cnt = 0
                      SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                      
                  WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                      BEGIN
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info     = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp2 += '               , SUM(CASE WHEN E.ISO_YYYYWW=''' + @v_week_info + ''' THEN (CASE WHEN B.CATEGORY_ID=''S'' THEN A.SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                      END 

                      SELECT @v_tmp3 =''                           
                      SELECT @max_loop_cnt = 0
                      SELECT @mst_loop_cnt = 0
                      SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                      
                  WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                      BEGIN
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info     = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp3 += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @v_day_info + ''' THEN (CASE WHEN B.CATEGORY_ID=''S'' THEN A.SALES_QTY ELSE A.PAST_SALES_QTY END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                      END  
		      END 
          
		    SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 + @v_tmp2 + @v_tmp3

            SELECT @v_dSql2 += '                , B.CATEGORY_ID, B.CATEGORY_ORDER, ''DATA'' AS DATA_TYPE ' + char(10)
            SELECT @v_dSql2 += '                , ROW_NUMBER() OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
            SELECT @v_dSql2 += '                     ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, B.CATEGORY_ORDER) AS S_ROW ' + char(10)
            SELECT @v_dSql2 += '             FROM   ( ' + char(10)
            SELECT @v_dSql2 += '                     SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '                          , A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID            ' + char(10)
            SELECT @v_dSql2 += '                          , NULL ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION   ' + char(10)
            SELECT @v_dSql2 += '                          , NULL AS BOH_QTY, A.PRODUCTION_TYPE, A.MARKET, ''S'' AS PSI ' + char(10)
            SELECT @v_dSql2 += '                          , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE                   ' + char(10)
            SELECT @v_dSql2 += '                          , A.SALES_QTY, A.PAST_SALES_QTY                              ' + char(10)
            SELECT @v_dSql2 += '                     FROM   '+ @p_amend_sales_table +' A WITH(NOLOCK)                  ' + char(10)
            SELECT @v_dSql2 += '                     WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                    ' + char(10)
            SELECT @v_dSql2 += '                     AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                      ' + char(10)
            SELECT @v_dSql2 += '                     AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' + char(10)
            SELECT @v_dSql2 += '                     AND    ( ISNULL(A.SALES_QTY,0) > 0 OR ISNULL(A.PAST_SALES_QTY,0) > 0)             ' + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
		    IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '                     AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '                     AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
            SELECT @v_dSql2 += '                     UNION ALL                                                         ' + char(10)
            SELECT @v_dSql2 += '                     SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID   ' + char(10)
            SELECT @v_dSql2 += '                          , A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID            ' + char(10)
            SELECT @v_dSql2 += '                          , NULL ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION   ' + char(10)
            SELECT @v_dSql2 += '                          , NULL AS BOH_QTY, A.PRODUCTION_TYPE, A.MARKET, ''S'' AS PSI ' + char(10)
            SELECT @v_dSql2 += '                          , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE                   ' + char(10)
            SELECT @v_dSql2 += '                          , 0 AS SALES_QTY, 0 AS PAST_SALES_QTY                        ' + char(10)
            SELECT @v_dSql2 += '                     FROM   '+ @p_amend_table +' A WITH(NOLOCK)                        ' + char(10)
            SELECT @v_dSql2 += '                     WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                    ' + char(10)
            SELECT @v_dSql2 += '                     AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                      ' + char(10)
            SELECT @v_dSql2 += '                     AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' + char(10)
            SELECT @v_dSql2 += '                     AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0) ' + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))           + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                   + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                 + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))             + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))         + char(10)
            SELECT @v_dSql2 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                   + char(10)
		    IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '                     AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '                     AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
            SELECT @v_dSql2 += '             ) A             ' + char(10)
            SELECT @v_dSql2 += '             INNER JOIN (    ' + char(10)
            SELECT @v_dSql2 += '                   SELECT ''S'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER ' + char(10)
            SELECT @v_dSql2 += '                   UNION ALL ' + char(10)
            SELECT @v_dSql2 += '                   SELECT ''PAST_SALES'' AS CATEGORY_ID, ''S(W-1)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER ' + char(10)
            SELECT @v_dSql2 += '             ) B             ' + char(10)
            SELECT @v_dSql2 += '             ON 1=1          ' + char(10)
            SELECT @v_dSql2 += '             INNER HASH JOIN TH_UIS_CAL E WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql2 += '             ON     A.PLAN_DATE    = E.DT                   ' + char(10)
            SELECT @v_dSql2 += '             WHERE  A.INSTANCE_ID  = '''+ @p_master_id +''' ' + char(10)
            SELECT @v_dSql2 += '             AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''   ' + char(10)
            SELECT @v_dSql2 += '             AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''  ' + char(10)
            SELECT @v_dSql2 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql2 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql2 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql2 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql2 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql2 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
		    IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '             AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '             AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	

            SELECT @v_dSql2 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            SELECT @v_dSql2 += '             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
            SELECT @v_dSql2 += '                  , A.ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE       ' + char(10)
            SELECT @v_dSql2 += '                  , A.MARKET, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER                     ' + char(10)
            SELECT @v_dSql2 += '     ) A           ' + char(10)

            SELECT @v_dSql2 += '     INNER HASH JOIN (  ' + char(10)
            SELECT @v_dSql2 += '         SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                                          ' + char(10)
            SELECT @v_dSql2 += '            ,(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
            SELECT @v_dSql2 += '                  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                             ' + char(10)
            SELECT @v_dSql2 += '                  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
            SELECT @v_dSql2 += '           ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME      ' + char(10)
            SELECT @v_dSql2 += '         FROM  SCM_ITEM_M A WITH(NOLOCK),               ' + char(10)
            SELECT @v_dSql2 += '               SCM_ITEM_CLASS_M C WITH(NOLOCK)          ' + char(10)
            SELECT @v_dSql2 += '         WHERE  A.ITEM_CLASS  = C.CLASS_ID              ' + char(10)
            SELECT @v_dSql2 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql2 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            IF LEN(@p_top_item_id) > 0 																			                
			   BEGIN																						                
                    SELECT @v_dSql2 += '             AND  A.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''   ' + char(10)
			   END	
            SELECT @v_dSql2 += '     ) B                                   ' + char(10)
            SELECT @v_dSql2 += '     ON  A.COMPANY_ID  = B.COMPANY_ID      ' + char(10)
            SELECT @v_dSql2 += '     AND A.DIVISION_ID = B.DIVISION_ID     ' + char(10)
            SELECT @v_dSql2 += '     AND A.SITE_ID     = B.SITE_ID         ' + char(10)
            SELECT @v_dSql2 += '     AND A.ITEM_ID     = B.ITEM_ID         ' + char(10)

            SELECT @v_dSql2 += '     INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql2 += '     ON     A.COMPANY_ID   = C.COMPANY_ID  ' + char(10)
            SELECT @v_dSql2 += '     AND    A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
            SELECT @v_dSql2 += '     AND    A.SITE_ID      = C.SITE_ID     ' + char(10)
            SELECT @v_dSql2 += '     AND    A.TOP_ITEM_ID  = C.ITEM_ID     ' + char(10)
            SELECT @v_dSql2 += '     LEFT OUTER JOIN (                     ' + char(10)
            SELECT @v_dSql2 += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql2 += '                  , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID, SUM(ISNULL(A.MODIFY_QTY, A.QTY)) AS QTY ' + char(10)
            SELECT @v_dSql2 += '             FROM   '+ @p_amend_cutoff_boh_table +'  A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '             WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''         ' + char(10)
            SELECT @v_dSql2 += '             AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''           ' + char(10)
            SELECT @v_dSql2 += '     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql2 += '     '+(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql2 += '     '+(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql2 += '     '+(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql2 += '     '+(SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql2 += '             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql2 += '                    , A.OPERATION_ID, A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID             ' + char(10)
            SELECT @v_dSql2 += '     ) D                                    ' + char(10)
            SELECT @v_dSql2 += '     ON     A.COMPANY_ID   = D.COMPANY_ID   ' + char(10)
            SELECT @v_dSql2 += '     AND    A.DIVISION_ID  = D.DIVISION_ID  ' + char(10)
            SELECT @v_dSql2 += '     AND    A.SITE_ID      = D.SITE_ID      ' + char(10)
            SELECT @v_dSql2 += '     AND    A.PLANT_ID     = D.PLANT_ID     ' + char(10)
            SELECT @v_dSql2 += '     AND    A.FACTORY_ID   = D.FACTORY_ID   ' + char(10)
            SELECT @v_dSql2 += '     AND    A.OPERATION_ID = D.OPERATION_ID ' + char(10)
            SELECT @v_dSql2 += '     AND    A.LOCATION     = D.LOCATION     ' + char(10)
            SELECT @v_dSql2 += '     AND    A.ITEM_ID      = D.ITEM_ID      ' + char(10)
            SELECT @v_dSql2 += '     AND    A.TOP_ITEM_ID  = D.TOP_ITEM_ID  ' + char(10)
            --SELECT @v_dSql2 += ' )                                          ' + char(10)
		  
		    SELECT @v_dSql3  =''
		    SELECT @v_dSql3  ='-------------------------------------------------------v_dSql3-----------------------------------------------' +char(10)
            --SELECT @v_dSql3 += ' , MAIN_P AS ( ' + char(10)
            SELECT @v_dSql3 += '     -- P : builing, location, production type, market, line            ' +char(10)
            
			
			if object_id('tempdb..#MAIN_P') is not null
				drop table #MAIN_P
			



			SELECT @v_dSql3 += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID         ' +char(10)
            SELECT @v_dSql3 += '         , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME           ' +char(10)
            SELECT @v_dSql3 += '         , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION                     ' +char(10)
            SELECT @v_dSql3 += '         , ISNULL(MAX(F.QTY),0) AS BOH_QTY, A.PRODUCTION_TYPE, A.MARKET ' +char(10)
            SELECT @v_dSql3 += '         , ''P'' AS PSI, A.LINE_ID, A.LINE_NAME                         ' +char(10)
            SELECT @v_dSql3 += '         , A.ELECTRODE_TYPE, D.CATE_NAME AS CATE                        ' +char(10)
          
		    SELECT @v_tmp1 = ''
		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
            IF  LEN(@p_day_info) > 0
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN
                          SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                          SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp1 += '   , SUM(CASE WHEN G.YYYYMM=''' + @v_month_info + ''' THEN (CASE WHEN D.CATE_ID = ''M_IN_CELL'' THEN A.MPP_CELL_IN_QTY  ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''M_IN''          THEN A.MPP_IN_QTY           ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''M_OUT_CELL''    THEN A.MPP_CELL_OUT_QTY     ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''M_OUT''         THEN A.MPP_OUT_QTY          ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''W_IN_CELL''     THEN A.WPP_CELL_IN_QTY      ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''W_IN''          THEN A.WPP_IN_QTY           ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''W_OUT_CELL''    THEN A.WPP_CELL_OUT_QTY     ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''W_OUT''         THEN A.WPP_OUT_QTY          ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_IN_CELL''     THEN A.CELL_IN_QTY          ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_IN''          THEN A.IN_QTY               ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_OUT_CELL''    THEN A.CELL_OUT_QTY         ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_OUT''         THEN A.OUT_QTY              ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN A.RESULT_CELL_OUT_QTY  ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_RESULT''      THEN A.RESULT_OUT_QTY       ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_IN_ENGINE_CELL''  THEN A.ORG_CELL_IN_QTY  ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_IN_ENGINE''       THEN A.ORG_IN_QTY       ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_OUT_ENGINE_CELL'' THEN A.ORG_CELL_OUT_QTY ' +char(10)
                          SELECT @v_tmp1 += '       WHEN D.CATE_ID = ''P_OUT_ENGINE''      THEN A.ORG_OUT_QTY      ' +char(10)
                          SELECT @v_tmp1 += '       ELSE 0 END ) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                          
                      END

                  SELECT @v_tmp2 = ''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						  SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
                          
                          SELECT @v_tmp2 += '   , SUM(CASE WHEN G.ISO_YYYYWW=''' + @v_week_info + ''' THEN (CASE WHEN D.CATE_ID = ''M_IN_CELL'' THEN A.MPP_CELL_IN_QTY  ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''M_IN''          THEN A.MPP_IN_QTY           ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''M_OUT_CELL''    THEN A.MPP_CELL_OUT_QTY     ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''M_OUT''         THEN A.MPP_OUT_QTY          ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''W_IN_CELL''     THEN A.WPP_CELL_IN_QTY      ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''W_IN''          THEN A.WPP_IN_QTY           ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''W_OUT_CELL''    THEN A.WPP_CELL_OUT_QTY     ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''W_OUT''         THEN A.WPP_OUT_QTY          ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_IN_CELL''     THEN A.CELL_IN_QTY          ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_IN''          THEN A.IN_QTY               ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_OUT_CELL''    THEN A.CELL_OUT_QTY         ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_OUT''         THEN A.OUT_QTY              ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN A.RESULT_CELL_OUT_QTY  ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_RESULT''      THEN A.RESULT_OUT_QTY       ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_IN_ENGINE_CELL''  THEN A.ORG_CELL_IN_QTY  ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_IN_ENGINE''       THEN A.ORG_IN_QTY       ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_OUT_ENGINE_CELL'' THEN A.ORG_CELL_OUT_QTY ' +char(10) 
                          SELECT @v_tmp2 += '           WHEN D.CATE_ID = ''P_OUT_ENGINE''      THEN A.ORG_OUT_QTY      ' +char(10) 
                          SELECT @v_tmp2 += '           ELSE 0 END ) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'               ' +char(10)  
                          
                      END

                  SELECT @v_tmp3 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp3 += '   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @v_day_info + ''' THEN (CASE WHEN D.CATE_ID = ''M_IN_CELL'' THEN A.MPP_CELL_IN_QTY  ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''M_IN''          THEN A.MPP_IN_QTY           ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''M_OUT_CELL''    THEN A.MPP_CELL_OUT_QTY     ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''M_OUT''         THEN A.MPP_OUT_QTY          ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''W_IN_CELL''     THEN A.WPP_CELL_IN_QTY      ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''W_IN''          THEN A.WPP_IN_QTY           ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''W_OUT_CELL''    THEN A.WPP_CELL_OUT_QTY     ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''W_OUT''         THEN A.WPP_OUT_QTY          ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_IN_CELL''     THEN A.CELL_IN_QTY          ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_IN''          THEN A.IN_QTY               ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_OUT_CELL''    THEN A.CELL_OUT_QTY         ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_OUT''         THEN A.OUT_QTY              ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN A.RESULT_CELL_OUT_QTY  ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_RESULT''      THEN A.RESULT_OUT_QTY       ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_IN_ENGINE_CELL''  THEN A.ORG_CELL_IN_QTY  ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_IN_ENGINE''       THEN A.ORG_IN_QTY       ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_OUT_ENGINE_CELL'' THEN A.ORG_CELL_OUT_QTY ' +char(10)
                          SELECT @v_tmp3 += '            WHEN D.CATE_ID = ''P_OUT_ENGINE''      THEN A.ORG_OUT_QTY      ' +char(10)
                          SELECT @v_tmp3 += '            ELSE 0 END ) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10) 
                          
                      END
              END
            SELECT  @v_dSql3  = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3   

            SELECT @v_dSql3 += '       , D.CATE_ID AS CATEGORY_ID       ' +char(10) 
            SELECT @v_dSql3 += '       , D.CATE_ORDER AS CATEGORY_ORDER ' +char(10) 
            SELECT @v_dSql3 += '       , D.MEASURE_ID, D.MEASURE_NAME   ' +char(10) 
            SELECT @v_dSql3 += '       , ''DATA'' AS DATA_TYPE          ' +char(10) 
            SELECT @v_dSql3 += '       , NULL AS S_ROW                  ' +char(10) 
            SELECT @v_dSql3 += '  INTO  #MAIN_P                                ' +char(10) 
			
			SELECT @v_dSql3 += '  FROM (                                ' +char(10) 
            SELECT @v_dSql3 += '        SELECT   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                         ' +char(10)
            SELECT @v_dSql3 += '           , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, A.OPERATION_ID                          ' +char(10)
            SELECT @v_dSql3 += '           , A.FACTORY_ID, A.LOCATION, A.BOH_QTY, A.PRODUCTION_TYPE                         ' +char(10)
            SELECT @v_dSql3 += '           , A.MARKET, A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE                      ' +char(10)
            SELECT @v_dSql3 += '           , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME ' +char(10)
            SELECT @v_dSql3 += '           , A.IN_QTY, A.OUT_QTY, A.CELL_IN_QTY, A.CELL_OUT_QTY, A.MPP_IN_QTY               ' +char(10)
            SELECT @v_dSql3 += '           , A.MPP_CELL_IN_QTY, A.MPP_OUT_QTY, A.MPP_CELL_OUT_QTY, A.WPP_IN_QTY, A.WPP_CELL_IN_QTY    ' +char(10)
            SELECT @v_dSql3 += '           , A.WPP_OUT_QTY, A.WPP_CELL_OUT_QTY, A.RESULT_CELL_OUT_QTY, A.RESULT_OUT_QTY, A.ORG_IN_QTY ' +char(10)
            SELECT @v_dSql3 += '           , A.ORG_OUT_QTY, A.ORG_CELL_IN_QTY, A.ORG_CELL_OUT_QTY                ' +char(10)
            SELECT @v_dSql3 += '         FROM (                                                                  ' +char(10)
            SELECT @v_dSql3 += '              SELECT 	A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID ' +char(10)
            SELECT @v_dSql3 += '                    , A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID            ' +char(10)
            SELECT @v_dSql3 += '                    , NULL ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, NULL AS BOH_QTY  ' +char(10)
            SELECT @v_dSql3 += '                    , A.PRODUCTION_TYPE, A.MARKET, ''P'' AS PSI, A.LINE_ID                       ' +char(10)
            SELECT @v_dSql3 += '                    , A.ELECTRODE_TYPE, A.PLAN_DATE, A.IN_QTY, A.OUT_QTY                         ' +char(10)
            SELECT @v_dSql3 += '                    , A.CELL_IN_QTY, A.CELL_OUT_QTY, A.MPP_IN_QTY, A.MPP_CELL_IN_QTY             ' +char(10)
            SELECT @v_dSql3 += '                    , A.MPP_OUT_QTY, A.MPP_CELL_OUT_QTY, A.WPP_IN_QTY, A.WPP_CELL_IN_QTY         ' +char(10)
            SELECT @v_dSql3 += '                    , A.WPP_OUT_QTY, A.WPP_CELL_OUT_QTY, A.RESULT_CELL_OUT_QTY, A.RESULT_OUT_QTY ' +char(10)
            SELECT @v_dSql3 += '                    , A.ORG_IN_QTY, A.ORG_OUT_QTY, A.ORG_CELL_IN_QTY, A.ORG_CELL_OUT_QTY         ' +char(10)
            SELECT @v_dSql3 += '              FROM   '+ @p_amend_table +'  A WITH(NOLOCK)                                        ' +char(10)
            SELECT @v_dSql3 += '              WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                     ' +char(10)
            SELECT @v_dSql3 += '              AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                       ' +char(10)
            SELECT @v_dSql3 += '              AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''      ' +char(10)
            SELECT @v_dSql3 += '              AND	   (ISNULL(A.OUT_QTY,0) + ISNULL(A.MPP_OUT_QTY,0) + ISNULL(A.WPP_OUT_QTY,0) + ISNULL(A.RESULT_OUT_QTY,0)) <> 0 ' +char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
		    IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql3 += '              AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql3 += '              AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	

            SELECT @v_dSql3 += '         ) A                                                                     ' +char(10)
            SELECT @v_dSql3 += '         INNER JOIN (                                                            ' +char(10)
            SELECT @v_dSql3 += '              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID  ' +char(10)
            SELECT @v_dSql3 += '                   ,(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' +char(10)
            SELECT @v_dSql3 += '                     	  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' +char(10)
            SELECT @v_dSql3 += '                     	  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' +char(10)
            SELECT @v_dSql3 += '                   ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME      ' +char(10)
            SELECT @v_dSql3 += '              FROM	 SCM_ITEM_M A WITH(NOLOCK),                 ' +char(10)
            SELECT @v_dSql3 += '                		 SCM_ITEM_CLASS_M C WITH(NOLOCK)        ' +char(10)
            SELECT @v_dSql3 += '              WHERE	 A.ITEM_CLASS  = C.CLASS_ID                 ' +char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql3 += '              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'EQ', @p_nick_name))        + char(10)
            SELECT @v_dSql3 += '         ) B                                         ' +char(10)
            SELECT @v_dSql3 += '         ON     A.COMPANY_ID  = B.COMPANY_ID         ' +char(10)
            SELECT @v_dSql3 += '          AND    A.DIVISION_ID = B.DIVISION_ID       ' +char(10)
            SELECT @v_dSql3 += '          AND    A.SITE_ID     = B.SITE_ID           ' +char(10)
            SELECT @v_dSql3 += '          AND    A.ITEM_ID     = B.ITEM_ID           ' +char(10)
            SELECT @v_dSql3 += '         INNER JOIN SCM_ITEM_M C WITH(NOLOCK)        ' +char(10)
            SELECT @v_dSql3 += '          ON     A.COMPANY_ID   = C.COMPANY_ID       ' +char(10)
            SELECT @v_dSql3 += '          AND    A.DIVISION_ID  = C.DIVISION_ID      ' +char(10)
            SELECT @v_dSql3 += '          AND    A.SITE_ID      = C.SITE_ID          ' +char(10)
            SELECT @v_dSql3 += '          AND    A.TOP_ITEM_ID  = C.ITEM_ID          ' +char(10)
            SELECT @v_dSql3 += '         INNER JOIN SCM_LINE_M E WITH(NOLOCK)        ' +char(10)
            SELECT @v_dSql3 += '          ON     A.COMPANY_ID     = E.COMPANY_ID     ' +char(10)
            SELECT @v_dSql3 += '          AND    A.DIVISION_ID    = E.DIVISION_ID    ' +char(10)
            SELECT @v_dSql3 += '          AND    A.SITE_ID        = E.SITE_ID        ' +char(10)
            SELECT @v_dSql3 += '          AND    A.PLANT_ID       = E.PLANT_ID       ' +char(10)
            SELECT @v_dSql3 += '          AND    A.FACTORY_ID     = E.FACTORY_ID     ' +char(10)
            SELECT @v_dSql3 += '          AND    A.OPERATION_ID   = E.OPERATION_ID   ' +char(10)
            SELECT @v_dSql3 += '          AND    A.LINE_ID        = E.LINE_ID        ' +char(10)
            SELECT @v_dSql3 += '          AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' +char(10)
            SELECT @v_dSql3 += '   ) A                                               ' +char(10)
            SELECT @v_dSql3 += '   INNER JOIN (          ' +char(10)
            SELECT @v_dSql3 += '         SELECT * FROM ( ' +char(10)
   
  		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
			IF  @p_cate_info = 'X' --나중에 확인필요( 원본은 [ IF LEN(@p_cate_info)  > 0 ] 인데 스킵하기위해 X 값을 넣음)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
                            SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_delimiter, @mst_loop_cnt)
                    
                            IF( @v_cate_info = 'chk_memo' AND @v_cate_value = 'TRUE' )  
                                SELECT @bMemo = 'Y'
                            IF( @v_cate_info = 'chk_inqty' AND @v_cate_value = 'TRUE' )  
                                SELECT @bDppIn = 'Y'
                            IF( @v_cate_info = 'chk_outqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bDppOut = 'Y'
                            IF( @v_cate_info = 'chk_result' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bResult =  'Y'
                            IF( @v_cate_info = 'chk_wpp_inqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bWppIn =  'Y'
                            IF( @v_cate_info = 'chk_wpp_outqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bWppOut =  'Y'
                            IF( @v_cate_info = 'chk_mpp_inqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bMppIn =  'Y'
                            IF( @v_cate_info = 'chk_mpp_outqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bMppOut =  'Y'
                            IF( @v_cate_info = 'chk_cell' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bCell =  'Y'
                            IF( @v_cate_info = 'chk_uom' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bUom =  'Y'
                            IF( @v_cate_info = 'chk_total' AND @v_cate_value = 'TRUE' ) 
                                SELECT  @bTotal = 'Y'
                            IF( @v_cate_info = 'chk_total_2' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bTotal2 = 'Y'
                            IF( @v_cate_info = 'chk_engine_inqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bEngIn = 'Y'
                            IF( @v_cate_info = 'chk_engine_outqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bEngOut = 'Y'
                         END                
  
                    SELECT @v_pSql = 'SELECT -9999 AS CATE_ORDER, ''X'' AS CATE_NAME, ''X'' AS CATE_ID, '''' AS MEASURE_ID, '''' AS MEASURE_NAME ' +char(10)
                    
                    IF( @bMppIn = 'Y' AND @bCell = 'Y' ) 
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL ' +char(10)
                            SELECT @v_pSql += 'SELECT 20 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bMppIn = 'Y' AND @bUom = 'Y' ) 
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 25 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME ' +char(10)
                        END
                    IF( @bMppOut = 'Y' AND @bCell = 'Y' ) 
                        BEGIN
                            SELECT @v_tmp1 += 'UNION ALL  ' +char(10)
                            SELECT @v_tmp1 += 'SELECT 30 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME ' +char(10)
                        END
                    IF( @bMppOut = 'Y' AND @bUom = 'Y' ) 
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 35 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bWppIn = 'Y' AND @bCell = 'Y' ) 
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 40 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bWppIn = 'Y' AND @bUom = 'Y' )
                        BEGIN 
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 45 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bWppOut = 'Y' AND @bCell = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 50 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bWppOut = 'Y' AND @bUom = 'Y' )
					    BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 55 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bDppIn = 'Y' AND @bCell = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 60 AS CATE_ORDER, ''In'' AS CATE_NAME, ''P_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bDppIn = 'Y' AND @bUom = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 65 AS CATE_ORDER, ''In'' AS CATE_NAME, ''P_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bDppOut = 'Y' AND @bCell = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 70 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END   
                    IF( @bDppOut = 'Y' AND @bUom = 'Y' )
                        BEGIN 
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 75 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bResult = 'Y' AND @bCell = 'Y' ) 
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 80 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bResult = 'Y' AND @bUom = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 85 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bEngIn = 'Y' AND @bCell = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 57 AS CATE_ORDER, ''Engine(In)'' AS CATE_NAME, ''P_IN_ENGINE_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bEngIn = 'Y' AND @bUom = 'Y' )
                        BEGIN 
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 58 AS CATE_ORDER, ''Engine(In)'' AS CATE_NAME, ''P_IN_ENGINE'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bEngOut = 'Y' AND @bCell = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 67 AS CATE_ORDER, ''Engine(Out)'' AS CATE_NAME, ''P_OUT_ENGINE_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bEngOut = 'Y' AND @bUom = 'Y' )
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 68 AS CATE_ORDER, ''Engine(Out)'' AS CATE_NAME, ''P_OUT_ENGINE'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                        END
                    IF( @bMemo = 'Y')
                        BEGIN
                            SELECT @v_pSql += 'UNION ALL  ' +char(10)
                            SELECT @v_pSql += 'SELECT 69 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID, '''' AS MEASURE_ID, '''' AS MEASURE_NAME  ' +char(10)
                        END
                END  
            ELSE
			    BEGIN
		            SELECT @v_pSql = ''
                    SELECT @v_pSql  = ' SELECT 20 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 25 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 30 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 35 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 40 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 45 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 50 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 55 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME  ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 60 AS CATE_ORDER, ''In'' AS CATE_NAME, ''P_IN_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 65 AS CATE_ORDER, ''In'' AS CATE_NAME, ''P_IN'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 70 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 75 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 80 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME  ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 85 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL  ' +char(10) 
                    SELECT @v_pSql += ' SELECT 57 AS CATE_ORDER, ''Engine(In)'' AS CATE_NAME, ''P_IN_ENGINE_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 58 AS CATE_ORDER, ''Engine(In)'' AS CATE_NAME, ''P_IN_ENGINE'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 67 AS CATE_ORDER, ''Engine(Out)'' AS CATE_NAME, ''P_OUT_ENGINE_CELL'' AS CATE_ID, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += ' UNION ALL ' +char(10) 
                    SELECT @v_pSql += ' SELECT 68 AS CATE_ORDER, ''Engine(Out)'' AS CATE_NAME, ''P_OUT_ENGINE'' AS CATE_ID, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME   ' +char(10)
                    SELECT @v_pSql += 'UNION ALL  ' +char(10)
                    SELECT @v_pSql += 'SELECT 69 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID, '''' AS MEASURE_ID, '''' AS MEASURE_NAME  ' +char(10)
			    END

            SELECT @v_dSql3 = @v_dSql3 + @v_pSql

            SELECT @v_dSql3 += '        ) A                    ' +char(10)
            SELECT @v_dSql3 += '        WHERE CATE_ID <> ''X'' ' +char(10)
            SELECT @v_dSql3 += '   ) D                         ' +char(10)
            SELECT @v_dSql3 += '   ON     1=1                  ' +char(10)
            SELECT @v_dSql3 += '   LEFT OUTER JOIN (           ' +char(10)
            SELECT @v_dSql3 += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' +char(10)
            SELECT @v_dSql3 += '         , A.FACTORY_ID, A.OPERATION_ID, A.LOCATION, A.ITEM_ID    ' +char(10)
            SELECT @v_dSql3 += '         , A.TOP_ITEM_ID, SUM(ISNULL(A.MODIFY_QTY, A.QTY)) AS QTY ' +char(10)
            SELECT @v_dSql3 += '      FROM   '+ @p_amend_cutoff_boh_table +' A WITH(NOLOCK)       ' +char(10)
            SELECT @v_dSql3 += '      WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''              ' +char(10)
            SELECT @v_dSql3 += '      AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                ' +char(10)
            SELECT @v_dSql3 += '      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID             ' +char(10)
            SELECT @v_dSql3 += '          , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID              ' +char(10)
            SELECT @v_dSql3 += '          , A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                  ' +char(10)
            SELECT @v_dSql3 += '   ) F                                       ' +char(10)
            SELECT @v_dSql3 += '   ON  A.COMPANY_ID   = F.COMPANY_ID         ' +char(10)
            SELECT @v_dSql3 += '   AND A.DIVISION_ID  = F.DIVISION_ID        ' +char(10)
            SELECT @v_dSql3 += '   AND A.SITE_ID      = F.SITE_ID            ' +char(10)
            SELECT @v_dSql3 += '   AND A.PLANT_ID     = F.PLANT_ID           ' +char(10)
            SELECT @v_dSql3 += '   AND A.FACTORY_ID   = F.FACTORY_ID         ' +char(10)
            SELECT @v_dSql3 += '   AND A.OPERATION_ID = F.OPERATION_ID       ' +char(10)
            SELECT @v_dSql3 += '   AND A.LOCATION     = F.LOCATION           ' +char(10)
            SELECT @v_dSql3 += '   AND A.ITEM_ID      = F.ITEM_ID            ' +char(10)
            SELECT @v_dSql3 += '   AND A.TOP_ITEM_ID  = F.TOP_ITEM_ID        ' +char(10)
            SELECT @v_dSql3 += '   INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK) ' +char(10)
            SELECT @v_dSql3 += '   ON  A.PLAN_DATE    = G.DT                 ' +char(10)
            SELECT @v_dSql3 += ' WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' +char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
            
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @p_item_id))            + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'EQ', @p_nick_name))        + char(10)
            SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))  + char(10)
		    
            SELECT @v_dSql3 += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID ' +char(10)
            SELECT @v_dSql3 += '        , A.ITEM_TYPE, A.NICK_NAME, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION           ' +char(10)
            SELECT @v_dSql3 += '        , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE        ' +char(10)
            SELECT @v_dSql3 += '        , D.CATE_NAME, D.CATE_ORDER, D.CATE_ID, D.MEASURE_ID, D.MEASURE_NAME           ' +char(10)
            SELECT @v_dSql3 += 'option (maxdop 1)' +char(10)
			--SELECT @v_dSql3 += ' ) ' +char(10)

		    SELECT @v_dSql4 = ''
		    SELECT @v_dSql4 = '----------------------------------------------v_dSql4-------------------------------------' +char(10)
            --SELECT @v_dSql4 += ' , MAIN_P_SUBT AS ( ' +char(10)
            
			
			if object_id('tempdb..#MAIN_P_SUBT') is not null
				drop table #MAIN_P_SUBT

			
			SELECT @v_dSql4 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' +char(10)
            SELECT @v_dSql4 += '         , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME           ' +char(10)
            SELECT @v_dSql4 += '         , A.OPERATION_ID, ''Total'' AS FACTORY_ID, convert(nvarchar(50), NULL) AS [LOCATION]    ' +char(10)
            SELECT @v_dSql4 += '         , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY, convert(nvarchar(30), NULL) AS PRODUCTION_TYPE ' +char(10)
            SELECT @v_dSql4 += '         , convert(nvarchar(30), NULL) AS MARKET, A.PSI, convert(nvarchar(30), NULL) AS LINE_ID, convert(nvarchar(150), NULL) AS LINE_NAME    ' +char(10)
            SELECT @v_dSql4 += '         , convert(nvarchar(50), NULL) AS ELECTRODE_TYPE, A.CATE                               ' +char(10)
		    
            SELECT @v_tmp1 =''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
               
            IF (LEN(@p_day_info) > 0 )
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '         , SUM(M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END
					  
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                
                          SELECT @v_tmp1 += '         , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END  
                        
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)              
                          SELECT @v_tmp1 += '         , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END                                  
              END
		    
            SELECT @v_dSql4 = @v_dSql4 + @v_tmp1
		    
            SELECT @v_dSql4 += '         , A.CATEGORY_ID                                          ' +char(10)
            SELECT @v_dSql4 += '         , (CASE WHEN A.CATEGORY_ID = ''M_IN_CELL'' THEN 600      ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''M_IN'' THEN 610              ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''M_OUT_CELL'' THEN 620        ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''M_OUT'' THEN 630             ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''W_IN_CELL'' THEN 640         ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''W_IN'' THEN 650              ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''W_OUT_CELL'' THEN 660        ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''W_OUT'' THEN 670             ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_IN_ENGINE_CELL'' THEN 675  ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_IN_ENGINE'' THEN 677       ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_IN_CELL'' THEN 680         ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_IN'' THEN 690              ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_OUT_ENGINE_CELL'' THEN 695 ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_OUT_ENGINE'' THEN 697      ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_OUT_CELL'' THEN 700        ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_OUT'' THEN 710             ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_RESULT_CELL'' THEN 720     ' +char(10)
            SELECT @v_dSql4 += '              WHEN A.CATEGORY_ID = ''P_RESULT'' THEN 730          ' +char(10)
            SELECT @v_dSql4 += '              ELSE 999 END) AS CATEGORY_ORDER                     ' +char(10)
            SELECT @v_dSql4 += '         , A.MEASURE_ID, A.MEASURE_NAME ' +char(10)
            SELECT @v_dSql4 += '         , ''TOTAL'' AS DATA_TYPE       ' +char(10)
            SELECT @v_dSql4 += '         , NULL AS S_ROW                ' +char(10)
            SELECT @v_dSql4 += '     INTO #MAIN_P_SUBT                           ' +char(10)

			SELECT @v_dSql4 += '     FROM (                             ' +char(10)
            SELECT @v_dSql4 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID              ' +char(10)
            SELECT @v_dSql4 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME                 ' +char(10)
            SELECT @v_dSql4 += '            , A.OPERATION_ID, ''Total'' AS FACTORY_ID, NULL AS LOCATION          ' +char(10)
            SELECT @v_dSql4 += '            , A.BOH_QTY, NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI          ' +char(10)
            SELECT @v_dSql4 += '            , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE ' +char(10)
            
		    SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_day_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '            , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END
                      
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                
                          SELECT @v_tmp1 += '            , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + ') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END  
                        
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                     
                          SELECT @v_tmp1 += '            , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END                                  
              END
		    
		    SELECT @v_dSql4 = @v_dSql4 + @v_tmp1
		    
            SELECT @v_dSql4 += '            , A.CATEGORY_ID ' +char(10)
            SELECT @v_dSql4 += '            , (CASE WHEN A.CATEGORY_ID=''P_IN'' THEN 600 WHEN A.CATEGORY_ID=''P_OUT'' THEN 700 ELSE 800 END) AS CATEGORY_ORDER ' +char(10)
            SELECT @v_dSql4 += '            , A.MEASURE_ID, A.MEASURE_NAME, ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW ' +char(10)
            SELECT @v_dSql4 += '            , ROW_NUMBER( ) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE ' +char(10)
            SELECT @v_dSql4 += '                ORDER BY     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE ) AS BOH_ROWNUM ' +char(10)
            SELECT @v_dSql4 += '          FROM #MAIN_P A                                               ' +char(10)
            SELECT @v_dSql4 += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' +char(10)
            SELECT @v_dSql4 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME      ' +char(10)
            SELECT @v_dSql4 += '            , A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE            ' +char(10)
            SELECT @v_dSql4 += '            , A.MEASURE_ID, A.MEASURE_NAME, A.BOH_QTY                 ' +char(10)
            SELECT @v_dSql4 += '      ) A                                                             ' +char(10)
            SELECT @v_dSql4 += '      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID ' +char(10)
            SELECT @v_dSql4 += '       , A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.OPERATION_ID, A.CATEGORY_ID      ' +char(10)
            SELECT @v_dSql4 += '       , A.PSI, A.CATE, A.MEASURE_ID, A.MEASURE_NAME                             ' +char(10)
            --SELECT @v_dSql4 += ' )             ' +char(10)
            
			
			if object_id('tempdb..#T_MEMO') is not null
				drop table #T_MEMO
			
			
			
			--SELECT @v_dSql4 += ' , T_MEMO AS ( ' +char(10)
            SELECT @v_dSql4 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
            SELECT @v_dSql4 += '              , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID    ' +char(10)
            SELECT @v_dSql4 += '              , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET          ' +char(10)
            
		    SELECT @v_tmp1 = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
            
		    WHILE @mst_loop_cnt < @max_loop_cnt      
              BEGIN                                
                  SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                  SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                  
                  SELECT @v_tmp1 += '              , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @v_day_info + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO ' +char(10)  
              END  
		    
	        SELECT @v_dSql4  = @v_dSql4 +  @v_tmp1
		    
            SELECT @v_dSql4 += '       INTO #T_MEMO              ' +char(10)
			SELECT @v_dSql4 += '       FROM FP_AMEND_MEMO_M A WITH(NOLOCK)              ' +char(10)
            SELECT @v_dSql4 += '       WHERE 1=1                                        ' +char(10)
            SELECT @v_dSql4 += '       AND    A.INSTANCE_ID  = '''+ @p_instance_id +''' ' +char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
            
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @p_item_id))            + char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_nick_name))      + char(10)
            SELECT @v_dSql4 += '       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))  + char(10)
            SELECT @v_dSql4 += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
            SELECT @v_dSql4 += '              , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID      ' +char(10)
            SELECT @v_dSql4 += '              , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET            ' +char(10)
            --SELECT @v_dSql4 += '   )          ' +char(10)
            
			
			
			
			
			
			SELECT @v_dSql4 += '   SELECT A.* ' +char(10)
            SELECT @v_dSql4 += '     , DENSE_RANK() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID               ' +char(10)
            SELECT @v_dSql4 += '         ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID) AS LV1 ' +char(10)
          
		    SELECT @v_tmp1 = ''
		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
            
		    WHILE @mst_loop_cnt < @max_loop_cnt      
              BEGIN                                
                  SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                  SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                     
                  SELECT @v_tmp1 += '    , C.D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO ' +char(10)  
              END 
		    
		    SELECT @v_dSql4  = @v_dSql4  + @v_tmp1
		    
            SELECT @v_dSql4 += '     , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ' +char(10)
            SELECT @v_dSql4 += '            WHEN D.PRODUCTION_TYPE IS NULL       ' +char(10)
            --SELECT @v_dSql4 += '            OR (A.OPERATION_ID IN (''A3000'',''A9000'') AND H.MARKET IS NULL) ' +char(10) -- target 제약 해제... 20231116
            SELECT @v_dSql4 += '            OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'') THEN ''N'' ELSE ''Y'' END AS EDIT_YN ' +char(10)
            SELECT @v_dSql4 += '   FROM (                   ' +char(10)
            SELECT @v_dSql4 += '        SELECT * FROM #MAIN_S ' +char(10)
            SELECT @v_dSql4 += '        UNION ALL            ' +char(10)
            SELECT @v_dSql4 += '        SELECT * FROM #MAIN_P ' +char(10)
            SELECT @v_dSql4 += '        UNION ALL            ' +char(10)
            SELECT @v_dSql4 += '        SELECT * FROM #MAIN_I ' +char(10)
            SELECT @v_dSql4 += '        UNION ALL            ' +char(10)
            SELECT @v_dSql4 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' +char(10)
            SELECT @v_dSql4 += '          , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME           ' +char(10)
            SELECT @v_dSql4 += '          , A.OPERATION_ID, ''Total'' AS FACTORY_ID, NULL AS LOCATION    ' +char(10)
            SELECT @v_dSql4 += '          , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY, NULL AS PRODUCTION_TYPE ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS MARKET, A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME    ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS ELECTRODE_TYPE, A.CATE                               ' +char(10)
             
		    SELECT @v_tmp1 = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_day_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '          , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END
                      
                  SET @max_loop_cnt = 0
                  SET @mst_loop_cnt = 0
                  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                     
                          SELECT @v_tmp1 += '          , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END  
                        
                  SET @max_loop_cnt = 0
                  SET @mst_loop_cnt = 0
                  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                   
                          SELECT @v_tmp1 += '          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END                                  
              END  
			  
            SELECT @v_dSql4  = @v_dSql4  + @v_tmp1

            SELECT @v_dSql4 += '          , ''S'' AS CATEGORY_ID, (CASE WHEN A.CATEGORY_ID = ''S'' THEN 400 ELSE 410 END) AS CATEGORY_ORDER ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS MEASURE_ID, NULL AS MEASURE_NAME, ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW                 ' +char(10)
            SELECT @v_dSql4 += '        FROM #MAIN_S A ' +char(10)
          
		    SELECT @v_tmp1 = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_cate_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
                          SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_type     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_type ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value,@v_delimiter, @mst_loop_cnt)
 
						  IF ( @v_cate_type = 'CATEGORY' AND @v_cate_info = 'chk_total' ) 
						      BEGIN
                                  IF (@v_cate_value = 'FALSE')
							          BEGIN
                                          SELECT @v_tmp1 = '        WHERE 1=0 ' + char(10)
								      END
                              END

                      END
              END            
          
		    SELECT @v_dSql4 = @v_dSql4  + @v_tmp1

            SELECT @v_dSql4 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql4 += '          , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME      ' + char(10)
            SELECT @v_dSql4 += '          , A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID            ' + char(10)
            SELECT @v_dSql4 += '        UNION ALL                                                   ' + char(10)
            SELECT @v_dSql4 += '        SELECT * FROM #MAIN_P_SUBT                                   ' + char(10)
          
		    SELECT @v_tmp1 = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_cate_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
                          SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_type     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_type ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value,@v_delimiter, @mst_loop_cnt)
						  
						  IF ( @v_cate_type = 'CATEGORY' AND @v_cate_info = 'chk_total' ) 
						      BEGIN
                                  IF (@v_cate_value = 'FALSE')
							          BEGIN
                                          SELECT @v_tmp1 = '        WHERE 1=0 ' + char(10)
								      END
                              END

                      END
              END  
			  
            SELECT @v_dSql4 = @v_dSql4  + @v_tmp1

            SELECT @v_dSql4 += '        UNION ALL ' + char(10)
            SELECT @v_dSql4 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
            SELECT @v_dSql4 += '          , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME        ' + char(10)
            SELECT @v_dSql4 += '          , A.OPERATION_ID, ''Total'' AS FACTORY_ID, NULL AS LOCATION ' + char(10)
            SELECT @v_dSql4 += '          , SUM(A.BOH_QTY) AS  BOH_QTY, NULL AS PRODUCTION_TYPE       ' + char(10)
            SELECT @v_dSql4 += '          , NULL AS MARKET, A.PSI, NULL AS LINE_ID                    ' + char(10)
            SELECT @v_dSql4 += '          , NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE         ' + char(10)
               
		    SELECT @v_tmp1 = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_day_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '          , NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END
                      
                  SET @max_loop_cnt = 0
                  SET @mst_loop_cnt = 0
                  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                
                          SELECT @v_tmp1 += '          , NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END  
                        
                  SET @max_loop_cnt = 0
                  SET @mst_loop_cnt = 0
                  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)               
                          SELECT @v_tmp1 += '          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END                                  
              END   
			  
            SELECT @v_dSql4 = @v_dSql4  + @v_tmp1

            SELECT @v_dSql4 += '          , ''I'' AS CATEGORY_ID, 900 AS CATEGORY_ORDER ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS MEASURE_ID, NULL AS MEASURE_NAME    ' +char(10)
            SELECT @v_dSql4 += '          , ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW       ' +char(10)
            SELECT @v_dSql4 += '        FROM #MAIN_I A                                   ' +char(10)
          
		    SELECT @v_tmp1 = ''
		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_cate_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
                          SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_type     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_type ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_delimiter, @mst_loop_cnt)
						  IF ( @v_cate_type = 'CATEGORY' AND @v_cate_info = 'chk_total' ) 
						      BEGIN
                                  IF (@v_cate_value = 'FALSE')
							          BEGIN
                                          SELECT @v_tmp1 = '        WHERE 1=0 ' + char(10)
								      END
                              END

                      END
              END 
			  
            SELECT @v_dSql4 = @v_dSql4  + @v_tmp1
		  
		    SELECT @v_dSql4 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' +char(10)
            SELECT @v_dSql4 += '          , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME      ' +char(10)
            SELECT @v_dSql4 += '          , A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE            ' +char(10)
            SELECT @v_dSql4 += '        UNION ALL                                                   ' +char(10)
            SELECT @v_dSql4 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID ' +char(10)
            SELECT @v_dSql4 += '          , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE                  ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS NICK_NAME, A.OPERATION_ID AS OPERATION_ID, NULL AS FACTORY_ID         ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS LOCATION, ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY                         ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI, NULL AS LINE_ID               ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE                             ' +char(10)

            SELECT @v_tmp1 = ''     
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_day_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '          , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END
                      
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)             
                          SELECT @v_tmp1 += '          , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END  
                        
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                
                          SELECT @v_tmp1 += '          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END                                  
              END                
			  
            SELECT @v_dSql4 = @v_dSql4  + @v_tmp1

            SELECT @v_dSql4 += '          , A.CATEGORY_ID                                                             ' +char(10)
            SELECT @v_dSql4 += '          , (CASE WHEN A.CATEGORY_ID = ''S'' THEN 800 ELSE 810 END) AS CATEGORY_ORDER ' +char(10)
            SELECT @v_dSql4 += '          , NULL AS MEASURE_ID, NULL AS MEASURE_NAME ' +char(10)
            SELECT @v_dSql4 += '          , ''TOTAL_2'' AS DATA_TYPE, NULL AS S_ROW  ' +char(10)
            SELECT @v_dSql4 += '        FROM   #MAIN_S A                              ' +char(10)
          
            SELECT @v_tmp1 = ''
		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_cate_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
                          SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_type     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_type ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value,@v_delimiter, @mst_loop_cnt)
                          IF(@v_cate_type = 'CATEGORY' AND @v_cate_info = 'chk_total') 
						      BEGIN
                                  IF (@v_cate_value = 'FALSE')
							          BEGIN
                                          SELECT @v_tmp1 = '        WHERE 1=0 ' + char(10)
								      END
                              END
                      END
              END 
			  
            SELECT @v_dSql4 = @v_dSql4  + @v_tmp1

            SELECT @v_dSql4 += '        GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID ' +char(10)
		 
		    SELECT @v_dSql5 = ''
		    SELECT @v_dSql5 = '-------------------------------------------v_dSql5----------------------------------------' +char(10)
            SELECT @v_dSql5 += '        UNION ALL                                             ' +char(10)
            SELECT @v_dSql5 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID   ' +char(10)
            SELECT @v_dSql5 += '          , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME ' +char(10)
            SELECT @v_dSql5 += '          , A.OPERATION_ID AS OPERATION_ID, NULL AS FACTORY_ID, NULL AS LOCATION            ' +char(10)
            SELECT @v_dSql5 += '          , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY, NULL AS PRODUCTION_TYPE, NULL AS MARKET    ' +char(10)
            SELECT @v_dSql5 += '          , A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE       ' +char(10)
               
            SELECT @v_tmp1 = ''
		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_day_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '          , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END
                      
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                  
                          SELECT @v_tmp1 += '          , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END  
                        
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                    
                          SELECT @v_tmp1 += '          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END                                  
              END    
			  
            SELECT @v_dSql5 = @v_dSql5  + @v_tmp1
            SELECT @v_dSql5 += '          , A.CATEGORY_ID ' +char(10)
            SELECT @v_dSql5 += '          , (CASE WHEN A.CATEGORY_ID = ''M_IN_CELL'' THEN 2000     ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''M_IN'' THEN 2100              ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''M_OUT_CELL'' THEN 2200        ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''M_OUT'' THEN 2300             ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''W_IN_CELL'' THEN 2400         ' +char(10) 
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''W_IN'' THEN 2500              ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''W_OUT_CELL'' THEN 2600        ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''W_OUT'' THEN 2700             ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_IN_ENGINE_CELL'' THEN 2780  ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_IN_ENGINE'' THEN 2790       ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_IN_CELL'' THEN 2800         ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_IN'' THEN 2900              ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_OUT_ENGINE_CELL'' THEN 2980 ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_OUT_ENGINE'' THEN 2990      ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_OUT_CELL'' THEN 3000        ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_OUT'' THEN 3100             ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_RESULT_CELL'' THEN 3200     ' +char(10)
            SELECT @v_dSql5 += '              WHEN A.CATEGORY_ID = ''P_RESULT'' THEN 3300          ' +char(10)
            SELECT @v_dSql5 += '              ELSE 4000 END) AS CATEGORY_ORDER                     ' +char(10)
            SELECT @v_dSql5 += '          , A.MEASURE_ID, A.MEASURE_NAME                           ' +char(10)
            SELECT @v_dSql5 += '          , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW                ' +char(10)
            SELECT @v_dSql5 += '        FROM #MAIN_P_SUBT A                                         ' +char(10)
          
		    SELECT @v_tmp1       = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_cate_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
					      SELECT @mst_loop_cnt    = @mst_loop_cnt +1
                          SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_type     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_type ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_delimiter, @mst_loop_cnt)
                          IF(@v_cate_type = 'CATEGORY' AND @v_cate_info = 'chk_total') 
						      BEGIN
                                  IF (@v_cate_value = 'FALSE')
							          BEGIN
                                          SELECT @v_tmp1 = '        WHERE 1=0 ' + char(10)
								      END
                              END
                      END
              END 

            SELECT @v_dSql5 = @v_dSql5 + @v_tmp1

            SELECT @v_dSql5 += '        GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID, A.MEASURE_ID, A.MEASURE_NAME ' + char(10)
		    SELECT @v_dSql5 += '        UNION ALL                                                                           ' + char(10)
            SELECT @v_dSql5 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID   ' + char(10)
            SELECT @v_dSql5 += '          , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME ' + char(10)
            SELECT @v_dSql5 += '          , A.OPERATION_ID AS OPERATION_ID, NULL AS FACTORY_ID, NULL AS LOCATION            ' + char(10)
            SELECT @v_dSql5 += '          , SUM(A.BOH_QTY) AS  BOH_QTY, NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI      ' + char(10)
            SELECT @v_dSql5 += '          , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE              ' + char(10)
               
            SELECT @v_tmp1 = ''
		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_day_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '          , NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END
                      
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                
                          SELECT @v_tmp1 += '          , NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
                      END  
                        
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단                           
                  
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_tmp1 += '          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                      END                                  
              END 
			  
            SELECT @v_dSql5 = @v_dSql5 + @v_tmp1

            SELECT @v_dSql5 += '          , A.CATEGORY_ID, 5000 AS CATEGORY_ORDER    ' +char(10)
            SELECT @v_dSql5 += '          , NULL AS MEASURE_ID, NULL AS MEASURE_NAME ' +char(10)
            SELECT @v_dSql5 += '          , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW  ' +char(10)
            SELECT @v_dSql5 += '        FROM   #MAIN_I A                              ' +char(10)
          
            SELECT @v_tmp1 = ''
		    SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_cate_info) > 0)
              BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
					      SELECT @mst_loop_cnt    = @mst_loop_cnt +1
                          SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_type     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_type ,@v_delimiter, @mst_loop_cnt)
                          SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_delimiter, @mst_loop_cnt)
                          
						  IF(@v_cate_type = 'CATEGORY' AND @v_cate_info = 'chk_total') 
						      BEGIN
                                  IF (@v_cate_value = 'FALSE')
							          BEGIN
                                          SELECT @v_tmp1 = '        WHERE 1=0 ' + char(10)
								      END
                              END
                      END
              END
		  
            SELECT @v_dSql5 = @v_dSql5 + @v_tmp1

            SELECT @v_dSql5 += '        GROUP BY A.OPERATION_ID, A.PSI, A.CATE, A.CATEGORY_ID ' + char(10)
            SELECT @v_dSql5 += '     ) A                                        ' + char(10)
            SELECT @v_dSql5 += '     LEFT OUTER JOIN #T_MEMO C WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql5 += '      ON  A.COMPANY_ID      = C.COMPANY_ID      ' + char(10)
            SELECT @v_dSql5 += '      AND A.DIVISION_ID     = C.DIVISION_ID     ' + char(10)
            SELECT @v_dSql5 += '      AND A.SITE_ID         = C.SITE_ID         ' + char(10)
            SELECT @v_dSql5 += '      AND A.PLANT_ID        = C.PLANT_ID        ' + char(10)
            SELECT @v_dSql5 += '      AND A.FACTORY_ID      = C.FACTORY_ID      ' + char(10)
            SELECT @v_dSql5 += '      AND A.OPERATION_ID    = C.OPERATION_ID    ' + char(10)
            SELECT @v_dSql5 += '      AND A.LINE_ID         = C.LINE_ID         ' + char(10)
            SELECT @v_dSql5 += '      AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE  ' + char(10)
            SELECT @v_dSql5 += '      AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql5 += '      AND A.MARKET          = C.MARKET          ' + char(10)
            SELECT @v_dSql5 += '      AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID     ' + char(10)
            SELECT @v_dSql5 += '      AND A.ITEM_ID         = C.ITEM_ID         ' + char(10)
            SELECT @v_dSql5 += '     LEFT OUTER JOIN                            ' + char(10)
            SELECT @v_dSql5 += '     (                                          ' + char(10)
            SELECT @v_dSql5 += '       SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql5 += '       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
            SELECT @v_dSql5 += '       WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
            SELECT @v_dSql5 += '       AND    A.ACTIVE_FLAG = ''Y''                         ' + char(10)
            SELECT @v_dSql5 += '     ) D                                       ' + char(10)
            SELECT @v_dSql5 += '     ON A.DIVISION_ID = D.DIVISION_ID          ' + char(10)
            SELECT @v_dSql5 += '     AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql5 += '     AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE ' + char(10)
/*
-- target 제약 해제... 20231116
    	    SELECT @v_dSql5 += '     LEFT OUTER JOIN (        ' + char(10)
            SELECT @v_dSql5 += '         SELECT DISTINCT H.*  ' + char(10)
            SELECT @v_dSql5 += '         FROM (               ' + char(10)
            SELECT @v_dSql5 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MARKET, A.ITEM_ID, (CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST'' ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql5 += '                FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql5 += '                WHERE  1=1                                       ' + char(10) 
            SELECT @v_dSql5 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql5 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql5 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)    
            SELECT @v_dSql5 += '                AND EXISTS  (          ' + char(10) 
            SELECT @v_dSql5 += '                         SELECT 1 ' + char(10) 
            SELECT @v_dSql5 += '                         FROM (   ' + char(10) 
            SELECT @v_dSql5 += '                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SHOP_GROUP_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID  ' + char(10) 
            SELECT @v_dSql5 += '                                FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK) ' + char(10) 
            SELECT @v_dSql5 += '                                WHERE 1=1                                      ' + char(10)                   
            SELECT @v_dSql5 += '                                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
            SELECT @v_dSql5 += '                                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
            SELECT @v_dSql5 += '                                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))      + char(10)                             
            SELECT @v_dSql5 += '                                 GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SHOP_GROUP_ID                ' + char(10)
            SELECT @v_dSql5 += '                               ) AA ' + char(10)
            SELECT @v_dSql5 += '                          WHERE 1=1 ' + char(10)
            SELECT @v_dSql5 += '                          AND A.COMPANY_ID = AA.COMPANY_ID       ' + char(10)
            SELECT @v_dSql5 += '                          AND A.DIVISION_ID = AA.DIVISION_ID     ' + char(10)
            SELECT @v_dSql5 += '                          AND A.SITE_ID = AA.SITE_ID             ' + char(10)
            SELECT @v_dSql5 += '                          AND A.SHOP_GROUP_ID = AA.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql5 += '                        ) ' + char(10)
            SELECT @v_dSql5 += '            UNION         ' + char(10)
            SELECT @v_dSql5 += '            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID, A.PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql5 += '            FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql5 += '            WHERE  1=1    ' + char(10)
            SELECT @v_dSql5 += '            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
            SELECT @v_dSql5 += '            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
            SELECT @v_dSql5 += '            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)       
            SELECT @v_dSql5 += '            AND  A.DUE_DATE >= ( SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) ' + char(10)
            SELECT @v_dSql5 += '                             FROM   SCM_FP_PLAN_H                     ' + char(10)
            SELECT @v_dSql5 += '                             WHERE  PLAN_ID =  '''+ @p_plan_id +''' ) ' + char(10)
            SELECT @v_dSql5 += '        ) H    ' + char(10)
            SELECT @v_dSql5 += '    ) H        ' + char(10)
            SELECT @v_dSql5 += '    ON  A.COMPANY_ID  = H.COMPANY_ID          ' + char(10)
            SELECT @v_dSql5 += '    AND A.DIVISION_ID = H.DIVISION_ID         ' + char(10)
            SELECT @v_dSql5 += '    AND A.SITE_ID     = H.SITE_ID             ' + char(10)
            SELECT @v_dSql5 += '    AND A.PLANT_ID    = H.PLANT_ID            ' + char(10)
            SELECT @v_dSql5 += '    AND A.MARKET      = H.MARKET              ' + char(10)
            SELECT @v_dSql5 += '    AND A.TOP_ITEM_ID = H.ITEM_ID             ' + char(10)
            SELECT @v_dSql5 += '    AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE ' + char(10)
*/
            SELECT @v_dSql5 += '    LEFT OUTER JOIN (                         ' + char(10)
            SELECT @v_dSql5 += '            SELECT DISTINCT R.INSTANCE_ID, R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
            SELECT @v_dSql5 += '            FROM  FP_USER_ROLE_INFO_V R WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql5 += '            WHERE 1=1                                    ' + char(10)
            SELECT @v_dSql5 += '            AND   R.USER_ID	    = '''+ @p_user_id +'''   ' + char(10)
            SELECT @v_dSql5 += '            AND   R.SAVE_FLAG	  = ''Y''                ' + char(10)
            SELECT @v_dSql5 += '            AND   R.INSTANCE_ID = '''+ @p_master_id +''' ' + char(10)
            SELECT @v_dSql5 += '    ) R                                  ' + char(10)
            SELECT @v_dSql5 += '   ON  1=1                               ' + char(10)
            SELECT @v_dSql5 += '   AND   A.COMPANY_ID = R.COMPANY_ID     ' + char(10)
            SELECT @v_dSql5 += '   AND   A.DIVISION_ID = R.DIVISION_ID   ' + char(10)
            SELECT @v_dSql5 += '   AND   A.SITE_ID = R.SITE_ID           ' + char(10)
            SELECT @v_dSql5 += '   AND   A.PLANT_ID = R.PLANT_ID         ' + char(10)
            SELECT @v_dSql5 += '   AND   A.FACTORY_ID = R.FACTORY_ID     ' + char(10)
            SELECT @v_dSql5 += '   AND   A.OPERATION_ID = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql5 += '   AND   A.LINE_ID = R.LINE_ID           ' + char(10)
            SELECT @v_dSql5 += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID,A.OPERATION_ID DESC            ' + char(10)
            SELECT @v_dSql5 += '     ,A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE,(CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE 999 END) ' + char(10)
            SELECT @v_dSql5 += '     ,A.FACTORY_ID, A.LOCATION,(CASE WHEN CATEGORY_ID=''I'' THEN 999 ELSE 1 END)             ' + char(10)
            SELECT @v_dSql5 += '     ,A.PRODUCTION_TYPE, A.MARKET,(CASE WHEN CATEGORY_ID=''S'' THEN 1 ELSE 2 END)            ' + char(10)
            SELECT @v_dSql5 += '     ,A.LINE_ID, A.ELECTRODE_TYPE, CATEGORY_ORDER                                            ' + char(10)

		    SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3 + @v_dSql4 + @v_dSql5

		    IF @p_sys_type = 'SQL'
		  	  BEGIN
		  	  	  EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		  	  	  SELECT @v_dSql as [QUERY_VALUE]
		  	  
		  	  END  
		  ELSE 
		  	  BEGIN
		  	  	  SET @runstart = GetDate()
		  	  	  --쿼리실행
		  	  	  EXEC sp_executesql @v_dSql
		  	  	  
		  	  	  SET @runend = GetDate()
		  	  	  EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		  	  END
        END	--IF( END )
	/************************************************************************************************/
	/* SELECT인경우 :SELECT_TOTAL_VALUE                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_TOTAL_VALUE')
		BEGIN --IF(START)
		    SELECT @v_dSql1  = ''
            SELECT @v_dSql1  = ' WITH MAIN AS (                                                                            ' + char(10)
            SELECT @v_dSql1 += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                                         ' + char(10)
            SELECT @v_dSql1 += '        , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID                                         ' + char(10)
            SELECT @v_dSql1 += '        , A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                                             ' + char(10)
			SELECT @v_dSql1 += '        , ISNULL(A.MODIFY_QTY, A.QTY) AS QTY                                               ' + char(10)
            SELECT @v_dSql1 += '     FROM   '+ @p_amend_cutoff_boh_table +'  A WITH(NOLOCK)                                ' + char(10)
            SELECT @v_dSql1 += '     INNER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                  ' + char(10)
            SELECT @v_dSql1 += '     ON     A.COMPANY_ID   = B.COMPANY_ID                                                  ' + char(10)
            SELECT @v_dSql1 += '     AND    A.DIVISION_ID  = B.DIVISION_ID                                                 ' + char(10)
            SELECT @v_dSql1 += '     AND    A.SITE_ID      = B.SITE_ID                                                     ' + char(10)
            SELECT @v_dSql1 += '     AND    A.ITEM_ID      = B.ITEM_ID                                                     ' + char(10)
            SELECT @v_dSql1 += '     WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                                        ' + char(10)
            SELECT @v_dSql1 += '     AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                                          ' + char(10)
            SELECT @v_dSql1 += '     AND    EXISTS (                                                                       ' + char(10)
            SELECT @v_dSql1 += '         SELECT 1                                                                          ' + char(10)
            SELECT @v_dSql1 += '         FROM (                                                                            ' + char(10)
            SELECT @v_dSql1 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                               ' + char(10)
            SELECT @v_dSql1 += '                 , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID                                ' + char(10)
            SELECT @v_dSql1 += '                 , A.LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                                    ' + char(10)
            SELECT @v_dSql1 += '                 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                           ' + char(10)
            SELECT @v_dSql1 += '               FROM  '+ @p_amend_table +' A WITH(NOLOCK)                                   ' + char(10)
            SELECT @v_dSql1 += '               WHERE  A.INSTANCE_ID  = '''+ @p_master_id +'''                              ' + char(10)
            SELECT @v_dSql1 += '               AND  A.FP_PLAN_ID     = '''+ @p_plan_id +'''                                ' + char(10)
            SELECT @v_dSql1 += '               AND  CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @p_plan_date +'''             ' + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
			IF LEN(@p_top_item_id) > 0 
			    BEGIN
                    SELECT @v_dSql1 += '               AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''     ' + char(10)
				END																							                
            IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '               AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''             ' + char(10)
			    END																							                
            SELECT @v_dSql1 += '         ) AA                                                                               ' + char(10)
            SELECT @v_dSql1 += '         WHERE A.COMPANY_ID    = AA.COMPANY_ID                                              ' + char(10)
            SELECT @v_dSql1 += '         AND   A.DIVISION_ID   = AA.DIVISION_ID                                             ' + char(10)
            SELECT @v_dSql1 += '         AND   A.SITE_ID       = AA.SITE_ID                                                 ' + char(10)
            SELECT @v_dSql1 += '         AND   A.PLANT_ID      = AA.PLANT_ID                                                ' + char(10)
            SELECT @v_dSql1 += '         AND   A.FACTORY_ID    = AA.FACTORY_ID                                              ' + char(10)
            SELECT @v_dSql1 += '         AND   A.OPERATION_ID  = AA.OPERATION_ID                                            ' + char(10)
            SELECT @v_dSql1 += '         AND   A.LOCATION      = AA.LOCATION                                                ' + char(10)
            SELECT @v_dSql1 += '     	 AND   A.ITEM_ID       = AA.ITEM_ID                                                 ' + char(10)
            SELECT @v_dSql1 += '         AND   A.TOP_ITEM_ID   = AA.TOP_ITEM_ID                                             ' + char(10)
            SELECT @v_dSql1 += '         AND   AA.PLAN_DATE BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' + char(10)
            SELECT @v_dSql1 += '     )                                                                                      ' + char(10)
			IF LEN(@p_nick_name) > 0 
			    BEGIN
                    SELECT @v_dSql1 += '   AND B.NICK_NAME LIKE ''%''+ '''+ @p_nick_name +'''+''%''                          ' + char(10)
			    END																							                 
            SELECT @v_dSql1 += ' )                                                                                           ' + char(10)
			SELECT @v_dSql2 = ''																			                 
            SELECT @v_dSql2 += ' -- SUB TOTAL                                                                                ' + char(10)
            SELECT @v_dSql2 += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                                               ' + char(10)
            SELECT @v_dSql2 += '    , A.PLANT_ID, ''-'' AS FACTORY_ID, A.OPERATION_ID                                        ' + char(10)
            SELECT @v_dSql2 += '    , ''-'' AS LOCATION, A.ITEM_ID, A.TOP_ITEM_ID                                            ' + char(10)
            SELECT @v_dSql2 += '    , SUM(A.QTY) AS QTY, ''SUB_TOTAL'' AS _TYPE                                              ' + char(10)
            SELECT @v_dSql2 += ' FROM   MAIN A                                                                               ' + char(10)
            SELECT @v_dSql2 += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID                 ' + char(10)
			SELECT @v_dSql2 += '      , A.ITEM_ID, A.TOP_ITEM_ID                                                             ' + char(10)
            SELECT @v_dSql2 += ' UNION ALL                                                                                   ' + char(10)
            SELECT @v_dSql2 += ' --- TOTAL                                                                                   ' + char(10)
            SELECT @v_dSql2 += ' SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID                             ' + char(10)
            SELECT @v_dSql2 += '    , NULL AS PLANT_ID, NULL AS FACTORY_ID, B.OPERATION_ID AS OPERATION_ID                   ' + char(10)
            SELECT @v_dSql2 += '    , NULL AS LOCATION, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID                                 ' + char(10)
            SELECT @v_dSql2 += '    , SUM(CASE WHEN A.OPERATION_ID = B.OPERATION_ID THEN ISNULL(A.QTY,0) ELSE 0 END ) AS QTY ' + char(10)
            SELECT @v_dSql2 += '    , ''TOTAL'' AS _TYPE                                                                     ' + char(10)
            SELECT @v_dSql2 += ' FROM   MAIN A ,                                                                             ' + char(10)
            SELECT @v_dSql2 += ' (                                                                                           ' + char(10)
            SELECT @v_dSql2 += '     SELECT DISTINCT OPERATION_ID                                                            ' + char(10)
            SELECT @v_dSql2 += '     FROM SCM_OPERATION_M A WITH(NOLOCK)                                                     ' + char(10)
            SELECT @v_dSql2 += '     WHERE 1=1                                                                               ' + char(10)
            SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID', 'EQ', @p_operation_id))                 + char(10)
            SELECT @v_dSql2 += ' ) B                                                                                         ' + char(10)
            SELECT @v_dSql2 += ' GROUP BY B.OPERATION_ID                                                                     ' + char(10)

			SELECT @v_dSql = @v_dSql1 + @v_dSql2

			IF @p_sys_type = 'SQL'
				BEGIN
					EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )
	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,@v_delimiter,     @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,@v_delimiter,     @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,@v_delimiter,    @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,@v_delimiter,      @mst_loop_cnt)
                        , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,@v_delimiter,   @mst_loop_cnt)
                        , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,@v_delimiter,  @mst_loop_cnt)
                        , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,@v_delimiter,      @mst_loop_cnt)
                        , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,@v_delimiter,     @mst_loop_cnt)
                        , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter, @mst_loop_cnt)

					   
					   /****************************************************************************/
					   /* DELETE  경우  :     D(MAIN)                                                   */
					   /****************************************************************************/
					   IF(@v_sys_flag ='D')
						   BEGIN

						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
	
								SELECT @v_dSql1 = ''

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'
					   /******************************************************************************/
					   /* INSERT 경우 : INSERT(DETAIL)                                                 */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_SUB')  
							BEGIN
                                SELECT @v_dSql = ''


						   END --'I'
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
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
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

