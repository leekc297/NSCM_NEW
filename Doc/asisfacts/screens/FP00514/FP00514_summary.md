# FP00514 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 1821 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 734 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TestTargetImportPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 1300 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TestTargetImportPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 648 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TestTargetMultiPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 1188 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TestTargetMultiPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 1208 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00514_TEST_Target.UIL\FP00514_TEST_Target.UIL.csproj | 84 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00514_TEST_Target.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1821 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00514_TEST_Target.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 734 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00514_TestTargetImportPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1300 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00514_TestTargetImportPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 648 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00514_TestTargetMultiPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1157 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00514_TestTargetMultiPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1208 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 258 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 266 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 273 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 280 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | CboDivision_SelectedIndexChanged > SetChangedControl | 288 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboPlant.SelectedIndexChanged | CboPlant_SelectedIndexChanged | 894 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboPlant.SelectedIndexChanged | CboPlant_SelectedIndexChanged | 902 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboPlant.SelectedIndexChanged | CboPlant_SelectedIndexChanged | 911 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 837 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 844 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 851 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged | 859 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged | 952 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | ClbFactory_SelectedIndexChanged | 961 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged | 1007 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 381 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Import | 381 | {?pServiceCallName} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Line | 548 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| button:FindButton | FindButton > Find_Data > Find_Data_Multi | 574 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data > Find_Data_Multi | 574 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 381 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Import | 381 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 419 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Validation | 419 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Line | 548 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| event:popSql.OnSql | RunSqlSource > Find_Data_Multi | 574 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Multi | 574 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 669 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Import | 669 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Multi | 741 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Multi | 741 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Test | 762 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 802 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Save_Data_Buffer | 802 | {?pServiceCallName} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 865 | {?string.Empty} | UNRESOLVED |  |
| event:popSql.OnSql | RunSqlSource > Delete_Data_Buffer | 865 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 381 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Import | 381 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Line | 548 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Multi | 574 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Find_Data > Find_Data_Multi | 574 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 669 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Import | 669 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Multi | 741 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Multi | 741 | {?pServiceCallName} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_Data > Save_Data_Test | 762 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 381 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Import | 381 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Multi | 574 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnFind.Click | btnFind_Click > Find_Data > Find_Data_Multi | 574 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 419 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Find_Save_Validation > Find_Data_Validation | 419 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 802 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Save_Data_Buffer | 802 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 865 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnImport.Click | btnImport_Click > Delete_Data_Buffer | 865 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 381 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Import | 381 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Multi | 574 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Find_Data > Find_Data_Multi | 574 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 669 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Import | 669 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Multi | 741 | {?string.Empty} | UNRESOLVED |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data > Save_Data_Multi | 741 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > InitControls | 153 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls | 183 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 192 | FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | SP PR_UI_FP_MASTER_FORM_CODE |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 258 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 266 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 273 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 280 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 288 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 381 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Import | 381 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Multi | 574 | {?string.Empty} | UNRESOLVED |  |
| event:this.Load | Form_Load > Find_Data > Find_Data_Multi | 574 | {?pServiceCallName} | UNRESOLVED |  |
| event:this.spdTarget.CellClick | spdTarget_CellClick | 1085 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_pdsType_filtering] | BIZ_MATCH |  |
| event:this.spdTarget.CellClick | spdTarget_CellClick | 1085 | FP\Master\FP00514_TEST_Target#find_pdsType_filtering | MATCH | [sql] foxquery_sql\FP_Master_FP00514_TEST_Target_find_pdsType_filtering.sql |
| unreached:(진입점 미연결) | Find_Data_Import | 1196 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| unreached:(진입점 미연결) | Insert_Data_Excel_Buffer | 1437 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| unreached:(진입점 미연결) | Find_Data_Excel_Buffer_Valid | 1494 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| unreached:(진입점 미연결) | Save_Data_Excel_Import | 1654 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |
| unreached:(진입점 미연결) | Delete_Data_Excel_Buffer | 1722 | FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | SP PR_UI_FP00514_TEST_TARGET |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?pServiceCallName} | UNRESOLVED | 7 |  |  |  |
| {?string.Empty} | UNRESOLVED | 7 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 2 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_pdsType_filtering] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP_MASTER_FORM_CODE | MATCH | 2 | SP PR_UI_FP_MASTER_FORM_CODE | EXEC:PR_UI_FP_MASTER_FORM_CODE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00514_TEST_TARGET | MATCH | 7 | SP PR_UI_FP00514_TEST_TARGET | EXEC:PR_UI_FP00514_TEST_TARGET | ⚠ DB에 SP 없음 |
| FP\Master\FP00514_TEST_Target#find_pdsType_filtering | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00514_TEST_Target_find_pdsType_filtering.sql | SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_INSTANCE_LINE_V |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnImport_Click | Application.OpenForms | FP00514_TestTargetImportPopup |
| ExcelPopup_ImportValidation_Data | data.Tables[0].Rows[i] | VALUE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, TEST_TARGET_ID, MODEL, ITEM_ID, FACTORY_ID, OPERATION_ID, LINE_ID, MARKET, PRODUCTION_TYPE, DUE_DATE, MFG_WEEK, MFG_QTY, DESCRIPTION, NICK_NAME, IS_PREV_SCHEDULE, DEMAND_TYPE, SCP_PLAN_ID |
| ExcelPopup_ImportValidation_Data | newrow | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, TEST_TARGET_ID, MODEL, ITEM_ID, FACTORY_ID, OPERATION_ID, LINE_ID, MARKET, PRODUCTION_TYPE, DUE_DATE, MFG_WEEK, MFG_QTY, DESCRIPTION, NICK_NAME, IS_PREV_SCHEDULE, DEMAND_TYPE, SCP_PLAN_ID |
| ExcelPopup_ImportValidation_Data | each_row | _VALID |
| GetDivision | Filter | USER_ID |
| InitControls | dtMFGDate.Rows[0] | MIN_DATE, MAX_DATE |
| Insert_Data_Excel_Buffer | dsData.Tables[0].Rows[i] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, MODEL, FACTORY_ID, OPERATION_ID, LINE_ID, MARKET, PRODUCTION_TYPE, DUE_DATE, MFG_WEEK, MFG_QTY, IS_PREV_SCHEDULE, DEMAND_TYPE, SCP_PLAN_ID, DESCRIPTION, TEST_TARGET_ID |
| Save_Data_Excel_Import | dsData.Tables[0].Rows[i] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CITEM_ID, MODEL, FACTORY_ID, OPERATION_ID, LINE_ID, MARKET, PRODUCTION_TYPE, DUE_DATE, MFG_WEEK, MFG_QTY, IS_PREV_SCHEDULE, DEMAND_TYPE, SCP_PLAN_ID, DESCRIPTION, TEST_TARGET_ID |
| SetChangeControl | Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| spdTarget_CellClick | dtPDS_In | DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| spdTarget_CellClick | dRow | DIVISION_ID, CODE, NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | Find_Data_Line:536, Find_Data_Line:537, Find_Data_Line:538, btnImport_Click:901, btnImport_Click:902, btnImport_Click:903, Find_Data_Import:1183, Find_Data_Import:1184 | CString.GetCheckedListValue | CODE |
| GetInnerTable | SetChangeControl:1778, SetChangeControl:1784, SetChangeControl:1796, GetDivision:1815 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetSpdTitle | btnImport_Click:991 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnAdd | Click | btnAdd_Click | InitializeComponent:176 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:425 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:465 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:628 |
| this | Load | Form_Load | .ctor:109 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:262 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:263 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:264 |
| popSql | OnSql | RunSqlSource | btnSql_Click:888 |
| this | Load | Form_Load | .ctor:153 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1077 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:171 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:256 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:295 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:334 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:373 |
| this.btnExport | Click | btnExport_Click | InitializeComponent:576 |
| this | Load | Form_Load | .ctor:156 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:308 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitEvent:309 |
| cboPlant | SelectedIndexChanged | CboPlant_SelectedIndexChanged | InitEvent:310 |
| clbFactory | SelectedIndexChanged | ClbFactory_SelectedIndexChanged | InitEvent:311 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitEvent:312 |
| popSql | OnSql | RunSqlSource | btnSql_Click:466 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:211 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:693 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:742 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:781 |
| this.spdTarget | CellClick | spdTarget_CellClick | InitializeComponent:1078 |

