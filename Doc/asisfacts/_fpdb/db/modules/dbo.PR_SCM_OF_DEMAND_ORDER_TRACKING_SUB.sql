--USE [LGCE_FP_TR]

CREATE PROCEDURE [dbo].[PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB]
  @p_master_id nvarchar(MAX) = '-'
, @p_plan_id nvarchar(MAX) = '-'
, @p_basic_plan_id nvarchar(MAX) = '-'
, @p_operation_id nvarchar(MAX) = '-'
, @p_seq	Integer = 0
, @p_flag	nvarchar(10) = '0'
, @p_demand_pegging_id nvarchar(MAX) = '-'
, @p_work_order_id nvarchar(MAX) = '-'
, @p_item_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/*********************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_OF_DEMAND_ORDER_TRACKING													**/
/** 프로그램 명	:                                                                           **/
/** 설 명		:																			**/
/** Version		: 1.0.0																		**/
/**                                                                                         **/
/** Argument	:																			**/
/**                                                                                         **/
/** [검색 조건]																				**/
/**                                                                                         **/
/** [Biz Logic]                                                                             **/
/**                                                                                         **/
/**-----------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유													**/
/** 20200207       cys          Demand 별 Order Tracking									**/
/*********************************************************************************************/  
/*
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_basic_plan_id  nvarchar(30)
  DECLARE @v_operation_id	nvarchar(30)
  DECLARE @v_target_seq		Integer = 0
  DECLARE @v_flag			nvarchar(10)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime
  DECLARE @v_demand_pegging_id	nvarchar(100)
  DECLARE @v_work_order_id	nvarchar(100)
  DECLARE @v_item_id	nvarchar(100)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(500)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @sync_operation_id  nvarchar(30)
  DECLARE @in_operation_id    nvarchar(30)
  DECLARE @out_operation_id   nvarchar(30)

  DECLARE @v_sqltext            nvarchar(MAX)

  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  SET @v_master_id			= @p_master_id
  SET @v_plan_id			= @p_plan_id
  SET @v_basic_plan_id		= @p_basic_plan_id
  SET @v_operation_id		= @p_operation_id
  SET @v_target_seq			= @p_seq
  SET @v_flag				= @p_flag
  SET @v_demand_pegging_id	= @p_demand_pegging_id
  SET @v_work_order_id		= @p_work_order_id
  SET @v_item_id			= @p_item_id

  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  BEGIN TRY
    

    -- 필수 DATA 쿼리.. 
    BEGIN
    
		IF @v_flag = 'TARGET'
		BEGIN
				--SELECT * FROM TH_BUF_RAW_DATA
				-- BUFFER에 DEMAND 잔량을 넣어준다.
				SET @v_table_name = 'TH_BUF_SCP_TARGET'

				UPDATE	A
				SET		REMAIN_MFG_QTY	=	( CASE WHEN A.REMAIN_MFG_QTY - (A.PLAN_QTY - A.REMAIN_QTY) <= 0		THEN 0
												   																ELSE A.REMAIN_MFG_QTY - (A.PLAN_QTY - A.REMAIN_QTY)
											  END  )
				FROM	(
							SELECT	A.*, B.PLAN_QTY, B.REMAIN_QTY
							FROM	TH_BUF_SCP_TARGET A	
									INNER JOIN (
											SELECT	A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID, ISNULL(SUM(PLAN_QTY),0) AS PLAN_QTY, ISNULL(SUM(A.REMAIN_QTY),0) AS REMAIN_QTY
											FROM	TH_BUF_RAW_DATA	A
											WHERE	1=1
											AND		A.INSTANCE_ID	= @v_master_id
											AND		A.FP_PLAN_ID	= @v_plan_id
											AND		A.OPERATION_ID	= @v_operation_id
											AND		A.SCP_DEMAND_ID IS NOT NULL
											AND		A.PLAN_QTY		<> A.REMAIN_QTY	
											GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID
									) B
									ON	1=1
									AND	A.INSTANCE_ID	=	@v_master_id
									AND	A.FP_PLAN_ID	=	@v_plan_id
									AND	A.OPERATION_ID	=	@v_operation_id
									AND A.TARGET_SEQ	=	@v_target_seq
									AND	A.INSTANCE_ID	=	B.INSTANCE_ID
									AND	A.FP_PLAN_ID	=	B.FP_PLAN_ID
									AND	A.FP_DEMAND_ID	=	B.SCP_DEMAND_ID
									AND	A.REMAIN_MFG_QTY > 0
							WHERE	1=1
							AND		A.REMAIN_MFG_QTY > 0
						) A
				WHERE 1=1

				SET @v_message = 'DEMAND_OFFSET : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
		END


		IF @v_flag = 'SUB_TARGET'
		BEGIN
				--SELECT * FROM TH_BUF_RAW_DATA
				-- BUFFER에 DEMAND 잔량을 넣어준다.
				SET @v_table_name = 'TH_BUF_SCP_TARGET'

				UPDATE	A
				SET		REMAIN_MFG_QTY	=	( CASE WHEN A.REMAIN_MFG_QTY - (A.PLAN_QTY - A.REMAIN_QTY) <= 0		THEN 0
												   																ELSE A.REMAIN_MFG_QTY - (A.PLAN_QTY - A.REMAIN_QTY)
												END  )
				FROM	(
							SELECT	A.*, B.PLAN_QTY, B.REMAIN_QTY
							FROM	TH_BUF_SCP_TARGET A	
									INNER JOIN (
											SELECT	A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID, ISNULL(SUM(PLAN_QTY),0) AS PLAN_QTY, ISNULL(SUM(A.REMAIN_QTY),0) AS REMAIN_QTY
											FROM	TH_BUF_RAW_DATA	A
											WHERE	1=1
											AND		A.INSTANCE_ID	= @v_master_id
											AND		A.FP_PLAN_ID	= @v_plan_id
											AND		A.OPERATION_ID	= @v_operation_id
											--AND		A.SCP_DEMAND_ID IS NOT NULL
											AND		RTRIM(LTRIM(A.SCP_DEMAND_ID)) = RTRIM(LTRIM(@v_demand_pegging_id))+'_'+RTRIM(LTRIM(@v_work_order_id))
											AND		A.ITEM_ID		=	@v_item_id
											AND		A.PLAN_QTY		<> A.REMAIN_QTY	
											GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID
									) B
									ON	1=1
									AND	A.INSTANCE_ID	=	@v_master_id
									AND	A.FP_PLAN_ID	=	@v_plan_id
									AND	A.OPERATION_ID	=	@v_operation_id
									AND	A.FP_DEMAND_ID	=	RTRIM(LTRIM(@v_demand_pegging_id))
									AND	A.WORK_ORDER_ID =	RTRIM(LTRIM(@v_work_order_id))
									AND	A.ITEM_ID		=	RTRIM(LTRIM(@v_item_id))
									AND	A.INSTANCE_ID	=	B.INSTANCE_ID
									AND	A.FP_PLAN_ID	=	B.FP_PLAN_ID
									AND	RTRIM(LTRIM(A.FP_DEMAND_ID))+'_'+RTRIM(LTRIM(@v_work_order_id))	=	RTRIM(LTRIM(B.SCP_DEMAND_ID))
									AND	A.REMAIN_MFG_QTY > 0
							WHERE	1=1
							AND		A.REMAIN_MFG_QTY > 0
						) A
				WHERE 1=1

				SET @v_message = 'SUB_DEMAND_OFFSET : ' + @v_item_id
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
		END


		-- FP_ORDER_TRACKING_DEMEND_R
		IF @v_flag = 'DEMAND'
		BEGIN
        
			SET @v_table_name = 'FP_ORDER_TRACKING_DEMEND_R'

			INSERT INTO FP_ORDER_TRACKING_DEMEND_R
			(
				INSTANCE_ID
				,FP_PLAN_ID
				,COMPANY_ID
				,DIVISION_ID
				,SITE_ID
				,PLANT_ID
				,FACTORY_ID
				,OPERATION_ID
				,LINE_ID
				,LOCATION
				,PRODUCTION_TYPE
				,MARKET
				,ELECTRODE_TYPE
				,TOP_ITEM_ID
				,ITEM_ID
				,SCP_DEMAND_ID
				,SCP_DEMAND_PEGGING_ID
				,ORG_MFG_QTY
				,MFG_QTY
				,MFG_WEEK
				,DUE_DATE
				,COMPLETE_DATE
				,PLAN_RESULT
				,INSERT_ID
				,INSERT_DTTM
				,UPDATE_ID
				,UPDATE_DTTM
			)
			SELECT	INSTANCE_ID
					,FP_PLAN_ID
					,COMPANY_ID
					,DIVISION_ID
					,SITE_ID
					,PLANT_ID
					,FACTORY_ID
					,OPERATION_ID
					,LINE_ID
					,'-' AS LOCATION
					,PRODUCTION_TYPE
					,MARKET
					,ELECTRODE_TYPE
					,TOP_ITEM_ID
					,ITEM_ID
					,SCP_DEMAND_ID
					,SCP_DEMAND_PEGGING_ID
					,ORG_MFG_QTY
					,MFG_QTY
					,MFG_WEEK
					,DUE_DATE
					,COMPLETE_DATE
					,PLAN_RESULT
					,@v_proc_name AS INSERT_ID
					,GETDATE() AS INSERT_DTTM
					,@v_proc_name AS UPDATE_ID
					,GETDATE() AS UPDATE_DTTM
			FROM	(
						SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID
								, A.LINE_ID, '-' AS LOCATION_ID, A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE, A.TOP_ITEM_ID, A.ITEM_ID
								, B.FP_DEMAND_ID AS SCP_DEMAND_ID, B.FP_DEMAND_ID+'_'+ CONVERT(NVARCHAR,REPLICATE('0',3 - LEN(A.SCP_SEQ)) + CAST(A.SCP_SEQ AS VARCHAR)) AS SCP_DEMAND_PEGGING_ID
								, B.MFG_QTY AS ORG_MFG_QTY
								, CASE	WHEN A.PLAN_QTY > A.TOTAL_QTY						THEN	A.TOTAL_QTY
										WHEN A.PLAN_QTY < A.TOTAL_QTY  AND A.REMAIN_QTY = 0 THEN	A.PLAN_QTY
																							ELSE	A.PLAN_QTY - A.REMAIN_QTY 
								  END MFG_QTY
								, B.MFG_WEEK, A.PLAN_DATE AS COMPLETE_DATE
								, CASE	WHEN A.DATA_TYPE = 'R' AND B.DUE_DATE >= A.PLAN_DATE	THEN 'PRODUCT'
										WHEN A.DATA_TYPE = 'X' AND B.DUE_DATE >= A.PLAN_DATE	THEN 'PRECEDING'
										WHEN A.DATA_TYPE = 'P' AND B.DUE_DATE >= A.PLAN_DATE	THEN 'PLAN_COMPELTE'
										WHEN B.DUE_DATE < A.PLAN_DATE							THEN 'LATE'
																								ELSE 'UNPLAN' 
								  END AS PLAN_RESULT
								, B.DUE_DATE
						FROM TH_BUF_RAW_DATA A, TH_BUF_SCP_TARGET B
						WHERE 1=1
						AND	A.INSTANCE_ID	= @v_master_id
						AND	A.FP_PLAN_ID	= @v_plan_id
						AND	A.OPERATION_ID	= @v_operation_id
						AND	B.INSTANCE_ID	= @v_master_id
						AND	B.FP_PLAN_ID	= @v_plan_id
						AND	B.OPERATION_ID	= @v_operation_id
						AND B.TARGET_SEQ	= @v_target_seq
						AND A.SCP_DEMAND_ID = B.FP_DEMAND_ID
						AND A.PLAN_QTY		<> A.REMAIN_QTY

					) A
			WHERE	1=1

			SET @v_message = 'DEMAND_TRACKING_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

		END

		--SET @v_proc_name = 1/0

		-- FP_ORDER_TRACKING_WO_R
		IF @v_flag = 'WO'
		BEGIN
        
			SET @v_table_name = 'FP_ORDER_TRACKING_WO_R'

			INSERT INTO FP_ORDER_TRACKING_WO_R
			(
				INSTANCE_ID
				,FP_PLAN_ID
				,COMPANY_ID
				,DIVISION_ID
				,SITE_ID
				,PLANT_ID
				,FACTORY_ID
				,OPERATION_ID
				,LINE_ID
				,LOCATION
				,PRODUCTION_TYPE
				,FP_PRODUCTION_TYPE
				,MARKET
				,ELECTRODE_TYPE
				,TOP_ITEM_ID
				,ITEM_ID
				,SCP_DEMAND_PEGGING_ID
				,WORK_ORDER_ID
				,PLAN_DATE
				,ORG_PLAN_QTY
				,ORG_PLAN_IN_QTY
				,PLAN_QTY
				,PLAN_IN_QTY
				,INSERT_ID
				,INSERT_DTTM
				,UPDATE_ID
				,UPDATE_DTTM
			)
			SELECT	INSTANCE_ID
					,FP_PLAN_ID
					,COMPANY_ID
					,DIVISION_ID
					,SITE_ID
					,PLANT_ID
					,FACTORY_ID
					,OPERATION_ID
					,LINE_ID
					,'-' AS LOCATION
					,PRODUCTION_TYPE
					,FP_PRODUCTION_TYPE
					,MARKET
					,ELECTRODE_TYPE
					,TOP_ITEM_ID
					,ITEM_ID
					,SCP_DEMAND_PEGGING_ID
					,WORK_ORDER_ID
					,PLAN_DATE
					,ORG_PLAN_QTY
					,ORG_PLAN_IN_QTY
					,PLAN_QTY
					,PLAN_IN_QTY
					,@v_proc_name AS INSERT_ID
					,GETDATE() AS INSERT_DTTM
					,@v_proc_name AS UPDATE_ID
					,GETDATE() AS UPDATE_DTTM
			FROM	(
						SELECT	A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID
								, A.LINE_ID, '-' AS LOCATION_ID, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE, A.TOP_ITEM_ID, A.ITEM_ID
								, A.SCP_DEMAND_ID+'_' + CONVERT(NVARCHAR,REPLICATE('0',3 - LEN(A.SCP_SEQ)) + CAST(A.SCP_SEQ AS VARCHAR)) AS SCP_DEMAND_PEGGING_ID
								, A.WORK_ORDER_ID
								, A.PLAN_DATE
								, A.PLAN_QTY AS ORG_PLAN_QTY
								, A.PLAN_IN_QTY AS ORG_PLAN_IN_QTY
								--, CASE WHEN REMAIN_QTY = 0 THEN A.PLAN_QTY 
								--								ELSE (A.TOTAL_QTY - B.MFG_QTY) 
								--	END AS PLAN_QTY
								, CASE	WHEN A.PLAN_QTY > A.TOTAL_QTY						THEN	A.TOTAL_QTY
										WHEN A.PLAN_QTY < A.TOTAL_QTY  AND A.REMAIN_QTY = 0 THEN	A.PLAN_QTY
																							ELSE	A.PLAN_QTY - A.REMAIN_QTY 
								  END PLAN_QTY
								, (CASE WHEN REMAIN_QTY = 0 THEN A.PLAN_QTY 
																ELSE (A.TOTAL_QTY - B.MFG_QTY) 
									END ) / 0.99 AS PLAN_IN_QTY
						FROM	TH_BUF_RAW_DATA A, TH_BUF_SCP_TARGET B
						WHERE	1=1
						AND		A.INSTANCE_ID	= @v_master_id
						AND		A.FP_PLAN_ID	= @v_plan_id
						AND		A.OPERATION_ID	= @v_operation_id
						AND		B.INSTANCE_ID	= @v_master_id
						AND		B.FP_PLAN_ID	= @v_plan_id
						AND		B.OPERATION_ID	= @v_operation_id
						AND		B.TARGET_SEQ	= @v_target_seq
						AND		A.SCP_DEMAND_ID = B.FP_DEMAND_ID
						AND		A.PLAN_QTY		<> A.REMAIN_QTY

					) A
			WHERE	1=1

			SET @v_message = 'WO_TRACKING_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

		END
				
		-- FP_ORDER_TRACKING_DEMEND_R

		-- UNPLAN
		IF @v_flag = 'UNPLAN'
		BEGIN
        
			SET @v_table_name = 'FP_ORDER_TRACKING_DEMEND_R'

			INSERT INTO FP_ORDER_TRACKING_DEMEND_R
			(
				INSTANCE_ID
				,FP_PLAN_ID
				,COMPANY_ID
				,DIVISION_ID
				,SITE_ID
				,PLANT_ID
				,FACTORY_ID
				,OPERATION_ID
				,LINE_ID
				,LOCATION
				,PRODUCTION_TYPE
				,MARKET
				,ELECTRODE_TYPE
				,TOP_ITEM_ID
				,ITEM_ID
				,SCP_DEMAND_ID
				,SCP_DEMAND_PEGGING_ID
				,ORG_MFG_QTY
				,MFG_QTY
				,MFG_WEEK
				,DUE_DATE
				,COMPLETE_DATE
				,PLAN_RESULT
				,INSERT_ID
				,INSERT_DTTM
				,UPDATE_ID
				,UPDATE_DTTM
			)
			SELECT	@v_master_id AS INSTANCE_ID
					,@v_plan_id AS FP_PLAN_ID
					,COMPANY_ID
					,DIVISION_ID
					,SITE_ID
					,PLANT_ID
					,FACTORY_ID
					,OPERATION_ID
					,LINE_ID
					,'-' AS LOCATION
					,PRODUCTION_TYPE
					,MARKET
					,ELECTRODE_TYPE
					,TOP_ITEM_ID
					,ITEM_ID
					,SCP_DEMAND_ID
					,SCP_DEMAND_PEGGING_ID
					,ORG_MFG_QTY
					,MFG_QTY
					,MFG_WEEK
					,DUE_DATE
					,COMPLETE_DATE
					,PLAN_RESULT
					,@v_proc_name AS INSERT_ID
					,GETDATE() AS INSERT_DTTM
					,@v_proc_name AS UPDATE_ID
					,GETDATE() AS UPDATE_DTTM
			FROM	(
						SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID AS FACTORY_ID, A.OPERATION_ID
								, A.LINE_ID, '-' AS LOCATION_ID, A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE AS ELECTRODE_TYPE, A.TOP_ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID
								, A.SCP_DEMAND_ID AS SCP_DEMAND_ID, '' AS SCP_DEMAND_PEGGING_ID
								, B.ORG_MFG_QTY AS ORG_MFG_QTY
								, B.REMAIN_MFG_QTY AS MFG_QTY
								, A.MFG_WEEK, A.DUE_DATE AS COMPLETE_DATE
								, 'UNPLAN' AS PLAN_RESULT
								, A.DUE_DATE
						FROM FP_ORDER_TRACKING_DEMEND_R A WITH(NOLOCK)
								INNER JOIN (
												SELECT	A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID, MAX(A.ORG_MFG_QTY) AS ORG_MFG_QTY, SUM(A.MFG_QTY) AS MFG_QTY, MAX(A.ORG_MFG_QTY) - SUM(A.MFG_QTY) AS REMAIN_MFG_QTY
												FROM	FP_ORDER_TRACKING_DEMEND_R A WITH(NOLOCK)
												WHERE	1=1
												AND		A.INSTANCE_ID	= @v_master_id
												AND		A.FP_PLAN_ID	= @v_plan_id
												AND		A.OPERATION_ID	= @v_operation_id
												GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID
												HAVING	MAX(A.ORG_MFG_QTY) - SUM(A.MFG_QTY) > 0
								) B
								ON 1=1
								AND	A.INSTANCE_ID	= B.INSTANCE_ID
								AND	A.FP_PLAN_ID	= B.FP_PLAN_ID
								AND	A.SCP_DEMAND_ID = B.SCP_DEMAND_ID
						WHERE 1=1
						AND	A.INSTANCE_ID	= @v_master_id
						AND	A.FP_PLAN_ID	= @v_plan_id
						AND	A.OPERATION_ID	= @v_operation_id
						UNION ALL
						SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.FACTORY_ID, L.FACTORY_ID) AS FACTORY_ID, A.OPERATION_ID
								, A.LINE_ID, '-' AS LOCATION_ID, A.PRODUCTION_TYPE, A.MARKET, ISNULL(A.ELECTRODE_TYPE, L.ELECTRODE_TYPE) AS ELECTRODE_TYPE, A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID
								, A.FP_DEMAND_ID AS SCP_DEMAND_ID, '' AS SCP_DEMAND_PEGGING_ID
								, A.MFG_QTY AS ORG_MFG_QTY
								, A.REMAIN_MFG_QTY AS MFG_QTY
								, A.MFG_WEEK, A.DUE_DATE AS COMPLETE_DATE
								, 'UNPLAN' AS PLAN_RESULT
								, A.DUE_DATE
						FROM	TH_BUF_SCP_TARGET A WITH(NOLOCK)
								LEFT OUTER JOIN SCM_LINE_M  L
								ON   1=1
								AND  L.ACTIVE_FLAG = 'Y' 
								AND  A.COMPANY_ID  = L.COMPANY_ID
								AND  A.DIVISION_ID = L.DIVISION_ID
								AND  A.SITE_ID     = L.SITE_ID
								AND  A.PLANT_ID    = L.PLANT_ID
								AND  A.OPERATION_ID = L.OPERATION_ID
								AND  A.LINE_ID     = L.LINE_ID
						WHERE 1=1
						AND A.INSTANCE_ID	= @v_master_id
						AND	A.FP_PLAN_ID	= @v_plan_id
						AND A.OPERATION_ID	= @v_operation_id
						AND A.MFG_QTY		= A.REMAIN_MFG_QTY
						
					) A
			WHERE	1=1

			SET @v_message = 'UNPLAN_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

		END
	
	END
    

  END TRY

  BEGIN CATCH
    --ROLLBACK

	BEGIN
		
		

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;

	END

  END CATCH

END
