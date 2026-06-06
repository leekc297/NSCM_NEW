--==============================================================================
-- 080_DMF0008_NoPermission_Diagnose.sql
--
-- 목적:
--   (1) 070 fix 적용 후 PROC_M 정합 확인
--   (2) minyonglee1 권한 그룹 확인 ("No Permission" 원인)
--   (3) DMF0008_GET_MY_DIVISION_LIST 대체 SP 검색 (cloud 에 미존재)
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : 070 fix 적용 후 DMF0008_GET_UPDATE_HISTORY PROC_M 인벤토리 ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_UPDATE_HISTORY'
 ORDER BY sort_ord, col_nm;

PROMPT === DIAG 2 : DMF0008_GET_MY_DIVISION_LIST 다른 owner / synonym 검색 ===

SELECT owner, object_name, object_type, status
  FROM all_objects
 WHERE object_name LIKE 'DMF0008%DIVISION%'
    OR object_name LIKE '%MY_DIVISION%'
    OR object_name LIKE 'PR%DIVISION%LIST%'
 ORDER BY owner, object_name;

PROMPT === DIAG 3 : 'division' lookup 으로 사용 가능한 SP 후보 (DMF0072 도 동일 사용) ===

SELECT owner, object_name, object_type, status
  FROM all_objects
 WHERE object_type = 'PROCEDURE'
   AND status = 'VALID'
   AND (object_name LIKE '%GET_MY_DIVISION%'
        OR object_name LIKE '%DIVISION_LIST%'
        OR object_name LIKE '%GET_DIV%')
 ORDER BY owner, object_name
 FETCH FIRST 20 ROWS ONLY;

PROMPT === DIAG 4 : minyonglee1 사용자 권한 그룹 (USER_GR_MPG_M) ===

SELECT user_id, user_gr_id, use_yn, valid_yn
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
 WHERE user_id = 'minyonglee1'
 ORDER BY user_gr_id;

PROMPT === DIAG 5 : minyonglee1 권한 그룹의 DMF0008 메뉴/버튼 권한 ===

SELECT 'MENU_PERM' AS check_item, ugr.user_gr_id,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
         WHERE USER_GR_ID = ugr.user_gr_id AND MNU_ID = 'DMF0008') AS cnt,
       'expect >= 1' AS note
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M ugr
 WHERE ugr.user_id = 'minyonglee1'
 UNION ALL
SELECT 'BTN_PERM', ugr.user_gr_id,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
         WHERE USER_GR_ID = ugr.user_gr_id AND MNU_ID = 'DMF0008'),
       'expect >= 13 (DMF0008 btn 수)'
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M ugr
 WHERE ugr.user_id = 'minyonglee1';

PROMPT === DIAG 6 : DMF0008/division/SEARCH 가 어느 권한 그룹에 등록되어 있는지 ===

SELECT USER_GR_ID,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B
         WHERE B.USER_GR_ID = X.USER_GR_ID AND B.MNU_ID = 'DMF0008'
           AND B.SHT_NM = 'division' AND B.MNU_BTN_CD = 'SEARCH') AS division_perm
  FROM SCM_MGR.SCM_ADM_USER_GR_M X
 WHERE EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B
    WHERE B.USER_GR_ID = X.USER_GR_ID AND B.MNU_ID = 'DMF0008'
      AND B.SHT_NM = 'division' AND B.MNU_BTN_CD = 'SEARCH'
 );

PROMPT === DIAG 7 : DMF0008 전체 chain (070 fix 후 division 포함) ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD,
       BTN.API_ID AS BTN_API_ID, API.API_URL,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) AS PROC_M_CNT,
       (SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND object_name = API.API_URL) AS SP_EXISTS,
       CASE WHEN (SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND object_name = API.API_URL) = 0
              THEN 'FAIL: SP body missing'
            WHEN (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = API.API_URL) = 0
              THEN 'FAIL: PROC_M missing'
            ELSE 'PASS' END AS RESULT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0008'
 ORDER BY BTN.SHT_NM, BTN.MNU_BTN_CD;

PROMPT === 판독 ===
PROMPT - DIAG 1 row 3 (sesUserId/mnuId/o_rc1, SORT 1/2/3) → 070 fix 정합 OK
PROMPT - DIAG 1 row 5 그대로 → 070 fix 미적용 (재실행 필요)
PROMPT - DIAG 2/3 DMF0008_GET_MY_DIVISION_LIST 미존재 + 대체 SP 검색 → division 호출 routing 재검토
PROMPT - DIAG 4 minyonglee1 의 권한 그룹 (예: SCM_USER) — 'GUEST' 가 아니라면 GUEST 권한만 등록한 fix 효과 없음
PROMPT - DIAG 5 menu_perm/btn_perm 0 → minyonglee1 의 그룹에 DMF0008 권한 추가 필요
PROMPT - DIAG 7 SP_EXISTS=0 행 = "FAIL: SP body missing" → 그 sheet 의 SP 별도 작성 또는 routing 변경
