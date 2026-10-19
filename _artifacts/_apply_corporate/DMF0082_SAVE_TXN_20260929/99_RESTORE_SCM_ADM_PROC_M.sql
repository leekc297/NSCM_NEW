-- [E20260929-DMF0082SAVETXN] 원복: SAVE IN 17종 VARCHAR 복귀
UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET DATA_TP_CD = 'VARCHAR', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA'
   AND COL_TP_CD = 'IN'
   AND COL_NM IN ('activeFlag', 'divisionId', 'projectCode', 'endCustomer', 'scmSiteId', 'itemId', 'domExp', 'fcstType', 'incoterms', 'measure', 'plantSite', 'cellProdSiteId', 'yyyymmdd', 'currency', 'qty', 'createdBy', 'asFromSite');
COMMIT;
