/* DMF0052_registration.sql — 생성: tools/Harness/gen-register-sql.js 2026-10-19
 * 원천: Doc/gen/DMF0052/register.json · As-is SCM_MST_SHEET_COLUMNS(45행) + 하드코딩 컬럼(9) · TB_FX_MenuItemInfo · TB_FX_GroupMenuAuth(4)
 * 7영역: i18n(MNU) · PROC_M(ALL_ARGUMENTS 동적) · SHEET_COLUMNS · MNU_M · API_M · MNU_BTN_MPG_M · USER_GR_MNU_MPG_M(+버튼 권한)
 * 실행: SQL*Plus/SQLcl @DMF0052_registration.sql  (SCM_MGR). 재실행 안전(DELETE 후 INSERT / MERGE). 마지막 COMMIT 은 BLOCK 8 결과 확인 후.
 * TODO 표시는 사람이 확정: 상위 메뉴 ID(To-Be menu.csv 로 확정됨), 메뉴 KO/CN 명, 그룹 ID(user_group.csv 로 확정됨)
 */
SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED
DEFINE V_MENU_ID     = 'DMF0052'
DEFINE V_MENU_MSG_ID = 'MNU_DMF0052'
DEFINE V_MENU_URL    = 'dmf0052'
DEFINE V_PKG_NM      = 'PKG_DMF0052'
DEFINE V_USER_ID     = 'harness'

-- BLOCK 1: i18n 메뉴명 (KO/CN 은 As-is Title 로 임시 — TODO 번역)
-- 기존 메뉴가 MSG_ID MNU00193 를 이미 쓰므로 신규 MNU_ 메시지는 등록하지 않음(아래 INSERT 는 참고용으로 주석 처리)
/*DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID = '&V_MENU_MSG_ID';
INSERT ALL
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('&V_MENU_MSG_ID', 'KO', 'EDI Summary', 'MNU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('&V_MENU_MSG_ID', 'EN', 'EDI Summary', 'MNU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('&V_MENU_MSG_ID', 'CN', 'EDI Summary', 'MNU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;*/

