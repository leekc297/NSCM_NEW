

CREATE VIEW [dbo].[FP_STOCK_BOH_V]
AS
SELECT D.INSTANCE_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.CUTOFF_DATE, 
       A.STOCK_TYPE, A.ITEM_ID, ISNULL(A.LANE,E.LANE_QTY) AS LANE, A.PRODUCTION_TYPE, 
       B.ITEM_UOM, B.COATED_LENGTH, B.UNCOATED_LENGTH, B.LENGTH_UOM, E.PATTERN_QTY, 
       A.QTY, A.QTY_UOM, 
              (CASE WHEN UPPER(A.QTY_UOM) = 'M'
                             THEN A.QTY -- Pancake
                             WHEN UPPER(A.QTY_UOM) != 'M'
                             THEN A.QTY -- Pancake
                                  / ISNULL(E.PATTERN_QTY,1) 
                                  * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                              WHEN 'CM' THEN 100
                                                                              WHEN 'MM' THEN 1000
                                                                                        ELSE 1 END)
                                    END )
                              ELSE NULL END) AS ROLL_QTY
                     ,  (CASE WHEN UPPER(A.QTY_UOM) = 'M'
                              THEN A.QTY / CASE WHEN A.LANE = 0 OR A.LANE IS NULL THEN E.LANE_QTY ELSE A.LANE END  --ISNULL(A.LANE,E.LANE_QTY) -- Roll 
                              WHEN UPPER(A.QTY_UOM) != 'M'
                              THEN A.QTY / CASE WHEN A.LANE = 0 OR A.LANE IS NULL THEN E.LANE_QTY ELSE A.LANE END --ISNULL(A.LANE,E.LANE_QTY) -- Roll
                                    / ISNULL(E.PATTERN_QTY,1) 
                                    * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                            ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                    / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                WHEN 'CM' THEN 100
                                                                                WHEN 'MM' THEN 1000
                                                                                          ELSE 1 END)
                                   END )
                              ELSE NULL END) JR_QTY
                     ,  (CASE WHEN  F.ACCUMULATED_CHILD_QTY IS NULL THEN NULL 
                              ELSE  A.QTY / (CASE WHEN F.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                       ELSE F.ACCUMULATED_CHILD_QTY END)
                              END) AS CELL_QTY                               
FROM SCM_STOCK_H_V A
     LEFT OUTER JOIN (
                        SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, PATTERN_QTY
                        FROM   (
                                SELECT A.*,
                                       DENSE_RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                          ORDER     BY CASE WHEN ACTIVE_FLAG = 'Y'    THEN 1
                                                                            WHEN ACTIVE_FLAG IS NULL  THEN 2
                                                                            ELSE 3
                                                                       END,
                                                                       LANE_QTY DESC
                                                                     , FACTORY_ID
                                                                     , MAIN_LANE_QTY DESC
                                                                     , SUB_LANE_QTY
                                                                     , PATTERN_QTY) AS SEQ
                                FROM   SCM_ITEM_LANE_M A
                               ) A
                        WHERE  SEQ = 1       
                       ) E
            ON    A.DIVISION_ID = E.DIVISION_ID
            AND   A.SITE_ID = E.SITE_ID
            AND   A.PLANT_ID = E.PLANT_ID
            AND   A.FACTORY_ID = E.FACTORY_ID
            AND   A.ITEM_ID = E.ITEM_ID
                       LEFT OUTER JOIN DBO.FP_ITEM_CELL_EXCHANGE_M F
    		                    ON      A.ITEM_ID = F.ITEM_ID
    		                    AND     CASE WHEN F.DIVISION_ID = '82' THEN '81' ELSE F.DIVISION_ID END = A.DIVISION_ID     ,       
     SCM_ITEM_M B,
     SCM_ITEM_CLASS_M C ,
     (SELECT A.INSTANCE_ID, A.INSTANCE_TYPE, B.PLANT_ID, A.FACTORY_ID
	    FROM FP_INSTANCE_FACTORY_M A,
		     SCM_FACTORY_M B
		WHERE 1=1
		AND A.ACTIVE_FLAG = 'Y'
		AND A.FACTORY_ID = B.FACTORY_ID
		) D
