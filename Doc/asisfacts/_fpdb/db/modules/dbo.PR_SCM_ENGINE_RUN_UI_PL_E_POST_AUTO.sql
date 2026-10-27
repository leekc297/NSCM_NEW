CREATE PROCEDURE [dbo].[PR_SCM_ENGINE_RUN_UI_PL_E_POST_AUTO]
@p_instance_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS

/*************************************************************************************************/   
/** 프로그램 ID	: PR_SCM_ENGINE_RUN_UI_PL_E_POST_AUTO											**/
/** 프로그램 명	:																				**/
/** 설 명		: 전극 후공정 계획 수립 Engine													**/
/** Version		: 1.0.0																			**/
/**																								**/
/** Argument																					**/
/**																								**/
/**  [검색 조건]																			    **/
/**																								**/
/** [Biz Logic]																					**/
/**																								**/
/**---------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유														**/
/**=============================================================================================**/
/** 2019.10.01    최기주			최초 작성												    **/
/*************************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- LOG 용 변수 설정
  DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_ENGINE_RUN_UI_PL_E_POST_AUTO'
  DECLARE @v_descr     nvarchar(250)
  DECLARE @v_message   nvarchar(250)
  DECLARE @v_flag  nvarchar(1) = 'N'
  DECLARE @v_run_flag  nvarchar(1) = 'N'
  DECLARE @v_run_step  nvarchar(1) = '0'
  DECLARE @v_plan_flag  nvarchar(1) = 'C'
  DECLARE @v_run_step2  nvarchar(1) = '0'
  DECLARE @n_loop_date nvarchar(250)
  DECLARE @n_loop_count INTEGER    = 0
  
  DECLARE @n_log_count INTEGER    = 0
  DECLARE @sysdate     DATETIME     = GETDATE()
  DECLARE @v_log_code   nvarchar(10)
  DECLARE @v_isfinished nvarchar(20)
  DECLARE @v_table_name     nvarchar(100)
  
  -- ERROR_LINE
  DECLARE @v_temp1     nvarchar(1000)
  DECLARE @v_temp2     nvarchar(1000)

  -- ================================================
    -- Declare start
  -- ================================================
  DECLARE @v_instance_id      nvarchar(1000)  
  DECLARE @v_plan_id          nvarchar(1000)
  DECLARE @v_instance_date    date
  DECLARE @v_basis_time       nvarchar(30)
  DECLARE @v_assy_instance_id nvarchar(30)
  DECLARE @v_max_plan_id      nvarchar(30)
  DECLARE @v_plan_flag_descr  nvarchar(100)
  DECLARE @v_scp_plan_id      nvarchar(30)
    
  DECLARE @sqltext        nvarchar(1000)
        , @v_site_id      nvarchar(10)
  
  -- ================================================
    -- Declare end
  -- ================================================
  SET @v_instance_id  = @p_instance_id
--  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  -- Start 로그는 무조건 남김
  SET @n_log_count = @n_log_count + 1
  EXEC PR_XIF_LOG @v_proc_name, null, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', null, @sysdate
  
  EXEC PR_LOG_PROCESS null, @v_instance_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', @v_descr
  
  BEGIN TRY        
/*
    BEGIN

      SELECT @v_site_id = ISnull(MAX(B.SITE_ID), 'A004' )
      FROM   FP_INSTANCE_FACTORY_M  A
           , SCM_FACTORY_M          B
      WHERE  A.INSTANCE_ID  = @v_instance_id
      AND    A.FACTORY_ID   = B.FACTORY_ID
      AND    A.ACTIVE_FLAG  = 'Y'
      AND    B.ACTIVE_FLAG  = 'Y'
    
      --LOG 생성
      SET @v_descr = 'SITE ID : ' + @v_site_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXEC PR_LOG_PROCESS null, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, null, @v_descr, null

    END
*/
    BEGIN
    -- ================================================
    -- 로직 추가 start
    -- ================================================
      -- 당일 Batch로 실행하는 최초 PLAN일경우 PLAN ID을 INSTANCE ID+해당년월일+00으로 셋팅
      /*
      IF @v_plan_id = 'FIRST_PLAN'
      */
