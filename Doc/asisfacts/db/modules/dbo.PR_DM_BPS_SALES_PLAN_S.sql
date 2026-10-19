
/*=====================================================================================================================================================
 * Program ID	:	PR_DM_BPS_SALES_PLAN_S
 * Description	:	이동계획 IF_매출
 * 이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상
 * 테이블 
   XIF_BPS_SALES_PLAN_S -->  XIF_BPS_SALES_PLAN_S_SN
 * Program History
 *=====================================================================================================================================================
 *  Date		In Charge   Description
 *=====================================================================================================================================================
 * 2024.05.30	kcw3408		이동계획 IF_매출 배치작업 신규   
 * 2024.07.05	JSSBAE		[E20240703-001284]_이동계획 BPS I/F 관련 개선요청 (CUTOFF 주차 오매핑으로 수정)
 * 2024.09.13	KJJ			[PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 * 2024.10.24.	KJJ			[PJ2024-50611] 소형 이동계획 확산 
 * 2024.11.15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선	
 * 2024.12.03	KJJ			[PJ2024-50611] 소형사업부 Sales Plan Catch Up 수량 추가
 * 2024.12.06	KANG.H.J	[PJ2024-50611] FROM_SITE_ID 전사업부 확대 적용
 * 2024.12.19	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리 - 작업중
 * 2025.04.03	KANG.H.J	[PJ2025-50017] FROM_SITE_ID를 SALES_PLAN의 CELL_PROD_SITE_ID로 정의함.
 * 2025.04.08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.22	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - FUTURE_PRICE를 사업부 단위로 구분처리 (임시테이블 활용)
 * 2025.04.28	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 칼럼 위치 잘못되어 재조정함
 * 2025.07.23	KANG.H.J	[PJ2025-50188] RESULT의 ATTRIBUTE2는 CELL_PROD_SITE_ID와 관계없는 데이터이므로 CELL_PROD_SITE_ID 만으로 조정함. 
 * 2025.08.27	JSSBAE		[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선

 EXEC PR_DM_BPS_SALES_PLAN_S_KJJ2 N'40',N'SP_W_20241205_V002'
 EXEC PR_DM_BPS_SALES_PLAN_S N'ALL',N'ALL'
 EXEC PR_DM_BPS_SALES_PLAN_S N'82',N'SP_W_20240530_V002'
 EXEC PR_DM_BPS_SALES_PLAN_S N'81',N'SP_W_20240613_V001' 
 */
 /*===================================================================================================================================================*/
CREATE PROCEDURE [dbo].[PR_DM_BPS_SALES_PLAN_S]   
	  @p_division_id				NVARCHAR(30)  -- DIVISION_ID
	, @p_cut_off_version			NVARCHAR(50)  -- Version
   
AS  
BEGIN
--메인이 되는 메저 추가한 버전
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON; 	

	BEGIN TRAN PR_DM_BPS_SALES_PLAN_S;
	BEGIN TRY
		--================================================================================================================================================
		-- LOG 용 변수 설정  (START)
		--================================================================================================================================================
		DECLARE @V_PROGRAM_NAME			NVARCHAR(150) = 'PR_DM_BPS_SALES_PLAN_S';
		DECLARE @V_LOG_TYPE				NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @N_LOG_COUNT			INTEGER = 0;
		DECLARE @V_LOG_MESSAGE			NVARCHAR(1000);
		DECLARE @V_DESCRIPTION			NVARCHAR(500);
		DECLARE @D_EVENT_DATE			DATETIME;
		DECLARE @N_DELETE_COUNT			INTEGER = 0;
		DECLARE @N_INSERT_COUNT			INTEGER = 0;
		DECLARE @V_CREATED_BY			NVARCHAR(150) = 'SYS_BATCH_DATA'; 		
		DECLARE @v_CNT					INTEGER = 0;  
		DECLARE @v_yyyymmdd				NVARCHAR(08);
		DECLARE @v_from_yyyymmdd		NVARCHAR(08); -- Cutoff 월 01일
		DECLARE @v_to_yyyymmdd			NVARCHAR(08); -- Cutoff 주차 월요일
	    DECLARE @v_VERSION_NO			NVARCHAR(50);	
    	--DECLARE @v_from_yyyymmdd_R NVARCHAR(08); -- [PJ2024-50611] 사용하지 않는 실적용 변수 삭제
	    --DECLARE @v_to_yyyymmdd_R   NVARCHAR(08); -- [PJ2024-50611] 사용하지 않는 실적용 변수 삭제
		--================================================================================================================================================
		-- LOG 용 변수 설정  (END)
		--================================================================================================================================================
		 
		--================================================================================================================================================
		-- 시작 LOG	(START)
		--================================================================================================================================================
		SET @V_LOG_TYPE		= 'START';
		SET @V_LOG_MESSAGE	= '########## START OF PROCEDURE ##########';
		SET @V_DESCRIPTION	= 'PR_DM_BATCH_IF:' + @p_division_id + '/' + @p_cut_off_version ;
		SET @D_EVENT_DATE	= SYSDATETIME();
		EXEC PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
 	   
		--================================================================================================================================================
		-- 시작 LOG (END)
		--================================================================================================================================================		
PRINT @V_PROGRAM_NAME +' : A001--' + CONVERT(VARCHAR(30), GETDATE(), 121);		

		BEGIN		 
			--================================================================================================================================================
			-- Temp Table 존재 여부 체크 (START)
			--================================================================================================================================================
			IF OBJECT_ID (N'tempdb..#TEMP_VERSION_NO', N'U') IS NOT NULL 
				DROP TABLE #TEMP_VERSION_NO;      
			IF OBJECT_ID (N'tempdb..#TEMP_SCM_SYS_CALENDAR_M', N'U') IS NOT NULL 
				DROP TABLE #TEMP_SCM_SYS_CALENDAR_M;        
			IF OBJECT_ID (N'tempdb..#TEMP_VERSION_SEQ', N'U') IS NOT NULL 
				DROP TABLE #TEMP_VERSION_SEQ;    			     
			IF OBJECT_ID (N'tempdb..#TEMP_PRICE', N'U') IS NOT NULL 
				DROP TABLE #TEMP_PRICE;    			 		
			--================================================================================================================================================
			-- Temp Table 존재 여부 체크 (END)
			--================================================================================================================================================
PRINT @V_PROGRAM_NAME +' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121);		

			--================================================================================================================================================
			-- Temp Table 생성 (START)
			--================================================================================================================================================
			CREATE TABLE #TEMP_PRICE  
			(	DIVISION_ID				NVARCHAR(30) 
			  , VERSION_NO				NVARCHAR(50) 
			  ,	CUTOFF_TYPE				NVARCHAR(10) 
			  ,	CUTOFF_YYYYMMDD			NVARCHAR(8) 
			  ,	PROJECT_CODE			NVARCHAR(50) 
			  , END_CUSTOMER			NVARCHAR(100) 
			  , SCM_SITE_ID				NVARCHAR(30) 
			  , PLANT_SITE_ID			NVARCHAR(30) 
			  , CELL_PROD_SITE_ID		NVARCHAR(30) 
			  ,	ITEM_ID					NVARCHAR(50) 
			  ,	YYYYMMDD				NVARCHAR(8) 
			  ,	CURRENCY				NVARCHAR(10)
			  ,	MEASURE					NVARCHAR(50) 
			  ,	DOM_EXP					NVARCHAR(3) 
			  ,	FCST_TYPE				NVARCHAR(20) 
			  ,	INCOTERMS				NVARCHAR(10) 
			  ,	PRICE					NUMERIC(20, 10));			
			  
