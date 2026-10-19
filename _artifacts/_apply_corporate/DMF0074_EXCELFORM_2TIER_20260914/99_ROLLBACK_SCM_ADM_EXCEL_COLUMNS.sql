-- 원복: 2026-09-14 적용 전 HEADER_CONTENT (사내 ZIOUI1 실측)
UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
   SET HEADER_CONTENT = 'Div|Plan Date|Team|End Customer|Project Code|Project|Model Code|Metal Link|Sales Site|Currency|FCST type|Exception|Energy|Key_Ni|Key_Co|Key_Li2CO3|Key_LIOH|Key_Al|Key_Mn|Key_Cu|PeriodFr_Ni|PeriodFr_Co|PeriodFr_Li2CO3|PeriodFr_LIOH|PeriodFr_Al|PeriodFr_Mn|PeriodFr_Cu|PeriodTo_Ni|PeriodTo_Co|PeriodTo_Li2CO3|PeriodTo_LIOH|PeriodTo_Al|PeriodTo_Mn|PeriodTo_Cu|ContractPrice_Ni|ContractPrice_Co|ContractPrice_Li2CO3|ContractPrice_LIOH|ContractPrice_Al|ContractPrice_Mn|ContractPrice_Cu|ChangePrice_Ni|ChangePrice_Co|ChangePrice_Li2CO3|ChangePrice_LIOH|ChangePrice_Al|ChangePrice_Mn|ChangePrice_Cu|MetalIndex_Ni|MetalIndex_Co|MetalIndex_Li2CO3|MetalIndex_LIOH|MetalIndex_Al|MetalIndex_Mn|MetalIndex_Cu'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0074' AND SHEET_NAME = 'Metal Link Price'; -- ROLLBACK E20260914-EXCELFORM2TIER
UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
   SET HEADER_CONTENT = 'Div|Plan Date|Team|End Customer|Model Code|Metal Link|Sales Site|Currency|FCST type|Exception|Energy|Key_Ni|Key_Co|Key_Li2CO3|Key_LIOH|Key_Al|Key_Mn|Key_Cu|PeriodFr_Ni|PeriodFr_Co|PeriodFr_Li2CO3|PeriodFr_LIOH|PeriodFr_Al|PeriodFr_Mn|PeriodFr_Cu|PeriodTo_Ni|PeriodTo_Co|PeriodTo_Li2CO3|PeriodTo_LIOH|PeriodTo_Al|PeriodTo_Mn|PeriodTo_Cu|ContractPrice_Ni|ContractPrice_Co|ContractPrice_Li2CO3|ContractPrice_LIOH|ContractPrice_Al|ContractPrice_Mn|ContractPrice_Cu|ChangePrice_Ni|ChangePrice_Co|ChangePrice_Li2CO3|ChangePrice_LIOH|ChangePrice_Al|ChangePrice_Mn|ChangePrice_Cu|MetalIndex_Ni|MetalIndex_Co|MetalIndex_Li2CO3|MetalIndex_LIOH|MetalIndex_Al|MetalIndex_Mn|MetalIndex_Cu'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0074_40' AND SHEET_NAME = 'Metal Link Price'; -- ROLLBACK E20260914-EXCELFORM2TIER
COMMIT;
