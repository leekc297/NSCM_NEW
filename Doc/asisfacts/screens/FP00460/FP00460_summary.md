# FP00460 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_ExcelImportPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 1194 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_ExcelImportPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 648 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 2157 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 858 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_SetupGroupAddPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 789 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_SetupGroupAddPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 1524 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00460_Setup_Group.UIL\FP00460_Setup_Group.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00460_Setup_Group.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1551 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00460_Setup_Group.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1080 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00460_SetupGroupAddPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 638 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00460_SetupGroupAddPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1414 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 413 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 413 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 413 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 413 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 448 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 448 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 662 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 662 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 733 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 733 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 773 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 773 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Main | 1082 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_setup_group] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Main | 1082 | FP\Master\FP00460_SetupGroup#save_item_setup_group | MATCH | [update-batch]  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Main | 1091 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_setup_group] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Main | 1091 | FP\Master\FP00460_SetupGroup#delete_item_setup_group | MATCH | [update-batch]  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Sub | 1309 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_line_setup_group] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Sub | 1309 | FP\Master\FP00460_SetupGroup#save_line_setup_group | MATCH | [update-batch]  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Sub | 1315 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_line_setup_group] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Sub | 1315 | FP\Master\FP00460_SetupGroup#delete_line_setup_group | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 413 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 413 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 662 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 662 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Main | 1082 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_setup_group] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Main | 1082 | FP\Master\FP00460_SetupGroup#save_item_setup_group | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Main | 1091 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_setup_group] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Main | 1091 | FP\Master\FP00460_SetupGroup#delete_item_setup_group | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Sub > Save_Data_Sub | 1309 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_line_setup_group] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Sub > Save_Data_Sub | 1309 | FP\Master\FP00460_SetupGroup#save_line_setup_group | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Sub > Save_Data_Sub | 1315 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_line_setup_group] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Sub > Save_Data_Sub | 1315 | FP\Master\FP00460_SetupGroup#delete_line_setup_group | MATCH | [update-batch]  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 413 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 413 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 448 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 448 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 733 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 733 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 773 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 773 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 413 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 413 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 662 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 662 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSearchOperation.Click | btnSearchOperation_Click | 363 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 113 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 113 | FP\MASTER\FP00460_SetupGroup#find_category | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_category.sql |
| event:this.Load | Form_Load > InitControls | 118 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_key] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 118 | FP\MASTER\FP00460_SetupGroup#find_key | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_key.sql |
| event:this.Load | Form_Load > InitControls | 125 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 125 | FP\Master\FP00902_ItemSetupAttr#get_item_list | MATCH | [sql] foxquery_sql\FP_Master_FP00902_ItemSetupAttr_get_item_list.sql |
| event:this.Load | Form_Load > InitControls | 127 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ref_operation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 127 | FP\MASTER\FP00460_SetupGroup#find_ref_operation | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_ref_operation.sql |
| event:this.Load | Form_Load > InitControls | 132 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_calculation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 132 | FP\MASTER\FP00460_SetupGroup#find_calculation | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_calculation.sql |
| event:this.Load | Form_Load > InitControls > GetInstanceSetupInstance | 151 | biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstanceSetupInstance | 152 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstanceSetupInstance | 152 | FP\MASTER\FP00460_SetupGroup#find_instance | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_instance.sql |
| event:this.Load | Form_Load > InitControls | 204 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 208 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 208 | FP\MASTER\FP00460_SetupGroup#find_category | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_category.sql |
| event:this.Load | Form_Load > InitControls | 211 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_calculation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 211 | FP\MASTER\FP00460_SetupGroup#find_calculation | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_calculation.sql |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 413 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 413 | {?pServiceCallName} | UNRESOLVED |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 1446 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 1446 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?pServiceCallName} | UNRESOLVED | 5 |  |  |  |
| {?string.Empty} | UNRESOLVED | 5 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_calculation] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_key] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ref_operation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_setup_group] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_line_setup_group] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_setup_group] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_line_setup_group] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 1 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 1 | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql | SELECT:FP_PLAN_STATUS_H, SELECT:SCM_FP_PLAN_DETAIL_H, SELECT:SCM_FP_PLAN_GROUP_DETAIL_H, SELECT:FP_RELEASE_CALCULATION_STATUS_H |  |
| FP\Master\FP00460_SetupGroup#delete_item_setup_group | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00460_SetupGroup#delete_line_setup_group | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00460_SetupGroup#find_calculation | MATCH | 2 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_calculation.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\FP00460_SetupGroup#find_category | MATCH | 2 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_category.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\FP00460_SetupGroup#find_instance | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_instance.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\FP00460_SetupGroup#find_key | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_key.sql | SELECT:SCM_ITEM_CLASS_LEVEL_M |  |
| FP\MASTER\FP00460_SetupGroup#find_ref_operation | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_ref_operation.sql | SELECT:FP_INSTANCE_LINE_V, SELECT:FP_USER_ROLE_INFO_V, SELECT:SCM_OPERATION_M |  |
| FP\Master\FP00460_SetupGroup#save_item_setup_group | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00460_SetupGroup#save_line_setup_group | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00902_ItemSetupAttr#get_item_list | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00902_ItemSetupAttr_get_item_list.sql | SELECT:FP_INSTANCE_ITEM_SETUP_ATTR_TYPE_M, SELECT:FP_USER_ROLE_INFO_V |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnRefreshSetup_Click | filter | USER_ID, OPERATION_ID, INSTANCE_ID |
| btnSearchOperation_Click | dRow | OPERATION_GROUP_ID, CODE, NAME, LEVEL, OPERATION_GROUP_NAME, INSTANCE_ID, OPERATION_ID |
| btnSubImport_Click | Application.OpenForms | FPC0100_ExcelImportPopup |
| call_Excel_Row_Save | checkSave.Tables[0].Rows[0] | _TYPE |
| call_Excel_Row_Save | popup.Filter | PLAN_TYPE, INSTANCE_ID, FP_PLAN_ID |
| call_Excel_Row_Save | row | INSTANCE_ID, FP_PLAN_ID |
| cboCategory_SelectionChangeCommitted | dRow | OPERATION_GROUP_ID, CODE, NAME, LEVEL, OPERATION_GROUP_NAME, INSTANCE_ID, OPERATION_ID, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15 |
| CheckNullDataTableValidation | dtSheetColumn.Rows[iRow] | COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO |
| CheckNullSpreadValidation | dtSheetColumn.Rows[iRow] | COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_NAME |
| CreateSpread | spdMain.ActiveSheet.Columns | INSTANCE_ID, INSTANCE_NAME, COMPANY_ID, SITE_ID, DIVISION_ID |
| CreateSpread | siSub.ActiveSheet.Columns | INSTANCE_NAME, PLANT_ID, COMPANY_ID, SITE_ID, DIVISION_ID |
| Find_Data_Detail | filter | USER_ID |
| Find_Data_Main | filter | USER_ID, OPERATION_ID, SETUP_CATEGORY_ID, INSTANCE_ID |
| Find_Data_Sub | filter | USER_ID, INSTANCE_ID, OPERATION_ID |
| Find_Sub | siSub.ActiveSheet.Columns | INSTANCE_ID, PLANT_ID, COMPANY_ID, SITE_ID, DIVISION_ID |
| GetInstanceSetupInstance | Filter | USER_ID |
| GetInstanceSetupInstance | r | CODE |
| GetInstanceSetupInstance | rA | CODE |
| InitControls | Filter | USER_ID, INSTANCE_ID, OPERATION_ID |
| InsertButton | Application.OpenForms | FP00460_SetupGroupAddPopup |
| Save_Data_Add | filter | USER_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, LEVEL, REFERANCE_OPERATION_ID, CALCULATION, DESCRIPTION, LINE_SETUP_GROUP_ID, ORG_LINE_SETUP_GROUP_ID, INSTANCE_ID |
| Save_Data_Add | dtAttrTable.Rows[i] | CODE |
| Save_Data_Main | ret.Rows[0] | COUNT |
| Save_Data_Main | resRow | Result, CNT |
| Save_Data_Sub | row | USER_ID, ACTIVE_FLAG, DESCRIPTION |
| UIFindData | row | SETUP_CATEGORY_ID, SETUP_KEY_ID_BAK, SETUP_KEY_ID, SETUP_KEY_NAME |
| UIFindData | spdMain.ActiveSheet.Columns | INSTANCE_ID, COMPANY_ID, SITE_ID, DIVISION_ID |
| UIFindData | siSub.ActiveSheet.Columns | INSTANCE_ID, PLANT_ID, COMPANY_ID, SITE_ID, DIVISION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | btnImport_Click:848, CheckNullSpreadValidation:980, CheckNullDataTableValidation:1026 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| GetCheckedListValue | Save_Data_Add:209, Save_Data_Add:213, Save_Data_Add:241, Save_Data_Add:242, cboCategory_SelectionChangeCommitted:456, RunSqlSource:706, RunSqlSource:710, RunSqlSource:737 | CString.GetCheckedListValue | CODE |
| FP_PseudoBatch | Save_Data_Main:1082, Save_Data_Main:1091, Save_Data_Sub:1309, Save_Data_Sub:1315 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| FP_Log | call_Excel_Row_Save:1442, call_Excel_Row_Save:1445, call_Excel_Row_Save:1447 | DataService.FP_Log | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSql | Click | btnSql_Click | InitializeComponent:171 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:222 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:295 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:334 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:373 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:412 |
| this | Load | Form_Load | .ctor:164 |
| popSql | OnSql | RunSqlSource | btnSql_Click:953 |
| this | Load | Form_Load | .ctor:83 |
| popSql | OnSql | RunSqlSource | btnSql_Click:442 |
| this.cboAttrKey | SelectedIndexChanged | cboAttrKey_SelectedIndexChanged | InitializeComponent:345 |
| this.btnSearchOperation | Click | btnSearchOperation_Click | InitializeComponent:459 |
| this.cboCategory | SelectionChangeCommitted | cboCategory_SelectionChangeCommitted | InitializeComponent:552 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:850 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:992 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:1030 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:118 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:119 |
| this.btnRefreshSetup | Click | btnRefreshSetup_Click | InitializeComponent:327 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:368 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:562 |
| this.btnSubImport | Click | btnSubImport_Click | InitializeComponent:695 |
| this | Load | Form_Load | .ctor:109 |
| cboInstance | SelectedIndexChanged | cboInstance_SelectedIndexChanged | InitEvent:135 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1903 |

