

/*
 * Program ID   : PR_UI_FP00607_AMEND_MODEL
 * Description  :Amend Model Formation
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/15   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00607_AMEND_MODEL]
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
  @p_cell_group                 NVARCHAR(MAX),
  @p_cell_group_code            NVARCHAR(MAX),
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
	DECLARE @v_plan_type                  NVARCHAR(MAX)
    DECLARE @v_prod_type                  NVARCHAR(MAX)
    DECLARE @v_item_id                    NVARCHAR(MAX)
    DECLARE @v_nick_name                  NVARCHAR(MAX)
    DECLARE @v_cell_group                 NVARCHAR(MAX)
	DECLARE @v_cell_group_code            NVARCHAR(MAX)
    DECLARE @v_bucket_from_date           NVARCHAR(MAX)
    DECLARE @v_bucket_to_date             NVARCHAR(MAX)
    DECLARE @v_day_info                   NVARCHAR(MAX)
    DECLARE @v_week_info                  NVARCHAR(MAX)
    DECLARE @v_month_info                 NVARCHAR(MAX)
    DECLARE @v_cate_info                  NVARCHAR(MAX)
	DECLARE @v_cate_value                 NVARCHAR(MAX)
    DECLARE @v_cate_type                  NVARCHAR(MAX)
    DECLARE @v_amend_table                NVARCHAR(100) = 'FP_AMEND_PLAN_FORM_R'
    DECLARE @v_amend_cutoff_boh_table     NVARCHAR(100) = 'FP_AMEND_CUTOFF_BOH_R'
    DECLARE @v_amend_bor_table            NVARCHAR(100) = 'FP_AMEND_PLAN_FORM_BOR_R'
    DECLARE @v_amend_sales_table          NVARCHAR(100) = 'FP_AMEND_PLAN_FORM_SALES_R'
    DECLARE @v_amend_util_table           NVARCHAR(100) = 'FP_AMEND_PLAN_FORM_UTIL_R'

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00607_AMEND_MODEL'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0
	DECLARE @max_day_loop_cnt	integer = 0;
	DECLARE @max_week_loop_cnt	integer = 0;
	DECLARE @max_month_loop_cnt	integer = 0;
	DECLARE @v_row_delimiter	NVARCHAR(2);

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
    DECLARE @sSql                   NVARCHAR(MAX)=''
    DECLARE @iSql                   NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''
	DECLARE @v_tmp3                 NVARCHAR(MAX)=''

    DECLARE @bAct                   NVARCHAR(2)= ''
    DECLARE @bActSim                NVARCHAR(2)= ''
    DECLARE @bWipAd                 NVARCHAR(2)= ''
    DECLARE @bWipSimAd              NVARCHAR(2)= ''
    DECLARE @bWip                   NVARCHAR(2)= ''
    DECLARE @bWipSim                NVARCHAR(2)= ''
    DECLARE @bWipBd                 NVARCHAR(2)= ''
    DECLARE @bWipSimBd              NVARCHAR(2)= ''
    DECLARE @bCalAgingQty           NVARCHAR(2)= ''
    DECLARE @bCarryOver             NVARCHAR(2)= ''
    DECLARE @bCellBiz               NVARCHAR(2)= ''
    DECLARE @bInventory             NVARCHAR(2)= ''
    DECLARE @bPkgProcDate           NVARCHAR(2)= ''
    DECLARE @bPkgQty                NVARCHAR(2)= ''
    DECLARE @bPackSemi              NVARCHAR(2)= ''
    DECLARE @bInQty                 NVARCHAR(2)= ''
    DECLARE @bOutQty                NVARCHAR(2)= ''
    DECLARE @bResult                NVARCHAR(2)= ''
    DECLARE @bTarget                NVARCHAR(2)= ''
    DECLARE @bYield                 NVARCHAR(2)= ''
    DECLARE @bTotal                 NVARCHAR(2)= ''
    DECLARE @bSubTotal              NVARCHAR(2)= ''
    DECLARE @bShipResult            NVARCHAR(2)= ''
    DECLARE @bMppInQty              NVARCHAR(2)= ''
    DECLARE @bMppOutQty             NVARCHAR(2)= ''
    DECLARE @bWppInQty              NVARCHAR(2)= ''
    DECLARE @bWppOutQty             NVARCHAR(2)= ''
    DECLARE @bPastSales             NVARCHAR(2)= ''
    DECLARE @bShipPlanPlanner       NVARCHAR(2)= ''
    DECLARE @bInv_simul             NVARCHAR(2)= ''


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
    SET @v_item_id                  = ''
    SET @v_nick_name                = ''
    SET @v_cell_group               = ''
	SET @v_cell_group_code          = ''
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
	SET @v_row_delimiter	= '!';

	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  
	
	SET @max_day_loop_cnt		= [dbo].[SCM_ARR_SPL_CNT](@p_day_info	, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_week_loop_cnt		= [dbo].[SCM_ARR_SPL_CNT](@p_week_info	, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	SET @max_month_loop_cnt		= [dbo].[SCM_ARR_SPL_CNT](@p_month_info , @v_delimiter) -- 프로시저 LOOP 길이를 판단

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

	SET	@pSql                 = ''
	SET	@sSql                 = ''
	SET	@iSql                 = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''

	--DECLARE @bMemo  NVARCHAR(2)= 'Y'

	/*	Parameter Setting End */

DECLARE @PARAMS NVARCHAR(MAX)
--SET @PARAMS = @max_month_loop_cnt
--SELECT @PARAMS AS SQL
--RETURN

