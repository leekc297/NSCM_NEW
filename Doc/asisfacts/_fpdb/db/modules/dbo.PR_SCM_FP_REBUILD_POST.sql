CREATE PROCEDURE [dbo].[PR_SCM_FP_REBUILD_POST]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_FP_REBUILD_POST                                             **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2020.11.27    	CYS          최초 작성 - POST AMEND 데이타를 WO 기준으로 넣어주기 위해서 (Engine 수행하지 않음)                     **/
/** 2022.04.18    	CGJ			전극 후 공정 릴리즈  사전 준비                               **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_FP_REBUILD_POST
*/
BEGIN
  	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 
  	SET XACT_ABORT ON;

  	-- 필수 칼럼
  	DECLARE @v_master_id      nvarchar(30)
  	DECLARE @v_plan_id        nvarchar(30)

  	-- LOG 용 변수 설정
  	DECLARE @v_proc_name		nvarchar(100) = 'PR_SCM_FP_REBUILD_POST'
  	DECLARE @v_table_name     	nvarchar(100)
  	DECLARE @v_message        	nvarchar(250)
  	DECLARE @v_descr          	nvarchar(250)
  	DECLARE @n_row_count      	Integer  = 0
  	DECLARE @n_log_count      	Integer  = 0
  	DECLARE @v_log_code       	nvarchar(10)

  	DECLARE @v_start_date        	date
  	DECLARE @n_amend_past_period  Integer        
  	DECLARE @sysdate          	DATETIME2 = GETDATE()

  	DECLARE @v_temp1          	nvarchar(1000)
  	DECLARE @v_temp2          	nvarchar(1000)
  
  -------------------------------------------------------------------------------------------

  	SET @v_master_id     = @p_instance_id
  	SET @v_plan_id        = @p_plan_id
  
  	SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  	SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  	SET @n_log_count = @n_log_count + 1
  	SET @sysdate = GETDATE()
  	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  	BEGIN TRY

    	-- 필수 DATA 쿼리.. 반듯이 있어야 함.
    	
		BEGIN
    
		      SELECT  @v_start_date   = CONVERT(DATE, PLAN_START_TIME)
		      FROM    SCM_FP_PLAN_H WITH(NOLOCK)
		      WHERE   INSTANCE_ID = @v_master_id 
		      AND     PLAN_ID     = @v_plan_id
		
		    
		      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
		      --LOG 생성
		      SET @v_message   = '@v_start_date : ' + convert(nvarchar, @v_start_date)
		      SET @n_log_count = @n_log_count + 1
		      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null
		      
		END		      
		      		      
		/*
		      select @n_amend_past_period = isnull(max(day_period), 30)
		      from   (
		              -- 일자 기준이면 일자만
		              select convert(Integer, SEGMENT2) as day_period
		              from   scm_sys_lookup_value WITH(NOLOCK)
		              where  lookup_type_code = 'AMEND_PAST_PERIOD'
		              and    segment1         = @v_master_id
		              and    segment2         = 'DAY'
		              union  all
		              -- 주차 기준이면 주차 기준의 월요일
		              select datediff(day, a.date_id, @v_start_date) as day_period
		              from   (
		                      select a.date_id
		                           , dense_rank() over (order by a.date_id desc) as seq
		                      from   scm_sys_calendar_m a WITH(NOLOCK)
		                           , scm_sys_calendar_m b WITH(NOLOCK)
		                      where  b.date_id  = @v_start_date
		                      and    b.week     > a.week
		                      and    a.day      = 'MON'
		                      and    a.date_id  > dateadd(day, -365, @v_start_date)
		                     ) a
		                   , (               
		                      select convert(Integer, SEGMENT2) as week_period
		                      from   scm_sys_lookup_value  WITH(NOLOCK)
		                      where  lookup_type_code = 'AMEND_PAST_PERIOD'
		                      and    segment1         = @v_master_id
		                      and    segment2         = 'WEEK'
		                     ) b
		              where  a.seq = b.week_period
		             ) a
		      
		      --LOG 생성
		      SET @v_message   = '@n_amend_past_period : ' + convert(nvarchar, @n_amend_past_period)
		      SET @n_log_count = @n_log_count + 1
		      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null
		
		END
    */
    	BEGIN
    
			SET @v_table_name = 'TH_BUF_AMEND_PLAN_POST_DATA'
		
		  	DELETE FROM TH_BUF_AMEND_PLAN_POST_DATA WHERE INSERT_DTTM < DATEADD(DAY, -7, GETDATE())
		  	
		      --LOG 생성
		      SET @v_message   = 'Past Data Delete : ' + convert(nvarchar, @@ROWCOUNT)
		      SET @n_log_count = @n_log_count + 1
		      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null
		      
		  	DELETE FROM TH_BUF_AMEND_PLAN_POST_DATA WHERE INSTANCE_ID  = @v_master_id AND FP_PLAN_ID   = @v_plan_id
		  	
		      --LOG 생성
		      SET @v_message   = 'Plan Data Delete : ' + convert(nvarchar, @@ROWCOUNT)
		      SET @n_log_count = @n_log_count + 1
		      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, @v_log_code, @v_message, null
			
			INSERT INTO TH_BUF_AMEND_PLAN_POST_DATA
			(	
				  INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID
				, WORK_ORDER_SPL_ID, WORK_ORDER_ID, ORG_DEMAND_ID, DEMAND_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, FP_PRODUCTION_TYPE, SHIFT
				, PLAN_DATE, START_TIME, END_TIME, PLAN_IN_QTY, PLAN_QTY, PLAN_LATE_QTY, ITEM_UOM, ROLL_IN_QTY, ROLL_OUT_QTY, ROLL_LATE_QTY
				, JR_IN_QTY, JR_OUT_QTY, JR_LATE_QTY, CELL_IN_QTY, CELL_OUT_QTY, CELL_LATE_QTY, BATCH_IN_QTY, BATCH_OUT_QTY, BATCH_LATE_QTY
				, FIX_TYPE, TOTAL_WORKING_TIME, LINE_ITEM_SEQ, OPERATION_ITEM_SEQ, LANE_QTY, LANE_TACT_QTY, BATCH_ORDER_ID, BIN_ORDER_ID
				, MFG_WEEK, DEMAND_DIVISION_ID, MARKET, FULL_CLEANING_FLAG, MODEL_TYPE_CHANGE_FLAG, SEQ, CELL_MATERIAL_ID, CALC_TYPE, CALC_VERSION
				, TOTAL_BATCH, PIG_CLEANING_FLAG, SETUP_COLOR_CODE, INSERT_ID, INSERT_DTTM
			)
			/*
			SELECT	A.INSTANCE_ID     
						, A.FP_PLAN_ID      
						, A.COMPANY_ID      
						, A.DIVISION_ID     
						, A.SITE_ID  
						, A.PLANT_ID 
						, A.FACTORY_ID  
						, A.OPERATION_ID AS OPERATION_ID 
						, A.LINE_ID  
						, A.ELECTRODE_TYPE
						, ISNULL(C.EQUIPMENT_ID,'-') AS EQUIPMENT_ID
						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_SPL_ID
						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_ID         
						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS ORG_DEMAND_ID   
						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS DEMAND_ID       
						, A.ITEM_ID  
						, A.TOP_ITEM_ID
						, ISNULL(A.PRODUCTION_TYPE, 'MASS') AS PRODUCTION_TYPE
						, ISNULL(A.PRODUCTION_TYPE, 'MASS') AS FP_PRODUCTION_TYPE
						, A.SHIFT
						, A.PLAN_DATE
						, CONVERT(DATETIME, CONVERT(VARCHAR(10),A.PLAN_DATE,23) + ' ' + STUFF(STUFF(F.PLAN_START_TIME, 3,0,':'), 6,0,':') ) AS START_TIME
						, CONVERT(DATETIME, DATEADD(DAY, F.DAY_DIFF, CONVERT(VARCHAR(10),A.PLAN_DATE,23)) + ' ' + STUFF(STUFF(F.PLAN_END_TIME, 3,0,':'), 6,0,':') ) AS END_TIME
						--, A.ADJUST_IN_QTY AS PLAN_IN_QTY 
						--, A.ADJUST_OUT_QTY AS PLAN_QTY   
						, A.ADJUST_IN_QTY_M AS PLAN_IN_QTY		--pancake qty 
						, A.ADJUST_OUT_QTY_M AS PLAN_QTY			--pancake qty
						, 0 AS PLAN_LATE_QTY       
						, B.ITEM_UOM 
						, A.ADJUST_IN_QTY_M AS ROLL_IN_QTY     
						, A.ADJUST_OUT_QTY_M AS ROLL_OUT_QTY   
						, 0 AS ROLL_LATE_QTY       
						, A.ADJUST_IN_QTY_JR AS JR_IN_QTY 
						, A.ADJUST_OUT_QTY_JR AS JR_OUT_QTY     
						, 0 AS JR_LATE_QTY  
						, A.ADJUST_IN_QTY_CELL AS CELL_IN_QTY   
						, A.ADJUST_OUT_QTY_CELL AS CELL_OUT_QTY 
						, 0 AS CELL_LATE_QTY  
						, A.ADJUST_IN_QTY_BATCH AS BATCH_IN_QTY     
						, A.ADJUST_OUT_QTY_BATCH AS BATCH_OUT_QTY   
						, 0 AS BATCH_LATE_QTY  
						, NULL AS FIX_TYPE  
						, '86400' AS TOTAL_WORKING_TIME  
						, 1 AS LINE_ITEM_SEQ       
						, 1 AS OPERATION_ITEM_SEQ 
						, NULL AS LANE_QTY  
						, NULL AS LANE_TACT_QTY   
						, NULL AS BATCH_ORDER_ID  
						, NULL AS BIN_ORDER_ID     
						, E.WEEK AS MFG_WEEK       
						, A.DIVISION_ID AS DEMAND_DIVISION_ID   
						, A.MARKET
						, NULL AS FULL_CLEANING_FLAG     
						, NULL AS MODEL_TYPE_CHANGE_FLAG 
						, 1 AS SEQ   
						, NULL AS CELL_MATERIAL_ID 
						, NULL AS CALC_TYPE 
						, NULL AS CALC_VERSION     
						, NULL AS TOTAL_BATCH      
						, NULL AS PIG_CLEANING_FLAG      
						, NULL AS SETUP_COLOR_CODE    
						, @v_proc_name AS INSERT_ID      
						, GETDATE() AS INSERT_DTTM 
			FROM		FP_AMEND_PLAN_POST_R A
						LEFT OUTER JOIN SCM_ITEM_M B
						    ON     1=1
							AND    A.COMPANY_ID = B.COMPANY_ID
							AND    A.DIVISION_ID = B.DIVISION_ID
						    AND    A.SITE_ID = B.SITE_ID
						    AND    A.ITEM_ID = B.ITEM_ID
						    AND    B.ACTIVE_FLAG = 'Y' 
						LEFT OUTER JOIN (
													SELECT	B.INSTANCE_ID, A.SITE_ID, A.DIVISION_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, MIN(EQUIPMENT_ID) AS EQUIPMENT_ID
								                    FROM	SCM_EQUIPMENT_M A,
								                            (
								                            	/**
																SELECT	INSTANCE_ID, SITE_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, ELECTRODE_TYPE, MIN(LINE_ID) AS LINE_ID
																FROM	FP_INSTANCE_LINE_V
																WHERE	1=1
																AND		INSTANCE_ID = @v_master_id
																GROUP BY INSTANCE_ID, SITE_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, ELECTRODE_TYPE
																**/
								                            	SELECT	DISTINCT	 INSTANCE_ID, SITE_ID, DIVISION_ID, FACTORY_ID, OPERATION_ID, ELECTRODE_TYPE, LINE_ID
																FROM		FP_INSTANCE_LINE_V
																WHERE	1=1
																AND		INSTANCE_ID = @v_master_id
								                            ) B
								                    WHERE	1=1
													AND		A.DIVISION_ID = B.DIVISION_ID
								                    AND		A.SITE_ID = B.SITE_ID
								                    AND		A.FACTORY_ID = B.FACTORY_ID
								                    AND		A.OPERATION_ID = B.OPERATION_ID
													AND		A.LINE_ID = B.LINE_ID
								                    AND		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
								                    GROUP BY B.INSTANCE_ID, A.SITE_ID, A.DIVISION_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
												) C
						    ON     1=1
						    AND    A.INSTANCE_ID = C.INSTANCE_ID
							AND    A.DIVISION_ID = C.DIVISION_ID
						    AND    A.SITE_ID = C.SITE_ID
						    AND    A.FACTORY_ID = C.FACTORY_ID
							AND    A.OPERATION_ID = C.OPERATION_ID
							AND    A.LINE_ID = C.LINE_ID
						    AND    C.ELECTRODE_TYPE = ( CASE WHEN B.ITEM_CLASS IN ('ES0301')			THEN 'Anode'
																		 WHEN B.ITEM_CLASS IN ('ES0302', 'ES0303')	THEN 'Cathode' END )
						LEFT OUTER JOIN (
													SELECT	A.*, CASE WHEN PLAN_START_TIME > PLAN_END_TIME THEN 1 ELSE 0 END AS DAY_DIFF
													FROM		FP_PLAN_SHIFT_H A
													WHERE	1=1
													AND		A.INSTANCE_ID = @v_master_id
													AND		A.PLAN_ID = @v_plan_id
												) F
							ON   	A.INSTANCE_ID	= F.INSTANCE_ID
							AND  A.FP_PLAN_ID	= F.PLAN_ID 
							AND  A.SHIFT			= F.SHIFT ,
						SCM_SYS_CALENDAR_M E
			WHERE 1=1
			AND    A.INSTANCE_ID	= @v_master_id
			AND    A.FP_PLAN_ID 		= @v_plan_id
			AND    A.PLAN_DATE 		= E.DATE_ID
			*/
			SELECT	A.INSTANCE_ID     
						, A.FP_PLAN_ID      
						, A.COMPANY_ID      
						, A.DIVISION_ID     
						, A.SITE_ID  
						, A.PLANT_ID 
						, A.FACTORY_ID  
						, A.OPERATION_ID AS OPERATION_ID 
						, A.LINE_ID  
						, A.ELECTRODE_TYPE
						, ISNULL(A.EQUIPMENT_ID,'-') AS EQUIPMENT_ID
