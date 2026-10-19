/*
 * Program ID   : DMF0052_GET_SUMMARY_DATA
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2022.11.16	   HWI1993		  C20221103-000432  EDI 상시 점검 날짜조건만 적용함. 나머지는 구조상 적용하지 않음.
 2023.01.03	   kdmcc14		  [C20230102-000019]  EDI SUMMARY DATA 날짜 내림차순 정렬
 */
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DMF0052_GET_SUMMARY_DATA]
	@p_SENDER_CODE			NVARCHAR(4000),
	@p_ITEM_ID					NVARCHAR(4000),
	@p_project_code				NVARCHAR(4000),
	@p_FROM_YYYYMMDD	NVARCHAR(8),
	@p_TO_YYYYMMDD			NVARCHAR(8)
AS

BEGIN
	
    SET NOCOUNT ON;
	-- SENDER 조건이 있으면 SENDER_CNT 를 체크하고 없으면 TT_CNT 를 체크한다.

	SELECT ISNULL(A.YYYYMMDD,B.YYYYMMDD) AS YYYYMMDD
			 , ISNULL(B.ERP_CNT, 0) AS SEND_CNT
			 , ISNULL(A.GSCM_CNT, 0) AS RCV_CNT
			 , CASE WHEN ISNULL(B.ERP_CNT, 0) = ISNULL(A.GSCM_CNT, 0) THEN 'COMPLETE'
					   ELSE 'Need to Check' END AS STATUS
	 FROM (
				SELECT TRANSFER_CREATE_DATE AS YYYYMMDD
						 , COUNT(*) AS GSCM_CNT
				 FROM XIF_ERP_EDI_CALLOFF_ITEM_R_SN A
			    WHERE TRANSFER_CREATE_DATE BETWEEN @p_FROM_YYYYMMDD AND @p_TO_YYYYMMDD
			    GROUP BY TRANSFER_CREATE_DATE
			   ) A
	 FULL OUTER JOIN 
			   (
				-- 총 건수는 ERP 에서 국내와 해외를 각각 보내는 관계로 합산해야 한다. ( IFSEQNO LIKE '1%' : 해외, '5%' 국내 )
				SELECT ISNULL(A.YYYYMMDD, B.YYYYMMDD) AS YYYYMMDD
						 , ISNULL(A.ERP_CNT, 0) + ISNULL(B.ERP_CNT,0) AS ERP_CNT
				 FROM (
							SELECT TRANSFER_CREATE_DATE AS YYYYMMDD
									 , MAX(CASE WHEN ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS INT) 
													  ELSE 0 END) AS ERP_CNT
							 FROM XIF_ERP_EDI_CALLOFF_ITEM_R_SN A
						   WHERE TRANSFER_CREATE_DATE BETWEEN @p_FROM_YYYYMMDD AND @p_TO_YYYYMMDD
							   AND IFSEQNO LIKE '1%'
						   GROUP BY TRANSFER_CREATE_DATE
						  ) A
				 FULL OUTER JOIN 
						 (
						  SELECT TRANSFER_CREATE_DATE AS YYYYMMDD
							 	   , MAX(CASE WHEN ISNUMERIC(ATTRIBUTE2) > 0 THEN CAST(ATTRIBUTE2 AS INT) 
												    ELSE 0 END) AS ERP_CNT
						   FROM XIF_ERP_EDI_CALLOFF_ITEM_R_SN A
					     WHERE TRANSFER_CREATE_DATE BETWEEN @p_FROM_YYYYMMDD AND @p_TO_YYYYMMDD
						     AND IFSEQNO LIKE '5%'
					     GROUP BY TRANSFER_CREATE_DATE
					     ) B ON A.YYYYMMDD = B.YYYYMMDD		
			   ) B ON A.YYYYMMDD = B.YYYYMMDD
	ORDER BY ISNULL(A.YYYYMMDD,B.YYYYMMDD) DESC
	

END