WHERE 1=1
--AND A.CUTOFF_DATE = '2017-03-21'
AND A.QTY > 0
AND A.STOCK_TYPE = 'INVENTORY'
AND A.ITEM_ID = B.ITEM_ID
AND B.ITEM_CLASS = C.CLASS_ID
AND C.LEVEL_2_NAME LIKE '%Pancake%'
AND C.LEVEL_3_CODE != 'APCSR'
AND D.INSTANCE_TYPE = 'E1'
AND A.PLANT_ID = D.PLANT_ID
AND (A.STORAGE_ID LIKE '5%' OR A.STORAGE_ID LIKE '1%')
UNION ALL
SELECT D.INSTANCE_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.CUTOFF_DATE, 
       A.STOCK_TYPE, A.ITEM_ID, ISNULL(A.LANE,E.LANE_QTY) AS LANE, A.PRODUCTION_TYPE, 
       B.ITEM_UOM, B.COATED_LENGTH, B.UNCOATED_LENGTH, B.LENGTH_UOM, E.PATTERN_QTY, 
       A.QTY, A.QTY_UOM, 
              (CASE WHEN UPPER(A.QTY_UOM) = 'M'
                             THEN A.QTY -- Pancake
                             WHEN UPPER(A.QTY_UOM) != 'M'
                             THEN A.QTY -- Pancake
                                  / ISNULL(E.PATTERN_QTY,1) 
                                  * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                          ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                  / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                              WHEN 'CM' THEN 100
                                                                              WHEN 'MM' THEN 1000
                                                                                        ELSE 1 END)
                                    END )
                              ELSE NULL END) AS ROLL_QTY
                     ,  (CASE WHEN UPPER(A.QTY_UOM) = 'M'
                              THEN A.QTY / CASE WHEN A.LANE = 0 OR A.LANE IS NULL THEN E.LANE_QTY ELSE A.LANE END   --ISNULL(A.LANE,E.LANE_QTY) -- Roll 
                              WHEN UPPER(A.QTY_UOM) != 'M'
                              THEN A.QTY / CASE WHEN A.LANE = 0 OR A.LANE IS NULL THEN E.LANE_QTY ELSE A.LANE END   --ISNULL(A.LANE,E.LANE_QTY) -- Roll
                                    / ISNULL(E.PATTERN_QTY,1) 
                                    * (CASE WHEN (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                            ELSE (ISNULL(B.COATED_LENGTH,0) + ISNULL(B.UNCOATED_LENGTH, 0)) 
                                                    / (CASE UPPER(B.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                                WHEN 'CM' THEN 100
                                                                                WHEN 'MM' THEN 1000
                                                                                          ELSE 1 END)
                                   END )
                              ELSE NULL END) JR_QTY
                     ,  (CASE WHEN  F.ACCUMULATED_CHILD_QTY IS NULL THEN NULL 
                              ELSE  A.QTY / (CASE WHEN F.ACCUMULATED_CHILD_QTY = 0 THEN 1 
                                                       ELSE F.ACCUMULATED_CHILD_QTY END)
                              END) AS CELL_QTY                               
FROM SCM_STOCK_H_V A
     LEFT OUTER JOIN (
                        SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, PATTERN_QTY
                        FROM   (
                                SELECT A.*,
                                       DENSE_RANK() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                                                          ORDER     BY CASE WHEN ACTIVE_FLAG = 'Y'    THEN 1
                                                                            WHEN ACTIVE_FLAG IS NULL  THEN 2
                                                                            ELSE 3
                                                                       END,
                                                                       LANE_QTY DESC
                                                                     , FACTORY_ID
                                                                     , MAIN_LANE_QTY DESC
                                                                     , SUB_LANE_QTY
                                                                     , PATTERN_QTY) AS SEQ
                                FROM   SCM_ITEM_LANE_M A
                               ) A
                        WHERE  SEQ = 1       
                       ) E
            ON    A.DIVISION_ID = E.DIVISION_ID
            AND   A.SITE_ID = E.SITE_ID
            AND   A.PLANT_ID = E.PLANT_ID
            AND   A.FACTORY_ID = E.FACTORY_ID
            AND   A.ITEM_ID = E.ITEM_ID
                       LEFT OUTER JOIN DBO.FP_ITEM_CELL_EXCHANGE_M F
    		                    ON      A.ITEM_ID = F.ITEM_ID
    		                    AND     CASE WHEN F.DIVISION_ID = '82' THEN '81' ELSE F.DIVISION_ID 
    		                                 --WHEN F.SITE_ID = 'A002' AND F.DIVISION_ID = '82' 
    		                                 END = A.DIVISION_ID 
    		                         ,       
     SCM_ITEM_M B,
     SCM_ITEM_CLASS_M C ,
     (SELECT A.INSTANCE_ID, A.INSTANCE_TYPE, B.PLANT_ID, A.FACTORY_ID
	    FROM FP_INSTANCE_FACTORY_M A,
		     SCM_FACTORY_M B
		WHERE 1=1
		AND A.ACTIVE_FLAG = 'Y'
		AND A.FACTORY_ID = B.FACTORY_ID
		) D
WHERE 1=1
--AND A.CUTOFF_DATE = '2017-03-20'
AND A.QTY > 0
AND A.STOCK_TYPE = 'WIP'
AND A.ITEM_ID = B.ITEM_ID
AND A.DIVISION_ID = B.DIVISION_ID
AND A.SITE_ID = B.SITE_ID
AND B.ITEM_CLASS = C.CLASS_ID
AND C.LEVEL_2_NAME LIKE '%Pancake%'
AND C.LEVEL_3_CODE != 'APCSR'
--AND D.INSTANCE_ID = 'KR_E_PRE'
AND D.INSTANCE_TYPE = 'E1'
AND A.PLANT_ID = D.PLANT_ID
AND CASE WHEN A.PLANT_ID = 'G452' AND A.FACTORY_ID = 'E7' THEN 'E8' ELSE A.FACTORY_ID END = D.FACTORY_ID
--AND A.ITEM_ID = 'APCAN0026A'
