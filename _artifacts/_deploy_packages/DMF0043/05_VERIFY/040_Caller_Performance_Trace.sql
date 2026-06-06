--==============================================================================
-- 040_Caller_Performance_Trace.sql
--
-- 목적: DMF0043_GET_CONTRIBUTE_MAIN_DATA (caller) 의 ORA-01013 timeout 진단
--       단계별 SYSTIMESTAMP + DBMS_OUTPUT 로 어느 step 이 느린지 식별
-- 실행: SCM_MGR 세션 (USER_SOURCE 자기 schema). SQL*Plus 권장 (timeout 무제한)
-- 작성: 2026-06-04
--
-- 사전: DIAG 1-5 결과 (이전 세션) — DMF0043_GET_MAIN_SPREAD_TITLE fix 정상, caller timeout 추정
--==============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET TIMING ON

PROMPT === STEP 0 : 시작 ===

DECLARE
  v_rc1            SYS_REFCURSOR;
  v_rc2            SYS_REFCURSOR;
  v_rc3            SYS_REFCURSOR;
  v_caller_rc      SYS_REFCURSOR;
  v_start_ts       TIMESTAMP;
  v_step_ts        TIMESTAMP;
  v_elapsed_total  INTERVAL DAY TO SECOND;
  v_elapsed_step   INTERVAL DAY TO SECOND;
  v_title_cnt      NUMBER;
  v_temp_cnt       NUMBER;
  v_temp2_cnt      NUMBER;
  v_temp3_cnt      NUMBER;
  v_data_cnt       NUMBER;
  v_dummy          VARCHAR2(4000);
  v_rc1_cnt        PLS_INTEGER := 0;

  PROCEDURE log_step(p_label VARCHAR2) IS
  BEGIN
    v_elapsed_step  := SYSTIMESTAMP - v_step_ts;
    v_elapsed_total := SYSTIMESTAMP - v_start_ts;
    DBMS_OUTPUT.PUT_LINE(
      RPAD(p_label, 60) ||
      ' step=' || TO_CHAR(EXTRACT(SECOND FROM v_elapsed_step), 'FM999990.000') || 's' ||
      ' total=' || TO_CHAR(EXTRACT(SECOND FROM v_elapsed_total) + EXTRACT(MINUTE FROM v_elapsed_total) * 60, 'FM999990.000') || 's'
    );
    v_step_ts := SYSTIMESTAMP;
  END;
