-- ============================================================================
-- 13_DATA_ASFROMSITE_TO_NULL.sql
--   DMF0003 (MKT FCST) — AS From Site 센티널 값 → NULL 데이터 보정
--   대상 : SCM_MGR.DM_PLN_MKT_FCST.ATTRIBUTE10  (= 화면 AS From Site)
--   실행 : SCM_MGR 계정 / 클라우드(QA·DEV·운영)
--
-- [왜 필요한가]
--   구 저장 로직이 빈 값을 '-' 로 적재했다(`NVL(V_AS_FROM_SITE,'-')` 외 2곳).
--   그 결과 **같은 정적 구조인데 AS From Site 만 다른 행**으로 갈라져 화면에 2줄로 보인다.
--   패키지 정정(마커 E20260815-ASFROMNULL, `02_PKG_DMF0003_BODY.sql`)으로 **신규 발생은 차단**되지만,
--   이미 적재된 과거 행은 남아 있으므로 이 스크립트로 정리한다.
--   ⇒ 반드시 **패키지 정정 적용 후** 실행할 것. 먼저 돌리면 이후 저장에서 다시 '-' 가 쌓인다.
--
-- [안전성 — 사내 실측 2026-08-16]
--   · ATTRIBUTE10 = VARCHAR2(600), NULLABLE='Y'  → NULL 저장 가능
--   · PK(10컬럼: DIVISION_ID/PROJECT_CODE/SCM_SITE_ID/ITEM_ID/DOM_EXP/FCST_TYPE/
--     INCOTERMS/MEASURE/YYYYMMDD/PLANT_SITE_ID)에 **미포함** → 값 변경으로 PK 충돌 없음
--   · 인덱스 구성 컬럼 **아님** → 인덱스 재구축 부담 없음
--   · 사내 적용 실적: 11행 UPDATE, 잔존 0, 저장 왕복 후 재발 0
--
-- [감사컬럼 정책]
--   LAST_UPDATED_BY / LAST_UPDATE_DATE 는 **일부러 건드리지 않는다.**
--   이 테이블은 메타가 아니라 **업무 원장**이라, 데이터 정리 때문에 "누가 마지막에 수정했는가"를
--   덮어쓰면 실제 담당자 이력이 사라진다. (메타 테이블의 'admin' 고정 규약과 구분)
--   감사컬럼까지 갱신하려면 §4 의 주석을 해제할 것.
-- ============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

-- ────────────────────────────────────────────────────────────────────────────
-- §1. 사전 점검 — 무엇을 몇 건 바꾸는지 먼저 본다 (변경 없음, 조회만)
-- ────────────────────────────────────────────────────────────────────────────
PROMPT === §1-a 현재 센티널 값 분포 (DUMP 로 실제 바이트까지 확인) ===
SELECT '[' || ATTRIBUTE10 || ']' AS VAL,
       DUMP(ATTRIBUTE10)         AS RAW_BYTES,
       COUNT(*)                  AS CNT
  FROM SCM_MGR.DM_PLN_MKT_FCST
 WHERE ATTRIBUTE10 IS NOT NULL
   AND ( TRIM(ATTRIBUTE10) IS NULL                 -- '' / ' ' / '   ' (공백만)
      OR REPLACE(TRIM(ATTRIBUTE10), '-') IS NULL ) -- '-' / '--' / '---' (하이픈만)
 GROUP BY ATTRIBUTE10, DUMP(ATTRIBUTE10)
 ORDER BY CNT DESC;

PROMPT === §1-b 전체 대비 비율 ===
SELECT COUNT(*)                                                          AS TOTAL_ROWS,
       COUNT(CASE WHEN ATTRIBUTE10 IS NULL THEN 1 END)                   AS ALREADY_NULL,
       COUNT(CASE WHEN ATTRIBUTE10 IS NOT NULL
                   AND ( TRIM(ATTRIBUTE10) IS NULL
                      OR REPLACE(TRIM(ATTRIBUTE10), '-') IS NULL )
                  THEN 1 END)                                            AS TO_BE_FIXED
  FROM SCM_MGR.DM_PLN_MKT_FCST;

