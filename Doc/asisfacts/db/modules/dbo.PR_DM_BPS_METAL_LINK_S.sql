
/*
 * Program ID  : [PR_DM_BPS_METAL_LINK_S]
 * Description  :  메탈링크 IF 연동

 * 테이블 
   XIF_BPS_METAL_LINK_PRICE_S -->  XIF_BPS_METAL_LINK_PRICE_S_SN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 2024.07.23		KJJ			[PJ2024-50244]SCM DM 고객수요관리 고도화 및 개선 - 신규생성
 2024.09.12		KJJ			[PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 2024.10.24		KJJ			[PJ2024-50611] 소형 이동계획 확산

 EXEC PR_DM_BPS_METAL_LINK_S N'ALL',N'ALL'
 */
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_DM_BPS_METAL_LINK_S]   
	@p_division_id				NVARCHAR(30)  -- DIVISION_ID
   ,@p_cut_off_version          NVARCHAR(50)  -- Version
   
AS 
 
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON; 
	
	BEGIN TRAN PR_DM_BPS_SALES_PLAN_S;

	BEGIN TRY
	 
		-- LOG 용 변수 설정
		DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_DM_BPS_METAL_LINK_S';
		DECLARE @V_LOG_TYPE			NVARCHAR(30); 
		DECLARE @N_LOG_COUNT		INTEGER = 0;
		DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
		DECLARE @V_DESCRIPTION		NVARCHAR(500);
		DECLARE @D_EVENT_DATE		DATETIME;
		DECLARE @N_DELETE_COUNT		INTEGER = 0;
		DECLARE @N_INSERT_COUNT     INTEGER = 0;
		DECLARE @V_CREATED_BY		NVARCHAR(150)	= 'SYS_BATCH_DATA'; 
		 
		-- 시작 LOG
		SET @V_LOG_TYPE = 'START';
		SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
		SET @V_DESCRIPTION = 'PR_DM_BATCH_IF:';
		SET @D_EVENT_DATE = SYSDATETIME();
		EXEC  PR_DM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE, @V_CREATED_BY;
     
		DECLARE @v_yyyymmdd			NVARCHAR(08);

