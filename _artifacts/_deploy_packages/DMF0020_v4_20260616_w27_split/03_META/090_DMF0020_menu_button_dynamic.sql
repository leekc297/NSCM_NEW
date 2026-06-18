--==============================================================================
-- 090_DMF0020_menu_button_dynamic.sql
--
-- DMF0020 (Sales Future Price) — Menu Button 동적 fetch 메타 보강
-- =============================================================================
-- 작성: 2026-06-18 (DMF0020 Menu Button 동적화 FE 적용 동반 — useTabBtnPermissions + hasButton)
--
-- 적용 hook:
--   _rules_v2/hooks/ui-dynamic-property-management.md §3 (Menu Button)
--   _rules_v2/hooks/menu-button-dynamic-fetch.md
--   DMF0008 140_DMF0008_menu_button_dynamic_audit.sql 검증된 컬럼명 표준
--
-- 목적: FE 가 `useTabBtnPermissions({ menuId: 'DMF0020' })` + `hasButton(...)` 로 전환됨.
--   BE `GET /admin/menu/DMF0020/auth` → SCM_ADM_USER_GR_MNU_BTN_MPG_M JOIN 결과 list 반환.
--   sheet 무관 union. hasButton(BTN_CD) 결과 true 가 되려면 BTN_MPG row + USER_GR 권한 둘 다 있어야 함.
--
-- 핵심 button 코드 (SalesFuturePrice.tsx 분석):
--   SEARCH  — hotkeyConfig.search → handleSearch (조회)
--   INSERT  — hotkeyConfig.insert → handleInsert (신규 row 추가)
--   SAVE    — hotkeyConfig.save → handleSave (저장)
--   DELETE  — hotkeyConfig.delete → handleDelete (삭제)
--
-- BLOCK 구성:
--   AUDIT 1 : 현 DMF0020 BTN_MPG_M 인벤토리
--   AUDIT 2 : 현 USER_GR_MNU_BTN_MPG_M (DMF0020) 인벤토리
--   BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — 4 button NOT EXISTS INSERT (main sheet)
--   BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — sister 그룹 (DMF0004/DMF0005) SEARCH 권한 보유 USER_GR 동적 복사
--   POST-CHECK : chain (BTN → API → SP STATUS)
--
-- 멱등성: 모든 INSERT NOT EXISTS — 재실행 안전.
-- 적용 환경: SQL*Plus / SQLcl / DBeaver Execute SQL Script.
--==============================================================================

SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200

PROMPT === AUDIT 1 : 현 DMF0020 BTN_MPG_M 인벤토리 ===

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD') AS LUD
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === AUDIT 2 : 현 USER_GR 의 DMF0020 권한 ===

SELECT USER_GR_ID, COUNT(*) AS CNT,
       LISTAGG(SHT_NM || '/' || MNU_BTN_CD, ', ')
         WITHIN GROUP (ORDER BY SHT_NM, MNU_BTN_CD) AS PERMISSIONS
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

PROMPT === AUDIT 3 : 표준 4 button 누락 검출 ===

WITH EXPECTED AS (
  SELECT 'main' AS SHT_NM, 'SEARCH' AS MNU_BTN_CD FROM DUAL UNION ALL
  SELECT 'main',           'INSERT'              FROM DUAL UNION ALL
  SELECT 'main',           'SAVE'                FROM DUAL UNION ALL
  SELECT 'main',           'DELETE'              FROM DUAL
)
SELECT E.SHT_NM, E.MNU_BTN_CD, '누락 — BTN_MPG_M 등록 필요' AS STATUS
  FROM EXPECTED E
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0020' AND X.SHT_NM = E.SHT_NM AND X.MNU_BTN_CD = E.MNU_BTN_CD
 );

PROMPT === BLOCK 1 : SCM_ADM_MNU_BTN_MPG_M — 4 button NOT EXISTS INSERT ===

