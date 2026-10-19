



CREATE VIEW [dbo].[SSP_KPI_SHIP_RESULT_OWMS_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_DNM_SHIP_RESULT_OWMS_V]
* DESCRIPTION   : OWMS 출하실저, 반품실적 
               
* PROGRAM HISTORY
*-------------------------------------------------------------------------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*-------------------------------------------------------------------------------------------------------------------------------
* 2020.01.20   juhlee     DW 제공을 위한 OWMS 실적 VIEW 
            
********************************************************************************************************************************/

SELECT FS.COMPANY_ID
,      FS.PLANT_ID
,      X.DIVISION_ID 
,      FS.OPERATION_GROUP 
,      X.FROM_SITE
,      ISNULL(X.TO_SITE ,'-')          AS TO_SITE 
,      ISNULL(X.CUSTOMER_CODE,'-')     AS CUSTOMER_CODE 
,      X.ITEM_ID 
,      X.YYYYMMDD 
,      X.QTY 
,      ISNULL(B.ACCUMULATED_CHILD_QTY,1) * X.QTY AS QTY_TO_CELL
FROM (
		SELECT A.DIVISION_ID       AS DIVISION_ID 
		,      A.FROM_SITE         AS FROM_SITE
		,      A.TO_SITE     AS TO_SITE
--		,      CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE  A.TO_SITE END          AS TO_SITE
		,      A.CUSTOMER_CODE     AS CUSTOMER_CODE 
		,      A.ITEM_ID           AS ITEM_ID 
		,      A.PLANT_ISSUE_DATE  AS YYYYMMDD
		,      SUM(A.LOT_QTY)       AS QTY 
		FROM SSP_DNM_SHIP_RESULT_OWMS A WITH(NOLOCK) 
		GROUP BY A.DIVISION_ID        
		,        A.ITEM_ID      
		,        A.FROM_SITE   
		,        A.TO_SITE 
		--,        CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE  END  
		,        A.PLANT_ISSUE_DATE 
		,        A.CUSTOMER_CODE 
		UNION ALL 
		SELECT B.DIVISION_ID      AS DIVISION_ID 
		,      B.FROM_SITE        AS FROM_SITE
		,      '-'                AS TO_SITE 
		,      '-'                AS CUSTOMER_CODE 
		,      B.ITEM_ID          AS ITEM_ID 
		,      B.RECIEPT_DATE     AS YYYYMMDD 
		,      SUM(B.RECIEPT_QTY)* -1      AS QTY 
		FROM SSP_DNM_SHIP_RETURN_OWMS B WITH(NOLOCK) 
		GROUP BY B.DIVISION_ID        
		,        B.ITEM_ID      
		,        B.FROM_SITE   
		,        B.RECIEPT_DATE 
		) X
 JOIN SCP_MST_FINAL_ITEM V WITH(NOLOCK) 
   ON V.DIVISION_ID = X.DIVISION_ID 
  AND V.ITEM_ID = X.ITEM_ID 

 JOIN SCM_MST_SITE FS WITH(NOLOCK) 
   ON FS.DIVISION_ID = X.DIVISION_ID 
  AND FS.SCM_SITE_ID = X.FROM_SITE 
  AND FS.SITE_TYPE   = 'PLANT'
  AND FS.OSP_YN      = 'N'

	JOIN SCM_MST_SITE TS WITH(NOLOCK) 
	ON TS.DIVISION_ID = X.DIVISION_ID 
	AND TS.SCM_SITE_ID = X.TO_SITE 
	AND TS.SITE_TYPE   = 'SALES'

LEFT OUTER JOIN  SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) 
ON  B.DIVISION_ID = X.DIVISION_ID 
AND B.MODEL_ID    = X.ITEM_ID
AND B.OPERATION_GROUP_ID = 'A'
AND B.PLANT_ID = FS.PLANT_ID 
AND B.TCO_CELL_YN = 'N' 


