/* =====================================================================================================
 * 11 — 클라우드 실행용: PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE('40', '1464') 재실행 — 보정(루트 10-06 · C 10-02 · GTT) 반영 후 소요 측정
 *      1464 = 현재 최신 계획(10/05 주차 FN). 1461(9/14 주차) 대신 쓰는 이유: 소요 구조는 같고, 옛 RTF 로 BALANCE 를 덮어쓰는 부작용이 없다.
 *
 *      ⚠ 조회가 아니다. 운영 데이터 변경: ① 40 사업부 BALANCE 재계산(최신 계획이므로 00시 롤링과 같은 값) ② 이번 주 MF_W/SF_W 버전의 _C 스냅샷 RTF_SCP 재작성
 *        ③ 목요일 08:00~14:30 밖이고 SP_W 가 있고 차이가 있으면 IRREGULAR SP_W 버전 생성 + 수신자 106명 메일(11분). ROLLBACK 불가(메일 SP COMMIT·GATHER_STATS).
 *
 *      순서: [S1] 사전 점검 — S1-c(제외시간) 가 '제외시간 안' 일 때만 다음으로 (사용자 지시 2026-10-08)
 *            [S2] 실행 블록 — 주석을 풀어 워크시트 A 에서 실행. 블록 안에도 같은 제외시간 게이트가 있어 '제외시간 밖' 이면 SP 를 호출하지 않고 끝난다
 *            [S3] 실행 중 관찰(워크시트 B 반복) → [S4] 실행 후 결과 → 결과 전체를 보내주면 09-30 과 호출당 비교
 *      기대값(순소요): 루트 ≈2분 + C_QTY_BALANCE 2회 × ≈2분 + SALES_PLAN_C 비메일 0.6 ≈ 6~7분.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON
SET SERVEROUTPUT ON SIZE UNLIMITED


/* ======================================== S1. 사전 점검 (조회만) — S1-c 결과를 보고 S2 로 갈지 정한다 ======================================== */

-- S1-a. 1464 가 최신 계획인지 · 배분 행 수
SELECT MAX(plan_id) AS latest_plan_id, MAX(plan_start_yyyymmdd) AS plan_start
     , SUM(CASE WHEN plan_id = '1464' THEN 1 ELSE 0 END) AS rows_of_1464
  FROM SCP_PLN_RTF_ALLOCATION_V WHERE division_id = '40';

-- S1-b. CUTOFF 루프가 재작성할 이번 주 버전 (MF_W/SF_W 건수 = C_QTY_BALANCE 호출 수 · SP_W ≥1 이면 메일 분기 후보)
SELECT version_type, COUNT(*) AS cnt, LISTAGG(version_no, ', ') WITHIN GROUP (ORDER BY version_no) AS versions
  FROM DM_MST_VERSION
 WHERE division_id = '40' AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
   AND version_type IN ('MF_W', 'SF_W', 'SP_W')
 GROUP BY version_type ORDER BY version_type;

-- S1-c. ★ 제외시간 게이트 — '제외시간 안' 이면 S2 진행. '제외시간 밖' 이면 메일 106명 + SP_W 생성이 따르므로 멈추고 판단
SELECT d.segment2 AS dow, d.segment3 AS from_hhmi, d.segment4 AS to_hhmi, TO_CHAR(SYSDATE, 'DY HH24:MI') AS now_
     , CASE WHEN d.segment2 = (SELECT dayofweek FROM SCM_SYS_CALENDAR_M WHERE basis_yyyymmdd = TO_CHAR(SYSDATE, 'YYYYMMDD'))
             AND TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI')) BETWEEN TO_NUMBER(d.segment3) AND TO_NUMBER(d.segment4)
            THEN '제외시간 안 → S2 진행 가능 (메일·SP_W 생성 없음, 순소요만 측정)'
            ELSE '제외시간 밖 → S2 보류 (실행하면 차이 발생 시 메일 106명 + SP_W 생성, +11분)' END AS judge
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL d
 WHERE d.lookup_type = 'CUTOFF_EXCLUDE_TIME_DIVISION' AND d.valid_yn = 'Y' AND d.segment1 = '40';

