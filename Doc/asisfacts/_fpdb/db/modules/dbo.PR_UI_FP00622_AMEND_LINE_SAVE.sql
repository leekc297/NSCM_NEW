

/*
 * Program ID   : PR_UI_FP00622_AMEND_LINE_SAVE
 * Description  : Plan Amend Line NJ Pouch
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/05/11   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00622_AMEND_LINE_SAVE]
  @p_sys_type            NVARCHAR(MAX),
  @p_sys_flag            NVARCHAR(MAX),
  @p_sys_gubun           NVARCHAR(MAX),
  @p_user_id             NVARCHAR(MAX),
  @p_instance_id         NVARCHAR(MAX),
  @p_plan_date           NVARCHAR(MAX),
  @p_plan_id             NVARCHAR(MAX), 
  @p_company_id          NVARCHAR(MAX),
  @p_division_id         NVARCHAR(MAX),
  @p_site_id             NVARCHAR(MAX),
  @p_plant_id            NVARCHAR(MAX),
  @p_factory_id          NVARCHAR(MAX),
  @p_line_id             NVARCHAR(MAX),
  @p_operation_id        NVARCHAR(MAX),
  @p_item_id             NVARCHAR(MAX),
  @p_top_item_id         NVARCHAR(MAX),
  @p_item_type           NVARCHAR(MAX),
  @p_location            NVARCHAR(MAX),
  @p_prod_type           NVARCHAR(MAX),
  @p_market              NVARCHAR(MAX),
  @p_electrode_type      NVARCHAR(MAX),
  @p_category_id         NVARCHAR(MAX),
  @p_p_in_qty            NVARCHAR(MAX),
  @p_p_out_qty           NVARCHAR(MAX),
  @p_mpp_in_qty          NVARCHAR(MAX),
  @p_mpp_out_qty         NVARCHAR(MAX),
  @p_wpp_in_qty          NVARCHAR(MAX),
  @p_wpp_out_qty         NVARCHAR(MAX),
  @p_boh_qty             NVARCHAR(MAX),
  @p_plm_ec_no           NVARCHAR(MAX),
  @p_version             NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_instance_id          NVARCHAR(MAX)
    DECLARE @v_plan_date            NVARCHAR(MAX)
    DECLARE @v_plan_id              NVARCHAR(MAX)
    DECLARE @v_company_id           NVARCHAR(MAX)
    DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_plant_id             NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_line_id              NVARCHAR(MAX)
    DECLARE @v_operation_id         NVARCHAR(MAX)
    DECLARE @v_item_id              NVARCHAR(MAX)
    DECLARE @v_top_item_id          NVARCHAR(MAX)
	DECLARE @v_item_type            NVARCHAR(MAX)
    DECLARE @v_location             NVARCHAR(MAX)
    DECLARE @v_prod_type            NVARCHAR(MAX)
    DECLARE @v_market               NVARCHAR(MAX)
    DECLARE @v_electrode_type       NVARCHAR(MAX)
    DECLARE @v_category_id          NVARCHAR(MAX)
    DECLARE @v_p_in_qty             NVARCHAR(MAX)
    DECLARE @v_p_out_qty            NVARCHAR(MAX)
    DECLARE @v_mpp_in_qty           NVARCHAR(MAX)
    DECLARE @v_mpp_out_qty          NVARCHAR(MAX)
    DECLARE @v_wpp_in_qty           NVARCHAR(MAX)
    DECLARE @v_wpp_out_qty          NVARCHAR(MAX)
    DECLARE @v_boh_qty              NVARCHAR(MAX)
	DECLARE @v_plm_ec_no            NVARCHAR(MAX)
	DECLARE @v_version              NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00622_AMEND_LINE_SAVE'
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


	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_instance_id              = ''
    SET @v_plan_date                = ''
    SET @v_plan_id                  = ''  
    SET @v_company_id               = ''
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_line_id                  = ''
    SET @v_operation_id             = ''
    SET @v_item_id                  = ''
    SET @v_top_item_id              = '' 
	SET @v_item_type                = '' 
    SET @v_location                 = ''
    SET @v_prod_type                = ''
    SET @v_market                   = ''
    SET @v_electrode_type           = ''
    SET @v_category_id              = ''
    SET @v_p_in_qty                 = ''
    SET @v_p_out_qty                = ''
    SET @v_mpp_in_qty               = ''
    SET @v_mpp_out_qty              = ''
    SET @v_wpp_in_qty               = ''
    SET @v_wpp_out_qty              = ''
    SET @v_boh_qty                  = ''
	SET @v_plm_ec_no                = ''
	SET @v_version                  = ''

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

	/************************************************************************************************/
	/* SAVE인경우 :SAVE                                                                      */
	/************************************************************************************************/
	-- 트랜잭션 (TRAN)
	BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
	BEGIN TRAN   

	BEGIN --( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type    = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,      @v_delimiter, @mst_loop_cnt)
						, @v_sys_flag         = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,      @v_delimiter, @mst_loop_cnt)
						, @v_sys_gubun        = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,     @v_delimiter, @mst_loop_cnt)
						, @v_user_id          = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_instance_id      = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_plan_date        = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,     @v_delimiter, @mst_loop_cnt)
                        , @v_plan_id          = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_company_id       = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_division_id      = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_site_id          = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_plant_id         = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,      @v_delimiter, @mst_loop_cnt)
                        , @v_factory_id       = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,    @v_delimiter, @mst_loop_cnt)
                        , @v_line_id          = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_operation_id     = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,  @v_delimiter, @mst_loop_cnt)
                        , @v_item_id          = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,       @v_delimiter, @mst_loop_cnt)
                        , @v_top_item_id      = [dbo].[SCM_ARR_SPL_VAL](@p_top_item_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_item_type        = [dbo].[SCM_ARR_SPL_VAL](@p_item_type ,     @v_delimiter, @mst_loop_cnt)
                        , @v_location         = [dbo].[SCM_ARR_SPL_VAL](@p_location ,      @v_delimiter, @mst_loop_cnt)
                        , @v_prod_type        = [dbo].[SCM_ARR_SPL_VAL](@p_prod_type ,     @v_delimiter, @mst_loop_cnt)
                        , @v_market           = [dbo].[SCM_ARR_SPL_VAL](@p_market ,        @v_delimiter, @mst_loop_cnt)
                        , @v_electrode_type   = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,@v_delimiter, @mst_loop_cnt)
                        , @v_category_id      = [dbo].[SCM_ARR_SPL_VAL](@p_category_id ,   @v_delimiter, @mst_loop_cnt)
                        , @v_p_in_qty         = [dbo].[SCM_ARR_SPL_VAL](@p_p_in_qty ,      @v_delimiter, @mst_loop_cnt)
                        , @v_p_out_qty        = [dbo].[SCM_ARR_SPL_VAL](@p_p_out_qty ,     @v_delimiter, @mst_loop_cnt)
                        , @v_mpp_in_qty       = [dbo].[SCM_ARR_SPL_VAL](@p_mpp_in_qty ,    @v_delimiter, @mst_loop_cnt)
                        , @v_mpp_out_qty      = [dbo].[SCM_ARR_SPL_VAL](@p_mpp_out_qty ,   @v_delimiter, @mst_loop_cnt)
                        , @v_wpp_in_qty       = [dbo].[SCM_ARR_SPL_VAL](@p_wpp_in_qty ,    @v_delimiter, @mst_loop_cnt)
                        , @v_wpp_out_qty      = [dbo].[SCM_ARR_SPL_VAL](@p_wpp_out_qty ,   @v_delimiter, @mst_loop_cnt)
                        , @v_boh_qty          = [dbo].[SCM_ARR_SPL_VAL](@p_boh_qty ,       @v_delimiter, @mst_loop_cnt)
						, @v_plm_ec_no        = [dbo].[SCM_ARR_SPL_VAL](@p_plm_ec_no ,     @v_delimiter, @mst_loop_cnt)
						, @v_version          = [dbo].[SCM_ARR_SPL_VAL](@p_version ,       @v_delimiter, @mst_loop_cnt)
					   
					   /****************************************************************************/
					   /* MERGE_DATA  저장 경우  :   (MAIN)                                                   */
					   /****************************************************************************/
					   IF(@v_sys_flag ='MERGE_DATA')
						   BEGIN

								SELECT @v_dSql1 = ''

                                SELECT @v_dSql1 += ' MERGE INTO FP_AMEND_PLAN_CELL_R A ' + char(10)
                                SELECT @v_dSql1 += ' USING (SELECT UPPER('''+ @v_instance_id +''') AS INSTANCE_ID, UPPER('''+ @v_plan_id +''') AS FP_PLAN_ID, UPPER('''+ @v_division_id +''') AS DIVISION_ID ' + char(10)
                                SELECT @v_dSql1 += '           , ''PLAN'' AS CATEGORY_ID, UPPER('''+ @v_site_id +''') AS SITE_ID, UPPER('''+ @v_plant_id +''') AS PLANT_ID                                   ' + char(10)
                                SELECT @v_dSql1 += '           , UPPER('''+ @v_top_item_id +''') AS TOP_ITEM_ID, UPPER('''+ @v_item_id +''') AS ITEM_ID, UPPER('''+ @v_operation_id +''') AS OPERATION_ID    ' + char(10)
                                SELECT @v_dSql1 += '           , UPPER('''+ @v_prod_type +''') AS PRODUCTION_TYPE, UPPER('''+ @v_market +''') AS MARKET,UPPER('''+ @v_factory_id +''') AS FACTORY_ID         ' + char(10)
                                SELECT @v_dSql1 += '           , UPPER('''+ @v_line_id +''') AS LINE_ID, '''+ @v_electrode_type +''' AS ELECTRODE_TYPE, '''+ @v_plan_date +''' AS PLAN_DATE                  ' + char(10)
                                SELECT @v_dSql1 += '           , UPPER('''+ @v_location +''') AS LOCATION ' + char(10)
                                SELECT @v_dSql1 += '           , ''' + @v_plm_ec_no + ''' AS PLM_EC_NO, ''' + @v_version + ''' AS VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql1 += '           , ( SELECT MAX(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
                                SELECT @v_dSql1 += '           	   FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '           	   WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
                                SELECT @v_dSql1 += '           	   AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
                                SELECT @v_dSql1 += '           	   AND    C.USE_FLAG    = ''Y'' ' + char(10)
                                SELECT @v_dSql1 += '           	   AND    A.DIVISION_ID = ''' + @v_division_id + ''' ' + char(10)
                                SELECT @v_dSql1 += '           	   AND    A.SITE_ID     = ''' + @v_site_id + ''' ' + char(10)
                                SELECT @v_dSql1 += '           	   AND    A.ITEM_ID     = ''' + @v_top_item_id + ''' ' + char(10)
                                SELECT @v_dSql1 += '           ) AS ITEM_TYPE ' + char(10) -- item type 정보 직접 조회... 20230915
								SELECT @v_dSql1 += ' ) B ' + char(10)
                                SELECT @v_dSql1 += ' ON (  A.INSTANCE_ID         = B.INSTANCE_ID     AND A.FP_PLAN_ID      = B.FP_PLAN_ID      ' + char(10)
                                SELECT @v_dSql1 += '       AND A.DIVISION_ID     = B.DIVISION_ID     AND A.CATEGORY_ID     = B.CATEGORY_ID     ' + char(10)
                                SELECT @v_dSql1 += '       AND A.SITE_ID         = B.SITE_ID         AND A.PLANT_ID        = B.PLANT_ID        ' + char(10)    
                                SELECT @v_dSql1 += '       AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID     AND A.ITEM_ID         = B.ITEM_ID         ' + char(10)
                                SELECT @v_dSql1 += '       AND A.OPERATION_ID    = B.OPERATION_ID    AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql1 += '       AND A.MARKET          = B.MARKET          AND A.FACTORY_ID      = B.FACTORY_ID      ' + char(10)
                                SELECT @v_dSql1 += '       AND A.LINE_ID         = B.LINE_ID         AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE  ' + char(10)
                                SELECT @v_dSql1 += '       AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.LOCATION = B.LOCATION AND A.PLM_EC_NO = B.PLM_EC_NO AND A.VERSION = B.VERSION ) ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql1 += ' WHEN MATCHED THEN                                                                         ' + char(10)
                                SELECT @v_dSql1 += '       UPDATE SET IN_QTY  = CEILING(FLOOR('''+ @v_p_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE)) ' + char(10)
                                SELECT @v_dSql1 += '                        /( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD   ' + char(10)
                                SELECT @v_dSql1 += '                           FROM   SCM_YIELD_M YYY WITH(NOLOCK)                                          ' + char(10)
                                SELECT @v_dSql1 += '                           LEFT OUTER JOIN (                                                            ' + char(10)
                                SELECT @v_dSql1 += '                                  SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                                  FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)                ' + char(10)
                                SELECT @v_dSql1 += '                                  WHERE  EE.DIVISION_ID  = B.DIVISION_ID                   ' + char(10)
                                SELECT @v_dSql1 += '                                  AND    EE.SITE_ID      = B.SITE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                                  AND    EE.PLANT_ID     = B.PLANT_ID                      ' + char(10)
                                SELECT @v_dSql1 += '                                  AND    EE.FACTORY_ID   = B.FACTORY_ID                    ' + char(10)
                                SELECT @v_dSql1 += '                                  AND    EE.OPERATION_ID = B.OPERATION_ID                  ' + char(10)
                                SELECT @v_dSql1 += '                                  AND    EE.LINE_ID      = B.LINE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                                  AND    EE.ITEM_ID      = B.ITEM_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                                  AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '                           ) EEE                                     ' + char(10)
                                SELECT @v_dSql1 += '                           ON     1=1                                ' + char(10)
                                SELECT @v_dSql1 += '                           WHERE  YYY.DIVISION_ID  = B.DIVISION_ID   ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.SITE_ID      = B.SITE_ID       ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.PLANT_ID     = B.PLANT_ID      ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.FACTORY_ID   = B.FACTORY_ID    ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.OPERATION_ID = B.OPERATION_ID  ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.LINE_ID      = B.LINE_ID       ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.ITEM_ID      = B.ITEM_ID       ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))                      ' + char(10)
                                SELECT @v_dSql1 += '      , OUT_QTY = FLOOR('''+ @v_p_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))   ' + char(10)
                                SELECT @v_dSql1 += '      , CELL_IN_QTY  = CEILING('''+ @v_p_out_qty +'''                                                                           ' + char(10)
                                SELECT @v_dSql1 += '         / ( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '             FROM   SCM_YIELD_M YYY WITH(NOLOCK)                                        ' + char(10)
                                SELECT @v_dSql1 += '             LEFT OUTER JOIN (                                                          ' + char(10)
                                SELECT @v_dSql1 += '                 SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD  ' + char(10)
                                SELECT @v_dSql1 += '                 FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)                ' + char(10)
                                SELECT @v_dSql1 += '                 WHERE  EE.DIVISION_ID  = B.DIVISION_ID                   ' + char(10)
                                SELECT @v_dSql1 += '                 AND    EE.SITE_ID      = B.SITE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                 AND    EE.PLANT_ID     = B.PLANT_ID                      ' + char(10)
                                SELECT @v_dSql1 += '                 AND    EE.FACTORY_ID   = B.FACTORY_ID                    ' + char(10)
                                SELECT @v_dSql1 += '                 AND    EE.OPERATION_ID = B.OPERATION_ID                  ' + char(10)
                                SELECT @v_dSql1 += '                 AND    EE.LINE_ID      = B.LINE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                 AND    EE.ITEM_ID      = B.ITEM_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                 AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '             ) EEE                                     ' + char(10)
                                SELECT @v_dSql1 += '             ON     1=1                                ' + char(10)
                                SELECT @v_dSql1 += '             WHERE  YYY.DIVISION_ID  = B.DIVISION_ID   ' + char(10)
                                SELECT @v_dSql1 += '             AND    YYY.SITE_ID      = B.SITE_ID       ' + char(10)
                                SELECT @v_dSql1 += '             AND    YYY.PLANT_ID     = B.PLANT_ID      ' + char(10)
                                SELECT @v_dSql1 += '             AND    YYY.FACTORY_ID   = B.FACTORY_ID    ' + char(10)
                                SELECT @v_dSql1 += '             AND    YYY.OPERATION_ID = B.OPERATION_ID  ' + char(10)
                                SELECT @v_dSql1 += '             AND    YYY.LINE_ID      = B.LINE_ID       ' + char(10)
                                SELECT @v_dSql1 += '             AND    YYY.ITEM_ID      = B.ITEM_ID       ' + char(10)
                                SELECT @v_dSql1 += '             AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))                ' + char(10)
                                SELECT @v_dSql1 += '      , CELL_OUT_QTY = '''+ @v_p_out_qty +'''                                                               ' + char(10)
                                SELECT @v_dSql1 += '      , DATE_SEQ = CASE WHEN CONVERT(NUMERIC(25,10),ISNULL('''+ @v_p_out_qty +''',0)) = 0 THEN 0 ELSE 1 END ' + char(10)
                                SELECT @v_dSql1 += '      , UPDATE_ID = '''+ @v_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''')            ' + char(10)
                                SELECT @v_dSql1 += '      , PRODUCTION_TYPE = B.PRODUCTION_TYPE                            ' + char(10)
                                SELECT @v_dSql1 += ' WHEN NOT MATCHED THEN                                                 ' + char(10)
                                SELECT @v_dSql1 += '     INSERT (                                                          ' + char(10)
                                SELECT @v_dSql1 += '         INSTANCE_ID,   FP_PLAN_ID,   COMPANY_ID,     DIVISION_ID      ' + char(10)
                                SELECT @v_dSql1 += '        , CATEGORY_ID,  SITE_ID,      PLANT_ID,       ITEM_ID          ' + char(10)
                                SELECT @v_dSql1 += '        , OPERATION_ID, FACTORY_ID,   LOCATION,       PRODUCTION_TYPE  ' + char(10)
                                SELECT @v_dSql1 += '        , MARKET,       LINE_ID,      ELECTRODE_TYPE, PLAN_DATE        ' + char(10)
                                SELECT @v_dSql1 += '        , TOP_ITEM_ID,  ITEM_TYPE,    IN_QTY,         OUT_QTY          ' + char(10)
                                SELECT @v_dSql1 += '        , CELL_IN_QTY,  CELL_OUT_QTY, DATE_SEQ,       INSERT_ID        ' + char(10)
                                SELECT @v_dSql1 += '        , INSERT_TIME,  UPDATE_ID,    UPDATE_TIME                      ' + char(10)
                                SELECT @v_dSql1 += '        , PLM_EC_NO, VERSION ' + char(10) -- version 정보... 20230915
								SELECT @v_dSql1 += '          )                                                            ' + char(10)
                                SELECT @v_dSql1 += '     VALUES (                                                          ' + char(10)
                                SELECT @v_dSql1 += '        UPPER('''+ @v_instance_id +'''), UPPER('''+ @v_plan_id +''')   ' + char(10)
                                SELECT @v_dSql1 += '       , ( SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE DIVISION_ID = UPPER('''+ @v_division_id +''')                           ' + char(10)
                                SELECT @v_dSql1 += '           AND SITE_ID = UPPER('''+ @v_site_id +''') AND PLANT_ID = UPPER('''+ @v_plant_id +''') AND ACTIVE_FLAG = ''Y'')              ' + char(10)
                                SELECT @v_dSql1 += '       , UPPER('''+ @v_division_id +''')                                                                                               ' + char(10)
                                SELECT @v_dSql1 += '       , ''PLAN'', UPPER('''+ @v_site_id +'''), UPPER('''+ @v_plant_id +'''), UPPER('''+ @v_item_id +''')                              ' + char(10)
                                SELECT @v_dSql1 += '       , UPPER('''+ @v_operation_id +'''), UPPER('''+ @v_factory_id +'''), UPPER('''+ @v_location +'''), UPPER('''+ @v_prod_type +''') ' + char(10)
                                SELECT @v_dSql1 += '       , UPPER('''+ @v_market +'''),UPPER('''+ @v_line_id +'''), '''+ @v_electrode_type +''',CONVERT(DATE,'''+ @v_plan_date +''')      ' + char(10)
                                SELECT @v_dSql1 += '       , UPPER('''+ @v_top_item_id +'''), B.ITEM_TYPE ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql1 += '       , CEILING(FLOOR('''+ @v_p_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))             ' + char(10)
                                SELECT @v_dSql1 += '         /( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD           ' + char(10)
                                SELECT @v_dSql1 += '            FROM   SCM_YIELD_M YYY WITH(NOLOCK)                                         ' + char(10)
                                SELECT @v_dSql1 += '            LEFT OUTER JOIN (                                                           ' + char(10)
                                SELECT @v_dSql1 += '                  SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                  FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)                ' + char(10)
                                SELECT @v_dSql1 += '                  WHERE  EE.DIVISION_ID  = B.DIVISION_ID                   ' + char(10)
                                SELECT @v_dSql1 += '                  AND    EE.SITE_ID      = B.SITE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                  AND    EE.PLANT_ID     = B.PLANT_ID                      ' + char(10)
                                SELECT @v_dSql1 += '                  AND    EE.FACTORY_ID   = B.FACTORY_ID                    ' + char(10)
                                SELECT @v_dSql1 += '                  AND    EE.OPERATION_ID = B.OPERATION_ID                  ' + char(10)
                                SELECT @v_dSql1 += '                  AND    EE.LINE_ID      = B.LINE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                  AND    EE.ITEM_ID      = B.ITEM_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                  AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '            ) EEE                                      ' + char(10)
                                SELECT @v_dSql1 += '            ON     1=1                                 ' + char(10)
                                SELECT @v_dSql1 += '            WHERE  YYY.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql1 += '            AND    YYY.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql1 += '            AND    YYY.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '            AND    YYY.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql1 += '            AND    YYY.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql1 += '            AND    YYY.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql1 += '            AND    YYY.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql1 += '            AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))                                      ' + char(10)
                                SELECT @v_dSql1 += '       , FLOOR('''+ @v_p_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))             ' + char(10)
                                SELECT @v_dSql1 += '       , CEILING('''+ @v_p_out_qty +'''                                                                                          ' + char(10)
                                SELECT @v_dSql1 += '         / (  SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)                  
                                SELECT @v_dSql1 += '              FROM   SCM_YIELD_M YYY WITH(NOLOCK)                                        ' + char(10)
                                SELECT @v_dSql1 += '              LEFT OUTER JOIN (                                                          ' + char(10)
                                SELECT @v_dSql1 += '                   SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                   FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)                ' + char(10)
                                SELECT @v_dSql1 += '                   WHERE  EE.DIVISION_ID  = B.DIVISION_ID                   ' + char(10)
                                SELECT @v_dSql1 += '                   AND    EE.SITE_ID      = B.SITE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                   AND    EE.PLANT_ID     = B.PLANT_ID                      ' + char(10)
                                SELECT @v_dSql1 += '                   AND    EE.FACTORY_ID   = B.FACTORY_ID                    ' + char(10)
                                SELECT @v_dSql1 += '                   AND    EE.OPERATION_ID = B.OPERATION_ID                  ' + char(10)
                                SELECT @v_dSql1 += '                   AND    EE.LINE_ID      = B.LINE_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                   AND    EE.ITEM_ID      = B.ITEM_ID                       ' + char(10)
                                SELECT @v_dSql1 += '                   AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '              ) EEE                                    ' + char(10)
                                SELECT @v_dSql1 += '              ON     1=1                               ' + char(10)
                                SELECT @v_dSql1 += '              WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql1 += '              AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql1 += '              AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql1 += '              AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql1 += '              AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql1 += '              AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql1 += '              AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql1 += '              AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))     ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_p_out_qty +'''                                                                   ' + char(10)
                                SELECT @v_dSql1 += '       , CASE WHEN CONVERT(NUMERIC(25,10),ISNULL('''+ @v_p_out_qty +''',0)) = 0 THEN 0 ELSE 1 END ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''')                           ' + char(10)
                                SELECT @v_dSql1 += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''')                           ' + char(10)
								SELECT @v_dSql1 += '       , B.PLM_EC_NO, B.VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql1 += '   ) ; ' + char(10)
                                
								SELECT @v_dSql2  = ''         
                                SELECT @v_dSql2 += ' INSERT INTO HIS_AMEND_PLAN_CELL_R (                              ' + char(10)
                                SELECT @v_dSql2 += '  INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID                ' + char(10)
                                SELECT @v_dSql2 += ' , CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID                        ' + char(10)
                                SELECT @v_dSql2 += ' , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE            ' + char(10)
                                SELECT @v_dSql2 += ' , MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE                     ' + char(10)
                                SELECT @v_dSql2 += ' , TOP_ITEM_ID, ITEM_TYPE, IN_QTY, OUT_QTY                        ' + char(10)
                                SELECT @v_dSql2 += ' , CELL_IN_QTY, CELL_OUT_QTY, INSERT_ID, INSERT_TIME              ' + char(10)
                                SELECT @v_dSql2 += ' , UPDATE_ID, UPDATE_TIME, DATE_SEQ, JOB_USER_ID                  ' + char(10)
                                SELECT @v_dSql2 += ' , JOB_TIME, JOB_TYPE                                             ' + char(10)
								SELECT @v_dSql2 += ' , PLM_EC_NO, VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql2 += ' )                                                                ' + char(10)
                                SELECT @v_dSql2 += ' SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID          ' + char(10)
                                SELECT @v_dSql2 += ' , CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID                        ' + char(10)
                                SELECT @v_dSql2 += ' , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE            ' + char(10)
                                SELECT @v_dSql2 += ' , MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE                     ' + char(10)
                                SELECT @v_dSql2 += ' , TOP_ITEM_ID, ITEM_TYPE,IN_QTY ,OUT_QTY                         ' + char(10)
                                SELECT @v_dSql2 += ' , CELL_IN_QTY, CELL_OUT_QTY, INSERT_ID, INSERT_TIME              ' + char(10)
                                SELECT @v_dSql2 += ' , UPDATE_ID, UPDATE_TIME, DATE_SEQ,'''+ @v_user_id +'''          ' + char(10)
                                SELECT @v_dSql2 += ' , GETDATE() AS JOB_TIME, ''UPDATE'' AS JOB_TYPE                  ' + char(10)
								SELECT @v_dSql2 += ' , PLM_EC_NO, VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql2 += ' FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)                       ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  A.INSTANCE_ID      = '''+ @v_instance_id +'''             ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.FP_PLAN_ID       = '''+ @v_plan_id +'''                 ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.DIVISION_ID      = '''+ @v_division_id +'''             ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.CATEGORY_ID      = ''PLAN''                             ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.SITE_ID          = '''+ @v_site_id +'''                 ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PLANT_ID         = '''+ @v_plant_id +'''                ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.TOP_ITEM_ID      = '''+ @v_top_item_id +'''             ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.ITEM_ID          = '''+ @v_item_id +'''                 ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.OPERATION_ID     = '''+ @v_operation_id +'''            ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.FACTORY_ID       = '''+ @v_factory_id +'''              ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.LOCATION         = '''+ @v_location +'''                ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PRODUCTION_TYPE  = '''+ @v_prod_type +'''               ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.MARKET           = '''+ @v_market +'''                  ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.LINE_ID          = '''+ @v_line_id +'''                 ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.ELECTRODE_TYPE   = '''+ @v_electrode_type +'''          ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PLAN_DATE        = CONVERT(DATE,'''+ @v_plan_date +''') ' + char(10)
								SELECT @v_dSql2 += ' AND    A.PLM_EC_NO        = '''+ @p_plm_ec_no +''' ' + char(10)
								SELECT @v_dSql2 += ' AND    A.VERSION          = '''+ @p_version +''' ' + char(10)
								
								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'

					   /****************************************************************************/
					   /* MERGE_DATA_MPP_WPP  저장 경우  :   (MAIN)                                     */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='MERGE_DATA_MPPWPP')
						   BEGIN

								SELECT @v_dSql1 = ''

                                SELECT @v_dSql1 += '    MERGE INTO FP_AMEND_PLAN_CELL_H A ' + char(10)
                                SELECT @v_dSql1 += '    USING ( ' + char(10)
                                SELECT @v_dSql1 += '           SELECT UPPER('''+ @v_instance_id +''') AS INSTANCE_ID, UPPER('''+ @v_plan_id +''') AS FP_PLAN_ID,UPPER('''+ @v_division_id +''') AS DIVISION_ID ' + char(10)
                                SELECT @v_dSql1 += '               , ''PLAN'' AS CATEGORY_ID, UPPER('''+ @v_site_id +''') AS SITE_ID, UPPER('''+ @v_plant_id +''') AS PLANT_ID                                 ' + char(10)
                                SELECT @v_dSql1 += '               , UPPER('''+ @v_top_item_id +''') AS TOP_ITEM_ID, UPPER('''+ @v_item_id +''') AS ITEM_ID, UPPER('''+ @v_operation_id +''') AS OPERATION_ID  ' + char(10)
                                SELECT @v_dSql1 += '               , UPPER('''+ @v_prod_type +''') AS PRODUCTION_TYPE, UPPER('''+ @v_market +''') AS MARKET, UPPER('''+ @v_factory_id +''') AS FACTORY_ID      ' + char(10)
                                SELECT @v_dSql1 += '               , UPPER('''+ @v_line_id +''') AS LINE_ID, '''+ @v_electrode_type +''' AS ELECTRODE_TYPE, '''+ @v_plan_date +''' AS PLAN_DATE                ' + char(10)
                                SELECT @v_dSql1 += '               , UPPER('''+ @v_location +''') AS LOCATION ' + char(10)
								SELECT @v_dSql1 += '               , ''' + @v_plm_ec_no + ''' AS PLM_EC_NO, ''' + @v_version + ''' AS VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql1 += '               , ( SELECT MAX(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE ' + char(10)
                                SELECT @v_dSql1 += '               	   FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '               	   WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
                                SELECT @v_dSql1 += '               	   AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
                                SELECT @v_dSql1 += '               	   AND    C.USE_FLAG    = ''Y'' ' + char(10)
                                SELECT @v_dSql1 += '               	   AND    A.DIVISION_ID = ''' + @v_division_id + ''' ' + char(10)
                                SELECT @v_dSql1 += '               	   AND    A.SITE_ID     = ''' + @v_site_id + ''' ' + char(10)
                                SELECT @v_dSql1 += '               	   AND    A.ITEM_ID     = ''' + @v_top_item_id + ''' ' + char(10)
                                SELECT @v_dSql1 += '               ) AS ITEM_TYPE ' + char(10) -- item type 정보 직접 조회... 20230915
								SELECT @v_dSql1 += '    ) B ' + char(10)
                                SELECT @v_dSql1 += '    ON (     A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID             ' + char(10)
                                SELECT @v_dSql1 += '         AND A.DIVISION_ID = B.DIVISION_ID AND A.CATEGORY_ID = B.CATEGORY_ID           ' + char(10)
                                SELECT @v_dSql1 += '         AND A.SITE_ID = B.SITE_ID         AND A.PLANT_ID = B.PLANT_ID                 ' + char(10)
                                SELECT @v_dSql1 += '         AND A.TOP_ITEM_ID = B.TOP_ITEM_ID AND A.ITEM_ID = B.ITEM_ID                   ' + char(10)
                                SELECT @v_dSql1 += '         AND A.OPERATION_ID = B.OPERATION_ID AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql1 += '         AND A.MARKET = B.MARKET             AND A.FACTORY_ID = B.FACTORY_ID           ' + char(10)
                                SELECT @v_dSql1 += '         AND A.LINE_ID = B.LINE_ID           AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE   ' + char(10)
								SELECT @v_dSql1 += '         AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE AND A.LOCATION = B.LOCATION AND A.PLM_EC_NO = B.PLM_EC_NO AND A.VERSION = B.VERSION ) ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql1 += '    WHEN MATCHED THEN ' + char(10)
                                SELECT @v_dSql1 += '    UPDATE SET WPP_IN_QTY = CEILING(FLOOR('''+ @v_wpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE)) ' + char(10)
                                SELECT @v_dSql1 += '                        /( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD       ' + char(10)
                                SELECT @v_dSql1 += '                           FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                           LEFT OUTER JOIN (                   ' + char(10)
                                SELECT @v_dSql1 += '                                 SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                                 FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                                 WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '                           ) EEE      ' + char(10)
                                SELECT @v_dSql1 += '                           ON     1=1 ' + char(10)
                                SELECT @v_dSql1 += '                           WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql1 += '                           AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql1 += '             , WPP_OUT_QTY = FLOOR('''+ @v_wpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))   ' + char(10)
                                SELECT @v_dSql1 += '             , WPP_CELL_IN_QTY = CEILING('''+ @v_wpp_out_qty +'''                                                                            ' + char(10)
                                SELECT @v_dSql1 += '                       / (  SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                            FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                            LEFT OUTER JOIN (                   ' + char(10)
                                SELECT @v_dSql1 += '                                 SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                                 FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                                 WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                 AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '                            ) EEE      ' + char(10)
                                SELECT @v_dSql1 += '                            ON     1=1 ' + char(10)
                                SELECT @v_dSql1 += '                            WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql1 += '                            AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                            AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql1 += '                            AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql1 += '                            AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql1 += '                            AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                            AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql1 += '                            AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql1 += '             , WPP_CELL_OUT_QTY = '''+ @v_wpp_out_qty +'''                         ' + char(10)
                                SELECT @v_dSql1 += '             , MPP_IN_QTY = CEILING(FLOOR('''+ @v_mpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE) ) ' + char(10)
                                SELECT @v_dSql1 += '                          /( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD      ' + char(10)
                                SELECT @v_dSql1 += '                          	 FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                          	 LEFT OUTER JOIN (                   ' + char(10)
                                SELECT @v_dSql1 += '                          	      SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                          	      FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                          	      WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql1 += '                          	      AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                          	      AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '                          	      AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql1 += '                          	      AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql1 += '                          	      AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                          	      AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql1 += '                          	      AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '                          	 ) EEE      ' + char(10)
                                SELECT @v_dSql1 += '                          	 ON     1=1 ' + char(10)
                                SELECT @v_dSql1 += '                          	 WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql1 += '                          	 AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                          	 AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql1 += '                          	 AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql1 += '                          	 AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql1 += '                          	 AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                          	 AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql1 += '                          	 AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql1 += '             , MPP_OUT_QTY = FLOOR('''+ @v_mpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE) )      ' + char(10)
                                SELECT @v_dSql1 += '             , MPP_CELL_IN_QTY = CEILING('''+ @v_mpp_out_qty +'''                                                                                ' + char(10)
                                SELECT @v_dSql1 += '                           / (  SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                                FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                                LEFT OUTER JOIN (                   ' + char(10)
                                SELECT @v_dSql1 += '                                     SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql1 += '                                     FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql1 += '                                     WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql1 += '                                     AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                     AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql1 += '                                     AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql1 += '                                     AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql1 += '                                     AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                     AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql1 += '                                     AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql1 += '                                ) EEE      ' + char(10)
                                SELECT @v_dSql1 += '                                ON     1=1 ' + char(10)
                                SELECT @v_dSql1 += '                                WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql1 += '                                AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                                AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql1 += '                                AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql1 += '                                AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql1 += '                                AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql1 += '                                AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql1 += '                                AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql1 += '             , MPP_CELL_OUT_QTY = '''+ @v_mpp_out_qty +''' ' + char(10)
                                SELECT @v_dSql1 += '             , DATE_SEQ = CASE WHEN (CONVERT(NUMERIC(25,10),ISNULL('''+ @v_wpp_out_qty +''',0)) = 0 AND CONVERT(NUMERIC(25,10),ISNULL('''+ @v_mpp_out_qty +''',0)) = 0) THEN 0 ELSE 1 END ' + char(10)
                                SELECT @v_dSql1 += '             , UPDATE_ID = '''+ @v_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql1 += '             , PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)

			                    SELECT @v_dSql2  = ''
                                SELECT @v_dSql2 += '    WHEN NOT MATCHED THEN ' + char(10)
                                SELECT @v_dSql2 += '        INSERT (          ' + char(10)
                                SELECT @v_dSql2 += '           INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID            ' + char(10)
                                SELECT @v_dSql2 += '          , CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID                    ' + char(10)
                                SELECT @v_dSql2 += '          , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE        ' + char(10)
                                SELECT @v_dSql2 += '          , MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE                 ' + char(10)
                                SELECT @v_dSql2 += '          , TOP_ITEM_ID, ITEM_TYPE, WPP_IN_QTY, WPP_OUT_QTY            ' + char(10)
                                SELECT @v_dSql2 += '          , WPP_CELL_IN_QTY, WPP_CELL_OUT_QTY, MPP_IN_QTY, MPP_OUT_QTY ' + char(10)
                                SELECT @v_dSql2 += '          , MPP_CELL_IN_QTY, MPP_CELL_OUT_QTY, DATE_SEQ, INSERT_ID     ' + char(10)
                                SELECT @v_dSql2 += '          , INSERT_TIME, UPDATE_ID, UPDATE_TIME                        ' + char(10)
								SELECT @v_dSql2 += '          , PLM_EC_NO, VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql2 += '        )        ' + char(10)
                                SELECT @v_dSql2 += '        VALUES ( ' + char(10)
                                SELECT @v_dSql2 += '           UPPER('''+ @v_instance_id +'''), UPPER('''+ @v_plan_id +''') ' + char(10)
                                SELECT @v_dSql2 += '          ,( SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M              ' + char(10)
                                SELECT @v_dSql2 += '             WHERE DIVISION_ID = UPPER('''+ @v_division_id +''') AND SITE_ID = UPPER('''+ @v_site_id +''')  ' + char(10)
                                SELECT @v_dSql2 += '        	 AND PLANT_ID = UPPER('''+ @v_plant_id +''') AND ACTIVE_FLAG = ''Y''                            ' + char(10)
                                SELECT @v_dSql2 += '           ), UPPER('''+ @v_division_id +''')                                                               ' + char(10)
                                SELECT @v_dSql2 += '          ,''PLAN'',UPPER('''+ @v_site_id +'''), UPPER('''+ @v_plant_id +'''), UPPER('''+ @v_item_id +''')  ' + char(10)
                                SELECT @v_dSql2 += '          , UPPER('''+ @v_operation_id +'''), UPPER('''+ @v_factory_id +'''), UPPER('''+ @v_location +'''), UPPER('''+ @v_prod_type +''') ' + char(10)
                                SELECT @v_dSql2 += '          , UPPER('''+ @v_market +'''), UPPER('''+ @v_line_id +'''), '''+ @v_electrode_type +''', CONVERT(DATE,'''+ @v_plan_date +''')    ' + char(10)
                                --SELECT @v_dSql2 += '          , UPPER('''+ @v_top_item_id +'''), UPPER('''+ @v_item_type +''')                                                                ' + char(10)
								SELECT @v_dSql2 += '          , UPPER('''+ @v_top_item_id +'''), B.ITEM_TYPE ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql2 += '          ,CEILING(FLOOR('''+ @v_wpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))          ' + char(10)
                                SELECT @v_dSql2 += '                  /(  SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD    ' + char(10)
                                SELECT @v_dSql2 += '                      FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                      LEFT OUTER JOIN (                   ' + char(10)
                                SELECT @v_dSql2 += '                           SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql2 += '                           FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                           WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql2 += '                           AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                           AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '                           AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql2 += '                           AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql2 += '                           AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                           AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql2 += '                           AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql2 += '                      ) EEE      ' + char(10)
                                SELECT @v_dSql2 += '                      ON     1=1 ' + char(10)
                                SELECT @v_dSql2 += '                      WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql2 += '                      AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                      AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql2 += '                      AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql2 += '                      AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql2 += '                      AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                      AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql2 += '                      AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql2 += '          ,FLOOR('''+ @v_wpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))             ' + char(10)
                                SELECT @v_dSql2 += '          ,CEILING('''+ @v_wpp_out_qty +'''                                                                                          ' + char(10)
                                SELECT @v_dSql2 += '                / ( SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)
                                SELECT @v_dSql2 += '                    FROM  SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                    LEFT OUTER JOIN (                  ' + char(10)
                                SELECT @v_dSql2 += '                          SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql2 += '                          FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                          WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql2 += '                          AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql2 += '                    ) EEE      ' + char(10)
                                SELECT @v_dSql2 += '                    ON     1=1 ' + char(10)
                                SELECT @v_dSql2 += '                    WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql2 += '          ,'''+ @v_wpp_out_qty +'''                                        ' + char(10)
                                SELECT @v_dSql2 += '          ,CEILING(FLOOR('''+ @v_mpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))     ' + char(10)
                                SELECT @v_dSql2 += '                /(  SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)
                                SELECT @v_dSql2 += '                    FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                    LEFT OUTER JOIN (                   ' + char(10)
                                SELECT @v_dSql2 += '                          SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql2 += '                          FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                          WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                          AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql2 += '                          AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql2 += '                    ) EEE      ' + char(10)
                                SELECT @v_dSql2 += '                    ON     1=1 ' + char(10)
                                SELECT @v_dSql2 += '                    WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql2 += '                    AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql2 += '          ,FLOOR('''+ @v_mpp_out_qty +''' * dbo.FN_GET_REQ_QTY_MODEL(B.PLANT_ID, B.TOP_ITEM_ID, B.ITEM_ID, B.PLAN_DATE))          ' + char(10)
                                SELECT @v_dSql2 += '          ,CEILING('''+ @v_mpp_out_qty +'''                                                                                       ' + char(10)
                                SELECT @v_dSql2 += '            / (  SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD ' + char(10)
                                SELECT @v_dSql2 += '                 FROM   SCM_YIELD_M YYY WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                 LEFT OUTER JOIN (                   ' + char(10)
                                SELECT @v_dSql2 += '                     SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
                                SELECT @v_dSql2 += '                     FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql2 += '                     WHERE  EE.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
                                SELECT @v_dSql2 += '                     AND    EE.SITE_ID      = B.SITE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                     AND    EE.PLANT_ID     = B.PLANT_ID       ' + char(10)
                                SELECT @v_dSql2 += '                     AND    EE.FACTORY_ID   = B.FACTORY_ID     ' + char(10)
                                SELECT @v_dSql2 += '                     AND    EE.OPERATION_ID = B.OPERATION_ID   ' + char(10)
                                SELECT @v_dSql2 += '                     AND    EE.LINE_ID      = B.LINE_ID        ' + char(10)
                                SELECT @v_dSql2 += '                     AND    EE.ITEM_ID      = B.ITEM_ID        ' + char(10)
                                SELECT @v_dSql2 += '                     AND    CONVERT(DATE,B.PLAN_DATE) BETWEEN EE.START_TIME AND EE.END_TIME ' + char(10)
                                SELECT @v_dSql2 += '                 ) EEE      ' + char(10)
                                SELECT @v_dSql2 += '                 ON     1=1 ' + char(10)
                                SELECT @v_dSql2 += '                 WHERE  YYY.DIVISION_ID  = B.DIVISION_ID  ' + char(10)
                                SELECT @v_dSql2 += '                 AND    YYY.SITE_ID      = B.SITE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                 AND    YYY.PLANT_ID     = B.PLANT_ID     ' + char(10)
                                SELECT @v_dSql2 += '                 AND    YYY.FACTORY_ID   = B.FACTORY_ID   ' + char(10)
                                SELECT @v_dSql2 += '                 AND    YYY.OPERATION_ID = B.OPERATION_ID ' + char(10)
                                SELECT @v_dSql2 += '                 AND    YYY.LINE_ID      = B.LINE_ID      ' + char(10)
                                SELECT @v_dSql2 += '                 AND    YYY.ITEM_ID      = B.ITEM_ID      ' + char(10)
                                SELECT @v_dSql2 += '                 AND    YYY.MONTH        = SUBSTRING(B.PLAN_DATE,1,6))) ' + char(10)
                                SELECT @v_dSql2 += '          ,'''+ @v_mpp_out_qty +'''                                     ' + char(10)
                                SELECT @v_dSql2 += '          ,CASE WHEN (CONVERT(NUMERIC(25,10),ISNULL('''+ @v_wpp_out_qty +''',0)) = 0 AND CONVERT(NUMERIC(25,10),ISNULL('''+ @v_mpp_out_qty +''',0)) = 0) THEN 0 ELSE 1 END ' + char(10)
                                SELECT @v_dSql2 += '          ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql2 += '          ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
								SELECT @v_dSql2 += '          , B.PLM_EC_NO, B.VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql2 += '        ); ' + char(10)
		                        
								SELECT @v_dSql3  = ''
                                SELECT @v_dSql3 += ' INSERT INTO HIS_AMEND_PLAN_CELL_R (                         ' + char(10)
                                SELECT @v_dSql3 += '        INSTANCE_ID, FP_PLAN_ID,COMPANY_ID, DIVISION_ID      ' + char(10)
                                SELECT @v_dSql3 += '       ,CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID              ' + char(10)
                                SELECT @v_dSql3 += '       , OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql3 += '       , MARKET, LINE_ID, ELECTRODE_TYPE,PLAN_DATE           ' + char(10)
                                SELECT @v_dSql3 += '       ,TOP_ITEM_ID,ITEM_TYPE,WPP_OUT_QTY,WPP_CELL_OUT_QTY   ' + char(10)
                                SELECT @v_dSql3 += '       ,MPP_OUT_QTY,MPP_CELL_OUT_QTY,INSERT_ID, INSERT_TIME  ' + char(10)
                                SELECT @v_dSql3 += '       ,UPDATE_ID, UPDATE_TIME, DATE_SEQ                     ' + char(10)
                                SELECT @v_dSql3 += '       ,JOB_USER_ID, JOB_TIME, JOB_TYPE                      ' + char(10)
								SELECT @v_dSql3 += '       , PLM_EC_NO, VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql3 += ' ) ' + char(10)
                                SELECT @v_dSql3 += ' SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID     ' + char(10)
                                SELECT @v_dSql3 += '     , CATEGORY_ID, SITE_ID, PLANT_ID, ITEM_ID               ' + char(10)
                                SELECT @v_dSql3 += '     , OPERATION_ID, FACTORY_ID,LOCATION, PRODUCTION_TYPE    ' + char(10)
                                SELECT @v_dSql3 += '     , MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE            ' + char(10)
                                SELECT @v_dSql3 += '     , TOP_ITEM_ID,ITEM_TYPE,WPP_OUT_QTY,WPP_CELL_OUT_QTY    ' + char(10)
                                SELECT @v_dSql3 += '     , MPP_OUT_QTY,MPP_CELL_OUT_QTY ,INSERT_ID, INSERT_TIME  ' + char(10)
                                SELECT @v_dSql3 += '     , UPDATE_ID, UPDATE_TIME, DATE_SEQ                      ' + char(10)
                                SELECT @v_dSql3 += '     , '''+ @v_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''MERGE'' AS JOB_TYPE ' + char(10)
								SELECT @v_dSql3 += '     , PLM_EC_NO, VERSION ' + char(10) -- version 정보... 20230915
                                SELECT @v_dSql3 += ' FROM   FP_AMEND_PLAN_CELL_H A WITH(NOLOCK)                     ' + char(10)
                                SELECT @v_dSql3 += ' WHERE  A.INSTANCE_ID    = '''+ @v_instance_id +'''             ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.FP_PLAN_ID       = '''+ @v_plan_id +'''                 ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.DIVISION_ID      = '''+ @v_division_id +'''             ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.CATEGORY_ID      = ''PLAN''                             ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.SITE_ID          = '''+ @v_site_id +'''                 ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.PLANT_ID         = '''+ @v_plant_id +'''                ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.TOP_ITEM_ID      = '''+ @v_top_item_id +'''             ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.ITEM_ID          = '''+ @v_item_id +'''                 ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.OPERATION_ID     = '''+ @v_operation_id +'''            ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.FACTORY_ID       = '''+ @v_factory_id +'''              ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.LOCATION         = '''+ @v_location +'''                ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.PRODUCTION_TYPE  = '''+ @v_prod_type +'''               ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.MARKET           = '''+ @v_market +'''                  ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.LINE_ID          = '''+ @v_line_id +'''                 ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.ELECTRODE_TYPE   = '''+ @v_electrode_type +'''          ' + char(10)
                                SELECT @v_dSql3 += ' AND  A.PLAN_DATE        = CONVERT(DATE,'''+ @v_plan_date +''') ' + char(10)
								SELECT @v_dSql3 += ' AND  A.PLM_EC_NO        = '''+ @v_plm_ec_no +''' ' + char(10) -- version 정보... 20230915
								SELECT @v_dSql3 += ' AND  A.VERSION          = '''+ @v_version +''' ' + char(10) 
								
								SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3

						   END --'D'

					   /****************************************************************************/
					   /* EXECUTE  경우  :  EXEC_PAICALCUL                                           */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='EXEC_PAICALCUL')
                            BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION] @v_instance_id, @v_plan_id
								
								SET @rtnCount = 1
								SELECT	'Result' = @rtnCount

                            END
					   /****************************************************************************/
					   /* EXECUTE  경우  :  EXEC_PLANPRIORITY                                         */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='EXEC_PLANPRIORITY')
                            BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_AMEND_PLAN_PRIORITY] @v_instance_id, @v_plan_id
								
								SET @rtnCount = 1
								SELECT	'Result' = @rtnCount

                            END
					   /****************************************************************************/
					   /* EXECUTE  경우  :  EXEC_PR_PARALLEL_A                                     */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='EXEC_PR_PARALLEL_A')
                            BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A] @v_instance_id, @v_plan_id
								
								SET @rtnCount = 1
								SELECT	'Result' = @rtnCount

                            END
					   /****************************************************************************/
					   /* EXECUTE  경우  :  EXEC_PR_PARALLEL_B                                     */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='EXEC_PR_PARALLEL_B')
                            BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B] @v_instance_id, @v_plan_id
								
								SET @rtnCount = 1
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
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
						END

			    END --WHILE 내(END)

		END --(END)
 	
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