## 6. 컨트롤 (86개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 31 | layoutControlItem2, lblSql, layoutControlItem3, layoutControlItem6, layoutControlItem4, layoutControlItem1, lblExcelImport, layoutControlItem5, layoutControlItem4, layoutControlItem5, layoutControlItem6, lblSql, layoutControlItem1, layoutControlItem2, layoutControlItem3 … |
| UsrButton | 13 | btnAdd, btnImport, btnSql, btnSql, btnClose, btnImport, btnSave, btnFind, btnExport, btnSql, btnClose, btnSave, btnFind |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCheckedList2 | 5 | clbPlant, clbDivision, clbLine, clbOperation, clbFactory |
| UsrCombo | 4 | cboSite, cboDivision, cboPlant, cboSite |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| UsrMultiLineEditor | 3 | txtItemID, txtItem, txtModel |
| FpSpread | 3 | spdMain, spdTestExcel, spdTarget |
| SheetView | 3 | spdMain_Sheet1, spdTestExcel_Sheet1, spdTarget_Sheet1 |
| UsrLabel | 2 | lblSheetName, usrLabel1 |
| UsrRadio | 2 | rdoE, rdoD |
| UsrDateRangePicker2 | 1 | drpPeriod |
| UsrDatePicker2 | 1 | dtpDueDate |

