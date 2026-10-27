CREATE VIEW [dbo].[SCM_LINE_LOSS_V]
-- ================================================================================================
-- Program ID          : SCM_LINE_LOSS_V
--
-- Program Name        : SCM_LINE_LOSS_V
-- Param               :
-- Batch Period        : 
-- Description         : Line 별 FP 사용 Loss 합 View
--                       조회 일 기준 M-1 ~ M+3개월 
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_LOSS_M, SCM_SYS_LOOKUP_VALUE
-- Destination Table   : 
--
-- Create(Update) Date : 2021.04.26
-- Author              : CGJ
-- Version             : 2021-04-26  CGJ	신규 생성
-- ================================================================================================
AS
SELECT 	  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
		, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
		, A.WORK_MONTH AS [MONTH]
--		, 1-ROUND(EXP(SUM(ROUND(LOG(1-ISNULL(A.LOSS_RATE,0)),10))),4) AS LOSS_RATE
		, ROUND(SUM(ISNULL(A.LOSS_RATE,0)),4) AS LOSS_RATE
		, NULL AS ATTB_1
		, NULL AS ATTB_2
		, NULL AS ATTB_3
		, NULL AS ATTB_4
		, NULL AS ATTB_5
		, NULL AS DESCRIPTION
FROM 	SCM_LOSS_M A,
		(		
		SELECT 	SEGMENT1 AS LOSS_CODE
		FROM 	SCM_SYS_LOOKUP_VALUE 
		WHERE 	1=1
		AND 	LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
		AND 	ATTRIBUTE5 = 'Y'
		)	 B
WHERE 	1=1
AND 	A.LOSS_CODE = B.LOSS_CODE
AND     WORK_MONTH >= CONVERT(CHAR(6), DATEADD(MM, -1, GETDATE()), 112)
AND     WORK_MONTH <= CONVERT(CHAR(6), DATEADD(MM, 3, GETDATE()), 112)
GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.WORK_MONTH
