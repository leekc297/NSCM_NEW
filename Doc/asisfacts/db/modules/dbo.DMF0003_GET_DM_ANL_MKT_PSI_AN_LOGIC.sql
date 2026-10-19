
/*
 * Program ID  : [DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC]
 * Author:  <Author,,Name>  
 * Create date: <Create Date,,>  
 * Description  : 고객수요증감분석 Simulation 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.11.03 kcw3408 	[개발요청] 수요분석시스템_35번	Simulation 기능 로직 수정(신규 추가된 '공급차질' 카테고리를 연계하도록) SUPPLY_ISSUE  추가
 2023.11.08 kcw3408 	[개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 2024.01.12 kcw3408 	[오류수정] EDI-고수분 Data 입력 영업 담당자 및 Logic 문의/확인의 件(PERIOD를 변경하고서 ‘실행’버튼을 누르면, 고객수요 값이 모두 잘못된 값으로 계산되어 조회됨)
                        YYYYMM 기준이 불일치(@p_yyyymm_to_simul --> @p_yyyymm 로 변경)
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC '81', 'A15AI7001', 'AUDI 48V', '202211', '202211','202211', '202311',''
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC @p_division_id=N'81',@p_project_code=N'A15BW7001',@p_project_name=N'12V DSS', @p_yyyymm_from=N'202207', @p_yyyymm_to=N'202408',@p_yyyymm_from_simul=N'202301', @p_yyyymm_to_simul=N'202307',@p_created_by=N''  
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC @p_division_id=N'81',@p_project_code=N'A15BW7001',@p_project_name=N'ASVAGCBEV-1',@p_yyyymm_from=N'202211',@p_yyyymm_to=N'202311',@p_yyyymm_from_simul=N'202211',@p_yyyymm_to_simul=N'202310',@p_created_by=N'',@p_end_customer=N'BMW'
 */

CREATE PROCEDURE [dbo].[DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC]  
		@p_division_id			NVARCHAR(30),  
		@p_project_code			NVARCHAR(50),  
		@p_project_name		    NVARCHAR(100),  
		@p_yyyymm_from			NVARCHAR(20),  
		@p_yyyymm_to			NVARCHAR(20),  
		@p_yyyymm_from_simul	NVARCHAR(20),  
		@p_yyyymm_to_simul		NVARCHAR(20),  
		@p_created_by			NVARCHAR(MAX),  
    	@p_end_customer NVARCHAR(50)
AS  


