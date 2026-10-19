/* =====================================================================================================
 * 03 — 클라우드에서 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE('40', '1461') 재실행으로 09-30 51.9분 재현 여부 확인
 *
 * ⚠ 이 호출은 조회가 아니다. PLAN_ID 를 지정하면 V_BATCH_CALL_YN='N' 이 되어 배치 경로(매일 00시) 에 없는 A021 CUTOFF 블록까지 돈다.
 *    사내 원문(2026-10-07 23:26 판, 3,201줄) L3044~3173 기준으로 운영 데이터에 생기는 변화:
 *      ① DM_PLN_MKT_FCST / DM_PLN_CFM_MKT_DEMAND_PLAN 의 40 사업부 BALANCE·RTF 측정값을 "PLAN_ID 1461 의 RTF 배분" 으로 다시 계산해 덮어씀 (L1440 PLAN_ID = V_P_PLAN_ID)
 *         → 1461 이 지금 최신 계획이 아니면 옛 주차 RTF 로 덮어쓰는 것. 다음 00시 Daily Rolling(PLAN_ID NULL = 최신 계획) 이 다시 덮어쓰기 전까지 화면에 그 값이 보인다.
 *      ② 이번 주 월요일 이후 MF_W / SF_W 버전 전부에 대해 PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 재수행 → *_C(컷오프 스냅샷) 테이블의 RTF_SCP 측정값 재작성 (영구)
 *      ③ 이번 주 SP_W 버전이 있고 + 40 사업부 제외시간(THU 08:00~14:30) 밖이고 + Sales Plan RTF_SYS_RP 와 MKT FCST C 가 1건이라도 다르면
 *         PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE('40', NULL, 'IRREGULAR') → **새 SP_W 버전(비정기 Sales Plan Cutoff) 생성** + **수신자(룩업 DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_ADDR, 사내 127명) 에게 실제 메일 발송**
 *         (09-30 15:39 실행과 10-01 14:38 실행 모두 이 분기까지 들어가 11분 메일 발송이 찍혔다 = 그때 이미 SP_W 버전이 만들어지고 메일이 나갔다)
 *      ④ ROLLBACK 으로 되돌릴 수 없다: 메일 SP 안의 COMMIT(L284) + DBMS_STATS.GATHER_TABLE_STATS 27회(각각 트랜잭션 COMMIT) 가 중간중간 확정한다.
 *    따라서 "재현을 위한 재실행" 은 운영 데이터 변경 + 현업 메일 발송을 수반한다. 아래 순서를 지킨다.
 *
 *    [권장 순서]
 *      P. 사전 점검 (P1~P7, 조회만) — 1461 의 정체, 지금 재실행 시 어느 분기까지 가는지, 메일 수신자 수, 09-30·10-01 수동 실행이 이미 남긴 흔적
 *      A. 재실행 없이 09-30 15:39~16:31 실행의 병목을 AWR 로 실측 (hook #129 0-b) — 데이터 변경 0. AWR 보존기간 안이면 이것으로 충분한 경우가 많다
 *      B. 그래도 재실행이 필요하면: 영향 범위(위 ①~③)를 인지한 상태에서 B1 블록 실행 → 다른 세션에서 B2 로 실시간 관찰 → 끝난 뒤 B3 로 09-30 과 비교
 *         ※ 재실행 시각이 목요일 08:00~14:30 이면 ③(SP_W 생성·메일) 분기는 건너뛴다(CUTOFF_EXCLUDE_TIME_DIVISION 룩업). ①②는 그래도 발생.
 *         ※ 09-30 과 "동일 현상" 은 엄밀히는 재현 불가 — 그 사이 MKT FCST·버전·재고 데이터가 바뀌었다. 비교는 구간(step)별 소요와 상위 SQL 로 한다.
 * ===================================================================================================== */


/* ======================================== P. 사전 점검 (조회만) ======================================== */

