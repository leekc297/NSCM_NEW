


/*
 * Program ID   : PR_UI_FP00622_AMEND_LINE
 * Description  : Amend Line NJ Pouch
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/15   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00622_AMEND_LINE_NEW]
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
 @p_item_id                    NVARCHAR(MAX),
 @p_nick_name                  NVARCHAR(MAX),
 @p_nick_name_lt               NVARCHAR(MAX),
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
    DECLARE @v_nick_name_lt               NVARCHAR(MAX)
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
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00622_AMEND_LINE'
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
	DECLARE @v_tmp4                 NVARCHAR(MAX)=''
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
    DECLARE @bsubTotal              NVARCHAR(2)= ''
    DECLARE @bTotal                 NVARCHAR(2)= ''
    DECLARE @bEngIn                 NVARCHAR(2)= ''
    DECLARE @bEngOut                NVARCHAR(2)= ''
	DECLARE @bCapa                  NVARCHAR(2)= ''
    DECLARE @bTarget                NVARCHAR(2)= ''
    DECLARE @bMppWpp                NVARCHAR(2)= ''
    DECLARE @bMemo                NVARCHAR(2)= ''

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
	SET @v_nick_name_lt             = ''
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

--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += ' @P_SYS_TYPE= ''' +ISNULL(@P_SYS_TYPE,'') + '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_FLAG= ''' +ISNULL(@P_SYS_FLAG,'') + '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_GUBUN= ''' +ISNULL(@P_SYS_GUBUN,'') + '''' + CHAR(10)
--SET @PARAMS += ',@P_USER_ID= ''' +ISNULL(@P_USER_ID,'') + '''' + CHAR(10)
--SET @PARAMS += ',@P_INSTANCE_ID           = ''' + ISNULL(@p_instance_id				, '') + '''' + char(10)         
--SET @PARAMS += ',@P_COMPANY_ID            = ''' + ISNULL(@p_company_id				, '') + '''' + char(10)         
--SET @PARAMS += ',@P_DIVISION_ID           = ''' + ISNULL(@p_division_id           	, '') + '''' + char(10)
--SET @PARAMS += ',@P_SITE_ID               = ''' + ISNULL(@p_site_id               	, '') + '''' + char(10)
--SET @PARAMS += ',@P_PLANT_ID              = ''' + ISNULL(@p_plant_id              	, '') + '''' + char(10)
--SET @PARAMS += ',@P_FACTORY_ID            = ''' + ISNULL(@p_factory_id            	, '') + '''' + char(10)
--SET @PARAMS += ',@P_LINE_ID               = ''' + ISNULL(@p_line_id               	, '') + '''' + char(10)
--SET @PARAMS += ',@P_OPERATION_ID          = ''' + ISNULL(@p_operation_id          	, '') + '''' + char(10)
--SET @PARAMS += ',@P_MASTER_ID             = ''' + ISNULL(@p_master_id             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_PLAN_DATE             = ''' + ISNULL(@p_plan_date             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_PLAN_ID               = ''' + ISNULL(@p_plan_id               	, '') + '''' + char(10)
--SET @PARAMS += ',@P_PLAN_TYPE             = ''' + ISNULL(@p_plan_type             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_PROD_TYPE             = ''' + ISNULL(@p_prod_type             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_ITEM_ID               = ''' + ISNULL(@p_item_id               	, '') + '''' + char(10)
--SET @PARAMS += ',@P_NICK_NAME             = ''' + ISNULL(@p_nick_name             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_NICK_NAME_LT          = ''' + ISNULL(@p_nick_name_lt          	, '') + '''' + char(10)
--SET @PARAMS += ',@P_TOP_ITEM_ID           = ''' + ISNULL(@p_top_item_id           	, '') + '''' + char(10)
--SET @PARAMS += ',@P_BUCKET_FROM_DATE	  = ''' + ISNULL(@p_bucket_from_date      	, '') + '''' + char(10)
--SET @PARAMS += ',@P_BUCKET_TO_DATE		  = ''' + ISNULL(@p_bucket_to_date	       	, '') + '''' + char(10)
--SET @PARAMS += ',@P_DAY_INFO              = ''' + ISNULL(@p_day_info              	, '') + '''' + char(10)
--SET @PARAMS += ',@P_WEEK_INFO             = ''' + ISNULL(@p_week_info             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_MONTH_INFO            = ''' + ISNULL(@p_month_info            	, '') + '''' + char(10)
--SET @PARAMS += ',@P_CATE_INFO             = ''' + ISNULL(@p_cate_info             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_CATE_VALUE            = ''' + ISNULL(@p_cate_value            	, '') + '''' + char(10)
--SET @PARAMS += ',@P_CATE_TYPE             = ''' + ISNULL(@p_cate_type             	, '') + '''' + char(10)
--SET @PARAMS += ',@P_AMEND_TABLE           = ''' + ISNULL(@p_amend_table           	, '') + '''' + char(10)
--SET @PARAMS += ',@P_AMEND_CUTOFF_BOH_TABLE= ''' + ISNULL(@p_amend_cutoff_boh_table	, '') + '''' + char(10)
--SET @PARAMS += ',@P_AMEND_BOR_TABLE       = ''' + ISNULL(@p_amend_bor_table       	, '') + '''' + char(10)
--SET @PARAMS += ',@P_AMEND_SALES_TABLE     = ''' + ISNULL(@p_amend_sales_table     	, '') + '''' + char(10)
--SET @PARAMS += ',@P_AMEND_UTIL_TABLE      = ''' + ISNULL(@p_amend_util_table      	, '') + '''' + char(10)


--IF @P_SYS_TYPE = 'SQL' BEGIN
--	SELECT @PARAMS AS SQL
--	RETURN
--END

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
            SELECT @v_dSql1 = ''
            SELECT @v_pSql  = ''

            IF(LEN(@p_cate_info) > 0)            
			    BEGIN
  		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

                    WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
                            SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_delimiter, @mst_loop_cnt)
                    
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
                            IF( @v_cate_info = 'chk_subTotal' AND @v_cate_value = 'TRUE' ) 
                                SELECT  @bsubTotal = 'Y'
                            IF( @v_cate_info = 'chk_total' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bTotal = 'Y'
							IF( @v_cate_info = 'chk_capa' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bCapa = 'Y'
                            IF( @v_cate_info = 'chk_target' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bTarget = 'Y'
                            IF( @v_cate_info = 'chk_engine_inqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bEngIn = 'Y'
                            IF( @v_cate_info = 'chk_engine_outqty' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bEngOut = 'Y'
                            IF( @v_cate_info = 'chk_memo' AND @v_cate_value = 'TRUE' ) 
                                SELECT @bMemo = 'Y'
                         END    
						 
                     IF( @bMppIn = '' AND @bMppOut = '' AND @bWppIn = '' AND @bWppOut = '' ) 
					     BEGIN
					         SELECT @bMppWpp = ''
						 END

                     SELECT @v_pSql  = ''
                     SELECT @v_pSql += '                  SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 0 AS CATEGORY_ORDER ' + char(10)
               
                     IF( @bMppIn = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 20 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bMppIn = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 30 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bMppOut = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 40 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bMppOut = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 50 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bWppIn = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 60 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bWppIn = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 70 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bWppOut= 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 80 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bWppOut = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 90 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bDppIn = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 100 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bDppIn = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 110 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bDppOut = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bDppOut = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER ' + char(10)
                         END
                     IF( @bResult = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 140 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bResult = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 150 AS CATEGORY_ORDER ' + char(10)
                         END
                     IF( @bTarget = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 10 AS CATEGORY_ORDER  ' + char(10)
                         END
                     IF( @bEngIn = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_IN_ENGINE'' AS CATEGORY_ID, ''Engine(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 95 AS CATEGORY_ORDER ' + char(10)
                         END
                     IF( @bEngIn = 'Y' AND @bUom = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_IN_ENGINE'' AS CATEGORY_ID, ''Engine(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 97 AS CATEGORY_ORDER ' + char(10)
                         END
                     IF( @bEngOut = 'Y' AND @bCell = 'Y' ) 
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_OUT_ENGINE'' AS CATEGORY_ID, ''Engine(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 115 AS CATEGORY_ORDER ' + char(10)
                         END
                     
					 IF( @bEngOut = 'Y' AND @bUom = 'Y' )
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_OUT_ENGINE'' AS CATEGORY_ID, ''Engine(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 117 AS CATEGORY_ORDER' + char(10)
                         END
					 IF( @bMemo = 'Y')
					     BEGIN
                             SELECT @v_pSql += '                  UNION ALL ' + char(10)
                             SELECT @v_pSql += '                  SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 200 AS CATEGORY_ORDER' + char(10)
                         END
			    END
		    ELSE
			    BEGIN
				    SELECT @v_pSql  = ''
                    SELECT @v_pSql += '                  SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 20 AS CATEGORY_ORDER 	 ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''M_IN'' AS CATEGORY_ID, ''MPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 30 AS CATEGORY_ORDER       ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 40 AS CATEGORY_ORDER   ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''M_OUT'' AS CATEGORY_ID, ''MPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 50 AS CATEGORY_ORDER     ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 60 AS CATEGORY_ORDER     ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''W_IN'' AS CATEGORY_ID, ''WPP(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 70 AS CATEGORY_ORDER       ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 80 AS CATEGORY_ORDER   ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''W_OUT'' AS CATEGORY_ID, ''WPP(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 90 AS CATEGORY_ORDER     ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 100 AS CATEGORY_ORDER   ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_IN'' AS CATEGORY_ID, ''Plan(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 110 AS CATEGORY_ORDER     ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER   ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 140 AS CATEGORY_ORDER   ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''RESULT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 150 AS CATEGORY_ORDER     ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''TARGET'' AS CATEGORY_ID, ''Target'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 10 AS CATEGORY_ORDER            ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_IN_ENGINE'' AS CATEGORY_ID, ''Engine(In)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 95 AS CATEGORY_ORDER  ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_IN_ENGINE'' AS CATEGORY_ID, ''Engine(In)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 97 AS CATEGORY_ORDER  ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10);
                    SELECT @v_pSql += '                  SELECT ''P_OUT_ENGINE'' AS CATEGORY_ID, ''Engine(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 115 AS CATEGORY_ORDER  ' + char(10)
                    SELECT @v_pSql += '                  UNION ALL  ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_OUT_ENGINE'' AS CATEGORY_ID, ''Engine(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 117 AS CATEGORY_ORDER  ' + char(10)                
                    SELECT @v_pSql += '                  UNION ALL ' + char(10)
                    SELECT @v_pSql += '                  SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 200 AS CATEGORY_ORDER' + char(10)

--2023.12.30 천승호
					SELECT @v_pSql += ' OPTION (MAXDOP 1) ; ' + char(10)

			    END		

            SELECT @v_dSql1 += '   WITH MAIN AS ( ' + char(10)  
            SELECT @v_dSql1 += '       SELECT A.* ' + char(10)  
            SELECT @v_dSql1 += '       FROM (     ' + char(10)  
            SELECT @v_dSql1 += '            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID              ' + char(10)  
            SELECT @v_dSql1 += '                , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE           ' + char(10)  
            SELECT @v_dSql1 += '                , A.EQUIPMENT_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE       ' + char(10)  
            SELECT @v_dSql1 += '                , A.MARKET, A.ITEM_TYPE, B.CATEGORY_NAME AS CATE, B.MEASURE_NAME AS MEASURE_NAME ' + char(10)  
            
			IF  LEN(@p_day_info) > 0
                BEGIN
					SELECT @v_tmp1 = ''
		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                            SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
					    
                            SELECT @v_tmp1 += '               , SUM(CASE WHEN C.YYYYMM = ''' + @v_month_info + ''' THEN                                            ' +char(10)
			                SELECT @v_tmp1 += '                  ( CASE WHEN B.CATEGORY_ID=''P_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.IN_QTY              ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''P_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.CELL_IN_QTY         ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''P_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.OUT_QTY             ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''P_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.CELL_OUT_QTY        ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''W_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.WPP_IN_QTY          ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''W_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.WPP_CELL_IN_QTY     ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''W_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.WPP_OUT_QTY         ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''W_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.WPP_CELL_OUT_QTY    ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''M_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.MPP_IN_QTY          ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''M_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.MPP_CELL_IN_QTY     ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''M_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.MPP_OUT_QTY         ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''M_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.MPP_CELL_OUT_QTY    ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''RESULT''       AND B.MEASURE_ID = ''UOM''  THEN A.RESULT_OUT_QTY      ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''RESULT''       AND B.MEASURE_ID = ''CELL'' THEN A.RESULT_CELL_OUT_QTY ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''TARGET''                                   THEN A.TARGET_QTY          ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''P_IN_ENGINE''  AND B.MEASURE_ID = ''UOM''  THEN A.ORG_IN_QTY          ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''P_IN_ENGINE''  AND B.MEASURE_ID = ''CELL'' THEN A.ORG_CELL_IN_QTY     ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''P_OUT_ENGINE'' AND B.MEASURE_ID = ''UOM''  THEN A.ORG_OUT_QTY         ' +char(10)
                            SELECT @v_tmp1 += '                         WHEN B.CATEGORY_ID=''P_OUT_ENGINE'' AND B.MEASURE_ID = ''CELL'' THEN A.ORG_CELL_OUT_QTY    ' +char(10)
                            SELECT @v_tmp1 += '                         ELSE 0 END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY                ' +char(10)
                            SELECT @v_tmp1 += '               , NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR                                         ' +char(10)
                            
                        END
                  SELECT @v_tmp2 = ''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						  SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp2 += '               , SUM(CASE WHEN C.ISO_YYYYWW = ''' + @v_week_info + ''' THEN                                          ' +char(10)
			              SELECT @v_tmp2 += '                  (CASE WHEN B.CATEGORY_ID = ''P_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.IN_QTY              ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''P_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.CELL_IN_QTY         ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''P_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.OUT_QTY             ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''P_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.CELL_OUT_QTY        ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''W_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.WPP_IN_QTY          ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''W_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.WPP_CELL_IN_QTY     ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''W_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.WPP_OUT_QTY         ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''W_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.WPP_CELL_OUT_QTY    ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''M_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.MPP_IN_QTY          ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''M_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.MPP_CELL_IN_QTY     ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''M_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.MPP_OUT_QTY         ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''M_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.MPP_CELL_OUT_QTY    ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''RESULT''       AND B.MEASURE_ID = ''UOM''  THEN A.RESULT_OUT_QTY      ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''RESULT''       AND B.MEASURE_ID = ''CELL'' THEN A.RESULT_CELL_OUT_QTY ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''TARGET''                                   THEN A.TARGET_QTY          ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''P_IN_ENGINE''  AND B.MEASURE_ID = ''UOM''  THEN A.ORG_IN_QTY          ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''P_IN_ENGINE''  AND B.MEASURE_ID = ''CELL'' THEN A.ORG_CELL_IN_QTY     ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''P_OUT_ENGINE'' AND B.MEASURE_ID = ''UOM''  THEN A.ORG_OUT_QTY         ' +char(10)
                          SELECT @v_tmp2 += '                        WHEN B.CATEGORY_ID = ''P_OUT_ENGINE'' AND B.MEASURE_ID = ''CELL'' THEN A.ORG_CELL_OUT_QTY    ' +char(10)
                          SELECT @v_tmp2 += '                      ELSE 0 END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY                    ' +char(10)
                          SELECT @v_tmp2 += '               , NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR                                          ' +char(10)  
                      END

                  SELECT @v_tmp3 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp3 += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @v_day_info + ''' THEN                       ' +char(10)
			              SELECT @v_tmp3 += '                  (CASE WHEN B.CATEGORY_ID = ''P_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.IN_QTY              ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''P_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.CELL_IN_QTY         ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''P_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.OUT_QTY             ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''P_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.CELL_OUT_QTY        ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''W_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.WPP_IN_QTY          ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''W_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.WPP_CELL_IN_QTY     ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''W_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.WPP_OUT_QTY         ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''W_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.WPP_CELL_OUT_QTY    ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''M_IN''         AND B.MEASURE_ID = ''UOM''  THEN A.MPP_IN_QTY          ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''M_IN''         AND B.MEASURE_ID = ''CELL'' THEN A.MPP_CELL_IN_QTY     ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''M_OUT''        AND B.MEASURE_ID = ''UOM''  THEN A.MPP_OUT_QTY         ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''M_OUT''        AND B.MEASURE_ID = ''CELL'' THEN A.MPP_CELL_OUT_QTY    ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''RESULT''       AND B.MEASURE_ID = ''UOM''  THEN A.RESULT_OUT_QTY      ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''RESULT''       AND B.MEASURE_ID = ''CELL'' THEN A.RESULT_CELL_OUT_QTY ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''TARGET''                                  THEN A.TARGET_QTY           ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''P_IN_ENGINE''  AND B.MEASURE_ID = ''UOM''  THEN A.ORG_IN_QTY          ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''P_IN_ENGINE''  AND B.MEASURE_ID = ''CELL'' THEN A.ORG_CELL_IN_QTY     ' +char(10)
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''P_OUT_ENGINE'' AND B.MEASURE_ID = ''UOM''  THEN A.ORG_OUT_QTY         ' +char(10);
                          SELECT @v_tmp3 += '                        WHEN B.CATEGORY_ID = ''P_OUT_ENGINE'' AND B.MEASURE_ID = ''CELL'' THEN A.ORG_CELL_OUT_QTY    ' +char(10)
                          SELECT @v_tmp3 += '                             ELSE 0 END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY             ' +char(10)
                          SELECT @v_tmp3 += '               , NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR                                          ' +char(10)
                      END
            
			    END

            SELECT  @v_dSql1  = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3 

            SELECT @v_dSql1 += '               , B.CATEGORY_ID, B.MEASURE_ID, B.CATEGORY_ORDER, ''DATA'' AS DATA_TYPE   ' +char(10)
            SELECT @v_dSql1 += '            FROM(                                                                       ' +char(10)
            SELECT @v_dSql1 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
            SELECT @v_dSql1 += '                    , A.LOCATION, A.OPERATION_ID, A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE ' +char(10)
            SELECT @v_dSql1 += '                    , A.EQUIPMENT_ID, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME ' +char(10)
            SELECT @v_dSql1 += '                    , A.PRODUCTION_TYPE, A.MARKET, B.ITEM_TYPE , A.PLAN_TYPE, A.SEQ                                ' +char(10)
            SELECT @v_dSql1 += '                    , A.IN_QTY, A.OUT_QTY, A.CELL_IN_QTY, A.CELL_OUT_QTY, A.MPP_IN_QTY                             ' +char(10)
            SELECT @v_dSql1 += '                    , A.MPP_CELL_IN_QTY, A.MPP_OUT_QTY, A.MPP_CELL_OUT_QTY, A.WPP_IN_QTY, A.WPP_CELL_IN_QTY        ' +char(10)
            SELECT @v_dSql1 += '                    , A.WPP_OUT_QTY, A.WPP_CELL_OUT_QTY, A.RESULT_CELL_OUT_QTY, A.RESULT_OUT_QTY, A.TARGET_QTY     ' +char(10)
            SELECT @v_dSql1 += '                    , A.ORG_IN_QTY, A.ORG_OUT_QTY, A.ORG_CELL_IN_QTY, A.ORG_CELL_OUT_QTY                           ' +char(10)
            SELECT @v_dSql1 += '                FROM (                                                                                             ' +char(10)
            SELECT @v_dSql1 += '                     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                       ' +char(10)
            SELECT @v_dSql1 += '                         , A.LOCATION, A.OPERATION_ID, A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE              ' +char(10)
            SELECT @v_dSql1 += '                         , '''' AS EQUIPMENT_ID, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME          ' +char(10)
            SELECT @v_dSql1 += '                         , A.PRODUCTION_TYPE, A.MARKET, ''DPP'' AS PLAN_TYPE, DATE_SEQ AS SEQ, A.IN_QTY            ' +char(10)
            SELECT @v_dSql1 += '                         , A.OUT_QTY, A.CELL_IN_QTY, A.CELL_OUT_QTY, A.MPP_IN_QTY, A.MPP_CELL_IN_QTY               ' +char(10)
            SELECT @v_dSql1 += '                         , A.MPP_OUT_QTY, A.MPP_CELL_OUT_QTY, A.WPP_IN_QTY, A.WPP_CELL_IN_QTY, A.WPP_OUT_QTY       ' +char(10)
            SELECT @v_dSql1 += '                         , A.WPP_CELL_OUT_QTY, A.RESULT_CELL_OUT_QTY, A.RESULT_OUT_QTY, 0 TARGET_QTY, A.ORG_IN_QTY ' +char(10)
            SELECT @v_dSql1 += '                         , A.ORG_OUT_QTY, A.ORG_CELL_IN_QTY, A.ORG_CELL_OUT_QTY                                    ' +char(10)
            SELECT @v_dSql1 += '                     FROM   '+ @p_amend_table +' A WITH(NOLOCK)         ' +char(10)
            SELECT @v_dSql1 += '                     WHERE  A.INSTANCE_ID      = '''+ @p_master_id +''' ' +char(10)
            SELECT @v_dSql1 += '                     AND    A.FP_PLAN_ID       = '''+ @p_plan_id +'''   ' +char(10)
			SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))               + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
			SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            SELECT @v_dSql1 += '                     AND  CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
            SELECT @v_dSql1 += '                     AND  (ISNULL(A.OUT_QTY,0) + ISNULL(A.MPP_OUT_QTY,0) + ISNULL(A.WPP_OUT_QTY,0) + ISNULL(A.RESULT_OUT_QTY,0)) <> 0 ' +char(10)
			
			IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '              AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '              AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	

            SELECT @v_dSql1 += '                     UNION ALL                                                                                 ' + char(10)
            SELECT @v_dSql1 += '                     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                   ' + char(10)
            SELECT @v_dSql1 += '                           , A.LOCATION, A.OPERATION_ID, A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE        ' + char(10)
            SELECT @v_dSql1 += '                           , '''' AS EQUIPMENT_ID, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
            SELECT @v_dSql1 += '                           , A.PRODUCTION_TYPE, A.MARKET, ''DPP'' AS PLAN_TYPE, '''' AS SEQ, 0 IN_QTY          ' + char(10)
            SELECT @v_dSql1 += '                           , 0 OUT_QTY, 0 CELL_IN_QTY, 0 CELL_OUT_QTY, 0 MPP_IN_QTY, 0 MPP_CELL_IN_QTY         ' + char(10)
            SELECT @v_dSql1 += '                           , 0 MPP_OUT_QTY, 0 MPP_CELL_OUT_QTY, 0 WPP_IN_QTY, 0 WPP_CELL_IN_QTY, 0 WPP_OUT_QTY ' + char(10)
            SELECT @v_dSql1 += '                           , 0 WPP_CELL_OUT_QTY, 0 RESULT_CELL_OUT_QTY, 0 RESULT_OUT_QTY, ISNULL(A.SALES_QTY,0) AS TARGET_QTY, 0 AS ORG_IN_QTY ' + char(10)
            SELECT @v_dSql1 += '                           , 0 AS ORG_OUT_QTY, 0 AS ORG_CELL_IN_QTY, 0 AS ORG_CELL_OUT_QTY               ' + char(10)
            SELECT @v_dSql1 += '                     FROM    '+ @p_amend_sales_table +' A WITH(NOLOCK)                                   ' + char(10)
            SELECT @v_dSql1 += '                     WHERE  A.INSTANCE_ID      = '''+ @p_master_id +'''                                  ' + char(10)
            SELECT @v_dSql1 += '                     AND    A.FP_PLAN_ID       = '''+ @p_plan_id +'''                                    ' + char(10)
			SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))             + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
            SELECT @v_dSql1 += '                     AND  CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN  '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
            SELECT @v_dSql1 += '                     AND  ISNULL(A.SALES_QTY,0) <> 0                                     ' +char(10)
			IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '              AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '              AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
            SELECT @v_dSql1 += '                ) A          ' + char(10)
            SELECT @v_dSql1 += '                INNER JOIN ( ' + char(10)
            SELECT @v_dSql1 += '                     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID ' + char(10)
            SELECT @v_dSql1 += '                         ,(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
            SELECT @v_dSql1 += '                           WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
            SELECT @v_dSql1 += '                           ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
            SELECT @v_dSql1 += '                         ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql1 += '                     FROM   SCM_ITEM_M A WITH(NOLOCK)            ' + char(10)
            SELECT @v_dSql1 += '                       	   ,SCM_ITEM_CLASS_M C WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql1 += '                     WHERE	 1=1                                 ' + char(10)
			SELECT @v_dSql1 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))           + char(10)
            SELECT @v_dSql1 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                   + char(10)
			IF LEN(@p_nick_name_lt) > 0
			    BEGIN
			        SELECT @v_dSql1 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt)) + char(10)
				END
            SELECT @v_dSql1 += '                     AND A.ITEM_CLASS   = C.CLASS_ID                                                      ' + char(10)

            SELECT @v_dSql1 += '                ) B                                        ' + char(10)
            SELECT @v_dSql1 += '                ON     A.COMPANY_ID     = B.COMPANY_ID     ' + char(10)
            SELECT @v_dSql1 += '                AND    A.DIVISION_ID    = B.DIVISION_ID    ' + char(10)
            SELECT @v_dSql1 += '                AND    A.SITE_ID        = B.SITE_ID        ' + char(10)
            SELECT @v_dSql1 += '                AND    A.TOP_ITEM_ID    = B.ITEM_ID        ' + char(10)
            SELECT @v_dSql1 += '                INNER JOIN SCM_LINE_M C WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql1 += '                ON     A.COMPANY_ID     = C.COMPANY_ID     ' + char(10)
            SELECT @v_dSql1 += '                AND    A.DIVISION_ID    = C.DIVISION_ID    ' + char(10)
            SELECT @v_dSql1 += '                AND    A.SITE_ID        = C.SITE_ID        ' + char(10)
            SELECT @v_dSql1 += '                AND    A.PLANT_ID       = C.PLANT_ID       ' + char(10)
            SELECT @v_dSql1 += '                AND    A.FACTORY_ID     = C.FACTORY_ID     ' + char(10)
            SELECT @v_dSql1 += '                AND    A.OPERATION_ID   = C.OPERATION_ID   ' + char(10)
            SELECT @v_dSql1 += '                AND    A.LINE_ID        = C.LINE_ID        ' + char(10)
            SELECT @v_dSql1 += '                AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql1 += '                WHERE  1=1                                 ' + char(10)
			
			IF LEN(@p_nick_name) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql1 += '              AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			    END	

            SELECT @v_dSql1 += '           ) A                                  ' + char(10)
            SELECT @v_dSql1 += '           INNER JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '           ON  1=1                              ' + char(10)
            SELECT @v_dSql1 += '           AND CONVERT(VARCHAR, C.DT, 112) BETWEEN  '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
            SELECT @v_dSql1 += '           AND A.PLAN_DATE = C.DT           ' + char(10)
            SELECT @v_dSql1 += '           INNER JOIN (                     ' + char(10)
            SELECT @v_dSql1 += '               SELECT * FROM (              ' + char(10)
           
		    SELECT @v_dSql1 += @v_pSql

            SELECT @v_dSql1 += '                 ) A                        ' + char(10)
            SELECT @v_dSql1 += '                 WHERE CATEGORY_ID <> ''X'' ' + char(10)
            SELECT @v_dSql1 += '          ) B                               ' + char(10)
            SELECT @v_dSql1 += '           ON 1=1                           ' + char(10)
            SELECT @v_dSql1 += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql1 += '             , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql1 += '             , A.EQUIPMENT_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME                ' + char(10)
            SELECT @v_dSql1 += '             , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE, B.CATEGORY_ID              ' + char(10)
            SELECT @v_dSql1 += '             ,B.CATEGORY_NAME, B.MEASURE_ID, B.MEASURE_NAME, B.CATEGORY_ORDER       ' + char(10)
            SELECT @v_dSql1 += '      ) A                                                                           ' + char(10)
            SELECT @v_dSql1 += '   )                                                                                ' + char(10)

			SELECT @v_dSql2 = ''
            SELECT @v_dSql2 += '   , CAPA_VALUE AS (  ' + char(10)
            SELECT @v_dSql2 += '       SELECT *       ' + char(10)
            SELECT @v_dSql2 += '       FROM (         ' + char(10)
            SELECT @v_dSql2 += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID             ' + char(10)
			SELECT @v_dSql2 += '               , A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql2 += '                , '''+ @p_bucket_from_date +''' AS PLAN_DATE, NULL AS OFF_TIME                 ' + char(10)
            SELECT @v_dSql2 += '                , NULL AS SETUP_TIME, NULL AS UTILIZATION     ' + char(10)
            SELECT @v_dSql2 += '           FROM   '+ @p_amend_table +' A WITH(NOLOCK)         ' + char(10)
            SELECT @v_dSql2 += '           INNER JOIN SCM_ITEM_M B WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql2 += '           ON     A.COMPANY_ID     = B.COMPANY_ID             ' + char(10)
            SELECT @v_dSql2 += '           AND    A.DIVISION_ID    = B.DIVISION_ID            ' + char(10)
            SELECT @v_dSql2 += '           AND    A.SITE_ID        = B.SITE_ID                ' + char(10)
            SELECT @v_dSql2 += '           AND    A.ITEM_ID        = B.ITEM_ID                ' + char(10)
            SELECT @v_dSql2 += '           WHERE  INSTANCE_ID      = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql2 += '           AND    FP_PLAN_ID       = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))       + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))               + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
            SELECT @v_dSql2 += '           AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN  '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
			IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '           AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '           AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
			IF LEN(@p_nick_name) > 0 																			                
			    BEGIN	
                    SELECT @v_dSql2 += '           AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''       ' + char(10)
			    END	
			SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            SELECT @v_dSql2 += '           AND	A.OUT_QTY > 0                                                                      ' +char(10)
            SELECT @v_dSql2 += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID               ' +char(10)
			SELECT @v_dSql2 += '               , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE                           ' +char(10)
            SELECT @v_dSql2 += '           UNION ALL                                                                               ' +char(10)
            SELECT @v_dSql2 += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                 ' +char(10)
			SELECT @v_dSql2 += '                , A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE    ' +char(10)
            SELECT @v_dSql2 += '                , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE, SUM(A.OFF_TIME) AS OFF_TIME     ' +char(10)
            SELECT @v_dSql2 += '                , SUM(A.SETUP_TIME) AS SETUP_TIME, AVG(A.UTILIZATION) AS UTILIZATION               ' +char(10)
            SELECT @v_dSql2 += '           FROM   FP_AMEND_PLAN_CELL_UTIL_R A WITH(NOLOCK)                                         ' +char(10)
            SELECT @v_dSql2 += '           WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''                                         ' +char(10)
            SELECT @v_dSql2 += '           AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''                                             ' +char(10)
			SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
            SELECT @v_dSql2 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
            SELECT @v_dSql2 += '           AND  CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN  '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' +char(10)
            SELECT @v_dSql2 += '           AND  EXISTS (                                               ' +char(10)
            SELECT @v_dSql2 += '                    SELECT 1                                           ' +char(10)
            SELECT @v_dSql2 += '                    FROM  '+ @p_amend_table +' AAA WITH(NOLOCK)        ' +char(10)
			SELECT @v_dSql2 += '                        , SCM_ITEM_M BBB WITH(NOLOCK)                  ' +char(10)
            SELECT @v_dSql2 += '                    WHERE  AAA.COMPANY_ID   = BBB.COMPANY_ID           ' +char(10)
            SELECT @v_dSql2 += '                    AND    AAA.DIVISION_ID  = BBB.DIVISION_ID          ' +char(10)
            SELECT @v_dSql2 += '                    AND    AAA.SITE_ID      = BBB.SITE_ID              ' +char(10)
            SELECT @v_dSql2 += '                    AND    AAA.ITEM_ID      = BBB.ITEM_ID              ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.COMPANY_ID     = AAA.COMPANY_ID           ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.DIVISION_ID    = AAA.DIVISION_ID          ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.SITE_ID        = AAA.SITE_ID              ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.PLANT_ID       = AAA.PLANT_ID             ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.FACTORY_ID     = AAA.FACTORY_ID           ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.LOCATION       = AAA.LOCATION             ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.OPERATION_ID   = AAA.OPERATION_ID         ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.LINE_ID        = AAA.LINE_ID              ' +char(10)
            SELECT @v_dSql2 += '                    AND    A.ELECTRODE_TYPE = AAA.ELECTRODE_TYPE       ' +char(10)
            SELECT @v_dSql2 += '                    AND    AAA.INSTANCE_ID  = '''+ @p_instance_id +''' ' +char(10)
            SELECT @v_dSql2 += '                    AND    AAA.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' +char(10)
			SELECT @v_dSql2 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql2 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql2 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql2 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10)
            SELECT @v_dSql2 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
            SELECT @v_dSql2 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.LINE_ID' , 'EQ', @p_line_id))           + char(10)
            SELECT @v_dSql2 += '               AND    CONVERT(VARCHAR, AAA.PLAN_DATE, 112) BETWEEN  '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +''' ' +char(10)
			IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '               AND  AAA.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '               AND  AAA.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
			IF LEN(@p_nick_name) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '               AND  BBB.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''       ' + char(10)
			    END	

			SELECT @v_dSql2 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            SELECT @v_dSql2 += '               ) ' + char(10)
            SELECT @v_dSql2 += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
			SELECT @v_dSql2 += '                , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql2 += '                , CONVERT(VARCHAR, A.PLAN_DATE, 112) ' + char(10)
            SELECT @v_dSql2 += '         ) A ' + char(10)
			
			IF ( @bsubTotal <> 'Y') --subtotal
                BEGIN
                    SELECT @v_dSql2 += ' WHERE 1=0 ' + char(10)
			    END
            SELECT @v_dSql2 += '    ) ' + char(10)

			SELECT @v_dSql3 = ''
            SELECT @v_dSql3 += '    , T_MEMO AS (                                                                        ' + char(10)
            SELECT @v_dSql3 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID        ' + char(10)
            SELECT @v_dSql3 += '                , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.ITEM_ID ' + char(10)
            SELECT @v_dSql3 += '                , A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                             ' + char(10)

			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
          
            IF(LEN(@p_day_info) > 0)
              BEGIN
				  WHILE @mst_loop_cnt < @max_loop_cnt      
                      BEGIN                                
                          SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                     
                          SELECT @v_tmp1 += '                , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @v_day_info + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO ' +char(10)
                      END                                  
              END
            
			SELECT @v_dSql3 += @v_tmp1

            SELECT @v_dSql3 += '         FROM FP_AMEND_MEMO_M A WITH(NOLOCK)              ' +char(10)
            SELECT @v_dSql3 += '         WHERE 1=1                                        ' +char(10)
            SELECT @v_dSql3 += '         AND    A.INSTANCE_ID  = '''+ @p_instance_id +''' ' +char(10)
			SELECT @v_dSql3 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql3 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql3 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql3 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10)
            SELECT @v_dSql3 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
            SELECT @v_dSql3 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
			SELECT @v_dSql3 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)

			IF LEN(@p_top_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql3 += '         AND  A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''   ' + char(10)
			    END	
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql3 += '         AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	

            SELECT @v_dSql3 += '         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID          ' + char(10)
            SELECT @v_dSql3 += '                , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID               ' + char(10)
            SELECT @v_dSql3 += '                , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                     ' + char(10)
            SELECT @v_dSql3 += '   )                                                                                        ' + char(10)
            SELECT @v_dSql3 += '   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                  ' + char(10)
            SELECT @v_dSql3 += '        , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID           ' + char(10)
            SELECT @v_dSql3 += '        , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET, A.CATE                     ' + char(10)
            SELECT @v_dSql3 += '        , A.CATEGORY_ID, A.CATEGORY_ORDER, A.MEASURE_NAME, A.MEASURE_ID, A.DATA_TYPE        ' + char(10)
            SELECT @v_dSql3 += '        , DENSE_RANK() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql3 += '           ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID) AS LV1 ' + char(10)
            SELECT @v_dSql3 += '        , B.APPLIED_MODEL ' + char(10)

			IF  LEN(@p_day_info) > 0
                BEGIN
					SELECT @v_tmp1 = ''
		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                            SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
					    
                            SELECT @v_tmp1 += '        , M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10) 
                        END
                  SELECT @v_tmp2 = ''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						  SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp2 += '        , W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END

                  SELECT @v_tmp3 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp3 += '        , D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END

                  SELECT @v_tmp4 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp4 += '        , C.D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO ' +char(10)
                      END
            
			    END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3 + @v_tmp4

            SELECT @v_dSql3 += '       , CASE  WHEN R.FACTORY_ID IS NULL THEN ''N''                                       ' +char(10)
            SELECT @v_dSql3 += '         WHEN ''RELEASE'' = '''+ @p_plan_type +''' THEN ''Y''                             ' +char(10)
            SELECT @v_dSql3 += '         WHEN D.PRODUCTION_TYPE IS NULL                                                   ' +char(10)
            --SELECT @v_dSql3 += '           OR (A.OPERATION_ID IN (''A3000'',''A9000'') AND H.MARKET IS NULL)              ' +char(10) -- 타겟체크 제거... 20231115
            SELECT @v_dSql3 += '           OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'')                ' +char(10)
			SELECT @v_dSql3 += '           AND A.PRODUCTION_TYPE = ''TEST'') THEN ''N'' ELSE ''Y'' END AS EDIT_YN         ' +char(10)
            SELECT @v_dSql3 += '       , ISNULL(BB.ITEM_TYPE,''-'') AS ITEM_TYPE, ISNULL(BB.NICK_NAME,''-'') AS NICK_NAME ' +char(10)
            SELECT @v_dSql3 += '       , ISNULL(CC.LINE_NAME,''-'') AS LINE_NAME                                          ' +char(10)
            SELECT @v_dSql3 += '   FROM (                                                                                 ' +char(10)
            SELECT @v_dSql3 += '       SELECT * FROM MAIN                                                                 ' +char(10)
            SELECT @v_dSql3 += '       UNION ALL                                                                          ' +char(10)
            SELECT @v_dSql3 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID              ' +char(10)
            SELECT @v_dSql3 += '         , A.LOCATION, A.OPERATION_ID, A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE  ' +char(10)
            SELECT @v_dSql3 += '         , NULL AS EQUIPMENT_ID, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME    ' +char(10)
            SELECT @v_dSql3 += '         , NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS ITEM_TYPE,A.CATE, A.MEASURE_NAME ' +char(10)

			IF  LEN(@p_day_info) > 0
                BEGIN
					SELECT @v_tmp1 = ''
		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                            SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
					    
                            SELECT @v_tmp1 += '         ,SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10) 
                        END
                  SELECT @v_tmp2 = ''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						  SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp2 += '         ,SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END

                  SELECT @v_tmp3 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp3 += '         ,SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END
			    END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3

            SELECT @v_dSql3 += '         ,A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER, ''TOTAL'' AS DATA_TYPE   ' +char(10)
            SELECT @v_dSql3 += '       FROM   MAIN A     ' +char(10)
			
			IF ( @bsubTotal <> 'Y') --subtotal
                BEGIN
                    SELECT @v_dSql3 += '       WHERE 1=0 ' + char(10)
			    END
            SELECT @v_dSql3 += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID      ' + char(10)
			SELECT @v_dSql3 += '               , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE              ' + char(10)
            SELECT @v_dSql3 += '               ,A.CATE, A.MEASURE_NAME, A.CATEGORY_ID, A.MEASURE_ID, A.CATEGORY_ORDER ' + char(10)
            SELECT @v_dSql3 += '       -- Off Calendar, Setup                                                         ' + char(10)
			
			SELECT @v_dSql4 = ''
            SELECT @v_dSql4 += '       UNION ALL                                                                                                     ' + char(10)
            SELECT @v_dSql4 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                                       ' + char(10)
            SELECT @v_dSql4 += '             , A.LOCATION, A.OPERATION_ID, A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE                       ' + char(10)
            SELECT @v_dSql4 += '             , NULL AS EQUIPMENT_ID, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME,NULL AS PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql4 += '             , NULL AS MARKET, NULL AS ITEM_TYPE,B.CATEGORY_NAME AS CATE,NULL AS MEASURE_NAME                        ' + char(10)

			IF  LEN(@p_day_info) > 0
                BEGIN
					SELECT @v_tmp1 = ''
		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                            SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
					    
                            SELECT @v_tmp1 += '             ,SUM(CASE WHEN C.YYYYMM= '''+ @v_month_info +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY ' +char(10) 
                            SELECT @v_tmp1 += '             ,NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10) 
                        END
                  SELECT @v_tmp2 = ''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						  SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp2 += '             ,SUM(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY ' +char(10)
                          SELECT @v_tmp2 += '             ,NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END

                  SELECT @v_tmp3 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp3 += '             ,SUM(CASE WHEN C.YYYYMMDD='''+ @v_day_info +''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY ' +char(10)
                          SELECT @v_tmp3 += '             ,NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END
			    END
            
			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

            SELECT @v_dSql4 += '             ,B.CATEGORY_ID, NULL AS MEASURE_ID, B.CATEGORY_ORDER, ''TOTAL'' AS DATA_TYPE        ' + char(10)
            SELECT @v_dSql4 += '       FROM   CAPA_VALUE A                                                                       ' + char(10)
            SELECT @v_dSql4 += '       INNER JOIN (                                                                              ' + char(10)
            SELECT @v_dSql4 += '           SELECT ''OFF'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER   ' + char(10)
            SELECT @v_dSql4 += '           UNION ALL                                                                             ' + char(10)
            SELECT @v_dSql4 += '           SELECT ''SETUP'' AS CATEGORY_ID, ''M/C(min)'' AS CATEGORY_NAME, 500 AS CATEGORY_ORDER ' + char(10)
            SELECT @v_dSql4 += '       ) B                                       ' + char(10)
            SELECT @v_dSql4 += '       ON 1=1                                    ' + char(10)
            SELECT @v_dSql4 += '       INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql4 += '       ON  A.PLAN_DATE = C.YYYYMMDD              ' + char(10)
			
			IF ( @bsubTotal <> 'Y') --subtotal
                BEGIN
                    SELECT @v_dSql4 += '       WHERE 1=0 ' + char(10)
			    END
            SELECT @v_dSql4 += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql4 += '             , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE           ' + char(10)
            SELECT @v_dSql4 += '             , B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER                  ' + char(10)
            SELECT @v_dSql4 += '       -- Capa                                                                   ' + char(10)
            SELECT @v_dSql4 += '       UNION ALL                                                                 ' + char(10)
            SELECT @v_dSql4 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
            SELECT @v_dSql4 += '            , A.LOCATION, A.OPERATION_ID, A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE                        ' + char(10)
            SELECT @v_dSql4 += '            , NULL AS EQUIPMENT_ID, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql4 += '            , NULL AS MARKET, NULL AS ITEM_TYPE, '' Load(%)'' AS CATE, NULL AS MEASURE_NAME                          ' + char(10)

			IF  LEN(@p_day_info) > 0
                BEGIN
					SELECT @v_tmp1 = ''
		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                            SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
					    
                            SELECT @v_tmp1 += '            ,CEILING(AVG(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY ' +char(10) 
                            SELECT @v_tmp1 += '            ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END  AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10) 
                        END
                  SELECT @v_tmp2 = ''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						  SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp2 += '            ,CEILING(AVG(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY ' +char(10)
                          SELECT @v_tmp2 += '            ,CASE WHEN (CEILING(AVG(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END

                  SELECT @v_tmp3 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp3 += '            ,CEILING(AVG(CASE WHEN C.YYYYMMDD='''+ @v_day_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY ' +char(10)
                          SELECT @v_tmp3 += '            ,CASE WHEN (CEILING(AVG(CASE WHEN C.YYYYMMDD='''+ @v_day_info +''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR' +char(10)
                      END
			    END
            
			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

            SELECT @v_dSql4 += '            ,''CAPA'' AS CATEGORY_ID, NULL AS MEASURE_ID, 600 AS CATEGORY_ORDER,''TOTAL'' AS DATA_TYPE ' + char(10)
            SELECT @v_dSql4 += '       FROM   CAPA_VALUE A                       ' + char(10)
            SELECT @v_dSql4 += '       INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql4 += '       ON  A.PLAN_DATE = C.YYYYMMDD              ' + char(10)

			IF ( @bsubTotal <> 'Y') --subtotal
                BEGIN
                    SELECT @v_dSql4 += '       WHERE 1=0 ' + char(10)
			    END
			ELSE
			    IF ( @bCapa <> 'Y') --Capa
                    BEGIN
                        SELECT @v_dSql4 += '       WHERE 1=0 ' + char(10)
			        END
            SELECT @v_dSql4 += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql4 += '            , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE            ' + char(10)
            SELECT @v_dSql4 += '       -- Total                                                                  ' + char(10)
            SELECT @v_dSql4 += '       UNION ALL                                                                 ' + char(10)
            SELECT @v_dSql4 += '       SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID                     ' + char(10)
            SELECT @v_dSql4 += '             , NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID, NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql4 += '             , NULL AS EQUIPMENT_ID, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS PRODUCTION_TYPE            ' + char(10)
            SELECT @v_dSql4 += '             , NULL AS MARKET, NULL AS ITEM_TYPE, A.CATE, A.MEASURE_NAME                                                         ' + char(10)

			IF  LEN(@p_day_info) > 0
                BEGIN
					SELECT @v_tmp1 = ''
		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
					WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                            SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
					    
                            SELECT @v_tmp1 += '             ,SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, NULL AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10) 
                        END
                  SELECT @v_tmp2 = ''
                  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						  SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp2 += '             ,SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, NULL AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR' +char(10)
                      END

                  SELECT @v_tmp3 = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                  
                  WHILE @mst_loop_cnt < @max_loop_cnt
                      BEGIN         
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                          SELECT @v_tmp3 += '             ,SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_QTY, NULL AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_COLOR ' +char(10)
                      END
			    END

			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

            SELECT @v_dSql4 += '             ,A.CATEGORY_ID, A.MEASURE_NAME, A.CATEGORY_ORDER,''TOTAL_2'' AS DATA_TYPE                ' + char(10)
            SELECT @v_dSql4 += '       FROM   MAIN A    ' + char(10)
			
			IF ( @bTotal <> 'Y') --total
                BEGIN
                    SELECT @v_dSql4 += '       WHERE 1=0 ' + char(10)
			    END
            SELECT @v_dSql4 += '       GROUP BY A.OPERATION_ID, A.CATE, A.CATEGORY_ID, A.MEASURE_NAME, A.MEASURE_ID, A.CATEGORY_ORDER ' + char(10)
            SELECT @v_dSql4 += '   ) A                   ' + char(10)

            SELECT @v_dSql4 += '   LEFT OUTER JOIN (     ' + char(10)
            SELECT @v_dSql4 += '          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID          ' + char(10)
            SELECT @v_dSql4 += '             ,(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
            SELECT @v_dSql4 += '               WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
            SELECT @v_dSql4 += '               ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
            SELECT @v_dSql4 += '             ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql4 += '          FROM	 SCM_ITEM_M A WITH(NOLOCK),          ' + char(10)
            SELECT @v_dSql4 += '            		 SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql4 += '          WHERE	 A.ITEM_CLASS  = C.CLASS_ID          ' + char(10)
			SELECT @v_dSql4 += '          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql4 += '          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql4 += '          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt)) + char(10)
            SELECT @v_dSql4 += '   ) BB                                              ' + char(10)

			SELECT @v_dSql5  = ''
            SELECT @v_dSql5 += '   ON     A.COMPANY_ID     = BB.COMPANY_ID                  ' + char(10)
            SELECT @v_dSql5 += '   AND    A.DIVISION_ID    = BB.DIVISION_ID                 ' + char(10)
            SELECT @v_dSql5 += '   AND    A.SITE_ID        = BB.SITE_ID                     ' + char(10)
            SELECT @v_dSql5 += '   AND    A.TOP_ITEM_ID    = BB.ITEM_ID                     ' + char(10)
            SELECT @v_dSql5 += '   LEFT OUTER JOIN SCM_LINE_M CC WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql5 += '   ON     A.COMPANY_ID     = CC.COMPANY_ID                  ' + char(10)
            SELECT @v_dSql5 += '   AND    A.DIVISION_ID    = CC.DIVISION_ID                 ' + char(10)
            SELECT @v_dSql5 += '   AND    A.SITE_ID        = CC.SITE_ID                     ' + char(10)
            SELECT @v_dSql5 += '   AND    A.PLANT_ID       = CC.PLANT_ID                    ' + char(10)
            SELECT @v_dSql5 += '   AND    A.FACTORY_ID     = CC.FACTORY_ID                  ' + char(10)
            SELECT @v_dSql5 += '   AND    A.OPERATION_ID   = CC.OPERATION_ID                ' + char(10)
            SELECT @v_dSql5 += '   AND    A.LINE_ID        = CC.LINE_ID                     ' + char(10)
            SELECT @v_dSql5 += '   AND    A.ELECTRODE_TYPE = CC.ELECTRODE_TYPE              ' + char(10)
            SELECT @v_dSql5 += '   LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql5 += '   ON  A.COMPANY_ID  = B.COMPANY_ID                         ' + char(10)
            SELECT @v_dSql5 += '   AND A.DIVISION_ID = B.DIVISION_ID                        ' + char(10)
            SELECT @v_dSql5 += '   AND A.SITE_ID     = B.SITE_ID                            ' + char(10)
            SELECT @v_dSql5 += '   AND A.ITEM_ID     = B.ITEM_ID                            ' + char(10)
            SELECT @v_dSql5 += '   LEFT OUTER JOIN T_MEMO C WITH(NOLOCK)                    ' + char(10)
            SELECT @v_dSql5 += '   ON  A.COMPANY_ID      = C.COMPANY_ID                     ' + char(10)
            SELECT @v_dSql5 += '   AND A.DIVISION_ID     = C.DIVISION_ID                    ' + char(10)
            SELECT @v_dSql5 += '   AND A.SITE_ID         = C.SITE_ID                        ' + char(10)
            SELECT @v_dSql5 += '   AND A.PLANT_ID        = C.PLANT_ID                       ' + char(10)
            SELECT @v_dSql5 += '   AND A.FACTORY_ID      = C.FACTORY_ID                     ' + char(10)
            SELECT @v_dSql5 += '   AND A.OPERATION_ID    = C.OPERATION_ID                   ' + char(10)
            SELECT @v_dSql5 += '   AND A.LINE_ID         = C.LINE_ID                        ' + char(10)
            SELECT @v_dSql5 += '   AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE                 ' + char(10)
            SELECT @v_dSql5 += '   AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE                ' + char(10)
            SELECT @v_dSql5 += '   AND A.MARKET          = C.MARKET                         ' + char(10)
            SELECT @v_dSql5 += '   AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID                    ' + char(10)
            SELECT @v_dSql5 += '   AND A.ITEM_ID         = C.ITEM_ID                        ' + char(10)
            SELECT @v_dSql5 += '   LEFT OUTER JOIN (                                        ' + char(10)
            SELECT @v_dSql5 += '       SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID           ' + char(10)
			SELECT @v_dSql5 += '          , A.ATTRIBUTE2 AS PRODUCTION_TYPE                 ' + char(10)
            SELECT @v_dSql5 += '       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
            SELECT @v_dSql5 += '       WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
            SELECT @v_dSql5 += '       AND    A.ACTIVE_FLAG = ''Y''                         ' + char(10)

            IF(@p_instance_id = 'KR_CELL') 
			    BEGIN
                    SELECT @v_dSql5 += '       UNION ALL                                    ' + char(10)
                    SELECT @v_dSql5 += '       SELECT DISTINCT A.DIVISION_ID, ''M/C'' AS PRODUCTION_TYPE ' + char(10)
                    SELECT @v_dSql5 += '       FROM SCM_FACTORY_M A(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK) ' + char(10)
                    SELECT @v_dSql5 += '       ON   A.FACTORY_ID=B.FACTORY_ID   ' + char(10)
                    SELECT @v_dSql5 += '       AND  B.ACTIVE_FLAG = ''Y''       ' + char(10)
                    SELECT @v_dSql5 += '       WHERE 1=1                        ' + char(10)
                    SELECT @v_dSql5 += '       AND  A.ACTIVE_FLAG = ''Y''       ' + char(10)
                    SELECT @v_dSql5 += '       AND  B.INSTANCE_ID = ''KR_CELL'' ' + char(10)
                END
            SELECT @v_dSql5 += '   ) D                                          ' + char(10)
            SELECT @v_dSql5 += '   ON A.DIVISION_ID      = D.DIVISION_ID        ' + char(10)
            SELECT @v_dSql5 += '   AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE    ' + char(10)
            SELECT @v_dSql5 += '   AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE  ' + char(10)
			/*
			-- 타겟체크 제거... 20231115
            SELECT @v_dSql5 += '   LEFT OUTER JOIN (       ' + char(10)
            SELECT @v_dSql5 += '       SELECT DISTINCT H.* ' + char(10)
            SELECT @v_dSql5 += '       FROM (              ' + char(10)
            SELECT @v_dSql5 += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MARKET    ' + char(10)
			SELECT @v_dSql5 += '               , A.ITEM_ID, (CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST'' ' + char(10)
			SELECT @v_dSql5 += '                     ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE                 ' + char(10)
            SELECT @v_dSql5 += '             FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                       ' + char(10)
            SELECT @v_dSql5 += '             WHERE  1=1                                                             ' + char(10)
			SELECT @v_dSql5 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql5 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql5 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql5 += '             AND  EXISTS (          ' + char(10)
            SELECT @v_dSql5 += '                         SELECT 1  ' + char(10)
            SELECT @v_dSql5 += '                         FROM (    ' + char(10)
            SELECT @v_dSql5 += '                               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID        ' + char(10)
			SELECT @v_dSql5 += '                                 , A.SHOP_GROUP_ID, MAX(SCP_PLAN_ID) AS SCP_PLAN_ID ' + char(10)
            SELECT @v_dSql5 += '                               FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql5 += '                               WHERE 1=1                                            ' + char(10)
			SELECT @v_dSql5 += '                               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql5 += '                               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql5 += '                               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql5 += '                               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql5 += '                             ) AA                               ' + char(10)
            SELECT @v_dSql5 += '                         WHERE 1=1                              ' + char(10)
            SELECT @v_dSql5 += '                         AND A.COMPANY_ID = AA.COMPANY_ID       ' + char(10)
            SELECT @v_dSql5 += '                         AND A.DIVISION_ID = AA.DIVISION_ID     ' + char(10)
            SELECT @v_dSql5 += '                         AND A.SITE_ID = AA.SITE_ID             ' + char(10)
            SELECT @v_dSql5 += '                         AND A.SHOP_GROUP_ID = AA.SHOP_GROUP_ID ' + char(10)
            SELECT @v_dSql5 += '                     )                                          ' + char(10)
            SELECT @v_dSql5 += '             UNION                                              ' + char(10)
            SELECT @v_dSql5 += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' + char(10)
			SELECT @v_dSql5 += '             , ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID, A.PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql5 += '             FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)            ' + char(10)
            SELECT @v_dSql5 += '             WHERE  1=1                                                       ' + char(10)
			SELECT @v_dSql5 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
            SELECT @v_dSql5 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
            SELECT @v_dSql5 += '             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
            SELECT @v_dSql5 += '			 AND  A.DUE_DATE >= (SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) ' + char(10)
            SELECT @v_dSql5 += '								 FROM   SCM_FP_PLAN_H                    ' + char(10)
            SELECT @v_dSql5 += '								 WHERE  PLAN_ID = '''+ @p_plan_id +''' ) ' + char(10)
            SELECT @v_dSql5 += '				      ) H                                                ' + char(10)
            SELECT @v_dSql5 += ' ) H                                                         ' + char(10)
            SELECT @v_dSql5 += ' ON  A.COMPANY_ID  = H.COMPANY_ID                            ' + char(10)
            SELECT @v_dSql5 += ' AND A.DIVISION_ID = H.DIVISION_ID                           ' + char(10)
            SELECT @v_dSql5 += ' AND A.SITE_ID     = H.SITE_ID                               ' + char(10)
            SELECT @v_dSql5 += ' AND A.PLANT_ID    = H.PLANT_ID                              ' + char(10)
            SELECT @v_dSql5 += ' AND A.MARKET      = H.MARKET                                ' + char(10)
            SELECT @v_dSql5 += ' AND A.TOP_ITEM_ID = H.ITEM_ID                               ' + char(10)
            SELECT @v_dSql5 += ' AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE                   ' + char(10)
			*/
            SELECT @v_dSql5 += ' LEFT OUTER JOIN (                                           ' + char(10)
            SELECT @v_dSql5 += '     SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID  ' + char(10)
			SELECT @v_dSql5 += '       , R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
            SELECT @v_dSql5 += '     FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql5 += '     WHERE	1=1                                              ' + char(10)
            SELECT @v_dSql5 += '     AND		R.USER_ID	= '''+ @p_user_id +'''           ' + char(10)
            SELECT @v_dSql5 += '     AND		R.SAVE_FLAG	= ''Y''                          ' + char(10)
            SELECT @v_dSql5 += '     AND     R.INSTANCE_ID  = '''+ @p_instance_id +'''       ' + char(10)
            SELECT @v_dSql5 += ' ) R                                    ' + char(10)
            SELECT @v_dSql5 += ' ON    1=1                              ' + char(10)
            SELECT @v_dSql5 += ' AND   A.COMPANY_ID    = R.COMPANY_ID   ' + char(10)
            SELECT @v_dSql5 += ' AND   A.DIVISION_ID   = R.DIVISION_ID  ' + char(10)
            SELECT @v_dSql5 += ' AND   A.SITE_ID	   = R.SITE_ID      ' + char(10)
            SELECT @v_dSql5 += ' AND   A.PLANT_ID	   = R.PLANT_ID     ' + char(10)
            SELECT @v_dSql5 += ' AND   A.FACTORY_ID    = R.FACTORY_ID   ' + char(10)
            SELECT @v_dSql5 += ' AND   A.OPERATION_ID  = R.OPERATION_ID ' + char(10)
            SELECT @v_dSql5 += ' AND   A.LINE_ID       = R.LINE_ID	    ' + char(10)
            SELECT @v_dSql5 += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                                  ' + char(10)
            SELECT @v_dSql5 += '    , A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.LOCATION                             ' + char(10)
            SELECT @v_dSql5 += '    , (CASE WHEN A.TOP_ITEM_ID IS NOT NULL THEN A.TOP_ITEM_ID ELSE ''ZZZZZ'' END) ' + char(10)
            SELECT @v_dSql5 += '    , A.OPERATION_ID DESC, A.EQUIPMENT_ID, A.ITEM_ID, A.PRODUCTION_TYPE           ' + char(10)
            SELECT @v_dSql5 += '    , A.MARKET, A.ELECTRODE_TYPE, A.CATEGORY_ORDER                                ' + char(10)

--2023.12.30 천승호
			SELECT @v_pSql  += ' OPTION (MAXDOP 1) ;; ' + char(10)


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
	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,@v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,@v_delimiter, @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,@v_delimiter, @mst_loop_cnt)
                        , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,@v_delimiter, @mst_loop_cnt)
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

