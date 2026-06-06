-- 46_DMF0043_01_KO_Name_Update_DBeaver.sql
-- 목적: DMF0043_01 한글 메뉴명 변경 (DBeaver 실행본 — SQL*Plus 명령 제거)
-- '기여율 조회' → '해외법인 기여매출'
-- 작성: 2026-06-01

-- PART 1 : 사전 값 확인
SELECT 'PRE: MSG_NM' AS K, MSG_NM AS V
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0043_01' AND LANG_CD = 'KO';

-- PART 2 : UPDATE
UPDATE SCM_MGR.SCM_ADM_MSG_M
   SET MSG_NM           = '해외법인 기여매출'
     , MSG_DESC         = '해외법인 기여매출'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE MSG_ID = 'MNU_DMF0043_01'
   AND LANG_CD = 'KO';

-- PART 3 : 사후 값 확인
SELECT 'POST: MSG_NM' AS K, MSG_NM AS V
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0043_01' AND LANG_CD = 'KO';

COMMIT;
