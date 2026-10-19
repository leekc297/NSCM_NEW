-- ============================================================================
-- DMF0082 / Division 81 — "정적 컬럼 동일한데 메저가 복수 행" 원인 추적 (3차 · 확정 진단)
--   대상  : ⭐ 클라우드 (증상 발생 환경)
--   성격  : READ-ONLY. 아무것도 바꾸지 않는다.
--   작성  : 2026-09-21
--
-- ⭐⭐ 1~2차가 헛돈 이유 (정정)
--   화면 Version = 'Current' 는 `SEARCH_CURRENT` 배선을 타므로 실제 실행 SP 는
--   **P_DMF0082_GET_MAIN_DATA_CURRENT** 다. 1~2차는 `P_DMF0082_GET_MAIN_DATA` 를
--   돌렸으므로 "중복 0" 판정은 **다른 SP 에 대한 것**이었다 — 무효.
--   두 SP 는 스테이징 GTT 계열도 다르다:
--       GET      -> GT_DMF0082_*  (GT_DMF0082_MF_SP / _TEMP_SELECT_MEASURE)
--       CURRENT  -> GTT_*         (GTT_MF_SP / GTT_TEMPSELECTMEASURE / GTT_TEMPFCSTNPRICE)
--
-- ⭐⭐ 원인 가족 (SP 본문에 이미 기록된 기존 결함 계보)
--   최종 커서는 **표시 컬럼 전체를 동적 GROUP BY** 로 묶는다.
--   그래서 **계획 arm 과 실적 arm 의 같은 논리행이 어느 한 컬럼의 표현만 달라도 2행으로 갈린다.**
--     · [E20260825-AFSBLANK] AS_FROM_SITE : 계획 ' ' vs 실적 NULL  -> GTT_MF_SP 에서 ' ' 통일 (적용됨)
--     · [E20260825-CURRNORM] CURRENCY     : 계획 NULL vs 실적 '-'  -> 수량메저 ' ' 통일 (적용됨)
--     · SP 주석 한계 명시: "값이 실제로 다른 경우는 NVL 대상이 아니다 — 별도 판단 필요"
--   ⇒ MKT_FCST / RTF_SYS_RP / SCM_FCST / FCST_GAP 의 복수행은 **같은 가족의 미해소 축**일 가능성이 높다.
--      이 스크립트는 그 "남은 축"이 어느 컬럼인지 실측으로 지목한다.
--
-- ⚠️ 실행 방법
--   · 반드시 **한 커넥션**에서 위에서부터 순서대로. GTT 는 SYS$SESSION PRESERVE ROWS 다.
--   · 사용자 ID 는 minyonglee1 로 **이미 박아** 두었다(캡처 계정). 바꾸지 말 것.
--   · 조회조건은 캡처와 동일: Division 81 / Weekly / 2026-09-01 ~ 2027-02-28 / Version=Current
-- ============================================================================
SET LINESIZE 400
SET PAGESIZE 300
SET SQLBLANKLINES ON

VAR rc1 REFCURSOR
VAR rc2 REFCURSOR
VAR rc3 REFCURSOR
VAR rc4 REFCURSOR
VAR rc5 REFCURSOR
VAR rcr REFCURSOR

PROMPT ============================================================
PROMPT [0] Current 조회 SP 호출 (화면 Search 와 동일 파라미터)
PROMPT     멀티선택 조건은 빈 문자열 '' 이 "전체" 다 ('ALL' 넣으면 LIKE 로 전멸)
PROMPT ============================================================
EXEC PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT('81','','','','20260901','20270228','','','Current','Y','minyonglee1','','','','','', :rc1, :rc2, :rc3, :rc4, :rc5, :rcr);

PRINT rcr