## 6. 컨트롤 (103개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 38 | layoutControlItem5, layoutControlItem6, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem3, lblSql, lblSql, layoutControlItem9, lbltxtRefOperation, layoutControlItem7, layoutControlItem13, layoutControlItem15, layoutControlItem18, layoutControlItem22 … |
| UsrButton | 12 | btnSql, btnExport, btnClose, btnImport, btnSave, btnFind, btnSearchOperation, btnSql, btnClose, btnSave, btnSql, btnSubImport |
| UsrLabel | 12 | lblSheetName, usrLabel6, labelAttribute, usrLabel10, labelClassOrAttr, usrLabel4, usrLabel2, usrLabel1, usrLabel3, usrLabel5, usrLabel3, usrLabel1 |
| UsrCombo | 8 | cboAttrKey, cboRefOperation, cboClass, cboCalculation, cboCategory, cboInstance, cboCategory, cboOperation |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl3 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup3 |
| UsrTextBox | 5 | txtAttrValue, txtOperation, txtRefOperation, txtClass, txtInstance |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| FpSpread | 3 | spdComExcel, spdMain, spdSub |
| SheetView | 3 | spdComExcel_Sheet1, spdMain_Sheet1, spdSub_Sheet1 |
| SimpleButton | 1 | btnRefreshSetup |
| EmptySpaceItem | 1 | emptySpaceItem7 |
| Panel | 1 | StockPanel |
| Splitter | 1 | splitter1 |