--        BEGIN
--          SET @v_plan_id = @v_instance_id + '-' + CONVERT(nvarchar,dbo.FN_SITE_TIME(@v_site_id),112) + '-00'
--          
--          SET @n_log_count = @n_log_count + 1
--          SET @v_descr = 'SET First Plan : ' + @v_plan_id
--          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, null, @v_descr, null

	  -- 대상 SITE 변수 설정
      SET 		@v_table_name = 'FP_INSTANCE_INFO_V'
      
      SELECT 	@v_site_id = A.SITE_ID
	  FROM 		FP_INSTANCE_INFO_V A
	  WHERE 	A.INSTANCE_ID = @v_instance_id
             
             
      --LOG 생성
      SET @v_descr = 'SITE_ID : ' + @v_site_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SET', @n_log_count, null, @v_descr, null
      


      -- 계획 수립 일자 변수 설정
      
      SET 	 @v_table_name = 'FP_INSTANCE_FACTORY_M'
      
      SELECT @v_instance_date = CASE WHEN DBO.FN_SITE_TIME(@v_site_id) < CONVERT(DATETIME, CONVERT(VARCHAR(10),DBO.FN_SITE_TIME(@v_site_id),112) +' '+LEFT(BASIS_TIME,2)+':'+SUBSTRING(BASIS_TIME,3,2)+':'+RIGHT(BASIS_TIME,2)) 
							       THEN CONVERT(DATE, DATEADD(HOUR, -CONVERT(INT, LEFT(BASIS_TIME,2)), DBO.FN_SITE_TIME(@v_site_id)))
								   ELSE CONVERT(DATE,DBO.FN_SITE_TIME(@v_site_id)) END
		   , @v_basis_time   =  AAA.BASIS_TIME
	  FROM 	(
			SELECT CASE WHEN MAX(PLANT_BASIS_TIME) IS null THEN MAX(BASIS_TIME) ELSE MAX(PLANT_BASIS_TIME) END AS BASIS_TIME
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
					WHERE A.INSTANCE_ID = @v_instance_id
				) AA
			) AAA
             
             
      --LOG 생성
      SET @v_message = 'INSTANCE_DATE(SITE) : ' + CONVERT(nvarchar, @v_instance_date, 112) + '  BASIS_TIME: ' + CONVERT( NVARCHAR, @v_basis_time)
