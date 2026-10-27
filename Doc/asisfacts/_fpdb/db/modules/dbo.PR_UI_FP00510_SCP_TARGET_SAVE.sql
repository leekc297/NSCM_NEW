

/*
 * Program ID   : PR_UI_FP00510_SCP_TARGET_SAVE
 * Description  : SCP Target
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/01   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00510_SCP_TARGET_SAVE]
  @p_sys_type			  NVARCHAR(100),  
  @p_sys_flag			  NVARCHAR(100),
  @p_sys_gubun			  NVARCHAR(100),  
  @p_user_id			  NVARCHAR(100),
  @p_company_id           NVARCHAR(50), 
  @p_division_id          NVARCHAR(50),
  @p_site_id              NVARCHAR(50),
  @p_plant_id             NVARCHAR(50), 
  @p_instance_id          NVARCHAR(50),  --plan group
  @p_scp_plan_id          NVARCHAR(100),
  @p_scp_target_id        NVARCHAR(200),
  @p_shop_group_id        NVARCHAR(100),
  @p_item_id              NVARCHAR(100), 
  @p_nick_name            NVARCHAR(100), 
  @p_mfg_week             NVARCHAR(50), 
  @p_market               NVARCHAR(50), 
  @p_org_market           NVARCHAR(50), 
  @p_mfg_date             NVARCHAR(50), 
  @p_mfg_qty              NVARCHAR(100), 
  @p_chg_qty              NVARCHAR(100),
  @p_production_type      NVARCHAR(100),
  @p_priority             NVARCHAR(100),
  @p_period_type          NVARCHAR(100),
  @p_line_id              NVARCHAR(50), 
  @p_line_name            NVARCHAR(100),
  @p_operation_id         NVARCHAR(100),
  @p_new_target_id        NVARCHAR(200),
  @p_new_market           NVARCHAR(50)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_new_target_id        NVARCHAR(100)
	DECLARE @v_sample_from_date     NVARCHAR(50) 
	DECLARE @v_sample_to_date       NVARCHAR(50)
	DECLARE @v_confirm_type         NVARCHAR(50) 
	DECLARE @v_demand_type          NVARCHAR(50)
					    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00510_SCP_TARGET_SAVE'
	DECLARE @v_log_type             NVARCHAR(100) = '' 
	DECLARE @v_log_message          NVARCHAR(1000) = ''
	DECLARE @v_error_description    NVARCHAR(1000) = ''


	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime
	DECLARE @v_dSql                 NVARCHAR(MAX)
	DECLARE @v_dSql2                 NVARCHAR(MAX)

	SELECT @v_sample_from_date = '' 
	 , @v_sample_to_date       = ''
	 , @v_confirm_type         = ''
	 , @v_demand_type          = ''
	 , @v_dSql                 = ''
	 , @v_dSql2                = ''

	 --SET @p_user_id              = dbo.FN_deCRYPT_AES128(@p_user_id)
	/************************************************************************************************/
	/* SELECT인경우 :SELECT_MAIN(SELECT)                                                            */
	/************************************************************************************************/
	-- 트랜잭션 (TRAN)
	BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
	BEGIN TRAN  
	
	BEGIN --START( BEGIN )	
	IF(@p_sys_flag ='INSERT')
		BEGIN --INSERT(START)
			SELECT @v_dSql = ''
            SELECT @v_dSql += N'    INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_H (                                                                 ' + char(10)
            SELECT @v_dSql += N'           COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, MARKET,     ' + char(10)
            SELECT @v_dSql += N'           ITEM_ID, MFG_WEEK, MFG_QTY, CHG_QTY, PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE, LINE_ID,   ' + char(10)
            SELECT @v_dSql += N'           PRIORITY, PERIOD_TYPE, CONFIRM_TYPE, DEMAND_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,  ' + char(10)
            SELECT @v_dSql += N'           JOB_USER_ID, JOB_TIME, JOB_TYPE                                                                    ' + char(10)
            SELECT @v_dSql += N'    )                                                                                                         ' + char(10)
            SELECT @v_dSql += N'    SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, MARKET      ' + char(10)
            SELECT @v_dSql += N'         , ITEM_ID, MFG_WEEK, MFG_QTY, CHG_QTY, PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE, LINE_ID    ' + char(10)
            SELECT @v_dSql += N'         , PRIORITY, PERIOD_TYPE, CONFIRM_TYPE, DEMAND_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME   ' + char(10)
            SELECT @v_dSql += N'         , '''+ @p_user_id +''',  GETDATE(), ''INSERT''     ' + char(10)
            SELECT @v_dSql += N'    FROM   FP_WEEKLY_DEMAND_PRODUCT_H A                     ' + char(10)
            SELECT @v_dSql += N'    WHERE  COMPANY_ID     = '''+ @p_company_id +'''         ' + char(10)
            SELECT @v_dSql += N'    AND    DIVISION_ID    = '''+ @p_division_id +'''        ' + char(10)
            SELECT @v_dSql += N'    AND    SITE_ID        = '''+ @p_site_id +'''            ' + char(10)
            SELECT @v_dSql += N'    AND    PLANT_ID       = '''+ @p_plant_id +'''           ' + char(10)
            SELECT @v_dSql += N'    AND    SHOP_GROUP_ID  = '''+ @p_shop_group_id +'''      ' + char(10)
            SELECT @v_dSql += N'    AND    SCP_PLAN_ID    = '''+ @p_scp_plan_id +'''        ' + char(10)
            SELECT @v_dSql += N'    AND    SCP_TARGET_ID  = '''+ @p_scp_target_id +'''      ' + char(10)
            SELECT @v_dSql += N'    AND    MARKET         = '''+ @p_market +'''             ' + char(10)
            SELECT @v_dSql += N'                                                            ' + char(10)
            SELECT @v_dSql += N'    UPDATE FP_WEEKLY_DEMAND_PRODUCT_H SET					' + char(10)
            SELECT @v_dSql += N'		   MFG_QTY        = '''+ @p_mfg_qty +'''			' + char(10)
            SELECT @v_dSql += N'		 , UPDATE_ID      = '''+ @p_user_id +'''			' + char(10)
            SELECT @v_dSql += N'		 , UPDATE_TIME    = GETDATE()   					' + char(10)
            SELECT @v_dSql += N'    WHERE  COMPANY_ID     = '''+ @p_company_id +'''			' + char(10)
            SELECT @v_dSql += N'    AND    DIVISION_ID    = '''+ @p_division_id +'''		' + char(10)
            SELECT @v_dSql += N'    AND    SITE_ID        = '''+ @p_site_id +'''			' + char(10)
            SELECT @v_dSql += N'    AND    PLANT_ID       = '''+ @p_plant_id +'''			' + char(10)
            SELECT @v_dSql += N'    AND    SHOP_GROUP_ID  = '''+ @p_shop_group_id +'''		' + char(10)
            SELECT @v_dSql += N'    AND    SCP_PLAN_ID    = '''+ @p_scp_plan_id +'''		' + char(10)
            SELECT @v_dSql += N'    AND    SCP_TARGET_ID  = '''+ @p_scp_target_id +'''		' + char(10)
            SELECT @v_dSql += N'    AND    MARKET         = '''+ @p_market +'''				' + char(10)
            SELECT @v_dSql += N'																		   ' + char(10)
            SELECT @v_dSql += N'    INSERT INTO FP_WEEKLY_DEMAND_PRODUCT_H (                               ' + char(10)
            SELECT @v_dSql += N'        COMPANY_ID,        DIVISION_ID,      SITE_ID,         PLANT_ID     ' + char(10)
            SELECT @v_dSql += N'      , SHOP_GROUP_ID,     SCP_PLAN_ID,      SCP_TARGET_ID,   MARKET       ' + char(10)
            SELECT @v_dSql += N'      , ITEM_ID,           MFG_WEEK,         MFG_QTY,         CHG_QTY      ' + char(10)
            SELECT @v_dSql += N'      , PRODUCTION_TYPE,   SAMPLE_FROM_DATE, SAMPLE_TO_DATE,  LINE_ID      ' + char(10)
            SELECT @v_dSql += N'      , PRIORITY,          PERIOD_TYPE,      CONFIRM_TYPE,    DEMAND_TYPE  ' + char(10)
            SELECT @v_dSql += N'      , INSERT_ID,         INSERT_TIME,      UPDATE_ID,       UPDATE_TIME  ' + char(10)
            SELECT @v_dSql += N'      , MFG_DATE,          OPERATION_ID                                    ' + char(10)
            SELECT @v_dSql += N'    ) VALUES (                                                             ' + char(10)
            SELECT @v_dSql += N'     '''+ @p_company_id +''',    '''+ @p_division_id +''', '''+ @p_site_id +''',       '''+ @p_plant_id +'''   ' + char(10)
            SELECT @v_dSql += N'   , '''+ @p_shop_group_id +''', '''+ @p_scp_plan_id +''', '''+ @p_new_target_id +''', '''+ @p_new_market +''' ' + char(10)
			SELECT @v_dSql += N'   , '''+ @p_item_id +''',       '''+ @p_mfg_week +''',    '''+ @p_chg_qty +''',       NULL   ' + char(10)
            SELECT @v_dSql += N'   , '''+ @p_production_type +''', '''' , ''''                                                                 ' + char(10)
            SELECT @v_dSql += N'   , (                                                   ' + char(10)
            SELECT @v_dSql += N'       SELECT TOP 1 SCP_LINE_ID                          ' + char(10)
            SELECT @v_dSql += N'       FROM  SCM_LINE_M  A WITH(NOLOCK)                  ' + char(10)
            SELECT @v_dSql += N'      WHERE  A.COMPANY_ID  = '''+ @p_company_id +'''     ' + char(10)
            SELECT @v_dSql += N'       AND   A.DIVISION_ID = '''+ @p_division_id +'''    ' + char(10)
            SELECT @v_dSql += N'       AND   A.SITE_ID     = '''+ @p_site_id +'''        ' + char(10)
            SELECT @v_dSql += N'       AND   A.PLANT_ID    = '''+ @p_plant_id +'''       ' + char(10)
            SELECT @v_dSql += N'       AND   A.LINE_ID     = '''+ @p_line_id +'''        ' + char(10)
            SELECT @v_dSql += N'       AND   A.ACTIVE_FLAG = ''Y''                       ' + char(10)
            SELECT @v_dSql += N'       AND   A.SCP_LINE_ID IS NOT NULL                   ' + char(10)
            SELECT @v_dSql += N'       AND   A.SCP_LINE_ID != ''''                       ' + char(10)
            SELECT @v_dSql += N'       )                                                 ' + char(10)
            SELECT @v_dSql += N'      , '''+ @p_priority +''', '''+ @p_period_type +''', '''+ @v_confirm_type +''', '''+ @v_demand_type +'''  ' + char(10)
            SELECT @v_dSql += N'      , '''+ @p_user_id +''',  GETDATE(), '''+ @p_user_id +''',  GETDATE()                                    ' + char(10)
			SELECT @v_dSql += N'      , '''+ @p_mfg_date +''',  '''+ @p_operation_id +'''                                                     ' + char(10)
            SELECT @v_dSql += N'    )                                                                                                         ' + char(10)    
			SELECT @v_dSql += N'    INSERT INTO HIS_WEEKLY_DEMAND_PRODUCT_H (                                                                 ' + char(10)
            SELECT @v_dSql += N'           COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, MARKET,     ' + char(10)
            SELECT @v_dSql += N'           ITEM_ID, MFG_WEEK, MFG_QTY, CHG_QTY, PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE, LINE_ID,   ' + char(10)
            SELECT @v_dSql += N'           PRIORITY, PERIOD_TYPE, CONFIRM_TYPE, DEMAND_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,  ' + char(10)
            SELECT @v_dSql += N'           JOB_USER_ID, JOB_TIME, JOB_TYPE                                                                    ' + char(10)
            SELECT @v_dSql += N'    )                                                                                                         ' + char(10)
            SELECT @v_dSql += N'    SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, SCP_PLAN_ID, SCP_TARGET_ID, MARKET      ' + char(10)
            SELECT @v_dSql += N'         , ITEM_ID, MFG_WEEK, MFG_QTY, CHG_QTY, PRODUCTION_TYPE, SAMPLE_FROM_DATE, SAMPLE_TO_DATE, LINE_ID    ' + char(10)
            SELECT @v_dSql += N'         , PRIORITY, PERIOD_TYPE, CONFIRM_TYPE, DEMAND_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME   ' + char(10)
            SELECT @v_dSql += N'         , '''+ @p_user_id +''',  GETDATE(), ''INSERT''     ' + char(10)
            SELECT @v_dSql += N'    FROM   FP_WEEKLY_DEMAND_PRODUCT_H A                     ' + char(10)
            SELECT @v_dSql += N'    WHERE  COMPANY_ID     = '''+ @p_company_id +'''         ' + char(10)
            SELECT @v_dSql += N'    AND    DIVISION_ID    = '''+ @p_division_id +'''        ' + char(10)
            SELECT @v_dSql += N'    AND    SITE_ID        = '''+ @p_site_id +'''            ' + char(10)
            SELECT @v_dSql += N'    AND    PLANT_ID       = '''+ @p_plant_id +'''           ' + char(10)
            SELECT @v_dSql += N'    AND    SHOP_GROUP_ID  = '''+ @p_shop_group_id +'''      ' + char(10)
            SELECT @v_dSql += N'    AND    SCP_PLAN_ID    = '''+ @p_scp_plan_id +'''        ' + char(10)
            SELECT @v_dSql += N'    AND    SCP_TARGET_ID  = '''+ @p_new_target_id +'''      ' + char(10)
            SELECT @v_dSql += N'    AND    MARKET         = '''+ @p_new_market +'''         ' + char(10)

		END --'INSERT(END)'

		IF @p_sys_type = 'SQL'
			BEGIN
				--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','', @v_dSql, 'select', @runstart, @runend
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

	END --END (END)
 		
    -- 트랜잭션 (COMMIT)
	COMMIT TRAN
		
	-- 수행결과 성공여부 RETURN
	IF @p_sys_type <> 'SQL'
		SELECT 'SUCCESS' AS result_code,  '1' AS result_cnt	

	END TRY

	BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
		ROLLBACK TRAN                                                                                                                                                                                                                                                 
		-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
		SET @v_log_message = ERROR_MESSAGE()
		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
	END CATCH    

END --MAIN END

