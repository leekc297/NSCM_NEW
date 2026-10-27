

/*
 * Program ID   : PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT
 * Description  : Plan Result (Elec Post Shift) 화면
 * Program History : FP02842 소스 참조
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/03/16   LJS				Initial 
 * 2022/07/22   LJS             실적 달성률 표시, 조회기준 품번을 유의미한 수량의 계획or실적 정보 기준으로 변경
 * 2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 뷰로 변경
 */

--CREATE 
CREATE
PROCEDURE [dbo].[PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT]
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
  @p_uom		                NVARCHAR(MAX),
  @p_bucket_from                NVARCHAR(MAX),
  @p_bucket_to                  NVARCHAR(MAX),
  @p_day_info                   NVARCHAR(MAX),
  @p_week_info                  NVARCHAR(MAX),
  @p_month_info                 NVARCHAR(MAX),
  @p_cate_info                  NVARCHAR(MAX),
  @p_cate_value                 NVARCHAR(MAX),
  @p_cate_type                  NVARCHAR(MAX),

  @p_amend_table                NVARCHAR(100), -- FP_DAILY_SHIFT_PROD_PLAN_H
  @p_total_table                NVARCHAR(100)  -- PRODUCTION_TYPE
  --,@p_amend_cutoff_boh_table     NVARCHAR(100),
  --@p_amend_bor_table            NVARCHAR(100),
  --@p_amend_boh_table            NVARCHAR(100),
  --@p_amend_sales_table          NVARCHAR(100),
  --@p_amend_util_table           NVARCHAR(100),
  --@p_amend_capa_table           NVARCHAR(100)

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
	DECLARE @v_uom                        NVARCHAR(MAX)
    DECLARE @v_bucket_from_date           NVARCHAR(MAX)
    DECLARE @v_bucket_to_date             NVARCHAR(MAX)
    DECLARE @v_day_info                   NVARCHAR(MAX)
    DECLARE @v_week_info                  NVARCHAR(MAX)
    DECLARE @v_month_info                 NVARCHAR(MAX)
    DECLARE @v_cate_info                  NVARCHAR(MAX)
	DECLARE @v_cate_value                 NVARCHAR(MAX)
    DECLARE @v_cate_type                  NVARCHAR(MAX)
    DECLARE @v_amend_table                NVARCHAR(100) = 'FP_DAILY_SHIFT_PROD_PLAN_H'
	DECLARE @v_total_table                NVARCHAR(100) = ''
	DECLARE @v_plannedline                NVARCHAR(10)
	DECLARE @v_production_type            NVARCHAR(MAX)

    --DECLARE @v_amend_cutoff_boh_table     NVARCHAR(100) = 'FP_AMEND_CUTOFF_BOH_R'
    --DECLARE @v_amend_bor_table            NVARCHAR(100) = 'FP_AMEND_DAILY_BOR_R'
	--DECLARE @v_amend_boh_table            NVARCHAR(100) = 'FP_AMEND_DAILY_BOH_R'
    --DECLARE @v_amend_sales_table          NVARCHAR(100) = 'FP_AMEND_DAILY_SALES_R'
    --DECLARE @v_amend_util_table           NVARCHAR(100) = 'FP_AMEND_DAILY_UTIL_R'
	--DECLARE @v_amend_capa_table           NVARCHAR(100) = 'FP_AMEND_DAILY_CAPA_R'
	
	-- uom 별 컬럼
	DECLARE @v_uom_text					NVARCHAR(100)
	DECLARE @v_uom_col_out				NVARCHAR(100)
	DECLARE @v_uom_col_result_out		NVARCHAR(100)
	DECLARE @v_uom_total_col_out		NVARCHAR(100)
	DECLARE @v_uom_total_col_result_out	NVARCHAR(100)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP02845_PLAN_RESULT_ELEC_POST_SHIFT'
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
	set @v_plannedline = @p_nick_name_lt
	set @v_production_type = @p_total_table

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
	SET @v_dSql0                = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

	SET	@pSql                   = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''

	SET @v_uom_text				    = 'M(J/R)'
	SET @v_uom_col_out			    = 'JR_OUT_QTY'
	SET @v_uom_col_result_out       = 'JR_RESULT_OUT_QTY'
	SET @v_uom_total_col_out        = 'JR_TOTAL_QTY'
	SET @v_uom_total_col_result_out = 'JR_TOTAL_RESULT_QTY'

	IF @p_uom = 'PC'
	BEGIN
		SET @v_uom_text					= 'M(P/C)'
		SET @v_uom_col_out			    = 'PC_OUT_QTY'
		SET @v_uom_col_result_out       = 'PC_RESULT_OUT_QTY'
		SET @v_uom_total_col_out        = 'PC_TOTAL_QTY'
		SET @v_uom_total_col_result_out = 'PC_TOTAL_RESULT_QTY'
	END
	ELSE IF @p_uom = 'CELL'
	BEGIN
		SET @v_uom_text					= 'CELL'
		SET @v_uom_col_out			    = 'CELL_OUT_QTY'
		SET @v_uom_col_result_out       = 'CELL_RESULT_OUT_QTY'
		SET @v_uom_total_col_out        = 'CELL_TOTAL_QTY'
		SET @v_uom_total_col_result_out = 'CELL_TOTAL_RESULT_QTY'
	END


	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
			
			-- 환산자 로직 시작!!!
			--@v_dSql0
			SELECT @v_dSql0 = ''
			SELECT @v_dSql0 += '------------------------------------v_dSql0-----------------------------' + char(10)

			SELECT @v_dSql0 += 'if object_id(''tempdb..#W_EXCHANGE'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #W_EXCHANGE ; ' + char(10)
			SELECT @v_dSql0 += '' + char(10)
			SELECT @v_dSql0 += 'if object_id(''tempdb..#CALC'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #CALC ; ' + char(10)
			SELECT @v_dSql0 += '' + char(10)
			SELECT @v_dSql0 += 'if object_id(''tempdb..#LINE_ASSIGN'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #LINE_ASSIGN ; ' + char(10)
			SELECT @v_dSql0 += '' + char(10)
			SELECT @v_dSql0 += 'if object_id(''tempdb..#PLAN_SUMQTY'') is not null ' + char(10)
			SELECT @v_dSql0 += '	DROP TABLE #PLAN_SUMQTY ; ' + char(10)
			SELECT @v_dSql0 += '' + char(10)

			/*
			--- 변경전 로직
			SELECT @v_dSql0 += 'WITH STOCK AS ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT 	A.FACTORY_ID, A.FP_APPLY_ITEM_ID AS ITEM_ID, B.NICK_NAME, B.FLOW_ID, ' + char(10)
			SELECT @v_dSql0 += '						CASE WHEN A.FP_APPLY_ITEM_ID LIKE ''APCA%'' THEN ''Anode'' ' + char(10)
			SELECT @v_dSql0 += '							 WHEN A.FP_APPLY_ITEM_ID LIKE ''APCC%'' THEN ''Cathode'' ' + char(10)
			SELECT @v_dSql0 += '							 ELSE ''-'' END 	AS ELECTROD_TYPE, ' + char(10)
			SELECT @v_dSql0 += '						CASE WHEN A.OPERATION_ID > ''E4000'' THEN ''P'' ' + char(10)
			SELECT @v_dSql0 += '							 WHEN A.OPERATION_ID = ''E4000'' THEN ''J'' ' + char(10)
			SELECT @v_dSql0 += '							 ELSE ''J'' END AS ROLL_TYPE, ' + char(10)
			SELECT @v_dSql0 += '						CASE WHEN A.OPERATION_ID > ''E4000'' THEN ISNULL(C.SEGMENT2, ''B'') ' + char(10)
			SELECT @v_dSql0 += '							 ELSE ''-'' END AS ATTR_TYPE, ' + char(10)
			SELECT @v_dSql0 += '						A.LANE, QTY, A.FP_APPLY_WIPQTY, ' + char(10)
			SELECT @v_dSql0 += '						A.FP_APPLY_OPERATION_ID, ' + char(10)
			SELECT @v_dSql0 += '						A.POSITION_CATEGORY, A.DETAIL_POSITION, A.LOT_COUNT, ' + char(10)
			SELECT @v_dSql0 += '						A.COATING_LINE_ID ' + char(10)
			SELECT @v_dSql0 += '			FROM 	SCM_STOCK_H_V A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			ON 	    1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND 	C.LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT'' ' + char(10)
			SELECT @v_dSql0 += '			AND 	C.SEGMENT1 = ''' + @v_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '			AND 	B.NICK_NAME LIKE C.SEGMENT4 ' + char(10)
			SELECT @v_dSql0 += '			WHERE 	1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.CUTOFF_DATE = ''' + @p_bucket_from + ''' ' + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '			AND 	A.FP_APPLY_ITEM_ID LIKE ''APC%'' ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.COMPANY_ID = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.SITE_ID = B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.ITEM_ID = B.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	B.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.STOCK_TYPE = ''WIP'' ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.WIPHOLD_YN = ''N'' ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.FACTORY_ID LIKE ''E%'' ' + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += ', ITEM_STOCK AS ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT 	FACTORY_ID, ITEM_ID, ROLL_TYPE, SUM(QTY)/SUM(LOT_COUNT) AS M_ROLL ' + char(10)
			SELECT @v_dSql0 += '			FROM 	STOCK ' + char(10)
			SELECT @v_dSql0 += '			WHERE 	1=1 ' + char(10)
			SELECT @v_dSql0 += '			GROUP BY FACTORY_ID, ITEM_ID, ROLL_TYPE ' + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += ', FACTORY_STOCK AS ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT 	FACTORY_ID, ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE, SUM(QTY)/SUM(LOT_COUNT) AS M_ROLL ' + char(10)
			SELECT @v_dSql0 += '			FROM 	STOCK ' + char(10)
			SELECT @v_dSql0 += '			WHERE 	1=1 ' + char(10)
			SELECT @v_dSql0 += '			GROUP BY FACTORY_ID, ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += ', SITE_STOCK AS ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT 	ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE, SUM(QTY)/SUM(LOT_COUNT) AS M_ROLL ' + char(10)
			SELECT @v_dSql0 += '			FROM 	STOCK ' + char(10)
			SELECT @v_dSql0 += '			WHERE 	1=1 ' + char(10)
			SELECT @v_dSql0 += '			GROUP BY ELECTROD_TYPE, ROLL_TYPE, ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += ', ATTR_TYPE AS ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT ' + char(10)
			SELECT @v_dSql0 += '			FROM   SCM_SYS_LOOKUP_VALUE LV with(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			JOIN   FP_INSTANCE_INFO_V FII with(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			ON 	   1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND    LV.SEGMENT1 = FII.INSTANCE_ID ' + char(10)
			SELECT @v_dSql0 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND    LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT'' ' + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += ', PLAN_ITEM AS ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, B.NICK_NAME, ' + char(10)
			SELECT @v_dSql0 += '					CASE WHEN A.ITEM_ID LIKE ''APCA%'' THEN ''Cathode'' ELSE ''Anode'' END AS ELECTROD_TYPE, ' + char(10)
			SELECT @v_dSql0 += '					(CASE WHEN C.ATTR_DEFINIT IS NULL THEN ''B'' ELSE ''A'' END) AS ATTR_TYPE, ' + char(10)
			SELECT @v_dSql0 += '					B.FLOW_ID, CONVERT(NUMERIC(20,10), ATTB_5) AS LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '			FROM 	FP_DAILY_SHIFT_PROD_PLAN_H A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			LEFT OUTER JOIN ATTR_TYPE C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			ON      1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND     B.NICK_NAME LIKE C.ATTR_DEFINIT ' + char(10)
			SELECT @v_dSql0 += '			WHERE 	1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.SITE_ID = B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	A.ITEM_ID = B.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '			AND 	B.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, B.NICK_NAME, (CASE WHEN C.ATTR_DEFINIT IS NULL THEN ''B'' ELSE ''A'' END), B.FLOW_ID, ATTB_5 ' + char(10)
			SELECT @v_dSql0 += ')' + char(10)
			SELECT @v_dSql0 += ', M_PRIORITY AS ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT 	SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS A1, ATTRIBUTE2 AS A2, ATTRIBUTE3 AS A3, ATTRIBUTE4 AS A4 ' + char(10)
			SELECT @v_dSql0 += '			FROM 	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			WHERE 	1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND 	LOOKUP_TYPE_CODE = ''E_POST_ROLL_DEFAULT_DEFINIT'' ' + char(10)
			SELECT @v_dSql0 += '            AND 	SEGMENT1 = ''' + @v_instance_id + ''' ' + char(10) + char(10)
			SELECT @v_dSql0 += ') ' + char(10)
			SELECT @v_dSql0 += 'SELECT 	A.*, ' + char(10)
			SELECT @v_dSql0 += '			CASE WHEN A1 = ''SITE_STOCK'' THEN G.M_ROLL ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' ) THEN E.M_ROLL ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 = ''SITE_STOCK'' OR A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'' ) THEN ISNULL(E.M_ROLL, G.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  AND A4 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  THEN C.M_ROLL' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 != ''FACTORY_STOCK'' AND A3 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  E.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'') AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'')  THEN ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL)) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   AND A4 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   THEN B.JUMBO_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, G.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(E.M_ROLL, G.M_ROLL)) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 != ''SITE_STOCK'' OR A4 != ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, E.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 = ''FACTORY_STOCK'' AND A4 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL))) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND (A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, E.M_ROLL)) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 != ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, G.M_ROLL)) ' + char(10)
			SELECT @v_dSql0 += '				 ELSE NULL END AS JR_M_ROLL, ' + char(10)
			SELECT @v_dSql0 += '			CASE WHEN A1 = ''SITE_STOCK'' THEN G.M_ROLL ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' ) THEN E.M_ROLL * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 = ''SITE_STOCK'' OR A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'' ) THEN ISNULL(E.M_ROLL, G.M_ROLL) * A.LANE_QTY  ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  AND A4 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  THEN C.M_ROLL * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) * A.LANE_QTY' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 != ''FACTORY_STOCK'' AND A3 = ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  G.M_ROLL) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(C.M_ROLL,  E.M_ROLL) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'') AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'')  THEN ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL)) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   AND A4 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   THEN B.JUMBO_ROLL_LENGTH * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, G.M_ROLL) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(E.M_ROLL, G.M_ROLL)) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 != ''SITE_STOCK'' OR A4 != ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, E.M_ROLL) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 = ''FACTORY_STOCK'' AND A4 = ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, ISNULL(E.M_ROLL, G.M_ROLL))) * A.LANE_QTY  ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND (A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, E.M_ROLL)) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 != ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.JUMBO_ROLL_LENGTH, ISNULL(C.M_ROLL, G.M_ROLL)) * A.LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '				 ELSE NULL END AS JR_PC_M_ROLL, ' + char(10)
			SELECT @v_dSql0 += '			CASE WHEN A1 = ''SITE_STOCK'' THEN H.M_ROLL ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' ) THEN F.M_ROLL ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''FACTORY_STOCK'' AND (A2 = ''SITE_STOCK'' OR A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'' ) THEN ISNULL(F.M_ROLL, H.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  AND A4 NOT IN (''FACTORY_STOCK'',''SITE_STOCK'')  THEN D.M_ROLL ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 = ''SITE_STOCK'' THEN ISNULL(D.M_ROLL,  H.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND A2 != ''FACTORY_STOCK'' AND A3 = ''SITE_STOCK'' THEN ISNULL(D.M_ROLL,  H.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A2 != ''SITE_STOCK'' AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(D.M_ROLL,  F.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM_STOCK'' AND (A2 = ''FACTORY_STOCK'' OR A3 = ''FACTORY_STOCK'') AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'')  THEN ISNULL(D.M_ROLL, ISNULL(F.M_ROLL, H.M_ROLL)) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'') AND  A3 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   AND A4 NOT IN (''ITEM_STOCK'',''FACTORY_STOCK'',''SITE_STOCK'')   THEN B.PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''SITE_STOCK'' THEN ISNULL(B.PC_ROLL_LENGTH, H.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(F.M_ROLL, H.M_ROLL)) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''FACTORY_STOCK'' AND (A3 != ''SITE_STOCK'' OR A4 != ''SITE_STOCK'') THEN ISNULL(B.PC_ROLL_LENGTH, F.M_ROLL) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 = ''FACTORY_STOCK'' AND A4 = ''SITE_STOCK'' THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(D.M_ROLL, ISNULL(F.M_ROLL, H.M_ROLL))) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND (A3 = ''FACTORY_STOCK'' OR A4 = ''FACTORY_STOCK'') AND A3 != ''SITE_STOCK'' AND A4 != ''SITE_STOCK'' THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(D.M_ROLL, F.M_ROLL)) ' + char(10)
			SELECT @v_dSql0 += '				 WHEN A1 = ''ITEM'' AND A2 = ''ITEM_STOCK'' AND A3 != ''FACTORY_STOCK'' AND (A3 = ''SITE_STOCK'' OR A4 = ''SITE_STOCK'') THEN ISNULL(B.PC_ROLL_LENGTH, ISNULL(D.M_ROLL, H.M_ROLL))  ' + char(10)
			SELECT @v_dSql0 += '				 ELSE NULL END AS PC_M_ROLL ' + char(10)
			SELECT @v_dSql0 += 'INTO #W_EXCHANGE ' + char(10)
			SELECT @v_dSql0 += 'FROM 	PLAN_ITEM A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER JOIN SCM_ITEM_LANE_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON 	1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.COMPANY_ID = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.SITE_ID = B.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.PLANT_ID = B.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.FACTORY_ID = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.ITEM_ID = B.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += 'AND B.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER JOIN ITEM_STOCK C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON 	1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.FACTORY_ID = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.ITEM_ID = C.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += 'AND C.ROLL_TYPE = ''J'' ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER JOIN ITEM_STOCK D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON 	1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.FACTORY_ID = D.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.ITEM_ID = D.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += 'AND D.ROLL_TYPE = ''P'' ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER JOIN FACTORY_STOCK E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON 	1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.FACTORY_ID = E.FACTORY_ID  ' + char(10)
			SELECT @v_dSql0 += 'AND A.ELECTROD_TYPE = E.ELECTROD_TYPE ' + char(10)
			SELECT @v_dSql0 += 'AND E.ROLL_TYPE = ''J'' ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER JOIN FACTORY_STOCK F WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON 	1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.FACTORY_ID = F.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.ELECTROD_TYPE = F.ELECTROD_TYPE ' + char(10)
			SELECT @v_dSql0 += 'AND A.ATTR_TYPE = F.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += 'AND F.ROLL_TYPE = ''P'' ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER JOIN SITE_STOCK G WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON 	1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.ELECTROD_TYPE = G.ELECTROD_TYPE ' + char(10)
			SELECT @v_dSql0 += 'AND G.ROLL_TYPE = ''J'' ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER JOIN SITE_STOCK H WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON 	1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.ELECTROD_TYPE = H.ELECTROD_TYPE ' + char(10)
			SELECT @v_dSql0 += 'AND A.ATTR_TYPE = H.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += 'AND H.ROLL_TYPE = ''P'', ' + char(10)
			SELECT @v_dSql0 += 'M_PRIORITY I ' + char(10)
			SELECT @v_dSql0 += 'WHERE 	1=1' + char(10)
			SELECT @v_dSql0 += '; ' + char(10)
			*/

			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE, LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '     , ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) AS JR_M_ROLL ' + char(10)
			SELECT @v_dSql0 += '     , (CASE WHEN ''' + @p_uom + ''' = ''JR'' THEN ISNULL(A.JUMBO_ROLL_LENGTH, B.JUMBO_ROLL_LENGTH) ' + char(10)
			SELECT @v_dSql0 += '     		 ELSE  ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) * LANE_QTY END) AS JR_PC_M_ROLL ' + char(10)
			SELECT @v_dSql0 += '     , ISNULL(A.PC_ROLL_LENGTH, B.PC_ROLL_LENGTH) AS PC_M_ROLL ' + char(10)
			SELECT @v_dSql0 += 'INTO #W_EXCHANGE ' + char(10)
			SELECT @v_dSql0 += 'FROM ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += '		 , CASE WHEN A.ITEM_ID LIKE ''APCA%'' THEN ''ANODE'' ' + char(10)
			SELECT @v_dSql0 += '		 		WHEN A.ITEM_ID LIKE ''APCC%'' THEN ''CATHODE'' ' + char(10)
			SELECT @v_dSql0 += '		 	    END AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql0 += '		 , MAX(CASE WHEN A.FLOW_ID = ''E2000E3000'' THEN 1 ELSE ISNULL(B.LANE_QTY, ISNULL(C.LANE_QTY, ISNULL(D.LANE_QTY, E.LANE_QTY))) END) AS LANE_QTY ' + char(10)
			SELECT @v_dSql0 += '		 , MAX( B.JUMBO_ROLL_LENGTH ) AS JUMBO_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '		 , MAX( B.PC_ROLL_LENGTH ) AS PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '	FROM ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, ''B'') AS ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '				INNER HASH JOIN ( ' + char(10)
			SELECT @v_dSql0 += '						SELECT DISTINCT COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '						FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '						WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '						AND    INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '				) B ' + char(10)
			SELECT @v_dSql0 += '				ON   1=1 ' + char(10)
			SELECT @v_dSql0 += '				AND  B.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '				AND  B.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '				AND  B.SITE_ID 		= A.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '				AND  B.PLANT_ID 	= A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '				INNER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '				ON   1=1 ' + char(10)
			SELECT @v_dSql0 += '				AND  A.COMPANY_ID	= C.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '				AND  A.DIVISION_ID	= C.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '				AND  A.SITE_ID		= C.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '				AND  A.ITEM_ID		= C.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '				AND  C.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '				LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '						SELECT DISTINCT SEGMENT1 AS INSTANCE_ID, FII.COMPANY_ID, FII.DIVISION_ID, FII.SITE_ID, FII.PLANT_ID, SEGMENT2 AS ATTR_TYPE, SEGMENT3 AS ATTR_CATEGORY, SEGMENT4 AS ATTR_DEFINIT ' + char(10)
			SELECT @v_dSql0 += '						FROM   SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '						JOIN   FP_INSTANCE_INFO_V FII WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '						ON 	   1=1 ' + char(10)
			SELECT @v_dSql0 += '						AND    LV.SEGMENT1 = FII.INSTANCE_ID ' + char(10)
			SELECT @v_dSql0 += '						WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '						AND    LOOKUP_TYPE_CODE = ''E_POST_WH_ATTR_TYPE_DEFINIT'' ' + char(10)
			SELECT @v_dSql0 += '				) E ' + char(10)
			SELECT @v_dSql0 += '				ON 	  1=1 ' + char(10)
			SELECT @v_dSql0 += '				AND   C.NICK_NAME LIKE E.ATTR_DEFINIT ' + char(10)
			SELECT @v_dSql0 += '				WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, C.FLOW_ID, C.NICK_NAME, ISNULL(E.ATTR_TYPE, ''B'') ' + char(10)
			SELECT @v_dSql0 += '	) A ' + char(10)
			SELECT @v_dSql0 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '				AND    A.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
			SELECT @v_dSql0 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	) B ' + char(10)
			SELECT @v_dSql0 += '	ON   1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND  B.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  B.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  B.SITE_ID 		= A.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  B.PLANT_ID 	= A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  B.FACTORY_ID 	= A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  B.ITEM_ID 		= A.ITEM_ID	' + char(10)
			SELECT @v_dSql0 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	) C ' + char(10)
			SELECT @v_dSql0 += '	ON   1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND  C.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  C.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  C.SITE_ID 		= A.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  C.PLANT_ID 	= A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  B.FACTORY_ID 	= A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  C.ITEM_ID 		= A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '				AND    A.PROD_VERSION_TYPE = ''E3000E4000'' ' + char(10)
			SELECT @v_dSql0 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	) D ' + char(10)
			SELECT @v_dSql0 += '	ON   1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND  D.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  D.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  D.SITE_ID 		= A.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  D.PLANT_ID 	= A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  D.ITEM_ID 		= A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '					 , MAX( A.LANE_QTY ) AS LANE_QTY, MAX(A.JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(A.PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '				FROM   SCM_ITEM_LANE_M A  WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += ' 		        '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	) E ' + char(10)
			SELECT @v_dSql0 += '	ON   1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND  E.COMPANY_ID 	= A.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  E.DIVISION_ID 	= A.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  E.SITE_ID 		= A.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  E.PLANT_ID 	= A.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '	AND  E.ITEM_ID 		= A.ITEM_ID	' + char(10)
			SELECT @v_dSql0 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.NICK_NAME, A.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += ') A ' + char(10)
			SELECT @v_dSql0 += 'LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql0 += '		SELECT FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += '			 , MAX(JUMBO_ROLL_LENGTH) AS JUMBO_ROLL_LENGTH, MAX(PC_ROLL_LENGTH) AS PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '		FROM ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT FACTORY_ID, ELECTRODE_TYPE, B.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += '						, CASE WHEN B.UOM_TYPE = ''JR'' THEN JR_COL END AS JUMBO_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '						, CASE WHEN B.UOM_TYPE = ''PC'' AND B.ATTR_TYPE = ''A'' THEN A_TYPE_COL ' + char(10)
			SELECT @v_dSql0 += '						       WHEN B.UOM_TYPE = ''PC'' AND B.ATTR_TYPE = ''B'' THEN B_TYPE_COL ' + char(10)
			SELECT @v_dSql0 += '						       ELSE 0 END AS PC_ROLL_LENGTH ' + char(10)
			SELECT @v_dSql0 += '				FROM ( ' + char(10)
			SELECT @v_dSql0 += '						SELECT FACTORY_ID, ELECTRODE_TYPE, ISNULL([-],0) AS JR_COL, ISNULL([A],0) AS A_TYPE_COL, ISNULL([B],0) AS B_TYPE_COL ' + char(10)
			SELECT @v_dSql0 += '						FROM ( ' + char(10)
			SELECT @v_dSql0 += '							SELECT SEGMENT2 AS FACTORY_ID, ' + char(10)
			SELECT @v_dSql0 += '									CASE WHEN SEGMENT3 = ''A'' THEN ''ANODE'' ' + char(10)
			SELECT @v_dSql0 += '										 WHEN SEGMENT3 = ''C'' THEN ''CATHODE'' ' + char(10)
			SELECT @v_dSql0 += '										 ELSE SEGMENT3 END AS ELECTRODE_TYPE, SEGMENT4 AS ATTR_TYPE, ATTRIBUTE1 AS ROLL_QTY ' + char(10)
			SELECT @v_dSql0 += '							FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '							WHERE	A.LOOKUP_TYPE_CODE = ''E_POST_JR_DEFAULT_DEFINIT'' ' + char(10)
			SELECT @v_dSql0 += '							AND		A.SEGMENT1         = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql0 += '							AND		A.ACTIVE_FLAG      = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '						) AS RESULT ' + char(10)
			SELECT @v_dSql0 += '						PIVOT (	' + char(10)
			SELECT @v_dSql0 += '							MAX(ROLL_QTY) FOR ATTR_TYPE IN ([-], [A], [B]) ' + char(10)
			SELECT @v_dSql0 += '						) AS PIV ' + char(10)
			SELECT @v_dSql0 += '				) A ' + char(10)
			SELECT @v_dSql0 += '				JOIN ( ' + char(10)
			SELECT @v_dSql0 += '						SELECT ''JR'' AS UOM_TYPE , ''A'' AS ATTR_TYPE UNION ' + char(10)
			SELECT @v_dSql0 += '						SELECT ''JR'' AS UOM_TYPE , ''B'' AS ATTR_TYPE UNION ' + char(10)
			SELECT @v_dSql0 += '						SELECT ''PC'' AS UOM_TYPE , ''A'' AS ATTR_TYPE UNION ' + char(10)
			SELECT @v_dSql0 += '						SELECT ''PC'' AS UOM_TYPE , ''B'' AS ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += '				) B ' + char(10)
			SELECT @v_dSql0 += '				ON 1=1 ' + char(10)
			SELECT @v_dSql0 += '				WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += '		) A ' + char(10)
			SELECT @v_dSql0 += '		GROUP BY FACTORY_ID, ELECTRODE_TYPE, A.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += ') B ' + char(10)
			SELECT @v_dSql0 += 'ON  1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql0 += 'AND A.ATTR_TYPE      = B.ATTR_TYPE ' + char(10)
			SELECT @v_dSql0 += 'WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)

			SELECT @v_dSql0 += 'SELECT * ' + char(10)
			SELECT @v_dSql0 += 'INTO #CALC ' + char(10)
			SELECT @v_dSql0 += 'FROM ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.* ' + char(10)
			SELECT @v_dSql0 += '		 , ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.OPERATION, A.VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '							 ORDER BY     A.APPLY_DATE DESC) ROW_NUM ' + char(10)
			SELECT @v_dSql0 += '	FROM ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '				 , A.OPERATION, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '				 , UPPER(A.CATEGORY) AS CATEGORY ' + char(10)
			SELECT @v_dSql0 += '				 , A.PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '				 , MAX(A.VALUE) AS VALUE ' + char(10)
			SELECT @v_dSql0 += '				 , A.APPLY_DATE ' + char(10)
			SELECT @v_dSql0 += '			FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT DISTINCT A.ATTRIBUTE1 AS E_CATEGORY ' + char(10)
			SELECT @v_dSql0 += '				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '				WHERE  A.LOOKUP_TYPE_CODE = ''ITEM_CONV_CALC'' ' + char(10)
			SELECT @v_dSql0 += '				AND    A.ATTRIBUTE2 = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '			) D ' + char(10)
			SELECT @v_dSql0 += '			ON     A.CATEGORY = D.E_CATEGORY ' + char(10)
			SELECT @v_dSql0 += '			INNER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '				SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '				FROM ( ' + char(10)
			SELECT @v_dSql0 += '					SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '					FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '					WHERE  A.MAX_VER_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '					AND    A.VALUE > 0 ' + char(10)
			SELECT @v_dSql0 += '					AND    A.CATEGORY IN (  ''Jumbo Roll (cell/m)'' ' + char(10)
			SELECT @v_dSql0 += '										  , ''Lane Number'' ' + char(10)
			SELECT @v_dSql0 += '										  , ''Pancake (m/batch)'' ' + char(10)
			SELECT @v_dSql0 += '										  , ''cell/batch'' ' + char(10)
			SELECT @v_dSql0 += '										  , ''Jumbo Roll (m/batch)'' ' + char(10)
			SELECT @v_dSql0 += '										  , ''Pancake (cell/m)'' ) ' + char(10)
			SELECT @v_dSql0 += '					GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '					HAVING COUNT(1) = 6 ' + char(10)
			SELECT @v_dSql0 += '				) A ' + char(10)
			SELECT @v_dSql0 += '				GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION, ITEM_ID, PROD_VERSION_TYPE, A.VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '			) E ' + char(10)
			SELECT @v_dSql0 += '			ON     A.COMPANY_ID         = E.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '			AND    A.DIVISION_ID        = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '			AND    A.SITE_ID            = E.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '			AND    A.PLANT_ID           = E.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '			AND    A.FACTORY_ID         = E.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '			AND    A.OPERATION          = E.OPERATION ' + char(10)
			SELECT @v_dSql0 += '			AND    A.ITEM_ID            = E.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '			AND    A.PROD_VERSION_TYPE  = E.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '			AND    A.VERSION_TYPE       = E.VERSION_TYPE ' + char(10)
			SELECT @v_dSql0 += '			WHERE  A.MAX_VER_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql0 += '			AND    A.CATEGORY = ''Pancake (cell/m)'' ' + char(10)
			SELECT @v_dSql0 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '				   , A.OPERATION, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '				   , A.CATEGORY, A.PROD_VERSION_TYPE, A.VERSION_TYPE, A.APPLY_DATE ' + char(10)
			SELECT @v_dSql0 += '	) A ' + char(10)
			SELECT @v_dSql0 += '	WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND   A.OPERATION  = ''E2000'' ' + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += ') A ' + char(10)
			SELECT @v_dSql0 += 'WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += 'AND   A.ROW_NUM = 1 ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)

			SELECT @v_dSql0 += 'SELECT * ' + char(10)
			SELECT @v_dSql0 += 'INTO #LINE_ASSIGN ' + char(10)
			SELECT @v_dSql0 += 'FROM ( ' + char(10)
			SELECT @v_dSql0 += '		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, ISNULL(C.ROLE_TYPE,''-'') AS ROLE_TYPE ' + char(10)
			SELECT @v_dSql0 += '			 , A.ITEM_ID, ISNULL(D.NICK_NAME,''-'') AS NICK_NAME, A.LINE_ID, E.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql0 += '			 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += '		FROM ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '				 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '				 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10) 
			SELECT @v_dSql0 += '			FROM   ' + @p_amend_table + ' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '			AND    A.JR_OUT_QTY > 0 ' + char(10)
			SELECT @v_dSql0 += '			AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql0 += '			AND    A.SHIFT IN (''1'',''2'') ' + char(10)
			SELECT @v_dSql0 += '			AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql0 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '				   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '				   , A.PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += ' 		    UNION ' + char(10)
			SELECT @v_dSql0 += ' 		    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += ' 		         , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += ' 		         , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += ' 		    FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ' 		    WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '			ANd    A.JR_OUT_QTY > 0 ' + char(10)
			SELECT @v_dSql0 += ' 		    AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql0 += '			AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql0 += ' 		    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += ' 		           , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += ' 		           , A.PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += '		) A ' + char(10)
			SELECT @v_dSql0 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql0 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, MAX(ATTB_1) AS ROLE_TYPE ' + char(10)
			SELECT @v_dSql0 += '			FROM   ' + @p_amend_table + ' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql0 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID' + char(10)
			SELECT @v_dSql0 += '		) C ' + char(10)
			SELECT @v_dSql0 += '		ON    A.COMPANY_ID  = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.SITE_ID     = C.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.PLANT_ID    = C.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.FACTORY_ID  = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.ITEM_ID     = C.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		INNER JOIN SCM_ITEM_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '		ON    A.COMPANY_ID  = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.DIVISION_ID = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.SITE_ID     = D.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.ITEM_ID     = D.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		INNER JOIN SCM_LINE_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '		ON    A.COMPANY_ID     = E.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.DIVISION_ID    = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.SITE_ID        = E.SITE_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.PLANT_ID       = E.PLANT_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.FACTORY_ID     = E.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.OPERATION_ID   = E.OPERATION_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.LINE_ID        = E.LINE_ID ' + char(10)
			SELECT @v_dSql0 += '		AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql0 += '		WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += '		'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @v_production_type))  + char(10)

			IF (LEN(@p_item_id) > 0)
			BEGIN
                SELECT @v_dSql0 += '		AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
			END

			IF (LEN(@p_nick_name) > 0)
			BEGIN
                SELECT @v_dSql0 += '		AND    D.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			END

			SELECT @v_dSql0 += ') A ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10) + char(10)


			SELECT @v_dSql0 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	 , A.PLAN_DATE, B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
			SELECT @v_dSql0 += '	 , A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += '	 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql0 += 'INTO #PLAN_SUMQTY ' + char(10)
			SELECT @v_dSql0 += 'FROM ( ' + char(10)
			SELECT @v_dSql0 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '		 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '		 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += '		 , A.JR_OUT_QTY, 0 AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql0 += '	FROM   ' + @p_amend_table + ' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.JR_OUT_QTY > 0 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql0 += '	AND    A.SHIFT IN (''1'',''2'') ' + char(10)
			SELECT @v_dSql0 += '	AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql0 += '	UNION ALL ' + char(10)
			SELECT @v_dSql0 += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += ' 		 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += ' 		 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += ' 		 , 0 AS JR_OUT_QTY, A.JR_OUT_QTY AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql0 += ' 	FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += ' 	WHERE  1=1 ' + char(10)
			SELECT @v_dSql0 += '	AND    A.JR_OUT_QTY > 0 ' + char(10)
			SELECT @v_dSql0 += ' 	AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql0 += '	AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql0 += '	'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql0 += ') A ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON  A.PLAN_DATE = B.YYYYMMDD ' + char(10)
			SELECT @v_dSql0 += 'AND B.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql0 += 'INNER JOIN SCM_ITEM_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql0 += 'ON    A.COMPANY_ID  = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql0 += 'AND   A.DIVISION_ID = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql0 += 'AND   A.SITE_ID     = D.SITE_ID ' + char(10)
			SELECT @v_dSql0 += 'AND   A.ITEM_ID     = D.ITEM_ID ' + char(10)

			SELECT @v_dSql0 += 'WHERE 1=1 ' + char(10)
			SELECT @v_dSql0 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @v_production_type))  + char(10)

			IF (LEN(@p_item_id) > 0)
			BEGIN
                SELECT @v_dSql0 += 'AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
			END

			IF (LEN(@p_nick_name) > 0)
			BEGIN
                SELECT @v_dSql0 += 'AND    D.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
			END

			SELECT @v_dSql0 += 'GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql0 += '	   , A.PLAN_DATE, B.ISO_YYYYWW, B.YYYYMM ' + char(10)
			SELECT @v_dSql0 += '	   , A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql0 += '; ' + char(10)


			-- 환산자 로직 끝!!!
			
			SELECT @v_dSql1 = ''
			SELECT @v_dSql1 = '------------------------------------v_dSql1-----------------------------' + char(10)
			SELECT @v_dSql1 += 'WITH MAIN_P AS ( -- P_OUT, LOAD ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql1 += '		 , ''DATA'' AS DATA_TYPE ' + char(10)

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

						SELECT @v_tmp1 += '		 , SUM(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''P_OUT_ROLL'' THEN B.ROLL_OUT_QTY ' + char(10)
						SELECT @v_tmp1 += '		            WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''P_OUT''      THEN B.' + @v_uom_col_out + ' ' + char(10)
						SELECT @v_tmp1 += '		 			WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''RESULT_OUT'' THEN B.' + @v_uom_col_result_out + ' ELSE 0 END ) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp1 += '		 , SUM(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''P_OUT_ROLL'' THEN B.ROLL_OUT_QTY ' + char(10)
						SELECT @v_tmp1 += '		            WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''P_OUT''      THEN B.' + @v_uom_col_out + ' ' + char(10)
						SELECT @v_tmp1 += '		 			WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''RESULT_OUT'' THEN B.' + @v_uom_col_result_out + ' ELSE 0 END ) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp2 += '		 , SUM(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''P_OUT_ROLL'' THEN B.ROLL_OUT_QTY ' + char(10)
						SELECT @v_tmp2 += '		            WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''P_OUT''      THEN B.' + @v_uom_col_out + ' ' + char(10)
						SELECT @v_tmp2 += '		 			WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''RESULT_OUT'' THEN B.' + @v_uom_col_result_out + ' ELSE 0 END ) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp2 += '		 , SUM(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''P_OUT_ROLL'' THEN B.ROLL_OUT_QTY ' + char(10)
						SELECT @v_tmp2 += '		            WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''P_OUT''      THEN B.' + @v_uom_col_out + ' ' + char(10)
						SELECT @v_tmp2 += '		 			WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''RESULT_OUT'' THEN B.' + @v_uom_col_result_out + ' ELSE 0 END ) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp3 += '		 		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''P_OUT_ROLL'' THEN B.ROLL_OUT_QTY ' + char(10)
						SELECT @v_tmp3 += '		 		            WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''P_OUT''      THEN B.' + @v_uom_col_out + ' ' + char(10)
						SELECT @v_tmp3 += '		 					WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND B.SHIFT = ''1'' AND C.CATEGORY_ID = ''RESULT_OUT'' THEN B.' + @v_uom_col_result_out + ' ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp3 += '		 		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''P_OUT_ROLL'' THEN B.ROLL_OUT_QTY ' + char(10)
						SELECT @v_tmp3 += '		 		            WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''P_OUT''      THEN B.' + @v_uom_col_out + ' ' + char(10)
						SELECT @v_tmp3 += '		 					WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND B.SHIFT = ''2'' AND C.CATEGORY_ID = ''RESULT_OUT'' THEN B.' + @v_uom_col_result_out + ' ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

			        END 
			END

            SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM #LINE_ASSIGN A WITH(NOLOCK) ' + char(10)

			/*
			if (@v_plannedline = 'Y') begin
				SELECT @v_dSql1 += '	INNER JOIN ( ' + char(10)
			end
			else begin
				SELECT @v_dSql1 += '	LEFT OUTER JOIN ( ' + char(10)
			end
			*/
			SELECT @v_dSql1 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
			SELECT @v_dSql1 += '		FROM ( -- plan out ' + char(10)
			SELECT @v_dSql1 += ' 		    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    	 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    	 , A.PLAN_DATE, A.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		    	 , A.JR_OUT_QTY, A.PC_OUT_QTY, A.ROLL_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		    	 , ROUND(A.PC_OUT_QTY * ISNULL(B.VALUE, ISNULL(C.VALUE, 1)), 0) AS CELL_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		    	 , A.JR_RESULT_OUT_QTY, A.PC_RESULT_OUT_QTY, A.CELL_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		    FROM ( ' + char(10)
			SELECT @v_dSql1 += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '						 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '						 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '						 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.PC_OUT_QTY) AS PC_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '						 , CEILING( SUM(A.JR_OUT_QTY) / ISNULL(MAX(B.JR_M_ROLL),1) ) AS ROLL_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '						 , 0 AS JR_RESULT_OUT_QTY, 0 AS PC_RESULT_OUT_QTY, 0 AS CELL_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '						 , MAX(VERSION_TYPE_1) AS VERSION_TYPE_1, MAX(VERSION_TYPE_2) AS VERSION_TYPE_2 ' + char(10)
			SELECT @v_dSql1 += '					FROM   ' + @p_amend_table + ' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '					LEFT OUTER JOIN #W_EXCHANGE B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '					ON     A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '					AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '					AND    A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '					AND    A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '					AND    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '					AND    A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '						SELECT A.SEGMENT3 AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '							 , A.ATTRIBUTE1 AS VERSION_TYPE_1 ' + char(10)
			SELECT @v_dSql1 += '							 , A.ATTRIBUTE2 AS VERSION_TYPE_2 ' + char(10)
			SELECT @v_dSql1 += '							 , A.ATTRIBUTE3 AS VERSION_TYPE_3 ' + char(10)
			SELECT @v_dSql1 += '							 , A.ATTRIBUTE4 AS VERSION_TYPE_4 ' + char(10)
			SELECT @v_dSql1 += '							 , A.ATTRIBUTE5 AS VERSION_TYPE_5 ' + char(10)
			SELECT @v_dSql1 += '						FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '						WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_CONV_PRIORITY'' ' + char(10)
			SELECT @v_dSql1 += '						AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql1 += '						AND    A.SEGMENT1    = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql1 += '						AND    A.SEGMENT3   <> ''DEFAULT'' ' + char(10)
			SELECT @v_dSql1 += '					) C ' + char(10)
			SELECT @v_dSql1 += '					ON A.FP_PRODUCTION_TYPE = C.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '					WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '					AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql1 += '					AND    A.SHIFT IN (''1'',''2'') ' + char(10)
			SELECT @v_dSql1 += '					AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql1 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql1 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += '		 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += '		 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += '		 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_item_id) > 0)
			BEGIN
                SELECT @v_dSql1 += '		 		    AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
			END

			SELECT @v_dSql1 += '					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '						   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID' + char(10)
			SELECT @v_dSql1 += '						   , A.PLAN_DATE, A.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		    ) A ' + char(10)
			SELECT @v_dSql1 += ' 		    LEFT OUTER JOIN #CALC B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		    ON  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.VERSION_TYPE_1 = B.VERSION_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		    LEFT OUTER JOIN #CALC C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		    ON  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		    AND A.VERSION_TYPE_2 = B.VERSION_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		    UNION ALL -- result ' + char(10)
			SELECT @v_dSql1 += ' 		    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		         , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		         , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, B.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += ' 		         , 0 AS JR_OUT_QTY, 0 AS PC_OUT_QTY, 0 AS ROLL_OUT_QTY, 0 AS CELL_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		         , SUM(A.JR_OUT_QTY) AS JR_RESULT_OUT_QTY, SUM(A.ROLL_OUT_QTY) AS PC_RESULT_OUT_QTY, SUM(A.CELL_OUT_QTY) AS CELL_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += ' 		    FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += ' 		    , ( ' + char(10)
			SELECT @v_dSql1 += ' 		    	SELECT ''1'' AS SHIFT ' + char(10)
			SELECT @v_dSql1 += ' 		    	UNION ALL ' + char(10)
			SELECT @v_dSql1 += ' 		    	SELECT ''2'' AS SHIFT ' + char(10)
			SELECT @v_dSql1 += ' 		    ) B ' + char(10)
			SELECT @v_dSql1 += ' 		    WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += ' 		    AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql1 += '			AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql1 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql1 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql1 += ' 		    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += ' 		           , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += ' 		           , A.PLAN_DATE, B.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '		) A ' + char(10)
			SELECT @v_dSql1 += '		INNER JOIN TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		ON  A.PLAN_DATE = B.YYYYMMDD ' + char(10)
			SELECT @v_dSql1 += '		AND B.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON    A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.LINE_ID        = B.LINE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '	AND   A.ITEM_ID        = B.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT ''P_OUT_ROLL'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 90 AS CATEGORY_ORDER, ''Roll'' AS UOM ' + char(10)
			SELECT @v_dSql1 += '		UNION ALL ' + char(10)
			SELECT @v_dSql1 += '		SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 100 AS CATEGORY_ORDER, ''' + @v_uom_text + ''' AS UOM ' + char(10)
			SELECT @v_dSql1 += '		UNION ALL ' + char(10)
			SELECT @v_dSql1 += '		SELECT ''RESULT_OUT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 200 AS CATEGORY_ORDER, ''' + @v_uom_text + ''' AS UOM ' + char(10)
			SELECT @v_dSql1 += '	) C ' + char(10)
			SELECT @v_dSql1 += '	ON 1=1 ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE ' + char(10)
			SELECT @v_dSql1 += '		   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '		   , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql1 += ') ' + char(10)

			SELECT @v_dSql2 = ''
			SELECT @v_dSql2 += '------------------ v_dsql2 --------------------- ' + char(10)
			SELECT @v_dSql2 += ', MAIN_P_SUBTOTAL AS ( ' + char(10)
			SELECT @v_dSql2 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += '		 , ''TOTAL'' AS DATA_TYPE ' + char(10)

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

						SELECT @v_tmp1 += '		 , SUM( CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT_ROLL'' THEN B.ROLL_TOTAL_QTY ' + char(10)
						SELECT @v_tmp1 += '		             WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT''      THEN B.' + @v_uom_total_col_out + ' ' + char(10)
						SELECT @v_tmp1 += '		             WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_RESULT_OUT'' THEN B.' + @v_uom_total_col_result_out + ' ELSE 0 END ) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp1 += '		 , SUM( CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT_ROLL'' THEN B.ROLL_TOTAL_QTY ' + char(10)
						SELECT @v_tmp1 += '		             WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT''      THEN B.' + @v_uom_total_col_out + ' ' + char(10)
						SELECT @v_tmp1 += '		             WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_RESULT_OUT'' THEN B.' + @v_uom_total_col_result_out + ' ELSE 0 END ) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp2 += '		 , SUM( CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT_ROLL'' THEN B.ROLL_TOTAL_QTY ' + char(10)
						SELECT @v_tmp2 += '		             WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT''      THEN B.' + @v_uom_total_col_out + ' ' + char(10)
						SELECT @v_tmp2 += '		             WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_RESULT_OUT'' THEN B.' + @v_uom_total_col_result_out + ' ELSE 0 END ) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp2 += '		 , SUM( CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT_ROLL'' THEN B.ROLL_TOTAL_QTY ' + char(10)
						SELECT @v_tmp2 += '		             WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT''      THEN B.' + @v_uom_total_col_out + ' ' + char(10)
						SELECT @v_tmp2 += '		             WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_RESULT_OUT'' THEN B.' + @v_uom_total_col_result_out + ' ELSE 0 END ) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)
						
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

						SELECT @v_tmp3 += '		 		 , SUM( CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT_ROLL'' THEN B.ROLL_TOTAL_QTY ' + char(10)
						SELECT @v_tmp3 += '		 		             WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT''      THEN B.' + @v_uom_total_col_out + ' ' + char(10)
						SELECT @v_tmp3 += '		 		             WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_RESULT_OUT'' THEN B.' + @v_uom_total_col_result_out + ' ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp3 += '		 		 , SUM( CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT_ROLL'' THEN B.ROLL_TOTAL_QTY ' + char(10)
						SELECT @v_tmp3 += '		 		             WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_P_OUT''      THEN B.' + @v_uom_total_col_out+ ' ' + char(10)
						SELECT @v_tmp3 += '		 		             WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_RESULT_OUT'' THEN B.' + @v_uom_total_col_result_out + ' ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)
						
			        END 

			END

            SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql2 += '	FROM ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '			FROM #LINE_ASSIGN A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '	) A ' + char(10)
			
			/*
			if (@v_plannedline = 'Y') begin
				SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			end
			else begin
				SELECT @v_dSql2 += '	LEFT OUTER JOIN ( ' + char(10)
			end
			*/

			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE, A.OPERATION_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				 , B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_OUT_QTY) AS JR_TOTAL_QTY ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.PC_OUT_QTY) AS PC_TOTAL_QTY ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.ROLL_OUT_QTY) AS ROLL_TOTAL_QTY ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.CELL_OUT_QTY) AS CELL_TOTAL_QTY ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_RESULT_OUT_QTY) AS JR_TOTAL_RESULT_QTY ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.PC_RESULT_OUT_QTY) AS PC_TOTAL_RESULT_QTY ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.CELL_RESULT_OUT_QTY) AS CELL_TOTAL_RESULT_QTY ' + char(10)
			SELECT @v_dSql2 += '			FROM (  -- PLAN OUT ' + char(10)
			SELECT @v_dSql2 += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '							, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '							, A.PLAN_DATE, A.SHIFT, A.FP_PRODUCTION_TYPE' + char(10)
			SELECT @v_dSql2 += '							, A.JR_OUT_QTY, A.PC_OUT_QTY, A.ROLL_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '							, ROUND(A.PC_OUT_QTY * ISNULL(B.VALUE, ISNULL(C.VALUE, 1)), 0) AS CELL_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '							, A.JR_RESULT_OUT_QTY, A.PC_RESULT_OUT_QTY, A.CELL_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '					FROM ( ' + char(10)
			SELECT @v_dSql2 += '							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '									, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '									, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '									, SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.PC_OUT_QTY) AS PC_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '									, CEILING( SUM(A.JR_OUT_QTY) / ISNULL(MAX(B.JR_M_ROLL),1) ) AS ROLL_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '									, 0 AS JR_RESULT_OUT_QTY, 0 AS PC_RESULT_OUT_QTY, 0 AS CELL_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '									, MAX(VERSION_TYPE_1) AS VERSION_TYPE_1, MAX(VERSION_TYPE_2) AS VERSION_TYPE_2 ' + char(10)
			SELECT @v_dSql2 += '							FROM   ' + @p_amend_table + ' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '							LEFT OUTER JOIN #W_EXCHANGE B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '							ON     A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '							AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '							AND    A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '							AND    A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '							AND    A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '							AND    A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '							LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '								SELECT A.SEGMENT3 AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '										, A.ATTRIBUTE1 AS VERSION_TYPE_1 ' + char(10)
			SELECT @v_dSql2 += '										, A.ATTRIBUTE2 AS VERSION_TYPE_2 ' + char(10)
			SELECT @v_dSql2 += '										, A.ATTRIBUTE3 AS VERSION_TYPE_3 ' + char(10)
			SELECT @v_dSql2 += '										, A.ATTRIBUTE4 AS VERSION_TYPE_4 ' + char(10)
			SELECT @v_dSql2 += '										, A.ATTRIBUTE5 AS VERSION_TYPE_5 ' + char(10)
			SELECT @v_dSql2 += '								FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '								WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_CONV_PRIORITY'' ' + char(10)
			SELECT @v_dSql2 += '								AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql2 += '								AND    A.SEGMENT1    = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql2 += '								AND    A.SEGMENT3   <> ''DEFAULT'' ' + char(10)
			SELECT @v_dSql2 += '							) C ' + char(10)
			SELECT @v_dSql2 += '							ON A.FP_PRODUCTION_TYPE = C.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '							WHERE  1=1 ' + char(10)
			SELECT @v_dSql2 += '							AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql2 += '							AND    A.SHIFT IN (''1'',''2'') ' + char(10)
			SELECT @v_dSql2 += '							AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql2 += '							'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql2 += '							'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql2 += '							'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += '							'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql2 += '							'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql2 += '							'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_item_id) > 0)
			BEGIN
                SELECT @v_dSql2 += '							AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
			END

			SELECT @v_dSql2 += '							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '									, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '									, A.PLAN_DATE, A.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '					) A ' + char(10)
			SELECT @v_dSql2 += '					LEFT OUTER JOIN #CALC B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '					ON  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.VERSION_TYPE_1 = B.VERSION_TYPE ' + char(10)
			SELECT @v_dSql2 += '					LEFT OUTER JOIN #CALC C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '					ON  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.SITE_ID     = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.PLANT_ID    = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.ITEM_ID     = B.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '					AND A.VERSION_TYPE_2 = B.VERSION_TYPE ' + char(10)
			SELECT @v_dSql2 += '					UNION ALL -- result  ' + char(10)
			SELECT @v_dSql2 += '			 		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '			 				, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '			 				, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, B.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '			 				, 0 AS JR_OUT_QTY, 0 AS PC_OUT_QTY, 0 AS ROLL_OUT_QTY, 0 AS CELL_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 				, SUM(A.JR_OUT_QTY) AS JR_RESULT_OUT_QTY, SUM(A.ROLL_OUT_QTY) AS PC_RESULT_OUT_QTY, SUM(A.CELL_OUT_QTY) AS CELL_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 		FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			 		, ( ' + char(10)
			SELECT @v_dSql2 += '			 		    SELECT ''1'' AS SHIFT ' + char(10)
			SELECT @v_dSql2 += '			 		) B ' + char(10)
			SELECT @v_dSql2 += '			 		WHERE  1=1 ' + char(10)
			SELECT @v_dSql2 += '			 		AND    A.MARKET = ''D'' ' + char(10)
			SELECT @v_dSql2 += '					AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql2 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql2 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql2 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql2 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql2 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql2 += '					'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_item_id) > 0)
			BEGIN
                SELECT @v_dSql2 += '				AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
			END

			SELECT @v_dSql2 += '			 		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '			 				, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '			 				, A.PLAN_DATE, B.SHIFT, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '			) A ' + char(10)
			SELECT @v_dSql2 += '			INNER JOIN TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			ON  A.PLAN_DATE = B.YYYYMMDD ' + char(10)
			SELECT @v_dSql2 += '			AND B.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PLAN_DATE, A.OPERATION_ID, B.ISO_YYYYWW, B.YYYYMM, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '	) B ' + char(10)
			SELECT @v_dSql2 += '	ON    A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.ITEM_ID        = B.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT ''TOTAL_P_OUT_ROLL'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 5 AS CATEGORY_ORDER, ''Roll'' AS UOM ' + char(10)
			SELECT @v_dSql2 += '		UNION ALL ' + char(10)
			SELECT @v_dSql2 += '		SELECT ''TOTAL_P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER, ''' + @v_uom_text + ''' AS UOM ' + char(10)
			SELECT @v_dSql2 += '		UNION ALL ' + char(10)
			SELECT @v_dSql2 += '		SELECT ''TOTAL_RESULT_OUT'' AS CATEGORY_ID, ''Result'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER, ''' + @v_uom_text + ''' AS UOM ' + char(10)
			SELECT @v_dSql2 += '	) C ' + char(10)
			SELECT @v_dSql2 += '	ON 1=1 ' + char(10)
			SELECT @v_dSql2 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		   , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += ') ' + char(10)


			SELECT @v_dSql2 += ', MAIN_P_ACHIEVE AS ( ' + char(10)
			SELECT @v_dSql2 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += '		 , ''DATA'' AS DATA_TYPE ' + char(10)

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

						SELECT @v_tmp1 += '		 , ROUND(MAX(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''ACHIEVE'' THEN B.MONTHSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp1 += '		 , ROUND(MAX(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''ACHIEVE'' THEN B.MONTHSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp2 += '		 , ROUND(MAX(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''ACHIEVE'' THEN B.WEEKSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp2 += '		 , ROUND(MAX(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''ACHIEVE'' THEN B.WEEKSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp3 += '		 		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''ACHIEVE'' THEN B.ACHIEVE_RATE ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp3 += '		 		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''ACHIEVE'' THEN B.ACHIEVE_RATE ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

			        END 

			END

            SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql2 += '	FROM #LINE_ASSIGN A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '             , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '             , A.PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '             , A.PLAN_WEEK, A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '             , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(SUM(A.JR_OUT_QTY),0) = 0 THEN 0 ELSE (ISNULL(SUM(A.JR_RESULT_OUT_QTY),0) / ISNULL(SUM(A.JR_OUT_QTY),0) * 100) END, 0) AS ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '			 , C.JR_OUT_QTY AS WEEKSUM_JR_OUT_QTY, C.JR_RESULT_OUT_QTY AS WEEKSUM_JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(C.JR_OUT_QTY,0) = 0 THEN 0 ELSE (ISNULL(C.JR_RESULT_OUT_QTY,0) / ISNULL(C.JR_OUT_QTY,0) * 100) END, 0) AS WEEKSUM_ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '			 , D.JR_OUT_QTY AS MONTHSUM_JR_OUT_QTY, D.JR_RESULT_OUT_QTY AS MONTHSUM_JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(D.JR_OUT_QTY,0) = 0 THEN 0 ELSE (ISNULL(D.JR_RESULT_OUT_QTY,0) / ISNULL(D.JR_OUT_QTY,0) * 100) END, 0) AS MONTHSUM_ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '		FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				 , A.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				   , A.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '		) C ' + char(10)
			SELECT @v_dSql2 += '		ON  A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.SITE_ID        = C.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLANT_ID       = C.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.LINE_ID        = C.LINE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		AND A.ITEM_ID        = C.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLAN_WEEK     = C.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				 , A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				   , A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '		) D ' + char(10)
			SELECT @v_dSql2 += '		ON  A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.SITE_ID        = D.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLANT_ID       = D.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FACTORY_ID     = D.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.LINE_ID        = D.LINE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.ELECTRODE_TYPE = D.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		AND A.ITEM_ID        = D.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLAN_MONTH     = D.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '               , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '               , A.PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '               , A.PLAN_WEEK, A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '			   , C.JR_OUT_QTY, C.JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			   , D.JR_OUT_QTY, D.JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '	) B ' + char(10)
			SELECT @v_dSql2 += '	ON    A.COMPANY_ID      = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.DIVISION_ID     = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.SITE_ID         = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.PLANT_ID        = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.FACTORY_ID      = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.OPERATION_ID    = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.LINE_ID         = B.LINE_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += '	AND   A.ITEM_ID         = B.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT ''ACHIEVE'' AS CATEGORY_ID, ''Plan achve.'' AS CATEGORY_NAME, 300 AS CATEGORY_ORDER, ''%'' AS UOM ' + char(10)
			SELECT @v_dSql2 += '	) C ' + char(10)
			SELECT @v_dSql2 += '	ON 1=1 ' + char(10)
			SELECT @v_dSql2 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		   , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += ') ' + char(10)
			

			SELECT @v_dSql2 += ', MAIN_P_ACHIEVE_SUBTOTAL AS ( ' + char(10)
			SELECT @v_dSql2 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += '		 , ''TOTAL'' AS DATA_TYPE ' + char(10)

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

						SELECT @v_tmp1 += '		 , ROUND(MAX(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.MONTHSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp1 += '		 , ROUND(MAX(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.MONTHSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp2 += '		 , ROUND(MAX(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.WEEKSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp2 += '		 , ROUND(MAX(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.WEEKSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)
		 
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

						SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.ACHIEVE_RATE ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.ACHIEVE_RATE ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)
			        END 

			END

			SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql2 += '	FROM ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		FROM #LINE_ASSIGN A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '	) A ' + char(10)
			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '			 , A.OPERATION_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '			 , A.PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '			 , A.PLAN_WEEK, A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '			 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(SUM(A.JR_OUT_QTY),0) = 0 THEN 0 ELSE (ISNULL(SUM(A.JR_RESULT_OUT_QTY),0) / ISNULL(SUM(A.JR_OUT_QTY),0) * 100) END, 0) AS ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '			 , C.JR_OUT_QTY AS WEEKSUM_JR_OUT_QTY, C.JR_RESULT_OUT_QTY AS WEEKSUM_JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(C.JR_OUT_QTY,0) = 0 THEN 0 ELSE (ISNULL(C.JR_RESULT_OUT_QTY,0) / ISNULL(C.JR_OUT_QTY,0) * 100) END, 0) AS WEEKSUM_ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '			 , D.JR_OUT_QTY AS MONTHSUM_JR_OUT_QTY, D.JR_RESULT_OUT_QTY AS MONTHSUM_JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(D.JR_OUT_QTY,0) = 0 THEN 0 ELSE (ISNULL(D.JR_RESULT_OUT_QTY,0) / ISNULL(D.JR_OUT_QTY,0) * 100) END, 0) AS MONTHSUM_ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '		FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.OPERATION_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				 , A.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.OPERATION_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				   , A.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '		) C ' + char(10)
			SELECT @v_dSql2 += '		ON  A.COMPANY_ID         = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.DIVISION_ID        = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.SITE_ID            = C.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLANT_ID           = C.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FACTORY_ID         = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.OPERATION_ID       = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.ITEM_ID            = C.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FP_PRODUCTION_TYPE = C.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLAN_WEEK          = C.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.OPERATION_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				 , A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.OPERATION_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '				   , A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '		) D ' + char(10)
			SELECT @v_dSql2 += '		ON  A.COMPANY_ID         = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.DIVISION_ID        = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.SITE_ID            = D.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLANT_ID           = D.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FACTORY_ID         = D.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.OPERATION_ID       = D.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.ITEM_ID            = D.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FP_PRODUCTION_TYPE = D.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLAN_MONTH         = D.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '			   , A.OPERATION_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '			   , A.PLAN_DATE, A.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '			   , A.PLAN_WEEK, A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '			   , C.JR_OUT_QTY, C.JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			   , D.JR_OUT_QTY, D.JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '	) B ' + char(10)
			SELECT @v_dSql2 += '	ON    A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.ITEM_ID        = B.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT ''TOTAL_ACHIEVE'' AS CATEGORY_ID, ''Plan achve.'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER, ''%'' AS UOM ' + char(10)
			SELECT @v_dSql2 += '	) C ' + char(10)
			SELECT @v_dSql2 += '	ON 1=1 ' + char(10)
			SELECT @v_dSql2 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ROLE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		   , A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		   , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += ') ' + char(10)


			SELECT @v_dSql2 += ', MAIN_P_ACHIEVE_TOTAL AS ( ' + char(10)
			SELECT @v_dSql2 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, NULL AS ROLE_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '		 , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += '		 , ''TOTAL_2'' AS DATA_TYPE ' + char(10)

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

						SELECT @v_tmp1 += '		 , ROUND(MAX(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.MONTHSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp1 += '		 , ROUND(MAX(CASE WHEN B.PLAN_MONTH = ''' + @v_month_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.MONTHSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp2 += '		 , ROUND(MAX(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.WEEKSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp2 += '		 , ROUND(MAX(CASE WHEN B.PLAN_WEEK = ''' + @v_week_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.WEEKSUM_ACHIEVE_RATE ELSE 0 END ), 0) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.ACHIEVE_RATE ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp3 += '		 , SUM(CASE WHEN B.PLAN_DATE = ''' + @v_day_info + ''' AND C.CATEGORY_ID = ''TOTAL_ACHIEVE'' THEN B.ACHIEVE_RATE ELSE 0 END ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

			        END 

			END

			SELECT @v_dSql2 = @v_dSql2 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql2 += '	FROM ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		FROM #LINE_ASSIGN A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '	) A ' + char(10)
			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '			 , A.OPERATION_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql2 += '			 , A.PLAN_WEEK, A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '			 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(SUM(A.JR_OUT_QTY),0) = 0 THEN 0 ELSE (ISNULL(SUM(A.JR_RESULT_OUT_QTY),0) / ISNULL(SUM(A.JR_OUT_QTY),0) * 100) END, 0) AS ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '			 , C.JR_OUT_QTY AS WEEKSUM_JR_OUT_QTY, C.JR_RESULT_OUT_QTY AS WEEKSUM_JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(C.JR_OUT_QTY,0) = 0 THEN 0 ELSE (ISNULL(C.JR_RESULT_OUT_QTY,0) / ISNULL(C.JR_OUT_QTY,0) * 100) END, 0) AS WEEKSUM_ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '			 , D.JR_OUT_QTY AS MONTHSUM_JR_OUT_QTY, D.JR_RESULT_OUT_QTY AS MONTHSUM_JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			 , ROUND(CASE WHEN ISNULL(D.JR_OUT_QTY,0) = 0 THEN 0 ELSE (ISNULL(D.JR_RESULT_OUT_QTY,0) / ISNULL(D.JR_OUT_QTY,0) * 100) END, 0) AS MONTHSUM_ACHIEVE_RATE ' + char(10)
			SELECT @v_dSql2 += '		FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '		) C ' + char(10)
			SELECT @v_dSql2 += '		ON  A.COMPANY_ID   = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.SITE_ID      = C.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLANT_ID     = C.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FACTORY_ID   = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.OPERATION_ID = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLAN_WEEK    = C.PLAN_WEEK ' + char(10)
			SELECT @v_dSql2 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '				 , A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '				 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.JR_RESULT_OUT_QTY) AS JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			FROM #PLAN_SUMQTY A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '				   , A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '		) D ' + char(10)
			SELECT @v_dSql2 += '		ON  A.COMPANY_ID   = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.DIVISION_ID  = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.SITE_ID      = D.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLANT_ID     = D.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.FACTORY_ID   = D.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.OPERATION_ID = D.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		AND A.PLAN_MONTH   = D.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '			   , A.OPERATION_ID, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql2 += '			   , A.PLAN_WEEK, A.PLAN_MONTH ' + char(10)
			SELECT @v_dSql2 += '			   , C.JR_OUT_QTY, C.JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '			   , D.JR_OUT_QTY, D.JR_RESULT_OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '	) B ' + char(10)
			SELECT @v_dSql2 += '	ON    A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.SITE_ID        = B.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.PLANT_ID       = B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '	AND   A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql2 += '		SELECT ''TOTAL_ACHIEVE'' AS CATEGORY_ID, ''Plan achve.'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER, ''%'' AS UOM ' + char(10)
			SELECT @v_dSql2 += '	) C ' + char(10)
			SELECT @v_dSql2 += '	ON 1=1 ' + char(10)
			SELECT @v_dSql2 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '		   , C.CATEGORY_ID, C.CATEGORY_NAME, C.CATEGORY_ORDER, C.UOM ' + char(10)
			SELECT @v_dSql2 += ') ' + char(10)


			SELECT @v_dSql3  = ''
		    SELECT @v_dSql3  = '------------------------------------v_dSql3-----------------------------' + char(10)
			SELECT @v_dSql3 += 'SELECT A.* ' + char(10)
			SELECT @v_dSql3 += '     , ''N'' AS EDIT_YN ' + char(10)
			SELECT @v_dSql3 += '     , REPLACE(D.LEVEL_3_NAME, '' PANCAKE'', '''') AS LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql3 += 'FROM ( ' + char(10)
			SELECT @v_dSql3 += '	SELECT * FROM MAIN_P ' + char(10)
			SELECT @v_dSql3 += '	UNION ALL ' + char(10)
			SELECT @v_dSql3 += '	SELECT * FROM MAIN_P_SUBTOTAL -- sub total ' + char(10)
			SELECT @v_dSql3 += '	UNION ALL ' + char(10)
			SELECT @v_dSql3 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, NULL AS ROLE_TYPE ' + char(10)
			SELECT @v_dSql3 += '		 , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.UOM ' + char(10)
			SELECT @v_dSql3 += '		 , ''TOTAL_2'' AS DATA_TYPE ' + char(10)

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

						SELECT @v_tmp1 += '		 , SUM( A.M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1' + char(10)
						SELECT @v_tmp1 += '		 , SUM( A.M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2' + char(10)

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

						SELECT @v_tmp2 += '		 , SUM( A.W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp2 += '		 , SUM( A.W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

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

						SELECT @v_tmp3 += '		 , SUM( A.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp3 += '		 , SUM( A.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

			        END 
			END

			SELECT @v_dSql3 = @v_dSql3 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql3 += '	FROM  MAIN_P_SUBTOTAL A ' + char(10)
			SELECT @v_dSql3 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql3 += '		 , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.UOM ' + char(10)
			-- 실적달성률 정보
			SELECT @v_dSql3 += '	UNION ALL ' + char(10)
			SELECT @v_dSql3 += '	SELECT * FROM MAIN_P_ACHIEVE ' + char(10)
			SELECT @v_dSql3 += '	UNION ALL ' + char(10)
			SELECT @v_dSql3 += '	SELECT * FROM MAIN_P_ACHIEVE_SUBTOTAL ' + char(10)
			SELECT @v_dSql3 += '	UNION ALL ' + char(10)
			SELECT @v_dSql3 += '	SELECT * FROM MAIN_P_ACHIEVE_TOTAL ' + char(10)
			SELECT @v_dSql3 += ') A ' + char(10)
			SELECT @v_dSql3 += 'LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += 'ON  A.COMPANY_ID  = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql3 += 'AND A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql3 += 'AND A.SITE_ID     = C.SITE_ID ' + char(10)
			SELECT @v_dSql3 += 'AND A.ITEM_ID     = C.ITEM_ID ' + char(10)
			SELECT @v_dSql3 += 'LEFT OUTER JOIN SCM_ITEM_CLASS_M D(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += 'ON  C.ITEM_CLASS = D.CLASS_ID ' + char(10)
			SELECT @v_dSql3 += 'ORDER BY (CASE WHEN DATA_TYPE = ''TOTAL_2'' THEN 1 ELSE 999 END) ' + char(10)
			SELECT @v_dSql3 += '       , A.FACTORY_ID, D.LEVEL_3_NAME, A.OPERATION_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql3 += '       , (CASE WHEN DATA_TYPE = ''TOTAL'' THEN 999 ELSE 1 END) ' + char(10)
			SELECT @v_dSql3 += '       , A.PRODUCTION_TYPE, A.LINE_ID, A.CATEGORY_ORDER ' + char(10)

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
				IF OBJECT_ID('tempdb..#W_EXCHANGE') IS NOT NULL
				DROP TABLE #W_EXCHANGE

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



