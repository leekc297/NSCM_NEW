 
/*
 * Program ID  : [DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT]
 * Author:		<Author,,Name>
 * Create date: <Create Date,,>
 * Description  : 고객수요증감 입력(DMF0003_GET_DM_ANL_MKT_PSI_DATA:고객수요증감분석 PSI 조회 sub)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.11.02 kcw3408 	[개발요청] 수요분석시스템_36번	Final 값은 실적 값으로 변경 
 2023.11.08 kcw3408 	[개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 2024.01.10    kcw3408        [개발요청] 고객수요증감분석_배치작업 신규(표준리포트/RPA팀 우혜라 요청)으로 데이타 존재여부 확인

-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT @p_division_id=N'81',@p_project_code=N'A15BW7003',@p_yyyymm=N'202308',@p_created_by=N'',@p_end_customer=N'BMW'
 */
CREATE PROCEDURE [dbo].[DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT]
	@p_division_id	NVARCHAR(30),
    @p_project_code    NVARCHAR(50),
	@p_yyyymm    NVARCHAR(20),
	@p_created_by	NVARCHAR(MAX), 
    @p_end_customer NVARCHAR(50)

--EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT'81','A15AI7001','202307','leetw85'

AS
BEGIN
	SET NOCOUNT ON;	

	/*	
	   2023.11.02	   kcw3408		  ⓓ MKT.FCST (DP) 을 월 MKT FCST[R+P] Measure실적과 동일하게 관리
    */
	BEGIN			
		UPDATE T1
		SET MKT_FCST_M = T2.MKT_FCST_M
		FROM [dbo].[DM_ANL_MKT_PSI_DETAIL] T1
		JOIN 
		     (SELECT X.DIVISION_ID
			      , X.END_CUSTOMER
			      , X.PROJECT_CODE
				  , X.YYYYMM
			      , ISNULL(CEILING(X.MKT_FCST_M), 0) AS MKT_FCST_M
			   FROM DM_ANL_MKT_PSI X WITH (NOLOCK) 
		      WHERE 1 = 1
		        AND X.DIVISION_ID = @p_division_id
			    AND X.END_CUSTOMER = @p_end_customer
			    AND X.PROJECT_CODE = @p_project_code
	            AND X.MEASURE = 'DP_RESULT'
				AND X.YYYYMM = @p_yyyymm 
		  ) T2
		 ON T2.DIVISION_ID  = T1.DIVISION_ID 
		AND T2.END_CUSTOMER = T1.END_CUSTOMER
		AND T2.PROJECT_CODE = T1.PROJECT_CODE
		AND T2.YYYYMM       = T1.YYYYMM  
		AND T1.MEASURE = 'DP_RESULT'
	END

    -- 수요계획 Result 조회 쿼리
	SELECT PROJECT_CODE
		 , END_CUSTOMER
		 , YYYYMM
		 , ISNULL(CEILING(CUST_FCST_M), 0) AS EDI_QTY
		 , ISNULL(CEILING(QTY), 0) AS IN_DE_VOL
		 , CASE QTYCD1 WHEN 'CUSTOMER' THEN N'고객'
					   WHEN 'COMPANY' THEN N'당사' END AS IMPUTATION_YN
		 , CASE QTYCD2 WHEN 'DEMAND' THEN N'수요'
					   WHEN 'OPERATION' THEN N'운영' 
					   WHEN 'SUPPLY' THEN N'공급'  END AS DEMAND_OPERATION
		 , CASE QTYCD3 WHEN 'PRODUCT' THEN N'차량생산'
					   WHEN 'SALES' THEN N'차량판매'
					   WHEN 'INVENTORY' THEN N'물류이슈'
					   WHEN 'VPA' THEN N'시점조정'
					   WHEN 'MODELMIX' THEN N'모델믹스' 
					   WHEN 'SUPPLYISSUE' THEN N'공급차질' END AS VARIATION_FACTOR
		 , [DESC] AS "DESC"
		 --, ISNULL(CEILING(CUST_FCST_M + QTY), 0) AS IN_DE_DEMAND
		 --, INPUT_LIMIT AS IN_DDAY
		 , ISNULL(CEILING(MKT_FCST_M), 0) AS MKT_FCST
	  FROM DM_ANL_MKT_PSI_DETAIL WITH(NOLOCK) 
	 WHERE 1=1
	   AND DIVISION_ID = @p_division_id
	   AND END_CUSTOMER = @p_end_customer
	   AND PROJECT_CODE = @p_project_code
	   AND MEASURE = 'DP_RESULT'
       AND QTYCD3 <> ''
	   --AND YYYYMM BETWEEN CONVERT(CHAR(6), DATEADD(MONTH, -11, GETDATE()), 112) AND CONVERT(CHAR(6), GETDATE(), 112);
	   AND YYYYMM = @p_yyyymm
	 ORDER BY SEQ;
END
