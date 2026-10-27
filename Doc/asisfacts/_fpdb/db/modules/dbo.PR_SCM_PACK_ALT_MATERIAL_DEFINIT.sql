
CREATE PROCEDURE [dbo].[PR_SCM_PACK_ALT_MATERIAL_DEFINIT]  
--@p_instance_id nvarchar(MAX) = '-', 
--@p_simul_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/**************************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_PACK_ALT_MATERIAL_DEFINIT												**/
/** 프로그램 명	:																								**/
/** 설 명		: PACK INSTANCE ALTERNATIVE MATERIALS DEFINIT									**/
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
/** 2021.12.10	최기주        최초 작성																		**/
/**************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;


 -- 필수 칼럼

  DECLARE   @v_instance_id    	nvarchar(30)  = 'BATCH'
  DECLARE   @v_simul_id      	nvarchar(30)  = 'PACK ALT MATERIAL BATCH' 
  DECLARE   @v_plan_type    	nvarchar(30)
  DECLARE   @v_operation_01	nvarchar(30)
  DECLARE   @key_date  			date	= convert( date, getdate() )
  DECLARE 	@plan_start_time	datetime
  DECLARE 	@plan_end_time	datetime
  DECLARE   @v_form_instance_id    	nvarchar(30)  
--  DECLARE	@v_eol_d1_rate		 numeric(10) = 0
  

  -- LOG 용 변수 설정
  DECLARE  @v_proc_name		nvarchar(100) = 'PR_SCM_PACK_ALT_MATERIAL_DEFINIT'
  DECLARE  @v_table_name		nvarchar(100)
  DECLARE  @v_message			nvarchar(250)
  DECLARE  @v_descr				nvarchar(250)
  DECLARE  @n_row_count		Integer  = 0
  DECLARE  @n_log_count		Integer  = 0
  DECLARE  @v_log_code			nvarchar(10)
  DECLARE  @sysdate				datetime2 = getdate()
  DECLARE  @v_temp1			nvarchar(1000)


--  SET @v_instance_id		= @p_instance_id
--  SET @v_simul_id      	= @p_simul_id 
  
  SET @v_temp1 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_simul_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  

  BEGIN TRY

	BEGIN  
	--------------------------------------------------
	-- 1. Pack SCP Target 확인
	--------------------------------------------------
				
    	SET @v_table_name = 'SCP_PLAN'
    	
		CREATE TABLE #SCP_PLAN
			(
			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			SHOP_GROUP_ID nvarchar(1) COLLATE Latin1_General_CI_AS NOT NULL,
			SCP_PLAN_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL
			)

		INSERT INTO #SCP_PLAN
			(
			 COMPANY_ID
			,DIVISION_ID
			,SITE_ID
			,PLANT_ID
			,SHOP_GROUP_ID
			,SCP_PLAN_ID
			)
			SELECT 	COMPANY_ID,
						DIVISION_ID, 
						SITE_ID, 
						PLANT_ID, 
						SHOP_GROUP_ID, 
						MAX(SCP_PLAN_ID) AS SCP_PLAN_ID
			FROM 	FP_WEEKLY_DEMAND_PRODUCT_H
			WHERE 	1=1
			AND 		SHOP_GROUP_ID = 'P'
			GROUP BY COMPANY_ID, 
						  DIVISION_ID, 
						  SITE_ID, 
						  PLANT_ID, 
						  SHOP_GROUP_ID
			    			
		
	    --LOG 생성
	    SET @v_message =  'PACK SCP PLAN ID : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    
	    
	END
	    
	BEGIN 
	--=========================================================
	-- 2. PACK ITEM 추출
	--=========================================================
						
    	SET @v_table_name = 'PACK_ITEM'
    	
		CREATE TABLE #PACK_ITEM
			(
			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			ITEM_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			OPERATION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NULL
			)

		INSERT INTO #PACK_ITEM
			(
			 COMPANY_ID
			,DIVISION_ID
			,SITE_ID
			,PLANT_ID
			,ITEM_ID
			,OPERATION_ID
			)
			SELECT 	A.COMPANY_ID,
						A.DIVISION_ID, 
						A.SITE_ID,
						A.PLANT_ID,
						A.ITEM_ID,
						A.OPERATION_ID
			FROM 	FP_WEEKLY_DEMAND_PRODUCT_H A,
						#SCP_PLAN B
			WHERE 	1=1
			AND 		A.COMPANY_ID 		= B.COMPANY_ID
			AND 		A.DIVISION_ID 		= B.DIVISION_ID
			AND 		A.SITE_ID 			= B.SITE_ID
			AND 		A.PLANT_ID 			= B.PLANT_ID
			AND 		A.SHOP_GROUP_ID 	= B.SHOP_GROUP_ID
			AND 		A.SCP_PLAN_ID 		= B.SCP_PLAN_ID
			AND 		OPERATION_ID 		IN ('P5500','P9500')
			GROUP BY A.COMPANY_ID,
						  A.DIVISION_ID,
						  A.SITE_ID, 
						  A.PLANT_ID,
						  A.ITEM_ID,
						  A.OPERATION_ID	
			    			
		
	    --LOG 생성
	    SET @v_message = 'PACK ITEM : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    
	
	END
	
	BEGIN 
	--=========================================================
	-- 3. MODULE ITEM 추출 
	--=========================================================
						
    	SET @v_table_name = 'MODULE_ITEM'
    	
		CREATE TABLE #MODULE_ITEM
			(
			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			MODEL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			ITEM_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			OPERATION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NULL
			)

		INSERT INTO #MODULE_ITEM
			(
			 COMPANY_ID
			,DIVISION_ID
			,SITE_ID
			,PLANT_ID
			,MODEL_ID
			,ITEM_ID
			,OPERATION_ID
			)
			SELECT 	A.COMPANY_ID,
						A.DIVISION_ID, 
						A.SITE_ID,
						A.PLANT_ID,
						A.ITEM_ID AS MODEL_ID, 
						A.ITEM_ID, 
						A.OPERATION_ID
			FROM 	FP_WEEKLY_DEMAND_PRODUCT_H A,
						#SCP_PLAN B
			WHERE 	1=1
			AND 		A.COMPANY_ID 		= B.COMPANY_ID
			AND 		A.DIVISION_ID 		= B.DIVISION_ID
			AND 		A.SITE_ID 			= B.SITE_ID
			AND 		A.PLANT_ID 			= B.PLANT_ID
			AND 		A.SHOP_GROUP_ID 	= B.SHOP_GROUP_ID
			AND 		A.SCP_PLAN_ID 		= B.SCP_PLAN_ID
			AND 		A.OPERATION_ID 		IN ('P5000','P5200')
			GROUP BY A.COMPANY_ID, 
						  A.DIVISION_ID,
						  A.SITE_ID,
						  A.PLANT_ID,
						  A.ITEM_ID,
						  A.OPERATION_ID			
			UNION ALL	
			SELECT 	A.COMPANY_ID,
						A.DIVISION_ID, 
						A.SITE_ID,
						A.PLANT_ID,
						A.PARENT_ITEM_ID AS MODEL_ID,
						A.CHILD_ITEM_ID AS ITEM_ID,
						C.FLOW_ID AS OPERATION_ID
			FROM 	SCM_BOM_M A,
						#PACK_ITEM B,
						SCM_ITEM_M C
			WHERE 	1=1
			AND 		A.COMPANY_ID 		= B.COMPANY_ID
			AND 		A.DIVISION_ID 		= B.DIVISION_ID
			AND 		A.SITE_ID 			= B.SITE_ID
			AND 		A.PLANT_ID 			= B.PLANT_ID 
			AND 		A.PARENT_ITEM_ID = B.ITEM_ID
			AND 		A.DIVISION_ID 		= C.DIVISION_ID 
			AND 		A.SITE_ID 			= C.SITE_ID 
			AND 		A.CHILD_ITEM_ID 	= C.ITEM_ID 
			AND 		A.ACTIVE_FLAG 		= 'Y'
			AND 		C.ACTIVE_FLAG 		= 'Y'
			AND 		A.EFF_END_DATE 	>= GETDATE()
			AND 		C.FLOW_ID IS NOT NULL			
			GROUP BY A.COMPANY_ID,
						  A.DIVISION_ID, 
						  A.SITE_ID,
						  A.PLANT_ID,
						  A.PARENT_ITEM_ID,
						  A.CHILD_ITEM_ID,
						  C.FLOW_ID
			    			
		
	    --LOG 생성
	    SET @v_message = 'MODULE ITEM : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    
	
	END
	
	BEGIN 
	--=========================================================
	-- 3. ALT MATERIAL 확인
	--=========================================================
						
    	SET @v_table_name = 'ALT_MATERIAL_ITEM'
    	
		CREATE TABLE #ALT_MATERIAL_ITEM
			(
			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			ITEM_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			MATERIAL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			ALT_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			RNK numeric(2,0) NULL,
			EFF_START_DATE datetime NULL,
			EFF_END_DATE datetime NULL
			)

		INSERT INTO #ALT_MATERIAL_ITEM
			(
			 COMPANY_ID,
			 DIVISION_ID,
			 SITE_ID,
			 PLANT_ID,
			 ITEM_ID,
			 MATERIAL_ID,
			 ALT_ID, 
			 RNK,
			 EFF_START_DATE,
			 EFF_END_DATE
			)
			SELECT 	DISTINCT 
						A.COMPANY_ID,
						A.DIVISION_ID,
						A.SITE_ID,
						A.PLANT_ID,
						B.ITEM_ID,
						A.CHILD_ITEM_ID AS MATERIAL_ID,
						'ALT_' + B.ITEM_ID + '_' + A.ALT_ID AS ALT_ID, 
						RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,B.ITEM_ID, A.ALT_ID, A.EFF_START_DATE, A.EFF_END_DATE
										  ORDER BY 	A.CHILD_ITEM_ID) AS RNK,
						A.EFF_START_DATE,
						A.EFF_END_DATE
			FROM 	SCM_BOM_M A,
						#PACK_ITEM B
			WHERE 	1=1
			AND 		A.COMPANY_ID = B.COMPANY_ID
			AND 		A.DIVISION_ID = B.DIVISION_ID
			AND 		A.SITE_ID = B.SITE_ID
			AND 		A.PLANT_ID = B.PLANT_ID 
			AND 		A.PARENT_ITEM_ID = B.ITEM_ID
			AND 		A.EFF_END_DATE >= GETDATE()
			AND 		A.ACTIVE_FLAG = 'Y'
			AND 		A.ALT_ID IS NOT NULL
			AND 		NOT EXISTS (SELECT 1	
										  FROM 	#MODULE_ITEM X
										  WHERE 1=1
										  AND 	A.CHILD_ITEM_ID = X.ITEM_ID
										  )														  
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,B.ITEM_ID, A.ALT_ID, A.EFF_START_DATE, A.EFF_END_DATE, A.CHILD_ITEM_ID 
			UNION ALL			
			SELECT 	DISTINCT
					  	A.COMPANY_ID,
						A.DIVISION_ID,
						A.SITE_ID,
						A.PLANT_ID,
						B.ITEM_ID, 
						A.CHILD_ITEM_ID AS MATERIAL_ID,
						'ALT_' + B.ITEM_ID + '_' +A.ALT_ID AS ALT_ID, 
						RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,B.ITEM_ID, A.ALT_ID, A.EFF_START_DATE, A.EFF_END_DATE
										  ORDER BY 	A.CHILD_ITEM_ID) AS RNK,
						A.EFF_START_DATE,
						A.EFF_END_DATE
			FROM 	SCM_BOM_M A,
						#MODULE_ITEM B,
						SCM_ITEM_M C
			WHERE 	1=1
			AND 		A.COMPANY_ID = B.COMPANY_ID
			AND 		A.DIVISION_ID = B.DIVISION_ID
			AND 		A.SITE_ID = B.SITE_ID
			AND 		A.PLANT_ID = B.PLANT_ID 
			AND 		A.PARENT_ITEM_ID = B.ITEM_ID
			AND 		A.DIVISION_ID = C.DIVISION_ID 
			AND 		A.SITE_ID = C.SITE_ID 
			AND 		A.CHILD_ITEM_ID = C.ITEM_ID 
			AND 		A.ACTIVE_FLAG = 'Y'
			AND 		C.ACTIVE_FLAG = 'Y'
			AND 		A.EFF_END_DATE >= GETDATE()
			AND 		(C.FLOW_ID IS NULL OR C.FLOW_ID IN ('A3000','A9000'))
			AND 		A.ALT_ID IS NOT NULL	
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,B.ITEM_ID, A.ALT_ID, A.EFF_START_DATE, A.EFF_END_DATE, A.CHILD_ITEM_ID
			    			
		
	    --LOG 생성
	    SET @v_message = 'ALT MATERIAL ITEM : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    
	
	END	
	
	BEGIN 
	--=========================================================
	-- 4. NEW ALT ID 채번
	--=========================================================
						
    	SET @v_table_name = 'NEW_ALT_ID'
    	
		CREATE TABLE #NEW_ALT_ID
			(
			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			ALT_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			NEW_ALT_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL
			)

		INSERT INTO #NEW_ALT_ID
			(
			 COMPANY_ID,
			 DIVISION_ID,
			 SITE_ID,
			 PLANT_ID,
			 ALT_ID, 
 			 NEW_ALT_ID
			)
			SELECT 	COMPANY_ID,
						DIVISION_ID,
						SITE_ID,
						PLANT_ID,
						ALT_ID,
						'ALT_' + MATERIAL_ID AS NEW_ALT_ID
			FROM 	#ALT_MATERIAL_ITEM
			WHERE	1=1
			AND 		RNK = 1
			GROUP BY COMPANY_ID,
						  DIVISION_ID,
						  SITE_ID,
						  PLANT_ID,
						  ALT_ID,
						  MATERIAL_ID
			    			
		
	    --LOG 생성
	    SET @v_message = 'ALT MATERIAL ID : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    
	
	END		
	
	BEGIN 
	--=========================================================
	-- 5. MATERIAL 별 ALT ID 정의
	--=========================================================
						
    	SET @v_table_name = 'ALT_MATERIAL_DEFINIT'
    	
		CREATE TABLE #ALT_MATERIAL_DEFINIT
			(
			COMPANY_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			DIVISION_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			SITE_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			PLANT_ID nvarchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
			NEW_ALT_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			MATERIAL_ID nvarchar(150) COLLATE Latin1_General_CI_AS NULL,
			RNK numeric(2,0) NULL,
			)

		INSERT INTO #ALT_MATERIAL_DEFINIT
			(
			 COMPANY_ID,
			 DIVISION_ID,
			 SITE_ID,
			 PLANT_ID,
			 NEW_ALT_ID, 
 			 MATERIAL_ID,
 			 RNK
			)
			SELECT 	A.COMPANY_ID,
						A.DIVISION_ID,
						A.SITE_ID,
						A.PLANT_ID,
						B.NEW_ALT_ID, 
						A.MATERIAL_ID,
						RANK() OVER (PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,B.NEW_ALT_ID ORDER BY A.MATERIAL_ID) AS RNK	
			FROM 	#ALT_MATERIAL_ITEM A,
						#NEW_ALT_ID B
			WHERE	1=1
			AND 		A.ALT_ID = B.ALT_ID
			GROUP BY A.COMPANY_ID,
						A.DIVISION_ID,
						A.SITE_ID,
						A.PLANT_ID,
						B.NEW_ALT_ID, 
						A.MATERIAL_ID

			    			
		
	    --LOG 생성
	    SET @v_message = 'ALT MATERIAL ID : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    
	
	END			
	
	BEGIN
		
		SET @v_table_name = 'FP_PACK_ALT_MATERIAL_ITEM'
		
		DELETE 	FP_PACK_ALT_MATERIAL_ITEM
		
		INSERT INTO FP_PACK_ALT_MATERIAL_ITEM
		SELECT 	COMPANY_ID,
					DIVISION_ID,
					SITE_ID,
					PLANT_ID,
					ITEM_ID,
					MATERIAL_ID,
					ALT_ID,
					RNK,
					EFF_START_DATE,
					EFF_END_DATE,
					@v_proc_name AS UPDATE_ID,
					GETDATE() AS UPDATE_TIME
		FROM 	#ALT_MATERIAL_ITEM
	
	    --LOG 생성
	    SET @v_message = 'FP_PACK_ALT_MATERIAL_ITEM : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    	
	    
		SET @v_table_name = 'FP_PACK_NEW_ALT_ID'
		
		DELETE 	FP_PACK_NEW_ALT_ID
		
		INSERT INTO FP_PACK_NEW_ALT_ID
		SELECT 	COMPANY_ID,
					DIVISION_ID,
					SITE_ID,
					PLANT_ID,
					ALT_ID,
					NEW_ALT_ID,
					@v_proc_name AS UPDATE_ID,
					GETDATE() AS UPDATE_TIME
		FROM 	#NEW_ALT_ID
	
	    --LOG 생성
	    SET @v_message = 'FP_PACK_NEW_ALT_ID : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    	
	    
		SET @v_table_name = 'FP_PACK_ALT_MATERIAL_DEFINIT'
		
		DELETE 	FP_PACK_ALT_MATERIAL_DEFINIT
		
		INSERT INTO FP_PACK_ALT_MATERIAL_DEFINIT
		SELECT 	COMPANY_ID,
					DIVISION_ID,
					SITE_ID,
					PLANT_ID,
					NEW_ALT_ID,
					MATERIAL_ID,
					RNK,
					@v_proc_name AS UPDATE_ID,
					GETDATE() AS UPDATE_TIME
		FROM 	#ALT_MATERIAL_DEFINIT	
	
	    --LOG 생성
	    SET @v_message = 'FP_PACK_ALT_MATERIAL_DEFINIT : '+ convert(nvarchar, @@ROWCOUNT)
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    		    
	
	END
	
    -- TEMP 테이블 DROP
    BEGIN        
	    
      DROP TABLE #SCP_PLAN
      
      --LOG 생성
      SET @v_table_name = 'SCP_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr  
      
      DROP TABLE  #PACK_ITEM
      
      --LOG 생성
      SET @v_table_name = 'PACK_ITEM'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr        
      
      DROP TABLE  #MODULE_ITEM
      
      --LOG 생성
      SET @v_table_name = 'MODULE_ITEM'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr       
      
      DROP TABLE  #ALT_MATERIAL_ITEM
      
      --LOG 생성
      SET @v_table_name = 'ALT_MATERIAL_ITEM'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr               
      
      DROP TABLE  #NEW_ALT_ID
      
      --LOG 생성
      SET @v_table_name = 'NEW_ALT_ID'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr          
      
      DROP TABLE  #ALT_MATERIAL_DEFINIT
      
      --LOG 생성
      SET @v_table_name = 'ALT_MATERIAL_DEFINIT'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_simul_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr                
                 
      
    END	
		
		
		
  --- 후미 --- 
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()
    
    DROP TABLE #SCP_PLAN
    
    DROP TABLE #PACK_ITEM
    
    DROP TABLE  #MODULE_ITEM
    
    DROP TABLE  #ALT_MATERIAL_ITEM

    SET @n_log_count = @n_log_count + 1
    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_simul_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp1, null, @v_descr
  commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_simul_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

END