-- BLOCK 2: PROC_M — ALL_ARGUMENTS 에서 동적 등록 (PKG 배포 전이면 As-is 파라미터로 임시 등록 + WARN)
DECLARE v_pkg VARCHAR2(128); v_obj VARCHAR2(128); v_n NUMBER;
BEGIN
  -- SUMMARY / SEARCH  ← As-is DMF0052_GET_SUMMARY_DATA
  v_pkg := 'PKG_DMF0052'; v_obj := 'P_DMF0052_GET_SUMMARY_DATA'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is DMF0052_GET_SUMMARY_DATA 파라미터 5건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'senderCode', 'IN', 'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'itemId', 'IN', 'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'projectCode', 'IN', 'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'fromYyyymmdd', 'IN', 'VARCHAR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'toYyyymmdd', 'IN', 'VARCHAR', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'o_rc1', 'OUT', 'CURSOR', 6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA 파라미터 ' || v_n || '건'); END IF;

  -- Summary Pjt / SEARCH  ← As-is DMF0052_GET_PJT_DATA
  v_pkg := 'PKG_DMF0052'; v_obj := 'P_DMF0052_GET_PJT_DATA'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0052.P_DMF0052_GET_PJT_DATA';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN PKG_DMF0052.P_DMF0052_GET_PJT_DATA 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is DMF0052_GET_PJT_DATA 파라미터 5건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'senderCode', 'IN', 'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'itemId', 'IN', 'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'projectCode', 'IN', 'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'fromYyyymmdd', 'IN', 'VARCHAR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'toYyyymmdd', 'IN', 'VARCHAR', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'o_rc1', 'OUT', 'CURSOR', 6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK PKG_DMF0052.P_DMF0052_GET_PJT_DATA 파라미터 ' || v_n || '건'); END IF;

  -- Summary Status / SEARCH  ← As-is DMF0052_GET_STATUS_DATA
  v_pkg := 'PKG_DMF0052'; v_obj := 'P_DMF0052_GET_STATUS_DATA'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0052.P_DMF0052_GET_STATUS_DATA';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN PKG_DMF0052.P_DMF0052_GET_STATUS_DATA 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is DMF0052_GET_STATUS_DATA 파라미터 5건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'senderCode', 'IN', 'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'itemId', 'IN', 'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'projectCode', 'IN', 'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'fromYyyymmdd', 'IN', 'VARCHAR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'toYyyymmdd', 'IN', 'VARCHAR', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'o_rc1', 'OUT', 'CURSOR', 6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK PKG_DMF0052.P_DMF0052_GET_STATUS_DATA 파라미터 ' || v_n || '건'); END IF;

  -- ERP Data / DETAIL_DATA  ← As-is DMF0052_GET_DETAIL_DATA
  v_pkg := 'PKG_DMF0052'; v_obj := 'P_DMF0052_GET_DETAIL_DATA'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is DMF0052_GET_DETAIL_DATA 파라미터 6건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'projectCode', 'IN', 'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'itemId', 'IN', 'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'fromYyyymmdd', 'IN', 'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'toYyyymmdd', 'IN', 'VARCHAR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'gridSenderCode', 'IN', 'VARCHAR', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'gridProjectCode', 'IN', 'VARCHAR', 6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'o_rc1', 'OUT', 'CURSOR', 7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 8, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA 파라미터 ' || v_n || '건'); END IF;

  -- ERP Data / ERP_DATA  ← As-is DMF0052_GET_ERP_DATA
  v_pkg := 'PKG_DMF0052'; v_obj := 'P_DMF0052_GET_ERP_DATA'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0052.P_DMF0052_GET_ERP_DATA';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN PKG_DMF0052.P_DMF0052_GET_ERP_DATA 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is DMF0052_GET_ERP_DATA 파라미터 6건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'projectCode', 'IN', 'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'itemId', 'IN', 'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'fromYyyymmdd', 'IN', 'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'toYyyymmdd', 'IN', 'VARCHAR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'gridSenderCode', 'IN', 'VARCHAR', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'gridProjectCode', 'IN', 'VARCHAR', 6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'o_rc1', 'OUT', 'CURSOR', 7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'o_result_cursor', 'OUT', 'PROC_RESULT', 8, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK PKG_DMF0052.P_DMF0052_GET_ERP_DATA 파라미터 ' || v_n || '건'); END IF;

  -- main / SEARCH  ← As-is DMF0052_GET_SPREAD_TITLE
  v_pkg := 'PKG_DMF0052'; v_obj := 'P_DMF0052_GET_SPREAD_TITLE'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is DMF0052_GET_SPREAD_TITLE 파라미터 3건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE', 'createdBy', 'IN', 'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE', 'divisionId', 'IN', 'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE', 'sheetName', 'IN', 'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE', 'o_rc1', 'OUT', 'CURSOR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE', 'o_result_cursor', 'OUT', 'PROC_RESULT', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE 파라미터 ' || v_n || '건'); END IF;

  -- EDI Summary GSCM DATA Popup / SEARCH  ← As-is DMF0052_GET_SITE_POPUP
  v_pkg := 'PKG_DMF0052'; v_obj := 'P_DMF0052_GET_SITE_POPUP'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0052.P_DMF0052_GET_SITE_POPUP';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN PKG_DMF0052.P_DMF0052_GET_SITE_POPUP 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is DMF0052_GET_SITE_POPUP 파라미터 6건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'senderCode', 'IN', 'VARCHAR', 1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'itemId', 'IN', 'VARCHAR', 2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'projectCode', 'IN', 'VARCHAR', 3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'fromYyyymmdd', 'IN', 'VARCHAR', 4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'toYyyymmdd', 'IN', 'VARCHAR', 5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'popupType', 'IN', 'VARCHAR', 6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'o_rc1', 'OUT', 'CURSOR', 7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'o_result_cursor', 'OUT', 'PROC_RESULT', 8, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK PKG_DMF0052.P_DMF0052_GET_SITE_POPUP 파라미터 ' || v_n || '건'); END IF;
END;
/