-- S1-d. 지금 같은 SP 를 돌리는 세션이 있는가 (겹치면 측정이 흐려짐 — 10-01 14:33~14:38 겹침 사례)
SELECT s.sid, s.serial#, s.username, s.status, s.module, s.sql_id, s.last_call_et
  FROM v$session s
 WHERE s.status = 'ACTIVE' AND s.username IS NOT NULL
   AND s.plsql_entry_object_id IN (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
                                     AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'));


/* ======================================== S2. 실행 블록 (워크시트 A, 계정 SCM_MGR) — S1-c 가 '제외시간 안' 일 때 주석을 풀고 실행 ========================================
 * 블록 안 게이트: 제외시간 밖이면 SP 를 호출하지 않고 'SKIP' 만 출력한다. 메일 발송을 감수하고라도 돌리려면 v_allow_outside := TRUE 로 바꾼다.
 * 성공 판정 = MSG 가 'SUCCESS'. 실패도 CODE 는 '0' 으로 나온다. ELAPSED 가 전체 소요(메일 포함).
DECLARE
    v_cur            SYS_REFCURSOR;
    v_code           VARCHAR2(100);
    v_msg            VARCHAR2(4000);
    v_t0             TIMESTAMP := SYSTIMESTAMP;
    v_in_exclude     NUMBER;
    v_allow_outside  BOOLEAN := FALSE;     -- TRUE 로 바꾸면 제외시간 밖에서도 실행 (메일 106명 + SP_W 생성 감수)
BEGIN
    SELECT COUNT(*) INTO v_in_exclude
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL d
     WHERE d.lookup_type = 'CUTOFF_EXCLUDE_TIME_DIVISION' AND d.valid_yn = 'Y' AND d.segment1 = '40'
       AND d.segment2 = (SELECT dayofweek FROM SCM_SYS_CALENDAR_M WHERE basis_yyyymmdd = TO_CHAR(SYSDATE, 'YYYYMMDD'))
       AND TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI')) BETWEEN TO_NUMBER(d.segment3) AND TO_NUMBER(d.segment4);

    IF v_in_exclude = 0 AND NOT v_allow_outside THEN
        DBMS_OUTPUT.PUT_LINE('SKIP  ' || TO_CHAR(SYSDATE, 'DY HH24:MI') || ' = 제외시간 밖. SP 미호출. 메일을 감수하려면 v_allow_outside := TRUE');
        RETURN;
    END IF;

    DBMS_APPLICATION_INFO.SET_MODULE(module_name => 'RERUN_QTY_BALANCE_40_1464', action_name => 'MANUAL_' || TO_CHAR(SYSDATE, 'MMDD_HH24MI'));
    DBMS_OUTPUT.PUT_LINE('START ' || TO_CHAR(v_t0, 'YYYY-MM-DD HH24:MI:SS') || '  SID=' || SYS_CONTEXT('USERENV', 'SID') || '  USER=' || USER
                         || '  exclude_window=' || CASE WHEN v_in_exclude > 0 THEN 'IN(메일 없음)' ELSE 'OUT(메일 가능)' END);

    SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(P_DIVISION_ID => '40', P_PLAN_ID => '1464', O_RESULT_CURSOR => v_cur);

    FETCH v_cur INTO v_code, v_msg;
    IF v_cur%ISOPEN THEN CLOSE v_cur; END IF;
    DBMS_OUTPUT.PUT_LINE('END   ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') || '  ELAPSED=' || TO_CHAR(SYSTIMESTAMP - v_t0) || '  CODE=' || v_code || '  MSG=' || SUBSTR(v_msg, 1, 300));
    -- [2026-10-08 13:30 실행 교훈] 루트 SP 는 실패해도 CODE='0' 으로 돌아오고 ROLLBACK 을 호출자에 위임한다.
    -- 무조건 COMMIT 하면 하위 SP 가 DELETE 후 실패한 상태가 확정될 수 있다 → MSG='SUCCESS' 일 때만 COMMIT, 아니면 ROLLBACK.
    -- (내부 DBMS_STATS.GATHER_TABLE_STATS 가 중간 COMMIT 을 하므로 ROLLBACK 은 마지막 통계수집 이후분만 되돌린다 — 그래도 하는 것이 맞다)
    -- ※ 이 블록 전체가 블록주석으로 감싸져 있으므로 안에서는 블록주석(슬래시-별표)을 쓰지 않는다. Oracle 은 블록주석 중첩을 지원하지 않아 바깥 주석이 조기 종료된다 → 줄 주석만 사용
    IF v_msg = 'SUCCESS' THEN
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('COMMIT');
    ELSE
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ROLLBACK (실패 — 마지막 GATHER_STATS 이후 변경분만 되돌림. 12 D1 로 실테이블 영향 확인)');
    END IF;
    DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);
END;
/
 ======================================== S2 끝 ======================================== */


/* ======================================== S3. 실행 중 관찰 (워크시트 B 에서 30초~1분 간격으로 반복) ======================================== */

-- S3-a. 세션 현재 상태
SELECT s.sid, s.serial#, s.status, s.action, s.sql_id, TO_CHAR(s.sql_exec_start, 'HH24:MI:SS') AS sql_started, s.last_call_et AS sec_in_call
     , NVL(s.event, 'ON CPU') AS event, s.state, s.blocking_session
     , (SELECT SUBSTR(q.sql_text, 1, 100) FROM v$sql q WHERE q.sql_id = s.sql_id AND q.child_number = s.sql_child_number) AS sql_text
  FROM v$session s
 WHERE s.module = 'RERUN_QTY_BALANCE_40_1464';

-- S3-b. 이 세션의 1초 ASH 누적 — SQL × 플랜라인 × 이벤트
SELECT h.sql_id, h.sql_plan_hash_value AS phv, h.sql_plan_line_id AS line_id, SUBSTR(h.sql_plan_operation || ' ' || h.sql_plan_options, 1, 30) AS plan_op
     , SUBSTR(NVL(h.event, 'ON CPU'), 1, 30) AS event
     , SUBSTR((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id), 1, 42) AS in_sp
     , COUNT(*) AS sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM v$active_session_history h
 WHERE h.module = 'RERUN_QTY_BALANCE_40_1464'
 GROUP BY h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation || ' ' || h.sql_plan_options, NVL(h.event, 'ON CPU'), h.plsql_object_id
 ORDER BY sec DESC
 FETCH FIRST 30 ROWS ONLY;

-- S3-c. step 로그 실시간 (오늘 40/1464 실행 + 그 구간의 하위 SP)
SELECT TO_CHAR(x.event_date, 'HH24:MI:SS') AS at_time
     , ROUND((x.event_date - LAG(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date)) * 86400) AS gap_sec
     , SUBSTR(x.program_name, 1, 42) AS program_name, x.log_type, x.created_by
     , SUBSTR(x.log_message, 1, 40) AS log_message, SUBSTR(x.description, 1, 70) AS description
  FROM SCM_MGR.SCM_SYS_LOG_BATCH x
 WHERE x.event_date >= TRUNC(SYSDATE)
   AND ( x.in_para_data = '{"p_division_id":"40","p_plan_id":"1464"}'
      OR (x.created_by IN ('scm_batch', 'SYSTEM') AND REGEXP_LIKE(x.program_name, 'C_QTY_BALANCE|WS_RTF|LOCAL_KRW|CUTOFF|VERSION_CREATE|MAIL_SEND')
          AND x.event_date >= (SELECT MIN(event_date) FROM SCM_MGR.SCM_SYS_LOG_BATCH WHERE event_date >= TRUNC(SYSDATE) AND in_para_data = '{"p_division_id":"40","p_plan_id":"1464"}')))
 ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date;


/* ======================================== S4. 실행 후 결과 (워크시트 B) ======================================== */

-- S4-a. 전체 / 메일 / 순소요 분리 (오늘 40/1464 실행)
WITH l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date, in_para_data
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE event_date >= TRUNC(SYSDATE) AND log_type IN ('START', 'END', 'ERROR', 'error')
       AND program_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')
)
, s AS (
    SELECT l.*, LEAD(log_type) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
              , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date
      FROM l
)
, r AS (SELECT event_date AS run_start, next_date AS run_end, next_type FROM s
         WHERE log_type = 'START' AND program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND in_para_data = '{"p_division_id":"40","p_plan_id":"1464"}')