PROMPT ============================================================
PROMPT [1] 스테이징 행수 — 0 이면 조회조건/데이터 문제 (이하 무의미)
PROMPT ============================================================
SELECT 'GTT_MF_SP'             AS GTT, COUNT(*) AS ROWS_CNT FROM GTT_MF_SP
UNION ALL SELECT 'GTT_TEMPFCSTNPRICE',      COUNT(*) FROM GTT_TEMPFCSTNPRICE
UNION ALL SELECT 'GTT_TEMPSELECTMEASURE',   COUNT(*) FROM GTT_TEMPSELECTMEASURE;

PROMPT ============================================================
PROMPT [2] 측정 선택 원장 — 중복이 있으면 그 자체로 메저 N배
PROMPT     EXPECT : MEASURE 중복 0
PROMPT ============================================================
SELECT MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID
     , COUNT(*) OVER (PARTITION BY MEASURE) AS SAME_MEASURE_ROWS
  FROM GTT_TEMPSELECTMEASURE
 ORDER BY SORT_ORDER_NO, MEASURE;

PROMPT ============================================================
PROMPT [3] ⭐⭐ 핵심 — 표시키가 같은데 2행 이상인 (키 + MEASURE) 묶음
PROMPT     최종 커서의 동적 GROUP BY 축(표시 컬럼)을 그대로 묶어 본다.
PROMPT     N >= 2 면 그것이 화면의 복수행이다.
PROMPT ============================================================
SELECT MEASURE
     , COUNT(*) AS DUP_GROUPS
     , SUM(N)   AS DUP_ROWS
     , MAX(N)   AS MAX_ROWS_PER_KEY
  FROM (
    SELECT MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, NICK_NAME
         , INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID
         , CELL_PROD_SITE_ID, AS_FROM_SITE, VERSION_NO, YYYYMMDD
         , COUNT(*) AS N
      FROM GTT_MF_SP
     GROUP BY MEASURE, DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, NICK_NAME
            , INCOTERMS, FCST_TYPE, DOM_EXP, CURRENCY, PROJECT_CODE, PLANT_SITE_ID
            , CELL_PROD_SITE_ID, AS_FROM_SITE, VERSION_NO, YYYYMMDD
    HAVING COUNT(*) > 1)
 GROUP BY MEASURE ORDER BY 2 DESC;

PROMPT ============================================================
PROMPT [4] ⭐⭐⭐ 남은 "분리 축" 지목
PROMPT     표시키에서 버킷(YYYYMMDD)만 빼고 묶었을 때, 어느 컬럼이 값이 갈리는가.
PROMPT     distinct > 1 인 컬럼 = 계획 arm 과 실적 arm 이 다르게 채우는 컬럼 = 원인.
PROMPT     (AS_FROM_SITE / CURRENCY 는 이미 정규화된 축이라 1 이어야 정상)
PROMPT ============================================================
SELECT COUNT(DISTINCT AS_FROM_SITE)      AS D_AS_FROM_SITE
     , COUNT(DISTINCT CURRENCY)          AS D_CURRENCY
     , COUNT(DISTINCT CELL_PROD_SITE_ID) AS D_CELL_PROD_SITE
     , COUNT(DISTINCT NICK_NAME)         AS D_NICK_NAME
     , COUNT(DISTINCT VERSION_NO)        AS D_VERSION_NO
     , COUNT(DISTINCT PLANT_SITE_ID)     AS D_PLANT_SITE
     , COUNT(DISTINCT DOM_EXP)           AS D_DOM_EXP
     , COUNT(DISTINCT FCST_TYPE)         AS D_FCST_TYPE
     , COUNT(DISTINCT INCOTERMS)         AS D_INCOTERMS
     , COUNT(DISTINCT END_CUSTOMER)      AS D_END_CUSTOMER
     , COUNT(DISTINCT NOTATION)          AS D_NOTATION
     , COUNT(DISTINCT EDIT_FLAG)         AS D_EDIT_FLAG
     , COUNT(DISTINCT NEW_FLAG)          AS D_NEW_FLAG
     , COUNT(DISTINCT SORT_KEY)          AS D_SORT_KEY
     , COUNT(DISTINCT SORT_ORDER_NO)     AS D_SORT_ORDER_NO
     , COUNT(DISTINCT MEASURE_GROUP)     AS D_MEASURE_GROUP
     , COUNT(DISTINCT BUCKET)            AS D_BUCKET
     , COUNT(DISTINCT WEEK_END_YN)       AS D_WEEK_END_YN
     , COUNT(DISTINCT MONTH_END_YN)      AS D_MONTH_END_YN
     , COUNT(DISTINCT TEAM_ID)           AS D_TEAM_ID
     , COUNT(DISTINCT CUTOFF_YYYYMMDD)   AS D_CUTOFF
     , COUNT(DISTINCT ATTR1)             AS D_ATTR1
     , COUNT(DISTINCT AS_YN)             AS D_AS_YN
     , COUNT(DISTINCT VMI_STD_DIO)       AS D_VMI_STD_DIO
  FROM GTT_MF_SP
 WHERE (MEASURE, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, YYYYMMDD) IN (
        SELECT MEASURE, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, YYYYMMDD
          FROM GTT_MF_SP
         WHERE MEASURE IN ('MKT_FCST','RTF_SYS_RP','SCM_FCST','FCST_GAP')
         GROUP BY MEASURE, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, YYYYMMDD
        HAVING COUNT(*) > 1);

