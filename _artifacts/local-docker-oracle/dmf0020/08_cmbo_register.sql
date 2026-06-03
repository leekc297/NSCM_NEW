-- =====================================================================================
-- DMF0020 combo SQL_ID 등록 — CustomsHandbook / FcstType
-- AS-IS LOOKUP_TYPE: BP_CUSTOMS_HANDBOOK (6 rows) / BP_FCST_TYPE (25 rows)
-- BE syntax: @divisionId / @sesUserId / @mnuId / @langCd (자동 채움)
-- 멱등 — 재실행 안전 (DELETE+INSERT)
-- =====================================================================================
WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;

DELETE FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('CustomsHandbook','FcstType');

INSERT INTO SCM_ADM_CMBO_SQL_M (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (
  'CustomsHandbook', 'ALL', 'Customs Handbook 조회',
  'SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''BP_CUSTOMS_HANDBOOK'' AND VALID_YN = ''Y'' AND SEGMENT1 = @divisionId ORDER BY DISPLAY_SEQ',
  'Y', 'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
);

INSERT INTO SCM_ADM_CMBO_SQL_M (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (
  'FcstType', 'ALL', 'FCST Type 조회',
  'SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''BP_FCST_TYPE'' AND VALID_YN = ''Y'' AND SEGMENT1 = @divisionId ORDER BY DISPLAY_SEQ',
  'Y', 'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
);

COMMIT;

SELECT SQL_ID, USE_YN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('CustomsHandbook','FcstType') ORDER BY 1;
EXIT;
