

CREATE VIEW [dbo].[TH_MST_STOCK_PLAN_V] AS
/*================================================================================================*/
-- VIEW NAME : TH_MST_STOCK_PLAN_V
-- 목적      : CELL SIMULATION 에서 Remained Activated Cell의 계산에 사용할 AGING STOCK값을 가져오기 위함.
-- 생성일    : 2020-04-09 
/*================================================================================================*/
SELECT	*
FROM	(
		--SELECT  *  
		--FROM	PL_FORM_A.DBO.TH_MST_STOCK_PLAN A  
		--UNION ALL 
		--SELECT  *  
		--FROM	US_FORM_A.DBO.TH_MST_STOCK_PLAN A  
		--UNION ALL 
		--SELECT  *  
		--FROM	KR_FORM_A.DBO.TH_MST_STOCK_PLAN A 
		--UNION ALL 
		--SELECT  *  
		--FROM	CN_FORM_E.DBO.TH_MST_STOCK_PLAN A   
		SELECT  *  
		FROM	KR_FORM_DEV.DBO.TH_MST_STOCK_PLAN A  
		) A
WHERE	1=1
