-- =============================================================================
-- 90_VERIFY_AFTER_APPLY.sql  —  적용 **후** 검증 (READ-ONLY)
--   패키지: DBWORK_7UI_PKSENTINEL_TRUNC_20260730_2301
--   각 쿼리에 **사내 실측 기대값**을 주석으로 명기 — 다르면 원인 규명 후 재적용
--   실행 계정: SCM_MGR  (마지막 [8] 만 애플리케이션 계정)
-- =============================================================================
SET LINESIZE 200
SET PAGESIZE 100

PROMPT ============================================================
PROMPT [1] CODE 9본 컴파일 상태   ⭐ 기대: 9행 전부 VALID
PROMPT ============================================================
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM USER_OBJECTS
 WHERE OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE')
   AND OBJECT_NAME IN ('PKG_DMF0003','PKG_DMF0020','PKG_DMF0021','PKG_DMF0042',
                       'PKG_DMF0044','PKG_DMF0049','PKG_DMF0082',
                       'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL',
                       'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP')
 ORDER BY DECODE(STATUS,'INVALID',0,1), OBJECT_NAME;

PROMPT --- 컴파일 오류 상세   ⭐ 기대: 0행
SELECT NAME, TYPE, LINE, POSITION, TEXT
  FROM USER_ERRORS
 WHERE NAME IN ('PKG_DMF0003','PKG_DMF0020','PKG_DMF0021','PKG_DMF0042',
                'PKG_DMF0044','PKG_DMF0049','PKG_DMF0082',
                'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL',
                'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP')
 ORDER BY NAME, LINE;

PROMPT ============================================================
PROMPT [2] GTT / TYPE 자급 결과   ⭐ 기대: GTT >= 203 , TYPE >= 18
PROMPT ============================================================
SELECT 'GTT' AS KIND, COUNT(*) AS CNT FROM USER_TABLES WHERE TEMPORARY='Y'
UNION ALL
SELECT 'TYPE', COUNT(*) FROM USER_TYPES;

PROMPT ============================================================
PROMPT [3] ⭐ TRUNCATE → DELETE 전환 검증
PROMPT     기대: 잔존 TRUNCATE = **1행** (PKG_DMF0003 의 GT_DMF0_DM_MST_VERSION)
PROMPT     그 1행은 **의도적 유지**다 — 대상이 테이블이 아니라 PL/SQL 컬렉션 변수라
PROMPT     DELETE 로 바꾸면 정적 참조가 되어 컴파일 에러가 난다. _README §5 참조.
PROMPT     2행 이상이면 BODY 가 구판이다 → 02_DB_SP 재적용.
PROMPT ============================================================
SELECT NAME, LINE, SUBSTR(TRIM(TEXT),1,80) AS TXT
  FROM USER_SOURCE
 WHERE TYPE IN ('PACKAGE BODY','PROCEDURE')
   AND NAME IN ('PKG_DMF0003','PKG_DMF0020','PKG_DMF0021','PKG_DMF0042',
                'PKG_DMF0044','PKG_DMF0049','PKG_DMF0082',
                'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL',
                'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP')
   AND TRIM(TEXT) NOT LIKE '--%'
   AND REGEXP_LIKE(TEXT,'TRUNCATE\s+TABLE','i')
 ORDER BY NAME, LINE;

PROMPT ============================================================
PROMPT [4] ⭐ PK 센티널 '-' 정규화 반영 검증
PROMPT     ⚠ 아래는 **총 발생 건수**(기존분 + 이번 신규 136건)이다. 신규분만 세는 쿼리는 없다.
PROMPT        (라인수가 아니라 REGEXP_COUNT 로 세야 한다 — 한 라인에 여러 NVL 이 있다)
PROMPT     ⭐ 사내 실측 기대값 (합 803):
PROMPT       PKG_DMF0003 90 / PKG_DMF0020 22 / PKG_DMF0021 12 / PKG_DMF0042 65
PROMPT       PKG_DMF0044 541 / PKG_DMF0049 6 / PKG_DMF0082 45
PROMPT       DMF0020_SAVE_..._ALL 11 / _POPUP 11
PROMPT     이번 작업이 추가한 신규분 내역(참고): 0020 ALL 11·POPUP 11·PKG 22 /
PROMPT       0003 47 / 0021 11 / 0042 23 / 0044 5 / 0049 6  = 136
PROMPT       (DMF0082 는 GTT 정규화 2블록 방식 — 개별 NVL 이 아니므로 [5] 로 확인)
PROMPT ============================================================
SELECT NAME,
       SUM(REGEXP_COUNT(TEXT,'NVL\s*\(\s*[A-Za-z0-9_.]+\s*,\s*''-''\s*\)',1,'i')) AS NVL_SENTINEL_CNT
  FROM USER_SOURCE
 WHERE TYPE IN ('PACKAGE BODY','PROCEDURE')
   AND NAME IN ('PKG_DMF0003','PKG_DMF0020','PKG_DMF0021','PKG_DMF0042',
                'PKG_DMF0044','PKG_DMF0049','PKG_DMF0082',
                'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL',
                'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP')
   AND TRIM(TEXT) NOT LIKE '--%'
 GROUP BY NAME ORDER BY NAME;

