-- ============================================================================
-- DMF0042 클라우드 이관 (2026-08-10 06:38) — 90 VERIFY (AUTHUNION 증분)
--   ⚠️ QA·DEV **2 DB 각각** 실행. 전 항목 기대값 일치해야 완료.
-- ============================================================================
SET LINESIZE 200
SET PAGESIZE 100

PROMPT ===== [1] PKG_DMF0042 컴파일 상태 (기대: PACKAGE VALID / PACKAGE BODY VALID)
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0042'
 ORDER BY OBJECT_TYPE;

PROMPT ===== [2] 컴파일 에러 (기대 0행)
SELECT LINE, POSITION, TEXT
  FROM ALL_ERRORS
 WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0042'
 ORDER BY SEQUENCE;

PROMPT ===== [3] AUTHUNION 적용 (기대: MARKER=1 · UNION_PRED=1 · BODY_LINES=6,600)
SELECT SUM(CASE WHEN INSTR(TEXT,'AUTHUNION 2026-08-09') > 0 THEN 1 ELSE 0 END)   AS MARKER,
       SUM(CASE WHEN INSTR(TEXT,'SCM_ADM_USER_GR_MPG_M') > 0 THEN 1 ELSE 0 END)  AS UNION_PRED,
       COUNT(*)                                                                   AS BODY_LINES
  FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0042' AND TYPE = 'PACKAGE BODY';

PROMPT ===== [4] 판정식 원문 육안 확인 (보유그룹 합집합)
SELECT LINE, RTRIM(TEXT) TEXT
  FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0042' AND TYPE = 'PACKAGE BODY'
   AND (INSTR(TEXT,'GET_ADMIN_GROUP') > 0 OR INSTR(TEXT,'SCM_ADM_USER_GR_MPG_M') > 0)
 ORDER BY LINE;
-- 기대 형태: `SEGMENT1 = <FE 전달값>  OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M G
--            WHERE G.USER_ID IN (…) AND G.USE_YN = 'Y')`
-- ⭐ 정책: 편집 권한은 **사용자가 보유한 그룹의 합집합**으로 판정한다(2026-08-04 사용자 확정, AUTHUNION).
--    FE 가 그룹명 대신 USER_ID 를 넘기는 화면도 이 확장으로 정상 판정된다.

PROMPT ===== [5] 과권한 회귀 점검 (적용 전/후 동일해야 함 — 사내 실측 기준)
--   사내 2026-08-09 실측: ADMIN 유지 · bpark416(USER_ID 직전달) 0→1 해소 ·
--   DM Planner (W/S) / Viewer 계정 0→0 (**과권한 0**).
--   클라우드에서도 대표 계정 3종(관리자·W/S·Viewer)으로 동일 결과인지 확인할 것.
