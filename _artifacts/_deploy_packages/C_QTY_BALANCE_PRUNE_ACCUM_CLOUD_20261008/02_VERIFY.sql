/* =====================================================================================================
 * 02_VERIFY — 클라우드 적용 전/후 검증 (조회만). 순서: V0 → (03 R1 구판 실행) → 01 적용 → V1~V3 → (03 R3 신판 실행 · R4 비교)
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400

-- V0. 적용 전 — 현재 클라우드 판 (기대: 10-08 CORPSYNC 적용 판 = 3,092줄 · VALID · PERF 마크 0)
SELECT o.object_name, o.status, TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
     , (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type) AS total_lines
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%E20261008-PERF%') AS perf_marks
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%CUTOFF_YYYYMMDD_DATE = C_CUTOFF_DATE%') AS key_sites
  FROM all_objects o
 WHERE o.owner = 'SCM_MGR' AND o.object_type = 'PROCEDURE' AND o.object_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE';

-- V0-b. 적용 전 — 파티션 키·가상컬럼이 사내와 같은지 (기대: 두 표 모두 CUTOFF_YYYYMMDD_DATE · VIRTUAL=YES · TO_DATE("CUTOFF_YYYYMMDD",'YYYYMMDD')). 다르면 적용 중단
SELECT k.name AS table_name, k.column_name AS part_key, c.virtual_column, c.data_type
     , EXTRACTVALUE(DBMS_XMLGEN.GETXMLTYPE('SELECT data_default FROM all_tab_cols WHERE owner = ''SCM_MGR'' AND table_name = ''' || k.name || ''' AND column_name = ''' || k.column_name || ''''), '/ROWSET/ROW/DATA_DEFAULT') AS expr
  FROM all_part_key_columns k JOIN all_tab_cols c ON c.owner = k.owner AND c.table_name = k.name AND c.column_name = k.column_name
 WHERE k.owner = 'SCM_MGR' AND k.object_type = 'TABLE' AND k.name IN ('DM_PLN_MKT_FCST_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C');

-- V0-c. 적용 전 — 이 SP 를 실행 중인 세션이 없어야 한다
SELECT s.sid, s.serial#, s.username, s.status, s.module, s.last_call_et
  FROM v$session s
 WHERE s.plsql_entry_object_id IN (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name IN ('PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'))
    OR s.plsql_object_id IN (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE');

/* V0-d. (권장) 현재 클라우드 원문 백업 — 원복용. 주석 해제 후 1회 실행
CREATE TABLE SCM_MGR.ZZ_BK_SRC_C_QTY_BALANCE_20261008B AS
SELECT line, text FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE';
*/

-- ======== 여기서 03 R1(구판 실행·시각 기록) → 01 적용(SCM_MGR, F5) ========

-- V1. 적용 후(v3) — 기대: VALID · 3128줄 · ds_marks 1 · key_sites 28 · excl_marks 4 · ACCUM 참조 3(헤더·초기화 주석·START 주석) · AJS 마크 2 · 컴파일 오류 0 (v1 은 3,128줄/32 — v1 이면 01 재적용)
SELECT o.object_name, o.status, TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
     , (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type) AS total_lines
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%E20261008-PERF%') AS perf_marks
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%CUTOFF_YYYYMMDD_DATE = C_CUTOFF_DATE%') AS key_sites
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%GT_DPMFCQB_CUTOFF_MST_ACCUM%') AS accum_refs
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%의도적 제외%') AS excl_marks
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%optimizer_dynamic_sampling = 2%') AS ds_marks
     , (SELECT COUNT(*) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%2026.10.01 AJS%') AS ajs_marks
     , (SELECT COUNT(*) FROM all_errors e WHERE e.owner = o.owner AND e.name = o.object_name AND e.type = o.object_type) AS compile_errors
  FROM all_objects o
 WHERE o.owner = 'SCM_MGR' AND o.object_type = 'PROCEDURE' AND o.object_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE';

-- V2. 의존 객체 상태 (INVALID 가 있으면 ALTER ... COMPILE)
SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE', 'PR_DM_DNM_CREATE_C_WS_RTF', 'PKG_DMF0003', 'PKG_DMF0082')
 ORDER BY status, object_name;

-- V3. 실행 권한 유지 (기대: SCMP_APP EXECUTE 포함)
SELECT grantee, privilege FROM all_tab_privs WHERE table_schema = 'SCM_MGR' AND table_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' ORDER BY 1, 2;

-- V4. 실행 검증 = 03_RUN_COMPARE_cloud.sql R3(신판 실행) → R4(구판 결과와 측정값별 건수·QTY 합·키 해시 비교 = 0 차이) → R5(회당 소요·문장별 ASH)