-- BLOCK 3: SHEET_COLUMNS — As-is 메타 45행 이관 + 하드코딩 컬럼 9건(sort 9000+, DIV 별)
DECLARE
    v_col_json CLOB := '[
        {"sht_nm":"ERP Data","col_nm":"COMPANY_ID","col_lbl":"Company","sort_ord":530,"small_cls":"Company","large_cls":"Company","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"EDI_IF_SEQ","col_lbl":"EDI_IF_SEQ","sort_ord":510,"small_cls":"EDI_IF_SEQ","large_cls":"EDI_IF_SEQ","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"ERP_STATUS","col_lbl":"(ERP) Status","sort_ord":570,"small_cls":"(ERP) Status","large_cls":"(ERP) Status","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"GSCM_STATUS","col_lbl":"Status","sort_ord":580,"small_cls":"Status","large_cls":"Status","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"ITEM_ID","col_lbl":"Model","sort_ord":540,"small_cls":"Model","large_cls":"Model","col_wth":150,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"NICK_NAME","col_lbl":"Nickname","sort_ord":545,"small_cls":"Nickname","large_cls":"Nickname","col_wth":150,"align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"SENDER_NAME","col_lbl":"EDI Sender","sort_ord":520,"small_cls":"EDI Sender","large_cls":"EDI Sender","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"SHIPTO_CODE","col_lbl":"Ship to","sort_ord":560,"small_cls":"Ship to","large_cls":"Ship to","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"SOLDTO_CODE","col_lbl":"Sold to","sort_ord":550,"small_cls":"Sold to","large_cls":"Sold to","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"ERP Data","col_nm":"STATUS_DETAIL","col_lbl":"Status Detail","sort_ord":590,"small_cls":"Status Detail","large_cls":"Status Detail","col_wth":150,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"CHECK_INCOTERMS","col_lbl":"EDI Incoterms(SSPM)","sort_ord":380,"small_cls":"EDI Incoterms(SSPM)","large_cls":"EDI Incoterms(SSPM)","col_wth":100,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"CHECK_SALES_ACTIVE","col_lbl":"Sales Site Active","sort_ord":350,"small_cls":"Sales Site Active","large_cls":"Sales Site Active","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"CHECK_SALES_SITE","col_lbl":"Sales Site 누락","sort_ord":340,"small_cls":"Sales Site 누락","large_cls":"Sales Site 누락","col_wth":90,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"CHECK_SSPM","col_lbl":"SSPM 누락","sort_ord":360,"small_cls":"SSPM 누락","large_cls":"SSPM 누락","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"CHECK_SSPM_ACTIVE","col_lbl":"SSPM Active","sort_ord":370,"small_cls":"SSPM Active","large_cls":"SSPM Active","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"ITEM_ID","col_lbl":"Model","sort_ord":320,"small_cls":"Model","large_cls":"Model","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"NICK_NAME","col_lbl":"Nickname","sort_ord":325,"small_cls":"Nickname","large_cls":"Nickname","col_wth":80,"align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"PROJECT_CODE","col_lbl":"Project Code","sort_ord":330,"small_cls":"Project","large_cls":"Project","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"SENDER_CODE","col_lbl":"EDI Sender Code","sort_ord":315,"small_cls":"EDI Sender Code","large_cls":"EDI Sender Code","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"GSCM Data","col_nm":"SENDER_NAME","col_lbl":"EDI Sender","sort_ord":310,"small_cls":"EDI Sender","large_cls":"EDI Sender","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"SUMMARY","col_nm":"RCV_CNT","col_lbl":"GSCM 수신한 데이터 수","sort_ord":30,"small_cls":"GSCM 수신한 데이터 수","large_cls":"GSCM 수신한 데이터 수","col_wth":90,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"SUMMARY","col_nm":"SEND_CNT","col_lbl":"ERP전송 데이터 수","sort_ord":20,"small_cls":"ERP전송 데이터 수","large_cls":"ERP전송 데이터 수","col_wth":70,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"SUMMARY","col_nm":"STATUS","col_lbl":"Status","sort_ord":40,"small_cls":"Status","large_cls":"Status","col_wth":100,"cell_tp":"FPText","align":"L","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"SUMMARY","col_nm":"YYYYMMDD","col_lbl":"날짜","sort_ord":10,"small_cls":"날짜","large_cls":"날짜","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"CHECK_ERP_CNT","col_lbl":"ERP Data 확인 필요","sort_ord":170,"small_cls":"ERP Data 확인 필요","large_cls":"ERP Data 확인 필요","col_wth":120,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"CHECK_GSCM_CNT","col_lbl":"Master Data 정비 필요 건 수 (GSCM)","sort_ord":160,"small_cls":"Master Data 정비 필요 건 수 (GSCM)","large_cls":"Master Data 정비 필요 건 수 (GSCM)","col_wth":140,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"COMPLETED_CNT","col_lbl":"정상","sort_ord":150,"small_cls":"정상","large_cls":"정상","col_wth":80,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"CREATION_DATE","col_lbl":"최종 수신일","sort_ord":120,"small_cls":"최종 수신일","large_cls":"최종 수신일","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"PROJECT_CNT","col_lbl":"수신한 데이터 수","sort_ord":140,"small_cls":"수신한 데이터 수","large_cls":"수신한 데이터 수","col_wth":110,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"PROJECT_CODE","col_lbl":"Project Code","sort_ord":130,"small_cls":"Project","large_cls":"Project","col_wth":100,"cell_tp":"FPText","align":"L","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"SENDER_CODE","col_lbl":"EDI Sender Code","sort_ord":115,"small_cls":"EDI Sender Code","large_cls":"EDI Sender Code","cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Pjt","col_nm":"SENDER_NAME","col_lbl":"EDI Sender","sort_ord":110,"small_cls":"EDI Sender","large_cls":"EDI Sender","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Status","col_nm":"AVG_PERCENT","col_lbl":"%","sort_ord":240,"small_cls":"%","large_cls":"%","col_wth":80,"align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Status","col_nm":"QTY","col_lbl":"Qty","sort_ord":230,"small_cls":"Qty","large_cls":"Qty","col_wth":80,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Status","col_nm":"STATUS_ERP","col_lbl":"Status ERP","sort_ord":210,"small_cls":"Status ERP","large_cls":"Status ERP","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"Summary Status","col_nm":"STATUS_GSCM","col_lbl":"Status GSCM","sort_ord":220,"small_cls":"Status GSCM","large_cls":"Status GSCM","col_wth":80,"cell_tp":"FPText","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y","div_id":"81","input_tp":"S"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"CODE_VALID_YN","col_lbl":"LBL00007","sort_ord":9001,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"COMPANY_ID","col_lbl":"(ERP) Company","sort_ord":9002,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"GSCM_CODE","col_lbl":"(GSCM) Sold to / Ship to","sort_ord":9003,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"Message","col_lbl":"Message","sort_ord":9004,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"SCM_SITE_ID","col_lbl":"(GSCM) Sales Site","sort_ord":9005,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"SENDER_NAME","col_lbl":"(ERP) EDI Sender","sort_ord":9006,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"SHIPTO_CODE","col_lbl":"(ERP) Ship to","sort_ord":9007,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"SOLDTO_CODE","col_lbl":"(ERP) Sold to","sort_ord":9008,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"},
        {"sht_nm":"EDI Summary GSCM DATA Popup","col_nm":"VALID_YN","col_lbl":"LBL00007","sort_ord":9009,"cell_tp":"FPText","col_wth":100,"visible":"Y","default_f":"Y","usr_sel":"Y","input_tp":"OPTIONAL","div_id":"ALL"}
    ]';
