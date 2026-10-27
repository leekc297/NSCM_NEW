

/*
 * Program ID   : PR_UI_FP00521_DEMAND_WATERFALL_MEMO
 * Description  : Demand WaterFall
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/02   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00521_DEMAND_WATERFALL_MEMO]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),
  @p_company_id				    NVARCHAR(MAX),
  @p_division_id				NVARCHAR(MAX),
  @p_site_id					NVARCHAR(MAX),
  @p_plant_id					NVARCHAR(MAX),
  @p_factory_id					NVARCHAR(MAX),
  @p_operation_id				NVARCHAR(MAX),
  @p_line_id					NVARCHAR(MAX),
  @p_prod_type					NVARCHAR(MAX),
  @p_category_id                NVARCHAR(MAX),
  @p_market                     NVARCHAR(MAX),
  @p_item_id					NVARCHAR(MAX),
  @p_plan_week      			NVARCHAR(MAX),
  @p_mfg_week					NVARCHAR(MAX),
  @p_description                NVARCHAR(MAX),
  @p_bucket_from_week			NVARCHAR(MAX),
  @p_bucket_to_week				NVARCHAR(MAX),
  @p_plan_from_week				NVARCHAR(MAX),
  @p_plan_to_week				NVARCHAR(MAX)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
	DECLARE @v_company_id                 NVARCHAR(MAX)
	DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_factory_id                 NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_line_id                    NVARCHAR(MAX)
    DECLARE @v_prod_type                  NVARCHAR(MAX)
	DECLARE @v_category_id                NVARCHAR(MAX)
	DECLARE @v_market                     NVARCHAR(MAX)
    DECLARE @v_item_id                    NVARCHAR(MAX)
    DECLARE @v_plan_week      			  NVARCHAR(MAX)
    DECLARE @v_mfg_week					  NVARCHAR(MAX)
    DECLARE @v_description                NVARCHAR(MAX)
    DECLARE @v_bucket_from_week			  NVARCHAR(MAX)
    DECLARE @v_bucket_to_week			  NVARCHAR(MAX)
    DECLARE @v_plan_from_week			  NVARCHAR(MAX)
    DECLARE @v_plan_to_week				  NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00521_DEMAND_WATERFALL_MEMO'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @max_loop_cnt2	        INTEGER = 0
	DECLARE @mst_loop_cnt2	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_company_id               = ''
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_operation_id             = ''
    SET @v_line_id                  = ''
    SET @v_prod_type                = ''
	SET @v_category_id              = ''
	SET @v_market                   = ''
    SET @v_item_id                  = ''
	SET @v_plan_week      			= ''
    SET @v_mfg_week					= ''
    SET @v_description              = ''
    SET @v_bucket_from_week			= ''
    SET @v_bucket_to_week			= ''
    SET @v_plan_from_week			= ''
    SET @v_plan_to_week				= ''
    
	--SET @p_user_id              = dbo.FN_deCRYPT_AES128(@p_user_id)
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(MEMO LIST POPUP)                                                        */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MEMO_POPUP')
	    BEGIN
		    SELECT @v_dSql = ''

            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
            SELECT @v_dSql += '     , A.CATEGORY_ID, A.PLAN_WEEK, A.MFG_WEEK, A.DESCRIPTION             ' + char(10)
            SELECT @v_dSql += '     , A.UPDATE_ID, CONVERT(VARCHAR, A.UPDATE_DATE, 20) AS UPDATE_DATE   ' + char(10)
            SELECT @v_dSql += ' FROM   FP_SCP_CHANGE_MEMO_M A WITH(NOLOCK)                              ' + char(10)
            SELECT @v_dSql += ' WHERE  A.DESCRIPTION IS NOT NULL AND A.DESCRIPTION <> ''''              ' + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))               + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))           + char(10)
            SELECT @v_dSql += ' '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))       + char(10)
            SELECT @v_dSql += ' AND    A.PLAN_WEEK BETWEEN '''+ @p_plan_from_week +''' AND '''+ @p_plan_to_week +'''    ' + char(10)
            SELECT @v_dSql += ' AND    A.MFG_WEEK BETWEEN '''+ @p_bucket_from_week +''' AND '''+ @p_bucket_to_week +''' ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID               ' + char(10)
            SELECT @v_dSql += '    , A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                  ' + char(10)
            SELECT @v_dSql += '    , A.CATEGORY_ID, A.PLAN_WEEK, A.MFG_WEEK ' + char(10)

		    IF @p_sys_type = 'SQL'
		  	    BEGIN
		  	    	 --EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
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
                    
                    SELECT @v_sys_type       = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,    @v_delimiter, @mst_loop_cnt)
                         , @v_sys_flag       = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,    @v_delimiter, @mst_loop_cnt)
                         , @v_sys_gubun      = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,   @v_delimiter, @mst_loop_cnt)
                         , @v_user_id        = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,     @v_delimiter, @mst_loop_cnt)
                         , @v_company_id     = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,  @v_delimiter, @mst_loop_cnt)
                         , @v_division_id    = [dbo].[SCM_ARR_SPL_VAL](@p_division_id , @v_delimiter, @mst_loop_cnt)
                         , @v_site_id        = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,     @v_delimiter, @mst_loop_cnt)
                         , @v_plant_id       = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,    @v_delimiter, @mst_loop_cnt)
						 , @v_factory_id     = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,  @v_delimiter, @mst_loop_cnt)
                         , @v_operation_id   = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter, @mst_loop_cnt)
                         , @v_line_id        = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,     @v_delimiter, @mst_loop_cnt)
                         , @v_item_id        = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,     @v_delimiter, @mst_loop_cnt)
                         , @v_prod_type      = [dbo].[SCM_ARR_SPL_VAL](@p_prod_type ,   @v_delimiter, @mst_loop_cnt)
                         , @v_category_id    = [dbo].[SCM_ARR_SPL_VAL](@p_category_id , @v_delimiter, @mst_loop_cnt)
                         , @v_market         = [dbo].[SCM_ARR_SPL_VAL](@p_market ,      @v_delimiter, @mst_loop_cnt)
                         , @v_plan_week      = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week ,   @v_delimiter, @mst_loop_cnt)
                         , @v_mfg_week       = [dbo].[SCM_ARR_SPL_VAL](@p_mfg_week ,    @v_delimiter, @mst_loop_cnt)
                         , @v_description    = [dbo].[SCM_ARR_SPL_VAL](@p_description , @v_delimiter, @mst_loop_cnt)
                         
 					/****************************************************************************/
					/* SAVE_MEMO  경우  :     I(MEMOLIST_POPUP)                                 */
					/****************************************************************************/
					IF(@v_sys_flag ='SAVE_MEMO_POPUP')
					    BEGIN
								SELECT @v_dSql1 = ''
                                SELECT @v_dSql1 += 'MERGE INTO FP_SCP_CHANGE_MEMO_M A ' + char(10)
                                SELECT @v_dSql1 += 'USING (                           ' + char(10)
                                SELECT @v_dSql1 += '       SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_site_id +''' AS SITE_ID   ' + char(10)
                                SELECT @v_dSql1 += '          , '''+ @v_plant_id +''' AS PLANT_ID, '''+ @v_factory_id +''' AS FACTORY_ID, '''+ @v_operation_id +''' AS OPERATION_ID ' + char(10)
                                SELECT @v_dSql1 += '          , '''+ @v_line_id +''' AS LINE_ID, '''+ @v_item_id +''' AS ITEM_ID, '''+ @v_prod_type +''' AS PRODUCTION_TYPE         ' + char(10)
                                SELECT @v_dSql1 += '          , '''+ @v_market +''' AS MARKET, '''+ @v_category_id +''' AS CATEGORY_ID, '''+ @v_plan_week +''' AS PLAN_WEEK         ' + char(10)
                                SELECT @v_dSql1 += '          , '''+ @v_mfg_week +''' AS MFG_WEEK, '''+ @v_description +''' AS DESCRIPTION                                          ' + char(10)
                                SELECT @v_dSql1 += '      ) B                                     ' + char(10)
                                SELECT @v_dSql1 += 'ON (    A.FACTORY_ID      = B.FACTORY_ID      ' + char(10)
                                SELECT @v_dSql1 += '    AND A.OPERATION_ID    = B.OPERATION_ID    ' + char(10)
                                SELECT @v_dSql1 += '    AND A.LINE_ID         = B.LINE_ID         ' + char(10)
                                SELECT @v_dSql1 += '    AND A.ITEM_ID         = B.ITEM_ID         ' + char(10)
                                SELECT @v_dSql1 += '    AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
                                SELECT @v_dSql1 += '    AND A.MARKET          = B.MARKET          ' + char(10)
                                SELECT @v_dSql1 += '    AND A.CATEGORY_ID     = B.CATEGORY_ID     ' + char(10)
                                SELECT @v_dSql1 += '    AND A.PLAN_WEEK       = B.PLAN_WEEK       ' + char(10)
                                SELECT @v_dSql1 += '    AND A.MFG_WEEK        = B.MFG_WEEK        ' + char(10)
                                SELECT @v_dSql1 += ')                                             ' + char(10)
                                SELECT @v_dSql1 += 'WHEN MATCHED THEN                             ' + char(10)
                                SELECT @v_dSql1 += '  UPDATE SET DESCRIPTION = '''+ @v_description +'''    ' + char(10)
                                SELECT @v_dSql1 += '           , UPDATE_ID   = '''+ @v_user_id +'''        ' + char(10)
                                SELECT @v_dSql1 += '           , UPDATE_DATE = dbo.FN_SITE_TIME(B.SITE_ID) ' + char(10)
                                SELECT @v_dSql1 += 'WHEN NOT MATCHED THEN                                  ' + char(10)
                                SELECT @v_dSql1 += '  INSERT (                                             ' + char(10)
                                SELECT @v_dSql1 += '        COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID  ' + char(10)
                                SELECT @v_dSql1 += '      , OPERATION_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, MARKET ' + char(10)
                                SELECT @v_dSql1 += '      , CATEGORY_ID, PLAN_WEEK, MFG_WEEK, DESCRIPTION           ' + char(10)
                                SELECT @v_dSql1 += '      , INSERT_ID, INSERT_DATE, UPDATE_ID, UPDATE_DATE          ' + char(10)
                                SELECT @v_dSql1 += '  )                                                             ' + char(10)
                                SELECT @v_dSql1 += '  VALUES (                                                      ' + char(10)
                                SELECT @v_dSql1 += '        B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID  ' + char(10)
                                SELECT @v_dSql1 += '      , B.OPERATION_ID, B.LINE_ID, B.ITEM_ID, B.PRODUCTION_TYPE, B.MARKET ' + char(10)
                                SELECT @v_dSql1 += '      , B.CATEGORY_ID, B.PLAN_WEEK, B.MFG_WEEK, B.DESCRIPTION             ' + char(10)
                                SELECT @v_dSql1 += '      , '''+ @v_user_id +''', dbo.FN_SITE_TIME(B.SITE_ID)                 ' + char(10)
                                SELECT @v_dSql1 += '      , '''+ @v_user_id +''', dbo.FN_SITE_TIME(B.SITE_ID)                 ' + char(10)
                                SELECT @v_dSql1 += '  );                                                                      ' + char(10)
                                SELECT @v_dSql2  = ''
                                SELECT @v_dSql2 += ' INSERT INTO HIS_SCP_CHANGE_MEMO_M (                           ' + char(10)
                                SELECT @v_dSql2 += '    COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID     ' + char(10)
                                SELECT @v_dSql2 += '  , OPERATION_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, MARKET    ' + char(10)
                                SELECT @v_dSql2 += '  , CATEGORY_ID, PLAN_WEEK, MFG_WEEK, DESCRIPTION              ' + char(10)
                                SELECT @v_dSql2 += '  , INSERT_ID, INSERT_DATE, UPDATE_ID, UPDATE_DATE             ' + char(10)
                                SELECT @v_dSql2 += '  , JOB_USER_ID, JOB_TIME, JOB_TYPE                            ' + char(10)
                                SELECT @v_dSql2 += ' )                                                             ' + char(10)
                                SELECT @v_dSql2 += ' SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
                                SELECT @v_dSql2 += '  , OPERATION_ID, LINE_ID, ITEM_ID, PRODUCTION_TYPE, MARKET    ' + char(10)
                                SELECT @v_dSql2 += '  , CATEGORY_ID, PLAN_WEEK, MFG_WEEK, DESCRIPTION              ' + char(10)
                                SELECT @v_dSql2 += '  , INSERT_ID, INSERT_DATE, UPDATE_ID, UPDATE_DATE             ' + char(10)
                                SELECT @v_dSql2 += '  , '''+ @v_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''MERGE'' AS JOB_TYPE ' + char(10)
                                SELECT @v_dSql2 += ' FROM   FP_SCP_CHANGE_MEMO_M A WITH(NOLOCK)               ' + char(10)
                                SELECT @v_dSql2 += ' WHERE  A.COMPANY_ID       = '''+ @v_company_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.DIVISION_ID      = '''+ @v_division_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.SITE_ID          = '''+ @v_site_id +'''         ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PLANT_ID         = '''+ @v_plant_id +'''        ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.FACTORY_ID       = '''+ @v_factory_id +'''      ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.OPERATION_ID     = '''+ @v_operation_id +'''    ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.LINE_ID          = '''+ @v_line_id +'''         ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.ITEM_ID          = '''+ @v_item_id +'''         ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PRODUCTION_TYPE  = '''+ @v_prod_type +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.MARKET           = '''+ @v_market +'''          ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.CATEGORY_ID      = '''+ @v_category_id +'''     ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.PLAN_WEEK        = '''+ @v_plan_week +'''       ' + char(10)
                                SELECT @v_dSql2 += ' AND    A.MFG_WEEK         = '''+ @v_mfg_week +'''        ' + char(10)

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'S'
					    
					IF @v_sys_type = 'SQL'
						BEGIN
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
		    BEGIN
		        SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	
			END

		END TRY
		BEGIN CATCH                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                     
			ROLLBACK TRAN                                                                                                                                                                                                                                                 
			-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
			SET @v_log_message = ERROR_MESSAGE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
		END CATCH    

END --MAIN END
