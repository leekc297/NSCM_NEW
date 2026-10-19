-- SCM_ADM_EXCEL_COLUMNS DMF0074 / DMF0074_40 — 사내 현재 값 목표상태 (멱등 · 비파괴 · 사전값 WHERE 없음)
-- ⚠ BE(ExcelUtils/FileServiceImpl 2단 파싱)와 동시 반영 — 구 BE 에서는 'Period(Fr)_Ni' 토큰을 못 찾아 메탈 열이 탈락한다
SET DEFINE OFF
MERGE INTO SCM_MGR.SCM_ADM_EXCEL_COLUMNS T
USING (SELECT 'DMF0074' PROGRAM_ID, 'Metal Link Price' SHEET_NAME, 'PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD' STORAGE_SQL_ID, 'Div|Plan Date|Team|End Customer|Project Code|Project|Model Code|Metal Link|Sales Site|Currency|FCST type|Exception|Energy|Key_Ni|Key_Co|Key_Li2CO3|Key_LIOH|Key_Al|Key_Mn|Key_Cu|Period(Fr)_Ni|Period(Fr)_Co|Period(Fr)_Li2CO3|Period(Fr)_LIOH|Period(Fr)_Al|Period(Fr)_Mn|Period(Fr)_Cu|Period(To)_Ni|Period(To)_Co|Period(To)_Li2CO3|Period(To)_LIOH|Period(To)_Al|Period(To)_Mn|Period(To)_Cu|Contract Price(/kg)_Ni|Contract Price(/kg)_Co|Contract Price(/kg)_Li2CO3|Contract Price(/kg)_LIOH|Contract Price(/kg)_Al|Contract Price(/kg)_Mn|Contract Price(/kg)_Cu|Change Price(/kg)_Ni|Change Price(/kg)_Co|Change Price(/kg)_Li2CO3|Change Price(/kg)_LIOH|Change Price(/kg)_Al|Change Price(/kg)_Mn|Change Price(/kg)_Cu|Metal Index (kg/Biz type)_Ni|Metal Index (kg/Biz type)_Co|Metal Index (kg/Biz type)_Li2CO3|Metal Index (kg/Biz type)_LIOH|Metal Index (kg/Biz type)_Al|Metal Index (kg/Biz type)_Mn|Metal Index (kg/Biz type)_Cu' HEADER_CONTENT, 70 OPTION_ATTRIBUTE_COLUMN_NUMBER, 'Y' VALID_YN FROM DUAL) S
ON (T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME)
WHEN MATCHED THEN UPDATE SET T.STORAGE_SQL_ID = S.STORAGE_SQL_ID, T.HEADER_CONTENT = S.HEADER_CONTENT,
     T.OPTION_ATTRIBUTE_COLUMN_NUMBER = S.OPTION_ATTRIBUTE_COLUMN_NUMBER, T.VALID_YN = S.VALID_YN,
     T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT, OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
     VALUES (S.PROGRAM_ID, S.SHEET_NAME, S.STORAGE_SQL_ID, S.HEADER_CONTENT, S.OPTION_ATTRIBUTE_COLUMN_NUMBER, S.VALID_YN, 'admin', SYSDATE, 'admin', SYSDATE);
MERGE INTO SCM_MGR.SCM_ADM_EXCEL_COLUMNS T
USING (SELECT 'DMF0074_40' PROGRAM_ID, 'Metal Link Price' SHEET_NAME, 'PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD' STORAGE_SQL_ID, 'Div|Plan Date|Team|End Customer|Model Code|Metal Link|Sales Site|Currency|FCST type|Exception|Energy|Key_Ni|Key_Co|Key_Li2CO3|Key_LIOH|Key_Al|Key_Mn|Key_Cu|Period(Fr)_Ni|Period(Fr)_Co|Period(Fr)_Li2CO3|Period(Fr)_LIOH|Period(Fr)_Al|Period(Fr)_Mn|Period(Fr)_Cu|Period(To)_Ni|Period(To)_Co|Period(To)_Li2CO3|Period(To)_LIOH|Period(To)_Al|Period(To)_Mn|Period(To)_Cu|Contract Price(/kg)_Ni|Contract Price(/kg)_Co|Contract Price(/kg)_Li2CO3|Contract Price(/kg)_LIOH|Contract Price(/kg)_Al|Contract Price(/kg)_Mn|Contract Price(/kg)_Cu|Change Price(/kg)_Ni|Change Price(/kg)_Co|Change Price(/kg)_Li2CO3|Change Price(/kg)_LIOH|Change Price(/kg)_Al|Change Price(/kg)_Mn|Change Price(/kg)_Cu|Metal Index (kg/Biz type)_Ni|Metal Index (kg/Biz type)_Co|Metal Index (kg/Biz type)_Li2CO3|Metal Index (kg/Biz type)_LIOH|Metal Index (kg/Biz type)_Al|Metal Index (kg/Biz type)_Mn|Metal Index (kg/Biz type)_Cu' HEADER_CONTENT, 70 OPTION_ATTRIBUTE_COLUMN_NUMBER, 'Y' VALID_YN FROM DUAL) S
ON (T.PROGRAM_ID = S.PROGRAM_ID AND T.SHEET_NAME = S.SHEET_NAME)
WHEN MATCHED THEN UPDATE SET T.STORAGE_SQL_ID = S.STORAGE_SQL_ID, T.HEADER_CONTENT = S.HEADER_CONTENT,
     T.OPTION_ATTRIBUTE_COLUMN_NUMBER = S.OPTION_ATTRIBUTE_COLUMN_NUMBER, T.VALID_YN = S.VALID_YN,
     T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, HEADER_CONTENT, OPTION_ATTRIBUTE_COLUMN_NUMBER, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
     VALUES (S.PROGRAM_ID, S.SHEET_NAME, S.STORAGE_SQL_ID, S.HEADER_CONTENT, S.OPTION_ATTRIBUTE_COLUMN_NUMBER, S.VALID_YN, 'admin', SYSDATE, 'admin', SYSDATE);
COMMIT;