BEGIN
    DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID';
    INSERT INTO SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
        CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT '&V_MENU_ID', jt.SHT_NM, jt.COL_NM, jt.COL_LBL, jt.SORT_ORD, jt.SMALL_CLS, jt.LARGE_CLS, NVL(jt.FIXED, 'N'), NVL(jt.COL_WTH, 100), NVL(jt.CELL_TP, 'FPText'), jt.CELL_CBO, NVL(jt.SCALE, 0), NVL(jt.MAX_LEN, 200), NVL(jt.ALIGN, 'L'), NVL(jt.UPPER, 'N'), NVL(jt.VISIBLE, 'Y'), NVL(jt.DEFAULT_F, 'Y'), NVL(jt.USR_SEL, 'Y'), 'Y', NVL(jt.DIV_ID, 'ALL'), NVL(jt.INPUT_TP, 'OPTIONAL'), '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
    FROM JSON_TABLE(v_col_json, '$[*]' COLUMNS (SHT_NM VARCHAR2(50 CHAR) PATH '$.sht_nm', COL_NM VARCHAR2(100 CHAR) PATH '$.col_nm', COL_LBL VARCHAR2(200 CHAR) PATH '$.col_lbl', SORT_ORD NUMBER PATH '$.sort_ord', SMALL_CLS VARCHAR2(100 CHAR) PATH '$.small_cls', LARGE_CLS VARCHAR2(100 CHAR) PATH '$.large_cls', FIXED VARCHAR2(1 CHAR) PATH '$.fixed', COL_WTH NUMBER PATH '$.col_wth', CELL_TP VARCHAR2(50 CHAR) PATH '$.cell_tp', CELL_CBO VARCHAR2(100 CHAR) PATH '$.cell_cbo', SCALE NUMBER PATH '$.scale', MAX_LEN NUMBER PATH '$.max_len', ALIGN VARCHAR2(1 CHAR) PATH '$.align', UPPER VARCHAR2(1 CHAR) PATH '$.upper', VISIBLE VARCHAR2(1 CHAR) PATH '$.visible', DEFAULT_F VARCHAR2(1 CHAR) PATH '$.default_f', USR_SEL VARCHAR2(1 CHAR) PATH '$.usr_sel', DIV_ID VARCHAR2(100 CHAR) PATH '$.div_id', INPUT_TP VARCHAR2(50 CHAR) PATH '$.input_tp')) jt;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 3] SCM_MST_SHEET_COLUMNS: ' || SQL%ROWCOUNT || ' 행');