--						, ISNULL(C.EQUIPMENT_ID,'-') AS EQUIPMENT_ID
--						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_SPL_ID
--						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS WORK_ORDER_ID         
--						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS ORG_DEMAND_ID   
--						, A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' AS DEMAND_ID       
						, CASE WHEN ISNULL(A.WORK_ORDER_SPL_ID, '-') = '-'  THEN A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' 
								 ELSE A.WORK_ORDER_SPL_ID END AS WORK_ORDER_SPL_ID
						, CASE WHEN ISNULL(A.WORK_ORDER_ID, '-') = '-'  THEN A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' 
								 ELSE A.WORK_ORDER_ID END AS WORK_ORDER_ID 
						, CASE WHEN ISNULL(A.DEMAND_ID, '-') = '-'  THEN A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' 
								 ELSE A.DEMAND_ID END AS ORG_DEMAND_ID   
						, CASE WHEN ISNULL(A.DEMAND_ID, '-') = '-'  THEN A.DIVISION_ID + '^' + A.PLANT_ID + '-D^' + CONVERT(varchar(10), A.PLAN_DATE, 112) + '^' + A.SHIFT + '^' + A.ITEM_ID + '^' + A.LINE_ID + '^' + A.OPERATION_ID+ '^' + ISNULL(A.PRODUCTION_TYPE, 'MASS') + '^D' 
								 ELSE A.DEMAND_ID END AS DEMAND_ID 						