PRINT ( 'A1-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121))  
		
		BEGIN		 
	       IF OBJECT_ID (N'tempdb..#TEMP_VERSION_NO', N'U') IS NOT NULL 
		      DROP TABLE #TEMP_VERSION_NO      
	       IF OBJECT_ID (N'tempdb..#TEMP_SCM_SYS_CALENDAR_M', N'U') IS NOT NULL 
		      DROP TABLE #TEMP_SCM_SYS_CALENDAR_M        
	       IF OBJECT_ID (N'tempdb..#TEMP_VERSION_SEQ', N'U') IS NOT NULL 
		      DROP TABLE #TEMP_VERSION_SEQ    			     
			  
	       IF @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL'
		      BEGIN		
			     SET @v_yyyymmdd =  CONVERT(CHAR(8), GETDATE(),  112) 
		      END
		   ELSE 
		      BEGIN		
			     SET @v_yyyymmdd =  SUBSTRING(@p_cut_off_version,6,8)
		      END   
			 
	       SELECT MIN(B.BASIS_YYYYMMDD) AS BASIS_YYYYMMDD_WK_FROM
			    , MAX(B.BASIS_YYYYMMDD) AS BASIS_YYYYMMDD_WK_TO 
			    , MAX(SUBSTRING(A.CALENDAR_YYYY,3,2) + 'RF_DM_' + A.CALENDAR_YYYY + '_' + A.WEEK_NAME + '_V') AS VERSION_NO_T  
			    , MAX(A.ISO_WEEK) AS ISO_WEEK 
	       INTO #TEMP_SCM_SYS_CALENDAR_M
	       FROM SCM_SYS_CALENDAR_M A
	       INNER JOIN SCM_SYS_CALENDAR_M B
				   ON A.ISO_YYYYWW = B.ISO_YYYYWW 
	       WHERE A.BASIS_YYYYMMDD = CONVERT(CHAR(8), @v_yyyymmdd,  112) 

	       /* 이동계획 수립 주차에는 Version Popup에서 이동계획 여부(Y/N)을 Y인 것이 대상 */
	       SELECT A.DIVISION_ID, A.VERSION_NO, A.MONTHLY_ROLLING_FCST, A.VERSION_NO_T, A.ISO_WEEK
			    , SUBSTRING(A.YYYYMMDD,1,6) AS CUTOFF_YYYYMM, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( A.YYYYMMDD, 'MON')), 112) AS to_yyyymmdd_R
	       INTO #TEMP_VERSION_NO
	       FROM (SELECT ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID,A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
					  , A.DIVISION_ID, A.VERSION_NO, A.VERSION_TYPE, B.VERSION_NO_T, B.ISO_WEEK
					  , A.YYYYMMDD, ISNULL(A.ATTRIBUTE7, 'N') AS MONTHLY_ROLLING_FCST  
				 FROM DM_MST_VERSION A WITH (NOLOCK) 
				    , #TEMP_SCM_SYS_CALENDAR_M B
				 WHERE 1=1
				 --AND A.DIVISION_ID NOT IN ('40')--[PJ2024-50611] 소형 사업부도 허용
				 AND A.VERSION_TYPE	= 'SP_W' 
				 AND A.DIVISION_ID	= CASE WHEN @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL' THEN A.DIVISION_ID ELSE @p_division_id END
				 AND A.VERSION_NO	 = CASE WHEN @p_division_id = 'ALL' OR  @p_cut_off_version = 'ALL' THEN A.VERSION_NO ELSE @p_cut_off_version END
				 AND ISNULL(A.ATTRIBUTE7, 'N') = 'Y'
				 AND A.YYYYMMDD BETWEEN B.BASIS_YYYYMMDD_WK_FROM AND B.BASIS_YYYYMMDD_WK_TO) A
	       WHERE A.RNK = 1    	
			
			/* 최종버젼을 가져온다 */
	       SELECT A.DIVISION_ID, REPLICATE('0', 2 - LEN(CAST(A.VERSION_SEQ AS NVARCHAR(10)))) + CAST(A.VERSION_SEQ AS NVARCHAR(10))  AS VERSION_SEQ
		   INTO #TEMP_VERSION_SEQ
           FROM (SELECT A.DIVISION_ID, SUBSTRING(MAX(A.VERSION_NO),19,2) + 1 AS VERSION_SEQ
				 FROM XIF_BPS_METAL_LINK_PRICE_S_SN AS A WITH(NOLOCK)
				    , #TEMP_VERSION_NO Z WITH(NOLOCK) 
				 WHERE 1=1
				 AND A.DIVISION_ID = Z.DIVISION_ID   
				 AND A.VERSION_NO  LIKE VERSION_NO_T + '%' 
                 GROUP BY A.DIVISION_ID) A 
		END
		  
