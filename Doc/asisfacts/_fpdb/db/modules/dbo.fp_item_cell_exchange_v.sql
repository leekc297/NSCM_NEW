CREATE VIEW [dbo].[fp_item_cell_exchange_v] as
             SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID, APPLIED_MODEL, ACCUMULATED_CHILD_QTY
             FROM   (
                                        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID, APPLIED_MODEL, ACCUMULATED_CHILD_QTY,
                                               RANK() OVER (PARTITION BY DIVISION_ID, ITEM_ID ORDER BY ACCUMULATED_CHILD_QTY, MODEL_ID, SITE_ID, PLANT_ID) AS RNK
                                        FROM (SELECT MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID,
                                                     MCT.CHILD_ITEM_ID AS ITEM_ID, MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID, MAX(SIM.APPLIED_MODEL) AS APPLIED_MODEL,
                                                     SUM( MCT.ACCUMULATED_CHILD_QTY)     AS ACCUMULATED_CHILD_QTY, -- 누적 소요량
                                                     MAX(ICM.CLASS_ID) AS CLASS_ID,
                                                     MAX(ICM.CLASS_NAME) AS CLASS_NAME
                                              FROM   SCM_ITEM_M             MIM
                                                     ,SCM_ITEM_CLASS_M       ICM
                                                     ,SCM_ITEM_CLASS_LEVEL_M ILCM
                                                     ,SCM_ITEM_M             SIM
                                                     ,SCM_MODEL_COMP_TEMP    MCT
                                              WHERE  MCT.MODEL_ID          = MIM.ITEM_ID
                                              AND    MCT.COMPANY_ID        = MIM.COMPANY_ID
                                              AND    MCT.DIVISION_ID       = MIM.DIVISION_ID
                                              AND    MCT.SITE_ID           = MIM.SITE_ID
                                              AND    MCT.CHILD_ITEM_ID     = SIM.ITEM_ID
                                              AND    MCT.CHILD_COMPANY_ID  = SIM.COMPANY_ID
                                              AND    MCT.CHILD_DIVISION_ID = SIM.DIVISION_ID
                                              AND    MCT.CHILD_SITE_ID     = SIM.SITE_ID
                                              AND    MIM.ITEM_CLASS        = ICM.CLASS_ID
                                              AND    ICM.LEVEL_3_ID        = ILCM.LEVEL_ID
                                              AND    ILCM.OPERATION_GROUP_ID = 'A'
                                              AND    MCT.ALT_PRIORITY = 'Y'
                                              AND    MCT.PLANT_ID = (SELECT MAX(MCTI.PLANT_ID)
                                                                     FROM   SCM_MODEL_COMP_TEMP MCTI
                                                                     WHERE  MCTI.DIVISION_ID = MCT.DIVISION_ID
                                                                     AND    MCTI.SITE_ID     = MCT.SITE_ID
                                                                     AND    MCTI.COMPANY_ID  = MCT.COMPANY_ID) -- 3050, A011 중복 조회 방지
                                        GROUP  BY MCT.COMPANY_ID, MCT.DIVISION_ID, MCT.SITE_ID, MCT.PLANT_ID, MCT.MODEL_ID,
                                                  MCT.CHILD_ITEM_ID, MCT.CHILD_COMPANY_ID, MCT.CHILD_DIVISION_ID, MCT.CHILD_SITE_ID) A
                     ) A
                     WHERE RNK = 1