--	  SET @v_descr   = 'BASIS_TIME: ' + CONVERT( NVARCHAR, @v_basis_time)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SET', @n_log_count, null, @v_message, null
      
      
      -- CUTOFF DATA I/F 이전이면 이전 날짜로 INSTNACE DATE 설정
      SET 	 @v_table_name = 'SCM_SYS_LOOKUP_VALUE - AUTO_PLAN_CALL_FLAG'
      
      SELECT 	@v_instance_date = CONVERT(DATE, ATTRIBUTE1)
      FROM 		dbo.SCM_SYS_LOOKUP_VALUE
      WHERE 	1=1
      AND 		LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
	  AND       ACTIVE_FLAG = 'Y' 
      AND 		SEGMENT1 = @v_site_id
	  AND       SEGMENT2 = @v_basis_time
      
      --LOG 생성
      SET @v_message = 'INSTANCE_DATE(CUTOFF) : ' + CONVERT(nvarchar, @v_instance_date, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SET', @n_log_count, null, @v_message, null
      
      
      -- 조립 INSTANCE ID 변수 설정
      -- 향후 확산 시 2개 이상의 조립 INSTANCE가 나올 수 있음 - 남경 소형, 자동차, ESS
      
      SET 	 @v_table_name = 'SCM_SYS_LOOKUP_VALUE - ELEC_ASSY_INSTANCE_MAP'
      
      SELECT 	@v_assy_instance_id = SEGMENT2
	  FROM 		SCM_SYS_LOOKUP_VALUE
	  WHERE 	1=1
	  AND 		LOOKUP_TYPE_CODE = 'ELEC_ASSY_INSTANCE_MAP'
	  AND 		SEGMENT3 = @v_instance_id

	  
	  --LOG 생성
      SET @v_message = 'ASSY_INSTANCE_ID : ' + CONVERT(nvarchar, @v_assy_instance_id, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SET', @n_log_count, null, @v_message, null
      
      
      -- 이전 최종 전극 후공정 계획 변수
      
      SET 	 @v_table_name = 'SCM_FP_PLAN_H'
      
      SELECT @v_max_plan_id = MAX(PLAN_ID)
	  FROM 	SCM_FP_PLAN_H
	  WHERE 	1=1
	  AND 	INSTANCE_ID = @v_instance_id
	  AND 	PLAN_TYPE = 'PRE'
	  
	  
      --LOG 생성
      SET @v_message = 'MAX_PLAN_ID : ' + @v_max_plan_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SET', @n_log_count, null, @v_message, null
      
          
      -- 계획 수립 여부 변수 및 PLAN ID 설정
      -- 최종 계획 기준 INSTANCE DATE 변경 시 계획 당일 첫 계획 수립
      -- 최종 계획 기준 INSTANCE DATE가 동일하고 조립 RELEASE PLAN ID가 변경되었다면 당일 신규 계획 수립
      -- 최종 계획 기준 변동이 없다면 MAX PLAN ID 유지
      
      SET 	 @v_table_name = 'FP_RELEASE_PLAN_INFO_H'

/*    수동실행 시 새 버전을 지정함.  */ 
--	  SET    @v_plan_flag_descr = 'PLANING' 
--	  SET    @v_plan_id         = 'PL_E_POST-20191101-01'  

	  SELECT 	@v_plan_flag_descr = CASE WHEN SUM(INSTANCE_GAB) > 0 
										  THEN 'PLANING'
										  WHEN SUM(INSTANCE_GAB) = 0 AND SUM(RELEASE_GAB) > 0 
										  THEN 'PLANING'
										  ELSE 'SKIP' END, 
				@v_plan_id =  		 CASE WHEN SUM(INSTANCE_GAB) > 0 
									      THEN A.INSTANCE_ID + '-' + A.INSTANCE_DATE + '-00'
									 WHEN SUM(INSTANCE_GAB) = 0 AND SUM(RELEASE_GAB) > 0 
									 THEN A.INSTANCE_ID + '-' + A.INSTANCE_DATE + '-' 
									      +	REPLICATE ('0',2-LEN((CONVERT(NUMERIC, RIGHT(@v_max_plan_id, 2))+1))) + CAST ( (CONVERT(NUMERIC, RIGHT(@v_max_plan_id, 2))+1) AS VARCHAR )
									 ELSE @v_max_plan_id END 
	  FROM 	(
				SELECT 	ISnull(B.INSTANCE_ID, @v_instance_id) AS INSTANCE_ID, A.*, B.INSTANCE_DATE AS MAX_INSTANCE_DATE, B.CELL_RELEASE_PLAN_ID,
						CASE WHEN A.INSTANCE_DATE = B.INSTANCE_DATE THEN 0 ELSE 1 END AS INSTANCE_GAB,
						CASE WHEN A.RELEASE_PLAN_ID = B.CELL_RELEASE_PLAN_ID THEN 0 ELSE 1 END AS RELEASE_GAB
				FROM 	(
						
						SELECT	A.INSTANCE_ID AS CELL_INSTANCE_ID, B.INSTANCE_DATE, B.CONFIRM_GROUP_SEQ, B.CONFIRM_GROUP, MIN(RELEASE_PLAN_ID) AS RELEASE_PLAN_ID
						FROM	FP_RELEASE_PLAN_INFO_H A,
								(
								SELECT 	A.INSTANCE_ID AS CELL_INSTANCE_ID, CONVERT(VARCHAR(8), @v_instance_date, 112) AS INSTANCE_DATE,
										RANK() OVER (PARTITION BY A.INSTANCE_ID ORDER BY CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END) AS CONFIRM_GROUP_SEQ,
										CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END AS CONFIRM_GROUP, B.CONFIRM_AREA,
										MAX(INSTANCE_DATE) AS MAX_INSTANCE_DATE
								FROM 	FP_RELEASE_PLAN_INFO_H A,
										FP_INSTANCE_INFO_V B
								WHERE 	1=1
								AND 	A.INSTANCE_ID = @v_assy_instance_id
								AND 	A.INSTANCE_ID = B.INSTANCE_ID
								GROUP BY A.INSTANCE_ID, CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN FACTORY_ID ELSE PLAN_GROUP_ID END, B.CONFIRM_AREA
								) B
						WHERE	1=1
						AND		A.INSTANCE_ID = @v_assy_instance_id
						AND		A.INSTANCE_ID = B.CELL_INSTANCE_ID
						AND		A.INSTANCE_DATE = B.MAX_INSTANCE_DATE
						AND		B.CONFIRM_GROUP = CASE WHEN B.CONFIRM_AREA = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END
						GROUP BY A.INSTANCE_ID, B.INSTANCE_DATE, B.CONFIRM_GROUP_SEQ, B.CONFIRM_GROUP
						) A
						LEFT OUTER JOIN TH_BUF_EPOST_CELL_PLAN_INFO B
							ON 	1=1
							AND B.INSTANCE_ID = @v_instance_id
							AND B.FP_PLAN_ID =  @v_max_plan_id 
							AND A.CELL_INSTANCE_ID = B.CELL_INSTANCE_ID
							AND A.CONFIRM_GROUP_SEQ = B.CELL_COMFIRM_GROUP_SEQ
							AND A.CONFIRM_GROUP = CELL_COMFIRM_GROUP
				) A
	  WHERE 	1=1
	  GROUP BY A.INSTANCE_ID, A.INSTANCE_DATE   ; 

		  
      --LOG 생성
      SET @v_message = 'PLAN_FLAG_DESCR : ' + @v_plan_flag_descr + ' / PLAN_ID : ' + @v_plan_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SET', @n_log_count, null, @v_message, null	  
      
      
	      -- SCP PLAN ID 설정
	      
	  SET 	 @v_table_name = 'FP_WEEKLY_DEMAND_PRODUCT_H'
	      
		SELECT	@v_scp_plan_id = MAX(SCP_PLAN_ID)
		FROM	FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)
		WHERE	1=1
		AND		EXISTS (
							SELECT 1
							FROM (
									SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, A.SHOP_GROUP_ID
									FROM   FP_INSTANCE_FACTORY_M  A WITH(NOLOCK)
										 , SCM_FACTORY_M          B WITH(NOLOCK)
									WHERE  A.INSTANCE_ID  = @v_instance_id
									AND    A.FACTORY_ID   = B.FACTORY_ID
									AND    A.ACTIVE_FLAG  = 'Y'
									AND    B.ACTIVE_FLAG  = 'Y'
								) X
							WHERE 1=1
							AND A.COMPANY_ID	= X.COMPANY_ID
							AND A.DIVISION_ID	= X.DIVISION_ID
							AND A.SITE_ID		= X.SITE_ID
							AND A.SHOP_GROUP_ID = X.SHOP_GROUP_ID
						)
		  
	  --LOG 생성
	  SET @v_message = 'SCP_PLAN_ID : ' + @v_scp_plan_id
	  SET @n_log_count = @n_log_count + 1
	  SET @sysdate = GETDATE()
	  EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'SET', @n_log_count, null, @v_message, null	 

  --BEGIN TRY

    -- @V_PLAN_FLAG_DESCR = 'PLANING' 이면 계획 수립 진행
    
  	  IF @V_PLAN_FLAG_DESCR = 'PLANING' AND	  
	       (
        -- KOR --------------------------------------------------------------------
             @v_instance_id = 'KR_E_POST'     OR @v_instance_id = 'KR_E_POST_A'
                                              OR @v_instance_id = 'KR_E_POST_M'
        -- CHN --------------------------------------------------------------------

          OR @v_instance_id = 'CN_E_POST'
        -- USA --------------------------------------------------------------------
          OR @v_instance_id = 'US_E_POST'
        -- POL --------------------------------------------------------------------
          OR @v_instance_id = 'PL_E_POST'
           )
      BEGIN
	      
      SET 	 @v_table_name = 'SCM_FP_PLAN_H'
      
      DELETE FROM scm_fp_plan_h
      WHERE INSTANCE_ID = @v_instance_id
      AND PLAN_ID = @v_plan_id
            
	        --LOG 생성
	  SET @v_descr = @@ROWCOUNT      
	  SET @v_message = 'DELETE PLAN : ' + @v_plan_id
	  SET @n_log_count = @n_log_count + 1
	  SET @sysdate = GETDATE()
	  EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr            
	            
      INSERT INTO	SCM_FP_PLAN_H
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
	  SELECT 	  @v_instance_id AS INSTANCE_ID	
					, @v_plan_id AS PLAN_ID	
					, 'PRE' AS PLAN_TYPE	
					, @v_site_id AS SITE_ID	
					, DBO.FN_GET_BASISTIME(@v_instance_id , @v_plan_id) AS PLAN_START_TIME	
					, A.ATTRIBUTE15 * 7 AS PLAN_HORIZON	
					, 'DAY' AS PLAN_HORIZON_UOM	
					, A.ATTRIBUTE13 * 7 DEMAND_HORIZON	
					, 'DAY' AS DEMAND_HORIZON_UOM	
					, 'LG_CHEM' AS CONFIG_SET_ID	
					, @v_plan_id AS BASIS_PLAN_ID	
					, @v_scp_plan_id AS DEMAND_PLAN_ID	
					, @v_scp_plan_id AS SCP_PLAN_ID	
					, B.WEEK AS PLAN_WEEK	
					, 'N' AS CONFIRM_FLAG	
					, 'N' AS RELEASE_FLAG	
					, 'N' AS PRE_FIX_FLAG	
					, @v_proc_name AS INSERT_ID	
					, DBO.FN_SITE_TIME(@v_site_id) AS INSERT_TIME	
					, @v_proc_name AS UPDATE_ID	
					, DBO.FN_SITE_TIME(@v_site_id) AS UPDATE_TIME	
	  FROM 	SCM_SYS_LOOKUP_VALUE A,
			dbo.SCM_SYS_CALENDAR_M B
	  WHERE 	1=1
	  AND 	A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
	  AND 	A.SEGMENT1 = @v_instance_id		
	  AND 	B.DATE_ID = @v_instance_date

        --LOG 생성
      SET @v_descr = @@ROWCOUNT      
      SET @v_message = 'CREATE PLAN : ' + @v_plan_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	
      
	  SET @v_table_name = 'TH_BUF_EPOST_CELL_PLAN_INFO'
		
	  DELETE FROM TH_BUF_EPOST_CELL_PLAN_INFO
      WHERE INSTANCE_ID = @v_instance_id
      AND FP_PLAN_ID = @V_PLAN_ID
        
      --LOG 생성
      SET @v_message = @@ROWCOUNT      
      SET @v_descr = 'DELETE PLAN : ' + @V_PLAN_ID
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr	
      
      
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
		SELECT 	@v_instance_id AS INSTANCE_ID,
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
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	      

      
      SET 	 @v_table_name = 'FP_PLAN_STATUS_H'
	      
      DELETE FROM FP_PLAN_STATUS_H
      WHERE  INSTANCE_ID = @v_instance_id 
      AND    PLAN_ID = @v_plan_id 
            
            --LOG 생성
	  SET @v_descr = @@ROWCOUNT      
	  SET @v_message = 'DELETE PLAN : ' + @v_plan_id
	  SET @n_log_count = @n_log_count + 1
	  SET @sysdate = GETDATE()
	  EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr 
                
      INSERT INTO FP_PLAN_STATUS_H
                  (
                    INSTANCE_ID
                  , PLAN_ID
                  , ACTIVE_FLAG
                  , INBOUND_FLAG
                  , INBOUND_START
                  , ENGINE_FLAG
                  , OUTBOUND_FLAG
                  , DB_TRANS_FLAG
                  , INSERT_ID
                  , INSERT_TIME
                  , UPDATE_ID
                  , UPDATE_TIME
                  )
      SELECT 
                    @v_instance_id
                  , @v_plan_id
                  , 1 AS active_flag
                  , 'P' AS inbound_flag
                  , sysdatetime() AS inbound_start
                  , 'R' AS engine_flag
                  , 'R' AS outbound_flag
                  , 'R' AS db_trans_flag
                  , @v_proc_name AS insert_id
                  , sysdatetime() AS insert_date
                  , @v_proc_name AS update_id
                  , sysdatetime() AS update_date
            
      SET @n_log_count = @n_log_count + 1
      SET @v_descr = @@ROWCOUNT
      SET @v_message = 'Create Plan Status : ' + @v_plan_id
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'SET', @n_log_count, null, @v_message, @v_descr

--          END
    
        
      /* -- 해당 부분 UI로 이관... 20161115 LJS
      -- PLAN상태정보 초기화
      DELETE FROM FP_PLAN_STATUS_H
      WHERE  INSTANCE_ID = @v_instance_id 
      AND    PLAN_ID = @v_plan_id 
          
      INSERT INTO FP_PLAN_STATUS_H
            (
              INSTANCE_ID
            , PLAN_ID
            , ACTIVE_FLAG
            , INBOUND_FLAG
            , INBOUND_START
            , ENGINE_FLAG
            , OUTBOUND_FLAG
            , DB_TRANS_FLAG
            , INSERT_ID
            , INSERT_TIME
            , UPDATE_ID
            , UPDATE_TIME
            )
      SELECT 
              @v_instance_id
            , @v_plan_id
            , 1 AS active_flag
            , 'P' AS inbound_flag
            , sysdatetime() AS inbound_start
            , 'R' AS engine_flag
            , 'R' AS outbound_flag
            , 'R' AS db_trans_flag
            , @v_proc_name AS insert_id
            , sysdatetime() AS insert_date
            , @v_proc_name AS update_id
            , sysdatetime() AS update_date
      */
  
      --IF
        -- KOR --------------------------------------------------------------------
             --@v_instance_id = 'KR_E_POST'     OR @v_instance_id = 'KR_E_POST_A'
--                                              OR @v_instance_id = 'KR_E_POST_M'
        -- CHN --------------------------------------------------------------------

          --OR @v_instance_id = 'CN_E_POST'
        -- USA --------------------------------------------------------------------
         --- OR @v_instance_id = 'US_E_POST'
        -- POL --------------------------------------------------------------------
          --OR @v_instance_id = 'PL_E_POST'
      --BEGIN
	        
	      -- 수요 생성 프로시저 추가  
          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_ELECTRODE_POST_PLAN_A Start'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, null, @v_descr, null
          
          EXEC(@v_instance_id+'_SY_PR_SCM_ELECTRODE_POST_PLAN_A '''+@v_instance_id+''','''+@v_plan_id+'''')	      
      
	        
          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_IF_PLAN Start'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, null, @v_descr, null
          
          EXEC(@v_instance_id+'_SY_PR_SCM_IF_PLAN '''+@v_instance_id+''','''+@v_plan_id+'''')

          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_IF_PLAN End'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, null, @v_descr, null

          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_RUN_ENGINE Start'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, null, @v_descr, null
          
          EXEC(@v_instance_id+'_SY_PR_SCM_RUN_ENGINE '''+@v_instance_id+''','''+@v_plan_id+'''')

          SET @n_log_count = @n_log_count + 1
          SET @v_descr = @v_instance_id + ' PR_SCM_RUN_ENGINE End'
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, null, @v_descr, null
          
          -- ENGINE 실행완료 대기
          SET @n_loop_date = CONVERT(nvarchar,GETDATE(),120)
          SET @n_loop_count = 0
          
          WHILE 1 = 1
            BEGIN
              SET @sqltext='SELECT @v_return=CASE WHEN (b.PLAN_STATUS IS null) THEN ''P'' ELSE ''C'' END
              FROM 
                (
                  SELECT a.MASTER_ID, a.PLAN_ID, a.OUT_VERSION_ID
                  FROM '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG  AS a
                  WHERE a.MASTER_ID = '''+@v_instance_id+''' AND 
                        a.PLAN_ID = '''+@v_plan_id+''' AND 
                        a.ACTIVE_FLAG = 1
                )  AS a 
                 LEFT OUTER JOIN '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS  AS b 
                 ON 
                    a.MASTER_ID = b.MASTER_ID AND 
                    a.PLAN_ID = b.PLAN_ID AND 
                    a.OUT_VERSION_ID = b.OUT_VERSION_ID AND 
                    b.PLAN_STATUS = ''DONE'''
              EXEC sp_executesql @sqltext,N'@v_return AS NVARCHAR OUTPUT', @v_return=@v_isfinished OUTPUT
              
              -- Engine의 실행이 종료되거나 대기시간 600초가 넘으면 종료
              IF @v_isfinished = 'C' OR @n_loop_count >= 600
                BEGIN
                  IF @v_isfinished = 'C'
                    SET @v_run_flag = 'Y'
                  BREAK
                END
              
              -- 초가 변경되면  체크
              IF @n_loop_date <> CONVERT(nvarchar,GETDATE(),120)
                BEGIN
                  SET @n_loop_count = @n_loop_count + 1
                  SET @n_loop_date = CONVERT(nvarchar,GETDATE(),120)
                  
                  IF @n_loop_count/5 = @n_loop_count/5.0
                    BEGIN
                      SET @n_log_count = @n_log_count + 1
                      SET @v_descr = CONVERT(nvarchar,@n_loop_count) + ' Count'
                      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'COUNT', @n_log_count, null, @v_descr, null
                    END
                  
                  --Engine실행 STEP 확인
                  SET @sqltext='
                  SELECT @v_return = ISnull(MAX(PLAN_STEP),''0'') FROM (
                  select TOP 1 MASTER_ID,PLAN_ID,PLAN_STATUS
                    ,CASE WHEN PLAN_STATUS=''LOADING'' THEN ''1''
                    WHEN PLAN_STATUS=''PLANNING'' THEN ''2''
                    WHEN PLAN_STATUS=''SAVING'' THEN ''3''
                    WHEN PLAN_STATUS=''DONE'' THEN ''4'' END AS PLAN_STEP
                  from '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS
                  where MASTER_ID = '''+@v_instance_id+''' AND plan_id = '''+@v_plan_id+'''
                  order by 
                    CASE WHEN PLAN_STATUS=''LOADING'' THEN ''1''
                    WHEN PLAN_STATUS=''PLANNING'' THEN ''2''
                    WHEN PLAN_STATUS=''SAVING'' THEN ''3''
                    WHEN PLAN_STATUS=''DONE'' THEN ''4'' END DESC
                  ) A'
                  
                  EXEC sp_executesql @sqltext,N'@v_return AS NVARCHAR OUTPUT', @v_return=@v_run_step2 OUTPUT
                  
                  IF @v_run_step < @v_run_step2
                    BEGIN
  SET @v_run_step=@v_run_step2
                      
                      UPDATE FP_PLAN_STATUS_H
                      SET ENGINE_STEP = @v_run_step
                      FROM FP_PLAN_STATUS_H A
                      WHERE A.INSTANCE_ID = @v_instance_id AND A.plan_id = @v_plan_id
                      
                      SET @n_log_count = @n_log_count + 1
                      SET @v_descr = ' Engine STATUS UPDATE : ' + @v_run_step + '/4'
                      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'COUNT', @n_log_count, null, @v_descr, null
                    END
                END
            END
            
          EXEC('UPDATE FP_PLAN_STATUS_H
          SET ENGINE_START=B.ENGINE_START
          FROM FP_PLAN_STATUS_H A, '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG B
          WHERE A.INSTANCE_ID=B.MASTER_ID
          AND A.PLAN_ID=B.PLAN_ID
          AND A.PLAN_ID=B.OUT_VERSION_ID
          AND A.INSTANCE_ID = '''+@v_instance_id+''' 
          AND A.PLAN_ID = '''+@v_plan_id+'''') 

          IF @v_run_flag = 'Y'
            BEGIN
              BEGIN
                EXEC('UPDATE '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG
                SET ENGINE_FLAG=''C'',ENGINE_END=GETDATE()
                FROM '+@v_instance_id+'_SY_TH_MST_ENG_PLAN_FLAG A
                WHERE A.MASTER_ID = '''+@v_instance_id+''' 
                  AND A.PLAN_ID = '''+@v_plan_id +'''
                  AND A.OUT_VERSION_ID = '''+@v_plan_id+'''')
                
                  EXEC('UPDATE FP_PLAN_STATUS_H
                      SET 
                         ENGINE_FLAG=''C'',
                         ENGINE_STEP = ''4'',
                         ENGINE_END = B.EVENT_TIME, 
                         UPDATE_ID = '''+@v_proc_name+''', 
                         UPDATE_TIME = sysdatetime()
                   FROM FP_PLAN_STATUS_H  A,
                           '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS B
                   WHERE A.INSTANCE_ID = B.MASTER_ID
                    AND    A.PLAN_ID = B.PLAN_ID
                    AND    A.PLAN_ID = B.OUT_VERSION_ID
                    AND    B.PLAN_STATUS = ''SAVING''
                    AND    a.INSTANCE_ID = '''+@v_instance_id+''' 
                    AND    a.PLAN_ID = '''+@v_plan_id+'''')

                
                SET @n_log_count = @n_log_count + 1
                SET @v_descr = @v_plan_id  + ':TH_MST_ENG_PLAN_FLAG UPDATE'
                EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'UPDATE', @n_log_count, null, @v_descr, null
              END
              
              SET @n_log_count = @n_log_count + 1
              SET @v_descr = @v_instance_id + ':ENGINE Finised'
              EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ENGINE', @n_log_count, null, @v_descr, null
              
              SELECT @v_plan_flag=DB_TRANS_FLAG
              FROM FP_PLAN_STATUS_H
              WHERE INSTANCE_ID = @v_instance_id
                AND PLAN_ID = @v_plan_id
              
              IF @v_plan_flag = 'S'
                BEGIN
                     EXEC('UPDATE FP_PLAN_STATUS_H
                        SET 
                           OUTBOUND_FLAG = ''C'',
                           OUTBOUND_STEP = ''4'',
                           OUTBOUND_END = B.EVENT_TIME, 
                           ACTIVE_FLAG = 0,
                           UPDATE_ID = '''+@v_proc_name+''', 
                           UPDATE_TIME = sysdatetime()
                     FROM FP_PLAN_STATUS_H  A,
                             '+@v_instance_id+'_SY_TH_ENG_PLAN_STATUS B
                     WHERE A.INSTANCE_ID = B.MASTER_ID
                      AND    A.PLAN_ID = B.PLAN_ID
                      AND  A.PLAN_ID = B.OUT_VERSION_ID
                      AND    B.PLAN_STATUS = ''DONE''
                      AND    a.INSTANCE_ID = '''+@v_instance_id+''' 
                      AND    a.PLAN_ID = '''+@v_plan_id+'''')

                  
                  SET @n_log_count = @n_log_count + 1
                  SET @v_descr = @v_plan_id + ' USER Stop'
                  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'STOP', @n_log_count, null, @v_descr, null
                END
              ELSE
                BEGIN
                  --엔진실행후 OUtbound 프로시져 실행
                  SET @n_log_count = @n_log_count + 1
                  SET @v_descr = @v_instance_id + ' PR_SCM_OF_RESULT Start'
                  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, null, @v_descr, null
                  
                  EXEC(@v_instance_id+'_SY_PR_SCM_OF_RESULT '''+@v_instance_id+''', '''+@v_plan_id+'''')
        
                  SET @n_log_count = @n_log_count + 1
                  SET @v_descr = @v_instance_id + ' PR_SCM_OF_RESULT End'
                  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, null, @v_descr, null
                END

            END
          ELSE -- 비정상적인 엔진수행으로 오류처리후 종료
            BEGIN
                 UPDATE FP_PLAN_STATUS_H
                    SET 
                       ACTIVE_FLAG=0,
                       ENGINE_FLAG='E',
                       UPDATE_ID = @v_proc_name, 
                       UPDATE_TIME = sysdatetime()
                 FROM FP_PLAN_STATUS_H  A
                 WHERE a.INSTANCE_ID = @v_instance_id  
                  AND  a.PLAN_ID = @v_plan_id

              SET @n_log_count = @n_log_count + 1
              SET @v_descr = @v_instance_id + ':ENGINE Not Finised. Time Out'
              EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ENGINE', @n_log_count, null, @v_descr, null
            END
        END
      ELSE
        BEGIN
          UPDATE FP_PLAN_STATUS_H
            SET
              ACTIVE_FLAG=0,
              INBOUND_FLAG='E',
              UPDATE_ID = @v_proc_name, 
              UPDATE_TIME = sysdatetime()
          FROM FP_PLAN_STATUS_H  A
          WHERE a.INSTANCE_ID = @v_instance_id  
          AND  a.PLAN_ID = @v_plan_id

          SET @n_log_count = @n_log_count + 1
          EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'WARRING', @n_log_count, null, '############### NO PLANNING !!! OR INSTANCE NOT FOUND !!! ###############', null
        END
/*
      BEGIN 
        DELETE FROM SCM_LOSS_CALENDAR_M
        WHERE INSTANCE_ID = @v_instance_id
        AND PLAN_ID = @v_plan_id
        
        SET @v_descr = 'SCM_LOSS_CALENDAR_M DELETE :'+CONVERT(nvarchar,@@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'DELETE', @n_log_count, null, @v_descr, null
        
        INSERT INTO SCM_LOSS_CALENDAR_M
             (
               INSTANCE_ID
             , PLAN_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , EQUIPMENT_ID
             , OFF_TYPE_ID
             , OFF_START_TIME
             , OFF_END_TIME
             , REPEAT_ID
             , REPEAT_FLAG
             , WORK_CENTER_ID
             , DESCRIPTION
             , INSERT_ID
             , INSERT_TIME
             , UPDATE_ID
             , UPDATE_TIME
             )
        SELECT B.INSTANCE_ID
             , B.PLAN_ID
             , A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
   , A.LINE_ID
             , A.EQUIPMENT_ID
             , A.OFF_TYPE_ID
             , A.OFF_START_TIME
             , A.OFF_END_TIME
    , A.REPEAT_ID
             , A.REPEAT_FLAG
             , A.WORK_CENTER_ID
             , A.DESCRIPTION
             , @v_proc_name   AS INSERT_ID
             , GETDATE()      AS INSERT_TIME
             , @v_proc_name   AS UPDATE_ID
             , GETDATE()      AS UPDATE_TIME
        FROM   SCM_OFF_CALENDAR_M A
             , SCM_FP_PLAN_H B
        WHERE  A.OFF_START_TIME >= B.PLAN_START_TIME
        AND    A.OFF_END_TIME   < (B.PLAN_START_TIME+B.PLAN_HORIZON)
        AND    B.INSTANCE_ID    = @v_instance_id
        AND    B.PLAN_ID        = @v_plan_id
        
        SET @v_descr = 'SCM_LOSS_CALENDAR_M INSERT :'+CONVERT(nvarchar,@@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'INSERT', @n_log_count, null, @v_descr, null
      END
*/
      
    -- ================================================
    -- 로직 추가 end
    -- ================================================
    

	  --====  릴리즈 프로시저 실행 ===---
	    -- RELEASE
	    
    
  	  IF @V_PLAN_FLAG_DESCR = 'PLANING' AND	  
	       (
        -- KOR --------------------------------------------------------------------
             @v_instance_id = 'KR_E_POST'     OR @v_instance_id = 'KR_E_POST_A'
                                              OR @v_instance_id = 'KR_E_POST_M'
        -- CHN --------------------------------------------------------------------

          OR @v_instance_id = 'CN_E_POST'
        -- USA --------------------------------------------------------------------
          OR @v_instance_id = 'US_E_POST'
        -- POL --------------------------------------------------------------------
          OR @v_instance_id = 'PL_E_POST'
           )
      BEGIN        

	    ---- 릴리즈 상태 체크용 ---
		DELETE  TH_BUF_EPOST_RELEASE_STATUS
		WHERE   FP_PLAN_ID  = @V_PLAN_ID
		AND     INSTANCE_ID = @v_instance_id ; 

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
		WHERE A.INSTANCE_ID  =  @v_instance_id
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
		EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	


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
				AND    A.INSTANCE_ID  =  @v_instance_id
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

			--- 프로시저 실행. --shift 후고정말고 이전 버전으로 돌리기 위해 20211102 cys
			--EXECUTE  PR_SCM_RF_RESCHEDULE_FP_AMEND_POST  @C_RELEASE$INSTANCE , @C_RELEASE$PLAN_ID , @C_RELEASE$FACTORY 
			EXECUTE  PR_SCM_RF_RESCHEDULE_FP_AMEND_POST_NOSHIFT  @C_RELEASE$INSTANCE , @C_RELEASE$PLAN_ID , @C_RELEASE$FACTORY


			--LOG 생성
			SET @v_message =  @C_RELEASE$FACTORY
			SET @v_descr   = 'RELEASED FACTORY'
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'DONE', @n_log_count, null, @v_message, @v_descr	


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
		EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	

		
	  END  -- RELEASE 
	  	    
--  	  END  -- PLANNING 
  
  	  
	  --====  당일실적 생성 프로시저 ===-- (20190829)

	  EXEC PR_SCM_ELEC_POST_RT_RESULT @v_instance_id, @v_plan_id, @v_instance_date


	  --LOG 생성
      SET @v_table_name = 'FP_ELECTRODE_POST_PLAN_H'
	  SET @v_message = 'REALTIME RESULT'
	  SET @v_descr   = NULL
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_instance_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr	
      
      
      
    END

  END TRY

  BEGIN CATCH
       UPDATE FP_PLAN_STATUS_H
          SET 
             ACTIVE_FLAG = 0,
             INBOUND_FLAG=CASE WHEN INBOUND_FLAG='P' THEN 'E' ELSE INBOUND_FLAG END,
             ENGINE_FLAG=CASE WHEN ENGINE_FLAG='P' THEN 'E' ELSE ENGINE_FLAG END,
             OUTBOUND_FLAG=CASE WHEN OUTBOUND_FLAG='P' THEN 'E' ELSE OUTBOUND_FLAG END,
             DB_TRANS_FLAG=CASE WHEN DB_TRANS_FLAG='P' THEN 'E' ELSE DB_TRANS_FLAG END,
             UPDATE_ID = @v_proc_name, 
             UPDATE_TIME = sysdatetime()
       FROM FP_PLAN_STATUS_H  A
       WHERE a.INSTANCE_ID = @v_instance_id  
        AND  a.PLAN_ID = @v_plan_id

    -- 에러나도 로그는 인서트
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()
    EXEC PR_XIF_LOG @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr, @sysdate
    
    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

      IF @@TRANCOUNT > 0
         COMMIT WORK 
  END CATCH
  
  EXEC PR_XIF_LOG @v_proc_name, null, 'END',   999999, @v_temp1, '############### End of procedure ###############', null, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