-- P1. AWR 보존 범위 — 09-30 15:39 가 MIN 보다 뒤이면 A 섹션(재실행 없는 실측) 가능
SELECT TO_CHAR(MIN(sample_time), 'MM-DD HH24:MI') AS awr_from, TO_CHAR(MAX(sample_time), 'MM-DD HH24:MI') AS awr_to
     , CASE WHEN MIN(sample_time) <= TO_DATE('2026-09-30 15:39', 'YYYY-MM-DD HH24:MI') THEN 'A 섹션 가능' ELSE '09-30 샘플 소실 → 재실행만 가능' END AS judge
  FROM dba_hist_active_sess_history WHERE dbid = con_dbid;

-- P2. PLAN_ID 1461 의 정체 vs 지금 최신 계획 — 1461 이 최신이 아니면 재실행은 "옛 주차 RTF 로 BALANCE 덮어쓰기" 가 된다
SELECT v.plan_id, v.division_id, v.plan_start_yyyymmdd, v.plan_type, v.plan_seq, v.confirm_flag, TO_CHAR(v.confirm_date, 'MM-DD HH24:MI') AS confirmed
     , CASE WHEN v.plan_id = '1461' THEN '◆ 09-30 수동 실행이 쓴 PLAN' END AS mark
  FROM SCP_PLAN_VERSION_V v
 WHERE v.division_id = '40'
   AND (v.plan_id IN ('1461', '1462', '1463') OR v.plan_start_yyyymmdd >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 21, 'YYYYMMDD'))
 ORDER BY v.plan_start_yyyymmdd DESC, v.plan_type_order DESC;

-- P2-b. 배치 경로(PLAN_ID NULL)가 지금 고르는 계획 = 뷰의 MAX(PLAN_ID). 이것과 1461 이 다르면 "같은 조건" 이 아니다
SELECT MAX(plan_id) AS batch_path_plan_id, MAX(plan_start_yyyymmdd) AS plan_start
     , SUM(CASE WHEN plan_id = '1461' THEN 1 ELSE 0 END) AS rows_of_1461_still_in_view     -- 0 이면 1461 로 재실행해도 RTF 배분 0건 = 09-30 과 다른 길
  FROM SCP_PLN_RTF_ALLOCATION_V WHERE division_id = '40';

-- P3. 재실행 시 CUTOFF 블록이 건드릴 이번 주 버전 — MF_W/SF_W 건수 = C_QTY_BALANCE 재작성 횟수 · SP_W 가 1건 이상이면 ③ 분기 후보
SELECT version_type, COUNT(*) AS cnt, LISTAGG(version_no, ', ') WITHIN GROUP (ORDER BY version_no) AS versions
  FROM DM_MST_VERSION
 WHERE division_id = '40' AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')     -- SP 와 같은 기준일(L1260)
   AND version_type IN ('MF_W', 'SF_W', 'SP_W')
 GROUP BY version_type ORDER BY version_type;

-- P4. ③ 분기가 보낼 메일 수신자 수 (40 + ALL)
SELECT COUNT(*) AS mail_recipients
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE lookup_type = 'DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_ADDR' AND valid_yn = 'Y' AND (segment1 = '40' OR segment1 = 'ALL');

-- P5. 지금 이 순간 재실행하면 ③ 분기가 막히는가 — 40 사업부 제외시간 룩업(사내: THU 0800~1430) 과 현재 요일·시각 대조
SELECT d.segment1 AS division, d.segment2 AS dow, d.segment3 AS from_hhmi, d.segment4 AS to_hhmi
     , TO_CHAR(SYSDATE, 'DY HH24MI') AS now_
     , CASE WHEN d.segment2 = (SELECT dayofweek FROM SCM_SYS_CALENDAR_M WHERE basis_yyyymmdd = TO_CHAR(SYSDATE, 'YYYYMMDD'))
             AND TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI')) BETWEEN TO_NUMBER(d.segment3) AND TO_NUMBER(d.segment4)
            THEN '제외시간 안 → ③(SP_W 생성·메일) 건너뜀' ELSE '제외시간 밖 → ③ 수행 가능(차이 있으면 메일 발송)' END AS judge
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL d
 WHERE d.lookup_type = 'CUTOFF_EXCLUDE_TIME_DIVISION' AND d.valid_yn = 'Y' AND d.segment1 = '40';

