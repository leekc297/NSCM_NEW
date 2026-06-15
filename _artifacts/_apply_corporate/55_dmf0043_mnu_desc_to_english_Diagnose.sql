-- ============================================================================
-- 55. DMF0043 / DMF0043_01 — MNU_DESC 한글 → 영문 (DIAGNOSE)
-- ----------------------------------------------------------------------------
-- 목적   : UPDATE 전 현재 상태 점검
-- 작성   : 2026-06-15 (클라우드 메뉴 한글 잔존 사고)
-- 대상   : 사내 Oracle (121.162.245.167:2521/ESSCMD), user SCM_MGR
-- 원인   : SCM_ADM_MSG_M.MNU00030/00031 은 영문화 됐으나 SCM_ADM_MNU_M.MNU_DESC
--          가 한글 그대로 → 클라우드 FE 의 i18n key 부재 시 fallback 으로
--          MNU_DESC 한글이 그대로 화면에 표시 (`t(mnuMsgId, mnuDesc)` 패턴)
-- ============================================================================

-- 1. 현재 MNU_DESC (한글이어야 함)
SELECT MNU_ID, MNU_DESC, MNU_MSG_ID
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0043','DMF0043_01');

-- 2. i18n MSG_M (이미 영문화 — 사용자가 다국어 UI 에서 변경 완료)
SELECT MSG_ID, LANG_CD, MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MNU00030','MNU00031')
 ORDER BY MSG_ID, LANG_CD;

-- 3. 자매 화면 영문 사례 (UPDATE 후 값과 정합성 확인용)
SELECT MNU_ID, MNU_DESC, MNU_MSG_ID
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID LIKE 'DMF004%'
 ORDER BY MNU_ID;
