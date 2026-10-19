        /*[E20260930-DMF0042SETZERO] ② 수량(Business_Plan)만 온 신규 키·월 → LOC 0 생성 — 사용자 결정 2026-09-30 "세트 첫 행이 오면 세트 전체를 0 으로 일괄 생성, 이후 실제 값이 오면 수정".
           GTT 에 Business_Plan(I/M) 가 있는 키·월에 LOC 가 GTT 에도 원장에도 없으면 LOC = 0 행을 GTT 에 만든다
           ('D' 행 제외 · 원장에 이미 있으면 그대로 둔다 = 실제 값 보존). 뒤의 원장 삽입·SalesAmt 파생은 무수정 */
        INSERT /*+ NO_PARALLEL */
          INTO GT_SDPB2_BP_FCST_4
             ( ACTIVE_FLAG, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, ITEM_USE, UNIT_ENERGY, MEASURE, YYYYMM, CURRENCY, QTY, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE, CREATED_BY, LAST_UPDATED_BY )
        SELECT MAX(B.ACTIVE_FLAG), B.DIVISION_ID, B.PROJECT_CODE, MAX(B.PROJECT_NAME), B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID
             , B.FCST_TYPE, B.INCOTERMS, B.ITEM_USE, B.UNIT_ENERGY, 'LOC', B.YYYYMM, B.CURRENCY, 0
             , B.DEPT_ID, B.END_CUSTOMER, B.BIZ_TYPE, B.CELL_PROD_SITE, MAX(B.CREATED_BY), MAX(B.LAST_UPDATED_BY)
          FROM GT_SDPB2_BP_FCST_4 B
         WHERE B.MEASURE = 'Business_Plan'
           AND B.ACTIVE_FLAG IN ('I', 'M')
           AND NOT EXISTS (SELECT 1 FROM GT_SDPB2_BP_FCST_4 C
                           WHERE C.MEASURE = 'LOC'
                          AND C.DIVISION_ID = B.DIVISION_ID
                          AND C.PROJECT_CODE = B.PROJECT_CODE
                          AND C.SCM_SITE_ID = B.SCM_SITE_ID
                          AND C.PLANT_SITE_ID = B.PLANT_SITE_ID
                          AND C.ITEM_ID = B.ITEM_ID
                          AND C.FCST_TYPE = B.FCST_TYPE
                          AND C.INCOTERMS = B.INCOTERMS
                          AND C.ITEM_USE = B.ITEM_USE
                          AND C.UNIT_ENERGY = B.UNIT_ENERGY
                          AND C.YYYYMM = B.YYYYMM
                          AND C.CURRENCY = B.CURRENCY
                          AND C.DEPT_ID = B.DEPT_ID
                          AND C.END_CUSTOMER = B.END_CUSTOMER
                          AND C.BIZ_TYPE = B.BIZ_TYPE
                          AND C.CELL_PROD_SITE = B.CELL_PROD_SITE)
           AND NOT EXISTS (SELECT 1 FROM DM_PLN_BP_FCST A
                           WHERE A.MEASURE = 'LOC'
                          AND A.DIVISION_ID = B.DIVISION_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND A.SCM_SITE_ID = B.SCM_SITE_ID
                          AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                          AND A.ITEM_ID = B.ITEM_ID
                          AND A.FCST_TYPE = B.FCST_TYPE
                          AND A.INCOTERMS = B.INCOTERMS
                          AND A.ITEM_USE = B.ITEM_USE
                          AND A.UNIT_ENERGY = B.UNIT_ENERGY
                          AND A.YYYYMM = B.YYYYMM
                          AND A.CURRENCY = B.CURRENCY
                          AND A.DEPT_ID = B.DEPT_ID
                          AND A.END_CUSTOMER = B.END_CUSTOMER
                          AND A.BIZ_TYPE = B.BIZ_TYPE
                          AND A.CELL_PROD_SITE = B.CELL_PROD_SITE)
         GROUP BY B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.FCST_TYPE, B.INCOTERMS, B.ITEM_USE
                , B.UNIT_ENERGY, B.YYYYMM, B.CURRENCY, B.DEPT_ID, B.END_CUSTOMER, B.BIZ_TYPE, B.CELL_PROD_SITE;

        /*[E20260930-DMF0042SETZERO] ④ 단가(LOC)만 온 신규 키·월 → Business_Plan 0 생성 — 사용자 결정 2026-09-30 "세트 첫 행이 오면 세트 전체를 0 으로 일괄 생성, 이후 실제 값이 오면 수정".
           GTT 에 LOC(I/M) 가 있는 키·월에 Business_Plan 가 GTT 에도 원장에도 없으면 Business_Plan = 0 행을 GTT 에 만든다
           ('D' 행 제외 · 원장에 이미 있으면 그대로 둔다 = 실제 값 보존). 뒤의 원장 삽입·SalesAmt 파생은 무수정 */
        INSERT /*+ NO_PARALLEL */
          INTO GT_SDPB2_BP_FCST_4
             ( ACTIVE_FLAG, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, ITEM_USE, UNIT_ENERGY, MEASURE, YYYYMM, CURRENCY, QTY, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE, CREATED_BY, LAST_UPDATED_BY )
        SELECT MAX(B.ACTIVE_FLAG), B.DIVISION_ID, B.PROJECT_CODE, MAX(B.PROJECT_NAME), B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID
             , B.FCST_TYPE, B.INCOTERMS, B.ITEM_USE, B.UNIT_ENERGY, 'Business_Plan', B.YYYYMM, B.CURRENCY, 0
             , B.DEPT_ID, B.END_CUSTOMER, B.BIZ_TYPE, B.CELL_PROD_SITE, MAX(B.CREATED_BY), MAX(B.LAST_UPDATED_BY)
          FROM GT_SDPB2_BP_FCST_4 B
         WHERE B.MEASURE = 'LOC'
           AND B.ACTIVE_FLAG IN ('I', 'M')
           AND NOT EXISTS (SELECT 1 FROM GT_SDPB2_BP_FCST_4 C
                           WHERE C.MEASURE = 'Business_Plan'
                          AND C.DIVISION_ID = B.DIVISION_ID
                          AND C.PROJECT_CODE = B.PROJECT_CODE
                          AND C.SCM_SITE_ID = B.SCM_SITE_ID
                          AND C.PLANT_SITE_ID = B.PLANT_SITE_ID
                          AND C.ITEM_ID = B.ITEM_ID
                          AND C.FCST_TYPE = B.FCST_TYPE
                          AND C.INCOTERMS = B.INCOTERMS
                          AND C.ITEM_USE = B.ITEM_USE
                          AND C.UNIT_ENERGY = B.UNIT_ENERGY
                          AND C.YYYYMM = B.YYYYMM
                          AND C.CURRENCY = B.CURRENCY
                          AND C.DEPT_ID = B.DEPT_ID
                          AND C.END_CUSTOMER = B.END_CUSTOMER
                          AND C.BIZ_TYPE = B.BIZ_TYPE
                          AND C.CELL_PROD_SITE = B.CELL_PROD_SITE)
           AND NOT EXISTS (SELECT 1 FROM DM_PLN_BP_FCST A
                           WHERE A.MEASURE = 'Business_Plan'
                          AND A.DIVISION_ID = B.DIVISION_ID
                          AND A.PROJECT_CODE = B.PROJECT_CODE
                          AND A.SCM_SITE_ID = B.SCM_SITE_ID
                          AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                          AND A.ITEM_ID = B.ITEM_ID
                          AND A.FCST_TYPE = B.FCST_TYPE
                          AND A.INCOTERMS = B.INCOTERMS
                          AND A.ITEM_USE = B.ITEM_USE
                          AND A.UNIT_ENERGY = B.UNIT_ENERGY
                          AND A.YYYYMM = B.YYYYMM
                          AND A.CURRENCY = B.CURRENCY
                          AND A.DEPT_ID = B.DEPT_ID
                          AND A.END_CUSTOMER = B.END_CUSTOMER
                          AND A.BIZ_TYPE = B.BIZ_TYPE
                          AND A.CELL_PROD_SITE = B.CELL_PROD_SITE)
         GROUP BY B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.FCST_TYPE, B.INCOTERMS, B.ITEM_USE
                , B.UNIT_ENERGY, B.YYYYMM, B.CURRENCY, B.DEPT_ID, B.END_CUSTOMER, B.BIZ_TYPE, B.CELL_PROD_SITE;

