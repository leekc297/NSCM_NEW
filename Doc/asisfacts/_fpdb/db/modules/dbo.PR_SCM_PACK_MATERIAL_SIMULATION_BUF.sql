
CREATE PROCEDURE [dbo].[PR_SCM_PACK_MATERIAL_SIMULATION_BUF]  
@p_instance_id nvarchar(MAX) = '-', 
@p_simul_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/**************************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_PACK_MATERIAL_SIMULATION												**/
/** 프로그램 명	:																								**/
/** 설 명		: PACK INSTANCE MATERIAL SIMULATION													**/
/** Version	: 1.0.0																								**/
/**																													**/
/** Argument																									**/
/**																													**/
/** [검색 조건]																									**/
/**																													**/
/** [Biz Logic]																									**/
/**																													**/
/**************************************************************************************************/
/** 작성일자		작성자			사유																			**/
/**==============================================================	**/
/** 2021.09.24	최기주        최초 작성																		**/
/** 2021.10.26	최기주        CELL 창고 재고 변경															**/
/**************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;


 -- 필수 칼럼

  DECLARE   @v_instance_id    	nvarchar(30)  
  DECLARE   @v_simul_id      	nvarchar(30)   
  DECLARE   @v_plan_type    	nvarchar(30)
  DECLARE   @v_operation_01	nvarchar(30)
  DECLARE   @key_date  			date	= convert( date, getdate() )
  DECLARE 	@plan_start_time	datetime
  DECLARE 	@plan_end_time	datetime
  DECLARE   @v_form_instance_id    	nvarchar(30)  
  

  -- LOG 용 변수 설정
  DECLARE  @v_proc_name		nvarchar(100) = 'PR_SCM_PACK_MATERIAL_SIMULATION_BUF'
  DECLARE  @v_table_name		nvarchar(100)
  DECLARE  @v_message			nvarchar(250)
  DECLARE  @v_descr				nvarchar(250)
  DECLARE  @n_row_count		Integer  = 0
  DECLARE  @n_log_count		Integer  = 0
  DECLARE  @v_log_code			nvarchar(10)
  DECLARE  @sysdate				datetime2 = getdate()
  DECLARE  @v_temp1			nvarchar(1000)


  SET @v_instance_id		= @p_instance_id
  SET @v_simul_id      	= @p_simul_id 
  
  SET @v_temp1 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_simul_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  
  BEGIN

	  /* 
	   1st Simulation 일 경우 'PRE-SIM' 
	   Plan 변경 후 재 수립 시는 'RE-SIM'
	   */
      SET 		@v_table_name = 'FP_SIM_PLAN_H'      
      SELECT	@key_date = CONVERT(DATE, A.PLAN_START_TIME),      			
      			@v_plan_type 		= A.PLAN_TYPE,
      			@plan_start_time	= A.PLAN_START_TIME,
      			@plan_end_time 	= A.PLAN_END_TIME
      FROM   (
	              SELECT	PLAN_START_TIME, PLAN_END_TIME, PLAN_TYPE
	              FROM	FP_SIM_PLAN_H
	              WHERE	1=1
	              AND 	INSTANCE_ID	= @v_instance_id
	              AND		SIM_PLAN_ID	= @v_simul_id
	             ) A
             
             
      --LOG 생성
      SET @v_message = 'KEY_DATE : ' + CONVERT(nvarchar, @KEY_DATE, 112) + ' / PLAN_TYPE : ' + @v_plan_type 
      							+ ' / PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      
	  SELECT	@v_form_instance_id =  SEGMENT1 
	  FROM 	SCM_SYS_LOOKUP_VALUE
	  WHERE	1=1
	  AND		LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
	  AND 	SEGMENT2 = @V_INSTANCE_ID
	  AND 	ACTIVE_FLAG = 'Y'
	  GROUP BY SEGMENT1
             
             
      --LOG 생성
      SET @v_message = 'FORM INSTANCE : ' + @v_form_instance_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null      
      
      
  END  

  BEGIN TRY

	BEGIN  
	--------------------------------------------------
	-- 1-1. 계획 수량
	--------------------------------------------------
				
    	SET @v_table_name = 'PACK_MATERIAL_SIM_PLAN'
    	
--		CREATE TABLE #PACK_MATERIAL_SIM_PLAN
--			(
--			INSTANCE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SIM_PLAN_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			FACTORY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			OPERATION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			LINE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			TOP_LINE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			PRODUCTION_TYPE nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			MODEL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			ITEM_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			PLAN_DATE datetime NOT NULL,
--			SIM_IN_QTY numeric(20,10) NULL,
--			SIM_QTY numeric(20,10) NULL,
--			PLAN_IN_QTY numeric(20,10) NULL,
--			PLAN_QTY numeric(20,10) NULL,
--			PACK_MODEL_PLAN_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			ALT_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
--			ALT_PRIORITY numeric(20,10) NULL,
--			YIELD numeric(20,10) DEFAULT 1 NULL,
--			TOTAL_YIELD numeric(20,10) DEFAULT 1 NULL,
--			BOM_RATE numeric(20,10) DEFAULT 1 NULL,
--			MODIFY_FLAG nvarchar(1) COLLATE Latin1_General_CI_AS NULL
--			)
TRUNCATE TABLE BUF_PACK_MATERIAL_SIM_PLAN
		INSERT INTO BUF_PACK_MATERIAL_SIM_PLAN
			(
			INSTANCE_ID
			,SIM_PLAN_ID
			,COMPANY_ID
			,DIVISION_ID
			,SITE_ID
			,PLANT_ID
			,FACTORY_ID
			,OPERATION_ID
			,LINE_ID
			,TOP_LINE_ID
			,PRODUCTION_TYPE
			,MODEL_ID
			,ITEM_ID
			,PLAN_DATE
			,SIM_IN_QTY
			,SIM_QTY
			,PLAN_IN_QTY
			,PLAN_QTY
			,PACK_MODEL_PLAN_ID
			,ALT_ID
			,ALT_PRIORITY
			,YIELD
			,TOTAL_YIELD
			,BOM_RATE
			,MODIFY_FLAG
			)
		SELECT	@v_instance_id AS INSTANCE_ID,
		    		@v_simul_id AS SIM_PLAN_ID,
		    		A.COMPANY_ID,
		    		A.DIVISION_ID,
		    		A.SITE_ID,
		    		A.PLANT_ID,
		    		A.FACTORY_ID,
		    		A.OPERATION_ID,
		    		A.LINE_ID,
		    		ISNULL(C.ATTRIBUTE1, A.LINE_ID) AS TOP_LINE_ID,
		    		A.PRODUCTION_TYPE,
		    		A.TOP_ITEM_ID AS MODEL_ID,
		    		A.ITEM_ID,
		    		A.PLAN_DATE,
		    		CEILING(SUM(PLAN_IN_QTY)) AS SIM_IN_QTY,
		    		SUM(PLAN_QTY) AS SIM_QTY,
		    		SUM(PLAN_IN_QTY) AS PLAN_IN_QTY,
		    		SUM(PLAN_QTY) AS PLAN_QTY,
		    		A.TOP_ITEM_ID +'_' + ISNULL(C.ATTRIBUTE1, A.LINE_ID) + '_' + A.PRODUCTION_TYPE + '_' + CONVERT(VARCHAR(8), A.PLAN_DATE, 112) AS PACK_MODEL_PLAN_ID,
					NULL AS ALT_ID,
					NULL AS ALT_PRIORITY,
					1 AS YIELD,
					1 AS  TOTAL_YIELD,
					1 AS  BOM_RATE,
					NULL AS MODIFY_FLAG
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A
					LEFT OUTER JOIN 	SCM_SYS_LOOKUP_VALUE C
					ON 	1=1
					AND 	C.LOOKUP_TYPE_CODE = 'TOP_LINE_DEFINITION'
					AND 	A.LINE_ID = C.SEGMENT1 
					AND 	A.OPERATION_ID = C.SEGMENT2,
					FP_INSTANCE_LINE_V B
		WHERE 	1=1
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		@v_plan_type = 'PRE-SIM' 
		AND 		B.INSTANCE_ID = @v_instance_id
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND 		A.DIVISION_ID = B.DIVISION_ID
		AND 		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.PLAN_DATE >= @plan_start_time
		AND 		A.PLAN_DATE <= @plan_end_time
		AND 		A.PLAN_QTY > 0
		GROUP BY   A.COMPANY_ID,
		    			A.DIVISION_ID,
		    			A.SITE_ID,
		    			A.PLANT_ID,
		    			A.FACTORY_ID,
		    			A.OPERATION_ID,
		    			A.LINE_ID,
		    			C.ATTRIBUTE1,
		    			A.PRODUCTION_TYPE,
		    			A.TOP_ITEM_ID,
		    			A.ITEM_ID,
		    			A.PLAN_DATE
		UNION ALL 
		SELECT	@v_instance_id AS INSTANCE_ID,
		    		@v_simul_id AS SIM_PLAN_ID,
		    		A.COMPANY_ID,
		    		A.DIVISION_ID,
		    		A.SITE_ID,
		    		A.PLANT_ID,
		    		A.FACTORY_ID,
		    		A.OPERATION_ID,
		    		A.LINE_ID,
		    		ISNULL(C.ATTRIBUTE1, A.LINE_ID) AS TOP_LINE_ID,
		    		A.PRODUCTION_TYPE,
		    		A.MODEL_ID,
		    		A.ITEM_ID,
		    		A.PLAN_DATE,
		    		CEILING(SUM(SIM_IN_QTY)) AS SIM_IN_QTY,
		    		SUM(SIM_QTY) AS SIM_QTY,
		    		SUM(PLAN_IN_QTY) AS PLAN_IN_QTY,
		    		SUM(PLAN_QTY) AS PLAN_QTY,
		    		A.MODEL_ID +'_' + ISNULL(C.ATTRIBUTE1, A.LINE_ID) + '_' + A.PRODUCTION_TYPE + '_' + CONVERT(VARCHAR(8), A.PLAN_DATE, 112) AS PACK_MODEL_PLAN_ID,
					NULL AS ALT_ID,
					NULL AS ALT_PRIORITY,
					1 AS YIELD,
					1 AS  TOTAL_YIELD,
					1 AS  BOM_RATE,
					CASE WHEN A.ATTB_05 IS NOT NULL THEN 'Y' ELSE 'N' END AS MODIFY_FLAG
		FROM 	FP_SIM_MATERIAL_PACK_R A
					LEFT OUTER JOIN 	SCM_SYS_LOOKUP_VALUE C
					ON 	1=1
					AND 	C.LOOKUP_TYPE_CODE = 'TOP_LINE_DEFINITION'
					AND 	A.LINE_ID = C.SEGMENT1 
					AND 	A.OPERATION_ID = C.SEGMENT2		
		WHERE 	1=1
		AND 		@v_plan_type 	= 'RE-SIM' 
		AND 		A.SIM_PLAN_ID	= @v_simul_id
