CREATE VIEW [dbo].[SCM_OFF_CALENDAR_LINE_V]
-- ================================================================================================
-- Program ID          : SCM_OFF_CALENDAR_LINE_V
--
-- Program Name        : SCM_OFF_CALENDAR_LINE_V
-- Param               :
-- Batch Period        : 
-- Description         : Line 별 FP 사용 OFF TIME 합 View
--                       조회 일 기준 M-1 ~ M+3개월 
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_WORK_CALENDAR_M, SCM_SYS_LOOKUP_VALUE
-- Destination Table   : 
--
-- Create(Update) Date : 2021.03.09
-- Author              : CGJ
-- Version             : 2021-05-16  CGJ	신규 생성
-- ================================================================================================
AS
SELECT 	  COMPANY_ID
		, DIVISION_ID
		, SITE_ID
		, PLANT_ID
		, FACTORY_ID
		, OPERATION_ID
		, LINE_ID
		, ELECTRODE_TYPE
		, WORK_DATE AS OFF_DATE
		, CASE WHEN SUM(TIME_TERM) > 1440 THEN 1440 ELSE SUM(TIME_TERM) END AS  OFF_TIME_TERM
		, 'MINUTE' AS OFF_TIME_UOM
		, NULL AS DESCRIPTION			
		, MAX(INSERT_TIME) AS INSERT_TIME 
		, MAX(UPDATE_TIME) AS UPDATE_TIME 
--SELECT 	*		
FROM 	SCM_WORK_CALENDAR_M WITH(NOLOCK)
WHERE 	1=1
AND 	WORK_DATE >= DATEADD(MM,-1,GETDATE())
AND 	WORK_DATE <= DATEADD(MM,4,GETDATE())
AND 	LOSS_CODE IN (SELECT 	SEGMENT1
						FROM 	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
					   WHERE 	1=1
						 AND 	LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
						 AND 	ATTRIBUTE3 = 'SCM_WORK_CALENDAR_M'
						 AND 	ATTRIBUTE4 = 'Y')
GROUP BY COMPANY_ID
		, DIVISION_ID
		, SITE_ID
		, PLANT_ID
		, FACTORY_ID
		, OPERATION_ID
		, LINE_ID
		, ELECTRODE_TYPE
		, WORK_DATE
