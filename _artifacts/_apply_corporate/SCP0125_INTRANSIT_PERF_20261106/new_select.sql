SELECT A.DIVISION_ID
     , A.RESULT_TYPE
     , A.ITEM_ID
     , A.TO_SCM_SITE_ID
     , A.FROM_SCM_SITE_ID
     , A.FINAL_INCOTERMS
     , CASE WHEN VALIDATE_CONVERSION(A.ETA_DATE AS DATE, 'YYYYMMDD') = 1
            THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD') + NVL(B.LT_DAY, 0), 'YYYYMMDD')
            ELSE A.ETA_DATE
       END   AS ETA_DATE
     , A.DELIVERY_QTY
     , A.PROJECT_CODE
  FROM ( SELECT A.RESULT_DATE
              , A.RESULT_TYPE
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.PLANT_ID
              , A.SHIPMENT_NO
              , A.PROJECT_CODE
              , A.ITEM_ID
              , A.PLANT_ISSUE_DATE
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.INCOTERMS
                END   AS INCOTERMS
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.FINAL_INCOTERMS
                END   AS FINAL_INCOTERMS
              , A.FCST_TYPE
              , A.CUSTOMER_CODE
              , A.FINAL_SOLDTO_CODE
              , A.SHIPTO_CODE
              , A.FROM_SCM_SITE_ID
              , A.TO_SCM_SITE_ID
              , B.SITE_TYPE
              , A.DELIVERY_QTY
              , A.UOM
              , A.TRANSPORT_MODE
              , A.SHIPPING_DATE
              , A.POL
              , A.POL_ATD_DATE
              , A.POD
              , A.POD_ETA_DATE
              , A.POD_ATA_DATE
              , A.POD_ETD_DATE
              , A.POD_ATD_DATE
              , A.F_DEST_PORT_CODE
              , A.F_DEST_ETA_DATE
              , A.F_DEST_ATA_DATE
              , CASE WHEN A.F_DEST_ETA_DATE IS NULL THEN
                          CASE WHEN C.ADD_AFTER_LT_TOTAL IS NULL THEN
                                    CASE WHEN D.ADD_AFTER_LT_TOTAL IS NULL
                                         THEN TO_CHAR(TO_DATE(A.RESULT_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')
                                         ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + D.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                                    END
                               ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + C.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                          END
                     ELSE A.F_DEST_ETA_DATE
                END   AS ETA_DATE
              , A.ATTRIBUTE2
           FROM SCM_DNM_INTRANSIT_C   A
              , ( SELECT DIVISION_ID
                       , SCM_SITE_ID
                       , SITE_TYPE
                    FROM SCM_MST_SITE
                   WHERE SITE_TYPE IN ('PLANT', 'SALES')
                     AND VALID_YN = 'Y' )   B
              , SCP_MST_BOD_N_V   C
              , ( SELECT A.DIVISION_ID
                       , A.FROM_SITE
                       , A.TO_SITE
                       , A.TRANSPORT_MODE
                       , MAX(A.ADD_AFTER_LT_TOTAL)   AS ADD_AFTER_LT_TOTAL
                    FROM SCP_MST_BOD_N_V   A
                   WHERE A.BOD_VALID_YN = 'Y'
                   GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.TRANSPORT_MODE )   D
          WHERE B.DIVISION_ID = A.DIVISION_ID
            AND B.SCM_SITE_ID = A.TO_SCM_SITE_ID
            AND C.DIVISION_ID(+) = A.DIVISION_ID
            AND C.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND C.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND C.INCOTERMS(+) = A.FINAL_INCOTERMS
            AND C.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND C.BOD_VALID_YN(+) = 'Y'
            AND C.FROM_YYYYMMDD(+) <= A.PLANT_ISSUE_DATE
            AND C.TO_YYYYMMDD(+) >= A.PLANT_ISSUE_DATE
            AND D.DIVISION_ID(+) = A.DIVISION_ID
            AND D.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND D.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND D.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND A.RESULT_TYPE = 'I'
            AND A.VALID_YN = 'Y'
            AND A.DIVISION_ID = :P_DIVISION_ID
            AND A.RESULT_DATE = :V_CUTOFF_DAY
         UNION
         SELECT A.RESULT_DATE
              , A.RESULT_TYPE
              , A.COMPANY_ID
              , A.DIVISION_ID
              , A.PLANT_ID
              , A.SHIPMENT_NO
              , A.PROJECT_CODE
              , A.ITEM_ID
              , A.PLANT_ISSUE_DATE
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.INCOTERMS
                END   AS INCOTERMS
              , CASE WHEN A.FROM_SCM_SITE_ID = FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'SCM_SITE_ID')
                      AND A.TO_SCM_SITE_ID = 'LGE_US_HZP' THEN 'DDP' ELSE A.FINAL_INCOTERMS
                END   AS FINAL_INCOTERMS
              , A.FCST_TYPE
              , A.CUSTOMER_CODE
              , A.FINAL_SOLDTO_CODE
              , A.SHIPTO_CODE
              , A.FROM_SCM_SITE_ID
              , A.TO_SCM_SITE_ID
              , B.SITE_TYPE
              , A.DELIVERY_QTY
              , A.UOM
              , A.TRANSPORT_MODE
              , A.SHIPPING_DATE
              , A.POL
              , A.POL_ATD_DATE
              , A.POD
              , A.POD_ETA_DATE
              , A.POD_ATA_DATE
              , A.POD_ETD_DATE
              , A.POD_ATD_DATE
              , A.F_DEST_PORT_CODE
              , A.F_DEST_ETA_DATE
              , A.F_DEST_ATA_DATE
              , CASE WHEN A.F_DEST_ETA_DATE IS NULL THEN
                          CASE WHEN C.ADD_AFTER_LT_TOTAL IS NULL THEN
                                    CASE WHEN D.ADD_AFTER_LT_TOTAL IS NULL
                                         THEN TO_CHAR(TO_DATE(A.RESULT_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')
                                         ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + D.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                                    END
                               ELSE TO_CHAR(TO_DATE(A.PLANT_ISSUE_DATE, 'YYYYMMDD') + C.ADD_AFTER_LT_TOTAL, 'YYYYMMDD')
                          END
                     ELSE A.F_DEST_ETA_DATE
                END   AS ETA_DATE
              , A.ATTRIBUTE2
           FROM SCM_DNM_INTRANSIT_C   A
              , ( SELECT DIVISION_ID
                       , SCM_SITE_ID
                       , SITE_TYPE
                    FROM SCM_MST_SITE
                   WHERE VALID_YN = 'Y' )   B
              , SCP_MST_BOD_N_V   C
              , ( SELECT A.DIVISION_ID
                       , A.FROM_SITE
                       , A.TO_SITE
                       , A.TRANSPORT_MODE
                       , MAX(A.ADD_AFTER_LT_TOTAL)   AS ADD_AFTER_LT_TOTAL
                    FROM SCP_MST_BOD_N_V   A
                   WHERE A.BOD_VALID_YN = 'Y'
                   GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.TRANSPORT_MODE )   D
          WHERE B.DIVISION_ID = A.DIVISION_ID
            AND B.SCM_SITE_ID = A.TO_SCM_SITE_ID
            AND C.DIVISION_ID(+) = A.DIVISION_ID
            AND C.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND C.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND C.INCOTERMS(+) = A.FINAL_INCOTERMS
            AND C.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND C.BOD_VALID_YN(+) = 'Y'
            AND C.FROM_YYYYMMDD(+) <= A.PLANT_ISSUE_DATE
            AND C.TO_YYYYMMDD(+) >= A.PLANT_ISSUE_DATE
            AND D.DIVISION_ID(+) = A.DIVISION_ID
            AND D.FROM_SITE(+) = A.FROM_SCM_SITE_ID
            AND D.TO_SITE(+) = A.TO_SCM_SITE_ID
            AND D.TRANSPORT_MODE(+) = A.TRANSPORT_MODE
            AND A.RESULT_TYPE = 'C'
            AND A.VALID_YN = 'Y'
            AND A.DIVISION_ID = :P_DIVISION_ID
            AND A.RESULT_DATE = :V_CUTOFF_DAY
 )   A
     , ( SELECT A.DIVISION_ID
              , A.SCM_SITE_ID
              , A.ITEM_ID
              , MAX(NVL(A.SCP_VMI_LT, 0))   AS LT_DAY
           FROM SCM_MST_SITE_ITEM             A
              , SCM_ADM_LOOKUP_MASTER_DETAIL  B
          WHERE A.DIVISION_ID = B.SEGMENT1
            AND A.SCM_SITE_ID = B.SEGMENT2
            AND B.LOOKUP_TYPE = 'VMI_LT_SITE'
            AND A.VALID_YN = 'Y'
            AND B.VALID_YN = 'Y'
          GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID )   B
 WHERE A.DIVISION_ID = B.DIVISION_ID(+)
   AND A.TO_SCM_SITE_ID = B.SCM_SITE_ID(+)
   AND A.ITEM_ID = B.ITEM_ID(+)
   AND A.PLANT_ID <> FN_GET_LOOKUP_VALUE('SCM_DNM_INTRANSIT_V', 'WarrantyPlant')
   AND ( A.FROM_SCM_SITE_ID IS NULL
      OR A.FROM_SCM_SITE_ID IN (SELECT SCM_SITE_ID
                                  FROM SCM_MST_SITE
                                 WHERE NVL(OPERATION_GROUP, '*') <> 'W') )
   AND A.TO_SCM_SITE_ID IS NOT NULL