-- =====================================================================
-- 공유 콤보 등록/교정 — PlantSitebyEndCustomer (클라우드) · 2026-07-10
-- DMF0020/DMF0014/DMF0074 Plant Site 조회조건 공용. 사내(SCM_MGR@OCGSCMD_P01) 정본 1:1.
-- 증상: 클라우드에서 Plant Site 가 81 division 기준 조회 안 됨 = 콤보 미등록 or 구버전.
-- 멱등 MERGE (재실행 안전). DBeaver/SQLcl 호환.
-- =====================================================================

-- ── [1] 진단 (적용 전 실행 — 현재 상태 확인) ──────────────────────────
-- (a) 콤보 존재 여부
SELECT 'EXISTS?' CHK, COUNT(*) CNT FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'PlantSitebyEndCustomer';
-- (b) 현재 SQL 본문 (바인드 @divisionId/@endCustomer 포함 여부 · SITE_TYPE='PLANT' 여부 확인)
SELECT SQL_ID, MDU_DIVS_CD, USE_YN, SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'PlantSitebyEndCustomer';
-- (c) 81 division 실 데이터 존재 확인 (SCM_MST_SITE SITE_TYPE='PLANT' AND DIVISION_ID 81 계열)
SELECT COUNT(*) PLANT_81 FROM SCM_MGR.SCM_MST_SITE
 WHERE SITE_TYPE = 'PLANT' AND INSTR(',' || '81,81_UC,81_HM,81_ST,81_HD,81_HG' || ',', ',' || DIVISION_ID || ',') > 0;
-- (d) SCM_MST_SITE 에 END_CUSTOMER 컬럼 존재 (콤보 SQL 이 참조)
SELECT COUNT(*) HAS_END_CUSTOMER_COL FROM ALL_TAB_COLUMNS
 WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = 'SCM_MST_SITE' AND COLUMN_NAME = 'END_CUSTOMER';

-- ── [2] 등록/교정 (멱등 MERGE — 사내 정본 SQL 로 통일) ────────────────
MERGE INTO SCM_ADM_CMBO_SQL_M t
USING (
  SELECT 'PlantSitebyEndCustomer' SQL_ID, 'DM' MDU_DIVS_CD, 'Plant Site by Division+EndCustomer' SQL_NM,
         q'[SELECT DISTINCT A.SCM_SITE_ID AS CODE, A.SCM_SITE_ID AS NAME FROM SCM_MGR.SCM_MST_SITE A WHERE A.SITE_TYPE = 'PLANT' AND (NVL(TRIM(@divisionId), 'ALL') = 'ALL' OR INSTR(',' || @divisionId || ',', ',' || A.DIVISION_ID || ',') > 0) AND (NVL(TRIM(@endCustomer), 'ALL') = 'ALL' OR INSTR(',' || @endCustomer || ',', ',' || A.END_CUSTOMER || ',') > 0) ORDER BY CODE]' SQL_DTL_CTN
  FROM DUAL
) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET
  t.MDU_DIVS_CD = s.MDU_DIVS_CD, t.SQL_NM = s.SQL_NM, t.SQL_DTL_CTN = s.SQL_DTL_CTN, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.SQL_ID, s.MDU_DIVS_CD, s.SQL_NM, s.SQL_DTL_CTN, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- ── [3] 검증 (적용 후 — 81 division 조회 시 행 반환) ────────────────
-- 콤보 SQL 을 @divisionId='81', @endCustomer='ALL' 로 치환 실행 (BE makeComboQuery 재현)
SELECT COUNT(*) CNT_DIV81 FROM (
  SELECT DISTINCT A.SCM_SITE_ID AS CODE, A.SCM_SITE_ID AS NAME FROM SCM_MGR.SCM_MST_SITE A
   WHERE A.SITE_TYPE = 'PLANT'
     AND (NVL(TRIM('81'), 'ALL') = 'ALL' OR INSTR(',' || '81' || ',', ',' || A.DIVISION_ID || ',') > 0)
     AND (NVL(TRIM('ALL'), 'ALL') = 'ALL' OR INSTR(',' || 'ALL' || ',', ',' || A.END_CUSTOMER || ',') > 0)
);
-- 기대: CNT_DIV81 > 0 (사내 = 28). 0 이면 클라우드 SCM_MST_SITE 데이터/컬럼 확인 필요.
