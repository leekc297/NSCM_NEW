/* 00_PRECHECK — 조회 전용. 클라우드 PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING 판본 판정
 * [H-APPLIED] 마커 수 >0 → SKIP(이미 적용)
 * [H-PATTERN] 치환 대상 패턴 수 = 54w 2 / 1w 9 → 12 변경 블록 수동 반영 가능 (전체본 10 은 [H-MD5] 가 일치할 때만)
 * [H-MD5]     줄 수·지문이 사내 변경 직전 판(2026-10-06 15:38:38, 914줄, md5 e5f7388498f8846a9b09cfa8c37f8cf1)과 같으면 10 전체본 적용 가능 */
SELECT 'H-APPLIED' AS chk, COUNT(*) AS cnt, CASE WHEN COUNT(*) > 0 THEN 'SKIP — 이미 적용됨' ELSE '미적용' END AS judge
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%E20261007-DATEVAR%'
UNION ALL
SELECT 'H-PATTERN-54W', COUNT(*), CASE WHEN COUNT(*) = 2 THEN 'OK' ELSE '⚠ 기대 2 — 12 수동 반영 시 위치 확인' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%TO_CHAR(FN_NEXT_DAY(SYSDATE, ''MON'') - 7*54, ''YYYYMMDD'')%'
UNION ALL
SELECT 'H-PATTERN-1W', COUNT(*), CASE WHEN COUNT(*) = 9 THEN 'OK' ELSE '⚠ 기대 9 — 12 수동 반영 시 위치 확인' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%TO_CHAR(FN_NEXT_DAY(SYSDATE, ''MON'') - 7, ''YYYYMMDD'')%'
UNION ALL
SELECT 'H-LINES', MAX(line), CASE WHEN MAX(line) = 914 THEN '사내 판과 줄 수 일치 → 10 전체본 가능성' ELSE '⚠ 줄 수 다름 → 10 전체본 금지, 12 수동 반영' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE'
UNION ALL
SELECT 'H-DDL', NULL, '현재 LAST_DDL = ' || TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || status
  FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND object_type = 'PROCEDURE';
