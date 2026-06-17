-- Issue 1: SCM_ADM_CMBO_SQL_M SQL_ID='BizType' 의 'ALL' UNION 제거
--   CustomDropdown allOption 이 자동 'Select All' 추가 → 중복.
--   FE 가 자동 추가, BE 는 lookup raw 만 반환 의무.

UPDATE SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN     = 'SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''DM_BIZ_TYPE''',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE= SYSDATE
 WHERE SQL_ID = 'BizType';

COMMIT;
