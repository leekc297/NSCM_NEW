-- ============================================================================
-- 93 편집 불가 원인 점검 — 클라우드 DMF0042 (2026-08-06)
--   사내 편집 가능 확정 경로(실측): 조회 SP EDIT_FLAG =
--     CASE WHEN (행 DEPT_ID = v_dept_id) THEN 'Y'
--          WHEN v_group_id = 'ADMIN'     THEN 'Y' ELSE 'N' END
--   ① v_group_id: LOOKUP 'GET_ADMIN_GROUP' 에 SEGMENT1=p_userinfo(호출값 'ADMIN')
--      + SEGMENT2='ALL' + VALID_YN='Y' 행 존재 → 'ADMIN' (사내는 이 경로로 전행 Y)
--   ② v_dept_id: TB_FX_User.DEPT_ID(사내 minyonglee1='LESIC') → PM_TEAM_MAPPING 변환(사내 매핑 없음)
--   ⚠ 이 lookup/사용자 마스터는 이관 패키지 "기존재 전제"(README §5) — 클라우드 결측이 유력 원인.
--   실행: 클라우드 SCM_MGR (QA·DEV 각각)
-- ============================================================================

-- [A] GET_ADMIN_GROUP lookup (사내 9행 — 반드시 ('ADMIN','ALL','Y') 포함이 편집 가능 조건)
SELECT SEGMENT1, SEGMENT2, SEGMENT3, VALID_YN
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
ORDER  BY SEGMENT1, SEGMENT2;

-- [B] SP 판정식 그대로 시뮬 (기대: 1 이상 = v_group_id 'ADMIN' 성립)
SELECT COUNT(1) AS ADMIN_MATCH
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
  AND  VALID_YN = 'Y'
  AND  SEGMENT2 = 'ALL'
  AND  SEGMENT1 = 'ADMIN';   -- 화면 호출의 p_userinfo 실값 (91 [0-1] SQL_HEAD 14번째 인자)

-- [C] 사용자 dept (사내: minyonglee1 = 'LESIC' / PM_TEAM_MAPPING 매핑 없음)
SELECT UserID, DEPT_ID FROM SCM_MGR.TB_FX_User WHERE UserID = 'minyonglee1';

SELECT SEGMENT1, SEGMENT3, VALID_YN
FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE  LOOKUP_TYPE = 'PM_TEAM_MAPPING' AND VALID_YN = 'Y'
  AND  SEGMENT1 = (SELECT DEPT_ID FROM SCM_MGR.TB_FX_User WHERE UserID='minyonglee1');

-- ============================================================================
-- [D] ⭐ 08-06 BODY 패치 적용 여부 (기대: 8 — 0 이면 sp/02 최신본 미적용이 편집 불가의 원인)
--   클라우드 93 실측(08-06): [A]9행/[B]1/[C]LESIC 전부 사내와 동일 = lookup 무죄.
--   진짜 원인 = 92 [B]의 branch① 21행 — DEFAULT_FLAG '-' 변형으로 MEASURE 와 함께
--   **EDIT_FLAG 도 SELECT 조립에서 탈락** → FE editLock R1(row.EDIT_FLAG=='Y' 만 개방)이
--   undefined 를 '' 로 보고 전행 잠금. 08-06 관용화 패치(RTRIM(x,' -') IS NULL)가
--   EDIT_FLAG/MEASURE 를 다시 포함시키므로 sp/02 재실행로 해소.
-- ============================================================================
SELECT COUNT(*) AS PATCH_MARKS
FROM   ALL_SOURCE
WHERE  OWNER='SCM_MGR' AND NAME='PKG_DMF0042' AND TYPE='PACKAGE BODY'
  AND  TEXT LIKE '%E20260806%';

-- ============================================================================
-- [조치-lookup] [B]=0 인 경우에만 — 사내 GET_ADMIN_GROUP 파리티 (핵심 'ADMIN' 행.
--   나머지 8행도 필요 시 사내 [A] 결과 기준으로 동일 패턴 추가. 감사컬럼 'admin' 표준)
-- ============================================================================
--   (컬럼 구성 = 사내 'ADMIN' 행 실값 그대로. SEGMENT1~5·VALID_YN·감사일자 = NOT NULL 실측)
-- INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
-- ( LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN,
--   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
-- SELECT 'GET_ADMIN_GROUP', 'ADMIN', 'ALL', '-', '-', '-', 1, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
-- FROM DUAL
-- WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
--                   WHERE X.LOOKUP_TYPE='GET_ADMIN_GROUP' AND X.SEGMENT1='ADMIN' AND X.SEGMENT2='ALL');
-- COMMIT;