PRINT ( 'A3-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121))  	

		BEGIN         
			INSERT INTO XIF_BPS_METAL_LINK_PRICE_S_SN 
			( IFDATE
			  ,IFTIME
			  ,IFUSER
			  ,IFSERVICE
			  ,CUTOFF_YYYYMM
			  ,VERSION_NO
			  ,CUTOFF_ISO_WEEK
			  ,CUTOFF_YYYYMMDD
			  ,DIVISION_ID
			  ,DEPT_ID
			  ,DEPT_NAME
			  ,FCST_TYPE
			  ,FCST_TYPE_NAME
			  ,SCM_SITE_ID
			  ,COMPANY_ID
			  ,END_CUSTOMER
			  ,PROJECT_CODE
			  ,PLANT_SITE_ID
			  ,ITEM_ID
			  ,METAL_KIND_CODE
			  ,CURRENCY
			  ,METAL_EXCEPTION_YN
			  ,METAL_LINK_YN
			  ,APPLY_PRICE_TYPE_CODE
			  ,PLAN_YYYYMM
			  ,FROM_PERIOD_YYYYMM
			  ,TO_PERIOD_YYYYMM
			  ,CONTRACT_UNIT_PRICE
			  ,METAL_APPLY_UNIT_PRICE
			  ,METAL_REQR_QTY
			  ,CREATION_DATE
			  ,TRANSFER_DATE
			  ,TRANSFER_FLAG
			  ,ETL_LOAD_DATE
			  ,VALUE_TBL_INFO
			  ,SRC_SYS_CD
			  ,ENERGE )  
			SELECT '' AS IFDATE              
				 , '' AS IFTIME										/* 전송 시간 */ 
				 , '' AS IFUSER										/* 전송 유저 */
				 , '' AS IFSERVICE									/* 서비스 인터페이스명 */
				 , T1.CUTOFF_YYYYMM									/* 컷오프년월 */
				 , T1.VERSION_NO									/* 버전번호 */ 
				 , T1.CUTOFF_ISO_WEEK								/* 컷오프ISO주차 */
				 , T1.CUTOFF_YYYYMMDD								/* 컷오프년월일 */
				 , T1.DIVISION_ID    
				 , T1.DEPT_ID										/* 부서ID */
				 --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
				 --, T2.DEPT_NAME_KO								/* 부서명 */
				 , T1.DEPT_NAME_KO									/* 부서명 */
				 --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
				 , T1.FCST_TYPE										/* 예측유형 */
				 , ISNULL(T3.SEGMENT2,'') AS FCST_TYPE_NAME         /* 예측유형명 */
				 , T1.SCM_SITE_ID    
				 , T1.COMPANY_ID									/* 회사ID */
				 , T1.END_CUSTOMER									/* End Customer */ 
				 , T1.PROJECT_CODE									/* 프로젝트코드 */ 
				 , T1.PLANT_SITE_ID									/* 플랜트사이트ID */ 
				 , T1.ITEM_ID  
				 , T1.METAL_KIND_CODE
				 , T1.CURRENCY
				 , T1.METAL_EXCEPTION_YN
				 ,T1.METAL_LINK_YN
				 ,T1.APPLY_PRICE_TYPE_CODE
				 ,T1.PLAN_YYYYMM
				 ,T1.FROM_PERIOD_YYYYMM
				 ,T1.TO_PERIOD_YYYYMM
				 ,T1.CONTRACT_UNIT_PRICE
				 ,T1.METAL_APPLY_UNIT_PRICE
				 ,T1.METAL_REQR_QTY
				 , SYSDATETIME() AS CREATION_DATE   
				 , SYSDATETIME() AS TRANSFER_DATE           
				 , 'N' AS TRANSFER_FLAG    
				 , SYSDATETIME() AS ETL_LOAD_DATE														/* etl적재일자 */
				 , '' AS VALUE_TBL_INFO																	/* 값테이블정보 */
				 , 'SCM' AS SRC_SYS_CD																	/* 소스시스템코드 */ 	   
				 , CAST(STR(ISNULL(T1.ENERGY,0),20,5) AS NUMERIC(30,10)) AS ENERGY						/* ENERGY */ 
			FROM( SELECT LEFT(A.CUTOFF_YYYYMMDD,6) AS CUTOFF_YYYYMM										/* 컷오프년월 */
					   , Z.VERSION_NO_T + ISNULL(Y.VERSION_SEQ,'01') AS VERSION_NO						/* 버전번호 */ 
					   , F.ISO_WEEK AS CUTOFF_ISO_WEEK													/* 컷오프ISO주차 */
					   , A.CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD											/* 컷오프년월일 */
					   , A.DIVISION_ID   
					   --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
					   --, A.DEPT_ID																	/* 부서ID */
						, TEAM.DEPT_ID																	/* 부서ID */
						, TEAM.DEPT_NAME_KO																/* 부서명 */
					   --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
					   , A.SCM_SITE_ID    
					   , A.FCST_TYPE																	 /* 예측유형 */
						,ISNULL(D.SALES_COMPANY, '') AS COMPANY_ID
						, A.END_CUSTOMER
					   , A.PROJECT_CODE																	 /* 프로젝트코드 */ 
					   , A.PLANT_SITE_ID																 /* 플랜트사이트ID */  
					   , A.ITEM_ID																		 /* 아이템ID */
					   , A.CURRENCY																		 /* 통화코드 */ 
					   , A.PLAN_YYYYMM																	 /* 계획년월 */  
					   , A.METAL_KIND_CODE
						 , A.METAL_EXCEPTION_YN
						 ,A.METAL_LINK_YN
						 ,LUP.SEGMENT4 APPLY_PRICE_TYPE_CODE --company_id는 저정하고 있다가 넘기는게 아니라 I/F시에 조회하여 다시 이름으로 넘김
						 ,A.FROM_PERIOD_YYYYMM
						 ,A.TO_PERIOD_YYYYMM
						 ,A.CONTRACT_UNIT_PRICE
						 ,A.METAL_APPLY_UNIT_PRICE
						 ,A.METAL_REQR_QTY																	/* Item UOM */
					   , A.ENERGY																			/* ENERGY */ 	   
					FROM DM_BPS_METAL_LINK_PRICE_C A WITH (NOLOCK)   
					LEFT OUTER JOIN #TEMP_VERSION_NO Z WITH (NOLOCK) 
								 ON A.DIVISION_ID	= Z.DIVISION_ID      
					LEFT OUTER JOIN #TEMP_VERSION_SEQ Y WITH (NOLOCK) 
								 ON A.DIVISION_ID	= Y.DIVISION_ID    
					INNER JOIN SCM_SYS_CALENDAR_M F WITH (NOLOCK) 
								 ON A.CUTOFF_YYYYMMDD = F.BASIS_YYYYMMDD    
								 AND A.VERSION_NO = Z.VERSION_NO   
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
						ON LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
							AND LUP.SEGMENT1 = SUBSTRING(A.DIVISION_ID, 1,2)
							AND LUP.SEGMENT2 = A.METAL_KIND_CODE
							AND LUP.SEGMENT3 = A.APPLY_PRICE_TYPE_CODE
					LEFT OUTER JOIN SCM_MST_SITE_ITEM D WITH(NOLOCK) 
						ON A.DIVISION_ID = D.DIVISION_ID 

						--[PJ2024-50611]소형일 경우 END_CUSTOMER로 비교. 나머지는 PROJECT_CODE로 비교
						--AND A.PROJECT_CODE = D.PROJECT_CODE 
						AND CASE WHEN A.DIVISION_ID = '40' THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END = D.PROJECT_CODE 
						--[PJ2024-50611]소형일 경우 END_CUSTOMER로 비교. 나머지는 PROJECT_CODE로 비교

						AND A.SCM_SITE_ID = D.SCM_SITE_ID
						AND A.ITEM_ID = D.ITEM_ID 
						AND D.VALID_YN = 'Y'
					--[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 start
					LEFT JOIN (
						SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
						FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
						INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
						ON B.DEPT_ID = C.DEPT_ID
					) AS TEAM
					ON              TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](D.owner, ','))
					--[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 end
				) T1  
			--[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start
			/*LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO T2 WITH(NOLOCK) 
						 ON T1.DEPT_ID		= T2.DEPT_ID	*/
			--[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T3 WITH(NOLOCK) 
						 ON T1.FCST_TYPE	= T3.SEGMENT1
						AND T3.LOOKUP_TYPE	= 'SALES_TYPE_CODE'
						AND T3.VALID_YN		= 'Y'						 
		  
PRINT ( 'A4-- ' + CONVERT(NVARCHAR(30), GETDATE(), 121)) 

 		END  	
		COMMIT;

    END TRY

	BEGIN CATCH
		ROLLBACK TRAN PR_DM_BPS_SALES_PLAN_S;	
		 
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	END CATCH;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END;
