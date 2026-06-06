--==============================================================================
-- 080_DMF0043_PKG_SpreadTitle_Sig_Verify.sql
--
-- 목적: PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE 시그니처 + OPEN cursor 위치 확인
--       → standalone caller (CONTRIBUTE_MAIN_DATA) 가 PKG 호출 가능한지 검증
--       → Fix 방향 결정 (Option A vs B vs C)
-- 실행: SCM_MGR 세션
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : PKG.P_DMF0043_GET_MAIN_SPREAD_TITLE 시그니처 ===

SELECT argument_name, position, data_type, in_out, pls_type
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND package_name = 'PKG_DMF0043'
   AND object_name = 'P_DMF0043_GET_MAIN_SPREAD_TITLE'
 ORDER BY position;

PROMPT === DIAG 2 : standalone DMF0043_GET_MAIN_SPREAD_TITLE 시그니처 ===

SELECT argument_name, position, data_type, in_out, pls_type
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND package_name IS NULL
   AND object_name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
 ORDER BY position;

PROMPT === DIAG 3 : PKG.SPREAD_TITLE 의 OPEN cursor 위치 (line 244-470 내) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0043'
   AND type = 'PACKAGE BODY'
   AND line BETWEEN 244 AND 470
   AND REGEXP_LIKE(text, 'OPEN\s+\w+\s+FOR', 'i')
 ORDER BY line;

PROMPT === DIAG 4 : PKG.SPREAD_TITLE 의 declaration 영역 (line 244-260) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'PKG_DMF0043'
   AND type = 'PACKAGE BODY'
   AND line BETWEEN 244 AND 265
 ORDER BY line;

PROMPT === DIAG 5 : standalone caller (CONTRIBUTE_MAIN_DATA) 의 SPREAD_TITLE 호출 영역 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA'
   AND type = 'PROCEDURE'
   AND (UPPER(text) LIKE '%SPREAD_TITLE%' OR UPPER(text) LIKE '%PKG_DMF0043%')
 ORDER BY line;

PROMPT === DIAG 6 : PKG.P_DMF0043_GET_MAIN_SPREAD_TITLE 직접 호출 → GT_GMST 채워지는지 ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_gmst_cnt PLS_INTEGER;
  v_dummy VARCHAR2(100);
  v_cnt PLS_INTEGER := 0;
BEGIN
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP_2;  EXCEPTION WHEN OTHERS THEN NULL; END;

  -- PKG 시그니처가 standalone 과 다를 수 있으니 try with both shapes
  -- Try 1: 5 IN + 3 OUT (raw standalone 동일)
  BEGIN
    EXECUTE IMMEDIATE
      'BEGIN SCM_MGR.PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE(:1,:2,:3,:4,:5,:6,:7,:8); END;'
      USING '40', '2024', 'minyonglee1', 'minyonglee1', 'DMF0043',
            OUT v_rc, OUT v_rc, OUT v_rc;
    DBMS_OUTPUT.PUT_LINE('[Try 1] PKG.SPREAD_TITLE 호출 (5 IN + 3 OUT) — 성공');
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[Try 1] 호출 ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM,1,150));
  END;

  -- Try 2: 5 IN + 2 OUT (O_RC1 + O_RESULT_CURSOR)
  BEGIN
    EXECUTE IMMEDIATE
      'BEGIN SCM_MGR.PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE(:1,:2,:3,:4,:5,:6,:7); END;'
      USING '40', '2024', 'minyonglee1', 'minyonglee1', 'DMF0043',
            OUT v_rc, OUT v_result_rc;
    DBMS_OUTPUT.PUT_LINE('[Try 2] PKG.SPREAD_TITLE 호출 (5 IN + 2 OUT) — 성공');
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[Try 2] 호출 ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM,1,150));
  END;

  -- 호출 후 GT_GMST 인벤토리
  SELECT COUNT(*) INTO v_gmst_cnt FROM SCM_MGR.GT_GMST_TEMP2_2;
  DBMS_OUTPUT.PUT_LINE('  -> GT_GMST_TEMP2_2 row = ' || v_gmst_cnt || ' (예상: OS_CORP 수 × 13 = 13~26+)');
  BEGIN
    SELECT COUNT(*) INTO v_gmst_cnt FROM SCM_MGR.GT_GMST_TEMP_2;
    DBMS_OUTPUT.PUT_LINE('  -> GT_GMST_TEMP_2  row = ' || v_gmst_cnt || ' (예상: OS_CORP 마스터)');
  EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('DIAG 6 outer ERR ' || SQLCODE || ' / ' || SQLERRM);
END;
/

PROMPT === DIAG 7 : SCM_ADM_LOOKUP_MASTER_DETAIL 'DM_OS_CORP_CD' 마스터 데이터 (PKG SPREAD_TITLE 의 첫 INSERT source) ===

SELECT segment1 AS code, segment2 AS name, display_seq, segment4, valid_yn
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE lookup_type = 'DM_OS_CORP_CD'
   AND valid_yn = 'Y'
   AND segment4 = 'N'
 ORDER BY display_seq;

PROMPT === 판독 ===
PROMPT - DIAG 1 vs DIAG 2 시그니처 비교 — 동일 (5 IN + 3 OUT) 이면 caller 호출 단순 PKG_ prefix 추가만
PROMPT - DIAG 3 PKG SPREAD_TITLE OPEN cursor 위치 — O_RC1/O_RC2/O_RC3 패턴 확인
PROMPT - DIAG 5 caller 의 SPREAD_TITLE 호출 위치 — patch 대상 line
PROMPT - DIAG 6 PKG 직접 호출 후 GT_GMST_TEMP2_2 > 0 → Option A 확정 (caller 의 호출을 PKG path 로 변경)
PROMPT - DIAG 7 LOOKUP_MASTER_DETAIL 의 OS_CORP 마스터 N개 → GT_GMST_TEMP_2 N row → GT_GMST_TEMP2_2 N×13 row