-- P6. 클라우드 메일 SP 판본 — SLEEP(30) 활성 여부(C2 의 11.0분 고정이 이것) · 발송 가드(DB_NAME) 문구
SELECT name, line, SUBSTR(TRIM(text), 1, 140) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND type = 'PROCEDURE'
   AND name IN ('PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND')
   AND (UPPER(text) LIKE '%SLEEP%' OR UPPER(text) LIKE '%DB_NAME%' OR UPPER(text) LIKE '%P_SEND_MAIL%')
 ORDER BY name, line;

-- P7. 09-30·10-01 수동 실행이 이미 남긴 흔적 — 그 시각에 생성된 40 사업부 버전(= ③ 분기의 IRREGULAR SP_W) 과 메일 로그
SELECT 'VERSION' AS kind, version_no AS key_, version_type AS type_, TO_CHAR(creation_date, 'MM-DD HH24:MI:SS') AS at_, created_by
  FROM DM_MST_VERSION
 WHERE division_id = '40' AND creation_date BETWEEN TO_DATE('2026-09-29', 'YYYY-MM-DD') AND TO_DATE('2026-10-02', 'YYYY-MM-DD')
UNION ALL
SELECT 'MAIL_LOG', SUBSTR(segment2, 1, 60), use_type_code, TO_CHAR(creation_date, 'MM-DD HH24:MI:SS'), SUBSTR(segment1, 1, 50)   -- SEGMENT1 = 발송 프로그램, SEGMENT2 = 수신 주소(100자 절단)
  FROM SCM_ADM_SMS_MAIL_SEND_LOG
 WHERE creation_date BETWEEN TO_DATE('2026-09-29', 'YYYY-MM-DD') AND TO_DATE('2026-10-02', 'YYYY-MM-DD')
   AND UPPER(segment1) LIKE '%IRREGULAR%'
 ORDER BY 4;


/* ================================ A. 재실행 없이 09-30 실행을 AWR 로 실측 (권한: DBA_HIST_*) ================================
 * 두 수동 실행 창을 같이 본다: R1 = 09-30 15:39:17~16:31:13 (51.9분, SCM_MGR) · R2 = 10-01 14:38:21~15:18:07 (39.8분, SYSTEM)
 * DBID = CON_DBID 로 PDB 1벌만. 10초 샘플 1건 ≈ 10초. */

