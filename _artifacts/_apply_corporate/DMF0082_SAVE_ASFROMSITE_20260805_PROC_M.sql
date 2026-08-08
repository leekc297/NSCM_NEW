-- ============================================================================
-- DMF0082 SAVE_MAIN_DATA PROC_M 동기화 — p_as_from_site 신설 (2026-08-05)
--   SP positional: createdBy(16) → asFromSite(17) → o_rc1(18)
--   멱등: asFromSite 기존재 시 무변경. 감사컬럼 'admin' (메타 표준).
-- ============================================================================
UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET SORT_ORD = 18
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA'
   AND COL_NM  = 'o_rc1'
   AND SORT_ORD = 17
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X
                   WHERE X.PROC_NM = 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA'
                     AND X.COL_NM  = 'asFromSite');

INSERT INTO SCM_MGR.SCM_ADM_PROC_M
( PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA', 'asFromSite', 'VARCHAR', 'IN', 17
     , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X
                  WHERE X.PROC_NM = 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA'
                    AND X.COL_NM  = 'asFromSite');

COMMIT;

-- [검증] 기대: 1~17 IN(17=asFromSite) + 18 o_rc1 CURSOR OUT
SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
FROM   SCM_MGR.SCM_ADM_PROC_M
WHERE  PROC_NM = 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA'
ORDER  BY SORT_ORD;