PRINT @V_PROGRAM_NAME +' : A003--' + CONVERT(VARCHAR(30), GETDATE(), 121);		
			--================================================================================================================================================
			-- Temp Table 생성 (END)
			--================================================================================================================================================			  	       
			IF @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL'
				BEGIN		
					SET @v_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112) 
				END
			ELSE 
				BEGIN		
					SET @v_yyyymmdd = SUBSTRING(@p_cut_off_version, 6, 8)
				END   
			 
PRINT @V_PROGRAM_NAME +' : A004--' + CONVERT(VARCHAR(30), GETDATE(), 121);		
			--================================================================================================================================================
			-- 기간설정
			-- 실적: 해당월1일 부터 CUTOFF 해당주 월요일 전일
			-- 계획: CUTOFF 해당주 월요일부터 52주차 까지 			
			--================================================================================================================================================	
			--------------------------------------------------------------------------------------------------------------------------------------------------
			-- [E20250825-000297]_BPS 전송 주차를 유동적으로 변경하기위하여 룩업을 사용하여 사업부별로 조정할수있도록 수정 (START)
			-- 수정배경: 일반적으로 월별로 전송하는 BPS는 52주차를 전송하지만, 사업계획을 전송하는 경우에는 주차가 다르므로 보내는 목적에 따라 주차가 달라짐
			-- 관련룩업: DM_BPS_PLAN_WEEK
			--------------------------------------------------------------------------------------------------------------------------------------------------
			DECLARE @v_plan_week		VARCHAR(30);

			SELECT @v_plan_week = A.SEGMENT2
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
			 WHERE A.LOOKUP_TYPE = 'DM_BPS_PLAN_WEEK'
			   AND A.SEGMENT1 = @p_division_id

PRINT @V_PROGRAM_NAME +' : A005--' + ' / Plan_Week: '+ @v_plan_week + ' / '+  CONVERT(VARCHAR(30), GETDATE(), 121);		
			--------------------------------------------------------------------------------------------------------------------------------------------------
			-- [E20250825-000297]_BPS 전송 주차를 유동적으로 변경하기위하여 룩업을 사용하여 사업부별로 조정할수있도록 수정 (END)
			--------------------------------------------------------------------------------------------------------------------------------------------------

			SET @v_from_yyyymmdd	= CONVERT(VARCHAR, CONVERT(CHAR(6), @v_yyyymmdd,  112) + '01', 112)  
			--------------------------------------------------------------------------------------------------------------------------------------------------
			-- [E20250825-000297]_BPS 전송 주차 룩업의 변수로 받아서 처리 하는 부분으로 변경 과거 소스 주석처리  (START)
			--SET @v_to_yyyymmdd		= CONVERT(CHAR(8), DATEADD(DD, - 1, DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( @v_yyyymmdd, 'MON')), 112) )),  112) 
			SET @v_to_yyyymmdd		= CONVERT(CHAR(8), DATEADD(DD, - 1, DATEADD(WW, CONVERT(INT, @v_plan_week), CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( @v_yyyymmdd, 'MON')), 112) )),  112) 
			-- [E20250825-000297]_BPS 전송 주차 룩업의 변수로 받아서 처리 하는 부분으로 변경 과거 소스 주석처리  (END)
			--------------------------------------------------------------------------------------------------------------------------------------------------
			
PRINT @V_PROGRAM_NAME +' : A006--' + ' / from_yyyymmdd: '+ @v_from_yyyymmdd + ' / to_yyyymmdd: '+ @v_to_yyyymmdd + ' / '+ CONVERT(VARCHAR(30), GETDATE(), 121);		

			--================================================================================================================================================
			--  BPS I/F 진행할 TEMP 테이블 데이터 INSERT (START)
			--================================================================================================================================================
			SELECT MIN(B.BASIS_YYYYMMDD) AS BASIS_YYYYMMDD_WK_FROM
				 , MAX(B.BASIS_YYYYMMDD) AS BASIS_YYYYMMDD_WK_TO 
				 , MAX(SUBSTRING(A.CALENDAR_YYYY,3,2) + 'RF_DM_' + A.CALENDAR_YYYY + '_' + A.WEEK_NAME + '_V') AS VERSION_NO_T  
				 , MAX(A.ISO_WEEK) AS ISO_WEEK 
			  INTO #TEMP_SCM_SYS_CALENDAR_M
			  FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
			 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.ISO_YYYYWW = B.ISO_YYYYWW 
			 WHERE A.BASIS_YYYYMMDD = CONVERT(CHAR(8), @v_yyyymmdd,  112) 

			--================================================================================================================================================
			--  BPS I/F 진행할 TEMP 테이블 데이터 INSERT (END)
			--================================================================================================================================================	
PRINT @V_PROGRAM_NAME +' : A007--' + CONVERT(VARCHAR(30), GETDATE(), 121);		
			--================================================================================================================================================
			--  이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상 TEMP 테이블 데이터 INSERT (START)
			--================================================================================================================================================

			SELECT A.DIVISION_ID, A.VERSION_NO, A.MONTHLY_ROLLING_FCST, A.VERSION_NO_T, A.ISO_WEEK, SUBSTRING(A.YYYYMMDD,1,6) AS CUTOFF_YYYYMM 
				 , CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.YYYYMMDD, 'MON')), 112) AS to_yyyymmdd_R
			  INTO #TEMP_VERSION_NO
			  FROM ( SELECT ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID,A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
						  , A.DIVISION_ID, A.VERSION_NO, A.VERSION_TYPE, B.VERSION_NO_T, B.ISO_WEEK, A.YYYYMMDD, ISNULL(A.ATTRIBUTE7, 'N') AS MONTHLY_ROLLING_FCST  
					   FROM DM_MST_VERSION A WITH (NOLOCK) 
						  , #TEMP_SCM_SYS_CALENDAR_M B
					  WHERE 1 = 1
					  --AND A.DIVISION_ID NOT IN ('40')--[PJ2024-50611] 40번 사업부도 사용 가능하게 제약조건 주석처리
						AND A.VERSION_TYPE	= 'SP_W' 
						AND A.DIVISION_ID	= CASE WHEN @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL' THEN A.DIVISION_ID ELSE @p_division_id END
						AND A.VERSION_NO	= CASE WHEN @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL' THEN A.VERSION_NO ELSE @p_cut_off_version END
						AND ISNULL(A.ATTRIBUTE7, 'N') = 'Y'
						AND A.YYYYMMDD BETWEEN B.BASIS_YYYYMMDD_WK_FROM AND B.BASIS_YYYYMMDD_WK_TO ) A
			  WHERE A.RNK = 1    		
			--================================================================================================================================================
			--  이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상 TEMP 테이블 데이터 INSERT (END)
			--================================================================================================================================================
