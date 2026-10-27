--USE [LGCE_FP_TR]

CREATE PROCEDURE [dbo].[PR_SCM_PACK_FORM_PLAN]  
@p_master_id nvarchar(MAX) = '-', 
@p_plan_id nvarchar(MAX) = '-',
@p_fix_option nvarchar(MAX) = 'N'
WITH EXEC AS CALLER
AS

/************************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_PACK_FORM_PLAN												**/
/** 프로그램 명	:																**/
/** 설 명		: PAKC FORMATION 계획 수립 및 DATA 생성									**/
/** Version		: 1.0.0														**/
/**																			**/
/** Argument																	**/
/**																			**/
/**  [검색 조건]																	**/
/**																			**/
/** [Biz Logic]																**/
/**																			**/
/**--------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                 	                    **/
/**============================================================================================**/
/** 2022.08.03    최기주        최초 작성												**/
/** 2022.09.19    최기주        최초 작성												**/
/** 2022.09.28    최기주        SSP 실시간 출하계획 반영									**/
/** 2022.10.13    이진석        과거 계획/실적 전달 1일부터 생성								**/
/** 2022.10.13    최기주        SHIPPING RESULT 추가, oWMS 재고 추가							**/
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
/*************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
  SET XACT_ABORT ON;


 -- 필수 칼럼

DECLARE   @V_MASTER_ID    nvarchar(30)  
DECLARE   @V_PLAN_ID      nvarchar(30)
DECLARE   @V_CONFIRM_PLAN_ID      nvarchar(30)
DECLARE   @V_SSP_PLAN_ID      nvarchar(30)   
DECLARE   @v_operation_01   nvarchar(30)
DECLARE   @KEY_DATE  DATE  
DECLARE   @CUTOFF_DATE  DATE 
DECLARE 	@n_target_end_day NUMERIC
DECLARE 	@n_plan_end_day NUMERIC
DECLARE   @V_fix_option   nvarchar(10)

	SET   @KEY_DATE     = CONVERT( DATE, GETDATE() ) 
	SET   @CUTOFF_DATE  = CONVERT( DATE, GETDATE() ) 

  -- LOG 용 변수 설정
  DECLARE  @v_proc_name      nvarchar(100) = 'PR_SCM_PACK_FORM_PLAN'
  DECLARE  @v_table_name     nvarchar(100)
  DECLARE  @v_message        nvarchar(250)
  DECLARE  @v_descr          nvarchar(250)
  DECLARE  @n_row_count      Integer  = 0
  DECLARE  @n_log_count      Integer  = 0
  DECLARE  @v_log_code       nvarchar(10)
  DECLARE  @sysdate          DATETIME2 = GETDATE()
  --DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)


  SET @V_MASTER_ID    = @p_master_id
  SET @V_PLAN_ID      = @p_plan_id
  SET @V_fix_option   = @p_fix_option 
  
  --SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  
  BEGIN

      --LOG 생성
      SET @v_table_name = 'SCM_FP_PLAN_H'
      SELECT  @KEY_DATE = CONVERT(DATE, PLAN_START_TIME)
            , @CUTOFF_DATE  = CONVERT(DATE, PLAN_START_TIME)
      FROM   (
              SELECT PLAN_START_TIME
              FROM   SCM_FP_PLAN_H
              WHERE  INSTANCE_ID = @V_MASTER_ID
              AND    PLAN_ID     = @V_PLAN_ID
             ) A   
             
      --LOG 생성
      SET @v_message = 'KEY_DATE : ' + CONVERT(nvarchar, @KEY_DATE, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, NULL
      
	 SELECT 	@V_CONFIRM_PLAN_ID = A.PLAN_ID 
	 FROM 	(
			SELECT 	RANK() OVER (PARTITION BY INSTANCE_ID ORDER BY CONFIRM_TIME DESC) AS RNK, A.*
			FROM 	SCM_FP_PLAN_H A
			WHERE 	1=1
			AND 		INSTANCE_ID = @V_MASTER_ID
			AND 		CONFIRM_FLAG = 'Y'
			) A
	 WHERE 	1=1
	 AND 		A.RNK = 1   
	 
      --LOG 생성
      SET @v_message = 'LAST CONFIRM PLAN ID : ' + @V_CONFIRM_PLAN_ID
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, NULL	 
      
      				
	SELECT	@n_target_end_day = CONVERT(NUMERIC, ATTRIBUTE13) * 7, 
			@n_plan_end_day = CONVERT(NUMERIC, ATTRIBUTE15) * 7 
	FROM 	SCM_SYS_LOOKUP_VALUE
	WHERE 	1=1
	AND 		LOOKUP_TYPE_CODE = 'INSTANCE_ID'
	AND 		SEGMENT1 = 'PL_P_FORM'
	
      --LOG 생성
	SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
     SET @v_message = 'TARGET_END_DAY : ' + CONVERT(nvarchar, @n_target_end_day) + ', N_PLAN_END_DAY : ' + CONVERT(nvarchar, @n_plan_end_day)
     SET @n_log_count = @n_log_count + 1
     SET @sysdate = GETDATE()
     EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, NULL
     
     
     SELECT 	@V_SSP_PLAN_ID = MAX(SCP_PLAN_ID)
	FROM 	FP_WEEKLY_DEMAND_SHIPMENT_H A,
			FP_INSTANCE_INFO_V B
	WHERE 	1=1
	AND 		B.INSTANCE_ID = @V_MASTER_ID
	AND 		A.COMPANY_ID = B.COMPANY_ID 
	AND 		A.DIVISION_ID = B.DIVISION_ID 
	AND 		A.SITE_ID = B.SITE_ID 
	AND 		A.PLANT_ID = B.PLANT_ID
	AND 		A.SHOP_GROUP_ID = 'P'
--	AND 		LEFT(A.SCP_PLAN_ID,8) <= @KEY_DATE 
      
      --LOG 생성
	SET @v_table_name = 'FP_WEEKLY_DEMAND_SHIPMENT_H'
     SET @v_message = 'SSP PLAN ID : ' + @V_SSP_PLAN_ID
     SET @n_log_count = @n_log_count + 1
     SET @sysdate = GETDATE()
     EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, NULL	
      
  END  

  BEGIN TRY

    -- BUFFER 테이블 삭제
  	/*
    	BEGIN        
		 
	 
      DROP TABLE #P_FORM_ITEM
      
      --LOG 생성
      SET @v_table_name = 'P_FORM_ITEM'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr
      
      DROP TABLE #CMA_ASSY_PLAN
      
      --LOG 생성
      SET @v_table_name = 'CMA_ASSY_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr     
      
      DROP TABLE #SSP_TARGET
      
      --LOG 생성
      SET @v_table_name = 'SSP_TARGET'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr        
      
      DROP TABLE #BOH_STOCK
      
      --LOG 생성
      SET @v_table_name = 'BOH_STOCK'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr          
      
    
    	END
    	*/

	BEGIN  
	--------------------------------------------------
	-- 1. 대상 Item 생성 
	--	P5200 공정을 가지고 있는 MEB 제품
	--	대상 선택이 추가적인 제약이 필요한 경우 LOOKUP 등에 사전 정의 필요    	 
	--------------------------------------------------
    	  SET @v_table_name = 'P_FORM_ITEM'

    	  /*
		SELECT 	DISTINCT F.COMPANY_ID 
				, F.DIVISION_ID 
				, F.SITE_ID 
				, F.PLANT_ID 
				, B.PARENT_ITEM_ID AS MODEL
				, A.ITEM_ID AS MODULE
				, C.CHILD_ITEM_ID AS CELL
				, A.ITEM_NAME
				, A.NICK_NAME
				, A.ITEM_CLASS
				, A.ITEM_CLASS_NAME
				, A.SPEC 
				, A.FLOW_ID 
				, A.FP_EXTRA_SPEC
				, A.PACK_PRODUCT_GROUP_CODE
		INTO 	#P_FORM_ITEM
		FROM 	SCM_ITEM_M A,
				SCM_BOM_M B,
				SCM_BOM_M C,
				SCM_ITEM_M D,
				SCM_ITEM_CLASS_M E,
				FP_INSTANCE_INFO_V F		
		WHERE 	1=1
		AND 		A.ACTIVE_FLAG = 'Y'
		AND 		A.FLOW_ID = 'P5200'
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.ITEM_ID = B.CHILD_ITEM_ID 
		AND 		B.EFF_END_DATE >= @KEY_DATE
		AND 		B.PARENT_ITEM_ID LIKE '%MEB%'
		AND 		B.ACTIVE_FLAG = 'Y'
		AND 		A.COMPANY_ID = C.COMPANY_ID 
		AND 		A.DIVISION_ID = C.DIVISION_ID 
		AND 		A.SITE_ID = C.SITE_ID 
		AND 		A.ITEM_ID = C.PARENT_ITEM_ID 
		AND 		C.ACTIVE_FLAG = 'Y'
		AND 		C.EFF_END_DATE >= @KEY_DATE
		AND 		C.COMPANY_ID = D.COMPANY_ID 
		AND 		C.DIVISION_ID = D.DIVISION_ID 
		AND 		C.SITE_ID = D.SITE_ID 
		AND 		C.CHILD_ITEM_ID = D.ITEM_ID 
		AND 		D.ITEM_CLASS = E.CLASS_ID		
		AND 		E.CLASS_ID = 'EM0201'
		AND 		F.INSTANCE_ID = @V_MASTER_ID
		AND 		A.COMPANY_ID = F.COMPANY_ID 
		AND 		A.DIVISION_ID = F.DIVISION_ID 
		AND 		A.SITE_ID = F.SITE_ID 	
		; 
	  */
    	  	SELECT 	DISTINCT F.COMPANY_ID 
					, F.DIVISION_ID 
					, F.SITE_ID 
					, F.PLANT_ID 
					, A.SEGMENT2 AS MODEL
					, A.SEGMENT3 AS MODULE
					, A.SEGMENT4 AS CELL
					, B.ITEM_NAME
					, B.NICK_NAME
					, B.ITEM_CLASS
					, B.ITEM_CLASS_NAME
					, B.SPEC 
					, B.FLOW_ID 
					, B.FP_EXTRA_SPEC
					, B.PACK_PRODUCT_GROUP_CODE
		INTO 	#P_FORM_ITEM
		FROM 	SCM_SYS_LOOKUP_VALUE A,
				SCM_ITEM_M B,
				FP_INSTANCE_INFO_V F
		WHERE 	1=1
		AND 		A.LOOKUP_TYPE_CODE = 'ILT_ITEM_LIST'		
		AND 		A.SEGMENT1 = @v_master_id
		AND 		A.SEGMENT1 = F.INSTANCE_ID 
		AND 		B.COMPANY_ID = F.COMPANY_ID 
		AND 		B.DIVISION_ID = F.DIVISION_ID 
		AND 		B.SITE_ID = F.SITE_ID 	
		AND 		A.SEGMENT2 = B.ITEM_ID 
		;    	  
		
	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = 'PACK FORM ITEM LIST' 
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	
	END -- 1 END 

	BEGIN 
	--=========================================================
	-- 2. CMA ASSY PLAN
	-- 	대상 제품의 P5200 공정 계획을 가져온다.  
	--=========================================================
	
		SET @v_table_name = 'CMA_ASSY_PLAN'


		SELECT 	  A.TOP_ITEM_ID AS MODEL
				, A.ITEM_ID AS MODULE
				, B.CELL
				, A.PLAN_DATE 
				, A.OPERATION_ID 
				, SUM(A.PLAN_QTY) AS PLAN_QTY  
		INTO 	#CMA_ASSY_PLAN
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.PLAN_DATE >= @KEY_DATE
		AND 		A.PLAN_DATE <= DATEADD(DAY, @n_target_end_day, @KEY_DATE)
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID
		AND 		A.ITEM_ID = B.MODULE 		
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		A.PLAN_QTY > 0
		GROUP BY  A.TOP_ITEM_ID 
				, A.ITEM_ID
				, B.CELL
				, A.PLAN_DATE				
				, A.OPERATION_ID 
			
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    
	END   -- 2 END 

	BEGIN  -- 3 
		--=========================================================
		-- 3. SSP TARGET
		-- 가장 최신 SSP 출하계획을 가져온다
		--=========================================================
		
		SET @v_table_name = 'SSP_TARGET'

		/*
		SELECT 	  A.ITEM_ID AS MODEL
				, B.MODULE
				, B.CELL
				, A.SHIP_DATE
				, SUM(A.SHIP_QTY) AS SHIP_QTY
		INTO 	#SSP_TARGET
		FROM 	FP_WEEKLY_DEMAND_SHIPMENT_H A,
				#P_FORM_ITEM B
		WHERE 	1=1
--		AND 		A.SITE_ID = 'A004'
		AND 		A.SCP_PLAN_ID = @v_ssp_plan_id
		AND 		A.ITEM_ID = B.MODEL
		AND 		A.SHIP_DATE <= DATEADD(DAY, @n_target_end_day, @KEY_DATE)
		GROUP BY    A.ITEM_ID
				, B.MODULE
				, B.CELL				
				, A.SHIP_DATE						
		; 
		*/
		SELECT 	  A.ITEM_ID AS MODEL
				, B.MODULE
				, B.CELL
				, A.SHIP_DATE
				, SUM(A.SHIP_QTY) AS SHIP_QTY
		INTO 	#SSP_TARGET
		FROM 	IF_SSP_WEEKLY_DEMAND_SHIPMENT_V A		,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.PLANT_ID = B.PLANT_ID 
		AND 		A.ITEM_ID = B.MODEL
		AND 		A.SHIP_DATE <= DATEADD(DAY, @n_target_end_day, @KEY_DATE)
		AND 		A.SHIP_DATE >= DATEADD(DAY, -30, @KEY_DATE)
		GROUP BY    A.ITEM_ID
				, B.MODULE
				, B.CELL				
				, A.SHIP_DATE		
	
			--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr

	END  -- 3 END 

	BEGIN  --4
		--=========================================================
		-- 4. STOCK 정보 1 
		-- 
		--=========================================================

		SET      @v_table_name = 'BOH_STOCK'
		
		/*
		SELECT 	A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, B.MODEL
				, B.MODULE
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5310' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_07'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END AS CATEGORY	
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
		INTO 	#BOH_STOCK
		FROM 	SCM_STOCK_H_V A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.CUTOFF_DATE = @KEY_DATE
		AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.STOCK_TYPE = 'WIP'
		AND 		A.OPERATION_ID NOT IN ('PR000','PS000')	
		GROUP BY A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, B.MODEL
				, B.MODULE
				, B.CELL
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5310' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_07'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END
		; 
		*/
		/*
		SELECT 	A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, B.MODEL
				, B.MODULE
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				  	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END AS CATEGORY	
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
		INTO 	#BOH_STOCK
		FROM 	SCM_STOCK_H_V A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.CUTOFF_DATE = @KEY_DATE
		AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.STOCK_TYPE = 'WIP'
		AND 		A.OPERATION_ID NOT IN ('PR000','PS000')	
		GROUP BY A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, B.MODEL
				, B.MODULE
				, B.CELL
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END
		*/
		/*
		SELECT 	A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, B.MODEL
				, B.MODULE
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) THEN 'CATEGORY_07'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				  	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END AS CATEGORY	
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
		INTO 	#BOH_STOCK
		FROM 	SCM_STOCK_H_V A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.CUTOFF_DATE = @KEY_DATE
		AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.STOCK_TYPE = 'WIP'
		AND 		A.OPERATION_ID NOT IN ('PR000','PS000')	
		GROUP BY A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, B.MODEL
				, B.MODULE
				, B.CELL
--				, A.OPERATION_ID
				,  CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) THEN 'CATEGORY_07'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				  	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END
		*/
		SELECT 	A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, A.MODEL
				, A.MODULE
				, A.CATEGORY	
				, SUM(A.GOOD_QTY) AS GOOD_QTY
				, SUM(A.LONG_TERM_QTY) AS LONG_TERM_QTY
				, SUM(A.HOLD_QTY) AS HOLD_QTY
		INTO 	#BOH_STOCK
		FROM 	(
				SELECT 	A.COMPANY_ID 
						, A.DIVISION_ID 
						, A.SITE_ID 
						, A.FACTORY_ID
						, B.MODEL
						, B.MODULE
						, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE /* AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) */ THEN 'CATEGORY_07'
						   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
						  	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
							  ELSE 'NULL' END AS CATEGORY	
						, SUM(CASE 
								 WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
--				INTO 	#BOH_STOCK
				FROM 	SCM_STOCK_H_V A,
						#P_FORM_ITEM B
				WHERE 	1=1
				AND 		A.CUTOFF_DATE = @KEY_DATE
				AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
				AND 		A.COMPANY_ID = B.COMPANY_ID 
				AND 		A.DIVISION_ID = B.DIVISION_ID 
				AND 		A.SITE_ID = B.SITE_ID 
				AND 		A.STOCK_TYPE = 'WIP'
				AND 		A.OPERATION_ID NOT IN ('PR000','PS000')	
				GROUP BY A.COMPANY_ID 
						, A.DIVISION_ID 
						, A.SITE_ID 
						, A.FACTORY_ID
						, B.MODEL
						, B.MODULE
						, B.CELL
		--				, A.OPERATION_ID
						,  CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE /* AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) */ THEN 'CATEGORY_07'
						   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
						  	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
							  ELSE 'NULL' END					  
				UNION ALL		
				SELECT 	A.COMPANY_ID 
						, A.DIVISION_ID 
						, A.SITE_ID 
						, A.FACTORY_ID
						, B.MODEL
						, B.MODULE
						, 'CATEGORY_02' AS CATEGORY	
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
		--		INTO 	#BOH_STOCK
				FROM 	SCM_STOCK_H_V A,
						#P_FORM_ITEM B
				WHERE 	1=1
				AND 		A.CUTOFF_DATE = @KEY_DATE
				AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
				AND 		A.COMPANY_ID = B.COMPANY_ID 
				AND 		A.DIVISION_ID = B.DIVISION_ID 
				AND 		A.SITE_ID = B.SITE_ID 
				AND 		A.STOCK_TYPE = 'DW'
				AND 		A.STORAGE_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_PACK_FORM_PLAN' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
				GROUP BY A.COMPANY_ID 
						, A.DIVISION_ID 
						, A.SITE_ID 
						, A.FACTORY_ID
						, B.MODEL
						, B.MODULE
						, B.CELL
				) A
		WHERE 	1=1
		GROUP  BY A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.FACTORY_ID
				, A.MODEL
				, A.MODULE
				, A.CATEGORY
		; 

	    --LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;
		
		END    --4 END 




		BEGIN --9
		--=========================================================
		-- 5. UI TABLE에 밀어넣기.
		--=========================================================

		SET      @v_table_name = 'FP_AMEND_PLAN_P_FORM_R'

		---- 11- SSP TARGET ---- 
		
	   	DELETE FP_AMEND_PLAN_P_FORM_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	   	AND 	FP_PLAN_ID = @V_PLAN_ID
	   	AND 	CATEGORY_ID = 'CATEGORY_01'
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = '11 SSP TARGET'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		
		
		INSERT INTO FP_AMEND_PLAN_P_FORM_R
		SELECT 	  @V_MASTER_ID AS INSTANCE_ID
				, @V_PLAN_ID AS FP_PLAN_ID
				, B.COMPANY_ID
				, B.DIVISION_ID
				, B.SITE_ID
				, B.PLANT_ID
				, B.MODEL AS MODEL_ITEM_ID
				, A.MODULE AS MODULE_ITEM_ID
				, B.CELL AS CELL_ITEM_ID
				, 'CATEGORY_01' AS CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, A.SHIP_DATE AS PLAN_DATE
				, A.SHIP_QTY AS QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME
		FROM 	#SSP_TARGET A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.MODULE = B.MODULE
		;

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '11 SSP TARGET'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	
	   
		---- 12 SHIPPING RESULT ---- 
		
	   	DELETE FP_AMEND_PLAN_P_FORM_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	   	AND 	FP_PLAN_ID = @V_PLAN_ID
	   	AND 	CATEGORY_ID = 'CATEGORY_15'
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = '12 SHIPPING RESULT'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		
		
		INSERT INTO FP_AMEND_PLAN_P_FORM_R
		SELECT 	  @V_MASTER_ID AS INSTANCE_ID
				, @V_PLAN_ID AS FP_PLAN_ID
				, B.COMPANY_ID
				, B.DIVISION_ID
				, B.SITE_ID
				, B.PLANT_ID
				, C.MODEL AS MODEL_ITEM_ID
				, C.MODULE AS MODULE_ITEM_ID
				, C.CELL AS CELL_ITEM_ID
				, 'CATEGORY_15' AS CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, A.YYYYMMDD AS PLAN_DATE
				, SUM(A.QTY) AS QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME	
		FROM 	IF_SSP_ERP_EXFACTORY_RESULT_V A,
				FP_INSTANCE_INFO_V B,
				#P_FORM_ITEM C
		WHERE 	1=1
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.PLANT_ID = B.PLANT_ID
		AND 		A.ITEM_ID = C.MODEL 
		AND 		YYYYMMDD >= DATEADD(MONTH, -1, SUBSTRING(CONVERT(VARCHAR,@KEY_DATE,112),1,6)+'01')
		AND         B.INSTANCE_ID = @V_MASTER_ID -- 추가
		GROUP BY    B.COMPANY_ID
				, B.DIVISION_ID
				, B.SITE_ID
				, B.PLANT_ID
				, C.MODEL
				, C.MODULE
				, C.CELL
				, A.YYYYMMDD
		;

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '12 SHIPPING RESULT'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	
	   

		 ---- 21 CMA Assy plan ----
	   
	   	DELETE FP_AMEND_PLAN_P_FORM_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	   	AND 	FP_PLAN_ID = @V_PLAN_ID
	   	AND 	CATEGORY_ID = 'CATEGORY_14'
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = '21 CMA Assy plan'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		   

		INSERT INTO FP_AMEND_PLAN_P_FORM_R
		SELECT 	  @V_MASTER_ID AS INSTANCE_ID
				, @V_PLAN_ID AS FP_PLAN_ID
				, B.COMPANY_ID
				, B.DIVISION_ID
				, B.SITE_ID
				, B.PLANT_ID
				, B.MODEL AS MODEL_ITEM_ID
				, A.MODULE AS MODULE_ITEM_ID
				, B.CELL AS CELL_ITEM_ID
				, 'CATEGORY_14' AS CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, A.PLAN_DATE
				, A.PLAN_QTY AS QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME
		FROM 	#CMA_ASSY_PLAN A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.MODULE = B.MODULE
		;
	
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '21 CMA Assy plan'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	

		---- 31 STOCK BOH ----
	   
	   	DELETE FP_AMEND_PLAN_P_FORM_BOH_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	   	AND 	FP_PLAN_ID = @V_PLAN_ID
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = '31 STOCK BOH'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		   
		
	   	/*
		INSERT INTO FP_AMEND_PLAN_P_FORM_BOH_R
		SELECT	@V_MASTER_ID AS INSTANCE_ID
				, @V_PLAN_ID AS PLAN_ID
				, B.COMPANY_ID 
				, B.DIVISION_ID 
				, B.SITE_ID 
				, B.PLANT_ID
				, B.MODEL AS MODEL_ITEM_ID
				, B.MODULE AS MODULE_ITEM_ID
				, B.CELL AS CELL_ITEM_ID
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END AS CATEGORY_ID	
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE					  
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
				, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= @KEY_DATE THEN @KEY_DATE ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 6, @KEY_DATE)) END AS OCV2_DATE
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME		
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' AND QMS_HOLD_YN = 'Y' THEN QTY ELSE 0 END) AS QMS_HOLD_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' AND QMS_HOLD_YN = 'N' AND MES_HOLD_YN = 'Y' THEN QTY ELSE 0 END) AS MES_HOLD_QTY
		FROM 	SCM_STOCK_H_V A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.CUTOFF_DATE = @KEY_DATE
		AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.STOCK_TYPE = 'WIP'
		AND 		A.OPERATION_ID NOT IN ('PR000','PS000')	
		GROUP BY B.COMPANY_ID 
				, B.DIVISION_ID 
				, B.SITE_ID 
				, B.PLANT_ID
				, B.MODEL
				, B.MODULE
				, B.CELL
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END
				, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= @KEY_DATE THEN @KEY_DATE ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 6, @KEY_DATE)) END
		*/
	   	INSERT INTO FP_AMEND_PLAN_P_FORM_BOH_R
	   	/*
		SELECT	@V_MASTER_ID AS INSTANCE_ID
				, @V_PLAN_ID AS PLAN_ID
				, B.COMPANY_ID 
				, B.DIVISION_ID 
				, B.SITE_ID 
				, B.PLANT_ID
				, B.MODEL AS MODEL_ITEM_ID
				, B.MODULE AS MODULE_ITEM_ID
				, B.CELL AS CELL_ITEM_ID
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) THEN 'CATEGORY_07'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END AS CATEGORY_ID	
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE					  
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'N' AND LONG_TERM_FLAG = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
				, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= @KEY_DATE THEN @KEY_DATE ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 6, @KEY_DATE)) END AS OCV2_DATE
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME		
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' AND QMS_HOLD_YN = 'Y' THEN QTY ELSE 0 END) AS QMS_HOLD_QTY
				, SUM(CASE WHEN WIPHOLD_YN = 'Y' AND QMS_HOLD_YN = 'N' AND MES_HOLD_YN = 'Y' THEN QTY ELSE 0 END) AS MES_HOLD_QTY
		FROM 	SCM_STOCK_H_V A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.CUTOFF_DATE = @KEY_DATE
		AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.STOCK_TYPE = 'WIP'
		AND 		A.OPERATION_ID NOT IN ('PR000','PS000')	
		GROUP BY B.COMPANY_ID 
				, B.DIVISION_ID 
				, B.SITE_ID 
				, B.PLANT_ID
				, B.MODEL
				, B.MODULE
				, B.CELL
				, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
				   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
				   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) THEN 'CATEGORY_07'
				   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
				   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
					  ELSE 'NULL' END
				, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= @KEY_DATE THEN @KEY_DATE ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 6, @KEY_DATE)) END
		*/
		SELECT 	@V_MASTER_ID AS INSTANCE_ID
				, @V_PLAN_ID AS PLAN_ID
				, A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.PLANT_ID
				, A.MODEL_ITEM_ID
				, A.MODULE_ITEM_ID
				, A.CELL_ITEM_ID
				, A.CATEGORY_ID	
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE					  
				, SUM(A.GOOD_QTY) AS GOOD_QTY
				, SUM(A.LONG_TERM_QTY) AS LONG_TERM_QTY
				, SUM(A.HOLD_QTY) AS HOLD_QTY
				, A.OCV2_DATE
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME		
				, SUM(A.QMS_HOLD_QTY) AS QMS_HOLD_QTY
				, SUM(A.MES_HOLD_QTY) AS MES_HOLD_QTY
		FROM 	(
				SELECT	B.COMPANY_ID 
						, B.DIVISION_ID 
						, B.SITE_ID 
						, B.PLANT_ID
						, B.MODEL AS MODEL_ITEM_ID
						, B.MODULE AS MODULE_ITEM_ID
						, B.CELL AS CELL_ITEM_ID
						, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) THEN 'CATEGORY_07'
						   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
						   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
							  ELSE 'NULL' END AS CATEGORY_ID				  
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
						, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= @KEY_DATE THEN @KEY_DATE ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 6, @KEY_DATE)) END AS OCV2_DATE	
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND ISNULL(QMS_HOLD_YN, 'N') = 'Y' THEN QTY ELSE 0 END) AS QMS_HOLD_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND ISNULL(QMS_HOLD_YN, 'N') = 'N' AND MES_HOLD_YN = 'Y' THEN QTY ELSE 0 END) AS MES_HOLD_QTY
				FROM 	SCM_STOCK_H_V A,
						#P_FORM_ITEM B
				WHERE 	1=1
				AND 		A.CUTOFF_DATE = @KEY_DATE
				AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
				AND 		A.COMPANY_ID = B.COMPANY_ID 
				AND 		A.DIVISION_ID = B.DIVISION_ID 
				AND 		A.SITE_ID = B.SITE_ID 
				AND 		A.STOCK_TYPE = 'WIP'
				AND 		A.OPERATION_ID NOT IN ('PR000','PS000')	
				GROUP BY B.COMPANY_ID 
						, B.DIVISION_ID 
						, B.SITE_ID 
						, B.PLANT_ID
						, B.MODEL
						, B.MODULE
						, B.CELL
						, CASE WHEN A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS != 'PROC' THEN 'CATEGORY_12'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE >= @KEY_DATE THEN 'CATEGORY_08'
						   	  WHEN ((A.OPERATION_ID = 'P5270' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5310') 
						   	  		OR (A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS != 'PROC')) AND SECOND_OCV_EXP_DATE < @KEY_DATE AND SECOND_OCV_EXP_DATE >= DATEADD(DAY, -2, @KEY_DATE) THEN 'CATEGORY_07'
						   	  WHEN ((A.OPERATION_ID = 'P5410' AND A.STOCK_STATUS = 'PROC') OR (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS != 'PROC')) THEN 'CATEGORY_06'
						   	  WHEN (A.OPERATION_ID = 'P5430' AND A.STOCK_STATUS = 'PROC') OR A.OPERATION_ID IN ('P5000','P5500','P5480') OR A.ITEM_ID = B.MODEL THEN 'CATEGORY_02'
							  ELSE 'NULL' END
						, CASE WHEN CONVERT(DATE, A.SECOND_OCV_EXP_DATE) <= @KEY_DATE THEN @KEY_DATE ELSE ISNULL(CONVERT(DATE, A.SECOND_OCV_EXP_DATE), DATEADD(DAY, 6, @KEY_DATE)) END	
				UNION ALL		
				SELECT	B.COMPANY_ID 
						, B.DIVISION_ID 
						, B.SITE_ID 
						, B.PLANT_ID
						, B.MODEL AS MODEL_ITEM_ID
						, B.MODULE AS MODULE_ITEM_ID
						, B.CELL AS CELL_ITEM_ID
						, 'CATEGORY_02' AS CATEGORY_ID				  
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'N' THEN QTY ELSE 0 END) AS GOOD_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'N' AND ISNULL(LONG_TERM_FLAG,'N') = 'Y' THEN QTY ELSE 0 END) AS LONG_TERM_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' THEN QTY ELSE 0 END) AS HOLD_QTY
						, ISNULL(A.SECOND_OCV_EXP_DATE, @KEY_DATE) AS OCV2_DATE	
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND ISNULL(QMS_HOLD_YN, 'N') = 'Y' THEN QTY ELSE 0 END) AS QMS_HOLD_QTY
						, SUM(CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND ISNULL(QMS_HOLD_YN, 'N') = 'N' AND ISNULL(MES_HOLD_YN, 'N') = 'Y' THEN QTY ELSE 0 END) AS MES_HOLD_QTY
				FROM 	SCM_STOCK_H_V A,
						#P_FORM_ITEM B
				WHERE 	1=1
				AND 		A.CUTOFF_DATE = @KEY_DATE
				AND 		(A.ITEM_ID = B.MODULE OR A.ITEM_ID = B.MODEL)
				AND 		A.COMPANY_ID = B.COMPANY_ID 
				AND 		A.DIVISION_ID = B.DIVISION_ID 
				AND 		A.SITE_ID = B.SITE_ID 
				AND 		A.STOCK_TYPE = 'DW'
				AND 		A.STORAGE_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_PACK_FORM_PLAN' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')

				GROUP BY B.COMPANY_ID 
						, B.DIVISION_ID 
						, B.SITE_ID 
						, B.PLANT_ID
						, B.MODEL
						, B.MODULE
						, B.CELL			
						, ISNULL(A.SECOND_OCV_EXP_DATE, @KEY_DATE)
				) A
		WHERE 	1=1
		AND 		CATEGORY_ID != 'NULL'
		GROUP BY  A.COMPANY_ID 
				, A.DIVISION_ID 
				, A.SITE_ID 
				, A.PLANT_ID
				, A.MODEL_ITEM_ID
				, A.MODULE_ITEM_ID
				, A.CELL_ITEM_ID
				, A.CATEGORY_ID				
				, A.OCV2_DATE	   	
		; 

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '31 STOCK BOH'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;
	   
		 ---- 41 Estimated Aging Completed ----
	   
	   	DELETE FP_AMEND_PLAN_P_FORM_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	   	AND 	FP_PLAN_ID = @V_PLAN_ID
	   	AND 	CATEGORY_ID = 'CATEGORY_07'
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = '41 Estimated Aging Completed'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		   

		INSERT INTO FP_AMEND_PLAN_P_FORM_R
		SELECT 	  A.INSTANCE_ID
				, A.FP_PLAN_ID
				, A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ITEM_ID
				, A.MODULE_ITEM_ID
				, A.CELL_ITEM_ID
				, 'CATEGORY_07' AS CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
