# SCP0113 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 84 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermProcessPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 4054 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermProcessPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 1541 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 3214 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 1071 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmtViewPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 869 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmtViewPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0113_LongTermStockMgmt\SCP0113_LongTermStockMgmt.csproj | 119 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > SetMonthRange > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| event:cboPlanDate.SelectedIndexChanged | CboPlanDate_SelectedIndexChanged > SetMonthRange > GetQtyInputPeriod | 2539 | SCP.SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD | MATCH | SP SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD |
| button:EditButton | EditButton > CheckEditPeriod > GetEditPeriod | 2521 | SCP.SCP0113_GET_LGTM_PLAN_EDIT_PERIOD | MATCH | SP SCP0113_GET_LGTM_PLAN_EDIT_PERIOD |
| button:EditButton | EditButton > ChangeEditCell > GetItemTypeQTYInputException | 2558 | SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | MATCH | SP SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION |
| button:ExcelButton | ExcelButton > ExportExcelData > CreateComboboxCellType > GetComboBoxMasterData | 705 | SCP.SCP0084_GET_COMBOBOX_DATA | MATCH | SP SCP0084_GET_COMBOBOX_DATA |
| button:ExcelButton | ExcelButton > ExportExcelData > CreateComboboxCellType > GetComboBoxMasterData | 999 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA |
| button:ExcelButton | ExcelButton > ExportExcelData > CreateComboboxCellType > GetComboBoxMasterData | 1012 | SCP.SCP0084_GET_COMBOBOX_DATA | MATCH | SP SCP0084_GET_COMBOBOX_DATA |
| button:FindButton | FindButton > FindData | 673 | SCP.SCP0113_GET_LGTM_DETAIL_FOR_EXPORT | MATCH | SP SCP0113_GET_LGTM_DETAIL_FOR_EXPORT |
| button:FindButton | FindButton > Find_Data | 709 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN |
| button:FindButton | FindButton > FindData > InitSpread > InitSpreadDateColumn > GetBaseMonth | 844 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| button:FindButton | FindButton > Find_Data > InitSpread > InitSpreadDateColumn > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| button:FindButton | FindButton > Find_Data > GetItemTypeQTYInputException | 2558 | SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | MATCH | SP SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION |
| button:SaveButton | SaveButton > SaveData > Find_Data | 709 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN |
| button:SaveButton | SaveButton > SaveData > SaveDataReason | 1237 | SCP.SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN | MATCH | SP SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN |
| button:SaveButton | SaveButton > SaveData > Find_Data > InitSpread > InitSpreadDateColumn > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| button:SaveButton | SaveButton > SaveData > Find_Data > GetItemTypeQTYInputException | 2558 | SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | MATCH | SP SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > InitSpreadDateColumn > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| event:this.btnCreatePlan.Click | btnCreatePlan_ClickAsync | 3234 | SCP.PR_SCM_LGTM_MRP_P_RESULT | MATCH | SP PR_SCM_LGTM_MRP_P_RESULT |
| event:this.btnCreatePlan.Click | btnCreatePlan_ClickAsync | 3282 | SCP.PR_SCM_LGTM_INV_ALLOCATION_START | MATCH | SP PR_SCM_LGTM_INV_ALLOCATION_START |
| event:this.btnSearch.Click | btnSearch_Click > Check_Exec_IsRunningEngine > Insert_Is_Running_Release | 2188 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| event:this.btnSearch.Click | btnSearch_Click > Check_Exec_IsRunningEngine > Delete_Is_Running_Release | 2259 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| event:this.btnSearch.Click | btnSearch_Click | 3395 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| event:this.btnSearch.Click | btnSearch_Click > Check_Exec_IsRunningEngine | 3454 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| event:this.Load | Form_Load > InitControls > GetPlanDateComboBox | 293 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE |
| event:this.Load | Form_Load > InitControls > GetMrpVersionComboBox | 303 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION |
| event:this.Load | Form_Load > FindData | 673 | SCP.SCP0113_GET_LGTM_DETAIL_FOR_EXPORT | MATCH | SP SCP0113_GET_LGTM_DETAIL_FOR_EXPORT |
| event:this.Load | Form_Load > LoadMasterData > GetComboBoxMasterData | 705 | SCP.SCP0084_GET_COMBOBOX_DATA | MATCH | SP SCP0084_GET_COMBOBOX_DATA |
| event:this.Load | Form_Load > FindData > InitSpread > InitSpreadDateColumn > GetBaseMonth | 844 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| event:this.Load | Form_Load > InitControls > GetComboBoxMasterData | 999 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA |
| event:this.Load | Form_Load > InitControls > GetComboBoxMasterData | 1012 | SCP.SCP0084_GET_COMBOBOX_DATA | MATCH | SP SCP0084_GET_COMBOBOX_DATA |
| event:this.Load | Form_Load > InitControls > GetPlanDateComboBox | 2313 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > InitSpreadDateColumn > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| event:this.Load | Form_Load > InitControls > SetMonthRange > GetQtyInputPeriod | 2539 | SCP.SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD | MATCH | SP SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD |
| event:this.Load | Form_Load > LoadMasterData > GetItemTypeQTYInputException | 2558 | SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | MATCH | SP SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail1 | 781 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail2 | 832 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail3 | 885 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Detail3 > InitSpread > InitSpreadDateColumn > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| event:this.spdMain.Change | spdMain_Change > ChangeEditCell > GetItemTypeQTYInputException | 2558 | SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | MATCH | SP SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION |
| event:this.spdMain.LeaveCell | spdMain_LeaveCell > ChangeEditCell > GetItemTypeQTYInputException | 2558 | SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | MATCH | SP SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION |
| event:this.spdSub.CellDoubleClick | spdSub_CellDoubleClick > FindData_Detail1 | 781 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL |
| event:this.spdSub.CellDoubleClick | spdSub_CellDoubleClick > FindData_Detail2 | 832 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL |
| event:this.spdSub.CellDoubleClick | spdSub_CellDoubleClick > FindData_Detail3 | 885 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL |
| event:this.spdSub.CellDoubleClick | spdSub_CellDoubleClick > FindData_Detail3 > InitSpread > InitSpreadDateColumn > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_Detail1 | 781 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_Detail2 | 832 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_Detail3 | 885 | SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL | MATCH | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL |
| event:this.spdSub.SheetTabClick | spdSub_SheetTabClick > FindData_Detail3 > InitSpread > InitSpreadDateColumn > GetBaseMonth | 2334 | SCP.SCP0113_GET_BASE_MONTH | MATCH | SP SCP0113_GET_BASE_MONTH |
| unreached:(진입점 미연결) | Find_Data_Sub | 514 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Save_Release | 568 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Save_Release | 639 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Save_Release | 654 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Save_Release | 725 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | GetMonthRange | 1038 | SCP.SCP0084_GET_MONTH_RANGE | MATCH | SP SCP0084_GET_MONTH_RANGE |
| unreached:(진입점 미연결) | Exec_Release_Queue | 1113 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Find_Duplicate_Check | 1396 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Execute_Calcuration | 1448 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Update_DivisionList | 1524 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_Release_Plan | 1599 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Exec_Release_Plan | 1628 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_Send_Mail_Quantity_Check | 1691 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Find_Release_Valid | 1741 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Find_Release_Valid | 1777 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_RollBack_Release | 1866 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Update_Release_Flag | 1952 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Update_Release_PlanList_2 | 2047 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Save_Data_Import | 2115 | SCP.SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN | MATCH | SP SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN |
| unreached:(진입점 미연결) | Find_Release_Plan_List_2 | 2117 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Find_Confirm_Valid | 2306 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Find_Confirm_Valid | 2340 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_SendMail_FinalTotal | 2411 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Insert_Hist_Detail | 2479 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_Send_SMS | 2547 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Exec_Send_SMS | 2568 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_MES_ERP_WO_MASTER | 2641 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Exec_MES_ERP_WO_MASTER | 2659 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Insert_OT_NET_JOB | 2720 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Insert_OT_NET_JOB | 2741 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_PR_SCM_OF_ASSY_ELEC_REPORT | 2806 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_PR_SCM_OF_PACK_REQUIRE_CEL | 2868 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_PR_SCM_OF_PACK_TO_CELL | 2937 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Exec_PR_SCM_OF_PACK_TO_CELL | 2957 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_PR_SCM_OF_CELL_DELIVERY_PLAN | 3024 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Exec_PR_SCM_PIC_ALARM | 3093 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Exec_PR_SCM_PIC_ALARM | 3113 | FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE |
| unreached:(진입점 미연결) | Check_isConfirmed | 3572 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Check_CapaValidation | 3690 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Check_CapaValidation | 3700 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | Check_IsPastDate | 3740 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |
| unreached:(진입점 미연결) | RunSqlSource | 3815 | SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| FP_Planning.PR_UI_FP00590_PLAN_CONTROL_RELEASE | MATCH | 23 | SP PR_UI_FP00590_PLAN_CONTROL_RELEASE | EXEC:PR_UI_FP00590_PLAN_CONTROL_RELEASE | ⚠ DB에 SP 없음 |
| SCP.PR_SCM_LGTM_INV_ALLOCATION_START | MATCH | 1 | SP PR_SCM_LGTM_INV_ALLOCATION_START | EXEC:PR_SCM_LGTM_INV_ALLOCATION_START, EXEC:PR_SCM_SYS_LOG_BATCH, UPDATE:XIF_MRP_TB_RS_ITEM_CONSUM_R_SN, REF:STRING_SPLIT, EXEC:PR_SCM_LGTM_INV_ALLOCATION, EXEC:PR_SCM_LGTM_INV_ALLOCATION_CAL, EXEC:PR_SCM_LGTM_INV_ALLOCATION_SPRD, EXEC:PR_SCM_LGTM_INV_ALLOCATION_SPRD_CAL, EXEC:PR_SCM_LGTM_INV_ALLOCATION_GODS, EXEC:PR_SCM_LGTM_INV_ALLOCATION_GODS_CAL, EXEC:PR_SCM_LGTM_INV_ALLOCATION_RMTL, EXEC:PR_SCM_LGTM_INV_ALLOCATION_RMTL_CAL, EXEC:PR_SCM_LGTM_INV_ALLOCATION_PLAN_COPY, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, DELETE:SCM_LGTM_INV_PSI_SUMMARY, DELETE:SCM_LGTM_INV_PSI_DETAIL, INSERT:#TEMP_PROD_PLAN, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:VERSION_INFO, SELECT:SCM_MST_SITE, SELECT:SCM_DNM_DAILY_PRODUCT_RESULT_SN, SELECT:SCM_DNM_SCS_PROD_RESULT, REF:FN_ZERO_LPAD, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_PLAN_DETAIL, INSERT:SCM_LGTM_INV_PSI_SUMMARY, SELECT:#TEMP_PROD_PLAN, SELECT:SCM_MST_BOM_SN, SELECT:SCP_ANL_PSI_INTEGRATION, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ALTER_BOM, SELECT:SCM_MST_BOM_ENG_SN, REF:FN_NEXT_DAY, SELECT:SCM_MST_BOM_EFFECTIVE_SN, SELECT:SCP_ANL_LONG_TERM_STOCK, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:SCM_PLANT_M_SN, SELECT:SCP_ANL_MONTH_END_STOCK_R, SELECT:SCP_ANL_LGTM_INV_MGMT_PLAN, UPDATE:SCM_LGTM_INV_PSI_SUMMARY, SELECT:SCM_LGTM_INV_PSI_SUMMARY, SELECT:SCP_MST_FORMATION, UPDATE:SUM, INSERT:#TMP_LONG_TERM_TYPE, SELECT:SCM_ADM_LOOKUP_MASTER, INSERT:SCM_LGTM_INV_PSI_DETAIL, SELECT:SYSCURSORS, SELECT:SCM_LGTM_INV_PSI_DETAIL, UPDATE:SCM_LGTM_INV_PSI_DETAIL, UPDATE:A, SELECT:#TMP_LONG_TERM_TYPE, SELECT:SCP_MST_FINAL_ITEM, INSERT:#TEMP_END_INV_COST, SELECT:AMDAU_CELL, UPDATE:S, SELECT:#TEMP_END_INV_COST, SELECT:DM_MST_VERSION, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.PR_SCM_LGTM_MRP_P_RESULT | MATCH | 1 | SP PR_SCM_LGTM_MRP_P_RESULT | EXEC:PR_SCM_LGTM_MRP_P_RESULT, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:SCM_LGTM_MRP_P_RESULT, INSERT:#TEMP_MRP_PLAN, SELECT:XIF_MRP_BPS_MAT_PLAN_R_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:XIF_MRP_PO_WHIN_RESULT_R_SN, INSERT:#TEMP_INTRANSIT_QTY, SELECT:SCP_ANL_MONTH_END_STOCK_R, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:#TEMP_MRP_PLAN, INSERT:SCM_LGTM_MRP_P_RESULT, SELECT:#TEMP_INTRANSIT_QTY, SELECT:SCM_MST_SITE, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0084_GET_COMBOBOX_DATA | MATCH | 2 | SP SCP0084_GET_COMBOBOX_DATA | EXEC:SCP0084_GET_COMBOBOX_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0084_GET_MONTH_RANGE | MATCH | 1 | SP SCP0084_GET_MONTH_RANGE | EXEC:SCP0084_GET_MONTH_RANGE, SELECT:SCP_ANL_LONG_TERM_STOCK |  |
| SCP.SCP0113_GET_BASE_MONTH | MATCH | 2 | SP SCP0113_GET_BASE_MONTH | EXEC:SCP0113_GET_BASE_MONTH, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_LGTM_INV_PSI_SUMMARY, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LGTM_DETAIL_FOR_EXPORT | MATCH | 1 | SP SCP0113_GET_LGTM_DETAIL_FOR_EXPORT | EXEC:SCP0113_GET_LGTM_DETAIL_FOR_EXPORT, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_LGTM_INV_PSI_SUMMARY, REF:STRING_SPLIT, SELECT:SCM_LGTM_INV_PSI_SUMMARY_SPRD, SELECT:SCM_LGTM_INV_PSI_SUMMARY_RMTL, SELECT:SCM_LGTM_INV_PSI_SUMMARY_GODS, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | MATCH | 1 | SP SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION | EXEC:SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD | MATCH | 1 | SP SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD | EXEC:SCP0113_GET_LGTM_MONTHLY_QTY_INPUT_PERIOD, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LGTM_PLAN_EDIT_PERIOD | MATCH | 1 | SP SCP0113_GET_LGTM_PLAN_EDIT_PERIOD | EXEC:SCP0113_GET_LGTM_PLAN_EDIT_PERIOD, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LGTM_PLAN_STATUS_DATA | MATCH | 21 | SP SCP0113_GET_LGTM_PLAN_STATUS_DATA | EXEC:SCP0113_GET_LGTM_PLAN_STATUS_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_LGTM_INV_PSI_SUMMARY, REF:STRING_SPLIT, SELECT:SCM_LGTM_INV_PSI_SUMMARY_SPRD, SELECT:SCM_LGTM_INV_PSI_SUMMARY_GODS, SELECT:SCM_LGTM_INV_PSI_SUMMARY_RMTL, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL | MATCH | 1 | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL | EXEC:SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_DETAIL, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#W_CELL_CF, SELECT:SCP_MST_ITEM_CELL_CF, INSERT:#W_CELL_CF_BOM, SELECT:SCM_MODEL_COMP_TEMP_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_CLASS_SN, INSERT:#W_SI, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_CLASS_M, INSERT:#TMP_LAST, SELECT:#W_CELL_CF, SELECT:SCP_MST_FINAL_ITEM, SELECT:#W_CELL_CF_BOM, SELECT:W_SITE_LIST, SELECT:SCP_ANL_MONTH_END_STOCK_R, SELECT:#W_SI, REF:STRING_SPLIT, SELECT:W_ITEM_EE, SELECT:W_CELL_ASSY_SI, SELECT:SCM_PLANT_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, SELECT:W_SCP_MST_CELL_PROD_ASSY_MAP, SELECT:#TMP_LAST, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL | MATCH | 1 | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL | EXEC:SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_BOH_ENDING_DETAIL, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:W_CELL_CF_BOM, SELECT:SCP_ANL_LONG_TERM_STOCK, SELECT:SCM_PLANT_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_ITEM_CLASS_M, SELECT:W_CELL_CF, SELECT:SCP_MST_PIC_INFO, SELECT:SCP_MST_NO_USE_3M, REF:STRING_SPLIT, SELECT:SCP_MST_ITEM_CELL_CF, SELECT:SCM_MODEL_COMP_TEMP_SN, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_ITEM_CLASS_SN, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA | MATCH | 1 | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA | EXEC:SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MASTER_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION | MATCH | 1 | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION | EXEC:SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_MRP_VERSION, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:XIF_MRP_TB_RS_ITEM_CONSUM_R_SN, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN | MATCH | 1 | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN | EXEC:SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN, CREATE:#RESULTTABLE, INSERT:#RESULTTABLE, EXEC:SCP0113_GET_BASE_MONTH, CREATE:#STDTEMPTABLE, INSERT:#STDTEMPTABLE, EXEC:SCP0113_GET_LGTM_PLAN_MAIN_DATA_FOR_N, SELECT:#RESULTTABLE, SELECT:MONTHLIST, INSERT:#TEMP_INV_MGMT_PLAN, SELECT:SCP_ANL_LGTM_PCY_INV_MGMT_PLAN, SELECT:SCP_ANL_LGTM_INV_MGMT_PLAN, REF:STRING_SPLIT, INSERT:#TEMP_MGMT_PLAN_LAST_UPDATE, INSERT:#CUR, SELECT:SCP_ANL_LONG_TERM_STOCK, EXEC:SP_EXECUTESQL, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_LGTM_INV_PSI_SUMMARY, SELECT:RTF, SELECT:BASE, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:MIN_EXHT, SELECT:SCM_LGTM_INV_PSI_SUMMARY_SPRD, SELECT:SCM_MST_BOM_EFFECTIVE_SN, SELECT:GROUP_CD, SELECT:SCM_LGTM_INV_PSI_SUMMARY_RMTL, SELECT:SCP_MST_PIC_INFO, SELECT:SCM_LGTM_INV_PSI_SUMMARY_GODS, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE | MATCH | 2 | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE | EXEC:SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PLAN_DATE, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_LGTM_INV_PSI_SUMMARY, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL | MATCH | 1 | SP SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL | EXEC:SCP0113_GET_LONG_TERM_STOCK_INV_MGMT_PSI_DETAIL, EXEC:PR_SCM_SYS_LOG_BATCH, CREATE:#RESULTTABLE, INSERT:#RESULTTABLE, EXEC:SCP0113_GET_BASE_MONTH, SELECT:#RESULTTABLE, SELECT:MONTHLIST, EXEC:SP_EXECUTESQL, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_LGTM_INV_PSI_SUMMARY |  |
| SCP.SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN | MATCH | 2 | SP SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN | EXEC:SCP0113_SAVE_REASON_FOR_LONG_TERM_MGMT_PLAN, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_ANL_LGTM_INV_MGMT_PLAN, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnDownloadExcel_Click | Filter | p_plan_date, p_division_id, p_group_code, p_item_type, p_plant_id, p_item_id |
| ChangeEditCell | x | ITEM_TYPE, EXHT_TP_CD |
| Check_CapaValidation | dtInstance.Rows[0] | CAPA_VALIDATION, LIMIT_CAPA, CONFIRM_AREA |
| Check_CapaValidation | dtEndDate.Rows[0] | END_DATE |
| Check_isConfirmed | dtConfirm.Rows[i] | FACTORY_ID |
| Check_IsPastDate | dtPastdate.Rows[0] | DATE_VALID |
| CheckNullExcelValidation | x | ITEM_TYPE, EXHT_TP_CD |
| CheckNullSpreadValidation | x | ITEM_TYPE, EXHT_TP_CD |
| convertMasterDataToList | row | Code, Name |
| CreateSpread | Filter | p_division_id |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| Exec_MES_ERP_WO_MASTER | dtReleasePlanList.Rows[i] | RELEASE_PLAN_ID |
| Exec_PR_SCM_OF_PACK_TO_CELL | dtReleasePlanList.Rows[i] | INSTANCE_ID, RELEASE_PLAN_ID |
| Exec_PR_SCM_PIC_ALARM | dtTmp.Rows[0] | PIC_ALARM |
| Exec_PR_SCM_PIC_ALARM | dtReleasePlanList.Rows[i] | INSTANCE_ID, RELEASE_PLAN_ID |
| Exec_Release_Main | dtInstance.Rows[0] | INSTANCE_TYPE |
| Exec_Release_Plan | dRow | PLAN_ID, INSTANCE_ID, PLAN_TYPE |
| Exec_Release_Plan | dtResult.Rows[0] | PLAN_TYPE |
| Exec_Send_SMS | dtReleasePlanList.Rows[i] | FACTORY_ID, INSTANCE_ID, RELEASE_PLAN_ID |
| Find_Confirm_Valid | dtEndDate.Rows[0] | END_DATE |
| Find_Duplicate_Check | dtDuplication.Rows[0] | FACTORY_ID, RELEASE_START, RELEASE_STATUS |
| Find_Release_Valid | dtEndDate.Rows[0] | END_DATE |
| FindData | Filter | p_plan_date, p_division_id, p_group_code, p_item_type, p_item_id, p_plant_id |
| GetLabelNameByName | foundRows[0] | COLUMN_LABEL_NAME |
| InitControls | dataRow | CODE, NAME |
| InitSpread | Filter | p_plan_date |
| Insert_OT_NET_JOB | dtReleasePlanList.Rows[i] | INSTANCE_ID, RELEASE_PLAN_ID |
| Save_Release | dtControl.Rows[0] | RELEASE_LIMIT_YN |
| Save_Release | dtInstance.Rows[0] | RELEASE_QUEUE_FLAG, INSTANCE_TYPE, PACK_INHOUSE_OPTION |
| Save_Release | dtIsRunReleaseBySite.Rows[0] | USER_NAME, INSERT_ID |
| Save_Release | dtWaiting.Rows[0] | CNT_MATCHING, DELAY_TIME |
| Save_Release | Application.OpenForms | FP00590_ValidationPopup |
| Update_Release_PlanList_2 | dtReleasePlanList2.Rows[i] | INSTANCE_ID, PLAN_ID, FACTORY_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | SetSpreadInit:337, InitSpread:421, InitSpread:258 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | SetSpreadInit:338, InitSpread:422, InitSpread:259 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| GetCheckedListValue | btnCreatePlan_ClickAsync:3213, btnCreatePlan_ClickAsync:3214, btnCreatePlan_ClickAsync:3217, btnCreatePlan_ClickAsync:3263, SetCboDivisionChangedControl:3314, Check_Exec_IsRunningEngine:3450, CreateSpread:360, InitSpread:427 | CString.GetCheckedListValue | CODE |
| InitSpreadDateColumn | InitSpread:432, InitSpread:450, InitSpread:267 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| SetSheetHeaderColumn | InitSpread:438, InitSpreadDateColumn:515, InitSpreadDateColumn:519, InitSpreadDateColumn:295, InitSpreadDateColumn:299 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:589 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.usrRadio3 | CheckedChanged | usrRadio_CheckedChanged | InitializeComponent:219 |
| this.btnSearch | Click | btnSearch_Click | InitializeComponent:257 |
| this.usrRadio2 | CheckedChanged | usrRadio_CheckedChanged | InitializeComponent:311 |
| this.usrRadio1 | CheckedChanged | usrRadio_CheckedChanged | InitializeComponent:349 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:655 |
| this.btnCreatePlan | Click | btnCreatePlan_ClickAsync | InitializeComponent:1283 |
| this.chkStatus | CheckedChanged | chkStatus_CheckedChanged | InitializeComponent:1320 |
| this | FormClosing | SCP0113_LongTermProcessPopup_FormClosing | InitializeComponent:1439 |
| this | Load | Form_Load | .ctor:169 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:194 |
| timer | Elapsed | timer_Tick | InitEvent:196 |
| this.btnProcessLongTerm | Click | btnProcessLongTerm_Click | InitializeComponent:200 |
| this.btnDownloadExcel | Click | btnDownloadExcel_Click | InitializeComponent:237 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:524 |
| this.btnImport | Click | btnImport_Click | InitializeComponent:667 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:867 |
| this.spdMain | LeaveCell | spdMain_LeaveCell | InitializeComponent:868 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:869 |
| this.spdSub | SheetTabClick | spdSub_SheetTabClick | InitializeComponent:921 |
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:922 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:923 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:924 |
| this | Load | Form_Load | .ctor:255 |
| cboDivision | SelectedIndexChanged | CboDivision_SelectedIndexChanged | InitEvent:461 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitEvent:462 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitEvent:464 |
| this | Load | Form_Load | .ctor:161 |

