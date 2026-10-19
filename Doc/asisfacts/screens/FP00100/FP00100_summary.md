# FP00100 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.UIL.csproj | 2789 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.UIL.csproj | 1119 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00100_Line.UIL\FP00100_Line.UIL.csproj | 84 |
| shared | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00100_LineImportPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1287 |
| shared | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00100_LineImportPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 647 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00100_Line.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 2671 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00100_Line.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1117 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged > SetChangeControl | 337 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged > SetChangeControl | 359 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged > SetChangeControl | 359 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 337 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 359 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangeControl | 359 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 337 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 359 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged > SetChangeControl | 359 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 337 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 359 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetChangeControl | 359 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 337 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 359 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetChangeControl | 359 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 2022 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 2022 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 337 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 359 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged > SetChangeControl | 359 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:clbSite.SelectedIndexChanged | ClbSite_SelectedIndexChanged | 2013 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 377 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 377 | {?pServiceCallName} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Line | 1125 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| button:FindButton | FindButton > FindData_Sub_2 > Find_Data_Line_ALL | 1307 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 377 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 377 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 411 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 411 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 654 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 654 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 774 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 774 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 834 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 834 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Line | 1125 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:popSql.OnSql | RunSqlSource > Save_Data_Line | 1735 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:popSql2.OnSql | RunSql2Source > Find_Data_Line_Sub | 1185 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:popSql2.OnSql | RunSql2Source > Find_Data_Line_ALL | 1307 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:popSql2.OnSql | RunSql2Source > Save_Data_Line_Sub | 1868 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 377 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 377 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 654 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 654 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Line | 1125 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| button:SaveButton | SaveButton > Save_Data > FindData_Sub > Find_Data_Line_Sub | 1185 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| button:SaveButton | SaveButton > Save_Data > FindData_Sub_2 > Find_Data_Line_ALL | 1307 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| button:SaveButton | SaveButton > Save_Data | 1454 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_operation_group] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 1454 | FP\MASTER\FP00460_SetupGroup#find_line_operation_group | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_operation_group.sql |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line | 1735 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Line_Sub | 1868 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > Find_Data_Line_Sub | 1185 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 377 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 377 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > FindData_Sub_ALL > FindData_Sub > Find_Data_Line_Sub | 1185 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:this.btnFind.Click | btnFind_Click > FindData_Sub_ALL > FindData_Sub_2 > Find_Data_Line_ALL | 1307 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 411 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 411 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 774 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 774 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 834 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 834 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 377 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 377 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 654 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 654 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > InitControls > SetCountry | 166 | biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 209 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 210 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 210 | FP\MASTER\FP00460_SetupGroup#find_instance | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_instance.sql |
| event:this.Load | Form_Load > InitControls | 211 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_operation_group] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 211 | FP\MASTER\FP00460_SetupGroup#find_line_operation_group | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_operation_group.sql |
| event:this.Load | Form_Load > InitControls | 213 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 214 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 215 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 216 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 217 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 230 | biz:FPCommonDataBLL.YesNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 234 | biz:FPCommonDataBLL.FPCommonDataList [code=ELECTRODE_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 337 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 359 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbLine_SelectedIndexChanged > SetChangeControl | 359 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 377 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 377 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > InitControls > ClbSite_SelectedIndexChanged | 2013 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 2022 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > ClbPlant_SelectedIndexChanged | 2022 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2174 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_from_tree] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2174 | FP\MASTER\FP00460_SetupGroup#find_instance_from_tree | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_instance_from_tree.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2207 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2207 | FP\MASTER\FP00460_SetupGroup#find_line_setup_group | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_setup_group.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2274 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2274 | FP\MASTER\FP00460_SetupGroup#find_line_setup_group | MATCH | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_setup_group.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick | 2420 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| unreached:(진입점 미연결) | Save_Data_Line_New | 1615 | FP_Master.PR_UI_FP00100_LINE | MATCH | SP PR_UI_FP00100_LINE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?pServiceCallName} | UNRESOLVED | 5 |  |  |  |
| {?string.Empty} | UNRESOLVED | 5 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=COUNTRY_ID] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=ELECTRODE_TYPE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance_from_tree] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_operation_group] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.YesNo | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 6 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00100_LINE | MATCH | 6 | SP PR_UI_FP00100_LINE | EXEC:PR_UI_FP00100_LINE | ⚠ DB에 SP 없음 |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 3 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\MASTER\FP00460_SetupGroup#find_instance | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_instance.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\FP00460_SetupGroup#find_instance_from_tree | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_instance_from_tree.sql | SELECT:FP_INSTANCE_FACTORY_M, SELECT:FP_INSTANCE_OPERATION_V |  |
| FP\MASTER\FP00460_SetupGroup#find_line_operation_group | MATCH | 2 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_operation_group.sql | SELECT:FP_INSTANCE_LINE_V, SELECT:LINE_SETUP_INSTANCE, SELECT:FP_LINE_SETUP_GROUP_M, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\FP00460_SetupGroup#find_line_setup_group | MATCH | 2 | [sql] foxquery_sql\FP_Master_FP00460_SetupGroup_find_line_setup_group.sql | SELECT:FP_LINE_SETUP_GROUP_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnImport_Click | Application.OpenForms | FPC0100_ExcelImportPopup |
| btnImport_WIP_Click | Application.OpenForms | FPC0100_ExcelImportPopup_WIP |
| EditButton | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| Find_Data | Filter | DIVISION_ID |
| Find_Data_Line_Sub | Filter_Sub | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ACTIVE_FLAG |
| InitControls | Filter | USER_ID, User_ID |
| InitControls | c | CODE |
| SetChangeControl | tt | CODE |
| SetChangeControl | Filter | PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| SetDivision | Filter | USER_ID |
| SetSpreadInit | this.siSub.ActiveSheet.Columns | ELECTRODE_TYPE |
| SpdMain_CellClick | cRow | INSTANCE_ID |
| SpdMain_CellClick | dtInstanceTree.Rows[0] | INSTANCE_ID |
| SpdMain_CellClick | row | CODE, LINE_SETUP_GROUP_ID |
| SpdMain_CellClick | loc | INSTANCE_ID |
| SpdMain_CellClick | dRow | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, CODE, NAME, FACTORY_ID, LINE_ID |
| SpdMain_CellClick | dtLinkLineId.Rows[i] | NAME, CODE |
| SpdMain_CellDoubleClick | SP_DataSource.Tables[0].Columns | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ACTIVE_FLAG, ELECTRODE_TYPE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | SetChangeControl:298, SetChangeControl:304, SetChangeControl:312, SetChangeControl:359, SetChangeControl:368, SetChangeControl:376, SetDivision:2499 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:302, SetChangeControl:311, SetChangeControl:320, SetChangeControl:358, SetChangeControl:367, SetChangeControl:375, SetChangeControl:383, Find_Data_Line:1104 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangeControl:303 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| GetSpdTitle | btnImport_Click:955 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnImport | Click | btnSql_Click | InitializeComponent:499 |
| this.btnSql | Click | btnImport_Click | InitializeComponent:539 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitializeComponent:758 |
| this.spdMain | CellClick | SpdMain_CellClick | InitializeComponent:759 |
| this.btnSql2 | Click | btnSql2_Click | InitializeComponent:882 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:923 |
| this.btnImport_WIP | Click | btnImport_WIP_Click | InitializeComponent:973 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:987 |
| this | Load | Form_Load | .ctor:143 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:409 |
| clbSite | SelectedIndexChanged | ClbSite_SelectedIndexChanged | InitEvent:410 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:411 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:412 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:413 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:414 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:425 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1930 |
| popSql2 | OnSql | RunSql2Source | btnSql2_Click:2757 |
| this | Load | Form_Load | .ctor:154 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1042 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:170 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:221 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:294 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:333 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:372 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:411 |

