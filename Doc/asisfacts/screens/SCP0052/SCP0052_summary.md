# SCP0052 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.UIL.csproj | 1542 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.UIL.csproj | 1555 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPAReportYieldMonitoringPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.UIL.csproj | 210 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPAReportYieldMonitoringPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.UIL.csproj | 115 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\TestCode.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0052_CAPA_Report.UIL\SCP0052_CAPA_Report.UIL.csproj | 48 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\POPUP\SCP0052_CAPAReportYieldMonitoringPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\SCP0052_CAPA_Report.csproj | 210 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\POPUP\SCP0052_CAPAReportYieldMonitoringPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\SCP0052_CAPA_Report.csproj | 115 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\SCP0052_CAPA_Report.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\SCP0052_CAPA_Report.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\SCP0052_CAPA_Report.csproj | 1542 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\SCP0052_CAPA_Report.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0052_CAPA_Report\SCP0052_CAPA_Report.csproj | 1555 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 275 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 275 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:cboGroup.SelectedIndexChanged | ClbGroup_SelectedIndexChanged | 1119 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:cboGroup.SelectedIndexChanged | ClbGroup_SelectedIndexChanged | 1119 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 1176 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 1176 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged | 1188 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged | 1188 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1160 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 1160 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 152 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL |
| button:FindButton | FindButton > FindData | 152 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL |
| button:FindButton | FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| button:FindButton | FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| button:FindButton | FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| button:FindButton | FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| button:FindButton | FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| button:FindButton | FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| button:FindButton | FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| button:FindButton | FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| button:FindButton | FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| button:FindButton | FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:this.Load | Form_Load > FindData | 152 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL |
| event:this.Load | Form_Load > FindData | 152 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 275 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 275 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:this.Load | Form_Load > InitControls > GetDayRange | 887 | SCP.SCP0052_GET_DAY_RANGE | MATCH | SP SCP0052_GET_DAY_RANGE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 887 | SCP.SCP0052_GET_DAY_RANGE | MATCH | SP SCP0052_GET_DAY_RANGE |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > SetPeriod > GetDayRange | 887 | SCP.SCP0052_GET_DAY_RANGE | MATCH | SP SCP0052_GET_DAY_RANGE |
| event:this.spdMain.ActiveSheetChanged | SpdMain_ActiveSheetChanged > SetPeriod > GetDayRange | 887 | SCP.SCP0052_GET_DAY_RANGE | MATCH | SP SCP0052_GET_DAY_RANGE |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_History | 481 | SCP.SCP0052_GET_CAPA_REPORT | MATCH | SP SCP0052_GET_CAPA_REPORT |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_TotalYield | 599 | SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring | 704 | SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle | 765 | SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | SP SCP0052_GET_SHEET_CALENDAR |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > Find_Data > FindData_YieldMonitoring > SetSpreadInit > GetSpdTitle2 | 799 | SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 43 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH | 10 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_LINE_HIERARCHY_V_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_LINE_HIERARCHY_CPS_V_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_OPERATION_SN |
| SCP.SCP0052_GET_CAPA_REPORT | MATCH | 2 | SP SCP0052_GET_CAPA_REPORT | EXEC:SCP0052_GET_CAPA_REPORT, INSERT:#TMP_SCP0052_LOOKUP, SELECT:SCM_SYS_LOOKUP_VALUE_SN, CREATE:#TMP_SCP0052_ADD_STD, CREATE:#TMP_SCP0052_MM, CREATE:#TMP_SCP0052_LTY_MM, CREATE:#TMP_SCP0052_ALL, INSERT:#TMP_SCP0052_DAY_OF_MONTH, SELECT:SCM_SYS_CALENDAR_M, CREATE:#TMP_SCP0052_STD_SUM, CREATE:#TMP_SCP0052_STD_CAL, INSERT:#TMP_SCP0052_STD, SELECT:SCM_LINE_HIERARCHY_V_SN, REF:STRING_SPLIT, INSERT:#TMP_SCP0052_STD_ITEM, SELECT:#TMP_SCP0052_STD, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_ITEM_M_SN, INSERT:#TMP_SCP0052_STD_ITEM_TACT, SELECT:#TMP_SCP0052_STD_ITEM, INSERT:#TMP_SCP0052_STD_ITEM_YIELD, INSERT:#TMP_SCP0052_MM, SELECT:#TMP_SCP0052_LOOKUP, SELECT:SCM_WORK_CALENDAR_M_SN, SELECT:SCM_LOSS_M_SN, INSERT:#TMP_SCP0052_LTY_MM, SELECT:SCM_MST_TACT_TIME_SN, SELECT:#TMP_SCP0052_STD_ITEM_TACT, SELECT:SCM_MST_YIELD_SN, SELECT:#TMP_SCP0052_STD_ITEM_YIELD, SELECT:SCM_ITEM_LINE_ASSIGN_VER_H_SN, SELECT:SCM_TACT_TIME_VER_H_SN, SELECT:SCM_YIELD_VER_H_SN, INSERT:#TMP_SCP0052_STD_SUM, SELECT:#TMP_SCP0052_MM, INSERT:#TMP_SCP0052_STD_CAL, SELECT:#TMP_SCP0052_STD_SUM, SELECT:#TMP_SCP0052_DAY_OF_MONTH, SELECT:#TMP_SCP0052_STD_CAL, INSERT:#TMP_SCP0052_ADD_STD, INSERT:#TMP_SCP0052_ALL, SELECT:#TMP_SCP0052_ADD_STD, SELECT:SCM_LOSS_REPORT_VER_H_SN, SELECT:#TMP_SCP0052_LTY_MM, INSERT:#TMP_SCP0052_RESULT, SELECT:#TMP_SCP0052_ALL, DYNAMIC@SCP0052_GET_CAPA_REPORT |  |
| SCP.SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | MATCH | 2 | SP SCP0052_GET_CAPA_REPORT_TOTAL_YIELD | EXEC:SCP0052_GET_CAPA_REPORT_TOTAL_YIELD, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, CREATE:#TMP_SCP0052_TARGET_ITEM, CREATE:#TMP_SCP0052_MODEL_COMP, CREATE:#TMP_SCP0052_MODEL_ITEM_LINE, CREATE:#TMP_SCP0052_ITEM_LINE_YIELD, CREATE:#TMP_SCP0052_MODEL_ITEM_LINE_OP_MIN_YIELD, INSERT:#TMP_SCP0052_TARGET_ITEM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, INSERT:#TMP_SCP0052_MODEL_COMP, SELECT:SCM_MST_BOM_SN, SELECT:SCM_FACTORY_M_SN, INSERT:#TMP_SCP0052_MODEL_ITEM_LINE, SELECT:#TMP_SCP0052_TARGET_ITEM, SELECT:#TMP_SCP0052_MODEL_COMP, INSERT:#TMP_SCP0052_ITEM_LINE_YIELD, SELECT:#TMP_SCP0052_MODEL_ITEM_LINE, SELECT:SCM_MST_YIELD_SN, INSERT:#TMP_SCP0052_MODEL_ITEM_LINE_OP_MIN_YIELD, SELECT:#TMP_SCP0052_ITEM_LINE_YIELD, INSERT:#TMP_SCP0052_TOTAL_YIELD_RESULT, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:#TMP_SCP0052_MODEL_ITEM_LINE_OP_MIN_YIELD, DYNAMIC@SCP0052_GET_CAPA_REPORT_TOTAL_YIELD |  |
| SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | MATCH | 2 | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING | EXEC:SCP0052_GET_CAPA_REPORT_YIELD_MONITORING, INSERT:#TMP_SCP0049_YIELD_DATA, SELECT:SCM_MST_YIELD_SN, REF:STRING_SPLIT, SELECT:HIST_SCM_YIELD_M_SN, INSERT:#TMP_SCP0049_LINE_ASSIGN_DATA, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:HIST_SCM_ITEM_LINE_ASSIGN_M_SN, INSERT:#TMP_SCP0049_TARGET_ITEM, SELECT:AA, SELECT:#TMP_SCP0049_YIELD_DATA, SELECT:SCM_DIVISION_M_SN, SELECT:SCM_PLANT_M_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:SCM_DNM_DAILY_PRODUCT_RESULT_SN, SELECT:#TMP_SCP0049_LINE_ASSIGN_DATA, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@SCP0052_GET_CAPA_REPORT_YIELD_MONITORING |  |
| SCP.SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | MATCH | 2 | SP SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL | EXEC:SCP0052_GET_CAPA_REPORT_YIELD_MONITORING_DETAIL, INSERT:#TMP_SCP0052_YIELD_DETAIL, SELECT:SCM_MST_YIELD_SN, REF:STRING_SPLIT, SELECT:HIST_SCM_YIELD_M_SN, INSERT:#TMP_SCP0052_LINE_ASSIGN_DETAIL, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:HIST_SCM_ITEM_LINE_ASSIGN_M_SN, SELECT:AA, SELECT:#TMP_SCP0052_YIELD_DETAIL, SELECT:SCM_DIVISION_M_SN, SELECT:SCM_PLANT_M_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:SCM_MASTER_MANAGER_M_SN, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_DNM_DAILY_PRODUCT_RESULT_SN, SELECT:#TMP_SCP0052_LINE_ASSIGN_DETAIL |  |
| SCP.SCP0052_GET_DAY_RANGE | MATCH | 2 | SP SCP0052_GET_DAY_RANGE | EXEC:SCP0052_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0052_GET_SHEET_CALENDAR | MATCH | 2 | SP SCP0052_GET_SHEET_CALENDAR | EXEC:SCP0052_GET_SHEET_CALENDAR, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | MATCH | 2 | SP SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING | EXEC:SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING, SELECT:AA, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_SHEET_COLUMNS |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| ClbGroup_SelectedIndexChanged | drCurrentRow | CODE, NAME |
| FindData | row | SIGNAL |
| InitControls | dataRow | CODE, NAME, SORT_ORDER |
| InitControls | dr | CODE, NAME |
| InitControls | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SetChangedControl | drCurrentRow | CODE, NAME |
| SetPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:112, SetSpreadInit:336, SetSpreadInit:344 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | SetChangedControl:254, SetChangedControl:258, SetChangedControl:263, SetChangedControl:268, SetChangedControl:273, FindData_History:441, FindData_History:457, FindData_History:458 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | SetSpreadInit:316 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| InitSpreadDateColumn | SetSpreadInit:345 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | SCP0052_CAPAReportYieldMonitoringPopup_Load | InitializeComponent:100 |
| this | Load | Form_Load | .ctor:74 |
| this | Load | Form_Load | .ctor:134 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:135 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:353 |
| cboGroup | SelectedIndexChanged | ClbGroup_SelectedIndexChanged | InitEvent:354 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:355 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:356 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:357 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:359 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:360 |
| txtModelId | KeyDown | TxtModelId_KeyDown | InitEvent:362 |
| txtMaterialId | KeyDown | TxtMaterialId_KeyDown | InitEvent:363 |
| txtNickName | KeyDown | TxtNickName_KeyDown | InitEvent:364 |
| cboDivision1 | SelectedIndexChanged | CboDivision1_SelectedIndexChanged | InitEvent:366 |
| cboGroup1 | SelectedIndexChanged | CboGroup1_SelectedIndexChanged | InitEvent:367 |
| drpPeriodMonth | ValueChanged | drpPeriodMonth_ValueChanged | InitEvent:369 |
| this | Load | SCP0052_CAPAReportYieldMonitoringPopup_Load | InitializeComponent:100 |
| this | Load | Form_Load | .ctor:74 |
| this | Load | Form_Load | .ctor:135 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:136 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:353 |
| cboGroup | SelectedIndexChanged | ClbGroup_SelectedIndexChanged | InitEvent:354 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:355 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:356 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:357 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:359 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:360 |
| txtModelId | KeyDown | TxtModelId_KeyDown | InitEvent:362 |
| txtMaterialId | KeyDown | TxtMaterialId_KeyDown | InitEvent:363 |
| txtNickName | KeyDown | TxtNickName_KeyDown | InitEvent:364 |
| cboDivision1 | SelectedIndexChanged | CboDivision1_SelectedIndexChanged | InitEvent:366 |
| cboGroup1 | SelectedIndexChanged | CboGroup1_SelectedIndexChanged | InitEvent:367 |
| drpPeriodMonth | ValueChanged | drpPeriodMonth_ValueChanged | InitEvent:369 |