## 6. 컨트롤 (97개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 37 | layout10, layoutControlItem23, layoutControlItem2, layoutControlItem7, layoutControlItem25, layoutControlItem11, layoutControlItem12, layoutControlItem1, layoutControlItem4, layoutControlItem5, layoutControlItem9, layoutControlItem10, layoutControlItem14, layoutControlItem15, layoutControlItem16 … |
| UsrButton | 7 | btnSearch, btnClose, btnCreatePlan, btnProcessLongTerm, btnDownloadExcel, btnColumn, btnImport |
| UsrLabel | 7 | usrLabel3, usrLabel10, usrLabel8, usrLabel5, usrLabel4, usrLabel1, lblBaseMonth |
| UsrCheckedList2 | 6 | clbItemType, clbPlant, cboDivision, clbPlant, cboDivision, clbItemType |
| UsrLayoutControl | 5 | usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2, usrLayoutControl4 |
| LayoutControlGroup | 5 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup3, layoutControlGroup2 |
| UsrCombo | 4 | cboMrpVersion, cboPlanDate, cboCreationType, cboPlanDate |
| FpSpread | 4 | spdMain, spdMain, spdSub, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdMain_Sheet1, sheetView1, spdMain_Sheet1 |
| UsrRadio | 3 | usrRadio3, usrRadio2, usrRadio1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel2, usrConditionPanel1 |
| ImageList | 2 | imageList1, imageList2 |
| UsrMonthPicker | 2 | monthPicker, monthPicker |
| EmptySpaceItem | 2 | emptySpaceItem7, emptySpaceItem1 |
| UsrMultiLineEditor | 2 | txtGroupCode, txtItemId |
| UsrDatePicker | 1 | drpPlanDate |
| Panel | 1 | StockPanel |
| UsrCheckBox | 1 | chkStatus |
| SplitContainer | 1 | splitContainer2 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 885 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 216 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_TITLESET_USER | 502 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 24 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2773 | SCP.SCP0049_GET_CAPA | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0113 | BOH Ending Inventory | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 | 51/0 |
| SCM_MST_SHEET_COLUMNS | SCP0113 | BOH Long-Term Stock | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 | 49/0 |
| SCM_MST_SHEET_COLUMNS | SCP0113 | EXPORT_POPUP | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |
| SCM_MST_SHEET_COLUMNS | SCP0113 | Long Term Stock Management | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 |
| SCM_MST_SHEET_COLUMNS | SCP0113 | PROCESS_POPUP | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | SCP0113 | PSI Detail | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: PROCESS_POPUP, Long Term Stock Management, BOH Ending Inventory, PSI Detail, BOH Long-Term Stock, EXPORT_POPUP
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@SetSpreadInit:338, CreateSheetHeaderColumn@InitSpread:422, SetSheetHeaderColumn@InitSpread:438, SetSheetHeaderColumn@InitSpreadDateColumn:515, SetSheetHeaderColumn@InitSpreadDateColumn:519, CreateSheetHeaderColumn@InitSpread:259, SetSheetHeaderColumn@InitSpreadDateColumn:295, SetSheetHeaderColumn@InitSpreadDateColumn:299
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| spdMain_CellClick |  | 3349 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value) == false) |
| spdMain_CellClick |  | 3354 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value) == false) |
| InitializeComponent |  | 1171 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1172 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1173 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1174 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread | Long Term Stock Management | 425 | 표시/라벨 변경 | set:RowCount | RowCount = 2 |  | if(spdInfo.SheetName == "Long Term Stock Management") |
| InitSpreadDateColumn |  | 529 | 하드코딩 | AddNumColumn | {?dtFrom.ToString(dateFormat)} | QTY_1 | while(dtFrom <= dtTo) |
| InitSpreadDateColumn |  | 536 | 표시/라벨 변경 | SetColumnHeader | 1 |  | while(dtFrom <= dtTo) ⟫ if(spdInfo.ActiveSheet.SheetName == "Long Term Stock Management") |
| InitSpreadDateColumn |  | 540 | 표시/라벨 변경 | SetColumnHeader | 0 |  | while(dtFrom <= dtTo) ⟫ else!(spdInfo.ActiveSheet.SheetName == "Long Term Stock Management") |
| InitSpreadDateColumn |  | 553 | 하드코딩 | AddTextColumn | Entered by | USER_ID | if(spdInfo.ActiveSheet.SheetName == "Long Term Stock Management") |
| InitSpreadDateColumn |  | 556 | 표시/라벨 변경 | SetColumnHeader | 0 | USER_ID | if(spdInfo.ActiveSheet.SheetName == "Long Term Stock Management") |
| InitSpreadDateColumn |  | 558 | 하드코딩 | AddDateTimeColumn | Date entered | UPDATE_DATE | if(spdInfo.ActiveSheet.SheetName == "Long Term Stock Management") |
| InitSpreadDateColumn |  | 561 | 표시/라벨 변경 | SetColumnHeader | 0 | UPDATE_DATE | if(spdInfo.ActiveSheet.SheetName == "Long Term Stock Management") |
| InitSpreadDateColumn |  | 569 | 하드코딩 | AddNumColumn | Total | TOTAL | if(spdInfo.ActiveSheet.SheetName == "PSI Detail") |
| InitSpreadDateColumn |  | 571 | 표시/라벨 변경 | SetColumnHeader | 0 |  | if(spdInfo.ActiveSheet.SheetName == "PSI Detail") |
| RenameColumnHearder |  | 952 | 표시/라벨 변경 | SetColumnHeader | 0 | QTY_1 | for(i <= 12) ⟫ if(inputMonth <= 12) ⟫ if(spdInfo.GetColumnIndex("QTY_" + i.ToString())> 0) |
| ExportExcelData |  | 1552 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelData |  | 1623 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 885 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 886 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 887 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 888 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 940 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 941 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 942 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 943 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| Form_Load |  | 171 | 표시/라벨 변경 | set:Width | Width = 56 |  |  |
| InitSpread | EXPORT_POPUP | 261 | 표시/라벨 변경 | set:RowCount | RowCount = 2 |  | if(spdInfo.SheetName == "EXPORT_POPUP") |
| ExportExcelData |  | 520 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcelData |  | 589 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 68 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 69 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 70 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 71 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| BOH Ending Inventory | META+코드연결 | 52 | 52 | 52 | 52 | 52 | 52 | 52 | 52 | 52 | 52 | 52 | 52 | 52 | 52 |
| BOH Long-Term Stock | META+코드연결 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 |
| EXPORT_POPUP | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |
| Long Term Stock Management | META+코드연결 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 | 49 |
| PROCESS_POPUP | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| PSI Detail | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