## 7. 확인 필요 (14건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 381 | Find_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 381 | Find_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 419 | Find_Data_Validation | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 419 | Find_Data_Validation | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 669 | Save_Data_Import | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 669 | Save_Data_Import | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 802 | Save_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 802 | Save_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 865 | Delete_Data_Buffer | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 865 | Delete_Data_Buffer | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 574 | Find_Data_Multi | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 574 | Find_Data_Multi | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 741 | Save_Data_Multi | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |
| 741 | Save_Data_Multi | {?pServiceCallName} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 71 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 13 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00514 | TEST_Target | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |
| SCM_MST_SHEET_COLUMNS | FP00514 | TEST_TargetImportPopup | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | FP00514 | TEST_TargetMultiPopup | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 | 24/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: TEST_Target, TEST_TargetImportPopup || {?this.sSheetName}, TEST_TargetMultiPopup || {?this.sSheetName}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:331, SetSheetHeaderColumn_FP@SetSpreadInit:239, SetSheetHeaderColumn_FP@SetSpreadInit:366

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadInit | 0 | 335 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 336 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEMAND_TYPE |  |
| SetSpreadInit | 0 | 337 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SCP_PLAN_ID |  |
| SetSpreadInit | 0 | 338 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID |  |
| SetSpreadInit | 0 | 339 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN |  |
| Find_Data | TEST_Target | 521 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 644 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 645 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 646 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 647 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 243 | 표시/라벨 변경 | set:Visible | Visible = {?false} | NICK_NAME |  |
| SetSpreadInit | 0 | 244 | 표시/라벨 변경 | set:Visible | Visible = {?false} | VALID_YN |  |
| SetSpreadInit | 0 | 245 | 표시/라벨 변경 | set:Visible | Visible = {?false} | IS_PREV_SCHEDULE |  |
| SetSpreadInit | 0 | 246 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEMAND_TYPE |  |
| SetSpreadInit | 0 | 247 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SCP_PLAN_ID |  |
| SetSheetHeadColor |  | 1266 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.FromArgb(0, 113, 0)} |  | for(idx < siTestExcel.ActiveSheet.Columns.Count) ⟫ if(sHeadName.IndexOf("*") >= 0) |
| SetSheetHeaderWidth |  | 1287 | 표시/라벨 변경 | set:Width | Width = {?sz.Width} |  | for(idx < siTestExcel.ActiveSheet.Columns.Count) ⟫ if(Convert.ToInt32(siTestExcel.ActiveSheet.Columns["0"].Width) == 0) |
| InitializeComponent |  | 492 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 493 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 494 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 495 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetSpreadInit | 0 | 369 | 표시/라벨 변경 | set:Visible | Visible = {?false} | COMPANY_ID |  |
| SetSpreadInit | 0 | 370 | 표시/라벨 변경 | set:Visible | Visible = {?false} | IS_PREV_SCHEDULE |  |
| SetSpreadInit | 0 | 371 | 표시/라벨 변경 | set:Visible | Visible = {?false} | DEMAND_TYPE |  |
| SetSpreadInit | 0 | 372 | 표시/라벨 변경 | set:Visible | Visible = {?false} | SCP_PLAN_ID |  |
| SetSpreadInit | 0 | 380 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK |  |
| SetSpreadInit | 0 | 381 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK |  |
| SetSpreadInit | 0 | 382 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK |  |
| Find_Data |  | 540 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| spdTarget_CellClick |  | 1029 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ⟫ if(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value) == false) |
| spdTarget_CellClick |  | 1034 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ⟫ if(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value) == false) |
| InitializeComponent |  | 1094 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1095 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1096 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1097 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| TEST_Target | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| TEST_TargetImportPopup | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| TEST_TargetMultiPopup | META+코드연결 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 | 24 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
