-- =============================================================================
-- 02_FIX_CORP_DMF0003_SLUG.sql — 사내(OCGSCMD_P01) DMF0003 메뉴 슬러그 정정
-- ⚠️ 적용 전 필수: 01_CHECK_CLOUD_MENU_DMF0003.sql [1] 결과로 클라우드 실측값 확인 + 사용자 승인.
--    아래 신값은 FE 규약(페이지 폴더 'mkt-fcst') 기준 기대값 — 클라우드 실측이 다르면 실측값으로 교체.
-- 원인: 사내 MNU_URL='mkt_forecast'(언더스코어) → FE viewRegistry 폴더 'mkt-fcst' 매칭 실패 = 빈 화면.
--       (사내 35개 화면 중 유일 불일치 — 2026-07-29 전수 실측)
-- 멱등: 이미 정정된 경우 0 rows updated.
-- =============================================================================
SET SERVEROUTPUT ON

PROMPT === BEFORE ===
SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0003';

UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'mkt-fcst',
       ROUTE_PATH       = 'demand/demand-plan/mkt-fcst',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0003'
   AND (MNU_URL <> 'mkt-fcst' OR ROUTE_PATH <> 'demand/demand-plan/mkt-fcst');

COMMIT;

PROMPT === AFTER (mkt-fcst / demand/demand-plan/mkt-fcst 기대) ===
SELECT MNU_ID, MNU_URL, ROUTE_PATH, LAST_UPDATED_BY,
       TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID = 'DMF0003';

PROMPT === 사후: BE 재기동 불요(메뉴는 세션 로딩 시 조회) — 브라우저 재로그인 후 DMF0003 진입 확인
