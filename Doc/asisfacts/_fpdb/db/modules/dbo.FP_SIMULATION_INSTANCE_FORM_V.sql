



CREATE VIEW [dbo].[FP_SIMULATION_INSTANCE_FORM_V]
-- ================================================================================================
-- Program ID          : FP_SIMULATION_INSTANCE_FORM_V
--
-- Program Name        : FP_SIMULATION_INSTANCE_FORM_V
-- Param               :
-- Batch Period        : 
-- Description         : Excel Simulation용 View
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_INSTANCE_FACTORY_M, TH_UIS_USER_INSTANCE_RELATE, TH_UIS_ROLE_INSTANCE_RELATE
-- Destination Table   : 
--
-- Create(Update) Date : 2019.12.06
-- Author              : KIMCD
-- Version             : 2019-10-03 KIMCD 신규 생성
--                       2.0 2019-12-06 KIMCD 권한 체계 변경에 따른 권한 Table 변경
-- ================================================================================================
AS 
	SELECT S.INSTANCE_ID, [USER_ID]
	  FROM FP_INSTANCE_FACTORY_M I WITH(NOLOCK)
		   INNER JOIN (
						SELECT B.INSTANCE_ID
								,A.USER_ID
						  FROM TH_UIS_USER_INSTANCE_RELATE A WITH(NOLOCK)
							   ,TH_UIS_ROLE_INSTANCE_RELATE B WITH(NOLOCK)
						 WHERE A.ROLE_ID = B.ROLE_ID
						   AND A.USE_AT_FLAG = 'Y'
						   AND B.USE_AT_FLAG = 'Y'
						   AND A.SAVE_FLAG = 'Y'
						 GROUP BY B.INSTANCE_ID, A.[USER_ID]
					   ) S
					ON I.INSTANCE_ID = S.INSTANCE_ID
	 WHERE I.ACTIVE_FLAG = 'Y'
	   AND I.INSTANCE_TYPE = 'F'
	GROUP BY S.INSTANCE_ID, [USER_ID]


