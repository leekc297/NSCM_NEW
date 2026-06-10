--==============================================================================
-- 120_DMF0008_i18n_msg_register.sql
--
-- 목적:
--   DMF0008 (ERP EDI Master) 화면 개발 시 추가된 i18n MSG 15 row 를 사내 클라우드 DB
--   (10.20.100.153:2521:ESSCMD) 의 SCM_ADM_MSG_M 에 등록.
--   - MNU_DMF0008 × 3 (KO/EN/CN)
--   - MSG_API_DMF0008_* × 12 (KO)
--
-- 사내 DB 의 SCM_ADM_MSG_M 은 MSG_TP_CD/USE_YN/CREATED_BY/LAST_UPDATED_BY 가 NOT NULL.
-- (Docker DB 는 NULLABLE) — 본 SQL 은 모든 NOT NULL 컬럼을 명시.
--
-- 멱등성: NOT EXISTS 가드 (MSG_ID + LANG_CD).
-- 추출 source: Docker DB SCM_ADM_MSG_M (2026-06-10 기준 15 row).
-- 작성: 2026-06-10
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT === BLOCK 1 : SCM_ADM_MSG_M INSERT (15 row, idempotent) ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M
  (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_DESC, NEW.MSG_TP_CD, NEW.USE_YN, NEW.CREATED_BY, SYSDATE, NEW.LAST_UPDATED_BY, SYSDATE
  FROM (
    SELECT 'MNU_DMF0008' AS MSG_ID, 'KO' AS LANG_CD, 'ERP EDI 마스터' AS MSG_NM, 'ERP EDI 마스터' AS MSG_DESC, 'MNU' AS MSG_TP_CD, 'Y' AS USE_YN, 'admin' AS CREATED_BY, 'admin' AS LAST_UPDATED_BY FROM DUAL UNION ALL
    SELECT 'MNU_DMF0008', 'EN', 'ERP EDI Master', 'ERP EDI Master', 'MNU', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MNU_DMF0008', 'CN', 'ERP EDI 主数据', 'ERP EDI 主数据', 'MNU', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_DIVISION_GET',       'KO', 'My Division 조회',                  'My Division 조회',                  'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_PROJECT_GET',        'KO', 'Project Model 조회',                'Project Model 조회',                'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_PROJECT_SAVE',       'KO', 'Project Model 저장',                'Project Model 저장',                'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_REPAIR_GET',         'KO', 'EDI Master 수정 조회',              'EDI Master 수정 조회',              'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_REPAIR_SAVE',        'KO', 'EDI Master 저장',                   'EDI Master 저장',                   'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_SALES_SITE_GET',     'KO', 'ERP EDI 마스터 Sales Site 조회',     'ERP EDI 마스터 Sales Site 조회',     'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_SITE_GET',           'KO', 'Sales Site 조회',                   'Sales Site 조회',                   'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_SSPM_GET',           'KO', 'ERP EDI 마스터 SSPM 조회',          'ERP EDI 마스터 SSPM 조회',          'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_STATUS_UPDATE',      'KO', 'ERP EDI Status Update 수행',        'ERP EDI Status Update 수행',        'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_SUMMARY_GET',        'KO', 'EDI Master 요약 조회',              'EDI Master 요약 조회',              'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_UPDATE_HISTORY',     'KO', '업데이트 히스토리 조회',             '업데이트 히스토리 조회',             'API', 'Y', 'admin', 'admin' FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0008_UPDATE_HISTORY_GET', 'KO', 'DMF0008 Update History 조회',       'DMF0008 Update History 조회',       'API', 'Y', 'admin', 'admin' FROM DUAL
  ) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X
   WHERE X.MSG_ID = NEW.MSG_ID AND X.LANG_CD = NEW.LANG_CD
);

COMMIT;

PROMPT === BLOCK 2 : VERIFY (등록 결과 — 15 expected) ===

SELECT 'MSG_TOTAL' AS K, COUNT(*) AS C FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = 'MNU_DMF0008' OR MSG_ID LIKE 'MSG_API_DMF0008%'
UNION ALL SELECT 'MNU_DMF0008', COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID = 'MNU_DMF0008'
UNION ALL SELECT 'MSG_API_DMF0008', COUNT(*) FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID LIKE 'MSG_API_DMF0008%';

PROMPT === BLOCK 3 : 상세 출력 ===
SET LINESIZE 300

SELECT MSG_ID, LANG_CD, SUBSTR(MSG_NM, 1, 60) AS MSG_NM, MSG_TP_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID = 'MNU_DMF0008' OR MSG_ID LIKE 'MSG_API_DMF0008%'
 ORDER BY MSG_ID, LANG_CD;

PROMPT === COMPLETE ===