PROMPT === §1-c PK 충돌 사전 검증 (0 이어야 정상 — ATTRIBUTE10 은 PK 미포함이라 구조상 0) ===
SELECT COUNT(*) AS PK_SIBLING_CONFLICT
  FROM SCM_MGR.DM_PLN_MKT_FCST A
 WHERE A.ATTRIBUTE10 IS NOT NULL
   AND ( TRIM(A.ATTRIBUTE10) IS NULL OR REPLACE(TRIM(A.ATTRIBUTE10), '-') IS NULL )
   AND EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST B
                WHERE B.DIVISION_ID   = A.DIVISION_ID   AND B.PROJECT_CODE  = A.PROJECT_CODE
                  AND B.SCM_SITE_ID   = A.SCM_SITE_ID   AND B.ITEM_ID       = A.ITEM_ID
                  AND B.DOM_EXP       = A.DOM_EXP       AND B.FCST_TYPE     = A.FCST_TYPE
                  AND B.INCOTERMS     = A.INCOTERMS     AND B.MEASURE       = A.MEASURE
                  AND B.YYYYMMDD      = A.YYYYMMDD      AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
                  AND B.ROWID <> A.ROWID);

-- ────────────────────────────────────────────────────────────────────────────
-- §2. 원복용 백업 — 바꾸기 전 상태를 테이블로 남긴다 (재실행 대비 멱등)
--     PK 10컬럼 + 이전 값. 원복은 §5 참조.
-- ────────────────────────────────────────────────────────────────────────────
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE SCM_MGR.DM_PLN_MKT_FCST_ASFROM_BAK_20260816 PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;   -- -942 = 테이블 없음(최초 실행) → 정상
END;
/

CREATE TABLE SCM_MGR.DM_PLN_MKT_FCST_ASFROM_BAK_20260816 AS
SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP,
       FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID,
       ATTRIBUTE10 AS OLD_ATTRIBUTE10,
       SYSDATE     AS BACKUP_DATE
  FROM SCM_MGR.DM_PLN_MKT_FCST
 WHERE ATTRIBUTE10 IS NOT NULL
   AND ( TRIM(ATTRIBUTE10) IS NULL OR REPLACE(TRIM(ATTRIBUTE10), '-') IS NULL );

PROMPT === §2 백업 건수 (§1-b 의 TO_BE_FIXED 와 같아야 함) ===
SELECT COUNT(*) AS BACKUP_CNT FROM SCM_MGR.DM_PLN_MKT_FCST_ASFROM_BAK_20260816;

-- ────────────────────────────────────────────────────────────────────────────
-- §3. 본 보정 — 센티널(공백만 / 하이픈만) → NULL
--     Oracle 은 '' 가 곧 NULL 이라 빈 문자열은 이미 NULL 로 들어와 있다.
-- ────────────────────────────────────────────────────────────────────────────
UPDATE SCM_MGR.DM_PLN_MKT_FCST
   SET ATTRIBUTE10 = NULL
 WHERE ATTRIBUTE10 IS NOT NULL
   AND ( TRIM(ATTRIBUTE10) IS NULL                 -- ' ', '   '
      OR REPLACE(TRIM(ATTRIBUTE10), '-') IS NULL );-- '-', '--', ' - '

PROMPT === §3 UPDATE 건수 ===
SELECT '갱신 ' || TO_CHAR(SQL%ROWCOUNT) FROM DUAL;   -- (SQL*Plus 는 아래 §4 로 확인)

-- ────────────────────────────────────────────────────────────────────────────
-- §4. (선택) 감사컬럼까지 갱신하려면 아래 주석 해제 — 기본은 **원장 이력 보존**
-- ────────────────────────────────────────────────────────────────────────────
-- UPDATE SCM_MGR.DM_PLN_MKT_FCST A
--    SET A.LAST_UPDATED_BY = 'admin', A.LAST_UPDATE_DATE = SYSDATE
--  WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST_ASFROM_BAK_20260816 B
--                 WHERE B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE
--                   AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID      = A.ITEM_ID
--                   AND B.DOM_EXP     = A.DOM_EXP     AND B.FCST_TYPE    = A.FCST_TYPE
--                   AND B.INCOTERMS   = A.INCOTERMS   AND B.MEASURE      = A.MEASURE
--                   AND B.YYYYMMDD    = A.YYYYMMDD    AND B.PLANT_SITE_ID = A.PLANT_SITE_ID);

