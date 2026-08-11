-- ============================================================================
-- DMF0044 클라우드 이관 — 신규 CMBO 2종 등록 (2026-08-10)
--   AS-IS `.cs` 런타임 SetCellTypeCombo(DEPT_ID 3분기) 이관에 필요한 원천 콤보.
--   AS-IS 메타(SHEET_COLUMNS)에는 이 컬럼 자체가 없으므로 TO-BE 는 화면 단위로 받아
--   beginningEdit 에서 행 컨텍스트로 골라 스왑한다(hook #59 §5-G).
--
--   ⛔ MERGE INTO / DELETE 금지 — **INSERT-only + 멱등(NOT EXISTS)** (hook #98 §9)
--   ⭐ 감사 컬럼 = 'admin' 고정 (feedback_meta_audit_column_admin_only)
--   사내 원본: OCGSCMD_P01 SCM_MGR.SCM_ADM_CMBO_SQL_M (2026-08-09 21:07 등록분 live 덤프)
-- ============================================================================
SET DEFINE OFF;

-- ── DMF0044_DEPARTMENT_TEAM ─────────────────────────────────────────────────────────────
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
       (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0044_DEPARTMENT_TEAM', 'DM',
       '[C] AS-IS UP_FX DMF0044_DEPARTMENT_TEAM — Dept→Team (superset+클라 cascade, 부모키 동반)',
       'SELECT D.DEPT_ID AS CODE
     , D.DEPT_NAME_KO AS NAME
     , D.UPPER_DEPT_ID AS DEPARTMENT_ID
  FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO D
 WHERE D.VALID_YN = ''Y''
   AND D.UPPER_DEPT_ID IS NOT NULL
 ORDER BY D.DEPT_NAME_KO',
       'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DMF0044_DEPARTMENT_TEAM');

-- ── DMF0044_ETC_SALE_RESULT_TYPE_40 ─────────────────────────────────────────────────────────────
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
       (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0044_ETC_SALE_RESULT_TYPE_40', 'DM',
       '[C] AS-IS UP_FX DMF0044_ETC_SALE_RESULT_TYPE_40 — DEPARTMENT_ID=''기타'' 시 DEPT_ID 후보',
       'SELECT L.SEGMENT1 AS CODE
     , L.SEGMENT2 AS NAME
  FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
 WHERE L.LOOKUP_TYPE = ''DMF0044_ETC_SALE_RESULT_TYPE_40''
   AND L.VALID_YN = ''Y''',
       'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'DMF0044_ETC_SALE_RESULT_TYPE_40');

COMMIT;

-- 확인 (기대 2행)
SELECT SQL_ID, MDU_DIVS_CD, USE_YN, CREATED_BY
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID IN ('DMF0044_DEPARTMENT_TEAM','DMF0044_ETC_SALE_RESULT_TYPE_40')
 ORDER BY SQL_ID;
