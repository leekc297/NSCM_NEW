-- ============================================================================
-- [Step 0 — 적용 전 선행 확인] DMF0082 환율 Modal 저장 — 클라우드 PREREQ
-- 아래 오브젝트가 없거나 INVALID 면 본 패키지 적용 전 선행 이관 필요
-- (deploy-package-completeness §4.6 #3 — 교차 PKG 의존 확인)
-- ============================================================================

-- [1] 교차 PKG 의존: PKG_DMF0000 BODY 가 호출하는 PKG_DMF0020
--     (P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION — 저장 후 Sales Price 재계산)
--     기대: PACKAGE + PACKAGE BODY 2행 모두 VALID.
--     ⚠ 미존재/INVALID → DMF0020 패키지(클라우드 기이관분) 선적용 후 본 패키지 진행.
--       본 패키지에 PKG_DMF0020 을 동봉하지 않은 사유: DMF0020 계열 패키지가 BODY
--       최신본의 단일 출처 (§4.6 #4 — 동일 PKG 를 복수 패키지가 갱신하는 충돌 방지)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
 WHERE OBJECT_NAME = 'PKG_DMF0020' ORDER BY OBJECT_TYPE;

-- [2] 공유 인프라 (전 화면 공통 — 기존재 기대)
--     기대: 각 1행 이상 존재
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('PR_SCM_SYS_LOG_BATCH',           -- 공통 로그 proc
                       'SCM_MST_DIVISION',               -- Division 검증 (SAVE SP)
                       'SCM_ADM_USER_MNU_EDIT_AUTH_V',   -- EDIT_YN view (GET SP)
                       'SCM_ADM_LOOKUP_MASTER_DETAIL',   -- CurrencyList lookup
                       'SCM_SYS_CALENDAR_M',             -- SPREAD_TITLE (PKG 내 GET)
                       'SCM_MST_SHEET_COLUMNS',
                       'SCM_MST_TITLESET_USER',
                       'SCM_SYS_LOG_BATCH')
 ORDER BY OBJECT_NAME, OBJECT_TYPE;

-- [3] 조회측 기배선 확인 (이 패키지 이전에 이미 클라우드 배선돼 있어야 정상)
--     기대: DMF0082_futurePriceInfo_SEARCH / _IF 2행
SELECT API_ID, API_URL, USE_YN FROM SCM_ADM_API_M
 WHERE API_ID IN ('DMF0082_futurePriceInfo_SEARCH', 'DMF0082_futurePriceInfo_IF');

-- [4] CurrencyList 콤보 (Insert 행 Currency/Unit 콤보 원천)
--     기대: 1행 (USE_YN='Y')
SELECT SQL_ID, USE_YN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'CurrencyList';
