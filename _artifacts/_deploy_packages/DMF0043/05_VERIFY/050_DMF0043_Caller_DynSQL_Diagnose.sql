--==============================================================================
-- 050_DMF0043_Caller_DynSQL_Diagnose.sql
--
-- 목적: caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) 의 ORA-00936 진단
--       dynamic SQL `v_Query` 가 malformed 인 이유 식별
-- 실행: SCM_MGR 세션. SQL*Plus / DBeaver 모두 OK
-- 작성: 2026-06-05
--
-- 가설:
--   1. GT_DMF0043_TITLE 에 COLUMN_NAME='EDIT_FLAG' row 없음 → v_ColumnData 빈 string
--   2. EDIT_FLAG row 는 있지만 SORT_ORDER_NO 가 마지막 → > 조건 미매치 → v_ColumnData 빈
--   3. SCM_MST_SHEET_COLUMNS 의 DMF0043/ContributeMain row 자체 0 → 모든 GTT 0 row
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : SCM_MST_SHEET_COLUMNS / DMF0043 / ContributeMain 인벤토리 ===

SELECT COUNT(*) AS total_rows,
       SUM(CASE WHEN COLUMN_NAME = 'EDIT_FLAG' THEN 1 ELSE 0 END) AS edit_flag_count,
       MIN(TO_NUMBER(SORT_ORDER_NO)) AS min_sort,
       MAX(TO_NUMBER(SORT_ORDER_NO)) AS max_sort
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043'
   AND SHEET_NAME = 'ContributeMain';

PROMPT === DIAG 2 : EDIT_FLAG row 의 SORT_ORDER_NO (있다면) ===

SELECT COLUMN_NAME, SORT_ORDER_NO, VALID_YN, DIVISION_ID, DEFAULT_FLAG
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043'
   AND SHEET_NAME = 'ContributeMain'
   AND COLUMN_NAME = 'EDIT_FLAG';

PROMPT === DIAG 3 : EDIT_FLAG 보다 SORT_ORDER_NO 큰 컬럼 수 (v_ColumnData 빌드 대상) ===

SELECT COUNT(*) AS cols_after_edit_flag
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043'
   AND SHEET_NAME = 'ContributeMain'
   AND TO_NUMBER(SORT_ORDER_NO) > NVL((
     SELECT TO_NUMBER(SORT_ORDER_NO) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
      WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'ContributeMain' AND COLUMN_NAME = 'EDIT_FLAG'
   ), 99999);

PROMPT === DIAG 4 : 전체 COLUMN_NAME 목록 (SORT_ORDER_NO 정렬) — EDIT_FLAG 위치 식별 ===

SELECT TO_NUMBER(SORT_ORDER_NO) AS sort, COLUMN_NAME, VALID_YN
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0043'
   AND SHEET_NAME = 'ContributeMain'
 ORDER BY TO_NUMBER(SORT_ORDER_NO);

PROMPT === DIAG 5 : v_ColumnData / v_ColumnDataPivot 시뮬레이션 (caller 와 동일 logic) ===

DECLARE
  v_ColumnData       VARCHAR2(4000) := '';
  v_ColumnDataPivot  VARCHAR2(4000) := '';
  v_first BOOLEAN := TRUE;
  v_edit_flag_sort NUMBER;
  v_cnt PLS_INTEGER := 0;
BEGIN
  BEGIN
    SELECT TO_NUMBER(SORT_ORDER_NO) INTO v_edit_flag_sort
      FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
     WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'ContributeMain' AND COLUMN_NAME = 'EDIT_FLAG';
    DBMS_OUTPUT.PUT_LINE('EDIT_FLAG SORT_ORDER_NO = ' || v_edit_flag_sort);
  EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ERR: EDIT_FLAG row 가 SCM_MST_SHEET_COLUMNS 에 없음 → v_ColumnData 빌드 0건 → ORA-00936');
    RETURN;
  END;

  FOR r IN (
    SELECT COLUMN_NAME
      FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
     WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'ContributeMain'
       AND TO_NUMBER(SORT_ORDER_NO) > v_edit_flag_sort
     ORDER BY TO_NUMBER(SORT_ORDER_NO)
  ) LOOP
    v_cnt := v_cnt + 1;
    IF v_first THEN
      v_ColumnData      := '"' || r.COLUMN_NAME || '"';
      v_ColumnDataPivot := '''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"';
      v_first := FALSE;
    ELSE
      v_ColumnData      := v_ColumnData      || ',"' || r.COLUMN_NAME || '"';
      v_ColumnDataPivot := v_ColumnDataPivot || ',''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"';
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('LOOP iteration count = ' || v_cnt);
  DBMS_OUTPUT.PUT_LINE('v_ColumnData LEN      = ' || NVL(LENGTH(v_ColumnData), 0));
  DBMS_OUTPUT.PUT_LINE('v_ColumnDataPivot LEN = ' || NVL(LENGTH(v_ColumnDataPivot), 0));
  IF v_cnt = 0 THEN
    DBMS_OUTPUT.PUT_LINE('WARN: 빈 v_ColumnData → caller v_Query 가 ", FROM" 형태 invalid SQL → ORA-00936');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_ColumnData (first 300 ch)      = ' || SUBSTR(v_ColumnData, 1, 300));
    DBMS_OUTPUT.PUT_LINE('v_ColumnDataPivot (first 300 ch) = ' || SUBSTR(v_ColumnDataPivot, 1, 300));
  END IF;
END;
/

PROMPT === DIAG 6 : caller (CONTRIBUTE_MAIN_DATA) body 의 line 840-870 (ORA 발생 영역) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND line BETWEEN 835 AND 870
 ORDER BY line;

PROMPT === 판독 ===
PROMPT - DIAG 1 total_rows 가 0 → SCM_MST_SHEET_COLUMNS 에 DMF0043 column 정의 미시드. 별도 SEED 필요
PROMPT - DIAG 1 edit_flag_count 가 0 → 'EDIT_FLAG' row 없음. caller v_ColumnData 빌드 0건
PROMPT - DIAG 2 EDIT_FLAG SORT_ORDER_NO = max_sort (DIAG 1) → 마지막 위치. 그 이후 컬럼 없음
PROMPT - DIAG 3 = 0 → v_ColumnData 빈 string → dynamic SQL invalid → ORA-00936
PROMPT - DIAG 5 LOOP iteration = 0 → 확정 (caller 측 logic 시뮬레이션)
PROMPT - DIAG 6 line 845 의 SQL 텍스트 직접 확인
