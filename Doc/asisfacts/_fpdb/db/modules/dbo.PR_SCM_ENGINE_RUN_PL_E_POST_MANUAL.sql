
CREATE PROCEDURE [dbo].[PR_SCM_ENGINE_RUN_PL_E_POST_MANUAL]  
@p_master_id nvarchar(MAX) = '-', 
--@p_plan_id nvarchar(MAX) = '-' 
@p_KEY_DATE  nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/*************************************************************************************************/   -- 당일기준 
/** 프로그램 ID	: PR_SCM_ENGINE_RUN_PL_E_POST_MANUAL											**/
/** 프로그램 명	:																				**/
/** 설 명		: 전극 후공정 계획 수립 수동													    **/
/** Version		: 1.0.0																			**/
/**																								**/
/** Argument																					**/
/**																								**/
/**  [검색 조건]																				    **/
/**																								**/
/** [Biz Logic]																					**/
/**																								**/
/**---------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유														**/
/**=============================================================================================**/
/** 2019.09.29    최기주			최초 작성													    **/
/*************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;


 -- 필수 칼럼

  DECLARE   @V_MASTER_ID    nvarchar(30)  = 'PL_E_POST'
  DECLARE   @V_PLAN_ID      nvarchar(30) 
  DECLARE   @V_MAX_PLAN_ID      nvarchar(30)
  DECLARE   @v_plan_type    nvarchar(30)
  DECLARE   @V_KEY_DATE     nvarchar(30)   --- 수동실행 시 입력값.(20190930) 
  DECLARE   @V_CUTOFF       DATETIME   
  DECLARE   @v_operation_01   nvarchar(30)
  DECLARE   @KEY_DATE  DATE  
  DECLARE   @CUTOFF_DATE  DATE 
  DECLARE   @V_INSTANCE_DATE  DATE
  DECLARE   @V_SITE_ID      nvarchar(30)
  DECLARE   @V_PLAN_FLAG_DESCR nvarchar(100)
  DECLARE   @V_ASSY_INSTANCE_ID nvarchar(30)
  DECLARE   @V_SCP_PLAN_ID  nvarchar(30)
  SET       @KEY_DATE  = CONVERT( DATE, GETDATE() ) 
  SET       @CUTOFF_DATE  = CONVERT( DATE, GETDATE() ) 
  DECLARE   @V_BASIS_TIME  NVARCHAR(30)    ----+ (20190930) ADD

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_ENGINE_RUN_PL_E_POST_MANUAL'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)


  SET @v_master_id    = @p_master_id
  SET @V_KEY_DATE     = @p_KEY_DATE
  SET @v_plan_type    = NULL
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS NULL, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  
  BEGIN

      -- 대상 SITE 변수 설정
      SET 		@v_table_name = 'FP_INSTANCE_INFO_V'
      SELECT 	@V_SITE_ID = A.SITE_ID
	  FROM 		FP_INSTANCE_INFO_V A
	  WHERE 	A.INSTANCE_ID = @V_MASTER_ID
             
             
      --LOG 생성
      SET @v_message = 'SITE_ID : ' + @V_SITE_ID
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


	  --LOG 생성
      SET @v_message = 'KEY_DATE : ' + @V_KEY_DATE
	  SET @v_descr   = 'MANUAL - INPUT DATE'
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, @v_descr
      
      
      -- 계획 수립 일자 변수 설정
      
      SET 	 @v_table_name = 'FP_INSTANCE_FACTORY_M'
      SELECT @V_INSTANCE_DATE = CASE WHEN DBO.FN_SITE_TIME(@V_SITE_ID) < CONVERT(DATETIME, CONVERT(VARCHAR(10),DBO.FN_SITE_TIME(@V_SITE_ID),112) +' '+LEFT(BASIS_TIME,2)+':'+SUBSTRING(BASIS_TIME,3,2)+':'+RIGHT(BASIS_TIME,2)) 
							       THEN CONVERT(DATE, DATEADD(HOUR, -CONVERT(INT, LEFT(BASIS_TIME,2)), DBO.FN_SITE_TIME(@V_SITE_ID)))
								   ELSE CONVERT(DATE,DBO.FN_SITE_TIME(@V_SITE_ID)) END
		   , @V_BASIS_TIME   =  AAA.BASIS_TIME
	  FROM 	(
			SELECT CASE WHEN MAX(PLANT_BASIS_TIME) IS NULL THEN MAX(BASIS_TIME) ELSE MAX(PLANT_BASIS_TIME) END AS BASIS_TIME
			FROM (
					select  A.INSTANCE_ID,B.PLANT_ID,B.FACTORY_ID,C.PLANT_BASIS_TIME,D.BASIS_TIME 
					from    FP_INSTANCE_FACTORY_M A 
					INNER JOIN SCM_FACTORY_M B 
							ON A.FACTORY_ID=B.FACTORY_ID
					LEFT JOIN (	SELECT SEGMENT1 AS PLANT_ID,SEGMENT2 AS PLANT_BASIS_TIME 
								FROM SCM_SYS_LOOKUP_VALUE 
								WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND   ACTIVE_FLAG = 'Y' ) C
							ON B.PLANT_ID=C.PLANT_ID
					INNER JOIN (SELECT '-' AS CODE_ID, SEGMENT1 AS BASIS_TIME 
								FROM SCM_SYS_LOOKUP_VALUE 
								WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME'
								AND   ACTIVE_FLAG = 'Y') D
							ON 1=1
					WHERE A.INSTANCE_ID = @V_MASTER_ID
				) AA
			) AAA
             
             
      --LOG 생성
      SET @v_message = 'INSTANCE_DATE(SITE) : ' + CONVERT(nvarchar, @V_INSTANCE_DATE, 112) 
	  SET @v_descr   = 'BASIS_TIME: ' + CONVERT( NVARCHAR, @V_BASIS_TIME)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, @v_descr
      
      
      -- CUTOFF DATA I/F 이전이면 이전 날짜로 INSTNACE DATE 설정
      
   --   SELECT 	@V_INSTANCE_DATE = CONVERT(DATE, ATTRIBUTE1)
   --   FROM 		dbo.SCM_SYS_LOOKUP_VALUE
   --   WHERE 	1=1
   --   AND 		LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
	  --AND       ACTIVE_FLAG = 'Y' 
   --   AND 		SEGMENT1 = @V_SITE_ID
	  --AND       SEGMENT2 = @V_BASIS_TIME

	  ---- DEV에서 과거일자 테스트 돌리기 위해 임시로 넣음. 
	  SET   @V_INSTANCE_DATE  = @V_KEY_DATE
      
      --LOG 생성
      SET @v_message = 'INSTANCE_DATE(CUTOFF) : ' + CONVERT(nvarchar, @V_INSTANCE_DATE, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      
      -- 조립 INSTANCE ID 변수 설정
      -- 향후 확산 시 2개 이상의 조립 INSTANCE가 나올 수 있음 - 남경 소형, 자동차, ESS
      
      SET 	 @v_table_name = 'ELEC_ASSY_INSTANCE_MAP'
      SELECT 	@V_ASSY_INSTANCE_ID = SEGMENT2
	  FROM 		SCM_SYS_LOOKUP_VALUE
	  WHERE 	1=1
	  AND 		LOOKUP_TYPE_CODE = 'ELEC_ASSY_INSTANCE_MAP'
	  AND 		SEGMENT3 = @V_MASTER_ID

	  
	  --LOG 생성
      SET @v_message = 'ASSY_INSTANCE_ID : ' + CONVERT(nvarchar, @V_ASSY_INSTANCE_ID, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      
      -- 이전 최종 전극 후공정 계획 변수
      
      SET 	 @v_table_name = 'SCM_FP_PLAN_H'
      SELECT @V_MAX_PLAN_ID = MAX(PLAN_ID)
	  FROM 	SCM_FP_PLAN_H
	  WHERE 	1=1
	  AND 	INSTANCE_ID = @V_MASTER_ID
	  AND 	PLAN_TYPE = 'PRE'
	  
	  
      --LOG 생성
      SET @v_message = 'MAX_PLAN_ID : ' + @V_MAX_PLAN_ID
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      

	  -----------------------------------------------------------------
	  -- 수동실행 PLAN ID 채번. (20190930)
	  -- 당일(@V_KEY_DATE=@V_INSTANCE_DATE)만 재실행 가능하며 PLAN ID는 MAX_PLAN_ID +1 
	  -----------------------------------------------------------------
	    SET 	 @v_table_name = 'SCM_FP_PLAN_H'	


        SELECT  @V_PLAN_ID  = A.PLAN_ID 
			  , @V_PLAN_FLAG_DESCR = A.PLAN_FLAG_DESCR
			  , @v_descr    =  A.GBN 
		FROM    (
					SELECT  AA.PLAN_ID  AS PLAN_ID 
						 ,  CASE WHEN AA.PLAN_ID > @V_MAX_PLAN_ID THEN 'PLANING' ELSE 'SKIP' END PLAN_FLAG_DESCR , 'NEW' AS GBN 
					FROM    (
							SELECT CASE WHEN  LAST_INSTANCE_DATE = CONVERT(nvarchar, @V_INSTANCE_DATE,112 ) 
										THEN  @V_MASTER_ID + '-' + CONVERT(nvarchar, @V_INSTANCE_DATE,112 )  + '-' 
													+ REPLICATE ('0',2-LEN((CONVERT(NUMERIC, RIGHT(@V_MAX_PLAN_ID, 2))+1))) + CAST ( (CONVERT(NUMERIC, RIGHT(@V_MAX_PLAN_ID, 2))+1) AS VARCHAR )
										ELSE  @V_MASTER_ID + '-' + CONVERT(nvarchar, @V_INSTANCE_DATE,112 ) + '-00' 
									END PLAN_ID
							FROM   (
									SELECT INSTANCE_ID, CONVERT(NVARCHAR,PLAN_START_TIME, 112) LAST_INSTANCE_DATE , MAX(PLAN_ID) LAST_PLAN_ID 
									FROM  SCM_FP_PLAN_H   A
									WHERE  INSTANCE_ID = @v_master_id
									AND   PLAN_TYPE = 'PRE' 
									AND   PLAN_ID = @V_MAX_PLAN_ID 
									GROUP BY INSTANCE_ID, CONVERT(NVARCHAR,PLAN_START_TIME, 112)
									) A 
							) AA  
					WHERE CONVERT(NVARCHAR,@V_KEY_DATE,112) =  CONVERT(NVARCHAR ,@V_INSTANCE_DATE,112) 
					UNION ALL 
					SELECT  @V_MAX_PLAN_ID , 'SKIP' , 'OLD' 
					WHERE  CONVERT(NVARCHAR,@V_KEY_DATE,112) !=  CONVERT(NVARCHAR ,@V_INSTANCE_DATE,112) 
				) A 
		WHERE 1=1 

		--LOG 생성
		SET @v_message = 'PLAN_FLAG_DESCR : ' + @V_PLAN_FLAG_DESCR + ' / PLAN_ID : ' + @V_PLAN_ID
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, @v_descr	  

	
      
      -- SCP PLAN ID 설정
      
      SET 	 @v_table_name = 'FP_WEEKLY_DEMAND_PRODUCT_H'
      
      SELECT @V_SCP_PLAN_ID = MAX(SCP_PLAN_ID)
	  FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)
	  WHERE 1=1
	  AND		(A.DIVISION_ID+A.SHOP_GROUP_ID+A.SITE_ID) IN (
																  SELECT DISTINCT (B.DIVISION_ID+A.SHOP_GROUP_ID+B.SITE_ID) AS CODE
																  FROM   FP_INSTANCE_FACTORY_M  A
																			, SCM_FACTORY_M          B
																  WHERE  A.INSTANCE_ID  = @V_MASTER_ID
																  AND    A.FACTORY_ID   = B.FACTORY_ID
																  AND    A.ACTIVE_FLAG  = 'Y'
																  AND    B.ACTIVE_FLAG  = 'Y'
															  )
	  
      --LOG 생성
      SET @v_message = 'SCP_PLAN_ID : ' + @V_SCP_PLAN_ID
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null	 															  
      
  END  

  BEGIN TRY

    -- @V_PLAN_FLAG_DESCR = 'PLANING' 이면 계획 수립 진행
    
  	  IF @V_PLAN_FLAG_DESCR = 'PLANING'
  	  
	  BEGIN 
  		
		SET @v_table_name = 'SCM_FP_PLAN_H'
		
		DELETE FROM SCM_FP_PLAN_H
        WHERE INSTANCE_ID = @V_MASTER_ID
        AND PLAN_ID = @V_PLAN_ID
        
      --LOG 생성
      SET @v_message = @@ROWCOUNT      
      SET @v_descr = 'DELETE PLAN : ' + @V_PLAN_ID
      SET @n_log_count = @n_log_count + 1
   SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr	        


        
        INSERT INTO SCM_FP_PLAN_H
					( INSTANCE_ID	
					, PLAN_ID	
					, PLAN_TYPE	
					, SITE_ID	
					, PLAN_START_TIME	
					, PLAN_HORIZON	
					, PLAN_HORIZON_UOM	
					, DEMAND_HORIZON	
					, DEMAND_HORIZON_UOM	
					, CONFIG_SET_ID	
					, BASIS_PLAN_ID	
					, DEMAND_PLAN_ID	
					, SCP_PLAN_ID	
					, PLAN_WEEK	
					, CONFIRM_FLAG	
					, RELEASE_FLAG	
					, PRE_FIX_FLAG	
					, INSERT_ID	
					, INSERT_TIME	
					, UPDATE_ID	
					, UPDATE_TIME
					)
		SELECT 	  @V_MASTER_ID AS INSTANCE_ID	
					, @V_PLAN_ID AS PLAN_ID	
					, 'PRE' AS PLAN_TYPE	
					, @V_SITE_ID AS SITE_ID	
					, DBO.FN_GET_BASISTIME(@V_MASTER_ID , @V_PLAN_ID) AS PLAN_START_TIME	
					, A.ATTRIBUTE15 * 7 AS PLAN_HORIZON	
					, 'DAY' AS PLAN_HORIZON_UOM	
					, A.ATTRIBUTE13 * 7 DEMAND_HORIZON	
					, 'DAY' AS DEMAND_HORIZON_UOM	
					, 'LG_CHEM' AS CONFIG_SET_ID	
					, @V_PLAN_ID AS BASIS_PLAN_ID	
					, @V_SCP_PLAN_ID AS DEMAND_PLAN_ID	
					, @V_SCP_PLAN_ID AS SCP_PLAN_ID	
					, B.WEEK AS PLAN_WEEK	
					, 'N' AS CONFIRM_FLAG	
					, 'N' AS RELEASE_FLAG	
					, 'N' AS PRE_FIX_FLAG	
					, @V_PROC_NAME AS INSERT_ID	
					, DBO.FN_SITE_TIME(@V_SITE_ID) AS INSERT_TIME	
					, @V_PROC_NAME AS UPDATE_ID	
					, DBO.FN_SITE_TIME(@V_SITE_ID) AS UPDATE_TIME	
			FROM 	SCM_SYS_LOOKUP_VALUE A,
					dbo.SCM_SYS_CALENDAR_M B
			WHERE 	1=1
			AND 	A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
			AND 	A.SEGMENT1 = @V_MASTER_ID		
			AND 	B.DATE_ID = @V_INSTANCE_DATE

      --LOG 생성
      SET @v_message = @@ROWCOUNT      
      SET @v_descr = 'CREATE PLAN : ' + @V_PLAN_ID
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr				
      
      

	  SET @v_table_name = 'TH_BUF_EPOST_CELL_PLAN_INFO'
		
	  DELETE FROM TH_BUF_EPOST_CELL_PLAN_INFO
      WHERE INSTANCE_ID = @V_MASTER_ID
      AND FP_PLAN_ID = @V_PLAN_ID
        
      --LOG 생성
      SET @v_message = @@ROWCOUNT      
      SET @v_descr = 'DELETE PLAN : ' + @V_PLAN_ID
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr	
      
      
      INSERT TH_BUF_EPOST_CELL_PLAN_INFO
		(INSTANCE_ID, 		
		INSTANCE_DATE,
		FP_PLAN_ID, 
		CELL_INSTANCE_ID,			
		CELL_COMFIRM_GROUP_SEQ,
		CELL_COMFIRM_GROUP,
		CELL_RELEASE_PLAN_ID,				
		INSERT_ID,				
		INSERT_TIME)
		SELECT 	@V_MASTER_ID AS INSTANCE_ID,
				CONVERT(VARCHAR(8), @V_INSTANCE_DATE, 112) AS INSTANCE_DATE,
				@V_PLAN_ID AS FP_PLAN_ID,
				A.INSTANCE_ID AS CELL_INSTANCE_ID, 
				RANK() OVER (PARTITION BY A.INSTANCE_ID ORDER BY CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END) AS CONFIRM_GROUP_SEQ,
				CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END AS CONFIRM_GROUP,
				MIN(A.RELEASE_PLAN_ID) AS RELEASE_PLAN_ID,
				'TEST' AS INSERT_ID,
				GETDATE() AS INSERT_TIME
		FROM	FP_RELEASE_PLAN_INFO_H A,
				(
				SELECT 	A.INSTANCE_ID AS CELL_INSTANCE_ID, CONVERT(VARCHAR(8), @V_INSTANCE_DATE, 112) AS INSTANCE_DATE,
						RANK() OVER (PARTITION BY A.INSTANCE_ID ORDER BY CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END) AS CONFIRM_GROUP_SEQ,
						CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END AS CONFIRM_GROUP, B.CONFIRM_AREA,
						MAX(INSTANCE_DATE) AS MAX_INSTANCE_DATE
				FROM 	FP_RELEASE_PLAN_INFO_H A,
						FP_INSTANCE_INFO_V B
				WHERE 	1=1
				AND 	A.INSTANCE_ID = @V_ASSY_INSTANCE_ID
				AND 	A.INSTANCE_ID = B.INSTANCE_ID
				GROUP BY A.INSTANCE_ID, CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN FACTORY_ID ELSE PLAN_GROUP_ID END, B.CONFIRM_AREA
				) B
		WHERE	1=1
		AND		A.INSTANCE_ID = @V_ASSY_INSTANCE_ID
		AND		A.INSTANCE_ID = B.CELL_INSTANCE_ID
		AND		A.INSTANCE_DATE = B.MAX_INSTANCE_DATE
		AND		B.CONFIRM_GROUP = CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END
		GROUP BY A.INSTANCE_ID, B.INSTANCE_DATE, B.CONFIRM_GROUP_SEQ, B.CONFIRM_GROUP, CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END


      --LOG 생성
      SET @v_message = @@ROWCOUNT      
      SET @v_descr = 'EPOST_CELL_PLAN_INFO INSERT'
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	
      
        

      --==== 후공정 계획 프로시저 실행 ====--
      EXEC PR_SCM_ELECTRODE_POST_PLAN_A @V_MASTER_ID, @V_PLAN_ID
      
      --LOG 생성
	  SET @v_table_name = 'FP_ELECTRODE_POST_PLAN_H'
      SET @v_message = 'E POST_PLAN END'
	  SET @v_descr   = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	
      



	  --====  릴리즈 프로시저 실행 ===---
	  BEGIN  -- RELEASE

	    ---- 릴리즈 상태 체크용 ---
		DELETE  TH_BUF_EPOST_RELEASE_STATUS
		WHERE   FP_PLAN_ID  = @V_PLAN_ID
		AND     INSTANCE_ID = @V_MASTER_ID ; 

		INSERT INTO TH_BUF_EPOST_RELEASE_STATUS
				(	INSTANCE_ID , 
					FP_PLAN_ID ,
					FACTORY_ID ,
					INSERT_ID ,
					INSERT_TIME 
				) 
		SELECT	A.INSTANCE_ID , @V_PLAN_ID as plan_id , A.FACTORY_ID , @v_proc_name AS INSERT_ID , GETDATE() as insert_time  
		FROM	FP_INSTANCE_FACTORY_M  A
		    , (	SELECT  DISTINCT SEGMENT1 AS INSTANCE_ID , SEGMENT2 AS EPOST_FACTORY_ID    ---+ (20190906) 
				FROM    SCM_SYS_LOOKUP_VALUE   
				WHERE LOOKUP_TYPE_CODE = 'ELEC_POST_FACTORY_MAP' 
				AND   ACTIVE_FLAG = 'Y' 
				) B
		WHERE A.INSTANCE_ID  =  @V_MASTER_ID
		AND   A.ACTIVE_FLAG   =  'Y' 		
		AND   A.INSTANCE_ID  =  B.INSTANCE_ID
		AND   A.FACTORY_ID   =  B.EPOST_FACTORY_ID		
		;

		--LOG 생성
		SET @v_table_name = 'TH_BUF_EPOST_RELEASE_STATUS'
		SET @v_message = @@ROWCOUNT    
		SET @v_descr   = ''
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	


		--- FACTORY별로 실행하기 위해 커서 사용 ---
	    SET  @v_table_name = 'C_RELEASE'  

		DECLARE  @v_TUNR_COUNT  nvarchar(30)
		
		DECLARE @C_RELEASE$CNT      NUMERIC 
			  , @C_RELEASE$FACTORY  nvarchar(30)
			  , @C_RELEASE$INSTANCE nvarchar(30)
			  , @C_RELEASE$PLAN_ID  nvarchar(30)

		DECLARE
			C_RELEASE CURSOR LOCAL FOR 
				select A.INSTANCE_ID , A.FP_PLAN_ID , A.FACTORY_ID , COUNT(*) OVER(PARTITION BY A.INSTANCE_ID , A.FP_PLAN_ID ) AS CNT 
				from   TH_BUF_EPOST_RELEASE_STATUS A
				WHERE  STATUS IS NULL 
				AND    A.INSTANCE_ID  =  @V_MASTER_ID
				AND    A.FP_PLAN_ID   =  @V_PLAN_ID 
				ORDER BY FACTORY_ID 

		OPEN C_RELEASE 

			WHILE  1=1
			BEGIN --1
				FETCH C_RELEASE INTO  @C_RELEASE$INSTANCE 
									, @C_RELEASE$PLAN_ID
									, @C_RELEASE$FACTORY
									, @C_RELEASE$CNT

			IF @@FETCH_STATUS <> 0
			BREAK

			SET  @v_TUNR_COUNT = @C_RELEASE$CNT 

			--- 프로시저 실행. 
			EXECUTE  PR_SCM_RF_RESCHEDULE_FP_AMEND_POST  @C_RELEASE$INSTANCE , @C_RELEASE$PLAN_ID , @C_RELEASE$FACTORY 


			--LOG 생성
			SET @v_message =  @C_RELEASE$FACTORY
			SET @v_descr   = 'RELEASED FACTORY'
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DONE', @n_log_count, null, @v_message, @v_descr	


			UPDATE  A 
			SET     A.STATUS = 'RELEASED' , 
					A.UPDATE_TIME = GETDATE() ,
					A.UPDATE_ID   = @v_table_name+@v_TUNR_COUNT
			FROM    TH_BUF_EPOST_RELEASE_STATUS A
			WHERE  A.INSTANCE_ID  =  @C_RELEASE$INSTANCE
			AND    A.FP_PLAN_ID   =  @C_RELEASE$PLAN_ID
			AND    A.FACTORY_ID   =  @C_RELEASE$FACTORY 


			SET   @v_TUNR_COUNT -= 1

			IF  @v_TUNR_COUNT <= 0  
			BREAK
			
			END  --1  

		CLOSE   C_RELEASE

		DEALLOCATE  C_RELEASE

		--LOG 생성
		SET @v_message = 'Release Precedure: DONE'
		SET @v_descr   = ''
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	

		
	  END  -- RELEASE 
	  	    
  	  END  -- PLANNING 
  
  	  
	  --====  당일실적 생성 프로시저 ===-- (20190829)

	  EXEC PR_SCM_ELEC_POST_RT_RESULT @v_master_id, @v_plan_id, @v_instance_date


	  --LOG 생성
      SET @v_table_name = 'FP_ELECTRODE_POST_PLAN_H'
	  SET @v_message = 'REALTIME RESULT'
	  SET @v_descr   = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	


  --- 후미 --- 
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    SET @n_log_count = @n_log_count + 1
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', @n_log_count, @v_temp2, null, @v_descr
    commit ; 
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', NULL
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

END
