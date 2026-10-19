

CREATE VIEW [dbo].[SSP_ANL_WH_STOCK_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_ANL_WH_SOTCK_V]
* DESCRIPTION   : SSP0015 BOH Total : OWMS available qty +  B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE      IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2019.05.16   juhlee     Initial Release [PJ20189106] 전지.GSCM 고도화 이행 

********************************************************************************************************************************/

SELECT  X.DIVISION_ID 
,        X.PLAN_START_YYYYMMDD
,        X.PLAN_TYPE 
,        X.SEQ
,        X.ITEM_ID 
,        X.FROM_SITE
,        SUM(X.QTY)  AS QTY 
FROM  
	(
		--OWMS 재고 
		SELECT O.DIVISION_ID  	        AS DIVISION_ID   
		,	   O.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
		,      O.PLAN_TYPE	            AS PLAN_TYPE
		,      O.SEQ 	                AS SEQ
		,      O.ITEM_ID	            AS ITEM_ID   
		,      O.FROM_SITE              AS FROM_SITE 
		,      ROUND(SUM(O.AVAILABLE_QTY) ,0) AS QTY 
		,      'OWMS'                    AS TYPE 
		FROM   SSP_ANL_OWMS_STOCK_C O WITH(NOLOCK)  
		GROUP BY 
				O.DIVISION_ID 
		,     O.PLAN_START_YYYYMMDD
		,     O.PLAN_TYPE
		,     O.SEQ
		,     O.ITEM_ID
		,     O.FROM_SITE  

	UNION ALL 
		--STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) FROM SCM_DNM_STOCK_V
		SELECT T.DIVISION_ID  	        AS DIVISION_ID   
		,	   T.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
		,      T.PLAN_TYPE	            AS PLAN_TYPE
		,      T.SEQ 	                AS SEQ
		,      T.ITEM_ID	            AS ITEM_ID   
		,      T.SCM_SITE_ID            AS FROM_SITE  
		,      ROUND(SUM(T.QTY),0) AS  QTY	  
		,      'TCO'                    AS TYPE 
		FROM   SSP_ANL_TCO_STOCK_C T WITH(NOLOCK)  
		GROUP BY 
				T.DIVISION_ID 
		,     T.PLAN_START_YYYYMMDD
		,     T.PLAN_TYPE
		,     T.SEQ
		,     T.ITEM_ID
		,     T.SCM_SITE_ID
	) X
GROUP BY X.DIVISION_ID 
,        X.PLAN_START_YYYYMMDD
,        X.PLAN_TYPE 
,        X.SEQ
,        X.ITEM_ID 
,        X.FROM_SITE


