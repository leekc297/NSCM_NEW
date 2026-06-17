-- =================================================================================================
-- ROLLBACK — Step 1 (03_fix_sheet_names.sql) 원복
--
-- 사유 (2026-06-17): PKG_DMF0043 SP body 가 SHEET_NAME='ContributeMain' / 'ContributeSalesList'
-- 를 hardcode 사용 중 → Step 1 UPDATE 후 SP query 0 row → DMF0043 조회 SQL error.
-- SP body 변경은 사용자 BE 변경 회피 정책 위배 → SHEET_COLUMNS 원복 + FE SHEETS enum 정합 으로 대응.
-- =================================================================================================

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'ContributeMain',
       LAST_UPDATE_DATE = SYSDATE,
       LAST_UPDATED_BY  = 'admin'
 WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'main';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'ContributeRate',
       LAST_UPDATE_DATE = SYSDATE,
       LAST_UPDATED_BY  = 'admin'
 WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'ratePopup';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'ContributeSalesList',
       LAST_UPDATE_DATE = SYSDATE,
       LAST_UPDATED_BY  = 'admin'
 WHERE PROGRAM_ID = 'DMF0043' AND SHEET_NAME = 'salesList';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'VersionPopup',
       LAST_UPDATE_DATE = SYSDATE,
       LAST_UPDATED_BY  = 'admin'
 WHERE PROGRAM_ID = 'DMF0043_01' AND SHEET_NAME = 'versionPopup';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'NNMasterMapping',
       LAST_UPDATE_DATE = SYSDATE,
       LAST_UPDATED_BY  = 'admin'
 WHERE PROGRAM_ID = 'DMF0072' AND SHEET_NAME = 'main';

COMMIT;

-- 검증
SELECT PROGRAM_ID, SHEET_NAME, COUNT(*) AS COL_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID IN ('DMF0008', 'DMF0043', 'DMF0043_01', 'DMF0072')
 GROUP BY PROGRAM_ID, SHEET_NAME
 ORDER BY PROGRAM_ID, SHEET_NAME;