--SET @params += '@p_sys_type		: ' + ISNULL(@p_sys_type              , '') + char(10)         
--SET @params += '@p_sys_flag      : ' + ISNULL(@p_sys_flag              , '') + char(10)        
--SET @params += '@p_sys_gubun     : ' + ISNULL(@p_sys_gubun             , '') + char(10)        
--SET @params += '@p_user_id       : ' + ISNULL(@p_user_id               , '') + char(10)        
--SET @params += '@p_instance_id   : ' + ISNULL(@p_instance_id           , '') + char(10)        
--SET @params += '@p_company_id    : ' + ISNULL(@p_company_id            , '') + char(10)        
--SET @params += '@p_division_id   : ' + ISNULL(@p_division_id           , '') + char(10)        
--SET @params += '@p_site_id       : ' + ISNULL(@p_site_id               , '') + char(10)        
--SET @params += '@p_plant_id      : ' + ISNULL(@p_plant_id              , '') + char(10)        
--SET @params += '@p_factory_id    : ' + ISNULL(@p_factory_id            , '') + char(10)        
--SET @params += '@p_line_id       : ' + ISNULL(@p_line_id               , '') + char(10)        
--SET @params += '@p_operation_id  : ' + ISNULL(@p_operation_id          , '') + char(10)        
--SET @params += '@p_master_id     : ' + ISNULL(@p_master_id             , '') + char(10)        
--SET @params += '@p_plan_date     : ' + ISNULL(@p_plan_date             , '') + char(10)        
--SET @params += '@p_plan_id       : ' + ISNULL(@p_plan_id               , '') + char(10)        
--SET @params += '@p_plan_type     : ' + ISNULL(@p_plan_type             , '') + char(10)        
--SET @params += '@p_prod_type     : ' + ISNULL(@p_prod_type             , '') + char(10)        
--SET @params += '@p_item_id       : ' + ISNULL(@p_item_id               , '') + char(10)        
--SET @params += '@p_nick_name     : ' + ISNULL(@p_nick_name             , '') + char(10)        
--SET @params += '@p_nick_name_lt  : ' + ISNULL(@p_nick_name_lt          , '') + char(10)        
--SET @params += '@p_cell_group    : ' + ISNULL(@p_cell_group            , '') + char(10)        
--SET @params += '@p_cell_group_code : ' + ISNULL(@p_cell_group_code       , '') + char(10)       
--SET @params += '@p_bucket_from   : ' + ISNULL(@p_bucket_from           , '') + char(10)        
--SET @params += '@p_bucket_to     : ' + ISNULL(@p_bucket_to             , '') + char(10)        
--SET @params += '@p_day_info      : ' + ISNULL(@p_day_info              , '') + char(10)        
--SET @params += '@p_week_info     : ' + ISNULL(@p_week_info             , '') + char(10)        
--SET @params += '@p_month_info    : ' + ISNULL(@p_month_info            , '') + char(10)        
--SET @params += '@p_cate_info     : ' + ISNULL(@p_cate_info             , '') + char(10)        
--SET @params += '@p_cate_value    : ' + ISNULL(@p_cate_value            , '') + char(10)        
--SET @params += '@p_cate_type     : ' + ISNULL(@p_cate_type             , '') + char(10)        
--SET @params += '@p_amend_table   : ' + ISNULL(@p_amend_table           , '') + char(10)        
--SET @params += '@p_amend_cutoff_boh_table : ' + ISNULL(@p_amend_cutoff_boh_table, '') + char(10)
--SET @params += '@p_amend_bor_table : ' + ISNULL(@p_amend_bor_table       , '') + char(10)      
--SET @params += '@p_amend_sales_table : ' + ISNULL(@p_amend_sales_table     , '') + char(10)     
--SET @params += '@p_amend_util_table : ' + ISNULL(@p_amend_util_table      , '') + char(10)      
--SELECT @PARAMS AS SQL
--RETURN

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
		
		---------------------------------------------
		----뷰를 임시 테이블로 생성
		if object_id('tempdb..#FP_CELL_GROUP_V') is not null
			drop table #FP_CELL_GROUP_V

		select distinct   
			COMPANY_ID              
			,DIVISION_ID             
			,SITE_ID                 
			,ITEM_ID
			,CELL_GROUP
		into #FP_CELL_GROUP_V
		from FP_CELL_GROUP_V WITH(NOLOCK) 
		WHERE 1=1 
		AND  SITE_ID = @p_site_id
		---------------------------------------------


		---------------------------------------------
		--뷰를 임시 테이블로 생성
		if object_id('tempdb..#TH_UIS_CAL') is not null
			drop table #TH_UIS_CAL

		select    
			DT            
			,YYYYMMDD
			,YYYYMM
			,ISO_YYYYWW 
		into #TH_UIS_CAL
		from TH_UIS_CAL WITH(NOLOCK) 
		WHERE 1=1 
			AND YYYYMMDD BETWEEN   @p_bucket_from AND  @p_bucket_to
		---------------------------------------------


			SELECT @pSql = ''
			SELECT @sSql = ''
			SELECT @iSql = ''
						            
            IF(LEN(@p_cate_info) > 0) 
                BEGIN --(IF)
                    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    
                    WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
                            SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_delimiter, @mst_loop_cnt)
                            
                            IF( @v_cate_info = 'chk_act'             AND @v_cate_value = 'TRUE' )  SELECT @bAct =  'Y'
                            IF( @v_cate_info = 'chk_actSim'          AND @v_cate_value = 'TRUE' )  SELECT @bActSim =  'Y'
                            IF( @v_cate_info = 'chk_wipAD'           AND @v_cate_value = 'TRUE' )  SELECT @bWipAd =  'Y'
                            IF( @v_cate_info = 'chk_wipSimAD'        AND @v_cate_value = 'TRUE' )  SELECT @bWipSimAd =  'Y'
                            IF( @v_cate_info = 'chk_wip'             AND @v_cate_value = 'TRUE' )  SELECT @bWip =  'Y'
                            IF( @v_cate_info = 'chk_wipSim'          AND @v_cate_value = 'TRUE' )  SELECT @bWipSim =  'Y'
                            IF( @v_cate_info = 'chk_wipBD'           AND @v_cate_value = 'TRUE' )  SELECT @bWipBd =  'Y'
                            IF( @v_cate_info = 'chk_wipSimBD'        AND @v_cate_value = 'TRUE' )  SELECT @bWipSimBd =  'Y'
                            IF( @v_cate_info = 'chk_calAgingQty'     AND @v_cate_value = 'TRUE' )  SELECT @bCalAgingQty =  'Y' 
                            IF( @v_cate_info = 'chk_carryOver'       AND @v_cate_value = 'TRUE' )  SELECT @bCarryOver =  'Y'
                            IF( @v_cate_info = 'chk_cellBiz'         AND @v_cate_value = 'TRUE' )  SELECT @bCellBiz =  'Y'
                            IF( @v_cate_info = 'chk_inventory'       AND @v_cate_value = 'TRUE' )  SELECT @bInventory =  'Y'
                            IF( @v_cate_info = 'chk_pkgProcDate'     AND @v_cate_value = 'TRUE' )  SELECT @bPkgProcDate =  'Y'
                            IF( @v_cate_info = 'chk_pkgQty'          AND @v_cate_value = 'TRUE' )  SELECT @bPkgQty =  'Y'
                            IF( @v_cate_info = 'chk_packSemi'        AND @v_cate_value = 'TRUE' )  SELECT @bPackSemi =  'Y'
                            IF( @v_cate_info = 'chk_inqty'           AND @v_cate_value = 'TRUE' )  SELECT @bInQty =  'Y' 
                            IF( @v_cate_info = 'chk_outqty'          AND @v_cate_value = 'TRUE' )  SELECT @bOutQty =  'Y'
                            IF( @v_cate_info = 'chk_result'          AND @v_cate_value = 'TRUE' )  SELECT @bResult =  'Y'
                            IF( @v_cate_info = 'chk_shipResult'      AND @v_cate_value = 'TRUE' )  SELECT @bShipResult =  'Y'
                            IF( @v_cate_info = 'chk_target'          AND @v_cate_value = 'TRUE' )  SELECT @bTarget =  'Y'
                            IF( @v_cate_info = 'chk_yield'           AND @v_cate_value = 'TRUE' )  SELECT @bYield =  'Y' 
                            IF( @v_cate_info = 'chk_past_sales'      AND @v_cate_value = 'TRUE' )  SELECT @bPastSales =  'Y'
                            IF( @v_cate_info = 'chk_mpp_inqty'       AND @v_cate_value = 'TRUE' )  SELECT @bMppInQty =  'Y'
                            IF( @v_cate_info = 'chk_mpp_outqty'      AND @v_cate_value = 'TRUE' )  SELECT @bMppOutQty =  'Y'
                            IF( @v_cate_info = 'chk_wpp_inqty'       AND @v_cate_value = 'TRUE' )  SELECT @bWppInQty =  'Y'
                            IF( @v_cate_info = 'chk_wpp_outqty'      AND @v_cate_value = 'TRUE' )  SELECT @bWppOutQty =  'Y'
                            IF( @v_cate_info = 'chk_shipPlanPlanner' AND @v_cate_value = 'TRUE' )  SELECT @bShipPlanPlanner =  'Y'
                            IF( @v_cate_info = 'chk_inventory_simul' AND @v_cate_value = 'TRUE' )  SELECT @bInv_simul =  'Y'
                            IF( @v_cate_info = 'chk_total_2'         AND @v_cate_value = 'TRUE' )  SELECT @bTotal =  'Y'
                            IF( @v_cate_info = 'chk_total'           AND @v_cate_value = 'TRUE' )  SELECT @bSubTotal =  'Y'
                        END
            	
                    SELECT @pSql = '              	        SELECT 0 AS CATE_ORDER, '''' AS CATE_NAME, ''X'' AS CATE_ID ' + char(10)
                
                	IF( @bWip = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                              
                            SELECT @pSql +=	'              	        SELECT 15 AS CATE_ORDER, ''Aging WIP'' AS CATE_NAME, ''P_WIP'' AS CATE_ID ' + char(10)                 
                	    END
                	IF( @bWipBd = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                             
                            SELECT @pSql +=	'              	        SELECT 20 AS CATE_ORDER, ''    Before Degas'' AS CATE_NAME, ''P_WIP_BD'' AS CATE_ID ' + char(10)       
                	    END
                	IF( @bWipAd = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                             
                            SELECT @pSql +=	'              	        SELECT 30 AS CATE_ORDER, ''    After Degas'' AS CATE_NAME, ''P_WIP_AD'' AS CATE_ID ' + char(10)        
                	    END
                	IF( @bAct = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                             
                            SELECT @pSql +=	'              	        SELECT 40 AS CATE_ORDER, ''Activated Cell'' AS CATE_NAME, ''P_ACT'' AS CATE_ID ' + char(10)            
                	    END
                	IF( @bCalAgingQty = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                             
                            SELECT @pSql +=	'              	        SELECT 50 AS CATE_ORDER, ''Activated(PKG Cal.)'' AS CATE_NAME, ''P_CALAGING'' AS CATE_ID ' + char(10)  
                	    END
                	IF( @bWipSim = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                                     
                            SELECT @pSql +=	'              	        SELECT 60 AS CATE_ORDER, ''Aging WIP(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM'' AS CATE_ID ' + char(10)    
                	    END
                	IF( @bWipSimBd = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                                     
                            SELECT @pSql +=	'              	        SELECT 70 AS CATE_ORDER, ''    Before Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_BD'' AS CATE_ID ' + char(10) 
                	    END
                	IF( @bWipSimAd = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	        SELECT 80 AS CATE_ORDER, ''    After Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_AD'' AS CATE_ID ' + char(10) 
                	    END
                	IF( @bPkgProcDate = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	        SELECT 90 AS CATE_ORDER, ''PKG Date(Changed L/T)'' AS CATE_NAME, ''P_PKGPLANDATE'' AS CATE_ID ' + char(10)           
                	    END
                	IF( @bPkgQty = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	        SELECT 95 AS CATE_ORDER, ''PKG Result & Plan(Changed L/T)'' AS CATE_NAME, ''P_PKGQTY'' AS CATE_ID ' + char(10)       
                	    END
                	IF( @bActSim = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	        SELECT 98 AS CATE_ORDER, ''Activated Cell(Changed L/T)'' AS CATE_NAME, ''P_ACTSIM'' AS CATE_ID ' + char(10)          
                	    END
                    IF( @bMppInQty = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                         
                            SELECT @pSql +=	'              	        SELECT 100 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''P_MPP_IN'' AS CATE_ID ' + char(10)								
                        END
                    IF( @bMppOutQty = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	        SELECT 105 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''P_MPP_OUT'' AS CATE_ID ' + char(10)   
                        END		
                    IF( @bWppInQty = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                               
                            SELECT @pSql +=	'              	        SELECT 108 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''P_WPP_IN'' AS CATE_ID ' + char(10)								
                        END
                    IF( @bWppOutQty = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	        SELECT 110 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''P_WPP_OUT'' AS CATE_ID ' + char(10)   
                        END
                    IF( @bInQty = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                               
                            SELECT @pSql +=	'              	        SELECT 112 AS CATE_ORDER, ''In'' AS CATE_NAME, ''P_IN'' AS CATE_ID ' + char(10)								
                        END
                    IF( @bYield = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	        SELECT 114 AS CATE_ORDER, ''Yield'' AS CATE_NAME, ''P_YIELD'' AS CATE_ID ' + char(10)        
                	    END
                	IF( @bOutQty = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	        SELECT 116 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT'' AS CATE_ID ' + char(10)            
                	    END
                	IF( @bResult = 'Y' ) 
					    BEGIN
                            SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	        SELECT 118 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID ' + char(10)      
                	    END
					--if(@bMemo = 'Y')
					--BEGIN
                    SELECT @pSql +=	'              	        UNION ALL ' + char(10)                                                                   
                    SELECT @pSql +=	'              	        SELECT 1000 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID ' + char(10)      
                	--END
					
                	
                	--main_s
                	SELECT @sSql = '              	        SELECT 0 AS CATE_ORDER, '''' AS CATE_NAME, ''X'' AS CATE_ID ' + char(10)
                	
                	IF( @bTarget = 'Y' ) 
					    BEGIN
                            SELECT @sSql += '              	        UNION ALL ' + char(10)                                                                
                            SELECT @sSql += '              	        SELECT 5 AS CATE_ORDER, ''Target'' AS CATE_NAME, ''S_NET'' AS CATE_ID ' + char(10)			
                	    END
                	IF( @bCellBiz = 'Y' ) 
					    BEGIN
                            SELECT @sSql += '              	        UNION ALL ' + char(10)                                                                
                            SELECT @sSql += '              	        SELECT 6 AS CATE_ORDER, ''    Cell Biz'' AS CATE_NAME, ''S_CELL'' AS CATE_ID ' + char(10) 
                	    END
                	IF( @bPackSemi = 'Y' ) 
					    BEGIN
                            SELECT @sSql += '              	        UNION ALL ' + char(10)
                            SELECT @sSql += '              	        SELECT 7 AS CATE_ORDER, ''    Pack Semi'' AS CATE_NAME, ''S_PACK'' AS CATE_ID ' + char(10)
                	    END
                	IF( @bShipPlanPlanner = 'Y' ) 
					    BEGIN
                            SELECT @sSql += '              	        UNION ALL ' + char(10)
                            SELECT @sSql += '              	        SELECT 7.5 AS CATE_ORDER, ''Shipment Plan(Simulation)'' AS CATE_NAME, ''S_SHIP_PLAN'' AS CATE_ID ' + char(10)
                	    END
                	IF( @bCarryOver = 'Y' ) 
					    BEGIN
                            SELECT @sSql += '              	        UNION ALL ' + char(10)                                                        
                            SELECT @sSql += '              	        SELECT 8 AS CATE_ORDER, ''Carry Over'' AS CATE_NAME, ''S_CARRY'' AS CATE_ID  ' + char(10)
                	    END
                	IF( @bShipResult = 'Y' ) 
					    BEGIN
                            SELECT @sSql += '              	        UNION ALL ' + char(10)
                            SELECT @sSql += '              	        SELECT 9 AS CATE_ORDER, ''Ship Result'' AS CATE_NAME, ''S_SHIP'' AS CATE_ID  ' + char(10)
                	    END
                	IF( @bPastSales = 'Y' ) 
					    BEGIN
                            SELECT @sSql += '              	        UNION ALL ' + char(10)
                            SELECT @sSql += '              	        SELECT 4 AS CATE_ORDER, ''S(W-1)'' AS CATE_NAME, ''S_PAST_SALES'' AS CATE_ID ' + char(10)
                	    END
                	
                	--main_i
                	SELECT @iSql = '               SELECT 0 AS CATEGORY_ORDER, '''' AS CATE_NAME, ''X'' AS CATEGORY_ID ' + char(10)
                	
                	IF( @bInventory = 'Y' ) 
					    BEGIN
                	        SELECT @iSql += '               UNION ALL ' + char(10)
                	        SELECT @iSql += '               SELECT 100 AS CATEGORY_ORDER, ''EOH'' AS CATE_NAME, ''I'' AS CATEGORY_ID ' + char(10)
                	    END
                	IF( @bInv_simul = 'Y' ) 
					    BEGIN
                	        SELECT @iSql += '               UNION ALL ' + char(10)
                	        SELECT @iSql += '               SELECT 110 AS CATEGORY_ORDER, ''EOH(Shipment Plan(Simulation))'' AS CATE_NAME, ''I_SIMUL'' AS CATEGORY_ID ' + char(10)
                	    END
            	
                END --(IF)
            ELSE 
                BEGIN --(ELSE)
                	SELECT  @pSql += '              	        SELECT 15 AS CATE_ORDER, ''Aging WIP'' AS CATE_NAME, ''P_WIP'' AS CATE_ID ' + char(10)                          
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                  
                	SELECT  @pSql += '              	        SELECT 20 AS CATE_ORDER, ''    Before Degas'' AS CATE_NAME, ''P_WIP_BD'' AS CATE_ID ' + char(10)                    
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                            
                	SELECT  @pSql += '              	        SELECT 30 AS CATE_ORDER, ''    After Degas'' AS CATE_NAME, ''P_WIP_AD'' AS CATE_ID ' + char(10)                     
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                          
                	SELECT  @pSql += '              	        SELECT 40 AS CATE_ORDER, ''Activated Cell'' AS CATE_NAME, ''P_ACT'' AS CATE_ID ' + char(10)                         
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                          
                	SELECT  @pSql += '              	        SELECT 50 AS CATE_ORDER, ''Activated(PKG Cal.)'' AS CATE_NAME, ''P_CALAGING'' AS CATE_ID ' + char(10)               
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                          
                	SELECT  @pSql += '              	        SELECT 60 AS CATE_ORDER, ''Aging WIP(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM'' AS CATE_ID ' + char(10)         
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                          
                	SELECT  @pSql += '              	        SELECT 70 AS CATE_ORDER, ''    Before Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_BD'' AS CATE_ID ' + char(10)
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	        SELECT 80 AS CATE_ORDER, ''    After Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_AD'' AS CATE_ID ' + char(10) 
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	        SELECT 90 AS CATE_ORDER, ''PKG Date(Changed L/T)'' AS CATE_NAME, ''P_PKGPLANDATE'' AS CATE_ID ' + char(10)           
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	        SELECT 95 AS CATE_ORDER, ''PKG Result & Plan(Changed L/T)'' AS CATE_NAME, ''P_PKGQTY'' AS CATE_ID ' + char(10)       
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	        SELECT 98 AS CATE_ORDER, ''Activated Cell(Changed L/T)'' AS CATE_NAME, ''P_ACTSIM'' AS CATE_ID ' + char(10)          
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                  
                	SELECT  @pSql += '              	        SELECT 100 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''P_MPP_IN'' AS CATE_ID ' + char(10)							
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	        SELECT 105 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''P_MPP_OUT'' AS CATE_ID ' + char(10)  
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	        SELECT 108 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''P_WPP_IN'' AS CATE_ID ' + char(10)							
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	        SELECT 110 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''P_WPP_OUT'' AS CATE_ID ' + char(10)  
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                  
                	--SELECT  @pSql += '              	        SELECT 112 AS CATE_ORDER, ''In'' AS CATE_NAME, ''P_IN'' AS CATE_ID ' + char(10)									
                	--SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                  
                	--SELECT  @pSql += '              	        SELECT 114 AS CATE_ORDER, ''Yield'' AS CATE_NAME, ''P_YIELD'' AS CATE_ID ' + char(10)       
                	--SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	        SELECT 116 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT'' AS CATE_ID ' + char(10)           
                	SELECT  @pSql += '              	        UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	        SELECT 118 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID ' + char(10)     
					SELECT @pSql +=	'              	            UNION ALL ' + char(10)                                                                   
                    SELECT @pSql +=	'              	            SELECT 300 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID ' + char(10)      
                				    
                	SELECT  @sSql += '              	        SELECT 5 AS CATE_ORDER, ''Target'' AS CATE_NAME, ''S_NET'' AS CATE_ID ' + char(10)			
                	SELECT  @sSql += '              	        UNION ALL ' + char(10)                                                                  
                	SELECT  @sSql += '              	        SELECT 6 AS CATE_ORDER, ''    Cell Biz'' AS CATE_NAME, ''S_CELL'' AS CATE_ID ' + char(10)   
                	SELECT  @sSql += '              	        UNION ALL ' + char(10)                                                                  
                	SELECT  @sSql += '              	        SELECT 7 AS CATE_ORDER, ''    Pack Semi'' AS CATE_NAME, ''S_PACK'' AS CATE_ID ' + char(10)
                	SELECT  @sSql += '              	        UNION ALL ' + char(10)                                                                
                	SELECT  @sSql += '              	        SELECT 7.5 AS CATE_ORDER, ''Shipment Plan(Simulation)'' AS CATE_NAME, ''S_SHIP_PLAN'' AS CATE_ID ' + char(10)  
                	SELECT  @sSql += '              	        UNION ALL ' + char(10)                                                                
                	SELECT  @sSql += '              	        SELECT 8 AS CATE_ORDER, ''Carry Over'' AS CATE_NAME, ''S_CARRY'' AS CATE_ID ' + char(10)  
                	SELECT  @sSql += '              	        UNION ALL ' + char(10)                                                                
                	SELECT  @sSql += '              	        SELECT 9 AS CATE_ORDER, ''Ship Result'' AS CATE_NAME, ''S_SHIP'' AS CATE_ID ' + char(10)  
                	SELECT  @sSql += '              	        UNION ALL ' + char(10)                                                                
                	SELECT  @sSql += '              	        SELECT 4 AS CATE_ORDER, ''S(W-1)'' AS CATE_NAME, ''S_PAST_SALES'' AS CATE_ID ' + char(10) 
                            
                	SELECT  @iSql += '               SELECT 100 AS CATEGORY_ORDER, ''EOH'' AS CATE_NAME, ''I'' AS CATEGORY_ID ' + char(10)
                	SELECT  @iSql += '               UNION ALL ' + char(10)
                	SELECT  @iSql += '               SELECT 110 AS CATEGORY_ORDER, ''EOH(Shipment Plan(Simulation))'' AS CATE_NAME, ''I_SIMUL'' AS CATEGORY_ID ' + char(10)
                END--(ELSE)
			
			IF OBJECT_ID('TEMPDB..#MAIN_I') IS NOT NULL
			DROP TABLE #MAIN_I

		CREATE TABLE #MAIN_I(
			[COMPANY_ID] [nvarchar](30) NULL,
			[DIVISION_ID] [nvarchar](30) NULL,
			[SITE_ID] [nvarchar](30) NULL,
			[PLANT_ID] [nvarchar](30) NULL,
			[CELL_GROUP_CODE] [nvarchar](150) NULL,
			[CELL_GROUP] [nvarchar](50) NULL,
			[TOP_ITEM_ID] [nvarchar](150) NULL,
			[ITEM_ID] [nvarchar](150) NULL,
			[ITEM_TYPE] [nvarchar](150) NULL,
			[NICK_NAME] [nvarchar](50) NULL,
			[OPERATION_ID] [nvarchar](30) NULL,
			[BOH_QTY] [varchar](8000) NULL,
			[MARKET] [nvarchar](30) NULL,
			[PRODUCTION_TYPE] [nvarchar](30) NULL,
			[CUSTOMER_ID] [nvarchar](50) NULL,
			[PSI] [varchar](1) NOT NULL,
			[FACTORY_ID] [nvarchar](30) NULL,
			[LOCATION] [nvarchar](30) NULL,
			[LINE_ID] [nvarchar](30) NULL,
			[LINE_NAME] [nvarchar](150) NULL,
			[ELECTRODE_TYPE] [nvarchar](50) NULL,
			[AGING_LEAD_TIME] [float] NULL,
			[FORMATION_TOTAL_YIELD] [float] NULL,
			[SHORTER_LEAD_TIME] [numeric](20, 10) NULL,
			[CATE] [varchar](30) NOT NULL,
			[CATEGORY_ID] [varchar](16) NOT NULL,
			[CATEGORY_ORDER] [numeric](11, 1) NOT NULL,
			[DATA_TYPE] [varchar](7) NOT NULL,
			[S_ROW] [int] NULL,
			[BOH] [numeric](38, 10) NULL,
			[HOLD] [numeric](38, 10) NULL
		) 
			SET @v_dSql = ''

			IF(LEN(@p_day_info) > 0) BEGIN

				IF @max_loop_cnt > 0 BEGIN
					-- monthinfo
					SET @mst_loop_cnt = 0
					
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_I ADD [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_I ADD  [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1						
						EXEC SP_EXECUTESQL @v_dSql;
  					END -- end of @mst_loop_cnt < @max_loop_cnt

					-- bucket
					SET @mst_loop_cnt = 0	

					WHILE @mst_loop_cnt < @max_day_loop_cnt
					
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_I ADD  [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END -- end of @mst_loop_cnt < @max_loop_cnt
				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''ui


			--SELECT @v_dSql AS SQL
			--RETURN


			if object_id('tempdb..#MAIN_S') is not null
	drop table #MAIN_S

CREATE TABLE #MAIN_S(
	[COMPANY_ID] [nvarchar](30) NULL,
	[DIVISION_ID] [nvarchar](30) NULL,
	[SITE_ID] [nvarchar](30) NULL,
	[PLANT_ID] [nvarchar](30) NULL,
	[CELL_GROUP_CODE] [nvarchar](150) NULL,
	[CELL_GROUP] [nvarchar](50) NULL,
	[TOP_ITEM_ID] [nvarchar](150) NULL,
	[ITEM_ID] [nvarchar](150) NULL,
	[ITEM_TYPE] [nvarchar](150) NULL,
	[NICK_NAME] [nvarchar](50) NULL,
	[OPERATION_ID] [nvarchar](30) NULL,
	[BOH_QTY] [varchar](8000) NULL,
	[MARKET] [nvarchar](30) NULL,
	[PRODUCTION_TYPE] [nvarchar](30) NULL,
	[CUSTOMER_ID] [nvarchar](50) NULL,
	[PSI] [varchar](1) NOT NULL,
	[FACTORY_ID] [nvarchar](30) NULL,
	[LOCATION] [nvarchar](30) NULL,
	[LINE_ID] [nvarchar](30) NULL,
	[LINE_NAME] [nvarchar](150) NULL,
	[ELECTRODE_TYPE] [nvarchar](50) NULL,
	[AGING_LEAD_TIME] [float] NULL,
	[FORMATION_TOTAL_YIELD] [float] NULL,
	[SHORTER_LEAD_TIME] [numeric](20, 10) NULL,
	[CATE] [varchar](30) NOT NULL,
	[CATEGORY_ID] [varchar](16) NOT NULL,
	[CATEGORY_ORDER] [numeric](11, 1) NOT NULL,
	[DATA_TYPE] [varchar](7) NOT NULL,
	[S_ROW] [int] NULL,
	[BOH] [numeric](38, 10) NULL,
	[HOLD] [numeric](38, 10) NULL
) 
			
			IF(LEN(@p_day_info) > 0) BEGIN

				IF @max_loop_cnt > 0 BEGIN
					-- monthinfo
					SET @mst_loop_cnt = 0
					
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_S ADD [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_S ADD  [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1						
						EXEC SP_EXECUTESQL @v_dSql;
  					END -- end of @mst_loop_cnt < @max_loop_cnt

					-- bucket
					SET @mst_loop_cnt = 0	

					WHILE @mst_loop_cnt < @max_day_loop_cnt
					
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_S ADD  [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END -- end of @mst_loop_cnt < @max_loop_cnt
				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''ui

						
if object_id('tempdb..#MAIN_P') is not null
	drop table #MAIN_P

CREATE TABLE #MAIN_P(
	[COMPANY_ID] [nvarchar](30) NULL,
	[DIVISION_ID] [nvarchar](30) NULL,
	[SITE_ID] [nvarchar](30) NULL,
	[PLANT_ID] [nvarchar](30) NULL,
	[CELL_GROUP_CODE] [nvarchar](150) NULL,
	[CELL_GROUP] [nvarchar](50) NULL,
	[TOP_ITEM_ID] [nvarchar](150) NULL,
	[ITEM_ID] [nvarchar](150) NULL,
	[ITEM_TYPE] [nvarchar](150) NULL,
	[NICK_NAME] [nvarchar](50) NULL,
	[OPERATION_ID] [nvarchar](30) NULL,
	[BOH_QTY] [varchar](8000) NULL,
	[MARKET] [nvarchar](30) NULL,
	[PRODUCTION_TYPE] [nvarchar](30) NULL,
	[CUSTOMER_ID] [nvarchar](50) NULL,
	[PSI] [varchar](1) NOT NULL,
	[FACTORY_ID] [nvarchar](30) NULL,
	[LOCATION] [nvarchar](30) NULL,
	[LINE_ID] [nvarchar](30) NULL,
	[LINE_NAME] [nvarchar](150) NULL,
	[ELECTRODE_TYPE] [nvarchar](50) NULL,
	[AGING_LEAD_TIME] [float] NULL,
	[FORMATION_TOTAL_YIELD] [float] NULL,
	[SHORTER_LEAD_TIME] [numeric](20, 10) NULL,
	[CATE] [varchar](30) NOT NULL,
	[CATEGORY_ID] [varchar](16) NOT NULL,
	[CATEGORY_ORDER] [numeric](11, 1) NOT NULL,
	[DATA_TYPE] [varchar](7) NOT NULL,
	[S_ROW] [int] NULL,
	[BOH] [numeric](38, 10) NULL,
	[HOLD] [numeric](38, 10) NULL
) 			
			
			IF(LEN(@p_day_info) > 0) BEGIN

				IF @max_loop_cnt > 0 BEGIN
					-- monthinfo
					SET @mst_loop_cnt = 0
					
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_P ADD [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_P ADD  [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1						
						EXEC SP_EXECUTESQL @v_dSql;
  					END -- end of @mst_loop_cnt < @max_loop_cnt

					-- bucket
					SET @mst_loop_cnt = 0	

					WHILE @mst_loop_cnt < @max_day_loop_cnt
					
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_P ADD  [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END -- end of @mst_loop_cnt < @max_loop_cnt
				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''ui
			
			


			SELECT @v_dSql1 = ''
			SELECT @v_dSql1 = '------------------------------------v_dSql1-----------------------------' + char(10)
			SELECT @v_dSql1 += ' -- I : model, item, operation ' + char(10)
			--SELECT @v_dSql1 += ' WITH MAIN_I AS (              ' + char(10)
			SELECT @v_dSql1 += '     insert into #MAIN_I SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                  ' + char(10)
			SELECT @v_dSql1 += '          , A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, B.NICK_NAME ' + char(10)
			SELECT @v_dSql1 += '          , A.OPERATION_ID                                                                      ' + char(10)
			SELECT @v_dSql1 += '          , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(MAX(A.QTY),0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(MAX(A.HOLD_QTY),0) AS MONEY),1),''.00'','''') + '')'' AS BOH_QTY ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS MARKET, NULL AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS CUSTOMER_ID                     ' + char(10)
			SELECT @v_dSql1 += '          , ''I'' AS PSI                            ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS FACTORY_ID, NULL AS LOCATION    ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS AGING_LEAD_TIME       ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS FORMATION_TOTAL_YIELD ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS SHORTER_LEAD_TIME     ' + char(10)
			SELECT @v_dSql1 += '          , F.CATE_NAME AS CATE           ' + char(10)
			SELECT @v_dSql1 += '          , F.CATEGORY_ID, F.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '          , ''DATA'' AS DATA_TYPE           ' + char(10)
			SELECT @v_dSql1 += '          , NULL AS S_ROW                   ' + char(10)
			SELECT @v_dSql1 += '          , ISNULL(MAX(A.QTY),0) AS BOH, ISNULL(MAX(A.HOLD_QTY),0) AS HOLD ' + char(10)

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

			                SELECT @v_tmp1 += '          , 0 AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                             SELECT @v_tmp2 += '          , SUM(CASE WHEN A.PLAN_WEEK <= '''+ @v_week_info +''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @p_plan_date +''' AND F.CATEGORY_ID = ''I'' THEN A.EOH_QTY ' + char(10)
                             SELECT @v_tmp2 += '                            WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @p_plan_date +''' AND F.CATEGORY_ID = ''I_SIMUL'' THEN A.EOH_SIMUL_QTY ' + char(10)
                             SELECT @v_tmp2 += '                            WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)  = A.WEEK_ENDDATE AND F.CATEGORY_ID = ''I_CONST'' THEN A.SHIP_EOH ELSE 0 END) ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			                 
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                             SELECT @v_tmp3 += '          , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @v_day_info +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @p_plan_date +''' AND F.CATEGORY_ID = ''I'' THEN A.EOH_QTY ' + char(10)
                             SELECT @v_tmp3 += '                            WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @v_day_info +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @p_plan_date +''' AND F.CATEGORY_ID = ''I_SIMUL'' THEN A.EOH_SIMUL_QTY ' + char(10)
                             SELECT @v_tmp3 += '                            WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)  = '''+ @v_day_info +''' AND F.CATEGORY_ID = ''I_CONST'' THEN A.SHIP_EOH ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			                 
			             END 

				END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3
						
			SELECT @v_dSql1 += '     FROM  (                                                               ' + char(10)
			SELECT @v_dSql1 += '             SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                 , AA.CELL_GROUP_CODE, AA.TOP_ITEM_ID, AA.ITEM_ID          ' + char(10)
			SELECT @v_dSql1 += '                 , AA.OPERATION_ID                                         ' + char(10)
			SELECT @v_dSql1 += '                 , AA.CATEGORY                                             ' + char(10)
			SELECT @v_dSql1 += '                 , AA.PLAN_DATE, E.ISO_YYYYWW AS PLAN_WEEK, E.WEEK_ENDDATE ' + char(10)
			SELECT @v_dSql1 += '                 , D.QTY, D.HOLD_QTY                                       ' + char(10)
			SELECT @v_dSql1 += '                 , CASE WHEN AA.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (D.QTY - (AA.NET_QTY + CARRYOVER_QTY) + AA.OUT_QTY) ELSE (0 - (AA.NET_QTY + CARRYOVER_QTY) + AA.OUT_QTY) END AS EOH_QTY ' + char(10)
			SELECT @v_dSql1 += '                 , CASE WHEN AA.PLAN_DATE = CONVERT(DATE,'''+ @p_plan_date +''') THEN (D.QTY - (AA.SALES_SIMUL_QTY + CARRYOVER_QTY) + AA.OUT_QTY) ELSE (0 - (AA.SALES_SIMUL_QTY + CARRYOVER_QTY) + AA.OUT_QTY) END AS EOH_SIMUL_QTY ' + char(10)
			SELECT @v_dSql1 += '                 , AA.SHIP_EOH ' + char(10)
			SELECT @v_dSql1 += '              FROM (           ' + char(10)
			SELECT @v_dSql1 += '	                 SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	                       , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += '	                       , A.OPERATION_ID                                     ' + char(10)
			SELECT @v_dSql1 += '	                       , ''EOH'' AS CATEGORY                                ' + char(10)
			SELECT @v_dSql1 += '	                       , A.PLAN_DATE                                        ' + char(10)
			SELECT @v_dSql1 += '	                       , SUM(A.OUT_QTY) AS OUT_QTY                          ' + char(10)
			SELECT @v_dSql1 += '	                       , SUM(A.NET_QTY) AS NET_QTY                          ' + char(10)
			SELECT @v_dSql1 += '	                       , SUM(A.CARRYOVER_QTY) AS CARRYOVER_QTY              ' + char(10)
			SELECT @v_dSql1 += '	                       , SUM(A.SALES_SIMUL_QTY) AS SALES_SIMUL_QTY          ' + char(10)
			SELECT @v_dSql1 += '	                       , 0 AS SHIP_EOH                       ' + char(10)
			SELECT @v_dSql1 += '	                  FROM (                                     ' + char(10)
			SELECT @v_dSql1 += '		                      -- P : operation(BOD) 반영         ' + char(10)
			SELECT @v_dSql1 += '		                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID ' + char(10)
			SELECT @v_dSql1 += '		                           , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		                           , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += '		                           , A.OPERATION_ID                                     ' + char(10)
			SELECT @v_dSql1 += '		                           --, (A.PLAN_DATE+1) AS PLAN_DATE                     ' + char(10)
			SELECT @v_dSql1 += '		                           , (A.PLAN_DATE+(CASE WHEN ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) IS NULL OR ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) = 0 THEN 1 ELSE ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) END)) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '		                           --, CASE WHEN (A.PLAN_DATE+1) = ''PLAN_DATE'' THEN 0 ELSE A.OUT_QTY END AS OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '		                           , CASE WHEN (A.PLAN_DATE+(CASE WHEN ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) IS NULL OR ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) = 0 THEN 1 ELSE ISNULL(C.MOVING_TIME_DAY, B.MOVING_TIME_DAY) END)) = '''+ @p_plan_date +''' THEN 0 ELSE A.OUT_QTY END AS OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '		                           , 0 AS NET_QTY         ' + char(10)
			SELECT @v_dSql1 += '		                           , 0 AS CARRYOVER_QTY   ' + char(10)
			SELECT @v_dSql1 += '		                           , 0 AS SALES_SIMUL_QTY ' + char(10)
			SELECT @v_dSql1 += '		                      FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                              LEFT OUTER JOIN (                                                ' + char(10)
			SELECT @v_dSql1 += '                                     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, ''-'' AS ITEM_ID     ' + char(10)
			SELECT @v_dSql1 += '                                     	--, BB.BUFFER_TIME, ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') AS BUFFER_TIME_UOM                               ' + char(10)
			SELECT @v_dSql1 += '                                     	, CASE WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/1440) ' + char(10)
			SELECT @v_dSql1 += '                                     		   WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/24)   ' + char(10)
			SELECT @v_dSql1 += '                                     		   WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(BB.BUFFER_TIME,0))      ' + char(10)
			SELECT @v_dSql1 += '                                     		   END  MOVING_TIME_DAY                       ' + char(10)
			SELECT @v_dSql1 += '                                     FROM  SCM_OPERATION_MOVE_2_V A WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql1 += '                                     LEFT OUTER JOIN SCM_OPERATION_MOVE_M BB WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                                     ON    A.COMPANY_ID    = BB.COMPANY_ID        ' + char(10)
			SELECT @v_dSql1 += '                                     AND   A.DIVISION_ID   = BB.DIVISION_ID       ' + char(10)
			SELECT @v_dSql1 += '                                     AND   A.SITE_ID       = BB.SITE_ID           ' + char(10)
			SELECT @v_dSql1 += '                                     AND   A.PLANT_ID      = BB.PLANT_ID          ' + char(10)
			SELECT @v_dSql1 += '                                     AND   A.FACTORY_ID    = BB.FACTORY_ID        ' + char(10)
			SELECT @v_dSql1 += '                                     AND   A.OPERATION_ID  = BB.OPERATION_ID      ' + char(10)
			SELECT @v_dSql1 += '                                     AND   A.MODEL_TYPE    = BB.MODEL_TYPE        ' + char(10)
			SELECT @v_dSql1 += '                                     AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1       ' + char(10)
			SELECT @v_dSql1 += '                                     AND   ISNULL(BB.ACTIVE_FLAG, ''Y'')  = ''Y'' ' + char(10) 
			SELECT @v_dSql1 += '                                     WHERE 1=1                                    ' + char(10)

			SELECT @v_dSql1 += '                                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                                     AND    A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			
			SELECT @v_dSql1 += '                                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += '                                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)

			SELECT @v_dSql1 += '                                     AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)

			SELECT @v_dSql1 += '                              ) B                                    ' + char(10)
			SELECT @v_dSql1 += '                        ON     A.COMPANY_ID   = B.COMPANY_ID   ' + char(10)
			SELECT @v_dSql1 += '                        AND    A.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
			SELECT @v_dSql1 += '                        AND    A.SITE_ID      = B.SITE_ID      ' + char(10)
			SELECT @v_dSql1 += '                        AND    A.PLANT_ID     = B.PLANT_ID     ' + char(10)
			SELECT @v_dSql1 += '                        AND    A.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
			SELECT @v_dSql1 += '                        AND    A.OPERATION_ID = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                        LEFT OUTER JOIN (                      ' + char(10)
			SELECT @v_dSql1 += '                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '                                	 --, A.BUFFER_TIME, A.BUFFER_TIME_UOM ' + char(10)
			SELECT @v_dSql1 += '                                	 , CASE WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(A.BUFFER_TIME,0)/1440) ' + char(10)
			SELECT @v_dSql1 += '                                			WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(A.BUFFER_TIME,0)/24)   ' + char(10)
			SELECT @v_dSql1 += '                                			WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(A.BUFFER_TIME,0))      ' + char(10)
			SELECT @v_dSql1 += '                                			END MOVING_TIME_DAY                   ' + char(10)
			SELECT @v_dSql1 += '                                FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql1 += '                                INNER JOIN SCM_OPERATION_MOVE_2_V BB WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                                ON    A.COMPANY_ID    = BB.COMPANY_ID    ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.DIVISION_ID   = BB.DIVISION_ID   ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.SITE_ID       = BB.SITE_ID       ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.PLANT_ID      = BB.PLANT_ID      ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.FACTORY_ID    = BB.FACTORY_ID    ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.OPERATION_ID  = BB.OPERATION_ID  ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.MODEL_TYPE    = BB.MODEL_TYPE    ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1   ' + char(10)
			SELECT @v_dSql1 += '                                WHERE  1=1                               ' + char(10)

			SELECT @v_dSql1 += '                                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                                AND    A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			
			SELECT @v_dSql1 += '                                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)
			SELECT @v_dSql1 += '                                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)

			SELECT @v_dSql1 += '                                AND   A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql1 += '                                AND   A.ACTIVE_FLAG = ''Y''                 ' + char(10)
			SELECT @v_dSql1 += '                          ) C                                               ' + char(10)
			SELECT @v_dSql1 += '                          ON     A.COMPANY_ID   = C.COMPANY_ID              ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.DIVISION_ID  = C.DIVISION_ID             ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.SITE_ID      = C.SITE_ID                 ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.PLANT_ID     = C.PLANT_ID                ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.FACTORY_ID   = C.FACTORY_ID              ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.OPERATION_ID = C.OPERATION_ID            ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.ITEM_ID      = C.ITEM_ID                 ' + char(10)
			SELECT @v_dSql1 += '                          WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +'''  ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''      ' + char(10)

			SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                          AND    A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			
			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)

			

			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))       + char(10)
			
			SELECT @v_dSql1 += '                          AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql1 += '                          AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql1 += '                          AND    ( A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.OUT_QTY > 0 ) ' + char(10)

			--IF (LEN(@p_cell_group_code) > 0)
			--    BEGIN
   --                 SELECT @v_dSql1 += '                          AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--	END
			
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                          AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql1 += '                          -- S      ' + char(10)
			SELECT @v_dSql1 += '                          UNION ALL ' + char(10)
			SELECT @v_dSql1 += '                          SELECT A.INSTANCE_ID, A.FP_PLAN_ID                        ' + char(10)
			SELECT @v_dSql1 += '                               , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                               , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += '                               , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                               , A.PLAN_DATE    ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS OUT_QTY   ' + char(10)
			SELECT @v_dSql1 += '                               , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) < '''+ @p_plan_date +''' THEN 0 WHEN A.FACTORY_ID = ''-'' THEN ISNULL(A.SALES_QTY,0) ELSE 0 END AS NET_QTY ' + char(10)
			SELECT @v_dSql1 += '                               , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) < '''+ @p_plan_date +''' THEN 0 WHEN A.FACTORY_ID = ''-'' THEN ISNULL(A.CARRYOVER_QTY,0) ELSE 0 END AS CARRYOVER_QTY ' + char(10)
			SELECT @v_dSql1 += '                               , CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) < ''20201217'' THEN 0 WHEN A.FACTORY_ID = ''-'' THEN ISNULL(A.SALES_SIMUL_QTY,0) ELSE 0 END AS SALES_SIMUL_QTY ' + char(10)
			SELECT @v_dSql1 += '                          FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                          WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +'''                 ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                     ' + char(10)

			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                      AND    A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			
			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)
			IF (LEN(@p_factory_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' ( A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			        SELECT @v_dSql1 += '                            OR    A.FACTORY_ID = ''-'' ) ' + char(10)
                END
			SELECT @v_dSql1 += '                          AND    A.OPERATION_ID = '''+ @p_operation_id +'''                                                    ' + char(10)
			SELECT @v_dSql1 += '                          AND    CONVERT(VARCHAR, A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql1 += '                          AND    ( A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.OUT_QTY <> 0  OR  ISNULL(A.AVAILABILITY,0) <> 0 OR  ISNULL(A.AGING_WIP,0) <> 0  ' + char(10)
			SELECT @v_dSql1 += '                          		OR (A.FACTORY_ID = ''-'' AND  (A.SALES_QTY <> 0 OR A.CARRYOVER_QTY <> 0 OR A.SALES_SIMUL_QTY <> 0) ) ) ' + char(10)

			--IF (LEN(@p_cell_group_code) > 0)
			--    BEGIN
   --                 SELECT @v_dSql1 += '                          AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--	END
			
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                          AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END

			SELECT @v_dSql1 += '                          -- 0 VALUE ADD ' + char(10)
			SELECT @v_dSql1 += '                          UNION ALL      ' + char(10)
			SELECT @v_dSql1 += '                          -- P           ' + char(10)
			SELECT @v_dSql1 += '                          SELECT A.INSTANCE_ID, A.FP_PLAN_ID                        ' + char(10)
			SELECT @v_dSql1 += '                               , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                               , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += '                               , A.OPERATION_ID                      ' + char(10)
			SELECT @v_dSql1 += '                               , '''+ @p_plan_date +''' AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS OUT_QTY                        ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS NET_QTY                        ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS CARRYOVER_QTY                  ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS SALES_SIMUL_QTY                ' + char(10)
			SELECT @v_dSql1 += '                          FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                          WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)

			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                      AND    A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			
			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)
			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))       + char(10)

			SELECT @v_dSql1 += '                          AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
            SELECT @v_dSql1 += '                           AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +''' ' + char(10)
            SELECT @v_dSql1 += '                           AND    ( A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.OUT_QTY > 0 ) ' + char(10)
			
			--IF (LEN(@p_cell_group_code) > 0)
			--    BEGIN
   --                 SELECT @v_dSql1 += '                          AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--	END
			
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                          AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''      ' + char(10)
				END

			SELECT @v_dSql1 += '                          GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID                          ' + char(10)
			SELECT @v_dSql1 += '                                   , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                                   , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += '                                   , A.OPERATION_ID          ' + char(10)
			SELECT @v_dSql1 += '                          -- S                               ' + char(10)
			SELECT @v_dSql1 += '                          UNION ALL                          ' + char(10)
			SELECT @v_dSql1 += '                          SELECT A.INSTANCE_ID, A.FP_PLAN_ID ' + char(10)
			SELECT @v_dSql1 += '                               , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                               , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += '                               , A.OPERATION_ID                      ' + char(10)
			SELECT @v_dSql1 += '                               , '''+ @p_plan_date +''' AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS OUT_QTY                        ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS NET_QTY                        ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS CARRYOVER_QTY                  ' + char(10)
			SELECT @v_dSql1 += '                               , 0 AS SALES_SIMUL_QTY                ' + char(10)
			SELECT @v_dSql1 += '                          FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                          WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += '                          AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)

			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                      AND    A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			
			SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)
			IF (LEN(@p_factory_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' ( A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			        SELECT @v_dSql1 += '                             OR  A.FACTORY_ID  = ''-'' ) ' + char(10)
			    END
			SELECT @v_dSql1 += '                          AND    A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql1 += '                          AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql1 += '                          AND    ( A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.OUT_QTY <> 0  OR  ISNULL(A.AVAILABILITY,0) <> 0 OR  ISNULL(A.AGING_WIP,0) <> 0 OR (A.FACTORY_ID = ''-'' AND  (A.SALES_QTY <> 0 OR A.CARRYOVER_QTY <> 0 OR A.SALES_SIMUL_QTY <> 0) ) ) ' + char(10)
			
			--IF (LEN(@p_cell_group_code) > 0)
			--    BEGIN
   --                 SELECT @v_dSql1 += '                          AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' '   + char(10)
			--	END

			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                          AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' '   + char(10)
				END

			SELECT @v_dSql1 += '                          GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID                     ' + char(10)
			SELECT @v_dSql1 += '                              , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                              , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql1 += '                              , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '	                  ) A                      ' + char(10)
			SELECT @v_dSql1 += '	                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                          , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID           ' + char(10)
			SELECT @v_dSql1 += '                          , A.OPERATION_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	                  UNION ALL                         ' + char(10)
			SELECT @v_dSql1 += '                      SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                          , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID          ' + char(10)
			SELECT @v_dSql1 += '                          , A.OPERATION_ID                 ' + char(10)
			SELECT @v_dSql1 += '                          , ''Constraint EOH'' AS CATEGORY ' + char(10)
			SELECT @v_dSql1 += '                          , A.PLAN_DATE                    ' + char(10)
			SELECT @v_dSql1 += '                          , 0 AS OUT_QTY                   ' + char(10)
			SELECT @v_dSql1 += '                          , 0 AS NET_QTY                   ' + char(10)
			SELECT @v_dSql1 += '                          , 0 AS CARRYOVER_QTY             ' + char(10)
			SELECT @v_dSql1 += '                          , 0 AS SALES_SIMUL_QTY           ' + char(10)
			SELECT @v_dSql1 += '                          , SUM(A.SHIP_EOH) AS SHIP_EOH    ' + char(10)
			SELECT @v_dSql1 += '                      FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			
			SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                      AND    A.SITE_ID =  ''' + @p_site_id + ''' '   + char(10)
				END

			SELECT @v_dSql1 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)

			SELECT @v_dSql1 += '                      AND   A.OPERATION_ID = '''+ @p_operation_id +''' '   + char(10)
			SELECT @v_dSql1 += '                      AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +''' '   + char(10)
			SELECT @v_dSql1 += '                      AND   A.SHIP_EOH IS NOT NULL                     '   + char(10)

			--IF (LEN(@p_cell_group_code) > 0)
			--    BEGIN
   --                 SELECT @v_dSql1 += '                      AND    A.CELL_GROUP_CODE LIKE  ''%'' + '''+ @p_cell_group_code +''' + ''%'' '   + char(10)
			--	END

			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '                      AND    A.ITEM_ID LIKE  ''%'' + '''+ @p_item_id +''' + ''%''   '   + char(10)
				END
			
			SELECT @v_dSql1 += '                      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '                          , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID           ' + char(10)
			SELECT @v_dSql1 += '                          , A.OPERATION_ID, A.PLAN_DATE                           ' + char(10)
			SELECT @v_dSql1 += '        ) AA                    ' + char(10)
			SELECT @v_dSql1 += '         LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql1 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                     , A.ITEM_ID, A.TOP_ITEM_ID                       ' + char(10)
			SELECT @v_dSql1 += '                     , SUM(A.QTY) AS QTY, SUM(A.HOLD_QTY) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql1 += '                FROM (                                                ' + char(10)
			SELECT @v_dSql1 += '                      SELECT DISTINCT                                 ' + char(10)
			SELECT @v_dSql1 += '                             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                           , A.ITEM_ID, A.TOP_ITEM_ID, 0 AS QTY, 0 AS HOLD_QTY          ' + char(10)
			SELECT @v_dSql1 += '                      FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +'''                  ' + char(10)
			SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                      ' + char(10)
			SELECT @v_dSql1 += '                      AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql1 += '                      UNION ALL                                                                 ' + char(10)
			SELECT @v_dSql1 += '                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                           , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY, ISNULL(A.HOLD_QTY,0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql1 += '                      FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_cutoff_boh_table) +' A WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql1 += '                ) A                                                    ' + char(10)
			SELECT @v_dSql1 += '                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                    , A.ITEM_ID, A.TOP_ITEM_ID   ' + char(10)
			SELECT @v_dSql1 += '         ) D                                     ' + char(10)
			SELECT @v_dSql1 += '         ON     AA.COMPANY_ID   = D.COMPANY_ID   ' + char(10)
			SELECT @v_dSql1 += '         AND    AA.DIVISION_ID  = D.DIVISION_ID  ' + char(10)
			SELECT @v_dSql1 += '         AND    AA.SITE_ID      = D.SITE_ID      ' + char(10)
			SELECT @v_dSql1 += '         AND    AA.PLANT_ID     = D.PLANT_ID     ' + char(10)
			SELECT @v_dSql1 += '         AND    AA.OPERATION_ID = D.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '         AND    AA.ITEM_ID      = D.ITEM_ID      ' + char(10)
			SELECT @v_dSql1 += '         AND    AA.TOP_ITEM_ID  = D.TOP_ITEM_ID  ' + char(10)
			SELECT @v_dSql1 += '         INNER HASH JOIN (                       ' + char(10)
			SELECT @v_dSql1 += '                 SELECT A.DT, B.YYYYMMDD AS WEEK_ENDDATE, A.ISO_YYYYWW ' + char(10)
			SELECT @v_dSql1 += '                 FROM #TH_UIS_CAL A WITH(NOLOCK)                   ' + char(10)
			SELECT @v_dSql1 += '                 LEFT OUTER JOIN (                                ' + char(10)
			SELECT @v_dSql1 += '                     SELECT ISO_YYYYWW, MAX(YYYYMMDD) AS YYYYMMDD ' + char(10)
			SELECT @v_dSql1 += '                     FROM   #TH_UIS_CAL A WITH(NOLOCK)             ' + char(10)
			SELECT @v_dSql1 += '                     WHERE  A.YYYYMMDD BETWEEN  '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' '   + char(10)
			SELECT @v_dSql1 += '                     GROUP BY A.ISO_YYYYWW       ' + char(10)
			SELECT @v_dSql1 += '                 ) B                             ' + char(10)
			SELECT @v_dSql1 += '                 ON  A.ISO_YYYYWW = B.ISO_YYYYWW ' + char(10)
			SELECT @v_dSql1 += '                 WHERE  A.YYYYMMDD BETWEEN  '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' '   + char(10)
			SELECT @v_dSql1 += '         ) E                      ' + char(10)
			SELECT @v_dSql1 += '         ON  AA.PLAN_DATE  = E.DT ' + char(10)
			SELECT @v_dSql1 += '     ) A                          ' + char(10)
			SELECT @v_dSql1 += '     INNER JOIN (                                                   ' + char(10)
			SELECT @v_dSql1 += '            SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
			SELECT @v_dSql1 += '                   A.ITEM_ID,                                       ' + char(10)
			SELECT @v_dSql1 += '                   (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql1 += '                   	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql1 += '                   	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)

			--@dev
			--SELECT @v_dSql1 += '                   	    ''AAA''+ C.LEVEL_4_NAME + C.LEVEL_3_NAME + ''of'' + A.ITEM_ID AS ITEM_TYPE, ' + char(10)
			
			SELECT @v_dSql1 += '                   ISNULL(A.NICK_NAME,''-'') AS NICK_NAME       ' + char(10)
			SELECT @v_dSql1 += '            FROM	 SCM_ITEM_M A WITH(NOLOCK),                 ' + char(10)
			SELECT @v_dSql1 += '              		 SCM_ITEM_CLASS_M C WITH(NOLOCK)            ' + char(10)
			SELECT @v_dSql1 += '            WHERE	 A.ITEM_CLASS  = C.CLASS_ID                 ' + char(10)

			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '            AND    A.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' '   + char(10)
				END

			IF (LEN(@p_nick_name_lt) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt))    + char(10)
				END

			SELECT @v_dSql1 += '     ) B                               '   + char(10)
			SELECT @v_dSql1 += '    ON  A.COMPANY_ID  = B.COMPANY_ID   '   + char(10)
			SELECT @v_dSql1 += '    AND A.DIVISION_ID = B.DIVISION_ID  '   + char(10)
			SELECT @v_dSql1 += '    AND A.SITE_ID     = B.SITE_ID      '   + char(10)
			SELECT @v_dSql1 += '    AND A.TOP_ITEM_ID = B.ITEM_ID      '   + char(10)
			--@dev
			--SELECT @v_dSql1 += '    AND A.ITEM_ID = B.ITEM_ID      '   + char(10)
			SELECT @v_dSql1 += '    INNER JOIN (                       '   + char(10)

			SELECT @v_dSql1 += '          SELECT * FROM (              '   + char(10)

            SELECT @v_dSql1 += ' ' + @iSql  + char(10)

			SELECT @v_dSql1 += '           ) A '         + char(10)
			SELECT @v_dSql1 += '           WHERE CATEGORY_ID <> ''X'' '   + char(10)
			SELECT @v_dSql1 += '     ) F       '   + char(10)
			SELECT @v_dSql1 += '     ON    1=1 '   + char(10)
			SELECT @v_dSql1 += '     INNER HASH JOIN #FP_CELL_GROUP_V J WITH(NOLOCK) '   + char(10)
			SELECT @v_dSql1 += '     ON    A.COMPANY_ID  = J.COMPANY_ID  '   + char(10)
			SELECT @v_dSql1 += '     AND   A.DIVISION_ID = J.DIVISION_ID '   + char(10)
			SELECT @v_dSql1 += '     AND   A.SITE_ID     = J.SITE_ID     '   + char(10)
			SELECT @v_dSql1 += '     AND   A.TOP_ITEM_ID = J.ITEM_ID     '   + char(10)
			SELECT @v_dSql1 += '     WHERE 1=1                           '   + char(10)

			IF (LEN(@p_cell_group) > 0)
			    BEGIN
                    SELECT @v_dSql1 += '    AND    J.CELL_GROUP LIKE ''%'' + '''+ @p_cell_group +''' + ''%'' '   + char(10)
				END

			SELECT @v_dSql1 += '     GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '         , A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, B.NICK_NAME, A.OPERATION_ID ' + char(10)
			--@dev
			--SELECT @v_dSql1 += '         , A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, ITEM_TYPE, B.NICK_NAME, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '         , F.CATEGORY_ORDER, F.CATE_NAME, F.CATEGORY_ID ' + char(10)
			--SELECT @v_dSql1 += ' ) ' + char(10)

			SELECT @v_dSql2 = ''
			SELECT @v_dSql2 = '------------------------------------v_dSql2------------------------' + char(10)
			SELECT @v_dSql2 += ' -- S : model, item, operation, market, production type, customer ' + char(10)
			
			
			
			
			
			
			
			
			--SELECT @v_dSql2 += ' , MAIN_S AS (                                                    ' + char(10)
			SELECT @v_dSql2 += '     insert into #MAIN_S SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                 ' + char(10)
			SELECT @v_dSql2 += '         , A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql2 += '         , A.OPERATION_ID                                                                      ' + char(10)
			SELECT @v_dSql2 += '         , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(MAX(D.QTY),0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(MAX(D.HOLD_QTY),0) AS MONEY),1),''.00'','''') + '')'' AS BOH_QTY ' + char(10)
			SELECT @v_dSql2 += '         , A.MARKET, A.PRODUCTION_TYPE          ' + char(10)
			SELECT @v_dSql2 += '         , A.CUSTOMER_ID                        ' + char(10)
			SELECT @v_dSql2 += '         , ''S'' AS PSI                         ' + char(10)
			SELECT @v_dSql2 += '         , NULL AS FACTORY_ID, NULL AS LOCATION ' + char(10)
			SELECT @v_dSql2 += '         , NULL AS LINE_ID, NULL AS LINE_NAME   ' + char(10)
			SELECT @v_dSql2 += '         , NULL AS ELECTRODE_TYPE               ' + char(10)
			SELECT @v_dSql2 += '         , NULL AS AGING_LEAD_TIME              ' + char(10)
			SELECT @v_dSql2 += '         , NULL AS FORMATION_TOTAL_YIELD        ' + char(10)
			SELECT @v_dSql2 += '         , NULL AS SHORTER_LEAD_TIME            ' + char(10)
			SELECT @v_dSql2 += '         , F.CATE_NAME AS CATE                  ' + char(10)
			SELECT @v_dSql2 += '         , F.CATE_ID AS CATEGORY_ID, F.CATE_ORDER AS CATEGORY_ORDER       ' + char(10)
			SELECT @v_dSql2 += '         , ''DATA'' AS DATA_TYPE  ' + char(10)
			SELECT @v_dSql2 += '         , NULL AS S_ROW          ' + char(10)
			SELECT @v_dSql2 += '         , ISNULL(MAX(D.QTY),0) AS BOH, ISNULL(MAX(D.HOLD_QTY),0) AS HOLD ' + char(10)

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

			                SELECT @v_tmp1 += '         , SUM(CASE WHEN E.YYYYMM ='''+ @v_month_info +''' THEN (CASE WHEN F.CATE_ID=''S_NET'' THEN A.NET_QTY WHEN F.CATE_ID=''S_CELL'' THEN A.CELL_QTY WHEN F.CATE_ID=''S_PACK'' THEN A.PACK_QTY WHEN F.CATE_ID=''S_SHIP_PLAN'' THEN A.SALES_SIMUL_QTY WHEN F.CATE_ID=''S_CARRY'' THEN A.CARRYOVER_QTY WHEN F.CATE_ID=''S_PAST_SALES'' THEN A.PAST_SALES_QTY ELSE A.SHIPPING_QTY END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += '         , SUM(CASE WHEN E.ISO_YYYYWW='''+ @v_week_info +''' THEN (CASE WHEN F.CATE_ID=''S_NET'' THEN A.NET_QTY WHEN F.CATE_ID=''S_CELL'' THEN A.CELL_QTY WHEN F.CATE_ID=''S_PACK'' THEN A.PACK_QTY WHEN F.CATE_ID=''S_SHIP_PLAN'' THEN A.SALES_SIMUL_QTY WHEN F.CATE_ID=''S_CARRY'' THEN A.CARRYOVER_QTY WHEN F.CATE_ID=''S_PAST_SALES'' THEN A.PAST_SALES_QTY ELSE A.SHIPPING_QTY END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += '         , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN (CASE WHEN F.CATE_ID=''S_NET'' THEN A.NET_QTY WHEN F.CATE_ID=''S_CELL'' THEN A.CELL_QTY WHEN F.CATE_ID=''S_PACK'' THEN A.PACK_QTY WHEN F.CATE_ID=''S_SHIP_PLAN'' THEN A.SALES_SIMUL_QTY WHEN F.CATE_ID=''S_CARRY'' THEN A.CARRYOVER_QTY WHEN F.CATE_ID=''S_PAST_SALES'' THEN A.PAST_SALES_QTY ELSE A.SHIPPING_QTY END) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 

				END

            SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 + @v_tmp2 + @v_tmp3

			
			SELECT @v_dSql2 += '     FROM   (                     ' + char(10)
			SELECT @v_dSql2 += '		     -- s info   ' + char(10)
			SELECT @v_dSql2 += '		     SELECT A.INSTANCE_ID, A.FP_PLAN_ID                        ' + char(10)
			SELECT @v_dSql2 += '                 , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
			SELECT @v_dSql2 += '                 , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID         ' + char(10)
			SELECT @v_dSql2 += '                 , C.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql2 += '                 , C.ITEM_TYPE AS ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SELECT @v_dSql2 += '                 , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql2 += '                 , A.FACTORY_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql2 += '                 , NULL AS BOH_QTY             ' + char(10)
			SELECT @v_dSql2 += '                 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql2 += '                 , ''S'' AS PSI                ' + char(10)
			SELECT @v_dSql2 += '                 , A.LINE_ID                   ' + char(10)
			SELECT @v_dSql2 += '                 , A.ELECTRODE_TYPE            ' + char(10)
			SELECT @v_dSql2 += '                 , A.PLAN_DATE                 ' + char(10)
			SELECT @v_dSql2 += '                 , CASE WHEN A.FACTORY_ID = ''-'' THEN A.SALES_QTY ELSE 0 END AS NET_QTY                ' + char(10)
			SELECT @v_dSql2 += '                 , CASE WHEN A.FACTORY_ID = ''-'' THEN A.SALES_CELL_QTY ELSE 0 END AS CELL_QTY          ' + char(10)
			SELECT @v_dSql2 += '                 , CASE WHEN A.FACTORY_ID = ''-'' THEN A.SALES_PACK_QTY ELSE 0 END AS PACK_QTY          ' + char(10)
			SELECT @v_dSql2 += '                 , CASE WHEN A.FACTORY_ID = ''-'' THEN A.CARRYOVER_QTY ELSE 0 END AS CARRYOVER_QTY      ' + char(10)
			SELECT @v_dSql2 += '                 , CASE WHEN A.FACTORY_ID = ''-'' THEN A.SHIPPING_RESULT_QTY ELSE 0 END AS SHIPPING_QTY ' + char(10)
			SELECT @v_dSql2 += '                 , CASE WHEN A.FACTORY_ID = ''-'' THEN A.PAST_SALES_QTY ELSE 0 END AS PAST_SALES_QTY    ' + char(10)
			SELECT @v_dSql2 += '                 , CASE WHEN A.FACTORY_ID = ''-'' THEN A.SALES_SIMUL_QTY ELSE 0 END AS SALES_SIMUL_QTY  ' + char(10)
			SELECT @v_dSql2 += '                 , A.CUSTOMER_ID                                                 ' + char(10)
			SELECT @v_dSql2 += '		     FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK)    ' + char(10)
			SELECT @v_dSql2 += '             INNER JOIN (                                                        ' + char(10)
			SELECT @v_dSql2 += '                         SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
			SELECT @v_dSql2 += '                                A.ITEM_ID,                                       ' + char(10)
			SELECT @v_dSql2 += '                                (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql2 += '                                	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql2 += '                                	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)

			--@dev
			--SELECT @v_dSql2 += '                                	     ''KKK'' + C.LEVEL_4_NAME + C.LEVEL_3_NAME AS ITEM_TYPE, ' + char(10)

			SELECT @v_dSql2 += '                                ISNULL(A.NICK_NAME,''-'') AS NICK_NAME         ' + char(10)
			SELECT @v_dSql2 += '                         FROM   SCM_ITEM_M A WITH(NOLOCK),                     ' + char(10)
			SELECT @v_dSql2 += '                                SCM_ITEM_CLASS_M C WITH(NOLOCK)                ' + char(10)
			SELECT @v_dSql2 += '                         WHERE	 1=1                                            ' + char(10)
			SELECT @v_dSql2 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			--IF (LEN(@p_site_id) > 0)
			--    BEGIN
            --        SELECT @v_dSql2 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			--	END

			SELECT @v_dSql2 += '                         AND	A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
			
			IF (LEN(@p_nick_name_lt) > 0)
			    BEGIN
                    SELECT @v_dSql2 += '                         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt))    + char(10)
				END

			SELECT @v_dSql2 += '                      ) C                                              ' + char(10)
			SELECT @v_dSql2 += '                      ON     A.COMPANY_ID   = C.COMPANY_ID             ' + char(10)
			SELECT @v_dSql2 += '                      AND    A.DIVISION_ID  = C.DIVISION_ID            ' + char(10)
			SELECT @v_dSql2 += '                      AND    A.SITE_ID      = C.SITE_ID                ' + char(10)
			SELECT @v_dSql2 += '                      AND    A.TOP_ITEM_ID  = C.ITEM_ID                ' + char(10)
			--@dev
			--SELECT @v_dSql2 += '                      AND    A.ITEM_ID  = C.ITEM_ID                ' + char(10)
			SELECT @v_dSql2 += '                      WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += '                      AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
				END
            
			SELECT @v_dSql2 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
			IF (LEN(@p_factory_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += '                      '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('( A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			        SELECT @v_dSql2 += '                          OR  A.FACTORY_ID = ''-'' ) ' + char(10)
			    END
            SELECT @v_dSql2 += '		              AND   A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
            SELECT @v_dSql2 += '		              AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)
            SELECT @v_dSql2 += '		              AND   ( A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.OUT_QTY <> 0  OR  ISNULL(A.AVAILABILITY,0) <> 0 OR  ISNULL(A.AGING_WIP,0) <> 0  ' + char(10)
            SELECT @v_dSql2 += '		                    OR (A.FACTORY_ID = ''-'' AND (A.SALES_QTY <> 0 OR A.SALES_CELL_QTY <> 0 OR A.SALES_PACK_QTY <> 0 OR A.CARRYOVER_QTY <> 0 OR A.SHIPPING_RESULT_QTY <> 0 OR A.PAST_SALES_QTY <> 0 OR A.SALES_SIMUL_QTY <> 0) ) ) ' + char(10)
			
			--IF LEN(@p_cell_group_code) > 0 																			                
			--    BEGIN																						                
   --                 SELECT @v_dSql2 += '		              AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--    END	
				
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '		              AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	

			SELECT @v_dSql2 += '         ) A                     ' + char(10)
			SELECT @v_dSql2 += '         LEFT OUTER HASH JOIN (  ' + char(10)
			SELECT @v_dSql2 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '                    , A.ITEM_ID, A.TOP_ITEM_ID                       ' + char(10)
			SELECT @v_dSql2 += '                    , SUM(A.QTY) AS QTY, SUM(A.HOLD_QTY) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql2 += '                FROM (                                               ' + char(10)
			SELECT @v_dSql2 += '                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '                           , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY, ISNULL(A.HOLD_QTY,0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql2 += '                      FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_cutoff_boh_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '                      WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += '                      AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += '                ) A                                                    ' + char(10)
			SELECT @v_dSql2 += '                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '                     , A.ITEM_ID, A.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql2 += '         ) D                                       ' + char(10)
			SELECT @v_dSql2 += '         ON     A.COMPANY_ID   = D.COMPANY_ID      ' + char(10)
			SELECT @v_dSql2 += '         AND    A.DIVISION_ID  = D.DIVISION_ID     ' + char(10)
			SELECT @v_dSql2 += '         AND    A.SITE_ID      = D.SITE_ID         ' + char(10)
			SELECT @v_dSql2 += '         AND    A.PLANT_ID     = D.PLANT_ID        ' + char(10)
			SELECT @v_dSql2 += '         AND    A.OPERATION_ID = D.OPERATION_ID    ' + char(10)
			SELECT @v_dSql2 += '         AND    A.ITEM_ID      = D.ITEM_ID         ' + char(10)
			SELECT @v_dSql2 += '         AND    A.TOP_ITEM_ID  = D.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += '         INNER HASH JOIN #TH_UIS_CAL E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '         ON     A.PLAN_DATE    = E.DT              ' + char(10)
			SELECT @v_dSql2 += '         AND    CONVERT(VARCHAR,E.DT,112) BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql2 += '         INNER JOIN (                  ' + char(10)
			
			SELECT @v_dSql2 += '            		SELECT * FROM (    ' + char(10)
			SELECT @v_dSql2 += ' ' + @sSql        + char(10)
			SELECT @v_dSql2 += '              	) A                    ' + char(10)
			SELECT @v_dSql2 += '              	WHERE CATE_ID <> ''X'' ' + char(10)
			SELECT @v_dSql2 += '         ) F                           ' + char(10)
			SELECT @v_dSql2 += '         ON   1=1                      ' + char(10)
			SELECT @v_dSql2 += '        INNER HASH JOIN #FP_CELL_GROUP_V J WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql2 += '        ON     A.COMPANY_ID  = J.COMPANY_ID              ' + char(10)
			SELECT @v_dSql2 += '        AND    A.DIVISION_ID = J.DIVISION_ID             ' + char(10)
			SELECT @v_dSql2 += '        AND    A.SITE_ID     = J.SITE_ID                 ' + char(10)
			SELECT @v_dSql2 += '        AND    A.TOP_ITEM_ID = J.ITEM_ID                 ' + char(10)
			SELECT @v_dSql2 += '        WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += '        AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += '        AND    CONVERT(VARCHAR,A.PLAN_DATE,112)  BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)

			--IF LEN(@p_cell_group_code) > 0 																			                
			--    BEGIN																						                
   --                 SELECT @v_dSql2 += '      AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--    END	
				
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '      AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''    ' + char(10)
			    END	

			IF LEN(@p_nick_name) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '      AND  A.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			    END	
			
			IF LEN(@p_cell_group) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql2 += '      AND  J.CELL_GROUP LIKE ''%'' + '''+ @p_cell_group +''' + ''%'' ' + char(10)
			    END	

			SELECT @v_dSql2  += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
			SELECT @v_dSql2  += '           , A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql2  += '           , A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql2  += '           , A.OPERATION_ID, A.MARKET, A.PRODUCTION_TYPE, A.CUSTOMER_ID ' + char(10)
			SELECT @v_dSql2  += '           , F.CATE_ID, F.CATE_NAME, F.CATE_ORDER                       ' + char(10)
			--SELECT @v_dSql2  += ' ) ' + char(10)

			SELECT @v_dSql3  = ''
			SELECT @v_dSql3  = '------------------------------------v_dSql3-----------------------------' + char(10)
			SELECT @v_dSql3  += ' -- P : model, item, operation, market, production type, building, line, customer ' + char(10)

			
			--SELECT @v_dSql3  += ' , MAIN_P AS (                                         ' + char(10)
			SELECT @v_dSql3  += '     insert into #MAIN_P SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
			SELECT @v_dSql3  += '         , CELL_GROUP_CODE, CELL_GROUP, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, NICK_NAME ' + char(10)
			SELECT @v_dSql3  += '         , OPERATION_ID            ' + char(10)
			SELECT @v_dSql3  += '         , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(BOH_QTY,0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(HOLD_QTY,0) AS MONEY),1),''.00'','''') + '')'' AS BOH_QTY ' + char(10)
			SELECT @v_dSql3  += '         , MARKET, PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3  += '         , CUSTOMER_ID             ' + char(10)
			SELECT @v_dSql3  += '         , PSI                     ' + char(10)
			SELECT @v_dSql3  += '         , FACTORY_ID, LOCATION    ' + char(10)
			SELECT @v_dSql3  += '         , LINE_ID, LINE_NAME, ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3  += '         , CAST(AGING_LEAD_TIME as float) AGING_LEAD_TIME       ' + char(10)
			SELECT @v_dSql3  += '         , CAST(FORMATION_TOTAL_YIELD as float) AS FORMATION_TOTAL_YIELD ' + char(10)
			SELECT @v_dSql3  += '         , SHORTER_LEAD_TIME     ' + char(10)
			SELECT @v_dSql3  += '         , CATE                  ' + char(10)
			SELECT @v_dSql3  += '        , CATEGORY_ID    ' + char(10)
			SELECT @v_dSql3  += '        , CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql3  += '        , DATA_TYPE      ' + char(10)
			SELECT @v_dSql3  += '        , (CASE WHEN CATEGORY_ID = ''P_OUT'' THEN 1 ELSE NULL END) AS S_ROW ' + char(10)
			SELECT @v_dSql3  += '        , ISNULL(BOH_QTY,0) AS BOH, ISNULL(HOLD_QTY,0) AS HOLD              ' + char(10)

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

			                SELECT @v_tmp1 += '         , CASE WHEN CATEGORY_ID = ''P_YIELD'' THEN YM'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ELSE  M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' END AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += '         , CASE WHEN CATEGORY_ID = ''P_YIELD'' THEN YW'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ELSE  W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' END AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += '         , D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 

				END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3

			
			SELECT @v_dSql3  += '    FROM (               ' + char(10)
			SELECT @v_dSql3  += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql3  += '               , A.CELL_GROUP_CODE, K.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE AS ITEM_TYPE, A.NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql3  += '               , A.CELL_GROUP_CODE, K.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID,''QQQ''+ A.ITEM_TYPE AS ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql3  += '               , A.OPERATION_ID               ' + char(10)
			SELECT @v_dSql3  += '               , ISNULL(MAX(F.QTY),0) AS BOH_QTY, ISNULL(MAX(F.HOLD_QTY),0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql3  += '               , A.MARKET, A.PRODUCTION_TYPE  ' + char(10)
			SELECT @v_dSql3  += '               , A.CUSTOMER_ID                ' + char(10)
			SELECT @v_dSql3  += '               , ''P'' AS PSI                 ' + char(10)
			SELECT @v_dSql3  += '               , A.FACTORY_ID, A.LOCATION     ' + char(10)
			SELECT @v_dSql3  += '               , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE      ' + char(10)
			SELECT @v_dSql3  += '               , CAST(H.AGING_LEAD_TIME as float) AS AGING_LEAD_TIME          ' + char(10)
			SELECT @v_dSql3  += '               , CAST(ROUND(J.YIELD*100,2) as float) AS FORMATION_TOTAL_YIELD ' + char(10)
			SELECT @v_dSql3  += '               , I.SHORTER_LT AS SHORTER_LEAD_TIME             ' + char(10)
			SELECT @v_dSql3  += '               , D.CATE_NAME AS CATE                           ' + char(10)

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

			                SELECT @v_tmp1 += '               , SUM(CASE WHEN G.YYYYMM='''+ @v_month_info +''' THEN               ' + char(10)
							SELECT @v_tmp1 += '                          ( CASE WHEN D.CATE_ID = ''P_IN'' THEN A.IN_QTY           ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_MPP_IN'' THEN A.MPP_IN_QTY   ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_MPP_OUT'' THEN A.MPP_OUT_QTY                 ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_WPP_IN'' THEN A.WPP_IN_QTY                   ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_WPP_OUT'' THEN A.WPP_OUT_QTY                 ' + char(10)
						    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY                   ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_WIP'' THEN A.AGING_WIP                       ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_ACT'' THEN A.ACTIVATED                       ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY                         ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_CALAGING'' THEN A.CAL_AGING_QTY              ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_WIP_BD'' THEN A.AGING_WIP_BD                 ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_WIP_AD'' THEN A.AGING_WIP_AD                 ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM'' THEN A.AGING_WIP_SIM           ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM_BD'' THEN A.AGING_WIP_SIM_BD     ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM_AD'' THEN A.AGING_WIP_SIM_AD     ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_PKGPLANDATE'' THEN A.PKG_PLAN_DATE           ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_ACTSIM'' THEN A.ACTIVATED_SIM                ' + char(10)
        				    SELECT @v_tmp1 += '                                 WHEN D.CATE_ID = ''P_PKGQTY'' THEN A.PKG_QTY                      ' + char(10)
        				    SELECT @v_tmp1 += '                            ELSE 0 END ) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'   ' + char(10)

			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += '               , SUM(CASE WHEN G.ISO_YYYYWW='''+ @v_week_info +''' THEN                           ' + char(10)
							 SELECT @v_tmp2 += '                          ( CASE WHEN D.CATE_ID = ''P_IN'' THEN A.IN_QTY 						  ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_MPP_IN'' THEN A.MPP_IN_QTY                  ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_MPP_OUT'' THEN A.MPP_OUT_QTY                ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_WPP_IN'' THEN A.WPP_IN_QTY                  ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_WPP_OUT'' THEN A.WPP_OUT_QTY                ' + char(10)
						     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY                  ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_WIP'' THEN A.AGING_WIP                      ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_ACT'' THEN A.ACTIVATED                      ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY                        ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_CALAGING'' THEN A.CAL_AGING_QTY             ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_WIP_BD'' THEN A.AGING_WIP_BD                ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_WIP_AD'' THEN A.AGING_WIP_AD                ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM'' THEN A.AGING_WIP_SIM          ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM_BD'' THEN A.AGING_WIP_SIM_BD    ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM_AD'' THEN A.AGING_WIP_SIM_AD    ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_PKGPLANDATE'' THEN A.PKG_PLAN_DATE          ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_ACTSIM'' THEN A.ACTIVATED_SIM               ' + char(10)
        				     SELECT @v_tmp2 += '                                 WHEN D.CATE_ID = ''P_PKGQTY'' THEN A.PKG_QTY                     ' + char(10)
        				     SELECT @v_tmp2 += '                           ELSE 0 END ) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN         ' + char(10)
							 SELECT @v_tmp3 += '                          ( CASE WHEN D.CATE_ID = ''P_IN'' THEN A.IN_QTY 						  ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_MPP_IN'' THEN A.MPP_IN_QTY                  ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_MPP_OUT'' THEN A.MPP_OUT_QTY                ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_WPP_IN'' THEN A.WPP_IN_QTY                  ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_WPP_OUT'' THEN A.WPP_OUT_QTY                ' + char(10)
						     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY                  ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_WIP'' THEN A.AGING_WIP                      ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_ACT'' THEN A.ACTIVATED                      ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY                        ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_CALAGING'' THEN A.CAL_AGING_QTY             ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_WIP_BD'' THEN A.AGING_WIP_BD                ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_WIP_AD'' THEN A.AGING_WIP_AD                ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM'' THEN A.AGING_WIP_SIM          ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM_BD'' THEN A.AGING_WIP_SIM_BD    ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_AGINGWIPSIM_AD'' THEN A.AGING_WIP_SIM_AD    ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_PKGPLANDATE'' THEN A.PKG_PLAN_DATE          ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_ACTSIM'' THEN A.ACTIVATED_SIM               ' + char(10)
        				     SELECT @v_tmp3 += '                                 WHEN D.CATE_ID = ''P_PKGQTY'' THEN A.PKG_QTY                     ' + char(10)
        				     SELECT @v_tmp3 += '                           ELSE 0 END ) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			             END 

				END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3

			IF(LEN(@p_week_info) > 0)
			    BEGIN
			        SELECT @v_tmp1 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			        WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					        SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)
			                SELECT @v_tmp1 += '               , MAX(CASE WHEN G.YYYYMM='''+ @v_month_info +''' AND D.CATE_ID = ''P_YIELD'' THEN J.YIELD ELSE 0 END) AS YM'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 SELECT @v_tmp2 += '               , MAX(CASE WHEN G.ISO_YYYYWW='''+ @v_week_info +''' AND D.CATE_ID = ''P_YIELD'' THEN J.YIELD ELSE 0 END) AS YW'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			             END 

				END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2

			SELECT @v_dSql3  += '               , D.CATE_ID AS CATEGORY_ID        ' + char(10)
			SELECT @v_dSql3  += '               , D.CATE_ORDER AS CATEGORY_ORDER  ' + char(10)
			SELECT @v_dSql3  += '               , ''DATA'' AS DATA_TYPE           ' + char(10)
			SELECT @v_dSql3  += '               , NULL AS S_ROW                   ' + char(10)
			SELECT @v_dSql3  += '           FROM (                                ' + char(10)
			SELECT @v_dSql3  += '                 SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                             ' + char(10)
			SELECT @v_dSql3  += '                     ,A.CELL_GROUP_CODE,A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.LINE_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql3  += '                     ,A.CELL_GROUP_CODE,A.TOP_ITEM_ID, A.ITEM_ID, ''SSS'' + A.ITEM_TYPE AS ITEM_TYPE, A.NICK_NAME, A.LINE_NAME ' + char(10)
			SELECT @v_dSql3  += '                     ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION        ' + char(10)
			SELECT @v_dSql3  += '                     ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET          ' + char(10)
			SELECT @v_dSql3  += '                     ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.MPP_IN_QTY) MPP_IN_QTY   ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.MPP_OUT_QTY) MPP_OUT_QTY ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.WPP_IN_QTY) WPP_IN_QTY   ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.WPP_OUT_QTY) WPP_OUT_QTY ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.IN_QTY) IN_QTY           ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.OUT_QTY) OUT_QTY         ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.RESULT_QTY) RESULT_QTY   ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.AGING_WIP) AGING_WIP, SUM(A.AVAILABILITY) ACTIVATED ' + char(10)
			SELECT @v_dSql3  += '                     ,MAX(ROUND(A.YIELD*100,1)) AS YIELD                   ' + char(10)
			SELECT @v_dSql3  += '                     ,A.CUSTOMER_ID, SUM(A.CAL_AGING_QTY) AS CAL_AGING_QTY ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.AGING_WIP_BD) AS AGING_WIP_BD         ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.AGING_WIP_AD) AS AGING_WIP_AD         ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.AGING_WIP_SIM) AS AGING_WIP_SIM       ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.AGING_WIP_SIM_BD) AS AGING_WIP_SIM_BD ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.AGING_WIP_SIM_AD) AS AGING_WIP_SIM_AD ' + char(10)
			SELECT @v_dSql3  += '                     ,MAX(A.PKG_PLAN_DATE) AS PKG_PLAN_DATE       ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.ACTIVATED_SIM) AS ACTIVATED_SIM       ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(A.PKG_QTY) AS PKG_QTY                   ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP ELSE 0 END) AS AGING_WIP_WEEK         ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_BD ELSE 0 END) AS AGING_WIP_BD_WEEK   ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_AD ELSE 0 END) AS AGING_WIP_AD_WEEK   ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AVAILABILITY ELSE 0 END) AS ACTIVATED_WEEK      ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_SIM ELSE 0 END) AS AGING_WIP_SIM_WEEK ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_SIM_BD ELSE 0 END) AS AGING_WIP_SIM_BD_WEEK ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_SIM_AD ELSE 0 END) AS AGING_WIP_SIM_AD_WEEK ' + char(10)
			SELECT @v_dSql3  += '                     ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.ACTIVATED_SIM ELSE 0 END) AS ACTIVATED_SIM_WEEK       ' + char(10)
			SELECT @v_dSql3  += '                 FROM (                                                             ' + char(10)
			SELECT @v_dSql3  += ' 		                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID                        ' + char(10)
			SELECT @v_dSql3  += '                               , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql3  += '                               , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql3  += '                               , B.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql3  += '                               , ''PPP'' + B.ITEM_TYPE AS ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
			SELECT @v_dSql3  += '                               , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql3  += '                               , A.FACTORY_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql3  += '                               , NULL AS BOH_QTY             ' + char(10)
			SELECT @v_dSql3  += '                               , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql3  += '                               , ''P'' AS PSI       ' + char(10)
			SELECT @v_dSql3  += '                               , A.LINE_ID          ' + char(10)
			SELECT @v_dSql3  += '                               , A.ELECTRODE_TYPE   ' + char(10)
			SELECT @v_dSql3  += '                               , A.PLAN_DATE        ' + char(10)
			SELECT @v_dSql3  += '                               , A.MPP_IN_QTY       ' + char(10)
			SELECT @v_dSql3  += '                               , A.MPP_OUT_QTY      ' + char(10)
			SELECT @v_dSql3  += '                               , A.WPP_IN_QTY       ' + char(10)
			SELECT @v_dSql3  += '                               , A.WPP_OUT_QTY      ' + char(10)
			SELECT @v_dSql3  += '                               , A.IN_QTY           ' + char(10)
			SELECT @v_dSql3  += '                               , A.OUT_QTY          ' + char(10)
			SELECT @v_dSql3  += '                               , A.RESULT_QTY       ' + char(10)
			SELECT @v_dSql3  += '                               , A.AGING_WIP        ' + char(10)
			SELECT @v_dSql3  += '                               , A.AVAILABILITY     ' + char(10)
			SELECT @v_dSql3  += '                               , A.CUSTOMER_ID      ' + char(10)
			SELECT @v_dSql3  += '                               , 0 AS CAL_AGING_QTY ' + char(10)
			SELECT @v_dSql3  += '                               , A.AGING_WIP_BD     ' + char(10)
			SELECT @v_dSql3  += '                               , A.AGING_WIP_AD     ' + char(10)
			SELECT @v_dSql3  += '                               , A.AGING_WIP_SIM    ' + char(10)
			SELECT @v_dSql3  += '                               , A.AGING_WIP_SIM_BD ' + char(10)
			SELECT @v_dSql3  += '                               , A.AGING_WIP_SIM_AD ' + char(10)
			SELECT @v_dSql3  += '                               , CONVERT(NUMERIC,CONVERT(VARCHAR,A.PKG_PLAN_DATE,112)) AS PKG_PLAN_DATE ' + char(10)
			SELECT @v_dSql3  += '                               , A.ACTIVATED_SIM ' + char(10)
			SELECT @v_dSql3  += '                               , A.PKG_QTY       ' + char(10)
			SELECT @v_dSql3  += '                               , 1 AS YIELD      ' + char(10)
			SELECT @v_dSql3  += ' 		                  FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_table) +' A WITH(NOLOCK) ' + char(10)

			SELECT @v_dSql4  = ''
			SELECT @v_dSql4 = '------------------------------------v_dSql4-----------------------------' + char(10)
			SELECT @v_dSql4 += '                           INNER JOIN (                                                    ' + char(10)
			SELECT @v_dSql4 += '                                   SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
			SELECT @v_dSql4 += '                                        A.ITEM_ID,                                         ' + char(10)
			SELECT @v_dSql4 += '                                        (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql4 += '                                        	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql4 += '                                        	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
		    --@dev
			--SELECT @v_dSql4 += '                                        	     ''zzz'' + C.LEVEL_4_NAME + C.LEVEL_3_NAME +''of'' + A.ITEM_ID AS ITEM_TYPE, ' + char(10)

			SELECT @v_dSql4 += '                                        ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SELECT @v_dSql4 += '                                   FROM   SCM_ITEM_M A WITH(NOLOCK),           ' + char(10)
			SELECT @v_dSql4 += '                                          SCM_ITEM_CLASS_M C WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql4 += '                                   WHERE   1=1                                 ' + char(10)

			SELECT @v_dSql4 += '                                   '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '                                   AND    A.SITE_ID   = '''+ @p_site_id +''' '   + char(10)
				    END
             
			SELECT @v_dSql4 += '                                   AND	A.ITEM_CLASS  = C.CLASS_ID ' + char(10)

			IF(LEN(@p_nick_name_lt) > 0)
			    BEGIN
			        SELECT @v_dSql4 += '                                   '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt))    + char(10)
			    END

			SELECT @v_dSql4 += '                           ) B                                       ' + char(10)
			SELECT @v_dSql4 += ' 			               ON    A.COMPANY_ID  = B.COMPANY_ID        ' + char(10)
			SELECT @v_dSql4 += ' 			               AND   A.DIVISION_ID = B.DIVISION_ID       ' + char(10)
			SELECT @v_dSql4 += ' 			               AND   A.SITE_ID     = B.SITE_ID           ' + char(10)
			SELECT @v_dSql4 += ' 			               AND   A.ITEM_ID     = B.ITEM_ID           ' + char(10)
			SELECT @v_dSql4 += ' 			               INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += ' 				           ON    1=1                                 ' + char(10)

			SELECT @v_dSql4 += '                          '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += ' 				           AND    C.SITE_ID = '''+ @p_site_id +''' '    + char(10)
				END
			SELECT @v_dSql4 += ' 				           AND   A.COMPANY_ID   = C.COMPANY_ID       ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.DIVISION_ID  = C.DIVISION_ID      ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.SITE_ID      = C.SITE_ID          ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.TOP_ITEM_ID  = C.ITEM_ID          ' + char(10)
			SELECT @v_dSql4 += ' 				           INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += ' 				           ON    1=1                                 ' + char(10)
			
			SELECT @v_dSql4 += ' 				           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += ' 				           AND   E.SITE_ID   = '''+ @p_site_id +'''  '  + char(10)
                END
            
			SELECT @v_dSql4 += ' 				           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql4 += ' 				           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += ' 				           AND   E.OPERATION_ID  = '''+ @p_operation_id +''' '  + char(10)
				END
			
            SELECT @v_dSql4 += ' 				           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.LINE_ID' , 'EQ', @p_line_id))         + char(10)

			SELECT @v_dSql4 += ' 				           AND   A.COMPANY_ID     = E.COMPANY_ID       ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.DIVISION_ID    = E.DIVISION_ID      ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.SITE_ID        = E.SITE_ID          ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.PLANT_ID       = E.PLANT_ID         ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.FACTORY_ID     = E.FACTORY_ID       ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.OPERATION_ID   = E.OPERATION_ID     ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.LINE_ID        = E.LINE_ID          ' + char(10)
			SELECT @v_dSql4 += ' 				           AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE   ' + char(10)
			SELECT @v_dSql4 += '                       WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql4 += '                       AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)

			SELECT @v_dSql4 += '                       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '                       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
				END
            
			SELECT @v_dSql4 += '                       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql4 += '                       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '                       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
				END
			
            SELECT @v_dSql4 += '                       '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))         + char(10)
			SELECT @v_dSql4 += '                       AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql4 += '                       AND   ( A.MPP_OUT_QTY <> 0  OR A.WPP_OUT_QTY <> 0  OR A.OUT_QTY <> 0  OR  ISNULL(A.AVAILABILITY,0) <> 0 OR  ISNULL(A.AGING_WIP,0) <> 0  ) ' + char(10)

			--IF LEN(@p_cell_group_code) > 0 																			                
			--    BEGIN																						                
   --                 SELECT @v_dSql4 += '                       AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--    END			    
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql4 += '                       AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
                  
			SELECT @v_dSql4 += '          			) A ' + char(10)
			SELECT @v_dSql4 += '         INNER JOIN (   ' + char(10)
			SELECT @v_dSql4 += '                SELECT A.DT, A.YYYYMMDD, B.YYYYMMDD AS WEEK_ENDDATE ' + char(10)
			SELECT @v_dSql4 += '                FROM #TH_UIS_CAL A WITH(NOLOCK)                      ' + char(10)
			SELECT @v_dSql4 += '                LEFT OUTER JOIN (                                   ' + char(10)
			SELECT @v_dSql4 += '                       SELECT ISO_YYYYWW, MAX(YYYYMMDD) AS YYYYMMDD ' + char(10)
			SELECT @v_dSql4 += '                       FROM   #TH_UIS_CAL A WITH(NOLOCK)             ' + char(10)
			SELECT @v_dSql4 += '                       WHERE  A.YYYYMMDD BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql4 += '                       GROUP BY A.ISO_YYYYWW    ' + char(10)
			SELECT @v_dSql4 += '                ) B                             ' + char(10)
			SELECT @v_dSql4 += '                ON  A.ISO_YYYYWW = B.ISO_YYYYWW ' + char(10)
			SELECT @v_dSql4 += '                WHERE  A.YYYYMMDD BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql4 += '          ) C                                            ' + char(10)
			SELECT @v_dSql4 += '         ON  A.PLAN_DATE = C.DT                          ' + char(10)
			SELECT @v_dSql4 += '         WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql4 += '         AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql4 += '         AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql4 += '         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '             , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.LINE_NAME ' + char(10)
			SELECT @v_dSql4 += '             , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
			SELECT @v_dSql4 += '             , A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET   ' + char(10)
			SELECT @v_dSql4 += '             , A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, A.CUSTOMER_ID ' + char(10)
			SELECT @v_dSql4 += '         ) A                    ' + char(10)
			SELECT @v_dSql4 += '         INNER JOIN (           ' + char(10)
			SELECT @v_dSql4 += '                SELECT * FROM ( ' + char(10)


			SELECT @v_dSql4 = @v_dSql4 + ' ' + @pSql

			SELECT @v_dSql4 += '             	) A      ' + char(10)
			SELECT @v_dSql4 += '             	WHERE CATE_ID <> ''X'' ' + char(10)
			SELECT @v_dSql4 += '         ) D                           ' + char(10)
			SELECT @v_dSql4 += '         ON   1=1                      ' + char(10)
			SELECT @v_dSql4 += '         LEFT OUTER HASH JOIN (        ' + char(10)
			SELECT @v_dSql4 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += '                     , A.ITEM_ID, A.TOP_ITEM_ID                       ' + char(10)
			SELECT @v_dSql4 += '                     , SUM(A.QTY) AS QTY, SUM(A.HOLD_QTY) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql4 += '                FROM (                                                ' + char(10)
			SELECT @v_dSql4 += '                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID   ' + char(10)
			SELECT @v_dSql4 += '                           , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY, ISNULL(A.HOLD_QTY,0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql4 += '                      FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_cutoff_boh_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '                      WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +'''  ' + char(10)
			SELECT @v_dSql4 += '                      AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''      ' + char(10)
			SELECT @v_dSql4 += '                ) A                                                     ' + char(10)
			SELECT @v_dSql4 += '                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += '                       , A.ITEM_ID, A.TOP_ITEM_ID  ' + char(10)
			SELECT @v_dSql4 += '         ) F                                       ' + char(10)
			SELECT @v_dSql4 += '         ON    A.COMPANY_ID   = F.COMPANY_ID       ' + char(10)
			SELECT @v_dSql4 += '         AND   A.DIVISION_ID  = F.DIVISION_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   A.SITE_ID      = F.SITE_ID          ' + char(10)
			SELECT @v_dSql4 += '         AND   A.PLANT_ID     = F.PLANT_ID         ' + char(10)
			SELECT @v_dSql4 += '         AND   A.OPERATION_ID = F.OPERATION_ID     ' + char(10)
			SELECT @v_dSql4 += '         AND   A.ITEM_ID      = F.ITEM_ID          ' + char(10)
			SELECT @v_dSql4 += '         AND   A.TOP_ITEM_ID  = F.TOP_ITEM_ID      ' + char(10)
			SELECT @v_dSql4 += '         INNER HASH JOIN #TH_UIS_CAL G WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '         ON  A.PLAN_DATE       = G.DT              ' + char(10)
			SELECT @v_dSql4 += '         LEFT OUTER HASH JOIN (                    ' + char(10)
			SELECT @v_dSql4 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '                     , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql4 += '                     , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql4 += '                     , A.FACTORY_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql4 += '                     , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += '                     , A.LINE_ID                   ' + char(10)
			SELECT @v_dSql4 += '                     , A.ELECTRODE_TYPE            ' + char(10)
			SELECT @v_dSql4 += '                     , MAX(CAST(A.AGING_LEAD_TIME As float)) AS AGING_LEAD_TIME                  ' + char(10)
			SELECT @v_dSql4 += '                FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '                WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +'''                  ' + char(10)
			SELECT @v_dSql4 += '                AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''                      ' + char(10)
			SELECT @v_dSql4 += '                AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)
			   
			SELECT @v_dSql4 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
				END
            
			SELECT @v_dSql4 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql4 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
				END
			
            SELECT @v_dSql4 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))         + char(10)
			
			--IF LEN(@p_cell_group_code) > 0 																			                
			--    BEGIN																						                
   --                 SELECT @v_dSql4 += '                AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--    END			    
			
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql4 += '                AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
			
			SELECT @v_dSql4 += '                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += '                    , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '         ) H                                         ' + char(10)
			SELECT @v_dSql4 += '         ON    A.COMPANY_ID      = H.COMPANY_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   A.DIVISION_ID     = H.DIVISION_ID     ' + char(10)
			SELECT @v_dSql4 += '         AND   A.SITE_ID         = H.SITE_ID         ' + char(10)
			SELECT @v_dSql4 += '         AND   A.PLANT_ID        = H.PLANT_ID        ' + char(10)
			SELECT @v_dSql4 += '         AND   A.TOP_ITEM_ID     = H.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql4 += '         AND   A.ITEM_ID         = H.ITEM_ID         ' + char(10)
			SELECT @v_dSql4 += '         AND   A.OPERATION_ID    = H.OPERATION_ID    ' + char(10)
			SELECT @v_dSql4 += '         AND   A.FACTORY_ID      = H.FACTORY_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   A.LOCATION        = H.LOCATION        ' + char(10)
			SELECT @v_dSql4 += '         AND   A.PRODUCTION_TYPE = H.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql4 += '         AND   A.MARKET          = H.MARKET          ' + char(10)
			SELECT @v_dSql4 += '         AND   A.LINE_ID         = H.LINE_ID         ' + char(10)
			SELECT @v_dSql4 += '         AND   A.ELECTRODE_TYPE  = H.ELECTRODE_TYPE  ' + char(10)
			SELECT @v_dSql4 += '         LEFT OUTER HASH JOIN FP_FORMATION_SHORTER_LT_M I WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '         ON    A.COMPANY_ID      = I.COMPANY_ID   ' + char(10)
			SELECT @v_dSql4 += '         AND   A.DIVISION_ID     = I.DIVISION_ID  ' + char(10)
			SELECT @v_dSql4 += '         AND   A.SITE_ID         = I.SITE_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   A.PLANT_ID        = I.PLANT_ID     ' + char(10)
			SELECT @v_dSql4 += '         AND   A.FACTORY_ID      = I.FACTORY_ID   ' + char(10)
			SELECT @v_dSql4 += '         AND   A.OPERATION_ID    = I.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += '         AND   A.LINE_ID         = I.LINE_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   A.ITEM_ID         = I.ITEM_ID      ' + char(10)
			SELECT @v_dSql4 += '         LEFT OUTER HASH JOIN SCM_YIELD_M J WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '         ON    A.COMPANY_ID      = J.COMPANY_ID   ' + char(10)
			SELECT @v_dSql4 += '         AND   A.DIVISION_ID     = J.DIVISION_ID  ' + char(10)
			SELECT @v_dSql4 += '         AND   A.SITE_ID         = J.SITE_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   A.PLANT_ID        = J.PLANT_ID     ' + char(10)
			SELECT @v_dSql4 += '         AND   A.FACTORY_ID      = J.FACTORY_ID   ' + char(10)
			SELECT @v_dSql4 += '         AND   A.OPERATION_ID    = J.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += '         AND   A.LINE_ID         = J.LINE_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   A.ITEM_ID         = J.ITEM_ID      ' + char(10)
			SELECT @v_dSql4 += '         AND   J.MONTH			 = CONVERT(VARCHAR(6), '''+ @p_plan_date +''') ' + char(10)
			SELECT @v_dSql4 += '         INNER HASH JOIN #FP_CELL_GROUP_V K WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '         ON    A.COMPANY_ID  = K.COMPANY_ID             ' + char(10)
			SELECT @v_dSql4 += '         AND   A.DIVISION_ID = K.DIVISION_ID            ' + char(10)
			SELECT @v_dSql4 += '         AND   A.SITE_ID     = K.SITE_ID                ' + char(10)
			SELECT @v_dSql4 += '         AND   A.TOP_ITEM_ID = K.ITEM_ID                ' + char(10)
			SELECT @v_dSql4 += '         WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +'''  AND '''+ @p_bucket_to +''' ' + char(10)

			SELECT @v_dSql4 += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
				END
            SELECT @v_dSql4 += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql4 += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
				END

            SELECT @v_dSql4 += '        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))         + char(10)
		    
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql4 += '         AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
			IF LEN(@p_nick_name) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql4 += '         AND    A.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			    END	
			--IF LEN(@p_cell_group_code) > 0 																			                
			--    BEGIN																						                
   --                 SELECT @v_dSql4 += '        AND    A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%'' ' + char(10)
			--    END	
			IF LEN(@p_cell_group) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql4 += '         AND    K.CELL_GROUP LIKE ''%'' + '''+ @p_cell_group +''' + ''%'' ' + char(10)
			    END	

			SELECT @v_dSql4 += '         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '             , A.CELL_GROUP_CODE, K.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql4 += '             , A.CELL_GROUP_CODE, K.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql4 += '             , A.OPERATION_ID                           ' + char(10)
			SELECT @v_dSql4 += '             , A.MARKET, A.PRODUCTION_TYPE              ' + char(10)
			SELECT @v_dSql4 += '             , A.CUSTOMER_ID                            ' + char(10)
			SELECT @v_dSql4 += '             , A.FACTORY_ID, A.LOCATION                 ' + char(10)
			SELECT @v_dSql4 += '             , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '             , H.AGING_LEAD_TIME                        ' + char(10)
			SELECT @v_dSql4 += '             , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER     ' + char(10)
			SELECT @v_dSql4 += '             , I.SHORTER_LT, J.YIELD                    ' + char(10)
			SELECT @v_dSql4 += '     ) AA      ' + char(10)
			--SELECT @v_dSql4 += ' )             ' + char(10) 
			SELECT @v_dSql4 += ' option (order group, maxdop 1)             ' + char(10)
			
			
			
			
			
			
			SELECT @v_dSql4 += '; with T_MEMO AS ( ' + char(10)
			SELECT @v_dSql4 += '         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql4 += '             , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql4 += '             , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '             , A.EQUIPMENT_ID              ' + char(10)
			SELECT @v_dSql4 += '             , A.ITEM_ID, A.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql4 += '             , A.PRODUCTION_TYPE, A.MARKET ' + char(10)

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
                            SELECT @v_tmp1 += '             , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)= ''' + @v_day_info + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_MO' + char(10)
                        END 
			    END
            
			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

			SELECT @v_dSql4 += '         FROM FP_AMEND_MEMO_M A WITH(NOLOCK)             ' + char(10)
			SELECT @v_dSql4 += '         WHERE 1=1                                       ' + char(10)
			SELECT @v_dSql4 += '         AND   A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			
			SELECT @v_dSql4 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
				END
            
			SELECT @v_dSql4 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql4 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			
			IF (LEN(@p_operation_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
				END

            SELECT @v_dSql4 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))         + char(10)
		    
		    IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql4 += '         AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
			    END	
			IF LEN(@p_prod_type) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql4 += '         AND  A.PRODUCTION_TYPE LIKE ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
			    END	

			SELECT @v_dSql4 += '         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql4 += '            , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql4 += '            , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '            , A.EQUIPMENT_ID              ' + char(10)
			SELECT @v_dSql4 += '            , A.ITEM_ID, A.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql4 += '            , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += ' )                                        ' + char(10)

			SELECT @v_dSql5  = ''
			SELECT @v_dSql5 = '------------------------------------v_dSql5-----------------------------' + char(10)
			SELECT @v_dSql5 += ' SELECT A.* ' + char(10)
			SELECT @v_dSql5 += '    , DENSE_RANK() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '           ORDER BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID) AS LV1 ' + char(10)
			
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
			                SELECT @v_tmp1 += '  , C.D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_tmp2 += '  ,	CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85'' ' + char(10)
                            SELECT @v_tmp2 += '  		 WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2'' ' + char(10)
                            SELECT @v_tmp2 += '  		 WHEN ( A.CATEGORY_ID=''P_OUT'' OR A.CATEGORY_ID=''S_SHIP_PLAN'') THEN  ' + char(10)
                            SELECT @v_tmp2 += '  		           ( CASE WHEN  ''' + @v_day_info + '''  >= '''+ @p_plan_date +''' AND '''+ @p_plan_type +''' <> ''RELEASE'' AND (R.FACTORY_ID IS NOT NULL OR R2.PLANT_ID IS NOT NULL) THEN ''#FFFF0055'' ' + char(10)
                            SELECT @v_tmp2 += '  		             ELSE '''' END ) ' + char(10)
                            SELECT @v_tmp2 += '  		 ELSE '''' END AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BG ' + char(10)
                        END 
			    END

			SELECT @v_dSql5 = @v_dSql5 + @v_tmp1 + @v_tmp2

			SELECT @v_dSql5 += '   , (CASE WHEN R.FACTORY_ID IS NOT NULL THEN ''Y''  ' + char(10)
			SELECT @v_dSql5 += '           WHEN (R2.PLANT_ID IS NOT NULL AND A.CATEGORY_ID = ''S_SHIP_PLAN'') THEN ''Y''  ' + char(10)
			SELECT @v_dSql5 += '      ELSE ''N'' END) AS EDIT_YN ' + char(10)
			SELECT @v_dSql5 += 'FROM  (                          ' + char(10)
			SELECT @v_dSql5 += '       SELECT * FROM #MAIN_S      ' + char(10)
			SELECT @v_dSql5 += '       UNION ALL                 ' + char(10)
			SELECT @v_dSql5 += '       SELECT * FROM #MAIN_P      ' + char(10)
			SELECT @v_dSql5 += '       UNION ALL                 ' + char(10)
			SELECT @v_dSql5 += '       SELECT * FROM #MAIN_I      ' + char(10)
			SELECT @v_dSql5 += '       -- S (Target, Carry Over) : sub total ' + char(10)
			SELECT @v_dSql5 += '       UNION ALL                             ' + char(10)
			SELECT @v_dSql5 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, ''RRR''+ A.ITEM_TYPE AS ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '           ,A.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS BOH_QTY, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID       ' + char(10)
			SELECT @v_dSql5 += '           ,''S'' AS PSI   ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATE         ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATEGORY_ID                                       ' + char(10)
			SELECT @v_dSql5 += '           ,( CASE WHEN A.CATEGORY_ID=''S_PAST_SALES'' THEN 300 ' + char(10)
			SELECT @v_dSql5 += '       	         WHEN A.CATEGORY_ID=''S_NET'' THEN 310          ' + char(10) 
			SELECT @v_dSql5 += '       			 WHEN A.CATEGORY_ID=''S_CELL'' THEN 320         ' + char(10) 
			SELECT @v_dSql5 += '       			 WHEN A.CATEGORY_ID=''S_PACK'' THEN 330         ' + char(10) 
			SELECT @v_dSql5 += '       			 WHEN A.CATEGORY_ID=''S_SHIP_PLAN'' THEN 340    ' + char(10)
			SELECT @v_dSql5 += '       			 WHEN A.CATEGORY_ID=''S_CARRY'' THEN 350        ' + char(10)
			SELECT @v_dSql5 += '       	     ELSE 500 END) AS CATEGORY_ORDER                    ' + char(10)
			SELECT @v_dSql5 += '           ,''TOTAL'' AS DATA_TYPE    ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS S_ROW             ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS BOH, NULL AS HOLD ' + char(10)

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
			                SELECT @v_tmp1 += '           , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 SELECT @v_tmp2 += '           , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                SELECT @v_day_info     = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                SELECT @v_tmp3 += '           , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END
				END

            SELECT @v_dSql5 = @v_dSql5 + @v_tmp1 + @v_tmp2 + @v_tmp3

			
			SELECT @v_dSql5 += '       FROM   #MAIN_S A                ' + char(10)
   
			IF( @bSubTotal != 'Y' )
			    BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=0 ' + char(10)
				END
			ELSE
				BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=1 ' + char(10)
				END

			SELECT @v_dSql5 += '       AND	A.CATEGORY_ID NOT IN (''S_CELL'', ''S_PACK'')          ' + char(10)
			SELECT @v_dSql5 += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '           ,A.OPERATION_ID       ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATE,A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql5 += '       -- p : sub total          ' + char(10)
			SELECT @v_dSql5 += '       UNION ALL                 ' + char(10)
			SELECT @v_dSql5 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, ''MMM''+ A.ITEM_TYPE AS ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '           ,A.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS BOH_QTY, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID       ' + char(10)
			SELECT @v_dSql5 += '           ,''P'' AS PSI   ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATE         ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATEGORY_ID                                   ' + char(10)
			SELECT @v_dSql5 += '           ,(CASE WHEN A.CATEGORY_ID=''P_MPP_IN'' THEN 600  ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_MPP_OUT'' THEN 610 ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_WPP_IN'' THEN 620  ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_WPP_OUT'' THEN 630 ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_IN'' THEN 640      ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_OUT'' THEN 700     ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_RESULT'' THEN 730  ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_WIP'' THEN 750     ' + char(10)
			SELECT @v_dSql5 += '                  WHEN A.CATEGORY_ID=''P_MEMO'' THEN 810     ' + char(10)
			SELECT @v_dSql5 += '              ELSE 800 END) AS CATEGORY_ORDER               ' + char(10)
			SELECT @v_dSql5 += '           ,''TOTAL'' AS DATA_TYPE    ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS S_ROW             ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS BOH, NULL AS HOLD ' + char(10)

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
			                SELECT @v_tmp1 += '           , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 SELECT @v_tmp2 += '           , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                SELECT @v_day_info     = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                SELECT @v_tmp3 += '           , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END
				END

            SELECT @v_dSql5 = @v_dSql5 + @v_tmp1 + @v_tmp2 + @v_tmp3

			
			SELECT @v_dSql5 += '       FROM  #MAIN_P A                 ' + char(10)
    
			IF( @bSubTotal != 'Y' )
			    BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=0 ' + char(10)
				END
			ELSE
				BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=1 ' + char(10)
				END
  
			SELECT @v_dSql5 += '       AND A.CATEGORY_ID <> ''P_YIELD'' AND A.CATEGORY_ID <> ''P_PKGPLANDATE'' ' + char(10)
			SELECT @v_dSql5 += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID             ' + char(10)
			SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '           ,A.OPERATION_ID       ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATE,A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql5 += '       -- I : sub total          ' + char(10)
			SELECT @v_dSql5 += '       UNION ALL                 ' + char(10)
			SELECT @v_dSql5 += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			--@dev
			--SELECT @v_dSql5 += '           ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, ''NNN''+ A.ITEM_TYPE AS ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '           ,A.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS BOH_QTY, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID       ' + char(10)
			SELECT @v_dSql5 += '           ,''I'' AS PSI   ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATE         ' + char(10)
			SELECT @v_dSql5 += '            ,A.CATEGORY_ID                        ' + char(10)
			SELECT @v_dSql5 += '            ,( CASE WHEN CATE = ''EOH'' THEN 900  ' + char(10)
			SELECT @v_dSql5 += '               ELSE 910 END ) AS CATEGORY_ORDER   ' + char(10)
			SELECT @v_dSql5 += '            ,''TOTAL'' AS DATA_TYPE               ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS S_ROW                        ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS BOH, NULL AS HOLD            ' + char(10)

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
			                SELECT @v_tmp1 += '            , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 SELECT @v_tmp2 += '            , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			             END 
			        
					SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                SELECT @v_day_info     = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                SELECT @v_tmp3 += '            , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END
				END

            SELECT @v_dSql5 = @v_dSql5 + @v_tmp1 + @v_tmp2 + @v_tmp3

			
			SELECT @v_dSql5 += '       FROM   #MAIN_I A                            ' + char(10)
     
			IF( @bSubTotal != 'Y' )
			    BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=0 ' + char(10)
				END
			ELSE
				BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=1 ' + char(10)
				END

			SELECT @v_dSql5 += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '          ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '          ,A.OPERATION_ID                ' + char(10)
			SELECT @v_dSql5 += '          ,A.CATE,A.CATEGORY_ID          ' + char(10)
			SELECT @v_dSql5 += '       -- S (Target, Carry Over) : total ' + char(10)
			SELECT @v_dSql5 += '       UNION ALL                         ' + char(10)
			SELECT @v_dSql5 += '       SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS BOH_QTY, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID ' + char(10)
			SELECT @v_dSql5 += '           ,''S'' AS PSI         ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATE               ' + char(10)
			SELECT @v_dSql5 += '           ,A.CATEGORY_ID                                         ' + char(10)
			SELECT @v_dSql5 += '           ,( CASE WHEN A.CATEGORY_ID=''S_PAST_SALES'' THEN -1000 ' + char(10) 
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''S_NET'' THEN -990         ' + char(10)
			SELECT @v_dSql5 += '           	     WHEN A.CATEGORY_ID=''S_CELL'' THEN -980          ' + char(10)
			SELECT @v_dSql5 += '           	     WHEN A.CATEGORY_ID=''S_PACK'' THEN -970          ' + char(10)
			SELECT @v_dSql5 += '           	     WHEN A.CATEGORY_ID=''S_SHIP_PLAN'' THEN -960     ' + char(10)
			SELECT @v_dSql5 += '           	     WHEN A.CATEGORY_ID=''S_CARRY'' THEN -950         ' + char(10)
			SELECT @v_dSql5 += '           	 ELSE -800 END            ' + char(10)
			SELECT @v_dSql5 += '             ) AS CATEGORY_ORDER      ' + char(10)
			SELECT @v_dSql5 += '           ,''TOTAL_2'' AS DATA_TYPE  ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS S_ROW             ' + char(10)
			SELECT @v_dSql5 += '           ,NULL AS BOH, NULL AS HOLD ' + char(10)

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
			                SELECT @v_tmp1 += '            , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 SELECT @v_tmp2 += '            , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			             END 
			        
					SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                SELECT @v_day_info     = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                SELECT @v_tmp3 += '            , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END
				END

            SELECT @v_dSql5 = @v_dSql5 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql5 += '       FROM   #MAIN_S A                ' + char(10)

			IF( @bTotal != 'Y' )
			    BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=0 ' + char(10)
				END
			ELSE
				BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=1 ' + char(10)
				END

			SELECT @v_dSql5 += '       AND  A.CATEGORY_ID NOT IN (''S_CELL'', ''S_PACK'') ' + char(10)
			SELECT @v_dSql5 += '       GROUP BY A.CATE, A.CATEGORY_ID                     ' + char(10)
			SELECT @v_dSql5 += '       -- p : total ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL   ' + char(10)
			SELECT @v_dSql5 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS BOH_QTY, NULL AS MARKET, NULL AS PRODUCTION_TYPE, NULL AS CUSTOMER_ID ' + char(10)
			SELECT @v_dSql5 += '            ,''P'' AS PSI         ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql5 += '            ,A.CATE               ' + char(10)
			SELECT @v_dSql5 += '            ,A.CATEGORY_ID                                      ' + char(10)
			SELECT @v_dSql5 += '            ,( CASE WHEN A.CATEGORY_ID=''P_MPP_IN'' THEN -700   ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_MPP_OUT'' THEN -680  ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_WPP_IN'' THEN -670   ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_WPP_OUT'' THEN -660  ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_IN'' THEN -650       ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_OUT'' THEN -600      ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_RESULT'' THEN -550   ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_WIP'' THEN -530      ' + char(10)
			SELECT @v_dSql5 += '                    WHEN A.CATEGORY_ID=''P_MEMO'' THEN -400      ' + char(10)
			SELECT @v_dSql5 += '               ELSE -500 END) AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '            ,''TOTAL_2'' AS DATA_TYPE           ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS S_ROW                      ' + char(10)
			SELECT @v_dSql5 += '            ,NULL AS BOH, NULL AS HOLD          ' + char(10)

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
			                SELECT @v_tmp1 += '            , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 SELECT @v_tmp2 += '            , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			            BEGIN
			                SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                SELECT @v_day_info     = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                SELECT @v_tmp3 += '            , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
			            END
				END
     
			SELECT @v_dSql5 = @v_dSql5 + @v_tmp1 + @v_tmp2 + @v_tmp3
			
			SELECT @v_dSql5 += '        FROM   #MAIN_P A                         ' + char(10)
  
			IF( @bTotal != 'Y' )
			    BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=0 ' + char(10)
				END
			ELSE
				BEGIN 
				    SELECT @v_dSql5 += '    WHERE 1=1 ' + char(10)
				END
    
			SELECT @v_dSql5 += '    AND   A.CATEGORY_ID <> ''P_YIELD'' AND A.CATEGORY_ID <> ''P_PKGPLANDATE'' ' + char(10)
			SELECT @v_dSql5 += '    GROUP BY A.CATE, A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql5 += '    -- I : total                   ' + char(10)
			SELECT @v_dSql5 += ' ) A                                       ' + char(10)
			SELECT @v_dSql5 += ' LEFT OUTER JOIN T_MEMO C WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql5 += ' ON  A.COMPANY_ID      = C.COMPANY_ID      ' + char(10)
			SELECT @v_dSql5 += ' AND A.DIVISION_ID     = C.DIVISION_ID     ' + char(10)
			SELECT @v_dSql5 += ' AND A.SITE_ID         = C.SITE_ID         ' + char(10)
			SELECT @v_dSql5 += ' AND A.PLANT_ID        = C.PLANT_ID        ' + char(10)
			SELECT @v_dSql5 += ' AND A.FACTORY_ID      = C.FACTORY_ID      ' + char(10)
			SELECT @v_dSql5 += ' AND A.OPERATION_ID    = C.OPERATION_ID    ' + char(10)
			SELECT @v_dSql5 += ' AND A.LINE_ID         = C.LINE_ID         ' + char(10)
			SELECT @v_dSql5 += ' AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE  ' + char(10)
			SELECT @v_dSql5 += ' AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql5 += ' AND A.MARKET          = C.MARKET          ' + char(10)
			SELECT @v_dSql5 += ' AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql5 += ' AND A.ITEM_ID         = C.ITEM_ID         ' + char(10)
			SELECT @v_dSql5 += ' LEFT OUTER JOIN ' + char(10)
			SELECT @v_dSql5 += ' (               ' + char(10)
			SELECT @v_dSql5 += '   SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql5 += '   FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
			SELECT @v_dSql5 += '   WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
			SELECT @v_dSql5 += '   AND    A.ACTIVE_FLAG      = ''Y''       ' + char(10)
			SELECT @v_dSql5 += ' ) D                                       ' + char(10)
			SELECT @v_dSql5 += ' ON A.DIVISION_ID = D.DIVISION_ID          ' + char(10)
			SELECT @v_dSql5 += ' AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql5 += ' AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql5 += ' LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql5 += '          SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
			SELECT @v_dSql5 += '          FROM	 FP_USER_ROLE_INFO_V R WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql5 += '          WHERE	 1=1                                        ' + char(10)
			SELECT @v_dSql5 += '          AND    R.USER_ID     = ''' + @p_user_id + '''     ' + char(10)
			SELECT @v_dSql5 += '          AND    R.SAVE_FLAG   = ''Y''                      ' + char(10)
			SELECT @v_dSql5 += '          AND    R.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql5 += ' ) R       ' + char(10)
			SELECT @v_dSql5 += ' ON    1=1 ' + char(10)
			SELECT @v_dSql5 += ' AND  A.COMPANY_ID   = R.COMPANY_ID   ' + char(10)
			SELECT @v_dSql5 += ' AND  A.DIVISION_ID  = R.DIVISION_ID  ' + char(10)
			SELECT @v_dSql5 += ' AND  A.SITE_ID	     = R.SITE_ID      ' + char(10)
			SELECT @v_dSql5 += ' AND  A.PLANT_ID     = R.PLANT_ID     ' + char(10)
			SELECT @v_dSql5 += ' AND  A.FACTORY_ID   = R.FACTORY_ID   ' + char(10)
			SELECT @v_dSql5 += ' AND  A.OPERATION_ID = R.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += ' AND  A.LINE_ID      = R.LINE_ID      ' + char(10)
			SELECT @v_dSql5 += ' LEFT OUTER JOIN (                    ' + char(10)
			SELECT @v_dSql5 += '        SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '        FROM  FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql5 += '        WHERE 1=1                                ' + char(10)
			SELECT @v_dSql5 += '        AND   R.USER_ID     = ''' + @p_user_id + '''     ' + char(10)
			SELECT @v_dSql5 += '        AND   R.SAVE_FLAG   = ''Y''                      ' + char(10)
			SELECT @v_dSql5 += '        AND   R.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql5 += ' ) R2       ' + char(10)
			SELECT @v_dSql5 += ' ON   1=1   ' + char(10)
			SELECT @v_dSql5 += ' AND  A.COMPANY_ID   = R2.COMPANY_ID   ' + char(10)
			SELECT @v_dSql5 += ' AND  A.DIVISION_ID  = R2.DIVISION_ID  ' + char(10)
			SELECT @v_dSql5 += ' AND  A.SITE_ID	     = R2.SITE_ID      ' + char(10)
			SELECT @v_dSql5 += ' AND  A.PLANT_ID     = R2.PLANT_ID     ' + char(10)
			SELECT @v_dSql5 += ' AND  A.OPERATION_ID = R2.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += ' ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999 END) -- TOTAL : TOP           ' + char(10)
			SELECT @v_dSql5 += '     , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '     , (CASE WHEN A.DATA_TYPE = ''TOTAL'' THEN A.CATEGORY_ORDER ELSE 1 END) -- SUB TOTAL : BOTTOM           ' + char(10)
			SELECT @v_dSql5 += '     , (CASE WHEN (A.CATEGORY_ID = ''I'' OR A.CATEGORY_ID = ''I_SIMUL'') THEN 999 ELSE 1 END) -- I : BOTTOM ' + char(10)
			SELECT @v_dSql5 += '     , A.MARKET          ' + char(10)
			SELECT @v_dSql5 += '     , A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql5 += '     , A.CUSTOMER_ID     ' + char(10)
			SELECT @v_dSql5 += '     , (CASE WHEN A.PSI = ''S'' THEN A.CATEGORY_ORDER ELSE 999 END) -- S : TOP ' + char(10)
			SELECT @v_dSql5 += '     , A.FACTORY_ID, A.LINE_ID ' + char(10)
			SELECT @v_dSql5 += '     , A.CATEGORY_ORDER        ' + char(10)
			
			SET @v_dSql = ''
			SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3 + @v_dSql4 + @v_dSql5

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
	/* SELECT인경우 :SELECT_TOTAL_VALUE                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_TOTAL_VALUE')
		BEGIN --ELSE IF(START)
		    SELECT @v_dSql1  = ''

			SELECT @v_dSql = @v_dSql1
            SELECT @v_dSql += ' WITH MAIN AS ( ' + char(10)
            SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID    ' + char(10)
            SELECT @v_dSql += '          , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY          ' + char(10)
            SELECT @v_dSql += '     FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_cutoff_boh_table ) +' A WITH(NOLOCK)' + char(10)
            SELECT @v_dSql += '     INNER JOIN SCM_ITEM_M B WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql += '     ON     A.COMPANY_ID   = B.COMPANY_ID               ' + char(10)
            SELECT @v_dSql += '     AND    A.DIVISION_ID  = B.DIVISION_ID              ' + char(10)
            SELECT @v_dSql += '     AND    A.SITE_ID      = B.SITE_ID                  ' + char(10)
            SELECT @v_dSql += '     AND    A.ITEM_ID      = B.ITEM_ID                  ' + char(10)
            SELECT @v_dSql += '     WHERE  A.INSTANCE_ID  = ''' + @p_instance_id + ''' ' + char(10)
            SELECT @v_dSql += '     AND    A.FP_PLAN_ID   = ''' + @p_plan_id + '''     ' + char(10)
            SELECT @v_dSql += '     AND    EXISTS (                                    ' + char(10)
            SELECT @v_dSql += '         SELECT 1                                       ' + char(10)
            SELECT @v_dSql += '         FROM (                                         ' + char(10)
            SELECT @v_dSql += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '                   , A.ITEM_ID, A.TOP_ITEM_ID                                      ' + char(10)
            SELECT @v_dSql += '                   , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                 ' + char(10)
            SELECT @v_dSql += '               FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_table ) +' A WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '               WHERE  A.INSTANCE_ID  = ''' + @p_instance_id + '''                  ' + char(10)
            SELECT @v_dSql += '               AND    A.FP_PLAN_ID   = ''' + @p_plan_id + '''                      ' + char(10)
            SELECT @v_dSql += '               AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_plan_date + ''' ' + char(10)

            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			IF LEN(@p_site_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '               AND  A.SITE_ID = '''+ @p_site_id +''' ' + char(10)
			    END
			SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
            SELECT @v_dSql += '               AND    A.OPERATION_ID = ''' + @p_operation_id + ''' ' + char(10)
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '               AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
			    END	
            SELECT @v_dSql += '               UNION ALL                                                          ' + char(10)
            SELECT @v_dSql += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '                 	 , A.ITEM_ID, A.TOP_ITEM_ID                                  ' + char(10)
            SELECT @v_dSql += '                    , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE               ' + char(10)
            SELECT @v_dSql += '               FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                  ' + char(10)
            SELECT @v_dSql += '               WHERE  1=0                                                         ' + char(10)
            SELECT @v_dSql += '               AND    CONVERT(VARCHAR,A.PLAN_DATE,112) < ''' + @p_plan_date + ''' ' + char(10)

			IF (LEN(@p_plan_type) > 0)
			    BEGIN
                    SELECT @v_dSql += '               AND   A.PLAN_TYPE   = '''+ @p_plan_type +''' ' + char(10)
				END

            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql += '               AND   A.SITE_ID   = '''+ @p_site_id +''' ' + char(10)
				END
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))   + char(10)

            SELECT @v_dSql += '               AND    A.OPERATION_ID = ''' + @p_operation_id + ''' ' + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))         + char(10)
            
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '               AND   A.ITEM_ID = '''+ @p_item_id +'''        ' + char(10)
			    END	
            SELECT @v_dSql += '               UNION ALL                                            ' + char(10)
            SELECT @v_dSql += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '                    , A.ITEM_ID, A.TOP_ITEM_ID                      ' + char(10)
            SELECT @v_dSql += '                    , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' + char(10)
            SELECT @v_dSql += '               FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql += '               WHERE  1=0                                           ' + char(10)
            SELECT @v_dSql += '               AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql += '               AND   A.SITE_ID   = '''+ @p_site_id +''' ' + char(10)
				END
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))       + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))   + char(10)
            SELECT @v_dSql += '               AND    A.OPERATION_ID = ''' + @p_operation_id + '''                             ' + char(10)
            SELECT @v_dSql += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))         + char(10)
			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '               AND   A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''  ' + char(10)
			    END
            SELECT @v_dSql += '         ) AA                                    ' + char(10)
            SELECT @v_dSql += '         WHERE A.COMPANY_ID    = AA.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += '         AND   A.DIVISION_ID   = AA.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '         AND   A.SITE_ID       = AA.SITE_ID      ' + char(10)
            SELECT @v_dSql += '         AND   A.PLANT_ID      = AA.PLANT_ID     ' + char(10)
            SELECT @v_dSql += '         AND   A.OPERATION_ID  = AA.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '         AND   A.ITEM_ID       = AA.ITEM_ID      ' + char(10)
            SELECT @v_dSql += '         AND   A.TOP_ITEM_ID   = AA.TOP_ITEM_ID  ' + char(10)
            SELECT @v_dSql += '         AND   AA.PLAN_DATE BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
            SELECT @v_dSql += '    ) ' + char(10)
			IF LEN(@p_nick_name) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '         AND  B.NICK_NAME  LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			    END

            SELECT @v_dSql += ' )            ' + char(10)
            SELECT @v_dSql += ' -- SUB TOTAL ' + char(10)
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '      , A.ITEM_ID, A.TOP_ITEM_ID            ' + char(10)
            SELECT @v_dSql += '      , FORMAT(SUM(A.QTY), ''#,0'') AS QTY  ' + char(10)
            SELECT @v_dSql += '      , ''SUB_TOTAL'' AS _TYPE              ' + char(10)
            SELECT @v_dSql += ' FROM   MAIN A                              ' + char(10)
            SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID, A.TOP_ITEM_ID   ' + char(10)
            SELECT @v_dSql += ' UNION ALL                                  ' + char(10)
            SELECT @v_dSql += ' --- TOTAL                                  ' + char(10)
            SELECT @v_dSql += ' SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS OPERATION_ID ' + char(10)
            SELECT @v_dSql += '     , NULL AS ITEM_ID, NULL AS TOP_ITEM_ID ' + char(10)
            SELECT @v_dSql += '     , FORMAT(SUM(A.QTY), ''#,0'') AS QTY   ' + char(10)
            SELECT @v_dSql += '     , ''TOTAL'' AS _TYPE                   ' + char(10)
            SELECT @v_dSql += ' FROM  MAIN A                               ' + char(10)

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
	/************************************************************************************************/
	/* SELECT인경우 :SELECT_CWA_MINUS_ACTIVED                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_CWA_MINUS_ACTIVED')
		BEGIN --ELSE IF(START)

			SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, D.LINE_NAME                            ' + char(10)
            SELECT @v_dSql += '     , A.PRODUCTION_TYPE, A.MARKET                                       ' + char(10)
            SELECT @v_dSql += '     , A.ITEM_ID, ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID) AS CELL_GROUP_CODE, C.NICK_NAME ' + char(10)
            SELECT @v_dSql += '     , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE                ' + char(10)
            SELECT @v_dSql += '     , A.OUT_QTY, A.AVAILABILITY                                    ' + char(10)
            SELECT @v_dSql += ' FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_table ) +' A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += ' LEFT OUTER JOIN (                                                  ' + char(10)
            SELECT @v_dSql += '       SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER ' + char(10)
            SELECT @v_dSql += '       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql += '       WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' ' + char(10)
            SELECT @v_dSql += '       AND    A.ACTIVE_FLAG = ''Y''  ' + char(10)
            SELECT @v_dSql += ' ) B                                 ' + char(10)
            SELECT @v_dSql += ' ON  A.DIVISION_ID = B.DIVISION_ID   ' + char(10)
            SELECT @v_dSql += ' AND A.SITE_ID = B.SITE_ID           ' + char(10)
            SELECT @v_dSql += ' AND A.ITEM_ID = B.ITEM_ID           ' + char(10)
            SELECT @v_dSql += ' INNER JOIN (                        ' + char(10)
            SELECT @v_dSql += '     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, ' + char(10)
            SELECT @v_dSql += '            ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                      ' + char(10)
            SELECT @v_dSql += '     FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql += '     WHERE  A.ITEM_CLASS  = C.CLASS_ID                                  ' + char(10)
			IF LEN(@p_nick_name_lt) > 0 																			                
			    BEGIN																						                
					SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_line_id))         + char(10)
			    END

			IF LEN(@p_nick_name) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '     AND  A.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			    END

            SELECT @v_dSql += '       	AND    A.ACTIVE_FLAG = ''Y''     ' + char(10)
            SELECT @v_dSql += '       	AND    C.USE_FLAG = ''Y''        ' + char(10)
            SELECT @v_dSql += '     ) C                                  ' + char(10)
            SELECT @v_dSql += '     ON     A.COMPANY_ID  = C.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += '     AND    A.DIVISION_ID = C.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '     AND    A.SITE_ID     = C.SITE_ID     ' + char(10)
            SELECT @v_dSql += '     AND    A.ITEM_ID     = C.ITEM_ID     ' + char(10)
            SELECT @v_dSql += '     LEFT OUTER JOIN (                    ' + char(10)
            SELECT @v_dSql += '         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID      ' + char(10)
            SELECT @v_dSql += '           	 , A.OPERATION_ID, A.LINE_ID, MAX(ISNULL(A.LINE_NAME,''-'')) AS LINE_NAME ' + char(10)
            SELECT @v_dSql += '         FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '         WHERE  A.ACTIVE_FLAG = ''Y''     ' + char(10)

			SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			IF LEN(@p_site_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '     AND  A.SITE_ID = '''+ @p_site_id +'''  ' + char(10)
			    END
            SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)
			SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF LEN(@p_operation_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '     AND  A.OPERATION_ID = '''+ @p_operation_id +'''  ' + char(10)
			    END
            SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))  + char(10)
           

            SELECT @v_dSql += '         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '                , A.OPERATION_ID, A.LINE_ID           ' + char(10)
            SELECT @v_dSql += '     ) D                                              ' + char(10)
            SELECT @v_dSql += '     ON  A.COMPANY_ID    = D.COMPANY_ID               ' + char(10)
            SELECT @v_dSql += '     AND A.DIVISION_ID   = D.DIVISION_ID              ' + char(10)
            SELECT @v_dSql += '     AND A.SITE_ID       = D.SITE_ID                  ' + char(10)
            SELECT @v_dSql += '     AND A.PLANT_ID      = D.PLANT_ID                 ' + char(10)
            SELECT @v_dSql += '     AND A.FACTORY_ID    = D.FACTORY_ID               ' + char(10)
            SELECT @v_dSql += '     AND A.OPERATION_ID  = D.OPERATION_ID             ' + char(10)
            SELECT @v_dSql += '     AND A.LINE_ID       = D.LINE_ID                  ' + char(10)
            SELECT @v_dSql += '     WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql += '     AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
            SELECT @v_dSql += '     AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)

			SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			IF LEN(@p_site_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '     AND  A.SITE_ID = '''+ @p_site_id +'''  ' + char(10)
			    END
            SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)
			SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF LEN(@p_operation_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '     AND  A.OPERATION_ID = '''+ @p_operation_id +'''  ' + char(10)
			    END
            
			SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))  + char(10)
 			--IF LEN(@p_cell_group_code) > 0 																			                
			 --   BEGIN																						                
    --                SELECT @v_dSql += '     AND  A.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%''  ' + char(10)
			 --   END          			
 			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '     AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''  ' + char(10)
			    END 

            SELECT @v_dSql += '     AND	  A.AVAILABILITY < 0 ' + char(10)
            SELECT @v_dSql += '     ------>> out_qty > 0     ' + char(10)
            SELECT @v_dSql += '     AND EXISTS (             ' + char(10)
            SELECT @v_dSql += '                SELECT 1      ' + char(10)
            SELECT @v_dSql += '                FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_table ) +' AA WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                WHERE  A.INSTANCE_ID    = AA.INSTANCE_ID            ' + char(10)
            SELECT @v_dSql += '                AND   A.FP_PLAN_ID      = AA.FP_PLAN_ID             ' + char(10)
            SELECT @v_dSql += '                AND   A.COMPANY_ID      = AA.COMPANY_ID             ' + char(10)
            SELECT @v_dSql += '                AND   A.CATEGORY_ID     = AA.CATEGORY_ID            ' + char(10)
            SELECT @v_dSql += '                AND   A.SITE_ID         = AA.SITE_ID                ' + char(10)
            SELECT @v_dSql += '                AND   A.PLANT_ID	       = AA.PLANT_ID               ' + char(10)
            SELECT @v_dSql += '                AND   A.ITEM_ID         = AA.ITEM_ID                ' + char(10)
            SELECT @v_dSql += '                AND   A.OPERATION_ID    = AA.OPERATION_ID           ' + char(10)
            SELECT @v_dSql += '                AND   A.FACTORY_ID      = AA.FACTORY_ID             ' + char(10)
            SELECT @v_dSql += '                AND   A.PRODUCTION_TYPE = AA.PRODUCTION_TYPE        ' + char(10)
            SELECT @v_dSql += '                AND   A.MARKET          = AA.MARKET                 ' + char(10)
            SELECT @v_dSql += '                AND   A.LINE_ID         = AA.LINE_ID                ' + char(10)
            SELECT @v_dSql += '                AND   A.TOP_ITEM_ID     = AA.TOP_ITEM_ID            ' + char(10)
            SELECT @v_dSql += '                AND   AA.INSTANCE_ID    = '''+ @p_instance_id +'''  ' + char(10)
            SELECT @v_dSql += '                AND   AA.FP_PLAN_ID     = '''+ @p_plan_id +'''      ' + char(10)
            SELECT @v_dSql += '                AND   CONVERT(VARCHAR,AA.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)

			SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			IF LEN(@p_site_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '                AND  AA.SITE_ID = '''+ @p_site_id +'''  ' + char(10)
			    END
            SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.PLANT_ID' , 'EQ', @p_plant_id))     + char(10)
			SELECT @v_dSql += '    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			
			IF LEN(@p_operation_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '                AND  AA.OPERATION_ID = '''+ @p_operation_id +'''  ' + char(10)
			    END
            
			SELECT @v_dSql += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.LINE_ID' , 'EQ', @p_line_id))  + char(10)
 			--IF LEN(@p_cell_group_code) > 0 																			                
			 --   BEGIN																						                
    --                SELECT @v_dSql += '                AND  AA.CELL_GROUP_CODE LIKE ''%'' + '''+ @p_cell_group_code +''' + ''%''  ' + char(10)
			 --   END          			
 			IF LEN(@p_item_id) > 0 																			                
			    BEGIN																						                
                    SELECT @v_dSql += '                AND  AA.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''  ' + char(10)
			    END 

            SELECT @v_dSql += '                	AND    AA.OUT_QTY > 0 ' + char(10)
            SELECT @v_dSql += '                )                      ' + char(10)
            SELECT @v_dSql += '                ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '                    , A.OPERATION_ID, A.LINE_ID                                           ' + char(10)
            SELECT @v_dSql += '                    , A.PRODUCTION_TYPE, A.MARKET                                         ' + char(10)
            SELECT @v_dSql += '                    , ISNULL(B.GROUP_ITEM_ID, A.ITEM_ID), A.ITEM_ID, A.PLAN_DATE          ' + char(10)


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
					   /* EXECUTE  경우  :  EXEC_PR_PARALLER_A                                       */
					   /******************************************************************************/
					   IF(@v_sys_flag ='EXEC_PR_PARALLER_A')  
                           BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_SHORTER_LT_SIM_CALL] @v_instance_id, @v_plan_id
								
								SELECT	'Result' = @rtnCount

                            END
					   /****************************************************************************/
					   /* EXECUTE  경우  :  EXEC_SIMULATION                                           */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='EXEC_SIMULATION')
                            BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_SHORTER_LT_SIM_CALL] @v_instance_id, @v_plan_id
								
								SET @rtnCount = 1
								SELECT	'Result' = @rtnCount

                            END
					   ELSE IF(@v_sys_flag ='EXEC_PR_PARALLER_B')  
                           BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM] @v_instance_id, @v_plan_id
								
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
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id, @v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
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

