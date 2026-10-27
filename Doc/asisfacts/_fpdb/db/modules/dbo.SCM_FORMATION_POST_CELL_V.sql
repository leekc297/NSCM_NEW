







CREATE VIEW [dbo].[SCM_FORMATION_POST_CELL_V]
-- ================================================================================================
-- Program ID          : SCM_FORMATION_POST_CELL_V
--
-- Program Name        : SCM_FORMATION_POST_CELL_V
-- Param               :
-- Batch Period        : 
-- Description         : 활성화 후 공정에서 필요로 하는 Bare Cell 일자별 소요량 View
--
-- Source System       : FP SDB
-- Destination System  : SCP SDB
-- Source Table        : FP_DAILY_PRODUCTIOIN_PLAN_H, SCM_OPERATION_M, SCM_BOM_M, SCM_ITEM_M,
--                       SCM_ITEM_CLASS_M, SCM_ITEM_LINE_ASSIGN_M, SCM_LINE_M
-- Destination Table   : 
--
-- Create(Update) Date : 2021.11.03
-- Author              : kim choon dong
-- Version             : 2019-05-14 kimcd Cell의 라인 어싸인 우선
--                       2019-10-02 kimcd 시업 시간별로 PLANT 조회하도록 수정
--                       2021-11-03 kimcd BOM 조회 속도 저하로 힌트 추가
-- ================================================================================================
AS
SELECT DPP.[COMPANY_ID]
      ,DPP.[DIVISION_ID]
      ,DPP.[SITE_ID]
      ,DPP.[PLANT_ID]
      ,DPP.[FACTORY_ID]
	  ,DPP.[OPERATION_ID]
      ,DPP.[ITEM_ID]
      ,DPP.[LINE_ID]
      ,DPP.[PLAN_DATE]
      ,DPP.[PLAN_QTY]
      ,DPP.[PLAN_IN_QTY]
	  ,SBM.[ITEM_ID]                AS CELL_ITEM_ID
	  ,SBM.REQ_QTY * [PLAN_IN_QTY]  AS CELL_REQ_QTY
