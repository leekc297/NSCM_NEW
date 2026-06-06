--==============================================================================
-- 020_Meta_Chain_Verify.sql (DMF0072)
--==============================================================================
SET LINESIZE 250

PROMPT === VERIFY 1 : DMF0072 MNU_URL slug 정합 ===

SELECT mnu_id, mnu_url,
       CASE WHEN mnu_url = 'nn-master-mapping' THEN 'PASS' ELSE 'FAIL' END AS result
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id = 'DMF0072';

PROMPT === VERIFY 2 : DMF0072 BTN_MPG ↔ API_M ↔ PROC_M chain ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD,
       BTN.API_ID AS BTN_API_ID, API.API_URL,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_M_COL_CNT,
       CASE WHEN API.API_URL IS NULL THEN 'FAIL: API_M missing'
            WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) = 0
              THEN 'FAIL: PROC_M missing'
            ELSE 'PASS' END AS RESULT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0072'
 ORDER BY BTN.SHT_NM, BTN.MNU_BTN_CD;

PROMPT === VERIFY 3 : CMBO_SQL_M (DMF0072 lookup combo SQL) 등록 ===

SELECT sql_id, division_id, valid_yn
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE sql_id LIKE '%DMF0072%' OR sql_id LIKE '%DATA_TYPE%' OR sql_id LIKE '%TEAM%'
 ORDER BY sql_id;

PROMPT === VERIFY 4 : GUEST 권한 ===

SELECT 'MENU' AS type,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
         WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0072') AS cnt FROM DUAL
UNION ALL
SELECT 'BTN',
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
         WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0072') FROM DUAL;