--						, A.WORK_ORDER_SPL_ID 
--						, A.WORK_ORDER_ID 
--						, A.DEMAND_ID AS ORG_DEMAND_ID   
--						, A.DEMAND_ID 
						, A.ITEM_ID  
						, A.ITEM_ID AS TOP_ITEM_ID
						, ISNULL(A.PRODUCTION_TYPE, 'MASS') AS PRODUCTION_TYPE
						, ISNULL(A.PRODUCTION_TYPE, 'MASS') AS FP_PRODUCTION_TYPE
						, A.SHIFT
						, A.PLAN_DATE
--						, F.PLAN_START_TIME
--						, CONVERT(VARCHAR(10),A.PLAN_DATE,23) + ' ' + STUFF(STUFF(F.PLAN_START_TIME, 3,0,':'), 6,0,':') AS AAA
						, CONVERT(DATETIME, CONVERT(VARCHAR(10),A.PLAN_DATE,23) + ' ' + STUFF(STUFF(F.PLAN_START_TIME, 3,0,':'), 6,0,':') ) AS START_TIME
						, CONVERT(DATETIME, DATEADD(DAY, F.DAY_DIFF, CONVERT(VARCHAR(10),A.PLAN_DATE,23)) + ' ' + STUFF(STUFF(F.PLAN_END_TIME, 3,0,':'), 6,0,':') ) AS END_TIME
						, A.PLAN_IN_QTY AS PLAN_IN_QTY		--pancake qty 
						, A.PLAN_QTY AS PLAN_QTY			--pancake qty
						, 0 AS PLAN_LATE_QTY       
						, B.ITEM_UOM 
						, A.PC_IN_QTY AS ROLL_IN_QTY     
						, A.PC_OUT_QTY AS ROLL_OUT_QTY   
						, 0 AS ROLL_LATE_QTY       
						, A.JR_IN_QTY AS JR_IN_QTY 
						, A.JR_OUT_QTY AS JR_OUT_QTY     
						, 0 AS JR_LATE_QTY  
						, 0 AS CELL_IN_QTY   
						, 0 AS CELL_OUT_QTY 
						, 0 AS CELL_LATE_QTY  
						, 0 AS BATCH_IN_QTY     
						, 0 AS BATCH_OUT_QTY   
						, 0 AS BATCH_LATE_QTY  
						, NULL AS FIX_TYPE  
						, '86400' AS TOTAL_WORKING_TIME  
						, 1 AS LINE_ITEM_SEQ       
						, 1 AS OPERATION_ITEM_SEQ 
						, NULL AS LANE_QTY  
						, NULL AS LANE_TACT_QTY   
						, NULL AS BATCH_ORDER_ID  
						, NULL AS BIN_ORDER_ID     
						, E.WEEK AS MFG_WEEK       
						, A.DIVISION_ID AS DEMAND_DIVISION_ID   
						, 'D' AS MARKET
						, NULL AS FULL_CLEANING_FLAG     
						, NULL AS MODEL_TYPE_CHANGE_FLAG 
						, 1 AS SEQ   
						, NULL AS CELL_MATERIAL_ID 
						, NULL AS CALC_TYPE 
						, NULL AS CALC_VERSION     
						, NULL AS TOTAL_BATCH      
						, NULL AS PIG_CLEANING_FLAG      
						, NULL AS SETUP_COLOR_CODE    
						, @v_proc_name AS INSERT_ID      
						, GETDATE() AS INSERT_DTTM 
			FROM		FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A
						LEFT OUTER JOIN SCM_ITEM_M B
						    ON     1=1
							AND    A.COMPANY_ID = B.COMPANY_ID
							AND    A.DIVISION_ID = B.DIVISION_ID
						    AND    A.SITE_ID = B.SITE_ID
						    AND    A.ITEM_ID = B.ITEM_ID
						    AND    B.ACTIVE_FLAG = 'Y' 			
						LEFT OUTER JOIN (
													SELECT 	SEGMENT4 AS INSTANCE_ID
																, SEGMENT5 AS SHIFT
																, ATTRIBUTE1 AS SHIFT_NAME
																, ATTRIBUTE2 AS PLAN_START_TIME
																, ATTRIBUTE3 AS PLAN_END_TIME
																, CASE WHEN SEGMENT5 = 1 THEN 0 ELSE 1 END AS DAY_DIFF
													FROM 	SCM_SYS_LOOKUP_VALUE  
													WHERE 	1=1
													AND 		LOOKUP_TYPE_CODE = 'SHIFT_BY_PLANT'
													AND 		SEGMENT4 = @V_MASTER_ID
												) F
							ON   	A.INSTANCE_ID	= F.INSTANCE_ID
							AND  A.SHIFT			= F.SHIFT,				    
						(
						SELECT 	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS FACTORY_ID, SEGMENT3 AS RELEASE_TERM
						FROM 	SCM_SYS_LOOKUP_VALUE
						WHERE 	1=1
						AND 		LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
						AND 		SEGMENT1 = @V_MASTER_ID
						) D,
						SCM_SYS_CALENDAR_M E
			WHERE 1=1
			AND    A.INSTANCE_ID	= @v_master_id
			AND    A.FP_PLAN_ID 		= @v_plan_id	
			AND 		A.FACTORY_ID = d.FACTORY_ID
			AND 		A.PLAN_DATE <= DATEADD(DAY, CONVERT(NUMERIC, D.RELEASE_TERM), @V_START_DATE)			
			AND    A.PLAN_DATE 		= E.DATE_ID		
			
			--LOG 생성
	      	SET @v_message   = 'AMEND BUFFER TR : ' + convert(nvarchar, @@ROWCOUNT)
	      	SET @n_log_count = @n_log_count + 1
	      	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null

      

      ----------------------------------------------------------------------------------------------------------------
      ----------------------------------------------------------------------------------------------------------------
      ----------------------------------------------------------------------------------------------------------------
			IF 1=1
      		BEGIN
			
				      	SET @v_table_name = 'FP_DAILY_PRODUCTION_PLAN_R'
				      	
