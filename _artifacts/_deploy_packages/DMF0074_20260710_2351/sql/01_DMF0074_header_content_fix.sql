-- =====================================================================
-- DMF0074 Metal Link Price — Excel Upload HEADER_CONTENT 확장
-- 원인: HEADER_CONTENT 가 'Energy' 에서 종료 → 광물 42열(Key/Period/Price/Index)이
--       FileServiceImpl.cvtListUploadJson 단계에서 탈락 → 스테이징 ATTRIBUTE12~ 전부 공백
--       → PKG_DMF0074 배포본 L1334 'NULL APPLY PRICE TYPE CODE.' 발생
-- 전제: ExcelUtils.convertExcelToJson 은 엑셀 1행을 헤더 키로 사용(이름 기반 매핑)
--       → 엑셀 1행은 아래 토큰과 100% 동일한 고유 헤더 1행이어야 함 (2단 병합 헤더 불가)
-- 위치검증: _40 Key=12~18 → GTT ATTRIBUTE14~20 / STD Key=14~20 → GTT ATTRIBUTE14~20
-- =====================================================================

UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
   SET HEADER_CONTENT   = 'Div|Plan Date|Team|End Customer|Model Code|Metal Link|Sales Site|Currency|FCST type|Exception|Energy|Key_Ni|Key_Co|Key_Li2CO3|Key_LIOH|Key_Al|Key_Mn|Key_Cu|PeriodFr_Ni|PeriodFr_Co|PeriodFr_Li2CO3|PeriodFr_LIOH|PeriodFr_Al|PeriodFr_Mn|PeriodFr_Cu|PeriodTo_Ni|PeriodTo_Co|PeriodTo_Li2CO3|PeriodTo_LIOH|PeriodTo_Al|PeriodTo_Mn|PeriodTo_Cu|ContractPrice_Ni|ContractPrice_Co|ContractPrice_Li2CO3|ContractPrice_LIOH|ContractPrice_Al|ContractPrice_Mn|ContractPrice_Cu|ChangePrice_Ni|ChangePrice_Co|ChangePrice_Li2CO3|ChangePrice_LIOH|ChangePrice_Al|ChangePrice_Mn|ChangePrice_Cu|MetalIndex_Ni|MetalIndex_Co|MetalIndex_Li2CO3|MetalIndex_LIOH|MetalIndex_Al|MetalIndex_Mn|MetalIndex_Cu'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0074_40'
   AND SHEET_NAME = 'Metal Link Price';

UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
   SET HEADER_CONTENT   = 'Div|Plan Date|Team|End Customer|Project Code|Project|Model Code|Metal Link|Sales Site|Currency|FCST type|Exception|Energy|Key_Ni|Key_Co|Key_Li2CO3|Key_LIOH|Key_Al|Key_Mn|Key_Cu|PeriodFr_Ni|PeriodFr_Co|PeriodFr_Li2CO3|PeriodFr_LIOH|PeriodFr_Al|PeriodFr_Mn|PeriodFr_Cu|PeriodTo_Ni|PeriodTo_Co|PeriodTo_Li2CO3|PeriodTo_LIOH|PeriodTo_Al|PeriodTo_Mn|PeriodTo_Cu|ContractPrice_Ni|ContractPrice_Co|ContractPrice_Li2CO3|ContractPrice_LIOH|ContractPrice_Al|ContractPrice_Mn|ContractPrice_Cu|ChangePrice_Ni|ChangePrice_Co|ChangePrice_Li2CO3|ChangePrice_LIOH|ChangePrice_Al|ChangePrice_Mn|ChangePrice_Cu|MetalIndex_Ni|MetalIndex_Co|MetalIndex_Li2CO3|MetalIndex_LIOH|MetalIndex_Al|MetalIndex_Mn|MetalIndex_Cu'
     , LAST_UPDATED_BY  = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0074'
   AND SHEET_NAME = 'Metal Link Price';

COMMIT;