--		AND 		A.SIM_QTY 		> 0
		GROUP BY   A.COMPANY_ID,
		    			A.DIVISION_ID,
		    			A.SITE_ID,
		    			A.PLANT_ID,
		    			A.FACTORY_ID,
		    			A.OPERATION_ID,
		    			A.LINE_ID,
		    			C.ATTRIBUTE1,
		    			A.PRODUCTION_TYPE,
		    			A.MODEL_ID,
		    			A.ITEM_ID,
		    			A.PLAN_DATE,
		    			CASE WHEN A.ATTB_05 IS NOT NULL THEN 'Y' ELSE 'N' END
			    			
		
	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr			   	    
	    
	    
	END
	    
	BEGIN 
	--=========================================================
	-- 1-2. RE-SIM MODIFY QTY 보정 
	-- 
	--=========================================================
		
		-- SIM IN QTY UPDATE : MODIFY QTY * 수율 
	    
		UPDATE A
		SET 		A.SIM_IN_QTY = CEILING(A.SIM_QTY / A.YIELD)
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A
		WHERE 	1=1
		AND 		A.SIM_PLAN_ID	= @v_simul_id
		AND 		A.MODIFY_FLAG = 'Y'

	    --LOG 생성
		SET @v_message =  'SIM IN QTY UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr		
	    
	    
	    -- 하위 공정 INSERT 
	    
		INSERT INTO BUF_PACK_MATERIAL_SIM_PLAN
			(
			INSTANCE_ID
			,SIM_PLAN_ID
			,COMPANY_ID
			,DIVISION_ID
			,SITE_ID
			,PLANT_ID
			,FACTORY_ID
			,OPERATION_ID
			,LINE_ID
			,TOP_LINE_ID
			,PRODUCTION_TYPE
			,MODEL_ID
			,ITEM_ID
			,PLAN_DATE
			,SIM_IN_QTY
			,SIM_QTY
			,PLAN_IN_QTY
			,PLAN_QTY
			,PACK_MODEL_PLAN_ID
			,ALT_ID
			,ALT_PRIORITY
			,YIELD
			,TOTAL_YIELD
			,BOM_RATE
			,MODIFY_FLAG
			)
	    SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID
					,A.COMPANY_ID
					,A.DIVISION_ID
					,A.SITE_ID
					,A.PLANT_ID
					,A.FACTORY_ID
					,C.OPERATION_ID
					,A.LINE_ID
					,A.TOP_LINE_ID
					,A.PRODUCTION_TYPE
					,A.MODEL_ID
					,C.ITEM_ID
					,A.PLAN_DATE
					,A.SIM_QTY * B.CHILD_QTY / B.PARENT_QTY AS SIM_IN_QTY
					,A.SIM_QTY * B.CHILD_QTY / B.PARENT_QTY AS SIM_QTY
					,A.PLAN_IN_QTY
					,A.PLAN_QTY
					,A.PACK_MODEL_PLAN_ID
					,B.ALT_ID
					,B.ALT_PRIORITY
					,1 AS YIELD
					,1 AS  TOTAL_YIELD
					,1 AS  BOM_RATE					
					,NULL AS MODIFY_FLAG
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A,
					SCM_BOM_M B,
					(
					SELECT 	MODEL_ID, ITEM_ID, LINE_ID, OPERATION_ID
					FROM 	BUF_PACK_MATERIAL_SIM_PLAN
					WHERE 	1=1
					AND 		SIM_PLAN_ID = @v_simul_id
					AND 		OPERATION_ID IN ('P5000','P5200')
					GROUP BY MODEL_ID, ITEM_ID, LINE_ID, OPERATION_ID
					) C
		WHERE 	1=1
		AND 		A.SIM_PLAN_ID = @v_simul_id 
		AND 		A.MODIFY_FLAG = 'Y'
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.MODEL_ID = B.PARENT_ITEM_ID
		AND 		B.ACTIVE_FLAG = 'Y'
		AND 		B.EFF_END_DATE >= A.PLAN_DATE
		AND 		B.CHILD_ITEM_ID LIKE 'AMD%'
		AND 		A.MODEL_ID = C.MODEL_ID
		AND 		B.CHILD_ITEM_ID = C.ITEM_ID
		AND 		A.LINE_ID = C.LINE_ID
		AND 		NOT EXISTS (
									SELECT 	MODEL_ID, ITEM_ID, LINE_ID, PLAN_DATE, OPERATION_ID, PACK_MODEL_PLAN_ID 
									FROM 	BUF_PACK_MATERIAL_SIM_PLAN D
									WHERE	1=1
									AND 		D.SIM_PLAN_ID = @v_simul_id
									AND 		A.MODEL_ID = D.MODEL_ID 
									AND 		C.ITEM_ID = D.ITEM_ID 
									AND 		A.PLAN_DATE = D.PLAN_DATE 
									AND 		A.LINE_ID = D.LINE_ID 
									AND 		C.OPERATION_ID = D.OPERATION_ID 
									AND 		A.PACK_MODEL_PLAN_ID = D.PACK_MODEL_PLAN_ID 
									GROUP BY MODEL_ID, ITEM_ID, LINE_ID, PLAN_DATE, OPERATION_ID, PACK_MODEL_PLAN_ID
									)
							
	    --LOG 생성
	    SET @v_message =  'SIM IN QTY INSERT : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    	    
	   
	    
	
	END
	
	BEGIN
	
	--=========================================================
	-- 1-3. ALT_ITEM, YIELD, BOM RATE UPDATE 
	-- 
	--=========================================================	
	    
	    
   		-- ALT ITEM UPDATE : 대치품목
	    
		UPDATE 	A
		SET 		A.ALT_ID = B.ALT_ID_AA,
					A.ALT_PRIORITY = B.ALT_PRIORITY_AA
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A,
					(
					SELECT 	A.*
								, 'ALT_' + MODEL_ID + '_' + A.TOP_LINE_ID + '_' + A.PRODUCTION_TYPE + '_' + C.ALT_ID AS ALT_ID_AA
								, RANK() OVER (PARTITION BY A.MODEL_ID, A.TOP_LINE_ID, A.PRODUCTION_TYPE, A.ALT_ID, A.PLAN_DATE ORDER BY C.ALT_PRIORITY ) 	AS ALT_PRIORITY_AA
					FROM 	BUF_PACK_MATERIAL_SIM_PLAN A,
								(
								SELECT 	PACK_MODEL_PLAN_ID, COUNT(*) AS MODULE_CNT
								FROM 	BUF_PACK_MATERIAL_SIM_PLAN
								WHERE 	1=1
								AND 		SIM_PLAN_ID	= @v_simul_id
								AND 		OPERATION_ID IN ('P5000', 'P5200')
								GROUP BY PACK_MODEL_PLAN_ID
								HAVING COUNT(*) > 1
								) B,
								SCM_BOM_M C
					WHERE 	1=1
					AND 		A.SIM_PLAN_ID = @v_simul_id
					AND 		A.PACK_MODEL_PLAN_ID = B.PACK_MODEL_PLAN_ID
					AND 		A.COMPANY_ID = C.COMPANY_ID 
					AND 		A.DIVISION_ID = C.DIVISION_ID 
					AND 		A.SITE_ID = C.SITE_ID 
					AND 		A.PLANT_ID = C.PLANT_ID 
					AND 		A.MODEL_ID = C.PARENT_ITEM_ID 
					AND 		A.ITEM_ID = C.CHILD_ITEM_ID 
					AND 		A.PLAN_DATE >= C.EFF_START_DATE 
					AND 		A.PLAN_DATE < C.EFF_END_DATE
					AND 		C.ACTIVE_FLAG = 'Y'
					AND 		C.ALT_ID IS NOT NULL
					) B
		WHERE 	1=1
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.PACK_MODEL_PLAN_ID = B.PACK_MODEL_PLAN_ID
		AND 		A.OPERATION_ID = B.OPERATION_ID
		AND 		A.ITEM_ID = B.ITEM_ID
		AND 		A.LINE_ID = B.LINE_ID

	    --LOG 생성
		SET @v_message =  'ALT ITEM UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	 	SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			    
	    
		-- BOM RATE 반영
		
		UPDATE A
		SET 		A.BOM_RATE = CASE WHEN B.PARENT_QTY IS NULL OR B.PARENT_QTY = 0 THEN 1 ELSE ISNULL(B.CHILD_QTY,1000) / ISNULL(B.PARENT_QTY,1000) END
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A, 
					SCM_BOM_M B
		WHERE 	1=1
		AND		A.INSTANCE_ID	= @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.PLANT_ID = B.PLANT_ID 
		AND 		B.ACTIVE_FLAG = 'Y'
		AND 		B.EFF_START_DATE <= A.PLAN_DATE 
		AND 		B.EFF_END_DATE > A.PLAN_DATE 
		AND 		A.MODEL_ID = B.PARENT_ITEM_ID 
		AND 		A.ITEM_ID = B.CHILD_ITEM_ID 

	    --LOG 생성
		SET @v_message = 'BOM RATE UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr		
	    
   		-- YIELD UPDATE : 수율 
	    
		UPDATE A
		SET 		A.YIELD = B.YIELD,
					A.TOTAL_YIELD = B.YIELD
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A
					, SCM_YIELD_M B
		WHERE 	1=1
		AND		A.INSTANCE_ID	= @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.PLANT_ID = B.PLANT_ID 
		AND 		A.ITEM_ID = B.ITEM_ID 
		AND 		A.LINE_ID = B.LINE_ID
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		B.MONTH = CONVERT(VARCHAR(6), A.PLAN_DATE, 112)

	    --LOG 생성
		SET @v_message =  'YIELD UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			
	    
   		-- TOTAL YIELD UPDATE : 수율 
	    
		UPDATE A
		SET 		A.TOTAL_YIELD = A.YIELD * B.YIELD 
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A,
					BUF_PACK_MATERIAL_SIM_PLAN B
		WHERE 	1=1
		AND 		A.SIM_PLAN_ID	= @v_simul_id
		AND 		A.SIM_PLAN_ID	= B.SIM_PLAN_ID
		AND 		A.OPERATION_ID IN ('P5000','P5200')
		AND 		A.OPERATION_ID != B.OPERATION_ID 
		AND 		A.PACK_MODEL_PLAN_ID = B.PACK_MODEL_PLAN_ID 

	    --LOG 생성
		SET @v_message =  'TOTAL YIELD UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			    
	        
	    
	END 	
	
	BEGIN
		
		
	--=========================================================
	-- 1-4. MODIFY ITEM ALT_ITEM, YIELD, BOM RATE UPDATE 
	-- 
	--=========================================================			

	
		-- 하위 공정 SIM IN QTY UPDATE : MODIFY QTY * 수율 
	    -- ALT PRIORITY =1 인 MODULE만 UPDATE
	    -- ALT PRIORITY =1 인 MODULE이 여러개 일 경우 1/N로 수량 보정
	    
		UPDATE B
		SET 		B.SIM_QTY = CEILING(A.SIM_QTY / A.TOTAL_YIELD * ISNULL(B.BOM_RATE,1) / ISNULL(C.CNT, 1)),
					B.SIM_IN_QTY = CEILING(A.SIM_QTY / B.TOTAL_YIELD * ISNULL(B.BOM_RATE,1) / ISNULL(C.CNT, 1)),
					B.MODIFY_FLAG = 'Y'
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A,
					BUF_PACK_MATERIAL_SIM_PLAN B
					LEFT OUTER JOIN (SELECT 	PACK_MODEL_PLAN_ID, ALT_ID, COUNT(*) AS CNT
											FROM 	BUF_PACK_MATERIAL_SIM_PLAN A
											WHERE 	1=1	
											AND 		A.SIM_PLAN_ID	= @v_simul_id
											AND 		ALT_ID IS NOT NULL
											AND 		ALT_PRIORITY = 1
											GROUP BY PACK_MODEL_PLAN_ID, ALT_ID) C
					ON 	1=1
					AND 	B.PACK_MODEL_PLAN_ID = C.PACK_MODEL_PLAN_ID
					AND 	B.ALT_ID = C.ALT_ID
		WHERE 	1=1
		AND 		A.SIM_PLAN_ID	= @v_simul_id
		AND 		A.SIM_PLAN_ID	= B.SIM_PLAN_ID
		AND 		A.MODIFY_FLAG = 'Y'
		AND 		A.PACK_MODEL_PLAN_ID = B.PACK_MODEL_PLAN_ID 
		AND 		A.OPERATION_ID != B.OPERATION_ID 
		AND 		(B.ALT_PRIORITY IS NULL OR B.ALT_PRIORITY = 1)

	    --LOG 생성
		SET @v_message =  'MODULE SIM QTY UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr	
	    
	    -- QTY = 0 Data Delete
	    
		DELETE	BUF_PACK_MATERIAL_SIM_PLAN 
		WHERE 	1=1
		AND 		SIM_PLAN_ID	= @v_simul_id
		AND 		SIM_QTY 		<= 0


	    --LOG 생성
		SET @v_message =  'MODULE SIM QTY UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr		    
	    
	
	END
	

	BEGIN 
	--=========================================================
	-- 2. BOM 전개 - CELL / MATERIAL 
	-- MODUE은 보류  
	--=========================================================
	
		-- MATERIAL CLASS 정의
		
		SET @v_table_name = 'PACK_MATERIAL_SIM_CLASS'
		
