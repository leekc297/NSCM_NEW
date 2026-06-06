--==============================================================================
-- 240_DMF0008_REPAIR_DataDist_PFlag_Detail.sql
--
-- 목적:
--   1) SP body line 191-204 정밀 추출 (p_Flag 분기 logic)
--   2) BMW row 의 STATUS_CODE / EXCEPTION_FLAG distribution (마스터 0 분류 원인)
--   3) p_Flag='4' / '5' / '6' 정확 row count (RECORD type fetch)
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === DIAG 1 : SP body line 185-210 (p_Flag 분기 정밀) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND line BETWEEN 185 AND 215
 ORDER BY line;

PROMPT === DIAG 2 : BMW row 의 STATUS_CODE distribution (마스터 0 분류 원인) ===

SELECT STATUS_CODE, COUNT(*) AS row_cnt
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '81'
   AND SENDER_NAME = 'BMW'
   AND CREATE_DATE >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 52*7, 'YYYYMMDD')
   AND ERP_STATUS = 'S'
   AND LTRIM(RTRIM(YYYYMMDD)) NOT IN ('444444')
 GROUP BY STATUS_CODE
 ORDER BY row_cnt DESC;

PROMPT === DIAG 3 : BMW row 의 EXCEPTION_FLAG distribution ===

SELECT EXCEPTION_FLAG, COUNT(*) AS row_cnt
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '81'
   AND SENDER_NAME = 'BMW'
   AND CREATE_DATE >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 52*7, 'YYYYMMDD')
   AND ERP_STATUS = 'S'
   AND LTRIM(RTRIM(YYYYMMDD)) NOT IN ('444444')
 GROUP BY EXCEPTION_FLAG
 ORDER BY row_cnt DESC;

PROMPT === DIAG 4 : REPAIR SP p_Flag='4' 정확 row count (RECORD type fetch) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  TYPE r_rec IS RECORD (
    DIVISION_ID     VARCHAR2(50),
    EDI_SENDER_CODE VARCHAR2(50),
    EDI_SENDER_NAME VARCHAR2(100)
  );
  v_rec r_rec;
  v_cnt PLS_INTEGER := 0;

  PROCEDURE try_flag(p_flag VARCHAR2) IS
    v_rc2 SYS_REFCURSOR;
    v_r2 SYS_REFCURSOR;
    v_c PLS_INTEGER := 0;
    v_dv VARCHAR2(50);
  BEGIN
    DMF0008_GET_EDI_MST_REPAIR(
      P_DIVISION_ID   => '81',
      P_FROM_YYYYMMDD => '20240101',
      P_TO_YYYYMMDD   => '20261231',
      P_SENDER_NAME   => 'BMW',
      P_FLAG          => p_flag,
      P_USER_ID       => 'minyonglee1',
      P_MENU_ID       => 'DMF0008',
      O_RC1           => v_rc2,
      O_RESULT_CURSOR => v_r2
    );
    LOOP
      FETCH v_rc2 INTO v_dv
                    , v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv  -- 10 col 까지
                    , v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv
                    , v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv, v_dv
                    , v_dv, v_dv, v_dv, v_dv;  -- 34 col 시도 (REPAIR SP 컬럼 수 추정)
      EXIT WHEN v_rc2%NOTFOUND;
      v_c := v_c + 1;
    END LOOP;
    BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_r2; EXCEPTION WHEN OTHERS THEN NULL; END;
    DBMS_OUTPUT.PUT_LINE('BMW + flag=[' || p_flag || '] rows = ' || v_c);
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('BMW + flag=[' || p_flag || '] ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 100));
  END;
BEGIN
  try_flag('4');
  try_flag('5');
  try_flag('6');
END;
/

PROMPT === DIAG 5 : REPAIR SP body 의 column 수 확인 (SELECT 절 column 수) ===

SELECT COUNT(*) AS column_count
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND line BETWEEN 70 AND 105  -- OPEN O_RC1 FOR SELECT 영역
   AND text LIKE ', TF.%';

PROMPT === 판독 ===
PROMPT - DIAG 1 line 192-194 의 ELSE 절 (p_Flag != '6' 일 때 무엇 비교?) 확인
PROMPT - DIAG 2 STATUS_CODE distribution — 'U','E','S' 외 다른 값 있는지
PROMPT - DIAG 3 EXCEPTION_FLAG distribution — 대부분 NULL 이면 NVL(.., NULL) != 'Y' = UNKNOWN
PROMPT - DIAG 4 flag='4'/'5'/'6' 각 row 수 — SP 정상 동작 확인
PROMPT - DIAG 5 REPAIR SELECT 의 column 수 (RECORD type 정확 매칭 위함)
