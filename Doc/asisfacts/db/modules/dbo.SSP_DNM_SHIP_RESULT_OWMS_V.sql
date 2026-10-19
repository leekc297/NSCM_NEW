



CREATE VIEW [dbo].[SSP_DNM_SHIP_RESULT_OWMS_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_DNM_SHIP_RESULT_OWMS_V]
* DESCRIPTION   : OWMS 출하실저, 반품실적 
               
* PROGRAM HISTORY
*-------------------------------------------------------------------------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*-------------------------------------------------------------------------------------------------------------------------------
* 2019.12.04   juhlee     [C20191205-000132] OWMS 출하실적, 반품실적 
* 2020.02.11   KIMYONGHO  [C20200218-000135] SHIP_TYPE 컬럼 추가
********************************************************************************************************************************/
SELECT X.DIVISION_ID 
,      X.ITEM_ID 
,      X.FROM_SITE
,      X.TO_SITE 
,      X.QTY 
,      X.YYYYMMDD
,	   X.SHIP_TYPE
FROM (
		SELECT A.DIVISION_ID       AS DIVISION_ID 
		,      A.ITEM_ID           AS ITEM_ID 
		,      A.FROM_SITE         AS FROM_SITE
		,      CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE  A.TO_SITE END          AS TO_SITE
		,      SUM(A.LOT_QTY)            AS QTY 
		,      A.PLANT_ISSUE_DATE  AS YYYYMMDD
		,	   A.SHIP_TYPE AS SHIP_TYPE
		FROM SSP_DNM_SHIP_RESULT_OWMS A WITH(NOLOCK) 
		GROUP BY A.DIVISION_ID        
		,        A.ITEM_ID      
		,        A.FROM_SITE   
		,        CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE  END  
		,        A.PLANT_ISSUE_DATE  
		,		 A.SHIP_TYPE
		UNION ALL 
		SELECT B.DIVISION_ID      AS DIVISION_ID 
		,      B.ITEM_ID          AS ITEM_ID 
		,      B.FROM_SITE        AS FROM_SITE
		,      '*'                AS TO_SITE 
		,      SUM(B.RECIEPT_QTY)* -1      AS QTY 
		,      B.RECIEPT_DATE     AS YYYYMMDD 
		,	   NULL AS SHIP_TYPE
		FROM SSP_DNM_SHIP_RETURN_OWMS B WITH(NOLOCK) 
		GROUP BY B.DIVISION_ID        
		,        B.ITEM_ID      
		,        B.FROM_SITE   
		,        B.RECIEPT_DATE 
		) X
 JOIN SCP_MST_FINAL_ITEM V WITH(NOLOCK) 
   ON V.DIVISION_ID = X.DIVISION_ID 
  AND V.ITEM_ID = X.ITEM_ID 

