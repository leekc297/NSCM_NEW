--==============================================================================
-- 070_DMF0043_PKG_Inventory_Diagnose.sql
--
-- 목적: PKG_DMF0043 PACKAGE BODY 의 procedure 인벤토리 + GT_GMST_TEMP2_2 채우는
--       procedure 식별 → BE routing 을 standalone vs PKG 중 어느 쪽으로 할지 결정
-- 실행: SCM_MGR 세션
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : PKG_DMF0043 SPEC/BODY 상태 ===

SELECT object_name, object_type, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name = 'PKG_DMF0043'
 ORDER BY object_type;

PROMPT === DIAG 2 : PKG_DMF0043 안의 procedure 인벤토리 ===

SELECT procedure_name
  FROM all_procedures
 WHERE owner = 'SCM_MGR'
   AND object_name = 'PKG_DMF0043'
   AND procedure_name IS NOT NULL
 ORDER BY procedure_name;

PROMPT === DIAG 3 : line 295-330 (GT_GMST INSERT 3건 영역) — 어느 procedure 안인지 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0043'
   AND type = 'PACKAGE BODY'
   AND line BETWEEN 290 AND 330
 ORDER BY line;

PROMPT === DIAG 4 : line 430-470 (GT_GMST SELECT 영역) — 어느 procedure 안인지 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0043'
   AND type = 'PACKAGE BODY'
   AND line BETWEEN 425 AND 470
 ORDER BY line;

PROMPT === DIAG 5 : PKG_DMF0043 안의 모든 PROCEDURE 선언 위치 (BEGIN line) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0043'
   AND type = 'PACKAGE BODY'
   AND REGEXP_LIKE(text, '^\s*PROCEDURE\s+\w+|^\s*FUNCTION\s+\w+', 'i')
 ORDER BY line;

PROMPT === DIAG 6 : PKG_DMF0043 의 P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 호출 시 GT_GMST 채워지는지 ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_gmst_cnt PLS_INTEGER;
  v_title_cnt PLS_INTEGER;
BEGIN
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;
  DELETE FROM SCM_MGR.GT_DMF0043_TITLE;

  -- PKG 의 P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 호출 시도 (이름 있는 경우)
  BEGIN
    EXECUTE IMMEDIATE 'BEGIN SCM_MGR.PKG_DMF0043.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA(:1,:2,:3,:4,:5,:6,:7); END;'
      USING '2024', '12', 'ALL', 'N', 'minyonglee1', 'ALL', OUT v_rc;
    DBMS_OUTPUT.PUT_LINE('PKG.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 호출 성공');
    BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('PKG.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 호출 ERR: ' || SQLCODE || ' / ' || SUBSTR(SQLERRM,1,150));
  END;

  -- 호출 후 GT 인벤토리
  BEGIN
    SELECT COUNT(*) INTO v_gmst_cnt FROM SCM_MGR.GT_GMST_TEMP2_2;
    DBMS_OUTPUT.PUT_LINE('  -> GT_GMST_TEMP2_2 row = ' || v_gmst_cnt);
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('  -> GT_GMST SELECT ERR: ' || SQLERRM);
  END;

  SELECT COUNT(*) INTO v_title_cnt FROM SCM_MGR.GT_DMF0043_TITLE;
  DBMS_OUTPUT.PUT_LINE('  -> GT_DMF0043_TITLE row = ' || v_title_cnt);
END;
/

PROMPT === 판독 ===
PROMPT - DIAG 1 PACKAGE BODY VALID → PKG 사용 가능. INVALID → 컴파일 오류 확인
PROMPT - DIAG 2 procedure 목록에 P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 있는지 → 있으면 BE routing 을 PKG 로 변경 가능
PROMPT - DIAG 3 line 295-330 의 INSERT 가 어느 PROCEDURE 안에 있는지 확인
PROMPT - DIAG 4 line 430-470 의 SELECT 가 어느 PROCEDURE 안에 있는지
PROMPT - DIAG 5 PKG 안의 모든 PROCEDURE 시작 line — DIAG 3/4 의 위치가 어느 PROCEDURE 안인지 cross-ref
PROMPT - DIAG 6 PKG.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA 호출 성공 + GT_GMST > 0 → 사고 해결 경로 = 메타를 PKG path 로 환원
