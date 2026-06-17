-- =================================================================================================
-- DMF0043 patch 적용 후 컴파일 + 권한 검증
-- =================================================================================================

-- 1. INVALID 객체 확인 — 0 row 가 기대값
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND (OBJECT_NAME LIKE 'DMF0043%' OR OBJECT_NAME = 'PKG_DMF0043')
   AND STATUS <> 'VALID'
 ORDER BY OBJECT_TYPE, OBJECT_NAME;

-- 2. USER_ERRORS — patch 후 컴파일 오류 잔존?
SELECT NAME, TYPE, LINE, POSITION, TEXT
  FROM ALL_ERRORS
 WHERE OWNER = 'SCM_MGR'
   AND (NAME LIKE 'DMF0043%' OR NAME = 'PKG_DMF0043')
 ORDER BY NAME, SEQUENCE;

-- 3. SCMD_APP 권한 검증 — patched 9 객체에 EXECUTE 권한 유지?
SELECT TABLE_NAME, PRIVILEGE, GRANTABLE
  FROM ALL_TAB_PRIVS
 WHERE TABLE_SCHEMA = 'SCM_MGR'
   AND GRANTEE = 'SCMD_APP'
   AND (TABLE_NAME LIKE 'DMF0043%' OR TABLE_NAME = 'PKG_DMF0043')
   AND PRIVILEGE = 'EXECUTE'
 ORDER BY TABLE_NAME;

-- 4. LAST_DDL 갱신 확인 — 적용 직후 patched 객체 모두 SYSDATE 근처
SELECT OBJECT_NAME, OBJECT_TYPE, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND OBJECT_NAME IN (
     'PKG_DMF0043',
     'DMF0043_GET_CONTRIBUTE_MAIN_DATA',
     'DMF0043_GET_MAIN_SPREAD_TITLE',
     'DMF0043_GET_CONTRIBUTE_RATE_POPUP',
     'DMF0043_GET_CONTRIBUTE_YEAR_POPUP',
     'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',
     'DMF0043_GET_SALES_LIST_SPREAD_TITLE',
     'DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO'
   )
 ORDER BY OBJECT_TYPE, OBJECT_NAME;

-- 5. 사용자 권한 확인 (minyonglee1 + division 40)
SELECT UNIT_ID, EDIT_YN
  FROM TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN('minyonglee1', 'DMF0043'));

-- 6. DMF0043 ContributeMain SHEET_COLUMNS 인벤토리
SELECT COLUMN_NAME, SORT_ORDER_NO, VISIBLE_FLAG, DEFAULT_FLAG, VALID_YN, ATTRIBUTE1
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043'
 ORDER BY SHEET_NAME, SORT_ORDER_NO;

-- 7. Dynamic column cursor 응답 검증 — 화면 진입 + 조회 시 yyyy/verSeq 와 동일 인자
SET SERVEROUTPUT ON
DECLARE
  v_rc       SYS_REFCURSOR;
  v_cur_id   INTEGER;
  v_col_cnt  INTEGER;
  v_desc_tab DBMS_SQL.DESC_TAB;
  v_dyn_y    INTEGER := 0;
  v_dyn_m    INTEGER := 0;
  v_gt_cnt   INTEGER;
BEGIN
  SCM_MGR.DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','1','ALL','N','minyonglee1','',v_rc);
  v_cur_id := DBMS_SQL.TO_CURSOR_NUMBER(v_rc);
  DBMS_SQL.DESCRIBE_COLUMNS(v_cur_id, v_col_cnt, v_desc_tab);
  FOR i IN 1 .. v_col_cnt LOOP
    IF v_desc_tab(i).col_name LIKE 'Y#%' THEN v_dyn_y := v_dyn_y + 1; END IF;
    IF v_desc_tab(i).col_name LIKE 'M#%' THEN v_dyn_m := v_dyn_m + 1; END IF;
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(v_cur_id);
  DBMS_OUTPUT.PUT_LINE('Total cursor columns : ' || v_col_cnt);
  DBMS_OUTPUT.PUT_LINE('  Y# dynamic         : ' || v_dyn_y);
  DBMS_OUTPUT.PUT_LINE('  M# dynamic         : ' || v_dyn_m);
  SELECT COUNT(*) INTO v_gt_cnt FROM SCM_MGR.GT_GMST_TEMP2_2;
  DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP2_2 rows : ' || v_gt_cnt);
END;
/
