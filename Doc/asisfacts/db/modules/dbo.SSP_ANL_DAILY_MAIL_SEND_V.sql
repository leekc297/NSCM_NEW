







CREATE VIEW [dbo].[SSP_ANL_DAILY_MAIL_SEND_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_ANL_DAILY_MAIL_SEND_V]
* DESCRIPTION   : D-4일 BALANCE 음수 경우 메일 대상자 및 대상 아이템 추출 
   -  대상 : 오창 자동차 공장출하분 ( division 81 , from site : A040-P, A040-A ) 
             현재일 기준 D+4 (PLAN_START_YYYYMMDD +4 ) 출하 Confirm 수량이 있으면서 BALANCE가 음수인 경우 
     ex)  현재일 : 2018-07-24일 경우 2018-07-27의의 출하 확정수량 이 0보다 크고 BALANCE가 음수인 ITEM 대상             
   -  메일링 일시 : Daily 08시 
   -  메일수신자 : 
      . MKT 담당자  : ITEM/Project 의 오너 (SCM_MST_SITE_ITEM.OWNER) 
      . 생산 담당자 : Pack  황현규 선임( hwanghg)  --> from site가 A040-P 
                      Cell  이재범 책임(laebumlee) --> from site가 A040-A
      . 물류 담당자 : 최예린 사원(chldpfls) , 한유미(ymhan) , 유정아(dhwmak)
	  . PI담당자    : 지준혁 선임(bondi)                   
* PROGRAM HISTORY
*-------------------------------------------------------------------------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*-------------------------------------------------------------------------------------------------------------------------------
* 2018.09.19   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
*                         최초 OPEN시에는 PI 및 프로젝트 담당자에게만 메일 발송    
* 2018.10.04   juhlee	  물류담당자 추가 - 최예린 사원(chldpfls) , 한유미(ymhan) , 유정아(dhwmak) 
* 2019.01.28   juhlee     [C20190123_05453]메일수신자를 LOOKUP정도 등록하여 발송하게 변경( LOOKUP_TYPE ='WARNING_MAIL_SEND')     
* 2019.04.09   juhlee	  [PJ20189106] 전지.GSCM 고도화 이행- 소형 추가                 
********************************************************************************************************************************/
-- 대상 ITEM  
SELECT M.SEGMENT1             AS TYPE
,      M.SEGMENT2             AS MAIL_RECEIVER
,      A.DIVISION_ID          AS DIVISION_ID
,      A.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
,      A.FROM_SITE            AS FROM_SITE 
,      A.ITEM_ID              AS ITEM_ID
,      A.YYYYMMDD             AS YYYYMMDD
FROM  SSP_ANL_SHIP_PLAN A WITH(NOLOCK) 
	  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)  
		ON  M.LOOKUP_TYPE ='WARNING_MAIL_SEND'
	   AND  M.VALID_YN    ='Y'
	   AND  M.SEGMENT3    = CASE WHEN M.SEGMENT3 = 'ALL' THEN 'ALL' ELSE A.FROM_SITE END

WHERE A.PLAN_START_YYYYMMDD =  ( SELECT MAX(PLAN_START_YYYYMMDD) FROM SSP_PLAN_VERSION_V WHERE DIVISION_ID = '81' ) 
AND   A.DIVISION_ID = '81'
AND   A.PLAN_TYPE = 'SP'
AND   A.YYYYMMDD = DBO.FN_DATE_TO_CHAR ( DBO.FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD) + 4 )  
--AND   A.FROM_SITE IN ( 'A040-P' ,'A040-A')
AND   A.MEASURE IN ( 'SHIP_CONFIRM' ,'BALANCE') 
GROUP BY M.SEGMENT1, M.SEGMENT2, A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.FROM_SITE, A.ITEM_ID, A.YYYYMMDD
HAVING SUM(CASE WHEN A.MEASURE = 'BALANCE'      THEN A.QTY ELSE 0 END ) < 0 
   AND SUM(CASE WHEN A.MEASURE = 'SHIP_CONFIRM' THEN A.QTY ELSE 0 END ) > 0

 
