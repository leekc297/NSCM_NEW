

/*
 * Program ID   : PR_UI_FP01630_SAVE
 * Description  : Close Work Order
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/04   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01630_SAVE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @p_company_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_line_id			NVARCHAR(MAX),
  @p_cutoff_date		NVARCHAR(MAX),
  @p_work_order_id		NVARCHAR(MAX),
  @p_work_order_spl_id	NVARCHAR(MAX),
  @p_actual_qty			NVARCHAR(MAX),
  @p_group_id			NVARCHAR(MAX)

AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP01630_SAVE';
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
	DECLARE @v_line_id			    NVARCHAR(MAX);
	DECLARE @v_cutoff_date		    NVARCHAR(MAX);
	DECLARE @v_work_order_id		NVARCHAR(MAX);  
	DECLARE @v_work_order_spl_id	NVARCHAR(MAX);  
	DECLARE @v_actual_qty			NVARCHAR(MAX);  
	DECLARE @v_group_id				NVARCHAR(MAX);  

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
							
							SET @v_company_id			= [dbo].[SCM_ARR_SPL_VAL]( @p_company_id			,@v_delimiter, @mst_loop_cnt);
							SET @v_division_id			= [dbo].[SCM_ARR_SPL_VAL]( @p_division_id			,@v_delimiter, @mst_loop_cnt);  
							SET @v_site_id				= [dbo].[SCM_ARR_SPL_VAL]( @p_site_id				,@v_delimiter, @mst_loop_cnt);
							SET @v_plant_id				= [dbo].[SCM_ARR_SPL_VAL]( @p_plant_id				,@v_delimiter, @mst_loop_cnt);
							SET @v_factory_id		    = [dbo].[SCM_ARR_SPL_VAL]( @p_factory_id			,@v_delimiter, @mst_loop_cnt);
							SET @v_line_id				= [dbo].[SCM_ARR_SPL_VAL]( @p_line_id				,@v_delimiter, @mst_loop_cnt);  
							SET @v_cutoff_date			= [dbo].[SCM_ARR_SPL_VAL]( @p_cutoff_date			,@v_delimiter, @mst_loop_cnt);
							SET @v_work_order_id		= [dbo].[SCM_ARR_SPL_VAL]( @p_work_order_id			,@v_delimiter, @mst_loop_cnt);
							SET @v_work_order_spl_id	= [dbo].[SCM_ARR_SPL_VAL]( @p_work_order_spl_id		,@v_delimiter, @mst_loop_cnt);
							SET @v_actual_qty			= [dbo].[SCM_ARR_SPL_VAL]( @p_actual_qty			,@v_delimiter, @mst_loop_cnt);
							SET @v_group_id				= [dbo].[SCM_ARR_SPL_VAL]( @p_group_id				,@v_delimiter, @mst_loop_cnt);

						END

						BEGIN
					
							IF (@v_sys_type = 'U' AND @v_sys_flag = 'MAIN')
							BEGIN
								
								SET @v_dSql = '';
								
								SET @v_dSql += '	BEGIN                      																																		' + char(10)
								SET @v_dSql += '		BEGIN TRAN                                                                                                                                                  ' + char(10)
								SET @v_dSql += '		  INSERT INTO SCM_MANUAL_WO_CREATE (                                                                                                                        ' + char(10)
								SET @v_dSql += '		         SEQ                                                                                                                                                ' + char(10)
								SET @v_dSql += '		       , STATUS                                                                                                                                             ' + char(10)
								SET @v_dSql += '		       , WO_BASE_DATE                                                                                                                                       ' + char(10)
								SET @v_dSql += '		       , FACTORY_ID                                                                                                                                         ' + char(10)
								SET @v_dSql += '		       , LINE_ID                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , OPERATION_ID                                                                                                                                       ' + char(10)
								SET @v_dSql += '		       , EQUIPMENT_ID                                                                                                                                       ' + char(10)
								SET @v_dSql += '		       , ITEM_ID                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , WO_ID                                                                                                                                              ' + char(10)
								SET @v_dSql += '		       , MO_ID                                                                                                                                              ' + char(10)
								SET @v_dSql += '		       , ORDER_TYPE                                                                                                                                         ' + char(10)
								SET @v_dSql += '		       , WO_TYPE                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , IN_QTY                                                                                                                                             ' + char(10)
								SET @v_dSql += '		       , OUT_QTY                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , MARKET                                                                                                                                             ' + char(10)
								SET @v_dSql += '		       , PROCESSING_YN                                                                                                                                      ' + char(10)
								SET @v_dSql += '		       , CREATE_DATE                                                                                                                                        ' + char(10)
								SET @v_dSql += '		       , CREATE_PSN_ID                                                                                                                                      ' + char(10)
								SET @v_dSql += '		       , UPDATE_DATE                                                                                                                                        ' + char(10)
								SET @v_dSql += '		       , UPDATE_PSN_ID                                                                                                                                      ' + char(10)
								SET @v_dSql += '		  )                                                                                                                                                         ' + char(10)
								SET @v_dSql += '		  SELECT A.SEQ + (ROW_NUMBER() OVER(PARTITION BY A.WO ORDER BY A.WO)-1) AS SEQ                                                                              ' + char(10)
								SET @v_dSql += '		       , A.STATUS, A.WO_BASE_DATE, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.EQUIPMENT_ID, A.ITEM_ID                                                       ' + char(10)
								SET @v_dSql += '		       , A.WO, A.WO_DETAIL, A.ORDER_TYPE, A.WO_TYPE, A.IN_QTY, A.OUT_QTY, A.MARKET, A.PROCESSING_YN                                                         ' + char(10)
								SET @v_dSql += '		       , A.CREATE_DATE, A.CREATE_PSN_ID, A.UPDATE_DATE, A.UPDATE_PSN_ID                                                                                     ' + char(10)
								SET @v_dSql += '		  FROM (                                                                                                                                                    ' + char(10)
								SET @v_dSql += '		      SELECT (SELECT (ISNULL(MAX(SEQ),0)+1) FROM SCM_MANUAL_WO_CREATE WHERE WO_BASE_DATE = RTRIM(LTRIM(CONVERT(VARCHAR,GETDATE(),112)))) AS SEQ             ' + char(10)
								SET @v_dSql += '		            ,(CASE WHEN CONVERT(NUMERIC,(CASE WHEN '''+ @v_actual_qty +''' = '''' THEN ''0'' ELSE '''+ @v_actual_qty +''' END)) > 0 THEN ''UPDATE'' ELSE ''DELETE'' END) AS STATUS        ' + char(10)
								SET @v_dSql += '		            ,CONVERT(VARCHAR,GETDATE(),112) AS WO_BASE_DATE                                                                                                 ' + char(10)
								SET @v_dSql += '		            ,SOURCES.BUILNO AS FACTORY_ID                                                                                                                   ' + char(10)
								SET @v_dSql += '		            ,'''+ @v_line_id +''' AS LINE_ID                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,SOURCES.OPERATION_ID                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,SOURCES.EQUIPMENT_ID                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,SOURCES.ITEM_ID                                                                                                                                ' + char(10)
								SET @v_dSql += '		            ,SOURCES.WO                                                                                                                                     ' + char(10)
								SET @v_dSql += '		            ,SOURCES.WO_DETAIL                                                                                                                              ' + char(10)
								SET @v_dSql += '		            ,SOURCES.ORDER_TYPE                                                                                                                             ' + char(10)
								SET @v_dSql += '		            ,SOURCES.WO_TYPE                                                                                                                                ' + char(10)
								SET @v_dSql += '		            ,(CASE WHEN '''+ @v_actual_qty +''' = '''' THEN ''0'' ELSE '''+ @v_actual_qty +''' END) AS IN_QTY                                                                         ' + char(10)
								SET @v_dSql += '		            ,(CASE WHEN '''+ @v_actual_qty +''' = '''' THEN ''0'' ELSE '''+ @v_actual_qty +''' END) AS OUT_QTY                                                                        ' + char(10)
								SET @v_dSql += '		            ,SOURCES.ATTR_04 AS MARKET                                                                                                                      ' + char(10)
								SET @v_dSql += '		            ,''N'' AS PROCESSING_YN                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,GETDATE() AS CREATE_DATE                                                                                                                       ' + char(10)
								SET @v_dSql += '		            ,'''+ @v_user_id +''' AS CREATE_PSN_ID                                                                                                                     ' + char(10)
								SET @v_dSql += '		            ,GETDATE() AS UPDATE_DATE                                                                                                                       ' + char(10)
								SET @v_dSql += '		            ,'''+ @v_user_id +''' AS UPDATE_PSN_ID                                                                                                                     ' + char(10)
								SET @v_dSql += '		      FROM SY_XIF_MES_WO_S SOURCES, (                                                                                                                       ' + char(10)
								SET @v_dSql += '		            SELECT IF_SEQ, B.WO, B.WO_DETAIL, ROW_NUMBER() OVER(PARTITION BY B.WO, B.WO_DETAIL ORDER BY UPDATE_DATE DESC) AS ROWNUMS                        ' + char(10)
								SET @v_dSql += '		            FROM   SY_XIF_MES_WO_S B                                                                                                                        ' + char(10)
								SET @v_dSql += '		            WHERE  B.WO        = '''+ @v_work_order_id +'''                                                                                                            ' + char(10)
								SET @v_dSql += '		            AND    B.WO_DETAIL = '''+ @v_work_order_spl_id +'''                                                                                                        ' + char(10)
								SET @v_dSql += '		            AND    B.IF_ID    != ''OFP0_OPLM_FP_WO''                                                                                                          ' + char(10)
								SET @v_dSql += '		      ) X                                                                                                                                                   ' + char(10)
								SET @v_dSql += '		      WHERE SOURCES.WO        = X.WO                                                                                                                        ' + char(10)
								SET @v_dSql += '		      AND   SOURCES.WO_DETAIL = X.WO_DETAIL                                                                                                                 ' + char(10)
								SET @v_dSql += '		      AND   SOURCES.IF_SEQ    = X.IF_SEQ                                                                                                                    ' + char(10)
								SET @v_dSql += '		      AND   X.ROWNUMS = 1                                                                                                                                   ' + char(10)
								SET @v_dSql += '		  ) A                                                                                                                                                       ' + char(10)
								SET @v_dSql += '		  ;                                                                                                                                                         ' + char(10)
								SET @v_dSql += '		                                                                                                                                                            ' + char(10)
								-- history.. 20231026
								SET @v_dSql += '		  INSERT INTO HIS_MANUAL_WO_CREATE (                                                                                                                        ' + char(10)
								SET @v_dSql += '		         SEQ                                                                                                                                                ' + char(10)
								SET @v_dSql += '		       , STATUS                                                                                                                                             ' + char(10)
								SET @v_dSql += '		       , WO_BASE_DATE                                                                                                                                       ' + char(10)
								SET @v_dSql += '		       , FACTORY_ID                                                                                                                                         ' + char(10)
								SET @v_dSql += '		       , LINE_ID                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , OPERATION_ID                                                                                                                                       ' + char(10)
								SET @v_dSql += '		       , EQUIPMENT_ID                                                                                                                                       ' + char(10)
								SET @v_dSql += '		       , ITEM_ID                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , WO_ID                                                                                                                                              ' + char(10)
								SET @v_dSql += '		       , MO_ID                                                                                                                                              ' + char(10)
								SET @v_dSql += '		       , ORDER_TYPE                                                                                                                                         ' + char(10)
								SET @v_dSql += '		       , WO_TYPE                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , IN_QTY                                                                                                                                             ' + char(10)
								SET @v_dSql += '		       , OUT_QTY                                                                                                                                            ' + char(10)
								SET @v_dSql += '		       , MARKET                                                                                                                                             ' + char(10)
								SET @v_dSql += '		       , PROCESSING_YN                                                                                                                                      ' + char(10)
								SET @v_dSql += '		       , CREATE_DATE                                                                                                                                        ' + char(10)
								SET @v_dSql += '		       , CREATE_PSN_ID                                                                                                                                      ' + char(10)
								SET @v_dSql += '		       , UPDATE_DATE                                                                                                                                        ' + char(10)
								SET @v_dSql += '		       , UPDATE_PSN_ID                                                                                                                                      ' + char(10)
								SET @v_dSql += '		       , JOB_USER_ID ' + char(10)
								SET @v_dSql += '		       , JOB_TIME ' + char(10)
								SET @v_dSql += '		       , JOB_TYPE ' + char(10)
								SET @v_dSql += '		  )                                                                                                                                                         ' + char(10)
								SET @v_dSql += '		  SELECT A.SEQ + (ROW_NUMBER() OVER(PARTITION BY A.WO ORDER BY A.WO)-1) AS SEQ                                                                              ' + char(10)
								SET @v_dSql += '		       , A.STATUS, A.WO_BASE_DATE, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.EQUIPMENT_ID, A.ITEM_ID                                                       ' + char(10)
								SET @v_dSql += '		       , A.WO, A.WO_DETAIL, A.ORDER_TYPE, A.WO_TYPE, A.IN_QTY, A.OUT_QTY, A.MARKET, A.PROCESSING_YN                                                         ' + char(10)
								SET @v_dSql += '		       , A.CREATE_DATE, A.CREATE_PSN_ID, A.UPDATE_DATE, A.UPDATE_PSN_ID                                                                                     ' + char(10)
								SET @v_dSql += '		       , ''' + @v_user_id  + ''' AS JOB_USER_ID ' + char(10)
								SET @v_dSql += '		       , GETDATE() AS JOB_TIME ' + char(10)
								SET @v_dSql += '		       , ''CLOSE_WO'' AS JOB_TYPE ' + char(10)
								SET @v_dSql += '		  FROM (                                                                                                                                                    ' + char(10)
								SET @v_dSql += '		      SELECT (SELECT (ISNULL(MAX(SEQ),0)+1) FROM SCM_MANUAL_WO_CREATE WHERE WO_BASE_DATE = RTRIM(LTRIM(CONVERT(VARCHAR,GETDATE(),112)))) AS SEQ             ' + char(10)
								SET @v_dSql += '		            ,(CASE WHEN CONVERT(NUMERIC,(CASE WHEN '''+ @v_actual_qty +''' = '''' THEN ''0'' ELSE '''+ @v_actual_qty +''' END)) > 0 THEN ''UPDATE'' ELSE ''DELETE'' END) AS STATUS        ' + char(10)
								SET @v_dSql += '		            ,CONVERT(VARCHAR,GETDATE(),112) AS WO_BASE_DATE                                                                                                 ' + char(10)
								SET @v_dSql += '		            ,SOURCES.BUILNO AS FACTORY_ID                                                                                                                   ' + char(10)
								SET @v_dSql += '		            ,'''+ @v_line_id +''' AS LINE_ID                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,SOURCES.OPERATION_ID                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,SOURCES.EQUIPMENT_ID                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,SOURCES.ITEM_ID                                                                                                                                ' + char(10)
								SET @v_dSql += '		            ,SOURCES.WO                                                                                                                                     ' + char(10)
								SET @v_dSql += '		            ,SOURCES.WO_DETAIL                                                                                                                              ' + char(10)
								SET @v_dSql += '		            ,SOURCES.ORDER_TYPE                                                                                                                             ' + char(10)
								SET @v_dSql += '		            ,SOURCES.WO_TYPE                                                                                                                                ' + char(10)
								SET @v_dSql += '		            ,(CASE WHEN '''+ @v_actual_qty +''' = '''' THEN ''0'' ELSE '''+ @v_actual_qty +''' END) AS IN_QTY                                                                         ' + char(10)
								SET @v_dSql += '		            ,(CASE WHEN '''+ @v_actual_qty +''' = '''' THEN ''0'' ELSE '''+ @v_actual_qty +''' END) AS OUT_QTY                                                                        ' + char(10)
								SET @v_dSql += '		            ,SOURCES.ATTR_04 AS MARKET                                                                                                                      ' + char(10)
								SET @v_dSql += '		            ,''N'' AS PROCESSING_YN                                                                                                                           ' + char(10)
								SET @v_dSql += '		            ,GETDATE() AS CREATE_DATE                                                                                                                       ' + char(10)
								SET @v_dSql += '		            ,'''+ @v_user_id +''' AS CREATE_PSN_ID                                                                                                                     ' + char(10)
								SET @v_dSql += '		            ,GETDATE() AS UPDATE_DATE                                                                                                                       ' + char(10)
								SET @v_dSql += '		            ,'''+ @v_user_id +''' AS UPDATE_PSN_ID                                                                                                                     ' + char(10)
								SET @v_dSql += '		      FROM SY_XIF_MES_WO_S SOURCES, (                                                                                                                       ' + char(10)
								SET @v_dSql += '		            SELECT IF_SEQ, B.WO, B.WO_DETAIL, ROW_NUMBER() OVER(PARTITION BY B.WO, B.WO_DETAIL ORDER BY UPDATE_DATE DESC) AS ROWNUMS                        ' + char(10)
								SET @v_dSql += '		            FROM   SY_XIF_MES_WO_S B                                                                                                                        ' + char(10)
								SET @v_dSql += '		            WHERE  B.WO        = '''+ @v_work_order_id +'''                                                                                                            ' + char(10)
								SET @v_dSql += '		            AND    B.WO_DETAIL = '''+ @v_work_order_spl_id +'''                                                                                                        ' + char(10)
								SET @v_dSql += '		            AND    B.IF_ID    != ''OFP0_OPLM_FP_WO''                                                                                                          ' + char(10)
								SET @v_dSql += '		      ) X                                                                                                                                                   ' + char(10)
								SET @v_dSql += '		      WHERE SOURCES.WO        = X.WO                                                                                                                        ' + char(10)
								SET @v_dSql += '		      AND   SOURCES.WO_DETAIL = X.WO_DETAIL                                                                                                                 ' + char(10)
								SET @v_dSql += '		      AND   SOURCES.IF_SEQ    = X.IF_SEQ                                                                                                                    ' + char(10)
								SET @v_dSql += '		      AND   X.ROWNUMS = 1                                                                                                                                   ' + char(10)
								SET @v_dSql += '		  ) A                                                                                                                                                       ' + char(10)
								SET @v_dSql += '		  ;                                                                                                                                                         ' + char(10)
								SET @v_dSql += ' ' + char(10)
								SET @v_dSql += '		COMMIT;                                                                                                                                                     ' + char(10)
								SET @v_dSql += '		                                                                                                                                                            ' + char(10)
								SET @v_dSql += '		BEGIN TRAN                                                                                                                                                  ' + char(10)
								SET @v_dSql += '		  UPDATE FP_MES_WORK_ORDER_STATUS_H                                                                                                                         ' + char(10)
								SET @v_dSql += '		  SET    PLAN_QTY          = ISNULL(ACTUAL_QTY,0)                                                                                                           ' + char(10)
								SET @v_dSql += '		       , PLAN_IN_QTY       = ISNULL(ACTUAL_QTY,0)                                                                                                           ' + char(10)
								SET @v_dSql += '		       , INSERT_ID         = '''+ @v_user_id +'''                                                                                                                      ' + char(10)
								SET @v_dSql += '		  WHERE  COMPANY_ID        = '''+ @v_company_id +'''                                                                                                                   ' + char(10)
								SET @v_dSql += '		  AND    DIVISION_ID       = '''+ @v_division_id +'''                                                                                                                  ' + char(10)
								SET @v_dSql += '		  AND    SITE_ID           = '''+ @v_site_id +'''                                                                                                                      ' + char(10)
								SET @v_dSql += '		  AND    PLANT_ID          = '''+ @v_plant_id +'''                                                                                                                     ' + char(10)
								SET @v_dSql += '		  AND    FACTORY_ID        = '''+ @v_factory_id +'''                                                                                                                   ' + char(10)
								SET @v_dSql += '		  AND    CUTOFF_DATE       = CONVERT(DATETIME, '''+ @v_cutoff_date +''')                                                                                               ' + char(10)
								SET @v_dSql += '		  AND    WORK_ORDER_ID     = '''+ @v_work_order_id +'''                                                                                                                ' + char(10)
								SET @v_dSql += '		  AND    WORK_ORDER_SPL_ID = '''+ @v_work_order_spl_id +'''                                                                                                            ' + char(10)
								SET @v_dSql += '		  ;                                                                                                                                                         ' + char(10)
								SET @v_dSql += '		                                                                                                                                                            ' + char(10)
								SET @v_dSql += '		COMMIT;                                                                                                                                                     ' + char(10)
								SET @v_dSql += '		                                                                                                                                                            ' + char(10)
								SET @v_dSql += '		BEGIN TRAN                                                                                                                                                  ' + char(10)
								SET @v_dSql += '		  UPDATE FP_MES_PRODUCTION_PLAN_M                                                                                                                           ' + char(10)
								SET @v_dSql += '		  SET    PLAN_QTY  = ISNULL(ACTUAL_QTY,0), PLAN_IN_QTY = ISNULL(ACTUAL_QTY,0)                                                                               ' + char(10)
								SET @v_dSql += '		       , UPDATE_ID = '''+ @v_user_id +''', UPDATE_TIME = GETDATE()                                                                                                     ' + char(10)
								SET @v_dSql += '		  WHERE  WORK_ORDER_ID     = '''+ @v_work_order_id +'''                                                                                                                ' + char(10)
								SET @v_dSql += '		  AND    WORK_ORDER_SPL_ID = '''+ @v_work_order_spl_id +'''                                                                                                            ' + char(10)
								SET @v_dSql += '		  ;                                                                                                                                                         ' + char(10)
								SET @v_dSql += '		                                                                                                                                                            ' + char(10)
								SET @v_dSql += '		COMMIT;                                                                                                                                                     ' + char(10)
								SET @v_dSql += '	                                                                                                                                                                ' + char(10)
								SET @v_dSql += '	END;                                                                                                                                                            ' + char(10)

								
							END

							IF (@v_sys_type = 'U' AND @v_sys_flag = 'NET_JOB')
							BEGIN
								SET @v_dSql = '';
								SET @v_dSql += '	UPDATE	JOB_SCHEDULE_MASTER						' + char(10)
								SET @v_dSql += '	SET		IMMEDIATE_FLAG	= ''Y''					' + char(10)
								SET @v_dSql += '	WHERE	GROUP_ID		= '''+ @v_group_id +'''	' + char(10)
								SET @v_dSql += '	;		' + char(10)
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
							exec PR_UI_SQL_LOG @v_proc_name,  @v_user_id, @v_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
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
		EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
	END CATCH   
END

