--==============================================================================
-- 200_DMF0008_SALES_SITE_Body_Line1_170_RealError.sql
--
-- 목적:
--   DMF0008_GET_SALES_SITE 가 line 184 EXCEPTION 절로 빠지면서 generic
--   ORA-20001 raise. 진짜 SQLCODE/SQLERRM 가려짐.
--   line 1-170 (GTT 채우는 logic) + GTT 인벤토리 + grant 확인 + 마지막 로그 추적.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : SP body line 1-50 (PROCEDURE 선언 + 변수) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND line BETWEEN 1 AND 50
 ORDER BY line;

PROMPT === DIAG 2 : SP body line 50-110 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND line BETWEEN 50 AND 110
 ORDER BY line;

PROMPT === DIAG 3 : SP body line 110-175 (IF v_cnt_1 이전 본문) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND line BETWEEN 110 AND 175
 ORDER BY line;

PROMPT === DIAG 4 : GTT 인벤토리 (GT_GSSI_DMF0008_*) ===

SELECT owner, table_name, duration, status
  FROM all_tables
 WHERE table_name LIKE 'GT_GSSI_DMF0008%'
    OR table_name LIKE 'GT_%DMF0008%'
 ORDER BY owner, table_name;

PROMPT === DIAG 5 : SCMD_APP 가 GTT 에 grant 있는지 ===

SELECT grantee, owner, table_name, privilege
  FROM dba_tab_privs
 WHERE grantee = 'SCMD_APP'
   AND table_name LIKE 'GT_GSSI_DMF0008%'
 ORDER BY table_name, privilege;

PROMPT === DIAG 6 : SP body 가 사용하는 모든 테이블/객체 grep ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'FROM\s+\w+|INTO\s+\w+|INSERT\s+INTO\s+\w+|UPDATE\s+\w+', 'i')
   AND NOT REGEXP_LIKE(text, '^\s*(--|/\*)', 'i')  -- 주석 제외
 ORDER BY line;

PROMPT === DIAG 7 : SP body 에서 호출하는 다른 SP/FUNC ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'PR_|PKG_|UF_|DMF0008_|SCM[0-9]', 'i')
 ORDER BY line
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 8 : EXCEPTION handler 임시 우회 — line 1-170 코드를 anonymous block 으로 분리 실행 ===
-- 이 진단은 SP body 정보 본 후 작성 (DIAG 1-3 결과 받은 후)
-- 지금은 GTT 직접 SELECT 만 시도 (권한 검증)

DECLARE
  v_cnt PLS_INTEGER;
BEGIN
  -- GT_GSSI_DMF0008_RESULT_TABLE_1_2 직접 SELECT 권한 확인
  EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.GT_GSSI_DMF0008_RESULT_TABLE_1_2' INTO v_cnt;
  DBMS_OUTPUT.PUT_LINE('GT_GSSI_DMF0008_RESULT_TABLE_1_2 COUNT = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('GT_GSSI_DMF0008_RESULT_TABLE_1_2 ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

DECLARE
  v_cnt PLS_INTEGER;
BEGIN
  EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.GT_GSSI_DMF0008_RESULT_TABLE_2_2' INTO v_cnt;
  DBMS_OUTPUT.PUT_LINE('GT_GSSI_DMF0008_RESULT_TABLE_2_2 COUNT = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('GT_GSSI_DMF0008_RESULT_TABLE_2_2 ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === 판독 ===
PROMPT - DIAG 1-3: SP body line 1-170 본문 logic 확인. 어떤 INSERT/SELECT 가 ORA 유발 가능한지
PROMPT - DIAG 4: GTT 존재. 미존재면 ORA-00942
PROMPT - DIAG 5: SCMD_APP grant 누락 시 ORA-00942 / ORA-01031
PROMPT - DIAG 6/7: SP body 의 의존 객체 인벤토리
PROMPT - DIAG 8: GTT 직접 SELECT — 권한 + 존재 검증
