
/*=====================================================================================================================================================
 * Program ID	:	PR_DM_BPS_SALES_ETC_PLAN_S
 * Description	:	이동계획 IF_기타매출 
 * 테이블 
   XIF_BPS_SALES_ETC_PLAN_S -->  XIF_BPS_SALES_ETC_PLAN_S_SN
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge		Description
 *=====================================================================================================================================================
 * 2024.05.30	kcw3408			이동계획 IF_기타매출 배치작업 신규   
 * 2024.08.23	JSSBAE			SM작업:SCM_SITE_ID가 존재하지 않는 데이터 나오지 않도록 + COMPANY_ID는 C100으로 고정요청 오윤종PI
 * 2024.09.13	KJJ				[PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 * 2024.10.11	P.C.I			[PJ20228272] NERP 하드코딩 대응
 * 2024.10.24	KJJ				[PJ2024-50611] 소형 이동계획 확산
 * 2024.12.19	KJJ				[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.08.27	JSSBAE			[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 -- EXEC PR_DM_BPS_SALES_ETC_PLAN_S N'ALL',N'ALL'
 -- EXEC PR_DM_BPS_SALES_ETC_PLAN_S N'82',N'SP_W_20240530_V002' 
 ====================================================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_BPS_SALES_ETC_PLAN_S]    
	  @p_division_id				NVARCHAR(30)  -- DIVISION_ID
	, @p_cut_off_version			NVARCHAR(50)  -- Version
AS 
 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON; 
	
	BEGIN TRAN PR_DM_BPS_SALES_ETC_PLAN_S;

	BEGIN TRY	
		--================================================================================================================================================
		-- LOG 용 변수 설정  (START)
		--================================================================================================================================================
		DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_DM_BPS_SALES_ETC_PLAN_S';
		DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
		DECLARE @N_LOG_COUNT		INTEGER = 0;
		DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
		DECLARE @V_DESCRIPTION		NVARCHAR(500);
		DECLARE @D_EVENT_DATE		DATETIME;
		DECLARE @N_DELETE_COUNT		INTEGER = 0;
		DECLARE @N_INSERT_COUNT     INTEGER = 0;
		DECLARE @V_CREATED_BY		NVARCHAR(150)	= 'SYS_BATCH_DATA'; 
		DECLARE @v_CNT				INTEGER = 0;  

		DECLARE @v_yyyymmdd			NVARCHAR(08);
		DECLARE @v_from_yyyymmdd	NVARCHAR(08);
		DECLARE @v_to_yyyymmdd		NVARCHAR(08);
    	DECLARE @v_from_yyyymmdd_R	NVARCHAR(08);
	    DECLARE @v_to_yyyymmdd_R	NVARCHAR(08);	
	    DECLARE @v_VERSION_NO		NVARCHAR(50);	
		--================================================================================================================================================
		-- LOG 용 변수 설정  (END)
		--================================================================================================================================================
		 
		--================================================================================================================================================
		-- 시작 LOG	(START)
		--================================================================================================================================================
		SET @V_LOG_TYPE		= 'START';
		SET @V_LOG_MESSAGE	= '########## START OF PROCEDURE ##########';
		SET @V_DESCRIPTION	= 'PR_DM_BATCH_IF_GITA:';
		SET @D_EVENT_DATE	= SYSDATETIME();
		EXEC  PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;

		--================================================================================================================================================
		-- 시작 LOG	(END)
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
				DROP TABLE #TEMP_VERSION_SEQ ;   			  
			--================================================================================================================================================
			-- Temp Table 존재 여부 체크 (END)
			--================================================================================================================================================
			IF @p_division_id = 'ALL' OR @p_cut_off_version = 'ALL'
				BEGIN		
					SET @v_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112) 
				END
			ELSE 
				BEGIN		
					SET @v_yyyymmdd = SUBSTRING(@p_cut_off_version, 6, 8)
				END   		  
			  
			--================================================================================================================================================
			-- 기간 설정
			-- 실적:해당월1일 부터 CUTOFF 해당주 월요일 전일 
			-- 계획:CUTOFF 해당주 월요일부터 52주차 까지 
			--================================================================================================================================================
PRINT @V_PROGRAM_NAME +' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121);		
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

PRINT @V_PROGRAM_NAME +' : A003--' + ' / Plan_Week: '+ @v_plan_week  + ' / '+  CONVERT(VARCHAR(30), GETDATE(), 121);		
			--------------------------------------------------------------------------------------------------------------------------------------------------
			-- [E20250825-000297]_BPS 전송 주차를 유동적으로 변경하기위하여 룩업을 사용하여 사업부별로 조정할수있도록 수정 (END)
			--------------------------------------------------------------------------------------------------------------------------------------------------

			SET @v_from_yyyymmdd = CONVERT(VARCHAR, CONVERT(CHAR(6), @v_yyyymmdd,  112) + '01', 112)  
			--------------------------------------------------------------------------------------------------------------------------------------------------
			-- [E20250825-000297]_BPS 전송 주차 룩업의 변수로 받아서 처리 하는 부분으로 변경 과거 소스 주석처리  (START)
	    	--SET @v_to_yyyymmdd	= CONVERT(CHAR(8), DATEADD(DD, - 1, DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( @v_yyyymmdd, 'MON')), 112) )),  112)  
	    	SET @v_to_yyyymmdd	= CONVERT(CHAR(8), DATEADD(DD, - 1, DATEADD(WW,  CONVERT(INT, @v_plan_week), CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( @v_yyyymmdd, 'MON')), 112) )),  112)  
			-- [E20250825-000297]_BPS 전송 주차 룩업의 변수로 받아서 처리 하는 부분으로 변경 과거 소스 주석처리  (END)
			--------------------------------------------------------------------------------------------------------------------------------------------------			
            
PRINT @V_PROGRAM_NAME +' : A004--' + ' / from_yyyymmdd: '+ @v_from_yyyymmdd + ' / to_yyyymmdd: '+ @v_to_yyyymmdd + ' / '+ CONVERT(VARCHAR(30), GETDATE(), 121);		
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
PRINT @V_PROGRAM_NAME +' : A005--' + CONVERT(VARCHAR(30), GETDATE(), 121);		
			--================================================================================================================================================
			--  이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상 TEMP 테이블 데이터 INSERT (START)
			--================================================================================================================================================

            SELECT A.DIVISION_ID, A.VERSION_NO, A.MONTHLY_ROLLING_FCST, A.VERSION_NO_T, A.ISO_WEEK, SUBSTRING(A.YYYYMMDD, 1, 6) AS CUTOFF_YYYYMM 
			     , CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(A.YYYYMMDD, 'MON')), 112) AS to_yyyymmdd_R
			  INTO #TEMP_VERSION_NO
			  FROM ( SELECT ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID,A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
						  , A.DIVISION_ID, A.VERSION_NO, A.VERSION_TYPE, B.VERSION_NO_T, B.ISO_WEEK, A.YYYYMMDD, ISNULL(A.ATTRIBUTE7, 'N') AS MONTHLY_ROLLING_FCST  
					   FROM DM_MST_VERSION A WITH (NOLOCK) 
					      , #TEMP_SCM_SYS_CALENDAR_M B
					  WHERE 1 = 1
					  --AND A.DIVISION_ID NOT IN ('40')--[PJ2024-50611] 40번 사업부도 사용 가능하게 제약조건 주석처리
						AND A.VERSION_TYPE = 'SP_W' 
						AND A.DIVISION_ID  = CASE WHEN @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL' THEN A.DIVISION_ID ELSE @p_division_id END
						AND A.VERSION_NO = CASE WHEN @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL' THEN A.VERSION_NO ELSE @p_cut_off_version END
						AND ISNULL(A.ATTRIBUTE7, 'N') = 'Y'
						AND A.YYYYMMDD BETWEEN B.BASIS_YYYYMMDD_WK_FROM AND B.BASIS_YYYYMMDD_WK_TO ) A
			  WHERE A.RNK = 1    	
			--================================================================================================================================================
			--  이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상 TEMP 테이블 데이터 INSERT (END)
			--================================================================================================================================================	
PRINT @V_PROGRAM_NAME +' : A006--' + CONVERT(VARCHAR(30), GETDATE(), 121);				
			--================================================================================================================================================
			--  최종버젼을 가져온다 (START)
			--================================================================================================================================================
            SELECT A.DIVISION_ID, REPLICATE('0', 2 - LEN(CAST(A.VERSION_SEQ AS NVARCHAR(10)))) + CAST(A.VERSION_SEQ AS NVARCHAR(10))  AS VERSION_SEQ
			  INTO #TEMP_VERSION_SEQ
              FROM ( SELECT A.DIVISION_ID, SUBSTRING(MAX(A.VERSION_NO), 19, 2) + 1 AS VERSION_SEQ
					   FROM XIF_BPS_SALES_ETC_PLAN_S_SN A WITH(NOLOCK)
					      , #TEMP_VERSION_NO Z WITH(NOLOCK) 
					  WHERE 1 = 1
					    AND A.DIVISION_ID = Z.DIVISION_ID   
					    AND A.VERSION_NO  LIKE VERSION_NO_T + '%' 
                      GROUP BY A.DIVISION_ID ) A 
			--================================================================================================================================================
			--  최종버젼을 가져온다 (END)
			--================================================================================================================================================
		   
		END
		 
    PRINT ( 'A2-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
	    /* 
		BEGIN	
	       IF OBJECT_ID (N'tempdb..#TEMP_DATA', N'U') IS NOT NULL 
		      DROP TABLE #TEMP_DATA

           CREATE TABLE #TEMP_DATA  (
             GUID                 NVARCHAR(40) NULL
			,IFDATE               NVARCHAR(08) NULL 
 			,IFTIME               NVARCHAR(06) NULL             /* 전송 시간 */ 
 			,IFUSER               NVARCHAR(30) NULL             /* 전송 유저 */
 			,IFSERVICE            NVARCHAR(15) NULL             /* 서비스 인터페이스명 */
 			,CUTOFF_YYYYMM        NVARCHAR(06) NULL             /* 컷오프년월 */
 			,VERSION_NO           NVARCHAR(20) NULL             /* 버전번호 */
			,CUTOFF_ISO_WEEK      NVARCHAR(02) NULL             /* 컷오프ISO주차 */
			,CUTOFF_YYYYMMDD      NVARCHAR(08) NULL             /* 컷오프년월일 */
			,DIVISION_ID          NVARCHAR(10) NULL             /* 사업부ID */
			,DEPT_ID              NVARCHAR(150) NULL             /* 부서ID */
			,SCM_SITE_ID          NVARCHAR(40) NULL             /* SCM사이트ID */ 
			,COMPANY_ID           NVARCHAR(30) NULL             /* 회사ID */
			,SOLDTO_CODE          NVARCHAR(10) NULL             /* Soldto Code */
			,SHIPTO_CODE          NVARCHAR(10) NULL             /* Shipto Code */
			,END_CUSTOMER         NVARCHAR(50) NULL             /* End Customer */ 
			,PROJECT_CODE         NVARCHAR(50) NULL             /* 프로젝트코드 */ 
			,ITEM_ID              NVARCHAR(50) NULL             /* 아이템ID */
			,REMARK_TEXT          NVARCHAR(500) NULL             /* 기타매출Remark(ATTRIBUTE9) */
			,CURRENCY             NVARCHAR(10) NULL             /* 통화코드 */
			,SALES_AMOUNT         NUMERIC(30,10)  NULL           /* 기타매출금액 */
			,LAST_UPDATE_DATE     DATE          NULL              /* 최종수정일자 */ 
			,ATTRIBUTE1           NVARCHAR(150) NULL            
			,ATTRIBUTE2           NVARCHAR(150) NULL            
			,ATTRIBUTE3           NVARCHAR(150) NULL            
			,ATTRIBUTE4           NVARCHAR(150) NULL            
			,ATTRIBUTE5           NVARCHAR(150) NULL            
			,ATTRIBUTE6           NVARCHAR(150) NULL            
			,ATTRIBUTE7           NVARCHAR(150) NULL            
			,ATTRIBUTE8           NVARCHAR(150) NULL            
			,ATTRIBUTE9           NVARCHAR(150) NULL            
			,ATTRIBUTE10          NVARCHAR(150) NULL            
			,ATTRIBUTE11          NVARCHAR(150) NULL            
			,ATTRIBUTE12          NVARCHAR(150) NULL            
			,ATTRIBUTE13          NVARCHAR(150) NULL            
			,ATTRIBUTE14          NVARCHAR(150) NULL            
			,ATTRIBUTE15          NVARCHAR(150) NULL            
			,ATTRIBUTE16          NVARCHAR(150) NULL            
			,ATTRIBUTE17          NVARCHAR(150) NULL            
			,ATTRIBUTE18          NVARCHAR(150) NULL            
			,ATTRIBUTE19          NVARCHAR(150) NULL            
			,ATTRIBUTE20          NVARCHAR(150) NULL            
			,CREATION_DATE        DATE          NULL           
			,TRANSFER_DATE        DATE          NULL               
			,TRANSFER_FLAG        NVARCHAR(1) NULL            
			,ETL_LOAD_DATE        DATE          NULL                /* etl적재일자 */
			,VALUE_TBL_INFO       NVARCHAR(4000) NULL                /* 값테이블정보 */
			,SRC_SYS_CD           NVARCHAR(30) NULL                  /* 소스시스템코드 */
                       )
		END
	*/		   
   
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
		  FROM SCM_MST_SITE  B WITH(NOLOCK)  
		  LEFT OUTER JOIN 
			   SCM_MST_SITE_CUSTOMER  K WITH(NOLOCK)
			   ON B.DIVISION_ID = K.DIVISION_ID 
			  AND B.SCM_SITE_ID = K.SCM_SITE_ID 
			  --AND K.VALID_YN = 'Y'   
			  AND K.REP_YN = 'Y'  	
		  LEFT OUTER JOIN 
			   SCM_MST_CITY    H WITH(NOLOCK)
			   ON B.CITY = H.CITY     
		  LEFT OUTER JOIN 
			   SCM_MST_COUNTRY    J WITH(NOLOCK) 
			   ON B.COUNTRY = J.COUNTRY      
		  LEFT OUTER JOIN 
			   SCM_MST_CUSTOMER   L WITH(NOLOCK)
		   ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE
   END 
		 
    PRINT ( 'A3-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
   BEGIN    
    INSERT INTO XIF_BPS_SALES_ETC_PLAN_S_SN(IFDATE  ,IFTIME  ,IFUSER  ,IFSERVICE ,CUTOFF_YYYYMM  ,VERSION_NO ,CUTOFF_ISO_WEEK ,CUTOFF_YYYYMMDD  
	             ,DIVISION_ID ,DEPT_ID,DEPT_NAME ,SCM_SITE_ID ,COMPANY_ID ,SOLDTO_CODE ,SHIPTO_CODE ,END_CUSTOMER  ,PROJECT_CODE  
				 ,ITEM_ID ,REMARK_TEXT ,CURRENCY,PLAN_YYYYMM ,SALES_AMOUNT 
				 ,CREATION_DATE ,TRANSFER_DATE ,TRANSFER_FLAG  ,ETL_LOAD_DATE  ,VALUE_TBL_INFO  ,SRC_SYS_CD)
				  
    SELECT '' AS IFDATE              
         , '' AS IFTIME					/* 전송 시간 */ 
         , '' AS IFUSER					/* 전송 유저 */
         , '' AS IFSERVICE				/* 서비스 인터페이스명 */
         , T1.CUTOFF_YYYYMM				/* 컷오프년월 */
         , T1.VERSION_NO				/* 버전번호 */
         , T1.CUTOFF_ISO_WEEK			/* 컷오프ISO주차 */
         , T1.CUTOFF_YYYYMMDD			/* 컷오프년월일 */
         , T1.DIVISION_ID   
         , T1.DEPT_ID 
         , T2.DEPT_NAME_KO				/* 부서ID */
         , T1.SCM_SITE_ID    
         --, T1.COMPANY_ID				/* 회사ID */ 
		 --, 'C100'				-- SM 20240822 COMPNY_ID는 C100만 나오도록 요청하여 해당부분 수정
		 , (SELECT TOP 1 CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_BPS_SALES_ETC_PLAN_S', 'COMPANY_ID')) --[PJ20228272] NERP 하드코딩 대응
         , T1.SOLDTO_CODE				/* Soldto Code */
         , T1.SHIPTO_CODE				/* Shipto Code */
         , T1.END_CUSTOMER				/* End Customer */  
         , T1.PROJECT_CODE				/* 프로젝트코드 */  
         , T1.ITEM_ID					/* 아이템ID */
         , T1.REMARK_TEXT				/* 기타매출Remark */
         , T1.CURRENCY					/* 통화코드 */  
         , T1.PLAN_YYYYMM				/* 계획년월 */  
         , CAST(STR(SUM(T1.SALES_AMOUNT), 20, 5 ) AS NUMERIC(30,10))  AS SALES_AMOUNT     /* 매출수량 */  
         , SYSDATETIME() AS CREATION_DATE   
         , SYSDATETIME() AS TRANSFER_DATE           
         , 'N' AS TRANSFER_FLAG    
         , SYSDATETIME() AS ETL_LOAD_DATE              /* etl적재일자 */
         , '' AS VALUE_TBL_INFO                        /* 값테이블정보 */
         , 'SCM' AS SRC_SYS_CD                         /* 소스시스템코드 */ 
	   
    FROM(    SELECT LEFT(A.CUTOFF_YYYYMMDD,6) AS CUTOFF_YYYYMM         /* 컷오프년월 */
				 , Z.VERSION_NO_T + ISNULL(Y.VERSION_SEQ,'01') AS VERSION_NO          /* 버전번호 */ 
				 , F.ISO_WEEK AS CUTOFF_ISO_WEEK     /* 컷오프ISO주차 */
				 , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD     /* 컷오프년월일 */
				 , A.DIVISION_ID   
				 --[PJ2024-50461] 기타매출은 모델이 없으므로 기존의 Site 의 팀으로 조회
				 --, CASE WHEN A.DIVISION_ID = '40' THEN SU.DEPT_ID ELSE C.DEPT_ID END AS DEPT_ID       /* 부서ID */
				 --,SU.DEPT_ID
				 --, CASE WHEN A.FCST_TYPE = 'ETC' THEN C.DEPT_ID ELSE SU.DEPT_ID END AS DEPT_ID       /* 부서ID */
				 --[PJ2024-50461] 한번 더 분기 40 사업부는 기타매출의 부서를 ATTRIBUTE1에서 가져옴
				 ,CASE WHEN A.FCST_TYPE = 'ETC' THEN CASE WHEN A.DIVISION_ID = '40' THEN A.ATTRIBUTE1 ELSE C.DEPT_ID END ELSE SU.DEPT_ID END AS DEPT_ID
				 --[PJ2024-50461] 기타매출은 모델이 없으므로 기존의 Site 의 팀으로 조회
				 , A.SCM_SITE_ID     
				 , D.SALES_COMPANY AS COMPANY_ID             /* 회사ID */
				 , C.SOLDTO_CODE            /* Soldto Code */
				 , C.SHIPTO_CODE            /* Shipto Code */

				 --[PJ2024-50611] 소형 이동계획 확산 start
				 --, C.END_CUSTOMER           /* End Customer */  
				 --, A.PROJECT_CODE          /* 프로젝트코드 */  
				 --소형일 경우 PROJECT_CODE로 비교. 나머지는 END_CUSTOMER로 비교
				 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE C.END_CUSTOMER END   AS END_CUSTOMER        /* End Customer */  
				 --소형일 경우 공백 비교. 나머지는 PROJECT_CODE로 비교
				 , CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE A.PROJECT_CODE  END AS  PROJECT_CODE       /* 프로젝트코드 */  
				 --[PJ2024-50611]  소형 이동계획 확산 end

				 , A.ITEM_ID               /* 아이템ID */
				 --, A.ATTRIBUTE9 AS REMARK_TEXT  /* 기타매출Remark */
				 , A.REMARK_TEXT  /* 기타매출Remark */--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 컬럼변경
				 , LEFT(A.YYYYMMDD,6) AS PLAN_YYYYMM                    /* 계획년월 */  
				 , A.CURRENCY              /* 통화코드 */ 
				 , A.QTY AS SALES_AMOUNT    /* 기타매출금액 */ 
				 , A.LAST_UPDATE_DATE          /* 최종수정일자 */ 
			--FROM [DM_PLN_SALES_PLAN_C] AS A WITH(NOLOCK)
			FROM DM_PLN_SALES_ETC_PLAN_C AS A WITH(NOLOCK)   --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블변경
			LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH(NOLOCK) 
						   ON A.DIVISION_ID = Z.DIVISION_ID     
			LEFT OUTER JOIN #TEMP_VERSION_SEQ Y WITH(NOLOCK) 
						   ON A.DIVISION_ID = Y.DIVISION_ID    
			--SM 20240822 SCM_MST_SITE가 없는 데이터도 나와, SCM_SITE_ID가 정상이 아닌것은 나오지 않도록 수정
			--LEFT OUTER JOIN #TEMP_SCM_MST_SITE C WITH(NOLOCK) 
			INNER JOIN #TEMP_SCM_MST_SITE C WITH(NOLOCK) 
					ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'   
			LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK) 
						   ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'  
			LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SU WITH(NOLOCK) 
						   ON SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))  
			LEFT OUTER JOIN SCM_MST_PROJECT    G WITH(NOLOCK) 
						   ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE   
			LEFT OUTER JOIN SCM_SYS_CALENDAR_M AS F WITH (NOLOCK) 
				  ON A.CUTOFF_YYYYMMDD = F.BASIS_YYYYMMDD    

			WHERE   A.YYYYMMDD >= @v_from_yyyymmdd and A.YYYYMMDD <= @v_to_yyyymmdd 
			  AND A.QTY <> 0   
			  AND A.VERSION_NO = Z.VERSION_NO    
			  AND A.MEASURE = 'SalesAmt_LOC'
			  AND A.FCST_TYPE IN (SELECT DISTINCT SEGMENT2 
					                        FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
					                       WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
										     AND VALID_YN = 'Y'  
											 AND SEGMENT1 = A.DIVISION_ID)
			  AND  A.ITEM_ID IN (SELECT DISTINCT SEGMENT3 
					                        FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
					                       WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'  
										     AND VALID_YN = 'Y'  
											 AND SEGMENT1 = A.DIVISION_ID)  
			  ) T1    
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO  T2 WITH(NOLOCK) 
						   ON T1.DEPT_ID = T2.DEPT_ID
		GROUP BY  
           T1.CUTOFF_YYYYMM         
         , T1.VERSION_NO           
         , T1.CUTOFF_ISO_WEEK      
         , T1.CUTOFF_YYYYMMDD     /* 컷오프년월일 */
         , T1.DIVISION_ID   
         , T1.DEPT_ID 
         , T2.DEPT_NAME_KO        /* 부서ID */
         , T1.SCM_SITE_ID  
         , T1.COMPANY_ID             /* 회사ID */
         , T1.SOLDTO_CODE            /* Soldto Code */
         , T1.SHIPTO_CODE            /* Shipto Code */
         , T1.END_CUSTOMER           /* End Customer */  
         , T1.PROJECT_CODE          /* 프로젝트코드 */  
         , T1.ITEM_ID               /* 아이템ID */
         , T1.REMARK_TEXT   
         , T1.CURRENCY              /* 통화코드 */  
         , T1.PLAN_YYYYMM           /* 계획년월 */  
         , T1.LAST_UPDATE_DATE 
		 
    PRINT ( 'A4-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
	  --SELECT *
	   --FROM XIF_BPS_SALES_ETC_PLAN_S_SN

 END  	 
  
      COMMIT;

    END TRY

	BEGIN CATCH
		ROLLBACK TRAN PR_DM_BPS_SALES_ETC_PLAN_S;		

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
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;
		 

END;

