-- =============================================================================
-- 01_CHECK_CLOUD_MENU_DMF0003.sql — 클라우드 Oracle 에서 실행 (read-only)
-- 목적: DMF0003 메뉴 배선을 사내와 비교 — "클라우드는 UI 표시 / 사내는 미표시" 원인 대조
--
-- 사내(OCGSCMD_P01) 실측 (2026-07-29):
--   DMF0003 | UPPR=Demand_Plan | MNU_URL='mkt_forecast' | ROUTE_PATH='demand/demand-plan/mkt_forecast'
--   | SCREEN | USE_YN=Y | MNU_MSG_ID=MNU00182 | 부모체인(Demand_Plan→Demand) 모두 USE_YN=Y
--   → FE viewRegistry 는 ①ROUTE_PATH ②MNU_URL 마지막 세그먼트로 페이지 폴더('mkt-fcst') 매칭.
--     사내는 'mkt_forecast'(언더스코어)라 매칭 실패 = 빈 화면. 사내 35개 화면 중 유일한 불일치.
--   → 클라우드 [1] 의 MNU_URL/ROUTE_PATH 값이 'mkt-fcst' 계열이면 그 값으로 사내 1행만 정정(02 스크립트).
--     ⚠️ MENU 테이블 통째 이관은 불필요·비권장 (사내 34개 정합 행 + 사내 전용 변경 덮어쓰기 위험).
-- =============================================================================
SET PAGESIZE 200 LINESIZE 220 TRIMSPOOL ON
COLUMN MNU_ID FORMAT A12
COLUMN UPPR_MNU_ID FORMAT A14
COLUMN MNU_URL FORMAT A28
COLUMN ROUTE_PATH FORMAT A42
COLUMN MNU_TP_CD FORMAT A9
COLUMN USE_YN FORMAT A6
COLUMN MNU_MSG_ID FORMAT A10

PROMPT === [1] DMF0003 행 (사내와 컬럼 단위 비교 — 핵심) ===
SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, MNU_TP_CD, UNIT_TP_CD, USE_YN,
       MNU_MSG_ID, SORT_ORD, MNU_LV_NO,
       LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI') UPD
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID = 'DMF0003';

PROMPT === [2] DMF0003 부모 체인 (전 단계 USE_YN='Y' 기대) ===
SELECT LEVEL LV, MNU_ID, UPPR_MNU_ID, MNU_TP_CD, USE_YN, MNU_URL
  FROM SCM_ADM_MNU_M
 START WITH MNU_ID = 'DMF0003'
CONNECT BY PRIOR UPPR_MNU_ID = MNU_ID;

PROMPT === [3] 전 SCREEN/POPUP 행 슬러그 인벤토리 (사내 전수 대조용 — 결과 전체 회신 요망) ===
SELECT MNU_ID, MNU_URL, ROUTE_PATH, MNU_TP_CD, USE_YN
  FROM SCM_ADM_MNU_M
 ORDER BY MNU_TP_CD, MNU_ID;

PROMPT === [4] DMF0003 메뉴 라벨 (MNU_MSG_ID 등록 여부) ===
SELECT MSG_ID, LANG_CD, MSG_NM, USE_YN
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID = (SELECT MNU_MSG_ID FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0003');

PROMPT === 판독 ===
PROMPT [1] 의 MNU_URL/ROUTE_PATH 가 사내('mkt_forecast')와 다르고 'mkt-fcst' 계열이면 → 원인 확정.
PROMPT 사내 정정은 본 폴더 02_FIX_CORP_DMF0003_SLUG.sql (클라우드 실측값 확인 후 적용 — 승인 필요).
