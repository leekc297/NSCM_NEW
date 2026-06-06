--==============================================================================
-- 060_DMF0043_GT_GMST_Diagnose.sql
--
-- 목적: SPREAD_TITLE 의 3rd UNION SELECT 의 source 인 GT_GMST_TEMP2_2 진단
--       + caller (CONTRIBUTE_MAIN_DATA) 가 GT_GMST_TEMP2_2 를 채우는 logic 위치
--       + SPREAD_TITLE 단독 호출 후 GT_DMF0043_TITLE 실제 row count
-- 실행: SCM_MGR 세션
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : GT_GMST_TEMP2_2 (GTT) 존재 + 컬럼 인벤토리 ===

SELECT table_name, temporary, duration
  FROM all_tables
 WHERE owner = 'SCM_MGR'
   AND table_name LIKE 'GT_GMST%';

SELECT column_name, data_type, data_length, nullable
  FROM all_tab_columns
 WHERE owner = 'SCM_MGR'
   AND table_name = 'GT_GMST_TEMP2_2'
 ORDER BY column_id;

PROMPT === DIAG 2 : caller (CONTRIBUTE_MAIN_DATA) 본문 안에서 GT_GMST_TEMP2_2 INSERT 위치 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND UPPER(text) LIKE '%GT_GMST%'
 ORDER BY line;

PROMPT === DIAG 3 : 다른 SP/PKG 에서 GT_GMST_TEMP2_2 사용 위치 (마스터 시드 SP 식별) ===

SELECT owner, name, type, line, SUBSTR(text, 1, 100) AS text_snippet
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND UPPER(text) LIKE '%GT_GMST_TEMP2_2%'
   AND name <> 'DMF0043_GET_MAIN_SPREAD_TITLE'
 ORDER BY name, line
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 4 : fn_string_split 함수 존재 (SPREAD_TITLE line 158/192 사용) ===

SELECT owner, object_name, object_type, status
  FROM all_objects
 WHERE object_name IN ('FN_STRING_SPLIT', 'FN_SCM_STRING_SPLIT', 'UF_FX_STRING_SPLIT')
 ORDER BY object_name, owner;

PROMPT === DIAG 5 : SPREAD_TITLE 단독 호출 → GT_DMF0043_TITLE 실제 row count ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc2 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_title_cnt PLS_INTEGER;
  v_dummy VARCHAR2(100);
BEGIN
  DELETE FROM SCM_MGR.GT_DMF0043_TITLE;
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;

  SCM_MGR.DMF0043_GET_MAIN_SPREAD_TITLE(
    p_division_id => '40',
    p_yyyy        => '2024',
    p_created_by  => 'minyonglee1',
    p_user_id     => 'minyonglee1',
    p_menu_id     => 'DMF0043',
    O_RC1         => v_rc1,
    O_RC2         => v_rc2,
    O_RC3         => v_rc3
  );

  -- caller 와 동일하게 v_rc1 fetch → GT_DMF0043_TITLE INSERT 시뮬레이션 불가능 (22 변수 fetch 필요)
  -- 단순 row count 만 확인 (fetch 안 하고 cursor 자체의 row 수 셈)
  DECLARE v_cnt PLS_INTEGER := 0; BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND; v_cnt := v_cnt + 1; END LOOP;
    DBMS_OUTPUT.PUT_LINE('SPREAD_TITLE O_RC1 row count (단독 호출, single-col fetch) = ' || v_cnt);
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SPREAD_TITLE O_RC1 fetch ERR (column mismatch 정상) ' || SQLCODE);
  END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;

  SELECT COUNT(*) INTO v_title_cnt FROM SCM_MGR.GT_GMST_TEMP2_2;
  DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP2_2 row count (호출 후) = ' || v_title_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('DIAG 5 ERR ' || SQLCODE || ' / ' || SQLERRM);
END;
/

PROMPT === DIAG 6 : caller (CONTRIBUTE_MAIN_DATA) 호출 시 GT_GMST_TEMP2_2 가 채워지는지 확인 ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_gmst_cnt PLS_INTEGER;
  v_title_cnt PLS_INTEGER;
BEGIN
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;
  DELETE FROM SCM_MGR.GT_DMF0043_TITLE;

  -- caller 호출 (ORA-00936 폭발 예상 — 그 전에 GT 가 채워졌는지 확인)
  BEGIN
    SCM_MGR.DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','12','ALL','N','minyonglee1','ALL',v_rc);
    DBMS_OUTPUT.PUT_LINE('caller 정상 종료 (예상 외)');
    BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('caller ERR (예상): ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
  END;

  -- 폭발 전까지 채워진 GT 인벤토리
  SELECT COUNT(*) INTO v_title_cnt FROM SCM_MGR.GT_DMF0043_TITLE;
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TITLE      = ' || v_title_cnt || ' row (SPREAD_TITLE 후 fetch INSERT 결과)');

  BEGIN
    SELECT COUNT(*) INTO v_gmst_cnt FROM SCM_MGR.GT_GMST_TEMP2_2;
    DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP2_2       = ' || v_gmst_cnt || ' row (caller/SPREAD_TITLE 내부 INSERT 결과)');
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP2_2 SELECT ERR: ' || SQLERRM);
  END;
END;
/

PROMPT === 판독 ===
PROMPT - DIAG 1 table 0 row → GT_GMST_TEMP2_2 자체 없음. SP body 의 3rd UNION SELECT ORA-942 가능 (1st 만 동작)
PROMPT - DIAG 2 row 0 → caller 가 GT_GMST_TEMP2_2 안 채움. 별도 SP/마스터 시드 필요
PROMPT - DIAG 3 다른 SP 가 GT_GMST_TEMP2_2 INSERT → 그 SP 가 caller 호출 전에 실행되어야 함
PROMPT - DIAG 4 fn_string_split 없음 → SPREAD_TITLE 의 1st SELECT 도 line 158 ORA-904. uf_fx_string_split 로 교체 필요
PROMPT - DIAG 5 SPREAD_TITLE 단독 호출 후 GT_GMST = 0 → SP 본문이 GT 안 채움
PROMPT - DIAG 6 caller 호출 후 GT_DMF0043_TITLE = 8 (BASE only) / GT_GMST = 0 → 동적 컬럼 0 → ORA-00936 확정
