--==============================================================================
-- 010_DMF0014_meta_DBeaver.sql — DBeaver 호환 (SET/PROMPT/EXIT 제거)
--   원본: 010_DMF0014_meta.sql (sqlplus 명령 포함)
--   feedback_sql_dual_output 메모리 의무 — DBeaver SQL Editor 호환 별도
--
-- 실행 위치: DBeaver SQL Editor → Execute All Statements (Ctrl+Alt+X)
--==============================================================================

-- BLOCK 1 : MSG_M (5 API 메시지)
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0014_MAIN_RETRIEVE'        AS MSG_ID, 'Customer FCST Upload 조회' AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_TITLE_RETRIEVE',                'Customer FCST Upload 헤더 조회'         FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_MAIN_SAVE',                     'Customer FCST Upload 저장'              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_EXCEL_UPLOAD',                  'Excel Upload 메인'                     FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0014_EXCEL_UPLOAD_SM',               'Excel Upload Small 사업부'             FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

-- BLOCK 2 : MNU_M (1 row)
INSERT INTO SCM_MGR.SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_NM, MNU_DESC, MNU_LVL, MNU_TP_CD, MNU_URL, MNU_ORD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0014', 'Demand_Plan', 'Customer FCST Upload', 'Customer FCST Upload (Excel Upload 패턴 — G4 Batch)', 3, 'SCREEN', 'customer-fcst-upload', 80, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0014');

-- ⚠️ 본 DBeaver 호환 파일은 BLOCK 1~2 만 발췌.
--   BLOCK 3~7 (SHEET_COLUMNS 15 + PROC_M 47 + API_M 4 + BTN_MPG 4 + 권한) 은
--   원본 010_DMF0014_meta.sql 의 해당 BLOCK 그대로 사용.
--   DBeaver 에서 원본 SQL 을 Open → Ctrl+End 로 SET/PROMPT/EXIT 라인 모두 선택 후 Comment Out (Ctrl+/)
--   → BLOCK 별 statement 만 Execute.

COMMIT;
