-- ====================================================================================================
-- DMF0074 템플릿 0건 — 후속 진단 v3: "예외 원문" 추출 (v2 판독 결과 반영)
--
-- v2 클라우드 결과 판독 (2026-08-25):
--   D0  BODY 최신 세대(MRFPARITY=1, 08-23 21:41 적용)  → 구세대 BODY 가설 기각
--   D1b 최신 버전 SP_W_20260821_V001 원장 8,346/7,165  → 버전-원장 불일치 가설 기각
--   D4  조인 체인 통과 후 생존 7,207행                  → 쿼리 로직상 0건 아님
--   D5  ★ 16:14/16:16/16:18 호출 5회 전부 START 직후 ERROR/EXCEPTION ★
--   = SP 가 데이터를 못 찾는 게 아니라 "실행 중 예외로 죽고" 있고,
--     FE 는 에러 커서를 0건으로 오표시("다운로드할 템플릿 대상 데이터가 없습니다")하는 것.
--
-- 이 스크립트 = 그 예외의 ORA 코드·메시지·발생 라인(BACKTRACE)을 뽑는다. 전부 SELECT.
-- ====================================================================================================

SET LINESIZE 250 PAGESIZE 200 LONG 100000

PROMPT ===== E1. SP 자체 로그 — ERROR 행의 에러 원문 (SQL_ERR_CODE / SQL_ERR_MSG / SQL_BACKTRACE) =====
PROMPT ===== SQL_BACKTRACE 의 "line NNNN" 이 BODY 실패 라인 — 이 결과가 원인 확정 =====
SELECT * FROM (
  SELECT TO_CHAR(EVENT_DATE,'MM-DD HH24:MI:SS') AS T,
         SQL_ERR_CODE, SQL_ERR_MSG, SQL_BACKTRACE, IN_PARA_DATA
  FROM   SCM_MGR.SCM_SYS_LOG_BATCH
  WHERE  PROGRAM_NAME LIKE '%METAL_LINK_TEMPLATE%'
    AND  LOG_TYPE = 'ERROR'
    AND  EVENT_DATE >= TRUNC(SYSDATE) - 3
  ORDER BY EVENT_DATE DESC)
WHERE ROWNUM <= 5;

PROMPT ===== E2. (교차확인) BE 측 로그 — SCM_COM_SQL_LOG 의 EXCEPTION (SP 는 RAISE_APPLICATION_ERROR -20001 로 전체 원문을 올린다) =====
SELECT * FROM (
  SELECT TO_CHAR(EXECUTE_TIME,'MM-DD HH24:MI:SS') AS T, SQL_ID,
         DBMS_LOB.SUBSTR(EXCEPTION, 3000, 1) AS EXCEPTION_TEXT
  FROM   SCM_MGR.SCM_COM_SQL_LOG
  WHERE  EXECUTE_TIME >= SYSDATE - 3
    AND  UPPER(SQL_ID) LIKE '%DMF0074%'
    AND  EXCEPTION IS NOT NULL
  ORDER BY EXECUTE_TIME DESC)
WHERE ROWNUM <= 5;

PROMPT ===== E3. (예외 원인 후보 선별) 최종 SELECT 의 조인 대상 객체 존재·상태 — SP 는 EDIT_AUTH_V 뷰 등 진단 v2 에 없던 객체도 쓴다 =====
PROMPT ===== STATUS<>VALID 또는 미존재(행 없음) 객체 = 유력 원인 =====
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
FROM   ALL_OBJECTS
WHERE  OWNER='SCM_MGR'
  AND  OBJECT_NAME IN ('SCM_ADM_USER_MNU_EDIT_AUTH_V',  -- 최종 SELECT INNER JOIN (division-gate)
                       'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',  -- Owner 팀 조인
                       'SCM_MST_PROJECT', 'SCM_MST_ITEM_SN',
                       'DM_MST_ITEM_SINGLE_V', 'FN_NEXT_DAY')
ORDER BY OBJECT_NAME, OBJECT_TYPE;

PROMPT ===== E4. (보조) division-gate 실측 — 신고 계정의 EDIT_AUTH_V 에 (메뉴 DMF0074 × UNIT 81) 행이 있는가 =====
PROMPT ===== ⚠ 아래 :USER_ID 를 신고 사용자 ID 로 바꿔 실행. 0행 = 예외가 아니라 권한 게이트로 0건인 경우의 원인 =====
PROMPT ===== (단, D5 가 ERROR 를 찍고 있으므로 이번 건의 1순위는 E1/E2 의 예외 원문이다) =====
-- SELECT USER_ID, MNU_ID, UNIT_ID, EDIT_YN
-- FROM   SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
-- WHERE  USER_ID = '&USER_ID' AND MNU_ID = 'DMF0074' AND UNIT_ID = '81';
