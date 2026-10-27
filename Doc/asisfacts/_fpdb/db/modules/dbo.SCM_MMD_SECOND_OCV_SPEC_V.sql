
CREATE VIEW [dbo].[SCM_MMD_SECOND_OCV_SPEC_V]
-- ================================================================================================
-- Program ID          : SCM_MMD_SECOND_OCV_SPEC_V
--
-- Program Name        : SCM_MMD_SECOND_OCV_SPEC_V
-- Param               :
-- Batch Period        : 
-- Description         : 2nd OCV 검사 Lead Time 조회용 View
--                       1차 완성 후 검사대기와 2,3차 검사 대기 정보 구분하여 조회
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_MMD_SECOND_OCV_SPEC_M, SCM_MMD_SECOND_OCV_PRE_M
-- Destination Table   : 
--
-- Create(Update) Date : 2021.10.25
-- Author              : kimcd
-- Version             : 2021-10-25  kimcd	신규 생성
-- ================================================================================================
AS
SELECT FACTORY_ID,
       ITEM_ID,
	   RUN_TIME,
	   MAX(KEEP_DAYS) 
	   + ISNULL( ( SELECT TOP 1 ROUND(P.KEEP_MINUTES/1440.0,0)
				   FROM   [SCM_MMD_SECOND_OCV_PRE_M] P
				   WHERE  P.ITEM_ID = S.ITEM_ID
				   AND    S.RUN_TIME = 1
				   AND    P.ACTIVE_FLAG = 'Y'
				   ORDER BY UPDATE_TIME DESC), 0) KEEP_DAYS
FROM  [SCM_MMD_SECOND_OCV_SPEC_M] S
GROUP BY FACTORY_ID,
         ITEM_ID,
	     RUN_TIME
