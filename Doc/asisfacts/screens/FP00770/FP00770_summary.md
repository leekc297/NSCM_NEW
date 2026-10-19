# FP00770 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_ExcelPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.UIL.csproj | 718 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_ExcelPopup.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.UIL.csproj | 570 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.UIL.csproj | 2095 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.UIL.csproj | 975 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.UIL.csproj | 64 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00770_Prod_Result_WO_ERP.UIL\FP00770_Prod_Result_WO_ERP.UIL.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 335 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_division.SelectedIndexChanged | mcbo_division_changed > SetChangeControl | 335 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 335 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_factory.SelectedIndexChanged | mcbo_factory_changed > SetChangeControl | 335 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 335 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_line.SelectedIndexChanged | mcbo_line_changed > SetChangeControl | 335 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 335 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_operation.SelectedIndexChanged | mcbo_operation_changed > SetChangeControl | 335 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 335 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed > SetChangeControl | 335 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 1973 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_plant.SelectedIndexChanged | mcbo_plant_changed | 1973 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 335 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:mcbo_site.SelectedIndexChanged | mcbo_site_changed > SetChangeControl | 335 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 335 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_line_changed > SetChangeControl | 335 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 1973 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > mcbo_plant_changed | 1973 | FP\COMMON\BigFilter_FP#list_release_building | MATCH | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 113 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSite | 1330 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlant | 1337 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetFactory | 1346 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetOperation | 1357 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetLine | 1369 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 1775 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 1775 | FP\Planning\FP00770_Production_Result_WO_ERP#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Planning_FP00770_Production_Result_WO_ERP_delete_excel_buffer.sql |
| unreached:(진입점 미연결) | SaveExcelRows | 1786 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00770] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 1786 | FP\Planning\FP00770_Production_Result_WO_ERP#saveAll_FP00770 | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | SaveExcelRows | 1809 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 1809 | FP\Planning\FP00770_Production_Result_WO_ERP#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Planning_FP00770_Production_Result_WO_ERP_find_Excel_buffer_validation.sql |
| unreached:(진입점 미연결) | SaveExcelRows | 1845 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=merge_FP00770] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 1845 | FP\Planning\FP00770_Production_Result_WO_ERP#merge_FP00770 | MATCH | [sql] foxquery_sql\FP_Planning_FP00770_Production_Result_WO_ERP_merge_FP00770.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 1 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=merge_FP00770] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00770] | BIZ_MATCH | 1 |  |  |  |
| FP\COMMON\BigFilter_FP#list_release_building | MATCH | 2 | [sql] foxquery_sql\FP_Common_BigFilter_FP_list_release_building.sql | SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Planning\FP00770_Production_Result_WO_ERP#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00770_Production_Result_WO_ERP_delete_excel_buffer.sql | DELETE:BUF_ERP_WORK_ORDER_STATUS_H |  |
| FP\Planning\FP00770_Production_Result_WO_ERP#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00770_Production_Result_WO_ERP_find_Excel_buffer_validation.sql | SELECT:BUF_ERP_WORK_ORDER_STATUS_H, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_FACTORY_M, SELECT:TH_UIS_CAL |  |
| FP\Planning\FP00770_Production_Result_WO_ERP#merge_FP00770 | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00770_Production_Result_WO_ERP_merge_FP00770.sql | MERGE:FP_ERP_WORK_ORDER_STATUS_H, REF:SYSDATE1, INSERT:HIS_ERP_WORK_ORDER_STATUS_H, SELECT:FP_ERP_WORK_ORDER_STATUS_H |  |
| FP\Planning\FP00770_Production_Result_WO_ERP#saveAll_FP00770 | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | rowPopup.KeyColumns | Company_id, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, CUTOFF_DATE, OPERATION_ID, LINE_ID, LINE_NAME, ITEM_ID, NICK_NAME, WORK_ORDER_ID, ORDER_TYPE, PLAN_DATE, PLAN_START_TIME, PLAN_END_TIME, ACTUAL_START_TIME, ACTUAL_END_TIME, PLAN_QTY, ACTUAL_QTY, REMAIN_QTY, WO_STATUS, MESSAGE |
| btnExcelImport_Click | rowPopup.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, CUTOFF_DATE, OPERATION_ID, LINE_ID, LINE_NAME, ITEM_ID, NICK_NAME, WORK_ORDER_ID, ORDER_TYPE, PLAN_DATE, PLAN_START_TIME, PLAN_END_TIME, ACTUAL_START_TIME, ACTUAL_END_TIME, PLAN_QTY, ACTUAL_QTY, REMAIN_QTY, WO_STATUS, MESSAGE |
| btnExcelImport_Click | rowPopup.ColumnWidth | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, CUTOFF_DATE, OPERATION_ID, LINE_ID, LINE_NAME, ITEM_ID, NICK_NAME, WORK_ORDER_ID, ORDER_TYPE, PLAN_DATE, PLAN_START_TIME, PLAN_END_TIME, ACTUAL_START_TIME, ACTUAL_END_TIME, PLAN_QTY, ACTUAL_QTY, REMAIN_QTY, WO_STATUS, MESSAGE |
| DrawHeader | measure.Data | chk_day, chk_week, chk_month |
| DrawSheet | SP_DataSource.Tables[0].Columns | PLAN_DATE |
| GetDivision | Filter | USER_ID |
| GetFactory | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, CONFIRM_AREA, MASTER_ID, PLAN_ID |
| GetLine | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID |
| GetOperation | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| GetPlant | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| GetSite | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| InitControls | Filter | START_DATE |
| lfn_settingValid | row | _MSG, MESSAGE, _VALID |
| MakeMemoBold | dsMainFiltered.Tables[0].Rows[i] | CATEGORY_ID, DATA_TYPE |
| planday_changed | Filter | PLAN_DATE |
| SaveButton | Filter | DONOTEDIT |
| SaveExcelRows | popupFilter | USER_ID |
| SaveExcelRows | paramFilter | USER_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, CUTOFF_DATE, WORK_ORDER_ID, ORDER_TYPE, ITEM_ID, TOP_ITEM_ID, OPERATION_ID, LINE_ID, WORK_CENTER_ID, EQUIPMENT_ID, PLAN_DATE, PLAN_START_TIME, PLAN_END_TIME, PLAN_QTY, ACTUAL_START_TIME, ACTUAL_END_TIME, ACTUAL_QTY, ACTUAL_GOOD_QTY, ACTUAL_SCRAP_QTY, RUNNING_FLAG, WO_STATUS, BOM_VERSION_ID |
| SaveExcelRows | data.Tables[0].Rows[0] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, CUTOFF_DATE, WORK_ORDER_ID, ORDER_TYPE, ITEM_ID, TOP_ITEM_ID, OPERATION_ID, LINE_ID, WORK_CENTER_ID, EQUIPMENT_ID, PLAN_DATE, PLAN_START_TIME, PLAN_END_TIME, PLAN_QTY, ACTUAL_START_TIME, ACTUAL_END_TIME, ACTUAL_QTY, ACTUAL_GOOD_QTY, ACTUAL_SCRAP_QTY, RUNNING_FLAG, WO_STATUS, BOM_VERSION_ID |
| SaveToDB | main.Tables[0].Rows[i] | USER_ID |
| SaveToDB | eachRow | _VALID |
| SaveToDB | result.Tables[0].Rows[0] | RESULT, COUNT, EXCEPTION |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |
| SetChangeControl | Filter | SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| SetTotalColor | row | DATA_TYPE, WORK_MODEL |
| UIFindData | Filter | START_DATE, DONOTEDIT, PLAN_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| ReadResult | OpenAndLoadExcelData:625, SaveExcelRows:1799 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |
| CommonDefaultLineCheck | DefaultLineCheck:665 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |
| GetInnerTable | SetChangeControl:310, SetChangeControl:319, SetChangeControl:327, SetChangeControl:335, SetChangeControl:343, SetChangeControl:352, GetDivision:1322 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:314, SetChangeControl:326, SetChangeControl:334, SetChangeControl:342, SetChangeControl:350, SetChangeControl:359, UIFindData:897 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangeControl:315, UIFindData:898, edt_item_TextChanged:2000 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| LoadAmendColumn | DrawHeader:722 | MeasureService.LoadAmendColumn | DAYTAG, MONTHTAG, WEEKTAG |
| EditQuery | DrawSheet:749, DrawSheet:757 | FPExtensions.EditQuery | ROW_ID |
| FP_UpdateBatch | SaveExcelRows:1786 | DataService.FP_UpdateBatch | COUNT, RESULT |
| FP_Log2 | mcbo_division_changed:1958, mcbo_division_changed:1962 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:157 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:164 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:214 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:253 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:292 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:331 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:470 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:471 |
| this | Load | Form_Load | .ctor:176 |
| sCalendar_planday | ValueChanged | planday_changed | InitEvent:379 |
| mcbo_division | SelectedIndexChanged | mcbo_division_changed | InitEvent:382 |
| mcbo_site | SelectedIndexChanged | mcbo_site_changed | InitEvent:383 |
| mcbo_plant | SelectedIndexChanged | mcbo_plant_changed | InitEvent:384 |
| mcbo_factory | SelectedIndexChanged | mcbo_factory_changed | InitEvent:385 |
| mcbo_operation | SelectedIndexChanged | mcbo_operation_changed | InitEvent:386 |
| mcbo_line | SelectedIndexChanged | mcbo_line_changed | InitEvent:387 |
| edt_item | TextChanged | edt_item_TextChanged | InitEvent:390 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:392 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1200 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:562 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:602 |
| this.spdMain | ClipboardChanged | spdMain_ClipboardChanged | InitializeComponent:781 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:782 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:783 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:784 |
| this.spdMain | ClipboardPasting | spdMain_ClipboardPasting | InitializeComponent:785 |
| this.spdMain | ClipboardPasted | spdMain_ClipboardPasted | InitializeComponent:786 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:787 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:788 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:789 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:790 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:791 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:792 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:793 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:794 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:795 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:796 |
| this.spdMain | ClipboardChanging | spdMain_ClipboardChanging | InitializeComponent:797 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:798 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:799 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:800 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:801 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:802 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:803 |
| this | Resize | FP00602_Plan_Amend_Line_Elec_Resize | InitializeComponent:907 |

