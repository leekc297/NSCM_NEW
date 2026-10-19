
/*
 * Program ID  : [DMF0069_GET_DM_ANL_MKT_STATUSLIST]
 * Description  : 수요분석시스템 현황판 조회 (DIVISION 별 프로젝트별 리스트)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================  
  2023.11.21 kcw3408  [개발요청] 수요분석시스템_29_프로젝트별 고객수요분석 입력 여부 확인 가능한 현황판 및 알람 신규작성
  2023.12.13 kcw3408  [개발요청] 수요분석시스템_MEASURE 추가 요청 ('CUST_FCST', 'Customer FCST')	
  2024.01.16 kcw3408  [개발요청] 수요분석시스템_DM_PLN_MKT_FCST 의 MEASURE 값 ('CUST_FCST', 'Customer FCST')이 부정확해서 실적구간은 DM_PLN_MKT_FCST_RESULT 테이블로 변경
   
-- EXEC DMF0069_GET_DM_ANL_MKT_STATUSLIST @p_division_id=N'81',@p_completed_yn=N'N',@p_from_yyyymmdd=N'20230101',@p_to_yyyymmdd=N'20231130' 
 */
  

CREATE  PROCEDURE [dbo].[DMF0069_GET_DM_ANL_MKT_STATUSLIST]  
	 @p_division_id    NVARCHAR(30)  
	,@p_completed_yn   NVARCHAR(1) 
    ,@p_from_yyyymmdd  NVARCHAR(8) 
    ,@p_to_yyyymmdd    NVARCHAR(8) 
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @v_from_yyyymmdd NVARCHAR(08);
	DECLARE @v_to_yyyymmdd   NVARCHAR(08);
	DECLARE @v_from_yyyymmdd_R NVARCHAR(08);
	DECLARE @v_to_yyyymmdd_R   NVARCHAR(08);
	DECLARE @v_completed_cnt      AS INT;
	 

	-- 테이블중복제거
	IF OBJECT_ID(N'tempdb..#TEMP_DATA', N'U') IS NOT NULL
		DROP TABLE #TEMP_DATA

	-- 임시확인용테이블 중복제거
	IF OBJECT_ID(N'dbo.#TEMP_DATA', N'U') IS NOT NULL
		DROP TABLE #TEMP_DATA

	CREATE TABLE #TEMP_DATA (
		 DIVISION_ID NVARCHAR(30) NOT NULL
		,End_Customer NVARCHAR(50) NOT NULL
		,PROJECT_CODE NVARCHAR(50) NOT NULL 
		,PROJECT_NAME NVARCHAR(100) NOT NULL
		,LAST_UPDATE_DATE NVARCHAR(50) NOT NULL
		,CHECK_CNT    NVARCHAR(30) NULL 
		);
		
		 
	BEGIN		  
		SET @v_from_yyyymmdd = CONVERT(CHAR(8), SUBSTRING(@p_from_yyyymmdd, 1, 6) + '01',  112)
		SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, - 1, DATEADD(MM, 1, SUBSTRING(@p_to_yyyymmdd, 1, 6) + '01')),  112) 
	END
		
	BEGIN 
	    -- 테이블중복제거
    	IF OBJECT_ID(N'tempdb..#TEMP_SCM_SYS_CALENDAR_M', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_SCM_SYS_CALENDAR_M

     	-- 임시확인용테이블 중복제거
    	IF OBJECT_ID(N'dbo.#TEMP_SCM_SYS_CALENDAR_M', N'U') IS NOT NULL
		   DROP TABLE #TEMP_SCM_SYS_CALENDAR_M

		SELECT DISTINCT BASIS_YYYYMM 
		INTO #TEMP_SCM_SYS_CALENDAR_M
		FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)		 
		WHERE  A.basis_yyyymmdd >= @v_from_yyyymmdd
		AND    A.basis_yyyymmdd <= @v_to_yyyymmdd  

		
	    SET @v_completed_cnt = 0 

        SELECT @v_completed_cnt = COUNT(*) * 2
	      FROM #TEMP_SCM_SYS_CALENDAR_M  WITH(NOLOCK)
	     WHERE  1 = 1
		
     	-- 실적구간 / 계획구간 구분SELECT X.DIVISION_ID 
		SELECT @v_from_yyyymmdd_R = ISNULL(MAX(X.YYYYMMDD),CONVERT(CHAR(8), DATEADD(DD, - 1,@V_from_yyyymmdd),  112))
		     , @v_to_yyyymmdd_R = ISNULL(MAX(X.YYYYMMDD),@V_to_yyyymmdd) 
		FROM DM_PLN_MKT_FCST_RESULT X WITH (NOLOCK) 	
		WHERE 1 = 1 
	    AND X.DIVISION_ID LIKE '81%'	
	    AND X.MEASURE IN ('CUST_FCST_EDI','CUST_FCST')	
		AND X.YYYYMMDD  >= @V_from_yyyymmdd
		AND X.YYYYMMDD  <= @V_to_yyyymmdd 
	END
	
  
		 
	/*	
	  대상추출
    */
	BEGIN
		
	   INSERT INTO #TEMP_DATA 
       SELECT T1.DIVISION_ID
			, T1.END_CUSTOMER
			, T1.PROJECT_CODE 
			, T1.PROJECT_NAME
            , ISNULL(CONVERT(CHAR(8), T2.LAST_UPDATE_DATE, 112),'') AS LAST_UPDATE_DATE
            , @v_completed_cnt - ISNULL(T2.CHECK_CNT,0) AS CHECK_CNT  
		FROM  
		    (SELECT A.DIVISION_ID
			      , A.END_CUSTOMER
			      , A.PROJECT_CODE 
			      , A.PROJECT_NAME 
			   FROM (SELECT X.DIVISION_ID
						  , H.END_CUSTOMER
						  , X.PROJECT_CODE 
			              , I.PROJECT_NAME
					   FROM DM_PLN_MKT_FCST_RESULT X WITH (NOLOCK) 			   
					   JOIN SCM_MST_SITE_ITEM F WITH(NOLOCK) 
							ON	F.DIVISION_ID    = X.DIVISION_ID
						   AND	F.PROJECT_CODE   = X.PROJECT_CODE
						   AND	F.SCM_SITE_ID    = X.SCM_SITE_ID
						   AND	F.ITEM_ID        = X.ITEM_ID			   
					   JOIN SCM_MST_SITE H WITH(NOLOCK) 
							ON	F.DIVISION_ID    = H.DIVISION_ID 
						   AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
					  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G WITH(NOLOCK) 
						   ON	G.SEGMENT1    = X.FCST_TYPE
								  AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE' 	  
					  LEFT OUTER JOIN  SCM_MST_PROJECT I 
							ON	I.DIVISION_ID    = X.DIVISION_ID
						   AND	I.PROJECT_CODE   = X.PROJECT_CODE 
					  WHERE 1 = 1 
	                    AND X.DIVISION_ID = @p_division_id
						AND X.MEASURE IN ('CUST_FCST_EDI','CUST_FCST')	
						AND X.YYYYMMDD  >= @V_from_yyyymmdd
						AND X.YYYYMMDD  <= @v_to_yyyymmdd_R
				      GROUP BY X.DIVISION_ID
							 , H.END_CUSTOMER
							 , X.PROJECT_CODE 
			                , I.PROJECT_NAME
			         UNION ALL
					 SELECT X.DIVISION_ID
						  , H.END_CUSTOMER
						  , X.PROJECT_CODE 
			              , I.PROJECT_NAME
					   FROM DM_PLN_MKT_FCST X WITH (NOLOCK) 			   
						JOIN SCM_MST_SITE_ITEM F WITH(NOLOCK) 
							ON	F.DIVISION_ID    = X.DIVISION_ID
							AND	F.PROJECT_CODE   = X.PROJECT_CODE
							AND	F.SCM_SITE_ID    = X.SCM_SITE_ID
							AND	F.ITEM_ID        = X.ITEM_ID			   
						JOIN SCM_MST_SITE H WITH(NOLOCK) 
							ON	F.DIVISION_ID    = H.DIVISION_ID 
							AND	F.SCM_SITE_ID    = H.SCM_SITE_ID
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL G WITH(NOLOCK) 
							ON	G.SEGMENT1    = X.FCST_TYPE
							AND	G.LOOKUP_TYPE = 'SALES_TYPE_CODE'   
					  LEFT OUTER JOIN  SCM_MST_PROJECT I 
							ON	I.DIVISION_ID    = X.DIVISION_ID
						   AND	I.PROJECT_CODE   = X.PROJECT_CODE 
						WHERE 1 = 1 
	                    AND X.DIVISION_ID = @p_division_id
						AND X.MEASURE IN ('CUST_FCST_EDI','CUST_FCST')	
						AND X.YYYYMMDD  > @V_from_yyyymmdd_R
						AND X.YYYYMMDD  <= @V_to_yyyymmdd 
					GROUP BY X.DIVISION_ID
							, H.END_CUSTOMER
							, X.PROJECT_CODE 
			                , I.PROJECT_NAME
				  ) A
			GROUP BY A.DIVISION_ID
			      , A.END_CUSTOMER
			      , A.PROJECT_CODE 
			      , A.PROJECT_NAME 
		    ) T1		   
			LEFT OUTER JOIN 
		    (
				SELECT DIVISION_ID
			          ,PROJECT_CODE
			          ,END_CUSTOMER 
			          ,MAX(LAST_UPDATE_DATE)     AS LAST_UPDATE_DATE 
			          ,COUNT(DISTINCT CASE WHEN ((ISNULL(T1.CUST_FCST_M,0) +
					                             (ISNULL(T1.P_VALUE,0) + ISNULL(T1.S_VALUE,0) + ISNULL(T1.I_VALUE,0) + ISNULL(T1.V_VALUE,0) + ISNULL(T1.M_VALUE,0) + ISNULL(T1.CP_VALUE,0))) - 
												  ISNULL(T1.MKT_FCST_M,0)) = 0
                                           THEN T1.YYYYMM + T1.MEASURE  
								      END) AS CHECK_CNT
				FROM DM_ANL_MKT_PSI T1 WITH (NOLOCK)
				JOIN #TEMP_SCM_SYS_CALENDAR_M T2
				     ON T1.YYYYMM  = T2.BASIS_YYYYMM 
			   WHERE T1.MEASURE IN ('DP_INIT','DP_RESULT')
			     AND (ISNULL(T1.P_VALUE,0) <> 0 
			      OR ISNULL(T1.S_VALUE,0) <> 0 
			      OR ISNULL(T1.I_VALUE,0) <> 0 
			      OR ISNULL(T1.V_VALUE,0) <> 0 
			      OR ISNULL(T1.M_VALUE,0) <> 0 
			      OR ISNULL(T1.CP_VALUE,0) <> 0) 
			    -- AND YYYYMM >= CONVERT(CHAR(6), DATEADD(MONTH, -12, @v_to_yyyymmdd), 112)
			    -- AND YYYYMM <= CONVERT(CHAR(6),@v_to_yyyymmdd, 112)
				GROUP BY DIVISION_ID,PROJECT_CODE,END_CUSTOMER 
				) T2 
				ON T1.DIVISION_ID = T2.DIVISION_ID
			   AND T1.END_CUSTOMER = T2.END_CUSTOMER
			   AND T1.PROJECT_CODE = T2.PROJECT_CODE 

	END
	
	SELECT T.DIVISION_ID
		 , T.END_CUSTOMER
		 , T.PROJECT_CODE 
		 , T.PROJECT_NAME
		 , T.LAST_UPDATE_DATE
		 , T.CHECK_CNT  
	FROM #TEMP_DATA T WITH (NOLOCK)
	WHERE (@p_completed_yn = 'Y' AND  T.CHECK_CNT = 0)
	   OR (@p_completed_yn = 'N' AND  T.CHECK_CNT > 0)
	ORDER BY T.END_CUSTOMER ASC
	       , T.PROJECT_CODE;

END