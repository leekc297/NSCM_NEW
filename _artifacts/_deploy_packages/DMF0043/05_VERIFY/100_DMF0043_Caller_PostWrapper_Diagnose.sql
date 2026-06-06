--==============================================================================
-- 100_DMF0043_Caller_PostWrapper_Diagnose.sql
--
-- 목적: 005b wrapper 적용 후 caller 가 여전히 ORA-00936 → 빌드 단계 진단
--       - caller 호출 시 GT_DMF0043_TITLE INSERT 가 정상인지
--       - EDIT_FLAG SORT_ORDER_NO 와 SORT > EDIT_FLAG row 수
--       - 빌드된 v_ColumnData / v_ColumnDataPivot 시뮬레이션
--       - GT_DMF0043_TEMP3 상태 (PIVOT source)
-- 실행: SCM_MGR 세션
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : caller 호출 (ORA 폭발 예상) — GTT 상태 capture ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_title_cnt PLS_INTEGER;
  v_temp_cnt  PLS_INTEGER;
  v_temp2_cnt PLS_INTEGER;
  v_temp3_cnt PLS_INTEGER;
  v_data_cnt  PLS_INTEGER;
  v_gmst2_cnt PLS_INTEGER;
  v_edit_flag_sort NUMBER;
  v_above NUMBER;
BEGIN
  DELETE FROM SCM_MGR.GT_DMF0043_TITLE;
  BEGIN DELETE FROM SCM_MGR.GT_DMF0043_TEMP;       EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM SCM_MGR.GT_DMF0043_TEMP2;      EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM SCM_MGR.GT_DMF0043_TEMP3;      EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM SCM_MGR.GT_DMF0043_DATA_TABLE; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2;       EXCEPTION WHEN OTHERS THEN NULL; END;

  BEGIN
    SCM_MGR.DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','12','ALL','N','minyonglee1','ALL',v_rc);
    DBMS_OUTPUT.PUT_LINE('caller 정상 종료 (예상 외)');
    BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('caller ERR (예상): ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
  END;

  -- GTT 상태 (caller 폭발 후에도 잔존 — ON COMMIT PRESERVE)
  SELECT COUNT(*) INTO v_title_cnt FROM SCM_MGR.GT_DMF0043_TITLE;
  SELECT COUNT(*) INTO v_temp_cnt  FROM SCM_MGR.GT_DMF0043_TEMP;
  SELECT COUNT(*) INTO v_temp2_cnt FROM SCM_MGR.GT_DMF0043_TEMP2;
  SELECT COUNT(*) INTO v_temp3_cnt FROM SCM_MGR.GT_DMF0043_TEMP3;
  SELECT COUNT(*) INTO v_data_cnt  FROM SCM_MGR.GT_DMF0043_DATA_TABLE;
  SELECT COUNT(*) INTO v_gmst2_cnt FROM SCM_MGR.GT_GMST_TEMP2_2;

  DBMS_OUTPUT.PUT_LINE('--- GTT 적재 상태 ---');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TITLE      = ' || v_title_cnt || ' (caller INSERT — wrapper 124 row 동일해야)');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TEMP       = ' || v_temp_cnt);
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TEMP2      = ' || v_temp2_cnt);
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TEMP3      = ' || v_temp3_cnt);
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_DATA_TABLE = ' || v_data_cnt);
  DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP2_2       = ' || v_gmst2_cnt || ' (wrapper PKG 117 row 동일해야)');

  -- EDIT_FLAG SORT
  BEGIN
    SELECT TO_NUMBER(SORT_ORDER_NO) INTO v_edit_flag_sort
      FROM SCM_MGR.GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG';
    DBMS_OUTPUT.PUT_LINE('--- EDIT_FLAG SORT_ORDER_NO in GT_DMF0043_TITLE = ' || v_edit_flag_sort);
  EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('--- EDIT_FLAG row 없음');
    v_edit_flag_sort := NULL;
  END;

  IF v_edit_flag_sort IS NOT NULL THEN
    SELECT COUNT(*) INTO v_above FROM SCM_MGR.GT_DMF0043_TITLE
     WHERE TO_NUMBER(SORT_ORDER_NO) > v_edit_flag_sort;
    DBMS_OUTPUT.PUT_LINE('--- SORT > EDIT_FLAG row = ' || v_above);
  END IF;
END;
/

PROMPT === DIAG 2 : SORT > EDIT_FLAG row sample (caller 빌드 대상 COLUMN_NAME 검증) ===

