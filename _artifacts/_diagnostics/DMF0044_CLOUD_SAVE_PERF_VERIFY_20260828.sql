--------------------------------------------------------------------------------
-- DMF0044 클라우드 저장 지연 — 원인 검증 쿼리 세트 (2026-08-28)
--
-- 배경: 사내는 저장 성능 정정 1단계(2026-08-20, 마커 E20260820-CF*)가 적용되어
--       저장이 빠르고, 클라우드는 원장 기준 미적용(클라우드 N) 상태.
--       클라우드가 구본 PKG 로 돌면 ①MERGE 유입 필터 미적용(16,746행 vs 정정 후
--       1,316행, -92%) ②행별 ROWID WHILE 루프 ③저장 중 GATHER_TABLE_STATS
--       ④optimizer_dynamic_sampling=0 무방어(DS2 세션 가드 부재) 가 전부 살아있다.
--
-- 사용법: 클라우드 DB 에서 Q1→Q4 순서로 실행 후 결과 전체를 회신.
--         Q1/Q2 는 일반 계정 가능(ALL_*), Q3/Q4 는 V$ 조회 권한 필요(없으면 DBA 대행).
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Q1. PKG_DMF0044 정정 적용 여부 — 마커 카운트 (⭐ 핵심 판정)
--
-- 기대값(사내 라이브 실측 2026-08-28 동일 기준):
--   CFMERGE=2 / CFSETBASED=2 / CFNOSTATS=1 / EXAUTH=4 / DS2>=8
-- 판정:
--   전부 0        → 클라우드 = 구본 (저장 지연 원인 확정. 조치 = 이관 패키지 적용)
--   기대값과 일치 → 신본 적용됨 (그런데도 느리면 Q3/Q4 로 진행 — 파라미터·데이터량 축)
--------------------------------------------------------------------------------
SELECT m.marker, COUNT(s.line) cnt
  FROM (SELECT 'E20260820-CFMERGE'    marker FROM DUAL UNION ALL
        SELECT 'E20260820-CFSETBASED'        FROM DUAL UNION ALL
        SELECT 'E20260820-CFNOSTATS'         FROM DUAL UNION ALL
        SELECT 'E20260820-EXAUTH'            FROM DUAL UNION ALL
        SELECT 'E20260812-DS2'               FROM DUAL) m
  LEFT JOIN ALL_SOURCE s
    ON s.owner = 'SCM_MGR'
   AND s.name  = 'PKG_DMF0044'
   AND s.type  = 'PACKAGE BODY'
   AND s.text LIKE '%' || m.marker || '%'
 GROUP BY m.marker
 ORDER BY m.marker;

--------------------------------------------------------------------------------
-- Q2. PKG 상태·배포 시각 — 구본/신본 및 INVALID 여부
--
-- 판정: LAST_DDL 이 2026-08-20 이전이면 구본 확정. STATUS 는 반드시 VALID 여야 함.
--       (사내 신본 BODY = 2026-08-20 19:17:48)
--------------------------------------------------------------------------------
SELECT object_name, object_type, status,
       TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') last_ddl
  FROM ALL_OBJECTS
 WHERE owner = 'SCM_MGR'
   AND object_name IN ('PKG_DMF0044', 'PKG_DMF0049')
 ORDER BY object_name, object_type;

--------------------------------------------------------------------------------
-- Q3. 시스템 파라미터 — 클라우드 기실측 계보(DMF0082): optimizer_dynamic_sampling=0
--
-- 판정: 0 이면 GTT 카디널리티 오추정 축 살아있음. 신본은 저장 SP 진입점
--       ALTER SESSION ... = 2 가드가 있어 완화되지만, 근본 조치는
--       ALTER SYSTEM SET optimizer_dynamic_sampling = 2 SCOPE=BOTH (DBA, 전 화면 파급 개선).
--------------------------------------------------------------------------------
SELECT name, value
  FROM V$PARAMETER
 WHERE name IN ('optimizer_dynamic_sampling', 'optimizer_index_cost_adj',
                'cursor_sharing', 'cpu_count');

--------------------------------------------------------------------------------
-- Q4. 저장 범인 SQL 실측 — 저장 1회 수행 직후 실행 (화면에서 저장 재현 → 즉시 조회)
--
-- 대상: 저장 경로 원장 2표 + CF 경로 GTT. sec_per_exec 상위가 범인.
-- 회신 시 SQL_ID / PLAN_HASH_VALUE / SEC_PER_EXEC / BUFFER_GETS 열이 특히 중요
-- (사내와 PHV 이 다르면 실행계획 문제, BUFFER_GETS 수십 배면 Nested Loop/카테시안 의심).
--------------------------------------------------------------------------------
SELECT sql_id, plan_hash_value phv, executions execs,
       ROUND(elapsed_time / 1e6 / NULLIF(executions, 0), 2) sec_per_exec,
       buffer_gets, disk_reads, rows_processed,
       SUBSTR(REPLACE(REPLACE(sql_text, CHR(10), ' '), CHR(13), ' '), 1, 120) sql_head
  FROM V$SQL
 WHERE (UPPER(sql_text) LIKE '%DM_PLN_SALES_PLAN_REPORT_C%'
     OR UPPER(sql_text) LIKE '%DM_PLN_SALES_ETC_REPORT_C%'
     OR UPPER(sql_text) LIKE '%GT_0044_RESULTS_MST_C%')
   AND executions > 0
   AND parsing_schema_name IN ('SCM_MGR', 'SCMP_APP')
 ORDER BY elapsed_time DESC
 FETCH FIRST 25 ROWS ONLY;

--------------------------------------------------------------------------------
-- (참고) 판정 후 조치
--   Q1 전부 0 → `_artifacts/_deploy_packages/DMF0044_CLOUD_20260820/A_DB/`
--               10_PKG_DMF0044_SPEC.sql → 11_PKG_DMF0044_BODY.sql 순 적용
--               (마커 5종 전부 포함 확인 완료 — 2026-08-28 대조) 후 90_VERIFY.sql.
--   Q3 = 0    → DBA 에 ALTER SYSTEM 요청 (세션 가드가 있어도 시스템 0 은 타 화면 공통 리스크).
--   Q1 정상 + 여전히 느림 → Q4 결과 회신 (사내 동일 SQL_ID 대조로 2단계 진단).
--------------------------------------------------------------------------------
