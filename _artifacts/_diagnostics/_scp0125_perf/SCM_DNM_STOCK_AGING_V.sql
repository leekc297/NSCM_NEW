SELECT SA.COMPANY_ID

     , SA.DIVISION_ID

     , CASE WHEN FX.OPERATION_ID IS NULL THEN FN_GET_SCM_SITE_ID_PLANT(SA.PLANT_ID, 'A')

            ELSE NULL

       END                                                  AS SCM_SITE_ID          /* [E20251028-000588] FCS 제외공정 반영 */

     , SA.SITE_ID

     , SA.PLANT_ID

     , SA.FACTORY_ID

     , SA.ROUTE_ID

     , SA.LINE_ID

     , SA.CUTOFF_DATE - 1                                   AS CUTOFF_DATE

     , SA.SEQ

     , CASE WHEN RTRIM(FI.PACKER_PLAN_ITEM_ID) IS NULL THEN TRIM(NVL(EA.CELL_ASSY_ITEM_ID, SA.ITEM_ID))

            ELSE FI.PACKER_PLAN_ITEM_ID

       END                                                  AS ITEM_ID              /* E20260331-000738 / 2025.09.15 CELL ASSY ITEM 우선 */

     , TRIM(SA.ITEM_ID)                                     AS ORIGIN_ITEM_ID       /* 2018.06.29 */

     , SA.PRODUCTION_TYPE

     , SA.FCS_INPUT_DATE

     , CASE WHEN NVL(SA.AGING_AVAILABLE_DATE, DATE '1999-01-01') >= NVL(SA.UNHOLD_EXP_DATE, DATE '1999-01-01') THEN SA.AGING_AVAILABLE_DATE

            ELSE SA.UNHOLD_EXP_DATE

       END                                                  AS AVAILABLE_DATE       /* 20200408 MAX(AVAILABLE_DATE, UNHOLD_EXP_DATE) */

     , SA.REMAIN_LEAD_TIME

     , SA.HOLDING_DATE

     , SA.INPUT_QTY

     , SA.QTY

     , SA.QTY_UOM

     , SA.STOCK_STATUS

     , SA.OPERATION_ID

     , SA.OPERATION_SEQ

     , SA.OP_START_TIME

     , SA.TRAY_OP_STATUS

     , SA.STOCK_TYPE

     , CASE WHEN RTRIM(SA.WIPHOLD_YN) IS NULL THEN 'N'

            ELSE SA.WIPHOLD_YN

       END                                                  AS WIPHOLD_YN           /* 2018. 5. 11 / E20260331-000738 */

     , SA.UNHOLD_EXP_DATE

     , SA.SPECIAL_YN

     , SA.LOT_ID

     , SA.OCV2_END_TIME

     , SA.SHIP_AVAILABLE_DATE

     , SA.BEFORE_DEGAS

     , SA.DEGAS_END_DATE

     , SA.INSERT_ID

     , SA.INSERT_TIME

     , SA.UPDATE_ID

     , SA.UPDATE_TIME

     , FI.OPERATION_GROUP                                                           /* 20190130 */

     , FI.NICK_NAME                                                                 /* 20190130 */

     , SA.AGING_AVAILABLE_DATE
     , SA.CUTOFF_DATE                                       AS ORG_CUTOFF_DATE      --  2026.10.07 AJS 원장 마감일(기간 조건 인덱스 사용)

  FROM SCM_DNM_STOCK_AGING_V_SN SA

     , (SELECT XA.COMPANY_ID

             , XA.DIVISION_ID

             , XA.SITE_ID

             , XA.PLANT_ID

             , XA.SCP_EXC_ITEM_ID

             , XA.CELL_ASSY_ITEM_ID

          FROM TABLE(FN_GET_SCP_EXC_ITEM_ASSY_MAP(NULL)) XA) EA                     /* 2025.09.15 SCP 제외 대상 품목 -> Cell Assy 전환 대상 */

     , SCP_MST_FINAL_ITEM FI

     , (SELECT SEGMENT1 AS OPERATION_ID

          FROM SCM_ADM_LOOKUP_MASTER_DETAIL

         WHERE LOOKUP_TYPE = 'FCS_INVENTORY_EXCEPTION_OPERATION'

           AND VALID_YN = 'Y'

         GROUP BY SEGMENT1) FX                                                      /* [E20251028-000588] FCS 제외공정 */

 WHERE EA.COMPANY_ID(+) = SA.COMPANY_ID

   AND EA.DIVISION_ID(+) = SA.DIVISION_ID

   AND EA.SITE_ID(+) = SA.SITE_ID

   AND EA.PLANT_ID(+) = SA.PLANT_ID

   AND EA.SCP_EXC_ITEM_ID(+) = TRIM(SA.ITEM_ID)

   AND FI.DIVISION_ID(+) = SA.DIVISION_ID

   AND FI.ITEM_ID(+) = TRIM(NVL(EA.CELL_ASSY_ITEM_ID, SA.ITEM_ID))

   AND FX.OPERATION_ID(+) = SA.OPERATION_ID

/* [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 line 재고 정보 추가 */

 UNION ALL

