

/*
 * Program ID   : PR_UI_FP00640_ILT_MODULE
 * Description  : Plan Amend Elec Post SHift 화면
 * Program History : 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/08/18   LJS				Initial 
 */


--CREATE
CREATE 
PROCEDURE [dbo].[PR_UI_FP00640_ILT_MODULE]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),

  @p_instance_id                NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_master_id                  NVARCHAR(MAX),
  @p_plan_date                  NVARCHAR(MAX),
  @p_plan_id                    NVARCHAR(MAX),
  @p_plan_type                  NVARCHAR(MAX),
  @p_model					    NVARCHAR(MAX),
  @p_module                     NVARCHAR(MAX),
  @p_cell					    NVARCHAR(MAX),
  @p_nick_name		            NVARCHAR(MAX),
  @p_bucket_from                NVARCHAR(MAX),
  @p_bucket_to                  NVARCHAR(MAX),
  @p_day_info                   NVARCHAR(MAX),
  @p_week_info                  NVARCHAR(MAX),
  @p_month_info                 NVARCHAR(MAX),
  @p_cate_info                  NVARCHAR(MAX),
  @p_cate_value                 NVARCHAR(MAX),
  @p_cate_type                  NVARCHAR(MAX),

  @p_amend_table                NVARCHAR(100),
  @p_total_table                NVARCHAR(100),

  @p_attribute_1                NVARCHAR(MAX), -- 충/방전 실적,계획,출하 있는 모델만 조회 옵션
  @p_attribute_2                NVARCHAR(MAX), -- CMA Assy 음수 모델만 조회 옵션
  @p_attribute_3                NVARCHAR(MAX), -- Waiting Charge 음수 모델만 조회 옵션
  @p_attribute_4                NVARCHAR(MAX),
  @p_attribute_5                NVARCHAR(MAX),
  @p_attribute_6                NVARCHAR(MAX),
  @p_attribute_7                NVARCHAR(MAX),
  @p_attribute_8                NVARCHAR(MAX),
  @p_attribute_9                NVARCHAR(MAX),
  @p_attribute_10               NVARCHAR(MAX)
  
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
    DECLARE @v_master_id                  NVARCHAR(MAX)
    DECLARE @v_plan_date                  NVARCHAR(MAX)
    DECLARE @v_plan_id                    NVARCHAR(MAX)
	DECLARE @v_plan_type                  NVARCHAR(MAX)
	DECLARE @v_model					  NVARCHAR(MAX)
    DECLARE @v_module                     NVARCHAR(MAX)
	DECLARE @v_cell						  NVARCHAR(MAX)
    DECLARE @v_nick_name                  NVARCHAR(MAX)
    DECLARE @v_bucket_from_date           NVARCHAR(MAX)
    DECLARE @v_bucket_to_date             NVARCHAR(MAX)
    DECLARE @v_day_info                   NVARCHAR(MAX)
    DECLARE @v_week_info                  NVARCHAR(MAX)
    DECLARE @v_month_info                 NVARCHAR(MAX)
    DECLARE @v_cate_info                  NVARCHAR(MAX)
	DECLARE @v_cate_value                 NVARCHAR(MAX)
    DECLARE @v_cate_type                  NVARCHAR(MAX)

    DECLARE @v_amend_table                NVARCHAR(100) = 'FP_AMEND_PLAN_P_FORM_R'
	DECLARE @v_total_table                NVARCHAR(100) = 'FP_AMEND_PLAN_P_FORM_BOH_R'

	DECLARE @v_refModel                   NVARCHAR(10)
	DECLARE @v_refCMA                     NVARCHAR(10)
	DECLARE @v_refWaitChar                NVARCHAR(10)
	
	-- uom 별 컬럼
	DECLARE @v_uom_text				NVARCHAR(100)
	DECLARE @v_uom_col_out			NVARCHAR(100)
	DECLARE @v_uom_col_result		NVARCHAR(100)
	DECLARE @v_uom_col_total		NVARCHAR(100)
	DECLARE @v_uom_col_remain		NVARCHAR(100)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00640_ILT_MODULE'
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
	DECLARE @v_dSql0                NVARCHAR(MAX)=''
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
    SET @v_master_id                = ''
    SET @v_plan_date                = ''
    SET @v_plan_id                  = ''
    SET @v_plan_type                = ''
	SET @v_model					= ''
	SET @v_module					= ''
	SET @v_cell						= ''
    SET @v_nick_name                = ''
	SET @v_refModel                 = @p_attribute_1
	SET @v_refCMA                   = @p_attribute_2
	SET @v_refWaitChar              = @p_attribute_3

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
	SET	@v_dSql0                = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

	SET	@pSql                   = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''



	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
			
			SELECT @pSql = ''
			
			--@v_dSql0
			SELECT @v_dSql0 = ''
			SELECT @v_dSql0 += '------------------------------------v_dSql0-----------------------------' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#ITEM_LIST'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #ITEM_LIST ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#BOH_LIST'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #BOH_LIST ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#AMEND_LIST'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #AMEND_LIST ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#BASE_MAIN'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #BASE_MAIN ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#CMA_PKG'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #CMA_PKG ' + char(10)
			SELECT @v_dSql0 += ' ' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#WAIT_DISC'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #WAIT_DISC ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#AGING_STOCK'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #AGING_STOCK ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#WAIT_CHAR'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #WAIT_CHAR ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#INV_CATEGORY'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #INV_CATEGORY ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#IN_HOUSE'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #IN_HOUSE ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			/*
			SELECT @v_dSql0 += 'if object_id(''tempdb..#SSP_RAW_DATA'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #SSP_RAW_DATA ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			-- SSP Raw Data
			SELECT @v_dSql0 += 'SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	  , A.ITEM_ID AS MODEL_ITEM_ID  ' + char(10)
			SELECT @v_dSql0 += '	  , C.CATEGORY_ID, C.CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '	  , CONVERT(VARCHAR,A.SHIP_DATE,112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql0 += '	  , SUM(A.SHIP_QTY) AS SHIP_QTY ' + char(10)
			SELECT @v_dSql0 += 'INTO #SSP_RAW_DATA ' + char(10)
			SELECT @v_dSql0 += 'FROM 	FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ', ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '		 , A.SORT_ORDER ' + char(10)
			SELECT @v_dSql0 += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT1 = ''P_FORM''  ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT3 = ''CATEGORY_01'' ' + char(10)
			SELECT @v_dSql0 += ') C ' + char(10)
			SELECT @v_dSql0 += 'WHERE 	1=1	' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += 'AND 	A.SCP_PLAN_ID = ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT MAX(SCP_PLAN_ID) ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '	AND    A.SHOP_GROUP_ID = ''P'' ' + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += 'AND     A.SHIP_DATE BETWEEN CONVERT(DATETIME,''' + @p_bucket_from + ''') AND CONVERT(DATETIME,''' + @p_bucket_to + ''') ' + char(10)
			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	   , C.CATEGORY_ID, C.CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '	   , CONVERT(VARCHAR,A.SHIP_DATE,112) ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)
			*/

			-- Item List
			/*
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '	 , F.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '     , B.PARENT_ITEM_ID AS MODEL ' + char(10)
			SELECT @v_dSql0 += '     , A.ITEM_ID AS MODULE ' + char(10)
			SELECT @v_dSql0 += '     , C.CHILD_ITEM_ID AS CELL ' + char(10)
			SELECT @v_dSql0 += '     , A.ITEM_NAME ' + char(10)
			SELECT @v_dSql0 += '     , A.NICK_NAME ' + char(10)
			SELECT @v_dSql0 += '     , A.ITEM_CLASS ' + char(10)
			SELECT @v_dSql0 += '     , A.ITEM_CLASS_NAME ' + char(10)
			SELECT @v_dSql0 += '     , A.SPEC ' + char(10)
			SELECT @v_dSql0 += '     , A.FLOW_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.SCP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql0 += '     , A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql0 += '     , A.PACK_PRODUCT_GROUP_CODE ' + char(10)
			SELECT @v_dSql0 += 'INTO #ITEM_LIST ' + char(10)
			SELECT @v_dSql0 += 'FROM   SCM_ITEM_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	UNION ' + char(10)
			SELECT @v_dSql0 += '	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_AMEND_PLAN_P_FORM_BOH_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += ') F ' + char(10)
			SELECT @v_dSql0 += 'ON     A.COMPANY_ID  = F.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.DIVISION_ID = F.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.SITE_ID     = F.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.ITEM_ID     = F.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += ',SCM_BOM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ',SCM_BOM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ',SCM_ITEM_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ',SCM_ITEM_CLASS_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += 'AND    A.FLOW_ID = ''P5200'' ' + char(10)
			SELECT @v_dSql0 += 'AND    A.NICK_NAME LIKE ''%MEB%'' ' + char(10)
			SELECT @v_dSql0 += 'AND    A.COMPANY_ID = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.SITE_ID = B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.ITEM_ID = B.CHILD_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    B.EFF_END_DATE >= GETDATE() ' + char(10)
			SELECT @v_dSql0 += 'AND    B.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += 'AND    A.COMPANY_ID = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.SITE_ID = C.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    A.ITEM_ID = C.PARENT_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    C.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += 'AND    C.EFF_END_DATE >= GETDATE() ' + char(10)
			SELECT @v_dSql0 += 'AND    C.COMPANY_ID = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    C.DIVISION_ID = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    C.SITE_ID = D.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    C.CHILD_ITEM_ID = D.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    D.ITEM_CLASS = E.CLASS_ID ' + char(10)
			SELECT @v_dSql0 += 'AND    E.CLASS_ID = ''EM0201'' ' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PARENT_ITEM_ID' , 'LK', @p_model)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_module)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.CHILD_ITEM_ID' , 'LK', @p_cell)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nick_name)) + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)
			*/
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '     , B.MODEL, B.MODULE, B.CELL ' + char(10)
			SELECT @v_dSql0 += '     , C.ITEM_NAME ' + char(10)
			SELECT @v_dSql0 += '     , C.NICK_NAME ' + char(10)
			SELECT @v_dSql0 += '     , C.ITEM_CLASS ' + char(10)
			SELECT @v_dSql0 += '     , C.ITEM_CLASS_NAME ' + char(10)
			SELECT @v_dSql0 += '     , C.SPEC ' + char(10)
			SELECT @v_dSql0 += '     , C.FLOW_ID ' + char(10)
			SELECT @v_dSql0 += '     , C.SCP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql0 += '     , C.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql0 += '     , C.PACK_PRODUCT_GROUP_CODE ' + char(10)
			SELECT @v_dSql0 += 'INTO #ITEM_LIST ' + char(10)
			SELECT @v_dSql0 += 'FROM ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_INSTANCE_INFO_V ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += ') A ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT DISTINCT ' + char(10)
			SELECT @v_dSql0 += '		   A.SEGMENT2 AS MODEL ' + char(10)
			SELECT @v_dSql0 += '		 , A.SEGMENT3 AS MODULE ' + char(10)
			SELECT @v_dSql0 += '		 , A.SEGMENT4 AS CELL ' + char(10)
			SELECT @v_dSql0 += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  A.LOOKUP_TYPE_CODE = ''ILT_ITEM_LIST'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += ') B ' + char(10)
			SELECT @v_dSql0 += 'ON  1=1 ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON    1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND   A.COMPANY_ID   = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND   A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND   A.SITE_ID      = C.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND   B.MODULE       = C.ITEM_ID ' + char(10)

			/*
			-- 충방전 계획,실적,출하 수량 존재하는 모델에 대해서만 조회해주는 조건
			if (@v_refModel = 'Y')
			begin
				SELECT @v_dSql0 += 'INNER JOIN ( ' + char(10)
				SELECT @v_dSql0 += '	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ITEM_ID ' + char(10)
				SELECT @v_dSql0 += '	FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
				SELECT @v_dSql0 += '	AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
				SELECT @v_dSql0 += '	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
				SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
				SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
				SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
				SELECT @v_dSql0 += '	AND    A.CATEGORY_ID IN (''CATEGORY_04'', ''CATEGORY_09'', ''CATEGORY_05'', ''CATEGORY_10'') ' + char(10)
				SELECT @v_dSql0 += '	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,''' + @p_bucket_from + ''') AND CONVERT(DATETIME,''' + @p_bucket_to + ''') ' + char(10)
				SELECT @v_dSql0 += '	UNION ' + char(10)
				SELECT @v_dSql0 += '	SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ITEM_ID ' + char(10)
				SELECT @v_dSql0 += '	FROM   #SSP_RAW_DATA ' + char(10)
				SELECT @v_dSql0 += ') D ' + char(10)
				SELECT @v_dSql0 += 'ON  1=1 ' + char(10)
				SELECT @v_dSql0 += 'AND A.COMPANY_ID  = D.COMPANY_ID ' + char(10)
				SELECT @v_dSql0 += 'AND A.DIVISION_ID = D.DIVISION_ID ' + char(10)
				SELECT @v_dSql0 += 'AND A.SITE_ID     = D.SITE_ID ' + char(10)
				SELECT @v_dSql0 += 'AND A.PLANT_ID    = D.PLANT_ID ' + char(10)
				SELECT @v_dSql0 += 'AND B.MODEL       = D.MODEL_ITEM_ID ' + char(10)
			end
			*/

			SELECT @v_dSql0 += 'WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND   C.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.MODEL' , 'LK', @p_model)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.MODULE' , 'LK', @p_module)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.CELL' , 'LK', @p_cell)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_nick_name)) + char(10)
			SELECT @v_dSql0 += '; ' + char(10)+char(10)

			-- BOH List
			/*
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.GOOD_QTY), 0) + ISNULL(SUM(A.LONG_TERM_QTY), 0) + ISNULL(SUM(A.HOLD_QTY), 0) AS TOTAL_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.GOOD_QTY), 0) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.LONG_TERM_QTY), 0) AS LONG_TERM_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.HOLD_QTY), 0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.QMS_HOLD_QTY), 0) AS QMS_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.MES_HOLD_QTY), 0) AS MES_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += 'INTO #BOH_LIST ' + char(10)
			SELECT @v_dSql0 += 'FROM   FP_AMEND_PLAN_P_FORM_BOH_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '		 , A.SORT_ORDER ' + char(10)
			SELECT @v_dSql0 += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql0 += ') B ' + char(10)
			SELECT @v_dSql0 += 'ON     1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND    A.CATEGORY_ID = B.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += 'WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += 'AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '       , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)
			*/
			-- Estimated 불용재고 추가
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.TOTAL_QTY) + SUM(A.USELESS_QTY) AS TOTAL_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.GOOD_QTY) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.LONG_TERM_QTY) AS LONG_TERM_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.HOLD_QTY) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.QMS_HOLD_QTY) AS QMS_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.MES_HOLD_QTY) AS MES_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.USELESS_QTY) AS USELESS_QTY ' + char(10)
			SELECT @v_dSql0 += 'INTO #BOH_LIST ' + char(10)
			SELECT @v_dSql0 += 'FROM ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	     , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '		 , ISNULL(SUM(A.GOOD_QTY), 0) + ISNULL(SUM(A.LONG_TERM_QTY), 0) + ISNULL(SUM(A.HOLD_QTY), 0) AS TOTAL_QTY ' + char(10)
			SELECT @v_dSql0 += '		 , ISNULL(SUM(A.GOOD_QTY), 0) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql0 += '		 , ISNULL(SUM(A.LONG_TERM_QTY), 0) AS LONG_TERM_QTY ' + char(10)
			SELECT @v_dSql0 += '		 , ISNULL(SUM(A.HOLD_QTY), 0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '		 , ISNULL(SUM(A.QMS_HOLD_QTY), 0) AS QMS_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '		 , ISNULL(SUM(A.MES_HOLD_QTY), 0) AS MES_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '		 , 0 AS USELESS_QTY ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_AMEND_PLAN_P_FORM_BOH_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '		SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '			 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '			 , A.SORT_ORDER ' + char(10)
			SELECT @v_dSql0 += '		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '		WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '		AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql0 += '	) B ' + char(10)
			SELECT @v_dSql0 += '	ON     1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.CATEGORY_ID = B.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql0 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	       , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		   , A.CATEGORY_ID ' + char(10)
			-- Estimated 불용재고는 직접 가져오게 처리
			SELECT @v_dSql0 += '	UNION ALL ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '         , A.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '         , A.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '         , A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '         , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '         , 0 AS TOTAL_QTY ' + char(10)
			SELECT @v_dSql0 += '         , 0 AS GOOD_QTY ' + char(10)
			SELECT @v_dSql0 += '         , 0 AS LONG_TERM_QTY ' + char(10)
			SELECT @v_dSql0 += '         , 0 AS HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '         , 0 AS QMS_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '         , 0 AS MES_HOLD_QTY ' + char(10)
			--SELECT @v_dSql0 += '         , SUM(A.GOOD_QTY) AS USELESS_QTY ' + char(10)
			SELECT @v_dSql0 += '         , (SUM(A.GOOD_QTY) + SUM(A.LONG_TERM_QTY) + SUM(A.HOLD_QTY)) AS USELESS_QTY ' + char(10)
			SELECT @v_dSql0 += '	FROM 	( ' + char(10)
			SELECT @v_dSql0 += '			SELECT	B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '					, B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '					, B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '					, B.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '					, B.MODEL AS MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '					, B.MODULE AS MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '					, B.CELL AS CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '					, CASE WHEN ((A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5310'') ' + char(10)
			SELECT @v_dSql0 += '						   	  	OR (A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS != ''PROC'')) AND SECOND_OCV_EXP_DATE < ''' + @p_plan_date + ''' AND SECOND_OCV_EXP_DATE < DATEADD(DAY, -2, ''' + @p_plan_date + ''') THEN ''CATEGORY_07'' ' + char(10)
			SELECT @v_dSql0 += '							ELSE ''NULL'' END AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '					, SUM(CASE WHEN ISNULL(WIPHOLD_YN,''N'') = ''N'' AND ISNULL(LONG_TERM_FLAG,''N'') = ''N'' THEN QTY ELSE 0 END) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql0 += '					, SUM(CASE WHEN ISNULL(WIPHOLD_YN,''N'') = ''N'' AND ISNULL(LONG_TERM_FLAG,''N'') = ''Y'' THEN QTY ELSE 0 END) AS LONG_TERM_QTY ' + char(10)
			SELECT @v_dSql0 += '					, SUM(CASE WHEN ISNULL(WIPHOLD_YN,''N'') = ''Y'' THEN QTY ELSE 0 END) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '					, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= ''' + @p_plan_date + ''' THEN ''' + @p_plan_date + ''' ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 7, ''' + @p_plan_date + ''')) END AS OCV2_DATE ' + char(10)
			SELECT @v_dSql0 += '					, SUM(CASE WHEN ISNULL(WIPHOLD_YN,''N'') = ''Y'' AND ISNULL(QMS_HOLD_YN, ''N'') = ''Y'' THEN QTY ELSE 0 END) AS QMS_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '					, SUM(CASE WHEN ISNULL(WIPHOLD_YN,''N'') = ''Y'' AND ISNULL(QMS_HOLD_YN, ''N'') = ''N'' AND MES_HOLD_YN = ''Y'' THEN QTY ELSE 0 END) AS MES_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '			FROM 	SCM_STOCK_H_V A WITH(NOLOCK), ' + char(10)
			SELECT @v_dSql0 += '					#ITEM_LIST B ' + char(10)
			SELECT @v_dSql0 += '			WHERE 	1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.CUTOFF_DATE = ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql0 += '			AND 	(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL) ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.STOCK_TYPE  = ''WIP'' ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.OPERATION_ID NOT IN (''PR000'',''PS000'')	' + char(10)
			SELECT @v_dSql0 += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql0 += '			GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.MODEL, B.MODULE, B.CELL ' + char(10)
			SELECT @v_dSql0 += '					, CASE WHEN ((A.OPERATION_ID = ''P5270'' AND A.STOCK_STATUS = ''PROC'') OR (A.OPERATION_ID = ''P5310'') ' + char(10)
			SELECT @v_dSql0 += '						   	OR (A.OPERATION_ID = ''P5410'' AND A.STOCK_STATUS != ''PROC'')) AND SECOND_OCV_EXP_DATE < ''' + @p_plan_date + ''' AND SECOND_OCV_EXP_DATE < DATEADD(DAY, -2, ''' + @p_plan_date + ''') THEN ''CATEGORY_07'' ' + char(10)
			SELECT @v_dSql0 += '							ELSE ''NULL'' END ' + char(10)
			SELECT @v_dSql0 += '					, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= ''' + @p_plan_date + ''' THEN ''' + @p_plan_date + ''' ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 7, ''' + @p_plan_date + ''')) END ' + char(10)
			SELECT @v_dSql0 += '	) A ' + char(10)
			SELECT @v_dSql0 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND   CATEGORY_ID != ''NULL'' ' + char(10)
			SELECT @v_dSql0 += '	GROUP BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.CATEGORY_ID, A.OCV2_DATE ' + char(10)
			SELECT @v_dSql0 += ') A ' + char(10)
			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)
			-- waithing charge 재고 = in-house재고 + ex-warehouse 
			SELECT @v_dSql0 += 'INSERT INTO #BOH_LIST ' + char(10)
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , ''CATEGORY_11'' AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.GOOD_QTY), 0) + ISNULL(SUM(A.LONG_TERM_QTY), 0) + ISNULL(SUM(A.HOLD_QTY), 0) AS TOTAL_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.GOOD_QTY), 0) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.LONG_TERM_QTY), 0) AS LONG_TERM_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.HOLD_QTY), 0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.QMS_HOLD_QTY), 0) AS QMS_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , ISNULL(SUM(A.MES_HOLD_QTY), 0) AS MES_HOLD_QTY ' + char(10)
			SELECT @v_dSql0 += '	 , 0 AS USELESS_QTY ' + char(10)
			SELECT @v_dSql0 += 'FROM   FP_AMEND_PLAN_P_FORM_BOH_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '		 , A.SORT_ORDER ' + char(10)
			SELECT @v_dSql0 += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql0 += ') B ' + char(10)
			SELECT @v_dSql0 += 'ON     1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND    A.CATEGORY_ID = B.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += 'WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += 'AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) 
			SELECT @v_dSql0 += 'AND    A.CATEGORY_ID IN (''CATEGORY_12'',''CATEGORY_13'') ' + char(10)
			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '       , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10)+char(10)

			-- Amend List
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.CATEGORY_ID, A.CATEGORY_NAME, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.QTY) AS QTY ' + char(10)
			SELECT @v_dSql0 += 'INTO #AMEND_LIST ' + char(10)
			SELECT @v_dSql0 += 'FROM ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	     , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.CATEGORY_ID, B.CATEGORY_NAME, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql0 += '		 , SUM(A.QTY) AS QTY ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '		SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '			 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '			 , A.SORT_ORDER ' + char(10)
			SELECT @v_dSql0 += '		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '		WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '		AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql0 += '	) B ' + char(10)
			SELECT @v_dSql0 += '	ON     1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.CATEGORY_ID = B.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			--SELECT @v_dSql0 += 'AND    A.CATEGORY_ID NOT IN (''CATEGORY_01'') ' + char(10) -- SSP 제외
			SELECT @v_dSql0 += '	AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ITEM_ID' , 'LK', @p_model)) + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODULE_ITEM_ID' , 'LK', @p_module)) + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LK', @p_cell)) + char(10)
			SELECT @v_dSql0 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	       , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		   , A.CATEGORY_ID, B.CATEGORY_NAME, CONVERT(VARCHAR, A.PLAN_DATE, 112) ' + char(10)
			--  Estimated Aging Completed : D+0 Estimated + D-7 charging plan
			SELECT @v_dSql0 += '	UNION ALL ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		 , B.CATEGORY_ID, B.CATEGORY_NAME, CONVERT(VARCHAR, A.PLAN_DATE+6, 112) AS PLAN_DATE ' + char(10) 
			SELECT @v_dSql0 += '		 , SUM(A.QTY) AS QTY ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '		SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '			 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '			 , A.SORT_ORDER ' + char(10)
			SELECT @v_dSql0 += '		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '		WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '		AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '		AND    A.SEGMENT1 = ''P_FORM'' ' + char(10) 
			SELECT @v_dSql0 += '		AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10) 
			SELECT @v_dSql0 += '		and    a.segment3 = ''CATEGORY_07'' ' + char(10)
			SELECT @v_dSql0 += '	) B ' + char(10)
			SELECT @v_dSql0 += '	ON     1=1 ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.CATEGORY_ID = ''CATEGORY_09'' ' + char(10) -- charging plan -> estimated
			SELECT @v_dSql0 += '	AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ITEM_ID' , 'LK', @p_model)) + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODULE_ITEM_ID' , 'LK', @p_module)) + char(10)
			SELECT @v_dSql0 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LK', @p_cell)) + char(10)
			SELECT @v_dSql0 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '		   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		   , B.CATEGORY_ID, B.CATEGORY_NAME, CONVERT(VARCHAR, A.PLAN_DATE+6, 112) ' + char(10) 
			SELECT @v_dSql0 += ') A ' + char(10)
			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.CATEGORY_ID, A.CATEGORY_NAME, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10)+char(10)
			/*
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '     , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.CATEGORY_ID, B.CATEGORY_NAME, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.QTY) AS QTY ' + char(10)
			SELECT @v_dSql0 += 'INTO #AMEND_LIST ' + char(10)
			SELECT @v_dSql0 += 'FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '		 , A.SORT_ORDER ' + char(10)
			SELECT @v_dSql0 += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql0 += ') B ' + char(10)
			SELECT @v_dSql0 += 'ON     1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND    A.CATEGORY_ID = B.CATEGORY_ID ' + char(10)
			SELECT @v_dSql0 += 'WHERE  1=1 ' + char(10)
			--SELECT @v_dSql0 += 'AND    A.CATEGORY_ID NOT IN (''CATEGORY_01'') ' + char(10) -- SSP 제외
			SELECT @v_dSql0 += 'AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += 'AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODEL_ITEM_ID' , 'LK', @p_model)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MODULE_ITEM_ID' , 'LK', @p_module)) + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CELL_ITEM_ID' , 'LK', @p_cell)) + char(10)
			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '       , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.CATEGORY_ID, B.CATEGORY_NAME, CONVERT(VARCHAR, A.PLAN_DATE, 112) ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)
			*/
			-- SSP 추가
			/*
			SELECT @v_dSql0 += 'INSERT INTO #AMEND_LIST ' + char(10)
			SELECT @v_dSql0 += 'SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	  , A.ITEM_ID AS MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	  , B.MODULE AS MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	  , B.CELL AS CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	  , C.CATEGORY_ID, C.CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '	  , CONVERT(VARCHAR,A.SHIP_DATE,112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql0 += '	  , SUM(A.SHIP_QTY) AS SHIP_QTY ' + char(10)
			SELECT @v_dSql0 += 'FROM 	FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ', #ITEM_LIST B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ', (  ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.SEGMENT3 AS CATEGORY_ID  ' + char(10)
			SELECT @v_dSql0 += '		 , A.ATTRIBUTE1 AS CATEGORY_NAME  ' + char(10)
			SELECT @v_dSql0 += '		 , A.SORT_ORDER  ' + char(10)
			SELECT @v_dSql0 += '	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1  ' + char(10)
			SELECT @v_dSql0 += '	AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT1 = ''P_FORM''  ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SEGMENT3 = ''CATEGORY_01'' ' + char(10)
			SELECT @v_dSql0 += ') C ' + char(10)
			SELECT @v_dSql0 += 'WHERE 	1=1	 ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.SITE_ID     = B.SITE_ID  ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.PLANT_ID    = B.PLANT_ID  ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.ITEM_ID     = B.MODEL  ' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql0 += 'AND 	A.SCP_PLAN_ID = ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT MAX(SCP_PLAN_ID) ' + char(10)
			SELECT @v_dSql0 += '	FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK), FP_INSTANCE_INFO_V B(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.COMPANY_ID    = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '	AND    A.DIVISION_ID   = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SITE_ID       = B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '	AND    A.PLANT_ID      = B.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SHOP_GROUP_ID = ''P'' ' + char(10)
			SELECT @v_dSql0 += '	AND    B.INSTANCE_ID   = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += 'AND     A.SHIP_DATE BETWEEN CONVERT(DATETIME,''' + @p_bucket_from + ''') AND CONVERT(DATETIME,''' + @p_bucket_to + ''') ' + char(10)
			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.ITEM_ID, B.MODULE, B.CELL ' + char(10)
			SELECT @v_dSql0 += '	   , C.CATEGORY_ID, C.CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '	   , CONVERT(VARCHAR,A.SHIP_DATE,112) ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)
			*/
			/*
			SELECT @v_dSql0 += 'INSERT INTO #AMEND_LIST ' + char(10)
			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , B.MODULE AS MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , B.CELL AS CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.CATEGORY_ID, A.CATEGORY_NAME ' + char(10)
			SELECT @v_dSql0 += '	 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql0 += '	 , A.SHIP_QTY ' + char(10)
			SELECT @v_dSql0 += 'FROM   #SSP_RAW_DATA A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ', #ITEM_LIST B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'WHERE 	1=1	' + char(10)
			SELECT @v_dSql0 += 'AND 	A.COMPANY_ID    = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.DIVISION_ID   = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.SITE_ID       = B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.PLANT_ID      = B.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += 'AND 	A.MODEL_ITEM_ID = B.MODEL ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)
			*/

			SELECT @v_dSql1 = ''
			SELECT @v_dSql1 = '------------------------------------v_dSql1-----------------------------' + char(10)

			-- Discharging plan, Charging Plan, Shipping Plan(SSP), CMA Assy plan
			SELECT @v_dSql1 += 'SELECT A.* ' + char(10)
			SELECT @v_dSql1 += 'INTO #BASE_MAIN ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL AS MODEL_ITEM_ID, A.MODULE AS MODULE_ITEM_ID, A.CELL AS CELL_ITEM_ID, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)

			IF(LEN(@p_day_info) > 0)
			BEGIN
				-- month
				SELECT @v_tmp1 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			    WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp1 += '		 , SUM(CASE WHEN A.YYYYMM = ''' + @v_month_info + ''' THEN (CASE WHEN A.CATEGORY_ID = ''CATEGORY_01'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_04'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_09'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_14'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_05'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_07'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_10'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_15'' THEN B.QTY ELSE 0 END ) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END
					
				-- week
			    SELECT @v_tmp2 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp2 += '		 , SUM(CASE WHEN A.ISO_YYYYWW = ''' + @v_week_info + ''' THEN (CASE WHEN A.CATEGORY_ID = ''CATEGORY_01'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_04'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_09'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_14'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_05'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_07'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_10'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_15'' THEN B.QTY ELSE 0 END ) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 

				-- day
			    SELECT @v_tmp3 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp3 += '		 , SUM(CASE WHEN A.YYYYMMDD = ''' + @v_day_info + ''' THEN (CASE WHEN A.CATEGORY_ID = ''CATEGORY_01'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_04'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_09'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_14'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_05'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_07'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_10'' THEN B.QTY WHEN A.CATEGORY_ID = ''CATEGORY_15'' THEN B.QTY ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 
			END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.*, D.YYYYMMDD, D.ISO_YYYYWW, D.YYYYMM ' + char(10)
			SELECT @v_dSql1 += '		FROM   #ITEM_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		, ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql1 += '				 , A.SORT_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT3 IN (''CATEGORY_01'',''CATEGORY_04'',''CATEGORY_09'',''CATEGORY_14'' ' + char(10)
			SELECT @v_dSql1 += '			, ''CATEGORY_05'',''CATEGORY_07'',''CATEGORY_10'',''CATEGORY_15'' ' + char(10) -- Discharging result, Estimated Aging Completed, Charging result 카테고리 강제 추가
			SELECT @v_dSql1 += '			) ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		, TH_UIS_CAL D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND   D.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.CATEGORY_ID, A.CATEGORY_NAME, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '			 , A.QTY ' + char(10)
			SELECT @v_dSql1 += '		FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND    A.CATEGORY_ID IN (''CATEGORY_01'',''CATEGORY_04'',''CATEGORY_09'',''CATEGORY_14'',''CATEGORY_05'',''CATEGORY_07'',''CATEGORY_10'',''CATEGORY_15'') ' + char(10) -- Discharging result, Charging result 카테고리 추가
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODEL       = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODULE      = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CELL        = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CATEGORY_ID = B.CATEGORY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.YYYYMMDD    = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.MODEL, A.MODULE, A.CELL, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10) + char(10)

			/*
			* CMA PKG(P5500) :: CATEGORY_02

			- D0	"CMA PKG" GOOD BOH + "Discharging plan" GOOD BOH - D+0 "Shipping Plan(SSP)"
			- 이후	D-1	"CMA PKG" + D-1 "Discharging plan" - D+0 "Shipping Plan(SSP)"
			*/
			SELECT @v_dSql1 += 'SELECT * ' + char(10)
			SELECT @v_dSql1 += 'INTO #CMA_PKG ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL AS MODEL_ITEM_ID, A.MODULE AS MODULE_ITEM_ID, A.CELL AS CELL_ITEM_ID, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)

			IF(LEN(@p_day_info) > 0)
			BEGIN
				-- month
				SELECT @v_tmp1 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			    WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp1 += '		 , SUM(CASE WHEN A.YYYYMM <= ''' + @v_month_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END
					
				-- week
			    SELECT @v_tmp2 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp2 += '		 , SUM(CASE WHEN A.ISO_YYYYWW <= ''' + @v_week_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 

				-- day
			    SELECT @v_tmp3 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE <= ''' + @v_day_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 
			END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.*, D.YYYYMMDD, D.ISO_YYYYWW, D.YYYYMM ' + char(10)
			SELECT @v_dSql1 += '		FROM   #ITEM_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		, ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql1 += '				 , A.SORT_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1' + char(10)
			SELECT @v_dSql1 += '			AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT3 IN (''CATEGORY_02'') ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		, TH_UIS_CAL D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND   D.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '			 , CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(B.GOOD_QTY,0) - A.SSPP_QTY) ELSE (A.DISC_QTY - A.SSPP_QTY) END AS EOH_QTY ' + char(10)
			SELECT @v_dSql1 += '		FROM ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.SSPP_QTY) AS SSPP_QTY ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.DISC_QTY) AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM ( ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS SSPP_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10) -- PLAN_DATE
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_01'') ' + char(10)
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, CONVERT(VARCHAR, CONVERT(DATETIME,A.PLAN_DATE)+1, 112) AS PLAN_DATE ' + char(10) -- LT = 1
			SELECT @v_dSql1 += '					 , 0 AS SSPP_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10) -- PLAN_DATE
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_04'') ' + char(10)
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, ''' + @p_plan_date + ''' AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS SSPP_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_02'',''CATEGORY_04'') ' + char(10)
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			) A ' + char(10)
			SELECT @v_dSql1 += '			WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		) A ' + char(10)
			SELECT @v_dSql1 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(ISNULL(A.GOOD_QTY,0)) + SUM(ISNULL(A.LONG_TERM_QTY,0)) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.CATEGORY_ID IN (''CATEGORY_02'',''CATEGORY_04'') ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		ON 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODEL_ITEM_ID  = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODULE_ITEM_ID = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.CELL_ITEM_ID   = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODEL       = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODULE      = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CELL        = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.YYYYMMDD    = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.MODEL, A.MODULE, A.CELL, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10) + char(10)

			/*
			* Waiting Discharge

			- D0	"Waiting Discharge" Good BOH + "Estimated Aging Completed" Good BOH + "Aging Stock" Good BOH - D+0 "Discharging plan"
			- 이후	D-1 "Waiting Discharge" + D-7 "Charging Plan" - D+0 "Discharging plan"
			*/
			SELECT @v_dSql1 += 'SELECT * ' + char(10)
			SELECT @v_dSql1 += 'INTO #WAIT_DISC ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL AS MODEL_ITEM_ID, A.MODULE AS MODULE_ITEM_ID, A.CELL AS CELL_ITEM_ID, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)

			IF(LEN(@p_day_info) > 0)
			BEGIN
				-- month
				SELECT @v_tmp1 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			    WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp1 += '		 , SUM(CASE WHEN A.YYYYMM <= ''' + @v_month_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END
					
				-- week
			    SELECT @v_tmp2 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp2 += '		 , SUM(CASE WHEN A.ISO_YYYYWW <= ''' + @v_week_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 

				-- day
			    SELECT @v_tmp3 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE <= ''' + @v_day_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 
			END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.*, D.YYYYMMDD, D.ISO_YYYYWW, D.YYYYMM ' + char(10)
			SELECT @v_dSql1 += '		FROM   #ITEM_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		, ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql1 += '				 , A.SORT_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT3 IN (''CATEGORY_06'') ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		, TH_UIS_CAL D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND   D.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			--SELECT @v_dSql1 += '			 , CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(B.GOOD_QTY,0) + A.ESTI_QTY - A.DISC_QTY) ELSE (0 + A.ESTI_QTY - A.DISC_QTY + A.CHAR_QTY) END AS EOH_QTY ' + char(10)
			SELECT @v_dSql1 += '			 , CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(B.GOOD_QTY,0) + A.ESTI_QTY - A.DISC_QTY) ELSE (0 + A.ESTI_QTY - A.DISC_QTY) END AS EOH_QTY ' + char(10)
			SELECT @v_dSql1 += '		FROM ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.ESTI_QTY) AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.DISC_QTY) AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.CHAR_QTY) AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM ( ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10) 
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_07'') ' + char(10)-- D+0 estimated qty
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10) 
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_04'') ' + char(10) -- D+0 discharging qty
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			/*
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, CONVERT(VARCHAR, CONVERT(DATETIME,A.PLAN_DATE)+7, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_09'') ' + char(10) -- D-7 charging qty
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			*/
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, ''' + @p_plan_date + ''' AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS DISC_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_06'',''CATEGORY_07'') ' + char(10)-- boh 품번 강제 추가
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			) A ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '		) A ' + char(10)
			SELECT @v_dSql1 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(ISNULL(A.GOOD_QTY,0)) + SUM(ISNULL(A.LONG_TERM_QTY,0)) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.CATEGORY_ID IN (''CATEGORY_06'',''CATEGORY_07'') ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODEL_ITEM_ID  = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODULE_ITEM_ID = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.CELL_ITEM_ID   = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODEL       = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODULE      = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CELL        = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.YYYYMMDD    = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.MODEL, A.MODULE, A.CELL, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10)

			/*
			* Aging Stock

			- D0	"Aging Stock" Good BOH - D+0 "Estimated ~" + D+0 "charging plan"
			- 이후	D-1 "Aging Stock" - D+0 "Estimated ~" + D+0 "charging plan" - D-7 "charging plan"
			*/
			SELECT @v_dSql1 += 'SELECT * ' + char(10)
			SELECT @v_dSql1 += 'INTO #AGING_STOCK ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL AS MODEL_ITEM_ID, A.MODULE AS MODULE_ITEM_ID, A.CELL AS CELL_ITEM_ID, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)

			IF(LEN(@p_day_info) > 0)
			BEGIN
				-- month
				SELECT @v_tmp1 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			    WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp1 += '		 , SUM(CASE WHEN A.YYYYMM <= ''' + @v_month_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END
					
				-- week
			    SELECT @v_tmp2 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp2 += '		 , SUM(CASE WHEN A.ISO_YYYYWW <= ''' + @v_week_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 

				-- day
			    SELECT @v_tmp3 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE <= ''' + @v_day_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 
			END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.*, D.YYYYMMDD, D.ISO_YYYYWW, D.YYYYMM ' + char(10)
			SELECT @v_dSql1 += '		FROM   #ITEM_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		, ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql1 += '				 , A.SORT_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT3 IN (''CATEGORY_08'') ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		, TH_UIS_CAL D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND   D.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			--SELECT @v_dSql1 += '			 , CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(B.GOOD_QTY,0) - A.ESTI_QTY + A.CHAR_1_QTY) ELSE (- A.ESTI_QTY + A.CHAR_1_QTY - A.CHAR_2_QTY) END AS EOH_QTY ' + char(10)
			SELECT @v_dSql1 += '			 , CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(B.GOOD_QTY,0) - A.ESTI_QTY + A.CHAR_1_QTY) ELSE (- A.ESTI_QTY + A.CHAR_1_QTY) END AS EOH_QTY ' + char(10)
			SELECT @v_dSql1 += '		FROM ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.CHAR_1_QTY) AS CHAR_1_QTY ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.CHAR_2_QTY) AS CHAR_2_QTY ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.ESTI_QTY) AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM ( ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS CHAR_1_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_2_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_09'') ' + char(10) -- D+0 charging qty
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			/*
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, CONVERT(VARCHAR, CONVERT(DATETIME,A.PLAN_DATE)+7, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_1_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS CHAR_2_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_09'') ' + char(10) -- D-7 charging qty
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			*/
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_1_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_2_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + ''' ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_07'') ' + char(10) -- D+0 estimated
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				UNION ALL ' + char(10) -- BOH 품번 강제 추가
			SELECT @v_dSql1 += '				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, ''' + @p_plan_date + ''' AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_1_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_2_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ESTI_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_06'',''CATEGORY_07'',''CATEGORY_08'') ' + char(10)
			SELECT @v_dSql1 += '			) A ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '		) A ' + char(10)
			SELECT @v_dSql1 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(ISNULL(A.GOOD_QTY,0)) + SUM(ISNULL(A.LONG_TERM_QTY,0)) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.CATEGORY_ID IN (''CATEGORY_08'') ' + char(10) -- aging stock
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODEL_ITEM_ID  = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODULE_ITEM_ID = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.CELL_ITEM_ID   = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODEL       = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODULE      = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CELL        = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.YYYYMMDD    = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.MODEL, A.MODULE, A.CELL, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10)

			/*
			* Waiting charge

			- D0	"Waiting Charge" GOOD BOH - D+0 "Charging Plan"
			- 이후	D-1 "Waiting change" + D-1 "CMA ASSY Plan" - D+0 "Charging Plan"
			*/
			SELECT @v_dSql1 += 'SELECT * ' + char(10)
			SELECT @v_dSql1 += 'INTO #WAIT_CHAR ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL AS MODEL_ITEM_ID, A.MODULE AS MODULE_ITEM_ID, A.CELL AS CELL_ITEM_ID, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			
			IF(LEN(@p_day_info) > 0)
			BEGIN
				-- month
				SELECT @v_tmp1 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			    WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp1 += '		 , SUM(CASE WHEN A.YYYYMM <= ''' + @v_month_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END
					
				-- week
			    SELECT @v_tmp2 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp2 += '		 , SUM(CASE WHEN A.ISO_YYYYWW <= ''' + @v_week_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 

				-- day
			    SELECT @v_tmp3 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE <= ''' + @v_day_info + ''' AND B.PLAN_DATE >= ''' + @p_plan_date + ''' THEN B.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 
			END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.*, D.YYYYMMDD, D.ISO_YYYYWW, D.YYYYMM ' + char(10)
			SELECT @v_dSql1 += '		FROM   #ITEM_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		, ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql1 += '				 , A.SORT_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT3 IN (''CATEGORY_11'') ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		, TH_UIS_CAL D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND   D.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '			 , CASE WHEN A.PLAN_DATE = ''' + @p_plan_date + ''' THEN (ISNULL(B.GOOD_QTY,0) - A.CHAR_QTY) ELSE (A.ASSY_QTY - A.CHAR_QTY) END AS EOH_QTY ' + char(10)
			SELECT @v_dSql1 += '			 , B.GOOD_QTY, A.CHAR_QTY, A.ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '		FROM ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.CHAR_QTY) AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.ASSY_QTY) AS ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM ( ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + '''  ' + char(10) -- PLAN_DATE
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_09'') ' + char(10)
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, CONVERT(VARCHAR, CONVERT(DATETIME,A.PLAN_DATE)+1, 112) AS PLAN_DATE ' + char(10) -- LT = 1
			SELECT @v_dSql1 += '					 , 0 AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , SUM(A.QTY) AS ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE >= ''' + @p_plan_date + '''  ' + char(10) -- PLAN_DATE
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_14'') ' + char(10)
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, ''' + @p_plan_date + ''' AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS CHAR_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.CATEGORY_ID IN (''CATEGORY_11'') ' + char(10)
			SELECT @v_dSql1 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			) A ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '		) A ' + char(10)
			SELECT @v_dSql1 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(ISNULL(A.GOOD_QTY,0)) + SUM(ISNULL(A.LONG_TERM_QTY,0)) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.CATEGORY_ID IN (''CATEGORY_11'') ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODEL_ITEM_ID  = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.MODULE_ITEM_ID = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.CELL_ITEM_ID   = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		where 1=1 ' + char(10)
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODEL       = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODULE      = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CELL        = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.YYYYMMDD    = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.MODEL, A.MODULE, A.CELL, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10) + char(10)


			-- 내/외수 재고 : 
			SELECT @v_dSql1 += 'SELECT A.* ' + char(10)
			SELECT @v_dSql1 += '	 , ISNULL(B.IN_HOUSE_BOH, 0) AS IN_HOUSE_BOH ' + char(10)
			SELECT @v_dSql1 += '	 , ISNULL(B.EX_WARE_BOH, 0) AS EX_WARE_BOH ' + char(10)
			SELECT @v_dSql1 += '	 , 0 AS WEEK_IN_HOUSE_QTY ' + char(10)
			SELECT @v_dSql1 += '	 , 0 AS MONTH_IN_HOUSE_QTY ' + char(10)
			SELECT @v_dSql1 += '	 , 0 AS WEEK_EX_WARE_QTY ' + char(10)
			SELECT @v_dSql1 += '	 , 0 AS MONTH_EX_WARE_QTY ' + char(10)
			SELECT @v_dSql1 += 'INTO #INV_CATEGORY ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL AS MODEL_ITEM_ID, A.MODULE AS MODULE_ITEM_ID, A.CELL AS CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '		 , ISNULL(SUM(B.ASSY_QTY),0) AS ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '		 , ISNULL(SUM(B.CHARGING_QTY),0) AS CHARGING_QTY ' + char(10)
			SELECT @v_dSql1 += '		 , 0 AS IN_HOUSE_QTY ' + char(10)
			SELECT @v_dSql1 += '		 , 0 AS EX_WARE_QTY ' + char(10)
			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.* ' + char(10)
			SELECT @v_dSql1 += '		     , D.YYYYMMDD AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '		FROM   #ITEM_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		, TH_UIS_CAL D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND   D.YYYYMMDD BETWEEN ''' + @p_plan_date + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			 , A.CATEGORY_NAME, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '			 , ISNULL(SUM(CASE WHEN A.CATEGORY_ID = ''CATEGORY_14'' THEN A.QTY ELSE 0 END), 0)  AS ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '			 , ISNULL(SUM(CASE WHEN A.CATEGORY_ID = ''CATEGORY_09'' THEN A.QTY ELSE 0 END), 0)  AS CHARGING_QTY ' + char(10)
			SELECT @v_dSql1 += '		FROM   #AMEND_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND    A.CATEGORY_ID IN (''CATEGORY_09'',''CATEGORY_14'')  ' + char(10)
			SELECT @v_dSql1 += '		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			   , A.CATEGORY_NAME, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODEL       = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODULE      = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CELL        = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLAN_DATE   = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			, A.MODEL, A.MODULE, A.CELL ' + char(10)
			SELECT @v_dSql1 += '			, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += ') a ' + char(10)
			SELECT @v_dSql1 += 'LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		 , ISNULL(SUM(CASE WHEN A.CATEGORY_ID = ''CATEGORY_12'' THEN A.GOOD_QTY ELSE 0 END), 0) + ISNULL(SUM(CASE WHEN A.CATEGORY_ID = ''CATEGORY_12'' THEN A.LONG_TERM_QTY ELSE 0 END), 0) AS IN_HOUSE_BOH ' + char(10)
			SELECT @v_dSql1 += '		 , ISNULL(SUM(CASE WHEN A.CATEGORY_ID = ''CATEGORY_13'' THEN A.GOOD_QTY ELSE 0 END), 0) + ISNULL(SUM(CASE WHEN A.CATEGORY_ID = ''CATEGORY_13'' THEN A.LONG_TERM_QTY ELSE 0 END), 0) AS EX_WARE_BOH ' + char(10)
			SELECT @v_dSql1 += '	FROM   #BOH_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND    A.CATEGORY_ID IN (''CATEGORY_12'',''CATEGORY_13'') ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ') B ' + char(10)
			SELECT @v_dSql1 += 'ON  1=1 ' + char(10)
			SELECT @v_dSql1 += 'AND A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += 'AND A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += 'AND A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += 'AND A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += 'AND A.MODEL_ITEM_ID  = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += 'AND A.MODULE_ITEM_ID = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += 'AND A.CELL_ITEM_ID   = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10)+char(10)

			SELECT @v_dSql1 += 'DECLARE @__BEFORE_IN_HOUSE NUMERIC(20,10) , @__BEFORE_EX_WARE NUMERIC(20,10) ' + char(10) -- 전날 In house qty, ex-warehouse qty 값 용 변수
			SELECT @v_dSql1 += 'DECLARE @__CURRENT_IN_HOUSE NUMERIC(20,10), @__CURRENT_EX_WARE NUMERIC(20,10) ' + char(10) -- 당일 In house qty, ex-warehouse qty 값 용 변수
			SELECT @v_dSql1 += 'DECLARE @__BEFORE_ASSY NUMERIC(20,10) ' + char(10)+char(10) -- 전날 CMA Assy

			SELECT @v_dSql1 += 'DECLARE C_ITEM_LIST CURSOR FOR ' + char(10) -- ITEM 목록 커서 선언
			SELECT @v_dSql1 += '' + char(10)    
			SELECT @v_dSql1 += '	SELECT COMPANY_ID, DIVISION_ID , SITE_ID , PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '         , MODEL AS MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '         , MODULE AS MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '         , CELL AS CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	FROM   #ITEM_LIST ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '	DECLARE ' + char(10)
			SELECT @v_dSql1 += '		@_COMPANY_ID NVARCHAR(150), ' + char(10)
			SELECT @v_dSql1 += '		@_DIVISION_ID NVARCHAR(150), ' + char(10)
			SELECT @v_dSql1 += '		@_SITE_ID NVARCHAR(150), ' + char(10)
			SELECT @v_dSql1 += '		@_PLANT_ID NVARCHAR(150), ' + char(10)
			SELECT @v_dSql1 += '		@_MODEL_ITEM_ID NVARCHAR(150), ' + char(10)
			SELECT @v_dSql1 += '		@_MODULE_ITEM_ID NVARCHAR(150), ' + char(10)
			SELECT @v_dSql1 += '		@_CELL_ITEM_ID NVARCHAR(150) ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '	OPEN C_ITEM_LIST ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '	WHILE 1 = 1 ' + char(10) -- LOOP 1
			SELECT @v_dSql1 += '	BEGIN ' + char(10)
			SELECT @v_dSql1 += '' + char(10)		-- SELECT 한 값을 변수들에 넣는다.
			SELECT @v_dSql1 += '		FETCH C_ITEM_LIST ' + char(10)
			SELECT @v_dSql1 += '		INTO  @_COMPANY_ID, ' + char(10)
			SELECT @v_dSql1 += '			  @_DIVISION_ID, ' + char(10)
			SELECT @v_dSql1 += '			  @_SITE_ID, ' + char(10)
			SELECT @v_dSql1 += '			  @_PLANT_ID, ' + char(10)
			SELECT @v_dSql1 += '			  @_MODEL_ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += '			  @_MODULE_ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += '			  @_CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '		IF @@FETCH_STATUS <> 0 ' + char(10)	-- LOOP 1 break
			SELECT @v_dSql1 += '		BREAK ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '		SET @__BEFORE_IN_HOUSE  = 0 ' + char(10)
			SELECT @v_dSql1 += '		SET @__BEFORE_EX_WARE   = 0 ' + char(10)
			SELECT @v_dSql1 += '		SET @__CURRENT_IN_HOUSE = 0 ' + char(10)
			SELECT @v_dSql1 += '		SET @__CURRENT_EX_WARE  = 0 ' + char(10)
			SELECT @v_dSql1 += '		SET @__BEFORE_ASSY      = 0 ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '		DECLARE C_ITEM_DATE_LIST CURSOR FOR  ' + char(10) -- ITEM-DATE 목록 커서 선언
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '			SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ' + char(10)
			SELECT @v_dSql1 += '				   MODEL_ITEM_ID, MODULE_ITEM_ID, CELL_ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += '				   PLAN_DATE, ' + char(10)
			SELECT @v_dSql1 += '				   ASSY_QTY, CHARGING_QTY, ' + char(10)
			SELECT @v_dSql1 += '				   IN_HOUSE_QTY, EX_WARE_QTY, ' + char(10)
			SELECT @v_dSql1 += '				   IN_HOUSE_BOH, EX_WARE_BOH ' + char(10)
			SELECT @v_dSql1 += '			FROM   #INV_CATEGORY ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    COMPANY_ID     = @_COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '			AND    DIVISION_ID    = @_DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '			AND    SITE_ID        = @_SITE_ID ' + char(10)
			SELECT @v_dSql1 += '			AND    PLANT_ID       = @_PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '			AND    MODEL_ITEM_ID  = @_MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			AND    MODULE_ITEM_ID = @_MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '			AND    CELL_ITEM_ID   = @_CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '			DECLARE ' + char(10)
			SELECT @v_dSql1 += '				@__COMPANY_ID nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__DIVISION_ID nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__SITE_ID nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__PLANT_ID nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__MODEL_ITEM_ID nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__MODULE_ITEM_ID nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__CELL_ITEM_ID nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__PLAN_DATE nvarchar(150), ' + char(10)
			SELECT @v_dSql1 += '				@__ASSY_QTY numeric(20,10), ' + char(10)
			SELECT @v_dSql1 += '				@__CHARGING_QTY numeric(20,10), ' + char(10)
			SELECT @v_dSql1 += '				@__IN_HOUSE_QTY numeric(20,10), ' + char(10)
			SELECT @v_dSql1 += '				@__EX_WARE_QTY numeric(20,10), ' + char(10)
			SELECT @v_dSql1 += '				@__IN_HOUSE_BOH numeric(20,10), ' + char(10)
			SELECT @v_dSql1 += '				@__EX_WARE_BOH numeric(20,10) ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '			OPEN C_ITEM_DATE_LIST ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '			WHILE 1 = 1 ' + char(10) -- LOOP 2
			SELECT @v_dSql1 += '			BEGIN ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '				FETCH C_ITEM_DATE_LIST ' + char(10)
			SELECT @v_dSql1 += '				INTO  @__COMPANY_ID, ' + char(10)
			SELECT @v_dSql1 += '					  @__DIVISION_ID, ' + char(10)
			SELECT @v_dSql1 += '					  @__SITE_ID, ' + char(10)
			SELECT @v_dSql1 += '					  @__PLANT_ID, ' + char(10)
			SELECT @v_dSql1 += '					  @__MODEL_ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += '					  @__MODULE_ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += '					  @__CELL_ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += '					  @__PLAN_DATE, ' + char(10)
			SELECT @v_dSql1 += '					  @__ASSY_QTY, ' + char(10)
			SELECT @v_dSql1 += '					  @__CHARGING_QTY, ' + char(10)
			SELECT @v_dSql1 += '					  @__IN_HOUSE_QTY, ' + char(10)
			SELECT @v_dSql1 += '					  @__EX_WARE_QTY, ' + char(10)
			SELECT @v_dSql1 += '					  @__IN_HOUSE_BOH, ' + char(10)
			SELECT @v_dSql1 += '					  @__EX_WARE_BOH ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '				IF @@FETCH_STATUS <> 0  ' + char(10) -- LOOP 2 break
			SELECT @v_dSql1 += '				BREAK ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '				IF @__PLAN_DATE = ''' + @p_plan_date + '''  ' + char(10)-- plan date : D0 인지 여부
			SELECT @v_dSql1 += '				BEGIN ' + char(10)
													/*
													1) ex. warehouse : D0
													
													O265 : "In House" Good BOH
													O289 : "Ex-Warehouse" Good BOH
													R193 : "Charging Plan" D0
													
													=IF(O265>R193, O289
																 , IF(O265+O289<R193, 0
																					, O265+O289-R193
																 )
													)
													
													내수재고만으로 충전을 커버치면 외수재고 안까이고
													안되면 내+외수 재고합친게 충전을 커버치면 충전수량 까인값만큼 주고, 커버못치면 0 재고임
													*/
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '					SET @__BEFORE_EX_WARE = CASE WHEN @__IN_HOUSE_BOH > @__CHARGING_QTY THEN @__EX_WARE_BOH ' + char(10)
			SELECT @v_dSql1 += '						                         WHEN @__IN_HOUSE_BOH + @__EX_WARE_BOH < @__CHARGING_QTY THEN 0 ' + char(10)
			SELECT @v_dSql1 += '											     ELSE @__IN_HOUSE_BOH + @__EX_WARE_BOH - @__CHARGING_QTY END ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '' + char(10)
													/*
													2) In house : D0
													
													O265 : "In House" Good BOH
													O289 : "ex-ware" Good BOH
													R289 : "ex-ware" D0
													R193 : "Charging Plan" D0
													
													
													=IF(R289=0, O265-R193
															  , IF(O265-R193>0, O265-R193
																			  , IF(O265-R193+O289>0, 0
																								   , O265-R193+O289
																			  )
															  )
													
													)
													
													외수수량 없으면 외수재고에서 충전수량 뺀값
													아니면 내수재고만으로 충전수량 커버가능하면 내수재고 빼기 충전수량 값이고
													아니면 내외수재고로 충전수량 커버가능하면 0
													아니면 내외수재고 합수량 빼기 충전수량 값 --> 0 이나 마이너스값이 나올듯
													*/
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '					SET @__BEFORE_IN_HOUSE = CASE WHEN @__BEFORE_EX_WARE = 0 THEN @__IN_HOUSE_BOH - @__CHARGING_QTY ' + char(10)
			SELECT @v_dSql1 += '					                              WHEN @__IN_HOUSE_BOH - @__CHARGING_QTY > 0 THEN @__IN_HOUSE_BOH - @__CHARGING_QTY ' + char(10)
			SELECT @v_dSql1 += '												  WHEN @__IN_HOUSE_BOH - @__CHARGING_QTY + @__EX_WARE_BOH > 0 THEN 0 ' + char(10)
			SELECT @v_dSql1 += '												  ELSE @__IN_HOUSE_BOH - @__CHARGING_QTY + @__EX_WARE_BOH END ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '					UPDATE A SET ' + char(10)
			SELECT @v_dSql1 += '						  IN_HOUSE_QTY     = @__BEFORE_IN_HOUSE ' + char(10)
			SELECT @v_dSql1 += '						, EX_WARE_QTY      = @__BEFORE_EX_WARE ' + char(10)
			SELECT @v_dSql1 += '					FROM  #INV_CATEGORY A ' + char(10)
			SELECT @v_dSql1 += '					WHERE A.COMPANY_ID     = @__COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.DIVISION_ID    = @__DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.SITE_ID        = @__SITE_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.PLANT_ID       = @__PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.MODEL_ITEM_ID  = @__MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.MODULE_ITEM_ID = @__MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.CELL_ITEM_ID   = @__CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.PLAN_DATE      = @__PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '				END ' + char(10)
			SELECT @v_dSql1 += '				ELSE BEGIN ' + char(10)
													/*
													3) ex. warehouse : 이후
			
													R265 : D-1 "In House"
													R289 : D-1 "ex-ware"
													S193 : D+0 "Charging Plan"
			
			
													=IF(R265>S193, R289
																 , IF(R265+R289-S193<0, 0
																					, R265+R289-S193
																 )
													)
			
													전날 내수수량이 당일 충전수량보다 크면 전날 외수수량
													아니면 전날 내외수수량이 당일 충전수량보다 작으면 0
													아니면 전날 내외수수량 합에서 당일 충전수량 뺀 값
													*/
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '					SET @__CURRENT_EX_WARE = CASE WHEN @__BEFORE_IN_HOUSE > @__CHARGING_QTY THEN @__BEFORE_EX_WARE ' + char(10)
			SELECT @v_dSql1 += '					                              WHEN @__BEFORE_IN_HOUSE + @__BEFORE_EX_WARE - @__CHARGING_QTY < 0 THEN 0 ' + char(10)
			SELECT @v_dSql1 += '												  ELSE @__BEFORE_IN_HOUSE + @__BEFORE_EX_WARE - @__CHARGING_QTY END ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
													/*
													4) In house : 이후
													
													S193 : D+0 "charging plan"
													S289 : D+0 "ex-ware"
													R265 : D-1 "in house"
													R289 : D-1 "ex-ware"
													R313 : D-1 "CMA Assy"
													
													
													=IF(S289=0, R265+R313-S193
															  , IF(R265+R313-S193>0, R265+R313-S193
																				   , IF(R265+R313-S193+R289>0, 0
																											 , R265+R313-S193+R289
																				   )
															  )
													)
													
													당일 외수수량이 0 이면 (전날 내수수량 + 전날 조립수량 - 당일 충전수량)
													아니면 (전날 내수수량 + 전날 조립수량 - 당일 충전수량) 이 0보다 크면 그값
													아니면 (전날 내수수량 + 전날 조립수량 - 당일 충전수량 + 전날 외수수량) 이 0보다 크면 0
													아니면 그값
													*/
			SELECT @v_dSql1 += '					SET @__CURRENT_IN_HOUSE = CASE WHEN @__CURRENT_EX_WARE = 0 THEN @__BEFORE_IN_HOUSE + @__BEFORE_ASSY - @__CHARGING_QTY ' + char(10)
			SELECT @v_dSql1 += '					                               WHEN @__BEFORE_IN_HOUSE + @__BEFORE_ASSY - @__CHARGING_QTY > 0 THEN @__BEFORE_IN_HOUSE + @__BEFORE_ASSY - @__CHARGING_QTY ' + char(10)
			SELECT @v_dSql1 += '												   WHEN @__BEFORE_IN_HOUSE + @__BEFORE_ASSY - @__CHARGING_QTY + @__BEFORE_EX_WARE > 0 THEN 0 ' + char(10)
			SELECT @v_dSql1 += '												   ELSE @__BEFORE_IN_HOUSE + @__BEFORE_ASSY - @__CHARGING_QTY + @__BEFORE_EX_WARE END ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '					UPDATE A SET' + char(10)
			SELECT @v_dSql1 += '						  IN_HOUSE_QTY     = @__CURRENT_IN_HOUSE ' + char(10)
			SELECT @v_dSql1 += '						, EX_WARE_QTY      = @__CURRENT_EX_WARE ' + char(10)
			SELECT @v_dSql1 += '					FROM  #INV_CATEGORY A ' + char(10)
			SELECT @v_dSql1 += '					WHERE A.COMPANY_ID     = @__COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.DIVISION_ID    = @__DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.SITE_ID        = @__SITE_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.PLANT_ID       = @__PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.MODEL_ITEM_ID  = @__MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.MODULE_ITEM_ID = @__MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.CELL_ITEM_ID   = @__CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					AND   A.PLAN_DATE      = @__PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '					SET @__BEFORE_IN_HOUSE = @__CURRENT_IN_HOUSE ' + char(10)
			SELECT @v_dSql1 += '					SET @__BEFORE_EX_WARE  = @__CURRENT_EX_WARE ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '				END ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '				SET @__BEFORE_ASSY = @__ASSY_QTY ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '			END ' + char(10)	-- LOOP 2 END
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '		CLOSE C_ITEM_DATE_LIST ' + char(10)
			SELECT @v_dSql1 += '		DEALLOCATE C_ITEM_DATE_LIST ' + char(10)
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += '	END ' + char(10)	-- LOOP 1 END
			SELECT @v_dSql1 += '' + char(10)
			SELECT @v_dSql1 += 'CLOSE C_ITEM_LIST ' + char(10)
			SELECT @v_dSql1 += 'DEALLOCATE C_ITEM_LIST ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10)+char(10)

			-- week, month 별 막날짜 수량을 따로 update
			SELECT @v_dSql1 += 'UPDATE A SET ' + char(10)
			SELECT @v_dSql1 += '	   WEEK_IN_HOUSE_QTY  = (CASE WHEN B.DATE IS NOT NULL THEN A.IN_HOUSE_QTY ELSE 0 END) ' + char(10)
			SELECT @v_dSql1 += '	 , MONTH_IN_HOUSE_QTY = (CASE WHEN C.DATE IS NOT NULL THEN A.IN_HOUSE_QTY ELSE 0 END) ' + char(10)
			SELECT @v_dSql1 += '	 , WEEK_EX_WARE_QTY   = (CASE WHEN B.DATE IS NOT NULL THEN A.EX_WARE_QTY ELSE 0 END) ' + char(10)
			SELECT @v_dSql1 += '	 , MONTH_EX_WARE_QTY  = (CASE WHEN C.DATE IS NOT NULL THEN A.EX_WARE_QTY ELSE 0 END) ' + char(10)
			SELECT @v_dSql1 += 'FROM   #INV_CATEGORY A ' + char(10)
			SELECT @v_dSql1 += 'LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT B.ISO_YYYYWW AS WEEK ,MAX(B.YYYYMMDD) AS DATE ' + char(10) -- 주차별 막날짜
			SELECT @v_dSql1 += '	FROM   TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND    B.YYYYMMDD BETWEEN ''' + @p_plan_date + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY B.ISO_YYYYWW ' + char(10)
			SELECT @v_dSql1 += ') B ' + char(10)
			SELECT @v_dSql1 += 'ON  1=1 ' + char(10)
			SELECT @v_dSql1 += 'AND A.PLAN_DATE = B.DATE ' + char(10)
			SELECT @v_dSql1 += 'LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT B.YYYYMM AS MONTH ,MAX(B.YYYYMMDD) AS DATE ' + char(10) -- 월별 막날짜
			SELECT @v_dSql1 += '	FROM   TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND    B.YYYYMMDD BETWEEN ''' + @p_plan_date + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY YYYYMM ' + char(10)
			SELECT @v_dSql1 += ') C ' + char(10)
			SELECT @v_dSql1 += 'ON  1=1 ' + char(10)
			SELECT @v_dSql1 += 'AND A.PLAN_DATE = C.DATE ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10)+char(10)


			SELECT @v_dSql1 += 'SELECT * ' + char(10)
			SELECT @v_dSql1 += 'INTO #IN_HOUSE ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.MODEL AS MODEL_ITEM_ID, A.MODULE AS MODULE_ITEM_ID, A.CELL AS CELL_ITEM_ID, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)

			IF(LEN(@p_day_info) > 0)
			BEGIN
				-- month
				SELECT @v_tmp1 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			    WHILE LEN(@p_month_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp1 += '		 , SUM(CASE WHEN A.YYYYMM = ''' + @v_month_info + ''' THEN (CASE WHEN A.CATEGORY_ID = ''CATEGORY_12'' THEN B.MONTH_IN_HOUSE_QTY WHEN A.CATEGORY_ID = ''CATEGORY_13'' THEN B.MONTH_EX_WARE_QTY ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END
					
				-- week
			    SELECT @v_tmp2 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_week_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_week_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp2 += '		 , SUM(CASE WHEN A.ISO_YYYYWW = ''' + @v_week_info + ''' THEN (CASE WHEN A.CATEGORY_ID = ''CATEGORY_12'' THEN B.WEEK_IN_HOUSE_QTY WHEN A.CATEGORY_ID = ''CATEGORY_13'' THEN B.WEEK_EX_WARE_QTY ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 

				-- day
			    SELECT @v_tmp3 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

					SELECT @v_tmp3 += '		 , SUM(CASE WHEN A.YYYYMMDD = ''' + @v_day_info + ''' THEN (CASE WHEN A.CATEGORY_ID = ''CATEGORY_12'' THEN B.IN_HOUSE_QTY WHEN A.CATEGORY_ID = ''CATEGORY_13'' THEN B.EX_WARE_QTY ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + char(10)

			    END 
			END

			SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.*, D.YYYYMMDD, D.ISO_YYYYWW, D.YYYYMM ' + char(10)
			SELECT @v_dSql1 += '		FROM   #ITEM_LIST A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		, ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.SEGMENT3 AS CATEGORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.ATTRIBUTE1 AS CATEGORY_NAME ' + char(10)
			SELECT @v_dSql1 += '				 , A.SORT_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.LOOKUP_TYPE_CODE = ''UI_CATEGORY_DEFINITION'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT1 = ''P_FORM'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT2 = ''P_FORM_AMEND_UI'' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.SEGMENT3 IN (''CATEGORY_12'',''CATEGORY_13'') ' + char(10) 
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		, TH_UIS_CAL D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND   D.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN #INV_CATEGORY B ' + char(10)
			SELECT @v_dSql1 += '	ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODEL       = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.MODULE      = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.CELL        = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND A.YYYYMMDD    = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.MODEL, A.MODULE, A.CELL, A.NICK_NAME, A.SCP_EXTRA_SPEC, A.FP_EXTRA_SPEC ' + char(10)
			SELECT @v_dSql1 += '		   , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += ';' + char(10)+char(10)

			SELECT @v_dSql2 = ''
			SELECT @v_dSql2 += '------------------ v_dsql2 --------------------- ' + char(10)
			SELECT @v_dSql2 += 'SELECT A.* ' + char(10)
			SELECT @v_dSql2 += '	 , ISNULL(B.TOTAL_QTY, 0) AS TOTAL_QTY ' + char(10)
			SELECT @v_dSql2 += '	 , ISNULL(B.GOOD_QTY, 0) AS GOOD_QTY ' + char(10)
			SELECT @v_dSql2 += '	 , ISNULL(B.LONG_TERM_QTY, 0) AS LONG_TERM_QTY ' + char(10)
			SELECT @v_dSql2 += '	 , ISNULL(B.HOLD_QTY, 0) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql2 += '	 , ISNULL(B.QMS_HOLD_QTY, 0) AS QMS_HOLD_QTY ' + char(10)
			SELECT @v_dSql2 += '	 , ISNULL(B.MES_HOLD_QTY, 0) AS MES_HOLD_QTY ' + char(10)
			SELECT @v_dSql2 += '	 , ISNULL(B.USELESS_QTY, 0) AS USELESS_QTY ' + char(10)
			SELECT @v_dSql2 += '	 , ''DATA'' AS  DATA_TYPE ' + char(10)
			SELECT @v_dSql2 += '	 , (CASE WHEN A.CATEGORY_ID IN (''CATEGORY_04'',''CATEGORY_09'') THEN ''Y'' ELSE ''N'' END) AS EDIT_YN ' + char(10)
			SELECT @v_dSql2 += 'FROM ( ' + char(10)
			SELECT @v_dSql2 += '	SELECT * FROM #BASE_MAIN A ' + char(10)
			SELECT @v_dSql2 += '	UNION ALL ' + char(10)
			SELECT @v_dSql2 += '	SELECT * FROM #CMA_PKG A ' + char(10) -- CMA PKG(P5500)
			SELECT @v_dSql2 += '	UNION ALL ' + char(10)
			SELECT @v_dSql2 += '	SELECT * FROM #WAIT_DISC ' + char(10) -- Waiting Discharge
			SELECT @v_dSql2 += '	UNION ALL ' + char(10)
			SELECT @v_dSql2 += '	SELECT * FROM #AGING_STOCK ' + char(10) -- Aging Stock
			SELECT @v_dSql2 += '	UNION ALL ' + char(10)
			SELECT @v_dSql2 += '	SELECT * FROM #WAIT_CHAR ' + char(10) -- Waiting Charge
			SELECT @v_dSql2 += '	UNION ALL ' + char(10)
			SELECT @v_dSql2 += '	SELECT * FROM #IN_HOUSE ' + char(10) -- In house Inventory
			SELECT @v_dSql2 += ') A ' + char(10)
			SELECT @v_dSql2 += 'LEFT OUTER JOIN #BOH_LIST B ' + char(10)
			SELECT @v_dSql2 += 'ON 1=1 ' + char(10)
			SELECT @v_dSql2 += 'AND A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += 'AND A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += 'AND A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += 'AND A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += 'AND A.MODEL_ITEM_ID  = B.MODEL_ITEM_ID ' + char(10)
			SELECT @v_dSql2 += 'AND A.MODULE_ITEM_ID = B.MODULE_ITEM_ID ' + char(10)
			SELECT @v_dSql2 += 'AND A.CELL_ITEM_ID   = B.CELL_ITEM_ID ' + char(10)
			SELECT @v_dSql2 += 'AND A.CATEGORY_ID    = B.CATEGORY_ID ' + char(10)
			SELECT @v_dSql2 += 'WHERE 1=1 ' + char(10)





			-- 모델 조건
			DECLARE @dateString NVARCHAR(MAX)
			SET @dateString = ''

			IF(LEN(@p_day_info) > 0)
			BEGIN

				-- day
			    SELECT @v_tmp3 = ''
			    SELECT @max_loop_cnt = 0
			    SELECT @mst_loop_cnt = 0
			    SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			    WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN
					SELECT @mst_loop_cnt = @mst_loop_cnt + 1
					SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)


					IF @v_day_info >= @p_plan_date -- 계획구간
					BEGIN
						
						IF @dateString = ''
						BEGIN
							SET @dateString += 'D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '<0'

						END
						ELSE 
						BEGIN
							SET @dateString += ' OR D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '<0'

						END

					END

			    END 

				-- 유효한 계획구간이 존재하면 조건을 수립
				IF (@dateString != '' AND ( @v_refCMA = 'Y' OR @v_refWaitChar = 'Y' OR @v_refModel = 'Y' ))
				BEGIN

					SELECT @v_dSql2 += 'AND A.MODEL_ITEM_ID IN ( ' + char(10)
					-- 1) 충방전 계획,실적,출하 수량 존재하는 모델에 대해서만 조회해주는 조건
					SELECT @v_dSql2 += '		SELECT DISTINCT A.MODEL_ITEM_ID ' + char(10)
					SELECT @v_dSql2 += '		FROM   FP_AMEND_PLAN_P_FORM_R A WITH(NOLOCK) ' + char(10)
					IF @v_refModel = 'Y' BEGIN
						SELECT @v_dSql2 += '		WHERE  1=1 ' + char(10)
					END
					ELSE BEGIN
						SELECT @v_dSql2 += '		WHERE  1=0 ' + char(10)
					END
					SELECT @v_dSql2 += '		AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
					SELECT @v_dSql2 += '		AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
					SELECT @v_dSql2 += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
					SELECT @v_dSql2 += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
					SELECT @v_dSql2 += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
					SELECT @v_dSql2 += '		AND    A.CATEGORY_ID IN (''CATEGORY_04'', ''CATEGORY_09'', ''CATEGORY_05'', ''CATEGORY_10'', ''CATEGORY_01'') ' + char(10)
					SELECT @v_dSql2 += '		AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,''' + @p_bucket_from + ''') AND CONVERT(DATETIME,''' + @p_bucket_to + ''') ' + char(10)

					-- 2) CMA PKG 음수
					SELECT @v_dSql2 += '		UNION ' + char(10)
					SELECT @v_dSql2 += '		SELECT DISTINCT A.MODEL_ITEM_ID ' + char(10)
					SELECT @v_dSql2 += '		FROM   #CMA_PKG A ' + char(10)
					IF @v_refCMA = 'Y' BEGIN
						SELECT @v_dSql2 += '		WHERE  1=1 ' + char(10)
					END
					ELSE BEGIN
						SELECT @v_dSql2 += '		WHERE  1=0 ' + char(10)
					END
					SELECT @v_dSql2 += '		AND    ( ' + @dateString + ' ) ' + char(10)

					-- 3) Waiting Charge 음수
					SELECT @v_dSql2 += '		UNION ' + char(10)
					SELECT @v_dSql2 += '		SELECT DISTINCT A.MODEL_ITEM_ID ' + char(10)
					SELECT @v_dSql2 += '		FROM   #WAIT_CHAR A ' + char(10)
					IF @v_refWaitChar = 'Y' BEGIN
						SELECT @v_dSql2 += '		WHERE  1=1 ' + char(10)
					END
					ELSE BEGIN
						SELECT @v_dSql2 += '		WHERE  1=0 ' + char(10)
					END
					SELECT @v_dSql2 += '		AND    ( ' + @dateString + ' ) ' + char(10)
					SELECT @v_dSql2 += ') ' + char(10)

				END

			END





			SELECT @v_dSql2 += 'ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '	   , A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql2 += '	   , A.MODEL_ITEM_ID, A.MODULE_ITEM_ID, A.CELL_ITEM_ID ' + char(10)

			
			SELECT @v_dSql = '';
			SELECT @v_dSql = @v_dSql0 + @v_dSql1 + @v_dSql2 + @v_dSql3;

		    IF @p_sys_type = 'SQL'
		  	BEGIN
		  	  	EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, 'select',@runstart, @runend
		  	  	SELECT @v_dSql as [QUERY_VALUE]
		  	  
		  	END  
		    ELSE 
		  	BEGIN
				EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, 'select',@runstart, @runend

		  	  	SET @runstart = GetDate()
		  	  	--쿼리실행
		  	  	EXEC sp_executesql @v_dSql
		  	  	  
		  	  	SET @runend = GetDate()

		  	END

			BEGIN
				if object_id('tempdb..#ITEM_LIST') is not null 
					DROP TABLE #ITEM_LIST

				if object_id('tempdb..#BOH_LIST') is not null 
					DROP TABLE #BOH_LIST

				if object_id('tempdb..#AMEND_LIST') is not null 
					DROP TABLE #AMEND_LIST

				if object_id('tempdb..#BASE_MAIN') is not null 
					DROP TABLE #BASE_MAIN

				if object_id('tempdb..#CMA_PKG') is not null 
					DROP TABLE #CMA_PKG

				if object_id('tempdb..#WAIT_DISC') is not null 
					DROP TABLE #WAIT_DISC

				if object_id('tempdb..#AGING_STOCK') is not null 
					DROP TABLE #AGING_STOCK

				if object_id('tempdb..#WAIT_CHAR') is not null 
					DROP TABLE #WAIT_CHAR

				if object_id('tempdb..#INV_CATEGORY') is not null 
					DROP TABLE #INV_CATEGORY

				if object_id('tempdb..#IN_HOUSE') is not null 
					DROP TABLE #IN_HOUSE

				--if object_id('tempdb..#SSP_RAW_DATA') is not null 
					--DROP TABLE #SSP_RAW_DATA

			END

        END	--IF( END )
	/************************************************************************************************/
	/* SELECT인경우 :FIND_AMEND_VALIDATION_EPOST                                                    */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='FIND_AMEND_VALIDATION_EPOST')
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
                        --, @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter,  @mst_loop_cnt)
                        --, @v_line_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,     @v_delimiter,  @mst_loop_cnt)
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

