
/*
 * PROGRAM ID   : SSP0026_GET_SHIPMENT_REQUEST_CELL
 * DESCRIPTION  : CELL SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 20200921     KIMYONGHO		신규추가
 * 20210526     SSP Pjt.        속도개선
 * 2021/09/02   KIMYONGHO      scp_mst_bod_n_v -> SCP_MST_BOD_N_V 변경
 */
CREATE PROCEDURE [dbo].[SSP0026_GET_SHIPMENT_REQUEST_CELL]
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
	@p_created_by	   NVARCHAR(50),
	@debug_mode       NVARCHAR(1)='F'
--WITH RECOMPILE	
AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	


	DECLARE @V_sheet_name     NVARCHAR(10)
	DECLARE @V_division_id    NVARCHAR(30)
	DECLARE @V_team_id        NVARCHAR(MAX)
	DECLARE @V_customer       NVARCHAR(MAX)
	DECLARE @V_scm_site_id    NVARCHAR(MAX)
	DECLARE @V_plant_site_id  NVARCHAR(MAX)
	DECLARE @V_project_code   NVARCHAR(MAX)
	DECLARE @V_item_id        NVARCHAR(4000)

	DECLARE @V_created_by	   NVARCHAR(50)

	SET @v_sheet_name    = @p_sheet_name;   
	SET	@v_division_id   = @p_division_id;  
	SET	@v_team_id       = @p_team_id; 
	SET	@v_customer      = @p_customer;     
	SET	@v_scm_site_id   = @p_scm_site_id;
	SET	@v_plant_site_id = @p_plant_site_id;
	SET	@v_project_code  = @p_project_code;
	SET	@v_item_id       = @p_item_id;

	--DE@V_created_by	CLARE @debug_mode       NVARCHAR(1)='F'
	
	DECLARE @V_FROM_YYYYMMDD			NVARCHAR(8);
	DECLARE @V_TO_YYYYMMDD				NVARCHAR(8);
	DECLARE @P_STOCK_YYYYMMDD			NVARCHAR(8);
	DECLARE @MQRY_SUM					NVARCHAR(MAX);
	DECLARE @MEXEC						NVARCHAR(MAX);
	DECLARE @MDAY_QTY					NVARCHAR(MAX);
	DECLARE @P_PROGRAM_ID				NVARCHAR(MAX);

	DECLARE @V_SEQ						INT;
	DECLARE @V_CNT_USR_MEASURE			INT =0;


	DECLARE @v_last_plan_start_yyyymmdd     NVARCHAR(8)	= '';
	DECLARE @v_last_plan_type				NVARCHAR(30)	= 'SP'; 
	DECLARE @v_last_seq						INTEGER		= 0;


	-- SCP FINAL PLAN INFO
	DECLARE @v_scp_plan_start_yyyymmdd		NVARCHAR(8);
	DECLARE @v_scp_plan_type				NVARCHAR(10); 
	DECLARE @v_scp_seq					INTEGER ;    


	SET @P_PROGRAM_ID					= 'SSP0026';
	SET @v_from_yyyymmdd				= @p_from_yyyymmdd;
	SET @v_to_yyyymmdd					= @p_to_yyyymmdd;



	SET @V_CNT_USR_MEASURE = (
							SELECT COUNT(*) 
							FROM SCM_MST_TITLESET_USER   WITH(NOLOCK)
							WHERE 1=1
							AND PROGRAM_ID  =  @P_PROGRAM_ID
							AND SHEET_NAME  =  @V_SHEET_NAME 
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

	SELECT * 
	  INTO #TBLDYNAMICTITLEST_SSP0026 
	  FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
	 WHERE PROGRAM_ID		= @P_PROGRAM_ID
	   AND SHEET_NAME		= @V_SHEET_NAME
	   AND USER_ID			= @V_created_by;

	CREATE TABLE #TMP_RESULT_TABLE
	(
		  DIVISION_ID		NVARCHAR(10)		
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
	   ,LAST_UPDATE_DATE	DATETIME
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
    
	--가장 최근 출하계획 버전 확인 
	SELECT @v_last_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
	,      @v_last_seq                 = MAX(PLAN_SEQ)
	,      @v_last_plan_type           = MAX(PLAN_TYPE)
	FROM   SSP_PLAN_VERSION_V
	WHERE  PLAN_TYPE    = 'SP'
	AND    DIVISION_ID  = @v_division_id 
	AND    CONFIRM_FLAG = 'Y'
	;


	PRINT '-------------01------------: ' +  CONVERT(CHAR(23), getdate(), 21);

	-- SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다.
	SELECT DISTINCT
	       DIVISION_ID
	     , FROM_SITE
		 , PLAN_START_YYYYMMDD
	  INTO #TblDynamic_SSP0026_40_STD     -- 기준 데이터 저장
	  FROM(
			SELECT SP.DIVISION_ID
				 , SP.FROM_SITE
				 , SP.PLAN_START_YYYYMMDD
				 , RANK() OVER(PARTITION BY SP.FROM_SITE ORDER BY SP.PLAN_START_YYYYMMDD DESC) AS RANK
			  FROM SSP_ANL_SHIP_PLAN_40 SP WITH(NOLOCK)
			 WHERE SP.DIVISION_ID    = @v_division_id
			   AND SP.PLAN_START_YYYYMMDD >= CONVERT(VARCHAR(8) ,GETDATE() -1,112)  -- 전일
			   AND SP.PLAN_START_YYYYMMDD <= CONVERT(VARCHAR(8) ,GETDATE() ,112)    -- 당일
			   AND SP.QTY > 0
		   ) A
	   WHERE RANK = 1
	;

	PRINT '-------------02------------: ' +  CONVERT(CHAR(23), getdate(), 21);

	--SELECT  A.DIVISION_ID      
	--		,A.PLAN_START_YYYYMMDD                
	--		,A.PLAN_TYPE            
	--		,A.SEQ                  
	--		,A.ORDER_ID
	--		,A.ALLOCATION_QTY 
	--		,A.FCST_TYPE 
	--INTO #TblDynamic_SSP0026_40_FG
	--FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)
	--WHERE A.DIVISION_ID = @v_division_id
	--	AND A.PLAN_START_YYYYMMDD	   = @V_SCP_PLAN_START_YYYYMMDD                
	--	AND A.PLAN_TYPE					= @V_SCP_PLAN_TYPE
	--	AND A.SEQ					   = @V_SCP_SEQ
	--;

	PRINT '-------------03------------: ' +  CONVERT(CHAR(23), getdate(), 21);

	SELECT  DIVISION_ID                        
	      , PLAN_START_YYYYMMDD                        
	      , PLAN_TYPE                 
	      , SEQ                        
	      , MAX(OPERATION_GROUP)     AS BIZ_TYPE                                 
	      , FCST_TYPE
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
			SELECT B.DIVISION_ID                        
				, B.PLAN_START_YYYYMMDD                     
				, B.PLAN_TYPE                        
				, B.SEQ                          
				, B.OPERATION_GROUP                        
				, A.FCST_TYPE                        
				, B.ITEM_ID                        
				, B.TO_SITE                    		
				, B.FROM_SITE                        
				, B.BOD_ID                         
				, B.TRANSPORT_MODE                        
				, B.MEASURE                 
				, B.YYYYMMDD                        
				, A.ALLOCATION_QTY         AS QTY 
				, REPLACE(B.LAST_UPDATED_BY,'scp_batch','System') as LAST_UPDATED_BY
				, B.LAST_UPDATE_DATE
			FROM SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK, index(IX04_SCP_PLN_SHIPMENT_PLAN))                         
			INNER JOIN SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)           
				ON 1 = 1
					AND A.MASTER_ID				= B.MASTER_ID
					AND A.PLAN_ID				= B.PLAN_ID
					AND A.OUT_VERSION_ID		= B.OUT_VERSION_ID
					AND A.DIVISION_ID           = B.DIVISION_ID     
					AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD                
					AND A.PLAN_TYPE             = B.PLAN_TYPE   
					AND A.SEQ                   = B.SEQ      
					AND A.ORDER_ID              = B.ORDER_ID 	
     
				INNER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                      
						ON B.DIVISION_ID		   = T4.DIVISION_ID                                                           
						AND B.TO_SITE			   = T4.SCM_SITE_ID                                                              
						AND T4.VALID_YN		   = 'Y'
						AND T4.OPERATION_GROUP IS NULL 

			WHERE 1 = 1
				AND B.DIVISION_ID			   = @v_division_id
				AND B.PLAN_START_YYYYMMDD	   = @v_scp_plan_start_yyyymmdd                    
				AND B.PLAN_TYPE				   = @v_scp_plan_type
				AND B.SEQ					   = @v_scp_seq
				AND B.MEASURE                  ='SHIP_PLAN'			  
				AND B.SEMI_YN                  = 'N'
				AND B.OPERATION_GROUP		   = 'A' 
				AND B.YYYYMMDD			   >= @v_from_yyyymmdd
				AND B.YYYYMMDD			   <= @v_to_yyyymmdd
				AND (( @V_item_id		  IS NULL OR @V_item_id ='')		   OR B.ITEM_ID				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
				AND (( @V_plant_site_id   IS NULL OR @V_plant_site_id ='')	   OR B.FROM_SITE			  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
				AND (( @V_scm_site_id     IS NULL OR @V_scm_site_id ='')	   OR B.TO_SITE				  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_scm_site_id , ',')))
				AND (( @V_customer        IS NULL OR @V_customer ='')		   OR T4.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_customer , ','))) 		

		) X                        
			GROUP BY DIVISION_ID                        
					, PLAN_START_YYYYMMDD                        
					, PLAN_TYPE                
					, SEQ                           
					, FCST_TYPE              
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

	PRINT '-------------04------------: ' +  CONVERT(CHAR(23), getdate(), 21);

	BEGIN
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
			-- 20201223 incoterms 변경 작업 modify KIMYONGHO
			, C.SSP_INCOTERMS AS INCOTERMS
			, C.TRANSPORT_MODE
			, ISNULL(A.FCST_TYPE,'') AS FCST_TYPE
			, 1 AS SEQ
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, '-' AS REMARK
		FROM  #TMP_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK) 	
		--LEFT OUTER JOIN scp_mst_bod_n_v  C WITH(NOLOCK)
		LEFT OUTER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
				ON   C.DIVISION_ID		   = A.DIVISION_ID                        
				AND  C.BOD_ID			   = A.BOD_ID
				AND  C.DIVISION_ID		   = @v_division_id
				AND  C.BOD_TYPE			   = 'SALES'
		WHERE A.DIVISION_ID			= @v_division_id			
		AND A.MEASURE				= 'SHIP_PLAN'          
		;

		
		PRINT '-------------05------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		
		/*SHIP_REQ Meausre 생성*/
		INSERT INTO #TMP_ROWDATA 
		SELECT A.DIVISION_ID
			, A.ITEM_ID
			, A.PLANT_SITE_ID	AS FROM_SITE
			, A.SCM_SITE_ID	AS TO_SITE	
			, 'SHIP_REQ'		AS MEASURE
			, A.YYYYMMDD
			, A.BOD_ID
			, A.QTY
			, A.INCOTERMS
			, A.TRANSPORT_MODE
			, A.FCST_TYPE
			, 2 AS SEQ
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, '-'  AS REMARK
		FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)

		--LEFT OUTER JOIN scp_mst_bod_n_v  C WITH(NOLOCK)
		LEFT OUTER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
				ON   C.DIVISION_ID		   = A.DIVISION_ID                        
				AND  C.BOD_ID			   = A.BOD_ID
				AND  C.DIVISION_ID		   = @v_division_id
				AND  C.BOD_TYPE			   = 'SALES'

		LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                      
			ON A.DIVISION_ID	 = T4.DIVISION_ID                                                           
			AND A.SCM_SITE_ID	 = T4.SCM_SITE_ID                                                              
			AND T4.VALID_YN	 = 'Y' 
			
		WHERE 1 = 1
		AND A.DIVISION_ID		 = @v_division_id 
		AND A.MEASURE			 = 'SHIP_REQ' 
		AND A.YYYYMMDD			 >= @v_from_yyyymmdd
		AND A.YYYYMMDD			 <= @v_to_yyyymmdd
		AND (( @V_item_id		 IS NULL OR @V_item_id ='')			OR A.ITEM_ID			  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ',')))
		AND (( @V_plant_site_id  IS NULL OR @V_plant_site_id ='')   OR A.PLANT_SITE_ID		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
		AND (( @V_scm_site_id    IS NULL OR @V_scm_site_id ='')		OR A.SCM_SITE_ID		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_scm_site_id , ',')))
		AND (( @V_customer		 IS NULL OR @V_customer ='')		oR T4.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_customer , ',')))  
		;
		

		PRINT '-------------06------------: ' +  CONVERT(CHAR(23), getdate(), 21);

		/*SHIP_PLAN Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT SSP.DIVISION_ID
			, SSP.ITEM_ID
			, SSP.FROM_SITE
			, SSP.TO_SITE
			, 'SHIP_PLAN'            AS MEASURE
			, SSP.YYYYMMDD
			, BOD.BOD_ID
			, SSP.QTY
			-- 20201223 incoterms 변경 작업 modify KIMYONGHO
			, BOD.SSP_INCOTERMS          AS INCOTERMS
			, BOD.TRANSPORT_MODE     AS TR_MODE
			, SSP.FCST_TYPE
			, 3                      AS SEQ
			, '-' AS LAST_UPDATED_BY
			, SSP.LAST_UPDATE_DATE
			, '-'				AS REMARK
		FROM SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)

			INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
					    FROM SCM_MST_ITEM_SN WITH (NOLOCK)
					   WHERE DIVISION_ID		= @v_division_id
						AND SCP_OPERATION_GROUP  = 'A'  -- CELL/PACK 구분
						AND ACTIVE_FLAG		= 'Y'
					) IT 
				ON SSP.DIVISION_ID	= IT.DIVISION_ID 
				AND SSP.ITEM_ID	= IT.ITEM_ID

			INNER JOIN SCM_MST_SITE TS WITH (NOLOCK)     
				ON  SSP.DIVISION_ID = TS.DIVISION_ID
				AND SSP.TO_SITE     = TS.SCM_SITE_ID
				AND TS.VALID_YN     = 'Y'
				AND TS.SITE_TYPE    = 'SALES'

			--INNER JOIN scp_mst_bod_n_v BOD WITH(NOLOCK)
			INNER JOIN SCP_MST_BOD_N_V BOD WITH(NOLOCK)
				ON  SSP.DIVISION_ID = BOD.DIVISION_ID
				AND SSP.BOD_ID      = BOD.BOD_ID
				
		WHERE SSP.DIVISION_ID	   = @v_division_id -- 변수
		  AND SSP.QTY			   >  0
		  AND SSP.YYYYMMDD		   >= @v_from_yyyymmdd
		  AND SSP.YYYYMMDD		   <= @v_to_yyyymmdd
		  AND SSP.CHANGE_TYPE	   = 'C'
		  AND (( @V_item_id		    IS NULL OR @V_item_id ='')		 OR SSP.ITEM_ID		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
		  AND (( @V_plant_site_id   IS NULL OR @V_plant_site_id ='') OR SSP.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
		  AND (( @V_scm_site_id     IS NULL OR @V_scm_site_id ='')	 OR SSP.TO_SITE		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_scm_site_id , ',')))
		  AND (( @V_customer	    IS NULL OR @V_customer ='')	 OR TS.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_customer , ',')))  

		UNION ALL

		SELECT P.DIVISION_ID
			, P.ITEM_ID
			, P.PLANT_SITE_ID		AS FROM_SITE
			, P.SCM_SITE_ID			AS TO_SITE
			, 'SHIP_PLAN'			AS MEASURE
			, P.YYYYMMDD
			, P.BOD_ID
			, P.QTY
			, P.INCOTERMS
			, P.TRANSPORT_MODE
			, P.FCST_TYPE
			, 3					AS SEQ
			, '-'				AS LAST_UPDATED_BY
			, P.LAST_UPDATE_DATE
			,   '-'				AS REMARK
		FROM DM_PLN_SHIPMENT_REQ P WITH(NOLOCK) 

		LEFT OUTER JOIN SCM_MST_SITE FZ WITH(NOLOCK) 
		ON P.DIVISION_ID		= FZ.DIVISION_ID 
			AND P.PLANT_SITE_ID = FZ.SCM_SITE_ID 
			AND FZ.VALID_YN	= 'Y'
		
		LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK) 
		ON P.DIVISION_ID		= T4.DIVISION_ID 
			AND P.SCM_SITE_ID   = T4.SCM_SITE_ID 
			AND T4.VALID_YN	= 'Y'
			AND T4.SITE_TYPE    = 'SALES'

		WHERE P.DIVISION_ID = @v_division_id
		AND P.YYYYMMDD		>= CONVERT(NVARCHAR(8), DATEADD(DD,ISNULL(FZ.SHIP_FROZEN,0),GETDATE()),112) -- 확정구간의 다음날짜가 나오므로 >= 로 처리함
		AND (( @V_item_id		 IS NULL OR @V_item_id ='')			OR P.ITEM_ID		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
		AND (( @V_plant_site_id  IS NULL OR @V_plant_site_id ='')   OR P.PLANT_SITE_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
		AND (( @V_scm_site_id    IS NULL OR @V_scm_site_id ='')		OR P.SCM_SITE_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_scm_site_id , ',')))
		AND (( @V_customer		 IS NULL OR @V_customer ='')		OR T4.SOLDTO_CUSTOMER IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_customer , ',')))  
		;


		PRINT '-------------07------------: ' +  CONVERT(CHAR(23), getdate(), 21);

		/*POSTP_PLAN Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT P.DIVISION_ID				AS DIVISION_ID
			, P.CELL_ITEM_ID				AS ITEM_ID 
			, P.SCM_SITE_ID					AS FROM_SITE
			, '-'							AS TO_SITE
			, 'POSTP_PLAN'					AS MEASURE
			, P.PLAN_DATE					AS YYYYMMDD
			, '-'							AS BOD_ID    
			, SUM(P.PLAN_QTY)               AS QTY 
			, '-'							AS INCOTERMS
			, '-'							AS TRANSPORT_MODE
			, '-'							AS FCST_TYPE
			, 4								AS SEQ
			, NULL							AS LAST_UPDATED_BY
			, NULL							AS LAST_UPDATE_DATE	
			, '-'							AS REMARK
		--FROM SSP_FORMATION_POST_CELL_V P WITH(NOLOCK)  
		FROM SSP_DNM_FORMATION_POST_CELL P WITH(NOLOCK)  
		WHERE P.DIVISION_ID   = @v_division_id
		AND   P.PLAN_DATE    >= @v_from_yyyymmdd 
		AND   P.PLAN_DATE    <  @v_to_yyyymmdd
		AND (( @V_item_id  IS NULL OR @V_item_id ='')   OR P.CELL_ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
		
		GROUP BY P.DIVISION_ID
		,        P.CELL_ITEM_ID
		,        P.SCM_SITE_ID
		,        P.PLAN_DATE

		--/*POSTP_PLAN Meausre 생성*/
		--INSERT INTO #TMP_ROWDATA
		--SELECT  P.DIVISION_ID				AS DIVISION_ID
		--	, P.ITEM_ID					AS ITEM_ID 
		--	, P.FROM_SITE					AS FROM_SITE
		--	, '-'						AS TO_SITE
		--	, 'POSTP_PLAN'					AS MEASURE
		--	, P.YYYYMMDD					AS YYYYMMDD
		--	, '-'						AS BOD_ID    
		--	, P.QTY						AS QTY 
		--	, '-'						AS INCOTERMS
		--	, '-'						AS TRANSPORT_MODE
		--	, '-'						AS FCST_TYPE
		--	, 4							AS SEQ
		--	, NULL						AS LAST_UPDATED_BY
		--	, NULL						AS LAST_UPDATE_DATE	
		--	, '-'						AS REMARK
		-- FROM SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK)

		--INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
		--   ON P.DIVISION_ID		= FS.DIVISION_ID
		--  AND P.FROM_SITE        = FS.SCM_SITE_ID
		--  AND FS.SITE_TYPE       = 'SALSE'
		--  AND FS.OPERATION_GROUP = 'A'
		--  AND FS.OSP_YN          = 'N'
		--  AND FS.VALID_YN        = 'Y'

		--WHERE 1 = 1
		--  AND P.PLAN_START_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE() , 112) -- 당일(현재는 현재일 -1)
		--  AND P.MEASURE		= 'POSTP_PLAN'
		--  AND P.DIVISION_ID      = @v_division_id
		--  AND P.YYYYMMDD         >= @v_from_yyyymmdd
		--  AND P.YYYYMMDD         <= @v_to_yyyymmdd
		--  AND (( @p_item_id		  IS NULL OR @p_item_id ='')		OR P.ITEM_ID		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 
		--  AND (( @p_plant_site_id  IS NULL OR @p_plant_site_id ='')   OR P.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_site_id , ',')))   		
		--  AND P.qty            >  0
		--  AND P.DIVISION_ID    = '40' -- 소형(40) 인 경우만 조회



		PRINT '-------------08------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		/*SITE_MOVE Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT SSP.DIVISION_ID
			, SSP.ITEM_ID
			, SSP.FROM_SITE    AS FROM_SITE
			, '-'		    AS TO_SITE
			, 'SITE_MOVE'      AS MEASURE
			, SSP.YYYYMMDD
			, ''			    AS BOD_ID
			, SSP.QTY
			, ''			    AS INCOTERMS
			, ''			    AS TRANSPORT_MODE
			, ''			    AS FCST_TYPE
			, 5                AS SEQ
			, NULL		    AS LAST_UPDATED_BY
			, NULL		    AS LAST_UPDATE_DATE	
			, '-'		    AS REMARK
		FROM  SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)

		INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)	
		ON  SSP.DIVISION_ID		= TS.DIVISION_ID
			AND SSP.TO_SITE     = TS.SCM_SITE_ID
			AND TS.SITE_TYPE    = 'PLANT'  
			AND TS.VALID_YN     = 'Y'
				  
		INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)	
		ON  SSP.DIVISION_ID		= FS.DIVISION_ID
			AND SSP.FROM_SITE   = FS.SCM_SITE_ID 
			AND FS.VALID_YN     = 'Y'

		WHERE  1=1
		AND TS.PLANT_ID	<> FS.PLANT_ID
		AND SSP.DIVISION_ID  = @v_division_id
		AND SSP.QTY          >  0
		AND SSP.YYYYMMDD    >= @v_from_yyyymmdd
		AND SSP.YYYYMMDD    <= @v_to_yyyymmdd
		AND SSP.BIZ_TYPE	 = 'A'
		AND SSP.CHANGE_TYPE  = 'C'
		AND (( @V_item_id  IS NULL OR @V_item_id ='')   OR SSP.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 

		UNION ALL

		SELECT R.DIVISION_ID
			, R.ITEM_ID
			, R.PLANT_SITE_ID		AS FROM_SITE
			, '-'                    AS TO_SITE
			, 'SITE_MOVE'            AS MEASURE
			, R.YYYYMMDD
			, ''                     AS BOD_ID
			, R.QTY
			, ''                     AS INCOTERMS
			, ''                     AS TRANSPORT_MODE
			, ''					AS FCST_TYPE
			, 5					AS SEQ
			, NULL				AS LAST_UPDATED_BY
			, NULL				AS LAST_UPDATE_DATE
			, '-'				AS REMARK
		FROM   DM_PLN_SHIPMENT_REQ R WITH(NOLOCK)

		INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)	
			ON  FS.DIVISION_ID	   = R.DIVISION_ID       
			AND FS.SCM_SITE_ID	   = R.PLANT_SITE_ID	   
			AND FS.SITE_TYPE       = 'PLANT'  
			AND FS.OPERATION_GROUP = 'A'
			AND FS.OSP_YN          = 'N'
			AND FS.VALID_YN        = 'Y'	  
				
		INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)	
			ON  TS.DIVISION_ID	   = R.DIVISION_ID
			AND TS.SCM_SITE_ID	   = R.SCM_SITE_ID
			AND TS.SITE_TYPE	   = 'PLANT'  
			AND TS.VALID_YN	   = 'Y'

		WHERE  1=1
		AND R.DIVISION_ID		   = @v_division_id
		AND R.MEASURE			   = 'SHIP_REQ' 
		AND R.YYYYMMDD			   >= @v_from_yyyymmdd
		AND R.YYYYMMDD			   <= @v_to_yyyymmdd
		AND TS.plant_id				<> FS.plant_id
		AND R.QTY				   >  0
		AND R.YYYYMMDD			   >= CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN,0), GETDATE()), 112)	
		AND (( @V_item_id		   IS NULL OR @V_item_id ='')   OR R.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 


		PRINT '-------------09------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		INSERT INTO #TMP_ROWDATA
		/*WH_IN Meausre 생성*/
		SELECT T. DIVISION_ID  	     
			, T.ITEM_ID    
			, T.FROM_SITE	         
			, T.TO_SITE	         
			, 'WH_IN' AS MEASURE	         
			, T.YYYYMMDD	         
			, T.BOD_ID	 
			, T.QTY
			--, CASE WHEN X.QTY IS NOT NULL THEN X.QTY --사용자 수정수량이 있으면 사용자 수정 수량 적용 
			--	ELSE 
			--		CASE WHEN T.FROM_SITE = 'A010-A' THEN 
			--		     -- 오창(A010-A) : ATTRIBUTE4 - ATTRIBUTE6  ( Prod Qty(MASS) - oWMS 재고 수량) 
			--			CASE WHEN CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE4,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0)) < 0 THEN 0 
			--			ELSE
			--				CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE4,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0))
			--			END 

			--		ELSE 
			--		     -- 이외 : ATTRIBUTE5 - ATTRIBUTE6  ( Prod Qty(ALL) - oWMS 재고 수량)  
			--			CASE WHEN CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE5,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0)) < 0 THEN 0 
			--			ELSE
			--				CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE5,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0))
			--			END					      
			--		END 
			--	END   AS QTY    		 
			, T.INCOTERMS         
			, T.TRANSPORT_MODE    
			, T.FCST_TYPE	       
			, 6 AS SEQ 
			, NULL						AS LAST_UPDATED_BY
			, NULL						AS LAST_UPDATE_DATE
			, '-'						AS REMARK
		FROM SSP_ANL_SHIP_PLAN_40 T  WITH (NOLOCK)  
		INNER JOIN #TblDynamic_SSP0026_40_STD ST
		    ON ST.DIVISION_ID = T.DIVISION_ID
		   AND ST.FROM_SITE   = T.FROM_SITE
		   AND ST.PLAN_START_YYYYMMDD = T.PLAN_START_YYYYMMDD
		--LEFT OUTER JOIN ( 
		--				SELECT H.DIVISION_ID 
		--				,      H.ITEM_ID
		--				,      H.FROM_SITE 
		--				,      H.MEASURE 
		--				,      H.YYYYMMDD
		--				,      H.QTY 
		--				FROM SSP_ANL_SHIP_PLAN_40_WH_IN_H H WITH(NOLOCK) 
		--				WHERE H.HISTORY_SEQ = (SELECT MAX(B.HISTORY_SEQ ) 
		--										FROM  SSP_ANL_SHIP_PLAN_40_WH_IN_H B WITH(NOLOCK) 
		--										WHERE B.DIVISION_ID = H.DIVISION_ID 
		--										AND   B.ITEM_ID     = H.ITEM_ID 
		--										AND   B.FROM_SITE   = H.FROM_SITE 
		--										AND   B.MEASURE     = H.MEASURE 
		--										AND   B.YYYYMMDD    = H.YYYYMMDD ) 
		--				AND (( @p_item_id  IS NULL OR @p_item_id ='')   OR H.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ','))) 
		--				) X 
		--				ON  X.DIVISION_ID = T.DIVISION_ID 
		--				AND X.ITEM_ID = T.ITEM_ID
		--				AND X.FROM_SITE = T.FROM_SITE
		--				AND X.MEASURE =  'WH_IN' 
		--				AND X.YYYYMMDD = T.YYYYMMDD
		--LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK) 
		--ON T.DIVISION_ID = T4.DIVISION_ID 
		--	AND T.TO_SITE = T4.SCM_SITE_ID 
		--	AND T4.VALID_YN = 'Y'	
		--WHERE T.MEASURE ='PROD_PLAN'
		WHERE T.DIVISION_ID = @v_division_id
		  AND T.MEASURE ='WH_IN'
		 
		 -- AND T.PLAN_START_YYYYMMDD  = @v_last_plan_start_yyyymmdd			
		  AND T.YYYYMMDD		   >= @v_from_yyyymmdd
		  AND T.YYYYMMDD		   <= @v_to_yyyymmdd
		  AND T.BIZ_TYPE		    = 'A'
		  AND (( @V_item_id			IS NULL OR @V_item_id ='')		   OR T.ITEM_ID			 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
		  AND (( @V_plant_site_id   IS NULL OR @V_plant_site_id ='')   OR T.FROM_SITE		 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
		  --AND (( @p_scm_site_id     IS NULL OR @p_scm_site_id ='')	   OR T.TO_SITE		 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_scm_site_id , ',')))
		  --AND (( @p_customer	   IS NULL OR @p_customer ='')	   OR T4.SOLDTO_CUSTOMER	 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_customer , ',')))  

		PRINT '-------------10------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		/*TOTAL_PLAN Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT DIVISION_ID
			, ITEM_ID
			, FROM_SITE      AS FROM_SITE
			, '-'            AS TO_SITE
			, 'TOTAL_PLAN'   AS MEASURE
			, YYYYMMDD
			, ''             AS BOD_ID
			, SUM(QTY)	  AS QTY
			, ''             AS INCOTERMS
			, ''             AS TRANSPORT_MODE
			, ''             AS FCST_TYPE	
			, 7			  AS SEQ
			, NULL		  AS LAST_UPDATED_BY
			, NULL		  AS LAST_UPDATE_DATE
			, '-'		  AS REMARK
		FROM (
				SELECT SSP.DIVISION_ID
					, SSP.FROM_SITE
					, SSP.ITEM_ID
					, SSP.YYYYMMDD
					, SSP.QTY
					FROM SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)
					 
					INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
								FROM SCM_MST_ITEM_SN WITH (NOLOCK)
							WHERE DIVISION_ID		 = @v_division_id
								AND SCP_OPERATION_GROUP = 'A'  -- CELL/PACK 구분
								AND ACTIVE_FLAG		 = 'Y'
		  			) IT 
					ON SSP.DIVISION_ID	= IT.DIVISION_ID 
					AND SSP.ITEM_ID	= IT.ITEM_ID
 
					--INNER JOIN SCM_MST_SITE TS WITH (NOLOCK)     
					--ON SSP.DIVISION_ID	= TS.DIVISION_ID
					--AND SSP.TO_SITE     = TS.SCM_SITE_ID
					--AND TS.VALID_YN     = 'Y'
		  
				--INNER JOIN scp_mst_bod_n_v BOD WITH(NOLOCK)
				--ON  SSP.DIVISION_ID = BOD.DIVISION_ID
				--AND SSP.BOD_ID      = BOD.BOD_ID

				WHERE SSP.DIVISION_ID	 = @v_division_id
					AND SSP.YYYYMMDD    >= @v_from_yyyymmdd
					AND SSP.YYYYMMDD    <= @v_to_yyyymmdd
					AND SSP.CHANGE_TYPE  = 'C'
					AND SSP.QTY          >  0
					AND (( @V_item_id		  IS NULL OR @V_item_id ='')		 OR SSP.ITEM_ID			  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
					AND (( @V_plant_site_id   IS NULL OR @V_plant_site_id ='')   OR SSP.FROM_SITE		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
					--AND (( @p_scm_site_id     IS NULL OR @p_scm_site_id ='')	   OR SSP.TO_SITE		  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_scm_site_id , ',')))
					--AND (( @p_customer	   IS NULL OR @p_customer ='')	   OR TS.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_customer , ',')))  
			
				UNION ALL

				SELECT P.DIVISION_ID
					, P.PLANT_SITE_ID	AS FROM_SITE
					, P.ITEM_ID	
					, P.YYYYMMDD
					, P.QTY
				FROM DM_PLN_SHIPMENT_REQ P WITH(NOLOCK)
				
				LEFT OUTER JOIN SCM_MST_SITE FZ WITH(NOLOCK) 
	     			ON P.DIVISION_ID	 = FZ.DIVISION_ID 
	     			AND P.PLANT_SITE_ID  = FZ.SCM_SITE_ID 
	     			AND FZ.VALID_YN	 = 'Y'
				
				--LEFT OUTER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
	   --  			ON P.DIVISION_ID	= TS.DIVISION_ID 
	   --  			AND P.SCM_SITE_ID	= TS.SCM_SITE_ID 
	   --  			AND TS.VALID_YN	= 'Y'
				WHERE P.DIVISION_ID = @v_division_id 
				    AND P.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,ISNULL(FZ.SHIP_FROZEN,0),GETDATE()),112) -- 확정구간의 다음날짜가 나오므로 >= 로 처리함
					AND (( @V_item_id			IS NULL OR @V_item_id ='')		   OR P.ITEM_ID				IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
					AND (( @V_plant_site_id		IS NULL OR @V_plant_site_id ='')   OR P.PLANT_SITE_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
					--AND (( @p_scm_site_id		IS NULL OR @p_scm_site_id ='')	OR P.SCM_SITE_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_scm_site_id , ',')))
					--AND (( @p_customer			IS NULL OR @p_customer ='')		OR TS.SOLDTO_CUSTOMER	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_customer , ',')))  
			
		) A 
		GROUP BY A.DIVISION_ID
			, A.ITEM_ID
			, A.YYYYMMDD
			, A.FROM_SITE

		
		PRINT '-------------11------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		/*TOTAL_REQ Meausre 생성*/
		INSERT INTO #TMP_ROWDATA
		SELECT DIVISION_ID
			, ITEM_ID
			, FROM_SITE		AS FROM_SITE
			, '-'			AS TO_SITE
			, 'TOTAL_REQ'		AS MEASURE
			, YYYYMMDD
			, ''				AS BOD_ID
			, SUM(QTY)		AS QTY
			, ''				AS INCOTERMS
			, ''				AS TRANSPORT_MODE
			, ''				AS FCST_TYPE	
			, 8				AS SEQ
			, NULL			AS LAST_UPDATED_BY
			, NULL			AS LAST_UPDATE_DATE
			, '-'			AS REMARK
		FROM (
				SELECT P.DIVISION_ID
					, P.PLANT_SITE_ID	AS FROM_SITE
					, P.ITEM_ID
					, P.YYYYMMDD
					, P.QTY
				FROM DM_PLN_SHIPMENT_REQ P WITH(NOLOCK)

				LEFT OUTER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
	     		ON P.DIVISION_ID = TS.DIVISION_ID 
	     			AND P.SCM_SITE_ID = TS.SCM_SITE_ID 
	     			AND TS.VALID_YN = 'Y'
					AND P.SITE_TYPE    = 'SALES'

				WHERE P.DIVISION_ID = @v_division_id 
				AND P.YYYYMMDD		>= @v_last_plan_start_yyyymmdd
				AND P.YYYYMMDD			<= @V_to_yyyymmdd
				AND (( @V_item_id		IS NULL OR @V_item_id ='')			OR P.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ','))) 
				AND (( @V_plant_site_id	IS NULL OR @V_plant_site_id ='')	OR P.PLANT_SITE_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
				--AND (( @p_scm_site_id	IS NULL OR @p_scm_site_id ='')	OR P.SCM_SITE_ID		IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_scm_site_id , ',')))
				--AND (( @p_customer		IS NULL OR @p_customer ='')		OR TS.SOLDTO_CUSTOMER	IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_customer , ',')))  
		) A 
		GROUP BY A.DIVISION_ID
			, A.ITEM_ID
			, A.YYYYMMDD
			, A.FROM_SITE
		;

		PRINT '-------------12------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		--------------------------------------------------------------------------------------------
		DECLARE @TAB_STOCK   TABLE
		(
			[DIVISION_ID]			[nvarchar](30) NOT NULL INDEX VIX_TAB_STOCK_01(DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD),
			[FROM_SITE]			    [nvarchar](30) NOT NULL,
			[ITEM_ID]				[nvarchar](150) NOT NULL,
			[YYYYMMDD]              [nvarchar](8) NULL,
			[QTY]				    [numeric](28, 10) NULL
		)

		/*BOH 계산시 사용할 재고 생성*/
		INSERT INTO @TAB_STOCK
		      (DIVISION_ID
			  ,FROM_SITE
			  ,ITEM_ID
			  ,YYYYMMDD
			  ,QTY)
		SELECT A.DIVISION_ID
			, A.FROM_SITE					AS FROM_SITE
			, A.ITEM_ID						AS ITEM_ID
			, @v_last_plan_start_yyyymmdd   AS YYYYMMDD
			, SUM(ISNULL(A.QTY, 0))			AS QTY
		--INTO #tbl_boh
		FROM SSP_ANL_SHIP_PLAN_40 A (NOLOCK)

		INNER JOIN #TblDynamic_SSP0026_40_STD ST
			ON ST.DIVISION_ID = A.DIVISION_ID
			AND ST.FROM_SITE   = A.FROM_SITE
			AND ST.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD

		WHERE  1 = 1
		AND	A.DIVISION_ID			 = @v_division_id
		AND	A.BIZ_TYPE				 = 'A'   
		AND	A.MEASURE				 = 'WH_STOCK'
		AND A.YYYYMMDD				 = @v_last_plan_start_yyyymmdd 
		AND (( @V_item_id		IS NULL OR @V_item_id ='')			OR A.ITEM_ID			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_item_id , ',')))
		AND (( @V_plant_site_id	IS NULL OR @V_plant_site_id ='')    OR A.FROM_SITE			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_plant_site_id , ',')))   		
			
		GROUP BY A.DIVISION_ID
			, A.FROM_SITE
			, A.ITEM_ID
			, A.YYYYMMDD

		;

		PRINT '-------------13------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		--WITH Z AS (
		--	SELECT DISTINCT 
		--	       DIVISION_ID
		--		  ,ITEM_ID		
		--		  ,FROM_SITE
		--		  ,o.basis_yyyymmdd AS YYYYMMDD
		--	  FROM scm_sys_calendar_m o WITH(NOLOCK, index(IDX_SCM_SYS_CALENDAR_N3)) 
		--		   CROSS APPLY (  
		--		               SELECT DISTINCT 
		--					          DIVISION_ID
		--						     ,ITEM_ID
		--						     ,FROM_SITE
		--						 FROM #TMP_ROWDATA  WITH(NOLOCK) 
		--						)  R
		--	 WHERE o.basis_yyyymmdd >= @v_last_plan_start_yyyymmdd
		--	   AND o.basis_yyyymmdd <= @v_to_yyyymmdd
		--),
		--QTY AS (
		--	SELECT  
		--		X.DIVISION_ID
		--		, X.ITEM_ID
		--		, X.FROM_SITE
		--		, X.YYYYMMDD
		--		, ISNULL( SUM(CASE  WHEN X.MEASURE= 'TOTAL_PLAN'   THEN -1 * ISNULL(X.QTY,0)
		--							WHEN X.MEASURE= 'WH_IN' THEN ISNULL(X.QTY,0)
		--							ELSE 0.0  
		--			END),0)  AS PLAN_QTY
		--		, ISNULL( SUM(CASE  WHEN X.MEASURE= 'TOTAL_REQ'   THEN -1 * ISNULL(X.QTY,0)
		--							WHEN X.MEASURE= 'WH_IN' THEN ISNULL(X.QTY,0)
		--							ELSE 0.0  
		--			END),0) AS REQ_QTY
		--	FROM #TMP_ROWDATA X WITH(NOLOCK)   
		--	WHERE 1 = 1  
		--	AND X.MEASURE IN ( 'TOTAL_PLAN', 'TOTAL_REQ', 'WH_IN')
		--	AND X.YYYYMMDD >= @v_last_plan_start_yyyymmdd
		--	GROUP BY X.DIVISION_ID, X.ITEM_ID, X.FROM_SITE, X.YYYYMMDD
		--),
		--BOH AS (   
		
		--	SELECT
		--			V.DIVISION_ID
		--			, ITEM_ID
		--			, FROM_SITE
		--			, YYYYMMDD
		--			, SUM(QTY) AS QTY
		--		FROM (
		--			SELECT	  inv.division_id
		--					, inv.item_id
  -- 							, inv.FROM_SITE     AS FROM_SITE
		--					, inv.yyyymmdd		AS YYYYMMDD
  --							, inv.QTY           AS QTY
		--			--FROM   #tbl_boh	inv WITH (NOLOCK)  	
		--			FROM   @TAB_STOCK	inv --WITH (NOLOCK)  	
		--			WHERE  1=1
		--			AND inv.DIVISION_ID = @v_division_id
		--			AND ( ( @p_scm_site_id IS NULL OR         @p_scm_site_id         ='' ) OR inv.FROM_SITE         IN (SELECT token FROM dbo.String_Split(@p_scm_site_id    ,',')) )
		--			AND ( ( @p_item_id IS NULL OR    @p_item_id     ='' )	OR inv.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
		--		) V 
		--		WHERE 1 = 1
		--		AND V.DIVISION_ID  =  @v_division_id
		--		GROUP BY DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD
		--)

		--INSERT INTO #TMP_ROWDATA
		--SELECT   
		--		  Z.DIVISION_ID
		--		, Z.ITEM_ID		AS ITEM_ID
		--		, Z.FROM_SITE	AS FROM_SITE
		--		, '-'			AS TO_SITE
		--		, 'WH_BOH_PLAN'	AS MEASURE			
		--		,  Z.YYYYMMDD   AS yyyymmdd
		--		, ''			AS BOD_ID
		--		,( SELECT  
		--				ISNULL( SUM(PLAN_QTY),0)   
		--			FROM QTY X WITH(NOLOCK)   
		--			WHERE 1=1  
		--			AND X.DIVISION_ID          = Z.DIVISION_ID  
		--			AND X.ITEM_ID			   = Z.ITEM_ID           
		--			AND X.FROM_SITE            = Z.FROM_SITE  
		--			AND X.YYYYMMDD             < Z.YYYYMMDD        ) + ISNULL(BOH.QTY,0) AS QTY  
		--		, ''				AS INCOTERMS
		--		, ''				AS TRANSPORT_MODE
		--		, ''				AS FCST_TYPE	
		--		, 10				AS SEQ
		--		, NULL			AS LAST_UPDATED_BY
		--		, NULL			AS LAST_UPDATE_DATE
		--		, '-'			AS REMARK
		--FROM Z WITH(NOLOCK)  
		--LEFT OUTER JOIN BOH WITH(NOLOCK) 
		--				ON  Z.DIVISION_ID		= BOH.DIVISION_ID  
		--				AND Z.ITEM_ID			= BOH.ITEM_ID  
		--				AND Z.FROM_SITE			= BOH.FROM_SITE 


		--UNION ALL

		--SELECT   
		--		  Z.DIVISION_ID
		--		, Z.ITEM_ID		AS ITEM_ID
		--		, Z.FROM_SITE	AS FROM_SITE
		--		, '-'			AS TO_SITE
		--		, 'WH_BOH_REQ'	AS MEASURE
		--		,  Z.YYYYMMDD   AS yyyymmdd
		--		, ''			AS BOD_ID
		--		,( SELECT  
		--				ISNULL( SUM(REQ_QTY),0)   
		--			FROM QTY X WITH(NOLOCK)   
		--			WHERE 1 = 1  
		--			AND X.DIVISION_ID          = Z.DIVISION_ID  
		--			AND X.ITEM_ID			   = Z.ITEM_ID           
		--			AND X.FROM_SITE            = Z.FROM_SITE  
		--			AND X.YYYYMMDD             < Z.YYYYMMDD        ) + ISNULL(BOH.QTY,0) AS QTY
		--		, ''				AS INCOTERMS
		--		, ''				AS TRANSPORT_MODE
		--		, ''				AS FCST_TYPE	
		--		, 10				AS SEQ
		--		, NULL			AS LAST_UPDATED_BY
		--		, NULL			AS LAST_UPDATE_DATE
		--		, '-'			AS REMARK
		--FROM Z WITH(NOLOCK)  
		--LEFT OUTER JOIN BOH WITH(NOLOCK) 
		--				ON  Z.DIVISION_ID		= BOH.DIVISION_ID  
		--				AND Z.ITEM_ID			= BOH.ITEM_ID  
		--				AND Z.FROM_SITE			= BOH.FROM_SITE  
		--;

		INSERT INTO #Z (
		       [DIVISION_ID]
			  ,[ITEM_ID]	
			  ,[FROM_SITE]	
			  ,[YYYYMMDD]  )
		SELECT DISTINCT 
		       DIVISION_ID
			  ,ITEM_ID		
			  ,FROM_SITE
			  ,o.basis_yyyymmdd AS YYYYMMDD
		  FROM scm_sys_calendar_m o WITH(NOLOCK, index(IDX_SCM_SYS_CALENDAR_N3)) 
			   CROSS APPLY (  
					SELECT DISTINCT 
					       DIVISION_ID
						  ,ITEM_ID
						  ,FROM_SITE
					  FROM #TMP_ROWDATA WITH(NOLOCK) 
							) R
		 WHERE o.basis_yyyymmdd >= @v_last_plan_start_yyyymmdd
		   AND o.basis_yyyymmdd <= @v_to_yyyymmdd
		   ;


		INSERT INTO #QTY (
               [DIVISION_ID]
              ,[ITEM_ID]
              ,[FROM_SITE]
              ,[YYYYMMDD]
              ,[PLAN_QTY]
              ,[REQ_QTY]
			  )
		SELECT X.DIVISION_ID
			  ,X.ITEM_ID
			  ,X.FROM_SITE
			  ,X.YYYYMMDD
			  ,ISNULL(SUM(CASE WHEN X.MEASURE= 'TOTAL_PLAN' THEN -1 * ISNULL(X.QTY,0)
							   WHEN X.MEASURE= 'WH_IN'      THEN ISNULL(X.QTY,0)
							   ELSE 0.0  
					       END), 0)		AS PLAN_QTY
			  ,ISNULL(SUM(CASE WHEN X.MEASURE= 'TOTAL_REQ'   THEN -1 * ISNULL(X.QTY,0)
							   WHEN X.MEASURE= 'WH_IN' THEN ISNULL(X.QTY,0)
							   ELSE 0.0  
					       END), 0)		AS REQ_QTY
		 FROM #TMP_ROWDATA X WITH(NOLOCK)   
		WHERE 1 = 1  
		  AND X.MEASURE IN ( 'TOTAL_PLAN', 'TOTAL_REQ', 'WH_IN')
		  AND X.YYYYMMDD >= @v_last_plan_start_yyyymmdd
		GROUP BY 
		      X.DIVISION_ID
			 ,X.ITEM_ID
			 ,X.FROM_SITE
			 ,X.YYYYMMDD
			;


		INSERT INTO #BOH (
               [DIVISION_ID]
              ,[ITEM_ID]
              ,[FROM_SITE]
              ,[YYYYMMDD]
              ,[QTY]
			  )
		SELECT
			   V.DIVISION_ID
			  ,ITEM_ID
			  ,FROM_SITE
			  ,YYYYMMDD
			  ,SUM(QTY) AS QTY
		  FROM (
					SELECT	  inv.division_id
							, inv.item_id
   							, inv.FROM_SITE     AS FROM_SITE
							, inv.yyyymmdd		AS YYYYMMDD
  							, inv.QTY           AS QTY
					FROM   @TAB_STOCK	inv --WITH (NOLOCK)  	
					WHERE  1 = 1
					AND inv.DIVISION_ID = @v_division_id
					AND ( ( @p_scm_site_id IS NULL OR         @p_scm_site_id         ='' ) OR inv.FROM_SITE         IN (SELECT token FROM dbo.String_Split(@p_scm_site_id    ,',')) )
					AND ( ( @p_item_id IS NULL OR    @p_item_id     ='' )	OR inv.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
				) V 
				WHERE 1 = 1
				AND V.DIVISION_ID  =  @v_division_id
				GROUP BY DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD
				;


		INSERT INTO #TMP_ROWDATA (
			   DIVISION_ID			
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
		      ,LAST_UPDATED_BY	
		      ,LAST_UPDATE_DATE  
		      ,REMARK			
			  )
		SELECT Z.DIVISION_ID
			  ,Z.ITEM_ID		AS ITEM_ID
			  ,Z.FROM_SITE		AS FROM_SITE
			  ,'-'				AS TO_SITE
			  ,'WH_BOH_PLAN'	AS MEASURE			
			  , Z.YYYYMMDD		AS YYYYMMDD
			  ,''				AS BOD_ID
			  ,(SELECT ISNULL(SUM(PLAN_QTY), 0)   
			  	  FROM #QTY X   
			  	 WHERE 1 = 1  
			  	   AND X.DIVISION_ID    = Z.DIVISION_ID  
			  	   AND X.ITEM_ID		= Z.ITEM_ID           
			  	   AND X.FROM_SITE      = Z.FROM_SITE  
			  	   AND X.YYYYMMDD       < Z.YYYYMMDD        
			   ) + ISNULL(BOH.QTY,0)	AS QTY  
			  ,''				AS INCOTERMS
			  ,''				AS TRANSPORT_MODE
			  ,''				AS FCST_TYPE	
			  ,10				AS SEQ
			  ,NULL				AS LAST_UPDATED_BY
			  ,NULL				AS LAST_UPDATE_DATE
			  ,'-'				AS REMARK
		  FROM #Z AS Z WITH(NOLOCK) 
		       LEFT OUTER JOIN #BOH AS BOH WITH(NOLOCK) 
		    ON Z.DIVISION_ID		= BOH.DIVISION_ID  
		   AND Z.ITEM_ID			= BOH.ITEM_ID  
		   AND Z.FROM_SITE			= BOH.FROM_SITE 

		UNION ALL

		SELECT Z.DIVISION_ID
			  ,Z.ITEM_ID		AS ITEM_ID
			  ,Z.FROM_SITE		AS FROM_SITE
			  ,'-'				AS TO_SITE
			  ,'WH_BOH_REQ'		AS MEASURE
			  , Z.YYYYMMDD		AS YYYYMMDD
			  ,''				AS BOD_ID
			  ,(SELECT ISNULL(SUM(REQ_QTY),0)   
			  	  FROM #QTY X WITH(NOLOCK)  
			  	 WHERE 1 = 1  
			  	   AND X.DIVISION_ID         = Z.DIVISION_ID  
			  	   AND X.ITEM_ID			 = Z.ITEM_ID           
			  	   AND X.FROM_SITE           = Z.FROM_SITE  
			  	   AND X.YYYYMMDD            < Z.YYYYMMDD        
			    ) + ISNULL(BOH.QTY,0)	AS QTY
			  ,''				AS INCOTERMS
			  ,''				AS TRANSPORT_MODE
			  ,''				AS FCST_TYPE	
			  ,10				AS SEQ
			  ,NULL				AS LAST_UPDATED_BY
			  ,NULL				AS LAST_UPDATE_DATE
			  ,'-'				AS REMARK
		  FROM #Z AS Z WITH(NOLOCK) 
		       LEFT OUTER JOIN #BOH AS BOH WITH(NOLOCK) 
		    ON Z.DIVISION_ID		= BOH.DIVISION_ID  
		   AND Z.ITEM_ID			= BOH.ITEM_ID  
		   AND Z.FROM_SITE			= BOH.FROM_SITE  
		;


		PRINT '-------------14------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		SELECT T0.DIVISION_ID
		,	  T0.ITEM_ID
		,	  T0.FROM_SITE
		,	  T0.TO_SITE
		,      T0.MEASURE
		,	  T0.YYYYMMDD
		,	  T0.BOD_ID
		,	  T0.QTY
		,	  T0.INCOTERMS
		,	  T0.TRANSPORT_MODE
		,	  T0.FCST_TYPE		
		,	  T0.LAST_UPDATED_BY
		,      T0.REMARK
		,	  RANK() OVER(PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE, T0.BOD_ID, T0.FCST_TYPE ORDER BY T0.ITEM_ID DESC , T0.LAST_UPDATE_DATE ) AS RN
		INTO #TMP_ROWDATA_RN
		FROM 
		(		
					
			SELECT *
			FROM	#TMP_ROWDATA A WITH(NOLOCK)          
			WHERE	A.DIVISION_ID	= @v_division_id
			AND		A.YYYYMMDD	>= @v_from_yyyymmdd
			AND		A.YYYYMMDD	<= @v_to_yyyymmdd
		) T0
		WHERE 1 = 1


		PRINT '-------------15------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		INSERT INTO #TMP_RESULT_TABLE
		(
			DIVISION_ID
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
			,X.SEQ
		FROM  
		(
				SELECT DISTINCT T.DIVISION_ID 
				,     T.ITEM_ID
				,	 ISNULL(T.FROM_SITE,'-') AS FROM_SITE
				,	 ISNULL(T.TO_SITE,'-')	AS TO_SITE
				,	 T.BOD_ID
				,	 T.QTY
				,	 T.INCOTERMS
				,	 T.TRANSPORT_MODE
				,	 T.FCST_TYPE
				,     TT1.COLUMN_NAME		 AS MEASURE 
				,	 TT1.COLUMN_LABEL_NAME	 AS MEASURE_NAME																									
				,	 TT1.ATTRIBUTE3		 AS BACK_COLOR							
				,	 TT1.SORT_ORDER_NO		 AS SEQ
				,     T.YYYYMMDD				  
				FROM  #TMP_ROWDATA T WITH(NOLOCK) 
				
				INNER JOIN SCM_MST_SHEET_MEASURE TT1 WITH(NOLOCK)
				     ON TT1.PROGRAM_ID = @P_PROGRAM_ID
					AND TT1.SHEET_NAME = @V_SHEET_NAME	
						
				WHERE 1=1
		) X
		LEFT OUTER JOIN  #TMP_ROWDATA R WITH(NOLOCK) 
			ON R.DIVISION_ID		= X.DIVISION_ID
			AND R.ITEM_ID			= X.ITEM_ID
			AND R.MEASURE			= X.MEASURE
			AND R.YYYYMMDD			= X.YYYYMMDD
			AND R.FROM_SITE			= X.FROM_SITE
			AND R.TO_SITE			= X.TO_SITE
		WHERE X.TO_SITE = '-'	
		AND  X.MEASURE IN (	'WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','POSTP_PLAN', 'SITE_MOVE','WH_IN') 
			
		UNION ALL

		SELECT DISTINCT 
			  X.DIVISION_ID
			, X.ITEM_ID
			, X.FROM_SITE
			, X.TO_SITE 
			, X.MEASURE
			, X.YYYYMMDD
			,ISNULL(X.BOD_ID,'-')				AS BOD_ID
			,ISNULL(R.QTY,0)					AS QTY
			,ISNULL(X.INCOTERMS,'-')				AS INCOTERMS
			,ISNULL(X.TRANSPORT_MODE,'-')			AS TRANSPORT_MODE
			,ISNULL(X.FCST_TYPE,'-')				AS FCST_TYPE
			,X.SEQ
		FROM  
		(
				SELECT DISTINCT T.DIVISION_ID 
				,      T.ITEM_ID
				,	 ISNULL(T.FROM_SITE,'-')		AS FROM_SITE
				,	 ISNULL(T.TO_SITE,'-')		AS TO_SITE
				,	 T.BOD_ID
				,	 T.QTY
				,	 T.INCOTERMS
				,	 T.TRANSPORT_MODE
				,	 T.FCST_TYPE
				,      TT1.COLUMN_NAME			AS MEASURE 
				,	 TT1.COLUMN_LABEL_NAME		AS MEASURE_NAME																									
				,	 TT1.ATTRIBUTE3			AS BACK_COLOR							
				,	 TT1.SORT_ORDER_NO			AS SEQ
				,      T.YYYYMMDD					  
				FROM  #TMP_ROWDATA T WITH(NOLOCK) 
				
				INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)                                                      
					ON T.DIVISION_ID	= TS.DIVISION_ID                                                           
					AND T.TO_SITE		= TS.SCM_SITE_ID                                                              
					AND TS.VALID_YN	= 'Y'
					AND TS.SITE_TYPE	= 'SALES'
				
				LEFT JOIN SCM_MST_SHEET_MEASURE TT1 WITH(NOLOCK)
				     ON TT1.PROGRAM_ID	= @P_PROGRAM_ID
					AND TT1.SHEET_NAME	= @V_SHEET_NAME	
		) X
		LEFT OUTER JOIN  #TMP_ROWDATA R WITH(NOLOCK) 
			ON R.DIVISION_ID		= X.DIVISION_ID
			AND R.ITEM_ID			= X.ITEM_ID
			AND R.MEASURE			= X.MEASURE
			AND R.YYYYMMDD			= X.YYYYMMDD
			AND R.FROM_SITE			= X.FROM_SITE
			AND R.TO_SITE			= X.TO_SITE
			AND R.BOD_ID			= X.BOD_ID
			AND R.FCST_TYPE			= X.FCST_TYPE
		WHERE X.TO_SITE != '-'	
		AND  X.MEASURE IN (	'SCP_SHIP_PLAN','SHIP_REQ','SHIP_PLAN')

		PRINT '-------------151-----------: ' +  CONVERT(CHAR(23), getdate(), 21);

	--	-------------------------------------------------
	--	---- Requestor
	--	-------------------------------------------------
		SELECT DIVISION_ID, FROM_SITE,TO_SITE,ITEM_ID,MEASURE, BOD_ID,  LAST_UPDATED_BY, REMARK, FCST_TYPE
		INTO #TblDynamic_REQUESTOR
		FROM (
			SELECT DIVISION_ID,FROM_SITE,TO_SITE,ITEM_ID,MEASURE, BOD_ID , LAST_UPDATED_BY, REMARK, FCST_TYPE
				, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID,FROM_SITE,TO_SITE,ITEM_ID,MEASURE, BOD_ID, FCST_TYPE ORDER BY RN DESC ) AS RN2
			FROM #TMP_ROWDATA_RN WITH(NOLOCK)
			) X
		WHERE RN2 = 1
		AND MEASURE NOT IN ('WH_BOH_PLAN','WH_BOH_REQ','TOTAL_PLAN','TOTAL_REQ','SITE_MOVE','POSTP_PLAN','WH_IN') ;
		
	--	--////////////////////////////////////////////////////////////////////////////////--
	--	--//5. PIVOT				 													//--
	--	--////////////////////////////////////////////////////////////////////////////////--

		--SELECT * FROM #TMP_RESULT_TABLE ;
		PRINT '-------------16------------: ' +  CONVERT(CHAR(23), getdate(), 21);
		SELECT DISTINCT T0.DIVISION_ID
		,	  T0.ITEM_ID	
		,	  TEAM.DEPT_NAME_KO
		,	  TEAM.DEPT_ID
		,	  T0.FROM_SITE
		,	  T0.TO_SITE
		,	  T4.SOLDTO_CUSTOMER
		,      T0.MEASURE
		,	  T0.BOD_ID
		,	  'D_' + T0.YYYYMMDD						AS YYYYMMDD		
		,	  T1.BASIS_YYYYMM							AS YYYYMM
		,	  RIGHT(T1.BASIS_YYYYMM,4) + T1.ISO_WEEK		AS ISO_WEEK
		,	  T0.QTY
		,	  T0.INCOTERMS
		,	  T0.TRANSPORT_MODE
		,	  T0.FCST_TYPE
		,	  T0.SEQ
		,	  T5.SHIP_FROZEN
		,	  RANK() OVER (PARTITION BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE,	T0.BOD_ID ORDER BY T0.MEASURE, CASE WHEN T0.YYYYMMDD IS NULL THEN 'N' ELSE  'Y' END  DESC
				) AS ROW_NUM
		INTO #TMP_RESULT_PIVOT_TABLE_TEMP
		FROM #TMP_RESULT_TABLE T0

		-- MEASURE가 10개가 안돼면 화면에 Display 하지 않음
		INNER JOIN (SELECT AAA.ITEM_ID, AAA.FROM_SITE, COUNT(*) AS CNT 
		FROM (
				SELECT DISTINCT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE 
				FROM  #TMP_RESULT_TABLE  
			) AAA
		GROUP BY AAA.ITEM_ID, AAA.FROM_SITE
		HAVING COUNT(*) >=10) MC
			ON T0.ITEM_ID    = MC.ITEM_ID
			AND T0.FROM_SITE = MC.FROM_SITE

		LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                      
			ON T0.DIVISION_ID = T4.DIVISION_ID                                                           
			AND T0.TO_SITE = T4.SCM_SITE_ID                                                              
			AND T4.VALID_YN = 'Y' 
		
		LEFT OUTER JOIN SCM_MST_SITE T5 WITH(NOLOCK)                                                      
			ON T0.DIVISION_ID = T5.DIVISION_ID                                                           
			AND T0.FROM_SITE = T5.SCM_SITE_ID                                                              
			AND T5.VALID_YN = 'Y' 

		LEFT OUTER JOIN SCM_MST_SITE_ITEM T6 WITH(NOLOCK)       -- 해당 ITEM_ID MCCE121501A2  SCM_MST_SITE_ITEM PROJECT_CODE 두개 확인!                                                  
			ON T6.DIVISION_ID = T0.DIVISION_ID                                                           
			AND T6.SCM_SITE_ID = T0.TO_SITE                                                              
			AND T6.ITEM_ID = T0.ITEM_ID                                                                 
	                                        

		LEFT OUTER  JOIN SCM_SYS_CALENDAR_M T1 WITH(NOLOCK)
			ON T0.YYYYMMDD = T1.BASIS_YYYYMMDD	


		LEFT  JOIN (																				
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 					
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)													
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)											
			ON B.DEPT_ID = C.DEPT_ID															
		) AS TEAM
		ON TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](T6.owner, ','))	
		WHERE 1=1
		;
		PRINT '-------------17------------: ' +  CONVERT(CHAR(23), getdate(), 21);

		--AND (( @p_team_id   IS NULL OR @p_team_id ='')   OR T0.DEPT_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_team_id , ',')))    

		SELECT A.*
		INTO #TMP_RESULT_PIVOT_TABLE 
		FROM #TMP_RESULT_PIVOT_TABLE_TEMP A
		WHERE A.ITEM_ID IN (
			SELECT DISTINCT ITEM_ID  
			FROM #TMP_RESULT_PIVOT_TABLE_TEMP A
			WHERE 1=1 --A.DEPT_ID = '58260040'
			AND (( @V_team_id   IS NULL OR @V_team_id ='')   OR A.DEPT_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_team_id , ',')))   
		)

		--SELECT * FROM #TMP_ROWDATA WHERE MEASURE = 'WH_BOH_PLAN' ORDER BY YYYYMMDD ASC
		     
		--SELECT * FROM #TMP_RESULT_TABLE P  ; --WHERE MEASURE = 'WH_BOH_REQ'

		--SELECT * FROM #TMP_RESULT_PIVOT_TABLE WHERE MEASURE = 'WH_BOH_PLAN';



		--select * from #TMP_RESULT_PIVOT_TABLE

	--	/*PIVOIT처리*******************************************************************************/
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
					FROM [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE

					UNION ALL

					SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
							,MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
					FROM [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME		
					UNION ALL

					SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD      
							,A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
					FROM [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
					WHERE A.BASIS_YYYYMMDD  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY A.BASIS_YYYYMMDD	
					-------------------------------------------------------------------------
					) AS A
			ORDER BY SORT_ORDER_NO  ;
		END;
	--	--//END PIVOT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
	--	--////////////////////////////////////////////////////////////////////////////////--
	--	--//6. RESULT				 													//--
	--	--////////////////////////////////////////////////////////////////////////////////--

		SET @MEXEC = 'SELECT DISTINCT TTT.* FROM ( '
		SET @MEXEC = @MEXEC+'	SELECT  																											' + CHAR(10);
		SET @MEXEC = @MEXEC+'       	 T0.DIVISION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'       	, T0.ITEM_ID	AS MODEL_ID 																									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'       	, ISNULL(IT.NICK_NAME,''-'')		AS NICK_NAME																								' + CHAR(10);
		SET @MEXEC = @MEXEC+'       	, [dbo].[FN_GET_ITEM_NICKNAME](T0.DIVISION_ID,T0.ITEM_ID)		AS NICK_NAME																								' + CHAR(10);
		--SET @MEXEC = @MEXEC+'         , T0.DEPT_NAME_KO			 AS TEAM_NAME_KO																	' + CHAR(10);
		--SET @MEXEC = @MEXEC+'         , T0.DEPT_ID				 AS DEPT_ID																	' + CHAR(10);
		
		SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.DEPT_NAME_KO,''-'') ELSE ''-'' END				 AS TEAM_NAME_KO																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.DEPT_ID,''-'') ELSE ''-'' END				 AS DEPT_ID																	' + CHAR(10);
		--SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.FROM_SITE,''-'') ELSE ''-'' END				 AS FROM_SITE																	' + CHAR(10);
		--SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T4.SITE_DESCRIPTION,''-'') ELSE ''-'' END				 AS SITE_DESCRIPTION																	' + CHAR(10);
		--SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.TO_SITE,''-'') ELSE ''-'' END				 AS TO_SITE																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'         , T0.FROM_SITE			 AS FROM_SITE																	' + CHAR(10);
		--SET @MEXEC = @MEXEC+'         , T4.SITE_DESCRIPTION			 AS SITE_DESCRIPTION																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'         , T0.TO_SITE				 AS TO_SITE																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'         , T0.MEASURE							 																			' + CHAR(10);		
		SET @MEXEC = @MEXEC+'       	, T2.SORT_ORDER_NO				AS SORT_ORDER_NO																								' + CHAR(10);
		SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.BOD_ID,''-'') ELSE ''-'' END				 AS BOD_ID																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.INCOTERMS,''-'') ELSE ''-'' END				 AS INCOTERMS																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.TRANSPORT_MODE,''-'') ELSE ''-'' END				 AS TR_MODE																	' + CHAR(10);	
		SET @MEXEC = @MEXEC+'         , ISNULL(T0.FCST_TYPE,''-'')					AS FCST_TYPE																			' + CHAR(10);			
		SET @MEXEC = @MEXEC+'         , CASE WHEN (T2.SORT_ORDER_NO = 1 OR T2.SORT_ORDER_NO = 2 OR T2.SORT_ORDER_NO = 3)  THEN ISNULL(T0.SOLDTO_CUSTOMER,''-'') ELSE ''-'' END				 AS END_CUSTOMER																	' + CHAR(10);	
		SET @MEXEC = @MEXEC+'         , ISNULL(R.REMARK,''-'')  AS REMARK			'+CHAR(10);
		SET @MEXEC = @MEXEC+'         , CONVERT(CHAR(8), DATEADD(DD, ISNULL(T0.SHIP_FROZEN,0) - 1, CONVERT(VARCHAR, '''+ @v_last_plan_start_yyyymmdd + ''', 121)), 112) AS SHIP_FROZEN	'+CHAR(10);
		SET @MEXEC = @MEXEC+'         , CASE WHEN ISNULL(C.USERNAME,'''') <> '''' THEN C.USERNAME + ''('' + R.LAST_UPDATED_BY + '')'' ELSE ISNULL(R.LAST_UPDATED_BY,''-'') END AS LAST_UPDATED_BY			'+CHAR(10);
		SET @MEXEC = @MEXEC+'       	' + @MQRY_SUM																										  + CHAR(10);
		SET @MEXEC = @MEXEC+'       FROM #TMP_RESULT_PIVOT_TABLE T0 WITH(NOLOCK)																			     ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		INNER JOIN SCM_MST_SHEET_MEASURE T2	WITH(NOLOCK)																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ON T0.MEASURE = T2.COLUMN_NAME																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T2.PROGRAM_ID = ''' + @P_PROGRAM_ID + '''																		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T2.SHEET_NAME = ''' + @V_SHEET_NAME + '''																		' + CHAR(10);
		SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN SCM_MST_TITLESET_USER T3 WITH(NOLOCK)                                                                                       ' + CHAR(10) ;
		SET @MEXEC = @MEXEC+'			ON T3.PROGRAM_ID = T2.PROGRAM_ID                                                                                                       ' + CHAR(10) ;
		SET @MEXEC = @MEXEC+'			AND T3.SHEET_NAME = T2.SHEET_NAME                                                                                                      ' + CHAR(10) ;
		SET @MEXEC = @MEXEC+'			AND T3.COLUMN_NAME = T2.COLUMN_NAME                                                                                                    ' + CHAR(10) ;
		SET @MEXEC = @MEXEC+'			AND T3.USER_ID = ''' + @p_created_by + '''                                                                                                ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'		INNER JOIN SCM_MST_SITE T4 WITH(NOLOCK)                                                                                       ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = T4.DIVISION_ID                                                                                                       ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'			AND T0.FROM_SITE = T4.SCM_SITE_ID                                                                                                      ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'			AND T4.VALID_YN = ''Y''                                                                                                 ' + CHAR(10) ;
		
		--SET @MEXEC = @MEXEC+'		INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME											     ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'				    FROM SCM_MST_ITEM_SN WITH (NOLOCK)															     ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'				   WHERE DIVISION_ID =  ''' + @v_division_id + '''    													' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'					AND ACTIVE_FLAG = ''Y''																	     ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'					AND SCP_OPERATION_GROUP = ''A''  -- CELL/PACK 구분													' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'				  ) IT 																					     ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = IT.DIVISION_ID AND T0.ITEM_ID = IT.ITEM_ID												' + CHAR(10) ;
		SET @MEXEC = @MEXEC+'         LEFT OUTER JOIN  #TblDynamic_REQUESTOR R	ON R.DIVISION_ID = T0.DIVISION_ID		'+CHAR(10);
		SET @MEXEC = @MEXEC+'											AND R.ITEM_ID = T0.ITEM_ID			'+CHAR(10);
		SET @MEXEC = @MEXEC+'											AND R.FROM_SITE = T0.FROM_SITE		'+CHAR(10);
		SET @MEXEC = @MEXEC+'											AND R.TO_SITE = T0.TO_SITE			'+CHAR(10);
		SET @MEXEC = @MEXEC+'											AND R.BOD_ID = T0.BOD_ID				'+CHAR(10);
		SET @MEXEC = @MEXEC+'											AND R.FCST_TYPE = T0.FCST_TYPE				'+CHAR(10);
		SET @MEXEC = @MEXEC+'											AND R.MEASURE = T0.MEASURE			'+CHAR(10);
		SET @MEXEC = @MEXEC+'         LEFT OUTER JOIN (SELECT UserID, UserName FROM TB_FX_User WITH(NOLOCK)) C     '+CHAR(10);
		SET @MEXEC = @MEXEC+'                                           ON R.LAST_UPDATED_BY = C.UserID     '+CHAR(10);
		SET @MEXEC = @MEXEC+'		WHERE 1 = 1																										' + CHAR(10);
		--SET @MEXEC = @MEXEC+'		AND T2.PROGRAM_ID = ''' + @P_PROGRAM_ID + '''                                                                                               ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'		AND T2.SHEET_NAME = ''' + @P_SHEET_NAME + '''                                                                                               ' + CHAR(10) ;
		--SET @MEXEC = @MEXEC+'		AND T2.VALID_YN = ''Y''                                                                                                                     ' + CHAR(10) ;
		SET @MEXEC = @MEXEC+'		AND T0.ROW_NUM = ''1''                                                                                                                     ' + CHAR(10) ;
		--IF (@p_plant_site_id IS NOT NULL AND @p_plant_site_id !='')
		--	SET @MEXEC = @MEXEC+'		AND (( '''+@p_plant_site_id+'''   IS NULL OR '''+@p_plant_site_id+''' ='''')   OR T0.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_plant_site_id+''' , '','')))                                                                                                 ' + CHAR(10) ;
		--IF (@p_scm_site_id IS NOT NULL AND @p_scm_site_id !='')
		--	SET @MEXEC = @MEXEC+'		AND (( '''+@p_scm_site_id+'''   IS NULL OR '''+@p_scm_site_id+''' ='''')   OR T0.TO_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_scm_site_id+''' , '','')))                                                                                                 ' + CHAR(10) ;
		----IF (@p_customer IS NOT NULL AND @p_customer !='')
		----	SET @MEXEC = @MEXEC+'		AND (( '''+@p_customer+'''   IS NULL OR '''+@p_customer+''' ='''')   OR T0.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_customer+''' , '','')))                                                                                                 ' + CHAR(10) ;
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
		SET @MEXEC = @MEXEC+'		GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.DEPT_NAME_KO, T0.DEPT_ID, T0.FROM_SITE, T0.TO_SITE, T0.MEASURE,T0.SHIP_FROZEN, T0.BOD_ID, T0.INCOTERMS, T0.TRANSPORT_MODE, T0.FCST_TYPE,T0.SOLDTO_CUSTOMER,R.REMARK, R.LAST_UPDATED_BY,C.USERNAME, T2.SORT_ORDER_NO' + CHAR(10);
		SET @MEXEC = @MEXEC+'	) TTT' + CHAR(10);
		SET @MEXEC = @MEXEC+'		ORDER BY TTT.DIVISION_ID, TTT.MODEL_ID, TTT.FROM_SITE DESC, TTT.TO_SITE DESC, TTT.FCST_TYPE, TTT.DEPT_ID, TTT.INCOTERMS, TTT.TR_MODE, TTT.SORT_ORDER_NO ASC		' + CHAR(10);

		--PRINT @MEXEC;
		EXEC(@MEXEC);

	END
	--//END RESULT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

	/********************************************************************************
	* 임시테이블 삭제
	********************************************************************************/
	-- MEASURE JOIN 처리용
	IF OBJECT_ID('tempdb..#Tbl_boh') IS NOT NULL	
		DROP TABLE #Tbl_boh;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('TEMPDB..#TMP_ROWDATA') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA;

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
