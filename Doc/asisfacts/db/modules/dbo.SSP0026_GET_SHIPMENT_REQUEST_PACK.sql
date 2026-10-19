
/*
 * PROGRAM ID   : SSP0026_GET_SHIPMENT_REQUEST_PACK
 * DESCRIPTION  : PACKER SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-10-07   KIMYONGHO		신규추가
 * 2022-02-01   SMS		        CONFIRM_DAY 부분 수정
 */
CREATE PROCEDURE [dbo].[SSP0026_GET_SHIPMENT_REQUEST_PACK]
	@p_sheet_name     NVARCHAR(10),
	@p_division_id    NVARCHAR(30),
	@p_team_id        NVARCHAR(MAX),
	@p_customer       NVARCHAR(MAX),
	@p_scm_site_id    NVARCHAR(MAX),
	@p_plant_site_id  NVARCHAR(MAX),
	@p_project_code   NVARCHAR(MAX),
	@p_item_id        NVARCHAR(4000),
	@p_from_yyyymmdd  NVARCHAR(8),
	@p_to_yyyymmdd    NVARCHAR(8),
	@p_created_by	  NVARCHAR(50),
	@debug_mode       NVARCHAR(1)='F'
	
AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	DECLARE @v_division_id					NVARCHAR(30)

	DECLARE @v_FROM_YYYYMMDD				NVARCHAR(8);
	DECLARE @v_TO_YYYYMMDD					NVARCHAR(8);

	DECLARE @MQRY_SUM						NVARCHAR(MAX);
	DECLARE @MEXEC							NVARCHAR(MAX);
	DECLARE @MDAY_QTY						NVARCHAR(MAX);

	DECLARE @P_STOCK_YYYYMMDD				NVARCHAR(8);

	DECLARE @V_SEQ							INT;


	DECLARE @P_PROGRAM_ID					NVARCHAR(MAX);

	DECLARE @v_plan_start_yyyymmdd			NVARCHAR(8);



	-- SCP FINAL PLAN INFO
	DECLARE @v_scp_plan_start_yyyymmdd		NVARCHAR(8);
	DECLARE @v_scp_plan_type				NVARCHAR(10); 
	DECLARE @v_scp_seq						INTEGER ;    


	SET	@v_division_id			= @p_division_id;  
	SET	@P_PROGRAM_ID			= 'SSP0026' 

	SET @V_FROM_YYYYMMDD		= @P_FROM_YYYYMMDD;
	SET @V_TO_YYYYMMDD			= @P_TO_YYYYMMDD;

	DECLARE @V_CNT_USR_MEASURE	INT =0;

	SET @V_CNT_USR_MEASURE = (
							SELECT COUNT(*) 
							FROM SCM_MST_TITLESET_USER   WITH(NOLOCK)
							WHERE 1=1
							AND PROGRAM_ID  =  @P_PROGRAM_ID
							AND SHEET_NAME  =  @P_SHEET_NAME 
							AND USER_ID     =  @p_created_by
						)

	
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/

	


	-- MEASURE JOIN 처리용
	IF OBJECT_ID('tempdb..#Tbl_boh') IS NOT NULL	
		DROP TABLE #Tbl_boh;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('TEMPDB..#TMP_ROWDATA') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('TEMPDB..##TMP_ROWDATA_RN') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA_RN;

	IF OBJECT_ID('TEMPDB..#TMP_ROWDATA_RN') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA_RN;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_PIVOT_TABLE_TEMP') IS NOT NULL	
		DROP TABLE #TMP_RESULT_PIVOT_TABLE_TEMP;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_PIVOT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_PIVOT_TABLE;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE;
	
	-- Requestor
	IF OBJECT_ID('tempdb..#TblDynamic_REQUESTOR') IS NOT NULL
		DROP TABLE #TblDynamic_REQUESTOR;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
		DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG;

	IF OBJECT_ID('tempdb..#TBLDYNAMICTITLEST_SSP0026') IS NOT NULL
		DROP TABLE #TBLDYNAMICTITLEST_SSP0026;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_STD') IS NOT NULL	
		DROP TABLE #TblDynamic_SSP0026_40_STD;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_FG') IS NOT NULL	
		DROP TABLE #TblDynamic_SSP0026_40_FG;

	IF OBJECT_ID('tempdb..#Z') IS NOT NULL	
		DROP TABLE #Z;

	IF OBJECT_ID('tempdb..#QTY') IS NOT NULL	
		DROP TABLE #QTY;

	IF OBJECT_ID('tempdb..#BOH') IS NOT NULL	
		DROP TABLE #BOH;

	SELECT * INTO #TBLDYNAMICTITLEST_SSP0026 
	FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
	WHERE PROGRAM_ID	= @P_PROGRAM_ID
	AND SHEET_NAME		= @P_SHEET_NAME
	AND USER_ID		= @p_created_by;
	

	SELECT @v_plan_start_yyyymmdd =  CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT(VARCHAR, ATTRIBUTE1, 121)), 112) 
	FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL]
	WHERE LOOKUP_TYPE = 'SSP_ANL_SHIP_PLAN_P'
	;


	CREATE TABLE #TMP_RESULT_TABLE
	(
		  DIVISION_ID		NVARCHAR(10)
	--	, MODEL_TYPE		NVARCHAR(10)
		, ITEM_ID			NVARCHAR(50)
		, FROM_SITE			NVARCHAR(30)
		, TO_SITE			NVARCHAR(30)
		, MEASURE			NVARCHAR(50)
		, YYYYMMDD			NVARCHAR(8)
		, BOD_ID			NVARCHAR(30)
		, QTY				NUMERIC(20, 10)
		, INCOTERMS			NVARCHAR(50)
		, TRANSPORT_MODE	NVARCHAR(50)
		, FCST_TYPE			NVARCHAR(50)
		, SEQ				INT
	);

	CREATE TABLE #TMP_ROWDATA
	(
		DIVISION_ID			NVARCHAR(10) --INDEX VIX_TMP_ROWDATA_01 (MEASURE, YYYYMMDD, DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, BOD_ID)		
	   ,ITEM_ID				NVARCHAR(50) INDEX VIX_TMP_ROWDATA_01(DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE,MEASURE, YYYYMMDD, BOD_ID) 
	   ,FROM_SITE			NVARCHAR(30)
	   ,TO_SITE				NVARCHAR(30)
	   ,MEASURE				NVARCHAR(50)
	   ,YYYYMMDD			NVARCHAR(8)
	   ,BOD_ID				NVARCHAR(30)
	   ,QTY					NUMERIC(20, 10)
	   ,INCOTERMS			NVARCHAR(50)
	   ,TRANSPORT_MODE		NVARCHAR(50)
	   ,FCST_TYPE			NVARCHAR(50)
	   ,SEQ					INT
	   ,LAST_UPDATED_BY		NVARCHAR(50)
	   ,LAST_UPDATE_DATE	NVARCHAR(MAX)
	   ,REMARK				NVARCHAR(MAX)
	);

	CREATE TABLE #Z   
	(
		[DIVISION_ID]		[nvarchar](30)  INDEX VIX_Z_01 CLUSTERED(DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD) 
	   ,[ITEM_ID]			[nvarchar](150)
	   ,[FROM_SITE]			[nvarchar](30)
	   ,[YYYYMMDD]          [nvarchar](8) 
	);

	CREATE TABLE #QTY   
	(
		[DIVISION_ID]		[nvarchar](30)  INDEX VIX_QTY_01 CLUSTERED(DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD)
	   ,[ITEM_ID]			[nvarchar](150)
	   ,[FROM_SITE]			[nvarchar](30)
	   ,[YYYYMMDD]          [nvarchar](8)
	   ,[PLAN_QTY]          numeric(20, 10)
	   ,[REQ_QTY]           numeric(20, 10)
	);

	CREATE TABLE #BOH   
	(
		[DIVISION_ID]		[nvarchar](30)  INDEX VIX_BOH_01 CLUSTERED(DIVISION_ID, ITEM_ID, FROM_SITE)
	   ,[ITEM_ID]			[nvarchar](150)
	   ,[FROM_SITE]			[nvarchar](30)
	   ,[YYYYMMDD]          [nvarchar](8)
	   ,[QTY]               numeric(20, 10)
	);


	SELECT TOP 1 
		   @v_scp_plan_start_yyyymmdd = A.PLAN_START_YYYYMMDD 
	      ,@v_scp_plan_type           = A.PLAN_TYPE 
	      ,@v_scp_seq                 = A.PLAN_SEQ   
	  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK) 
	 WHERE 1 = 1 
	   AND A.DIVISION_ID	= @v_division_id
	   AND A.PLAN_CYCLE		= 'WEEKLY'
	   AND A.PLAN_TYPE		= 'FN'
	ORDER BY 
	      PLAN_START_YYYYMMDD DESC 
	    , PLAN_TYPE_ORDER DESC 
		, PLAN_SEQ DESC 
    ;
    
	--IF @P_REAL_FLAG = 'Y'  -- 현재 기준 조회
	 
	BEGIN

		SELECT  DIVISION_ID                        
	      , PLAN_START_YYYYMMDD                        
	      , PLAN_TYPE                 
	      , SEQ                        
	      , MAX(OPERATION_GROUP)     AS BIZ_TYPE                                 
	      , '-' AS FCST_TYPE--FCST_TYPE
	      , ITEM_ID                        
	      , TO_SITE                        
	      -- , INCOTERMS                        
	      , FROM_SITE                        
	      , BOD_ID                        
	      , TRANSPORT_MODE                        
	      , MEASURE                        
	      , YYYYMMDD                         
	      , SUM(QTY) AS QTY                                             
	      , LAST_UPDATED_BY
	      , LAST_UPDATE_DATE
	  INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG
	  FROM (
			SELECT A.DIVISION_ID                        
				,  A.PLAN_START_YYYYMMDD                     
				,  A.PLAN_TYPE                        
				,  A.SEQ                          
				,  A.OPERATION_GROUP                        
				,  '-' FCST_TYPE--D.FCST_TYPE                        
				,  A.ITEM_ID                        
				,  A.TO_SITE                    		
				,  A.FROM_SITE                        
				,  A.BOD_ID                         
				,  A.TRANSPORT_MODE                        
				,  A.MEASURE                 
				,  A.YYYYMMDD                        
				,  D.ALLOCATION_QTY         AS QTY 
				,  REPLACE(A.LAST_UPDATED_BY,'scp_batch','System') as LAST_UPDATED_BY
				,  A.LAST_UPDATE_DATE
			FROM SCP_PLN_SHIPMENT_PLAN A WITH (NOLOCK, index(IX04_SCP_PLN_SHIPMENT_PLAN))
			
			INNER JOIN SCP_PLN_SHIPMENT_PLAN_PEGGING D WITH (NOLOCK)           
				ON 1 = 1
					AND A.MASTER_ID				= D.MASTER_ID
					AND A.PLAN_ID				= D.PLAN_ID
					AND A.OUT_VERSION_ID		= D.OUT_VERSION_ID
					AND A.DIVISION_ID           = D.DIVISION_ID     
					AND A.PLAN_START_YYYYMMDD   = D.PLAN_START_YYYYMMDD                
					AND A.PLAN_TYPE             = D.PLAN_TYPE   
					AND A.SEQ                   = D.SEQ      
					AND A.ORDER_ID              = D.ORDER_ID 	
			
				JOIN SCM_MST_SITE  B WITH(NOLOCK)
					ON   B.SITE_TYPE = 'PLANT'
					AND  B.VALID_YN = 'Y'
					AND  B.OSP_YN   = 'Y'
					AND  B.OPERATION_GROUP = 'P'
					AND  A.DIVISION_ID = B.DIVISION_ID
					AND  A.FROM_SITE   = B.SCM_SITE_ID
				
				JOIN SCM_MST_SITE  C WITH(NOLOCK)
					ON   C.SITE_TYPE = 'SALES'
					AND  C.VALID_YN = 'Y'
					AND  A.DIVISION_ID = C.DIVISION_ID
					AND  A.TO_SITE     = C.SCM_SITE_ID
				
				JOIN SCP_MST_BOD_N_V   E WITH(NOLOCK)
					ON   E.DIVISION_ID = A.DIVISION_ID
					AND  E.BOD_ID      = A.BOD_ID

			WHERE 1 = 1
				AND A.DIVISION_ID			   = @v_division_id
				AND A.PLAN_START_YYYYMMDD	   = @v_scp_plan_start_yyyymmdd                    
				AND A.PLAN_TYPE				   = @v_scp_plan_type
				AND A.SEQ					   = @v_scp_seq
				AND A.MEASURE                  ='SHIP_PLAN'			  
				AND A.YYYYMMDD			   >= @v_from_yyyymmdd
				AND A.YYYYMMDD			   <= @v_to_yyyymmdd
				AND (( @p_item_id		  IS NULL OR @p_item_id ='')		   OR A.ITEM_ID				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_item_id , ','))) 
				AND (( @P_plant_site_id   IS NULL OR @P_plant_site_id ='')	   OR A.FROM_SITE			  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_plant_site_id , ',')))   		
				AND (( @P_scm_site_id     IS NULL OR @P_scm_site_id ='')	   OR A.TO_SITE				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_scm_site_id , ',')))
				AND (( @P_customer        IS NULL OR @P_customer ='')		   OR C.SOLDTO_CUSTOMER		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_customer , ','))) 		

		) X                        
			GROUP BY DIVISION_ID                        
					, PLAN_START_YYYYMMDD                        
					, PLAN_TYPE                
					, SEQ                           
				--	, FCST_TYPE              
					, ITEM_ID                        
					, TO_SITE                        
				--  , INCOTERMS                        
					, FROM_SITE                        
					, TRANSPORT_MODE                        
					, BOD_ID                        
					, MEASURE                        
					, YYYYMMDD 
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
		;

		/*SCP_SHIP_PLAN Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT A.DIVISION_ID												
			, A.ITEM_ID													
			, A.FROM_SITE 
			, A.TO_SITE
			, 'SCP_SHIP_PLAN' AS MEASURE
			, A.YYYYMMDD
			, A.BOD_ID
			, A.QTY
			, C.SSP_INCOTERMS AS INCOTERMS
			, C.TRANSPORT_MODE
			--, ISNULL(A.FCST_TYPE,'') AS FCST_TYPE
			, '-' AS FCST_TYPE
			, 1 AS SEQ
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, '-' AS REMARK
		FROM  #TMP_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK) 	
		--LEFT OUTER JOIN SCP_MST_BOD_V  C WITH(NOLOCK)
		LEFT OUTER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
				ON   C.DIVISION_ID		   = A.DIVISION_ID                        
				AND  C.BOD_ID			   = A.BOD_ID
				AND  C.DIVISION_ID		   = @v_division_id
				AND  C.BOD_TYPE			   = 'SALES'
		WHERE A.DIVISION_ID			= @v_division_id			
		AND A.MEASURE				= 'SHIP_PLAN'          
		;


		/*SHIP_REQ Meausre 생성*/
		INSERT INTO #TMP_ROWDATA 
		SELECT A.DIVISION_ID
			, A.ITEM_ID			AS ITEM_ID
			, C.FROM_SITE		AS FROM_SITE
			, C.TO_SITE			AS TO_SITE	
			, 'SHIP_REQ'		AS MEASURE
			, A.YYYYMMDD
			, A.BOD_ID
			, A.QTY
			, C.INCOTERMS
			, C.TRANSPORT_MODE
			, A.FCST_TYPE
			, 2 AS SEQ
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, '-'  AS REMARK
		FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
		
		LEFT OUTER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
				ON   C.DIVISION_ID		   = A.DIVISION_ID                        
				AND  C.BOD_ID			   = A.BOD_ID
				AND  C.DIVISION_ID		   = @v_division_id
				AND  C.BOD_TYPE			   = 'SALES'

		JOIN SCM_MST_SITE  B WITH(NOLOCK)
					ON   B.SITE_TYPE = 'SALES'
					AND  B.VALID_YN = 'Y'
					AND  A.DIVISION_ID = B.DIVISION_ID
					AND  C.TO_SITE     = B.SCM_SITE_ID

		WHERE 1 = 1
		AND A.DIVISION_ID		 = @v_division_id 
		AND A.YYYYMMDD			 >= @v_from_yyyymmdd
		AND A.YYYYMMDD			 <= @v_to_yyyymmdd
		AND A.QTY > 0 
		AND (( @p_item_id		  IS NULL OR @p_item_id ='')		   OR A.ITEM_ID				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_item_id , ','))) 
		AND (( @P_plant_site_id   IS NULL OR @P_plant_site_id ='')	   OR C.FROM_SITE			  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_plant_site_id , ',')))   		
		AND (( @P_scm_site_id     IS NULL OR @P_scm_site_id ='')	   OR C.TO_SITE				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_scm_site_id , ',')))
		AND (( @P_customer        IS NULL OR @P_customer ='')		   OR B.SOLDTO_CUSTOMER		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_customer , ','))) 	
		;



		/*SHIP_PLAN Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT A.DIVISION_ID												
			, A.ITEM_ID													
			, A.SCM_SITE_ID 
			, A.TO_SITE
			, 'SHIP_PLAN' AS MEASURE
			, A.SHIP_DATE AS YYYYMMDD
			, V.BOD_ID AS BOD_ID
			, A.SHIP_QTY
			, ISNULL(C.INCOTERMS,V.INCOTERMS) AS INCOTERMS
			, ISNULL(C.TRANSPORT_MODE, V.TRANSPORT_MODE) AS TRANSPORT_MODE
			, '-' AS FCST_TYPE
			, 3 AS SEQ
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, '-' AS REMARK
		FROM  SCM_DNM_SCS_SHIP_RESULT A WITH(NOLOCK) 	
		--JOIN (
		--	SELECT DIVISION_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE, PACK_MODEL_CODE, SCM_SITE_ID
		--	FROM [DBO].[SCM_DNM_SCS_SHIP_RESULT]
		--	GROUP BY DIVISION_ID, PACK_MODEL_CODE, SCM_SITE_ID
		--) B
		--ON A.DIVISION_ID = B.DIVISION_ID AND A.CUTOFF_DATE = B.CUTOFF_DATE AND A.PACK_MODEL_CODE = B.PACK_MODEL_CODE 

		-- 임시로 Confirm ID만 존재하는 실적 대상
		 --SCS I/F INCOTERS, TRANS MODE, FCST TYPE 추가 되면 JOIN 해제
		LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
			ON A.ATTRIBUTE5 = C.CONFIRM_ID

		LEFT OUTER JOIN SCP_MST_BOD_N_V V WITH(NOLOCK)
			ON A.SCM_SITE_ID = V.FROM_SITE
			AND A.TO_SITE	 = V.TO_SITE
			AND A.ATTRIBUTE8 = V.TRANSPORT_MODE
			AND A.ATTRIBUTE9 = V.INCOTERMS
		
		WHERE A.DIVISION_ID	= @v_division_id
		AND  A.SHIP_DATE  >= @v_from_yyyymmdd
		AND  A.SHIP_DATE  <= @v_to_yyyymmdd					
		AND  A.SHIP_QTY > 0	
		--AND  A.ATTRIBUTE8 IS NOT NULL
		--AND  A.ATTRIBUTE9 IS NOT NULL

		
		;

		/*PACK_FP Meausre 생성*/

		INSERT INTO #TMP_ROWDATA 
		SELECT A.DIVISION_ID
			, A.ITEM_ID
			, A.SCM_SITE_ID AS FROM_SITE
			, '-' AS TO_SITE
			, 'PACK_FP'	AS MEASURE
			, A.PROD_DATE	AS YYYYMMDD
			, '-'			AS BOD_ID
			, SUM( ISNULL(A.PROD_QTY, 0) )   AS QTY
			, '-'			AS INCOTERMS
			, '-'			AS TRANSPORT_MODE
			, '-'			AS FCST_TYPE
			, 4				AS SEQ
			, '-'			AS LAST_UPDATED_BY
			, '-'			AS LAST_UPDATE_DATE
			, '-'			AS REMARK
		FROM   SCM_DNM_SCS_PROD_PLAN  A WITH(NOLOCK)
		JOIN (
			SELECT DIVISION_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE, PACK_MODEL_CODE, SCM_SITE_ID
			FROM [DBO].[SCM_DNM_SCS_PROD_PLAN]
			GROUP BY DIVISION_ID, PACK_MODEL_CODE, SCM_SITE_ID
		) B
		ON A.DIVISION_ID = B.DIVISION_ID AND A.CUTOFF_DATE = B.CUTOFF_DATE AND A.PACK_MODEL_CODE = B.PACK_MODEL_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID
		JOIN SCM_MST_SITE  C WITH(NOLOCK)
			ON   C.SITE_TYPE = 'PLANT'
			AND  C.VALID_YN = 'Y'
			AND  C.OSP_YN   = 'Y'
			AND  C.OPERATION_GROUP = 'P'
			AND  C.DIVISION_ID = A.DIVISION_ID
			AND  C.SCM_SITE_ID = A.SCM_SITE_ID
	
		WHERE  A.DIVISION_ID = @p_division_id
			--AND  A.CUTOFF_DATE = CONVERT(CHAR(8), GETDATE(), 112)
			AND  A.PROD_DATE  >= @v_from_yyyymmdd
			AND  A.PROD_DATE  <= @v_to_yyyymmdd										 
		
		GROUP BY A.DIVISION_ID
			, A.SCM_SITE_ID	
			, A.ITEM_ID
			, A.PROD_DATE



		/*TOTAL_PLAN Meausre 생성*/
		INSERT INTO #TMP_ROWDATA 
		SELECT A.DIVISION_ID
			, A.ITEM_ID
			, A.SCM_SITE_ID AS FROM_SITE
			, '-'			AS TO_SITE
			, 'TOTAL_PLAN'	AS MEASURE
			, A.SHIP_DATE	AS YYYYMMDD
			, '-'			AS BOD_ID
			, SUM(ISNULL(A.SHIP_QTY, 0) )   AS QTY
			, '-'			AS INCOTERMS
			, '-'			AS TRANSPORT_MODE
			, '-'			AS FCST_TYPE
			, 5				AS SEQ
			, '-'			AS LAST_UPDATED_BY
			, '-'			AS LAST_UPDATE_DATE
			, '-'  AS REMARK
		FROM   SCM_DNM_SCS_SHIP_RESULT  A WITH(NOLOCK)
		--JOIN (
		--		SELECT DIVISION_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE, PACK_MODEL_CODE, SCM_SITE_ID
		--		FROM [DBO].[SCM_DNM_SCS_SHIP_RESULT]
		--		GROUP BY DIVISION_ID, PACK_MODEL_CODE, SCM_SITE_ID
		--	) B
		--	ON A.DIVISION_ID = B.DIVISION_ID AND A.CUTOFF_DATE = B.CUTOFF_DATE AND A.PACK_MODEL_CODE = B.PACK_MODEL_CODE 
		JOIN (
				SELECT A.SCM_SITE_ID, B.SOLDTO_CODE, B.SHIPTO_CODE
				FROM   SCM_MST_SITE   A WITH(NOLOCK)
						JOIN SCM_MST_SITE_CUSTOMER  B WITH(NOLOCK)
						ON   B.DIVISION_ID = @v_division_id
						AND  B.VALID_YN = 'Y'
						AND  B.REP_YN = 'Y'
						AND  B.DIVISION_ID = A.DIVISION_ID
						AND  B.SCM_SITE_ID = A.SCM_SITE_ID
				WHERE  1 = 1
				AND    A.DIVISION_ID = @v_division_id
				AND    A.SITE_TYPE ='SALES'
				AND    A.VALID_YN = 'Y'
				) C
			ON   C.SCM_SITE_ID = A.TO_SITE
		JOIN SSP_ANL_SHIP_CONFIRM D WITH(NOLOCK)
			ON A.ATTRIBUTE5 = D.CONFIRM_ID

		WHERE  A.DIVISION_ID = @v_division_id
		--AND    B.CUTOFF_DATE >= @v_plan_start_date
		--AND    B.CUTOFF_DATE <= @v_cutoff_end_date
		AND    A.SHIP_DATE >= @v_from_yyyymmdd
		AND    A.SHIP_DATE <= @v_to_yyyymmdd												 
		GROUP BY A.DIVISION_ID
			, A.SCM_SITE_ID
			, A.ITEM_ID
			, A.SHIP_DATE



		/*TOTAL_REQ Meausre 생성*/
		INSERT INTO #TMP_ROWDATA 
		SELECT A.DIVISION_ID
			, A.ITEM_ID			AS ITEM_ID
			, C.FROM_SITE		AS FROM_SITE
			, '-'				AS TO_SITE	
			, 'TOTAL_REQ'		AS MEASURE
			, A.YYYYMMDD
			, '-'				AS BOD_ID
			, SUM(A.QTY)		AS QTY
			, '-'				AS INCOTERMS
			, '-'				AS TRANSPORT_MODE
			, '-'				AS FCST_TYPE
			, 6					AS SEQ
			, '-'				AS LAST_UPDATED_BY
			, '-'				AS LAST_UPDATE_DATE
			, '-'  AS REMARK
		FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)

		INNER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
				ON   C.DIVISION_ID		   = A.DIVISION_ID                        
				AND  C.BOD_ID			   = A.BOD_ID
				AND  C.DIVISION_ID		   = @v_division_id
				AND  C.BOD_TYPE			   = 'SALES'

		INNER JOIN SCM_MST_SITE  B WITH(NOLOCK)
					ON   B.SITE_TYPE = 'SALES'
					AND  B.VALID_YN = 'Y'
					AND  A.DIVISION_ID = B.DIVISION_ID
					AND  C.TO_SITE     = B.SCM_SITE_ID
					
		

		WHERE 1 = 1
		AND A.DIVISION_ID		 = @v_division_id 
		AND A.YYYYMMDD			 >= @v_from_yyyymmdd
		AND A.YYYYMMDD			 <= @v_to_yyyymmdd
		AND A.QTY > 0 
		AND (( @p_item_id		  IS NULL OR @p_item_id ='')		   OR A.ITEM_ID				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_item_id , ','))) 
		AND (( @P_plant_site_id   IS NULL OR @P_plant_site_id ='')	   OR C.FROM_SITE			  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_plant_site_id , ',')))   		
		AND (( @P_scm_site_id     IS NULL OR @P_scm_site_id ='')	   OR C.TO_SITE				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_scm_site_id , ',')))
		AND (( @P_customer        IS NULL OR @P_customer ='')		   OR B.SOLDTO_CUSTOMER		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_customer , ','))) 	

		GROUP BY A.DIVISION_ID,  A.ITEM_ID, C.FROM_SITE, A.YYYYMMDD, A.BOD_ID
		;



		/*WH_BOH_PLAN Meausre 생성*/
		INSERT INTO #TMP_ROWDATA 
		SELECT    A.DIVISION_ID
				, A.ITEM_ID		AS ITEM_ID
				, A.FROM_SITE	AS FROM_SITE
				, '-'			AS TO_SITE
				, 'WH_BOH_PLAN'	AS MEASURE
				, A.YYYYMMDD	AS YYYYMMDD
				, '-'			AS BOD_ID
				, SUM(CASE WHEN C.MEASURE = 'TOTAL_PLAN' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0  -- @p_from_yyyymmdd
							WHEN C.MEASURE = 'TOTAL_PLAN' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) THEN -1 * ISNULL(C.QTY,0)  -- @p_from_yyyymmdd
							WHEN C.MEASURE <> 'TOTAL_PLAN' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0
							WHEN C.MEASURE <> 'TOTAL_PLAN' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) AND C.YYYYMMDD < A.YYYYMMDD THEN ISNULL(C.QTY, 0)
					ELSE 0 END) + ISNULL(B.STOCK_QTY, 0) AS QTY							
				, '-'			AS INCOTERMS
				, '-'			AS TRANSPORT_MODE
				, '-'			AS FCST_TYPE
				, 7				AS SEQ
				, '-'			AS LAST_UPDATED_BY
				, '-'			AS LAST_UPDATE_DATE
				, '-'			AS REMARK		
								
		FROM   (
				SELECT B.DIVISION_ID
						, B.ITEM_ID
						, B.FROM_SITE
						, A.BASIS_YYYYMMDD AS YYYYMMDD
				FROM   SCM_SYS_CALENDAR_M  A WITH(NOLOCK)
						CROSS APPLY (
									SELECT A.DIVISION_ID
											, A.ITEM_ID
											, A.FROM_SITE
									FROM   #TMP_ROWDATA  A WITH(NOLOCK)
									WHERE  1 = 1
									AND    A.DIVISION_ID = @p_division_id
									AND    A.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
									AND    A.YYYYMMDD <= @p_to_yyyymmdd
									AND    A.MEASURE   IN ('TOTAL_PLAN', 'PACK_FP')
									GROUP BY A.DIVISION_ID
											, A.ITEM_ID
											, A.FROM_SITE
									) B
				WHERE  1 = 1
				AND    A.BASIS_YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
				AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
				) A
				LEFT OUTER JOIN (
								SELECT DIVISION_ID
										, SCM_SITE_ID     AS FROM_SITE
										, ITEM_ID         AS ITEM_ID
										, STOCK_DATE      AS YYYYMMDD
										, SUM(ISNULL(STOCK_QTY, 0))  AS STOCK_QTY
								FROM   SCM_DNM_SCS_STOCK A (NOLOCK)
								WHERE  1 = 1
								AND    DIVISION_ID = @p_division_id
								AND    CUTOFF_DATE = CONVERT(NVARCHAR(8), GETDATE()-1, 112)
								--AND    STOCK_DATE >= @v_plan_start_date
								--AND    STOCK_DATE <= @v_plan_end_date
								AND    CELL_PACK   = 'P'
								GROUP BY DIVISION_ID
										, SCM_SITE_ID
										, ITEM_ID
										, STOCK_DATE
								) B
				ON   A.DIVISION_ID		= B.DIVISION_ID
				AND  A.ITEM_ID			= B.ITEM_ID
				AND  A.FROM_SITE		= B.FROM_SITE
				LEFT OUTER JOIN (
								SELECT A.DIVISION_ID
										, A.ITEM_ID
										, A.FROM_SITE
										, A.YYYYMMDD
										, A.MEASURE
										, A.QTY
								FROM   #TMP_ROWDATA  A WITH(NOLOCK)
								WHERE  1 = 1
								AND    A.DIVISION_ID = @p_division_id
								AND    A.YYYYMMDD >= @v_plan_start_yyyymmdd--CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
								AND    A.YYYYMMDD <= @p_to_yyyymmdd
								AND    A.MEASURE   IN ('TOTAL_PLAN', 'PACK_FP')
								) C
				ON   C.DIVISION_ID = A.DIVISION_ID 
				AND  C.ITEM_ID     = A.ITEM_ID 
				AND  C.YYYYMMDD   <= A.YYYYMMDD 
				AND  C.FROM_SITE   = A.FROM_SITE
		WHERE  1 = 1
		GROUP BY A.DIVISION_ID
				, A.ITEM_ID
				, A.FROM_SITE
				, A.YYYYMMDD
				, B.STOCK_QTY


		
		/*WH_BOH_REQ Meausre 생성*/
		INSERT INTO #TMP_ROWDATA 
		SELECT    A.DIVISION_ID
				, A.ITEM_ID		AS ITEM_ID
				, A.FROM_SITE	AS FROM_SITE
				, '-'			AS TO_SITE
				, 'WH_BOH_REQ'	AS MEASURE
				, A.YYYYMMDD	AS YYYYMMDD
				, '-'			AS BOD_ID
				, SUM(CASE WHEN C.MEASURE = 'TOTAL_REQ' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0  -- @p_from_yyyymmdd
							WHEN C.MEASURE = 'TOTAL_REQ' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) THEN -1 * ISNULL(C.QTY,0)  -- @p_from_yyyymmdd
							WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0
							WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) AND C.YYYYMMDD < A.YYYYMMDD THEN ISNULL(C.QTY, 0)
					ELSE 0 END) + ISNULL(B.STOCK_QTY, 0) AS QTY							
				, '-'			AS INCOTERMS
				, '-'			AS TRANSPORT_MODE
				, '-'			AS FCST_TYPE
				, 8				AS SEQ
				, '-'			AS LAST_UPDATED_BY
				, '-'			AS LAST_UPDATE_DATE
				, '-'			AS REMARK		
								
		FROM   (
				SELECT B.DIVISION_ID
						, B.ITEM_ID
						, B.FROM_SITE
						, A.BASIS_YYYYMMDD AS YYYYMMDD
				FROM   SCM_SYS_CALENDAR_M  A WITH(NOLOCK)
						CROSS APPLY (
									SELECT A.DIVISION_ID
											, A.ITEM_ID
											, A.FROM_SITE
									FROM   #TMP_ROWDATA  A WITH(NOLOCK)
									WHERE  1 = 1
									AND    A.DIVISION_ID = @p_division_id
									AND    A.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
									AND    A.YYYYMMDD <= @p_to_yyyymmdd
									AND    A.MEASURE   IN ('TOTAL_REQ', 'PACK_FP')
									GROUP BY A.DIVISION_ID
											, A.ITEM_ID
											, A.FROM_SITE
									) B
				WHERE  1 = 1
				AND    A.BASIS_YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
				AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
				) A
				LEFT OUTER JOIN (
								SELECT DIVISION_ID
										, SCM_SITE_ID     AS FROM_SITE
										, ITEM_ID         AS ITEM_ID
										, STOCK_DATE      AS YYYYMMDD
										, SUM(ISNULL(STOCK_QTY, 0))  AS STOCK_QTY
								FROM   SCM_DNM_SCS_STOCK A (NOLOCK)
								WHERE  1 = 1
								AND    DIVISION_ID = @p_division_id
								AND    CUTOFF_DATE = CONVERT(NVARCHAR(8), GETDATE()-1, 112)
								--AND    STOCK_DATE >= @v_plan_start_date
								--AND    STOCK_DATE <= @v_plan_end_date
								AND    CELL_PACK   = 'P'
								GROUP BY DIVISION_ID
										, SCM_SITE_ID
										, ITEM_ID
										, STOCK_DATE
								) B
				ON   A.DIVISION_ID		= B.DIVISION_ID
				AND  A.ITEM_ID			= B.ITEM_ID
				AND  A.FROM_SITE		= B.FROM_SITE
				LEFT OUTER JOIN (
								SELECT A.DIVISION_ID
										, A.ITEM_ID
										, A.FROM_SITE
										, A.YYYYMMDD
										, A.MEASURE
										, A.QTY
								FROM   #TMP_ROWDATA  A WITH(NOLOCK)
								WHERE  1 = 1
								AND    A.DIVISION_ID = @p_division_id
								AND    A.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
								AND    A.YYYYMMDD <= @p_to_yyyymmdd
								AND    A.MEASURE   IN ('TOTAL_REQ', 'PACK_FP')
								) C
				ON   C.DIVISION_ID = A.DIVISION_ID 
				AND  C.ITEM_ID     = A.ITEM_ID 
				AND  C.YYYYMMDD   <= A.YYYYMMDD 
				AND  C.FROM_SITE   = A.FROM_SITE
		WHERE  1 = 1
		GROUP BY A.DIVISION_ID
				, A.ITEM_ID
				, A.FROM_SITE
				, A.YYYYMMDD
				, B.STOCK_QTY



		

			
		
			SELECT T0.DIVISION_ID
			,	  T0.ITEM_ID
			,	  T0.FROM_SITE
			,	  T0.TO_SITE
			,     T0.MEASURE
			,	  T0.YYYYMMDD
			,	  T0.BOD_ID
			,	  T0.QTY
			,	  T0.INCOTERMS
			,	  T0.TRANSPORT_MODE
			,	  T0.FCST_TYPE		
			,	  T0.LAST_UPDATED_BY
			,	  RANK() OVER(PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE, T0.BOD_ID ORDER BY T0.ITEM_ID DESC , T0.LAST_UPDATE_DATE ) AS RN
			INTO #TMP_ROWDATA_RN
			FROM 
			(		
					SELECT *
					FROM  #TMP_ROWDATA A WITH(NOLOCK)         
					
					  
			) T0
			WHERE 1 = 1
			GROUP BY T0.DIVISION_ID		
			,	  T0.ITEM_ID
			,	  T0.FROM_SITE
			,	  T0.TO_SITE
			,     T0.MEASURE
			,	  T0.YYYYMMDD
			,	  T0.BOD_ID
			,	  T0.QTY
			,	  T0.INCOTERMS
			,	  T0.TRANSPORT_MODE
			,	  T0.FCST_TYPE	
			,	  T0.LAST_UPDATED_BY
			,	  T0.LAST_UPDATE_DATE
			;



			INSERT INTO #TMP_RESULT_TABLE
			(
				DIVISION_ID
			--	,MODEL_TYPE
				,ITEM_ID
				,FROM_SITE
				,TO_SITE
				,MEASURE
				,YYYYMMDD
				,BOD_ID
				,QTY
				,INCOTERMS
				,TRANSPORT_MODE
				,FCST_TYPE
				,SEQ
			)
			SELECT DISTINCT 
				  X.DIVISION_ID
				--, X.MODEL_TYPE
				, X.ITEM_ID
				, X.FROM_SITE
				, X.TO_SITE AS TO_SITE
				, X.MEASURE
				, X.YYYYMMDD

				,'-' AS BOD_ID
				,ISNULL(R.QTY,0) AS QTY
				,'-' AS INCOTERMS
				,'-' AS TRANSPORT_MODE
				,'-' AS FCST_TYPE

				--,ISNULL(X.BOD_ID,'-') AS BOD_ID
				--,ISNULL(R.QTY,0) AS QTY
				--,ISNULL(X.INCOTERMS,'-') AS INCOTERMS
				--,ISNULL(X.TRANSPORT_MODE,'-') AS TRANSPORT_MODE
				--,ISNULL(X.FCST_TYPE,'-') AS FCST_TYPE
				,X.SEQ
			FROM  
			(
				    SELECT DISTINCT T.DIVISION_ID 
				 --   ,	 T.MODEL_TYPE
				    ,    T.ITEM_ID				 AS ITEM_ID
				    --,	 ISNULL(T.FROM_SITE,'-') AS FROM_SITE
				    --,	 ISNULL(T.TO_SITE,'-') AS TO_SITE
					,	 '-' AS FROM_SITE
				    ,	 '-' AS TO_SITE
				    --,	 '-' AS TO_SITE
				    ,	 T.BOD_ID
				    ,	 T.QTY
				    ,	 T.INCOTERMS
				    ,	 T.TRANSPORT_MODE
				    ,	 T.FCST_TYPE
				    ,     TT1.COLUMN_NAME		 AS MEASURE 
				    ,	 TT1.COLUMN_LABEL_NAME	 AS MEASURE_NAME																									
				    ,	 TT1.ATTRIBUTE3		 AS BACK_COLOR							
				    ,	 TT1.SORT_ORDER_NO		 AS SEQ
				    ,      T.YYYYMMDD				  
				    FROM  #TMP_ROWDATA T				 
				    INNER JOIN SCM_MST_SHEET_MEASURE TT1 WITH(NOLOCK)
				       ON TT1.PROGRAM_ID = @P_PROGRAM_ID
						AND TT1.SHEET_NAME = @P_SHEET_NAME	
					LEFT OUTER JOIN SCM_MST_TITLESET_USER T3 WITH(NOLOCK)                                                                                       
						ON T3.PROGRAM_ID = TT1.PROGRAM_ID                                                                                                       
						AND T3.SHEET_NAME = TT1.SHEET_NAME                                                                                                      
						AND T3.COLUMN_NAME = TT1.COLUMN_NAME                                                                                                    
						AND T3.USER_ID =  @p_created_by    
			) X
			LEFT OUTER JOIN  #TMP_ROWDATA R  
				ON R.DIVISION_ID		= X.DIVISION_ID
				AND R.ITEM_ID			= X.ITEM_ID
				AND R.MEASURE			= X.MEASURE
				AND R.YYYYMMDD			= X.YYYYMMDD
			WHERE ( X.TO_SITE = '-'	AND  X.MEASURE IN (	'WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','PACK_FP') )
			--WHERE ( X.TO_SITE = '-'	AND  X.MEASURE IN (	'WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','PACK_FP') )
			 

				
			UNION ALL

			SELECT DISTINCT 
				  X.DIVISION_ID
				--, X.MODEL_TYPE
				, X.ITEM_ID
				, X.FROM_SITE
				, X.TO_SITE 
				, X.MEASURE
				, X.YYYYMMDD
				,ISNULL(X.BOD_ID,'-') AS BOD_ID
				,ISNULL(R.QTY,0) AS QTY
				,ISNULL(X.INCOTERMS,'-') AS INCOTERMS
				,ISNULL(X.TRANSPORT_MODE,'-') AS TRANSPORT_MODE
				,ISNULL(X.FCST_TYPE,'-') AS FCST_TYPE
				,X.SEQ
			FROM  
			(
				    SELECT DISTINCT T.DIVISION_ID 
				--    ,	 T.MODEL_TYPE
				    ,      T.ITEM_ID
				    ,	 ISNULL(T.FROM_SITE,'-') AS FROM_SITE
				    ,	 ISNULL(T.TO_SITE,'-') AS TO_SITE
				    ,	 T.BOD_ID
				    ,	 T.QTY
				    ,	 T.INCOTERMS
				    ,	 T.TRANSPORT_MODE
				    ,	 T.FCST_TYPE
				    ,    TT1.COLUMN_NAME		 AS MEASURE 
				    ,	 TT1.COLUMN_LABEL_NAME	 AS MEASURE_NAME																									
				    ,	 TT1.ATTRIBUTE3		 AS BACK_COLOR							
				    ,	 TT1.SORT_ORDER_NO		 AS SEQ
				    ,    T.YYYYMMDD				  
				    FROM  #TMP_ROWDATA T				 
				    INNER JOIN SCM_MST_SHEET_MEASURE TT1 WITH(NOLOCK)
				       ON TT1.PROGRAM_ID = @P_PROGRAM_ID
						AND TT1.SHEET_NAME = @P_SHEET_NAME	
					LEFT OUTER JOIN SCM_MST_TITLESET_USER T3 WITH(NOLOCK)                                                                                       
						ON T3.PROGRAM_ID = TT1.PROGRAM_ID                                                                                                       
						AND T3.SHEET_NAME = TT1.SHEET_NAME                                                                                                      
						AND T3.COLUMN_NAME = TT1.COLUMN_NAME                                                                                                    
						AND T3.USER_ID =  @p_created_by    
			) X
			LEFT OUTER JOIN  #TMP_ROWDATA R  
				ON R.DIVISION_ID		= X.DIVISION_ID
				AND R.ITEM_ID			= X.ITEM_ID
				AND R.MEASURE			= X.MEASURE
				AND R.YYYYMMDD			= X.YYYYMMDD
				AND R.FROM_SITE			= X.FROM_SITE
				AND R.TO_SITE			= X.TO_SITE
				AND R.BOD_ID			= X.BOD_ID
				--AND R.FCST_TYPE			= X.FCST_TYPE
			
			WHERE ( X.TO_SITE != '-'	AND  X.MEASURE IN (	'SCP_SHIP_PLAN','SHIP_REQ','SHIP_PLAN'))

			;
			
			--select * from #TMP_ROWDATA WHERE ITEM_ID  = 'MPCLGEH7HD4N';

			--select * from #TMP_RESULT_TABLE where measure = 'SHIP_PLAN';

			-------------------------------------------------
			---- Requestor
			-------------------------------------------------
			SELECT DIVISION_ID, FROM_SITE,TO_SITE,ITEM_ID,MEASURE, BOD_ID, LAST_UPDATED_BY
			INTO #TblDynamic_REQUESTOR
			FROM (
				SELECT DIVISION_ID,FROM_SITE,TO_SITE,ITEM_ID,MEASURE, BOD_ID ,LAST_UPDATED_BY
					, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,FROM_SITE,TO_SITE,ITEM_ID,MEASURE, BOD_ID ORDER BY RN DESC ) AS RN2
				FROM #TMP_ROWDATA_RN WITH(NOLOCK)
				) X
			WHERE RN2 = 1
			AND MEASURE NOT IN ('WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','PACK_FP') 

			--////////////////////////////////////////////////////////////////////////////////--
			--//5. PIVOT				 													//--
			--////////////////////////////////////////////////////////////////////////////////--


			SELECT DISTINCT T0.DIVISION_ID
			--,	  T0.MODEL_TYPE
			,	  T0.ITEM_ID	
			,	  TEAM.DEPT_NAME_KO
			,	  TEAM.DEPT_ID
			,	  T0.FROM_SITE
			,	  T0.TO_SITE
			,	  T4.SOLDTO_CUSTOMER
			,     T0.MEASURE
			,	  T0.BOD_ID
			,	  'D_' + T0.YYYYMMDD							AS YYYYMMDD		
			,	  T1.BASIS_YYYYMM								AS YYYYMM
			,	  RIGHT(T1.BASIS_YYYYMM,4) + T1.ISO_WEEK		AS ISO_WEEK
			,	  T0.QTY
			,	  T0.INCOTERMS
			,	  T0.TRANSPORT_MODE
			--,	  T0.FCST_TYPE
			,	  '-' AS FCST_TYPE
			,	  T0.SEQ
			,	  RANK() OVER (PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE,	T0.BOD_ID ORDER BY T0.MEASURE, CASE WHEN T0.YYYYMMDD IS NULL THEN 'N' ELSE  'Y' END  DESC
				  ) AS ROW_NUM
			INTO #TMP_RESULT_PIVOT_TABLE_TEMP
			FROM #TMP_RESULT_TABLE T0
			LEFT OUTER  JOIN SCM_SYS_CALENDAR_M T1 
				ON T0.YYYYMMDD = T1.BASIS_YYYYMMDD	

			--LEFT JOIN SCM_MST_SITE_ITEM T5 WITH(NOLOCK)                                                       
			--ON T5.DIVISION_ID = T0.DIVISION_ID                                                           
			--AND T5.SCM_SITE_ID = T0.TO_SITE                                                              
			--AND T5.ITEM_ID = T0.ITEM_ID
			--AND T5.VALID_YN = 'Y'

			LEFT JOIN (			
				SELECT MAX(PROJECT_CODE) AS PROJECT_CODE , ITEM_ID , SCM_SITE_ID, DIVISION_ID , MAX(OWNER) AS OWNER
				FROM SCM_MST_SITE_ITEM
				WHERE VALID_YN = 'Y'
				GROUP BY ITEM_ID , SCM_SITE_ID, DIVISION_ID
			) T5
				ON T5.DIVISION_ID = T0.DIVISION_ID                                                           
				AND T5.SCM_SITE_ID = T0.TO_SITE                                                              
				AND T5.ITEM_ID = T0.ITEM_ID

			LEFT JOIN SCM_MST_PROJECT T6 WITH(NOLOCK)                                                         
				ON T6.DIVISION_ID = T5.DIVISION_ID                                                           
				AND T6.PROJECT_CODE = T5.PROJECT_CODE                                                        
			
			LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                      
				ON T0.DIVISION_ID = T4.DIVISION_ID                                                           
				AND T0.TO_SITE = T4.SCM_SITE_ID                                                              
				AND T4.VALID_YN = 'Y'                                                                    
			
			LEFT  JOIN (																				
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 					
				FROM [SCM_MST_SSO_USER_INFO] AS B													
				INNER JOIN SCM_MST_SSO_DEPT_INFO AS C												
				ON B.DEPT_ID = C.DEPT_ID															
			) AS TEAM																			
			ON              TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](T5.owner, ','))	
			WHERE 1=1
			
			

			;

			--SELECT * FROM #TMP_ROWDATA WHERE ITEM_ID = 'MPCGOOGGJL2O'
		     
			--SELECT * FROM #TMP_RESULT_TABLE P WHERE ITEM_ID = 'MPCGOOGGJL2O'

			--SELECT * FROM #TMP_RESULT_PIVOT_TABLE_TEMP;


			--return;

			SELECT A.*
			INTO #TMP_RESULT_PIVOT_TABLE 
			FROM #TMP_RESULT_PIVOT_TABLE_TEMP A
			WHERE A.ITEM_ID IN (
				SELECT DISTINCT  A.ITEM_ID 
				FROM #TMP_RESULT_PIVOT_TABLE_TEMP A
				WHERE 1=1 
				AND (( @p_plant_site_id   IS NULL OR @p_plant_site_id ='')   OR A.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_site_id , ',')))   
				AND (( @p_scm_site_id	  IS NULL OR @p_scm_site_id ='')	 OR A.TO_SITE			 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_scm_site_id , ',')))
				AND (( @p_customer		  IS NULL OR @p_customer ='')		 OR A.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_customer , ',')))
				AND (( @p_team_id		  IS NULL OR @p_team_id ='')		 OR A.DEPT_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_team_id , ',')))
				AND (( @p_item_id		  IS NULL OR @p_item_id ='')		 OR A.ITEM_ID			  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_item_id , ','))) 

			)
			;

			/*PIVOIT처리*******************************************************************************/
			BEGIN
		
				-- PIVOIT 대상 날짜문자열 생성
				SET @MQRY_SUM = '';
			
				SELECT  @MQRY_SUM = @MQRY_SUM+','+  CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  'CEILING(SUM(CASE WHEN T0.YYYYMM   = RIGHT('''+YYYYMMDD+''',6) THEN CONVERT(NUMERIC(20, 10), ISNULL(T0.QTY, 0)) ELSE 0 END )) AS ' + YYYYMMDD
												 WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  'CEILING(SUM(CASE WHEN T0.ISO_WEEK = RIGHT('''+YYYYMMDD+''',6) THEN CONVERT(NUMERIC(20, 10),ISNULL(T0.QTY, 0)) ELSE 0  END )) AS ' + YYYYMMDD
												 WHEN CHARINDEX('D_', YYYYMMDD) =1 THEN  'CEILING(SUM(CASE WHEN T0.YYYYMMDD = RIGHT('''+YYYYMMDD+''',10)THEN CONVERT(NUMERIC(20, 10),ISNULL(T0.QTY, 0)) ELSE 0 END )) AS ' + YYYYMMDD
										
											END +''+  CHAR(10)
				FROM ( 
						SELECT 'W_'+A.BASIS_YYYYMM + A.ISO_WEEK AS YYYYMMDD        
							, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
						FROM [DBO].[SCM_SYS_CALENDAR_M] A 
						WHERE A.BASIS_YYYYMMDD  BETWEEN @V_FROM_YYYYMMDD AND @V_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE

						UNION ALL

						SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
								,MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
						FROM [DBO].[SCM_SYS_CALENDAR_M] A 
						WHERE A.BASIS_YYYYMMDD  BETWEEN @V_FROM_YYYYMMDD AND @V_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME		
						UNION ALL

						SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD      
								,A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
						FROM [DBO].[SCM_SYS_CALENDAR_M] A 
						WHERE A.BASIS_YYYYMMDD  BETWEEN @V_FROM_YYYYMMDD AND @V_TO_YYYYMMDD
						GROUP BY A.BASIS_YYYYMMDD	
						-------------------------------------------------------------------------
						) AS A
				ORDER BY SORT_ORDER_NO  ;
			END;
			--//END PIVOT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
			--////////////////////////////////////////////////////////////////////////////////--
			--//6. RESULT				 													//--
			--////////////////////////////////////////////////////////////////////////////////--

			SET @MEXEC = 'SELECT DISTINCT TTT.* FROM ( '
			SET @MEXEC = @MEXEC+'	SELECT  																											' + CHAR(10);
			SET @MEXEC = @MEXEC+'       	 T0.DIVISION_ID																									' + CHAR(10);
			--SET @MEXEC = @MEXEC+'       	, T0.MODEL_TYPE																										' + CHAR(10);
			SET @MEXEC = @MEXEC+'       	, T0.ITEM_ID	AS MODEL_ID																									' + CHAR(10);
			SET @MEXEC = @MEXEC+'       	, ISNULL(IT.NICK_NAME,''-'')		AS NICK_NAME																								' + CHAR(10);
--			SET @MEXEC = @MEXEC+'       	, CONVERT(VARCHAR, DATEADD(D, 0 + ISNULL(T4.SHIP_FROZEN,0), CONVERT(DATETIME,GETDATE() ,112)) ,112)		AS CONFIRM_DAY																								' + CHAR(10);
			-- 20220221	SMS	수정	
			SET @MEXEC = @MEXEC+'       	, CONVERT(VARCHAR, DATEADD(D,  CASE WHEN (T4.SHIP_FROZEN - 1) > 0 THEN (T4.SHIP_FROZEN - 1) ELSE 0 END, CONVERT(DATETIME,GETDATE() ,112)) ,112)		AS CONFIRM_DAY																								' + CHAR(10);						

			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.DEPT_NAME_KO,''-'') ELSE ''-'' END				 AS TEAM_NAME_KO																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.DEPT_ID,''-'') ELSE ''-'' END				 AS DEPT_ID																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.FROM_SITE,''-'') ELSE ''-'' END				 AS FROM_SITE																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T4.SITE_DESCRIPTION,''-'') ELSE ''-'' END				 AS SITE_DESCRIPTION																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.TO_SITE,''-'') ELSE ''-'' END				 AS TO_SITE																	' + CHAR(10);
		--	SET @MEXEC = @MEXEC+'         , ISNULL(T0.TO_SITE,''-'') 				 AS TO_SITE																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , T0.MEASURE							 																			' + CHAR(10);		
			SET @MEXEC = @MEXEC+'       	, T2.SORT_ORDER_NO		AS SORT_ORDER_NO																								' + CHAR(10);
			--SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.BOD_ID,''-'') ELSE ''-'' END				 AS BOD_ID																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , ''-'' 				 AS BOD_ID																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.INCOTERMS,''-'') ELSE ''-'' END				 AS INCOTERMS																	' + CHAR(10);
			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.TRANSPORT_MODE,''-'') ELSE ''-'' END				 AS TR_MODE																	' + CHAR(10);	
			--SET @MEXEC = @MEXEC+'         , ISNULL(T0.FCST_TYPE,''-'')					AS FCST_TYPE																			' + CHAR(10);			
			SET @MEXEC = @MEXEC+'         , ''-''					AS FCST_TYPE																			' + CHAR(10);			
			SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.SOLDTO_CUSTOMER,''-'') ELSE ''-'' END				 AS END_CUSTOMER																	' + CHAR(10);	
			SET @MEXEC = @MEXEC+'         , CASE WHEN ISNULL(C.USERNAME,'''') <> '''' THEN C.USERNAME + ''('' + R.LAST_UPDATED_BY + '')'' ELSE ISNULL(R.LAST_UPDATED_BY,''-'') END AS LAST_UPDATED_BY			'+CHAR(10);
			SET @MEXEC = @MEXEC+'       	' + @MQRY_SUM																										  + CHAR(10);
			SET @MEXEC = @MEXEC+'       FROM #TMP_RESULT_PIVOT_TABLE T0 WITH(NOLOCK)																			     ' + CHAR(10);
			SET @MEXEC = @MEXEC+'		INNER JOIN SCM_MST_SHEET_MEASURE T2																					' + CHAR(10);
			SET @MEXEC = @MEXEC+'			ON T0.MEASURE = T2.COLUMN_NAME																					' + CHAR(10);
			SET @MEXEC = @MEXEC+'			AND T2.PROGRAM_ID = ''' + @P_PROGRAM_ID + '''																		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			AND T2.SHEET_NAME = ''' + @P_SHEET_NAME + '''																		' + CHAR(10);
			SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN SCM_MST_TITLESET_USER T3 WITH(NOLOCK)                                                                                       ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			ON T3.PROGRAM_ID = T2.PROGRAM_ID                                                                                                       ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			AND T3.SHEET_NAME = T2.SHEET_NAME                                                                                                      ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			AND T3.COLUMN_NAME = T2.COLUMN_NAME                                                                                                    ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			AND T3.USER_ID = ''' + @p_created_by + '''                                                                                                ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                                                       ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = T4.DIVISION_ID                                                                                                       ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			AND T0.FROM_SITE = T4.SCM_SITE_ID                                                                                                      ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			AND T4.VALID_YN = ''Y''                                                                                                 ' + CHAR(10) ;

			SET @MEXEC = @MEXEC+'		INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME											     ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'				    FROM SCM_MST_ITEM_SN WITH (NOLOCK)															     ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'				   WHERE DIVISION_ID =  ''' + @p_division_id + '''    													' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'					AND ACTIVE_FLAG = ''Y''																	     ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'					AND SCP_OPERATION_GROUP = ''P''  -- CELL/PACK 구분													' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'				  ) IT 																					     ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = IT.DIVISION_ID AND T0.ITEM_ID = IT.ITEM_ID												' + CHAR(10) ;
			--SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO DP ON T4.DEPT_ID = DP.DEPT_ID												' + CHAR(10) ;

			SET @MEXEC = @MEXEC+'         LEFT OUTER JOIN  #TblDynamic_REQUESTOR R	ON R.DIVISION_ID = T0.DIVISION_ID		'+CHAR(10);
			SET @MEXEC = @MEXEC+'											AND R.ITEM_ID = T0.ITEM_ID			'+CHAR(10);
			SET @MEXEC = @MEXEC+'											AND R.FROM_SITE = T0.FROM_SITE		'+CHAR(10);
			SET @MEXEC = @MEXEC+'											AND R.TO_SITE = T0.TO_SITE			'+CHAR(10);
			SET @MEXEC = @MEXEC+'											AND R.BOD_ID = T0.BOD_ID				'+CHAR(10);
			SET @MEXEC = @MEXEC+'											AND R.MEASURE = T0.MEASURE			'+CHAR(10);
			SET @MEXEC = @MEXEC+'         LEFT OUTER JOIN (SELECT UserID, UserName FROM TB_FX_User WITH(NOLOCK)) C     '+CHAR(10);
			SET @MEXEC = @MEXEC+'                                           ON R.LAST_UPDATED_BY = C.UserID     '+CHAR(10);
			SET @MEXEC = @MEXEC+'		WHERE 1 = 1																										' + CHAR(10);
			SET @MEXEC = @MEXEC+'		AND T2.PROGRAM_ID = ''' + @P_PROGRAM_ID + '''                                                                                               ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'		AND T2.SHEET_NAME = ''' + @P_SHEET_NAME + '''                                                                                               ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'		AND T2.VALID_YN = ''Y''                                                                                                                     ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'		AND T0.ROW_NUM = ''1''                                                                                                                     ' + CHAR(10) ;
			--IF (@p_plant_site_id IS NOT NULL AND @p_plant_site_id !='')
			--	SET @MEXEC = @MEXEC+'		AND (( '''+@p_plant_site_id+'''   IS NULL OR '''+@p_plant_site_id+''' ='''')   OR T0.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_plant_site_id+''' , '','')))                                                                                                 ' + CHAR(10) ;
			--IF (@p_scm_site_id IS NOT NULL AND @p_scm_site_id !='')
			--	SET @MEXEC = @MEXEC+'		AND (( '''+@p_scm_site_id+'''   IS NULL OR '''+@p_scm_site_id+''' ='''')   OR T0.TO_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_scm_site_id+''' , '','')))                                                                                                 ' + CHAR(10) ;
			--IF (@p_customer IS NOT NULL AND @p_customer !='')
			--	SET @MEXEC = @MEXEC+'		AND (( '''+@p_customer+'''   IS NULL OR '''+@p_customer+''' ='''')   OR T0.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_customer+''' , '','')))                                                                                                 ' + CHAR(10) ;
			--IF (@p_team_id IS NOT NULL AND @p_team_id !='')
			--	SET @MEXEC = @MEXEC+'		AND (( '''+@p_team_id+'''   IS NULL OR '''+@p_team_id+''' ='''')   OR T0.DEPT_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_team_id+''' , '','')))                                                                                                 ' + CHAR(10) ;
			SET @MEXEC = @MEXEC+' 		AND ('+CONVERT(VARCHAR,@V_CNT_USR_MEASURE)+' = 0                                      ' + CHAR(10) ;                                                                                                                 
			SET @MEXEC = @MEXEC+' 						OR EXISTS (SELECT 1                                    ' + CHAR(10) ;                                                                                                                 
			SET @MEXEC = @MEXEC+' 									 FROM #TBLDYNAMICTITLEST_SSP0026			   ' + CHAR(10) ;                                                                                                                 
			SET @MEXEC = @MEXEC+' 									 WHERE COLUMN_NAME = T2.COLUMN_NAME)         ' + CHAR(10) ;                                                                                                                 
			SET @MEXEC = @MEXEC+' 				                  )                                            ' + CHAR(10) ; 	
			SET @MEXEC = @MEXEC+' 			  AND ( ( '+CONVERT(VARCHAR,@V_CNT_USR_MEASURE)+' = 0 AND T2.DEFAULT_FLAG=''Y'' )                                      ' + CHAR(10) ;                                                                                                                 
			SET @MEXEC = @MEXEC+' 						OR  ('+CONVERT(VARCHAR,@V_CNT_USR_MEASURE)+' != 0 )       ' + CHAR(10) ;                                                                                                                 
			SET @MEXEC = @MEXEC+' 				                  )                                            ' + CHAR(10) ; 	
			SET @MEXEC = @MEXEC+'		AND T2.COLUMN_NAME = T0.MEASURE																							' + CHAR(10) ;
			SET @MEXEC = @MEXEC+'		GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.DEPT_NAME_KO, T0.DEPT_ID, T0.FROM_SITE,T4.SITE_DESCRIPTION,T4.SHIP_FROZEN, T0.TO_SITE, T0.MEASURE, T0.BOD_ID, T0.BOD_ID, T0.INCOTERMS, T0.TRANSPORT_MODE,T0.SOLDTO_CUSTOMER, R.LAST_UPDATED_BY,C.USERNAME, T2.SORT_ORDER_NO' + CHAR(10);
		--	SET @MEXEC = @MEXEC+'		ORDER BY T0.DIVISION_ID, T0.MODEL_TYPE, T0.MODEL_ID, T0.FROM_SITE DESC, T0.TO_SITE DESC, T2.SORT_ORDER_NO ASC		' + CHAR(10);
			SET @MEXEC = @MEXEC+'	) TTT' + CHAR(10);
			SET @MEXEC = @MEXEC+'		ORDER BY TTT.DIVISION_ID, TTT.MODEL_ID, TTT.FROM_SITE DESC, TTT.TO_SITE DESC, TTT.INCOTERMS, TTT.TR_MODE, TTT.FCST_TYPE, TTT.SORT_ORDER_NO ASC		' + CHAR(10);

			--PRINT @MEXEC;
			EXEC(@MEXEC);

		END

		--//END RESULT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		-- MEASURE JOIN 처리용
	IF OBJECT_ID('tempdb..#Tbl_boh') IS NOT NULL	
		DROP TABLE #Tbl_boh;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('TEMPDB..#TMP_ROWDATA') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA;

		-- SHIPMENT ROW DATA
	IF OBJECT_ID('TEMPDB..##TMP_ROWDATA_RN') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA_RN;

	IF OBJECT_ID('TEMPDB..#TMP_ROWDATA_RN') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA_RN;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_PIVOT_TABLE_TEMP') IS NOT NULL	
		DROP TABLE #TMP_RESULT_PIVOT_TABLE_TEMP;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_PIVOT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_PIVOT_TABLE;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE;
	
	-- Requestor
	IF OBJECT_ID('tempdb..#TblDynamic_REQUESTOR') IS NOT NULL
		DROP TABLE #TblDynamic_REQUESTOR;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
		DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG;

	IF OBJECT_ID('tempdb..#TBLDYNAMICTITLEST_SSP0026') IS NOT NULL
		DROP TABLE #TBLDYNAMICTITLEST_SSP0026;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_STD') IS NOT NULL	
		DROP TABLE #TblDynamic_SSP0026_40_STD;

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_40_FG') IS NOT NULL	
		DROP TABLE #TblDynamic_SSP0026_40_FG;

	IF OBJECT_ID('tempdb..#Z') IS NOT NULL	
		DROP TABLE #Z;

	IF OBJECT_ID('tempdb..#QTY') IS NOT NULL	
		DROP TABLE #QTY;

	IF OBJECT_ID('tempdb..#BOH') IS NOT NULL	
		DROP TABLE #BOH;

		
END