END;
/

-- BLOCK 4: MENU (As-is: 상위 'Customer Forecast', 정렬 1, 레벨 3)
MERGE INTO SCM_ADM_MNU_M T USING (SELECT '&V_MENU_ID' AS MNU_ID FROM DUAL) S ON (T.MNU_ID = S.MNU_ID)
WHEN MATCHED THEN UPDATE SET T.UPPR_MNU_ID = 'Customer_Forecast', T.MNU_LV_NO = 3, T.MNU_MSG_ID = 'MNU00193', T.MNU_URL = '&V_MENU_URL', T.SORT_ORD = 1, T.USE_YN = 'Y', T.ROUTE_PATH = 'report/customer-forecast/dmf0052', T.MNU_TP_CD = NVL(T.MNU_TP_CD, 'SCREEN'), T.LAST_UPDATED_BY = '&V_USER_ID', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, SORT_ORD, USE_YN, MNU_TP_CD, ROUTE_PATH, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('&V_MENU_ID', 'Customer_Forecast', 3, '&V_MENU_MSG_ID', '&V_MENU_URL', 1, 'Y', 'SCREEN', 'report/customer-forecast/dmf0052', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
-- 기존 메뉴 행 있음(USE_YN=N, MNU_MSG_ID=MNU00193 유지) → USE_YN 'Y' 로 올림

-- BLOCK 5: API (7)
DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE '&V_MENU_ID' || '\_%' ESCAPE '\';
INSERT ALL
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052_SUMMARY_SEARCH', 'PROC', NULL, 'DMF0052 SUMMARY SEARCH', 'PKG_DMF0052.P_DMF0052_GET_SUMMARY_DATA', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052_SUMMARY_PJT_SEARCH', 'PROC', NULL, 'DMF0052 Summary Pjt SEARCH', 'PKG_DMF0052.P_DMF0052_GET_PJT_DATA', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052_SUMMARY_STATUS_SEARCH', 'PROC', NULL, 'DMF0052 Summary Status SEARCH', 'PKG_DMF0052.P_DMF0052_GET_STATUS_DATA', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052_ERP_DATA_DETAIL_DATA', 'PROC', NULL, 'DMF0052 ERP Data DETAIL_DATA', 'PKG_DMF0052.P_DMF0052_GET_DETAIL_DATA', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052_ERP_DATA_ERP_DATA', 'PROC', NULL, 'DMF0052 ERP Data ERP_DATA', 'PKG_DMF0052.P_DMF0052_GET_ERP_DATA', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052_MAIN_SEARCH', 'PROC', NULL, 'DMF0052 main SEARCH', 'PKG_DMF0052.P_DMF0052_GET_SPREAD_TITLE', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052_EDI_SUMMARY_GSCM_DATA_POPUP_SEARCH', 'PROC', NULL, 'DMF0052 EDI Summary GSCM DATA Popup SEARCH', 'PKG_DMF0052.P_DMF0052_GET_SITE_POPUP', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;

-- BLOCK 6: MNU_BTN_MPG (시트×버튼 → API)
DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
INSERT ALL
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052', 'SUMMARY', 'SEARCH', 'DMF0052_SUMMARY_SEARCH', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052', 'Summary Pjt', 'SEARCH', 'DMF0052_SUMMARY_PJT_SEARCH', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052', 'Summary Status', 'SEARCH', 'DMF0052_SUMMARY_STATUS_SEARCH', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052', 'ERP Data', 'DETAIL_DATA', 'DMF0052_ERP_DATA_DETAIL_DATA', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052', 'ERP Data', 'ERP_DATA', 'DMF0052_ERP_DATA_ERP_DATA', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052', 'main', 'SEARCH', 'DMF0052_MAIN_SEARCH', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0052', 'EDI Summary GSCM DATA Popup', 'SEARCH', 'DMF0052_EDI_SUMMARY_GSCM_DATA_POPUP_SEARCH', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;

-- BLOCK 7: 그룹 권한 (As-is TB_FX_GroupMenuAuth 4건 → 읽기 그룹 메뉴 허용, 읽기 전용 그룹은 저장류 버튼 N)
DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID';
INSERT ALL
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('-', 'DMF0052', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)  -- As-is ADMIN
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('DM ADMIN', 'DMF0052', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)  -- As-is DM ADMIN
  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('SCM PI Admin', 'DMF0052', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)  -- As-is SCM PI Admin
SELECT * FROM DUAL;
-- (버튼 권한 분리 없음)

-- BLOCK 8: 검증
SELECT '1.MENU' AS AREA, COUNT(*) AS CNT FROM SCM_ADM_MNU_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '2.PROC_M', COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE '&V_PKG_NM' || '.%'
UNION ALL SELECT '3.SHEET_COLUMNS', COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID'
UNION ALL SELECT '5.API', COUNT(*) FROM SCM_ADM_API_M WHERE API_ID LIKE '&V_MENU_ID' || '\_%' ESCAPE '\'
UNION ALL SELECT '6.MNU_BTN_MPG', COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '7.GROUP_MENU', COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '1.I18N', COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID = 'MNU00193' ORDER BY 1;
DECLARE v_cur SYS_REFCURSOR; v_proc VARCHAR2(200); v_col VARCHAR2(100); v_dt VARCHAR2(50); v_ct VARCHAR2(50); v_so NUMBER; v_cnt NUMBER := 0;
BEGIN
  SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(P_MNU_ID => '&V_MENU_ID', P_SHT_NM => 'SUMMARY', P_MNU_BTN_CD => 'SEARCH', O_CURSOR => v_cur);
  LOOP FETCH v_cur INTO v_proc, v_col, v_dt, v_ct, v_so; EXIT WHEN v_cur%NOTFOUND; v_cnt := v_cnt + 1; END LOOP; CLOSE v_cur;
  DBMS_OUTPUT.PUT_LINE(CASE WHEN v_cnt = 0 THEN 'FAIL 라우팅 없음' WHEN v_cnt = 1 THEN 'WARN PROC_M 미등록(PKG 배포 후 재실행)' ELSE 'OK 파라미터 ' || v_cnt END);
END;
/
-- COMMIT;   -- BLOCK 8 확인 후 수동 커밋 (롤백: ROLLBACK;)
UNDEFINE V_MENU_ID V_MENU_MSG_ID V_MENU_URL V_PKG_NM V_USER_ID
