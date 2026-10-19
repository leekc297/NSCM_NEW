

CREATE VIEW [dbo].[SSP_MAIL_SHIP_PLAN_INTER_COM_V] AS
/********************************************************************************************************************************
 * VIEW NAME     : [SSP_MAIL_SHIP_PLAN_INTER_COM_V]
 * DESCRIPTION   : 법인간 거래 대상 TO_SITE PO발행을 위한 공유 메일 대상자 및 대상 아이템 추출 (81,82 대상) 
                
 * PROGRAM HISTORY
 *-------------------------------------------------------------------------------------------------------------------------------
 *  DATE        IN CHARGE      DESCRIPTION
 *-------------------------------------------------------------------------------------------------------------------------------
 * 2018.10.17   juhlee         Initial Release [PJ20189106] 전지.GSCM 고도화 이행-
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
********************************************************************************************************************************/

SELECT DISTINCT 
       M.SEGMENT2             AS MAIL_RECEIVER
,      A.COMPANY_ID           AS COMPANY_ID 
,      A.DIVISION_ID          AS DIVISION_ID
,      A.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
,      A.FROM_SITE            AS FROM_SITE 
,      A.ITEM_ID              AS ITEM_ID
,      A.TO_SITE              AS TO_SITE 
,      CONVERT(VARCHAR, DATEADD(D, +1, CONVERT(DATETIME, A.PLAN_START_YYYYMMDD ,112)) ,112) AS FROM_YYYYMMDD
,      CONVERT(VARCHAR, DATEADD(D, +14, CONVERT(DATETIME, A.PLAN_START_YYYYMMDD ,112)) ,112) AS TO_YYYYMMDD
,      [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](A.DIVISION_ID,A.FROM_SITE) AS SHIP_FROZEN
FROM  SSP_ANL_SHIP_PLAN_C A WITH(NOLOCK) 
    JOIN SCM_MST_SITE  TS WITH(NOLOCK) 
	  ON TS.DIVISION_ID = A.DIVISION_ID 
	 AND TS.SCM_SITE_ID = A.TO_SITE 
	 AND TS.SITE_TYPE ='PLANT'
	 AND TS.OSP_YN    = 'N'
	JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)  
	  ON  M.LOOKUP_TYPE ='SHIP_PLAN_INTER_COM_MAIL_SEND'
	 AND  M.VALID_YN    ='Y'
	 AND  M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE A.TO_SITE END
WHERE A.PLAN_START_YYYYMMDD =  ( SELECT MAX(PLAN_START_YYYYMMDD) 
                                 FROM SSP_ANL_SHIP_PLAN_C 
								 WHERE COMPANY_ID = A.COMPANY_ID 
								 AND   DIVISION_ID  IN ( SELECT DIVISION_ID
                                                           FROM SCM_MST_DIVISION WITH(NOLOCK)
                                                          WHERE VALID_YN = 'Y'
                                                            AND ATTRIBUTE3 IN ('81','82')
													   )
							  ) 
AND   A.YYYYMMDD >= CONVERT(VARCHAR, DATEADD(D, +1, CONVERT(DATETIME, A.PLAN_START_YYYYMMDD ,112)) ,112)
AND   A.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, +14, CONVERT(DATETIME, A.PLAN_START_YYYYMMDD ,112)) ,112)
AND   A.MEASURE  = 'SHIP_PLAN' 
AND   [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](A.DIVISION_ID,A.FROM_SITE) > 0 --  확정일자 0이상인것만
AND   A.QTY > 0 
AND   A.DIVISION_ID  IN ( SELECT DIVISION_ID
                            FROM SCM_MST_DIVISION WITH(NOLOCK)
                           WHERE VALID_YN = 'Y'
                             AND ATTRIBUTE3 IN ('81','82')
				        )

