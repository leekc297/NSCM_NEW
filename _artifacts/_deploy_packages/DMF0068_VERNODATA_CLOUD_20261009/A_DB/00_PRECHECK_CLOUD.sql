/* 00_PRECHECK — 조회 전용. 클라우드 PKG_DMF0068 PACKAGE BODY 판본 판정 ([E20261009-VERNODATA])
 * [H-APPLIED] 마커 수 >0 → SKIP (이미 적용)
 * [H-LINES]/[H-LEN] 줄 수 1476 · 총 길이 68313 가 사내 변경 직전 판(2026-10-08 16:02, md5 61c8ea8fa713158eb0b5e12650241ce3)과 같으면 10 전체본 적용 가능
 * [H-TARGET] L429 `SELECT ORI_CUTOFF_VERSION_NO` + `FETCH FIRST 1 ROWS ONLY` 가 BEGIN 없이 노출되어 있으면 결함 판 → 10(전체본) 또는 12(수동 반영)
 * [H-GUARD]  NO_DATA_FOUND 가드 수 = 0 이면 미적용 */
SELECT 'H-APPLIED' AS chk, COUNT(*) AS cnt, CASE WHEN COUNT(*) > 0 THEN 'SKIP — 이미 적용됨' ELSE '미적용' END AS judge
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY' AND text LIKE '%E20261009-VERNODATA%'
UNION ALL
SELECT 'H-LINES', MAX(line), CASE WHEN MAX(line) = 1476 THEN '사내 판과 줄 수 일치 → 10 전체본 가능' ELSE '⚠ 줄 수 다름 → 10 전체본 금지, 12 수동 반영' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY'
UNION ALL
SELECT 'H-LEN', SUM(LENGTH(text)), CASE WHEN SUM(LENGTH(text)) = 68313 THEN '사내 판과 길이 일치' ELSE '⚠ 길이 다름 → 12 수동 반영' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY'
UNION ALL
SELECT 'H-TARGET', COUNT(*), CASE WHEN COUNT(*) = 1 THEN 'L429 SELECT INTO 실존 (결함 판)' ELSE '⚠ 대상 문장 수 ' || COUNT(*) || ' — 원문 확인' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY' AND line = 429 AND text LIKE '%SELECT ORI_CUTOFF_VERSION_NO%'
UNION ALL
SELECT 'H-GUARD', COUNT(*), CASE WHEN COUNT(*) = 0 THEN '가드 없음 (미적용)' ELSE '가드 있음' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PKG_DMF0068' AND type = 'PACKAGE BODY' AND text LIKE '%WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL%'
UNION ALL
SELECT 'H-DDL', NULL, '현재 LAST_DDL = ' || TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || status
  FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PKG_DMF0068' AND object_type = 'PACKAGE BODY';