SELECT MP.VL_COMPANY_ID                                     AS COMPANY_ID

     , MP.VL_DIVISION_ID                                    AS DIVISION_ID

     , CASE WHEN FX.OPERATION_ID IS NULL THEN FN_GET_SCM_SITE_ID_PLANT(MP.VL_PLANT_ID, 'A')

            ELSE NULL

       END                                                  AS SCM_SITE_ID

     , MP.VL_SITE_ID                                        AS SITE_ID

     , MP.VL_PLANT_ID                                       AS PLANT_ID

     , MP.VL_FACTORY_ID                                     AS FACTORY_ID

     , SA.ROUTE_ID

     , MP.VL_LINE_ID                                        AS LINE_ID

     , SA.CUTOFF_DATE - 1                                   AS CUTOFF_DATE

     , SA.SEQ

     , CASE WHEN RTRIM(FI.PACKER_PLAN_ITEM_ID) IS NULL THEN TRIM(NVL(EA.CELL_ASSY_ITEM_ID, SA.ITEM_ID))

            ELSE FI.PACKER_PLAN_ITEM_ID

       END                                                  AS ITEM_ID

     , TRIM(SA.ITEM_ID)                                     AS ORIGIN_ITEM_ID

     , SA.PRODUCTION_TYPE

     , SA.FCS_INPUT_DATE

     , CASE WHEN NVL(SA.AGING_AVAILABLE_DATE, DATE '1999-01-01') >= NVL(SA.UNHOLD_EXP_DATE, DATE '1999-01-01') THEN SA.AGING_AVAILABLE_DATE

            ELSE SA.UNHOLD_EXP_DATE

       END                                                  AS AVAILABLE_DATE

     , SA.REMAIN_LEAD_TIME

     , SA.HOLDING_DATE

     , SA.INPUT_QTY

     , SA.QTY

     , SA.QTY_UOM

     , SA.STOCK_STATUS

     , SA.OPERATION_ID

     , SA.OPERATION_SEQ

     , SA.OP_START_TIME

     , SA.TRAY_OP_STATUS

     , SA.STOCK_TYPE

     , CASE WHEN RTRIM(SA.WIPHOLD_YN) IS NULL THEN 'N'

            ELSE SA.WIPHOLD_YN

       END                                                  AS WIPHOLD_YN

     , SA.UNHOLD_EXP_DATE

     , SA.SPECIAL_YN

     , SA.LOT_ID

     , SA.OCV2_END_TIME

     , SA.SHIP_AVAILABLE_DATE

     , SA.BEFORE_DEGAS

     , SA.DEGAS_END_DATE

     , SA.INSERT_ID

     , SA.INSERT_TIME

     , SA.UPDATE_ID

     , SA.UPDATE_TIME

     , FI.OPERATION_GROUP

     , FI.NICK_NAME

     , SA.AGING_AVAILABLE_DATE
     , SA.CUTOFF_DATE                                       AS ORG_CUTOFF_DATE      --  2026.10.07 AJS 원장 마감일(기간 조건 인덱스 사용)

  FROM SCM_DNM_STOCK_AGING_V_SN SA

     , TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP()) MP                              /* JV Real Line / ESS Virtual Line 매핑 */

     , SCM_MST_ITEM_SN VI

     , (SELECT XA.COMPANY_ID

             , XA.DIVISION_ID

             , XA.SITE_ID

             , XA.PLANT_ID

             , XA.SCP_EXC_ITEM_ID

             , XA.CELL_ASSY_ITEM_ID

          FROM TABLE(FN_GET_SCP_EXC_ITEM_ASSY_MAP(NULL)) XA) EA

     , SCP_MST_FINAL_ITEM FI

     , (SELECT SEGMENT1 AS OPERATION_ID

          FROM SCM_ADM_LOOKUP_MASTER_DETAIL

         WHERE LOOKUP_TYPE = 'FCS_INVENTORY_EXCEPTION_OPERATION'

           AND VALID_YN = 'Y'

         GROUP BY SEGMENT1) FX

 WHERE MP.RL_COMPANY_ID = SA.COMPANY_ID

   AND MP.RL_DIVISION_ID = SA.DIVISION_ID

   AND MP.RL_SITE_ID = SA.SITE_ID

   AND MP.RL_PLANT_ID = SA.PLANT_ID

   AND MP.RL_FACTORY_ID = SA.FACTORY_ID

   AND MP.RL_LINE_ID = SA.LINE_ID

   AND VI.COMPANY_ID = MP.VL_COMPANY_ID

   AND VI.DIVISION_ID = MP.VL_DIVISION_ID

   AND VI.SITE_ID = MP.VL_SITE_ID

   AND VI.ITEM_ID = CASE WHEN RTRIM(FI.PACKER_PLAN_ITEM_ID) IS NULL THEN TRIM(NVL(EA.CELL_ASSY_ITEM_ID, SA.ITEM_ID))

                         ELSE FI.PACKER_PLAN_ITEM_ID

                    END

   AND EA.COMPANY_ID(+) = SA.COMPANY_ID

   AND EA.DIVISION_ID(+) = SA.DIVISION_ID

   AND EA.SITE_ID(+) = SA.SITE_ID

   AND EA.PLANT_ID(+) = SA.PLANT_ID

   AND EA.SCP_EXC_ITEM_ID(+) = TRIM(SA.ITEM_ID)

   AND FI.DIVISION_ID(+) = SA.DIVISION_ID

   AND FI.ITEM_ID(+) = TRIM(NVL(EA.CELL_ASSY_ITEM_ID, SA.ITEM_ID))

   AND FX.OPERATION_ID(+) = SA.OPERATION_ID

   AND VI.SCP_OPERATION_GROUP = 'A'                                                 /* Cell(조립) */