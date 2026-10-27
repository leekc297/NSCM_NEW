








CREATE VIEW [dbo].[FP_SIMULATION_PLAN_CELL_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_PLAN_CELL_V
--
-- Program Name        : FP_SIMULATION_PLAN_CELL_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_FP_PLAN_H, TH_UIS_USER_FACTORY_RELATE, TH_UIS_ROLE_FACTORY_RELATE
-- Destination Table   : 
--
-- Create(Update) Date : 2019.11.05
-- Author              : PIYONG
-- Version             : 2019-07-31 PIYONG 신규 생성
--                       2019-08-30 kimcd  Plant별 시업시간 반영 - 시업 시간 이전이면 전일로 조회
--                       2019-11-05 kimcd  PLAN_START_YYYYMMDD 계획 시작 일 추가
-- ================================================================================================
AS 
	SELECT H.INSTANCE_ID + ''  AS INSTANCE_ID
		   , H.PLAN_ID
		   , H.CONFIRM_FLAG
		   , CONVERT(NVARCHAR, MAX(H.PLAN_START_TIME), 112) AS PLAN_START_YYYYMMDD  -- 2019-11-05 kimcd  PLAN_START_YYYYMMDD 계획 시작 일 추가
	  FROM SCM_FP_PLAN_H H WITH(NOLOCK)
		   , (
				SELECT INSTANCE_ID, MAX(F.PLANT_ID) AS PLANT_ID -- 2019-08-30 kimcd PLANT_ID 추가
				      ,MAX(DBO.FN_SITE_TIME(F.SITE_ID)) AS LOCAL_DATE -- 2019-08-30 kimcd 추가
				  FROM FP_INSTANCE_FACTORY_M I WITH(NOLOCK)
				     , SCM_FACTORY_M         F WITH(NOLOCK)
				 WHERE I.FACTORY_ID = F.FACTORY_ID
				   AND I.ACTIVE_FLAG = 'Y'
				   AND F.ACTIVE_FLAG = 'Y'
				   AND I.INSTANCE_TYPE = 'A'
				 GROUP BY I.INSTANCE_ID
		   ) I
	 WHERE H.INSTANCE_ID = I.INSTANCE_ID
	   AND H.PLAN_ID NOT LIKE '%00'
	   AND H.PLAN_TYPE != 'RELEASE'
	   AND CONVERT( DATE,H.PLAN_START_TIME, 112) = (SELECT CASE WHEN  SLV.SEGMENT2 > REPLACE(SUBSTRING(CONVERT( NVARCHAR(20), I.LOCAL_DATE, 120), 12, 8),':', '') THEN
	                                                           DATEADD(D,-1,CONVERT( DATE, I.LOCAL_DATE))
														   ELSE
														       CONVERT( DATE, I.LOCAL_DATE)
														   END
													FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													WHERE  SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													AND    SLV.SEGMENT1         = I.PLANT_ID
													AND    SLV.ACTIVE_FLAG      = 'Y' ) -- 2019-08-30 kimcd 시업 시간 기준 일자 조정
	   AND H.PLAN_START_TIME > DATEADD(D,-3,GETDATE())  -- 2019-08-30 kimcd 정보 검색 범위 제한용
	 GROUP BY H.INSTANCE_ID
		   , H.PLAN_ID
		   , H.CONFIRM_FLAG









