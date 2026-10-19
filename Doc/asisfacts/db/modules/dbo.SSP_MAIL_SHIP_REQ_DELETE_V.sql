

CREATE  VIEW [dbo].[SSP_MAIL_SHIP_REQ_DELETE_V] 
AS
/********************************************************************************************************************************
 * VIEW NAME     : [SSP_MAIL_SHIP_REQ_DELETE_V]
 * DESCRIPTION   : 출하요청 CONFIRM 시 재고 부족으로 CONFIRM되지 않은 내용 MAILING 대상 (81,82 대상) 
                
 * PROGRAM HISTORY
 *-------------------------------------------------------------------------------------------------------------------------------
 *  DATE        IN CHARGE      DESCRIPTION
 *-------------------------------------------------------------------------------------------------------------------------------
 * 2019.10.17   juhlee         Initial Release  [PJ20189106] 전지.GSCM 고도화 이행 
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용            
********************************************************************************************************************************/
WITH MAIL_RECEIVER 
AS (

SELECT X.DIVISION_ID 
,      X.COMPANY_ID
,      X.PLAN_START_YYYYMMDD
,      X.MAIL_RECEIVER
,      X.FROM_SITE
,      X.ITEM_ID  
,      X.TO_SITE 
FROM ( 
                -- LOOKUP등록자  
				SELECT A.DIVISION_ID
                ,      A.COMPANY_ID 
				,      A.PLAN_START_YYYYMMDD
				,      M.SEGMENT2    AS MAIL_RECEIVER
				,      A.FROM_SITE
				,      A.ITEM_ID 
				,      A.TO_SITE
				FROM  SSP_ANL_SHIP_PLAN_C A WITH(NOLOCK) 
				  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)  
					ON  M.LOOKUP_TYPE ='SHIP_REQ_DEL_MAIL_SEND'
				   AND  M.VALID_YN    ='Y'
				   AND  M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE A.FROM_SITE END
				WHERE A.PLAN_START_YYYYMMDD =  ( SELECT MAX(PLAN_START_YYYYMMDD) 
												 FROM SSP_ANL_SHIP_PLAN_C 
												 WHERE COMPANY_ID = A.COMPANY_ID
												 AND   DIVISION_ID IN (SELECT DIVISION_ID
                                                                         FROM SCM_MST_DIVISION WITH(NOLOCK)
                                                                        WHERE VALID_YN = 'Y'
                                                                          AND ATTRIBUTE3 IN ('81','82')
																	  ) 
											   ) 
				AND   A.MEASURE ='SHIP_REQ'
				AND   A.CONFIRM_FLAG  = 'D' -- CONFIRM 되지 않은 대상
				AND   A.DIVISION_ID IN (SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION WITH(NOLOCK)
                                         WHERE VALID_YN = 'Y'
                                           AND ATTRIBUTE3 IN ('81','82')
									   )  
				UNION ALL 
                -- LOOKUP등록자 (TYPE : SCP 대상 : 법인간 거래 )  
				SELECT A.DIVISION_ID
                ,      A.COMPANY_ID 
				,      A.PLAN_START_YYYYMMDD
				,      M.SEGMENT2    AS MAIL_RECEIVER
				,      A.FROM_SITE
				,      A.ITEM_ID 
				,      A.TO_SITE
				FROM  SSP_ANL_SHIP_PLAN_C A WITH(NOLOCK) 
				  JOIN SCM_MST_SITE S WITH(NOLOCK) 
					ON S.DIVISION_ID = A.DIVISION_ID 
				   AND S.SCM_SITE_ID = A.TO_SITE 
				   AND S.SITE_TYPE = 'PLANT'
				   AND S.OSP_YN = 'N'
				  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)  
					ON  M.LOOKUP_TYPE ='SHIP_REQ_DEL_MAIL_SEND'
				   AND  M.SEGMENT1    = 'SCP'
				   AND  M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE A.FROM_SITE END
				WHERE A.PLAN_START_YYYYMMDD =  ( SELECT MAX(PLAN_START_YYYYMMDD) 
												 FROM SSP_ANL_SHIP_PLAN_C 
												 WHERE COMPANY_ID = A.COMPANY_ID 
												 AND   DIVISION_ID IN (SELECT DIVISION_ID
                                                                         FROM SCM_MST_DIVISION WITH(NOLOCK)
                                                                        WHERE VALID_YN = 'Y'
                                                                          AND ATTRIBUTE3 IN ('81','82')
																	  ) 
												 ) 
				AND   A.MEASURE ='SHIP_REQ'
				AND   A.CONFIRM_FLAG  = 'D' -- CONFIRM 되지 않은 대상 
				AND   A.DIVISION_ID IN (SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION WITH(NOLOCK)
                                         WHERE VALID_YN = 'Y'
                                           AND ATTRIBUTE3 IN ('81','82')
									   )  
				UNION ALL 

                -- 출하요청자 REQUESTOR  
				SELECT A.DIVISION_ID
                ,      A.COMPANY_ID 
				,      A.PLAN_START_YYYYMMDD
				,      A.REQUESTOR   AS MAIL_RECEIVER
				,      A.FROM_SITE
				,      A.ITEM_ID 
				,      A.TO_SITE
				FROM  SSP_ANL_SHIP_PLAN_C A WITH(NOLOCK) 
				WHERE A.PLAN_START_YYYYMMDD =  ( SELECT MAX(PLAN_START_YYYYMMDD) 
												 FROM SSP_ANL_SHIP_PLAN_C 
												 WHERE COMPANY_ID = A.COMPANY_ID
												 AND   DIVISION_ID IN (SELECT DIVISION_ID
                                                                         FROM SCM_MST_DIVISION WITH(NOLOCK)
                                                                        WHERE VALID_YN = 'Y'
                                                                          AND ATTRIBUTE3 IN ('81','82')
																	  ) 
												 ) 
				AND   A.MEASURE ='SHIP_REQ'
				AND   A.CONFIRM_FLAG  = 'D' -- CONFIRM 되지 않은 대상
				AND   A.DIVISION_ID IN (SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION WITH(NOLOCK)
                                         WHERE VALID_YN = 'Y'
                                           AND ATTRIBUTE3 IN ('81','82')
									   )  
