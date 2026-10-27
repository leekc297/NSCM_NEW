
CREATE PROCEDURE [dbo].[PR_SCM_OF_PACK_TO_CELL ]
      @p_master_id nvarchar(MAX) = '-' 
	, @p_plan_id   nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/*********************************************************************************************/
/** 프로그램 ID	: PR_SCM_OF_PACK_TO_CELL													**/
/** 프로그램 명	: 셀 가시성 화면 조회용														**/
/** 설 명		: PACK Item 기준의 투입수량을 CELL Item 기준으로 변환하여 소요량을 산출한다.	**/
/** Version		: 1.0.0                                                                     **/
/**																							**/
/** Argument																				**/
/**																							**/
/** [검색 조건]																				**/
/**																							**/
/** [Biz Logic]																				**/
/**																							**/
/**-----------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유													**/
/**=========================================================================================**/
/** 2019.09.19    LHS			최초 작성													**/ 
/** 2019.11.29    LHS			BOM PRIORITY 중복으로 수정함.								**/ 
/** 2020.09.15    CYS			Hazel Park Plant 는 CMI 로 통합하여 보여줌 	(D.20200915~R.0915.01)			**/
/** 2020.12.29    CYS			DW Intransit 을 SSP Intransit 으로 변경 	(D.20201229~R.1229.01)			**/
/** 2021.05.07    CYS			Buf table 을 Temp table 로 변경(잦은 락 발생) 	(D.20210507~R.0510.01)			**/
/*********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_PACK_TO_CELL'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  DECLARE @sysdate          DATETIME2 = GETDATE()

  -- 사용자 변수 설정
  DECLARE @V_INSTANCE_DATE  date
  DECLARE @V_SITE_ID        nvarchar(30)
  DECLARE @V_COMPANY_ID     nvarchar(30)
  DECLARE @V_DIVISION_ID    nvarchar(30)
  DECLARE @V_PLANT_ID       nvarchar(30)
  DECLARE @v_plan_type      nvarchar(30)
  DECLARE @V_BASIS_TIME  NVARCHAR(30)    ----+ (20190930) ADD

  --DECLARE @v_temp1        nvarchar(1000)
  --DECLARE @v_temp2        nvarchar(1000)
  
  -------------------------------------------------------------------------------------------

  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  	BEGIN TRY
    	
  		IF OBJECT_ID('tempdb..#tempTH_BUF_VB_PACK_BOM') IS NOT NULL
		DROP TABLE #tempTH_BUF_VB_PACK_BOM
	
		CREATE TABLE #tempTH_BUF_VB_PACK_BOM (
								[INSTANCE_ID] [NVARCHAR](30) NOT NULL,
								[FP_PLAN_ID] [NVARCHAR](30) NOT NULL,
								[COMPANY_ID] [NVARCHAR](30) NOT NULL,
								[DIVISION_ID] [NVARCHAR](30) NOT NULL,
								[SITE_ID] [NVARCHAR](30) NOT NULL,
								[PLANT_ID] [NVARCHAR](30) NOT NULL,
								[PARENT_ITEM_ID] [NVARCHAR](150) NOT NULL,
								[CHILD_ITEM_ID] [NVARCHAR](150) NOT NULL,
								[BOM_RATE] [NUMERIC](20, 10) DEFAULT 1 NOT NULL,
								[ALT_ID] [NVARCHAR](150) NULL,
								[ALT_PRIORITY] [NUMERIC](20, 10) NULL,
								[SEQ] [NUMERIC](20, 10) DEFAULT 1 NOT NULL,
								[P_QTY] [NUMERIC](20, 10) NULL,
								[S_QTY] [NUMERIC](20, 10) NULL,
								[PARENT_QTY] [NUMERIC](20, 10) DEFAULT 1 NOT NULL,
								[PARENT_UOM] [NVARCHAR](10) DEFAULT 'EA' NOT NULL,
								[CHILD_QTY] [NUMERIC](20, 10) DEFAULT 1 NOT NULL,
								[CHILD_UOM] [NVARCHAR](10) DEFAULT 'EA' NOT NULL,
								[ATTB_01] [NVARCHAR](150) NULL,
								[ATTB_02] [NVARCHAR](150) NULL,
								[ATTB_03] [NVARCHAR](150) NULL,
								[ATTB_04] [NVARCHAR](150) NULL,
								[ATTB_05] [NVARCHAR](150) NULL,
								[INSERT_ID] [NVARCHAR](150) NULL,
								[INSERT_TIME] [DATETIME] NULL,
								[UPDATE_ID] [NVARCHAR](150) NULL,
								[UPDATE_TIME] [DATETIME] NULL 
								--,CONSTRAINT PK_TEMP_TH_BUF_VB_PACK_BOM PRIMARY KEY (INSTANCE_ID,FP_PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,SEQ)
							)
		
		IF OBJECT_ID('tempdb..#tempTH_BUF_VB_PACK_IN_PLAN') IS NOT NULL
		DROP TABLE #tempTH_BUF_VB_PACK_IN_PLAN
	
		CREATE TABLE #tempTH_BUF_VB_PACK_IN_PLAN (
								[INSTANCE_ID] [NVARCHAR](30) NOT NULL,
								[FP_PLAN_ID] [NVARCHAR](30) NOT NULL,
								[COMPANY_ID] [NVARCHAR](30) NOT NULL,
								[DIVISION_ID] [NVARCHAR](30) NOT NULL,
								[SITE_ID] [NVARCHAR](30) NOT NULL,
								[PLANT_ID] [NVARCHAR](30) NOT NULL,
								[CATEGORY_ID] [NVARCHAR](30) NULL,
								[MODEL_CODE] [NVARCHAR](150) NOT NULL,
								[MODEL_NICK] [NVARCHAR](150) NULL,
								[PACK_ITEM_ID] [NVARCHAR](150) NOT NULL,
								[PLAN_DATE] [DATETIME] NOT NULL,
								[IN_QTY] [NUMERIC](20, 10) NULL,
								[CELL_ITEM_ID] [NVARCHAR](150) NULL,
								[CELL_NICK] [NVARCHAR](150) NULL,
								[BOM_RATE] [NUMERIC](20, 10) NULL,
								[CELL_QTY] [NUMERIC](20, 10) NULL,
								[ATTB_01] [NVARCHAR](150) NULL,
								[ATTB_02] [NVARCHAR](150) NULL,
								[ATTB_03] [NVARCHAR](150) NULL,
								[ATTB_04] [NVARCHAR](150) NULL,
								[ATTB_05] [NVARCHAR](150) NULL,
								[INSERT_ID] [NVARCHAR](150) NULL,
								[INSERT_TIME] [DATETIME] NULL
								--,CONSTRAINT PK_TEMP_TH_BUF_VB_PACK_IN_PLAN PRIMARY KEY (INSTANCE_ID,FP_PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,MODEL_CODE,PACK_ITEM_ID,PLAN_DATE)
							)
		
		IF OBJECT_ID('tempdb..#CELL_ITEM_V') IS NOT NULL
		DROP TABLE #CELL_ITEM_V
  		
		SELECT	COMPANY_ID, DIVISION_ID, SITE_ID, PARENT_ITEM_ID AS CELL_PRODUCT, CHILD_ITEM_ID AS CELL_ASSY, FLAG								
		INTO	#CELL_ITEM_V 																													
		FROM (																																	
				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, 'NEW' AS FLAG						
				FROM	SCM_MODEL_COMP_TEMP_V A WITH(NOLOCK)																						
					  , SCM_ITEM_M B WITH(NOLOCK)																								
				WHERE 1=1																														
				AND	A.SITE_ID = ( SELECT MAX(SITE_ID) AS SITE_ID
								  FROM SY_FP_INSTANCE_INFO_V
								  WHERE 1=1
								  AND INSTANCE_ID = @v_master_id)																											
				AND A.MODEL_ID = A.PARENT_ITEM_ID																								
				AND A.COMPANY_ID = B.COMPANY_ID																									
				AND A.DIVISION_ID = B.DIVISION_ID																								
				AND A.SITE_ID = B.SITE_ID																										
				AND A.CHILD_ITEM_ID = B.ITEM_ID																									
				AND B.ACTIVE_FLAG = 'Y'																											
				AND B.ITEM_CLASS  = 'ES1901'																									
				UNION ALL																														
				SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID , A.PARENT_ITEM_ID, A.PARENT_ITEM_ID AS CHILD_ITEM_ID, 'ORG' AS FLAG
				FROM	SCM_MODEL_COMP_TEMP_V A WITH(NOLOCK)																						
					  , SCM_ITEM_M B WITH(NOLOCK)		
					  , SCM_ITEM_CLASS_M C WITH(NOLOCK)
				WHERE 1=1																														
				AND	A.SITE_ID = ( SELECT MAX(SITE_ID) AS SITE_ID
								  FROM SY_FP_INSTANCE_INFO_V
								  WHERE 1=1
								  AND INSTANCE_ID = @v_master_id)																												
				AND A.MODEL_ID = A.PARENT_ITEM_ID																								
				AND A.COMPANY_ID = B.COMPANY_ID																									
				AND A.DIVISION_ID = B.DIVISION_ID																								
				AND A.SITE_ID = B.SITE_ID																										
				AND A.PARENT_ITEM_ID = B.ITEM_ID																								
				AND B.ACTIVE_FLAG = 'Y'	
				AND B.ITEM_CLASS = C.CLASS_ID
				AND C.LEVEL_1_NAME LIKE '%Model%'
				AND C.LEVEL_3_NAME LIKE '%Cell%'
			) A																																	
		WHERE 1=1	
		;	


    	BEGIN  -- 01 
        	---- Plan_Type 설정
			SELECT  @v_plan_type = A.PLAN_TYPE 
			FROM    SCM_FP_PLAN_H A
			WHERE   A.INSTANCE_ID =  @v_master_id
			AND     A.PLAN_ID     =  @v_plan_id ; 


		---- 대상 SITE 변수 설정
		SET 	@v_table_name  = 'FP_INSTANCE_INFO_V'
		SELECT  @V_SITE_ID     = A.SITE_ID
			  , @V_COMPANY_ID  = A.COMPANY_ID
			  , @V_DIVISION_ID = A.DIVISION_ID
			  , @V_PLANT_ID    = A.PLANT_ID
		FROM    (   ---(20191015) 중복행 제거
				SELECT  DISTINCT  A.COMPANY_ID ,  A.DIVISION_ID , A.SITE_ID , A.PLANT_ID
				FROM 	FP_INSTANCE_INFO_V A
				WHERE   A.INSTANCE_ID  = @V_MASTER_ID
				) A
		;              
             
		--LOG 생성
		SET @v_message = 'SITE_ID : ' + @V_SITE_ID + ', PLAN_TYPE : ' + @v_plan_type
		SET @v_descr   = NULL
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, @v_descr



		---- 계획 수립 일자 변수 설정      
		SET 	 @v_table_name = 'FP_INSTANCE_FACTORY_M'
		SELECT   @V_INSTANCE_DATE = CASE WHEN DBO.FN_SITE_TIME(@V_SITE_ID) < CONVERT(DATETIME, CONVERT(VARCHAR(10),DBO.FN_SITE_TIME(@V_SITE_ID),112) +' '+LEFT(BASIS_TIME,2)+':'+SUBSTRING(BASIS_TIME,3,2)+':'+RIGHT(BASIS_TIME,2)) 
									THEN CONVERT(DATE, DATEADD(HOUR, -CONVERT(INT, LEFT(BASIS_TIME,2)), DBO.FN_SITE_TIME(@V_SITE_ID)))
									ELSE CONVERT(DATE,DBO.FN_SITE_TIME(@V_SITE_ID)) END
				, @V_BASIS_TIME   =  AAA.BASIS_TIME
		FROM 	(
			SELECT CASE WHEN MAX(PLANT_BASIS_TIME) IS NULL THEN MAX(BASIS_TIME) ELSE MAX(PLANT_BASIS_TIME) END AS BASIS_TIME
			FROM (
					select A.INSTANCE_ID,B.PLANT_ID,B.FACTORY_ID,C.PLANT_BASIS_TIME,D.BASIS_TIME 
					from FP_INSTANCE_FACTORY_M A 
					INNER JOIN SCM_FACTORY_M B 
					ON A.FACTORY_ID=B.FACTORY_ID
					LEFT JOIN (SELECT SEGMENT1 AS PLANT_ID,SEGMENT2 AS PLANT_BASIS_TIME 
				  				FROM SCM_SYS_LOOKUP_VALUE 
				  				WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT') C
					ON B.PLANT_ID=C.PLANT_ID
					INNER JOIN (SELECT '-' AS CODE_ID, SEGMENT1 AS BASIS_TIME 
				  				FROM SCM_SYS_LOOKUP_VALUE 
				  				WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME') D
					ON 1=1
					WHERE A.INSTANCE_ID = @V_MASTER_ID
				) AA
			) AAA
		;        
             
		--LOG 생성
		SET @v_message = 'INSTANCE_DATE(SITE) : ' + CONVERT(nvarchar, @V_INSTANCE_DATE, 112)
		SET @v_descr   = 'BASIS_TIME: ' + CONVERT( NVARCHAR, @V_BASIS_TIME)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, @v_descr    


	  
		---- CUTOFF DATA I/F 이전이면 이전 날짜로 INSTNACE DATE 설정      
		SELECT 	@V_INSTANCE_DATE = CONVERT(DATE, ATTRIBUTE1)
		FROM 	dbo.SCM_SYS_LOOKUP_VALUE
		WHERE 	1=1
		AND 	LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
		AND 	SEGMENT1 = @V_SITE_ID
		AND     SEGMENT2 = @V_BASIS_TIME

		;
        
		--LOG 생성
		SET @v_message = 'INSTANCE_DATE(CUTOFF) : ' + CONVERT(nvarchar, @V_INSTANCE_DATE, 112)
		SET @v_descr   = NULL
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, @v_descr
    END  --01


		------------------------------------------------------
		---- PACK - CELL BOM 정보 생성.
		------------------------------------------------------    
		BEGIN  --02
	        SET @v_table_name = 'TH_BUF_VB_PACK_BOM'	    
	
	        --DELETE  #tempTH_BUF_VB_PACK_BOM 
			DELETE  TH_BUF_VB_PACK_BOM 
			WHERE  INSTANCE_ID = @v_master_id
			AND    FP_PLAN_ID  = @v_plan_id
			; 

			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
			SET @v_descr   = NULL
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr 
		

			--INSERT INTO   #tempTH_BUF_VB_PACK_BOM
			INSERT INTO   TH_BUF_VB_PACK_BOM
				(   INSTANCE_ID 
					, FP_PLAN_ID 
					, COMPANY_ID 
					, DIVISION_ID
					, SITE_ID 
					, PLANT_ID 
					, PARENT_ITEM_ID 
					, CHILD_ITEM_ID 
					, ALT_ID 
					, ALT_PRIORITY 
					, PARENT_QTY 
					, PARENT_UOM 
					, CHILD_QTY 
					, CHILD_UOM 
					, BOM_RATE 
					, INSERT_ID
					, INSERT_TIME 
					, UPDATE_ID
					, UPDATE_TIME 
				) 
			-- (D.20200915~R.0915.01) Hazel Park 모델은 단독 모델이지만 중복이 생길 가능성이 있어서 MIN 으로 통일함
			SELECT	@v_master_id AS INSTANCE_ID          , @v_plan_id AS FP_PLAN_ID 
						, AA.COMPANY_ID     , AA.DIVISION_ID   , AA.SITE_ID   
						, ISNULL(D.PLANT_ID, AA.PLANT_ID) AS PLANT_ID
						, AA.PARENT_ITEM_ID , AA.CHILD_ITEM_ID 
						, MIN(AA.ALT_ID) AS ALT_ID
						, MIN(AA.ALT_PRIORITY) AS ALT_PRIORITY
						, MIN(AA.PARENT_QTY) AS PARENT_QTY     
						, AA.PARENT_UOM    
						, MIN(AA.CHILD_QTY) AS CHILD_QTY 
						, AA.CHILD_UOM     
						, MIN(AA.BOM_RATE) AS BOM_RATE
						, @v_proc_name AS INSERT_ID  , GETDATE()   AS INSERT_TIME
						, @v_proc_name AS UPDATE_ID  , GETDATE()   AS UPDATE_TIME
			FROM    ( --- BOM: 자품목이 CELL ITEM인 것을 가져온다.
							SELECT DISTINCT                 ---+ (20191129) ALT_PRIORITY중복나서 수정함.
									 AA.COMPANY_ID
									,AA.DIVISION_ID
									,AA.SITE_ID
									,AA.PLANT_ID
									,AA.KEY_DATE   AS BOM_VERSION_ID
									,AA.PARENT_ITEM_ID
									,AA.CHILD_ITEM_ID
									,AA.PARENT_UOM 
									,AA.PARENT_QTY
									,AA.CHILD_QTY
									,AA.CHILD_UOM
									,AA.ALT_ID
									,AA.ALT_RATE
									,AA.ALT_PRIORITY
									, CASE WHEN AA.PARENT_QTY = 0 THEN 0 ELSE (AA.CHILD_QTY/AA.PARENT_QTY) END BOM_RATE
							FROM   SCM_BOM_M AA WITH(NOLOCK),
									(
									SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
									FROM    SCM_BOM_M         A WITH(NOLOCK),
											SCM_ITEM_M        B WITH(NOLOCK),
											SCM_ITEM_CLASS_M  C WITH(NOLOCK)
									WHERE  1=1
									AND    A.ACTIVE_FLAG    = 'Y'
									AND    A.COMPANY_ID     = B.COMPANY_ID
									AND    A.DIVISION_ID    = B.DIVISION_ID
									AND    A.SITE_ID        = B.SITE_ID
									AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
									AND    B.ACTIVE_FLAG    = 'Y'
									AND    B.ITEM_CLASS     = C.CLASS_ID  
									AND    C.USE_FLAG       = 'Y'                    
									AND    A.EFF_END_DATE   > CONVERT(DATE,  @V_INSTANCE_DATE )              
									GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.KEY_DATE
									) BB,
									SCM_ITEM_M        CC WITH(NOLOCK),
									SCM_ITEM_CLASS_M  DD WITH(NOLOCK)
								  , FP_INSTANCE_OPERATION_V OP
							WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
							AND    AA.DIVISION_ID     = BB.DIVISION_ID
							AND    AA.SITE_ID         = BB.SITE_ID
							AND    AA.PLANT_ID        = BB.PLANT_ID
							AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
							AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
							AND    AA.KEY_DATE        = BB.KEY_DATE
							AND    AA.COMPANY_ID     = CC.COMPANY_ID
							AND    AA.DIVISION_ID    = CC.DIVISION_ID
							AND    AA.SITE_ID        = CC.SITE_ID
							AND    AA.CHILD_ITEM_ID  = CC.ITEM_ID  
							AND    CC.ACTIVE_FLAG    = 'Y'
							AND    CC.ITEM_CLASS     = DD.CLASS_ID  
							AND    DD.USE_FLAG       =  'Y'                    
							AND    AA.ACTIVE_FLAG     = 'Y'
							AND    AA.BOM_VERSION_ID  = '1'
							AND    AA.EFF_END_DATE    >  CONVERT(DATE, @V_INSTANCE_DATE )
							AND    AA.EFF_START_DATE  <= CONVERT(DATE, @V_INSTANCE_DATE )  ---+ (20200109) ADD 
							AND    RIGHT(CC.FLOW_ID , 5) = OP.OPERATION_ID
							AND    CC.ITEM_TYPE = 'P'		--@@@
							--AND    CASE WHEN CC.FLOW_ID IS NULL AND CC.ITEM_TYPE = 'P' THEN RIGHT(CC.SCP_FLOW_ID , 5) ELSE RIGHT(CC.FLOW_ID , 5) END = OP.OPERATION_ID  -- @@@
							AND    AA.COMPANY_ID     =  OP.COMPANY_ID
							AND    AA.DIVISION_ID    =  OP.DIVISION_ID
							AND    AA.SITE_ID        =  OP.SITE_ID
							AND    OP.AMEND_MAIN_FLAG = 'Y'
							AND    OP.INSTANCE_ID LIKE '%CELL%'
							AND    AA.SITE_ID         =  @V_SITE_ID
							--SELECT  A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID 
							--		, A.PARENT_ITEM_ID , A.CHILD_ITEM_ID , A.ALT_ID , A.ALT_PRIORITY 
							--		, A.PARENT_QTY , PARENT_UOM , A.CHILD_QTY , CHILD_UOM 
							--		, CASE WHEN A.PARENT_QTY = 0 THEN 0 ELSE (A.CHILD_QTY/A.PARENT_QTY) END BOM_RATE 
							--FROM    (
							--		SELECT  A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID 
							--				, A.PARENT_ITEM_ID , A.PARENT_QTY , A.PARENT_UOM , A.CHILD_QTY , CHILD_UOM 
							--				, ISNULL( LV.GROUP_ITEM_ID , A.CHILD_ITEM_ID) AS CHILD_ITEM_ID 
							--				, MIN(A.ALT_ID) AS ALT_ID  
							--				, MIN(A.ALT_PRIORITY) AS ALT_PRIORITY 
							--		FROM    SCM_BOM_M  A  WITH(NOLOCK) 
							--		LEFT OUTER JOIN (
							--						SELECT  SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS GROUP_ITEM_ID , SEGMENT4 AS ITEM_ID 
							--						FROM    SCM_SYS_LOOKUP_VALUE  LV  WITH(NOLOCK)
							--						WHERE  LV.LOOKUP_TYPE_CODE  =  'MODULE_CELL_GROUP'
							--						AND    LV.ACTIVE_FLAG  = 'Y'
							--						) LV
							--						ON   1=1
							--						AND  A.SITE_ID       =  LV.SITE_ID 
							--						AND  A.DIVISION_ID   =  LV.DIVISION_ID
							--						AND  A.CHILD_ITEM_ID =  LV.ITEM_ID    
							--		WHERE  1=1
							--		AND    A.SITE_ID         =  @V_SITE_ID
							--		AND    A.EFF_START_DATE <=  @V_INSTANCE_DATE
							--		AND    A.EFF_END_DATE   >=  @V_INSTANCE_DATE
							--		AND    A.ACTIVE_FLAG     = 'Y' 
							--		GROUP BY A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.PARENT_ITEM_ID , A.PARENT_QTY , A.PARENT_UOM , A.CHILD_QTY , CHILD_UOM 
							--				, ISNULL( LV.GROUP_ITEM_ID , A.CHILD_ITEM_ID) 		
							--		) A 
							--		, SCM_ITEM_M  I1  WITH(NOLOCK)
							--		, FP_INSTANCE_OPERATION_V OP
							--WHERE  1=1      
							--AND    A.CHILD_ITEM_ID  =  I1.ITEM_ID
							--AND    A.COMPANY_ID     =  I1.COMPANY_ID
							--AND    A.SITE_ID        =  I1.SITE_ID
							--AND    A.DIVISION_ID    =  I1.DIVISION_ID
							--AND    A.COMPANY_ID     =  OP.COMPANY_ID
							--AND    A.DIVISION_ID    =  OP.DIVISION_ID
							--AND    A.SITE_ID        =  OP.SITE_ID
							--AND    RIGHT(I1.FLOW_ID , 5) = OP.OPERATION_ID
							--AND    OP.AMEND_MAIN_FLAG = 'Y'
							--AND    OP.INSTANCE_ID LIKE '%CELL%'
					) AA
					LEFT OUTER JOIN (														-- (D.20200915~R.0915.01) Hazel Park Plant mapping 시켜줌
										SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID
												, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID
										FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
										WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
										AND    A.ACTIVE_FLAG = 'Y'
										AND	   A.SEGMENT4 = 'DU'
									) D
						ON  AA.DIVISION_ID  	= D.REF_DIVISION_ID
						AND AA.SITE_ID      	= D.REF_SITE_ID
						AND AA.PLANT_ID      = D.REF_PLANT_ID
			WHERE 1=1
			GROUP BY  AA.COMPANY_ID     , AA.DIVISION_ID   , AA.SITE_ID   
							, ISNULL(D.PLANT_ID, AA.PLANT_ID)
							, AA.PARENT_ITEM_ID , AA.CHILD_ITEM_ID 
							, AA.PARENT_UOM    , AA.CHILD_UOM 
			;		      

		--LOG 생성
		SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )  
		SET @v_descr   = NULL
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr 



			---- 공급계획 수량 업데이트	  
			UPDATE  AA
			SET     AA.P_QTY = BB.P_QTY 
			--FROM    #tempTH_BUF_VB_PACK_BOM AA
			FROM    TH_BUF_VB_PACK_BOM AA
					LEFT OUTER JOIN (
										SELECT  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID , A.ITEM_ID , SUM(QTY) AS P_QTY 
										FROM    (
														----< INHOUSE MOVING PLAN: COMPANY, SITE , DIVISION 동일 >-- 
														SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
															  , ISNULL(LV.GROUP_ITEM_ID , A.ITEM_ID ) AS ITEM_ID 
															  , SUM(A.QTY) AS QTY
															  , 'INHOUSE'  AS GBN 
														FROM    FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)
														LEFT OUTER JOIN (
																		SELECT  SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS GROUP_ITEM_ID , SEGMENT4 AS ITEM_ID 
																		FROM    SCM_SYS_LOOKUP_VALUE  LV  WITH(NOLOCK)
																		WHERE  LV.LOOKUP_TYPE_CODE  =  'MODULE_CELL_GROUP'
																		AND    LV.ACTIVE_FLAG  = 'Y'
																		) LV
																		ON   1=1
																		AND  A.SITE_ID     =  LV.SITE_ID 
																		AND  A.DIVISION_ID =  LV.DIVISION_ID
																		AND  A.ITEM_ID     =  LV.ITEM_ID    
														WHERE 1=1
														AND   A.CATEGORY     = 'MOVING'
														AND	  CONVERT(DATE, A.PLAN_DATE)  >=  @V_INSTANCE_DATE  ---> 오늘 이후날짜로 조회.						
														AND	  A.DIVISION_ID  = @V_DIVISION_ID
														AND	  A.COMPANY_ID   = @V_COMPANY_ID
														AND   A.SITE_ID      = @V_SITE_ID
														AND   A.INSTANCE_ID  LIKE '%FORM%'
														GROUP BY  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
																, A.DIVISION_ID, A.SITE_ID,  A.PLANT_ID 
																, ISNULL(LV.GROUP_ITEM_ID , A.ITEM_ID )
														HAVING  SUM(A.QTY) > 0 
														UNION ALL    
														----< INTRANSIT >----
														SELECT  A.COMPANY_ID 
															  , A.DIVISION_ID 
															  , A.SITE_ID 
															  , A.PLANT_ID 
															  , ISNULL(LV.GROUP_ITEM_ID, A.ITEM_ID) AS ITEM_ID 
															  , SUM(A.DELIVERY_QTY)  AS QTY
															  , 'INTRANSIT'  AS GBN 
														FROM    IF_FP_SCM_IN_TRANSIT_V A 
														LEFT OUTER JOIN (
																		SELECT  SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS GROUP_ITEM_ID , SEGMENT4 AS ITEM_ID 
																		FROM    SCM_SYS_LOOKUP_VALUE  LV  WITH(NOLOCK)
																		WHERE  LV.LOOKUP_TYPE_CODE  =  'MODULE_CELL_GROUP'
																		AND    LV.ACTIVE_FLAG  = 'Y'
																		) LV
																		ON   1=1
																		AND  A.SITE_ID     =  LV.SITE_ID 
																		AND  A.DIVISION_ID =  LV.DIVISION_ID
																		AND  A.ITEM_ID     =  LV.ITEM_ID
															  , SCM_PLANT_M  M   WITH(NOLOCK) 
														WHERE 1=1
														AND   A.FROM_PLANT_ID =  M.PLANT_ID
														AND   A.DIVISION_ID   =  M.DIVISION_ID
														--AND   A.PLANT_ID      =  @V_PLANT_ID
														AND   A.RESULT_DATE   =  DATEADD (DAY, -1, @V_INSTANCE_DATE)         ---+ 시업시간 기준. D-1일이 최신 수집 정보 (김춘동 책임)
														GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID 
														      , ISNULL(LV.GROUP_ITEM_ID, A.ITEM_ID)
														UNION ALL
														----< SSP 출하계획 >----
														SELECT  A.CUSTOMER_ID    AS COMPANY_ID 
																, A.DIVISION_ID  
																, A.TO_SITE_ID   AS SITE_ID 
																, A.TO_PLANT_ID  AS PLANT_ID 
																, ISNULL(LV.ITEM_ID,A.ITEM_ID) AS ITEM_ID       
																, SUM(A.SHIP_QTY) AS  QTY 
																, 'SSP'           AS GBN 
														FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A  WITH(NOLOCK)
														LEFT OUTER JOIN (
																		SELECT  SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS GROUP_ITEM_ID , SEGMENT4 AS ITEM_ID 
																		FROM    SCM_SYS_LOOKUP_VALUE  LV  WITH(NOLOCK)
																		WHERE  LV.LOOKUP_TYPE_CODE  =  'MODULE_CELL_GROUP'
																		AND    LV.ACTIVE_FLAG  = 'Y'
																		) LV
																		ON   1=1
																		AND  A.SITE_ID     =  LV.SITE_ID 
																		AND  A.DIVISION_ID =  LV.DIVISION_ID
																		AND  A.ITEM_ID     =  LV.ITEM_ID 		
														WHERE 1=1
														AND   A.SCP_PLAN_ID = (	SELECT  MAX(SCP_PLAN_ID) 
																				FROM    FP_WEEKLY_DEMAND_SHIPMENT_H  A  WITH(NOLOCK) 
																				WHERE A.SHOP_GROUP_ID = 'A'   ---+ cell 출하 
																				AND   A.DIVISION_ID   =  @V_DIVISION_ID 
																				AND   A.TO_SITE_ID    =  @V_SITE_ID
																				--AND   A.TO_PLANT_ID   =  @V_PLANT_ID
																				AND   A.CUSTOMER_ID   =  @V_COMPANY_ID
																				GROUP BY CUSTOMER_ID , DIVISION_ID , TO_SITE_ID , TO_PLANT_ID , SHOP_GROUP_ID ) 
														AND   A.SHOP_GROUP_ID = 'A'
														AND   A.DIVISION_ID   = @V_DIVISION_ID
														AND   A.TO_SITE_ID    = @V_SITE_ID
														--AND   A.TO_PLANT_ID   = @V_PLANT_ID
														AND   A.CUSTOMER_ID   = @V_COMPANY_ID
														GROUP BY  A.CUSTOMER_ID 
																, A.DIVISION_ID  
																, A.TO_SITE_ID   
																, A.TO_PLANT_ID  
																, ISNULL(LV.ITEM_ID,A.ITEM_ID)
												) A
												LEFT OUTER JOIN (														-- (D.20200915~R.0915.01) Hazel Park Plant mapping 시켜줌
																			SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID
																					, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID
																			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
																			WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
																			AND    A.ACTIVE_FLAG = 'Y'
																			AND	   A.SEGMENT4 = 'DU'
												) D
													ON   A.DIVISION_ID  	= D.REF_DIVISION_ID
													AND A.SITE_ID      	= D.REF_SITE_ID
													AND A.PLANT_ID      = D.REF_PLANT_ID
									WHERE  1=1 
									GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , ISNULL(D.PLANT_ID, A.PLANT_ID) , A.ITEM_ID
								) BB 
					ON   1=1
					AND	 AA.COMPANY_ID  =  BB.COMPANY_ID
					AND  AA.DIVISION_ID =  BB.DIVISION_ID 
					AND  AA.SITE_ID     =  BB.SITE_ID
					AND  AA.PLANT_ID    =  BB.PLANT_ID
					AND  AA.CHILD_ITEM_ID = BB.ITEM_ID 
			WHERE  AA.FP_PLAN_ID = @v_plan_id 
			AND    AA.INSTANCE_ID = @v_master_id
			; 

		--LOG 생성
		SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
		SET @v_descr   = 'P_QTY'
		SET @n_log_count = @n_log_count + 1
		SET @sysdate     = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr 



			---- STOCK(BOH) 수량 업데이트
			UPDATE  AA     
			SET     AA.S_QTY = BB.STOCK_QTY  
			--FROM    #tempTH_BUF_VB_PACK_BOM AA
			FROM    TH_BUF_VB_PACK_BOM AA
					LEFT OUTER JOIN #CELL_ITEM_V VV	-- 활성화 코드 분리 관련 추가 @@@
					ON 1=1									
					AND	AA.COMPANY_ID    =  VV.COMPANY_ID    
					AND AA.DIVISION_ID   =  VV.DIVISION_ID   
					AND AA.SITE_ID       =  VV.SITE_ID		
					AND AA.CHILD_ITEM_ID =  VV.CELL_ASSY		
					LEFT OUTER JOIN (
								SELECT  A.CUTOFF_DATE  , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID , A.ITEM_ID
									  , SUM(A.STOCK_QTY) AS STOCK_QTY
								FROM    (
										--- P1000 대기재고 --- 
										SELECT  A.CUTOFF_DATE  , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.FACTORY_ID 
											  , ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID
											  , ISNULL( SUM(A.MODIFY_FP_APPLY_WIPQTY), SUM(A.FP_APPLY_WIPQTY) ) AS STOCK_QTY 
										FROM    SCM_STOCK_H_V A  WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C
														ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'
														AND A.SITE_ID     = C.SEGMENT1
														AND A.DIVISION_ID = C.SEGMENT2
														AND	A.ITEM_ID     = C.SEGMENT4
														AND C.ACTIVE_FLAG  = 'Y'		
										WHERE 1=1
										AND   A.CUTOFF_DATE  =  CONVERT(nvarchar, @V_INSTANCE_DATE, 112) 
										AND   A.OPERATION_ID =  'P1000'
										AND   A.STORAGE_ID   =  'MES'
										AND   A.SITE_ID      =  @V_SITE_ID  
										AND   A.DIVISION_ID  =  @V_DIVISION_ID
										--AND   A.PLANT_ID     =  @V_PLANT_ID
										GROUP BY A.CUTOFF_DATE  , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.FACTORY_ID 
											   , ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID)
										UNION ALL 
										--- STORAGE_ID 1000번대 재고 ---
										SELECT  A.CUTOFF_DATE  , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.FACTORY_ID 
											  , ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID
											  , ISNULL(A.QTY2 ,0)  AS STOCK_QTY 
										FROM    SCM_STOCK_H_V A  WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C
														ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   
														AND A.SITE_ID     = C.SEGMENT1
														AND A.DIVISION_ID = C.SEGMENT2
														AND	A.ITEM_ID     = C.SEGMENT4
														AND C.ACTIVE_FLAG  = 'Y'	
										WHERE 1=1
										AND   A.CUTOFF_DATE  =  CONVERT(nvarchar, @V_INSTANCE_DATE, 112)
										AND   SUBSTRING (A.STORAGE_ID, 1, 1)  = '1' 
										AND   A.SITE_ID      =  @V_SITE_ID
										AND   A.DIVISION_ID  =  @V_DIVISION_ID
										--AND   A.PLANT_ID     =  @V_PLANT_ID
										UNION ALL 
				/*
										--- DW 이동재고 ---
										SELECT  A.CUTOFF_DATE  , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.FACTORY_ID 
											  , ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID
											  , ISNULL(A.PACK_MOVE_QTY ,0)  AS STOCK_QTY 
										FROM    SCM_STOCK_H_V A  WITH(NOLOCK)
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C
														ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.
														AND A.SITE_ID     = C.SEGMENT1
														AND A.DIVISION_ID = C.SEGMENT2
														AND	A.ITEM_ID     = C.SEGMENT4
														AND C.ACTIVE_FLAG  = 'Y'			
											WHERE 1=1
											AND   A.CUTOFF_DATE  =  @V_INSTANCE_DATE   --->  시업시간 기준 INSTANCE DATE 
											AND   STOCK_TYPE     =  'DW'
											AND   ISNULL(PACK_MOVE_QTY ,0) > 0 
											AND   A.SITE_ID      =  @V_SITE_ID
											AND   A.DIVISION_ID  =  @V_DIVISION_ID
											AND   A.PLANT_ID     =  @V_PLANT_ID
											*/
											--- SSP 이동재고 ---	(D.20201229~R.1229.01)
											SELECT  A.CUTOFF_DATE  , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID , A.FACTORY_ID 
													, ISNULL(C.SEGMENT3 , ITEM_ID)  AS ITEM_ID
													, ISNULL(A.PACK_MOVE_QTY ,0)  AS STOCK_QTY 
											FROM    FP_SSP_STOCK_BACKUP_H A  WITH(NOLOCK)
													LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C
														ON	C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.
														AND A.SITE_ID     = C.SEGMENT1
														AND A.DIVISION_ID = C.SEGMENT2
														AND	A.ITEM_ID     = C.SEGMENT4
														AND C.ACTIVE_FLAG  = 'Y'			
											WHERE 1=1
											AND   A.CUTOFF_DATE  =  CONVERT(nvarchar, @V_INSTANCE_DATE, 112)  --->  시업시간 기준 INSTANCE DATE 
											AND   A.DIVISION_ID  =  @V_DIVISION_ID
											AND   A.SITE_ID      =  @V_SITE_ID
											--AND   A.PLANT_ID     =  @V_PLANT_ID
											AND   ISNULL(PACK_MOVE_QTY ,0) > 0 
										) A
										LEFT OUTER JOIN (														-- (D.20200915~R.0915.01) Hazel Park Plant mapping 시켜줌
																	SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID
																			, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID
																	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
																	WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
																	AND    A.ACTIVE_FLAG = 'Y'
																	AND	   A.SEGMENT4 = 'DU'
										) D
											ON  A.DIVISION_ID  	= D.REF_DIVISION_ID
											AND A.SITE_ID      	= D.REF_SITE_ID
											AND A.PLANT_ID     	= D.REF_PLANT_ID
								WHERE 1=1
								GROUP BY A.CUTOFF_DATE  , A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID ,  ISNULL(D.PLANT_ID, A.PLANT_ID) , A.ITEM_ID
							) BB 
					ON   1=1
					AND	 AA.COMPANY_ID  =  BB.COMPANY_ID
					AND  AA.DIVISION_ID =  BB.DIVISION_ID 
					AND  AA.SITE_ID     =  BB.SITE_ID
					AND  AA.PLANT_ID    =  BB.PLANT_ID
					--AND  AA.CHILD_ITEM_ID = BB.ITEM_ID 
					AND  VV.CELL_PRODUCT = BB.ITEM_ID	--@@@
			WHERE  AA.FP_PLAN_ID = @v_plan_id 
			AND    AA.INSTANCE_ID = @v_master_id
			; 

		--LOG 생성
		SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
		SET @v_descr   = 'S_QTY'
		SET @n_log_count = @n_log_count + 1
		SET @sysdate     = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr 



			---- SEQ 재설정 
			UPDATE  AA
			SET     AA.SEQ = BB.PRIORITY 
			--FROM    #tempTH_BUF_VB_PACK_BOM AA
			FROM    TH_BUF_VB_PACK_BOM AA
				  , (
						SELECT  A.INSTANCE_ID 
							  , FP_PLAN_ID 
							  , COMPANY_ID 
							  , DIVISION_ID
							  , SITE_ID 
							  , PLANT_ID 
							  , PARENT_ITEM_ID 
							  , CHILD_ITEM_ID 
							  , ALT_ID 
							  , ALT_PRIORITY 
							  , SEQ 
							  , P_QTY
							  , S_QTY
							  , DENSE_RANK() OVER(PARTITION BY INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PARENT_ITEM_ID 
							                      ORDER BY   ISNULL(ALT_ID, 999), ISNULL(ALT_PRIORITY,999)  ---(20191125) 정인천 책임 요청으로 우선순위만 봄.
												           , ISNULL(P_QTY,0) + ISNULL(S_QTY,0) DESC         ---(20191129) BOM PRIORITY가 중복날 경우 대비. 
												  --ORDER BY  ISNULL(P_QTY,0) + ISNULL(S_QTY,0) DESC , ISNULL(ALT_ID, 999) , ISNULL(ALT_PRIORITY,999)  --- (20191125) 주석처리.
												  )  AS PRIORITY 
						--FROM    #tempTH_BUF_VB_PACK_BOM  A
						FROM    TH_BUF_VB_PACK_BOM  A
						WHERE  1=1
						AND    A.INSTANCE_ID  =  @v_master_id
						AND    A.FP_PLAN_ID   =  @v_plan_id
					) BB
			WHERE  1=1
			AND    AA.INSTANCE_ID = BB.INSTANCE_ID
			AND    AA.FP_PLAN_ID  = BB.FP_PLAN_ID
			AND    AA.COMPANY_ID  = BB.COMPANY_ID
			AND    AA.DIVISION_ID = BB.DIVISION_ID
			AND    AA.SITE_ID     = BB.SITE_ID
			AND    AA.PLANT_ID    = BB.PLANT_ID
			AND    AA.PARENT_ITEM_ID = BB.PARENT_ITEM_ID
			AND    AA.CHILD_ITEM_ID  = BB.CHILD_ITEM_ID 
			; 

			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT ) 
			SET @v_descr   = 'SEQ'
			SET @n_log_count = @n_log_count + 1
			SET @sysdate     = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, @v_descr 
		
		END  --02
	  
	----------------------------------------------------------    
    -- CELL ITEM 기준으로 코드 변환 및 BOM_RATE 반영한 소요량 
	-- PLAN_TYPE에 따라 참조하는 AMEND TABLE이 다름
	----------------------------------------------------------  
    BEGIN  --3
      SET @v_table_name = 'TH_BUF_VB_PACK_IN_PLAN'

			--DELETE  #tempTH_BUF_VB_PACK_IN_PLAN
			DELETE  TH_BUF_VB_PACK_IN_PLAN
			WHERE  1=1
			AND    INSTANCE_ID  =  @v_master_id
			AND    FP_PLAN_ID   =  @v_plan_id
			; 
			
			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
			SET @v_descr   = NULL
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr 


			IF @V_PLAN_TYPE IN ('PRE', 'SYNC')    --- (20191209) KR_PACK: sync 조건 추가
		  	BEGIN  -- PRE 
				--INSERT INTO  #tempTH_BUF_VB_PACK_IN_PLAN
				INSERT INTO  TH_BUF_VB_PACK_IN_PLAN
					(   INSTANCE_ID 
						, FP_PLAN_ID 
						, COMPANY_ID 
						, DIVISION_ID 
						, SITE_ID 
						, PLANT_ID
						, CATEGORY_ID 
						, MODEL_CODE 
						, MODEL_NICK 
						, PACK_ITEM_ID 
						, PLAN_DATE 
						, IN_QTY
						, CELL_ITEM_ID 
						, CELL_NICK 
						, BOM_RATE   
						, CELL_QTY  
						, INSERT_ID
						, INSERT_TIME 
					) 
					SELECT DISTINCT A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID
							, A.CATEGORY_ID , A.MODEL_CODE , A.MODEL_NICK , A.PACK_ITEM_ID , A.PLAN_DATE , A.IN_QTY
							, A.CELL_ITEM_ID , A.CELL_NICK , A.BOM_RATE   , A.CELL_QTY  
							, @v_proc_name  AS INSERT_ID
							, GETDATE()     AS INSERT_TIME
					FROM    ( ---- PACK FP PLAN ----
								SELECT  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID 
											, ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID
										, A.CATEGORY_ID 
										, A.TOP_ITEM_ID AS MODEL_CODE
										, C.NICK_NAME   AS MODEL_NICK
										, A.ITEM_ID     AS PACK_ITEM_ID
										, CONVERT(DATE,A.PLAN_DATE) AS PLAN_DATE 
										, SUM(A.IN_QTY) AS IN_QTY 
										, B.CHILD_ITEM_ID  AS CELL_ITEM_ID 
										, B.CELL_NICK 
										, B.BOM_RATE 
										, SUM(A.IN_QTY) * B.BOM_RATE  AS CELL_QTY 
								FROM    FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)
										LEFT OUTER JOIN (														-- (D.20200915~R.0915.01) Hazel Park Plant mapping 시켜줌
															SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID
																	, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID
															FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
															WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
															AND    A.ACTIVE_FLAG = 'Y'
															AND	   A.SEGMENT4 = 'DU'
										) D
											ON  A.DIVISION_ID  	= D.REF_DIVISION_ID
											AND A.SITE_ID      	= D.REF_SITE_ID
											AND A.PLANT_ID     	= D.REF_PLANT_ID
										LEFT OUTER JOIN ( 
															SELECT  A.* , ISNULL(I.NICK_NAME ,'-') AS CELL_NICK
															--FROM    #tempTH_BUF_VB_PACK_BOM A
															FROM    TH_BUF_VB_PACK_BOM A
															LEFT OUTER JOIN SCM_ITEM_M  I WITH(NOLOCK) 
																			ON  1=1
																			AND    A.CHILD_ITEM_ID = I.ITEM_ID
																			AND    A.COMPANY_ID    = I.COMPANY_ID
																			AND    A.DIVISION_ID   = I.DIVISION_ID
																			AND    I.ACTIVE_FLAG   = 'Y'
															WHERE  1=1
															AND    A.SEQ = 1 
															AND    A.INSTANCE_ID  =  @v_master_id
															AND    A.FP_PLAN_ID   =  @v_plan_id
										) B
										ON   1=1
										AND  A.INSTANCE_ID = B.INSTANCE_ID
										AND  A.FP_PLAN_ID  = B.FP_PLAN_ID    
										AND  A.COMPANY_ID  = B.COMPANY_ID
										AND  A.DIVISION_ID = B.DIVISION_ID
										AND  A.SITE_ID     = B.SITE_ID
										AND  ISNULL(D.PLANT_ID, A.PLANT_ID)    = B.PLANT_ID
										AND  A.ITEM_ID     = B.PARENT_ITEM_ID 
										, SCM_ITEM_M C  WITH(NOLOCK)    
								WHERE 1=1
								AND   A.INSTANCE_ID  = @v_master_id
								AND   A.FP_PLAN_ID   = @v_plan_id  
								AND   A.CATEGORY_ID  = 'PLAN' 
								AND   A.OPERATION_ID = 'P5000'
								AND   A.PLAN_DATE   >=  @V_INSTANCE_DATE        
								AND   A.COMPANY_ID   =  C.COMPANY_ID
								AND   A.DIVISION_ID  =  C.DIVISION_ID
								AND   A.SITE_ID      =  C.SITE_ID
								AND   A.TOP_ITEM_ID  =  C.ITEM_ID 
								GROUP BY  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID 
											, ISNULL(D.PLANT_ID, A.PLANT_ID)
											, A.CATEGORY_ID 
											, A.OPERATION_ID
											, A.ITEM_ID
											, A.TOP_ITEM_ID 
											, CONVERT(DATE,A.PLAN_DATE)
											, C.NICK_NAME
											, B.CHILD_ITEM_ID 
											, B.BOM_RATE 
											, CELL_NICK
							) A 
					WHERE  1=1

					--LOG 생성
					SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )  
					SET @v_descr   = 'PLAN_TYPE (' + @V_PLAN_TYPE + ')'
					SET @n_log_count = @n_log_count + 1
					SET @sysdate     = GETDATE()
					EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr  
		  		
		  		END -- PRE 
			ELSE 
		  	BEGIN  ---- @V_PLAN_TYPE = 'RELEASE'
				--INSERT INTO  #tempTH_BUF_VB_PACK_IN_PLAN
				INSERT INTO  TH_BUF_VB_PACK_IN_PLAN
				(   INSTANCE_ID 
					, FP_PLAN_ID 
					, COMPANY_ID 
					, DIVISION_ID 
					, SITE_ID 
					, PLANT_ID
					, CATEGORY_ID 
					, MODEL_CODE 
					, MODEL_NICK 
					, PACK_ITEM_ID 
					, PLAN_DATE 
					, IN_QTY
					, CELL_ITEM_ID 
					, CELL_NICK 
					, BOM_RATE   
					, CELL_QTY  
					, INSERT_ID
					, INSERT_TIME 
				) 
				SELECT  DISTINCT A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID
						, A.CATEGORY_ID , A.MODEL_CODE , A.MODEL_NICK , A.PACK_ITEM_ID , A.PLAN_DATE , A.IN_QTY
						, A.CELL_ITEM_ID , A.CELL_NICK , A.BOM_RATE   , A.CELL_QTY  
						, @v_proc_name  AS INSERT_ID
						, GETDATE()     AS INSERT_TIME
				FROM    ( ---- PACK FP PLAN ----
							SELECT  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID 
									, ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID
									, A.CATEGORY_ID 
									, A.TOP_ITEM_ID AS MODEL_CODE
									, C.NICK_NAME   AS MODEL_NICK
									, A.ITEM_ID     AS PACK_ITEM_ID
									, CONVERT(DATE,A.PLAN_DATE) AS PLAN_DATE 
									, SUM(A.IN_QTY) AS IN_QTY 
									, B.CHILD_ITEM_ID  AS CELL_ITEM_ID 
									, B.CELL_NICK 
									, B.BOM_RATE 
									, SUM(A.IN_QTY) * B.BOM_RATE  AS CELL_QTY 
							FROM    FP_AMEND_PLAN_PACK_H A WITH(NOLOCK)
										LEFT OUTER JOIN (														-- (D.20200915~R.0915.01) Hazel Park Plant mapping 시켜줌
																	SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID
																			, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID
																	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
																	WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'
																	AND    A.ACTIVE_FLAG = 'Y'
																	AND	   A.SEGMENT4 = 'DU'
										) D
											ON  A.DIVISION_ID  	= D.REF_DIVISION_ID
											AND A.SITE_ID      	= D.REF_SITE_ID
											AND A.PLANT_ID     	= D.REF_PLANT_ID
										LEFT OUTER JOIN ( 
																	SELECT  A.* , ISNULL(I.NICK_NAME ,'-') AS CELL_NICK
																	--FROM    #tempTH_BUF_VB_PACK_BOM A
																	FROM    TH_BUF_VB_PACK_BOM A
																	LEFT OUTER JOIN SCM_ITEM_M  I WITH(NOLOCK) 
																					ON  1=1
																					AND    A.CHILD_ITEM_ID = I.ITEM_ID
																					AND    A.COMPANY_ID    = I.COMPANY_ID
																					AND    A.DIVISION_ID   = I.DIVISION_ID
																					AND    I.ACTIVE_FLAG   = 'Y'
																	WHERE  1=1
																	AND    A.SEQ = 1 
																	AND    A.INSTANCE_ID  =  @v_master_id
																	AND    A.FP_PLAN_ID   =  @v_plan_id
										) B
											ON   1=1
											AND  A.INSTANCE_ID = B.INSTANCE_ID
											AND  A.FP_PLAN_ID  = B.FP_PLAN_ID    
											AND  A.COMPANY_ID  = B.COMPANY_ID
											AND  A.DIVISION_ID = B.DIVISION_ID
											AND  A.SITE_ID     = B.SITE_ID
											AND  ISNULL(D.PLANT_ID, A.PLANT_ID)    = B.PLANT_ID
											AND  A.ITEM_ID     = B.PARENT_ITEM_ID 
										, SCM_ITEM_M C  WITH(NOLOCK)    
							WHERE 1=1
							AND   A.INSTANCE_ID  = @v_master_id
							AND   A.FP_PLAN_ID   = @v_plan_id  
							AND   A.CATEGORY_ID  = 'PLAN' 
							AND   A.OPERATION_ID = 'P5000'
							AND   A.PLAN_DATE   >=  @V_INSTANCE_DATE        
							AND   A.COMPANY_ID   =  C.COMPANY_ID
							AND   A.DIVISION_ID  =  C.DIVISION_ID
							AND   A.SITE_ID      =  C.SITE_ID
							AND   A.TOP_ITEM_ID  =  C.ITEM_ID 
							GROUP BY  A.INSTANCE_ID , A.FP_PLAN_ID , A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID 
									, ISNULL(D.PLANT_ID, A.PLANT_ID)
									, A.CATEGORY_ID 
									, A.OPERATION_ID
									, A.ITEM_ID
									, A.TOP_ITEM_ID 
									, CONVERT(DATE,A.PLAN_DATE)
									, C.NICK_NAME
									, B.CHILD_ITEM_ID 
									, B.BOM_RATE 
									, CELL_NICK
							) A 
					WHERE  1=1 
					; 	

					--LOG 생성
					SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )  
					SET @v_descr   = 'PLAN_TYPE (' + @V_PLAN_TYPE + ')'
					SET @n_log_count = @n_log_count + 1
					SET @sysdate     = GETDATE()
					EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr  
			END -- REL

    END  --3

	-----------------------------------------------------
	-- UI TABLE로 I/F ( 릴리즈 버전일때 H로 넣어준다. )
	-----------------------------------------------------
    IF @V_PLAN_TYPE IN ('PRE', 'SYNC')     --- (20191209) KR_PACK: sync 조건 추가
		BEGIN
			SET  @v_table_name = 'FP_AMEND_SIM_CELL_PACK_R'

			DELETE FP_AMEND_SIM_CELL_PACK_R  
			WHERE  INSTANCE_ID =  @v_master_id
			AND    FP_PLAN_ID  =  @v_plan_id ; 

			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
			SET @v_descr   = NULL
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr 

			INSERT INTO	FP_AMEND_SIM_CELL_PACK_R
				(   INSTANCE_ID 
				  , FP_PLAN_ID 
				  , COMPANY_ID 
				  , DIVISION_ID 
				  , SITE_ID 
				  , PLANT_ID
				  , CATEGORY_ID 
				  , MODEL_CODE 
				  , MODEL_NICK 
				  , PACK_ITEM_ID 
				  , PLAN_DATE 
				  , IN_QTY
				  , CELL_ITEM_ID 
				  , CELL_NICK 
				  , BOM_RATE   
				  , CELL_QTY  
				  , ATTB_01
				  , ATTB_02
				  , ATTB_03
				  , ATTB_04
				  , ATTB_05
				  , INSERT_ID
				  , INSERT_TIME 
				) 
			SELECT  DISTINCT INSTANCE_ID 
				  , FP_PLAN_ID 
				  , COMPANY_ID 
				  , DIVISION_ID 
				  , SITE_ID 
				  , PLANT_ID
				  , CATEGORY_ID 
				  , MODEL_CODE 
				  , MODEL_NICK 
				  , PACK_ITEM_ID 
				  , PLAN_DATE 
				  , IN_QTY
				  , CELL_ITEM_ID 
				  , CELL_NICK 
				  , BOM_RATE   
				  , CELL_QTY  
				  , ATTB_01
				  , ATTB_02
				  , ATTB_03
				  , ATTB_04
				  , ATTB_05
				  , @v_proc_name AS  INSERT_ID
				  , GETDATE()    AS INSERT_TIME 
			--FROM    #tempTH_BUF_VB_PACK_IN_PLAN
			FROM    TH_BUF_VB_PACK_IN_PLAN
			WHERE  INSTANCE_ID =  @v_master_id
			AND    FP_PLAN_ID  =  @v_plan_id ; 

			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
			SET @v_descr   = 'PLAN_TYPE (' + @V_PLAN_TYPE + ')'
			SET @n_log_count = @n_log_count + 1
			SET @sysdate     = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr  
		END
		ELSE
		BEGIN
			SET  @v_table_name = 'FP_AMEND_SIM_CELL_PACK_H'
			DELETE FP_AMEND_SIM_CELL_PACK_H  
			WHERE  INSTANCE_ID =  @v_master_id
			AND    FP_PLAN_ID  =  @v_plan_id ; 

			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
			SET @v_descr   = NULL
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, @v_descr 

			INSERT INTO	FP_AMEND_SIM_CELL_PACK_H
				(   INSTANCE_ID 
				  , FP_PLAN_ID 
				  , COMPANY_ID 
				  , DIVISION_ID 
				  , SITE_ID 
				  , PLANT_ID
				  , CATEGORY_ID 
				  , MODEL_CODE 
				  , MODEL_NICK 
				  , PACK_ITEM_ID 
				  , PLAN_DATE 
				  , IN_QTY
				  , CELL_ITEM_ID 
				  , CELL_NICK 
				  , BOM_RATE   
				  , CELL_QTY  
				  , ATTB_01
				  , ATTB_02
				  , ATTB_03
				  , ATTB_04
				  , ATTB_05
				  , INSERT_ID
				  , INSERT_TIME 
				) 
			SELECT DISTINCT INSTANCE_ID 
				  , FP_PLAN_ID 
				  , COMPANY_ID 
				  , DIVISION_ID 
				  , SITE_ID 
				  , PLANT_ID
				  , CATEGORY_ID 
				  , MODEL_CODE 
				  , MODEL_NICK 
				  , PACK_ITEM_ID 
				  , PLAN_DATE 
				  , IN_QTY
				  , CELL_ITEM_ID 
				  , CELL_NICK 
				  , BOM_RATE   
				  , CELL_QTY  
				  , ATTB_01
				  , ATTB_02
				  , ATTB_03
				  , ATTB_04
				  , ATTB_05
				  , @v_proc_name AS  INSERT_ID
				  , GETDATE()    AS INSERT_TIME 
			--FROM    #tempTH_BUF_VB_PACK_IN_PLAN
			FROM    TH_BUF_VB_PACK_IN_PLAN
			WHERE  INSTANCE_ID =  @v_master_id
			AND    FP_PLAN_ID  =  @v_plan_id ; 

			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR,@@ROWCOUNT )
			SET @v_descr   = 'PLAN_TYPE (' + @V_PLAN_TYPE + ')'
			SET @n_log_count = @n_log_count + 1
			SET @sysdate     = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, @v_descr  
		END 
		
		DROP TABLE #tempTH_BUF_VB_PACK_BOM
		DROP TABLE #tempTH_BUF_VB_PACK_IN_PLAN
		DROP TABLE #CELL_ITEM_V
		
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
