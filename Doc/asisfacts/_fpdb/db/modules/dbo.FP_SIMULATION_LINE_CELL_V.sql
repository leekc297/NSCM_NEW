



CREATE VIEW [dbo].[FP_SIMULATION_LINE_CELL_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_LINE_CELL_V
--
-- Program Name        : FP_SIMULATION_LINE_CELL_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_AMEND_PLAN_CELL_R, SCM_FP_PLAN_H, FP_INSTANCE_FACTORY_M, SCM_LINE_M
-- Destination Table   : 
--
-- Create(Update) Date : 2019.07.31
-- Author              : PIYONG
-- Version             : 2019-07-31 PIYONG 신규 생성
-- ================================================================================================
AS 
	WITH IST AS (
					SELECT INSTANCE_ID
						   , I.FACTORY_ID
					  FROM FP_INSTANCE_FACTORY_M I WITH(NOLOCK)
					 WHERE I.ACTIVE_FLAG = 'Y'
					   AND I.INSTANCE_TYPE = 'A'
					 GROUP BY I.INSTANCE_ID
						   , I.FACTORY_ID
				)

	SELECT A.INSTANCE_ID
		   , A.FACTORY_ID
		   , A.LINE_ID
   		   , L.LINE_NAME
	  FROM FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)
		   ,IST  B
   		   ,SCM_LINE_M L WITH(NOLOCK)
	 WHERE A.INSTANCE_ID	= B.INSTANCE_ID
	   AND A.FACTORY_ID		= B.FACTORY_ID
	   AND A.[COMPANY_ID]	= L.[COMPANY_ID]
	   AND A.[DIVISION_ID]	= L.[DIVISION_ID]
	   AND A.[SITE_ID]		= L.[SITE_ID]
	   AND A.[PLANT_ID]		= L.[PLANT_ID]
	   AND A.[FACTORY_ID]	= L.[FACTORY_ID]
	   AND A.[OPERATION_ID]	= L.[OPERATION_ID]
	   AND A.[LINE_ID]		= L.[LINE_ID]
	   AND A.[ELECTRODE_TYPE]	= L.[ELECTRODE_TYPE]
	   AND L.ACTIVE_FLAG	= 'Y'
	 GROUP BY A.INSTANCE_ID
			, A.FACTORY_ID
			, A.LINE_ID
			, L.LINE_NAME