-- API_ID = NULL 허용 (BE 가 hasButton 만 사용 — 실 SP 호출 시 별도 API_M 매핑 의무).
-- 기존 등록 SP 가 있는 경우 API_ID 매핑 (예: P_DMF0020_GET_FUTUREPRICE_INFO)
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0020', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'main' AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0020_GET_FUTUREPRICE_INFO' AS API_ID FROM DUAL UNION ALL
    SELECT 'main',           'INSERT',                NULL                                       FROM DUAL UNION ALL
    SELECT 'main',           'SAVE',                  'P_DMF0020_SAVE_FUTUREPRICE'               FROM DUAL UNION ALL
    SELECT 'main',           'DELETE',                NULL                                       FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0020' AND X.SHT_NM = NEW.SHT_NM AND X.MNU_BTN_CD = NEW.MNU_BTN_CD
 );

PROMPT === BLOCK 2 : SCM_ADM_USER_GR_MNU_BTN_MPG_M — sister 그룹 동적 복사 ===

-- DMF0004 / DMF0005 (sister 화면) SEARCH 권한 보유 USER_GR 를 DMF0020 의 4 button × main 으로 자동 복사
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0020', T.SHT_NM, T.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 CROSS JOIN (
    SELECT 'main' SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'main',        'INSERT'            FROM DUAL UNION ALL
    SELECT 'main',        'SAVE'              FROM DUAL UNION ALL
    SELECT 'main',        'DELETE'            FROM DUAL
 ) T
 WHERE u.MNU_ID IN ('DMF0004', 'DMF0005') AND u.SHT_NM IN ('main', 'production') AND u.MNU_BTN_CD = 'SEARCH' AND u.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'DMF0020'
        AND e.SHT_NM = T.SHT_NM AND e.MNU_BTN_CD = T.MNU_BTN_CD
   );

-- GUEST 그룹 (login 전 default) 도 보강
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', 'DMF0020', T.SHT_NM, T.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'main' SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'main',        'INSERT'            FROM DUAL UNION ALL
    SELECT 'main',        'SAVE'              FROM DUAL UNION ALL
    SELECT 'main',        'DELETE'            FROM DUAL
  ) T
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID = 'GUEST' AND X.MNU_ID = 'DMF0020'
      AND X.SHT_NM = T.SHT_NM AND X.MNU_BTN_CD = T.MNU_BTN_CD
 );

-- minyonglee1 의 모든 USER_GR (SCM_ADM_USER_GR_MPG_M JOIN) 보강
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT gr.USER_GR_ID, 'DMF0020', T.SHT_NM, T.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M gr
 CROSS JOIN (
    SELECT 'main' SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'main',        'INSERT'            FROM DUAL UNION ALL
    SELECT 'main',        'SAVE'              FROM DUAL UNION ALL
    SELECT 'main',        'DELETE'            FROM DUAL
 ) T
 WHERE gr.USER_ID = 'minyonglee1' AND (gr.USE_YN = 'Y' OR gr.USE_YN IS NULL)
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = gr.USER_GR_ID AND e.MNU_ID = 'DMF0020'
        AND e.SHT_NM = T.SHT_NM AND e.MNU_BTN_CD = T.MNU_BTN_CD
   );

COMMIT;

PROMPT === POST-CHECK 1 : 적용 후 DMF0020 BTN_MPG_M ===

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020'
 ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === POST-CHECK 2 : 적용 후 USER_GR 카운트 ===

SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;

PROMPT === POST-CHECK 3 : chain (BTN → API → SP STATUS) ===

SELECT BTN.MNU_BTN_CD, BTN.USE_YN AS BTN_USE,
       API.API_ID, API.API_URL,
       (SELECT status FROM all_objects
         WHERE owner='SCM_MGR' AND object_name=API.API_URL AND object_type='PROCEDURE' AND ROWNUM=1) AS SP_STATUS,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=API.API_URL) AS PROC_M_CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0020'
 ORDER BY BTN.MNU_BTN_CD;

PROMPT === 090_DMF0020_menu_button_dynamic.sql 완료 ===

--==============================================================================
-- 적용 후 FE 검증:
--   1) BE 재기동 (Spring boot 메타 캐시 무효화)
--   2) DevTools Network: GET /admin/menu/DMF0020/auth → mnuBtnAuth list 에 SEARCH/INSERT/SAVE/DELETE 포함
--   3) DMF0020 진입 → F5/F7/F8/F9 hotkey 정상 작동
--   4) admin SYS0009 에서 DMF0020/main/SAVE USE_YN='N' → 화면 재진입 시 SAVE 버튼 비활성
--==============================================================================
