-- DROP PROCEDURE [dbo].[PR_SCM_ITEM_LINE_VERSION]

CREATE PROCEDURE [dbo].[PR_SCM_ITEM_LINE_VERSION]  
--@p_master_id nvarchar(MAX) = '-', 
--@p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/************************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_ITEM_LINE_VERSION											**/
/** 프로그램 명	: PR_SCM_ITEM_LINE_VERSION											**/
/** 설 명		: ITEM LINE VERSION 정보 생성											**/
/** Version	: 1.0.0															**/
/**																			**/
/** Argument																	**/
/**																			**/
/**  [검색 조건]																	**/
/**																			**/
/** [Biz Logic]																**/
/**																			**/
/**--------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                               			**/
/**============================================================================================**/
/** 2022.12.19    CGJ 				최초 작성										**/
/************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;


 -- 변수 정의

  DECLARE   @v_master_id    nvarchar(30)  
  DECLARE   @v_plan_id      nvarchar(30)   
  DECLARE   @v_comfirm_area   nvarchar(30)   
  DECLARE   @v_release_group   nvarchar(30)   
  DECLARE   @v_start_min   numeric(20,10)
  DECLARE   @v_alarm_yn   nvarchar(30)
  DECLARE   @key_month  nvarchar(6) 
--  SET   @key_date     = CONVERT( DATE, GETDATE() ) 

  -- LOG 용 변수 설정
  DECLARE  @v_proc_name      nvarchar(100) = 'PR_SCM_ITEM_LINE_VERSION'
  DECLARE  @v_table_name     nvarchar(100)
  DECLARE  @v_message        nvarchar(250)
  DECLARE  @v_descr          nvarchar(250)
  DECLARE  @n_row_count      Integer  = 0
  DECLARE  @n_log_count      Integer  = 0
  DECLARE  @v_log_code       nvarchar(10)
  DECLARE  @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)


  SET @v_master_id    	= 'E_PRE ALL INSTANCE'
  SET @v_plan_id      	= 'E_PRE ALL INSTANCE'
    
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  
  /*
  변수 설정
  */
  
  BEGIN 
      
      -- 계획 수립일 설정
      SET @v_table_name = 'SCM_FP_PLAN_H'
      
      SELECT  @key_month = CONVERT(NVARCHAR(6),getdate(),112)
             
      --LOG 생성
      SET @v_message = 'KEY_MONTH : ' + @key_month
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      
  END  

  BEGIN TRY

    -- 로직 시작
	BEGIN  
	--------------------------------------------------
	-- 1. ITEM LINE VERSION DATA INSERT 
	--    신규 LINE ASSIGN DATA 기준 VERSION 정보 INSERT
	--------------------------------------------------
   			
		INSERT INTO SCM_ITEM_CONV_CALC_USE_M
		SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
				, A.OPERATION_ID, C.MODEL_ID, A.ITEM_ID, A.LINE_ID
				, A.ELECTRODE_TYPE, C.VERSION
				, 'Y' AS ACTIVE_FLAG, NULL AS DESCRIPTION 
				, @v_proc_name AS INSERT_ID , GETDATE() AS INSERT_TIME  
				, @v_proc_name AS UPDATE_ID , GETDATE() AS UPDATE_TIME 
		FROM 	SCM_ITEM_LINE_ASSIGN_M A,
				SCM_LINE_M B,
				SCM_ITEM_CONV_CALC_M C
		WHERE 	1=1
		AND 		A.OPERATION_ID = 'E2000'
		AND 		A.ACTIVE_FLAG = 'Y'
		AND 		A.MONTH >= @key_month
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.FACTORY_ID = B.FACTORY_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.ACTIVE_FLAG = 'Y'
		AND 		A.COMPANY_ID = C.COMPANY_ID 
		AND 		A.DIVISION_ID = C.DIVISION_ID 
		AND 		A.SITE_ID = C.SITE_ID
		AND 		A.OPERATION_ID = C.OPERATION
		AND 		A.FACTORY_ID = C.FACTORY_ID 
		AND 		A.ITEM_ID = C.ITEM_ID 
		AND 		B.PROD_VERSION_TYPE = C.PROD_VERSION_TYPE		
		AND 		NOT EXISTS (SELECT	1
						  FROM	SCM_ITEM_CONV_CALC_USE_M X
						  WHERE 	1=1
						  AND 	A.COMPANY_ID = X.COMPANY_ID
						  AND 	A.DIVISION_ID = X.DIVISION_ID
						  AND 	A.SITE_ID = X.SITE_ID
						  AND 	A.PLANT_ID = X.PLANT_ID
						  AND 	A.OPERATION_ID = X.OPERATION_ID
						  AND 	C.MODEL_ID = X.MODEL_ID
						  AND 	A.ITEM_ID = X.ITEM_ID
						  AND 	A.LINE_ID = X.LINE_ID
						  AND 	A.ELECTRODE_TYPE = X.ELECTRODE_TYPE
						  AND 	C.VERSION = X.VERSION)						  
		GROUP BY 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
				, A.OPERATION_ID, C.MODEL_ID, A.ITEM_ID, A.LINE_ID
				, A.ELECTRODE_TYPE, C.VERSION
		; 
		
	    --LOG 생성
		SET @v_table_name = 'SCM_ITEM_CONV_CALC_USE_M'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    
	    
		
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
