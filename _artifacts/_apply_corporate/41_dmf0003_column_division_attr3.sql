--------------------------------------------------------------------------------
-- 41_dmf0003_column_division_attr3.sql
-- DMF0003 (mkt-fcst) — 컬럼 DIVISION_ID 가시성(hook #92) 정합 handoff (멱등)
--
-- 작성    : 2026-06-29
-- 대상 DB : 사내 Oracle  SCM_MGR @ 121.162.245.167:2521/OCGSCMD_P01
-- 룰      : column-division-id-visibility(#92) / corp-meta-integrity-and-wiring(#98) /
--           ui-category-setup-no-arbitrary-data(#78) / backup(룰 30)
--
-- ⚠️ 적용 보류. 사용자(검토자)가 직접 적용. AI 임의 INSERT/추측 0건 — 모든 값은 기존 컬럼 복사.
--
-- 목적/근거 (2026-06-29 READ 실측)
--   hook #92 : SHEET_COLUMNS.DIVISION_ID 에 콤마토큰이 있으면, 조회조건 Division 이 그 토큰에
--              포함될 때만 컬럼 표시. 공란이면 항상 표시.
--   문제     : BE generic /admin/menu/{id}/column 엔드포인트 + RawFlexGridColumnConfig 모델에는
--              divisionId 필드가 없다(attribute1..10 만 존재). 따라서 DB 의 DIVISION_ID 값이
--              FE 로 실려오지 못한다 → FE 가 division 필터를 적용할 입력이 없음.
--   #92 정식패턴 : DIVISION_ID → ATTRIBUTE3 복사. FE 는 col.attribute3 를 _divisionAllow 로 읽어
--                  콤마토큰 필터(공란=항상표시). (BE/SP/모델 무변경.)
--   실측     : SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main'
--                → 67 컬럼 전부 DIVISION_ID 채워짐 (예: END_CUSTOMER40='40',
--                  END_CUSTOMER='82,81,81_UC,81_HM,81_ST,81_HD,81_HG').
--                ATTRIBUTE3 는 전 행 공백(' ', LEN=1)/NULL = clean → 충돌 없이 복사 가능.
--                ATTRIBUTE1 에는 division 토큰('81,82' 등)이 들어가 있으나 이는 FE 에서 modalKey 로
--                오인되므로 FE 코드에서 fallback 우선으로 차단함(별도 FE PR). 본 SQL 은 ATTRIBUTE3 만 손댐.
--------------------------------------------------------------------------------

WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;

--------------------------------------------------------------------------------
-- [STEP 0] CTAS 백업 (멱등 — 이미 있으면 skip)  ⭐ 모든 변경 선행 의무
--------------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE
    'CREATE TABLE SCM_MST_SHEET_COLUMNS_BAK_DMF0003_ATTR3 AS
       SELECT * FROM SCM_MST_SHEET_COLUMNS
        WHERE PROGRAM_ID = ''DMF0003'' AND SHEET_NAME = ''main''';
  DBMS_OUTPUT.PUT_LINE('BACKUP: SCM_MST_SHEET_COLUMNS_BAK_DMF0003_ATTR3 created');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -955 THEN
    DBMS_OUTPUT.PUT_LINE('BACKUP exists (skip): SCM_MST_SHEET_COLUMNS_BAK_DMF0003_ATTR3');
  ELSE RAISE; END IF;
END;
/

--------------------------------------------------------------------------------
-- [STEP 1] 근거 SELECT (변경 전 현황 — DIVISION_ID 채움 vs ATTRIBUTE3 공란)
--------------------------------------------------------------------------------
PROMPT === 1-A. main 67 컬럼: DIVISION_ID 채움 / ATTRIBUTE3 현재값 분포 ===
SELECT COUNT(*) TOTAL,
       COUNT(DIVISION_ID) DIV_FILLED,
       SUM(CASE WHEN TRIM(ATTRIBUTE3) IS NULL THEN 1 ELSE 0 END) A3_BLANK,
       SUM(CASE WHEN TRIM(ATTRIBUTE3) IS NOT NULL THEN 1 ELSE 0 END) A3_NONBLANK
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main';

PROMPT === 1-B. 대표 컬럼 DIVISION_ID -> ATTRIBUTE3 복사 미리보기 (변경 전) ===
SELECT COLUMN_NAME, DIVISION_ID, ATTRIBUTE3 BEFORE_A3
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main'
   AND COLUMN_NAME IN ('DIVISION_ID','END_CUSTOMER','END_CUSTOMER40','SCM_SITE_ID',
                       'ITEM_ID','MEASURE','PROJECT_CODE')
 ORDER BY SORT_ORDER_NO;

--------------------------------------------------------------------------------
-- [STEP 2] UPDATE — ATTRIBUTE3 := DIVISION_ID (전 67 컬럼, 멱등)  ⭐ APPLY-READY
--   멱등: 이미 ATTRIBUTE3 = DIVISION_ID 인 행은 재실행해도 동일(영향 0). NVL 비교로 NULL/공백 모두 갱신.
--------------------------------------------------------------------------------
UPDATE SCM_MST_SHEET_COLUMNS
   SET ATTRIBUTE3       = DIVISION_ID,
       LAST_UPDATED_BY  = 'meta_div_41',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main'
   AND DIVISION_ID IS NOT NULL
   AND NVL(ATTRIBUTE3, '~') <> DIVISION_ID;
-- 예상 영향: 67 row (전부 ATTRIBUTE3 공백/NULL → DIVISION_ID 로 채워짐).
COMMIT;

--------------------------------------------------------------------------------
-- [STEP 3] 검증 SELECT (변경 후 — 적용했다면 0 row 여야 정상)
--------------------------------------------------------------------------------
PROMPT === 3-A. (적용 후) ATTRIBUTE3 != DIVISION_ID 잔존 (0 row 여야 정상) ===
SELECT COLUMN_NAME, DIVISION_ID, ATTRIBUTE3
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='main'
   AND DIVISION_ID IS NOT NULL
   AND NVL(ATTRIBUTE3, '~') <> DIVISION_ID;

--------------------------------------------------------------------------------
-- [STEP 4] 백업 검증
--------------------------------------------------------------------------------
PROMPT === 4. 백업 row 수 (원본 main 67 과 일치 확인) ===
SELECT 'BAK_ATTR3' T, COUNT(*) CNT FROM SCM_MST_SHEET_COLUMNS_BAK_DMF0003_ATTR3;

-- STEP 2 에서 이미 COMMIT 됨 (apply-ready). 원복은 아래 §원복 블록 사용.

--------------------------------------------------------------------------------
-- §원복 (필요 시)
--   UPDATE SCM_MST_SHEET_COLUMNS c
--      SET c.ATTRIBUTE3 = (SELECT b.ATTRIBUTE3
--                            FROM SCM_MST_SHEET_COLUMNS_BAK_DMF0003_ATTR3 b
--                           WHERE b.PROGRAM_ID=c.PROGRAM_ID AND b.SHEET_NAME=c.SHEET_NAME
--                             AND b.COLUMN_NAME=c.COLUMN_NAME)
--    WHERE c.PROGRAM_ID='DMF0003' AND c.SHEET_NAME='main';
--   COMMIT;
--------------------------------------------------------------------------------
