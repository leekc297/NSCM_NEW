-- =============================================================================
-- 00_PRECHECK_CLOUD.sql  —  ⭐ 적용 **전에** 반드시 먼저 실행 (READ-ONLY, 변경 없음)
--   대상 패키지: DBWORK_7UI_PKSENTINEL_TRUNC_20260730_2301
--   근거: hook deploy-package-completeness §1.0-B (SYS0017 이관 사고 3건)
--
--   ⛔ 이 스크립트의 결과를 보고 **어느 파일을 실행할지 결정**한다.
--      사내 실측만 믿고 바로 적용하면 중복·충돌이 발생한다.
--   실행 계정: SCM_MGR   (마지막 [9] 만 애플리케이션 계정)
-- =============================================================================
SET LINESIZE 200
SET PAGESIZE 100
SET SERVEROUTPUT ON

PROMPT ============================================================
PROMPT [1] 접속 환경 확인
PROMPT ============================================================
SELECT USER AS CUR_USER, SYS_CONTEXT('USERENV','DB_NAME') AS DB_NAME,
       SYS_CONTEXT('USERENV','SERVER_HOST') AS HOST FROM DUAL;

PROMPT ============================================================
PROMPT [2] 이관 대상 CODE 9본 — 클라우드 현재 상태
PROMPT     기대: 9행. STATUS 무관(덮어쓰므로). 0행이면 신규 생성.
PROMPT     ⚠ LAST_DDL_TIME 이 사내(2026-07-30 21:54~22:38)보다 **최신**이면
PROMPT        클라우드에서 별도 수정된 것 → 덮어쓰기 전 담당자 확인 필수
PROMPT ============================================================
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM USER_OBJECTS
 WHERE OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE')
   AND OBJECT_NAME IN ('PKG_DMF0003','PKG_DMF0020','PKG_DMF0021','PKG_DMF0042',
                       'PKG_DMF0044','PKG_DMF0049','PKG_DMF0082',
                       'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL',
                       'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP')
 ORDER BY OBJECT_NAME, OBJECT_TYPE;

PROMPT ============================================================
PROMPT [3] 의존 GTT — 클라우드 보유 수  (사내 = 203)
PROMPT     부족분이 있으면 01_PREREQ/00_GTT_DDL.sql 이 채운다(멱등 -955 skip).
PROMPT     ⚠ 이미 있는 GTT 는 **갱신되지 않는다**. 본 패키지는 GTT 구조 변경이
PROMPT        없으므로 REBUILD 불요 — 구조 차이가 의심되면 [3-B] 로 확인.
PROMPT ============================================================
SELECT COUNT(*) AS GTT_PRESENT_CNT, 203 AS EXPECTED_CORP
  FROM USER_TABLES
 WHERE TEMPORARY='Y'
   AND TABLE_NAME IN (
     SELECT COLUMN_VALUE FROM TABLE(SYS.ODCIVARCHAR2LIST(
       -- 목록은 01_PREREQ/00_GTT_DDL.sql 의 주석 헤더와 동일 (203본)
       'GT_DMF0082_MF_SP','GT_DMF0020_EXCH','GT_DMF0020_RESULTS'
       -- ↑ 대표 3본만 예시. 전수 판정은 아래 [3-B] 사용
     )));

PROMPT --- [3-B] 전수 판정: 패키지의 GTT DDL 을 그대로 실행하면 없는 것만 생성된다.
PROMPT ---        따라서 사전 카운트보다 **적용 후 [04_VERIFY] 카운트**로 판정할 것.

PROMPT ============================================================
PROMPT [4] 의존 standalone TYPE — 클라우드 보유 수  (사내 = 18)
PROMPT     부족 시 PKG BODY 컴파일이 PLS-00201 로 실패 → 01_PREREQ/00_TYPES_DDL.sql 선행 필수
PROMPT ============================================================
SELECT COUNT(*) AS TYPE_PRESENT_CNT, 18 AS EXPECTED_CORP FROM USER_TYPES;

PROMPT ============================================================
PROMPT [5] ⭐⭐ 신규 채번 충돌 점검 — MSG/LBL  (hook §1.0-B B2)
PROMPT     본 패키지가 넣는 LBL 16종이 클라우드에서 **다른 의미로 이미 사용 중**이면
PROMPT     그대로 적용 금지 — 클라우드 MAX 기준 재채번 후 SQL 재생성할 것.
PROMPT     판정: 아래 결과의 MSG_NM 이 사내 값과 다르면 충돌.
PROMPT ============================================================
SELECT MSG_ID, LANG_CD, MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID IN ('LBL00783','LBL00794','LBL00795','LBL00796','LBL00797','LBL00798',
                  'LBL00799','LBL00800','LBL00844','LBL00845','LBL00846','LBL00847',
                  'LBL00848','LBL00849','LBL00850','LBL00851')
 ORDER BY MSG_ID, LANG_CD;

