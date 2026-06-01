--==============================================================================
-- 41b_PKG_DMF0043_Spec_Body_Fix_Round2.sql
--
-- 41a 적용 결과:
--   - SCM_MST_COMPANY_SN view 생성 OK
--   - FN_SCM_STRING_SPLIT synonym 생성 OK
--   - SP #10 재컴파일 시도 → 일부 해결, 그러나 ORA-00904 "COLUMN_VALUE" 잔존
--   - 원인: FN_STRING_SPLIT 의 return type element 컬럼명이 'TOKEN' (COLUMN_VALUE 아님)
--           SP body 는 표준 'COLUMN_VALUE' 가정 → synonym 으로는 호환 불가
--
-- 본 Round 2 작업:
--   1) 41a 의 synonym 을 drop
--   2) 표준 VARCHAR2 collection type 으로 FN_SCM_STRING_SPLIT 신규 생성
--      → SQL 에서 'COLUMN_VALUE' 컬럼명 자동 사용 가능
--   3) SP #10 자동 재컴파일 → VALID
--
-- 멱등성: CREATE OR REPLACE — 재실행 OK.
-- 작성: 2026-05-30
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : synonym 제거 (function 으로 대체 예정) ===

DROP SYNONYM SCM_MGR.FN_SCM_STRING_SPLIT;

PROMPT === BLOCK 2 : T_SCM_STR_SPLIT_TAB collection type 생성 ===

CREATE OR REPLACE TYPE SCM_MGR.T_SCM_STR_SPLIT_TAB AS TABLE OF VARCHAR2(4000 CHAR);
/

PROMPT === BLOCK 3 : FN_SCM_STRING_SPLIT pipelined function 신규 생성 ===

CREATE OR REPLACE FUNCTION SCM_MGR.FN_SCM_STRING_SPLIT
(
    P_STR   IN VARCHAR2
   ,P_DELIM IN VARCHAR2 DEFAULT ','
)
RETURN SCM_MGR.T_SCM_STR_SPLIT_TAB PIPELINED IS
    v_start PLS_INTEGER := 1;
    v_end   PLS_INTEGER;
BEGIN
    IF P_STR IS NULL THEN
        RETURN;
    END IF;
    LOOP
        v_end := INSTR(P_STR, P_DELIM, v_start);
        IF v_end = 0 THEN
            PIPE ROW(SUBSTR(P_STR, v_start));
            EXIT;
        ELSE
            PIPE ROW(SUBSTR(P_STR, v_start, v_end - v_start));
            v_start := v_end + LENGTH(P_DELIM);
        END IF;
    END LOOP;
    RETURN;
END;
/

PROMPT === BLOCK 4 : SP #10 재컴파일 ===

ALTER PROCEDURE SCM_MGR.DMF0043_GET_CONTRIBUTION_SALES_LIST COMPILE;

PROMPT === BLOCK 5 : 최종 상태 ===

SELECT 'standalone SP count (10 expected)' AS K, COUNT(*) AS V
  FROM USER_OBJECTS
 WHERE OBJECT_NAME LIKE 'DMF0043_%'
   AND OBJECT_TYPE = 'PROCEDURE'
UNION ALL
SELECT 'standalone SP INVALID (0 expected)', COUNT(*)
  FROM USER_OBJECTS
 WHERE OBJECT_NAME LIKE 'DMF0043_%'
   AND OBJECT_TYPE = 'PROCEDURE'
   AND STATUS = 'INVALID'
UNION ALL
SELECT 'FN_SCM_STRING_SPLIT function (1 expected)', COUNT(*)
  FROM USER_OBJECTS
 WHERE OBJECT_NAME = 'FN_SCM_STRING_SPLIT' AND OBJECT_TYPE = 'FUNCTION';

PROMPT === BLOCK 6 : 잔존 오류 (0 expected) ===

SELECT NAME, TYPE, LINE, POSITION, TEXT
  FROM USER_ERRORS
 WHERE NAME LIKE 'DMF0043_%' AND TYPE = 'PROCEDURE';

COMMIT;

PROMPT === COMPLETE ===
EXIT;
