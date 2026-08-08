-- ============================================================================
-- 95 편집 불가 원인 조치 — LOOKUP 'DM_LONG_PLAN' 편집 유효구간 (2026-08-06)
--   94 재현 확정: 클라우드 EDIT_FLAG 전행 Y(권한 정상)인데 CURSOR2 유효구간이
--   202601~202601 (사내 202101~203112) → Monthly 게이트(R4')가 div40 에서 구간 밖
--   M_ 컬럼 전부 잠금 → "조회는 되고 편집만 불가".
--   원천 = LOOKUP 'DM_LONG_PLAN' SEGMENT1='40' SEGMENT2='Biz Plan' 의 ATTRIBUTE1/2.
--   사내 실값(2026-08-06 실측): 202101 / 203112, VALID_YN='Y' (운영자 jssbae 2025-06-24 설정).
--   실행: 클라우드 SCM_MGR, QA·DEV 각각.
-- ============================================================================

-- [1] 현재 값 확인 (예상: ATTRIBUTE1=202601, ATTRIBUTE2=202601)
SELECT SEGMENT1, SEGMENT2, ATTRIBUTE1, ATTRIBUTE2, VALID_YN,
       TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD') AS UPD, LAST_UPDATED_BY
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'DM_LONG_PLAN'
ORDER  BY SEGMENT1, SEGMENT2;

-- [2] 조치 — 사내 파리티(202101~203112)로 UPDATE (⚠ 운영 설정값 — 실행 전 값 확정 필요.
--     이 구간은 40 사업부 Biz Plan 편집 허용 기간이므로 운영 의도에 맞는 값으로 조정 가능)
UPDATE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
   SET ATTRIBUTE1 = '202101'
     , ATTRIBUTE2 = '203112'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE LOOKUP_TYPE = 'DM_LONG_PLAN'
   AND SEGMENT1 = '40'
   AND SEGMENT2 = 'Biz Plan'
   AND VALID_YN = 'Y'
   AND NOT (ATTRIBUTE1 = '202101' AND ATTRIBUTE2 = '203112');   -- 멱등

COMMIT;

-- [3] 검증 — 94 블록 재실행 시 CURSOR2: VALID_YN=Y 202101~203112 기대.
--     화면은 재조회(Search)만으로 편집 개방 (조회 SP 커서2가 매 조회 갱신).
