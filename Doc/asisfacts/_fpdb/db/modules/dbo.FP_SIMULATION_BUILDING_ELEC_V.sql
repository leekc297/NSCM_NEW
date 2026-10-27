



CREATE VIEW [dbo].[FP_SIMULATION_BUILDING_ELEC_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_BUILDING_ELEC_V
--
-- Program Name        : FP_SIMULATION_BUILDING_ELEC_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_INSTANCE_FACTORY_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.08 1.0 PIYONG
-- Author              : PIYONG
-- Version             : 1.0 신규 생성
-- ================================================================================================
AS 
	SELECT INSTANCE_ID
		   , I.FACTORY_ID
	  FROM FP_INSTANCE_FACTORY_M I WITH(NOLOCK)
	 WHERE I.ACTIVE_FLAG = 'Y'
	   AND I.INSTANCE_TYPE = 'E1'
	 GROUP BY I.INSTANCE_ID
		   , I.FACTORY_ID


