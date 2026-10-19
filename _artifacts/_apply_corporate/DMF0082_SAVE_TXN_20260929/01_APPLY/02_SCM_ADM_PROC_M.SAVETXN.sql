-- [E20260929-DMF0082SAVETXN] SAVE IN 17종 CLOB 바인딩 (멱등 — 재실행 무해)
UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET DATA_TP_CD = 'CLOB', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA'
   AND COL_TP_CD = 'IN'
   AND COL_NM IN ('activeFlag', 'divisionId', 'projectCode', 'endCustomer', 'scmSiteId', 'itemId', 'domExp', 'fcstType', 'incoterms', 'measure', 'plantSite', 'cellProdSiteId', 'yyyymmdd', 'currency', 'qty', 'createdBy', 'asFromSite');
COMMIT;
