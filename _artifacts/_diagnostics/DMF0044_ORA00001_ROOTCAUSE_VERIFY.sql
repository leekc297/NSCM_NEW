--------------------------------------------------------------------------------
-- DMF0044 저장 ORA-00001 근본원인 진단 (클라우드 / Oracle / SCM_MGR)
-- 마커 : E20260903-DMF0044DUP
--------------------------------------------------------------------------------
-- 실패 지점 (실측 2026-09-03) : PKG_DMF0044 BODY line 5354
--   -- RTF 가 원래 없었을 경우
--   INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
--   SELECT '1', ... NVL(B.MEASURE,'-'), '-' /*PLANT_SITE_ID*/, NVL(B.YYYYMMDD,'-') ...
--   FROM DM_PLN_SALES_PLAN_REPORT_C A JOIN GT_0044_RESULTS_MST_C B
--     ON ... AND A.YYYYMMDD LIKE SUBSTR(B.YYYYMMDD,1,4)||'%'      <- 연 단위
--    AND B.MEASURE IN ('RTF','RTF_SYS_RP') AND B.SEQ_RANK = V_I
--   WHERE A.DIVISION_ID = V_DIVISION_ID AND A.VERSION_NO = V_VERSION_NO
--     AND ROWNUM = 1;
--
-- 확인된 사실
--   · ROWNUM = 1 이 이미 있다 -> 1행만 넣는데도 충돌 = "넣으려는 그 행이 이미 존재"
--   · 이 INSERT 는 상위 IF 의 ELSE 다.  IF NVL(V_ORIQTY,0) <> 0 THEN (배분) ELSE (이 INSERT)
--     V_ORIQTY = 기존 REPORT_C 의 RTF/RTF_SYS_RP QTY 합계 (BODY L5113~5122)
--   · 즉 **행은 있는데 QTY 합계가 0** 이면 "원래 없었다"로 판정되어 INSERT 로 간다 -> 중복
--   · AS-IS(L763)는 PLANT_SITE_ID 에 '' (MSSQL 빈문자) 를 넣지만
--     TO-BE 는 '-' 를 넣는다. Oracle 은 ''=NULL 이고 PLANT_SITE_ID 는 PK 라 NULL 불가.
--
-- ⭐ 이 쿼리가 가르는 것
--   가설 A : 행이 존재하는데 SUM(QTY)=0 이라 ELSE 로 빠져 중복 INSERT  -> §2 가 증명
--   가설 B : PLANT_SITE_ID 센티널('-' vs 공백) 불일치로 키가 겹침       -> §3 이 증명
--   가설 C : 같은 저장 트랜잭션 안 다른 INSERT 와 충돌                  -> §4 가 증명
--
-- 실행 : SQLcl / DBeaver. 전 구문 읽기 전용(DML 없음).
--------------------------------------------------------------------------------
SET SERVEROUTPUT OFF
SET LINESIZE 320
SET PAGESIZE 200

DEFINE P_DIV     = '40'
DEFINE P_VER     = 'RP_S_20260902_V006_C'
DEFINE P_CUTOFF  = 'REPORT_SP_W'

COLUMN MEASURE          FORMAT A16
COLUMN PLANT_SITE_ID    FORMAT A18
COLUMN 판정             FORMAT A54
COLUMN DEPT_ID          FORMAT A12
COLUMN ITEM_ID          FORMAT A22
COLUMN SCM_SITE_ID      FORMAT A24

PROMPT ================ §0. 환경 지문 ================
SELECT SYS_CONTEXT('USERENV','DB_NAME') AS DB_NAME
     , TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS NOW FROM DUAL;

PROMPT ================ §1. 실패 버전의 저장 현황 (MEASURE별) ================
SELECT MEASURE, COUNT(*) AS 행수, SUM(QTY) AS QTY합계
     , COUNT(DISTINCT PLANT_SITE_ID) AS PLANT값종류
     , MIN(YYYYMMDD) AS 최소월, MAX(YYYYMMDD) AS 최대월
  FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID = '&P_DIV' AND VERSION_NO = '&P_VER'
 GROUP BY MEASURE ORDER BY MEASURE;

PROMPT ================ §2. ⭐ 가설 A — 행은 있는데 QTY 합계가 0 인 키 ================
-- SP 는 SUM(QTY)=0 을 "RTF 가 원래 없었다"로 해석해 INSERT 분기로 간다(BODY L5127 IF).
-- 아래가 1건이라도 나오면 그 키에서 반드시 중복 INSERT 가 시도된다. = 원인 확정
SELECT DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
     , SUBSTR(YYYYMMDD,1,6) AS YM
     , COUNT(*) AS 행수, SUM(QTY) AS QTY합계
     , LISTAGG(DISTINCT MEASURE, ',') WITHIN GROUP (ORDER BY MEASURE) AS 메저
     , LISTAGG(DISTINCT PLANT_SITE_ID, ',') WITHIN GROUP (ORDER BY PLANT_SITE_ID) AS PLANT값
  FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID = '&P_DIV' AND VERSION_NO = '&P_VER'
   AND MEASURE IN ('RTF','RTF_SYS_RP')
 GROUP BY DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SUBSTR(YYYYMMDD,1,6)