PROMPT ============================================================
PROMPT [5] ⭐⭐⭐ 실제 2행 원본 — 무엇이 다른지 눈으로 확정
PROMPT     4종 메저 한정. 같은 (메저·사이트·모델·프로젝트·일자) 인데 2행인 것.
PROMPT     두 행을 나란히 놓고 값이 갈리는 컬럼을 찾는다.
PROMPT ============================================================
SELECT *
  FROM (
    SELECT MEASURE, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, YYYYMMDD, QTY
         , '[' || NVL(AS_FROM_SITE,'<NULL>')      || ']' AS AS_FROM_SITE
         , '[' || NVL(CURRENCY,'<NULL>')          || ']' AS CURRENCY
         , '[' || NVL(CELL_PROD_SITE_ID,'<NULL>') || ']' AS CELL_PROD
         , '[' || NVL(NICK_NAME,'<NULL>')         || ']' AS NICK_NAME
         , '[' || NVL(VERSION_NO,'<NULL>')        || ']' AS VERSION_NO
         , '[' || NVL(PLANT_SITE_ID,'<NULL>')     || ']' AS PLANT_SITE
         , '[' || NVL(DOM_EXP,'<NULL>')           || ']' AS DOM_EXP
         , '[' || NVL(FCST_TYPE,'<NULL>')         || ']' AS FCST_TYPE
         , '[' || NVL(INCOTERMS,'<NULL>')         || ']' AS INCOTERMS
         , '[' || NVL(END_CUSTOMER,'<NULL>')      || ']' AS END_CUSTOMER
         , '[' || NVL(NOTATION,'<NULL>')          || ']' AS NOTATION
         , '[' || NVL(ATTR1,'<NULL>')             || ']' AS ATTR1
         , '[' || NVL(AS_YN,'<NULL>')             || ']' AS AS_YN
         , '[' || NVL(EDIT_FLAG,'<NULL>')         || ']' AS EDIT_FLAG
         , '[' || NVL(NEW_FLAG,'<NULL>')          || ']' AS NEW_FLAG
         , '[' || NVL(SORT_KEY,'<NULL>')          || ']' AS SORT_KEY
         , '[' || NVL(BUCKET,'<NULL>')            || ']' AS BUCKET
         , '[' || NVL(CUTOFF_YYYYMMDD,'<NULL>')  || ']' AS CUTOFF
         , '[' || NVL(TEAM_ID,'<NULL>')          || ']' AS TEAM_ID
         , COUNT(*) OVER (PARTITION BY MEASURE, DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                     , PROJECT_CODE, YYYYMMDD) AS DUP_N
      FROM GTT_MF_SP
     WHERE MEASURE IN ('MKT_FCST','RTF_SYS_RP','SCM_FCST','FCST_GAP'))
 WHERE DUP_N > 1
 ORDER BY MEASURE, SCM_SITE_ID, ITEM_ID, YYYYMMDD
 FETCH FIRST 40 ROWS ONLY;

