-- ============================================================================
-- 57. SYS0013 (Dynamic Query) UI 동적 속성관리 룰 적용 보완
-- ----------------------------------------------------------------------------
-- 작성  : 2026-06-15 (master hook ui-dynamic-property-management 준수)
-- 대상  : 사내 Oracle (121.162.245.167:2521/ESSCMD)
-- 3 axis 보완:
--   A) SHEET_COLUMNS.INPUT_TP_CD : 'S' 일색 → 자매 SYS0010 패턴 (IM/M/O/S 분포)
--   B) MNU_BTN_MPG_M : INSERT/DELETE 버튼 추가 (main/columns/parameters)
--   C) USER_GR_MNU_BTN_MPG_M : 자매 SYS0010 cascade
-- ============================================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
  v_a_main   PLS_INTEGER := 0;
  v_a_cols   PLS_INTEGER := 0;
  v_a_param  PLS_INTEGER := 0;
  v_b_btn    PLS_INTEGER := 0;
  v_c_perm   PLS_INTEGER := 0;
BEGIN
  --------------------------------------------------------------------------
  -- (A) INPUT_TP_CD 정정 — 자매 SYS0010 패턴 (IM/M/O/S)
  --------------------------------------------------------------------------
  -- main sheet (7 row 중 5 변경)
  UPDATE SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD='IM', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='main' AND COLUMN_NAME='QUERY_ID';
  v_a_main := v_a_main + SQL%ROWCOUNT;
  UPDATE SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD='M', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='main' AND COLUMN_NAME IN ('QUERY_NAME','QUERY_SQL');
  v_a_main := v_a_main + SQL%ROWCOUNT;
  UPDATE SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD='O', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='main' AND COLUMN_NAME IN ('QUERY_CATEGORY','USE_YN');
  v_a_main := v_a_main + SQL%ROWCOUNT;

  -- columns sheet (7 row 중 4 변경)
  UPDATE SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD='M', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='columns' AND COLUMN_NAME='COLUMN_NAME';
  v_a_cols := v_a_cols + SQL%ROWCOUNT;
  UPDATE SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD='O', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='columns' AND COLUMN_NAME IN ('VALUE_YN','VALUE_TYPE','VALID_YN');
  v_a_cols := v_a_cols + SQL%ROWCOUNT;

  -- parameters sheet (8 row 중 6 변경)
  UPDATE SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD='IM', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='parameters' AND COLUMN_NAME='PARAMETER_ID';
  v_a_param := v_a_param + SQL%ROWCOUNT;
  UPDATE SCM_MST_SHEET_COLUMNS SET INPUT_TP_CD='O', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE PROGRAM_ID='SYS0013' AND SHEET_NAME='parameters'
     AND COLUMN_NAME IN ('PARAMETER_TYPE','OPERATION_ID','VALID_YN','REP_YN','SEQNO');
  v_a_param := v_a_param + SQL%ROWCOUNT;

  -- history sheet 변경 없음 (read-only 시스템 컬럼 — 'S' 유지)

  --------------------------------------------------------------------------
  -- (B) MNU_BTN_MPG_M — INSERT/DELETE 추가 (main/columns/parameters)
  --------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT * FROM (
    SELECT 'SYS0013' MNU_ID, 'main' SHT_NM, 'INSERT' MNU_BTN_CD, NULL API_ID, 'Y' USE_YN, 'admin' CB, SYSDATE CD, 'admin' LB, SYSDATE LD FROM DUAL UNION ALL
    SELECT 'SYS0013', 'main',       'DELETE', NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL UNION ALL
    SELECT 'SYS0013', 'columns',    'INSERT', NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL UNION ALL
    SELECT 'SYS0013', 'columns',    'DELETE', NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL UNION ALL
    SELECT 'SYS0013', 'parameters', 'INSERT', NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL UNION ALL
    SELECT 'SYS0013', 'parameters', 'DELETE', NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
  ) NEW
   WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M e
                      WHERE e.MNU_ID=NEW.MNU_ID AND e.SHT_NM=NEW.SHT_NM AND e.MNU_BTN_CD=NEW.MNU_BTN_CD);
  v_b_btn := SQL%ROWCOUNT;

  --------------------------------------------------------------------------
  -- (C) USER_GR_MNU_BTN_MPG_M — 추가된 6 button × USER_GR 동적 복사
  --------------------------------------------------------------------------
  INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT DISTINCT u.USER_GR_ID, 'SYS0013', new_btn.SHT_NM, new_btn.MNU_BTN_CD, 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u
   CROSS JOIN (SELECT 'main' SHT_NM, 'INSERT' MNU_BTN_CD FROM DUAL UNION ALL
               SELECT 'main',       'DELETE'             FROM DUAL UNION ALL
               SELECT 'columns',    'INSERT'             FROM DUAL UNION ALL
               SELECT 'columns',    'DELETE'             FROM DUAL UNION ALL
               SELECT 'parameters', 'INSERT'             FROM DUAL UNION ALL
               SELECT 'parameters', 'DELETE'             FROM DUAL) new_btn
   WHERE u.MNU_ID='SYS0013'
     AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e
                      WHERE e.USER_GR_ID=u.USER_GR_ID AND e.MNU_ID='SYS0013'
                        AND e.SHT_NM=new_btn.SHT_NM AND e.MNU_BTN_CD=new_btn.MNU_BTN_CD);
  v_c_perm := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE('(A) INPUT_TP_CD main updated     : ' || v_a_main);
  DBMS_OUTPUT.PUT_LINE('(A) INPUT_TP_CD columns updated  : ' || v_a_cols);
  DBMS_OUTPUT.PUT_LINE('(A) INPUT_TP_CD parameters upd   : ' || v_a_param);
  DBMS_OUTPUT.PUT_LINE('(B) MNU_BTN_MPG_M inserted       : ' || v_b_btn);
  DBMS_OUTPUT.PUT_LINE('(C) USER_GR cascade inserted     : ' || v_c_perm);

  COMMIT;
END;
/