PROMPT --- 사내 기대값 (대조용): 03_META/04_MSG_LBL_VERSIONMODAL.sql 의 INSERT 값과 일치해야 함
PROMPT --- 0행 = 신규 채번 (충돌 없음, 그대로 적용 가능)

PROMPT ============================================================
PROMPT [6] PROC_M 현재 상태 — 이관 대상 19 SP
PROMPT     본 패키지는 이 19 SP 를 **DELETE 후 INSERT** 한다(211행).
PROMPT     아래 카운트가 211 과 다르면 클라우드가 다른 시그니처를 쓰고 있다는 뜻 →
PROMPT     적용 후 SP 시그니처와 대조 필수(04_VERIFY [4]).
PROMPT ============================================================
SELECT COUNT(DISTINCT PROC_NM) AS PROC_CNT, COUNT(*) AS ROW_CNT
  FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'PKG_DMF0044.%' OR PROC_NM LIKE 'PKG_DMF0049.%';

PROMPT --- 비표준 COL_TP_CD 잔존 (사내는 수정 완료 = 0). 0 이 아니면 본 패키지가 고친다.
SELECT COUNT(*) AS NONSTD_COL_TP_CD FROM SCM_ADM_PROC_M WHERE COL_TP_CD='PROC_RESULT';

PROMPT ============================================================
PROMPT [7] DMF0082 division 82 메타 — 보정 전/후 판정
PROMPT     사내 기대(적용 후): SHEET_MEASURE 82토큰 10행 / SHEET_COLUMNS 2행
PROMPT     0 이면 본 패키지가 채운다. 이미 있으면 UPDATE 로 값만 맞춘다(멱등).
PROMPT ============================================================
SELECT 'SHEET_MEASURE' AS TBL, COUNT(*) AS CNT FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID='DMF0082' AND DIVISION_ID LIKE '%82%'
UNION ALL
SELECT 'SHEET_COLUMNS', COUNT(*) FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0082' AND DIVISION_ID LIKE '%82%';

PROMPT ============================================================
PROMPT [8] ⚠️ 센티널 byte 검증 (hook §1.6) — 이관 전 기준값 확보
PROMPT     사내 기대: '-' 은 Len=1 (byte 45). '--'(Len=2) 가 나오면 이관 중 깨진 것.
PROMPT     본 패키지의 PK 센티널 정규화는 '-' 을 **쓰는** 쪽이므로 사전 상태 기록용.
PROMPT ============================================================
SELECT DUMP(PLANT_SITE_ID,1016) AS HEX, COUNT(*) AS CNT
  FROM SCM_MST_SITE_ITEM
 WHERE PLANT_SITE_ID IN ('-','--')
 GROUP BY DUMP(PLANT_SITE_ID,1016)
 ORDER BY 2 DESC;

PROMPT ============================================================
PROMPT [9] ⛔ 애플리케이션(BE 접속) 계정 확인 — **이 쿼리만 APP 계정으로 실행**
PROMPT     클라우드 = SCMP_APP / 사내 = SCMD_APP
PROMPT     18_APP_SYNONYM_ONLY.sql 은 이 계정 세션에서만 동작한다(SCM_MGR = ORA-01031).
PROMPT ============================================================
-- (APP 계정 세션에서)
-- SELECT USER AS CURRENT_ACCOUNT FROM DUAL;
-- SELECT COUNT(*) AS PKG_SYN_CNT FROM USER_SYNONYMS
--  WHERE TABLE_OWNER='SCM_MGR' AND SYNONYM_NAME LIKE 'PKG_DMF00%';
-- 기대: 정상 동작 중인 다른 화면 PKG 의 SYNONYM 이 이 계정에 있어야 함

PROMPT ============================================================
PROMPT [10] 판정 요약 — 아래를 확인한 뒤 _README.md 의 적용 순서로 진행
PROMPT   ☐ [2] LAST_DDL 이 사내보다 최신인 오브젝트 없음
PROMPT   ☐ [5] LBL 16종 충돌 없음 (0행 이거나 사내와 동일 문구)
PROMPT   ☐ [9] APP 계정이 SCMP_APP 임을 확인
PROMPT   위 3개 중 하나라도 어긋나면 **적용 중단 후 담당자 확인**
PROMPT ============================================================
