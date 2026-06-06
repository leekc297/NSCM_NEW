--==============================================================================
-- 030_DMF0043_State_Diagnose.sql
--
-- 목적: 055/056 patch 적용 결과 + SP 호출 실패 지점 정확 진단
-- 실행: SCM_MGR 세션 (SCMD_APP 도 ALL_SOURCE 가능). SQL*Plus / DBeaver 모두 OK.
-- 작성: 2026-06-04
--==============================================================================
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
SET PAGESIZE 100

PROMPT === DIAG 1 : DMF0043_GET_MAIN_SPREAD_TITLE 상태 + 마지막 변경 시각 ===

SELECT object_name, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0043_GET_MAIN_SPREAD_TITLE';

PROMPT === DIAG 2 : default branch (IF v_user_col_cnt = 0 ...) 주변 30 라인 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
   AND type = 'PROCEDURE'
   AND line BETWEEN
       (SELECT MIN(line) - 5
          FROM all_source
         WHERE owner = 'SCM_MGR'
           AND name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
           AND type = 'PROCEDURE'
           AND REGEXP_LIKE(text, 'v_user_col_cnt\s*=\s*0', 'i'))
       AND
       (SELECT MIN(line) + 30
          FROM all_source
         WHERE owner = 'SCM_MGR'
           AND name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
           AND type = 'PROCEDURE'
           AND REGEXP_LIKE(text, 'v_user_col_cnt\s*=\s*0', 'i'))
 ORDER BY line;

PROMPT === DIAG 3 : 모든 OPEN O_RCn FOR 위치 (default 분기 어느 cursor 여는지) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'OPEN\s+O_RC[1-9]\s+FOR', 'i')
 ORDER BY line;

PROMPT === DIAG 4 : DMF0043_GET_MAIN_SPREAD_TITLE 단독 호출 (caller 사용 IN params) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc2 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_rc1_cnt PLS_INTEGER := 0;
  v_rc2_cnt PLS_INTEGER := 0;
  v_rc3_cnt PLS_INTEGER := 0;
  v_dummy   VARCHAR2(4000);
BEGIN
  -- caller 가 사용하는 IN params 그대로
  DMF0043_GET_MAIN_SPREAD_TITLE(
    p_division_id => '40',
    p_yyyy        => '2024',
    p_created_by  => 'minyonglee1',
    p_user_id     => 'minyonglee1',
    p_menu_id     => 'DMF0043',
    O_RC1         => v_rc1,
    O_RC2         => v_rc2,
    O_RC3         => v_rc3
  );

  -- O_RC1 row count
  BEGIN
    IF v_rc1%ISOPEN THEN
      LOOP
        FETCH v_rc1 INTO v_dummy;
        EXIT WHEN v_rc1%NOTFOUND;
        v_rc1_cnt := v_rc1_cnt + 1;
      END LOOP;
      CLOSE v_rc1;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_rc1_cnt := -99;  -- fetch 컬럼 수 불일치 등
  END;

  -- O_RC2 row count
  BEGIN
    IF v_rc2%ISOPEN THEN
      LOOP
        FETCH v_rc2 INTO v_dummy;
        EXIT WHEN v_rc2%NOTFOUND;
        v_rc2_cnt := v_rc2_cnt + 1;
      END LOOP;
      CLOSE v_rc2;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_rc2_cnt := -99;
  END;

  -- O_RC3 row count
  BEGIN
    IF v_rc3%ISOPEN THEN
      LOOP
        FETCH v_rc3 INTO v_dummy;
        EXIT WHEN v_rc3%NOTFOUND;
        v_rc3_cnt := v_rc3_cnt + 1;
      END LOOP;
      CLOSE v_rc3;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_rc3_cnt := -99;
  END;

  DBMS_OUTPUT.PUT_LINE('O_RC1 rows = ' || v_rc1_cnt || ' (caller 가 fetch — 이 값이 0 이면 GT_TITLE 0건 → ORA-01001)');
  DBMS_OUTPUT.PUT_LINE('O_RC2 rows = ' || v_rc2_cnt);
  DBMS_OUTPUT.PUT_LINE('O_RC3 rows = ' || v_rc3_cnt || ' (default branch 가 잘못 OPEN — 22 면 fix 미적용 확정)');
  DBMS_OUTPUT.PUT_LINE('(-99 = fetch column 수 불일치, dummy 1개 fetch 실패)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('DIAG 4 ERR ' || SQLCODE || ' / ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 5 : caller (CONTRIBUTE_MAIN_DATA) 호출 후 GT_TITLE 카운트 + 에러 ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_title_cnt NUMBER := 0;
BEGIN
  DELETE FROM GT_DMF0043_TITLE;
  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','12','ALL','N','minyonglee1','ALL',v_rc);
  SELECT COUNT(*) INTO v_title_cnt FROM GT_DMF0043_TITLE;
  DBMS_OUTPUT.PUT_LINE('Caller OK. GT_DMF0043_TITLE = ' || v_title_cnt || ' rows');
  BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  SELECT COUNT(*) INTO v_title_cnt FROM GT_DMF0043_TITLE;
  DBMS_OUTPUT.PUT_LINE('Caller ERR ' || SQLCODE || ' / ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TITLE (at exception) = ' || v_title_cnt || ' rows');
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