## 6. 컨트롤 (118개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 42 | layoutDivision, layoutDivision1, layoutModel, layoutMaterial, layoutNickName, layoutBtnColumn, layoutPeriodMonth, layoutChkLoss, layoutChkLineAssign, layoutChkTactTime, layoutVersionId, layoutChkYield, layoutPlant, layoutPlant1, layoutBuilding … |
| UsrCheckedList2 | 14 | cboGroup1, clbOperation, clbLine, clbBuilding, clbPlant, clbPlant1, cboDivision1, cboGroup1, clbOperation, clbLine, clbBuilding, clbPlant, clbPlant1, cboDivision1 |
| EmptySpaceItem | 14 | emptySpaceItem4, emptySpaceItem3, emptySpaceItem9, emptySpaceItem1, emptySpaceItem5, emptySpaceItem2, emptySpaceItem6, emptySpaceItem4, emptySpaceItem3, emptySpaceItem9, emptySpaceItem1, emptySpaceItem5, emptySpaceItem2, emptySpaceItem6 |
| UsrCheckBox | 12 | checkYield, checkTactTime, checkLineAssign, checkLoss, checkProduction, checkAccuracy, checkYield, checkTactTime, checkLineAssign, checkLoss, checkProduction, checkAccuracy |
| UsrMultiLineEditor | 6 | txtNickName, txtMaterialId, txtModelId, txtNickName, txtMaterialId, txtModelId |
| FpSpread | 4 | spdMain, spdMain, spdMain, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 4 | cboGroup, cboDivision, cboGroup, cboDivision |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList | 2 | clbVersionId, clbVersionId |
| UsrMonthRangePicker | 2 | drpPeriodMonth, drpPeriodMonth |
| UsrButton | 2 | btnColumn, btnColumn |
| ImageList | 2 | imageList1, imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 60 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 58 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 14 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 44 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0052 | CAPA History | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |
| SCM_MST_SHEET_COLUMNS | SCP0052 | Total Yield(Assembly) | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_COLUMNS | SCP0052 | Yield Monitoring | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 | 4/5 |
| SCM_MST_SHEET_COLUMNS | SCP0052 | Yield Monitoring Detail | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Yield Monitoring Detail, CAPA History, Total Yield(Assembly), Yield Monitoring
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:112, SetSheetHeaderColumn@SetSpreadInit:336, SetSheetHeaderColumn@SetSpreadInit:344
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn2, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 788 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.COLUMN_LABEL_NAME]} | {?dr[DefColumnsTitle.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 842 | DB루프 | AddNumColumn | {?dr[DefColumnsTitle.G_LABEL]} | {?dr[DefColumnsTitle.G_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 843 | DB루프 | AddNumColumn | {?dr[DefColumnsTitle.Y_LABEL]} | {?dr[DefColumnsTitle.Y_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 844 | DB루프 | AddNumColumn | {?dr[DefColumnsTitle.R_LABEL]} | {?dr[DefColumnsTitle.R_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 845 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.A_LABEL]} | {?dr[DefColumnsTitle.A_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 866 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.A_LABEL]} | {?dr[DefColumnsTitle.A_COL]} | else!(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 876 | 하드코딩 | AddNumColumnEx | Accuracy(%) | ACCURACY |  |
| InitializeComponent |  | 1399 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1400 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1401 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1402 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 65 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 66 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 65 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 66 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 67 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpreadDateColumn |  | 788 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.COLUMN_LABEL_NAME]} | {?dr[DefColumnsTitle.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 842 | DB루프 | AddNumColumn | {?dr[DefColumnsTitle.G_LABEL]} | {?dr[DefColumnsTitle.G_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 843 | DB루프 | AddNumColumn | {?dr[DefColumnsTitle.Y_LABEL]} | {?dr[DefColumnsTitle.Y_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 844 | DB루프 | AddNumColumn | {?dr[DefColumnsTitle.R_LABEL]} | {?dr[DefColumnsTitle.R_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 845 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.A_LABEL]} | {?dr[DefColumnsTitle.A_COL]} | if(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 866 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.A_LABEL]} | {?dr[DefColumnsTitle.A_COL]} | else!(pCheckAccuracy.Equals("N")) ⟫ foreach(dr in dsSpdTitle2.Tables[0].Rows) |
| InitSpreadDateColumn2 |  | 876 | 하드코딩 | AddNumColumnEx | Accuracy(%) | ACCURACY |  |
| InitializeComponent |  | 1399 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1400 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1401 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1402 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CAPA History | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |
| Total Yield(Assembly) | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Yield Monitoring | META+코드연결 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Yield Monitoring Detail | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
