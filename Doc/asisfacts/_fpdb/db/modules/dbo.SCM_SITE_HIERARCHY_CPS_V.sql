
CREATE VIEW [dbo].[SCM_SITE_HIERARCHY_CPS_V]
-- ================================================================================================
-- Program ID          : SCM_SITE_HIERARCHY_CPS_V
--
-- Program Name        : SCM_SITE_HIERARCHY_CPS_V
-- Param               :
-- Batch Period        : 
-- Description         : 기준 정보 Data 조회 Hierarchy 정보
--
-- Source System       : FP SDB
-- Destination System  : GSCM SDB
-- Source Table        : SCM_LINE_M, SCM_PLANT_M, SCM_FACTORY_M, SCM_OPERATION_M, SCM_SYS_LOOKUP_VALUE
-- Destination Table   : 
--
-- Create(Update) Date : 2020.09.10
-- Author              : choikjthira
-- Version             : 2020.09.10	choikjthira 신규 생성
-- ================================================================================================
AS
SELECT 	DISTINCT 
		A.COMPANY_ID,
		H.COMPANY_NAME,
		A.DIVISION_ID, 
		B.ATTRIBUTE1 AS DIVISION_NAME, 
		A.SITE_ID,
		I.SITE_NAME,
		CASE WHEN A.OPERATION_ID LIKE 'P%' THEN 'P' ELSE E.OPERATION_GROUP_ID END AS SHOP_GROUP_ID, 		
		F.SEGMENT2 AS OPERATION_GROUP,		
		A.PLANT_ID, 
		C.PLANT_NAME 
FROM 	SCM_LINE_M A
		, SCM_SYS_LOOKUP_VALUE B
		, SCM_COMPANY_M H
		, SCM_SITE_M I
		, SCM_PLANT_M C
		, SCM_OPERATION_M E
		, SCM_SYS_LOOKUP_VALUE F
		--, (SELECT 	COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID
		--	FROM 	FP_INSTANCE_OPERATION_V
		--	GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID) G
WHERE 	1=1
AND 	A.ACTIVE_FLAG = 'Y'
AND 	B.LOOKUP_TYPE_CODE = 'DIVISION_NAME'
AND 	A.DIVISION_ID = B.SEGMENT1
AND 	A.PLANT_ID = C.PLANT_ID
AND 	A.COMPANY_ID = E.COMPANY_ID
AND 	A.COMPANY_ID = H.COMPANY_ID
AND 	A.DIVISION_ID = E.DIVISION_ID
AND 	A.SITE_ID = E.SITE_ID
AND 	A.SITE_ID = I.SITE_ID
AND 	A.OPERATION_ID = E.OPERATION_ID
AND 	E.ACTIVE_FLAG = 'Y'
AND 	F.LOOKUP_TYPE_CODE = 'SHOP_GROUP_ID'
AND 	E.OPERATION_GROUP_ID = F.SEGMENT1
--AND 	A.DIVISION_ID = G.DIVISION_ID
--AND 	A.COMPANY_ID = G.COMPANY_ID
--AND 	A.SITE_ID = G.SITE_ID
--AND 	A.OPERATION_ID = G.OPERATION_ID
