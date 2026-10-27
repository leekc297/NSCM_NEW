

/*
 * Program ID   :PR_UI_FP00596_ADD_LINE
 * Description  : Plan Amend Line Formation
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/12/27   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00596_ADD_LINE]
  @p_sys_type            NVARCHAR(MAX),
  @p_sys_flag            NVARCHAR(MAX),
  @p_sys_gubun           NVARCHAR(MAX),
  @p_user_id             NVARCHAR(MAX),
  @p_instance_id         NVARCHAR(MAX),
  @p_plan_date           NVARCHAR(MAX),
  @p_plan_id             NVARCHAR(MAX), 
  @p_division_id         NVARCHAR(MAX),
  @p_site_id             NVARCHAR(MAX),
  @p_plant_id            NVARCHAR(MAX),
  @p_factory_id          NVARCHAR(MAX),
  @p_operation_id        NVARCHAR(MAX),
  @p_line_id             NVARCHAR(MAX),
  @p_top_item_id         NVARCHAR(MAX),
  @p_item_id             NVARCHAR(MAX),
  @p_item_type           NVARCHAR(MAX),
  @p_nick_name           NVARCHAR(MAX),
  @p_electrode_type      NVARCHAR(MAX),
  @p_prod_type           NVARCHAR(MAX),
  @p_location            NVARCHAR(MAX),
  @p_equipment_id        NVARCHAR(MAX),
  @p_market              NVARCHAR(MAX),
  @p_qty                 NVARCHAR(MAX),
  @p_adjust_in_qty_batch NVARCHAR(MAX),
  @p_adjust_in_qty_kg    NVARCHAR(MAX),
  @p_adjust_out_qty_batch  NVARCHAR(MAX),
  @p_adjust_out_qty_kg     NVARCHAR(MAX)
AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type              NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag              NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun             NVARCHAR(MAX) 
	DECLARE @v_user_id               NVARCHAR(MAX)
    DECLARE @v_instance_id           NVARCHAR(MAX)
    DECLARE @v_plan_date             NVARCHAR(MAX)
    DECLARE @v_plan_id               NVARCHAR(MAX) 
    DECLARE @v_division_id           NVARCHAR(MAX)
    DECLARE @v_site_id               NVARCHAR(MAX)
    DECLARE @v_plant_id              NVARCHAR(MAX)
    DECLARE @v_factory_id            NVARCHAR(MAX)
    DECLARE @v_line_id               NVARCHAR(MAX)
    DECLARE @v_operation_id          NVARCHAR(MAX)
    DECLARE @v_top_item_id           NVARCHAR(MAX)
    DECLARE @v_item_id               NVARCHAR(MAX)
    DECLARE @v_item_type             NVARCHAR(MAX)
    DECLARE @v_nick_name             NVARCHAR(MAX)
    DECLARE @v_electrode_type        NVARCHAR(MAX)
    DECLARE @v_prod_type             NVARCHAR(MAX)
    DECLARE @v_location              NVARCHAR(MAX)
    DECLARE @v_equipment_id          NVARCHAR(MAX)
    DECLARE @v_market                NVARCHAR(MAX)
    DECLARE @v_qty                   NVARCHAR(MAX)
    DECLARE @v_adjust_in_qty_batch   NVARCHAR(MAX) 
    DECLARE @v_adjust_in_qty_kg      NVARCHAR(MAX) 
    DECLARE @v_adjust_out_qty_batch  NVARCHAR(MAX) 
    DECLARE @v_adjust_out_qty_kg     NVARCHAR(MAX)


	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00596_ADD_LINE'
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
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_line_id                  = ''
    SET @v_operation_id             = ''
    SET @v_top_item_id              = ''
    SET @v_item_id                  = ''
    SET @v_item_type                = ''
    SET @v_nick_name                = ''
    SET @v_prod_type                = ''
    SET @v_electrode_type           = ''
    SET @v_location                 = ''
    SET @v_market                   = ''
    SET @v_equipment_id             = ''
    SET @v_qty                      = ''
    SET @v_adjust_in_qty_batch      = '' 
    SET @v_adjust_in_qty_kg         = '' 
    SET @v_adjust_out_qty_batch     = '' 
    SET @v_adjust_out_qty_kg        = ''


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

	/****************************************************************************/
	/* EXECUTE  경우  :  EXEC_PSICALCUL                                         */
	/****************************************************************************/
	IF(@p_sys_flag ='EXEC_PSICALCUL')
         BEGIN
		    SET @runstart = GETDATE()
			SELECT @v_dSql = '[dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI] '''+ @p_instance_id +''', '''+ @p_plan_id +''' '
		    EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id, @p_sys_flag,'', @v_dSql,'SELECT(START)',@runstart, @runend
			
			--실제수행
			EXEC  @rtnCount = [dbo].PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI @v_instance_id, @v_plan_id

			SET @runend = GETDATE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
			--SET @rtnCount = 1
			SELECT	'Result' = @rtnCount

         END
    ELSE
		/************************************************************************************************/
		/* SAVE인경우 :SAVE                                                                      */
		/************************************************************************************************/
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --( BEGIN )

             /****************************************************************************/
             /* INSERT_LINE  저장 경우  :                                               */
             /****************************************************************************/
             IF(@p_sys_flag ='INSERT_LINE')
                
                BEGIN
             		SELECT @v_dSql = ''
                     SELECT @v_dSql += ' MERGE INTO FP_AMEND_DAILY_PLAN_R A ' + char(10)
                     SELECT @v_dSql += ' USING ( SELECT UPPER('''+ @p_instance_id +''') AS INSTANCE_ID, UPPER('''+ @p_plan_id +''') AS FP_PLAN_ID, ' + char(10)
                     SELECT @v_dSql += '                UPPER('''+ @p_division_id +''') AS DIVISION_ID, UPPER('''+ @p_site_id +''') AS SITE_ID,UPPER('''+ @p_plant_id +''') AS PLANT_ID, UPPER('''+ @p_factory_id +''') AS FACTORY_ID,  ' + char(10)
                     SELECT @v_dSql += '                ''-'' AS LOCATION, UPPER('''+ @p_operation_id +''') AS OPERATION_ID, UPPER('''+ @p_line_id +''') AS LINE_ID, '''+ @p_electrode_type +''' AS ELECTRODE_TYPE, ' + char(10)
                     SELECT @v_dSql += '                UPPER('''+ @p_equipment_id +''') AS EQUIPMENT_ID,'''+ @p_plan_date +''' AS PLAN_DATE,       ' + char(10)
                     SELECT @v_dSql += '                UPPER('''+ @p_item_id +''') AS TOP_ITEM_ID, UPPER('''+ @p_item_id +''') AS ITEM_ID,         ' + char(10)
                     SELECT @v_dSql += '                UPPER('''+ @p_prod_type +''') AS PRODUCTION_TYPE, UPPER('''+ @p_market +''') AS MARKET) B ' + char(10)
                     SELECT @v_dSql += ' ON (    A.INSTANCE_ID = B.INSTANCE_ID AND A.FP_PLAN_ID = B.FP_PLAN_ID                                      ' + char(10)
                     SELECT @v_dSql += '     AND A.FACTORY_ID = B.FACTORY_ID AND A.LOCATION = B.LOCATION                                            ' + char(10)
                     SELECT @v_dSql += '     AND A.OPERATION_ID = B.OPERATION_ID AND A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE  ' + char(10)
                     SELECT @v_dSql += '     AND A.EQUIPMENT_ID = B.EQUIPMENT_ID AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE ' + char(10)
                     SELECT @v_dSql += '     AND A.TOP_ITEM_ID = B.TOP_ITEM_ID AND A.ITEM_ID = B.ITEM_ID         ' + char(10)
                     SELECT @v_dSql += '     AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET ) ' + char(10)
                     SELECT @v_dSql += ' WHEN MATCHED THEN                                                       ' + char(10)
                     SELECT @v_dSql += '      UPDATE SET ADJUST_IN_QTY_BATCH  = '''+ @p_adjust_in_qty_batch +''' ' + char(10)
                     SELECT @v_dSql += '          , ADJUST_IN_QTY_KG     = '''+ @p_adjust_in_qty_kg +'''         ' + char(10)
                     SELECT @v_dSql += '          , ADJUST_OUT_QTY_BATCH = '''+ @p_adjust_out_qty_batch +'''     ' + char(10)
                     SELECT @v_dSql += '          , ADJUST_OUT_QTY_KG    = '''+ @p_adjust_out_qty_kg +'''        ' + char(10)
                     SELECT @v_dSql += '          , UPDATE_ID = '''+ @p_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                     SELECT @v_dSql += '          , PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
					 SELECT @v_dSql += '          , SEQ = 1 ' + char(10)
                     SELECT @v_dSql += ' WHEN NOT MATCHED THEN                          ' + char(10)
                     SELECT @v_dSql += '     INSERT (                                   ' + char(10)
                     SELECT @v_dSql += '          INSTANCE_ID, FP_PLAN_ID               ' + char(10)
                     SELECT @v_dSql += '         ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID        ' + char(10)
                     SELECT @v_dSql += '         ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID ' + char(10)
                     SELECT @v_dSql += '         ,PLAN_DATE               ' + char(10)
                     SELECT @v_dSql += '         ,TOP_ITEM_ID, ITEM_ID    ' + char(10)
                     SELECT @v_dSql += '         ,PRODUCTION_TYPE, MARKET ' + char(10)
                     SELECT @v_dSql += '         ,SEQ                     ' + char(10)
                     SELECT @v_dSql += '         ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY, ADJUST_IN_QTY_KG    ' + char(10)
                     SELECT @v_dSql += '         ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY, ADJUST_OUT_QTY_KG ' + char(10)
                     SELECT @v_dSql += '         ,INSERT_ID, INSERT_TIME ' + char(10)
                     SELECT @v_dSql += '         ,UPDATE_ID, UPDATE_TIME ' + char(10)
                     SELECT @v_dSql += '     )        ' + char(10)
                     SELECT @v_dSql += '     VALUES ( ' + char(10)
                     SELECT @v_dSql += '          UPPER('''+ @p_instance_id +'''), UPPER('''+ @p_plan_id +''') ' + char(10)
                     SELECT @v_dSql += '         ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = '''+ @p_factory_id +''' AND ACTIVE_FLAG = ''Y''), '''+ @p_division_id +''', '''+ @p_site_id +''', '''+ @p_plant_id +''', '''+ @p_factory_id +''' ' + char(10)
                     SELECT @v_dSql += '         ,''-'', UPPER('''+ @p_operation_id +'''), UPPER('''+ @p_line_id +'''), '''+ @p_electrode_type +''', UPPER('''+ @p_equipment_id +''') ' + char(10)
                     SELECT @v_dSql += '         ,CONVERT(DATETIME,'''+ @p_plan_date +''')                  ' + char(10)
                     SELECT @v_dSql += '         ,UPPER('''+ @p_item_id +'''), UPPER('''+ @p_item_id +''')  ' + char(10)
                     SELECT @v_dSql += '         ,UPPER('''+ @p_prod_type +'''), UPPER('''+ @p_market +''') ' + char(10)
                     SELECT @v_dSql += '         ,1                                                         ' + char(10)
                     SELECT @v_dSql += '         ,'''+ @p_adjust_in_qty_batch +''', '''+ @p_qty +''', '''+ @p_adjust_in_qty_kg +'''   ' + char(10)
                     SELECT @v_dSql += '         ,'''+ @p_adjust_out_qty_batch +''', '''+ @p_qty +''', '''+ @p_adjust_out_qty_kg +''' ' + char(10)
                     SELECT @v_dSql += '         ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                     SELECT @v_dSql += '         ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                     SELECT @v_dSql += '     ) ' + char(10)
                     SELECT @v_dSql += ' ;     ' + char(10)


             
                END --'D'
              /****************************************************************************/
             /* INSERT_LINE_LOG  저장 경우  :                                        */
             /****************************************************************************/
             ELSE IF(@p_sys_flag ='INSERT_LINE_LOG')
                 BEGIN
                      
                      SELECT @v_dSql = ''

                     SELECT @v_dSql += ' INSERT INTO HIS_AMEND_DAILY_PLAN_R ( ' + char(10)
                     SELECT @v_dSql += '      INSTANCE_ID, FP_PLAN_ID ' + char(10)
                     SELECT @v_dSql += '     ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
                     SELECT @v_dSql += '     ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID ' + char(10)
                     SELECT @v_dSql += '     ,PLAN_DATE ' + char(10)
                     SELECT @v_dSql += '     ,TOP_ITEM_ID, ITEM_ID ' + char(10)
                     SELECT @v_dSql += '     ,PRODUCTION_TYPE, MARKET ' + char(10)
                     SELECT @v_dSql += '     ,SEQ ' + char(10)
                     SELECT @v_dSql += '     ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY, ADJUST_IN_QTY_KG ' + char(10)
                     SELECT @v_dSql += '     ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY, ADJUST_OUT_QTY_KG ' + char(10)
                     SELECT @v_dSql += '     ,INSERT_ID, INSERT_TIME ' + char(10)
                     SELECT @v_dSql += '     ,UPDATE_ID, UPDATE_TIME ' + char(10)
                     SELECT @v_dSql += '     ,JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
                     SELECT @v_dSql += ' ) ' + char(10)
                     SELECT @v_dSql += ' VALUES ( ' + char(10)
                     SELECT @v_dSql += '      '''+ @p_instance_id +''', '''+ @p_plan_id +''' ' + char(10)
                     SELECT @v_dSql += '     ,(SELECT DISTINCT COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = '''+ @p_factory_id +''' AND ACTIVE_FLAG = ''Y''), '''+ @p_division_id +''', '''+ @p_site_id +''', '''+ @p_plant_id +''', '''+ @p_factory_id +''' ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_location +''', '''+ @p_operation_id +''', '''+ @p_line_id +''', '''+ @p_electrode_type +''', '''+ @p_equipment_id +''' ' + char(10)
                     SELECT @v_dSql += '     ,CONVERT(DATETIME,'''+ @p_plan_date +''') ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_item_id +''', '''+ @p_item_id +''' ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_prod_type +''', '''+ @p_market +''' ' + char(10)
                     SELECT @v_dSql += '     ,1 ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_qty +''', '''+ @p_qty +''', '''+ @p_adjust_in_qty_kg +'''  ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_qty +''', '''+ @p_qty +''' , '''+ @p_adjust_out_qty_kg +'''  ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                     SELECT @v_dSql += '     ,'''+ @p_user_id +''', GETDATE(), ''ADD'' ' + char(10)
                     SELECT @v_dSql += ' ) ' + char(10)

                 END --'D'            

             IF @p_sys_type = 'SQL'
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
                     EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
                 END

         END --(END)           
         -- 트랜잭션 (COMMIT)
	     COMMIT TRAN
	     
	     -- 수행결과 성공여부 RETURN
	     IF @p_sys_type <> 'SQL'
	         SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	
	     
	     END TRY
	     BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
             ROLLBACK TRAN                                                                                                                                                                                                                                                 
             -- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
             SET @v_log_message = ERROR_MESSAGE()
             EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_log_message,'excute',@runstart, @runend
             SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
	     END CATCH    

END --MAIN END

