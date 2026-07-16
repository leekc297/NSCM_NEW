-- =====================================================================
-- DMF0074 — 사업부 40 최신 SP_W 버전에 MRF('Y') 플래그 부여
-- 배경: Excel Form 템플릿 SP 와 업로드 검증(C19)이 서로 다른 버전을 참조하여
--       내려받은 모든 행이 'Invalid Sales Plan Waterfall MODEL.' 로 탈락.
--       템플릿 SP 는 MRF 필터를 복원(PKG_DMF0074 L613)했고, 본 스크립트는
--       현행 최신 버전에 MRF 플래그를 부여해 운영과 동일한 상태로 맞춘다.
-- 실측: 마지막 ATTRIBUTE7='Y' = SP_W_20260122_V001 (2026-01-22) — 해당 버전의
--       DM_PLN_SALES_PLAN_C / _RESULT_C 데이터 0건 → 어떤 행도 업로드 불가 상태였음.
-- 영향: DIVISION_ID='40' 1행. (81/82 계열은 미변경)
-- =====================================================================

-- BEFORE: ATTRIBUTE7 = NULL / LAST_UPDATED_BY = 'system' / LAST_UPDATE_DATE = 2026-05-15 23:43
UPDATE SCM_MGR.DM_MST_VERSION
   SET ATTRIBUTE7       = 'Y'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE VERSION_TYPE = 'SP_W'
   AND DIVISION_ID  = '40'
   AND VERSION_NO   = 'SP_W_20260515_V001';

COMMIT;

-- 원복 (ROLLBACK SCRIPT — 필요 시 수동 실행)
-- UPDATE SCM_MGR.DM_MST_VERSION
--    SET ATTRIBUTE7 = NULL, LAST_UPDATED_BY = 'system'
--  WHERE VERSION_TYPE = 'SP_W' AND DIVISION_ID = '40' AND VERSION_NO = 'SP_W_20260515_V001';
-- COMMIT;
