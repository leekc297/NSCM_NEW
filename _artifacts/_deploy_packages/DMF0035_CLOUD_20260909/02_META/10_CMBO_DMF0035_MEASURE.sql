-- ============================================================
-- DMF0035 MEASURE 셀 콤보 3종 (시트 한정) — 멱등 MERGE
--   공유 콤보 'Measure' 는 건드리지 않는다(26컬럼/16프로그램 무영향).
--   AS-IS UP_FX_GetCommonDataList @Code='Measure' L2155~2156 =
--     PROGRAM_ID = @Param1 AND SHEET_NAME = @Param2  ← TO-BE 공유본은 SHEET_NAME 누락
-- ============================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET SCAN OFF

MERGE INTO SCM_ADM_CMBO_SQL_M T
USING (SELECT 'DMF0035_MKT_Measure' AS SQL_ID, 'DM' AS MDU_DIVS_CD, '[C] AS-IS @Code=''Measure'' + SHEET_NAME 필터 복원 (DMF0035 MKT FCST 전용)' AS SQL_NM,
              'SELECT DISTINCT A.COLUMN_NAME AS CODE, CASE WHEN A.COLUMN_NAME = ''CUST_FCST_EDI_ORG'' THEN '' └ '' || ''EDI[Org.]'' WHEN A.COLUMN_NAME = ''CUST_FCST_EDI'' THEN '' └ '' || ''EDI'' ELSE A.COLUMN_LABEL_NAME END AS NAME FROM SCM_MGR.SCM_MST_SHEET_MEASURE A WHERE A.PROGRAM_ID = @mnuId AND A.SHEET_NAME = ''Mkt Fcst Waterfall'' AND A.VALID_YN = ''Y'' UNION ALL SELECT MEASURE AS CODE, '' └ '' || MEASURE AS NAME FROM SCM_MGR.DM_MST_CUSTOMER_FCST WHERE VALID_YN = ''Y'' AND MEASURE IS NOT NULL AND MEASURE_GROUP = ''CUST_FCST'' AND @mnuId IN (''DMF0003'', ''DMF0035'', ''DMF0003_TEST'') GROUP BY MEASURE UNION ALL SELECT ''Immidiate'', ''    └ '' || ''Immidiate'' FROM DUAL UNION ALL SELECT ''Planning_Forecast'', ''    └ '' || ''Planning_Forecast'' FROM DUAL UNION ALL SELECT ''Commercial_Agreement'', ''    └ '' || ''Commercial_Agreement'' FROM DUAL UNION ALL SELECT ''Firm_Temp'', ''    └ '' || ''Firm_Temp'' FROM DUAL UNION ALL SELECT ''Manumacturing_Material_Temp'', ''    └ '' || ''Manumacturing_Material_Temp'' FROM DUAL UNION ALL SELECT ''Material_Temp'', ''    └ '' || ''Material_Temp'' FROM DUAL UNION ALL SELECT ''Backorder'', ''    └ '' || ''Backorder'' FROM DUAL UNION ALL SELECT ''Cust.FCST_EXCEL[P+P]'', '' └ '' || ''EXCEL'' FROM DUAL UNION ALL SELECT ''Cust.FCST_RPA[P+P]'', '' └ '' || ''RPA'' FROM DUAL UNION ALL SELECT ''Immidiate[Org.]'', ''    └ '' || ''Immidiate[Org.]'' FROM DUAL UNION ALL SELECT ''Planning_Forecast[Org.]'', ''    └ '' || ''Planning_Forecast[Org.]'' FROM DUAL UNION ALL SELECT ''Commercial_Agreement[Org.]'', ''    └ '' || ''Commercial_Agreement[Org.]'' FROM DUAL UNION ALL SELECT ''Firm_Temp[Org.]'', ''    └ '' || ''Firm_Temp[Org.]'' FROM DUAL UNION ALL SELECT ''Manumacturing_Material_Temp[Org.]'', ''    └ '' || ''Manumacturing_Material_Temp[Org.]'' FROM DUAL UNION ALL SELECT ''Material_Temp[Org.]'', ''    └ '' || ''Material_Temp[Org.]'' FROM DUAL UNION ALL SELECT ''Backorder[Org.]'', ''    └ '' || ''Backorder[Org.]'' FROM DUAL UNION ALL SELECT ''Cust.FCST_EXCEL[Org.]'', '' └ '' || ''EXCEL[Org.]'' FROM DUAL UNION ALL SELECT ''Cust.FCST_RPA[Org.]'', '' └ '' || ''RPA[Org.]'' FROM DUAL UNION ALL SELECT ''Cust.FCST_EXCEL'', '' └ '' || ''EXCEL'' FROM DUAL UNION ALL SELECT ''Cust.FCST_RPA'', '' └ '' || ''RPA'' FROM DUAL UNION ALL SELECT ''Ship Plan'', ''Ship Plan'' FROM DUAL UNION ALL SELECT ''CUST_FCST_EDI'', '' └ '' || ''EDI'' FROM DUAL' AS SQL_DTL_CTN, 'Y' AS USE_YN FROM DUAL) S
   ON (T.SQL_ID = S.SQL_ID)
 WHEN MATCHED THEN UPDATE SET T.SQL_NM=S.SQL_NM, T.SQL_DTL_CTN=S.SQL_DTL_CTN,
        T.USE_YN=S.USE_YN, T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
 WHEN NOT MATCHED THEN INSERT (SQL_ID,MDU_DIVS_CD,SQL_NM,SQL_DTL_CTN,USE_YN,
        CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
   VALUES (S.SQL_ID,S.MDU_DIVS_CD,S.SQL_NM,S.SQL_DTL_CTN,S.USE_YN,
        'admin',SYSDATE,'admin',SYSDATE);

MERGE INTO SCM_ADM_CMBO_SQL_M T
USING (SELECT 'DMF0035_SP_Measure' AS SQL_ID, 'DM' AS MDU_DIVS_CD, '[C] AS-IS @Code=''Measure'' + SHEET_NAME 필터 복원 (DMF0035 SALES PLAN 전용)' AS SQL_NM,
              'SELECT DISTINCT A.COLUMN_NAME AS CODE, CASE WHEN A.COLUMN_NAME = ''CUST_FCST_EDI_ORG'' THEN '' └ '' || ''EDI[Org.]'' WHEN A.COLUMN_NAME = ''CUST_FCST_EDI'' THEN '' └ '' || ''EDI'' ELSE A.COLUMN_LABEL_NAME END AS NAME FROM SCM_MGR.SCM_MST_SHEET_MEASURE A WHERE A.PROGRAM_ID = @mnuId AND A.SHEET_NAME = ''Sales Plan Waterfall'' AND A.VALID_YN = ''Y'' UNION ALL SELECT MEASURE AS CODE, '' └ '' || MEASURE AS NAME FROM SCM_MGR.DM_MST_CUSTOMER_FCST WHERE VALID_YN = ''Y'' AND MEASURE IS NOT NULL AND MEASURE_GROUP = ''CUST_FCST'' AND @mnuId IN (''DMF0003'', ''DMF0035'', ''DMF0003_TEST'') GROUP BY MEASURE UNION ALL SELECT ''Immidiate'', ''    └ '' || ''Immidiate'' FROM DUAL UNION ALL SELECT ''Planning_Forecast'', ''    └ '' || ''Planning_Forecast'' FROM DUAL UNION ALL SELECT ''Commercial_Agreement'', ''    └ '' || ''Commercial_Agreement'' FROM DUAL UNION ALL SELECT ''Firm_Temp'', ''    └ '' || ''Firm_Temp'' FROM DUAL UNION ALL SELECT ''Manumacturing_Material_Temp'', ''    └ '' || ''Manumacturing_Material_Temp'' FROM DUAL UNION ALL SELECT ''Material_Temp'', ''    └ '' || ''Material_Temp'' FROM DUAL UNION ALL SELECT ''Backorder'', ''    └ '' || ''Backorder'' FROM DUAL UNION ALL SELECT ''Cust.FCST_EXCEL[P+P]'', '' └ '' || ''EXCEL'' FROM DUAL UNION ALL SELECT ''Cust.FCST_RPA[P+P]'', '' └ '' || ''RPA'' FROM DUAL UNION ALL SELECT ''Immidiate[Org.]'', ''    └ '' || ''Immidiate[Org.]'' FROM DUAL UNION ALL SELECT ''Planning_Forecast[Org.]'', ''    └ '' || ''Planning_Forecast[Org.]'' FROM DUAL UNION ALL SELECT ''Commercial_Agreement[Org.]'', ''    └ '' || ''Commercial_Agreement[Org.]'' FROM DUAL UNION ALL SELECT ''Firm_Temp[Org.]'', ''    └ '' || ''Firm_Temp[Org.]'' FROM DUAL UNION ALL SELECT ''Manumacturing_Material_Temp[Org.]'', ''    └ '' || ''Manumacturing_Material_Temp[Org.]'' FROM DUAL UNION ALL SELECT ''Material_Temp[Org.]'', ''    └ '' || ''Material_Temp[Org.]'' FROM DUAL UNION ALL SELECT ''Backorder[Org.]'', ''    └ '' || ''Backorder[Org.]'' FROM DUAL UNION ALL SELECT ''Cust.FCST_EXCEL[Org.]'', '' └ '' || ''EXCEL[Org.]'' FROM DUAL UNION ALL SELECT ''Cust.FCST_RPA[Org.]'', '' └ '' || ''RPA[Org.]'' FROM DUAL UNION ALL SELECT ''Cust.FCST_EXCEL'', '' └ '' || ''EXCEL'' FROM DUAL UNION ALL SELECT ''Cust.FCST_RPA'', '' └ '' || ''RPA'' FROM DUAL UNION ALL SELECT ''Ship Plan'', ''Ship Plan'' FROM DUAL UNION ALL SELECT ''CUST_FCST_EDI'', '' └ '' || ''EDI'' FROM DUAL' AS SQL_DTL_CTN, 'Y' AS USE_YN FROM DUAL) S
   ON (T.SQL_ID = S.SQL_ID)
 WHEN MATCHED THEN UPDATE SET T.SQL_NM=S.SQL_NM, T.SQL_DTL_CTN=S.SQL_DTL_CTN,
        T.USE_YN=S.USE_YN, T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
 WHEN NOT MATCHED THEN INSERT (SQL_ID,MDU_DIVS_CD,SQL_NM,SQL_DTL_CTN,USE_YN,
        CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
   VALUES (S.SQL_ID,S.MDU_DIVS_CD,S.SQL_NM,S.SQL_DTL_CTN,S.USE_YN,
        'admin',SYSDATE,'admin',SYSDATE);

MERGE INTO SCM_ADM_CMBO_SQL_M T
USING (SELECT 'DMF0035_BP_Measure' AS SQL_ID, 'DM' AS MDU_DIVS_CD, '[C] BP Measure — 축 통일(PROGRAM_ID=DMF0035 / Biz Plan Waterfall)' AS SQL_NM,
              'SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID = ''DMF0035'' AND SHEET_NAME = ''Biz Plan Waterfall'' AND (NVL(TRIM(@divisionId), ''-'') = ''-'' OR INSTR('','' || DIVISION_ID || '','', '','' || @divisionId || '','') > 0) ORDER BY SORT_ORDER_NO' AS SQL_DTL_CTN, 'Y' AS USE_YN FROM DUAL) S
   ON (T.SQL_ID = S.SQL_ID)
 WHEN MATCHED THEN UPDATE SET T.SQL_NM=S.SQL_NM, T.SQL_DTL_CTN=S.SQL_DTL_CTN,
        T.USE_YN=S.USE_YN, T.LAST_UPDATED_BY='admin', T.LAST_UPDATE_DATE=SYSDATE
 WHEN NOT MATCHED THEN INSERT (SQL_ID,MDU_DIVS_CD,SQL_NM,SQL_DTL_CTN,USE_YN,
        CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
   VALUES (S.SQL_ID,S.MDU_DIVS_CD,S.SQL_NM,S.SQL_DTL_CTN,S.USE_YN,
        'admin',SYSDATE,'admin',SYSDATE);

COMMIT;
