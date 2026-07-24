-- =====================================================================
-- DMF0042 P5 — CMBO_SQL_M 등록: BizPlanUserAuthGroup (P_USERINFO 권한 그룹 해석) (2026-07-15)
-- 배경 (플랜 §D 실측): DMF0042 조회 SP 의 P_USERINFO 사용처 = lookup GET_ADMIN_GROUP
--   (SEGMENT2='ALL', SEGMENT1=그룹명 → v_group_id='ADMIN' 해석 — GET_ADMIN_GROUP_MEASURE 아님.
--   SEGMENT2='ALL' VALID 6행 실측 2026-07-15). TO-BE 세션 그룹 부재(session.groupId 유령 필드)
--   → DMF0021 'SalesPlanUserAuthGroup' 선례와 동일하게 보유그룹 × lookup 교집합 콤보 신설.
-- 파라미터: @sesUserId (BE getCombo 세션 치환 — CMBO 'TeambyDivision' 선례)
-- Owner 조회조건: MODAL(DM0020) 팝업이므로 CMBO 불필요 판정 (체크포인트 확정)
-- =====================================================================
MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (
  SELECT 'BizPlanUserAuthGroup' SQL_ID, 'DM' MDU_DIVS_CD,
         'DMF0042 P_USERINFO 권한 그룹 (보유그룹 × GET_ADMIN_GROUP(ALL) 교집합)' SQL_NM,
'SELECT M.USER_GR_ID AS CODE, M.USER_GR_ID AS NAME
FROM SCM_ADM_USER_GR_MPG_M M
WHERE M.USER_ID = @sesUserId
  AND M.USE_YN = ''Y''
  AND EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
              WHERE L.LOOKUP_TYPE = ''GET_ADMIN_GROUP'' AND L.VALID_YN = ''Y''
                AND L.SEGMENT1 = M.USER_GR_ID AND L.SEGMENT2 = ''ALL'')
ORDER BY DECODE(M.USER_GR_ID, ''ADMIN'', 1, 2), M.USER_GR_ID' SQL_DTL_CTN
  FROM DUAL
) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET t.MDU_DIVS_CD = s.MDU_DIVS_CD, t.SQL_NM = s.SQL_NM,
  t.SQL_DTL_CTN = s.SQL_DTL_CTN, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.SQL_ID, s.MDU_DIVS_CD, s.SQL_NM, s.SQL_DTL_CTN, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ── ② CMBO 'BucketType2' — DMF0042 Bucket(M/Q/Y) 콤보 (AS-IS GetLookupData BUCKET2_TYPE_CODE 1:1.
--    기존 'BucketType'(D/W/M — BUCKET_TYPE_CODE)과 별개 축. lookup 실측: MONTHLY/QUARTERLY/YEARLY 3행 VALID) ──
MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (
  SELECT 'BucketType2' SQL_ID, 'DM' MDU_DIVS_CD,
         'Bucket 유형 2 (M, Q, Y — DMF0042 Business Plan)' SQL_NM,
'SELECT SEGMENT1  AS CODE
      , SEGMENT2  AS NAME
FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  1 = 1
AND    LOOKUP_TYPE = ''BUCKET2_TYPE_CODE''
AND    VALID_YN = ''Y''
ORDER BY DISPLAY_SEQ' SQL_DTL_CTN
  FROM DUAL
) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET t.MDU_DIVS_CD = s.MDU_DIVS_CD, t.SQL_NM = s.SQL_NM,
  t.SQL_DTL_CTN = s.SQL_DTL_CTN, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.SQL_ID, s.MDU_DIVS_CD, s.SQL_NM, s.SQL_DTL_CTN, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 검증: 등록 2건 + minyonglee1 치환 스모크 (기대: ADMIN 1행 선두 / Bucket2 3행)
SELECT SQL_ID, USE_YN, LENGTH(SQL_DTL_CTN) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE SQL_ID IN ('BizPlanUserAuthGroup', 'BucketType2');

-- 원복: DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('BizPlanUserAuthGroup','BucketType2'); COMMIT;
