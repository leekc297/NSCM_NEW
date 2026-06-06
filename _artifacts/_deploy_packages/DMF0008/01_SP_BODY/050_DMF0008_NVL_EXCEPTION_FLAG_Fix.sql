--==============================================================================
-- 050_DMF0008_NVL_EXCEPTION_FLAG_Fix.sql
--
-- 목적:
--   SUMMARY + REPAIR SP body 의 `EXCEPTION_FLAG != 'Y'` / `NVL(.., NULL) != 'Y'`
--   표현이 NULL row 를 잘못 제외하는 사고 fix.
--
-- 사고:
--   As-Is MSSQL : ISNULL(EXCEPTION_FLAG, '') != 'Y'  -- NULL → '' → '' != 'Y' = TRUE
--   To-Be 잘못   : EXCEPTION_FLAG != 'Y'             -- NULL != 'Y' = UNKNOWN → row 제외
--                NVL(EXCEPTION_FLAG, NULL) != 'Y'    -- NVL(NULL, NULL) = NULL → 동일
--   올바름      : NVL(EXCEPTION_FLAG, 'N') != 'Y'    -- NULL → 'N' → 'N' != 'Y' = TRUE
--
-- DIAG 검증:
--   BMW + div=81 + ERP_STATUS='S' = 152,164 row
--   EXCEPTION_FLAG distribution: 152,164 row 모두 NULL
--   현재 GSCM_MASTER_DATA/SUCCESS/EXCEPTION_CNT 모두 0 (NULL 처리 사고)
--
-- 처치:
--   본 SQL 은 DBMS_METADATA.GET_DDL 로 SP body 추출 → 정확 패턴 patch 안내.
--   실제 ALTER PROCEDURE 는 추출된 DDL 의 `EXCEPTION_FLAG != 'Y'` 부분을
--   `NVL(EXCEPTION_FLAG, 'N') != 'Y'` 로 치환 후 CREATE OR REPLACE.
--
-- ⚠ 주의: 광범위 SP recompile — 사용자 사전 승인 필수.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === BLOCK 1 : SUMMARY SP body 의 EXCEPTION_FLAG 사용 line ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'EXCEPTION_FLAG|EXCEPTION_fLAG', 'i')
 ORDER BY line;

PROMPT === BLOCK 2 : REPAIR SP body 의 EXCEPTION_FLAG 사용 line ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_REPAIR'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'EXCEPTION_FLAG|EXCEPTION_fLAG', 'i')
 ORDER BY line;

PROMPT === BLOCK 3 : 권장 fix 의 직접 query 검증 — BMW row 의 분류 cnt (NVL 'N' 적용) ===

SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN STATUS_CODE IN ('U', 'E') AND NVL(EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END) AS gscm_master_data_fixed,
  SUM(CASE WHEN STATUS_CODE = 'S'         AND NVL(EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END) AS success_cnt_fixed,
  SUM(CASE WHEN NVL(EXCEPTION_FLAG, 'N') = 'Y' THEN 1 ELSE 0 END) AS exception_cnt_fixed
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '81'
   AND SENDER_NAME = 'BMW'
   AND CREATE_DATE >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 52*7, 'YYYYMMDD')
   AND ERP_STATUS = 'S'
   AND LTRIM(RTRIM(YYYYMMDD)) NOT IN ('444444');

PROMPT === 판독 ===
PROMPT - BLOCK 1/2: SUMMARY + REPAIR SP body 의 모든 EXCEPTION_FLAG line 인벤토리
PROMPT - BLOCK 3: NVL(.., 'N') 적용 시 BMW row 의 정상 분류 count
PROMPT   - gscm_master_data_fixed = 31,301 기대 (STATUS_CODE='E' row)
PROMPT   - success_cnt_fixed     = 120,863 기대 (STATUS_CODE='S' row)
PROMPT   - exception_cnt_fixed   = 0       기대 (EXCEPTION_FLAG='Y' row — 모두 NULL)
PROMPT
PROMPT - 본 SQL 은 진단 + 사고 검증만. 실제 SP body recompile 은 별도 060/070 SQL 작성 후 진행.
