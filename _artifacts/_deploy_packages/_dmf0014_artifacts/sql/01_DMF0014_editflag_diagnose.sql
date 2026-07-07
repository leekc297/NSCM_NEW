-- ============================================================================
-- DMF0014 동적 컬럼 편집 불가 진단 (클라우드 DB 에서 실행)
--   편집 가부 = PKG_DMF0014 의 EDIT_FLAG:
--     EDIT_FLAG = 'Y'  ⟺  (V_GROUP_ID='ADMIN')  OR  FN_GET_DEPT_LIST(사용자, ITM.DEPT_ID)='Y'
--     V_GROUP_ID='ADMIN'  ⟺  SCM_ADM_LOOKUP_MASTER_DETAIL 에
--                            (LOOKUP_TYPE='GET_ADMIN_GROUP', SEGMENT1=사용자, SEGMENT2='ALL', VALID_YN='Y') 존재
--   ⚠️ 아래 :USER_ID 를 클라우드 로그인 USER_ID 로 치환 후 실행.
-- ============================================================================

-- [1] 로그인 사용자 ADMIN(GET_ADMIN_GROUP) 등록 여부  (0 행 = ADMIN 아님 = 편집 불가 원인)
SELECT 'ADMIN_REG' AS CHK, SEGMENT1, SEGMENT2, VALID_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
   AND SEGMENT1 = 'CLOUD_USER_ID_HERE';   -- ← 클라우드 로그인 USER_ID 로 치환

-- [2] SP EDIT_FLAG 계산식 버전 (2026-04-01 'ITM.DEPT_ID' 반영본인지 — 미반영 시 SP 배포 필요)
SELECT 'SP_VER' AS CHK, LINE, TEXT
  FROM ALL_SOURCE
 WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE BODY'
   AND UPPER(TEXT) LIKE '%FN_GET_DEPT_LIST%' AND UPPER(TEXT) LIKE '%ITM.DEPT_ID%'
 ORDER BY LINE;

-- [3] 사용자의 81 division Team 권한 (참고 — ADMIN 이 아니면 이 권한으로만 편집 가능)
SELECT 'TEAM_AUTH' AS CHK, DEPT_ID,
       FN_GET_DEPT_LIST('CLOUD_USER_ID_HERE', DEPT_ID) AS HAS_AUTH   -- ← USER_ID 치환
  FROM (SELECT DISTINCT DEPT_ID FROM SCM_MST_SITE_ITEM
         WHERE DIVISION_ID LIKE '81%' AND DEPT_ID IS NOT NULL AND ROWNUM <= 10);