PROMPT ============================================================
PROMPT [6] 캡처 키 집중 추적 — FCA_US_HLM / A15CR7002 / MI00-P
PROMPT     캡처에 보이는 그 행이 스테이징에서 몇 행인지 그대로 본다.
PROMPT ============================================================
SELECT MEASURE, ITEM_ID, YYYYMMDD, QTY
     , '[' || NVL(AS_FROM_SITE,'<NULL>') || ']' AS AS_FROM_SITE
     , '[' || NVL(CURRENCY,'<NULL>')     || ']' AS CURRENCY
     , '[' || NVL(CELL_PROD_SITE_ID,'<NULL>') || ']' AS CELL_PROD
     , '[' || NVL(VERSION_NO,'<NULL>')   || ']' AS VERSION_NO
     , '[' || NVL(NOTATION,'<NULL>')     || ']' AS NOTATION
     , BUCKET, CUTOFF_YYYYMMDD, SORT_ORDER_NO
  FROM GTT_MF_SP
 WHERE SCM_SITE_ID = 'FCA_US_HLM' AND PROJECT_CODE = 'A15CR7002'
   AND MEASURE IN ('MKT_FCST','RTF_SYS_RP','SCM_FCST','FCST_GAP')
 ORDER BY ITEM_ID, MEASURE, YYYYMMDD
 FETCH FIRST 60 ROWS ONLY;

PROMPT ============================================================
PROMPT [7] 정규화 적용 여부 확인 — 두 UPDATE 가 실제로 먹었는가
PROMPT     EXPECT : AS_FROM_SITE NULL = 0행
PROMPT              수량메저(LOC/KRW/USD/MKT_AMT_* 제외) 의 CURRENCY 가 NULL/'-' = 0행
PROMPT     0 이 아니면 정규화 UPDATE 가 클라우드 본에 없다(= PKG 세대 차이).
PROMPT ============================================================
SELECT 'AS_FROM_SITE IS NULL'                  AS CHK, COUNT(*) AS N FROM GTT_MF_SP WHERE AS_FROM_SITE IS NULL
UNION ALL
SELECT 'AS_FROM_SITE = '' '' (정규화됨)',       COUNT(*) FROM GTT_MF_SP WHERE AS_FROM_SITE = ' '
UNION ALL
SELECT '수량메저 CURRENCY NULL/센티널',          COUNT(*) FROM GTT_MF_SP
 WHERE MEASURE NOT IN ('LOC','KRW','USD','MKT_AMT_LOC','MKT_AMT_KRW')
   AND (CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = '-');

PROMPT ============================================================
PROMPT [8] 클라우드 PKG 세대 (사내 = 2026-09-21 적용본)
PROMPT ============================================================
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;

PROMPT
PROMPT ============================================================
PROMPT §판정
PROMPT   [3] 에 4종 메저가 나오면       -> 스테이징에서 이미 2행. [4]/[5] 가 원인 컬럼을 지목한다.
PROMPT   [4] 에서 distinct>1 인 컬럼   -> 그게 계획/실적 arm 의 표현 차이 축 = 보완 대상.
PROMPT   [7] 이 0행이 아니면           -> 클라우드 PKG 가 정규화 UPDATE 이전 세대. PKG 동기화가 먼저.
PROMPT   [3] 이 0행인데 화면은 2행이면 -> 스테이징 아님. 최종 동적 GROUP BY 축(표시 컬럼 집합)
PROMPT                                   차이이므로 [5]/[6] 원본과 화면 캡처를 대조해 좁힌다.
PROMPT ============================================================
