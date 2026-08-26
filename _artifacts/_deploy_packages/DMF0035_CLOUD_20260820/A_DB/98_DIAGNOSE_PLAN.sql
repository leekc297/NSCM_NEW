-- =====================================================================================================
-- 98_DIAGNOSE_PLAN.sql — DS2 적용 후에도 MKT FCST 스피너가 계속 도는 경우 (SELECT 전용)
--
--   먼저 두 가지를 가른다: ① DS2 가 **실제로 반영됐는가** ② 반영됐는데도 플랜이 여전히 나쁜가.
--   ①이면 배포 문제(97 절차), ②면 추가 튜닝 문제다. 추정하지 말고 W1 → W2 순으로 확인한다.
--
--   [사내 실측 — 판단 근거]
--     · 병목 문장이 쓰는 GTT 3종(GT_DM35_SEL_MEASURE / GT_DM35_VERSION / GT_DM35_T_LAST_SETUP_C)은
--       **통계가 전혀 없다**(NUM_ROWS NULL, GLOBAL_TEMP_TABLE_STATS=SESSION) → 전적으로 동적 샘플링 의존.
--       ⇒ 클라우드 `optimizer_dynamic_sampling=0` 이면 카디널리티 1 추정 → NL → 대형표 행단위 조회.
--     · division 40 조회가 읽는 표 = `DM_PLN_CFM_MKT_DEMAND_PLAN_C` (사내 6,816,647행),
--       **인덱스는 PK 하나뿐**(DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, ...).
--       ⚠ 앞선 P4 인덱스 대조에서 이 표를 빠뜨렸다 — 40 조회의 실제 원천인데 확인하지 않았다.
-- =====================================================================================================
SET LINESIZE 240
SET PAGESIZE 300

PROMPT ===== W1. ⭐⭐ DS2 가 실제로 반영됐는가 (여기서 FAIL 이면 배포 문제 — 97 절차로) =====
SELECT O.OBJECT_NAME, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND S.NAME=O.OBJECT_NAME
         AND S.TYPE='PACKAGE BODY' AND S.TEXT LIKE '%E20260820-DS2%') DS2_CNT
  FROM ALL_OBJECTS O
 WHERE O.OWNER='SCM_MGR' AND O.OBJECT_TYPE='PACKAGE BODY'
   AND O.OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
 ORDER BY 1;

PROMPT ===== W2. ⭐ 조회 세션이 실제로 ODS=2 로 동작하는가 (스피너 도는 동안 실행) =====
--  ALTER SESSION 이 먹혔다면 그 세션의 값은 2 여야 한다. 0 이면 새 본문이 실행되지 않은 것(=구 커서/미반영).
SELECT E.SID, E.NAME, E.VALUE
  FROM V$SES_OPTIMIZER_ENV E
  JOIN V$SESSION S ON S.SID = E.SID
 WHERE E.NAME = 'optimizer_dynamic_sampling'
   AND S.USERNAME IN ('SCMP_APP','SCMD_APP') AND S.STATUS='ACTIVE';

PROMPT ===== W3. 병목 문장 자식 커서 — ODS 변경으로 새 플랜이 생겼는가 =====
SELECT SQL_ID, CHILD_NUMBER, PLAN_HASH_VALUE, EXECUTIONS,
       ROUND(ELAPSED_TIME/GREATEST(EXECUTIONS,1)/1e6,1) ELA_PER_EXEC_S, BUFFER_GETS,
       TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI') LAST_ACT
  FROM V$SQL
 WHERE SQL_ID = 'cbxpxq839ydqs'
 ORDER BY CHILD_NUMBER;
--  PLAN_HASH_VALUE 가 이전과 **같으면** 플랜이 안 바뀐 것 = DS2 효과 없음(또는 미반영)

PROMPT ===== W4. ⭐ 그 문장의 실행계획 (무엇이 시간을 먹는지) =====
SELECT ID, LPAD(' ', DEPTH) || OPERATION || ' ' || OPTIONS AS OP,
       OBJECT_NAME, CARDINALITY, COST, ACCESS_PREDICATES, FILTER_PREDICATES
  FROM V$SQL_PLAN
 WHERE SQL_ID = 'cbxpxq839ydqs'
 ORDER BY CHILD_NUMBER, ID;
--  판독: NESTED LOOPS + 대형표 INDEX/TABLE ACCESS 반복 = 카디널리티 오추정
--        HASH JOIN + TABLE ACCESS FULL = 정상 방향(대신 스캔량이 시간)

PROMPT ===== W5. division 40 경로 표의 규모·인덱스 (사내: 6,816,647행 / 인덱스 PK 1개) =====
SELECT T.TABLE_NAME, T.NUM_ROWS, TO_CHAR(T.LAST_ANALYZED,'MM-DD') LA,
       (SELECT COUNT(DISTINCT I.INDEX_NAME) FROM ALL_INDEXES I
         WHERE I.OWNER='SCM_MGR' AND I.TABLE_NAME=T.TABLE_NAME) IDX_CNT
  FROM ALL_TAB_STATISTICS T
 WHERE T.OWNER='SCM_MGR' AND T.PARTITION_NAME IS NULL
   AND T.TABLE_NAME IN ('DM_PLN_CFM_MKT_DEMAND_PLAN_C','DM_PLN_MKT_FCST_C')
 ORDER BY 1;

PROMPT ===== W6. 지금 도는 세션 (스피너 중 실행) =====
SELECT S.SID, S.SERIAL#, S.LAST_CALL_ET RUNNING_SEC, S.EVENT, S.SQL_ID,
       SUBSTR(Q.SQL_TEXT,1,100) SQL_HEAD
  FROM V$SESSION S LEFT JOIN V$SQL Q ON Q.SQL_ID=S.SQL_ID AND Q.CHILD_NUMBER=S.SQL_CHILD_NUMBER
 WHERE S.STATUS='ACTIVE' AND S.USERNAME IN ('SCMP_APP','SCMD_APP')
 ORDER BY S.LAST_CALL_ET DESC FETCH FIRST 5 ROWS ONLY;

PROMPT ===== 판독 =====
PROMPT   W1 DS2_CNT=0 또는 LAST_DDL 이 배포 시각이 아님 → **미반영**. 97_REDEPLOY_LOCKED 절차로 재배포
PROMPT   W1 PASS 인데 W2 가 0                        → 구 커서/구 본문 실행 중. 세션 재접속 후 재조회
PROMPT   W2 가 2 인데 W3 PLAN_HASH 가 그대로          → DS2 로도 플랜이 안 바뀜 → W4 플랜 보고 2차 튜닝
PROMPT   W4 에 NESTED LOOPS + 대형표 반복 접근        → 카디널리티 오추정 잔존(GTT 통계 수집 추가 검토)
PROMPT   W6 SQL_ID 가 cbxpxq839ydqs 가 아님           → 병목이 옮겨간 것. 그 SQL_ID 로 W3/W4 재실행
