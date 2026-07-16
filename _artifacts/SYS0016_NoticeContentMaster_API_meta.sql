--==============================================================================
-- SYS0016_NoticeContentMaster_API_meta.sql
-- SYS0016 (공지 내용 마스터 조회) 화면 — 조회 API 메타 등록.
--
-- 대상 SP : PKG_SYS0016.P_SYS0016_GET_NOTICE_CONTENT_MASTER
--   IN  : P_NOTICE_ID (VARCHAR2)
--   OUT : O_RC1            (SYS_REFCURSOR)  — 공지 내용 데이터
--         O_RESULT_CURSOR  (SYS_REFCURSOR)  — 결과 상태('0'/SUCCESS/EVENT)
--
-- 스키마·감사값 = 동일 계열 사내 적용본 60_SYS0012_SCM0009_full_fix.sql(2026-06-06) 준거.
-- 멱등: 전 INSERT NOT EXISTS 가드 → 재실행 안전.
--
-- ⚠ 실행 전 확인 필요 (환경별 상이 가능 — anti-simplification):
--   (1) API_URL / PROC_NM = PKG-qualified 로 등록. SYS 계열 일부(SYS0012)는 짧은 프로시저명을
--       쓰므로, 만약 SYS0016 BE 리졸버가 짧은 이름을 기대하면 두 값을 모두
--       'P_SYS0016_GET_NOTICE_CONTENT_MASTER' 로 동일하게 바꿀 것. (API_URL == PROC_NM 필수)
--   (2) SHT_NM='main' — FE SYS0016 의 SHEETS 상수와 일치해야 함(불일치 시 조회 시 권한없음/무동작).
--   (3) MSG 는 SCM_ADM_MSG_M 에 등록(사내 DMF 계열 준거). 환경이 SCM_ADM_I18N_M 를 쓰면 BLOCK 1 조정.
--   (4) PROC_M 은 주어진 SP 시그니처와 위치 1:1(noticeId/o_rc1/O_RESULT_CURSOR). SP 에 사용자
--       파라미터가 없으므로 sesUserId/mnuId 를 추가하지 말 것(추가 시 위치 바인딩 어긋남).
--   (5) 권한(BLOCK 5)은 ADMIN / SCM PI Admin 예시 — 실제 부여 대상 그룹으로 조정.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

-- ---------------------------------------------------------------------------
-- BLOCK 1 : MSG_M — API 메시지 (API_M.API_MSG_ID 가 참조, NOT NULL)
-- ---------------------------------------------------------------------------
PROMPT === BLOCK 1 : MSG_M ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG_API_SYS0016_MAIN_SEARCH', 'KO', 'API', '공지 내용 마스터 조회', '공지 내용 마스터 조회', 'Y', 'system', SYSDATE, 'system', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X
    WHERE X.MSG_ID = 'MSG_API_SYS0016_MAIN_SEARCH' AND X.LANG_CD = 'KO'
 );

-- ---------------------------------------------------------------------------
-- BLOCK 2 : API_M — 조회 API 1건 (Oracle SP routing)
-- ---------------------------------------------------------------------------
PROMPT === BLOCK 2 : API_M ===

INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_URL, API_TP_CD, API_MSG_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'API_SYS0016_GET_NOTICE_CONTENT_MASTER',
       'PKG_SYS0016.P_SYS0016_GET_NOTICE_CONTENT_MASTER',
       'POST',
       'MSG_API_SYS0016_MAIN_SEARCH',
       'Y', 'system', SYSDATE, 'system', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X
    WHERE X.API_ID = 'API_SYS0016_GET_NOTICE_CONTENT_MASTER'
 );

-- ---------------------------------------------------------------------------
-- BLOCK 3 : MNU_BTN_MPG_M — 메뉴×시트×버튼 → API 배선 (SEARCH)
--   FE useTabProcQuery 기본 action='SEARCH' 와 매칭 (RETRIEVE 아님)
-- ---------------------------------------------------------------------------
PROMPT === BLOCK 3 : MNU_BTN_MPG_M ===

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SYS0016', 'main', 'SEARCH', 'API_SYS0016_GET_NOTICE_CONTENT_MASTER', 'Y', 'system', SYSDATE, 'system', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'SYS0016' AND X.SHT_NM = 'main' AND X.MNU_BTN_CD = 'SEARCH'
 );

-- ---------------------------------------------------------------------------
-- BLOCK 4 : PROC_M — SP 파라미터 메타 (SP 시그니처와 위치 1:1)
--   P_NOTICE_ID     → noticeId        (IN,  VARCHAR)      SORT 1
--   O_RC1           → o_rc1           (OUT, CURSOR)       SORT 2  — 공지 데이터 커서
--   O_RESULT_CURSOR → O_RESULT_CURSOR (OUT, PROC_RESULT)  SORT 3  — 결과 상태 커서
-- ---------------------------------------------------------------------------
PROMPT === BLOCK 4 : PROC_M ===

INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.COL_TP_CD, NEW.DATA_TP_CD, NEW.SORT_ORD, NEW.CREATED_BY, NEW.CREATION_DATE, NEW.LAST_UPDATED_BY, NEW.LAST_UPDATE_DATE
  FROM (
    SELECT 'PKG_SYS0016.P_SYS0016_GET_NOTICE_CONTENT_MASTER' AS PROC_NM, 'noticeId'        AS COL_NM, 'IN'  AS COL_TP_CD, 'VARCHAR'     AS DATA_TP_CD, 1 AS SORT_ORD, 'system' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'system' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
    SELECT 'PKG_SYS0016.P_SYS0016_GET_NOTICE_CONTENT_MASTER',           'o_rc1',                     'OUT',              'CURSOR',                   2,            'system',              SYSDATE,                   'system',                   SYSDATE FROM DUAL UNION ALL
    SELECT 'PKG_SYS0016.P_SYS0016_GET_NOTICE_CONTENT_MASTER',           'O_RESULT_CURSOR',           'OUT',              'PROC_RESULT',              3,            'system',              SYSDATE,                   'system',                   SYSDATE FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X
    WHERE X.PROC_NM = NEW.PROC_NM AND X.COL_NM = NEW.COL_NM AND X.COL_TP_CD = NEW.COL_TP_CD
 );

-- ---------------------------------------------------------------------------
-- BLOCK 5 : USER_GR_MNU_BTN_MPG_M — 조회 버튼 권한 부여 (예시: ADMIN / SCM PI Admin)
--   ⚠ 실제 부여 대상 권한그룹으로 조정. 미부여 시 조회 버튼이 "권한없음" 으로 동작.
-- ---------------------------------------------------------------------------
PROMPT === BLOCK 5 : USER_GR_MNU_BTN_MPG_M ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.USER_GR_ID, NEW.MNU_ID, NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.USE_YN, NEW.CREATED_BY, NEW.CREATION_DATE, NEW.LAST_UPDATED_BY, NEW.LAST_UPDATE_DATE
  FROM (
    SELECT 'ADMIN'        AS USER_GR_ID, 'SYS0016' AS MNU_ID, 'main' AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'Y' AS USE_YN, 'system' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'system' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
    SELECT 'SCM PI Admin',              'SYS0016',           'main',           'SEARCH',              'Y',            'system',              SYSDATE,                   'system',                   SYSDATE FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID = NEW.USER_GR_ID AND X.MNU_ID = NEW.MNU_ID
      AND X.SHT_NM = NEW.SHT_NM AND X.MNU_BTN_CD = NEW.MNU_BTN_CD
 );

-- ---------------------------------------------------------------------------
-- BLOCK 6 : 검증
-- ---------------------------------------------------------------------------
PROMPT === BLOCK 6 : VERIFY ===

SELECT 'MSG_M'                 AS TOPIC, COUNT(*) AS CNT FROM SCM_MGR.SCM_ADM_MSG_M              WHERE MSG_ID='MSG_API_SYS0016_MAIN_SEARCH'
UNION ALL
SELECT 'API_M',                         COUNT(*)         FROM SCM_MGR.SCM_ADM_API_M              WHERE API_ID='API_SYS0016_GET_NOTICE_CONTENT_MASTER'
UNION ALL
SELECT 'MNU_BTN_MPG_M',                 COUNT(*)         FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M      WHERE MNU_ID='SYS0016' AND MNU_BTN_CD='SEARCH'
UNION ALL
SELECT 'PROC_M',                        COUNT(*)         FROM SCM_MGR.SCM_ADM_PROC_M             WHERE PROC_NM='PKG_SYS0016.P_SYS0016_GET_NOTICE_CONTENT_MASTER'
UNION ALL
SELECT 'USER_GR_MNU_BTN_MPG_M',         COUNT(*)         FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='SYS0016' AND MNU_BTN_CD='SEARCH';

-- 배선 조인 검증 (BTN_MPG × API_M × PROC_M — 조회 체인 정합)
SELECT B.MNU_ID, B.SHT_NM, B.MNU_BTN_CD, A.API_URL, A.API_TP_CD,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M P WHERE P.PROC_NM = A.API_URL) AS PROC_PARAM_CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B
  JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID
 WHERE B.MNU_ID='SYS0016' AND B.MNU_BTN_CD='SEARCH';

COMMIT;
PROMPT === COMPLETE ===
EXIT;
