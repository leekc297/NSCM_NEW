-- ============================================================================
-- SCM0008 (Auth Request) — Dead placeholder 메타 cleanup
-- 작성: 2026-06-04
-- 사유: 이전 세션이 P_SCM0008_* placeholder 7 entries 를 신규 등록했으나,
--       PKG_SYS0011 (6 SP) 이 이미 deploy + 메타 wire 되어 있음을 인지하지 못함.
--       FE 는 useTabProcQuery(default SEARCH) + useProcMutation(default SAVE) 만 사용 →
--       RETRIEVE/ADD/DELETE/REQUEST entries 는 모두 dead code (호출되지 않음).
--
-- 삭제 대상 (FE 호출 경로 확인 — 모두 dead):
--   1. API_SCM0008_GET_USER_INFO       (userInfo/RETRIEVE)
--   2. API_SCM0008_GET_AUTH_GROUP      (authority/RETRIEVE)
--   3. API_SCM0008_GET_DIVISION        (division/RETRIEVE)
--   4. API_SCM0008_GET_MY_AUTH         (myAuthorityList/RETRIEVE)
--   5. API_SCM0008_ADD_MY_AUTH         (myAuthorityList/ADD)
--   6. API_SCM0008_DELETE_MY_AUTH      (myAuthorityList/DELETE)
--   7. API_SCM0008_REQUEST_AUTH        (myAuthorityList/REQUEST)
--
-- 유지 entries (SCM0008 화면 실제 호출 — PKG_SYS0011 wire):
--   - SYS0011_GET_AUTH_DATA / GET_DIVISION_DATA / GET_MY_AUTH_DATA / GET_USER_INFO_DATA (SEARCH)
--   - SYS0011_SAVE_MY_AUTH_DATA / SAVE_USER_INFO_DATA (SAVE)
-- ============================================================================

-- BLOCK 1: MNU_BTN_MPG_M dead entries 삭제
DELETE FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'SYS0011'
   AND API_ID IN (
       'API_SCM0008_GET_USER_INFO',
       'API_SCM0008_GET_AUTH_GROUP',
       'API_SCM0008_GET_DIVISION',
       'API_SCM0008_GET_MY_AUTH',
       'API_SCM0008_ADD_MY_AUTH',
       'API_SCM0008_DELETE_MY_AUTH',
       'API_SCM0008_REQUEST_AUTH'
   );

-- BLOCK 2: API_M dead entries 삭제
DELETE FROM SCM_ADM_API_M
 WHERE API_ID IN (
       'API_SCM0008_GET_USER_INFO',
       'API_SCM0008_GET_AUTH_GROUP',
       'API_SCM0008_GET_DIVISION',
       'API_SCM0008_GET_MY_AUTH',
       'API_SCM0008_ADD_MY_AUTH',
       'API_SCM0008_DELETE_MY_AUTH',
       'API_SCM0008_REQUEST_AUTH'
   );

-- BLOCK 3: PROC_M dead entries 삭제 (P_SCM0008_* placeholder 이름들)
DELETE FROM SCM_ADM_PROC_M
 WHERE PROC_NM IN (
       'P_SCM0008_GET_CURRENT_USER',
       'P_SCM0008_GET_AUTH_GROUP_INFO',
       'P_SCM0008_GET_DIVISION_LIST',
       'P_SCM0008_GET_MY_AUTH_LIST',
       'P_SCM0008_ADD_MY_AUTH',
       'P_SCM0008_DELETE_MY_AUTH',
       'P_SCM0008_REQUEST_AUTH'
   );

COMMIT;

PROMPT === Verify (after cleanup) ===
PROMPT --- SCM0008 (SYS0011) MNU_BTN_MPG (should show only PKG_SYS0011 wires)
SELECT SHT_NM, MNU_BTN_CD, API_ID FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'SYS0011' ORDER BY SHT_NM, MNU_BTN_CD;
PROMPT --- API_M dead entries (should be 0)
SELECT COUNT(*) AS DEAD_API_REMAINING FROM SCM_ADM_API_M WHERE API_ID LIKE 'API_SCM0008%';
PROMPT --- PROC_M placeholder entries (should be 0)
SELECT COUNT(*) AS DEAD_PROC_REMAINING FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'P_SCM0008%';