-- A1. 그 창에서 BALANCE 체인 SP 를 돌린 세션 — SID,SERIAL# · 계정 · MODULE(DBeaver/SQL Developer 등) · 활동 초
WITH runs AS (
    SELECT 'R1_0930' AS run_id, TO_DATE('2026-09-30 15:39:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-09-30 16:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'R2_1001',           TO_DATE('2026-10-01 14:38:00', 'YYYY-MM-DD HH24:MI:SS'),      TO_DATE('2026-10-01 15:19:00', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
, g AS (
    SELECT r.run_id, h.session_id, h.session_serial#, MAX(h.user_id) AS user_id
         , MAX(h.module) AS module, MAX(h.program) AS program, MAX(h.machine) AS machine
         , MIN(h.sample_time) AS first_seen, MAX(h.sample_time) AS last_seen, COUNT(*) * 10 AS active_sec
      FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
     WHERE h.dbid = h.con_dbid
       AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
     GROUP BY r.run_id, h.session_id, h.session_serial#
)
SELECT g.run_id, g.session_id || ',' || g.session_serial# AS sid_serial
     , (SELECT username FROM all_users u WHERE u.user_id = g.user_id) AS db_user
     , g.module, g.program, g.machine
     , TO_CHAR(g.first_seen, 'HH24:MI:SS') AS first_seen, TO_CHAR(g.last_seen, 'HH24:MI:SS') AS last_seen
     , g.active_sec
  FROM g
 ORDER BY g.run_id, g.active_sec DESC;

-- A2. 어느 SP 안에서 시간이 갔나 (현재 실행 중 SP 단위) — C2 의 "본체 40분 + SALES_PLAN_C 11.6분" 을 SP 로 분해
WITH runs AS (
    SELECT 'R1_0930' AS run_id, TO_DATE('2026-09-30 15:39:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-09-30 16:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'R2_1001',           TO_DATE('2026-10-01 14:38:00', 'YYYY-MM-DD HH24:MI:SS'),      TO_DATE('2026-10-01 15:19:00', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
SELECT r.run_id
     , NVL((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id), '(루트 ' || (SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_entry_object_id) || ')') AS in_sp
     , COUNT(*) * 10 AS approx_sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY r.run_id) * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
 WHERE h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
 GROUP BY r.run_id, h.plsql_object_id, h.plsql_entry_object_id
 ORDER BY r.run_id, approx_sec DESC;

-- A3. SQL × 플랜 라인 × 대기이벤트 — hook #129 0-b 의 "병목 1문장". 상위 SQL_ID 는 A4 로 플랜을 푼다
WITH runs AS (
    SELECT 'R1_0930' AS run_id, TO_DATE('2026-09-30 15:39:00', 'YYYY-MM-DD HH24:MI:SS') AS f, TO_DATE('2026-09-30 16:32:00', 'YYYY-MM-DD HH24:MI:SS') AS t FROM dual UNION ALL
    SELECT 'R2_1001',           TO_DATE('2026-10-01 14:38:00', 'YYYY-MM-DD HH24:MI:SS'),      TO_DATE('2026-10-01 15:19:00', 'YYYY-MM-DD HH24:MI:SS')      FROM dual)
, chain AS (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE'
             AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE'
                               , 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW'
                               , 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND', 'PR_DM_PLN_VERSION_CREATE', 'PR_SCM_MST_FUTURE_PRICE_CUTOFF', 'PR_DM_MST_EXCHANGE_RATE_CUTOFF'))
SELECT r.run_id, h.sql_id, h.sql_plan_hash_value AS phv, h.sql_plan_line_id AS line_id
     , h.sql_plan_operation || ' ' || h.sql_plan_options AS plan_op
     , NVL(h.event, 'ON CPU') AS event
     , (SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id) AS in_sp
     , COUNT(*) * 10 AS approx_sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER (PARTITION BY r.run_id) * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
     , (SELECT SUBSTR(DBMS_LOB.SUBSTR(x.sql_text, 120, 1), 1, 120) FROM dba_hist_sqltext x WHERE x.sql_id = h.sql_id AND x.dbid = x.con_dbid AND ROWNUM = 1) AS sql_text
  FROM dba_hist_active_sess_history h JOIN runs r ON h.sample_time >= r.f AND h.sample_time < r.t
 WHERE h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id IN (SELECT object_id FROM chain) OR h.plsql_object_id IN (SELECT object_id FROM chain))
 GROUP BY r.run_id, h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation || ' ' || h.sql_plan_options, NVL(h.event, 'ON CPU'), h.plsql_object_id
 ORDER BY r.run_id, approx_sec DESC
 FETCH FIRST 60 ROWS ONLY;

-- A4. 상위 SQL_ID 의 실행계획 (A3 의 sql_id / phv 를 넣는다)
-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('<sql_id>', <phv>, NULL, 'ALLSTATS LAST +PEEKED_BINDS'));

-- A5. 09-30 실행의 step 타임라인 (SCM_SYS_LOG_BATCH) — A2/A3 의 시각과 맞춰 "어느 step 구간 = 어느 SQL" 을 잇는다
SELECT TO_CHAR(x.event_date, 'MM-DD HH24:MI:SS') AS at_time
     , ROUND((x.event_date - LAG(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date)) * 86400) AS gap_sec
     , ROUND((x.event_date - TO_DATE('2026-09-30 15:39:17', 'YYYY-MM-DD HH24:MI:SS')) * 1440, 1) AS min_from_start
     , x.program_name, x.log_type, x.created_by, SUBSTR(x.log_message, 1, 60) AS log_message, SUBSTR(x.description, 1, 80) AS description
  FROM SCM_MGR.SCM_SYS_LOG_BATCH x
 WHERE x.event_date BETWEEN TO_DATE('2026-09-30 15:39:17', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2026-09-30 16:31:13', 'YYYY-MM-DD HH24:MI:SS')
   AND (x.created_by = 'SCM_MGR' OR x.created_by IN ('scm_batch', 'SYSTEM'))
   AND REGEXP_LIKE(x.program_name, 'BALANCE|WS_RTF|LOCAL_KRW|CUTOFF|VERSION_CREATE|MAIL_SEND')
 ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date;


/* ======================================== B. 재실행 (영향 ①~③ 인지 후에만) ======================================== */

-- B1. 실행 블록 — 09-30 과 같은 호출(계정 SCM_MGR 권장). MODULE/ACTION 을 찍어 두면 B2/B3 에서 이 세션만 골라낼 수 있다.
--     결과 커서는 성공/실패 모두 CODE='0' 이므로 MESSAGE 로 판정('SUCCESS' 아니면 '[[[code]msg'). 끝나면 COMMIT(09-30 DBeaver auto-commit 과 동일).
--     실행 전 P5 로 ③ 분기 수행 여부를, P3 로 재작성될 버전 수를 확인하고, 시작 시각을 적어 둔다.
/*
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v_cur   SYS_REFCURSOR;
    v_code  VARCHAR2(100);
    v_msg   VARCHAR2(4000);
    v_t0    TIMESTAMP := SYSTIMESTAMP;
BEGIN
    DBMS_APPLICATION_INFO.SET_MODULE(module_name => 'RERUN_QTY_BALANCE_40_1461', action_name => 'MANUAL_' || TO_CHAR(SYSDATE, 'MMDD_HH24MI'));
    DBMS_OUTPUT.PUT_LINE('START ' || TO_CHAR(v_t0, 'YYYY-MM-DD HH24:MI:SS') || '  SID=' || SYS_CONTEXT('USERENV', 'SID') || '  USER=' || USER);

    SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(P_DIVISION_ID => '40', P_PLAN_ID => '1461', O_RESULT_CURSOR => v_cur);

    FETCH v_cur INTO v_code, v_msg;
    IF v_cur%ISOPEN THEN CLOSE v_cur; END IF;
    DBMS_OUTPUT.PUT_LINE('END   ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') || '  ELAPSED=' || TO_CHAR(SYSTIMESTAMP - v_t0) || '  CODE=' || v_code || '  MSG=' || SUBSTR(v_msg, 1, 300));
    COMMIT;
    DBMS_APPLICATION_INFO.SET_MODULE(NULL, NULL);
END;
/
*/

-- B2. 실행 중 다른 세션에서 반복 조회 — 지금 어느 SQL / 어느 step 에 있나
-- B2-a. 세션 현재 상태 (V$SESSION)
SELECT s.sid, s.serial#, s.username, s.status, s.module, s.action, s.sql_id, s.sql_child_number
     , TO_CHAR(s.sql_exec_start, 'HH24:MI:SS') AS sql_started, s.last_call_et AS sec_in_current_call
     , s.event, s.state, s.seconds_in_wait, s.blocking_session
     , (SELECT SUBSTR(q.sql_text, 1, 120) FROM v$sql q WHERE q.sql_id = s.sql_id AND q.child_number = s.sql_child_number) AS sql_text
  FROM v$session s
 WHERE s.module = 'RERUN_QTY_BALANCE_40_1461';

-- B2-b. 이 세션의 1초 ASH 누적 — SQL × 플랜라인 × 이벤트 (실행 중·직후 모두 유효, V$ 는 최근 수십 분~수 시간 보존)
SELECT h.sql_id, h.sql_plan_hash_value AS phv, h.sql_plan_line_id AS line_id, h.sql_plan_operation || ' ' || h.sql_plan_options AS plan_op
     , NVL(h.event, 'ON CPU') AS event
     , (SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id) AS in_sp
     , COUNT(*) AS sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM v$active_session_history h
 WHERE h.module = 'RERUN_QTY_BALANCE_40_1461'
 GROUP BY h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation || ' ' || h.sql_plan_options, NVL(h.event, 'ON CPU'), h.plsql_object_id
 ORDER BY sec DESC
 FETCH FIRST 40 ROWS ONLY;

-- B2-c. step 로그 실시간 (오늘 40/1461 실행의 로그만)
SELECT TO_CHAR(x.event_date, 'HH24:MI:SS') AS at_time
     , ROUND((x.event_date - LAG(x.event_date) OVER (ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date)) * 86400) AS gap_sec
     , x.program_name, x.log_type, x.created_by, SUBSTR(x.log_message, 1, 60) AS log_message, SUBSTR(x.description, 1, 80) AS description
  FROM SCM_MGR.SCM_SYS_LOG_BATCH x
 WHERE x.event_date >= TRUNC(SYSDATE)
   AND ( x.in_para_data = '{"p_division_id":"40","p_plan_id":"1461"}'
      OR (x.created_by IN ('scm_batch', 'SYSTEM') AND REGEXP_LIKE(x.program_name, 'C_QTY_BALANCE|WS_RTF|LOCAL_KRW|CUTOFF|VERSION_CREATE|MAIL_SEND')
          AND x.event_date >= (SELECT MIN(event_date) FROM SCM_MGR.SCM_SYS_LOG_BATCH WHERE event_date >= TRUNC(SYSDATE) AND in_para_data = '{"p_division_id":"40","p_plan_id":"1461"}')))
 ORDER BY x.event_date, CASE x.log_type WHEN 'START' THEN 0 ELSE 1 END, x.creation_date;

-- B3. 실행 후 비교 — 오늘 실행(모듈 기준)을 A2 와 같은 SP 단위로. 09-30 R1 과 나란히 보려면 A2 결과와 대조
SELECT NVL((SELECT object_name FROM dba_objects o WHERE o.object_id = h.plsql_object_id), '(루트)') AS in_sp
     , COUNT(*) AS sec, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1) AS pct
     , TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_seen, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_seen
  FROM v$active_session_history h
 WHERE h.module = 'RERUN_QTY_BALANCE_40_1461'
 GROUP BY h.plsql_object_id
 ORDER BY sec DESC;

-- B3-b. 오늘 실행이 남긴 변경 — 새 버전(③ 분기 여부) · 메일 로그
SELECT 'VERSION' AS kind, version_no AS key_, version_type AS type_, TO_CHAR(creation_date, 'HH24:MI:SS') AS at_, created_by
  FROM DM_MST_VERSION WHERE division_id = '40' AND creation_date >= TRUNC(SYSDATE)
UNION ALL
SELECT 'MAIL_LOG', SUBSTR(segment2, 1, 60), use_type_code, TO_CHAR(creation_date, 'HH24:MI:SS'), SUBSTR(segment1, 1, 50)
  FROM SCM_ADM_SMS_MAIL_SEND_LOG WHERE creation_date >= TRUNC(SYSDATE) AND UPPER(segment1) LIKE '%IRREGULAR%'
 ORDER BY 4;