--		CREATE TABLE BUF_PACK_MATERIAL_SIM_CLASS
--			(
--			INSTANCE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SIM_PLAN_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_TYPE nvarchar(30) COLLATE Latin1_General_CI_AS NULL,
--			MATERIAL_CLASS nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_CLASS_NAME nvarchar(150) COLLATE Latin1_General_CI_AS NULL
--			)
		
		INSERT INTO BUF_PACK_MATERIAL_SIM_CLASS
		SELECT 	@v_instance_id AS INSTANCE_ID
					,@v_simul_id AS SIM_PLAN_ID
					,'MATERIAL' AS MATERIAL_TYPE
					,B.CLASS_ID AS MATERIAL_CLASS
					,B.CLASS_NAME AS MATERIAL_CLASS_NAME
  		FROM		SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK),
  				 	SCM_ITEM_CLASS_M B WITH(NOLOCK)
  		WHERE  	1=1
  		AND    	A.SEGMENT1 = @v_instance_id
  		AND    	A.LOOKUP_TYPE_CODE = 'MATERIAL_SIMUL_ITEM_DEFINIT'      			   
		AND 		A.SEGMENT2 = B.CLASS_ID
		AND 		A.ACTIVE_FLAG = 'Y'
		AND 		A.ATTRIBUTE1 = 'Y'
		
	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr			    			
	    
	    
	    -- MATERIAL BOM 전개
	    -- 대체는 1순위만 적용
	    
		SET @v_table_name = 'PACK_MATERIAL_SIM_BOM'	    
		
--		CREATE TABLE #PACK_MATERIAL_SIM_BOM 
--			(
--			INSTANCE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SIM_PLAN_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			FACTORY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			OPERATION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			LINE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			PRODUCTION_TYPE nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			MODEL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			ITEM_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_TYPE nvarchar(30) COLLATE Latin1_General_CI_AS NULL,
--			MATERIAL_CLASS nvarchar(30) COLLATE Latin1_General_CI_AS NULL,
--			PLAN_DATE datetime NOT NULL,
--			SIM_QTY numeric(20,10) NULL,
--			BOM_RATE numeric(20,10) DEFAULT 1 NULL,
--			MATERIAL_QTY numeric(20,10) NULL		
--			)
	    
   
		INSERT INTO BUF_PACK_MATERIAL_SIM_BOM
		SELECT 	DISTINCT A.INSTANCE_ID
					,A.SIM_PLAN_ID
					,A.COMPANY_ID
					,A.DIVISION_ID
					,A.SITE_ID
					,A.PLANT_ID
					,A.FACTORY_ID
					,A.OPERATION_ID
					,A.LINE_ID
					,A.PRODUCTION_TYPE
					,A.MODEL_ID
					,A.ITEM_ID
					,B.CHILD_ITEM_ID AS MATERIAL_ID
					,'MATERIAL' AS MATERIAL_TYPE
					,C.ITEM_CLASS AS MATERIAL_CLASS
					,A.PLAN_DATE
					,A.SIM_IN_QTY
					,B.CHILD_QTY / B.PARENT_QTY AS BOM_RATE
					,A.SIM_IN_QTY * (B.CHILD_QTY / B.PARENT_QTY) AS MATERIAL_QTY
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A,
					SCM_BOM_M B WITH(NOLOCK),
					SCM_ITEM_M C WITH(NOLOCK),
					BUF_PACK_MATERIAL_SIM_CLASS D
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.INSTANCE_ID = D.INSTANCE_ID
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.SIM_PLAN_ID = D.SIM_PLAN_ID
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND 		A.DIVISION_ID = B.DIVISION_ID
		AND 		A.SITE_ID = B.SITE_ID
		AND 		A.PLANT_ID = B.PLANT_ID
		AND 		A.ITEM_ID = B.PARENT_ITEM_ID
		AND 		A.PLAN_DATE < B.EFF_END_DATE
		AND 		A.PLAN_DATE >= B.EFF_START_DATE 
		AND 		B.ACTIVE_FLAG = 'Y'
		AND 		(B.ALT_ID IS NULL OR B.ALT_PRIORITY = 1)
		AND 		A.COMPANY_ID = C.COMPANY_ID
		AND 		A.DIVISION_ID = C.DIVISION_ID
		AND 		A.SITE_ID = C.SITE_ID
		AND 		B.CHILD_ITEM_ID = C.ITEM_ID
		AND 		C.ACTIVE_FLAG = 'Y'
		AND 		C.ITEM_CLASS = D.MATERIAL_CLASS	    
		UNION ALL 
		SELECT 	DISTINCT A.INSTANCE_ID
					,A.SIM_PLAN_ID
					,A.COMPANY_ID
					,A.DIVISION_ID
					,A.SITE_ID
					,A.PLANT_ID
					,A.FACTORY_ID
					,A.OPERATION_ID
					,A.LINE_ID
					,A.PRODUCTION_TYPE
					,A.MODEL_ID
					,A.ITEM_ID
					,B.CHILD_ITEM_ID AS MATERIAL_ID
					,'CELL' AS MATERIAL_TYPE
					,C.ITEM_CLASS AS MATERIAL_CLASS
					,A.PLAN_DATE
					,A.SIM_IN_QTY
					,B.CHILD_QTY / B.PARENT_QTY AS BOM_RATE
					,A.SIM_IN_QTY * (B.CHILD_QTY / B.PARENT_QTY) AS MATERIAL_QTY 
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A,
					SCM_BOM_M B,
					SCM_ITEM_M C,
					SCM_ITEM_CLASS_M D
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND 		A.DIVISION_ID = B.DIVISION_ID
		AND 		A.SITE_ID = B.SITE_ID
		AND 		A.PLANT_ID = B.PLANT_ID
		AND 		A.ITEM_ID = B.PARENT_ITEM_ID
		AND 		B.ACTIVE_FLAG = 'Y'
		AND 		A.PLAN_DATE < B.EFF_END_DATE
		AND 		A.PLAN_DATE >= B.EFF_START_DATE 
		AND 		A.COMPANY_ID = C.COMPANY_ID
		AND 		A.DIVISION_ID = C.DIVISION_ID
		AND 		A.SITE_ID = C.SITE_ID
		AND 		B.CHILD_ITEM_ID = C.ITEM_ID
		AND 		C.ACTIVE_FLAG = 'Y'
		AND 		C.ITEM_CLASS = D.CLASS_ID
		AND 		D.SCP_FLOW_ID = 'A9000'
		AND 		D.USE_FLAG = 'Y'
		AND 		(B.ALT_ID IS NULL OR B.ALT_PRIORITY = 1)
		
	    --LOG 생성		
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr			
	    
	    -- LINE BOM PRIORITY 반영
	    
	    UPDATE A
		SET 		A.MATERIAL_ID = B.REPLACE_ITEM_ID 
		FROM 	BUF_PACK_MATERIAL_SIM_BOM A,
					FP_LINE_BOM_PRIORITY_M B
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.PLANT_ID = B.PLANT_ID 
		AND 		A.ITEM_ID = B.PARENT_ITEM_ID 
		AND 		A.MATERIAL_ID = B.CHILD_ITEM_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.PLAN_DATE >= B.EFF_START_DATE 
		AND 		A.PLAN_DATE < B.EFF_END_DATE 

		
	    --LOG 생성
	    SET @v_message = 'LINE BOM PRIORITY MATERIAL UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			    
	    	    
	    -- CELL / MATERIAL 정의
	    
		SET @v_table_name = 'PACK_MATERIAL_SIM_ITEM_M'	    	  
		
