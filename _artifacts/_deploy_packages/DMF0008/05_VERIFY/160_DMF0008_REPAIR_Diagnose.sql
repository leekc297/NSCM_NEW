--==============================================================================
-- 160_DMF0008_REPAIR_Diagnose.sql
--
-- 목적:
--   1단 SUMMARY grid 더블클릭 → 2단 REPAIR (sheet 'repair') 호출 시 SQL error -9994.
--   DMF0008_GET_EDI_MST_REPAIR 단독 진단:
--     1. SP 존재 + STATUS
--     2. signature (PROC_M 와 일치)
--     3. SP body 의 DUMMY OPEN 사고 (SUMMARY 동일 패턴 의심)
--     4. 단독 호출 ORA 에러
--     5. PROC_M / API_M / BTN_MPG row
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : DMF0008_GET_EDI_MST_REPAIR 존재 + STATUS ===

SELECT owner, object_name, object_type, status, last_ddl_time
  FROM all_objects
 WHERE object_name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND object_type IN ('PROCEDURE', 'SYNONYM')
 ORDER BY owner;

PROMPT === DIAG 2 : SP signature (in/out 인자) ===

SELECT argument_name, position, data_type, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND package_name IS NULL
 ORDER BY position;

PROMPT === DIAG 3 : SP body 의 OPEN 구문 모두 (DUMMY OPEN 패턴 검출) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'OPEN\s+O_', 'i')
 ORDER BY line;

PROMPT === DIAG 4 : SP body 전체 line + IF/THEN 분기 grep ===

SELECT COUNT(*) AS total_lines
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE';

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, '\b(IF|ELSE|ELSIF|END\s+IF)\b|DUMMY|EXCEPTION', 'i')
 ORDER BY line;

PROMPT === DIAG 5 : SCM_ADM_PROC_M 메타 (FE → BE → SP key 정합) ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm = 'DMF0008_GET_EDI_MST_REPAIR'
 ORDER BY sort_ord;

PROMPT === DIAG 6 : SCM_ADM_API_M / BTN_MPG (DMF0008 repair sheet) ===

SELECT api_id, api_url, api_tp_cd, api_msg_id
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE UPPER(api_id) LIKE '%DMF0008%REPAIR%'
    OR UPPER(api_url) LIKE '%DMF0008_GET_EDI_MST_REPAIR%'
 ORDER BY api_id;

SELECT mnu_id, sht_nm, btn_id, api_id
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE mnu_id = 'DMF0008'
   AND sht_nm = 'repair'
 ORDER BY btn_id;

PROMPT === DIAG 7 : SP 단독 호출 (signature 결과 기반 적용 필요 — 일단 일반 시도) ===
-- SUMMARY 와 동일 패턴이면 (FROM/TO/DIVISION/USER/MENU + O_RC1/O_RC3/O_RESULT_CURSOR)

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_EDI_MST_REPAIR(
    P_FROM_YYYYMMDD => '20240101',
    P_TO_YYYYMMDD   => '20261231',
    P_DIVISION_ID   => '81',
    P_USER_ID       => 'minyonglee1',
    P_MENU_ID       => 'DMF0008',
    O_RC1           => v_rc1,
    O_RC3           => v_rc3,
    O_RESULT_CURSOR => v_result_rc
  );
  BEGIN
    LOOP FETCH v_rc1 INTO v_dummy; EXIT WHEN v_rc1%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('REPAIR div=81 O_RC1 single-col fetch = ' || v_cnt
                    || ' (-99=multi-col 정상 / 1=DUMMY 덮어쓰기 / 0=row 0 / >0=정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('REPAIR call ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

PROMPT === DIAG 8 : 최근 BE 가 잡은 ORA-XXXXX 가 어떤 종류 — SCM_SYS_LOG 최근 10건 (DMF0008 관련) ===

SELECT log_id, log_type, log_message, sql_code, SUBSTR(sql_errmsg, 1, 100) AS errmsg_short, event_date
  FROM SCM_MGR.SCM_SYS_LOG
 WHERE (log_message LIKE '%DMF0008%' OR description LIKE '%DMF0008%' OR sql_errmsg LIKE '%DMF0008%')
   AND event_date >= SYSDATE - 1/24
 ORDER BY event_date DESC
 FETCH FIRST 10 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - DIAG 1 STATUS=VALID 필수. SCMD_APP synonym 있어야
PROMPT - DIAG 2 signature 가 PROC_M (DIAG 5) 와 일치 — 다르면 -9994 원인
PROMPT - DIAG 3 OPEN O_RC1 가 2번 (메인 + DUMMY) → SUMMARY 와 동일 사고 = SP body fix 필요
PROMPT - DIAG 4 IF/THEN 없으면 DUMMY 무조건 흐름. EXCEPTION 절 확인
PROMPT - DIAG 5 col_nm = fromYyyymmdd / toYyyymmdd / divisionId / sesUserId / mnuId / o_rc1 / o_rc3 / O_RESULT_CURSOR 기대
PROMPT - DIAG 6 API_URL standalone path (PKG prefix 없음) 확인
PROMPT - DIAG 7 ORA 발생 시 SQLCODE/SQLERRM 캡쳐
PROMPT - DIAG 8 BE 가 trap 한 실제 SQLCODE (1단 더블클릭 발생 시점)
