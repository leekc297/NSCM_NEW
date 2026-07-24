-- =====================================================================
-- DMF0042 — MNU_URL 'dmf0042'(임시명) → 'business-plan' 교체 + ROUTE_PATH 재파생 (G11, 2026-07-21)
--
-- 배경: P1(2026-07-15)의 교체분이 현행 실측에서 'dmf0042' 로 잔존(미반영/롤백) —
--   ROUTE_PATH='demand/demand-plan/dmf0042'. 신아키텍처(viewRegistry mnuId 1차)라 화면 오픈 무영향이나
--   타 화면 kebab 명명 일관 + ROUTE_PATH 파생값 정리 (사용자 승인 2026-07-21).
--   충돌 0 실측: MNU_URL='business-plan' 사용 행 없음 (2026-07-15 P1 실측 + 금일 46행 인벤토리).
-- FE 짝: apps/web/src/mdi/viewRegistry.tsx SLUG_ALIAS 에 'business-plan' 추가('dmf0042' 도 유지 — 이중 안전망).
-- 멱등: WHERE 가 구값 한정 — 재실행 시 0행 무해. ROUTE_PATH 파생은 계층 고정값.
-- =====================================================================

-- ① MNU_URL 교체
UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL = 'business-plan', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0042' AND MNU_URL = 'dmf0042';

-- ② ROUTE_PATH 재파생 (DMF0042 1행 한정 — 계층 SYS_CONNECT_BY_PATH, populate SQL 과 동일 식)
UPDATE SCM_MGR.SCM_ADM_MNU_M t
   SET t.ROUTE_PATH = (
         SELECT LTRIM(SYS_CONNECT_BY_PATH(s.MNU_URL, '/'), '/')
         FROM   SCM_MGR.SCM_ADM_MNU_M s
         WHERE  s.MNU_ID = t.MNU_ID
         START WITH s.UPPR_MNU_ID IS NULL OR TRIM(s.UPPR_MNU_ID) IS NULL
         CONNECT BY PRIOR s.MNU_ID = s.UPPR_MNU_ID
       ),
       t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
 WHERE t.MNU_ID = 'DMF0042';

COMMIT;

-- ── 검증 (기대: MNU_URL='business-plan' / ROUTE_PATH='demand/demand-plan/business-plan') ──
-- SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0042';

-- ── 원복 ──
-- UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='dmf0042',
--   ROUTE_PATH='demand/demand-plan/dmf0042', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
--  WHERE MNU_ID='DMF0042'; COMMIT;
-- =====================================================================