## 7. 확인 필요 (11건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 413 | Find_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 413 | Find_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 448 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 448 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 662 | Save_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 662 | Save_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 733 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 733 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 773 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 773 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 1446 | call_Excel_Row_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 37 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 4 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 772 | FP_Master.PR_UI_FP00460_SETUP_GROUP | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00460 | spdDetail | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | FP00460 | spdMain | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | FP00460 | spdSub | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: {?this.sSheetName}, spdMain, spdSub
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:255, SetSheetHeaderColumn_FP@InitSpread:286, SetSheetHeaderColumn_FP@InitSpread:303

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 263 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | if(_arrHiddenColumns != null) ⟫ if(_arrHiddenColumns.Length > 0) ⟫ for(i < _arrHiddenColumns.Length) |
| SetSheetHeadColor |  | 1126 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.FromArgb(0, 113, 0)} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(sHeadName.IndexOf("*") >= 0) |
| SetSheetHeaderWidth |  | 1146 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siComExcel.ActiveSheet.Columns["0"].Width) == 0) |
| InitializeComponent |  | 561 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 562 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 563 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 564 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| CreateSpread | spdMain | 248 | 표시/라벨 변경 | set:Width | Width = 0 | INSTANCE_ID |  |
| CreateSpread | spdMain | 249 | 표시/라벨 변경 | set:Width | Width = 170 | INSTANCE_NAME |  |
| CreateSpread | spdMain | 250 | 표시/라벨 변경 | set:Width | Width = 0 | COMPANY_ID |  |
| CreateSpread | spdMain | 251 | 표시/라벨 변경 | set:Width | Width = 0 | SITE_ID |  |
| CreateSpread | spdMain | 252 | 표시/라벨 변경 | set:Width | Width = 0 | DIVISION_ID |  |
| CreateSpread | spdSub | 258 | 표시/라벨 변경 | set:Width | Width = 170 | INSTANCE_NAME |  |
| CreateSpread | spdSub | 259 | 표시/라벨 변경 | set:Width | Width = 0 | PLANT_ID |  |
| CreateSpread | spdSub | 260 | 표시/라벨 변경 | set:Width | Width = 0 | COMPANY_ID |  |
| CreateSpread | spdSub | 261 | 표시/라벨 변경 | set:Width | Width = 0 | SITE_ID |  |
| CreateSpread | spdSub | 262 | 표시/라벨 변경 | set:Width | Width = 0 | DIVISION_ID |  |
| InitSpread |  | 294 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID | if(spreadInfo.SheetName == "spdMain") |
| InitSpread |  | 295 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN | if(spreadInfo.SheetName == "spdMain") |
| InitSpread |  | 308 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID | else!(spreadInfo.SheetName == "spdMain") ⟫ if(spreadInfo.SheetName == "spdSub") |
| InitSpread |  | 309 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN | else!(spreadInfo.SheetName == "spdMain") ⟫ if(spreadInfo.SheetName == "spdSub") |
| UIFindData | spdMain | 716 | 표시/라벨 변경 | set:Width | Width = 100 | INSTANCE_ID | else!(ds.Good()) |
| UIFindData | spdMain | 718 | 표시/라벨 변경 | set:Width | Width = 0 | COMPANY_ID | else!(ds.Good()) |
| UIFindData | spdMain | 719 | 표시/라벨 변경 | set:Width | Width = 0 | SITE_ID | else!(ds.Good()) |
| UIFindData | spdMain | 720 | 표시/라벨 변경 | set:Width | Width = 0 | DIVISION_ID | else!(ds.Good()) |
| UIFindData | spdMain | 724 | 표시/라벨 변경 | set:Width | Width = 100 | INSTANCE_ID | else!(ds.Good()) |
| UIFindData | spdMain | 726 | 표시/라벨 변경 | set:Width | Width = 0 | PLANT_ID | else!(ds.Good()) |
| UIFindData | spdMain | 727 | 표시/라벨 변경 | set:Width | Width = 0 | COMPANY_ID | else!(ds.Good()) |
| UIFindData | spdMain | 728 | 표시/라벨 변경 | set:Width | Width = 0 | SITE_ID | else!(ds.Good()) |
| UIFindData | spdMain | 729 | 표시/라벨 변경 | set:Width | Width = 0 | DIVISION_ID | else!(ds.Good()) |
| UIFindData | spdMain | 737 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| Find_Sub | spdSub | 843 | 표시/라벨 변경 | set:Width | Width = 100 | INSTANCE_ID | else!(ds.Good()) |
| Find_Sub | spdSub | 845 | 표시/라벨 변경 | set:Width | Width = 0 | PLANT_ID | else!(ds.Good()) |
| Find_Sub | spdSub | 846 | 표시/라벨 변경 | set:Width | Width = 0 | COMPANY_ID | else!(ds.Good()) |
| Find_Sub | spdSub | 847 | 표시/라벨 변경 | set:Width | Width = 0 | SITE_ID | else!(ds.Good()) |
| Find_Sub | spdSub | 848 | 표시/라벨 변경 | set:Width | Width = 0 | DIVISION_ID | else!(ds.Good()) |
| Find_Sub | spdSub | 876 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 135 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 136 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 137 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 138 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 578 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 579 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 580 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 581 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| spdDetail | 메타 정의만, 코드 미참조(미사용 가능) | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| spdMain | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| spdSub | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
