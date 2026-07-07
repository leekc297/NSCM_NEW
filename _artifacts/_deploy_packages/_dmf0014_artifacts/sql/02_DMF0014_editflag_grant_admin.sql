-- ============================================================================
-- DMF0014 동적 컬럼 편집 가능 — 클라우드 로그인 사용자를 ADMIN(GET_ADMIN_GROUP)으로 등록
--   (로컬 DB 의 minyonglee1 과 동일 설정 → V_GROUP_ID='ADMIN' → 전체 행 EDIT_FLAG='Y' → 편집 가능)
--   ⚠️ 'CLOUD_USER_ID_HERE' 를 클라우드 로그인 USER_ID 로 치환 후 실행.
--   ⚠️ ADMIN 등록은 "전체 편집 허용" 광범위 권한(로컬/테스트 편의). 운영에서 Team 단위 제어가 필요하면
--      이 대신 해당 사용자에게 81 Team(DEPT_ID) 권한을 부여(SCM_ADM_USER_GR_UNIT_AUTH_MPG_M 등)하세요.
--   멱등: 이미 등록돼 있으면 0 rows (NOT EXISTS 가드).
-- ============================================================================
INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, VALID_YN, CREATION_DATE, LAST_UPDATE_DATE)
SELECT 'GET_ADMIN_GROUP', 'CLOUD_USER_ID_HERE', 'ALL', '-', '-', '-', 'Y', SYSDATE, SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' AND SEGMENT1 = 'CLOUD_USER_ID_HERE'
 );
COMMIT;

-- 검증 (1 행 = 등록 완료)
SELECT SEGMENT1, SEGMENT2, VALID_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' AND SEGMENT1 = 'CLOUD_USER_ID_HERE';
