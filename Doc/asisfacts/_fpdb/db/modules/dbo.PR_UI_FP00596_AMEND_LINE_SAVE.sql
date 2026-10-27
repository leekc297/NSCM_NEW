

/*
 * Program ID   : [PR_UI_FP00596_AMEND_LINE_SAVE]
 * Description  : Amend Formation
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/11/16   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00596_AMEND_LINE_SAVE]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_instance_id                NVARCHAR(MAX),
  @p_plan_date                  NVARCHAR(MAX),
  @p_plan_id                    NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_factory_id                 NVARCHAR(MAX),
  @p_location                   NVARCHAR(MAX),
  @p_operation_id               NVARCHAR(MAX),
  @p_line_id                    NVARCHAR(MAX),
  @p_electrode_type             NVARCHAR(MAX),
  @p_equipment_id               NVARCHAR(MAX),
  @p_top_item_id                NVARCHAR(MAX),
  @p_item_id                    NVARCHAR(MAX),
  @p_prod_type                  NVARCHAR(MAX),
  @p_market                     NVARCHAR(MAX),
  @p_seq                        NVARCHAR(MAX),
  @p_adjust_in_qty              NVARCHAR(MAX),
  @p_adjust_in_qty_batch        NVARCHAR(MAX),
  @p_adjust_in_qty_kg           NVARCHAR(MAX),
  @p_adjust_out_qty             NVARCHAR(MAX),
  @p_adjust_out_qty_batch       NVARCHAR(MAX),
  @p_adjust_out_qty_kg          NVARCHAR(MAX)


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
    DECLARE @v_instance_id                 NVARCHAR(MAX)
    DECLARE @v_plan_date                   NVARCHAR(MAX)
    DECLARE @v_plan_id                     NVARCHAR(MAX)
    DECLARE @v_company_id                  NVARCHAR(MAX)
    DECLARE @v_division_id                 NVARCHAR(MAX)
    DECLARE @v_site_id                     NVARCHAR(MAX)
    DECLARE @v_plant_id                    NVARCHAR(MAX)
    DECLARE @v_factory_id                  NVARCHAR(MAX)
    DECLARE @v_location                    NVARCHAR(MAX)
    DECLARE @v_operation_id                NVARCHAR(MAX)
	DECLARE @v_line_id                     NVARCHAR(MAX)
    DECLARE @v_electrode_type              NVARCHAR(MAX)
    DECLARE @v_equipment_id                NVARCHAR(MAX)
    DECLARE @v_top_item_id                 NVARCHAR(MAX)
    DECLARE @v_item_id                     NVARCHAR(MAX)
	DECLARE @v_prod_type                   NVARCHAR(MAX)
	DECLARE @v_market                      NVARCHAR(MAX)
	DECLARE @v_seq                         NVARCHAR(MAX)
	DECLARE @v_qty                         NVARCHAR(MAX)
	DECLARE @v_adjust_in_qty              NVARCHAR(MAX)
	DECLARE @v_adjust_in_qty_batch        NVARCHAR(MAX)
	DECLARE @v_adjust_in_qty_kg           NVARCHAR(MAX)
	DECLARE @v_adjust_out_qty             NVARCHAR(MAX)
	DECLARE @v_adjust_out_qty_batch       NVARCHAR(MAX)
	DECLARE @v_adjust_out_qty_kg          NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00596_AMEND_LINE_SAVE'
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
    DECLARE @sSql                   NVARCHAR(MAX)=''
    DECLARE @iSql                   NVARCHAR(MAX)=''

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
    SET @v_location                 = ''
    SET @v_operation_id             = ''
    SET @v_line_id                  = ''
    SET @v_electrode_type           = ''
    SET @v_equipment_id             = ''
    SET @v_top_item_id              = ''
    SET @v_item_id                  = ''
    SET @v_prod_type                = ''
    SET @v_market                   = ''
    SET @v_seq                      = ''

	SET @v_adjust_in_qty           = ''
	SET @v_adjust_in_qty_batch     = ''
	SET @v_adjust_in_qty_kg        = ''
	SET @v_adjust_out_qty          = ''
	SET @v_adjust_out_qty_batch    = ''
	SET @v_adjust_out_qty_kg       = ''

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
	SET	@sSql                 = ''
	SET	@iSql                 = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='EXEC_PSICALCUL')
         BEGIN
		    SET @runstart = GETDATE()
			SELECT @v_dSql = '[dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI] '''+ @p_instance_id +''', '''+ @p_plan_id +''' '
		    EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT(ST)',@runstart, @runend
			
			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI] @p_instance_id, @p_plan_id

			SET @runend = GETDATE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT(ED)',@runstart, @runend

			SELECT	'Result' = @rtnCount

         END
	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,             @v_delimiter,  @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,             @v_delimiter,  @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,            @v_delimiter,  @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,              @v_delimiter,  @mst_loop_cnt)
                        , @v_instance_id              = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,          @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_date                = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,            @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,              @v_delimiter,  @mst_loop_cnt)
                        , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,           @v_delimiter,  @mst_loop_cnt)
                        , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,          @v_delimiter,  @mst_loop_cnt)
                        , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,              @v_delimiter,  @mst_loop_cnt)
                        , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,             @v_delimiter,  @mst_loop_cnt)
						, @v_factory_id               = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,           @v_delimiter,  @mst_loop_cnt)
						, @v_location                 = [dbo].[SCM_ARR_SPL_VAL](@p_location ,             @v_delimiter,  @mst_loop_cnt)  
                        , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,         @v_delimiter,  @mst_loop_cnt)
                        , @v_line_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,              @v_delimiter,  @mst_loop_cnt)
						, @v_electrode_type           = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,       @v_delimiter,  @mst_loop_cnt)    
						, @v_equipment_id             = [dbo].[SCM_ARR_SPL_VAL](@p_equipment_id ,         @v_delimiter,  @mst_loop_cnt) 
						, @v_top_item_id              = [dbo].[SCM_ARR_SPL_VAL](@p_top_item_id ,          @v_delimiter,  @mst_loop_cnt)    
						, @v_item_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,              @v_delimiter,  @mst_loop_cnt)        
                        , @v_prod_type                = [dbo].[SCM_ARR_SPL_VAL](@p_prod_type ,            @v_delimiter,  @mst_loop_cnt)
						, @v_market                   = [dbo].[SCM_ARR_SPL_VAL](@p_market ,               @v_delimiter,  @mst_loop_cnt)         
						, @v_seq                      = [dbo].[SCM_ARR_SPL_VAL](@p_seq ,                  @v_delimiter,  @mst_loop_cnt)      
						, @v_adjust_in_qty       	  = [dbo].[SCM_ARR_SPL_VAL](@p_adjust_in_qty ,        @v_delimiter,  @mst_loop_cnt)
						, @v_adjust_in_qty_batch 	  = [dbo].[SCM_ARR_SPL_VAL](@p_adjust_in_qty_batch ,  @v_delimiter,  @mst_loop_cnt)
						, @v_adjust_in_qty_kg    	  = [dbo].[SCM_ARR_SPL_VAL](@p_adjust_in_qty_kg ,     @v_delimiter,  @mst_loop_cnt)
						, @v_adjust_out_qty      	  = [dbo].[SCM_ARR_SPL_VAL](@p_adjust_out_qty ,       @v_delimiter,  @mst_loop_cnt)
						, @v_adjust_out_qty_batch	  = [dbo].[SCM_ARR_SPL_VAL](@p_adjust_out_qty_batch , @v_delimiter,  @mst_loop_cnt)
						, @v_adjust_out_qty_kg   	  = [dbo].[SCM_ARR_SPL_VAL](@p_adjust_out_qty_kg ,    @v_delimiter,  @mst_loop_cnt)


					   /******************************************************************************/
					   /* MERGE_DATA 경우 : (saveAll_data)                                           */
					   /******************************************************************************/
					   IF(@v_sys_flag ='MERGE_DATA')  
							BEGIN
                                SELECT @v_dSql = ''
								SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' MERGE INTO FP_AMEND_DAILY_PLAN_R A ' + char(10)
                                SELECT @v_dSql1 += ' USING (SELECT UPPER('''+ @v_instance_id +''') AS INSTANCE_ID, UPPER('''+ @v_plan_id +''') AS FP_PLAN_ID, ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_division_id +''') AS DIVISION_ID, UPPER('''+ @v_site_id +''') AS SITE_ID,UPPER('''+ @v_plant_id +''') AS PLANT_ID, UPPER('''+ @v_factory_id +''') AS FACTORY_ID,  ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_location +''') AS LOCATION, UPPER('''+ @v_operation_id +''') AS OPERATION_ID, UPPER('''+ @v_line_id +''') AS LINE_ID, '''+ @v_electrode_type +''' AS ELECTRODE_TYPE, ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_equipment_id +''') AS EQUIPMENT_ID, '''+ @v_plan_date +''' AS PLAN_DATE,      ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_item_id +''') AS TOP_ITEM_ID, UPPER('''+ @v_item_id +''') AS ITEM_ID,         ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_prod_type +''') AS PRODUCTION_TYPE, UPPER('''+ @v_market +''') AS MARKET) B   ' + char(10)
                                SELECT @v_dSql1 += ' ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID                                     ' + char(10)
                                SELECT @v_dSql1 += '     AND A.FACTORY_ID = B.FACTORY_ID AND A.LOCATION = B.LOCATION                                           ' + char(10)
                                SELECT @v_dSql1 += '     AND A.OPERATION_ID = B.OPERATION_ID AND A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
                                SELECT @v_dSql1 += '     AND A.EQUIPMENT_ID = B.EQUIPMENT_ID AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE ' + char(10)
                                SELECT @v_dSql1 += '     AND A.TOP_ITEM_ID = B.TOP_ITEM_ID AND A.ITEM_ID = B.ITEM_ID         ' + char(10)
                                SELECT @v_dSql1 += '     AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET ) ' + char(10)
                                SELECT @v_dSql1 += ' WHEN MATCHED THEN                                                       ' + char(10)
                                SELECT @v_dSql1 += '   UPDATE SET SEQ = CASE WHEN CONVERT(NUMERIC(25,10),ISNULL('''+ @v_adjust_in_qty_batch +''',0)) = 0 THEN 0 ELSE convert(numeric,'''+ @v_seq +''') END ' + char(10)
                                SELECT @v_dSql1 += '            , ADJUST_IN_QTY_BATCH  = convert(numeric,'''+ @v_adjust_in_qty_batch +''')  ' + char(10)
                                SELECT @v_dSql1 += '            , ADJUST_IN_QTY_KG     = convert(numeric,'''+ @v_adjust_in_qty_kg +''')     ' + char(10)
                                SELECT @v_dSql1 += '            , ADJUST_OUT_QTY_BATCH = convert(numeric,'''+ @v_adjust_out_qty_batch +''') ' + char(10)
                                SELECT @v_dSql1 += '            , ADJUST_OUT_QTY_KG    = convert(numeric,'''+ @v_adjust_out_qty_kg +''')    ' + char(10)
                                SELECT @v_dSql1 += '            , UPDATE_ID = '''+ @v_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql1 += '            , PRODUCTION_TYPE = B.PRODUCTION_TYPE       ' + char(10)
                                SELECT @v_dSql1 += ' WHEN NOT MATCHED THEN                                  ' + char(10)
                                SELECT @v_dSql1 += '     INSERT (                                           ' + char(10)
                                SELECT @v_dSql1 += '        INSTANCE_ID, FP_PLAN_ID                         ' + char(10)
                                SELECT @v_dSql1 += '       ,COMPANY_ID                                      ' + char(10)
                                SELECT @v_dSql1 += '       ,DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID      ' + char(10)
                                SELECT @v_dSql1 += '       ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE ' + char(10)
                                SELECT @v_dSql1 += '       ,EQUIPMENT_ID, PLAN_DATE              ' + char(10)
                                SELECT @v_dSql1 += '       ,TOP_ITEM_ID, ITEM_ID                 ' + char(10)
                                SELECT @v_dSql1 += '       ,PRODUCTION_TYPE, MARKET              ' + char(10)
                                SELECT @v_dSql1 += '       ,SEQ                                  ' + char(10)
                                SELECT @v_dSql1 += '       ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY   ' + char(10)
                                SELECT @v_dSql1 += '       ,ADJUST_IN_QTY_KG                     ' + char(10)
                                SELECT @v_dSql1 += '       ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY ' + char(10)
                                SELECT @v_dSql1 += '       ,ADJUST_OUT_QTY_KG                    ' + char(10)
                                SELECT @v_dSql1 += '       ,INSERT_ID, INSERT_TIME               ' + char(10)
                                SELECT @v_dSql1 += '       ,UPDATE_ID, UPDATE_TIME               ' + char(10)
                                SELECT @v_dSql1 += '     )                                       ' + char(10)
                                SELECT @v_dSql1 += '     VALUES (                                ' + char(10)
                                SELECT @v_dSql1 += '        UPPER('''+ @v_instance_id +'''), UPPER('''+ @v_plan_id +''') ' + char(10)
                                SELECT @v_dSql1 += '       ,(SELECT MAX(COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = '''+ @v_factory_id +''' AND ACTIVE_FLAG = ''Y'') ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_division_id +'''), UPPER('''+ @v_site_id +'''), ('''+ @v_plant_id +'''), UPPER('''+ @v_factory_id +''')         ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_location +'''), UPPER('''+ @v_operation_id +'''), UPPER('''+ @v_line_id +'''), '''+ @v_electrode_type +'''     ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_equipment_id +''') ,CONVERT(DATETIME,'''+ @v_plan_date +''') ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_item_id +'''), UPPER('''+ @v_item_id +''')                   ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_prod_type +'''), UPPER('''+ @v_market +''')                  ' + char(10)
                                SELECT @v_dSql1 += '       ,CASE WHEN CONVERT(NUMERIC(25,10),ISNULL('''+ @v_adjust_in_qty_batch +''',0)) = 0 THEN 0 ELSE convert(numeric,'''+ @v_seq +''') END ' + char(10)
                                SELECT @v_dSql1 += '       ,convert(numeric,'''+ @v_adjust_in_qty_batch +'''),convert(numeric,'''+ @v_adjust_in_qty +''')    ' + char(10)
                                SELECT @v_dSql1 += '       ,convert(numeric,'''+ @v_adjust_in_qty_kg +''')                                  ' + char(10)
                                SELECT @v_dSql1 += '       ,convert(numeric,'''+ @v_adjust_out_qty_batch +'''), convert(numeric,'''+ @v_adjust_out_qty +''') ' + char(10)
                                SELECT @v_dSql1 += '       ,convert(numeric,'''+ @v_adjust_out_qty_kg +''')                                 ' + char(10)
                                SELECT @v_dSql1 += '       ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''')   ' + char(10)
                                SELECT @v_dSql1 += '       ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''')   ' + char(10)
                                SELECT @v_dSql1 += '     );                                     ' + char(10)
                                
								SELECT @v_dSql2 = '' + char(10)
                                SELECT @v_dSql2 += '     INSERT INTO HIS_AMEND_DAILY_PLAN_R (   ' + char(10)
                                SELECT @v_dSql2 += '            INSTANCE_ID, FP_PLAN_ID         ' + char(10)
                                SELECT @v_dSql2 += '           ,COMPANY_ID                      ' + char(10)
                                SELECT @v_dSql2 += '           ,DIVISION_ID                     ' + char(10)
                                SELECT @v_dSql2 += '           ,SITE_ID                         ' + char(10)
                                SELECT @v_dSql2 += '           ,PLANT_ID                        ' + char(10)
                                SELECT @v_dSql2 += '           ,FACTORY_ID                      ' + char(10)
                                SELECT @v_dSql2 += '           ,LOCATION                        ' + char(10)
                                SELECT @v_dSql2 += '           ,OPERATION_ID                    ' + char(10)
                                SELECT @v_dSql2 += '           ,LINE_ID                         ' + char(10)
                                SELECT @v_dSql2 += '           ,ELECTRODE_TYPE                  ' + char(10)
                                SELECT @v_dSql2 += '           ,EQUIPMENT_ID                    ' + char(10)
                                SELECT @v_dSql2 += '           ,PLAN_DATE                       ' + char(10)
                                SELECT @v_dSql2 += '           ,TOP_ITEM_ID                     ' + char(10)
                                SELECT @v_dSql2 += '           ,ITEM_ID                         ' + char(10)
                                SELECT @v_dSql2 += '           ,PRODUCTION_TYPE                 ' + char(10)
                                SELECT @v_dSql2 += '           ,MARKET                          ' + char(10)
                                SELECT @v_dSql2 += '           ,SEQ                             ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_IN_QTY_BATCH             ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_IN_QTY                   ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_IN_QTY_KG                ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_OUT_QTY_BATCH            ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_OUT_QTY                  ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_OUT_QTY_KG               ' + char(10)
                                SELECT @v_dSql2 += '           ,INSERT_ID, INSERT_TIME          ' + char(10)
                                SELECT @v_dSql2 += '           ,UPDATE_ID, UPDATE_TIME          ' + char(10)
                                SELECT @v_dSql2 += '           ,JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += '     )                              ' + char(10)
                                SELECT @v_dSql2 += '     SELECT INSTANCE_ID, FP_PLAN_ID ' + char(10)
                                SELECT @v_dSql2 += '           ,COMPANY_ID              ' + char(10)
                                SELECT @v_dSql2 += '           ,DIVISION_ID             ' + char(10)
                                SELECT @v_dSql2 += '           ,SITE_ID                 ' + char(10)
                                SELECT @v_dSql2 += '           ,PLANT_ID                ' + char(10)
                                SELECT @v_dSql2 += '           ,FACTORY_ID              ' + char(10)
                                SELECT @v_dSql2 += '           ,LOCATION                ' + char(10)
                                SELECT @v_dSql2 += '           ,OPERATION_ID            ' + char(10)
                                SELECT @v_dSql2 += '           ,LINE_ID                 ' + char(10)
                                SELECT @v_dSql2 += '           ,ELECTRODE_TYPE          ' + char(10)
                                SELECT @v_dSql2 += '           ,EQUIPMENT_ID            ' + char(10)
                                SELECT @v_dSql2 += '           ,PLAN_DATE               ' + char(10)
                                SELECT @v_dSql2 += '           ,TOP_ITEM_ID             ' + char(10)
                                SELECT @v_dSql2 += '           ,ITEM_ID                 ' + char(10)
                                SELECT @v_dSql2 += '           ,PRODUCTION_TYPE         ' + char(10)
                                SELECT @v_dSql2 += '           ,MARKET                  ' + char(10)
                                SELECT @v_dSql2 += '           ,SEQ                     ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_IN_QTY_BATCH     ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_IN_QTY           ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_IN_QTY_KG        ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_OUT_QTY_BATCH    ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_OUT_QTY          ' + char(10)
                                SELECT @v_dSql2 += '           ,ADJUST_OUT_QTY_KG       ' + char(10)
                                SELECT @v_dSql2 += '           ,INSERT_ID, INSERT_TIME  ' + char(10)
                                SELECT @v_dSql2 += '           ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql2 += '           ,'''+ @v_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''UPDATE'' AS JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += '     FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)             ' + char(10)
                                SELECT @v_dSql2 += '     WHERE  A.INSTANCE_ID      = '''+ @v_instance_id +'''    ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.FP_PLAN_ID       = '''+ @v_plan_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.FACTORY_ID       = '''+ @v_factory_id +'''     ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.LOCATION         = '''+ @v_location +'''       ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.OPERATION_ID     = '''+ @v_operation_id +'''   ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.LINE_ID          = '''+ @v_line_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.ELECTRODE_TYPE   = '''+ @v_electrode_type +''' ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.EQUIPMENT_ID     = '''+ @v_equipment_id +'''   ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.PLAN_DATE        = CONVERT(DATETIME,'''+ @v_plan_date +''') ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.TOP_ITEM_ID      = '''+ @v_item_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.ITEM_ID          = '''+ @v_item_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.PRODUCTION_TYPE  = '''+ @v_prod_type +'''      ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.MARKET           = '''+ @v_market +''' ;       ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						    END --'I'
					   /******************************************************************************/
					   /* BOH 경우 : (merge_boh)                                           */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='MERGE_BOH')  
							BEGIN
                                SELECT @v_dSql = ''
								SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += ' MERGE INTO FP_AMEND_CUTOFF_BOH_R A ' + char(10)
                                SELECT @v_dSql1 += ' USING (SELECT '''+ @v_instance_id +''' AS INSTANCE_ID, '''+ @v_plan_id +''' AS FP_PLAN_ID, ' + char(10)
                                SELECT @v_dSql1 += '               '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID, '''+ @v_plant_id +''' AS PLANT_ID, ' + char(10)
                                SELECT @v_dSql1 += '               '''+ @v_item_id +''' AS ITEM_ID, '''+ @v_top_item_id +''' AS TOP_ITEM_ID, '''+ @v_operation_id +''' AS OPERATION_ID, '''+ @v_factory_id +''' AS FACTORY_ID, '''+ @v_location +''' AS LOCATION) B ' + char(10)
                                SELECT @v_dSql1 += ' ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID                       ' + char(10)
                                SELECT @v_dSql1 += '     AND A.DIVISION_ID = B.DIVISION_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID ' + char(10)
                                SELECT @v_dSql1 += '     AND A.ITEM_ID = B.ITEM_ID AND A.TOP_ITEM_ID = B.TOP_ITEM_ID AND A.OPERATION_ID = B.OPERATION_ID AND A.FACTORY_ID = B.FACTORY_ID AND A.LOCATION = B.LOCATION) ' + char(10)
                                SELECT @v_dSql1 += ' WHEN MATCHED THEN                           ' + char(10)
                                SELECT @v_dSql1 += '   UPDATE SET MODIFY_QTY = '''+ @v_qty +''', ' + char(10)
                                SELECT @v_dSql1 += '              UPDATE_ID  = '''+ @v_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') '+ char(10)
                                SELECT @v_dSql1 += ' WHEN NOT MATCHED THEN               ' + char(10)
                                SELECT @v_dSql1 += '   INSERT (                          ' + char(10)
                                SELECT @v_dSql1 += '      INSTANCE_ID, FP_PLAN_ID        ' + char(10)
                                SELECT @v_dSql1 += '     ,COMPANY_ID                     ' + char(10)
                                SELECT @v_dSql1 += '     ,DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
                                SELECT @v_dSql1 += '     ,ITEM_ID                ' + char(10)
                                SELECT @v_dSql1 += '     ,OPERATION_ID           ' + char(10)
                                SELECT @v_dSql1 += '     ,FACTORY_ID             ' + char(10)
                                SELECT @v_dSql1 += '     ,LOCATION               ' + char(10)
                                SELECT @v_dSql1 += '     ,QTY, MODIFY_QTY        ' + char(10)
                                SELECT @v_dSql1 += '     ,INSERT_ID, INSERT_TIME ' + char(10)
                                SELECT @v_dSql1 += '     ,UPDATE_ID, UPDATE_TIME ' + char(10)
                                SELECT @v_dSql1 += '     ,TOP_ITEM_ID            ' + char(10)
                                SELECT @v_dSql1 += '   )                         ' + char(10)
                                SELECT @v_dSql1 += '   VALUES (                  ' + char(10)
                                SELECT @v_dSql1 += '      '''+ @v_instance_id +''', '''+ @v_plan_id +''' '+ char(10)
                                SELECT @v_dSql1 += '     ,(SELECT MAX(COMPANY_ID) FROM SCM_FACTORY_M WHERE DIVISION_ID =  '''+ @v_division_id +''' AND SITE_ID = '''+ @v_site_id +''' AND PLANT_ID = '''+ @v_plant_id +''' AND ACTIVE_FLAG = ''Y'') '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_division_id +''', '''+ @v_site_id +''', '''+ @v_plant_id +''' '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_item_id +'''                '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_operation_id +'''           '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_factory_id +'''             '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_location +'''               '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_qty +''', '''+ @v_qty +'''  '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') '+ char(10)
                                SELECT @v_dSql1 += '     ,'''+ @v_top_item_id +''' '+ char(10)
                                SELECT @v_dSql1 += '   )                           '+ char(10)
                                SELECT @v_dSql1 += ' ;                             '+ char(10)
                                SELECT @v_dSql1 += ' MERGE SCM_STOCK_H AS T1       '+ char(10)
                                SELECT @v_dSql1 += ' USING (                       '+ char(10)
                                SELECT @v_dSql1 += '     SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.MODIFY_QTY '+ char(10)
                                SELECT @v_dSql1 += '            , ISNULL(B.SEQ, ISNULL(C.MAX_SEQ,0) + 1) AS SEQ '+ char(10)
                                SELECT @v_dSql1 += '     FROM   (                                               '+ char(10)
                                SELECT @v_dSql1 += '               SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, MODIFY_QTY, ELECTRODE_TYPE '+ char(10)
                                SELECT @v_dSql1 += '               FROM  FP_AMEND_CUTOFF_BOH_R                    '+ char(10)
                                SELECT @v_dSql1 += '               WHERE INSTANCE_ID  = '''+ @v_instance_id +'''  '+ char(10)
                                SELECT @v_dSql1 += '               AND   FP_PLAN_ID   = '''+ @v_plan_id +'''      '+ char(10)
                                SELECT @v_dSql1 += '               AND   DIVISION_ID  = '''+ @v_division_id +'''  '+ char(10)
                                SELECT @v_dSql1 += '               AND   SITE_ID      = '''+ @v_site_id +'''      '+ char(10)
                                SELECT @v_dSql1 += '               AND   PLANT_ID     = '''+ @v_plant_id +'''     '+ char(10)
                                SELECT @v_dSql1 += '               AND   ITEM_ID      = '''+ @v_item_id +'''      '+ char(10)
                                SELECT @v_dSql1 += '               AND   OPERATION_ID = '''+ @v_operation_id +''' '+ char(10)
                                SELECT @v_dSql1 += '               AND   FACTORY_ID   = '''+ @v_factory_id +'''   '+ char(10)
                                SELECT @v_dSql1 += '               AND   LOCATION     = '''+ @v_location +'''     '+ char(10)
                                SELECT @v_dSql1 += '               AND   TOP_ITEM_ID  = '''+ @v_top_item_id +'''  '+ char(10)
                                SELECT @v_dSql1 += '            ) A               '+ char(10)
                                SELECT @v_dSql1 += '            LEFT OUTER JOIN ( '+ char(10)
                                SELECT @v_dSql1 += '               SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID, '+ char(10)
                                SELECT @v_dSql1 += '                      A.ITEM_ID, A.OPERATION_ID, '+ char(10)
                                SELECT @v_dSql1 += '                      A.FACTORY_ID, '+ char(10)
                                SELECT @v_dSql1 += '                      A.LOCATION,   '+ char(10)
                                SELECT @v_dSql1 += '                      A.SEQ,        '+ char(10)
                                SELECT @v_dSql1 += '                      A.MIN_SEQ     '+ char(10)
                                SELECT @v_dSql1 += '               FROM   (             '+ char(10)
                                SELECT @v_dSql1 += '                         SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID, '+ char(10)
                                SELECT @v_dSql1 += '                                FP_APPLY_ITEM_ID AS ITEM_ID, ISNULL(FP_APPLY_OPERATION_ID, ''-'') OPERATION_ID, '+ char(10)
                                SELECT @v_dSql1 += '                                FACTORY_ID,                          '+ char(10)
                                SELECT @v_dSql1 += '                                CUTOFF_DATE,                         '+ char(10)
                                SELECT @v_dSql1 += '                                ISNULL(LOCATION, ''-'') AS LOCATION, '+ char(10)
                                SELECT @v_dSql1 += '                                SEQ,                                 '+ char(10)
                                SELECT @v_dSql1 += '                                MIN(SEQ) OVER( PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FP_APPLY_ITEM_ID, ISNULL(FP_APPLY_OPERATION_ID, ''-''), FACTORY_ID, ISNULL(LOCATION, ''-'') ORDER BY CUTOFF_DATE DESC, SEQ ) AS MIN_SEQ '+ char(10)
                                SELECT @v_dSql1 += '                         FROM   SCM_STOCK_H_V                          '+ char(10)
                                SELECT @v_dSql1 += '                         WHERE  CONVERT(VARCHAR,CUTOFF_DATE,112) = '''+ @v_plan_date +''' '+ char(10)
                                SELECT @v_dSql1 += '                         AND    STOCK_TYPE = ''WIP'' '+ char(10)
                                SELECT @v_dSql1 += '                      ) A                            '+ char(10)
                                SELECT @v_dSql1 += '               WHERE A.SEQ = A.MIN_SEQ               '+ char(10)
                                SELECT @v_dSql1 += '           ) B                                       '+ char(10)
                                SELECT @v_dSql1 += '           ON     A.COMPANY_ID    = B.COMPANY_ID     '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.DIVISION_ID   = B.DIVISION_ID    '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.SITE_ID       = B.SITE_ID        '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.PLANT_ID      = B.PLANT_ID       '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.ITEM_ID       = B.ITEM_ID        '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.OPERATION_ID  = B.OPERATION_ID   '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.FACTORY_ID    = B.FACTORY_ID     '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.LOCATION      = B.LOCATION       '+ char(10)
                                SELECT @v_dSql1 += '           LEFT OUTER JOIN (                         '+ char(10)
                                SELECT @v_dSql1 += '                             SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID        '+ char(10)
                                SELECT @v_dSql1 += '                                  , MAX(SEQ) AS MAX_SEQ                                       '+ char(10)
                                SELECT @v_dSql1 += '                             FROM   SCM_STOCK_H_V                                               '+ char(10)
                                SELECT @v_dSql1 += '                             WHERE  CONVERT(VARCHAR,CUTOFF_DATE,112) = '''+ @v_plan_date +''' '+ char(10)
                                SELECT @v_dSql1 += '                             GROUP  BY COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID     '+ char(10)
                                SELECT @v_dSql1 += '                           ) C                     '+ char(10)
                                SELECT @v_dSql1 += '           ON     A.COMPANY_ID    = C.COMPANY_ID   '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.DIVISION_ID   = C.DIVISION_ID  '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.SITE_ID       = C.SITE_ID      '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.PLANT_ID      = C.PLANT_ID     '+ char(10)
                                SELECT @v_dSql1 += '           AND    A.FACTORY_ID    = C.FACTORY_ID   '+ char(10)
                                SELECT @v_dSql1 += ' ) AS T2                                           '+ char(10)
                                SELECT @v_dSql1 += ' ON (     T1.COMPANY_ID           = T2.COMPANY_ID  '+ char(10)
                                SELECT @v_dSql1 += '      AND T1.DIVISION_ID          = T2.DIVISION_ID '+ char(10)
                                SELECT @v_dSql1 += '      AND T1.SITE_ID              = T2.SITE_ID     '+ char(10)
                                SELECT @v_dSql1 += '      AND T1.PLANT_ID             = T2.PLANT_ID    '+ char(10)
                                SELECT @v_dSql1 += '      AND T1.FP_APPLY_ITEM_ID     = T2.ITEM_ID     '+ char(10)
                                SELECT @v_dSql1 += '      AND ISNULL(T1.FP_APPLY_OPERATION_ID, ''-'') = T2.OPERATION_ID '+ char(10)
                                SELECT @v_dSql1 += '      AND T1.FACTORY_ID           = T2.FACTORY_ID '+ char(10)
                                SELECT @v_dSql1 += '      AND ISNULL(T1.LOCATION,''-'') = T2.LOCATION '+ char(10)
                                SELECT @v_dSql1 += '      AND T1.SEQ                  = T2.SEQ )      '+ char(10)
                                SELECT @v_dSql1 += ' WHEN MATCHED THEN                                '+ char(10)
                                SELECT @v_dSql1 += '    UPDATE SET T1.MODIFY_FP_APPLY_WIPQTY = T2.MODIFY_QTY,              '+ char(10)
                                SELECT @v_dSql1 += '               T1.FP_APPLY_WIPQTY = ISNULL(T1.FP_APPLY_WIPQTY,0),      '+ char(10)
                                SELECT @v_dSql1 += '               T1.UPDATE_ID   = '''+ @v_user_id +''',                  '+ char(10)
                                SELECT @v_dSql1 += '               T1.UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') '+ char(10)
                                SELECT @v_dSql1 += ' WHEN NOT MATCHED THEN                                                 '+ char(10)
                                SELECT @v_dSql1 += '    INSERT( COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,STORAGE_ID,CUTOFF_DATE,SEQ, '+ char(10)
                                SELECT @v_dSql1 += '            STOCK_TYPE, ITEM_ID, AVAILABLE_DATE, QTY, OPERATION_ID, FP_APPLY_OPERATION_ID, WIPHOLD_YN, MODIFY_FP_APPLY_WIPQTY, LOCATION, FP_APPLY_ITEM_ID, FP_APPLY_WIPQTY, '+ char(10)
                                SELECT @v_dSql1 += '            INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME '+ char(10)
                                SELECT @v_dSql1 += '    ) '+ char(10)
                                SELECT @v_dSql1 += '    VALUES( T2.COMPANY_ID,T2.DIVISION_ID,T2.SITE_ID,T2.PLANT_ID,T2.FACTORY_ID,''-'', CONVERT(DATE, '''+ @v_plan_date +'''), T2.SEQ, '+ char(10)
                                SELECT @v_dSql1 += '            ''WIP'', T2.ITEM_ID, CONVERT(DATETIME, '''+ @v_plan_date +'''), T2.MODIFY_QTY, T2.OPERATION_ID, T2.OPERATION_ID, ''N'', T2.MODIFY_QTY, T2.LOCATION, T2.ITEM_ID, 0, '+ char(10)
                                SELECT @v_dSql1 += '            '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') '+ char(10)
                                SELECT @v_dSql1 += '    ) '+ char(10)
                                SELECT @v_dSql1 += ' ;    '+ char(10)
          

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

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

