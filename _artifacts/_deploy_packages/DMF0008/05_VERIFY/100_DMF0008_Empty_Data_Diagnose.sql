--==============================================================================
-- 100_DMF0008_Empty_Data_Diagnose.sql
--
-- 목적: 클라우드 DMF0008 조회 시 "success 응답 + 데이터 0건" 원인 진단
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === DIAG 1 : SCM0001_GET_DIVISION 결과 cursor 의 컬럼 / row 수 (division dropdown) ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_col1 VARCHAR2(200);
  v_col2 VARCHAR2(200);
  v_col3 VARCHAR2(200);
  v_col4 VARCHAR2(200);
BEGIN
  SCM_MGR.SCM0001_GET_DIVISION(O_RC1 => v_rc, O_RESULT_CURSOR => v_result_rc);

  -- O_RC1 columns + 첫 3 row sample (4 컬럼 가정 — 컬럼 수 다르면 ORA-XXXX)
  BEGIN
    LOOP
      FETCH v_rc INTO v_col1, v_col2, v_col3, v_col4;
      EXIT WHEN v_rc%NOTFOUND OR v_cnt >= 3;
      v_cnt := v_cnt + 1;
      DBMS_OUTPUT.PUT_LINE('row#' || v_cnt || ' col1=' || v_col1 || ' col2=' || v_col2 || ' col3=' || v_col3 || ' col4=' || v_col4);
    END LOOP;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('O_RC1 fetch 4-col fail: ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 100));
    -- 2-col 재시도
    BEGIN
      CLOSE v_rc;
      SCM_MGR.SCM0001_GET_DIVISION(O_RC1 => v_rc, O_RESULT_CURSOR => v_result_rc);
      v_cnt := 0;
      LOOP
        FETCH v_rc INTO v_col1, v_col2;
        EXIT WHEN v_rc%NOTFOUND OR v_cnt >= 3;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('2-col row#' || v_cnt || ' col1=' || v_col1 || ' col2=' || v_col2);
      END LOOP;
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('O_RC1 2-col 도 fail (다른 컬럼 수)');
    END;
  END;
  BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
END;
/

PROMPT === DIAG 2 : SCM0001_GET_DIVISION 의 O_RC1 SELECT 컬럼 정보 (USER_SOURCE grep) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'SCM0001_GET_DIVISION'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'OPEN\s+O_RC1\s+FOR|SELECT', 'i')
 ORDER BY line
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 3 : DMF0008 메인 SP (DMF0008_GET_EDI_MST_SUMMARY) 단독 호출 — division 40 ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_EDI_MST_SUMMARY(
    p_division_id => '40',
    p_ses_user_id => 'minyonglee1',
    p_menu_id     => 'DMF0008',
    O_RC1         => v_rc
  );

  BEGIN
    LOOP
      FETCH v_rc INTO v_dummy;
      EXIT WHEN v_rc%NOTFOUND;
      v_cnt := v_cnt + 1;
    END LOOP;
  EXCEPTION WHEN OTHERS THEN
    v_cnt := -99;  -- column mismatch (정상 — multi-col cursor)
  END;
  BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('SUMMARY (division=40) row count (single-col fetch) = ' || v_cnt
                    || ' (-99 = column mismatch — multi-col cursor 정상, 0 = SP 0 row, > 0 = 데이터 있음)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SUMMARY call ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === DIAG 4 : DM_DNM_EDI_SUMMARY 마스터 row count (division=40) ===

SELECT division_id, COUNT(*) AS row_cnt
  FROM SCM_MGR.DM_DNM_EDI_SUMMARY
 WHERE division_id = '40'
 GROUP BY division_id;

PROMPT === DIAG 5 : DM_DNM_EDI_SUMMARY 전체 division 별 row count ===

SELECT division_id, COUNT(*) AS row_cnt
  FROM SCM_MGR.DM_DNM_EDI_SUMMARY
 GROUP BY division_id
 ORDER BY 1
 FETCH FIRST 10 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - DIAG 1 row > 0 → SCM0001_GET_DIVISION 결과 있음. 컬럼명 (col1) 이 FE 기대 (DIVISION_ID) 와 일치하는지 확인
PROMPT - DIAG 1 col1/col2 이름 추측 (CODE/NAME 또는 SEGMENT1/SEGMENT2 또는 DIVISION_ID/DIVISION_NM)
PROMPT - DIAG 3 row = -99 (multi-col 정상) → SUMMARY SP 정상 동작. row 수는 DIAG 4 로 확인
PROMPT - DIAG 4 row > 0 → 마스터 데이터 있음. SP body 의 필터 (예: minyonglee1 권한) 가 0 row 반환 원인
PROMPT - DIAG 4 row = 0 → 마스터 데이터 자체 없음 (cloud 운영 데이터 부재)
