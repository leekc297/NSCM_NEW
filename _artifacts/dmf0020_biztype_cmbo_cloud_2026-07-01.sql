-- =====================================================================================
-- DMF0020 조회조건/그리드 Biz.Type 콤보 — SCM_ADM_CMBO_SQL_M 'BizType' 1건 클라우드 이관
--   증상 : 클라우드에서 조회조건 BIZ.TYPE 콤보 옵션이 비어 보임(콤보 미표시)
--   원인 : 클라우드 SCM_ADM_CMBO_SQL_M 에 SQL_ID='BizType' 행 누락 → admin/combo 가 옵션 0건 반환
--   소스 : 사내 OCGSCMD_P01 의 실제 행 값 그대로 (2026-07-01 추출, 권위 소스)
--   의존 : SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE='DM_BIZ_TYPE') 은 클라우드에 이미 존재(사용자 확인) → 이관 제외
--   멱등 : NOT EXISTS (재실행 안전). DBeaver/SQL*Plus 공통 (SET / '/' / EXIT 미사용)
--   NOT NULL 전수 반영: SQL_ID, MDU_DIVS_CD, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
-- =====================================================================================

INSERT INTO SCM_ADM_CMBO_SQL_M (
  SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT
  'BizType',
  'CM',
  'Biz Type (BIZ_TYPE_NAME for combo)',
  'SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''DM_BIZ_TYPE''',
  'Y',
  'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'BizType'
);

COMMIT;

-- 검증 (1건 조회되어야 함)
SELECT SQL_ID, MDU_DIVS_CD, USE_YN, SQL_DTL_CTN
FROM   SCM_ADM_CMBO_SQL_M
WHERE  SQL_ID = 'BizType';
