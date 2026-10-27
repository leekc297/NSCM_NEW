


/*
 * Program ID   : [PR_UI_FP02842_AMEND_SAVE]
 * Description  : Amend Post
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/03/24   LJS				Initial Release UI통합
 */

CREATE 
--ALTER
PROCEDURE [dbo].[PR_UI_FP02842_AMEND_SAVE]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),

  @p_instance_id                NVARCHAR(MAX),
  @p_plan_id                    NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_factory_id                 NVARCHAR(MAX),
  @p_item_id                    NVARCHAR(MAX),
  @p_line_id                    NVARCHAR(MAX),
  @p_operation_id               NVARCHAR(MAX),
  @p_electrode_type             NVARCHAR(MAX),
  @p_equipment_id               NVARCHAR(MAX),
  @p_plan_date                  NVARCHAR(MAX),
  @p_shift		                NVARCHAR(MAX),
  @p_jr_out_qty					NVARCHAR(MAX),
  @p_pc_out_qty					NVARCHAR(MAX),
  @p_prod_type                  NVARCHAR(MAX)

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
    DECLARE @v_plan_id                    NVARCHAR(MAX)
    DECLARE @v_company_id                 NVARCHAR(MAX)
    DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_factory_id                 NVARCHAR(MAX)
	DECLARE @v_item_id                    NVARCHAR(MAX)
	DECLARE @v_line_id                    NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_electrode_type             NVARCHAR(MAX)
    DECLARE @v_equipment_id               NVARCHAR(MAX)
	DECLARE @v_plan_date                  NVARCHAR(MAX)
	DECLARE @v_shift                      NVARCHAR(MAX)
	DECLARE @v_jr_out_qty				  NVARCHAR(MAX)
	DECLARE @v_pc_out_qty				  NVARCHAR(MAX)
	DECLARE @v_prod_type                  NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP02842_AMEND_SAVE'
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
    SET @v_plan_id                  = ''
    SET @v_company_id               = ''
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
	SET @v_item_id                  = ''
	SET @v_line_id                  = ''
    SET @v_operation_id             = ''
    SET @v_electrode_type           = ''
    SET @v_equipment_id             = ''
	SET @v_plan_date                = ''
	SET @v_shift                    = ''
	SET @v_jr_out_qty				= ''
	SET @v_pc_out_qty				= ''
	SET @v_prod_type                = ''

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

					SELECT @v_sys_type				   = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,             @v_delimiter,  @mst_loop_cnt)
						 , @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,             @v_delimiter,  @mst_loop_cnt)
						 , @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,            @v_delimiter,  @mst_loop_cnt)
						 , @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,              @v_delimiter,  @mst_loop_cnt)
                         , @v_instance_id              = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id ,          @v_delimiter,  @mst_loop_cnt)
                         , @v_plan_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,              @v_delimiter,  @mst_loop_cnt)
                         , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,           @v_delimiter,  @mst_loop_cnt)
                         , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id ,          @v_delimiter,  @mst_loop_cnt)
                         , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,              @v_delimiter,  @mst_loop_cnt)
                         , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,             @v_delimiter,  @mst_loop_cnt)
						 , @v_factory_id               = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,           @v_delimiter,  @mst_loop_cnt)
                         , @v_item_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,              @v_delimiter,  @mst_loop_cnt)
						 , @v_line_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,              @v_delimiter,  @mst_loop_cnt)
						 , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,         @v_delimiter,  @mst_loop_cnt)
						 , @v_electrode_type           = [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type ,       @v_delimiter,  @mst_loop_cnt)    
						 , @v_equipment_id             = [dbo].[SCM_ARR_SPL_VAL](@p_equipment_id ,         @v_delimiter,  @mst_loop_cnt) 
						 , @v_plan_date                = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,            @v_delimiter,  @mst_loop_cnt)
						 , @v_shift					   = [dbo].[SCM_ARR_SPL_VAL](@p_shift ,		           @v_delimiter,  @mst_loop_cnt)
						 , @v_jr_out_qty       		   = [dbo].[SCM_ARR_SPL_VAL](@p_jr_out_qty ,           @v_delimiter,  @mst_loop_cnt)
						 , @v_pc_out_qty 			   = [dbo].[SCM_ARR_SPL_VAL](@p_pc_out_qty ,		   @v_delimiter,  @mst_loop_cnt)
						 , @v_prod_type                = [dbo].[SCM_ARR_SPL_VAL](@p_prod_type ,            @v_delimiter,  @mst_loop_cnt)


					/******************************************************************************/
					/* MERGE_DATA 경우 : (saveAll_data)                                           */
					/******************************************************************************/
					IF(@v_sys_flag ='MERGE_DATA')  
					BEGIN
                                SELECT @v_dSql = ''
								SELECT @v_dSql1 = ''
								
                                SELECT @v_dSql1 += ' MERGE INTO FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A ' + char(10)
                                SELECT @v_dSql1 += ' USING (SELECT UPPER('''+ @v_instance_id +''') AS INSTANCE_ID, UPPER('''+ @v_plan_id +''') AS FP_PLAN_ID, ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_division_id +''') AS DIVISION_ID, UPPER('''+ @v_site_id +''') AS SITE_ID,UPPER('''+ @v_plant_id +''') AS PLANT_ID, UPPER('''+ @v_factory_id +''') AS FACTORY_ID,  ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_operation_id +''') AS OPERATION_ID, UPPER('''+ @v_line_id +''') AS LINE_ID, '''+ @v_electrode_type +''' AS ELECTRODE_TYPE, ' + char(10)
                                SELECT @v_dSql1 += '               '''+ @v_plan_date +''' AS PLAN_DATE, ''' + @v_shift + ''' AS SHIFT, ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_item_id +''') AS ITEM_ID,         ' + char(10)
                                SELECT @v_dSql1 += '               UPPER('''+ @v_prod_type +''') AS PRODUCTION_TYPE ) B   ' + char(10)
                                SELECT @v_dSql1 += ' ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID                                     ' + char(10)
                                SELECT @v_dSql1 += '     AND A.FACTORY_ID = B.FACTORY_ID                                          ' + char(10)
                                SELECT @v_dSql1 += '     AND A.OPERATION_ID = B.OPERATION_ID AND A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
                                SELECT @v_dSql1 += '     AND A.PLAN_DATE = CONVERT(DATETIME, B.PLAN_DATE) AND A.SHIFT = B.SHIFT ' + char(10)
                                SELECT @v_dSql1 += '     AND A.ITEM_ID = B.ITEM_ID AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql1 += ' ) ' + char(10)
                                SELECT @v_dSql1 += ' WHEN MATCHED THEN ' + char(10)
                                SELECT @v_dSql1 += '   UPDATE SET ' + char(10)
								SELECT @v_dSql1 += '              PC_IN_QTY  = CEILING(convert(numeric,'''+ @v_pc_out_qty +''') / (SELECT ISNULL(MAX(CASE WHEN A.YIELD = 0 THEN 1 ELSE A.YIELD END), 1) AS YIELD ' + char(10)
								SELECT @v_dSql1 += '            		                                                           FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
								SELECT @v_dSql1 += '            		                                                           WHERE  A.DIVISION_ID = ''' + @v_division_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.SITE_ID = ''' + @v_site_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.PLANT_ID = ''' + @v_plant_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.FACTORY_ID = ''' + @v_factory_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.OPERATION_ID = ''' + @v_operation_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.LINE_ID = ''' + @v_line_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.ITEM_ID = ''' + @v_item_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.MONTH = SUBSTRING(''' + @v_plan_date + ''', 1, 6) ) ) ' + char(10)
                                SELECT @v_dSql1 += '            , PC_OUT_QTY  = CEILING(convert(numeric,'''+ @v_pc_out_qty +''')) ' + char(10)
								SELECT @v_dSql1 += '            , JR_IN_QTY  = CEILING(convert(numeric,'''+ @v_jr_out_qty +''') / (SELECT ISNULL(MAX(CASE WHEN A.YIELD = 0 THEN 1 ELSE A.YIELD END), 1) AS YIELD ' + char(10)
								SELECT @v_dSql1 += '            		                                                           FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
								SELECT @v_dSql1 += '            		                                                           WHERE  A.DIVISION_ID = ''' + @v_division_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.SITE_ID = ''' + @v_site_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.PLANT_ID = ''' + @v_plant_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.FACTORY_ID = ''' + @v_factory_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.OPERATION_ID = ''' + @v_operation_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.LINE_ID = ''' + @v_line_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.ITEM_ID = ''' + @v_item_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            		                                                           AND    A.MONTH = SUBSTRING(''' + @v_plan_date + ''', 1, 6) ) ) ' + char(10)
                                SELECT @v_dSql1 += '            , JR_OUT_QTY  = convert(numeric,'''+ @v_jr_out_qty +''') ' + char(10)
                                SELECT @v_dSql1 += '            , UPDATE_ID = '''+ @v_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql1 += ' WHEN NOT MATCHED THEN                                  ' + char(10)
                                SELECT @v_dSql1 += '     INSERT (                                           ' + char(10)
                                SELECT @v_dSql1 += '        INSTANCE_ID, FP_PLAN_ID                         ' + char(10)
                                SELECT @v_dSql1 += '       ,COMPANY_ID                                      ' + char(10)
                                SELECT @v_dSql1 += '       ,DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID      ' + char(10)
								SELECT @v_dSql1 += '       ,WORK_ORDER_SPL_ID						' + char(10)
								SELECT @v_dSql1 += '       ,WORK_ORDER_ID							' + char(10)
								SELECT @v_dSql1 += '       ,DEMAND_ID								' + char(10)
                                SELECT @v_dSql1 += '       ,OPERATION_ID, LINE_ID, ELECTRODE_TYPE	' + char(10)
                                SELECT @v_dSql1 += '       ,EQUIPMENT_ID, PLAN_DATE, SHIFT			' + char(10)
								SELECT @v_dSql1 += '       ,START_TIME, END_TIME			' + char(10)
                                SELECT @v_dSql1 += '       ,ITEM_ID									' + char(10)
                                SELECT @v_dSql1 += '       ,PRODUCTION_TYPE							' + char(10)
                                SELECT @v_dSql1 += '       ,PC_IN_QTY					  ' + char(10)
                                SELECT @v_dSql1 += '       ,PC_OUT_QTY					  ' + char(10)
								SELECT @v_dSql1 += '       ,JR_IN_QTY                    ' + char(10)
                                SELECT @v_dSql1 += '       ,JR_OUT_QTY                    ' + char(10)
                                SELECT @v_dSql1 += '       ,INSERT_ID, INSERT_TIME               ' + char(10)
                                SELECT @v_dSql1 += '       ,UPDATE_ID, UPDATE_TIME               ' + char(10)
                                SELECT @v_dSql1 += '     )                                       ' + char(10)
                                SELECT @v_dSql1 += '     VALUES (                                ' + char(10)
                                SELECT @v_dSql1 += '        UPPER('''+ @v_instance_id +'''), UPPER('''+ @v_plan_id +''') ' + char(10)
                                SELECT @v_dSql1 += '       ,(SELECT MAX(COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = '''+ @v_factory_id +''' AND ACTIVE_FLAG = ''Y'') ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_division_id +'''), UPPER('''+ @v_site_id +'''), ('''+ @v_plant_id +'''), UPPER('''+ @v_factory_id +''')         ' + char(10)
								SELECT @v_dSql1 += '       ,''-'' ,''-'' ,''-'' ' + char(10) -- WORK_ORDER_SPL_ID, WORK_ORDER_ID, DEMAND_ID
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_operation_id +'''), UPPER('''+ @v_line_id +'''), '''+ @v_electrode_type +'''     ' + char(10)

								SELECT @v_dSql1 += '       ,''' + @v_line_id + ''' + ''_'' + ''' + @v_operation_id + ''' + (CASE ''' + @v_electrode_type + ''' WHEN NULL THEN '''' WHEN '''' THEN '''' WHEN ''-'' THEN '''' ELSE ''_'' + ''' + @v_electrode_type + ''' END) ,CONVERT(DATETIME,'''+ @v_plan_date +'''), upper(''' + @v_shift + ''') ' + char(10)

								SELECT @v_dSql1 += '       ,CONVERT(DATETIME,''' + @v_plan_date + '''),  CONVERT(DATETIME,''' + @v_plan_date + ''') -- start, end time ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_item_id +''')                   ' + char(10)
                                SELECT @v_dSql1 += '       ,UPPER('''+ @v_prod_type +''')                  ' + char(10)
								SELECT @v_dSql1 += '       , CEILING(convert(numeric,'''+ @v_pc_out_qty +''') / (SELECT ISNULL(MAX(CASE WHEN A.YIELD = 0 THEN 1 ELSE A.YIELD END), 1) AS YIELD ' + char(10)
								SELECT @v_dSql1 += '            	                                             FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
								SELECT @v_dSql1 += '            	                                             WHERE  A.DIVISION_ID = ''' + @v_division_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.SITE_ID = ''' + @v_site_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.PLANT_ID = ''' + @v_plant_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.FACTORY_ID = ''' + @v_factory_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.OPERATION_ID = ''' + @v_operation_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.LINE_ID = ''' + @v_line_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.ITEM_ID = ''' + @v_item_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.MONTH = SUBSTRING(''' + @v_plan_date + ''', 1, 6) ) ) ' + char(10) -- PC_IN_QTY
                                SELECT @v_dSql1 += '       , CEILING(convert(numeric,'''+ @v_pc_out_qty +''')) ' + char(10) -- PC_OUT_QTY
								SELECT @v_dSql1 += '       , CEILING(convert(numeric,'''+ @v_jr_out_qty +''') / (SELECT ISNULL(MAX(CASE WHEN A.YIELD = 0 THEN 1 ELSE A.YIELD END), 1) AS YIELD ' + char(10)
								SELECT @v_dSql1 += '            	                                             FROM   SCM_YIELD_M A WITH(NOLOCK) ' + char(10)
								SELECT @v_dSql1 += '            	                                             WHERE  A.DIVISION_ID = ''' + @v_division_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.SITE_ID = ''' + @v_site_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.PLANT_ID = ''' + @v_plant_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.FACTORY_ID = ''' + @v_factory_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.OPERATION_ID = ''' + @v_operation_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.LINE_ID = ''' + @v_line_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.ITEM_ID = ''' + @v_item_id + ''' ' + char(10)
								SELECT @v_dSql1 += '            	                                             AND    A.MONTH = SUBSTRING(''' + @v_plan_date + ''', 1, 6) ) ) ' + char(10) -- JR_IN_QTY
                                SELECT @v_dSql1 += '       , convert(numeric,'''+ @v_jr_out_qty +''') ' + char(10) -- JR_OUT_QTY
                                SELECT @v_dSql1 += '       ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''')   ' + char(10)
                                SELECT @v_dSql1 += '       ,'''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''')   ' + char(10)
                                SELECT @v_dSql1 += '     );                                     ' + char(10)
                                
								SELECT @v_dSql2 = '' + char(10)
                                SELECT @v_dSql2 += '     INSERT INTO HIS_PRODUCTION_PLAN_EQUIPMENT_EPOST_R (   ' + char(10)
                                SELECT @v_dSql2 += '            INSTANCE_ID, FP_PLAN_ID         ' + char(10)
                                SELECT @v_dSql2 += '           ,COMPANY_ID                      ' + char(10)
                                SELECT @v_dSql2 += '           ,DIVISION_ID                     ' + char(10)
                                SELECT @v_dSql2 += '           ,SITE_ID                         ' + char(10)
                                SELECT @v_dSql2 += '           ,PLANT_ID                        ' + char(10)
                                SELECT @v_dSql2 += '           ,FACTORY_ID                      ' + char(10)
								SELECT @v_dSql2 += '           ,WORK_ORDER_SPL_ID, WORK_ORDER_ID, DEMAND_ID ' + char(10)
                                SELECT @v_dSql2 += '           ,OPERATION_ID                    ' + char(10)
                                SELECT @v_dSql2 += '           ,LINE_ID                         ' + char(10)
                                SELECT @v_dSql2 += '           ,ELECTRODE_TYPE                  ' + char(10)
                                SELECT @v_dSql2 += '           ,EQUIPMENT_ID                    ' + char(10)
                                SELECT @v_dSql2 += '           ,PLAN_DATE                       ' + char(10)
								SELECT @v_dSql2 += '           ,SHIFT                           ' + char(10)
								SELECT @v_dSql2 += '           ,START_TIME, END_TIME            ' + char(10)
                                SELECT @v_dSql2 += '           ,ITEM_ID                         ' + char(10)
                                SELECT @v_dSql2 += '           ,PRODUCTION_TYPE                 ' + char(10)
                                SELECT @v_dSql2 += '           ,PC_IN_QTY						' + char(10)
                                SELECT @v_dSql2 += '           ,PC_OUT_QTY						' + char(10)
                                SELECT @v_dSql2 += '           ,JR_IN_QTY						' + char(10)
                                SELECT @v_dSql2 += '           ,JR_OUT_QTY						' + char(10)
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
								SELECT @v_dSql2 += '           ,WORK_ORDER_SPL_ID, WORK_ORDER_ID, DEMAND_ID ' + char(10)
                                SELECT @v_dSql2 += '           ,OPERATION_ID            ' + char(10)
                                SELECT @v_dSql2 += '           ,LINE_ID                 ' + char(10)
                                SELECT @v_dSql2 += '           ,ELECTRODE_TYPE          ' + char(10)
                                SELECT @v_dSql2 += '           ,EQUIPMENT_ID            ' + char(10)
                                SELECT @v_dSql2 += '           ,PLAN_DATE               ' + char(10)
								SELECT @v_dSql2 += '           ,SHIFT                   ' + char(10)
								SELECT @v_dSql2 += '           ,START_TIME, END_TIME    ' + char(10)
                                SELECT @v_dSql2 += '           ,ITEM_ID                 ' + char(10)
                                SELECT @v_dSql2 += '           ,PRODUCTION_TYPE         ' + char(10)
                                SELECT @v_dSql2 += '           ,PC_IN_QTY				' + char(10)
                                SELECT @v_dSql2 += '           ,PC_OUT_QTY				' + char(10)
                                SELECT @v_dSql2 += '           ,JR_IN_QTY				' + char(10)
                                SELECT @v_dSql2 += '           ,JR_OUT_QTY				' + char(10)
                                SELECT @v_dSql2 += '           ,INSERT_ID, INSERT_TIME  ' + char(10)
                                SELECT @v_dSql2 += '           ,UPDATE_ID, UPDATE_TIME  ' + char(10)
                                SELECT @v_dSql2 += '           ,'''+ @v_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''MERGE'' AS JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += '     FROM   FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A WITH(NOLOCK)             ' + char(10)
                                SELECT @v_dSql2 += '     WHERE  A.INSTANCE_ID      = '''+ @v_instance_id +'''    ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.FP_PLAN_ID       = '''+ @v_plan_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.FACTORY_ID       = '''+ @v_factory_id +'''     ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.OPERATION_ID     = '''+ @v_operation_id +'''   ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.LINE_ID          = '''+ @v_line_id +'''        ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.ELECTRODE_TYPE   = '''+ @v_electrode_type +''' ' + char(10)
                                --SELECT @v_dSql2 += '     AND    A.EQUIPMENT_ID     = '''+ @v_equipment_id +'''   ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.PLAN_DATE        = CONVERT(DATETIME,'''+ @v_plan_date +''') ' + char(10)
                                SELECT @v_dSql2 += '     AND    A.ITEM_ID          = '''+ @v_item_id +'''        ' + char(10)
								SELECT @v_dSql2 += '     AND    A.SHIFT            = '''+ @v_shift +'''			 ' + char(10)

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