--		CREATE TABLE #PACK_MATERIAL_SIM_ITEM_M 
--			(
--			INSTANCE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SIM_PLAN_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_TYPE nvarchar(30) COLLATE Latin1_General_CI_AS NULL,
--			MATERIAL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_CLASS nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			REMAIN_QTY numeric(20,10) DEFAULT 0 NOT NULL		
--			)
	    
		INSERT INTO BUF_PACK_MATERIAL_SIM_ITEM_M
	    SELECT 	DISTINCT A.INSTANCE_ID
	    			, A.SIM_PLAN_ID
	    			, A.COMPANY_ID
	    			, A.DIVISION_ID
	    			, A.SITE_ID
	    			, A.PLANT_ID
	    			, A.MATERIAL_TYPE
	    			, A.MATERIAL_ID
	    			, A.MATERIAL_CLASS
	    			, 0 AS REMAIN_QTY
	    FROM 	BUF_PACK_MATERIAL_SIM_BOM A
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		
	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	  EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		

	END



	BEGIN
		--=========================================================
		-- 3. CELL / MATERIAL STOCK 수량
		--      FORM 계획을 CELL STOCK PLAN으로 반영
		--=========================================================

		-- CELL STOCK PLAN 구성
		-- FORM PLAN으로 CELL STOCK PLAN 구성
		-- MRP 자재로 CELL BOH 구성 --> STOCK으로 변경 가능
		
		SET @v_table_name = 'PACK_MATERIAL_SIM_STOCK_CELL'
		
--		CREATE TABLE #PACK_MATERIAL_SIM_STOCK_CELL 
--			(
--			INSTANCE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SIM_PLAN_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			AVAILABLE_DATE datetime NOT NULL,
--			QTY numeric(20,10) NULL,
--			STOCK_TYPE nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL		
--			)		
			
		/*
		 * 2021.10.26 CELL 창고 재고는 LOOKUP에 정의된 시스템 재고 사용하도록 수정 (MES / SSP)
		 */
		INSERT INTO BUF_PACK_MATERIAL_SIM_STOCK_CELL
		SELECT	@v_instance_id AS INSTANCE_ID,
		    		@v_simul_id AS SIM_PLAN_ID,
		    		A.COMPANY_ID,
		    		A.DIVISION_ID,
		    		A.SITE_ID,
		    		A.PLANT_ID,
		    		A.ITEM_ID,
		    		DATEADD(DD, 1,A.PLAN_DATE) AS AVAILABLE_DATE,
					FLOOR(SUM(PLAN_QTY) / 2) AS QTY,
		    		'FORM_PLAN_1' AS STOCK_TYPE
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
					FP_INSTANCE_LINE_V B
		WHERE 	1=1
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		B.INSTANCE_ID IN (SELECT 	DISTINCT SEGMENT1 AS FORM_INSTANCE_ID
											FROM 	SCM_SYS_LOOKUP_VALUE
											WHERE 	1=1
											AND 		LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
											AND 		SEGMENT2 = @v_instance_id)
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND 		A.DIVISION_ID = B.DIVISION_ID
		AND 		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.PLAN_DATE >= @plan_start_time --DATEADD(DD, -1, @plan_start_time)
		AND 		A.PLAN_DATE <= DATEADD(DD, -1, @plan_end_time)
		AND 		A.PLAN_QTY > 0
		GROUP BY   A.COMPANY_ID,
		    			A.DIVISION_ID,
		    			A.SITE_ID,
		    			A.PLANT_ID,
		    			A.ITEM_ID,
		    			DATEADD(DD, 1,A.PLAN_DATE)
		UNION ALL
		SELECT	@v_instance_id AS INSTANCE_ID,
		    		@v_simul_id AS SIM_PLAN_ID,
		    		A.COMPANY_ID,
		    		A.DIVISION_ID,
		    		A.SITE_ID,
		    		A.PLANT_ID,
		    		A.ITEM_ID,
		    		A.PLAN_DATE AS AVAILABLE_DATE,
		    		CEILING(SUM(PLAN_QTY)/2) AS QTY,
		    		'FORM_PLAN_2' AS STOCK_TYPE
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
					FP_INSTANCE_LINE_V B
		WHERE 	1=1
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		B.INSTANCE_ID IN (SELECT 	DISTINCT SEGMENT1 AS FORM_INSTANCE_ID
											FROM 	SCM_SYS_LOOKUP_VALUE
											WHERE 	1=1
											AND 		LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
											AND 		SEGMENT2 = @v_instance_id)
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND 		A.DIVISION_ID = B.DIVISION_ID
		AND 		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.PLAN_DATE >= @plan_start_time
		AND 		A.PLAN_DATE <= @plan_end_time
		AND 		A.PLAN_QTY > 0
		GROUP BY   A.COMPANY_ID,
		    			A.DIVISION_ID,
		    			A.SITE_ID,
		    			A.PLANT_ID,
		    			A.ITEM_ID,
		    			A.PLAN_DATE
		UNION ALL		
		/*
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID		
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_ID 
					,B.AVAILABLE_DATE
					,SUM(B.QTY) AS QTY
					,'MRP_STOCK' AS STOCK_TYPE
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A,
					FP_MRP_CUTOFF_SUPPLY_H B WITH(NOLOCK)
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.MATERIAL_TYPE = 'CELL'
		AND 		B.CUTOFF_DATE = @key_date  
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND		A.DIVISION_ID = B.DIVISION_ID
		AND		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID
		AND 		A.MATERIAL_ID = B.ITEM_ID
		AND 		B.AVAILABLE_DATE <= @plan_end_time		
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID					
					,A.MATERIAL_ID
					,B.AVAILABLE_DATE		
		UNION ALL
		*/
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID		
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_ID 
--					,@key_date AS AVAILABLE_DATE
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END AS AVAILABLE_DATE
					,SUM(B.QTY) AS QTY
					,'PACK_STOCK' AS STOCK_TYPE
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A,
					SCM_STOCK_H_V B WITH(NOLOCK)
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.MATERIAL_TYPE = 'CELL'
		AND 		B.CUTOFF_DATE = @key_date  
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND		A.DIVISION_ID = B.DIVISION_ID
		AND		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID
		AND 		A.MATERIAL_ID = B.ITEM_ID
		AND 		B.AVAILABLE_DATE <= @plan_end_time		
		AND 		B.OPERATION_ID = 'P1000'
		AND   	B.STOCK_STATUS =  'WAIT' 
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID					
					,A.MATERIAL_ID
--					,B.AVAILABLE_DATE		
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END
		UNION ALL				
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID		
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_ID 
--					,@key_date AS AVAILABLE_DATE
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE CONVERT(DATETIME, CONVERT(NVARCHAR, B.AVAILABLE_DATE, 112)) END AS AVAILABLE_DATE
--					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END AS AVAILABLE_DATE					
					,SUM(B.QTY) AS QTY
					,'ERP_STOCK' AS STOCK_TYPE	
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A,
					SCM_STOCK_H_V B WITH(NOLOCK)
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.MATERIAL_TYPE = 'CELL'
		AND 		B.CUTOFF_DATE = @key_date  
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND		A.DIVISION_ID = B.DIVISION_ID
		AND		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID
		AND 		A.MATERIAL_ID = B.ITEM_ID
		AND 		B.AVAILABLE_DATE <= @plan_end_time		
		AND   	SUBSTRING (B.STORAGE_ID, 1, 1)  = '1'   
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	 			,A.SITE_ID
	  			,A.PLANT_ID					
					,A.MATERIAL_ID