PROMPT ============================================================
PROMPT [5] PKG_DMF0082 — division 82 편입 + 센티널 정규화 블록 반영
PROMPT     기대: DIV82_BRANCH >= 18  (81% OR ='82' 분기)
PROMPT           SENTINEL_BLOCK = 2   (GTT 정규화 UPDATE 블록 2개)
PROMPT ============================================================
SELECT SUM(CASE WHEN REGEXP_LIKE(TEXT,'LIKE\s*''81%''\s*OR.*=\s*''82''','i') THEN 1 ELSE 0 END) AS DIV82_BRANCH,
       SUM(CASE WHEN REGEXP_LIKE(TEXT,'PK 센티널|SENTINEL','i') THEN 1 ELSE 0 END) AS SENTINEL_MARK
  FROM USER_SOURCE
 WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TRIM(TEXT) NOT LIKE '--%';

PROMPT ============================================================
PROMPT [6] 메타 반영 검증
PROMPT   기대:  PROC_M_ROWS = 211 / NONSTD = 0
PROMPT          SHEET_MEASURE_82 = 10 / SHEET_COLUMNS_82 = 2 / MSG_LBL = 48
PROMPT ============================================================
SELECT 'PROC_M_ROWS' AS ITEM, COUNT(*) AS CNT FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'PKG_DMF0044.%' OR PROC_NM LIKE 'PKG_DMF0049.%'
UNION ALL
SELECT 'NONSTD_COL_TP_CD', COUNT(*) FROM SCM_ADM_PROC_M WHERE COL_TP_CD='PROC_RESULT'
UNION ALL
SELECT 'SHEET_MEASURE_82', COUNT(*) FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID='DMF0082' AND DIVISION_ID LIKE '%82%'
UNION ALL
SELECT 'SHEET_COLUMNS_82', COUNT(*) FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0082' AND DIVISION_ID LIKE '%82%'
UNION ALL
SELECT 'MSG_LBL', COUNT(*) FROM SCM_ADM_MSG_M
 WHERE MSG_ID IN ('LBL00783','LBL00794','LBL00795','LBL00796','LBL00797','LBL00798',
                  'LBL00799','LBL00800','LBL00844','LBL00845','LBL00846','LBL00847',
                  'LBL00848','LBL00849','LBL00850','LBL00851');

PROMPT ============================================================
PROMPT [7] ⭐ PROC_M ↔ SP 실제 시그니처 대조 (위치 + 이름)
PROMPT     불일치 시 PLS-00306 (인수의 갯수나 유형이 잘못되었습니다)
PROMPT     기대: MISMATCH 0행
PROMPT ============================================================
WITH SIG AS (
  SELECT a.OBJECT_NAME||'.'||a.PACKAGE_NAME AS X, a.PACKAGE_NAME, a.OBJECT_NAME,
         a.POSITION, a.ARGUMENT_NAME, a.IN_OUT
    FROM ALL_ARGUMENTS a
   WHERE a.OWNER='SCM_MGR' AND a.PACKAGE_NAME IN ('PKG_DMF0044','PKG_DMF0049')
     AND a.ARGUMENT_NAME IS NOT NULL
), MET AS (
  SELECT PROC_NM, SORT_ORD, COL_NM, COL_TP_CD FROM SCM_ADM_PROC_M
   WHERE PROC_NM LIKE 'PKG_DMF0044.%' OR PROC_NM LIKE 'PKG_DMF0049.%'
)
SELECT s.PACKAGE_NAME||'.'||s.OBJECT_NAME AS PROC, s.POSITION, s.ARGUMENT_NAME, s.IN_OUT,
       m.COL_NM, m.COL_TP_CD
  FROM SIG s FULL OUTER JOIN MET m
    ON m.PROC_NM = s.PACKAGE_NAME||'.'||s.OBJECT_NAME AND m.SORT_ORD = s.POSITION
 WHERE s.ARGUMENT_NAME IS NULL OR m.COL_NM IS NULL
 ORDER BY 1,2;

PROMPT ============================================================
PROMPT [8] ⛔ SYNONYM 확인 — **애플리케이션 계정(SCMP_APP) 세션에서 실행**
PROMPT     기대: 162 (사내 미러링 기준). 미달 시 18_APP_SYNONYM_ONLY.sql 재실행
PROMPT ============================================================
-- (APP 계정 세션에서)
-- SELECT COUNT(*) AS SYN_CNT FROM USER_SYNONYMS
--  WHERE TABLE_OWNER='SCM_MGR'
--    AND (SYNONYM_NAME LIKE 'PKG_DMF00%' OR SYNONYM_NAME LIKE 'GT%'
--         OR SYNONYM_NAME LIKE 'DMF0020_SAVE%');

PROMPT ============================================================
PROMPT [9] 최종 판정
PROMPT   ☐ [1] 9본 VALID / USER_ERRORS 0
PROMPT   ☐ [3] 잔존 TRUNCATE = 1 (PKG_DMF0003 L3329 만)
PROMPT   ☐ [4] NVL 센티널 9본 카운트 일치 (총 발생 합 803)
PROMPT   ☐ [6] 메타 5항목 기대값 일치
PROMPT   ☐ [7] 시그니처 MISMATCH 0
PROMPT   ☐ [8] APP 계정 SYNONYM 확보
PROMPT   ⚠ 저장 경로는 SQL 로 직접 실행하지 말 것(hook #104 — 부수효과·연쇄 SP)
PROMPT      → 반드시 **화면 E2E** 로 검증
PROMPT ============================================================
