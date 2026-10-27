


/*
 * Program ID   : PR_UI_FP00621_AMEND_LINE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/10/06   JYJ				Initial Release UI통합
 */

create PROCEDURE [dbo].[PR_UI_FP00621_AMEND_LINE_TUNING]
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
	DECLARE @v_proc_name	        NVARCHAR(100) = OBJECT_NAME(@@PROCID)
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
    DECLARE @bOff                   NVARCHAR(2)= ''
    DECLARE @bSetup                 NVARCHAR(2)= ''
    DECLARE @bCapa                  NVARCHAR(2)= ''
	DECLARE @bMemo                  NVARCHAR(2)=''

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
--SET @PARAMS += ',@P_CELL_GROUP            = ''' + ISNULL(@p_cell_group           	, '') + '''' + char(10)
--SET @PARAMS += ',@P_CELL_GROUP_CODE	      = ''' + ISNULL(@p_cell_group_code      	, '') + '''' + char(10)
--SET @PARAMS += ',@P_BUCKET_FROM		      = ''' + ISNULL(@p_bucket_from	        	, '') + '''' + char(10)
--SET @PARAMS += ',@P_BUCKET_TO		      = ''' + ISNULL(@p_bucket_to	        	, '') + '''' + char(10)
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


--SELECT @PARAMS AS SQL
--RETURN

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)

			SELECT @pSql = ''
           
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
                            IF( @v_cate_info = 'chk_calAgingQty'                                )  SELECT @bCalAgingQty =  'Y'
                            IF( @v_cate_info = 'chk_carryOver'       AND @v_cate_value = 'TRUE' )  SELECT @bCarryOver =  'Y'
                            IF( @v_cate_info = 'chk_cellBiz'         AND @v_cate_value = 'TRUE' )  SELECT @bCellBiz =  'Y'
                            IF( @v_cate_info = 'chk_inventory'       AND @v_cate_value = 'TRUE' )  SELECT @bInventory =  'Y'
                            IF( @v_cate_info = 'chk_pkgProcDate'     AND @v_cate_value = 'TRUE' )  SELECT @bPkgProcDate =  'Y'
                            IF( @v_cate_info = 'chk_pkgQty'          AND @v_cate_value = 'TRUE' )  SELECT @bPkgQty =  'Y'
                            IF( @v_cate_info = 'chk_packSemi'        AND @v_cate_value = 'TRUE' )  SELECT @bPackSemi =  'Y'
                            IF( @v_cate_info = 'chk_inqty'                                      )  SELECT @bInQty =  'Y' 
                            IF( @v_cate_info = 'chk_outqty'          AND @v_cate_value = 'TRUE' )  SELECT @bOutQty =  'Y'
                            IF( @v_cate_info = 'chk_result'          AND @v_cate_value = 'TRUE' )  SELECT @bResult =  'Y'
                            IF( @v_cate_info = 'chk_shipResult'      AND @v_cate_value = 'TRUE' )  SELECT @bShipResult =  'Y'
                            IF( @v_cate_info = 'chk_target'          AND @v_cate_value = 'TRUE' )  SELECT @bTarget =  'Y'
                            IF( @v_cate_info = 'chk_yield'                                      )  SELECT @bYield =  'Y' 

                            IF( @v_cate_info = 'chk_mppIn'           AND @v_cate_value = 'TRUE' )  SELECT @bMppInQty =  'Y'
                            IF( @v_cate_info = 'chk_mppOut'          AND @v_cate_value = 'TRUE' )  SELECT @bMppOutQty =  'Y'
                            IF( @v_cate_info = 'chk_wppIn'           AND @v_cate_value = 'TRUE' )  SELECT @bWppInQty =  'Y'
                            IF( @v_cate_info = 'chk_wppOut'          AND @v_cate_value = 'TRUE' )  SELECT @bWppOutQty =  'Y'

                            IF( @v_cate_info = 'chk_total_2'         AND @v_cate_value = 'TRUE' )  SELECT @bTotal =  'Y'
                            IF( @v_cate_info = 'chk_total'           AND @v_cate_value = 'TRUE' )  SELECT @bSubTotal =  'Y'

							IF( @v_cate_info = 'chk_off'             AND @v_cate_value = 'TRUE' )  SELECT @bOff   = 'Y'
						  	IF( @v_cate_info = 'chk_setup'           AND @v_cate_value = 'TRUE' )  SELECT @bSetup = 'Y'
						  	IF( @v_cate_info = 'chk_capa'            AND @v_cate_value = 'TRUE' )  SELECT @bCapa  = 'Y'

						  	IF( @v_cate_info = 'chk_memo'            AND @v_cate_value = 'TRUE' )  SELECT @bMemo  = 'Y'
                        END
            	
                    SELECT @pSql = '              	                SELECT 0 AS CATE_ORDER, '''' AS CATE_NAME, ''X'' AS CATE_ID ' + char(10)
                
                	IF( @bWip = 'Y' ) 
					    BEGIN	
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                              
                            SELECT @pSql +=	'              	                SELECT 15 AS CATE_ORDER, ''Aging WIP'' AS CATE_NAME, ''P_WIP'' AS CATE_ID ' + char(10)                 
                	    END											        
                	IF( @bWipBd = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                             
                            SELECT @pSql +=	'              	                SELECT 20 AS CATE_ORDER, ''    Before Degas'' AS CATE_NAME, ''P_WIP_BD'' AS CATE_ID ' + char(10)       
                	    END											        
                	IF( @bWipAd = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                             
                            SELECT @pSql +=	'              	                SELECT 30 AS CATE_ORDER, ''    After Degas'' AS CATE_NAME, ''P_WIP_AD'' AS CATE_ID ' + char(10)        
                	    END											        
                	IF( @bAct = 'Y' ) 								        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                             
                            SELECT @pSql +=	'              	                SELECT 40 AS CATE_ORDER, ''Activated Cell'' AS CATE_NAME, ''P_ACT'' AS CATE_ID ' + char(10)            
                	    END											        
                	IF( @bWipSim = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                                     
                            SELECT @pSql +=	'              	                SELECT 60 AS CATE_ORDER, ''Aging WIP(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM'' AS CATE_ID ' + char(10)    
                	    END											        
                	IF( @bWipSimBd = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                                     
                            SELECT @pSql +=	'              	                SELECT 70 AS CATE_ORDER, ''    Before Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_BD'' AS CATE_ID ' + char(10) 
                	    END											        
                	IF( @bWipSimAd = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	                SELECT 80 AS CATE_ORDER, ''    After Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_AD'' AS CATE_ID ' + char(10) 
                	    END											        
                	IF( @bPkgProcDate = 'Y' ) 						        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	                SELECT 90 AS CATE_ORDER, ''PKG Date(Changed L/T)'' AS CATE_NAME, ''P_PKGPLANDATE'' AS CATE_ID ' + char(10)           
                	    END											        
                	IF( @bPkgQty = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	                SELECT 95 AS CATE_ORDER, ''PKG Result & Plan(Changed L/T)'' AS CATE_NAME, ''P_PKGQTY'' AS CATE_ID ' + char(10)       
                	    END											        
                	IF( @bActSim = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                                           
                            SELECT @pSql +=	'              	                SELECT 98 AS CATE_ORDER, ''Activated Cell(Changed L/T)'' AS CATE_NAME, ''P_ACTSIM'' AS CATE_ID ' + char(10)          
                	    END											        
                    IF( @bMppInQty = 'Y' OR @bWppInQty = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                         
                            SELECT @pSql +=	'              	                SELECT 100 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN'' AS CATE_ID ' + char(10)								
                        END											        
                    IF( @bMppOutQty = 'Y' OR @bWppOutQty = 'Y' ) 						        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	                SELECT 105 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT'' AS CATE_ID ' + char(10)   
                        END											        
                    IF( @bWppInQty = 'Y' OR @bMppInQty = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                               
                            SELECT @pSql +=	'              	                SELECT 108 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN'' AS CATE_ID ' + char(10)								
                        END											        
                    IF( @bWppOutQty = 'Y' OR @bMppOutQty = 'Y' ) 						        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	                SELECT 110 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT'' AS CATE_ID ' + char(10)   
                        END											        
                	IF( @bOutQty = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	                SELECT 116 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT'' AS CATE_ID ' + char(10)            
                	    END											        
                	IF( @bResult = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	                SELECT 118 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID ' + char(10)      
                	    END
                	IF( @bMemo = 'Y' ) 							        
					    BEGIN										        
                            SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                   
                            SELECT @pSql +=	'              	                SELECT 300 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID ' + char(10)      
                	    END
                END --(IF)
            ELSE 
                BEGIN --(ELSE)
                	SELECT  @pSql += '              	                SELECT 1 AS CATE_ORDER, ''Aging WIP'' AS CATE_NAME, ''P_WIP'' AS CATE_ID ' + char(10)                          
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                  
                	SELECT  @pSql += '              	                SELECT 2 AS CATE_ORDER, ''    Before Degas'' AS CATE_NAME, ''P_WIP_BD'' AS CATE_ID ' + char(10)                    
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                            
                	SELECT  @pSql += '              	                SELECT 3 AS CATE_ORDER, ''    After Degas'' AS CATE_NAME, ''P_WIP_AD'' AS CATE_ID ' + char(10)                     
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                          
                	SELECT  @pSql += '              	                SELECT 4 AS CATE_ORDER, ''Activated Cell'' AS CATE_NAME, ''P_ACT'' AS CATE_ID ' + char(10)                         
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                                                                                                                  
                	SELECT  @pSql += '              	                SELECT 5 AS CATE_ORDER, ''Aging WIP(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM'' AS CATE_ID ' + char(10)         
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                          
                	SELECT  @pSql += '              	                SELECT 6 AS CATE_ORDER, ''    Before Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_BD'' AS CATE_ID ' + char(10)
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	                SELECT 7 AS CATE_ORDER, ''    After Degas(Changed L/T)'' AS CATE_NAME, ''P_AGINGWIPSIM_AD'' AS CATE_ID ' + char(10) 
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	                SELECT 9 AS CATE_ORDER, ''PKG Date(Changed L/T)'' AS CATE_NAME, ''P_PKGPLANDATE'' AS CATE_ID ' + char(10)           
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	                SELECT 10 AS CATE_ORDER, ''PKG Result & Plan(Changed L/T)'' AS CATE_NAME, ''P_PKGQTY'' AS CATE_ID ' + char(10)       
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                                           
                	SELECT  @pSql += '              	                SELECT 11 AS CATE_ORDER, ''Activated Cell(Changed L/T)'' AS CATE_NAME, ''P_ACTSIM'' AS CATE_ID ' + char(10)          
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                  
                	SELECT  @pSql += '              	                SELECT 13 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN'' AS CATE_ID ' + char(10)							
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	                SELECT 15 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT'' AS CATE_ID ' + char(10)  
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	                SELECT 20 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN'' AS CATE_ID ' + char(10)							
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	                SELECT 25 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT'' AS CATE_ID ' + char(10)     
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	                SELECT 30 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT'' AS CATE_ID ' + char(10)           
                	SELECT  @pSql += '              	                UNION ALL ' + char(10)                                                                  
                	SELECT  @pSql += '              	                SELECT 40 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID ' + char(10)     
					SELECT @pSql +=	'              	                UNION ALL ' + char(10)                                                                   
                    SELECT @pSql +=	'              	                SELECT 300 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID ' + char(10)      

                END--(ELSE)
						  
			SELECT @v_dSql1 = ''
			SELECT @v_dSql1 = '------------------------------------v_dSql1-----------------------------' + char(10)
			
			SELECT @v_dSql1 += ' if object_id(''tempdb..#temp_table_1'') is not null' + char(10)
			SELECT @v_dSql1 += ' DROP TABLE #temp_table_1 ' + char(10)

			SELECT @v_dSql1 += ' 		            SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.LINE_NAME ' + char(10)
			SELECT @v_dSql1 += ' 		                ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
			SELECT @v_dSql1 += ' 		                ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET   ' + char(10)
			SELECT @v_dSql1 += ' 		                ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, SUM(A.IN_QTY) IN_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.OUT_QTY) OUT_QTY, SUM(A.RESULT_QTY) RESULT_QTY      ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.AGING_WIP) AGING_WIP, SUM(A.AVAILABILITY) ACTIVATED ' + char(10)
			SELECT @v_dSql1 += ' 		                ,MAX(ROUND(A.YIELD*100,1)) AS YIELD                   ' + char(10)
			SELECT @v_dSql1 += ' 		                ,A.CUSTOMER_ID, SUM(A.CAL_AGING_QTY) AS CAL_AGING_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.AGING_WIP_BD) AS AGING_WIP_BD         ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.AGING_WIP_AD) AS AGING_WIP_AD         ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.AGING_WIP_SIM) AS AGING_WIP_SIM       ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.AGING_WIP_SIM_BD) AS AGING_WIP_SIM_BD ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.AGING_WIP_SIM_AD) AS AGING_WIP_SIM_AD ' + char(10)
			SELECT @v_dSql1 += ' 		                ,MAX(A.PKG_PLAN_DATE) AS PKG_PLAN_DATE       ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.ACTIVATED_SIM) AS ACTIVATED_SIM       ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.PKG_QTY) AS PKG_QTY                   ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP ELSE 0 END) AS AGING_WIP_WEEK         ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_BD ELSE 0 END) AS AGING_WIP_BD_WEEK   ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_AD ELSE 0 END) AS AGING_WIP_AD_WEEK   ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AVAILABILITY ELSE 0 END) AS ACTIVATED_WEEK      ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_SIM ELSE 0 END) AS AGING_WIP_SIM_WEEK ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_SIM_BD ELSE 0 END) AS AGING_WIP_SIM_BD_WEEK ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.AGING_WIP_SIM_AD ELSE 0 END) AS AGING_WIP_SIM_AD_WEEK ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(CASE WHEN C.WEEK_ENDDATE = C.YYYYMMDD THEN A.ACTIVATED_SIM ELSE 0 END) AS ACTIVATED_SIM_WEEK       ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.MPP_IN_QTY) AS MPP_IN_QTY,SUM(A.MPP_OUT_QTY) AS MPP_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		                ,SUM(A.WPP_IN_QTY) AS WPP_IN_QTY,SUM(A.WPP_OUT_QTY) AS WPP_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		            INTO #temp_table_1                       ' + char(10) 
			SELECT @v_dSql1 += ' 		            FROM (                                   ' + char(10) 
			SELECT @v_dSql1 += ' 		                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                      , B.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.FACTORY_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql1 += ' 		                      , NULL AS BOH_QTY             ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += ' 		                      , ''P'' AS PSI       ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.LINE_ID          ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.ELECTRODE_TYPE   ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.PLAN_DATE        ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.IN_QTY           ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.OUT_QTY          ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.RESULT_QTY       ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.AGING_WIP        ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.AVAILABILITY     ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.CUSTOMER_ID      ' + char(10)
			SELECT @v_dSql1 += ' 		                      , 0 AS CAL_AGING_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.AGING_WIP_BD     ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.AGING_WIP_AD     ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.AGING_WIP_SIM    ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.AGING_WIP_SIM_BD ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.AGING_WIP_SIM_AD ' + char(10)
			SELECT @v_dSql1 += ' 		                      , CONVERT(NUMERIC,CONVERT(VARCHAR,A.PKG_PLAN_DATE,112)) AS PKG_PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.ACTIVATED_SIM ' + char(10)
			SELECT @v_dSql1 += ' 		                      , 1 AS YIELD      ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.MPP_IN_QTY, A.MPP_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.WPP_IN_QTY, A.WPP_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		                      , A.PKG_QTY                   ' + char(10)
			SELECT @v_dSql1 += ' 		                  FROM  '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		                  INNER JOIN (                                                    ' + char(10)
			SELECT @v_dSql1 += ' 		                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,   ' + char(10)
			SELECT @v_dSql1 += ' 		                            A.ITEM_ID,                                            ' + char(10)
			SELECT @v_dSql1 += ' 		                            (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql1 += ' 		                                  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql1 += ' 		                                  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
			SELECT @v_dSql1 += ' 		                            ISNULL(A.NICK_NAME,''-'') AS NICK_NAME       ' + char(10)
			SELECT @v_dSql1 += ' 		                        FROM  SCM_ITEM_M A WITH(NOLOCK),                 ' + char(10)
			SELECT @v_dSql1 += ' 		                              SCM_ITEM_CLASS_M C WITH(NOLOCK)            ' + char(10)
			SELECT @v_dSql1 += ' 		                        WHERE  1=1                                       ' + char(10)

			SELECT @v_dSql1 += ' 		                        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                        AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		                        AND  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)

			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                        AND    A.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END

			IF (LEN(@p_nick_name_lt) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt))    + char(10)
				END
			SELECT @v_dSql1 += ' 		                  ) B                                  ' + char(10)
			SELECT @v_dSql1 += ' 		                  ON     A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.SITE_ID     = B.SITE_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.ITEM_ID     = B.ITEM_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		                  INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		                  ON     1=1                                ' + char(10)

			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                  AND  C.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		                  AND   A.COMPANY_ID   = C.COMPANY_ID  ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.SITE_ID      = C.SITE_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.TOP_ITEM_ID  = C.ITEM_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		                  INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		                  ON     1=1                                ' + char(10)
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                  AND  E.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.LINE_ID' , 'EQ', @p_line_id)) + char(10)

			SELECT @v_dSql1 += ' 		                  AND    E.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
								 		                  
			SELECT @v_dSql1 += ' 		                  AND   A.COMPANY_ID     = E.COMPANY_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.DIVISION_ID    = E.DIVISION_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.SITE_ID        = E.SITE_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.PLANT_ID       = E.PLANT_ID       ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.FACTORY_ID     = E.FACTORY_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.OPERATION_ID   = E.OPERATION_ID   ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.LINE_ID        = E.LINE_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		                  INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		                  ON     A.COMPANY_ID  = J.COMPANY_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.DIVISION_ID = J.DIVISION_ID       ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.SITE_ID     = J.SITE_ID           ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.TOP_ITEM_ID = J.ITEM_ID           ' + char(10)
			SELECT @v_dSql1 += ' 		                  WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)

			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                  AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)

			SELECT @v_dSql1 += ' 		                  AND  A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		                  '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))       + char(10)
			SELECT @v_dSql1 += ' 		                  AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND  ( A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.AVAILABILITY IS NOT NULL OR ISNULL(A.AGING_WIP,0) <> 0 ) ' + char(10)
			IF (LEN(@p_cell_group) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                  AND    J.CELL_GROUP  LIKE ''%'' + '''+ @p_cell_group +''' + ''%'' ' + char(10)
				END
			
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                  AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END

            SELECT @v_dSql1 += ' 		            ) A          ' + char(10)
            SELECT @v_dSql1 += ' 		            INNER JOIN ( ' + char(10)
            SELECT @v_dSql1 += ' 		                   SELECT A.DT, A.YYYYMMDD, B.YYYYMMDD AS WEEK_ENDDATE ' + char(10)
            SELECT @v_dSql1 += ' 		                   FROM TH_UIS_CAL A WITH(NOLOCK)                      ' + char(10)
            SELECT @v_dSql1 += ' 		                   LEFT OUTER JOIN (                                   ' + char(10)
            SELECT @v_dSql1 += ' 		                         SELECT ISO_YYYYWW, MAX(YYYYMMDD) AS YYYYMMDD  ' + char(10)
            SELECT @v_dSql1 += ' 		                         FROM   TH_UIS_CAL A WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql1 += ' 		                         WHERE  A.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
            SELECT @v_dSql1 += ' 		                         GROUP BY A.ISO_YYYYWW     ' + char(10)
            SELECT @v_dSql1 += ' 		                   ) B                             ' + char(10)
            SELECT @v_dSql1 += ' 		                   ON  A.ISO_YYYYWW = B.ISO_YYYYWW ' + char(10)
            SELECT @v_dSql1 += ' 		                   WHERE  A.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
            SELECT @v_dSql1 += ' 		            ) C                    ' + char(10)
            SELECT @v_dSql1 += ' 		            ON  A.PLAN_DATE = C.DT ' + char(10)
            SELECT @v_dSql1 += ' 		            WHERE  1=1             ' + char(10)
            SELECT @v_dSql1 += ' 		            AND	A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql1 += ' 		            AND  A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
            SELECT @v_dSql1 += ' 		            AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
            SELECT @v_dSql1 += ' 		            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql1 += ' 		                    ,A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.LINE_NAME ' + char(10)
            SELECT @v_dSql1 += ' 		                    ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
            SELECT @v_dSql1 += ' 		                    ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET   ' + char(10)
            SELECT @v_dSql1 += ' 		                    ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, A.CUSTOMER_ID ' + char(10)
			
			SELECT @v_dSql1 += ' if object_id(''tempdb..#MAIN_P'') is not null ' + char(10)
			SELECT @v_dSql1 += ' DROP TABLE #MAIN_P ' + char(10)

			SELECT @v_dSql1 += ' -- WITH MAIN_P AS ( ' + char(10)
			SELECT @v_dSql1 += ' 		SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '           , LOCATION, OPERATION_ID                                   ' + char(10)
			SELECT @v_dSql1 += '           , LINE_ID, LINE_NAME, ELECTRODE_TYPE, EQUIPMENT_ID         ' + char(10)
			SELECT @v_dSql1 += '           , CELL_GROUP_CODE, CELL_GROUP, ITEM_ID, TOP_ITEM_ID, NICK_NAME, ITEM_TYPE ' + char(10)
			SELECT @v_dSql1 += '           , PRODUCTION_TYPE, MARKET, CUSTOMER_ID                                    ' + char(10)
			SELECT @v_dSql1 += '           , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(BOH_QTY,0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(HOLD_QTY,0) AS MONEY),1),''.00'','''') + '')'' AS BOH_QTY ' + char(10)
			SELECT @v_dSql1 += '           , CAST(AGING_LEAD_TIME as float) AGING_LEAD_TIME                ' + char(10)
			SELECT @v_dSql1 += '           , CAST(FORMATION_TOTAL_YIELD as float) AS FORMATION_TOTAL_YIELD ' + char(10)
			SELECT @v_dSql1 += '           , SHORTER_LEAD_TIME                                             ' + char(10)
			SELECT @v_dSql1 += '           , CATEGORY_NAME                                                 ' + char(10)

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

			                SELECT @v_tmp1 += '           , M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

                             SELECT @v_tmp2 += '           , W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)			                 
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                             SELECT @v_tmp3 += '           , D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)	
			             END 

				END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '           , CATEGORY_ID    ' + char(10)	
			SELECT @v_dSql1 += '           , CATEGORY_ORDER ' + char(10)	
			SELECT @v_dSql1 += '           , DATA_TYPE      ' + char(10)	
			SELECT @v_dSql1 += '           , (CASE WHEN CATEGORY_ID = ''P_OUT'' THEN 1 ELSE NULL END) AS S_ROW ' + char(10)	
			SELECT @v_dSql1 += ' 		INTO #MAIN_P        ' + char(10)
			SELECT @v_dSql1 += ' 		FROM (              ' + char(10)
			SELECT @v_dSql1 += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)	
			SELECT @v_dSql1 += ' 		         , A.LOCATION, A.OPERATION_ID                                         ' + char(10)
			SELECT @v_dSql1 += ' 		         , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, ''-'' AS EQUIPMENT_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		         , A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql1 += ' 		         , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += ' 		         , ISNULL(MAX(F.QTY),0) AS BOH_QTY, ISNULL(MAX(F.HOLD_QTY),0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		         , A.CUSTOMER_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		         , ''P'' AS PSI      ' + char(10)
			SELECT @v_dSql1 += ' 		         , H.AGING_LEAD_TIME ' + char(10)
			SELECT @v_dSql1 += ' 		         , ROUND(J.YIELD*100,2) AS FORMATION_TOTAL_YIELD ' + char(10)
			SELECT @v_dSql1 += ' 		         , I.SHORTER_LT AS SHORTER_LEAD_TIME             ' + char(10)
			SELECT @v_dSql1 += ' 		         , D.CATE_NAME AS CATEGORY_NAME                  ' + char(10)
			
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

			                SELECT @v_tmp1 += ' 		         , SUM(CASE WHEN G.YYYYMM ='''+ @v_month_info +''' THEN (CASE WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY WHEN D.CATE_ID = ''P_WIP'' THEN A.AGING_WIP WHEN D.CATE_ID = ''P_ACT'' THEN A.ACTIVATED WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY WHEN D.CATE_ID = ''P_WIP_BD'' THEN A.AGING_WIP_BD WHEN D.CATE_ID = ''P_WIP_AD'' THEN A.AGING_WIP_AD WHEN D.CATE_ID = ''P_AGINGWIPSIM'' THEN A.AGING_WIP_SIM WHEN D.CATE_ID = ''P_AGINGWIPSIM_BD'' THEN A.AGING_WIP_SIM_BD WHEN D.CATE_ID = ''P_AGINGWIPSIM_AD'' THEN A.AGING_WIP_SIM_AD WHEN D.CATE_ID = ''P_PKGPLANDATE'' THEN A.PKG_PLAN_DATE WHEN D.CATE_ID = ''P_ACTSIM'' THEN A.ACTIVATED_SIM WHEN D.CATE_ID = ''M_IN'' THEN A.MPP_IN_QTY WHEN D.CATE_ID = ''M_OUT'' THEN A.MPP_OUT_QTY WHEN D.CATE_ID = ''W_IN'' THEN A.WPP_IN_QTY WHEN D.CATE_ID = ''W_OUT'' THEN A.WPP_OUT_QTY WHEN D.CATE_ID = ''P_PKGQTY'' THEN A.PKG_QTY ELSE 0 END ) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += ' 		         , SUM(CASE WHEN G.ISO_YYYYWW='''+ @v_week_info +''' THEN (CASE WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY WHEN D.CATE_ID = ''P_WIP'' THEN A.AGING_WIP_WEEK WHEN D.CATE_ID = ''P_ACT'' THEN A.ACTIVATED_WEEK WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY WHEN D.CATE_ID = ''P_WIP_BD'' THEN A.AGING_WIP_BD_WEEK WHEN D.CATE_ID = ''P_WIP_AD'' THEN A.AGING_WIP_AD_WEEK WHEN D.CATE_ID = ''P_AGINGWIPSIM'' THEN A.AGING_WIP_SIM_WEEK WHEN D.CATE_ID = ''P_AGINGWIPSIM_BD'' THEN A.AGING_WIP_SIM_BD_WEEK WHEN D.CATE_ID = ''P_AGINGWIPSIM_AD'' THEN A.AGING_WIP_SIM_AD_WEEK WHEN D.CATE_ID = ''P_PKGPLANDATE'' THEN A.PKG_PLAN_DATE WHEN D.CATE_ID = ''P_ACTSIM'' THEN A.ACTIVATED_SIM_WEEK WHEN D.CATE_ID = ''M_IN'' THEN A.MPP_IN_QTY WHEN D.CATE_ID = ''M_OUT'' THEN A.MPP_OUT_QTY WHEN D.CATE_ID = ''W_IN'' THEN A.WPP_IN_QTY WHEN D.CATE_ID = ''W_OUT'' THEN A.WPP_OUT_QTY WHEN D.CATE_ID = ''P_PKGQTY'' THEN A.PKG_QTY ELSE 0 END ) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += ' 		         , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN (CASE WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY WHEN D.CATE_ID = ''P_WIP'' THEN A.AGING_WIP WHEN D.CATE_ID = ''P_ACT'' THEN A.ACTIVATED WHEN D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY WHEN D.CATE_ID = ''P_WIP_BD'' THEN A.AGING_WIP_BD WHEN D.CATE_ID = ''P_WIP_AD'' THEN A.AGING_WIP_AD WHEN D.CATE_ID = ''P_AGINGWIPSIM'' THEN A.AGING_WIP_SIM WHEN D.CATE_ID = ''P_AGINGWIPSIM_BD'' THEN A.AGING_WIP_SIM_BD WHEN D.CATE_ID = ''P_AGINGWIPSIM_AD'' THEN A.AGING_WIP_SIM_AD WHEN D.CATE_ID = ''P_PKGPLANDATE'' THEN A.PKG_PLAN_DATE WHEN D.CATE_ID = ''P_ACTSIM'' THEN A.ACTIVATED_SIM WHEN D.CATE_ID = ''M_IN'' THEN A.MPP_IN_QTY WHEN D.CATE_ID = ''M_OUT'' THEN A.MPP_OUT_QTY WHEN D.CATE_ID = ''W_IN'' THEN A.WPP_IN_QTY WHEN D.CATE_ID = ''W_OUT'' THEN A.WPP_OUT_QTY WHEN D.CATE_ID = ''P_PKGQTY'' THEN A.PKG_QTY ELSE 0 END ) ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 
				END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += ' 		         , D.CATE_ID AS CATEGORY_ID       ' + char(10)
			SELECT @v_dSql1 += ' 		         , D.CATE_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ' 		         , ''DATA'' AS DATA_TYPE          ' + char(10)
			SELECT @v_dSql1 += ' 		         , NULL AS S_ROW                  ' + char(10)
			SELECT @v_dSql1 += ' 		       FROM #temp_table_1 A                ' + char(10)
			SELECT @v_dSql1 += ' 		       INNER JOIN (           ' + char(10)
			SELECT @v_dSql1 += ' 		                   SELECT * FROM ( ' + char(10)
			
			SELECT @v_dSql1 += @pSql		            
			
			SELECT @v_dSql1 += ' 		                  	) A                    ' + char(10)
			SELECT @v_dSql1 += ' 		                  	WHERE CATE_ID <> ''X'' ' + char(10)
			SELECT @v_dSql1 += ' 		       ) D                    ' + char(10)
			SELECT @v_dSql1 += ' 		       ON   1=1               ' + char(10)
			SELECT @v_dSql1 += ' 		       LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql1 += ' 		             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                  , A.ITEM_ID, A.TOP_ITEM_ID                       ' + char(10)
			SELECT @v_dSql1 += ' 		                  , SUM(A.QTY) AS QTY, SUM(A.HOLD_QTY) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		             FROM (                                                ' + char(10)
			SELECT @v_dSql1 += ' 		                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                       , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY, ISNULL(A.HOLD_QTY,0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		                  FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_cutoff_boh_table) +'  A WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql1 += ' 		                  WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		                  AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql1 += ' 		             ) A                                                   ' + char(10)
			SELECT @v_dSql1 += ' 		             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                  , A.ITEM_ID, A.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		       ) F                                       ' + char(10)
			SELECT @v_dSql1 += ' 		       ON     A.COMPANY_ID   = F.COMPANY_ID      ' + char(10)
			SELECT @v_dSql1 += ' 		       AND    A.DIVISION_ID  = F.DIVISION_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		       AND    A.SITE_ID      = F.SITE_ID         ' + char(10)
			SELECT @v_dSql1 += ' 		       AND    A.PLANT_ID     = F.PLANT_ID        ' + char(10)
			SELECT @v_dSql1 += ' 		       AND    A.OPERATION_ID = F.OPERATION_ID    ' + char(10)
			SELECT @v_dSql1 += ' 		       AND    A.ITEM_ID      = F.ITEM_ID         ' + char(10)
			SELECT @v_dSql1 += ' 		       AND    A.TOP_ITEM_ID  = F.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql1 += ' 		       INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		       ON  A.PLAN_DATE       = G.DT              ' + char(10)
			SELECT @v_dSql1 += ' 		       LEFT OUTER HASH JOIN (                    ' + char(10)
			SELECT @v_dSql1 += ' 		             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID         ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.FACTORY_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.LINE_ID                   ' + char(10)
			SELECT @v_dSql1 += ' 		                 , A.ELECTRODE_TYPE            ' + char(10)
			SELECT @v_dSql1 += ' 		                 , MAX(A.AGING_LEAD_TIME) AS AGING_LEAD_TIME  ' + char(10)
			SELECT @v_dSql1 += ' 		             FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		             WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		             AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql1 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		                 AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += ' 		             AND  A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))       + char(10)
			SELECT @v_dSql1 += ' 		             AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		             AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END
            SELECT @v_dSql1 += ' 		             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql1 += ' 		                , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql1 += ' 		        ) H                                         ' + char(10)
            SELECT @v_dSql1 += ' 		        ON    A.COMPANY_ID      = H.COMPANY_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.DIVISION_ID     = H.DIVISION_ID     ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.SITE_ID         = H.SITE_ID         ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.PLANT_ID        = H.PLANT_ID        ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.TOP_ITEM_ID     = H.TOP_ITEM_ID     ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.ITEM_ID         = H.ITEM_ID         ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.OPERATION_ID    = H.OPERATION_ID    ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.FACTORY_ID      = H.FACTORY_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.LOCATION        = H.LOCATION        ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.PRODUCTION_TYPE = H.PRODUCTION_TYPE ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.MARKET          = H.MARKET          ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.LINE_ID         = H.LINE_ID         ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.ELECTRODE_TYPE  = H.ELECTRODE_TYPE  ' + char(10)
            SELECT @v_dSql1 += ' 		        LEFT OUTER HASH JOIN FP_FORMATION_SHORTER_LT_M I WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += ' 		        ON    A.COMPANY_ID      = I.COMPANY_ID   ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.DIVISION_ID     = I.DIVISION_ID  ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.SITE_ID         = I.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.PLANT_ID        = I.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.FACTORY_ID      = I.FACTORY_ID   ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.OPERATION_ID    = I.OPERATION_ID ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.LINE_ID         = I.LINE_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.ITEM_ID         = I.ITEM_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        LEFT OUTER HASH JOIN SCM_YIELD_M J WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += ' 		        ON    A.COMPANY_ID      = J.COMPANY_ID   ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.DIVISION_ID     = J.DIVISION_ID  ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.SITE_ID         = J.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.PLANT_ID        = J.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.FACTORY_ID      = J.FACTORY_ID   ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.OPERATION_ID    = J.OPERATION_ID ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.LINE_ID         = J.LINE_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   A.ITEM_ID         = J.ITEM_ID      ' + char(10)
            SELECT @v_dSql1 += ' 		        AND   J.MONTH		     = CONVERT(VARCHAR(6), '''+ @p_plan_date +''') ' + char(10)
            SELECT @v_dSql1 += ' 		        WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		        AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql1 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += ' 		        AND  A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql1 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))       + char(10)
			SELECT @v_dSql1 += ' 		        AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		        AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END			

			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql1 += ' 		        AND  A.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END			
			SELECT @v_dSql1 += ' 		        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		            , A.LOCATION, A.OPERATION_ID                 ' + char(10)
			SELECT @v_dSql1 += ' 		            , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE   ' + char(10)
			SELECT @v_dSql1 += ' 		            , A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql1 += ' 		            , A.PRODUCTION_TYPE, A.MARKET, A.CUSTOMER_ID ' + char(10)
			SELECT @v_dSql1 += ' 		            , H.AGING_LEAD_TIME                          ' + char(10)
			SELECT @v_dSql1 += ' 		            , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER       ' + char(10)
			SELECT @v_dSql1 += ' 		            , I.SHORTER_LT, J.YIELD                      ' + char(10)
			SELECT @v_dSql1 += ' 		      ) AA                                               ' + char(10)
			SELECT @v_dSql1 += ' 		      option (force order)                               ' + char(10)
			SELECT @v_dSql1 += ' 		-- )                                                        ' + char(10)

		    SELECT @v_dSql2  = ''
		    SELECT @v_dSql2  = '------------------------------------v_dSql2-----------------------------' + char(10)
            SELECT @v_dSql2 += ' 		if object_id(''tempdb..#MAIN_S'') is not null ' + char(10)
			SELECT @v_dSql2 += ' 		DROP TABLE #MAIN_S ' + char(10)
			
			SELECT @v_dSql2 += ' 		--, MAIN_S AS (  ' + char(10)
            SELECT @v_dSql2 += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql2 += ' 		          , A.LOCATION, A.OPERATION_ID                                        ' + char(10)
            SELECT @v_dSql2 += ' 		          , A.LINE_ID, E.LINE_NAME, A.ELECTRODE_TYPE, ''-'' AS EQUIPMENT_ID   ' + char(10)
            SELECT @v_dSql2 += ' 		          , A.CELL_GROUP_CODE, A.CELL_GROUP, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
            SELECT @v_dSql2 += ' 		          , A.PRODUCTION_TYPE, A.MARKET, ''-'' AS CUSTOMER_ID                 ' + char(10)
            SELECT @v_dSql2 += ' 		          , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(MAX(F.QTY),0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(MAX(F.HOLD_QTY),0) AS MONEY),1),''.00'','''') + '')'' AS BOH_QTY ' + char(10)
            SELECT @v_dSql2 += ' 		          , H.AGING_LEAD_TIME                             ' + char(10)
            SELECT @v_dSql2 += ' 		          , ROUND(J.YIELD*100,2) AS FORMATION_TOTAL_YIELD ' + char(10)
            SELECT @v_dSql2 += ' 		          , I.SHORTER_LT AS SHORTER_LEAD_TIME             ' + char(10)
            SELECT @v_dSql2 += ' 		          , ''Target'' AS CATEGORY_NAME                   ' + char(10)
			
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

			                SELECT @v_tmp1 += ' 		          , SUM(CASE WHEN G.YYYYMM='''+ @v_month_info +''' THEN A.SALES_QTY ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
                             SELECT @v_tmp1 += ' 		          , SUM(CASE WHEN G.ISO_YYYYWW='''+ @v_week_info +''' THEN A.SALES_QTY ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
                         END

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

                             SELECT @v_tmp1 += ' 		          , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN A.SALES_QTY ELSE 0 END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 
				END

            SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 + @v_tmp2 + @v_tmp3

            SELECT @v_dSql2 += ' 		          , ''TARGET'' AS CATEGORY_ID ' + char(10)
            SELECT @v_dSql2 += ' 		          , -10 AS CATEGORY_ORDER     ' + char(10)
            SELECT @v_dSql2 += ' 		          , ''DATA'' AS DATA_TYPE     ' + char(10)
            SELECT @v_dSql2 += ' 		          , NULL AS S_ROW             ' + char(10)
			SELECT @v_dSql2 += ' 		     INTO #MAIN_S                     ' + char(10)
            SELECT @v_dSql2 += ' 		     FROM (                           ' + char(10)
            SELECT @v_dSql2 += ' 		           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql2 += ' 		               , A.CELL_GROUP_CODE, A.CELL_GROUP, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
            SELECT @v_dSql2 += ' 		               , C.ITEM_TYPE, C.NICK_NAME                     ' + char(10)
            SELECT @v_dSql2 += ' 		               , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE  ' + char(10)
            SELECT @v_dSql2 += ' 		               , A.LOCATION, A.PRODUCTION_TYPE, A.MARKET      ' + char(10)
            SELECT @v_dSql2 += ' 		               , ISNULL(B.PLAN_DATE,'''+ @p_plan_date +''') AS PLAN_DATE ' + char(10)
            SELECT @v_dSql2 += ' 		               , ISNULL(B.SALES_QTY,0) AS SALES_QTY           ' + char(10)
            SELECT @v_dSql2 += ' 		           FROM (                                             ' + char(10)
            SELECT @v_dSql2 += ' 		                 -- p info ' + char(10)
            SELECT @v_dSql2 += ' 		                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql2 += ' 		                     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.ITEM_ID, A.CELL_GROUP_CODE, J.CELL_GROUP, A.TOP_ITEM_ID ' + char(10)
            SELECT @v_dSql2 += ' 		                     , A.PRODUCTION_TYPE, A.MARKET                                 ' + char(10)
            SELECT @v_dSql2 += ' 		                 FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +'  A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += ' 		                 INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)  ' + char(10)
            SELECT @v_dSql2 += ' 		                 ON    A.COMPANY_ID  = J.COMPANY_ID              ' + char(10)
            SELECT @v_dSql2 += ' 		                 AND   A.DIVISION_ID = J.DIVISION_ID             ' + char(10)
            SELECT @v_dSql2 += ' 		                 AND   A.SITE_ID     = J.SITE_ID                 ' + char(10)
            SELECT @v_dSql2 += ' 		                 AND   A.TOP_ITEM_ID = J.ITEM_ID                 ' + char(10)
            SELECT @v_dSql2 += ' 		                 WHERE A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql2 += ' 		                 AND   A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += ' 		                 '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		                 AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		                 '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		                 '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql2 += ' 		                 AND  A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		                 '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))       + char(10)
			SELECT @v_dSql2 += ' 		                 AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql2 += ' 		                 AND  ( A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.AVAILABILITY IS NOT NULL OR ISNULL(A.AGING_WIP,0) <> 0  )' + char(10)
			
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END			
		    IF (LEN(@p_cell_group) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND  J.CELL_GROUP  LIKE ''%'' + '''+ @p_cell_group +''' + ''%'' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		             ) A          ' + char(10)
			SELECT @v_dSql2 += ' 		             INNER HASH JOIN ( ' + char(10)
			SELECT @v_dSql2 += ' 		                   -- S   ' + char(10)
			SELECT @v_dSql2 += ' 		                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                       , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		                       , A.OPERATION_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql2 += ' 		                       , A.PRODUCTION_TYPE, A.MARKET   ' + char(10)
			SELECT @v_dSql2 += ' 		                       , A.PLAN_DATE                   ' + char(10)
			SELECT @v_dSql2 += ' 		                       , MAX(A.SALES_QTY) AS SALES_QTY ' + char(10)
			SELECT @v_dSql2 += ' 		                   FROM  '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		             WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +'''   ' + char(10)
			SELECT @v_dSql2 += ' 		             AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''       ' + char(10)
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		             AND  A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		             AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql2 += ' 		             AND  (A.FACTORY_ID = ''-'' AND A.SALES_QTY <> 0) ' + char(10)

			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END			
			SELECT @v_dSql2 += ' 		             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID           ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.OPERATION_ID, A.LOCATION  ' + char(10)     
			SELECT @v_dSql2 += ' 		                 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql2 += ' 		             -- p 0 qty        ' + char(10)
			SELECT @v_dSql2 += ' 		             UNION ALL         ' + char(10)
			SELECT @v_dSql2 += ' 		             SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.OPERATION_ID, A.LOCATION  ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.PLAN_DATE                 ' + char(10)
			SELECT @v_dSql2 += ' 		                 , 0 AS SALES_QTY              ' + char(10)
			SELECT @v_dSql2 += ' 		             FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		             WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		             AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))    + char(10)
			SELECT @v_dSql2 += ' 		             AND  A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		             '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))    + char(10)
			SELECT @v_dSql2 += ' 		             AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql2 += ' 		             AND  ( A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.AVAILABILITY IS NOT NULL OR ISNULL(A.AGING_WIP,0) <> 0 ) ' + char(10)

			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		             AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END	
			SELECT @v_dSql2 += ' 		        ) B                                        ' + char(10)
			SELECT @v_dSql2 += ' 		        ON  A.COMPANY_ID      = B.COMPANY_ID       ' + char(10)
			SELECT @v_dSql2 += ' 		        AND A.DIVISION_ID     = B.DIVISION_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		        AND A.SITE_ID         = B.SITE_ID          ' + char(10)
			SELECT @v_dSql2 += ' 		        AND A.PLANT_ID        = B.PLANT_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		        AND A.OPERATION_ID    = B.OPERATION_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		        AND A.ITEM_ID         = B.ITEM_ID          ' + char(10)
			SELECT @v_dSql2 += ' 		        AND A.CELL_GROUP_CODE = B.CELL_GROUP_CODE  ' + char(10)
			SELECT @v_dSql2 += ' 		        INNER HASH JOIN (                          ' + char(10)
			SELECT @v_dSql2 += ' 		              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, ' + char(10)
			SELECT @v_dSql2 += ' 		                  (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql2 += ' 		                        WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql2 += ' 		                    ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
			SELECT @v_dSql2 += ' 		                   ISNULL(A.NICK_NAME,''-'') AS NICK_NAME  ' + char(10)
			SELECT @v_dSql2 += ' 		              FROM	 SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		              WHERE	 A.ITEM_CLASS  = C.CLASS_ID            ' + char(10)
			SELECT @v_dSql2 += ' 		              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		              AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		              AND  A.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END	
			IF (LEN(@p_nick_name_lt) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		              '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(A.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt))    + char(10)
				END 
			SELECT @v_dSql2 += ' 		         ) C                                ' + char(10)
			SELECT @v_dSql2 += ' 		         ON   A.COMPANY_ID  = C.COMPANY_ID  ' + char(10)
			SELECT @v_dSql2 += ' 		         AND  A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += ' 		         AND  A.SITE_ID     = C.SITE_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		         AND  A.ITEM_ID     = C.ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		     ) A      ' + char(10)
			SELECT @v_dSql2 += ' 		     LEFT OUTER HASH JOIN SCM_LINE_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		     ON   1=1 ' + char(10)
			SELECT @v_dSql2 += ' 		     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		     AND  E.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
            SELECT @v_dSql2 += ' 		     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql2 += ' 		     AND  E.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.LINE_ID' , 'EQ', @p_line_id))    + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.COMPANY_ID     = E.COMPANY_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.DIVISION_ID    = E.DIVISION_ID    ' + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.SITE_ID        = E.SITE_ID        ' + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.PLANT_ID       = E.PLANT_ID       ' + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.FACTORY_ID     = E.FACTORY_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.OPERATION_ID   = E.OPERATION_ID   ' + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.LINE_ID        = E.LINE_ID        ' + char(10)
			SELECT @v_dSql2 += ' 		     AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		     LEFT OUTER HASH JOIN (                    ' + char(10)
			SELECT @v_dSql2 += ' 		           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID        ' + char(10)
			SELECT @v_dSql2 += ' 		                , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql2 += ' 		                , A.FACTORY_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql2 += ' 		                , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql2 += ' 		                , A.LINE_ID                   ' + char(10)
			SELECT @v_dSql2 += ' 		                , A.ELECTRODE_TYPE            ' + char(10)
			SELECT @v_dSql2 += ' 		                , MAX(A.AGING_LEAD_TIME) AS AGING_LEAD_TIME ' + char(10)
			SELECT @v_dSql2 += ' 		           FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		           WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		           AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
            SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql2 += ' 		           AND  A.OPERATION_ID = '''+ @p_operation_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))    + char(10)
			SELECT @v_dSql2 += ' 		           AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)

			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql2 += ' 		           AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END	
			SELECT @v_dSql2 += ' 		           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		       ) H                                          ' + char(10)
			SELECT @v_dSql2 += ' 		       ON     A.COMPANY_ID      = H.COMPANY_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.DIVISION_ID     = H.DIVISION_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.SITE_ID         = H.SITE_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.PLANT_ID        = H.PLANT_ID        ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.TOP_ITEM_ID     = H.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.ITEM_ID         = H.ITEM_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.OPERATION_ID    = H.OPERATION_ID    ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.FACTORY_ID      = H.FACTORY_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.LOCATION        = H.LOCATION        ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.PRODUCTION_TYPE = H.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.MARKET          = H.MARKET          ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.LINE_ID         = H.LINE_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.ELECTRODE_TYPE  = H.ELECTRODE_TYPE  ' + char(10)
			SELECT @v_dSql2 += ' 		       LEFT OUTER HASH JOIN FP_FORMATION_SHORTER_LT_M I WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		       ON     A.COMPANY_ID      = I.COMPANY_ID    ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.DIVISION_ID     = I.DIVISION_ID   ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.SITE_ID         = I.SITE_ID       ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.PLANT_ID        = I.PLANT_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.FACTORY_ID      = I.FACTORY_ID    ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.OPERATION_ID    = I.OPERATION_ID  ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.LINE_ID         = I.LINE_ID       ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.ITEM_ID         = I.ITEM_ID       ' + char(10)
			SELECT @v_dSql2 += ' 		       LEFT OUTER HASH JOIN SCM_YIELD_M J WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		       ON     A.COMPANY_ID      = J.COMPANY_ID   ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.DIVISION_ID     = J.DIVISION_ID  ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.SITE_ID         = J.SITE_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.PLANT_ID        = J.PLANT_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.FACTORY_ID      = J.FACTORY_ID   ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.OPERATION_ID    = J.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.LINE_ID         = J.LINE_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.ITEM_ID         = J.ITEM_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		       AND	   J.MONTH			 = CONVERT(VARCHAR(6), '''+ @p_plan_date +''') ' + char(10)
			SELECT @v_dSql2 += ' 		       LEFT OUTER HASH JOIN (                    ' + char(10)
			SELECT @v_dSql2 += ' 		             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                 , A.ITEM_ID, A.TOP_ITEM_ID                       ' + char(10)
			SELECT @v_dSql2 += ' 		                 , SUM(A.QTY) AS QTY, SUM(A.HOLD_QTY) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql2 += ' 		             FROM (                                               ' + char(10)
			SELECT @v_dSql2 += ' 		                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += ' 		                   		, A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY, ISNULL(A.HOLD_QTY,0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql2 += ' 		                   FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_cutoff_boh_table) +' A WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql2 += ' 		                   WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql2 += ' 		                   AND    A.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql2 += ' 		             ) A                                                    ' + char(10)
			SELECT @v_dSql2 += ' 		             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += ' 		             		, A.ITEM_ID, A.TOP_ITEM_ID   ' + char(10)
			SELECT @v_dSql2 += ' 		       ) F                                       ' + char(10)
			SELECT @v_dSql2 += ' 		       ON     A.COMPANY_ID   = F.COMPANY_ID      ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.DIVISION_ID  = F.DIVISION_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.SITE_ID      = F.SITE_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.PLANT_ID     = F.PLANT_ID        ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.OPERATION_ID = F.OPERATION_ID    ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.ITEM_ID      = F.ITEM_ID         ' + char(10)
			SELECT @v_dSql2 += ' 		       AND    A.TOP_ITEM_ID  = F.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += ' 		       INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += ' 		       ON  A.PLAN_DATE       = G.DT              ' + char(10)
			SELECT @v_dSql2 += ' 		       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
			SELECT @v_dSql2 += ' 		           , A.LOCATION, A.OPERATION_ID, A.LINE_ID, E.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		           , A.CELL_GROUP_CODE, A.CELL_GROUP, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql2 += ' 		           , A.PRODUCTION_TYPE, A.MARKET                           ' + char(10)
			SELECT @v_dSql2 += ' 		           , H.AGING_LEAD_TIME, ROUND(J.YIELD*100,2), I.SHORTER_LT ' + char(10)
			SELECT @v_dSql2 += ' 		  ; -- ) ' + char(10)

			SELECT @v_dSql3  = ''
		    SELECT @v_dSql3  = '------------------------------------v_dSql3-----------------------------' + char(10)
            SELECT @v_dSql3 += ' 		WITH CAPA_VALUE AS ( ' + char(10)
            SELECT @v_dSql3 += ' 		      SELECT *    ' + char(10)
            SELECT @v_dSql3 += ' 		      FROM (      ' + char(10)
            SELECT @v_dSql3 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql3 += ' 		                 , '''+ @p_bucket_from +''' AS PLAN_DATE ' + char(10)
            SELECT @v_dSql3 += ' 		                 , NULL AS OFF_TIME                      ' + char(10)
            SELECT @v_dSql3 += ' 		                 , NULL AS SETUP_TIME                    ' + char(10)
            SELECT @v_dSql3 += ' 		                 , NULL AS UTILIZATION                   ' + char(10)
            SELECT @v_dSql3 += ' 		            FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql3 += ' 		            INNER JOIN SCM_ITEM_M B WITH(NOLOCK)               ' + char(10)
            SELECT @v_dSql3 += ' 		            ON     A.COMPANY_ID     = B.COMPANY_ID             ' + char(10)
            SELECT @v_dSql3 += ' 		            AND    A.DIVISION_ID    = B.DIVISION_ID            ' + char(10)
            SELECT @v_dSql3 += ' 		            AND    A.SITE_ID        = B.SITE_ID                ' + char(10)
            SELECT @v_dSql3 += ' 		            AND    A.ITEM_ID        = B.ITEM_ID                ' + char(10)
            SELECT @v_dSql3 += ' 		            WHERE  INSTANCE_ID      = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql3 += ' 		            AND    FP_PLAN_ID       = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		           AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
            SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))    + char(10)
			SELECT @v_dSql3 += ' 		            AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)

			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		            AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END	
			--IF (LEN(@p_nick_name) > 0)
			--    BEGIN
   --                 SELECT @v_dSql3 += ' 		            AND  A.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			--	END	
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		            AND  A.PRODUCTION_TYPE LIKE  ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END	
			SELECT @v_dSql3 += ' 		            AND	A.OUT_QTY > 0 ' + char(10)
			SELECT @v_dSql3 += ' 		            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		            UNION ALL          ' + char(10)
			SELECT @v_dSql3 += ' 		            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, NULL AS EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		                 , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql3 += ' 		                 , SUM(A.OFF_TIME) AS OFF_TIME                     ' + char(10)
			SELECT @v_dSql3 += ' 		                 , SUM(A.SETUP_TIME) AS SETUP_TIME                 ' + char(10)
			SELECT @v_dSql3 += ' 		                 , AVG(A.UTILIZATION) AS UTILIZATION               ' + char(10)
			SELECT @v_dSql3 += ' 		            FROM   '+ TRY_CONVERT(NVARCHAR, @p_amend_util_table) +' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += ' 		            WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql3 += ' 		            AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		            AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
            SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql3 += ' 		            '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))    + char(10)
			SELECT @v_dSql3 += ' 		            AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			SELECT @v_dSql3 += ' 		            AND   EXISTS (     ' + char(10)
			SELECT @v_dSql3 += ' 		                     SELECT 1 ' + char(10)
			SELECT @v_dSql3 += ' 		                     FROM   '+ TRY_CONVERT(NVARCHAR,@p_amend_table) +' AAA WITH(NOLOCK), SCM_ITEM_M BBB WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += ' 		                     WHERE  AAA.COMPANY_ID   = BBB.COMPANY_ID           ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    AAA.DIVISION_ID  = BBB.DIVISION_ID          ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    AAA.SITE_ID      = BBB.SITE_ID              ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    AAA.ITEM_ID      = BBB.ITEM_ID              ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.COMPANY_ID     = AAA.COMPANY_ID           ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.DIVISION_ID    = AAA.DIVISION_ID          ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.SITE_ID        = AAA.SITE_ID              ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.PLANT_ID       = AAA.PLANT_ID             ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.FACTORY_ID     = AAA.FACTORY_ID           ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.LOCATION       = AAA.LOCATION             ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.OPERATION_ID   = AAA.OPERATION_ID         ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.LINE_ID        = AAA.LINE_ID              ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    A.ELECTRODE_TYPE = AAA.ELECTRODE_TYPE       ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    AAA.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql3 += ' 		                     AND    AAA.FP_PLAN_ID   = '''+ @p_plan_id +'''     ' + char(10)
			SELECT @v_dSql3 += ' 		                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		                     AND  AAA.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
            SELECT @v_dSql3 += ' 		                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql3 += ' 		                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql3 += ' 		                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql3 += ' 		                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AAA.LINE_ID' , 'EQ', @p_line_id))    + char(10)
			SELECT @v_dSql3 += ' 		                     AND  CONVERT(VARCHAR,AAA.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +''' ' + char(10)
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		                     AND  AAA.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END	
			IF (LEN(@p_nick_name) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		                     AND  BBB.NICK_NAME LIKE  ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
				END	
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql3 += ' 		                     AND  AAA.PRODUCTION_TYPE LIKE  ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END	
			SELECT @v_dSql3 += ' 		                ) ' + char(10)
			SELECT @v_dSql3 += ' 		                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += ' 		                    , CONVERT(VARCHAR, A.PLAN_DATE, 112) ' + char(10)
			SELECT @v_dSql3 += ' 		            ) A   ' + char(10)
			
			IF( @bSubTotal != 'Y' )
			    BEGIN 
				    SELECT @v_dSql3 += ' 		            WHERE 1=0 ' + char(10)
				END
            SELECT @v_dSql3 += ' 		       ) ' + char(10)

            SELECT @v_dSql4  = ''		  
		    SELECT @v_dSql4  = '------------------------------------v_dSql4-----------------------------' + char(10)
            SELECT @v_dSql4 += ' 		  , T_MEMO AS (                                                 ' + char(10)
            SELECT @v_dSql4 += ' 		        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql4 += ' 		            , A.OPERATION_ID              ' + char(10)
            SELECT @v_dSql4 += ' 		            , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
            SELECT @v_dSql4 += ' 		            , A.EQUIPMENT_ID              ' + char(10)
            SELECT @v_dSql4 += ' 		            , A.ITEM_ID, A.TOP_ITEM_ID    ' + char(10)
            SELECT @v_dSql4 += ' 		            , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
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
                            SELECT @v_tmp1 += ' 		            , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)= ''' + @v_day_info + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_MO' + char(10)
                        END 
			    END

            SELECT @v_dSql4 +=  @v_tmp1

            SELECT @v_dSql4 += ' 		        FROM FP_AMEND_MEMO_M A WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql4 += ' 		        WHERE 1=1                                        ' + char(10)
            SELECT @v_dSql4 += ' 		        AND    A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql4 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			
			IF (LEN(@p_site_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += ' 		        AND  A.SITE_ID =  ''' + @p_site_id + ''' ' + char(10)
				END
            SELECT @v_dSql4 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql4 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql4 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql4 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))    + char(10)
			IF (LEN(@p_item_id) > 0)
			    BEGIN
                    SELECT @v_dSql4 += ' 		                     AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
				END	
			IF (LEN(@p_prod_type) > 0)
			    BEGIN
                    SELECT @v_dSql4 += ' 		                     AND  A.PRODUCTION_TYPE LIKE  ''%'' + '''+ @p_prod_type +''' + ''%'' ' + char(10)
				END	
			SELECT @v_dSql4 += ' 		        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql4 += ' 		            , A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql4 += ' 		            , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		            , A.EQUIPMENT_ID              ' + char(10)
			SELECT @v_dSql4 += ' 		            , A.ITEM_ID, A.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql4 += ' 		            , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += ' 		)          ' + char(10)
			SELECT @v_dSql4 += ' 		SELECT A.* ' + char(10)
			SELECT @v_dSql4 += ' 	        , DENSE_RANK() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		         ORDER BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.LINE_ID) AS LV1 ' + char(10)

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
			                SELECT @v_tmp1 += ' 	        , C.D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_MO' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_tmp2 += ' 	        ,	CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85'' ' + char(10)
                            SELECT @v_tmp2 += ' 	        		 WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2'' ' + char(10)
                            SELECT @v_tmp2 += ' 	        		 WHEN A.CATEGORY_ID=''P_OUT'' THEN  ' + char(10)
                            SELECT @v_tmp2 += ' 	        		           ( CASE WHEN  ''' + @v_day_info + '''  >= '''+ @p_plan_date +''' AND '''+ @p_plan_type +''' <> ''RELEASE'' AND  R.FACTORY_ID IS NOT NULL THEN ''#FFFF0055'' ' + char(10)
                            SELECT @v_tmp2 += ' 	        		             ELSE '''' END ) ' + char(10)
                            SELECT @v_tmp2 += ' 	        		 WHEN (A.CATEGORY_ID=''W_OUT'' OR A.CATEGORY_ID=''M_OUT'') THEN  ' + char(10)
                            SELECT @v_tmp2 += ' 	        		           ( CASE WHEN  ''' + @v_day_info + '''  >= E.CURR_DATE  AND '''+ @p_plan_type +''' = ''RELEASE'' AND  R.FACTORY_ID IS NOT NULL THEN ''#FFFF0055'' ' + char(10)
                            SELECT @v_tmp2 += ' 	        		             ELSE '''' END ) ' + char(10)
							SELECT @v_tmp2 += ' 	        		 ELSE '''' END AS D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'_BG ' + char(10)
                        END 
			    END

			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2
			SELECT @v_dSql4 += ' 	        , CASE  WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END AS EDIT_YN --CASE WHEN D.PRODUCTION_TYPE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS EDIT_YN ' + char(10)
			SELECT @v_dSql4 += ' 		FROM (                     ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT * FROM #MAIN_P ' + char(10)
			SELECT @v_dSql4 += ' 		      UNION ALL            ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT * FROM #MAIN_S ' + char(10)

			IF(@bTarget != 'Y')
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			    END 

			SELECT @v_dSql4 += ' 		      UNION ALL            ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS CUSTOMER_ID              ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS BOH_QTY, NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.CATEGORY_NAME ' + char(10)
			
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

			                SELECT @v_tmp1 += ' 		          , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += ' 		          , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += ' 		          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 
				END

            SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3
			SELECT @v_dSql4 += ' 		          , A.CATEGORY_ID          ' + char(10)
			SELECT @v_dSql4 += ' 		          , (CASE WHEN A.CATEGORY_ID=''M_IN'' THEN 630 WHEN A.CATEGORY_ID=''M_OUT'' THEN 633 WHEN A.CATEGORY_ID=''W_IN'' THEN 636 WHEN A.CATEGORY_ID=''W_OUT'' THEN 640 WHEN A.CATEGORY_ID=''P_IN'' THEN 650 WHEN A.CATEGORY_ID=''P_OUT'' THEN 700 WHEN A.CATEGORY_ID=''P_RESULT'' THEN 730 WHEN A.CATEGORY_ID=''P_WIP'' THEN 750 WHEN A.CATEGORY_ID=''P_MEMO'' THEN 810 ELSE 800 END) AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		          , ''TOTAL'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS S_ROW          ' + char(10)
			SELECT @v_dSql4 += ' 		      FROM   #MAIN_P A              ' + char(10)

			IF(@bSubTotal != 'Y')
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			    END
			ELSE
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=1	   ' + char(10)
			    END
			SELECT @v_dSql4 += ' 		      AND	A.CATEGORY_ID <> ''P_YIELD'' AND A.CATEGORY_ID <> ''P_PKGPLANDATE'' ' + char(10)
			SELECT @v_dSql4 += ' 		      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		         		,A.CATEGORY_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		      UNION ALL                                                   ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                     ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS CUSTOMER_ID                                       ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS BOH_QTY, NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.CATEGORY_NAME ' + char(10)
			
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

			                SELECT @v_tmp1 += ' 		          , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += ' 		          , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += ' 		          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 
				END

			SELECT @v_dSql4  = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql4 += ' 		            ,A.CATEGORY_ID           ' + char(10)
			SELECT @v_dSql4 += ' 		            ,620 AS CATEGORY_ORDER   ' + char(10)
			SELECT @v_dSql4 += ' 		            ,''TOTAL'' AS DATA_TYPE  ' + char(10)
			SELECT @v_dSql4 += ' 		            ,NULL AS S_ROW           ' + char(10)
			SELECT @v_dSql4 += ' 		      FROM   #MAIN_S A                ' + char(10)

			IF(@bSubTotal != 'Y' OR @bTarget != 'Y')
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			    END
			ELSE
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=1	   ' + char(10)
			    END

			SELECT @v_dSql4 += ' 		      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		            ,A.CATEGORY_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		      -- Off Calendar, Setup                                  ' + char(10)
			SELECT @v_dSql4 += ' 		      UNION ALL                                               ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID                     ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS CUSTOMER_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS BOH_QTY, NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql4 += ' 		          , B.CATEGORY_NAME AS CATEGORY_NAME                             ' + char(10)
			
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
							SELECT @v_tmp1 += ' 		          , SUM(CASE WHEN C.YYYYMM= ''' + @v_month_info + '''  THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + ' ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
							 SELECT @v_tmp2 += ' 		          , SUM(CASE WHEN C.ISO_YYYYWW= ''' + @v_week_info + '''  THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + ' ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
							 SELECT @v_tmp3 += ' 		          , SUM(CASE WHEN C.YYYYMMDD= ''' + @v_day_info + '''  THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS  D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + ' ' + char(10)

			             END 
				END

			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql4 += ' 		          , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		          , ''TOTAL'' AS DATA_TYPE          ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS S_ROW                   ' + char(10)
			SELECT @v_dSql4 += ' 		      FROM   CAPA_VALUE A                   ' + char(10)
			SELECT @v_dSql4 += ' 		      INNER JOIN (                          ' + char(10)
			SELECT @v_dSql4 += ' 		          SELECT ''OFF'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		          UNION ALL                            ' + char(10)
			SELECT @v_dSql4 += ' 		          SELECT ''SETUP'' AS CATEGORY_ID, ''M/C(min)'' AS CATEGORY_NAME, 500 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		      ) B                                       ' + char(10)
			SELECT @v_dSql4 += ' 		      ON 1=1                                    ' + char(10)
			SELECT @v_dSql4 += ' 		      INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += ' 		      ON  A.PLAN_DATE = C.YYYYMMDD              ' + char(10)
			IF(@bSubTotal != 'Y')
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			    END

			SELECT @v_dSql4 += ' 		      GROUP BY 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          	   ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		      -- Capa   ' + char(10)
			SELECT @v_dSql4 += ' 		      UNION ALL ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS CUSTOMER_ID              ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS BOH_QTY, NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql4 += ' 		          , ''Load(%)'' AS CATEGORY_NAME ' + char(10)
			
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
							SELECT @v_tmp1 += ' 		          , CEILING(AVG(CASE WHEN C.YYYYMM= ''' + @v_month_info + '''  THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_QTY ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
							 SELECT @v_tmp2 += ' 		          , CEILING(AVG(CASE WHEN C.ISO_YYYYWW= ''' + @v_week_info + '''  THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_QTY ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
							 SELECT @v_tmp3 += ' 		          , CEILING(AVG(CASE WHEN C.YYYYMMDD= ''' + @v_day_info + '''  THEN A.UTILIZATION ELSE NULL END)*100)/100 AS  D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_QTY ' + char(10)

			             END 
				END

			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql4 += ' 		          , ''CAPA'' AS CATEGORY_ID, 600 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		          , ''TOTAL'' AS DATA_TYPE              ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS S_ROW                       ' + char(10)
			SELECT @v_dSql4 += ' 		      FROM   CAPA_VALUE A                       ' + char(10)
			SELECT @v_dSql4 += ' 		      INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += ' 		      ON  A.PLAN_DATE = C.YYYYMMDD              ' + char(10)
			
			IF(@bSubTotal != 'Y')
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			    END
            ELSE
			    IF(@bCapa != 'Y')
			        BEGIN
			    	    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			        END

			SELECT @v_dSql4 += ' 		      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		      -- p : total ' + char(10)
			SELECT @v_dSql4 += ' 		      UNION ALL    ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS CUSTOMER_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS BOH_QTY, NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.CATEGORY_NAME ' + char(10)
			
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

			                SELECT @v_tmp1 += ' 		          , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += ' 		          , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += ' 		          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 
				END

            SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql4 += ' 		          , A.CATEGORY_ID            ' + char(10)
			SELECT @v_dSql4 += ' 		          , (CASE WHEN A.CATEGORY_ID=''M_IN'' THEN -740 WHEN A.CATEGORY_ID=''M_OUT'' THEN -730 WHEN A.CATEGORY_ID=''W_IN'' THEN -720 WHEN A.CATEGORY_ID=''W_OUT'' THEN -710 WHEN A.CATEGORY_ID=''P_IN'' THEN -700 WHEN A.CATEGORY_ID=''P_OUT'' THEN -600 WHEN A.CATEGORY_ID=''P_RESULT'' THEN -550 WHEN A.CATEGORY_ID=''P_WIP'' THEN -530 ELSE -500 END) AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += ' 		          , ''TOTAL_2'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS S_ROW            ' + char(10)
			SELECT @v_dSql4 += ' 		      FROM   #MAIN_P A                ' + char(10)
			
			IF(@bTotal != 'Y')
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			    END
			ELSE
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=1	   ' + char(10)
			    END

			SELECT @v_dSql4 += ' 		      AND	A.CATEGORY_ID <> ''P_YIELD'' AND A.CATEGORY_ID <> ''P_PKGPLANDATE'' ' + char(10)
			SELECT @v_dSql4 += ' 		      GROUP BY A.OPERATION_ID, A.CATEGORY_NAME, A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql4 += ' 		      UNION ALL                                               ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, A.OPERATION_ID AS OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS CELL_GROUP_CODE, NULL AS CELL_GROUP, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS PRODUCTION_TYPE, NULL AS MARKET, NULL AS CUSTOMER_ID ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS BOH_QTY, NULL AS AGING_LEAD_TIME, NULL AS FORMATION_TOTAL_YIELD, NULL AS SHORTER_LEAD_TIME ' + char(10)
			SELECT @v_dSql4 += ' 		          , A.CATEGORY_NAME ' + char(10)
			
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

			                SELECT @v_tmp1 += ' 		          , SUM(M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  M'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			            END 
			
			        SELECT @v_tmp2 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp2 += ' 		          , SUM(W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)

			             END 

			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			             BEGIN
			                 SELECT @mst_loop_cnt = @mst_loop_cnt + 1
			                 SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)
			                 
							 SELECT @v_tmp3 += ' 		          , SUM(D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +') AS  D'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' + char(10)
			             END 
				END

            SELECT @v_dSql4 = @v_dSql4 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql4 += ' 		          , A.CATEGORY_ID            ' + char(10)
			SELECT @v_dSql4 += ' 		          , -800 AS CATEGORY_ORDER   ' + char(10)
			SELECT @v_dSql4 += ' 		          , ''TOTAL_2'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		          , NULL AS S_ROW            ' + char(10)
			SELECT @v_dSql4 += ' 		      FROM   #MAIN_S A                ' + char(10)

			IF(@bSubTotal != 'Y' OR @bTarget != 'Y')
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=0	   ' + char(10)
			    END
			ELSE
			    BEGIN
				    SELECT @v_dSql4 += ' 		      WHERE 1=1	   ' + char(10)
			    END
			SELECT @v_dSql4 += ' 		      GROUP BY A.OPERATION_ID, A.CATEGORY_NAME, A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql4 += ' 		 ) A                                       ' + char(10)
			SELECT @v_dSql4 += ' 		 LEFT OUTER JOIN T_MEMO C WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql4 += ' 		 ON  A.COMPANY_ID      = C.COMPANY_ID      ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.DIVISION_ID     = C.DIVISION_ID     ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.SITE_ID         = C.SITE_ID         ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.PLANT_ID        = C.PLANT_ID        ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.FACTORY_ID      = C.FACTORY_ID      ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.OPERATION_ID    = C.OPERATION_ID    ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.LINE_ID         = C.LINE_ID         ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE  ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.MARKET          = C.MARKET          ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.TOP_ITEM_ID     = C.TOP_ITEM_ID     ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.ITEM_ID         = C.ITEM_ID         ' + char(10)
			SELECT @v_dSql4 += ' 		 LEFT OUTER JOIN                           ' + char(10)
			SELECT @v_dSql4 += ' 		 (                                         ' + char(10)
			SELECT @v_dSql4 += ' 		     SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
			SELECT @v_dSql4 += ' 		     WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
			SELECT @v_dSql4 += ' 		     AND    A.ACTIVE_FLAG = ''Y''          ' + char(10)
			SELECT @v_dSql4 += ' 		 ) D                                       ' + char(10)
			SELECT @v_dSql4 += ' 		 ON A.DIVISION_ID = D.DIVISION_ID          ' + char(10)
			SELECT @v_dSql4 += ' 		 AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		 AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = D.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		 LEFT OUTER JOIN  ' + char(10)
			SELECT @v_dSql4 += ' 		 (                ' + char(10)
			SELECT @v_dSql4 += ' 		     SELECT CONVERT(VARCHAR, dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
			SELECT @v_dSql4 += ' 		           - ( SELECT ISNULL(LLL2._DAY, CONVERT(NUMERIC,ISNULL(LLL.SEGMENT1,''0''))) AS _DAY ' + char(10)
			SELECT @v_dSql4 += ' 		               FROM   SCM_SYS_LOOKUP_VALUE LLL WITH(NOLOCK)                       ' + char(10)
			SELECT @v_dSql4 += ' 		               LEFT OUTER JOIN (                                                  ' + char(10)
			SELECT @v_dSql4 += ' 		                     SELECT CONVERT(NUMERIC,ISNULL(SEGMENT1,''0'')) AS _DAY       ' + char(10)
			SELECT @v_dSql4 += ' 		                     FROM   SCM_SYS_LOOKUP_VALUE LLL2 WITH(NOLOCK)                ' + char(10)
			SELECT @v_dSql4 += ' 		                     WHERE  LLL2.LOOKUP_TYPE_CODE = ''WPP_DAY_RANGE_BY_INSTANCE'' ' + char(10)
			SELECT @v_dSql4 += ' 		                     AND    LLL2.ACTIVE_FLAG = ''Y''                              ' + char(10)
			SELECT @v_dSql4 += ' 		                     AND    LLL2.SEGMENT2    = '''+ @p_instance_id +'''           ' + char(10)
			SELECT @v_dSql4 += ' 		               ) LLL2 ' + char(10)
			SELECT @v_dSql4 += ' 		               ON 1=1 ' + char(10)
			SELECT @v_dSql4 += ' 		               WHERE LLL.LOOKUP_TYPE_CODE = ''WPP_DAY_RANGE'') ,112) AS CURR_DATE ' + char(10)
			SELECT @v_dSql4 += ' 		 ) E              ' + char(10)
			SELECT @v_dSql4 += ' 		 ON 1=1           ' + char(10)
			SELECT @v_dSql4 += ' 		 LEFT OUTER JOIN  ' + char(10)
			SELECT @v_dSql4 += ' 		 (                ' + char(10)
			SELECT @v_dSql4 += ' 		      SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
			SELECT @v_dSql4 += ' 		      FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql4 += ' 		      WHERE	1=1                                        ' + char(10)
			SELECT @v_dSql4 += ' 		      AND    R.USER_ID      = '''+ @p_user_id +'''     ' + char(10)
			SELECT @v_dSql4 += ' 		      AND    R.SAVE_FLAG    = ''Y''                    ' + char(10)
			SELECT @v_dSql4 += ' 		      AND    R.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
			SELECT @v_dSql4 += ' 		 ) R      ' + char(10)
			SELECT @v_dSql4 += ' 		 ON   1=1 ' + char(10)
			SELECT @v_dSql4 += ' 		 AND  A.COMPANY_ID      = R.COMPANY_ID   ' + char(10)
			SELECT @v_dSql4 += ' 		 AND  A.DIVISION_ID     = R.DIVISION_ID  ' + char(10)
			SELECT @v_dSql4 += ' 		 AND  A.SITE_ID         = R.SITE_ID      ' + char(10)
			SELECT @v_dSql4 += ' 		 AND  A.PLANT_ID        = R.PLANT_ID     ' + char(10)
			SELECT @v_dSql4 += ' 		 AND  A.FACTORY_ID		= R.FACTORY_ID   ' + char(10)
			SELECT @v_dSql4 += ' 		 AND  A.OPERATION_ID    = R.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += ' 		 AND  A.LINE_ID         = R.LINE_ID	     ' + char(10)
			SELECT @v_dSql4 += ' 		 ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999 END) -- TOTAL : TOP ' + char(10)
			SELECT @v_dSql4 += ' 		     , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
			SELECT @v_dSql4 += ' 		     , A.LINE_ID                                                                    ' + char(10)
			SELECT @v_dSql4 += ' 		     , (CASE WHEN A.TOP_ITEM_ID IS NOT NULL THEN A.TOP_ITEM_ID ELSE ''ZZZZZ'' END)  ' + char(10)
			SELECT @v_dSql4 += ' 		     , A.OPERATION_ID DESC       ' + char(10)
			SELECT @v_dSql4 += ' 		     , A.EQUIPMENT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql4 += ' 		     , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += ' 		     , A.CATEGORY_ORDER                              ' + char(10)

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
		  	  	  --EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
		  	  END
        
		
			BEGIN
				IF OBJECT_ID('tempdb..#temp_table_1') IS NOT NULL
				DROP TABLE #temp_table_1
		    
				IF OBJECT_ID('tempdb..#MAIN_P') IS NOT NULL
				DROP TABLE #MAIN_P

				IF OBJECT_ID('tempdb..#MAIN_S') IS NOT NULL
				DROP TABLE #MAIN_S

			END
		
		
		END	--IF( END )
	/************************************************************************************************/
	/* SELECT인경우 :SELECT_TOTAL_VALUE                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_TOTAL_VALUE')
		BEGIN --ELSE IF(START)

			SELECT @v_dSql = ''
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
			--EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		END CATCH    


END --MAIN END