BEGIN
  v_start_ts := SYSTIMESTAMP;
  v_step_ts  := v_start_ts;
  DBMS_OUTPUT.PUT_LINE('=== Caller Performance Trace START: ' || TO_CHAR(v_start_ts, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' ===');

  -- ────────────────────────────────────────────────────────────────────────
  -- STEP 1 : GTT 정리
  -- ────────────────────────────────────────────────────────────────────────
  DELETE FROM gt_dmf0043_title;
  DELETE FROM gt_dmf0043_temp;
  DELETE FROM gt_dmf0043_temp2;
  DELETE FROM gt_dmf0043_temp3;
  DELETE FROM gt_dmf0043_data_table;
  BEGIN DELETE FROM gt_dmf0043_master_list; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN DELETE FROM gt_dmf0043_temp_list;   EXCEPTION WHEN OTHERS THEN NULL; END;
  log_step('STEP 1: GTT 정리 완료');

  -- ────────────────────────────────────────────────────────────────────────
  -- STEP 2 : DMF0043_GET_MAIN_SPREAD_TITLE 단독 호출 (header SP)
  -- ────────────────────────────────────────────────────────────────────────
  dmf0043_get_main_spread_title(
    p_division_id => '40',
    p_yyyy        => '2024',
    p_created_by  => 'minyonglee1',
    p_user_id     => 'minyonglee1',
    p_menu_id     => 'DMF0043',
    o_rc1         => v_rc1,
    o_rc2         => v_rc2,
    o_rc3         => v_rc3
  );
  log_step('STEP 2: DMF0043_GET_MAIN_SPREAD_TITLE 호출 (cursor OPEN)');

  -- ────────────────────────────────────────────────────────────────────────
  -- STEP 3 : O_RC1 cursor fetch 시도 (column mismatch 예상 → 에러 catch)
  -- ────────────────────────────────────────────────────────────────────────
  BEGIN
    IF v_rc1%ISOPEN THEN
      LOOP
        FETCH v_rc1 INTO v_dummy;
        EXIT WHEN v_rc1%NOTFOUND;
        v_rc1_cnt := v_rc1_cnt + 1;
      END LOOP;
      CLOSE v_rc1;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_rc1_cnt := -99;  -- column mismatch
  END;
  BEGIN IF v_rc2%ISOPEN THEN CLOSE v_rc2; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN IF v_rc3%ISOPEN THEN CLOSE v_rc3; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('     SPREAD_TITLE O_RC1 fetch count = ' || v_rc1_cnt || ' (-99 = column mismatch, fix 정상; 0 = SP 0 row)');
  log_step('STEP 3: O_RC1 fetch 완료');

  -- ────────────────────────────────────────────────────────────────────────
  -- STEP 4 : caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) 호출 — 무거운 작업
  -- ────────────────────────────────────────────────────────────────────────
  DBMS_OUTPUT.PUT_LINE('     >>> caller 호출 시작 (timeout 시 어디서 멈추는지 확인)');
  dmf0043_get_contribute_main_data(
    '2024', '12', 'ALL', 'N', 'minyonglee1', 'ALL', v_caller_rc
  );
  log_step('STEP 4: DMF0043_GET_CONTRIBUTE_MAIN_DATA caller 호출 완료');

  -- ────────────────────────────────────────────────────────────────────────
  -- STEP 5 : caller 결과 cursor 상태 + GTT 적재 카운트
  -- ────────────────────────────────────────────────────────────────────────
  SELECT COUNT(*) INTO v_title_cnt FROM gt_dmf0043_title;
  SELECT COUNT(*) INTO v_temp_cnt  FROM gt_dmf0043_temp;
  SELECT COUNT(*) INTO v_temp2_cnt FROM gt_dmf0043_temp2;
  SELECT COUNT(*) INTO v_temp3_cnt FROM gt_dmf0043_temp3;
  SELECT COUNT(*) INTO v_data_cnt  FROM gt_dmf0043_data_table;
  DBMS_OUTPUT.PUT_LINE('     GT_DMF0043_TITLE       = ' || v_title_cnt || ' rows (expect 22)');
  DBMS_OUTPUT.PUT_LINE('     GT_DMF0043_TEMP        = ' || v_temp_cnt);
  DBMS_OUTPUT.PUT_LINE('     GT_DMF0043_TEMP2       = ' || v_temp2_cnt);
  DBMS_OUTPUT.PUT_LINE('     GT_DMF0043_TEMP3       = ' || v_temp3_cnt);
  DBMS_OUTPUT.PUT_LINE('     GT_DMF0043_DATA_TABLE  = ' || v_data_cnt);

  IF v_caller_rc%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('     >>> caller cursor OPEN 정상');
    CLOSE v_caller_rc;
  ELSE
    DBMS_OUTPUT.PUT_LINE('     >>> caller cursor 미오픈 (WARN)');
  END IF;
  log_step('STEP 5: GTT count + cursor 검증');

  DBMS_OUTPUT.PUT_LINE('==========================================================');
  DBMS_OUTPUT.PUT_LINE('Total elapsed = ' || TO_CHAR(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts)) +
                                                     EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60, 'FM999990.000') || 's');
  DBMS_OUTPUT.PUT_LINE('==========================================================');

EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('==========================================================');
  DBMS_OUTPUT.PUT_LINE('FAIL at step elapsed = ' || TO_CHAR(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_ts)) +
                                                          EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_start_ts)) * 60, 'FM999990.000') || 's');
  DBMS_OUTPUT.PUT_LINE('SQLCODE = ' || SQLCODE);
  DBMS_OUTPUT.PUT_LINE('SQLERRM = ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE('BACKTRACE: ');
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  -- 현재까지 적재된 GTT 행수도 출력
  BEGIN
    SELECT COUNT(*) INTO v_title_cnt FROM gt_dmf0043_title;  DBMS_OUTPUT.PUT_LINE('     GT_TITLE  at err = ' || v_title_cnt);
  EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN
    SELECT COUNT(*) INTO v_temp_cnt FROM gt_dmf0043_temp;    DBMS_OUTPUT.PUT_LINE('     GT_TEMP   at err = ' || v_temp_cnt);
  EXCEPTION WHEN OTHERS THEN NULL; END;
END;
/

PROMPT === 판독 ===
PROMPT - STEP 4 가 30s+ 걸리면 caller 내부의 DM_MST_CONTRIBUTE_RATIO_* JOIN 또는 PIVOT 이 무거움
PROMPT - STEP 2 SPREAD_TITLE 만 느리면 SCM_MST_SHEET_COLUMNS INDEX/통계 문제
PROMPT - FAIL backtrace 의 line 번호로 어느 SQL block 폭발했는지 식별
PROMPT - GT_TITLE = 22 인데 caller fail 이면 caller 내부의 다른 SELECT (DM_MST_CONTRIBUTE_RATIO_* 등) 문제
