

/*
 * Program ID   : PR_UI_FP02670_SAVE
 * Description  : Slurry Batch Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/15   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02670_SAVE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_company_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX),
  @p_item_id 			NVARCHAR(MAX),
  @p_batch_lot_size 	NVARCHAR(MAX),	
  @p_lot_size_uom		NVARCHAR(MAX),
  @p_tat				NVARCHAR(MAX),
  @p_tat_uom			NVARCHAR(MAX),
  @p_active_flag		NVARCHAR(MAX),
  @p_prod_version_type	NVARCHAR(MAX),
  @p_description		NVARCHAR(MAX)

AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02670_SAVE';
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
	
	DECLARE @v_company_id			NVARCHAR(MAX);
	DECLARE @v_division_id		    NVARCHAR(MAX);
	DECLARE @v_site_id			    NVARCHAR(MAX);
	DECLARE @v_plant_id				NVARCHAR(MAX);  
	DECLARE @v_factory_id			NVARCHAR(MAX);
	DECLARE @v_operation_id			NVARCHAR(MAX);
	DECLARE @v_item_id 				NVARCHAR(MAX);
	DECLARE @v_batch_lot_size 		NVARCHAR(MAX);	
	DECLARE @v_lot_size_uom			NVARCHAR(MAX);
	DECLARE @v_tat					NVARCHAR(MAX);
	DECLARE @v_tat_uom				NVARCHAR(MAX);
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_prod_version_type	NVARCHAR(MAX);
	DECLARE @v_description			NVARCHAR(MAX);

	DECLARE @rtnCount   	        INTEGER = 0
	SET @recv_active_flag       = @p_sys_flag;
	SET @v_delimiter            = '^';  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter); -- 프로시저 LOOP 길이를 판단 

	/*
	exec PR_UI_SQL_LOG @v_proc_name,  @v_user_id, @v_sys_flag,'',@v_dSql,'RECEIVE',@runstart, @runend
	SET @v_dSql = '';
	SET @v_dSql = '-- BEGIN EXEC PR_XIF_PLM_WO_INSP_SPEC_R END -- SQL Log'
								
	--EXEC  @rtnCount = [dbo].[PR_XIF_PLM_WO_INSP_SPEC_R]
	EXEC  [dbo].[PR_XIF_PLM_WO_INSP_SPEC_R]
	*/

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
							
							SET @v_company_id			=  [dbo].[SCM_ARR_SPL_VAL]( @p_company_id			, @v_delimiter, @mst_loop_cnt );	
							SET @v_division_id		    =  [dbo].[SCM_ARR_SPL_VAL](	@p_division_id			, @v_delimiter, @mst_loop_cnt );
							SET @v_site_id			    =  [dbo].[SCM_ARR_SPL_VAL](	@p_site_id				, @v_delimiter, @mst_loop_cnt );
							SET @v_plant_id				=  [dbo].[SCM_ARR_SPL_VAL](	@p_plant_id				, @v_delimiter, @mst_loop_cnt );
							SET @v_factory_id			=  [dbo].[SCM_ARR_SPL_VAL](	@p_factory_id			, @v_delimiter, @mst_loop_cnt );
							SET @v_operation_id			=  [dbo].[SCM_ARR_SPL_VAL](	@p_operation_id			, @v_delimiter, @mst_loop_cnt );
							SET @v_item_id 				=  [dbo].[SCM_ARR_SPL_VAL](	@p_item_id 				, @v_delimiter, @mst_loop_cnt );
							SET @v_batch_lot_size 		=  [dbo].[SCM_ARR_SPL_VAL](	@p_batch_lot_size 		, @v_delimiter, @mst_loop_cnt );
							SET @v_lot_size_uom			=  [dbo].[SCM_ARR_SPL_VAL](	@p_lot_size_uom			, @v_delimiter, @mst_loop_cnt );
							SET @v_tat					=  [dbo].[SCM_ARR_SPL_VAL_WITH_NULL](	@p_tat					, @v_delimiter, @mst_loop_cnt );
							SET @v_tat_uom				=  [dbo].[SCM_ARR_SPL_VAL](	@p_tat_uom				, @v_delimiter, @mst_loop_cnt );
							SET @v_active_flag			=  [dbo].[SCM_ARR_SPL_VAL](	@p_active_flag			, @v_delimiter, @mst_loop_cnt );
							SET @v_prod_version_type	=  [dbo].[SCM_ARR_SPL_VAL](	@p_prod_version_type	, @v_delimiter, @mst_loop_cnt );
							SET @v_description			=  [dbo].[SCM_ARR_SPL_VAL](	@p_description			, @v_delimiter, @mst_loop_cnt );

						END

						

						BEGIN
					
							IF (@v_sys_type = 'U' AND @v_sys_flag = 'MAIN')
							BEGIN
								SET @v_dSql = '';
								SET @v_dSql += N'	BEGIN      																			' + char(10)			
								SET @v_dSql += N'	BEGIN TRAN                                                                          ' + char(10)
								SET @v_dSql += N'	                                                                                    ' + char(10)
								SET @v_dSql += N'	  MERGE INTO SCM_ITEM_EQUIP_RATE_BATCH_M AS A                                       ' + char(10)
								SET @v_dSql += N'	  USING (SELECT  '''+ @V_COMPANY_ID +''' AS COMPANY_ID                                         ' + char(10)
								SET @v_dSql += N'	      			,'''+ @V_DIVISION_ID +''' AS DIVISION_ID                                 ' + char(10)
								SET @v_dSql += N'	      			,'''+ @V_SITE_ID +''' AS SITE_ID                                         ' + char(10)
								SET @v_dSql += N'	      			,'''+ @V_PLANT_ID +''' AS PLANT_ID                                       ' + char(10)
								SET @v_dSql += N'	      			,'''+ @V_FACTORY_ID +''' AS FACTORY_ID                                   ' + char(10)
								SET @v_dSql += N'	      			,'''+ @V_OPERATION_ID +''' AS OPERATION_ID                               ' + char(10)
								SET @v_dSql += N'	      			,'''+ @V_ITEM_ID +''' AS ITEM_ID                                         ' + char(10)
								SET @v_dSql += N'	      			,'''+ @V_PROD_VERSION_TYPE +''' AS PROD_VERSION_TYPE                     ' + char(10)
								SET @v_dSql += N'	      				 ) AS B                                                         ' + char(10)
								SET @v_dSql += N'	    ON (A.COMPANY_ID=B.COMPANY_ID                                                   ' + char(10)
								SET @v_dSql += N'			AND A.DIVISION_ID=B.DIVISION_ID                                             ' + char(10)
								SET @v_dSql += N'			AND A.SITE_ID=B.SITE_ID                                                     ' + char(10)
								SET @v_dSql += N'			AND A.PLANT_ID=B.PLANT_ID                                                   ' + char(10)
								SET @v_dSql += N'			AND A.FACTORY_ID=B.FACTORY_ID                                               ' + char(10)
								SET @v_dSql += N'			AND A.OPERATION_ID=B.OPERATION_ID                                           ' + char(10)
								SET @v_dSql += N'			AND A.ITEM_ID=B.ITEM_ID                                                     ' + char(10)
								SET @v_dSql += N'			AND A.PROD_VERSION_TYPE=B.PROD_VERSION_TYPE                                 ' + char(10)
								SET @v_dSql += N'			)                                                                           ' + char(10)
								SET @v_dSql += N'	  WHEN MATCHED THEN                                                                 ' + char(10)
								SET @v_dSql += N'	    UPDATE SET                                                                      ' + char(10)
								SET @v_dSql += N'	         BATCH_LOT_SIZE = CONVERT(DECIMAL(20,10),'''+ @V_BATCH_LOT_SIZE +''')                 ' + char(10)
								SET @v_dSql += N'					,LOT_SIZE_UOM = '''+ @V_LOT_SIZE_UOM +'''                                     ' + char(10)
								SET @v_dSql += N'					,TAT = CONVERT(DECIMAL(20,10),'''+ @V_TAT +''')                               ' + char(10)
								SET @v_dSql += N'					,TAT_UOM = '''+ @V_TAT_UOM +'''                                               ' + char(10)
								SET @v_dSql += N'					,ACTIVE_FLAG = '''+ @V_ACTIVE_FLAG +'''                                       ' + char(10)
								SET @v_dSql += N'			,UPDATE_ID    = '''+ @V_USER_ID +'''                                                  ' + char(10)
								SET @v_dSql += N'	        ,UPDATE_TIME  = DBO.SYSDATE1()                                              ' + char(10)
								SET @v_dSql += N'	  WHEN NOT MATCHED THEN                                                             ' + char(10)
								SET @v_dSql += N'	    INSERT (                                                                        ' + char(10)
								SET @v_dSql += N'				 COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,OPERATION_ID        ' + char(10)
								SET @v_dSql += N'				,ITEM_ID,BATCH_LOT_SIZE,LOT_SIZE_UOM,TAT,TAT_UOM                        ' + char(10)
								SET @v_dSql += N'				,ACTIVE_FLAG,DESCRIPTION,INSERT_ID                                      ' + char(10)
								SET @v_dSql += N'				,INSERT_TIME,UPDATE_ID,UPDATE_TIME                                      ' + char(10)
								SET @v_dSql += N'				,PROD_VERSION_TYPE                                                      ' + char(10)
								SET @v_dSql += N'	    ) VALUES (                                                                      ' + char(10)
								SET @v_dSql += N'				 '''+ @V_COMPANY_ID +'''                                                                ' + char(10)
								SET @v_dSql += N'				,'''+ @V_DIVISION_ID +'''                                                         ' + char(10)
								SET @v_dSql += N'				,'''+ @V_SITE_ID +'''                                                             ' + char(10)
								SET @v_dSql += N'				,'''+ @V_PLANT_ID +'''                                                            ' + char(10)
								SET @v_dSql += N'				,'''+ @V_FACTORY_ID +'''                                                          ' + char(10)
								SET @v_dSql += N'				,'''+ @V_OPERATION_ID +'''                                                        ' + char(10)
								SET @v_dSql += N'				,'''+ @V_ITEM_ID +'''                                                             ' + char(10)
								SET @v_dSql += N'				,CONVERT(DECIMAL(20,10),'''+ @V_BATCH_LOT_SIZE +''')                              ' + char(10)
								SET @v_dSql += N'				,'''+ @V_LOT_SIZE_UOM +'''                                                        ' + char(10)
								SET @v_dSql += N'				,CONVERT(DECIMAL(20,10),'''+ @V_TAT +''')                                         ' + char(10)
								SET @v_dSql += N'				,'''+ @V_TAT_UOM +'''                                                             ' + char(10)
								SET @v_dSql += N'				,'''+ @V_ACTIVE_FLAG +'''                                                         ' + char(10)
								SET @v_dSql += N'				,'''+ @V_DESCRIPTION +'''                                                         ' + char(10)
								SET @v_dSql += N'				,'''+ @V_USER_ID +'''                                                             ' + char(10)
								SET @v_dSql += N'				,DBO.SYSDATE1()                                                         ' + char(10)
								SET @v_dSql += N'				,'''+ @V_USER_ID +'''                                                             ' + char(10)
								SET @v_dSql += N'				,DBO.SYSDATE1()                                                         ' + char(10)
								SET @v_dSql += N'				,'''+ @V_PROD_VERSION_TYPE +'''                                                   ' + char(10)
								SET @v_dSql += N'	    )                                                                               ' + char(10)
								SET @v_dSql += N'	  ;                                                                                 ' + char(10)
								SET @v_dSql += N'	                                                                                    ' + char(10)
								SET @v_dSql += N'	COMMIT;                                                                             ' + char(10)
								SET @v_dSql += N'	                                                                                    ' + char(10)
								SET @v_dSql += N'	BEGIN TRAN                                                                          ' + char(10)
								SET @v_dSql += N'	                                                                                    ' + char(10)
								SET @v_dSql += N'	  INSERT INTO HIS_ITEM_EQUIP_RATE_BATCH_M (                                         ' + char(10)
								SET @v_dSql += N'	          COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,OPERATION_ID           ' + char(10)
								SET @v_dSql += N'	         ,ITEM_ID,RATIO_ID,BATCH_LOT_SIZE,LOT_SIZE_UOM,TAT,TAT_UOM                  ' + char(10)
								SET @v_dSql += N'	         ,WAIT_TOLERANCE_TIME,WAIT_TOLERANCE_TIME_UOM,ACTIVE_FLAG,DESCRIPTION,INSERT_ID	' + char(10)
								SET @v_dSql += N'	         ,INSERT_TIME,UPDATE_ID,UPDATE_TIME                                         ' + char(10)
								SET @v_dSql += N'	         ,JOB_USER_ID, JOB_TIME, JOB_TYPE                                           ' + char(10)
								SET @v_dSql += N'	         ,PROD_VERSION_TYPE                                                         ' + char(10)
								SET @v_dSql += N'	  )                                                                                 ' + char(10)
								SET @v_dSql += N'	  SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,OPERATION_ID            ' + char(10)
								SET @v_dSql += N'	        ,ITEM_ID,RATIO_ID,BATCH_LOT_SIZE,LOT_SIZE_UOM,TAT,TAT_UOM                   ' + char(10)
								SET @v_dSql += N'	        ,WAIT_TOLERANCE_TIME,WAIT_TOLERANCE_TIME_UOM,ACTIVE_FLAG,DESCRIPTION,INSERT_ID	' + char(10)
								SET @v_dSql += N'	        ,INSERT_TIME,UPDATE_ID,UPDATE_TIME                                          ' + char(10)
								SET @v_dSql += N'	        ,'''+ @V_USER_ID +''' AS JOB_USER_ID, DBO.SYSDATE1() AS JOB_TIME			' + char(10)
								SET @v_dSql += N'	        , CASE WHEN INSERT_TIME = UPDATE_TIME THEN ''INSERT'' ELSE ''UPDATE'' END AS JOB_TYPE	' + char(10)
								SET @v_dSql += N'	        ,PROD_VERSION_TYPE                                                          ' + char(10)
								SET @v_dSql += N'	  FROM   SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK)                                 ' + char(10)
								SET @v_dSql += N'	  WHERE  COMPANY_ID	 = '''+ @V_COMPANY_ID +'''                                                   ' + char(10)
								SET @v_dSql += N'		AND  DIVISION_ID = '''+ @V_DIVISION_ID +'''                                           ' + char(10)
								SET @v_dSql += N'		AND  SITE_ID	 = '''+ @V_SITE_ID +'''                                                   ' + char(10)
								SET @v_dSql += N'		AND  PLANT_ID	 = '''+ @V_PLANT_ID +'''                                                 ' + char(10)
								SET @v_dSql += N'		AND  FACTORY_ID	 = '''+ @V_FACTORY_ID +'''                                             ' + char(10)
								SET @v_dSql += N'		AND  OPERATION_ID = '''+ @V_OPERATION_ID +'''                                         ' + char(10)
								SET @v_dSql += N'		AND  ITEM_ID	 = '''+ @V_ITEM_ID +'''                                                   ' + char(10)
								SET @v_dSql += N'	  ;                                                                                 ' + char(10)
								SET @v_dSql += N'	                                                                                    ' + char(10)
								SET @v_dSql += N'	COMMIT;                                                                             ' + char(10)
								SET @v_dSql += N'	                                                                                    ' + char(10)
								SET @v_dSql += N'	END;                                                                                ' + char(10)

							END

							IF (@v_sys_type = 'U' AND @v_sys_flag = 'COPY')
							BEGIN

								SET @v_dSql = '';
								SET @v_dSql += N'	BEGIN                              																' + char(10)
								SET @v_dSql += N'	                                                                                                ' + char(10)
								SET @v_dSql += N'		BEGIN TRAN                                                                                  ' + char(10)
								SET @v_dSql += N'		                                                                                            ' + char(10)
								SET @v_dSql += N'		  UPDATE SCM_ITEM_EQUIP_RATE_BATCH_M SET                                                    ' + char(10)
								SET @v_dSql += N'		         BATCH_LOT_SIZE = ISNULL(GPLM_BATCH_LOT_SIZE, BATCH_LOT_SIZE)                       ' + char(10)
								SET @v_dSql += N'		        ,UPDATE_ID      = '''+ @V_USER_ID +'''                                                        ' + char(10)
								SET @v_dSql += N'		        ,UPDATE_TIME    = dbo.SYSDATE1()                                                    ' + char(10)
								SET @v_dSql += N'		  WHERE  COMPANY_ID     = '''+ @V_COMPANY_ID +'''                                                     ' + char(10)
								SET @v_dSql += N'		  AND    DIVISION_ID    = '''+ @V_DIVISION_ID +'''                                                    ' + char(10)
								SET @v_dSql += N'		  AND    SITE_ID        = '''+ @V_SITE_ID +'''                                                        ' + char(10)
								SET @v_dSql += N'		  AND    PLANT_ID       = '''+ @V_PLANT_ID +'''                                                      ' + char(10)
								SET @v_dSql += N'		  AND    FACTORY_ID     = '''+ @V_FACTORY_ID +'''                                                     ' + char(10)
								SET @v_dSql += N'		  AND    OPERATION_ID   = '''+ @V_OPERATION_ID +'''                                                   ' + char(10)
								SET @v_dSql += N'		  AND    ITEM_ID        = '''+ @V_ITEM_ID +'''                                                        ' + char(10)
								SET @v_dSql += N'		  AND    PROD_VERSION_TYPE = '''+ @V_PROD_VERSION_TYPE +'''                                    ' + char(10)
								SET @v_dSql += N'		  ;                                                                                         ' + char(10)
								SET @v_dSql += N'		                                                                                            ' + char(10)
								SET @v_dSql += N'		COMMIT;                                                                                     ' + char(10)
								SET @v_dSql += N'		                                                                                            ' + char(10)
								SET @v_dSql += N'		BEGIN TRAN                                                                                  ' + char(10)
								SET @v_dSql += N'		  INSERT INTO HIS_ITEM_EQUIP_RATE_BATCH_M (                                                 ' + char(10)
								SET @v_dSql += N'		         COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,OPERATION_ID                    ' + char(10)
								SET @v_dSql += N'		        ,ITEM_ID,RATIO_ID,BATCH_LOT_SIZE,LOT_SIZE_UOM,TAT,TAT_UOM                           ' + char(10)
								SET @v_dSql += N'		        ,WAIT_TOLERANCE_TIME,WAIT_TOLERANCE_TIME_UOM,ACTIVE_FLAG,DESCRIPTION,INSERT_ID      ' + char(10)
								SET @v_dSql += N'		        ,INSERT_TIME,UPDATE_ID,UPDATE_TIME                                                  ' + char(10)
								SET @v_dSql += N'		        ,JOB_USER_ID, JOB_TIME, JOB_TYPE                                                    ' + char(10)
								SET @v_dSql += N'		        ,PROD_VERSION_TYPE                                                                  ' + char(10)
								SET @v_dSql += N'		  )                                                                                         ' + char(10)
								SET @v_dSql += N'		  SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,OPERATION_ID                    ' + char(10)
								SET @v_dSql += N'		        ,ITEM_ID,RATIO_ID,BATCH_LOT_SIZE,LOT_SIZE_UOM,TAT,TAT_UOM                           ' + char(10)
								SET @v_dSql += N'		        ,WAIT_TOLERANCE_TIME,WAIT_TOLERANCE_TIME_UOM,ACTIVE_FLAG,DESCRIPTION,INSERT_ID      ' + char(10)
								SET @v_dSql += N'		        ,INSERT_TIME,UPDATE_ID,UPDATE_TIME                                                  ' + char(10)
								SET @v_dSql += N'		        ,'''+ @V_USER_ID +''' as JOB_USER_ID, dbo.sysdate1() as JOB_TIME, ''UPDATE'' as JOB_TYPE      ' + char(10)
								SET @v_dSql += N'		        ,PROD_VERSION_TYPE                                                                  ' + char(10)
								SET @v_dSql += N'		  FROM   SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK)                                         ' + char(10)
								SET @v_dSql += N'		  WHERE  COMPANY_ID     = '''+ @V_COMPANY_ID +'''                                                     ' + char(10)
								SET @v_dSql += N'		  AND    DIVISION_ID    = '''+ @V_DIVISION_ID +'''                                                   ' + char(10)
								SET @v_dSql += N'		  AND    SITE_ID        = '''+ @V_SITE_ID +'''                                                       ' + char(10)
								SET @v_dSql += N'		  AND    PLANT_ID       = '''+ @V_PLANT_ID +'''                                                       ' + char(10)
								SET @v_dSql += N'		  AND    FACTORY_ID     = '''+ @V_FACTORY_ID +'''                                                     ' + char(10)
								SET @v_dSql += N'		  AND    OPERATION_ID   = '''+ @V_OPERATION_ID +'''                                                   ' + char(10)
								SET @v_dSql += N'		  AND    ITEM_ID        = '''+ @V_ITEM_ID +'''                                                        ' + char(10)
								SET @v_dSql += N'		  ;                                                                                         ' + char(10)
								SET @v_dSql += N'		                                                                                            ' + char(10)
								SET @v_dSql += N'		COMMIT;                                                                                     ' + char(10)
								SET @v_dSql += N'	                                                                                                ' + char(10)
								SET @v_dSql += N'	END;                                                                                            ' + char(10)
							
							END
							
							
							IF (@v_sys_type = 'U' AND @v_sys_flag = 'RECEIVE')
							BEGIN
								exec PR_UI_SQL_LOG @v_proc_name,  @v_user_id, @v_sys_flag,'',@v_dSql,'RECEIVE',@runstart, @runend
								SET @v_dSql = '';
								SET @v_dSql = '-- BEGIN EXEC PR_XIF_PLM_WO_INSP_SPEC_R END -- SQL Log'
								
								--EXEC  @rtnCount = [dbo].[PR_XIF_PLM_WO_INSP_SPEC_R]
								EXEC  [dbo].[PR_XIF_PLM_WO_INSP_SPEC_R]
			exec PR_UI_SQL_LOG @v_proc_name,  @v_user_id, @v_sys_flag,'',@v_dSql,'RECEIVE2',@runstart, @runend
								--SET @rtnCount = 1
								--SELECT	'Result' = @rtnCount
								
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