## 6. 컨트롤 (57개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | layoutControlItem2, layoutControlItem12, layoutControlItem4, layoutControlItem1, layoutControlItem3, layoutControlItem5, lblExcelImport, lblSql, layoutControlItem6, layoutControlItem4, layoutControlItem5, layoutControlItem6, lblSql, layoutControlItem1, layoutControlItem2 … |
| UsrButton | 11 | btnImport, btnSql, btnSql2, btnFind, btnImport_WIP, btnExport, btnSql, btnClose, btnImport, btnSave, btnFind |
| UsrCheckedList2 | 6 | clbLine, clbSite, clbOperation, clbBuilding, clbPlant, clbDivision |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| FpSpread | 3 | spdMain, spdSub, spdComExcel |
| SheetView | 3 | spdMain_Sheet1, spdSub_Sheet1, spdComExcel_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList1 |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrCombo | 1 | cboActive |
| EmptySpaceItem | 1 | emptySpaceItem10 |
| Panel | 1 | panel1 |
| UsrLabel | 1 | lblSheetName |

## 7. 확인 필요 (10건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 377 | Find_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 377 | Find_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 411 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 411 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 654 | Save_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 654 | Save_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 774 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 774 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 834 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 834 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 56 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 14 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 7 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00100 | Item Popup | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 | 5/0 |
| SCM_MST_SHEET_COLUMNS | FP00100 | Line(FP) | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 |
| SCM_MST_SHEET_COLUMNS | FP00100 | LineExcelPopup | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_COLUMNS | FP00100 | LineImportExcelPopup | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 | 2/0 |
| SCM_MST_SHEET_COLUMNS | FP00100 | WIP_LEVEL | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Line(FP), WIP_LEVEL, LineExcelPopup || {?this.sSheetName}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:560, SetSheetHeaderColumn_FP@SetSpreadInit:575, SetSheetHeaderColumn_FP@SetSpreadInit:239

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit |  | 564 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID | if(sheetName.Equals("Line(FP)")) |
| SetSpreadInit |  | 565 | 표시/라벨 변경 | set:Visible | Visible = {?false} | LINE_TYPE | if(sheetName.Equals("Line(FP)")) |
| SetSpreadInit |  | 566 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DESCRIPTION | if(sheetName.Equals("Line(FP)")) |
| SetSpreadInit |  | 567 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID | if(sheetName.Equals("Line(FP)")) |
| SetSpreadInit |  | 588 | 표시/라벨 변경 | set:CellType | CellType = {?cb} | ELECTRODE_TYPE | else!(sheetName.Equals("Line(FP)")) |
| Find_Data | Line(FP) | 967 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| FindData_Sub |  | 1013 | 표시/라벨 변경 | set:CellType | CellType = {?num} |  |  |
| FindData_Sub_2 |  | 1062 | 표시/라벨 변경 | set:CellType | CellType = {?num} |  |  |
| InitializeComponent |  | 775 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 776 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 777 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 778 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1003 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1004 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1005 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1006 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 242 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EQUIPMENT_COUNT |  |
| SetSpreadInit | 0 | 243 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VALID_YN |  |
| SetSheetHeaderWidth |  | 1106 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siComExcel.ActiveSheet.Columns["0"].Width) == 0) |
| SetSheetHeadColor |  | 1235 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.FromArgb(0, 113, 0)} |  | for(idx < siComExcel.ActiveSheet.Columns.Count) ⟫ if(sHeadName.IndexOf("*") >= 0) |
| InitializeComponent |  | 560 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 561 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 562 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 563 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| Item Popup | 메타 정의만, 코드 미참조(미사용 가능) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Line(FP) | META+코드연결 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 |
| LineExcelPopup | META+코드연결 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |
| LineImportExcelPopup | 메타 정의만, 코드 미참조(미사용 가능) | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 | 2 |
| WIP_LEVEL | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
