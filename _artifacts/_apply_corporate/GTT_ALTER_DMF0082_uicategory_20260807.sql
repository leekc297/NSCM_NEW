-- =====================================================================
-- DMF0082 uicategory — GTT 컬럼 확장 (2026-08-07)
-- 순서 제약: 메타(SHEET_COLUMNS) 반영 전에 반드시 선행 (동적 V_COLUMN ORA-00904 차단)
-- ⚠️ GTT ALTER = ORA-14450(타 세션 바인딩 중) 가능 — 실패 시 세션 소강 시점 재시도
-- 타입 정본: GT_DMF0003_MF (AS_YN 40 / VMI_STD_DIO 400 / NEW_FLAG 40) + ATTR1 은 4000 안전 상향
-- 원복: 잔존 무해 — DROP 하지 않음 (ROLLBACK_DMF0082_uicategory_20260807.sql [5])
-- =====================================================================

-- [1] GT_DMF0082_MF_SP (GET_MAIN_DATA 최종 소스, 75 → 79 컬럼)
ALTER TABLE SCM_MGR.GT_DMF0082_MF_SP ADD (
    AS_YN        VARCHAR2(40),
    ATTR1        VARCHAR2(4000),
    VMI_STD_DIO  VARCHAR2(400),
    NEW_FLAG     VARCHAR2(40)
);

-- [2] GTT_MF_SP (GET_MAIN_DATA_CURRENT 최종 소스, 58 → 72 컬럼)
--     Tier3 3(NEW_FLAG 기존재) + Tier1 9 + 잠복 ORA-00904 해소 2(AS_FROM_SITE/SENDER_NAME)
ALTER TABLE SCM_MGR.GTT_MF_SP ADD (
    AS_YN                VARCHAR2(40),
    ATTR1                VARCHAR2(4000),
    VMI_STD_DIO          VARCHAR2(400),
    BIZ_TYPE             VARCHAR2(200),
    PROJECT_STATUS       VARCHAR2(200),
    ENERGE               VARCHAR2(200),
    CELL_QUANTITY        NUMBER,
    CELL_PER_CAR         NUMBER,
    CELL_PER_MODULE      NUMBER,
    MODULE_PER_CAR       NUMBER,
    SENDER_CODE          VARCHAR2(200),
    SENDER_NAME          VARCHAR2(800),
    PROJECT_S_OP_REPORT  VARCHAR2(800),
    AS_FROM_SITE         VARCHAR2(200)
);

-- [3] GTT_TEMPFCSTNPRICE — ALTER 불필요 판정 (2026-08-07):
--     CURRENT 의 project/owner/sender 필터는 GTT_MF_SP 적재 완료 후 단일 DELETE 로 구현
--     (GTT_MF_SP 에 PROJECT_CODE/OWNER 기존재 + SENDER_CODE 는 [2] 에서 추가)

-- [검증]
SELECT TABLE_NAME, COUNT(*) COLS FROM USER_TAB_COLUMNS
 WHERE TABLE_NAME IN ('GT_DMF0082_MF_SP','GTT_MF_SP') GROUP BY TABLE_NAME;
