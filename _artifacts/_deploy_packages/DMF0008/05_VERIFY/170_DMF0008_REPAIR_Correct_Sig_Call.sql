--==============================================================================
-- 170_DMF0008_REPAIR_Correct_Sig_Call.sql
--
-- 목적:
--   160 의 DIAG 7 호출이 잘못된 signature (P_SENDER_NAME/P_FLAG 누락, O_RC3 존재 안함)
--   로 PLS-00306. SP 본문 자체의 ORA 캡쳐를 위해 DIAG 2 정확한 9 args 로 재호출.
--
-- 정확한 signature (DIAG 2):
--   P_DIVISION_ID, P_FROM_YYYYMMDD, P_TO_YYYYMMDD, P_SENDER_NAME, P_FLAG,
--   P_USER_ID, P_MENU_ID, O_RC1, O_RESULT_CURSOR
--   (O_RC3 없음 — SUMMARY 와 다른 sig)
--
-- 사과 메모: 160 진단 SQL 은 SUMMARY sig 추정 오류. anti-simplification 위반.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : SP body line 66-90 (메인 SELECT 시작 부분 — FROM/WHERE/JOIN 확인) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND line BETWEEN 66 AND 95
 ORDER BY line;

PROMPT === DIAG 2 : SP body line 280-309 (EXCEPTION handler) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND line BETWEEN 280 AND 309
 ORDER BY line;

PROMPT === DIAG 3 : 정확한 9 args 호출 — div=81 + senderName=BMW + flag=ALL ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_EDI_MST_REPAIR(
    P_DIVISION_ID   => '81',
    P_FROM_YYYYMMDD => '20240101',
    P_TO_YYYYMMDD   => '20261231',
    P_SENDER_NAME   => 'BMW',
    P_FLAG          => 'ALL',
    P_USER_ID       => 'minyonglee1',
    P_MENU_ID       => 'DMF0008',
    O_RC1           => v_rc1,
    O_RESULT_CURSOR => v_result_rc
  );
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('REPAIR BMW O_RC1 single-col fetch = ' || v_cnt
                    || ' (-99=multi-col 정상 / 0=row 0 / >0=정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('REPAIR call ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 4 : flag 다른 값 시도 (Y / N / 빈 string) ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);

  PROCEDURE try_flag(p_flag VARCHAR2) IS
    v_rc2 SYS_REFCURSOR;
    v_r2 SYS_REFCURSOR;
    v_c PLS_INTEGER := 0;
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
    BEGIN
      LOOP FETCH v_rc2 INTO v_dummy; EXIT WHEN v_rc2%NOTFOUND OR v_c >= 3; v_c := v_c + 1; END LOOP;
    EXCEPTION WHEN OTHERS THEN v_c := -99; END;
    BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_r2; EXCEPTION WHEN OTHERS THEN NULL; END;
    DBMS_OUTPUT.PUT_LINE('flag=[' || p_flag || '] fetch = ' || v_c);
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('flag=[' || p_flag || '] ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
  END;
BEGIN
  try_flag('ALL');
  try_flag('Y');
  try_flag('N');
  try_flag('');
  try_flag(NULL);
END;
/

PROMPT === DIAG 5 : DM_DNM_EDI_CALLOFF_ITEM div=81 + sender=BMW 실제 row 수 ===

SELECT COUNT(*) AS bmw_rows, MIN(CREATE_DATE) AS min_dt, MAX(CREATE_DATE) AS max_dt
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '81'
   AND SENDER_NAME = 'BMW';

PROMPT === DIAG 6 : EXCEPTION handler 의 RAISE_APPLICATION_ERROR 패턴 확인 (SP 가 -20001 raise) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'RAISE_APPLICATION_ERROR|SCM_SYS_LOG|PR_SCM_SYS_LOG', 'i')
 ORDER BY line;

PROMPT === DIAG 7 : SP body line 200-280 (EXCEPTION_FLAG 처리 + flag 분기 영역 ?) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND line BETWEEN 180 AND 280
   AND (REGEXP_LIKE(text, 'p_FLAG|p_SENDER|p_DIVISION|UF_FX_STRING|EXCEPTION|FROM\s+\w', 'i'))
 ORDER BY line;

PROMPT === 판독 ===
PROMPT - DIAG 1 line 66-95 메인 SELECT FROM 절 (사용 테이블)
PROMPT - DIAG 3 ERR 캡쳐 → 실제 ORA 코드 (테이블/조인/타입 캐스팅 등)
PROMPT - DIAG 4 flag 별 fetch 결과 → flag 처리 로직 정상 확인
PROMPT - DIAG 5 마스터 row 수 > 0 → 데이터 있음
PROMPT - DIAG 7 SP body 의 flag 분기 + WHERE 절 logic
