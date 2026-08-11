-- ============================================================================
-- DMF0044 환율 모달 컬럼 2중 표시 정정 (2026-08-11 — 클라우드 실증: Div/Currency/Unit 2개씩)
--
-- ## 원천 구조
--   환율 모달 정적 컬럼 = `/admin/menu/DMF0044/column` (sheetNm='exchangeRate')
--   → PR_GET_SHEET_COLUMN_LIST → SCM_MST_SHEET_COLUMNS. **이 테이블은 PK 가 없다.**
--
-- ## 사내 정본 (2026-08-11 실측 — 정확히 4행)
--   | SHEET_NAME   | COLUMN_NAME           | VISIBLE |
--   | exchangeRate | DIVISION_ID           | Y       |
--   | exchangeRate | CURRENCY              | Y       |
--   | exchangeRate | UNIT_CURRENCY         | Y       |
--   | exchangeRate | CURRENCY_UNITCURRENCY | N       |
--   (7월 이관 패키지에는 exchangeRate 시트가 없었다 — 4행은 08-10 사내 신설분)
--
-- ## 중복 2계보 (둘 다 본 스크립트가 잡는다)
--   A. **완전 동일 키 물리 중복** — PK 부재라 같은 (PROGRAM_ID,SHEET_NAME,COLUMN_NAME) 행이
--      2개 존재 가능. 이관 MERGE 는 둘 다 UPDATE 할 뿐 제거하지 못한다.
--   B. **키 변형 구행** — 클라우드에 다른 SHEET_NAME/COLUMN_NAME 표기(공백·대소문자·다른 명명)로
--      먼저 생긴 행 + 이관 MERGE 가 넣은 정본 행이 공존.
--
-- 실행: SCM_MGR. **QA·DEV 2DB 동시**. §1 진단 결과를 확인한 뒤 §2~§4 를 실행할 것.
-- ============================================================================
SET DEFINE OFF
SET LINESIZE 220

-- ────────────────────────────────────────────────────────────────────────────
-- §1. 진단 — 변형까지 전부 노출 (LENGTH 로 숨은 공백 검출)
-- ────────────────────────────────────────────────────────────────────────────
SELECT '''' || SHEET_NAME  || '''' AS SHEET_NAME_QUOTED,  LENGTH(SHEET_NAME)  AS SHEET_LEN,
       '''' || COLUMN_NAME || '''' AS COLUMN_NAME_QUOTED, LENGTH(COLUMN_NAME) AS COL_LEN,
       VISIBLE_FLAG, VALID_YN, NVL(DIVISION_ID,'<NULL>') AS DIVISION_ID,
       TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI') AS CRE, CREATED_BY,
       COUNT(*) OVER (PARTITION BY SHEET_NAME, COLUMN_NAME) AS 동일키행수
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0044'
   AND UPPER(REPLACE(SHEET_NAME, ' ', '')) LIKE '%XCHANGE%'
 ORDER BY SHEET_NAME, COLUMN_NAME, CREATION_DATE;

-- ────────────────────────────────────────────────────────────────────────────
-- §2. 백업 (멱등 — 이미 있으면 skip)
-- ────────────────────────────────────────────────────────────────────────────
DECLARE
  n NUMBER;
BEGIN
  SELECT COUNT(*) INTO n FROM ALL_TABLES
   WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = 'DROP_SHTCOL_EXCH_BAK_20260811';
  IF n = 0 THEN
    EXECUTE IMMEDIATE q'[
      CREATE TABLE SCM_MGR.DROP_SHTCOL_EXCH_BAK_20260811 AS
      SELECT * FROM SCM_MST_SHEET_COLUMNS
       WHERE PROGRAM_ID = 'DMF0044'
         AND UPPER(REPLACE(SHEET_NAME, ' ', '')) LIKE '%XCHANGE%']';
  END IF;
END;
/

-- ────────────────────────────────────────────────────────────────────────────
-- §3. 정정 — 안전가드: 정본 4행이 존재할 때만 수행 (없으면 아무것도 지우지 않음)
-- ────────────────────────────────────────────────────────────────────────────
DECLARE
  n_canon NUMBER;
  n_dedup NUMBER := 0;
  n_var   NUMBER := 0;
BEGIN
  -- 가드: 정본 4키가 전부 있는가 (이관 11_META_SHEET_COLUMNS.sql 적용 후여야 한다)
  SELECT COUNT(DISTINCT COLUMN_NAME) INTO n_canon
    FROM SCM_MST_SHEET_COLUMNS
   WHERE PROGRAM_ID = 'DMF0044' AND SHEET_NAME = 'exchangeRate'
     AND COLUMN_NAME IN ('DIVISION_ID','CURRENCY','UNIT_CURRENCY','CURRENCY_UNITCURRENCY');
  IF n_canon < 4 THEN
    RAISE_APPLICATION_ERROR(-20001,
      '정본 4행 미존재(' || n_canon || '/4) — 11_META_SHEET_COLUMNS.sql 선적용 후 재실행');
  END IF;

  -- A. 완전 동일 키 물리 중복 → 1행만 남김 (PK 부재 대비 ROWID dedup)
  DELETE FROM SCM_MST_SHEET_COLUMNS a
   WHERE a.PROGRAM_ID = 'DMF0044'
     AND UPPER(REPLACE(a.SHEET_NAME, ' ', '')) LIKE '%XCHANGE%'
     AND a.ROWID <> ( SELECT MIN(b.ROWID) FROM SCM_MST_SHEET_COLUMNS b
                       WHERE b.PROGRAM_ID = a.PROGRAM_ID
                         AND b.SHEET_NAME = a.SHEET_NAME
                         AND b.COLUMN_NAME = a.COLUMN_NAME );
  n_dedup := SQL%ROWCOUNT;

  -- B. 키 변형 구행 → 정본 4키 외 전부 제거 (스코프 = DMF0044 + exchange 계열만)
  DELETE FROM SCM_MST_SHEET_COLUMNS
   WHERE PROGRAM_ID = 'DMF0044'
     AND UPPER(REPLACE(SHEET_NAME, ' ', '')) LIKE '%XCHANGE%'
     AND NOT ( SHEET_NAME = 'exchangeRate'
               AND COLUMN_NAME IN ('DIVISION_ID','CURRENCY','UNIT_CURRENCY','CURRENCY_UNITCURRENCY') );
  n_var := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE('물리 중복 제거 ' || n_dedup || '행 / 변형 제거 ' || n_var || '행');
  COMMIT;
END;
/

-- ────────────────────────────────────────────────────────────────────────────
-- §4. 검증 — 정확히 4행 + 동일키행수 전부 1 이어야 PASS
-- ────────────────────────────────────────────────────────────────────────────
SELECT SHEET_NAME, COLUMN_NAME, VISIBLE_FLAG,
       COUNT(*) OVER (PARTITION BY SHEET_NAME, COLUMN_NAME) AS 동일키행수,
       COUNT(*) OVER () AS 총행수_기대4
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0044'
   AND UPPER(REPLACE(SHEET_NAME, ' ', '')) LIKE '%XCHANGE%'
 ORDER BY SORT_ORDER_NO;

-- (화면) 환율 모달 재오픈 → Div / Currency / Unit 각 1개 확인.
-- 원복이 필요하면: DROP_SHTCOL_EXCH_BAK_20260811 에서 INSERT SELECT.
