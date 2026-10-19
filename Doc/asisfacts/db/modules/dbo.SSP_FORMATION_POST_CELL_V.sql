


CREATE VIEW [dbo].[SSP_FORMATION_POST_CELL_V] AS
/*
 * Program ID   : SCM_FORMATION_POST_CELL_V
 * Description  : 활성화 후 공정에서 필요로 하는 Bare Cell 일자별 소요량 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.05. 15  juhlee    Initial Release [PJ20189106] 전지.GSCM 고도화 이행 
 * 2019.12.27   juhlee    속도감소로 인행 SCM_SITE_ID 변경 전부 CELL이므로 A로 고정
 
 */
SELECT 
 COMPANY_ID
,DIVISION_ID
,SITE_ID
,PLANT_ID
,FACTORY_ID
,OPERATION_ID
--,DBO.FN_GET_SCM_SITE_ID_PLANT(PLANT_ID, DBO.FN_GET_ITEM_OPERATION_GROUP(DIVISION_ID, RTRIM(LTRIM(CELL_ITEM_ID)))) AS SCM_SITE_ID
,PLANT_ID+'-A' AS SCM_SITE_ID
,ITEM_ID
,LINE_ID
,CONVERT(VARCHAR, PLAN_DATE,112)   AS PLAN_DATE 
,PLAN_QTY
,PLAN_IN_QTY
,CELL_ITEM_ID
,CELL_REQ_QTY
FROM SCM_FORMATION_POST_CELL_V_SN 