--					,B.AVAILABLE_DATE 		
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE CONVERT(DATETIME, CONVERT(NVARCHAR, B.AVAILABLE_DATE, 112)) END
		UNION ALL
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID		
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_ID 
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END AS AVAILABLE_DATE
					,SUM(B.PACK_MOVE_QTY) AS QTY
					,'MOVING_STOCK' AS STOCK_TYPE	
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A,
					FP_SSP_STOCK_BACKUP_H B WITH(NOLOCK)
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.MATERIAL_TYPE = 'CELL'
		AND 		B.CUTOFF_DATE = @key_date  
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND		A.DIVISION_ID = B.DIVISION_ID
		AND		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID
		AND 		A.MATERIAL_ID = B.ITEM_ID
		AND 		B.AVAILABLE_DATE <= @plan_end_time		
		AND 		B.[HOLD] = 'N'
		AND 		B.PACK_MOVE_QTY > 0
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID					
					,A.MATERIAL_ID
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END 		
		UNION ALL 
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID		
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_ID 
--					,@key_date AS AVAILABLE_DATE
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END AS AVAILABLE_DATE
					,SUM(B.QTY) AS QTY
					,'DW_STOCK' AS STOCK_TYPE	
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A,
					SCM_STOCK_H_V B WITH(NOLOCK)
		WHERE 	1=1
		AND 		0=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 SSP 쪽 활성화  
            			SELECT 	ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_SSP  
              			FROM   	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              
              			WHERE  	A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'   
              			AND	   	A.ACTIVE_FLAG = 'Y'    
              			AND    	A.SEGMENT1 = @v_instance_id )  			
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.MATERIAL_TYPE = 'CELL'
		AND 		B.CUTOFF_DATE = @key_date  
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND		A.DIVISION_ID = B.DIVISION_ID
		AND		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID
		AND 		A.MATERIAL_ID = B.ITEM_ID
		AND 		B.AVAILABLE_DATE <= @plan_end_time		
		AND   	(B.STOCK_TYPE  = 'DW' AND B.STORAGE_ID = '-' )
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID					
					,A.MATERIAL_ID
--					,B.AVAILABLE_DATE 	
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END
		UNION ALL
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID		
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_ID 
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END AS AVAILABLE_DATE
					,SUM(B.QTY) AS QTY
					,'SSP_STOCK' AS STOCK_TYPE	
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A,
					FP_SSP_STOCK_BACKUP_H B WITH(NOLOCK)
		WHERE 	1=1
		AND 		1=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 SSP 쪽 활성화  
            			SELECT 	ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_SSP  
              			FROM   	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              
              			WHERE  	A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'   
              			AND	   	A.ACTIVE_FLAG = 'Y'    
              			AND    	A.SEGMENT1 = @v_instance_id )  		
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.MATERIAL_TYPE = 'CELL'
		AND 		B.CUTOFF_DATE = @key_date  
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND		A.DIVISION_ID = B.DIVISION_ID
		AND		A.SITE_ID = B.SITE_ID
		AND		A.PLANT_ID = B.PLANT_ID
		AND 		A.MATERIAL_ID = B.ITEM_ID
		AND 		B.AVAILABLE_DATE <= @plan_end_time		
		AND 		B.[HOLD] = 'N'
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID					
					,A.MATERIAL_ID
					,CASE WHEN B.AVAILABLE_DATE <= B.CUTOFF_DATE THEN B.CUTOFF_DATE ELSE B.AVAILABLE_DATE END 		
		UNION ALL 					
		SELECT 	@V_INSTANCE_ID AS INSTANCE_ID
					,@v_simul_id AS SIM_PLAN_ID		
					,A.COMPANY_ID
					,A.DIVISION_ID
					,A.SITE_ID
					,A.PLANT_ID
					,A.CELL_CODE AS MATERIAL_ID 
					,A.PLAN_DATE AS AVAILABLE_DATE
					,SUM(A.QTY) AS QTY
					,'INTRANSIT' AS STOCK_TYPE	            
		FROM 	(
					SELECT	A.COMPANY_ID,
					          	A.DIVISION_ID,
					          	A.SITE_ID,
					          	A.PLANT_ID,
					          	A.ITEM_ID  AS CELL_CODE ,
					          	B.SITE_ID  AS FROM_SITE,
					          	B.PLANT_ID AS FROM_PLANT_ID ,
					          	CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, @plan_start_time,112) THEN @plan_start_time
					                   ELSE convert(date,A.ETA_DATE) END AS PLAN_DATE ,
								A.DELIVERY_QTY AS QTY ,
								B.COMPANY_ID   AS FROM_COMPANY_ID
					FROM		FP_SCM_IN_TRANSIT_H A,
								(
								SELECT	DISTINCT A.COMPANY_ID, A.SITE_ID, A.PLANT_ID
								FROM		SCM_PLANT_M A
								) B,
								BUF_PACK_MATERIAL_SIM_ITEM_M C
					WHERE	1=1
					AND		A.RESULT_DATE = CONVERT(VARCHAR, DATEADD(DD, -1, CONVERT(DATE, @plan_start_time) ),112)
					AND		A.DELIVERY_QTY > 0
					AND 		A.FROM_PLANT_ID = B.PLANT_ID
					AND 		A.ETA_DATE < CONVERT(VARCHAR, @plan_end_time,112)
					AND 		A.ITEM_ID = C.MATERIAL_ID
					AND 		A.COMPANY_ID = C.COMPANY_ID 
					AND 		A.DIVISION_ID = C.DIVISION_ID
					AND    	A.SITE_ID = C.SITE_ID 
					AND 		A.PLANT_ID = C.PLANT_ID					     							             			
					UNION ALL          						
					SELECT	A.CUSTOMER_ID AS COMPANY_ID ,
					          	A.DIVISION_ID,
					          	A.TO_SITE_ID AS SITE_ID ,
					          	A.TO_PLANT_ID AS PLANT_ID ,
					          	A.ITEM_ID AS CELL_CODE ,
					          	A.SITE_ID AS FROM_SITE_ID ,
					          	A.PLANT_ID AS FROM_PLANT_ID ,
					          	CONVERT(DATE,A.RECEIVE_YYYYMMDD) AS PLAN_DATE ,
					          	A.SHIP_QTY AS QTY ,
					          	A.COMPANY_ID AS FROM_COMPANY_ID        			
					FROM		FP_WEEKLY_DEMAND_SHIPMENT_H A,
								BUF_PACK_MATERIAL_SIM_ITEM_M C
					WHERE	1=1             			
					AND		A.SHOP_GROUP_ID = 'A'
					AND 		A.SCP_PLAN_ID = 	(
														SELECT 	MAX(SCP_PLAN_ID) AS SCP_PLAN_ID
														FROM 	FP_WEEKLY_DEMAND_SHIPMENT_H A,
																	FP_INSTANCE_INFO_V B
														WHERE 	1=1
														AND		A.SHOP_GROUP_ID = 'A'
														AND 		B.INSTANCE_ID = @v_instance_id
														AND		A.CUSTOMER_ID = B.COMPANY_ID
														AND		A.DIVISION_ID = B.DIVISION_ID
														AND		A.TO_SITE_ID = B.SITE_ID
														AND		A.TO_PLANT_ID = B.PLANT_ID
														)
					AND 		A.RECEIVE_YYYYMMDD < CONVERT(VARCHAR, @plan_end_time,112)
					AND 		A.ITEM_ID = C.MATERIAL_ID
					AND 		A.CUSTOMER_ID = C.COMPANY_ID 
					AND 		A.DIVISION_ID = C.DIVISION_ID
					AND    	A.TO_SITE_ID = C.SITE_ID 
					AND 		A.TO_PLANT_ID = C.PLANT_ID						         	
					) A						         	
		WHERE 	1=1
		GROUP BY A.COMPANY_ID,
		            A.DIVISION_ID,
		            A.SITE_ID,
		            A.PLANT_ID,
		            A.CELL_CODE,
		            A.FROM_SITE,
		            A.PLAN_DATE		
					
	    --LOG 생성
		SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		
	    
--	    INSERT INTO BUF_PACK_MATERIAL_SIM_STOCK_CELL
--	    SELECT 	*
--	    FROM 	BUF_PACK_MATERIAL_SIM_STOCK_CELL
--	    WHERE 	1=1
--	    AND 		SIM_PLAN_ID = @v_simul_id
					
		
		SET @v_table_name = 'PACK_MATERIAL_SIM_STOCK'	    	    
		
