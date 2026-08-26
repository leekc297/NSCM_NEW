-- ============================================================================================
-- PKG_DMF0022 조회 튜닝 — hook #129 ③ 인덱스 (제안만 / **적용하지 않음**)
--   구조 변경(①②④)만으로는 아래 3개 표의 TABLE ACCESS FULL 을 제거할 수 없었다.
--   사내 실측 근거는 각 항목의 주석 참조. DBA 검토 후 적용 여부 결정 필요.
--   ⚠ 힌트/optimizer 파라미터/강제 통계수집은 사용하지 않았고, 여기서도 제안하지 않는다.
-- ============================================================================================

-- ──────────────────────────────────────────────────────────────────────────────────────────
-- ③-1  DM_PLN_CFM_SELLING_PRICE  (1,069,693행 / 31,517블록)
--   사용처 : PKG_DMF0022 BODY  단가 조인(CURRENT · division 40)
--   현황   : TABLE ACCESS FULL, 유일한 필터가 C.YYYYMMDD <= :P_TO  (E-Rows 915K, 실측 disk 31,261)
--   PK     : (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID,
--             CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS)
--   왜 술어 추가만으로 안 되나 :
--     조인이 PK 3번째 컬럼 END_CUSTOMER 를 공급하지 않아 range 가 (DIVISION_ID, PROJECT_CODE)
--     에서 끊긴다. 실제로 division+기간 술어를 넣었더니 옵티마이저가 이 PK NL 로 전환하여
--     0.331s / 32,070 buffer  →  3.749s / 1,178,150 buffer 로 **악화**했다 (SQL_ID ftz4kvgxttgk9,
--     사내 2026-08-21 실측). 그래서 해당 술어는 철회했다.
--   제안   : END_CUSTOMER 를 건너뛴 조인키 순서의 보조 인덱스
CREATE INDEX SCM_MGR.IDX07_DM_PLN_CFM_SELLING_PRICE
    ON SCM_MGR.DM_PLN_CFM_SELLING_PRICE
       (DIVISION_ID, YYYYMMDD, ITEM_ID, SCM_SITE_ID, PROJECT_CODE) ONLINE;

-- ──────────────────────────────────────────────────────────────────────────────────────────
-- ③-2  SCM_MST_FUTURE_PRICE  (1,380,745행 / 30,720블록)
--   사용처 : PKG_DMF0022 BODY  단가 조인(CURRENT · division 40 외)
--   현황   : TABLE ACCESS FULL, 필터 C.YYYYMMDD <= :P_TO 뿐 (E-Rows 858K, 실측 disk 30,497)
--   기존 IX_YYYYMMDD_SCM_MST_FUTURE_PRICE(YYYYMMDD, DIVISION_ID) 가 있으나
--   division+하한 술어 추가 시 PK NL 로 뒤집혀 C2/C6 이 악화되어 철회함.
--   제안   : 조인키 정합 인덱스 (PK 와 달리 CURRENCY 를 뒤로 뺀 순서)
CREATE INDEX SCM_MGR.IDX02_SCM_MST_FUTURE_PRICE
    ON SCM_MGR.SCM_MST_FUTURE_PRICE
       (DIVISION_ID, YYYYMMDD, ITEM_ID, SCM_SITE_ID, PROJECT_CODE) ONLINE;

-- ──────────────────────────────────────────────────────────────────────────────────────────
-- ③-3  SCM_ITEM_M (= 시노님 SCM_MST_ITEM_SN, FP_MGR 소유, 788,924행 / 30,497블록)
--   사용처 : GT_DM22_DM_MST_ITEM_SINGLE_ORI_V 적재
--   현황   : TABLE ACCESS FULL (filter DIVISION_ID=:B1). 기존 인덱스는
--            PK(ITEM_ID, COMPANY_ID, DIVISION_ID, SITE_ID) / IX01(DIVISION_ID, ITEM_TYPE) 등으로
--            (DIVISION_ID, ITEM_ID) 선두 조합이 없다.
--   [E20260820-D22PREREDUCE] 로 GTT 적재행수는 243,050 → 수백 수준으로 줄였으나
--   원표 스캔 자체(물리 29,733 reads)는 인덱스 없이는 남는다 = 현재 잔여 물리 I/O 의 대부분.
--   ⚠ FP_MGR 소유 공용 마스터이므로 타 도메인 영향 검토 필수.
CREATE INDEX FP_MGR.IX04_SCM_ITEM_M
    ON FP_MGR.SCM_ITEM_M (DIVISION_ID, ITEM_ID) ONLINE;

-- ──────────────────────────────────────────────────────────────────────────────────────────
-- ③-4  DM_PLN_BP_FCST_C  (사내 6,768,311행 / **클라우드 58,335,432행 = 8.6배**)
--   사용처 : PKG_DMF0051 BODY  BP 버전 원장 적재 (L861~871)
--   현황   : TABLE ACCESS FULL. ④ 선행축소(버전 술어)는 **이미 적용돼 있으나** PK 가
--            (DIVISION_ID, VERSION_NO, SEQ_NO) 라 **기간(YYYYMM) 축이 없어** range 가
--            1.28M행에서 끊긴다. 사내 실측 0.88s / BG 190,196 / disk 178,700.
--   시도한 4형태 전부 FTS 유지 : IN 세미조인 / JOIN+DISTINCT / EXISTS / 단일버전 리터럴 등치
--   ⇒ 구조 변경만으로는 제거 불가 (한계). 기간 축을 붙인 복합 인덱스가 유일한 수단.
CREATE INDEX SCM_MGR.IX02_DM_PLN_BP_FCST_C
    ON SCM_MGR.DM_PLN_BP_FCST_C (DIVISION_ID, VERSION_NO, YYYYMM) ONLINE;