--				, A.OCV2_DATE AS PLAN_DATE
				, ISNULL(A.OCV2_DATE, DATEADD(DAY, 6, @KEY_DATE)) AS PLAN_DATE
				, A.GOOD_QTY + A.LONG_TERM_QTY  AS QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME
		FROM 	FP_AMEND_PLAN_P_FORM_BOH_R A
		WHERE 	1=1
		AND 		FP_PLAN_ID = @V_PLAN_ID
		AND 		CATEGORY_ID = 'CATEGORY_08'
		;
	
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '41 Estimated Aging Completed'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;	
	   
		 ---- 51 Product Result ----
	   
	   	DELETE FP_AMEND_PLAN_P_FORM_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	   	AND 	FP_PLAN_ID = @V_PLAN_ID
	   	AND 	CATEGORY_ID IN ('CATEGORY_05','CATEGORY_10')
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = '51 Product Result'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		   
	   
		INSERT INTO FP_AMEND_PLAN_P_FORM_R
		SELECT 	  @v_master_id AS INSTANCE_ID
				, @v_plan_id AS FP_PLAN_ID
				, A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, B.MODEL AS MODEL_ITEM_ID
				, B.MODULE AS MODULE_ITEM_ID
				, B.CELL AS CELL_ITEM_ID
				, CASE WHEN OPERATION_ID = 'P5270' THEN 'CATEGORY_10' 
					  WHEN OPERATION_ID = 'P5430' THEN 'CATEGORY_05' END AS CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, A.PLAN_DATE
				, SUM(A.ACTUAL_GOOD_QTY) AS QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME
		FROM 	SCM_DAILY_PRODUCT_RESULT_H A,
				#P_FORM_ITEM B
		WHERE 	1=1
		AND 		A.COMPANY_ID = B.COMPANY_ID
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.PLANT_ID = B.PLANT_ID 
		AND 		A.ITEM_ID = B.MODULE
		--AND		A.PLAN_DATE >= DATEADD(DAY, -30, @KEY_DATE)		
		AND		    A.PLAN_DATE >= DATEADD(MONTH, -1, SUBSTRING(CONVERT(VARCHAR,@KEY_DATE,112),1,6)+'01') -- 과거 계획/실적 전달 1일부터 생성
		AND 		A.OPERATION_ID IN ('P5270','P5430')		
		GROUP BY A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, B.MODEL
				, B.MODULE
				, B.CELL
				, A.OPERATION_ID
				, A.PLAN_DATE		
		;
	
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '51 Product Result'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;		   
	   
		 ---- 61 Fix Product Plan ----
	   
	   	DELETE FP_AMEND_PLAN_P_FORM_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	  	AND 	FP_PLAN_ID = @V_PLAN_ID
	   	AND 	CATEGORY_ID IN ('CATEGORY_04', 'CATEGORY_09')
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = '61 Fix Product Plan'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		   

		INSERT INTO FP_AMEND_PLAN_P_FORM_R
		SELECT 	  A.INSTANCE_ID
				, @V_PLAN_ID AS FP_PLAN_ID
				, A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ITEM_ID
				, A.MODULE_ITEM_ID
				, A.CELL_ITEM_ID
				, A.CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, A.PLAN_DATE
				, A.QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME
		FROM 	FP_AMEND_PLAN_P_FORM_R A
		WHERE 	1=1
		AND 		@v_fix_option = 'Y'
		AND 		A.FP_PLAN_ID = @V_CONFIRM_PLAN_ID
		AND 		A.CATEGORY_ID IN ('CATEGORY_04', 'CATEGORY_09')
		--AND 		A.PLAN_DATE >= @KEY_DATE
		AND		    A.PLAN_DATE >= DATEADD(MONTH, -1, SUBSTRING(CONVERT(VARCHAR,@KEY_DATE,112),1,6)+'01') -- 과거 계획/실적 전달 1일부터 생성
		UNION ALL
		SELECT @V_MASTER_ID	AS INSTANCE_ID
				, @V_PLAN_ID AS FP_PLAN_ID
				, A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, B.MODEL AS MODEL_ITEM_ID
				, B.MODULE AS MODULE_ITEM_ID
				, B.CELL AS CELL_ITEM_ID
				, 'CATEGORY_04' AS CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, DATEADD(DAY, 6, A.PLAN_DATE) AS PLAN_DATE
				, SUM(A.QTY) AS QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME							
			FROM 	SCM_DAILY_PRODUCT_RESULT_H A,
					#P_FORM_ITEM B
			WHERE 	1=1
			AND 		@v_fix_option = 'N'
			AND 		A.COMPANY_ID = B.COMPANY_ID
			AND 		A.DIVISION_ID = B.DIVISION_ID 
			AND 		A.SITE_ID = B.SITE_ID 
			AND 		A.PLANT_ID = B.PLANT_ID 
			AND 		A.ITEM_ID = B.MODULE 
			AND 		A.OPERATION_ID = 'P5270'
			AND 		A.PLAN_DATE >= DATEADD(DAY, -6, @KEY_DATE)
			AND 		A.PLAN_DATE < @KEY_DATE
			GROUP BY A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, B.MODEL
					, B.MODULE
					, B.CELL
					, A.PLAN_DATE
			UNION ALL 			
			SELECT 	  A.INSTANCE_ID
				, @V_PLAN_ID AS FP_PLAN_ID
				, A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ITEM_ID
				, A.MODULE_ITEM_ID
				, A.CELL_ITEM_ID
				, A.CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, A.PLAN_DATE
				, A.QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME
		FROM 	FP_AMEND_PLAN_P_FORM_R A
		WHERE 	1=1
		AND 		@v_fix_option = 'N'
		AND 		A.FP_PLAN_ID = @V_CONFIRM_PLAN_ID
		AND 		A.CATEGORY_ID = 'CATEGORY_04'
		AND		A.PLAN_DATE >= DATEADD(DAY, 6, @KEY_DATE)		
		AND 		A.PLAN_DATE >= @KEY_DATE
		UNION ALL		
		SELECT 	  A.INSTANCE_ID
				, @V_PLAN_ID AS FP_PLAN_ID
				, A.COMPANY_ID
				, A.DIVISION_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.MODEL_ITEM_ID
				, A.MODULE_ITEM_ID
				, A.CELL_ITEM_ID
				, A.CATEGORY_ID
				, '-' AS OPERATION_ID
				, '-' AS PRODUCTION_TYPE
				, '-' AS MARKET
				, '-' AS LINE_ID
				, '-' AS ELECTRODE_TYPE
				, A.PLAN_DATE
				, A.QTY
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_TIME
				, @v_proc_name AS UPDATE_ID
				, GETDATE() AS UPDATE_TIME
		FROM 	FP_AMEND_PLAN_P_FORM_R A
		WHERE 	1=1
		AND 		@v_fix_option = 'N'
		AND 		A.FP_PLAN_ID = @V_CONFIRM_PLAN_ID
		AND 		A.CATEGORY_ID = 'CATEGORY_09'
--		AND 		A.PLAN_DATE >= @KEY_DATE
		AND		A.PLAN_DATE >= DATEADD(MONTH, -1, SUBSTRING(CONVERT(VARCHAR,@KEY_DATE,112),1,6)+'01')			
		;
	
		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = '61 Fix Product Plan'
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    ;		   


		END  --9
		

		
	/*
	 * TEMP TABLE DROP
	 */	
	BEGIN
			
      DROP TABLE #P_FORM_ITEM
      
      --LOG 생성
      SET @v_table_name = 'P_FORM_ITEM'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr
      
      DROP TABLE #CMA_ASSY_PLAN
      
      --LOG 생성
      SET @v_table_name = 'CMA_ASSY_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr     
      
      DROP TABLE #SSP_TARGET
      
      --LOG 생성
      SET @v_table_name = 'SSP_TARGET'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr        
      
      DROP TABLE #BOH_STOCK
      
      --LOG 생성
      SET @v_table_name = 'BOH_STOCK'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr             
			
	END
		
  --- 후미 --- 
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    SET @n_log_count = @n_log_count + 1
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
