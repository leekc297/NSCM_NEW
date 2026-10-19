# FP02550 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP02550_Operation_Bod.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1991 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP02550_Operation_Bod.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 986 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP02550_ExcelImportPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1029 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP02550_ExcelImportPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 509 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 292 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 298 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 304 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 310 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 321 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 331 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 341 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 350 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 292 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 298 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 304 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 310 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 321 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 331 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 341 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged > SetChangedControl | 350 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 292 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 298 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 304 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 310 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 321 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 331 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 341 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangedControl | 350 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 292 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 298 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 304 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 310 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 321 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 331 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 341 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangedControl | 350 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 292 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 298 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 304 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 310 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 321 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 331 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 341 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangedControl | 350 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Main > Find_Data_Main | 1208 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| button:FindButton | FindButton > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 1335 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| event:popSql.OnSql | RunSqlSource > Find_Data_Main | 1208 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| button:SaveButton | SaveButton > Save_Main > Find_Main > Find_Data_Main | 1208 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| button:SaveButton | SaveButton > Save_Sub > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 1335 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| button:SaveButton | SaveButton > Save_Sub > Save_Data_Execute | 1670 | FP_Master.PR_UI_FP02550_SAVE | MATCH | SP PR_UI_FP02550_SAVE |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > Find_Main > Find_Data_Main | 1208 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 1335 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| event:this.btnSearchAll.Click | btnSearchAll_Click > Find_Data_Sub > Find_Data_Sub_Execute | 1335 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| event:this.btnSubImport.Click | btnSubImport_Click > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 1335 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| event:this.Load | Form_Load > InitControls | 234 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 237 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 242 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 247 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 251 | biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 292 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 298 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 304 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 310 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 321 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 331 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 341 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 350 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 1335 | FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | SP PR_UI_FP02550_OPERATION_BOD |
| unreached:(진입점 미연결) | ExcelImport_Main_SaveDataDelegate | 943 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_SaveDataDelegate | 943 | FP\Master\FP02550_OperationBod#merge_FP02550 | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 962 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 962 | FP\MASTER\FP02550_OperationBod#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 965 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 965 | FP\MASTER\FP02550_OperationBod#insert_Excel_buffer | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 966 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 966 | FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation.sql |
| unreached:(진입점 미연결) | ExcelImport_Sub_SaveDataDelegate | 990 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550_Sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_SaveDataDelegate | 990 | FP\Master\FP02550_OperationBod#merge_FP02550_Sub | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 1006 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 1006 | FP\MASTER\FP02550_OperationBod#delete_Excel_buffer_sub | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer_sub.sql |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 1009 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 1009 | FP\MASTER\FP02550_OperationBod#insert_Excel_buffer_sub | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 1010 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 1010 | FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation_sub | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation_sub.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550_Sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP02550_OPERATION_BOD | MATCH | 2 | SP PR_UI_FP02550_OPERATION_BOD | EXEC:PR_UI_FP02550_OPERATION_BOD | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP02550_SAVE | MATCH | 1 | SP PR_UI_FP02550_SAVE | EXEC:PR_UI_FP02550_SAVE | ⚠ DB에 SP 없음 |
| FP\MASTER\FP02550_OperationBod#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer.sql | DELETE:BUF_OPERATION_MOVE_M |  |
| FP\MASTER\FP02550_OperationBod#delete_Excel_buffer_sub | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer_sub.sql | DELETE:BUF_ITEM_FLOW_EXCEPT_M |  |
| FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation.sql | SELECT:BUF_OPERATION_MOVE_M, SELECT:SCM_FACTORY_M, SELECT:SCM_OPERATION_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation_sub | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation_sub.sql | SELECT:BUF_ITEM_FLOW_EXCEPT_M, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_FACTORY_M, SELECT:SCM_OPERATION_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\MASTER\FP02550_OperationBod#insert_Excel_buffer | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP02550_OperationBod#insert_Excel_buffer_sub | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP02550_OperationBod#merge_FP02550 | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP02550_OperationBod#merge_FP02550_Sub | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelUpload_Click | Application.OpenForms | FP02550_ExcelImportPopup |
| btnExcelUpload_Click | Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, EXCEL_VIEW |
| btnExcelUpload_Click | p.KeyColumns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, MODEL_TYPE, LINE_ATTR_1 |
| btnExcelUpload_Click | p.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_TYPE, OPERATION_ID, LINE_ATTR_1, OPERATION_LOT_SIZE, MIN_LOT_SIZE, LOT_SIZE_UOM, TRANSFER_LOT_SIZE, TRANSFER_LOT_SIZE_UOM, PRECEDE_PRODUCING_TERM, PRECEDE_PRODUCING_TERM_UOM, BUFFER_TIME, BUFFER_TIME_UOM, TAT, TAT_UOM, OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM, TOLERANCE, TOLERANCE_UOM, MESSAGE, INITIAL_PRODUCING_LEAD_TIME, INITIAL_PRODUCING_LEAD_TIME_UOM, ACTIVE_FLAG, DESCRIPTION |
| btnExcelUpload_Click | p.ColumnWidth | INITIAL_PRODUCING_LEAD_TIME, INITIAL_PRODUCING_LEAD_TIME_UOM, ACTIVE_FLAG, DESCRIPTION, EDIT_YN |
| btnExcelUpload_Click | p.ColumnBgColor | OPERATION_LOT_SIZE, MIN_LOT_SIZE, LOT_SIZE_UOM, TRANSFER_LOT_SIZE, TRANSFER_LOT_SIZE_UOM, PRECEDE_PRODUCING_TERM, BUFFER_TIME, TAT, OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM, TOLERANCE, TOLERANCE_UOM |
| btnSubImport_Click | Application.OpenForms | FP02550_ExcelImportPopup |
| btnSubImport_Click | Filter | p_company_id, p_division_id, p_site_id, p_plant_id, p_factory_id, p_operation_id, EXCEL_VIEW |
| btnSubImport_Click | p.KeyColumns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, MODEL_TYPE, LINE_ATTR_1, ITEM_ID |
| btnSubImport_Click | p.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_TYPE, OPERATION_ID, LINE_ATTR_1, ITEM_ID, NICK_NAME, OPERATION_LOT_SIZE, MIN_LOT_SIZE, LOT_SIZE_UOM, TRANSFER_LOT_SIZE, TRANSFER_LOT_SIZE_UOM, PRECEDE_PRODUCING_TERM, PRECEDE_PRODUCING_TERM_UOM, BUFFER_TIME, BUFFER_TIME_UOM, TAT, TAT_UOM, OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM, TOLERANCE, TOLERANCE_UOM, MESSAGE, INITIAL_PRODUCING_LEAD_TIME, INITIAL_PRODUCING_LEAD_TIME_UOM, ACTIVE_FLAG, DESCRIPTION |
| btnSubImport_Click | p.ColumnWidth | TAT_FLAG, INITIAL_PRODUCING_LEAD_TIME, INITIAL_PRODUCING_LEAD_TIME_UOM, ACTIVE_FLAG, DESCRIPTION, EDIT_YN |
| btnSubImport_Click | p.ColumnBgColor | OPERATION_LOT_SIZE, MIN_LOT_SIZE, LOT_SIZE_UOM, TRANSFER_LOT_SIZE, TRANSFER_LOT_SIZE_UOM, PRECEDE_PRODUCING_TERM, BUFFER_TIME, TAT, OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM, TOLERANCE, TOLERANCE_UOM |
| EditButton | row | EDIT_YN |
| FindData | Filter | EXCEL_VIEW |
| GetSearchCondition | dRow | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, MODEL_TYPE, LINE_ATTR_1 |
| Insert_Row_Sub | dRow | LOT_SIZE_UOM, PRECEDE_PRODUCING_TERM_UOM, BUFFER_TIME_UOM, TAT_UOM, TRANSFER_LOT_SIZE_UOM, OPERATION_LEAD_TIME_UOM, TOLERANCE_UOM |
| SaveToDB | main.Tables[0].Rows[i] | USER_ID, JOB_ORDER |
| SaveToDB | eachRow | _VALID |
| SaveToDB | result.Tables[0].Rows[0] | RESULT, COUNT, EXCEPTION |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:290, SetChangedControl:296, SetChangedControl:302, SetChangedControl:308, SetChangedControl:319, SetChangedControl:329, SetChangedControl:339, SetChangedControl:348 | CString.GetCheckedListValue | CODE |
| FP_PseudoBatch | ExcelImport_Main_SaveDataDelegate:943, ExcelImport_Main_ValidateDataDelegate:965, ExcelImport_Sub_SaveDataDelegate:990, ExcelImport_Sub_ValidateDataDelegate:1009 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| GetSearchCondition | ExcelPopup_Search_Sub_Data:977, lfn_SearchDetailGrid:1927 | BaseForm.GetSearchCondition | ControlName, ControlValue |
| CommonDefaultLineCheck | DefaultLineCheck:978 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:122 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:222 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:475 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:676 |
| this.btnSearchAll | Click | btnSearchAll_Click | InitializeComponent:757 |
| this.btnSubImport | Click | btnSubImport_Click | InitializeComponent:798 |
| this | Load | Form_Load | .ctor:157 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:185 |
| clbSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:186 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:187 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:188 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:189 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1031 |
| this | Load | Form_Load | .ctor:141 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:153 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:204 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:244 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:284 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:324 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:407 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:408 |

