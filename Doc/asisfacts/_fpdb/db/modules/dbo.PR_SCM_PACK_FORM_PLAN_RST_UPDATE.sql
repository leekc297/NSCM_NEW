--USE [LGCE_FP_TR]

CREATE PROCEDURE [dbo].[PR_SCM_PACK_FORM_PLAN_RST_UPDATE]  
--@p_master_id nvarchar(MAX) = '-', 
--@p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/************************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_PACK_FORM_PLAN_RST_UPDATE										**/
/** 프로그램 명	:																**/
/** 설 명		: 최종 Release Plan Result 갱신											**/
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
/** 2022.10.24    최기주        최초 작성												**/
/*************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
  SET XACT_ABORT ON;


 -- 필수 칼럼

DECLARE   @V_MASTER_ID    nvarchar(30)  
DECLARE   @V_PLAN_ID      nvarchar(30)
DECLARE   @V_CONFIRM_PLAN_ID      nvarchar(30)
DECLARE   @KEY_DATE  DATE  
DECLARE 	@n_target_end_day NUMERIC

	SET   @KEY_DATE     = CONVERT( DATE, GETDATE() ) 
	
  -- LOG 용 변수 설정
  DECLARE  @v_proc_name      nvarchar(100) = 'PR_SCM_PACK_FORM_PLAN_RST_UPDATE'
  DECLARE  @v_table_name     nvarchar(100)
  DECLARE  @v_message        nvarchar(250)
  DECLARE  @v_descr          nvarchar(250)
  DECLARE  @n_row_count      Integer  = 0
  DECLARE  @n_log_count      Integer  = 0
  DECLARE  @v_log_code       nvarchar(10)
  DECLARE  @sysdate          DATETIME2 = GETDATE()
  --DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)


  SET @V_MASTER_ID    = 'PL_P_FORM'
  SET @V_PLAN_ID      = 'PL_P_FORM'
  
  --SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  
  BEGIN

      --LOG 생성
	  
	 SELECT 	@V_CONFIRM_PLAN_ID = A.PLAN_ID,
	 		@v_plan_id = A.PLAN_ID
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
      
	  
      SET @v_table_name = 'SCM_FP_PLAN_H'
      SELECT  @KEY_DATE = CONVERT(DATE, PLAN_START_TIME)
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
           
      				
	SELECT	@n_target_end_day = CONVERT(NUMERIC, ATTRIBUTE13) * 7
	FROM 	SCM_SYS_LOOKUP_VALUE
	WHERE 	1=1
	AND 		LOOKUP_TYPE_CODE = 'INSTANCE_ID'
	AND 		SEGMENT1 = 'PL_P_FORM'
	
      --LOG 생성
	SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
     SET @v_message = 'TARGET_END_DAY : ' + CONVERT(nvarchar, @n_target_end_day) 
     SET @n_log_count = @n_log_count + 1
     SET @sysdate = GETDATE()
     EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, NULL
     
     
      
  END  

  BEGIN TRY

	BEGIN  
	--------------------------------------------------
	-- 1. 대상 Item 생성 
	--	P5200 공정을 가지고 있는 MEB 제품
	--	대상 선택이 추가적인 제약이 필요한 경우 LOOKUP 등에 사전 정의 필요    	 
	--------------------------------------------------
    	  SET @v_table_name = 'P_FORM_ITEM'

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

	BEGIN --2
		--=========================================================
		-- 2. PLAN RESULT UPDATE
		--=========================================================

		SET      @v_table_name = 'FP_AMEND_PLAN_P_FORM_R'

		---- 21- DISCHARGING PLAN ---- 
		
	   	DELETE FP_AMEND_PLAN_P_FORM_R
	   	WHERE 	1=1
	   	AND 	INSTANCE_ID = @V_MASTER_ID
	   	AND 	FP_PLAN_ID = @V_CONFIRM_PLAN_ID
	   	AND 	CATEGORY_ID IN ('CATEGORY_05', 'CATEGORY_10')
	   
		--LOG 생성
	    	SET @v_message = @@ROWCOUNT
	    	SET @v_descr = 'PLAN RESULT'
	    	SET @n_log_count = @n_log_count + 1
	    	SET @sysdate = GETDATE()
	    	EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr
	    	;		
		
		INSERT INTO FP_AMEND_PLAN_P_FORM_R
		SELECT 	  @v_master_id AS INSTANCE_ID
				, @V_CONFIRM_PLAN_ID AS FP_PLAN_ID
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
		;

		--LOG 생성
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = 'DISCHARGING PLAN'
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