PRINT @V_PROGRAM_NAME +' : A008--' + CONVERT(VARCHAR(30), GETDATE(), 121);					
			--================================================================================================================================================
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - FUTURE_PRICE를 사업부 단위로 구분처리 (임시테이블 활용) (START)
			--================================================================================================================================================
			INSERT INTO #TEMP_PRICE 
			( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID
			, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
			SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
				 , A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
			  FROM DM_PLN_CFM_SELLING_PRICE_C A WITH(NOLOCK)
			 INNER JOIN (	SELECT DIVISION_ID, VERSION_NO
							FROM #TEMP_VERSION_NO WITH(NOLOCK)
							WHERE DIVISION_ID = '40'
							GROUP BY DIVISION_ID, VERSION_NO ) B
					  ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO	= B.VERSION_NO
			UNION ALL
			SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
				 , A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
			  FROM SCM_MST_FUTURE_PRICE_C A WITH(NOLOCK)
			 INNER JOIN (	SELECT DIVISION_ID, VERSION_NO
							FROM #TEMP_VERSION_NO  WITH(NOLOCK)
							WHERE DIVISION_ID <> '40'
							GROUP BY DIVISION_ID, VERSION_NO ) B
					  ON A.DIVISION_ID = B.DIVISION_ID AND A.VERSION_NO	= B.VERSION_NO;

			--================================================================================================================================================
			-- [PJ2025-50017] 소형 매출계획 동기화 개선 - FUTURE_PRICE를 사업부 단위로 구분처리 (임시테이블 활용) (END)
			--================================================================================================================================================
PRINT @V_PROGRAM_NAME +' : A009--' + CONVERT(VARCHAR(30), GETDATE(), 121);					
			
			--================================================================================================================================================
			-- 최종버젼을 가져온다 (START)
			--================================================================================================================================================
			SELECT A.DIVISION_ID, REPLICATE('0', 2 - LEN(CAST(A.VERSION_SEQ AS NVARCHAR(10)))) + CAST(A.VERSION_SEQ AS NVARCHAR(10))  AS VERSION_SEQ
			  INTO #TEMP_VERSION_SEQ
			  FROM ( SELECT A.DIVISION_ID, SUBSTRING(MAX(A.VERSION_NO), 19, 2) + 1 AS VERSION_SEQ
					   FROM XIF_BPS_SALES_PLAN_S_SN A WITH(NOLOCK)
						 , #TEMP_VERSION_NO Z WITH(NOLOCK) 
					  WHERE 1 = 1
						AND A.DIVISION_ID = Z.DIVISION_ID   
						AND A.VERSION_NO  LIKE VERSION_NO_T + '%' 
					  GROUP BY A.DIVISION_ID ) A 
			--================================================================================================================================================
			-- 최종버젼을 가져온다 (END)
			--================================================================================================================================================
		END
		 
PRINT ( 'A2-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
   
		/* 20240228 KCW3408 속도개선_템프사용 */	
		BEGIN   
			IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL 
					DROP TABLE #TEMP_SCM_MST_SITE      

			SELECT B.SCM_SITE_ID
				 , B.DIVISION_ID
				 , B.DEPT_ID
				 , K.SOLDTO_CODE
				 , K.SHIPTO_CODE
				 , B.VMI_YN
				 , B.END_CUSTOMER
				 , H.CITY_NAME 
				 , J.COUNTRY_NAME
				 , L.SHIPTO_DESCRIPTION
				 , L.SOLDTO_DESCRIPTION 
				 , B.VALID_YN
			INTO #TEMP_SCM_MST_SITE      
			FROM SCM_MST_SITE B WITH(NOLOCK) 
			LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K WITH(NOLOCK)
						 ON B.DIVISION_ID = K.DIVISION_ID 
						AND B.SCM_SITE_ID = K.SCM_SITE_ID 
					  --AND K.VALID_YN = 'Y'   
						AND K.REP_YN = 'Y'  	
			LEFT OUTER JOIN SCM_MST_CITY H WITH(NOLOCK)
						 ON B.CITY = H.CITY     
			LEFT OUTER JOIN SCM_MST_COUNTRY J WITH(NOLOCK) 
						 ON B.COUNTRY = J.COUNTRY      
			LEFT OUTER JOIN SCM_MST_CUSTOMER L WITH(NOLOCK)
						 ON K.DIVISION_ID = L.DIVISION_ID 
						AND K.SHIPTO_CODE = L.SHIPTO_CODE 
						AND K.SOLDTO_CODE = L.SOLDTO_CODE
		END 
		 
PRINT ( 'A3-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121))  


		INSERT INTO XIF_BPS_SALES_PLAN_S_SN 
		(  IFDATE, IFTIME, IFUSER, IFSERVICE, CUTOFF_YYYYMM, VERSION_NO, CUTOFF_ISO_WEEK, CUTOFF_YYYYMMDD, DIVISION_ID, DEPT_ID, DEPT_NAME
		, SCM_SITE_ID, FCST_TYPE, FCST_TYPE_NAME, COMPANY_ID, SALES_PLANT, SOLDTO_CODE, SHIPTO_CODE, END_CUSTOMER, INCOTERMS, PROJECT_CODE 
		, PLANT_SITE_ID, ITEM_ID, BIZ_TYPE, BIZ_TYPE_NAME, CURRENCY, PLAN_YYYYMM, SALES_QTY, ITEM_UOM, SALES_PRICE, CELL_PER_MODULE, MODULE_PER_CAR
		, KWH_PER_CELL, CELL_PER_CAR, ENERGE, CREATION_DATE, TRANSFER_DATE, TRANSFER_FLAG, ETL_LOAD_DATE, VALUE_TBL_INFO, SRC_SYS_CD, FROM_SITE_ID, CATCH_UP_QTY)  --[PJ2024-50611] 소형사업부 Sales Plan Catch Up 수량 추가
		SELECT '' AS IFDATE              
			, '' AS IFTIME              /* 전송 시간 */ 
			, '' AS IFUSER              /* 전송 유저 */
			, '' AS IFSERVICE           /* 서비스 인터페이스명 */
			, T1.CUTOFF_YYYYMM         /* 컷오프년월 */
			, T1.VERSION_NO            /* 버전번호 */ 
			, T1.CUTOFF_ISO_WEEK       /* 컷오프ISO주차 */
			, T1.CUTOFF_YYYYMMDD       /* 컷오프년월일 */
			, T1.DIVISION_ID    
			, T1.DEPT_ID               /* 부서ID */
			, T2.DEPT_NAME_KO           /* 부서명 */
			, T1.SCM_SITE_ID    
			, T1.FCST_TYPE              /* 예측유형 */
			, ISNULL(T3.SEGMENT2,'') AS FCST_TYPE_NAME              /* 예측유형명 */
			, T1.COMPANY_ID             /* 회사ID */
			, T1.SALES_PLANT             /* SalesPlant */
			, T1.SOLDTO_CODE            /* Soldto Code */
			, T1.SHIPTO_CODE            /* Shipto Code */
			, T1.END_CUSTOMER           /* End Customer */ 
			, T1.INCOTERMS             /* Incoterms */ 
			, T1.PROJECT_CODE          /* 프로젝트코드 */ 
			, T1.PLANT_SITE_ID         /* 플랜트사이트ID */  
			, T1.ITEM_ID   
			, T1.BIZ_TYPE              /* 사업유형 */
			, ISNULL(T4.SEGMENT2,'') AS BIZ_TYPE_NAME  /* 사업유형명 */
			, T1.CURRENCY              /* 통화코드 */ 
			, T1.PLAN_YYYYMM                    /* 계획년월 */  
			, CAST(STR(SUM(T1.SALES_QTY), 20, 5 ) AS NUMERIC(30,10))  AS SALES_QTY     /* 매출수량 */ 
			--, CAST(STR(SUM(T1.QTY), 20, 5 ) AS NUMERIC(30,10))  AS QTY     /* 매출수량 */
			, T1.ITEM_UOM              /* Item UOM */
			, CAST(STR(AVG(T1.SALES_PRICE), 20, 5 ) AS NUMERIC(30,10))  AS SALES_PRICE   /* Sales Price(LOC) */ 
			, CAST(STR(ISNULL(T1.CELL_PER_MODULE,0), 20, 5 ) AS NUMERIC(30,10))  AS CELL_PER_MODULE   /* Cell/Module */ 
			, CAST(STR(ISNULL(T1.MODULE_PER_CAR,0), 20, 5 ) AS NUMERIC(30,10))  AS MODULE_PER_CAR   /* Module/Car */ 
			, CAST(STR(ISNULL(T1.KWH_PER_CELL,0), 20, 5 ) AS NUMERIC(30,10))  AS KWH_PER_CELL   /* KWh/Cell */ 
			, CAST(STR(ISNULL(T1.CELL_PER_CAR,0), 20, 5 ) AS NUMERIC(30,10))  AS CELL_PER_CAR   /* Cell/Car */ 
			, CAST(STR(ISNULL(T1.ENERGE,0), 20, 5 ) AS NUMERIC(30,10))  AS ENERGE   /* ENERGE */ 
			, SYSDATETIME() AS CREATION_DATE   
			, SYSDATETIME() AS TRANSFER_DATE           
			, 'N' AS TRANSFER_FLAG    
			, SYSDATETIME() AS ETL_LOAD_DATE              /* etl적재일자 */
			, '' AS VALUE_TBL_INFO                        /* 값테이블정보 */
			, 'SCM' AS SRC_SYS_CD                         /* 소스시스템코드 */ 	
			, T1.FROM_SITE_ID 							  --[PJ2024-50611] FROM_SITE_ID 추가		
			, CAST(STR(AVG(T1.CATCHUP_QTY), 20, 5 ) AS NUMERIC(30,10))--[PJ2024-50611] 소형사업부 Sales Plan Catch Up 수량 추가 
		FROM( SELECT LEFT(A.CUTOFF_YYYYMMDD,6) AS CUTOFF_YYYYMM         /* 컷오프년월 */
				, Z.VERSION_NO_T + ISNULL(Y.VERSION_SEQ,'01') AS VERSION_NO          /* 버전번호 */ 
				--[E20240703-001284]_이동계획 BPS I/F 관련 개선요청 (CUTOFF 주차 오매핑으로 수정)
				--, F.ISO_WEEK AS CUTOFF_ISO_WEEK     /* 컷오프ISO주차 */
				, Z.ISO_WEEK AS CUTOFF_ISO_WEEK     /* 컷오프ISO주차 */
				, A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD     /* 컷오프년월일 */
				, A.DIVISION_ID   
				--[PJ2024-50461] Sales Site Project Model 의 부서 정보
				--, CASE WHEN A.DIVISION_ID = '40' THEN SU.DEPT_ID ELSE C.DEPT_ID END AS DEPT_ID       /* 부서ID */
				,SU.DEPT_ID
				--[PJ2024-50461] Sales Site Project Model 의 부서 정보
				, A.SCM_SITE_ID    
				, A.FCST_TYPE              /* 예측유형 */
				, D.SALES_COMPANY AS COMPANY_ID             /* 회사ID */
				, D.SALES_PLANT            /* SalesPlant */
				, C.SOLDTO_CODE            /* Soldto Code */
				, C.SHIPTO_CODE            /* Shipto Code */
				, A.INCOTERMS             /* Incoterms */ 
				--[PJ2024-50611] 소형 이동계획 확산 start
				--, C.END_CUSTOMER           /* End Customer */ 
				--, A.PROJECT_CODE          /* 프로젝트코드 */ 
				--소형일 경우 PROJECT_CODE로 비교. 나머지는 END_CUSTOMER로 비교
				, CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE C.END_CUSTOMER END   AS END_CUSTOMER        /* End Customer */  
				--소형일 경우 공백 비교. 나머지는 PROJECT_CODE로 비교
				, CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE A.PROJECT_CODE  END AS  PROJECT_CODE       /* 프로젝트코드 */  
				--[PJ2024-50611] 소형 이동계획 확산 end
				, A.PLANT_SITE_ID         /* 플랜트사이트ID */	
				, A.ITEM_ID               /* 아이템ID */
				--[PJ2024-50611] 소형일 경우 공백. 나머지는 BIZ_TYPE로 분기
				--, G.BIZ_TYPE AS BIZ_TYPE  /* 사업유형 */
				, CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE G.BIZ_TYPE END AS BIZ_TYPE  /* 사업유형 */
				--[PJ2024-50611] 소형일 경우 공백. 나머지는 BIZ_TYPE로 분기
				, A.CURRENCY              /* 통화코드 */ 
				, LEFT(ISNULL(A.YYYYMMDD, A.YYYYMMDD),6) AS PLAN_YYYYMM                    /* 계획년월 */	--[PJ2024-50611] FROM_SITE_ID 추가 / RTF_ALLOC 기준으로 날짜 적용 : Catch Up 관련하여 조인 변경되어 없을 경우 DM_PLN_SALES_PLAN_C의 날짜 넘김 --[PJ2025-50017] SALES_PLAN 기반으로 정의
				-- , ROUND(CASE WHEN ISNULL(B.PRICE,0) <> 0 THEN A.QTY/B.PRICE ELSE 0 END,9) AS SALES_QTY     /* 매출수량 */   
				, CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN ISNULL(A.QTY, 0) ELSE 0 END AS SALES_QTY


				, H.ITEM_UOM              /* Item UOM */
				--[PJ2024-50611] 소형사업부 Sales Plan Catch Up 추가 START
				, ISNULL(B.PRICE,0) AS SALES_PRICE    /* Sales Price(LOC) */
				/*, CASE WHEN A.MEASURE = 'SalesAmt_KRW_Catch_Up' AND A.QTY > 0 THEN A.QTY 
					ELSE ISNULL(B.PRICE,0) 
				END AS SALES_PRICE --Catch Up Sales Amount가 있으면 그 값을 전달 */
				---[PJ2024-50611] 소형사업부 Sales Plan Catch Up 추가 END

				, ISNULL(D.CELL_PER_MODULE,0) AS  CELL_PER_MODULE               /* Cell/Module */
				, CASE WHEN ISNULL(D.CELL_PER_MODULE,0)  <> 0 THEN ISNULL(D.CELL_PER_CAR,0) / ISNULL(D.CELL_PER_MODULE,0) ELSE 0 END AS MODULE_PER_CAR            /* Module/Car */
				, ISNULL(D.ATTRIBUTE8,0) AS KWH_PER_CELL                    /* KWh/Cell */
				, ISNULL(D.CELL_PER_CAR,0) AS CELL_PER_CAR             /* Cell/Car */
				, H.ENERGE               /* ENERGY */ 
				--, ISNULL(A.CELL_PROD_SITE_ID, '') AS FROM_SITE_ID	--[PJ2024-50611] FROM_SITE_ID 추가 : Catch Up 관련하여 조인 변경되어 ISNULL 처리 --[PJ2025-50017] SALES_PLAN 기반으로 정의
				, CASE WHEN (A.DIVISION_ID = '40' AND ISNULL(A.CELL_PROD_SITE_ID, '-') = '-') THEN ISNULL(A.ATTRIBUTE2, '-') ELSE ISNULL(A.CELL_PROD_SITE_ID, '-') END AS FROM_SITE_ID	--[PJ2024-50611] FROM_SITE_ID 추가 : Catch Up 관련하여 조인 변경되어 ISNULL 처리 --[PJ2025-50017] SALES_PLAN 기반으로 정의 / BPS 전송용 FROM_SITE_ID 추가 (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
				, CASE WHEN A.MEASURE = 'Catch_Up' THEN ISNULL(A.QTY, 0) ELSE 0 END AS CATCHUP_QTY--[PJ2024-50611] 소형사업부 Sales Plan Catch Up 수량
				, A.MEASURE--[PJ2024-50611]소형사업부 Sales Plan Catch Up :  밖에서 MEASURE로 구분하기 위해 추가

				FROM DM_PLN_SALES_PLAN_C A WITH(NOLOCK)   

				LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) 
							ON A.DIVISION_ID = Z.DIVISION_ID      
				LEFT OUTER JOIN #TEMP_VERSION_SEQ Y WITH(NOLOCK) 
							ON A.DIVISION_ID = Y.DIVISION_ID    
				LEFT OUTER JOIN #TEMP_SCM_MST_SITE C WITH(NOLOCK) 
							ON A.DIVISION_ID = C.DIVISION_ID 
							AND A.SCM_SITE_ID = C.SCM_SITE_ID 
							AND C.VALID_YN = 'Y'   
				LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK) 
							ON A.DIVISION_ID = D.DIVISION_ID 
							AND A.PROJECT_CODE = D.PROJECT_CODE 
							AND A.SCM_SITE_ID = D.SCM_SITE_ID
							AND A.ITEM_ID = D.ITEM_ID 
							AND D.VALID_YN = 'Y'  
				LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) 
							ON SU.USER_ID = (SELECT TOP 1 token FROM [dbo].[String_Split](D.owner, ','))  
				LEFT OUTER JOIN SCM_MST_PROJECT    G WITH(NOLOCK) 
							ON A.DIVISION_ID = G.DIVISION_ID 
							AND A.PROJECT_CODE = G.PROJECT_CODE  
				LEFT OUTER JOIN ( SELECT T1.DIVISION_ID
									, T1.ITEM_ID
									, MAX(T1.ITEM_UOM) AS ITEM_UOM
									, MAX(T1.ENERGE)   AS ENERGE		 
								FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)	
								GROUP BY T1.DIVISION_ID, T1.ITEM_ID) H
							ON A.DIVISION_ID = H.DIVISION_ID  
							AND A.ITEM_ID = H.ITEM_ID 
				LEFT OUTER JOIN SCM_SYS_CALENDAR_M F WITH (NOLOCK) 
						ON A.YYYYMMDD = F.BASIS_YYYYMMDD  
				LEFT OUTER JOIN ( SELECT A.DIVISION_ID   
								 		, A.PROJECT_CODE  
										, A.END_CUSTOMER
										, A.SCM_SITE_ID   
										, A.PLANT_SITE_ID   
										, A.ITEM_ID    
										, A.INCOTERMS   
										, A.DOM_EXP   
										, A.FCST_TYPE  
										, A.CURRENCY  
										, A.MEASURE  
										, A.YYYYMMDD   
										, A.PRICE
										, A.CELL_PROD_SITE_ID
--									FROM SCM_MST_FUTURE_PRICE_C A WITH(NOLOCK)    
									FROM #TEMP_PRICE A WITH(NOLOCK)    
									LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) 
												ON A.DIVISION_ID = Z.DIVISION_ID  
									WHERE A.YYYYMMDD >= Z.to_yyyymmdd_R 
									AND A.YYYYMMDD <= @v_to_yyyymmdd 
		  							AND A.MEASURE = 'LOC' 
									AND A.VERSION_NO = Z.VERSION_NO    
								) B ON  A.DIVISION_ID = B.DIVISION_ID  
								AND A.PROJECT_CODE = CASE WHEN B.DIVISION_ID = '40' THEN B.END_CUSTOMER ELSE B.PROJECT_CODE  END
								AND A.SCM_SITE_ID = B.SCM_SITE_ID  
								AND A.PLANT_SITE_ID = B.PLANT_SITE_ID  
								AND A.ITEM_ID = B.ITEM_ID  
								AND A.INCOTERMS = B.INCOTERMS  
								AND A.DOM_EXP = B.DOM_EXP  
								AND A.FCST_TYPE = B.FCST_TYPE  
								AND A.CURRENCY = B.CURRENCY  
								AND F.BASIS_START_DATE = B.YYYYMMDD  
				WHERE A.YYYYMMDD >= Z.to_yyyymmdd_R 
				AND A.YYYYMMDD <= @v_to_yyyymmdd
				AND A.MEASURE = 'RTF_SYS_RP'--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : Catch_Up 메저 제외(별도 테이블에서 처리)
				--AND A.MEASURE IN ('RTF_SYS_RP', 'Catch_Up') --[PJ2024-50611] 소형사업부 Sales Plan Catch Up 수량 추가 : MEASURE 추가 
				AND A.QTY  <> 0
				AND ISNULL(B.PRICE,0)  <> 0
				AND A.VERSION_NO = Z.VERSION_NO
				AND CASE WHEN A.DIVISION_ID ='40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = CASE WHEN A.DIVISION_ID ='40' THEN B.CELL_PROD_SITE_ID ELSE '-' END	--[PJ2025-50017] 
				--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 start
				UNION ALL
				SELECT LEFT(A.CUTOFF_YYYYMMDD,6) AS CUTOFF_YYYYMM         /* 컷오프년월 */
				, Z.VERSION_NO_T + ISNULL(Y.VERSION_SEQ,'01') AS VERSION_NO          /* 버전번호 */ 
				, Z.ISO_WEEK AS CUTOFF_ISO_WEEK     /* 컷오프ISO주차 */
				, A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD     /* 컷오프년월일 */
				, A.DIVISION_ID   
				,SU.DEPT_ID
				, A.SCM_SITE_ID    
				, A.FCST_TYPE              /* 예측유형 */
				, D.SALES_COMPANY AS COMPANY_ID             /* 회사ID */
				, D.SALES_PLANT            /* SalesPlant */
				, C.SOLDTO_CODE            /* Soldto Code */
				, C.SHIPTO_CODE            /* Shipto Code */
				, A.INCOTERMS             /* Incoterms */ 
				, CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE C.END_CUSTOMER END   AS END_CUSTOMER        /* End Customer */  
				, CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE A.PROJECT_CODE  END AS  PROJECT_CODE       /* 프로젝트코드 */  
				, A.PLANT_SITE_ID         /* 플랜트사이트ID */	
				, A.ITEM_ID               /* 아이템ID */
				, CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE G.BIZ_TYPE END AS BIZ_TYPE  /* 사업유형 */
				--[PJ2024-50611] 소형일 경우 공백. 나머지는 BIZ_TYPE로 분기
				, A.CURRENCY              /* 통화코드 */ 
				, LEFT(ISNULL(A.YYYYMMDD, A.YYYYMMDD),6) AS PLAN_YYYYMM                    /* 계획년월 */	--[PJ2024-50611] FROM_SITE_ID 추가 / RTF_ALLOC 기준으로 날짜 적용 : Catch Up 관련하여 조인 변경되어 없을 경우 DM_PLN_SALES_PLAN_C의 날짜 넘김 --[PJ2025-50017] SALES_PLAN 기반으로 정의
				, CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN ISNULL(A.QTY, 0) ELSE 0 END AS SALES_QTY		 --[PJ2025-50017] SALES_PLAN 기반으로 정의
				, H.ITEM_UOM              /* Item UOM */
				, ISNULL(B.PRICE,0) AS SALES_PRICE    /* Sales Price(LOC) */
				, ISNULL(D.CELL_PER_MODULE,0) AS  CELL_PER_MODULE               /* Cell/Module */
				, CASE WHEN ISNULL(D.CELL_PER_MODULE,0)  <> 0 THEN ISNULL(D.CELL_PER_CAR,0) / ISNULL(D.CELL_PER_MODULE,0) ELSE 0 END AS MODULE_PER_CAR            /* Module/Car */
				, ISNULL(D.ATTRIBUTE8,0) AS KWH_PER_CELL                    /* KWh/Cell */
				, ISNULL(D.CELL_PER_CAR,0) AS CELL_PER_CAR             /* Cell/Car */
				, H.ENERGE               /* ENERGY */ 
