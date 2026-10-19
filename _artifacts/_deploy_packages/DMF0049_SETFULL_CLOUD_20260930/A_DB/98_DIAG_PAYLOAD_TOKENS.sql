-- 98_DIAG_PAYLOAD_TOKENS.sql — 실패한 저장 호출의 세트 식별 토큰이 행마다 같은지 (READ-ONLY) [E20260930-DMF0049SETFULL]
SET LINESIZE 250 PAGESIZE 200 LONG 4000
COLUMN K FORMAT A22
COLUMN TOKENS FORMAT A200
WITH L AS (
  SELECT SYS_LOG_MSG_CTN M FROM SCM_COM_SYS_LOG
   WHERE MNU_ID='DMF0049' AND EXCT_MSG_CTN LIKE '%ORA-00001%' AND CREATION_DATE >= SYSDATE - 1
   ORDER BY TRNM_ST_DTM DESC FETCH FIRST 1 ROWS ONLY)
SELECT K, REGEXP_SUBSTR(M, '"' || K || '":"([^"]*)"', 1, 1, NULL, 1) TOKENS
  FROM L, ( SELECT COLUMN_VALUE K FROM TABLE(SYS.ODCIVARCHAR2LIST(
            'departmentId','departmentEditFlag','departmentName','deptId','custReport','endCustReport','soldtoCode','soldtoCustReport',
            'productGroup','itemId','productDetails','currency','companyId','bizType','applicationGr','application','countryCode',
            'projectCode','scmSiteId','fcstType','itemUse','soldtoCountry','shiptoCountry','endCustomer','etcDescr','cellModelInfo','cellModel',
            'resultMonth','dataSeq','measure','yyyymmdd','qty','activeFlag')) );
