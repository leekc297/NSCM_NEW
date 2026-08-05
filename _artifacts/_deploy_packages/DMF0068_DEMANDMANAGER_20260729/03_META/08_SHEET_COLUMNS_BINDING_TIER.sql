-- DMF0068 Demand Manager — 컬럼 메타 바인딩·헤더 단수 정정 (2026-07-30)
--
-- [증상 1] 정적 컬럼이 전부 빈 셀로 표시된다 (월 컬럼 M1~ 만 값이 보임).
--   원인 : COLUMN_NAME 이 AS-IS FarPoint 표기(대소문자 혼용: Project_Name / OrderStart / SResult …)인데
--          조회 프로시저가 돌려주는 별칭은 전부 대문자(PROJECT_NAME / ORDERSTART / SRESULT …)라 바인딩이 어긋난다.
--          MEASURE2 / KEYVALUE / KEYVALUE2 / M1~M143 만 우연히 일치해 값이 보였다.
--   조치 : COLUMN_NAME 을 프로시저 별칭과 동일한 대문자로 정정 (룰: SHEET_COLUMNS = SP alias 일치).
--
-- [증상 2] 헤더가 3단으로 나온다 (AS-IS 는 2단).
--   원인 : 모든 컬럼에 COLUMN_LABEL / SMALL_CLASS / LARGE_CLASS 3종이 다 채워져 있어 3단으로 판정된다.
--          (판정 규칙: LARGE 가 비었거나 SMALL=LARGE 이면 2단, 아니면 3단)
--   조치 : 그룹이 없는 컬럼은 SMALL·LARGE 를 비우고, 시작/종료만 SMALL=LARGE='수주 기간' 으로 묶는다.
--          (캐노니컬 패턴 = DMF0044 'MDF Reports')
-- ⚠ 기존 행 UPDATE 이므로 적용 전 백업 SELECT 를 먼저 남길 것.

-- [백업] 적용 전 상태
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, VISIBLE_FLAG, SORT_ORDER_NO
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0068' AND NOT REGEXP_LIKE(COLUMN_NAME, '^M[0-9]+$')
ORDER BY TO_NUMBER(SORT_ORDER_NO), COLUMN_NAME;

-- ① 바인딩 정정 — 프로시저 별칭(대문자)과 일치시킨다
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    COLUMN_NAME      = UPPER(COLUMN_NAME),
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
WHERE  PROGRAM_ID  = 'DMF0068'
  AND  SHEET_NAME  = 'ContributeSalesList'
  AND  COLUMN_NAME <> UPPER(COLUMN_NAME);

-- ② 헤더 2단화 — 그룹이 없는 컬럼은 상·중 분류를 비운다
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    SMALL_CLASS_LABEL_NAME = NULL,
       LARGE_CLASS_LABEL_NAME = NULL,
       LAST_UPDATED_BY        = 'admin',
       LAST_UPDATE_DATE       = SYSDATE
WHERE  PROGRAM_ID  = 'DMF0068'
  AND  SHEET_NAME  = 'ContributeSalesList'
  AND  COLUMN_NAME NOT IN ('ORDERSTART', 'ORDEREND');

-- ③ 수주 기간 그룹 — 시작/종료만 상위 헤더로 묶는다 (SMALL = LARGE 이어야 2단으로 판정된다)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
SET    SMALL_CLASS_LABEL_NAME = '수주 기간',
       LARGE_CLASS_LABEL_NAME = '수주 기간',
       LAST_UPDATED_BY        = 'admin',
       LAST_UPDATE_DATE       = SYSDATE
WHERE  PROGRAM_ID  = 'DMF0068'
  AND  SHEET_NAME  = 'ContributeSalesList'
  AND  COLUMN_NAME IN ('ORDERSTART', 'ORDEREND');

COMMIT;

-- 검증 ① : 소문자 잔존 0행
SELECT COUNT(*) AS LOWERCASE_LEFT
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0068' AND COLUMN_NAME <> UPPER(COLUMN_NAME);

-- 검증 ② : 2단 판정 조건 위반 0행 (LARGE 가 비었거나 SMALL = LARGE 여야 함)
SELECT COUNT(*) AS TIER_VIOLATION
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0068'
  AND  LARGE_CLASS_LABEL_NAME IS NOT NULL
  AND  NVL(SMALL_CLASS_LABEL_NAME, '@') <> LARGE_CLASS_LABEL_NAME;

-- 검증 ③ : 정적 컬럼 최종 상태
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, NVL(SMALL_CLASS_LABEL_NAME, '-') AS SMALL,
       NVL(LARGE_CLASS_LABEL_NAME, '-') AS LARGE, VISIBLE_FLAG, SORT_ORDER_NO
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0068' AND NOT REGEXP_LIKE(COLUMN_NAME, '^M[0-9]+$')
ORDER BY TO_NUMBER(SORT_ORDER_NO), COLUMN_NAME;