, m AS (SELECT event_date AS m_start, next_date AS m_end FROM s
         WHERE log_type = 'START' AND program_name LIKE '%MAIL_SEND' AND next_type IN ('END', 'ERROR', 'error'))
SELECT TO_CHAR(r.run_start, 'HH24:MI:SS') AS start_time, TO_CHAR(r.run_end, 'HH24:MI:SS') AS end_time
     , CASE WHEN r.next_type = 'END' THEN 'END' WHEN r.next_type IN ('ERROR', 'error') THEN 'ERROR' ELSE '미종료' END AS status
     , ROUND((r.run_end - r.run_start) * 1440, 1) AS total_min
     , ROUND(NVL((SELECT SUM(LEAST(m.m_end, r.run_end) - GREATEST(m.m_start, r.run_start)) FROM m WHERE m.m_start < r.run_end AND m.m_end > r.run_start), 0) * 1440, 1) AS mail_min
     , ROUND(((r.run_end - r.run_start) - NVL((SELECT SUM(LEAST(m.m_end, r.run_end) - GREATEST(m.m_start, r.run_start)) FROM m WHERE m.m_start < r.run_end AND m.m_end > r.run_start), 0)) * 1440, 1) AS net_min
  FROM r
 ORDER BY r.run_start;

-- S4-b. SP 단위 분해 (1초 ASH, 모듈 기준) — 09-30 R1(루트 5.0분 · C 회당 7.0분) / 10-01 R3(루트 1.5 · C 회당 1.9) 과 비교
SELECT NVL((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id), '(루트)') AS in_sp
     , COUNT(*) AS sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM v$active_session_history h
 WHERE h.module = 'RERUN_QTY_BALANCE_40_1464'
 GROUP BY h.plsql_object_id
 ORDER BY sec DESC;