## 6. 컨트롤 (57개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 15 | lblDivision, lblSite, lblPlant, lblFactory, lblOperation, lblExcelUpload, lblSql, layoutControlItem11, layoutControlItem1, layoutControlItem2, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem3 |
| UsrButton | 8 | btnExcelUpload, btnSql, btnSubImport, btnSave, btnClose, btnFind, btnDownload, btnUpload |
| EmptySpaceItem | 7 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem4, emptySpaceItem5, emptySpaceItem3, emptySpaceItem7, emptySpaceItem1 |
| UsrCheckedList2 | 5 | clbFactory, clbOperation, clbPlant, clbSite, clbDivision |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 3 | spdMain, spdSub, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1 |
| ImageList | 2 | imageList1, imageList1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| Panel | 1 | StockPanel |
| Label | 1 | label1 |
| SimpleButton | 1 | btnSearchAll |
| Splitter | 1 | splitter1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 48 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 676 | FPCommonDataBLL.UpdateBatch | commented:BIZ_NOT_FOUND |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP02550 | Main | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | FP02550 | Sub | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, Sub, AutoExcelPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:389, SetSheetHeaderColumn_FP@InitSpread:397, SetSheetHeaderColumn_FP@InitSpread:196

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| Find_Main | Main | 1171 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 138 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 139 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 140 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 692 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 693 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 694 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 695 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| FindData |  | 302 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(DoSearchData != null) ⟫ if(init) ⟫ if(AutoCHK) |
| FindData |  | 303 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(DoSearchData != null) ⟫ if(init) ⟫ if(AutoCHK) |
| FindData |  | 304 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(DoSearchData != null) ⟫ if(init) ⟫ if(AutoCHK) |
| InitializeComponent |  | 424 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 425 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 426 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 427 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| Sub | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
