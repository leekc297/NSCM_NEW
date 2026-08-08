-- ====================================================================================
-- DMF0082 UP_FX 정합 — CMBO 'DefaultBucketDay' 신규 등록 (2026-08-08)
--
-- 배경: AS-IS 는 행 BUCKET 이 비었거나 '0000000' 일 때 마스터 lookup `DEFAULT_BUCKET_DAY`
--       (SEGMENT1=division × SEGMENT2=MONTHLY|WEEKLY → SEGMENT3=요일)를
--       `UP_FX_GetCommonDataList @Code='DefaultBucketDay'` 로 조회해 기본 배분요일로 쓴다(.cs L1773).
--       TO-BE FE 는 이를 상수(40=MON / 그 외=FRI)로 박아 두어 마스터 변경·division 추가에 반응하지
--       못했다 → AS-IS 동일 코드명으로 CMBO 등록(hook #117 §5 — 동일 코드 재사용 원칙).
--
-- AS-IS SP 원문(1:1 이식):
--   SELECT L.SEGMENT3 AS DEFAULTBUCKETDAY
--   FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
--   WHERE  L.LOOKUP_TYPE='DEFAULT_BUCKET_DAY' AND L.VALID_YN='Y'
--   AND    L.SEGMENT1 = @Param1
--   AND    L.SEGMENT2 = CASE WHEN @Param2='DAILY' THEN 'MONTHLY' ELSE @Param2 END
--
-- TO-BE 차이(의도적):
--   · 반환 컬럼을 콤보 규약(CODE/NAME)으로 맞춤 — 값 자체는 SEGMENT3 동일.
--   · @Param2 는 TO-BE FE 의 bucketType 리터럴('D'/'W'/'M')로 오므로 AS-IS 어휘와 함께 매핑:
--     D|DAILY → MONTHLY (AS-IS 의 DAILY→MONTHLY 규약 승계) / M|MONTHLY → MONTHLY / 그 외 → WEEKLY.
--
-- 멱등: NOT EXISTS 가드. 공유 CMBO 본문 무수정(신규 SQL_ID 만 추가) → 타 화면 회귀 0.
-- 원복: DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='DefaultBucketDay';
-- ====================================================================================

INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DefaultBucketDay', 'DM',
       'DMF0082 기본 배분요일 (AS-IS UP_FX_GetCommonDataList @Code=DefaultBucketDay 1:1)',
       'SELECT L.SEGMENT3 AS CODE, L.SEGMENT3 AS NAME '
    || 'FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L '
    || 'WHERE L.LOOKUP_TYPE = ''DEFAULT_BUCKET_DAY'' AND L.VALID_YN = ''Y'' '
    || 'AND L.SEGMENT1 = @divisionId '
    || 'AND L.SEGMENT2 = CASE WHEN @bucketType IN (''D'',''DAILY'',''M'',''MONTHLY'') '
    || 'THEN ''MONTHLY'' ELSE ''WEEKLY'' END',
       'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DefaultBucketDay');

COMMIT;
