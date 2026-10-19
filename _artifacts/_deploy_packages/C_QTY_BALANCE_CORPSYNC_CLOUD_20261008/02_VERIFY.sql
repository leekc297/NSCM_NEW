/* =====================================================================================================
 * 02_VERIFY — 클라우드 적용 전/후 검증 (조회만). 적용 전 V0 → 01 파일 적용 → V1~V5
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400

-- V0. 적용 전 — 현재 클라우드 판 기록 (기대: 2026-10-02 15:39:33 · 3100줄 · VALID). 아래 값이 다르면 README §3 의 차이 목록을 다시 확인
SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
     , (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type) AS total_lines
  FROM all_objects o
 WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE' AND object_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE';

-- V0-b. 적용 전 — 이 SP 를 실행 중인 세션이 없어야 CREATE OR REPLACE 가 대기 없이 끝난다
SELECT s.sid, s.serial#, s.username, s.status, s.module, s.last_call_et
  FROM v$session s
 WHERE s.plsql_entry_object_id IN (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name IN ('PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'))
    OR s.plsql_object_id IN (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE');

/* V0-c. (권장) 적용 전 현재 클라우드 원문 백업 — 원복용. 주석 해제 후 1회 실행
CREATE TABLE SCM_MGR.ZZ_BK_SRC_C_QTY_BALANCE_20261008 AS
SELECT line, text FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE';
SELECT COUNT(*) AS backed_up_lines FROM SCM_MGR.ZZ_BK_SRC_C_QTY_BALANCE_20261008;   -- 기대 3100
*/

-- ======== 여기서 01_PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE.sql 적용 (SCM_MGR) ========

-- V1. 적용 후 — 기대: VALID · 3092줄 · LAST_DDL = 적용 시각
SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
     , (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type) AS total_lines
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%2026.10.01 AJS%') AS ajs_1001_marks   -- 기대 2
     , (SELECT COUNT(*) FROM all_errors e WHERE e.owner = o.owner AND e.name = o.object_name AND e.type = o.object_type) AS compile_errors        -- 기대 0
  FROM all_objects o
 WHERE owner = 'SCM_MGR' AND object_type = 'PROCEDURE' AND object_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE';

-- V2. GROUP BY tail 4곳 (기대 4행: 761 · 795 · 941 · 978 — 사내 줄 번호)
SELECT line, SUBSTR(RTRIM(text), 1, 140) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND line BETWEEN 700 AND 1000
   AND UPPER(text) LIKE '%C.VMI_YN%' AND UPPER(text) LIKE '%C.OPERATION_GROUP%'
   AND NOT REGEXP_LIKE(text, '^\s*-{2}')
 ORDER BY line;

-- V3. 사내 판 지표와 일치 (기대: blank 0 · '--' 줄 11 · GATHER 0 · 뷰 참조 13 · 로그 호출 7)
SELECT COUNT(*) AS total_lines
     , SUM(CASE WHEN TRIM(text) IS NULL THEN 1 ELSE 0 END) AS blank_lines
     , SUM(CASE WHEN REGEXP_LIKE(text, '^\s*-{2}') THEN 1 ELSE 0 END) AS comment_lines
     , SUM(CASE WHEN UPPER(text) LIKE '%GATHER_TABLE_STATS%' THEN 1 ELSE 0 END) AS gather_stats
     , SUM(CASE WHEN UPPER(text) LIKE '%SCP_PLN_RTF_ALLOCATION_V%' THEN 1 ELSE 0 END) AS view_refs
     , SUM(CASE WHEN UPPER(text) LIKE '%PR_SCM_SYS_LOG_BATCH(%' THEN 1 ELSE 0 END) AS log_calls
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE';

-- V4. 의존 객체 상태 (INVALID 가 있으면 ALTER ... COMPILE)
SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE', 'PKG_DMF0003', 'PKG_DMF0082')
 ORDER BY status, object_name;

-- V5. 실행 검증 = 11_rerun_plan1464_cloud.sql 을 목요일 08:00~14:30 안에 재실행 → C_QTY_BALANCE 2회가 END 로 끝나고 S4-d 회당 소요가 나오면 완료
