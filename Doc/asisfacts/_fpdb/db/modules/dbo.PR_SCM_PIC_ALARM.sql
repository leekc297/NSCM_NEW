-- DROP PROCEDURE [dbo].[PR_SCM_PIC_ALARM]

CREATE PROCEDURE [dbo].[PR_SCM_PIC_ALARM]  
@p_master_id nvarchar(MAX) = '-', 
@p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/*************************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_PIC_ALARM												**/
/** 프로그램 명	: PR_SCM_PIC_ALARM																						**/
/** 설 명		:  Alarm기능																	**/
/** Version		: 1.0.0																						**/
/**																												**/
/** Argument																								**/
/**																												**/
/**  [검색 조건]																								**/
/**																												**/
/** [Biz Logic]																								**/
/**																												**/
/**---------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                       			**/
/**===========================================================**/
/** 2022.06.23    CGJ 				최초 작성																**/
/*************************************************************************************************/

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
  DECLARE   @key_date  DATE  
  SET   @key_date     = CONVERT( DATE, GETDATE() ) 

  -- LOG 용 변수 설정
  DECLARE  @v_proc_name      nvarchar(100) = 'PR_SCM_PIC_ALARM'
  DECLARE  @v_table_name     nvarchar(100)
  DECLARE  @v_message        nvarchar(250)
  DECLARE  @v_descr          nvarchar(250)
  DECLARE  @n_row_count      Integer  = 0
  DECLARE  @n_log_count      Integer  = 0
  DECLARE  @v_log_code       nvarchar(10)
  DECLARE  @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)


  SET @v_master_id    	= @p_master_id
  SET @v_plan_id      		= @p_plan_id
    
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
      
      SELECT  @key_date = CONVERT(DATE, PLAN_START_TIME)
      FROM   (
              SELECT	PLAN_START_TIME
              FROM	SCM_FP_PLAN_H
              WHERE	INSTANCE_ID 	= @v_master_id
              AND    PLAN_ID     		= @v_plan_id
             ) A             
             
      --LOG 생성
      SET @v_message = 'KEY_DATE : ' + CONVERT(nvarchar, @KEY_DATE, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      -- CONFIRM AREA 정의
      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
      
		SELECT 	@v_comfirm_area = ATTRIBUTE1
		FROM 	SCM_SYS_LOOKUP_VALUE
		WHERE 	1=1
		AND 		LOOKUP_TYPE_CODE = 'INSTANCE_ID'
		AND 		SEGMENT1 = @v_master_id             
             
      --LOG 생성
      SET @v_message = 'CONFIRM AREA : ' + @v_comfirm_area 
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null     
      
     -- RELEASE GROUP 정의 
      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'
      
	  SELECT 	@v_release_group = CASE WHEN @v_comfirm_area = 'BUILDING' THEN FACTORY_ID ELSE PLAN_GROUP_ID END
	  FROM 		FP_RELEASE_PLAN_INFO_H
	  WHERE 	1=1
	  AND 		INSTANCE_ID = @v_master_id
	  AND    	RELEASE_PLAN_ID = @v_plan_id             
             
      --LOG 생성
      SET @v_message = '@v_release_group : ' + @v_release_group
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null           
      
      -- 시업 시간 분 단위 정의 
      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
      
		SELECT 	@v_start_min = CONVERT(NUMERIC, ATTRIBUTE4)
		FROM 	SCM_SYS_LOOKUP_VALUE
		WHERE 	1=1
		AND 		LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		AND 		SEGMENT1 = (SELECT 	DISTINCT PLANT_ID 
									  FROM 		FP_INSTANCE_INFO_V
									  WHERE 	1=1
									  AND 		INSTANCE_ID = @v_master_id)
             
      --LOG 생성
      SET @v_message = '@v_start_min : ' --+ CONVERT(NVARCHAR(3), @v_start_min)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null                        
      
      -- 시업 시간 분 단위 정의 
      SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE'
      
		SELECT 	@v_alarm_yn = ATTRIBUTE1
		FROM 	SCM_SYS_LOOKUP_VALUE
		WHERE 	1=1
		AND 		LOOKUP_TYPE_CODE = 'INSTANCE_OPTION'
		AND 		SEGMENT1 = @v_master_id
             
      --LOG 생성
      SET @v_message = '@v_alarm_yn : ' + @v_alarm_yn
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null                 
      
      
  END  

  BEGIN TRY

    -- 로직 시작
	BEGIN  
	--------------------------------------------------
	-- 1. ALARM 대상 선정 
	--    RELEASE 기준으로 ALARM 대상 선정
	--------------------------------------------------
   			
		SELECT 	CONVERT(NVARCHAR, A.PLAN_DATE, 112) + '_' + A.ITEM_ID + '_' + A.PRODUCTION_TYPE +'_' + A.LINE_ID +'_' + A.ELECTRODE_TYPE + '_' + A.OPERATION_ID AS ALARM_ID,
					A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, A.PLAN_DATE
		INTO 		#PIC_ALARM_PLAN
		FROM 	FP_AMEND_MEMO_M A,
					SCM_LINE_M B
		WHERE 	1=1
		AND 		A.INSTANCE_ID = @v_master_id
		AND 		A.PLAN_DATE >= @key_date
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID 
		AND 		A.PLANT_ID = B.PLANT_ID 
		AND 		A.FACTORY_ID = B.FACTORY_ID 
		AND 		A.LINE_ID =B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.FACTORY_ID = CASE WHEN @v_comfirm_area = 'BUILDING' THEN @v_release_group ELSE A.FACTORY_ID  END
		AND 		ISNULL(B.MODEL_TYPE, '-')  = CASE WHEN @v_comfirm_area != 'BUILDING' THEN @v_release_group ELSE ISNULL(B.MODEL_TYPE, '-')  END
		AND 		A.PRODUCTION_TYPE != 'MASS'
		AND 		B.ACTIVE_FLAG = 'Y'
		AND 		@v_alarm_yn = 'Y'
		; 
		
	    --LOG 생성
		SET @v_table_name = 'PIC_ALARM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr
	    
	--------------------------------------------------
	-- 2. LINE별 OPERATION별 생산 순위 산출 
	--    ALARM PLAN DO의 동일 LINE, ELECTRODE TYPE의 계획 확인    
     --    ALARM PLAN D+1의 동일 LINE, ELECTRODE TYPE의 계획 확인
     --    ALARM PLAN D-1의 동일 LINE, ELECTRODE TYPE의 계획 확인
	--    D+1일에 동일 ITEM, PRODUCTION TYPE이 있다면 D0의 마지막 계획으로
	--------------------------------------------------
   			
		SELECT 	DISTINCT B.ALARM_ID
					, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID, A.ITEM_ID
					, A.FP_PRODUCTION_TYPE, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID
					, A.PLAN_DATE, A.PLAN_IN_QTY 
					, CASE WHEN B.ALARM_ID = CONVERT(NVARCHAR, A.PLAN_DATE, 112) + '_' + A.ITEM_ID + '_' + A.FP_PRODUCTION_TYPE +'_' + A.LINE_ID +'_' + A.ELECTRODE_TYPE + '_' + A.OPERATION_ID THEN 'Y' ELSE 'N' END AS ALARM_YN
					, 50 AS SEQ
		INTO 		#ITEM_PLAN
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
					#PIC_ALARM_PLAN B
		WHERE 	1=1
		AND 		A.FACTORY_ID = B.FACTORY_ID
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.PLAN_DATE = B.PLAN_DATE
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		A.PLAN_QTY > 0
		; 
		
	 --LOG 생성
		SET @v_table_name = 'ITEM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	    
	    
	    
		SELECT 	DISTINCT B.ALARM_ID 
					, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID, A.ITEM_ID
					, A.FP_PRODUCTION_TYPE, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID
					, A.PLAN_DATE, A.PLAN_IN_QTY 
					, 'N' AS ALARM_YN
					, 50 AS SEQ
		INTO 		#PRE_ITEM_PLAN
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
					#PIC_ALARM_PLAN B
		WHERE 	1=1
		AND 		A.FACTORY_ID = B.FACTORY_ID
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.PLAN_DATE = DATEADD(DD, -1,B.PLAN_DATE)
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		A.PLAN_QTY > 0
		; 
		
	    --LOG 생성
		SET @v_table_name = 'PRE_ITEM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		    
	    
	    
		SELECT 	DISTINCT B.ALARM_ID 
					, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID, A.ITEM_ID
					, A.FP_PRODUCTION_TYPE, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID
					, A.PLAN_DATE, A.PLAN_IN_QTY 
					, 'N' AS ALARM_YN
					, 50 AS SEQ
		INTO 		#POST_ITEM_PLAN								
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
					#PIC_ALARM_PLAN B
		WHERE 	1=1
		AND 		A.FACTORY_ID = B.FACTORY_ID
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.PLAN_DATE = DATEADD(DD, 1,B.PLAN_DATE)
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		A.PLAN_QTY > 0
		; 
		
	    --LOG 생성
		SET @v_table_name = 'POST_ITEM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		   	    
	    
	    
		UPDATE 	#ITEM_PLAN
		SET 		SEQ = CASE WHEN B.ITEM_ID IS NOT NULL AND A.FP_PRODUCTION_TYPE = 'MASS' THEN 98
							 WHEN B.ITEM_ID IS NOT NULL AND A.FP_PRODUCTION_TYPE != 'MASS' THEN 99
							 ELSE A.SEQ END
		FROM 	#ITEM_PLAN A,
					#POST_ITEM_PLAN B
		WHERE 	1=1
		AND 	A.LINE_ID = B.LINE_ID 
		AND 	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 	A.OPERATION_ID = B.OPERATION_ID 
		AND 	A.TOP_ITEM_ID = B.TOP_ITEM_ID 
		AND 	A.ITEM_ID = B.ITEM_ID 
		AND 	A.FP_PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE 
		AND 	A.PLAN_DATE = DATEADD(DD, -1,B.PLAN_DATE)			
		AND 	A.ALARM_ID = B.ALARM_ID
		;
	    
	    --LOG 생성
		SET @v_table_name = 'ITEM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr		   	 
	    

	    UPDATE 	#ITEM_PLAN
		SET 		SEQ = CASE WHEN B.ITEM_ID IS NOT NULL AND A.FP_PRODUCTION_TYPE = 'MASS' THEN 2
							 WHEN B.ITEM_ID IS NOT NULL AND A.FP_PRODUCTION_TYPE != 'MASS' THEN 1
							 ELSE A.SEQ END
		FROM 	#ITEM_PLAN A,
					#PRE_ITEM_PLAN B
		WHERE  	1=1
		AND 	A.LINE_ID = B.LINE_ID 
		AND 	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 	A.OPERATION_ID = B.OPERATION_ID 
		AND 	A.TOP_ITEM_ID = B.TOP_ITEM_ID 
		AND 	A.ITEM_ID = B.ITEM_ID 
		AND 	A.FP_PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE 
		AND 	A.PLAN_DATE = DATEADD(DD, 1,B.PLAN_DATE)		
		AND 	A.ALARM_ID = B.ALARM_ID
		;

		--LOG 생성
		SET @v_table_name = 'ITEM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr
	    
	    
		UPDATE 	#PRE_ITEM_PLAN
		SET 		SEQ = CASE WHEN B.ITEM_ID IS NOT NULL AND B.SEQ = 1 THEN 99
									  WHEN B.ITEM_ID IS NOT NULL THEN 98
							 ELSE 1 END
		FROM 	#PRE_ITEM_PLAN A,
					#ITEM_PLAN B
		WHERE  	1=1
		AND 	A.LINE_ID = B.LINE_ID 
		AND 	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 	A.OPERATION_ID = B.OPERATION_ID 
		AND 	A.TOP_ITEM_ID = B.TOP_ITEM_ID 
		AND 	A.ITEM_ID = B.ITEM_ID 
		AND 	A.FP_PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE 
		AND 	A.PLAN_DATE = DATEADD(DD, -1,B.PLAN_DATE)		
		AND 	A.ALARM_ID = B.ALARM_ID
		;
		
		--LOG 생성
		SET @v_table_name = 'PRE_ITEM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr		
	    
	    
		INSERT INTO #ITEM_PLAN
		SELECT 	* 
		FROM #PRE_ITEM_PLAN				    
		
		--LOG 생성
		SET @v_table_name = 'ITEM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		
	    
	    
	    SELECT 	A.*, B.DAILY_CAPA, CASE WHEN 86400/B.DAILY_CAPA*A.PLAN_IN_QTY > 86400 THEN 86400 ELSE 86400/B.DAILY_CAPA*A.PLAN_IN_QTY END AS OPERATION_TIME
					, DATEADD(SS, SUM(CASE WHEN 86400/B.DAILY_CAPA*A.PLAN_IN_QTY > 86400 THEN 86400 ELSE 86400/B.DAILY_CAPA*A.PLAN_IN_QTY END) OVER (PARTITION BY A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, A.PLAN_DATE  ORDER BY A.SEQ ), DATEADD(MINUTE ,@v_start_min,PLAN_DATE)) AS END_TIME
		INTO 		#ALARM_PLAN			
		FROM 	(
					SELECT 	A.*, RANK() OVER (PARTITION BY ALARM_ID, LINE_ID, ELECTRODE_TYPE, OPERATION_ID ORDER BY PLAN_DATE, SEQ, CASE WHEN FP_PRODUCTION_TYPE = 'MASS' THEN 9 ELSE 1 END, CASE WHEN ALARM_YN = 'Y' THEN 1 ELSE 2 END, ITEM_ID, FP_PRODUCTION_TYPE) AS RNK
					FROM 	#ITEM_PLAN A	
					) A,
					SCM_TACT_TIME_M B
		WHERE 	1=1
		AND 		A.ITEM_ID = B.ITEM_ID
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		CONVERT(varchar(6), A.PLAN_DATE, 112) = B.[MONTH] 
		;

		--LOG 생성
		SET @v_table_name = 'ALARM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		
	    
	    
	--------------------------------------------------
	-- 3. MEMO TABLE DATA INSERT 
	--    대상 ALARM 초기화
	-- 	  대상 ALARM UPDATE	
	--------------------------------------------------	    
	    
		UPDATE 	FP_AMEND_MEMO_M
		SET		ALARM_YN = 'N',
					ALARM_TIME = '',
					UPDATE_ID = @v_proc_name,
					UPDATE_TIME = GETDATE()
		FROM 	FP_AMEND_MEMO_M A,
					#PIC_ALARM_PLAN B
		WHERE 	1=1
		AND 		A.PLANT_ID = B.PLANT_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.ITEM_ID = B.ITEM_ID
		AND 		A.PRODUCTION_TYPE = B.PRODUCTION_TYPE 
		AND 		A.PLAN_DATE = B.PLAN_DATE 	    
		;
		
		--LOG 생성
		SET @v_table_name = 'FP_AMEND_MEMO_M - 0'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			
	    
		UPDATE X
		SET		--ALARM_YN = 'Y',
					ALARM_TIME = CASE WHEN A.ITEM_ID = B.ITEM_ID AND A.FP_PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE THEN C.END_TIME ELSE B.END_TIME END,
					UPDATE_ID = @v_proc_name,
					UPDATE_TIME = GETDATE()
		FROM 	FP_AMEND_MEMO_M X,
					#ALARM_PLAN	A
					LEFT OUTER JOIN #ALARM_PLAN B
					ON 	1=1
					AND 	A.LINE_ID = B.LINE_ID
					AND 	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
					AND 	A.OPERATION_ID = B.OPERATION_ID
					AND 	B.RNK = A.RNK -1
					AND 	A.ALARM_ID = B.ALARM_ID
					LEFT OUTER JOIN #ALARM_PLAN C
					ON 	1=1
					AND 	A.LINE_ID = C.LINE_ID
					AND 	A.ELECTRODE_TYPE = C.ELECTRODE_TYPE
					AND 	A.OPERATION_ID = C.OPERATION_ID
					AND 	C.RNK = A.RNK -2			
					AND 	A.ALARM_ID = C.ALARM_ID
		WHERE 	1=1
		AND 		A.ALARM_YN = 'Y'
		AND 		A.RNK != 1
		AND 		A.PLANT_ID = X.PLANT_ID 
		AND 		A.LINE_ID = X.LINE_ID 
		AND 		A.ELECTRODE_TYPE = X.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = X.OPERATION_ID 
		AND 		A.ITEM_ID = X.ITEM_ID
		AND 		A.FP_PRODUCTION_TYPE = X.PRODUCTION_TYPE 
		AND 		A.PLAN_DATE = X.PLAN_DATE 
		;
		
		--LOG 생성
		SET @v_table_name = 'FP_AMEND_MEMO_M'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			    
	    
	    
	--------------------------------------------------
	-- 4. MEMO TABLE DATA INSERT - 예외 CASE
	--    D-1일이 휴일이거나 계획이 없는 경우
	-- 	  계회 수립일 이후 ALARM 대상의 최후 계획을 찾아서 END TIME 산출
	--------------------------------------------------	  	    
	    
	    
	    SELECT 	A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, A	.ALARM_ID
			    	, A.PRE_PLAN_DATE, A.PLAN_DATE 
		INTO 	#PRE_ALARM_PLAN_INFO
		FROM 	(
				SELECT 	A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, B.ALARM_ID
			    			, MAX(A.PLAN_DATE) AS PRE_PLAN_DATE, B.PLAN_DATE 		
				FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
							#ALARM_PLAN B
				WHERE 	1=1
				AND 		A.PLANT_ID = B.PLANT_ID
				AND 		A.FACTORY_ID = B.FACTORY_ID 
				AND 		A.LINE_ID = B.LINE_ID 
				AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
				AND 		A.OPERATION_ID = B.OPERATION_ID 
				AND 		A.PLAN_DATE < B.PLAN_DATE 
				AND 		B.ALARM_YN = 'Y'
				AND 		B.RNK = 1
				AND 		A.PLAN_TYPE = 'RELEASE'
				AND 		A.PLAN_QTY > 0
				AND 		A.PLAN_DATE >= @key_date
				GROUP BY A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, B.ALARM_ID
							, B.ITEM_ID, B.FP_PRODUCTION_TYPE, B.LINE_ID, B.ELECTRODE_TYPE, B.OPERATION_ID, B.PLAN_DATE
				UNION ALL 
						SELECT 	A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, A.ALARM_ID
			    			, NULL AS PRE_PLAN_DATE, A.PLAN_DATE 	
				FROM 	#ALARM_PLAN A
				WHERE 	1=1
				AND 		ALARM_ID IN (		
								    SELECT 	A.ALARM_ID	    			
									FROM 	#ALARM_PLAN A
											LEFT OUTER JOIN FP_DAILY_PRODUCTIOIN_PLAN_H B
											ON 1=1
											AND 		A.PLANT_ID = B.PLANT_ID
											AND 		A.FACTORY_ID = B.FACTORY_ID 
											AND 		A.LINE_ID = B.LINE_ID 
											AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
											AND 		A.OPERATION_ID = B.OPERATION_ID 
											AND 		B.PLAN_DATE < A.PLAN_DATE
											AND 		B.PLAN_TYPE = 'RELEASE'
											AND 		B.PLAN_QTY > 0
											AND 		B.PLAN_DATE >= @key_date
									WHERE 	1=1
									AND 		A.RNK = 1
									AND 		B.PLAN_DATE IS NULL		
									GROUP BY B.PLANT_ID, B.FACTORY_ID, B.LINE_ID, B.ELECTRODE_TYPE, B.OPERATION_ID, A.ALARM_ID
												, A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, A.PLAN_DATE					
									)
				AND 		PLAN_DATE >= @key_date
				) A
		;
					
		--LOG 생성
		SET @v_table_name = 'PRE_ALARM_PLAN_INFO'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		
	    	    
	    
		SELECT 	B.ALARM_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, A.PLAN_DATE, A.PLAN_IN_QTY--, C.DAILY_CAPA 
					, DATEADD(SS, SUM(CASE WHEN 86400/C.DAILY_CAPA*A.PLAN_IN_QTY > 86400 THEN 86400 ELSE 86400/C.DAILY_CAPA*A.PLAN_IN_QTY END) OVER (PARTITION BY A.LINE_ID, A.ELECTRODE_TYPE, A.OPERATION_ID, A.PLAN_DATE  ORDER BY A.ITEM_ID ), DATEADD(MINUTE ,@v_start_min,A.PLAN_DATE)) AS END_TIME
		INTO 	#PRE_ALARM_PLAN
		FROM 	FP_DAILY_PRODUCTIOIN_PLAN_H A,
					#PRE_ALARM_PLAN_INFO B,
					SCM_TACT_TIME_M C
		WHERE 	1=1
		AND 		A.PLANT_ID = B.PLANT_ID
		AND 		A.FACTORY_ID = B.FACTORY_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.PLAN_DATE = B.PRE_PLAN_DATE 
		AND 		A.PLAN_TYPE = 'RELEASE'
		AND 		A.PLAN_QTY > 0
		AND 		A.ITEM_ID = C.ITEM_ID
		AND 		A.LINE_ID = C.LINE_ID 
		AND 		A.ELECTRODE_TYPE = C.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = C.OPERATION_ID 
		AND 		CONVERT(varchar(6), A.PLAN_DATE, 112) = C.[MONTH] 
		AND 		B.PRE_PLAN_DATE IS NOT NULL
		;
					
		--LOG 생성
		SET @v_table_name = 'PRE_ALARM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr		
	    
	    INSERT INTO #PRE_ALARM_PLAN
	    SELECT 	A.ALARM_ID, A.PLANT_ID, A.FACTORY_ID, B.ITEM_ID, B.LINE_ID, B.ELECTRODE_TYPE, A.OPERATION_ID, A.PLAN_DATE, B.PLAN_IN_QTY--, C.DAILY_CAPA 
					, DATEADD(MINUTE, CONVERT(NUMERIC, LEFT(C.ATTRIBUTE1,2))*60 + CONVERT(NUMERIC, RIGHT(C.ATTRIBUTE1,2)), A.PLAN_DATE ) AS END_TIME
		FROM 	#PRE_ALARM_PLAN_INFO A,
				#ITEM_PLAN B,
				SCM_SYS_LOOKUP_VALUE C
		WHERE 	1=1
		AND 		A.PRE_PLAN_DATE IS NULL
		AND 		A.ALARM_ID = B.ALARM_ID
		AND 		C.LOOKUP_TYPE_CODE = 'PIC_ALARM_BASIS_TIME'
		
		--LOG 생성
		SET @v_table_name = 'PRE_ALARM_PLAN'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr				
	    
		UPDATE 	X
		SET 		ALARM_YN = 'Y',
				ALARM_TIME = B.END_TIME,
					UPDATE_ID = @v_proc_name,
					UPDATE_TIME = GETDATE()
		FROM 	FP_AMEND_MEMO_M X,
					#ALARM_PLAN	A,
					#PRE_ALARM_PLAN B
		WHERE 	1=1
		AND 		A.PLANT_ID = X.PLANT_ID 
		AND 		A.LINE_ID = X.LINE_ID 
		AND 		A.ELECTRODE_TYPE = X.ELECTRODE_TYPE 
		AND 		A.OPERATION_ID = X.OPERATION_ID 
		AND 		A.ITEM_ID = X.ITEM_ID
		AND 		A.FP_PRODUCTION_TYPE = X.PRODUCTION_TYPE 
		AND 		A.PLAN_DATE = X.PLAN_DATE 
		AND 		A.ALARM_YN = 'Y'
		AND 		A.RNK = 1
		AND 		A.ALARM_ID = B.ALARM_ID 
		;
		
		--LOG 생성
		SET @v_table_name = 'FP_AMEND_MEMO_M'
	    SET @v_message = @@ROWCOUNT
	    SET @v_descr = NULL
	    SET @n_log_count = @n_log_count + 1
	    SET @sysdate = GETDATE()
	    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr			    
		
	END 

	--TEMP TABLE DROP
	
    BEGIN        
	    
      DROP TABLE #PIC_ALARM_PLAN
      
      --LOG 생성
      SET @v_table_name = 'PIC_ALARM_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr      
      
      DROP TABLE #ITEM_PLAN		
      
      --LOG 생성
      SET @v_table_name = 'ITEM_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr      
    
      DROP TABLE #PRE_ITEM_PLAN		
      
      --LOG 생성
      SET @v_table_name = 'PRE_ITEM_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr      
    
      DROP TABLE #POST_ITEM_PLAN		
      
      --LOG 생성
      SET @v_table_name = 'POST_ITEM_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr      
          
      DROP TABLE #ALARM_PLAN		
      
      --LOG 생성
      SET @v_table_name = 'ALARM_PLAN'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr            
      
      DROP TABLE #PRE_ALARM_PLAN_INFO
      
      --LOG 생성
      SET @v_table_name = 'PRE_ALARM_PLAN_INFO'
      SET @v_message = @@ROWCOUNT
      SET @v_descr = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DROP', @n_log_count, null, @v_message, @v_descr        
      
      DROP TABLE #PRE_ALARM_PLAN
      
      --LOG 생성
      SET @v_table_name = 'PRE_ALARM_PLAN'
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