--/*
				UNION ALL 
                -- MKT_OWNER 
				SELECT A.DIVISION_ID
                ,      A.COMPANY_ID 
				,      A.PLAN_START_YYYYMMDD
				,      U.MKT_USER     AS MAIL_RECEIVER
				,      A.FROM_SITE
				,      A.ITEM_ID 
				,      A.TO_SITE
				FROM  SSP_ANL_SHIP_PLAN_C A WITH(NOLOCK) 
					JOIN SSP_MKT_USER_V U WITH(NOLOCK) 
					ON U.DIVISION_ID    = A.DIVISION_ID  
					AND U.TO_SITE       = A.TO_SITE 
					AND U.ITEM_ID       = A.ITEM_ID 
					AND U.PROJECT_CODE  = A.PROJECT_CODE
				WHERE A.PLAN_START_YYYYMMDD =  ( SELECT MAX(PLAN_START_YYYYMMDD) 
												 FROM SSP_ANL_SHIP_PLAN_C 
												 WHERE COMPANY_ID = A.COMPANY_ID
												 AND   DIVISION_ID IN (SELECT DIVISION_ID
                                                                         FROM SCM_MST_DIVISION WITH(NOLOCK)
                                                                        WHERE VALID_YN = 'Y'
                                                                          AND ATTRIBUTE3 IN ('81','82')
																	  ) 
												 ) 
				AND   A.MEASURE ='SHIP_REQ'
				AND   A.CONFIRM_FLAG  = 'D' -- CONFIRM 되지 않은 대상
				AND   A.DIVISION_ID IN (SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION WITH(NOLOCK)
                                         WHERE VALID_YN = 'Y'
                                           AND ATTRIBUTE3 IN ('81','82')
									   )  
--*/

) X
GROUP BY  X.DIVISION_ID 
,      X.COMPANY_ID
,      X.PLAN_START_YYYYMMDD
,      X.MAIL_RECEIVER
,      X.FROM_SITE
,      X.ITEM_ID  
,      X.TO_SITE 
   ) 

SELECT V.MAIL_RECEIVER
,      R.COMPANY_ID  
,      R.DIVISION_ID
,      R.FROM_SITE
,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( R.DIVISION_ID , R.FROM_SITE ) AS FROM_SITE_DESCRIPTION 
,      R.ITEM_ID
,      [DBO].[FN_GET_ITEM_NICKNAME](R.DIVISION_ID,R.ITEM_ID)  AS NICK_NAME
,      U.USERNAME + '('+R.REQUESTOR +')'  AS REQUESTOR 
,      R.TO_SITE 
,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( R.DIVISION_ID , R.TO_SITE ) AS TO_SITE_DESCRIPTION 
,      TS.END_CUSTOMER           AS END_CUSTOMER 
,      R.FCST_TYPE
,      R.INCOTERMS
,      R.TRANSPORT_MODE
,      R.YYYYMMDD 
,      R.QTY 
FROM SSP_ANL_SHIP_PLAN_C R WITH(NOLOCK) 
     JOIN MAIL_RECEIVER V  WITH(NOLOCK)
	   ON V.DIVISION_ID = R.DIVISION_ID
	  AND V.PLAN_START_YYYYMMDD = R.PLAN_START_YYYYMMDD
      AND V.COMPANY_ID  = R.COMPANY_ID 
	  AND V.FROM_SITE = R.FROM_SITE
	  AND V.ITEM_ID   = R.ITEM_ID  
	  AND   R.MEASURE ='SHIP_REQ'
	  AND   R.CONFIRM_FLAG  = 'D' -- CONFIRM 되지 않은 대상 
     JOIN SCM_MST_SITE TS WITH(NOLOCK) 
	   ON TS.DIVISION_ID = R.DIVISION_ID 
	  AND TS.SCM_SITE_ID = R.TO_SITE 
    LEFT OUTER JOIN TB_FX_USER U WITH(NOLOCK) 
	  ON U.USERID = R.REQUESTOR   

WHERE R.MEASURE ='SHIP_REQ'
AND   R.CONFIRM_FLAG  = 'D' -- CONFIRM 되지 않은 대상 
AND   R.DIVISION_ID IN (SELECT DIVISION_ID
                          FROM SCM_MST_DIVISION WITH(NOLOCK)
                         WHERE VALID_YN = 'Y'
                           AND ATTRIBUTE3 IN ('81','82')
					   )  

