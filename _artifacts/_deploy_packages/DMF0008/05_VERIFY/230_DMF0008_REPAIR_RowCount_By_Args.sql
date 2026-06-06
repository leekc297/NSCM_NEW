--==============================================================================
-- 230_DMF0008_REPAIR_RowCount_By_Args.sql
--
-- 목적:
--   BMW 더블클릭 시 REPAIR grid 0 row.
--   SP 가 정확히 어떤 인자에 어떤 row count 반환하는지 매트릭스 진단.
--
-- FE 가 보내는 인자 (setRepairFilter):
--   divisionId='81', fromYyyymmdd, toYyyymmdd, senderName='BMW', flag=<column별>
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === DIAG 1 : SP body 의 p_Flag 분기 + p_Sender_Name WHERE 절 정밀 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'p_Sender|p_Flag|p_FROM|p_TO|p_DIVISION|p_user|p_menu|SENDER_NAME|WHERE\s', 'i')
 ORDER BY line
 FETCH FIRST 50 ROWS ONLY;

PROMPT === DIAG 2 : REPAIR row count 매트릭스 — senderName × flag 조합별 ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_dummy VARCHAR2(4000);

  PROCEDURE try_call(p_sender VARCHAR2, p_flag VARCHAR2) IS
    v_rc2 SYS_REFCURSOR;
    v_r2 SYS_REFCURSOR;
    v_c PLS_INTEGER := 0;
  BEGIN
    DMF0008_GET_EDI_MST_REPAIR(
      P_DIVISION_ID   => '81',
      P_FROM_YYYYMMDD => '20240101',
      P_TO_YYYYMMDD   => '20261231',
      P_SENDER_NAME   => p_sender,
      P_FLAG          => p_flag,
      P_USER_ID       => 'minyonglee1',
      P_MENU_ID       => 'DMF0008',
      O_RC1           => v_rc2,
      O_RESULT_CURSOR => v_r2
    );
    BEGIN
      LOOP FETCH v_rc2 INTO v_dummy; EXIT WHEN v_rc2%NOTFOUND; v_c := v_c + 1; END LOOP;
    EXCEPTION WHEN OTHERS THEN v_c := -99; END;  -- multi-col 인 경우 -99
    BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_r2; EXCEPTION WHEN OTHERS THEN NULL; END;
    DBMS_OUTPUT.PUT_LINE('sender=[' || p_sender || '] flag=[' || p_flag || '] rows = ' || v_c);
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('sender=[' || p_sender || '] flag=[' || p_flag || '] ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 100));
  END;
BEGIN
  -- 빈 sender (초기 SEARCH 시) — 모든 sender row 반환 기대
  try_call('', 'ALL');
  try_call('', '4');
  try_call('', '5');
  try_call('', '6');
  try_call(NULL, 'ALL');

  -- BMW (더블클릭 시) — BMW row 만 반환 기대
  try_call('BMW', 'ALL');
  try_call('BMW', '4');
  try_call('BMW', '5');
  try_call('BMW', '6');
  try_call('BMW', '');
  try_call('BMW', NULL);
END;
/

PROMPT === DIAG 3 : REPAIR 의 실제 row count (multi-col fetch 이라서 DIAG 2 는 -99) ===
-- COUNT(*) 로 변환 fetch — 직접 row count

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_division VARCHAR2(20);
  v_cnt PLS_INTEGER := 0;
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
  LOOP
    FETCH v_rc1 INTO v_division;  -- 1st col 만 fetch (DIVISION_ID)
    EXIT WHEN v_rc1%NOTFOUND;
    v_cnt := v_cnt + 1;
  END LOOP;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('BMW + flag=ALL ROW COUNT = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === DIAG 4 : DM_DNM_EDI_CALLOFF_ITEM 의 BMW + div=81 + ERP_STATUS='S' 실제 row ===

SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN STATUS_CODE IN ('U', 'E') AND NVL(EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END) AS gscm_master_data,
  SUM(CASE WHEN STATUS_CODE = 'S'         AND NVL(EXCEPTION_FLAG, NULL) != 'Y' THEN 1 ELSE 0 END) AS success_cnt,
  SUM(CASE WHEN EXCEPTION_FLAG = 'Y' THEN 1 ELSE 0 END) AS exception_cnt
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '81'
   AND SENDER_NAME = 'BMW'
   AND CREATE_DATE >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 52*7, 'YYYYMMDD')
   AND ERP_STATUS = 'S'
   AND LTRIM(RTRIM(YYYYMMDD)) NOT IN ('444444');

PROMPT === 판독 ===
PROMPT - DIAG 1: SP body 의 p_Sender_Name + p_Flag WHERE/CASE 분기
PROMPT - DIAG 2: 인자 조합별 row count (multi-col 이라 -99 가 정상)
PROMPT - DIAG 3: BMW + ALL 단일 col fetch 로 실제 row count
PROMPT - DIAG 4: 마스터 데이터 자체 row 수 (cloud 에 BMW 데이터 풍부 확인)
PROMPT - DIAG 3 = 0 → SP body 의 logic 이 0 row 반환 → SP 분석
PROMPT - DIAG 3 > 0 → SP 정상, FE 호출 인자 또는 응답 처리 문제