--		CREATE TABLE #PACK_MATERIAL_SIM_STOCK 
--			(
--			INSTANCE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SIM_PLAN_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_TYPE nvarchar(30) COLLATE Latin1_General_CI_AS NULL,
--			MATERIAL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NOT NULL,
--			MATERIAL_CLASS nvarchar(30) COLLATE Latin1_General_CI_AS NULL,
--			AVAILABLE_DATE datetime NOT NULL,
--			QTY numeric(20,10) NULL		
--			)
	    
		INSERT INTO BUF_PACK_MATERIAL_SIM_STOCK 
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_TYPE
					,A.MATERIAL_ID
					,A.MATERIAL_CLASS 
					,ISNULL(B.AVAILABLE_DATE, @key_date) AS AVAILABLE_DATE
					,SUM(ISNULL(B.QTY,0)) AS QTY
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A
					LEFT OUTER JOIN FP_MRP_CUTOFF_SUPPLY_H B WITH(NOLOCK)
					ON 	1=1
					AND 	B.CUTOFF_DATE = @key_date  
					AND 	A.COMPANY_ID = B.COMPANY_ID
					AND	A.DIVISION_ID = B.DIVISION_ID
					AND	A.SITE_ID = B.SITE_ID
					AND	A.PLANT_ID = B.PLANT_ID
					AND 	A.MATERIAL_ID = B.ITEM_ID
					AND 	B.AVAILABLE_DATE <= @plan_end_time
					AND 	(B.SUPPLY_TYPE = 'SUPPLY_PLAN' OR (B.SUPPLY_TYPE = 'STOCK' AND LEFT(B.STORAGE_ID,1) = '1')) 
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.MATERIAL_TYPE = 'MATERIAL'
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID					
					,A.MATERIAL_TYPE
					,A.MATERIAL_ID
					,A.MATERIAL_CLASS 
					,B.AVAILABLE_DATE 
		UNION ALL 
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_TYPE
					,A.MATERIAL_ID
					,A.MATERIAL_CLASS 
					,ISNULL(B.AVAILABLE_DATE, @key_date) AS AVAILABLE_DATE
					,SUM(ISNULL(B.QTY,0)) AS QTY
		FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A
					LEFT OUTER JOIN BUF_PACK_MATERIAL_SIM_STOCK_CELL B
					ON 	1=1
					AND 	A.MATERIAL_ID = B.MATERIAL_ID
					AND 	A.COMPANY_ID = B.COMPANY_ID
					AND 	A.DIVISION_ID = B.DIVISION_ID
					AND 	A.SITE_ID = B.SITE_ID
					AND 	A.PLANT_ID = B.PLANT_ID
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id
		AND 		A.INSTANCE_ID = B.INSTANCE_ID
		AND 		A.SIM_PLAN_ID = B.SIM_PLAN_ID
		AND 		A.MATERIAL_TYPE = 'CELL'
		GROUP BY A.INSTANCE_ID
					,A.SIM_PLAN_ID
	    			,A.COMPANY_ID
	    			,A.DIVISION_ID
	    			,A.SITE_ID
	    			,A.PLANT_ID
					,A.MATERIAL_TYPE
					,A.MATERIAL_ID
					,A.MATERIAL_CLASS 
					,B.AVAILABLE_DATE
		
	    --LOG 생성
		SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	  EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		
		
	END

	BEGIN
		--=========================================================
		-- 4. 1차 FP_SIM_MATERIAL_PACK_R 구성
		--=========================================================

		SET @v_table_name = 'FP_SIM_MATERIAL_PACK_R'
		
		DELETE	FROM FP_SIM_MATERIAL_PACK_R
	    WHERE 	INSTANCE_ID = @v_instance_id 
	    AND 		SIM_PLAN_ID = @v_simul_id
	     
	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr              
		
		-- CELL STOCK PLAN 구성
		-- FORM PLAN으로 CELL STOCK PLAN 구성
		-- MRP 자재로 CELL BOH 구성 --> STOCK으로 변경 가능
		
		SET @v_table_name = 'FP_SIM_MATERIAL_PACK_R'	
		
		INSERT INTO FP_SIM_MATERIAL_PACK_R	
		SELECT 	A.INSTANCE_ID
					,A.SIM_PLAN_ID
					,A.COMPANY_ID
					,A.DIVISION_ID
					,A.SITE_ID
					,A.PLANT_ID
					,A.FACTORY_ID
					,A.OPERATION_ID
					,A.LINE_ID
					,A.PRODUCTION_TYPE
					,A.MODEL_ID
					,A.ITEM_ID
					,'-' AS CATEGORY_ID
					,A.PLAN_DATE
					,A.SIM_IN_QTY
					,A.SIM_QTY
					,A.PLAN_IN_QTY
					,A.PLAN_QTY
					,CASE WHEN A.OPERATION_ID IN ('P5000','P5200') THEN A.SIM_IN_QTY ELSE A.SIM_IN_QTY END AS CELL_SIM_QTY
					,A.SIM_IN_QTY AS MATERIAL_QTY
					,0 AS AVAILABLE_QTY
					,0 AS UI_SIM_QTY
					,0 AS UI_CELL_SIM_QTY
					,0 AS UI_MATERIAL_QTY
					,0 AS UI_AVAILABLE_QTY					
					,A. YIELD
					,A.TOTAL_YIELD
					,A.BOM_RATE
					,A.TOP_LINE_ID			
					,A.PACK_MODEL_PLAN_ID
					,A.ALT_ID
					,A.ALT_PRIORITY						
					,NULL AS ATTB_01
					,A.MODIFY_FLAG AS ATTB_02
					,B.MATERIAL_ID AS ATTB_03
					,CONVERT(NVARCHAR, B.BOM_RATE) AS ATTB_04
					,NULL AS ATTB_05
					,@v_proc_name AS INSERT_ID
					,GETDATE() AS INSERT_DTTM
					,@v_proc_name AS UPDATE_ID
					,GETDATE() AS UPDATE_DTTM
		FROM 	BUF_PACK_MATERIAL_SIM_PLAN A
					LEFT OUTER JOIN BUF_PACK_MATERIAL_SIM_BOM B
					ON 	1=1
					AND 	A.INSTANCE_ID = B.INSTANCE_ID 
					AND 	A.SIM_PLAN_ID = B.SIM_PLAN_ID 
					AND 	B.MATERIAL_TYPE = 'CELL'	
					AND 	A.MODEL_ID = B.MODEL_ID 
					AND 	A.ITEM_ID = B.ITEM_ID 
					AND  A.PLAN_DATE = B.PLAN_DATE 
					AND 	A.LINE_ID = B.LINE_ID 
					AND 	A.OPERATION_ID = B.OPERATION_ID 
					AND 	A.PRODUCTION_TYPE = B.PRODUCTION_TYPE 		
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id

	    --LOG 생성
		SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		
	    
	    
	END
	
	

		--=========================================================
		-- 5. LOGIC 구성
		--=========================================================

	BEGIN	

		DECLARE  @coursor_count           integer = 0
					, @c_plan_date				nvarchar(200)
					
		SET @v_table_name = 'C_PLAN_DATE'
		
		--LOG 생성
		SET @v_message = '--------------- C_PLAN_DATE ---------------'
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
		
		DECLARE C_PLAN_DATE CURSOR FOR
		-- PLAN DATE 별 LOGIC 수행
		
			SELECT 	A.YYYYMMDD AS PLAN_DATE
			FROM 	TH_UIS_CAL A,
						FP_SIM_PLAN_H B
			WHERE 	1=1
			AND		B.INSTANCE_ID	= @v_instance_id
			AND		B.SIM_PLAN_ID	= @v_simul_id
			AND 		A.YYYYMMDD >=  CONVERT(NVARCHAR, B.PLAN_START_TIME, 112)
			AND 		A.YYYYMMDD <=  CONVERT(NVARCHAR, B.PLAN_END_TIME, 112)
			ORDER BY A.YYYYMMDD
		
			 --LOG 생성
			SET @v_table_name = 'C_PLAN_DATE'
			SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
		
		OPEN C_PLAN_DATE
		
			WHILE 1=1
			BEGIN
			
				FETCH C_PLAN_DATE
				INTO   @c_plan_date
					
					IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
					   BREAK
			
					--LOG 생성
					SET @v_message = '--------------- ' + @c_plan_date + ' ---------------'
					SET @n_log_count = @n_log_count + 1
					SET @sysdate = GETDATE()
					EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
			
					BEGIN
							
							-- PLAN DATE 별 가용 MATERIAL 수량 UPDATE
						
							UPDATE	A
							SET		A.REMAIN_QTY = ISNULL(A.REMAIN_QTY,0) + ISNULL(B.QTY,0)
							FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A
										LEFT OUTER JOIN BUF_PACK_MATERIAL_SIM_STOCK B
										ON 	1=1
										AND 	A.INSTANCE_ID = B.INSTANCE_ID 
										AND 	A.SIM_PLAN_ID = B.SIM_PLAN_ID 
										AND 	A.COMPANY_ID = B.COMPANY_ID 
										AND 	A.DIVISION_ID = B.DIVISION_ID 
										AND 	A.SITE_ID = B.SITE_ID 
										AND 	A.PLANT_ID = B.PLANT_ID 
										AND 	A.MATERIAL_ID = B.MATERIAL_ID 
										AND 	 CONVERT(NVARCHAR, B.AVAILABLE_DATE, 112)  = @c_plan_date
							WHERE 	1=1
							AND 		A.INSTANCE_ID	= @v_instance_id
							AND		A.SIM_PLAN_ID	= @v_simul_id
							
							BEGIN	
								
								-- PLAN DATE 별 PLAN 확인
						
								DECLARE  @coursor_count_1           	integer = 0
											, @c_factory_id					nvarchar(200)
											, @c_operation_id				nvarchar(200)
											, @c_line_id						nvarchar(200)
											, @c_model_id					nvarchar(200)
											, @c_item_id						nvarchar(200)
											, @c_sim_qty					numeric(20,10)
											
								SET @v_table_name = 'C_SIM_PLAN'
								
								--LOG 생성
								SET @v_message = '--------------- C_SIM_PLAN ---------------'
								SET @n_log_count = @n_log_count + 1
								SET @sysdate = GETDATE()
								EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
								
								DECLARE C_SIM_PLAN CURSOR FOR
								-- PLAN DATE 별 LOGIC 수행
								
									SELECT 	A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.MODEL_ID, A.ITEM_ID, A.SIM_QTY
									FROM 	BUF_PACK_MATERIAL_SIM_PLAN A
									WHERE 	1=1
									AND 		A.INSTANCE_ID	= @v_instance_id
									AND		A.SIM_PLAN_ID	= @v_simul_id
									AND 		A.PLAN_DATE = @c_plan_date
									ORDER BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.MODEL_ID, A.ITEM_ID
								
									 --LOG 생성
									SET @v_table_name = 'C_SIM_PLAN'
									SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
									SET @n_log_count = @n_log_count + 1
									SET @sysdate = GETDATE()
									EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
								
								OPEN C_SIM_PLAN
								
									WHILE 1=1
									BEGIN
									
										FETCH C_SIM_PLAN
										INTO   @c_factory_id
												, @c_operation_id
												, @c_line_id
												, @c_model_id
												, @c_item_id
												, @c_sim_qty
											
											IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
											   BREAK
									
											--LOG 생성
											SET @v_message = '--------------- ' + @c_plan_date + ', ' + @c_factory_id  + ', ' + @c_operation_id  + ', ' + @c_line_id  + ', ' + @c_model_id  + ', ' + @c_item_id + ' ---------------'
											SET @n_log_count = @n_log_count + 1
											SET @sysdate = GETDATE()
											EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
											

											BEGIN	
												
												-- PLAN DATE 별 PLAN 별 MATERIAL PLAN 확인
										
												DECLARE  @coursor_count_2          	integer = 0
															, @c_material_id				nvarchar(200)
															, @c_material_type				nvarchar(200)
															, @c_bom_rate					numeric(20,10)
															, @c_material_qty				numeric(20,10)
															, @C_m_rate_qty				int
															
												SET @v_table_name = 'C_SIM_MATERIAL'
												
												--LOG 생성
												SET @v_message = '--------------- C_SIM_MATERIAL ---------------'
												SET @n_log_count = @n_log_count + 1
												SET @sysdate = GETDATE()
												EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null				
												
											DECLARE C_SIM_MATERIAL CURSOR FOR
											-- PLAN DATE 별 LOGIC 수행
											
												SELECT 	A.MATERIAL_ID, A.MATERIAL_TYPE, A.BOM_RATE, A.MATERIAL_QTY
															, CASE WHEN ISNULL(B.REMAIN_QTY,0) = 0 THEN 0 
																	ELSE CONVERT (INT, (ISNULL(B.REMAIN_QTY,0) / A.BOM_RATE) / (A.MATERIAL_QTY / A.BOM_RATE)) END AS M_RATE_QTY  
												FROM 	BUF_PACK_MATERIAL_SIM_BOM A,
															BUF_PACK_MATERIAL_SIM_ITEM_M B
												WHERE 	1=1
												AND		A.INSTANCE_ID	= @v_instance_id
												AND		A.SIM_PLAN_ID	= @v_simul_id
												AND		A.INSTANCE_ID	= B.INSTANCE_ID
												AND		A.SIM_PLAN_ID	= B.SIM_PLAN_ID												
												AND 		A.PLAN_DATE = @c_plan_date
												AND 		A.FACTORY_ID = @c_factory_id
												AND 		A.OPERATION_ID = @c_operation_id
												AND 		A.LINE_ID = @c_line_id
												AND 		A.MODEL_ID = @c_model_id
												AND 		A.ITEM_ID = @c_item_id
												AND 		A.MATERIAL_TYPE = B.MATERIAL_TYPE 
												AND 		A.MATERIAL_ID = B.MATERIAL_ID 
												ORDER BY CASE WHEN ISNULL(B.REMAIN_QTY,0) = 0 THEN 0 
																	ELSE (ISNULL(B.REMAIN_QTY,0) / A.BOM_RATE) / (A.MATERIAL_QTY / A.BOM_RATE) END, A.MATERIAL_TYPE, A.MATERIAL_ID
											
												 --LOG 생성
												SET @v_table_name = 'C_SIM_MATERIAL'
												SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
												SET @n_log_count = @n_log_count + 1
												SET @sysdate = GETDATE()
												EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null			
												
											OPEN C_SIM_MATERIAL
											
												WHILE 1=1
												BEGIN
												
													FETCH C_SIM_MATERIAL
													INTO   @c_material_id
															, @c_material_type
															, @c_bom_rate
															, @c_material_qty
															, @C_m_rate_qty
														
														IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
														   BREAK
												
														--LOG 생성
														SET @v_message = '--------------- ' + @c_material_id + ', ' + @c_material_type  + ', '  + CONVERT(NVARCHAR, @c_material_qty)  + ', ' + CONVERT(NVARCHAR, @C_m_rate_qty) + ' ---------------'
														SET @n_log_count = @n_log_count + 1
														SET @sysdate = GETDATE()
														EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null		
														
														BEGIN
																
																UPDATE	A
																SET		A.CELL_SIM_QTY = CASE WHEN B.MATERIAL_TYPE = 'CELL' AND A.CELL_SIM_QTY <= ISNULL(B.REMAIN_QTY,0) / @c_bom_rate THEN A.CELL_SIM_QTY
																					 WHEN B.MATERIAL_TYPE = 'CELL' AND A.CELL_SIM_QTY > ISNULL(B.REMAIN_QTY,0) / @c_bom_rate THEN CONVERT (INT, ISNULL(B.REMAIN_QTY,0) / @c_bom_rate)
																					ELSE A.CELL_SIM_QTY END,
																			A.MATERIAL_QTY =  CASE WHEN B.MATERIAL_TYPE = 'MATERIAL' AND A.MATERIAL_QTY <= (ISNULL(B.REMAIN_QTY,0) / @c_bom_rate) THEN A.MATERIAL_QTY
																					 WHEN B.MATERIAL_TYPE = 'MATERIAL' AND A.MATERIAL_QTY > (ISNULL(B.REMAIN_QTY,0) / @c_bom_rate) THEN CONVERT (INT, ISNULL(B.REMAIN_QTY,0) / @c_bom_rate)
																					ELSE A.MATERIAL_QTY END, 
																			A.ATTB_01 =  CASE WHEN B.MATERIAL_TYPE = 'CELL' AND A.CELL_SIM_QTY > ISNULL(B.REMAIN_QTY,0) / @c_bom_rate THEN @c_material_id
																					WHEN B.MATERIAL_TYPE = 'MATERIAL' AND A.MATERIAL_QTY > ISNULL(B.REMAIN_QTY,0) / @c_bom_rate THEN @c_material_id
																					ELSE ATTB_01 END
																FROM 	FP_SIM_MATERIAL_PACK_R A
																			, BUF_PACK_MATERIAL_SIM_ITEM_M B
																WHERE 	1=1
																AND		A.INSTANCE_ID	= @v_instance_id
																AND		A.SIM_PLAN_ID	= @v_simul_id
																AND		A.INSTANCE_ID	= B.INSTANCE_ID
																AND		A.SIM_PLAN_ID	= B.SIM_PLAN_ID
																AND 		A.MODEL_ID = @c_model_id
																AND 		A.ITEM_ID = @c_item_id
																AND 		A.PLAN_DATE = @c_plan_date
																AND 		A.OPERATION_ID = @c_operation_id
																AND 		A.LINE_ID = @c_line_id
																AND 		B.MATERIAL_ID = @c_material_id
																;
																
																UPDATE	A
																SET 		A.REMAIN_QTY = CASE WHEN A.MATERIAL_TYPE = 'CELL' THEN ISNULL(A.REMAIN_QTY,0) - (ISNULL(B.CELL_SIM_QTY,0) * @c_bom_rate)
																					WHEN A.MATERIAL_TYPE = 'MATERIAL' THEN ISNULL(A.REMAIN_QTY,0) - (ISNULL(B.MATERIAL_QTY,0)  * @c_bom_rate) END 
																FROM 	BUF_PACK_MATERIAL_SIM_ITEM_M A
																			, FP_SIM_MATERIAL_PACK_R B
																WHERE 	1=1
																AND		A.INSTANCE_ID	= @v_instance_id
																AND		A.SIM_PLAN_ID	= @v_simul_id
																AND		A.INSTANCE_ID	= B.INSTANCE_ID
																AND		A.SIM_PLAN_ID	= B.SIM_PLAN_ID
																AND 		B.MODEL_ID = @c_model_id
																AND 		B.ITEM_ID = @c_item_id
																AND 		B.PLAN_DATE = @c_plan_date
																AND 		B.OPERATION_ID = @c_operation_id
																AND 		B.LINE_ID = @c_line_id
																AND 		A.MATERIAL_ID = @c_material_id
																
																SET @coursor_count_2 += @@ROWCOUNT	
														END

												END			
												
											CLOSE       C_SIM_MATERIAL
											DEALLOCATE  C_SIM_MATERIAL											
									
										END							
										
										SET @coursor_count_1 += @@ROWCOUNT												
									
									END			
									
								CLOSE       C_SIM_PLAN
								DEALLOCATE  C_SIM_PLAN								
						
							END							
							
							SET @coursor_count += @@ROWCOUNT	
					END
			
			END			
			
		CLOSE       C_PLAN_DATE
		DEALLOCATE  C_PLAN_DATE	

	END
	
	BEGIN
		--=========================================================
		-- 6. UI용 FP_SIM_MATERIAL_PACK_R 구성
		--=========================================================
       
		
		-- SIM QTY UPDATE : MODEL 기준으로 변경
		
		SET @v_table_name = 'FP_SIM_MATERIAL_PACK_R'	
		
		UPDATE A
		SET 		A.UI_SIM_QTY = B.UI_SIM_QTY
		FROM 	FP_SIM_MATERIAL_PACK_R A,
					(			
					SELECT 	PACK_MODEL_PLAN_ID, SIM_QTY AS UI_SIM_QTY
					FROM 	FP_SIM_MATERIAL_PACK_R A
					WHERE 	1=1
					AND 		A.SIM_PLAN_ID	= @v_simul_id
					AND 		A.MODEL_ID = A.ITEM_ID 
					) B
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id 
		AND 		A.PACK_MODEL_PLAN_ID = B.PACK_MODEL_PLAN_ID

	 --LOG 생성
		SET @v_message = 'UI SIM QTY UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr		
	    
		-- SIM CELL/MATERIAL QTY UPDATE : MODEL 기준으로 변경	
		
		UPDATE A
		SET 		A.UI_CELL_SIM_QTY = CASE WHEN C.CNT > 1 AND A.ATTB_02 = 'Y' THEN ROUND(A.CELL_SIM_QTY * A.TOTAL_YIELD / ISNULL(A.BOM_RATE,1), 1) 
													  WHEN C.CNT > 1 THEN ROUND(A.CELL_SIM_QTY * A.YIELD / ISNULL(A.BOM_RATE,1), 1)
													  WHEN A.ATTB_02 = 'Y' AND ABS(A.SIM_QTY - (A.CELL_SIM_QTY * A.TOTAL_YIELD)) < 1 THEN A.SIM_QTY / ISNULL(A.BOM_RATE,1)
													  WHEN ABS(A.SIM_QTY - (A.CELL_SIM_QTY * A.YIELD)) < 1 THEN A.SIM_QTY / ISNULL(A.BOM_RATE,1)
													  WHEN A.ATTB_02 = 'Y' AND A.SIM_QTY < (A.CELL_SIM_QTY * A.TOTAL_YIELD / ISNULL(A.BOM_RATE,1)) THEN A.SIM_QTY
													  WHEN A.SIM_QTY < (A.CELL_SIM_QTY * A.YIELD) THEN A.SIM_QTY / ISNULL(A.BOM_RATE,1)
													  WHEN A.ATTB_02 = 'Y' THEN FLOOR(A.CELL_SIM_QTY * A.TOTAL_YIELD / ISNULL(A.BOM_RATE,1)) * 10 / 10
													  ELSE FLOOR(A.CELL_SIM_QTY * A.YIELD / ISNULL(A.BOM_RATE,1)) * 10 / 10 END,
					A.UI_MATERIAL_QTY = CASE WHEN C.CNT > 1 AND A.ATTB_02 = 'Y' THEN ROUND(A.MATERIAL_QTY * A.TOTAL_YIELD / ISNULL(A.BOM_RATE,1), 1) 
													  WHEN C.CNT > 1 THEN ROUND(A.MATERIAL_QTY * A.YIELD / ISNULL(A.BOM_RATE,1), 1)
													  WHEN A.ATTB_02 = 'Y' AND ABS(A.SIM_QTY - (A.MATERIAL_QTY * A.TOTAL_YIELD)) < 1 THEN A.SIM_QTY / ISNULL(A.BOM_RATE,1)
													  WHEN ABS(A.SIM_QTY - (A.MATERIAL_QTY * A.YIELD)) < 1 THEN A.SIM_QTY / ISNULL(A.BOM_RATE,1)
													  WHEN A.ATTB_02 = 'Y' AND A.SIM_QTY < (A.MATERIAL_QTY * A.TOTAL_YIELD) THEN A.SIM_QTY / ISNULL(A.BOM_RATE,1)
													  WHEN A.SIM_QTY < (A.MATERIAL_QTY * A.YIELD) THEN A.SIM_QTY / ISNULL(A.BOM_RATE,1)
													  WHEN A.ATTB_02 = 'Y' THEN FLOOR(A.MATERIAL_QTY * A.TOTAL_YIELD / ISNULL(A.BOM_RATE,1)) * 10 / 10
													  ELSE FLOOR(A.MATERIAL_QTY * A.YIELD / ISNULL(A.BOM_RATE,1)) * 10 / 10 END 
		FROM 	FP_SIM_MATERIAL_PACK_R A
				LEFT OUTER JOIN (
										SELECT 	PACK_MODEL_PLAN_ID, ALT_ID, COUNT(*) AS CNT
										FROM 	BUF_PACK_MATERIAL_SIM_PLAN A
										WHERE 	1=1	
										AND 		A.SIM_PLAN_ID	= @v_simul_id
										AND 		ALT_ID IS NOT NULL
										AND 		ALT_PRIORITY = 1
										GROUP BY PACK_MODEL_PLAN_ID, ALT_ID
										) C
				ON 	1=1
				AND 	A.PACK_MODEL_PLAN_ID = C.PACK_MODEL_PLAN_ID
				AND 	A.ALT_ID = C.ALT_ID			
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id 

	    --LOG 생성
		SET @v_message = 'UI SIM CELL/MATERIAL QTY UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			    
	    
		-- SIM AVAILABLE QTY UPDATE : MODEL 기준으로 변경	
		
		UPDATE A
		SET 		A.AVAILABLE_QTY = CASE WHEN A.OPERATION_ID IN ('P5500','P9500') THEN  A.UI_MATERIAL_QTY
													  WHEN A.OPERATION_ID IN ('P5000','P5200') AND A.UI_CELL_SIM_QTY > A.UI_MATERIAL_QTY	THEN  A.UI_MATERIAL_QTY
													  ELSE A.UI_CELL_SIM_QTY END

		FROM 	FP_SIM_MATERIAL_PACK_R A
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id 

	    --LOG 생성
		SET @v_message = 'UI SIM AVAILABLE QTY UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			 
	    
	    -- SIM UI AVAILABLE QTY UPDATE : MODEL 기준으로 변경	
	    
		UPDATE A
		SET 		A.UI_AVAILABLE_QTY = B.UI_AVAILABLE_QTY
		FROM 	FP_SIM_MATERIAL_PACK_R A,
					(			
					SELECT 	A.PACK_MODEL_PLAN_ID, MIN(A.AVAILABLE_QTY) AS UI_AVAILABLE_QTY
					FROM 	(
								SELECT 	PACK_MODEL_PLAN_ID, OPERATION_ID, ALT_ID, SUM(A.AVAILABLE_QTY) AS AVAILABLE_QTY
								FROM 	FP_SIM_MATERIAL_PACK_R A
								WHERE 	1=1
								AND 		A.INSTANCE_ID = @v_instance_id
								AND 		A.SIM_PLAN_ID	= @v_simul_id
								GROUP BY  PACK_MODEL_PLAN_ID, OPERATION_ID, ALT_ID
								) A
					GROUP BY A.PACK_MODEL_PLAN_ID
					) B
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id 
		AND 		A.PACK_MODEL_PLAN_ID = B.PACK_MODEL_PLAN_ID

	    --LOG 생성
		SET @v_message = 'UI SIM GROUP AVAILABLE QTY UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr	
	    
	    -- CELL ITEM ID UPDATE : MODEL 기준으로 변경	
	    
		UPDATE A
		SET 		A.ATTB_03 = B.ATTB_03,
					A.ATTB_04 = B.ATTB_04
		FROM 	FP_SIM_MATERIAL_PACK_R A,
					(			
					SELECT 	PACK_MODEL_PLAN_ID, MAX(ATTB_03) AS ATTB_03, MAX(ATTB_04) AS ATTB_04
					FROM 	FP_SIM_MATERIAL_PACK_R A
					WHERE 	1=1
					AND 		A.INSTANCE_ID = @v_instance_id
					AND 		A.SIM_PLAN_ID	= @v_simul_id
					GROUP BY  PACK_MODEL_PLAN_ID
					) B
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_instance_id
		AND 		A.SIM_PLAN_ID = @v_simul_id 
		AND 		A.PACK_MODEL_PLAN_ID = B.PACK_MODEL_PLAN_ID

	    --LOG 생성
		SET @v_message = 'CELL ITEM ID UPDATE : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr				    

	    
	END
	
    -- TEMP 테이블 DROP