--				      	DELETE 	FP_DAILY_PRODUCTION_PLAN_R
--						WHERE 	1=1
--						AND 		INSTANCE_ID = @V_MASTER_ID
--						AND 		FP_PLAN_ID = @V_PLAN_ID       
									
						
						DELETE 	FP_DAILY_PRODUCTION_PLAN_R
						FROM 	FP_DAILY_PRODUCTION_PLAN_R A,
									(
									SELECT 	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS FACTORY_ID, SEGMENT3 AS RELEASE_TERM
									FROM 	SCM_SYS_LOOKUP_VALUE
									WHERE 	1=1
									AND 		LOOKUP_TYPE_CODE = 'INSTANCE_FACTORY_RELEASE_TERM'
									AND 		SEGMENT1 = @V_MASTER_ID
									) B
						WHERE 	1=1
						AND 		A.INSTANCE_ID = @V_MASTER_ID
						AND 		A.FP_PLAN_ID = @V_PLAN_ID
						AND 		A.FACTORY_ID = B.FACTORY_ID
						AND 		A.PLAN_DATE <= DATEADD(DAY, CONVERT(NUMERIC, B.RELEASE_TERM), @V_START_DATE)								
						
					  	SET @v_message = @@ROWCOUNT      
				        SET @v_descr = 'FP_DAILY_PRODUCTION_PLAN_R DELETE'
				        SET @n_log_count = @n_log_count + 1
				        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_descr, @v_message			
				
				
						INSERT INTO  FP_DAILY_PRODUCTION_PLAN_R  
						(
					 		  INSTANCE_ID	
							, FP_PLAN_ID	
							, COMPANY_ID	
							, DIVISION_ID	
							, SITE_ID	
							, PLANT_ID	
							, FACTORY_ID	
							, WORK_ORDER_SPL_ID
							, WORK_ORDER_ID	
							, ORG_DEMAND_ID	
							, DEMAND_ID	
							, ITEM_ID	
							, TOP_ITEM_ID	
							, OPERATION_ID	
							, LINE_ID	
							, ELECTRODE_TYPE	
							, EQUIPMENT_ID	
							, PLAN_DATE	
							, START_TIME	
							, END_TIME	
							, PLAN_IN_QTY	
							, PLAN_QTY	
							, PLAN_LATE_QTY	
							, ITEM_UOM	
							, ROLL_IN_QTY	
							, ROLL_OUT_QTY	
							, ROLL_LATE_QTY	
							, JR_IN_QTY	
							, JR_OUT_QTY	
							, JR_LATE_QTY	
							, CELL_IN_QTY	
							, CELL_OUT_QTY	
							, BATCH_IN_QTY	
							, BATCH_OUT_QTY	
							, BATCH_LATE_QTY	
							, FIX_TYPE	
							, PRODUCTION_TYPE	
							, FP_PRODUCTION_TYPE
							, TOTAL_WORKING_TIME	
							, LINE_ITEM_SEQ	
							, OPERATION_ITEM_SEQ	
							, LANE_QTY	
							, LANE_TACT_QTY	
							, BATCH_ORDER_ID	
							, BIN_ORDER_ID	
							, MFG_WEEK	
							, DEMAND_DIVISION_ID	
							, MARKET	
							, FULL_CLEANING_FLAG	
							, MODEL_TYPE_CHANGE_FLAG	
							, SEQ	
							, CELL_MATERIAL_ID	
							, CALC_TYPE	
							, CALC_VERSION	
							, TOTAL_BATCH	
							, PIG_CLEANING_FLAG	
							, SETUP_COLOR_CODE
							, INSERT_ID	
							, INSERT_DTTM	
						) 
						SELECT	 INSTANCE_ID	
									, FP_PLAN_ID	
									, COMPANY_ID	
									, DIVISION_ID	
									, SITE_ID	
									, PLANT_ID	
									, FACTORY_ID	
									, WORK_ORDER_SPL_ID
									, WORK_ORDER_ID	
									, ORG_DEMAND_ID	
									, DEMAND_ID	
									, ITEM_ID	
									, TOP_ITEM_ID	
									, OPERATION_ID	
									, LINE_ID	
									, ELECTRODE_TYPE	
									, EQUIPMENT_ID	
									, PLAN_DATE	
									, START_TIME	
									, END_TIME	
									, ISNULL(PLAN_IN_QTY,0) AS PLAN_IN_QTY
									, ISNULL(PLAN_QTY,0) AS PLAN_QTY	
									, ISNULL(PLAN_LATE_QTY,0) AS PLAN_LATE_QTY	
									, ITEM_UOM	
									, ISNULL(ROLL_IN_QTY,0) AS ROLL_IN_QTY	
									, ISNULL(ROLL_OUT_QTY,0) AS ROLL_OUT_QTY	
									, ISNULL(ROLL_LATE_QTY,0) AS ROLL_LATE_QTY	
									, ISNULL(JR_IN_QTY,0) AS JR_IN_QTY	
									, ISNULL(JR_OUT_QTY,0) AS JR_OUT_QTY	
									, ISNULL(JR_LATE_QTY,0) AS JR_LATE_QTY	
									, CELL_IN_QTY	
									, CELL_OUT_QTY	
									, BATCH_IN_QTY	
									, BATCH_OUT_QTY	
									, BATCH_LATE_QTY	
									, FIX_TYPE	
									, PRODUCTION_TYPE	
									, FP_PRODUCTION_TYPE
									, TOTAL_WORKING_TIME	
									, LINE_ITEM_SEQ	
									, OPERATION_ITEM_SEQ	
									, LANE_QTY	
									, LANE_TACT_QTY	
									, BATCH_ORDER_ID	
									, BIN_ORDER_ID	
									, MFG_WEEK	
									, DEMAND_DIVISION_ID	
									, MARKET	
									, FULL_CLEANING_FLAG	
									, MODEL_TYPE_CHANGE_FLAG	
									, SEQ	
									, CELL_MATERIAL_ID	
									, CALC_TYPE	
									, CALC_VERSION	
									, TOTAL_BATCH	
									, PIG_CLEANING_FLAG	
									, SETUP_COLOR_CODE
									, INSERT_ID	
									, INSERT_DTTM
						FROM   	TH_BUF_AMEND_PLAN_POST_DATA A
			        	WHERE  	A.INSTANCE_ID  = @v_master_id
			        	AND    	A.FP_PLAN_ID   = @v_plan_id
			        	AND 		ISNULL(PLAN_QTY,0) > 0
			        	AND    	NOT EXISTS (
							                            SELECT 1
							                            FROM   FP_DAILY_PRODUCTION_PLAN_R X
							                            WHERE  	X.INSTANCE_ID      	= A.INSTANCE_ID
							                            AND    	X.FP_PLAN_ID       		= A.FP_PLAN_ID
							                            AND    	X.COMPANY_ID       	= A.COMPANY_ID
							                            AND   	X.DIVISION_ID       	= A.DIVISION_ID
							                            AND   	X.SITE_ID     			= A.SITE_ID
							                            AND    	X.PLANT_ID     			= A.PLANT_ID
							                            AND    	X.FACTORY_ID          	= A.FACTORY_ID
							                            AND    	X.WORK_ORDER_SPL_ID	= A.WORK_ORDER_SPL_ID
							                            AND    	X.PLAN_DATE        	= A.PLAN_DATE
							                       )
			
			        --LOG 생성
			        SET @v_message   = 'TH_BUF_AMEND_PLAN_POST_DATA (NEW) : ' + convert(nvarchar, @@ROWCOUNT)
			        SET @n_log_count = @n_log_count + 1
			        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, @v_log_code, @v_message, null
			END

		END
		
		IF @@TRANCOUNT > 0
      	COMMIT WORK 
    
	END TRY

	BEGIN CATCH
	    --ROLLBACK
	    SET @v_descr = ERROR_MESSAGE()
	    SET @sysdate = GETDATE()
	
	    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
	    commit;
	END CATCH

  	SET @n_log_count = @n_log_count + 1
  	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
