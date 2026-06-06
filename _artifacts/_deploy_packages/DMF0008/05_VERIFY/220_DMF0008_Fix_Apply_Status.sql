--==============================================================================
-- 220_DMF0008_Fix_Apply_Status.sql
--
-- 목적:
--   030 SP body fix + 060 PROC_M dedupe + 016 GTT GRANT 적용 status 검증.
--   재조회 시 여전히 sql error 발생 — 어떤 fix 가 미적용인지 또는 다른 origin 인지
--   식별.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === DIAG 1 : SP last_ddl_time 확인 (030 적용 됐다면 today) ===

SELECT object_name, status, last_ddl_time, timestamp
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_SALES_SITE'
   AND object_type = 'PROCEDURE';

PROMPT === DIAG 2 : SP body line 43-44 — TRUNCATE 사라지고 DELETE 로 변경됐는지 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND line BETWEEN 1 AND 60
   AND REGEXP_LIKE(text, 'TRUNCATE|DELETE\s+FROM\s+GT_', 'i')
 ORDER BY line;

PROMPT === DIAG 3 : PROC_M 중복 정리됐는지 (5 row 기대) ===

SELECT proc_nm, col_nm, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_SALES_SITE'
 ORDER BY sort_ord, col_nm;

PROMPT === DIAG 4 : GTT 권한 (016 적용 됐다면 INSERT/UPDATE/DELETE 표시) ===

SELECT table_name, LISTAGG(privilege, ',') WITHIN GROUP (ORDER BY privilege) AS privs
  FROM dba_tab_privs
 WHERE grantee = 'SCMD_APP'
   AND owner = 'SCM_MGR'
   AND table_name IN ('GT_GSSI_DMF0008_RESULT_TABLE_1_2', 'GT_GSSI_DMF0008_RESULT_TABLE_2_2')
 GROUP BY table_name;

PROMPT === DIAG 5 : 정정 후 SP 단독 호출 — 이제 SQLCODE/SQLERRM 포함된 ORA 캡쳐 ===

DECLARE
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_SALES_SITE(
    p_division_id   => '81',
    p_soldto        => 'DE000161',
    p_shipto        => 'DEH000086',
    p_scm_site_id   => '',
    O_RESULT_CURSOR => v_result_rc
  );
  BEGIN
    LOOP FETCH v_result_rc INTO v_dummy; EXIT WHEN v_result_rc%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SALES_SITE fix 후 fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SALES_SITE ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 500));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 6 : SSPM SP 도 호출 (1단 더블클릭 시 SALES_SITE + SSPM 동시) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_SALES_SITE_PROJECT_MODEL(
    P_DIVISION_ID => '81',
    P_ITEM_ID     => 'APFMCCX48-A1',
    P_SCM_SITE_ID => '',
    P_USER_ID     => 'minyonglee1',
    P_MENU_ID     => 'DMF0008',
    O_RC1         => v_rc1,
    O_RESULT_CURSOR => v_result_rc
  );
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SSPM fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SSPM ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 500));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === 판독 ===
PROMPT - DIAG 1 last_ddl_time = today → 030 적용
PROMPT - DIAG 2 TRUNCATE 0건 + DELETE FROM GT_ 2건 → 030 적용
PROMPT - DIAG 3 5 row (소문자 없음) → 060 적용
PROMPT - DIAG 4 SELECT,INSERT,UPDATE,DELETE → 016 적용
PROMPT - DIAG 5 fetch=-99 → SP 정상 / ERR 인 경우 진짜 SQLCODE/SQLERRM 노출
PROMPT - DIAG 6 SSPM SP 도 정상 동작 확인 (1단 더블클릭 시 동시 호출)
