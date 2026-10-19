
/*
 * Program ID   : SSP0029_SAVE_MES_STOCK
 * Description  : MES STOCK 시트 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022.09.01   SSP Pjt. 	    Created.
 *
 ex) 
 */
 CREATE PROCEDURE [dbo].[SSP0029_SAVE_MES_STOCK]

	@p_active_flag				NVARCHAR(MAX),
	@p_division_id				NVARCHAR(MAX),
	@p_plan_start_yyyymmdd		NVARCHAR(MAX),
	@p_plan_type				NVARCHAR(MAX),
	@p_seq						NVARCHAR(MAX),
	@p_from_site				NVARCHAR(MAX),
	@p_item_id					NVARCHAR(MAX),
	@p_lot_id					NVARCHAR(MAX),
	@p_user_mod_release_date	NVARCHAR(MAX),
	@p_remarks					NVARCHAR(MAX),
	@p_user_id					NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;
--    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
--    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag					NVARCHAR(MAX);
	DECLARE @v_division_id         			NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd			NVARCHAR(MAX);
	DECLARE @v_plan_type					NVARCHAR(MAX);
	DECLARE @v_seq							NVARCHAR(MAX);
	DECLARE @v_from_site           			NVARCHAR(MAX);
	DECLARE @v_item_id             			NVARCHAR(MAX);
	DECLARE @v_lot_id						NVARCHAR(MAX);
	DECLARE @v_user_mod_release_date       	NVARCHAR(MAX);
    DECLARE @v_remarks						NVARCHAR(MAX);
	DECLARE @v_user_id						NVARCHAR(MAX);

	DECLARE @temp_from_site           		NVARCHAR(MAX);
	DECLARE @temp_item_id           		NVARCHAR(MAX);

	SET @v_active_flag				= NULL;
	SET @v_division_id				= NULL;
	SET @v_plan_start_yyyymmdd		= NULL;
	SET @v_plan_type				= NULL;
	SET @v_seq						= NULL;
	SET @v_from_site				= NULL;
	SET @v_item_id					= NULL;
	SET @v_lot_id					= NULL;
	SET @v_user_mod_release_date	= NULL;
	SET @v_remarks					= NULL;
	SET @v_user_id					= NULL;

	SET @temp_from_site				= '-';
	SET @temp_item_id				= '-';

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0;


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0029_SAVE_MES_STOCK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	IF OBJECT_ID('tempdb..#TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP') IS NOT NULL	
		DROP TABLE #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP;


	 CREATE TABLE #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP (
		 ACTIVE_FLAG			NVARCHAR(MAX)
		,DIVISION_ID			NVARCHAR(MAX)
		,PLAN_START_YYYYMMDD	NVARCHAR(MAX)
		,PLAN_TYPE				NVARCHAR(MAX)
		,SEQ					NVARCHAR(MAX)
		,FROM_SITE				NVARCHAR(MAX)
        ,ITEM_ID				NVARCHAR(MAX)
    	,LOT_ID					NVARCHAR(MAX)
		,USER_MOD_RELEASE_DATE	NVARCHAR(MAX)
		,REMARKS				NVARCHAR(MAX)
		,USER_ID				NVARCHAR(MAX)

	);


	BEGIN TRY
	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	-- 프로시저 LOOP 길이를 판단
	SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);
	--SELECT    @max_loop_cnt;
	--	WHILE LEN(@p_active_flag) > 0
	WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

	BEGIN

		-- @mst_loop_cnt 1증가
		SET @mst_loop_cnt = @mst_loop_cnt + 1;
		--SELECT @mst_loop_cnt,'@mst_loop_cnt'

		-- 각 컬럼들에 대한 스플릿처리로직 스타트
		BEGIN

			SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;
			SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;
			SET @v_plan_start_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;
			SET @v_plan_type = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type, @v_delimiter , @mst_loop_cnt) ;
			SET @v_seq = [dbo].[SCM_ARR_SPL_VAL](@p_seq, @v_delimiter , @mst_loop_cnt) ;
			SET @v_from_site = [dbo].[SCM_ARR_SPL_VAL](@p_from_site, @v_delimiter , @mst_loop_cnt) ;
			SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;
			SET @v_lot_id = [dbo].[SCM_ARR_SPL_VAL](@p_lot_id, @v_delimiter , @mst_loop_cnt) ;
			SET @v_user_mod_release_date = [dbo].[SCM_ARR_SPL_VAL](@p_user_mod_release_date, @v_delimiter, @mst_loop_cnt) ;
			SET @v_remarks = [dbo].[SCM_ARR_SPL_VAL](@p_remarks, @v_delimiter, @mst_loop_cnt) ;
			SET @v_user_id = [dbo].[SCM_ARR_SPL_VAL](@p_user_id, @v_delimiter, @mst_loop_cnt) ;

		END


		-- UPDATE 대상 TEMP 테이블 만들기
		INSERT INTO #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP ( ACTIVE_FLAG, DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, FROM_SITE, ITEM_ID, LOT_ID, USER_MOD_RELEASE_DATE, REMARKS, USER_ID)
		VALUES(@v_active_flag, @v_division_id, @v_plan_start_yyyymmdd, @v_plan_type, @v_seq, @v_from_site, @v_item_id, @v_lot_id, REPLACE(@v_user_mod_release_date,'-',''), @v_remarks, @v_user_id);
		

		--BEGIN

		--	UPDATE [dbo].[SSP_ANL_MES_FCS_STOCK_40_C]
		--		SET
		--			USER_MOD_RELEASE_DATE		= REPLACE(@v_user_mod_release_date,'-','')
		--			,REMARKS					= @v_remarks
		--			,LAST_UPDATED_BY			= @v_user_id
		--			,LAST_UPDATE_DATE			= sysdatetime()
		--	WHERE	DIVISION_ID					= @v_division_id
		--			AND PLAN_START_YYYYMMDD		= @v_plan_start_yyyymmdd
		--			AND PLAN_TYPE				= @v_plan_type
		--			AND SEQ						= @v_seq
		--			AND FROM_SITE				= @v_from_site
		--			AND ITEM_ID					= @v_item_id
		--			AND LOT_ID					= @v_lot_id
		--	;
		--END
		--MERGE INTO SSP_ANL_SHIP_PLAN_40 AS TA
		--USING (
		--		SELECT A.DIVISION_ID
		--		,      A.PLAN_START_YYYYMMDD
		--		,      A.PLAN_TYPE
		--		,      A.SEQ
		--		,      A.ITEM_ID
		--	    ,      A.FROM_SITE  
		--		,      A.MEASURE
		--		,      A.YYYYMMDD
		--		,      A.BOD_ID
		--		,      A.INCOTERMS 
		--		,      A.TRANSPORT_MODE
		--		,      A.PROJECT_CODE 
		--		,      A.FCST_TYPE
		--		,      A.CONFIRM_ID
		--		,      ISNULL(SUM(B.LOT_QTY_TOT),0) AS QTY
		--		FROM SSP_ANL_SHIP_PLAN_40 A WITH(NOLOCK) 
		--		LEFT OUTER JOIN SSP_ANL_MES_FCS_STOCK_40_C B WITH(NOLOCK) 
		--			ON  A.DIVISION_ID			= B.DIVISION_ID
		--			AND A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
		--			AND A.PLAN_TYPE				= B.PLAN_TYPE
		--			AND A.SEQ					= B.SEQ
		--			AND A.FROM_SITE				= B.FROM_SITE
		--			AND A.ITEM_ID				= B.ITEM_ID
		--			--AND B.DIVISION_ID			= @v_division_id 
		--			--AND B.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd 
		--			--AND B.FROM_SITE				= @v_from_site
		--			--AND B.ITEM_ID				= @v_item_id
		--			AND A.YYYYMMDD	=  CASE WHEN (ISNULL(B.USER_MOD_RELEASE_DATE, '') <> '29991231' AND ISNULL(B.USER_MOD_RELEASE_DATE, '') <> '') THEN B.USER_MOD_RELEASE_DATE
		--									WHEN (ISNULL(B.USER_MOD_RELEASE_DATE, '') =  '29991231') AND (ISNULL(B.QMS_HOLD_RELEASE, '') > ISNULL(B.MES_HOLD_RELEASE, '')) THEN B.QMS_HOLD_RELEASE
		--								ELSE B.MES_HOLD_RELEASE  END -- AS USER_MOD_RELEASE_DATE
		--		WHERE A.DIVISION_ID = @v_division_id  
		--		AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
		--		AND A.ITEM_ID = @v_item_id 
		--		AND a.from_site = @v_from_site 
		--		AND A.PLAN_TYPE =   @v_plan_type 
		--		AND A.SEQ = 1
		--		AND A.MEASURE = 'MES_FCS_RELEASE'
				
		--		GROUP BY  A.DIVISION_ID
		--		,      A.PLAN_START_YYYYMMDD
		--		,      A.PLAN_TYPE
		--		,      A.SEQ
		--		,      A.ITEM_ID
		--	    ,      A.FROM_SITE  
		--		,      A.MEASURE
		--		,      A.YYYYMMDD
		--		,      A.BOD_ID
		--		,      A.INCOTERMS 
		--		,      A.TRANSPORT_MODE
		--		,      A.PROJECT_CODE 
		--		,      A.FCST_TYPE
		--		,      A.CONFIRM_ID
		--) AS TB ON     (
		--            TA.DIVISION_ID         = TB.DIVISION_ID
		--		AND TA.PLAN_START_YYYYMMDD = TB.PLAN_START_YYYYMMDD
		--		AND TA.PLAN_TYPE           = TB.PLAN_TYPE          
		--		AND TA.SEQ                 = TB.SEQ                
		--		AND TA.ITEM_ID             = TB.ITEM_ID            
		--		AND TA.FROM_SITE           = TB.FROM_SITE          
		--		AND TA.MEASURE             = TB.MEASURE            
		--		AND TA.YYYYMMDD            = TB.YYYYMMDD           
		--		AND TA.BOD_ID              = TB.BOD_ID             
		--		AND TA.INCOTERMS           = TB.INCOTERMS          
		--		AND TA.TRANSPORT_MODE      = TB.TRANSPORT_MODE     
		--		AND TA.PROJECT_CODE        = TB.PROJECT_CODE       
		--		AND TA.FCST_TYPE           = TB.FCST_TYPE          
		--		AND TA.CONFIRM_ID          = TB.CONFIRM_ID         
		--			 )
		--WHEN MATCHED AND TA.QTY != TB.QTY  THEN
		--	UPDATE SET TA.QTY 					= TB.QTY
		--	           ,TA.LAST_UPDATED_BY      = @p_user_id 
		--	           ,TA.LAST_UPDATE_DATE     = SYSDATETIME();


	END


	--SELECT * FROM #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP;
	BEGIN
		MERGE INTO SSP_ANL_MES_FCS_STOCK_40_C AS TA
		USING(
			SELECT A.DIVISION_ID
			,      A.PLAN_START_YYYYMMDD
			,      A.PLAN_TYPE
			,      A.SEQ
			,      A.FROM_SITE
			,      A.ITEM_ID  
			,      A.LOT_ID
			,      A.USER_MOD_RELEASE_DATE
			,      A.REMARKS 
			,      A.USER_ID 
			FROM #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP A WITH(NOLOCK) 
		) AS TB ON  (
		        TA.DIVISION_ID         = TB.DIVISION_ID
			AND TA.PLAN_START_YYYYMMDD = TB.PLAN_START_YYYYMMDD
			AND TA.PLAN_TYPE           = TB.PLAN_TYPE          
			AND TA.SEQ                 = TB.SEQ                
			AND TA.ITEM_ID             = TB.ITEM_ID            
			AND TA.LOT_ID			   = TB.LOT_ID
			AND TA.FROM_SITE           = TB.FROM_SITE 
			AND TA.CHANGE_STATUS	   <> 'D'
			)
		WHEN MATCHED AND TA.LOT_ID = TB.LOT_ID THEN
			UPDATE SET TA.USER_MOD_RELEASE_DATE	= TB.USER_MOD_RELEASE_DATE
						,TA.REMARKS				 = TB.REMARKS
						,TA.LAST_UPDATED_BY      = TB.USER_ID 
						,TA.LAST_UPDATE_DATE     = SYSDATETIME();

	END
	BEGIN
		SET @mst_loop_cnt = 0;	 -- SSP_ANL_MES_FCS_STOCK_40_C 테이블 UPDATE 완료 후 초기화


		MERGE INTO SSP_ANL_SHIP_PLAN_40 AS TA
		USING (
				SELECT A.DIVISION_ID
				,      A.PLAN_START_YYYYMMDD
				,      A.PLAN_TYPE
				,      A.SEQ
				,      A.ITEM_ID
			    ,      A.FROM_SITE  
				,      A.MEASURE
				,      A.YYYYMMDD
				,      A.BOD_ID
				,      A.INCOTERMS 
				,      A.TRANSPORT_MODE
				,      A.PROJECT_CODE 
				,      A.FCST_TYPE
				,      A.CONFIRM_ID
				,      ISNULL(SUM(B.LOT_QTY_TOT),0) AS QTY
				,      C.USER_ID
				FROM SSP_ANL_SHIP_PLAN_40 A WITH(NOLOCK)
				
				INNER JOIN #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP C
					ON  A.DIVISION_ID = C.DIVISION_ID
					AND A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD
					AND A.PLAN_TYPE = C.PLAN_TYPE
					AND A.SEQ = C.SEQ
					AND A.FROM_SITE = C.FROM_SITE
					AND A.ITEM_ID = C.ITEM_ID

				LEFT OUTER JOIN SSP_ANL_MES_FCS_STOCK_40_C B WITH(NOLOCK) 
					ON  A.DIVISION_ID = B.DIVISION_ID
					AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
					AND A.PLAN_TYPE = B.PLAN_TYPE
					AND A.SEQ = B.SEQ
					AND C.LOT_ID = B.LOT_ID
					AND A.FROM_SITE = B.FROM_SITE
					AND A.ITEM_ID = B.ITEM_ID
					
					AND A.YYYYMMDD	=  CASE WHEN (ISNULL(B.USER_MOD_RELEASE_DATE, '') <> '29991231' AND ISNULL(B.USER_MOD_RELEASE_DATE, '') <> '') THEN B.USER_MOD_RELEASE_DATE
											WHEN (ISNULL(B.USER_MOD_RELEASE_DATE, '') =  '29991231') AND (ISNULL(B.QMS_HOLD_RELEASE, '') > ISNULL(B.MES_HOLD_RELEASE, '')) THEN B.QMS_HOLD_RELEASE
									   ELSE B.MES_HOLD_RELEASE  END -- AS USER_MOD_RELEASE_DATE

				WHERE 1=1
				-- AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd -- '20200105' --
				AND A.MEASURE = 'MES_FCS_RELEASE'
				AND A.DIVISION_ID = '40'--@v_division_id --'40'-- 
				AND A.PLAN_TYPE =   'SP'--@v_plan_type -- 'SP'--
				AND ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) AND  A.item_id       IN (@v_item_id )
				--AND A.SEQ = 1
				--AND A.ITEM_ID = @v_item_id --'MCCE121501A3'
				--and a.from_site = @v_from_site 
				GROUP BY  A.DIVISION_ID
				,      A.PLAN_START_YYYYMMDD
				,      A.PLAN_TYPE
				,      A.SEQ
				,      A.ITEM_ID
			    ,      A.FROM_SITE  
				,      A.MEASURE
				,      A.YYYYMMDD
				,      A.BOD_ID
				,      A.INCOTERMS 
				,      A.TRANSPORT_MODE
				,      A.PROJECT_CODE 
				,      A.FCST_TYPE
				,      A.CONFIRM_ID
				,      C.USER_ID
		) AS TB ON     (
		            TA.DIVISION_ID         = TB.DIVISION_ID
				AND TA.PLAN_START_YYYYMMDD = TB.PLAN_START_YYYYMMDD
				AND TA.PLAN_TYPE           = TB.PLAN_TYPE          
				AND TA.SEQ                 = TB.SEQ                
				AND TA.ITEM_ID             = TB.ITEM_ID            
				AND TA.FROM_SITE           = TB.FROM_SITE          
				AND TA.MEASURE             = TB.MEASURE            
				AND TA.YYYYMMDD            = TB.YYYYMMDD           
				AND TA.BOD_ID              = TB.BOD_ID             
				AND TA.INCOTERMS           = TB.INCOTERMS          
				AND TA.TRANSPORT_MODE      = TB.TRANSPORT_MODE     
				AND TA.PROJECT_CODE        = TB.PROJECT_CODE       
				AND TA.FCST_TYPE           = TB.FCST_TYPE          
				AND TA.CONFIRM_ID          = TB.CONFIRM_ID         
					 )
		WHEN MATCHED AND TA.QTY != TB.QTY THEN
			UPDATE SET TA.QTY 					= TB.QTY
			           ,TA.LAST_UPDATED_BY      = TB.USER_ID 
			           ,TA.LAST_UPDATE_DATE     = SYSDATETIME();

	
	END

	--WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
	--BEGIN
	--	-- @mst_loop_cnt 1증가
	--	SET @mst_loop_cnt = @mst_loop_cnt + 1;
	--	--SELECT @mst_loop_cnt,'@mst_loop_cnt'

	--	-- 각 컬럼들에 대한 스플릿처리로직 스타트
	--	BEGIN
	--		SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;
	--		SET @v_from_site = [dbo].[SCM_ARR_SPL_VAL](@p_from_site, @v_delimiter , @mst_loop_cnt) ;
	--		SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;

	--	END
	--	BEGIN
	--		IF (@temp_from_site != @v_from_site OR @temp_item_id != @v_item_id)
	--			BEGIN
	--				SET @temp_from_site = @v_from_site;
	--				SET @temp_item_id = @v_item_id;

	--				-- 재고 재 계산
	--				EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 @v_division_id, @v_item_id, @v_from_site, NULL, NULL;
	--	 		END ;
	-- 	END
	--END


	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	IF OBJECT_ID('tempdb..#TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP') IS NOT NULL	
		DROP TABLE #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP;

	-- 결과코드, 결과 카운트 반환
	SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH
	  	BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
	  END
	  -- error코드, errror 메시지 반환
	  SELECT 'F' AS result_code;
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
