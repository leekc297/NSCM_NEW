/*
 * Program ID   : DMF0052_GET_STATUS_DATA
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2022.11.16	   HWI1993		  C20221103-000432  EDI 상시 점검
 2023.01.03	   kdmcc14		  [C20230102-000019]  Status ERP 칼럼 내림차순 정렬, Status ERP 칼럼 값이 FAILED인 경우 Status GSCM을 전부 FAILED로 표기, 퍼센티지 값 표기 추가

 EXEC DMF0052_GET_STATUS_DATA 'ALL', '', '', '20221013', '20230111'
 */
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DMF0052_GET_STATUS_DATA]
	@p_SENDER_CODE			NVARCHAR(4000),
	@p_ITEM_ID					NVARCHAR(4000),
	@p_project_code				NVARCHAR(4000),
	@p_FROM_YYYYMMDD	NVARCHAR(8),
	@p_TO_YYYYMMDD			NVARCHAR(8)
AS

BEGIN
	
    SET NOCOUNT ON;

	    SELECT STATUS_ERP
				 , STATUS_GSCM
				 , QTY 
				 , CONVERT(NVARCHAR, ROUND((CONVERT(FLOAT, QTY) / CONVERT(FLOAT, SUM_QTY)) * 100, 2)) + '%' AS AVG_PERCENT				 
		 FROM (
					SELECT CASE WHEN ATTRIBUTE6 IN ( 'S', 'W' ) THEN 'SUCCESS'  
									   ELSE 'FAILED' END AS STATUS_ERP  
							 , CASE WHEN ATTRIBUTE6 IN ('S', 'W') THEN ATTRIBUTE1
									   ELSE 'FAILED' END AS STATUS_GSCM  
							 , COUNT(*) AS QTY
							 , SUM(COUNT(*)) OVER () AS SUM_QTY				
					 FROM DM_DNM_EDI_CALLOFF_ITEM A WITH(NOLOCK) 
				    WHERE A.CREATE_DATE BETWEEN @p_FROM_YYYYMMDD AND @p_TO_YYYYMMDD
					    AND CASE WHEN @p_SENDER_CODE = 'ALL' THEN @p_SENDER_CODE
										ELSE A.SENDER_CODE END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@p_SENDER_CODE, ','))  
						AND CASE WHEN @p_ITEM_ID = '' THEN @p_ITEM_ID
										ELSE A.ITEM_ID END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@p_ITEM_ID, ','))  
						AND CASE WHEN @p_project_code = '' THEN @p_project_code
										ELSE ISNULL(A.ATTRIBUTE7,'') END IN ( SELECT TOKEN FROM DBO.STRING_SPLIT(@p_project_code, ','))  
					GROUP BY CASE WHEN ATTRIBUTE6 IN ( 'S', 'W' ) THEN 'SUCCESS'  
											ELSE 'FAILED' END  
								  , CASE WHEN ATTRIBUTE6 IN ('S', 'W') THEN ATTRIBUTE1
											ELSE 'FAILED' END  
				   ) A	    
	   GROUP BY STATUS_ERP, STATUS_GSCM, QTY, SUM_QTY
	   ORDER BY 1 DESC, 2
	

END
