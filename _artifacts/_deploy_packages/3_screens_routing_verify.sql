--==============================================================================
-- 3_screens_routing_verify.sql
--
-- 목적: DMF0043_01 / DMF0008 / DMF0072 3 화면의 routing 등록 종합 검증
-- 실행: SCM_MGR / SCMD_APP 세션 모두 OK
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === VERIFY 1 : 3 화면 메뉴 등록 (SCM_ADM_MNU_M) ===

SELECT mnu_id, mnu_url, mnu_msg_id, upper_mnu_id, mnu_tp_cd, use_yn
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id IN ('DMF0043_01', 'DMF0008', 'DMF0072')
 ORDER BY mnu_id;

PROMPT === VERIFY 2 : MNU_URL slug 정합 ===

SELECT mnu_id, mnu_url,
       CASE mnu_id
         WHEN 'DMF0043_01' THEN CASE WHEN mnu_url = 'contribute-view'    THEN 'PASS' ELSE 'FAIL: expect contribute-view'    END
         WHEN 'DMF0008'    THEN CASE WHEN mnu_url = 'erp-edi-master'     THEN 'PASS' ELSE 'FAIL: expect erp-edi-master'     END
         WHEN 'DMF0072'    THEN CASE WHEN mnu_url = 'nn-master-mapping'  THEN 'PASS' ELSE 'FAIL: expect nn-master-mapping'  END
       END AS result
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id IN ('DMF0043_01', 'DMF0008', 'DMF0072');

PROMPT === VERIFY 3 : GUEST 메뉴 권한 ===

SELECT mnu_id,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
         WHERE USER_GR_ID = 'GUEST' AND MNU_ID = m.mnu_id) AS menu_perm_cnt,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
         WHERE USER_GR_ID = 'GUEST' AND MNU_ID = m.mnu_id) AS btn_perm_cnt
  FROM SCM_MGR.SCM_ADM_MNU_M m
 WHERE m.mnu_id IN ('DMF0043_01', 'DMF0008', 'DMF0072')
 ORDER BY mnu_id;

PROMPT === VERIFY 4 : BTN_MPG ↔ API_M ↔ PROC_M chain (3 화면 통합) ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD,
       BTN.API_ID AS BTN_API_ID, API.API_URL,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_M_COL_CNT,
       CASE WHEN API.API_URL IS NULL THEN 'FAIL: API_M missing'
            WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) = 0
              THEN 'FAIL: PROC_M missing'
            ELSE 'PASS' END AS RESULT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID IN ('DMF0043_01', 'DMF0008', 'DMF0072')
 ORDER BY BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD;

PROMPT === VERIFY 5 : 3 화면 SP 객체 STATUS ===

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0043_01_%'
        OR object_name LIKE 'DMF0008_%'
        OR object_name LIKE 'DMF0072_%'
        OR object_name = 'DMF0043_GET_CONT_VIEW_VERSIONPOPUP')
   AND object_type = 'PROCEDURE'
 ORDER BY object_name;

PROMPT === 판독 ===
PROMPT - VERIFY 1 3 row → 메뉴 등록 완료
PROMPT - VERIFY 2 3 row PASS → slug 정합
PROMPT - VERIFY 3 menu_perm_cnt = 1 / btn_perm_cnt > 0 (각 화면) → 권한 정상
PROMPT - VERIFY 4 모든 row RESULT=PASS → routing chain 정합
PROMPT - VERIFY 5 SP STATUS=VALID 모두 → OK
