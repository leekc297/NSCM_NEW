--==============================================================================
-- 46_DMF0043_01_KO_Name_Update.sql  (SQL*Plus 본체)
--
-- 목적:
--   DMF0043_01 의 한글 메뉴명 변경 — '기여율 조회' → '해외법인 기여매출'
--   사용자 요청 (2026-06-01) — Figma frame name 의 한글 표기와 일치.
--
-- 영향 테이블:
--   - SCM_ADM_MSG_M : MSG_ID='MNU_DMF0043_01' / LANG_CD='KO' / MSG_NM 값 변경
--
-- 멱등성: UPDATE — 재실행 시 0 행 영향 (이미 변경된 값 그대로).
-- 작성: 2026-06-01
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 0 : 사전 카운트 + 현재 값 ===

SELECT 'PRE: MSG_NM' AS K, MSG_NM AS V
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0043_01' AND LANG_CD = 'KO';

PROMPT === BLOCK 1 : SCM_ADM_MSG_M UPDATE (KO 한글명) ===

UPDATE SCM_MGR.SCM_ADM_MSG_M
   SET MSG_NM           = '해외법인 기여매출'
     , MSG_DESC         = '해외법인 기여매출'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE MSG_ID = 'MNU_DMF0043_01'
   AND LANG_CD = 'KO';

PROMPT === BLOCK 2 : 사후 카운트 + 변경 값 ===

SELECT 'POST: MSG_NM' AS K, MSG_NM AS V
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0043_01' AND LANG_CD = 'KO';

COMMIT;

PROMPT === COMPLETE ===
EXIT;
