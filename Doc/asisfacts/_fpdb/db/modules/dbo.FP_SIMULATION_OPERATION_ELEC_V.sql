



CREATE VIEW [dbo].[FP_SIMULATION_OPERATION_ELEC_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_OPERATION_ELEC_V
--
-- Program Name        : FP_SIMULATION_OPERATION_ELEC_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_AMEND_DAILY_PLAN_R, FP_INSTANCE_FACTORY_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.08.08 1.0 PIYONG
-- Author              : PIYONG
-- Version             : PIYONG 신규 생성
-- ================================================================================================
AS 
	SELECT A.INSTANCE_ID
		   , A.FACTORY_ID
   		   , A.OPERATION_ID
	  FROM FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
		   ,(
				SELECT INSTANCE_ID
					   , I.FACTORY_ID
				  FROM FP_INSTANCE_FACTORY_M I WITH(NOLOCK)
				 WHERE I.ACTIVE_FLAG = 'Y'
				   AND I.INSTANCE_TYPE = 'E1'
				 GROUP BY I.INSTANCE_ID
					   , I.FACTORY_ID
			)  B
	 WHERE A.INSTANCE_ID	= B.INSTANCE_ID
	   AND A.FACTORY_ID		= B.FACTORY_ID
	 GROUP BY A.INSTANCE_ID
		   , A.FACTORY_ID
		   , A.OPERATION_ID


