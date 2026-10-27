
CREATE VIEW [dbo].[FP_LAST_RELEASE_PLAN_ID_V]
-- ================================================================================================
-- Program ID          : FP_LAST_RELEASE_PLAN_ID_V
--
-- Program Name        : FP_LAST_RELEASE_PLAN_ID_V
-- Param               :
-- Batch Period        : 
-- Description         : SCP 제공용 최종 확정 FP Release Plan ID
--
-- Source System       : FP SDB
-- Destination System  : SCP SDB
-- Source Table        : FP_RELEASE_PLAN_INFO_H, FP_INSTANCE_FACTORY_M, SCM_FACTORY_M, SCM_OPERATION_M, SCM_SYS_LOOKUP_VALUE
-- Destination Table   : 
--
-- Create(Update) Date : 2019.06.21
-- Author              : kim choon dong
-- Version             : 2019-06-21 kimcd FP 계획 배포하는 Instance별 최종 Release ID 조회
-- ================================================================================================
AS
    SELECT ZZ.COMPANY_ID
		  ,ZZ.DIVISION_ID
		  ,ZZ.SITE_ID
		  ,ZZ.PLANT_ID
		  ,ZZ.INSTANCE_ID
		  ,ZZ.INSTANCE_TYPE
		  ,ZZ.INSTANCE_DATE
		  ,ZZ.RELEASE_PLAN_ID
		  ,ZZ.FACTORY_ID
		  ,ZZ.PLAN_GROUP_ID
    FROM ( SELECT B.COMPANY_ID
				 ,B.DIVISION_ID
				 ,B.SITE_ID
				 ,B.PLANT_ID
				 ,A.INSTANCE_ID
				 ,B.INSTANCE_TYPE
				 ,A.INSTANCE_DATE
				 ,A.RELEASE_PLAN_ID
				 ,A.FACTORY_ID
				 ,A.PLAN_GROUP_ID
				 ,ROW_NUMBER() OVER ( PARTITION BY  A.DIVISION_ID, A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION
		   FROM   DBO.FP_RELEASE_PLAN_INFO_H  A,
				  ( SELECT  DISTINCT 
					        A.INSTANCE_ID
						   ,A.INSTANCE_TYPE
						   ,B.COMPANY_ID
						   ,B.DIVISION_ID
						   ,B.SITE_ID
						   ,B.PLANT_ID
						   ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
						   ,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
					FROM    DBO.FP_INSTANCE_FACTORY_M A WITH(NOLOCK)
						   ,DBO.SCM_FACTORY_M         B WITH(NOLOCK)
						   ,DBO.SCM_OPERATION_M       O WITH(NOLOCK)
						   ,DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
						    LEFT OUTER JOIN DBO.SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
							    ON  MP.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
							    AND MP.SEGMENT1         = SLV.SEGMENT1
							    AND MP.ACTIVE_FLAG      = 'Y'
							    AND SLV.ATTRIBUTE1      = 'PLAN GROUP'
					WHERE   A.FACTORY_ID         = B.FACTORY_ID
					AND     A.ACTIVE_FLAG        = 'Y'
					AND     A.ACTIVE_FLAG        = B.ACTIVE_FLAG
					AND     A.INSTANCE_TYPE      = O.INSTANCE_TYPE
					AND     B.COMPANY_ID         = O.COMPANY_ID
					AND     B.DIVISION_ID        = O.DIVISION_ID
					AND     B.SITE_ID            = O.SITE_ID
					AND     A.INSTANCE_ID       != 'KR_CELL_M_P'
					AND     SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
					AND     SLV.SEGMENT1         = A.INSTANCE_ID
					AND     SLV.ACTIVE_FLAG      = 'Y'
					) B
		   WHERE A.INSTANCE_ID   = B.INSTANCE_ID
		   AND   A.FACTORY_ID    = B.LINK_FACTORY_ID
		   AND   A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
		   AND   A.INSTANCE_DATE > DATEADD(D,-30,GETDATE())
		) ZZ
	WHERE ZZ.NUMS = 1
