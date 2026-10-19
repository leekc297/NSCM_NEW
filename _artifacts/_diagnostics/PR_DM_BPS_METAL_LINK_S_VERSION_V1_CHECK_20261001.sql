-- =====================================================================================================
-- PR_DM_BPS_METAL_LINK_S — VERSION_NO 가 '..._V1' (2자리 아님) 로 생성되는 원인 확인 (읽기 전용, 클라우드 SCM_MGR 에서 실행)
--   채번식: VERSION_NO = VERSION_NO_T('26RF_DM_2026_W40_V') || NVL(GT_DBML_VERSION_SEQ.VERSION_SEQ, '01')
--           VERSION_SEQ 는 LPAD(seq, 2, '0') 로 넣지만 GTT 컬럼이 NUMBER 이면 '02' → 2 로 저장되고,
--           NVL(NUMBER, '01') 의 결과형도 NUMBER → '01' 이 1 이 되어 '..._V1' / '..._V2' 로 붙는다.
-- =====================================================================================================

-- [1] GTT 컬럼 타입 — NUMBER 이면 원인 확정 (사내 ZIOUI1 = NUMBER)
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH
  FROM ALL_TAB_COLUMNS
 WHERE OWNER = 'SCM_MGR' AND TABLE_NAME = 'GT_DBML_VERSION_SEQ'
 ORDER BY COLUMN_ID;

-- [2] 같은 식의 재현 — FIRST_RUN 이 '..._V1' 이면 이 DB 에서는 TO-BE 실행분이 항상 한 자리로 생성됨
SELECT '26RF_DM_2026_W40_V' || NVL(CAST(NULL AS NUMBER), '01')            AS FIRST_RUN
     , '26RF_DM_2026_W40_V' || NVL(TO_NUMBER(LPAD('2', 2, '0')), '01')    AS SECOND_RUN
  FROM DUAL;

-- [3] 프로시저 판본 + 채번 줄 원문
SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') LAST_DDL, STATUS
  FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PR_DM_BPS_METAL_LINK_S';
SELECT LINE, TRIM(TEXT) TEXT FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR' AND NAME = 'PR_DM_BPS_METAL_LINK_S'
   AND (UPPER(TEXT) LIKE '%VERSION_SEQ%' OR UPPER(TEXT) LIKE '%VERSION_NO_T ||%')
 ORDER BY LINE;

-- [4] 적재 원장의 버전번호 형태 — 2자리(V99) = AS-IS 이관분 / 1자리(V9) = TO-BE 실행분
SELECT REGEXP_REPLACE(VERSION_NO, '[0-9]', '9') PATTERN
     , COUNT(DISTINCT VERSION_NO)                VERSIONS
     , MIN(VERSION_NO) MIN_VER, MAX(VERSION_NO) MAX_VER
  FROM XIF_BPS_METAL_LINK_PRICE_S_SN
 GROUP BY REGEXP_REPLACE(VERSION_NO, '[0-9]', '9')
 ORDER BY 1;

-- [5] 한 자리 버전의 상세 (언제·어느 사업부)
SELECT DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, MIN(IFDATE) IFDATE, COUNT(*) CNT
  FROM XIF_BPS_METAL_LINK_PRICE_S_SN
 WHERE REGEXP_LIKE(VERSION_NO, '_V[0-9]$')
 GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD
 ORDER BY VERSION_NO;