-- S4-c. SQL 단위 상위 20 — 1nc5at1kvv06s(보정 VMI INSERT) 회당 초 · 뷰 MAX 6nzwwbfd3rzsz 초
SELECT h.sql_id, MAX(h.sql_plan_hash_value) AS phv
     , SUBSTR(MAX((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id)), 1, 42) AS in_sp
     , COUNT(*) AS sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct
     , SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec, SUM(CASE WHEN h.event IS NOT NULL THEN 1 ELSE 0 END) AS wait_sec
     , (SELECT SUBSTR(REPLACE(REPLACE(q.sql_text, CHR(10), ' '), CHR(13), ' '), 1, 90) FROM v$sqlarea q WHERE q.sql_id = h.sql_id) AS sql_text
  FROM v$active_session_history h
 WHERE h.module = 'RERUN_QTY_BALANCE_40_1464'
 GROUP BY h.sql_id
 ORDER BY sec DESC
 FETCH FIRST 20 ROWS ONLY;

-- S4-d. C_QTY_BALANCE 호출별 소요 (오늘) — 09-30 회당 4.9~5.6분 / 10-01 20:09 회당 1.9분과 비교
WITH l AS (
    SELECT program_name, created_by, log_type, event_date, creation_date, description
         , CASE log_type WHEN 'START' THEN 0 ELSE 1 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE event_date >= TRUNC(SYSDATE) AND program_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND log_type IN ('START', 'END', 'ERROR', 'error')
)
, s AS (SELECT l.*, LEAD(log_type) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_type
                  , LEAD(event_date) OVER (PARTITION BY program_name, created_by ORDER BY event_date, ord, creation_date) AS next_date FROM l)
SELECT TO_CHAR(event_date, 'HH24:MI:SS') AS start_time
     , ROUND((CASE WHEN next_type IN ('END', 'ERROR', 'error') THEN next_date END - event_date) * 1440, 1) AS elapsed_min
     , CASE WHEN next_type = 'END' THEN 'END' WHEN next_type IN ('ERROR', 'error') THEN 'ERROR' ELSE '미종료/중첩' END AS status
     , SUBSTR(description, 1, 90) AS params
  FROM s WHERE log_type = 'START' ORDER BY event_date;

-- S4-e. 오늘 실행이 남긴 변경 — 새 버전(메일 분기 수행 여부) · 메일 로그
SELECT 'VERSION' AS kind, version_no AS key_, version_type AS type_, TO_CHAR(creation_date, 'HH24:MI:SS') AS at_, created_by
  FROM DM_MST_VERSION WHERE division_id = '40' AND creation_date >= TRUNC(SYSDATE)
UNION ALL
SELECT 'MAIL_LOG', SUBSTR(segment2, 1, 60), use_type_code, TO_CHAR(creation_date, 'HH24:MI:SS'), SUBSTR(segment1, 1, 50)
  FROM SCM_ADM_SMS_MAIL_SEND_LOG WHERE creation_date >= TRUNC(SYSDATE) AND UPPER(segment1) LIKE '%IRREGULAR%'
 ORDER BY 4;
