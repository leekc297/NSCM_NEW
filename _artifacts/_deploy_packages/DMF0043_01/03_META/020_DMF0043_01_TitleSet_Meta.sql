--==============================================================================
-- 48_DMF0043_01_TitleSet_Meta.sql  (SQL*Plus 본체)
--
-- 목적:
--   AS-IS DM0002_TitleSetForm_Popup 공통기능 — DMF0043_01 (Contribute View) 의
--   '컬럼 표시 설정' 모달이 호출하는 SP DMF0002_GET_TITLESET_POPUP 메타 등록.
--
-- 영향 테이블 (4 블록):
--   B1  SCM_ADM_MSG_M           : API 메시지 1 행 (KO)
--   B2  SCM_ADM_API_M           : API 정의 1 행
--   B3  SCM_ADM_MNU_BTN_MPG_M   : DMF0043_01 sheet 'titleSet' / SEARCH 매핑
--   B4  SCM_ADM_USER_GR_MNU_BTN_MPG_M : GUEST 권한
--   B5  SCM_ADM_PROC_M          : 인자 매핑 8 행
--   B6  사후 카운트
--
-- AS-IS 호출 (.cs L243~250):
--   request = new FoxDataRequest("DM.DMF0002_GET_TITLESET_POPUP");
--   request.Parameters["p_program_id"]  = "DMF0043";
--   request.Parameters["p_sheet_name"]  = "ContributeSalesList";
--   request.Parameters["p_column_type"] = "C";
--   request.Parameters["p_user_id"]     = (자동);
--   request.Parameters["p_division_id"] = "40";
--
-- 매핑 룰 (메모리 feedback_proc_meta_col_nm_be_auto_keys):
--   P_USER_ID → sesUserId / P_MENU_ID → mnuId (BE 자동 채움)
--   그 외 IN  → camelCase
--   OUT cursor → 원래 이름 그대로 (o_cursor / O_RESULT_CURSOR)
--
-- 멱등성: NOT EXISTS 가드 — 재실행 시 0 행 영향.
-- 작성: 2026-06-01
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SCM_ADM_MSG_M (API 메시지 1 행) ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG_API_DMF0002_TITLESET_POPUP', 'KO', 'API', '컬럼 표시 설정 조회', '컬럼 표시 설정 조회', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = 'MSG_API_DMF0002_TITLESET_POPUP' AND X.LANG_CD = 'KO'
 );

PROMPT === BLOCK 2 : SCM_ADM_API_M (1 행) ===

INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'P_DMF0002_GET_TITLESET_POPUP', 'PROC_SELECT', 'MSG_API_DMF0002_TITLESET_POPUP', '컬럼 표시 설정 조회', 'DMF0002_GET_TITLESET_POPUP', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID = 'P_DMF0002_GET_TITLESET_POPUP'
 );

PROMPT === BLOCK 3 : SCM_ADM_MNU_BTN_MPG_M (DMF0043_01.titleSet) ===

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0043_01', 'titleSet', 'SEARCH', 'P_DMF0002_GET_TITLESET_POPUP', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID='DMF0043_01' AND X.SHT_NM='titleSet' AND X.MNU_BTN_CD='SEARCH'
 );

PROMPT === BLOCK 4 : SCM_ADM_USER_GR_MNU_BTN_MPG_M (GUEST × 1) ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', 'DMF0043_01', 'titleSet', 'SEARCH', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID='GUEST' AND X.MNU_ID='DMF0043_01' AND X.SHT_NM='titleSet' AND X.MNU_BTN_CD='SEARCH'
 );

PROMPT === BLOCK 5 : SCM_ADM_PROC_M (DMF0002_GET_TITLESET_POPUP 인자 매핑) ===

INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- SP: DMF0002_GET_TITLESET_POPUP (IN 6 + OUT 2)
    -- AS-IS: p_program_id / p_sheet_name / p_column_type / p_user_id / p_division_id (+ BE 자동 p_menu_id)
    SELECT 'DMF0002_GET_TITLESET_POPUP' AS PROC_NM, 'programId'  AS COL_NM, 'VARCHAR'     AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0002_GET_TITLESET_POPUP',          'sheetName',              'VARCHAR',                  'IN',                2 FROM DUAL UNION ALL
    SELECT 'DMF0002_GET_TITLESET_POPUP',          'columnType',             'VARCHAR',                  'IN',                3 FROM DUAL UNION ALL
    SELECT 'DMF0002_GET_TITLESET_POPUP',          'sesUserId',              'VARCHAR',                  'IN',                4 FROM DUAL UNION ALL
    SELECT 'DMF0002_GET_TITLESET_POPUP',          'divisionId',             'VARCHAR',                  'IN',                5 FROM DUAL UNION ALL
    SELECT 'DMF0002_GET_TITLESET_POPUP',          'mnuId',                  'VARCHAR',                  'IN',                6 FROM DUAL UNION ALL
    SELECT 'DMF0002_GET_TITLESET_POPUP',          'o_cursor',               'CURSOR',                   'OUT',               7 FROM DUAL UNION ALL
    SELECT 'DMF0002_GET_TITLESET_POPUP',          'O_RESULT_CURSOR',        'PROC_RESULT',              'OUT',               8 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X
    WHERE X.PROC_NM = NEW.PROC_NM AND X.COL_NM = NEW.COL_NM AND X.COL_TP_CD = NEW.COL_TP_CD
 );

PROMPT === BLOCK 6 : 사후 카운트 ===

SELECT 'POST: MSG_M' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = 'MSG_API_DMF0002_TITLESET_POPUP'
UNION ALL
SELECT 'POST: API_M', COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID = 'P_DMF0002_GET_TITLESET_POPUP'
UNION ALL
SELECT 'POST: BTN_MPG (DMF0043_01.titleSet)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID='DMF0043_01' AND SHT_NM='titleSet'
UNION ALL
SELECT 'POST: GUEST PERM', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0043_01' AND SHT_NM='titleSet'
UNION ALL
SELECT 'POST: PROC_M (8)', COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0002_GET_TITLESET_POPUP';

COMMIT;

PROMPT === COMPLETE ===
EXIT;