--    BEGIN        
	    
--      DROP TABLE #PACK_MATERIAL_SIM_PLAN
      
      --LOG 생성
--      SET @v_table_name = 'PACK_MATERIAL_SIM_PLAN'
--      SET @v_message = @@ROWCOUNT
--      SET @v_descr = NULL
--      SET @n_log_count = @n_log_count + 1
--      SET @sysdate = GETDATE()
--      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr  
      
--      DROP TABLE  BUF_PACK_MATERIAL_SIM_CLASS
      
      --LOG 생성
--      SET @v_table_name = 'PACK_MATERIAL_SIM_CLASS'
--      SET @v_message = @@ROWCOUNT
--      SET @v_descr = NULL
--      SET @n_log_count = @n_log_count + 1
--      SET @sysdate = GETDATE()
--      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr        
--      
--      DROP TABLE  #PACK_MATERIAL_SIM_BOM
      
      --LOG 생성
--      SET @v_table_name = 'PACK_MATERIAL_SIM_BOM'
--      SET @v_message = @@ROWCOUNT
--      SET @v_descr = NULL
--      SET @n_log_count = @n_log_count + 1
--      SET @sysdate = GETDATE()
--      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr       
      
--      DROP TABLE  #PACK_MATERIAL_SIM_ITEM_M
      
      --LOG 생성
