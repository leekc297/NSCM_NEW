-- ============================================================================
-- DMF0035 / SALES PLAN / 81 DIVISION — 행 병합(AS-IS 초과 32) 원인 확정 (클라우드, SCM_MGR)
--
-- 확정된 사실
--   · AS-IS 3,649 / TO-BE 3,647. 순차 -2 는 상쇄값이고 실제는
--       TO-BE 초과 30 (통화 폴백 — 미정정)  +  AS-IS 초과 32 (신규)
--   · AS-IS 초과 32 = [2:1 병합 29] + [소멸 3]. 병합 29 쌍은 TO-BE 값이 AS-IS 두 행의 정확한 합.
--   · 그 29 쌍은 **표시 컬럼이 완전히 동일** → 숨은 컬럼 하나가 GROUP BY 에서 빠졌다는 뜻.
--   · 15:14 → 16:50 사이 적용분은 제공 파일뿐(PERSDIV / KWHNUM / QTYMASK).
--       QTYMASK = 82 전용 분기, KWHNUM = KWH 컬럼 전용(목록에 없음) → 소거.
--       ⇒ 남는 후보는 [E20260910-PERSDIV] 하나.
--   · div81 에서 PERSDIV 가 빼는 컬럼은 END_CUSTOMER40 / CELL_PROD_SITE_ID 둘뿐이고,
--     END_CUSTOMER40 은 동적 SQL 상 'A.PROJECT_CODE AS END_CUSTOMER40' 로 PROJECT_CODE 와 동일값 → 병합 불가.
--     ⇒ 성립 가능한 기전은 CELL_PROD_SITE_ID 하나뿐이다.
--
--   FROM_SITE_ID = CASE WHEN NVL(A.CELL_PROD_SITE_ID,'-')='-' THEN 'N/A' ELSE ... END
--       → NULL 과 '-' 를 같은 'N/A' 로 접는다.
--       → CELL_PROD_SITE_ID 가 GROUP BY 에 있으면 NULL 행과 '-' 행이 갈리고,
--         PERSDIV 로 빠지면 둘이 합쳐진다.
--
-- 사내는 이 조건이 성립하지 않는다(아래 [Q1] 사내값 참조) → 사내에서 재현 불가.
-- 클라우드 데이터에 NULL 과 '-' 가 섞여 있는지가 판정의 전부다.
-- 전부 읽기 전용.
-- ============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET LINESIZE 200
SET PAGESIZE 200

PROMPT ############ [Q1] div81 CELL_PROD_SITE_ID 값 분포
PROMPT 사내 실측: DM_PLN_SALES_PLAN_RESULT = [-] 만 존재 (NULL 0), 조회용 GT_DM22_RAW_DATA 21,231행 전부 [-]
PROMPT 클라우드에 (NULL) 과 [-] 가 함께 나오면 = 병합 기전 성립
SELECT 'DM_PLN_SALES_PLAN' AS SRC, NVL('['||CELL_PROD_SITE_ID||']','(NULL)') AS V, COUNT(*) AS CNT
FROM   DM_PLN_SALES_PLAN WHERE DIVISION_ID = '81' GROUP BY CELL_PROD_SITE_ID
UNION ALL
SELECT 'DM_PLN_SALES_PLAN_RESULT', NVL('['||CELL_PROD_SITE_ID||']','(NULL)'), COUNT(*)
FROM   DM_PLN_SALES_PLAN_RESULT WHERE DIVISION_ID = '81' GROUP BY CELL_PROD_SITE_ID
ORDER  BY 1, 3 DESC;

PROMPT ############ [Q2] ★판정★ 같은 키인데 CELL_PROD_SITE_ID 만 NULL/'-' 로 갈리는 그룹
PROMPT (FROM_SITE_ID 는 둘 다 N/A 라 표시상 구분 불가 → CPS 를 빼면 정확히 이만큼 병합된다)
PROMPT 기대: 0 이면 PERSDIV 기전 반증 / >0 이면 확정. 사내 = 0
SELECT COUNT(*) AS 병합그룹수, SUM(CNT) AS 관련행수 FROM (
  SELECT VERSION_NO, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, DOM_EXP,
         FCST_TYPE, MEASURE, CURRENCY, COMPANY_ID, COUNT(*) AS CNT
  FROM   DM_PLN_SALES_PLAN_RESULT
  WHERE  DIVISION_ID = '81'
  GROUP  BY VERSION_NO, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, DOM_EXP,
            FCST_TYPE, MEASURE, CURRENCY, COMPANY_ID
  HAVING COUNT(DISTINCT NVL(CELL_PROD_SITE_ID,'~NULL~')) > 1
     AND COUNT(DISTINCT CASE WHEN NVL(CELL_PROD_SITE_ID,'-') = '-'
                             THEN 'N/A' ELSE CELL_PROD_SITE_ID END) = 1 );

PROMPT ############ [Q3] 실제 신고 모델로 좁혀 확인 (병합 쌍에 등장한 모델)
SELECT ITEM_ID, SCM_SITE_ID, PROJECT_CODE, MEASURE,
       NVL('['||CELL_PROD_SITE_ID||']','(NULL)') AS CPS, COUNT(*) AS CNT
FROM   DM_PLN_SALES_PLAN_RESULT
WHERE  DIVISION_ID = '81'
AND    ITEM_ID IN ('MBT00206AA','MNT00072AA','MAL00307AA','MAL00308AA','EABS00173AD')
GROUP  BY ITEM_ID, SCM_SITE_ID, PROJECT_CODE, MEASURE, CELL_PROD_SITE_ID
ORDER  BY ITEM_ID, CPS, MEASURE;

PROMPT ############ [Q4] PERSDIV 실제 적용 여부 재확인 (기대: 0022/0035 각 1행)
SELECT NAME, LINE, TRIM(SUBSTR(TEXT,1,130)) AS TEXT
FROM   USER_SOURCE
WHERE  NAME IN ('PKG_DMF0022','PKG_DMF0035','PKG_DMF0051') AND TYPE = 'PACKAGE BODY'
AND    INSTR(TEXT,'UF_FX_STRING_SPLIT(C.DIVISION_ID') > 0
AND    LTRIM(TEXT) NOT LIKE '--%'
ORDER  BY NAME, LINE;
