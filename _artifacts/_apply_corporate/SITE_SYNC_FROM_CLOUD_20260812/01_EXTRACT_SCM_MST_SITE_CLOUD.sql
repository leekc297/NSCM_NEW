-- 01_EXTRACT_SCM_MST_SITE_CLOUD.sql — 클라우드에서 실행: SCM_MST_SITE 전 행·전 39컬럼 추출 (2026-08-12)
-- 실행법(클라우드 sqlplus):
--   sqlplus 접속 후  @01_EXTRACT_SCM_MST_SITE_CLOUD.sql
--   → 현재 디렉터리에 scm_mst_site_cloud.dat 생성. 그 파일을 로컬로 가져와 02_load_scm_mst_site.py 로 적재.
-- 형식: 구분자 '|@|' / DATE=YYYYMMDDHH24MISS / NULL=빈값 / 줄바꿈·CR 은 \n \r 로 이스케이프(적재기가 복원)
SET PAGESIZE 0
SET LINESIZE 32767
SET LONG 100000
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET HEADING OFF
SET ECHO OFF
SET TERMOUT OFF
SET VERIFY OFF
SPOOL scm_mst_site_cloud.dat

SELECT DIVISION_ID
  || '|@|' || SCM_SITE_ID
  || '|@|' || NVL(PLANT_ID,'')
  || '|@|' || NVL(OPERATION_GROUP,'')
  || '|@|' || REPLACE(REPLACE(NVL(SITE_DESCRIPTION,''), CHR(13), '\r'), CHR(10), '\n')
  || '|@|' || NVL(SITE_TYPE,'')
  || '|@|' || NVL(CITY,'')
  || '|@|' || NVL(COUNTRY,'')
  || '|@|' || NVL(VMI_YN,'')
  || '|@|' || NVL(VALID_YN,'')
  || '|@|' || NVL(NEW_YN,'')
  || '|@|' || NVL(SITE_HRCY_ID,'')
  || '|@|' || NVL(OSP_YN,'')
  || '|@|' || NVL(TO_CHAR(SHIP_FROZEN),'')
  || '|@|' || NVL(TO_CHAR(PROD_FROZEN),'')
  || '|@|' || NVL(END_CUSTOMER,'')
  || '|@|' || NVL(SOLDTO_CUSTOMER,'')
  || '|@|' || NVL(TO_CHAR(FP_PLAN_PERIOD),'')
  || '|@|' || NVL(TO_CHAR(BUILD_AHEAD),'')
  || '|@|' || NVL(LOGISTIC_PLANT_ID,'')
  || '|@|' || NVL(PACKER_ITEM_ID_SUFFIX,'')
  || '|@|' || NVL(HQ_VENDOR_CODE,'')
  || '|@|' || NVL(COMPANY_ID,'')
  || '|@|' || NVL(SITE_ID,'')
  || '|@|' || NVL(CREATED_BY,'')
  || '|@|' || NVL(TO_CHAR(CREATION_DATE,'YYYYMMDDHH24MISS'),'')
  || '|@|' || NVL(LAST_UPDATED_BY,'')
  || '|@|' || NVL(TO_CHAR(LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'')
  || '|@|' || NVL(ATTRIBUTE1,'')
  || '|@|' || NVL(ATTRIBUTE2,'')
  || '|@|' || NVL(ATTRIBUTE3,'')
  || '|@|' || NVL(ATTRIBUTE4,'')
  || '|@|' || NVL(ATTRIBUTE5,'')
  || '|@|' || NVL(ATTRIBUTE6,'')
  || '|@|' || NVL(ATTRIBUTE7,'')
  || '|@|' || NVL(ATTRIBUTE8,'')
  || '|@|' || NVL(ATTRIBUTE9,'')
  || '|@|' || NVL(ATTRIBUTE10,'')
  || '|@|' || NVL(DEPT_ID,'')
FROM SCM_MGR.SCM_MST_SITE
ORDER BY DIVISION_ID, SCM_SITE_ID;

SPOOL OFF
SET TERMOUT ON
-- 참고 요약(화면 출력): 행수와 DEPT_ID 보유 수
SELECT COUNT(*) AS TOTAL_ROWS, COUNT(DEPT_ID) AS DEPT_FILLED,
       SUM(CASE WHEN SITE_TYPE='SALES' AND DIVISION_ID='81' AND DEPT_ID IS NOT NULL THEN 1 ELSE 0 END) AS SALES_81_DEPT
  FROM SCM_MGR.SCM_MST_SITE;
