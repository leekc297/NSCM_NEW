--==============================================================================
-- 92_DIAG_CLOUD_MRFPARITY.sql — 클라우드 PKG_DMF0074 MRFPARITY 반영 여부 판별
--   증상: Excel Form 조회 시 MSG00656("이번 주 Sales Plan Waterfall 에
--         Monthly Rolling Forecast 'Y' 버전이 존재하지 않습니다") 재발
--   실행: sqlplus SCM_MGR 로 **QA·DEV 양쪽 각각** 실행 (클라우드 2DB 동시 적용 원칙)
--   판정 기준 (사내 정본 실측 2026-08-19):
--     [1] 어느 DB 인지 식별      : SERVER_HOST 확인 (QA/DEV 각 1회)
--     [2] BODY 라인수            : 3981  (다르면 구버전 BODY)
--     [3] MRFPARITY 마커         : 1     (0 이면 pre-MRFPARITY = 정정 미반영)
--     [4] MRF 필터 활성 라인 수   : 1     (2 이면 TEMPLATE 분기 필터가 살아있음 → 메시지 발생)
--     [5] STATUS                 : PACKAGE / PACKAGE BODY 모두 VALID
--==============================================================================
SET LINESIZE 200 PAGESIZE 100 TRIMSPOOL ON

PROMPT ===== [1] 실행 환경 식별 (QA / DEV 어느 쪽인지) =====
SELECT USER AS "USER",
       SYS_CONTEXT('USERENV','DB_NAME')     AS DB_NAME,
       SYS_CONTEXT('USERENV','CON_NAME')    AS CON_NAME,
       SYS_CONTEXT('USERENV','SERVER_HOST') AS SERVER_HOST
  FROM DUAL;

PROMPT ===== [2] PKG_DMF0074 상태 / LAST_DDL / BODY 라인수 (기대: VALID + 3981줄) =====
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074';

SELECT MAX(LINE) AS BODY_LINES
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY';

PROMPT ===== [3] MRFPARITY 마커 (기대: 1 / 0 이면 정정 미반영) =====
SELECT COUNT(*) AS MRFPARITY_MARKER
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
   AND TEXT LIKE '%MRFPARITY 2026-08-18%';

PROMPT ===== [4] MRF 필터 활성 라인 (기대: 1 = UPLOAD 분기만 / 2 = TEMPLATE 분기 활성 → 메시지 발생) =====
SELECT COUNT(*) AS ACTIVE_MRF_FILTER
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
   AND LTRIM(TEXT) LIKE 'AND    NVL(ATTRIBUTE7, ''N'') = ''Y''%';

PROMPT ===== [4b] 활성/주석 라인 위치 (참고 — 사내 정본: 주석 L618 / 활성 L1032) =====
SELECT LINE,
       CASE WHEN LTRIM(TEXT) LIKE '--%' THEN '주석' ELSE '활성' END AS 구분,
       SUBSTR(LTRIM(TEXT),1,60) AS TEXT_HEAD
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' AND TYPE='PACKAGE BODY'
   AND TEXT LIKE '%NVL(ATTRIBUTE7, ''N'') = ''Y''%'
 ORDER BY LINE;

PROMPT ===== [5] 컴파일 오류 (기대: 0) =====
SELECT COUNT(*) AS ERRORS
  FROM ALL_ERRORS
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074';

--==============================================================================
-- 판정 후 조치:
--  · [3]=0 또는 [4]=2 → 그 DB 는 pre-MRFPARITY 본.
--    → DMF0074_CLOUD_20260819\A_DB\02_PKG_DMF0074_BODY.sql 을 sqlplus 로
--      **파일 통째 실행** (@02_PKG_DMF0074_BODY.sql).
--      ⚠ 세미콜론 단위로 문장을 쪼개는 도구(자체 배포 스크립트/일부 IDE의
--        구문 분할 실행)는 헤더 주석에 붙은 첫 문장을 조용히 누락시킨 전력이
--        있음 — sqlplus @파일 실행이 정본.
--    → 실행 후 본 92 진단을 다시 실행해 [2]=3981 / [3]=1 / [4]=1 / VALID 확인.
--  · QA·DEV 두 DB 모두 같은 결과가 나와야 완료 (한쪽만 적용 = 화면 증상 잔존).
--  · [3]=1, [4]=1 인데도 화면 메시지가 나오면 → BE 가 바라보는 DB 가 다른 쪽일
--    가능성 — [1] SERVER_HOST 를 BE application.yml datasource 와 대조.
--==============================================================================