SELECT TO_NUMBER(SORT_ORDER_NO) AS sort, COLUMN_NAME, LENGTH(COLUMN_NAME) AS col_len
  FROM SCM_MGR.GT_DMF0043_TITLE
 WHERE TO_NUMBER(SORT_ORDER_NO) > NVL((SELECT TO_NUMBER(SORT_ORDER_NO)
                                        FROM SCM_MGR.GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG'), -1)
 ORDER BY 1
 FETCH FIRST 20 ROWS ONLY;

PROMPT === DIAG 3 : caller 빌드 시뮬레이션 — v_ColumnData / v_ColumnDataPivot 첫 500 chars ===

DECLARE
  v_ColumnData      CLOB := EMPTY_CLOB();
  v_ColumnDataPivot CLOB := EMPTY_CLOB();
  v_first           BOOLEAN := TRUE;
  v_cnt             PLS_INTEGER := 0;
  v_edit_flag_sort  NUMBER;
BEGIN
  DBMS_LOB.CREATETEMPORARY(v_ColumnData, TRUE);
  DBMS_LOB.CREATETEMPORARY(v_ColumnDataPivot, TRUE);

  BEGIN
    SELECT TO_NUMBER(SORT_ORDER_NO) INTO v_edit_flag_sort
      FROM SCM_MGR.GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG';
  EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('EDIT_FLAG row 없음 — caller v_ColumnData 빈 string → ORA-00936 확정');
    RETURN;
  END;

  FOR r IN (
    SELECT COLUMN_NAME FROM SCM_MGR.GT_DMF0043_TITLE
     WHERE TO_NUMBER(SORT_ORDER_NO) > v_edit_flag_sort
     ORDER BY TO_NUMBER(SORT_ORDER_NO)
  ) LOOP
    v_cnt := v_cnt + 1;
    IF v_first THEN
      DBMS_LOB.APPEND(v_ColumnData, '"' || r.COLUMN_NAME || '"');
      DBMS_LOB.APPEND(v_ColumnDataPivot, '''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"');
      v_first := FALSE;
    ELSE
      DBMS_LOB.APPEND(v_ColumnData, ',"' || r.COLUMN_NAME || '"');
      DBMS_LOB.APPEND(v_ColumnDataPivot, ',''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"');
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('빌드된 COLUMN 수 = ' || v_cnt);
  DBMS_OUTPUT.PUT_LINE('v_ColumnData LEN      = ' || DBMS_LOB.GETLENGTH(v_ColumnData));
  DBMS_OUTPUT.PUT_LINE('v_ColumnDataPivot LEN = ' || DBMS_LOB.GETLENGTH(v_ColumnDataPivot));
  DBMS_OUTPUT.PUT_LINE('--- v_ColumnData 첫 500 chars ---');
  DBMS_OUTPUT.PUT_LINE(SUBSTR(DBMS_LOB.SUBSTR(v_ColumnData, 500, 1), 1, 500));
  DBMS_OUTPUT.PUT_LINE('--- v_ColumnDataPivot 첫 500 chars ---');
  DBMS_OUTPUT.PUT_LINE(SUBSTR(DBMS_LOB.SUBSTR(v_ColumnDataPivot, 500, 1), 1, 500));

  DBMS_LOB.FREETEMPORARY(v_ColumnData);
  DBMS_LOB.FREETEMPORARY(v_ColumnDataPivot);
END;
/

PROMPT === DIAG 4 : COLUMN_NAME 의 # 문자 / 공백 / 특수 char 통계 ===

SELECT COUNT(*) AS total,
       SUM(CASE WHEN INSTR(COLUMN_NAME, '#')      > 0 THEN 1 ELSE 0 END) AS has_hash,
       SUM(CASE WHEN INSTR(COLUMN_NAME, ' ')      > 0 THEN 1 ELSE 0 END) AS has_space,
       SUM(CASE WHEN LENGTH(COLUMN_NAME) > 30           THEN 1 ELSE 0 END) AS over_30_char,
       MAX(LENGTH(COLUMN_NAME)) AS max_col_len
  FROM SCM_MGR.GT_DMF0043_TITLE
 WHERE TO_NUMBER(SORT_ORDER_NO) > NVL((SELECT TO_NUMBER(SORT_ORDER_NO)
                                        FROM SCM_MGR.GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG'), -1);

PROMPT === DIAG 5 : GT_DMF0043_TEMP3 (PIVOT source) 상태 ===

SELECT COUNT(*) AS temp3_rows FROM SCM_MGR.GT_DMF0043_TEMP3;
SELECT * FROM SCM_MGR.GT_DMF0043_TEMP3 WHERE ROWNUM <= 5;

PROMPT === DIAG 6 : caller body 의 v_Query 빌드 시작 line (file 의 dynamic SQL 영역) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND line BETWEEN 800 AND 845
   AND (UPPER(text) LIKE '%V_QUERY%' OR UPPER(text) LIKE '%V_COLUMNDATA%' OR UPPER(text) LIKE '%PIVOT%')
 ORDER BY line;

PROMPT === 판독 ===
PROMPT - DIAG 1 GT_DMF0043_TITLE = 124 ✓ + EDIT_FLAG SORT = 800 ✓ + SORT > 800 row = 117 (3rd UNION) ✓ 면 v_ColumnData 정상 빌드 가능
PROMPT - DIAG 1 GT_DMF0043_TITLE = 0 → caller wrapper 호출 fail. wrapper 시그니처/타입 mismatch
PROMPT - DIAG 3 v_ColumnData LEN > 0 → 빌드 정상. caller 다른 부분 ORA-00936 원인
PROMPT - DIAG 4 has_space > 0 → COLUMN_NAME 의 ' ' 가 quoted identifier 안에서 문제? (Oracle 30-char identifier limit)
PROMPT - DIAG 4 max_col_len > 30 → ORA-00972 identifier 길이 초과
PROMPT - DIAG 5 GT_DMF0043_TEMP3 = 0 → PIVOT source 비어있음 → MAX(RATIO) 빈 cursor 정상 (dynamic SQL 자체는 valid 해야 OK)
PROMPT - DIAG 6 v_Query 빌드 영역 SQL — # 문자 / 공백 escape 누락 가능성 확인
