


CREATE VIEW [dbo].[FP_SIMULATION_BUILDING_PACK_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_BUILDING_PACK_V
--
-- Program Name        : FP_SIMULATION_BUILDING_PACK_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_INSTANCE_FACTORY_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.06
-- Author              : PIYONG
-- Version             : 2019-08-06 신규 생성
-- ================================================================================================
AS 
	SELECT INSTANCE_ID
		   , I.FACTORY_ID
	  FROM FP_INSTANCE_FACTORY_M I WITH(NOLOCK)
	 WHERE I.ACTIVE_FLAG = 'Y'
	   AND I.INSTANCE_TYPE = 'P'
	 GROUP BY I.INSTANCE_ID
		   , I.FACTORY_ID