FROM   [DBO].[FP_DAILY_PRODUCTIOIN_PLAN_H] DPP WITH(NOLOCK)
	   LEFT OUTER JOIN (SELECT SBM.COMPANY_ID
						     , SBM.DIVISION_ID
							 , SBM.SITE_ID
							 , SBM.PLANT_ID
							 , SBM.PARENT_ITEM_ID
							 , SBM.ITEM_ID
							 , SBM.REQ_QTY
	   					     , CASE WHEN SBM.ALT_ID IS NULL THEN 1
							   ELSE
							       ROW_NUMBER() OVER (PARTITION BY SBM.COMPANY_ID, SBM.DIVISION_ID, SBM.SITE_ID, SBM.PLANT_ID, SBM.PARENT_ITEM_ID, SBM.ALT_ID ORDER BY SBM.ALT_PRIORITY, SBM.PRIT)
							   END AS PRIT
	                    FROM  (SELECT SBM.COMPANY_ID
									, SBM.DIVISION_ID
									, SBM.SITE_ID
									, SBM.PLANT_ID
									, SBM.PARENT_ITEM_ID
									, CIM.ITEM_ID
									, SBM.ALT_ID
									, SBM.ALT_PRIORITY
									, SBM.CHILD_QTY/PARENT_QTY AS REQ_QTY
									, ( SELECT TOP 1 ILA.PRIORITY
										FROM   SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK)
											 , SCM_LINE_M             SLM WITH(NOLOCK)
										WHERE  ILA.COMPANY_ID     = SLM.COMPANY_ID
										AND    ILA.DIVISION_ID    = SLM.DIVISION_ID
										AND    ILA.SITE_ID        = SLM.SITE_ID
										AND    ILA.PLANT_ID       = SLM.PLANT_ID
										AND    ILA.FACTORY_ID     = SLM.FACTORY_ID
										AND    ILA.OPERATION_ID   = SLM.OPERATION_ID
										AND    ILA.LINE_ID        = SLM.LINE_ID
										AND    ILA.ELECTRODE_TYPE = SLM.ELECTRODE_TYPE
										AND    ILA.MONTH         >= CONVERT(NVARCHAR(6), DATEADD(M, -1, GETDATE()), 112)
										AND    ILA.COMPANY_ID     = CIM.COMPANY_ID
										AND    ILA.DIVISION_ID    = CIM.DIVISION_ID
										AND    ILA.SITE_ID        = CIM.SITE_ID
										AND    ILA.ITEM_ID        = CIM.ITEM_ID
										AND    ILA.ACTIVE_FLAG    = 'Y'
										AND    SLM.ACTIVE_FLAG    = 'Y'
										ORDER  BY ILA.MONTH, ILA.PRIORITY ) AS PRIT
								FROM   SCM_ITEM_M  CIM WITH(NOLOCK),
										SCM_ITEM_CLASS_M  ICM WITH(NOLOCK),
										SCM_BOM_M   SBM WITH(NOLOCK, INDEX(PK_SCM_BOM_M)) -- 2021-11-03 kimcd BOM 조회 속도 저하로 힌트 추가
								WHERE  SBM.EFF_START_DATE <= GETDATE()
								AND    SBM.EFF_END_DATE > GETDATE()
								AND    CIM.COMPANY_ID  = SBM.COMPANY_ID
								AND    CIM.DIVISION_ID = SBM.DIVISION_ID
								AND    CIM.SITE_ID     = SBM.SITE_ID
								AND    CIM.ITEM_ID     = SBM.CHILD_ITEM_ID
								AND    ICM.[CLASS_ID]      = CIM.[ITEM_CLASS]
								--AND    ICM.[LEVEL_1_NAME]  = 'Model'
								--AND    ICM.CLASS_ID  = 'ES1901' 
							    AND    ICM.CLASS_ID  IN ('ES1901', 'ES2001', 'ES2002', 'ES2003', 'ES2004') 

								/*
								AND		LEVEL_1_NAME = 'Assembly'
								AND		LEVEL_2_NAME = 'Cell Assembly'
								AND		LEVEL_3_NAME = 'Cell Assembly'
								*/) SBM
						) SBM
	   ON   DPP.COMPANY_ID  = SBM.COMPANY_ID
       AND  DPP.DIVISION_ID = SBM.DIVISION_ID
       AND  DPP.SITE_ID     = SBM.SITE_ID
	   AND  DPP.PLANT_ID    = SBM.PLANT_ID
       AND  DPP.ITEM_ID     = SBM.PARENT_ITEM_ID
	   AND  (SBM.PRIT IS NULL OR SBM.PRIT = 1 )
	  ,( SELECT SLV.SEGMENT1
	           ,SLP.SEGMENT1  AS PLANT_ID
			   ,SLV.ATTRIBUTE1
	     FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  SLV WITH(NOLOCK)
		       ,[DBO].[SCM_SYS_LOOKUP_VALUE]  SLP WITH(NOLOCK)
			   ,[DBO].[SCM_PLANT_M]           PM  WITH(NOLOCK)
		 WHERE  SLP.SEGMENT2         = SLV.SEGMENT2
		 AND    PM.SITE_ID           = SLV.SEGMENT1
		 AND    PM.PLANT_ID          = SLP.SEGMENT1
		 AND    SLV.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
         AND    SLV.ACTIVE_FLAG    = 'Y'
		 AND    SLP.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
         AND    SLP.ACTIVE_FLAG    = 'Y'  ) SLV  -- 2019-10-02 kimcd 시업 시간별로 PLANT 조회하도록 수정
	  ,[DBO].[SCM_OPERATION_M]  SOM WITH(NOLOCK)
WHERE DPP.[COMPANY_ID]   = [SOM].[COMPANY_ID]
AND   DPP.[DIVISION_ID]  = [SOM].[DIVISION_ID]
AND   DPP.[SITE_ID]      = [SOM].[SITE_ID]
AND	  DPP.[OPERATION_ID] = [SOM].[OPERATION_ID]
AND   DPP.SITE_ID        = SLV.SEGMENT1
AND   DPP.PLANT_ID       = SLV.PLANT_ID  -- 2019-10-02 kimcd 시업 시간별로 PLANT 조회하도록 수정
AND   DPP.PLAN_TYPE      = 'RELEASE'
AND   DPP.PLAN_DATE     >=  CONVERT(datetime,  ATTRIBUTE1 + ' 00:00:00', 120)
AND   SOM.INSTANCE_TYPE  = 'F0'
AND   DPP.PLAN_IN_QTY    > 0

