

/*
 * Program ID   : PR_UI_FP02641_SAVE
 * Description  : Close Work Order
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/09   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02641_SAVE]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_first_test_wo		NVARCHAR(MAX),
  @p_vd_first_test_wo	NVARCHAR(MAX),
  @p_work_order_id		NVARCHAR(MAX)
 
AS
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED -- commit 된 데이타만 사용
    SET NOCOUNT ON    -- 처리 결과 건수                                                                                                                                                                                                                                               
	SET XACT_ABORT ON -- trasaction 처리

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02641_SAVE';
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
	
	DECLARE @v_first_test_wo		NVARCHAR(MAX);
	DECLARE @v_vd_first_test_wo	    NVARCHAR(MAX);
	DECLARE @v_work_order_id	    NVARCHAR(MAX);
	
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
							
							SET @v_first_test_wo		= [dbo].[SCM_ARR_SPL_VAL]( @p_first_test_wo			,@v_delimiter, @mst_loop_cnt);
							SET @v_vd_first_test_wo		= [dbo].[SCM_ARR_SPL_VAL]( @p_vd_first_test_wo		,@v_delimiter, @mst_loop_cnt);  
							SET @v_work_order_id		= [dbo].[SCM_ARR_SPL_VAL]( @p_work_order_id			,@v_delimiter, @mst_loop_cnt);
							
						END

						BEGIN
					
							IF (@v_sys_type = 'U' AND @v_sys_flag = 'MAIN')
							BEGIN
								
								SET @v_dSql = '';
								
								SET @v_dSql += '	BEGIN    																										' + char(10)
								SET @v_dSql += '		BEGIN TRAN                                                                                                  ' + char(10)
								SET @v_dSql += '		  UPDATE B SET                                                                                              ' + char(10)
								SET @v_dSql += '		        B.ATTRIBUTE6  = (CASE WHEN '''+ @v_first_test_wo +''' = ''1'' THEN ''Y'' ELSE ''N'' END)                       ' + char(10)
								SET @v_dSql += '		      , B.ATTRIBUTE7  = (CASE WHEN '''+ @v_vd_first_test_wo +''' = ''1'' THEN ''Y'' ELSE ''N'' END)        ' + char(10)
								SET @v_dSql += '		      , B.UPDATE_ID   = '''+ @v_user_id +'''                                                                           ' + char(10)
								SET @v_dSql += '		      , B.UPDATE_TIME = GETDATE()                                                                           ' + char(10)
								SET @v_dSql += '		  FROM  [DBO].[FP_MES_PRODUCTION_PLAN_M] B                                                                  ' + char(10)
								SET @v_dSql += '		  WHERE B.WORK_ORDER_ID = '''+ @v_work_order_id +'''                                                                   ' + char(10)
								SET @v_dSql += '		  ;                                                                                                         ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '		COMMIT;                                                                                                     ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '		BEGIN TRAN                                                                                                  ' + char(10)
								SET @v_dSql += '		  UPDATE FP_ERP_PRODUCTION_PLAN_M                                                                           ' + char(10)
								SET @v_dSql += '		  SET    FIRST_TEST_WO  = (CASE WHEN '''+ @v_first_test_wo +''' = ''1'' THEN ''Y'' ELSE ''N'' END)                     ' + char(10)
								SET @v_dSql += '		       , ATTRIBUTE2     = (CASE WHEN '''+ @v_vd_first_test_wo +''' = ''1'' THEN ''Y'' ELSE ''N'' END)                  ' + char(10)
								SET @v_dSql += '		       , UPDATE_ID      = '''+ @v_user_id +'''                                                                         ' + char(10)
								SET @v_dSql += '		       , UPDATE_TIME    = GETDATE()                                                                         ' + char(10)
								SET @v_dSql += '		  WHERE [WORK_ORDER_ID] = '''+ @v_work_order_id +'''                                                                   ' + char(10)
								SET @v_dSql += '		  ;                                                                                                         ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '		COMMIT;                                                                                                     ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '		BEGIN TRAN                                                                                                  ' + char(10)
								SET @v_dSql += '		  DECLARE @SEQ NVARCHAR(100)                                                                                ' + char(10)
								SET @v_dSql += '		  DECLARE @IF_SEQ NVARCHAR(100)                                                                                ' + char(10)
								SET @v_dSql += '		  DECLARE @IF_SEQ_TEMP NVARCHAR(100)                                                                                ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '		  SELECT @SEQ = NEXT VALUE FOR RELEASE_PLAN                                                                 ' + char(10)
								SET @v_dSql += '		  SELECT @IF_SEQ_TEMP = next value FOR [dbo].[XIF_MES_SEND_SEQ]                                             ' + char(10)
								SET @v_dSql += '		  SELECT @IF_SEQ = ''OFP0'' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE(''0'', 10 - LEN(@IF_SEQ_TEMP)) + CAST( @IF_SEQ_TEMP AS NVARCHAR)     ' + char(10)
								SET @v_dSql += '		                        ' + char(10)
								SET @v_dSql += '		  INSERT INTO [dbo].[SY_XIF_MES_WO_S] (                                                                     ' + char(10)
								SET @v_dSql += '		         [IF_SEQ]                                                                                           ' + char(10)                                                                     
								SET @v_dSql += '		        ,[IF_TYPE]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_ID]                                                                                            ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_INS_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_FLAG]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_SND_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_IF_SEQ]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_PROC_FLAG]                                                                                   ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_PROC_MSG]                                                                                    ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLAN_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLANT_ID]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[BUILNO]                                                                                           ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[LINE_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[OPERATION_ID]                                                                                     ' + char(10)                                                                                                          
								SET @v_dSql += '		        ,[EQUIPMENT_ID]                                                                                     ' + char(10)                                                           
								SET @v_dSql += '		        ,[ITEM_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[DEMAND_ID]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO]                                                                                               ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO_TYPE]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO_DETAIL]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLAN_DATE]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[START_TIME]                                                                                       ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[END_TIME]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IN_QTY]                                                                                           ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[OUT_QTY]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IS_RELEASE]                                                                                       ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[CREATE_PSN_ID]                                                                                    ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[CREATE_DATE]                                                                                      ' + char(10)                  
								SET @v_dSql += '		        ,[UPDATE_PSN_ID]                                                                                    ' + char(10)                                                 
								SET @v_dSql += '		        ,[UPDATE_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[LANE_QTY]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[UNIT]                                                                                             ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ORDER_TYPE]                                                                                       ' + char(10)
								SET @v_dSql += '		        ,[BATCH_ORDER_ID]                                                                                   ' + char(10)
								SET @v_dSql += '		        ,[SLITTER_PLANT]                                                                                    ' + char(10)                                                                                                                                              
								SET @v_dSql += '		        ,[ATTR_01]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_02]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_03]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_04]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_05]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_06]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_07]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_08]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_09]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_10]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_11]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_12]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_13]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_14]                                                                                          ' + char(10)
								SET @v_dSql += '		  )                                                                                                         ' + char(10)
								SET @v_dSql += '		  SELECT @IF_SEQ   ' + char(10)
								SET @v_dSql += '		        ,''S''                                                                                              ' + char(10)
								SET @v_dSql += '		        ,''OFP0''+''_''+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'''') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = SOURCES.FACTORY_ID ),'''') +''_''+''FP_WO''	' + char(10)
								SET @v_dSql += '		        ,GETDATE()                                                                                          ' + char(10)
								SET @v_dSql += '		        ,''N''                                                                                              ' + char(10)
								SET @v_dSql += '		        ,NULL                                                                                               ' + char(10)
								SET @v_dSql += '		        ,NULL                                                                                               ' + char(10)
								SET @v_dSql += '		        ,NULL                                                                                               ' + char(10)
								SET @v_dSql += '		        ,NULL                                                                                               ' + char(10)
								SET @v_dSql += '		        ,CONCAT(SOURCES.FP_PLAN_ID,''_00X'',@SEQ)                                                           ' + char(10)
								SET @v_dSql += '		        ,SOURCES.PLANT_ID                                                                                   ' + char(10)
								SET @v_dSql += '		        ,SOURCES.FACTORY_ID                                                                                 ' + char(10)
								SET @v_dSql += '		        ,CASE WHEN SOURCES.INSTANCE_ID = ''KR_PACK'' THEN SOURCES.LINE_ID                                   ' + char(10)
								SET @v_dSql += '		         WHEN SOURCES.B_ATTRIBUTE1 IS NOT NULL THEN                                                         ' + char(10)
								SET @v_dSql += '		         (SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_EQUIPMENT_M] C WITH(NOLOCK)                            ' + char(10)
								SET @v_dSql += '		          WHERE C.COMPANY_ID = SOURCES.B_ATTRIBUTE1                                                         ' + char(10)
								SET @v_dSql += '		          AND C.DIVISION_ID = SOURCES.B_ATTRIBUTE2                                                          ' + char(10)
								SET @v_dSql += '		          AND C.SITE_ID = SOURCES.SITE_ID                                                                   ' + char(10)
								SET @v_dSql += '		          AND C.PLANT_ID = SOURCES.B_ATTRIBUTE3                                                             ' + char(10)
								SET @v_dSql += '		          AND C.EQUIPMENT_ID = SOURCES.EQUIPMENT_ID                                                         ' + char(10)
								SET @v_dSql += '		          AND C.OPERATION_ID = SOURCES.OPERATION_ID                                                         ' + char(10)
								SET @v_dSql += '		         )                                                                                                  ' + char(10)
								SET @v_dSql += '		        ELSE (SELECT  C.MES_LINE_ID  FROM [dbo].[SCM_EQUIPMENT_M] C WITH(NOLOCK)                            ' + char(10)
								SET @v_dSql += '		           WHERE C.COMPANY_ID = SOURCES.COMPANY_ID                                                          ' + char(10)
								SET @v_dSql += '		           AND C.DIVISION_ID = SOURCES.DIVISION_ID                                                          ' + char(10)
								SET @v_dSql += '		           AND C.SITE_ID = SOURCES.SITE_ID                                                                  ' + char(10)
								SET @v_dSql += '		           AND C.PLANT_ID = SOURCES.PLANT_ID                                                                ' + char(10)
								SET @v_dSql += '		           AND C.EQUIPMENT_ID = SOURCES.EQUIPMENT_ID                                                        ' + char(10)
								SET @v_dSql += '		           AND C.OPERATION_ID = SOURCES.OPERATION_ID)                                                       ' + char(10)
								SET @v_dSql += '		         END AS MES_LINE_ID                                                                                 ' + char(10)                                                                                                                                       
								SET @v_dSql += '		        ,SOURCES.OPERATION_ID                                                                               ' + char(10)
								SET @v_dSql += '		        ,SOURCES.EQUIPMENT_ID                                                                               ' + char(10)
								SET @v_dSql += '		        ,SOURCES.ITEM_ID                                                                                    ' + char(10)
								SET @v_dSql += '		        ,SOURCES.DEMAND_ID                                                                                  ' + char(10)
								SET @v_dSql += '		        ,SOURCES.WORK_ORDER_ID                                                                              ' + char(10)
								SET @v_dSql += '		        ,CASE WHEN SOURCES.ORDER_TYPE = ''W'' THEN ''WO''                                                   ' + char(10)                                                                                                                                              
								SET @v_dSql += '		              WHEN SOURCES.ORDER_TYPE = ''M'' THEN ''MO''                                                   ' + char(10)                                                                                                                                              
								SET @v_dSql += '		              END                                                                                           ' + char(10)
								SET @v_dSql += '		        ,SOURCES.WORK_ORDER_SPL_ID                                                                          ' + char(10)
								SET @v_dSql += '		        ,CASE WHEN SOURCES.PLAN_DATE > GETDATE() AND SOURCES.PLAN_IN_QTY = 0 THEN                           ' + char(10)
								SET @v_dSql += '		         CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), '' 00:00:00'')                      ' + char(10)
								SET @v_dSql += '		        ELSE                                                                                                ' + char(10)
								SET @v_dSql += '		         CONVERT(NVARCHAR(50), SOURCES.PLAN_DATE, 120)                                                      ' + char(10)
								SET @v_dSql += '		        END AS PLAN_DATE                                                                                    ' + char(10)
								SET @v_dSql += '		        ,CASE WHEN SOURCES.PLAN_DATE > GETDATE() AND SOURCES.PLAN_IN_QTY = 0 THEN                           ' + char(10)
								SET @v_dSql += '		         CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), '' 06:00:00'')                      ' + char(10)
								SET @v_dSql += '		        ELSE                                                                                                ' + char(10)
								SET @v_dSql += '		         CONVERT(NVARCHAR(50), SOURCES.START_TIME, 120)                                                     ' + char(10)
								SET @v_dSql += '		        END AS START_TIME                                                                                   ' + char(10)
								SET @v_dSql += '		        ,CASE WHEN SOURCES.PLAN_DATE > GETDATE() AND SOURCES.PLAN_IN_QTY  = 0 THEN                          ' + char(10)
								SET @v_dSql += '		         CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), '' 06:10:00'')                      ' + char(10)
								SET @v_dSql += '		        ELSE                                                                                                ' + char(10)
								SET @v_dSql += '		         CONVERT(NVARCHAR(50), SOURCES.END_TIME, 120)                                                       ' + char(10)
								SET @v_dSql += '		        END AS END_TIME                                                                                     ' + char(10)
								SET @v_dSql += '		        ,SOURCES.OUT_QTY                                                                                    ' + char(10)
								SET @v_dSql += '		        ,SOURCES.OUT_QTY                                                                                    ' + char(10)
								SET @v_dSql += '		        ,SOURCES.FIX_TYPE                                                                                   ' + char(10)                                                                                                                         
								SET @v_dSql += '		        ,'''+ @v_user_id +'''                                                                                          ' + char(10)
								SET @v_dSql += '		        ,GETDATE()                                                                                          ' + char(10)
								SET @v_dSql += '		        ,'''+ @v_user_id +'''                                                                                          ' + char(10)
								SET @v_dSql += '		        ,GETDATE()                                                                                          ' + char(10)
								SET @v_dSql += '		        ,SOURCES.LANE_QTY                                                                                   ' + char(10)
								SET @v_dSql += '		        ,SOURCES.ITEM_UOM                                                                                   ' + char(10)
								SET @v_dSql += '		        ,SOURCES.PRODUCTION_TYPE                                                                            ' + char(10)
								SET @v_dSql += '		        ,SOURCES.[BATCH_ORDER_ID]                                                                           ' + char(10)
								SET @v_dSql += '		        ,SOURCES.[SLIT_PLANT_ID]                                                                            ' + char(10)
								SET @v_dSql += '		        ,SOURCES.BATCH_SUM_QTY                                                                              ' + char(10)
								SET @v_dSql += '		        ,SOURCES.BATCH_QTY                                                                                  ' + char(10)
								SET @v_dSql += '		        ,CASE WHEN SOURCES.BATCH_ORDER_ID != ''-'' THEN                                                     ' + char(10)
								SET @v_dSql += '		          SUM(SOURCES.PLAN_IN_QTY) OVER (PARTITION BY SOURCES.BATCH_ORDER_ID)                               ' + char(10)
								SET @v_dSql += '		         END                                                                                                ' + char(10)
								SET @v_dSql += '		        ,ISNULL(SOURCES.MARKET,''D'')                                                                       ' + char(10)
								SET @v_dSql += '		        ,SOURCES.TOP_BACK_IND                                                                               ' + char(10)
								SET @v_dSql += '		        ,SOURCES.LINK_WO                                                                                    ' + char(10)
								SET @v_dSql += '		        ,SOURCES.DETAIL_LINK_WO                                                                             ' + char(10)
								SET @v_dSql += '		        ,SOURCES.PLAN_IN_QTY AS FP_PLAN_QTY                                                          ' + char(10)
								SET @v_dSql += '		        ,SOURCES.FP_SNAP_QTY                                                                                ' + char(10)
								SET @v_dSql += '		        ,SOURCES.LINE_ID                                                                                    ' + char(10)
								SET @v_dSql += '		        ,SOURCES.PILOT_YN                                                                                   ' + char(10)
								SET @v_dSql += '		        ,SOURCES.TOP_ITEM_ID                                                                                ' + char(10)
								SET @v_dSql += '		        ,SOURCES.FIRST_TEST_WO                                                                              ' + char(10)
								SET @v_dSql += '		        ,SOURCES.VD_FIRST_TEST_WO                                                                           ' + char(10)
								SET @v_dSql += '		  FROM (                                                                                                    ' + char(10)
								SET @v_dSql += '		    SELECT MWS.INSTANCE_ID                                                                                  ' + char(10)
								SET @v_dSql += '		          ,MWS.COMPANY_ID                                                                                   ' + char(10)
								SET @v_dSql += '		          ,MWS.DIVISION_ID                                                                                  ' + char(10)
								SET @v_dSql += '		          ,MWS.SITE_ID                                                                                      ' + char(10)
								SET @v_dSql += '		          ,MWS.UPDATE_FP_PLAN_ID  AS  FP_PLAN_ID                                                            ' + char(10)
								SET @v_dSql += '		          ,MWS.PLANT_ID                                                                                     ' + char(10)
								SET @v_dSql += '		          ,MWS.FACTORY_ID                                                                                   ' + char(10)
								SET @v_dSql += '		          ,B.ATTRIBUTE1   AS B_ATTRIBUTE1                                                                   ' + char(10)
								SET @v_dSql += '		          ,B.ATTRIBUTE2   AS B_ATTRIBUTE2                                                                   ' + char(10)
								SET @v_dSql += '		          ,B.ATTRIBUTE3   AS B_ATTRIBUTE3                                                                   ' + char(10)
								SET @v_dSql += '		          ,MWS.OPERATION_ID                                                                                 ' + char(10)
								SET @v_dSql += '		          ,MWS.EQUIPMENT_ID                                                                                 ' + char(10)
								SET @v_dSql += '		          ,MWS.ELECTRODE_TYPE                                                                               ' + char(10)                                                                                                                      
								SET @v_dSql += '		          ,MWS.ITEM_ID                                                                                      ' + char(10)
								SET @v_dSql += '		          ,NULL   AS  DEMAND_ID                                                                             ' + char(10)
								SET @v_dSql += '		          ,MWS.WORK_ORDER_ID                                                                                ' + char(10)
								SET @v_dSql += '		          ,MWS.ORDER_TYPE                                                                                   ' + char(10)                                                                                                                               
								SET @v_dSql += '		          ,MWS.WORK_ORDER_SPL_ID                         ' + char(10)
								SET @v_dSql += '		  ,MWS.PLAN_IN_QTY - MWS.ACTUAL_QTY  AS  PLAN_IN_QTY                                                ' + char(10)
								SET @v_dSql += '		          ,MWS.ATTRIBUTE2 AS PLAN_DATE                                                                      ' + char(10)
								SET @v_dSql += '		          ,MWS.START_TIME                                                                                   ' + char(10)
								SET @v_dSql += '		          ,MWS.END_TIME                                                                                     ' + char(10)
								SET @v_dSql += '		          ,MWS.PLAN_IN_QTY  AS IN_QTY                                                                       ' + char(10)
								SET @v_dSql += '		          ,MWS.PLAN_QTY     AS OUT_QTY                                                                      ' + char(10)
								SET @v_dSql += '		          ,CASE WHEN MWS.FIX_TYPE = ''F'' THEN ''Y''                                                        ' + char(10)
								SET @v_dSql += '		                WHEN MWS.FIX_TYPE = ''N'' THEN ''Y''                                                        ' + char(10)
								SET @v_dSql += '		                WHEN MWS.FIX_TYPE = ''P'' THEN ''-''                                                        ' + char(10)
								SET @v_dSql += '		                ELSE FIX_TYPE END AS FIX_TYPE                                                               ' + char(10)                                                                                                                                             
								SET @v_dSql += '		          ,MWS.LANE_QTY                                                                                     ' + char(10)
								SET @v_dSql += '		          ,IM.ITEM_UOM                                                                                      ' + char(10)
								SET @v_dSql += '		          ,MWS.PRODUCTION_TYPE                                                                              ' + char(10)
								SET @v_dSql += '		          ,MWS.[BATCH_ORDER_ID]                                                                             ' + char(10)
								SET @v_dSql += '		          ,MWS.[SLIT_PLANT_ID]                                                                              ' + char(10)
								SET @v_dSql += '		          ,MWS.BATCH_SUM_QTY                                                                                ' + char(10)
								SET @v_dSql += '		          ,MWS.BATCH_QTY                                                                                    ' + char(10)
								SET @v_dSql += '		          ,MWS.MARKET                                                                                       ' + char(10)
								SET @v_dSql += '		          ,NULL AS TOP_BACK_IND                                                                             ' + char(10)
								SET @v_dSql += '		          ,NULL AS LINK_WO                                                                                  ' + char(10)
								SET @v_dSql += '		          ,NULL AS DETAIL_LINK_WO                                                                           ' + char(10)
								SET @v_dSql += '		          ,MWS.ACTUAL_QTY AS FP_SNAP_QTY                                                                    ' + char(10)
								SET @v_dSql += '		          ,MWS.LINE_ID                                                                                      ' + char(10)
								SET @v_dSql += '		          ,CASE WHEN MWS.INSTANCE_ID = ''KR_CELL_M_P'' THEN ''Y''                                           ' + char(10)
								SET @v_dSql += '		                END AS PILOT_YN                                                                             ' + char(10)
								SET @v_dSql += '		          ,MWS.ATTRIBUTE4 AS TOP_ITEM_ID              ' + char(10)
								SET @v_dSql += '		          ,MWS.ATTRIBUTE6  AS FIRST_TEST_WO                                   ' + char(10)
								SET @v_dSql += '		          ,MWS.ATTRIBUTE7  AS VD_FIRST_TEST_WO                                                              ' + char(10)
								SET @v_dSql += '		    FROM DBO.FP_MES_PRODUCTION_PLAN_M MWS WITH(NOLOCK)                                                      ' + char(10)
								SET @v_dSql += '		    LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  B WITH(NOLOCK)                                            ' + char(10)
								SET @v_dSql += '		    ON    B.LOOKUP_TYPE_CODE = ''BOM_ADD_FOR_RES_SHARE''                                                    ' + char(10)
								SET @v_dSql += '		    AND   B.SEGMENT1         = MWS.PLANT_ID                                                                 ' + char(10)
								SET @v_dSql += '		    AND   B.ACTIVE_FLAG      = ''Y''                                                                        ' + char(10)
								SET @v_dSql += '		    LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)                                                     ' + char(10)
								SET @v_dSql += '		    ON    IM.DIVISION_ID     = MWS.DIVISION_ID                                                              ' + char(10)
								SET @v_dSql += '		    AND   IM.SITE_ID         = MWS.SITE_ID                                                                  ' + char(10)
								SET @v_dSql += '		    AND   IM.ITEM_ID         = MWS.ITEM_ID                                                                  ' + char(10)
								SET @v_dSql += '		    WHERE MWS.WORK_ORDER_SPL_ID = '''+ @v_work_order_id +'''                                                           ' + char(10)
								SET @v_dSql += '		    AND   MWS.WORK_ORDER_ID     = '''+ @v_work_order_id +'''                                                           ' + char(10)
								SET @v_dSql += '		  ) SOURCES                                                                                                 ' + char(10)
								SET @v_dSql += '		  ;                                                                                                         ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '		  INSERT INTO [dbo].[SY_XIF_PDS_WO_S] (                                                                     ' + char(10)
								SET @v_dSql += '		         [IF_SEQ]                                                                                           ' + char(10)                                                                     
								SET @v_dSql += '		        ,[IF_TYPE]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_ID]                                                                                            ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_INS_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_FLAG]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_SND_DATE]                                                                              ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_IF_SEQ]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_PROC_FLAG]                                                                                   ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_PROC_MSG]                                                                                    ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLAN_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLANT_ID]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[BUILNO]                                                                                           ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[LINE_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[OPERATION_ID]                                                                                     ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[EQUIPMENT_ID]                                                                                     ' + char(10)                                                           
								SET @v_dSql += '		        ,[ITEM_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[DEMAND_ID]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO]                                                                                               ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO_TYPE]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO_DETAIL]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLAN_DATE]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[START_TIME]                                                                                       ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[END_TIME]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IN_QTY]                                                                                           ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[OUT_QTY]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IS_RELEASE]                                                                                       ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[CREATE_PSN_ID]                                                                                    ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[CREATE_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[UPDATE_PSN_ID]                                                                                    ' + char(10)                                                 
								SET @v_dSql += '		        ,[UPDATE_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[LANE_QTY]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[UNIT]                                                                                             ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ORDER_TYPE]                                                                                       ' + char(10)
								SET @v_dSql += '		        ,[BATCH_ORDER_ID]                                                                                   ' + char(10)
								SET @v_dSql += '		        ,[SLITTER_PLANT]                                                                                    ' + char(10)                                                         
								SET @v_dSql += '		        ,[ATTR_01]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_02]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_03]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_04]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_05]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_06]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_07]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_08]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_09]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_10]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_11]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_12]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_13]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_14]                                                                                          ' + char(10)
								SET @v_dSql += '		  )                                                                                                         ' + char(10)
								SET @v_dSql += '		  SELECT								                                                                    ' + char(10)
								SET @v_dSql += '		         [IF_SEQ]                                                                                           ' + char(10)                                                                     
								SET @v_dSql += '		        ,[IF_TYPE]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_ID]                                                                                            ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_INS_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_FLAG]                    ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IF_SND_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_IF_SEQ]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_PROC_FLAG]                                                                                   ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[RSLT_PROC_MSG]                                                                                    ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLAN_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLANT_ID]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[BUILNO]                                                                                           ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[LINE_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[OPERATION_ID]                                                                                     ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[EQUIPMENT_ID]                                                                                     ' + char(10)                                                           
								SET @v_dSql += '		        ,[ITEM_ID]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[DEMAND_ID]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO]                                                                                               ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[WO_TYPE]                                                                                          ' + char(10)                                                                                 
								SET @v_dSql += '		        ,[WO_DETAIL]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[PLAN_DATE]                                                                                        ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[START_TIME]                                                                                       ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[END_TIME]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IN_QTY]                                                                                           ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[OUT_QTY]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[IS_RELEASE]                                                                                       ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[CREATE_PSN_ID]                                                                                    ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[CREATE_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[UPDATE_PSN_ID]                                                                                    ' + char(10)                                                 
								SET @v_dSql += '		        ,[UPDATE_DATE]                                                                                      ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[LANE_QTY]                                                                                         ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[UNIT]                                                                                             ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ORDER_TYPE]                                                                                       ' + char(10)
								SET @v_dSql += '		        ,[BATCH_ORDER_ID]                                                                                   ' + char(10)
								SET @v_dSql += '		        ,[SLITTER_PLANT]                                                                                    ' + char(10)                                                                                                                                              
								SET @v_dSql += '		        ,[ATTR_01]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_02]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_03]                                                                                          ' + char(10)                                                                                                                                         
								SET @v_dSql += '		        ,[ATTR_04]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_05]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_06]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_07]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_08]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_09]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_10]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_11]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_12]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_13]                                                                                          ' + char(10)
								SET @v_dSql += '		        ,[ATTR_14]                                                                                          ' + char(10)
								SET @v_dSql += '		FROM	[dbo].[SY_XIF_MES_WO_S]                                                                             ' + char(10)
								SET @v_dSql += '		WHERE 1=1                                                           										' + char(10)
								SET @v_dSql += '		AND   IF_SEQ	= @IF_SEQ						                                                            ' + char(10)
								SET @v_dSql += '		AND   WO     	= '''+ @v_work_order_id +'''                                                           		' + char(10)
								SET @v_dSql += '		;                                                                                                           ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								-- history.. 20231026
								SET @v_dSql += '		INSERT INTO [dbo].[HIS_ERP_PRODUCTION_PLAN_M] ' + char(10)
								SET @v_dSql += '		( ' + char(10)
								SET @v_dSql += '			   [INSTANCE_ID] ' + char(10)
								SET @v_dSql += '		     , [COMPANY_ID] ' + char(10)
								SET @v_dSql += '		     , [DIVISION_ID] ' + char(10)
								SET @v_dSql += '		     , [SITE_ID] ' + char(10)
								SET @v_dSql += '		     , [PLANT_ID] ' + char(10)
								SET @v_dSql += '		     , [FACTORY_ID] ' + char(10)
								SET @v_dSql += '		     , [WORK_ORDER_ID] ' + char(10)
								SET @v_dSql += '		     , [BATCH_ORDER_ID] ' + char(10)
								SET @v_dSql += '		     , [ORDER_TYPE] ' + char(10)
								SET @v_dSql += '		     , [TOP_ITEM_ID] ' + char(10)
								SET @v_dSql += '		     , [ITEM_ID] ' + char(10)
								SET @v_dSql += '		     , [LANE_QTY] ' + char(10)
								SET @v_dSql += '		     , [LINE_ID] ' + char(10)
								SET @v_dSql += '		     , [OPERATION_ID] ' + char(10)
								SET @v_dSql += '		     , [ELECTRODE_TYPE] ' + char(10)
								SET @v_dSql += '		     , [WORK_CENTER_ID] ' + char(10)
								SET @v_dSql += '		     , [PLAN_DATE] ' + char(10)
								SET @v_dSql += '		     , [START_TIME] ' + char(10)
								SET @v_dSql += '		     , [END_TIME] ' + char(10)
								SET @v_dSql += '		     , [ORG_PLAN_QTY] ' + char(10)
								SET @v_dSql += '		     , [ORG_PLAN_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [PLAN_QTY] ' + char(10)
								SET @v_dSql += '		     , [PLAN_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [ROLL_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [ROLL_OUT_QTY] ' + char(10)
								SET @v_dSql += '		     , [JR_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [JR_OUT_QTY] ' + char(10)
								SET @v_dSql += '		     , [BATCH_QTY] ' + char(10)
								SET @v_dSql += '		     , [ACTUAL_QTY] ' + char(10)
								SET @v_dSql += '		     , [ACTUAL_GOOD_QTY] ' + char(10)
								SET @v_dSql += '		     , [ACTUAL_SCRAP_QTY] ' + char(10)
								SET @v_dSql += '		     , [FIX_TYPE] ' + char(10)
								SET @v_dSql += '		     , [PRODUCTION_TYPE] ' + char(10)
								SET @v_dSql += '		     , [FP_PRODUCTION_TYPE] ' + char(10)
								SET @v_dSql += '		     , [MARKET] ' + char(10)
								SET @v_dSql += '		     , [SLIT_PLANT_ID] ' + char(10)
								SET @v_dSql += '		     , [PUBLISH_TYPE] ' + char(10)
								SET @v_dSql += '		     , [WO_STATUS] ' + char(10)
								SET @v_dSql += '		     , [FIRST_TEST_WO] ' + char(10)
								SET @v_dSql += '		     , [ERP_IF_STATUS] ' + char(10)
								SET @v_dSql += '		     , [FP_IF_RETURN] ' + char(10)
								SET @v_dSql += '		     , [ERP_IF_RETURN] ' + char(10)
								SET @v_dSql += '		     , [INSERT_FP_PLAN_ID] ' + char(10)
								SET @v_dSql += '		     , [INSERT_ID] ' + char(10)
								SET @v_dSql += '		     , [INSERT_TIME] ' + char(10)
								SET @v_dSql += '		     , [UPDATE_FP_PLAN_ID] ' + char(10)
								SET @v_dSql += '		     , [UPDATE_ID] ' + char(10)
								SET @v_dSql += '		     , [UPDATE_TIME] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE1] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE2] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE3] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE4] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE5] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE6] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE7] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE8] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE9] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE10] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE11] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE12] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE13] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE14] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE15] ' + char(10)
								SET @v_dSql += '			 , [IF_SEQ] ' + char(10)
								SET @v_dSql += '		     , [JOB_USER_ID] ' + char(10)
								SET @v_dSql += '		     , [JOB_TIME] ' + char(10)
								SET @v_dSql += '		     , [JOB_TYPE] ' + char(10)
								SET @v_dSql += '		) ' + char(10)
								SET @v_dSql += '		SELECT [INSTANCE_ID] ' + char(10)
								SET @v_dSql += '		     , [COMPANY_ID] ' + char(10)
								SET @v_dSql += '		     , [DIVISION_ID] ' + char(10)
								SET @v_dSql += '		     , [SITE_ID] ' + char(10)
								SET @v_dSql += '		     , [PLANT_ID] ' + char(10)
								SET @v_dSql += '		     , [FACTORY_ID] ' + char(10)
								SET @v_dSql += '		     , [WORK_ORDER_ID] ' + char(10)
								SET @v_dSql += '		     , [BATCH_ORDER_ID] ' + char(10)
								SET @v_dSql += '		     , [ORDER_TYPE] ' + char(10)
								SET @v_dSql += '		     , [TOP_ITEM_ID] ' + char(10)
								SET @v_dSql += '		     , [ITEM_ID] ' + char(10)
								SET @v_dSql += '		     , [LANE_QTY] ' + char(10)
								SET @v_dSql += '		     , [LINE_ID] ' + char(10)
								SET @v_dSql += '		     , [OPERATION_ID] ' + char(10)
								SET @v_dSql += '		     , [ELECTRODE_TYPE] ' + char(10)
								SET @v_dSql += '		     , [WORK_CENTER_ID] ' + char(10)
								SET @v_dSql += '		     , [PLAN_DATE] ' + char(10)
								SET @v_dSql += '		     , [START_TIME] ' + char(10)
								SET @v_dSql += '		     , [END_TIME] ' + char(10)
								SET @v_dSql += '		     , [ORG_PLAN_QTY] ' + char(10)
								SET @v_dSql += '		     , [ORG_PLAN_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [PLAN_QTY] ' + char(10)
								SET @v_dSql += '		     , [PLAN_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [ROLL_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [ROLL_OUT_QTY] ' + char(10)
								SET @v_dSql += '		     , [JR_IN_QTY] ' + char(10)
								SET @v_dSql += '		     , [JR_OUT_QTY] ' + char(10)
								SET @v_dSql += '		     , [BATCH_QTY] ' + char(10)
								SET @v_dSql += '		     , [ACTUAL_QTY] ' + char(10)
								SET @v_dSql += '		     , [ACTUAL_GOOD_QTY] ' + char(10)
								SET @v_dSql += '		     , [ACTUAL_SCRAP_QTY] ' + char(10)
								SET @v_dSql += '		     , [FIX_TYPE] ' + char(10)
								SET @v_dSql += '		     , [PRODUCTION_TYPE] ' + char(10)
								SET @v_dSql += '		     , [FP_PRODUCTION_TYPE] ' + char(10)
								SET @v_dSql += '		     , [MARKET] ' + char(10)
								SET @v_dSql += '		     , [SLIT_PLANT_ID] ' + char(10)
								SET @v_dSql += '		     , [PUBLISH_TYPE] ' + char(10)
								SET @v_dSql += '		     , [WO_STATUS] ' + char(10)
								SET @v_dSql += '		     , [FIRST_TEST_WO] ' + char(10)
								SET @v_dSql += '		     , [ERP_IF_STATUS] ' + char(10)
								SET @v_dSql += '		     , [FP_IF_RETURN] ' + char(10)
								SET @v_dSql += '		     , [ERP_IF_RETURN] ' + char(10)
								SET @v_dSql += '		     , [INSERT_FP_PLAN_ID] ' + char(10)
								SET @v_dSql += '		     , [INSERT_ID] ' + char(10)
								SET @v_dSql += '		     , [INSERT_TIME] ' + char(10)
								SET @v_dSql += '		     , [UPDATE_FP_PLAN_ID] ' + char(10)
								SET @v_dSql += '		     , [UPDATE_ID] ' + char(10)
								SET @v_dSql += '		     , [UPDATE_TIME] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE1] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE2] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE3] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE4] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE5] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE6] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE7] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE8] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE9] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE10] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE11] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE12] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE13] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE14] ' + char(10)
								SET @v_dSql += '		     , [ATTRIBUTE15] ' + char(10)
								SET @v_dSql += '			 , @IF_SEQ AS IF_SEQ ' + char(10)
								SET @v_dSql += '		     , ''' + @p_user_id  + ''' AS JOB_USER_ID ' + char(10)
								SET @v_dSql += '		     , GETDATE() AS JOB_TIME ' + char(10)
								SET @v_dSql += '		     , ''WO_STATUS'' AS JOB_TYPE ' + char(10)
								SET @v_dSql += '		FROM   FP_ERP_PRODUCTION_PLAN_M A WITH(NOLOCK) ' + char(10)
								SET @v_dSql += '		WHERE  A.WORK_ORDER_ID = ''' + @v_work_order_id + ''' ' + char(10)
								SET @v_dSql += '		; ' + char(10)
								SET @v_dSql += ' ' + char(10)
								SET @v_dSql += '		COMMIT;                                                                                                     ' + char(10)
								SET @v_dSql += '		                                                                                                            ' + char(10)
								SET @v_dSql += '	END;                                ' + char(10)

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
							exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SAVE',@runstart, @runend
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