/* 
UNION ALL  
-- 소형의 경우 해당 모델 담당자에게 메일 발송 (Shipment Model PIC 화면에서 등록) 
SELECT 'MODEL_PIC'            AS TYPE
,      U.USER_ID              AS MAIL_RECEIVER
,      A.DIVISION_ID          AS DIVISION_ID
,      A.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
,      A.FROM_SITE            AS FROM_SITE 
,      A.ITEM_ID              AS ITEM_ID
,      A.YYYYMMDD             AS YYYYMMDD
FROM  SSP_ANL_SHIP_PLAN_40 A WITH(NOLOCK) -- 소형 
      JOIN SSP_MST_MODEL_USER U WITH(NOLOCK) 
        ON U.DIVISION_ID = A.DIVISION_ID 
	   AND U.FROM_SITE   = A.FROM_SITE
	   AND U.ITEM_ID     = A.ITEM_ID 
WHERE A.PLAN_START_YYYYMMDD =  ( SELECT MAX(PLAN_START_YYYYMMDD) FROM SSP_PLAN_VERSION_V WHERE DIVISION_ID = '40' ) 
AND   A.DIVISION_ID = '40'
AND   A.PLAN_TYPE   = 'SP'
AND   A.YYYYMMDD = DBO.FN_DATE_TO_CHAR ( DBO.FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD) + 4 )  
AND   A.MEASURE IN ( 'SHIP_CONFIRM' ,'BALANCE') 
GROUP BY U.FROM_SITE, U.USER_ID, A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.FROM_SITE, A.ITEM_ID, A.YYYYMMDD
HAVING SUM(CASE WHEN A.MEASURE = 'BALANCE'      THEN A.QTY ELSE 0 END ) < 0 
   AND SUM(CASE WHEN A.MEASURE = 'SHIP_CONFIRM' THEN A.QTY ELSE 0 END ) > 0


-----------------------------------------------------------------------------------------------


UNION ALL 
-- 대상 ITEM 추출 MKT -- mkt 담당자는 ITEM별로 정해져 있어 LOOKUP 사용 안됨 
SELECT 'MKT'                  AS TYPE
,      X.MAIL_RECEIVER        AS MAIL_RECEIVER
,      X.DIVISION_ID          AS DIVISION_ID
,      X.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
,      X.FROM_SITE            AS FROM_SITE
,      X.ITEM_ID              AS ITEM_ID
,      X.YYYYMMDD             AS YYYYMMDD
FROM ( 
		SELECT 
			   U.MKT_USER             AS MAIL_RECEIVER
		,      P.DIVISION_ID          AS DIVISION_ID
		,      P.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
		,      P.FROM_SITE            AS FROM_SITE 
		,      P.ITEM_ID              AS ITEM_ID
		,      P.YYYYMMDD             AS YYYYMMDD
		FROM SSP_ANL_SHIP_PLAN P  WITH(NOLOCK)  
		JOIN (
				SELECT A.DIVISION_ID
				,      A.FROM_SITE  
				,      A.ITEM_ID 
				,      A.YYYYMMDD
				,      MAX(A.PROJECT_CODE) PROJECT_CODE
				FROM  SSP_ANL_SHIP_PLAN A WITH(NOLOCK) 
				WHERE A.PLAN_START_YYYYMMDD = ( SELECT MAX(PLAN_START_YYYYMMDD) FROM SSP_PLAN_VERSION_V WHERE DIVISION_ID = '81' ) 
				AND   A.DIVISION_ID = '81'
				AND   A.PLAN_TYPE   = 'SP'
				AND   A.YYYYMMDD = DBO.FN_DATE_TO_CHAR ( DBO.FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD) + 4 )  -- D+4
				AND   A.FROM_SITE IN ( 'A040-P' ,'A040-A')
				AND   A.MEASURE IN ( 'SHIP_CONFIRM' ,'BALANCE') 
				GROUP BY A.DIVISION_ID , A.FROM_SITE , A.ITEM_ID , A.YYYYMMDD
				HAVING SUM(CASE WHEN A.MEASURE = 'BALANCE'      THEN A.QTY ELSE 0 END ) < 0 
				   AND SUM(CASE WHEN A.MEASURE = 'SHIP_CONFIRM' THEN A.QTY ELSE 0 END ) > 0
			) B
			ON P.DIVISION_ID = B.DIVISION_ID AND  P.ITEM_ID = B.ITEM_ID 
		JOIN SSP_MKT_USER_V U
		  ON U.DIVISION_ID   = CASE WHEN P.DIVISION_ID = 'EE' THEN P.ORIGIN_FROM_DIVISION_ID ELSE P.DIVISION_ID END 
		 AND U.TO_SITE       = P.TO_SITE 
		 AND U.ITEM_ID       = P.ITEM_ID 
		 AND U.PROJECT_CODE  = P.PROJECT_CODE 
		WHERE P.DIVISION_ID = '81'
		AND   P.PLAN_TYPE   ='SP'
		AND   P.PLAN_START_YYYYMMDD = ( SELECT MAX(PLAN_START_YYYYMMDD) FROM SSP_PLAN_VERSION_V WHERE DIVISION_ID = '81' ) 
		AND   P.DIVISION_ID = B.DIVISION_ID
		AND   P.FROM_SITE   = B.FROM_SITE 
		AND   P.ITEM_ID     = B.ITEM_ID 
		AND   P.YYYYMMDD    = B.YYYYMMDD 
		AND   P.MEASURE     = 'SHIP_CONFIRM'
		AND   P.QTY > 0 
		GROUP BY U.MKT_USER, P.DIVISION_ID ,P.PLAN_START_YYYYMMDD ,P.FROM_SITE , P.ITEM_ID , P.YYYYMMDD  
		) X
*/







