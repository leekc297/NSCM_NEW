--------------------------------------------------------------------------------
-- 47_dmf0003_spreadtitle_routing.sql
-- DMF0003(mkt-fcst) — spreadTitle(동적 기간 헤더 SP) 라우팅 등록 [STEP 6]
--
-- 작성    : 2026-06-29
-- 대상 DB : 사내 Oracle  SCM_MGR @ 121.162.245.167:2521/OCGSCMD_P01
--
-- 배경/근거 (사내 READ 실측 2026-06-29):
--   FE useTabProcQuery 가 동적 기간 헤더를 callProc(DMF0003,'spreadTitle','SEARCH') 로 호출
--   (useCustomQueryClient.ts: procedureAction 기본 SEARCH). 그런데 'spreadTitle' 라우팅이
--   SCM_ADM_API_M / SCM_ADM_MNU_BTN_MPG_M / SCM_ADM_USER_GR_MNU_BTN_MPG_M 어디에도 없어
--   call-proc 응답 code != '0' → FE alert("권한없음"). 메인(Mkt Fcst/SEARCH)은 성공 → 데이터는 조회됨.
--   => 증상: "조회 시 권한없음 뜬 뒤 데이터 조회됨" + GET_SPREAD_TITLE 미작동으로 Weekly 주차 일부 누락.
--   PROC_M(DMF0003_GET_SPREAD_TITLE)=7행 이미 존재(script 36). API/BTN/USER_GR 만 누락 → 본 스크립트로 보완.
--
-- 부여 그룹 = DMF0003 의 다른 10개 버튼('Mkt Fcst')을 이미 보유한 동일 3그룹(ADMIN/DEMAND_USER/GUEST).
--   (신규 권한 확장이 아니라, 이미 DMF0003 전 버튼 권한을 가진 그룹에 내부 헤더 호출 1건 추가.)
--
-- 멱등: NOT EXISTS 가드. 적용주체 = 사용자(handoff).
--------------------------------------------------------------------------------
WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
SET DEFINE OFF;

-- [1] API_M — DMF0003_spreadTitle_SEARCH → DMF0003_GET_SPREAD_TITLE
INSERT INTO SCM_MGR.SCM_ADM_API_M
  (API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003_spreadTitle_SEARCH','PROC','MSG_API_DMF0003_SPREADTITLE_SEARCH',
       'DMF0003_GET_SPREAD_TITLE','Y','spreadtitle_reg',SYSDATE,'spreadtitle_reg',SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='DMF0003_spreadTitle_SEARCH');

-- [2] BTN_MPG — (DMF0003, spreadTitle, SEARCH) → API
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003','spreadTitle','SEARCH','DMF0003_spreadTitle_SEARCH','Y','spreadtitle_reg',SYSDATE,'spreadtitle_reg',SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
                    WHERE MNU_ID='DMF0003' AND SHT_NM='spreadTitle' AND MNU_BTN_CD='SEARCH');

-- [3] USER_GR 권한 미러 — 3그룹(ADMIN/DEMAND_USER/GUEST), DMF0003 다른 버튼과 동일 그룹셋
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT gg.g,'DMF0003','spreadTitle','SEARCH','Y','spreadtitle_reg',SYSDATE,'spreadtitle_reg',SYSDATE
  FROM (SELECT 'ADMIN' g FROM DUAL UNION ALL SELECT 'DEMAND_USER' FROM DUAL UNION ALL SELECT 'GUEST' FROM DUAL) gg
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
                    WHERE u.USER_GR_ID=gg.g AND u.MNU_ID='DMF0003'
                      AND u.SHT_NM='spreadTitle' AND u.MNU_BTN_CD='SEARCH');

COMMIT;

-- [검증]
PROMPT === API/BTN/USER_GR spreadTitle 등록 확인 ===
SELECT 'API' T, COUNT(*) C FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='DMF0003_spreadTitle_SEARCH'
UNION ALL SELECT 'BTN', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0003' AND SHT_NM='spreadTitle'
UNION ALL SELECT 'USERGR', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0003' AND SHT_NM='spreadTitle';

-- [원복] 필요 시
--   DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0003' AND SHT_NM='spreadTitle';
--   DELETE FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M       WHERE MNU_ID='DMF0003' AND SHT_NM='spreadTitle';
--   DELETE FROM SCM_MGR.SCM_ADM_API_M               WHERE API_ID='DMF0003_spreadTitle_SEARCH';
--   COMMIT;
PROMPT === 47 완료 ===