--      SET @v_table_name = 'PACK_MATERIAL_SIM_ITEM_M'
--      SET @v_message = @@ROWCOUNT
--      SET @v_descr = NULL
--      SET @n_log_count = @n_log_count + 1
--      SET @sysdate = GETDATE()
--      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr                  
          
--      DROP TABLE   #PACK_MATERIAL_SIM_STOCK_CELL
      
      --LOG 생성
--      SET @v_table_name = 'PACK_MATERIAL_SIM_STOCK_CELL'
--      SET @v_message = @@ROWCOUNT
--      SET @v_descr = NULL
--      SET @n_log_count = @n_log_count + 1
--      SET @sysdate = GETDATE()
--      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr           
      
--      DROP TABLE #PACK_MATERIAL_SIM_STOCK 
      
      --LOG 생성
--      SET @v_table_name = 'PACK_MATERIAL_SIM_STOCK'
--      SET @v_message = @@ROWCOUNT
--      SET @v_descr = NULL
--      SET @n_log_count = @n_log_count + 1
--      SET @sysdate = GETDATE()
--      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr                 
      
--    END	
		
		
		
  --- 후미 --- 
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()
    
--    DROP TABLE #PACK_MATERIAL_SIM_PLAN
--    
--    DROP TABLE #PACK_MATERIAL_SIM_CLASS
--    
--    DROP TABLE  #PACK_MATERIAL_SIM_BOM
--    
--    DROP TABLE  #PACK_MATERIAL_SIM_ITEM_M
--    
--    DROP TABLE   #PACK_MATERIAL_SIM_STOCK_CELL
--    
--     DROP TABLE #PACK_MATERIAL_SIM_STOCK 

    SET @n_log_count = @n_log_count + 1
    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_simul_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp1, null, @v_descr
  commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_simul_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END