HAVING SUM(QTY) = 0
 ORDER BY 1,2,5,6
 FETCH FIRST 30 ROWS ONLY;

PROMPT ================ §2-1. 위 조건에 해당하는 키 총 개수 ================
SELECT COUNT(*) AS "QTY합계0인_키_개수"
  FROM ( SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
          WHERE DIVISION_ID = '&P_DIV' AND VERSION_NO = '&P_VER'
            AND MEASURE IN ('RTF','RTF_SYS_RP')
          GROUP BY DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                 , SUBSTR(YYYYMMDD,1,6)
         HAVING SUM(QTY) = 0 );

PROMPT ================ §3. ⭐ 가설 B — PLANT_SITE_ID 센티널 값 분포 ================
-- AS-IS 는 '' (빈문자), TO-BE 는 '-' 를 넣는다. 실제로 어떤 값들이 공존하는지 본다.
SELECT NVL(PLANT_SITE_ID,'<NULL>') AS PLANT_SITE_ID
     , CASE WHEN PLANT_SITE_ID IS NULL THEN 'NULL'
            WHEN PLANT_SITE_ID = '-'   THEN '하이픈 센티널'
            WHEN TRIM(PLANT_SITE_ID) IS NULL THEN '공백만'
            ELSE '실제 사이트값' END AS 종류
     , COUNT(*) AS 행수
     , LISTAGG(DISTINCT MEASURE, ',') WITHIN GROUP (ORDER BY MEASURE) AS 메저
  FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID = '&P_DIV' AND VERSION_NO = '&P_VER'
 GROUP BY PLANT_SITE_ID
 ORDER BY 3 DESC FETCH FIRST 20 ROWS ONLY;

PROMPT ================ §4. ⭐ 가설 C — 이미 PK 가 중복 직전인 행 (동일 키 다건) ================
-- PK 16컬럼 중 PLANT_SITE_ID 만 다른 행이 있으면, '-' 로 통일되는 순간 충돌한다.
SELECT VERSION_NO, DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
     , FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, COMPANY_ID
     , COUNT(*) AS 행수
     , LISTAGG(NVL(PLANT_SITE_ID,'<NULL>'), ' | ')
         WITHIN GROUP (ORDER BY PLANT_SITE_ID) AS PLANT값들
  FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID = '&P_DIV' AND VERSION_NO = '&P_VER'
   AND MEASURE IN ('RTF','RTF_SYS_RP')
 GROUP BY VERSION_NO, DEPARTMENT_ID, DEPT_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, COMPANY_ID
HAVING COUNT(*) > 1
 ORDER BY 13 DESC
 FETCH FIRST 20 ROWS ONLY;

PROMPT ================ §5. PK 제약 구성 확인 (COMPO_40 / CELL_PROD_SITE 포함) ================
SELECT CC.POSITION, CC.COLUMN_NAME
  FROM ALL_CONSTRAINTS C
  JOIN ALL_CONS_COLUMNS CC
    ON C.OWNER = CC.OWNER AND C.CONSTRAINT_NAME = CC.CONSTRAINT_NAME
 WHERE C.OWNER = 'SCM_MGR' AND C.TABLE_NAME = 'DM_PLN_SALES_PLAN_REPORT_C'
   AND C.CONSTRAINT_TYPE = 'P'
 ORDER BY CC.POSITION;

PROMPT ================ §5-1. PK 구성 컬럼의 기본값·NULL 허용 ================
SELECT COLUMN_NAME, DATA_TYPE, NULLABLE, DATA_DEFAULT
  FROM ALL_TAB_COLUMNS
 WHERE OWNER='SCM_MGR' AND TABLE_NAME='DM_PLN_SALES_PLAN_REPORT_C'
   AND COLUMN_NAME IN ('PLANT_SITE_ID','COMPO_40','CELL_PROD_SITE','COMPANY_ID')
 ORDER BY COLUMN_NAME;

PROMPT ================ §6. 이 버전의 CUTOFF/DATA_TYPE 분포 (분기 조건 확인) ================
SELECT DATA_TYPE, CUTOFF_TYPE, COUNT(*) AS 행수, SUM(QTY) AS QTY합계
  FROM SCM_MGR.DM_PLN_SALES_PLAN_REPORT_C
 WHERE DIVISION_ID = '&P_DIV' AND VERSION_NO = '&P_VER'
 GROUP BY DATA_TYPE, CUTOFF_TYPE ORDER BY 1,2;

PROMPT ================ 끝 ================
--------------------------------------------------------------------------------
-- 판정 가이드
--   §2 에 행이 나오면      -> 가설 A 확정. 정정 = INSERT 에 WHERE NOT EXISTS 가드 추가
--                             (또는 분기 조건을 "행 존재 여부"로 교정)
--   §3 에 '-' 와 공백/NULL 이 섞여 있으면 -> 가설 B 가세. 센티널 정규화 필요
--   §4 에 행이 나오면      -> 가설 C 확정. PLANT_SITE_ID 만 다른 형제 행이 이미 존재
--   셋 다 0행이면          -> 다른 원인. §1 결과와 함께 회신 요망
--------------------------------------------------------------------------------
