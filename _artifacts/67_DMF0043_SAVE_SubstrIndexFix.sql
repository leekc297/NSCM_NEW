--==============================================================================
-- 67_DMF0043_SAVE_SubstrIndexFix.sql
--
-- 사고: DMF0043 저장 시 ORA-01722 (unable to convert string '^' to number).
-- 원인: SP `DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO` 의 13곳 SUBSTR 가
--       `SUBSTR(s, 0, v_index_xxx)` 패턴 (MSSQL SUBSTRING 변환 누락).
--       v_index_xxx 는 INSTR 결과 = ^ 위치. Oracle SUBSTR(s, 0, idx) 는
--       offset 0 == 1, length = idx → ^ 까지 포함하여 추출 → number 변환 폭발.
-- Fix: 13곳 모두 `, 0, v_index_xxx)` → `, 1, v_index_xxx - 1)`.
-- 작성: 2026-06-01 / minyonglee1
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_cnt_before PLS_INTEGER;
    v_cnt_after  PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME='DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO' AND TYPE='PROCEDURE' ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    v_cnt_before := REGEXP_COUNT(v_src, 'SUBSTR\(vp_\w+\s*,\s*0\s*,\s*v_index_\w+\s*\)');
    DBMS_OUTPUT.PUT_LINE('SUBSTR(.., 0, v_index_..) BEFORE: ' || v_cnt_before);

    -- 13곳 SUBSTR(vp_xxx, 0, v_index_xxx) → SUBSTR(vp_xxx, 1, v_index_xxx - 1)
    v_patched := REGEXP_REPLACE(
        v_src,
        'SUBSTR\((vp_\w+)(\s*,\s*)0(\s*,\s*)(v_index_\w+)(\s*)\)',
        'SUBSTR(\1\g<2>1\g<3>\4\g<5> - 1)'
    );

    v_cnt_after := REGEXP_COUNT(v_patched, 'SUBSTR\(vp_\w+\s*,\s*0\s*,\s*v_index_\w+\s*\)');
    DBMS_OUTPUT.PUT_LINE('SUBSTR(.., 0, v_index_..) AFTER : ' || v_cnt_after);

    IF v_cnt_after > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Patch incomplete: ' || v_cnt_after || ' remaining.');
    END IF;

    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_patched;
    DBMS_OUTPUT.PUT_LINE('SP recompiled.');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO';

PROMPT === SP 직접 호출 검증 ===
DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO(
    p_active_flag => 'M',
    p_ver_seq => '12',
    p_department_id => '58691249',
    p_dept_id => '70090866',
    p_end_cust_report => 'Acell',
    p_soldto_cust_report => 'Acell',
    p_product_group => '원통형',
    p_dm_biz_type => 'CELL',
    p_yyyymm => '202401',
    p_os_corp_cd => 'RBU_0001',
    p_contribution_type => 'COMMISSION',
    p_contribution_ratio => '99',
    p_created_by => 'minyonglee1',
    O_RC1 => v_rc
  );
  DBMS_OUTPUT.PUT_LINE('SP success');
  BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR: ' || SQLERRM);
END;
/

EXIT;
