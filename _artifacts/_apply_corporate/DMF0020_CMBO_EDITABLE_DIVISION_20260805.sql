-- =============================================================================
-- DMF0020_CMBO_EDITABLE_DIVISION_20260805.sql
-- 목적: DMF0020 편집 가능 division CMBO 'SalesFuturePriceEditableDivision' 등록 (❌미등재 해소)
--   FE utils/editableDivision.ts + SalesFuturePrice.tsx L110 이 이 CMBO 를 전제(fallback 없음 —
--   미등재 상태 = 편집 division 0 = 전면 편집 불가).
-- 규약: TO-BE 기존 'MktFcstEditableDivision'(DMF0003) 동일 패턴 — lookup DM_UI_EDITABLE_DIVISION
--   화이트리스트(ATTRIBUTE1='Y').
-- ⚠ 데이터 무변경 방침: 현재 lookup DMF0020 행 = 40:'N' / 81:'N' (82 행 없음) → 등록 후에도
--   편집 가능 division 0. 실제 편집 개방은 lookup ATTRIBUTE1='Y' 지정(운영 데이터 결정) 필요 —
--   AS-IS 기준이면 40 금지·81/82 허용.
-- 정책: INSERT-only(NOT EXISTS) 멱등 / 감사 'admin' / SQL_NM ≤100byte.
-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내 ②클라우드 QA ③클라우드 DEV
-- =============================================================================

INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'SalesFuturePriceEditableDivision'
 , 'DM'
 , 'DMF0020 편집가능 Division (ATTRIBUTE1=Y 화이트리스트)'
 , 'SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME' || CHR(10) ||
   'FROM SCM_ADM_LOOKUP_MASTER_DETAIL' || CHR(10) ||
   'WHERE LOOKUP_TYPE = ''DM_UI_EDITABLE_DIVISION''' || CHR(10) ||
   '  AND SEGMENT1 = ''DMF0020''' || CHR(10) ||
   '  AND ATTRIBUTE1 = ''Y''' || CHR(10) ||
   '  AND VALID_YN = ''Y''' || CHR(10) ||
   'ORDER BY SEGMENT2'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X
                  WHERE X.SQL_ID = 'SalesFuturePriceEditableDivision');

COMMIT;

-- ===== 검증 1: 등록 확인 =====
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'SalesFuturePriceEditableDivision';
-- ===== 검증 2: 현행 결과 시뮬 (현 데이터 기준 0행 = 정상 — ATTRIBUTE1 정책 지정 전) =====
SELECT SEGMENT2 AS CODE FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE LOOKUP_TYPE='DM_UI_EDITABLE_DIVISION' AND SEGMENT1='DMF0020' AND ATTRIBUTE1='Y' AND VALID_YN='Y';
