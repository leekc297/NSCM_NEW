




CREATE VIEW [dbo].[FP_SIMULATION_BUILDING_FORM_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_BUILDING_FORM_V
--
-- Program Name        : FP_SIMULATION_BUILDING_FORM_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_FP_PLAN_H, FP_INSTANCE_FACTORY_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.10.03
-- Author              : KIMCD
-- Version             : 2019-10-03 KIMCD 신규 생성
-- ================================================================================================
AS 
	SELECT INSTANCE_ID
		   , I.FACTORY_ID
	  FROM FP_INSTANCE_FACTORY_M I WITH(NOLOCK)
	 WHERE I.ACTIVE_FLAG = 'Y'
	   AND I.INSTANCE_TYPE = 'F'
	 GROUP BY I.INSTANCE_ID
		   , I.FACTORY_ID