## 6. 컨트롤 (51개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem3, lblSql, layoutControlItem2, lblData, layoutControlItem8, layoutControlItem15, layoutControlItem19, layoutControlItem21, layoutControlItem6, layoutControlItem9, layoutControlItem20 … |
| UsrButton | 9 | btnSave, btnClose, btnFind, btnDownload, btnUpload, btnToggleSave, btnSql, btnExcelImport, usrButton2 |
| UsrCheckedList2 | 6 | mcbo_line, mcbo_division, mcbo_operation, mcbo_factory, mcbo_plant, mcbo_site |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| EmptySpaceItem | 2 | emptySpaceItem5, emptySpaceItem2 |
| UsrDatePickerWtWeek | 1 | sCalendar_planday |
| UsrTextBox | 1 | edt_item |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 48 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00770 | Amend | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |
| SCM_MST_SHEET_COLUMNS | FP00770 | AutoExcelPopup | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: AutoExcelPopup, Amend
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP2@FindData:294, SetSheetHeaderColumn_FP@DrawHeader:665

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| FindData |  | 300 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 301 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 302 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 487 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 488 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 489 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 490 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| SetCalenderColor |  | 544 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(calendar != null) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| SetCalenderColor |  | 550 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(calendar != null) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| DrawSheet |  | 794 | 표시/라벨 변경 | set:CellType | CellType = {?num} |  | if(dsMainFiltered.Good()) ⟫ if(idx_PLAN_QTY != -1) |
| DrawSheet |  | 799 | 표시/라벨 변경 | set:CellType | CellType = {?num} |  | if(dsMainFiltered.Good()) ⟫ if(idx_ACTUAL_QTY != -1) |
| DrawSheet |  | 804 | 표시/라벨 변경 | set:CellType | CellType = {?num} |  | if(dsMainFiltered.Good()) ⟫ if(idx_REMAIN_QTY != -1) |
| InitializeComponent |  | 819 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 820 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 821 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 822 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Amend | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| AutoExcelPopup | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
