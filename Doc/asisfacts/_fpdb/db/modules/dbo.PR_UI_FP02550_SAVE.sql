

/*
 * Program ID   : PR_UI_FP02550_SAVE
 * Description  : Operation BOD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/22   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02550_SAVE]
  @p_sys_type							NVARCHAR(MAX),  
  @p_sys_flag							NVARCHAR(MAX),
  @p_sys_gubun							NVARCHAR(MAX),  
  @p_user_id							NVARCHAR(MAX),

  @p_company_id							NVARCHAR(MAX),
  @p_division_id						NVARCHAR(MAX),
  @p_site_id							NVARCHAR(MAX),
  @p_plant_id							NVARCHAR(MAX),
  @p_factory_id							NVARCHAR(MAX),
  @p_operation_id						NVARCHAR(MAX),
  @p_item_id 							NVARCHAR(MAX),
  @p_operation_lot_size 				NVARCHAR(MAX),	
  @p_min_lot_size 						NVARCHAR(MAX),	
  @p_lot_size_uom 						NVARCHAR(MAX),	
  @p_precede_producing_term 			NVARCHAR(MAX),	
  @p_precede_producing_term_uom			NVARCHAR(MAX),
  @p_buffer_time						NVARCHAR(MAX),
  @p_buffer_time_uom					NVARCHAR(MAX),
  @p_initial_producing_lead_time		NVARCHAR(MAX),
  @p_initial_producing_lead_time_uom	NVARCHAR(MAX),
  @p_tat								NVARCHAR(MAX),
  @p_tat_uom							NVARCHAR(MAX),
  @p_tat_flag							NVARCHAR(MAX),
  @p_transfer_lot_size					NVARCHAR(MAX),
  @p_transfer_lot_size_uom				NVARCHAR(MAX),
  @p_tolerance							NVARCHAR(MAX),
  @p_tolerance_uom						NVARCHAR(MAX),
  @p_operation_lead_time				NVARCHAR(MAX),
  @p_operation_lead_time_uom			NVARCHAR(MAX),
  @p_model_type							NVARCHAR(MAX),
  @p_line_attr_1						NVARCHAR(MAX),
  @p_description						NVARCHAR(MAX),
  @p_active_flag						NVARCHAR(MAX)


AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02550_SAVE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	DECLARE @v_log_message	NVARCHAR(MAX) = '';
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	        INTEGER = 0;
	DECLARE @recv_active_flag       NVARCHAR(MAX);		
	DECLARE @v_delimiter            NVARCHAR(1);

	DECLARE @v_sys_type			    NVARCHAR(MAX);  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag			    NVARCHAR(MAX);  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun			NVARCHAR(MAX); 
	DECLARE @v_user_id			    NVARCHAR(MAX);
	
	DECLARE @v_company_id						NVARCHAR(MAX);
	DECLARE @v_division_id						NVARCHAR(MAX);
	DECLARE @v_site_id							NVARCHAR(MAX);
	DECLARE @v_plant_id							NVARCHAR(MAX);
	DECLARE @v_factory_id						NVARCHAR(MAX);
	DECLARE @v_operation_id						NVARCHAR(MAX);
	DECLARE @v_item_id 							NVARCHAR(MAX);
	DECLARE @v_operation_lot_size 				NVARCHAR(MAX);	
	DECLARE @v_min_lot_size 					NVARCHAR(MAX);	
	DECLARE @v_lot_size_uom 					NVARCHAR(MAX);	
	DECLARE @v_precede_producing_term 			NVARCHAR(MAX);	
	DECLARE @v_precede_producing_term_uom		NVARCHAR(MAX);
	DECLARE @v_buffer_time						NVARCHAR(MAX);
	DECLARE @v_buffer_time_uom					NVARCHAR(MAX);
	DECLARE @v_initial_producing_lead_time		NVARCHAR(MAX);
	DECLARE @v_initial_producing_lead_time_uom	NVARCHAR(MAX);
	DECLARE @v_tat								NVARCHAR(MAX);
	DECLARE @v_tat_uom							NVARCHAR(MAX);
	DECLARE @v_tat_flag							NVARCHAR(MAX);
	DECLARE @v_transfer_lot_size				NVARCHAR(MAX);
	DECLARE @v_transfer_lot_size_uom			NVARCHAR(MAX);
	DECLARE @v_tolerance						NVARCHAR(MAX);
	DECLARE @v_tolerance_uom					NVARCHAR(MAX);
	DECLARE @v_operation_lead_time				NVARCHAR(MAX);
	DECLARE @v_operation_lead_time_uom			NVARCHAR(MAX);
	DECLARE @v_model_type						NVARCHAR(MAX);
	DECLARE @v_line_attr_1						NVARCHAR(MAX);
	DECLARE @v_description						NVARCHAR(MAX);
	DECLARE @v_active_flag						NVARCHAR(MAX);


	DECLARE @rtnCount   	        INTEGER = 0
	SET @recv_active_flag       = @p_sys_flag;
	SET @v_delimiter            = '^';  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter); -- 프로시저 LOOP 길이를 판단 

	BEGIN TRY
		BEGIN TRAN		

			BEGIN 
				--max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
				WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
					BEGIN --WHILE 내(START)
					 
						BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
							
							SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

							SET @v_sys_type			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_type			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_sys_flag			    = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_flag			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_sys_gubun			= [dbo].[SCM_ARR_SPL_VAL]( @p_sys_gubun			    ,@v_delimiter, @mst_loop_cnt);
							SET @v_user_id			    = [dbo].[SCM_ARR_SPL_VAL]( @p_user_id			    ,@v_delimiter, @mst_loop_cnt);
							
							SET @v_company_id						= [dbo].[SCM_ARR_SPL_VAL]( @p_company_id						, @v_delimiter, @mst_loop_cnt );		 
							SET @v_division_id						= [dbo].[SCM_ARR_SPL_VAL]( @p_division_id						, @v_delimiter, @mst_loop_cnt );
							SET @v_site_id							= [dbo].[SCM_ARR_SPL_VAL]( @p_site_id							, @v_delimiter, @mst_loop_cnt );
							SET @v_plant_id							= [dbo].[SCM_ARR_SPL_VAL]( @p_plant_id							, @v_delimiter, @mst_loop_cnt );
							SET @v_factory_id						= [dbo].[SCM_ARR_SPL_VAL]( @p_factory_id						, @v_delimiter, @mst_loop_cnt );
							SET @v_operation_id						= [dbo].[SCM_ARR_SPL_VAL]( @p_operation_id						, @v_delimiter, @mst_loop_cnt );
							SET @v_item_id 							= [dbo].[SCM_ARR_SPL_VAL]( @p_item_id 							, @v_delimiter, @mst_loop_cnt );
							SET @v_operation_lot_size 				= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_operation_lot_size 				, @v_delimiter, @mst_loop_cnt );
							SET @v_min_lot_size 					= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_min_lot_size 						, @v_delimiter, @mst_loop_cnt );
							SET @v_lot_size_uom 					= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_lot_size_uom 						, @v_delimiter, @mst_loop_cnt );
							SET @v_precede_producing_term 			= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_precede_producing_term 			, @v_delimiter, @mst_loop_cnt );
							SET @v_precede_producing_term_uom		= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_precede_producing_term_uom		, @v_delimiter, @mst_loop_cnt );
							SET @v_buffer_time						= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_buffer_time						, @v_delimiter, @mst_loop_cnt );
							SET @v_buffer_time_uom					= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_buffer_time_uom					, @v_delimiter, @mst_loop_cnt );
							SET @v_initial_producing_lead_time		= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_initial_producing_lead_time		, @v_delimiter, @mst_loop_cnt );
							SET @v_initial_producing_lead_time_uom	= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_initial_producing_lead_time_uom	, @v_delimiter, @mst_loop_cnt );
							SET @v_tat								= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_tat								, @v_delimiter, @mst_loop_cnt );
							SET @v_tat_uom							= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_tat_uom							, @v_delimiter, @mst_loop_cnt );
							SET @v_transfer_lot_size				= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_transfer_lot_size					, @v_delimiter, @mst_loop_cnt );
							SET @v_transfer_lot_size_uom			= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_transfer_lot_size_uom				, @v_delimiter, @mst_loop_cnt );
							SET @v_tolerance						= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_tolerance							, @v_delimiter, @mst_loop_cnt );
							SET @v_tolerance_uom					= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_tolerance_uom						, @v_delimiter, @mst_loop_cnt );
							SET @v_operation_lead_time				= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_operation_lead_time				, @v_delimiter, @mst_loop_cnt );
							SET @v_operation_lead_time_uom			= [dbo].[SCM_ARR_SPL_VAL_WITH_NULL]( @p_operation_lead_time_uom			, @v_delimiter, @mst_loop_cnt );
							SET @v_model_type						= [dbo].[SCM_ARR_SPL_VAL]( @p_model_type						, @v_delimiter, @mst_loop_cnt );
							SET @v_line_attr_1						= [dbo].[SCM_ARR_SPL_VAL]( @p_line_attr_1						, @v_delimiter, @mst_loop_cnt );
							SET @v_description						= [dbo].[SCM_ARR_SPL_VAL]( @p_description						, @v_delimiter, @mst_loop_cnt );
							SET @v_active_flag						= [dbo].[SCM_ARR_SPL_VAL]( @p_active_flag						, @v_delimiter, @mst_loop_cnt );
							
						END	-- 각 컬럼들에 대한 스플릿처리로직 END
						
						SET @v_dSql = '';

						BEGIN
					
							IF (@v_sys_type = 'U' AND @v_sys_flag = 'MAIN')
							BEGIN
								
								SELECT @v_dSql += N'	BEGIN            																																																					' + char(10)
								SELECT @v_dSql += N'		  MERGE INTO SCM_OPERATION_MOVE_M AS A                                  ' + char(10)
								SELECT @v_dSql += N'		  USING ( SELECT RTRIM(LTRIM('''+ @V_COMPANY_ID +''')) AS COMPANY_ID    ' + char(10)
								SELECT @v_dSql += N'		      					,RTRIM(LTRIM('''+ @V_DIVISION_ID +''')) AS DIVISION_ID                                      ' + char(10)
								SELECT @v_dSql += N'		      					,RTRIM(LTRIM('''+ @V_SITE_ID +''')) AS SITE_ID  ' + char(10)
								SELECT @v_dSql += N'		      					,RTRIM(LTRIM('''+ @V_PLANT_ID +''')) AS PLANT_ID' + char(10)
								SELECT @v_dSql += N'		      					,RTRIM(LTRIM('''+ @V_FACTORY_ID +''')) AS FACTORY_ID                                        ' + char(10)
								SELECT @v_dSql += N'		      					,RTRIM(LTRIM('''+ @V_OPERATION_ID +''')) AS OPERATION_ID                                    ' + char(10)
								SELECT @v_dSql += N'		      					,RTRIM(LTRIM('''+ @V_MODEL_TYPE +''')) AS MODEL_TYPE                                        ' + char(10)
								SELECT @v_dSql += N'		      					,RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +''')) AS LINE_ATTR_1) AS B                                ' + char(10)
								SELECT @v_dSql += N'		    ON (A.COMPANY_ID    = B.COMPANY_ID                                  ' + char(10)
								SELECT @v_dSql += N'				AND A.DIVISION_ID   = B.DIVISION_ID                             ' + char(10)
								SELECT @v_dSql += N'				AND A.SITE_ID       = B.SITE_ID                                 ' + char(10)
								SELECT @v_dSql += N'				AND A.PLANT_ID      = B.PLANT_ID                                ' + char(10)
								SELECT @v_dSql += N'				AND A.FACTORY_ID    = B.FACTORY_ID                              ' + char(10)
								SELECT @v_dSql += N'				AND A.OPERATION_ID  = B.OPERATION_ID                            ' + char(10)
								SELECT @v_dSql += N'				AND A.MODEL_TYPE    = B.MODEL_TYPE                              ' + char(10)
								SELECT @v_dSql += N'				AND A.LINE_ATTR_1   = B.LINE_ATTR_1)                            ' + char(10)
								SELECT @v_dSql += N'		  WHEN MATCHED THEN         ' + char(10)
								SELECT @v_dSql += N'		    UPDATE SET              ' + char(10)
								SELECT @v_dSql += N'					    PRECEDE_PRODUCING_TERM      = RTRIM(LTRIM('+ ISNULL(@V_PRECEDE_PRODUCING_TERM,'NULL') +'))                     ' + char(10)
								SELECT @v_dSql += N'					   ,PRECEDE_PRODUCING_TERM_UOM	= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,BUFFER_TIME                 = RTRIM(LTRIM('+ ISNULL(@V_BUFFER_TIME,'NULL') +'))                                ' + char(10)
								SELECT @v_dSql += N'					   ,BUFFER_TIME_UOM				= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,TAT           = RTRIM(LTRIM('+ ISNULL(@V_TAT,'NULL') +'))                                        ' + char(10)
								SELECT @v_dSql += N'					   ,TAT_UOM						= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TAT_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TAT_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,OPERATION_LOT_SIZE          = RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LOT_SIZE,'NULL') +'))                         ' + char(10)
								SELECT @v_dSql += N'					   ,MIN_LOT_SIZE                = RTRIM(LTRIM('+ ISNULL(@V_MIN_LOT_SIZE,'NULL') +'))                               ' + char(10)
								SELECT @v_dSql += N'					   ,LOT_SIZE_UOM				= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,TRANSFER_LOT_SIZE           = RTRIM(LTRIM('+ ISNULL(@V_TRANSFER_LOT_SIZE,'NULL') +'))                          ' + char(10)
								SELECT @v_dSql += N'					   ,TRANSFER_LOT_SIZE_UOM       = RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,TOLERANCE                   = RTRIM(LTRIM('+ ISNULL(@V_TOLERANCE,'NULL') +'))                                  ' + char(10)
								SELECT @v_dSql += N'					   ,TOLERANCE_UOM				= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,OPERATION_LEAD_TIME         = RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LEAD_TIME,'NULL') +'))                        ' + char(10)
								SELECT @v_dSql += N'					   ,OPERATION_LEAD_TIME_UOM		= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,MODEL_TYPE                  = RTRIM(LTRIM('''+ @V_MODEL_TYPE +'''))                                 ' + char(10)
								SELECT @v_dSql += N'					   ,LINE_ATTR_1                 = RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +'''))                                ' + char(10)
								SELECT @v_dSql += N'					   ,UPDATE_ID                   = '''+ @V_USER_ID +'''      ' + char(10)
								SELECT @v_dSql += N'					   ,UPDATE_TIME                 = dbo.SYSDATE1()            ' + char(10)
								
								
								SELECT @v_dSql += N'		  WHEN NOT MATCHED THEN     ' + char(10)
								SELECT @v_dSql += N'		    INSERT (                ' + char(10)
								SELECT @v_dSql += N'						COMPANY_ID, DIVISION_ID, SITE_ID,                       ' + char(10)
								SELECT @v_dSql += N'						PLANT_ID, FACTORY_ID, OPERATION_ID,                     ' + char(10)
								SELECT @v_dSql += N'						OPERATION_LOT_SIZE, MIN_LOT_SIZE, LOT_SIZE_UOM,         ' + char(10)
								SELECT @v_dSql += N'						PRECEDE_PRODUCING_TERM, PRECEDE_PRODUCING_TERM_UOM, BUFFER_TIME, BUFFER_TIME_UOM,                   ' + char(10)
								SELECT @v_dSql += N'						INITIAL_PRODUCING_LEAD_TIME, INITIAL_PRODUCING_LEAD_TIME_UOM, TAT,                                  ' + char(10)
								SELECT @v_dSql += N'						TAT_UOM, TRANSFER_LOT_SIZE, TRANSFER_LOT_SIZE_UOM,													' + char(10)
								SELECT @v_dSql += N'						TOLERANCE, TOLERANCE_UOM,                               ' + char(10)
								SELECT @v_dSql += N'						OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM,           ' + char(10)
								SELECT @v_dSql += N'						MODEL_TYPE, LINE_ATTR_1,   ACTIVE_FLAG,                             ' + char(10)
								SELECT @v_dSql += N'						DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME                                         ' + char(10)
								SELECT @v_dSql += N'		    ) VALUES (              ' + char(10)
								SELECT @v_dSql += N'		        		RTRIM(LTRIM('''+ @V_COMPANY_ID +'''))                  ,RTRIM(LTRIM('''+ @V_DIVISION_ID +'''))                      ,RTRIM(LTRIM('''+ @V_SITE_ID +'''))        ' + char(10)
								SELECT @v_dSql += N'		        	   ,RTRIM(LTRIM('''+ @V_PLANT_ID +'''))         ,RTRIM(LTRIM('''+ @V_FACTORY_ID +'''))       ,RTRIM(LTRIM('''+ @V_OPERATION_ID +'''))                                  ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LOT_SIZE,'NULL') +'))                         ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_MIN_LOT_SIZE,'NULL') +'))                               ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_PRECEDE_PRODUCING_TERM,'NULL') +'))                     ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_BUFFER_TIME,'NULL') +'))                                ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_INITIAL_PRODUCING_LEAD_TIME,'NULL') +'))                                        ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_INITIAL_PRODUCING_LEAD_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_INITIAL_PRODUCING_LEAD_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_TAT,'NULL') +'))                                        ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TAT_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TAT_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_TRANSFER_LOT_SIZE,'NULL') +'))                          ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_TOLERANCE,'NULL') +'))                                  ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LEAD_TIME,'NULL') +'))                        ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								--SELECT @v_dSql += N'					   ,RTRIM(LTRIM('''+ @V_MODEL_TYPE +''')), RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +''')), RTRIM(LTRIM('''+ @V_ACTIVE_FLAG +'''))                      ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('''+ @V_MODEL_TYPE +''')), RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +''')), ''Y''                      ' + char(10)	-- 화면에서 넘어오지 않아 Y 로 고정 20220415 cys
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('''+ @V_DESCRIPTION +''')), '''+ @V_USER_ID +''', dbo.sysdate1(), '''+ @V_USER_ID +''', dbo.sysdate1()      ' + char(10)
								SELECT @v_dSql += N'		    )                       ' + char(10)
								SELECT @v_dSql += N'		    ;                       ' + char(10)
								SELECT @v_dSql += N'		                            ' + char(10)
								SELECT @v_dSql += N'		  INSERT INTO HIS_OPERATION_MOVE_M(                                     ' + char(10)
								SELECT @v_dSql += N'		         COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID,                                      ' + char(10)
								SELECT @v_dSql += N'		         OPERATION_LOT_SIZE, MIN_LOT_SIZE, LOT_SIZE_UOM,                ' + char(10)
								SELECT @v_dSql += N'		         PRECEDE_PRODUCING_TERM, PRECEDE_PRODUCING_TERM_UOM, BUFFER_TIME, BUFFER_TIME_UOM,                          ' + char(10)
								SELECT @v_dSql += N'		         INITIAL_PRODUCING_LEAD_TIME, INITIAL_PRODUCING_LEAD_TIME_UOM, TAT, TAT_UOM, TRANSFER_LOT_SIZE, TRANSFER_LOT_SIZE_UOM, ACTIVE_FLAG,                                         ' + char(10)
								SELECT @v_dSql += N'		  			 TOLERANCE, TOLERANCE_UOM,                                  ' + char(10)
								SELECT @v_dSql += N'		  			 OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM,              ' + char(10)
								SELECT @v_dSql += N'		  			 MODEL_TYPE, LINE_ATTR_1,                                   ' + char(10)
								SELECT @v_dSql += N'		         DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,   ' + char(10)
								SELECT @v_dSql += N'		         JOB_USER_ID, JOB_TIME, JOB_TYPE                                ' + char(10)
								SELECT @v_dSql += N'		  )                         ' + char(10)
								SELECT @v_dSql += N'		  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID,                                      ' + char(10)
								SELECT @v_dSql += N'		         OPERATION_LOT_SIZE, MIN_LOT_SIZE, LOT_SIZE_UOM,                ' + char(10)
								SELECT @v_dSql += N'		         PRECEDE_PRODUCING_TERM, PRECEDE_PRODUCING_TERM_UOM, BUFFER_TIME, BUFFER_TIME_UOM,                          ' + char(10)
								SELECT @v_dSql += N'		         INITIAL_PRODUCING_LEAD_TIME, INITIAL_PRODUCING_LEAD_TIME_UOM, TAT, TAT_UOM, TRANSFER_LOT_SIZE, TRANSFER_LOT_SIZE_UOM, ACTIVE_FLAG,                                         ' + char(10)
								SELECT @v_dSql += N'		  			 TOLERANCE, TOLERANCE_UOM,                                  ' + char(10)
								SELECT @v_dSql += N'		  			 OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM,              ' + char(10)
								SELECT @v_dSql += N'		  			 MODEL_TYPE, LINE_ATTR_1,                                   ' + char(10)
								SELECT @v_dSql += N'		         DESCRIPTION, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME,   ' + char(10)
								SELECT @v_dSql += N'		         '''+ @V_USER_ID +''', dbo.SYSDATE1(), ''EXCEL''                ' + char(10)
								SELECT @v_dSql += N'		  FROM   SCM_OPERATION_MOVE_M A WITH(NOLOCK)                            ' + char(10)
								SELECT @v_dSql += N'		  WHERE  COMPANY_ID   = RTRIM(LTRIM('''+ @V_COMPANY_ID +'''))           ' + char(10)
								SELECT @v_dSql += N'		  AND    DIVISION_ID  = RTRIM(LTRIM('''+ @V_DIVISION_ID +'''))          ' + char(10)
								SELECT @v_dSql += N'		  AND    SITE_ID      = RTRIM(LTRIM('''+ @V_SITE_ID +'''))              ' + char(10)
								SELECT @v_dSql += N'		  AND    PLANT_ID     = RTRIM(LTRIM('''+ @V_PLANT_ID +'''))             ' + char(10)
								SELECT @v_dSql += N'		  AND    FACTORY_ID   = RTRIM(LTRIM('''+ @V_FACTORY_ID +'''))           ' + char(10)
								SELECT @v_dSql += N'		  AND    OPERATION_ID = RTRIM(LTRIM('''+ @V_OPERATION_ID +'''))         ' + char(10)
								SELECT @v_dSql += N'		  AND    MODEL_TYPE   = RTRIM(LTRIM('''+ @V_MODEL_TYPE +'''))           ' + char(10)
								SELECT @v_dSql += N'		  AND    LINE_ATTR_1  = RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +'''))          ' + char(10)
								SELECT @v_dSql += N'		  ;                         ' + char(10)
								SELECT @v_dSql += N'	                                ' + char(10)
								SELECT @v_dSql += N'	END;                            ' + char(10)

							END

							IF (@v_sys_type IN ('U', 'I') AND @v_sys_flag = 'SUB')
							BEGIN

								SELECT @v_dSql += N'	BEGIN                                       																																' + char(10)
								SELECT @v_dSql += N'		MERGE INTO SCM_ITEM_FLOW_EXCEPT_M A       ' + char(10)
								SELECT @v_dSql += N'		USING           ' + char(10)
								SELECT @v_dSql += N'		  (SELECT RTRIM(LTRIM('''+ @V_COMPANY_ID +''')) as COMPANY_ID, RTRIM(LTRIM('''+ @V_DIVISION_ID +''')) as DIVISION_ID, RTRIM(LTRIM('''+ @V_SITE_ID +''')) as SITE_ID     ' + char(10)
								SELECT @v_dSql += N'		  		 ,RTRIM(LTRIM('''+ @V_PLANT_ID +''')) as PLANT_ID, RTRIM(LTRIM('''+ @V_FACTORY_ID +''')) as FACTORY_ID              ' + char(10)
								SELECT @v_dSql += N'		         ,RTRIM(LTRIM('''+ @V_ITEM_ID +''')) as ITEM_ID, RTRIM(LTRIM('''+ @V_OPERATION_ID +''')) as OPERATION_ID            ' + char(10)
								SELECT @v_dSql += N'		         ,RTRIM(LTRIM('''+ @V_MODEL_TYPE +''')) as MODEL_TYPE, RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +''')) as LINE_ATTR_1) B     ' + char(10)
								SELECT @v_dSql += N'		  ON (A.COMPANY_ID    = B.COMPANY_ID                        ' + char(10)
								SELECT @v_dSql += N'		  AND A.DIVISION_ID   = B.DIVISION_ID                       ' + char(10)
								SELECT @v_dSql += N'		  AND A.SITE_ID       = B.SITE_ID                           ' + char(10)
								SELECT @v_dSql += N'		  AND A.PLANT_ID      = B.PLANT_ID                          ' + char(10)
								SELECT @v_dSql += N'		  AND A.FACTORY_ID    = B.FACTORY_ID                        ' + char(10)
								SELECT @v_dSql += N'		  AND A.ITEM_ID       = B.ITEM_ID                           ' + char(10)
								SELECT @v_dSql += N'		  AND A.OPERATION_ID  = B.OPERATION_ID                      ' + char(10)
								SELECT @v_dSql += N'		  AND A.LINE_ATTR_1   = B.LINE_ATTR_1                       ' + char(10)
								SELECT @v_dSql += N'		  AND A.MODEL_TYPE    = B.MODEL_TYPE)                       ' + char(10)
								SELECT @v_dSql += N'		WHEN MATCHED THEN                                           ' + char(10)
								SELECT @v_dSql += N'		  UPDATE SET    ' + char(10)
								SELECT @v_dSql += N'					    PRECEDE_PRODUCING_TERM      = RTRIM(LTRIM('+ ISNULL(@V_PRECEDE_PRODUCING_TERM,'NULL') +'))                     ' + char(10)
								SELECT @v_dSql += N'					   ,PRECEDE_PRODUCING_TERM_UOM	= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,BUFFER_TIME                 = RTRIM(LTRIM('+ ISNULL(@V_BUFFER_TIME,'NULL') +'))                                ' + char(10)
								SELECT @v_dSql += N'					   ,BUFFER_TIME_UOM				= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,TAT                         = RTRIM(LTRIM('+ ISNULL(@V_TAT,'NULL') +'))                                        ' + char(10)
								SELECT @v_dSql += N'					   ,TAT_UOM						= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TAT_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TAT_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,OPERATION_LOT_SIZE          = RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LOT_SIZE,'NULL') +'))                         ' + char(10)
								SELECT @v_dSql += N'					   ,MIN_LOT_SIZE                = RTRIM(LTRIM('+ ISNULL(@V_MIN_LOT_SIZE,'NULL') +'))                               ' + char(10)
								SELECT @v_dSql += N'					   ,LOT_SIZE_UOM				= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,TRANSFER_LOT_SIZE           = RTRIM(LTRIM('+ ISNULL(@V_TRANSFER_LOT_SIZE,'NULL') +'))                          ' + char(10)
								SELECT @v_dSql += N'					   ,TRANSFER_LOT_SIZE_UOM       = RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,TOLERANCE                   = RTRIM(LTRIM('+ ISNULL(@V_TOLERANCE,'NULL') +'))                                  ' + char(10)
								SELECT @v_dSql += N'					   ,TOLERANCE_UOM				= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,OPERATION_LEAD_TIME         = RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LEAD_TIME,'NULL') +'))                        ' + char(10)
								SELECT @v_dSql += N'					   ,OPERATION_LEAD_TIME_UOM		= RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'		     ,UPDATE_ID                   = '''+ @V_USER_ID +'''    ' + char(10)
								SELECT @v_dSql += N'		     ,UPDATE_TIME                 = dbo.SYSDATE1()          ' + char(10)
								SELECT @v_dSql += N'		WHEN NOT MATCHED THEN                                       ' + char(10)
								SELECT @v_dSql += N'		  INSERT (      ' + char(10)
								SELECT @v_dSql += N'		     COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID     ' + char(10)
								SELECT @v_dSql += N'			,ITEM_ID,OPERATION_ID                                   ' + char(10)
								SELECT @v_dSql += N'			,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM           ' + char(10)
								SELECT @v_dSql += N'			,BUFFER_TIME,BUFFER_TIME_UOM                            ' + char(10)
								SELECT @v_dSql += N'			,TAT,TAT_UOM,TAT_FLAG                                   ' + char(10)
								SELECT @v_dSql += N'			,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM      ' + char(10)
								SELECT @v_dSql += N'			,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM                ' + char(10)
								SELECT @v_dSql += N'			,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM                ' + char(10)
								SELECT @v_dSql += N'			,TOLERANCE, TOLERANCE_UOM                               ' + char(10)
								SELECT @v_dSql += N'			,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM           ' + char(10)
								SELECT @v_dSql += N'			,MODEL_TYPE, LINE_ATTR_1                                ' + char(10)
								SELECT @v_dSql += N'			,ACTIVE_FLAG' + char(10)
								SELECT @v_dSql += N'			,DESCRIPTION' + char(10)
								SELECT @v_dSql += N'		    ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME         ' + char(10)
								SELECT @v_dSql += N'		  )             ' + char(10)
								SELECT @v_dSql += N'		  VALUES(       ' + char(10)

								SELECT @v_dSql += N'		        		RTRIM(LTRIM('''+ @V_COMPANY_ID +'''))                  ,RTRIM(LTRIM('''+ @V_DIVISION_ID +'''))                      ,RTRIM(LTRIM('''+ @V_SITE_ID +'''))        ' + char(10)
								SELECT @v_dSql += N'		        	   ,RTRIM(LTRIM('''+ @V_PLANT_ID +'''))         ,RTRIM(LTRIM('''+ @V_FACTORY_ID +'''))                                     ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('''+ @V_ITEM_ID +'''))                    ,RTRIM(LTRIM('''+ @V_OPERATION_ID +'''))                         ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LOT_SIZE,'NULL') +'))                         ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_MIN_LOT_SIZE,'NULL') +'))                               ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_BUFFER_TIME,'NULL') +'))                                ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_BUFFER_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_TAT,'NULL') +'))                                        ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TAT_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TAT_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TAT_FLAG,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TAT_FLAG,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_PRECEDE_PRODUCING_TERM,'NULL') +'))                     ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_PRECEDE_PRODUCING_TERM_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_INITIAL_PRODUCING_LEAD_TIME,'NULL') +'))                                        ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_INITIAL_PRODUCING_LEAD_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_INITIAL_PRODUCING_LEAD_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_TRANSFER_LOT_SIZE,'NULL') +'))                          ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TRANSFER_LOT_SIZE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_TOLERANCE,'NULL') +'))                                  ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_TOLERANCE_UOM,'NULL') +''' END ))   ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('+ ISNULL(@V_OPERATION_LEAD_TIME,'NULL') +'))                        ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM( CASE WHEN ''NULL'' = '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' THEN NULL ELSE '''+ ISNULL(@V_OPERATION_LEAD_TIME_UOM,'NULL') +''' END ))   ' + char(10)
								--SELECT @v_dSql += N'					   ,RTRIM(LTRIM('''+ @V_MODEL_TYPE +''')), RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +''')), RTRIM(LTRIM('''+ @V_ACTIVE_FLAG +'''))                      ' + char(10)
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('''+ @V_MODEL_TYPE +''')), RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +''')), ''Y''                      ' + char(10) -- 화면에서 넘어오지 않아 Y 로 고정 20220415 cys
								SELECT @v_dSql += N'					   ,RTRIM(LTRIM('''+ @V_DESCRIPTION +''')), '''+ @V_USER_ID +''', dbo.sysdate1(), '''+ @V_USER_ID +''', dbo.sysdate1()      ' + char(10)
								SELECT @v_dSql += N'		  )             ' + char(10)
								SELECT @v_dSql += N'		;               ' + char(10)
								SELECT @v_dSql += N'		                ' + char(10)
								SELECT @v_dSql += N'		INSERT INTO HIS_ITEM_FLOW_EXCEPT_M (                        ' + char(10)
								SELECT @v_dSql += N'				COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID  ' + char(10)
								SELECT @v_dSql += N'				,ITEM_ID,OPERATION_ID                               ' + char(10)
								SELECT @v_dSql += N'				,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM,BUFFER_TIME,BUFFER_TIME_UOM                                           ' + char(10)
								SELECT @v_dSql += N'				,TAT,TAT_UOM,TAT_FLAG                               ' + char(10)
								SELECT @v_dSql += N'				,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM  ' + char(10)
								SELECT @v_dSql += N'				,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM            ' + char(10)
								SELECT @v_dSql += N'				,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM            ' + char(10)
								SELECT @v_dSql += N'				,ACTIVE_FLAG                                        ' + char(10)
								SELECT @v_dSql += N'				,DESCRIPTION                                        ' + char(10)
								SELECT @v_dSql += N'				,TOLERANCE, TOLERANCE_UOM                           ' + char(10)
								SELECT @v_dSql += N'				,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM       ' + char(10)
								SELECT @v_dSql += N'				,MODEL_TYPE, LINE_ATTR_1                            ' + char(10)
								SELECT @v_dSql += N'				,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME     ' + char(10)
								SELECT @v_dSql += N'				,JOB_USER_ID, JOB_TIME, JOB_TYPE                    ' + char(10)
								SELECT @v_dSql += N'		)               ' + char(10)
								SELECT @v_dSql += N'		SELECT 	COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID  ' + char(10)
								SELECT @v_dSql += N'				,ITEM_ID,OPERATION_ID                               ' + char(10)
								SELECT @v_dSql += N'				,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM,BUFFER_TIME,BUFFER_TIME_UOM                                           ' + char(10)
								SELECT @v_dSql += N'				,TAT,TAT_UOM,TAT_FLAG                               ' + char(10)
								SELECT @v_dSql += N'				,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM  ' + char(10)
								SELECT @v_dSql += N'				,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM            ' + char(10)
								SELECT @v_dSql += N'				,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM            ' + char(10)
								SELECT @v_dSql += N'				,ACTIVE_FLAG                                        ' + char(10)
								SELECT @v_dSql += N'				,DESCRIPTION                                        ' + char(10)
								SELECT @v_dSql += N'				,TOLERANCE, TOLERANCE_UOM                           ' + char(10)
								SELECT @v_dSql += N'				,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM       ' + char(10)
								SELECT @v_dSql += N'				,MODEL_TYPE, LINE_ATTR_1                            ' + char(10)
								SELECT @v_dSql += N'				,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME     ' + char(10)
								SELECT @v_dSql += N'				,'''+ @V_USER_ID +''', dbo.SYSDATE1(), ''EXCEL''    ' + char(10)
								SELECT @v_dSql += N'		FROM  SCM_ITEM_FLOW_EXCEPT_M A(NOLOCK)                      ' + char(10)
								SELECT @v_dSql += N'		WHERE COMPANY_ID    = RTRIM(LTRIM('''+ @V_COMPANY_ID +''')) ' + char(10)
								SELECT @v_dSql += N'		AND   DIVISION_ID   = RTRIM(LTRIM('''+ @V_DIVISION_ID +'''))' + char(10)
								SELECT @v_dSql += N'		AND   SITE_ID       = RTRIM(LTRIM('''+ @V_SITE_ID +'''))    ' + char(10)
								SELECT @v_dSql += N'		AND   PLANT_ID      = RTRIM(LTRIM('''+ @V_PLANT_ID +'''))   ' + char(10)
								SELECT @v_dSql += N'		AND   FACTORY_ID    = RTRIM(LTRIM('''+ @V_FACTORY_ID +''')) ' + char(10)
								SELECT @v_dSql += N'		AND   ITEM_ID       = RTRIM(LTRIM('''+ @V_ITEM_ID +'''))    ' + char(10)
								SELECT @v_dSql += N'		AND   OPERATION_ID  = RTRIM(LTRIM('''+ @V_OPERATION_ID +'''))                   ' + char(10)
								SELECT @v_dSql += N'		AND   MODEL_TYPE    = RTRIM(LTRIM('''+ @V_MODEL_TYPE +''')) ' + char(10)
								SELECT @v_dSql += N'		AND   LINE_ATTR_1   = RTRIM(LTRIM('''+ @V_LINE_ATTR_1 +'''))' + char(10)
								SELECT @v_dSql += N'		;               ' + char(10)
								SELECT @v_dSql += N'	                    ' + char(10)
								SELECT @v_dSql += N'	END;                ' + char(10)
							
							END
							
							IF (@v_sys_type = 'D' AND @v_sys_flag = 'SUB')
							BEGIN

								SELECT @v_dSql += N'	BEGIN																					' + char(10)
								SELECT @v_dSql += N'		INSERT INTO HIS_ITEM_FLOW_EXCEPT_M (    ' + char(10)
								SELECT @v_dSql += N'		       COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID                           ' + char(10)
								SELECT @v_dSql += N'		      ,ITEM_ID,OPERATION_ID             ' + char(10)
								SELECT @v_dSql += N'		      ,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM,BUFFER_TIME,BUFFER_TIME_UOM     ' + char(10)
								SELECT @v_dSql += N'		      ,TAT,TAT_UOM,TAT_FLAG             ' + char(10)
								SELECT @v_dSql += N'		      ,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM                            ' + char(10)
								SELECT @v_dSql += N'		      ,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM                  ' + char(10)
								SELECT @v_dSql += N'			      ,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM                                  ' + char(10)
								SELECT @v_dSql += N'		      ,ACTIVE_FLAG                      ' + char(10)
								SELECT @v_dSql += N'					,TOLERANCE, TOLERANCE_UOM   ' + char(10)
								SELECT @v_dSql += N'					,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM                           ' + char(10)
								SELECT @v_dSql += N'					,MODEL_TYPE, LINE_ATTR_1    ' + char(10)
								SELECT @v_dSql += N'		      ,DESCRIPTION                      ' + char(10)
								SELECT @v_dSql += N'		      ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME                               ' + char(10)
								SELECT @v_dSql += N'		      ,JOB_USER_ID, JOB_TIME, JOB_TYPE  ' + char(10)
								SELECT @v_dSql += N'		)                                       ' + char(10)
								SELECT @v_dSql += N'		SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID                           ' + char(10)
								SELECT @v_dSql += N'		      ,ITEM_ID,OPERATION_ID             ' + char(10)
								SELECT @v_dSql += N'		      ,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM,BUFFER_TIME,BUFFER_TIME_UOM     ' + char(10)
								SELECT @v_dSql += N'		      ,TAT,TAT_UOM,TAT_FLAG             ' + char(10)
								SELECT @v_dSql += N'		      ,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM                            ' + char(10)
								SELECT @v_dSql += N'		      ,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM                  ' + char(10)
								SELECT @v_dSql += N'			        ,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM                                ' + char(10)
								SELECT @v_dSql += N'		      ,ACTIVE_FLAG                      ' + char(10)
								SELECT @v_dSql += N'					,TOLERANCE, TOLERANCE_UOM   ' + char(10)
								SELECT @v_dSql += N'					,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM                           ' + char(10)
								SELECT @v_dSql += N'					,MODEL_TYPE, LINE_ATTR_1    ' + char(10)
								SELECT @v_dSql += N'		      ,DESCRIPTION                      ' + char(10)
								SELECT @v_dSql += N'		      ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME                               ' + char(10)
								SELECT @v_dSql += N'		      ,'''+ @V_USER_ID +''' , dbo.SYSDATE1(), ''DELETE''                            ' + char(10)
								SELECT @v_dSql += N'		FROM  SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)                                         ' + char(10)
								SELECT @v_dSql += N'		WHERE COMPANY_ID   = '''+ @V_COMPANY_ID +'''                                        ' + char(10)
								SELECT @v_dSql += N'		AND   DIVISION_ID  = '''+ @V_DIVISION_ID +'''                                       ' + char(10)
								SELECT @v_dSql += N'		AND   SITE_ID      = '''+ @V_SITE_ID +'''                                           ' + char(10)
								SELECT @v_dSql += N'		AND   PLANT_ID     = '''+ @V_PLANT_ID +'''                                          ' + char(10)
								SELECT @v_dSql += N'		AND   FACTORY_ID   = '''+ @V_FACTORY_ID +'''                                        ' + char(10)
								SELECT @v_dSql += N'		AND   ITEM_ID      = '''+ @V_ITEM_ID +'''                                           ' + char(10)
								SELECT @v_dSql += N'		AND   OPERATION_ID = '''+ @V_OPERATION_ID +'''                                      ' + char(10)
								SELECT @v_dSql += N'		AND   MODEL_TYPE   = '''+ @V_MODEL_TYPE +'''                                        ' + char(10)
								SELECT @v_dSql += N'		AND   LINE_ATTR_1  = '''+ @V_LINE_ATTR_1 +'''                                       ' + char(10)
								SELECT @v_dSql += N'		;                                       ' + char(10)
								SELECT @v_dSql += N'		                                        ' + char(10)
								SELECT @v_dSql += N'		DELETE FROM SCM_ITEM_FLOW_EXCEPT_M      ' + char(10)
								SELECT @v_dSql += N'		WHERE  COMPANY_ID   = '''+ @V_COMPANY_ID +'''                                       ' + char(10)
								SELECT @v_dSql += N'		AND    DIVISION_ID  = '''+ @V_DIVISION_ID +'''                                      ' + char(10)
								SELECT @v_dSql += N'		AND    SITE_ID      = '''+ @V_SITE_ID +'''                                          ' + char(10)
								SELECT @v_dSql += N'		AND    PLANT_ID     = '''+ @V_PLANT_ID +'''                                         ' + char(10)
								SELECT @v_dSql += N'		AND    FACTORY_ID   = '''+ @V_FACTORY_ID +'''                                       ' + char(10)
								SELECT @v_dSql += N'		AND    ITEM_ID      = '''+ @V_ITEM_ID +'''                                          ' + char(10)
								SELECT @v_dSql += N'		AND    OPERATION_ID = '''+ @V_OPERATION_ID +'''                                     ' + char(10)
								SELECT @v_dSql += N'		AND    MODEL_TYPE   = '''+ @V_MODEL_TYPE +'''                                       ' + char(10)
								SELECT @v_dSql += N'		AND    LINE_ATTR_1  = '''+ @V_LINE_ATTR_1 +'''                                      ' + char(10)
								SELECT @v_dSql += N'		;                                       ' + char(10)
								SELECT @v_dSql += N'	' + char(10)
								SELECT @v_dSql += N'	END;                                        ' + char(10)

							END

						END
	
						IF @p_sys_type = 'SQL'
						BEGIN
							select @v_dSql as [QUERY_VALUE]
						END ELSE BEGIN
							SET @runstart = GetDate()
							BEGIN TRY
									BEGIN TRAN
										exec sp_executesql @v_dSql
									COMMIT TRAN
							END TRY
							BEGIN CATCH
									ROLLBACK
							END CATCH
							SET @runend = GetDate()
							exec PR_UI_SQL_LOG @v_proc_name,  @v_user_id, @v_sys_flag,'',@v_dSql,'SAVE',@runstart, @runend
						END

					END --WHILE 내(END)
			END
 		
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
END

