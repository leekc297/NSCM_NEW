-- 46_DMF0043_01_KO_Name_Update_Diagnose.sql
-- 목적: 변경 실패 시 진단
-- 작성: 2026-06-01

-- D1 : 대상 row 존재 여부
SELECT 'ROW_EXISTS' AS K, COUNT(*) AS V
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0043_01' AND LANG_CD = 'KO';

-- D2 : 모든 lang 의 현재 값
SELECT MSG_ID, LANG_CD, MSG_NM, MSG_DESC, USE_YN, LAST_UPDATE_DATE
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0043_01'
 ORDER BY LANG_CD;

-- D3 : MNU_M 의 MNU_MSG_ID 매핑 확인 (MSG 변경 후 메뉴 렌더링 의존성)
SELECT M.MNU_ID, M.MNU_URL, M.MNU_MSG_ID, M.UPPR_MNU_ID, M.SORT_ORD, M.USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M M
 WHERE M.MNU_ID = 'DMF0043_01';

-- D4 : Figma file 의 frame name 과 한글명 일치 cross-check
--      Figma: 'Master > Demand Master > 해외법인 기여매출' (Doc/_figma/screens/DMF0043_01.md)
--      DB:    SCM_ADM_MSG_M.MSG_NM (LANG_CD='KO')
SELECT '해외법인 기여매출' AS FIGMA_FRAME_NAME, MSG_NM AS DB_KO_NAME,
       CASE WHEN MSG_NM = '해외법인 기여매출' THEN 'ALIGNED' ELSE 'MISMATCH' END AS RESULT
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0043_01' AND LANG_CD = 'KO';