COMMIT;

-- ────────────────────────────────────────────────────────────────────────────
-- §5. 검증 — 잔존 0 이어야 하고, 행 수는 변하지 않아야 한다(UPDATE 지 DELETE 가 아님)
-- ────────────────────────────────────────────────────────────────────────────
PROMPT === §5-a 잔존 센티널 (0 이어야 정상) ===
SELECT COUNT(*) AS REMAIN_SENTINEL
  FROM SCM_MGR.DM_PLN_MKT_FCST
 WHERE ATTRIBUTE10 IS NOT NULL
   AND ( TRIM(ATTRIBUTE10) IS NULL OR REPLACE(TRIM(ATTRIBUTE10), '-') IS NULL );

PROMPT === §5-b 보정 대상 행이 사라지지 않았는지 (백업 건수와 매칭 = 백업 전건 존재) ===
SELECT COUNT(*) AS MATCHED_ROWS
  FROM SCM_MGR.DM_PLN_MKT_FCST_ASFROM_BAK_20260816 B
 WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST A
                WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE  = B.PROJECT_CODE
                  AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID       = B.ITEM_ID
                  AND A.DOM_EXP     = B.DOM_EXP     AND A.FCST_TYPE     = B.FCST_TYPE
                  AND A.INCOTERMS   = B.INCOTERMS   AND A.MEASURE       = B.MEASURE
                  AND A.YYYYMMDD    = B.YYYYMMDD    AND A.PLANT_SITE_ID = B.PLANT_SITE_ID);

PROMPT === §5-c AS From Site 값 분포 (센티널이 사라졌는지) ===
SELECT NVL('[' || ATTRIBUTE10 || ']', '(NULL)') AS VAL, COUNT(*) AS CNT
  FROM SCM_MGR.DM_PLN_MKT_FCST
 WHERE ATTRIBUTE10 IS NULL
    OR TRIM(ATTRIBUTE10) IS NULL
    OR REPLACE(TRIM(ATTRIBUTE10), '-') IS NULL
 GROUP BY ATTRIBUTE10;

-- ────────────────────────────────────────────────────────────────────────────
-- §6. 원복 (필요 시에만)
-- ────────────────────────────────────────────────────────────────────────────
-- UPDATE SCM_MGR.DM_PLN_MKT_FCST A
--    SET A.ATTRIBUTE10 = (SELECT B.OLD_ATTRIBUTE10
--                           FROM SCM_MGR.DM_PLN_MKT_FCST_ASFROM_BAK_20260816 B
--                          WHERE B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE  = A.PROJECT_CODE
--                            AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID       = A.ITEM_ID
--                            AND B.DOM_EXP     = A.DOM_EXP     AND B.FCST_TYPE     = A.FCST_TYPE
--                            AND B.INCOTERMS   = A.INCOTERMS   AND B.MEASURE       = A.MEASURE
--                            AND B.YYYYMMDD    = A.YYYYMMDD    AND B.PLANT_SITE_ID = A.PLANT_SITE_ID)
--  WHERE EXISTS (SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST_ASFROM_BAK_20260816 B
--                 WHERE B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE  = A.PROJECT_CODE
--                   AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID       = A.ITEM_ID
--                   AND B.DOM_EXP     = A.DOM_EXP     AND B.FCST_TYPE     = A.FCST_TYPE
--                   AND B.INCOTERMS   = A.INCOTERMS   AND B.MEASURE       = A.MEASURE
--                   AND B.YYYYMMDD    = A.YYYYMMDD    AND B.PLANT_SITE_ID = A.PLANT_SITE_ID);
-- COMMIT;

-- ────────────────────────────────────────────────────────────────────────────
-- §7. 참고 — 영향 범위
--   `DM_PLN_MKT_FCST` 는 DMF0003 의 원장이지만 DMF0082(FCST&PRICE MGMT) 등
--   같은 원장을 읽는 화면에서도 AS From Site 표시가 함께 바뀐다(모두 '값 없음' 표기로 통일).
--   행이 사라지거나 수량이 바뀌는 변경은 아니다 — 표시/그룹핑 기준만 정규화된다.
-- ────────────────────────────────────────────────────────────────────────────
