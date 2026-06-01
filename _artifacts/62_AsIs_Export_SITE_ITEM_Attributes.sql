--==============================================================================
-- 62_AsIs_Export_SITE_ITEM_Attributes.sql
--
-- 목적: As-Is 시스템 (LGCE_SCMDEV / MSSQL or Oracle) 에서 SCM_MST_SITE_ITEM 의
--       ATTRIBUTE1/ATTRIBUTE2 컬럼 데이터를 추출하여 로컬 Docker Oracle 에 import.
--
-- 사고: 2026-05-26 CSV export (SCM_MST_SITE_ITEM_202605261658.csv) 의 ATTRIBUTE1/2
--       컬럼이 전체 109,126 rows 모두 빈값으로 export 됨 (export 누락).
--       → 로컬 DMF0043 화면 LEFT JOIN 매칭 0건 → grid 빈 결과.
--
-- 실행 환경: As-Is DB (사용자가 직접 접근 가능한 환경)
-- 출력 형식: CSV (탭/콤마 구분), 또는 SQL*Plus spool, 또는 결과창 복사
--==============================================================================

-- BLOCK 1 : 사전 진단 — ATTRIBUTE1/2 가 As-Is 에 실제로 데이터가 있는지 확인
PROMPT === BLOCK 1 : 사전 진단 ===
SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT(ATTRIBUTE1) AS A1_NON_NULL,
    COUNT(ATTRIBUTE2) AS A2_NON_NULL,
    COUNT(CASE WHEN TRIM(ATTRIBUTE1) IS NOT NULL THEN 1 END) AS A1_NON_EMPTY,
    COUNT(CASE WHEN TRIM(ATTRIBUTE2) IS NOT NULL THEN 1 END) AS A2_NON_EMPTY
FROM SCM_MST_SITE_ITEM
WHERE DIVISION_ID = '40';
--
-- 기대치: A1_NON_EMPTY > 0, A2_NON_EMPTY > 0
-- 만약 As-Is 도 빈값이면, ATTRIBUTE1/2 는 다른 컬럼/테이블에 있는 것.
--   → 같이 확인할 후보: REPORT_GROUP1/2/3, CUST_GROUP, CUST_GROUP_DTL, OWNER_GROUP 등


-- BLOCK 2 : DMF0043 화면이 사용하는 데이터만 추출 (DIV=40 + REP_YN/VALID_YN 등 정상 데이터)
--   3개 컬럼 (DIVISION_ID, SCM_SITE_ID, ITEM_ID) = SCM_MST_SITE_ITEM PK
--   + 가져올 컬럼 (ATTRIBUTE1, ATTRIBUTE2)
--
-- DBeaver / SQL Developer 에서 본 쿼리 실행 후 결과 전체를 CSV 로 export
-- ── (헤더 포함 / 콤마 구분 / 한글은 UTF-8) ──
PROMPT === BLOCK 2 : Export 쿼리 ===
SELECT
    DIVISION_ID,
    SCM_SITE_ID,
    ITEM_ID,
    ATTRIBUTE1,                 -- SOLDTO_CUST_REPORT
    ATTRIBUTE2                  -- END_CUST_REPORT
FROM SCM_MST_SITE_ITEM
WHERE DIVISION_ID = '40'
  AND VALID_YN = 'Y'
  AND (ATTRIBUTE1 IS NOT NULL OR ATTRIBUTE2 IS NOT NULL);


-- BLOCK 3 (대안) : INSERT 문 형태로 export — DBeaver / SQL Developer 의 "Export Result Set as SQL Insert" 사용
--   결과를 텍스트로 저장하여 본 프로젝트에 첨부.
--
-- 저장 위치 권장: C:\TRANFILE\DB\DATA\SCM_MST_SITE_ITEM_ATTR_FIX_YYYYMMDDHHMI.csv
--                또는       C:\Projects\NSCM\_artifacts\62_AsIs_SITE_ITEM_attr_data.sql
--==============================================================================
