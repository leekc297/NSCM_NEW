-- ============================================================================================
-- DMF0014_GRAYZERO_CLOUD_20260823 / 적용 후 검증 (QA·DEV 각각) — 기대값 단언 형식
-- ============================================================================================

PROMPT ===== V1. 컴파일 상태 (기대: PACKAGE / PACKAGE BODY 모두 VALID) =====
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
WHERE  OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0014' ORDER BY OBJECT_TYPE;

PROMPT ===== V2. 정정 반영 단언 (사내 실측치와 동일해야 함) =====
WITH exp (K, V) AS (
  SELECT '마커 E20260823-GRAYZERO', 2 FROM DUAL UNION ALL
  SELECT '적재 CASE (…ELSE 0 END)', 1 FROM DUAL UNION ALL
  SELECT '구 반려문구 Invalid Upload Week', 0 FROM DUAL),
act AS (
  SELECT '마커 E20260823-GRAYZERO' K, COUNT(*) V FROM ALL_SOURCE
   WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
     AND INSTR(TEXT,'E20260823-GRAYZERO') > 0
  UNION ALL
  SELECT '적재 CASE (…ELSE 0 END)', COUNT(*) FROM ALL_SOURCE
   WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
     AND INSTR(TEXT,'THEN TO_NUMBER(V.VALUE) ELSE 0 END') > 0
  UNION ALL
  SELECT '구 반려문구 Invalid Upload Week', COUNT(*) FROM ALL_SOURCE
   WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY'
     AND INSTR(TEXT,'Invalid Upload Week') > 0)
SELECT e.K, e.V EXPECTED, a.V ACTUAL,
       CASE WHEN a.V = e.V THEN 'PASS' ELSE 'FAIL ⛔' END RESULT
FROM   exp e JOIN act a ON a.K = e.K ORDER BY 4 DESC, 1;

PROMPT ===== V3. BODY 규모 (사내 7,325줄 — 대폭 차이나면 다른 세대가 올라간 것) =====
SELECT COUNT(*) BODY_LINES, 7325 EXPECTED FROM ALL_SOURCE
WHERE  OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY';

PROMPT ===== V4. 런타임 스모크 (수기 — 화면에서 확인) =====
-- S1 Excel Form 다운로드 → 회색(입력불가) 칸이 있는 행을 고른다.
-- S2 그 회색 칸에 임의 수량을 적고 [Upload] → 종전과 달리 **반려되지 않아야** 한다(ERROR 아님).
-- S3 [OK] 적재 후 원장 확인 — 그 칸의 버킷은 QTY = 0, 같은 행의 노란 칸은 입력값 그대로.
--    SELECT YYYYMMDD, QTY FROM SCM_MGR.DM_PLN_CUSTOMER_PSI
--     WHERE DIVISION_ID = :div AND SCM_SITE_ID = :site AND MEASURE = :measure
--       AND YYYYMMDD IN (:gray_bucket, :yellow_bucket) AND BATCH_RESULT='UI'
--     ORDER BY YYYYMMDD;
-- S4 0 처리 건수 로그 확인 (선택):
--    SELECT * FROM SCM_MGR.SCM_SYS_LOG_BATCH -- (환경별 로그 테이블명 상이 가능)
--     WHERE PROGRAM_NAME LIKE '%DMF0014%' AND LOG_TYPE='175' ORDER BY EVENT_DATE DESC;