BEGIN  
	SET NOCOUNT ON;

	DECLARE @CNT INT = 0, @i INT =  1  
	DECLARE @v_yyyymm			NVARCHAR(20)  
	DECLARE @p_yyyymm			NVARCHAR(20)  
	DECLARE @v_CUST_FCST_M		NVARCHAR(MAX);  
	DECLARE @v_MKT_FCST_S		NVARCHAR(MAX);	--수요계획(1st)
	DECLARE @v_MKT_FCST_R		NVARCHAR(MAX);	--수요계획(Result)	


	DECLARE @v_DP_RESULT_SUM    NUMERIC(20,10);	
	DECLARE @v_DP_RESULT_P      NUMERIC(20,10);	
	DECLARE @v_DP_RESULT_S      NUMERIC(20,10);	
	DECLARE @v_DP_RESULT_I      NUMERIC(20,10);	
	DECLARE @v_DP_RESULT_V      NUMERIC(20,10);	
	DECLARE @v_DP_RESULT_M      NUMERIC(20,10);	
	DECLARE @v_DP_RESULT_CP     NUMERIC(20,10);	
	DECLARE @v_EDI_SUM          NUMERIC(20,10);	

	DECLARE @v_DP_ANL_SUM       NUMERIC(20,10);	
	DECLARE @v_DP_ANL_P         NUMERIC(20,10);	
	DECLARE @v_DP_ANL_S         NUMERIC(20,10);	
	DECLARE @v_DP_ANL_I         NUMERIC(20,10);	
	DECLARE @v_DP_ANL_V         NUMERIC(20,10);	
	DECLARE @v_DP_ANL_M         NUMERIC(20,10);	
	DECLARE @v_DP_ANL_CP        NUMERIC(20,10);	
	DECLARE @v_LAST_MONTH_EDI   NUMERIC(20,10);	

	
	DECLARE @v_0month_tuesday	NVARCHAR(08);		--당월의 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff	

	DECLARE @v_0month				NVARCHAR(6);		--M0 당월
	DECLARE @v_1month				NVARCHAR(6);		--M-1 전월	 		

	SET @v_0month = CONVERT(CHAR(6), GETDATE(), 112)									--M0 당월
	SET @v_1month = CONVERT(CHAR(6), DATEADD(MONTH, -1, GETDATE()), 112)	--M-1 전월

	
	PRINT N'@v_0month = ' + @v_0month  
	PRINT N'@@v_1month = ' + @v_1month  

	SELECT @i = DATEDIFF(MONTH, SUBSTRING(@p_yyyymm_to, 1, 4) + '-' + SUBSTRING(@p_yyyymm_to, 5, 2)  + '-01', SUBSTRING(@p_yyyymm_from, 1, 4) + '-' + SUBSTRING(@p_yyyymm_from, 5, 2)  + '-01' )
	--SET @i = -12
	--PRINT @i

	PRINT N'@i = ' + CONVERT(NVARCHAR,  @i)  
	PRINT N'@p_yyyymm_to = ' + @p_yyyymm_to
	
	SET @p_yyyymm = @p_yyyymm_to
	-- 테이블중복제거
	IF OBJECT_ID (N'tempdb..#TEMP_DATA', N'U')			IS NOT NULL	DROP TABLE #TEMP_DATA

	-- 임시확인용테이블 중복제거
	IF OBJECT_ID (N'dbo.#TEMP_DATA', N'U')				IS NOT NULL	DROP TABLE #TEMP_DATA

	CREATE TABLE #TEMP_DATA (    
		DIVISION_ID				NVARCHAR(30) NOT NULL,   
		End_Customer            NVARCHAR(50) NOT NULL, 
		PROJECT_NAME            NVARCHAR(100) NOT NULL,
		PROJECT_CODE            NVARCHAR(50) NOT NULL, 
		YYYYMM					NVARCHAR(6)  NOT NULL,    
		EDI_QTY					NVARCHAR(30) NOT NULL,    
		MEASURE					NVARCHAR(30) NOT NULL,    
		[SUM]					NVARCHAR(30) NOT NULL,    
		PRODUCT					NVARCHAR(30) NOT NULL,    
		SALE					NVARCHAR(30) NULL,    
		INVENTORY				NVARCHAR(30) NULL,    
		TIME_ADJUST				NVARCHAR(30) NULL,    
		MODEL_MIX				NVARCHAR(30) NULL,       
		SUPPLY_ISSUE			NVARCHAR(30) NULL,    
		MKT_DP					NVARCHAR(MAX) NULL,  
		RNK						NVARCHAR(MAX) NULL  
		);
	
	-- 테이블중복제거
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_VERSION', N'U')			IS NOT NULL	DROP TABLE #TEMP_DM_MST_VERSION

	-- 임시확인용테이블 중복제거
	IF OBJECT_ID (N'dbo.#TEMP_DM_MST_VERSION', N'U')				IS NOT NULL	DROP TABLE #TEMP_DM_MST_VERSION

	CREATE TABLE #TEMP_DM_MST_VERSION	(
		NUM							INT	NULL,
		VERSION_NO				NVARCHAR(100)	NULL,
		VERSION_TYPE			NVARCHAR(100)	NULL		
		);
			   
	BEGIN

		-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#TMP_PROJECT_CODE', N'U')			IS NOT NULL	DROP TABLE #TMP_PROJECT_CODE

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#TMP_PROJECT_CODE', N'U')				IS NOT NULL	DROP TABLE #TMP_PROJECT_CODE

		SELECT * INTO #TMP_PROJECT_CODE
		FROM (SELECT PROJECT_CODE FROM SCM_MST_PROJECT WHERE DIVISION_ID = @p_division_id AND PROJECT_NAME = @p_project_name) A

	END
	

	BEGIN

		--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
		IF DATEPART(WEEKDAY, SUBSTRING(CONVERT(VARCHAR, GETDATE(), 112), 1, 6) + '01') = '4'
			BEGIN				
				SET @v_0month_tuesday  = CONVERT(CHAR(8), DATEADD(WW, -1, DBO.FN_NEXT_DAY(CONVERT(VARCHAR, SUBSTRING(CONVERT(VARCHAR, GETDATE(), 112), 1, 6) + '01' ,112), 'TUE')), 112)
			END
		ELSE
			BEGIN				
				SET @v_0month_tuesday = CONVERT(NVARCHAR, DATEADD(WK, DATEDIFF(WK, 0, DATEADD(DD, 5-DATEPART(DAY, GETDATE()), GETDATE())), 1), 112)	--당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff				
			END
			
		BEGIN
			INSERT INTO #TEMP_DM_MST_VERSION ( NUM, VERSION_NO, VERSION_TYPE )
			SELECT ROW_NUMBER() OVER (ORDER BY X.VERSION_NO) AS NUM
						, X.VERSION_NO
						, X.VERSION_TYPE
			FROM (
						SELECT ROW_NUMBER() OVER (PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC) AS RNK
									, A.VERSION_NO, A.VERSION_TYPE
						FROM  DM_MST_VERSION A WITH(NOLOCK)
						JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK)
						ON A.YYYYMMDD = B.BASIS_YYYYMMDD
						WHERE 1=1
						AND A.DIVISION_ID = @p_division_id					
						AND A.VERSION_TYPE = 'MF_W'			--MKT_FCST Weekly Cutoff
						AND A.YYYYMMDD = @v_0month_tuesday							
					) X
			WHERE RNK = 1
		END

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------
		

		BEGIN	
	    	-- 테이블중복제거
	       	IF OBJECT_ID(N'tempdb..#TMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL
		    	DROP TABLE #TMP_DM_MST_ITEM_SINGLE_V

		    -- 임시확인용테이블 중복제거
		    IF OBJECT_ID(N'dbo.#TMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL
		    	DROP TABLE #TMP_DM_MST_ITEM_SINGLE_V	

			SELECT * INTO #TMP_DM_MST_ITEM_SINGLE_V FROM DM_MST_ITEM_SINGLE_V WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id 
			AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
			AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y'
			--AND ITEM_ID IN (SELECT ITEM_ID FROM SCM_MST_PROJECT_ITEM WHERE PROJECT_CODE = @p_project_code AND VALID_YN = 'Y') AND ITEM_TYPE = 'P' AND ACTIVE_FLAG = 'Y'
		END
		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')-------------------------------------------------------------------------------------------------

		 

		--SCM_MST_SITE 대상건만 추출
		BEGIN
        	-- 테이블중복제거
        	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U')			IS NOT NULL	DROP TABLE #TEMP_SCM_MST_SITE

        	-- 임시확인용테이블 중복제거
        	IF OBJECT_ID (N'dbo.#TEMP_SCM_MST_SITE', N'U')				IS NOT NULL	DROP TABLE #TEMP_SCM_MST_SITE

			SELECT DIVISION_ID
			     , SCM_SITE_ID
				 , END_CUSTOMER
			INTO #TEMP_SCM_MST_SITE
			FROM SCM_MST_SITE WITH (NOLOCK)
			WHERE DIVISION_ID  = @p_division_id
	          AND END_CUSTOMER = @p_end_customer 
		END 
		 

		BEGIN
        	-- 테이블중복제거
        	IF OBJECT_ID (N'tempdb..#TMP_DM_PLN_MKT_FCST_C', N'U')			IS NOT NULL	DROP TABLE #TMP_DM_PLN_MKT_FCST_C

        	-- 임시확인용테이블 중복제거
        	IF OBJECT_ID (N'dbo.#TMP_DM_PLN_MKT_FCST_C', N'U')				IS NOT NULL	DROP TABLE #TMP_DM_PLN_MKT_FCST_C


			SELECT X.*
			INTO #TMP_DM_PLN_MKT_FCST_C
			FROM DM_PLN_MKT_FCST_C X WITH(NOLOCK)  
			JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK)
			ON X.VERSION_NO = Y.VERSION_NO
		    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
			WHERE 1=1   
			AND X.DIVISION_ID = @p_division_id								
			AND X.MEASURE IN ('MKT_FCST','CUST_FCST_EDI', 'CUST_FCST') 
			AND X.PROJECT_CODE = @p_project_code
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------

			
        	-- 테이블중복제거
        	IF OBJECT_ID (N'tempdb..#TMP_DM_PLN_MKT_FCST_RESULT_C', N'U')			IS NOT NULL	DROP TABLE #TMP_DM_PLN_MKT_FCST_RESULT_C

        	-- 임시확인용테이블 중복제거
        	IF OBJECT_ID (N'dbo.#TMP_DM_PLN_MKT_FCST_RESULT_C', N'U')				IS NOT NULL	DROP TABLE #TMP_DM_PLN_MKT_FCST_RESULT_C

			SELECT X.* 
			INTO #TMP_DM_PLN_MKT_FCST_RESULT_C
			FROM DM_PLN_MKT_FCST_RESULT_C X WITH(NOLOCK) 
			JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK)
			ON X.VERSION_NO = Y.VERSION_NO
		    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
			WHERE 1=1   
			AND X.DIVISION_ID = @p_division_id  
			AND X.MEASURE IN ('MKT_FCST','CUST_FCST_EDI', 'CUST_FCST') 
			AND X.PROJECT_CODE = @p_project_code  
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
			--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------

		END

	END

	--SELECT * FROM #TMP_DM_MST_ITEM_SINGLE_V
  
	WHILE @i <= 0  
	BEGIN  
  
		BEGIN  
			SELECT @CNT = COUNT(*) FROM DM_ANL_MKT_PSI WITH(NOLOCK)  
			WHERE 1=1  
			AND DIVISION_ID = @p_division_id  
			--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE) 
			AND END_CUSTOMER = @p_end_customer
			AND PROJECT_CODE = @p_project_code    
			AND YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)  
		END		
		
		BEGIN			
			IF @v_0month_tuesday <= CONVERT(NVARCHAR, GETDATE(), 112)
				BEGIN
					--고객수요계획
					BEGIN
						IF CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) = @v_0month
							BEGIN
								SELECT @v_CUST_FCST_M = (A_QTY + B_QTY)  
								FROM (  
											SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS A_QTY  
											FROM #TMP_DM_PLN_MKT_FCST_C X WITH(NOLOCK)  
											JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK) ON X.VERSION_NO = Y.VERSION_NO											
											WHERE 1=1   
											AND X.DIVISION_ID = @p_division_id								
											AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')  
											--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
											AND X.PROJECT_CODE = @p_project_code  
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTRING(X.YYYYMMDD, 1, 6) = @p_yyyymm
											AND X.QTY <> 0
											) A,  
											(  
											SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS B_QTY  
											FROM #TMP_DM_PLN_MKT_FCST_RESULT_C X WITH(NOLOCK) 
											JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1   
											AND X.DIVISION_ID = @p_division_id  
											AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')  
											--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
											AND X.PROJECT_CODE = @p_project_code  
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTRING(X.YYYYMMDD, 1, 6) = @p_yyyymm						        
											) B  
							END
						ELSE
							SELECT @v_CUST_FCST_M = 0
					END
					--마케팅수요계획
					BEGIN
						IF CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) = @v_0month
							--수요계획(1st)
							BEGIN
								SELECT @v_MKT_FCST_S = (A_QTY + B_QTY)  
								FROM (  
											SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS A_QTY  
											FROM #TMP_DM_PLN_MKT_FCST_C X WITH(NOLOCK)  
											JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1   
											AND X.DIVISION_ID = @p_division_id 					
											AND X.MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
											AND X.PROJECT_CODE = @p_project_code  
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTRING(X.YYYYMMDD, 1, 6) = @p_yyyymm
											AND X.QTY <> 0
											) A,  
											(  
											SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS B_QTY  
											FROM #TMP_DM_PLN_MKT_FCST_RESULT_C X WITH(NOLOCK) 
											JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1   
											AND X.DIVISION_ID = @p_division_id  
											AND X.MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
											AND X.PROJECT_CODE = @p_project_code  
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTRING(X.YYYYMMDD, 1, 6) = @p_yyyymm
											) B  
							END
						ELSE
							SELECT @v_MKT_FCST_S = 0

						IF CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) = @v_1month
							--수요계획(Result)
							BEGIN
					            /* 2023.11.02	   kcw3408		  전월 실적 구하기 ,기존로직 삭제
								SELECT @v_MKT_FCST_R = (A_QTY + B_QTY)  
								FROM (  
											SELECT ISNULL(CEILING(SUM(QTY)), 0) AS A_QTY  
											FROM #TMP_DM_PLN_MKT_FCST_C X WITH(NOLOCK)  
											JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK)
											ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1   
											AND DIVISION_ID = @p_division_id								
											AND MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
											AND PROJECT_CODE = @p_project_code
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTRING(YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MONTH, -1, @p_yyyymm + '01'), 112)
											AND QTY <> 0
											) A,  
											(  
											SELECT ISNULL(CEILING(SUM(QTY)), 0) AS B_QTY  
											FROM #TMP_DM_PLN_MKT_FCST_RESULT_C X WITH(NOLOCK) 
											JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK)
											ON X.VERSION_NO = Y.VERSION_NO
											WHERE 1=1   
											AND DIVISION_ID = @p_division_id  
											AND MEASURE = 'RTF_SYS_RP'
											--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
											AND PROJECT_CODE = @p_project_code  
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
											AND X.FCST_TYPE = 'MPS'
											--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
											AND SUBSTRING(YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MONTH, -1, @p_yyyymm + '01'), 112)
											) B   
					    */			 
				    		SELECT @v_MKT_FCST_R = A.A_QTY
					          FROM (
								SELECT ISNULL(CEILING(SUM(QTY)), 0) AS A_QTY
								FROM DM_PLN_MKT_FCST_RESULT X WITH (NOLOCK) 			   
		                        JOIN SCM_MST_SITE_ITEM F WITH(NOLOCK) 
				                     ON	F.DIVISION_ID    = X.DIVISION_ID
				                    AND	F.PROJECT_CODE   = X.PROJECT_CODE
			                        AND	F.scm_site_id    = X.scm_site_id
                                    AND	F.ITEM_ID        = X.ITEM_ID			   
			                   JOIN #TEMP_SCM_MST_SITE H WITH(NOLOCK) 
				                    ON	F.DIVISION_ID    = H.DIVISION_ID 
				                   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID 
			                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G WITH(NOLOCK) 
			                        ON	G.SEGMENT1    = X.FCST_TYPE
				                   AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE' 
								WHERE 1 = 1
									AND X.DIVISION_ID = @p_division_id
									AND X.MEASURE = 'RTF_SYS_RP'
									AND X.PROJECT_CODE = @p_project_code 
									AND SUBSTRING(X.YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MONTH, - 1, @p_yyyymm + '01'), 112)
							       ) A
					        END
						ELSE
							SELECT @v_MKT_FCST_R = 0
					END
				END
			ELSE
				SELECT @v_CUST_FCST_M = 0, @v_MKT_FCST_S = 0, @v_MKT_FCST_R = 0
		END

  
		IF (@CNT = 0) 
			IF @v_0month_tuesday <= CONVERT(NVARCHAR, GETDATE(), 112) AND CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) = @v_0month				
				BEGIN  
					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), @v_CUST_FCST_M, N'Average impact(%)', '0%', '0%', '0%', '0%', '0%', '0%', '0%',NULL, '1'  
					END

					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), @v_CUST_FCST_M, N'Simulation (Impact)', 0, 0, 0, 0, 0, 0, 0, 0, '2'  
					END

					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), @v_CUST_FCST_M, N'Demand Plan (1st)', 0, 0, 0, 0, 0, 0, 0, CEILING(@v_MKT_FCST_S), '3'  
					END  

					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), @v_CUST_FCST_M, N'Demand Plan (final)', 0, 0, 0, 0, 0, 0, 0, CEILING(@v_MKT_FCST_R), '4'  
					END  
				END
			ELSE
				BEGIN  
					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, N'Average impact(%)', '0%', '0%', '0%', '0%', '0%', '0%', '0%', NULL, '1'  
					END

					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, N'Simulation (Impact)', 0, 0, 0, 0, 0, 0, 0, 0, '2'  
					END

					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, N'Demand Plan (1st)', 0, 0, 0, 0, 0, 0, 0, CEILING(@v_MKT_FCST_S), '3'  
					END  

					BEGIN  
						INSERT INTO #TEMP_DATA    
						SELECT @p_division_id,@p_end_customer, @p_project_name,@p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, N'Demand Plan (final)', 0, 0, 0, 0, 0, 0, 0, CEILING(@v_MKT_FCST_R), '4'  
					END  
				END
		ELSE  
			BEGIN  
				-- 고객수요증감분석 전체조회  
				INSERT INTO #TEMP_DATA    
				SELECT  T1.DIVISION_ID AS DIVISION_ID  	
				          , @p_end_customer					
						  , @p_project_name 
						  , @p_project_code
						  , T1.YYYYMM AS YYYYMM  
						  , (CASE WHEN ISNULL(T1.CUST_FCST_M, 0) = 0 THEN
											   @v_CUST_FCST_M
									 WHEN @v_0month_tuesday <= CONVERT(NVARCHAR, GETDATE(), 112) AND CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) = @v_0month THEN
											   @v_CUST_FCST_M
									 ELSE CEILING(T1.CUST_FCST_M) END) AS EDI_QTY
						  , (CASE T1.MEASURE WHEN 'AN_LOGIC' THEN N'Average impact(%)'  
													   WHEN 'AN_RESULT' THEN N'Simulation (Impact)'  
													   WHEN 'DP_INIT' THEN N'Demand Plan (1st)'  
													   WHEN 'DP_RESULT' THEN N'Demand Plan (final)' END) AS MEASURE  
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN CONCAT(CONVERT(VARCHAR, (ROUND(CONVERT(FLOAT,T2.VSUM), 2))), '%')  								  
								 	 ELSE FORMAT(CEILING(T2.VSUM), '#,#') END) AS [SUM]  
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN CONCAT(CONVERT(VARCHAR, ROUND(CONVERT(FLOAT,T1.P_VALUE), 2)), '%')  								  
									 ELSE FORMAT(CEILING(T1.P_VALUE), '#,#') END) AS PRODUCT   
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN CONCAT(CONVERT(VARCHAR, (ROUND(CONVERT(FLOAT,T1.S_VALUE), 2))), '%')  								  
									 ELSE FORMAT(CEILING(T1.S_VALUE), '#,#') END) AS SALE   
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN CONCAT(CONVERT(VARCHAR, (ROUND(CONVERT(FLOAT,T1.I_VALUE), 2))), '%')  								  
									 ELSE FORMAT(CEILING(T1.I_VALUE), '#,#') END) AS INVENTORY   
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN CONCAT(CONVERT(VARCHAR, (ROUND(CONVERT(FLOAT,T1.V_VALUE), 2))), '%')  								  
									 ELSE FORMAT(CEILING(T1.V_VALUE), '#,#') END) AS TIME_ADJUST   
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN CONCAT(CONVERT(VARCHAR, (ROUND(CONVERT(FLOAT,T1.M_VALUE), 2))), '%')  								  
									 ELSE FORMAT(CEILING(T1.M_VALUE), '#,#') END) AS MODEL_MIX       
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN CONCAT(CONVERT(VARCHAR, (ROUND(CONVERT(FLOAT,T1.CP_VALUE), 2))), '%')  								  
									 ELSE FORMAT(CEILING(T1.CP_VALUE), '#,#') END) AS SUPPLY_ISSUE      
						  , (CASE WHEN T1.MEASURE = 'AN_RESULT' THEN											  
											  (CASE WHEN ISNULL(T1.MKT_FCST_M, 0) = 0 THEN 0 ELSE CEILING(T1.MKT_FCST_M) END)
									 WHEN T1.MEASURE = 'DP_INIT' THEN 											  
											  (CASE WHEN ISNULL(T1.MKT_FCST_M, 0) = 0 THEN 
																 CEILING(@v_MKT_FCST_S) 
													   WHEN @v_0month_tuesday <= CONVERT(NVARCHAR, GETDATE(), 112) AND CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) = @v_0month THEN
																 CEILING(@v_MKT_FCST_S)																
														ELSE CEILING(T1.MKT_FCST_M) END)
									 WHEN T1.MEASURE = 'DP_RESULT' THEN											  
											  (CASE WHEN ISNULL(T1.MKT_FCST_M, 0) = 0 THEN 
																 CEILING(@v_MKT_FCST_R) 
													   WHEN @v_0month_tuesday <= CONVERT(NVARCHAR, GETDATE(), 112) AND CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) = @v_0month THEN
																 CEILING(@v_MKT_FCST_R) 															    
													   ELSE CEILING(T1.MKT_FCST_M) END)
									 ELSE NULL END)
						  , (CASE WHEN T1.MEASURE = 'AN_LOGIC' THEN '1'  
									 WHEN T1.MEASURE = 'AN_RESULT' THEN '2'  
									 WHEN T1.MEASURE = 'DP_INIT' THEN '3'  
									 ELSE '4' END) RNK  
				FROM DM_ANL_MKT_PSI T1 WITH(NOLOCK)    
				LEFT OUTER JOIN (SELECT PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE, SUM(VVALUE) AS VSUM  
										  FROM DM_ANL_MKT_PSI WITH(NOLOCK)   
				UNPIVOT (VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE)) AS UPV_RST  
				GROUP BY PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE) T2  
				ON T1.PROJECT_CODE = T2.PROJECT_CODE AND T1.END_CUSTOMER = T2.END_CUSTOMER AND T1.YYYYMM = T2.YYYYMM AND T1.MEASURE = T2.MEASURE      
				WHERE 1=1  
				AND T1.DIVISION_ID = @p_division_id  
				AND T1.END_CUSTOMER = @p_end_customer
				AND T1.PROJECT_CODE = @p_project_code   
				AND T1.YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, @i , @p_yyyymm + '01'), 112)  	  --20240112 @p_yyyymm_to_simul --> @p_yyyymm 로 변경
			 


				IF CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) >= CONVERT(CHAR(6), @p_yyyymm_from_simul + '01', 112) 
				AND CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112) <= CONVERT(CHAR(6), @p_yyyymm_to_simul + '01', 112)
				BEGIN
				--SELECT CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)
					--SELECT @v_EDI_SUM
					--SELECT CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)  
					--SELECT CONVERT(CHAR(6), @p_yyyymm_to_simul + '01', 112)
					--SELECT @v_EDI_SUM
					SELECT  
					 @v_EDI_SUM = T1.CUST_FCST_M		+ ISNULL(@v_EDI_SUM, 0)
					 ,@v_DP_RESULT_SUM = T2.VSUM		+ ISNULL(@v_DP_RESULT_SUM, 0)
					,@v_DP_RESULT_P   = T1.P_VALUE	+ ISNULL(@v_DP_RESULT_P, 0)  
					,@v_DP_RESULT_S   = T1.S_VALUE	+ ISNULL(@v_DP_RESULT_S, 0)  
					,@v_DP_RESULT_I   = T1.I_VALUE	+ ISNULL(@v_DP_RESULT_I, 0)  
					,@v_DP_RESULT_V   = T1.V_VALUE	+ ISNULL(@v_DP_RESULT_V, 0)  
					,@v_DP_RESULT_M   = T1.M_VALUE	+ ISNULL(@v_DP_RESULT_M, 0)  
					,@v_DP_RESULT_CP   = ISNULL(T1.CP_VALUE, 0)	+ ISNULL(@v_DP_RESULT_CP, 0)
					FROM DM_ANL_MKT_PSI T1 WITH(NOLOCK)    
					LEFT OUTER JOIN (SELECT PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE, SUM(VVALUE) AS VSUM  
											  FROM DM_ANL_MKT_PSI WITH(NOLOCK)   
					UNPIVOT (VVALUE FOR VLIST IN (P_VALUE, S_VALUE, I_VALUE, V_VALUE, M_VALUE, CP_VALUE)) AS UPV_RST  
					GROUP BY PROJECT_CODE,END_CUSTOMER, YYYYMM, MEASURE) T2  
					ON T1.PROJECT_CODE = T2.PROJECT_CODE AND T1.END_CUSTOMER = T2.END_CUSTOMER AND T1.YYYYMM = T2.YYYYMM AND T1.MEASURE = T2.MEASURE      
					WHERE 1=1  
					AND T1.DIVISION_ID = @p_division_id   
		     		AND T1.END_CUSTOMER = @p_end_customer
					AND T1.PROJECT_CODE = @p_project_code-- IN (SELECT * FROM #TMP_PROJECT_CODE)
					AND T1.YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)  
					AND T1.MEASURE = 'DP_RESULT'
				END

				
      
			END  

	PRINT N'@@p_yyyymm = ' + @p_yyyymm  + ' ' + CONVERT(CHAR(6), DATEADD(MONTH, @i +1, @p_yyyymm_to_simul + '01'), 112)   + ' ' + CONVERT(NVARCHAR,  @i)  

		SET @i = @i + 1  
  
 	END

	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



	BEGIN

	DECLARE @s           INT = 0
	DECLARE @PSI_CNT     INT = 1
	DECLARE @YYYYMM_CNT  INT = 1 
	DECLARE @YYYYMM      NVARCHAR(30)
	DECLARE @YYYYMM_FROM NVARCHAR(30)
	DECLARE @YYYYMM_TO   NVARCHAR(30)
	DECLARE @V_MEASURE   NVARCHAR(30)
	DECLARE @V_P		 INT = 0
	DECLARE @V_S		 INT = 0
	DECLARE @V_I		 INT = 0
	DECLARE @V_V		 INT = 0
	DECLARE @V_M		 INT = 0
	DECLARE @V_CP		 INT = 0

	SELECT @YYYYMM_CNT = DATEDIFF(MONTH, SUBSTRING(@p_yyyymm_from_simul, 1, 4) + '-' + SUBSTRING(@p_yyyymm_from_simul, 5, 2)  + '-01'
	     , SUBSTRING(CONVERT(CHAR(6),  DATEADD(MONTH, 0, GETDATE()), 112) , 1, 4) + '-' + SUBSTRING(CONVERT(CHAR(6), DATEADD(MONTH, 0, GETDATE()), 112) , 5, 2)  + '-01' )
	SET @YYYYMM_FROM = @p_yyyymm_from_simul
	SELECT @YYYYMM_TO = CONVERT(CHAR(6), GETDATE(), 112) 
	



	END


	BEGIN
			-- 테이블중복제거
		IF OBJECT_ID (N'tempdb..#TEMP_AN_LOGIC', N'U')			IS NOT NULL	DROP TABLE #TEMP_AN_LOGIC

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID (N'dbo.#TEMP_AN_LOGIC', N'U')				IS NOT NULL	DROP TABLE #TEMP_AN_LOGIC
				
				
		CREATE TABLE #TEMP_AN_LOGIC(  
				DIVISION_ID				NVARCHAR(MAX),
				PROJECT_CODE			NVARCHAR(MAX),
				YYYYMM					NVARCHAR(MAX),
				CUST_FCST_M				NVARCHAR(MAX),
				MEASURE					NVARCHAR(MAX),				   
				P_VALUE					NVARCHAR(MAX),				   
				S_VALUE					NVARCHAR(MAX),				   
				I_VALUE					NVARCHAR(MAX),				   
				V_VALUE					NVARCHAR(MAX),				   
				M_VALUE					NVARCHAR(MAX),					   
				CP_VALUE				NVARCHAR(MAX),			   
				MKT_FCST_M				NVARCHAR(MAX),
				)

	END

	--PRINT @YYYYMM_CNT


	--SELECT * FROM  #TEMP_DM_MST_VERSION

		BEGIN

			SELECT @v_LAST_MONTH_EDI =ISNULL(CEILING(SUM(QTY)), 0)
			FROM DM_PLN_MKT_FCST_C X WITH(NOLOCK) 
			JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
		    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
			ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
			WHERE 1=1   
			AND X.DIVISION_ID = @p_division_id  
			AND X.MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')  
			--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
			AND X.PROJECT_CODE = @p_project_code  
			AND X.ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
			AND X.FCST_TYPE = 'MPS'
			AND SUBSTRING(X.YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MONTH, 1, @p_yyyymm_to_simul + '01'), 112)--'202308'	

			--SELECT CONVERT(CHAR(6), DATEADD(MONTH, 1, '202310' + '01'), 112)

			--SELECT CONVERT(CHAR(6), DATEADD(MONTH, 1, @p_yyyymm_to_simul + '01'), 112)

			--PRINT @v_LAST_MONTH_EDI

			--SELECT @v_LAST_MONTH_EDI = CUST_FCST_M FROM DM_ANL_MKT_PSI WITH(NOLOCK) WHERE 1=1
			--AND PROJECT_CODE = @p_project_code
			--AND YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, 1, @p_yyyymm_to_simul + '01'), 112) AND MEASURE = 'DP_RESULT'
		END


		BEGIN
			--SELECT * FROM #TEMP_DATA WHERE YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, @i-1, @p_yyyymm + '01'), 112)   
			

			SET @v_DP_ANL_SUM  =  CONVERT(NUMERIC(4,2), @v_DP_RESULT_SUM/@v_EDI_SUM )
			SET @v_DP_ANL_P    =  CONVERT(NUMERIC(4,2), @v_DP_RESULT_P/@v_EDI_SUM )
			SET @v_DP_ANL_S    =  CONVERT(NUMERIC(4,2), @v_DP_RESULT_S/@v_EDI_SUM )
			SET @v_DP_ANL_I    =  CONVERT(NUMERIC(4,2), @v_DP_RESULT_I/@v_EDI_SUM )
			SET @v_DP_ANL_V    =  CONVERT(NUMERIC(4,2), @v_DP_RESULT_V/@v_EDI_SUM )
			SET @v_DP_ANL_M    =  CONVERT(NUMERIC(4,2), @v_DP_RESULT_M/@v_EDI_SUM )
			SET @v_DP_ANL_CP   =  CONVERT(NUMERIC(4,2), @v_DP_RESULT_CP/@v_EDI_SUM )

			--SELECT @v_DP_ANL_SUM, @v_DP_ANL_P
		END

		--PRINT CONVERT(NUMERIC(4,3),ISNULL(@v_DP_ANL_SUM, 0))

		PRINT @v_EDI_SUM

		PRINT CONCAT( (CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_SUM, 0)) * 100), '%')  
		PRINT CONCAT( (CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_P, 0))* 100), '%')  
		PRINT CONCAT( (CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_S, 0))* 100), '%')  
		PRINT CONCAT( (CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_I, 0))* 100), '%')  
		PRINT CONCAT( (CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_V, 0))* 100), '%')  
		PRINT CONCAT( (CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_M, 0))* 100), '%')   
		PRINT CONCAT( (CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_CP, 0))* 100), '%')  

		BEGIN
		    UPDATE #TEMP_DATA SET 
			[SUM]        = CONCAT((CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_SUM, 0) ) * 100), '%')  --CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_SUM, 0), 3)) * 100), '%')  
			,PRODUCT     = CONCAT((CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_P, 0) ) * 100), '%')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_P, 0), 3)) * 100), '%')  
			,SALE        = CONCAT((CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_S, 0) ) * 100), '%')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_S, 0), 3)) * 100), '%')  
			,INVENTORY   = CONCAT((CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_I, 0) ) * 100), '%')  --CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_I, 0), 3)) * 100), '%')  
			,TIME_ADJUST = CONCAT((CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_V, 0) ) * 100), '%')  --CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_V, 0), 3)) * 100), '%')  
			,MODEL_MIX   = CONCAT((CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_M, 0) ) * 100), '%')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_M, 0), 3)) * 100), '%')  
			,SUPPLY_ISSUE = CONCAT((CONVERT(NUMERIC(4,2),ISNULL(@v_DP_ANL_CP, 0) ) * 100), '%')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_CP, 0), 3)) * 100), '%')  
			--, PRODUCT = @v_DP_ANL_P, SALE = @v_DP_ANL_S, INVENTORY = @v_DP_ANL_I, TIME_ADJUST = @v_DP_ANL_V, MODEL_MIX = @v_DP_ANL_M
			WHERE YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, 1, @p_yyyymm_to_simul + '01'), 112)    AND MEASURE = 'Average impact(%)'
		END


		PRINT @v_LAST_MONTH_EDI

		BEGIN
		    UPDATE #TEMP_DATA SET 
			[SUM]        = FORMAT(CEILING(CONVERT(NUMERIC(4,2),ROUND(ISNULL(@v_DP_ANL_SUM, 0), 3)) * @v_LAST_MONTH_EDI), '#,#')
			,PRODUCT     = FORMAT(CEILING(CONVERT(NUMERIC(4,2),ROUND(ISNULL(@v_DP_ANL_P, 0), 3)) * @v_LAST_MONTH_EDI), '#,#') --CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_P, 0), 2)) * 100), '%')  
			,SALE        = FORMAT(CEILING(CONVERT(NUMERIC(4,2),ROUND(ISNULL(@v_DP_ANL_S, 0), 3)) * @v_LAST_MONTH_EDI), '#,#')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_S, 0), 2)) * 100), '%')  
			,INVENTORY   = FORMAT(CEILING(CONVERT(NUMERIC(4,2),ROUND(ISNULL(@v_DP_ANL_I, 0), 3)) * @v_LAST_MONTH_EDI), '#,#')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_I, 0), 2)) * 100), '%')  
			,TIME_ADJUST = FORMAT(CEILING(CONVERT(NUMERIC(4,2),ROUND(ISNULL(@v_DP_ANL_V, 0), 3)) * @v_LAST_MONTH_EDI), '#,#')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_V, 0), 2)) * 100), '%')  
			,MODEL_MIX   = FORMAT(CEILING(CONVERT(NUMERIC(4,2),ROUND(ISNULL(@v_DP_ANL_M, 0), 3)) * @v_LAST_MONTH_EDI), '#,#')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_M, 0), 2)) * 100), '%')   
			,SUPPLY_ISSUE   = FORMAT(CEILING(CONVERT(NUMERIC(4,2),ROUND(ISNULL(@v_DP_ANL_CP, 0), 3)) * @v_LAST_MONTH_EDI), '#,#')--CONCAT(CONVERT(VARCHAR, CONVERT(NUMERIC(3,2),ROUND(ISNULL(@v_DP_ANL_CP, 0), 2)) * 100), '%') 
			--, PRODUCT = @v_DP_ANL_P, SALE = @v_DP_ANL_S, INVENTORY = @v_DP_ANL_I, TIME_ADJUST = @v_DP_ANL_V, MODEL_MIX = @v_DP_ANL_M
			WHERE YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, 1, @p_yyyymm_to_simul + '01'), 112)    AND MEASURE = 'Simulation (Impact)'
		END


		
	SELECT T.DIVISION_ID
		,T.END_CUSTOMER
		,T.PROJECT_NAME
		,T.PROJECT_CODE
		,CONCAT (SUBSTRING(YYYYMM, 1, 4),'.',SUBSTRING(YYYYMM, 5, 2)) AS YYYYMM 
		,CEILING(EDI_QTY) AS EDI_QTY
		,MEASURE
		,[SUM]
		,PRODUCT
		,SALE
		,INVENTORY
		,TIME_ADJUST
		,MODEL_MIX
		,MKT_DP
		,SUPPLY_ISSUE   --2023.11.03 kcw3408 	[개발요청] 수요분석시스템_35번	Simulation 기능 로직 수정(신규 추가된 '공급차질' 카테고리를 연계하도록)
	FROM #TEMP_DATA T WITH (NOLOCK)
	ORDER BY YYYYMM ASC
		,RNK;  
END  
	
	