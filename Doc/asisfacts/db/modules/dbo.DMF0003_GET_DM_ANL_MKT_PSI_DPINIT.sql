/*
 * Program ID  : [DMF0003_GET_DM_ANL_MKT_PSI_DPINIT]
 * Description  : 고객수요증감분석 PSI 팝업 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.10.14	   chutoc730		  []  고객수요증감분석 PSI 입력창의 관리 단위 변경(END CUSTOMER까지)
공급차질 수량을 구분하기 위한 Category 신규 추가
분석 입력 기간 설정 잠시 Close
 2023.11.08 kcw3408 	[개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 2024.01.10    kcw3408        [개발요청] 고객수요증감분석_배치작업 신규(표준리포트/RPA팀 우혜라 요청)으로 데이타 존재여부 확인

-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPINIT '81', 'A15BW7001','202308', '','BMW'
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPINIT '81', 'A15BW7001','202308', '','BMW'
-- EXEC DMF0003_GET_DM_ANL_MKT_PSI_DPINIT @p_division_id=N'81',@p_project_code=N'A15BW7001',@p_yyyymm=N'202308',@p_created_by=N'',@p_end_customer=N'BMW'
 */
CREATE PROCEDURE [dbo].[DMF0003_GET_DM_ANL_MKT_PSI_DPINIT]
	@p_division_id	NVARCHAR(30),
    @p_project_code    NVARCHAR(50),
	@p_yyyymm    NVARCHAR(20),
	@p_created_by	NVARCHAR(MAX),  
    @p_end_customer NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;


	-- CREATE TABLE #TEMP_DATA(  
	--   PROJECT_CODE              NVARCHAR(30) NOT NULL,  
	--   YYYYMM          NVARCHAR(6)  NOT NULL,  
	--   MKT_FCST          NVARCHAR(30) NOT NULL,  
	--   IN_DE_VOL         NVARCHAR(30) NULL,  
	--   IMPUTATION_YN         NVARCHAR(30) NULL,  
	--   DEMAND_OPERATION         NVARCHAR(30) NULL,  
	--   VARIATION_FACTOR        NVARCHAR(30) NULL,  
	--   [DESC]          NVARCHAR(MAX) NULL,  
	--   IN_DE_DEMAND         NVARCHAR(30) NULL,  
	--   IN_DDAY      NVARCHAR(30) NULL,  
	--   DE_PL            NVARCHAR(30) NULL,    
	--   )

	--DECLARE @CNT INT = 0, @i INT =  1
	--DECLARE @v_yyyymm NVARCHAR(20)
	--SET @i = -12
  
    --WHILE @i <= 0
	BEGIN

		--BEGIN
		--	SELECT @CNT = COUNT(*) FROM DM_ANL_MKT_PSI_DETAIL WHERE 1=1
		--	   AND DIVISION_ID = @p_division_id
		--	   AND PROJECT_CODE = @p_project_code
		--	   AND MEASURE = 'DP_INIT'

		--	   AND YYYYMM = CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)
		--END

		--IF (@CNT = 0)
		--BEGIN
		--	BEGIN
		--		INSERT INTO #TEMP_DATA  
		--		SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'고객', N'수요', N'차량생산', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO #TEMP_DATA  
		--		SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'고객', N'수요', N'차량판매', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO #TEMP_DATA  
		--		SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'고객', N'수요', N'물류이슈', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO #TEMP_DATA  
		--		SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'당사', N'운영', N'시점조정', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO #TEMP_DATA  
		--		SELECT @p_project_code, CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112), 0, 0, N'당사', N'운영', N'모델믹스', '', 0, '', 0
		--	END
		--END
		--ELSE
		BEGIN
			   
		-- 수요계획 1st 조회 쿼리
		--INSERT INTO #TEMP_DATA  
		-- wbs 주석
		/*
		SELECT PROJECT_CODE
			 , YYYYMM
			 , CONVERT(NUMERIC(30, 2), CUST_FCST_M) AS MKT_FCST
			 , CONVERT(NUMERIC(30, 2), QTY) AS IN_DE_VOL
			 , CASE QTYCD1 WHEN 'CUSTOMER' THEN N'고객'--'100'-- N'고객'
						   WHEN 'COMPANY' THEN N'당사'--'200' --N'당사' 
						   END AS IMPUTATION_YN
			 , CASE QTYCD2 WHEN 'DEMAND' THEN N'수요'--N'110'--N'수요'
						   WHEN 'OPERATION' THEN N'운영'--N'210'--N'운영' 
						   WHEN 'SUPPLY' THEN N'공급'--N'220'--N'공급' 
						   END AS DEMAND_OPERATION
			 , CASE QTYCD3 WHEN 'PRODUCT' THEN N'차량생산'--N'111'--N'차량생산'
						   WHEN 'SALES' THEN N'차량판매'--N'112'--N'차량판매'
						   WHEN 'INVENTORY' THEN N'물류이슈'--N'113'--N'물류이슈'
						   WHEN 'VPA' THEN N'시점조정'--N'211'--N'시점조정'
						   WHEN 'MODELMIX' THEN N'모델믹스' --N'212'--N'모델믹스' 
						   WHEN 'SUPPLYISSUE' THEN N'공급차질' --N'221'--N'공급차질' 
						   
						   END AS VARIATION_FACTOR
			 , [DESC] AS [DESC]--[DESC] AS [DESC]
			 , '' AS IN_DE_DEMAND
			 , INPUT_LIMIT AS IN_DDAY
			 , CONVERT(NUMERIC(30, 2), MKT_FCST_M) AS DE_PL
		  FROM DM_ANL_MKT_PSI_DETAIL WITH(NOLOCK) 
		 WHERE 1=1
		   AND DIVISION_ID = @p_division_id
		   AND PROJECT_CODE = @p_project_code
		   AND MEASURE = 'DP_INIT'
		   --AND YYYYMM BETWEEN CONVERT(CHAR(6), DATEADD(MONTH, -11, GETDATE()), 112) AND CONVERT(CHAR(6), GETDATE(), 112);
		   AND YYYYMM = @p_yyyymm--CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)
		END
		   */
		--SET @i = @I + 1
		SELECT PROJECT_CODE
			 , END_CUSTOMER
			 , YYYYMM
			 , ISNULL(CEILING(CUST_FCST_M), 0) AS EDI_QTY
			 , ISNULL(CEILING(QTY), 0) AS IN_DE_VOL
			 , CASE QTYCD1 WHEN 'CUSTOMER' THEN N'고객'--'100'-- N'고객'
						   WHEN 'COMPANY' THEN N'당사'--'200' --N'당사' 
						   END AS IMPUTATION_YN
			 , CASE QTYCD2 WHEN 'DEMAND' THEN N'수요'--N'110'--N'수요'
						   WHEN 'OPERATION' THEN N'운영'--N'210'--N'운영' 
						   WHEN 'SUPPLY' THEN N'공급'--N'220'--N'공급' 
						   END AS DEMAND_OPERATION
			 , CASE QTYCD3 WHEN 'PRODUCT' THEN N'차량생산'--N'111'--N'차량생산'
						   WHEN 'SALES' THEN N'차량판매'--N'112'--N'차량판매'
						   WHEN 'INVENTORY' THEN N'물류이슈'--N'113'--N'물류이슈'
						   WHEN 'VPA' THEN N'시점조정'--N'211'--N'시점조정'
						   WHEN 'MODELMIX' THEN N'모델믹스' --N'212'--N'모델믹스' 
						   WHEN 'SUPPLYISSUE' THEN N'공급차질' --N'221'--N'공급차질' 
						   END AS VARIATION_FACTOR
			 , [DESC] AS [DESC]--[DESC] AS [DESC]
			 --, ISNULL(CEILING(CUST_FCST_M + QTY), 0) AS RESULT
			 --, INPUT_LIMIT AS IN_DDAY
			 , ISNULL(CEILING(MKT_FCST_M), 0) AS MKT_FCST
		  FROM DM_ANL_MKT_PSI_DETAIL WITH(NOLOCK) 
		 WHERE 1=1
		   AND DIVISION_ID = @p_division_id  
		   AND END_CUSTOMER = @p_end_customer
		   AND PROJECT_CODE = @p_project_code
		   AND MEASURE = 'DP_INIT'
		   AND QTYCD3 <> ''
		   --AND YYYYMM BETWEEN CONVERT(CHAR(6), DATEADD(MONTH, -11, GETDATE()), 112) AND CONVERT(CHAR(6), GETDATE(), 112);
		   AND YYYYMM = @p_yyyymm--CONVERT(CHAR(6), DATEADD(MONTH, @i, @p_yyyymm + '01'), 112)
		 ORDER BY SEQ;
		END
	END

	--SELECT * FROM #TEMP_DATA  

    

END