--				, ISNULL(A.CELL_PROD_SITE_ID, '') AS FROM_SITE_ID	--[PJ2024-50611] FROM_SITE_ID 추가 : Catch Up 관련하여 조인 변경되어 ISNULL 처리  --[PJ2025-50017] SALES_PLAN 기반으로 정의
				, '-'							  AS FROM_SITE_ID	--[PJ2024-50611] FROM_SITE_ID 추가 : Catch Up 관련하여 조인 변경되어 ISNULL 처리  --[PJ2025-50017] SALES_PLAN 기반으로 정의
				, CASE WHEN A.MEASURE = 'Catch_Up' THEN ISNULL(A.QTY, 0) ELSE 0 END AS CATCHUP_QTY--[PJ2024-50611] 소형사업부 Sales Plan Catch Up 수량
				, A.MEASURE--[PJ2024-50611]소형사업부 Sales Plan Catch Up :  밖에서 MEASURE로 구분하기 위해 추가

				FROM DM_PLN_SALES_ETC_PLAN_C A WITH(NOLOCK)   
				LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) 
							ON A.DIVISION_ID = Z.DIVISION_ID      
				LEFT OUTER JOIN #TEMP_VERSION_SEQ Y WITH(NOLOCK) 
							ON A.DIVISION_ID = Y.DIVISION_ID    
				LEFT OUTER JOIN #TEMP_SCM_MST_SITE C WITH(NOLOCK) 
							ON A.DIVISION_ID = C.DIVISION_ID 
							AND A.SCM_SITE_ID = C.SCM_SITE_ID 
							AND C.VALID_YN = 'Y'   
				LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK) 
							ON A.DIVISION_ID = D.DIVISION_ID 
							AND A.PROJECT_CODE = D.PROJECT_CODE 
							AND A.SCM_SITE_ID = D.SCM_SITE_ID
							AND A.ITEM_ID = D.ITEM_ID 
							AND D.VALID_YN = 'Y'  
				LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) 
							ON SU.USER_ID = (SELECT TOP 1 token FROM [dbo].[String_Split](D.owner, ','))  
				LEFT OUTER JOIN SCM_MST_PROJECT    G WITH(NOLOCK) 
							ON A.DIVISION_ID = G.DIVISION_ID 
							AND A.PROJECT_CODE = G.PROJECT_CODE  
				LEFT OUTER JOIN ( SELECT T1.DIVISION_ID
									, T1.ITEM_ID
									, MAX(T1.ITEM_UOM) AS ITEM_UOM
									, MAX(T1.ENERGE)   AS ENERGE		 
								FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)	
								GROUP BY T1.DIVISION_ID, T1.ITEM_ID) H
							ON A.DIVISION_ID = H.DIVISION_ID  
							AND A.ITEM_ID = H.ITEM_ID 
				LEFT OUTER JOIN SCM_SYS_CALENDAR_M F WITH (NOLOCK) 
						ON A.YYYYMMDD = F.BASIS_YYYYMMDD  
				LEFT OUTER JOIN ( SELECT A.DIVISION_ID   
								 		, A.PROJECT_CODE   
										, A.SCM_SITE_ID   
										, A.PLANT_SITE_ID   
										, A.ITEM_ID    
										, A.INCOTERMS   
										, A.DOM_EXP   
										, A.FCST_TYPE  
										, A.CURRENCY  
										, A.MEASURE  
										, A.YYYYMMDD   
										, A.PRICE
									FROM SCM_MST_FUTURE_PRICE_C A WITH(NOLOCK)    
									LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) 
												ON A.DIVISION_ID = Z.DIVISION_ID  
									WHERE A.YYYYMMDD >= Z.to_yyyymmdd_R 
									AND A.YYYYMMDD <= @v_to_yyyymmdd 
		  							AND A.MEASURE = 'LOC' 
									AND A.VERSION_NO = Z.VERSION_NO    
								) B ON  A.DIVISION_ID = B.DIVISION_ID  
								AND A.PROJECT_CODE = B.PROJECT_CODE  
								AND A.SCM_SITE_ID = B.SCM_SITE_ID  
								AND A.PLANT_SITE_ID = B.PLANT_SITE_ID  
								AND A.ITEM_ID = B.ITEM_ID  
								AND A.INCOTERMS = B.INCOTERMS  
								AND A.DOM_EXP = B.DOM_EXP  
								AND A.FCST_TYPE = B.FCST_TYPE  
								AND A.CURRENCY = B.CURRENCY  
								AND F.BASIS_START_DATE = B.YYYYMMDD  
				WHERE A.YYYYMMDD >= Z.to_yyyymmdd_R 
				AND A.YYYYMMDD <= @v_to_yyyymmdd
				AND A.MEASURE = 'Catch_Up'
				AND A.QTY  <> 0
				AND ISNULL(B.PRICE,0)  <> 0
				AND A.VERSION_NO = Z.VERSION_NO
				--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 end
				UNION ALL			
				SELECT LEFT(A.CUTOFF_YYYYMMDD,6) AS CUTOFF_YYYYMM         /* 컷오프년월 */
						, Z.VERSION_NO_T + ISNULL(Y.VERSION_SEQ,'01') AS VERSION_NO          /* 버전번호 */ 
						--[E20240703-001284]_이동계획 BPS I/F 관련 개선요청 (CUTOFF 주차 오매핑으로 수정)
						--, F.ISO_WEEK AS CUTOFF_ISO_WEEK     /* 컷오프ISO주차 */
						, Z.ISO_WEEK AS CUTOFF_ISO_WEEK     /* 컷오프ISO주차 */
						, A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD     /* 컷오프년월일 */
						, A.DIVISION_ID   
					--[PJ2024-50461] Sales Site Project Model 의 부서 정보
					--, CASE WHEN A.DIVISION_ID = '40' THEN SU.DEPT_ID ELSE C.DEPT_ID END AS DEPT_ID       /* 부서ID */
					,SU.DEPT_ID
					--[PJ2024-50461] Sales Site Project Model 의 부서 정보
						, A.SCM_SITE_ID    
						, A.FCST_TYPE              /* 예측유형 */
						, A.COMPANY_ID             /* 회사ID */
						, D.SALES_PLANT              /* SalesPlant */
						, C.SOLDTO_CODE            /* Soldto Code */
						, C.SHIPTO_CODE            /* Shipto Code */
						--, C.END_CUSTOMER           /* End Customer */				--[PJ2025-50188] 칼럼 위치 잘못되어 재조정함. (중복되어 있어 칼럼 제거함)
					, A.INCOTERMS             /* Incoterms */ 
					--[PJ2024-50611] 소형 이동계획 확산 start
					--, C.END_CUSTOMER           /* End Customer */ 
					--, A.PROJECT_CODE          /* 프로젝트코드 */ 
					--소형일 경우 PROJECT_CODE로 비교. 나머지는 END_CUSTOMER로 비교
					, CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE C.END_CUSTOMER END   AS END_CUSTOMER        /* End Customer */  
					--소형일 경우 공백 비교. 나머지는 PROJECT_CODE로 비교
					, CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE A.PROJECT_CODE  END AS  PROJECT_CODE       /* 프로젝트코드 */  
					--[PJ2024-50611] 소형 이동계획 확산 end
					, A.PLANT_SITE_ID												--[PJ2025-50188] 칼럼 위치 잘못되어 재조정함. (누락되어 칼럼 추가)
						, A.ITEM_ID               /* 아이템ID */
					--[PJ2024-50611] 소형일 경우 공백. 나머지는 BIZ_TYPE로 분기
					--, G.BIZ_TYPE AS BIZ_TYPE  /* 사업유형 */
					, CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE G.BIZ_TYPE END AS BIZ_TYPE  /* 사업유형 */
					--[PJ2024-50611] 소형일 경우 공백. 나머지는 BIZ_TYPE로 분기
						, A.CURRENCY              /* 통화코드 */ 
						, LEFT(A.YYYYMMDD,6) AS PLAN_YYYYMM                    /* 계획년월 */ 
					-- , ROUND(CASE WHEN ISNULL(B.PRICE,0) <> 0 THEN A.QTY/B.PRICE ELSE 0 END,9) AS SALES_QTY     /* 매출수량 */    
						, A.QTY AS SALES_QTY    /* 매출수량 */
						, H.ITEM_UOM              /* Item UOM */
						, ISNULL(B.PRICE,0) AS SALES_PRICE    /* Sales Price(LOC) */ 
						, ISNULL(D.CELL_PER_MODULE,0) AS  CELL_PER_MODULE               /* Cell/Module */
						, CASE WHEN ISNULL(D.CELL_PER_MODULE,0)  <> 0 THEN ISNULL(D.CELL_PER_CAR,0) / ISNULL(D.CELL_PER_MODULE,0) ELSE 0 END AS MODULE_PER_CAR            /* Module/Car */
						, ISNULL(D.ATTRIBUTE8,0) AS KWH_PER_CELL                    /* KWh/Cell */
						, ISNULL(D.CELL_PER_CAR,0) AS CELL_PER_CAR             /* Cell/Car */
						, H.ENERGE               /* ENERGY */ 	   
						-------------------------------------------------------------------------------------------
						-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DM_PLN_SALES_PLAN_RESULT_C에 CELL_PROD_SITE_ID가 추가됨에 따라 FROM_SITE를 CELL_PROD_SITE_ID 와 연계하여 생성하는 로직으로 변경)
						-- [PJ2025-50188] RESULT의 ATTRIBUTE2는 CELL_PROD_SITE_ID와 관계없는 데이터이므로 CELL_PROD_SITE_ID 만으로 조정함. 
						--, '-' AS FROM_SITE_ID	
						--, CASE WHEN (A.DIVISION_ID = '40' AND ISNULL(A.CELL_PROD_SITE_ID, '-') = '-') THEN ISNULL(A.ATTRIBUTE2, '-') ELSE ISNULL(A.CELL_PROD_SITE_ID, '-') END AS FROM_SITE_ID	
						, ISNULL(A.CELL_PROD_SITE_ID, '-')	AS FROM_SITE_ID		-- 40사업부는 CELL_PROD_SITE_ID가 존재함. 그외 사업부는 모두 '-'임
						-------------------------------------------------------------------------------------------
						, 0 AS CATCHUP_QTY--[PJ2024-50611] 소형사업부 Sales Plan Catch Up I/F 추가 
						, A.MEASURE--[PJ2024-50611]소형사업부 Sales Plan Catch Up :  밖에서 MEASURE로 구분하기 위해 추가
				FROM DM_PLN_SALES_PLAN_RESULT_C A WITH(NOLOCK)   
				LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) 
								ON A.DIVISION_ID = Z.DIVISION_ID     
				LEFT OUTER JOIN #TEMP_VERSION_SEQ Y WITH(NOLOCK) 
								ON A.DIVISION_ID = Y.DIVISION_ID      
				LEFT OUTER JOIN #TEMP_SCM_MST_SITE C WITH(NOLOCK) 
								ON A.DIVISION_ID = C.DIVISION_ID 
							AND A.SCM_SITE_ID = C.SCM_SITE_ID 
							AND C.VALID_YN = 'Y'   
				LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK) 
								ON A.DIVISION_ID = D.DIVISION_ID 
								AND A.PROJECT_CODE = D.PROJECT_CODE 
								AND A.SCM_SITE_ID = D.SCM_SITE_ID 
								AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'  
				LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) 
								ON SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))  
				LEFT OUTER JOIN SCM_MST_PROJECT G WITH(NOLOCK) 
								ON A.DIVISION_ID = G.DIVISION_ID 
							AND A.PROJECT_CODE = G.PROJECT_CODE  
				LEFT OUTER JOIN ( SELECT T1.DIVISION_ID
								  		, T1.ITEM_ID  
										, MAX(T1.ITEM_UOM)		AS ITEM_UOM
										, MAX(T1.ENERGE)  	    AS ENERGE		 
									FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)	
									GROUP BY T1.DIVISION_ID, T1.ITEM_ID ) H
								ON A.DIVISION_ID = H.DIVISION_ID 
							AND A.ITEM_ID = H.ITEM_ID 
				LEFT OUTER JOIN SCM_SYS_CALENDAR_M F WITH (NOLOCK) 
							    ON A.YYYYMMDD = F.BASIS_YYYYMMDD    
				LEFT OUTER JOIN (
				----------------------------------------------------------------------
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 START (SCM_MST_FUTURE_PRICE_C는 과거 실적이 없음. ==> RESULT에서 SALESAMT_LOC / RTF_SYS_RP 처리함으로 변경)
				/*
									SELECT A.DIVISION_ID   
								 		, A.PROJECT_CODE   
										, A.SCM_SITE_ID   
										, A.PLANT_SITE_ID   
										, A.ITEM_ID    
										, A.INCOTERMS   
										, A.DOM_EXP   
										, A.FCST_TYPE  
										, A.CURRENCY  
										, A.MEASURE  
										, A.YYYYMMDD   
										, A.PRICE
									FROM [SCM_MST_FUTURE_PRICE_C] AS A WITH(NOLOCK)  
		          					LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) 
													ON A.DIVISION_ID = Z.DIVISION_ID   
									WHERE A.YYYYMMDD >= @v_from_yyyymmdd 
									AND A.YYYYMMDD < Z.to_yyyymmdd_R
		  							AND A.MEASURE = 'LOC' 
									AND A.VERSION_NO = Z.VERSION_NO 
					*/
									SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
										 , A.CURRENCY, A.YYYYMMDD, A.CELL_PROD_SITE_ID
										 , (A.SUM_QTY / B.SUM_QTY)	AS PRICE		 
									FROM 
									(
										SELECT A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
											 , CURRENCY, YYYYMMDD, CELL_PROD_SITE_ID  
											 , SUM(QTY)		AS SUM_QTY
										FROM [DM_PLN_SALES_PLAN_RESULT_C] AS A WITH(NOLOCK)  
		          						LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) ON A.DIVISION_ID = Z.DIVISION_ID  
										WHERE 1=1
										AND A.VERSION_NO = Z.VERSION_NO 
										AND A.YYYYMMDD >= @v_from_yyyymmdd 
										AND A.MEASURE IN ('SALESAMT_LOC')
										GROUP BY  A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
											 , CURRENCY, YYYYMMDD, CELL_PROD_SITE_ID   
									) A 
									INNER JOIN 
									(
										SELECT A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
											 , CURRENCY, YYYYMMDD, CELL_PROD_SITE_ID   
											 , SUM(QTY)		AS SUM_QTY
										FROM [DM_PLN_SALES_PLAN_RESULT_C] AS A WITH(NOLOCK)  
		          						LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) ON A.DIVISION_ID = Z.DIVISION_ID  
										WHERE 1=1
										AND A.VERSION_NO = Z.VERSION_NO 
										AND A.YYYYMMDD >= @v_from_yyyymmdd 
										AND A.MEASURE IN ('RTF_SYS_RP')
										GROUP BY  A.DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
											 , CURRENCY, YYYYMMDD, CELL_PROD_SITE_ID   
									) B
									ON	A.DIVISION_ID	= B.DIVISION_ID
									AND	A.PROJECT_CODE	= B.PROJECT_CODE
									AND	A.SCM_SITE_ID	= B.SCM_SITE_ID
									AND	A.PLANT_SITE_ID	= B.PLANT_SITE_ID
									AND	A.ITEM_ID		= B.ITEM_ID
									AND	A.INCOTERMS		= B.INCOTERMS
									AND	A.DOM_EXP		= B.DOM_EXP
									AND	A.FCST_TYPE		= B.FCST_TYPE
									AND	A.CURRENCY		= B.CURRENCY
									AND	A.YYYYMMDD		= B.YYYYMMDD
									AND	A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID
									WHERE B.SUM_QTY != 0
				-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 END
							) B 
							ON A.DIVISION_ID = B.DIVISION_ID  
							AND A.PROJECT_CODE = B.PROJECT_CODE  
							AND A.SCM_SITE_ID = B.SCM_SITE_ID  
							AND A.PLANT_SITE_ID = B.PLANT_SITE_ID  
							AND A.ITEM_ID = B.ITEM_ID  
							AND A.INCOTERMS = B.INCOTERMS  
							AND A.DOM_EXP = B.DOM_EXP  
							AND A.FCST_TYPE = B.FCST_TYPE  
							AND A.CURRENCY = B.CURRENCY  
							--AND F.BASIS_START_DATE = B.YYYYMMDD 
							AND A.YYYYMMDD = B.YYYYMMDD								-- [PJ2025-50188] FUTURE_PRICE 가 아닌 RESULT로 역산해서 만드므로 원 YYYYMMDD 필요
							AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID			-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
				WHERE A.YYYYMMDD >= @v_from_yyyymmdd 
				AND A.YYYYMMDD < @v_to_yyyymmdd -- [PJ2024-50611] 실적구간에 Cutoff 월요일 날짜 적용, 선언되지 않는 변수 @v_to_yyyymmdd_R 삭제
				AND A.MEASURE = 'RTF_SYS_RP'  
				AND A.QTY <> 0   
				AND ISNULL(B.PRICE,0) <> 0
				AND A.VERSION_NO = Z.VERSION_NO 
				) T1     
				LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO T2 WITH(NOLOCK) 
								ON T1.DEPT_ID = T2.DEPT_ID
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T3 WITH(NOLOCK) 
								ON T1.FCST_TYPE = T3.SEGMENT1
							AND T3.LOOKUP_TYPE = 'SALES_TYPE_CODE'
							AND T3.VALID_YN = 'Y'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T4 WITH(NOLOCK) 
								ON T1.BIZ_TYPE = T4.SEGMENT1
							AND T4.LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
							AND T4.VALID_YN = 'Y'

				-- [PJ2024-50611]RTF_SYS_RP 일 경우에만 적용 되게 수정 START
				--WHERE CAST(STR(T1.SALES_QTY, 20, 5 ) AS NUMERIC(30,10)) <> 0   --0인것 제외로직임,반올림현상으로 0이 아닌데 0으로 나옴
				WHERE CASE WHEN T1.MEASURE = 'RTF_SYS_RP' THEN CAST(STR(T1.SALES_QTY, 20, 5 ) AS NUMERIC(30,10)) ELSE 1 END <> 0
				-- [PJ2024-50611]RTF_SYS_RP 일 경우에만 적용 되게 수정 END


				GROUP BY T1.CUTOFF_YYYYMM         
						, T1.VERSION_NO           
						, T1.CUTOFF_ISO_WEEK      
						, T1.CUTOFF_YYYYMMDD     /* 컷오프년월일 */
						, T1.DIVISION_ID    
						, T1.DEPT_ID
						, T2.DEPT_NAME_KO  /* 부서ID */
						, T1.SCM_SITE_ID    
						, T1.FCST_TYPE
						, T3.SEGMENT2              /* 예측유형 */
						, T1.COMPANY_ID             /* 회사ID */
						, T1.SALES_PLANT             /* SalesPlant */
						, T1.SOLDTO_CODE            /* Soldto Code */
						, T1.SHIPTO_CODE            /* Shipto Code */
						, T1.END_CUSTOMER           /* End Customer */ 
						, T1.INCOTERMS             /* Incoterms */ 
						, T1.PROJECT_CODE          /* 프로젝트코드 */ 
						, T1.PLANT_SITE_ID         /* 플랜트사이트ID */  
						, T1.ITEM_ID               /* 아이템ID */
						, T1.BIZ_TYPE
						, T4.SEGMENT2              /* 사업유형 */
						, T1.CURRENCY              /* 통화코드 */ 
						, T1.PLAN_YYYYMM                    /* 계획년월 */  
						, T1.ITEM_UOM              /* Item UOM */  
						, T1.CELL_PER_MODULE               /* Cell/Module */
						, T1.MODULE_PER_CAR            /* Module/Car */
						, T1.KWH_PER_CELL                    /* KWh/Cell */
						, T1.CELL_PER_CAR            /* Cell/Car */
						, T1.ENERGE
						, T1.FROM_SITE_ID
				ORDER BY T1.DIVISION_ID,T1.DEPT_ID,T1.SCM_SITE_ID,T1.PROJECT_CODE ,T1.ITEM_ID		



PRINT ( 'A4-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121)) 


  
		COMMIT;

		END TRY

	BEGIN CATCH
		ROLLBACK TRAN PR_DM_BPS_SALES_PLAN_S;		

		-- ERROR LOG
		 
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
			,@v_log_type
			,@n_log_count
			,@v_log_message
			,@v_description
			,@d_event_date;			 
			 
	END CATCH;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'PR_DM_BATCH_IF:' + @p_division_id + '/' + @p_cut_off_version ;
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;	 

END;
